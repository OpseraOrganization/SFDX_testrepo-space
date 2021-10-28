@isTest
public class DS_PowerBIControllerTests {	
	
	public static PageReference pageRef = Page.Report;
	public static OAuthApp_pbi__c app;
	public static DS_PowerBIController pbicontroller = new DS_PowerBIController();
		
	@testSetup public static void setUp()
	{   
		app = new OAuthApp_pbi__c();
		app.Name = 'PowerBI2';
		app.Token_Expires_On__c = '0';
		app.Client_Id__c = 'clientId';
		app.Client_Secret__c = 'clientSecret';
		app.Authorization_URL__c = 'https://login.windows.net/common/oauth2/authorize';
		app.Access_Token_URL__c = 'https://login.microsoftonline.com/common/oauth2/token';
		app.Resource_URI__c = 'https://analysis.windows.net/powerbi/api';
		insert app;

		pbicontroller.application_name = 'PowerBI2';
	}
		
	public static testMethod void powerBiControllerNotNull()
	{
		System.assertNotEquals(pbicontroller, null);
	}
	
	public static testMethod void getValidateResultReturnsNotNull()
	{
		pbicontroller.validateResult = 'testResult';
		String validate = pbicontroller.getValidateResult();
		System.assertEquals('testResult', pbicontroller.getValidateResult());	   
	}
	
	public static testMethod void callRedirect()
	{
		PageReference page = pbicontroller.redirectOnCallback();		
	}
	
	public static testMethod void callRefreshToken()
	{   Test.startTest();
		Test.setMock(HttpCalloutMock.class, new DS_MockHttpResponseGenerator());
		
		pbicontroller.application_name = 'PowerBI2';
		Test.setCurrentPage(pageRef);	   

		PageReference page = pbicontroller.refreshAccessToken();
				
		String accessCookie = pbicontroller.PBIAccess_token;
		String refreshCookie =  pbicontroller.PBIRefresh_token;
		
		System.assertEquals('accessCookieToken',accessCookie);
		System.assertEquals('refreshCookieToken',refreshCookie);	
		Test.stopTest();
	}
	
	public static testMethod void loadDependentUseCaseTest()
	{   Test.startTest();
			DS_PowerBIController objPBIController= new DS_PowerBIController();
			objPBIController.selectedTechnology  = 'TDD LTE';
			objPBIController.loadDependentUsecases();
			System.assertEquals(objPBIController.usecaseSelectOption.size() > 0, true);
		Test.stopTest();
		
	}
	
	public static testMethod void testPBIURLSetting()
	{   Test.startTest();
			DS_PowerBIController objPBIController= new DS_PowerBIController();
			objPBIController.selectedTechnology  = 'TDD LTE';
			objPBIController.loadDependentUsecases();
			objPBIController.selectedUseCase   = 'Energy Efficiency';
			objPBIController.getPBIReportURL();
			
			DS_PBI_Report_URL_Setting__c objReportURLSetting = new DS_PBI_Report_URL_Setting__c();
			//objReportURLSetting.DS_Power_BI_Report_URL__c = 'https://app.powerbi.com/reportEmbed?reportId=e402bf19-2a7c-484e-98ff-4e073d86f0c0&groupId=4ab12e0b-f04c-46a2-8744-9768b2670087';
			objReportURLSetting.DS_Technology__c ='TDD LTE';
			objReportURLSetting.DS_Use_case__c  ='Energy Efficiency';
			objReportURLSetting.Name = 'PBI Report URL';
			insert objReportURLSetting;
			
			objPBIController.selectedTechnology  = 'TDD LTE';
			objPBIController.loadDependentUsecases();
			objPBIController.selectedUseCase   = 'Energy Efficiency';
			objPBIController.getPBIReportURL();
			
			objReportURLSetting.DS_Power_BI_Report_URL__c = 'https://app.powerbi.com/reportEmbed?reportId=e402bf19-2a7c-484e-98ff-4e073d86f0c0&groupId=4ab12e0b-f04c-46a2-8744-9768b2670087';
			update objReportURLSetting;
			
			objPBIController.selectedTechnology  = 'TDD LTE';
			objPBIController.loadDependentUsecases();
			objPBIController.selectedUseCase   = 'Energy Efficiency';
			objPBIController.getPBIReportURL();
			
			objPBIController= new DS_PowerBIController();
			objPBIController.selectedTechnology  = 'TDD LTE';
			objPBIController.loadDependentUsecases();
			objPBIController.selectedUseCase   = CSWXGlobalConstant.NONE_OPTION_VALUE;
			objPBIController.getPBIReportURL();
			 
			System.assertEquals(objPBIController.statusMessage, Label.DS_Usecase_Missing);
		Test.stopTest();
		
	}
	
	
	 public static testMethod void testPBIURLSettinForDiffCustomer()
	{   Test.startTest();
			DS_PowerBIController objPBIController= new DS_PowerBIController();
			objPBIController.selectedTechnology  = 'TDD LTE';
			objPBIController.loadDependentUsecases();
			objPBIController.selectedUseCase   = 'Energy Efficiency';
			objPBIController.getPBIReportURL();
			
			DS_PBI_Report_URL_Setting__c objReportURLSetting = new DS_PBI_Report_URL_Setting__c();
			//objReportURLSetting.DS_Power_BI_Report_URL__c = 'https://app.powerbi.com/reportEmbed?reportId=e402bf19-2a7c-484e-98ff-4e073d86f0c0&groupId=4ab12e0b-f04c-46a2-8744-9768b2670087';
			objReportURLSetting.DS_Technology__c ='TDD LTE';
			objReportURLSetting.DS_Use_case__c  ='Energy Efficiency';
			objReportURLSetting.Name = 'PBI Report URL';
			objReportURLSetting.DS_Customer_Account_Number__c ='123';
			insert objReportURLSetting;
			
			
			objReportURLSetting = new DS_PBI_Report_URL_Setting__c();
			//objReportURLSetting.DS_Power_BI_Report_URL__c = 'https://app.powerbi.com/reportEmbed?reportId=e402bf19-2a7c-484e-98ff-4e073d86f0c0&groupId=4ab12e0b-f04c-46a2-8744-9768b2670087';
			objReportURLSetting.DS_Technology__c ='TDD LTE';
			objReportURLSetting.DS_Use_case__c  ='Energy Efficiency';
			objReportURLSetting.Name = 'PBI Report URL2';
			objReportURLSetting.DS_Customer_Account_Number__c ='1234';
			insert objReportURLSetting;
			
			 objPBIController.getPBIReportURL();
			
		   
			 
			//System.assertEquals(objPBIController.statusMessage, Label.DS_Usecase_Missing);
		Test.stopTest();
		
	}
	
	 public static testMethod void testPBIURL()
	{   Test.startTest();
			DS_PowerBIController objPBIController= new DS_PowerBIController();
			objPBIController.selectedTechnology  = 'TDD LTE';
			objPBIController.loadDependentUsecases();
			objPBIController.selectedUseCase   = 'Energy Efficiency';
			objPBIController.getPBIReportURL();
			
			DS_PBI_Report_URL_Setting__c objReportURLSetting = new DS_PBI_Report_URL_Setting__c();
			objReportURLSetting.DS_Power_BI_Report_URL__c = 'https://app.powerbi.com/reportEmbed?reportId=e402bf19-2a7c-484e-98ff-4e073d86f0c0&groupId=4ab12e0b-f04c-46a2-8744-9768b2670087=123455';
			objReportURLSetting.DS_Technology__c ='TDD LTE';
			objReportURLSetting.DS_Use_case__c  ='Energy Efficiency';
			objReportURLSetting.Name = 'PBI Report URL';
			insert objReportURLSetting;
			
			objPBIController.selectedTechnology  = 'TDD LTE';
			objPBIController.loadDependentUsecases();
			objPBIController.selectedUseCase   = 'Energy Efficiency';
			objPBIController.getPBIReportURL();
		   
			 
			System.assertEquals(objPBIController.statusMessage, Label.DS_Report_Does_not_Exist);
		Test.stopTest();
		
	}
	
	public static testMethod void testAccessToken()
	{   
		 Test.startTest();
				DS_OAuthControllerTests.getAuthURLReturnSuccess();
				pageRef = new PageReference('https://c.eu11.visual.force.com/apex/Report?code=testCode');
				Test.setCurrentPage(pageRef);
				Test.setMock(HttpCalloutMock.class, new DS_MockHttpResponseGenerator());
				DS_PowerBIController pbicontroller = new DS_PowerBIController();
				
				Test.setMock(HttpCalloutMock.class, new DS_MockHttpResponseGenerator());
				
				pbicontroller.application_name = 'PowerBI2';
				pbicontroller.PBIAccessTokenCode = 'Code';
			   
				pbicontroller.getAccessToken();	 

		//PageReference page = pbicontroller.refreshAccessToken();
		 Test.stopTest();
	}
}