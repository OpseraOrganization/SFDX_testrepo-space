/****************************************
* Class Name : CH_UpdateFlagOnAccountBatch
* Created Date: 26 February 2019
* Created By : Mahati Krishna (mahatikrishna.chitta@tcs.com)
* Last Modified by: Mahati Krishna
* Last Modified Date: 26 February 2019
* Description : This batch class is used to update CH_CareContract__c flag on account
* Reference: NOKIASC-13997
* Test Class: NA
*****************************************/
global class CH_UpdateFlagOnAccountBatch implements  Schedulable, Database.Batchable<sObject>, Database.Stateful {
	
	global List < Account > accountList;   
	
	global CH_UpdateFlagOnAccountBatch() {
		accountList = new List < Account > ();
	} 
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		String query = 'SELECT Id, CH_CareContract__c FROM Account WHERE RecordType.DeveloperName = \'Legal_Entity\' AND Active__c = true'; 
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List < sObject > scope) {		
		for (sObject tempObj: scope) {
			Account accountObj = (Account) tempObj;
			accountList.add(accountObj);
		}		
		try {
			if (accountList.size() >= 5000 ) {
				updateAccountField(accountList);
			}		  
		} catch(Exception ex) {
			System.debug('### An exception has occurred : ' + ex.getMessage());
		}			
	}
	
	global void finish(Database.BatchableContext BC) {
		try{
			if (!accountList.isEmpty()) {
				updateAccountField(accountList);
			} 
		}catch(Exception ex) {
			System.debug('### An exception has occurred : ' + ex.getMessage());
		} 
	}
	
	/********************
	* Method Name: updateAccountField
	* Parameter: Set < Id > accountIds
	* Description: Used to update CH_CareContract__c field on Account
	* Reference: NOKIASC-13997
	*******************/
	global void updateAccountField (List < Account > accountList) { 
		if(accountList != null && !accountList.isEmpty()) {
			Set < Id > accountIds = new Set < Id > ();
			for(Account accountObj: accountList) {
				accountIds.add(accountObj.Id);
			}
			
			//Map for get key value pair of account and related list of service contract which are active
			Map < Id, List < ServiceContract >> serviceContractMap = new Map < Id, List < ServiceContract >> ();
			for (ServiceContract serviceObject: [SELECT Id, AccountId, Status FROM ServiceContract WHERE AccountId =: accountIds AND CH_RecordTypeCheck__c = TRUE] ) {
				if(serviceContractMap.get(serviceObject.AccountId) != null) {
					List < ServiceContract >  contractList = serviceContractMap.get(serviceObject.AccountId);
					contractList.add(serviceObject);
					serviceContractMap.put(serviceObject.AccountId, contractList);   
				} else {
					serviceContractMap.put(serviceObject.AccountId, new list <ServiceContract> {serviceObject});   
				}
			}		
			
			List < Account > updateAccountList = new List < Account > (); 
			for (Account accountObj : accountList) {	
				Boolean isUpdate = false;
				if(serviceContractMap.get(accountObj.Id) != null) {
					//Check status of service contract 
					for (ServiceContract serviceObj : serviceContractMap.get(accountObj.Id)) {
						if(serviceObj.Status == 'Active') {
							isUpdate = true;
							break;
						}				  
					} 
				}
				//Check status Active and Care Contract is False make True
				if(isUpdate && accountObj.CH_CareContract__c == false) {
					accountObj.CH_CareContract__c = true;
					updateAccountList.add(accountObj);
				} 
				//Check status Inactive and Care Contract is True make False
				else if(!isUpdate && accountObj.CH_CareContract__c == true) {
					accountObj.CH_CareContract__c = false;
					updateAccountList.add(accountObj);
				}				   
			} 
			
			Database.SaveResult[] srList = Database.update(updateAccountList, false); 
			// Iterate through each returned result
			for (Integer i = 0; i < updateAccountList.size(); i++) {
				Database.SaveResult sr = srList[i];
				if (!sr.isSuccess()) {
					// Operation failed, so get all errors				
					for(Database.Error err : sr.getErrors()) {
						System.debug('### Account Info ###' + updateAccountList[i].id + '****Care Contract value*****' + updateAccountList[i].CH_CareContract__c);
					}
				}
			} 
		}
	}
	
	/********************
	* Method Name: updateAccountField
	* Parameter: 
	* Description: Used to update CH_CareContract__c field on Account
	* Reference: NOKIASC-13997
	*******************/
	global void execute(SchedulableContext sc)
	{
		// Implement any logic to be scheduled
		
		// We now call the batch class to be scheduled
		CH_UpdateFlagOnAccountBatch b = new CH_UpdateFlagOnAccountBatch ();
		
		//Parameters of ExecuteBatch(context,BatchSize)
		database.executebatch(b,2000);
	}
}