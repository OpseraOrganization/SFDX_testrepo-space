/**
* @description: A Batch class for Deleting interface Logs. This supports removing interface log which created time before x months

* @author:	SDC Fitch
*
* ============================================================================
* History:
* -------
* 
* VERSION AUTHOR		  DATE		DETAIL										  FEATURES/CSR/TTP
* 1.0				   1/12/2017	 
* ============================================================================ 
*/
global class Scheduler_BatchInterfaceLogDelete implements Schedulable{
	global void execute(SchedulableContext ctx) {
		IFMaintainanceCheck__c IFMC = [Select hasBackup__c from IFMaintainanceCheck__c WHERE Name='HasBackup' Limit 1];
		System.debug('===>'+IFMC.hasBackup__c);
		if(IFMC.hasBackup__c){
			DeleteInterfaceLog dil=new DeleteInterfaceLog();
			Database.executeBatch(dil); 
		}else{
			Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
			String address = Label.DeleteIFReceiver;
			message.toAddresses = address.split(',');
			message.optOutPolicy = 'FILTER';
			message.subject = 'Failed-Interface Log data clean up';
			message.plainTextBody = 'The job of deleting interface log will not be performed until the data has been backup. If the data has been backup,please change the value of Label DeleteIFCheck to T';
			Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
			if(!Test.isRunningTest()) {
				Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
				if (results[0].success) {
					System.debug('The email was sent successfully.');
				} else {
					System.debug('The email failed to send: ' + results[0].errors[0].message);
				}
			}				
		}
	 	
	}
}