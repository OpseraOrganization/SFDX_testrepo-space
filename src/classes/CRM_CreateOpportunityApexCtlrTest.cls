@IsTest
public class CRM_CreateOpportunityApexCtlrTest
{ 
	@testSetup 
	static void datasetup() 
	{
		List<Opportunity> oppList = new  List<Opportunity>();
		List<Account> accList = new  List<Account>();
		List<Contact> conList = new List<Contact>();
		List<campaign> campaignList= new List<campaign>();
		List<campaign> campaignList1= new List<campaign>();
		List<CampaignMember> campmbList= new List<CampaignMember>();
		
		ProfileNames__c profileRec = new ProfileNames__c();
		profileRec.Name = 'System Administrator';
		insert profileRec;
			
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
		accList.add(acc2);
		
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
		
		Nokia_Financial_Calendar__c nokFinCal = TestDataFactory.nokiaFinCalCreation(1)[0];
		database.insert(nokFinCal);
	}
	
	private static testMethod void CreateOpptyUnitTestIndirect() 
	{  
		List<Opportunity> OppList1 = new  List<Opportunity>();
		List<Account> accList1 = new  List<Account>();
		List<Contact> conList = [SELECT Id FROM Contact];
		
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
		acc.AccountNumber='301030873';
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
		acc2.AccountNumber='301030874';
		acc2.BusinessPartnerRole__c = 'Distributor';
		accList1.add(acc2);
		database.insert(accList1);
		

		Opportunity opp1 = new Opportunity();
		opp1.Name = 'Test Opportunity1';
		opp1.StageName = 'Identify Opportunity';
		opp1.Contract_Signing_Entity__c = 'fALU';
		opp1.Phase_Status__c = 'Planned';
		opp1.CurrencyIsoCode='USD';
		opp1.Account_Role__c = 'Disti+SPaaP';
		opp1.Business_Type__c = 'Standard Opportunity';
		opp1.AccountId = accList1[0].id;
		opp1.End_Customer__c = accList1[1].id;
		opp1.Unweighted_Amount_EUR__c=0;
		opp1.CloseDate = system.today();
		opp1.G2_Planned_Date__c = system.today();
		opp1.G3_Planned_Date__c = system.today()+1;
		opp1.G4_Planned_Date__c = system.today()+2;
		opp1.G5_Planned_Date__c = system.today()+3;
		opp1.G6_Planned_Date__c = system.today()+4;
		OppList1.add(opp1);		
			
		Test.startTest();		
		CRM_CreateOpportunityApexCtlr.getFormData(accList1[1].Id);
		CRM_CreateOpportunityApexCtlr.saveIndirectOpportunityWithAccount(OppList1[0],accList1[1].Id,accList1[0].Id);
		Test.stopTest();
	}
	
	private static testMethod void CreateOpptyUnitTestDirect() 
	{  
		List<Opportunity> OppList1 = new  List<Opportunity>();
		List<Account> accList1 = [SELECT Id FROM Account WHERE Active__c = true ORDER BY AccountNumber DESC];//Customer and then Legal Entity
		List<Contact> conList = [SELECT Id FROM Contact];
	
		Opportunity opp1 = new Opportunity();
		opp1.Name = 'Test Opportunity1';
		opp1.StageName = 'Identify Opportunity';
		opp1.Contract_Signing_Entity__c = 'fALU';
		opp1.Phase_Status__c = 'Planned';
		opp1.CurrencyIsoCode='USD';
		opp1.Business_Type__c = 'Standard Opportunity';
		opp1.Unweighted_Amount_EUR__c=0;
		opp1.CloseDate = system.today();
		opp1.G2_Planned_Date__c = system.today();
		opp1.G3_Planned_Date__c = system.today()+1;
		opp1.G4_Planned_Date__c = system.today()+2;
		opp1.G5_Planned_Date__c = system.today()+3;
		opp1.G6_Planned_Date__c = system.today()+4;
		OppList1.add(opp1);
		
		Test.startTest();		
		CRM_CreateOpportunityApexCtlr.getFormData(accList1[0].Id);
		CRM_CreateOpportunityApexCtlr.saveDirectOpportunityWithAccount(OppList1[0], accList1[0].Id);
		Test.stopTest();
	}
	
	private static testMethod void CreateOpptyUnitTestDirectFromContact() 
	{  
		List<Opportunity> OppList1 = new  List<Opportunity>();
		List<Account> accList1 = [SELECT Id FROM Account WHERE Active__c = true ORDER BY AccountNumber DESC];//Customer and then Legal Entity
		List<Contact> conList = [SELECT Id FROM Contact];
		List<Campaign> campList = [SELECT Id From Campaign];
		
		Opportunity opp = new Opportunity();
		opp.Name = 'Test Opportunity';
		opp.StageName = 'Identify Opportunity';
		opp.Contract_Signing_Entity__c = 'fALU';
		opp.Phase_Status__c = 'Planned';
		opp.CurrencyIsoCode='USD';
		opp.Business_Type__c = 'Standard Opportunity';
		opp.Unweighted_Amount_EUR__c=0;
		opp.AccountId = accList1[0].id;
		opp.CloseDate = system.today();
		opp.G2_Planned_Date__c = system.today();
		opp.G3_Planned_Date__c = system.today()+1;
		opp.G4_Planned_Date__c = system.today()+2;
		opp.G5_Planned_Date__c = system.today()+3;
		opp.G6_Planned_Date__c = system.today()+4;
		OppList1.add(opp);	 
			
		Test.startTest();		
		CRM_CreateOpportunityApexCtlr.getFormData(conList[0].Id);
		CRM_CreateOpportunityApexCtlr.saveOpportunityWithContact(OppList1[0],conList[0].Id, campList[0].Id, accList1[0].Id, 'Alliance');
		Test.stopTest();
	}
	
	private static testMethod void CreateOpptyUnitTestIndirectFromContact() 
	{  
		List<Opportunity> OppList1 = new  List<Opportunity>();
		List<Account> accList1 = [SELECT Id FROM Account WHERE Active__c = true ORDER BY AccountNumber DESC];//Customer and then Legal Entity
		List<Contact> conList = [SELECT Id FROM Contact];
		List<Campaign> campList = [SELECT Id From Campaign];
		
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
			
		Test.startTest();		
		CRM_CreateOpportunityApexCtlr.getFormData(conList[0].Id);
		CRM_CreateOpportunityApexCtlr.saveIndirectOpportunityWithContact(OppList1[0],conList[0].Id, campList[0].Id, accList1[0].Id,accList1[1].Id, 'Alliance');
		Test.stopTest();
	}
	
	private static testMethod void CreateOpptyUnitTestFT() 
	{  
		System.debug('JOTATR -1');
		List<Opportunity> OppList1 = new  List<Opportunity>();
		List<Account> accList1 = [SELECT Id FROM Account WHERE Active__c = true ORDER BY AccountNumber DESC];//Customer and then Legal Entity
	  
		System.debug('JOTATR 0');
		Opportunity masterOpp = new Opportunity();
		masterOpp.recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
		masterOpp.Name = 'Test Opportunity1';
		masterOpp.StageName = 'Identify Opportunity';
		masterOpp.Contract_Signing_Entity__c = 'fALU';
		masterOpp.Phase_Status__c = 'Planned';
		masterOpp.CurrencyIsoCode='USD';
		masterOpp.Account_Role__c = 'Disti+SPaaP';
		masterOpp.Lead_BG__c = 'CNS';
		masterOpp.Business_Type__c = 'Standard Opportunity';
		masterOpp.End_Customer_Information__c = 'Known End Customer';
		masterOpp.End_Customer_LE__c = accList1[1].id;
		masterOpp.Unweighted_Amount_EUR__c=0;
		masterOpp.CloseDate = system.today();
		masterOpp.G2_Planned_Date__c = system.today();
		masterOpp.G3_Planned_Date__c = system.today()+1;
		masterOpp.G4_Planned_Date__c = system.today()+2;
		masterOpp.G5_Planned_Date__c = system.today()+3;
		masterOpp.G6_Planned_Date__c = system.today()+4;
		insert masterOpp;
		
		Nokia_Financial_Calendar__c nokFinCal = [SELECT Id FROM Nokia_Financial_Calendar__c][0];

		Test.startTest();
		
		CRM_CreateOpportunityApexCtlr.WrapperFullFT wrapperFT = CRM_CreateOpportunityApexCtlr.getFTDetailsApex(masterOpp.Id,'Indirect Fast Track (under Frame Contract)', accList1[0].Id);
		
		wrapperFT.fastTrackOpp.End_Customer_LE__c = accList1[1].Id;
		wrapperFT.fastTrackOpp.End_Customer_Information__c = 'Known End Customer';
		wrapperFT.fastTrackOpp.End_Customer__c = accList1[1].id;
		wrapperFT.fastTrackOpp.Name = 'Fast Track Opp';
		wrapperFT.oifLine.POPlanReceipt__c = nokFinCal.Id;
		wrapperFT.oifLine.Rev_RecPlan_Receipt__c = nokFinCal.Id;
		wrapperFT.oifLine.Forecast_Category__c = 'Secure';
		wrapperFT.oifLine.OIF_Value__c = 100;
		
		CRM_CreateOpportunityApexCtlr.saveFastTrackApex(JSON.serialize(wrapperFT.fastTrackOpp),'Indirect Fast Track (under Frame Contract)', JSON.serialize(wrapperFT.oifLine), accList1[0].Id, masterOpp.Id);
		
		Test.stopTest();
	}
	
	private static testMethod void remClassMethod()
	{  
		CRM_CreateOpportunityApexCtlr.getAllCurrencyValues();
		CRM_CreateOpportunityApexCtlr.getAllOppTypesValues();
		CRM_CreateOpportunityApexCtlr.getAllContractSigningValues();
		CRM_CreateOpportunityApexCtlr.getAllAccountRoleValues(); 
		CRM_CreateOpportunityApexCtlr.getAccountRoleDefaultValue(GlobalConstants.PARTNER_TYPE_DISTR, CRM_CreateOpportunityApexCtlr.getAccountRoleMappings());
	}
	
	private static testMethod void testConvertFastTrack(){
		List<Account> accList1 = [SELECT Id FROM Account WHERE Active__c = true ORDER BY AccountNumber DESC];
		Opportunity oppty = TestDataFactory.OpportunityCreation(1, accList1[0])[0];
		oppty.G4_Approval_Date__c = System.now();
		oppty.LOA_Level__c = 'C';
		insert oppty;
		Test.startTest();
		Opportunity fastTrack = TestDataFactory.OpportunityCreation(1, accList1[0])[0];
		fastTrack.Name ='Fast Track Opp';
		fastTrack.Reference_Opportunity__c  =oppty.Id;
		fastTrack.Business_Type__c = GlobalConstants.FAST_TRACK_OPP_TYPE;
		fastTrack.StageName = GlobalConstants.WIN_THE_CASE_NEGOTIATE;
		fastTrack.Phase_Status__c = GlobalConstants.OFFERSUBMITTEDTOCUSTOMER;
		insert fastTrack;
		
		CRM_CreateOpportunityApexCtlr.convertFastTrack(fastTrack.id);
		Test.stopTest();
	}
}