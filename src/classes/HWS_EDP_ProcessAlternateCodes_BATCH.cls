/********************************************
	 * @description : Batch job to process Alternate Product Codes, related Products and related Assets
	 * ********************************/
	global with sharing class HWS_EDP_ProcessAlternateCodes_BATCH implements Database.Batchable<sObject>,Schedulable{
	  /****************************************
	* Name : AletnateCode records process
	* Author : TCS
	* Version : 2 (code added for NOKIASC- 28645, on top of existing code)
	* @description : Check EDP delete flag=true for alternate code type = 'CARESID' in alternate code table and with the remove the corresponding CARESID from the product2 and find the product with the nsncode with EDP delete flag=false.
	And search all the assets associated with cares id and change the lookup to the new product
	Schedule the job
	* User Story : NOKIASC- 28645
	/****************************************
	* Name : execute
	* @description : executes the batch class using schedulable instance
	* @param: SchedulableContext
	*****************************************/
	  global void execute(SchedulableContext sc)  
	  {
		HWS_EDP_ProcessAlternateCodes_BATCH batch= new HWS_EDP_ProcessAlternateCodes_BATCH();
		Database.executebatch(batch,1);  
	  } 
	  /****************************************
	* Name : start
	* @description : Retrieves the data from ProductAlternateCode
	* @param: Database.BatchableContext
	* @return : Database.QueryLocator
	*****************************************/
	  global Database.QueryLocator start(Database.BatchableContext bc)
	  {
		String squery = 'select Id, Name, HWS_NSNCode__c, HWS_AlternateCodeType__c, HWS_PartType__c, LastModifiedDate, LastModifiedBy.Name, HWS_IsProcessed__c, HWS_VersionItem__c, HWS_EDP_DeletedAtSource__c, HWS_Unprocessed_Reason__c from HWS_AlternateProductCode__c where HWS_IsProcessed__c = false';
			return database.getQueryLocator(squery);
	  }
	  /****************************************
	* Name : execute
	* @description : Retrieves the data from product serviceable version item staging object
	* @param: Database.BatchableContext, List of Product sales item
	* @return : 
	*****************************************/  
	  global void execute(Database.BatchableContext bc, List<HWS_AlternateProductCode__c> alternatecodes)
	  {   
		try 
		{ 
		  List<HWS_AlternateProductCode__c> toUpdateprodSerAltCode = new List<HWS_AlternateProductCode__c>();
		  Map<String,Id> nsnVerIdMap = new Map<String,Id>();
		  Set<String> nsnCodesforVersion= new Set<String>();
		  Map<String,String> nsncaresCodeMap = new Map<String,String>();
		  Map<String,HWS_AlternateProductCode__c> alternatecodesmap = new Map<String,HWS_AlternateProductCode__c>();
				Set<String> nsnCodesforProducts= new Set<String>();
		  for(HWS_AlternateProductCode__c prodAltCode : alternatecodes){
			if(prodAltCode.HWS_PartType__c =='PART' && prodAltCode.HWS_AlternateCodeType__c == 'CARESID'){
			  nsnCodesforProducts.add(prodAltCode.HWS_NSNCode__c);
			  nsncaresCodeMap.put(prodAltCode.HWS_NSNCode__c,prodAltCode.Name);
				alternatecodesmap.put(prodAltCode.HWS_NSNCode__c,prodAltCode);
			}
			else if(prodAltCode.HWS_PartType__c == 'PART REVISION'){
			   nsnCodesforVersion.add(prodAltCode.HWS_NSNCode__c); 
				}
			}
		List<HWS_VersionItem__c> versionItemList = [Select id,HWS_NSNCode__c from HWS_VersionItem__c where HWS_NSNCode__c in: nsnCodesforVersion and HWS_Source__c='PUMA2'];  
		  if(versionItemList.size()>0){
			for(HWS_VersionItem__c version : versionItemList){
			  nsnVerIdMap.put(version.HWS_NSNCode__c,version.Id);
			}
		  }
		 for(HWS_AlternateProductCode__c prodAltCode : alternatecodes){
				if(prodAltCode.HWS_PartType__c !='PART' ){
						prodAltCode.HWS_VersionItem__c = nsnVerIdMap.get(prodAltCode.HWS_NSNCode__c);
			   if(prodAltCode.HWS_VersionItem__c!=null && !prodAltCode.HWS_EDP_DeletedAtSource__c){
				 prodAltCode.HWS_IsProcessed__c=true; 
			   }
			   if(prodAltCode.HWS_EDP_DeletedAtSource__c)
			   {
				prodAltCode.HWS_VersionItem__c=null;
				prodAltCode.HWS_IsProcessed__c=true; 
			   }
			   toUpdateprodSerAltCode.add(prodAltCode);
			   }
		  }
		  List<Database.SaveResult> resultsalternatecodes1 = Database.update(toUpdateprodSerAltCode,false);
				dmlOperationError(resultsalternatecodes1, 'AlternateCode', null, null, toUpdateprodSerAltCode);
				toUpdateprodSerAltCode.clear();	  
		  List<AggregateResult> groupedResults = [select HWS_NSNCode__c,count(id) from HWS_AlternateProductCode__c where HWS_AlternateCodeType__c ='CARESID' and HWS_PartType__c ='PART' 
														and HWS_NSNCode__c in :nsnCodesforProducts group by HWS_NSNCode__c having count(id) > 1];
		  List<String> multipleNsnCodes = new List<String>();
				if(groupedResults.size()>0){
					for (AggregateResult ar : groupedResults)  {
						String i = (String) ar.get('HWS_NSNCode__c');
						multipleNsnCodes.add(i);
					}
				}
		  List<HWS_AlternateProductCode__c> altProdCodeListWithMultipleCaresId = [Select Id, Name, HWS_NSNCode__c, HWS_Unprocessed_Reason__c from HWS_AlternateProductCode__c where HWS_NSNCode__c in :multipleNsnCodes];
		  List<String> multipleCaresIdList = new List<String>();
		  if(altProdCodeListWithMultipleCaresId.size() > 0){
					List<HWS_AlternateProductCode__c> toUpdatemultipleAltCode = new List<HWS_AlternateProductCode__c>();
			for(HWS_AlternateProductCode__c altCode : altProdCodeListWithMultipleCaresId){
			  altCode.HWS_Unprocessed_Reason__c = 'Multiple CARES ID Issue';
			  altCode.HWS_IsProcessed__c = false;
			  multipleCaresIdList.add(altCode.HWS_NSNCode__c);
			  toUpdatemultipleAltCode.add(altCode); 
			}
			//NOKIASC-28651 -- multiple CARESID for 1 NSN Code
			List<Database.SaveResult> resultsmultiplealternatecodes1 = Database.update(toUpdatemultipleAltCode,false);
			dmlOperationError(resultsmultiplealternatecodes1, 'AlternateCode', null, null, toUpdatemultipleAltCode);
			  toUpdatemultipleAltCode.clear();
		  }
		  //NOKIASC-28645 -- remove CARESID from Product where EDP delete flag in the AlternateCode was true
		  List<Product2> listProd = [Select id, ProductCode, CARE_PartCode__c from Product2 where ProductCode in:nsnCodesforProducts and ProductCode not in :multipleCaresIdList and HWS_DoNotConsider__c=false ];
		  List<Product2> listProdNew = new List<Product2>();
		  List<Product2> listProdNew1 = new List<Product2>();
		  Set<String> oldCaresId = new Set<String>();
		  Map<String, String> caresProdIdMap = new Map<String, String>();
		  if(listProd.size()>0){
			for(Product2 prod : listProd){
			  Product2 newProd = new Product2(); 
			  newProd.Id = prod.Id;
			  if(!alternatecodesmap.isEmpty()){
				//NOKIASC-28645
				if(alternatecodesmap.get(prod.ProductCode).HWS_EDP_DeletedAtSource__c){
				  oldCaresId.add(prod.id);
				  newProd.CARE_PartCode__c = '';
				  listProdNew.add(newProd);
				}
				else{
				  newProd.CARE_PartCode__c = nsncaresCodeMap.get(prod.ProductCode);
				  caresProdIdMap.put(newProd.CARE_PartCode__c, newProd.Id);
				   listProdNew1.add(newProd);
			  
				} 
			  }
			  if(newProd.CARE_PartCode__c !=null)
			  {
				HWS_AlternateProductCode__c altcode= alternatecodesmap.get(prod.ProductCode);
				if(!multipleNsnCodes.contains(altcode.HWS_NSNCode__c)){
				  altcode.HWS_IsProcessed__c=true;
				  altcode.HWS_Unprocessed_Reason__c = '';
				  toUpdateprodSerAltCode.add(altcode);
				}
			  }
		   //NOKIASC-28650 -- Added HWS_Unprocessed_Reason__C field value as 'Sales Item not found in ENOVIA/ALPIM' for the records where no corresponding nsn code was found in Product2 record
				nsnCodesforProducts.remove(prod.ProductCode); 
		  } 
		  for(String nsnCode : nsnCodesforProducts){
			  HWS_AlternateProductCode__c altcode= alternatecodesmap.get(nsnCode);
			  if(!multipleNsnCodes.contains(altcode.HWS_NSNCode__c)){
				altcode.HWS_IsProcessed__c=false;
				altcode.HWS_Unprocessed_Reason__c = 'Sales Item not found in ENOVIA/ALPIM';
				toUpdateprodSerAltCode.add(altcode);
			  }
			}
		  }
		  //NOKIASC-28650 -- Added HWS_Unprocessed_Reason__C field value as 'Sales Item not found in ENOVIA/ALPIM' for the records where no corresponding nsn code was found in Product2 records
		  else{
			if(!alternatecodesmap.isEmpty()){
			  for(String nsnCode : nsnCodesforProducts){
				if(alternatecodesmap.get(nsnCode) != null){
				  HWS_AlternateProductCode__c altcode= alternatecodesmap.get(nsnCode);
				  if(!multipleNsnCodes.contains(altcode.HWS_NSNCode__c)){
					altcode.HWS_IsProcessed__c=false;
					altcode.HWS_Unprocessed_Reason__c = 'Sales Item not found in ENOVIA/ALPIM';
					toUpdateprodSerAltCode.add(altcode);
				  }
				}
			  }
			}
		  }
		  
		  //Defect NOKIASC-35317 : Restored all the update statements
		  // if CARES ID Deleted in alternate code table then remove from Product2 from caresid fied
		  Boolean isError = false;	  
		  if(listProdNew.size() > 0){  
						List<Database.SaveResult> resultscares = Database.update(listProdNew,false);
						isError = dmlOperationError(resultscares, 'Product_caresid_blank', listProdNew, null, null);
						listProdNew.clear();
		  }
		 // Map Cares id from Alternate code table to product2 table
		  if(listProdNew1.size() > 0){
			  List<Database.SaveResult> resultscares1 = Database.update(listProdNew1,false);
					isError = dmlOperationError(resultscares1, 'Product_caresid_populate', listProdNew1, null, null);
					listProdNew1.clear();
		   }
		  
		  //NOKIASC-28645 -- Find Assets still linked with old product and CARESID and replace the lookup with new product and CARESID
		  List<Asset> listAssetNew = new List<Asset>();
				if(oldCaresId.size() > 0){
			List<Asset> assetList = [select id, name, product2Id, HWS_CDB_ExternalAssetId__c, HWS_Part_Code__c, HWS_SourceSystem__c, HWS_CaresIdFromExternalId__c, Product2.HWS_NSNPartCode__c, Product2.ProductCode, Product2.CARE_PartCode__c 
						 from Asset 
						 where HWS_CDB_ExternalAssetId__c != null AND HWS_SourceSystem__c = 'Puma2' AND product2id in:oldCaresId];
					if(!assetList.isEmpty()){
						for(Asset asset : assetList){
							if(caresProdIdMap.get(asset.HWS_CaresIdFromExternalId__c) != null){ //only update assets if new products are present, else not
								asset.Product2Id = caresProdIdMap.get(asset.HWS_CaresIdFromExternalId__c);
								listAssetNew.add(asset); 
							}
						}
					}
		  }
		  if(listAssetNew.size() > 0 && !isError){
					   List<Database.SaveResult> resultsAssets = Database.update(listAssetNew,false); 
					   dmlOperationError(resultsAssets, 'Asset', null, listAssetNew, null);
					   listAssetNew.clear();
		   }
		 List<Database.SaveResult> resultsalternatecodes = Database.update(toUpdateprodSerAltCode,false);
		 dmlOperationError(resultsalternatecodes, 'AlternateCode', null, null, toUpdateprodSerAltCode);
		  toUpdateprodSerAltCode.clear();
		  nsnVerIdMap.clear(); 
		  nsnCodesforVersion.clear();
		  nsncaresCodeMap.clear();
		  alternatecodesmap.clear();	   
		}  
		catch (Exception e) { 
		  System.debug(LoggingLevel.DEBUG,'An unexpected error has occurred: ' + e.getMessage());
		} 
	  }
	  /****************************************
	* Name : finish
	* @description : 
	* @param: Database.BatchableContext
	* @return : 
	*****************************************/ 
	  global void finish(Database.BatchableContext bc)
	  {
		HWS_EDP_BuildRelation_Product_Part batch = new HWS_EDP_BuildRelation_Product_Part();
		Database.executebatch(batch,2000);  
	  }
	  //Method to log interface log objects whenever thers is error in the Database.Saveresult lists 
	  public Boolean dmlOperationError(List<Database.SaveResult> dmlList, String objectUsed, List<Product2> prodList, List<Asset> assetList, List<HWS_AlternateProductCode__c> alternateCodeList){
		try{
		  List<interface_log__c> ilogs = new List<interface_log__c>();
		  for(Integer index = 0, size = dmlList.size(); index < size; index++) {
			if(!dmlList[index].isSuccess()) {
			  Interface_Log__c ilogpr = new Interface_Log__c();
			  for (Database.Error err : dmlList[index].getErrors()){
				ilogpr.comment__c = 'Fields: '+err.getFields()+'Message: '+err.getMessage()+
				  'Status Code: '+err.getStatusCode();
			  }
			  ilogpr.Message_Type__c = 'Inbound';
			  ilogpr.Operation_Type__c = 'update';
			  ilogpr.Status__c = 'Failure';
			  if(objectUsed == 'Product_caresid_blank'){
				ilogpr.Interface_Type__c = 'PMDSOR-HWS Product Cares Id Update :Product_caresid_blank ';
				ilogpr.Name = 'Product Cares Id update Failure with NSNCode: '+ prodList[index].ProductCode;
			  }
			  else if(objectUsed == 'Asset'){
				ilogpr.Interface_Type__c = 'PMDSOR-HWS Product Lookup on Asset ';
				ilogpr.Name = 'Product lookup on Asset Failure with NSNCode: '+ assetList[index].Product2.HWS_NSNPartCode__c;
			  }
			  else if(objectUsed == 'AlternateCode'){
				ilogpr.Interface_Type__c = 'PMDSOR-HWS  AletnateCode for Part Revision';
				ilogpr.Name = 'HWS Alternate Code update Failure with NSNCode: '+ alternateCodeList[index].HWS_NSNCode__c;
			  }
						else if(objectUsed == 'Product_caresid_populate'){
				ilogpr.Interface_Type__c = 'PMDSOR-HWS Product Cares Id Update :Product_caresid_populate ';
				ilogpr.Name = 'Product Cares Id update Failure with NSNCode: '+ prodList[index].ProductCode;
			  }
			  ilogs.add(ilogpr);
			}
		  }
		  if(!ilogs.isEmpty()){
					//Commenting unused variable results - NOKIASC-32425
					Database.SaveResult[] results = Database.insert(ilogs,false);
					Database.insert(ilogs);
					return true;
				}
				return false;
		}
		catch(DMLException e){
		  System.debug(LoggingLevel.DEBUG,'There was an error during DML Operation'+e.getMessage());
		  return true;
		}
	  }
	}