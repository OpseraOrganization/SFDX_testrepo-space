public class ConfiFileTriggerHandler
{
	public static void beforeDelete(List<Confidential_File__c > lstFileOldList)
	{
	 if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) )
	 {
		 for(Confidential_File__c oConfiFile: lstFileOldList)
		 {
			oConfiFile.adderror(label.File_Deletion_Error);
		 }
	 }
	}   
}