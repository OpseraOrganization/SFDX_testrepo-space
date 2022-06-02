/****************************************
* Name : Home_Page_offers
* Author : Accenture
* Description : Test class Home_Page_offers
*****************************************/

@IsTest
private class Home_Page_offersTest{
	public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();
	static testmethod void getProposalTest(){
			Account acct = TestDataFactory.createAccount(1)[0];
			database.insert(acct);
			Opportunity oppty = TestDataFactory.OpportunityCreation(1,acct)[0];
			oppty.StageName = 'Develop Opportunity';
			oppty.Phase_Status__c = 'Opportunity in Progress';
			oppty.Lead_BG__c = 'MN';
				
			insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
			
			database.insert(oppty);
		
		
			  Apttus_Proposal__Proposal__c quoteProposal = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
			  quoteProposal.NokiaCPQ_Portfolio__c = 'IP Routing';
			  quoteProposal.NokiaCPQ_SSP_Level__c = 'Unlimited';
				quoteProposal.Apttus_Proposal__Opportunity__c=oppty.id;
				 quoteProposal.RecordTypeId=swxQuoteRecordTypeId;
			  database.insert(quoteProposal);
			  Home_Page_Offers.getProposal();	
		
	}
	
}