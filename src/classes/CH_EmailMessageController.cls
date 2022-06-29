public class CH_EmailMessageController {

	@AuraEnabled
	public static EmailMessage retriveEmailMessage(String recordId) {
	   return [Select Id, HTMLBody, TextBody From EmailMessage Where Id = : recordId];
	}
}