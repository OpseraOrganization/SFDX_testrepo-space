/****************************************
* Name : HWS_UploadToProductRelation
* Author : TCS
* Description : This class is for loading data from edp to Product Relationship and create interface logs
* ReqNo : 
****************************************/
public class HWS_UploadToProductRelation {
	/****************************************
* Name : jsonToProductRelationshipTable
* Description : load data to Product Relationship Table
* Parameters: HttResponse, URL
* Returns: List of Product Relationship Records
*****************************************/
	public static List<HWS_Product_Serviceable_Relations__c> jsonToProductRelationshipTable(HttpResponse response1, String path){
		List<HWS_Product_Serviceable_Relations__c> prodRelList = new List<HWS_Product_Serviceable_Relations__c>();
		List<ProdRelWrapper> prodRelations = (List<ProdRelWrapper>)System.JSON.deserialize(response1.getBody().substring(response1.getBody().indexOf('['), response1.getBody().lastIndexOf(']')+1), List<ProdRelWrapper>.class);
		Set<String> nsnCodeSET= new Set<String>();
		 List<interface_log__c> ilogs = new List<interface_log__c>();
		for(ProdRelWrapper prodRel: prodRelations)
		{
		   try{
			HWS_Product_Serviceable_Relations__c productRelation = new HWS_Product_Serviceable_Relations__c();
			productRelation.HWS_EDPActiveStatus__c = prodRel.EDP_ActiveStatus;
			productRelation.HWS_EDPDeletedAtSource__c = prodRel.EDP_DeletedAtSource;
			productRelation.HWS_EDPLastModifiedDate__c = prodRel.EDP_LastModifiedDate;
			productRelation.HWS_HWSSIPartNumber__c = prodRel.HWSSIPartNumber;
			productRelation.HWS_HWSVIPartNumber__c = prodRel.HWSVIPartNumber + prodRel.Source;
			productRelation.HWS_HWSVIPartRevisionHWSVIToICS__c = prodRel.HWSVIPartRevisionHWSVIToICS;
			productRelation.HWS_PCIIdentifier__c = prodRel.PCIIdentifier;
			productRelation.HWS_PrimaryProductCode__c = prodRel.PrimaryProductCode;
			productRelation.HWS_ProductCode__c = prodRel.ProductCode;
			productRelation.HWS_SourceSystem__c = prodRel.Source;
			productRelation.HWS_Combined_key__c = prodRel.HWSSIPartNumber+'_'+prodRel.HWSVIPartNumber+'_'+prodRel.ProductCode + prodRel.Source;
			productRelation.HWS_Is_Processed__c = false;
			if(!nsnCodeSET.contains(productRelation.HWS_Combined_key__c))
			{
				prodRelList.add(productRelation);
				nsnCodeSET.add(productRelation.HWS_Combined_key__c);
			}
		   }
		   catch(Listexception e){
		  iLogs = HWS_Utility_Batch.createInterfaceLogs(prodRel.HWSSIPartNumber,'EDP Release Stage','Inbound','Insert','HWS_UploadToProductRelation', e.getMessage(),prodRel.EDP_LastModifiedDate);
 
		  } 
		}
		Database.insert(ilogs);
		return prodRelList;
	}
	/****************************************
		 * Name : createInterfaceLogsToProductRelationship
		 * Description : create interface logs for  Product Relationship
		 * Parameters: Response, List of  Product Relationships Items, url
		 * Returns: 
	 *****************************************/
	public static void createInterfaceLogsAndProductRelationship(HttpResponse response1,List<HWS_Product_Serviceable_Relations__c> prodRelationshipList,String pathSI){
		List<Database.UpsertResult> resultspr = Database.upsert(prodRelationshipList,HWS_Product_Serviceable_Relations__c.HWS_Combined_key__c,false);
	   
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
			ilogcallout.Name = 'Product Serviceble Relation Class Rest Callout Failed';
		}
		ilogs.add(ilogcallout);
		
		////part Revision Interface Logs////
		for(Integer index = 0, size = resultspr.size(); index < size; index++) {
			String operationtype= resultspr[index].isCreated()?'Insert':'Update';
			
			if(!resultspr[index].isSuccess()) { 
				////PR Error Interface Logs///
				Interface_Log__c ilog_pr = new Interface_Log__c();
				for (Database.Error err : resultspr[index].getErrors()){
					ilog_pr.comment__c = 'Fields: '+err.getFields()+'Message: '+err.getMessage()+
						'Status Code: '+err.getStatusCode();
				}
				
				
				ilog_pr.Interface_Type__c = HWS_Constants.EDP_Release_Stage;
				ilog_pr.Message_Type__c = 'Inbound';
				ilog_pr.Operation_Type__c = operationtype;
				ilog_pr.Status__c = 'Failure';
				ilog_pr.Interface_Request_Sent__c = 'Request URL: '+pathSI+ '\n'+
					'NSNCode: '+ prodRelationshipList[index].HWS_Combined_key__c +'\n';
		 
				ilog_pr.Name = 'Product Relation '+operationtype+' Failure with NSNCode: '+ prodRelationshipList[index].HWS_Combined_key__c;
				ilogs.add(ilog_pr);
				
			   
				
			}	
		}
		
	   
		
	}
	public class ProdRelWrapper{
		public Boolean EDP_ActiveStatus{get;set;}
		public Boolean EDP_DeletedAtSource{get;set;}
		public DateTime EDP_LastModifiedDate{get;set;}
		public String HWSSIPartNumber{get;set;}
		public String HWSVIPartNumber{get;set;}
		public String HWSVIPartRevisionHWSVIToICS{get;set;}
		public String PCIIdentifier{get;set;}
		public String PrimaryProductCode{get;set;}
		public String ProductCode{get;set;}
		public String Source{get;set;}
		
	} 
}