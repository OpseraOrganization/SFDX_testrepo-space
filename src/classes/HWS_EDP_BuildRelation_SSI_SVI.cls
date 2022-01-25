global class HWS_EDP_BuildRelation_SSI_SVI implements Database.Batchable<sObject>,Database.Stateful,Schedulable{
	/****************************************
	 * Name : HWS_EDP_SVItoVersionItem_BATCH
	 * Author : TCS
	 * Description : This class is for building relationship between Sericeable Sales item and Serviceable version item 
	 * User Stroy : 
	****************************************/

	//static variable initialization
	public List<NokiaCPQ_PMDI_Parameter__c> lparas = new List<NokiaCPQ_PMDI_Parameter__c>();
	public string sourcetype = 'HWS_Product_Serviceable_Version_Item__c';
	private static boolean debug = false;
	private static String code = 'HWS_NSNCodeRelation__c';
	
	/****************************************
		 * Name : execute
		 * Description : executes the batch class using schedulable instance
		 * Parameters: SchedulableContext
	 *****************************************/
	global void execute(SchedulableContext sc)	  
	{
		HWS_EDP_BuildRelation_SSI_SVI  batch= new HWS_EDP_BuildRelation_SSI_SVI();
		Database.executebatch(batch,1);			
	} 
	
	/****************************************
		 * Name : start
		 * Description : Retrieves the data from serviceable Version item item to build relationship
		 * Parameters: Database.BatchableContext
		 * Returns : Database.QueryLocator
	 *****************************************/
	global Database.QueryLocator start(Database.BatchableContext bc)
	{
		
	  String sQuery='SELECT Id, HWS_NSNCodeRelation__c ,HWS_Source__c, HWS_IsRelation_Processed__c FROM HWS_Product_Serviceable_Version_Item__c WHERE HWS_IsRelation_Processed__c = false';
	  return database.getQueryLocator(sQuery);
	}

	 /****************************************
		 * Name : execute
		 * Description : Retrieves the data from product serviceable sales item staging object
		 * Parameters: Database.BatchableContext, List of Product sales item
		 * Returns : 
	 *****************************************/	
	global void execute(Database.BatchableContext bc, List<HWS_Product_Serviceable_Version_Item__c> serviceableVersionItems)
	{	 
		 List<String> nsnCodeList=new List<String>();
		 List<String> nsnCodeListtoUpdate=new List<String>();
		 Map<String,String> mappingNSNCode;
		 List<String> mappingParentNSNCode;
		Map<String,Id> mappingRecords;  
		for(HWS_Product_Serviceable_Version_Item__c record : serviceableVersionItems){
				  nsnCodeList.add(record.HWS_NSNCodeRelation__c);
	 
		 }   
	   List<HWS_Product_Serviceable_Relations__c> productServiceableRelationlist=new List<HWS_Product_Serviceable_Relations__c>();
	   productServiceableRelationlist = [SELECT Id, HWS_HWSSIPartNumber__c, HWS_HWSVIPartNumber__c  FROM HWS_Product_Serviceable_Relations__c WHERE HWS_HWSVIPartNumber__c  IN  :nsnCodeList];
		 
	   mappingParentNSNCode=new List<String>();
	   mappingNSNCode=new map<String,String>();
	  
		
		for (HWS_Product_Serviceable_Relations__c objparentRelation : productServiceableRelationlist){
			 mappingNSNCode.put(objparentRelation.HWS_HWSVIPartNumber__c,objparentRelation.HWS_HWSSIPartNumber__c);
			 mappingParentNSNCode.add(objparentRelation.HWS_HWSSIPartNumber__c);
		}  
		
	   List<Product2> productList=[SELECT Id, ProductCode FROM Product2 WHERE ProductCode IN :mappingParentNSNCode and HWS_DoNotConsider__c=false];
	   mappingRecords=new Map<String,Id>();
	  //loop thorugh Child(NSNCode from HWS_Serviceable_Version_Item) Parentmap to(ProductCode from Product2) 
		for(String key:mappingNSNCode.keySet()){
			String productCode=mappingNSNCode.get(key);
			for(Product2 objProduct:productList){
				if (productCode==objProduct.ProductCode){
					mappingRecords.put(key,objProduct.id);
					System.debug('key** '+key+' Product id '+objProduct.id);
				}
			}
		  }
		 
		List<HWS_Product_Serviceable_Version_Item__c> listsrcrecord = new List<HWS_Product_Serviceable_Version_Item__c>();
		for(HWS_Product_Serviceable_Version_Item__c record : serviceableVersionItems){
				  Id productId=mappingRecords.get(record.HWS_NSNCodeRelation__c);
				  if(productId != null){
				  nsnCodeListtoUpdate.add(record.HWS_NSNCodeRelation__c); 
				  record.HWS_IsRelation_Processed__c =true;
				  listsrcrecord.add(record);
			   }
		 }   
	   
	   List<HWS_VersionItem__c>  listversion = new List<HWS_VersionItem__c>();
	   List<HWS_VersionItem__c>  listversions = new List<HWS_VersionItem__c>();
	   listversion = [select id, HWS_NSNCodeRelation__c from HWS_VersionItem__c where HWS_NSNCodeRelation__c in :nsnCodeListtoUpdate]; 
	   
	 for(HWS_VersionItem__c veritem : listversion) 
	   {
		 HWS_VersionItem__c targetRecord = new HWS_VersionItem__c();
		 Id productId=mappingRecords.get(veritem.HWS_NSNCodeRelation__c);
		 targetRecord.HWS_Hardware_Sellable_Item__c = productId;
		 targetRecord.id =  veritem.id;
		 listversions.add(targetRecord) ;  
	   }
		
		
		List<Database.SaveResult> upsertVersionItem = Database.update(listversions, false);
		
	   for (Database.SaveResult result : upsertVersionItem) {
			if (!result.isSuccess()){
				for (Database.Error err : result.getErrors()){
					System.debug('Error: '+ err.getStatusCode() + ' ' + err.getMessage());
				}
			}
		}
		
		List<Database.SaveResult> updateServiceableVersionItem =   Database.update(listsrcrecord, false);
		
		listsrcrecord.clear();
		mappingRecords.clear();
		nsnCodeList.clear();
	}
	
	/****************************************
		 * Name : createErrorLog
		 * Description : creates an error log for errors occurred during product load
		 * Parameters: Database.Error[], Product record, Operation type
		 * Returns : Interfacelog
	 *****************************************/  
	public Interface_log__c createErrorLog(Database.Error[] errors, HWS_VersionItem__c product, String operationType)
	{
		  Interface_log__c ilog = new Interface_log__c();
			for (Database.Error err : errors)
			 {
				ilog.comment__c = 'Fields: '+err.getFields()+' Message: '+err.getMessage()+
													' Status Code: '+err.getStatusCode();
			 }
			ilog.Interface_Type__c = 'EDP Build Relation to Product2 and VI';
			ilog.Message_Type__c = 'Inbound';
			ilog.Operation_Type__c = operationType;
			ilog.Interface_Request_Sent__c = 'Product Name: '+product.Name;
			ilog.Status__c = 'Failure';
			ilog.Name = 'EDP Build Relation'+operationType+' failed with '+product.HWS_NSNCodeRelation__c;
			return ilog;

	}
	
	
	
	/****************************************
		 * Name : finish
		 * Description : finish method of batch class which calls price list item batch class to update 
		 *			  or create price list items from product sales items
		 * Parameters: Database.BatchableContext
		 * Returns : 
	 *****************************************/ 
	global void finish(Database.BatchableContext bc)
	{
		  if(!Test.isRunningTest()){
			  Integer batchSize=Integer.valueOf(HWS_Settings__c.getValues('ALTERNATECODE').SettingValue__c);
			  HWS_EDP_ProcessAlternateCodes_BATCH batch = new HWS_EDP_ProcessAlternateCodes_BATCH();
			  Database.executebatch(batch,batchSize);
		  }   
		  
	}


}