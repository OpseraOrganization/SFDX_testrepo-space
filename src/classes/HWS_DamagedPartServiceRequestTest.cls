@isTest
public class HWS_DamagedPartServiceRequestTest {   
		 @testSetup 
	public static void createTestData(){  
		 insert new Global_Control__c(ObjectTriggerByPass__c='Asset,ACCT,CNTCT,ACC_CNTCT_REL,USER,SVCNTRT,ASSET,PRODUCT,CLI,ENT,ACCT, CNTCT, Product,cli,PROD2');
	
		CH_UTIL_TEST.setupCase(false);  
		CH_UTIL_TEST.createNokiaUsers();
		HWS_GenericSettings__c cs = new HWS_GenericSettings__c();
		cs.Name='OrderedProcessingSize';
		cs.HWS_Field1__c = '25';
		insert cs;
			
		Id accountRecordType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LOGISTIC_ACCOUNT_EXISTING);
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id childcase = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Child_Case_Read_Only);
		Id parentCaseRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_Parent_Case);
		
		Account acc = HWS_DataFactory_TEST.insertAccount();
		acc.name='test1';
		acc.Customer_Compliance__c ='US_Govern';
		insert acc;
		Account legalAcc = HWS_DataFactory_TEST.insertAccount(); 
		legalAcc.RecordTypeId =  legalEntityAccountType;
		legalAcc.ParentId = Acc.Id;
		legalAcc.Type = 'Vendor';
		insert legalAcc;
		Account acc1 = new Account();
		acc1.Name = 'Testing RMANUMBER FIELD';
		acc1.ParentId = Acc.Id;
		acc1.Logistic_Account_Type__c = 'Bill-To';
		acc1.ngERP__c = '1';
		acc1.BillingCountry = 'India';
		acc1.BillingStreet = 'Gachibowli, Gachibowli';
		acc1.BillingCity = 'Hyderabad';
		acc1.BillingPostalCode = '500071';
		acc1.BillingState = 'TELANGANA';
		acc1.Market__c = 'Market India';
		acc1.RecordTypeId = accountRecordType;
		insert acc1;
		//insert parent case					 
		Case ca = new Case();
		ca.RecordTypeId = parentCaseRecordType;
		ca.AccountId = legalAcc.Id;
		ca.Hws_Ship_to_Party_Address__c= acc1.Id;
		ca.Status='Closed';
		ca.Subject='Test Subject';
		ca.Description='test Description';
		ca.HWS_ShipTopartyId__c='1234566';
		ca.Describe__c = 'Test description3';
		ca.Country__c ='United States of America';		 
		insert ca;
		//insert child case
		Case cas = new Case();
		cas.RecordTypeId = childcase;
		cas.ParentId = ca.Id;
		cas.AccountId = legalAcc.Id;
		cas.Hws_Ship_to_Party_Address__c= acc1.Id;
		cas.HWS_Faulty_Serial_Number__c = '1234'; 
		cas.HWS_FaultyUnitMaterialCode__c = '4567';
		cas.HWS_Shippeddate__c= system.today();
		cas.HWS_LSP_Courier_Name__c = 'Test123';
		cas.HWS_TotalShippedQuantity__c = 1234;
		cas.Describe__c = 'Test description';
		cas.HWS_Bar_Code__c = 'Test data111';
		cas.HWS_Bar_Code_Ref1__c = HWS_Constants.Test123;  
		cas.HWS_RMA_Number__c='1234';
		insert cas;
		
		User queueUser = new User();
		queueUser.alias = 'CHQueueU';
		queueUser.email = 'testgmail1@mail.com';
		queueUser.emailencodingkey = 'UTF-8';
		queueUser.lastname = 'CH Queue';
		queueUser.languagelocalekey = 'en_US';
		queueUser.localesidkey = 'en_US';
		queueUser.profileid = UserInfo.getProfileId();
		queueUser.Country__c = 'Canada';
		queueUser.timezonesidkey = 'America/Los_Angeles';
		queueUser.Username = 'testgmail2345@randomemail.com';
		insert queueUser;

		HWS_DataFactory_TEST.createWGSetupServiceQuote();
	}
	static testMethod void updateCaseWithReturnDeliveryAddressTest() {  
		String JsonMsg3 = '{"RequestInfo": {"RMANumber": "1234","PartNumberReceived": "1212","PartNumberDescription": "1234","SerialNumber": "trertry","PartReceivedDate": "2016-10-30T15:27:02.000Z","Type": "UnReturned Part Quote","TransactionId": "12121","SourceSystem" : "DHUB","Action" :"Create","OrderCode": "test","OPTOnProcessStatus":"DEL","ImageReferenceInfo" : "https://www.google.com","LSPComments" : "","ExclusionCategories":[{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"},{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"}]}}';
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();		
		req.requestURI = '/services/apexrest/api/exclusionPartServiceQuoteRequest/';
		req.httpMethod = 'PUT';//HTTP Request Type
		req.requestBody = Blob.valueof(JsonMsg3);
		RestContext.request = req;
		RestContext.response= res;
		Test.startTest();	  
		HWS_DamagedPartServiceRequest.damagedPartRequest();
		Test.stopTest();
	}
	static testMethod void method1() {  
		String JsonMsg3 = '{"RequestInfo": {"RMANumber": "1234","PartNumberReceived": "1212","PartNumberDescription": "1234","SerialNumber": "trertry","PartReceivedDate": "2016-10-30T15:27:02.000Z","Type": "UnReturned Part Quote","TransactionId": "12121","SourceSystem" : "DHUB","Action" :"Create","OrderCode": "test","OPTOnProcessStatus":"DEL","ImageReferenceInfo" : "https://www.google.com","LSPComments" : "test","ExclusionCategories":[{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"},{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"}]}}';
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();		
		req.requestURI = '/services/apexrest/api/exclusionPartServiceQuoteRequest/';
		req.httpMethod = 'PUT';//HTTP Request Type
		req.requestBody = Blob.valueof(JsonMsg3);
		RestContext.request = req;
		RestContext.response= res;
		Test.startTest();	  
		HWS_DamagedPartServiceRequest.damagedPartRequest();
		Test.stopTest();
	}
	static testMethod void method2() {  
		String JsonMsg3 = '{"RequestInfo": {"RMANumber": "1234","PartNumberReceived": "1212","PartNumberDescription": "","SerialNumber": "trertry","PartReceivedDate": null,"Type": "Damaged Part Quote","TransactionId": "12121","SourceSystem" : "DHUB","Action" :"Create","OrderCode": "test","OPTOnProcessStatus":"DEL","ImageReferenceInfo" : "https://www.google.com","LSPComments" : "test cmts","ExclusionCategories":[{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"},{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"}]}}';
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();		
		req.requestURI = '/services/apexrest/api/exclusionPartServiceQuoteRequest/';
		req.httpMethod = 'PUT';//HTTP Request Type
		req.requestBody = Blob.valueof(JsonMsg3);
		RestContext.request = req;
		RestContext.response= res;
		Test.startTest();	  
		HWS_DamagedPartServiceRequest.damagedPartRequest();
		Test.stopTest();
	}
	static testMethod void method4() {  
		String JsonMsg3 = '{"RequestInfo": {"RMANumber": "1234","PartNumberReceived": "1212","PartNumberDescription": "","SerialNumber": "trertry","PartReceivedDate": null,"Type": "Damaged Part Quote","TransactionId": "12121","SourceSystem" : " ","Action" :"Create","OrderCode": "test","OPTOnProcessStatus":"DEL","ImageReferenceInfo" : "https://www.google.com","LSPComments" : "test cmts","ExclusionCategories":[{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"},{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"}]}}';
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();		
		req.requestURI = '/services/apexrest/api/exclusionPartServiceQuoteRequest/';
		req.httpMethod = 'PUT';//HTTP Request Type
		req.requestBody = Blob.valueof(JsonMsg3);
		RestContext.request = req;
		RestContext.response= res;
		Test.startTest();	  
		HWS_DamagedPartServiceRequest.damagedPartRequest();
		Test.stopTest();
	}
	static testMethod void actionTest() {  
		String JsonMsg3 = '{"RequestInfo": {"RMANumber": "1234","PartNumberReceived": "1212","PartNumberDescription": "","SerialNumber": "trertry","PartReceivedDate": null,"Type": "Damaged Part Quote","TransactionId": "12121","SourceSystem" : " ","Action" :" ","OrderCode": "test","OPTOnProcessStatus":"DEL","ImageReferenceInfo" : "https://www.google.com","LSPComments" : "test cmts","ExclusionCategories":[{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"},{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"}]}}';
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();		
		req.requestURI = '/services/apexrest/api/exclusionPartServiceQuoteRequest/';
		req.httpMethod = 'PUT';//HTTP Request Type
		req.requestBody = Blob.valueof(JsonMsg3);
		RestContext.request = req;
		RestContext.response= res;
		Test.startTest();	  
		HWS_DamagedPartServiceRequest.damagedPartRequest();
		Test.stopTest();
	}
	static testMethod void damageModify() {  
		String JsonMsg3 = '{"RequestInfo": {"RMANumber": "1234","PartNumberReceived": "1212","PartNumberDescription": "","SerialNumber": "trertry","PartReceivedDate": null,"Type": "Damaged Part Quote","TransactionId": "12121","SourceSystem" : "DHUB ","Action" :"Modify","OrderCode": "test","OPTOnProcessStatus":"DEL","ImageReferenceInfo" : "https://www.google.com","LSPComments" : "test cmts","ExclusionCategories":[{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"},{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"}]}}';
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();		
		req.requestURI = '/services/apexrest/api/exclusionPartServiceQuoteRequest/';
		req.httpMethod = 'PUT';//HTTP Request Type
		req.requestBody = Blob.valueof(JsonMsg3);
		RestContext.request = req;
		RestContext.response= res;
		Test.startTest();	  
		HWS_DamagedPartServiceRequest.damagedPartRequest();
		Test.stopTest();
	}
	
	static testMethod void method3() {  
		HWS_Service_Quote__c sq=new HWS_Service_Quote__c();
		sq.HWS_RMA_Number__c='1234';
		insert sq;
		String JsonMsg3 = '{"RequestInfo": {"RMANumber": "1234","PartNumberReceived": "","PartNumberDescription": "","SerialNumber": "trertry","PartReceivedDate": null,"Type": "UnReturned Part Quote","TransactionId": "12121","SourceSystem" : "DHUB","Action" :"Create","OrderCode": "test","OPTOnProcessStatus":"DEL","ImageReferenceInfo" : "https://www.google.com","LSPComments" : "test cmts","ExclusionCategories":[{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"},{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"}]}}';
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();		
		req.requestURI = '/services/apexrest/api/exclusionPartServiceQuoteRequest/';
		req.httpMethod = 'PUT';//HTTP Request Type
		req.requestBody = Blob.valueof(JsonMsg3);
		RestContext.request = req;
		RestContext.response= res;
		Test.startTest();	  
		HWS_DamagedPartServiceRequest.damagedPartRequest();
		Test.stopTest();
	}
	static testMethod void unReturnedModify() {  

		HWS_Service_Quote__c sq=new HWS_Service_Quote__c();
		sq.HWS_RMA_Number__c='1234';
		sq.HWS_Quote_Status__c='Cancelled';
		insert sq;
	
		String JsonMsg3 = '{"RequestInfo": {"RMANumber": "1234","PartNumberReceived": "1212","PartNumberDescription": "","SerialNumber": "trertry","PartReceivedDate": null,"Type": "UnReturned Part Quote","TransactionId": "12121","SourceSystem" : "DHUB ","Action" :"Modify","OrderCode": "test","OPTOnProcessStatus":"DEL","ImageReferenceInfo" : "https://www.google.com","LSPComments" : "test cmts","ExclusionCategories":[{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"},{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"}]}}';
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();		
		req.requestURI = '/services/apexrest/api/exclusionPartServiceQuoteRequest/';
		req.httpMethod = 'PUT';//HTTP Request Type
		req.requestBody = Blob.valueof(JsonMsg3);
		RestContext.request = req;
		RestContext.response= res;
		Test.startTest();	  
		HWS_DamagedPartServiceRequest.damagedPartRequest();
		Test.stopTest();
	}
   
	static testMethod void unReturnedModify2() {  
		HWS_Service_Quote__c sq=new HWS_Service_Quote__c();
		sq.HWS_RMA_Number__c='1234';
		sq.HWS_Quote_Status__c='Draft';
		insert sq;
	
		String JsonMsg3 = '{"RequestInfo": {"RMANumber": "1234","PartNumberReceived": "1212","PartNumberDescription": "","SerialNumber": "trertry","PartReceivedDate": null,"Type": "UnReturned Part Quote","TransactionId": "12121","SourceSystem" : "DHUB ","Action" :"Modify","OrderCode": "test","OPTOnProcessStatus":"DEL","ImageReferenceInfo" : "https://www.google.com","LSPComments" : "test cmts","ExclusionCategories":[{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"},{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"}]}}';
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();		
		req.requestURI = '/services/apexrest/api/exclusionPartServiceQuoteRequest/';
		req.httpMethod = 'PUT';//HTTP Request Type
		req.requestBody = Blob.valueof(JsonMsg3);
		RestContext.request = req;
		RestContext.response= res;
		Test.startTest();	  
		HWS_DamagedPartServiceRequest.damagedPartRequest();
		Test.stopTest();
	}
   static testMethod void noCaseTest() {  
		HWS_Service_Quote__c sq=new HWS_Service_Quote__c();
		sq.HWS_RMA_Number__c='12345';
		sq.HWS_Quote_Status__c='Draft';
		insert sq;
	
		String JsonMsg3 = '{"RequestInfo": {"RMANumber": "12345","PartNumberReceived": "1212","PartNumberDescription": "","SerialNumber": "trertry","PartReceivedDate": null,"Type": "UnReturned Part Quote","TransactionId": "12121","SourceSystem" : "DHUB ","Action" :"Modify","OrderCode": "test","OPTOnProcessStatus":"DEL","ImageReferenceInfo" : "https://www.google.com","LSPComments" : "test cmts","ExclusionCategories":[{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"},{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"}]}}';
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();		
		req.requestURI = '/services/apexrest/api/exclusionPartServiceQuoteRequest/';
		req.httpMethod = 'PUT';//HTTP Request Type
		req.requestBody = Blob.valueof(JsonMsg3);
		RestContext.request = req;
		RestContext.response= res;
		Test.startTest();	  
		HWS_DamagedPartServiceRequest.damagedPartRequest();
		Test.stopTest();
	}
	static testMethod void innerCatchTest() {  
		HWS_Service_Quote__c sq=new HWS_Service_Quote__c();
		sq.HWS_RMA_Number__c='1234';
		sq.HWS_Quote_Status__c='Draft';
		insert sq;
	
		String JsonMsg3 = '{"RequestInfo": {"RMANumber": "12345","PartNumberReceived": "1212","PartNumberDescription": "","SerialNumber": "trertry","PartReceivedDate": null,"Type": "UnReturned Part Quote","TransactionId": "12121","SourceSystem" : "DHUB ","Action" :"Modify","OrderCode": "test","OPTOnProcessStatus":"DEL","ImageReferenceInfo" : "https://www.google.com","LSPComments" : "test cmts","ExclusionCategories":[{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"},{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"}]}}';
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();		
		req.requestURI = '/services/apexrest/api/exclusionPartServiceQuoteRequest/';
		req.httpMethod = 'PUT';//HTTP Request Type
		req.requestBody = Blob.valueof(JsonMsg3);
		RestContext.request = req;
		RestContext.response= res;
		Test.startTest();	  
		HWS_DamagedPartServiceRequest.damagedPartRequest();
		Test.stopTest();
	}
	static testMethod void innerCatchTest2() {  
		String JsonMsg3 = '{"RequestInfo": {"RMANumber": 1234","PartNumberReceived": "1212","PartNumberDescription": "","SerialNumber": "trertry","PartReceivedDate": null,"Type": "UnReturned Part Quote","TransactionId": "12121","SourceSystem" : "DHUB ","Action" :"Modify","OrderCode": "test","OPTOnProcessStatus":"DEL","ImageReferenceInfo" : "https://www.google.com","LSPComments" : "test cmts","ExclusionCategories":[{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"},{ "ExclusionCategory": "test","ExlusionCategoryCode":"test","Attribute_1":"test1","RepairableFlag": "true"}]}}';
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();		
		req.requestURI = '/services/apexrest/api/exclusionPartServiceQuoteRequest/';
		req.httpMethod = 'PUT';//HTTP Request Type
		req.requestBody = Blob.valueof(JsonMsg3);
		RestContext.request = req;
		RestContext.response= res;
		Test.startTest();	  
		HWS_DamagedPartServiceRequest.damagedPartRequest();
		Test.stopTest();
	}

}