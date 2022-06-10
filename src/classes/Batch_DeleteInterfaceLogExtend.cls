global class Batch_DeleteInterfaceLogExtend implements Database.Batchable<sObject>, Database.Stateful{
	global  String CustSettingName = 'Delete Interface Log';
	global  String MailToList;
	global  String ErrorMsg;
	global  String Querystatement;
	global Integer count;
	global Integer ProcessedBatch;
	global Batch_DeleteInterfaceLogExtend(){
			String query;
			String query_where;
			String StartDate;
			String EndDate;
			query = 'select Id,CreatedDate From Interface_Log__c';
			List<Delete_Interface_Log_Extend__c> ddilList = [Select Id, Start_Date__c,ActiveStartEndDate__c,End_Date__c ,DaysBefore__c ,SQL_Limit__c,ToEmail__c,Additional_Query__c,Count__c,ProcessedBatch__c
												 From Delete_Interface_Log_Extend__c Where Active__c=true];
			if(ddilList.size()==1){
			Delete_Interface_Log_Extend__c ddil=ddilList.get(0); 
			MailToList=ddil.ToEmail__c;
			count = (Integer)ddil.Count__c;
			ProcessedBatch=(Integer)ddil.ProcessedBatch__c;	

			if(ddil.ActiveStartEndDate__c){
			if(ddil.Start_Date__c !=null && ddil.End_Date__c !=null && ddil.Start_Date__c<ddil.End_Date__c){
				StartDate = ddil.Start_Date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
				EndDate = ddil.End_Date__c.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
				query_where = ' Where CreatedDate >= ' + StartDate +' and CreatedDate <= ' + EndDate;	
			}else{
				ErrorMsg='Please make sure the date you input in Custom Setting Date_for_Delete_Interface_Log__c is correct';
				
			}
		}	   
		if(String.isNotEmpty(query_where)) {
			query += query_where;
		}else {
			if(ddil.DaysBefore__c>=0){
				query += ' Where CreatedDate < last_n_days:'+ddil.DaysBefore__c;   
			}else{
				ErrorMsg='Please input Date/Time';
				
			}
			
		}
		if(String.isNotEmpty(ddil.Additional_Query__c)){
			query = query+' '+ddil.Additional_Query__c;
		}
		if(String.isNotEmpty(String.valueOf(ddil.SQL_Limit__c))){
			query += ' limit '+ddil.SQL_Limit__c;	
		}else{
			ErrorMsg='Please input the some value in SQL_Limit__c, 500k would take half an hour';
		}	
		}else{
			ErrorMsg='There is no value in custom setting or there are several active value, please make sure the setting is correct';
			query+=' Limit 1';
		}										 
		system.debug('query@@' + query);
		Querystatement=query;
	}
	global Database.QueryLocator start(Database.BatchableContext BC){
		
		return Database.getQueryLocator(Querystatement);	
	}
	global void execute(Database.BatchableContext bc, List<Interface_Log__c> list_IFLogs) {
		System.debug('====>MSG '+ErrorMsg+'====>SZ '+list_IFLogs.size());
		if(String.isEmpty(ErrorMsg) && list_IFLogs.size() > 0) {
			delete list_IFLogs;
			DataBase.emptyRecycleBin(list_IFLogs);
		} 
	}
	global void finish(Database.BatchableContext BC) {
		AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
			JobItemsProcessed,
			TotalJobItems, CreatedBy.Email,MethodName,ApexClassID
			FROM AsyncApexJob
			WHERE Id = :BC.getJobId()];
		Delete_Interface_Log_Extend__c ddil = [Select Id,Count__c,ProcessedBatch__c
												 From Delete_Interface_Log_Extend__c Where Active__c=true Limit 1];
		//List<AsyncApexJob> jobList=[SELECT Id, NumberOfErrors,ApexClassID from AsyncApexJob where CreatedDate > :Datetime.now().addhours(-12) and ApexClassID =: job.ApexClassId];
		if(String.isEmpty(ErrorMsg) && ProcessedBatch < (count-1) ){ //jobList.size() < count
			ddil.ProcessedBatch__c +=1;
			update ddil;
			Batch_DeleteInterfaceLogExtend newone = new Batch_DeleteInterfaceLogExtend();
			database.executeBatch(newone,200);

		}else{
			ddil.ProcessedBatch__c = 0;
			update ddil;
				Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
				message.optOutPolicy = 'FILTER';
				message.subject = 'Interface Log data clean up';
				if(String.isNotEmpty(ErrorMsg)){
					message.plainTextBody =  ErrorMsg;
				if(ErrorMsg.contains('no value in custom setting')){
					MailToList='keith.siler@nokia.com';	
				}
			
				}else{
			message.plainTextBody = 'The job has been executed with job ID '+job.Id +' and Status is '+job.Status +' Error :'+job.NumberOfErrors +' Count:'+count; 
			}
			message.toAddresses = MailToList.split(',');
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