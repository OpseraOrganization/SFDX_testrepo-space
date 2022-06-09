public class InterfaceLogHelper {
	public static void CheckIsOpptySync(List<Interface_Log__c> iLogs){
		List<String> opptyNameList= new List<String>();
		for(Interface_Log__c iLog:iLogs){
			if(iLog.Interface_Type__c=='fALU Oppty Sync' && iLog.Operation_Type__c=='Insert' && iLog.Status__c=='Success' && iLog.Interface_Request_Sent__c.contains('Is_Opportunity_Sync__c: 1') ){			
	String str=iLog.Name.split('#')[1];
			 opptyNameList.add(str.trim());
			}
		}
		if(opptyNameList.size()>0){
			List<Opportunity> opptyUpdateList =new List<Opportunity>();
			try{
			List<Opportunity> oppList=[Select Id,Opportunity_ID__c,isOpportunitySync__c from Opportunity where Opportunity_ID__c in:opptyNameList];
				for(Opportunity oppty:oppList){
					if(oppty.isOpportunitySync__c == false){
						oppty.isOpportunitySync__c=true;
						opptyUpdateList.add(oppty);
					}
				}
				System.debug('====>'+oppList);
				Database.update(opptyUpdateList, false);
			}
			catch(Exception e){
				System.debug(e.getMessage());
			}

		}

			
	}

	public static void handleCDBBusinessHoursLogs(List<Interface_Log__c> logs) {
		List<Interface_Log__c> successCDBLogs = new List<Interface_Log__c>();
		for (Interface_Log__c log : logs) {
			if (log.Interface_Type__c == 'Business Hours' && log.Status__c == 'Success') {
				successCDBLogs.add(log);
			}
		}

		if (!successCDBLogs.isEmpty()) {
			CH_Business_Hours_Integration__c integrationSettings = CH_Business_Hours_Integration__c.getOrgDefaults();
			if (integrationSettings != NULL && integrationSettings.CH_Start_Sync_DateTime__c != NULL) {
				integrationSettings.CH_Last_Success_Sync_DateTime__c = integrationSettings.CH_Start_Sync_DateTime__c;
				integrationSettings.CH_Start_Sync_DateTime__c = NULL;
				update integrationSettings;
			}
		}
	}
}