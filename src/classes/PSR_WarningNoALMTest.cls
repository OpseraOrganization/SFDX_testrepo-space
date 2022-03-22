/**
* @name	PSR_WarningNoALMTest
* @author   
* @since   Oct , 2017
* @desc	This class helps create customized test data, used in test classes
* @history 
*/
@isTest
private class PSR_WarningNoALMTest{
	
	static testMethod void opptyNoALMErrorMessageTestMethod() {
		//creating user
		user userCreation = TestDataFactory.userCreation(1,GlobalConstants.SYSTEM_AdMINISTRATOR)[0];
		insert userCreation;
		system.runAs(userCreation){
			//creating Account
			Account acc = TestDataFactory.createAccount(1)[0];
			database.insert(acc);
			
			//insert opportunity
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,acc)[0];			
			optyCreation.RecordTypeId=  Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
			optyCreation.Lead_BG__c = 'MN';
			optyCreation.Lead_BU__c = 'MN';
			database.insert(optyCreation);
			
			//Creating Presales Oppty
			List <Opportunity> preSalesTest = TestDataFactory.preSalesOpportunityCreation(1, acc, optyCreation);			
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Type__c = GlobalConstants.RISK_ORDER;
			preSalesTest[0].PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = GlobalConstants.RISK_ORDER_ONLY;
			preSalesTest[0].CurrencyIsoCode = 'USD';
			database.insert(preSalesTest);
			
			test.startTest();
			PSR_WarningNoALM.opptyNoALMErrorMessage(preSalesTest[0].Id);
			PSR_WarningNoALM.opptyNoALMErrorMessage(null);
			test.stopTest();
		}
	}
}