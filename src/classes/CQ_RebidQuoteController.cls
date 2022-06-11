/*******************************
Class Name: CQ_RebidQuoteController
Created by: Accenture
Created Date: 22 April 2019
Last modified by: Accenture
Last modified date:  
Description: Contracted Quote Rebid Apex Controller
*******************************/
public with Sharing class CQ_RebidQuoteController {
	
	Private static final Id CQ_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get(Label.CQ_RecordTypeId).getRecordTypeId();
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
			quo = [Select Apttus_Proposal__Proposal_Name__c,NokiaCPQ_Portfolio__c,Parent_Rebid_Quote__c,Quote_Type__c,NokiaCPQ_Proposal_Id__c,Apttus_Proposal__Opportunity__c,
	   Apttus_Proposal__Account__c,Apttus_Proposal__Account__r.Name,Account_Legal_Entity__c,Account_Legal_Entity__r.Name,
	   CQ_Customer_Organization_Segment__c,Apttus_Proposal__Description__c,CQ_Notes__c,CQ_Customer_Request_Number__c,
	   CQ_Customer_Project_Code__c,CQ_Customer_Project_Site_City__c,CQ_Customer_Project_Site_State__c,CQ_Master_Quote__c,
	   CQ_Master_Quote_Quantity__c,CQ_Sales_Lead__c,CQ_Lead__c,CQ_Lead__r.Name,CQ_Sales_Lead__r.Name,
	   Apttus_Proposal__Approval_Stage__c,CQ_Servies_components__c, CPQ_Is_Rebid_Completed__c, CPQ_NCQ_Check__c,CPQ_CQ_Check__c,
	   CPQ_Pricing_Pool__c,CPQ_Contractual_Price_Condition__c,CPQ_Contractual_Price_Condition_Code__c,CPQ_CLLI_ID__c,CPQ_SSF_Billing_Rule_ID__c,
	   CPQ_Include_Transportation__c,CPQ_Display_FRU_Items__c,CPQ_Scope_of_Work__c,CPQ_Assumptions__c,CPQ_Report_Notes__c
	   FROM Apttus_Proposal__Proposal__c 
	   WHERE Id =: quoteId LIMIT 1];
			quo.RecordTypeId = CQ_RecId;
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.CQ_REBIDQUOTECONTROLLER , GlobalConstants.CQ_FETCHQUOTEDETAILS);
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
Method Name: rebidQuote
Description:  
Parameters: Quote/Proposal record id
*******************************/
	@AuraEnabled
	public static string rebidQuote(Apttus_Proposal__Proposal__c cqquote,String recordId){
		String returnMessage = 'EXCEPTION';
		//String query = GlobalConstants.SELECT_QUERY;
		//String OBJECTNAME = 'Quote_Proposal';
		String cqid;
		String quoteid;
		String revId;
		String firstpart;
		String newfirstpart;
		String lastpart;
		String newlastpart;
		Boolean vzw = FALSE;
		Boolean MaxChar = FALSE;
		List<Apttus_Proposal__Proposal__c> cqlist = new List<Apttus_Proposal__Proposal__c>();
		
		try{
			cqid = cqquote.NokiaCPQ_Proposal_Id__c;
			//Parse the QuoteId to get the firstpart for Query
			if(cqid.substring(cqid.length() - 1 , cqid.length()) == GlobalConstants.ONE)
	firstpart = cqid.substring(0, cqid.length() - 2);
			else
	firstpart = cqid.substring(0, cqid.length() - 1);
			
			newfirstpart = GlobalConstants.WILDCARD_SEARCH+firstpart+GlobalConstants.WILDCARD_SEARCH;
			
			cqlist = [SELECT NokiaCPQ_Proposal_Id__c FROM Apttus_Proposal__Proposal__c
	WHERE NokiaCPQ_Proposal_Id__c LIKE :newfirstpart
	ORDER BY CreatedDate DESC];
			quoteid = cqlist[0].NokiaCPQ_Proposal_Id__c;
			
			//Parse the QuoteId to get the last Char for Revision
			if(quoteid.substring(quoteid.length() - 1 , quoteid.length()) == GlobalConstants.ONE)
			{
	lastpart = quoteid.substring(quoteid.length() - 2 , quoteid.length() - 1);
	vzw = TRUE;
			}
			else
	lastpart = quoteid.substring(quoteid.length() - 1 , quoteid.length());
			
			//Check whether the Revision has reached the Max limit
			if(GlobalConstants.ZEE == lastpart)
	MaxChar = TRUE;
			else
	newlastpart = getNextChar(lastpart);
			
			//Check for VzW Quote to add '1' at the end
			if(vzw)
	revId = firstpart+newlastpart+GlobalConstants.ONE;
			else
	revId = firstpart+newlastpart;  
			
			if(!MaxChar)
			{
	 Apttus_Proposal__Proposal__c newquote = cqquote.clone(false,true,false,false);
	 if (!cqquote.CPQ_NCQ_Check__c && !cqquote.CPQ_CQ_Check__c) {
		newquote.CQ_IsRebid__c = TRUE;
		newquote.CQ_Active__c = TRUE;
		newquote.RecordTypeId = CQ_RecId;
		newquote.NokiaCPQ_Proposal_Id__c = revId;
		newquote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.CQ_STATUS_DRAFT;
		newquote.isCQ__c = TRUE;
	} else {
		newquote.CQ_IsRebid__c = TRUE;
		
		if(cqquote.CPQ_NCQ_Check__c){
		newquote.RecordTypeId = NCQ_RecId;
		//newquote.isCQ__c = FALSE;
		}else if(cqquote.CPQ_CQ_Check__c){
		newquote.RecordTypeId = CQ_new_RecId;
		//newquote.isCQ__c = TRUE;
		}
		newquote.NokiaCPQ_Proposal_Id__c = revId;
		newquote.Apttus_Proposal__Approval_Stage__c = GlobalConstants.CQ_STATUS_DRAFT;
		newquote.isCQ__c = FALSE;
	   }
	
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
		updateQuote(recordId,cqlist);
		cloneQuoteTeam(newquote.id, recordId);
		cloneCustomerContact(newquote.id, recordId);
	}	 
			}
			else
	returnMessage = GlobalConstants.CQ_MAXREVISIONERROR;
			
			return returnMessage;
		}
		Catch(Exception ex)
		{
			ExceptionHandler.addException(ex,GlobalConstants.CQ_REBIDQUOTECONTROLLER , GlobalConstants.CQ_REBIDQUOTE);
			returnMessage = ex.getMessage();
			return returnMessage;
		}
	}
	
	/*******************************
Method Name: getNextChar
Description:  
Parameters: Last Character of QuoteId
*******************************/
	public static String getNextChar(String oldChar) {
		String key = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
		Integer index = key.indexOfChar(oldChar.charAt(0));
		return index == -1? null: key.substring(index+1, index+2);
	}
	
	/*******************************
Method Name: updateQuote
Description:  
Parameters: old QuoteId
*******************************/
	public static void updateQuote(String recId, List<Apttus_Proposal__Proposal__c> quoList){
		List<Apttus_Proposal__Proposal__c> quoUpdateList = new List<Apttus_Proposal__Proposal__c>();
		
		try{			
			for(Apttus_Proposal__Proposal__c cq : quoList){
	if(cq.Id==recId)
	cq.Apttus_Proposal__Approval_Stage__c = GlobalConstants.CQ_STATUS_REBID;
	//Added by Rajitha
	cq.CPQ_Is_Rebid_Completed__c = true;
	//end
	cq.CQ_isRebid_Done__c = TRUE;
	cq.CQ_Active__c = FALSE;
	quoUpdateList.add(cq);
			}
			Database.update(quoUpdateList,false);
		}
		Catch(Exception ex){  
			ExceptionHandler.addException(ex,GlobalConstants.CQ_REBIDQUOTECONTROLLER , GlobalConstants.CQ_UPDATEQUOTE);
		}
	}
	
	/*******************************
Method Name: cloneQuoteTeam
Description:  
Parameters: newquoteId,recordId
*******************************/
	public static void cloneQuoteTeam(String quoteId,String oldquoteId){
		List<CQ_Quote_Team__c> cqteamList = new List<CQ_Quote_Team__c>();
		set<Id> CQTeamset = new set<Id>();
		try{
			for(CQ_Quote_Team__c cqteam : [Select Id, CQ_Quote_Team_Member__c,CQ_Role__c
	 FROM CQ_Quote_Team__c
	 WHERE CQ_CQ_Name__c =:quoteId ])
			{
	CQTeamset.add(cqteam.CQ_Quote_Team_Member__c);
			}
			for(CQ_Quote_Team__c team : [Select Id, CQ_Quote_Team_Member__c,CQ_Role__c
	 FROM CQ_Quote_Team__c
	 WHERE CQ_CQ_Name__c =:oldquoteId ])
			{
	if(!CQTeamset.contains(team.CQ_Quote_Team_Member__c)){
	CQ_Quote_Team__c cqTeam = new CQ_Quote_Team__c();
	cqTeam.CQ_CQ_Name__c = quoteId;
	cqTeam.CQ_Quote_Team_Member__c = team.CQ_Quote_Team_Member__c;
	if(String.isNotBlank(team.CQ_Role__c) && String.isNotEmpty(team.CQ_Role__c))
		cqTeam.CQ_Role__c = team.CQ_Role__c;
	cqTeamList.add(cqTeam);
	}
			}
			if(!cqTeamList.IsEmpty())
	Database.insert(cqTeamList,false);
		}
		Catch(Exception ex)
		{
			ExceptionHandler.addException(ex,GlobalConstants.CQ_REBIDQUOTECONTROLLER , GlobalConstants.CQ_CLONEQUOTETEAM);
		}
	}
	
	/*******************************
Method Name: cloneCustomerContact
Description:  
Parameters: newquoteId,recordId
*******************************/
	public static void cloneCustomerContact(String quoteId, String oldquoteId){
		List<CQ_Customer_Contact__c> conList = new List<CQ_Customer_Contact__c>();
		
		try{
			for(CQ_Customer_Contact__c cc : [SELECT Id, CQ_Contact__c,CQ_Is_Primary__c,CQ_Account__c
			FROM CQ_Customer_Contact__c
			WHERE CQ_CQ_Name__c =: oldquoteId])
			{
	CQ_Customer_Contact__c con = new CQ_Customer_Contact__c();
	con.CQ_Contact__c = cc.CQ_Contact__c;
	con.CQ_isCloned__c = TRUE;
	con.CQ_CQ_Name__c = quoteId;
	con.CQ_Account__c = cc.CQ_Account__c;
	if(cc.CQ_Is_Primary__c)
		con.CQ_Is_Primary__c = cc.CQ_Is_Primary__c;
	conList.add(con);
			}
			if(!conList.IsEmpty())
	Database.insert(conList,false);
		}
		Catch(Exception ex)
		{
			ExceptionHandler.addException(ex,GlobalConstants.CQ_REBIDQUOTECONTROLLER , GlobalConstants.CQ_CLONECUSTOMERCONTACT);
		}
	}
}