@isTest
public class NokiaCPQQuoteApprovalController_Test{

	  public static testMethod void Testmethod1(){
		 List<User> sysAdminUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Data Loader Profile');
		 System.runAs(sysAdminUser[0]){
			List <Account> account = NOKIA_CPQ_TestDataFactory.getAccounts(2);
			account[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			account[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			account[1].Partner_Type__c = '';
			account[1].Partner_Program__c = '';
			insert account;
			
			product2 prod = new product2();
			prod.name = 'A';
			prod.CurrencyIsoCode = 'EUR';
			prod.Business_Group__c='MN';
			prod.Family= 'A&A-CEM';
			prod.IsActive=True;
			prod.Partner_Visible__c=True;
			prod.ProductCode='3HE10869BA';
			prod.Apttus_Config2__Version__c= 1;
			prod.Portfolio__c= 'IP Routing';
			prod.Pricing_Clusters__c='NAM';
			prod.IsActive= True;
			insert prod;
		
			product2 prod1 = new product2();
			prod1.name = 'A2';
			prod1.CurrencyIsoCode = 'EUR';
			prod1.Business_Group__c='MN';
			prod1.Family= 'A&A-CEM';
			prod1.IsActive=True;
			prod1.Partner_Visible__c=True;
			prod1.ProductCode='3HE10869AAAA';
			prod1.Apttus_Config2__Version__c= 1;
			prod1.Portfolio__c= 'Fixed Access - FBA';
			prod1.Pricing_Clusters__c='NAM';
			prod1.IsActive= True;
			insert prod1;
			
			Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c='Product',
				Accreditation_Date__c = date.today(),
				Accreditation_Level__c='Advanced',
				Partner__c=account[0].Id,
				Portfolio__c='IP Routing',
				Pricing_Cluster__c='NAM');
			insert accreditation1;
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Product',
				Accreditation_Date__c = date.today(),
				Accreditation_Level__c='Advanced',
				Partner__c=account[0].Id,
				Portfolio__c='Fixed Access - FBA',
				Pricing_Cluster__c='NAM');
			insert accreditation2;
			
			List<Accreditation__c> maccreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(1);
			maccreditations[0].partner__c = account[0].Id;
			maccreditations[0].Accreditation_Type__c = 'Maintenance';
			maccreditations[0].Accreditation_Level__c = 'Premium';
			maccreditations[0].Pricing_Level_Override__c = 'Premium';   
			insert maccreditations;
			
			test.startTest();
	
			List <Opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account);
			opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
			opportunities[0].End_Customer_LE__c = account[1].id;
			insert opportunities;
			
			/*List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>();
			opportunityTeamMemberList = TestDataFactory.optyTeamMemberCreation(2, sysAdminUser[0],opportunities[0]);
			insert opportunityTeamMemberList;*/
		
			Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
			priceList.Name='Global Price List (EUR)';
			priceList.CurrencyIsoCode='EUR';
			priceList.Apttus_Config2__Active__c=True;
			priceList.PriceList_Type__c='CPQ';
			priceList.Apttus_Config2__Type__c='Standard';
		
			insert priceList;
	 
			Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
			Apttus_Proposal__Account__c = account[0].Id,
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
			//NokiaProductAccreditation__c = accreditation1.id,
			//NokiaCPQ_Maintenance_Accreditation__c = maccreditations[0].id,
			Maintenance_Y1__c = 200,
			NokiaCPQ_Maintenance_Type__c ='');
	
			insert testProposal;
			
			Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c();
			ProdConfig.Name = 'APTTUS Test Config'; 
			ProdConfig.Apttus_QPConfig__Proposald__c = testProposal.id;
			ProdConfig.Apttus_Config2__Status__c = 'Finalized';
			ProdConfig.Apttus_Config2__VersionNumber__c = 1;
			ProdConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
		
			insert ProdConfig;
			
			Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=prodConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = priceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod.Id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = account[0].Id);
			
			insert LineItem1;
			
			ApexPages.currentPage().getParameters().put('quoteId',testProposal.id);
			ApexPages.currentPage().getParameters().put('oppId',opportunities.get(0).Id);
			NokiaCPQQuoteApprovalController quoteApprovalCtrl = new  NokiaCPQQuoteApprovalController();
			quoteApprovalCtrl.init();
			quoteApprovalCtrl.cancel();
			test.stopTest();
		 }
	  }
	  
	  public static testMethod void Testmethod2(){
		 List<User> sysAdminUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Data Loader Profile');
		 System.runAs(sysAdminUser[0]){
			List <Account> account = NOKIA_CPQ_TestDataFactory.getAccounts(2);
			account[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			account[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			account[1].Partner_Type__c = '';
			account[1].Partner_Program__c = '';
			insert account;
			
			product2 prod = new product2();
			prod.name = 'A';
			prod.CurrencyIsoCode = 'EUR';
			prod.Business_Group__c='MN';
			prod.Family= 'A&A-CEM';
			prod.IsActive=True;
			prod.Partner_Visible__c=True;
			prod.ProductCode='3HE10869BA';
			prod.Apttus_Config2__Version__c= 1;
			prod.Portfolio__c= 'IP Routing';
			prod.Pricing_Clusters__c='NAM';
			prod.IsActive= True;
			insert prod;
		
			product2 prod1 = new product2();
			prod1.name = 'A2';
			prod1.CurrencyIsoCode = 'EUR';
			prod1.Business_Group__c='MN';
			prod1.Family= 'A&A-CEM';
			prod1.IsActive=True;
			prod1.Partner_Visible__c=True;
			prod1.ProductCode='3HE10869AAAA';
			prod1.Apttus_Config2__Version__c= 1;
			prod1.Portfolio__c= 'Fixed Access - FBA';
			prod1.Pricing_Clusters__c='NAM';
			prod1.IsActive= True;
			insert prod1;
			
			Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c='Product',
				Accreditation_Date__c = date.today(),
				Accreditation_Level__c='Advanced',
				Partner__c=account[0].Id,
				Portfolio__c='IP Routing',
				Pricing_Cluster__c='NAM');
			insert accreditation1;
			
			Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Product',
				Accreditation_Date__c = date.today(),
				Accreditation_Level__c='Advanced',
				Partner__c=account[0].Id,
				Portfolio__c='Fixed Access - FBA',
				Pricing_Cluster__c='NAM');
			insert accreditation2;
			
			List<Accreditation__c> maccreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(1);
			maccreditations[0].partner__c = account[0].Id;
			maccreditations[0].Accreditation_Type__c = 'Maintenance';
			maccreditations[0].Accreditation_Level__c = 'Premium';
			maccreditations[0].Pricing_Level_Override__c = 'Premium';   
			insert maccreditations;
			
			test.startTest();
			
			List <Opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,account);
			opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
			opportunities[0].End_Customer_LE__c = account[1].id;
			insert opportunities;
			
			/*List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>();
			opportunityTeamMemberList = TestDataFactory.optyTeamMemberCreation(2, sysAdminUser[0],opportunities[0]);
			insert opportunityTeamMemberList;*/
		
			Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
			priceList.Name='Global Price List (EUR)';
			priceList.CurrencyIsoCode='EUR';
			priceList.Apttus_Config2__Active__c=True;
			priceList.PriceList_Type__c='CPQ';
			priceList.Apttus_Config2__Type__c='Standard';
		
			insert priceList;
			
			Apttus_Proposal__Proposal__c testProposal = new Apttus_Proposal__Proposal__c(
			RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId(),
			Apttus_Proposal__Account__c = account[0].Id,
			Apttus_Proposal__Opportunity__c = opportunities.get(0).Id,
			Apttus_QPConfig__PriceListId__c = priceList.Id,
			Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
			NokiaCPQ_FN_Maintenance_Type__c='',
			NokiaCPQ_SRS_Level__c='',
			NokiaCPQ_Existing_IONMaint_Contract__c='',
			NokiaCPQ_Needs_Reprice__c = true,
			Reprice_In_Progress__c = false,
			NokiaCPQ_Existing_FN_Maint_Contract__c='',
			NokiaCPQ_No_of_Years__c = '',
			NokiaCPQ_ION_Maintenance_Type__c='',
			NokiaCPQ_SSP_Level__c='',
			NokiaCPQ_Portfolio__c = 'IP Routing',
			//NokiaProductAccreditation__c = accreditation1.id,
			//NokiaCPQ_Maintenance_Accreditation__c = maccreditations[0].id,
			Maintenance_Y1__c = 200,
			NokiaCPQ_Maintenance_Type__c ='');
	
			insert testProposal;
			
			Apttus_Config2__ProductConfiguration__c ProdConfig = new Apttus_Config2__ProductConfiguration__c();
			ProdConfig.Name = 'APTTUS Test Config'; 
			ProdConfig.Apttus_QPConfig__Proposald__c = testProposal.id;
			ProdConfig.Apttus_Config2__Status__c = 'Finalized';
			ProdConfig.Apttus_Config2__VersionNumber__c = 1;
			ProdConfig.Apttus_Config2__BusinessObjectType__c = 'Proposal';
		
			insert ProdConfig;
			
			Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=prodConfig.Id,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = priceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = prod.Id,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = account[0].Id);
			
			insert LineItem1;
			
			ApexPages.currentPage().getParameters().put('quoteId',testProposal.id);
			ApexPages.currentPage().getParameters().put('oppId',opportunities.get(0).Id);
			NokiaCPQQuoteApprovalController quoteApprovalCtrl = new  NokiaCPQQuoteApprovalController();
			quoteApprovalCtrl.init();
			quoteApprovalCtrl.cancel();
			test.stopTest();
		 }
	  }

}