/****************************************
 * Class Name : Opportunity_Exception_Email 
 * Created Date: 30 Jan 2020
 * Created By : sudha kumari
 * Last Modified by:  
 * Last Modified Date:  
 * Description : Send email of wrongly processed or failed to process opportunity records when updating the opportunity 
 *		 value according to exchange rates
 * Test Class: 
 *****************************************/
public class Opportunity_Exception_Email {
	
	/********************
	*Method Name: sendEmail
	*Parameter: opportunity FailedRecords, Batch jobID, ProcessedRecordsCount, ClassName, 
		opportunity ClosedRecords 
	*Description: Used to send email to designated receipients with csv files as attachment which contains 
		failed/non-processed records and records which are closed but still updated

	*******************/
   public static void sendEmail(Map<Id, Opportunity> failedRecords, String jobID, Integer processedRecords, String className, List<opportunity> closedUpdated)
   {
	   System.debug('test confirm');
	   String header = GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_HEADER;
	   String closed_header = GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_CLOSEDRECORDS_HEADER;
	   String finalstr = header ;
	   String closed_str = closed_header ;   
	   String mailBody;
	   String mailBody_closed = '';
	   String subject ;
	   Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
	   List<Messaging.Emailfileattachment> attcList = new List<Messaging.Emailfileattachment>();
	   if(failedRecords.size()!=0 && failedRecords.size() < 5000)
	   {
			for(Opportunity a: failedRecords.values())
			{
				String recordString = '"'+a.id+'","'+a.Name+'","'+a.CurrencyIsoCode+'"\n';
				finalstr = finalstr +recordString; 
			}
			
			if(closedUpdated.size() > 0 )
			{
				for(Opportunity a: closedUpdated)
				{
					String closedRecord = '"'+a.id+'","'+a.Name+'","'+a.CurrencyIsoCode+'"\n';
					closed_str = closed_str +closedRecord;
				} 
				Messaging.EmailFileAttachment csvAttc_closed = new Messaging.EmailFileAttachment();
				blob csvBlob_closed = Blob.valueOf(closed_str);
				string csvname_closed= GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_CLOSEDRECORDS_CSVFILENAME;
				csvAttc_closed.setFileName(csvname_closed);
				csvAttc_closed.setBody(csvBlob_closed);
				attcList.add(csvAttc_closed);
				mailBody_closed = GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_CLOSEDRECORDS_MAILBODY + closedUpdated.size() + 
					GlobalConstants.FORWARD_SLASH + processedRecords + GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_CLOSEDRECORDS_INSTRUCTIONS;
			}   
			Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
			blob csvBlob = Blob.valueOf(finalstr);
			string csvname= GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_FAILEDRECORDS_CSVFILENAME;
			csvAttc.setFileName(csvname);
			csvAttc.setBody(csvBlob);
			attcList.add(csvAttc);
		
			mailBody = GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_MAILBODY_SALUTATION1  + jobID +GlobalConstants.NEWLINE +
				GlobalConstants.COMPLETED + GlobalConstants.COLON  + system.now() +
				GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_MAILBODY_SALUTATION2 + failedRecords.size() + 
				GlobalConstants.FORWARD_SLASH + processedRecords + GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_MAILBODY_INSTRUCTION;
			
		   if(mailBody_closed.length()>0)
			  mailBody += mailBody_closed ;
			
			mailBody += GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_SIGNATURE;
		
			email.setPlainTextBody(mailBody);
			system.debug('mailBody'+mailBody);
		
			email.setFileAttachments(attcList);
			subject = GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_SUBJECT + className + GlobalConstants.COMPLETED_ON+ system.now();
	   }
	   else if (failedRecords.size() > 5000)
	   {
			mailBody = GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_FILETOOLARGE_MESSAGE1+ GlobalConstants.BATCH_ID  + 
				jobID + GlobalConstants.NEWLINE + GlobalConstants.COMPLETED + system.now() + 
				GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_FILETOOLARGE_MESSAGE2 + failedRecords.size() + '/' + processedRecords +
				GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_FILETOOLARGE_MESSAGE_INSTRUCTION;
			email.setPlainTextBody(mailBody);
		  subject = GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_FILETOOLARGE_SUBJECT + className + GlobalConstants.COMPLETED_ON + system.now();	 
	   }
	   else if(failedRecords.size() == 0 && closedUpdated.size() == 0)   
	   {
			mailBody = GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_NOFAILURE_MESSAGE1  + jobID + GlobalConstants.NEWLINE + GlobalConstants.COMPLETED + system.now() + GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_NOFAILURE_MESSAGE2;   
			email.setPlainTextBody(mailBody); 
			subject = GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_NOFAILURE_SUBJECT+ className + GlobalConstants.COMPLETED_ON + system.now();   
	   }   
	   else if(failedRecords.size() == 0 && closedUpdated.size() > 0)
	   {
		   for(Opportunity a: closedUpdated)
				{
					String closedRecord = '"'+a.id+'","'+a.Name+'","'+a.CurrencyIsoCode+'"\n';
					closed_str = closed_str +closedRecord;
				} 
				Messaging.EmailFileAttachment csvAttc_closed = new Messaging.EmailFileAttachment();
				blob csvBlob_closed = Blob.valueOf(closed_str);
				string csvname_closed= GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_CLOSEDRECORDS_CSVFILENAME;
				csvAttc_closed.setFileName(csvname_closed);
				csvAttc_closed.setBody(csvBlob_closed);
				attcList.add(csvAttc_closed);
				mailBody_closed = GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_MAILBODY_SALUTATION1  + jobID +GlobalConstants.NEWLINE +
				  GlobalConstants.COMPLETED + GlobalConstants.COLON  + system.now() +
					GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_CLOSEDRECORDS_MAILBODY + closedUpdated.size() + 
					GlobalConstants.FORWARD_SLASH + processedRecords + GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_CLOSEDRECORDS_INSTRUCTIONS;
		   
		   mailBody = mailBody_closed + GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_SIGNATURE;
		
			email.setPlainTextBody(mailBody);
			system.debug('mailBody'+mailBody);
		
			email.setFileAttachments(attcList);
			subject = GlobalConstants.OPPORTUNITY_EXCEPTION_EMAIL_SUBJECT + className + GlobalConstants.COMPLETED_ON+ system.now();
	   }
		system.debug('UserInfo.getUserEmail()');
		String[] toAddresses = new list<string> {UserInfo.getUserEmail(),Label.PSRO_Batch_Recipient1, Label.PSRO_Batch_Recipient2,Label.PSRO_Batch_Recipient3,Label.PSRO_Batch_Recipient4};
		email.setSubject(subject);
		email.setToAddresses( toAddresses ); 
		 if(!Test.isRunningTest()) {
		  Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
		}
	} 
}