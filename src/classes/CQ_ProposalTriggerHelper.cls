/*******************************
Class Name: CQ_ProposalTriggerHelper
Created By: Accenture - April 2019
Last Modified By: Accenture
Last Modified Date: 09-04-2019
Description: Helper Class for Quote/Proposal Trigger for Contracted Quote Record Type
*******************************/
public with sharing class CQ_ProposalTriggerHelper {
	Private static final Id CQ_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get(Label.CQ_RecordTypeId).getRecordTypeId();
	//Rajitha start
	Private static final Id NCQ_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_NCQ_Quote').getRecordTypeId();
	//End
	Public static integer limitRows = Limits.getLimitQueryRows()- Limits.getQueryRows();
	//added by Jithin
	 Private static final Id New_CQ_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_CQ_Quote').getRecordTypeId();
	/*****************************
*Method Name: createQuoteTeamoncreation
*Description: This method is used to create quote team on CQ quote creation
*Parameters:  Quote/Proposal List
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 09-04-2019
*******************************/
	public static void createQuoteTeamoncqcreation(List<Apttus_Proposal__Proposal__c> quotelist)
	{
		List<CQ_Quote_Team__c> quoteteamlist = new list<CQ_Quote_Team__c>();
		Map<String, String> quoteteamcreationMap = new Map<String, String>();
		Set<String> quoteTeamSet = new set<String>();
		
		try{
			for(Apttus_Proposal__Proposal__c quote : quotelist)
			{
	//Process the records and put it in two sets, bypassed for Rebid updated by Rajitha
	if((quote.RecordTypeId == CQ_RecId || quote.RecordTypeId == NCQ_RecId || quote.RecordTypeId == New_CQ_RecId) && !quote.CQ_IsRebid__c)
		//End
	{
		quoteTeamSet.add(quote.CQ_Lead__c+GlobalConstants.SEMICOLON+GlobalConstants.CQ_Lead+GlobalConstants.COMMA+quote.Id);
		quoteTeamSet.add(quote.CQ_Sales_Lead__c+GlobalConstants.SEMICOLON+GlobalConstants.Sales_Lead+GlobalConstants.COMMA+quote.Id);
	}
			}
			
			if(!quoteTeamSet.isEmpty())
			{
	//Split the records and store it as a Map
	for(String quoteTeamValue : quoteTeamSet)
		quoteteamcreationMap.put(quoteTeamValue.substringBefore(GlobalConstants.COMMA).Trim(),quoteTeamValue.substringAfter(GlobalConstants.COMMA).Trim());
			}
			
			if(!quoteteamcreationMap.isEmpty())
			{
	for(String quoteTeam : quoteteamcreationMap.keyset())
	{
		CQ_Quote_Team__c  cqTeam = new CQ_Quote_Team__c();
		cqTeam.CQ_CQ_Name__c = quoteteamcreationMap.get(quoteTeam);
		cqTeam.CQ_Quote_Team_Member__c = quoteTeam.substringBefore(GlobalConstants.SEMICOLON).Trim();
		cqTeam.CQ_Role__c = quoteTeam.substringAfter(GlobalConstants.SEMICOLON).Trim();
		quoteteamlist.add(cqTeam);
	}
			}
			
			if(!quoteteamlist.isEmpty())
	Database.insert(quoteteamlist,false);
		}
		catch(exception ex)
		{
			ExceptionHandler.addException(ex,GlobalConstants.CQ_PROPOSALTRIGGERHELPER, GlobalConstants.CQ_CREATEQUOTETEAMUPONCREATION);
		}
	}
	
	/*****************************
*Method Name: createQuoteNumber
*Description: This method is used to create quote number on CQ quote creation
*Parameters:  Quote/Proposal List
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 10-04-2019
*******************************/   
	public static void createQuoteNumber(List<Apttus_Proposal__Proposal__c> quoteList)
	{
		string Verizon= System.Label.VzW_Number;
		List<CQ_QuoteId_Calculation__c> idList = new List<CQ_QuoteId_Calculation__c>();
		Map<String,String> idMap = new Map<String,String>();
		Map<Id, Apttus_Proposal__Proposal__c> oppToQuoteCountMap = new Map<Id,Apttus_Proposal__Proposal__c>();
		Map<Id, Apttus_Proposal__Proposal__c> ver_quotemap = new Map<Id, Apttus_Proposal__Proposal__c>();
		Map<Id, Apttus_Proposal__Proposal__c> nonver_quotemap = new Map<Id, Apttus_Proposal__Proposal__c>();
		Map<Id,String> countMap = new Map<Id,String>();
		Map<Id,Opportunity> quoteOppMap = new Map<Id,Opportunity>();
		
		try{
			idList = CQ_QuoteId_Calculation__c.getAll().Values(); //Collect the custom settings values
			for(CQ_QuoteId_Calculation__c idCal : idList)
	idMap.put(idCal.Name,idCal.CQ_Quote_Number__c);
			
			for (Apttus_Proposal__Proposal__c quote : quoteList)
			{
	// if(quote.RecordTypeId == CQ_RecId && !quote.CQ_IsRebid__c) 
	//updated by Rajitha
	if((quote.RecordTypeId == CQ_RecId || quote.RecordTypeId == NCQ_RecId || quote.RecordTypeId == New_CQ_RecId) && !quote.CQ_IsRebid__c)
		//End
	{
		oppToQuoteCountMap.put(quote.Apttus_Proposal__Opportunity__c,quote);
	}
	
			}
			
			if(!oppToQuoteCountMap.isEmpty())
			{
	for(Opportunity opp : [Select Id, Opportunity_ID__c, CQ_Count__c, Legal_Entity__r.QTC_Sold_To__c 
			from Opportunity Where Id IN :oppToQuoteCountMap.Keyset()
			LIMIT :limitRows FOR UPDATE])
	{
		quoteOppMap.put(oppToQuoteCountMap.get(opp.Id).Id,opp); // Put Quote and Opportunity in a map for fetching Opp Number
		
		// Store Quote count of Opportunity in Map for fetching Quote number from Custom settings
		if(opp.CQ_Count__c<>Null)
			countMap.put(opp.Id, String.valueOf(opp.CQ_Count__c));
		else
			countMap.put(opp.Id, GlobalConstants.ZERO);
		
		//Split and store the Quote as VzW and Non-VzW 
		if(Verizon == opp.Legal_Entity__r.QTC_Sold_To__c)
			ver_quotemap.put(oppToQuoteCountMap.get(opp.Id).Id,oppToQuoteCountMap.get(opp.Id));
		else
			nonver_quotemap.put(oppToQuoteCountMap.get(opp.Id).Id,oppToQuoteCountMap.get(opp.Id));
	}
			}   
			
			for(Apttus_Proposal__Proposal__c cq : quoteList)
			{
	//Generate Quote Number for Non-VzW Quotes 
	if(!nonver_quotemap.isEmpty() && nonver_quotemap.containsKey(cq.Id))
	{
		cq.NokiaCPQ_Proposal_Id__c = quoteOppMap.get(cq.Id).Opportunity_ID__c+GlobalConstants.DOT+idMap.get(countMap.get(cq.Apttus_Proposal__Opportunity__c));
	}
	
	//Generate Quote Number for VzW Quotes
	if(!ver_quotemap.isEmpty() && ver_quotemap.containsKey(cq.Id))
	{
		String oppLastpart = quoteOppMap.get(cq.Id).Opportunity_ID__c.substringafterlast(GlobalConstants.DOT);
		String oppFirstpart = quoteOppMap.get(cq.Id).Opportunity_ID__c.substringbefore(GlobalConstants.DOT);
		cq.NokiaCPQ_Proposal_Id__c = oppFirstpart+GlobalConstants.DOT+oppLastpart+GlobalConstants.DOT+idMap.get(countMap.get(cq.Apttus_Proposal__Opportunity__c))+GlobalConstants.ONE;		
	}	  
			}
		}
		catch (Exception ex)
		{
			ExceptionHandler.addException(ex,GlobalConstants.CQ_PROPOSALTRIGGERHELPER, GlobalConstants.CQ_CREATEQUOTENUMBER);
		}
	}
	/*****************************
*Method Name: CQ_QuoteVersion_Active
*Description: This method is used to inactive the previous quote versions on new CQ quote creation and Rebid
*Parameters:  Quote/Proposal List
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 27-04-2019
*******************************/ 
	public static void CQ_QuoteVersion_Active(Map<Id,Apttus_Proposal__Proposal__c> newMap_CQ, Map<Id,Apttus_Proposal__Proposal__c> oldMap_CQ){
		try{
			string cqid;
			string firstpart;
			List<Apttus_Proposal__Proposal__c> quotesList = new List<Apttus_Proposal__Proposal__c>();
			set<id> quoteVersionSet = new set<id>();
			set<String> version_set = new set<String>();
			List<Apttus_Proposal__Proposal__c> inactiveQuotes = new List<Apttus_Proposal__Proposal__c>();
			
			for(Apttus_Proposal__Proposal__c singleQuote:newMap_CQ.values())
			{
	if((oldMap_CQ.get(singleQuote.id).CQ_Active__c <> singleQuote.CQ_Active__c) & singleQuote.CQ_Active__c){
		quoteVersionSet.add(singleQuote.Id);
		
		//getting the quoteNumber
		cqid = singleQuote.NokiaCPQ_Proposal_Id__c;
		
		//Parse the QuoteId to get the firstpart for Query	
		if(cqid.substring(cqid.length() - 1 , cqid.length()) == GlobalConstants.ONE)
			firstpart = cqid.substring(0, cqid.length() - 2);
		
		else
			firstpart = cqid.substring(0, cqid.length() - 1);
		firstpart = firstpart+GlobalConstants.WILDCARD_SEARCH;
		//Adding each of version into a list
		version_set.add(firstpart);	 
	} 
			}
			
			quotesList=[select id,NokiaCPQ_Proposal_Id__c,CQ_Active__c from Apttus_Proposal__Proposal__c where
			NokiaCPQ_Proposal_Id__c like :version_set and CQ_Active__c=true and Id not in:quoteVersionSet]; 
			
			//for each quotes taken making it inactive
			for(Apttus_Proposal__Proposal__c Quote:quotesList){
	Quote.CQ_isRebid_Done__c=true;
	Quote.CQ_Active__c=false; 
	inactiveQuotes.add(Quote);  
			}
			if(!inactiveQuotes.isEmpty()){
	database.update(inactiveQuotes);	 
			}
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,GlobalConstants.CQ_PROPOSALTRIGGERHELPER , GlobalConstants.CQ_QuoteVersion_Active);  
		}
	}
	
	
	/*****************************
*Method Name: CQ_QuoteTeammemberUpdate
*Description: This method is used to update quote teammembers while change happens in saleslead or Cq lead
*Parameters:  Quote/Proposal map
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 27-04-2019
*******************************/ 
	public static void CQ_QuoteTeammemberUpdate(Map<Id,Apttus_Proposal__Proposal__c> newMap_CQ, Map<Id,Apttus_Proposal__Proposal__c> oldMap_CQ){
		list<CQ_Quote_Team__c> QUoteteamsetUpsert=new list<CQ_Quote_Team__c>();
		Map<string,CQ_Quote_Team__c> QuoteteamRolemap=new Map<string,CQ_Quote_Team__c>();
		
		try{
			
			for(CQ_Quote_Team__c Qte_Team:[Select Id,CQ_Role__c,CQ_Quote_Team_Member__c,CQ_CQ_Name__c from CQ_Quote_Team__c Where CQ_CQ_Name__c IN: newMap_CQ.Keyset() AND (CQ_Role__c LIKE : GlobalConstants.CQ_Lead OR CQ_Role__c LIKE : GlobalConstants.Sales_Lead ) ])
	QuoteteamRolemap.put(Qte_Team.CQ_CQ_Name__c+GlobalConstants.COMMA+Qte_Team.CQ_Role__c,Qte_Team);
			
			for(Apttus_Proposal__Proposal__c Quote:newMap_CQ.values()) 
			{
	if(!QuoteteamRolemap.containskey(Quote.id+GlobalConstants.COMMA+GlobalConstants.Sales_Lead) ||!QuoteteamRolemap.containskey(Quote.id+GlobalConstants.COMMA+GlobalConstants.CQ_Lead))
	{
		if(!QuoteteamRolemap.containskey(Quote.id+GlobalConstants.COMMA+GlobalConstants.Sales_Lead))
		{
			CQ_Quote_Team__c  cqTeam = new CQ_Quote_Team__c();
			cqTeam.CQ_CQ_Name__c = Quote.id;
			cqTeam.CQ_Quote_Team_Member__c =Quote.CQ_Sales_Lead__c;
			cqTeam.CQ_Role__c = GlobalConstants.Sales_Lead;
			QUoteteamsetUpsert.add(cqTeam);
		}
		if(!QuoteteamRolemap.containskey(Quote.id+GlobalConstants.COMMA+GlobalConstants.CQ_Lead))
		{
			CQ_Quote_Team__c  cqTeam = new CQ_Quote_Team__c();
			cqTeam.CQ_CQ_Name__c = Quote.id;
			cqTeam.CQ_Quote_Team_Member__c =Quote.CQ_Lead__c;
			cqTeam.CQ_Role__c = GlobalConstants.CQ_Lead;  
			QUoteteamsetUpsert.add(cqTeam);
		}
	}	 
	
	if(QuoteteamRolemap.containskey(Quote.id+GlobalConstants.COMMA+GlobalConstants.CQ_Lead))
	{
		if((Quote.CQ_Lead__c!=Null) && (Quote.CQ_Lead__c<>oldMap_CQ.get(Quote.Id).CQ_Lead__c))
			QuoteteamRolemap.get(Quote.id+GlobalConstants.COMMA+GlobalConstants.CQ_Lead).CQ_Quote_Team_Member__c=Quote.CQ_Lead__c;
		else
			QuoteteamRolemap.remove(Quote.id+GlobalConstants.COMMA+GlobalConstants.CQ_Lead);  
	}
	if(QuoteteamRolemap.containskey(Quote.id+GlobalConstants.COMMA+GlobalConstants.Sales_Lead))
	{
		if((Quote.CQ_Sales_Lead__c!=Null) && (Quote.CQ_Sales_Lead__c<>oldMap_CQ.get(Quote.Id).CQ_Sales_Lead__c))
			QuoteteamRolemap.get(Quote.id+GlobalConstants.COMMA+GlobalConstants.Sales_Lead).CQ_Quote_Team_Member__c=Quote.CQ_Sales_Lead__c;
		else
			QuoteteamRolemap.remove(Quote.id+GlobalConstants.COMMA+GlobalConstants.Sales_Lead);  
	}
			}
			
			if(!QuoteteamRolemap.isempty())QUoteteamsetUpsert.AddAll(QuoteteamRolemap.values());
			
			if(!QUoteteamsetUpsert.isempty())Database.upsert(QUoteteamsetUpsert);
		}
		catch (Exception ex)
		{
			ExceptionHandler.addException(ex,GlobalConstants.CQ_PROPOSALTRIGGERHELPER , 'CQ_QuoteTeammemberUpdate');
		}
	}
	
	
	/*****************************
*Method Name: updateSurroundPricedAccount
*Description: This method is used to update surround priced account field in quote when the quote is priced in surround
*Parameters:  Quote/Proposal List
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 27-04-2019
*******************************/ 
	public static void updateSurroundPricedAccount(List<Apttus_Proposal__Proposal__c> newQuoteList,Map<Id,Apttus_Proposal__Proposal__c> oldMap){
		Set<String> SurroundQTCCodeSet = new Set<String>();
		Map<String,Id> accIdMap = new Map<String,Id>();
		try{
			System.debug('Helper::::'+newQuoteList);
			for(Apttus_Proposal__Proposal__c cq : newQuoteList){
	if(cq.Surround_QTC_Code__c <> null && cq.Surround_QTC_Code__c <> oldMap.get(cq.Id).Surround_QTC_Code__c)
		SurroundQTCCodeSet.add(cq.Surround_QTC_Code__c);	 
			}
			
			System.debug('SurroundQTCCodeSet++++'+SurroundQTCCodeSet);
			if(SurroundQTCCodeSet.size() > 0){
	for(Account acc : [select Id,QTC_Sold_To__c 
	 from Account 
	 where QTC_Sold_To__c IN: SurroundQTCCodeSet]){
			accIdMap.put(acc.QTC_Sold_To__c, acc.Id);
	 }
			}
			
			for(Apttus_Proposal__Proposal__c CQquote : newQuoteList){
	if(CQquote.Surround_QTC_Code__c <> null && accIdMap.get(CQquote.Surround_QTC_Code__c) <> null){
		CQquote.Surround_Priced_Account__c = accIdMap.get(CQquote.Surround_QTC_Code__c);
	}
	//CQquote.CQ_Documents_Attached__c = false;
			}
		}
		catch (Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CQ_PROPOSALTRIGGERHELPER, GlobalConstants.UPDATE_SURROUND_PRICED_ACCOUNT);
		}
	}
	
	/*****************************
*Method Name: updateeQuoteStatus
*Description: This method is used to update equote status field whenever equote error field is updated from EAI
*Parameters:  Quote/Proposal List
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 27-04-2019
********************************/ 
	public static void updateeQuoteStatus(List<Apttus_Proposal__Proposal__c> oldQuoteList, Map<Id, Apttus_Proposal__Proposal__c> newQuoteMap){
		system.debug('@@@updateeQuoteStatus');
		//Add recursive logic
		Map<Id,Apttus_Proposal__Proposal__c> eQuoteSuccessMap = new Map<Id,Apttus_Proposal__Proposal__c>();
		try{
			for(Apttus_Proposal__Proposal__c cq : oldQuoteList){
	if(cq.CQ_eQuote__c!= null && cq.CQ_eQuote__c && newQuoteMap.get(cq.Id).eQuote_Error__c != null && cq.CQ_eQuote_Status__c != null
	&& cq.CQ_eQuote_Status__c.equalsIgnoreCase(GlobalConstants.EQUOTE_STATUS_INPROGRESS)){
		if(newQuoteMap.get(cq.Id).eQuote_Error__c.containsignorecase(GlobalConstants.EQUOTE_ERROR_FAIL)){
		 newQuoteMap.get(cq.Id).CQ_eQuote_Status__c = GlobalConstants.EQUOTE_STATUS_FAILURE;
		}
		else if(newQuoteMap.get(cq.Id).eQuote_Error__c.containsignorecase(GlobalConstants.EQUOTE_ERROR_ACCEPT)){
		 newQuoteMap.get(cq.Id).CQ_eQuote_Status__c = GlobalConstants.EQUOTE_STATUS_SUCCESS;
		 eQuoteSuccessMap.put(cq.Id, newQuoteMap.get(cq.Id));
		}   
	}
			}
			if(eQuoteSuccessMap.size() > 0)
			{
	CQ_SendQuoteController.sendQuoteByMail(eQuoteSuccessMap);
			}
			system.debug(newQuoteMap);
			
		}
		catch (Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CQ_PROPOSALTRIGGERHELPER, GlobalConstants.UPDATE_EQUOTE_STATUS);
		}
	}
	
	/******************************************************************************************************
Name : QuotestoEAI
Created Date: 21 April 2019
Created by: Accenture
Description : while Create or update happens in QUote record This method will help to determine whether we have to send message or not for  EAI 
*********************************************************************************************************/
	public static void Sync_QuotestoEAI(Map<Id, Apttus_Proposal__Proposal__c> newQuoteMap, Map<Id, Apttus_Proposal__Proposal__c> OldQuoteMap)
	{
		Globalconstants.RecursiveCount=Globalconstants.RecursiveCount+1;
		system.debug('RecursiveCount-->'+Globalconstants.RecursiveCount);
		Map<Id, Apttus_Proposal__Proposal__c> newQuoteMap_v1 = new Map<Id, Apttus_Proposal__Proposal__c>();
		set<ID> NEwQuoteIDs=new set<ID>(); 
		Map<Id, string> Old_Approvalstagemap=new map<Id,string>();
		Map<Id, string> Old_QuoteNamemap=new map<Id,string>();
		Map<Id, Boolean> Old_CQActivemap=new map<Id,Boolean>();
		boolean  makeCallout = true; 
		//determine Dml is Insert or Update
		string Operationtype=oldQuoteMap<>null ? Globalconstants.UPDATE_VALUE : Globalconstants.INSERT_VALUE;
		
		// if(Globalconstants.RecursiveCount==1)
		{
			System.SavePoint savePoint = Database.setSavepoint();
			
			for(Id quoteId : newQuoteMap.keySet()){
	if(( !String.isBlank(newQuoteMap.get(quoteId).NokiaCPQ_Proposal_Id__c) && !String.isBlank(newQuoteMap.get(quoteId).NokiaCPQ_Opportunity_Number__c)))
	{
		if(isRecordToSync(newQuoteMap.get(quoteId),oldQuoteMap <> null && oldQuoteMap.containskey(quoteId) ? oldQuoteMap.get(quoteId):Null ))
		{
			newQuoteMap_v1.put(quoteId, newQuoteMap.get(quoteId));
			NEwQuoteIDs.add(quoteId);
			if(Operationtype.equalsIgnoreCase(Globalconstants.UPDATE_VALUE))
			{
	Old_Approvalstagemap.put(quoteId,oldQuoteMap.get(quoteId).Apttus_Proposal__Approval_Stage__c);
	Old_QuoteNamemap.put(quoteId,oldQuoteMap.get(quoteId).Apttus_Proposal__Proposal_Name__c);
	Old_CQActivemap.put(quoteId,oldQuoteMap.get(quoteId).CQ_Active__c);
			}
			
		}
	}
	else 
		newQuoteMap.get(quoteId).addError(CQ_Sync_Quote_EAI__c.getInstance(Globalconstants.QUOTE_REQUIRED_INFO_MISSING).Message__c);
			}
			
			if(!newQuoteMap_v1.isEmpty() )
			{  //In existing EAI implementation max 25 records only we can send max size check 
	if(newQuoteMap_v1.size() >CQ_Sync_Quote_EAI__c.getInstance(GlobalConstants.CQ_MAX_SIZE).Size__c ) {
		for(Apttus_Proposal__Proposal__c newQuote: newQuoteMap.values())
			newQuote.addError(CQ_Sync_Quote_EAI__c.getInstance(GlobalConstants.MAX_BULK_SIZE_ERROR).Message__c);
	}
	else{
		try{
			String iLogName = ( newQuoteMap_v1.size() > 1 ? GlobalConstants.INTERFACE_LOG_BULK_NAME + system.today() : newQuoteMap_v1.values()[0].NokiaCPQ_Proposal_Id__c );
			if(newQuoteMap_v1.size()==1) {		
	//see if a record interface log exists for the same Opportunity, in Queued Status and with the same operation. 
	Integer iLogInProgress=[select count() from Interface_Log__c where Name = :iLogName and Status__c = :GlobalConstants.INTERFACE_LOG_QUEUED  and 
	Interface_Type__c=:GlobalConstants.INTERFACE_LOG_QUOTE_INTERFACE_TYPE and Operation_Type__c = :Operationtype ];
	
	if( iLogInProgress== 1)makeCallout = false;	  
			}
			
			if(makeCallout) {
	Interface_Log__c iLog = new Interface_Log__c(Name=iLogName, Interface_Type__c=GlobalConstants.INTERFACE_LOG_QUOTE_INTERFACE_TYPE, Message_Type__c=Globalconstants.OUTBOUND,	
			 Operation_type__c =Operationtype,Status__c = GlobalConstants.INTERFACE_LOG_QUEUED);
	database.insert(ilog);  
	if(!System.IsFuture()&&!System.isBatch()){		
	if((Globalconstants.INSERT_VALUE.equalsignorecase(Operationtype)&&CQ_Sync_Quote_EAI__c.getInstance(Globalconstants.CQ_SYNCQUOTE_INSERT).sync__c)||(Globalconstants.UPDATE_VALUE.equalsignorecase(Operationtype)&&CQ_Sync_Quote_EAI__c.getInstance(Globalconstants.CQ_SYNCQUOTE_UPDATE).sync__c))
		QuoteOffer_SyncCalloutService.SyncQuotetoEAI(NEwQuoteIDs,Old_Approvalstagemap,Old_QuoteNamemap,Old_CQActivemap , iLog.id,Operationtype ,false);
	}
			}
		}
		catch(Exception e) {
			system.debug('An unexpected erorr occurred:' + e);
			ExceptionHandler.addException(e, GlobalConstants.CQ_PROPOSALTRIGGERHELPER, GlobalConstants.Sync_QuotestoEAI);
			for(Id qId: newQuoteMap_v1.keySet())
	newQuoteMap.get(qId).addError('Unexpected system error occurred:' + e.getMessage());
			Database.rollback(savePoint);  
		}
	}
			}
		}
	}
	
	
	/******************************************************************************************************
Name : isRecordToSync
Created Date:  21 April 2019
Created by: Accenture
Description : This method will check Required fields are available are updated  to send EAI
Modified Date: 11 Jan 2021
Modified by: Standav
Change: Added logic to identify records for NCQ quotes
*********************************************************************************************************/
	public static boolean isRecordToSync(Apttus_Proposal__Proposal__c newQuote, Apttus_Proposal__Proposal__c oldQuote){
		boolean isRecordToSync=false;
		try{
			if(oldQuote != null && (newquote.CPQ_NCQ_Check__c || newquote.CPQ_CQ_Check__c)) {
	if((oldQuote.Apttus_Proposal__Approval_Stage__c <> newquote.Apttus_Proposal__Approval_Stage__c) && (oldQuote.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(GlobalConstants.CQ_STATUS_DRAFT) || oldQuote.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase('In Review')) && (newquote.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(GlobalConstants.CQ_STATUS_DRAFT) || newquote.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(GlobalConstants.CQ_STATUS_APPROVED))) {
		isRecordToSync = true;
	}
			}
			else if(oldQuote==null ||(oldQuote<>null && (oldQuote.Apttus_Proposal__Approval_Stage__c <> newquote.Apttus_Proposal__Approval_Stage__c ||
	(newquote.CQ_eQuote__c && oldQuote.CQ_eQuote_Status__c <> newquote.CQ_eQuote_Status__c && newquote.CQ_eQuote_Status__c<> NULL &&
	 (newquote.CQ_eQuote_Status__c.equalsIgnoreCase(Globalconstants.EQUOTE_STATUS_SUCCESS) || 
	  newquote.CQ_eQuote_Status__c.equalsIgnoreCase(Globalconstants.EQUOTE_STATUS_FAILURE))))) ||			
	  (newquote.Apttus_Proposal__Approval_Stage__c.equalsIgnoreCase(GlobalConstants.CQ_STATUS_DRAFT) && (oldQuote.NokiaCPQ_Opportunity_Number__c <> newquote.NokiaCPQ_Opportunity_Number__c ||oldQuote.CQ_eQuote__c <> newquote.CQ_eQuote__c || 
		 oldQuote.Apttus_Proposal__Opportunity__c <> newquote.Apttus_Proposal__Opportunity__c ||  oldQuote.CurrencyIsoCode<> newquote.CurrencyIsoCode || oldQuote.Apttus_Proposal__Account__c <> newquote.Apttus_Proposal__Account__c ||
		 oldQuote.CQ_eQuote__c <> newquote.CQ_eQuote__c ||  oldQuote.CQ_Customer_Project_Code__c <> newquote.CQ_Customer_Project_Code__c ||  oldQuote.CQ_Customer_Project_Site_City__c <> newquote.CQ_Customer_Project_Site_City__c ||
		 oldQuote.CQ_Customer_Project_Site_State__c <> newquote.CQ_Customer_Project_Site_State__c ||  oldQuote.Apttus_Proposal__Description__c <> newquote.Apttus_Proposal__Description__c || oldQuote.CQ_Due_Date__c <> newquote.CQ_Due_Date__c || 
		 oldQuote.NokiaCPQ_OpportunityLeadBG__c <> newquote.NokiaCPQ_OpportunityLeadBG__c || oldQuote.CQ_Lead__c <> newquote.CQ_Lead__c || oldQuote.CQ_Master_Quote__c <> newquote.CQ_Master_Quote__c || 
		 oldQuote.CQ_Master_Quote_Quantity__c <> newquote.CQ_Master_Quote_Quantity__c || oldQuote.Apttus_Proposal__Proposal_Name__c <> newquote.Apttus_Proposal__Proposal_Name__c || oldQuote.CQ_Notes__c <> newquote.CQ_Notes__c || 
		 oldQuote.NokiaCPQ_Proposal_Id__c <> newquote.NokiaCPQ_Proposal_Id__c || oldQuote.NokiaCPQ_End_Customer__c <> newquote.NokiaCPQ_End_Customer__c || oldQuote.CQ_Sales_Lead__c <> newquote.CQ_Sales_Lead__c || 
		 oldQuote.CQ_Submitted_to_Customer_Date__c <> newquote.CQ_Submitted_to_Customer_Date__c ||oldQuote.CQ_Value__c <> newquote.CQ_Value__c ||oldQuote.CQ_Active__c <> newquote.CQ_Active__c ||
		 oldQuote.CQ_eQuote_Status__c <> newquote.CQ_eQuote_Status__c || oldQuote.CQ_Customer_Request_Number__c <> newquote.CQ_Customer_Request_Number__c)))
			{
	isRecordToSync=true;
			}
		}
		catch(Exception ex) {
			system.debug('Exception-->'+Ex.getMessage());
		}  
		return isRecordToSync;
	}
	
	/*****************************
*Method Name: CQ_eQuoteCheck
*Description: This method is used to update equote status field whenever QTC_Sold_To__c field in Account legal entity contains '8000405'
*Parameters:  Quote/Proposal List
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 06-05-2019
*******************************/	 
	public static void CQ_eQuoteCheck(list<Apttus_Proposal__Proposal__c> eQuote){
		//system.debug('eQuote--->>'+eQuote);
		try{	 
			String Qtc_value =system.label.VzW_Number;
			set<id> acc_id= new set<id>();
			map<id,string> acc_map = new map<id,string>();
			//list<Apttus_Proposal__Proposal__c> eQuote_list = new  list<Apttus_Proposal__Proposal__c>();
			for(Apttus_Proposal__Proposal__c cq_eq:eQuote){
	acc_id.add(cq_eq.Account_Legal_Entity__c);
			}
			//system.debug('acc_id-->>'+acc_id);
			for(Account acc:[select id,QTC_Sold_To__c from Account where id IN:acc_id and QTC_Sold_To__c =:Qtc_value])
	acc_map.put(acc.id,acc.QTC_Sold_To__c);
			//system.debug('acc_map-->>##'+acc_map);
			
			for(Apttus_Proposal__Proposal__c eq_check:eQuote){
	if((acc_map.containskey(eq_check.Account_Legal_Entity__c)) && (eq_check.CQ_eQuote__c==false)){
		eq_check.CQ_eQuote__c=true;
		//eQuote_list.add(eq_check);
	}
			}
			//system.debug('eQuote_list-->'+eQuote_list);		
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CQ_PROPOSALTRIGGERHELPER, GlobalConstants.CQ_eQuoteCheck);
		}
	}
	/*Method Name: CQ_StatusChange_NotificationEmail
*Description: This method is used to fetch the quote team members for the quotes when Approval Stage Field gets updated and send email to them.
*Parameters:  Quote/Proposal List
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 06-05-2019
*******************************/
	public static void CQ_StatusChange_NotificationEmail(Map<Id, Apttus_Proposal__Proposal__c> newMap_CQ, Map<Id, Apttus_Proposal__Proposal__c> oldMap_CQ){
		set<Id> QuoteId = new set<Id>();
		Map<Id,List<String>> QTeam=new Map<Id,List<String>>();
		Map<Id,Set<Id>> QTeam_Idlist=new Map<Id,Set<Id>>();
		Messaging.SingleEmailMessage[] emailList= new Messaging.SingleEmailMessage[] {};
			
			try{
	if(!GlobalConstants.CQ_SEND_EMAIL){
		for(Apttus_Proposal__Proposal__c Quote:newMap_CQ.values()){
			if((Quote.Apttus_Proposal__Approval_Stage__c<>oldMap_CQ.get(Quote.Id).Apttus_Proposal__Approval_Stage__c) && Quote.Apttus_Proposal__Approval_Stage__c!=GlobalConstants.Approvalstage_Rebid && (Quote.isCQ__c || Quote.CPQ_CQ_Check__c || Quote.CPQ_NCQ_Check__c)){
	if(Quote.CPQ_CQ_Check__c || Quote.CPQ_NCQ_Check__c) {
		if(Quote.Apttus_Proposal__Approval_Stage__c == 'Accepted') {
			QuoteId.add(Quote.Id);
		}
	} else {
		QuoteId.add(Quote.Id);
	}
			}
		}
		
		if(!(QuoteId.isEmpty()))
		{
			for(CQ_Quote_Team__c qt : [select CQ_CQ_Name__c, member_email__C,CQ_Quote_Team_Member__c from CQ_Quote_Team__c where CQ_CQ_Name__c in :QuoteId]) {
	if(!QTeam_Idlist.containskey(qt.CQ_CQ_Name__c)){
		//QTeam.put(qt.CQ_CQ_Name__c,new List<String>{qt.member_email__c});
		QTeam_Idlist.put(qt.CQ_CQ_Name__c,new Set<Id>{qt.CQ_Quote_Team_Member__c});
	}
	else{
		//if(!QTeam.get(qt.CQ_CQ_Name__c).contains(qt.member_email__c))
		//  QTeam.get(qt.CQ_CQ_Name__c).add(qt.member_email__c);
		if(!QTeam_Idlist.get(qt.CQ_CQ_Name__c).contains(qt.CQ_Quote_Team_Member__c))
			QTeam_Idlist.get(qt.CQ_CQ_Name__c).add(qt.CQ_Quote_Team_Member__c);
	}
			}
			
			
			// system.debug('QTeam: '+QTeam);
			//system.debug(QTeam.size());
			system.debug(QTeam_Idlist.keyset());
			List<EmailTemplate> template=[Select Id from EmailTemplate Where DeveloperName=:Label.CQ_ApprovalStage_UpdateNotification LIMIT :limitRows];
			String tid=template[0].Id;
			if(!QTeam_Idlist.isEmpty()){
	for(Id qpid:QTeam_Idlist.keyset()){
		System.debug('qpid+++'+qpid);
		map<string,string> output = EmailNotifications.ExtractHTMLbody(tid,qpid);
		//Messaging.SingleEmailMessage mail = EmailNotifications.sendmail(output.get('body'),output.get('subject'),QTeam.get(qpid));
		Messaging.SingleEmailMessage[] mail = EmailNotifications.sendmailwithtrgtobj(output.get('body'),output.get('subject'),QTeam_Idlist.get(qpid));
		//Messaging.SingleEmailMessage mail = ExtractHTMLbody(tid,qpid,QTeam.get(qpid));
		//mail.setTargetObjectId(userinfo.getUserId());
		emailList.addall(mail);
		
		System.debug('mailmail'+mail);
		system.debug('Loop++');
	}
	GlobalConstants.CQ_SEND_EMAIL=True;
			}
			if(!emailList.isEmpty()){
	
	Messaging.SendEmailResult[] EmailResult = Messaging.sendEmail(emailList,false);
	system.debug('email result: '+EmailResult);
			}
			
		}
	}
			}
		catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CQ_PROPOSALTRIGGERHELPER, GlobalConstants.CQ_StatusChange_NotificationEmail);
		}
	}
	
	/*****************************
*Method Name: CQTerritorysharing
*Description: This method is used to Share CQ's with the Territiry to which its account is associated
*Parameters:  Quote/Proposal map, Quote, Account map
*Created By: Accenture - May 2019
*Last Modified By: Accenture
*Last Modified Date: 30-05-2019
*******************************/	
	public static void CQTerritorysharing(Map<Id, Apttus_Proposal__Proposal__c> newMap_CQ, Map<Id,Id> CQ_Acct_map){
		
		try{
			map<Id,Id> Acct_tername_map = new map<Id,Id>();
			map<Id,Id> ter_grp_map = new map<Id,Id>();
			map<Id,Id> Acct_grp_map = new map<Id,Id>();
			Apttus_Proposal__Proposal__Share[] CQshareList = new Apttus_Proposal__Proposal__Share[]{};
	
	if(!CQ_Acct_map.isEmpty())
			{
	for(objectTerritory2Association obta : [select objectId, Territory2Id, Territory2.developername from objectTerritory2Association where objectId in :CQ_Acct_map.values()])
	{
		Acct_tername_map.put(obta.objectId, obta.Territory2Id);
	}
			}
			
			if(!Acct_tername_map.isEmpty())
			{
	for(group grp: [SELECT DeveloperName,Id,RelatedId,Type FROM Group WHERE Type = 'territory' and RelatedId in : Acct_tername_map.values()])
	{
		ter_grp_map.put(grp.RelatedId, grp.Id);
	}
			}
			
			if(!Acct_tername_map.isEmpty())
			{
	for(Id acc : Acct_tername_map.keyset())
	{
		if(ter_grp_map.get(Acct_tername_map.get(acc)) <> null)
		{
			Acct_grp_map.put(acc, ter_grp_map.get(Acct_tername_map.get(acc)));
		}
	}
			}
			
			for(Apttus_Proposal__Proposal__c CQ : newMap_CQ.values())
			{
	if(Acct_grp_map.get(CQ.Apttus_Proposal__Account__c) <> null){
		Apttus_Proposal__Proposal__Share CQshare = new Apttus_Proposal__Proposal__Share();
		
		CQshare.ParentId = CQ.Id;
		CQshare.AccessLevel = 'Edit';
		CQshare.UserOrGroupId = Acct_grp_map.get(CQ.Apttus_Proposal__Account__c);
		
		CQshareList.add(CQshare);
	}
			}
			
			database.insert(CQshareList,false);
		} catch( Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CQ_PROPOSALTRIGGERHELPER, GlobalConstants.M_CQTerritorysharing);
		}
		
	}
	
	/*****************************
*Method Name: CQTerritorysharingupdate
*Description: This method will Share CQ's with the Territiry to which its account is associated on Account and owner change
*Parameters:  Quote/Proposal map, Quote, Account map
*Created By: Accenture - May 2019
*Last Modified By: Accenture
*Last Modified Date: 30-05-2019
*******************************/	
	public static void CQTerritorysharingupdate(Map<Id, Apttus_Proposal__Proposal__c> newMap_CQ, Map<Id,Id> CQ_Acct_map){
		
		try{
			map<Id,Id> Acct_tername_map = new map<Id,Id>();
			map<Id,Id> ter_grp_map = new map<Id,Id>();
			map<Id,Id> Acct_grp_map = new map<Id,Id>();
			map<Id,Id> cqsharemap = new map<Id,Id>();
			map<Id,List<Apttus_Proposal__Proposal__Share>> CQshareidmap = new map<Id,List<Apttus_Proposal__Proposal__Share>>();
			Apttus_Proposal__Proposal__Share[] CQshareList = new Apttus_Proposal__Proposal__Share[]{};
	Apttus_Proposal__Proposal__Share[] CQsharedelList = new Apttus_Proposal__Proposal__Share[]{};  
		
		if(!CQ_Acct_map.isEmpty())
	{
		for(objectTerritory2Association obta : [select objectId, Territory2Id, Territory2.developername from objectTerritory2Association where objectId in :CQ_Acct_map.values()])
		{
			Acct_tername_map.put(obta.objectId, obta.Territory2Id);
		}
	}
			
			for(Apttus_Proposal__Proposal__Share cqshare : [SELECT ParentId,RowCause,UserOrGroupId,Id FROM Apttus_Proposal__Proposal__Share where Parent.quote_type__c = 'CQ' and UserOrGroup.Type = 'Queue' and parentId in :newMap_CQ.keySet()])
			{
	List<Apttus_Proposal__Proposal__Share> cqslist = new List<Apttus_Proposal__Proposal__Share>();
	cqslist.add(cqshare);
	cqsharemap.put(cqshare.ParentId, cqshare.UserOrGroupId);
	if(CQshareidmap.containsKey(cqshare.ParentId)){
		CQshareidmap.get(cqshare.ParentId).add(cqshare);
	} else{
		CQshareidmap.put(cqshare.ParentId, cqslist);
	}
			}
			system.debug('cqsharemap: '+cqsharemap);
			if(!Acct_tername_map.isEmpty())
			{
	for(group grp: [SELECT DeveloperName,Id,RelatedId,Type FROM Group WHERE Type = 'territory' and RelatedId in : Acct_tername_map.values()])
	{
		ter_grp_map.put(grp.RelatedId, grp.Id);
	}
			}
			
			if(!Acct_tername_map.isEmpty())
			{
	for(Id acc : Acct_tername_map.keyset())
	{
		if(ter_grp_map.get(Acct_tername_map.get(acc)) <> null)
		{
			Acct_grp_map.put(acc, ter_grp_map.get(Acct_tername_map.get(acc)));
		}
	}
			}
			
			for(Apttus_Proposal__Proposal__c CQ : newMap_CQ.values())
			{
	system.debug('CQ: '+CQ);
	system.debug('cqsharemap.get(CQ.Id): '+cqsharemap.get(CQ.Id));
	if(cqsharemap.get(CQ.Id) <> null)
	{
		system.debug('entered first If');
		Id CurrentCQsharedgrp = cqsharemap.get(CQ.Id);
		Id ShouldbeCQgrp = Acct_grp_map.get(CQ.Apttus_Proposal__Account__c);
		system.debug('CurrentCQsharedgrp: '+CurrentCQsharedgrp);
		system.debug('ShouldbeCQgrp: '+ShouldbeCQgrp);
		
		if(!CurrentCQsharedgrp.equals(ShouldbeCQgrp) ){
			Apttus_Proposal__Proposal__Share CQshare = new Apttus_Proposal__Proposal__Share();
			
			CQshare.ParentId = CQ.Id;
			CQshare.AccessLevel = 'Edit';
			CQshare.UserOrGroupId = Acct_grp_map.get(CQ.Apttus_Proposal__Account__c);
			
			CQshareList.add(CQshare);
			
			CQsharedelList.addall(CQshareidmap.get(CQ.Id));
		}
	} else{
		system.debug('entered else');
		Apttus_Proposal__Proposal__Share CQS = new Apttus_Proposal__Proposal__Share();
		
		CQS.ParentId = CQ.Id;
		CQS.AccessLevel = 'Edit';
		CQS.UserOrGroupId = Acct_grp_map.get(CQ.Apttus_Proposal__Account__c);
		
		CQshareList.add(CQS);
	}
	
			}
			system.debug('CQshareList: '+CQshareList);
			system.debug('CQshareListsize: '+CQshareList.size());
			system.debug('CQsharedelList: '+CQsharedelList);
			system.debug('CQsharedelListsize: '+CQsharedelList.size());
			Database.SaveResult[] saveresult =  Database.insert(CQshareList,false);
			Database.DeleteResult[] delresult =  Database.delete(CQsharedelList,false);
			
			system.debug('saveresult: '+saveresult);
			system.debug('delresult: '+delresult);
			
		} catch( Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.CQ_PROPOSALTRIGGERHELPER, GlobalConstants.M_CQTerritorysharingupdate);
		}
		
	}   
	
	public static void sendEmailtoCQLead(List<Apttus_Proposal__Proposal__c> quotes){
		try{
			Map<Id, String> userEmails = new Map<Id, String>();
			List <Messaging.SingleEmailMessage> mailList = new List <Messaging.SingleEmailMessage>();
			EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'NCQ_QuoteLead_UpdateNotification'];
			for(Apttus_Proposal__Proposal__c quote : quotes){
	map<string,string> output = EmailNotifications.ExtractHTMLbody(et.Id, quote.Id);
	Messaging.SingleEmailMessage[] mail = EmailNotifications.sendmailwithtrgtobj(output.get('body'),output.get('subject'), new Set<Id>{quote.CQ_Lead__c});
	mailList.addAll(mail);
			}
			Messaging.sendEmail(mailList);
		} catch (Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CQ_PROPOSALTRIGGERHELPER, 'sendEmailtoCQLead');
		}
	}
	public static void sendEmailtoCQLeadonApprovalStageChanges(List<Apttus_Proposal__Proposal__c> quotes){
		try{
			Map<Id, String> userEmails = new Map<Id, String>();
			List <Messaging.SingleEmailMessage> mailList = new List <Messaging.SingleEmailMessage>();
			EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'NCQ_ApprovalStage_UpdateNotification'];
			for(Apttus_Proposal__Proposal__c quote : quotes){
	Set<Id> userSet = new Set<Id>();
	if(quote.CQ_Lead__c != quote.CQ_Sales_Lead__c){
		userSet.add(quote.CQ_Lead__c);
		userSet.add(quote.CQ_Sales_Lead__c);
	} else {
		userSet.add(quote.CQ_Lead__c);
	}
	map<string,string> output = EmailNotifications.ExtractHTMLbody(et.Id, quote.Id);
	Messaging.SingleEmailMessage[] mail = EmailNotifications.sendmailwithtrgtobj(output.get('body'),output.get('subject'), userSet);
	mailList.addAll(mail);
			}
			system.debug('mailList'+mailList);
			Messaging.sendEmail(mailList);
			
		} catch (Exception ex){
			system.debug('mailList'+ex.getMessage());
			ExceptionHandler.addException(ex, GlobalConstants.CQ_PROPOSALTRIGGERHELPER, 'sendEmailtoCQLead');
		}
		
	}
}