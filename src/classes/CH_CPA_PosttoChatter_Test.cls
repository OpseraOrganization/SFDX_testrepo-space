@isTest(SeeAllData=true)
public class CH_CPA_PosttoChatter_Test { 
	
	// Success Case
	public static testMethod void ProcessApplicantTest(){
		
		
		// Create a new email, envelope object and Attachment
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
		
		CH_Corrective_Preventive_Action__c CPAction = new CH_Corrective_Preventive_Action__c();
		//CPAction.='hdfh';
		CPAction.CH_Source__c = 'Case Handling Routing Issue';
		CPAction.CH_Description__c = 'Test Desc123';
		CPAction.CH_Classification__c ='Preventive';
		CPAction.CH_Priority__c = 'High';
		
		CPAction.CH_Category__c = 'Care Delivery';
		CPAction.CH_Domain__c = 'Care';
		insert CPAction;
		EmailMessage emailMessage = new EmailMessage();
		emailMessage.status = '3'; // email was sent
		emailMessage.relatedToId = CPAction.Id; // related to record e.g. an opportunity
		System.debug('emailMessage.relatedToId:'+emailMessage.relatedToId);
		emailMessage.fromName = 'Dan Perkins'; // from name
		emailMessage.subject =  CPAction.Id; // email subject
		emailMessage.htmlBody = '<html><body><b>Hello</b></body></html>'; // email body
		// additional recipients who don’t have a corresponding contact, lead or user id in the Salesforce org (optional)
		emailMessage.toAddress = 'emailnotinsalesforce@toexample.com, anotherone@toexample.com';
		insert emailMessage; // insert
		
		// Add Email Message Relation for id of the sender
		EmailMessageRelation emr = new EmailMessageRelation();
		emr.emailMessageId = emailMessage.id;
		emr.relationId = UserInfo.getUserId(); // user id of the sender
		emr.relationType = 'FromAddress';
		insert emr;
		//CPAction.OwnerId='0058A000001q69sQAA';
		//update CPAction;
		list<String> list1 = new list<String>();
		list1.add('gouri.uit@gmail.com');
		email.toAddresses=list1;
		CH_Corrective_Preventive_Action__c CPAction1=[select id from CH_Corrective_Preventive_Action__c limit 1];
		email.subject = 'ref:'+CPAction1.id+':ref';
		email.fromName = 'test test';
		email.plainTextBody = 'Hello, this a test email body. for testing purposes only.Phone:123456 Bye';
		Messaging.InboundEmail.BinaryAttachment[] binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[1]; 
		Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
		binaryAttachment.Filename = 'test.txt';
		String algorithmName = 'HMacSHA1';
		Blob b = Crypto.generateMac(algorithmName, Blob.valueOf('test'),
			Blob.valueOf('test_key'));
		binaryAttachment.Body = b;
		binaryAttachments[0] =  binaryAttachment ;
		email.binaryAttachments = binaryAttachments ;
		envelope.fromAddress = 'user@acme.com';
		email.fromAddress = 'user@acme.com';
		CH_CPA_PosttoChatter catcher = new CH_CPA_PosttoChatter();
		catcher.CPAID1=CPAction.Id;
		catcher.handleInboundEmail(email, envelope);
		// System.assertEquals( result.success  ,true);		
	}		 
}