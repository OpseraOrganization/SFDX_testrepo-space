public class CH_Process_ProductPortfolioItem_SVC {
	
	private final string targetExternalId = 'NCP_NOKIA_PRODUCT_ID__C';
	private final string parameterSectionName = 'CH_Product2';
	private CH_Product_Mapping_Rules mappingRules;
	private string sourceObjectName;
	private string targetObjectName;
	
	private List<Product2> recordsToUpdate = new List<Product2>();
	private List<CH_ProductRelation__c> relationShipRecordsToUpdate = new List<CH_ProductRelation__c>();

	// Assumption that the parameter grouping contains 1 source and 1 target object
	// Constructor that gets the mapping parameters
	public CH_Process_ProductPortfolioItem_SVC(){
		mappingRules = new CH_Product_Mapping_Rules(parameterSectionName);
		sourceObjectName = mappingRules.sourceObjectName;
		targetObjectName = mappingRules.targetObjectName;
	}
	
	// Process the record
	public void execute(Product_Portfolio_Item__c recordToProcess){
		
		// If no mapping parameters found then end 
		if (mappingRules.mapping.keySet().size() == 0){
			return;
		}
		
		Product_Portfolio_Item__c sourceRecord = (Product_Portfolio_Item__c)mappingRules.getSourceRecord(recordToProcess.id);
		Product2 targetRecord = new Product2(); 
		
		//Update all fields for the target record
		targetRecord = (Product2)mappingRules.mapDataFromSourceToTarget(sourceRecord, targetRecord);

		//CH_ProductRelation__c
		List<CH_ProductRelation__c> targetRelationShip = mappingRules.getParentRecords(targetRecord.NCP_NOKIA_PRODUCT_ID__C);		
		relationShipRecordsToUpdate.addAll(targetRelationShip);
			
		System.debug(recordToProcess.Id);
		recordsToUpdate.add((Product2)targetRecord);
	}
	
	public void SaveChanges(){
		Schema.SObjectType objectDescription = Schema.getGlobalDescribe().get(targetObjectName);
		Schema.DescribeSObjectResult r = objectDescription.getDescribe();
		Schema.SObjectField targetExternalField = r.fields.getMap().get(targetExternalId);
		Database.upsert(recordsToUpdate, targetExternalField, false);
		
		Database.upsert(relationShipRecordsToUpdate, CH_ProductRelation__c.CH_ExternalId__c, false);	   
	}
}