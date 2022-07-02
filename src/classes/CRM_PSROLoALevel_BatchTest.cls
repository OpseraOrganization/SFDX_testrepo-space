@isTest
public class CRM_PSROLoALevel_BatchTest {
	
	static testmethod  void testPSROLoABatch(){
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreation);
		Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];			
		optyCreation.G3_Approval_Date__c = system.now();
		optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
		optyCreation.Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
		database.insert(optyCreation);
		//Creating Presales Oppty
		Opportunity preSalesTest = TestDataFactory.preSalesOpportunityCreation(1, accountCreation, optyCreation)[0];
		preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Type__c = GlobalConstants.RISK_ORDER;
		preSalesTest.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = GlobalConstants.RISK_ORDER_ONLY;
		database.insert(preSalesTest);
		Test.startTest();
		CRM_PSROLoALevel_Batch batch = new CRM_PSROLoALevel_Batch();
		Database.executeBatch(batch,10);
		Test.stopTest();	
	}
	
}