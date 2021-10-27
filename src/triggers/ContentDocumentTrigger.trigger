/**
 * @description:DeleteRelatedDocumentRecord_Before apex Trigger. This use to extend the delete file functionality of lightning component.
 *			 class includes class to delete the appropriate record from Document__c object when an excisting file is deleted from file object.
 * @author:	Accenture IDC.
 *
 * ============================================================================
 * History:
 * -------
 * 
 * VERSION AUTHOR		  DATE		DETAIL										  FEATURES/CSR/TTP
 * 1.0				  22/11/2016   Sprint 2 Doc Stretegy & LoA requirements.
 * ============================================================================  
 */
trigger ContentDocumentTrigger on ContentDocument (Before insert, Before delete, After insert, After undelete, After delete) 
{
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) &&
	   !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Excel_Add_In_Profile_SF_Id))
	{
		if(Trigger.isBefore)
		{
			if(Trigger.isDelete)
			{
				ContentDocumentHandler.beforeDelete(Trigger.OldMap);
				ContentDocumentHandlerPRM.restrictDeletion(trigger.Old);
				ContentDocumentHandlerPRM.restrictFileDeleteOnClaim(trigger.Old);
	DS_ContentDocumentTriggerHandler.beforeDelete(trigger.old);
			}
			if(Trigger.isInsert){
		Id profileId = userinfo.getProfileId();
					String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
				for(ContentDocument cont : trigger.New){
					if(profileName == 'Customers' || profileName == 'Customers Login'){
						Trigger.new[0].addError('You dont have access to upload files');
					}
				}
			}
		}
		else if(Trigger.isAfter)
		{
			if(Trigger.isUndelete)
			{
				ContentDocumentHandler.afterUndelete(Trigger.NewMap);
			}
			if(Trigger.isInsert)
			{
			   // ContentDocumentHandler.afterInsert(Trigger.New);
			}
			if(Trigger.isdelete)
			{
				ContentDocumentHandler.afterDelete(Trigger.OldMap);
			}
		}
		else
		{
			System.debug('ContentDocumentTrigger: skipping trigger profile is Data Loader or Excel Add-In');
		}
	}
}