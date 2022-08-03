trigger beforeInsertOnAttachment on Attachment (before insert,after insert,before delete) {

System.debug('inside attachement trigger');
/***********************************************
*   Trigger Name : beforeInsertOnAttachment
*   Created By : Accenture IDC
*   Created Date :08/Aug/2017
*   Description : This is trigger on the attachment object
				  
*********************************************/
String accid;
if(Trigger.isBefore && Trigger.isInsert){

	NokiaCPQ_AttachmentHandler.beforeInsert(Trigger.new);
	//Added for HLD600 [DSI-1862] by Bogdan Botcharov 
	QTO_AttachmentTriggerHandler.resetCaseStatus(Trigger.new);
   
  //  system.debug('inside after12' +accid);
}


	if(Trigger.isDelete){
		
		DS_AttachmentHandler.beforeDelete(Trigger.old);
	}

if(Trigger.isAfter && Trigger.isInsert){
	 String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
	string appName = NokiaCPQ_AttachmentHandler.getAppName();
	Boolean isPRM = NokiaCPQ_AttachmentHandler.getIsPRM();
if((isPRM) && (profileName.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PARTNER_PROFILE_NAME)||profileName.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PARTNER_RELATIONSHIP_MANAGER))){
				 NokiaCPQ_AttachmentHandler.shareAccount('Read');
			   }
			} 
}