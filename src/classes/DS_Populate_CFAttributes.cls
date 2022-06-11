/******************************************************************************************************
Name : DS_Populate_CFAttributes
Created Date: 18th June 2019
Created by: Accenture
Description : This class is used to Insert/Update records in Custmer facing Attributes Object from Quote/Proposal & CPO
*********************************************************************************************************/		   
global with sharing class DS_Populate_CFAttributes
{

/******************************************************************************************************
Name : CreateCFAforQuote
Created Date: 20th June 2018
Created by: Accenture
Description : This method is used to insert records in CFA for header attributes with Quote/Proposal details. 
			  Once the Quote record gets created from DS_JSONQuoteCreation, this method is invoked
Parameter : List<Sobject> hdrList, List<Apttus_Proposal__Proposal__c> quoteList
*********************************************************************************************************/
public static void createCFAforQuote(List<Sobject> hdrList,List<Apttus_Proposal__Proposal__c> quoteList)
{
 try
	{
		List<Customer_facing_Attribute__c> cfaList = new List<Customer_facing_Attribute__c>();
		Customer_facing_Attribute__c cfaRec = new Customer_facing_Attribute__c();
		If(!quoteList.isEmpty() && !hdrList.isEmpty())
		{
			for(Apttus_Proposal__Proposal__c qtRec : quoteList)
			{
			IF(qtRec.ID != null)
			{ 
			for(SObject hAttr : hdrList)
			{
			cfaRec = (Customer_facing_Attribute__c)hAttr;
			cfaRec.Attribute_indicator__c = CSWXGlobalConstant.header_indicator;
			cfaRec.Quote__c = qtRec.ID;
			//cfaRec.Account__c = qtRec.Apttus_Proposal__Account__c;
			cfaRec.DS_Staging__c = qtRec.DS_Staging__c;
			cfaList.add(cfaRec);
			}
			}
			}
			IF(!cfaList.isEmpty())
			{
			database.insert(cfaList);
			}
		}
	}
	catch(Exception ex)
	{
		ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_Populate_CFAttributes,CSWXGlobalConstant.createCFAforQuote);
	}
}


/******************************************************************************************************
Name : createCFAforConfigItem
Created Date: 24th June 2018
Created by: Accenture
Description : This method is used to insert records in CFA for Item attributes with Configuration Line item details. 
			  Once the Line item records gets created from DS_JSONQuoteCreation, this method is invoked
Parameter : map<Integer,List<Sobject>> cfaMap, List<Apttus_Proposal__Proposal__c> qpList
*********************************************************************************************************/
public static void createCFAforConfigItem(map<Integer,List<Sobject>> cfaMap, List<Apttus_Proposal__Proposal__c> qpList)
{
	try
	{
		List<Customer_facing_Attribute__c> cfaciRec = new List<Customer_facing_Attribute__c>();
		If(!qpList.isEmpty())
		{
			Set<String> qpID = new Set<String>();
		  For(Apttus_Proposal__Proposal__c qurec : qpList)
			{   
				If(qurec.Id!= null)
				{
				qpID.add(qurec.Id);
				}
			} 
			//qpID.addall(qurec.Id);
			List<Apttus_Config2__LineItem__c> ciRec = [Select Id,  AccountID__c, Apttus_Config2__LineNumber__c,
															  Apttus_Config2__ConfigurationId__c, 
															  Apttus_Config2__LineType__c,
															  Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c,
															  Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DS_Staging__c 
														from Apttus_Config2__LineItem__c  
														where Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c in :qpID
														LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];
			 System.debug('ciRec:'+ciRec);

			IF(!ciRec.isEmpty() && !cfaMap.isEmpty())
			{
				List<SObject> maptoList;
				Customer_facing_Attribute__c cfaItem;
				for(Apttus_Config2__LineItem__c  itemrec:ciRec)
				{
				If(itemrec.Apttus_Config2__LineType__c == CSWXGlobalConstant.ProductService )
				{
				Integer key = itemrec.Apttus_Config2__LineNumber__c.intvalue(); 
				maptoList = new List<SObject>(); 
				maptoList = cfaMap.get(key);
				for(Sobject DPIAttr : maptoList)
				{			   
				cfaItem = new Customer_facing_Attribute__c();
				cfaItem.Attribute_indicator__c = CSWXGlobalConstant.item_indicator;
				cfaItem.Attribute_Name__c = String.valueOf(DPIAttr.get(CSWXGlobalConstant.attributeName));  
				cfaItem.Attribute_Label__c  = String.valueOf(DPIAttr.get(CSWXGlobalConstant.attributeLabel));
				cfaItem.Attribute_Value__c = String.valueOf(DPIAttr.get(CSWXGlobalConstant.attributeValue));
				cfaItem.Attribute_Visibility__c = String.valueOf(DPIAttr.get(CSWXGlobalConstant.attributeVisibility));
				cfaItem.Configuration_Line_item__c = itemrec.ID;
				cfaItem.Quote__c= itemrec.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__c;
				//cfaItem.Account__c = itemrec.AccountID__c;
				cfaItem.DS_Staging__c = itemrec.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.DS_Staging__c;
				System.debug('cfaItem:'+cfaItem);
				cfaciRec.add(cfaItem);
				}   
				}
			}
			If(!cfaciRec.isEmpty())
			{
			database.insert(cfaciRec);
			}
			}
		}
	}
	catch(Exception ex)
	{
		ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_Populate_CFAttributes,CSWXGlobalConstant.createCFAforConfigItem);
	}
}
/******************************************************************************************************
Name : updateCFAforCPO
Created Date: 19th June 2018
Created by: Accenture
Description : This method is used to update records in CFA for Header & Item Attributes with CPO & CPO Item details. 
			  Once the CPO & CPO item records gets created & triggers DS_CPOHelper, this method is invoked
Parameter : List<Apttus_Config2__CustomerPurchaseOrder__c> cpoList, List<Apttus_Config2__CustomerPOItem__c> cpoitemlist
*********************************************************************************************************/
public static void updateCFAforCPO( List<Apttus_Config2__CustomerPurchaseOrder__c> cpoList, List<Apttus_Config2__CustomerPOItem__c> cpoitemlist)
{
try
{
	List<Customer_facing_Attribute__c> updatecfList = new List<Customer_facing_Attribute__c>();
	if(!cpoList.isEmpty())
	{
		Set<String> qtID = new Set<String>();
		For(Apttus_Config2__CustomerPurchaseOrder__c cporec : cpoList)
		{
			qtID.add(cporec.Apttus_QPConfig__ProposalId__c);
		} 

		List<Customer_facing_Attribute__c> cfList = [Select Id, CPO__c,CPO_item__c, Quote__c, Quote_Line_item__c 
											   from  Customer_facing_Attribute__c where Quote__c in :qtID
											   LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		
		If(!cfList.isEmpty())
		{
			for(Apttus_Config2__CustomerPurchaseOrder__c cpovar : cpoList)
			{
			IF(cpovar.ID != null && cpovar.Apttus_QPConfig__ProposalId__c != null)
			{
			for(Customer_facing_Attribute__c addCFA: cfList)
			{
			if(addCFA.Quote__c == cpovar.Apttus_QPConfig__ProposalId__c && addCFA.Quote_Line_item__c == null)
			{
			addCFA.CPO__c = cpovar.Id;
			updatecfList.add(addCFA);
			}
			}   
			}			   
		}
		
		IF(!CPOItemList.isEmpty())
		{
			for(Apttus_Config2__CustomerPOItem__c CPOItemvar : cpoitemlist)
			{
			IF(cpoitemvar.ID != null && cpoitemvar.Apttus_QPConfig__ProposalLineItemId__c != null)
			{
				for(Customer_facing_Attribute__c addCFA: cfList)
				{
				if(addCFA.Quote_Line_item__c == cpoitemvar.Apttus_QPConfig__ProposalLineItemId__c )
				{
				addCFA.CPO_item__c = cpoitemvar.ID;
				addCFA.CPO__c = cpoitemvar.Apttus_Config2__PurchaseOrderId__c;
				updatecfList.add(addCFA);			   
				}
				}
			}
			}
		}
		}
		If(!updatecfList.isEmpty())
		{
		database.update(updatecfList);
		}
	} 
}
catch(Exception ex)
	{
		ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_Populate_CFAttributes,CSWXGlobalConstant.updateCFAforCPO);
	}
} 
/*-----------Insert records in CFA for header attributes with Digital Proposal details----------*/
/*public static void CreateCFAforDP(List<Sobject> hdrList,List<SWx_Upsell_Proposal__c> DPList)
{
List<DS_Cust_facing_Attr__c> cfaList = new List<DS_Cust_facing_Attr__c>();
DS_Cust_facing_Attr__c cfaRec ;
System.debug('--------Start------'+DPList+'HDRList'+hdrList); 
If(!DPList.isEmpty() && !hdrList.isEmpty())
{
for(SWx_Upsell_Proposal__c DPRec : DPList)
{

IF(DPRec.ID != null)
{ 
for(SObject hAttr : hdrList)
{
cfaRec = = new DS_Cust_facing_Attr__c();
cfaRec = (DS_Cust_facing_Attr__c)hAttr;
cfaRec.Digital_Proposal__c = DPRec.ID;
cfaRec.Account__c = DPRec.Account_ID__c;
cfaRec.DS_Staging__c = DPRec.DS_Staging__c;
System.debug('cfaRec'+cfaRec);
cfaList.add(cfaRec);
}
}
}
System.debug('cfaList->'+cfaList);
IF(!cfaList.isEmpty())
Insert cfaList;
}
}*/
/*----------------Insert records in CFA for item attributes with Digital proposal line item details------------*/
/*public static void createCFAforDPItem( map<Integer,List<Sobject>> cfaMap, List<SWx_Upsell_Items__c> DPItemList, ID Account_ID,DS_Staging__c stagingObjRec)
{
List<DS_Cust_facing_Attr__c> CFADPItemLi = new List<DS_Cust_facing_Attr__c>();
DS_Cust_facing_Attr__c cfaItem = new DS_Cust_facing_Attr__c();
IF(!DPItemList.isEmpty() && !cfaMap.isEmpty())
{
for(SWx_Upsell_Items__c itemrec:DPItemList)
{
IF(itemrec.ID != null)
{
Integer key = itemrec.LineNumber__C.intvalue();
List<SObject> maptoList = cfaMap.get(key);
for(Sobject DPIAttr : maptoList)
{

System.debug('Account:'+ itemrec.SWx_Upsell_Proposal__r.Account_ID__c);
System.debug('Account:'+ itemrec.SWx_Upsell_Proposal__r.DS_Staging__c);
cfaItem = (DS_Cust_facing_Attr__c)DPIAttr;
cfaItem.SWx_Items__c = itemrec.ID;
cfaItem.Digital_proposal__c = itemrec.SWx_Upsell_Proposal__c;
cfaItem.Account__c = Account_ID;
cfaItem.DS_Staging__c = stagingObjRec.Id;
CFADPItemLi.add(cfaItem);
}
}
}
IF(!CFADPItemLi.isEmpty())
insert CFADPItemLi;
}
}
*/
/*----------------Update records in CFA for Header Attributes with Quote/Proposal details------------*/
/*public static void UpdateCFAforQuote( List<Apttus_Proposal__Proposal__c> proposalList)
{
List<DS_Cust_facing_Attr__c> updatecfList = new List<DS_Cust_facing_Attr__c>();
System.debug('Start----');
if(!proposalList.isEmpty()){
Set<String> DPId = new Set<String>();
For(Apttus_Proposal__Proposal__c qurec : proposalList)
{
DPId.add(qurec.SWx_Upsell_Proposal__c);
} 
System.debug('DPId:'+DPId);
List<DS_Cust_facing_Attr__c> cfList = [Select Id, Digital_Proposal__c, SWx_Items__c,Quote__c, Quote_Line_item__c 
									   from  DS_Cust_facing_Attr__c where Digital_proposal__c in :dpid 
									   LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
System.debug('cfList:'+cfList);
If(!cfList.isEmpty())
{
System.debug('PropList:'+ProposalList);  
for(Apttus_Proposal__Proposal__c propvar : proposalList){
IF(propvar.ID != null && propvar.SWx_Upsell_Proposal__c != null)
{
for(DS_Cust_facing_Attr__c addCFA: cfList)
{
if(addCFA.Digital_Proposal__c == propvar.SWx_Upsell_Proposal__c && addCFA.SWx_items__c == null)
{
addCFA.Quote__c = propvar.Id;
updatecfList.add(addCFA);
}
}   
}			   
}
System.debug('UpdatecfList:'+updatecfList);
update updatecfList;
}
}
}*/
/*---------Update records in CFA for Item Attributes with Proposal line Item details------------*/
/*public static void UpdateCFAforQuoteItem(List<Apttus_Proposal__Proposal__c> qpList)
{
If(!qpList.isEmpty())
{
Set<String> DPId = new Set<String>();
Set<String> qpID = new Set<String>();
Map<Id,Apttus_Proposal__Proposal_Line_Item__c> MapQtItem = new Map<Id,Apttus_Proposal__Proposal_Line_Item__c>();
For(Apttus_Proposal__Proposal__c qurec : qpList)
{   
If(qurec.SWx_Upsell_Proposal__c != null)
DPId.add(qurec.SWx_Upsell_Proposal__c);
If(qurec.Id!= null)
qpID.add(qurec.Id);
} 
If(!qpID.isEmpty())
{
List<Apttus_Proposal__Proposal_Line_Item__c> QPItem = [Select Id, Apttus_Proposal__Proposal__c, Apttus_Proposal__Proposal__r.SWx_Upsell_Proposal__c,
Apttus_Proposal__Product__c, Apttus_QPConfig__OptionId__c  from 
Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c in :qpID];
If(!QPItem.isEmpty() && !DPId.isEmpty())
{
List<DS_Cust_facing_Attr__c> cfList = [Select Id, Digital_Proposal__c, SWx_Items__c,Quote__c, Quote_Line_item__c from  DS_Cust_facing_Attr__c where Digital_proposal__c in :dpid ];	   
List<SWx_Upsell_Items__c> SwxItems = [Select ID, Sales_Item_Code__c,SWx_Upsell_Proposal__c from SWx_Upsell_Items__c where SWx_Upsell_Proposal__c in :DPId];
List<DS_Cust_facing_Attr__c> updatecfList = new List<DS_Cust_facing_Attr__c>();
DS_Cust_facing_Attr__c cfaItem = new DS_Cust_facing_Attr__c();
IF(!cfList.isEmpty() && !SwxItems.isEmpty())
{
for(Apttus_Proposal__Proposal_Line_Item__c itemrec:QPItem)
{
for(SWx_Upsell_Items__c DPitemrec:SwxItems)
{
If(itemrec.Apttus_Proposal__Proposal__r.SWx_Upsell_Proposal__c == DPitemrec.SWx_Upsell_Proposal__c && (DPitemrec.Sales_Item_Code__c == itemrec.Apttus_Proposal__Product__c || DPitemrec.Sales_Item_Code__c == itemrec.Apttus_QPConfig__OptionId__c))
{
If(!MapQtItem.containskey(DPitemrec.Id) )
MapQtItem.put(DPitemrec.Id, itemrec);

}
}
}
for(Id DPitemId:MapQtItem.keyset())
{
Apttus_Proposal__Proposal_Line_Item__c itemMaprec = MapQtItem.get(DPitemId);
for(DS_Cust_facing_Attr__c addCFA: cfList)
{
If(addCFA.SWx_Items__c == DPitemId)
{
addCFA.Quote_Line_item__c = itemMaprec.Id;
addCFA.Quote__c = itemMaprec.Apttus_Proposal__Proposal__c;
updatecfList.add(addCFA);
}
}
}
If(!updatecfList.isEmpty())
update updatecfList;
}
}
}
}
}
*/ 
}