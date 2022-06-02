@isTest
public class emailServiceReciver_UserRequest_Test {
	
	// Success Case
	public static testMethod void testinBoundEmail(){
		
		// create a new email and envelope object
		Messaging.InboundEmail email = new Messaging.InboundEmail() ;
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		
		//get the case record type id by developer name
		Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('User_Management_Case_Support').getRecordTypeId();
		
		// setup the data for the email
		email.subject = 'New User Request';
		email.fromAddress = 'someaddress@email.com';
		email.plainTextBody = 'email body\nSubject:Test Subject;\nDescription:Test Description;\nLine Manager Email:Test@lm.com;\nMultimarket/CrossMarket:Market Europe;\n';
		email.plainTextBody = email.plainTextBody+'Tableau CRM Access:Yes;\nNokia ID:62203566;\nType of Request:CRM Access;\nSelect Your Market:Market India;\nCountry:India;\n';
		email.plainTextBody = email.plainTextBody+'Assessed Priority:Medium;\nType:sCRM Problem;\nOrigin:Email;\nCategory:Reporting;\nRequest Submitted By:Test1@lm.com;\nHas Attachments:TRUE;\n';
		email.plainTextBody = email.plainTextBody+'Applicant Email:Rahul.6.kumar@nokia.com;\nTerritory:2-Nokia Networks;\nSubscribe to Emails for Ticket Status:Yes;\nRecord Type:'+recordTypeId+';';
		System.debug('Plain Body: '+email.plainTextBody);
		// add a Binary attachment
		Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
		attachment.body = blob.valueOf('my attachment text');
		attachment.fileName = 'textfileone.txt';
		attachment.mimeTypeSubType = 'text/plain';
		email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
			
		// add an Text atatchment			
		Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
		attachmenttext.body = 'my attachment text';
		attachmenttext.fileName = 'textfiletwo3.txt';
		attachmenttext.mimeTypeSubType = 'texttwo/plain';
		email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
			
		// call the email service class and test it with the data in the testMethod
		emailServiceReciver_UserRequest testInbound=new emailServiceReciver_UserRequest();
		testInbound.handleInboundEmail(email, env);
			
	}
}