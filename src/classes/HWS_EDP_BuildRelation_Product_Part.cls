global class HWS_EDP_BuildRelation_Product_Part implements Database.Batchable<sObject>,Database.Stateful,Schedulable{

	  /****************************************
		 * Name : execute
		 * Description : executes the batch class using schedulable instance
		 * Parameters: SchedulableContext
	 *****************************************/
	global void execute(SchedulableContext sc)	  
	{
		HWS_EDP_BuildRelation_Product_Part  batch= new HWS_EDP_BuildRelation_Product_Part();
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
	   
	  String sQuery='SELECT Id,HWS_SourceSystem__c, HWS_HWSSIPartNumber__c ,HWS_ProductCode__c  FROM HWS_Product_Serviceable_Relations__c WHERE HWS_Is_Processed__c = false';
	  return database.getQueryLocator(sQuery);
	}

	 /****************************************
		 * Name : execute
		 * Description : Retrieves the data from product serviceable sales item staging object
		 * Parameters: Database.BatchableContext, List of Product sales item
		 * Returns :
	 *****************************************/	
	global void execute(Database.BatchableContext bc, List<HWS_Product_Serviceable_Relations__c> serviceableRelations)
	{	
		List<CH_ProductRelation__c> lstChProductRelation=new List<CH_ProductRelation__c>();
		List<String> lstProductCode= new List<String>();
	   
	 
		for(HWS_Product_Serviceable_Relations__c record:serviceableRelations){
			lstProductCode.add(record.HWS_HWSSIPartNumber__c);
			lstProductCode.add(record.HWS_ProductCode__c);
		}
	   
	   
		List<Product2> lstProduct2=[Select id,ProductCode,APTS_Ext_ID__c ,NokiaCPQ_Item_Type__c from Product2 where HWS_DoNotConsider__c=false and (ProductCode in :lstProductCode or APTS_Ext_ID__c in :lstProductCode)];
		Map<String,Id> mapProductcodeId=new Map<String,Id>();
		Map<String,Id> mapAPTSExtId=new   Map<String,Id>();
   
		for(Product2 recordProd:lstProduct2){
			if(recordProd.NokiaCPQ_Item_Type__c == 'Hardware'){
				mapProductcodeId.put(recordProd.ProductCode,recordProd.Id);
			} else{
				mapAPTSExtId.put(recordProd.APTS_Ext_ID__c,recordProd.Id);
			}
		}
	   
		List<Id> recordToUpdate=new List<Id>();
		Set<String> setServiceRelRecords= new Set<String>();
		for(HWS_Product_Serviceable_Relations__c record : serviceableRelations){			
			CH_ProductRelation__c objChProductRelation = new  CH_ProductRelation__c();
			objChProductRelation.CH_Child_Product__c = mapProductcodeId.get(record.HWS_HWSSIPartNumber__c);
			objChProductRelation.CH_Parent_Product__c = mapAPTSExtId.get(record.HWS_ProductCode__c);
			 objChProductRelation.CH_ExternalId__c =  record.HWS_HWSSIPartNumber__c+record.HWS_ProductCode__c+ record.HWS_SourceSystem__c;			
			if(!setServiceRelRecords.contains(objChProductRelation.CH_ExternalId__c) && objChProductRelation.CH_Child_Product__c != null && objChProductRelation.CH_Parent_Product__c !=null ){
			   lstChProductRelation.add(objChProductRelation);
			   recordToUpdate.add(record.Id);
			   setServiceRelRecords.add(objChProductRelation.CH_ExternalId__c);			
			 }
		}
	   
		List<HWS_Product_Serviceable_Relations__c> lstToUpdate=[Select id,HWS_ProductCode__c,HWS_Is_Processed__c from HWS_Product_Serviceable_Relations__c where id in :recordToUpdate];
		for(HWS_Product_Serviceable_Relations__c rec:lstToUpdate){
			rec.HWS_Is_Processed__c=true;
		}	  
	   
		update lstToUpdate;
		Database.UpsertResult[] results = Database.upsert(lstChProductRelation,CH_ProductRelation__c.CH_ExternalId__c );
	}
   
	/****************************************
		 * Name : createErrorLog
		 * Description : creates an error log for errors occurred during product load
		 * Parameters: Database.Error[], Product record, Operation type
		 * Returns : Interfacelog
	 ***************************************/
  //  public Interface_log__c createErrorLog(Database.Error[] errors,String operationType)
 //   {

  //  }
 
   
   
	/****************************************
		 * Name : finish
		 * Description : finish method of batch class which calls price list item batch class to update
		 *			  or create price list items from product sales items
		 * Parameters: Database.BatchableContext
		 * Returns :
	 *****************************************/
	global void finish(Database.BatchableContext bc)
	{
		   
		 
	}

}