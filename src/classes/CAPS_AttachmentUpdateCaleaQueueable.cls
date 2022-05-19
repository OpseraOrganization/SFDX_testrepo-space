/*************************************************************************************************
* Class Name : CAPS_AttachmentUpdateCaleaQueueable
* Test Class : CAPS_AttachmentUpdateCaleaQueueable_Test
* Created Date: 26 July 2021
* Created By : TCS
* Description: Queueable class to update Calea flag in CAPS. 
* US: NOKIASC-37029
*************************************************************************************************/
public class CAPS_AttachmentUpdateCaleaQueueable implements Queueable, Database.AllowsCallouts{
	private static final string DECODED_SIGNATUREKEY =  DecodeEncodeUtility.decodeValues(CAPS_ConstantHandler.SIGNATURE_KEYID2);
	public Integer maximum;
	private Integer counter = 1;
	public Map<String, Boolean> attachmentVsCaleaFlag = new Map<String,Boolean>();
	//Constructor
	public CAPS_AttachmentUpdateCaleaqueueable(Map<String, Boolean> attachmentsMap){
	   this.attachmentVsCaleaFlag = attachmentsMap;
	}
	/*********************************************************************
	*Description: Calling this method to invoke CAPS system to update attachments
	*Author:	TCS
	*Date:	  26 July 2021
	*Method Name: execute
	*********************************************************************/
	public void execute(QueueableContext context) {
		CAPS_Attachment_Util attachmentUtil = new CAPS_Attachment_Util();
		Integer iterateStarts = CAPS_ConstantHandler.ATTACHMENT_NUMBER_DEL_MANUAL*counter - CAPS_ConstantHandler.ATTACHMENT_NUMBER_DEL_MANUAL;
		Integer iterateEnds = CAPS_ConstantHandler.ATTACHMENT_NUMBER_DEL_MANUAL*counter;
		Integer setSize = attachmentVsCaleaFlag.keySet().size();
		for(Integer i=iterateStarts; i<iterateEnds; i++){
			if(i <= setSize-1){
				string attachmentId = (new list<string>(attachmentVsCaleaFlag.keySet()))[i];
				HttpRequest req = new HttpRequest();
				String url = '';
				url = CAPS_ConstantHandler.SYSTEM_URL + attachmentId;// add attachment with url for end point and signature
				System.debug('Request URL=== '+CAPS_ConstantHandler.BASE_URL+url);
				req = attachmentUtil.createRequest( CAPS_ConstantHandler.BASE_URL , url, CAPS_ConstantHandler.PUT_METHOD, 
						   CAPS_ConstantHandler.CAPS_ENDUSER,  DECODED_SIGNATUREKEY);
				JSONGenerator gen = JSON.createGenerator(true);
				gen.writeStartObject();		
				gen.writeBooleanField(CAPS_ConstantHandler.LAWFULINTERCEPT_CALEA, attachmentVsCaleaFlag.get(attachmentId));
				gen.writeEndObject();
				String jsonString = gen.getAsString();
				//End creating JSON Request body
				req.setBody(jsonString);
				System.debug('Request body to be sent=== '+jsonString);
				Http http = new Http();
				HTTPResponse res = http.send(req);
				if(res.getStatusCode() == CAPS_ConstantHandler.REQUEST_STATUS_200){
					//attachment updated ssuccessfully
				}
			}
		}
		 // Chain this job to next job by submitting the next job
		CAPS_AttachmentUpdateCaleaqueueable job = new CAPS_AttachmentUpdateCaleaqueueable(attachmentVsCaleaFlag);
		job.maximum = maximum;
		job.counter = counter+1;		 
		 if(maximum >=job.counter && !Test.isRunningTest()){
			System.enqueueJob(job);
		 }
	}
}