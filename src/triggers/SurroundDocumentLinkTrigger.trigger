/****************************************
* Trigger Name : SurroundDocumentLinkTrigger 
* Created Date: 2 May 2019
* Created By : Accenture
* Description : This trigger updates suround document  link record with quote/proposal field
***************************************/
trigger SurroundDocumentLinkTrigger on Surround_Document_Links__c (before insert) {
	
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
		if(Trigger.isBefore){
			if(Trigger.isInsert){
				SurroundDocumentLinkHandler.updateCQNameField(Trigger.New);
			}
		}
	}

}