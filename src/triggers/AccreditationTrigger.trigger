/****************************************
* Trigger Name : AccreditationTrigger 
* Created Date: July 2018
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 
* Description : All AccreditationTrigger Related Actions will be tracked here
*****************************************/
trigger AccreditationTrigger on Accreditation__c (before update, after update , before insert) {
	
	try{
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
			if(Trigger.isAfter){
	if(Trigger.isUpdate){
		AccreditationHandler.afterUpdateOperation(Trigger.new, Trigger.oldMap);
		
		AccreditationHandler.afterUpdateNeedsRepriceCheck(Trigger.newMap, Trigger.oldMap);
		
		List<Accreditation__c> validaccreList = new List<Accreditation__c>();
		
		if(Nokia_CPQ_Constants.AccredAfterTriggerExecute .equalsignoreCase(Nokia_CPQ_Constants.FALSE_CONSTANT)){
			
			Nokia_CPQ_Constants.AccredAfterTriggerExecute =Nokia_CPQ_Constants.TRUE_STRING;
			for(Accreditation__c accre : Trigger.new){
				if(Trigger.oldMap.get(accre.Id) != null && Trigger.newMap.get(accre.Id) != null && ((Trigger.oldMap.get(accre.Id).Accreditation_Level__c != Trigger.newMap.get(accre.Id).Accreditation_Level__c && String.isBlank(Trigger.newMap.get(accre.Id).pricing_level_override__C)) || Trigger.oldMap.get(accre.Id).Pricing_Accreditation__c != Trigger.newMap.get(accre.Id).Pricing_Accreditation__c)){
		validaccreList.add(accre);
				}
			}
			
			if(!validaccreList.isEmpty()){
				AccreditationTriggerHelper.sendChatter(validaccreList);
			}	 
		}	
	}
			}
			
			if(Trigger.isBefore){
	if(Trigger.isInsert){
		AccreditationTriggerHelper.updateAccreditaion(Trigger.New);
		AccreditationTriggerHelper.populateIncotermOnAccreditaion(Trigger.New); 
		AccreditationTriggerHelper.displayOnPartnerPortal(Trigger.New, Trigger.OldMap);
					AccreditationTriggerHelper.getTierDiscountDetail(Trigger.New);
	}
	if(Trigger.isUpdate){
		AccreditationTriggerHelper.displayOnPartnerPortal(Trigger.New, Trigger.OldMap);
					AccreditationTriggerHelper.getTierDiscountDetail(Trigger.New);
	}
			}
		}
	}
	
	catch(Exception e)
	{
		ExceptionHandler.addException(e,Nokia_CPQ_Constants.ACCR_TRIGGER_NAME,Nokia_CPQ_Constants.ERROR_MSD);
	}	
}