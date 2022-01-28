/****************************************
* Name : HWS_ComponentToProductLoad
* Author : TCS
* Description : This class is for loading data from edp to Product and create interface logs
* ReqNo : 
* Test Class : HWS_PMDSoRComponentToProductBatch_Test
****************************************/
public without sharing class HWS_ComponentToProductLoad {
	/****************************************
* Name : jsonToProductLoading
* Description : load data to Product
* Parameters: HttResponse, URL
* Returns: List of Product Records
*****************************************/
	public static List<Product2> jsonToProductLoading(HttpResponse response1, String path, boolean isDeltaLoad){
		List<Product2> prodList = new List<Product2>();
		List<HWS_ComponentToProductJSON> prodDeserializedList = (List<HWS_ComponentToProductJSON>)System.JSON.deserialize(response1.getBody().substring(response1.getBody().indexOf('['), response1.getBody().lastIndexOf(']')+1), List<HWS_ComponentToProductJSON>.class);
		System.debug('prodDeserializedList:'+prodDeserializedList);
		
		Id devRecordTypeId = Schema.SObjectType.product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
		
		
		List<Product2> pssiList = [Select Id,HWS_NSNPartCode__c from Product2 where PMD_Product_Item_Type__c='HW Standard Component'];
		Set<String> PSSInsncodes = new Set<String>();
		List<interface_log__c> iLogs = new List<interface_log__c>();

		for(Product2 pssi: pssiList){
			PSSInsncodes.add(pssi.HWS_NSNPartCode__c);
		}   
		for(HWS_ComponentToProductJSON prodEnovia: prodDeserializedList)
		{
		  try{
			if(isDeltaLoad && PSSInsncodes.contains(prodEnovia.NSNCode)){
				
					Product2 product = new Product2();
					Map<String, String> nameValuePair = new Map<String, String>();
					product.RecordTypeId = devRecordTypeId;
					product.NokiaCPQ_Valid_for__c ='';
					product.PMD_Product_Item_Type__c='HW Standard Component';
					product.NokiaCPQ_Item_Type__c='Hardware';
					product.Created_by_PMDI__c=true;
					product.Name = prodEnovia.Description;		  
					product.Description = prodEnovia.Description;
					product.HWS_NSNPartCode__c = prodEnovia.NSNCode;
					product.ProductCode = prodEnovia.NSNCode;
					product.HWS_EDP_LastModifiedDate__c = prodEnovia.Modified;
					product.NokiaCPQ_State__c = prodEnovia.Current;
					for(HWS_ComponentToProductJSON.cls_MainAttributes attr:  prodEnovia.MainAttributes){
						nameValuePair.put(attr.Name, attr.Value);
					}
					product.HWS_MaterialCategory__c=nameValuePair.get('Material Category');
					product.HWS_Unit_of_Measure__c = nameValuePair.get('Unit of Measure');
					prodList.add(product);
				
			}
			if(!isDeltaLoad){
				Product2 product = new Product2();
					Map<String, String> nameValuePair = new Map<String, String>();
					product.RecordTypeId = devRecordTypeId;
					product.NokiaCPQ_Valid_for__c ='';
					product.PMD_Product_Item_Type__c='HW Standard Component';
					product.NokiaCPQ_Item_Type__c='Hardware';
					product.Created_by_PMDI__c=true;
					product.Name = prodEnovia.Description;		  
					product.Description = prodEnovia.Description;
					product.HWS_NSNPartCode__c = prodEnovia.NSNCode;
					product.ProductCode = prodEnovia.NSNCode;
					product.HWS_EDP_LastModifiedDate__c = prodEnovia.Modified;
					product.NokiaCPQ_State__c = prodEnovia.Current;
					for(HWS_ComponentToProductJSON.cls_MainAttributes attr:  prodEnovia.MainAttributes){
						nameValuePair.put(attr.Name, attr.Value);
					}
					product.HWS_MaterialCategory__c=nameValuePair.get('Material Category');
					product.HWS_Unit_of_Measure__c = nameValuePair.get('Unit of Measure');
					prodList.add(product);
				
			}
		  }
		  catch(Listexception e){
	   iLogs = HWS_Utility_Batch.createInterfaceLogs(prodEnovia.NSNCode,'EDP Release Stage','Inbound','Insert','HWS_ComponentToProductLoad', e.getMessage(),prodEnovia.Modified);
	 
		  } 
		}
	  Database.insert(iLogs);

		return prodList;
	}
	/****************************************
* Name : createInterfaceLogs
* Description : create interface logs for  Product Data load
* Parameters: Response, List of  Product2 Records, url
* Returns: 
*****************************************/
	public static void createInterfaceLogsAndProductData(HttpResponse response1,List<Product2> productList,String pathSI)
	{   
		try
		{
			//Insert  Product
			System.debug('productList:'+productList);
			List<Database.upsertResult> resultsSI = Database.upsert(productList,Product2.Fields.HWS_NSNPartCode__c, false);		 
			System.debug('Data loaded to  Product2..'+resultsSI.size());
			Set<String> processedCodes = new Set<String>();
			// Callout Interface Logs//
			List<interface_log__c> ilogs = new List<interface_log__c>();	 
			Interface_Log__c iLogCallout = new Interface_Log__c();
			iLogCallout.Interface_Type__c = 'PMDSOR-HWS';
			iLogCallout.Message_Type__c = 'Inbound';
			iLogCallout.Operation_Type__c = 'Insert';		   
			
			if(response1.getStatuscode() !=200){
				iLogCallout.Interface_Request_Sent__c = 'Request URL: '+pathSI+ '\n'+ 'Response: '+response1.getStatus()+'\n'+'Response Code'+response1.getStatuscode();
				iLogCallout.Status__c = 'Failure';iLogCallout.Name = 'Component to Product Class Rest Callout Failed'; ilogs.add(iLogCallout);
			}
			
			
			String operationType;
			for(Integer index = 0, size = resultsSI.size(); index < size; index++) 
			{
				processedCodes.add(productList[index].HWS_NSNPartCode__c); 
				operationType = (resultsSI[index].isCreated() ? 'Insert' : 'Update');
				if(!resultsSI[index].isSuccess()) 
				{ 
					
					////Serviceble Version Item Error Interface Logs///
					interface_log__c iLogSi = new interface_log__c();
					for (Database.Error err : resultsSI[index].getErrors()){
						iLogSi.comment__c = 'Fields: '+err.getFields()+', Message: '+err.getMessage()+' Status Code: '+err.getStatusCode();
						System.debug('Message.....'+err.getMessage());
					}
										
					iLogSi.Interface_Type__c = 'PMDSOR-HWS';iLogSi.Message_Type__c = 'Inbound'; iLogSi.Operation_Type__c = operationType;
					iLogSi.Status__c = 'Failure'; iLogSi.Interface_Request_Sent__c = 'Request URL: '+pathSI+ '\n'+'NSNCode: '+productList[index].HWS_NSNPartCode__c;
					iLogSi.Name = 'Product2 '+operationType+' Failed with product code: '+productList[index].HWS_NSNPartCode__c;ilogs.add(iLogSi);
					
				}
			}
			if(!processedCodes.isEmpty()){
				List<HWS_Product_Serviceable_Sales_Item__c> pssiList = [Select Id,HWS_Part_Number__c from HWS_Product_Serviceable_Sales_Item__c where HWS_Part_Number__c IN:processedCodes];
				List<HWS_Product_Serviceable_Sales_Item__c> pssiListnew = new List<HWS_Product_Serviceable_Sales_Item__c>();
				for(HWS_Product_Serviceable_Sales_Item__c pssi : pssiList){
					pssi.HWS_isComponentInsertToProduct2__c=true;
					pssiListnew.add(pssi);
				}
				update pssiListnew;
			}
			if(!ilogs.isEmpty()){ Database.Insert(ilogs,false);}	
			System.debug('Interface logs created for '+Ilogs.size()+'items');
			Ilogs.clear(); 
		}
		catch(Exception e)
		{
			System.debug('Exception occured while loading data to staging table or interface log. Exception: '+e);
		}
	}
	
}