global without sharing class CH_TemporaryBatchJob implements Database.Batchable<SObject> {
	global CH_TemporaryBatchJob() { /* Do Nothing */ }
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		String query = 'SELECT Id, CH_NetworkElementAsset__c, CH_Site__c, CH_LegacyCaseNumber__c, CaseNumber FROM Case WHERE ';
		query += 'CH_LegacyCaseNumber__c != null AND CH_LegacyCaseNumber__c like \'1-%\' AND CH_Site__c NOT IN (null, \'No Selection\')';
		return DML_SObject.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		List<String> results = new List<String>();		
		//Get Legacy Cases and respective Sites
		List<Case> oCaseList = (List<Case>)scope;
		Set<String> sSites = new Set<String>();
		for(Case oCase : oCaseList) {
			sSites.add(oCase.CH_Site__c);
		}
		//Get Assets based on Site
		Map<String, Asset> oNameToAssetMap = new Map<String, Asset>();
		for(Asset oAsset : [SELECT Id, Name FROM Asset WHERE Name IN :sSites AND RecordType.DeveloperName = 'CH_NetworkElementAsset']) {
			oNameToAssetMap.put(oAsset.Name, oAsset);
		}
		//Update Cases
		Map<Id, Asset> oCaseToAssetMap = new Map<Id, Asset>();
		List<Case> oCaseUpdateList = new List<Case>();
		for(Case oCase : oCaseList) {
			if(oNameToAssetMap.containsKey(oCase.CH_Site__c)) {
				Asset oAsset = oNameToAssetMap.get(oCase.CH_Site__c);
				oCase.CH_NetworkElementAsset__c = oAsset.Id;
				oCase.CH_Site__c = null;
				oCaseUpdateList.add(oCase);
				oCaseToAssetMap.put(oCase.Id, oAsset);
			}
			else results.add('Failed,' + oCase.CaseNumber + ',' + oCase.CH_LegacyCaseNumber__c + ',' + oCase.CH_Site__c + ',' + 'Error: No Network Element Asset "' + oCase.CH_Site__c + '" found.');
		}
		Database.SaveResult[] updateResult = Database.update(oCaseUpdateList, false);
		Integer updateResultSize = updateResult.size();
		for(Integer i = 0; i < updateResultSize; i++) {
			Case oCase = oCaseUpdateList.get(i);
			Asset oAsset = oCaseToAssetMap.get(oCase.Id);
			if (updateResult[i].isSuccess()) {
				results.add('Success,' + oCase.CaseNumber + ',' + oCase.CH_LegacyCaseNumber__c + ',' + oAsset.Name + ',' + oAsset.Id);
			}
			else {
				results.add('Failed,' + oCase.CaseNumber + ',' + oCase.CH_LegacyCaseNumber__c + ',' + oAsset.Name + ',' + 'Error:' + updateResult[i].getErrors()[0].getMessage());
			}  
		}
		//Output to export to file
		String title = 'FixNEAOutput';
		List<ContentVersion> oContentVersionList = [SELECT Id, VersionData FROM ContentVersion WHERE OwnerId =:UserInfo.getUserId() AND Title =: title LIMIT 1];
		if(!oContentVersionList.isEmpty()) {
			ContentVersion oContentVersion = oContentVersionList.get(0);
			String data = oContentVersion.VersionData.toString();
			for(String output : results) { data += output + ' \n'; }
			oContentVersion.VersionData = Blob.valueOf(data);
			update oContentVersion;
		} else {
			String data = 'Result,Case Number,Legacy Case Number,Asset Name/Site,Asset Id/Error Info \n';
			for(String output : results) { data += output + ' \n'; }
			ContentVersion oContentVersion = new ContentVersion(
				Title = title,
				PathOnClient = title+'.csv',
				VersionData = Blob.valueOf(data),
				IsMajorVersion = false
			);
			insert oContentVersion;
		}
	}
	
	global void finish(Database.BatchableContext BC) { /* Do Nothing */ }
}