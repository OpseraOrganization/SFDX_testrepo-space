/****************************************
 * Class Name : class EDP_RedboxSourceDimensionTest
 * Created Date: 1 August 2018
 * Created By : Accenture
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for loading data to dataset from EDP RedBoxSourceDimension
*****************************************/



@isTest
public class EDP_RedboxSourceDimensionTest {
@isTest
	static void test()
	{
		User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		System.runAs(thisuser){
		RB_Folder_Names__c fol=new RB_Folder_Names__c();
		fol.Name='Developer';
		fol.Folder__c='Developer';
		insert fol;
		RB_Names__c name=new RB_Names__c();
		name.Name='RB_SourceDimension';
		name.Value__c='Redbox_Account_for_SSM';
		insert name;
		RB_URLs__c url=new RB_URLs__c();
		url.Name='RedBoxSourceDimension';
		url.URL__c='https://edpqaapi.azurewebsites.net/api/RedboxSourceDimension';
		insert url;
		EDP_URLs__c edpURL = new EDP_URLs__c();
		edpURL.name = 'resource';
		edpURL.URL__c = 'https://edpqaapi.azurewebsites.net';
		insert edpURL;
		  
	   MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
	   String redpath='https://edpqaapi.azurewebsites.net/api/RedboxSourceDimension';
	   String tokenpath='https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token'; 
	   String calloutpath='callout:EDP_RB_Login';
		
	   multimock.setStaticResource(redpath,'RedboxOrdersTest');
	   multimock.setStaticResource(tokenpath,'ProductToken');
	   multimock.setStaticResource(calloutpath,'ProductToken');  
	   
	   Test.startTest();
		
	   Test.setMock(HttpCalloutMock.class, multimock); 
	   EDP_RedboxSourceDimension.fetch(); 
	  
	   
	   Test.stopTest(); 
	   }	 
	}  
}