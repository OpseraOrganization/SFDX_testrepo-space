@isTest
private class QuoteRepriceControllerTest {
	
	testMethod static  void QuoteRepriceControllerTest() 
	{
		//create account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		List<Account> accounts1 = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		accounts1[0].Acc_No__c = 'Testing1';
		accounts1[0].Partner_Program__c ='';
		accounts1[0].Partner_Type__c = '';
		accounts1[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		insert accounts1;
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations; 
		
		test.startTest();
		PageReference pageRef = Page.QuoteRepriceVF;
		Test.setCurrentPage(pageRef);
		//Create Opportunity
		List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();
		opportunities1[0].End_Customer_LE__c = accounts1[0].Id;
		System.debug('opportunities1[0] : '+opportunities1[0]);
		insert opportunities1;
		
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
		proposals[0].NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Repair)';
		proposals[0].NokiaCPQ_No_of_Years__c = '2';
		proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing'; //MN airscale wifi portfolio
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId();
		proposals[0].Is_Classic_Pricing__c = true;
		proposals[0].Is_Turbo_Pricing__c = true;
		insert proposals;  
		//start - Shubham
		ApexPages.StandardController controller = new ApexPages.StandardController(proposals[0]);
		QuoteRepriceController qrc = new QuoteRepriceController(controller);	   
		qrc.QuoteReprice();
		proposals[0].Is_Classic_Pricing__c = false;
		update proposals;
		qrc.QuoteReprice();
		//End - Shubham
		test.stopTest();
	}
	
}