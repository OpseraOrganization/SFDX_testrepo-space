/***********************************************************************
* Name : HWS_ProcessMissingReturnDeliveryBatch
* Description : batch class to retrofit missing attachments on parent cases
*Created Date : 20-Sep-2021
***********************************************************************/
global without sharing class HWS_ProcessMissingReturnDeliveryBatch implements Database.Batchable<sObject>,Database.Stateful,Schedulable {
	
	 public String cronId = '';
	global HWS_ProcessMissingReturnDeliveryBatch(String cronId){  
		//this.queryString=query;
		this.cronId = cronId;
	}
	global void execute(SchedulableContext ctx) {
		String cronId = ctx.getTriggerId();
		System.debug('AttachmentBatch# in order scheduler debug');
		HWS_ProcessMissingReturnDeliveryBatch batchObj = new HWS_ProcessMissingReturnDeliveryBatch(cronId);  
		if(!test.isRunningTest()){Database.executeBatch(batchObj,1);
								 }
//system.schedule('Update job', CRON_EXP, sch);
		
	}
	/****************************************************************
	* Name : start
	* Description : this method will contain the SOQL query for the batch 
	*****************************************************************/
	global Database.QueryLocator start(Database.BatchableContext BC) {
		DateTime lastRunDate = HWS_GenericSettings__c.getValues('BulkOrderLastsync').ReturnAddressSyncTime__c;
		String queryString;
			if(lastRunDate!=null)
			{
				 queryString='select id,casenumber,parentid,HWS_ReturnAddressReceivedFromSOO__c from Case where ';
			 queryString +='HWS_RecordTypeCheck__c =true and HWS_Address_Name__c=null and Parent.HWS_ReturnAddressReceivedFromSOO__c=true and Parentid'+'!='+'null and CreatedDate >: lastRunDate' ;
			
			}
			else
			{
				  queryString='select id,casenumber,parentid,HWS_ReturnAddressReceivedFromSOO__c from Case where ';
			 queryString +='HWS_RecordTypeCheck__c =true and HWS_Address_Name__c=null and Parent.HWS_ReturnAddressReceivedFromSOO__c=true and Parentid'+'!='+'null' ;
			}
		return Database.getQueryLocator(queryString);
	}
	/****************************************************************
	* Name : execute
	* Description : Execution of the batch
	*****************************************************************/
	global void execute(Database.BatchableContext BC, List<Case> caseList) {
			Set<Id> caseIds2=new Set<Id>();
			Map<Id,Set<Id>> parentChildMap= new Map<Id,Set<Id>>();
			for(Case cs:caseList){   
					//caseIds.add(cs.ParentId);
				if(parentChildMap.get(cs.ParentId)!=null){
					Set<Id> childIds=parentChildMap.get(cs.ParentId); 
					childIds.add(cs.id);
					parentChildMap.put(cs.ParentId,childIds);
				}
				else{   
					Set<Id> childId=new Set<Id>();
					childId.add(cs.Id);
					parentChildMap.put(cs.ParentId,childId);
				}					
			}
		for(Id parent:parentChildMap.keySet()){
			HWS_UpdateReturnDeliveryAddress.updateReturnDeliveryAddressOnChildCaseFromBatch(parentChildMap.get(parent),parent);
		}			
	}
	/****************************************************************
	* Name : finish
	* Description : Logic to be performed when finished all processing all rows
	*****************************************************************/
	global void finish(Database.BatchableContext BC) {	 
		 System.debug('Batch# in order batch final'); 
			if(!String.isBlank(cronId)){
			CronTrigger[] cronTrigger = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name like 'HWS_PMAB%'  WITH SECURITY_ENFORCED LIMIT 5];
			if(cronTrigger != null && !cronTrigger.isEmpty()){
	for (CronTrigger schedule : cronTrigger){
		if(!Test.isRunningTest() && schedule.Id != cronId){System.abortJob(schedule.Id);}
	}
			}
		}
		//Integer batchRunInterval = Integer.valueOf(CH_Settings__c.getValues('RunFreqInMinuteNotificationBatch') != null ? CH_Settings__c.getValues('RunFreqInMinuteNotificationBatch').SettingValue__c :'0');
		Integer batchRunInterval = 180;
		datetime currentDateTime = system.now().addMinutes(batchRunInterval);
		String day = string.valueOf(currentDateTime.day());
		String month = string.valueOf(currentDateTime.month());
		String hour = string.valueOf(currentDateTime.hour());
		String minute = string.valueOf(currentDateTime.minute());
		String second = string.valueOf(currentDateTime.second());
		String year = string.valueOf(currentDateTime.year());
		String strScheduleTime = second +CAPS_ConstantHandler.EMPTY_WHITESPACE+ minute + CAPS_ConstantHandler.EMPTY_WHITESPACE + hour + CAPS_ConstantHandler.EMPTY_WHITESPACE + day + CAPS_ConstantHandler.EMPTY_WHITESPACE + month + ' ?' + CAPS_ConstantHandler.EMPTY_WHITESPACE + year;
		String uniqustring = string.ValueOf(currentDateTime.getTime());	
		if(!Test.isRunningTest() ){
			System.debug('Batch# in order batch final before schedule');
			System.schedule('HWS_PMAB Del'+strScheduleTime+ ''+uniqustring, strScheduleTime, new HWS_ProcessMissingReturnDeliveryBatch(cronId)); 
		}
	}
}