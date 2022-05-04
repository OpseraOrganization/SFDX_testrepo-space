/****************************************
 * Name : PMDSoRStagingDataUtil
 * Author : Standav
 * Description : This class is for loading data from PMDSoR to staging table and from staging to productmaster
 * Note: Test methods are written in class: Batch_PMDSoRToStagingDataLoadTest
****************************************/
public without sharing class PMDSoRStagingDataUtil {
	
	public static String responseStatus = '';
	public static Integer responseStatusCode;
	public static Integer successRecordCount = 0;
	public static Integer errorRecordCount = 0;

	/****************************************
		 * Name : loadSIToStagingObject
		 * Description : Load Sales Item data to Staging object
		 * Parameters: HttResponse
		 * Returns: List of staging object
	 *****************************************/
	public static List<CPQ_PMDSOR_Staging_Data__c> loadSIToStagingObject(HttpResponse response){
		responseStatus = response.getStatus();
		responseStatusCode = response.getStatuscode();

		List<CPQ_PMDSOR_Staging_Data__c> stagingDataList = new List<CPQ_PMDSOR_Staging_Data__c>();

		try {
			//Deserializing response
			List<PMDSOR_SalesItem> salesItemsList = (List<PMDSOR_SalesItem>)System.JSON.deserialize(response.getBody().substring(response.getBody().indexOf('['), response.getBody().lastIndexOf(']')+1), List<PMDSOR_SalesItem>.class);
			
			System.debug('PMDSOR Sales Item size: '+salesItemsList.size());
		
			//Clear the response once its processed, to clear heap size
			response = null;

			//Process each salesitem and add it to  sales items list	 
			Set<String> prod_code_set = new Set<String>();

			//store the productcode from the pmdsor response
			Set<String> pmdsorProductSet = new Set<String>();
			for(PMDSOR_SalesItem si :  salesItemsList) {
				pmdsorProductSet.add(si.NSNCode);
			}

			//this will store qtc products that are already exisiting in the product2 and staing object. 
			Set<String> existingQTCProducts = new Set<String>();

			List<Product2> existingProd2List = [Select Id, ProductCode FROM Product2 WHERE ProductCode IN :pmdsorProductSet AND CPQ_Stream__c INCLUDES('QTC')];
			List<CPQ_PMDSOR_Staging_Data__c> existingStgProdList = [Select Id, NSNCode__c FROM CPQ_PMDSOR_Staging_Data__c WHERE NSNCode__c IN :pmdsorProductSet];
			
			for(Product2 prod :  existingProd2List) {
				existingQTCProducts.add(prod.ProductCode);
			}
			existingProd2List.clear();
			for(CPQ_PMDSOR_Staging_Data__c stgProd :  existingStgProdList) {
				existingQTCProducts.add(stgProd.NSNCode__c);
			}
			existingStgProdList.clear();

			CPQ_PMDSOR_Staging_Data__c siStaging;
			for(PMDSOR_SalesItem si :  salesItemsList) {
				siStaging = new CPQ_PMDSOR_Staging_Data__c();
				siStaging.NSNCode__c = si.NSNCode;
				siStaging.BusinessGroup__c = si.BusinessGroup;
				siStaging.BusinessUnit__c = si.BusinessUnit;
				siStaging.PMDSOR_SI_UpdateDateTime__c = si.PMDSOR_UpdateDateTime;
				siStaging.NSN_Published_to_QtC__c = false;
				siStaging.Current_Status__c = si.Current;
				siStaging.Is_Data_Processed__c = false;
				siStaging.Is_Partial_Success__c = false;
				siStaging.Processing_Status__c  = null;
				for(PMDSOR_MainAttributes attr : si.MainAttributes) {
					if(String.isNotBlank(attr.Name)) {
						if(attr.Name.equalsIgnoreCase(PMDI_Constants.PMDSOR_SI_NSN_PUBLISHED_TO_QTC)) {
							siStaging.NSN_Published_to_QtC__c = attr.Value.equalsIgnoreCase('TRUE') ? true : false;
						} else if(attr.Name.equalsIgnoreCase(PMDI_Constants.PMDSOR_SI_NSN_SECONDARY_CATEGORY)) {
							siStaging.NSN_Secondary_Category__c = attr.Value;
						} else if(attr.Name.equalsIgnoreCase(PMDI_Constants.PMDSOR_SI_NSN_TERTIARY_CATEGORY)) {
							siStaging.NSN_Tertiary_Category__c = attr.Value;
						} else if(attr.Name.equalsIgnoreCase('NSN Reference Price Currency')) {//todo - move it to pmdiconstants
							siStaging.NSN_Reference_Price_Currency__c = attr.Value;
						} else if(attr.Name.equalsIgnoreCase('NSN Reference Price')) {//todo - move it to pmdiconstants
							try {
								siStaging.NSN_Reference_Price__c = Decimal.valueOf(attr.Value);
							} catch(Exception ex) {
								System.debug('PMDSOR Staging NSN Pricing Data conversion error: ' + ex.getStackTraceString());
							}
						}
					}
				}

				if((siStaging.NSN_Published_to_QtC__c || existingQTCProducts.contains(siStaging.NSNCode__c)) && !prod_code_set.contains(siStaging.NSNCode__c)) {
					stagingDataList.add(siStaging);
					prod_code_set.add(siStaging.NSNCode__c);
				}
			}
			System.debug('si staging wrapper data: ' + stagingDataList);
			salesItemsList.clear();
			prod_code_set.clear();
			existingQTCProducts.clear();

		} catch (Exception ex) {
			ExceptionHandler.addException(ex, 'PMDSoRStagingDataUtil', 'loadSIToStagingObject');
		}
		return stagingDataList;
	}

   
	/****************************************
	 * Name : loadPCIToStagingObject
	 * Description : Load Product Configuration Item data to Staging object
	 * Parameters: List<PMDSOR_PCI>
	 * Returns: List of staging object
	 *****************************************/
	public static List<CPQ_PMDSOR_Staging_Data__c> loadPCIToStagingObject(List<PMDSOR_PCI> pciList){

		List<CPQ_PMDSOR_Staging_Data__c> stagingDataList = new List<CPQ_PMDSOR_Staging_Data__c>();
		Map<String, CPQ_PMDSOR_Staging_Data__c> stagingDataMap = new Map<String, CPQ_PMDSOR_Staging_Data__c>();
		Map<String, String> qtcChildNSNCodeToParentNSNCodeMap = new Map<String, String>();
		Map<String, Set<String>> qtcParenNSNCodeToChildrenNSNCodeMap = new Map<String, Set<String>>();

		try {
			//Deserializing response
			// List<PMDSOR_PCI> pciList = (List<PMDSOR_PCI>)System.JSON.deserialize(response.getBody().substring(response.getBody().indexOf('['), response.getBody().lastIndexOf(']')+1), List<PMDSOR_PCI>.class);
			
			System.debug('PMDSOR qtc PCI size: '+pciList.size());

			System.debug('PCI Relation pciRelationInfoList size: ' + pciList.size());
			Map<String, String> childNSNCodeToParentNSNCodeMap = new Map<String, String>();
			Map<String, String> childNSNCodeToParentNSNCodeMapTemp;//to store the child to parent map temporarily before identifying the correct product configuration record
			for(PMDSOR_PCI pci : pciList) {
				System.debug('parentNSNCOde: ' + pci.NSNCode);
				Boolean isValidPCI = false;
				childNSNCodeToParentNSNCodeMapTemp = new Map<String, String>();
				for(PMDSOR_PCI_RelationInfo ri : pci.RelationInfo) {
					if(String.isNotBlank(ri.RelType)) {
						//for sales items - consider only RelationInfo objects with RelType = "EBOM"
						if(ri.RelType.equalsIgnoreCase(PMDI_Constants.PMDSOR_PCI_VALID_SI_RELATION_INFO_RELTYPE) && String.isNotBlank(ri.ChildNSNCode) && String.isNotBlank(ri.ParentNSNCode)) {
							childNSNCodeToParentNSNCodeMapTemp.put(ri.ChildNSNCode, ri.ParentNSNCode);
						}
						//identify correct parent by checking if the ParentName attribute equals Portfolio Element
						if(ri.RelType.equalsIgnoreCase(PMDI_Constants.PMDSOR_PCI_VALID_RELATION_INFO_RELTYPE) && String.isNotBlank(ri.ParentType) && String.isNotBlank(ri.ParentName) && ri.ParentType.equalsIgnoreCase(PMDI_Constants.PMDSOR_PCI_VALID_RELATION_INFO_PARENTTYPE) && ri.ParentName.equalsIgnoreCase(PMDI_Constants.PMDSOR_PCI_VALID_RELATION_INFO_PARENTNAME)) {
							isValidPCI = true;
						}
					}
				}
				System.debug('>>>Is valid PCI: ' + isValidPCI);
				//if a valid ProductConfigurationParent is found add the temporary map to original map
				if(isValidPCI && !childNSNCodeToParentNSNCodeMapTemp.isEmpty()) {
					childNSNCodeToParentNSNCodeMap.putAll(childNSNCodeToParentNSNCodeMapTemp);
				}
			}

			//identify qtc related products
			//get list of qtc productcodes from product2 master data
			List<Product2> qtcProdList = [SELECT Id, ProductCode FROM Product2 WHERE CPQ_Stream__c INCLUDES ('QTC') AND ProductCode IN : childNSNCodeToParentNSNCodeMap.keySet()];
			//get list of qtc productcodes from pmdsor staging data
			List<CPQ_PMDSOR_Staging_Data__c> stagingDataProducts = [SELECT Id, NSNCode__c FROM CPQ_PMDSOR_Staging_Data__c WHERE NSNCode__c IN : childNSNCodeToParentNSNCodeMap.keySet()];

			Set<String> qtcProductCodes = new Set<String>();
			for(Product2 prod : qtcProdList) {
				qtcProductCodes.add(prod.ProductCode);
			}
			for(CPQ_PMDSOR_Staging_Data__c prodStage : stagingDataProducts) {
				qtcProductCodes.add(prodStage.NSNCode__c);
			}

			// store only the qtc product child to parent and parent children maps
			if(!qtcProductCodes.isEmpty()) {
				for(String prodCode : qtcProductCodes) {
					if(childNSNCodeToParentNSNCodeMap.containsKey(prodCode)) {

						//store qtc child to parent map
						//qtcChildNSNCodeToParentNSNCodeMap.put(prodCode, childNSNCodeToParentNSNCodeMap.get(prodCode));

						//store parent to qtc children map
						if(qtcParenNSNCodeToChildrenNSNCodeMap.containsKey(childNSNCodeToParentNSNCodeMap.get(prodCode))) {
							qtcParenNSNCodeToChildrenNSNCodeMap.get(childNSNCodeToParentNSNCodeMap.get(prodCode)).add(prodCode);
						} else {
							qtcParenNSNCodeToChildrenNSNCodeMap.put(childNSNCodeToParentNSNCodeMap.get(prodCode), new Set<String>{prodCode});
						}

					}
				}

				System.debug('findNSNParent: qtcParenNSNCodeToChildrenNSNCodeMap: ' + qtcParenNSNCodeToChildrenNSNCodeMap);
			}

			//Process each qtc salesitem and add it to  staging list
			if(!qtcParenNSNCodeToChildrenNSNCodeMap.isEmpty()) {
				Set<String> prod_code_set = new Set<String>();
			
				for(PMDSOR_PCI pci :  pciList) {
					String parentNSNCode = pci.NSNCode;
				
					if(String.isNotBlank(parentNSNCode) && qtcParenNSNCodeToChildrenNSNCodeMap.containsKey(parentNSNCode)) {
						String reportingStructure = '';
						for(PMDSOR_MainAttributes attr : pci.MainAttributes) {
							if(attr.Name.equalsIgnoreCase(PMDI_Constants.PMDSOR_SI_NSN_FINANCE_REPORTING_STRUCTURE)) {
								reportingStructure = attr.Value;
							}
						}
						CPQ_PMDSOR_Staging_Data__c pciStaging;
						for(String childCode : qtcParenNSNCodeToChildrenNSNCodeMap.get(parentNSNCode)) {
							pciStaging = new CPQ_PMDSOR_Staging_Data__c();
							pciStaging.NSNCode__c = childCode;
							pciStaging.ParentNSNCode__c = parentNSNCode;
							pciStaging.NSN_Published_to_QtC__c = true;
							pciStaging.PMDSOR_PCI_UpdateDateTime__c = pci.PMDSOR_UpdateDateTime;
							if(String.isNotBlank(pci.BusinessGroup)) {
								pciStaging.BusinessGroup__c = pci.BusinessGroup;
							}
							if(String.isNotBlank(pci.BusinessUnit)) {
								pciStaging.BusinessUnit__c = pci.BusinessUnit;
							}
							pciStaging.Is_Data_Processed__c = false;
							pciStaging.Is_Partial_Success__c = false;
							pciStaging.Processing_Status__c  = null;
							if(String.isNotBlank(reportingStructure)) {
								pciStaging.NSN_Finance_Reporting_Structure__c = reportingStructure;

								List<string> split_reportingStructure = reportingStructure.split('\\\\');
								Integer splitSize = split_reportingStructure.size();
								if(splitSize >= 4) {
									pciStaging.Finance_Reporting_BG__c = split_reportingStructure[splitSize - 4];
									pciStaging.Finance_Reporting_BU__c = split_reportingStructure[splitSize - 3];
									pciStaging.Finance_Reporting_BL_Code__c = split_reportingStructure[splitSize - 2];
									pciStaging.Finance_Reporting_PP_Code__c = split_reportingStructure[splitSize - 1];
								}
							}
							if(!prod_code_set.contains(pciStaging.NSNCode__c)) {
								stagingDataList.add(pciStaging);
								prod_code_set.add(pciStaging.NSNCode__c);
							}
							if(!stagingDataMap.containsKey(pciStaging.NSNCode__c) || String.isNotBlank(reportingStructure)) {
								stagingDataMap.put(pciStaging.NSNCode__c, pciStaging);
							}
						}
					}
				}
				prod_code_set.clear();
			}
			pciList.clear();	
			System.debug('si staging wrapper data: ' + stagingDataList);
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, 'PMDSoRStagingDataUtil', 'loadPCIToStagingObject');
		}
		return stagingDataMap.values();
	}

	/****************************************
		 * Name : updateStagingRecords
		 * Description : Update staging records and create interface logs for sales items load
		 * Parameters: List of sales items, url
		 * Returns: 
	 *****************************************/
	public static void updateStagingRecords(List<CPQ_PMDSOR_Staging_Data__c> stagingData,String calloutAPIURL) {			
		try {
			//Insert product sales item
			List<Database.upsertResult> stagingResult = Database.upsert(stagingData,CPQ_PMDSOR_Staging_Data__c.Fields.NSNCode__c, false);			
			System.debug('Sales Items: Data loaded to sales item..'+stagingResult.size());
		
			// Callout Interface Logs//
			List<interface_log__c> ilogs = new List<interface_log__c>();
	
			String operationType;
			////Staging Interface Logs////
			for(Integer index = 0, size = stagingResult.size(); index < size; index++) {
	operationType = (stagingResult[index].isCreated() ? 'Insert' : 'Update');

	if(!stagingResult[index].isSuccess()) {

		////Staging Error Interface Logs///
		interface_log__c ilog = new interface_log__c();
		for (Database.Error err : stagingResult[index].getErrors()){
			ilog.comment__c = 'Fields: '+err.getFields()+'Message: '+err.getMessage()+
			'Status Code: '+err.getStatusCode();
		}
		
		//ilog_si.comment__c = results_pci[index].getMessage();
		ilog.Interface_Type__c = 'PMDSOR to Staging Table';
		ilog.Message_Type__c = 'Inbound';
		ilog.Operation_Type__c = operationType;
		ilog.Status__c = 'Failure';
		ilog.Interface_Request_Sent__c = 'Request URL: '+calloutAPIURL+ '\n'+
					'NSNCode: '+stagingData[index].NSNCode__c +'\n'+
														'NSN_Finance_Reporting_Structure__c: '+stagingData[index].NSN_Finance_Reporting_Structure__c +'\n'+
														'NSN_Secondary_Category__c: '+stagingData[index].NSN_Secondary_Category__c +'\n'+
														'NSN_Tertiary_Category__c: '+stagingData[index].NSN_Tertiary_Category__c +'\n'+
					'PMDSOR_SI_LastModifiedDate: '+stagingData[index].PMDSOR_SI_UpdateDateTime__c +'\n'+
														'PMDSOR_PCI_LastModifiedDate: '+stagingData[index].PMDSOR_PCI_UpdateDateTime__c;
		ilog.Name = 'SI '+operationType+' Failed with product code: '+stagingData[index].NSNCode__c;
		ilogs.add(ilog);
					errorRecordCount++;
	} else { 
		successRecordCount++;
	 }
			}

			Database.Insert(ilogs,false);	
			System.debug('Interface logs created for:  '+ilogs.size()+'items');
			ilogs.clear(); 
		} catch(Exception e) {
			System.debug('Exception occured while loading data to staging table or interface log. Exception: '+e);
		}
	}

	/****************************************
		 * Name : mapStagingAttributesToProduct
		 * Description : Update the product master with the values from Staging Record
		 * Parameters: Product2 Mster record to be updated, Staging Record from which value is taken
		 * Returns: 
	 *****************************************/
	public static void mapStagingAttributesToProduct(Product2 product, CPQ_PMDSOR_Staging_Data__c stagingitem) {
		Boolean isPartialSuccess = false;
		String statusMessage = '';

		if(stagingitem.NSN_Published_to_QtC__c) { 
			//add stream value
			if(String.isBlank(product.CPQ_Stream__c)) {
				product.CPQ_Stream__c = 'QTC';
			} else if(!product.CPQ_Stream__c.containsIgnoreCase('QTC')) {
				product.CPQ_Stream__c += ';QTC';
			}
		} else if(String.isNotBlank(product.CPQ_Stream__c) && product.CPQ_Stream__c.containsIgnoreCase('QTC')) {
			product.CPQ_Stream__c = product.CPQ_Stream__c.replaceAll('QTC', '');
		}
		
		//map secondary category
		String nsnSecondaryCategory = stagingitem.NSN_Secondary_Category__c;
		if(String.isNotBlank(nsnSecondaryCategory)) {
			if(PMDSoRAttributeMapping.secondaryCategoryValueMapping.containsKey(nsnSecondaryCategory)) {
				product.CPQ_Secondary_Category__c = PMDSoRAttributeMapping.secondaryCategoryValueMapping.get(nsnSecondaryCategory);
			} else if(PMDSoRAttributeMapping.isIncentiveProduct(nsnSecondaryCategory)) {
				product.CPQ_Secondary_Category__c = PMDSoRAttributeMapping.secondaryCategoryValueMapping.get('INCENTIVE');
			} else {
				product.CPQ_Secondary_Category__c = nsnSecondaryCategory;
			}
			//set configuration type and auto cascade for bundle products
			if(PMDSoRAttributeMapping.isBundleProduct(product.CPQ_Secondary_Category__c)) {
				product.Apttus_Config2__ConfigurationType__c = 'Bundle';
			}
		}


		//map tertiary category
		String nsnTertiaryCategory = stagingitem.NSN_Tertiary_Category__c;
		if(String.isNotBlank(nsnTertiaryCategory)) {
			product.CPQ_Tertiary_Category__c = nsnTertiaryCategory;
		}

		
		//map business group
		String bg = stagingitem.BusinessGroup__c;
		if(String.isNotBlank(bg)) {
			product.CPQ_QTC_Business_Group__c = PMDSoRAttributeMapping.getBGMappingValue(bg);
		}

		//map business unit
		String bu = stagingitem.Finance_Reporting_BG__c;
		if(String.isNotBlank(bu)) {
			product.CPQ_QTC_Business_Unit__c = bu;
		}

		//map business line
		String bl = stagingitem.Finance_Reporting_BU__c;
		if(String.isNotBlank(bl)) {
			product.Business_Line2__c = bl;
		}

		//map business line code
		String blCode = stagingitem.Finance_Reporting_BL_Code__c;
		if(String.isNotBlank(blCode)) {
			product.Business_Line_Code__c = blCode;
		}
		//map portfolio package code
		String ppCode = stagingitem.Finance_Reporting_PP_Code__c;
		if(String.isNotBlank(ppCode)) {
			product.NokiaCPQ_Portfolio_Package_Code__c = ppCode;
		}

		if(isPartialSuccess) {
			System.debug('is partial sucess: ' + isPartialSuccess);
			stagingitem.Is_Partial_Success__c = true;
			stagingitem.Processing_Status__c = statusMessage;
		}
	}

	/****************************************
		 * Name : createPCIRelationNextLinkUrl
		 * Description : creates the next url after adding the skip count to the relationInfo
		 * Parameters: current url and skip count
		 * Returns: 
	 *****************************************/
	public static String createPCIRelationNextLinkUrl(String calloutAPI, Integer skipCount) {
		String skipFilter = 'RelationInfo($skip=' + skipCount + ')';
		String baseUrl = calloutAPI.subString(0, calloutAPI.indexOf('RelationInfo'));
		String nextLinkUrl = baseUrl + calloutAPI.subString(calloutAPI.indexOf('RelationInfo')).replace('RelationInfo', skipFilter);
		return nextLinkUrl;
	}

	/****************************************
	 * Name : convertToPCIJsonFormat
	 * Description : convert PCI response to JSON 
	 * Parameters: HttResponse
	 * Returns: List<PMDSOR_PCI>
	 *****************************************/
	public static List<PMDSOR_PCI> convertToPCIJsonFormat(HttpResponse response) {

		List<PMDSOR_PCI> pciList = (List<PMDSOR_PCI>)System.JSON.deserialize(response.getBody().substring(response.getBody().indexOf('['), response.getBody().lastIndexOf(']')+1), List<PMDSOR_PCI>.class);

		return pciList;
	}

	public static void sendEmail(Map<String,String> success_map, Map<String,List<String>> error_map, String Classname){
		try{
			List<String> toAddresses=new List<String>();
			String emailRecipients = System.Label.PMDSOR_Job_Notifications;
			toAddresses.addAll(emailRecipients.split(';'));
			
			String subject;
			if(Classname.equalsIgnoreCase(PMDI_Constants.CLASS_NAME_Batch_PMDSoRToStagingDataLoad)) {
				subject = PMDI_Constants.PMDSOR_NOTIFICATION_SUBJECT;
			} else {
				subject ='PMDSOR Automation Status'; 
			}

			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setSubject(subject);
			mail.setToAddresses(toAddresses);  
			
			String mailBody = 'Batch execution status';

			if(success_map != null){
				for(String successStr : success_map.keySet()){
					mailBody += success_map.get(successStr);
				}
			}
			
			if(error_map != null & !error_map.isEmpty()){
				mailBody += '\n\nFailed Loads \n';	 
				for(String errorStr: error_map.keySet()) {
					mailBody += error_map.get(errorStr)+ '\n';
				} 
			}
			
			mail.setPlainTextBody(mailBody) ;

			Messaging.SendEmailResult[] result= Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
		}
		catch(exception ex) {
			system.debug('ex'+ex.getMessage());
			ExceptionHandler.addException(ex, 'PMDSoRStagingDataUtil', 'sendEmail');
		}		
		
	}


	//Inner class for josn structure of product sales item
	public class PMDSOR_SalesItem{
		public PMDSOR_SalesItem(){}
		public String ID; 
		public String Type; 
		public String Name; 
		public String NSNCode;
		public String Current;
		public String Description;
		public String BusinessGroup; 
		public String BusinessUnit; 
		public DateTime PMDSOR_UpdateDateTime;
		public List<PMDSOR_MainAttributes> MainAttributes;
	}

	public class PMDSOR_MainAttributes {
		public PMDSOR_MainAttributes(){}
		public String ID; 
		public String Name;
		public String Value;
	}

	public class PMDSOR_PCI{
		public PMDSOR_PCI(){}
		public String ID; 
		public String Type; 
		public String Name; 
		public String NSNCode;
		public String Current;
		public String Description;
		public String BusinessGroup; 
		public String BusinessUnit; 
		public DateTime PMDSOR_UpdateDateTime;
		public List<PMDSOR_MainAttributes> MainAttributes;
		public List<PMDSOR_PCI_RelationInfo> RelationInfo;
	}

	public class PMDSOR_PCI_RelationInfo {
		public PMDSOR_PCI_RelationInfo(){}
		public String RelID; 
		public String RelType;
		public String ParentType;
		public String ParentName;
		public String ParentNSNCode;
		public String ChildNSNCode;
	}

}