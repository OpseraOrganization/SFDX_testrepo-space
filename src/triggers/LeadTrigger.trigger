/****************************************
 * Trigger Name : LeadTrigger 
 * Created Date: 7 December 2016
 * Created By : Accenture
 * Last Modified by: Avishek Hazra
 * Last Modified Date:  August 2020
 * Description : All Lead Related Actions will be tracked here
 * Description : Updated LeadTriggerHandler.afterUpdateOperation method by oldMap parameter on(August 2020)
 *****************************************/
trigger LeadTrigger on Lead (After Insert,before update ,after update, before insert) {
 
		  
   if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){

   if(Trigger.isBefore){
	  LeadTriggerHandler.beforeOperation(Trigger.new,Trigger.OldMap);
	  if(Trigger.isUpdate){
		 if(PRMGlobalConstants.RUN_LEAD_TRIGGER_ON_LEAD_UPDATE){
		  LeadConversionTriggerHelper.beforeConversion(Trigger.old,Trigger.new);
		 }
	  }
	}
	
	if(Trigger.isAfter){
	  if(Trigger.isUpdate){
		LeadTriggerHandlerPRM.afterUpdateLead(Trigger.newMap);// Us-1220
		
		LeadTriggerHandler.afterUpdateOperation(Trigger.new,Trigger.OldMap);//Updated Oldmap Parameter as part of IBCM43
		 LeadTriggerHandlerPRM.afterUpdate(Trigger.new,Trigger.OldMap);
		
		if(PRMGlobalConstants.RUN_LEAD_TRIGGER_ON_LEAD_UPDATE){
		  LeadConversionTriggerHelper.leadConversion(Trigger.new,Trigger.oldMap);
		  LeadConversionTriggerHelper.afterUpdate(Trigger.oldMap,Trigger.newMap);
		  LeadTriggerHelperPRM.MakeCommentsMandatoryRejectedDeal(Trigger.new, Trigger.old);
		  
		  LeadConversionTriggerHelper.updateDistributorAccount(Trigger.oldMap,Trigger.newMap);
		  PRMGlobalConstants.RUN_LEAD_TRIGGER_ON_LEAD_UPDATE=true;
		}
	  }
	}
	
	if(Trigger.isAfter){
	  if(Trigger.isInsert){
		if(PRMGlobalConstants.RUN_LEAD_TRIGGER_ON_LEAD_UPDATE){
		  LeadConversionTriggerHelper.afterInsert(Trigger.new);
		  LeadConversionTriggerHelper.populateDistributorAccount(Trigger.new);
		}
		LeadTriggerHandler.afterInsertOperation(trigger.new,Trigger.oldMap);
	  }
	}   
  }
  

   
  
}