/*************************************************************************************************
* Class Name : CAPS_Attachment_Delete
* Created Date: 27 June 2018
* Created By : TCS
* Description: Invoke CAPS system to update retention days on case closure.
Invoke CAPS system to update retention days when user wants to delete any attachment 
* Last Modified by: 
* Last Modified Date: 
* Description : 
*************************************************************************************************/
global class CAPS_Attachment_Delete{
	//private static final string BASE_URL = CAPS_ConstantHandler.BASE_URL //'https://capsv.nokia.com';//keep it configurable
	private static final string DECODED_SIGNATUREKEY =  DecodeEncodeUtility.decodeValues(CAPS_ConstantHandler.SIGNATURE_KEYID2);
	
	/*********************************************************************
*Description: Calling this method to invoke CAPS system to delete attachment from CAPS
*Author:	TCS
*Date:	  27-JUNE-2018
*Method Name: updateRetentionDaysforLightning
*Parameter: <List of CAPS attachment id>, <Boolean value if attachment is sensitive or non sensitive>
*Return: None
*********************************************************************/
	public static void updateRetentionDaysforLightning(Set<String> chAttachmentIdSet, Boolean isSensitive){
		try{	
			Decimal numberOfRecords = chAttachmentIdSet.size();
			Integer recordInEachJob = CAPS_ConstantHandler.ATTACHMENT_NUMBER_DEL_MANUAL;
			Integer numberOfIterationofJobs = integer.valueof((numberOfRecords/recordInEachJob)+1);
			CAPS_AttachmentManualDeleteQueueable job = new CAPS_AttachmentManualDeleteQueueable(chAttachmentIdSet, isSensitive);
			job.maximum = numberOfIterationofJobs;
			System.enqueueJob(job);
		}catch(Exception ex){ExceptionHandler.addException(ex,CAPS_ConstantHandler.cAPSAttachmentDelete,CAPS_ConstantHandler.updateRetentionDaysforLightning);}
	}
	/*********************************************************************
	*Description: Calling this method to invoke CAPS system to update fields attachment from CAPS
	*Author:	TCS
	*Date:	  27-JUNE-2018
	*Method Name: updateAllFieldsforTrigger
	*Parameter:String chAttachmentIdSet1,String userMapSerialized for getting updated fields and update these fields in caps system
	*Return: None
	*********************************************************************/   
	//@future(callout = true)//calling from trigger. So to support added in future context
	public static void updateAllFieldsforTrigger(String attahmentIdVsToBeDeletedMapStr,String attachIDVsMapOfUpdateFieldsMapStr,String attachmentidvsDate){
		try{
			Map<String,Boolean> attahmentIdVsToBeDeletedMap = new Map<String,Boolean>();
			Map<String, Map<String,String>> attachIDVsMapOfUpdateFieldsMap = new Map<String, Map<String,String>>();
			Map<String,String> attachmentIdVsDateMap = new Map<String,String>(); /*For deletion Date*/
			if(!String.isBlank(attahmentIdVsToBeDeletedMapStr)){attahmentIdVsToBeDeletedMap =(Map<String,Boolean>)JSON.deserialize(attahmentIdVsToBeDeletedMapStr, Map<String,Boolean>.class);}
			//map of attachmentid vs it's parameter to be updated
			if(!String.isBlank(attachIDVsMapOfUpdateFieldsMapStr)){attachIDVsMapOfUpdateFieldsMap = (Map<String, Map<String,String>>)JSON.deserialize(attachIDVsMapOfUpdateFieldsMapStr, Map<String, Map<String,String>>.class);}
			//map of attachmentid vs it's parameter to be updated
			if(!String.isBlank(attachmentidvsDate)){attachmentIdVsDateMap = (Map<String,String>)JSON.deserialize(attachmentidvsDate, Map<String,String>.class);}
			if(!attachIDVsMapOfUpdateFieldsMap.isEmpty()){
	Decimal numberOfRecords = attachIDVsMapOfUpdateFieldsMap.keySet().size();
	Integer recordInEachJob = CAPS_ConstantHandler.ATTACHMENT_NUMBER_DEL_AUTO;
	Integer numberOfIterationofJobs = integer.valueof((numberOfRecords/recordInEachJob)+1);
	CAPS_AttachmentDelOnCloseCancelQueue job = new CAPS_AttachmentDelOnCloseCancelQueue(attahmentIdVsToBeDeletedMap, attachIDVsMapOfUpdateFieldsMap, attachmentIdVsDateMap);
	job.maximum = numberOfIterationofJobs;
	if(!Test.isRunningTest()){System.enqueueJob(job);}
			}
		}catch(Exception ex){ExceptionHandler.addException(ex,CAPS_ConstantHandler.cAPSAttachmentDelete,CAPS_ConstantHandler.updateAllFieldsforTrigger);}
	}
	/*********************************************************************
	*Method Name: cAPSVclassification
	*Author:	TCS
	*Date: 19-Aug-2018
	*Description: Get nct Classification Id
	*Parameter : String
	*Return: String
	*********************************************************************/
	public static string cAPSVclassification(string classification){
		String nctclassificationId;
		if(classification == 'Service Provider End User Information'){
			nctclassificationId = '1'; 
		}else if(classification == 'Other Sensitive Information'){
			nctclassificationId = '3'; 
		}else if(classification == 'Other Information'){
			nctclassificationId = '4'; 
		}
		return nctclassificationId;
	}
	
}