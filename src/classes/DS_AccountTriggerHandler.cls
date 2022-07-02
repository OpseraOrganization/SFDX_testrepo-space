/*******************************
	Class name :DS_AccountTriggerHandler	 
	Created by: Accenture
	Description: This handler is written for the Trigger on Account  object
	Team: Digital Sales
	*******************************/
public without sharing class DS_AccountTriggerHandler {
/******************************************************************************************************
Name : afterInsertOperation
Description : This method is used to perform after insert operations on Accounts
Parameter : List of CurrentRecord ids, Map of newly inserted records
*********************************************************************************************************/	
   public static void afterInsertOperation(List<Account> accountList){
	   try{
			Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosById();
			for(Account accRecord : accountList){
			   if(rtMap.get(accRecord.RecordTypeId).getName().equals(CSWXGlobalConstant.recordTypeLogisticAccount) && !String.isBlank(accRecord.parentId)){
				  DS_AccountTriggerHelper.assignTerritory(accountList);   
				}
		 }
	   }catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_AccountTriggerHandlerClass, CSWXGlobalConstant.afterInsertOperationmethod);}
   }
   
	 /******************************************************************************************************
	Name : afterUpdateOperation
	Description : This method will call quable apex to share DS quote with New accotn owner
	Parameter : Acount old n new map
	*********************************************************************************************************/
	public static void afterUpdateOperation(Map<id,Account> accountOldMap , Map<id,Account> accountNewMap){
		try{
			List<Account> accountListOld = new List<Account>();
			List<Account> accountListNew = new List<Account>();
			for(Account a : accountNewMap.values()) {
				   if(a.DMP_Account__c && a.ownerId != accountOldMap.get(a.Id).ownerId) {
					   accountListOld.add(accountOldMap.get(a.Id));
					   accountListNew.add(a);
				   }
			   }
			   if(!accountListNew.isEmpty()){
					System.enqueuejob(new  DS_quoteShareonAccountOwnerChange(accountListOld, accountListNew));
			   }
		}
	   catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_AccountTriggerHandlerClass, CSWXGlobalConstant.DSaterUpfateMethod);
	   }
   }
   
   /******************************************************************************************************
	Name : ProcessOnlyDMPAccount 
	Description : 
	Parameter : 
	*********************************************************************************************************/
   
   
   public static void ProcessOnlyDMPAccount (Map<Id,Account> oldAccMap , Map<Id,Account> newAccMap) {
	  try{  
		List<Account> lastAccountToBeupdate = new List<Account>();
		if(oldAccMap != null) {
			for(String key : oldAccMap.keySet()) {
				Account OldAccount =  oldAccMap.get(key);
				Account newAccount = newAccMap.get(key);
				if((OldAccount.DMP_Account__c  !=  newAccount.DMP_Account__c  &&  newAccount.DMP_Account__c == True) || ((OldAccount.OwnerId  !=  newAccount.OwnerId) && newAccount.DMP_Account__c == True)) {
					lastAccountToBeupdate.add(newAccount);
				}
			}
		}
		
		//Below code will be fired  for newly Created Record. 
		if(oldAccMap  == null) {
			
			for(String key : newAccMap.keySet()) {
				Account newAccount = newAccMap.get(key);
				lastAccountToBeupdate.add(newAccount);
			}
		}
		System.debug('************lastAccountToBeupdate*************'+lastAccountToBeupdate);
		if(!lastAccountToBeupdate.isEmpty()) {
			DS_AccountTriggerHelper.AssignTheCommunityUserWithAccountOwner(lastAccountToBeupdate);
			
		}
		}
		catch(Exception ex) {
			ExceptionHandler.addException(ex,'ProcessOnlyDMPAccount' ,'');
		}
	}
}