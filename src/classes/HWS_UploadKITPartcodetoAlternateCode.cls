/****************************************
* Name : HWS_UploadKITcodetoAlternateCode
* Author : TCS
* Description : This class is for loading data from KIT code to part code in Alternate product code  and create interface logs
* ReqNo : 
* Test Class Name : HWS_ProductServiceableKitCode_Batch_Test
****************************************/
public without sharing class HWS_UploadKITPartcodetoAlternateCode{
	/****************************************
* Name : jsonKITCodetoAlternatecodeStagingTable
* Description : load data to Product Serviceble Version Items
* Parameters: HttResponse, URL
* Returns: List of Product Serviceble Version Items
*****************************************/
	public static List<HWS_AlternateProductCode__c> jsonKITCodetoAlternatecodeStagingTable(HttpResponse response1, String path){
		List<HWS_AlternateProductCode__c> altprodcdKitList = new List<HWS_AlternateProductCode__c>();
		List<KITCodesStatgintableWr> kitcodesPars = (List<KITCodesStatgintableWr>)System.JSON.deserialize(response1.getBody().substring(response1.getBody().indexOf('['), response1.getBody().lastIndexOf(']')+1), List<KITCodesStatgintableWr>.class);	   
		
		List<interface_log__c> ilogs = new List<interface_log__c>();
		
		Map<String,Id> mapNSNPartcodeandPId = new Map<String,Id>();
	   
		List<Product2> lstproducts = new List<product2>();
			   
		//Combination of Partcode and kit code
		Set<string> stAltProdCodeFinal = new Set<string>();
		
		for(KITCodesStatgintableWr prodSales: kitcodesPars)
		{
			if(prodSales.PartNumber != null && prodSales.PartNumber !='')
				stAltProdCodeFinal.add(prodSales.PartNumber);
			if(prodSales.Kit_BundleCode != null && prodSales.Kit_BundleCode !='')
				stAltProdCodeFinal.add(prodSales.Kit_BundleCode);
		}
		
		if(stAltProdCodeFinal.size()>0){
			lstproducts = [select id,Name,HWS_NSNPartCode__c from product2 where HWS_NSNPartCode__c IN : stAltProdCodeFinal];
		}
		if(lstproducts.size()>0){
			for(product2 prd : lstproducts){
				if(stAltProdCodeFinal.contains(prd.HWS_NSNPartCode__c)){
					mapNSNPartcodeandPId.put(prd.HWS_NSNPartCode__c,prd.id);
				}
			}
		}
		for(KITCodesStatgintableWr prodSales: kitcodesPars)
		{
			try{ 
				HWS_AlternateProductCode__c altprodcdKit = new HWS_AlternateProductCode__c();
				altprodcdKit.Name = prodSales.Kit_BundleCode;
				if(mapNSNPartcodeandPId.containsKey(prodSales.Kit_BundleCode)){
					altprodcdKit.HWS_Kit__c = mapNSNPartcodeandPId.get(prodSales.Kit_BundleCode);
					
				}
				altprodcdKit.HWS_KitDescription__c = prodSales.Kit_BundleDescription;
				altprodcdKit.HWS_NSNCode__c = prodSales.PartNumber;
				if(mapNSNPartcodeandPId.containsKey(prodSales.PartNumber)){
					altprodcdKit.HWS_Part__c = mapNSNPartcodeandPId.get(prodSales.PartNumber);
					
				}
				if(altprodcdKit.HWS_Kit__c == null){
					altprodcdKit.HWS_Unprocessed_Reason__c = 'KIT not found';
				}
				if(altprodcdKit.HWS_Kit__c == null){
					altprodcdKit.HWS_Unprocessed_Reason__c = 'PART not found';
				}
				if(altprodcdKit.HWS_Kit__c == null && altprodcdKit.HWS_Part__c ==null){
					altprodcdKit.HWS_Unprocessed_Reason__c = 'KIT and PART not found';
				}
				
				//altprodcdKit.HWS_Unprocessed_Reason__c = 'KIT not found'; 'Part Not found' , KIT and Part not found
				if(altprodcdKit.HWS_Unprocessed_Reason__c == null || altprodcdKit.HWS_Unprocessed_Reason__c == ''){
					altprodcdKit.HWS_IsProcessed__c = true;
				}
				altprodcdKit.HWS_PartDescription__c = prodSales.PartNumberDescription;
				altprodcdKit.HWS_Quantity__c = prodSales.Quantity;
				altprodcdKit.HWS_Combined_key__c = prodSales.PartNumber+prodSales.Kit_BundleCode+'KIT';
				altprodcdKit.HWS_AlternateCodeType__c = 'KIT';
				altprodcdKit.HWS_PartType__c = 'PART';
				altprodcdKit.HWS_SourceSystem__c = prodSales.SourceSystem;
				altprodcdKit.HWS_Status__c = prodSales.Status;
				altprodcdKit.HWS_Comments__c = prodSales.Comments;
				altprodcdKit.HWS_EDP_LastModifiedDate__c = prodSales.PMDSOR_UpdateDateTime;
				altprodcdKit.HWS_EDP_ActiveStatus__c = prodSales.PMDSOR_ActiveStatus;
				altprodcdKit.HWS_EDP_DeletedAtSource__c = prodSales.PMDSOR_DeletedAtSource;
				altprodcdKitList.add(altprodcdKit);
			}
			catch(Listexception e){
				iLogs = HWS_Utility_Batch.createInterfaceLogs(prodSales.PartNumber,'HWS KIT Alternate Part Code Interface','Inbound','Insert','HWS_UploadKITPartcodetoAlternateCode', e.getMessage(),prodSales.PMDSOR_UpdateDateTime); 
				
			} 
		}
		Database.insert(ilogs);
		System.debug('altprodcdKitList.size()***'+altprodcdKitList.size());
		return altprodcdKitList;
	}
	/****************************************
* Name : createInterfaceLogsToServiceableSalesItem
* Description : create interface logs for  Product Serviceble Sales Items load
* Parameters: Response, List of  Product Serviceble Sales Items, url
* Returns: 
*****************************************/
	public static void createInterfaceLogsAndAlternateProductCode(HttpResponse response1,List<HWS_AlternateProductCode__c> altprodcdKitList,String pathSI){
		try
		{
						
			List<Database.UpsertResult> resultspr = Database.upsert(altprodcdKitList,HWS_AlternateProductCode__c.HWS_Combined_key__c,false);		   
			
			//// Callout Interface Logs////
			List<interface_log__c> ilogs = new List<interface_log__c>();
			Interface_Log__c ilogcallout = new Interface_Log__c();
			ilogcallout.Interface_Type__c = 'HWS KIT Alternate Part Code Interface';
			ilogcallout.Message_Type__c = 'Inbound';
			ilogcallout.Operation_Type__c = 'Insert';
			
			if(response1.getStatuscode() !=200){
				ilogcallout.Interface_Request_Sent__c = 'Request URL: '+pathSI+ '\n'+
					'Response: '+response1.getStatus()+'\n'+
					'Response Code'+response1.getStatuscode();
				ilogcallout.Status__c = 'Failure';
				ilogcallout.Name = 'HWS_ProductServiceableKitCode_Batch Class Rest Callout Failed';
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
					ilogpr.Interface_Type__c = 'HWS KIT Alternate Part Code Interface';
					ilogpr.Message_Type__c = 'Inbound';
					ilogpr.Operation_Type__c = operationtype;
					ilogpr.Status__c = 'Failure';
					ilogpr.Interface_Request_Sent__c = 'Request URL: '+pathSI+ '\n'+
						'NSNCode: '+ altprodcdKitList[index].HWS_NSNCode__c +'\n';//+
					ilogpr.Name = 'KIT Alternate Part code Item  '+ altprodcdKitList[index].HWS_Combined_key__c;
					ilogs.add(ilogpr);
				}	
			}
			Database.Insert(Ilogs,false);
		}catch(Exception e){
			//This is empty block of code
		}
	}   
	public class KITCodesStatgintableWr{
		
		public String Kit_BundleCode{get;set;}
		public String SourceSystem{get;set;}
		public String PartNumber{get;set;}
		public Double Quantity{get;set;}
		public String Status{get;set;}
		public String Comments{get;set;}
		public DateTime PMDSOR_UpdateDateTime{get;set;}
		public Boolean PMDSOR_ActiveStatus{get;set;}
		public Boolean PMDSOR_DeletedAtSource{get;set;}
		public String Kit_BundleDescription{get;set;}
		public String PartNumberDescription{get;set;}
	   
		
	}
}