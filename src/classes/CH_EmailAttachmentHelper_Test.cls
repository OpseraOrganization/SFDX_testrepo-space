@isTest
public class CH_EmailAttachmentHelper_Test { 

	public static final string casemarket='Market India';
	public static final string caserecedtyp='CH_NokiaStandardCase';
	public static final string theardid= 'Test theadId [ ref:_00D1FDGvi._5001F1zZnV:ref ]';
	public static final string emailbody='email body content';
	public static final string emailsubject='Email Subject';
	
	@testSetup static void testDataSetup(){
		CH_Settings__c chsettings = new CH_Settings__c();
		chsettings.Name = 'SpecificTimeForOnhold';   
		chsettings.SettingValue__c = '0';
		chsettings.Description__c = 'test';
		CH_EntitlementTestData.createCustomSettingData();
		File_Sharing_Custom_Setting__c fileSharingCustomSetting51 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting51.Name = 'Allowed Profiles For Chatter Files';
		fileSharingCustomSetting51.Value__c = 'Confidential';
		insert fileSharingCustomSetting51;
		List<ISO_Country_Codes__c> listISO = new List<ISO_Country_Codes__c>();
		ISO_Country_Codes__c setting = new ISO_Country_Codes__c();
		setting.Name = 'IN';
		setting.Country_Name__c = 'India';
		setting.Market__c=casemarket;
		listISO.add(setting);
		ISO_Country_Codes__c setting1 = new ISO_Country_Codes__c();
		setting1.Name = 'AG';
		setting1.Country_Name__c = 'Antigua And Barbuda';
		setting1.Market__c='Market Latin America';
		listISO.add(setting1);
		insert listISO;
		Account accObjNL = new Account();
		accObjNL.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('Prospect').Id;	
		accObjNL.Name ='testNL';
		accObjNL.BillingCity= 'Hyderabad';
		accObjNL.BillingCountry = 'India';
		accObjNL.BillingState = 'telangana';
		accObjNL.BillingStreet = '18/89 Ayyappa colony';
		accObjNL.Market__c = casemarket;
		insert accObjNL;
		
		Account accObjLE = new Account();
		accObjLE.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('Legal_Entity').Id;	
		accObjLE.Name ='testLE';
		accObjLE.ParentId = accObjNL.id;
		insert accObjLE;
		
		Contact contObj = new contact();
		contObj.AccountId = accObjNL.id;
		contObj.FirstName = 'TestClassData';
		contObj.LastName = 'TCS Data';
		contObj.Email = 'testaccount@aometh.com';
		contObj.Market__c = casemarket;
		contObj.CH_ContactType__c = 'customer';
		contObj.CurrencyIsoCode = 'EUR';
		insert contObj;
		
		Product2 prodObj = new Product2();
		prodObj.Name ='Test';
		prodObj.ProductCode ='133-047489_0';
		prodObj.DataUsage__c = 'CARES';
		prodObj.PMD_Portfolio_Classification__c = 'Product';
		prodObj.NCP_CAREACTIVATE__c ='Test';
		prodObj.DataUsage__c='CARES';
		prodObj.NCP_Nokia_Product_Id__c = '123456';
		prodObj.NCP_CAREACTIVATE__c='Test';
		insert prodObj;
		
		Product2 prodObj1 = new Product2();
		prodObj1.Name ='Test1';
		prodObj1.ProductCode ='133-047489_1';
		prodObj1.DataUsage__c = 'CARES';		
		prodObj1.NCP_CAREACTIVATE__c ='Test1';
		prodObj1.DataUsage__c='CARES';
		prodObj1.CH_ParentProductId__c=prodObj.Id;
		prodObj1.NCP_Nokia_Product_Id__c = '852963';
		prodObj1.CH_Product_Type__c = 'NSN Solution';
		prodObj1.PMD_Portfolio_Classification__c = 'Solution';
		insert prodObj1;
		
		Product2 prodObj2 = new Product2();
		prodObj2.Name ='Test11';
		prodObj2.ProductCode ='133-047489_11';
		prodObj2.DataUsage__c = 'CARES';		
		prodObj2.NCP_CAREACTIVATE__c ='Test11';
		prodObj2.DataUsage__c='CARES';
		prodObj2.CH_ParentProductId__c=prodObj.Id;
		prodObj2.NCP_Nokia_Product_Id__c = '8529637';
		prodObj2.CH_Product_Type__c = 'Complementary Item';
		prodObj2.PMD_Portfolio_Classification__c = 'Complementary Product';
		prodObj2.PMD_Additional_Classification__c = 'Product Variant';
		insert prodObj2;
		
		Product_Relation__c childParent = new Product_Relation__c();
		childParent.Child_Name__c = prodObj.NCP_Nokia_Product_Id__c;
		ChildParent.Parent_Type__c= 'NSN Solution';
		childparent.RelationFor__c = 'ProductRelation';
		childparent.Parent_Name__c = prodObj1.NCP_Nokia_Product_Id__c;
		childParent.RelationType__c = 'NSN Solution Consists Of';
		insert childParent;
		
		Product_Relation__c parentChild = new Product_Relation__c();
		parentChild.Child_Name__c = prodObj2.NCP_Nokia_Product_Id__c;
		parentChild.Child_Type__c = 'NSN Complementary Item';
		parentChild.RelationFor__c = 'ProductRelation';
		parentChild.Parent_Name__c = prodObj.NCP_Nokia_Product_Id__c;
		parentChild.RelationType__c = 'NSN Is Complemented By';
		insert parentChild;
			
			
		Id pricebook2Id = Test.getStandardPricebookId();
		
		PricebookEntry standardPrice = new PricebookEntry();
		standardPrice.Pricebook2Id= pricebook2id;
		standardPrice.Product2Id= prodObj.id;
		standardPrice.UnitPrice = 10000;
		standardPrice.IsActive = true;
		insert standardPrice;
		
		Pricebook2 customPB1 = new Pricebook2();
		customPB1.Id = CH_EntitlementTestData.CreateCustomPriceBook();
		
		PricebookEntry customPrice = new PricebookEntry();
		customPrice.Pricebook2Id= customPB1.Id;
		customPrice.Product2Id= prodObj.id;
		customPrice.UnitPrice = 10000;
		customPrice.IsActive = true;
		insert customPrice;
		
		
		
		Asset assetObj = new Asset();
		assetObj.RecordTypeId = CH_EntitlementTestData.recordTypeMap.get('CH_CoveredProduct').Id;
		assetObj.Name = 'Test Asset Test Class';
		assetObj.Product2Id = prodObj.id;
		assetObj.AccountId = accObjLE.id;
		insert assetObj;
		system.assertNotEquals(assetObj.Id, Null);
		
		
		
		
		Entitlement entiObj = new Entitlement();
		entiObj.Name ='test';
		entiObj.AccountId = accObjNL.id;
		entiObj.CH_CDB_EntitlementId__c = '1test';
		entiObj.StartDate = System.today();
		entiObj.EndDate = System.today() + 10;
		
		entiObj.AssetId = assetObj.id;
		entiObj.CH_EntitlementType__c = 'Entitled Asset';
		entiObj.CH_ServiceMappingId__c = 'Legacy Customer Support Service - No Severity 24x7';
	
		insert entiObj;
		
		EntitlementContact entcon = new EntitlementContact();
		entcon.EntitlementId = entiObj.id;
		entcon.ContactId = contObj.id;	 
		insert entcon;
		test.startTest();
		Case newCase = new Case();
		newCase.AccountId = accObjLE.Id;
		newCase.ContactId = contObj.Id;
		newCase.CH_ReportedDate__c = DateTime.Now();
		newCase.Mobile_Phone__c = '123-456789';
		newCase.Country__c = 'Bahrain';
		newCase.reason = 'New problem';
		newCase.Subject = 'Test';
		newCase.CH_Summary__c = 'Test';
		newCase.Type = 'Incident';		 
		newCase.Description = 'TEST';
		newCase.Severity__c = 'Critical';
		newCase.CH_Outage__c = 'Yes';
		newCase.Status = 'Created';
		newCase.CH_IssueOccurenceDate__c = system.today();
		newCase.ProductId = prodObj.Id;
		newCase.CH_Initial_Assignment__c = true;
		newCase.CH_SystemRestoredTargetDate__c = system.now();
		newCase.CH_Reassignment__c = true;
		newCase.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(caserecedtyp).getRecordTypeId();
		insert newCase;
			
	}
	static Case createNewCHcase(){
		// Create a new CH case
		CH_AvoidRecursion.beforeInsert = false;
		CH_AvoidRecursion.beforeUpdate = false;
		CH_AvoidRecursion.afterInsert = false;
		CH_AvoidRecursion.afterUpdate = false;
		CH_AvoidRecursion.doNtExcuteCseTrggr4NotfcationBtch = false;
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('Test1', 'Minor', 'No', caserecedtyp, true); 
		newCase.CH_ServiceType__c = 'Customer Support';
		newCase.CH_OutageEndDate__c = datetime.now().addDays(5);
		newCase.CH_OutageStartDate__c = datetime.now();		 
		newCase.ownerId = Userinfo.getUserId();
		insert newCase;
		return newCase;
	}
	public class MockHttpCAPSresponse implements HttpCalloutMock{
		
		public HTTPResponse respond(HTTPRequest req){
			HttpResponse res = new HttpResponse();
			res.setHeader('Content-Type', 'application/json');
			res.setBody('');
			res.setStatusCode(200);
			return res;
		}   
	}
	
	 @isTest static void replyToCaseEmail4(){
		CH_EmailAttachmentHelper.AttachmentHeader attt = new CH_EmailAttachmentHelper.AttachmentHeader();
		attt.contentType = 'content';
		attt.attachementId = 'content';
		attt.contentDisposition = 'content';
		 
		Case newCase = [Select Id from Case limit 1];
		newCase.Status = 'Assigned';
		newCase.CH_AssignedDate__c = DateTime.Now();
		update newCase;
		
		EmailMessage existingEmailMessage = new EmailMessage();
		existingEmailMessage.parentid = newCase.Id;
		existingEmailMessage.Subject = theardid;
		existingEmailMessage.CH_Email_Type__c = 'Update';
		insert existingEmailMessage;
			
		// create a new email and envelope object
		Messaging.InboundEmail email = new Messaging.InboundEmail() ;
		
		
		// setup the data for the email
		email.subject = theardid;
		email.fromAddress = 'Test932047120919781@nokia.com';
		email.plainTextBody = emailbody;
		email.HtmlBody = emailbody;
		email.toAddresses = new list<string>{'alphaUser@test.com'};		 
			
		// add an Text atatchment
		Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
		attachmenttext.body = 'text body';
		attachmenttext.fileName = 'example2.txt';
		email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new MockHttpCAPSresponse());		
		CH_EmailAttachmentHelper attHelper = new CH_EmailAttachmentHelper(newCase.Id, emailsubject, attachmenttext); 
		
		 
		list<EmailMessage> message2 = new list<EmailMessage>([SELECT Id FROM EmailMessage]); // WHERE Subject = 'Nokia Support - Unable to Process Email']);
		list<EmailMessage> message = new list<EmailMessage>([SELECT Id FROM EmailMessage WHERE ParentId = :newCase.Id]);
		Test.stopTest();
	}
	
	 @isTest static void replyToCaseEmail5(){
		Test.startTest();
		
		Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_NokiaStandardCase').getRecordTypeId();
		 CAPS_TestDataUtil.createCustomSettingsData();
		 CH_Settings__c chSet1 = new CH_Settings__c();
		chSet1.Name = 'CAPSSecret';
		chSet1.SettingValue__c = 'Njc2Nzg=';
		 insert chSet1;
		Case newCase = [Select Id from Case limit 1];
		newCase.recordTypeId = recordTypeId;
		newCase.Status = 'Assigned';
		newCase.CH_AssignedDate__c = DateTime.Now();
		update newCase;
		EmailMessage existingEmailMessage = new EmailMessage();
		existingEmailMessage.parentid = newCase.Id;
		existingEmailMessage.Subject = theardid;
		existingEmailMessage.CH_Email_Type__c = 'Update';
		insert existingEmailMessage;
			
		// create a new email and envelope object
		Messaging.InboundEmail email = new Messaging.InboundEmail() ;
		
		
		// setup the data for the email
		email.subject = theardid;
		email.fromAddress = 'Test932047120919781@nokia.com';
		email.plainTextBody = emailbody;
		email.HtmlBody = emailbody;
		email.toAddresses = new list<string>{'alphaUser@test.com'}; 
		
		// add an Binary attachment
		Messaging.InboundEmail.BinaryAttachment attachment2 = new Messaging.InboundEmail.BinaryAttachment();
		attachment2.body = blob.valueOf('png body');
		attachment2.fileName = 'exemple.png';
		attachment2.mimeTypeSubType = 'image/png';
		Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
		attachment.body = blob.valueOf('png body');
		attachment.fileName = 'exemple.png';
		attachment.mimeTypeSubType = 'image/png';
		list<Messaging.InboundEmail.Header> headers = new list<Messaging.InboundEmail.Header>();
		Messaging.InboundEmail.Header header1 = new Messaging.InboundEmail.Header();
		header1.name = 'X-Attachment-Id';
		header1.value = 'cid:AttachmentID2342';
		headers.add(header1);
		Messaging.InboundEmail.Header header2 = new Messaging.InboundEmail.Header();
		header2.name = 'Content-Disposition';
		header2.value =  'inline; filename="image.png"';
		headers.add(header2);
		attachment.headers = headers;
		email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment, attachment2 };
		Test.setMock(HttpCalloutMock.class, new MockHttpCAPSresponse());
		CH_EmailAttachmentHelper attHelper = new CH_EmailAttachmentHelper(newCase.Id, emailsubject, attachment); 
		CH_EmailAttachmentHelper.sendEmailNotification(email.fromAddress,email.subject,'Test Name',email.plainTextBody,email.messageId,email.messageId);
		 CH_EmailAttachmentHelper.caseCommentCalculation(new Set<Id>{UserInfo.getUserId()},new Set<Id>{newCase.Id});
		CH_EmailAttachmentHelper.getAttHeader(headers);
		System.enqueueJob(new CH_EmailAttachmentHelper(newCase.Id, emailsubject, attachment));		 
		list<EmailMessage> message2 = new list<EmailMessage>([SELECT Id FROM EmailMessage]); // WHERE Subject = 'Nokia Support - Unable to Process Email']);
		list<EmailMessage> message = new list<EmailMessage>([SELECT Id FROM EmailMessage WHERE ParentId = :newCase.Id]);
		System.debug('xxx ' + message2.size());		
		System.debug('xxx ' + message.size());		
		Test.stopTest(); 
	}
	}