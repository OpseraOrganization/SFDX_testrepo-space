/* --------------------------------------------------------------------------------------------------------------------------------------------------------
Name:	PS_productuploadscontroller
Description:	 add products to Quote/Proposal record in a bulk.
Date	Version  Author	 Summary of Changes 
-----------   ----------   -----------------	 ---------------------------------------------------------------------------------------
18 Jul 2017   1.0   Akshay Thorat	2606 - Manually upload a list of sellable items in quote (skip guided configuration)
12 Feb 2021   2.0   Christie JJ	  Requirment 6987 - Added logic for duplicate file upload and populating previously uploaded file section
12 Apr 2021   3.0   Christie JJ	  ITCCPQ-925 - Changed csv template file format in VF Page, for accomodating European Users
01 Sep 2021   4.0   Siva Kumar	  ITCCPQ-2170
---------------------------------------------------------------------------------------------------------------------------------------------------------- */

	public without sharing class PS_productuploadscontroller{
	List <Apttus_CPQApi.CPQ.SelectedProductDO> selectedProdDOList = new List <Apttus_CPQApi.CPQ.SelectedProductDO>();
	List <Apttus_Config2__ProductConfiguration__c> prodConfig = new List <Apttus_Config2__ProductConfiguration__c>();
	List <Apttus_Config2__LineItem__c> lineItems = new List <Apttus_Config2__LineItem__c>();
	List <Apttus_Config2__LineItem__c> updateLineItem = new List <Apttus_Config2__LineItem__c>();
	public Id proposalId;
	public String contractIds {get;set;}
	public Id proposalId1 {get;set;}
	public Apttus_Proposal__Proposal__c proposal;
	public boolean readSuccess {get;set;}
	public boolean isMaintQuote {get;set;} 
	public boolean isLeoQuote {get;set;}	
	public String productDataAsString;
	public string csvAsString{get;set;}
	public string errorMessage2{get;set;}
	public Blob csvFileBody{get;set;}
	public String[] csvFileLines{get;set;}
	public Id cartId;
	public List<Apttus_Config2__PriceListItem__c> productlist;
	public map<Id,Decimal> productmap;
	public PS_ApttusCPQWebServiceCalls acpq;
	public String errorMessageWithProducts;
	public string productCodes{get;set;}
	public boolean isPRM {get; set;}
	public boolean issCRM {get; set;}
	public String flowname {get; set;}
	public String proposalquoteType{get;set;}
	public boolean isDirectGSS {get;set;}
	public boolean isMNDirectFlow {get;set;}
	public boolean isFNFlow {get;set;}  
	public Map<String,String> prodPortfolioMap = new Map<String,String>();
	public Map<String,Set<String>> prodPricingClusterMap = new Map<String,Set<String>>();
	Public String storedProducts = '';
	public boolean displayError = false;
	public Set<String> unMatchedProducts = new Set<String>();
	public Set<String> matchedProducts = new Set<String>();
	Public  String store = '';
	public string activeProducts='';
	public string inActiveProducts='';
	//public string xmlheader{get;set;}
	public string endfile {get;set;}
	Public String sspProducts = '';
	public boolean showSSPErrorMsg = false;
	public Set<String> pCodFinalCheck = new Set<String>();
	List <Apttus_Config2__LineItem__c> lineItem = new List <Apttus_Config2__LineItem__c>();
	Set<String> sspProdSet ;
	List<Direct_Portfolio_General_Setting__mdt> portfolioSettingList = new List<Direct_Portfolio_General_Setting__mdt>();
	Integer flag=0;
	//Added by Christie JJ: Requirement 6987
	public List<String> uploadedFiles {get; set;}
	public boolean isCSV {get; set;}
	public String priorUploadedFiles {get; set;}
	Map<String,ID> concatenateproductsiteliid = new Map<String,ID>();
	Map<String,String> concatenateproductsiteliName = new Map<String,String>();
	List <CPQ_Site_Phase_and_Quantity__c> insertSitePhaseQuan = new List <CPQ_Site_Phase_and_Quantity__c>();
	Map<String,ID> siteNameIDMap = new Map<String,ID>();
	
	//ITCCPQ-924
	public String documentId {get; set;}
	
	//Added by Srisailam
	public String extractProducts {get;set;}
	public boolean store1{get;set;}
	public string displayMsg{get;set;}
	
	public List<NokiaCPQ_Site__c> sitesExistingRecords;
	//added by Siva - (ITCCPQ-2170)
	List<String> siteSet = new List<String>();
	public PS_productuploadscontroller(Apexpages.Standardcontroller controller){
		//Added by
		extractProducts='';
		//Added by Christie JJ: Requirment 6987
		priorUploadedFiles = '';
		uploadedFiles = new List<String>();
		isCSV = false;
		proposalId = ApexPages.currentPage().getParameters().get('id');
		isMaintQuote = FALSE;
		system.debug('proposalId'+proposalId);
		proposalId1 = ApexPages.currentPage().getParameters().get('id');
		readSuccess = FALSE;
		acpq = new PS_ApttusCPQWebServiceCalls();
		productlist = new List<Apttus_Config2__PriceListItem__c>();
		productmap = new map<Id,Decimal>();
		if(proposalId != null){
			system.debug('proposal if condition');
			proposal = [Select Id,Apttus_Proposal__Opportunity__c,NokiaCPQ_LEO_Discount__c, Project_Price_List_Number__c,NokiaCPQ_Is_Maintenance_Quote__c,Quote_Type__c,Is_List_Price_Only__c,Apttus_QPConfig__PriceListId__c, NokiaCPQ_Environment_Access_Type__c, NokiaCPQ_Portfolio__c, NokiaCPQPricing_Cluster__c,Turbo_Pricing_Enable__c,APTS_ConfigureProductsTP__c,Configure_button_field_TP__c,Configure_grid_flow_button__c,Configure_button_field__c,Is_Classic_Pricing__c,Is_Turbo_Pricing__c,CPQ_PortfolioClusterSF1__c,CPQ_PortfolioClusterSF2__c,CPQ_PortfolioClusterSF3__c,CPQ_PortfolioClusterSF4__c from Apttus_Proposal__Proposal__c where Id =:proposalId Limit 1];
			system.debug('proposal if condition'+proposal);
			
		}
		//defect 12843 Heema
		contractIds = proposal.Project_Price_List_Number__c;
		proposalquoteType = proposal.Quote_Type__c;
		isMaintQuote = proposal.NokiaCPQ_Is_Maintenance_Quote__c;
		isLeoQuote=proposal.NokiaCPQ_LEO_Discount__c;
		// srisailam : 1062
		if(proposal.NokiaCPQ_Is_Maintenance_Quote__c==true){
			displayMsg = 'This is a Maintenance only Quote';
			// ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, 'This is a maintenance Quote'));
		}
		else if(proposal.NokiaCPQ_LEO_Discount__c==true){
			displayMsg = 'This is a Lab Equipment Quote';
			//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, 'This is a LEO Quote'));
		}
		else{
			// ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.info, 'This is a Standard Quote'));
			displayMsg ='This is a Standard Quote';
		}
		
		if(proposalquoteType !='Indirect CPQ')
			portfolioSettingList = [SELECT Portfolio__c,GSS_Flow__c,Non_GSS_Flow__c,MNDirectFlow__c,Direct_CPQ__c FROM Direct_Portfolio_General_Setting__mdt where Portfolio__c=: this.proposal.NokiaCPQ_Portfolio__c LIMIT 1];
		
		if(proposal.NokiaCPQ_Environment_Access_Type__c == 'PRM')
		{
			isPRM = true;
			issCRM = false;
			isDirectGSS = false;
			isMNDirectFlow = false;
			isFNFlow = false;
		}
		else if(proposalquoteType !='Indirect CPQ' && proposal.Is_List_Price_Only__c == true && portfolioSettingList[0].Direct_CPQ__c == true)
		{
			isDirectGSS = true;
			isPRM =false;
			issCRM = true;
			isMNDirectFlow = false;
			isFNFlow = false;
		}
		else if(proposalquoteType !='Indirect CPQ' && proposal.Is_List_Price_Only__c == false && portfolioSettingList[0].Direct_CPQ__c == true)
		{
			/* if(portfolioSettingList[0].Portfolio__c.equalsIgnoreCase(Nokia_CPQ_Constants.AIRSCALE_WIFI_STRING)){
isDirectGSS =false;
isPRM =false;
issCRM = true;
isMNDirectFlow = true;
isFNFlow= false;
} */
			if(portfolioSettingList[0].Portfolio__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_FN)){  /// Heema chages ITCEPP-752
	isDirectGSS =false;
	isPRM =false;
	issCRM = true;
	isMNDirectFlow = false;
	isFNFlow = true;
			}
			
			else {
	isDirectGSS =false;
	isPRM =false;
	issCRM = true; 
	isMNDirectFlow = false;	 
	isFNFlow= false;
			}
			
		}   
		else {
			isPRM = false;
			issCRM = true;
			isDirectGSS = false;
			isMNDirectFlow = false;
			isFNFlow = false;
		}
		
		if(proposalquoteType !='Indirect CPQ' && isDirectGSS && portfolioSettingList[0].Direct_CPQ__c == true){
			flowname = portfolioSettingList[0].GSS_Flow__c;
		} else if(proposalquoteType !='Indirect CPQ' && !isDirectGSS && portfolioSettingList[0].Direct_CPQ__c == true){
			if(isMNDirectFlow){
	flowname = portfolioSettingList[0].MNDirectFlow__c;
			}else if(isFNFlow){
	flowname = portfolioSettingList[0].Non_GSS_Flow__c;
			}else{
	flowname = portfolioSettingList[0].Non_GSS_Flow__c;  
			}
			
		} 
		
		//ITCCPQ-924
		getDocumentId();
		
	}
	
	public void getDocumentId() { 
		if(!Test.isRunningTest()){
			documentId = [SELECT Id FROM Document WHERE DeveloperName =: 'Custom_Product_Upload_ROW'].Id;
		}
	}
	
	/******* Read the CSV file *********/
	public void readFromFile(){
		//Added by Christie JJ for requirment 6987 (ITCCPQ - 875)
		selectedProdDOList.clear();  
		system.debug('Loading products ..');
		system.debug(csvAsString);
		system.debug(csvFileBody);
		try{
			if(csvFileBody !=null){
	IF(proposalquoteType.equals('Indirect CPQ')){
		readCSVFile();
	}else {readCSVDirectFile();}
			}else{

	ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'No File Selected');
	ApexPages.addMessage(errorMessage);
			}
			
			
		}
		catch(exception e){
			readSuccess = FALSE;
			//ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,Label.PS_CSV_Error);

			ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,'CSV File Error');
			ApexPages.addMessage(errorMessage);
			
			
		}
		
	}   
	
	public void readCSVFile()
	{
		
		system.debug('readCSVFile::::');
		//Set<String> siteSet = new Set<String>();
		List<String> csvRecordData;
		List<String> csvRecordData1;
		Map<String,String> prodcutCodeSiteNameMap = new Map<String,String>();
		Set<NokiaCPQ_Site__c> sitesToInsertset = new Set<NokiaCPQ_Site__c>();
		List<NokiaCPQ_Site__c> sitesToInsertLists = new List<NokiaCPQ_Site__c>();
		Set<String> productCodeSet = new Set<String>();
		Map<String,ID> productCodeIDMap = new Map<String,ID>();
		Map<Id, Double> productIdVersionMap = new Map<Id, Double>();
		Map<String,Integer> concatenateProductIDSiteIDQuantityMap = new Map<String,Integer>();
		Map<String,Set<String>> siteAndProductMap = new Map<String,Set<String>>();
		Boolean validForInsertion;
		Set<String> pricingClusters;
		Set<String> activeProducts = new Set<String>();
		Set<String> inActiveProducts = new Set<String>();
		
		sitesExistingRecords = new List<NokiaCPQ_Site__c>();

		productDataAsString = csvFileBody.toString();
		if(productDataAsString.contains(';')){
			system.debug('CSV file with comma' +productDataAsString );
			productDataAsString = productDataAsString.replaceAll(';',',');
		}
		system.debug('csvFileBody::::'+csvFileBody);
		system.debug('productDataAsString::::'+productDataAsString);
		csvFileLines = productDataAsString.split('\n');
		
		system.debug('CsvFileLinesSize'+csvFileLines.size());
		
		
		for(Integer i=1;i<csvFileLines.size();i++){
			csvRecordData = csvFileLines[i].split(',');
			system.debug('csvRecordData::::'+csvRecordData);
			system.debug('productCodeSet::::'+productCodeSet);
			if(!String.isBlank(csvRecordData[0]) && !String.isBlank(csvRecordData[1])){
	productCodeSet.add(csvRecordData[0]);
	system.debug('productCodeSet::::'+productCodeSet);
	if(!String.isBlank(csvRecordData[2])){
		if(!siteSet.contains(csvRecordData[2])){
			siteSet.add(csvRecordData[2]);
		}
		if(siteAndProductMap.containsKey(csvRecordData[2].trim())){
			siteAndProductMap.get(csvRecordData[2].trim()).add(csvRecordData[0]);
		}
		else{
			siteAndProductMap.put(csvRecordData[2].trim(),new Set<String>{csvRecordData[0]});
		}
	}
			}
		}
		sspProdSet = new Set<String>();
		for(Product2 sspProduct : [Select Id, ProductCode from Product2 WHERE isInvalidProductCatalog__c =:Nokia_CPQ_Constants.TrueValue LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows()) ]){
			System.debug('productCodeSet:::'+productCodeSet);
			System.debug('sspProduct.Product_Code__c:::'+sspProduct.ProductCode);
			if(productCodeSet.contains(sspProduct.ProductCode) ){
	sspProdSet.add(sspProduct.ProductCode);
	//sspProducts = sspProducts + sspProduct.Product_Code__c + ','; 
	showSSPErrorMsg = true;
			}
			System.debug('SSPProducts::::>>>'+sspProducts);
			
		}
		
		
		
		System.debug('sspProdSet::'+sspProdSet);
		
		
		system.debug('siteAndProductMap ** '+siteAndProductMap);  
		//Added by RG for Req 6612 on 1st Oct 2019 (Valid for check)  
		for(Product2 product : [SELECT ID, Apttus_Config2__Version__c,Created_by_PMDI__c, ProductCode, Portfolio__c, NokiaCPQ_Valid_for__c, Pricing_Clusters__c FROM Product2 WHERE IsActive = TRUE AND NokiaCPQ_Valid_for__c = 'Indirect' AND ProductCode IN :productCodeSet]){   //AND Created_by_PMDI__c = FALSE
			system.debug('Product In Loop***'+ product.ProductCode+'portfolio'+product.Portfolio__c);
			activeProducts.add(product.ProductCode);
			system.debug('ActiveProducts***'+ activeProducts);
			if(String.isNotBlank(product.Portfolio__c) && product.Portfolio__c.containsignorecase(proposal.NokiaCPQ_Portfolio__c)){  //ITCCPQ-2594
	
	productCodeIDMap.put(product.ProductCode, product.ID);
	
	prodPortfolioMap.put(product.productcode,product.Portfolio__c);
	productIdVersionMap.put(product.ID, product.Apttus_Config2__Version__c);
	
	system.debug('ActiveProducts matched***'+ activeProducts); 
	
	if(String.isNotBlank(product.Pricing_Clusters__c)){
		system.debug('pricing cluster is not blank ');
		pricingClusters = new Set<String>();
		pricingClusters.addAll(product.Pricing_Clusters__c.split(';'));
		if(!pricingClusters.isEmpty()){
			system.debug('pricing cluster is not empty');
			prodPricingClusterMap.put(product.productcode,pricingClusters);
			matchedProducts.add(product.ProductCode);
			system.debug('prodPricingClusterMap..'+prodPricingClusterMap);
		}
	}
	system.debug('product2 for loop..'+prodPortfolioMap);	
			}
			
			
		}
		System.debug('MatchedProducts'+matchedProducts);
		System.debug('unMatchedProducts'+unMatchedProducts);
		
		
		for(Integer i=1;i<csvFileLines.size();i++){
			csvRecordData1 = csvFileLines[i].split(',');
			system.debug('csvRecordData1::::'+csvRecordData1);
			if(activeProducts.contains(csvRecordData1[0])){
	System.debug('ActiveProducts'+activeProducts);
			}
			else{
	inActiveProducts.add(csvRecordData1[0]);
	System.debug('InActiveProducts'+inActiveProducts);
			}
		}
		system.debug('prodPricingClusterMap..'+prodPricingClusterMap);
		
		//added try here
		try{
			List<NokiaCPQ_Site__c> siteList = [SELECT ID, Name FROM NokiaCPQ_Site__c WHERE Opportunity__c  = : proposal.Apttus_Proposal__Opportunity__c];
			Set<NokiaCPQ_Site__c> nokiaSiteSet = new Set<NokiaCPQ_Site__c>();
			sitesToInsertset.addAll(nokiaSiteSet);
			nokiaSiteSet.addAll(siteList);
			
			/*for(String siteName : siteSet){
	flag=0;
	NokiaCPQ_Site__c siteRecord = new NokiaCPQ_Site__c();
	if(siteList.size()>0){
		for(NokiaCPQ_Site__c site :siteList){
			if(siteName!=null && site.Name!=null && !siteName.trim().equals(site.Name.trim())){
				siteRecord.Name = siteName.trim();
				siteRecord.Opportunity__c = proposal.Apttus_Proposal__Opportunity__c;
				for(NokiaCPQ_Site__c siteobj :siteList){
		if((siteobj.Name.trim()).equals(siteRecord.Name.trim())){
			flag++;break;
		}
				}
				if(flag==0){
		sitesToInsertset.add(siteRecord); 
				}
			}else if(siteName!=null && site.Name!=null && siteName.trim().equals(site.Name.trim())){
				sitesExistingRecords.add(site);
				//break;
			}
		}
	}
	else{
		siteRecord.Name = siteName;siteRecord.Opportunity__c = proposal.Apttus_Proposal__Opportunity__c;
		sitesToInsertset.add(siteRecord);
	}
			}*/
			Map<String,NokiaCPQ_Site__c> opptySite = new Map<String,NokiaCPQ_Site__c>();
			for(NokiaCPQ_Site__c oppSite : siteList){
	opptySite.put(oppSite.Name, oppSite);
			}

			for(String siteName : siteSet){
	//System.debug('RG:siteName--->'+siteName);
	String siteNameTm = siteName.trim();
	if(!opptySite.containsKey(siteNameTm)){
		NokiaCPQ_Site__c siteRecord = new NokiaCPQ_Site__c();
		siteRecord.Name = siteNameTm;
		siteRecord.Opportunity__c = proposal.Apttus_Proposal__Opportunity__c;
		sitesToInsertset.add(siteRecord);
	}
	else if(opptySite.containsKey(siteNameTm)){
		sitesExistingRecords.add(opptySite.get(siteNameTm));
	}
			}

			if(!sitesToInsertset.isEmpty()){
	for(NokiaCPQ_Site__c siteRec : sitesToInsertset){
		validForInsertion = false;
		Set<String> relatedProdCodes = new Set<String>();
		relatedProdCodes = siteAndProductMap.get(siteRec.Name.trim());
		system.debug('relatedProdCodes**' + relatedProdCodes + siteRec.Name);
		for(String prodCode : relatedProdCodes){
			String prodPortfolio = prodPortfolioMap.get(prodCode);
			Set<String> prodPricingCluster = new Set<String>();
			prodPricingCluster = prodPricingClusterMap.get(prodCode);
			system.debug('prodPricingCluster**' + prodPricingCluster + proposal.NokiaCPQPricing_Cluster__c);
		if(String.isNotBlank(prodPortfolio) && prodPortfolio.containsignorecase(proposal.NokiaCPQ_Portfolio__c)
							&& prodPricingCluster != null && !prodPricingCluster.isEmpty() 
							&& (prodPricingCluster.contains(proposal.CPQ_PortfolioClusterSF1__c.removeEnd(Nokia_CPQ_Constants.SEMICOLON_STRING)) 
							|| prodPricingCluster.contains(proposal.CPQ_PortfolioClusterSF2__c.removeEnd(Nokia_CPQ_Constants.SEMICOLON_STRING))
							|| prodPricingCluster.contains(proposal.CPQ_PortfolioClusterSF3__c.removeEnd(Nokia_CPQ_Constants.SEMICOLON_STRING))
							|| prodPricingCluster.contains(proposal.CPQ_PortfolioClusterSF4__c.removeEnd(Nokia_CPQ_Constants.SEMICOLON_STRING)))){   //ITCCPQ-2594
				validForInsertion = true;break;
			}
		}
		if(validForInsertion){
			sitesToInsertLists.add(siteRec);
			system.debug('ValidForInsertion '+validForInsertion);
		}
	}
	if(!sitesToInsertLists.isEmpty()){
		insert sitesToInsertLists;
		sitesExistingRecords.addAll(sitesToInsertLists);
		system.debug('sitesToINserted');
	}
			}
			system.debug('2sitesExistingRecords>>'+sitesExistingRecords);
			for(NokiaCPQ_Site__c site : [SELECT ID, Name FROM NokiaCPQ_Site__c WHERE Opportunity__c  = :proposal.Apttus_Proposal__Opportunity__c]){
	siteNameIDMap.put(site.Name, site.ID);
			}
			
			
			for(Integer i=1;i<csvFileLines.size();i++){
	csvRecordData = csvFileLines[i].split(',');
	
	if(!String.isBlank(csvRecordData[0]) && !productCodeIDMap.containsKey(csvRecordData[0])){
		system.debug('In if condigiton...'+csvRecordData[0]);
		if(!inActiveProducts.contains(csvRecordData[0])){
			displayError = true;
			unMatchedProducts.add(csvRecordData[0]);
		}
		//   ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Either the Product is inactive or does not exist.'); 
		//  ApexPages.addMessage(errorMessage);
	}
	else{
		system.debug('In Else condition...'+ productCodeIDMap);
		Set<String> pricingCluster2 = new Set<String>();
		pricingCluster2 = prodPricingClusterMap.get(csvRecordData[0]);
		/*for(String cluster : pricingCluster2){
if(String.isBlank(cluster)){
pricingCluster2.remove(cluster);
}
}*/
		system.debug('pricingCluster2'+ pricingCluster2 + proposal.NokiaCPQPricing_Cluster__c);

			if(!String.isBlank(csvRecordData[0]) && prodPortfolioMap.get(csvRecordData[0])!= null
				 && prodPortfolioMap.get(csvRecordData[0]).containsignorecase(proposal.NokiaCPQ_Portfolio__c)
				  && pricingCluster2 != null && (!pricingCluster2.isEmpty())
				  && proposal.Quote_Type__c.equalsignorecase(Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ)
						&& (pricingCluster2.contains(proposal.CPQ_PortfolioClusterSF1__c.removeEnd(Nokia_CPQ_Constants.SEMICOLON_STRING)) 
							|| pricingCluster2.contains(proposal.CPQ_PortfolioClusterSF2__c.removeEnd(Nokia_CPQ_Constants.SEMICOLON_STRING))
							|| pricingCluster2.contains(proposal.CPQ_PortfolioClusterSF3__c.removeEnd(Nokia_CPQ_Constants.SEMICOLON_STRING))
							|| pricingCluster2.contains(proposal.CPQ_PortfolioClusterSF4__c.removeEnd(Nokia_CPQ_Constants.SEMICOLON_STRING)))){
								
			if(!sspProdSet.Contains(csvRecordData[0])){
				pCodFinalCheck.add(csvRecordData[0]);
				system.debug(pCodFinalCheck);
				system.debug(pricingCluster2.contains(proposal.NokiaCPQPricing_Cluster__c));
				if(!String.isBlank(csvRecordData[0]) && !String.isBlank(csvRecordData[1])){
		System.debug('----->>'+ csvRecordData[0].trim() +'---'+ csvRecordData[2].trim());
		
		String concatenateProductIDSiteID;
		if(!String.isBlank(csvRecordData[2])){
			concatenateProductIDSiteID = productCodeIDMap.get(csvRecordData[0]) + '--' + siteNameIDMap.get(csvRecordData[2].trim());
			//added by nandeesh
			prodcutCodeSiteNameMap.put(productCodeIDMap.get(csvRecordData[0]) + '--' + siteNameIDMap.get(csvRecordData[2].trim()),csvRecordData[2].trim());
		}
		else{
			concatenateProductIDSiteID = productCodeIDMap.get(csvRecordData[0]) + '--null';
			prodcutCodeSiteNameMap.put(productCodeIDMap.get(csvRecordData[0]) + '--null',csvRecordData[2].trim());
		}
		if(concatenateProductIDSiteIDQuantityMap.containsKey(concatenateProductIDSiteID)){
			String s = csvRecordData[1]; 
			Integer quantity = concatenateProductIDSiteIDQuantityMap.get(concatenateProductIDSiteID) + Integer.valueOf(s);
			concatenateProductIDSiteIDQuantityMap.put(concatenateProductIDSiteID, quantity);
			
		}
		else{
			String s = csvRecordData[1];
			concatenateProductIDSiteIDQuantityMap.put(concatenateProductIDSiteID, Integer.ValueOf(s));   
		}
				}
			}
		}
		else{
			displayError = true;
			unMatchedProducts.add(csvRecordData[0]);
			System.debug('unmatched Products after else>>'+unMatchedProducts);
		}
	}
			}
			for(String unMatched : unMatchedProducts){
	if(String.isNotBlank(unMatched)){
					storedProducts = storedProducts + unMatched +'<br/>'; //+',' ;
		system.debug('storeValues'+storedProducts);
	}
			} 
			
			If(!inActiveProducts.isEmpty()){
	for(String inactivePro : inActiveProducts){
		if(String.isNotBlank(inactivePro)){
			store = store + inactivePro +'<br/>';
			//srisailam :1062
			if(store!=null ){
				store1 = true;
				system.debug('@@@@@@STORE1' +store1);
			}
			system.debug('inactive values'+store);
		}
	}
			}
			
			if(!concatenateProductIDSiteIDQuantityMap.keySet().isEmpty()){
	system.debug('concatenateProductIDSiteIDQuantityMap'+concatenateProductIDSiteIDQuantityMap);
	for(String concatenateProductIDSiteID : concatenateProductIDSiteIDQuantityMap.keySet()){
		system.debug('concatenateProductIDSiteIDQuantityMap for loop'+concatenateProductIDSiteIDQuantityMap);
		List<String> productIDSiteIDList = concatenateProductIDSiteID.split('--');
		
		Apttus_CPQApi.CPQ.SelectedProductDO SelectedProductDOInstance = new Apttus_CPQApi.CPQ.SelectedProductDO();
		SelectedProductDOInstance.ProductId = productIDSiteIDList[0];
		SelectedProductDOInstance.Quantity = concatenateProductIDSiteIDQuantityMap.get(concatenateProductIDSiteID);
		
		List<String> customFields = new List<String>();
		customFields.add('Apttus_Config2__ProductVersion__c');  
		customFields.add(Nokia_CPQ_Constants.OPPORTUNITYSIDE);
		customFields.add('NokiaCPQ_Site__c');
		customFields.add('Source__c');
		SelectedProductDOInstance.CustomFields = customFields;
		
		Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c();
		
		if(productIDSiteIDList[1] != 'null'){
			CustomData.NokiaCPQ_Opportunity_Site__c = productIDSiteIDList[1];   
		}
		CustomData.Apttus_Config2__ProductVersion__c = productIdVersionMap.get(productIDSiteIDList[0]);
		CustomData.Source__c ='CSV';
		//added by nandeesh
		System.debug('----->>'+ concatenateProductIDSiteID);
		System.debug('----->>'+ prodcutCodeSiteNameMap);
		CustomData.NokiaCPQ_Site__c = prodcutCodeSiteNameMap.get(concatenateProductIDSiteID);
		
		SelectedProductDOInstance.CustomData = customData;
		selectedProdDOList.add(SelectedProductDOInstance);
	}
			}
			//Added by Srisailam
			string fileContent;
			string Column1= 'Products';
			String Column2= 'Status';
			fileContent = Column1 + ',' + Column2 +'\n'; 
			for(String inActive : inActiveProducts){
	fileContent += inActive + ',' + 'Unavailable'+'\n' ;
			}
			//for(String Active : activeProducts){
			// fileContent += Active + ',' + 'Available'+'\n' ;
			//}	
			extractProducts = EncodingUtil.urlEncode(fileContent,'UTF-8');
			system.debug('[+] extractedproducts = '+extractProducts );
			
			//Added by Christie JJ for rqmt 6987
			uploadedFiles.add(csvAsString);
			priorUploadedFiles = String.join(uploadedFiles,' , ');
			
		}catch(Exception e){
			system.debug('Upload product is failing');
			ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Products Upload Error'+ +e.getMessage());
			ApexPages.addMessage(errorMessage);
		}
		
	}
	/*Product upload method for Direct and ION */
	
	public void readCSVDirectFile()
	{
		try{
			system.debug('readIONCSVFile::::');
			//Set<String> siteSet = new Set<String>();
			List<String> csvRecordData;
			List<String> csvRecordData1;
			
			Map<String,String> prodcutCodeSiteNameMap = new Map<String,String>();
			//Map<String,ID> siteNameIDMap = new Map<String,ID>();
			Set<String> productCodeSet = new Set<String>();
			Map<String,ID> productCodeIDMap = new Map<String,ID>();
			Map<Id, Double> productIdVersionMap = new Map<Id, Double>();
			Map<String,Integer> concatenateProductIDSiteIDQuantityMap = new Map<String,Integer>();
			
			Set<String> pricingClusters;
			Set<String> activeProducts = new Set<String>();
			Set<String> inActiveProducts = new Set<String>();
			/*FOr MN Direct*/
			Map<String,String> productCodeANdIRPMap = new Map<String,String>();
			
			
			productDataAsString = csvFileBody.toString();
			if(productDataAsString.contains(';')){
	system.debug('ION CSV file with comma' +productDataAsString );
	productDataAsString = productDataAsString.replaceAll(';',',');
			}
			system.debug('ION csvFileBody::::'+csvFileBody);
			system.debug('ION productDataAsString::::'+productDataAsString);
			csvFileLines = productDataAsString.split('\n');
			
			system.debug('ION CsvFileLinesSize'+csvFileLines.size());
			
			
			for(Integer i=1;i<csvFileLines.size();i++){
	csvRecordData = csvFileLines[i].split(',');
	system.debug('ION csvRecordData::::'+csvRecordData);
	system.debug('ION productCodeSet::::'+productCodeSet);
	if(!String.isBlank(csvRecordData[0]) && !String.isBlank(csvRecordData[1]) && (!String.isBlank(csvRecordData[2]) || String.isBlank(csvRecordData[2]))){
		productCodeSet.add(csvRecordData[0]);
		system.debug('productCodeSet::::'+productCodeSet);
		
		if(!String.isBlank(csvRecordData[2])){
			productCodeANdIRPMap.put(csvRecordData[0],csvRecordData[2]);
		}
		system.debug('productCodeANdIRPMap>>'+productCodeANdIRPMap);
	}
			}  
			//ITCEPP-752 Heema 
	for(Product2 product : [SELECT ID, Apttus_Config2__Version__c, ProductCode,Created_by_PMDI__c, Portfolio__c,Direct_Portfolio__c, Pricing_Clusters__c FROM Product2 WHERE IsActive = TRUE AND Created_by_PMDI__c =false AND ProductCode IN :productCodeSet]){
	system.debug('Product In Loop***'+ product.ProductCode+'portfolio'+product.Portfolio__c);
	activeProducts.add(product.ProductCode);
	system.debug('ActiveProducts***'+ activeProducts);
	if(String.isNotBlank(product.Direct_Portfolio__c) && product.Direct_Portfolio__c.equalsIgnoreCase(proposal.NokiaCPQ_Portfolio__c)){
		
		productCodeIDMap.put(product.ProductCode, product.ID);
		
		prodPortfolioMap.put(product.productcode,product.Direct_Portfolio__c);
		productIdVersionMap.put(product.ID, product.Apttus_Config2__Version__c);
		
		system.debug('ActiveProducts matched***'+ activeProducts); 
			//commented by sunidhar as this is not being used for direct portfolio
		/*if(String.isNotBlank(product.Pricing_Clusters__c)){
			system.debug('pricing cluster is not blank ');
			pricingClusters = new Set<String>();
			pricingClusters.addAll(product.Pricing_Clusters__c.split(','));
			if(!pricingClusters.isEmpty()){
				system.debug('pricing cluster is not empty');
				prodPricingClusterMap.put(product.productcode,pricingClusters);
				matchedProducts.add(product.ProductCode);
				system.debug('prodPricingClusterMap..'+prodPricingClusterMap);
			}
		} */
		system.debug('product2 for loop..'+prodPortfolioMap);	
	}
	
	
			}
			System.debug('MatchedProducts'+matchedProducts);
			System.debug('unMatchedProducts'+unMatchedProducts);
			
			
			for(Integer i=1;i<csvFileLines.size();i++){
	csvRecordData1 = csvFileLines[i].split(',');
	system.debug('csvRecordData1::::'+csvRecordData1);
	if(activeProducts.contains(csvRecordData1[0])){
		System.debug('ActiveProducts'+activeProducts);
	}
	else{
		inActiveProducts.add(csvRecordData1[0]);
		System.debug('InActiveProducts'+inActiveProducts);
	}
			}
			system.debug('prodPricingClusterMap..'+prodPricingClusterMap);
			
			
			for(Integer i=1;i<csvFileLines.size();i++){
	csvRecordData = csvFileLines[i].split(',');
	
	if(!String.isBlank(csvRecordData[0]) && !productCodeIDMap.containsKey(csvRecordData[0])){
		system.debug('In if condigiton...'+csvRecordData[0]);
		if(!inActiveProducts.contains(csvRecordData[0])){
			displayError = true;
			unMatchedProducts.add(csvRecordData[0]);
		}
		
	}
	else{
		system.debug('In Else condition...'+ productCodeIDMap);
		
		if(!String.isBlank(csvRecordData[0]) && prodPortfolioMap.get(csvRecordData[0])!= null && prodPortfolioMap.get(csvRecordData[0]).equalsignorecase(proposal.NokiaCPQ_Portfolio__c) && (proposal.Quote_Type__c.equalsignorecase(Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ))){
			
			pCodFinalCheck.add(csvRecordData[0]);
			system.debug(pCodFinalCheck);
			
			if(!String.isBlank(csvRecordData[0]) && !String.isBlank(csvRecordData[1])){
				String concatenateProductIDSiteID;
				String concatenateProductIDIRPPrice;
				if(!String.isBlank(csvRecordData[2])){
		concatenateProductIDIRPPrice = productCodeIDMap.get(csvRecordData[0]) + '--' + productCodeANdIRPMap.get(csvRecordData[0]);
		//added by nandeesh
		prodcutCodeSiteNameMap.put(productCodeIDMap.get(csvRecordData[0]) + '--' + productCodeANdIRPMap.get(csvRecordData[0]),csvRecordData[2].trim());
				}
				else{
		concatenateProductIDIRPPrice = productCodeIDMap.get(csvRecordData[0]) + '--EMP';
		prodcutCodeSiteNameMap.put(productCodeIDMap.get(csvRecordData[0]) + '--null',csvRecordData[2].trim());
				}
				if(concatenateProductIDSiteIDQuantityMap.containsKey(concatenateProductIDIRPPrice)){
		String s = csvRecordData[1]; 
		Integer quantity = concatenateProductIDSiteIDQuantityMap.get(concatenateProductIDIRPPrice) + Integer.valueOf(s);
		concatenateProductIDSiteIDQuantityMap.put(concatenateProductIDIRPPrice, quantity);
		
				}
				else{
		String s = csvRecordData[1];
		concatenateProductIDSiteIDQuantityMap.put(concatenateProductIDIRPPrice, Integer.ValueOf(s));   
				}
				system.debug('concatenateProductIDIRPPrice'+concatenateProductIDIRPPrice);
				system.debug('concatenateProductIDSiteIDQuantityMap'+concatenateProductIDSiteIDQuantityMap);
			}
		}
		else{
			displayError = true;
			unMatchedProducts.add(csvRecordData[0]);
			
		}
	}
			}
			for(String unMatched : unMatchedProducts){
	if(String.isNotBlank(unMatched)){
					storedProducts = storedProducts + unMatched +'<br/>';//+',' ;
		system.debug('storeValues'+storedProducts);
	}
			} 
			
			If(!inActiveProducts.isEmpty()){
	for(String inactivePro : inActiveProducts){
		if(String.isNotBlank(inactivePro)){
			store = store + inactivePro +'<br/>';
			//srisailam :1062
			if(store!= null){
				store1= true;
				system.debug('@@@@@@@@@@@@@@@@STORE1' +store1);
			}
			system.debug('inactive values'+store);
			
		}
	}
			}
			for(NokiaCPQ_Site__c site : [SELECT ID, Name FROM NokiaCPQ_Site__c WHERE Opportunity__c  = :proposal.Apttus_Proposal__Opportunity__c]){
	siteNameIDMap.put(site.Name, site.ID);
			}
			
			if(!concatenateProductIDSiteIDQuantityMap.keySet().isEmpty()){
	system.debug('concatenateProductIDSiteIDQuantityMap'+concatenateProductIDSiteIDQuantityMap);
	for(String concatenateProductIDSiteID : concatenateProductIDSiteIDQuantityMap.keySet()){
		system.debug('concatenateProductIDSiteIDQuantityMap for loop'+concatenateProductIDSiteIDQuantityMap);
		List<String> productIDSiteIDList = concatenateProductIDSiteID.split('--');
		system.debug('productIDSiteIDList'+productIDSiteIDList);
		Apttus_CPQApi.CPQ.SelectedProductDO SelectedProductDOInstance = new Apttus_CPQApi.CPQ.SelectedProductDO();
		system.debug('productIDSiteIDList[0]'+productIDSiteIDList[0]);
		system.debug('productIDSiteIDList[1]'+productIDSiteIDList[1]);
		SelectedProductDOInstance.ProductId = productIDSiteIDList[0];
		system.debug('concatenateProductIDSiteIDQuantityMap.get(concatenateProductIDSiteID)'+concatenateProductIDSiteIDQuantityMap.get(concatenateProductIDSiteID));
		SelectedProductDOInstance.Quantity = concatenateProductIDSiteIDQuantityMap.get(concatenateProductIDSiteID);
		system.debug('1');
		List<String> customFields = new List<String>();
		customFields.add('Apttus_Config2__ProductVersion__c');  
		customFields.add('Source__c');
		customFields.add('NokiaCPQ_Site__c');
		//customFields.add('NokiaCPQ_Unitary_IRP__c');
		//customFields.add('NCPQ_Unitary_CLP__c');
		system.debug('2');
		SelectedProductDOInstance.CustomFields = customFields;
		system.debug('3');
		Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c();
		system.debug('4');
		/*if(productIDSiteIDList[1] != 'EMP'){
//CustomData.NokiaCPQ_Opportunity_Site__c = productIDSiteIDList[1];  
system.debug('5');  
CustomData.NokiaCPQ_Unitary_IRP__c = Decimal.valueOf(productIDSiteIDList[1].trim()).setScale(2);  
system.debug('6');	
}*/
		system.debug('productIdVersionMap.get(productIDSiteIDList[0]'+productIdVersionMap.get(productIDSiteIDList[0]));
		CustomData.Apttus_Config2__ProductVersion__c = productIdVersionMap.get(productIDSiteIDList[0]);
		CustomData.Source__c ='CSV';
		//added by nandeesh
		System.debug('----->>'+ prodcutCodeSiteNameMap+ '---'+ concatenateProductIDSiteID);
		CustomData.NokiaCPQ_Site__c = prodcutCodeSiteNameMap.get(concatenateProductIDSiteID);
		
		SelectedProductDOInstance.CustomData = customData;
		selectedProdDOList.add(SelectedProductDOInstance);
	}
			}
			
			//Added by Srisailam
			string fileContent;
			string Column1= 'Products';
			String Column2= 'Status';
			fileContent = Column1 + ',' + Column2 +'\n'; 
			for(String inActive : inActiveProducts){
	fileContent += inActive + ',' + 'Unavailable'+'\n' ;
			}
			// for(String Active : activeProducts){
			//fileContent += Active + ',' + 'Available'+'\n' ;
			//}	
			extractProducts = EncodingUtil.urlEncode(fileContent,'UTF-8');
			system.debug('[+] extractedproducts = '+extractProducts );
			
		}catch(Exception e){
			system.debug('In Exception');
			ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'Products Upload Error'+e.getMessage());
			ApexPages.addMessage(errorMessage);
		}
		
	}
	
	/******  on close return to Proposal *******/
	public PageReference  returntoquote(){
		PageReference pg = new PageReference('/'+proposalId);   
		pg.setRedirect(true);
		return pg;
		
	}
	
	/******  on close return to Proposal cart *******/
	public PageReference  returntocart(){
		string cartUrl = Nokia_CPQ_Utility.updateQuoteAndRedirect(proposal);
		system.debug('returntocart>>>' + cartUrl);
		PageReference pg1 = new PageReference(cartUrl);
		pg1.setRedirect(true);
		return pg1;
		
	}
	
	/******  Create a Cart for the proposal *******/
	public void createcart(){
		//Req 6383 Start
		if(proposal.NokiaCPQ_Is_Maintenance_Quote__c){
			
			prodConfig = [Select Id from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c = :proposalId and (Apttus_Config2__Status__c = 'Saved' OR Apttus_Config2__Status__c = 'Finalized')];
			if(!prodConfig.isEmpty()){
	lineItem = [Select Id,Apttus_Config2__IsHidden__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c in :prodConfig and Apttus_Config2__IsHidden__c = true];
	if(!lineItem.isEmpty()){
		for(Apttus_Config2__LineItem__c li : lineItem){
			li.Apttus_Config2__IsHidden__c=false;
			updateLineItem.add(li);
		}
		
	}
			}
			update updateLineItem;
		}
		
		//Req 6383 End
		if(proposalId != null){
			cartId = acpq.CreateApttusCart(proposalId);
			//acpq.addMultiProductsfromfile(productmap,cartid);
			//acpq.RepriceProposal(cartid);
			//acpq.Finalizeproposal(cartid);
			acpq.saveCart(cartid);
			
			List<ID> sitesInCSVOrderlstIns = new List<ID>();
			for(String site:siteSet){
	for(NokiaCPQ_Site__c  siteObj :sitesExistingRecords){
		if(site.trim() == siteObj.Name){
			sitesInCSVOrderlstIns.add(siteObj.Id);
			break;
		}
	}
			}			
			
			if( sitesExistingRecords!= null && !sitesExistingRecords.isEmpty()){
	Nokia_CPQ_Utility.insertSitePhaseConfig(cartid,sitesInCSVOrderlstIns, new List<ID>());
			}
			
		}

		system.debug('cartId----------------------'+cartId );
	}
	
	/******* Add products selected from the CSV file to Cart *******/ 
	public void addProductsfromfile(){
		List<String> csvRecordData;
		List<Integer> primaryLines = new List<Integer>();
		if(!selectedProdDOList.isEmpty())
		{
			Apttus_CPQApi.CPQ.AddMultiProductRequestDO lineItemRecords = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
			lineItemRecords.cartID = cartID;
			lineItemRecords.SelectedProducts = selectedProdDOList;
			Apttus_CPQApi.CPQ.AddMultiProductResponseDO lineItemRecordsResponse = Apttus_CPQApi.CPQWebService.addMultiProducts(lineItemRecords);
			if(proposal.NokiaCPQ_Is_Maintenance_Quote__c){
	Apttus_CPQApi.CPQWebService.associateConstraintRules(cartId,primaryLines);
	Apttus_CPQApi.CPQWebService.applyConstraintRules(cartId, false);
	
	
			}
			
		}
		// Added by nandeesh
		lineItems = [Select Id,Name,Apttus_Config2__ProductId__r.ProductCode,NokiaCPQ_Opportunity_Site__r.name,NokiaCPQ_Site__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = :cartId ];   
		for(Apttus_Config2__LineItem__c li : lineItems){
			if(!(li.Apttus_Config2__ProductId__r.ProductCode.equalsIgnoreCase('MT001') || li.Apttus_Config2__ProductId__r.ProductCode.equalsIgnoreCase('MT002') || li.Apttus_Config2__ProductId__r.ProductCode.equalsIgnoreCase('SSP002') || li.Apttus_Config2__ProductId__r.ProductCode.equalsIgnoreCase('SRS001') )){
	concatenateproductsiteliid.put(li.Apttus_Config2__ProductId__r.ProductCode+'--'+li.NokiaCPQ_Site__c,li.id);
	concatenateproductsiteliName.put(li.Apttus_Config2__ProductId__r.ProductCode+'--'+li.NokiaCPQ_Site__c,li.Name);
			}
		}
		for(Integer i=1;i<csvFileLines.size();i++){
			csvRecordData = csvFileLines[i].split(','); 
			system.debug('----->>sitephs---'+concatenateproductsiteliid.keySet());
			if(concatenateproductsiteliid.containsKey(csvRecordData[0].trim()+'--'+csvRecordData[2].trim())){
	CPQ_Site_Phase_and_Quantity__c spq = new CPQ_Site_Phase_and_Quantity__c();
	spq.Name= concatenateproductsiteliName.get(csvRecordData[0].trim()+'--'+csvRecordData[2].trim());
	spq.Line_Item__c= concatenateproductsiteliid.get(csvRecordData[0].trim()+'--'+csvRecordData[2].trim());
	spq.NCPQ_Quantity__c = Integer.ValueOf(csvRecordData[1]);
	spq.NCPQ_Site__c = siteNameIDMap.get(csvRecordData[2].trim());
	insertSitePhaseQuan.add(spq);
			}
		}
		if(!insertSitePhaseQuan.isEmpty()){
			system.debug('--- insertSitePhaseQuan--'+ insertSitePhaseQuan);
			insert insertSitePhaseQuan;  
		}		
	}
	
	
	/******  Reprice the cart *******/
	public void Reprice(){
		system.debug('reprice ..');
		
		if(cartId != null){
			acpq.RepriceProposal(cartId);
		}
	}
	
	/***** Save The cart *********/
	public void Saveconfig(){
		system.debug('Save ..');
		if(cartId != null && csvFileBody !=null){
			//Req 6383 Start
			List<Integer> primaryLines = new List<Integer>();
			if(!proposal.NokiaCPQ_Is_Maintenance_Quote__c){
	Apttus_CPQApi.CPQWebService.associateConstraintRules(cartId,primaryLines);
	Apttus_CPQApi.CPQWebService.applyConstraintRules(cartId, false);
			}
			acpq.saveCart(cartId);
			//Req 6383 End
			ApexPages.Message errorMessage;

			if(showSSPErrorMsg){
	ApexPages.Message errorMessage1 = new ApexPages.Message(ApexPages.Severity.Info,'SSP, SRS and Care items are not uploaded as they are calculated automatically in the cart.'); 
	ApexPages.addMessage(errorMessage1);   
	
			}
			if(displayError && String.isNotBlank(storedProducts)){
	ApexPages.Message errorMessage1 = new ApexPages.Message(ApexPages.Severity.Info,'Following products are not available for shopping as pricing cluster and portfolio does not match:<br/>'+storedProducts.removeEnd(','));		
	ApexPages.addMessage(errorMessage1);
			}
			if(String.isNotBlank(store)) {
	system.debug('store in save method'+store);
	store = store.removeEnd(',');
	//srisailam : 1062
	ApexPages.Message errorMessage2 = new ApexPages.Message(ApexPages.Severity.Info,'Following items are not available in the Partner Catalog. These items must be added using the Custom Products feature. Please contact your Partner Sales Manager <br/>List of the Unavailable products are available in the "Download Unavailable Products" link provided below   <br/> The Unavailable Products are :<br/>'+store.removeStart(',') ); 
	ApexPages.addMessage(errorMessage2);
			}
			
			if(!pCodFinalCheck.isEmpty() && pCodFinalCheck != null){		
	errorMessage = new ApexPages.Message(ApexPages.Severity.Info,' Products loaded successfully.. ');
	ApexPages.addMessage(errorMessage);  
			}
			// For rules that are not marked as Check on Finalization
			
			//Req 6383 Start
			if(proposal.NokiaCPQ_Is_Maintenance_Quote__c){		 
	
	acpq.updateMaintenanceLineItem(cartId);
			}
			//Req 6383 End
			
		}
		//Added by Christie JJ: rqmt 6987
		isCSV = true;
		
	}
	/******  Finalize the cart *******/ 
	public void Finalize(){
		system.debug('finalize ..');
		if(cartId != null){
			acpq.Finalizeproposal(cartId);
			ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.Info,'Product loaded....');
			ApexPages.addMessage(errorMessage);
		}
		
	}
	public void abandonCart(){
		Apttus_CPQApi.CPQ.AbandonCartRequestDO request = new Apttus_CPQApi.CPQ.AbandonCartRequestDO();
		request.CartId = cartId;
		Apttus_CPQApi.CPQ.AbandonCartResponseDO response = Apttus_CPQApi.CPQWebService.abandonCart(request);
		//ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'Success: ' + response.IsSuccess));
		returntoProp();
	}
	
	public PageReference returntoProp(){
		PageReference pg2 = new PageReference('/'+proposalId);
		
		pg2.setRedirect(true);
		return pg2;
	}
	/* public void abandonCart(){
Apttus_CPQApi.CPQ.AbandonCartRequestDO request = new
Apttus_CPQApi.CPQ.AbandonCartRequestDO();
request.CartId = cartId;
Apttus_CPQApi.CPQ.AbandonCartResponseDO response = Apttus_CPQApi.CPQWebService.abandonCart(request); 
ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'Success: ' + response.IsSuccess));

}*/
	/***** Set the five values ******/
	public void setFile()
	{
		system.debug('csvAsString  :'+csvAsString);
		system.debug('csvFileBody  :'+csvFileBody);
		//Added by Christie JJ for rqmt 6987
		if(uploadedFiles.contains(csvAsString)){
			isCSV = true;
			ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR,GlobalConstants.DUPLICATE);
			ApexPages.addMessage(errorMessage);
		}
		else
			isCSV = false;
	}
	
	
	
	
	
	
	
}