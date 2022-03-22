@isTest
public class CH_EmailMessageController_Test {

	@isTest
	public static void retriveEmailMessageTest() {
		
		EmailMessage emailRec = new EmailMessage();
		emailRec.Subject = 'Test Subject';
		emailRec.HtmlBody = 'Test Html Body';
		emailRec.TextBody = 'Test Text Body';
		insert emailRec; 
		Test.startTest();
		EmailMessage emailrecForTest = CH_EmailMessageController.retriveEmailMessage(emailRec.Id);
		Test.stopTest();
		System.assertEquals(emailrecForTest.Id, emailRec.Id);
	}
}