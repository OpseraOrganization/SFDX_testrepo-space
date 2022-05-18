/******************************
 * Author : Christie JJ
 * Date : 05/30/2021
 * Description : The class controls the link and visibility of Preapproved CustomProducts Lightning Component
 *******************************/
public with sharing class PreapprovedCustomProductsController {

static List < Apttus_CPQApi.CPQ.SelectedProductDO > selectedProdDOList = new List < Apttus_CPQApi.CPQ.SelectedProductDO > ();
List < Apttus_Config2__ProductConfiguration__c > prodConfig = new List < Apttus_Config2__ProductConfiguration__c > ();
List < Apttus_Config2__LineItem__c > lineItem = new List < Apttus_Config2__LineItem__c > ();
List < Apttus_Config2__LineItem__c > updateLineItem = new List < Apttus_Config2__LineItem__c > ();

public static PS_ApttusCPQWebServiceCalls acpq = new PS_ApttusCPQWebServiceCalls();
public static Apttus_Config2__ProductConfiguration__c configRecord;
public static List<Pre_Approved_Custom_Products__c> productsList = new List<Pre_Approved_Custom_Products__c>();


public static Boolean quoteWithMaintenance_SSP_SRS;
public static Id proposalId;
public static boolean isMaintQuote = FALSE;
public static String productDataAsString;
public static String[] csvFileLines;
public static String proposalquoteType;
public static String errorFlag='';
public static Boolean isNFMP = true;


// return the search result of the product
@AuraEnabled
public static List <Pre_Approved_Custom_Products__c> fetchProduct(String searchKeyWord,String ProductConfigId) {

	system.debug('[+] Inside Search');

	List<Pre_Approved_Custom_Products__c> fetchProduct = new List<Pre_Approved_Custom_Products__c>();
	try{
		configRecord = [SELECT Id, NokiaCPQ_Portfolio_From_Quote__c,Apttus_Config2__AccountId__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Maintenance_Type__c,Apttus_QPConfig__Proposald__r.CPQ_SubPortfolio__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Portfolio__c FROM Apttus_Config2__ProductConfiguration__c WHERE ID =:ProductConfigId][0];
		String accountId = configRecord.Apttus_Config2__AccountId__c;
		String maintenanceType = configRecord.Apttus_QPConfig__Proposald__r.NokiaCPQ_Maintenance_Type__c;
		String portfolio = configRecord.NokiaCPQ_Portfolio_From_Quote__c;

		List<String> validPortfolios = Nokia_CPQ_Utility.getPortfolio(configRecord.Apttus_QPConfig__Proposald__r);
		String query = 'SELECT Id,Name,Product_Code__c,Expiration_Date__c,Is_NSP__c,List_Price__c,Maintenance_Beyond_Warranty_Rate__c,Maintenance_Type__c,Maintenance_Under_Warranty_Rate__c,Portfolio__c,SSP_Rate__c,Product_Discount_Rate__c FROM Pre_Approved_Custom_Products__c WHERE Account__c =:accountId AND Maintenance_Type__c =:maintenanceType AND Portfolio__c IN: validPortfolios AND Expiration_Date__c > TODAY AND Product_Code__c LIKE \'%'+String.escapeSingleQuotes(searchKeyWord)+'%\' LIMIT 100';
		fetchProduct = Database.query(query);
	}
	catch(Exception e) {
		system.debug(e);

	}
	return fetchProduct;



}

@AuraEnabled
public static List<Pre_Approved_Custom_Products__c> init (String ProductConfigId) {

	System.debug('[+] Config Id = '+ProductConfigId);
	if(ProductConfigId == null)
		return null;
	configRecord = [SELECT Id, NokiaCPQ_Portfolio_From_Quote__c,Apttus_Config2__AccountId__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Maintenance_Type__c,Apttus_QPConfig__Proposald__r.CPQ_SubPortfolio__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Portfolio__c FROM Apttus_Config2__ProductConfiguration__c WHERE ID =:ProductConfigId][0];

	System.debug('[+] Config Id = '+configRecord.Id);
	List<String> validPortfolios = Nokia_CPQ_Utility.getPortfolio(configRecord.Apttus_QPConfig__Proposald__r);
	productsList = [SELECT Id,Name,Product_Code__c,Expiration_Date__c,Is_NSP__c,List_Price__c,Maintenance_Beyond_Warranty_Rate__c,
	 Maintenance_Type__c,Maintenance_Under_Warranty_Rate__c,Portfolio__c,SSP_Rate__c,Product_Discount_Rate__c
	 FROM Pre_Approved_Custom_Products__c WHERE Account__c =:configRecord.Apttus_Config2__AccountId__c
						 AND Maintenance_Type__c =:configRecord.Apttus_QPConfig__Proposald__r.NokiaCPQ_Maintenance_Type__c
						   AND Portfolio__c IN: validPortfolios AND Expiration_Date__c > TODAY LIMIT 100];
	System.debug('[+] Pre_Approved_Custom_Products__c size = '+productsList.size());

	return productsList;

}


@AuraEnabled
public static String upload (List<Pre_Approved_Custom_Products__c> preApprovedList, String configId) {

	system.debug('preApprovedList.size()  = '+preApprovedList.size());
	system.debug('[+] configid = '+configId );
	configRecord = [SELECT Id,Apttus_QPConfig__Proposald__r.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Is_Maintenance_Quote__c,/*Apttus_QPConfig__Proposald__r.NokiaProductAccreditation__c,*/ Quote_Type__c,NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c,NokiaCPQ_Portfolio_From_Quote__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_LEO_Discount__c,Apttus_Config2__PriceListId__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Existing_IONMaint_Contract__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_No_of_Years__c,Apttus_QPConfig__Proposald__c,Apttus_QPConfig__Proposald__r.Warranty_credit__c,Apttus_QPConfig__Proposald__r.NokiaCPQ_Maintenance_Type__c,Apttus_Config2__AccountId__c,Pricing_Cluster_Search_Filter__c,Apttus_QPConfig__Proposald__r.CPQ_SubPortfolio__c,Apttus_QPConfig__Proposald__r.NokiaCPQPricing_Cluster__c,Apttus_Config2__AccountId__r.Partner_Program__c FROM Apttus_Config2__ProductConfiguration__c WHERE Id=: configId LIMIT 1][0];
	proposalId = configRecord.Apttus_QPConfig__Proposald__c;
	system.debug('proposalId' + proposalId);

	proposalquoteType = configRecord.Quote_Type__c;
	isMaintQuote = configRecord.Apttus_QPConfig__Proposald__r.NokiaCPQ_Is_Maintenance_Quote__c;
	quoteWithMaintenance_SSP_SRS = configRecord.Apttus_QPConfig__Proposald__r.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c;
	string warrantyCredit = configRecord.Apttus_QPConfig__Proposald__r.Warranty_credit__c;


	//Fields to store value from csv file
	String productName,prodCode;
	Boolean isnfm;
	Id preapprovedProductsId;
	Double quantity,listPrice,maintY1,maintY2,sspRate,prodDiscount;
	List<String> productNameList = new List<String>();
	List<String> prodCodeList = new List<String>();
	List<String> csvRecordData = new List<String>();
	List<Double> quantityList = new List<Double>();
	List<Double> listPriceList = new List<Double>();
	List<Double> maintY1List = new List<Double>();
	List<Double> maintY2List = new List<Double>();
	List<Double> sspRateList = new List<Double>();
	List<Boolean> isnfmList = new List<Boolean>();
	List<Double> prodDiscountList = new List<Double>();
	List<Id> preapprovedProducts = new List<Id>();
	List<String> portfolioList = new List<String>();


	for (Integer i = 0; i < preApprovedList.size(); i++) {
		Pre_Approved_Custom_Products__c customProductRecord = preApprovedList[i];

		if (customProductRecord!=null) {

			// Add Parsing Logic Here
			preapprovedProductsId = customProductRecord.Id;
			productName = customProductRecord.Name;
			prodCode = customProductRecord.Product_Code__c;
			//quantity = Double.valueOf(customProductRecord);
			listPrice = Double.valueOf(customProductRecord.List_Price__c);
			prodDiscount = Double.valueOf(customProductRecord.Product_Discount_Rate__c);
			maintY2 = Double.valueOf(customProductRecord.Maintenance_Beyond_Warranty_Rate__c);
			sspRate = Double.valueOf(customProductRecord.SSP_Rate__c);
			isnfm = customProductRecord.Is_NSP__c;
			maintY1 = Double.valueOf(customProductRecord.Maintenance_Under_Warranty_Rate__c);
			system.debug('[+] productName = '+productName);
			system.debug('[+] prodCode = '+prodCode);
			//system.debug('[+] quantity = '+quantity);
			system.debug('[+] listPrice = '+listPrice);
			system.debug('[+] maintY1 = '+maintY1);
			system.debug('[+] maintY2 = '+maintY2);
			system.debug('[+] sspRate = '+sspRate);
			system.debug('[+] isnfm = '+isnfm);
			system.debug('[+] prodDiscount = '+prodDiscount);


			productNameList.add(productName);
			prodCodeList.add(prodCode);
			//quantityList.add(quantity);
			listPriceList.add(listPrice);
			maintY1List.add(maintY1);
			maintY2List.add(maintY2);
			sspRateList.add(sspRate == null ? 0.0 : sspRate);
			isnfmList.add(isnfm);
			prodDiscountList.add(prodDiscount);
			preapprovedProducts.add(preapprovedProductsId);
			portfolioList.add(customProductRecord.Portfolio__c);//FN_Added


		}
	}

	system.debug('[+] init Wrapper  getLineItemValue');
	// Get Line Item Details in the Wrapper Object for Later Use
	SearchProductWrapper vWrapper = new SearchProductWrapper();
	//vWrapper=getLineItemValue(configRecord,configId);//FN-commented

	Map<String,SearchProductWrapper> mapsubPortfolioWithWrapper = new Map<String,SearchProductWrapper>();//FN-Added
	mapsubPortfolioWithWrapper = CPQ_CustomProductUploadHelper.getLineItemValue(configRecord,configId,portfolioList);//FN-Added
	if(!mapsubPortfolioWithWrapper.isEmpty())
	vWrapper = mapsubPortfolioWithWrapper.values()[0];//FN-Modified


	system.debug('[+] Done Wrapper  getLineItemValue');
	system.debug(vWrapper);

	system.debug('[+] before  SelectedProductDO loop 288');
	List<string> erroredProds = new List<string>();
	// Add Line Item Data to Cart , using data from csv file
	if (!productNameList.isEmpty()) {
		system.debug('[+] inside  SelectedProductDO loop 294');
		Integer i=0;

		for (String pname:productNameList) {
			try {

	// Initialize the Line Item Web API record, to be used for inserting into the cart.
	Apttus_CPQApi.CPQ.SelectedProductDO SelectedProductDOInstance = new Apttus_CPQApi.CPQ.SelectedProductDO();
	// Line Item Custom Fields to be used
	List<String> customFields = new List<String>();
	customFields.add('Custom_Product_Name__c');
	customFields.add('Custom_Product_Code__c');
	customFields.add('NokiaCPQAccreditationType__c');
	customFields.add('Nokia_CPQ_Maint_Prod_Cat_Disc__c');
	customFields.add('Nokia_Maint_Y1_Per__c');
	customFields.add('Nokia_Maint_Y2_Per__c');
	customFields.add('NokiaCPQ_Maint_Y1_List_Price__c');
	customFields.add('NokiaCPQ_Maint_Yr1_Base_Price__c');
	customFields.add('NokiaCPQ_Maint_Yr1_Extended_Price__c');
	customFields.add('Nokia_Maint_Y1_Extended_List_Price__c');
	customFields.add('NokiaCPQ_Maint_Yr2_List_Price__c');
	customFields.add('NokiaCPQ_Maint_Yr2_Extended_Price__c');
	customFields.add('NokiaCPQ_Maint_Yr2_Extended_List_Price__c');
	customFields.add('NokiaCPQ_Maint_Yr2_Base_Price__c');
	customFields.add('NokiaCPQ_IncotermNew__c');
	customFields.add('is_Custom_Product__c');
	customFields.add('NokiaCPQ_SSP_Rate__c');
	customFields.add('Nokia_SSP_List_Price__c');
	customFields.add('Nokia_SSP_Base_Price__c');
	customFields.add('Nokia_SSP_Base_Extended_Price__c');
	customFields.add('NokiaCPQ_SRS_Rate__c');
	customFields.add('Nokia_SRS_List_Price__c');
	customFields.add('Nokia_SRS_Base_Price__c');
	customFields.add('Nokia_SRS_Base_Extended_Price__c');
	customFields.add('Source__c');
	customFields.add('CustomProductValue__c');
	customFields.add('IsNFMP_Custom_Product__c');
	customFields.add('Pre_Approved_Custom_Product__c');


	customFields.add('Apttus_Config2__ListPrice__c');
	customFields.add('NokiaCPQ_Unitary_IRP__c');
	customFields.add('NokiaCPQ_CNP_High__c');
	customFields.add('NokiaCPQ_Light_Color__c');
	customFields.add('NokiaCPQ_Alias__c');
	customFields.add('CPQ_ProductPortfolio__c'); //FN-added
	customFields.add('CPQ_MaintenancePortfolio__c');//FN-added


	//  Assign Custom Fields to the SelectedProduct Instance record
	SelectedProductDOInstance.CustomFields = customFields;

	Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c();

	// Assign Values to Standard and Custom fields
	SelectedProductDOInstance.ProductId = vWrapper.strProductID;
	SelectedProductDOInstance.Quantity = 1;
	CustomData.Custom_Product_Name__c = pname;
	CustomData.Custom_Product_Code__c =  prodCodeList[i];
	CustomData.Apttus_Config2__Description__c =  pname;
	CustomData.Apttus_Config2__LineNumber__c = vWrapper.iLineNumber+1+i;
	CustomData.Apttus_Config2__PrimaryLineNumber__c = vWrapper.iPrimaryLineNumber+1+i;
	CustomData.Apttus_Config2__ItemSequence__c = vWrapper.iItemSequence+1+i;
	//CustomData.NokiaCPQAccreditationType__c = vWrapper.strPricingAccred;//FN-commented
	CustomData.NokiaCPQAccreditationType__c = mapsubPortfolioWithWrapper.get(portfolioList[i]).strPricingAccred;//FN-Added
	CustomData.Apttus_Config2__ConfigurationId__c = configId;
	CustomData.Apttus_Config2__LineType__c = 'Product/Service';
	CustomData.Apttus_Config2__ListPrice__c =  listPriceList[i];

	CustomData.NokiaCPQ_SRS_Rate__c = 0;
	CustomData.Nokia_SRS_List_Price__c = 0;
	CustomData.Nokia_SRS_Base_Extended_Price__c = 0;
	CustomData.Nokia_SRS_Base_Price__c = 0;
	CustomData.Nokia_SSP_List_Price__c = 0;
	CustomData.Nokia_SSP_Base_Price__c = 0;
	CustomData.Nokia_SSP_Base_Extended_Price__c = 0;

	//Added condition for maintenance check here by christie
	if(proposalquoteType != 'Direct CPQ' ) { //ITCCPQ-464 Christie : Added AND condition for maintenance check // ITCCPQ 3048-3045
		CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c = prodDiscountList[i];
	}
	//Added condition based on new additions for 464 by christie
	if((proposalquoteType == 'Direct CPQ' || isMaintQuote == true)&&(prodDiscountList[i]!=null)) { //ITCCPQ-464 Christie : Added OR condition
		errorFlag = 'Product Discount % has been ignored as it is not applicable for this quote type.';
	}

	if(proposalquoteType == 'Direct CPQ') {
		CustomData.NokiaCPQ_Unitary_IRP__c =  CustomData.Apttus_Config2__ListPrice__c;
		CustomData.NokiaCPQ_CNP_High__c= CustomData.Apttus_Config2__ListPrice__c;
		CustomData.NokiaCPQ_Alias__c = CustomData.Custom_Product_Name__c;
		CustomData.NokiaCPQ_Light_Color__c = 'RED';

		if(isnfmList[i] == false && quoteWithMaintenance_SSP_SRS==true) {//ITCEPP:789:Bibhu:Modified Code
			CustomData.NokiaCPQ_SSP_Rate__c = sspRateList[i];
		}else{
			CustomData.NokiaCPQ_SRS_Rate__c = vWrapper.dSRSPercentage;//sspRateList[i];
		}
	}// added by surinder=>else part for alias for partners
	else{
		if(proposalquoteType == 'InDirect CPQ') {
			CustomData.NokiaCPQ_Alias__c = CustomData.Custom_Product_Name__c;
		}
	}


	if((quoteWithMaintenance_SSP_SRS==true && proposalquoteType == 'Direct CPQ')||(proposalquoteType == 'Indirect CPQ' && /*ITCCPQ-1823*/ !(isMaintQuote && warrantyCredit != null && warrantyCredit.equalsIgnoreCase(Nokia_CPQ_Constants.Nokia_NO)) /*ITCCPQ-1823*/))//ITCEPP:789:Bibhu:Modified Code
	{
		CustomData.Nokia_Maint_Y1_Per__c = maintY1List[i];

	}

	if(CustomData.Nokia_Maint_Y1_Per__c!=null) {
		CustomData.NokiaCPQ_Maint_Y1_List_Price__c = (CustomData.Apttus_Config2__ListPrice__c * CustomData.Nokia_Maint_Y1_Per__c) /100;
		CustomData.NokiaCPQ_Maint_Yr1_Base_Price__c = CustomData.NokiaCPQ_Maint_Y1_List_Price__c;
		CustomData.NokiaCPQ_Maint_Yr1_Extended_Price__c = ((CustomData.Apttus_Config2__ListPrice__c * SelectedProductDOInstance.Quantity)* CustomData.Nokia_Maint_Y1_Per__c) /100;
		CustomData.Nokia_Maint_Y1_Extended_List_Price__c = CustomData.NokiaCPQ_Maint_Yr1_Extended_Price__c;
	}

	CustomData.Apttus_Config2__BasePriceMethod__c = 'Per Unit';

	if(vWrapper.str1Year == '1' && proposalquoteType == 'Indirect CPQ')
		CustomData.Nokia_Maint_Y2_Per__c = 0.0;
	else if((quoteWithMaintenance_SSP_SRS==true && proposalquoteType == 'Direct CPQ')||(proposalquoteType == 'Indirect CPQ'))
		CustomData.Nokia_Maint_Y2_Per__c = maintY2List[i];


	if(CustomData.Nokia_Maint_Y2_Per__c!=null) {
		CustomData.NokiaCPQ_Maint_Yr2_List_Price__c = (CustomData.Apttus_Config2__ListPrice__c * CustomData.Nokia_Maint_Y2_Per__c)/100;
		CustomData.NokiaCPQ_Maint_Yr2_Extended_Price__c = ((CustomData.Apttus_Config2__ListPrice__c * SelectedProductDOInstance.Quantity) * CustomData.Nokia_Maint_Y2_Per__c)/100;
		CustomData.NokiaCPQ_Maint_Yr2_Extended_List_Price__c = CustomData.NokiaCPQ_Maint_Yr2_Extended_Price__c;
		CustomData.NokiaCPQ_Maint_Yr2_Base_Price__c = CustomData.NokiaCPQ_Maint_Yr2_List_Price__c;
	}

	Decimal strAccredDiscount = mapsubPortfolioWithWrapper.get(portfolioList[i]).strAccredDiscount;//FN-Added

	if(CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c == null && strAccredDiscount==null) //FN-Modified
		CustomData.Apttus_Config2__BasePrice__c = CustomData.Apttus_Config2__ListPrice__c;
	else if(CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c != null && strAccredDiscount==null) //FN-Modified
		CustomData.Apttus_Config2__BasePrice__c = CustomData.Apttus_Config2__ListPrice__c- (CustomData.Apttus_Config2__ListPrice__c * CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c)/100;
	else if(CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c == null && strAccredDiscount!=null) //FN-Modified
		CustomData.Apttus_Config2__BasePrice__c = CustomData.Apttus_Config2__ListPrice__c - (CustomData.Apttus_Config2__ListPrice__c * strAccredDiscount)/100;
	else
	{
		CustomData.Apttus_Config2__BasePrice__c = CustomData.Apttus_Config2__ListPrice__c - (CustomData.Apttus_Config2__ListPrice__c * strAccredDiscount)/100;
		CustomData.Apttus_Config2__BasePrice__c = CustomData.Apttus_Config2__BasePrice__c - (CustomData.Apttus_Config2__BasePrice__c * CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c)/100;
	}
	Decimal iIncotermPercentage = mapsubPortfolioWithWrapper.get(portfolioList[i]).iIncotermPercentage;//FN-Added
	if(iIncotermPercentage!=null) //FN-Modified
		CustomData.Apttus_Config2__BasePrice__c = CustomData.Apttus_Config2__BasePrice__c + (CustomData.Apttus_Config2__BasePrice__c * iIncotermPercentage)/100;


	CustomData.Apttus_Config2__BasePriceOverride__c = CustomData.Apttus_Config2__BasePrice__c;
	CustomData.NokiaCPQ_IncotermNew__c = iIncotermPercentage;
	CustomData.Apttus_Config2__PriceListId__c = vWrapper.strGlobalPriceListID;
	CustomData.Apttus_Config2__PriceListItemId__c = vWrapper.strGlobalPriceListItemID;
	CustomData.Apttus_Config2__BaseExtendedPrice__c = CustomData.Apttus_Config2__BasePrice__c * SelectedProductDOInstance.Quantity;
	CustomData.Apttus_Config2__ExtendedPrice__c = CustomData.Apttus_Config2__BasePrice__c * SelectedProductDOInstance.Quantity;
	CustomData.Apttus_Config2__NetPrice__c = CustomData.Apttus_Config2__BasePrice__c * SelectedProductDOInstance.Quantity;
	CustomData.Apttus_Config2__NetUnitPrice__c = CustomData.Apttus_Config2__BasePrice__c;
	CustomData.Apttus_Config2__PriceUom__c ='Each';
	CustomData.Apttus_Config2__Frequency__c = 'One Time';
	CustomData.Apttus_Config2__Frequency__c = 'One Time';
	CustomData.Apttus_Config2__PricingStatus__c = 'Pending';
	CustomData.is_Custom_Product__c = true;
	CustomData.Apttus_Config2__ConfigStatus__c = 'NA';
	CustomData.Apttus_Config2__IsPrimaryLine__c = true;
	CustomData.Apttus_Config2__ChargeType__c = 'Standard Price';



	if(isnfmList[i] == false) {
		CustomData.IsNFMP_Custom_Product__c = false;
		//SSP Field Population
		system.debug('[+] NokiaCPQ_SSP_Rate__c = ' + sspRateList[i]);
		CustomData.NokiaCPQ_SSP_Rate__c = sspRateList[i];
		if(vWrapper.isLEO== true)
			CustomData.Nokia_SSP_List_Price__c = 0.0;
		else if((quoteWithMaintenance_SSP_SRS==true && proposalquoteType == 'Direct CPQ')||(proposalquoteType == 'Indirect CPQ')) //ITCEPP:789:Bibhu:Modified Code
			CustomData.Nokia_SSP_List_Price__c =  (CustomData.Apttus_Config2__ListPrice__c * sspRateList[i])/100;

		system.debug('[+] Nokia_SSP_List_Price__c = '+CustomData.Nokia_SSP_List_Price__c);
		system.debug('[+] Nokia_CPQ_Maint_Prod_Cat_Disc__c = '+CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c);
		if(CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c!=null && CustomData.Nokia_SSP_List_Price__c!=null)
			CustomData.Nokia_SSP_Base_Price__c =  CustomData.Nokia_SSP_List_Price__c  - (CustomData.Nokia_SSP_List_Price__c * CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c) /100;
		else if(CustomData.Nokia_SSP_List_Price__c!=null) {
			CustomData.Nokia_SSP_Base_Price__c = CustomData.Nokia_SSP_List_Price__c;
		}
		CustomData.Nokia_SSP_Base_Extended_Price__c = CustomData.Nokia_SSP_Base_Price__c * SelectedProductDOInstance.Quantity;
	}

	else if(isnfmList[i] == true) {
		//SRS Field Population
		CustomData.NokiaCPQ_SRS_Rate__c = vWrapper.dSRSPercentage;//sspRateList[i];
					if(vWrapper.dSRSPercentage != null)
		CustomData.Nokia_SRS_List_Price__c =  (CustomData.Apttus_Config2__ListPrice__c * vWrapper.dSRSPercentage);
					
		CustomData.IsNFMP_Custom_Product__c = true;
		system.debug('[+] snfmList[i].toLowerCase() - '+isnfmList[i]);
		system.debug('[+]  CustomData.IsNFMP_Custom_Product__c = '+ CustomData.IsNFMP_Custom_Product__c);

		if(CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c!=null && CustomData.Nokia_SRS_List_Price__c!=null)
			CustomData.Nokia_SRS_Base_Price__c =  CustomData.Nokia_SRS_List_Price__c  - (CustomData.Nokia_SRS_List_Price__c * CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c) /100;
		else if(CustomData.Nokia_SRS_List_Price__c!=null) {
			CustomData.Nokia_SRS_Base_Price__c = CustomData.Nokia_SRS_List_Price__c;
		}
		CustomData.Nokia_SRS_Base_Extended_Price__c = CustomData.Nokia_SRS_Base_Price__c * SelectedProductDOInstance.Quantity;
	}

	CustomData.Apttus_Config2__NetUnitPrice__c = CustomData.Apttus_Config2__BasePrice__c;
	CustomData.Apttus_Config2__ProductVersion__c = 1.0;
	CustomData.Source__c ='Custom Product';
	CustomData.CustomProductValue__c = CustomData.Apttus_Config2__ListPrice__c +';'+CustomData.Apttus_Config2__BasePrice__c +';'+ CustomData.Apttus_Config2__BasePriceOverride__c;

	//Assosciate pre apporved custom products with line item
	CustomData.Pre_Approved_Custom_Product__c = preapprovedProducts[i];
	CustomData.CPQ_ProductPortfolio__c = portfolioList[i];//FN-Added portfolio
	CustomData.CPQ_MaintenancePortfolio__c = portfolioList[i];//FN-Added portfolio

	//  Assosciate Custom Field Values to the API record.
	SelectedProductDOInstance.CustomData = customData;

	selectedProdDOList.add(SelectedProductDOInstance);
	++i;
			} catch (Exception e) {
	system.debug('Exception:Upload product is failing');
	system.debug(e.getMessage());
	system.debug(e.getStackTraceString());
	erroredProds.add(prodCodeList[i]);
	++i;
			}
		}

		system.debug('[+] after SelectedProductDO loop 433');
	}




	// End Parsing of CSV file data


	// Start product addition to cart using Web API

	List < Integer > primaryLines = new List < Integer > ();
	system.debug('[+] Before Loop addProductsfromfile 466');
	if (!selectedProdDOList.isEmpty()) {
		system.debug('[+] inside Loop addProductsfromfile 468');
		Apttus_CPQApi.CPQ.AddMultiProductRequestDO lineItemRecords = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
		lineItemRecords.cartID = configRecord.Id;
		lineItemRecords.SelectedProducts = selectedProdDOList;
		system.debug('[+] assosciated selectedProdDOList to record 472');
		Apttus_CPQApi.CPQ.AddMultiProductResponseDO lineItemRecordsResponse = Apttus_CPQApi.CPQWebService.addMultiProducts(lineItemRecords);
		system.debug('[+] added lines to cart api 474');
		if (isMaintQuote) {
			Apttus_CPQApi.CPQWebService.associateConstraintRules(configRecord.Id, primaryLines);
			Apttus_CPQApi.CPQWebService.applyConstraintRules(configRecord.Id, false);
		}
	}else if(!erroredProds.isEmpty()) {
		throw new AuraHandledException('Below Pre-Approved product(s) could not be added to the cart. Please contact the Administrator:<br/>' + string.join(erroredProds, '<br/>'));
	}
	system.debug('[+] ended addProductsfromfile 482');

	// End product addition to cart using Web API


	//Start Save Cart

	system.debug('Save ..');
	if (configRecord.Id != null) {
		//Req 6383 Start
		//List < Integer > primaryLines = new List < Integer > ();
		system.debug('[+] before  associateConstraintRules 492');
		if (!isMaintQuote) {
			Apttus_CPQApi.CPQWebService.associateConstraintRules(configRecord.Id, primaryLines);
			Apttus_CPQApi.CPQWebService.applyConstraintRules(configRecord.Id, false);
		}
		system.debug('[+] after  associateConstraintRules 492');
		acpq.saveCart(configRecord.Id);
		system.debug('[+] after  savecart 499');
		//Req 6383 End
		ApexPages.Message errorMessage;


		// For rules that are not marked as Check on Finalization
		system.debug('[+] before updateMaintenanceLineItem 508');
		//Req 6383 Start
		if (isMaintQuote) {

			acpq.updateMaintenanceLineItem(configRecord.Id);
		}
		system.debug('[+] after updateMaintenanceLineItem 514');
		//Req 6383 End

	}

	//End Save Cart
	if(!erroredProds.isEmpty()) {
		errorFlag += 'Below Pre-Approved product(s) could not be added to the cart. Please contact the Administrator:<br/>' + string.join(erroredProds, '<br/>');
	}
	return 'Success~'+errorFlag;

	//return null;
}

}