@isTest(SeeAllData=false)
public class NeedsRepriceTest
{
static testmethod void needReprice_InitTest1()
{

		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		 insert accounts;
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Indirect Sales Opportunity').getRecordTypeId();
		insert opportunities;  
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations;
		test.startTest();
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = false;
		proposals[0].Reprice_In_Progress__c = false;
		//proposals[0].RecordTypeId ='012290000008kdZAAQ'; //direct quote
		proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
		insert proposals;		
		List<String> partnerProgram = new List<String>();
		partnerProgram.add(accounts[0].Partner_Program__c);
		
		NeedsRepriceQuoteRepricePartnerProgram.updateQuotes(partnerProgram);  
		test.stopTest();
		  
		
		
}
	
 
}