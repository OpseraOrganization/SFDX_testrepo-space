/******************************************************************************************************
   Name : QTC_QuoteProposalToStaging
   Created Date: 20 August 2019
   Created by: Accenture
   Description : This class is for loading the data from proposal line item to Quote Staging object
 *********************************************************************************************************/
global with sharing class QTC_QuoteProposalToStaging implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful,Schedulable
{
Map<String,Integer> marketModelsLineNum = new Map<String,Integer>();
Map<String,Quote_Staging__c> marketModelWithStaging = new Map<String,Quote_Staging__c>();
Map<String,Integer> quoteLineNumMap = new Map<String,Integer>();
Map<String,Decimal> LineNumbersMap = new Map<String,Decimal>();
//Map<String,Decimal> CodeLineNumberMap = new Map<String,Decimal>();
Map<String,List<Quote_Delivery_Sales_Item__c> > arcadiaProductOptionMap = new Map<String,List<Quote_Delivery_Sales_Item__c> >();
Map<String,String> arcadiaProductCodeNameMap = new Map<String,String>();
Map<string,string> picklist_map = new Map<string,string>();
List<Quote_Parameter__c> q_paramap_list = new List<Quote_Parameter__c>();
Map<Id,Apttus_Proposal__Proposal__c> proposal_Map = new Map<Id,Apttus_Proposal__Proposal__c>();
Map<String,String> taskValuesMap = new Map<String,String>();
List<Quote_Staging__c> quoteStagingList = new List<Quote_Staging__c>();
// added by surinder
List<Quote_Staging__c> quoteStagingListForTxnRec = new List<Quote_Staging__c>();
Set<String> processedQuoteHeaders = new Set<String>();
Map<String,List<String> > parentChildNodeMap = new Map<String,List<String> >();
Map<String,Map<String,List<String> > > excludeMap = new Map<String,Map<String,List<String> > >();
Map<String,Decimal> parentBundleQuantityMap = new Map<String,Decimal>();
Map<String,List<Apttus_Proposal__Proposal_Line_Item__c> > marketModelMap = new Map<String,List<Apttus_Proposal__Proposal_Line_Item__c> >();
List<Maintenance_SSP_Product__c> sspList = new List<Maintenance_SSP_Product__c>();
Set<String> processedQuoteLineItems = new Set<String>();

//List<string> targetfields = new List<string>();
String QTEHEADER_BODY = '',QTELINEITEM_BODY;
String ADD_QTEHEADER_BODY,ADD_QTELINEITEM_BODY,Final_QTEHEADER_BODY,Final_QTELINEITEM_BODY;
//String TASK;

Schema.SObjectType proposalLineItemType = Schema.getGlobalDescribe().get(Globalconstants.Apttus_ProposalProposal_Line_Item);
Schema.SObjectType quoteDeliverySalesItemType = Schema.getGlobalDescribe().get(Globalconstants.Quote_Delivery_Sales_Item);
//// Added by Imran -- ITCCPQ-789
Decimal ExtendedePrice_CNP = 0;

/****************************************
 * Name : execute
 * Description : schedules the batch class by calling execute Method
 * Parameters: SchedulableContext
 *****************************************/
global void execute(SchedulableContext SC)
{

}


/****************************************
 * Name : QTC_QuoteProposalToStaging
 * Description : constructor used to get the quote proposals passed from trigger or lightning component
 * Parameters: Map<Id,Apttus_Proposal__Proposal__c>,TaskvaluesMap which has task and quotenumbers
 *****************************************/
public QTC_QuoteProposalToStaging(Set<Id> QuoteproposalId,Map<String,String> taskValuesMap)
{
	List<Quote_Parameter__c> parameter = new List<Quote_Parameter__c>( [Select id,Target_Field__c,Target_Object__c,
																		Source_Field__c,Source_Object__c,
																		Parameter_Value1__c,Parameter_Value2__c,Parameter_Type__c,Active__c
																		from Quote_Parameter__c
																		Where Parameter_Type__c = : GlobalConstants.Interface_String
																								  AND Target_Field__c = : GlobalConstants.Add_QuoteAddMessage
																	   ]);
	if(parameter[0].Active__c) {
		Map<Id,Apttus_Proposal__Proposal__c>  QuoteproposalMap = retreiveQuoteData(QuoteproposalId);
		system.debug('[+] QuoteproposalMap = '+QuoteproposalMap);
		this.proposal_Map = Quotefilter(QuoteproposalMap);
		system.debug('[+] proposal_Map = '+this.proposal_Map);
		this.taskValuesMap = taskValuesMap;
		if(!proposal_Map.isEmpty())
			deleteStaging(proposal_Map);
	}

}


/****************************************
 * Name : returnTypeOfField
 * Description : this method returns the data type of field for the geiven feld name
 * Parameters: sourceObject name,field name
 * Returns : returns the data type of field
 *****************************************/
public Schema.DisplayType returnTypeOfField(String sourceObject,String fieldName)
{
	Schema.SObjectType targetObjType = Schema.getGlobalDescribe().get(sourceObject);
	Schema.DescribeSObjectResult targetObjResult = targetObjType.getDescribe();
	Schema.DescribeFieldResult targetFieldResult = targetObjResult.fields.getMap().get(fieldName).getDescribe();
	return targetFieldResult.getType();
}

/****************************************
 * Name : returnSobject
 * Description : this method returns the generic sobject for the string object name given
 * Parameters: sourceObject name
 * Returns : returns the generic sObject
 *****************************************/
/*private Sobject returnSobject(String sourceObject)
   {
	Schema.SObjectType sourceObjectType = Schema.getGlobalDescribe().get(sourceObject);
	Sobject genericObject = sourceObjectType.newSObject();
	return genericObject;
   }*/

/****************************************
 * Name : getRootElementFromStaging
 * Description : this method returns the root element for the request data from quote staging
 * Parameters: sourceObject name
 * Returns : returns the generic sObject
 *****************************************/
@TestVisible
private Dom.Document getDomDocument(Quote_Staging__c quote_staging_Rec)
{
	Dom.Document docNode = new Dom.Document();
	String reqData = quote_staging_Rec.Request_Data__c;
	docNode.load(reqData);
	return docNode;
}

/****************************************
 * Name : checkValidCondition
 * Description : this method checks whether the parameter entry satisfies the condition mentioned
 * Parameters: field name, field value, source object
 * Returns : returns whether the condition satisfies or not
 *****************************************/
public Boolean checkForValidCondition(String fieldName, String value,sObject sourceObject)
{
	//system.debug('fieldName'+fieldName+' value'+value);
	try{
		if(fieldName <> null && fieldName.contains(Globalconstants.UNDERSCORE_R)) {
			if(value<> null && value.equalsIgnoreCase(getDataFromParent(fieldName,sourceObject))) {
				return true;
			}
		}
		else if(sourceObject.get(fieldName) <> null) {
			String sourceValue = String.valueOf(sourceObject.get(fieldName));
			if(sourceValue <> null && sourceValue.equalsIgnoreCase(value)) {
				return true;
			}
		}
		else if(value == GlobalConstants.NULLWORD ) {
			return (fieldName <> null && sourceObject.get(fieldName) == null ? true : false);
		}
	}catch(Exception ex) {
		ExceptionHandler.addException(ex,Globalconstants.QTC_QuoteProposalToStaging,Globalconstants.checkForValidCondition);
	}
	return false;
}

/****************************************
 * Name : start
 * Description : prepares the data
 * Parameters: Database.BatchableContext
 * Returns : List of urls for each staging object
 *****************************************/
global Iterable<sObject> start(Database.BatchableContext BC)
{
	Set<string> QPfield_set = new Set<string>();
	Set<string> quoteDeliverySIfield_Set = new Set<string>();
	//List<Quote_Parameter__c> q_para_list = new List<Quote_Parameter__c>();
	list<String> excludedProduts = new list<String>();
	String Q_pli_query; String excl_Query = '';
	List<sObject> sObjectList = new List<sObject>();
	try{
		if(taskValuesMap.values().contains(GlobalConstants.TASK_VALUE_Final)) {
			Staticresource sr2 = [select id,body from Staticresource where name = :GlobalConstants.QTC_ADDQUOTEFINAL_QTEHEADER limit 1];
			Final_QTEHEADER_BODY = sr2.body.tostring();
			Staticresource sr3 = [select id,body from Staticresource where name = :GlobalConstants.QTC_ADDQUOTEFINAL_QTELINEITEM limit 1];
			Final_QTELINEITEM_BODY = sr3.body.tostring();
			mapChildNodesWithParent(Final_QTEHEADER_BODY);
			mapChildNodesWithParent(Final_QTELINEITEM_BODY);
		}
		if(taskValuesMap.values().contains(GlobalConstants.TASK_VALUE_ADD) || taskValuesMap.values().contains(GlobalConstants.TASK_VALUE_UPD)) {
			Staticresource sr = [select id,body from Staticresource where name = :GlobalConstants.QTC_ADDQUOTEADD_QTEHEADER limit 1];
			ADD_QTEHEADER_BODY = sr.body.tostring();
			Staticresource sr1 = [select id,body from Staticresource where name = :GlobalConstants.QTC_ADDQUOTEADD_QTELINEITEM limit 1];
			ADD_QTELINEITEM_BODY = sr1.body.tostring();
			mapChildNodesWithParent(ADD_QTEHEADER_BODY);
			mapChildNodesWithParent(ADD_QTELINEITEM_BODY);
		}
		//get the list of parameter mapping from quote parameter object
		q_paramap_list =  [Select id,Target_Field__c,Source_Field__c,Source_Object__c,Target_Object__c,
						   Parameter_Value1__c,Parameter_Value2__c,Parameter_Type__c
						   from Quote_Parameter__c
						   Where Active__c = true
											 AND Target_Object__c =: GlobalConstants.Quote_Staging
																	AND Parameter_Type__c !=: GlobalConstants.Entry_Criteria
																	Order by Parameter_Type__c ASC,Parameter_Value1__c asc
		];

		//Collect all mapping values or picklist values from Quote Parameter custom object
		for(Quote_Parameter__c q_para : q_paramap_list) {

			//If the mapping is a pickist, then collect the values in a map
			if(q_para.Parameter_Type__c <> null && q_para.Parameter_Type__c.equalsIgnoreCase(GlobalConstants.Mapping_Value))
				picklist_map.put(q_para.Parameter_Value1__c, q_para.Parameter_Value2__c);

			//collect all the source fields of proposal line item in a set for querying the required fields
			if(q_para.Source_Object__c <> null && q_para.Parameter_Type__c!= Globalconstants.Direct_Value
			   && q_para.Source_Field__c <> null) {
				if(q_para.Source_Object__c.equalsIgnoreCase(GlobalConstants.Apttus_ProposalProposal_Line_Item) ) {
					QPfield_set.addAll(q_para.Source_Field__c.split(GlobalConstants.COMMA));
					if(q_para.Parameter_Value1__c!=null && q_para.Parameter_Value1__c.contains(GlobalConstants.UNDERSCORE_C))
						QPfield_set.add(q_para.Parameter_Value1__c);
				}

				//Collect all the fields to be queried for Quote Delivery Sales Items
				if(q_para.Source_Object__c.equalsIgnoreCase(GlobalConstants.Quote_Delivery_Sales_Item)) {
					if(q_para.Parameter_Type__c == GlobalConstants.Query_Fields)
						quoteDeliverySIfield_Set.addAll(q_para.Source_Field__c.split(GlobalConstants.COMMA));
					else
						quoteDeliverySIfield_Set.add(q_para.Source_Field__c);
				}
			}

			//If there is any parameters which needs to excluded from line items to be sent
			if(q_para.Parameter_Type__c <> null && q_para.Source_Field__c <> null && q_para.Target_Field__c <> null
			   && q_para.Parameter_Type__c.equalsIgnoreCase(GlobalConstants.Exclude)) {
				if(q_para.Parameter_Value1__c <> null) {
					if(excludeMap.containsKey(q_para.Parameter_Value1__c+GlobalConstants.COMMA+q_para.Parameter_Value2__c)) {
						Map<String,List<String> > exlMap = excludeMap.get(q_para.Parameter_Value1__c+GlobalConstants.COMMA+q_para.Parameter_Value2__c);
						exlMap.get(q_para.Source_Field__c).add(q_para.Target_Field__c);
					}
					else{
						Map<String,List<String> > exlMap = new Map<String,List<String> >();
						exlMap.put(q_para.Source_Field__c,q_para.Target_Field__c.split(GlobalConstants.COMMA));
						excludeMap.put(q_para.Parameter_Value1__c+GlobalConstants.COMMA+q_para.Parameter_Value2__c,exlMap);
					}
				}
				else{
					excludedProduts = q_para.Target_Field__c.split(GlobalConstants.COMMA);
					//system.debug('excludedProduts'+excludedProduts);
					excl_Query = excl_Query + GlobalConstants.ANDWITHSPACE + q_para.Source_Field__c + GlobalConstants.NOTINBRACKET;
					if(returnTypeOfField(q_para.Source_Object__c,q_para.Source_Field__c) == Schema.DisplayType.Currency ||
					   returnTypeOfField(q_para.Source_Object__c,q_para.Source_Field__c) == Schema.DisplayType.DOUBLE) {
						for(String prod : excludedProduts) {
							excl_Query = excl_Query + Decimal.valueOf(prod) +GlobalConstants.COMMA;
						}
						excl_Query = excl_Query.removeEnd(GlobalConstants.COMMA);
					}
					else if(returnTypeOfField(q_para.Source_Object__c,q_para.Source_Field__c) == Schema.DisplayType.DateTime) {
						for(String prod : excludedProduts) {
							excl_Query = excl_Query + DateTime.valueOf(prod) +GlobalConstants.COMMA;
						}
						excl_Query = excl_Query.removeEnd(GlobalConstants.COMMA);
					}
					else if(returnTypeOfField(q_para.Source_Object__c,q_para.Source_Field__c) == Schema.DisplayType.BOOLEAN) {
						for(String prod : excludedProduts) {
							excl_Query = excl_Query + Boolean.valueOf(prod) +GlobalConstants.COMMA;
						}
						excl_Query = excl_Query.removeEnd(GlobalConstants.COMMA);
					}
					else{
						//excl_Query = excl_Query + ' not in :excludedProduts';
						excl_Query = excl_Query + '\'' + String.join(excludedProduts,'\',\'') + '\'';
					}

					excl_Query = excl_Query + GlobalConstants.CLOSEBRACKET;
				}
			}

		}
		//system.debug('exclude_map-->'+excludeMap);
		system.debug('QPfield_set::'+QPfield_set);
		Set<ID> quotesId = new Set<ID> (proposal_Map.keyset());
		System.debug('quotesId:::' + quotesId);
		String query_fields;
		if(!QPfield_set.isEmpty()) {
			query_fields = String.join(new List<String>(QPfield_set), GlobalConstants.COMMA);
			query_fields = GlobalConstants.COMMA + query_fields;
		}
		if(!query_fields.contains('Apttus_QPConfig__OptionId__c')) query_fields = query_fields + ',Apttus_QPConfig__OptionId__c';
		if(!query_fields.contains('NokiaCPQ_Unitary_IRP__c')) query_fields = query_fields + ',NokiaCPQ_Unitary_IRP__c';
		if(!query_fields.contains('Apttus_QPConfig__ParentBundleNumber__c')) query_fields = query_fields + ',Apttus_QPConfig__ParentBundleNumber__c'; //added by ks

		Q_pli_query = 'SELECT Id,Total_Option_Quantity__c,NokiaCPQ_Unitary_IRPrice__c,Apttus_Proposal__Proposal__c,Apttus_QPConfig__LineNumber__c,Apttus_QPConfig__PrimaryLineNumber__c,CPQ_Market_Model__c,Apttus_QPConfig__DerivedFromId__r.CPQ_Group_Quantity__c,Apttus_Proposal__Proposal__r.CPQ_NCQ_Check__c,Apttus_Proposal__Proposal__r.CPQ_CQ_Check__c' +
					  query_fields + ' FROM Apttus_Proposal__Proposal_Line_Item__c'
					  +' WHERE Apttus_Proposal__Proposal__c in :quotesId ';

		//system.debug('Q_pli_query_1:'+Q_pli_query);

		//system.debug('excl_Query-->'+excl_Query);


		//Retreive all parent bundles alone along with their bundle quanity
		//this is needed to cascade the quantity of bundle to sellable items(SI's)
		List<Apttus_Proposal__Proposal_Line_Item__c> parentBundleList = [select id, Apttus_QPConfig__ParentBundleNumber__c,
																		 Product_Code__c, Apttus_QPConfig__PrimaryLineNumber__c,
																		 Apttus_QPConfig__Quantity2__c,Apttus_QPConfig__LineNumber__c,Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c
																		 from Apttus_Proposal__Proposal_Line_Item__c
																		 where Apttus_Proposal__Proposal__c =:quotesId
																											  and Apttus_QPConfig__ParentBundleNumber__c = null
																																						   and NokiaCPQ_Configuration_Type__c = :GlobalConstants.BUNDLE
																																																order by Apttus_QPConfig__ParentBundleNumber__c asc nulls first];
		if(parentBundleList <> null) {
			for(Apttus_Proposal__Proposal_Line_Item__c pliBundleItem : parentBundleList) {
				parentBundleQuantityMap.put(pliBundleItem.Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c+pliBundleItem.Apttus_QPConfig__PrimaryLineNumber__c,pliBundleItem.Apttus_QPConfig__Quantity2__c);
			}
		}

		//Retreive all SSP/SRS product to be mapped
		sspList = [Select Id,NokiaCPQ_Maintenance_Type__c,NokiaCPQ_Portfolio__c,NokiaCPQ_Product__c,NokiaCPQ_Product_Type__c,Product_Code__c,
				   NokiaCPQ_7705_SSP_Applicable__c,NokiaCPQ_Description__c from Maintenance_SSP_Product__c
				   where NokiaCPQ_Product_Type__c = :Nokia_CPQ_Constants.NOKIA_PRODUCT_NAME_SRS or NokiaCPQ_Product_Type__c = :Nokia_CPQ_Constants.NOKIA_PRODUCT_NAME_SSP];

		//Retreive all Arcadia options for this quote if it exists
		List<Quote_Delivery_Sales_Item__c> QDSIList = retrieveQuoteDeliveryOptions(proposal_Map.keyset(),quoteDeliverySIfield_Set);

		String marketModelQuery = Q_pli_query + excl_Query + ' and CPQ_Market_Model__c  != null order by CPQ_Market_Model__c,Apttus_QPConfig__PrimaryLineNumber__c';
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalwithMarketModel = Database.query(marketModelQuery);
		if(proposalwithMarketModel <> null && !proposalwithMarketModel.isEmpty()) {
			for(Apttus_Proposal__Proposal_Line_Item__c lineItem : proposalwithMarketModel) {
				if(marketModelMap.containsKey(lineItem.CPQ_Market_Model__c)) {
					marketModelMap.get(lineItem.CPQ_Market_Model__c).add(lineItem);
				}
				else
					marketModelMap.put(lineItem.CPQ_Market_Model__c, new List<Apttus_Proposal__Proposal_Line_Item__c> {lineItem});
			}
		}
		//Add the excluded conditions to the query
		Q_pli_query = Q_pli_query + excl_Query + ' Order by Apttus_Proposal__Proposal__c,Apttus_QPConfig__PrimaryLineNumber__c ASC NULLS LAST';
		system.debug('Q_pli_query:'+Q_pli_query);
		//Add proposal line items to batch execute
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalList = Database.query(Q_pli_query);
		System.debug('proposalList::::' + proposalList);
		List<sObject> finalObjectList = new List<sObject>();
		// Added by Imran -- ITCCPQ-789
		for(Apttus_Proposal__Proposal_Line_Item__c lineItem : proposalList) {
			if(lineItem.Total_Option_Quantity__c != null)
			{
				ExtendedePrice_CNP = ExtendedePrice_CNP + (lineItem.NokiaCPQ_ExtendedPrice_CNP__c * lineItem.Total_Option_Quantity__c)/lineItem.Apttus_QPConfig__Quantity2__c;
			}
			else{
				ExtendedePrice_CNP = ExtendedePrice_CNP + lineItem.NokiaCPQ_ExtendedPrice_CNP__c;
			}
		}
		//If its a QTC quote with flexi group structure, then sort the list according to flexi group
		if(proposalwithMarketModel <> null && !proposalwithMarketModel.isEmpty()) {
			for(Apttus_Proposal__Proposal_Line_Item__c lineItem : proposalList) {
				if(!finalObjectList.contains(lineItem)) {
					if(lineItem.CPQ_Market_Model__c<>null) {
						finalObjectList.addAll(marketModelMap.get(lineItem.CPQ_Market_Model__c));
					}else{
						finalObjectList.add(lineItem);
					}
				}
			}
		}

		//If its a NSW quote with QDSI, then add them after its corresponding proposal line item
		if(QDSIList <> null && !QDSIList.isEmpty()) {
			for(Apttus_Proposal__Proposal_Line_Item__c lineItem : proposalList) {
				if(!finalObjectList.contains(lineItem)) {
					finalObjectList.add(lineItem);
					if(arcadiaProductOptionMap.get(lineItem.Product_Code__c+lineItem.Apttus_QPConfig__LineNumber__c) <> null) {
						finalObjectList.addAll(arcadiaProductOptionMap.get(lineItem.Product_Code__c+lineItem.Apttus_QPConfig__LineNumber__c));
					}
				}
			}
		}

		if(finalObjectList <> null && !finalObjectList.isEmpty()) {
			system.debug('adding final-->'+finalObjectList);
			sObjectList.addAll(finalObjectList);
		}
		else{
			system.debug('adding proposal-->'+proposalList);
			sObjectList.addAll(proposalList);
		}
		System.debug('sobjectlisr: ' + sObjectList);
		//Add quote delivery sales item to batch execute
		/*if(QDSIList <> null && !QDSIList.isEmpty())
		   sObjectList.addAll(QDSIList);*/

	}catch(Exception ex) {
		ExceptionHandler.addException(ex,Globalconstants.QTC_QuoteProposalToStaging,Globalconstants.STARTMETHOD+Globalconstants.AT_LINE_NUMBER+ex.getLineNumber());
	}
	return sObjectList;
}



/****************************************
 * Name : createHeaderData
 * Description : prepares the header data for quote staging
 * Parameters:
 * Returns :
 *****************************************/
public Quote_Staging__c createHeaderData(Apttus_Proposal__Proposal_Line_Item__c proposalLineItem)
{

	Apttus_Proposal__Proposal__c quote = proposal_Map.get(proposalLineItem.Apttus_Proposal__Proposal__c);
	sObject sobj = quote;
	//system.debug('sobj'+sobj);
	Quote_Staging__c quote_staging = new Quote_Staging__c();
	//system.debug(taskValuesMap.get(proposalLineItem.Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c));
	if(taskValuesMap.get(proposalLineItem.Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c) == 'Final') {
		QTEHEADER_BODY = Final_QTEHEADER_BODY;
		QTELINEITEM_BODY = Final_QTELINEITEM_BODY;
	}
	else{
		QTELINEITEM_BODY = ADD_QTELINEITEM_BODY;
		QTEHEADER_BODY = ADD_QTEHEADER_BODY;
	}
	quote_staging.Type__c = GlobalConstants.QTE_HEADER;
//Added by Imran ITCCPQ-789
	quote_staging.CONTRACT__c = ExtendedePrice_CNP;
	//mapChildNodesWithParent(QTEHEADER_BODY);
	//mapChildNodesWithParent(QTELINEITEM_BODY);
	quote_staging = mapQuoteParameter(sobj,quote_staging,proposal_Map,quote.NokiaCPQ_Proposal_Id__c,QTEHEADER_BODY);
	if(quote_staging.Quote_Number__c <> null && taskValuesMap.containsKey(quote_staging.Quote_Number__c))
		quote_staging.TASK__c = taskValuesMap.get(quote_staging.Quote_Number__c);

	//system.debug('quote_staging++'+quote_staging);
	return quote_staging;
}

public Quote_Staging__c createLineItemStaging(Quote_Staging__c quote_staging,String quoteNumber,Apttus_Proposal__Proposal_Line_Item__c lineItem){
	//Create line item staging records
	quote_staging = new Quote_Staging__c();
	quote_staging.Type__c = GlobalConstants.QTE_LINE_ITEM;
	quote_staging.QTELINENUM__c = quoteLineNumMap.get(quoteNumber)+1;
	quoteLineNumMap.put(quoteNumber,quoteLineNumMap.get(quoteNumber)+1);
	LineNumbersMap.put(quoteNumber+lineItem.get(GlobalConstants.PrimaryLineNumber_Field), quote_staging.QTELINENUM__c);

	//Maps the fields of proposal line item to Quote staging by field mapping maintained in Quote parameter
	quote_staging = mapQuoteParameter(lineItem,quote_staging,proposal_Map,quoteNumber,QTELINEITEM_BODY);
	quoteStagingList.add(quote_staging);
	processedQuoteLineItems.add(lineItem.Id);
	//system.debug('quote_staging-->'+quote_staging);
	return quote_staging;
}

/******************************************************************************************************
   Name : LoadQuoteData
   Created Date: 20 August 2019
   Created by: Accenture
   Description : method for loading the data to staging
 *********************************************************************************************************/
public void LoadQuoteData(List<sObject> proposalLineItemList){
	Apttus_Proposal__Proposal_Line_Item__c proposal_lineitem;
	String quoteNumber;
	try{
		Quote_Staging__c quote_staging_Rec;
		for(sObject proposallineitem : proposalLineItemList) {
			if(!processedQuoteLineItems.contains(String.valueOf(proposallineitem.get('Id')))) {

				if(proposallineitem.getSObjectType() == proposalLineItemType) {
					proposal_lineitem = (Apttus_Proposal__Proposal_Line_Item__c)proposallineitem;
					quoteNumber = proposal_lineitem.Apttus_Proposal__Proposal__r.NokiaCPQ_Proposal_Id__c;

					//system.debug('excludeMap'+excludeMap);
					//Check if the line item should be excluded based on condition mentioned in parameter values
					Boolean toBeExcluded = false;
					for(String excl : excludeMap.keyset()) {
						String fieldname = excl.substringBefore(GlobalConstants.COMMA);
						String fieldValue = excl.substringAfter(GlobalConstants.COMMA);
						Object actualValue;
						if(fieldname <> null && fieldname.contains(GlobalConstants.UNDERSCORE_R)) {
							actualValue = getDataFromParent(fieldname,proposallineitem);
						}
						else
							actualValue = proposal_lineitem.get(fieldname);
						//system.debug('actualValue'+actualValue);
						if(fieldValue <> null && fieldValue.equalsIgnoreCase(String.valueOf(actualValue))) {
							Map<String,List<String> > excludeValuesMap = excludeMap.get(excl);
							//system.debug('excludeValuesMap'+excludeValuesMap);
							for(String exclField : excludeValuesMap.keySet()) {
								Object excludedValue = proposal_lineitem.get(exclField);
								List<String> excludedValues  = excludeValuesMap.get(exclField);
								//system.debug('excludedValues'+excludedValues);
								if(excludedValues.contains(String.valueOf(excludedValue))) {
									toBeExcluded = true;
								}
							}
						}
					}

					//If the line item should not be excluded then create quote staging records
					if(!toBeExcluded) {
						//Creates the header data for quote staging object from proposal line item
						if(!processedQuoteHeaders.contains(proposal_lineitem.Apttus_Proposal__Proposal__c)) {
							Quote_Staging__c quote_staging = createHeaderData(proposal_lineitem);
							processedQuoteHeaders.add(proposal_lineitem.Apttus_Proposal__Proposal__c);
							//If the proposal line items contains any SERVICE items, then update the RFQType of Quote staging header to EFI
							if(proposal_lineitem.NokiaCPQ_Item_Type__c <> null && proposal_lineitem.NokiaCPQ_Item_Type__c.equalsIgnoreCase(GlobalConstants.SERVICE)) {
								if(quote_staging.RFQTYPE__c <> GlobalConstants.EFI) {
									quote_staging.RFQTYPE__c = GlobalConstants.EFI;
									String reqData =  quote_staging.Request_Data__c;
									reqData = reqData.replace(GlobalConstants.RFQTYPE_StartTag+reqData.substringBetween(GlobalConstants.RFQTYPE_StartTag, GlobalConstants.RFQTYPE_EndTag)+GlobalConstants.RFQTYPE_EndTag, GlobalConstants.RFQTYPE_StartTag+quote_staging.RFQTYPE__c +GlobalConstants.RFQTYPE_EndTag);
									quote_staging.Request_Data__c = reqData;
								}
							}
							quoteStagingList.add(quote_staging);
						}
						//Assigns line number for the proposal line items
						if(!quoteLineNumMap.containsKey(quoteNumber))
							quoteLineNumMap.put(quoteNumber, 0);

						//Create market model record if the market model is present for a line item
						if(proposal_lineitem.CPQ_Market_Model__c <> null && !String.isBlank(proposal_lineitem.CPQ_Market_Model__c)) {
							//Added below NCQ check in order to append QTY(Group Quantity) for NCQ quotes. This is needed for them to be sent to SAP.
							//Added on Nov 16th by Neeharika Upadrasta
							Integer groupQuantity = Integer.valueOf(proposal_lineitem.Apttus_QPConfig__DerivedFromId__r.CPQ_Group_Quantity__c);
							proposal_lineitem.CPQ_Market_Model__c = (proposal_lineitem.Apttus_Proposal__Proposal__r.CPQ_NCQ_Check__c || proposal_lineitem.Apttus_Proposal__Proposal__r.CPQ_CQ_Check__c) ? proposal_lineitem.CPQ_Market_Model__c + ' QTY('+groupQuantity+')' : proposal_lineitem.CPQ_Market_Model__c;
							if(marketModelsLineNum.get(quoteNumber+proposal_lineitem.CPQ_Market_Model__c)==  null) {
								quote_staging_Rec = createMarketModelStaging(proposal_lineitem.CPQ_Market_Model__c,quoteNumber,proposal_lineitem.Flexible_group_code__c);
								quoteStagingList.add(quote_staging_Rec);
								marketModelWithStaging.put(quoteNumber+proposal_lineitem.CPQ_Market_Model__c, quote_staging_Rec);
							}
						}
						//system.debug('marketModelWithStaging'+marketModelWithStaging);
						Quote_Staging__c quote_staging;
						quote_staging = createLineItemStaging(quote_staging,quoteNumber,proposal_lineitem);
						//If the proposal line item contains market model, then calculate pricing fields
						quote_staging_Rec = marketModelWithStaging.get(quoteNumber+proposal_lineitem.CPQ_Market_Model__c);
						if(quote_staging_Rec <> null)
						{
							Dom.Document docNode = getDomDocument(quote_staging_Rec);
							Dom.XmlNode rootElement1 = docNode.getRootElement();

							quote_staging_Rec.BASE__c = (quote_staging_Rec.EXTENDED__c / quote_staging_Rec.QUANTITY__c).setScale(2);
							quote_staging_Rec.CONTRACT__c = (quote_staging_Rec.EXTENDED__c / quote_staging_Rec.QUANTITY__c).setScale(2);
							String currData = String.valueOF(quote_staging_Rec.get(GlobalConstants.BASE_Field));
							createCurrencyXMLStructure(rootElement1,currData,quote_staging_Rec.BASE__c,proposal_lineitem, GlobalConstants.BASE_Field);
							createCurrencyXMLStructure(rootElement1,currData,quote_staging_Rec.BASE__c,proposal_lineitem, GlobalConstants.CONTRACT_Field);

							Decimal RoundingValue = quote_staging_Rec.EXTENDED__c - (quote_staging_Rec.CONTRACT__c * quote_staging_Rec.QUANTITY__c);
							quote_staging_Rec.RoundingAdjustment__c = RoundingValue;
							createRoundingAdjustmentStructure(rootElement1,RoundingValue,quote_staging_Rec.QUANTITY__c,proposal_lineitem, GlobalConstants.RoundingAdjustment_Field);

							if(quote_staging_Rec.DOCUMENTID__c == null)
							{
								quote_staging_Rec.DOCUMENTID__c = quote_staging.DOCUMENTID__c;
								Dom.XmlNode childElement = getChildXmlNode(rootElement1,GlobalConstants.DOCUMENTID);
								if(childElement != null && (childElement.getText() == '' || childElement.getText() == null))
									childElement.addTextNode(quote_staging_Rec.DOCUMENTID__c);
							}

							quote_staging_Rec.Request_Data__c = docNode.toXmlString();
							//system.debug('quote_staging_Rec::'+quote_staging_Rec);
						}
					}
				}
				if(proposallineitem.getSObjectType() == quoteDeliverySalesItemType) {
					Quote_Delivery_Sales_Item__c qdsi = (Quote_Delivery_Sales_Item__c)proposallineitem;
					quoteNumber = qdsi.Proposal__r.NokiaCPQ_Proposal_Id__c;
					createArcadiaOptions(proposallineitem,proposal_Map,quoteNumber);
				}

			}
		}

		if(!quoteStagingList.isempty())
			database.insert(quoteStagingList,false);


		if(quote_staging_Rec <> null) {
			Database.update(marketModelWithStaging.values(),false);
		}

		//added by surinder
		quoteStagingListForTxnRec.addAll(quoteStagingList);
		//Clear quotestaginglist once this batch is processed
		quoteStagingList.clear();
		system.debug('CPU Time'+Limits.getCpuTime());
	}catch(Exception ex) {
		ExceptionHandler.addException(ex,Globalconstants.QTC_QuoteProposalToStaging,Globalconstants.LoadQuoteData+Globalconstants.AT_LINE_NUMBER+ex.getLineNumber());
	}
}

/****************************************
 * Name : execute
 * Description : Retrieves the data from sales item staging object
 * Parameters: Database.BatchableContext, List of Product sales item
 * Returns :
 *****************************************/
global void execute(Database.BatchableContext BC, List<sObject> proposalLineItemList)
{
	system.debug('before execute proposalLineItemList:' + proposalLineItemList);
	LoadQuoteData(proposalLineItemList);
	system.debug('after execute:');
	//system.debug('CPU time:'+Limits.getCpuTime());
}

/******************************************************************************************************
   Name : addParentLineNumber
   Created Date: 20 August 2019
   Created by: Accenture
   Description : method for adding parent line number to the proposal line item
 *********************************************************************************************************/
public Decimal addParentLineNumber(sObject proposal_lineitem,String field,String quoteNumber)
{
	Decimal parentLineNum;
	Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = (Apttus_Proposal__Proposal_Line_Item__c)proposal_lineitem;
	if(proposalLineItem.Apttus_Proposal__Proposal__r.CPQ_CQ_Check__c && proposalLineItem.Apttus_QPConfig__ParentBundleNumber__c != null) {//added by ks
		parentLineNum = proposalLineItem.Apttus_QPConfig__ParentBundleNumber__c;
	} else {
		if(!String.isBlank(field) && marketModelsLineNum.get(quoteNumber+proposal_lineitem.get(field)) <> null) {
			parentLineNum = marketModelsLineNum.get(quoteNumber+proposal_lineitem.get(field));
		}
		else
		{
			parentLineNum = 0;
		}
	}
	System.debug('parent line no  outside: ' + parentLineNum);
	return parentLineNum;
}

/******************************************************************************************************
   Name : mapCurrencyParameter
   Created Date: 23 September 2019
   Created by: Accenture
   Description : method for mapping the currency parameter
 *********************************************************************************************************/
public Decimal mapCurrencyParameter(Decimal val1,Decimal val2,String operation)
{
	Decimal currencyValue;
	if(operation.equalsIgnorecase(GlobalConstants.DIVIDE)) {
		if(val2 <> 0)
			currencyValue = (val1 / val2 );
	}
	else if(operation.equalsIgnorecase(GlobalConstants.MULTIPLY)) {
		currencyValue = val1 * val2;
	}
	return currencyValue;
}


/******************************************************************************************************
   Name : getTotalOptionQuantity
   Created Date: 23 September 2019
   Created by: Accenture
   Description : method for multiplying option quantity with bundle quantity
 *********************************************************************************************************/
public Decimal getTotalOptionQuantity(Sobject proposal_lineitem,String quoteNumber,Decimal currencyValue)
{
	if(checkFieldInSObject(GlobalConstants.LineNumber_Field,proposal_lineitem) && proposal_lineitem.get(GlobalConstants.LineNumber_Field  ) <> null) {
		Decimal lineNumber =  Decimal.valueOf(String.valueOf(proposal_lineitem.get(GlobalConstants.LineNumber_Field  )));
		//system.debug(lineNumber);
		Decimal parentBundleQuantity = parentBundleQuantityMap.get(quoteNumber+lineNumber);
		if(parentBundleQuantity <> null && parentBundleQuantity <> 1) {
			currencyValue = currencyValue * parentBundleQuantityMap.get(quoteNumber+lineNumber);
		}
	}
	else if(checkFieldInSObject(GlobalConstants.PARENTLINEITEMFIELD,proposal_lineitem)) {
		//system.debug('In field QDSI');
		String parentField = getDataFromParent(GlobalConstants.PARENTLINEITEMNUMBERFIELD,proposal_lineitem);
		if(parentField <> null)
		{
			Decimal lineNumber =  Decimal.valueOf(parentField);
			//system.debug(lineNumber);
			if(parentBundleQuantityMap.containsKey(quoteNumber+lineNumber)) {
				Decimal parentBundleQuantity = parentBundleQuantityMap.get(quoteNumber+lineNumber);
				if(parentBundleQuantity <> null && parentBundleQuantity <> 1)
					currencyValue = currencyValue * parentBundleQuantity;
			}
		}
	}
	//system.debug('currencyValue++++'+currencyValue );
	return currencyValue;
}


/******************************************************************************************************
   Name : mapQuoteParameter
   Created Date: 20 August 2019
   Created by: Accenture
   Description : method for mapping the parameters from source object(proposal line item/Quote Delivery Sales Items/Quote Proposal) to Quote staging
 *********************************************************************************************************/
public Quote_Staging__c mapQuoteParameter(sObject proposal_lineitem,Quote_Staging__c quote_staging,Map<ID,Apttus_Proposal__Proposal__c> proposal_Map,String quoteNumber,String QTE_BODY)
{
	try{

		//Convert the Quote Body from static Resource to XML Dom structure
		Dom.Document doc = new Dom.Document();
		doc.load(QTE_BODY);
		Dom.XmlNode rootElement = doc.getRootElement();

		//Add the line number to the
		Dom.XmlNode qtelineElement = rootElement.getChildElement(GlobalConstants.QTELINENUM,null);
		if(qtelineElement != null)
		{
			//Add the line number value to XML Request Data
			qtelineElement.addTextNode(String.valueOf(quote_staging.QTELINENUM__c));
			if(proposal_lineitem.getSObjectType() == proposalLineItemType) {
				Decimal parentLinenumber = addParentLineNumber(proposal_lineitem,GlobalConstants.cpqMarketModel,quoteNumber);
				quote_staging.put(GlobalConstants.LUCENT_ParentLineNum,parentLinenumber);
				//Add the Parent line number value to XML Request Data
				if(qtelineElement.getAttributeCount() > 0 && parentLinenumber <> null) {
					qtelineElement.setAttribute(qtelineElement.getAttributeKeyAt(0), String.valueOf(Integer.valueOf(parentLinenumber)));
				}
			}
		}

		for(Quote_Parameter__c q_paratype : q_paramap_list) {
			Schema.SObjectType sourceObjType = Schema.getGlobalDescribe().get(q_paratype.Source_Object__c);
			Schema.SObjectType targetObjType = Schema.getGlobalDescribe().get(q_paratype.Target_Object__c);
			if(sourceObjType == proposal_lineitem.getSObjectType() && q_paratype.Parameter_Type__c <> null) {
				if(q_paratype.Parameter_Value2__c == null || q_paratype.Parameter_Type__c.equalsIgnoreCase(GlobalConstants.Mapping_Value) ||
				   (q_paratype.Parameter_Value1__c <> null && q_paratype.Parameter_Value2__c <> null
					&& !checkFieldInSObject(q_paratype.Parameter_Value1__c,proposal_lineitem)) ||
				   (q_paratype.Parameter_Value1__c <> null && q_paratype.Parameter_Value2__c <> null
					&& checkFieldInSObject(q_paratype.Parameter_Value1__c,proposal_lineitem) && checkForValidCondition(q_paratype.Parameter_Value1__c,q_paratype.Parameter_Value2__c,proposal_lineitem))
				   ) {
					if(q_paratype.Parameter_Type__c == GlobalConstants.Mapping_Rule) {
						String parentField = '';
						if(q_paratype.Source_Field__c <> null && q_paratype.Source_Field__c.contains(GlobalConstants.UNDERSCORE_R))
						{
							parentField = getDataFromParent(q_paratype.Source_Field__c,proposal_lineitem);
							quote_staging.put(q_paratype.Target_Field__c,parentField);
							Dom.XmlNode childElement = getChildXmlNode(rootElement,q_paratype.Target_Field__c.remove(GlobalConstants.UNDERSCORE_C));
							//Dom.XmlNode childElement = checkIfElementExists(rootElement,q_paratype.Target_Field__c.remove(GlobalConstants.UNDERSCORE_C));
							if(childElement != null && parentField!= null)
								childElement.addTextNode(parentField);
						}

						Schema.DescribeSObjectResult targetObjResult = targetObjType.getDescribe();
						Schema.DescribeFieldResult targetFieldResult = targetObjResult.fields.getMap().get(q_paratype.Target_Field__c).getDescribe();

						Boolean isMarketModel = false;
						//Decimal MM_Qty = 1.0;
						//If the source object is proposal line itemm and belong to a marketModel structure, then get the marketmodel quote staging record
						if(proposal_lineitem.getSObjectType() == proposalLineItemType
						   && marketModelWithStaging.containsKey(quoteNumber+proposal_lineitem.get(Globalconstants.cpqMarketModel))) {
							isMarketModel = true;
						}

						//If the source field contains two fields seprated by comma with an operation, then do the calculation
						Decimal currencyValue;
						if(q_paratype.Source_Field__c <> null && q_paratype.Source_Field__c.contains(GlobalConstants.COMMA) && targetFieldResult.getType() == Schema.DisplayType.Currency) {
							Decimal val1 = Decimal.valueOf(String.valueOf(proposal_lineitem.get(q_paratype.Source_Field__c.substringBefore(GlobalConstants.COMMA))));
							Decimal val2 = Decimal.valueOf(String.valueOf(proposal_lineitem.get(q_paratype.Source_Field__c.substringAfter(GlobalConstants.COMMA))));
							currencyValue = 0.0;
							if(q_paratype.Parameter_Value1__c <> null && q_paratype.Parameter_Value1__c.equalsIgnorecase(GlobalConstants.OPERATION)) {
								if(q_paratype.Parameter_Value2__c <> null && q_paratype.Parameter_Value2__c.equalsIgnorecase(GlobalConstants.DIVIDE)) {
									currencyValue = mapCurrencyParameter(val1,val2,q_paratype.Parameter_Value2__c);
									if(currencyValue.scale() > 2) {
										currencyValue = currencyValue.setScale(2);
										//system.debug('currencyValue'+currencyValue);
										Decimal RoundingValue = val1 - (currencyValue * val2);
										//system.debug('RoundingValue'+RoundingValue);
										if(quote_staging.RoundingAdjustment__c == null && (RoundingValue <> 0.0 || RoundingValue <> 0)) {
											val2 = getTotalOptionQuantity(proposal_lineitem,quoteNumber,val2);
											quote_staging.put(GlobalConstants.RoundingAdjustment_Field,RoundingValue);
											createRoundingAdjustmentStructure(rootElement,RoundingValue,val2,proposal_lineitem,GlobalConstants.RoundingAdjustment_Field);
										}
									}
								}
							}
						}
						if(parentField <> null && String.isBlank(parentField) && (currencyValue <> null || proposal_lineitem.get(q_paratype.Source_Field__c) <> null)) {
							//system.debug('Inside Main condition');
							//If the field is a currency field, do the neccessary transformations
							if (targetFieldResult.getType() == Schema.DisplayType.Currency) {
								if(currencyValue == null) {
									currencyValue = Decimal.valueOf(String.valueOf(proposal_lineitem.get(q_paratype.Source_Field__c)));
								}
								//If its a currency field and belongs to market model structure, then sum up the values of line item to market model
								if(isMarketModel)
								{
									Quote_Staging__c qtc = marketModelWithStaging.get(quoteNumber+proposal_lineitem.get(Globalconstants.cpqMarketModel));
									Decimal tempCurr = 0.0;
									if(q_paratype.Target_Field__c <> null && qtc.get(q_paratype.Target_Field__c) <> null)
										tempCurr = Decimal.valueOf(String.valueOf(qtc.get(q_paratype.Target_Field__c)));
									qtc.put(q_paratype.Target_Field__c,tempCurr+currencyValue);
									//system.debug('makelt model of item::'+proposal_lineitem.get(Globalconstants.cpqMarketModel));
									//system.debug('tempCurr--'+tempCurr+' currencyValue--'+currencyValue);
								}
								String currencyStringValue = currencyValue.toPlainString();
								if(q_paratype.Target_Field__c.equalsIgnoreCase(GlobalConstants.RoundingAdjustment_Field)) {
									if(quote_staging.RoundingAdjustment__c == null) {
										quote_staging.put(q_paratype.Target_Field__c,currencyValue);
										//If the field is a currency field, then prepare the xml structure of OPERAMT
										createRoundingAdjustmentStructure(rootElement,0.0,currencyValue,proposal_lineitem, q_paratype.Target_Field__c);
									}
								}else{
									quote_staging.put(q_paratype.Target_Field__c,currencyValue);
									//If the field is a currency field, then prepare the xml structure of OPERAMT
									createCurrencyXMLStructure(rootElement,currencyStringValue,currencyValue,proposal_lineitem, q_paratype.Target_Field__c);
								}
							}else if(targetFieldResult.getType() == Schema.DisplayType.DOUBLE) {
								//system.debug('quantity');
								if(proposal_lineitem.get(q_paratype.Source_Field__c) <> null && sourceObjType == proposal_lineitem.getSObjectType() ) {
									currencyValue = Decimal.valueOf(String.valueOf(proposal_lineitem.get(q_paratype.Source_Field__c)));//* MM_Qty;
								}
								//  if(sourceObjType <> proposalLineItemType
								//	 || proposal_lineitem.get(q_paratype.Source_Field__c) == null){
								//system.debug('parentBundleQuantityMap'+parentBundleQuantityMap);
								currencyValue = getTotalOptionQuantity(proposal_lineitem,quoteNumber,currencyValue);
								//  }
								String currencyStringValue = currencyValue.toPlainString();
								quote_staging.put(q_paratype.Target_Field__c, currencyValue);
								//If the field is a Decimal field, then prepare the xml structure of OPERAMT
								createQuantityXMLStructure(rootElement,currencyStringValue,currencyValue,proposal_lineitem, q_paratype.Target_Field__c);
								createRoundingAdjustmentStructure(rootElement,null,currencyValue,proposal_lineitem,GlobalConstants.RoundingAdjustment_Field);
							}
							else if(targetFieldResult.getType() == Schema.DisplayType.DateTime)
							{
								DateTime dateValue = DateTime.valueOf(String.valueOf(proposal_lineitem.get(q_paratype.Source_Field__c)));

								quote_staging.put(q_paratype.Target_Field__c,dateValue);
								//If the field is a date field, then prepare xml structure of DATETIME
								createDateXMLStructure(rootElement,dateValue, q_paratype.Target_Field__c);
							}
							/*else if(targetFieldResult.getType() == Schema.DisplayType.Boolean)
							   {
							   Boolean booleanValue = Boolean.valueOf(proposal_lineitem.get(q_paratype.Source_Field__c));
							   quote_staging.put(q_paratype.Target_Field__c,booleanValue);
							   //If the field is a date field, then prepare xml structure of DATETIME
							   createDateXMLStructure(rootElement,booleanValue, q_paratype.Target_Field__c);
							   }*/
							else
							{

								String stringValue = String.valueOf(proposal_lineitem.get(q_paratype.Source_Field__c));
								//system.debug('q_paratype.Source_Field__c'+q_paratype.Source_Field__c);
								quote_staging.put(q_paratype.Target_Field__c,stringValue);
								//Enterprise Release - SSP, SRS product code
								if(q_paratype.Target_Field__c.Contains('ITEM'))
								{

									Apttus_Proposal__Proposal_Line_Item__c lineitem = (Apttus_Proposal__Proposal_Line_Item__c)proposal_lineitem;
									Apttus_Proposal__Proposal__c quote = proposal_Map.get(lineitem.Apttus_Proposal__Proposal__c);

									if(quote.NokiaCPQ_Portfolio__c == Nokia_CPQ_Constants.NOKIA_IP_ROUTING && (lineitem.Apttus_QPConfig__ChargeType__c == Nokia_CPQ_Constants.NOKIA_PRODUCT_NAME_SRS || lineitem.Apttus_QPConfig__ChargeType__c == Nokia_CPQ_Constants.NOKIA_PRODUCT_NAME_SSP))
									{
										for(Maintenance_SSP_Product__c sspdata: sspList)
										{
											system.debug('7705'+quote.NokiaCPQ_Is_7705_Exists__c+'-'+sspdata.NokiaCPQ_7705_SSP_Applicable__c);
											system.debug('[+] condition = '+(sspdata.NokiaCPQ_Portfolio__c == quote.NokiaCPQ_Portfolio__c && (lineitem.Apttus_QPConfig__ChargeType__c == Nokia_CPQ_Constants.NOKIA_PRODUCT_NAME_SRS || (sspdata.NokiaCPQ_Product_Type__c == Nokia_CPQ_Constants.NOKIA_PRODUCT_NAME_SSP && ((sspdata.NokiaCPQ_7705_SSP_Applicable__c == '7705_NAR' && quote.NokiaCPQ_Is_7705_Exists__c > 0) || (quote.NokiaCPQ_Is_7705_Exists__c == 0 && (sspdata.NokiaCPQ_7705_SSP_Applicable__c == null || sspdata.NokiaCPQ_7705_SSP_Applicable__c ==  '')))))));
											system.debug('[+] '+q_paratype.Target_Field__c);
											if(sspdata.NokiaCPQ_Portfolio__c == quote.NokiaCPQ_Portfolio__c && (lineitem.Apttus_QPConfig__ChargeType__c == Nokia_CPQ_Constants.NOKIA_PRODUCT_NAME_SRS ||
																												(sspdata.NokiaCPQ_Product_Type__c == Nokia_CPQ_Constants.NOKIA_PRODUCT_NAME_SSP && ((sspdata.NokiaCPQ_7705_SSP_Applicable__c == '7705_NAR' && quote.NokiaCPQ_Is_7705_Exists__c > 0) || (quote.NokiaCPQ_Is_7705_Exists__c == 0 && (sspdata.NokiaCPQ_7705_SSP_Applicable__c == null || sspdata.NokiaCPQ_7705_SSP_Applicable__c ==  ''))))))
											{

												if(q_paratype.Target_Field__c == 'ITEM__C')
												{
													stringvalue = sspdata.Product_Code__c;
													quote_staging.ITEM__c = sspdata.Product_Code__c;
												}
												else if(q_paratype.Target_Field__c  == 'ITEMDESC__c')
												{
													stringvalue = sspdata.NokiaCPQ_Description__c;
													quote_staging.ITEMDESC__c = sspdata.NokiaCPQ_Description__c;
												}
											}
										}
									}
								}
								//Dom.XmlNode childElement = rootElement.getChildElement(q_paratype.Target_Field__c.remove('__c'),null);
								Dom.XmlNode childElement = getChildXmlNode(rootElement,q_paratype.Target_Field__c.remove(GlobalConstants.UNDERSCORE_C));
								//Dom.XmlNode childElement = checkIfElementExists(rootElement,q_paratype.Target_Field__c.remove(GlobalConstants.UNDERSCORE_C));
								if(childElement != null && (childElement.getText() == '' || childElement.getText() == null))
									childElement.addTextNode(stringValue);
							}
						}

					}
					//Parameter mapping for DIRECT VALUE
					if(q_paratype.Parameter_Type__c == GlobalConstants.Direct_Value) {
						quote_staging.put(q_paratype.Target_Field__c,q_paratype.Parameter_Value1__c);
						//Dom.XmlNode childElement = rootElement.getChildElement(q_paratype.Target_Field__c.remove('__c'),null);
						Dom.XmlNode childElement = getChildXmlNode(rootElement,q_paratype.Target_Field__c.remove(GlobalConstants.UNDERSCORE_C));
						//Dom.XmlNode childElement = checkIfElementExists(rootElement,q_paratype.Target_Field__c.remove(GlobalConstants.UNDERSCORE_C));
						if(childElement != null && (childElement.getText() == '' || childElement.getText() == null))
							childElement.addTextNode(q_paratype.Parameter_Value1__c);
					}
					////Parameter mapping for MAPPING VALUES
					if(q_paratype.Parameter_Type__c == GlobalConstants.Mapping_Value) {
						String parameterValue1 = string.valueof(proposal_lineitem.get(q_paratype.Source_Field__c));
						if(picklist_map.containskey(parameterValue1))
							quote_staging.put(q_paratype.Target_Field__c,picklist_map.get(parameterValue1));
						Dom.XmlNode childElement = getChildXmlNode(rootElement,q_paratype.Target_Field__c.remove(GlobalConstants.UNDERSCORE_C));
						//Dom.XmlNode childElement = checkIfElementExists(rootElement,q_paratype.Target_Field__c.remove(GlobalConstants.UNDERSCORE_C));
						if(childElement != null && (childElement.getText() == '' || childElement.getText() == null))
							childElement.addTextNode(q_paratype.Source_Field__c);
					}
					//Parameter mapping for CURRENCY CONVERSION EURO
					if(q_paratype.Parameter_Type__c == GlobalConstants.Currency_Conversion_EUR) {
						decimal amount_EUR = decimal.valueOf(q_paratype.Source_Field__c)*decimal.valueOf(q_paratype.Parameter_Value1__c);
						quote_staging.put(q_paratype.Target_Field__c,amount_EUR);
						Dom.XmlNode childElement = getChildXmlNode(rootElement,q_paratype.Target_Field__c.remove(GlobalConstants.UNDERSCORE_C));
						//Dom.XmlNode childElement = rootElement.getChildElement(q_paratype.Target_Field__c.remove(GlobalConstants.UNDERSCORE_C),null);
						if(childElement != null && amount_EUR <> null)
							childElement.addTextNode(String.valueOf(amount_EUR));
					}
					//Parameter mapping for CURRENCY CONVERSION USD
					if(q_paratype.Parameter_Type__c== GlobalConstants.Currency_Conversion_USD) {
						decimal amount_USD = decimal.valueOf(q_paratype.Source_Field__c)*decimal.valueOf(q_paratype.Parameter_Value1__c);
						quote_staging.put(q_paratype.Target_Field__c,amount_USD);
						Dom.XmlNode childElement = getChildXmlNode(rootElement,q_paratype.Target_Field__c.remove(GlobalConstants.UNDERSCORE_C));
						//Dom.XmlNode childElement = rootElement.getChildElement(q_paratype.Target_Field__c.remove(GlobalConstants.UNDERSCORE_C),null);
						if(childElement != null && amount_USD <> null)
							childElement.addTextNode(String.valueOf(amount_USD));
					}
				}
			}
			//Parameter mapping for REMOVE CHARACTER
			if(q_paratype.Parameter_Type__c.equalsIgnoreCase(GlobalConstants.Remove_Character)) {
				String Source = '';
				//system.debug('q_paratype.Source_Field__c'+quote_staging.get(q_paratype.Source_Field__c));
				if(quote_staging.get(q_paratype.Source_Field__c) <> null) {
					Source = String.valueOf(quote_staging.get(q_paratype.Source_Field__c));
					String character = q_paratype.Parameter_Value1__c;
					if(character <> null && source.contains(character))
						source = source.replace(character, '');
					if(character <> null && character.equalsIgnoreCase(GlobalConstants.WHITESPACECHAR))
						source = source.deleteWhitespace();
					quote_staging.put(q_paratype.Target_Field__c,source);
					// Dom.XmlNode childElement = rootElement.getChildElement(q_paratype.Target_Field__c.remove(GlobalConstants.UNDERSCORE_C),null);
					Dom.XmlNode childElement = getChildXmlNode(rootElement,q_paratype.Target_Field__c.remove(GlobalConstants.UNDERSCORE_C));
					//Dom.XmlNode childElement = checkIfElementExists(rootElement,q_paratype.Target_Field__c.remove(GlobalConstants.UNDERSCORE_C));
					//debug(childElement);
					if(childElement != null && childElement.getChildren() <> null) {
						childElement.removeChild(childElement.getChildren()[0]);
						childElement.addTextNode(source);
					}
				}
			}
		}
		if(Schema.getGlobalDescribe().get(Globalconstants.quoteProposal) == proposal_lineitem.getSObjectType()) {
			//store the effective date as today's date with time
			quote_staging.EFFECTIVE__c = system.now();
			createDateXMLStructure(rootElement,quote_staging.EFFECTIVE__c, GlobalConstants.EFFECTIVE);
			//If Expiration date is null, then add 90 Days to Today's date and map it
			If(quote_staging.EXPIRATION__c == null)
			{
				quote_Staging.EXPIRATION__c = system.now().addDays(90);
				createDateXMLStructure(rootElement,quote_staging.EXPIRATION__c, GlobalConstants.EXPIRATION);
			}
			//If the warranty number for the quote is maintained in custom settings, then map it
			if(quote_staging.PARTNRID__c <> null) {
				QTC_WES_Warranty_Mapping__c warrantyEntry = QTC_WES_Warranty_Mapping__c.getInstance(quote_staging.PARTNRID__c);
				quote_staging.WarrantyContractNumber__c = warrantyEntry.WES_warranty__c;

				Dom.XmlNode childElement = getChildXmlNode(rootElement,GlobalConstants.WarrantyContractNumber);
				//Dom.XmlNode childElement = checkIfElementExists(rootElement,GlobalConstants.WarrantyContractNumber);
				if(childElement != null && childElement.getChildren() <> null ) {
					childElement.removeChild(childElement.getChildren()[0]);
					childElement.addTextNode(quote_staging.WarrantyContractNumber__c);
				}
			}

		}
		quote_staging.Request_Data__c = doc.toXMLString();
	}
	catch(Exception ex) {
		ExceptionHandler.addException(ex,GlobalConstants.QTC_QuoteProposalToStaging,GlobalConstants.MapQuoteParameter+Globalconstants.AT_LINE_NUMBER+ex.getLineNumber());
	}
	return quote_staging;
}

/******************************************************************************************************
   Name : checkIfElementExists
   Created Date: 30 September 2019
   Created by: Accenture
   Description : method for checking if the field is in any of the child elements.. uo tp 4 levels
   Quote Delivery Sales Item
 *********************************************************************************************************/
/*public Dom.XmlNode checkIfElementExists(Dom.XmlNode rootElement, String field)
   {
   Dom.XmlNode firstChildElement = rootElement.getChildElement(field,null);
   Dom.XmlNode secondChildElement;
   Dom.XmlNode thirdChildElement;
   Dom.XmlNode fourthChildElement;
   if(firstChildElement <> null){
   return firstChildElement;
   }
   else if(rootElement.getChildren() <> null){
   for(Dom.XmlNode firstChild : rootElement.getChildElements()){
   //system.debug('firstChild: '+firstChild);
   //system.debug('firstChild text:'+firstChild.getText());
   secondChildElement = firstChild.getChildElement(field,null);
   //system.debug('secondChildElement: '+secondChildElement);
   if(secondChildElement <> null)
   return secondChildElement;
   else if(!(firstChild.getName() == GlobalConstants.OPERAMT || firstChild.getName() == GlobalConstants.DATETIME_String
 ||firstChild.getName() == GlobalConstants.QUANTITY)
   && firstChild.getChildren() <> null){
   for(Dom.XmlNode secondChild : firstChild.getChildElements()){
   thirdChildElement = secondChild.getChildElement(field,null);
   //system.debug('thirdChildElement: '+thirdChildElement);
   if(thirdChildElement <> null )
   return thirdChildElement;
   else if(!(secondChild.getName() == GlobalConstants.OPERAMT || secondChild.getName() == GlobalConstants.DATETIME_String
 ||secondChild.getName() == GlobalConstants.QUANTITY)
   && secondChild.getChildren() <> null){
   for(Dom.XmlNode thirdChild : secondChild.getChildElements()){
   fourthChildElement = thirdChild.getChildElement(field,null);
   //system.debug('fourthChildElement: '+fourthChildElement);
   if(fourthChildElement <> null )
   return fourthChildElement;
   }
   }
   }
   }
   }
   }
   return null;
   }
 */

/******************************************************************************************************
   Name : mapChildNodesWithParent
   Description : method for storing the child nodes with its parent nodes
 *********************************************************************************************************/
public void mapChildNodesWithParent(String xmlbody)
{
	Dom.Document doc = new Dom.Document();
	doc.load(xmlbody);
	Dom.xmlNode rootElement = doc.getRootElement();
	for(Dom.XmlNode firstChild : rootElement.getChildElements()) {
		//parentChildNodeMap.put(firstChild.getName()+rootElement.getName(), new List<String>{rootElement.getName()});
		if(firstChild <> null && !(firstChild.getName() == GlobalConstants.OPERAMT || firstChild.getName() == GlobalConstants.DATETIME_String
								   ||firstChild.getName() == GlobalConstants.QUANTITY)
		   && firstChild.getChildren() <> null) {
			for(Dom.XmlNode secondChild : firstChild.getChildElements()) {
				if(parentChildNodeMap.get(secondChild.getName()+GlobalConstants.COMMA+rootElement.getName()) <> null)
					parentChildNodeMap.get(secondChild.getName()+GlobalConstants.COMMA+rootElement.getName()).add(firstChild.getName());
				else
					parentChildNodeMap.put(secondChild.getName()+GlobalConstants.COMMA+rootElement.getName(), new List<String> {firstChild.getName()});
				if(secondChild <> null && !(secondChild.getName() == GlobalConstants.OPERAMT || secondChild.getName() == GlobalConstants.DATETIME_String
											||secondChild.getName() == GlobalConstants.QUANTITY)
				   && secondChild.getChildren() <> null) {
					for(Dom.XmlNode thirdChild : secondChild.getChildElements()) {
						if(parentChildNodeMap.get(thirdChild.getName()+GlobalConstants.COMMA+rootElement.getName()) <> null)
							parentChildNodeMap.get(thirdChild.getName()+GlobalConstants.COMMA+rootElement.getName()).add(firstChild.getName()+GlobalConstants.COMMA+secondChild.getName());
						else
							parentChildNodeMap.put(thirdChild.getName()+GlobalConstants.COMMA+rootElement.getName(), new List<String> {firstChild.getName()+GlobalConstants.COMMA+secondChild.getName()});
						if(thirdChild <> null && !(thirdChild.getName() == GlobalConstants.OPERAMT || thirdChild.getName() == GlobalConstants.DATETIME_String
												   ||thirdChild.getName() == GlobalConstants.QUANTITY)
						   && thirdChild.getChildren() <> null) {
							for(Dom.XmlNode fourthChild: thirdChild.getChildElements()) {
								if(parentChildNodeMap.get(fourthChild.getName()+GlobalConstants.COMMA+rootElement.getName()) <> null)
									parentChildNodeMap.get(fourthChild.getName()+GlobalConstants.COMMA+rootElement.getName()).add(firstChild.getName()+GlobalConstants.COMMA+secondChild.getName()+GlobalConstants.COMMA+thirdChild.getName());
								else
									parentChildNodeMap.put(fourthChild.getName()+GlobalConstants.COMMA+rootElement.getName(), new List<String> {firstChild.getName()+GlobalConstants.COMMA+secondChild.getName()+GlobalConstants.COMMA+thirdChild.getName()});
							}
						}
					}
				}
			}
		}
	}
}

/******************************************************************************************************
   Name : getChildXmlNode
   Description : method for retrieving the corresponding child node
 *********************************************************************************************************/
public Dom.xmlNode getChildXmlNode(Dom.XmlNode rootElement, String field)
{
	Dom.XmlNode firstChildElement = rootElement;
	if(rootElement.getChildElement(field,null) <> null) {
		return rootElement.getChildElement(field,null);
	}else
	{
		//System.debug('field+element:'+field+rootElement.getName());
		if(parentChildNodeMap.get(field+GlobalConstants.COMMA+rootElement.getName()) <> null) {
			List<String> parentNodes = parentChildNodeMap.get(field+GlobalConstants.COMMA+rootElement.getName());
			if(parentNodes<> null) {
				for(String node : parentNodes) {
					for(String childNode : node.split(GlobalConstants.COMMA)) {
						firstChildElement = firstChildElement.getChildElement(childNode,null);
					}
					//system.debug('firstChildElement'+firstChildElement);
					firstChildElement = firstChildElement.getChildElement(field,null);
					//system.debug('finalChildElement'+firstChildElement);
					// if(firstChildElement <> null && (firstChildElement.getText() == null || firstChildElement.getText() == ''))
					return firstChildElement;
				}
			}
		}
	}
	return null;
}
/******************************************************************************************************
   Name : getDataFromParent
   Created Date: 20 August 2019
   Created by: Accenture
   Description : method for getting child data whenever the field from parameter has parent relationships
   Quote Delivery Sales Item
 *********************************************************************************************************/
public String getDataFromParent(String field1,sObject childObj)
{
	String parentField='',parentObject='',result,field2=''; Object objResult;
	//system.debug('field1-->'+field1);
	parentField = field1.substringAfterLast(GlobalConstants.DOT_SYMBOL);
	parentObject = field1.substringBefore(GlobalConstants.DOT_SYMBOL);
	field2 = field1.substringAfter(GlobalConstants.DOT_SYMBOL);

	if(!String.isBlank(parentField)) {
		sObject ParentObj = childObj.getSobject(parentObject);
		if(ParentObj <> null) {
			if(field2 <> parentField) {
				ParentObj = ParentObj.getSobject(field2.remove(GlobalConstants.DOT_SYMBOL+parentField));
			}
			if(ParentObj<>null)
				objResult = ParentObj.get(parentField);
			// system.debug('objResult>>>>>'+objResult);
			if(objResult <> null)
				result = String.valueOf(objResult);
		}
		//system.debug('result = '+result);
	}
	return result;
}

/******************************************************************************************************
   Name : createArcadiaOptions
   Created Date: 20 August 2019
   Created by: Accenture
   Description : method for creating a proposal line item for options available under Arcadia bundle in
   Quote Delivery Sales Item
 *********************************************************************************************************/
public void createArcadiaOptions(sObject proposalLineItem,Map<ID,Apttus_Proposal__Proposal__c> proposal_Map,String quoteNumber)
{
	//for(Quote_Delivery_Sales_Item__c quoteDeliverySI : quoteDeliverySIList)
	//{
	Quote_Delivery_Sales_Item__c quoteDeliverySI = (Quote_Delivery_Sales_Item__c)proposalLineItem;
	Quote_Staging__c quote_staging = new Quote_Staging__c();
	quote_staging.QTELINENUM__c = quoteLineNumMap.get(quoteNumber)+1;
	quote_staging.QTEID__c = quoteNumber;
	quote_staging.Quote_Number__c = quoteNumber;

	//Map the QDSI to Quote staging by the fetching the field mapping from quote parameter
	quote_staging = mapQuoteParameter(proposalLineItem,quote_staging,proposal_Map,quoteNumber,QTELINEITEM_BODY);
	quoteLineNumMap.put(quoteNumber,quoteLineNumMap.get(quoteNumber)+1);

	//Get the request data created after mapping quote paramters and add the parent line number to it
	Dom.Document doc = getDomDocument(quote_staging);
	Dom.XmlNode rootElement = doc.getRootElement();
	//String arcCodelineNum = proposalLineItem.get('Arcadia_Product_Code__c') <> null ? String.valueOf(proposalLineItem.get('Arcadia_Product_Code__c'))+String.valueOf(proposalLineItem.get(GlobalConstants.LineNumber_Field)) : '';
	//Decimal primaryLineNumber = CodeLineNumberMap.get(quoteDeliverySI.Arcadia_Product_Code__c+quoteDeliverySI.Parent_Line_Item__r.Apttus_Config2__LineNumber__c);
	//quote_staging.LUCENT_ParentLineNum__c = LineNumbersMap.get(quoteNumber+primaryLineNumber);
	quote_staging.LUCENT_ParentLineNum__c  = 0;
	Dom.XmlNode qtelineElement = rootElement.getChildElement(GlobalConstants.QTELINENUM,null);
	if(qtelineElement.getAttributeCount() > 0 && quote_staging.LUCENT_ParentLineNum__c <> null) {
		qtelineElement.setAttribute(qtelineElement.getAttributeKeyAt(0), String.valueOf(quote_staging.LUCENT_ParentLineNum__c));
	}
	quote_staging.ITEMDESC__c = arcadiaProductCodeNameMap.get(quoteDeliverySI.Product_Code__c);
	//system.debug('DESC:'+proposalLineItem.get(GlobalConstants.PRODUCTCODEFIELD));
	Dom.XmlNode itemDescElement = rootElement.getChildElement(GlobalConstants.ITEMDESC,null);
	if(itemDescElement <> null && quote_staging.ITEMDESC__c <> null) {
		itemDescElement.addTextNode(quote_staging.ITEMDESC__c);
	}

	quote_staging.Type__c = GlobalConstants.QTE_LINE_ITEM;
	Decimal curr = 0.0;
	String currData = GlobalConstants.ZEROPOINTZERO;
	createCurrencyXMLStructure(rootElement,currData,curr,proposalLineItem, GlobalConstants.BASE_Field);
	createCurrencyXMLStructure(rootElement,currData,curr,proposalLineItem, GlobalConstants.CONTRACT_Field);

	quote_staging.Request_Data__c = doc.toXmlString();
	//system.debug('quote_staging++++'+quote_staging);
	quoteStagingList.add(quote_staging);
	//}

}

/******************************************************************************************************
   Name : retrieveQuoteDeliveryOptions
   Created Date: 20 August 2019
   Created by: Accenture
   Description : method for creating a proposal line item for options available under Arcadia bundle in
   Quote Delivery Sales Item
 *********************************************************************************************************/
public List<Quote_Delivery_Sales_Item__c> retrieveQuoteDeliveryOptions(Set<Id> QuoteproposalIds,set<String> quoteDeliverySIfield_Set)
{
	String s_query = GlobalConstants.SELECTIDSTRING;
	Set<String> productSet = new Set<String>();
	if(!quoteDeliverySIfield_Set.isEmpty())
	{
		s_query = s_query + GlobalConstants.COMMA + String.join(new List<String>(quoteDeliverySIfield_Set),GlobalConstants.COMMA);
	}
	s_query = s_query + GlobalConstants.QDSIQUERYSTRING;
	List<Quote_Delivery_Sales_Item__c> qdsiList = Database.query(s_query);
	for(Quote_Delivery_Sales_Item__c quoteDeliverySI : qdsiList)
	{
		if(!arcadiaProductOptionMap.containsKey(quoteDeliverySI.Arcadia_Product_Code__c+quoteDeliverySI.Parent_Line_Item__r.Apttus_Config2__LineNumber__c))
			arcadiaProductOptionMap.put(quoteDeliverySI.Arcadia_Product_Code__c+quoteDeliverySI.Parent_Line_Item__r.Apttus_Config2__LineNumber__c, new List<Quote_Delivery_Sales_Item__c> {quoteDeliverySI});
		else{
			arcadiaProductOptionMap.get(quoteDeliverySI.Arcadia_Product_Code__c+quoteDeliverySI.Parent_Line_Item__r.Apttus_Config2__LineNumber__c).add(quoteDeliverySI);
		}
		productSet.add(quoteDeliverySI.Product_Code__c);
	}
	//system.debug('arcadiaProductOptionMap>>>'+arcadiaProductOptionMap);
	for(Product2 prod : [Select Id,ProductCode,Name
						 from Product2
						 where ProductCode = :productSet])
	{
		arcadiaProductCodeNameMap.put(prod.ProductCode, prod.Name);
	}
	return qdsiList;
}

/******************************************************************************************************
   Name : createMarketModelStaging
   Created Date: 20 August 2019
   Created by: Accenture
   Description : method for creating a staging record for Market model
 *********************************************************************************************************/
public Quote_Staging__c createMarketModelStaging(String marketModel,String quoteNumber,String FlexibleGroupCode)
{
	Dom.Document doc = new Dom.Document();
	doc.load(QTELINEITEM_BODY);
	Dom.XmlNode rootElement = doc.getRootElement();
	Quote_Staging__c stagingRec = new Quote_Staging__c();

	String modelname = marketModel;
	String [] modelArray = modelname.split(GlobalConstants.WHITESPACECHARACTER);
	String qty = modelArray[modelArray.size()-1];
	string MarketModelName = modelname.remove(qty);
	stagingRec.ITEMDESC__c = MarketModelName;
	Dom.XmlNode childElement = rootElement.getChildElement(GlobalConstants.ITEMDESC,null);
	if(childElement != null)
		childElement.addTextNode(MarketModelName);

	string Quantity = qty.substringBetween(GlobalConstants.OPENBRACKET,GlobalConstants.CLOSEBRACKET);
	stagingRec.QUANTITY__c = Decimal.valueOf(Quantity);
	Dom.XmlNode childElement1 = rootElement.getChildElement(GlobalConstants.QUANTITY,null);

	if(childElement1 <> null) {
		childElement1.getChildElement(GlobalConstants.VALUE,null).addTextNode(Quantity.remove(GlobalConstants.DOT_SYMBOL));
		Dom.XmlNode uomNode = childElement1.getChildElement(GlobalConstants.UOM,null);
		if(uomNode <> null && uomNode.getText() == '')
			uomNode.addTextNode(GlobalConstants.EA);
		childElement1.getChildElement(GlobalConstants.NUMOFDEC,null).addTextNode(String.valueOf(stagingRec.QUANTITY__c.scale()));
		childElement1.getChildElement(GlobalConstants.SIGN,null).addTextNode(Quantity.indexOf(GlobalConstants.HYPHEN) == 0 ? GlobalConstants.HYPHEN : GlobalConstants.PLUSSYMBOL);
	}

	stagingRec.QTELINENUM__c = quoteLineNumMap.get(quoteNumber)+1;
	Dom.XmlNode qtelineElement = rootElement.getChildElement(GlobalConstants.QTELINENUM,null);
	if(qtelineElement != null)
		qtelineElement.addTextNode(String.valueOf(stagingRec.QTELINENUM__c));
	stagingRec.LUCENT_ParentLineNum__c = 0;
	qtelineElement.setAttribute(qtelineElement.getAttributeKeyAt(0), GlobalConstants.ZERO);

	stagingRec.Quote_Number__c = quoteNumber;
	stagingRec.Type__c = GlobalConstants.QTE_LINE_ITEM;
	stagingRec.ITEM__c = FlexibleGroupCode;
	Dom.XmlNode childElement2 = rootElement.getChildElement(GlobalConstants.ITEM,null);
	if(childElement2 != null)
		childElement2.addTextNode(FlexibleGroupCode);

	quoteLineNumMap.put(quoteNumber,quoteLineNumMap.get(quoteNumber)+1);
	//system.debug('quoteNumber+marketModel-->'+(quoteNumber+marketModel));
	if(!marketModelsLineNum.containsKey(quoteNumber+marketModel))
		marketModelsLineNum.put(quoteNumber+marketModel,Integer.valueOf(stagingRec.QTELINENUM__c));

	stagingRec.Request_Data__c = doc.toXMLString();
	//system.debug('stagingRec'+stagingRec.Request_Data__c);
	return stagingRec;
}

/******************************************************************************************************
   Name : retreiveQuoteData
   Created Date: 20 August 2019
   Created by: Accenture
   Description : method for retrieving quote data with parent fields
 *********************************************************************************************************/
public Map<Id,Apttus_Proposal__Proposal__c> retreiveQuoteData(Set<Id> proposalIds){
	Set<String> QPfield_set = new Set<String>();
	Map<Id,Apttus_Proposal__Proposal__c> Quoteproposal_Map = new Map<Id,Apttus_Proposal__Proposal__c>();

	//get the list of mapping from quote parameter object which has filter
	for(Quote_Parameter__c q_paramap_Entry :  [Select id,Target_Field__c,Source_Field__c,Source_Object__c,Target_Object__c,
											   Parameter_Value1__c,Parameter_Value2__c,Parameter_Type__c
											   from Quote_Parameter__c
											   Where Active__c = true
																 AND Parameter_Type__c != :GlobalConstants.Direct_Value
																 AND Source_Object__c = :GlobalConstants.quoteProposal
		])
	{
		if(q_paramap_Entry.Source_Field__c <> null)
		{
			QPfield_set.addAll(q_paramap_Entry.Source_Field__c.split(GlobalConstants.COMMA));
			if(q_paramap_Entry.Parameter_Value1__c!=null && q_paramap_Entry.Parameter_Value1__c.contains(GlobalConstants.UNDERSCORE_C))
				QPfield_set.add(q_paramap_Entry.Parameter_Value1__c);
		}
	}
	system.debug('QPfield_set::' + QPfield_set);
	String s_query = GlobalConstants.SELECTIDSTRING;
	if(!QPfield_set.isEmpty()) {
		s_query = s_query + GlobalConstants.COMMA+  'NokiaCPQ_Is_7705_Exists__c,' + String.join(new List<String>(QPfield_set), GlobalConstants.COMMA) + GlobalConstants.PLIQUERYSTRING;
	}
	List<Apttus_Proposal__Proposal__c> proposalList = Database.query(s_query);
	system.debug('proposalList::' + proposalList);
	for(Apttus_Proposal__Proposal__c prop : proposalList) {
		Quoteproposal_Map.put(prop.Id,prop);
	}
	return Quoteproposal_Map;
}

/******************************************************************************************************
   Name : Quotefilter
   Created Date: 20 August 2019
   Created by: Accenture
   Description : method for filtering quotes based on criteria given on Quote Parameter
 *********************************************************************************************************/
public Map<Id,Apttus_Proposal__Proposal__c> Quotefilter(Map<Id,Apttus_Proposal__Proposal__c> Quoteproposal_Map){
	Map<Id,Apttus_Proposal__Proposal__c> Quoteproposal_PutMap = new Map<Id,Apttus_Proposal__Proposal__c>();

	//get the list of mapping from quote parameter object which has filter
	List<Quote_Parameter__c> q_paramap_Entry_list = [Select id,Target_Field__c,Source_Field__c,Source_Object__c,Target_Object__c,
													 Parameter_Value1__c,Parameter_Value2__c,Parameter_Type__c
													 from Quote_Parameter__c
													 Where Active__c = true
																	   AND Parameter_Type__c = :GlobalConstants.Entry_Criteria
																							   AND Source_Object__c = :GlobalConstants.quoteProposal
	];

	if(q_paramap_Entry_list <> null && q_paramap_Entry_list.size() > 0) {
		for(Apttus_Proposal__Proposal__c prop : Quoteproposal_Map.values())
		{
			for(Quote_Parameter__c q_paramater : q_paramap_Entry_list) {
				List<String> targetFieldsList = new List<String>();

				//If the mapping has filters on source field, then check whether
				//the quote contains the values which are mentioned in target field
				if(q_paramater.Target_Field__c <> null && q_paramater.Target_Field__c.contains(GlobalConstants.COMMA)) {
					targetFieldsList.addAll(q_paramater.Target_Field__c.split(GlobalConstants.COMMA));
				}
				else{
					targetFieldsList.add(q_paramater.Target_Field__c);
				}
				string sourceValue = string.valueof(prop.get(q_paramater.Source_Field__c));
				if(targetFieldsList.contains(sourceValue))
				{
					//If the mapping has filters on paramter values, then check whether
					//the quote has values which are there in parameters value 2 for parameter value field name
					if(q_paramater.Parameter_Value1__c <> null && q_paramater.Parameter_Value2__c <> null) {
						List<String> parameterValuesList = new List<String>();
						if(q_paramater.Parameter_Value2__c.contains(GlobalConstants.COMMA)) {
							parameterValuesList.addAll(q_paramater.Target_Field__c.split(GlobalConstants.COMMA));
						}
						else{
							parameterValuesList.add(q_paramater.Parameter_Value2__c);
						}
						string ParameterValue1 = string.valueOf(prop.get(q_paramater.Parameter_Value1__c));
						if(parameterValuesList.contains(ParameterValue1)) {
							Quoteproposal_PutMap.put(prop.ID,prop);
						}
					}
					else
						Quoteproposal_PutMap.put(prop.ID,prop);
				}
			}
		}
		return Quoteproposal_PutMap;
	}
	else{
		return Quoteproposal_Map;
	}

}

/****************************************
 * Name : finish
 * Description : finish method of batch class
 * Parameters: Database.BatchableContext
 * Returns :
 *****************************************/
global void finish(Database.BatchableContext BC)
{
	//added by surinder
	Map<String,boolean> quoteTypeWithEnableCheck= new Map<String,boolean>();
	Map<String,String> quoteNumberWithType = new Map<String,String>();
	for(QTC_IntegrationControls__c obj:[Select id,QTC_EnableWorkato__c, QTC_QuoteType__c from QTC_IntegrationControls__c]) {
		quoteTypeWithEnableCheck.put(obj.QTC_QuoteType__c,obj.QTC_EnableWorkato__c);
	}
	Set<String> workaToQuotes= new Set<String>();
	Set<String> eaiQuotes= new Set<String>();
	if(taskValuesMap.keyset()!=null && UserInfo.getFirstName() != 'SWMP') {
		for(Apttus_Proposal__Proposal__c prop:[SELECT id,NokiaCPQ_Proposal_Id__c,Quote_Type__c FROM Apttus_Proposal__Proposal__c WHERE NokiaCPQ_Proposal_Id__c IN:taskValuesMap.keyset()]) {
			quoteNumberWithType.put(prop.NokiaCPQ_Proposal_Id__c,prop.Quote_Type__c);
		}
		for(String str:taskValuesMap.keyset()) {
			if(quoteTypeWithEnableCheck.containsKey(quoteNumberWithType.get(str)) && quoteTypeWithEnableCheck.get(quoteNumberWithType.get(str))==True) {
				workaToQuotes.add(str);
			}else{
				eaiQuotes.add(str);
			}
		}
		if(workaToQuotes!=null && workaToQuotes.size()>0) {
			QTC_CreateTransactionsBatch txnObj= new QTC_CreateTransactionsBatch(workaToQuotes);
			Database.executeBatch(txnObj,1);
		}
		if(eaiQuotes!=null && eaiQuotes.size()>0) {
			Batch_SendAddQuoteMessageToEAI sendMsg = new Batch_SendAddQuoteMessageToEAI(eaiQuotes);
			Database.executeBatch(sendMsg,1);
		}
	}
	//surinder changes end
}

/****************************************
 * Name : createDateXMLStructure
 * Description : create the xml structure for Date Element
 * Parameters: RootElement, Date value, TargetField
 * Returns :
 *****************************************/
public static void createDateXMLStructure(Dom.XmlNode rootElement,DateTime dateValue, String targetField)
{
	if(rootElement.getChildElement(GlobalConstants.DATETIME_String,null) <> null) {
		for(Dom.XmlNode xmlNode : rootElement.getChildElements()) {
			if(xmlNode.getName() ==  GlobalConstants.DATETIME_String && xmlNode.getAttributeCount() > 0) {
				String attValue = xmlNode.getAttributeValue(xmlNode.getAttributeKeyAt(0),null);
				if(attValue == targetField.remove(GlobalConstants.UNDERSCORE_C)) {
					Dom.XmlNode xmlChildNode;
					xmlNode.getChildElement(GlobalConstants.YEAR,null).addTextNode(String.valueOf(dateValue.year()));
					xmlNode.getChildElement(GlobalConstants.MONTH,null).addTextNode(String.valueOf(dateValue.month()));
					xmlNode.getChildElement(GlobalConstants.DAY,null).addTextNode(String.valueOf(dateValue.day()));
					xmlChildNode = xmlNode.getChildElement(GlobalConstants.HOUR,null);
					if(xmlChildNode != null && xmlChildNode.getText() <> GlobalConstants.ZERO) {
						xmlChildNode.addTextNode(String.valueOf(dateValue.hour()));
					}
					xmlChildNode = xmlNode.getChildElement(GlobalConstants.MINUTE,null);
					if(xmlChildNode != null && xmlChildNode.getText() <> GlobalConstants.ZERO) {
						xmlNode.getChildElement(GlobalConstants.MINUTE,null).addTextNode(String.valueOf(dateValue.minute()));
					}
					xmlChildNode = xmlNode.getChildElement(GlobalConstants.SECOND,null);
					if(xmlChildNode != null && xmlChildNode.getText() <> GlobalConstants.ZERO) {
						xmlChildNode.addTextNode(String.valueOf(dateValue.second()));
					}
					xmlChildNode = xmlNode.getChildElement(GlobalConstants.SUBSECOND,null);
					if(xmlChildNode != null && xmlChildNode.getText() <> GlobalConstants.ZERO) {
						xmlChildNode.addTextNode(String.valueOf(dateValue.millisecond()));
					}
					xmlChildNode = xmlNode.getChildElement(GlobalConstants.TIMEZONE,null);
					if(xmlChildNode != null && xmlChildNode.getText() <> GlobalConstants.TRIPLEZERO) {
						xmlChildNode.addTextNode(GlobalConstants.TRIPLEZERO);
					}
				}
			}
		}
	}
}

/****************************************
 * Name : createCurrencyXMLStructure
 * Description : create the xml structure for Quantity Element
 * Parameters: RootElement,Curreny value as string,Currency value as Decimal, Source object,Field to be mapped in target
 * Returns :
 *****************************************/
public void createCurrencyXMLStructure(Dom.XmlNode rootElement,String currencyStringValue,Decimal currencyValue,sObject proposal_lineitem, String targetField)
{
	if(rootElement.getChildElement(GlobalConstants.OPERAMT,null) <> null) {
		for(Dom.XmlNode xmlNode : rootElement.getChildElements()) {
			if(xmlNode.getName() == GlobalConstants.OPERAMT && xmlNode.getAttributeCount() > 0) {
				String attValue = xmlNode.getAttributeValue(xmlNode.getAttributeKeyAt(0),null);
				if(attValue == targetField.remove(GlobalConstants.UNDERSCORE_C)) {
					String currencyValueString = currencyValue.toPlainString();
					Dom.XmlNode xmlChildNode;
					xmlChildNode = xmlNode.getChildElement(GlobalConstants.VALUE,null);
					//system.debug('currenyValueString'+currencyValueString);
					if(xmlChildNode != null && xmlChildNode.getText() <>  GlobalConstants.ZERO) {
						if(xmlChildNode.getChildren() <> null && xmlChildNode.getChildren().size() > 0) {
							xmlChildNode.removeChild(xmlChildNode.getChildren()[0]);
						}
						xmlChildNode.addTextNode(currencyValue.abs().toPlainString().remove(GlobalConstants.DOT_SYMBOL));
					}

					xmlChildNode = xmlNode.getChildElement(GlobalConstants.NUMOFDEC,null);
					if(xmlChildNode != null && xmlChildNode.getText() <> Globalconstants.TWO && xmlChildNode.getText() <> GlobalConstants.ZERO) {
						if(xmlChildNode.getChildren() <> null && xmlChildNode.getChildren().size() > 0) {
							xmlChildNode.removeChild(xmlChildNode.getChildren()[0]);
						}
						//system.debug('Decimal:'+currencyValue);
						if(currencyValueString.contains(GlobalConstants.DOT_SYMBOL)) {
							xmlChildNode.addTextNode(String.valueOf(currencyValueString.substringAfter(GlobalConstants.DOT_SYMBOL).length()));
						}
						else
							xmlChildNode.addTextNode(GlobalConstants.ZERO);
					}

					xmlChildNode = xmlNode.getChildElement(GlobalConstants.SIGN,null);
					/*//commented by jithin - as this condition will never get executed as xmlChildNode.getText() always contains a value of + from the static resource
					   if(xmlChildNode != null && (xmlChildNode.getText() == '' || xmlChildNode.getText() == null)){
					   xmlChildNode.addTextNode(currencyStringValue.indexOf(GlobalConstants.HYPHEN) == 0 ? GlobalConstants.HYPHEN : GlobalConstantS.PLUSSYMBOL);
					   }
					 */

					//added by jithin to fix the negative sign value
					if(xmlChildNode != null) {
						if(String.isNotBlank(xmlChildNode.getText())) {
							xmlChildNode.removeChild(xmlChildNode.getChildren()[0]);
						}
						xmlChildNode.addTextNode(currencyStringValue.indexOf(GlobalConstants.HYPHEN) == 0 ? GlobalConstants.HYPHEN : GlobalConstantS.PLUSSYMBOL);
					}
					xmlChildNode = xmlNode.getChildElement(GlobalConstants.CURRENCY_String,null);
					if(xmlChildNode <> null) {
						if(xmlChildNode.getChildren() <> null && xmlChildNode.getChildren().size() > 0) {
							xmlChildNode.removeChild(xmlChildNode.getChildren()[0]);
						}
						xmlChildNode.addTextNode(String.valueOf(proposal_lineitem.get(GlobalConstants.currencyISOCODE)));
					}

					xmlChildNode = xmlNode.getChildElement(GlobalConstants.UOMVALUE,null);
					if(xmlChildNode <> null && xmlChildNode.getText() <> GlobalConstants.ONE) {
						if(xmlChildNode.getChildren() <> null && xmlChildNode.getChildren().size() > 0) {
							xmlChildNode.removeChild(xmlChildNode.getChildren()[0]);
						}
						xmlChildNode.addTextNode(String.valueOf(currencyValue.intValue()));
					}

					xmlChildNode = xmlNode.getChildElement(GlobalConstants.UOMNUMDEC,null);
					if(xmlChildNode <> null && xmlChildNode.getText() <> GlobalConstants.ZERO) {
						if(xmlChildNode.getChildren() <> null && xmlChildNode.getChildren().size() > 0) {
							xmlChildNode.removeChild(xmlChildNode.getChildren()[0]);
						}
						xmlChildNode.addTextNode(GlobalConstants.ZERO);
					}

					xmlChildNode = xmlNode.getChildElement(GlobalConstants.UOM,null);
					if(xmlChildNode <> null && xmlChildNode.getText() <> GlobalConstants.EA && checkFieldInSObject(GlobalConstants.UOM_Field,proposal_lineitem)
					   && proposal_lineitem.get(GlobalConstants.UOM_Field) <> null) {
						if(xmlChildNode.getChildren() <> null && xmlChildNode.getChildren().size() > 0) {
							xmlChildNode.removeChild(xmlChildNode.getChildren()[0]);
						}
						String parameterValue1 = string.valueof(proposal_lineitem.get(GlobalConstants.UOM_Field));
						if(picklist_map.containskey(parameterValue1))
							xmlChildNode.addTextNode(picklist_map.get(parameterValue1));
					}else if(xmlChildNode <> null && xmlChildNode.getText()=='') {
						xmlChildNode.addTextNode(GlobalConstants.EA);
					}
				}
			}
		}
	}
}

/****************************************
 * Name : createRoundingAdjustmentStructure
 * Description : create the xml structure for Rounding adjustment Element
 * Parameters: RootElement,Curreny value as string,Currency value as Decimal, Source object,Field to be mapped in target
 * Returns :
 *****************************************/
public void createRoundingAdjustmentStructure(Dom.XmlNode rootElement,Decimal currencyValue,Decimal quantity,sObject proposal_lineitem, String targetField)
{
	String sign = GlobalConstants.PLUSSYMBOL;
	if(rootElement.getChildElement(GlobalConstants.OPERAMT,null) <> null) {
		for(Dom.XmlNode xmlNode : rootElement.getChildElements()) {
			if(xmlNode.getName() == GlobalConstants.OPERAMT && xmlNode.getAttributeCount() > 0) {
				String attValue = xmlNode.getAttributeValue(xmlNode.getAttributeKeyAt(0),null);
				if(attValue == targetField.remove(GlobalConstants.UNDERSCORE_C)) {
					Dom.XmlNode xmlChildNode;
					if(currencyValue <> null) {
						String currStringValue = currencyValue.toPlainString();
						Integer decimalPlace = 0;
						xmlChildNode = xmlNode.getChildElement(GlobalConstants.VALUE,null);
						if(xmlChildNode != null ) {
							if(xmlChildNode.getChildren() <> null && xmlChildNode.getChildren().size() > 0) {
								xmlChildNode.removeChild(xmlChildNode.getChildren()[0]);
							}
							if(currStringValue <> null && currStringValue.contains(GlobalConstants.DOT_SYMBOL)) {
								currStringValue = currStringValue.replaceAll('0*$','').replaceAll('\\.$','');
								decimalPlace = currStringValue.substringAfter(GlobalConstants.DOT_SYMBOL).length();
								if(currStringValue.contains(GlobalConstants.DOT_SYMBOL))
									currStringValue = currStringValue.remove(GlobalConstants.DOT_SYMBOL);
								sign = currStringValue.indexOf(GlobalConstants.HYPHEN) == 0 ? GlobalConstants.HYPHEN : GlobalConstants.PLUSSYMBOL;
								if(currStringValue.contains(GlobalConstants.HYPHEN))
									currStringValue = currStringValue.remove(GlobalConstants.HYPHEN);
							}

							xmlChildNode.addTextNode(currStringValue);
						}
						xmlChildNode = xmlNode.getChildElement(GlobalConstants.NUMOFDEC,null);
						if(xmlChildNode != null) {
							if(xmlChildNode.getChildren() <> null && xmlChildNode.getChildren().size() > 0) {
								xmlChildNode.removeChild(xmlChildNode.getChildren()[0]);
							}
							xmlChildNode.addTextNode(String.valueOf(decimalPlace));
						}
						xmlChildNode = xmlNode.getChildElement(GlobalConstants.SIGN,null);
						if(xmlChildNode != null) {
							if(xmlChildNode.getChildren() <> null && xmlChildNode.getChildren().size() > 0) {
								xmlChildNode.removeChild(xmlChildNode.getChildren()[0]);
							}
							xmlChildNode.addTextNode(sign);
						}
					}else{
						xmlChildNode = xmlNode.getChildElement(GlobalConstants.SIGN,null);
						if(xmlChildNode != null && (xmlChildNode.getText() == '' || xmlChildNode.getText() == null)) {
							xmlChildNode.addTextNode(sign);
						}
					}

					xmlChildNode = xmlNode.getChildElement(GlobalConstants.CURRENCY_String,null);
					if(xmlChildNode <> null) {
						if(xmlChildNode.getChildren() <> null && xmlChildNode.getChildren().size() > 0) {
							xmlChildNode.removeChild(xmlChildNode.getChildren()[0]);
						}
						xmlChildNode.addTextNode(String.valueOf(proposal_lineitem.get(GlobalConstants.currencyISOCODE)));
					}

					xmlChildNode = xmlNode.getChildElement(GlobalConstants.UOMVALUE,null);
					if(xmlChildNode <> null ) {//&& xmlChildNode.getText() <> GlobalConstants.ONE){
						if(xmlChildNode.getChildren() <> null && xmlChildNode.getChildren().size() > 0)
						{
							xmlChildNode.removeChild(xmlChildNode.getChildren()[0]);
						}
						xmlChildNode.addTextNode(String.valueOf(quantity.intValue()));
					}

					xmlChildNode = xmlNode.getChildElement(GlobalConstants.UOMNUMDEC,null);
					if(xmlChildNode <> null && xmlChildNode.getText() <> GlobalConstants.ZERO) {
						if(xmlChildNode.getChildren() <> null && xmlChildNode.getChildren().size() > 0) {
							xmlChildNode.removeChild(xmlChildNode.getChildren()[0]);
						}
						xmlChildNode.addTextNode(GlobalConstants.ZERO);
					}

					xmlChildNode = xmlNode.getChildElement(GlobalConstants.UOM,null);
					if(xmlChildNode <> null && xmlChildNode.getText() <> GlobalConstants.EA && checkFieldInSObject(GlobalConstants.UOM_Field,proposal_lineitem)
					   && proposal_lineitem.get(GlobalConstants.UOM_Field) <> null) {
						if(xmlChildNode.getChildren() <> null && xmlChildNode.getChildren().size() > 0) {
							xmlChildNode.removeChild(xmlChildNode.getChildren()[0]);
						}
						String parameterValue1 = string.valueof(proposal_lineitem.get(GlobalConstants.UOM_Field));
						if(picklist_map.containskey(parameterValue1))
							xmlChildNode.addTextNode(picklist_map.get(parameterValue1));
					}else if(xmlChildNode <> null && xmlChildNode.getText()=='') {
						xmlChildNode.addTextNode(GlobalConstants.EA);
					}
				}
			}
		}
	}
}

/****************************************
 * Name : createQuantityXMLStructure
 * Description : create the xml structure for Quantity Element
 * Parameters: Database.BatchableContext
 * Returns :
 *****************************************/
public void createQuantityXMLStructure(Dom.XmlNode rootElement,String currencyStringValue,Decimal currencyValue,sObject proposal_lineitem, String targetField)
{
	if(rootElement.getChildElement(GlobalConstants.QUANTITY,null) <> null) {
		for(Dom.XmlNode xmlNode : rootElement.getChildElements()) {
			if(xmlNode.getName() == GlobalConstants.QUANTITY && xmlNode.getAttributeCount() > 0) {
				if(xmlNode.getName() == targetField.remove(GlobalConstants.UNDERSCORE_C)) {
					Dom.XmlNode xmlChildNode;
					xmlChildNode = xmlNode.getChildElement(GlobalConstants.VALUE,null);
					if(xmlChildNode != null && xmlChildNode.getText() <> GlobalConstants.ZERO) {
						if(xmlChildNode.getChildren() <> null && xmlChildNode.getChildren().size() > 0) {
							xmlChildNode.removeChild(xmlChildNode.getChildren()[0]);
						}
						xmlChildNode.addTextNode(currencyValue.abs().toPlainString().remove(GlobalConstantS.DOT_SYMBOL));
					} xmlChildNode = xmlNode.getChildElement(GlobalConstants.NUMOFDEC,null);
					if(xmlChildNode != null && xmlChildNode.getText() <> GlobalConstants.ZERO) {
						if(xmlChildNode.getChildren() <> null && xmlChildNode.getChildren().size() > 0) {
							xmlChildNode.removeChild(xmlChildNode.getChildren()[0]);
						}
						xmlChildNode.addTextNode(String.valueOf(currencyValue.scale()));
					}
					xmlChildNode = xmlNode.getChildElement(GlobalConstants.UOM,null);
					if(xmlChildNode != null && xmlChildNode.getText() <> GlobalConstants.EA && checkFieldInSObject(GlobalConstants.UOM_Field,proposal_lineitem)
					   && proposal_lineitem.get(GlobalConstants.UOM_Field) <> null) {
						if(xmlChildNode.getChildren() <> null && xmlChildNode.getChildren().size() > 0) {
							xmlChildNode.removeChild(xmlChildNode.getChildren()[0]);
						}
						String parameterValue1 = string.valueof(proposal_lineitem.get(GlobalConstants.UOM_Field));
						if(picklist_map.containskey(parameterValue1))
							xmlChildNode.addTextNode(picklist_map.get(parameterValue1));
					}else if(xmlChildNode != null && xmlChildNode.getText() == '') {
						xmlChildNode.addTextNode(GlobalConstants.EA);
					}

					xmlChildNode = xmlNode.getChildElement(GlobalConstants.SIGN,null);
					if(xmlChildNode != null && xmlChildNode.getText() <> GlobalConstants.ZERO) {
						if(xmlChildNode.getChildren() <> null && xmlChildNode.getChildren().size() > 0) {
							xmlChildNode.removeChild(xmlChildNode.getChildren()[0]);
						}
						xmlChildNode.addTextNode(currencyStringValue.indexOf(GlobalConstants.HYPHEN) == 0 ? GlobalConstants.HYPHEN : GlobalConstants.PLUSSYMBOL);
					}
				}
			}
		}
	}
}

/****************************************
 * Name : checkFieldInSObject
 * Description : checks if the field is in sobject
 * Parameters: Proposal map
 * Returns :
 *****************************************/
public Boolean checkFieldInSObject(String fieldName, SObject so){
	return so.getSobjectType().getDescribe().fields.getMap().keySet().contains(fieldName.toLowerCase());
}

/****************************************
 * Name : deleteStaging
 * Description : method to delete Quote Staging records if they already exists
 * Parameters: Proposal map
 * Returns :
 *****************************************/
public void deleteStaging(Map<Id,Apttus_Proposal__Proposal__c> Qproposal_Map){

	Map<Id,Quote_Staging__c> QuoteStaging_Map  = new Map<Id,Quote_Staging__c>([select id,Quote_Number__c,Type__c
																			   from Quote_Staging__c
																			   where Quote_Number__c IN: taskValuesMap.keySet()]);
	//system.debug('QuoteStaging_Map for delete-->'+QuoteStaging_Map);

	if(QuoteStaging_Map != null)
		database.delete(QuoteStaging_Map.values(),false);

}

}