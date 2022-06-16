/****************************************************************
* Class Name : HWS_QuoteUpdation 
* Created Date: 18 Nov 2021
* Created By: TCS
* Description : Controller class is called form CH Event Flow and HWS_QuoteActions for Sync Price
* Test class : HWS_QuoteActions_Test
* Modification Log:
---------------------------------------------------------
Modified By	 Modified For US#	Modified Date
TCS	Modify Status Cancelled to 
	On hold when discount record is not found
	Changed where condition in the fee and discount table
*****************************************************************/
public with sharing Class HWS_QuoteUpdation
{
	// This method is called from CH Event Flow. It will get a list of quotes
	@InvocableMethod
	public static void ProcessQuotes(List<Id> quoteIds){
		HWS_QuoteUpdation.QuoteUpdate(quoteIds, true, false);
	}
	// This method is called from CH Event Flow. And Sync Button. If runSync == true then code will not update admin fields. 
	// if updateQuoteAndLineItem is true then code will update the admin fields and price/discount fields as well.
	public static string QuoteUpdate(List<Id> quoteIds, boolean updateQuoteAndLineItem, boolean runSync){
	List<HWS_Service_Quote__c> lstQuote = [SELECT id,HWS_Return_Part_Received_Date__c,HWS_Quote_Status__c,HWS_Quote_Status_Reason__c,HWS_Part_Number_Reported__c,HWS_CDB_ContractLineItemID__c,Part_Number_Reported_Id__c,RecordTypeId,HWS_CaresAgreementUniqueId__c,OwnerId,HWS_Quote_Expiration_Days__c,HWS_Order_Code__c,HWS_Quote_Eligibility_Days__c,HWS_Escalation_Manager__c,HWS_Customer_ContactId_1__c,HWS_Quotation_Contact_Email__c,HWS_Quotation_Contact_Phone__c,HWS_Quotation_Contact__c,HWS_Minimal_Quote_Price__c,HWS_WorkGroupType__c,Recordtype.name,HWS_Is_Quotable__c,HWS_LSP_Serial_Number_Received__c,HWS_Earliest_Quotation_Send_Date__c,HWS_Nokia_Email__c,HWS_Customer_Contact_2__c,HWS_Customer_Contact_Email_2__c,  HWS_Customer_ContactId2__c, HWS_Customer_Contact_Phone_2__c from HWS_Service_Quote__c WHERE id in :quoteIds];
	list<string> pricefieldlst = new list<string>();
		map<string,schema.sobjectfield> priced= HWS_ServiceFeeDetails__c.sobjectType.getdescribe().fields.getmap();
		for(schema.SObjectField curr : priced.values()){
			schema.DescribeFieldResult flds = curr.getdescribe();	   
			if(flds.getname().contains('Fee'))
			pricefieldlst.add(flds.getname());
		}
		set<string> sProduct = new  set<string>();
		set<string> sContractLineItemID = new  set<string>();
		set<string> sCaresAgreementUniqueId = new  set<string>();
		for(HWS_Service_Quote__c c: lstQuote){
			if(c.Part_Number_Reported_Id__c != null && c.Part_Number_Reported_Id__c !='')
				sProduct.add(c.Part_Number_Reported_Id__c);
			if(c.HWS_CDB_ContractLineItemID__c != null && c.HWS_CDB_ContractLineItemID__c !='')
				sContractLineItemID.add(c.HWS_CDB_ContractLineItemID__c);
			if(c.HWS_CaresAgreementUniqueId__c != null && c.HWS_CaresAgreementUniqueId__c !='')
				sCaresAgreementUniqueId.add(c.HWS_CaresAgreementUniqueId__c);
		}
		string val = string.join(pricefieldlst,',');
		List<HWS_ServiceFeeDetails__c> lstPrice = new List<HWS_ServiceFeeDetails__c>();
		if(sProduct != null && sProduct.size()> 0){
			string priceQStr = 'select id,HWS_SupportedQuoteTypes__c,HWS_Product__c, '+ val.removeEnd(',')+'  FROM HWS_ServiceFeeDetails__c WHERE HWS_Status__c=\'Active\' and HWS_Product__c IN '+ DML_SObject.setToString(sProduct);		
			lstPrice =DML_SObject.doQuery(priceQStr,true); /// without Sharining true
		}
		
		map<string, HWS_ServiceFeeDetails__c> mpProductToFee = new map<string, HWS_ServiceFeeDetails__c>();
		map<id, HWS_ServiceFeeDetails__c> mpQuoteToFee = new map<id, HWS_ServiceFeeDetails__c>();

		for(HWS_ServiceFeeDetails__c q: lstPrice){   
	string rType = q.HWS_SupportedQuoteTypes__c; 
	rType = rType.replace(' ', '');   
	rType = rType.toLowerCase();
			List<string>lstrType = rType.split(';');
	for(string s :lstrType){
	mpProductToFee.put(q.HWS_Product__c+'-'+s, q );
	}
		}

		for(HWS_Service_Quote__c q: lstQuote){
			String recordTypeName = Schema.SObjectType.HWS_Service_Quote__c.getRecordTypeInfosById().get(q.RecordTypeId).getName();
			recordTypeName = recordTypeName.replaceAll('Quote', ''); 
			recordTypeName = recordTypeName.replace(' ', '');
			recordTypeName = recordTypeName.toLowerCase();  
		  
			HWS_ServiceFeeDetails__c Fee = mpProductToFee.get(q.Part_Number_Reported_Id__c+'-'+recordTypeName);		
			mpQuoteToFee.put(q.id, Fee);
		}


		list<string> discountFieldLst = new list<string>();
		map<string,schema.sobjectfield> discountfields= HWS_ServiceFee_Discount__c.sobjectType.getdescribe().fields.getmap();
		for(schema.SObjectField curr : discountfields.values()){
			schema.DescribeFieldResult flds = curr.getdescribe();	   
			if(flds.getname().contains('Discount'))
			discountFieldLst.add(flds.getname());
		}
		val = string.join(discountFieldLst,',');
		List<HWS_ServiceFee_Discount__c> lstDiscount = new List<HWS_ServiceFee_Discount__c>();
		if(sContractLineItemID != null && sCaresAgreementUniqueId != null){
			if( sContractLineItemID.size()>0 && sCaresAgreementUniqueId.size()>0){
	string DiscountStr = 'select id,HWS_CaresAgreementUniqueId__c,HWS_SupportedQuoteTypes__c,HWS_Quote_Eligilibilty_Days__c, HWS_Quote_Expiration_Days__c,HWS_Service_Assurance_Manager__c,HWS_Quotation_Contact__c,HWS_QuotationContactEmail__c ,HWS_Quotation_Contact_Phone__c,HWS_QuotationContactName__c,HWS_Minimal_Quote_Price__c,HWS_Nokia_Email__c,HWS_Customer_Contact_2__c,HWS_Customer_Contact_2_Email__c,HWS_Customer_Contact_2_Phone__c,HWS_Customer_Contact_2_Name__c,  '+ val.removeEnd(',')+'  FROM HWS_ServiceFee_Discount__c WHERE HWS_Status__c=\'Active\' and (HWS_LineItemDiscountUniqueId__c IN '+ DML_SObject.setToString(sContractLineItemID) +' OR HWS_CaresAgreementUniqueId__c IN ' + DML_SObject.setToString(sCaresAgreementUniqueId) +' )';
	lstDiscount =DML_SObject.doQuery(DiscountStr,true); /// without sharining
			}
			else if(sContractLineItemID.size() == 0 && sCaresAgreementUniqueId.size()>0){
	string DiscountStr = 'select id,HWS_CaresAgreementUniqueId__c,HWS_SupportedQuoteTypes__c,HWS_Quote_Eligilibilty_Days__c, HWS_Quote_Expiration_Days__c,HWS_Service_Assurance_Manager__c,HWS_Quotation_Contact__c,HWS_QuotationContactEmail__c ,HWS_Quotation_Contact_Phone__c,HWS_QuotationContactName__c,HWS_Minimal_Quote_Price__c,HWS_Nokia_Email__c,HWS_Customer_Contact_2__c,HWS_Customer_Contact_2_Email__c,HWS_Customer_Contact_2_Phone__c,HWS_Customer_Contact_2_Name__c,  '+ val.removeEnd(',')+'  FROM HWS_ServiceFee_Discount__c WHERE HWS_Status__c=\'Active\' and  HWS_CaresAgreementUniqueId__c IN ' + DML_SObject.setToString(sCaresAgreementUniqueId);
	lstDiscount =DML_SObject.doQuery(DiscountStr,true); /// without sharining
			}
			else if(sContractLineItemID.size() > 0 && sCaresAgreementUniqueId.size() == 0){
	string DiscountStr = 'select id,HWS_CaresAgreementUniqueId__c,HWS_SupportedQuoteTypes__c,HWS_Quote_Eligilibilty_Days__c, HWS_Quote_Expiration_Days__c,HWS_Service_Assurance_Manager__c,HWS_Quotation_Contact__c,HWS_QuotationContactEmail__c ,HWS_Quotation_Contact_Phone__c,HWS_QuotationContactName__c,HWS_Minimal_Quote_Price__c,HWS_Nokia_Email__c,HWS_Customer_Contact_2__c,HWS_Customer_Contact_2_Email__c,HWS_Customer_Contact_2_Phone__c,HWS_Customer_Contact_2_Name__c,  '+ val.removeEnd(',')+'  FROM HWS_ServiceFee_Discount__c WHERE HWS_Status__c=\'Active\' and  HWS_LineItemDiscountUniqueId__c IN ' + DML_SObject.setToString(sContractLineItemID);
	lstDiscount =DML_SObject.doQuery(DiscountStr,true); /// without sharining
			}
		}
		map<string, HWS_ServiceFee_Discount__c> mpLineItemIdToDiscount = new map<string, HWS_ServiceFee_Discount__c>();
		map<string, HWS_ServiceFee_Discount__c> mpAgreementUniqueIdToDiscount = new map<string, HWS_ServiceFee_Discount__c>();
		map<id, HWS_ServiceFee_Discount__c> mpQuoteToDiscount = new map<id, HWS_ServiceFee_Discount__c>();
		for(HWS_ServiceFee_Discount__c d :lstDiscount){
			string rTypeD = d.HWS_SupportedQuoteTypes__c;
			rTypeD = rTypeD.replace(' ', '');
			rTypeD = rTypeD.toLowerCase();
			List<string>lstrTypeDis = rTypeD.split(';');
	for(string s :lstrTypeDis){
	mpLineItemIDToDiscount.put(d.HWS_LineItemDiscountUniqueId__c+'-'+s, d);
	mpAgreementUniqueIdToDiscount.put(d.HWS_CaresAgreementUniqueId__c+'-'+s, d);
	}
		}
		for(HWS_Service_Quote__c d :lstQuote){
			String recordTypeName = Schema.SObjectType.HWS_Service_Quote__c.getRecordTypeInfosById().get(d.RecordTypeId).getName();
			recordTypeName = recordTypeName.replaceAll('Quote', ''); 
			recordTypeName = recordTypeName.replace(' ', '');
			recordTypeName = recordTypeName.toLowerCase(); 
			HWS_ServiceFee_Discount__c Discount = mpLineItemIDToDiscount.get(d.HWS_CDB_ContractLineItemID__c+'-'+recordTypeName);
			if(Discount == null){
	Discount = mpAgreementUniqueIdToDiscount.get(d.HWS_CaresAgreementUniqueId__c+'-'+recordTypeName);
			}
			mpQuoteToDiscount.put(d.id, Discount);
		}

		List<HWS_Service_Quote_Line_Item__c> lstQL = [SELECT id,Fee_Type_Field_Name__c,HWS_Unit_List_Price__c,HWS_Repairable__c,HWS_Exclusion_Category__c,Service_Quote__c from HWS_Service_Quote_Line_Item__c where Service_Quote__c in :quoteIds and HWS_Fee_Inclusion__c = true];
		map<id, List<HWS_Service_Quote_Line_Item__c>> mpQuoteLine = new map<id, List<HWS_Service_Quote_Line_Item__c>>();
		for(HWS_Service_Quote_Line_Item__c q :lstQL){
			if(mpQuoteLine == null || mpQuoteLine.get(q.Service_Quote__c ) == null){
	List<HWS_Service_Quote_Line_Item__c> rt = new List<HWS_Service_Quote_Line_Item__c>();
	rt.add(q);
	mpQuoteLine.put(q.Service_Quote__c ,  rt);
			}
			else{
	List<HWS_Service_Quote_Line_Item__c> rt = mpQuoteLine.get(q.Service_Quote__c);
	rt.add(q);
	mpQuoteLine.put(q.Service_Quote__c , rt);
			}
	
		}

		map<string,schema.sobjectfield> allMetaF= HWS_Quotation_Exclusion_Mapping__mdt.sobjectType.getdescribe().fields.getmap();
		list<string> allMetaFields = new list<string>();
		for(schema.SObjectField curr : allMetaF.values()){
			schema.DescribeFieldResult flds = curr.getdescribe();	  
			allMetaFields.add(flds.getname());
		}
		val = string.join(allMetaFields,',');
		string soqlMeta = 'select '+ val.removeEnd(',')+'  FROM HWS_Quotation_Exclusion_Mapping__mdt';
		List<HWS_Quotation_Exclusion_Mapping__mdt> ExclusionMeta =database.query(soqlMeta);
		id currentUser = UserInfo.getUserId();
		map<id,boolean> returnMe = new map<id,boolean>();
		List<PermissionSetAssignment> lstUserPermission = [select Id,PermissionSet.Name from PermissionSetAssignment where Assignee.Id =:UserInfo.getUserId() AND PermissionSet.Label in ('HWS_CustomerDeliveryManager')];
	if(runSync && (currentUser != lstQuote[0].ownerId || lstUserPermission.size()==0 || lstQuote[0].HWS_WorkGroupType__c !='Exclusions Quotation Support-CDM' )){
	 HWS_QuoteActions.throwException();
	}
	else{
	 returnMe =  HWS_QuoteUpdation.checkForPriceSync(mpQuoteToFee,mpQuoteToDiscount,lstQuote,ExclusionMeta,mpQuoteLine,updateQuoteAndLineItem, runSync);
	}
	if(runSync && !updateQuoteAndLineItem){
	 for(HWS_Service_Quote__c q :lstQuote){	  
	if(!returnMe.get(q.id) ){
		return 'error';
	}
			} 
	}
	return 'ok';	
	}


	public static map<id,boolean> checkForPriceSync(map<id, HWS_ServiceFeeDetails__c> quoteToFee, map<id, HWS_ServiceFee_Discount__c> QuoteToDiscount, List<HWS_Service_Quote__c> lstQuote,List<HWS_Quotation_Exclusion_Mapping__mdt> lstExclusionMeta,map<id, List<HWS_Service_Quote_Line_Item__c>> QuoteLine ,boolean updateQuoteAndLineItem, boolean runSync){
		map<id, boolean>mpCheckForPrice = new map<id, boolean>();
		if(lstQuote.size()> 0){			
			
			List<HWS_Service_Quote_Line_Item__c> lstUpdateQL = new List<HWS_Service_Quote_Line_Item__c> ();
			Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();			
			Schema.SObjectType leadSchema = schemaMap.get('HWS_ServiceFeeDetails__c');
			Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
			List<HWS_Service_Quote__c>quoteToUpdate = new List<HWS_Service_Quote__c>();
			for(HWS_Service_Quote__c quote : lstQuote){
	
	//if(lstQuote.size()> 0 && currentUser == quote.OwnerId && !string.ISBLANK(quote.HWS_Part_Number_Reported__c) && !string.ISBLANK(quote.HWS_CDB_ContractLineItemID__c)){ 
	if(lstQuote.size()> 0 && !string.ISBLANK(quote.HWS_CDB_ContractLineItemID__c)){
		if(QuoteToDiscount != null && QuoteToDiscount.get(quote.id) == null){				
				mpCheckForPrice.put(quote.id, false);
				if(updateQuoteAndLineItem){
		quote.HWS_Quote_Status__c = 'Cancelled';
		quote.HWS_Quote_Status_Reason__c = 'Line Item not Enabled for Quotation';
				}
		}		  
		else{ 
			// Updating the admin fields after Discount table check
			if(updateQuoteAndLineItem){				
				if(quote.HWS_Quote_Status__c != 'On hold' && quote.HWS_Quote_Status__c != 'Cancelled')
			quote.HWS_Quote_Status__c = 'In Progress';  
				if(QuoteToDiscount.get(quote.id) != null){
		if( QuoteToDiscount.get(quote.id).get('HWS_Quote_Eligilibilty_Days__c') != null)
			quote.HWS_Quote_Eligibility_Days__c = integer.valueof(QuoteToDiscount.get(quote.id).get('HWS_Quote_Eligilibilty_Days__c'));
		if( QuoteToDiscount.get(quote.id).get('HWS_Quote_Expiration_Days__c') != null)
			quote.HWS_Quote_Expiration_Days__c = integer.valueof(QuoteToDiscount.get(quote.id).get('HWS_Quote_Expiration_Days__c'));		 
		if(QuoteToDiscount.get(quote.id).get('HWS_Service_Assurance_Manager__c') != null)		 
			quote.HWS_Escalation_Manager__c = Id.valueOf(string.valueof(QuoteToDiscount.get(quote.id).get('HWS_Service_Assurance_Manager__c')));
		if(QuoteToDiscount.get(quote.id).get('HWS_Quotation_Contact__c') != null) 
			quote.HWS_Customer_ContactId_1__c = string.valueof(QuoteToDiscount.get(quote.id).get('HWS_Quotation_Contact__c'));
		if(QuoteToDiscount.get(quote.id).get('HWS_QuotationContactEmail__c') != null) 
			quote.HWS_Quotation_Contact_Email__c = string.valueof(QuoteToDiscount.get(quote.id).get('HWS_QuotationContactEmail__c'));
		if(QuoteToDiscount.get(quote.id).get('HWS_Quotation_Contact_Phone__c') != null) 
			quote.HWS_Quotation_Contact_Phone__c = string.valueof(QuoteToDiscount.get(quote.id).get('HWS_Quotation_Contact_Phone__c'));
		if(QuoteToDiscount.get(quote.id).get('HWS_Customer_Contact_2__c') != null) 
			quote.HWS_Customer_ContactId2__c = string.valueof(QuoteToDiscount.get(quote.id).get('HWS_Customer_Contact_2__c'));
		if(QuoteToDiscount.get(quote.id).get('HWS_Customer_Contact_2_Email__c') != null) 
			quote.HWS_Customer_Contact_Email_2__c = string.valueof(QuoteToDiscount.get(quote.id).get('HWS_Customer_Contact_2_Email__c'));
		if(QuoteToDiscount.get(quote.id).get('HWS_Customer_Contact_2_Phone__c') != null) 
			quote.HWS_Customer_Contact_Phone_2__c = string.valueof(QuoteToDiscount.get(quote.id).get('HWS_Customer_Contact_2_Phone__c'));
		if(QuoteToDiscount.get(quote.id).get('HWS_Customer_Contact_2_Name__c') != null)
			quote.HWS_Customer_Contact_2__c = string.valueof(QuoteToDiscount.get(quote.id).get('HWS_Customer_Contact_2_Name__c'));
		if(QuoteToDiscount.get(quote.id).get('HWS_Nokia_Email__c') != null)
			quote.HWS_Nokia_Email__c = string.valueof(QuoteToDiscount.get(quote.id).get('HWS_Nokia_Email__c'));


		if(QuoteToDiscount.get(quote.id).get('HWS_QuotationContactName__c') != null)
			quote.HWS_Quotation_Contact__c = string.valueof(QuoteToDiscount.get(quote.id).get('HWS_QuotationContactName__c'));
		if(QuoteToDiscount.get(quote.id).get('HWS_Minimal_Quote_Price__c') != null)
		quote.HWS_Minimal_Quote_Price__c = integer.valueof(QuoteToDiscount.get(quote.id).get('HWS_Minimal_Quote_Price__c'));
				}		
			}   

			if(quoteToFee == null || quoteToFee.get(quote.id)== null){		
				mpCheckForPrice.put(quote.id, false);
				if(updateQuoteAndLineItem){
		quote.HWS_Quote_Status__c = 'On Hold';
		quote.HWS_Quote_Status_Reason__c = 'Missing Price Record';
				}
			}
			else{		
				map<string,HWS_Quotation_Exclusion_Mapping__mdt> priceTypeToMeta = new map<string, HWS_Quotation_Exclusion_Mapping__mdt>();
				for(HWS_Quotation_Exclusion_Mapping__mdt ob : lstExclusionMeta){
		string skey = ob.HWS_Reason_Category__c+','+ob.HWS_Repairable__c;
		priceTypeToMeta.put(skey, ob);
				}
				List<HWS_Service_Quote_Line_Item__c> lstQL = new List<HWS_Service_Quote_Line_Item__c>();
				lstQL = QuoteLine.get(quote.id);				
				string sOrderCode = '';
				if(lstQL == null || lstQL.size()==0){
		mpCheckForPrice.put(quote.id, false);
		quote.HWS_Quote_Status__c = 'On Hold';
		quote.HWS_Quote_Status_Reason__c = 'Category Error';
				}		  
				else{	  
				  
		for(HWS_Service_Quote_Line_Item__c ob : lstQL){
			HWS_Quotation_Exclusion_Mapping__mdt metarecord = priceTypeToMeta.get(ob.HWS_Exclusion_Category__c +','+ob.HWS_Repairable__c );			
			if(metarecord == null){
				mpCheckForPrice.put(quote.id, false);
				quote.HWS_Quote_Status__c = 'On Hold';
				quote.HWS_Quote_Status_Reason__c = 'Category Error';
			}
			else if(mpCheckForPrice.get(quote.id) != false){		  
				sOrderCode = metarecord.HWS_Order_Code__c;
				quote.HWS_Order_Code__c = sOrderCode; // Admin Field
				quote.HWS_Quote_Status__c = 'In Progress';
				quote.HWS_Quote_Status_Reason__c = '';
				ob.HWS_Unit_List_Price__c = decimal.valueof(string.valueof(quoteToFee.get(quote.id).get(metarecord.HWS_SRM_Price_Type__c)));  
				ob.HWS_Discount__c =decimal.valueof(string.valueof(QuoteToDiscount.get(quote.id).get(metarecord.HWS_SRM_Discount_Type__c)));
				ob.HWS_Description__c = fieldMap.get(metarecord.HWS_SRM_Price_Type__c).getDescribe().getLabel();
				lstUpdateQL.add(ob);
			}			
		}
				}
		
				
			}
			
		}		
		quoteToUpdate.add(quote);
	}
	else{	   
		mpCheckForPrice.put(quote.id, false);
	}
	if(mpCheckForPrice.get(quote.id) != false)
		mpCheckForPrice.put(quote.id, true);
			}
			
			try{ 
	if(lstUpdateQL.size()>0 )
		DML_SObject.doUpdate(lstUpdateQL,true,false,true);
	if(quoteToUpdate.size()>0 ) 
		DML_SObject.doUpdate(quoteToUpdate,true,false,true);
	}
	catch (Exception e) {
	 String errorMsg = e.getMessage();
	 if(runSync)
		throw new AuraHandledException(errorMsg);
	}			
		}
		else{
			if(runSync)
	HWS_QuoteActions.throwException();
			return null;
		}
		return mpCheckForPrice;
	}
	
}