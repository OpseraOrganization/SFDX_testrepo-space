/*************************************************************************************************
* Class Name : CAPS_AttachmentDelOnCloseCancelQueue
* Created Date: 24 October 2019
* Created By : TCS
* Description: Queueable class to delete attachment manually. This is written in queueable to handle more than 100 http call out. 
* Last Modified by: 
* Last Modified Date: 
* Description : 
*************************************************************************************************/
public class CAPS_AttachmentDelOnCloseCancelQueue implements Queueable, Database.AllowsCallouts{
	
	private static final string DECODED_SIGNATUREKEY =  DecodeEncodeUtility.decodeValues(CAPS_ConstantHandler.SIGNATURE_KEYID2);
	public Integer maximum;
	private Integer counter = 1;
	
	public Map<String,Boolean> attahmentIdVsToBeDeletedMap {get; set;}
	public Map<String, Map<String,String>> attachIDVsMapOfUpdateFieldsMap {get; set;}
	public Map<String,String> attachmentIdVsDateMap {get; set;}
	/*************************************************************************************************
	* Constructor : CAPS_AttachmentDelOnCloseCancelQueue
	* Created Date: 24 October 2019
	* Created By : TCS
	* Description:  Parameters: Map<String,Boolean>, Map<String, Map<String,String>>,Map<String,String>
	* Last Modified by: 
	* Last Modified Date: 
	* Description : 
	*************************************************************************************************/
	public CAPS_AttachmentDelOnCloseCancelQueue(Map<String,Boolean> attahmentIdVsToBeDeletedMap, Map<String, Map<String,String>> attachIDVsMapOfUpdateFieldsMap,Map<String,String> attachmentIdVsDateMap){
		this.attahmentIdVsToBeDeletedMap = attahmentIdVsToBeDeletedMap;
		this.attachIDVsMapOfUpdateFieldsMap = attachIDVsMapOfUpdateFieldsMap;
		this.attachmentIdVsDateMap = attachmentIdVsDateMap;
	}
	/*********************************************************************
	*Description: Calling this method to invoke CAPS system to delete attachment from CAPS
	*Author:	TCS
	*Date:	  24 October 2019
	*Method Name: execute
	*********************************************************************/
	public void execute(QueueableContext context) {
		Set<String> deleteCAPSAttachmentIdSet = new Set<String>();
		Integer iterateStarts = CAPS_ConstantHandler.ATTACHMENT_NUMBER_DEL_AUTO*counter - CAPS_ConstantHandler.ATTACHMENT_NUMBER_DEL_AUTO;
		Integer iterateEnds = CAPS_ConstantHandler.ATTACHMENT_NUMBER_DEL_AUTO*counter;
		Integer setSize = attachIDVsMapOfUpdateFieldsMap.keySet().size();
		
		List<String> attachmentIdList = new List<String>();
		//if(!attachIDVsMapOfUpdateFieldsMap.isEmpty()){
		//for(String attachmentId: attachIDVsMapOfUpdateFieldsMap.keySet()){
		for(Integer i=iterateStarts; i<iterateEnds; i++){//invoke CAPS system for each attachment.
			if(i <= setSize-1){
				string attachmentId = (new list<string>(attachIDVsMapOfUpdateFieldsMap.keySet()) )[i];
				String url = '';
				url = CAPS_ConstantHandler.SYSTEM_URL + attachmentId;// add attachment with url for end point and signature
				CAPS_Attachment_Util attachmentUtil = new CAPS_Attachment_Util();
				HttpRequest req = new HttpRequest();
				req = attachmentUtil.createRequest( CAPS_ConstantHandler.BASE_URL , url, CAPS_ConstantHandler.PUT_METHOD, 
												   CAPS_ConstantHandler.CAPS_ENDUSER,  DECODED_SIGNATUREKEY );
				//Start creating JSON Request body
				JSONGenerator gen = JSON.createGenerator(true);
				gen.writeStartObject(); 
				for(String innerKey : attachIDVsMapOfUpdateFieldsMap.get(attachmentId).keySet()){
					if(!String.isBlank(innerKey)){
						/*commenting as CAPS does not support
						if(innerKey == CAPS_ConstantHandler.PRODUCTID && !String.isBlank(attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey)))
						{
							gen.writeFieldName(CAPS_ConstantHandler.PRODUCT);
							gen.writeStartObject();
							gen.writeStringField(CAPS_ConstantHandler.ID_CDB, attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey)); //'133-047489_00' //'833-022515_00'
							gen.writeEndObject(); 
						}
						if(innerKey == CAPS_ConstantHandler.SECURITYGROUP && !String.isBlank(attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey)))
						{
							gen.writeStringField(CAPS_ConstantHandler.SF_SECURITY_GROUPS, attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey));
						}
						if(innerKey == CAPS_ConstantHandler.PRODUCTVERSIONID && !String.isBlank(attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey)))
						{   
							//if(Label.ExecuteProductionVersion == 'Yes'){//once product release field is correctly set this needs to be modified 
								gen.writeFieldName(CAPS_ConstantHandler.PRODUCTVERSION);
								gen.writeStartObject();
								gen.writeStringField(CAPS_ConstantHandler.ID_CDB, attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey));		  //'833-022516_00'//if null do not create 
								gen.writeEndObject();
							//}
						}
						if(innerKey == CAPS_ConstantHandler.CLASSIFICATION && !String.isBlank(attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey)))
						{
							String nctclassificationId = cAPSVclassification(attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey));
							gen.writeStringField('nctclassification', nctclassificationId);
						}commenting as CAPS does not support*/
						if(innerKey == CAPS_ConstantHandler.description && !String.isBlank(attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey)))
						{   
							gen.writeStringField('description',attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey));
						}
						/*commenting as CAPS does not support
						if(innerKey == CAPS_ConstantHandler.customervisible && !String.isBlank(attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey)))
						{   
							gen.writeBooleanField('customer_visible', Boolean.valueOf(attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey)));
						}
						if(innerKey == CAPS_ConstantHandler.TICKETID && !String.isBlank(attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey)))
						{
							gen.writeFieldName('ticket'); 
							gen.writeStartObject();
							gen.writeStringField('app_name', Label.CAPS_AppName);
							gen.writeStringField('ticket_id', attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey));
							gen.writeEndObject();
						}commenting as CAPS does not support*/
						if(innerKey == CAPS_ConstantHandler.CASESTATUS && !String.isBlank(attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey)))
						{
							if(attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey) == CAPS_ConstantHandler.CLOSED_STATUS || 
							   attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey) == CAPS_ConstantHandler.CANCELLED_STATUS){
								   gen.writeStringField('sf_case_status','closed');
							   }
							if(!attahmentIdVsToBeDeletedMap.isEmpty() && attahmentIdVsToBeDeletedMap.get(attachmentId) != null){//attachmentIdVsDateMap
								gen.writeNumberField(CAPS_ConstantHandler.RETENTION_DAYS, Integer.valueOf(attachmentIdVsDateMap.get(attachmentId)));
							   //gen.writeNumberField(CAPS_ConstantHandler.RETENTION_DAYS, CAPS_ConstantHandler.RETENTION_DAYS_1);// set retention days for immediate deletion
							}
							//else if(!attahmentIdVsToBeDeletedMap.isEmpty() && attahmentIdVsToBeDeletedMap.get(attachmentId) != null && !attahmentIdVsToBeDeletedMap.get(attachmentId)){
								//gen.writeNumberField(CAPS_ConstantHandler.RETENTION_DAYS, Integer.valueOf(attachmentIdVsDateMap.get(attachmentId)));// set retention days for deletion after 2 years
								//gen.writeNumberField(CAPS_ConstantHandler.RETENTION_DAYS, CAPS_ConstantHandler.RETENTION_DAYS_730);// set retention days for deletion after 2 years
							//}
						}
						/*commenting as CAPS does not support
						if(innerKey == CAPS_ConstantHandler.CDBCUSTOMERID && !String.isBlank(attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey)))
						{
							gen.writeFieldName('customer');
							gen.writeStartObject(); 
							gen.writeStringField(CAPS_ConstantHandler.ID_CDB, attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey)); 
							gen.writeEndObject();
						}else if(innerKey == CAPS_ConstantHandler.referentialId && !String.isBlank(attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey))){
							gen.writeFieldName('customer');
							gen.writeStartObject();	
							gen.writeStringField(CAPS_ConstantHandler.ID_CDB, attachIDVsMapOfUpdateFieldsMap.get(attachmentId).get(innerKey)); 
							gen.writeEndObject();
						}commenting as CAPS does not support*/
					}
				}
				gen.writeEndObject();
				String jsonString = gen.getAsString();
				//End creating JSON Request body
				req.setBody(jsonString);
				Http http = new Http();
				HTTPResponse res = http.send(req);
				if((res.getStatusCode() == CAPS_ConstantHandler.REQUEST_STATUS_200) && !attahmentIdVsToBeDeletedMap.isEmpty() && attahmentIdVsToBeDeletedMap.get(attachmentId) != null){
					//attachmentidvsdays.put(attachmentId,attachmentIdVsDateMap.get(attachmentId));
					deleteCAPSAttachmentIdSet.add(attachmentId);
				}
			}
		}
		List<CH_Attachment__c> attachmentTobeUpdated = new List<CH_Attachment__c>(); 
		if(!deleteCAPSAttachmentIdSet.isEmpty()){
		   for(CH_Attachment__c updateAttach : 
				[SELECT Id, CH_Status__c,AttachmentID__c
				 FROM CH_Attachment__c 
				 WHERE AttachmentID__c 
				 IN : deleteCAPSAttachmentIdSet 
				 LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
				
			   //get SFDC CH_Attachment records and update status 
				updateAttach.CH_MarkForDelete__c =True;
				if(attahmentIdVsToBeDeletedMap.get(updateAttach.AttachmentID__c)){
					updateAttach.CH_Expected_Delete_Date__c = System.today()+  CAPS_ConstantHandler.RETENTION_DAYS_1;
				}
				else{
					updateAttach.CH_Expected_Delete_Date__c = System.today()+ CAPS_ConstantHandler.RETENTION_DAYS_730;
				}
				attachmentTobeUpdated.add(updateAttach);
			}
			Database.update(attachmentTobeUpdated,false);
		}
		
		 // Chain this job to next job by submitting the next job
		CAPS_AttachmentDelOnCloseCancelQueue job = new CAPS_AttachmentDelOnCloseCancelQueue(attahmentIdVsToBeDeletedMap, attachIDVsMapOfUpdateFieldsMap, attachmentIdVsDateMap);
		job.maximum = maximum;
		job.counter = counter+1;		 
		if(maximum >=job.counter){
			if(!Test.isRunningTest()){System.enqueueJob(job);}
		}
	}
}