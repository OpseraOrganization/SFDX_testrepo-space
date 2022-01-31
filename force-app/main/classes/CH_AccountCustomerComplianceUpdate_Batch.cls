/****************************************
* Class Name : CH_AccountCustomerComplianceUpdate_Batch 
* Created Date: 27 April 2020
* Created By : Bharathi Nutakki - TCS
* Description : To Update customer compliance on Account
************/
global class CH_AccountCustomerComplianceUpdate_Batch implements Database.Batchable<sObject>,Schedulable{
	Id legalEntityAccountId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
	Id logisticAccountId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Logistic Account').getRecordTypeId();
	global List<Interface_Log__c> logs;
	CH_CustomerCompliance__c custComplCreatedDate = new CH_CustomerCompliance__c();  
	List<CH_CustomerCompliance__c> custComplList = new List<CH_CustomerCompliance__c>();
	global CH_AccountCustomerComplianceUpdate_Batch() {
		logs = new List<Interface_Log__c>();
		custComplCreatedDate =  CH_CustomerCompliance__c.getInstance('AccountLastModifiedDate');	 
	}
	global Database.QueryLocator start(Database.BatchableContext BC){
		String accList; 
		String custCompl = 'Customer_Compliance__c'; 
		Date createdDate;
		Date custComplUpdateDate = Date.valueOf(custComplCreatedDate.CH_StartDate__c);
		if(custComplUpdateDate != null){
			createdDate = custComplUpdateDate;
		}
		if(custComplUpdateDate == null && !custComplCreatedDate.CH_AccountFullShare__c){
			createdDate=Date.today().addDays(-1);	
		}		
		accList = 'SELECT Id,Parent.Customer_Compliance__c,Customer_Compliance__c,RecordType.DeveloperName,Parent.RecordType.DeveloperName,RecordTypeId,(SELECT Id,RecordType.DeveloperName,RecordTypeId,Parent.Parent.Customer_Compliance__c FROM ChildAccounts WHERE RecordTypeId = : logisticAccountId) FROM Account WHERE (RecordTypeId =: legalEntityAccountId OR RecordTypeId =: logisticAccountId)';
		if(createdDate != null){
			accList = accList + ' AND ParentId IN (SELECT AccountId FROM AccountHistory WHERE Field= :custCompl AND CreatedDate >= :createdDate)';
		}
		if(createdDate == null && custComplCreatedDate.CH_AccountFullShare__c){
			accList = accList + ' AND ParentId IN (SELECT AccountId FROM AccountHistory WHERE Field= :custCompl)';
		}
		System.debug('QUERY LIST:'+accList);		
		return Database.getQueryLocator(accList);
	}
	global void execute(Database.BatchableContext BC, List<Account> accList){		
		List<Account> updateAccList = new List<Account>();
		Map<Id,Account> updateAccMap = new Map<Id,Account>();
		if(!accList.isEmpty()){
			for(Account acc : accList){			
				System.debug('ACC REC TYPE:'+acc.RecordType.DeveloperName);
	if((acc.RecordType.DeveloperName == 'Legal_Entity' || acc.RecordTypeId == legalEntityAccountId) || (acc.ChildAccounts.isEmpty() && acc.RecordType.DeveloperName == 'Logistic_Account')){
					acc.CH_LE_Customer_Compliance__c = '';
					acc.Customer_Compliance__c = acc.Parent.Customer_Compliance__c;	
				}		
				if(!acc.ChildAccounts.isEmpty()){
					for(Account ca : acc.ChildAccounts){
						if(ca.RecordType.DeveloperName == 'Logistic_Account' || ca.RecordTypeId == logisticAccountId){
							ca.CH_LE_Customer_Compliance__c = '';
							ca.Customer_Compliance__c = ca.Parent.Parent.Customer_Compliance__c;		
						}
						updateAccList.add(ca);
					}	  
				}
				updateAccList.add(acc);
				updateAccMap.putAll(updateAccList);				 
				//accToUpdateMap.putAll(accToUpdate);
			}
		}
		System.debug('PARENT accToUpdate:'+updateAccMap);
		if(updateAccMap.size()>0){ 
			Database.SaveResult[] parentUpdateList = Database.update(updateAccMap.values(),false);
			for(Database.SaveResult a : parentUpdateList){
				if(!a.isSuccess()){
					for(Database.Error err : a.getErrors()) {
						logs.add(new Interface_Log__c(
							Comment__c = err.getMessage(),
							Interface_Type__c = 'Legal Account Customer Compliance Sharing Error'
						));
					}
				}			
			}
		}		
		Database.insert(logs,false);
	}
	global void finish(Database.BatchableContext BC){
		//DateTime startDate = System.now();
		custComplCreatedDate.CH_StartDate__c = null;
		custComplCreatedDate.CH_AccountFullShare__c = FALSE;
		custComplList.add(custComplCreatedDate);
		Database.update(custComplList,false);	
	}   
	global void execute(SchedulableContext SC)	  
	{
		CH_AccountCustomerComplianceUpdate_Batch  batch = new CH_AccountCustomerComplianceUpdate_Batch();
		Database.executebatch(batch,200);			
	}  
	
}