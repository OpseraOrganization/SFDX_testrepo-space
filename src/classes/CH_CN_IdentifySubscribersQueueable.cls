/****************************************
* Class Name : CH_CN_IdentifySubscribersQueueable
* Created Date: 16 Jul 2020
* Created By : TCS
* Last Modified by: TCS
* Description : To perform asynchronous calls from CH_CaseTriggerHandler for Subscription Notifications
* US : NOKIASC-29170
*****************************************/
public class CH_CN_IdentifySubscribersQueueable implements Queueable, Database.AllowsCallouts{	
	List<Case> newCaseList = new List<Case>();
	Set<Id> caseIdSet = new Set<Id>();
	Map<Id,Case> oldCaseMap = new Map<Id,Case>();
	Boolean isCreation = false; 
	Boolean isFromBatch = false;
	Boolean isFromDistributeUpdate = false; 
	Map<Id,Integer> caseTXMap = new Map<Id,Integer>();
	String jobId = '';
	public CH_CN_IdentifySubscribersQueueable(Set<Id> caseIdSet, Map<Id,Case> oldCaseMap, Boolean isCreation, Boolean isFromBatch, Boolean isFromDistributeUpdate, Map<Id,Integer> caseTXMap){
		this.caseIdSet = caseIdSet;   
		//Add Query on Case for new case list.
		String query = Label.CH_CN_SubscriptionNotification;
		query = query + ' AND Id IN :caseIdSet';
		try{
			newCaseList = Database.query(query);
		}
		catch(QueryException qe){			
			ErrorLog__c err = CH_ErrorLogUtils.createErrorLog(qe.getTypeName()+' '+qe.getMessage()+' Line number: ' + qe.getLineNumber()+' Stack trace: ' + qe.getStackTraceString()+' Case Id: '+caseIdSet,'CH_CN_IdentifySubscribersQueueable','NOTIFICATION-QUEUEABLE', 'CH_Notification_Identify_Subscribers', new list<Id>(caseIdSet)[0]);
			CH_ErrorLogUtils.insertErrorLog(new List<ErrorLog__c>{err});
		}
		this.oldCaseMap = oldCaseMap;
		this.isCreation = isCreation;
		this.isFromBatch = isFromBatch;
		this.isFromDistributeUpdate = isFromDistributeUpdate;
		this.caseTXMap = caseTXMap;
		this.jobId = generateJobId();
	}
	public void execute(QueueableContext context){	
		Map<Case, Map<String, List<CH_NotificationSubscription__c>>> casEvtNSMap = new Map<Case, Map<String, List<CH_NotificationSubscription__c>>>();
		try{
			if(newCaseList.size()>0){
	casEvtNSMap = CH_CN_IdentifySubscribers.identifySubscribersWithEvents(newCaseList, oldCaseMap, isCreation, isFromBatch, isFromDistributeUpdate, caseTXMap, jobId);
			}
		}
		catch(Exception e){
			system.debug('Error Occured '+e.getMessage());
			ErrorLog__c err = CH_ErrorLogUtils.createErrorLog(e.getTypeName()+' '+e.getMessage()+' Line number: ' + e.getLineNumber()+' Stack trace: ' + e.getStackTraceString()+' Case Id: '+caseIdSet,'CH_CN_IdentifySubscribersQueueable','NOTIFICATION-QUEUEABLE', 'CH_Notification_Identify_Subscribers', new list<Id>(caseIdSet)[0]);
			CH_ErrorLogUtils.insertErrorLog(new List<ErrorLog__c>{err});
		}
	}
	
	public String generateJobId(){
		String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
		Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
		String hexDigest = EncodingUtil.convertToHex(hash);
		return hexDigest;
	}
}