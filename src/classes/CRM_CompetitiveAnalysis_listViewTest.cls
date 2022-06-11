/****************************************
* Name : CRM_CompetitiveAnalysis_listViewTest 
* Author : CRM Dev
* Description : Test class for CRM_CompetitiveAnalysis_listViewCtrl
*****************************************/
@istest
public class CRM_CompetitiveAnalysis_listViewTest
{	
	@testSetup 
	static void datasetup() 
	{
		Account acc = TestDataFactory.createAccount(1)[0];
		acc.AccountNumber = '1234';
		insert acc;
		
		Opportunity opp = TestDataFactory.OpportunityCreation(1, acc)[0];
		opp.Name = 'test wp';
		insert opp;
		
		List<Competitor__c> compList = TestDataFactory.CompetitorCreation(2, opp);
		compList[1].Primary_Competitor__c = true;
		insert compList;
	}
	
	static testmethod void test1()
	{	
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'test wp'];		
		CRM_CompetitiveAnalysis_listViewCtrl.WrapperFull wrapper = CRM_CompetitiveAnalysis_listViewCtrl.getOppCompetitorsApex(opp.Id);
		CRM_CompetitiveAnalysis_listViewCtrl.saveCompetitorApex(wrapper.competitorWrapperList[0]);
		wrapper.competitorWrapperList[0].primary = true;
		CRM_CompetitiveAnalysis_listViewCtrl.saveCompetitorApex(wrapper.competitorWrapperList[0]);
		CRM_CompetitiveAnalysis_listViewCtrl.deleteCompetitorApex(wrapper.competitorWrapperList[0]);
		wrapper.competitorWrapperList[0].Id= null;
		CRM_CompetitiveAnalysis_listViewCtrl.saveCompetitorApex(wrapper.competitorWrapperList[0]);
		CRM_CompetitiveAnalysis_listViewCtrl.updateCommentsApex(opp.Id, 'comments');
	}
}