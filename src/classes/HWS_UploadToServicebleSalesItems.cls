/****************************************
* Name : HWS_UploadToServicebleSalesItems
* Author : TCS
* Description : This class is for loading data from edp to Product Serviceble Version Items and create interface logs
* ReqNo : 
****************************************/
public without sharing class HWS_UploadToServicebleSalesItems {
	/****************************************
* Name : uploadToProductServiceableSalesItemStagingTable
* Description : load data to Product Serviceble Version Items
* Parameters: HttResponse, URL
* Returns: List of Product Serviceble Version Items
*****************************************/
	public static List<HWS_Product_Serviceable_Sales_Item__c> jsonToProductServiceableSalesItemStagingTable(HttpResponse response1, String path){
		List<HWS_Product_Serviceable_Sales_Item__c> prodServiceSalesItemList = new List<HWS_Product_Serviceable_Sales_Item__c>();
		List<ProdServiceSalesItem> prodServiceSales = (List<ProdServiceSalesItem>)System.JSON.deserialize(response1.getBody().substring(response1.getBody().indexOf('['), response1.getBody().lastIndexOf(']')+1), List<ProdServiceSalesItem>.class);	   
		Set<String> nsnCodeSET= new Set<String>();
		List<interface_log__c> ilogs = new List<interface_log__c>();
		for(ProdServiceSalesItem prodSales: prodServiceSales)
		{
		  try{ 
			HWS_Product_Serviceable_Sales_Item__c prodSalesItem = new HWS_Product_Serviceable_Sales_Item__c();
			prodSalesItem.HWS_Alternate_code_type__c = prodSales.AlternateCodeType;
			prodSalesItem.HWS_Alternate_code_value__c = prodSales.AlternateCodeValue;
			prodSalesItem.HWS_Discontinued_Advanced_Exchange_Date__c = prodSales.DiscontinuedAdvancedExchangeDate;
			prodSalesItem.HWS_Discontinued_Repair_Date__c = prodSales.DiscontinuedRepairDate;
			prodSalesItem.HWS_EDP_ActiveStatus__c = prodSales.EDP_ActiveStatus;
			prodSalesItem.HWS_EDP_DeletedAtSource__c = prodSales.EDP_DeletedAtSource;
			prodSalesItem.HWS_EDP_LastModifiedDate__c = prodSales.EDP_LastModifiedDate;
			prodSalesItem.HWS_Hazardous_flag__c = prodSales.HazardousFlag;
			prodSalesItem.HWS_Status__c = prodSales.HWSStatus;
			prodSalesItem.HWS_Life_Extender__c = prodSales.LifeExtender;
			prodSalesItem.HWS_Manufacturer__c = prodSales.Manufacturer;
			prodSalesItem.HWS_Material_Type__c = prodSales.MaterialType;
			prodSalesItem.HWS_No_Swap_Flag__c = prodSales.NoSwapFlag;
			prodSalesItem.HWS_NSNCode__c = prodSales.PartNumber+'-'+prodSales.Source;
			prodSalesItem.HWS_OEM_manufacturer_part_code__c = prodSales.OEMManufacturerPartCode;
			prodSalesItem.HWS_Part_name__c = prodSales.PartName;
			prodSalesItem.HWS_Part_Number__c = prodSales.PartNumber;
			prodSalesItem.HWS_Proprietary_Note__c = prodSales.ProprietaryNote;
			prodSalesItem.HWS_Restricted_flag__c = prodSales.Restrictedflag;
			prodSalesItem.HWS_SAP_Status__c = prodSales.SAPStatus;
			prodSalesItem.HWS_SPS_Last_order_date__c = prodSales.SPSLastOrderDate;
			prodSalesItem.HWS_SupportbyDerogation__c = prodSales.SupportbyDerogation;
			prodSalesItem.HWS_SupportbyDerogationEndDate__c = prodSales.SupportbyDerogationEndDate;
			prodSalesItem.HWS_GlobalServiceLeadTimeSpare__c = prodSales.GlobalServiceLeadTimeSpare;
			prodSalesItem.HWS_GlobalServiceLeadTimeSwap__c = prodSales.GlobalServiceLeadTimeSwap;
			prodSalesItem.HWS_GlobalServiceLeadTimeService3__c = prodSales.GlobalServiceLeadTimeService3;
			prodSalesItem.HWS_GlobalServiceLeadTimeService4__c = prodSales.GlobalServiceLeadTimeService4;
			prodSalesItem.HWS_Source__c = prodSales.Source;
			prodSalesItem.HWS_CodeType__c = prodSales.CodeType;
			prodSalesItem.HWS_MaterialCategory__c = prodSales.MaterialCategory;
			prodSalesItem.HWS_Is_Processed__c = false;
			prodSalesItem.HWS_Is_Assembly_Processed__c = false;
			if(prodSales.EDP_ItemType == 'VersionItem'){
			prodSalesItem.HWS_Item_Type__c  = 'Sub Assembly';
			}
			else{
	prodSalesItem.HWS_Item_Type__c = prodSales.EDP_ItemType;
			}
			if(!nsnCodeSET.contains(prodSalesItem.HWS_NSNCode__c))
			{
	prodServiceSalesItemList.add(prodSalesItem);
	nsnCodeSET.add(prodSalesItem.HWS_NSNCode__c);
			}
			else{
	System.debug('Duplicate NSN Codes:'+prodSalesItem.HWS_NSNCode__c);
			}
		  }
		 catch(Listexception e){
		iLogs = HWS_Utility_Batch.createInterfaceLogs(prodSales.PartNumber+'-'+prodSales.Source,'EDP Release Stage','Inbound','Insert','HWS_UploadToServicebleSalesItems', e.getMessage(),prodSales.EDP_LastModifiedDate); 
		 
		  } 
		}
		Database.insert(ilogs);
		System.debug('prodServiceSalesItemList.size()***'+prodServiceSalesItemList.size());
		return prodServiceSalesItemList;
	}
	/****************************************
* Name : createInterfaceLogsToServiceableSalesItem
* Description : create interface logs for  Product Serviceble Sales Items load
* Parameters: Response, List of  Product Serviceble Sales Items, url
* Returns: 
*****************************************/
	public static void createInterfaceLogsAndServiceableSalesItem(HttpResponse response1,List<HWS_Product_Serviceable_Sales_Item__c> prodServiceSalesItemList,String pathSI){
		try
		{
			List<Database.UpsertResult> resultspr = Database.upsert(prodServiceSalesItemList,HWS_Product_Serviceable_Sales_Item__c.HWS_NSNCode__c,false);		   
			//// Callout Interface Logs////
			List<interface_log__c> ilogs = new List<interface_log__c>();
			Interface_Log__c ilogcallout = new Interface_Log__c();
			ilogcallout.Interface_Type__c = HWS_Constants.EDP_Release_Stage;
			ilogcallout.Message_Type__c = 'Inbound';
			ilogcallout.Operation_Type__c = 'Insert';
		  
			
			if(response1.getStatuscode() !=200){
	ilogcallout.Interface_Request_Sent__c = 'Request URL: '+pathSI+ '\n'+
		'Response: '+response1.getStatus()+'\n'+
		'Response Code'+response1.getStatuscode();
	ilogcallout.Status__c = 'Failure';
	ilogcallout.Name = 'Product Serviceble Sales Item Class Rest Callout Failed';
			}
			ilogs.add(ilogcallout);
			
			////Product SalesItem Extended Interface Logs////
			for(Integer index = 0, size = resultspr.size(); index < size; index++) {
	String operationtype= resultspr[index].isCreated()?'Insert':'Update';
	
	if(!resultspr[index].isSuccess()) { 
		////PR Error Interface Logs///
		Interface_Log__c ilogpr = new Interface_Log__c();
		for (Database.Error err : resultspr[index].getErrors()){
			ilogpr.comment__c = 'Fields: '+err.getFields()+'Message: '+err.getMessage()+
	'Status Code: '+err.getStatusCode();
		}
		ilogpr.Interface_Type__c = HWS_Constants.EDP_Release_Stage;
		ilogpr.Message_Type__c = 'Inbound';
		ilogpr.Operation_Type__c = operationtype;
		ilogpr.Status__c = 'Failure';
		ilogpr.Interface_Request_Sent__c = 'Request URL: '+pathSI+ '\n'+
			'NSNCode: '+ prodServiceSalesItemList[index].HWS_NSNCode__c +'\n';//+
		//'Type: '+ prodServiceSalesItemList[index].HWS_Type__c +'\n'//+
		//'Description: '+ prodServiceSalesItemList[index].HWS_Description__c +'\n';//+
		//'LifeCycleStatus: '+ ReleasesList[index].Lifecyclestatus__c +'\n'+
		//'EDP_LastModifiedDate: '+ ReleasesList[index].EDP_LastModifiedDate__c;
		ilogpr.Name = 'Product Serviceable Sales Item '+operationtype+' Failure with NSNCode: '+ ProdServiceSalesItemList[index].HWS_NSNCode__c;
		ilogs.add(ilogpr);
	}	
			}
			
			
		}catch(Exception e){
			//This is empty block of code
		}
	}   
	public class ProdServiceSalesItem{
		
		public String AlternateCodeType{get;set;}
		public String AlternateCodeValue{get;set;}
		public DateTime DiscontinuedAdvancedExchangeDate{get;set;}
		public DateTime DiscontinuedRepairDate{get;set;}
		public Boolean EDP_ActiveStatus{get;set;}
		public Boolean EDP_DeletedAtSource{get;set;}
		public DateTime EDP_LastModifiedDate{get;set;}
		public String HazardousFlag{get;set;}
		public Boolean IsProcessed{get;set;}
		public String LifeExtender{get;set;}
		public String Manufacturer{get;set;}
		public String MaterialType{get;set;}
		public String NoSwapFlag{get;set;}
		public String OEMManufacturerPartCode{get;set;}
		public String PartName{get;set;}
		public String PartNumber{get;set;}
		public String ProprietaryNote{get;set;}
		public String Restrictedflag{get;set;}
		public String SAPStatus{get;set;}
		public DateTime SPSLastOrderDate{get;set;}
		public String SupportbyDerogation{get;set;}
		public DateTime SupportbyDerogationEndDate{get;set;}
		public Double GlobalServiceLeadTimeSpare{get;set;}
		public Double GlobalServiceLeadTimeSwap{get;set;}
		public Double GlobalServiceLeadTimeService3{get;set;}
		public Double GlobalServiceLeadTimeService4{get;set;}
		public String Source{get;set;}
		public String EDP_ItemType{get;set;}
		public String HWSStatus{get;set;}  
		public String MaterialCategory{get;set;}
		public String CodeType{get;set;}
	}
}