global class SearchAndAddEndCustomer implements Database.Batchable<sObject>,Database.Stateful{
	
	global List<Database.SaveResult> srList = new List<Database.SaveResult>();
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		Id leRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Indirect Sales Opportunity').getRecordTypeId();
		system.debug(leRecordTypeId+'===========');
		return Database.getQueryLocator('select Id,End_Customer__c,End_Customer_LE__c,End_Customer_LE__r.parentId from opportunity where End_Customer_LE__r.parentId<>NULL and End_Customer__c=NULL and End_Customer_LE__c<>NULL and End_Customer_LE__r.lastmodifieddate=TODAY and recordtypeId=:leRecordTypeId');
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope){
		system.debug('scope size......'+scope.size());
		for(sobject s : scope){
			Opportunity opp = (Opportunity)s;
			system.debug('End_Customer_LE__r.parentId..........'+opp.End_Customer_LE__r.parentId);
			s.put('End_Customer__c',opp.End_Customer_LE__r.parentId); 
		}
		GlobalConstants.isSearchAndAddEndCustomer = true;
		srList.addAll(Database.update(scope,false));
	}
	
	global void finish(Database.BatchableContext BC){
		System.debug('SrList.......'+srList.size());
		List<Interface_Log__c> logList = new List<Interface_Log__c>();
		for(Database.SaveResult sr : SrList){
			Interface_Log__c interfaceLog = New Interface_Log__c();
			interfaceLog.Name = 'Opportunity End Customer Update '+sr.getId();
			/***************************************************************/
			interfaceLog.Message_Type__c = GlobalConstants.INBOUND;
			if(sr.isSuccess()){
				interfaceLog.Status__c = GlobalConstants.SUCCESS;
				interfaceLog.Comment__c = 'Successfully Updated';
			}else{
				interfaceLog.Status__c = GlobalConstants.FAILURE;
				for(Database.Error err : sr.getErrors()) {
					interfaceLog.Comment__c = interfaceLog.Comment__c +'	'+err.getStatusCode() + ': ' + err.getMessage();
				}
			}
			interfaceLog.Operation_type__c = GlobalConstants.UPDATE_VALUE; 
			interfaceLog.Interface_Type__c = 'Opportunity End Customer Update';
			interfaceLog.Message_Type__c = GlobalConstants.INBOUND;
			loglist.add(interfaceLog);
		}  
		insert logList;	
	}
}