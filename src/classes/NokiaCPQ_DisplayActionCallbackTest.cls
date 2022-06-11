/**
 * @description	   : 
 * @author			: Yashdeep Prajapati
 * @group			 : 
 * @last modified on  : 06-11-2021
 * @last modified by  : Yashdeep Prajapati
 * Modifications Log 
 * Ver   Date		 Author			   Modification
 * 1.0   06-10-2021   Yashdeep Prajapati   Initial Version
**/
@isTest /*(SeeAllData = true) */
public class NokiaCPQ_DisplayActionCallbackTest 
{

static testMethod void testvalidationCallBackFORMNINDIRECT() {
		
	  /*  Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__DisplayActionCallbackCalss__c = 'NokiaCPQ_DisplayActionCallback';
		//custSetting.Apttus_Config2__ActionParamsCallbackClass__c='DefaultActionParamsCallback';
		custSetting.Name = 'SystemProperties';
		insert custSetting;*/
		
		
		List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
		users[0].Nokia_ID__c = '234597';
		insert users;
	
	System.runAs(users[0]) {   
		//create account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		accounts[0].CountryCode__c = 'CA';
		insert accounts;
		List<Account> accounts1 = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		accounts1[0].Acc_No__c = 'Testing1';
		accounts1[0].Partner_Program__c ='';
		accounts1[0].Partner_Type__c = '';
		accounts1[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts1[0].CountryCode__c = 'CA';
		accounts1[0].ParentId = accounts[0].Id;
		insert accounts1;

		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[0].Portfolio__c = 'Optics';
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Portfolio__c = 'Optics';
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';
		insert accreditations; 
		
		//Create Opportunity
		List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities1[0].End_Customer_LE__c = accounts1[0].Id;
		 opportunities1[0].End_Customer__c = accounts1[0].Id;
		 opportunities1[0].Legal_Entity__c = accounts1[0].Id;
		opportunities1[0].Account_Role__c = 'Alliance Partner';
		opportunities1[0].Lead_BU__c ='MN';
		insert opportunities1;
		
		
	Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
		);
		insert ApttusTestPriceList;	
	
		 test.startTest();

		Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities1[0].Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
			NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
			NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
			NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
			NokiaCPQ_SSP_Level__c = '',
			NokiaCPQ_SRS_Level__c = '',
			NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)',
			NokiaCPQ_Portfolio__c = 'Optics',
			NokiaCPQ_No_of_Years__c = '1',
			CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
			NokiaCPQ_LEO_Discount__c=false,
			Is_List_Price_Only__c =false,
			NokiaCPQ_Is_cloned__c = false,
			NokiaCPQ_Is_Maintenance_Quote__c = True,
			NokiaCPQ_Contract_Start_Date__c = System.Today(),
			Warranty_credit__c = 'No',
	 RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
			isCQ__c = false
	 
		);
		insert testProposal;	 
		
		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = testProposal.Id, 
			Apttus_Config2__Status__c = 'New', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

		List<Apttus_Config2.DisplayActionInfo> displayActions = New List<Apttus_Config2.DisplayActionInfo>();
		List<Apttus_Config2__ConfigCustomDisplayActions__c> custdisatList = new List<Apttus_Config2__ConfigCustomDisplayActions__c>();
		Apttus_Config2__ConfigCustomDisplayActions__c custdisat= new Apttus_Config2__ConfigCustomDisplayActions__c();
		custdisat.Apttus_Config2__ActionLabelName__c = 'AddMoreProducts';
		custdisat.Apttus_Config2__ActionName__c = 'AddMoreProducts';
		custdisat.Apttus_Config2__Sequence__c = 1;
		custdisat.Name = 'Test' + custdisat.Apttus_Config2__Sequence__c + '' + System.now().millisecond();
		custdisat.Apttus_Config2__DisplayType__c = 'Cart Line Item';
		custdisatList.add(custdisat);
		//insert custdisat; 
		
		Apttus_Config2__ConfigCustomDisplayActions__c custdisat2= new Apttus_Config2__ConfigCustomDisplayActions__c();
		custdisat2.Apttus_Config2__ActionLabelName__c = 'GPPPricing';
		custdisat2.Apttus_Config2__ActionName__c = 'GPPPricing';
		custdisat2.Apttus_Config2__Sequence__c = 2;
		custdisat2.Name = 'Test' + custdisat2.Apttus_Config2__Sequence__c + '' + System.now().millisecond();
		custdisat2.Apttus_Config2__DisplayType__c = 'Catalog Item';
		custdisatList.add(custdisat2);
		//insert custdisat2;

		Apttus_Config2__ConfigCustomDisplayActions__c custdisat3= new Apttus_Config2__ConfigCustomDisplayActions__c();
		custdisat3.Apttus_Config2__ActionLabelName__c = 'Site_Phase_Allocation';
		custdisat3.Apttus_Config2__ActionName__c = 'CustomAction23';
		custdisat3.Apttus_Config2__Sequence__c = 3;
		custdisat3.Name = 'Test' + custdisat3.Apttus_Config2__Sequence__c + '' + System.now().millisecond();
		custdisat3.Apttus_Config2__DisplayType__c = 'Cart Line Item';
		custdisatList.add(custdisat3);
		insert custdisatList;
		
	  /*  Apttus_Config2__ConfigCustomDisplayActions__c custdisat4= new Apttus_Config2__ConfigCustomDisplayActions__c();
		custdisat4.Apttus_Config2__ActionLabelName__c = 'MicrowaveCATconfigurator';
		custdisat4.Apttus_Config2__ActionName__c = 'CustomAction10';
		custdisat4.Apttus_Config2__Sequence__c = 4;
		custdisat4.Name = 'Test' + custdisat2.Apttus_Config2__Sequence__c + '' + System.now().millisecond();
		custdisat4.Apttus_Config2__DisplayType__c = 'Attribute Item';
		custdisat4.Apttus_Config2__IsEnabled__c=False;
		custdisat4.Apttus_Config2__ActionParams__c='';
		insert custdisat4; */
		
		Apttus_config2.DisplayActionInfo action1 = new apttus_config2.DisplayActionInfo(custdisat);
		Apttus_config2.DisplayActionInfo action2 = new apttus_config2.DisplayActionInfo(custdisat2);
		Apttus_config2.DisplayActionInfo action3 = new apttus_config2.DisplayActionInfo(custdisat3);
	  //  Apttus_config2.DisplayActionInfo action4 = new apttus_config2.DisplayActionInfo(custdisat4);
		displayActions.add(action1);
		displayActions.add(action2);
		displayActions.add(action3);
	// displayActions.add(action4);
		
		//ProdConfig  Apttus_Config2.CallbackTester.testValidationCallback(testAllLineItems1[0].Apttus_Config2__ConfigurationId__c, testAllLineItems1, null, new Nokia_Validation_Callback());   
		NokiaCPQ_DisplayActionCallback nb= new NokiaCPQ_DisplayActionCallback();
		NokiaCPQ_DisplayActionCallback.disableActionsForIndirectQuote(ProdConfig,displayActions);
				 
		test.stopTest();
	}

 }
 static testMethod void testvalidationCallBackFORMW() {
		
	  /*  Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__DisplayActionCallbackCalss__c = 'NokiaCPQ_DisplayActionCallback';
		//custSetting.Apttus_Config2__ActionParamsCallbackClass__c='DefaultActionParamsCallback';
		custSetting.Name = 'SystemProperties';
		insert custSetting;
		*/
		
		List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
		users[0].Nokia_ID__c = '234597';
		insert users;
	
	System.runAs(users[0]) {   
		//create account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		accounts[0].CountryCode__c = 'CA';
		insert accounts;
		List<Account> accounts1 = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		accounts1[0].Acc_No__c = 'Testing1';
		accounts1[0].Partner_Program__c ='';
		accounts1[0].Partner_Type__c = '';
		accounts1[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts1[0].CountryCode__c = 'CA';
		accounts1[0].ParentId = accounts[0].Id;
		insert accounts1;

		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[0].Portfolio__c = 'Microwave';
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Portfolio__c = 'Microwave';
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Nokia Brand Of Service';
		accreditations[1].Pricing_Level_Override__c = 'Nokia Brand Of Service';   
		insert accreditations; 
		
		//Create Opportunity
		List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities1[0].End_Customer_LE__c = accounts1[0].Id;
		 opportunities1[0].End_Customer__c = accounts1[0].Id;
		 opportunities1[0].Legal_Entity__c = accounts1[0].Id;
		opportunities1[0].Account_Role__c = 'Alliance Partner';
		opportunities1[0].Lead_BU__c ='MN';
		insert opportunities1;
		
		
	Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
		);
		insert ApttusTestPriceList;	
	
		 test.startTest();

		Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities1[0].Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_Existing_IONMaint_Contract__c = 'No',
			NokiaCPQ_Existing_FN_Maint_Contract__c = 'No',
			NokiaCPQ_ION_Maintenance_Type__c = 'Gold',
			NokiaCPQ_FN_Maintenance_Type__c = 'Gold',
			NokiaCPQ_SSP_Level__c = '',
			NokiaCPQ_SRS_Level__c = '',
			NokiaCPQ_Maintenance_Type__c = 'Basic Support',
			NokiaCPQ_Portfolio__c = 'Microwave',
			NokiaCPQ_No_of_Years__c = '1',
			CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY,
			NokiaCPQ_LEO_Discount__c=false,
			Is_List_Price_Only__c =false,
			NokiaCPQ_Is_cloned__c = false,
			NokiaCPQ_Is_Maintenance_Quote__c = False,
			//NokiaCPQ_Contract_Start_Date__c = System.Today(),
			//Warranty_credit__c = 'No',
			RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
			isCQ__c = false
	 
		);
		insert testProposal;	 
		
		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = testProposal.Id, 
			Apttus_Config2__Status__c = 'New', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal.Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;

		List<Apttus_Config2.DisplayActionInfo> displayActions = New List<Apttus_Config2.DisplayActionInfo>();
		
		Apttus_Config2__ConfigCustomDisplayActions__c custdisat3= new Apttus_Config2__ConfigCustomDisplayActions__c();
		custdisat3.Apttus_Config2__ActionLabelName__c = 'Edit_Site_Button';
		custdisat3.Apttus_Config2__ActionName__c = 'CustomAction23';
		custdisat3.Apttus_Config2__Sequence__c = 3;
		custdisat3.Name = 'Test' + custdisat3.Apttus_Config2__Sequence__c + '' + System.now().millisecond();
		custdisat3.Apttus_Config2__DisplayType__c = 'Cart Line Item';
		custdisat3.Apttus_Config2__IsEnabled__c=False;
		custdisat3.Apttus_Config2__ActionParams__c='';
		insert custdisat3;
		
		
		
		
		Apttus_config2.DisplayActionInfo action3 = new apttus_config2.DisplayActionInfo(custdisat3);
		displayActions.add(action3);
		
		
		//ProdConfig  Apttus_Config2.CallbackTester.testValidationCallback(testAllLineItems1[0].Apttus_Config2__ConfigurationId__c, testAllLineItems1, null, new Nokia_Validation_Callback());   
		NokiaCPQ_DisplayActionCallback nb= new NokiaCPQ_DisplayActionCallback();
		NokiaCPQ_DisplayActionCallback.disableActionsForIndirectQuote(ProdConfig,displayActions);
		Apttus_Config2.CustomClass.ActionParams params=new Apttus_Config2.CustomClass.ActionParams();
		NokiaCPQ_DisplayActionCallback.setActionProperties(null);
		test.stopTest();
	}

 }
 static testMethod void testMPW()
	{	  
		 //create account
		 List<Account> accounts = NOKIA_CPQ_TestDataFactory_MPW.getAccounts(1);
		insert accounts;
		List<Account> accounts1 = NOKIA_CPQ_TestDataFactory_MPW.getAccounts(1);
		accounts1[0].Acc_No__c = 'Testing1';
		accounts1[0].Partner_Program__c ='';
		accounts1[0].Partner_Type__c = '';
		accounts1[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		insert accounts1;

		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory_MPW.createAccreditationMPW(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[0].RecordTypeId = Schema.SObjectType.Accreditation__c.getRecordTypeInfosByDeveloperName().get('Distributor_GPP_3_0').getRecordTypeId(); 
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Nokia Brand of Service';
		accreditations[1].Pricing_Level_Override__c = 'Nokia Brand of Service';
		accreditations[1].Actual_pricing_level__c = 'Nokia Brand of Service'; 
		accreditations[1].RecordTypeId = Schema.SObjectType.Accreditation__c.getRecordTypeInfosByDeveloperName().get('Distributor_GPP_3_0').getRecordTypeId();
		insert accreditations; 
		
		//Create Opportunity
		List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory_MPW.getOpportunities(1,accounts);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities1[0].End_Customer_LE__c = accounts1[0].Id;
		opportunities1[0].StageName = 'Create Offer (Bid)';
		opportunities1[0].Phase_Status__c ='Offer in Progress';
		opportunities1[0].Account_Role__c = 'Alliance Partner';
		opportunities1[0].Lead_BU__c ='MN';
		opportunities1[0].Lead_BG__c ='MN';
		insert opportunities1;
		
	Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
		);
		insert ApttusTestPriceList;
		//Create Product
		//Prodid=[select id,Quote_Type__c,NokiaCPQ_Portfolio_From_Quote__c from Apttus_Config2__ProductConfiguration__c]
		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
			Name = 'Test2', 
			ProductCode = '456', 
			//Business_Group__c = 'MN', 
			CurrencyIsoCode = 'EUR',
			IsActive = true,
			Capacity__c = 'full',
			//NokiaCPQ_Portfolio_Package_Code__c = 'not null',
			Apttus_Config2__ConfigurationType__c='Option'
		); 
		prods.add(prod1);
		
		//create price list items
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod1.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		plistItems.add(pLI1);
		 test.startTest();
	 
		Apttus_Proposal__Proposal__c proposals = new Apttus_Proposal__Proposal__c();
		proposals.Apttus_Proposal__Proposal_Name__c = 'MPW Proposal';
		proposals.NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
		proposals.Apttus_Proposal__Account__c = accounts[0].Id;
		proposals.Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
		proposals.NokiaCPQ_LEO_Discount__c=true;	   
		proposals.NokiaCPQ_Portfolio__c = 'Modular Private Wireless Solution'; 
		//proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Indirect Quote').getRecordTypeId();
		insert proposals;	  
		
		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = proposals.Id, 
			Apttus_Config2__Status__c = 'New', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals.Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal',
			NokiaCPQ_Portfolio__c = 'Modular Private Wireless Solution'
			
		);
		insert ProdConfig;
		NokiaCPQ_Site_Phase_Configuration__c spObj= new NokiaCPQ_Site_Phase_Configuration__c();
		spObj.NokiaCPQ_Configuration__c=ProdConfig.id;
		spObj.NokiaCPQ_Aggregator__c=1;
		insert spObj;
		
		 List<Apttus_Config2.DisplayActionInfo> displayActions = New List<Apttus_Config2.DisplayActionInfo>();
		
	Apttus_Config2__ConfigCustomDisplayActions__c custdisat3= new Apttus_Config2__ConfigCustomDisplayActions__c();
		custdisat3.Apttus_Config2__ActionLabelName__c = 'Edit_Site_Button';
		custdisat3.Apttus_Config2__ActionName__c = 'CustomAction11';
		custdisat3.Apttus_Config2__Sequence__c = 3;
		custdisat3.Name = 'Test' + custdisat3.Apttus_Config2__Sequence__c + '' + System.now().millisecond();
		custdisat3.Apttus_Config2__DisplayType__c = 'Cart Line Item';
		custdisat3.Apttus_Config2__IsEnabled__c=False;
		custdisat3.Apttus_Config2__ActionParams__c='';
		insert custdisat3;
		
		
		
		
	Apttus_config2.DisplayActionInfo action3 = new apttus_config2.DisplayActionInfo(custdisat3);
		displayActions.add(action3);
		
		
		NokiaCPQ_DisplayActionCallback nb= new NokiaCPQ_DisplayActionCallback();
		NokiaCPQ_DisplayActionCallback.disableActionsForIndirectQuote(ProdConfig,displayActions);
		Apttus_Config2.CustomClass.ActionParams params=new Apttus_Config2.CustomClass.ActionParams();
		NokiaCPQ_DisplayActionCallback.setActionProperties(null);
		
		Apttus_Config2__ConfigCustomDisplayActions__c custdisat4= new Apttus_Config2__ConfigCustomDisplayActions__c();
		custdisat4.Apttus_Config2__ActionLabelName__c = 'CloseCart';
		custdisat4.Apttus_Config2__ActionName__c = 'Close';
		custdisat4.Apttus_Config2__Sequence__c = 4;
	custdisat4.Name = 'Test' + custdisat3.Apttus_Config2__Sequence__c + '' + System.now().millisecond();
		custdisat4.Apttus_Config2__DisplayType__c = 'Cart Line Item';
		custdisat4.Apttus_Config2__IsEnabled__c=False;
		custdisat4.Apttus_Config2__ActionParams__c='';
		insert custdisat4;
		Apttus_config2.DisplayActionInfo action4 = new apttus_config2.DisplayActionInfo(custdisat4);
		displayActions.add(action4);
		NokiaCPQ_DisplayActionCallback nb1= new NokiaCPQ_DisplayActionCallback();
		NokiaCPQ_DisplayActionCallback.disableActionsForIndirectQuote(ProdConfig,displayActions);
		Apttus_Config2.CustomClass.ActionParams params1=new Apttus_Config2.CustomClass.ActionParams();
		NokiaCPQ_DisplayActionCallback.setActionProperties(null);
		NokiaCPQ_DisplayActionCallback.disableActionsOnAggregation(ProdConfig,displayActions);
		
		Test.stopTest();
		
	}
		
}