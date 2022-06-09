/****************************************
* Class Name : CH_CN_SubscriptionForChunksBatch
* Created Date: 13 Oct 2020
* Created By : TCS (Satya Pagadala)
* Last Modified by: TCS (Satya Pagadala)
* Description : To Identify Subscribers for Subscription Notifications and for chaining
* US : NOKIASC-31978
*****************************************/
global class CH_CN_SubscriptionForChunksBatch implements Database.Batchable<sObject>,Database.Stateful{
	String query='';
	String loopQuery='';
	String all ='ALL';
	List<Case> newCaseList = new List<Case>();
	Map<Id,Case> oldCaseMap= new Map<Id,Case>();
	Boolean isCreation = false; 
	Boolean isFromBatch = false;
	Boolean isFromDistributeUpdate = false; 
	Map<Id,Set<String>> caseIdEvtTypStrMap = new Map<Id,Set<String>>();
	Set<Id> childAttributeIdset = new Set<Id> ();
	Set<String> childAttributeIdset2=new Set<String> ();
	Set<String> securityGrpSet = new Set<String>();
	String jobId ='';
	global CH_CN_SubscriptionForChunksBatch(String query,List<Case> newCaseList, Map<Id,Case> oldCaseMap, Boolean isCreation, Boolean isFromBatch, Boolean isFromDistributeUpdate,Map<Id,Set<String>> caseIdEvtTypStrMap, String loopQuery,Set<Id> childAttributeIdset,Set<String> childAttributeIdset2, Set<String> securityGrpSet, String jobId){ 
		this.query = query;
		this.loopQuery = loopQuery;
		this.newCaseList = newCaseList;
		this.oldCaseMap = oldCaseMap;
		this.isCreation = isCreation;
		this.isFromBatch = isFromBatch;
		this.isFromDistributeUpdate = isFromDistributeUpdate;
		this.caseIdEvtTypStrMap = caseIdEvtTypStrMap;
		this.childAttributeIdset = childAttributeIdset;
		this.childAttributeIdset2 =childAttributeIdset2;
		this.securityGrpSet = securityGrpSet;
		this.jobId = jobId;
	}
	global Database.QueryLocator start(Database.BatchableContext bc){
		//get CH_NotificationSubscription__c reordtype Ids
		Id excDomainRecordTypeId = Schema.SObjectType.CH_NotificationSubscription__c.getRecordTypeInfosByDeveloperName().get('CH_Executive_Domain').getRecordTypeId();
		Id wgRecordTypeId = Schema.SObjectType.CH_NotificationSubscription__c.getRecordTypeInfosByDeveloperName().get('CH_Workgroup_Domain').getRecordTypeId();
		
		return Database.getQueryLocator(query);
	} 
	// The batch job executes and operates on one batch of records
	global void execute(Database.BatchableContext bc, List<sObject> scope){ 
		
		Map<Case, Map<String, List<CH_NotificationSubscription__c>>> casEvtNSMap = new Map<Case, Map<String, List<CH_NotificationSubscription__c>>>();
		casEvtNSMap  = CH_CN_IdentifySubscribers.identifySubscribers(scope, loopQuery+' AND Id IN :scope order by OwnerId', newCaseList, oldCaseMap, isCreation, isFromBatch, isFromDistributeUpdate, casEvtNSMap, caseIdEvtTypStrMap, childAttributeIdset,childAttributeIdset2, securityGrpSet);
		CH_NotificationEventLog__c notEvtLog = new CH_NotificationEventLog__c(CH_ClassName__c='CH_CN_SubscriptionForChunksBatch',CH_MethodName__c='execute');
		if(casEvtNSMap.size()>0){
			notEvtLog.CH_NumberOfCases__c=casEvtNSMap.keySet().size();
			integer totalSubs = 0;
			Set<Id> caseIdSet = new Set<Id>();
			Set<String> evtTypeSet = new Set<String>();
			for(case c: casEvtNSMap.keySet()){
	caseIdSet.add(c.Id);
	notEvtLog.CH_CaseNumber__c = c.CaseNumber;
	notEvtLog.CH_Country__c=c.Country__c;
	notEvtLog.CH_Workgroup__c=c.CH_Workgroup__c;
	
	Map<String, List<CH_NotificationSubscription__c>> evtMap= casEvtNSMap.get(c);   
	for(String eventtype: evtMap.KeySet()){
		evtTypeSet.add(eventtype);
		totalSubs +=evtMap.get(eventtype).size();
		
	}}
			notEvtLog.CH_EventType__c=string.join(new List<String>(evtTypeSet),';');
			notEvtLog.CH_NumberOfSubscribers__c=totalSubs;
			CH_CNNotificationLimits__c notificationLimit = CH_CNNotificationLimits__c.getValues('Subscription Record Count');
			if(totalSubs>Integer.valueOf(notificationLimit.CH_NotificationLimitValue__c)){
	System.enqueueJob(new CH_CN_NotificationSubContentQueueable(casEvtNSMap,caseIdSet, jobId));	 
			}
			else{
	CH_CN_NotificationSubscriptionContent.Contentselection(casEvtNSMap,jobId);
	
			}
		}
		notEvtLog.CH_CPUTime__c=Limits.getCpuTime();
		notEvtLog.CH_HeapSize__c=Limits.getHeapSize();
		notEvtLog.CH_RelatedJobId__c=jobId;
		CH_CN_IdentifySubscribers.createNotificationLogs(new List<CH_NotificationEventLog__c>{notEvtLog});		
	}
	// The batch job finishes
	global void finish(Database.BatchableContext bc){ }
}