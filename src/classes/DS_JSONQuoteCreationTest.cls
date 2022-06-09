@isTest
Public class DS_JSONQuoteCreationTest{
	private static  Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
	private static  Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_DIRECT_SALES_OPPORTUNITY).getRecordTypeId();

	@testSetup 
	static void TestData() {
		Test.startTest();
		List<Account> accounts=new List<Account>();
		Account Customeraccount = NF_TestDataFactory.createAccount('1TestNONV0000');
		Customeraccount.RecordTypeId=custRecordTypeId;
		accounts.add(Customeraccount);
		Database.insert(accounts);
		
		Account LegalEntityaccount = NF_TestDataFactory.createAccount('10308719999AIA');
		LegalEntityaccount.Accountnumber='1323242223i';
		LegalEntityaccount.Recordtypeid=LERecordTypeId;
		LegalEntityaccount.ParentId=accounts[0].Id;
		LegalEntityaccount.Default_Legal_Entity__c = true;
		LegalEntityaccount.Partner_Program__c=null;
		accounts.add(LegalEntityaccount);
		Database.upsert(accounts); 
		
		/*
		Opportunity Opportunity_v1= NF_TestDataFactory.createOpportunity(accounts[0].Id, 'Create offer (bid)', 'Offer in Progress', Date.today().addDays(10), 7000000);
		Opportunity_v1.Lead_BG__c='NSW';
		Opportunity_v1.RecordTypeId = oppDirectRecordTypeId;
		Opportunity_v1.Business_Type__c = 'Standard Opportunity';
		*/
		Opportunity Opportunity_v1= NF_TestDataFactory.createOpportunity(accounts[0].Id, 'Execute (Start Delivery)', 'In Execution', Date.today().addDays(10), 7000000);
		Opportunity_v1.Lead_BG__c='NSW';
		Opportunity_v1.Opportunity_ID__c='19.IN.856951';
		Opportunity_v1.RecordTypeId = oppDirectRecordTypeId;
		Opportunity_v1.Business_Type__c = 'Standard Opportunity';
		/*
		oppty.Opportunity_ID__c = '19.IN.856950';
		oppty.StageName = 'Execute (Start Delivery)';
		oppty.Phase_Status__c = 'In Execution';
		*/
		Database.insert(Opportunity_v1);
		
		List<product2> productObj2 = TestDataFactory.productCreation(3);
		productObj2[0].ProductCode = 'RL000277.T';
		productObj2[0].Apttus_Config2__ConfigurationType__c = 'Standalone';
		productObj2[1].ProductCode = 'var-opt';
		productObj2[1].name = 'Variable Option';
		productObj2[1].Apttus_Config2__ConfigurationType__c = 'Option';
		productObj2[2].ProductCode = 'vb';
		productObj2[2].name = 'Variable Bundle';
		productObj2[2].Apttus_Config2__ConfigurationType__c = 'Bundle';
		database.insert(productObj2);
		
		List<Apttus_Config2__ProductOptionComponent__c> OptionComlist=new  List<Apttus_Config2__ProductOptionComponent__c>();
	 
		Apttus_Config2__ProductOptionComponent__c prodoptioncmp = TestDataFactory.CreateproductOptionComponent(productObj2[1].id,1)[0];
		prodoptioncmp.Apttus_Config2__ParentProductId__c = productObj2[2].id;
		prodoptioncmp.Apttus_Config2__Sequence__c = 5613;
		Apttus_Config2__ProductOptionComponent__c prodoptioncmp1 = TestDataFactory.CreateproductOptionComponent(productObj2[0].id,1)[0];
		prodoptioncmp1.Apttus_Config2__Sequence__c = 5614;
		Apttus_Config2__ProductOptionComponent__c prodoptioncmp2 = TestDataFactory.CreateproductOptionComponent(productObj2[2].id,1)[0];
		prodoptioncmp2.Apttus_Config2__Sequence__c = 5616;
		OptionComlist.add(prodoptioncmp);
		OptionComlist.add(prodoptioncmp1);
		OptionComlist.add(prodoptioncmp2);
		database.insert(OptionComlist);
		
		List<Apttus_Config2__PriceList__c> priceListObj = TestDataFactory.priceList(1);
		priceListObj[0].Apttus_Config2__AccountId__c = LegalEntityaccount.id;
		priceListObj[0].Type__c  = 'CXM';
		database.insert(priceListObj[0]);
		
		List<Apttus_Config2__PriceListItem__c> priceListItemObj = TestDataFactory.createPriceListItem(3,priceListObj[0]);
		priceListItemObj[0].Apttus_Config2__PriceListId__c = priceListObj[0].id;
		priceListItemObj[0].Apttus_Config2__ProductId__c = productObj2[0].id;
		priceListItemObj[1].Apttus_Config2__PriceListId__c = priceListObj[0].id;
		priceListItemObj[1].Apttus_Config2__ProductId__c = productObj2[1].id;
		priceListItemObj[2].Apttus_Config2__PriceListId__c = priceListObj[0].id;
		priceListItemObj[2].Apttus_Config2__ProductId__c = productObj2[2].id;
		
		database.insert(priceListItemObj);
		
		Apttus__APTS_Agreement__c agreementobj= new Apttus__APTS_Agreement__c();
		agreementobj.Apttus__Agreement_Number__c='00000024';
		agreementobj.Name= 'New demo';
		agreementobj.Apttus__Account__c = accounts[1].id;
		agreementobj.CurrencyIsoCode = 'EUR';
		agreementobj.Delivery_System__c = 'Scratch Order via P20';
		agreementobj.ERP__c = 'P20';
		agreementobj.Sales_Mode__c = 'Corporate Sales Mode';
		agreementobj.Confidence_Level__c = 'Low Level';
		agreementobj.Apttus__Contract_Start_Date__c=System.today();
		agreementobj.Apttus__Contract_End_Date__c=System.today()+30;
		agreementobj.Apttus_CMConfig__PriceListId__c = priceListObj[0].id;
		database.insert(agreementobj);
				 
		Test.stopTest(); 

	}
	
	static testMethod void JsonQuoteCreation(){
		
		 
		List <Apttus_Proposal__Proposal__c> QPList = new List<Apttus_Proposal__Proposal__c>();
		Schema.SObjectType HeaderSobj = Schema.getGlobalDescribe().get('Apttus_Proposal__Proposal__c');
		Sobject HeaderObject = HeaderSobj.newSObject();
		
		
		HeaderObject.put('Analytics_Source__c','CXM-ASDFG');
		HeaderObject.put('Analytics_File_Refer_ID__c','LTE AIR Interface AR');
		HeaderObject.put('Apttus_Proposal__Approval_Stage__c','Approved');
		HeaderObject.put('Sold_To_Party__c','1323242223i');
		HeaderObject.put('Creation_Date__c',System.today());  
		HeaderObject.put('Contract_Start_Date__c',System.today());
		HeaderObject.put('Contract_End_Date__c',System.today());
		HeaderObject.put('Proposal_Recommendation_Type__c','SW Recommendation');
		HeaderObject.put('Agreement_Lookup__c','00000024.0');
		HeaderObject.put('Apttus_Proposal__Opportunity__c','19.IN.856951');
		
		Apttus_Proposal__Proposal__c  QP=(Apttus_Proposal__Proposal__c)HeaderObject;

		QPList.add(QP);
		
		DS_Staging__c DS_Staging = new DS_Staging__c ();
		DS_Staging .Payload_Status__c='Success';
		DS_Staging .DS_Payload__c= 'Json Structure' ;
		DS_Staging .DP_Status__c = 'Success';
		insert DS_Staging ;
		
		Interface_Log__c Ilog = new Interface_Log__c();
		Ilog.Message_Type__c= 'Inbound';
		Ilog.Operation_Type__c= 'Insert';
		Ilog.Interface_Type__c= 'DS ProposalCreation';
		Ilog.Status__c= 'Failure';
		insert Ilog;
		Set <String> AgreenumberSet = new Set <String>{'00000024.0'};			   
		Set <String> OppNumSet = new Set <String>{'19.IN.856951'};				
		Set <String> AccNumberset = new Set <String>{'1323242223i'};		
		Set <String> ProductCodeSet = new Set <String>{'vb', 'RL000277.T','var-opt'};
			
		List <Apttus_Config2__LineItem__c> QuoteLineItemsList = new List<Apttus_Config2__LineItem__c>();
		List <Apttus_Config2__LineItem__c> StandaloneList = new List<Apttus_Config2__LineItem__c>();
		List <Apttus_Config2__LineItem__c> BundleList = new List<Apttus_Config2__LineItem__c>();
		map<Integer,List<Sobject>> CFA_Listwithmap = new map<Integer,List<Sobject>>();	   

		Schema.SObjectType LineitemSobj = Schema.getGlobalDescribe().get('Apttus_Config2__LineItem__c');
		Sobject LineItemObj1 = LineitemSobj.newSObject();
		LineItemObj1.put('Apttus_Config2__Quantity__c',1);
		LineItemObj1.put('Apttus_Config2__ProductOptionId__c','RL000277.T');
		LineItemObj1.put('Apttus_Config2__LineNumber__c',1);
		Apttus_Config2__LineItem__c  QuoteLineItemStandalone=(Apttus_Config2__LineItem__c)LineItemObj1;
		
		Sobject LineItemObj2 = LineitemSobj.newSObject();
		LineItemObj2.put('Apttus_Config2__Quantity__c',1);
		LineItemObj2.put('Apttus_Config2__ProductId__c','vb');
		LineItemObj2.put('Apttus_Config2__LineNumber__c',2);
		Apttus_Config2__LineItem__c  QuoteLineItemBundle=(Apttus_Config2__LineItem__c)LineItemObj2;
		
		Sobject LineItemObj3 = LineitemSobj.newSObject();
		LineItemObj3.put('Apttus_Config2__Quantity__c',1);
		LineItemObj3.put('Apttus_Config2__ProductOptionId__c','var-opt');
		LineItemObj3.put('Apttus_Config2__LineNumber__c',2);
		LineItemObj3.put('Apttus_Config2__ProductId__c','vb');

		Apttus_Config2__LineItem__c  QuoteLineItemOption=(Apttus_Config2__LineItem__c)LineItemObj3;
		
		QuoteLineItemsList.add(QuoteLineItemStandalone);  
		StandaloneList.add(QuoteLineItemStandalone);
		QuoteLineItemsList.add(QuoteLineItemBundle);  
		BundleList.add(QuoteLineItemBundle);
		QuoteLineItemsList.add(QuoteLineItemOption);
		BundleList.add(QuoteLineItemOption);
		
		List<Sobject> CFA_List=new List<Sobject>();
		 
		CFA_Listwithmap.put(1,StandaloneList);
		CFA_Listwithmap.put(2,BundleList);
		Test.startTest(); 
		DS_JSONQuoteCreation DsJson=new DS_JSONQuoteCreation(QPList,QuoteLineItemsList,CFA_List,CFA_Listwithmap,AccNumberset,ProductCodeSet,AgreenumberSet,OppNumSet,DS_Staging,Ilog);
		DsJson.QuoteDataInsertion();
		 
		Test.stopTest();
	}
}