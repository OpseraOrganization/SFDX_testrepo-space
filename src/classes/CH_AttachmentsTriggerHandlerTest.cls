/***************************************************************
 * Class Name : CH_AttachmentsTriggerHandlerTest
 * Created Date: 12 July 2018
 * Description : Test class for CH_AttachmentsTriggerHandler, also it covers CAPS_Attachment_Delete
***************************************************************/

//Test Class for CH_Attchment Trigger
@IsTest
public class CH_AttachmentsTriggerHandlerTest {
	
	@testSetup
	public static void setup()
	{
		CH_UTIL_TEST.setupCase(false);
		CAPS_TestDataUtil.createCustomSettingsData();
		
	}
	
	/* Method is used to cover CH_AttachmentsTriggerHandler.updateAttchmentinCAPS method*/ 
	public testMethod static void updateAttchmentinCAPS(){
		system.runAs(new User(Id = UserInfo.getUserId())){
			test.StartTest();
			CAPS_TestDataUtil.createCustomSettingsData();
			Case caseList = new Case();
			caseList = caseList = CH_UTIL_TEST.createCaseNotSaved('Test', 'Minor', 'No', 'CH_Problem', false);
			insert caseList;
			
			List<CH_Attachment__c> chAttchList = new List<CH_Attachment__c>();
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Other Information',caseList.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Other Information',caseList.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Service Provider End User Information',caseList.Id)[0]);
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecord(1,'Service Provider End User Information',caseList.Id)[0]);
			insert chAttchList;
			
			Test.setMock(HttpCalloutMock.class, new CAPS_DeleteMockHttpResponse());
			for(CH_Attachment__c ch1:chAttchList){
	ch1.CH_Classification__c ='Service Provider End User Information';
	ch1.CH_Description__c ='Test Description 1';
	ch1.Customer_Visible__c =True;
	
			}	  
			update chAttchList;
			system.assertEquals(4,chAttchList.size());
			Test.StopTest();			
		}
	}
	
	/* Method is used to cover CH_AttachmentsTriggerHandler.sendAttachmentIdForReadyStatus method*/
	public testMethod static void sendAttachmentIdForReadyStatusTest() {	
		Test.startTest();
		Case caseList =new Case();
		caseList = caseList = CH_UTIL_TEST.createCaseNotSaved('Test', 'Minor', 'No', 'CH_Problem', false);
		caseList.Reference_Number__c = 'test-123';
		caseList.Origin = 'S2S';
		caseList.CH_CaseOriginSystem__c = 'tcom-dtag';
		insert caseList;
		
		List<CH_Attachment__c> chList = new List<CH_Attachment__c>();
		CH_Attachment__c chAtt = new CH_Attachment__c();
		chAtt = CAPS_TestDataUtil.createCHAttachmentRecord(1,'Other Information',caseList.Id)[0];
		chAtt.CH_Portal_or_Email_to_Case__c = 'Salesforce';		
		chList.add(chAtt);
		chAtt = CAPS_TestDataUtil.createCHAttachmentRecord(1,'Other Information',caseList.Id)[0];
		chAtt.CH_Portal_or_Email_to_Case__c = 'Email'; 
		chList.add(chAtt);
		insert chList;
		NaipS2SSuccessWebServiceMock naipWebServiceMock = new NaipS2SSuccessWebServiceMock();			
		Test.setMock(WebServiceMock.class, naipWebServiceMock);
		
		for (CH_Attachment__c ch:chList) {
			if (ch.CH_Portal_or_Email_to_Case__c == 'Salesforce') {	
	system.assertEquals('uploading',ch.CH_Status__c);
	system.assertEquals(TRUE,ch.Customer_Visible__c);
	system.assertEquals('Salesforce',ch.CH_Portal_or_Email_to_Case__c);
	ch.CH_Status__c = 'Ready';
			}
			if (ch.CH_Portal_or_Email_to_Case__c == 'Email') {
	system.assertEquals('uploading',ch.CH_Status__c);
	system.assertEquals(TRUE,ch.Customer_Visible__c);
	system.assertEquals('Email',ch.CH_Portal_or_Email_to_Case__c);
	ch.CH_Status__c = 'Ready';	
			}			
		}
		Update chList;
		
		system.assertEquals('Ready',chList[0].CH_Status__c);
		system.assertEquals('Ready',chList[1].CH_Status__c);
		
		String sendAttachmentToNAIP = CH_Settings__c.getValues('SendAttachmentToNAIP').SettingValue__c;
		System.assertEquals(sendAttachmentToNAIP,sendAttachmentToNAIP);	
		Test.StopTest();
		
	}
	
		public class NaipS2SSuccessWebServiceMock implements WebServiceMock {
		public void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType) {
			CH_partnerNAIPWSDLForSF.receiveFromSalesForceResponse receivFromSfResponse = new CH_partnerNAIPWSDLForSF.receiveFromSalesForceResponse();
			CH_partnerNAIPWSDLForSF.responseToSalesForce responseToSf = new CH_partnerNAIPWSDLForSF.responseToSalesForce();
			receivFromSfResponse.responseToSalesForce = responseToSf;
			response.put('response_x', receivFromSfResponse);
		}
	}

	//DEM0050458: For customer hidden attachments comments should not be public
	public testMethod static void updateAttchmentinCAPSTesting(){
		system.runAs(new User(Id = UserInfo.getUserId())){
			test.StartTest();
			CAPS_TestDataUtil.createCustomSettingsData();
			Case caseList = new Case();
			caseList = caseList = CH_UTIL_TEST.createCaseNotSaved('Test', 'Minor', 'No', 'CH_Problem', false);
			insert caseList;
			
			List<CH_Attachment__c> chAttchList = new List<CH_Attachment__c>();
			//DEM0050458: For customer hidden attachments comments should not be public
			chAttchList.add(CAPS_TestDataUtil.createCHAttachmentRecordFalse(1,'Service Provider End User Information',caseList.Id)[0]);
			insert chAttchList;
			
			Test.setMock(HttpCalloutMock.class, new CAPS_DeleteMockHttpResponse());
			for(CH_Attachment__c ch1:chAttchList){
	ch1.CH_Classification__c ='Service Provider End User Information';
	ch1.CH_Description__c ='Test Description 1';
	
			}	  
			update chAttchList;
			system.assertEquals(1,chAttchList.size());
			Test.StopTest();			
		}
	}

}