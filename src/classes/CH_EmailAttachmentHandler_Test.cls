@isTest
public class CH_EmailAttachmentHandler_Test {
	static string threadId ='Test theadId [ ref:_00D1FDGvi._5001F1zZnV:ref ]';
	static string fromemladd ='Test932047120919781@nokia.com';
	static string embody ='email body content';
	static string toemadd ='alphaUser@test.com';
	static string filenme ='exemple.png';
	static string pngbdy ='png body';
	static string mimsubtype ='image/png';
	static string header1name ='X-Attachment-Id';
	static string header1value = 'cid:AttachmentID2342';
	static string header2name = 'Content-Disposition';
	static string header2value = 'inline; filename="image.png"';
	static string attachmenttextbody = 'text body';
	static string attachmenttextfileName = 'example2.txt';
	static string attachmentSubType = 'text/plain';
	static string tofromadd='support.services@nokia.com';
	static string contenttype='Content-Type';
	static string apjason='application/json';
	
	
	@testSetup static void setup(){ 
		
		CH_AvoidRecursion.beforeInsert = false;
		CH_AvoidRecursion.beforeUpdate = false;
		CH_AvoidRecursion.afterInsert = false;
		CH_AvoidRecursion.afterUpdate = false;
		CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;
		CH_UTIL_TEST.setupCase(false);
	} 
	
	static Case createNewCHcase(){
		
		// Create a new CH case
		CH_AvoidRecursion.beforeInsert = false;
		CH_AvoidRecursion.beforeUpdate = false;
		CH_AvoidRecursion.afterInsert = false;
		CH_AvoidRecursion.afterUpdate = false;
		CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', 'CH_NokiaStandardCase', true); 
		newCase.CH_ServiceType__c = 'Customer Support';
		newCase.CH_OutageEndDate__c = datetime.now().addDays(5);
		newCase.CH_OutageStartDate__c = datetime.now();   
		newCase.ownerId = Userinfo.getUserId();
		insert newCase;
		return newCase;
		
	}
	
	@isTest static void sendNewEmailWithNoRelatedCase(){
		
		Test.startTest(); 
		
	
		
		// create a new email and envelope object
		Messaging.InboundEmail email = new Messaging.InboundEmail() ;
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		
		// setup the data for the email
		email.subject = threadId;
		email.fromAddress = fromemladd;
		email.plainTextBody = embody;
		email.HtmlBody = embody;
		email.toAddresses = new list<string>{toemadd}; 
			
			Test.setMock(HttpCalloutMock.class, new MockHttpCAPSresponse());
		// call the email service class  
		CH_EmailAttachmentHandler inbound = new CH_EmailAttachmentHandler();
		inbound.caseId = null;
		inbound.handleInboundEmail(email, env);
		Test.stopTest();	
		
		list<EmailMessage> message = new list<EmailMessage>([SELECT Id FROM EmailMessage WHERE Subject =:threadId ]);
		system.assert(message.isEmpty(), 'No message should be found');
		
	}
	// Test that an email without an email chain gets discarded
	@isTest static void sendNewEmail(){
		Test.startTest();
		
		Case newCase = createNewCHcase(); 
		list<Messaging.InboundEmail> emails = new list<Messaging.InboundEmail>();
		// create a new email and envelope object
		Messaging.InboundEmail email = new Messaging.InboundEmail() ;
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
			List<Messaging.InboundEmail.Header> headers = new list<Messaging.InboundEmail.Header>();
		Messaging.InboundEmail.Header header1 = new Messaging.InboundEmail.Header();
		
		header1.name = 'name1';
		header1.value = 'value1';
		headers.add(header1);
		
		// setup the data for the email
		email.subject = threadId;
		email.fromAddress = fromemladd;
		email.plainTextBody = embody;
		email.HtmlBody = embody;
		email.toAddresses = new list<string>{toemadd}; 
			email.headers = headers;
		emails.add(email);
		
		Messaging.InboundEmail email1 = new Messaging.InboundEmail() ;
		email1.subject = threadId;
		email1.fromAddress = fromemladd;
		email1.plainTextBody = embody;
		email1.HtmlBody = embody;
		email1.toAddresses = new list<string>{toemadd}; 
			emails.add(email1);
		
		Test.setMock(HttpCalloutMock.class, new MockHttpCAPSresponse());
		// call the email service class  
		CH_EmailAttachmentHandler inbound = new CH_EmailAttachmentHandler();
		inbound.caseId = newCase.Id;
		inbound.handleInboundEmail(email, env);
		
		Test.stopTest();	
		
		list<EmailMessage> message = new list<EmailMessage>([SELECT Id FROM EmailMessage WHERE Subject =: threadId]);
		system.assert(message.isEmpty(), 'No message should be found');
	}
	
	
	// Test that an email can be linked to an existing email chain on a case
	@isTest static void replyToCaseEmail(){
		Test.startTest();
		
		
		Case newCase = createNewCHcase();
		newCase.Status = 'Assigned';
		newCase.CH_AssignedDate__c = DateTime.Now();
		update newCase;
		
		List<Case> caseList = new List<Case>();
		Case newCase1 = createNewCHcase();
		
		newCase1.Status = 'Cancelled';
		newCase1.CH_ReasonForCancellation__c = 'testCancel';
		caseList.add(newCase1);
		
		update caseList;
		
		EmailMessage existingEmailMessage = new EmailMessage();
		existingEmailMessage.parentid = newCase.Id;
		existingEmailMessage.Subject = threadId;
		existingEmailMessage.CH_Email_Type__c = 'Update';
		insert existingEmailMessage;
		
		// create a new email and envelope object
		Messaging.InboundEmail email = new Messaging.InboundEmail() ;
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		
		// setup the data for the email
		email.subject = threadId;
		email.fromAddress = fromemladd;
		email.plainTextBody = embody;
		email.HtmlBody = embody;
		email.toAddresses = new list<string>{toemadd}; 
			
			// add an Binary attachment
			Messaging.InboundEmail.BinaryAttachment attachment2 = new Messaging.InboundEmail.BinaryAttachment();
		attachment2.body = blob.valueOf(pngbdy);
		attachment2.fileName = filenme;
		attachment2.mimeTypeSubType = mimsubtype;
		
		Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
		attachment.body = blob.valueOf(pngbdy);
		attachment.fileName = filenme;
		attachment.mimeTypeSubType = mimsubtype;
		
		list<Messaging.InboundEmail.Header> headers = new list<Messaging.InboundEmail.Header>();
		
		Messaging.InboundEmail.Header header1 = new Messaging.InboundEmail.Header();
		header1.name = header1name;
		header1.value = header1value;
		headers.add(header1);
		Messaging.InboundEmail.Header header2 = new Messaging.InboundEmail.Header();
		header2.name = header2name;
		header2.value =  header2value;
		headers.add(header2);
		attachment.headers = headers;
		
		email.headers = new Messaging.InboundEmail.Header[]{header1,header2};
			email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment, attachment2 };
	
	// add an Text atatchment
	Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
		attachmenttext.body = attachmenttextbody;
		attachmenttext.fileName = attachmenttextfileName;
		attachment.mimeTypeSubType = attachmentSubType;
		email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
			
			Test.setMock(HttpCalloutMock.class, new MockHttpCAPSresponse());
		// call the email service class  
		CH_EmailAttachmentHandler inbound = new CH_EmailAttachmentHandler();
		
		
		inbound.caseId = newCase.Id;
		
		inbound.handleInboundEmail(email, env);
		list<EmailMessage> message2 = new list<EmailMessage>([SELECT Id FROM EmailMessage]); // WHERE Subject = 'Nokia Support - Unable to Process Email']);
		Test.stopTest();	
		
		System.debug('xxx ' + message2.size());  
		
	}
	
	@isTest static void replyToCaseEmail2(){
		Test.startTest();
		Case newCase = createNewCHcase();
		newCase.Status = 'Assigned';
		newCase.CH_AssignedDate__c = DateTime.Now();
		update newCase;
		
		EmailMessage existingEmailMessage = new EmailMessage();
		existingEmailMessage.parentid = newCase.Id;
		existingEmailMessage.Subject = threadId;
		existingEmailMessage.CH_Email_Type__c = 'Update';
		insert existingEmailMessage;
		
		// create a new email and envelope object
		Messaging.InboundEmail email = new Messaging.InboundEmail() ;
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		
		// setup the data for the email
		email.subject = threadId;
		email.fromAddress = fromemladd;
		email.plainTextBody = embody;
		email.HtmlBody = embody;
		email.toAddresses = new list<string>{toemadd}; 
			
			// add an Binary attachment
			Messaging.InboundEmail.BinaryAttachment attachment2 = new Messaging.InboundEmail.BinaryAttachment();
		attachment2.body = blob.valueOf(pngbdy);
		attachment2.fileName = filenme;
		attachment2.mimeTypeSubType = mimsubtype;
		
		Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
		attachment.body = blob.valueOf(pngbdy);
		attachment.fileName = filenme;
		attachment.mimeTypeSubType = mimsubtype;
		
		list<Messaging.InboundEmail.Header> headers = new list<Messaging.InboundEmail.Header>();
		Messaging.InboundEmail.Header header1 = new Messaging.InboundEmail.Header();
		header1.name = header1name;
		header1.value = header1value;
		headers.add(header1);
		
		
		Messaging.InboundEmail.Header header2 = new Messaging.InboundEmail.Header();
		header2.name = header2name;
		header2.value =  header2value;
		headers.add(header2);
		
		
		attachment.headers = headers;
		
		email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment, attachment2 };
			
			// add an Text atatchment
			Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
		attachmenttext.body = attachmenttextbody;
		attachmenttext.fileName = attachmenttextfileName;
		attachment.mimeTypeSubType = attachmentSubType;
		email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
			
			Test.setMock(HttpCalloutMock.class, new MockHttpCAPSresponse());
		// call the email service class  
		CH_EmailAttachmentHandler inbound = new CH_EmailAttachmentHandler();
		inbound.fileMaxSizeBytes = 1; 
		inbound.caseId = newCase.Id;
		inbound.handleInboundEmail(email, env);
		list<EmailMessage> message2 = new list<EmailMessage>([SELECT Id FROM EmailMessage]); // WHERE Subject = 'Nokia Support - Unable to Process Email']);
		Test.stopTest();	
		
		System.debug('xxx ' + message2.size());  
		
	}
	
	public class MockHttpCAPSresponse1 implements HttpCalloutMock{
		public HTTPResponse respond(HTTPRequest req){
			HttpResponse res = new HttpResponse();
			res.setHeader(contenttype, apjason);
			res.setBody('{"id":"c9c54141228044a98070638deba4e344","owner":"app_salesforce","owner_name":" ","owner_email":"ignore@nokia.com","app":"Salesforce CRM","classification":{"id":14,"name":"Non-Sensitive Data"},"classifications":[{"id":14,"name":"Non-Sensitive Data"}],"nctclassification":4,"customer":{"id":31502,"id_cdb":"76521","name":"Verizon Wireless, US","country_code":"US"},"product":null,"productversion":null,"ticket":{"id":15692,"app_name":"Salesforce CRM","ticket_id":"00013477"},"description":"file Desc","purpose":"Case Handling","files":[{"id":532282,"name":"TestFile20.txt","size":2416,"type":"original","status":"uploading","s3keyname":"c9c54141228044a98070638deba4e344/TestFile20.txt","processing_time":null,"s3_time":null,"dpc_id":"DPI_10269508821387T2","virus_scan_status":0}],"creation_time":"2018-10-26T07:07:08.715752-05:00","deletion_time":null,"retention_days":null,"status":null,"encryption_key":null,"evaporate":{"sign_params":{"permission":"RW","user":"app_salesforce","expiration":1540627629,"signer":"bdc7f90cef7345c984f9e34d25e0c192","signtoken":"4223fd6cca2de6b0-a245c85a8e7d5336a2e911ad190209cd7a9b526207b3e95e234da5f6ada0175f"},"aws_signature_version":"4","s3_region":"us-east-1","max_concurrent_parts":2,"acl":"private","part_size":33554432,"aws_key":"RZZVJKQRQUBLHMVWYTJ_","signer_url":"https://capsv.nokia.com/93f6cc8e/api/s3sign","aws_url":"https://s3.capsv.nokia.com/a848be61/us2","bucket":"capsvtest1"},"download_url":"https://capsv.nokia.com/93f6cc8e/downloadattachment?id=c9c54141228044a98070638deba4e344","download_url_external":"https://capsv.nokia.com/93f6cc8e/external/downloadattachment?id=c9c54141228044a98070638deba4e344","skip_scrambling":false,"service_class":"CARE","nct_lawful_intercept":null,"nct_case_status":null,"customer_visible":true,"retentiondaysleft":"N/A","capsrt_issue":null,"country_code":null,"SFsecuritygroup":"SEC_Default"}');
			res.setStatusCode(200);
			return res;
		}
	}
	
	public class MockHttpCAPSresponse2 implements HttpCalloutMock{
		public HTTPResponse respond(HTTPRequest req){
			HttpResponse res = new HttpResponse();
			res.setHeader(contenttype, apjason);
			res.setBody('ypmfiJ/kRY1V5N3rf8sozn5rqIU=');
			res.setStatusCode(200);
			return res;
		}
	}
	
	public class MockHttpCAPSresponse3 implements HttpCalloutMock{
		public HTTPResponse respond(HTTPRequest req){
			HttpResponse res = new HttpResponse();
			res.setHeader(contenttype, 'application/xml');
			res.setBody('<?xml version="1.0" encoding="UTF-8"?><InitiateMultipartUploadResult xmlns="http://s3.amazonaws.com/doc/2006-03-01/"><Bucket>capsvtest1</Bucket><Key>c9c54141228044a98070638deba4e344/TestFile20.txt</Key><UploadId>2~ZOTUTDzWqctucNysuAjXfyvi8YoUzO4</UploadId></InitiateMultipartUploadResult>');
			res.setStatusCode(200);
			return res;
		}
	}
	
	public class MockHttpCAPSresponse4 implements HttpCalloutMock{
		public HTTPResponse respond(HTTPRequest req){
			HttpResponse res = new HttpResponse();
			res.setHeader(contenttype, apjason);
			res.setBody('m7fQ2Jej9bNzIg4vr8NYL1abdcg=');
			res.setStatusCode(200);
			return res;
		}
	}
	
	public class MockHttpCAPSresponse implements HttpCalloutMock{
		
		public HTTPResponse respond(HTTPRequest req){
			HttpResponse res = new HttpResponse();
			res.setHeader(contenttype, apjason);
			res.setBody('');
			res.setStatusCode(200);
			return res;
		}   
	}
	
	
	@isTest 
	static void replyToCaseEmail3(){
		Test.startTest();
		
		Case cancelledCase = createNewCHcase();
		cancelledCase.Status = 'Cancelled';
		cancelledCase.CH_ReasonForCancellation__c = 'testCancel';
		cancelledCase.CH_AssignedDate__c = date.today();
		cancelledCase.CH_MilestoneSLA_Start__c = date.today();
		update cancelledCase;
		
		EmailMessage existingEmailMessage3 = new EmailMessage();
		existingEmailMessage3.parentid = cancelledCase.Id;
		existingEmailMessage3.Subject = threadId;
		existingEmailMessage3.CH_Email_Type__c = 'Update';
		
		// create a new email and envelope object
		Messaging.InboundEmail email3 = new Messaging.InboundEmail() ;
		Messaging.InboundEnvelope env3 = new Messaging.InboundEnvelope();
		
		// setup the data for the email
		email3.subject = threadId;
		email3.fromAddress = fromemladd;
		email3.plainTextBody = embody;
		email3.HtmlBody = embody;
		email3.toAddresses = new list<string>{toemadd}; 
			
			// add an Binary attachment
			Messaging.InboundEmail.BinaryAttachment attachment2 = new Messaging.InboundEmail.BinaryAttachment();
		attachment2.body = blob.valueOf(pngbdy);
		attachment2.fileName = filenme;
		attachment2.mimeTypeSubType = mimsubtype;
		
		Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
		attachment.body = blob.valueOf(pngbdy);
		attachment.fileName = filenme;
		attachment.mimeTypeSubType = mimsubtype;
		
		list<Messaging.InboundEmail.Header> headers = new list<Messaging.InboundEmail.Header>();
		
		Messaging.InboundEmail.Header header1 = new Messaging.InboundEmail.Header();
		header1.name = header1name;
		header1.value = header1value;
		headers.add(header1);
		Messaging.InboundEmail.Header header2 = new Messaging.InboundEmail.Header();
		header2.name = header2name;
		header2.value =  header2value;
		headers.add(header2);
		attachment.headers = headers;
		
		email3.headers = new Messaging.InboundEmail.Header[]{header1,header2};
		email3.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment, attachment2 };
	
	// add an Text atatchment
	Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
		attachmenttext.body = attachmenttextbody;
		attachmenttext.fileName = attachmenttextfileName;
		attachment.mimeTypeSubType = attachmentSubType;
		email3.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
			
			Test.setMock(HttpCalloutMock.class, new MockHttpCAPSresponse());
		// call the email service class  
		CH_EmailAttachmentHandler inbound = new CH_EmailAttachmentHandler();
		inbound.caseId = cancelledCase.Id;
		inbound.handleInboundEmail(email3, env3);
		Test.stopTest();
	}
}