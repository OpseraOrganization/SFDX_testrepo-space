/****************************************
* Trigger Name : CustomerDocumentJunctionTrigger 
* Created Date: 09 July 2019
* Created By : Accenture
* Description : This trigger is for customer document object
***************************************/
trigger CustomerDocumentJunctionTrigger on Customer_Document_Junction__c (After Delete) {
 	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
	if(Trigger.isAfter && Trigger.isDelete){
		CustomerDocumentJunctionTriggerHandler.deleteQuoteProposalAssociation(Trigger.Old);
	}
	}
}