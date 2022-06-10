/****************************************
* Class Name : CH_AssetCustomerComplianceUpdate_Batch 
* Created Date: 23 December 2019
* Created By : Bharathi Nutakki - TCS
* Description : To Update customer compliance on Asset
* Test Class: CH_AssetComplianceUpdate_Batch_Test
************/
global class CH_AssetCustomerComplianceUpdate_Batch implements Database.Batchable<sObject>,Schedulable{
	global List<Interface_Log__c> logs;
	CH_CustomerCompliance__c custComplCreatedDate = new CH_CustomerCompliance__c();  
	List<CH_CustomerCompliance__c> custComplList = new List<CH_CustomerCompliance__c>();
	global CH_AssetCustomerComplianceUpdate_Batch() {
		logs = new List<Interface_Log__c>();
		custComplCreatedDate =  CH_CustomerCompliance__c.getInstance('Date');	 
	}
	global Database.QueryLocator start(Database.BatchableContext BC){
		Id legalEntityAccountId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		String fieldName = 'Customer_Compliance__c';
		Date createdDate;
		String assetList;
		Date custComplUpdateDate = Date.valueOf(custComplCreatedDate.CH_StartDate__c);
		if(custComplUpdateDate != null){
			createdDate = custComplUpdateDate;
		}
		if(custComplUpdateDate == null && !custComplCreatedDate.CH_AccountFullShare__c){
			createdDate=Date.today().addDays(-1);				
		}
		assetList = 'SELECT Id, CH_AccountCustomerCompliance__c, Account.Customer_Compliance__c FROM Asset';			  
		if(createdDate != null){
			assetList = assetList +' WHERE AccountId IN (SELECT AccountId FROM AccountHistory WHERE Field= :fieldName AND CreatedDate >= :createdDate)';
		}
		if(createdDate == null && custComplCreatedDate.CH_AccountFullShare__c){
			assetList = assetList +' WHERE Account.RecordTypeId =: legalEntityAccountId AND Account.Customer_Compliance__c != null';
		}
		System.debug('ASSET QUERY####'+assetList);
		return Database.getQueryLocator(assetList);
	}
	
	global void execute(Database.BatchableContext BC, List<Asset> astList){
		List<Asset> astToUpdateList = new List<Asset>();		
		for(Asset ast : astList){
			ast.CH_AccountCustomerCompliance__c = ast.Account.Customer_Compliance__c;
			astToUpdateList.add(ast);
		}
		Database.SaveResult[] assetList = Database.update(astToUpdateList,false);
		for(Database.SaveResult a : assetList){
			if(!a.isSuccess()){
				for(Database.Error err : a.getErrors()) {
					logs.add(new Interface_Log__c(
						Comment__c = err.getMessage(),
						Interface_Type__c = 'Asset Customer Compliance Sharing Error'
					));
				}
			}			
		}
		Database.insert(logs,false);
		
	}
	
	global void finish(Database.BatchableContext BC){
		custComplCreatedDate.CH_StartDate__c = null;
		custComplCreatedDate.CH_AccountFullShare__c = FALSE;
		custComplList.add(custComplCreatedDate);
		Database.update(custComplList,false);		
	}
	
	global void execute(SchedulableContext SC)	  
	{
		CH_AssetCustomerComplianceUpdate_Batch  batch = new CH_AssetCustomerComplianceUpdate_Batch();
		Database.executebatch(batch,200);			
	} 
}