@isTest
private class NokiaCPQ_NotifyPricingManager_Test {
	/*@testSetup static void setup(){
Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Developer_Name').getRecordTypeId();
// your code here;
}*/
	
	static testMethod void testProcess(){
		
		List <Account> account = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		account[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		account[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		account[1].Partner_Type__c = '';
		account[1].Partner_Program__c = '';
		account[0].L2Name__c = 'Nokia Enterprise';
		account[0].CurrencyIsoCode =  'EUR';
		account[1].CurrencyIsoCode =  'EUR';
		insert account;
		
		//Create PriceList
		List<Apttus_Config2__PriceList__c> priceLists = new List<Apttus_Config2__PriceList__c>();
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True, PriceList_Type__c = 'Partner',CurrencyIsoCode = 'EUR'
		);
		priceLists.add(ApttusTestPriceList);
		
		insert priceLists;
		
		
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account);
		opportunities[0].StageName = 'Create Offer (Bid)';
		
		opportunities[0].AccountID = account[0].id;
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		 opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = account[1].id;
		opportunities[0].Contract_Price_List__c = priceLists[0].Id;
		opportunities[0].CurrencyIsoCode = 'EUR';
		insert opportunities; 
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].StageName='Create Offer (Bid)';
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();
   
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'Alliance Partner';
   
		opportunities[0].G4_Planned_Date__c =  Date.Today();
		
   
		update opportunities[0];
		
		List<User> userList = new List<User>(); 
		userList = TestDataFactory.userCreation(3, 'System Administrator');
		Database.insert(userList);
		
		List<Sales_Role__c> salesRoleList = new List<Sales_Role__c>();
		Sales_Role__c salesRoleRecord = new Sales_Role__c();
		salesRoleRecord.Role_Code__c = 'NSNA_PrMBG';
		salesRoleRecord.Organisation__c = 'Nokia Enterprise';
		salesRoleRecord.Role_Name__c = 'test role';
		salesRoleRecord.User__c = userList[0].Id;
		salesRoleList.add(salesRoleRecord);
		insert salesRoleList;
		
		List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>();
		opportunityTeamMemberList = TestDataFactory.optyTeamMemberCreation(1, userList[0], opportunities[0]);
		opportunityTeamMemberList[0].TeamMemberRole = 'Pricing Manager';
		database.insert(opportunityTeamMemberList);
		
		test.startTest();
		priceLists[0].Send_Email__c = TRUE;
		update priceLists[0];
		test.stoptest();
		
	}
	
}