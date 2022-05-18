@isTest(SeeAllData=false)
public class NokiaCPQSendBOMNPTController_Test  {
	static testMethod void testNPTMethod()
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
		insert opportunities1;
		
		Offer__c offer = new Offer__c(
		No_LoA__c = false,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = true,
		Pre_approved_Price_List_for_Acc_Managers__c = false,
		LOA_Bypass__c = '',
		Opportunity__c = opportunities1[0].Id
		); 
		insert offer;
		
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
		 Product2 prod2 = new product2(
			Name = 'Test3', 
			ProductCode = '4256', 
			//Business_Group__c = 'MN', 
			CurrencyIsoCode = 'EUR',
			IsActive = true,
			Capacity__c = 'full',
	Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
	//NokiaCPQ_Portfolio_Package_Code__c = 'tetet',
			Apttus_Config2__ConfigurationType__c='Bundle'
		); 
		prods.add(prod2);
		Product2 prod3 = new product2(
			Name = 'Test3', 
			ProductCode = '4256', 
			//Business_Group__c = 'MN', 
			CurrencyIsoCode = 'EUR',
			IsActive = true,
			Capacity__c = 'full',
			Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
			NokiaCPQ_Portfolio_Package_Code__c = 'tetet',
			NokiaCPQ_Item_Type__c = 'Software',
			Apttus_Config2__ConfigurationType__c='Bundle'
		); 
		prods.add(prod3);
		insert prods;
		
	Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
		);
		insert ApttusTestPriceList;
		
		//create price list items
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod1.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod3.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		//insert pLI1;
		plistItems.add(pLI2);
		 test.startTest();
	 
	//	List<Apttus_Proposal__Proposal__c> proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		Apttus_Proposal__Proposal__c proposals = new Apttus_Proposal__Proposal__c();
		proposals.Apttus_Proposal__Proposal_Name__c = 'MPW Proposal';
		proposals.NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
		proposals.Apttus_Proposal__Account__c = accounts[0].Id;
		proposals.Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
		proposals.NokiaCPQ_LEO_Discount__c=true;
		proposals.NokiaCPQ_No_of_Years__c = '3';
		proposals.NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION; 
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
			NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION
			
		);
		insert ProdConfig;
		
		//Create Line Items
		list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Option',
			Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			is_Custom_Product__c=false,
			NokiaCPQ_Spare__c=true,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
	
		allLineItems.add(LineItem1);
		
		Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Option',
			Apttus_Config2__OptionId__c = prod2.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,	
			is_Custom_Product__c=false,
			NokiaCPQ_Spare__c=false,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
	
		allLineItems.add(LineItem2);
		
		Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Option',
			Apttus_Config2__ProductId__c = prod2.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,	
			is_Custom_Product__c=false,
			NokiaCPQ_Spare__c=false,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__ParentBundleNumber__c = 1,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
	
		allLineItems.add(LineItem3);
		Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Option',
			Apttus_Config2__OptionId__c = prod3.Id,
			Apttus_Config2__PriceListItemId__c = pLI2.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,	
			is_Custom_Product__c=false,
			NokiaCPQ_Spare__c=false,
			NCPQ_Unitary_CLP__c = 5,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
	
		allLineItems.add(LineItem4);
		insert allLineItems;
		 //Create summary Group
		//
		list<Apttus_Config2__SummaryGroup__c> allSummarygrps = new List<Apttus_Config2__SummaryGroup__c>();
		Apttus_Config2__SummaryGroup__c allSummarygrp1 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Total (One Time)',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Total (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 100,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
		);
		allSummarygrps.add(allSummarygrp1);
		Apttus_Config2__SummaryGroup__c allSummarygrp2 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Configurable Products',
			Apttus_Config2__LineNumber__c = 2,
			Apttus_Config2__ItemSequence__c = 2,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 120,
			Apttus_Config2__Description__c = 'Maintenance Y1 (One Time) (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 80,
			Apttus_Config2__ChargeType__c = 'Maintenance Y1',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		
		allSummarygrps.add(allSummarygrp2);
		 Apttus_Config2__SummaryGroup__c allSummarygrp3 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Configurable Products',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Total (One Time) (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 800,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		allSummarygrps.add(allSummarygrp3);
		 
		 Apttus_Config2__SummaryGroup__c allSummarygrp4 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Subtotal - Standard Price (One Time) - Standard Price (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 100,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		allSummarygrps.add(allSummarygrp4);
		insert allSummarygrps;
		
		// Proposal Summary Group
		Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
		Apttus_QPConfig__ProposalId__c = proposals.id,
		CurrencyIsoCode = 'USD',
		Apttus_QPConfig__AdjustmentAmount__c = 10,
			NokiaCPQ_DOD__c = 3,
			NokiaCPQ_DPD__c =  4,
		//Apttus_QPConfig__NetPrice__c = 100.00,
		Apttus_QPConfig__ItemSequence__c = 1,
		Apttus_QPConfig__LineNumber__c = 1,
		//Apttus_QPConfig__ExtendedPrice__c = 100,
		name = 'Total (One Time)'
		);
		insert propSummaryGrp1;
		
		Interface_Log__c  interfaceL = new Interface_Log__c();
		interfaceL.Comment__c = 'SUCCESS';
			
		insert interfaceL;

			StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
			mock.setStaticResource('staticResourceJSON');
			mock.setStatusCode(200); // Or other appropriate HTTP status code
			mock.setHeader('Content-Type', 'application/json'); // Or other appropriate MIME type like application/xml
			Test.setMock(HttpCalloutMock.class, mock);
			
			//Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator()); 
			//MyCalloutClass.getInfoFromExternalService();
		
			NokiaCPQSendBOMNPTController ctrlr = new NokiaCPQSendBOMNPTController();	
			//NokiaCPQSendBOMNPTController.getNPTtoken();
			//system.debug('eee2 '+prodConfigs[0].Id);  //a683K000000NfnnQAC
			ctrlr.getNPTBomRequestBody(ProdConfig.Id);   //('a683K000000NfZWQA0');  kamlesh
			//ctrlr.getNPTBomRequestBody_MW(ProdConfig.Id);
	 // NokiaCPQSendBOMNPTController.getJsonStatus('');
			//NokiaCPQSendBOMNPTController.getNPTtoken();
			//ctrlr.NokiaCPQSendBOMNPTControllerAction_MPW(ProdConfig.Id);
			//ctrlr.getNPTBomRequestBody('a683K000000NfZWQA0');
		//system.debug('eee '+ctrlr.getNPTBomRequestBody(prodConfigs[0].Id));
			Test.stopTest();
		//} 
	}
  static testMethod void testNPTMethod2()
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
		insert opportunities1;
		
		Offer__c offer = new Offer__c(
		No_LoA__c = false,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = true,
		Pre_approved_Price_List_for_Acc_Managers__c = false,
		LOA_Bypass__c = '',
		Opportunity__c = opportunities1[0].Id
		); 
		insert offer;
		
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
		 Product2 prod2 = new product2(
			Name = 'Test3', 
			ProductCode = '4256', 
			//Business_Group__c = 'MN', 
			CurrencyIsoCode = 'EUR',
			IsActive = true,
			Capacity__c = 'full',
	//NokiaCPQ_Portfolio_Package_Code__c = 'tetet',
			Apttus_Config2__ConfigurationType__c='Bundle'
		); 
		prods.add(prod2);
		
		Product2 prod3 = new product2(
			Name = 'Test31', 
			ProductCode = '42156', 
			//Business_Group__c = 'MN', 
			CurrencyIsoCode = 'EUR',
			IsActive = true,
			Capacity__c = 'full',
			NokiaCPQ_Item_Type__c = 'Software',
	NokiaCPQ_Portfolio_Package_Code__c = 'tetet',
			Apttus_Config2__ConfigurationType__c='Bundle'
		); 
		prods.add(prod3);
		
		Product2 prod4 = new product2(
			Name = 'Test111', 
			ProductCode = '421156', 
			//Business_Group__c = 'MN', 
			CurrencyIsoCode = 'EUR',
			IsActive = true,
			Capacity__c = 'full',
			NokiaCPQ_Item_Type__c = 'Software',
			Apttus_Config2__ConfigurationType__c='Bundle'
		); 
		prods.add(prod4);
		
		insert prods;
		
	Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
			Name = 'Commercial Price List', 
			Apttus_Config2__Active__c = True
		);
		insert ApttusTestPriceList;
		
		//create price list items
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod1.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		//insert pLI1;
		plistItems.add(pLI1);
		Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod3.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		//insert pLI1;
		plistItems.add(pLI2);
		Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod4.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		//insert pLI1;
		plistItems.add(pLI3);
		 test.startTest();
	 
	//	List<Apttus_Proposal__Proposal__c> proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		Apttus_Proposal__Proposal__c proposals = new Apttus_Proposal__Proposal__c();
		proposals.Apttus_Proposal__Proposal_Name__c = 'MPW Proposal';
		proposals.NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
		proposals.Apttus_Proposal__Account__c = accounts[0].Id;
		proposals.Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
		proposals.NokiaCPQ_LEO_Discount__c=true;
		proposals.NokiaCPQ_No_of_Years__c = '3';
		proposals.NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION; 
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
			NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION
			
		);
		insert ProdConfig;
		
		//Create Line Items
		list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Option',
			Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			is_Custom_Product__c=false,
			NokiaCPQ_Spare__c=true,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
	
		allLineItems.add(LineItem1);
		
		Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Option',
			Apttus_Config2__OptionId__c = prod2.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,	
			is_Custom_Product__c=false,
			NokiaCPQ_Spare__c=false,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
	
		allLineItems.add(LineItem2);
		
		Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Option',
			Apttus_Config2__ProductId__c = prod2.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,	
			is_Custom_Product__c=false,
			NokiaCPQ_Spare__c=false,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__ParentBundleNumber__c = 2,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
	
		allLineItems.add(LineItem3);
		
		Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod3.Id,
			Apttus_Config2__PriceListItemId__c = pLI2.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,	
			//is_Custom_Product__c=false,
			NokiaCPQ_Spare__c=false,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__ParentBundleNumber__c = 2,
			is_Custom_Product__c = true, 
			Custom_Product_Code__c = 'custom12',   
			Custom_Product_Name__c = 'Sweet Description Please',
			Apttus_Config2__AddedBy__c = 'added by code',
			NCPQ_Unitary_CLP__c = 6
		);
	
		allLineItems.add(LineItem4);
		
		Apttus_Config2__LineItem__c LineItem5 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod4.Id,
			Apttus_Config2__PriceListItemId__c = pLI3.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,	
			//is_Custom_Product__c=false,
			NokiaCPQ_Spare__c=false,
			Apttus_Config2__PrimaryLineNumber__c = null,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__ParentBundleNumber__c = 2,
			is_Custom_Product__c = true, 
			Custom_Product_Code__c = 'custom12',   
			Custom_Product_Name__c = 'Sweet Description Please',
			Apttus_Config2__AddedBy__c = 'added by code',
			NCPQ_Unitary_CLP__c = 6
		);
	
		allLineItems.add(LineItem5);
		insert allLineItems;
		 //Create summary Group
		//
		list<Apttus_Config2__SummaryGroup__c> allSummarygrps = new List<Apttus_Config2__SummaryGroup__c>();
		Apttus_Config2__SummaryGroup__c allSummarygrp1 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Total (One Time)',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Total (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 100,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
		);
		allSummarygrps.add(allSummarygrp1);
		Apttus_Config2__SummaryGroup__c allSummarygrp2 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Configurable Products',
			Apttus_Config2__LineNumber__c = 2,
			Apttus_Config2__ItemSequence__c = 2,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 120,
			Apttus_Config2__Description__c = 'Maintenance Y1 (One Time) (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 80,
			Apttus_Config2__ChargeType__c = 'Maintenance Y1',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		
		allSummarygrps.add(allSummarygrp2);
		 Apttus_Config2__SummaryGroup__c allSummarygrp3 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Configurable Products',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Total (One Time) (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 800,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		allSummarygrps.add(allSummarygrp3);
		 
		 Apttus_Config2__SummaryGroup__c allSummarygrp4 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Subtotal - Standard Price (One Time) - Standard Price (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 100,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		allSummarygrps.add(allSummarygrp4);
		insert allSummarygrps;
   
		/*	StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
			mock.setStaticResource('staticResourceJSON');
			mock.setStatusCode(200); // Or other appropriate HTTP status code
			mock.setHeader('Content-Type', 'application/json'); // Or other appropriate MIME type like application/xml
			Test.setMock(HttpCalloutMock.class, mock);
		 */   
			NokiaCPQSendBOMNPTController ctrlr = new NokiaCPQSendBOMNPTController();
			//NokiaCPQSendBOMNPTController.getNPTtoken();
			//system.debug('eee2 '+prodConfigs[0].Id);  //a683K000000NfnnQAC
	 ctrlr.getNPTBomRequestBody(ProdConfig.Id);   //('a683K000000NfZWQA0');  kamlesh
			//ctrlr.getNPTBomRequestBody('a683K000000NfZWQA0');
		//system.debug('eee '+ctrlr.getNPTBomRequestBody(prodConfigs[0].Id));
			Test.stopTest();
		//} 
	}

	 static testMethod void testNPTMethod_MW()
	{
	
		//create a Account
		 List<Account> accounts = NOKIA_CPQ_TestDataFactory_MPW.getAccounts(1);
		insert accounts;
		List<Account> accounts1 = NOKIA_CPQ_TestDataFactory_MPW.getAccounts(1);
		accounts1[0].Acc_No__c = 'Testing1';
		accounts1[0].Partner_Program__c ='';
		accounts1[0].Partner_Type__c = '';
		accounts1[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		insert accounts1;

		
	
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].Portfolio__c = 'Microwave';
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Portfolio__c = 'Microwave';
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Nokia Brand Of Service';
		accreditations[1].Pricing_Level_Override__c = 'Nokia Brand Of Service';   
		insert accreditations;
		
	
		//Create Opportunity
		List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory_MPW.getOpportunities(1,accounts);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities1[0].End_Customer_LE__c = accounts1[0].Id;
		opportunities1[0].StageName = 'Create Offer (Bid)';
		opportunities1[0].Phase_Status__c ='Offer in Progress';
		insert opportunities1;
		
		Offer__c offer = new Offer__c(
		No_LoA__c = false,
		ActiveOffer__c =true,
		Authorized_for_Pricing_Manager__c = true,
		Pre_approved_Price_List_for_Acc_Managers__c = false,
		LOA_Bypass__c = '',
		Opportunity__c = opportunities1[0].Id
		); 
		insert offer;
		
		//Create products
		//Create Product
		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
		Name = 'Test1', 
		ProductCode = '123', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'Microwave',
		IsActive = true,
		Capacity__c = 'full',
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Portfolio_Package_Code__c = 'L24074',
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
		); 
		prods.add(prod1);

		Product2 prod2 = new product2(
		Name = 'Test12', 
		ProductCode = '1233', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'Microwave',
		IsActive = true,
		Capacity__c = 'full',
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Portfolio_Package_Code__c = 'L24074',
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
		); 
		prods.add(prod2);
		
		Product2 prod3 = new product2(
		Name = 'Test121', 
		ProductCode = '1234', 
		//Business_Group__c = 'ION', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'Microwave',
		IsActive = true,
		Capacity__c = 'full',
		Apttus_Config2__ConfigurationType__c = 'Standalone',
		NokiaCPQ_Item_Type__c='Software',
		NokiaCPQ_Classification2__c='Base',
		NokiaCPQ_Portfolio_Package_Code__c = 'L24074',
		NokiaCPQ_Product_Discount_Category__c = 'NSD-NRC IPR'
		); 
		prods.add(prod3);
		
		insert prods;
		
		//insert price List
		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (USD)';
		priceList.CurrencyIsoCode='USD';
		priceList.Apttus_Config2__Active__c=false;	  
		insert priceList;
		
		//create price list items
		List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
		Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 200, 
			Apttus_Config2__ProductId__c = prod1.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		 plistItems.add(pLI1);
		 Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 800, 
			Apttus_Config2__ProductId__c = prod2.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		 plistItems.add(pLI2);
		Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = priceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod3.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		//insert pLI1;
		plistItems.add(pLI2);
		
		test.startTest();
		 Apttus_Proposal__Proposal__c proposals = new Apttus_Proposal__Proposal__c();
		proposals.Apttus_Proposal__Proposal_Name__c = 'MW Proposal';
		proposals.NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
		proposals.Apttus_Proposal__Account__c = accounts[0].Id;
		proposals.Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
		proposals.NokiaCPQ_Portfolio__c = 'Microwave';
		insert proposals;   
		
		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = priceList.Id, 
			Apttus_QPConfig__Proposald__c = proposals.Id, 
			Apttus_Config2__Status__c = 'New', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = priceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals.Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal',
			NokiaCPQ_Portfolio__c = 'Microwave'
			
		);
		insert ProdConfig;
		
		//Create Line Items
		list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = priceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 1200,
			Apttus_Config2__Quantity__c = 10,
			NokiaCPQ_Unitary_IRP__c = 1200,
			Apttus_Config2__BasePriceOverride__c = 1100,
			is_Custom_Product__c=false,
			NokiaCPQ_Spare__c=false,
			//CPQ_NPT_SI_TYPE__c = 'HW',
			EPT_Sites__c = 'Chennai,Pune,Delhi',
			EPT_Site_Quantity__c = '2,6,2',
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
	
		allLineItems.add(LineItem1);
		
		Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 2,
			Apttus_Config2__LineNumber__c = 2,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = priceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod2.Id,
			Apttus_Config2__PriceListItemId__c = pLI2.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,	 
			NokiaCPQ_Unitary_IRP__c = 1200,
			Apttus_Config2__BasePriceOverride__c = 1100,
			is_Custom_Product__c=false,
			//CPQ_NPT_SI_TYPE__c = 'HW',
			NokiaCPQ_Spare__c=true,
			Apttus_Config2__PrimaryLineNumber__c = 2,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
	
		allLineItems.add(LineItem2);
		 Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 3,
			Apttus_Config2__LineNumber__c = 3,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = priceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod3.Id,
			Apttus_Config2__PriceListItemId__c = pLI3.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 1800,
			Apttus_Config2__Quantity__c = 6, 
			//CPQ_NPT_SI_TYPE__c = 'HW',
			NokiaCPQ_Unitary_IRP__c = 1200,
			Apttus_Config2__BasePriceOverride__c = 1100,
			is_Custom_Product__c=false,
			NokiaCPQ_Spare__c=false,
			EPT_Site_Quantity__c = '2,2,2',
			EPT_Sites__c = 'Pune, Delhi',
			Apttus_Config2__PrimaryLineNumber__c = 3,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
	
		allLineItems.add(LineItem3);
		
		Insert allLineItems;
		
		
		//Create summary Group
		//
		list<Apttus_Config2__SummaryGroup__c> allSummarygrps = new List<Apttus_Config2__SummaryGroup__c>();
		Apttus_Config2__SummaryGroup__c allSummarygrp1 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Total (One Time)',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Total (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 100,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
		);
		allSummarygrps.add(allSummarygrp1);
		Apttus_Config2__SummaryGroup__c allSummarygrp2 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Configurable Products',
			Apttus_Config2__LineNumber__c = 2,
			Apttus_Config2__ItemSequence__c = 2,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 120,
			Apttus_Config2__Description__c = 'Maintenance Y1 (One Time) (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 80,
			Apttus_Config2__ChargeType__c = 'Maintenance Y1',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		
		allSummarygrps.add(allSummarygrp2);
		 Apttus_Config2__SummaryGroup__c allSummarygrp3 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Configurable Products',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Total (One Time) (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 800,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		allSummarygrps.add(allSummarygrp3);
		 
		 Apttus_Config2__SummaryGroup__c allSummarygrp4 =new Apttus_Config2__SummaryGroup__c(
			Name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
			Apttus_Config2__ExtendedPrice__c = 600,
			Apttus_Config2__Description__c = 'Subtotal - Standard Price (One Time) - Standard Price (One Time)',
			Apttus_Config2__AdjustmentAmount__c = 100,
			Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__Frequency__c = 'One Time'
			
		);
		allSummarygrps.add(allSummarygrp4);
		insert allSummarygrps;
		
		// Proposal Summary Group
		Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
		Apttus_QPConfig__ProposalId__c = proposals.id,
		CurrencyIsoCode = 'USD',
		Apttus_QPConfig__AdjustmentAmount__c = 10,
			NokiaCPQ_DOD__c = 3,
			NokiaCPQ_DPD__c =  4,
		//Apttus_QPConfig__NetPrice__c = 100.00,
		Apttus_QPConfig__ItemSequence__c = 1,
		Apttus_QPConfig__LineNumber__c = 1,
		//Apttus_QPConfig__ExtendedPrice__c = 100,
		name = 'Total (One Time)'
		);
		insert propSummaryGrp1;
		
		Interface_Log__c  interfaceL = new Interface_Log__c();
		interfaceL.Comment__c = 'SUCCESS';
			
		insert interfaceL;
		
	  
		NokiaCPQSendBOMNPTController ctrlr = new NokiaCPQSendBOMNPTController();	
		ctrlr.getNPTBomRequestBody_MW(ProdConfig.Id);  
		
		Test.stopTest();
		
		}
	
   /* static testMethod void testNPTMethod_callout()
	{
	
	  MultiStaticResourceCalloutMock multimock = new MultiStaticResourceCalloutMock();
		String tokenpath = 'https://login.microsoftonline.com/5d471751-9675-428d-917b-70f44f9630b0/oauth2/token';
		String calloutpath = 'callout:NPT_Login';
		multimock.setStaticResource(tokenpath,'ProductToken');
		multimock.setStaticResource(calloutpath,'ProductToken');
		multimock.setStatusCode(200); // Or other appropriate HTTP status code
		multimock.setHeader('Content-Type', 'application/json'); // Or other appropriate MIME type like application/xml

		Test.startTest();
		Test.setMock(HttpCalloutMock.class, multimock);
		String reqBody = 'JSON';
		NokiaCPQSendBOMNPTController ctrlr = new NokiaCPQSendBOMNPTController();	
		string token =  NokiaCPQSendBOMNPTController.getNPTToken(); 
		
		Test.stopTest();
	
} */
}