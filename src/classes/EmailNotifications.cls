public class EmailNotifications {
	
	//=========================================================================================
	//Method	: ExtractHTMLbody
	//Description: This method will get the HTML body from template provided what are the template merge fields related to.
	//Author : Rakesh Dandae
	//Attributes:
	//   Templatename - DeveloperName of the Emailtemplate
	//   whatid - Merge fields of the EmailTemplate will refer to this id and populate fields
	//Return Value: Map consisting of HTML Body and Subject.   
	// 
	//=========================================================================================	
	public static map<String,String> ExtractHTMLbody(String Templateid, Id whatid){
		
		map<string, string> htmloutput = new map<string, string>();
		
		try{
	   
		system.debug('Queries used before sms : '+ limits.getQueries());
		Messaging.SingleEmailMessage sms = Messaging.renderStoredEmailTemplate(Templateid, userinfo.getUserId(), whatid);
			system.debug('Queries used after sms : '+ limits.getQueries());
		String htmlbody = sms.getHtmlBody();
		String htmlSubject = sms.getSubject();
		htmloutput.put('body', htmlbody);
		htmloutput.put('subject',htmlSubject);
		
		
		} catch(exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CL_EmailNotifications, GlobalConstants.M_ExtractHTMLbody);
		}
		system.debug('htmloutput-->'+htmloutput);
		return htmloutput;
	}
	
	//=========================================================================================
	//Method	: sendmail
	//Description: This method will Send Emails to the listed users.
	//Author : Rakesh Dandae
	//Attributes:
	//   Body - HTML body from template
	//   Subject - HTML Subject from template
	//   toaddress_list - List of email address to which the email has to be sent
	//========================================================================================= 
	
	public static Messaging.SingleEmailMessage sendmail(String Body, String Subject, List<String> toaddress_list){
		
		system.debug('entered sendemail method');
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		
		try{
			
		mail.setSubject(Subject);
		mail.setHtmlBody(body);
		mail.setToAddresses(Toaddress_list);
		mail.setSaveAsActivity(false);
			mail.setTargetObjectId(userinfo.getUserId());
		   // mail.setTreatTargetObjectAsRecipient(false);
		   
		//Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		} catch(exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CL_EmailNotifications, GlobalConstants.M_sendmail);
		}
		
		 return mail;
	}
	
	//=========================================================================================
	//Method	: sendmailwithtrgtobj
	//Description: This method will Send Emails to the listed users.
	//Author : Rakesh Dandae
	//Attributes:
	//   Body - HTML body from template
	//   Subject - HTML Subject from template
	//   toaddress_list - List of email address to which the email has to be sent
	//=========================================================================================	 
	
	public static Messaging.SingleEmailMessage[] sendmailwithtrgtobj(String Body, String Subject, Set<Id> toaddress_list){
		
		system.debug('entered sendemail method');
		List<Messaging.SingleEmailMessage> maillist = new List<Messaging.SingleEmailMessage>();
		
		try{
			for(Id toadr : toaddress_list){
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setSubject(Subject);
				mail.setHtmlBody(body);
				mail.setSaveAsActivity(false);
				mail.setTargetObjectId(toadr);
				
				maillist.add(mail);
			}
		
		   // mail.setTreatTargetObjectAsRecipient(false);
		   
		//Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		} catch(exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.CL_EmailNotifications, GlobalConstants.M_sendmail);
		}
		
		 return maillist;
	}
}