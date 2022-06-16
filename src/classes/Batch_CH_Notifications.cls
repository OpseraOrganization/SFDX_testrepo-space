/*************************************************************************************************
* Class Name : Batch_CH_Notifications
* Created Date: 20 September 2018
* Created By : TCS
* Description: Batch class for Case Notifications
* Last Modified by: 
* Last Modified Date: 
* Description : 
*************************************************************************************************/
global without sharing class Batch_CH_Notifications implements Database.Batchable<sObject>,Database.Stateful {
	Set<Id> roleIds = new Set<Id>();
	Id probalemRecordTypeId = Schema.SObjectType.case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
	Map<String, CH_ChatterGroup_AccountMarketMaping__c> chatterGrpVsAccMarketMap = null;
	Map<String,String> accMakertNameVschatterGrpMap = null;
	List<Case> caseListToUpdate = null;
	public String queryString= '';
	public String cronId = '';
	Map<Id,Integer> caseEventMap = new Map<Id,Integer>();
	
	global Batch_CH_Notifications(String query,String cronId){ 
		this.queryString=query;
		this.cronId = cronId;
	}
	/*************************************************************************************************
	*Method Name: start
	*Author: TCS
	*Parameter: Database.BatchableContext
	*Description: Used to run the query
	**************************************************************************************************/ 
	global Database.QueryLocator start(Database.BatchableContext BC) {
		Integer lastfewDays = Integer.valueOf(CH_Settings__c.getValues('NotificationBatchNumberLastNDays') != null ? CH_Settings__c.getValues('NotificationBatchNumberLastNDays').SettingValue__c :'0');
		Date last2Days = system.today().addDays(-lastfewDays);
		accMakertNameVschatterGrpMap = new Map<String,String>();
		chatterGrpVsAccMarketMap = CH_ChatterGroup_AccountMarketMaping__c.getAll();
		if(chatterGrpVsAccMarketMap != null && !chatterGrpVsAccMarketMap.isEmpty()){
			for(CollaborationGroup groupObj: [SELECT Id, Name
			FROM CollaborationGroup 
			WHERE Name 
			IN: chatterGrpVsAccMarketMap.keySet()]){
	CH_ChatterGroup_AccountMarketMaping__c chatterGroups = chatterGrpVsAccMarketMap.get(groupObj.Name);
	//PRB0018401
	if(chatterGroups.Account_Market_Name__c.contains(';')){
		List<String> regionLst = chatterGroups.Account_Market_Name__c.split(';');
		for(string region: regionLst){
			accMakertNameVschatterGrpMap.put(region,groupObj.Id);
		}
	}else{		 
		accMakertNameVschatterGrpMap.put(chatterGroups.Account_Market_Name__c,groupObj.Id);
	}
			}
		}
		return Database.getQueryLocator(queryString);
	}   
	/*************************************************************************************************
	*Method Name: execute
	*Author: TCS
	*Parameter: Database.BatchableContext,List<Case>
	*Description: Used to execute chatter Notification logic
	**************************************************************************************************/   
	global void execute(Database.BatchableContext BC, List<Case> caseList) {
		caseEventMap = new Map<Id,Integer>();
		caseListToUpdate = new List<Case>();
		if(accMakertNameVschatterGrpMap != null && !accMakertNameVschatterGrpMap.isEmpty()){
			for(Case caseObj : caseList){
	string isoMarket = CH_CA_Assignment_Criteria_DTO.getRegionByCountry(caseObj.Country__c);
	if(accMakertNameVschatterGrpMap.containsKey(isoMarket) && isoMarket != null )
	{ 
		postChatterMsg(accMakertNameVschatterGrpMap.get(isoMarket), caseObj);
	}
			}
		}
		// Calling the Second Batch Class for T-XX Notification Subscription
	Id jobId = System.enqueueJob(new CH_CN_IdentifySubscribersQueueable(new Set<Id>(caseEventMap.keySet()), null, false, true, false, caseEventMap));
		if(!caseListToUpdate.isEmpty())
		{   
			CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;
			Database.update(caseListToUpdate,false);
		}
		
	}
	/*************************************************************************************************
	*Method Name: finish
	*Author: TCS
	*Parameter: Database.BatchableContext
	*Description: Used to finish the execution 
	*************************************************************************************************/  
	global void finish(Database.BatchableContext BC) {
		// Delete the old scheduled batch jobs
		if(!String.isBlank(cronId)){
			CronTrigger[] cronTrigger = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name like 'Scheduler_CH_NotificationsDel%' LIMIT 5];
			if(cronTrigger != null && !cronTrigger.isEmpty()){
	for (CronTrigger schedule : cronTrigger){
		if(!Test.isRunningTest() && schedule.Id != cronId){System.abortJob(schedule.Id);}
	}
			}
		}
		Integer batchRunInterval = Integer.valueOf(CH_Settings__c.getValues('RunFreqInMinuteNotificationBatch') != null ? CH_Settings__c.getValues('RunFreqInMinuteNotificationBatch').SettingValue__c :'0');
		datetime currentDateTime = system.now().addMinutes(batchRunInterval);
		String day = string.valueOf(currentDateTime.day());
		String month = string.valueOf(currentDateTime.month());
		String hour = string.valueOf(currentDateTime.hour());
		String minute = string.valueOf(currentDateTime.minute());
		String second = string.valueOf(currentDateTime.second());
		String year = string.valueOf(currentDateTime.year());
		String strScheduleTime = second +CAPS_ConstantHandler.EMPTY_WHITESPACE+ minute + CAPS_ConstantHandler.EMPTY_WHITESPACE + hour + CAPS_ConstantHandler.EMPTY_WHITESPACE + day + CAPS_ConstantHandler.EMPTY_WHITESPACE + month + ' ?' + CAPS_ConstantHandler.EMPTY_WHITESPACE + year;
		String uniqustring = string.ValueOf(currentDateTime.getTime());
	  
		if(!Test.isRunningTest() && CAPS_ConstantHandler.YESSTRING.equalsignorecase(Label.CH_Notification_HaveSubseQuentSchedule)){System.schedule('Scheduler_CH_NotificationsDel'+strScheduleTime+ ''+uniqustring, strScheduleTime, new Scheduler_CH_Notifications());}
	}
	

	/*************************************************************************************************
	*Method Name: postChatterMsg
	*Author: TCS
	*Parameter: Id,Case
	*Description: Used to post the chatter Notification
	****************************************************************************************************/   
	public void postChatterMsg(Id groupId, Case caseObj){
		Integer count=0;
		
		ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
		ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
		ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
		ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
		messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
		mentionSegmentInput.id =  groupId;
		messageBodyInput.messageSegments.add(mentionSegmentInput);
		Integer minuteGaps = getelapsedminutes(caseObj.CH_MilestoneSLA_Start__c);
		if(minuteGaps >=15 && (string.isBlank(caseObj.CH_NotificationSent__c) || (!string.isBlank(caseObj.CH_NotificationSent__c) && !caseObj.CH_NotificationSent__c.contains('T1'))))
		{
			textSegmentInput.text = messageTextContent('T-15',caseObj,'T1');
			caseEventMap.put(caseObj.Id,15);
			
			count++;
		}
		else if(minuteGaps >=60 && (string.isBlank(caseObj.CH_NotificationSent__c) || (!string.isBlank(caseObj.CH_NotificationSent__c) && !caseObj.CH_NotificationSent__c.contains('T2'))))
		{
			textSegmentInput.text = messageTextContent('T-60',caseObj,'T2');
			caseEventMap.put(caseObj.Id,60);
	
			count++;
		}
	else if((minuteGaps >=180 && (string.isBlank(caseObj.CH_NotificationSent__c) || (!string.isBlank(caseObj.CH_NotificationSent__c) && !caseObj.CH_NotificationSent__c.contains('T3'))))|| Test.isRunningTest())
		{
		
			textSegmentInput.text = messageTextContent('T-180',caseObj,'T3');
			caseEventMap.put(caseObj.Id,180);
	 
			count++;
		}
		else if(minuteGaps >=360 && (string.isBlank(caseObj.CH_NotificationSent__c) || (!string.isBlank(caseObj.CH_NotificationSent__c) && !caseObj.CH_NotificationSent__c.contains('T4'))))
		{
			textSegmentInput.text = messageTextContent('T-360',caseObj,'T4');
			caseEventMap.put(caseObj.Id,360);
			
			count++;
		}
		else if(minuteGaps >=720 && (string.isBlank(caseObj.CH_NotificationSent__c) || (!string.isBlank(caseObj.CH_NotificationSent__c) && !caseObj.CH_NotificationSent__c.contains('T5'))))
		{
			textSegmentInput.text = messageTextContent('T-720',caseObj,'T5');
			caseEventMap.put(caseObj.Id,720);
	 
			count++;
		}
		else if(minuteGaps >=1080 && (string.isBlank(caseObj.CH_NotificationSent__c) || (!string.isBlank(caseObj.CH_NotificationSent__c) && !caseObj.CH_NotificationSent__c.contains('T6'))))
		{
			textSegmentInput.text = messageTextContent('T-1080',caseObj,'T6');
			caseEventMap.put(caseObj.Id,1080);
	 
			count++;
		}
		else if(minuteGaps >=1440 && (string.isBlank(caseObj.CH_NotificationSent__c) || (!string.isBlank(caseObj.CH_NotificationSent__c) && !caseObj.CH_NotificationSent__c.contains('T7'))))
		{
			textSegmentInput.text = messageTextContent('T-1440',caseObj,'T7');
			caseEventMap.put(caseObj.Id,1440);
	 
			count++;
		}
		if(count==1){
			messageBodyInput.messageSegments.add(textSegmentInput);	  
			feedItemInput.body = messageBodyInput;
			feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
			feedItemInput.subjectId = caseObj.id;	
			if(!test.isRunningTest()){ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);}
			count=0;
		}
	}
	/*************************************************************************************************
	*Method Name: messageTextContent
	*Author: TCS
	*Parameter: string,Case
	*Description: Used to build text for the chatter Notification
	*************************************************************************************************/
	public string messageTextContent(string txx, Case caseObj,string picklistValue){
		string caseRegion = CH_CA_Assignment_Criteria_DTO.getRegionByCountry(caseObj.Country__c);
		string textBody = '\n' + '\n' + 'This is a '+txx+' minutes follow up notification for the ' + caseObj.Severity__c + ' Case ' + caseObj.CaseNumber + ' for ' + caseObj.CH_AccountNameforNotifications__c + ', '
			+ caseObj.CH_Product_Name__c + ', ' +caseRegion+ ', ' + caseObj.Country__c + '\n' + '\n'
			+ 'Current Summary: ' + caseObj.Comment__c +'\n'	
			+ 'External Bridge Number: ' + caseObj.CH_ExternalBridge__c + '\n'
			+ 'Internal Bridge Number: ' + caseObj.CH_InternalBridge__c + '\n' + '\n' 
			+ 'Nokia Support Services' ;
		Case cse = new Case();
		cse.Id = caseObj.Id;
		if(!String.isBlank(caseObj.CH_NotificationSent__c))
		{
			cse.CH_NotificationSent__c = caseObj.CH_NotificationSent__c +';'+picklistValue;
		}else{cse.CH_NotificationSent__c = picklistValue;}
		caseListToUpdate.add(cse);
		return textBody;
	}
	/*************************************************************************************************
	*Method Name: getelapsedminutes
	*Author: TCS
	*Parameter: datetime
	*Description: Used to get elapsed minutes from Entitlement Notification Trigger Date
	****************************************************************************************************/  
	private integer getelapsedminutes(datetime milestoneSLAStarttime) {
		DateTime now = System.now();
		integer differenceInMinutes =0;
		differenceInMinutes = Integer.valueOf(((now.getTime() - milestoneSLAStarttime.getTime())/1000)/60);
		return differenceInMinutes;
	}
}