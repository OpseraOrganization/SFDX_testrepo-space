/****************************************
* Class Name : Batch_CAPSStatusUpdate
* Created Date : 28-Aug-2018
* Author : TCS  
* Description : Checking the real status from the Caps Server and updating in the salesforce
* Last Modified Date :
* Last Modified by : 
*****************************************/
global class Batch_CAPSStatusUpdate implements Database.Batchable<sObject>,Database.AllowsCallouts,Database.Stateful {
	String decodedSignatureKey =  DecodeEncodeUtility.decodeValues(CAPS_ConstantHandler.SIGNATURE_KEYID2);
	String baseUrl, storageUrl, suffixUrl, userName;
	private List<String> unCaughtExceptions = new List<String>();
	public String queryString= '';
	public String cronId = '';
	/*
		Constructor
	*/
	global Batch_CAPSStatusUpdate(String query,String cronId){ 
		this.queryString=query;
		this.cronId = cronId;
	}
/******************************************
	* Method Name : start
	* Created Date: 08/28/2018
	* Created By : TCS
	* Descsription: Get all the records to be processed from the cH_Attachment objects
	* Parameter: NA
	* Return:
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
*******************************************/
	global Database.QueryLocator start(Database.BatchableContext bc) {
		baseUrl = CAPS_ConstantHandler.BASE_URL;
		storageUrl = CAPS_ConstantHandler.SYSTEM_URL;
		Date todayMinus3 = system.today().addDays(-CAPS_ConstantHandler.SPECIFICTIMEFORONHOLD);
		Date todaysDate = system.today();
		return Database.getQueryLocator(queryString);
	}
/******************************************
	* Method Name : execute
	* Created Date: 08/28/2018
	* Created By : TCS
	* Descsription: Process a batch from all the records that were retrieved from the CH_Attachment table
	* Parameter: NA
	* Return:
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
*******************************************/
	global void execute(Database.BatchableContext bc, List<CH_Attachment__c> ChAttachmentList){
		try{
			List<CH_Attachment__c> updatelist=new List<CH_Attachment__c>();
			userName=Label.CAPS_StatusUpdateBatchCAPSUserName;//'app_salesforce';
			String checkForHoldStatus = CH_Settings__c.getValues('checkToUpdateStatusToHold')!=null?CH_Settings__c.getValues('checkToUpdateStatusToHold').SettingValue__c:'TRUE';
			for(CH_Attachment__c attachmentObj : ChAttachmentList){
	Set<String> capsfileNameSet = new Set<String>();
	if(attachmentObj.AttachmentID__c !=null){
		suffixUrl=storageUrl + attachmentObj.AttachmentID__c + CAPS_ConstantHandler.USER_STR + userName ; 
	}	 
	CAPS_Attachments_Download callLogApiObj = new CAPS_Attachments_Download();
	HTTPResponse resCAPSApi = callLogApiObj.callLogApi(baseUrl,suffixUrl,'');
	  if(resCAPSApi.getStatusCode() == CAPS_ConstantHandler.REQUEST_STATUS_200){
		Map<String, Object> objMapApiResponse = (Map<String, Object>)JSON.deserializeUntyped(resCAPSApi.getBody());
		List<Map<String, Object>> objDataApiResponse = new List<Map<String, Object>>();
		for (Object instance : (List<Object>)objMapApiResponse.get(CAPS_ConstantHandler.FILES)){
			objDataApiResponse.add((Map<String, Object>)instance);
		}
		for(integer i=0; i< objDataApiResponse.size(); i++){
			string capsStatus = (String)objDataApiResponse.get(i).get(CAPS_ConstantHandler.STATUS);
			string capsFileName = (String)objDataApiResponse.get(i).get(CAPS_ConstantHandler.NAMES);
			capsfileNameSet.add(capsFileName);
			if(!String.isBlank(attachmentObj.File_Name__c) && capsFileName.equalsignorecase(attachmentObj.File_Name__c)){
				if(attachmentObj.CH_MarkForDelete__c && attachmentObj.CH_Actual_Delete_Date__c == null){
		CH_Attachment__c chattach3=new CH_Attachment__c();
		chattach3.Id =attachmentObj.Id;
		chattach3.CH_Status__c =capsStatus;
		if(CAPS_ConstantHandler.DELETED_STATUS.equalsignorecase(capsStatus)){
			chattach3.CH_Actual_Delete_Date__c = system.today();  
		}
		if(!attachmentObj.CH_Status__c.equalsignorecase(chattach3.CH_Status__c)){
			updatelist.add(chattach3);
		}
				}
				else if(attachmentObj.CH_Status__c != CAPS_ConstantHandler.DELETED_STR && 
				attachmentObj.CH_Status__c != CAPS_ConstantHandler.READY_STATUS && 
				attachmentObj.CH_Status__c != CAPS_ConstantHandler.ONHOLD && 
				!CAPS_ConstantHandler.FAILED_STATUS.equalsignorecase(attachmentObj.CH_Status__c) 
				&& capsStatus != CAPS_ConstantHandler.DELETED_STATUS){
		CH_Attachment__c chattach1=new CH_Attachment__c();
		chattach1.Id = attachmentObj.id;
		chattach1.CH_Status__c =capsStatus;		
		if(attachmentObj.CH_Uploaded__c <= system.today()-CAPS_ConstantHandler.SPECIFICTIMEFORONHOLD && 
		capsStatus !=CAPS_ConstantHandler.READY && !CAPS_ConstantHandler.FAILED_STATUS.equalsignorecase(capsStatus)  
		&& !attachmentObj.CH_MarkForDelete__c && checkForHoldStatus.equalsIgnoreCase('TRUE')){
			chattach1.CH_Status__c = CAPS_ConstantHandler.ONHOLD; 
		}
		if(!attachmentObj.CH_Status__c.equalsignorecase(chattach1.CH_Status__c)){
			updatelist.add(chattach1);
		}
				}
			}
		}	  
		if(!capsfileNameSet.isEmpty() && !capsfileNameSet.contains(attachmentObj.File_Name__c) && attachmentObj.CH_Uploaded__c <= system.today()-CAPS_ConstantHandler.SPECIFICTIMEFORONHOLD){
			if(!attachmentObj.CH_NoSuchFileinCAPS__c || !CAPS_ConstantHandler.ONHOLD.equalsignorecase(attachmentObj.CH_Status__c)){
				CH_Attachment__c chattachObj =new CH_Attachment__c();
				chattachObj.Id = attachmentObj.id;
				chattachObj.CH_Status__c =CAPS_ConstantHandler.ONHOLD;
				chattachObj.CH_NoSuchFileinCAPS__c = true;
				updatelist.add(chattachObj);
			}
		}
	}
			}  
			if(!updatelist.isEmpty()){
	Database.update(updatelist,false);
			}
		}catch(Exception unCaughtException){
	 System.debug('unCaughtExceptions' +  unCaughtExceptions.add(unCaughtException.getMessage()));
		}	
	}	
/******************************************
	* Method Name : execute
	* Created Date: 08/28/2018
	* Created By : TCS
	* Descsription: To know the batch status
	* Parameter: NA
	* Return:
	* Last Modified by: 
	* Last Modified Date: 
	* Description: 
*******************************************/	
	global void finish(Database.BatchableContext bc){
		try{
			datetime currentDateTime = system.now().addMinutes(CAPS_ConstantHandler.STATUS_UPDATEBATCH_FREQ);
			String day = string.valueOf(currentDateTime.day());
			String month = string.valueOf(currentDateTime.month());
			String hour = string.valueOf(currentDateTime.hour());
			String minute = string.valueOf(currentDateTime.minute());
			String second = string.valueOf(currentDateTime.second());
			String year = string.valueOf(currentDateTime.year());
			String strScheduleTime = second +CAPS_ConstantHandler.EMPTY_WHITESPACE+ minute + CAPS_ConstantHandler.EMPTY_WHITESPACE + hour + CAPS_ConstantHandler.EMPTY_WHITESPACE + day + CAPS_ConstantHandler.EMPTY_WHITESPACE + month + ' ?' + CAPS_ConstantHandler.EMPTY_WHITESPACE + year;
			if(!Test.isRunningTest() && CAPS_ConstantHandler.YESSTRING.equalsignorecase(Label.CAPS_HaveSubseQuentSchedule)){System.schedule(CAPS_ConstantHandler.JOBNAME+strScheduleTime, strScheduleTime, new Scheduler_CAPSStatusUpdateBatch());}
			if(!String.isBlank(cronId)){System.abortJob(cronId);}
		}catch(Exception ex){system.debug('Exception at finish'+ex.getMessage());}   
	}	
}