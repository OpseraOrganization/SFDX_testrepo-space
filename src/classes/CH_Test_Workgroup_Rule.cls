public with sharing class CH_Test_Workgroup_Rule {

	// This method is used to get reuired workgrouprule. 
	@AuraEnabled
	public static List <sObject> fetchFilterValues(String Contract, String Severity, String Region, String Country, 
												   String levelOfSupport, String Customer, String CustomerGroup, 
												   String Product, String ProductGroup, string Outage) 
	{
		List<string> levelOfSupports = new List<string>();
		if (!String.isBlank(levelOfSupport))
		{
			levelOfSupports.add(levelOfSupport); 
		}
		
		CH_CaseAssignment caseAssignmentDetails = new CH_CaseAssignment();
		caseAssignmentDetails.contract = '';
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
		
		CH_DisplayWorkgroupHelper helper = new CH_DisplayWorkgroupHelper();
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = helper.GetWorkgroupRules(caseAssignmentDetails);
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
	public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName) 
	{
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
		
		for (Schema.PicklistEntry ple : contrEntries) {
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
	public static String base64ToBits(String validFor) 
	{
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
	public static String decimalToBinary(Integer val) 
	{
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
	private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) 
	{
		return (List<PicklistEntryWrapper>) JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
	}
	
	public class PicklistEntryWrapper
	{
		public String active {get;set;}
		public String defaultValue {get;set;}
		public String label {get;set;}
		public String value {get;set;}
		public String validFor {get;set;}
		public PicklistEntryWrapper(){			
		}
	}
}