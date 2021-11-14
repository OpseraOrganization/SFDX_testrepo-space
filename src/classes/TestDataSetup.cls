/** 
* About 
* ----- 
* @Description : TestDataSetup - Data creation
* @testClass  : None.
* @project  : All. 
* @changeLog   : 
*  Created  : HCL
*  Modified : 
* ----- 
**/
@isTest
public without sharing class TestDataSetup {
   
	public static Apttus_Config2__ConfigCustomClasses__c customSettingsRecord(){
		Apttus_Config2__ConfigCustomClasses__c custSetting = new Apttus_Config2__ConfigCustomClasses__c();
		custSetting.Apttus_Config2__PricingCallbackClass__c = 'Nokia_PricingCallBack';
		custSetting.Name = 'Nokia_CallBack1';
		return custSetting;
	}
	
	public static List<product2> createCPQTestproduct(Integer size) {
		List<product2> productList = new List<product2>();
		for (integer i = 0; i < size; i++) {
			product2 prod = new product2();
			prod.Name = 'Test1'; 
			prod.ProductCode = '123'; 
			prod.CurrencyIsoCode = 'USD';
			prod.Portfolio__c = 'Nokia Software';
			prod.isActive = true;
			prod.Apttus_Config2__ConfigurationType__c = 'Standalone';
			prod.NokiaCPQ_Item_Type__c='Software';
			prod.NokiaCPQ_Classification2__c='Standard SW (STD)';
			prod.NokiaCPQ_License_Usage__c='Commercial Term License';
			prod.NokiaCPQ_Product_Discount_Category__c = 'XYZ';
			productList.add(prod);
		}
		return productList;
	}  
	public static List<Apttus_Config2__PriceListItem__c> creatPriceListItem(Apttus_Config2__PriceList__c ApttusPriceList, Integer size) {
		 string chargeType = 'Standard Price';
		List<Apttus_Config2__PriceListItem__c> priceListItemList = new List<Apttus_Config2__PriceListItem__c>();
		
		for (integer i = 0; i < size; i++){
			Apttus_Config2__PriceListItem__c pli = new Apttus_Config2__PriceListItem__c();
			pli.Apttus_Config2__PriceListId__c = ApttusPriceList.Id;
			pli.Apttus_Config2__ListPrice__c = 100;
			pli.Apttus_Config2__ChargeType__c = chargeType; 
			priceListItemList.add(pli);
		}
		return priceListItemList;
	}
	public static Apttus_Proposal__Proposal__c creatProposal(Opportunity opp, Account acc, Apttus_Config2__PriceList__c apl) {
		Apttus_Proposal__Proposal__c prop = new Apttus_Proposal__Proposal__c();
		prop.Apttus_Proposal__Opportunity__c = opp.Id;
		prop.Apttus_QPConfig__PriceListId__c = apl.Id;
		prop.Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today();
		prop.NokiaCPQ_Portfolio__c = 'Nokia Software';
		prop.Apttus_Proposal__Approval_Stage__c = 'Draft';
		prop.NokiaCPQ_No_of_Years__c = '1';
		prop.RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('Direct_Quote').getRecordTypeId();
		prop.Apttus_Proposal__Account__c=acc.id;
		prop.Is_List_Price_Only__c =false;
		
		return prop;
	}   
	public static Apttus_Config2__ProductConfiguration__c creatProductConfiguration(Account acc, Apttus_Config2__PriceList__c apl,Apttus_Proposal__Proposal__c prop){
		
		Apttus_Config2__ProductConfiguration__c prodConfigTest = new Apttus_Config2__ProductConfiguration__c();
		prodConfigTest.Name = 'APTTUS Test Config';
		prodConfigTest.Apttus_Config2__AccountId__c = acc.Id;
		prodConfigTest.Apttus_Config2__PriceListId__c = apl.Id;
		prodConfigTest.Apttus_QPConfig__Proposald__c = prop.Id;
		prodConfigTest.Apttus_Config2__Status__c = 'New';
		prodConfigTest.Apttus_Config2__VersionNumber__c = 1; 
		prodConfigTest.Apttus_Config2__EffectivePriceListId__c = apl.Id;
		prodConfigTest.Apttus_Config2__BusinessObjectId__c = String.valueOf(prop.Id);
		prodConfigTest.Apttus_Config2__BusinessObjectType__c = 'Proposal';
		
		return prodConfigTest;
	}
	public static List<Apttus_Config2__LineItem__c> creatConfigLineItem(Account acc, Apttus_Config2__ProductConfiguration__c prodConfigTest, Apttus_Config2__PriceList__c apl, Product2 prod, integer size){
		
		List<Apttus_Config2__LineItem__c> lineItemList =new List<Apttus_Config2__LineItem__c>();		
		for(integer i =0; i<size; i++){
			Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c();
			lineItem.Apttus_Config2__ConfigurationId__c=prodConfigTest.Id;
			lineItem.Apttus_Config2__ItemSequence__c = 1;
			lineItem.Apttus_Config2__LineNumber__c = 1;
			lineItem.Apttus_Config2__LineStatus__c='New';
			lineItem.Apttus_Config2__PriceListId__c = apl.id;
			lineItem.Apttus_Config2__ChargeType__c = 'Standard Price'; 
			lineItem.Apttus_Config2__LineType__c = 'Option';
			lineItem.Apttus_Config2__ProductId__c = prod.Id;
			lineItem.Apttus_Config2__PriceMethod__c = 'Per Unit';
			lineItem.Apttus_Config2__Frequency__c = 'One Time';
			lineItem.Apttus_Config2__BasePrice__c=120;
			lineItem.Apttus_Config2__ListPrice__c = 100;
			lineItem.Apttus_Config2__Quantity__c = 1;
			lineItem.Apttus_Config2__ParentBundleNumber__c = 1;
			lineItem.Apttus_Config2__PrimaryLineNumber__c = 2;
			lineItem.Apttus_Config2__ShipToAccountId__c = acc.Id;
			lineItem.is_Custom_Product__c=false;
			lineItem.Apttus_Config2__BasePriceOverride__c=1180.52;
			lineItem.Apttus_Config2__AddedBy__c = 'added by code';
			lineItemList.add(lineItem);
		}
		return lineItemList;
	}
	public static Apttus_Config2__ClassificationName__c createCategorySO(){
		Apttus_Config2__ClassificationName__c catSO = new Apttus_Config2__ClassificationName__c();
		catSO.Apttus_Config2__Active__c = true;
		catSO.Apttus_Config2__Type__c = 'Offering';
		catSO.Apttus_Config2__HierarchyLabel__c = 'Test826';
		
		return catSO;
	}
	public static Apttus_Config2__PriceList__c createpriceListSO(){
		Apttus_Config2__PriceList__c priceListSO = new Apttus_Config2__PriceList__c();
		priceListSO.Name = 'Commercial Price List';
		priceListSO.Apttus_Config2__Active__c = true;
		
		return priceListSO;
	}
	public static Apttus_Config2__PriceListCategory__c createPriceListCategorySO(Apttus_Config2__ClassificationName__c catSO, Apttus_Config2__PriceList__c plSO){
		Apttus_Config2__PriceListCategory__c priceListCatSO = new Apttus_Config2__PriceListCategory__c();
		priceListCatSO.Apttus_Config2__HierarchyId__c = catSO.id;
		priceListCatSO.Apttus_Config2__PriceListId__c = plSO.id;
		priceListCatSO.Apttus_Config2__Sequence__c =1;
		
		return priceListCatSO;
	}
	public static Apttus_Config2__ClassificationHierarchy__c createPriceListCategorySO(Apttus_Config2__ClassificationName__c catSO){
		Apttus_Config2__ClassificationHierarchy__c chSO = new Apttus_Config2__ClassificationHierarchy__c();
		chSO.Apttus_Config2__HierarchyId__c = catSO.id;
		chSO.Apttus_Config2__Left__c=1;
		chSO.Apttus_Config2__Right__c=2;
		chSO.Apttus_Config2__Label__c= 'My Category';
		
		return chSO;
	}
	public static List<Apttus_Config2__ProductClassification__c> createProdClassification(Apttus_Config2__ClassificationHierarchy__c chSO, integer size){
		List<Apttus_Config2__ProductClassification__c> prodClassificationList = new List<Apttus_Config2__ProductClassification__c>();
		for(integer i=0; i<size; i++){
			Apttus_Config2__ProductClassification__c productClassificationSO = new Apttus_Config2__ProductClassification__c();
			productClassificationSO.Apttus_Config2__ClassificationId__c = chSO.id;
			productClassificationSO.Apttus_Config2__Sequence__c = 1;
			productClassificationSO.Apttus_Config2__DefaultQuantity__c = 1;
			prodClassificationList.add(productClassificationSO);
		}
		return prodClassificationList;
	}
	public static List<Accreditation__c> createAccreditation(Account acc) {
		List<Accreditation__c> accredList = new List<Accreditation__c>();
		
		Accreditation__c accreditation1 = new Accreditation__c(Accreditation_Type__c='Maintenance',
															   Accreditation_Date__c = date.today(),
															   Accreditation_Level__c='Nokia Brand of Service',
															   Partner__c=acc.Id,
															   Portfolio__c=Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
															   Pricing_Cluster__c='MPW Cluster 2',
															   Pricing_Level_Override__c = 'Nokia Brand of Service',
															   Pricing_Override_Expiration__c = Date.today().addDays(10)
															  );
		accredList.add(accreditation1);
		
		Accreditation__c accreditation2 = new Accreditation__c(Accreditation_Type__c='Product',
															   Accreditation_Date__c = date.today(),
															   Accreditation_Level__c='Advanced',
															   Partner__c=acc.Id,
															   Portfolio__c=Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION,
															   Pricing_Cluster__c='MPW Cluster 2',
															   Pricing_Level_Override__c = 'Advanced',
															   Pricing_Override_Expiration__c = Date.today().addDays(10)
															  );
		accredList.add(accreditation2);
		
		return accredList;
	}
	public static Apttus_Proposal__Proposal__c createIPProposal(Opportunity opp, Account acc, Apttus_Config2__PriceList__c apl, Accreditation__c accr) {
		Apttus_Proposal__Proposal__c IPprop = new Apttus_Proposal__Proposal__c();
		IPprop.Apttus_Proposal__Account__c = acc.Id;
		IPprop.Apttus_Proposal__Opportunity__c = opp.Id;
		IPprop.Apttus_QPConfig__PriceListId__c = apl.Id;
		IPprop.Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today();
		IPprop.NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
		IPprop.NokiaCPQ_Existing_FN_Maint_Contract__c = 'No';
		IPprop.NokiaCPQ_ION_Maintenance_Type__c = 'Gold';
		IPprop.NokiaCPQ_FN_Maintenance_Type__c = 'Gold';
		IPprop.NokiaCPQ_SSP_Level__c = 'Unlimited';
		IPprop.NokiaCPQ_SRS_Level__c = 'Unlimited';
		IPprop.NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)';
		IPprop.NokiaCPQ_Portfolio__c = 'IP Routing';
		IPprop.NokiaCPQ_No_of_Years__c = '1';
		IPprop.NokiaProductAccreditation__c = accr.id;
		IPprop.NokiaCPQ_Maintenance_Accreditation__c = accr.id;
		IPprop.NokiaCPQ_Maintenance_Level__c = 'Yes';
		IPprop.CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		IPprop.NokiaCPQ_LEO_Discount__c=false;
		IPprop.Is_List_Price_Only__c =false;
		IPprop.NokiaCPQ_Is_cloned__c = false;
		IPprop.RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
		IPprop.isCQ__c = false;
		
		return IPprop;
	}
	public static Apttus_Config2__PriceList__c createPriceList(){
		//get a Price List
		Apttus_Config2__PriceList__c priceList = new Apttus_Config2__PriceList__c();
		priceList.Name='Global Price List (EUR)';
		priceList.CurrencyIsoCode='GBP';
		priceList.Apttus_Config2__Active__c=false;
		priceList.PriceList_Type__c='CPQ';
		priceList.Apttus_Config2__Type__c='Standard';
		return priceList;
	}
	public static Apttus_Config2__LineItem__c createConfigLineItem(Id configId, Id priceListId, Id productInstId, Id accId){
		Apttus_Config2__LineItem__c LineItem =new Apttus_Config2__LineItem__c(
			Apttus_Config2__ConfigurationId__c = configId,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 1,
			Apttus_Config2__LineStatus__c='New',
			Apttus_Config2__PriceListId__c = priceListId,
			Apttus_Config2__ChargeType__c = 'Standard Price', 
			Apttus_Config2__LineType__c = 'Product/Service',
			Apttus_Config2__ProductId__c = productInstId,
			Apttus_Config2__PriceMethod__c = 'Per Unit',
			Apttus_Config2__Frequency__c = 'One Time',
			Apttus_Config2__AdjustmentAmount__c = 10,
			Apttus_Config2__ListPrice__c = 100,
			Apttus_Config2__Quantity__c = 1,
			Apttus_Config2__PrimaryLineNumber__c = 1,
			Apttus_Config2__ShipToAccountId__c = accId,	
			Apttus_Config2__AddedBy__c = 'added by code'
		);
		return LineItem;
	}
	
	public static Apttus_QPConfig__ProposalSummaryGroup__c createProposalSummaryGroup(Id proposalId, Integer adjustedAmount){
		//Proposal Summary Group
		Apttus_QPConfig__ProposalSummaryGroup__c propSummaryGrp1 = new Apttus_QPConfig__ProposalSummaryGroup__c(
			Apttus_QPConfig__ProposalId__c = proposalId,
			Apttus_QPConfig__AdjustmentAmount__c = adjustedAmount,
			CurrencyIsoCode = 'USD',
			Apttus_QPConfig__NetPrice__c = 100.00,
			Apttus_QPConfig__ItemSequence__c = 1,
			Apttus_QPConfig__LineNumber__c = 1,
			Apttus_QPConfig__ExtendedPrice__c = 100,
			name = 'Total (One Time)'
		);
		return propSummaryGrp1;
	}
	
	public static Apttus_Config2__SummaryGroup__c createSummaryGroup(Id prodConfigId, Integer adjustedAmount){
		//Summary Group
		Apttus_Config2__SummaryGroup__c summaryGrp1 = new Apttus_Config2__SummaryGroup__c(
			Apttus_Config2__AdjustmentAmount__c = adjustedAmount,
			CurrencyIsoCode = 'USD',
			name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__ConfigurationId__c = prodConfigId,
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c= 1)
			;
		return summaryGrp1;
	}
	
	public static Apttus_Config2__SummaryGroup__c createSummaryGroup2(Id prodConfigId){
		//Summary Group
		Apttus_Config2__SummaryGroup__c sg = new Apttus_Config2__SummaryGroup__c(
			Apttus_Config2__ConfigurationId__c = prodConfigId,
			NokiaCPQ_Additional_Information__c = 'dummy',
			Name = 'Subtotal - Standard Price (One Time)',
			Apttus_Config2__ItemSequence__c = 1,
			Apttus_Config2__LineNumber__c = 2
		);
		return sg;
	}
	
	public static Offer__c createOffer(Id oppId, Boolean noLOA, Boolean activeOffer, Boolean primaryManager, Boolean accManager){
		Offer__c offer = new Offer__c(
			No_LoA__c = noLOA,
			ActiveOffer__c = activeOffer,
			Authorized_for_Pricing_Manager__c = primaryManager,
			Pre_approved_Price_List_for_Acc_Managers__c = accManager,
			Expected_LoA_G4_Approval_Level__c = 'LoA Bypass',
			LOA_Bypass__c = 'Pre-approved Price List for Account Managers',
			Opportunity__c = oppId
		); 
		return offer;
	}
	
		public static Product2 createProduct2(){
		product2 productInst = new product2(
			Name = 'Test3', 
			ProductCode = '4256', 
			//Business_Group__c = 'MN', 
			CurrencyIsoCode = 'EUR',
			IsActive = true,
			Capacity__c = 'full',
			Portfolio__c = 'Microwave',
			NokiaCPQ_Portfolio_Package_Code__c = 'Microwave',
			NokiaCPQ_Item_Type__c = 'Software',
			Apttus_Config2__ConfigurationType__c='Bundle',
			NokiaCPQ_State__c = 'Release',
			RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId()
		); 
		return productInst;
	}
}