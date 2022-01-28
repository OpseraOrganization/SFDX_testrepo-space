/*
Class Name: CAPS_UploadAttachmentControllerTest
Date: 10-July-2018
Description: Test Class for CAPS Upload Attachment
*/
@isTest
public class CAPS_UploadAttachmentControllerTest{
	/*
		cover getselectOptions, getCHattachmentdata
	*/
	
	//Stup Data
	@testSetup
	public static void setup()
	{
		CH_AccountName__c accauth = new CH_AccountName__c();
		accauth.CH_InvalidName__c = 'Nokia';
		accauth.CH_ValidName__c = 'Nokia-OYJ';
		insert accauth;
		
		Id accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
		Account accountobj =new Account();//Create Account Object
		accountobj.Region__c='Asia and Japan';
		accountobj.Country__c ='Albania';
		accountobj.name='accountName';
		accountobj.Market_Segment__c='CABLE';
		accountobj.Activity_Sector_Name__c = 'CABL-CABlE PROVIDERS';
		accountobj.Website='Nokia.com';
		accountobj.Customer_Compliance__c='unassign';
		if(accountRecordTypeId != null){
			accountobj.RecordTypeId =accountRecordTypeId;
			
			
			accountobj.BusinessPartnerRole__c='Alliance';
			//accountobj.Market__c='Market India';
			accountobj.CBT_CT_Code__c ='INDIA ID CT Idea';
			accountobj.BillingCity ='Chennai' ;
			accountobj.BillingCountry='india';
			accountobj.BillingLatitude=13.0827;
			accountobj.BillingLongitude=80.2707;
			accountobj.BillingPostalCode='600075';
			accountobj.BillingState='tamil nadu';
			accountobj.BillingStreet='water well street';
			insert accountobj;
			
			/*Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
			Account acc = new Account();
			acc.Name = 'Account';
			acc.AccountNumber = '301001643';
			acc.recordtypeid = custRecordTypeId ;
			insert acc;*/
			
			Product2 productObj =new Product2();//Create Product Object
			productObj.Name ='TestProduct';
			productObj.DataUsage__c='productObj Data Usage';
			productObj.NCP_CAREACTIVATE__c='productObj NCP AREACTIVATE c';
			productObj.PMD_Portfolio_Classification__c='Product';
			insert productObj;
			
		  /*  CH_Workgroup__c WorkgroupObj = new   CH_Workgroup__c();
			WorkgroupObj.Name ='testWorkgroup';
			WorkgroupObj.CH_Workgroup_Instructions__c ='Test Instructions ';
			insert WorkgroupObj; */
			
			 List<Account> accountList = new  List<Account>();
				List<Account> accountListTemp = new  List<Account>();
				Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
				Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
				accountList = TestDataFactory.createAccount(2);
				accountList[0].recordtypeid = custRecordTypeId;
				accountList[1].recordtypeid = LERecordTypeId;
				
				database.insert(accountList[0]); 
				accountList[1].parentid = accountList[0].id;
				accountList[1].Default_Legal_Entity__c = false;
				accountList[1].AccountNumber = '1000087011';
				database.insert(accountList[1]); 
			
			CaseMilestone caseMilestoneObj = new CaseMilestone();
			
			
			Contact con = new Contact();
			con.FirstName = 'Showket';
			con.LastName = 'Bhat';
			con.CurrencyIsoCode = 'EUR';
			con.Phone = '1234234534';
			con.Market__c = 'Market India';
			con.CH_PreferredMtdOfServiceCommunication__c = 'Email';
			con.CH_ContactTimeZone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
			con.Email = 'showket.bhat@accenture.com';
			con.CH_ContactType__c = 'Customer';
			con.accountId = accountobj.Id;
			Insert con;	
			
		   
			
			List<Case> listCase = new List<Case>();
			Case caseObj = new Case();
			caseObj.AccountId =accountList[1].Id ;
			caseObj.ProductId = productObj.Id;
		   // caseObj.CH_Workgroup__c=WorkgroupObj.Id;
			caseObj.CreatedDate=Date.today();
			caseObj.OwnerId = UserInfo.getUserId();
			caseObj.Status = 'Created';
			caseObj.Country__c = 'India';
			caseObj.CH_Outage__c = 'No';
			caseObj.CH_InitialDiagnosis__c = 'testt';
			caseObj.Severity__c = 'Minor';
			caseObj.CH_IssueOccurenceDate__c = Date.today();
			caseObj.of_Employees_to_represent_Nokia_CP__c = '0-10%';
			caseObj.Subject = 'Test call';
			caseObj.Description = 'test description';
			caseObj.CH_ProblemDisassociationReason__c='test';
			caseObj.RecordTypeId =Schema.SObjectType.case.getRecordTypeInfosByName().get('Nokia Standard Case').getRecordTypeId();
			caseObj.CH_Reassignment__c=true;
			caseObj.ContactId=con.Id;
			insert caseObj;
			listCase.add(caseObj);
		  
	}
	}
	
	public testMethod static void test1(){
		CH_Attachment__c chObj = new CH_Attachment__c();
		system.runAs(new User(Id = UserInfo.getUserId())){
			CAPS_TestDataUtil.createCustomSettingsData();
			Case caseList = new Case();
			caseList = [Select Id ,caseNumber From case  Limit 1 ];
			//insert caseList;
			
			CAPS_UploadAttachmentController.isCommunity();		 
			CAPS_UploadAttachmentController.getselectOptions(chObj, 'CH_Classification__c');
			CAPS_UploadAttachmentController.getCHattachmentdata(caseList.Id,true,'test.txt','test',5,'Other Information','66128736298h8900');
			//CAPS_UploadAttachmentController.getCHattachmentdata(caseList.Id,true,'test.txt','test',5,'Other Sensitive Information','66128736298h8900');
		}
	}
	/*
		for partnumber 1
	*/
	public testMethod static void test2(){
		CH_Attachment__c chObj = new CH_Attachment__c();
		system.runAs(new User(Id = UserInfo.getUserId())){
			CAPS_TestDataUtil.createCustomSettingsData();
			Case caseList = new Case();
			caseList = [Select Id ,caseNumber From case  Limit 1 ];
			//insert caseList;
			
			Map<String,String> partNumVsEtagMap = new Map<String,String>();
			CAPS_UploadResponseWrapper wrapperFromJs = new CAPS_UploadResponseWrapper();
			wrapperFromJs.attachmentId = 'df330b2ea42b4e55b61f2647eb710f89';
			wrapperFromJs.s3keyname = 'df330b2ea42b4e55b61f2647eb710f89/test.txt';  
			wrapperFromJs.fileid = '411952';
			wrapperFromJs.signer = 'bdc7f90cef7345c984f9e34d25e0c192';
			wrapperFromJs.user = 'app_salesforce';
			wrapperFromJs.signtoken = '63823fceca9aeed2-842e632dcc8ae6348177520d00057bd975e949cccd4791fde62e28b494a5e386';
			wrapperFromJs.expiration = '1532757105';
			wrapperFromJs.permission = 'RW';
			wrapperFromJs.acl = 'private';
			wrapperFromJs.aws_url = 'https://s3.capsv.nokia.com/a848be61/us2';
			wrapperFromJs.bucket = 'capsvtest1';
			wrapperFromJs.aws_key = 'RZZVJKQRQUBLHMVWYTJ_';
			wrapperFromJs.uploadId = '2~ijxcVVOnMUT7dCtnf6WEvREyldaGng-';
			wrapperFromJs.partNumVsEtagMap = partNumVsEtagMap;
			String wrappertoSernd = JSON.serialize(wrapperFromJs);
			test.startTest();
			Test.setMock(HttpCalloutMock.class, new CAPS_UploadAttachMockHttpResponse());
			CAPS_UploadAttachmentController.saveChunk(caseList.Id,true,'test.txt','dGVzdDI%3D','text/plain','','test','Other Information',5,1,true,wrappertoSernd);
			test.stopTest();
		}
	}
	/*
		for partnumber 2
	*/
	   public testMethod static void test3(){
		CH_Attachment__c chObj = new CH_Attachment__c();
		system.runAs(new User(Id = UserInfo.getUserId())){
			CAPS_TestDataUtil.createCustomSettingsData();
			Case caseList = new Case();
			caseList = [Select Id ,caseNumber From case  Limit 1 ];
			//insert caseList;
		  
			Map<String,String> partNumVsEtagMap = new Map<String,String>();
			CAPS_UploadResponseWrapper wrapperFromJs = new CAPS_UploadResponseWrapper();
			wrapperFromJs.attachmentId = 'df330b2ea42b4e55b61f2647eb710f89';
			wrapperFromJs.s3keyname = 'df330b2ea42b4e55b61f2647eb710f89/test.txt';  
			wrapperFromJs.fileid = '411952';
			wrapperFromJs.signer = 'bdc7f90cef7345c984f9e34d25e0c192';
			wrapperFromJs.user = 'app_salesforce';
			wrapperFromJs.signtoken = '63823fceca9aeed2-842e632dcc8ae6348177520d00057bd975e949cccd4791fde62e28b494a5e386';
			wrapperFromJs.expiration = '1532757105';
			wrapperFromJs.permission = 'RW';
			wrapperFromJs.acl = 'private';
			wrapperFromJs.aws_url = 'https://s3.capsv.nokia.com/a848be61/us2';
			wrapperFromJs.bucket = 'capsvtest1';
			wrapperFromJs.aws_key = 'RZZVJKQRQUBLHMVWYTJ_';
			wrapperFromJs.uploadId = '2~ijxcVVOnMUT7dCtnf6WEvREyldaGng-';
			wrapperFromJs.partNumVsEtagMap = partNumVsEtagMap;
			String wrappertoSernd = JSON.serialize(wrapperFromJs);
			test.startTest();
			Test.setMock(HttpCalloutMock.class, new CAPS_UploadAttachMockHttpResponse());
			CAPS_UploadAttachmentController.saveChunk(caseList.Id,true,'test.txt','dGVzdDI%3D','text/plain','','test','Other Information',5,2,true,wrappertoSernd);
			test.stopTest();
		}
	}
}