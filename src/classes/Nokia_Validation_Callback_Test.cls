/****************************************
 * Name : Nokia_Validation_Callback_Test
 * Author : Accenture
 * Description : Test class for Nokia_Validation_Callback.
   *****************************************/
  @isTest 
  private class Nokia_Validation_Callback_Test{ 
   
		//surround: May Release -CQ Flow -  Validation call back changes test - start


	  @testSetup static void dataSetup() {
		NCPQ_Settings__c cpqSetting = new NCPQ_Settings__c();
		cpqSetting.NCPQ_MaintenanceProdCodes__c = 'test';
		cpqSetting.NCPQ_SPS_SRS_ProdCodes__c = 'test';
		cpqSetting.Name = 'test';
		insert cpqSetting;
	  }
   
	static testMethod void testmothdIsCQ() {  
	  
	  Nokia_Validation_Callback nvc = new Nokia_Validation_Callback();
	  Apttus_Config2.CustomClass.ValidationResult result;
	
	  List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	  account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	 
	  insert account3;
	  
	  List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
	  opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	
	  insert opportunities1;
	 
	//create product 
	List<Product2> prdList = new List<Product2>();
	product2 prod = new product2();
	  prod.name = '5G';
	  prod.CurrencyIsoCode = 'USD';
	  prod.Business_Group__c='MN';
	  prod.Family= 'A&A-CEM';
	  prod.IsActive=True;
	  prod.Partner_Visible__c=True;
	  prod.ProductCode='FC11011';
	  prod.Apttus_Config2__Version__c=1;
	  prod.Portfolio__c='Airscale Wifi';
	  prod.Created_by_PMDI__c = False;
	  prod.Pricing_Clusters__c='NAM';
	  prod.IsActive= True;
	  prod.NokiaCPQ_Item_Type__c= 'Hardware';
	  prod.NokiaCPQ_State__c = 'Create';
	  prdList.add(prod);
  
	  product2 prod2 = new product2();
	  prod2.name = '5G Prd2';
	  prod2.CurrencyIsoCode = 'USD';
	  prod2.Business_Group__c='MN';
	  prod2.Family= 'A&A-CEM';
	  prod2.IsActive=True;
	  prod2.Partner_Visible__c=True;
	  prod2.ProductCode='FC11011';
	  prod2.Apttus_Config2__Version__c=1;
	  prod2.Portfolio__c='Airscale Wifi';
	  prod2.Created_by_PMDI__c = False;
	  prod2.Pricing_Clusters__c='NAM';
	  
	  prod2.NokiaCPQ_Item_Type__c= 'Service';
	  prod2.IsActive= True;
  
	  prdList.add(prod2);
  
	  product2 prod3 = new product2();
	  prod3.name = '5G Prd3';
	  prod3.CurrencyIsoCode = 'USD';
	  prod3.Business_Group__c='MN';
	  prod3.Family= 'A&A-CEM';
	  prod3.IsActive=True;
	  prod3.Partner_Visible__c=True;
	  prod3.ProductCode='FC11011';
	  prod3.Apttus_Config2__Version__c=1;
	  prod3.Portfolio__c='Airscale Wifi';
	  prod3.Created_by_PMDI__c = False;
	  prod3.Pricing_Clusters__c='NAM';
	  prod3.IsActive= True;
	  prod3.CPQ_ICD_Code__c = 'ICDCode';
	  prod3.NokiaCPQ_Item_Type__c= 'Service';
	  prod3.CPQ_Secondary_Category__c = 'Incentive';
	  prdList.add(prod3);
  
	  product2 prod4 = new product2();
	  prod4.name = 'SSF';
	  prod4.CurrencyIsoCode = 'USD';
	  prod4.Business_Group__c='MN';
	  prod4.Family= 'A&A-CEM';
	  prod4.IsActive=True;
	  prod4.Partner_Visible__c=True;
	  prod4.ProductCode='FC11011';
	  prod4.Apttus_Config2__Version__c=1;
	  prod4.Portfolio__c='Airscale Wifi';
	  prod4.Created_by_PMDI__c = False;
	  prod4.Pricing_Clusters__c='NAM';
	  prod4.IsActive= True;
	  prod4.NokiaCPQ_Item_Type__c= 'Service';
	  prod4.CPQ_Secondary_Category__c = 'Maintnc Or Warranty';
	  prod4.CPQ_Tertiary_Category__c = 'OPS_RTS';
	  prdList.add(prod4);
  
	  insert prdList;
  
	  test.startTest();
	//create pricelist
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
	  Name = 'Commercial Price List', 
	  PriceList_Type__c='CPQ',
	  Apttus_Config2__Type__c='Standard',
	  Apttus_Config2__Active__c = True
	  );
	
	  insert ApttusTestPriceList;
	  //create pricelist Item
	  List<Apttus_Config2__PriceListItem__c> pliList = new List<Apttus_Config2__PriceListItem__c>();
	Apttus_Config2__PriceListItem__c pli1 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
	  );
	  pliList.add(pli1);
	  Apttus_Config2__PriceListItem__c pli2 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod2.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
	  );
	  pliList.add(pli2);
	  insert pliList;
		Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_CQ_Quote').getRecordTypeId(),
		Apttus_Proposal__Account__c = account3[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities1.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_FN_Maintenance_Type__c='',
		NokiaCPQ_SRS_Level__c='',
		NokiaCPQ_Existing_IONMaint_Contract__c='',
		NokiaCPQ_Needs_Reprice__c = false,
		//NokiaCPQ_Environment_Access_Type__c = 'PRM',
		Reprice_In_Progress__c = false,
		NokiaCPQ_Existing_FN_Maint_Contract__c='',
		NokiaCPQ_No_of_Years__c = '',
		NokiaCPQ_ION_Maintenance_Type__c='',
		NokiaCPQ_SSP_Level__c='',
		// NokiaCPQ_Portfolio__c = 'QTC',
		//NokiaCPQ_Maintenance_Type__c ='MN GS TSS Basic',
		Is_List_Price_Only__c = true 
	   );
	  insert testProposal1;
	  testProposal1.CPQ_Contractual_Discounts_Updated__c = true;
	  update testProposal1;
		//create quote contractual discounts entries under quote
		List<CPQ_QuoteContractualDiscount__c> quoteDiscounts = new List<CPQ_QuoteContractualDiscount__c>();
		CPQ_QuoteContractualDiscount__c qd1 = new CPQ_QuoteContractualDiscount__c(
	CPQ_Proposal__c = testProposal1.Id,
	//CPQ_QLD_ICD_ID__c = qld1.Id,
	CPQ_Sequence__c = 1
		);
	  quoteDiscounts.add(qd1);
	  insert quoteDiscounts;
	 //create product configuration
	  Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
		Name = 'APTTUS Test Config', 
		Apttus_Config2__AccountId__c = account3[0].Id, 
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
		Apttus_QPConfig__Proposald__c = testProposal1.Id, 
		Apttus_Config2__Status__c = 'New', 
		Apttus_Config2__VersionNumber__c = 1, 
		Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal1.Id),
		Apttus_Config2__BusinessObjectType__c = 'Proposal'
	  );
	  insert ProdConfig;
	  
	 
	   //Create Line Items
	  list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
	  
  
	  Apttus_Config2__LineItem__c LineItem2 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 2,
		Apttus_Config2__LineNumber__c = 2,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod2.Id,
		CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 100.00,
		Apttus_Config2__ListPrice__c = 200,
		Apttus_Config2__Quantity__c = 1,
	  is_Custom_Product__c=false,	
		Apttus_Config2__PrimaryLineNumber__c = 2,
		CPQ_Rollup_Group_Num__c = 1,
		CPQ_Rollup_Group_Parent__c = true,
		Apttus_Config2__NetPrice__c = 100
	  );
	  allLineItems.add(LineItem2);
  
	  Apttus_Config2__LineItem__c LineItem3 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 3,
		Apttus_Config2__LineNumber__c = 3,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod2.Id,
	 CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		is_Custom_Product__c=false,
		Apttus_Config2__ListPrice__c = 300,
		
		Apttus_Config2__Quantity__c = 1,
		
		Apttus_Config2__PrimaryLineNumber__c = 3,
		CPQ_Rollup_Group_Num__c = 1,
		CPQ_Rollup_Group_Parent__c = true,
		Apttus_Config2__NetPrice__c = 100
	  );
	  allLineItems.add(LineItem3);
	  
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
		Apttus_Config2__ProductId__c = prod4.Id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 3,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		CPQ_Uploaded_via_SSF__c = true,
		CPQ_SSF_Quantity__c = 1,
		CPQ_SSF_Term__c = 2,
		Apttus_Config2__BasePriceOverride__c = 100,
		Apttus_Config2__NetPrice__c = 100
		
	  );
	  allLineItems.add(LineItem1);
	  Apttus_Config2__LineItem__c LineItem4 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 4,
		Apttus_Config2__LineNumber__c = 4,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Maintenance Y1', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod2.Id,
	CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		is_Custom_Product__c=false,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		Apttus_Config2__PrimaryLineNumber__c = 4,
		Apttus_Config2__NetPrice__c = -100
	  );
	  allLineItems.add(LineItem4);
  
  
	Apttus_Config2__LineItem__c LineItem5 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 5,
		Apttus_Config2__LineNumber__c = 5,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod3.Id,
		CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		is_Custom_Product__c=false,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		
		Apttus_Config2__PrimaryLineNumber__c = 5,
		Apttus_Config2__NetPrice__c = -10000
	  );
	  allLineItems.add(LineItem5);
	  Apttus_Config2__LineItem__c LineItem6 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 6,
		Apttus_Config2__LineNumber__c = 6,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod4.Id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 3,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 6,
		CPQ_SSF_Quantity__c = 1,
		CPQ_SSF_Term__c = 2,
		Apttus_Config2__NetPrice__c = 100
		
	  );
	  allLineItems.add(LineItem6);
	  Apttus_Config2__LineItem__c LineItem7 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 7,
		Apttus_Config2__LineNumber__c = 7,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod.Id,
		CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		is_Custom_Product__c=false,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		CPQ_Product_Description__c = 'test',
		Apttus_Config2__PrimaryLineNumber__c = 7,
		Apttus_Config2__NetPrice__c = -100
	  );
	  allLineItems.add(LineItem7);
	  Apttus_Config2__LineItem__c LineItem8 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 8,
		Apttus_Config2__LineNumber__c = 8,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod.Id,
		CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		is_Custom_Product__c=false,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		CPQ_Product_Description__c = 'test',
		Apttus_Config2__PrimaryLineNumber__c = 8,
		CPQ_Contracted_Price__c = 200,
		Apttus_Config2__NetPrice__c = 100
	  );
	  allLineItems.add(LineItem8);
	  
	  Apttus_Config2__LineItem__c LineItem9 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 9,
		Apttus_Config2__LineNumber__c = 9,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod4.Id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 3,
		is_Custom_Product__c=false,
		CPQ_SSF_Permission__c = 'M',
		Apttus_Config2__PrimaryLineNumber__c = 9,
		Apttus_Config2__NetPrice__c = 100
		);
	  allLineItems.add(LineItem9);
	  insert allLineItems;
	  System.debug('debug here for allLineItems' +allLineItems.size());
	  
	   
	  PageReference pref = Page.Apttus_Config2__CartDetailView;
	  Test.setCurrentPage(pref);
	 
	   
	
	  Apttus_Config2.CallbackTester.testValidationCallback(allLineItems[0].Apttus_Config2__ConfigurationId__c, allLineItems, null, new Nokia_Validation_Callback());
	  
		
	  
	  test.stopTest();
	}
	 //surround: May Release -CQ Flow -  Validation call back changes test - end
	static testMethod void testvalidationCallBackFORMNDIRECT() {
	  User sysAdminUser = TestDataFactory.createSystemAdminUser();   
	 System.runAs(sysAdminUser){
	  Nokia_Validation_Callback nvc = new Nokia_Validation_Callback();
	  Apttus_Config2.CustomClass.ValidationResult result;
	  //create account
	  List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
	   insert accounts;
	  
	   //Create Opportunity
	  List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
	  opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities1[0].Account_Role__c = 'GPP Distributor Partner';
	  insert opportunities1; 
	  
	  //Create Product
	  List<Product2> prods = new List<Product2>();
	  Product2 prod1 = new product2(
		Name = 'Test1', 
		ProductCode = '123', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'Nokia Software',
		IsActive = false
	  ); 
	  prods.add(prod1);
	  
	  
	  Product2 prod2 = new product2(
		Name = 'Test2', 
		ProductCode = '1234', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'Nokia Software',
		IsActive = false
	 
	  ); 
	  prods.add(prod2);
	  Product2 prod3 = new product2(
		Name = 'Test3', 
		ProductCode = '12345', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'Nokia Software',
		IsActive = true
	  ); 
	  prods.add(prod3);
	   Product2 prod4 = new product2(
		Name = 'Test4', 
		ProductCode = '1234556', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		Portfolio__c = 'Nokia Software',
		Apttus_Config2__ConfigurationType__c  = 'Bundle',
		IsActive = true
	  ); 
	  prods.add(prod4);
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
		Apttus_Config2__ChargeType__c = 'Maintenance Y1'
	  );
	  //insert pLI2;
	  plistItems.add(pLI2);
	  Apttus_Config2__PriceListItem__c pLI3 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod3.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
	  );
	  plistItems.add(pLI3);
	  
	  test.startTest();
	  List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
	  proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	  proposals[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
	  proposals[0].NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)';
	  proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing'; //MN airscale wifi portfolio
	  proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();//direct draft quote
	  proposals[0].NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c =true;
	  proposals[0].NokiaCPQ_Existing_IONMaint_Contract__c='No';
	  proposals[0].NokiaCPQ_No_of_Years__c='1';
	   insert proposals;  
	   //NSW code creation start here
	  
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
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
	   
		
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
		Apttus_Config2__AdjustmentAmount__c = 100.00,
		Apttus_Config2__ListPrice__c = 200,
		Apttus_Config2__Quantity__c = 1,
	  is_Custom_Product__c=false,   
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
		
		
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
		is_Custom_Product__c=false,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		
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
		Apttus_Config2__ChargeType__c = 'Maintenance Y1', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__PriceListItemId__c = pLI1.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		is_Custom_Product__c=false,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		
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
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod3.Id,
		Apttus_Config2__PriceListItemId__c = pLI3.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		is_Custom_Product__c=false,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		
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
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Option',
		Apttus_Config2__ProductId__c = prod3.Id,
		Apttus_Config2__PriceListItemId__c = pLI3.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
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
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Option',
		Apttus_Config2__ProductId__c = prod3.Id,
		Apttus_Config2__PriceListItemId__c = pLI3.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 100.00,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
		
		
		Apttus_Config2__AddedBy__c = 'added by code'
	  );
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
		Apttus_Config2__LineType__c = 'Option',
		//Apttus_Config2__ProductId__c = prod4.Id,
		Apttus_Config2__OptionId__c = prod4.Id,
		Apttus_Config2__PriceListItemId__c = pLI3.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 100.00,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
		Apttus_Config2__AddedBy__c = 'added by code'
	  );
	   allLineItems.add(LineItem8);
	  insert allLineItems;
	  System.debug('debug here for allLineItems' +allLineItems);
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
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__NetPrice__c =3,
		NokiaCPQ_AdvancePricing_NP__c = 0
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
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__NetPrice__c =3,
		NokiaCPQ_AdvancePricing_NP__c = 0
		
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
	Apttus_Config2__NetPrice__c =3,
		NokiaCPQ_AdvancePricing_NP__c = 0,
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
	Apttus_Config2__NetPrice__c =3,
		NokiaCPQ_AdvancePricing_NP__c = 0,
		Apttus_Config2__Frequency__c = 'One Time'
		
	  );
	  allSummarygrps.add(allSummarygrp4);
	   
	Apttus_Config2__SummaryGroup__c allSummarygrp5 =new Apttus_Config2__SummaryGroup__c(
		Name = 'Subtotal - Standard Price (One Time)',
		Apttus_Config2__LineNumber__c = 1,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
		Apttus_Config2__ExtendedPrice__c = 600,
		Apttus_Config2__Description__c = 'Subtotal - Standard Price (One Time) - Standard Price (One Time)',
		Apttus_Config2__AdjustmentAmount__c = 100,
		Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__NetPrice__c =3,
		NokiaCPQ_AdvancePricing_NP__c = 0 
	  );
	  allSummarygrps.add(allSummarygrp5);
	  insert allSummarygrps;
	  
	  //negative test scenario
	  nvc.isChargeTypeMaintenance(allSummarygrps);
	  nvc.isCADCorrect(allSummarygrps);
	  nvc.isValidLEOAmount(allSummarygrps);
	   
	  PageReference pref = Page.Apttus_Config2__CartDetailView;
	  Test.setCurrentPage(pref);
	  
	  Apttus_Config2.CallbackTester.testValidationCallback(allLineItems[0].Apttus_Config2__ConfigurationId__c, allLineItems, null, new Nokia_Validation_Callback());
	  
	  //create product configuration
	  Apttus_Config2__ProductConfiguration__c testProdConfig = new Apttus_Config2__ProductConfiguration__c(
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
	  insert testProdConfig;  
  
  list<Apttus_Config2__LineItem__c> testAllLineItems = new List<Apttus_Config2__LineItem__c>();
	  Apttus_Config2__LineItem__c testLineItem1 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=testProdConfig.Id,
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
		
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,
		
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
		
		
		Apttus_Config2__AddedBy__c = 'added by code'
	  );
	  
	  testAllLineItems.add(testLineItem1);
	  insert testAllLineItems;
	  
	  
   list<Apttus_Config2__SummaryGroup__c> testAllSummarygrps = new List<Apttus_Config2__SummaryGroup__c>();
	  Apttus_Config2__SummaryGroup__c testAllSummarygrp1 =new Apttus_Config2__SummaryGroup__c(
		Name = 'Total (One Time)',
		Apttus_Config2__LineNumber__c = 1,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__ConfigurationId__c = testProdConfig.Id ,
		Apttus_Config2__ExtendedPrice__c = 600,
		Apttus_Config2__Description__c = 'Total (One Time) (One Time)',
		Apttus_Config2__AdjustmentAmount__c = 800,
		Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__Frequency__c = 'One Time'
		
	  );
	  testAllSummarygrps.add(testAllSummarygrp1);
	  insert testAllSummarygrps;
	  
	  
	  
	  nvc.isCADCorrect(testAllSummarygrps);
	  
	  Apttus_Config2.CallbackTester.testValidationCallback(testAllLineItems[0].Apttus_Config2__ConfigurationId__c, testAllLineItems, null, new Nokia_Validation_Callback());
	
	  //create product configuration
	  Apttus_Config2__ProductConfiguration__c testProdConfig1 = new Apttus_Config2__ProductConfiguration__c(
		Name = 'APTTUS Test Config', 
		Apttus_Config2__AccountId__c = accounts[0].Id, 
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
		Apttus_QPConfig__Proposald__c = proposals[0].Id, 
		Apttus_Config2__Status__c = 'New', 
		Apttus_Config2__VersionNumber__c = 1, 
		Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__BusinessObjectId__c = String.valueOf(proposals[0].Id)
	  );
	  insert testProdConfig1;  
  
  list<Apttus_Config2__LineItem__c> testAllLineItems1 = new List<Apttus_Config2__LineItem__c>();
	  Apttus_Config2__LineItem__c testLineItem11 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=testProdConfig1.Id,
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
		
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,
		
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
		
		
		Apttus_Config2__AddedBy__c = 'added by code'
	  );
	  
	  testAllLineItems1.add(testLineItem11);
	  insert testAllLineItems1;
	 
	  
   list<Apttus_Config2__SummaryGroup__c> testAllSummarygrps1 = new List<Apttus_Config2__SummaryGroup__c>();
	  Apttus_Config2__SummaryGroup__c testAllSummarygrp11 =new Apttus_Config2__SummaryGroup__c(
		Name = 'Total (One Time)',
		Apttus_Config2__LineNumber__c = 1,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__ConfigurationId__c = testProdConfig1.Id ,
		Apttus_Config2__ExtendedPrice__c = 600,
		Apttus_Config2__Description__c = 'Total (One Time) (One Time)',
		Apttus_Config2__AdjustmentAmount__c = 800,
		Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__Frequency__c = 'One Time'
		
	  );
	  testAllSummarygrps1.add(testAllSummarygrp11);
	  insert testAllSummarygrps1;
	  
	  nvc.isCADCorrect(testAllSummarygrps1);
	  
	  Apttus_Config2.CallbackTester.testValidationCallback(testAllLineItems1[0].Apttus_Config2__ConfigurationId__c, testAllLineItems1, null, new Nokia_Validation_Callback());
	  Test.stopTest();
	 }
	}
  
	static testMethod void testvalidationCallBackFORMNINDIRECT() {
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
	  opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	  opportunities1[0].End_Customer_LE__c = accounts1[0].Id;
	  opportunities1[0].Account_Role__c = 'GPP Distributor Partner';
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
	  List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	  proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	  proposals[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
	
	  proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing'; //MN airscale wifi portfolio
	  //proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Indirect Quote').getRecordTypeId();
	  insert proposals;   
	  
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
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		NokiaCPQ_Spare__c=true,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
	 
		
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
		Apttus_Config2__AdjustmentAmount__c = 100.00,
		Apttus_Config2__ListPrice__c = 200,
		Apttus_Config2__Quantity__c = 1,
		NokiaCPQ_Spare__c=true,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
	 
		
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
		NokiaCPQ_Spare__c=true,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
	 
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
		Apttus_Config2__ChargeType__c = 'Maintenance Y1', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__PriceListItemId__c = pLI1.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		NokiaCPQ_Spare__c=true,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
	 
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
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__PriceListItemId__c = pLI1.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		NokiaCPQ_Spare__c=true,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
	 
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
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Option',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__PriceListItemId__c = pLI1.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
		
		
		Apttus_Config2__AddedBy__c = 'added by code'
	  );
	  //insert LineItem1;
	  allLineItems.add(LineItem6);
	  
  list<Apttus_Config2__LineItem__c> testAllLineItems1 = new List<Apttus_Config2__LineItem__c>();
	  Apttus_Config2__LineItem__c testLineItem11 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Option',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__PriceListItemId__c = pLI1.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
	 
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,
		
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
		
		
		Apttus_Config2__AddedBy__c = 'added by code'
	  );
	  
	  testAllLineItems1.add(testLineItem11);
	  insert testAllLineItems1;
	  
	  //Create summary Group
	  //
	  list<Apttus_Config2__SummaryGroup__c> allSummarygrps = new List<Apttus_Config2__SummaryGroup__c>();
	  Apttus_Config2__SummaryGroup__c allSummarygrp1 =new Apttus_Config2__SummaryGroup__c(
		Name = 'Configurable Products',
		Apttus_Config2__LineNumber__c = 1,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
		Apttus_Config2__ExtendedPrice__c = 600,
		Apttus_Config2__Description__c = 'Total (One Time) (One Time)',
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
	  Apttus_Config2.CallbackTester.testValidationCallback(testAllLineItems1[0].Apttus_Config2__ConfigurationId__c, testAllLineItems1, null, new Nokia_Validation_Callback());   
	  test.stopTest();
	}
	
	static testMethod void testvalidationCallBackFORMNINDIRECT10000() {
	  
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
	  opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	  opportunities1[0].End_Customer_LE__c = accounts1[0].Id;
	  opportunities1[0].Account_Role__c = 'GPP Distributor Partner';
	  insert opportunities1;
	  
	  //Create Product
	  List<Product2> prods = new List<Product2>();
	  Product2 prod1 = new product2(
		Name = 'Test2', 
		ProductCode = '456', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c='Bundle'
	  ); 
	  prods.add(prod1);
	  
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
	 
	  List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	  proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	  proposals[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
	  
	  proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing'; //MN airscale wifi portfolio
	  //proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Indirect Quote').getRecordTypeId();
	  insert proposals;   
	  
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
		Apttus_Config2__LineType__c = 'Misc',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__PriceListItemId__c = pLI1.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Invalid_Maintenance_type__c = true,
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
   
	  
  list<Apttus_Config2__LineItem__c> testAllLineItems1 = new List<Apttus_Config2__LineItem__c>();
	  Apttus_Config2__LineItem__c testLineItem11 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		//Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Misc',
		Apttus_Config2__ProductId__c = prod1.Id,
		Apttus_Config2__PriceListItemId__c = pLI1.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Invalid_Maintenance_type__c = true,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,
		
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
		
		
		Apttus_Config2__AddedBy__c = 'added by code'
	  );
	  
	  testAllLineItems1.add(testLineItem11);
	  insert testAllLineItems1;
	  
	  //Create summary Group
	  //
	  list<Apttus_Config2__SummaryGroup__c> allSummarygrps = new List<Apttus_Config2__SummaryGroup__c>();
	  Apttus_Config2__SummaryGroup__c allSummarygrp1 =new Apttus_Config2__SummaryGroup__c(
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
	  Apttus_Config2.CallbackTester.testValidationCallback(testAllLineItems1[0].Apttus_Config2__ConfigurationId__c, testAllLineItems1, null, new Nokia_Validation_Callback());   
	  test.stopTest();
	}
	
	   static testMethod void INDIRECT1() {
	  
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
	  opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	  opportunities1[0].End_Customer_LE__c = accounts1[0].Id;
	  opportunities1[0].Account_Role__c = 'GPP Distributor Partner';
	  insert opportunities1;
	  
	  //Create Product
	  List<Product2> prods = new List<Product2>();
	  Product2 prod1 = new product2(
		Name = 'Test2', 
		ProductCode = '456', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c='Bundle'
	  ); 
	  prods.add(prod1);
	  
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
	 
	  List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	  proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	  proposals[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
	  
	  proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing'; //MN airscale wifi portfolio
	  //proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Indirect Quote').getRecordTypeId();
	  insert proposals;   
	  
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
		Apttus_Config2__LineType__c = 'Product/Service',
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
   
	  
  list<Apttus_Config2__LineItem__c> testAllLineItems1 = new List<Apttus_Config2__LineItem__c>();
	  Apttus_Config2__LineItem__c testLineItem11 =new Apttus_Config2__LineItem__c(
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
		NokiaCPQ_Spare__c=true,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,
	 
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
		
		
		Apttus_Config2__AddedBy__c = 'added by code'
	  );
	  
	  testAllLineItems1.add(testLineItem11);
	  insert testAllLineItems1;
	  
	  //Create summary Group
	  //
	  list<Apttus_Config2__SummaryGroup__c> allSummarygrps = new List<Apttus_Config2__SummaryGroup__c>();
	  Apttus_Config2__SummaryGroup__c allSummarygrp1 =new Apttus_Config2__SummaryGroup__c(
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
	  Apttus_Config2.CallbackTester.testValidationCallback(testAllLineItems1[0].Apttus_Config2__ConfigurationId__c, testAllLineItems1, null, new Nokia_Validation_Callback());   
	  test.stopTest();
	}  
	static testMethod void INDIRECT2() {
	Nokia_Validation_Callback nvc = new Nokia_Validation_Callback();
	  
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
	  opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	  opportunities1[0].End_Customer_LE__c = accounts1[0].Id;
	  opportunities1[0].Account_Role__c = 'GPP Distributor Partner';
	  insert opportunities1;
	  
	  //Create Product
	  //Prodid=[select id,Quote_Type__c,NokiaCPQ_Portfolio_From_Quote__c from Apttus_Config2__ProductConfiguration__c]
	  List<Product2> prods = new List<Product2>();
	  Product2 prod1 = new product2(
		Name = 'Test2', 
		ProductCode = '456', 
		Business_Group__c = 'MN', 
		CurrencyIsoCode = 'USD',
		IsActive = true,
		//Prodid.NokiaCPQ_Portfolio_From_Quote__c = 'QTC',
		Apttus_Config2__ConfigurationType__c='Bundle'
	  ); 
	  prods.add(prod1);
	  
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
	 
	  List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	  proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	  proposals[0].Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
	proposals[0].NokiaCPQ_LEO_Discount__c=true;
	  proposals[0].NokiaCPQ_Portfolio__c = 'IP Routing'; //MN airscale wifi portfolio
	  proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	  insert proposals;   
	  
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
		Apttus_Config2__BusinessObjectType__c = 'Proposal',
		NokiaCPQ_Portfolio__c = 'QTC'
		
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
		Apttus_Config2__LineType__c = 'Product/Service',
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
   
	  
  list<Apttus_Config2__LineItem__c> testAllLineItems1 = new List<Apttus_Config2__LineItem__c>();
	  Apttus_Config2__LineItem__c testLineItem11 =new Apttus_Config2__LineItem__c(
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
		NokiaCPQ_Spare__c=true,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,
	 
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
		
		
		Apttus_Config2__AddedBy__c = 'added by code'
	  );
	  
	  testAllLineItems1.add(testLineItem11);
	  insert testAllLineItems1;
	  
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
	  
	  //negative test scenario
	  nvc.isChargeTypeMaintenance(allSummarygrps);
	  nvc.isCADCorrect(allSummarygrps);
	  nvc.isValidLEOAmount(allSummarygrps);
	  Apttus_Config2.CallbackTester.testValidationCallback(testAllLineItems1[0].Apttus_Config2__ConfigurationId__c, testAllLineItems1, null, new Nokia_Validation_Callback());   
	  test.stopTest();
	}  
	
	  static testMethod void testmothd() {
	
	Nokia_Validation_Callback nvc = new Nokia_Validation_Callback();
	  Apttus_Config2.CustomClass.ValidationResult result;
	
	  List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	  account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	 
	  insert account3;
	  
	  List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
	  opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities1[0].Account_Role__c = 'GPP Distributor Partner';
	  insert opportunities1;
	 
	/*create product*/
	product2 prod = new product2();
	  prod.name = '5G';
	  prod.CurrencyIsoCode = 'USD';
	  prod.Business_Group__c='MN';
	  prod.Family= 'A&A-CEM';
	  prod.IsActive=True;
	  prod.Partner_Visible__c=True;
	  prod.ProductCode='FC11011';
	  prod.Apttus_Config2__Version__c=1;
	  prod.Portfolio__c='Airscale Wifi';
	  prod.Created_by_PMDI__c = False;
	  prod.Pricing_Clusters__c='NAM';
	  prod.IsActive= True;
	  insert prod;
  
	  test.startTest(); 
	/*create pricelist*/
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
	  Name = 'Commercial Price List', 
	  PriceList_Type__c='CPQ',
	  Apttus_Config2__Type__c='Standard',
	  Apttus_Config2__Active__c = True
	  );
	
	  insert ApttusTestPriceList;
	  /*create pricelist Item*/
	Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
	  );
	  insert pLI5;
	 
		Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),
		Apttus_Proposal__Account__c = account3[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities1.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_FN_Maintenance_Type__c='',
		NokiaCPQ_SRS_Level__c='',
		NokiaCPQ_Existing_IONMaint_Contract__c='',
		NokiaCPQ_Needs_Reprice__c = false,
		//NokiaCPQ_Environment_Access_Type__c = 'PRM',
		Reprice_In_Progress__c = false,
		NokiaCPQ_Existing_FN_Maint_Contract__c='',
		NokiaCPQ_No_of_Years__c = '',
		NokiaCPQ_ION_Maintenance_Type__c='',
		NokiaCPQ_SSP_Level__c='',
		NokiaCPQ_Portfolio__c = 'QTC',
		//NokiaCPQ_Maintenance_Type__c ='MN GS TSS Basic',
		Is_List_Price_Only__c = true 
	   );
	  insert testProposal1;
	  
	 //create product configuration
	  Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
		Name = 'APTTUS Test Config', 
		Apttus_Config2__AccountId__c = account3[0].Id, 
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
		Apttus_QPConfig__Proposald__c = testProposal1.Id, 
		Apttus_Config2__Status__c = 'New', 
		Apttus_Config2__VersionNumber__c = 1, 
		Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal1.Id),
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
		Apttus_Config2__ProductId__c = prod.Id,
	CPQ_Market_Model__c='',
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
	 
	   
		
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
		Apttus_Config2__ProductId__c = prod.Id,
		CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 100.00,
		Apttus_Config2__ListPrice__c = 200,
		Apttus_Config2__Quantity__c = 1,
	  is_Custom_Product__c=false,   
		Apttus_Config2__PrimaryLineNumber__c = 1,
	
		
		
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
		Apttus_Config2__ProductId__c = prod.Id,
	 CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		is_Custom_Product__c=false,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		
		Apttus_Config2__PrimaryLineNumber__c = 1,
	   
		
		
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
		Apttus_Config2__ChargeType__c = 'Maintenance Y1', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod.Id,
	CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		is_Custom_Product__c=false,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		
		Apttus_Config2__PrimaryLineNumber__c = 1,
	   
		
		
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
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod.Id,
		CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		is_Custom_Product__c=false,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		
		Apttus_Config2__PrimaryLineNumber__c = 1,
	
		
		
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
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Option',
		Apttus_Config2__ProductId__c = prod.Id,
		CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
	   
		
		
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
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Option',
		Apttus_Config2__ProductId__c = prod.Id,
	CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 100.00,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
	
		
		Apttus_Config2__AddedBy__c = 'added by code'
	  );
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
		Apttus_Config2__LineType__c = 'Option',
		Apttus_Config2__ProductId__c = prod.Id,
	CPQ_Market_Model__c='Test1 QTY(1)',
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 100.00,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
	
		
		Apttus_Config2__AddedBy__c = 'added by code'
	  );
	   allLineItems.add(LineItem8);
	  insert allLineItems;
	  System.debug('debug here for allLineItems' +allLineItems);
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
	  
	 /*   allSummarygrps.add(allSummarygrp2);
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
	  */ 
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
	
	Apttus_Config2__SummaryGroup__c allSummarygrp5 =new Apttus_Config2__SummaryGroup__c(
		Name = 'Subtotal - Standard Price (One Time)',
		Apttus_Config2__LineNumber__c = 1,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
		Apttus_Config2__ExtendedPrice__c = 10,
		Apttus_Config2__Description__c = 'Total (One Time) (One Time)',
		Apttus_Config2__AdjustmentAmount__c =5,
		Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__Frequency__c = 'One Time'
		
	  );
	  allSummarygrps.add(allSummarygrp5);
	  insert allSummarygrps;
	  
	  //negative test scenario
	  nvc.isChargeTypeMaintenance(allSummarygrps);
	  nvc.isCADCorrect(allSummarygrps);
	  nvc.isValidLEOAmount(allSummarygrps);
	   
	  PageReference pref = Page.Apttus_Config2__CartDetailView;
	  Test.setCurrentPage(pref);
	 
	  
	
	  Apttus_Config2.CallbackTester.testValidationCallback(allLineItems[0].Apttus_Config2__ConfigurationId__c, allLineItems, null, new Nokia_Validation_Callback());
	  
		
	  
	  test.stopTest();
	 }
	 
	 //added by Monika to cover MPW Lines for Req:7278 - 10/8/2020
	  static testMethod void MPW() {
	Nokia_Validation_Callback nvc = new Nokia_Validation_Callback();
	User sysAdminUser = TestDataFactory.createSystemAdminUser();   
	 System.runAs(sysAdminUser){ 
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
	  List<opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
	  opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
	  opportunities1[0].End_Customer_LE__c = accounts1[0].Id;
	  opportunities1[0].StageName = 'Create Offer (Bid)';
	  opportunities1[0].Phase_Status__c ='Offer in Progress';
	  opportunities1[0].Account_Role__c = 'GPP Distributor Partner';
	  insert opportunities1;
	  
	  //Create Product
	  //Prodid=[select id,Quote_Type__c,NokiaCPQ_Portfolio_From_Quote__c from Apttus_Config2__ProductConfiguration__c]
	  List<Product2> prods = new List<Product2>();
	  Product2 prod1 = new product2(
		Name = 'Test2', 
		ProductCode = '456', 
		//Business_Group__c = 'MN', 
		CurrencyIsoCode = 'EUR',
		IsActive = true,
		Apttus_Config2__ConfigurationType__c='Bundle'
	  ); 
	  prods.add(prod1);
	  
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
	 
	//  List<Apttus_Proposal__Proposal__c> proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
	  Apttus_Proposal__Proposal__c proposals = new Apttus_Proposal__Proposal__c();
	  proposals.Apttus_Proposal__Proposal_Name__c = 'MPW Proposal';
	  proposals.NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
	  proposals.Apttus_Proposal__Account__c = accounts[0].Id;
	  proposals.Apttus_Proposal__Opportunity__c = opportunities1[0].Id;
	  proposals.NokiaCPQ_LEO_Discount__c=true;
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
		Apttus_Config2__LineType__c = 'Product/Service',
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
   
	  
  list<Apttus_Config2__LineItem__c> testAllLineItems1 = new List<Apttus_Config2__LineItem__c>();
	  Apttus_Config2__LineItem__c testLineItem11 =new Apttus_Config2__LineItem__c(
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
		NokiaCPQ_Spare__c=true,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,
	 
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
		
		
		Apttus_Config2__AddedBy__c = 'added by code'
	  );
	  
	  testAllLineItems1.add(testLineItem11);
	  insert testAllLineItems1;
	  
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
	  
	  //negative test scenario
	  nvc.isChargeTypeMaintenance(allSummarygrps);
	  nvc.isCADCorrect(allSummarygrps);
	  nvc.isValidLEOAmount(allSummarygrps);
	  Apttus_Config2.CallbackTester.testValidationCallback(testAllLineItems1[0].Apttus_Config2__ConfigurationId__c, testAllLineItems1, null, new Nokia_Validation_Callback());   
	  test.stopTest();
	} 
	} //end
	
	//new test method added to cover isNCQ quotes - start
	 static testMethod void testmothdIsNCQ() {  
	
	  Nokia_Validation_Callback nvc = new Nokia_Validation_Callback();
	  Apttus_Config2.CustomClass.ValidationResult result;
	
	  List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	  account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	 
	  insert account3;
	  
	  List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
	  opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities1[0].Account_Role__c = 'GPP Distributor Partner';
	  insert opportunities1;
	 
	/*create product*/
	product2 prod = new product2();
	  prod.name = '5G';
	  prod.CurrencyIsoCode = 'USD';
	  prod.Business_Group__c='MN';
	  prod.Family= 'A&A-CEM';
	  prod.IsActive=True;
	  prod.Partner_Visible__c=True;
	  prod.ProductCode='FC11011';
	  prod.Apttus_Config2__Version__c=1;
	  prod.Portfolio__c='Airscale Wifi';
	  prod.Created_by_PMDI__c = False;
	  prod.Pricing_Clusters__c='NAM';
	  prod.IsActive= True;
	  insert prod;
  
	  test.startTest(); 
	/*create pricelist*/
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
	  Name = 'Commercial Price List', 
	  PriceList_Type__c='CPQ',
	  Apttus_Config2__Type__c='Standard',
	  Apttus_Config2__Active__c = True
	  );
	
	  insert ApttusTestPriceList;
	  /*create pricelist Item*/
	Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
	  );
	  insert pLI5;
	 
		Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_NCQ_Quote').getRecordTypeId(),
		Apttus_Proposal__Account__c = account3[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities1.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_FN_Maintenance_Type__c='',
		NokiaCPQ_SRS_Level__c='',
		NokiaCPQ_Existing_IONMaint_Contract__c='',
		NokiaCPQ_Needs_Reprice__c = false,
		//NokiaCPQ_Environment_Access_Type__c = 'PRM',
		Reprice_In_Progress__c = false,
		NokiaCPQ_Existing_FN_Maint_Contract__c='',
		NokiaCPQ_No_of_Years__c = '',
		NokiaCPQ_ION_Maintenance_Type__c='',
		NokiaCPQ_SSP_Level__c='',
		// NokiaCPQ_Portfolio__c = 'QTC',
		//NokiaCPQ_Maintenance_Type__c ='MN GS TSS Basic',
		Is_List_Price_Only__c = true 
	   );
	  insert testProposal1;
	  
	 //create product configuration
	  Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
		Name = 'APTTUS Test Config', 
		Apttus_Config2__AccountId__c = account3[0].Id, 
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
		Apttus_QPConfig__Proposald__c = testProposal1.Id, 
		Apttus_Config2__Status__c = 'New', 
		Apttus_Config2__VersionNumber__c = 1, 
		Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal1.Id),
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
		Apttus_Config2__ProductId__c = prod.Id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 3,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__AddedBy__c = 'added by code',
		CPQ_Market_Model__c = 'group 1',
		CPQ_Group_Quantity__c = 2
		
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
		Apttus_Config2__ProductId__c = prod.Id,
		CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 100.00,
		Apttus_Config2__ListPrice__c = 200,
		Apttus_Config2__Quantity__c = 1,
	  is_Custom_Product__c=false,   
		Apttus_Config2__PrimaryLineNumber__c = 1,
	
		
		
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
		Apttus_Config2__ProductId__c = prod.Id,
	 CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		is_Custom_Product__c=false,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		
		Apttus_Config2__PrimaryLineNumber__c = 1,
	   
		
		
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
		Apttus_Config2__ChargeType__c = 'Maintenance Y1', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod.Id,
	CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		is_Custom_Product__c=false,
		Apttus_Config2__ListPrice__c = 120,
		Apttus_Config2__Quantity__c = 1,
		
		Apttus_Config2__PrimaryLineNumber__c = 1,
	   
		
		
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
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod.Id,
		CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		is_Custom_Product__c=false,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		
		Apttus_Config2__PrimaryLineNumber__c = 1,
	
		
		
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
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Option',
		Apttus_Config2__ProductId__c = prod.Id,
		CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
	   
		
		
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
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Option',
		Apttus_Config2__ProductId__c = prod.Id,
	CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 100.00,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
	
		
		Apttus_Config2__AddedBy__c = 'added by code'
	  );
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
		Apttus_Config2__LineType__c = 'Option',
		Apttus_Config2__ProductId__c = prod.Id,
	CPQ_Market_Model__c='Test1 QTY(1)',
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 100.00,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
	
		
		Apttus_Config2__AddedBy__c = 'added by code'
	  );
	   allLineItems.add(LineItem8);
	  insert allLineItems;
	  System.debug('debug here for allLineItems' +allLineItems);
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
	
	Apttus_Config2__SummaryGroup__c allSummarygrp5 =new Apttus_Config2__SummaryGroup__c(
		Name = 'Subtotal - Standard Price (One Time)',
		Apttus_Config2__LineNumber__c = 1,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
		Apttus_Config2__ExtendedPrice__c = 10,
		Apttus_Config2__Description__c = 'Total (One Time) (One Time)',
		Apttus_Config2__AdjustmentAmount__c =5,
		Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__Frequency__c = 'One Time'
		
	  );
	  allSummarygrps.add(allSummarygrp5);
	  insert allSummarygrps;
	  
	  //negative test scenario
	  nvc.isChargeTypeMaintenance(allSummarygrps);
	  nvc.isCADCorrect(allSummarygrps);
	  nvc.isValidLEOAmount(allSummarygrps);
	   
	  PageReference pref = Page.Apttus_Config2__CartDetailView;
	  Test.setCurrentPage(pref);
	 
	  
	
	  Apttus_Config2.CallbackTester.testValidationCallback(allLineItems[0].Apttus_Config2__ConfigurationId__c, allLineItems, null, new Nokia_Validation_Callback());
	  
		
	  
	  test.stopTest();
	 }
	 //new test method added to cover isNCQ quotes - end
	  static testMethod void testJarviscovergae() {
	
	Nokia_Validation_Callback nvc = new Nokia_Validation_Callback();
	  Apttus_Config2.CustomClass.ValidationResult result;
	
	  List <Account> account3 = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	  account3[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	 
	  insert account3;
	  
	  List<Opportunity> opportunities1 = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account3);
	  opportunities1[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities1[0].Account_Role__c = 'GPP Distributor Partner';
	  insert opportunities1;
	 
	/*create product*/
	product2 prod = new product2();
	  prod.name = '5G';
	  prod.CurrencyIsoCode = 'USD';
	  prod.Business_Group__c='MN';
	  prod.Family= 'A&A-CEM';
	  prod.IsActive=True;
	  prod.Partner_Visible__c=True;
	  prod.ProductCode='FC11011';
	  prod.Apttus_Config2__Version__c=1;
	  prod.Portfolio__c='IP Routing';
	  prod.Created_by_PMDI__c = False;
	  prod.Pricing_Clusters__c='NAM';
	  prod.IsActive= True;
	  prod.Direct_Portfolio__c= 'IP Routing';
	  insert prod;
  
	  test.startTest(); 
	/*create pricelist*/
	  Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
	  Name = 'Commercial Price List', 
	  PriceList_Type__c='CPQ',
	  Apttus_Config2__Type__c='Standard',
	  Apttus_Config2__Active__c = True
	  );
	
	  insert ApttusTestPriceList;
	  /*create pricelist Item*/
	Apttus_Config2__PriceListItem__c pLI5 = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
	  );
	  insert pLI5;
	 
		Apttus_Proposal__Proposal__c testProposal1 = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),
		Apttus_Proposal__Account__c = account3[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities1.get(0).Id,
		Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_FN_Maintenance_Type__c='',
		NokiaCPQ_SRS_Level__c='',
		NokiaCPQ_Existing_IONMaint_Contract__c='',
		NokiaCPQ_Needs_Reprice__c = false,
		//NokiaCPQ_Environment_Access_Type__c = 'PRM',
		Reprice_In_Progress__c = false,
		NokiaCPQ_Existing_FN_Maint_Contract__c='',
		NokiaCPQ_No_of_Years__c = '',
		NokiaCPQ_ION_Maintenance_Type__c='',
		NokiaCPQ_SSP_Level__c='',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		//NokiaCPQ_Maintenance_Type__c ='MN GS TSS Basic',
		Is_List_Price_Only__c = false 
	   );
	  insert testProposal1;
	  
	 //create product configuration
	  Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c(
		Name = 'APTTUS Test Config', 
		Apttus_Config2__AccountId__c = account3[0].Id, 
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
		Apttus_QPConfig__Proposald__c = testProposal1.Id, 
		Apttus_Config2__Status__c = 'New', 
		Apttus_Config2__VersionNumber__c = 1, 
		Apttus_Config2__EffectivePriceListId__c = ApttusTestPriceList.Id,
		Apttus_Config2__BusinessObjectId__c = String.valueOf(testProposal1.Id),
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
		Apttus_Config2__ProductId__c = prod.Id,
	CPQ_Market_Model__c='',
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Source__c='JARVIS',
		Apttus_Config2__CopySourceNumber__c=0,   
	   
		
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
		Apttus_Config2__ProductId__c = prod.Id,
		CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 100.00,
		Apttus_Config2__ListPrice__c = 200,
		Apttus_Config2__Quantity__c = 1,
	  is_Custom_Product__c=false,	
		Apttus_Config2__PrimaryLineNumber__c = 1,
	Source__c='JARVIS',
		Apttus_Config2__CopySourceNumber__c=0,  
		
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
		Apttus_Config2__ProductId__c = prod.Id,
	 CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		is_Custom_Product__c=false,
		Apttus_Config2__ListPrice__c = 300,
		Apttus_Config2__Quantity__c = 1,
		
		Apttus_Config2__PrimaryLineNumber__c = 1,
	   
		Source__c='JARVIS',
		Apttus_Config2__CopySourceNumber__c=0, 
		
		Apttus_Config2__AddedBy__c = 'added by code'
	  );
	  //insert LineItem1;
	  allLineItems.add(LineItem3);
	  
	  
	  insert allLineItems;
	  System.debug('debug here for allLineItems' +allLineItems);
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
	
	Apttus_Config2__SummaryGroup__c allSummarygrp5 =new Apttus_Config2__SummaryGroup__c(
		Name = 'Subtotal - Standard Price (One Time)',
		Apttus_Config2__LineNumber__c = 1,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__ConfigurationId__c = ProdConfig.Id ,
		Apttus_Config2__ExtendedPrice__c = 10,
		Apttus_Config2__Description__c = 'Total (One Time) (One Time)',
		Apttus_Config2__AdjustmentAmount__c =5,
		Apttus_Config2__ChargeType__c = 'Standard Type',
		Apttus_Config2__Frequency__c = 'One Time'
		
	  );
	  allSummarygrps.add(allSummarygrp5);
	  insert allSummarygrps;
	  
	  //negative test scenario
	  /* nvc.isChargeTypeMaintenance(allSummarygrps);
	  nvc.isCADCorrect(allSummarygrps);
	  nvc.isValidLEOAmount(allSummarygrps); */
	   
	  PageReference pref = Page.Apttus_Config2__CartDetailView;
	  Test.setCurrentPage(pref);
	 
	  
	
	  Apttus_Config2.CallbackTester.testValidationCallback(allLineItems[0].Apttus_Config2__ConfigurationId__c, allLineItems, null, new Nokia_Validation_Callback());
	  
		
	  
	  test.stopTest();
	 }
	 static testMethod void testSitePhase() {
	
	  Nokia_Validation_Callback nvc = new Nokia_Validation_Callback();
	  Apttus_Config2.CustomClass.ValidationResult result;
	
	  List <Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
	  accounts[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	 
	  insert accounts;
	  
	  List<Opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
	  opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	  opportunities[0].Account_Role__c = 'GPP Distributor Partner';
	  insert opportunities;
	 
	/*create product*/
	product2 prod = new product2();
	  prod.name = '5G';
	  prod.CurrencyIsoCode = 'USD';
	  prod.Business_Group__c='MN';
	  prod.Family= 'A&A-CEM';
	  prod.IsActive=True;
	  prod.Partner_Visible__c=True;
	  prod.ProductCode='FC11011';
	  prod.Apttus_Config2__Version__c=1;
	  prod.Portfolio__c='IP Routing';
	  prod.Created_by_PMDI__c = False;
	  prod.Pricing_Clusters__c='NAM';
	  prod.IsActive= True;
	  prod.Direct_Portfolio__c= 'IP Routing';
	  insert prod;
  
	  test.startTest(); 
	/*create pricelist*/
	  Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c(
	  Name = 'Commercial Price List', 
	  PriceList_Type__c='CPQ',
	  Apttus_Config2__Type__c='Standard',
	  Apttus_Config2__Active__c = True
	  );
	
	  insert priceList;
	  /*create pricelist Item*/
	Apttus_Config2__PriceListItem__c pli = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = prod.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
	  );
	  insert pli;
	 
		Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c(
		RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId(),
		Apttus_Proposal__Account__c = accounts[0].Id,
		Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
		Apttus_QPConfig__PriceListId__c = priceList.Id,
		Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
		NokiaCPQ_FN_Maintenance_Type__c='',
		NokiaCPQ_SRS_Level__c='',
		NokiaCPQ_Existing_IONMaint_Contract__c='',
		NokiaCPQ_Needs_Reprice__c = false,
		Reprice_In_Progress__c = false,
		NokiaCPQ_Existing_FN_Maint_Contract__c='',
		NokiaCPQ_No_of_Years__c = '',
		NokiaCPQ_ION_Maintenance_Type__c='',
		NokiaCPQ_SSP_Level__c='',
		NokiaCPQ_Portfolio__c = 'IP Routing',
		Is_List_Price_Only__c = false 
	   );
	  insert proposal;
	  
	 //create product configuration
	  Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c(
		Name = 'APTTUS Test Config', 
		Apttus_Config2__AccountId__c = accounts[0].Id, 
		Apttus_Config2__PriceListId__c = priceList.Id, 
		Apttus_QPConfig__Proposald__c = proposal.Id, 
		Apttus_Config2__Status__c = 'New', 
		Apttus_Config2__VersionNumber__c = 1, 
		Apttus_Config2__EffectivePriceListId__c = priceList.Id,
		Apttus_Config2__BusinessObjectId__c = String.valueOf(proposal.Id),
		Apttus_Config2__BusinessObjectType__c = 'Proposal'
	  );
	  insert prodConfig;
	  
	 
	   //Create Line Items
	  list<Apttus_Config2__LineItem__c> allLineItems = new List<Apttus_Config2__LineItem__c>();
	  Apttus_Config2__LineItem__c llneItem1 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=prodConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = priceList.id,
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod.Id,
		CPQ_Market_Model__c='',
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 100,
		is_Custom_Product__c=false,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__CopySourceNumber__c=0,   
		Apttus_Config2__AddedBy__c = 'added by code'
	  );
	  allLineItems.add(llneItem1);
	  Apttus_Config2__LineItem__c lineItem2 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = priceList.id,
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = prod.Id,
		CPQ_Market_Model__c=null,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 100.00,
		Apttus_Config2__ListPrice__c = 200,
		Apttus_Config2__Quantity__c = 50,
		is_Custom_Product__c=false,  
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__CopySourceNumber__c=0,  
		Apttus_Config2__AddedBy__c = 'added by code'
	  );
	  allLineItems.add(lineItem2);
	  insert allLineItems;
  
	  List<CPQ_Site_Phase_and_Quantity__c> sitePhases = new List<CPQ_Site_Phase_and_Quantity__c>();
	  CPQ_Site_Phase_and_Quantity__c sp1 = new CPQ_Site_Phase_and_Quantity__c(Line_Item__c=llneItem1.id, NCPQ_Quantity__c = -6);
	  sitePhases.add(sp1);
	  insert sitePhases;
  
	   
	  PageReference pref = Page.Apttus_Config2__CartDetailView;
	  Test.setCurrentPage(pref);
	  
	  Nokia_Validation_Callback vcb = new Nokia_Validation_Callback();
	  vcb.pageAction = 'Finalize';
	
	  Apttus_Config2.CallbackTester.testValidationCallback(allLineItems[0].Apttus_Config2__ConfigurationId__c, allLineItems, null, vcb);
	  
	  sitePhases[0].NCPQ_Quantity__c = 60; 
	  update sitePhases;
  
	  Apttus_Config2.CallbackTester.testValidationCallback(allLineItems[0].Apttus_Config2__ConfigurationId__c, allLineItems, null, vcb);
  
	  // CPQ_Site_Phase_and_Quantity__c sp2 = new CPQ_Site_Phase_and_Quantity__c(Line_Item__c=lineItem2.id, NCPQ_Quantity__c = 6);
	  // sitePhases.add(sp2);
	  sitePhases[0].NCPQ_Quantity__c = 100; 
	  update sitePhases;
  
	  Apttus_Config2.CallbackTester.testValidationCallback(allLineItems[0].Apttus_Config2__ConfigurationId__c, allLineItems, null, vcb);
  
	  NokiaCPQ_Phase__c  phase = new NokiaCPQ_Phase__c();
	  phase.Name = '2021';
	  phase.Opportunity__c = opportunities[0].Id;
	  insert phase;
  
	  sitePhases[0].NCPQ_Phase__c = phase.Id;
	  CPQ_Site_Phase_and_Quantity__c sp2 = new CPQ_Site_Phase_and_Quantity__c(Line_Item__c=lineItem2.id, NCPQ_Quantity__c = 6);
	  sitePhases.add(sp2); 
	  upsert sitePhases;
  
	  Apttus_Config2.CallbackTester.testValidationCallback(allLineItems[0].Apttus_Config2__ConfigurationId__c, allLineItems, null, vcb);
	  
	  test.stopTest();
	 }
  }