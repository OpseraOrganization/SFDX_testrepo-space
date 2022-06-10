/***************************************************************
 * Class Name : Scheduler_CAPSStatusUpdateBatchTest
 * Created Date: 
 * Description : Test class for Scheduler_CAPSStatusUpdateBatch &
 *	  Batch_CAPSStatusUpdate
***************************************************************/
@isTest
public class Scheduler_CAPSStatusUpdateBatchTest {
	private static final String FAKE_RESPONSE_JSON = '{ "id":"2cc6dacf201d4fa0b16dcbd1ce89ee82",  "owner":"app_salesforce",	"owner_name":" ",	"owner_email":"ignore@nokia.com",	"app":"Salesforce",	"classification":{		"id":1,	"name":"Test.Encrypted.zip"	},	"classifications":[		{	 "id":1,	"name":"Service Provider End User Information"	}	],	"nctclassification":1,	"customer":{		"id":31502,	"id_cdb":"76521",	"name":"Verizon Wireless, US",	"country_code":"US"	},	"product":{		"id":262,	"id_cdb":"134-073605_00",	"id_caps_identifier":"netact-sw",	"name":"NetAct"	},	"productversion":null,	"ticket":{		"id":13692,	"app_name":"Salesforce",	"ticket_id":"00012827"	},	"description":"yellow",	"purpose":"Case Handling",	"files":[		{	 "id":437132,	"name":"test file.txt.scrambled.zip",	"size":0,	"type":"scrambled",	"status":"scrambling",	"s3keyname":"2cc6dacf201d4fa0b16dcbd1ce89ee82/test file.txt.scrambled.zip",	"processing_time":null,	"s3_time":null,	"dpc_id":null,	"virus_scan_status":0	}	],	"creation_time":"2018-08-28T11:15:43.115328-05:00",	"deletion_time":null,	"retention_days":null,	"status":null,	"encryption_key":"02523f413473f13c07c1aaf411a8d048",	"evaporate":{		"sign_params":{	 "signer":"bdc7f90cef7345c984f9e34d25e0c192",	"signtoken":"f8bb32bf83918412-f57b22117bca6f76726896a718c7f9741adcb5deca0347e542777380ad2936ac",	"permission":"R",	"user":"ggundra",	"expiration":1535473666	},	"aws_url":"https://s3.capsv.nokia.com/a848be61/us2",	"signer_url":"https://capsv.nokia.com/93f6cc8e/api/s3sign",	"bucket":"capsvtest1",	"part_size":33554432,	"max_concurrent_parts":2,	"aws_key":"RZZVJKQRQUBLHMVWYTJ_",	"acl":"private"	},	"download_url":"https://capsv.nokia.com/93f6cc8e/downloadattachment?id=2cc6dacf201d4fa0b16dcbd1ce89ee82",	"download_url_external":"https://capsv.nokia.com/93f6cc8e/external/downloadattachment?id=2cc6dacf201d4fa0b16dcbd1ce89ee82",	"skip_scrambling":false,	"service_class":"CARE",	"nct_lawful_intercept":null,	"nct_case_status":null,	"customer_visible":true,	"retentiondaysleft":"N/A",	"capsrt_issue":86811 }';
	Date todayMinus3 = system.today().addDays(-3);
	Date todaysDate = system.today();
	String query = Label.CAPS_StatusUpdateBatchQuery;
	private class Mock implements HttpCalloutMock {
		
		public HTTPResponse respond(HTTPRequest req) {
			// You could assert the request content here
			HTTPResponse res = new HTTPResponse();
			res.setBody(FAKE_RESPONSE_JSON);
			res.setStatusCode(200);
			return res;
		}
	}
	
	 @testSetup 
	static void setup() {
		CAPS_TestDataUtil.createCustomSettingsData();
		CH_DisableCH_AttachmentTrigger__c chSet1 = new CH_DisableCH_AttachmentTrigger__c();
		chSet1.Name = 'BaseUrl';
		chSet1.SetupOwnerId = Userinfo.getUserId();
		chSet1.CH_Disable__c = true;
		insert chSet1;
		CH_Attachment__c chAtachObj = new CH_Attachment__c();
		chAtachObj.Name = 'Test Attachment' ;
		chAtachObj.File_Name__c ='test file.txt.scrambled.zip';
		chAtachObj.CH_FileType__c ='encrypted';
		chAtachObj.AttachmentID__c = 'kfgaskfgasieug';		
		chAtachObj.CH_Classification__c = 'Other Information';
		chAtachObj.CH_Description__c = 'Test' ;
		chAtachObj.CH_Puropse__c = 'Test';
		chAtachObj.CH_Service_Class__c = 'CARE';
		chAtachObj.CH_Size__c = 12;
		chAtachObj.CH_Status__c = 'uploading';
		chAtachObj.CH_Uploaded__c = system.today().addDays(-3);
		chatachObj.CH_MarkForDelete__c =True;  
		chatachObj.CH_NoSuchFileinCAPS__c = False;
		insert chAtachObj;
		
	 
		CH_Attachment__c chAtachObj1 = new CH_Attachment__c();
		chAtachObj1.Name = 'Test Attachment' ;
		chAtachObj1.File_Name__c ='test file.txt.scrambled.zip';
		chAtachObj1.CH_FileType__c ='encrypted';
		chAtachObj1.AttachmentID__c = 'kfgaskfgasieug';		
		chAtachObj1.CH_Classification__c = 'Other Information';
		chAtachObj1.CH_Description__c = 'Test' ;
		chAtachObj1.CH_Puropse__c = 'Test';
		chAtachObj1.CH_Service_Class__c = 'CARE';
		chAtachObj1.CH_Size__c = 12;
		chAtachObj1.CH_Status__c = 'uploading';
		chAtachObj1.CH_Uploaded__c =system.today().addDays(-3);
		chatachObj1.CH_MarkForDelete__c =false;   
		chatachObj1.CH_NoSuchFileinCAPS__c = False;
		insert chAtachObj1;
	
		
		CH_Attachment__c chAtachObj2 = new CH_Attachment__c();
		chAtachObj2.Name = 'Test Attachment' ;
		chAtachObj2.File_Name__c ='abc';
		chAtachObj2.CH_FileType__c ='encrypted';
		chAtachObj2.AttachmentID__c = 'kfgaskfgasieugk';		
		chAtachObj2.CH_Classification__c = 'Other Information';
		chAtachObj2.CH_Description__c = 'Test' ;
		chAtachObj2.CH_Puropse__c = 'Test';
		chAtachObj2.CH_Service_Class__c = 'CARE';
		chAtachObj2.CH_Size__c = 12;
		chAtachObj2.CH_Status__c = 'uploading';
		chAtachObj2.CH_Uploaded__c = system.today().addDays(-3);
		chatachObj2.CH_MarkForDelete__c =True;		
		chatachObj2.CH_NoSuchFileinCAPS__c = False;
		insert chAtachObj2;
	}

	  /*
	  test method for Scheduler_CAPSStatusUpdateBatch 
	*/  
	static testmethod void schedulerTest() 
	{
		String CRON_EXP = '0 30 * * * ?';   
		
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new Mock());
		//CAPS_TestDataUtil.createCustomSettingsData();
		String jobId = System.schedule('ScheduleApexClassTest',  CRON_EXP, new Scheduler_CAPSStatusUpdateBatch());
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
		System.assertEquals(CRON_EXP, ct.CronExpression);
		System.assertEquals(0, ct.TimesTriggered);
		Test.stopTest();
	}
	
	 /*
	  test method for Batch_CAPSStatusUpdate
	*/  
	static testmethod void Batch_CAPSStatusUpdateTest1() 
	{		
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new Mock());
		//CAPS_TestDataUtil.createCustomSettingsData();
		CH_Attachment__c ch = new CH_Attachment__c ();
		String query = 'SELECT Id,CH_NoSuchFileinCAPS__c,Name,File_Name__c,CH_MarkForDelete__c,CH_Actual_Delete_Date__c,CH_FileType__c,AttachmentID__c,CH_Status__c,CH_Uploaded__c FROM CH_Attachment__c WHERE (CH_Status__c !=\'Ready\' AND CH_Status__c !=\'Deleted\' AND CH_Status__c !=\'On Hold\' AND CH_Uploaded__c >= : todayMinus3) OR (CH_MarkForDelete__c = true AND CH_Actual_Delete_Date__c = null AND CH_Expected_Delete_Date__c >= : todayMinus3 AND CH_Expected_Delete_Date__c <= : todaysDate)';
		Batch_CAPSStatusUpdate  batchObj = new Batch_CAPSStatusUpdate (query,'');
		Id batchId = Database.executeBatch(batchObj);
		system.assertNotEquals(batchId ,null);
		Test.stopTest();
	}
}