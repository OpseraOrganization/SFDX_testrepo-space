/* --------------------------------------------------------------------------------------------------------------------------------------------------------
	Name:	BulkUploadCustomProducts_Controller
	Description:	 Controller Class for Bulk Upload functionality for Custom Product in Cart .
	Date	Version  Author	 Summary of Changes
	-----------   ----------   -----------------	 ---------------------------------------------------------------------------------------
	15 Apr 2021   1.0   Christie JJ	  ITCCPQ-925 - Pre-Aplha version.
	---------------------------------------------------------------------------------------------------------------------------------------------------------- */
	public with sharing class BulkUploadCustomProducts_Controller {

		static List <Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List <Apttus_CPQApi.CPQ.SelectedProductDO>();
		List <Apttus_Config2__ProductConfiguration__c> prodConfig = new List <Apttus_Config2__ProductConfiguration__c>();
		List <Apttus_Config2__LineItem__c> lineItem = new List <Apttus_Config2__LineItem__c>();
		List <Apttus_Config2__LineItem__c> updateLineItem = new List <Apttus_Config2__LineItem__c>();
		
		public static PS_ApttusCPQWebServiceCalls acpq = new PS_ApttusCPQWebServiceCalls();
		public static Apttus_Config2__ProductConfiguration__c prodConfigRecord;
		
		public static Boolean quoteWithMaintenance_SSP_SRS;
		public static Id proposalId;
		public static boolean isMaintQuote = FALSE;
		public static String productDataAsString;
		public static String[] csvFileLines;
		public static String proposalquoteType;
		public static String errorFlag='false';
		public static Boolean isNFMP = true;

		public static String subPortfolLabels;
		@AuraEnabled
		public static String getDocumentId (String quoteId) {
			/**FN START*******/

			List<Apttus_Proposal__Proposal__c> quoteProplst = [SELECT Id,CPQ_SubPortfolio__c,Quote_Type__c FROM Apttus_Proposal__Proposal__c where Id =: quoteId LIMIT 1];
			
			List<Document> templateDocument;
			if(!test.isRunningTest() && !quoteProplst.isEmpty()) {
	if(quoteProplst[0].CPQ_SubPortfolio__c != null && quoteProplst[0].Quote_Type__c == 'Indirect CPQ')
		templateDocument = [SELECT Id FROM Document where DeveloperName = 'Custom_Product_Bulk_Upload_FN' LIMIT 1];
	else
		templateDocument = [SELECT Id FROM Document where DeveloperName = 'Custom_Product_Upload_CSV_Template' LIMIT 1];
			}/**FN END*******/
			else {
	templateDocument = [SELECT Id FROM Document where DeveloperName = 'Custom_Product_Upload_CSV_TemplateTest' LIMIT 1];
			}
			if(!templateDocument.isEmpty())
	return templateDocument[0].Id;
			return null;
		}
		
		/**FN START*******/
		@AuraEnabled
		public static String getSubPortfolio (String quoteId) {		
			
			
			List<Apttus_Proposal__Proposal__c> quoteProplst= [SELECT Id,toLabel(CPQ_SubPortfolio__c)subportfolioLabels,Quote_Type__c FROM Apttus_Proposal__Proposal__c where Id =: quoteId AND CPQ_SubPortfolio__c != null AND Quote_Type__c = 'Indirect CPQ' LIMIT 1];
			
			if(!quoteProplst.isEmpty()){	
	subPortfolLabels = (string)quoteProplst[0].get('subportfolioLabels');
	return subPortfolLabels;
			}	
			
			return null;
		}/**FN END*******/
		
		
		@AuraEnabled
		public static String init (String configId,String filename,String filebody) {
		
			System.debug('[+] configid = '+configId );
			prodConfigRecord = CPQ_CustomProductUploadHelper.getProductConfig(configId);

			proposalId = prodConfigRecord.Apttus_QPConfig__Proposald__c;
			System.debug('proposalId' + proposalId);
		
			/**FN START*******/
			//it can have portfolio api value or subportfolio picklist labels
			List<String> validPortfolios = CPQ_CustomProductUploadHelper.getSubportfolioLabels(configId);
			system.debug('validPortfolios>>'+validPortfolios);			

			Boolean hasSubportfolio = prodConfigRecord.Apttus_QPConfig__Proposald__r.CPQ_SubPortfolio__c != null ? true:false;
			
			/**FN END*******/ 
		
			proposalquoteType = prodConfigRecord.Quote_Type__c;
			isMaintQuote = prodConfigRecord.Apttus_QPConfig__Proposald__r.NokiaCPQ_Is_Maintenance_Quote__c;
			quoteWithMaintenance_SSP_SRS = prodConfigRecord.Apttus_QPConfig__Proposald__r.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c;
			string warrantyCredit = prodConfigRecord.Apttus_QPConfig__Proposald__r.Warranty_credit__c;
		
		
		
			// Base64 decode the file content payload
			String decodedFileBody = EncodingUtil.base64Decode(filebody).toString();
		
			// Start Parsing of CSV file data
		
		
			//Fields to store value from csv file
			String productName,prodCode,isnfm;
			Double quantity,listPrice,maintY1,maintY2,sspRate,prodDiscount;
			List<String> productNameList = new List<String>();
			List<String> prodCodeList = new List<String>();
			List<String> csvRecordData = new List<String>();
			List<Double> quantityList = new List<Double>();
			List<Double> listPriceList = new List<Double>();
			List<Double> maintY1List = new List<Double>();
			List<Double> maintY2List = new List<Double>();
			List<Double> sspRateList = new List<Double>();
			List<String> isnfmList = new List<String>();
			List<Double> prodDiscountList = new List<Double>();
			List<String> portfolioList = new List<String>();
		
		
			system.debug('[+] readCSVFile::::');
			system.debug(filebody);
			system.debug('configid = ');
			system.debug(prodConfigRecord);
			productDataAsString = decodedFileBody;
			if (productDataAsString.contains(';')) {
	productDataAsString = productDataAsString.replaceAll(';', ',');
			}
		
			csvFileLines = productDataAsString.split('\n');
		
			system.debug('CsvFileLinesSize = ' + csvFileLines.size());
			string errorMessageProductNames = '';
			string errorMessagePortfolio = '';
			//ITCCPQ-1986 - START
			Boolean isDirectQuoteWithoutMaint = proposalquoteType == 'Direct CPQ' && !quoteWithMaintenance_SSP_SRS;
			//ITCCPQ-1986 - End
			Map<string,string>  mapPickListAPIValues = new Map<string,string>();
			for (Integer i = 1; i < csvFileLines.size(); i++) {
	csvRecordData = csvFileLines[i].split(',');
	System.debug('csvRecordData>>'+csvRecordData);
		
	if (!String.isBlank(csvRecordData[0]) && !String.isBlank(csvRecordData[1])) {
		
		
		if(String.isBlank(csvRecordData[0]))
			return 'Error~The Cell A'+String.valueOf(i+1)+' in the uploaded csv file is empty!';
		if(String.isBlank(csvRecordData[1]))
			return 'Error~The Cell B'+String.valueOf(i+1)+' in the uploaded csv file is empty!';
		if(String.isBlank(csvRecordData[2]))
			return 'Error~The Cell C'+String.valueOf(i+1)+' in the uploaded csv file is empty!';
		if(String.isBlank(csvRecordData[3]))
			return 'Error~The Cell D'+String.valueOf(i+1)+' in the uploaded csv file is empty!';
		if(String.isBlank(csvRecordData[4])) {
			if(proposalquoteType == 'Direct CPQ')
	csvRecordData[4] = '0';
			else
	return 'Error~The Cell E'+String.valueOf(i+1)+' in the uploaded csv file is empty!';
		
		}
		if(String.isBlank(csvRecordData[5])) {
			if(isDirectQuoteWithoutMaint)
	csvRecordData[5] = '0';
			else
	return 'Error~The Cell F'+String.valueOf(i+1)+' in the uploaded csv file is empty!';
		}
		if(String.isBlank(csvRecordData[6])) {
			if(isDirectQuoteWithoutMaint)
	csvRecordData[6] = '0';
			else
	return 'Error~The Cell G'+String.valueOf(i+1)+' in the uploaded csv file is empty!';
		}
		if(String.isBlank(csvRecordData[7])) {
			if(isDirectQuoteWithoutMaint)
	csvRecordData[7] = '0';
			else
	return 'Error~The Cell H'+String.valueOf(i+1)+' in the uploaded csv file is empty!';
		}
		
		if(String.isBlank(csvRecordData[8])) {
			if(isDirectQuoteWithoutMaint)
	csvRecordData[8] = 'No';
			else
	return 'Error~The Cell I'+String.valueOf(i+1)+' in the uploaded csv file is empty!';
		}
		
		// Add Parsing Logic Here
		productName = csvRecordData[0];
		prodCode = csvRecordData[1];
		try{
			quantity = Double.valueOf(csvRecordData[2]);
			listPrice = Double.valueOf(csvRecordData[3]);
			prodDiscount = Double.valueOf(csvRecordData[4]);
			
			maintY2 = Double.valueOf(csvRecordData[6]);
			sspRate = Double.valueOf(csvRecordData[7]);
			maintY1 = Double.valueOf(csvRecordData[5]);
		}catch(Exception ex) {
			ExceptionHandler.addException(ex,BulkUploadCustomProducts_Controller.class.getName(),'init');
			errorMessageProductNames += productName + ',';
			
			continue;
		}
		isnfm = csvRecordData[8].trim();
		if(String.isNotBlank(isnfm) && (!isnfm.equalsIgnoreCase('yes') && !isnfm.equalsIgnoreCase('no'))) {
			errorMessageProductNames += productName + ',';
			continue;
		}
		/**FN START*******/
		//For FN-Indirect
		if(csvRecordData.size() > 9 && hasSubportfolio){
			if(string.isBlank(csvRecordData[9].trim()))
	return 'Error~The Accreditation Solution'+String.valueOf(i+1)+' in the uploaded csv file is empty!';
			else{
			portfolioList.add(csvRecordData[9].trim());
			/***/ 
	if(!validPortfolios.contains(csvRecordData[9].trim())){
		errorMessagePortfolio += 'Line '+String.valueOf(i+1)+': '+prodCode+'<br/>';			
	}
			}	
		}
		//for Direct
		else if(!hasSubportfolio ){
			string quotePortfolio = prodConfigRecord.Apttus_QPConfig__Proposald__r.NokiaCPQ_Portfolio__c;
			portfolioList.add(quotePortfolio);
			mapPickListAPIValues.put(quotePortfolio,quotePortfolio);
		}
		/**FN END*******/

		System.debug('[+] productName = '+productName);
		System.debug('[+] prodCode = '+prodCode);
		System.debug('[+] quantity = '+quantity);
		System.debug('[+] listPrice = '+listPrice);
		System.debug('[+] maintY1 = '+maintY1);
		System.debug('[+] maintY2 = '+maintY2);
		System.debug('[+] sspRate = '+sspRate);
		System.debug('[+] isnfm = '+isnfm);
		System.debug('[+] prodDiscount = '+prodDiscount);
		
		
		
		productNameList.add(productName);
		prodCodeList.add(prodCode.trim());
		quantityList.add(quantity);
		listPriceList.add(listPrice);
		maintY1List.add(maintY1);
		maintY2List.add(maintY2);
		sspRateList.add(sspRate);
		isnfmList.add(isnfm);
		prodDiscountList.add(prodDiscount);
		
		
		
		
	}
			}
			system.debug('portfolioList>>'+portfolioList);
			

			if(!portfolioList.isEmpty() && hasSubportfolio){ //mappicklistAPI already populated above in else - will it replace confirm?
			mapPickListAPIValues = Nokia_CPQ_Utility.getPicklistValuesByLabel('Apttus_Proposal__Proposal__c','CPQ_SubPortfolio__c',portfolioList);
			}
			system.debug('mapPickListAPIValues>>'+mapPickListAPIValues);
			

			if(String.isNotBlank(errorMessageProductNames)) {
	errorMessageProductNames = errorMessageProductNames.substring(0, errorMessageProductNames.length() - 1);
	return 'Error~File Upload Failed: The following products contain invalid data: ' + errorMessageProductNames + '. Please correct the issues and re-upload the file.';
			}
			if(String.isNotBlank(errorMessagePortfolio)) {
	errorMessagePortfolio = errorMessagePortfolio.substring(0, errorMessagePortfolio.length() - 1);
	return 'Error~File Upload Failed: Please provide or correct the Accredited Solutions for the following:<br/>'+ errorMessagePortfolio+'<br/>';
			}			
			System.debug('[+] init Wrapper  getLineItemValue');
			// Get Line Item Details in the Wrapper Object for Later Use
			SearchProductWrapper vWrapper = new SearchProductWrapper();//FN-commented
			//vWrapper=getLineItemValue(prodConfigRecord,configId,portfolioList);//FN-commented
			
			Map<String,SearchProductWrapper> mapsubPortfolioWithWrapper = new Map<String,SearchProductWrapper>();//FN-Added
			
			if(!mapPickListAPIValues.isEmpty()) 
			mapsubPortfolioWithWrapper = CPQ_CustomProductUploadHelper.getLineItemValue(prodConfigRecord,configId,mapPickListAPIValues.values());//FN-Added
			else
			mapsubPortfolioWithWrapper = CPQ_CustomProductUploadHelper.getLineItemValue(prodConfigRecord,configId,portfolioList);

			if(!mapsubPortfolioWithWrapper.isEmpty()){
	vWrapper = mapsubPortfolioWithWrapper.values()[0];//FN-Modified
			}
			
			System.debug('[+] Done Wrapper  getLineItemValue');
			System.debug(vWrapper);
		
			System.debug('[+]  	ctDO loop 288');
			List<string> catalogProdList = new List<string>();
			List<string> papList = new List<string>();
			//ITCCPQ-2542 - START
			List<string> defaultProdList = new List<string>();
			//ITCCPQ-2542 - END
			try {
		
	// Add Line Item Data to Cart , using data from csv file
	if (!productNameList.isEmpty()) {
		System.debug('[+] inside  SelectedProductDO loop 294');
		Integer i=0;
		Map<string,string> mProdCheck = Nokia_CPQ_Utility.prodAvailabilityCheck(prodCodeList, prodConfigRecord);
		System.debug('mProdCheck-->' + mProdCheck);
		for (String pname:productNameList) {
			string pCode = prodCodeList[i];
			if(pCode!= null && !mProdCheck.isEmpty() && mProdCheck.containsKey(pCode) && string.isNotEmpty(mProdCheck.get(pCode))) {
	if(mProdCheck.get(pCode).equalsIgnoreCase('Available as Pre-Approved')) {
		papList.add(pCode);
	} else if(mProdCheck.get(pCode).equalsIgnoreCase('Defaultly Available')) {
		defaultProdList.add(pCode);
	} else{
		catalogProdList.add(pCode);
	}
	i++;
	continue;
			}
			//if available in catalog , add it to list and continue
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
		
			//Added fix for ITCCPQ-1780 by Christie JJ
			//Start
			customFields.add('Apttus_Config2__ListPrice__c');
			customFields.add('NokiaCPQ_Unitary_IRP__c');
			customFields.add('NokiaCPQ_CNP_High__c');
			customFields.add('NokiaCPQ_Light_Color__c');
			customFields.add('NokiaCPQ_Alias__c');
			customFields.add('CPQ_ProductPortfolio__c'); //FN-added
			customFields.add('CPQ_MaintenancePortfolio__c');//FN-added
			//End
		
		
			//  Assign Custom Fields to the SelectedProduct Instance record
			SelectedProductDOInstance.CustomFields = customFields;
		
			Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c();
		
			// Assign Values to Standard and Custom fields
			SelectedProductDOInstance.ProductId = vWrapper.strProductID;
			SelectedProductDOInstance.Quantity = quantityList[i];
			CustomData.Custom_Product_Name__c = pname;
			CustomData.Custom_Product_Code__c =  pCode;
			CustomData.Apttus_Config2__Description__c =  pname;
			CustomData.Apttus_Config2__LineNumber__c = vWrapper.iLineNumber+1+i;
			
			CustomData.Apttus_Config2__PrimaryLineNumber__c = vWrapper.iPrimaryLineNumber+1+i;
			
			CustomData.Apttus_Config2__ItemSequence__c = vWrapper.iItemSequence+1+i;
			
			//CustomData.NokiaCPQAccreditationType__c = vWrapper.strPricingAccred;
			

			
			//CustomData.NokiaCPQAccreditationType__c = mapsubPortfolioWithWrapper.get(portfolioList[i]).strPricingAccred;//FN-Added
			CustomData.NokiaCPQAccreditationType__c = mapsubPortfolioWithWrapper.get(mapPickListAPIValues.get(portfolioList[i]) ).strPricingAccred;//FN-Added			
			
			
			
			
			CustomData.Apttus_Config2__ConfigurationId__c = configId;
			CustomData.Apttus_Config2__LineType__c = 'Product/Service';
			CustomData.Apttus_Config2__ListPrice__c =  listPriceList[i];
			//ITCCPQ-1782 starts
			CustomData.NokiaCPQ_SRS_Rate__c = 0;
			CustomData.Nokia_SRS_List_Price__c = 0;
			CustomData.Nokia_SRS_Base_Extended_Price__c = 0;
			CustomData.Nokia_SRS_Base_Price__c = 0;
			CustomData.Nokia_SSP_List_Price__c = 0;
			CustomData.Nokia_SSP_Base_Price__c = 0;
			CustomData.Nokia_SSP_Base_Extended_Price__c = 0;
			//ITCCPQ-1782 ends
			/*ITCCPQ-1987 Yashdeep*/
			CustomData.Nokia_Maint_Y1_Per__c = 0;
			CustomData.Nokia_Maint_Y2_Per__c = 0;
		
		
			//Added condition for maintenance check here by christie
			//removed isMaintQuote != true ITCCPQ-3045,3048
			if(proposalquoteType != 'Direct CPQ' ) {				 //ITCCPQ-464 Christie : Added AND condition for maintenance check 
	CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c = prodDiscountList[i];
			}
			//Added condition based on new additions for 464 by christie
			if((proposalquoteType == 'Direct CPQ' || isMaintQuote == true)&&(prodDiscountList[i]!=null)) {	 //ITCCPQ-464 Christie : Added OR condition
	errorFlag = 'true';
			}
		
			if(proposalquoteType == 'Direct CPQ') {
	CustomData.NokiaCPQ_Unitary_IRP__c =  CustomData.Apttus_Config2__ListPrice__c;
	CustomData.NokiaCPQ_CNP_High__c= CustomData.Apttus_Config2__ListPrice__c;
	CustomData.NokiaCPQ_Alias__c = CustomData.Custom_Product_Name__c;
	CustomData.NokiaCPQ_Light_Color__c = 'RED';
		
	if(isnfmList[i].toLowerCase().contains('no') && quoteWithMaintenance_SSP_SRS==true) {	//ITCEPP:789:Bibhu:Modified Code
		CustomData.NokiaCPQ_SSP_Rate__c = sspRateList[i];
	}else{
		CustomData.NokiaCPQ_SRS_Rate__c = vWrapper.dSRSPercentage;	//sspRateList[i];
	}
			}else{	  // added by surinder => for partners
	if(proposalquoteType == 'Indirect CPQ') {
		CustomData.NokiaCPQ_Alias__c = CustomData.Custom_Product_Name__c;
	}
		
			}
		
		
			if((quoteWithMaintenance_SSP_SRS==true && proposalquoteType == 'Direct CPQ')||(proposalquoteType == 'Indirect CPQ' &&/*ITCCPQ-1823*/ !(isMaintQuote && warrantyCredit != null && warrantyCredit.equalsIgnoreCase(Nokia_CPQ_Constants.Nokia_NO)) /*ITCCPQ-1823*/))	//ITCEPP:789:Bibhu:Modified Code
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
		
			Decimal strAccredDiscount = mapsubPortfolioWithWrapper.get( mapPickListAPIValues.get(portfolioList[i]) ).strAccredDiscount;//FN-Added
		
			if(CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c == null && strAccredDiscount==null)//FN-Modified
	CustomData.Apttus_Config2__BasePrice__c = CustomData.Apttus_Config2__ListPrice__c;
			else if(CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c != null && strAccredDiscount==null)//FN-Modified
	CustomData.Apttus_Config2__BasePrice__c = CustomData.Apttus_Config2__ListPrice__c- (CustomData.Apttus_Config2__ListPrice__c * CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c)/100;
			else if(CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c == null && strAccredDiscount!=null)//FN-Modified
	CustomData.Apttus_Config2__BasePrice__c = CustomData.Apttus_Config2__ListPrice__c - (CustomData.Apttus_Config2__ListPrice__c * strAccredDiscount)/100;//FN-Modified
			else
			{
	CustomData.Apttus_Config2__BasePrice__c = CustomData.Apttus_Config2__ListPrice__c - (CustomData.Apttus_Config2__ListPrice__c * strAccredDiscount)/100;//FN-Modified
	CustomData.Apttus_Config2__BasePrice__c = CustomData.Apttus_Config2__BasePrice__c - (CustomData.Apttus_Config2__BasePrice__c * CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c)/100;
			}
		
			Decimal iIncotermPercentage = mapsubPortfolioWithWrapper.get( mapPickListAPIValues.get(portfolioList[i]) ).iIncotermPercentage;//FN-Added
			if(iIncotermPercentage!=null)
	CustomData.Apttus_Config2__BasePrice__c = CustomData.Apttus_Config2__BasePrice__c + (CustomData.Apttus_Config2__BasePrice__c * iIncotermPercentage)/100;//FN-Modified
		
			CustomData.Apttus_Config2__BasePriceOverride__c = CustomData.Apttus_Config2__BasePrice__c;
			CustomData.NokiaCPQ_IncotermNew__c = iIncotermPercentage;//FN-Modified
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
		
		
			CustomData.IsNFMP_Custom_Product__c = false;	/*ITCCPQ-1987 Yashdeep*/
			if(isnfmList[i].toLowerCase( ).contains('no')) {
	//SSP Field Population
	System.debug('[+] NokiaCPQ_SSP_Rate__c = ' + sspRateList[i]);
	CustomData.NokiaCPQ_SSP_Rate__c = sspRateList[i];
	if(vWrapper.isLEO== true)
		CustomData.Nokia_SSP_List_Price__c = 0.0;
	else if((quoteWithMaintenance_SSP_SRS==true && proposalquoteType == 'Direct CPQ')||(proposalquoteType == 'Indirect CPQ'))	 //ITCEPP:789:Bibhu:Modified Code
		CustomData.Nokia_SSP_List_Price__c =  (CustomData.Apttus_Config2__ListPrice__c * sspRateList[i])/100;
		
	System.debug('[+] Nokia_SSP_List_Price__c = '+CustomData.Nokia_SSP_List_Price__c);
	System.debug('[+] Nokia_CPQ_Maint_Prod_Cat_Disc__c = '+CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c);
	if(CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c!=null && CustomData.Nokia_SSP_List_Price__c!=null)
		CustomData.Nokia_SSP_Base_Price__c =  CustomData.Nokia_SSP_List_Price__c  - (CustomData.Nokia_SSP_List_Price__c * CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c) /100;
	else if(CustomData.Nokia_SSP_List_Price__c!=null) {
		CustomData.Nokia_SSP_Base_Price__c = CustomData.Nokia_SSP_List_Price__c;
	}
	CustomData.Nokia_SSP_Base_Extended_Price__c = CustomData.Nokia_SSP_Base_Price__c * SelectedProductDOInstance.Quantity;	//ITCCPQ-1778
			}
		
			else if(isnfmList[i].toLowerCase().contains('yes') && /*ITCCPQ-1987 start Yashdeep*/ ((quoteWithMaintenance_SSP_SRS && proposalquoteType == 'Direct CPQ')||(proposalquoteType == 'Indirect CPQ')) /*ITCCPQ-1987 end Yashdeep*/) {
	//SRS Field Population
	CustomData.NokiaCPQ_SRS_Rate__c = vWrapper.dSRSPercentage;	//sspRateList[i];
	if(vWrapper.dSRSPercentage != null)
	CustomData.Nokia_SRS_List_Price__c =  (CustomData.Apttus_Config2__ListPrice__c * vWrapper.dSRSPercentage);
	CustomData.IsNFMP_Custom_Product__c = true;
	System.debug('[+] snfmList[i].toLowerCase() - '+isnfmList[i].toLowerCase());
	System.debug('[+]  CustomData.IsNFMP_Custom_Product__c = '+ CustomData.IsNFMP_Custom_Product__c);
		
	if(CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c!=null && CustomData.Nokia_SRS_List_Price__c!=null)
		CustomData.Nokia_SRS_Base_Price__c =  CustomData.Nokia_SRS_List_Price__c  - (CustomData.Nokia_SRS_List_Price__c * CustomData.Nokia_CPQ_Maint_Prod_Cat_Disc__c) /100;
	else if(CustomData.Nokia_SRS_List_Price__c!=null) {
		CustomData.Nokia_SRS_Base_Price__c = CustomData.Nokia_SRS_List_Price__c;
	}
	CustomData.Nokia_SRS_Base_Extended_Price__c = CustomData.Nokia_SRS_Base_Price__c * SelectedProductDOInstance.Quantity;	//ITCCPQ-1778
			}
		
			CustomData.Apttus_Config2__NetUnitPrice__c = CustomData.Apttus_Config2__BasePrice__c;
			CustomData.Apttus_Config2__ProductVersion__c = 1.0;
			CustomData.Source__c ='Custom Product';
			CustomData.CustomProductValue__c = CustomData.Apttus_Config2__ListPrice__c +';'+CustomData.Apttus_Config2__BasePrice__c +';'+ CustomData.Apttus_Config2__BasePriceOverride__c;
			
			CustomData.CPQ_ProductPortfolio__c = mapPickListAPIValues.get(portfolioList[i]) ;//FN-Added portfolio
			CustomData.CPQ_MaintenancePortfolio__c = mapPickListAPIValues.get(portfolioList[i]);//FN-Added portfolio
		
			System.debug(i+'-->CustomData-->'+CustomData);
		
			//  Assosciate Custom Field Values to the API record.
			SelectedProductDOInstance.CustomData = customData;
		
			selectedProdDOList.add(SelectedProductDOInstance);
			++i;
		}
		System.debug(selectedProdDOList.size()+'-->mapsubPortfolioWithAccredDiscount-->'+selectedProdDOList);
		
		System.debug('[+] after SelectedProductDO loop 433');
	}
		
		
			} catch (Exception e) {
	system.debug('Upload product is failing');
	system.debug(e.getMessage());
	system.debug(e.getStackTraceString());
	ExceptionHandler.addException(e,BulkUploadCustomProducts_Controller.class.getName(),'init');
			}
		
			// End Parsing of CSV file data
		
		
			// Start product addition to cart using Web API
		
			List < Integer > primaryLines = new List < Integer > ();
			system.debug('[+] Before Loop addProductsfromfile 466');
			if (!selectedProdDOList.isEmpty()) {
	system.debug('[+] inside Loop addProductsfromfile 468');
	Apttus_CPQApi.CPQ.AddMultiProductRequestDO lineItemRecords = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
	lineItemRecords.cartID = prodConfigRecord.Id;
	lineItemRecords.SelectedProducts = selectedProdDOList;
	system.debug('[+] assosciated selectedProdDOList to record 472');
	Apttus_CPQApi.CPQWebService.addMultiProducts(lineItemRecords);
	system.debug('[+] added lines to cart api 474');
	if (isMaintQuote) {
		Apttus_CPQApi.CPQWebService.associateConstraintRules(prodConfigRecord.Id, primaryLines);
		Apttus_CPQApi.CPQWebService.applyConstraintRules(prodConfigRecord.Id, false);
	}
			}
		
			if(!catalogProdList.isEmpty() || !papList.isEmpty() || !defaultProdList.isEmpty()) {
	List<string> finalProdList = new List<string>();
	finalProdList.addAll(papList);
	finalProdList.addAll(catalogProdList);
	finalProdList.addAll(defaultProdList);
	errorFlag = 'Custom products cannot be created for Product Codes:<br/>' + String.join(finalProdList, '<br/>') +'<br/> as these products are' + (!defaultProdList.isEmpty() ? ' auto included in the cart' : '') + (!catalogProdList.isEmpty() ?  ((!defaultProdList.isEmpty() ? ' or' : '') + ' available for selection in the Catalog') : '') + (!papList.isEmpty() ? (!defaultProdList.isEmpty() || !catalogProdList.isEmpty() ? ' or' : '') +' available as Pre-Approved Custom Products' : '') + '.' + (!catalogProdList.isEmpty() ? (' Go to "Add more Products" and select the Products from the Catalog' + (!papList.isEmpty() ? ' or Pre-Approved Custom Products' : '') +'.' ) :  +(!papList.isEmpty() ? ' Go to "Pre-Approved Custom Products" and select the Products.' : ''));
			}
			system.debug('[+] ended addProductsfromfile 482');
		
			// End product addition to cart using Web API
		
		
			//Start Save Cart
		
			system.debug('Save ..');
			if (prodConfigRecord.Id != null && !selectedProdDOList.isEmpty()) {
	//Req 6383 Start
	//List < Integer > primaryLines = new List < Integer > ();
	system.debug('[+] before  associateConstraintRules 492');
	if (!isMaintQuote) {
		Apttus_CPQApi.CPQWebService.associateConstraintRules(prodConfigRecord.Id, primaryLines);
		Apttus_CPQApi.CPQWebService.applyConstraintRules(prodConfigRecord.Id, false);
	}
	system.debug('[+] after  associateConstraintRules 492');
	acpq.saveCart(prodConfigRecord.Id);
	system.debug('[+] after  savecart 499');
	//Req 6383 End
		
	// For rules that are not marked as Check on Finalization
	system.debug('[+] before updateMaintenanceLineItem 508');
	//Req 6383 Start
	if (isMaintQuote) {
		
		acpq.updateMaintenanceLineItem(prodConfigRecord.Id);
	}
	system.debug('[+] after updateMaintenanceLineItem 514');
	//Req 6383 End
		
			}
		
			//End Save Cart
		
			return 'Success~'+errorFlag;
		
		}		
}