/*
** @author : Apttus
** @date : 06/02/2017
** @description : Trigger on  Apttus_Approval__Backup_Approver__c  object
*/

trigger APTS_ApprovalBackupApproverTrigger on Apttus_Approval__Backup_Approver__c (Before Insert, Before Update){

	if(trigger.IsBefore){
		if(trigger.IsInsert){
			APTS_ApprovalBackupApproverTrigger.BeforeInsert(trigger.New);
		}
		if(trigger.IsUpdate){
			APTS_ApprovalBackupApproverTrigger.BeforeUpdate(trigger.New);		
		}
	}
}