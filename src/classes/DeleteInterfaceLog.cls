/****************************************
 * Class Name : DeleteInterfaceLog
 * Created Date: 27th Nov 2017
 * Created By : SDC
 * Last Modified by: SDC
 * Last Modified Date: 
 * Description : Used to delete old interface log which is not useful.
 * Test Class:DeleteInterfaceLogTest 
 *****************************************/
global class DeleteInterfaceLog implements 
	Database.Batchable<sObject>, Database.Stateful {
	global Integer recordsProcessed = 0;
	global Integer recordsFailToProcessed = 0;
	Integer months=0-Integer.valueof(Label.DeleteIFMonths);	
	String runtime = String.valueOf(Date.today().addMonths(months))+'T00:00:00.000Z';
	String query='SELECT Id,CreatedDate,Comment__c FROM Interface_Log__c WHERE CreatedDate<'+runtime;
	global Database.QueryLocator start(Database.BatchableContext bc) {
		System.debug(query);
		return Database.getQueryLocator(
			query
		);
	}

	global void execute(Database.BatchableContext bc, List<Interface_Log__c> scope){
		// process each batch of records
		Database.DeleteResult[] drList=Database.delete(scope,false);
				for(Database.DeleteResult dr:drList){
					if(dr.isSuccess()==true){
						recordsProcessed= recordsProcessed+1;
					}else{
						recordsFailToProcessed= recordsFailToProcessed+1; 
					}
				}
	}
  

	global void finish(Database.BatchableContext bc){
		System.debug(recordsProcessed + ' records processed.');
		IFMaintainanceCheck__c IFMC = [Select hasBackup__c from IFMaintainanceCheck__c WHERE Name='HasBackup' Limit 1];
		IFMC.hasBackup__c=false;
		update IFMC;
		AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
			JobItemsProcessed,
			TotalJobItems, CreatedBy.Email
			FROM AsyncApexJob
			WHERE Id = :bc.getJobId()];
		Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		String address = Label.DeleteIFReceiver;
		message.toAddresses = address.split(',');
		message.optOutPolicy = 'FILTER';
		message.subject = 'Interface Log data clean up';
		message.plainTextBody = 'The job has been performed with '+recordsProcessed + ' records processed and '+recordsFailToProcessed+' records Fail To Process whose job Id is '+job.Id;
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