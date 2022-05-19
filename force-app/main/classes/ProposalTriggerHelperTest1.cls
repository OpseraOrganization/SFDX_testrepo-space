@istest 
public class ProposalTriggerHelperTest1  {
   static testmethod void directInitTest1(){
	List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>();
	List<User> userList = new List<User>();  
	userList = TestDataFactory.userCreation(3, 'System Administrator');
		
		userList[0].NSA_Compliant__c = True;
		userList[0].Restriction_Level__c = 'Unrestricted';
		userList[1].Restriction_Level__c = 'Unrestricted';
		userList[2].Restriction_Level__c = 'Unrestricted';
		Database.insert(userList);	
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		 insert accounts;	  
			Account acc = new Account();
			acc.Name='Legal Entity Account For Test';
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			acc.ParentId = accounts[0].Id;
			acc.AccountNumber = '100006843';
			database.insert(acc);   
		
		
		//create opportunity with non-euro currency
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(2,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities[0].CurrencyIsoCode = 'GBP'; 
	opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities[1].CurrencyIsoCode = 'EUR'; 
		insert opportunities;  
		opportunityTeamMemberList = TestDataFactory.optyTeamMemberCreation(2, userList[0], opportunities[0]);
	opportunityTeamMemberList[1].OpportunityId = opportunities[1].Id;
		database.insert(opportunityTeamMemberList); 
		 Test.startTest();
		//create a quote with non-euro currency
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].CurrencyIsoCode = 'GBP';
		proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
		proposals[0].NokiaCPQ_Maintenance_Type__c = '';
		insert proposals;		

		//create opportunity with euro currency
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		//List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		//opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		//opportunities1[0].CurrencyIsoCode = 'EUR'; 
		//opportunities1[0].SWx_Upsell_Proposal__c = DigiObj2.Id; 
		//insert opportunities1; 
	
		Shipping_Location__c shipping_location = new Shipping_Location__c();
		shipping_location.Portfolio__c = 'IP Routing';
		shipping_location.Pricing_Cluster__c = 'Europe';
		insert shipping_location;

		//Test.startTest();
		//create a quote with non-euro currency
		List<Apttus_Proposal__Proposal__c > proposals1 = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
		proposals1[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals1[0].Apttus_Proposal__Opportunity__c = opportunities[1].Id;
		proposals1[0].CurrencyIsoCode = 'EUR';
		proposals1[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(); //direct quote
		proposals1[0].NokiaCPQ_Maintenance_Type__c = '';
		insert proposals1;   
		
		Test.stopTest();	
		
		
		
		
}
   
}