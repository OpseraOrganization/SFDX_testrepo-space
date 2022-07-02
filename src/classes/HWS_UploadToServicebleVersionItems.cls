/****************************************
* Name : HWS_UploadToServicebleVersionItems
* Author : TCS
* Description : This class is for loading data from edp to Product Serviceble Version Items and create interface logs
* ReqNo : 
****************************************/
public without sharing class HWS_UploadToServicebleVersionItems {
	/****************************************
* Name : uploadToServiceableVersionItemStagingTable
* Description : load data to Product Serviceble Version Items
* Parameters: HttResponse, URL
* Returns: List of Product Serviceble Version Items
*****************************************/
	public static List<HWS_Product_Serviceable_Version_Item__c> jsonToServiceableVersionItemStagingTable(HttpResponse response1, String path){
		system.debug('Response received to PSVI: '+response1.getBody());
		List<HWS_Product_Serviceable_Version_Item__c> prodSerVersionItmList = new List<HWS_Product_Serviceable_Version_Item__c>();
		List<ProdServItems> prodServItemList = (List<ProdServItems>)System.JSON.deserialize(response1.getBody().substring(response1.getBody().indexOf('['), response1.getBody().lastIndexOf(']')+1), List<ProdServItems>.class);
		Set<String> nsnCodeSET= new Set<String>();
			   List<interface_log__c> iLogs = new List<interface_log__c>();

		for(ProdServItems prodSales: prodServItemList)
		{
		  try{
			HWS_Product_Serviceable_Version_Item__c productService = new HWS_Product_Serviceable_Version_Item__c();
			productService.HWS_EDP_ActiveStatus__c = prodSales.EDP_ActiveStatus;
			productService.HWS_EDP_DeletedAtSource__c = prodSales.EDP_DeletedAtSource;
			productService.HWS_EDP_LastModifiedDate__c = prodSales.EDP_LastModifiedDate;
			productService.HWS_FITRate__c = prodSales.FITRate;
			productService.HWS_MaterialType__c = prodSales.MaterialType;
	 
			if(prodSales.Source == 'PUMA2'){
				productService.HWS_NSNCode__c = prodSales.PartNumber+'.'+prodSales.PartRevision  ;
			}else {
				productService.HWS_NSNCode__c = prodSales.PartRevision;
			}
			
			if (prodSales.Source == 'PUMA2')
			{
				productService.HWS_NSNCodeRelation__c = prodSales.PartNumber + prodSales.Source;
			}
			else{
				
				productService.HWS_NSNCodeRelation__c = prodSales.PartRevision + prodSales.Source;
			}
			
		   
			
			productService.HWS_PartNumber__c = prodSales.PartNumber;
			productService.HWS_PartRevision__c = prodSales.PartRevision;
			productService.HWS_PartRevisionFormat__c = prodSales.PartRevisionFormat;
			productService.HWS_SAPStatus__c = prodSales.SAPStatus;
			productService.HWS_SerialNumberFormat__c = prodSales.SerialNumberFormat;
			productService.HWS_SerialNumberTraceable__c = prodSales.SerialNumberTraceable;
			productService.HWS_Source__c = prodSales.Source;  
			productService.HWS_Is_Processed__c = False;
			productService.HWS_IsRelation_Processed__c=false;
			if(!nsnCodeSET.contains(productService.HWS_NSNCode__c))
			{
				prodSerVersionItmList.add(productService);
				nsnCodeSET.add(productService.HWS_NSNCode__c);
			}
		  }
		  catch(ListException e){
		  
		  iLogs = HWS_Utility_Batch.createInterfaceLogs(prodSales.PartNumber,'EDP Release Stage','Inbound','Insert','HWS_UploadToServicebleVersionItems', e.getMessage(),prodSales.EDP_LastModifiedDate);
			  
		  }  
		 }
		Database.insert(iLogs);
		return prodSerVersionItmList;
	}
	/****************************************
* Name : createInterfaceLogs
* Description : create interface logs for  Product Serviceble Version Items load
* Parameters: Response, List of  Product Serviceble Version Items, url
* Returns: 
*****************************************/
	public static void createInterfaceLogsAndServiceableVersionItem(HttpResponse response1,List<HWS_Product_Serviceable_Version_Item__c> productServiceableVersionList,String pathSI)
	{			   
		try
		{
			//Insert  Product Serviceble Version Items
			List<Database.upsertResult> resultsSI = Database.upsert(productServiceableVersionList,HWS_Product_Serviceable_Version_Item__c.Fields.HWS_NSNCode__c, false);			
			System.debug('Data loaded to  Product Serviceble Version Items..'+resultsSI.size());
			
			// Callout Interface Logs//
			List<interface_log__c> ilogs = new List<interface_log__c>();		   
			Interface_Log__c iLogCallout = new Interface_Log__c();
			iLogCallout.Interface_Type__c = 'EDP Release Stage';
			iLogCallout.Message_Type__c = 'Inbound';
			iLogCallout.Operation_Type__c = 'Insert';
			
			
			if(response1.getStatuscode() !=200){
				iLogCallout.Interface_Request_Sent__c = 'Request URL: '+pathSI+ '\n'+
					'Response: '+response1.getStatus()+'\n'+
					'Response Code'+response1.getStatuscode();
				iLogCallout.Status__c = 'Failure';
				iLogCallout.Name = 'Product Serviceble Vertion Item Class Rest Callout Failed';
			}
			ilogs.add(iLogCallout);
			
			String operationType;
			////SI Interface Logs////
			for(Integer index = 0, size = resultsSI.size(); index < size; index++) 
			{
				operationType = (resultsSI[index].isCreated() ? 'Insert' : 'Update');
				if(!resultsSI[index].isSuccess()) 
				{ 
					
					////Serviceble Version Item Error Interface Logs///
					interface_log__c iLogSi = new interface_log__c();
					for (Database.Error err : resultsSI[index].getErrors()){
						iLogSi.comment__c = 'Fields: '+err.getFields()+'Message: '+err.getMessage()+
							'Status Code: '+err.getStatusCode();
						System.debug('Message.....'+err.getMessage());
					}
					
				  
					iLogSi.Interface_Type__c = 'EDP Product Serviceble Version Item Stage';
					iLogSi.Message_Type__c = 'Inbound';
					iLogSi.Operation_Type__c = operationType;
					iLogSi.Status__c = 'Failure';
					iLogSi.Interface_Request_Sent__c = 'Request URL: '+pathSI+ '\n'+
						'NSNCode: '+productServiceableVersionList[index].HWS_NSNCode__c;
					iLogSi.Name = 'Product Serviceable Version Item '+operationType+' Failed with product code: '+productServiceableVersionList[index].HWS_NSNCode__c;
					ilogs.add(iLogSi);
					
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
	
	public class ProdServItems{
		public Boolean EDP_ActiveStatus{get;set;}
		public Boolean EDP_DeletedAtSource{get;set;}
		public DateTime EDP_LastModifiedDate{get;set;}
		public String FITRate{get;set;}
		public String MaterialType{get;set;}
		public String PartNumber{get;set;}
		public String PartRevision{get;set;}
		public String PartRevisionFormat{get;set;}
		public String SAPStatus{get;set;}
		public String SerialNumberFormat{get;set;}
		public String SerialNumberTraceable{get;set;}
		public String Source{get;set;}
	}
}