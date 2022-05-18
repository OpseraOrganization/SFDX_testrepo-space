/****************************************
* Class Name : CH_CN_IdentifySubscribers
* Created Date: 16 Jul 2020
* Created By : TCS (Satya Pagadala)
* Last Modified by: TCS (Satya Pagadala)
* Description : To Identify Subscriners for Subscription Notifications
* US : NOKIASC-29170
*****************************************/
public without sharing class CH_CN_IdentifySubscribers {
	/****************************************
* Class Name : CH_CN_IdentifySubscribersParentChild
* Created Date: 16 Jul 2020
* Created By : TCS (Satya Pagadala)
* Last Modified by: TCS (Satya Pagadala)
* Description : To Identify Subscriners for Subscription Notifications
* US : NOKIASC-29170
*****************************************/
	public static final String NOTIFICATION_QUEUEABLE='NOTIFICATION-QUEUEABLE';
	public static Set<Id> subscriptionOwnerIdSet = new Set<Id>();
	public static List<ErrorLog__c> ErrLst = new List<ErrorLog__c>();
	public static List<CH_NotificationEventLog__c> notifEvtLogLst = new List<CH_NotificationEventLog__c>();
	public static String all = 'ALL';
	public static String deft = 'Default';
	
	/****************************************
	* Name : identifySubscribersWithEvents
	* Description : returns Case Map with Map of EventType and list of subscription records
	* Parameters: List<Case> newCaseList, Map<Id,Case> oldCaseMap, Boolean isCreation, Boolean isFromBatch, Boolean isFromDistributeUpdate
	* Returns : Map of Map
	* written on 26th Jun 2020
	* By Satya Pagadala
	* NOKIASC-29170
	*****************************************/  
	public static Map<Case, Map<String, List<CH_NotificationSubscription__c>>> identifySubscribersWithEvents(List<Case> newCaseList, Map<Id,Case> oldCaseMap, Boolean isCreation, Boolean isFromBatch, Boolean isFromDistributeUpdate, Map<Id,Integer> caseTXMap, String jobId){
		Map<Case, Map<String, List<CH_NotificationSubscription__c>>> casEvtNSMap = new Map<Case, Map<String, List<CH_NotificationSubscription__c>>>();
		
		Map<Id,Set<String>> caseIdEvtTypStrMap = new Map<Id,Set<String>>();
		try{
			if(newCaseList.size()>0 !=null){
	Set<String> countryNameSet = new Set<String>();
	Set<String> bgSet = new Set<String>();
	Set<String> buSet = new Set<String>();
	Set<Id> childAttributeIdset = new Set<Id>();
	Set<String> childAttributeIdset2 = new Set<String>(); //NOKIASC-37902
	String bgStr = null;
	String buStr = null;
	String evtTypeStr = null;
	Set<String> evnTypeSetAll = new Set<String>();	
	Boolean isWGChanged = false;
	Set<String> securityGrpSet = new Set<String>();
	//for batch event notifications
	  for(Case c: newCaseList){
			Set<String> evnTypeSet = new Set<String>();	
			childAttributeIdset.add(c.AccountId);
			childAttributeIdset.add(c.ProductId);
			if(c.CH_GWC_SecurityGroup__c !=null){
	securityGrpSet.add(c.CH_GWC_SecurityGroup__c);
			}
			if(c.CH_SecurityGroup__c !=null){
	securityGrpSet.add(c.CH_SecurityGroup__c);
			}
			if(c.CH_3rdPartySecurityGroup__c !=null){
	securityGrpSet.add(c.CH_3rdPartySecurityGroup__c);
			}
			if(c.Country__c != null){
	countryNameSet.add(c.Country__c);
			}	 
			if(c.Account.ParentId !=null){
	childAttributeIdset.add(c.Account.ParentId);
			}
			if(c.CH_Rep_Product_Business_group__c !=null){			
	bgSet.add(c.CH_Rep_Product_Business_group__c);
			}
			if(c.CH_BusinessUnit__c !=null){	
	buSet.add(c.CH_BusinessUnit__c);
			}
			//get Event Types from Batch
			if(isFromBatch && caseTXMap.containsKey(c.Id)){	
	evnTypeSet.add('T'+caseTXMap.get(c.Id));
			}
			//get Event Types from 'Distribute Comment Update' button
			else if(isFromDistributeUpdate){
	evnTypeSet.add('Distribute Comment Update');
			}
			else{
	//get Event Types from Case Creation
	if(isCreation){
		if(c.Severity__c !=null && c.CH_Outage__c != null){
			evnTypeSet.add(c.Severity__c+'-'+c.CH_Outage__c);  
		}
	}
	//get Event Types from Case Updation
	else if(!isCreation && oldCaseMap !=null && oldCaseMap.containskey(c.Id)){
		if(c.CH_Outage__c != oldCaseMap.get(c.Id).CH_Outage__c && c.CH_Outage__c !=null){
			evnTypeSet.add('Outage Update');			
		}
		if(c.Severity__c != oldCaseMap.get(c.Id).Severity__c && (c.Severity__c =='Critical' || c.Severity__c =='Major')){
			evnTypeSet.add(c.Severity__c);	
		}
		if(c.Status != oldCaseMap.get(c.Id).Status && c.Status=='Restoration Provided'){
			evnTypeSet.add('Restored');		 
		}
		if(c.CH_Workgroup__c !=null && c.CH_Workgroup__c != oldCaseMap.get(c.Id).CH_Workgroup__c && (c.Severity__c =='Critical' || c.Severity__c =='Major' || c.Severity__c =='Minor' || c.Severity__c == SWS_Constants.IR)){
			if(c.Severity__c ==SWS_Constants.IR){
	evnTypeSet.add('CA-IR');
			}
			else{
	evnTypeSet.add('CA-'+c.Severity__c);
			}
			isWGChanged = true;
			childAttributeIdset.add(c.CH_Workgroup__c);
		} 
	}
			}
			evnTypeSetAll.addAll(evnTypeSet);
			caseIdEvtTypStrMap.put(c.id,evnTypeSet);
		}
	//prepare a string for BG from set
	if(bgSet.size()>0){
		for(String bg: bgSet){
			if(bgStr !=null){
	bgStr =  bgStr + ',\''+bg+'\'';
			}
			else{
	bgStr =  '\''+bg+'\'';
			}
		}
	}
	//prepare a string for BU from set
	if(buSet.size()>0){
		for(String bu: buSet){
			if(buStr !=null){
	buStr =  buStr + ',\''+bu+'\'';
			}
			else{
	buStr =  '\''+bu+'\'';
			}
		}
	}
	//prepare a string for Event type from set
	if(evnTypeSetAll.size()>0){
		for(String evt: evnTypeSetAll){
			if(evtTypeStr !=null){
	evtTypeStr =  evtTypeStr + ',\''+evt+'\'';
			}
			else{
	evtTypeStr =  '\''+evt+'\'';
			}
		}
	}
	String regionStr = null;
	//Added for NOKIASC-37902 removing ISO Countrycode with WorkgroupRule
	Map<String,CH_CN_SubscriptionsController.regionCountryWrapper> gw=CH_CN_SubscriptionsController.getcountriesFromWGRule();
	if(countryNameSet.size()>0){
		for(String cou:gw.keySet()){
				if(countryNameSet.contains(cou)){
	childAttributeIdset2.add(gw.get(cou).Name);	
	if(regionStr !=null){
		regionStr =  regionStr + ',\''+gw.get(cou).Market_c+'\'';
	}
	else{
		regionStr =  '\''+gw.get(cou).Market_c+'\'';
	}
			}
		}   
	}
	if(evtTypeStr !=null && regionStr !=null && bgStr !=null && buStr !=null){

		//get CH_NotificationSubscription__c reordtype Ids
		Id excDomainRecordTypeId = Schema.SObjectType.CH_NotificationSubscription__c.getRecordTypeInfosByDeveloperName().get('CH_Executive_Domain').getRecordTypeId();
		Id wgRecordTypeId = Schema.SObjectType.CH_NotificationSubscription__c.getRecordTypeInfosByDeveloperName().get('CH_Workgroup_Domain').getRecordTypeId();
		
		ErrorLog__c err3 = CH_ErrorLogUtils.createErrorLog('SubClass ISE Before Count Query - '+' CPU Time - '+Limits.getCpuTime() + ' HeapSize - '+Limits.getHeapSize(),'CH_CN_IdentifySubscribers',CH_CN_IdentifySubscribers.NOTIFICATION_QUEUEABLE, 'identifySubscribersWithEvents',  '');
		ErrLst.add(Err3);		
		
		String whereStr = ' AND (OwnerId IN (SELECT UserOrGroupId FROM GroupMember where Group.Name IN :securityGrpSet)) and (CH_Region__c =:all or CH_Region__c includes ('+regionStr+')) AND (CH_Product__c =null OR (CH_Product__c=:all and (CH_BusinessGroup__c=:all or CH_BusinessGroup__c includes ('+bgStr+')) and (CH_BusinessUnit__c=:all or CH_BusinessUnit__c includes ('+buStr+')))) AND (CH_EventType__c =:all OR CH_EventType__c includes ('+evtTypeStr+'))';
		String childCheck1 = ' AND (Id IN (select CH_NotificationSubscription__c from CH_NotificationSubscriptionDetail__c where CH_AttributeRecordID__c IN :childAttributeIdset OR CH_AttributeRecordID__c IN :childAttributeIdset2  OR CH_AttributeType__c=\'Default\'))';
		
		//query only for creation with executive recordtype Id
		if(!isWGChanged && !isFromBatch){	
			whereStr = whereStr + ' AND RecordTypeId =:excDomainRecordTypeId';
		}
		if(isWGChanged && newCaseList.size()==1){	
			whereStr = whereStr + ' AND RecordTypeId =:wgRecordTypeId';
		}
		if(!test.IsRunningTest()){whereStr = whereStr + ' AND Owner.IsActive = true';}
	
		String nsQueryStr = 'Select Id, name, RecordTypeId,  RecordType.Name, CH_Workgroup__c, CH_Region__c, CH_Country__c, CH_LegalEntityAccount__c, CH_ParentAccount__c, CH_DomainType__c, CH_EventType__c, CH_NotificationMode__c, CH_BusinessGroup__c, CH_BusinessUnit__c, CH_Product__c, OwnerId, Owner.Name, (select Id, CH_NotificationSubscription__c, CH_NotificationSubscription__r.Name, CH_AttributeCode__c, CH_AttributeName__c, CH_AttributeRecordID__c, CH_AttributeType__c from Notification_Subscription_Details__r where CH_AttributeRecordID__c IN :childAttributeIdset OR CH_AttributeRecordID__c IN :childAttributeIdset2 OR CH_AttributeType__c=\'Default\') from CH_NotificationSubscription__c where Id !=null'+whereStr;
		//Logic --> how to execute
			String batchQuery = 'Select Id from CH_NotificationSubscription__c where Id !=null'+whereStr+childCheck1+' order by OwnerId';			
			Database.executeBatch(new CH_CN_SubscriptionForChunksBatch(batchQuery, newCaseList, oldCaseMap, isCreation, isFromBatch, isFromDistributeUpdate, caseIdEvtTypStrMap, nsQueryStr, childAttributeIdset,childAttributeIdset2 ,securityGrpSet, jobId),2000);

	}
			}			
			
		}
		catch(Exception e){
			
			String methodRunType = (isFromBatch)?'NOTIFICATION-BATCH':CH_CN_IdentifySubscribers.NOTIFICATION_QUEUEABLE;
			ErrorLog__c errExcp = CH_ErrorLogUtils.createErrorLog(e.getTypeName()+' '+e.getMessage()+' Line number: ' + e.getLineNumber()+' Stack trace: ' + e.getStackTraceString(),'CH_CN_IdentifySubscribers-identifySubscribersWithEvents',methodRunType, 'CH_Notification_Identify_Subscribers', newCaseList[0].Id);
			ErrLst.add(errExcp);
			CH_ErrorLogUtils.insertErrorLog(ErrLst);
		}
		return casEvtNSMap;
	}
	
	
	/****************************************
* Name : evtTypeNSMapCheck
* Description : returns Map of EventType and list of subscription records
* Parameters: String evtStr, CH_NotificationSubscription__c ns, Map<String, List<CH_NotificationSubscription__c>> evtTypeNSMap
* Returns : Map
* written on 26th Jun 2020
* By Satya Pagadala
* NOKIASC-29170
* Note: this is subset method to avoid duplicate code
*****************************************/
	public static Map<String, List<CH_NotificationSubscription__c>> evtTypeNSMapCheck(String evtStr, CH_NotificationSubscription__c ns, Map<String, List<CH_NotificationSubscription__c>> evtTypeNSMap){
		if(ns.CH_EventType__c =='ALL' || ns.CH_EventType__c.contains(evtStr)){
			if(evtTypeNSMap.containskey(evtStr)){
	evtTypeNSMap.get(evtStr).add(ns);	 
			}
			else{
	evtTypeNSMap.put(evtStr, new List<CH_NotificationSubscription__c>{ns});	
			}
			subscriptionOwnerIdSet.add(ns.OwnerId);
		}	
		return evtTypeNSMap;
	}
	
  
	/****************************************
	* Name : identifySubscribersfromDistributCommentUpdate
	* Description : this method is triggered from Flow "CH_Status_Update_of_Critical_Service_Disruption_Not_Restored" while click 'Distribute Comment Update' button
	* Parameters: Case Id List
	* Returns : 
	* written on 26th Jun 2020
	* By Satya Pagadala
	* NOKIASC-29170
	*****************************************/
	@InvocableMethod
	public static void identifySubscribersfromDistributCommentUpdate(List<Id> caseIdLst){
		try{
			Id jobId = System.enqueueJob(new CH_CN_IdentifySubscribersQueueable(new Set<Id>(caseIdLst), null, false, false, true, null));
		}
		catch(Exception e){
			
			ErrorLog__c err = CH_ErrorLogUtils.createErrorLog(e.getTypeName()+' '+e.getMessage()+' Line number: ' + e.getLineNumber()+' Stack trace: ' + e.getStackTraceString(),'CH_CN_IdentifySubscribers-identifySubscribersfromDistributCommentUpdate',CH_CN_IdentifySubscribers.NOTIFICATION_QUEUEABLE, 'CH_Notification_Identify_Subscribers', caseIdLst[0]);
			CH_ErrorLogUtils.insertErrorLog(new List<ErrorLog__c>{err});
		}
	}
	
	/****************************************
	* Name : eliminateDuplicateSubs
	* Description : this method is remove duplicate Subscription records basd on Owner
	* Parameters: Map<Case, Map<String, List<CH_NotificationSubscription__c>>>
	* Returns : Map<Case, Map<String, List<CH_NotificationSubscription__c>>>
	* written on 26th Jun 2020
	* By Satya Pagadala
	* NOKIASC-29170
	*****************************************/
	public static Map<Case, Map<String, List<CH_NotificationSubscription__c>>> eliminateDuplicateSubs(Map<Case, Map<String, List<CH_NotificationSubscription__c>>> caseEvtSubMap ){	
		Map<Case, Map<String, List<CH_NotificationSubscription__c>>> uniqMapCaseEvtMap = new Map<Case, Map<String, List<CH_NotificationSubscription__c>>>();
		for(case c: caseEvtSubMap.keySet()){	
			if(caseEvtSubMap.containsKey(c)){
	Map<String, List<CH_NotificationSubscription__c>> evtMap= caseEvtSubMap.get(c); 
	Map<String, List<CH_NotificationSubscription__c>>   uniqEvtNSMap =  new Map<String, List<CH_NotificationSubscription__c>>();			
	for(String eventtype: evtMap.KeySet()){
		if(evtMap.containsKey(eventtype)){
			List<CH_NotificationSubscription__c> subscrptnlist = evtMap.get(eventtype);
			Map<Id, CH_NotificationSubscription__c> subModMap = new Map<Id, CH_NotificationSubscription__c>();
			for(CH_NotificationSubscription__c subscrptnobj : subscrptnlist){	  
	if(subModMap.containskey(subscrptnobj.OwnerId)){
		if(subscrptnobj.CH_NotificationMode__c=='Push Notification + Email'){
			subModMap.put(subscrptnobj.OwnerId, subscrptnobj);
		}
	}
	else{
		subModMap.put(subscrptnobj.OwnerId, subscrptnobj);
	}
			}
			uniqEvtNSMap.put(eventtype, subModMap.values());	
		}
	}
	uniqMapCaseEvtMap.put(c,uniqEvtNSMap);			
			}	
		}
		return uniqMapCaseEvtMap;
	}
	/****************************************
	* Name : checkSubscribersSecurity
	* Description : this method is is used to check user security group with case object
	* written on 4th Aug 2020
	* By Afif Reja
	* NOKIASC-29176
	*****************************************/
	public static Map<Case, Map<String, List<CH_NotificationSubscription__c>>> checkSubscribersSecurity(Map<Case, Map<String, List<CH_NotificationSubscription__c>>> mapCaseSubscriber,Set<Id> subscriptionUserIdSet, Set<String> securityGrpSet ){   
		//declare map for final data in  return method
		Map<Case, Map<String, List<CH_NotificationSubscription__c>>> mapReturnCaseSubscriber = new Map<Case, Map<String, List<CH_NotificationSubscription__c>>>();
		try{			
			//map to store all the user id wih public group
			Map<id, List<string>> userPublicgroups = new map<id, List<string>>();
			//for loop to get all the user id wih public group
			for(GroupMember gMember :[SELECT UserOrGroupId, group.Name FROM GroupMember WHERE UserOrGroupId IN :subscriptionUserIdSet and group.Name IN :securityGrpSet]){
	if(userPublicgroups.containsKey(gMember.UserOrGroupId)){
		userPublicgroups.get(gMember.UserOrGroupId).add(gMember.group.Name);
	}   
	else {
		userPublicgroups.put(gMember.UserOrGroupId, new List<String>{gMember.group.Name});
	}   
			}  
			//for loop to construct final map
			for(Case objCase: mapCaseSubscriber.keySet()){	  
	//get all value for perticular key
	Map<String, List<CH_NotificationSubscription__c>> mapNotification= mapCaseSubscriber.get(objCase);  
	//declare map for inner value 
	Map<String, List<CH_NotificationSubscription__c>> newMapNotification= new Map<String, List<CH_NotificationSubscription__c>>();
	//for loop to contruct value of final map
	for(String objNotification: mapNotification.KeySet()){	
		List<CH_NotificationSubscription__c> newSubscrptnlist = new List<CH_NotificationSubscription__c>();	
		//get all value for perticular key
		List<CH_NotificationSubscription__c> subscrptnList = mapNotification.get(objNotification);	
		for(CH_NotificationSubscription__c objSubscrptn : subscrptnList){ 
			//checking if user id is belong same security group as case
			if((userPublicgroups.containsKey(objSubscrptn.OwnerId)) && (userPublicgroups.get(objSubscrptn.OwnerId).contains(objCase.CH_GWC_SecurityGroup__c) || userPublicgroups.get(objSubscrptn.OwnerId).contains(objCase.CH_SecurityGroup__c) || userPublicgroups.get(objSubscrptn.OwnerId).contains(objCase.CH_3rdPartySecurityGroup__c))){		
	newSubscrptnlist.add(objSubscrptn);	
			}	
		}
		//construct value of final map
		if(!newSubscrptnlist.isempty() && newSubscrptnlist.size()>0)
			newMapNotification.put(objNotification, newSubscrptnlist);		 
	}
	// construct final map
	if(!newMapNotification.isempty() && newMapNotification.size()>0)
		mapReturnCaseSubscriber.put(objCase, newMapNotification);
	Integer remainingRows = Limits.getLimitQueryRows() - Limits.getQueryRows();
	system.debug(' Securityyyyyy Limits.getLimitQueryRows()  '+Limits.getLimitQueryRows()+' Limits.getQueryRows() '+Limits.getQueryRows()+' remainingRows '+remainingRows);
			}
		}
		catch(Exception e){
			
			ErrorLog__c err = CH_ErrorLogUtils.createErrorLog(e.getTypeName()+' '+e.getMessage()+' Line number: ' + e.getLineNumber()+' Stack trace: ' + e.getStackTraceString(),'CH_CN_IdentifySubscribers-checkSubscribersSecurity',CH_CN_IdentifySubscribers.NOTIFICATION_QUEUEABLE, 'CH_Notification_Identify_Subscribers', new List<Case>(mapCaseSubscriber.keySet())[0].Id);
			CH_ErrorLogUtils.insertErrorLog(new List<ErrorLog__c>{err});
		}	  
		return mapReturnCaseSubscriber;
	}
	/****************************************
	* Name : identifySubscribers
	* Description : returns Case Map with Map of EventType and list of subscription records
	* Parameters: List<Case> newCaseList, Map<Id,Case> oldCaseMap, Boolean isCreation, Boolean isFromBatch, Boolean isFromDistributeUpdate
	* Returns : Map of Map
	* written on 14th Oct 2020
	* By Satya Pagadala
	* NOKIASC-29170
	*****************************************/  
	public static Map<Case, Map<String, List<CH_NotificationSubscription__c>>> identifySubscribers(List<CH_NotificationSubscription__c> scope, String query, List<Case> newCaseList, Map<Id,Case> oldCaseMap, Boolean isCreation, Boolean isFromBatch, Boolean isFromDistributeUpdate, Map<Case, Map<String, List<CH_NotificationSubscription__c>>> casEvtNSMap, Map<Id,Set<String>> caseIdEvtTypStrMap, Set<Id> childAttributeIdset, Set<String> childAttributeIdset2, Set<String> securityGrpSet){
		
		Id excDomainRecordTypeId = Schema.SObjectType.CH_NotificationSubscription__c.getRecordTypeInfosByDeveloperName().get('CH_Executive_Domain').getRecordTypeId();
		Id wgRecordTypeId = Schema.SObjectType.CH_NotificationSubscription__c.getRecordTypeInfosByDeveloperName().get('CH_Workgroup_Domain').getRecordTypeId();
		Map<String,CH_CN_SubscriptionsController.regionCountryWrapper> gw=CH_CN_SubscriptionsController.getcountriesFromWGRule();
	
		
		for(CH_NotificationSubscription__c ns :Database.query(query)){
			CH_NotificationSubscription__c nsWithLessData = new CH_NotificationSubscription__c(Id=ns.Id, CH_EventType__c=ns.CH_EventType__c,OwnerId=ns.OwnerId, CH_NotificationMode__c=ns.CH_NotificationMode__c);
			for(Case c: newCaseList){
	Boolean isUpdateWG = false;	
	if(oldCaseMap !=null && oldCaseMap.containskey(c.Id) && c.CH_Workgroup__c !=null && c.CH_Workgroup__c != oldCaseMap.get(c.Id).CH_Workgroup__c && (c.Severity__c =='Critical' || c.Severity__c =='Major' || c.Severity__c =='Minor' || c.Severity__c ==SWS_Constants.IR)){
		isUpdateWG = true;
	}
	if((isUpdateWG && ns.RecordTypeId == wgRecordTypeId) || (!isUpdateWG && ns.RecordTypeId == excDomainRecordTypeId)){
		Map<String, List<CH_NotificationSubscription__c>> evtTypeNSMap = new Map<String, List<CH_NotificationSubscription__c>>();
		if(casEvtNSMap.containsKey(c)){	 
			evtTypeNSMap = casEvtNSMap.get(c);	
		}
		
		CH_CN_SubscriptionsController.regionCountryWrapper rc=gw.keySet().contains(c.Country__c)?gw.get(c.Country__c):null;
		if((ns.CH_Region__c =='ALL' || (rc !=null && ns.CH_Region__c.contains(rc.Market_c))) && (ns.CH_Product__c==null || (ns.CH_Product__c=='ALL' && (ns.CH_BusinessGroup__c=='ALL' || ns.CH_BusinessGroup__c.Contains(c.CH_Rep_Product_Business_group__c)) && (ns.CH_BusinessUnit__c=='ALL' || ns.CH_BusinessUnit__c.contains(c.CH_BusinessUnit__c))))){
			if(ns.Notification_Subscription_Details__r.size()>0){
	Boolean countryExists = false;
	Boolean accountExists = false;
	Boolean productExists = false;
	Boolean wrkgrpExists = false;
	for(CH_NotificationSubscriptionDetail__c nsd :ns.Notification_Subscription_Details__r){	 
		if(nsd.CH_AttributeType__c == 'Default'){
			for(string evtStr : caseIdEvtTypStrMap.get(c.id)){	  
	evtTypeNSMap = evtTypeNSMapCheck(evtStr, nsWithLessData, evtTypeNSMap);
			}	
		}
		else{
			if(nsd.CH_AttributeType__c == 'Country' && (c.Country__c != null && nsd.CH_AttributeName__c == c.Country__c)){
	countryExists = true;
			}
			if((nsd.CH_AttributeType__c == 'Legal Entity Account' && nsd.CH_AttributeRecordID__c == c.AccountId) || (nsd.CH_AttributeType__c == 'Parent Account' && nsd.CH_AttributeRecordID__c == c.Account.ParentId)){
	accountExists = true;
			}	 
			if(nsd.CH_AttributeType__c == 'Product' && nsd.CH_AttributeRecordID__c == c.ProductId){
	productExists = true;
			}
			if(!isCreation && ns.RecordTypeId == wgRecordTypeId && (nsd.CH_AttributeType__c == 'Workgroup' && nsd.CH_AttributeRecordID__c == c.CH_Workgroup__c)){
	wrkgrpExists = true;
			}
			
			if((ns.CH_Country__c=='ALL' || countryExists) && (ns.CH_LegalEntityAccount__c =='ALL' || accountExists) && (ns.CH_Product__c=='ALL' || productExists) && (ns.RecordTypeId == excDomainRecordTypeId || (!isCreation && ns.RecordTypeId == wgRecordTypeId && (ns.CH_Workgroup__c =='ALL' || (wrkgrpExists))))){	
	for(string evtStr : caseIdEvtTypStrMap.get(c.id)){	  
		evtTypeNSMap = evtTypeNSMapCheck(evtStr, nsWithLessData, evtTypeNSMap);	 
	}	
			}
		}
	}
			}		 
			if(!evtTypeNSMap.isEmpty()){
	casEvtNSMap.put(c, evtTypeNSMap);
			}
		}
	}
			}	
		}
		if(casEvtNSMap.size()>0){
			//Eliminte dupliocate Subscriptions per owner for each event type
			casEvtNSMap = eliminateDuplicateSubs(casEvtNSMap);
			if(newCaseList.size()>1){
	//Append Security Groups Checks
	casEvtNSMap = checkSubscribersSecurity(casEvtNSMap, subscriptionOwnerIdSet, securityGrpSet); 
			}
		}
		return casEvtNSMap;
	}
	/****************************************
	* Name : getISOCountryCodes
	* Description : returns ISO_Country_Codes__c Map with Map of Country Name and ISO_Country_Codes__c
	* Parameters: 
	* Returns : Map
	* written on 20th Nov 2020
	* By Satya Pagadala
	* NOKIASC-32546
	
	public static Map<String, ISO_Country_Codes__c> getISOCountryCodes(){	
		//preapre a region string from ISO_Country_Codes__c
		Map<String, ISO_Country_Codes__c> isoCountryCodesMap = new Map<String, ISO_Country_Codes__c>();
		for(ISO_Country_Codes__c iso:ISO_Country_Codes__c.getall().values()){
			isoCountryCodesMap.put(iso.Country_Name__c, iso);
		}
		return isoCountryCodesMap;
	}*****************************************/
	/****************************************
	* Name : createNotificationLogs
	* Description : Insert CH_NotificationEventLog__c records
	* Parameters: List<CH_NotificationEventLog__c>
	* Returns :
	* written on 26th Nov 2020
	* By Satya Pagadala
	* NOKIASC-32546
	*****************************************/
	public static void createNotificationLogs(List<CH_NotificationEventLog__c> notifEvtLogsLst){
		try{
			insert notifEvtLogsLst;
		}
		catch(Exception e){
			System.debug('Exception while creating Logs'+e);
		}
	}
}