public with sharing class CH_CA_TestWorkgroupRules_Controller {
	// This method is used to get reuired workgrouprule.
	@AuraEnabled
	public static List <sObject> fetchFilterValues(String Contract, String Severity, String Region, String Country, 
	  String levelOfSupport, String Customer, String CustomerGroup, 
	  String Product, String ProductGroup, string Outage,String Active,
	  String WorkgroupType,String ServiceType,String productModule,
	  String productVariant,String productRelease,String solution,string contractType)
	{
		List<string> levelOfSupports = new List<string>();
		List<string> workgorupTypes = new List<string>();  
		if (!String.isBlank(levelOfSupport)){
	levelOfSupports.add(levelOfSupport);
		}
		if (!String.isBlank(workgroupType)){
	 workgorupTypes.add(WorkgroupType);
		}
		CH_CA_Assignment_Criteria_DTO caseAssignmentDetails = new CH_CA_Assignment_Criteria_DTO();
		caseAssignmentDetails.contractType = contractType;
		caseAssignmentDetails.contract = Contract;
		caseAssignmentDetails.severity = Severity;
		caseAssignmentDetails.region = Region;
		caseAssignmentDetails.country = Country; 
		caseAssignmentDetails.levelOfSupport = levelOfSupports;
		caseAssignmentDetails.customerId = String.isBlank(Customer) ? null : Customer;
		caseAssignmentDetails.GetCustomerGroupsForCustomer();
		caseAssignmentDetails.customerGroupId = String.isBlank(CustomerGroup) ? null : CustomerGroup;
		caseAssignmentDetails.productId = String.isBlank(Product) ? null : Product;
		caseAssignmentDetails.GetProductGroupsForProduct();
		caseAssignmentDetails.productGroupId = String.isBlank(ProductGroup) ? null : ProductGroup;
		caseAssignmentDetails.outage = Outage;
		caseAssignmentDetails.active= Active; 
		caseAssignmentDetails.workgroupType=workgorupTypes; 
		caseAssignmentDetails.serviceType = serviceType; 
		caseAssignmentDetails.productModule = String.isBlank(productModule) ? null : productModule;//Changes US NOKIASC-22205
		caseAssignmentDetails.productVariant = String.isBlank(productVariant) ? null : productVariant;//Changes US NOKIASC-22205
		caseAssignmentDetails.productRelease = String.isBlank(productRelease) ? null : productRelease;
		caseAssignmentDetails.solution = String.isBlank(solution) ? null : solution;//Changes US NOKIASC-22205
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = CH_CA_Workgroup_Rule.GetWorkgroupRules(caseAssignmentDetails);
		return foundWorkgroupRules;
	}
	
	// This method is used to delete required workgrouprule.
	@AuraEnabled
	public static void deleteRule(String idstr){
		CH_Workgroup_Rule__c deletedRecord = new CH_Workgroup_Rule__c();
		deletedRecord.Id = idstr;
		delete deletedRecord;
	}
	
	// This method is used for holding values of dependent picklist.
	@AuraEnabled
	public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName){
		String controllingField = contrfieldApiName.toLowerCase();
		String dependentField = depfieldApiName.toLowerCase();
		Map<String,List<String>> objResults = new Map<String,List<String>>();
		Schema.sObjectType objType = objDetail.getSObjectType();
		if (objType==null){
			return objResults;
		}
		Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
		
		if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
			return objResults;
		}
		Schema.SObjectField theField = objFieldMap.get(dependentField);
		Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
		
		List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
		List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
		List<String> controllingValues = new List<String>();
		
		for (Schema.PicklistEntry ple : contrEntries){
			String label = ple.getLabel();
			objResults.put(label, new List<String>());
			controllingValues.add(label);
		}
		for (PicklistEntryWrapper plew : depEntries) {
			String label = plew.label;
			String validForBits = base64ToBits(plew.validFor);
			for (Integer i = 0; i < validForBits.length(); i++) {
	String bit = validForBits.mid(i, 1);
	if (bit == '1') {
		objResults.get(controllingValues.get(i)).add(label);
	}
			}
		}
		return objResults;
	}
	
	// This method is internal method of getDependentMap.
	public static String base64ToBits(String validFor){
		if (String.isEmpty(validFor)){
			return '';
		}
		String validForBits = '';
		for (Integer i = 0; i < validFor.length(); i++) {
			String thisChar = validFor.mid(i, 1);
			Integer val = base64Chars.indexOf(thisChar);
			String bits = decimalToBinary(val).leftPad(6, '0');
			validForBits += bits;
		}
		return validForBits;
	}
	
	// This method is internal method of base64ToBits.
	public static String decimalToBinary(Integer val){
		String bits = '';
		while (val > 0) {
			Integer remainder = Math.mod(val, 2);
			val = Integer.valueOf(Math.floor(val / 2));
			bits = String.valueOf(remainder) + bits;
		}
		return bits;
	}
	
	private static final String base64Chars = '' +
		'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
		'abcdefghijklmnopqrstuvwxyz' +
		'0123456789+/';
	
	// This method is used for wrapping picklist values.
	private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs){
		return (List<PicklistEntryWrapper>) JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
	}
	
	public class PicklistEntryWrapper{
		public String active {get;set;}
		public String defaultValue {get;set;}
		public String label {get;set;}
		public String value {get;set;}
		public String validFor {get;set;}
		public PicklistEntryWrapper(){}
	}
	
	@AuraEnabled
	public static List<String> getRecords() {  
		List<String> pickListValues= CH_CA_WorkGroup_Rule_Controller.getCdbRecords();
		return pickListValues;
	}
	
	//Below method added under NOKIASC-32652
	//Return Product Relesase as per Product selected and Value searched
	@AuraEnabled
	public static List<CH_ProductRelease__c> fetchProductRelRecords(String value,String productId) {
		try {
			List<CH_ProductRelease__c> recordsDataList = new List<CH_ProductRelease__c>();
			String query = '';
			if(String.isNotBlank(productId) && String.isNotBlank(value)) {
				query = 'SELECT Id, Name FROM CH_ProductRelease__c WHERE CH_ProductId__c=' + '\''+productId+ '\'';
				query += ' And Name LIKE ' + '\'' + String.escapeSingleQuotes(value.trim()) + '%\'';
				
			}else if(String.isNotBlank(productId)){
				query = 'SELECT Id, Name FROM CH_ProductRelease__c WHERE CH_ProductId__c=' + '\''+productId+ '\''+'';
			}else if(String.isNotBlank(value)){
				query = 'SELECT Id, Name FROM CH_ProductRelease__c WHERE Name LIKE ' + '\'' + String.escapeSingleQuotes(value.trim()) + '%\'';
			}
			if(String.isNotBlank(query)){
		 	recordsDataList=Database.query(query);
			}
			return recordsDataList;
	 } catch (Exception err) {
	 	if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
				throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
			} else {
				throw new AuraHandledException(err.getMessage());
			}
	 }
	}
}