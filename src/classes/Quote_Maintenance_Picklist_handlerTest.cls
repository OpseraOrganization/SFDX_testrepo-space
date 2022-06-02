@isTest
public class Quote_Maintenance_Picklist_handlerTest
{
	static testMethod void Quote_Maintenance_Picklist_handlerTestmethod1()
	{
		List<User> userList = new List<User>();
		userList = TestDataFactory.userCreation(1,'Data Loader Profile');

		System.runAs(userList[0]){

		//method for Indirect Quotes
		
		List<Opportunity> opportunities;		
		 
		//Create Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		List<Account> accounts1 = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		accounts1[0].Acc_No__c = 'Testing1';
		accounts1[0].Partner_Program__c ='';
		accounts1[0].Partner_Type__c = '';
		accounts1[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		insert accounts1;
		
		//Create Opportunity
		opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].Lead_BG__c = 'MN';
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts1[0].Id;
		opportunities[0].Account_Role__c = 'GPP Distributor Partner';
		opportunities[0].Business_Type__c = 'Standard Opportunity';
		insert opportunities;
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].StageName='Create Offer (Bid)';
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();		
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'GPP Distributor Partner';	
		opportunities[0].G4_Planned_Date__c =  Date.Today();		
		update opportunities[0];
		
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations;		
		
		//Create Product
		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
			Name = 'Test1', 
			ProductCode = '123', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'IP Routing',
			IsActive = true			
		); 
		prods.add(prod1);
		
		Product2 prod2 = new product2(
			Name = 'Maintenance Year1', 
			ProductCode = '1234', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'IP Routing',
			IsActive = true
		); 
		prods.add(prod2);
		
		Product2 prod3 = new product2(
			Name = 'Test2', 
			ProductCode = '1234', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'Fixed Access - POL',
			IsActive = true,
			NokiaCPQ_Product_Discount_Category__c = 'NFM-P'
		); 
		prods.add(prod3);
		
		Product2 prod4 = new product2(
			Name = 'SSP', 
			ProductCode = 'SSP002', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = true,
			NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION'
		); 
		
		Product2 prod5 = new product2(
			Name = 'Maintenance Year2+', 
			ProductCode = '1234', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			Portfolio__c = 'IP Routing',
			IsActive = true
		); 
		prods.add(prod5);
		
		Product2 prod6 = new product2(
			Name = 'prod6', 
			ProductCode = 'P6', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = true,
			NokiaCPQ_Product_Discount_Category__c = '7210 SAS-D ION'
		); 
		prods.add(prod6);
		insert prods;
		
		//Create PriceList
		
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
			Apttus_Config2__ListPrice__c = 200, 
			Apttus_Config2__ProductId__c = prod2.Id, 
			Apttus_Config2__ChargeType__c = 'Maintenance Year1'
		);
		//insert pLI2;
		plistItems.add(pLI2);
		
		Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod3.Id, 
			Apttus_Config2__ChargeType__c = 'SRS'
		);
		//insert pLI1;
		plistItems.add(pLI3);
		
		Apttus_Config2__PriceListItem__c pLI4 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod4.Id, 
			Apttus_Config2__ChargeType__c = 'SSP'
		);
		//insert pLI1;
		plistItems.add(pLI4);
		
		Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 100, 
			Apttus_Config2__ProductId__c = prod5.Id, 
			Apttus_Config2__ChargeType__c = 'Maintenance Year2+'
		);
		//insert pLI1;
		plistItems.add(pLI5);		
		
		Apttus_Config2__PriceListItem__c pLI6 = new Apttus_Config2__PriceListItem__c(
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__ListPrice__c = 800, 
			Apttus_Config2__ProductId__c = prod6.Id, 
			Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		//insert pLI1;
		plistItems.add(pLI6);
		insert plistItems;
		
		test.startTest();
		
		List<Apttus_Proposal__Proposal__c > testProposal = NOKIA_CPQ_TestDataFactory.createProposal(1);
		testProposal[0].Apttus_Proposal__Account__c = accounts[0].Id;
		testProposal[0].Apttus_Proposal__Opportunity__c = opportunities.get(0).Id;
		testProposal[0].Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id;
		testProposal[0].Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today();
		testProposal[0].NokiaCPQ_Existing_IONMaint_Contract__c = 'Yes';
		testProposal[0].NokiaCPQ_Existing_FN_Maint_Contract__c = 'No';
		testProposal[0].NokiaCPQ_ION_Maintenance_Type__c = 'Gold';
		testProposal[0].NokiaCPQ_FN_Maintenance_Type__c = 'Gold';
		testProposal[0].NokiaCPQ_SSP_Level__c = 'Unlimited';
		testProposal[0].NokiaCPQ_SRS_Level__c = 'Unlimited';
		testProposal[0].NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)';
		testProposal[0].NokiaCPQ_Portfolio__c = 'IP Routing';
		testProposal[0].NokiaCPQ_No_of_Years__c = '1';
		testProposal[0].CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		testProposal[0].NokiaCPQ_LEO_Discount__c=false;
		//Commented out for ITCCPQ-2555 by Christie JJ
		//testProposal[0].NokiaCPQ_Maintenance_Accreditation__c='a3822000000Bu8HAAS';
		//testProposal[0].NokiaCPQ_Maintenance_Level__c='';
		testProposal[0].Apttus_Proposal__Approval_Stage__c='Draft';
		testProposal[0].Reprice_In_Progress__c=false;
		//   testProposal[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Indirect Quote').getRecordTypeId();
		insert  testProposal;
		
		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = testProposal[0].Id, 
			Apttus_Config2__Status__c = 'New', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal[0].Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal'
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
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__BasePrice__c=4427,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PriceIncludedInBundle__c=false,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			is_Custom_Product__c =true,
			Custom_Product_Code__c=Nokia_CPQ_Constants.MAINTY2CODE,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem2;
		allLineItems.add(LineItem1);
		Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__BasePrice__c=4427,
			Apttus_Config2__ListPrice__c = 200,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PriceIncludedInBundle__c=false,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Custom_Product_Code__c=Nokia_CPQ_Constants.MAINTY1CODE,
			
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem1;
		allLineItems.add(LineItem2);
		Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod1.Id,
			Apttus_Config2__PriceListItemId__c = pLI1.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			
			Apttus_Config2__ListPrice__c = 300,
			Apttus_Config2__Quantity__c = 1,
			Custom_Product_Code__c=Nokia_CPQ_Constants.SSPCODE,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		//insert LineItem1;
		allLineItems.add(LineItem3);
		
		Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Maintenance Year1', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod2.Id,
			Apttus_Config2__PriceListItemId__c = pLI2.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			NokiaCPQ_Maint_Yr1_Extended_Price__c =  100,
			Apttus_Config2__ListPrice__c = 120,
			Apttus_Config2__Quantity__c = 1,
			Custom_Product_Code__c=Nokia_CPQ_Constants.SRS,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'   
		);
		//insert LineItem1;
		allLineItems.add(LineItem4);
		
		Apttus_Config2__LineItem__c LineItem5 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'SRS', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod3.Id,
			Apttus_Config2__PriceListItemId__c = pLI3.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			
			Apttus_Config2__ListPrice__c = 120,
			Apttus_Config2__Quantity__c = 1,
			Nokia_SRS_Base_Extended_Price__c = 80,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'   
		);
		//insert LineItem1;
		allLineItems.add(LineItem5);
		
		Apttus_Config2__LineItem__c LineItem6 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'SSP', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod4.Id,
			Apttus_Config2__PriceListItemId__c = pLI4.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			
			Apttus_Config2__ListPrice__c = 120,
			Apttus_Config2__Quantity__c = 1,
			Nokia_SSP_Base_Extended_Price__c = 90,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'   
		);
		//insert LineItem1;
		allLineItems.add(LineItem6);
		
		Apttus_Config2__LineItem__c LineItem7 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Maintenance Year2+', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod5.Id,
			Apttus_Config2__PriceListItemId__c = pLI5.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'Yearly',
			NokiaCPQ_Maint_Yr2_Extended_Price__c = 100,
			Apttus_Config2__ListPrice__c = 120,
			Apttus_Config2__Quantity__c = 1,
			Nokia_SSP_Base_Extended_Price__c = 200,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'   
		);
		//insert LineItem1;
		allLineItems.add(LineItem7);
		Apttus_Config2__LineItem__c LineItem8 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
			//Apttus_Config2__ChargeType__c = 'Standard Type',
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod6.Id,
			Apttus_Config2__PriceListItemId__c = pLI6.id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			NokiaCPQ_Maint_Yr2_Extended_Price__c = 100,
			Apttus_Config2__ListPrice__c = 120,
			Apttus_Config2__Quantity__c = 1,
			Nokia_SSP_Base_Extended_Price__c = 200,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
			Apttus_Config2__AddedBy__c = 'added by code'   
		);
		//insert LineItem1;
		allLineItems.add(LineItem8);
		insert allLineItems;		
		
		Quote_Maintenance_Picklist_handler.accreditationValueReturn(testproposal[0].Id);
		Quote_Maintenance_Picklist_handler.approvalStageValueReturn(testproposal[0].Id);
		Quote_Maintenance_Picklist_handler.defaultValueReturn(testproposal[0].Id);
		Quote_Maintenance_Picklist_handler.getportfolioSRS(testproposal[0].Id);
		Quote_Maintenance_Picklist_handler.getportfolioSSP(testproposal[0].Id);
		Quote_Maintenance_Picklist_handler.portfolioValueReturn(testproposal[0].Id);
		//Modified by Christie JJ for ITCCPQ-2556
		Quote_Maintenance_Picklist_handler.saveRecord(testproposal[0].Id, '', '', '', '', '');
		Quote_Maintenance_Picklist_handler.sspsrsValueReturn(new List<String>{'IP Routing'}, Nokia_CPQ_Constants.NOKIA_SSP);
		Quote_Maintenance_Picklist_handler.updateExistingMaintContract(testproposal[0].Id,'NokiaCPQ_Existing_IONMaint_Contract__c');
		Quote_Maintenance_Picklist_handler.updateMaintenanceTypeValue(testproposal[0].Id);
		//Commented out for FN restructuring by Christie JJ
		//Quote_Maintenance_Picklist_handler.updateExistingMaintContract(testproposal[0].Id,'NokiaCPQ_Maintenance_Level__c');
		Quote_Maintenance_Picklist_handler.updateExistingMaintContract(testproposal[0].Id,'NokiaCPQ_SSP_Level__c');  
		Quote_Maintenance_Picklist_handler.updateExistingMaintContract(testproposal[0].Id,'NokiaCPQ_SRS_Level__c');
		Quote_Maintenance_Picklist_handler.updateExistingMaintContract(testproposal[0].Id,'NokiaCPQ_No_of_Years__c');		
		
		Quote_Maintenance_Picklist_handler.accreditationValueReturn('');
		Quote_Maintenance_Picklist_handler.approvalStageValueReturn('');
		Quote_Maintenance_Picklist_handler.defaultValueReturn('');
		Quote_Maintenance_Picklist_handler.getportfolioSRS('');
		Quote_Maintenance_Picklist_handler.getportfolioSSP('');
		Quote_Maintenance_Picklist_handler.portfolioValueReturn('');
		//Modified by Christie JJ for ITCCPQ-2556
		Quote_Maintenance_Picklist_handler.saveRecord('', '', '', '', '', '');
		Quote_Maintenance_Picklist_handler.sspsrsValueReturn(new List<String>{''},'');
		Quote_Maintenance_Picklist_handler.updateExistingMaintContract('','');
		Quote_Maintenance_Picklist_handler.updateMaintenanceTypeValue('');
		//Quote_Maintenance_Picklist_handler.MaintenanceLevelValueReturn(testproposal[0].Id,'');
		Quote_Maintenance_Picklist_handler.initializeMaintenancePicklists(testproposal[0].Id,new list<String>());
		
		Test.stopTest();
		}
	}
}