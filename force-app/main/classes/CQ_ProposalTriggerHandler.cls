/*Description: Handler Class for Quote/Proposal Trigger for Contracted Quote Record Type
*******************************/
public with sharing class CQ_ProposalTriggerHandler {
	Public static final Id Contracted_Quote_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get(Label.CQ_RecordTypeId).getRecordTypeId();
	Public static final Id CQ_Read_Only_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CQ_Read_Only').getRecordTypeId();
	//added by Rajitha
	public static final Id NCQ_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_NCQ_Quote').getRecordTypeId();
	public static final Id NCQ_ReadOnly_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NCQ_ReadOnly_Recordtype').getRecordTypeId();
	//added by jithin
	public static final Id New_CQ_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_CQ_Quote').getRecordTypeId();
	public static final Id New_CQ_ReadOnly_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_CQ_Quote_Read_Only').getRecordTypeId();

   //End
	/*****************************
/*Method Name: BeforeInsert
*Description: This method is used to create quote team on CQ quote creation
*Parameters:  Quote/Proposal List
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 19-04-2019
*******************************/
	public static void BeforeInsert(list<Apttus_Proposal__Proposal__c> CQ_newList){ 
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
		{
			//Record type check	 
			list<Apttus_Proposal__Proposal__c> CQ_newList_WithRecord=new list<Apttus_Proposal__Proposal__c>();	
			for(Apttus_Proposal__Proposal__c Quote:CQ_newList)
	//updated by Rajitha && updated by jithin (added cq checks)
	if(QUote.RecordtypeId<>null&&(QUote.RecordtypeId==Contracted_Quote_RecId || QUote.RecordtypeId==CQ_Read_Only_RecId || QUote.RecordtypeId == NCQ_RecId || QUote.RecordtypeId == NCQ_ReadOnly_RecId || QUote.RecordtypeId == New_CQ_RecId || QUote.RecordtypeId == New_CQ_ReadOnly_RecId))
	//End
	CQ_newList_WithRecord.add(Quote);
			
			//IF CQ Records There Available
			if(!CQ_newList_WithRecord.isempty()){
	CQ_ProposalTriggerHelper.CQ_eQuoteCheck(CQ_newList_WithRecord);
	CQ_ProposalTriggerHelper.createQuoteNumber(CQ_newList_WithRecord);
			}
			beforeInsertTransportation(CQ_newList);
		}
	}
	/*Method Name: AfterInsert
*Description: This method is used to create quote team on CQ quote creation
*Parameters:  Quote/Proposal Map
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 19-04-2019
*******************************/
	public static void AfterInsert(Map<Id,Apttus_Proposal__Proposal__c> CQ_newMap){
		try{
			if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
			{
	//Record type check
	Map<Id,Apttus_Proposal__Proposal__c> CQ_newMap_WithRecord=new  Map<Id,Apttus_Proposal__Proposal__c>();
	Map<Id,Id> CQ_Acct_map = new Map<Id,Id>();
	//Added by Rajitha
	List<Apttus_Proposal__Proposal__c> emailQuotes = new List<Apttus_Proposal__Proposal__c>();
	//
	for(Apttus_Proposal__Proposal__c Quote:CQ_newMap.values())
	{
	//Updated by Rajitha
		if(QUote.RecordtypeId<>null&&(QUote.RecordtypeId==Contracted_Quote_RecId ||QUote.RecordtypeId==CQ_Read_Only_RecId || QUote.RecordtypeId== NCQ_RecId || QUote.RecordtypeId == NCQ_ReadOnly_RecId || QUote.RecordtypeId == New_CQ_RecId || QUote.RecordtypeId == New_CQ_ReadOnly_RecId))
		//End
		{
			CQ_newMap_WithRecord.put(Quote.Id, Quote);
			CQ_Acct_map.put(Quote.Id, Quote.Apttus_Proposal__Account__c);
		}
		//added by Rajitha
		if((Quote.RecordTypeId == NCQ_RecId || Quote.RecordTypeId == New_CQ_RecId) && Quote.CQ_Lead__c != Quote.OwnerId){
			emailQuotes.add(Quote);
		}
		//end
	}
	//IF CQ Records There Available
	if(!CQ_newMap_WithRecord.isEmpty()){
		
		CQ_QuotetoReporting.CQ_Report_Insert(CQ_newMap_WithRecord);
		CQ_ProposalTriggerHelper.Sync_QuotestoEAI(CQ_newMap_WithRecord,null);
		CQ_ProposalTriggerHelper.createQuoteTeamoncqcreation(CQ_newMap_WithRecord.values());
		CQ_ProposalTriggerHelper.CQTerritorysharing(CQ_newMap_WithRecord, CQ_Acct_map);
	}
	
	//added by Rajitha
	if(emailQuotes != null && !emailQuotes.isEmpty()){
		CQ_ProposalTriggerHelper.sendEmailtoCQLead(emailQuotes);
	}
	//end
			}
		}
		catch(exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CQ_ProposalTriggerHandler, GlobalConstants.CQ_ProposalTriggerHandler_AfterInsert);  
		}
	}
	/*Method Name: BeforeUpdate
*Description: This method is used to create quote team on CQ quote creation
*Parameters:  Quote/Proposal Map
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 19-04-2019
*******************************/ 
	public static void BeforeUpdate(Map<Id,Apttus_Proposal__Proposal__c> newMap, Map<Id,Apttus_Proposal__Proposal__c> oldMap){
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
		{
			//Record type check
			Map<Id,Apttus_Proposal__Proposal__c> CQ_newMap_WithRecord=new  Map<Id,Apttus_Proposal__Proposal__c>();
			
			for(Apttus_Proposal__Proposal__c Quote:newMap.values())
	//Updated by Rajitha
	if(QUote.RecordtypeId<>null&&(QUote.RecordtypeId==Contracted_Quote_RecId ||QUote.RecordtypeId==CQ_Read_Only_RecId || QUote.RecordtypeId== NCQ_RecId || QUote.RecordtypeId == NCQ_ReadOnly_RecId || QUote.RecordtypeId == New_CQ_RecId || QUote.RecordtypeId == New_CQ_ReadOnly_RecId))
	//End
		CQ_newMap_WithRecord.put(Quote.Id, Quote);
			
			if(!CQ_newMap_WithRecord.isempty() 
	&& !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) 
	&& GlobalConstants.IS_CQHANDLERUPDATEFIRSTRUN){
		
	GlobalConstants.IS_CQHANDLERUPDATEFIRSTRUN = False;
	//If this is an inbound update message from EAI, then call these methods
	if(GlobalConstants.IS_INBOUND){
		CQ_ProposalTriggerHelper.updateSurroundPricedAccount(CQ_newMap_WithRecord.values(),oldMap);
		CQ_ProposalTriggerHelper.updateeQuoteStatus(oldMap.values(),CQ_newMap_WithRecord);
	}	
			}
			//beforeInsertTransportation(newMap.values());
		}
	}
	/*Method Name: AfterUpdate
*Description: This method is used to create quote team on CQ quote creation
*Parameters:  Quote/Proposal Map
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 19-04-2019
*******************************/
	public static  void AfterUpdate(Map<Id,Apttus_Proposal__Proposal__c> newMap, Map<Id,Apttus_Proposal__Proposal__c> oldMap){
		try{
			if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
			{   
	//Record type check
	Map<Id,Apttus_Proposal__Proposal__c> CQ_newMap_WithRecord=new  Map<Id,Apttus_Proposal__Proposal__c>();
	Map<Id,Apttus_Proposal__Proposal__c> CQ_newMap_QTchanges=new  Map<Id,Apttus_Proposal__Proposal__c>();
	Map<Id,Apttus_Proposal__Proposal__c> CQ_sharingchagnes=new  Map<Id,Apttus_Proposal__Proposal__c>();
	Map<Id,Id> CQ_Acct_map = new Map<Id,Id>();
	//Added by Rajitha
	List<Apttus_Proposal__Proposal__c> emailQuotes = new List<Apttus_Proposal__Proposal__c>();
	List<Apttus_Proposal__Proposal__c> approvedQuotes = new List<Apttus_Proposal__Proposal__c>();
	//
	
	for(Apttus_Proposal__Proposal__c Quote:newMap.values()){
		//updated by Rajitha
		if(QUote.RecordtypeId<>null&&(QUote.RecordtypeId==Contracted_Quote_RecId ||QUote.RecordtypeId==CQ_Read_Only_RecId || QUote.RecordtypeId== NCQ_RecId || QUote.RecordtypeId == NCQ_ReadOnly_RecId || QUote.RecordtypeId == New_CQ_RecId || QUote.RecordtypeId == New_CQ_ReadOnly_RecId))
		//End
		{
			CQ_newMap_WithRecord.put(Quote.Id, Quote);
			if(Quote.OwnerId <> oldMap.get(Quote.Id).ownerId || quote.Apttus_Proposal__Account__c <> oldMap.get(Quote.Id).Apttus_Proposal__Account__c){
	system.debug(' entered CQ_sharingchagnes');
	CQ_Acct_map.put(Quote.Id, Quote.Apttus_Proposal__Account__c);
	CQ_sharingchagnes.put(Quote.Id, Quote);
			}
			if((Quote.CQ_Lead__c <> oldMap.get(Quote.Id).CQ_Lead__c && Quote.CQ_Lead__c <> null) || (Quote.CQ_Sales_Lead__c <> oldMap.get(Quote.Id).CQ_Sales_Lead__c && Quote.CQ_Sales_Lead__c <> null)){
	CQ_newMap_QTchanges.put(Quote.Id,Quote);
			}
			
		}
		//added by Rajitha
		if((Quote.RecordTypeId == NCQ_RecId || Quote.RecordTypeId == New_CQ_RecId) && Quote.CQ_Lead__c != oldMap.get(Quote.Id).CQ_Lead__c && 
		Quote.CQ_Lead__c != Quote.OwnerId){
		 emailQuotes.add(Quote);
		}
		if((Quote.RecordTypeId == NCQ_RecId || Quote.RecordTypeId == New_CQ_RecId) && Quote.Apttus_Proposal__Approval_Stage__c != oldMap.get(Quote.Id).Apttus_Proposal__Approval_Stage__c && 
		Quote.Apttus_Proposal__Approval_Stage__c == 'Approved'){
		 approvedQuotes.add(Quote);
		}
		//end
		system.debug('  c.getQuickActionName()--> '+Quote.getQuickActionName());
	}
	//IF CQ Records There Available
	if(!CQ_newMap_WithRecord.isempty()){
		if( GlobalConstants.CQ_AFTERUPDATEHANDLERFIRSTRUN){
			GlobalConstants.CQ_AFTERUPDATEHANDLERFIRSTRUN = false;
			CQ_ProposalTriggerHelper.CQ_QuoteVersion_Active(CQ_newMap_WithRecord,oldMap);
			
			CQ_ProposalTriggerHelper.CQ_StatusChange_NotificationEmail(newMap,oldMap);
			
			if(!CQ_sharingchagnes.isempty()){
	CQ_ProposalTriggerHelper.CQTerritorysharingupdate(CQ_sharingchagnes,CQ_Acct_map);
			}
			if(!CQ_newMap_QTchanges.isempty()){
	CQ_ProposalTriggerHelper.CQ_QuoteTeammemberUpdate(CQ_newMap_WithRecord,oldMap);
			}
			
		}
		
		
		Globalconstants.REC_Count=Globalconstants.REC_Count+1;
		CQ_QuotetoReporting.CQ_Report_Update(CQ_newMap_WithRecord.values());
		
		if(!GlobalConstants.IS_CQUPDATEPRICINGMSG && !GlobalConstants.IS_PROCESS_QUOTE_SYNC ){
			CQ_ProposalTriggerHelper.Sync_QuotestoEAI(CQ_newMap_WithRecord,oldMap);
		}
		
	}
	//added by Rajitha
	if(emailQuotes != null && !emailQuotes.isEmpty()){
		CQ_ProposalTriggerHelper.sendEmailtoCQLead(emailQuotes);
	}
	if(approvedQuotes != null && !approvedQuotes.isEmpty()){
		CQ_ProposalTriggerHelper.sendEmailtoCQLeadonApprovalStageChanges(approvedQuotes);
	}
	//end
			}  
		}catch(exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CQ_ProposalTriggerHandler, GlobalConstants.CQ_ProposalTriggerHandler_AfterUpdate);			
		}
	}
	/*Method Name: BeforeDelete
*Description: This method is used to create quote team on CQ quote creation
*Parameters:  Quote/Proposal list
*Created By: Accenture - April 2019
*Last Modified By: Accenture
*Last Modified Date: 19-04-2019
*******************************/
	public static void BeforeDelete(list<Apttus_Proposal__Proposal__c> newList){
		try{
			if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
			{
	//Record type check
	Map<Id,Apttus_Proposal__Proposal__c> CQ_newMap_WithRecord=new  Map<Id,Apttus_Proposal__Proposal__c>();
	for(Apttus_Proposal__Proposal__c Quote:newList)
	//Added by Rajitha
		if(QUote.RecordtypeId<>null&&(QUote.RecordtypeId==Contracted_Quote_RecId ||QUote.RecordtypeId==CQ_Read_Only_RecId || QUote.RecordtypeId== NCQ_RecId || QUote.RecordtypeId== New_CQ_RecId || QUote.RecordtypeId == NCQ_ReadOnly_RecId || QUote.RecordtypeId == New_CQ_ReadOnly_RecId))
		//End
		CQ_newMap_WithRecord.put(Quote.Id, Quote);
	
	//IF CQ Records There Available
	if(!CQ_newMap_WithRecord.isempty()){
		CQ_QuotetoReporting.CQ_Report_Delete(CQ_newMap_WithRecord.values());
	}
			}
		}catch(exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CQ_ProposalTriggerHandler, GlobalConstants.CQ_ProposalTriggerHandler_BeforeDelete);	 
		}
	}
	
	// Added logic for chech box checking "CPQ_Include_Transportation__c"
	public static void beforeInsertTransportation(list<Apttus_Proposal__Proposal__c> CQ_newList) {
		Map<Id,CPQ_TransportMap__c> transportMap = new Map<Id,CPQ_TransportMap__c>();
		List<Id> accountIds = new List<Id>();
		for(Apttus_Proposal__Proposal__c aptus : CQ_newList) {
			if(aptus.Apttus_Proposal__Account__c != NULL) {
				accountIds.add(aptus.Apttus_Proposal__Account__c);				
			}			
			
		}
		
		if(accountIds.size() > 0 ) {
			for(CPQ_TransportMap__c trp : [Select CPQ_Account__c,CPQ_Product__c from CPQ_TransportMap__c where CPQ_Account__c =:accountIds AND CPQ_Product__c=NULL  ]) {
				
				transportMap.put(trp.CPQ_Account__c,trp);
				
			}			
		}
		if(!transportMap.isEmpty()) {
			for(Apttus_Proposal__Proposal__c aptus : CQ_newList) {
				if(transportMap.containsKey(aptus.Apttus_Proposal__Account__c) && transportMap.get(aptus.Apttus_Proposal__Account__c).CPQ_Product__c==NULL ) {
					aptus.CPQ_Include_Transportation__c =true;
				}
				
			}
			
		}
		
	}
	
}