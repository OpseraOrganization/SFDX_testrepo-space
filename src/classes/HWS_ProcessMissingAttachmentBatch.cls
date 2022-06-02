/*****
*Story : NOKIASC-40333
*Description : Created for handling Attachment missing cases even after they are ordered
*due to rowlock or any other issue which have address updated on them.
***/
global without sharing class HWS_ProcessMissingAttachmentBatch implements Database.Batchable<sObject>,Database.Stateful,Schedulable {
	
	public String cronId = '';
	global HWS_ProcessMissingAttachmentBatch(String cronId){ 
		this.cronId = cronId;
	}
	global void execute(SchedulableContext ctx) {
		String cronId = ctx.getTriggerId();
		HWS_ProcessMissingAttachmentBatch batchObj = new HWS_ProcessMissingAttachmentBatch(cronId);  
		if(!test.isRunningTest()){Database.executeBatch(batchObj,1);
		 }
		
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
	queryString='select id,casenumber,HWS_ReturnAddressReceivedFromSOO__c from Case where ';
	queryString +='HWS_RecordTypeCheck__c =true and HWS_OrderConfirmationSent__c=true and HWS_ReturnAddressReceivedFromSOO__c=true and Parentid'+'='+'null and CreatedDate >: lastRunDate' ;
			
			}
			else
			{
				queryString='select id,casenumber,HWS_ReturnAddressReceivedFromSOO__c from Case where ';
	queryString +='HWS_RecordTypeCheck__c =true and HWS_OrderConfirmationSent__c=true and HWS_ReturnAddressReceivedFromSOO__c=true and Parentid'+'='+'null' ;

			}
		return Database.getQueryLocator(queryString);
	}
	/****************************************************************
	* Name : execute
	* Description : Execution of the batch
	*****************************************************************/
	global void execute(Database.BatchableContext BC, List<Case> caseList) {
		 Map < Id, boolean > isdeliveryAddrSent = new Map<Id, boolean >();
	   Set<Id> ParentCaseId=new Set<Id>();
	   for(Case cs:caseList)
	   {
		   ParentCaseId.add(cs.id);
	   }
	   List<Case> cschildList=[Select id,HWS_Bar_Code__c,HWS_Bar_Code_Ref1__c,ParentId,Parent.Id from Case where Parentid in :ParentCaseId];
	  if(cschildList.Size()>0)
	  {
		  for(Case cs:cschildList){			
				if(!isdeliveryAddrSent.containsKey(cs.parent.Id)) {
					isdeliveryAddrSent.put(cs.parent.Id, true);
				}
				String parentBarcode = cs.HWS_Bar_Code__c;
				String rmaBarcode = cs.HWS_Bar_Code_Ref1__c;
				if(parentBarcode == null || rmaBarcode == null ){ 
					isdeliveryAddrSent.put(cs.parent.Id, false);
				}
		  }
		  Set<Id> parentIdSet=new Set<Id>();
		  for(Id parentID:isdeliveryAddrSent.keySet())
		  {
			  if(isdeliveryAddrSent.get(parentID))
			  {
				  parentIdSet.add(parentID);
			  }
		  }
	if(parentIdSet.size()>0){
		 Map<Id,Case> childMap= new Map<Id,Case>([Select id from Case where ParentId in :parentIdSet]);
		HWS_OrderConfirmationNotification.sendEmailNotificationForPDFForBatch(childMap.keySet());
	}
	  }
	}
	/****************************************************************
	* Name : finish
	* Description : Logic to be performed when finished all processing all rows
	*****************************************************************/
	global void finish(Database.BatchableContext BC) {
			if(!String.isBlank(cronId)){
			CronTrigger[] cronTrigger = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name like 'Update job%'  WITH SECURITY_ENFORCED LIMIT 5];
			if(cronTrigger != null && !cronTrigger.isEmpty()){
	for (CronTrigger schedule : cronTrigger){
		if(!Test.isRunningTest() && schedule.Id != cronId){System.abortJob(schedule.Id);}
	}
			}
		}
		Integer batchRunInterval = 60;
		datetime currentDateTime = system.now().addMinutes(batchRunInterval);
		String day = string.valueOf(currentDateTime.day());
		String month = string.valueOf(currentDateTime.month());
		String hour = string.valueOf(currentDateTime.hour());
		String minute = string.valueOf(currentDateTime.minute());
		String second = string.valueOf(currentDateTime.second());
		String year = string.valueOf(currentDateTime.year());
		String strScheduleTime = second +CAPS_ConstantHandler.EMPTY_WHITESPACE+ minute + CAPS_ConstantHandler.EMPTY_WHITESPACE + hour + CAPS_ConstantHandler.EMPTY_WHITESPACE + day + CAPS_ConstantHandler.EMPTY_WHITESPACE + month + ' ?' + CAPS_ConstantHandler.EMPTY_WHITESPACE + year;
		String uniqustring = string.ValueOf(currentDateTime.getTime());
		if(!Test.isRunningTest() )
		{
			System.schedule('Update jobDel'+strScheduleTime+ ''+uniqustring, strScheduleTime, new HWS_ProcessMissingAttachmentBatch(cronId)); 
		}
	
	}
}