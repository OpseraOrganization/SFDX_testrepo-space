public without sharing class CH_WorkgroupMember_Trigger_Handler {
	
	// A Case Assignment workgroup member cannot be deleted when it has timeslots assigned
	public void validateBeforeDeletion(List<CH_Workgroup_Member__c> newWorkgroupMembers){
		Id kbRecordTypeId = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByDeveloperName().get('CH_KB_Workgroup_Members').getRecordTypeId();

		// Loop through all the workgroup members but process only the case assignment ones
		for(CH_Workgroup_Member__c newWorkgroupMember: newWorkgroupMembers) {
			// if not a KB workgroup member, thus a case assignment workgroup member and if the workgroup member has timeslot then you cannot delete
			if (newWorkgroupMember.recordTypeId != kbRecordTypeId && newWorkgroupMember.CH_Assigned_To_Timeslots__c > 0){
	
	
		//Ref: NOKIASC-36332 Replaced Error Message With Custom Label
		newWorkgroupMember.AddError(System.Label.CH_Workgroup_Member_With_Time_Slot_Cannot_Be_Removed);
				
			}
		}
	}
	//Method Added For NOKIASC-34961
	// A Case Assignment workgroup member queue cannot be deleted when it has only one queue
	public static void validateQueueBeforeDeletion(List<CH_Workgroup_Member__c> oldWorkgroupMembers,List<CH_Workgroup_Member__c> newWorkgroupMembers,Map<Id,CH_Workgroup_Member__c> oldWorkgroupMembersMap,String operation){
		Id caRecordTypeId = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByDeveloperName().get('CH_CA_WorkgroupMember').getRecordTypeId();
		Set<id> oWorkgroupIds = new Set<id>();
		for (CH_Workgroup_Member__c oldWorkgroupMember : oldWorkgroupMembers){
			oWorkgroupIds.add(oldWorkgroupMember.CH_Workgroup__c);
		}
		Integer oQueueCount = [SELECT Count() From CH_Workgroup_Member__c WHERE CH_Role__c='Queue' AND CH_Workgroup__c in :oWorkgroupIds];
		if(operation=='delete'){
		for (CH_Workgroup_Member__c oldWorkgroupMember : oldWorkgroupMembers){
		//Checks if the user has required permission set or not
		Boolean value = CH_Workgroup_Controller.getValidUser();	
		//If it's a only Case Assignment member queue in workgroup then you cannot delete it
		if(oldWorkgroupMember.RecordTypeId==caRecordTypeId && oQueueCount == 1 && oldWorkgroupMember.CH_Role__c=='Queue' && !value){
			//Ref: NOKIASC-36332 Replaced Error Message With Custom Label	
			oldWorkgroupMember.AddError(System.Label.CH_Workgroup_Member_Queue_Cannot_Be_Removed);		
		}
		}
		}//delete ended
		else if(operation == 'update' && newWorkgroupMembers != null && !newWorkgroupMembers.isEmpty()){
		
	  for (CH_Workgroup_Member__c newWorkgroupMember : newWorkgroupMembers)
		{
			//Get Old workgroup member 
			CH_Workgroup_Member__c oldMember = oldWorkgroupMembersMap.get(newWorkgroupMember.Id);
			//Check if a valid user
			Boolean value = CH_Workgroup_Controller.getValidUser();   
			//Check if Case assignment member is a queue and show error if update to type,name or user is performed
			if((newWorkgroupMember.RecordTypeId == caRecordTypeId && oldMember.CH_Role__c=='Queue' && !value )&&(((newWorkgroupMember.CH_Workgroup_Member_Type__c != oldMember.CH_Workgroup_Member_Type__c || oldMember.Name != newWorkgroupMember.Name ||  oldMember.CH_User__c != newWorkgroupMember.CH_User__c ) && oQueueCount==0)||(((oldMember.Name != newWorkgroupMember.Name ||  oldMember.CH_User__c != newWorkgroupMember.CH_User__c )  && oQueueCount==1)&&newWorkgroupMember.CH_Workgroup_Member_Type__c == 'Queue'))){
			   //Ref: NOKIASC-36332 Replaced Error Message With Custom Label
				newWorkgroupMember.AddError(System.Label.CH_WG_Member_Update_Error);
			}
		}
	 
	}//update ended
	}
}