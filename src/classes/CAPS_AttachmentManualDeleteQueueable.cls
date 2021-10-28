/*************************************************************************************************
* Class Name : CAPS_AttachmentManualDeleteQueueable
* Created Date: 24 October 2019
* Created By : TCS
* Description: Queueable class to delete attachment manually. This is written in queueable to handle more than 100 http call out. 
* Last Modified by: 
* Last Modified Date: 
* Description : 
*************************************************************************************************/
public class CAPS_AttachmentManualDeleteQueueable implements Queueable, Database.AllowsCallouts{
	
	private static final string DECODED_SIGNATUREKEY =  DecodeEncodeUtility.decodeValues(CAPS_ConstantHandler.SIGNATURE_KEYID2);
	public Integer maximum;
	private Integer counter = 1;
	
	public Set<String> chAttachmentIdSet {get; set;}
	public Boolean isSensitive {get; set;}
	/*************************************************************************************************
	* Constructor : CAPS_AttachmentManualDeleteQueueable
	* Created Date: 24 October 2019
	* Created By : TCS
	* Description:  Parameters: Set<String>, Boolean
	* Last Modified by: 
	* Last Modified Date: 
	* Description : 
	*************************************************************************************************/
	public CAPS_AttachmentManualDeleteQueueable(Set<String> chAttachmentIdSet, Boolean isSensitive){
		this.chAttachmentIdSet = chAttachmentIdSet;
		this.isSensitive = isSensitive;
	}
	/*********************************************************************
	*Description: Calling this method to invoke CAPS system to delete attachment from CAPS
	*Author:	TCS
	*Date:	  24 October 2019
	*Method Name: execute
	*********************************************************************/
	public void execute(QueueableContext context) {
		List<String> attachmentIdList = new List<String>();
		DateTime currentTime = DateTime.now();
		string nowFormatted = currentTime.formatGMT(CAPS_ConstantHandler.DATE_FORMAT);
		CAPS_Attachment_Util attachmentUtil = new CAPS_Attachment_Util();
		Integer iterateStarts = CAPS_ConstantHandler.ATTACHMENT_NUMBER_DEL_MANUAL*counter - CAPS_ConstantHandler.ATTACHMENT_NUMBER_DEL_MANUAL;
		Integer iterateEnds = CAPS_ConstantHandler.ATTACHMENT_NUMBER_DEL_MANUAL*counter;
		Integer setSize = chAttachmentIdSet.size();
		
		//for(String attachmentId : chAttachmentIdSet){
		for(Integer i=iterateStarts; i<iterateEnds; i++){//invoke CAPS system for each attachment.
			if(i <= setSize-1){
	string attchmntid = (new list<string>(chAttachmentIdSet) )[i];
	HttpRequest req = new HttpRequest();
	String url = '';
	url = CAPS_ConstantHandler.SYSTEM_URL + attchmntid;// add attachment with url for end point and signature
	req = attachmentUtil.createRequest( CAPS_ConstantHandler.BASE_URL , url, CAPS_ConstantHandler.PUT_METHOD, 
			   CAPS_ConstantHandler.CAPS_ENDUSER,  DECODED_SIGNATUREKEY);
	//Start creating JSON Request body
	JSONGenerator gen = JSON.createGenerator(true);
	gen.writeStartObject();		
	gen.writeNumberField(CAPS_ConstantHandler.RETENTION_DAYS, CAPS_ConstantHandler.RETENTION_DAYS_1);
	gen.writeEndObject();
	String jsonString = gen.getAsString();
	//End creating JSON Request body
	req.setBody(jsonString);
	Http http = new Http();
	HTTPResponse res = http.send(req);
	if(res.getStatusCode() == CAPS_ConstantHandler.REQUEST_STATUS_200){
		attachmentIdList.add(attchmntid);//get list of success attachment id in list, query and update.
	}
			}
		}
		List<CH_Attachment__c> attachmentTobeUpdated = new List<CH_Attachment__c>();
		if(!attachmentIdList.isEmpty()){
			for(CH_Attachment__c updateAttach : 
	[SELECT Id, CH_Status__c 
	 FROM CH_Attachment__c 
	 WHERE AttachmentID__c 
	 IN : attachmentIdList 
	 LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())])
			{
	//get SFDC CH_Attachment records and update status
	  updateAttach.CH_MarkForDelete__c =True;
	  updateAttach.CH_Expected_Delete_Date__c=System.today()+CAPS_ConstantHandler.RETENTION_DAYS_1;
	  attachmentTobeUpdated.add(updateAttach);			
			}
			Database.update(attachmentTobeUpdated,false);
		} 
		 // Chain this job to next job by submitting the next job
		CAPS_AttachmentManualDeleteQueueable job = new CAPS_AttachmentManualDeleteQueueable(chAttachmentIdSet, isSensitive);
		job.maximum = maximum;
		job.counter = counter+1;		 
		 if(maximum >=job.counter){
			if(!Test.isRunningTest()){System.enqueueJob(job);}
		 }
	 }
}