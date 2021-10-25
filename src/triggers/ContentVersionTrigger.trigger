trigger ContentVersionTrigger on ContentVersion (After insert, After Update,Before update,before insert)
{
	 if(!LeadConevrtDocHandler.isLeadConversion){
	 if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) &&
		!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Excel_Add_In_Profile_SF_Id))
	{
		if(Trigger.isAfter)
		{
			if(Trigger.isInsert)
			{
			System.debug('inside after insert--->');
				ContentVersionHandlerPRM.restrictNewVersionUpload(Trigger.new[0]); 
				ContentVersionHandlerPRM.restrictNewVersionUploadOnClaim(Trigger.new[0]);
				DS_ContentVersionHandler.restrictNewVersion(Trigger.new);
				ContentVersionHandler.afterInsert(Trigger.New); 
			}
		}
		else if(Trigger.isBefore)
		{
			   if(Trigger.isInsert){
				   DS_ContentVersionHandler.updateDocTypeforQuoteFiles(Trigger.new);
			   }
			 if(Trigger.isUpdate)
			 {
				DS_ContentVersionHandler.restrictFileDetails(Trigger.new);
			 }
		}
		else
		{
			System.debug('ContentVersionTrigger: skipping trigger profile is Data Loader or Excel Add-In');
		}
	}
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) )
	{
		if(Trigger.isAfter)
		{
			if(Trigger.isUpdate)
			{
			   ContentVersionHandler.afterUpdate(Trigger.New,Trigger.Oldmap);
			   
			}
		}
	}
	}
}