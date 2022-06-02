/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:			OpportunityTeamHelper_PRM
Description:	 Helper for opportunity team trigger
Date		Version	  Author		Summary of Changes 
-----------	  ----------	  -----------------	---------------------------------------------------------------------------------------------------
04/04/2016	  1.0		Pooja			Handler Class
----------------------------------------------------------------------------------------------------------------------------------------------------------*/
public with sharing class AccountTriggerHandlerPRM{
/**
* Description : Method for after update action
* @param Id accountOldMap, accountNewMap 
* @return List
* @throws NA
**/
	public static void afterUpdate( Map<id,Account> accountOldMap , Map<id,Account> accountNewMap  ){
		try{
			Map<ID,Schema.RecordTypeInfo> rt_Map = Account.sObjectType.getDescribe().getRecordTypeInfosById(); 
			Map<id,Account> custAccountOldMap = new Map<id,Account>();
			Map<id,Account> custAccountNewMap = new Map<id,Account>();
			AccountTriggerHelperPRM.createPartnerCompany(accountOldMap,accountNewMap);
			AccountTriggerHelperPRM.updatePartnerCompanyOnChange(accountOldMap,accountNewMap);
			AccountTriggerHelperPRM.deletePartnerCompany(accountOldMap,accountNewMap);
			AccountTriggerHelperPRM.updateCertValueONPaertnerProgram(accountOldMap,accountNewMap);
			for(Account acc : accountNewMap.values())
			{
				if(rt_map.get(acc.RecordTypeId).getName().containsIgnoreCase(PRMGlobalConstants.CUSTOMER))
				{
					custAccountOldMap.put(acc.Id, accountOldMap.get(acc.Id));
					custAccountNewMap.put(acc.Id, acc);
				}
			}
			if(!custAccountOldMap.isEmpty())
			{
				AccountTriggerHelperPRM.updateARRtools(accountOldMap,accountNewMap);
			}
			
			AccountTriggerHelperPRM.accountOnwerChange(accountOldMap,accountNewMap);
			AccountTriggerHelperPRM.getAccountIdsToDisablePartnerUser(accountOldMap,accountNewMap);
			AccountTriggerHelperPRM.accountAcreditationUpdate(accountOldMap,accountNewMap);
			if(!test.isRunningTest())
			{
				AccountTriggerHelperPRM.createPartnerLibrary(accountOldMap,accountNewMap);
				
			}
		}
		catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.AccountTriggerHandlerPRM,PRMGlobalConstants.afterUpdate);
		}
	}
	
/********************
*Method Name: beforeUpdateOperation
*Parameter: Account List
*Description: Used to handle before Update activities
*1. Choose default legal entity
*******************/
	 public static void beforeUpdateOperation(List<Account> accountList) { 
		 try{
	 AccountTriggerHelperPRM.restrictEnablingPartner(accountList);
		 }
		 catch(System.Exception e){ ExceptionHandler.addException(e,PRMGlobalConstants.AccountTriggerHandlerPRM,PRMGlobalConstants.BEFORE_UPDATE_OPERATION);
		}
		 
	 }
	 
 /********************
*Method Name: AfterInsertOperation
*Parameter: Account List
*Description: Used to handle after insert activities
*1. autocrete Parner Library
*******************/
	 public static void afterInsertOperation(List<Account> accountList) { 
		 try{
	if(!test.isRunningTest()){
	 AccountTriggerHelperPRM.createPartnerLibraryAfterInsert(accountList);
		}
		 }
		 catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.AccountTriggerHandlerPRM,PRMGlobalConstants.afterInsertOperation);
		}
		 
	 }
/********************
*Method Name: AfterInsert/AfterUpdateAccountOperation
*Parameter: Account List
*Description: Used to handle after insert/update activities for COOP
*******************/
  public static void afterInsertForCOOP(List<Account> accountNewList) { 
	  try{
	//system.debug('dxgvdrfth**********handler*');
	List<Account> accountList = new List<Account>();
	for(Account accountNew : accountNewList){
	 if(accountNew.Enrolled_in_Co_Op__c){
	  accountList.add(accountNew);
	 }
	}
	if (accountList.size() > 0) {
	 AccountTriggerHelperPRM.coopEligibleAccountAccrualandFundCreation(accountList);
	}
	  }
	  catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.AccountTriggerHandlerPRM,PRMGlobalConstants.afterInsertForCOOP);
	}
	} 
/********************
*Method Name: afterUpdateForCOOP
*Parameter: Account List
*Description: Used to handle after insert/update funds for COOP
*******************/   
	public static void afterUpdateForCOOP(Map<id,Account> accountOldMap ,List<Account> accountNewList) { 
		try{
			//system.debug('dxgvdrfth**********handler*');
			List<Account> accountList = new List<Account>();
			for(Account accountNew : accountNewList){
	if((accountOldMap.get(accountNew.id).Enrolled_in_Co_Op__c != accountNew.Enrolled_in_Co_Op__c) 
	&& accountNew.Enrolled_in_Co_Op__c ){
		accountList.add(accountNew);
	}
			}
			if (accountList.size() > 0 && PRMGlobalConstants.AccountAfterUpdate) {
	PRMGlobalConstants.AccountAfterUpdate = false;
	AccountTriggerHelperPRM.coopEligibleAccountAccrualandFundCreation(accountList);
			}
		}
		
		catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.AccountTriggerHandlerPRM,PRMGlobalConstants.afterUpdateForCOOP);
		 }
	}
	 
}