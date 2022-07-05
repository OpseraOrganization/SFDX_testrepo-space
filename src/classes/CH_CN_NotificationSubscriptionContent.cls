/*******************************************************************************************************************
* Apex Class Name: CH_CN_NotificationSubscriptionContent
* This Class will recieve the case id,event type and list of subscriptions and process email and Push Notifications
* Developed By : TCS
* Developer Name: Satya Pagadala
* Test Class Name: Yet to build
* Last Modified (By&On): Satya Pagadala on 05.08.2020
*******************************************************************************************************************/
public without sharing class CH_CN_NotificationSubscriptionContent {
	public static final String NOTIFICATION_QUEUEABLE='NOTIFICATION-QUEUEABLE';
	/**************************************************************************************
	* Method Name: Contentselection
	* Parameter : Map<Case, Map<String, List<CH_NotificationSubscription__c>>>
	* This method will check the content selection-Email or Push Notification
	* ************************************************************************************/
	public static void Contentselection(Map<Case, Map<String, List<CH_NotificationSubscription__c>>> caseEvtSubMap, String jobId){
		List<Messaging.SingleEmailMessage> semailLst = new List<Messaging.SingleEmailMessage>();
		List<Map<String,Object>> flowParamsMapList = new List<Map<String,Object>>();
		String notificationTypeId = Label.CH_CustomNotificationID;
		List<CH_NotificationEventLog__c> notifEvtLogLst = new List<CH_NotificationEventLog__c>();
		CH_NotificationEventLog__c notEvtLog = new CH_NotificationEventLog__c(CH_ClassName__c='CH_CN_NotificationSubscriptionContent',CH_MethodName__c='Contentselection');
		
		try{
			notEvtLog.CH_NumberOfCases__c=caseEvtSubMap.keySet().size();
			integer totalSubs = 0;
			Set<String> evtTypeSet = new Set<String>();
			for(case c: caseEvtSubMap.keySet()){
	if(caseEvtSubMap.keySet().size()==1){
		notEvtLog.CH_CaseNumber__c = c.CaseNumber;
		notEvtLog.CH_Country__c=c.Country__c;
		notEvtLog.CH_Workgroup__c=c.CH_Workgroup__c;
	}
	
	if(caseEvtSubMap.containsKey(c)){
		Map<String, List<CH_NotificationSubscription__c>> evtMap= caseEvtSubMap.get(c);	
		for(String eventtype: evtMap.KeySet()){
			if(evtMap.containsKey(eventtype)){
				evtTypeSet.add(eventtype);
				Set<Id> ownerIdSet = new Set<Id>();
				List<Set<Id>> ownerIdSetLst = new List<Set<Id>>();
				integer notifyLimit500 = 500;
				integer forEach500Size = 0;
				Messaging.SingleEmailMessage semail = sendemailtosubscribers(c,eventtype);
				totalSubs +=evtMap.get(eventtype).size();
				for(CH_NotificationSubscription__c ns : evtMap.get(eventtype)){	
		if(ns.CH_NotificationMode__c=='Push Notification + Email'){
			Messaging.SingleEmailMessage semailEach = new Messaging.SingleEmailMessage();	 
			semailEach.setSubject(semail.getSubject());
			semailEach.setPlainTextBody(semail.getPlainTextBody());
			semailEach.setOrgWideEmailAddressId(Label.CH_FromEmailNS);
			semailEach.setSaveAsActivity(false);
			semailEach.setTargetObjectId(ns.OwnerId);
			semailLst.add(semailEach);
		}
		forEach500Size = forEach500Size+1;
		if(forEach500Size <=notifyLimit500){
			ownerIdSet.add(ns.OwnerId);   
		}
		else{
			ownerIdSetLst.add(ownerIdSet);
			notifyLimit500 = notifyLimit500+500;
			ownerIdSet =  new Set<Id>();
			ownerIdSet.add(ns.OwnerId);		
		}
				}	
				ownerIdSetLst.add(ownerIdSet);
				Map<String,String> titleBodyMap = prepareBodyForCustomNotification(c,eventtype);   
				Map<String,Object> commonParamMap = new map<String,Object>{'notificationTitle' => new List<String>(titleBodyMap.keySet())[0],'notificationBody' => titleBodyMap.values()[0],'notificationTargetId' => c.Id,'notificationTypeId' => notificationTypeId	};
		for(Set<Id> ownerIdSet500:ownerIdSetLst){
			Map<String,Object> paramMap = new map<String,Object>(commonParamMap);
			paramMap.put('notificationOwnerSetId',ownerIdSet500);
			flowParamsMapList.add(paramMap);	
		}
			}
		}
	}
	
			}
			notEvtLog.CH_EventType__c=string.join(new List<String>(evtTypeSet),';');			
			if(flowParamsMapList.size()>0){
	for(Map<String,Object> param: flowParamsMapList){
		Flow.Interview flow = new Flow.Interview.CH_NotificationFlow(param);	 
		flow.start();
	}
			}	
			notEvtLog.CH_NoOfSubscribersforEmail__c=semailLst.size();
			if(semailLst.size()>0){
	Messaging.sendEmail(semailLst);	
			}	
			notEvtLog.CH_NumberOfSubscribers__c=totalSubs;
			notEvtLog.CH_CPUTime__c=Limits.getCpuTime();
			notEvtLog.CH_HeapSize__c=Limits.getHeapSize();
			notEvtLog.CH_RelatedJobId__c=jobId;
			notifEvtLogLst.add(notEvtLog);
			CH_CN_IdentifySubscribers.createNotificationLogs(notifEvtLogLst);			
		}
		catch(Exception e){
			ErrorLog__c err = CH_ErrorLogUtils.createErrorLog(e.getTypeName()+' '+e.getMessage()+' Line number: ' + e.getLineNumber()+' Stack trace: ' + e.getStackTraceString(),'CH_CN_NotificationSubscriptionContent-Contentselection',NOTIFICATION_QUEUEABLE, 'CH_Notification_Identify_Subscribers', new List<Case>(caseEvtSubMap.keySet())[0].Id);
			CH_ErrorLogUtils.insertErrorLog(new List<ErrorLog__c>{err});
		}	
	}
	
	/**************************************************************************************
	* Method Name: sendemailtosubscribers
	* Parameter : Case caseobj,CH_NotificationSubscription__c subobj, String evtype
	* This method will send the email notification based on event type
	* Developed By: Gourisankar Patra
	* Last Modified( on & By): Gourisankar patra on 04.08.2020
	* ************************************************************************************/  
	public static Messaging.SingleEmailMessage sendEmailtoSubscribers(Case caseobj, String evtype){  
		Messaging.SingleEmailMessage semail = new Messaging.SingleEmailMessage();
		try{
			String emailsubject,emalplainbody,checkoutage;
			if(caseobj.CH_ExternalBridge__c == null){
	caseobj.CH_ExternalBridge__c='';
			}
			if(caseobj.CH_InternalBridge__c == null){
	caseobj.CH_InternalBridge__c='';
			}
			if(caseobj.Comment__c == null){
	caseobj.Comment__c='';
			}
			
			// EmailTemplate for Case Creation 
			if(caseobj.CH_Outage__c=='Yes'){
	checkoutage='with Outage';
			}
			else{
	checkoutage='without Outage';
			}
			string caseRegion = CH_CA_Assignment_Criteria_DTO.getRegionByCountry(caseObj.Country__c);
			String emailsubject1='SalesForce SWS : New '+caseobj.Severity__c+' Case '+checkoutage+', Customer: '+caseobj.account.name+', Product: '+caseobj.CH_Product_Name__c+', Case Number: '+caseobj.casenumber;
			String emailbody1 = 'New '+ caseobj.Severity__c+' Case '+checkoutage+
	'\n\n Customer: '+caseobj.account.name+
	'\n\n Product: '+caseobj.CH_Product_Name__c+
	'\n\n Subject: '+caseobj.Subject+
	'\n\n Case Number: '+caseobj.casenumber+
	'\n\n Region: '+caseRegion+
	',  Country: ' +caseobj.Country__c+
	'\n\n Case Reported (in GMT): '+caseobj.CH_ReportedDate__c+
	'\n\n Business Group: '+caseobj.CH_Rep_Product_Business_group__c+
	',  Business Unit: '+caseobj.CH_BusinessUnit__c+
	'\n\n External Bridge number: '+caseobj.CH_ExternalBridge__c+
	'\n\n Internal Bridge number: '+caseobj.CH_InternalBridge__c+
	'\n\n View Case:  '+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Case/'+caseobj.id+'/view';
			// EmailTemplate for  Case Assignment to Workgroup
			
			String  emailsubject2='SalesForce SWS : Case Assignment to Workgroup: '+caseobj.CH_Workgroup__r.name+', Customer: '+caseobj.account.name +', Product: '+caseobj.CH_Product_Name__c+', Case Number: '+caseobj.casenumber;
			String activeassignment ='No';
			if(caseobj.CH_CurrentQueue__c== null || caseobj.CH_CurrentQueue__c==''){
	activeassignment='Yes';
			}
			String  emailbody2='Assigned to Workgroup '+caseobj.CH_Workgroup__r.name+
	': '+caseobj.Severity__c+' '+caseobj.recordtype.name+
	','+' Outage '+caseobj.CH_Outage__c+
	', Customer: '+caseobj.account.name+
	', Product: '+caseobj.CH_Product_Name__c+
	'\n\nActive Assignment: '+activeassignment+
	'\n\nCase Status: '+caseobj.Status+ 
	'\n\nSubject: '+caseobj.Subject+
	'\n\nCase Number: '+caseobj.casenumber+
	'\n\nRegion: '+caseRegion+
	',  Country: ' +caseobj.Country__c+
	'\n\nCase Reported (in GMT): '+caseobj.CH_ReportedDate__c+
	'\n\nBusiness Group: '+caseobj.CH_Rep_Product_Business_group__c+
	',  Business Unit: '+caseobj.CH_BusinessUnit__c+
	'\n\nView Case:  '+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Case/'+caseobj.id+'/view';
			// Assignment for  information Request
			String  emailsubjectinfoalt='SalesForce SWS : Case Assignment to Workgroup: '+caseobj.CH_Workgroup__r.name+', Customer: '+caseobj.account.name +', Product: '+caseobj.CH_Product_Name__c+', Case Number: '+caseobj.casenumber;
			String  emailbodyinfoalt='Assigned to Workgroup '+caseobj.CH_Workgroup__r.name+
	' : Information Request' +
	', Customer: '+caseobj.account.name+
	', Product: '+caseobj.CH_Product_Name__c+ 
	'\n\nActive Assignment: '+activeassignment+
	'\n\nCase Status: '+caseobj.Status+ 
	'\n\nSubject: '+caseobj.Subject+
	'\n\nCase Number: '+caseobj.casenumber+
	'\n\nRegion: '+caseRegion+
	',  Country: ' +caseobj.Country__c+
	'\n\nCase Reported (in GMT): '+caseobj.CH_ReportedDate__c+
	'\n\nBusiness Group: '+caseobj.CH_Rep_Product_Business_group__c+
	',  Business Unit: '+caseobj.CH_BusinessUnit__c+
	'\n\nView Case:  '+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Case/'+caseobj.id+'/view';
			
			// Assignment for Minor Request
			String  emailsubjectminalt='SalesForce SWS : Case Assignment to Workgroup: '+caseobj.CH_Workgroup__r.name+', Customer: '+caseobj.account.name +', Product: '+caseobj.CH_Product_Name__c+', Case Number: '+caseobj.casenumber;
			String  emailbodyminalt='Assigned to Workgroup '+caseobj.CH_Workgroup__r.name+
	' : Minor ' +caseobj.recordtype.name+
	', Customer: '+caseobj.account.name+
	', Product: '+caseobj.CH_Product_Name__c+ 
	'\n\nActive Assignment: '+activeassignment+
	'\n\nCase Status: '+caseobj.Status+ 
	'\n\nSubject: '+caseobj.Subject+
	'\n\nCase Number: '+caseobj.casenumber+
	'\n\nRegion: '+caseRegion+
	',  Country: ' +caseobj.Country__c+
	'\n\nCase Reported (in GMT): '+caseobj.CH_ReportedDate__c+
	'\n\nBusiness Group: '+caseobj.CH_Rep_Product_Business_group__c+
	',  Business Unit: '+caseobj.CH_BusinessUnit__c+
	'\n\nView Case:  '+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Case/'+caseobj.id+'/view';
			//Email Template for  Outage Update
			String  emailsubject3='SalesForce SWS : Outage Flag change to '+caseobj.CH_Outage__c+', Customer: '+caseobj.account.name +', Product: '+caseobj.CH_Product_Name__c+', Case Number: '+caseobj.casenumber;
			String  emailbody3='Outage Flag change to: '+caseobj.CH_Outage__c+
	'\n\nSeverity: '+caseobj.Severity__c+	
	'\n\nCustomer: '+caseobj.account.name+
	'\n\n Product: '+caseobj.CH_Product_Name__c+
	'\n\nSubject: '+caseobj.Subject+
	'\n\nCase Number: '+caseobj.casenumber+
	'\n\nRegion: '+caseRegion+
	',  Country: ' +caseobj.Country__c+
	'\n\nCase Reported (in GMT): '+caseobj.CH_ReportedDate__c+
	'\n\nBusiness Group: '+caseobj.CH_Rep_Product_Business_group__c+
	',  Business Unit: '+caseobj.CH_BusinessUnit__c+
	'\n\n External Bridge number: '+caseobj.CH_ExternalBridge__c+
	'\n\n Internal Bridge number: '+caseobj.CH_InternalBridge__c+
	'\n\nView Case:  '+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Case/'+caseobj.id+'/view';
			//Severity Change email
			String emailsubject4='SalesForce SWS:Severity change to '+caseobj.Severity__c+', Customer: '+caseobj.account.name+', Product: '+caseobj.CH_Product_Name__c+', Case Number: '+caseobj.casenumber;
			String emailbody4 = 'Severity change to '+caseobj.Severity__c+
	'\n\n Outage: '+caseobj.CH_Outage__c+
	'\n\n Customer: '+caseobj.account.name+
	'\n\n Product: '+caseobj.CH_Product_Name__c+
	'\n\n Subject: '+caseobj.Subject+
	'\n\n Case Number: '+caseobj.casenumber+
	'\n\n Region: '+caseRegion+
	',  Country: ' +caseobj.Country__c+
	'\n\n Case Reported (in GMT): '+caseobj.CH_ReportedDate__c+
	'\n\n Business Group: '+caseobj.CH_Rep_Product_Business_group__c+
	',  Business Unit: '+caseobj.CH_BusinessUnit__c+
	'\n\n External Bridge number: '+caseobj.CH_ExternalBridge__c+
	'\n\n Internal Bridge number: '+caseobj.CH_InternalBridge__c+
	'\n\n View Case:  '+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Case/'+caseobj.id+'/view';
			
			//Case Restored Email Template
			String emailsubject5='SalesForce SWS: '+caseobj.Severity__c+' Case Restored'+', Customer: '+caseobj.account.name+', Product: '+caseobj.CH_Product_Name__c+', Case Number: '+caseobj.casenumber;
			String emailbody5=' '+caseobj.Severity__c+' Case, Outage '+caseobj.CH_Outage__c+', Restored'+
	'\n\n Customer: '+caseobj.account.name+
	'\n\n Product: '+caseobj.CH_Product_Name__c+
	'\n\n Subject: '+caseobj.Subject+
	'\n\n Case Number: '+caseobj.casenumber+
	'\n\n Region: '+caseRegion+
	',  Country: ' +caseobj.Country__c+
	'\n\n Case Reported (in GMT): '+caseobj.CH_ReportedDate__c+
	'\n\n Business Group: '+caseobj.CH_Rep_Product_Business_group__c+
	',  Business Unit: '+caseobj.CH_BusinessUnit__c+
	'\n\n External Bridge number: '+caseobj.CH_ExternalBridge__c+
	'\n\n Internal Bridge number: '+caseobj.CH_InternalBridge__c+
	'\n\n View Case:  '+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Case/'+caseobj.id+'/view';
			//Restoration-in-progress email template manual update
			
			String emailsubject6='SalesForce SWS : Manual Update Customer: '+caseobj.account.name+', Product: '+caseobj.CH_Product_Name__c+', Case Number: '+caseobj.casenumber;
			String emailbody6='Restoration in Progress : '+caseobj.Severity__c+' Case, Outage '+caseobj.CH_Outage__c+', Manual Update'+
	'\n\n Comment: '+caseobj.Comment__c+
	'\n\n Customer: '+caseobj.account.name+
	'\n\n Product: '+caseobj.CH_Product_Name__c+
	'\n\n Subject: '+caseobj.Subject+
	'\n\n Case Number: '+caseobj.casenumber+
	'\n\n Region: '+caseRegion+
	',  Country: ' +caseobj.Country__c+
	'\n\n Case Reported (in GMT): '+caseobj.CH_ReportedDate__c+
	'\n\n Business Group: '+caseobj.CH_Rep_Product_Business_group__c+
	',  Business Unit: '+caseobj.CH_BusinessUnit__c+
	'\n\n External Bridge number: '+caseobj.CH_ExternalBridge__c+
	'\n\n Internal Bridge number: '+caseobj.CH_InternalBridge__c+
	'\n\n View Case:  '+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Case/'+caseobj.id+'/view';  
			// Restoration-in-progress- TXXX
			String TXXX;
			if(evtype=='T15'){
	TXXX='T15';
			}
			if(evtype=='T60'){
	TXXX='T60';
			}
			if(evtype=='T180'){
	TXXX='T180';
			}
			if(evtype=='T360'){
	TXXX='T360';
			}
			if(evtype=='T720'){
	TXXX='T720';
			}
			if(evtype=='T1440'){
	TXXX='T1440';
			}
	 
			String emailsubject7='SalesForce SWS: '+TXXX+', Customer: '+caseobj.account.name+', Product: '+caseobj.CH_Product_Name__c+', Case Number: '+caseobj.casenumber;
			String emailbody7='Restoration in Progress: '+caseobj.Severity__c +' Case, Outage '+caseobj.CH_Outage__c+', '+TXXX+
	'\n\n Comment: '+caseobj.Comment__c+
	'\n\n Customer: '+caseobj.account.name+
	'\n\n Product: '+caseobj.CH_Product_Name__c+
	'\n\n Subject: '+caseobj.Subject+
	'\n\n Case Number: '+caseobj.casenumber+
	'\n\n Region: '+caseRegion+
	',  Country: ' +caseobj.Country__c+
	'\n\n Case Reported (in GMT): '+caseobj.CH_ReportedDate__c+
	'\n\n Business Group: '+caseobj.CH_Rep_Product_Business_group__c+
	',  Business Unit: '+caseobj.CH_BusinessUnit__c+
	'\n\n External Bridge number: '+caseobj.CH_ExternalBridge__c+
	'\n\n Internal Bridge number: '+caseobj.CH_InternalBridge__c+
	'\n\n View Case:  '+URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/Case/'+caseobj.id+'/view';
			if(evtype=='Critical-Yes' || evtype=='Major-Yes' || evtype=='Critical-No' ||evtype=='Major-No'){
	emailsubject= emailsubject1;
	emalplainbody=emailbody1;	
			}   
			if(evtype=='CA-Critical' || evtype=='CA-Major' ){
	emailsubject= emailsubject2;
	emalplainbody=emailbody2;
			}
			if(evtype=='CA-Minor'){
	emailsubject= emailsubjectminalt;
	emalplainbody=emailbodyminalt;
			}
			if( evtype=='CA-IR'){
	emailsubject= emailsubjectinfoalt;
	emalplainbody=emailbodyinfoalt; 
			}
			if(evtype=='Outage Update'){
	emailsubject= emailsubject3;
	emalplainbody=emailbody3;	
			}
			if(evtype=='Critical' || evtype=='Major'){
	emailsubject= emailsubject4;
	emalplainbody=emailbody4;	
			}
			if(evtype=='Restored'){
	emailsubject= emailsubject5;
	emalplainbody=emailbody5;	
			}
			if(evtype=='Distribute Comment Update'){ //check correct event type for manual update
	emailsubject= emailsubject6;
	emalplainbody=emailbody6;  
			}
			if(evtype=='T15' || evtype=='T60' || evtype=='T15' || evtype=='T180' || evtype=='T360' || evtype=='T720' || evtype=='T1440' ){ //check correct event type for TXXX
	emailsubject= emailsubject7;
	emalplainbody=emailbody7;  
			}
			semail.setSubject(emailsubject);
			semail.setPlainTextBody(emalplainbody);			
			semail.setOrgWideEmailAddressId(Label.CH_FromEmailNS);  // hard coded to avoid Soql in OrgWideEmailAddress
			semail.setSaveAsActivity(false);
			semail.setCharset('UTF-8');
		}
		catch(Exception e){
			ErrorLog__c err = CH_ErrorLogUtils.createErrorLog(e.getTypeName()+' '+e.getMessage()+' Line number: ' + e.getLineNumber()+' Stack trace: ' + e.getStackTraceString(),'CH_CN_NotificationSubscriptionContent-sendEmailtoSubscribers',NOTIFICATION_QUEUEABLE, 'CH_Notification_Identify_Subscribers', caseobj.Id);
			CH_ErrorLogUtils.insertErrorLog(new List<ErrorLog__c>{err});
		} 
		return semail; 
	}
	
	/******************************************************************************************
	* Method Name: getRegionFromCountry
	* Parameter : Case Country
	* This method will fetch the region from custom settings and return the Region
	* Developed By: Gourisankar
	* Last Modified( on & By): Gourisankar on 19.11.2020
	* Optimization done to fetch the region based on country
	********************************************************************************************/
	
	public static string getRegionFromCountry(String caseCountry){
		
		return CH_CA_Assignment_Criteria_DTO.getRegionByCountry(caseCountry);
	}
	
	/**************************************************************************************
* Method Name: prepareBodyForCustomNotification
* Parameter : Case caseobj, String evtype
* This method will prepare the Title and body for Custom Notification based on event type
* Developed By: Satya Pagada/Gourisankar
* Last Modified( on & By): Satya Pagada on 04.09.2020
*************************************************************************************/   
	public static Map<String,String> prepareBodyForCustomNotification(Case caseobj, String evtype){
		Map<String,String> titleBodyMap = new Map<String,String>();
		try{  
			String notbody,title;
			Integer maxsize=750;
			if(caseobj.CH_ExternalBridge__c == null){
	caseobj.CH_ExternalBridge__c='';
			}
			if(caseobj.CH_InternalBridge__c == null){
	caseobj.CH_InternalBridge__c='';
			}
			if(caseobj.Comment__c == null){
	caseobj.Comment__c='';
			}  
			string caseRegionforNot = getRegionFromCountry(caseObj.Country__c);
			//Notification Body for  Case Assignment to Workgroup
			String activeassignment ='No';
			if(caseobj.CH_CurrentQueue__c== null || caseobj.CH_CurrentQueue__c==''){
	activeassignment='Yes';
			}
			
			// Workgroup assignment-Major and Critical
			String notificationtitle1 ='Assigned to Workgroup '+caseobj.CH_Workgroup__r.name+
	': '+caseobj.Severity__c+' '+caseobj.recordtype.name+
	','+' Outage '+caseobj.CH_Outage__c; 
			String notificationbody1 = 'Active Assignment: '+activeassignment+
	', Customer: '+caseobj.account.name+
	', Product: '+caseobj.CH_Product_Name__c+
	'\n Case Status: '+caseobj.Status+
	'\n Subject: '+caseobj.subject+
	'\n Case#: '+caseobj.casenumber+	  
	'\n Region: '+caseRegionforNot+'- Country: ' +caseobj.Country__c+
	'\n Case Reported(in GMT): '+caseobj.CH_ReportedDate__c+
	'\n BG: '+caseobj.CH_Rep_Product_Business_group__c+ ' - BU: '+caseobj.CH_BusinessUnit__c;
			String notificationbody1alt = 'Active Assignment: '+activeassignment+
	', Customer: '+caseobj.account.name+
	', Product: '+caseobj.CH_Product_Name__c+
	'\n Case#: '+caseobj.casenumber+
	'\n Case Status: '+caseobj.Status+	 
	'\n Region: '+caseRegionforNot+'- Country: ' +caseobj.Country__c+
	'\n BG: '+caseobj.CH_Rep_Product_Business_group__c;
			
			//Workgroup assignment- Minor 
			String notificationtitle2 ='Assigned to Workgroup: '+caseobj.CH_Workgroup__r.name+
	' Minor '+caseobj.recordtype.name; 
			//Workgroup assignment- Information 
			String notificationtitleinfo ='Assigned to Workgroup: '+caseobj.CH_Workgroup__r.name+
	' Information Request ';
			//Notification Body for Case Creation
			String checkingoutage;
			if(caseobj.CH_Outage__c=='Yes'){
	checkingoutage='with Outage';
			}else{
	checkingoutage='without Outage';
			}
			string notificationtitle3 = 'New '+ caseobj.Severity__c +' Case '+checkingoutage;
			String notificationbody3='Customer: '+caseobj.account.name+
	'\n Product: '+caseobj.CH_Product_Name__c+ ' - Case#: '+caseobj.casenumber+ 
	'\n Ext Bridge# '+caseobj.CH_ExternalBridge__c+
	'\n Int Bridge# '+caseobj.CH_InternalBridge__c+
	'\n Subject: '+caseobj.subject+		
	'\n Region: '+caseRegionforNot+'- Country: ' +caseobj.Country__c+ 
	'\n Case Reported(in GMT): '+caseobj.CH_ReportedDate__c+
	'\n BG: '+caseobj.CH_Rep_Product_Business_group__c+ ' - BU: '+caseobj.CH_BusinessUnit__c;
			String notificationbody3alt='Customer: '+caseobj.account.name+
	'\n Product: '+caseobj.CH_Product_Name__c+ ' - Case#: '+caseobj.casenumber+	
	'\n Ext Bridge# '+caseobj.CH_ExternalBridge__c+
	'\n Region: '+caseRegionforNot+'- Country: ' +caseobj.Country__c+	
	'\n BG: '+caseobj.CH_Rep_Product_Business_group__c;
			
			
			//Notification for Severity Change
			string notificationtitle4 = 'Severity change to '+caseobj.Severity__c;
			String notificationbody4='Outage: '+caseobj.CH_Outage__c+
	'\n Customer: '+caseobj.account.name+
	'\n Product: '+caseobj.CH_Product_Name__c+ ' - Case#: '+caseobj.casenumber+ 
	'\n Ext Bridge# '+caseobj.CH_ExternalBridge__c+
	'\n Int Bridge# '+caseobj.CH_InternalBridge__c+   
	'\n Subject: '+caseobj.subject+	 
	'\n Region: '+caseRegionforNot+'- Country: ' +caseobj.Country__c+ 
	'\n Case Reported(in GMT): '+caseobj.CH_ReportedDate__c+
	'\n BG: '+caseobj.CH_Rep_Product_Business_group__c+ ' - BU: '+caseobj.CH_BusinessUnit__c;
			String notificationbody4alt='Outage: '+caseobj.CH_Outage__c+
	'\n Customer: '+caseobj.account.name+
	'\n Product: '+caseobj.CH_Product_Name__c+ ' - Case#: '+caseobj.casenumber+ 
	'\n Ext Bridge# '+caseobj.CH_ExternalBridge__c+   
	'\n Region: '+caseRegionforNot+'- Country: ' +caseobj.Country__c+	
	'\n BG: '+caseobj.CH_Rep_Product_Business_group__c;
			//Notification Body For Outage Update
			string notificationtitle5 = 'Outage Flag change to '+caseobj.CH_Outage__c;
			String notificationbody5='Severity: '+caseobj.Severity__c+ 
	'\n Customer: '+caseobj.account.name+
	'\n Product: '+caseobj.CH_Product_Name__c+ ' - Case#: '+caseobj.casenumber+ 
	'\n Ext Bridge# '+caseobj.CH_ExternalBridge__c+
	'\n Int Bridge# '+caseobj.CH_InternalBridge__c+
	'\n Subject: '+caseobj.subject+	 
	'\n Region: '+caseRegionforNot+'- Country: ' +caseobj.Country__c+ 
	'\n Case Reported(in GMT): '+caseobj.CH_ReportedDate__c+
	'\n BG: '+caseobj.CH_Rep_Product_Business_group__c+ ' - BU: '+caseobj.CH_BusinessUnit__c;
			String notificationbody5alt='Severity: '+caseobj.Severity__c+ 
	'\n Customer: '+caseobj.account.name+
	'\n Product: '+caseobj.CH_Product_Name__c+ ' - Case#: '+caseobj.casenumber+ 
	'\n Ext Bridge# '+caseobj.CH_ExternalBridge__c+   
	'\n Region: '+caseRegionforNot+'- Country: ' +caseobj.Country__c+	
	'\n BG: '+caseobj.CH_Rep_Product_Business_group__c;
			//Notification Body For Case Restored
			string notificationtitle6 = caseobj.Severity__c+' Case, Outage '+caseobj.CH_Outage__c+', Restored';
			String notificationbody6='Customer: '+caseobj.account.name+
	'\n Product: '+caseobj.CH_Product_Name__c+ ' - Case#: '+caseobj.casenumber+
	'\n Ext Bridge# '+caseobj.CH_ExternalBridge__c+
	'\n Int Bridge# '+caseobj.CH_InternalBridge__c+
	'\n Subject: '+caseobj.subject+ 
	'\n Region: '+caseRegionforNot+'- Country: ' +caseobj.Country__c+ 
	'\n Case Reported(in GMT): '+caseobj.CH_ReportedDate__c+
	'\n BG: '+caseobj.CH_Rep_Product_Business_group__c+ ' - BU: '+caseobj.CH_BusinessUnit__c;
			String notificationbody6alt='Customer: '+caseobj.account.name+
	'\n Product: '+caseobj.CH_Product_Name__c+ ' - Case#: '+caseobj.casenumber+	
	'\n Ext Bridge# '+caseobj.CH_ExternalBridge__c+
	'\n Region: '+caseRegionforNot+'- Country: ' +caseobj.Country__c+	
	'\n BG: '+caseobj.CH_Rep_Product_Business_group__c;
			
			//Notificaion Body for Manual Update
			string notificationtitle7 = 'Restoration in Progress: '+caseobj.Severity__c+' Case, Outage '+caseobj.CH_Outage__c+', Manual Update';
			String notificationbody7='Comment: '+caseobj.Comment__c+
	'\n Customer: '+caseobj.account.name+
	'\n Product: '+caseobj.CH_Product_Name__c+ ' - Case#: '+caseobj.casenumber+
	'\n Ext Bridge# '+caseobj.CH_ExternalBridge__c+
	'\n Int Bridge# '+caseobj.CH_InternalBridge__c+
	'\n Subject: '+caseobj.subject+	 
	'\n Region: '+caseRegionforNot+'- Country: ' +caseobj.Country__c+ 
	'\n Case Reported(in GMT): '+caseobj.CH_ReportedDate__c+
	'\n BG: '+caseobj.CH_Rep_Product_Business_group__c+ ' - BU: '+caseobj.CH_BusinessUnit__c;
			String notificationbody7alt='Comment: '+caseobj.Comment__c+
	'\n Customer: '+caseobj.account.name+
	'\n Product: '+caseobj.CH_Product_Name__c+ ' - Case#: '+caseobj.casenumber+
	'\n Ext Bridge# '+caseobj.CH_ExternalBridge__c+
	'\n Region: '+caseRegionforNot+', Country: ' +caseobj.Country__c+	
	'\n BG: '+caseobj.CH_Rep_Product_Business_group__c;
			
			// Restoration-in-progress- TXXX
			String TXXXnumber;
			if(evtype=='T15'){
	TXXXnumber='T15';
			}
			if(evtype=='T60'){
	TXXXnumber='T60';
			}
			if(evtype=='T180'){
	TXXXnumber='T180';
			}
			if(evtype=='T360'){
	TXXXnumber='T360';
			}
			if(evtype=='T720'){
	TXXXnumber='T720';
			}
			if(evtype=='T1440'){
	TXXXnumber='T1440';
			}
			string notificationtitle8 = 'Restoration in Progress: '+caseobj.Severity__c+' Case, Outage '+caseobj.CH_Outage__c+', '+TXXXnumber;
			String notificationbody8='Comment: '+caseobj.Comment__c+
	'\n Customer: '+caseobj.account.name+
	'\n Product: '+caseobj.CH_Product_Name__c+ '- Case#: '+caseobj.casenumber+ 
	'\n Ext Bridge# '+caseobj.CH_ExternalBridge__c+
	'\n Int Bridge# '+caseobj.CH_InternalBridge__c+
	'\n Subject: '+caseobj.subject+ 
	'\n Region: '+caseRegionforNot+'- Country: ' +caseobj.Country__c+ 
	'\n Case Reported(in GMT): '+caseobj.CH_ReportedDate__c+
	'\n BG: '+caseobj.CH_Rep_Product_Business_group__c+ ' - BU: '+caseobj.CH_BusinessUnit__c;
			String notificationbody8alt='Comment: '+caseobj.Comment__c+
	'\n Customer: '+caseobj.account.name+
	'\n Product: '+caseobj.CH_Product_Name__c+  ' - Case#: '+caseobj.casenumber+ 
	'\n Ext Bridge# '+caseobj.CH_ExternalBridge__c+
	'\n Region: '+caseRegionforNot+'- Country: ' +caseobj.Country__c+	
	'\n BG: '+caseobj.CH_Rep_Product_Business_group__c;
			
			
			if(evtype=='Critical-Yes' || evtype=='Critical-No' || evtype=='Major-Yes' || evtype=='Major-No'){
	if(notificationbody3.length() > maxsize){	  
		notbody= notificationbody3alt;
	}else{
		notbody= notificationbody3;
	}	
	title=notificationtitle3;	
			}
			if(evtype=='CA-Critical' || evtype=='CA-Major'){
	if(notificationbody1.length() > maxsize){	  
		notbody= notificationbody1alt;
	}else{
		notbody= notificationbody1;
	}	
	title=notificationtitle1;
			}
			if(evtype=='CA-Minor'){
	if(notificationbody1.length() > maxsize){	  
		notbody= notificationbody1alt;
	}else{
		notbody= notificationbody1;
	}
	title=notificationtitle2;
			}
			if(evtype=='CA-IR'){
	if(notificationbody1.length() > maxsize){	  
		notbody= notificationbody1alt;
	}else{
		notbody= notificationbody1;
	}
	title=notificationtitleinfo;
			}
			if(evtype=='Critical' || evtype=='Major'){
	if(notificationbody4.length() > maxsize){	  
		notbody= notificationbody4alt;
	}else{
		notbody= notificationbody4;
	}
	title=notificationtitle4;
			}
			if(evtype=='Outage Update'){	
	if(notificationbody5.length() > maxsize){	  
		notbody= notificationbody5alt;
	}else{
		notbody= notificationbody5;
	}
	title=notificationtitle5;
			}
			if(evtype=='Restored'){
	if(notificationbody6.length() > maxsize){	  
		notbody= notificationbody6alt;
	}else{
		notbody= notificationbody6;
	}
	title=notificationtitle6; 
			}
			if(evtype=='Distribute Comment Update'){
	if(notificationbody7.length() > maxsize){	  
		notbody= notificationbody7alt;
	}else{
		notbody= notificationbody7;
	}	
	title=notificationtitle7;  
			}
			if(evtype=='T15' || evtype=='T60' || evtype=='T15' || evtype=='T180' || evtype=='T360' || evtype=='T720' || evtype=='T1440'){
	if(notificationbody8.length() > maxsize){	  
		notbody= notificationbody8alt;
	}else{
		notbody= notificationbody8;
	}
	title=notificationtitle8;
			}
			titleBodyMap.put(title, notbody);
		}
		catch(Exception e){
			ErrorLog__c err = CH_ErrorLogUtils.createErrorLog(e.getTypeName()+' '+e.getMessage()+' Line number: ' + e.getLineNumber()+' Stack trace: ' + e.getStackTraceString(),'CH_CN_NotificationSubscriptionContent-prepareBodyForCustomNotification',NOTIFICATION_QUEUEABLE, 'CH_Notification_Identify_Subscribers', caseobj.Id);
			CH_ErrorLogUtils.insertErrorLog(new List<ErrorLog__c>{err});
		}
		return titleBodyMap;   
	}
}

/********************************************Few Notes*************************************************************
* 
* Notification titles and bodies are trimmed after merge fields are expanded.
*  In-app notification titles have a maximum of 250 characters and the bodies have a maximum of 750 characters.
*  Character limits for mobile push notifications depend on the Display full content push notifications setting 
*   on the Salesforce for iOS or Salesforce for Android connected apps pages in Setup.
* 
* There are some restrictions applied for the Mobile notifications. This includes (but not limited to):
*   The user must have installed the app on their phone
*   The application must have notifications turned on
*   and, that the user actually looks at the app
* 
* A desktop notification can be delivered in real time to up to 1,000 concurrently logged-in recipients.
*   Additional concurrently logged-in recipients must refresh their Salesforce page to see their latest 
*   notifications. Recipients who aren't logged in see their notifications as expected upon login
* 
* ******************************************************************************************************************/