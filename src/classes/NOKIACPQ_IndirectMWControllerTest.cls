@isTest
public class NOKIACPQ_IndirectMWControllerTest {
	static testmethod void IndirectQuoteController_IndirectMicrowave(){
		List<User> userList = new List<User>();
		List<Account> accounts = new list<Account>();
		List<Account> acclist = new list<Account>();
		 
		userList = TestDataFactory.userCreation(1,'System Administrator');
		//Database.insert(userlist);
		insert userlist;

		//create a Account
		accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;
	  
		acclist = new List<Account>();
		acclist.add(accounts[0]);	
	
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
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(2,acclist);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();   
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		opportunities[0].Account_Role__c = 'Alliance Partner';
		opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();  
		opportunities[1].End_Customer_LE__c = accounts[1].id;
		opportunities[1].Account_Role__c = 'Alliance Partner';
		insert opportunities; 
		//Update Opportunities
		opportunities[0].stageName = 'Win the Case (Negotiate)';
		opportunities[0].Phase_Status__c = 'Offer Submitted to Customer (Manual)';
		opportunities[0].LOA_Level__c = GlobalConstants.LOA_BYPASS_LEVEL;
		opportunities[0].No_Loa__c = true ;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		
		opportunities[1].stageName = 'Create Offer (bid)';
		opportunities[1].Phase_Status__c = 'Offer in Progress';
		opportunities[1].LOA_Level__c = GlobalConstants.LOA_BYPASS_LEVEL;
		opportunities[1].No_Loa__c = true;
		opportunities[1].Apttus_Approval__Approval_Status__c = 'Approved';
		update opportunities; 
	  
		//Create Offer
		Offer__c offer = new Offer__c(
		No_LoA__c = true,
		ActiveOffer__c =true,
		//Authorized_for_Pricing_Manager__c = false,
		Pre_approved_Price_List_for_Acc_Managers__c = false,
		LoA_Approval_Level__c='LoA Bypass',
		LOA_Bypass__c = 'No LoA',
		Opportunity__c = opportunities[1].Id
		); 
		insert offer;
		test.starttest();
		//insert products
		Product2 productInst = new Product2();
		productInst = new product2(
	Name = 'Test3', 
	ProductCode = '4256', 
	//Business_Group__c = 'MN', 
	CurrencyIsoCode = 'EUR',
	IsActive = true,
	Capacity__c = 'full',
	Portfolio__c = 'Microwave',
	NokiaCPQ_Portfolio_Package_Code__c = 'Microwave',
	NokiaCPQ_Item_Type__c = 'Software',
	Apttus_Config2__ConfigurationType__c='Bundle'
		); 
		insert productInst;
	  
		//create a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (USD)';
		priceList.CurrencyIsoCode='GBP';
		priceList.Apttus_Config2__Active__c=false;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
	  
		insert priceList;
		
		//Create Price List Item
		Apttus_Config2__PriceListItem__c pLI = new Apttus_Config2__PriceListItem__c(
		Apttus_Config2__PriceListId__c = priceList.Id,
		Apttus_Config2__ListPrice__c = 100, 
		Apttus_Config2__ProductId__c = productInst.Id, 
		Apttus_Config2__ChargeType__c = 'Standard Price'
		);
		insert pLI;
		
		
		System.runAs(userList[0])
		{
		//create a quote
		//List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		Apttus_Proposal__Proposal__c proposals = new Apttus_Proposal__Proposal__c();
		proposals.NokiaCPQ_Existing_IONMaint_Contract__c  = 'No';
		proposals.NokiaCPQ_ION_Maintenance_Type__c = 'Gold';
		proposals.NokiaCPQ_Existing_FN_Maint_Contract__c  = 'No';
		proposals.NokiaCPQ_FN_Maintenance_Type__c= 'Gold';
	// proposals.Apttus_Proposal__Account__c = accounts[0].Id;
	  //  proposals.Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals.NokiaCPQ_Needs_Reprice__c = false;
		proposals.Reprice_In_Progress__c = false;
		proposals.Apttus_Proposal__Approval_Stage__c = 'Draft';
		proposals.RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Draft_Quote_Cannot_Validate').getRecordTypeId();//'Draft_Quote_Cannot_Validate'
		proposals.NokiaCPQ_Portfolio__c='Microwave';//Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO;
		//proposals.NokiaCPQ_Portfolio__c= 'QTC';
		proposals.NokiaCPQ_SSP_Level__c = '';
		proposals.NokiaCPQ_Maintenance_Type__c = 'Basic Support';
		 proposals.Maintenance_Y1__c=1;
		 //proposals.Maintenance_Y2__c=1;
		 proposals.NokiaCPQ_SRS_Level__c ='';
		 proposals.NokiaCPQ_LEO_Discount__c = false;
		 proposals.NokiaCPQ_has_Partner_Certified__c = true;
		 proposals.is_CustomProductQuote__c = true;
		// proposals.NokiaCPQ_CAD__c = 20;
			insert proposals;

		 
		
		// create a product configuration
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals.Id;
		
		insert prodConfigs;
		
		list<Apttus_Config2__LineItem__c> LineItemList = new List<Apttus_Config2__LineItem__c>();

		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = priceList.id,
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__ProductId__c = productInst.Id,
		Apttus_Config2__PriceListItemId__c = pLI.id,
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__AdjustmentAmount__c = 10,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
		Apttus_Config2__PricingStatus__c = 'Pending',	
		Apttus_Config2__AddedBy__c = 'added by code'
	  );
	
	  LineItemList.add(LineItem1);
	  insert LineItemList;
	  
	  // Proposal Summary Group
	  Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
	  Apttus_QPConfig__ProposalId__c = proposals.id,
	  Apttus_QPConfig__AdjustmentAmount__c = 1,
	  CurrencyIsoCode = 'USD',
	  Apttus_QPConfig__NetPrice__c = 100.00,
	  Apttus_QPConfig__ItemSequence__c = 1,
	  Apttus_QPConfig__LineNumber__c = 1,
	  Apttus_QPConfig__ExtendedPrice__c = 100,
	  name = 'Total (One Time)'
	  );
	  insert propSummaryGrp1;
	  
	NOKIACPQ_IndirectMWController quoteApprovalCtrl = new NOKIACPQ_IndirectMWController();
	  quoteApprovalCtrl.quoteId=proposals.id;
	string Value=quoteApprovalCtrl.getQuoteAppvlDtls();
	test.stopTest();   
	}
	
	}

 static testmethod void IndirectQuoteController_IndirectMicrowave_E(){
	List<User> userList = new List<User>();
	List<Account> accounts = new list<Account>();
	List<Account> acclist = new list<Account>();
  
	userList = TestDataFactory.userCreation(1,'System Administrator');
	Database.insert(userlist);

	//create a Account
	accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
	accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	accounts[1].AccountNumber='';
	accounts[1].Partner_Type__c = '';
	accounts[1].Partner_Program__c = '';
	insert accounts;
  
	acclist = new List<Account>();
	acclist.add(accounts[0]);
	
	  
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
	GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
	List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunitieswithoutG6(2,acclist);
	opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();   
	opportunities[0].End_Customer_LE__c = accounts[1].id;
	opportunities[0].Account_Role__c = 'Alliance Partner';
	opportunities[1].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();  
	opportunities[1].End_Customer_LE__c = accounts[1].id;
	opportunities[1].Account_Role__c = 'Alliance Partner';
	insert opportunities; 
	//Update Opportunities
	opportunities[0].stageName = 'Win the Case (Negotiate)';
	opportunities[0].Phase_Status__c = 'Offer Submitted to Customer (Manual)';
	opportunities[0].LOA_Level__c = 'A';
	opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
	
	opportunities[1].stageName = 'Create Offer (bid)';
	opportunities[1].Phase_Status__c = 'Offer in Progress';
	opportunities[1].LOA_Level__c = 'A';
	opportunities[1].Apttus_Approval__Approval_Status__c = 'Approved';
	update opportunities; 
  
	//Create Offer
	Offer__c offer = new Offer__c(
	No_LoA__c = false,
	ActiveOffer__c =true,
	//Authorized_for_Pricing_Manager__c = false,
	Pre_approved_Price_List_for_Acc_Managers__c = false,
	LoA_Approval_Level__c='E',
	LOA_Bypass__c = '',
	Opportunity__c = opportunities[1].Id
	); 
	insert offer;
	test.starttest();
	//insert products
	Product2 productInst = new Product2();
	productInst = new product2(
	  Name = 'Test3', 
	  ProductCode = '4256', 
	  //Business_Group__c = 'MN', 
	  CurrencyIsoCode = 'EUR',
	  IsActive = true,
	  Capacity__c = 'full',
	  Portfolio__c = 'Microwave',
	  NokiaCPQ_Portfolio_Package_Code__c = 'Microwave',
	  NokiaCPQ_Item_Type__c = 'Software',
	  Apttus_Config2__ConfigurationType__c='Bundle'
	); 
	insert productInst;
  
	//create a Price List
	Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
	priceList.Name='Global Price List (USD)';
	priceList.CurrencyIsoCode='GBP';
	priceList.Apttus_Config2__Active__c=false;
	priceList.PriceList_Type__c='CPQ';
	priceList.Apttus_Config2__Type__c='Standard';
  
	insert priceList;
	
	//Create Price List Item
	Apttus_Config2__PriceListItem__c pLI = new Apttus_Config2__PriceListItem__c(
	Apttus_Config2__PriceListId__c = priceList.Id,
	Apttus_Config2__ListPrice__c = 100, 
	Apttus_Config2__ProductId__c = productInst.Id, 
	Apttus_Config2__ChargeType__c = 'Standard Price'
	);
	insert pLI;
	
	
	system.runas(userList[0])
	{
	//create a quote
	List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
   // proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
   // proposals[0].Apttus_Proposal__Opportunity__c = opportunities[1].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = false;
	proposals[0].Reprice_In_Progress__c = false;
	proposals[0].Apttus_Proposal__Approval_Stage__c = 'Draft';  
	proposals[0].RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Draft_Quote_Cannot_Validate').getRecordTypeId();
	proposals[0].NokiaCPQ_Portfolio__c=Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO;
	proposals[0].NokiaCPQ_SSP_Level__c = '';
	proposals[0].NokiaCPQ_Maintenance_Type__c = 'Basic Support';
  proposals[0].Maintenance_Y1__c=1;
  //proposals[0].Maintenance_Y2__c=1;
  proposals[0].NokiaCPQ_LEO_Discount__c = false;
  proposals[0].NokiaCPQ_SRS_Level__c ='';
  proposals[0].NokiaCPQ_has_Partner_Certified__c = true;
	// proposals[0].is_CustomProductQuote__c = true;
	// proposals[0].NokiaCPQ_CAD__c = 20;
  insert proposals;
	  proposals[0].Apttus_Proposal__Approval_Stage__c = 'In Review';
	  update proposals;
  
	
	// create a product configuration
	List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
	prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
	prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
	prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
	prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
	
	insert prodConfigs;
	
	list<Apttus_Config2__LineItem__c> LineItemList = new List<Apttus_Config2__LineItem__c>();

	Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
	Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
	Apttus_Config2__ItemSequence__c = 1,
	Apttus_Config2__LineNumber__c = 1,
	//Apttus_Config2__IsPrimaryLine__c = opportunities.get(0).IdTrue,
	Apttus_Config2__LineStatus__c='New',
	Apttus_Config2__PriceListId__c = priceList.id,
	Apttus_Config2__ChargeType__c = 'Standard Price', 
	Apttus_Config2__LineType__c = 'Product/Service',
	Apttus_Config2__ProductId__c = productInst.Id,
	Apttus_Config2__PriceListItemId__c = pLI.id,
	Apttus_Config2__PriceMethod__c = 'Per Unit',
	Apttus_Config2__Frequency__c = 'One Time',
	Apttus_Config2__AdjustmentAmount__c = 10,
	Apttus_Config2__ListPrice__c = 100,
	Apttus_Config2__Quantity__c = 1,
	Apttus_Config2__PrimaryLineNumber__c = 1,
	Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
	Apttus_Config2__PricingStatus__c = 'Pending',	
	Apttus_Config2__AddedBy__c = 'added by code'
  );
   
  LineItemList.add(LineItem1);
  insert LineItemList;
  
  // Proposal Summary Group
  Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
  Apttus_QPConfig__ProposalId__c = proposals[0].id,
  Apttus_QPConfig__AdjustmentAmount__c = 1,
  CurrencyIsoCode = 'USD',
  Apttus_QPConfig__NetPrice__c = 100.00,
  Apttus_QPConfig__ItemSequence__c = 1,
  Apttus_QPConfig__LineNumber__c = 1,
  Apttus_QPConfig__ExtendedPrice__c = 100,
  name = 'Total (One Time)'
  );
  insert propSummaryGrp1;
  
  //test.startTest(); 
  NOKIACPQ_IndirectMWController quoteApprovalCtrl = new NOKIACPQ_IndirectMWController();
  quoteApprovalCtrl.quoteId=proposals[0].id;
   string Value=quoteApprovalCtrl.getQuoteAppvlDtls();
   test.stopTest();  
	  }
	
	}
}