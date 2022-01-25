@IsTest
public class CRM_CreateOpportunityApexCtlrTest {
   
	private static testMethod void CreateOpptyUnitTestIndirect() 
	{  
		List<Opportunity> OppList1 = new  List<Opportunity>();
		List<Account> accList1 = new  List<Account>();
		List<Contact> conList = new List<Contact>();
		List<campaign> campaignList1= new List<campaign>();
		List<CampaignMember> campmbList= new List<CampaignMember>();

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
		acc2.BillingStreet = '1660 International Dr';
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
		OppList1.add(opp1);
		
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
		con.accountId = accList1[1].Id;
		con.Campaign_Name__c='Test camp1';
		conList.add(con);
		database.insert(conList);
		
		CampaignMember campmb = new CampaignMember();
		campmb.contactid=conList[0].id;
		campmb.campaignid=campaignList1[0].id;
		campmbList.add(campmb);
		database.insert(campmbList);
		
		Test.startTest();		
		CRM_CreateOpportunityApexCtlr.getFormData(con.Id);
		CRM_CreateOpportunityApexCtlr.getFormData(accList1[1].Id);
		CRM_CreateOpportunityApexCtlr.saveIndirectOpportunityWithAccount(OppList1[0],accList1[1].Id,accList1[0].Id);
		//Exception Handling
		// CreateOpportunityApexCtlr.saveIndirectOpportunityWithContact(null,conList1[0].Id,campaignList1[0].Id,accList1[1].Id,accList1[0].id);
		// 
		Test.stopTest();
	}
	
	private static testMethod void remClassMethod() {  
		CRM_CreateOpportunityApexCtlr.getAllCurrencyValues();
		CRM_CreateOpportunityApexCtlr.getAllOppTypesValues();
		CRM_CreateOpportunityApexCtlr.getAllContractSigningValues();
		CRM_CreateOpportunityApexCtlr.getAllAccountRoleValues(); 
		CRM_CreateOpportunityApexCtlr.getAccountRoleDefaultValue(GlobalConstants.PARTNER_TYPE_DISTR, CRM_CreateOpportunityApexCtlr.getAccountRoleMappings());
		
	}
}