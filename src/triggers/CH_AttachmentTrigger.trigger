/****************************************
 * Trigger Name : CH_AttachmentTrigger
 * Created Date: 8 Aug 2018
 * Created By : TCS
 * Last Modified by: 
 * Last Modified Date: 9 Aug 2018
 * Description : All CH_Attachments Related Actions will be tracked here
 * Last Modified by: TCS
 * Last Modified Date: 
 * Description :
 *****************************************/
trigger CH_AttachmentTrigger on CH_Attachment__c (After update,After insert) {  
	String isActive = CH_Settings__c.getValues(CAPS_ConstantHandler.ENABLECHATTACHMENTTRIGGER) != null ? CH_Settings__c.getValues(CAPS_ConstantHandler.ENABLECHATTACHMENTTRIGGER).SettingValue__c :CAPS_ConstantHandler.EMPTYSTRING;
	boolean disbaleTrigger = CH_DisableCH_AttachmentTrigger__c.getInstance().CH_Disable__c;//added 25676
	if(isActive == CAPS_ConstantHandler.YESVALUE && !disbaleTrigger){
		if(Trigger.isAfter) {
			if(Trigger.isUpdate) {
			 CH_AttachmentsTriggerHandler.updateAttchmentinCAPS(Trigger.new,Trigger.oldMap);
			 CH_AttachmentsTriggerHandler.sendAttachmentIdForReadyStatus(Trigger.new,Trigger.oldMap);
			}
		}
		if(Trigger.isAfter) {
			if(Trigger.isInsert) {
				CH_AttachmentsTriggerHandler.addAttachmentComment(Trigger.new);
			}
		}
	}
}