/*******************************
 Class name :DS_AccountContactRelationTriggerHelper	 
 Created by: Accenture
 Description: This helper is written for the Trigger on Account Contact Relationship object
 Team: Digital Sales
*******************************/
public without sharing class DS_AccountContactRelationTriggerHelper {
  /******************************************************************************************************
Name : checkRecordExist
Description : This method is used check if contact added for Logistics account(Tier 3) exists at Legal Account(Tier 2) or not.
Parameter : List of CurrentRecord ids
*********************************************************************************************************/	
	public static void checkRecordExist(List<AccountContactRelation> accountContactList){
		
		try{
			
		System.debug('new inserted records on ACL'+accountContactList);
		Set <ID> logisticAccountset = new Set<Id>();
		Set <ID> legalEntityAccountIdSet = new Set<Id>();
		Set <ID> contactSet = new Set<Id>();
	   
		for(AccountContactRelation ACL : accountContactList){
		   logisticAccountset.add(ACL.AccountID);
		   contactSet.add(ACL.ContactID);
		 }
		
		 System.debug('Accountset'+logisticAccountset);
		 System.debug('contactSet'+contactSet);
		
  
		 Map<ID,Id> logistcalAccountLegalMap = new Map<Id,Id>();
		 for(Account acc : [Select Name, RecordTypeID, ParentID from Account where Id IN: logisticAccountset LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			legalEntityAccountIdSet.add(acc.ParentId);
			logistcalAccountLegalMap.put(acc.Id,acc.ParentId);
		   }
		 System.debug('parentAccountset>>>>>'+legalEntityAccountIdSet);
		 System.debug('contactSet'+contactSet);
		 
		 Map<String, AccountContactRelation> existingAccContactRelationMap = new Map<String, AccountContactRelation>();
		
		 for(AccountContactRelation objAccContactrelation : [Select AccountID, ContactID, Roles from AccountContactRelation where AccountID IN : legalEntityAccountIdSet AND ContactID IN : contactSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())] ){
			existingAccContactRelationMap.put(objAccContactrelation.AccountId+CSWXGlobalConstant.dash+objAccContactrelation.ContactId, objAccContactrelation);
			
		}
		
		//This  code will form the map by keeping the AccountId as key and Its Parent as value
		system.debug('existingAccContactRelationMap>>>>'+existingAccContactRelationMap);
		
		Map<String, AccountContactRelation> newAccContactRelationMap = new Map<String, AccountContactRelation>();
		 for (AccountContactRelation ACL : accountContactList){
			 if(logistcalAccountLegalMap.containsKey(ACL.AccountId)) {
				 String key =logistcalAccountLegalMap.get(ACL.AccountId)+CSWXGlobalConstant.dash+ACL.ContactId;
				if(!existingAccContactRelationMap.containsKey(key)){
						 ACL.adderror(CSWXGlobalConstant.logisticAccError); 
				}
			 }	 
			
		} 
			
			
		}catch(Exception ex) {ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_AccountContactRelationTriggerHelperClass,CSWXGlobalConstant.checkRecordExistmethod);} 
		
		
	}

}