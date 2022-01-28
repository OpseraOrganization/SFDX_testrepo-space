@isTest
public class DS_PBI_ReportServerControllerTest{
	
	public static OAuthApp_pbi__c app;
	
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
		
		DS_PBI_Report_URL_Setting__c objReportURLSetting = new DS_PBI_Report_URL_Setting__c();
		objReportURLSetting.DS_Technology__c ='TDD LTE';
		objReportURLSetting.DS_Use_case__c  ='Energy Efficiency';
		objReportURLSetting.Name = 'PBI Report URL';
		insert objReportURLSetting;
		
		DS_Technology_Usecase_Combination__c  tuCombination = new DS_Technology_Usecase_Combination__c();
		tuCombination.Name = 'test';
		tuCombination.DS_Technology__c='TDD LTE';
		tuCombination.DS_Usecase__c='Energy Efficiency';
		tuCombination.DS_Active__c = true;
		
		insert tuCombination;
		
		
	}
	
	public static testMethod void callRefreshToken()
	{   
	 Test.startTest();
	 Test.setMock(HttpCalloutMock.class, new DS_MockHttpResponseGenerator());
	 
	 DS_PBI_ReportServerController.tokenInfo tinfo = DS_PBI_ReportServerController.genarateAccessToken('test');
	 DS_PBI_ReportServerController.getOAuthURL();
	 DS_PBI_ReportServerController.tokenInfo tinfo1 = DS_PBI_ReportServerController.genarateAccessTokenFromRefreshToken('test');
	 List<DS_PBI_ReportServerController.techWrapper> tw =DS_PBI_ReportServerController.getUniqueTechnologies();
	 List<DS_PBI_ReportServerController.usecaseInfo> ucaseInfo =DS_PBI_ReportServerController.returnUseCaseOnTechnology('TDD LTE');
	 Test.stopTest();
	}
	
}