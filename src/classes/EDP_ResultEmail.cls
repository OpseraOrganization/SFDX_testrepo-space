public class EDP_ResultEmail {
	
   //public List<String> mail_ids=new List<String> ();
  
	
	public static void sendEmail(Map<String,String> successMap, Map<String,List<String>>errorResponseMap,String Classname){
		try{
		List<String> toAddresses=new List<String>();
		String email = System.Label.PMDI_Job_Notifications;
		String subject;   
			system.debug('LAbel-->'+email);
		 toAddresses.addAll(email.split(';'));
		system.debug(toAddresses);
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		   if(Classname.equalsIgnoreCase('Batch_ProductRelations'))
		   {
				subject ='Batch Records Status for PMDI ProductRelations';}
			else{
			   subject ='Batch Records Status for PMDI'; 
			}
		 String mailBody = '';
		 mail.setSubject(subject);
		 mail.setToAddresses(toAddresses);  
			
		 //Add the records count list to the mail body
		 mailBody = mailBody + PMDI_Constants.ResultString;
			if(successMap!=NULL){
			for(String successStr : successMap.keySet())
		 {
			 mailBody = mailBody + successMap.get(successStr);
		 }}
		 
			if(errorResponseMap!=NULL){
			   mailBody=mailBody + PMDI_Constants.errorString;	 
			for(String errorStr: errorResponsemap.keySet())
		{
			mailBody= mailBody+ errorResponseMap.get(errorStr)+ '\n';
		} }
			
			mail.setPlainTextBody(mailBody) ;
			system.debug('MAIL BODY'+mailBody);
			Messaging.SendEmailResult[] result= Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail}); 
				system.debug('result' +result);
		}
		catch(exception ex)
		{
			system.debug('ex'+ex.getMessage());
			ExceptionHandler.addException(ex, PMDI_Constants.EDP_ResultEmail, PMDI_Constants.sendEmail);
		}		
		
		
	}

}