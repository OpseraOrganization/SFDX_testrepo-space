/****************************************
 * Trigger Name : CertificationTrigger 
 * Created Date: 
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description : 
 *****************************************/
Trigger CertificationTrigger on Certification__c (after update,after Insert,before delete) {
	//Miguel Silva - SFPRM-169 updating accreditation couters on certification delete
	if(Trigger.isBefore){
		if(Trigger.isDelete){
			CertificationTriggerHandler.beforeDeleteOperations(Trigger.old);
		}
	}
	if (Trigger.isAfter){
		if (Trigger.isUpdate){
	 
			// added by supriyam
			CertificationTriggerHandler.afterUpdate(Trigger.oldMap,Trigger.newMap);
			CertificationTriggerHandler.afterUpdateOperations(Trigger.oldMap,Trigger.new);
			
		}
	}
	
	if(Trigger.isAfter){
		if(Trigger.isInsert){
			//added by sneha
			CertificationTriggerHandler.afterInsertCertificateOperation(Trigger.newMap,Trigger.oldMap);  
			// 
	// added by supriyam
			CertificationTriggerHandler.afterInsert(Trigger.newMap, Trigger.new);
		}
	} 
}