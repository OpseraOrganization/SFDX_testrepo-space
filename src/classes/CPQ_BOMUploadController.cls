/**************************************************************************************
* @Description  This class is used to upload product BOm and validate that bom and add them to cart
**************************************************************************************/
public with sharing class CPQ_BOMUploadController {
	public static List<String> colmns;
	// private static String configId;
	/**************************************************************************************
	* @Description  This methods is just used to uploadBOM
	* @Return
	* It will retum Uploaded BOM data and column
	* @Example	 
	* CPQ_BOMUploadController.uploadBOM('filedata') 
	**************************************************************************************/
	@AuraEnabled
	public static WrapperData uploadBOM(String base64Data, String configId) {
		System.debug('config id: ' + configId);
		base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
		
		WrapperData wrapper = new WrapperData();
		wrapper.csvData = readCSVRecords(EncodingUtil.base64Decode(base64Data).toString(), configId);
		wrapper.csvCol = colmns;
		return wrapper;
	}
	
	/**************************************************************************************
	* @Description  This methods is just used to parse the uploaded BOM data
	* @Return
	* It will retum Uploaded BOM data
	* @Example	 
	* CPQ_BOMUploadController.readCSVRecords('filedata')
	**************************************************************************************/
	public static List<CPQ_QTC_CartServices.ProductData> readCSVRecords(String fileData, Id configId){
		List<String> recordData = fileData.split('\n');
		
		List<CPQ_QTC_CartServices.ProductData> pdtList = new List<CPQ_QTC_CartServices.ProductData>();
		if(recordData[0].contains(System.Label.CSVHeader)){
			
			for(String rec : recordData){
				rec = handleCommaInCSV(rec);
				String colName;
				
				if(rec.contains('Line No')){
					colmns = rec.split(',');
				}else{
					try{
						CPQ_QTC_CartServices.ProductData pdt = new CPQ_QTC_CartServices.ProductData();
						List<String> fields = rec.split(',');
						system.debug('fields :: '+fields);
						
						colName = colmns[0];
						if(String.isNotBlank(fields[0])) {
							pdt.bomLineNumber = Integer.ValueOf(fields[0]);
						}
						
						colName = colmns[1];
						pdt.productCode = fields[1];
						
						colName = colmns[2];
						if(String.isNotBlank(fields[2])) {
							pdt.parentLineNumber = Integer.ValueOf(fields[2]);
						}
						
						colName = colmns[3];
						if(String.isNotBlank(fields[3])) {
							pdt.quantity = Integer.ValueOf(fields[3]);
						}
						
						colName = colmns[4];
						if(fields.size() > 4 && String.isNotBlank(fields[4])) {
							pdt.proposedPrice = Decimal.ValueOf(fields[4]);
						}
						
						colName = colmns[5];
						if(fields.size() > 5) {
							pdt.productDescription = fields[5].replaceAll(':quotes:', '').replaceAll(':comma:', ',');
						}

						colName = colmns[6];
						if(fields.size() > 6 && String.isNotBlank(fields[6])) {
							pdt.subHeading = fields[6].trim();
						}
						colName = colmns[7];
						if(fields.size() > 7 && String.isNotBlank(fields[7])) {
							pdt.flexibleGroup = fields[7].trim();
						}
						/*
						colName = colmns[6];
						if(fields.size() > 6 && String.isNotBlank(fields[6])) {
							pdt.rollupGrpNo = Integer.ValueOf(fields[6]);
						}
						
						colName = colmns[7];
						if(fields.size() > 7 && String.isNotBlank(fields[7])) {
							pdt.rollupGrpParent = fields[7];
						}
						*/
						pdt.status = 'Success';
						pdtList.add(pdt);
					}
					Catch(Exception e){
						system.debug('BOM Upload: Format Failed :: '+ e.getStackTraceString() + e.getMessage());
						throw new AuraHandledException('Invalid BOM Format. We got an issue in the parsing of '+ colName + ' column data.'); 
					}
				}
			}
			try {
				CPQ_QTC_CartServices.validateBOM(configId, pdtList);
			} catch(Exception e) {
				system.debug('BOM Upload: Validation Error :: '+ e.getStackTraceString() + e.getMessage());
				throw new AuraHandledException('Some unexpected error occured. Validation failed.');
			}
		}else{
			throw new AuraHandledException('CSV file does not match the expected format!'); 
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
	public static void addProductsToCart(Id configId, List<CPQ_QTC_CartServices.ProductData> productsToAdd) {
		System.debug('products to add: ' + productsToAdd);
		try {
			List<CPQ_QTC_CartServices.ProductData> sequencedProductData = CPQ_QTC_CartServices.addSequencingAndOptions(configId, productsToAdd);
			//add products cart
			CPQ_QTC_CartServices.addProductsToCart(configId, sequencedProductData); 
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
		@AuraEnabled public List<CPQ_QTC_CartServices.ProductData> csvData;
	}
	
	@AuraEnabled
	public static Boolean repriceCart(Id cartId) {
		Boolean IsPricePending = true;
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