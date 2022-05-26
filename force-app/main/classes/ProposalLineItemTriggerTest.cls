@isTest(seeAllData = false)
public class ProposalLineItemTriggerTest {
	@testSetup static void setup() {
		//create account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		insert accounts;
		List<Account> accounts1 = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		accounts1[0].Acc_No__c = 'Testing1';
		accounts1[0].Partner_Program__c ='';
		accounts1[0].Partner_Type__c = '';
		accounts1[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		insert accounts1;
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations; 
		
		//Create Opportunity
		List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		opportunities1[0].End_Customer_LE__c = accounts1[0].Id;
		insert opportunities1;
		
		//Create Product
		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
			Name = 'Test1', 
			ProductCode = '123', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = false,
			NokiaCPQ_Item_Type__c='Software',
			Apttus_Config2__ConfigurationType__c='Bundle'
			
		); 
		prods.add(prod1);

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
		 test.startTest();
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(2);
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;	  
		proposals[0].NokiaCPQ_ION_Maintenance_Type__c = '';
		proposals[0].NokiaCPQ_Maintenance_Type__c='';
		proposals[0].NokiaCPQ_Existing_FN_Maint_Contract__c  = '';
		proposals[0].NokiaCPQ_FN_Maintenance_Type__c= '';
		proposals[0].CurrencyIsoCode ='USD';
		proposals[0].Apttus_Proposal__Approval_Stage__c = 'Draft';
		proposals[0].Creation_Date__c = system.today();
		proposals[0].NokiaCPQ_Portfolio__c = ''; 
		proposals[0].NokiaCPQ_No_of_Years__c=''; 
		proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c ='';  
		proposals[0].NokiaCPQ_SSP_Level__c='';
	 
		proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_NCQ_Quote').getRecordTypeId();

		proposals[1].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[1].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;	  
		proposals[1].NokiaCPQ_ION_Maintenance_Type__c = '';
		proposals[1].NokiaCPQ_Maintenance_Type__c='';
		proposals[1].NokiaCPQ_Existing_FN_Maint_Contract__c  = '';
		proposals[1].NokiaCPQ_FN_Maintenance_Type__c= '';
		proposals[1].CurrencyIsoCode ='USD';
		proposals[1].Apttus_Proposal__Approval_Stage__c = 'Draft';
		proposals[1].Creation_Date__c = system.today();
		proposals[1].NokiaCPQ_Portfolio__c = ''; 
		proposals[1].NokiaCPQ_No_of_Years__c=''; 
		proposals[1].NokiaCPQ_Existing_IONMaint_Contract__c ='';  
		proposals[1].NokiaCPQ_SSP_Level__c='';
		
		proposals[1].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_CQ_Quote').getRecordTypeId();
		insert proposals;
		
		/*
		List<Apttus_Proposal__Proposal__c > proposals1 = NOKIA_CPQ_TestDataFactory.createProposal(1);
		
		proposals1[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals1[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;	 
		proposals1[0].NokiaCPQ_Portfolio__c = 'IP Routing'; //MN airscale wifi portfolio
		proposals1[0].Apttus_Proposal__Approval_Stage__c = 'Approved';
		proposals1[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_NCQ_Quote').getRecordTypeId();
		insert proposals1;	  
		*/
		
		//create product configuration
		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = proposals[0].Id, 
			Apttus_Config2__Status__c = 'New', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;
		
		//create proposal line items
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList[0].Apttus_Proposal__Product__c = prod1.id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		proposalLineItemList[0].Apttus_QPConfig__NetPrice__c = 100;
		insert proposalLineItemList;
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList1= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList1[0].Apttus_Proposal__Product__c = prod1.id;
		proposalLineItemList1[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		proposalLineItemList1[0].Apttus_QPConfig__NetPrice__c = 100;
		proposalLineItemList1[0].Item_Type__c = 'Service';
		insert proposalLineItemList1;
		 List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList2= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList2[0].Apttus_Proposal__Product__c = prod1.id;
		proposalLineItemList2[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		proposalLineItemList2[0].Apttus_QPConfig__NetPrice__c = 100;
		proposalLineItemList2[0].Item_Type__c = 'other';
		insert proposalLineItemList2;  
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList3= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList3[0].Apttus_Proposal__Product__c = prod1.id;
		proposalLineItemList3[0].Apttus_Proposal__Proposal__c =proposals[1].id;
		proposalLineItemList3[0].Apttus_QPConfig__NetPrice__c = 100;
		proposalLineItemList3[0].Item_Type__c = 'other';
		insert proposalLineItemList3;
		
		Apttus__APTS_Template__c temp = new Apttus__APTS_Template__c(Name ='QTC-NCQ Generic Quote Template123',
		 Apttus__Type__c='Agreement',
		 Apttus__IsActive__c=True,
		 Apttus__Agreement_Types__c='QTC NCQ Quote');
		insert temp;

		Apttus__APTS_Template__c temp2 = new Apttus__APTS_Template__c(Name ='Generic Report',
		 Apttus__Type__c='Agreement',
		 Apttus__IsActive__c=True,
		 Apttus__Agreement_Types__c='QTC CQ Quote');
		insert temp2;
		ProposalLineItemTriggerHelper.updateQuoteValue(proposalLineItemList2);
		ProposalLineItemTriggerHelper.updateQuoteValue(proposalLineItemList3);
		ProposalLineItemTriggerHelper.autoGenerateQuoteReports(proposalLineItemList3);
		ProposalLineItemTriggerHelper.autoGenerateDocument(temp.Id,proposals[0].Id);
		test.stopTest();
	 }

	@isTest
	static void validateCreateFRULineItems(){
		Test.startTest();
		
		
		List<Product2> prdList = [select id from product2 where productcode = '123'];

		string recTtypeId = Schema.SObjectType.CPQ_FRUCustItemCdMap__c.getRecordTypeInfosByDeveloperName().get('FRU').getRecordTypeId();
		CPQ_FRUCustItemCdMap__c fru = new CPQ_FRUCustItemCdMap__c();
		fru.CPQ_FRU_Description__c = 'Test Desc';
		fru.CPQ_Asset_Quantity__c = 1;
		fru.CPQ_Product__c = prdList[0].Id;
		fru.RecordTypeId = recTtypeId;
		insert fru;



		List<Apttus_Proposal__Proposal_Line_Item__c> pliList =  [SELECT  id, Apttus_QPConfig__ChargeType__c,Apttus_Proposal__Proposal__c,
	 Apttus_QPConfig__Quantity2__c,Apttus_QPConfig__LineType__c,
	 Apttus_QPConfig__NetPrice__c,Apttus_QPConfig__BasePrice__c,
	 Apttus_QPConfig__ListPrice__c,Apttus_QPConfig__OptionId__c,
	 CPQ_CQ_Check__c,Apttus_Proposal__Product__c 
	 FROM Apttus_Proposal__Proposal_Line_Item__c
	 WHERE CPQ_CQ_Check__c = true
	 LIMIT 1];
		
		
		
		ProposalLineItemTriggerHelper.createFRULineItems(pliList);

		pliList[0].Apttus_QPConfig__OptionId__c = prdList[0].Id;
		update pliList;

		ProposalLineItemTriggerHelper.createFRULineItems(pliList);

		
		Test.StopTest(); 
		
	}
	
	@isTest
	static void testDeleteTrigger(){ 
		test.startTest();
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList =[Select id from Apttus_Proposal__Proposal_Line_Item__c where Item_Type__c ='' ];
		delete proposalLineItemList;
		test.stopTest();
		
	}

	@isTest
	static void validateServiceRollupValues(){
		Test.startTest();

		Id RecId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		List<Account> accounts = [select id from Account where RecordTypeId =: RecId limit 1]; 

		Id RecId1 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		List<Account> accounts1 = [select id from Account where RecordTypeId =: RecId1 limit 1]; 
		

		
		//Create Opportunity
		 Id RecId3 = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
		List<opportunity> opportunities1 = [select id from opportunity where RecordTypeId =: RecId3 limit 1];
		 RecordType rec =[select id from RecordType where DeveloperName = 'NokiaCPQ_Sales_Product' limit 1];
		//Create Product
		List<Product2> prods = new List<Product2>();
		Product2 prod1 = new product2(
			Name = 'Test1123', 
			ProductCode = '123test', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = true,
			NokiaCPQ_Item_Type__c='Service',
			Apttus_Config2__ConfigurationType__c='Standalone',
			CPQ_Secondary_Category__c = 'Basic Inst New Assy',
			CPQ_Stream__c = 'QTC',
			RecordTypeId=rec.Id
		); 
		
		Product2 prod2 = new product2(
			Name = 'Test1123', 
			ProductCode = '123test', 
			Business_Group__c = 'MN', 
			CurrencyIsoCode = 'USD',
			IsActive = true,
			Apttus_Config2__ConfigurationType__c='Bundle',
			CPQ_Secondary_Category__c = 'Site Model',
			CPQ_Stream__c = 'QTC',
			RecordTypeId=rec.Id
		);
		
		prods.add(prod1);
		prods.add(prod2);

		insert prods;
		
		string recTtypeId = Schema.SObjectType.CPQ_FRUCustItemCdMap__c.getRecordTypeInfosByDeveloperName().get('FRU').getRecordTypeId();
		CPQ_FRUCustItemCdMap__c fru = new CPQ_FRUCustItemCdMap__c();
		fru.CPQ_FRU_Description__c = 'Test Desc';
		fru.CPQ_Asset_Quantity__c = 1;
		fru.CPQ_Product__c = prod1.Id;
		fru.RecordTypeId = recTtypeId;
		insert fru;
		
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
		insert pLI1;
		//plistItems.add(pLI1);
		
		//test.startTest();
		Id RecId4 =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_CQ_Quote').getRecordTypeId();
		List<Apttus_Proposal__Proposal__c > proposals = [select id from Apttus_Proposal__Proposal__c where RecordTypeId =: RecId4 limit 1];


		Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
			Name = 'APTTUS Test Config', 
			Apttus_Config2__AccountId__c = accounts[0].Id, 
			Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
			Apttus_QPConfig__Proposald__c = proposals[0].Id, 
			Apttus_Config2__Status__c = 'New', 
			Apttus_Config2__VersionNumber__c = 1, 
			Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
			Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id),
			Apttus_Config2__BusinessObjectType__c = 'Proposal'
		);
		insert ProdConfig;
		
		//create proposal line items
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLIList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
		
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList[0].Apttus_Proposal__Product__c = prod1.id;
		proposalLineItemList[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		proposalLineItemList[0].Apttus_QPConfig__NetPrice__c = 100;
		proposalLineItemList[0].CPQ_Rollup_Group_Num__c = 1;
		proposalLineItemList[0].CPQ_Rollup_Group_Parent__c = true;
		
		proposalLIList.add(proposalLineItemList[0]);
		
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList2= NOKIA_CPQ_TestDataFactory.createProposalLineItem(1);
		proposalLineItemList2[0].Apttus_Proposal__Product__c = prod1.id;
		proposalLineItemList2[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		proposalLineItemList2[0].Apttus_QPConfig__NetPrice__c = 100;
		proposalLineItemList2[0].CPQ_Rollup_Group_Num__c = 1;
		proposalLineItemList[0].CPQ_Rollup_Group_Parent__c = true;
		
		proposalLIList.add(proposalLineItemList2[0]);
		
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList1= NOKIA_CPQ_TestDataFactory.createProposalLineItem(3);
		proposalLineItemList1[0].Apttus_Proposal__Product__c = prod1.id;
		proposalLineItemList1[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		proposalLineItemList1[0].Apttus_QPConfig__NetPrice__c = 100;
		proposalLineItemList1[0].Item_Type__c = 'Service';
		proposalLineItemList1[0].CPQ_Price_Class__c = 'Engineering';
		proposalLIList.add(proposalLineItemList1[0]);
		
		proposalLineItemList1[1].Apttus_Proposal__Product__c = prod1.id;
		proposalLineItemList1[1].Apttus_Proposal__Proposal__c =proposals[0].id;
		proposalLineItemList1[1].Apttus_QPConfig__NetPrice__c = 100;
		proposalLineItemList1[1].Item_Type__c = 'Service';
		proposalLineItemList1[1].CPQ_Price_Class__c = 'Installation';
		proposalLIList.add(proposalLineItemList1[1]);
		
		proposalLineItemList1[2].Apttus_Proposal__Product__c = prod1.id;
		proposalLineItemList1[2].Apttus_Proposal__Proposal__c =proposals[0].id;
		proposalLineItemList1[2].Apttus_QPConfig__NetPrice__c = 100;
		proposalLineItemList1[2].Item_Type__c = 'Service';
		proposalLineItemList1[2].CPQ_Price_Class__c = 'Other';
		proposalLIList.add(proposalLineItemList1[2]);
		
		
		List<Apttus_Proposal__Proposal_Line_Item__c> proposalLineItemList3= NOKIA_CPQ_TestDataFactory.createProposalLineItem(3);
		proposalLineItemList3[0].Apttus_Proposal__Product__c = prod1.id;
		proposalLineItemList3[0].Apttus_Proposal__Proposal__c =proposals[0].id;
		proposalLineItemList3[0].Apttus_QPConfig__NetPrice__c = 100;
		proposalLineItemList3[0].Item_Type__c = 'Service';
		proposalLineItemList3[0].CPQ_Price_Class__c = 'Engineering';
		proposalLineItemList3[0].CPQ_Sub_Heading__c = 'Test SB';
		proposalLIList.add(proposalLineItemList3[0]);
		
		proposalLineItemList3[1].Apttus_Proposal__Product__c = prod2.id;
		proposalLineItemList3[1].Apttus_Proposal__Proposal__c =proposals[0].id;
		proposalLineItemList3[1].Apttus_QPConfig__NetPrice__c = 100;
		proposalLineItemList3[1].CPQ_Secondary_Category__c = 'Site Model';
		proposalLineItemList3[1].Apttus_QPConfig__LineNumber__c = 2;
		
		proposalLIList.add(proposalLineItemList3[1]);
		
		proposalLineItemList3[2].Apttus_Proposal__Product__c = prod2.id;
		proposalLineItemList3[2].Apttus_Proposal__Proposal__c =proposals[0].id;
		proposalLineItemList3[2].Apttus_QPConfig__NetPrice__c = 100;
		proposalLineItemList3[2].Item_Type__c = 'Service';
		proposalLineItemList3[2].CPQ_Price_Class__c = 'Other';
		proposalLineItemList3[1].Apttus_QPConfig__LineNumber__c = 2;
		proposalLineItemList3[2].Apttus_QPConfig__OptionId__c = prod1.id;
		proposalLIList.add(proposalLineItemList3[2]);
		
		
		
		Insert proposalLIList;
		 
		Apttus_Proposal__Proposal_Line_Item__c Pr = new Apttus_Proposal__Proposal_Line_Item__c();
		Pr.CPQ_Rollup_Group_Num__c = Null;
		Pr.Apttus_Proposal__Proposal__c = proposals[0].id;
		insert Pr;
		
		Map < Decimal, Decimal > m1 = new Map < Decimal, Decimal > ();
	// m1 = rollupPriceMap.get(Pr.Apttus_Proposal__Proposal__c);

		
		 Test.stopTest();
		ProposalLineItemTriggerHelper.wrapPriceClass wp = new ProposalLineItemTriggerHelper.wrapPriceClass();
		wp.Installation = Pr.Apttus_QPConfig__NetPrice__c;
	
	}
}