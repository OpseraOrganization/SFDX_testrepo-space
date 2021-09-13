@IsTest
public class CreateOpportunityApexCtlrTest {
	
	private static testMethod void createOpptyUnitTestDirect() {  
		
		List<Opportunity> oppList = new  List<Opportunity>();
		List<Account> accList = new  List<Account>();
		List<Contact> conList = new List<Contact>();
		List<campaign> campaignList= new List<campaign>();
		List<campaign> campaignList1= new List<campaign>();
		List<CampaignMember> campmbList= new List<CampaignMember>();
		
		Account acc = new Account();  
		acc.Name = 'Test Account -';
		acc.BillingStreet = '1662 International Dr';
		acc.BillingCity = 'McLean';
		acc.BillingState = 'maharashtra';
		acc.BillingPostalCode = '22102';
		acc.BillingCountry = 'india';
		acc.AccountStatusInCRMOM__c = 'Active';
		acc.Industry='Enterprise';
		acc.Market__c='Market India';
		acc.Country__c='India';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(GlobalConstants.CUSTOMER_DEVNAME).getRecordTypeId();
		acc.AccountNumber='301030871';
		accList.add(acc);
		database.insert(accList);
		
		InvalidEmailDomain__c objInv = new InvalidEmailDomain__c();
		objInv.Domain__c = 'nokia,alcatel,alcatel-lucent,nsn,gmx,hotmail,web,gmail,yahoo';
		insert objInv;
		
		list <File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new list <File_Sharing_Custom_Setting__c> ();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		
		String PurchRole='Approver';	
		
		Campaign camp1 = new Campaign();
		camp1.Name = 'Test camp1';
		camp1.CurrencyIsoCode = 'EUR';
		camp1.Campaign_id__c = 'T9901658'; 
		campaignList1.add(camp1);
		insert campaignList1;
		
		Contact con = new Contact();
		con.FirstName = 'John';
		con.LastName = 'Doe';
		con.CurrencyIsoCode = 'EUR';
		con.Email = 'abc@accenture.com';
		con.accountId = accList[0].Id;
		con.Campaign_Name__c='Test camp1';
		conList.add(con);
		database.insert(conList);
		
		CampaignMember campmb = new CampaignMember();
		campmb.contactid=conList[0].id;
		campmb.campaignid=campaignList1[0].id;
		campmbList.add(campmb);
		database.insert(campmbList);
		
		Opportunity opp = new Opportunity();
		opp.Name = 'Test Opportunity';
		opp.StageName = 'Identify Opportunity';
		opp.Contract_Signing_Entity__c = 'fALU';
		opp.Phase_Status__c = 'Planned';
		opp.CurrencyIsoCode='USD';
		opp.Business_Type__c = 'Standard Opportunity';
		opp.Unweighted_Amount_EUR__c=0;
		opp.AccountId = accList[0].id;
		opp.CloseDate = system.today();
		opp.G2_Planned_Date__c = system.today();
		opp.G3_Planned_Date__c = system.today()+1;
		opp.G4_Planned_Date__c = system.today()+2;
		opp.G5_Planned_Date__c = system.today()+3;
		opp.G6_Planned_Date__c = system.today()+4;
		oppList.add(opp);
		
		Campaign camp = new Campaign();
		camp.Name = 'Test Campaign';
		camp.CurrencyIsoCode = 'EUR';
		camp.Marketing_Campaign_Opportunity__c = oppList[0].id;
		camp.Campaign_ID__c = 'T238724';
		campaignList.add(camp);
		database.insert(campaignList);
		
		Opportunity objCreateOppty = new Opportunity();
		
		objCreateOppty = CreateOpportunityApexCtlr.saveOpportunityWithContact(oppList[0],conList[0].Id,campaignList[0].Id,accList[0].Id,PurchRole);
		//Exception Handling
		//CreateOpportunityApexCtlr.saveOpportunityWithContact(Null,conList[0].Id,campaignList[0].Id,accList[0].Id);	 
		CreateOpportunityApexCtlr.getContact(conList[0].Id);
		CreateOpportunityApexCtlr.getCampaign(conList[0].Id);
		
		
	}
	private static testMethod void createOpptyUnitTestIndirect() {  
		
		List<Opportunity> oppList1 = new  List<Opportunity>();
		List<Account> accList1 = new  List<Account>();
		List<Contact> conList1 = new List<Contact>();
		List<campaign> campaignList1= new List<campaign>();
		
		Account acc = new Account();  
		acc.Name = 'Test Account -';
		acc.BillingStreet = '1660 International Dr';
		acc.BillingCity = 'McLean';
		acc.BillingState = 'maharashtra';
		acc.BillingPostalCode = '22102';
		acc.BillingCountry = 'india';
		acc.AccountStatusInCRMOM__c = 'Active';
		acc.Industry='Enterprise';
		acc.Market__c='Market India';
		acc.Country__c='India';
		acc.Active__c = true;
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(GlobalConstants.LEGAL_ENTITY_DEVNAME).getRecordTypeId();
		acc.AccountNumber='301030871';
		accList1.add(acc);
		
		Account acc2 = new Account();  
		acc2.Name = 'Test Account - 2';
		acc2.BillingStreet = '1661 International Dr';
		acc2.BillingCity = 'McLean';
		acc2.BillingState = 'maharashtra';
		acc2.BillingPostalCode = '22102';
		acc2.BillingCountry = 'india';
		acc2.AccountStatusInCRMOM__c = 'Active';
		acc2.Industry='Enterprise';
		acc2.Market__c='Market India';
		acc2.Country__c='India';
		acc2.Active__c = true;
		acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(GlobalConstants.CUSTOMER_DEVNAME).getRecordTypeId();
		acc2.AccountNumber='301030872';
		acc2.BusinessPartnerRole__c = 'Distributor';
		accList1.add(acc2);
		database.insert(accList1);
		
		InvalidEmailDomain__c objInv = new InvalidEmailDomain__c();
		objInv.Domain__c = 'nokia,alcatel,alcatel-lucent,nsn,gmx,hotmail,web,gmail,yahoo';
		insert objInv;
		
		list <File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new list <File_Sharing_Custom_Setting__c> ();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		String PurchRole='Approver';
		
		Contact con = new Contact();
		con.FirstName = 'John';
		con.LastName = 'Doe';
		con.CurrencyIsoCode = 'EUR';
		con.Email = 'abc@accenture.com';
		con.accountId = accList1[1].Id;
		con.Purchasing_Role__c=PurchRole;
		conList1.add(con);
		database.insert(conList1);
		
		Opportunity opp1 = new Opportunity();
		opp1.Name = 'Test Opportunity1';
		opp1.StageName = 'Identify Opportunity';
		opp1.Contract_Signing_Entity__c = 'fALU';
		opp1.Phase_Status__c = 'Planned';
		opp1.CurrencyIsoCode='USD';
		opp1.Account_Role__c = 'Disti+SPaaP';
		opp1.Business_Type__c = 'Standard Opportunity';
		opp1.End_Customer__c = accList1[0].id;
		opp1.Unweighted_Amount_EUR__c=0;
		opp1.CloseDate = system.today();
		opp1.G2_Planned_Date__c = system.today();
		opp1.G3_Planned_Date__c = system.today()+1;
		opp1.G4_Planned_Date__c = system.today()+2;
		opp1.G5_Planned_Date__c = system.today()+3;
		opp1.G6_Planned_Date__c = system.today()+4;
		oppList1.add(opp1);
		
		Campaign camp = new Campaign();
		camp.Name = 'Test Campaign';
		camp.CurrencyIsoCode = 'EUR';
		camp.Marketing_Campaign_Opportunity__c = oppList1[0].id;
		camp.Campaign_ID__c = 'T233524';
		campaignList1.add(camp);
		database.insert(campaignList1);
		
		Opportunity objCreateOpptyIndirect = new Opportunity();
		
		objCreateOpptyIndirect = CreateOpportunityApexCtlr.saveIndirectOpportunityWithContact(oppList1[0],conList1[0].Id,campaignList1[0].Id,accList1[1].Id,accList1[0].id,PurchRole);
		//Exception Handling
		// CreateOpportunityApexCtlr.saveIndirectOpportunityWithContact(null,conList1[0].Id,campaignList1[0].Id,accList1[1].Id,accList1[0].id);
	}
	
	private static testMethod void remClassMethod() {  
		CreateOpportunityApexCtlr.getAllCurrencyValues();
		CreateOpportunityApexCtlr.getAllOppTypesValues();
		CreateOpportunityApexCtlr.getAllContractSigningValues();
		CreateOpportunityApexCtlr.getAllAccountRoleValues(); 
		CreateOpportunityApexCtlr.getCampaign(null);
		
	}
}