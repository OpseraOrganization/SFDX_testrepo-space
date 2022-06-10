/*******************************
Class Name: CQ_CloneQuoteController
Created by: Accenture
Created Date: 22 April 2019
Last modified by: Accenture
Last modified date:  
Description: Contracted Quote Clone Apex Controller
*******************************/
public without sharing class CQ_CloneQuoteController {
	Private static final Id CQ_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get(Label.CQ_RecordTypeId).getRecordTypeId();
	////Added by Rajitha
	Private static final Id NCQ_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_NCQ_Quote').getRecordTypeId();
	Private static final Id CQ_new_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_CQ_Quote').getRecordTypeId();
	/*******************************
Method Name: fetchquoteDetails
Description:  
Parameters: Quote/Proposal record id
*******************************/
	@AuraEnabled
	public static Apttus_Proposal__Proposal__c fetchquoteDetails(String quoteId){
		Apttus_Proposal__Proposal__c quo = new Apttus_Proposal__Proposal__c();
		try{
			quo = [Select Apttus_Proposal__Proposal_Name__c,NokiaCPQ_Proposal_Id__c,Apttus_Proposal__Opportunity__c,
	   Apttus_Proposal__Account__c,Apttus_Proposal__Account__r.Name,Account_Legal_Entity__c,Account_Legal_Entity__r.Name,
	   CQ_Customer_Organization_Segment__c,Apttus_Proposal__Description__c,CQ_Notes__c,CQ_Customer_Request_Number__c,
	   CQ_Customer_Project_Code__c,CQ_Customer_Project_Site_City__c,CQ_Customer_Project_Site_State__c,CQ_Master_Quote__c,
	   CQ_Master_Quote_Quantity__c,CQ_Sales_Lead__c,CQ_Lead__c,CQ_Lead__r.Name,CQ_Sales_Lead__r.Name,CQ_Servies_components__c,
	   CPQ_Pricing_Pool__c,CPQ_Contractual_Price_Condition__c,CPQ_Contractual_Price_Condition_Code__c,CPQ_CLLI_ID__c,CPQ_SSF_Billing_Rule_ID__c,
	   CPQ_Include_Transportation__c,CPQ_Display_FRU_Items__c,CPQ_Scope_of_Work__c,CPQ_Assumptions__c,CPQ_Report_Notes__c
	   FROM Apttus_Proposal__Proposal__c 
	   WHERE Id =: quoteId LIMIT 1];
			quo.RecordTypeId = CQ_RecId;
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.CQ_CLONEQUOTECONTROLLER , GlobalConstants.CQ_FETCHQUOTEDETAILS);
		}
		return quo;
	}
	
	/*******************************
Method Name: fetchpicklistValues
Description:  
Parameters: Quote/Proposal record id
*******************************/
	@AuraEnabled
	 public static List <String> fetchpicklistValues(String field) {
		List<String> plValues = new List<String>();
		try{
			//Get the object type from object name
			Schema.SObjectType objType = Schema.getGlobalDescribe().get(GlobalConstants.QUOTE_PROPOSAL_OBJECT);
			//Describe the sObject using its object type.
			Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
			//Get the specific field information from field name. 
			Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get(field).getDescribe();
			//Get the picklist field values.
			List<Schema.PicklistEntry> picklistvalues = objFieldInfo.getPicklistValues();
			//Add the picklist values to list.
			for(Schema.PicklistEntry plv: picklistvalues) {
	plValues.add(plv.getValue());
			}
			//plValues.sort();
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.CQ_REBIDQUOTECONTROLLER , GlobalConstants.CQ_FETCHPICKLISTVALUES);
		}
		return plValues;
	}
	/*******************************
Method Name: fetchUser
Description:  
Parameters: Quote/Proposal record id
*******************************/
	@AuraEnabled
	public static quoteWrapper fetchUser(String cqid, String salesid){
		//System.debug('cqid & SalesId ::> '+cqid+salesid);
		quoteWrapper quoWrap = new quoteWrapper();
		try{
			for(User cquser : [Select Id,Name from User WHERE Id =: cqid OR Id =: salesid])
			{
	if(cquser.Id == cqid)
		quoWrap.cqObj = cquser;
	if(cquser.Id == salesid)
		quoWrap.salesObj = cquser;
			}
		}
		Catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.CQ_CLONEQUOTECONTROLLER , GlobalConstants.CQ_FETCHUSER);
		}
		return quoWrap;
	}
	
	/*******************************
Method Name: getQuoteTeam
Description:  
Parameters: Quote/Proposal record id
*******************************/
	@AuraEnabled
	public static List<quoteWrapper> getQuoteTeam(String quoId){
		List<User> quoUserList = new List<User>();
		set<Id> userIdSet = new set<Id>();
		List<quoteWrapper> quoTeamWrap = new List<quoteWrapper>();
		try{
			for(CQ_Quote_Team__c quoTeam : [Select Id,CQ_Quote_Team_Member__c
		FROM CQ_Quote_Team__c WHERE CQ_CQ_Name__c =: quoId])
			{
	userIdSet.add(quoTeam.CQ_Quote_Team_Member__c);  
			}
			if(!userIdSet.isEmpty())
	quoUserList = [Select Id,Name FROM User WHERE Id IN :userIdSet];
			
			for(User us : quoUserList){
	quoteWrapper quoWrapr = new quoteWrapper();
	quoWrapr.Quoteteam = us;
	quoTeamWrap.add(quoWrapr);
			}
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.CQ_CLONEQUOTECONTROLLER , GlobalConstants.CQ_GETQUOTETEAM);
		}
		return quoTeamWrap;
	}
	
	/*******************************
Method Name: getCustomerContact
Description:  
Parameters: Quote/Proposal record id
*******************************/
	@AuraEnabled
	public static List<quoteWrapper> getCustomerContact(String quoId){
		List<Contact> conList = new List<Contact>();
		set<Id> conIdSet = new set<Id>();
		Map<Id,Boolean> conMap = new Map<Id,Boolean>();
		List<quoteWrapper> quoContWrap = new List<quoteWrapper>();
		try{
			for(CQ_Customer_Contact__c quoCon : [Select Id,CQ_Contact__c,CQ_Is_Primary__c
	FROM CQ_Customer_Contact__c WHERE CQ_CQ_Name__c =: quoId])
			{
	conIdSet.add(quoCon.CQ_Contact__c);
	conMap.put(quoCon.CQ_Contact__c,quoCon.CQ_Is_Primary__c);
			}
			if(!conIdSet.isEmpty())
	conList = [Select Id,Name FROM Contact WHERE Id IN :conIdSet];
			for(Contact cont : conList){
	quoteWrapper quoWrapper = new quoteWrapper();
	quoWrapper.Cus_Contacts = cont;
	if(conMap.get(cont.Id))
		quoWrapper.isPrimary = TRUE;
	else
		quoWrapper.isPrimary = FALSE;
	quoContWrap.add(quoWrapper);
			}
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.CQ_CLONEQUOTECONTROLLER , GlobalConstants.CQ_GETCUSTOMERCONTACT);
		}
		return quoContWrap;
	}
	/*******************************
Method Name: getCustomerContact
Description:  
Parameters: Quote/Proposal record id
*******************************/
	@AuraEnabled
	public static String cloneQuote(Apttus_Proposal__Proposal__c cqquote){
		String returnMessage='No response';
		try{
			//Added By Rajtha for NCQ
			Apttus_Proposal__Proposal__c oldQuote = [Select Id, RecordtypeId from Apttus_Proposal__Proposal__c where Id = :cqquote.Id ];
			//end
			Apttus_Proposal__Proposal__c newquote = cqquote.clone(false,true,false,false);
			newquote.NokiaCPQ_Is_cloned__c = TRUE;
			newquote.CQ_Active__c = TRUE;
			//Added by Rajitha
			if(oldQuote.RecordtypeId == NCQ_RecId){
	newquote.RecordTypeId = NCQ_RecId;
			} // Added by Ravi (Standav) for CQ record type
			else if(oldQuote.RecordtypeId == CQ_new_RecId ){
	newquote.RecordTypeId = CQ_new_RecId;
	//newquote.isCQ__c = TRUE;
			}else{
			newquote.RecordTypeId = CQ_RecId;	 
			newquote.isCQ__c = TRUE;
			}
			//end
			newquote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.CQ_STATUS_DRAFT;
			
			Database.SaveResult savedResults = Database.insert(newquote, false);
			Boolean someFailure = false;
			if (!savedResults.isSuccess()) {
	someFailure = true;
	for (Database.Error err: savedResults.getErrors()) {
		String msg = err.getMessage();
		returnMessage = msg.replaceAll(GlobalConstants.QUOTES,GlobalConstants.BLANK_VALUE);
	}
			}
			if (!someFailure) {
	returnMessage = newquote.id;
			}
			return returnMessage;
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.CQ_CLONEQUOTECONTROLLER , GlobalConstants.CQ_CLONEQUOTE);
			return returnMessage;
		}
	}
	/*******************************
Method Name: saveQuoteTeam
Description:  
Parameters: Quote/Proposal record id
*******************************/
	@AuraEnabled
	public static void saveQuoteTeam(string userList, string quoteId, Apttus_Proposal__Proposal__c quote){
		try{
			List<quoteWrapper> wrapperList = (List<quoteWrapper>) JSON.deserialize(userList, List<quoteWrapper>.class);
			//System.debug('UserList::> '+wrapperList);
			List<CQ_Quote_Team__c> newUserList = new List<CQ_Quote_Team__c>();
			
			for(quoteWrapper obj : wrapperList ){
	if(obj.Quoteteam.Id <> NULL && obj.Quoteteam.Id <> quote.CQ_Sales_Lead__c && obj.Quoteteam.Id <> quote.CQ_Lead__c)
	{
		CQ_Quote_Team__c qt = new CQ_Quote_Team__c();
		qt.CQ_Quote_Team_Member__c = obj.Quoteteam.Id;
		qt.CQ_CQ_Name__c = quoteId;
		newUserList.add(qt);
	}
			}
			//System.debug('newUserList::> '+newUserList);
			List<Database.SaveResult> savedResults = Database.insert(newUserList, false);
			for(Database.SaveResult sr : savedResults){
	if (!sr.isSuccess()) {
		for(Database.Error err: sr.getErrors()) {
			String msg = err.getMessage();
			System.debug('Error while inserting quote team::> '+msg);
		}
	}
			}
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.CQ_CLONEQUOTECONTROLLER , GlobalConstants.CQ_CLONEQUOTETEAM);
		}
	}
	/*******************************
Method Name: saveQuoteTeam
Description:  
Parameters: Quote/Proposal record id
*******************************/
	@AuraEnabled
	public static void saveCustomerContact(string contList, string quoteId, string AccId){
		try{
			List<quoteWrapper> wrapperList = (List<quoteWrapper>) JSON.deserialize(contList, List<quoteWrapper>.class);
			List<CQ_Customer_Contact__c> newConList = new List<CQ_Customer_Contact__c>();
			//System.debug('wrapperList ::> '+wrapperList.size());
			for(quoteWrapper obj : wrapperList ){
	if(obj.Cus_Contacts.Id<>NULL){
		CQ_Customer_Contact__c cc = new CQ_Customer_Contact__c();
		cc.CQ_Contact__c = obj.Cus_Contacts.Id;
		cc.CQ_isCloned__c = TRUE;
		cc.CQ_CQ_Name__c = quoteId;
		cc.CQ_Account__c = AccId;
		if(obj.isPrimary<>NULL && obj.isPrimary || wrapperList.size() == Globalconstants.VALUE_ONE)
			cc.CQ_Is_Primary__c = TRUE;
		else
			cc.CQ_Is_Primary__c = FALSE;
		newConList.add(cc);
		//System.debug('newConList::> '+newConList);
	}
			}
			List<Database.SaveResult> savedResults = Database.insert(newConList, false);
			for(Database.SaveResult sr : savedResults){
	if (!sr.isSuccess()) {
		for (Database.Error err: sr.getErrors()) {
			String msg = err.getMessage();
			System.debug('Error while inserting quote team::> '+err.getStatusCode()+'::> '+msg);
			//System.debug('Fields that affected this error : ' + err.getFields());
		}
	}
			}
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.CQ_CLONEQUOTECONTROLLER , GlobalConstants.CQ_CLONECUSTOMERCONTACT);
		}
	}
	/*******************************
Method Name: quoteWrapper
Description:  
Parameters: 
*******************************/
	public class quoteWrapper{
		@AuraEnabled public User cqObj {get;set;}
		@AuraEnabled public User salesObj {get;set;}
		@AuraEnabled public User Quoteteam {get;set;}
		@AuraEnabled public String usersearch {get;set;}
		@AuraEnabled public Contact Cus_Contacts {get;set;}
		@AuraEnabled public String consearch {get;set;}
		@AuraEnabled public Boolean isPrimary {get;set;}
		
	}
}