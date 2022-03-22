/***************************************************
*Class Name: OpportunityStrategyController_TEST
*Author: Bruno Palma (11/10/19)
*Description: Test class for OpportunityStrategyController
****************************************************/
@isTest
public class OpportunityStrategyController_TEST 
{
	/**************************************************/
	/*				  VARIABLES					 */
	/**************************************************/
	static List<user>		users		 = TestDataFactory.userCreation(1,'System Administrator');
	static List<Account>	 accounts	  = TestDataFactory.createAccount(1);
	static List<Opportunity> opportunities = new List<Opportunity>();

	/**************************************************/
	/*				  BEHAVIOUR					 */
	/**************************************************/
	@isTest static void userAllowedToEdit_OK()
	{
		Test.startTest();
		insert users;			   
		System.runAs(users[0])
		{			
			insert accounts;
			opportunities = TestDataFactory.OpportunityCreation(1,accounts[0]);
			opportunities[0].Phase_Status__c = 'Planned';
			insert opportunities;
			boolean result = OpportunityStrategyController.allowedUserToEdit(opportunities[0].id);
			System.assertEquals(true,result,'[OpportunityStrategyController_TEST].userAllowedToEdit_OK --> Unexpected behaviour...');			
		}
		Test.stopTest();
	}//end userAllowedToEdit_OK method

	@isTest static void userAllowedToEdit_NOK_EMPTYOPP()
	{
		Test.startTest();
		boolean result = OpportunityStrategyController.allowedUserToEdit('00629000008u2a3AAA');
		System.assertEquals(false,result,'[OpportunityStrategyController_TEST].userAllowedToEdit_NOK_EMPTYOPP --> Unexpected behaviour...');
		Test.stopTest();
	}//end userAllowedToEdit_NOK_EMPTYOPP method

	@isTest static void userAllowedToEdit_NOK_PHASE()
	{
		Test.startTest(); 
		insert users;			   
		System.runAs(users[0])
		{			
			insert accounts;
			opportunities = TestDataFactory.OpportunityCreation(1,accounts[0]);
			opportunities[0].Phase_Status__c = 'Submitted for G2 Approval';
			insert opportunities;
			boolean result = OpportunityStrategyController.allowedUserToEdit(opportunities[0].id);
			System.assertEquals(false,result,'[OpportunityStrategyController_TEST].userAllowedToEdit_NOK_PHASE --> Incorrect phase...');			
		}
		Test.stopTest();		
	}//end userAllowedToEdit_NOK_PHASE method
	
	@isTest static void userAllowedToEdit_NOK_PROFILEEMPTY()
	{
		Test.startTest();
		boolean result = OpportunityStrategyController.allowedUserToEdit('005410000054MFRAA2');
		System.assertEquals(false,result,'[OpportunityStrategyController_TEST].userAllowedToEdit_NOK_PROFILEEMPTY --> Unexpected behaviour...');
		Test.stopTest();
	}//end userAllowedToEdit_NOK_PROFILEEMPTY method

	@isTest static void userAllowedToEdit_NOK_PROFILE()
	{
		Test.startTest();
		users		 = TestDataFactory.userCreation(1,'CH_Agent');
		insert users;
		System.runAs(users[0])
		{		  
			insert accounts;
			opportunities = TestDataFactory.OpportunityCreation(1,accounts[0]);
			opportunities[0].recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Indirect Sales Opportunity For Partner').getRecordTypeId();
			insert opportunities;
			boolean result = OpportunityStrategyController.allowedUserToEdit(opportunities[0].id);
			System.assertEquals(false,result,'[OpportunityStrategyController_TEST].userAllowedToEdit_NOK_PROFILEEMPTY --> Incorrect Profile to be tested...');
		}
		Test.stopTest();
	}//end userAllowedToEdit_NOK_PROFILE method		
}//end TEST class