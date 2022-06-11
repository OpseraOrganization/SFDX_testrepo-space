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
	   
	public static List<Apttus_Config2__ConfigLineItemCustomFields__c> customSettingsRecord_DataSetup(){
		list<Apttus_Config2__ConfigLineItemCustomFields__c> sObjListCustSetng = new List <Apttus_Config2__ConfigLineItemCustomFields__c>();

	   
			Apttus_Config2__ConfigLineItemCustomFields__c custSettings1 = new Apttus_Config2__ConfigLineItemCustomFields__c();
					custSettings1.Name = 'Nokia_LineItem_CustomField1';
				custSettings1.Apttus_Config2__CustomFieldNames2__c = 'NokiaCPQ_Product_Name__c,NokiaCPQ_Portfolio__c,NokiaCPQ_Maint_Yr1_Extended_Price__c,Nokia_Maintenance_Level__c,NokiaCPQ_SSP_Rate__c,Nokia_CPQ_Maint_Prod_Cat_Disc__c,Nokia_Maint_Y1_Per__c,Nokia_Maint_Y2_Per__c,Nokia_SSP_Base_Price__c';
				custSettings1.Apttus_Config2__CustomFieldNames3__c ='Nokia_SSP_Base_Extended_Price__c,Nokia_SRS_List_Price__c,NokiaCPQ_Maint_Accreditation_Discount__c,NokiaCPQ_Maint_Y1_List_Price__c,NokiaCPQ_Maint_Yr2_List_Price__c,NokiaCPQ_Maint_Yr1_Base_Price__c,Apttus_Config2__ProductId__r.Name';
				custSettings1.Apttus_Config2__CustomFieldNames4__c = 'NokiaCPQ_Maint_Yr2_Extended_Price__c,Nokia_Pricing_Cluster__c,NokiaCPQ_Accreditation_Discount__c,Nokia_Maint_Pricing_Cluster__c, Nokia_SRS_Base_Extended_Price__c,Nokia_SRS_Base_Price__c';				  
				custSettings1.Apttus_Config2__CustomFieldNames5__c ='Nokia_Maint_Y1_Extended_List_Price__c,NokiaCPQAccreditationType__c,Nokia_CPQ_Is_Dummy_Bundle_LI__c,Apttus_Config2__ProductId__r.Apttus_Config2__Version__c,Apttus_Config2__OptionId__r.Apttus_Config2__Version__c,Apttus_Config2__OptionId__r.Name';
				custSettings1.Apttus_Config2__CustomFieldNames__c ='NokiaCPQ_Part_Number__c,NokiaCPQ_Total_Maintenance_Discount__c,NokiaCPQ_Renewal_Per__c,NokiaCPQ_Attachment_Per__c,NokiaCPQ_Performance_Per__c,NokiaCPQ_Multi_Yr_Per__c,Source__c';
		
				sObjListCustSetng.add(custSettings1);
		
				Apttus_Config2__ConfigLineItemCustomFields__c custSettings2 = new Apttus_Config2__ConfigLineItemCustomFields__c();
				custSettings2.Name = 'Nokia_LineItem_CustomField2';
				custSettings2.Apttus_Config2__CustomFieldNames2__c = 'Apttus_Config2__AttributeValueId__r.How_is_the_licence_pricing_done__c,Nokia_Total_Quantity_SRS__c,Apttus_Config2__NetUnitPrice__c,Apttus_Config2__ProductId__r.NokiaCPQ_Item_Type__c';
				custSettings2.Apttus_Config2__CustomFieldNames3__c = 'Nokia_SSP_List_Price__c,NokiaCPQ_ExtendedPrice_CUP__c,NokiaCPQ_Extended_CLP1__c,NokiaCPQ_ExtendedPrice_CNP__c,NokiaCPQ_Extended_IRP2__c,NokiaCPQ_Extended_CLP_2__c';
				custSettings2.Apttus_Config2__CustomFieldNames4__c = 'NokiaCPQ_Extended_IRP__c,NokiaCPQ_Extended_CUP__c,NokiaCPQ_Extended_CNP__c,NokiaCPQ_Configuration_Type__c,NokiaCPQ_Unitary_IRP__c';
				custSettings2.Apttus_Config2__CustomFieldNames5__c = 'Apttus_Config2__OptionId__c,Apttus_Config2__ProductId__c,Apttus_Config2__PrimaryLineNumber__c,NokiaCPQ_Unitary_Cost__c,Classification_From_Product__c,Item_Type__c,NokiaCPQ_Product_Type__c,NokiaCPQ_Spare__c,NokiaCPQ_Is_SI__c';
				//Modified for ITCCPQ-2555 by Christie JJ
				//custSettings2.Apttus_Config2__CustomFieldNames__c = 'NokiaCPQ_Rationale_Of_Adjustment__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.NokiaProductAccreditation__r.NokiaCPQ_Incoterm_Percentage__c';
				custSettings2.Apttus_Config2__CustomFieldNames__c = 'NokiaCPQ_Rationale_Of_Adjustment__c';	
				sObjListCustSetng.add(custSettings2);
				
				Apttus_Config2__ConfigLineItemCustomFields__c custSettings3 = new Apttus_Config2__ConfigLineItemCustomFields__c();
				 custSettings3.Name = 'Nokia_LineItem_CustomField3';
				custSettings3.Apttus_Config2__CustomFieldNames2__c = 'Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.SSP__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.SRS__c,NokiaCPQ_IRP_Discount__c';
				custSettings3.Apttus_Config2__CustomFieldNames3__c = 'NokiaCPQ_ExtendedAdvance_NP__c,NokiaCPQ_CareSRSBasePrice__c,Advanced_pricing_done__c,NokiaCPQ_SRSBasePrice__c,NokiaCPQ_Unitary_Cost_Initial__c,NokiaCPQ_IsArcadiaBundle__c,Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c';
				custSettings3.Apttus_Config2__CustomFieldNames4__c = 'Apttus_Config2__OptionId__r.ProductCode,NokiaCPQ_Alias__c,Is_List_Price_Only__c,NokiaCPQ_SRS_Rate__c,Apttus_Config2__ProductId__r.IsSSP__c,NokiaCPQ_Opportunity_Name__c,NokiaCPQ_Is_CLP__c,OEM__c,NokiaCPQ_Light_Color__c,NokiaCPQ_Customer_Price_List__c';
				custSettings3.Apttus_Config2__CustomFieldNames5__c = 'NokiaCPQ_Maximum_IRP_Discount__c,Custom_Product_Code__c,NokiaCPQ_Account_Region__c,NokiaCPQ_Minimum_Sales_Margin__c,Apttus_Config2__ProductId__r.Family,NokiaCPQ_Org__c,Apttus_Config2__OptionId__r.Id,Apttus_Config2__ProductId__r.Id';
				custSettings3.Apttus_Config2__CustomFieldNames__c ='Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Maintenance_Y1__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Maintenance_Y2__c,Sales_Margin__c,NokiaCPQ_Extended_Cost__c,NokiaCPQ_AdvancePricing_CUP__c';
				sObjListCustSetng.add(custSettings3);
					
				Apttus_Config2__ConfigLineItemCustomFields__c custSettings4 = new Apttus_Config2__ConfigLineItemCustomFields__c();
						custSettings4.Name = 'Nokia_LineItem_CustomField4';
				custSettings4.Apttus_Config2__CustomFieldNames2__c = 'Apttus_Config2__OptionId__r.Apttus_Config2__ConfigurationType__c,NokiaCPQ_Floor_Price__c,NokiaCPQ_Custom_Bid__c,NokiaCPQ_BG__c,NokiaCPQ_BU__c,Apttus_Config2__ProductId__r.Business_Group__c,Apttus_Config2__ProductId__r.NokiaCPQ_Product_Discount_Category__c';
				custSettings4.Apttus_Config2__CustomFieldNames3__c = 'Apttus_Config2__OptionId__r.NokiaCPQ_Product_Discount_Category__c,Apttus_Config2__OptionId__r.NokiaCPQ_Item_Type__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__ProductId__r.Is_Dummy_Bundle_CPQ__c,NokiaCPQ_Extended_CNP_High__c';
				custSettings4.Apttus_Config2__CustomFieldNames4__c = 'Apttus_Config2__OptionId__r.Is_Dummy_Bundle_CPQ__c,NokiaCPQ_Is_Direct_Option__c,Item_Type_From_CAT__c,Apttus_Config2__ProductId__r.NokiaCPQ_OEM__c,Apttus_Config2__OptionId__r.NokiaCPQ_OEM__c,Apttus_Config2__ProductId__r.NokiaCPQ_Maximum_IRP_Discount__c';
				custSettings4.Apttus_Config2__CustomFieldNames5__c = 'Apttus_Config2__OptionId__r.NokiaCPQ_Maximum_IRP_Discount__c,Apttus_Config2__PriceListItemId__r.Contracted__c,Apttus_Config2__OptionId__r.NokiaCPQ_Min_SM_North_America__c,Apttus_Config2__OptionId__r.NokiaCPQ_Min_SM_Latin_America__c,NokiaCPQ_CNP_High__c';
				custSettings4.Apttus_Config2__CustomFieldNames__c ='Apttus_Config2__OptionId__r.NokiaCPQMin_SM_Middle_East_and_Africa__c,Apttus_Config2__OptionId__r.NokiaCPQ_Min_SM_India__c,Apttus_Config2__OptionId__r.NokiaCPQ_Min_SM_Asia_Pacific_Japan__c,Apttus_Config2__OptionId__r.NokiaCPQ_Min_SM_Greater_China__c';
				sObjListCustSetng.add(custSettings4);
					
				Apttus_Config2__ConfigLineItemCustomFields__c custSettings5 = new Apttus_Config2__ConfigLineItemCustomFields__c();
				custSettings5.Name = 'Nokia_LineItem_CustomField5';
				custSettings5.Apttus_Config2__CustomFieldNames2__c = 'Apttus_Config2__OptionId__r.NokiaCPQ_Min_SM_Europe__c,Total_ONT_Quantity_P2P__c,Total_ONT_Quantity_FBA__c,Is_P2P__c,Is_FBA__c,Total_ONT_Quantity__c,Apttus_Config2__OptionId__r.Number_of_GE_Ports__c';
				custSettings5.Apttus_Config2__CustomFieldNames3__c = 'NokiaCPQ_Category__c,Product_Number_Of_Ports__c,Total_Option_Quantity__c,Apttus_Config2__ProductId__r.Portfolio__c,NokiaCPQ_Static_Bundle_Option__c,Apttus_Config2__OptionId__r.NokiaCPQ_Category__c,Apttus_Config2__ProductId__r.NokiaCPQ_Category__c';
				custSettings5.Apttus_Config2__CustomFieldNames4__c = 'CPQ_Original_Proposed_Price__c,Apttus_Config2__BasePriceOverride__c,CPQ_Group_Quantity__c,CPQ_Group_Adjustment_Type__c,CPQ_Group_Adjustment_Amount__c,CPQ_Group_Unit_Override_Price__c,CPQ_Market_Model__c';
				custSettings5.Apttus_Config2__CustomFieldNames5__c = 'Apttus_Config2__ProductOptionId__r.Apttus_Config2__ParentProductId__r.NokiaCPQ_Static_Bundle_Option__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.NokiaCPQ_Portfolio__c,Nokia_CPQ_Is_Dummy_Bundle_LI__c';
				custSettings5.Apttus_Config2__CustomFieldNames__c ='Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Quote_Type__c,Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c,NokiaCPQ_CNP_High__c,NokiaCPQ_Extended_CNP_High__c';
				sObjListCustSetng.add(custSettings5);
					
				Apttus_Config2__ConfigLineItemCustomFields__c custSettings6 = new Apttus_Config2__ConfigLineItemCustomFields__c();
				custSettings6.Name = 'Nokia_LineItem_CustomField6';	 
				custSettings6.Apttus_Config2__CustomFieldNames2__c = 'Apttus_Config2__OptionId__r.CPQ_XREF_Map_Flag__c,Apttus_Config2__OptionId__r.CPQ_Equipment_Flag__c,Apttus_Config2__ProductId__r.CPQ_XREF_Map_Flag__c,Apttus_Config2__ProductId__r.CPQ_Equipment_Flag__c,Invalid_Maintenance_type__c';
				custSettings6.Apttus_Config2__CustomFieldNames3__c = 'Apttus_Config2__ProductId__r.CPQ_Secondary_Category__c,Apttus_Config2__ProductId__r.NokiaCPQ_Portfolio_Package_Code__c,Apttus_Config2__ProductId__r.CPQ_ICD_Code__c';
				custSettings6.Apttus_Config2__CustomFieldNames4__c = 'CPQ_Contracted_Price__c,CPQ_Discounted_Price__c,CPQ_Contractual_Discounts__c,CPQ_Conditional_Price_Code__c,CPQ_Agreement_Contract_Price__c,CPQ_Contractual_Discounts_Applied__c,Apttus_Config2__IncentiveCode__c';
				custSettings6.Apttus_Config2__CustomFieldNames5__c = 'Apttus_Config2__OptionId__r.CPQ_Secondary_Category__c,Apttus_Config2__ProductId__r.CPQ_Price_Class__c,Apttus_Config2__OptionId__r.CPQ_Price_Class__c,Apttus_Config2__ProductId__r.CPQ_SSF_Permission__c,Apttus_Config2__OptionId__r.CPQ_SSF_Permission__c';
				custSettings6.Apttus_Config2__CustomFieldNames__c ='CPQ_Transport_Price__c,CPQ_Price_Class__c,CPQ_SSF_Billing_Rule_ID__r.CPQ_Billing_Rule_Code__c,CPQ_SSF_Billing_Rule_ID__r.CPQ_Billing_Rule_Description__c,CPQ_Secondary_Category__c,CPQ_Transport_Percent__c, CPQ_Uploaded_via_SSF__c';
				sObjListCustSetng.add(custSettings6);
		
				Apttus_Config2__ConfigLineItemCustomFields__c custSettings7 = new Apttus_Config2__ConfigLineItemCustomFields__c();
				custSettings7.Name = 'Nokia_LineItem_CustomField7';	 
				custSettings7.Apttus_Config2__CustomFieldNames2__c = 'Apttus_Config2__PriceListItemId__r.Partner_Price__c,Is_Contract_Pricing_2__c,NokiaCPQ_Maint_Yr2_Base_Price__c,NokiaCPQ_Maint_Yr1_Extended_Price__c';
				custSettings7.Apttus_Config2__CustomFieldNames3__c = 'NokiaCPQ_Product_Discount_Category__c,Portfolio_from_Quote_Line_Item__c,Apttus_Config2__PriceListItemId__r.Apttus_Config2__PriceListId__c,NCPQ_Unitary_CLP__c,NokiaCPQ_Extended_CLP__c';
				custSettings7.Apttus_Config2__CustomFieldNames4__c = 'NokiaCPQ_Extended_CUP_2__c,Apttus_Config2__ParentBundleNumber__c,NokiaCPQ_IncotermNew__c,is_Custom_Product__c,CustomProductValue__c,Apttus_Config2__OptionId__r.Number_of_GE_Ports__c';
				custSettings7.Apttus_Config2__CustomFieldNames5__c = 'NokiaCPQ_Is_CAT_Configured__c,Apttus_Config2__ProductId__r.Number_of_GE_Ports__c,License_Usage_From_Product__c,NokiaCPQ_AdvancePricing_NP__c,NokiaCPQAdv_Net_Price__c';
				custSettings7.Apttus_Config2__CustomFieldNames__c ='Apttus_Config2__ProductId__r.Number_of_GE_Ports__c,Apttus_Config2__OptionId__r.NokiaCPQ_Min_SM_Europe__c,Total_ONT_Quantity_P2P__c,Total_ONT_Quantity_FBA__c,Is_P2P__c,Is_FBA__c,Total_ONT_Quantity__c';
				sObjListCustSetng.add(custSettings7);
		
		
				 Apttus_Config2__ConfigLineItemCustomFields__c custSettings8 = new Apttus_Config2__ConfigLineItemCustomFields__c();
				 custSettings8.Name = 'Nokia_LineItem_CustomField8';		
				 custSettings8.Apttus_Config2__CustomFieldNames2__c = 'Is_Dummy_Product__c,Apttus_Config2__ProductId__r.Is_Dummy_Product__c,Apttus_Config2__OptionId__r.Is_Dummy_Product__c,NokiaCPQ_Is_CLP_in_PDC__c,Apttus_Config2__OptionId__r.CPQ_Activity_Type__c';
				 custSettings8.Apttus_Config2__CustomFieldNames3__c = 'Apttus_Config2__OptionId__r.NokiaCPQ_Static_Bundle_Option__c,Apttus_Config2__ProductId__r.NokiaCPQ_Static_Bundle_Option__c,Apttus_Config2__ProductId__r.CPQ_Activity_Type__c';
				 custSettings8.Apttus_Config2__CustomFieldNames4__c = 'Apttus_Config2__OptionId__r.CPQ_Budget_Hrs__c,Apttus_Config2__ProductId__r.CPQ_Budget_Hrs__c,Apttus_Config2__OptionId__r.CPQ_Description__c';
				 custSettings8.Apttus_Config2__CustomFieldNames5__c = 'Apttus_Config2__ProductId__r.CPQ_Activity_Type__c,Apttus_Config2__ProductId__r.CPQ_Budget_Hrs__c,Apttus_Config2__ProductId__r.CPQ_Description__c';
				 custSettings8.Apttus_Config2__CustomFieldNames__c = 'Apttus_Config2__ProductId__r.CPQ_Work_Center__c,Apttus_Config2__ProductId__r.NokiaCPQ_State__c,Apttus_Config2__AddedBy__c,Apttus_Config2__OptionId__r.Business_Group__c';
				sObjListCustSetng.add(custSettings8);

				 Apttus_Config2__ConfigLineItemCustomFields__c custSettings9 = new Apttus_Config2__ConfigLineItemCustomFields__c();
				 custSettings9.Name = 'Nokia_LineItem_CustomField9'; 
				 custSettings9.Apttus_Config2__CustomFieldNames2__c = 'Apttus_Config2__OptionId__r.Family,Apttus_Config2__OptionId__r.NokiaCPQ_State__c,Apttus_Config2__OptionId__r.CPQ_Work_Center__c,Apttus_Config2__OptionId__r.CPQ_T_L__c';
				 custSettings9.Apttus_Config2__CustomFieldNames3__c = 'Apttus_Config2__ProductId__r.CPQ_Network_Activity__c,Apttus_Config2__ProductId__r.CPQ_T_L__c,Apttus_Config2__OptionId__r.CPQ_Network_Activity__c';
				 custSettings9.Apttus_Config2__CustomFieldNames4__c = 'Apttus_Config2__ProductId__r.Is_Dummy_Product__c,Apttus_Config2__ProductId__r.NokiaCPQ_Static_Bundle_Option__c,Apttus_CQApprov__Approval_Status__c,CPQ_BOM_Quantity__c,CPQ_State__c';
				 custSettings9.Apttus_Config2__CustomFieldNames5__c = 'Apttus_Config2__PriceListItemId__r.Apttus_Config2__PriceListId__r.PriceList_Type__c,Apttus_Config2__IsQuantityModifiable__c,Apttus_Config2__Quantity__c';
				 sObjListCustSetng.add(custSettings9);

		return sObjListCustSetng;
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
		//FN R22.3 :Added as part of new FN implementation
	Accreditation__c accreditation3 = new Accreditation__c(Accreditation_Type__c='Product',
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Advanced',
	Partner__c=acc.Id,
	Portfolio__c=Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA,
	Pricing_Cluster__c='NAM',
	Pricing_Level_Override__c = 'Expert',
	Pricing_Override_Expiration__c = Date.today().addDays(10)
	);
	accredList.add(accreditation3);
	Accreditation__c accreditation4 = new Accreditation__c(Accreditation_Type__c='Maintenance',
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Advanced',
	Partner__c=acc.Id,
	Portfolio__c=Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_FBA,
	Pricing_Cluster__c='NAM',
	Pricing_Level_Override__c = 'Expert',
	Pricing_Override_Expiration__c = Date.today().addDays(10)
	);
	accredList.add(accreditation4);
	Accreditation__c accreditation5 = new Accreditation__c(Accreditation_Type__c='Product',
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Advanced',
	Partner__c=acc.Id,
	Portfolio__c=Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
	Pricing_Cluster__c='NAM',
	Pricing_Level_Override__c = 'Expert',
	Pricing_Override_Expiration__c = Date.today().addDays(10)
	);
	accredList.add(accreditation5);
	Accreditation__c accreditation6 = new Accreditation__c(Accreditation_Type__c='Maintenance',
	Accreditation_Date__c = date.today(),
	Accreditation_Level__c='Advanced',
	Partner__c=acc.Id,
	Portfolio__c=Nokia_CPQ_Constants.NOKIA_FIXED_ACCESS_POL,
	Pricing_Cluster__c='NAM',
	Pricing_Level_Override__c = 'Expert',
	Pricing_Override_Expiration__c = Date.today().addDays(10)
	);
	accredList.add(accreditation6);
		
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
		//Modified for ITCCPQ-2555 by Christie
		//IPprop.NokiaProductAccreditation__c = accr.id;
		//IPprop.NokiaCPQ_Maintenance_Accreditation__c = accr.id;
		//IPprop.NokiaCPQ_Maintenance_Level__c = 'Yes';
		IPprop.CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
		IPprop.NokiaCPQ_LEO_Discount__c=false;
		IPprop.Is_List_Price_Only__c =false;
		IPprop.NokiaCPQ_Is_cloned__c = false;
		IPprop.RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
		IPprop.isCQ__c = false;
		
		return IPprop;
	}

	//FN R22.3 :Added as part of new FN implementation
public static Apttus_Proposal__Proposal__c createInDirectFNProposal(Opportunity opp, Account acc, Apttus_Config2__PriceList__c apl, Accreditation__c accr) {
	Apttus_Proposal__Proposal__c propFN = new Apttus_Proposal__Proposal__c();
	propFN.Apttus_Proposal__Account__c = acc.Id;
	propFN.Apttus_Proposal__Opportunity__c = opp.Id;
	propFN.Apttus_QPConfig__PriceListId__c = apl.Id;
	propFN.Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today();
	propFN.NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
	propFN.NokiaCPQ_Existing_FN_Maint_Contract__c = 'No';
	propFN.NokiaCPQ_ION_Maintenance_Type__c = 'Gold';
	propFN.NokiaCPQ_FN_Maintenance_Type__c = 'Gold';
	propFN.NokiaCPQ_SSP_Level__c = 'Unlimited';
	propFN.NokiaCPQ_SRS_Level__c = 'Unlimited';
	propFN.NokiaCPQ_Maintenance_Type__c = 'Gold (Return for Exchange)';
	propFN.NokiaCPQ_Portfolio__c = Nokia_CPQ_Constants.NOKIA_INDIRECT_FN;
	//propFN.CPQ_SubPortfolio__c = 'Fixed Wireless Access;Broadband Access Networks;Optical LAN';
	propFN.NokiaCPQ_No_of_Years__c = '1';
	propFN.CurrencyIsoCode = Nokia_CPQ_Constants.USDCURRENCY;
	propFN.NokiaCPQ_LEO_Discount__c=false;
	propFN.Is_List_Price_Only__c =false;
	propFN.NokiaCPQ_Is_cloned__c = false;
	propFN.RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Draft_Quote').getRecordTypeId();
	propFN.isCQ__c = false;
	return propFN;
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