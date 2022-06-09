public class TaskCreationHandler{
	
	Private static Boolean executeTigger = true;

	
	public static void beforeInsert(List<Task> newTaskRecList){
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && !System.isBatch()){
			System.debug('&&& Inside Handler Method');
			TaskCreationHelper.taskCreationAllowed(newTaskRecList);
		} 
	}
	public static void beforeDelete(List<Task> newTaskRecList){
		Id profileId=userinfo.getProfileId();
		String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
		if((!profileName.equalsIgnoreCase(GlobalConstants.DATA_LOADER_PROFILE))&&(!profileName.equalsIgnoreCase(GlobalConstants.GLOBAL_PROCESS_ADMIN_PROFILE))&&(!profileName.equalsIgnoreCase(GlobalConstants.SYSTEM_AdMINISTRATOR))&&(!profileName.equalsIgnoreCase(GlobalConstants.NOKIA_ADMIN_PROFILE)) )
		{
			TaskCreationHelper.DeletionNotAllowed(newTaskRecList);
		}
	}
	
	public static void afterInsert(List<Task> newTaskRecList){
		TaskCreationHelper.blockIWATaskCreation(newTaskRecList);
	}
	
	public static Boolean getExecuteTrigger(){
		return executeTigger;
	}
	
	public static void setExecuteTrigger(Boolean doIt){
		executeTigger=doIt;
	}
	
	
}