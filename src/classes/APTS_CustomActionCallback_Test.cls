/*************************************************************
@Name: APTS_CustomActionCallback_Test 
@Author: Christie JJ
@CreateDate: 8 February 2021
@Description: This class acts as the test class for APTS_CustomActionCallback (rqmt 6987)
@UsedBy: Apex Class
******************************************************************/

@isTest(SeeAllData=true)
public class APTS_CustomActionCallback_Test{
	
	public static testmethod void validateCustomActionCallback_beforeCopyBundleLineItems(){
		List<User> PartnerUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Non-Sales User Profile');
		insert PartnerUser;
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;
		
		List<Account> acclist = new List<Account>();
		acclist.add(accounts[0]);
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities; 
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].StageName='Create Offer (Bid)';
	
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();
   
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'Alliance Partner';
   
		opportunities[0].G4_Planned_Date__c =  Date.Today();
   
		update opportunities[0];
		List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>();
		opportunityTeamMemberList = TestDataFactory.optyTeamMemberCreation(2, PartnerUser[0],opportunities[0]);
		insert opportunityTeamMemberList;
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations;
		test.startTest(); 
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		

		
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = true;
		proposals[0].Reprice_In_Progress__c = false;
		
		proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
		insert proposals;	 
		
		
		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='GBP';
		priceList.Apttus_Config2__Active__c=false;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		
		insert priceList;
		
		// create a product configuration
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
		insert prodConfigs;
		
		//get a IP Routing Product
		Product2 productInst = new Product2();
		productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
   
	
	 

		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
			Source__c = 'EPT',
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = priceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = productInst.Id,
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
		 

		
		
		insert LineItem1;
		
		Apttus_Config2.CustomClass.ActionCallbackRequest request = new Apttus_Config2.CustomClass.ActionCallbackRequest();
		List<String> bundleLineItemIds = new List<String>();
		bundleLineItemIds.add(LineItem1.Id);
		request.CartId = prodConfigs[0].Id;
		request.BundleLineItemIds = bundleLineItemIds;
		APTS_CustomActionCallback objControllerClass = new APTS_CustomActionCallback();
		objControllerClass.beforeCopyBundleLineItems(request);
		test.stopTest(); 
		 
	 }



	  public static testmethod void validateCustomActionCallback_beforeDeleteBundleLineItems(){
		List<User> PartnerUser = NOKIA_CPQ_TestDataFactory.userCreation(1,'Non-Sales User Profile');
		insert PartnerUser;
		//create a Account
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(2);
		accounts[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		accounts[1].AccountNumber='';
		accounts[1].Partner_Type__c = '';
		accounts[1].Partner_Program__c = '';
		insert accounts;
		
		List<Account> acclist = new List<Account>();
		acclist.add(accounts[0]);
		
		//create opportunity
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,acclist);
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Submitted for G4 Approval';
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Record_Type').getRecordTypeId();
		opportunities[0].End_Customer_LE__c = accounts[1].id;
		insert opportunities; 
		
		opportunities[0].StageName = 'Create Offer (Bid)';
		opportunities[0].Phase_Status__c = 'Offer in Progress';
		opportunities[0].StageName='Create Offer (Bid)';
	
		opportunities[0].LOA_Level__c = '';
		opportunities[0].No_Loa__c = false;
		opportunities[0].Apttus_Approval__Approval_Status__c = 'Approved';
		opportunities[0].G2_Approval_Date__c = Date.Today();
   
		opportunities[0].G3_Planned_Date__c =  Date.Today();
		opportunities[0].Account_Role__c = 'Alliance Partner';
   
		opportunities[0].G4_Planned_Date__c =  Date.Today();
   
		update opportunities[0];
		List<OpportunityTeamMember> opportunityTeamMemberList = new List<OpportunityTeamMember>();
		opportunityTeamMemberList = TestDataFactory.optyTeamMemberCreation(2, PartnerUser[0],opportunities[0]);
		insert opportunityTeamMemberList;
		
		//create Accreditation
		List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
		accreditations[0].partner__c = accounts[0].Id;
		accreditations[1].partner__c = accounts[0].Id;
		accreditations[1].Accreditation_Type__c = 'Maintenance';
		accreditations[1].Accreditation_Level__c = 'Premium';
		accreditations[1].Pricing_Level_Override__c = 'Premium';   
		insert accreditations;
		test.startTest(); 
		//create a quote
		List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposal(1);
		

		
		proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
		proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
		proposals[0].NokiaCPQ_Needs_Reprice__c = true;
		proposals[0].Reprice_In_Progress__c = false;
		
		proposals[0].RecordTypeId ='01241000001EPXcAAO'; //indirect draft quote
		insert proposals;	 
		
		
		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='GBP';
		priceList.Apttus_Config2__Active__c=false;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		
		insert priceList;
		
		// create a product configuration
		List<Apttus_Config2__ProductConfiguration__c> prodConfigs = NOKIA_CPQ_TestDataFactory.createProdConfig(1);
		prodConfigs[0].Apttus_Config2__PriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__EffectivePriceListId__c = priceList.Id;
		prodConfigs[0].Apttus_Config2__AccountId__c = accounts[0].Id;
		prodConfigs[0].Apttus_QPConfig__Proposald__c = proposals[0].Id;
		insert prodConfigs;
		
		//get a IP Routing Product
		Product2 productInst = new Product2();
		productInst = [SELECT Id, NAME, Portfolio__c, ProductCode, Apttus_Config2__ConfigurationType__c, NokiaCPQ_Category__c, NokiaCPQ_Product_Discount_Category__c, Pricing_Clusters_Search_Filter__c, Pricing_Clusters__c, NokiaCPQ_State__c FROM Product2 WHERE Portfolio__c =: proposals[0].NokiaCPQ_Portfolio__c AND NokiaCPQ_State__c != null Limit 1];
   
	
	 

		Apttus_Config2__LineItem__c LineItem1 =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c=prodConfigs[0].Id,
			Source__c = 'EPT',
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = priceList.id,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = productInst.Id,
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
		 

		
		
		insert LineItem1;
		
		Apttus_Config2.CustomClass.ActionCallbackRequest request = new Apttus_Config2.CustomClass.ActionCallbackRequest();
		List<String> bundleLineItemIds = new List<String>();
		bundleLineItemIds.add(LineItem1.Id);
		request.CartId = prodConfigs[0].Id;
		request.BundleLineItemIds = bundleLineItemIds;
		APTS_CustomActionCallback objControllerClass = new APTS_CustomActionCallback();
		objControllerClass.beforeDeleteBundleLineItems(request);
		test.stopTest(); 
		 
	 }
 }