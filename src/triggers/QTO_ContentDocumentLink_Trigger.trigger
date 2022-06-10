/******************************************************************************************************
Name : QTO_ContentDocumentLink_Trigger
Created Date: 14 September 2020
Created by: Bogdan Botcharov
Description : Trigger on ContentDocumentLink - This gets invoked when uploading attachments in LightningUI
*********************************************************************************************************/
trigger QTO_ContentDocumentLink_Trigger on ContentDocumentLink (after insert) {
	
	//Added for HLD600 [DSI-1862] by Bogdan Botcharov
	if(Trigger.isAfter && Trigger.isInsert)
		QTO_ContentDocumentLinkHandler.resetCaseStatus(Trigger.new);

}