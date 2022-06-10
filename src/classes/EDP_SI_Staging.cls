/****************************************
	 * Name : EDP_SI_Staging
	 * Author : Accenture
	 * Description : This class is for loading data from edp to sales items and create interface logs
	 * ReqNo : 4560
	 * 08/04/2019 -TCS  : added unit of measure field 
	****************************************/
public class EDP_SI_Staging {
	
	public static String status = '';
	public static Integer statusCode;   
	public static DateTime MaxTimestamp;
	public static Integer successRecordCount = 0;
	
	/****************************************
		 * Name : uploadToStagingTable
		 * Description : load data to Product Sales Item object
		 * Parameters: HttResponse, URL
		 * Returns: List of product sales items
	 *****************************************/
	public static List<Product_Sales_Item__c> uploadToStagingTable(HttpResponse response1, String path){
		
		status = response1.getStatus();
		statusCode = response1.getStatuscode(); 
		String path_SI = path;
	
		try{
		//Deserializing response and passing it to a list
		List<EDPProductSI> productArray = (List<EDPProductSI>)System.JSON.deserialize(response1.getBody().substring(response1.getBody().indexOf('['), response1.getBody().lastIndexOf(']')+1), List<EDPProductSI>.class);
			//System.debug('Product Sales Item: '+productArray);
		System.debug('Product Sales Item size: '+productArray.size());
		
		//Clear the response once its processed, to clear heap size
		response1 = null;
		
		//Process each salesitem in a for loop and add it to product sales items list
		List<Product_Sales_Item__c> productSalesItemList = new List<Product_Sales_Item__c>();			   
		Set<String> prod_code_set = new Set<String>();
		  MaxTimestamp=productArray[0].EDP_LastModifiedDate;
	 
		for(EDPProductSI edp :  productArray)
		{
			
			Product_Sales_Item__c productSale = new Product_Sales_Item__c();
			productSale.NSNCode__c = edp.NSNCode;
			productSale.Type__c = edp.Type;
			productSale.SourceTable__c = edp.SourceTable;
			productSale.Description__c = edp.Description;
			productSale.Lifecycle_Status__c = edp.LifeCycleStatus;
			productSale.NSNSummary__c = edp.NSNSummary;
			productSale.NSNCustomsDescription__c = edp.NSNCustomsDescription;
			productSale.NSNVolume__c = edp.NSNVolume;
			productSale.NSNVolumeUnit__c = edp.NSNVolumeUnit;
			productSale.NSNAbbreviation__c = edp.NSNAbbreviation;
			productSale.NSNGic__c = edp.NSNGic;
			productSale.NSNDesignResponsibility__c = edp.NSNDesignResponsibility;
			productSale.NSNPlanningStatus__c = edp.NSNPlanningStatus;
			productSale.NSNPlanningType__c = edp.NSNPlanningType;
			productSale.Policy__c = edp.Policy;
			productSale.NSNProductHierarchy__c = edp.NSNProductHierarchy;
			productSale.NSNProductLine__c = edp.NSNProductLine;
			productSale.NSNProductSubArea__c = edp.NSNProductSubArea;
			productSale.NSNSalesItemCategory__c = edp.NSNSalesItemCategory;
			productSale.NSNSAPMatnr__c = edp.NSNSAPMatnr;
			productSale.NSNSAPMaterialType__c = edp.NSNSAPMaterialType;
			productSale.NSNSourceSystem__c = edp.NSNSourceSystem;
			productSale.NSNSourceType__c = edp.NSNSourceType;
			productSale.IRP_Price__c = edp.IRPPrice;
			productSale.IRP_Valid_From__c = edp.IRPValidityDateFrom;
			productSale.CurrencyIsoCode = edp.CurrencyID;		   
			productSale.Is_PLI_Processed__c = false;
			productSale.Is_Processed__c = false;
			productSale.EDP_ActiveStatus__c=edp.EDP_ActiveStatus;
			productSale.CreatedDate__c=edp.CreatedDate;
			productSale.ModifiedDate__c=edp.ModifiedDate;
			productSale.AdditionalInformation__c=edp.AdditionalInformation; 
			productSale.ApprovedDate__c=edp.ApprovedDate;
			productSale.Approver__c=edp.Approver;
			productSale.NSNCompliancyNotes__c=edp.NSNCompliancyNotes;
			productSale.NSNCountryOrArea__c=edp.NSNCountryOrArea;
			productSale.NSNDoubleCode__c=edp.NSNDoubleCode;
			productSale.NSNEncryption__c=edp.NSNEncryption;
			productSale.Lattice__c=edp.Lattice;
			productSale.NSNOldCode__c=edp.NSNOldCode;
			productSale.NSNOldRevision__c=edp.NSNOldRevision;
			productSale.Originated__c=edp.Originated;
			productSale.NSNHwsPortfolio__c=edp.NSNHwsPortfolio;
			productSale.NSNTargtVariantConfig__c=edp.NSNTargtVariantConfig;
			productSale.PDMTimestamp__c=edp.PDMTimestamp;
			productSale.RealPDMRevision__c=edp.RealPDMRevision;
			productSale.NSNMepRequired__c=edp.NSNMepRequired;
			productSale.LegacyCode__c=edp.LegacyCode;
			productSale.LegacyRevision__c=edp.LegacyRevision;
			productSale.LegacyNcmCode__c=edp.LegacyNcmCode;
			productSale.SpecialPricingIndicator__c=edp.SpecialPricingIndicator;
			productSale.Originator__c=edp.Originator;
			productSale.Revision__c=edp.Revision;
			productSale.EDPLastModifiedDate__c = edp.EDP_LastModifiedDate;
			productSale.capacity__c = edp.NSNCapacityUnit;
		  //productSale.capacity_factor__c = edp.NSNCapacityFactor;
			productSale.HWS_Unit_of_measure__c = edp.UnitOfMeasure; // added by TCS
			if(edp.IRPPrice == null)
				productSale.Is_PLI_Processed__c = true;
			if(prod_code_set.add(productSale.NSNCode__c))
			productSalesItemList.add(productSale);
			
			if(edp.EDP_LastModifiedDate>MaxTimestamp)
				MaxTimestamp=edp.EDP_LastModifiedDate;
			
		}
		//clear productAray list after loading it to productsalesitem list
		productArray.clear();
		prod_code_set.clear();
		
		return productSalesItemList;
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, PMDI_Constants.EDP_SI_Staging, PMDI_Constants.UPLOADTOSTAGINGTABLE);
			return null;
		}
	}
	
	/****************************************
		 * Name : createInterfaceLogs
		 * Description : create interface logs for sales items load
		 * Parameters: List of sales items, url
		 * Returns: 
	 *****************************************/
	public static void createInterfaceLogs(List<Product_Sales_Item__c> productSalesItemList,String path_SI)
	{				
		try
		{
			//Insert product sales item
			List<Database.upsertResult> results_si = Database.upsert(productSalesItemList,Product_Sales_Item__c.Fields.NSNCode__c, false);			
			System.debug('Data loaded to sales item..'+results_si.size());
								
			// Callout Interface Logs//
			List<interface_log__c> ilogs = new List<interface_log__c>();		   
			interface_log__c ilog_callout = new interface_log__c();
			ilog_callout.Interface_Type__c = 'EDP Sales Item Stage';
			ilog_callout.Message_Type__c = 'Inbound';
			ilog_callout.Operation_Type__c = 'Insert';
			//ilog_callout.Status__c = 'Success';
			// ilog_callout.Name = 'SI Rest Callout';
						 
			 if(statusCode == 200)
			 {
				ilog_callout.Interface_Request_Sent__c = 'Request URL: '+path_SI+ '\n'+
														 'Response: '+status+'\n'+
														  'Response Code'+statusCode+'\n';
														  //'Product Codes extracted: '+prod_code_str;
														  ilog_callout.Status__c = 'Success';
				ilog_callout.Name = 'SI Rest Callout success';
			 } 
				
			String operationType;
			////SI Interface Logs////
			for(Integer index = 0, size = results_si.size(); index < size; index++) 
			{
				operationType = (results_si[index].isCreated() ? 'Insert' : 'Update');
				if(!results_si[index].isSuccess()) 
				{ 
					////SI Error Interface Logs///
					interface_log__c ilog_si = new interface_log__c();
					for (Database.Error err : results_si[index].getErrors()){
						ilog_si.comment__c = 'Fields: '+err.getFields()+'Message: '+err.getMessage()+
												'Status Code: '+err.getStatusCode();
					}
					
					//ilog_si.comment__c = results_pci[index].getMessage();
					ilog_si.Interface_Type__c = 'EDP Sales Item Stage';
					ilog_si.Message_Type__c = 'Inbound';
					ilog_si.Operation_Type__c = operationType;
					ilog_si.Status__c = 'Failure';
					ilog_si.Interface_Request_Sent__c = 'Request URL: '+Path_SI+ '\n'+
														'NSNCode: '+productSalesItemList[index].NSNCode__c +'\n'+
														'Type: '+productSalesItemList[index].Type__c +'\n'+
														'Name: '+productSalesItemList[index].Name +'\n'+
														'Description: '+productSalesItemList[index].NSNCustomsDescription__c +'\n'+
														'LifeCycleStatus: '+productSalesItemList[index].Lifecycle_Status__c +'\n'+
														'EDP_LastModifiedDate: '+productSalesItemList[index].EDPLastModifiedDate__c;
					ilog_si.Name = 'SI '+operationType+' Failed with product code: '+productSalesItemList[index].NSNCode__c;
				 ilogs.add(ilog_si);
									   
				}
				else
				{ 
				////SI Success Interface Logs///
				interface_log__c ilog_si = new interface_log__c();
					ilog_si.comment__c = 'Success';
					ilog_si.Interface_Type__c = 'EDP Sales Item Stage';
					ilog_si.Message_Type__c = 'Inbound';
					ilog_si.Operation_Type__c = operationType;
					ilog_si.Status__c = 'Success';
					ilog_si.Interface_Request_Sent__c = 'Request URL: '+Path_SI+ '\n'+
														'Id: '+ results_si[index].Id + '\n'+
														'NSNCode: '+productSalesItemList[index].NSNCode__c +'\n'+
														'Type: '+productSalesItemList[index].Type__c +'\n'+
														'Name: '+productSalesItemList[index].Name +'\n'+
														'Description: '+productSalesItemList[index].NSNCustomsDescription__c +'\n'+
														'LifeCycleStatus: '+productSalesItemList[index].Lifecycle_Status__c +'\n'+
														'EDP_LastModifiedDate: '+productSalesItemList[index].EDPLastModifiedDate__c;
					ilog_si.Name = 'SI '+operationType+' Success with product code: '+productSalesItemList[index].NSNCode__c;
				 ilogs.add(ilog_si);
					successRecordCount++;
				 }
			}

			Database.Insert(Ilogs,false);			 
			System.debug('Interface logs created for '+Ilogs.size()+'items');
			Ilogs.clear(); 
			}
			catch(Exception e)
			{
				System.debug('Exception occured while loading data to staging table or interface log. Exception: '+e);
			}
	}
	
	//Inner class for josn structure of product sales item
	public class EDPProductSI{
		public String Name ; 
		public String NSNCode ; 
		public String Revision ; 
		public String Type ; // in json: Type
		public String SourceTable ; 
		public String Description ; 
		public String LifeCycleStatus ; 
		public String NSNSummary ; 
		public String NSNCustomsDescription ; 
		public DateTime CreatedDate ; 
		public DateTime ModifiedDate ; 
		public String NSNVolume ; 
		public String NSNVolumeUnit ; 
		public String NSNAbbreviation ; 
		public String AdditionalInformation ; 
		public DateTime ApprovedDate ; 
		public String Approver ; 
		public String NSNCompliancyNotes ; 
		public String NSNCountryOrArea ; 
		public String NSNDoubleCode ; 
		public String NSNEncryption ; 
		public String NSNGic ; 
		public String Lattice ; 
		public String NSNOldCode ; 
		public String NSNOldRevision ; 
		public DateTime Originated ; 
		public String Originator ; 
		public String NSNDesignResponsibility ; 
		public String NSNPlanningStatus ; 
		public String NSNPlanningType ; 
		public String Policy ; 
		public String NSNProductHierarchy ; 
		public String NSNProductLine ; 
		public String NSNProductSubArea ; 
		public String NSNSalesItemCategory ; 
		public String NSNSAPMatnr ; 
		public String NSNSAPMaterialType ; 
		public String NSNSourceSystem ; 
		public String NSNSourceType ; 
		public String NSNHwsPortfolio ; 
		public String NSNTargtVariantConfig ; 
		public DateTime PDMTimestamp ; 
		public String RealPDMRevision ; 
		public String NSNMepRequired ; 
		public String LegacyCode ; 
		public String LegacyRevision ; 
		public String LegacyNcmCode ; 
		public String SpecialPricingIndicator;
		public Decimal IRPPrice;
		public DateTime IRPValidityDateFrom;
		public String CurrencyID;
		public DateTime EDP_LastModifiedDate ;	
		public Boolean EDP_ActiveStatus;
		public String NSNCapacityFactor;
		public String NSNCapacityUnit ;
		public String UnitOfMeasure ;
	}

}