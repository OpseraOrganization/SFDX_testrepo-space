/**************************************************************************************
* @Description  This class is used to upload product SSF and validate that bom and add them to cart
**************************************************************************************/
public with sharing class CPQ_SSFUploadController {
	public static List<String> colmns;
	public static List<String> quoteColmns = new List<String>();
	public static CPQ_QTC_CartServices.QuoteData quoteData  = new CPQ_QTC_CartServices.QuoteData();
	// private static String configId;
	/**************************************************************************************
	* @Description  This methods is just used to uploadSSF
	* @Return
	* It will retum Uploaded SSF data and column
	* @Example	 
	* CPQ_SSFUploadController.uploadSSF('filedata') 
	**************************************************************************************/
	@AuraEnabled
	public static WrapperData uploadSSF(String base64Data, String configId) {
		System.debug('config id: ' + configId);
		base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
		WrapperData wrapper = new WrapperData();
		wrapper.csvData = readCSVRecords(EncodingUtil.base64Decode(base64Data).toString(), configId);
		wrapper.csvCol = colmns;
		wrapper.csvQuoteCol = quoteColmns;
		wrapper.csvQuoteData = quoteData;
		return wrapper;
	}
	
	/**************************************************************************************
	* @Description  This methods is just used to parse the uploaded BOM data
	* @Return
	* It will retum Uploaded BOM data
	* @Example	 
	* CPQ_SSFUploadController.readCSVRecords('filedata')
	**************************************************************************************/
	public static List<CPQ_QTC_CartServices.ProductData> readCSVRecords(String fileData, Id configId){
		List<String> recordData = fileData.split('\n');
		for(String strData: recordData){
			System.debug('===strData=='+strData);
		}

		List<CPQ_QTC_CartServices.ProductData> pdtList = new List<CPQ_QTC_CartServices.ProductData>();
		if(recordData[0].contains(System.Label.SSF_CSV_Header)){
			
			for(String rec : recordData){
				rec = handleCommaInCSV(rec);
				system.debug('===rec==='+rec);
				String colName;
				if(rec.contains('#Header|resellername')){
					quoteColmns = rec.split('\\|');
					system.debug('==47=rec==='+rec);
				}else if(rec.contains('#Header')){
					system.debug('==49=rec==='+rec);
					CPQ_QTC_CartServices.QuoteData quoteDt = new CPQ_QTC_CartServices.QuoteData();
					List<String> fields = rec.split('\\|');
					system.debug('fields :: '+fields);
					if(String.isNotBlank(fields[1])) {
						quoteDt.resellername = fields[1];
					}
					if(String.isNotBlank(fields[2])) {
						quoteDt.transtype = fields[2];
					}
					if(String.isNotBlank(fields[3])) {
						quoteDt.custtype = fields[3];
					}
					if(String.isNotBlank(fields[4])) {
						quoteDt.purchaseorder = fields[4];
					}
					quoteData = quoteDt;
				}
				
				if(rec.contains('#Services|groupid')){
					colmns = rec.split('\\|');
					system.debug('==54 c=rec==='+rec);
				}else if(rec.contains('#Services')){
					system.debug('==47=rec==='+rec);
					try{
						
						CPQ_QTC_CartServices.ProductData pdt = new CPQ_QTC_CartServices.ProductData();
						List<String> fields = rec.split('\\|');
						system.debug('fields :: '+fields);
						if(String.isNotBlank(fields[1])) {
							pdt.groupid = fields[1];
						}
						if(String.isNotBlank(fields[2])) {
							pdt.quantity = Integer.valueOf(fields[2]);
						}
						if(String.isNotBlank(fields[3])) {
							pdt.serviceoi = fields[3];
						}
						if(String.isNotBlank(fields[4])) {
							pdt.tss_productoi = fields[4];
						}
						if(String.isNotBlank(fields[5])) {
							pdt.tss_productname = fields[5];
						}
						if(String.isNotBlank(fields[6])) {
							pdt.servicedesc = fields[6];
						}
						if(String.isNotBlank(fields[7])) {
							pdt.tss_productOIDescription = fields[7];
						}
						if(String.isNotBlank(fields[8])) {
							pdt.tss_productManufacturer = fields[8];
						}
						if(String.isNotBlank(fields[9])) {
							pdt.startDate = fields[9];
						}
						if(String.isNotBlank(fields[10])) {
							pdt.endDate = fields[10];
						}
						if(String.isNotBlank(fields[11])) {
							pdt.term = fields[11];
						}
						if(String.isNotBlank(fields[12])) {
							pdt.tss_unitRate = fields[12];
						}
						if(String.isNotBlank(fields[13])) {
							pdt.extunitrate = fields[13];
						}
						if(String.isNotBlank(fields[14])) {
							pdt.tss_oneTimeCharge = fields[14];
						}
						if(String.isNotBlank(fields[15])) {
							pdt.extonetimecharge = fields[15];
						}
						if(String.isNotBlank(fields[16])) {
							pdt.unitdisc = fields[16];
						}
						if(String.isNotBlank(fields[17])) {
							pdt.tss_discUnitRate = fields[17];
						}
						if(String.isNotBlank(fields[18])) {
							pdt.extdiscunitrate = fields[18];
						}
						if(String.isNotBlank(fields[19])) {
							pdt.onetimedisc = fields[19];
						}
						if(String.isNotBlank(fields[20])) {
							pdt.disconetimecharge = fields[20];
						}
						if(String.isNotBlank(fields[21])) {
							pdt.extdisconetimecharge = fields[21];
						}
						if(String.isNotBlank(fields[22])) {
							pdt.adjusttype = fields[22];
						}
						if(String.isNotBlank(fields[23])) {
							pdt.priceclass = fields[23];
						}
						pdt.status = 'Success';
						pdtList.add(pdt);
					}
					Catch(Exception e){
						system.debug('Harsh :: '+ e.getStackTraceString() + e.getMessage());
						throw new AuraHandledException('Invalid SSF Format. We got an issue in the parsing of '+ colName + ' column data.'); 
					}
				}
			}
			CPQ_QTC_CartServices.validateSSF(configId, pdtList);
			System.debug('validated pdtList: ' + pdtList);
		}else{
			throw new AuraHandledException('CSV file does not match the expected content!'); 
		}
		return pdtList;
	}
	
	private static String handleCommaInCSV(String csvLine){
		String prevLine = csvLine;
		Integer startIndex;
		Integer endIndex;
		
		while(csvLine.indexOf('"') > -1){
			
			if(startIndex == null){
				startIndex = csvLine.indexOf('"');
				csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
			}else{
				if(endIndex == null){
					endIndex = csvLine.indexOf('"');
					csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
				}
			}
			
			if(startIndex != null && endIndex != null){
				String sub = csvLine.substring(startIndex, endIndex);
				sub = sub.replaceAll(',', ':comma:');
				csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
				startIndex = null;
				endIndex = null;
			}
		}
		
		System.debug('prevLine:::'+prevLine);
		System.debug('csvLine:::'+csvLine);
		return csvLine;
	}
	
	
	/**************************************************************************************
	* @Description  This methods validates uploaded product codes adds the product to cart
	* @Return		
	* @Example	 
	* FileUploadController.addProductsToCart(cartconfigId, bomdata)
	**************************************************************************************/
	@AuraEnabled
	public static void addProductsToCart(Id configId, String productsToAddJsn, String quoteDataJsn) {
		List<CPQ_QTC_CartServices.ProductData> productsToAdd = (List<CPQ_QTC_CartServices.ProductData>)JSON.deserialize(productsToAddJsn, List<CPQ_QTC_CartServices.ProductData>.class); 
		CPQ_QTC_CartServices.QuoteData quoteData = (CPQ_QTC_CartServices.QuoteData)JSON.deserialize(quoteDataJsn, CPQ_QTC_CartServices.QuoteData.class); 
		System.debug('products to add: ' + productsToAdd);
		System.debug('products to add: ' + quoteData);
		try {

			CPQ_QTC_CartServices.updateQuote(configId, quoteData);
			
			//List<CPQ_QTC_CartServices.ProductData> sequencedProductData = CPQ_QTC_CartServices.addSequencingAndOptions(configId, productsToAdd);
			//add products cart
			CPQ_QTC_CartServices.addProductsToCartSSF(configId, productsToAdd); 
			//reprice
			//repriceCart(configId);
		} catch(Exception e) {
			System.debug('Exception: addProductsToCart: ' + e.getStackTraceString());
			throw new AuraHandledException('Some unexpected error occured. Please try again.'); 
		}
	}

	
	
	/**************************************************************************************
	* @Description  This wrapper class is used to bind uploaded BOM column and Data
	**************************************************************************************/
	public class WrapperData{
		@AuraEnabled public List<String> csvCol;
		@AuraEnabled public List<String> csvQuoteCol;
		@AuraEnabled public List<CPQ_QTC_CartServices.ProductData> csvData;
		@AuraEnabled public CPQ_QTC_CartServices.QuoteData csvQuoteData;
	}
	
	@AuraEnabled
	public static Boolean repriceCart(Id cartId) {
		Boolean IsPricePending = false;

		List<Apttus_Config2__ProductConfiguration__c> config =  [select Apttus_QPConfig__Proposald__r.Is_Turbo_Pricing__c from Apttus_Config2__ProductConfiguration__c where id = :cartId];
		
		if(config == null || config.isEmpty()) return false;

		if(config[0].Apttus_QPConfig__Proposald__r.Is_Turbo_Pricing__c) {
			return false;
		}
		
		Apttus_CPQApi.CPQ.UpdatePriceRequestDO priceReqDO = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
		priceReqDO.cartID = cartId;
		Apttus_CPQApi.CPQ.UpdatePriceResponseDO priceRespDO = Apttus_CPQApi.CPQWebService.updatePriceForCart(priceReqDO);	
		List<Decimal> complLineNums = priceRespDO.CompletedLineNumbers;
		System.debug('completed li: ' + complLineNums);
		IsPricePending = priceRespDO.IsPricePending;
		List<Decimal> PendingLineNumbers = priceRespDO.PendingLineNumbers;
		System.debug('pending li: ' + PendingLineNumbers);
		system.debug('IsPricePending :'+ IsPricePending);
		return IsPricePending;
	}
}