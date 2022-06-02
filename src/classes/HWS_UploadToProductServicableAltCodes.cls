/****************************************
* Name : HWS_UploadToProductServicableAltCodes
* Author : TCS
* Description : This class is for loading data from edp to Product Relationship and create interface logs
* ReqNo : 
****************************************/
public without sharing class HWS_UploadToProductServicableAltCodes {
	/****************************************
* Name : jsonToProductServicableAltCodesTable
* Description : load data to Product Relationship Table
* Parameters: HttResponse, URL
* Returns: List of Product Relationship Records
*****************************************/
	public static List<HWS_AlternateProductCode__c> jsonToProductServicableAltCodesTable(HttpResponse response1, String path){
		system.debug('response--'+response1.getStatuscode());
		List<HWS_AlternateProductCode__c> prodSerAltCode = new List<HWS_AlternateProductCode__c>();
		List<ProdAltCodeWrapper> prodAltCodes = (List<ProdAltCodeWrapper>)System.JSON.deserialize(response1.getBody().substring(response1.getBody().indexOf('['), response1.getBody().lastIndexOf(']')+1), List<ProdAltCodeWrapper>.class);
		Set<String> nsnCodeSET= new Set<String>();
		List<interface_log__c> ilogs = new List<interface_log__c>();
	   
		for(ProdAltCodeWrapper prodAltCode : prodAltCodes)
		{
		 try{
			HWS_AlternateProductCode__c prodAltCodeRec = new HWS_AlternateProductCode__c();
			prodAltCodeRec.Name = prodAltCode.AlternateCodeValue;
			prodAltCodeRec.HWS_AlternateCodeType__c = prodAltCode.AlternateCodeType;
			prodAltCodeRec.HWS_NSNCode__c= prodAltCode.NSNCode;
			prodAltCodeRec.HWS_SourceSystem__c = prodAltCode.Source;
			prodAltCodeRec.HWS_Combined_key__c = prodAltCode.NSNCode+ prodAltCode.AlternateCodeType+prodAltCode.AlternateCodeValue;
			prodAltCodeRec.HWS_EDP_ActiveStatus__c = prodAltCode.EDP_ActiveStatus;
			prodAltCodeRec.HWS_EDP_DeletedAtSource__c = prodAltCode.EDP_DeletedAtSource;
			prodAltCodeRec.HWS_PartType__c= prodAltCode.PartType;
			prodAltCodeRec.HWS_EDP_LastModifiedDate__c = prodAltCode.EDP_LastModifiedDate;
			prodAltCodeRec.HWS_IsProcessed__c=false;
			if(!nsnCodeSET.contains(prodAltCodeRec.HWS_Combined_key__c))
			{
				prodSerAltCode.add(prodAltCodeRec);
				nsnCodeSET.add(prodAltCodeRec.HWS_Combined_key__c);
			}
		  }
		  catch(Listexception e){
		iLogs = HWS_Utility_Batch.createInterfaceLogs(prodAltCode.AlternateCodeValue,'EDP Release Stage','Inbound','Insert','HWS_UploadToProductServicableAltCodes', e.getMessage(),prodAltCode.EDP_LastModifiedDate); 
		
		  }
		   
		}
		Database.insert(ilogs);
		return prodSerAltCode;
	}
	/****************************************
		 * Name : createInterfaceLogsAndProductServiceableAltCode
		 * Description : create interface logs And ProductServiceableAltCode
		 * Parameters: Response, List of  Product Relationships Items, url
		 * Returns: 
	 *****************************************/
	public static void createInterfaceLogsAndProductServiceableAltCode(HttpResponse response1,List<HWS_AlternateProductCode__c> prodServiceableAltCode, String pathSI){
		
		List<Database.UpsertResult> resultspr = Database.upsert(prodServiceableAltCode,HWS_AlternateProductCode__c.HWS_Combined_key__c,false);
		 
		List<interface_log__c> ilogs = new List<interface_log__c>();
		Interface_Log__c ilogcallout = new Interface_Log__c();
		ilogcallout.Interface_Type__c = 'EDP Release Stage';
		ilogcallout.Message_Type__c = 'Inbound';
		ilogcallout.Operation_Type__c = 'Insert';
		
		
		
		if(response1.getStatuscode() !=200){
			ilogcallout.Interface_Request_Sent__c = 'Request URL: '+pathSI+ '\n'+
				'Response: '+response1.getStatus()+'\n'+
				'Response Code'+response1.getStatuscode();
			ilogcallout.Status__c = 'Failure';
			ilogcallout.Name = 'Product Serviceble Alternate Code Class Rest Callout Failed';
		}
		ilogs.add(ilogcallout);
		
		////part Revision Interface Logs////
		for(Integer index = 0, size = resultspr.size(); index < size; index++) {
			String operationtype= resultspr[index].isCreated()?'Insert':'Update';
			
			if(!resultspr[index].isSuccess()) { 
				 
				Interface_Log__c ilogpr = new Interface_Log__c();
				for (Database.Error err : resultspr[index].getErrors()){
					ilogpr.comment__c = 'Fields: '+err.getFields()+'Message: '+err.getMessage()+
						'Status Code: '+err.getStatusCode();
				}
				
				ilogpr.Interface_Type__c = 'HWS Alternate Code Interface';
				ilogpr.Message_Type__c = 'Inbound';
				ilogpr.Operation_Type__c = operationtype;
				ilogpr.Status__c = 'Failure';
				ilogpr.Name = 'PHWS Alternate Code Interface Failure with NSNCode: '+ prodServiceableAltCode[index].HWS_Combined_key__c;
				ilogs.add(ilogpr);
				
				
				
			}
		}
		
		Database.Insert(Ilogs,false); 
		
	}
	public class ProdAltCodeWrapper{
		
		public String NSNCode{get;set;}
		public String AlternateCodeValue{get;set;}
		public String AlternateCodeType{get;set;}
		public String PartType{get;set;}
		public String Source{get;set;}
		public Boolean EDP_DeletedAtSource{get;set;}
		public DateTime EDP_LastModifiedDate{get;set;}
		public Boolean EDP_ActiveStatus{get;set;}
	} 
}