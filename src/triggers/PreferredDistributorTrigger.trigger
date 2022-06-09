trigger PreferredDistributorTrigger on junction__c (After Delete) {

 if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
  if(Trigger.isAfter){		
		  if(Trigger.isDelete){ 
		   PreferredDistributorHelper.updateDeleteFLag(trigger.old);  
			 
		  }
	}			
 
 }
}