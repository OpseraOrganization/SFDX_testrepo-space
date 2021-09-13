@istest
private class CampaignMemberHelperTest{

	static testMethod void campaignMemberTest1(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		List<Account> accountList = new List<Account>();
		List<Contact> contactList = new List<Contact>();
		List<Lead> leadList = new List<Lead>();
		List<campaign> campaignList= new List<campaign>();
		Set<Id> tacticIdSet = new Set<Id>();
		Set<Id> parentIdSet = new Set<Id>();
		System.runAs(userCreation){
			accountList = TestDataFactory.createAccount(1);
			insert accountList;
			contactList = TestDataFactory.createContact(2,accountList[0]);
			contactList[0].LastName = 'con1';
			contactList[1].LastName = 'con2';
			insert contactList; 
			leadList = TestDataFactory.createLead(2);
			leadList[0].Email = 'john11.doe@accenture.com';
			leadList[0].Country  = 'India';
			leadList[1].Country  = 'India';
			insert leadList; 
			
			campaign campaign1 = new campaign(Name = 'Master', IsActive = true, CurrencyIsoCode = 'USD');
			insert campaign1;
			campaign campaign2 = new campaign(Name = 'Program', IsActive = true, ParentId = campaign1.Id, CurrencyIsoCode = 'USD');
			insert campaign2;
			campaign campaign3 = new campaign(Name = 'Tactic', IsActive = true, ParentId = campaign2.Id, CurrencyIsoCode = 'USD');
			insert campaign3;
			tacticIdSet.add(campaign3.Id);
			Test.StartTest();
				CampaignMember campaignMem1 = new CampaignMember(CampaignId = campaign3.Id, LeadId = leadList[0].Id, Status = 'Sent', CurrencyIsoCode = 'USD');
				insert campaignMem1;
				CampaignMember campaignMem3 = new CampaignMember(CampaignId = campaign3.Id, ContactId = contactList[0].Id, Status = 'Sent', CurrencyIsoCode = 'USD');
				insert campaignMem3;
				campaignMem1.Status = 'Responded';
				update campaignMem1;
				delete campaignMem3;
				parentIdSet.add(campaign1.Id);
				parentIdSet.add(campaign2.Id);
				CampaignMemberHelper.campaingMemberRollUp(tacticIdSet);
				CampaignMemberHelper.updateparentCount(parentIdSet);
				Database.Undelete(campaignMem3, False);
			Test.StopTest();
		}
	}
}