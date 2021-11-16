/*
   @Trigger Name:SupportingMaterialTrigger 
   @Description:Its used for before insert on Supporting Material Trigger
   @Date:29/9/2018 
*/
trigger SupportingMaterialTrigger on File_Upload__c (before insert) {

	If(Trigger.isInsert && Trigger.isBefore){
			 System.debug('In Trigger');
			SupportingMaterialTriggerHandler.beforeInsert(Trigger.New);
	}
}