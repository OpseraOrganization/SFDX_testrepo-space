/****************************************
 * Name : CompetitorTriggerTest 
 * Author : Accenture
 * Description : Test class for CompetitorTriggerHelper
 *****************************************/
@istest
private class CompetitorTriggerTest {
	
	
	private static List<Account> accountList = new List<Account>();
	private static List<Opportunity> opportunityList = new List<Opportunity>();
	private static List<Competitor__c> compList = new List<Competitor__c>();
	private static Id oppReadOnlyDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.READONLYDIRECT).getRecordTypeId();
 
	/***********************
	* Method Name: preventDuplicateCompetitorTest
	* Description: Sales Process : preventDuplicateCompetitor
	* Parameters: NA
	************************/
	static testMethod void preventDuplicateCompetitorTest()
	{
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			opportunityList = TestDataFactory.OpportunityCreation(2,accountList[0]);
			database.insert(opportunityList);
			compList = TestDataFactory.CompetitorCreation(2,opportunityList[0]);
			compList[0].Competitor_New__c = 'Accenture';
			compList[1].Competitor_New__c = 'Autodesk';
			database.insert(compList);
			Test.StartTest();
			Boolean isInsertFlag = true;
			compList[1].Competitor_New__c = 'Accenture';
			try{
				database.update(compList[1]);
			}
			catch(Exception e)
			{
			   Boolean expectedExceptionThrown = e.getMessage().contains(System.Label.Duplicate_Competitor) ? true : false; 
				System.assertEquals(expectedExceptionThrown, true); 
			}
		Test.stopTest();
		CompetitorTriggerHelper.preventDuplicateCompetitor(null, null, null);
	} 
/***********************
	* Method Name: onDeleteCompetitorUpdateOptyWinningCompetitorTest
	* Description: Sales Process : onDeleteCompetitorUpdateOptyWinningCompetitor
	* Parameters: NA
	************************/
	static testMethod void onDeleteCompetitorUpdateOptyWinningCompetitorTest()
	{
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			Opportunity opportunityObj = TestDataFactory.OpportunityCreation(1,accountList[0])[0];
			database.insert(opportunityObj);
			compList = TestDataFactory.CompetitorCreation(3,opportunityObj);
			compList[0].Competitor_New__c = 'Accenture';
			compList[1].Competitor_New__c = 'Adva';
			compList[2].Competitor_New__c = '2Operate';
			database.insert(compList);
		
			opportunityObj.StageName = GlobalConstants.LOST_TO_COMPETITOR;
			opportunityObj.RecordTypeId = oppReadOnlyDirectRecordTypeId;
			opportunityObj.Winning_Competitor__c = 'Accenture;Adva';
			database.update(opportunityObj);
			compList[2].Competitor_New__c = '3com';
			Test.StartTest();
			database.delete(compList[0]);
			database.delete(compList[1]);
			database.update(compList[2]);
			Test.stopTest();
			CompetitorTriggerHelper.onDeleteCompetitorUpdateOptyWinningCompetitor(null,null,null);
	} 
/***********************
	* Method Name: updateWinningCompetitorOnopptyTest
	* Description: Sales Process : updateWinningCompetitorOnoppty
	* Parameters: NA
	************************/
	static testMethod void updateWinningCompetitorOnopptyTest()
	{
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			Opportunity opportunityObj = TestDataFactory.OpportunityCreation(1,accountList[0])[0];
			database.insert(opportunityObj);
			opportunityObj.StageName = GlobalConstants.LOST_TO_COMPETITOR;
			opportunityObj.Winning_Competitor__c = 'Accenture';
			opportunityObj.RecordTypeId = oppReadOnlyDirectRecordTypeId;
			database.update(opportunityObj);
		
			Test.StartTest();
			compList = TestDataFactory.CompetitorCreation(2,opportunityObj);
			compList[0].Competitor_New__c = 'Accenture';
			compList[0].Opportunity_Won__c = true;
			compList[1].Competitor_New__c = 'Adva';
			database.insert(compList);
			compList[1].Opportunity_Won__c = true;
			database.update(compList);
			
			Test.stopTest();
			CompetitorTriggerHelper.updateWinningCompetitorOnoppty(null, null, null);
	} 
	/***********************
	* Method Name: wonShareAllocationValidationTest
	* Description: Sales Process : wonShareAllocationValidation
	* Parameters: NA
	************************/
	static testMethod void wonShareAllocationValidationTest()
	{
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			Opportunity opportunityObj = TestDataFactory.OpportunityCreation(1,accountList[0])[0];
			database.insert(opportunityObj);
			opportunityObj.StageName = GlobalConstants.LOST_TO_COMPETITOR;
			opportunityObj.Winning_Competitor__c = 'Accenture';
			opportunityObj.RecordTypeId = oppReadOnlyDirectRecordTypeId;
			database.update(opportunityObj);
			Test.StartTest();
			compList = TestDataFactory.CompetitorCreation(2,opportunityObj);
			compList[0].Competitor_New__c = 'Accenture';
			compList[0].Opportunity_Won__c = true;
			compList[0].Won_Share_Allocation_in__c = 60;
			compList[1].Competitor_New__c = 'Adva';
			compList[1].Won_Share_Allocation_in__c = 50;
			database.insert(compList);
			compList[0].Won_Share_Allocation_in__c = 70;
			compList[1].Opportunity_Won__c = true;
			try{
				   database.update(compList);
				}
			catch(Exception e)
			{
			   Boolean expectedExceptionThrown = e.getMessage().contains(System.Label.Won_Share_Error) ? true : false; 
				System.assertEquals(expectedExceptionThrown, true); 
			}
		
			Test.stopTest();
			CompetitorTriggerHelper.wonShareAllocationValidation(null, null, null);
	} 
}