public class CH_Process_ProductRelease_SVC {

	private final string targetExternalId = 'CH_NSNLegacyCode__c';
	private final string parameterSectionName = 'CH_ProductRelease';
	private final string childRelationshipType = 'NSN Release';
	private CH_Product_Mapping_Rules mappingRulesService;
	private string sourceObjectName;
	private string targetObjectName;
	
	private List<CH_ProductRelease__c> recordsToUpdate = new List<CH_ProductRelease__c>();
	
	// Assumption that the parameter grouping contains 1 source and 1 target object
	// Constructor that gets the mapping parameters
	public CH_Process_ProductRelease_SVC(){
		mappingRulesService = new CH_Product_Mapping_Rules(parameterSectionName);
		sourceObjectName = mappingRulesService.sourceObjectName;
		targetObjectName = mappingRulesService.targetObjectName;
	}
	
	// Process the record
	public void execute(ProductRelease__c recordToProcess){

		// If no mapping parameters found then end 
		if (mappingRulesService.mapping.keySet().size() == 0){
			return;
		}
		
		ProductRelease__c sourceRecord = (ProductRelease__c)mappingRulesService.getSourceRecord(recordToProcess.id);
		CH_ProductRelease__c targetRecord = new CH_ProductRelease__c(); 

		//Update all fields for the target record
		targetRecord = (CH_ProductRelease__c)mappingRulesService.mapDataFromSourceToTarget(sourceRecord, targetRecord);
		
		// Lookup the Product2.Id to setup the product - release master detail relationship
		targetRecord.CH_ProductId__c = mappingRulesService.getParentRecord(targetRecord.CH_NSNLegacyCode__c, childRelationshipType);
		
		System.debug(recordToProcess.Id);
		recordsToUpdate.add((CH_ProductRelease__c)targetRecord);			   
	}
	   
	public void SaveChanges(){
		Schema.SObjectType objectDescription = Schema.getGlobalDescribe().get(targetObjectName);
		Schema.DescribeSObjectResult r = objectDescription.getDescribe();
		Schema.SObjectField targetExternalField = r.fields.getMap().get(targetExternalId);

		Database.upsert(recordsToUpdate, targetExternalField, false);
	}
}