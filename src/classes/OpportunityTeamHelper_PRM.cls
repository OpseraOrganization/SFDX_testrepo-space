/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:			OpportunityTeamHelper_PRM
Description:	 Helper for opportunity team trigger
Date		Version	  Author		Summary of Changes 
-----------	  ----------	  -----------------	---------------------------------------------------------------------------------------------------
04/04/2016	  1.0		Rohan			Helper Class
----------------------------------------------------------------------------------------------------------------------------------------------------------*/



public without sharing class OpportunityTeamHelper_PRM{
	/**
* Description : shareFilesOnInsert 
* @param opptyTeamList
* @return NA
* @throws NA
  Req 2552 Partner Access to only their Sales Support Request Cases
**/
	public static void shareFilesOnInsert(List<OpportunityTeamMember> opptyTeamList)
	{
		List<CaseShare> caseShareToInsert  = new List<CaseShare>();
		set<Id> opptyId = new set<Id>();
		set<Id> userSet = new set<Id>();
		Map<id,Set<id>> otmToOpptyMap = new Map<id,Set<id>>();
		try{
				Set<id> userId = new Set<id>();		 
			for(OpportunityTeamMember opptyTeam : opptyTeamList)
			{
			 if(otmToOpptyMap.Containskey(opptyTeam.OpportunityId)){
					userId = otmToOpptyMap.get(opptyTeam.OpportunityId);
				}
				userId.add(opptyTeam.userId);
				otmToOpptyMap.put(opptyTeam.OpportunityId,userId);
				userSet.add(opptyTeam.userId);
				opptyId.add(opptyTeam.OpportunityId);
			}
			//List<Case> caseList = [SELECT Id,Opportunity__c FROM Case WHERE Opportunity__c in : opptyId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			
					
			for(Case caseRec: [SELECT Id,Opportunity__c FROM Case WHERE Opportunity__c in : opptyId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
				
				for(id userIdInstance : otmToOpptyMap.get(caseRec.Opportunity__c)){  
					CaseShare share = new CaseShare();				  
					share.UserOrGroupId = userIdInstance;
					share.CaseId = caseRec.Id;
					share.CaseAccessLevel = PRMGlobalConstants.READ;
					share.RowCause = PRMGlobalConstants.MANUAL;
					caseShareToInsert.add(share);
				}
				
			}
			
			if(!caseShareToInsert.IsEmpty()){
				database.Insert(caseShareToInsert);
			}
		}catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.OPPORTUNITY_TEAM_HELPER_PRM,PRMGlobalConstants.SHARE_FILES_ON_INSERT);
		}
		
		
	}
	/**
* Description : unshareFilesOnDelete 
* @param opptyTeamList
* @return NA
* @throws NA
**/
	public static void unshareFilesOnDelete(List<OpportunityTeamMember> opptyTeamList)
	{
		set<Id> opptyId = new set<Id>();
		set<Id> userSet = new set<Id>();
		try{
			for(OpportunityTeamMember opptyTeam : opptyTeamList)
			{
				userSet.add(opptyTeam.userId);
				opptyId.add(opptyTeam.OpportunityId);
			}
			//List<Case> caseList = [SELECT Id FROM Case WHERE Opportunity__c in : opptyId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			set<Id> caseIdSet = new set<Id>();
			for(Case caseRec: [SELECT Id FROM Case WHERE Opportunity__c in : opptyId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
				caseIdSet.add(caseRec.Id);
			}
			List<CaseShare> shareList = [Select Id from CaseShare where CaseId in : caseIdSet and UserOrGroupId in : userSet Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			
			if(!shareList.IsEmpty()){
				database.delete(shareList);
			  
			}  
		}catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.OPPORTUNITY_TEAM_HELPER_PRM,PRMGlobalConstants.UNSHARE_FILES_ON_DELETE);		 
		}
	}

	/*******************************
	*Method name: deletePartnerFromDiffAccount
	*Description: This method will stop user from adding non account partner in OTM
	*Parameter: Opportunity Values
	*******************************/  
	public static void deletePartnerFromDiffAccount(OpportunityTeamMember otm){
		try{
			set<Id> opptyId = new set<Id>();
			set<Id> contactAccId = new set<Id>();
			List<contact> contactAcc = new list<contact>();
			Opportunity oppty = new Opportunity();
			oppty = [SELECT ID, Account.Name,AccountId, PartnerAvailable__c FROM Opportunity WHERE ID =: otm.OpportunityId Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			OpportunityTeamMember opptyTeamMember = new OpportunityTeamMember();
			OTM_Sharing_Exception__c customMap = OTM_Sharing_Exception__c.getValues(oppty.AccountId);
			List<Id> contactAccount = new List<Id>();
			String strAccounts;
			String strAccounts2;
			contactAcc = [SELECT Accountid FROM Contact WHERE id in (Select contactId from User where id =: otm.userid) limit 1];
			if(contactAcc[0].Accountid != oppty.AccountId && oppty.PartnerAvailable__c == PRMGlobalConstants.YES && customMap == null){
				otm.UserId.addError(PRMGlobalConstants.deletePartnerFromDiffAccountValidationError);
			}else if(contactAcc[0].Accountid != oppty.AccountId && oppty.PartnerAvailable__c == PRMGlobalConstants.YES && customMap != null){
					strAccounts = customMap.Contact_Account_Name__c;					
					strAccounts2 = customMap.Contact_Account_Name2__c;
					if(strAccounts2 != null ){
						strAccounts = strAccounts + PRMGlobalConstants.SemiColon + strAccounts2;
					}
					contactAccount = strAccounts.split(PRMGlobalConstants.SemiColon);
					
			}
			else {
			
				 }
				if(!contactAccount.IsEmpty()){
					
					  contactAccId.addAll(contactAccount);
			   
					if(!contactAccId.Contains(contactAcc[0].Accountid)){
						otm.UserId.addError(PRMGlobalConstants.deletePartnerFromDiffAccountValidationError);
					}
				}
			
			else{
		   
				}
		}catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.OPPORTUNITY_TEAM_HELPER_PRM,PRMGlobalConstants.deletePartnerFromDiffAccount);		 
		}
	}
}