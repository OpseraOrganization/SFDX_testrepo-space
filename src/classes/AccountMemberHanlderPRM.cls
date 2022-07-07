/********************************************************************************************************************************************************
Name:			AccountTeamMemberPRM
Description:	 Helper for AccountMemberHanlderPRM
Date		Version	  Author		Summary of Changes 
-----------	  ----------	  -----------------	---------------------------------------------------------------------------------------------------
04/04/2016	  1.0		Pooja			Helper Class
----------------------------------------------------------------------------------------------------------------------------------------------------------*/
public without sharing class AccountMemberHanlderPRM
{
	
	
	/**
* Description : sharePSM 
* @param accTeamList
* @return NA
* @throws NA
**/
	public static void sharePSM(List<Account_Member__c> accTeamList){
		List<User> userList = new List<User>();
		userList = [SELECT ProfileId,Name,Id FROM User WHERE ProfileId =: system.label.Nokia_Sales_Profile_Id 
					Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		try{
			AccountMemberHelperPRM.shareCertificationOnInsertPSM(accTeamList, userList);
			AccountMemberHelperPRM.shareFundOnInsertAccMember(accTeamList);
		}catch(Exception e) {ExceptionHandler.addException(e,PRMGlobalConstants.AccountMemberHanlderPRM,PRMGlobalConstants.sharePSM);
							}
	}
	
	/**
* Description : shareUpdatePSM
* @param accTeamList
* @return NA
* @throws NA
**/
	public static void shareUpdatePSM(List<Account_Member__c> accTeamList,Account_Member__c accTeamOLD, Account_Member__c accTeamNEW){
		List<User> userList = new List<User>();
		userList = [SELECT ProfileId,Name,Id FROM User WHERE ProfileId =: system.label.Nokia_Sales_Profile_Id 
					Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		try{
			AccountMemberHelperPRM.shareCertificationOnUpdatePSM(accTeamList, accTeamOLD, accTeamNEW, userList);
			AccountMemberHelperPRM.shareCertificationOnUpdateAccountRolePSM(accTeamList, accTeamOLD, accTeamNEW, userList);
		}catch(Exception e) { ExceptionHandler.addException(e,PRMGlobalConstants.AccountMemberHanlderPRM,PRMGlobalConstants.shareUpdatePSM);
							}
	}
	
	public static void beforeInsertOperation(List<Account_Member__c> accTeamList){
		try{
			AccountMemberHelperPRM.validateAccMember(accTeamList, false);
		}catch(Exception e) { ExceptionHandler.addException(e,PRMGlobalConstants.AccountMemberHanlderPRM,PRMGlobalConstants.beforeInsertOperation);}
	}
	
	public static void beforeUpdateOperation(List<Account_Member__c> accTeamList){
		try{
			AccountMemberHelperPRM.validateAccMember(accTeamList, true);
		}catch(Exception e) { ExceptionHandler.addException(e,PRMGlobalConstants.AccountMemberHanlderPRM,PRMGlobalConstants.beforeUpdateOperation);}
	}
}