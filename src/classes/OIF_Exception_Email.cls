/****************************************
 * Class Name : OIF_Exception_Email 
 * Created Date: 19 September 2010
 * Created By : Aakanksha Sharma
 * Last Modified by:  
 * Last Modified Date:  
 * Description : Send email of wrongly processed or failed to process oif records when updating the oif 
 *		value according to exchange rates
 * Test Class: 
 *****************************************/
public class OIF_Exception_Email {
	
	/********************
	*Method Name: sendEmail
	*Parameter: Order_Intake_Forecast__c FailedRecords, Batch jobID, ProcessedRecordsCount, ClassName, 
	Order_Intake_Forecast__c PastPORecords 
	*Description: Used to send email to designated receipients with csv files as attachment which contains 
	failed/non-processed records and records with past po plan updated

	*******************/
   public static void sendEmail(Map<Id, Order_Intake_Forecast__c> failedRecords, String jobID, Integer processedRecords, String className, List<Order_Intake_Forecast__c> pastPeriodUpdated)
   {
	   String header = GlobalConstants.OIF_EXCEPTION_EMAIL_HEADER;
	   String past_header = GlobalConstants.OIF_EXCEPTION_EMAIL_PASTRECORDS_HEADER;
	   String finalstr = header ;
	   String past_str = past_header ;   
	   String mailBody;
	   String mailBody_past = '';
	   String subject ;
	   Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
	   List<Messaging.Emailfileattachment> attcList = new List<Messaging.Emailfileattachment>();
	   if(failedRecords.size()!=0 && failedRecords.size() < 5000)
	   {
			for(Order_Intake_Forecast__c a: failedRecords.values())
			{
				String recordString = '"'+a.id+'","'+a.Name+'","'+a.Opportunity__c+'","'+a.CurrencyIsoCode+'","'+a.OIF_Value__c+'","'+a.OIF_Value_EUR__c+'","'+a.OIF_Value_USD__c+'"\n';
				finalstr = finalstr +recordString;
			}
			
			if(pastPeriodUpdated.size() > 0 )
			{
				for(Order_Intake_Forecast__c a: pastPeriodUpdated)
				{
					String pastRecord = '"'+a.id+'","'+a.Name+'","'+a.Opportunity__c+'","'+
						a.POPlanReceipt__r.Name+'","'+a.CurrencyIsoCode+'","'+a.OIF_Value__c+'"\n';
					past_str = past_str +pastRecord;
				} 
				Messaging.EmailFileAttachment csvAttc_past = new Messaging.EmailFileAttachment();
				blob csvBlob_past = Blob.valueOf(past_str);
				string csvname_past= GlobalConstants.OIF_EXCEPTION_EMAIL_PASTRECORDS_CSVFILENAME;
				csvAttc_past.setFileName(csvname_past);
				csvAttc_past.setBody(csvBlob_past);
				attcList.add(csvAttc_past);
				mailBody_past = GlobalConstants.OIF_EXCEPTION_EMAIL_PASTRECORDS_MAILBODY + pastPeriodUpdated.size() + 
					GlobalConstants.FORWARD_SLASH + processedRecords + GlobalConstants.OIF_EXCEPTION_EMAIL_PASTRECORDS_INSTRUCTIONS;
			}   
			Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
			blob csvBlob = Blob.valueOf(finalstr);
			string csvname= GlobalConstants.OIF_EXCEPTION_EMAIL_FUTUREPOPERIODS_CSVFILENAME;
			csvAttc.setFileName(csvname);
			csvAttc.setBody(csvBlob);
			attcList.add(csvAttc);
		
			mailBody = GlobalConstants.OIF_EXCEPTION_EMAIL_MAILBODY_SALUTATION1  + jobID +GlobalConstants.NEWLINE +
				GlobalConstants.COMPLETED + GlobalConstants.COLON  + system.now() +
				GlobalConstants.OIF_EXCEPTION_EMAIL_MAILBODY_SALUTATION2 + failedRecords.size() + 
				GlobalConstants.FORWARD_SLASH + processedRecords + GlobalConstants.OIF_EXCEPTION_EMAIL_MAILBODY_INSTRUCTION;
			
		   if(mailBody_past.length()>0)
				mailBody += mailBody_past ;
			
			mailBody += GlobalConstants.OIF_EXCEPTION_EMAIL_SIGNATURE;
		
			email.setPlainTextBody(mailBody);
			system.debug('mailBody'+mailBody);
		
			email.setFileAttachments(attcList);
			subject = GlobalConstants.OIF_EXCEPTION_EMAIL_SUBJECT + className + GlobalConstants.COMPLETED_ON+ system.now();
	   }
	   else if (failedRecords.size() > 5000)
	   {
			mailBody = GlobalConstants.OIF_EXCEPTION_EMAIL_FILETOOLARGE_MESSAGE1+ GlobalConstants.BATCH_ID  + 
				jobID + GlobalConstants.NEWLINE + GlobalConstants.COMPLETED + system.now() + 
				GlobalConstants.OIF_EXCEPTION_EMAIL_FILETOOLARGE_MESSAGE2 + failedRecords.size() + '/' + processedRecords +
				GlobalConstants.OIF_EXCEPTION_EMAIL_FILETOOLARGE_MESSAGE_INSTRUCTION;
			email.setPlainTextBody(mailBody);
			subject = GlobalConstants.OIF_EXCEPTION_EMAIL_FILETOOLARGE_SUBJECT + className + GlobalConstants.COMPLETED_ON + system.now();	 
	   }
	   else if(failedRecords.size() == 0 && pastPeriodUpdated.size() == 0)   
	   {
			mailBody = GlobalConstants.OIF_EXCEPTION_EMAIL_NOFAILURE_MESSAGE1  + jobID + GlobalConstants.NEWLINE + GlobalConstants.COMPLETED + system.now() + GlobalConstants.OIF_EXCEPTION_EMAIL_NOFAILURE_MESSAGE2;   
			email.setPlainTextBody(mailBody); 
			subject = GlobalConstants.OIF_EXCEPTION_EMAIL_NOFAILURE_SUBJECT+ className + GlobalConstants.COMPLETED_ON + system.now();   
	   }   
	   else if(failedRecords.size() == 0 && pastPeriodUpdated.size() > 0)
	   {
		   for(Order_Intake_Forecast__c a: pastPeriodUpdated)
				{
					String pastRecord = '"'+a.id+'","'+a.Name+'","'+a.Opportunity__c+'","'+
						a.POPlanReceipt__r.Name+'","'+a.CurrencyIsoCode+'","'+a.OIF_Value__c+'"\n';
					past_str = past_str +pastRecord;
				} 
				Messaging.EmailFileAttachment csvAttc_past = new Messaging.EmailFileAttachment();
				blob csvBlob_past = Blob.valueOf(past_str);
				string csvname_past= GlobalConstants.OIF_EXCEPTION_EMAIL_PASTRECORDS_CSVFILENAME;
				csvAttc_past.setFileName(csvname_past);
				csvAttc_past.setBody(csvBlob_past);
				attcList.add(csvAttc_past);
				mailBody_past = GlobalConstants.OIF_EXCEPTION_EMAIL_MAILBODY_SALUTATION1  + jobID +GlobalConstants.NEWLINE +
					GlobalConstants.COMPLETED + GlobalConstants.COLON  + system.now() +
					GlobalConstants.OIF_EXCEPTION_EMAIL_PASTRECORDS_MAILBODY + pastPeriodUpdated.size() + 
					GlobalConstants.FORWARD_SLASH + processedRecords + GlobalConstants.OIF_EXCEPTION_EMAIL_PASTRECORDS_INSTRUCTIONS;
		   
		   mailBody = mailBody_past + GlobalConstants.OIF_EXCEPTION_EMAIL_SIGNATURE;
		
			email.setPlainTextBody(mailBody);
			system.debug('mailBody'+mailBody);
		
			email.setFileAttachments(attcList);
			subject = GlobalConstants.OIF_EXCEPTION_EMAIL_SUBJECT + className + GlobalConstants.COMPLETED_ON+ system.now();
	   }
		system.debug('UserInfo.getUserEmail()');
		String[] toAddresses = new list<string> {UserInfo.getUserEmail(),Label.OIF_Batch_Recipient1, Label.OIF_Batch_Recipient2,Label.OIF_Batch_Recipient3,Label.OIF_Batch_Recipient4};
		email.setSubject(subject);
		email.setToAddresses( toAddresses ); 
		if(!Test.isRunningTest()) {
			Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
		}
	}
}