/************************************************************************************************************
* Apex Class Name   : PS_configLineItemHandler_Test.cls
* Version		  : 1.0 
* Created Date	: 20 Jul 2017
* Function		: test class for PS_configLineItemHandler_Test
* Modification Log  :
* Developer				Date				 Description
* -----------------------------------------------------------------------------------------------------------
* Akshay Thorat			20/07/2017			 Created Test Class for PS_configLineItemHandler_Test
*
************************************************************************************************************/
@isTest//(seeAllData =true)
private class PS_configLineItemHandler_Test
{
	private static List<Account> accountList = new List<Account>();
	private static List<Opportunity> opportunityList = new List<Opportunity>();
	
	
	/*Create Dummy Price list*/
	public static Apttus_Config2__PriceList__c createpricelist(string priceListName) {
		Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c();
		pl.Name=priceListName; 
		return pl;
	}
	
	
	/********** functionality lineitem trigger  ***********/
	@isTest static void lineitemTest(){
		/* String csvContent = 'ProductCode,QTY,\n3HE11467AA,2,\n3HE10218AA,5';
		Apttus_Proposal__Proposal__c proposal = [select ID, Apttus_QPConfig__PriceListId__c from Apttus_Proposal__Proposal__c limit 1];
		ApexPages.currentPage().getParameters().put('id',proposal.id);
		PS_productuploadscontroller puc = new  PS_productuploadscontroller(new ApexPages.StandardController(proposal));
		puc.csvAsString = 'filename.csv';
		puc.csvFileBody =  Blob.valueof(csvContent);
		puc.setFile();
		puc.readFromFile();
		// puc.createcart();
		puc.addProductsfromfile();
		//puc.Reprice();
		puc.Finalize();
		puc.Saveconfig();
		puc.Finalize();
		puc.returntoquote();
		puc.returntocart();
		
		test.startTest();
		List<Apttus_Config2__LineItem__c> li = [select Id from Apttus_Config2__LineItem__c Limit 1];
		Apttus_Config2__ProductAttributeValue__c PA1 = new Apttus_Config2__ProductAttributeValue__c();
		
		if(li != null && !li.isEmpty() && li[0] != null){
			//PA1.Product_Offering__c = 'eBook Only';
			//PA1.CurrencyIsoCode = 'GBP';
			PA1.Apttus_Config2__LineItemId__c = li[0].id;
			PA1.Q_SWSuite__c = 'Premium';
		}
		   insert PA1; 
		   
		test.stopTest(); */
		 
	}
	
	/********** functionality lineitem trigger  ***********/
	@isTest static void lineitemTest1(){
		List<User> sysAdminUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'System Administrator');
		System.runAs(sysAdminUser[0]){
		String csvContent = 'ProductCode,QTY,\n3HE11467AA,2,\n3HE10218AA,5';
		Account account;
		string partnerProgram = 'Global Alliance';
		account = NF_TestDataFactory.createAccount('30112345');
			account.Partner_Program__c = partnerProgram;
		List<Account> accounts=NOKIA_CPQ_TestDataFactory.getAccounts(1);
		accounts.add(account);
			
			accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			accounts[1].Partner_Type__c = '';
			accounts[1].Partner_Program__c = '';
		insert accounts; 
		   
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id; 
			insert opportunities;
		Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
																							Name = 'Commercial Price List', 
																							Apttus_Config2__Active__c = True
																							);
		insert ApttusTestPriceList;

		//Accrediation creation
	   /*Accreditation__c accred = new Accreditation__c(
			partner__c = account.Id,
			Accreditation_Type__c = 'Product',
			Portfolio__c = 'IP Routing',
			Pricing_Cluster__c = 'NAM',
			Accreditation_Level__c = 'Advanced', 
			Pricing_Level_Override__c = 'Advanced',  
			Accreditation_Date__c = date.today() + 9, 
			Pricing_Override_Expiration__c = date.today() + 9, 
			Actual_pricing_level__c = 'Advanced'
		); 
		insert accred;*/
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations;
		
		test.startTest();
		
		 Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
			Apttus_Proposal__Account__c = accounts[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = ApttusTestPriceList.Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='Gold', 
			NokiaCPQ_SRS_Level__c='Unlimited',
			NokiaCPQ_Existing_IONMaint_Contract__c='No',
			NokiaCPQ_Existing_FN_Maint_Contract__c='No',
			NokiaCPQ_ION_Maintenance_Type__c='Gold',
			NokiaCPQ_SSP_Level__c='Unlimited',
			//CurrencyIsoCode = 'USD',
			//NokiaCPQ_Opportunity_Type__c
			//Quote_Type__c
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Proposal').getRecordTypeId(),
			NokiaCPQ_Maintenance_Type__c = '',
			NokiaCPQ_Portfolio__c = 'IP Routing',
			NokiaCPQ_Maintenance_Accreditation__c = accreditations[0].id, 
			NokiaProductAccreditation__c = accreditations[0].id, 
			NokiaCPQ_Maintenance_Level__c = 'Yes',
			Warranty_credit__c = 'Yes',
			NokiaCPQ_LEO_Discount__c=false,
			Is_List_Price_Only__c =false,
			NokiaCPQ_Is_cloned__c = false, 
			NokiaCPQ_Is_Maintenance_Quote__c = true,
			NokiaCPQ_Contract_Start_Date__c = System.today(),
			isCQ__c = false,
		   // Apttus_Proposal__Approval_Stage__c = 'Draft',
			NokiaCPQ_No_of_Years__c  = '1'); 
			
			insert testProposal;
			System.Debug('testProposal-->>> '+testProposal);
			System.Debug('testProposal-->>> '+testProposal.Id);
			
			/*if(testProposal.id != null){
				ApexPages.currentPage().getParameters().put('id',testProposal.id);
				PS_productuploadscontroller puc = new  PS_productuploadscontroller(new ApexPages.StandardController(testProposal));
				puc.csvAsString = 'filename.csv';
				puc.csvFileBody =  Blob.valueof(csvContent);
				puc.setFile();
				puc.readFromFile();
				puc.createcart();
				puc.addProductsfromfile();
				//puc.Reprice();
				puc.Finalize();
				puc.Saveconfig();
				puc.Finalize();
				puc.returntoquote(); 
				puc.returntocart();
			} */
		//test.startTest();
		
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
		
		Apttus_Config2__LineItem__c li =new Apttus_Config2__LineItem__c(
		Apttus_Config2__ConfigurationId__c=ProdConfig.Id,
		Apttus_Config2__ItemSequence__c = 1,
		Apttus_Config2__LineNumber__c = 1,
		Apttus_Config2__LineStatus__c='New',
		Apttus_Config2__PriceListId__c = ApttusTestPriceList.id,
		Apttus_Config2__ChargeType__c = 'Standard Price', 
		Apttus_Config2__LineType__c = 'Product/Service',
		Apttus_Config2__PriceMethod__c = 'Per Unit',
		Apttus_Config2__Frequency__c = 'One Time',
		Apttus_Config2__BasePrice__c=100,
		Apttus_Config2__ListPrice__c = 100,
		Apttus_Config2__Quantity__c = 1,
		Source__c='',
		Apttus_Config2__PrimaryLineNumber__c = 1,
		Apttus_Config2__ShipToAccountId__c = accounts[0].Id,
		is_Custom_Product__c=false,
		Apttus_Config2__BasePriceOverride__c=120,
		Apttus_Config2__AddedBy__c = 'added by code',
		NokiaCPQ_Product_Type__c='Controller');
		
		insert li;
		
		//List<Apttus_Config2__LineItem__c> li = [select Id from Apttus_Config2__LineItem__c Limit 1];
		Apttus_Config2__ProductAttributeValue__c PA1 = new Apttus_Config2__ProductAttributeValue__c();
		
		//if(li != null && !li.isEmpty() && li[0] != null){
			//PA1.Product_Offering__c = 'eBook Only';
			//PA1.CurrencyIsoCode = 'GBP';  Apttus_Config2__LineItemId__c
			
		if(li != null){
			PA1.Apttus_Config2__LineItemId__c = li.id;
			PA1.Q_SWSuite__c = 'Premium';
		}
		   insert PA1; 
		   
		   if(testProposal.id != null){
				ApexPages.currentPage().getParameters().put('id',testProposal.id);
				PS_productuploadscontroller puc = new  PS_productuploadscontroller(new ApexPages.StandardController(testProposal));
				puc.csvAsString = 'filename.csv';
				puc.csvFileBody =  Blob.valueof(csvContent);
				puc.setFile();
				puc.readFromFile();
				//puc.createcart();
				puc.addProductsfromfile();
				//puc.Reprice();
				puc.Finalize();
				puc.Saveconfig();
				puc.Finalize();
				puc.returntoquote(); 
				puc.returntocart();
			}
		   
		test.stopTest();
		 }
	}
	/* @isTest static void setup()
	{
		test.startTest();
		PageReference pageRef = Page.Apttus_QPConfig__ProposalConfiguration; // Add your VF page Name here
		
		Apttus_Proposal__Proposal__c proposal = [select ID, Apttus_QPConfig__PriceListId__c from Apttus_Proposal__Proposal__c limit 1];
		 List<Apttus_Config2__LineItem__c> li = [select Id from Apttus_Config2__LineItem__c Limit 1];
		Apttus_Config2__ProductAttributeValue__c PA1 = new Apttus_Config2__ProductAttributeValue__c();
		
		if(li != null && !li.isEmpty() && li[0] != null){
			//PA1.Product_Offering__c = 'eBook Only';
			//PA1.CurrencyIsoCode = 'GBP';
			PA1.Apttus_Config2__LineItemId__c = li[0].id;
			PA1.Q_SWSuite__c = 'Premium';
		}
		
		
		   insert PA1; 
		/* Test.setCurrentPage(pageRef);
		ApexPages.StandardController sc = new ApexPages.StandardController(proposal);
		PS_productuploadscontroller  puc = new  PS_productuploadscontroller(sc);
		pageRef.getParameters().put('id', String.valueOf(proposal.Id));
		pageRef.getParameters().put('flow','NewUIPartner');
		puc.returntocart(); ----
		test.stopTest();
		
	}*/

}