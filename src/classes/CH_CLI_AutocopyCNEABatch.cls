/****************************************
* Class Name : CH_CLI_AutocopyCNEABatch
* Created Date: 23 March 2020
* Created By : lokanadha.reddy.ext@nokia.com
* Last Modified by: lokanadha.reddy.ext@nokia.com
* Last Modified Date: 23 March 2020
* Description : This batch class is used to update Covered network element Asset records when Previous CDB on Contract line item is equal to CDB Entitlement id of previous records of CLI.
* Reference: NOKIASC-27536
* Test Class: CH_CLI_AutocopyCNEABatch_Test
*****************************************/
global class CH_CLI_AutocopyCNEABatch implements Database.Batchable <sObject>, Database.Stateful, schedulable {
	//static variable initialization
	public Map<string, Id> NewCliMap1 = new Map<string, Id>();
	public Map<string, Id> oldNewCliMap2 = new Map<string, Id>();
	Set<String> previousCDBEntId = new Set<String>();
	global List<Interface_Log__c> logs = new List<Interface_Log__c>();
	global Database.QueryLocator start(Database.BatchableContext BC){
		List<ContractLineItem> CLIList = [SELECT Id,CH_PreviousCDBEntitlementId__c, CH_QtyCoveredNetworkElementAssets__c FROM ContractLineItem WHERE CH_PreviousCDBEntitlementId__c != null and CH_isCNEACopyRequied__c = TRUE and CH_QtyCoveredNetworkElementAssets__c =0];
		for(ContractLineItem cliRec:CLIList){
			previousCDBEntId.add(cliRec.CH_PreviousCDBEntitlementId__c);
			//Map contains previousCDBEntitlement and CLI Id
			NewCliMap1.put(cliRec.CH_PreviousCDBEntitlementId__c,cliRec.Id);
		}
		List<ContractLineItem> CLIOldList = [SELECT Id,CH_CDB_EntitlementId__c FROM ContractLineItem 
											 WHERE CH_CDB_EntitlementId__c != null and CH_CDB_EntitlementId__c IN: previousCDBEntId ];
		
		for(ContractLineItem cliRec:CLIOldList){
			oldNewCliMap2.put(cliRec.Id,NewCliMap1.get(cliRec.CH_CDB_EntitlementId__c));
		}
		string query = 'Select Name,CH_NetworkElementAsset__c,CH_ContractLineItem__c,CH_Status__c  FROM CH_CoveredNetworkElementAsset__c WHERE CH_ContractLineItem__r.CH_CDB_EntitlementId__c IN: previousCDBEntId AND CH_Status__c =\'Active\'';
		return Database.getQueryLocator(query);
	}
	global void execute(Database.BatchableContext BC, List<CH_CoveredNetworkElementAsset__c> newCNEList){
		List<CH_CoveredNetworkElementAsset__c> finalCNEAToInsert = new List<CH_CoveredNetworkElementAsset__c>();
		for(CH_CoveredNetworkElementAsset__c CNEARec : newCNEList)
		{
			CH_CoveredNetworkElementAsset__c CNEAutoCopy = new CH_CoveredNetworkElementAsset__c();
			CNEAutoCopy.Name = CNEARec.Name;
			CNEAutoCopy.CH_Status__c = CNEARec.CH_Status__c;
			CNEAutoCopy.CH_NetworkElementAsset__c = CNEARec.CH_NetworkElementAsset__c;
			CNEAutoCopy.CH_ContractLineItem__c = oldNewCliMap2.get(CNEARec.CH_ContractLineItem__c);
			finalCNEAToInsert.add(CNEAutoCopy);
		}
		insert finalCNEAToInsert;
		// Database.SaveResult[] CNEAReslt = Database.Insert(finalCNEAToInsert,false);
		/*for(Database.SaveResult a : CNEAReslt){
if(!a.isSuccess()){
for(Database.Error err : a.getErrors()) {
logs.add(new Interface_Log__c(
Comment__c = err.getMessage(),
Interface_Type__c = 'Error Auto Copy NEA'
));
}
}
}*/
		
		Database.insert(logs,false);
	}
	global void finish(Database.BatchableContext BC){
		List<ContractLineItem> clisToUpdate = new List<ContractLineItem>();  
		List<ContractLineItem> CLIList = [SELECT Id,CH_isCNEACopyRequied__c, CH_QtyCoveredNetworkElementAssets__c FROM ContractLineItem WHERE id =: NewCliMap1.values() ];
		for(ContractLineItem CliUpdate : CLIList ){
			
			CliUpdate.CH_isCNEACopyRequied__c = false;
			clisToUpdate.add(CliUpdate);
			
		}
		update clisToUpdate;
	}
	global void execute(SchedulableContext SC){
		CH_CLI_AutocopyCNEABatch batch11 = new CH_CLI_AutocopyCNEABatch();
		Database.executeBatch(batch11,1000);
	} 
	
}