public class CH_CaseField_AssessApex {
 	@AuraEnabled
	public static List<String> getPickVal(sObject caseObject, string fieldId){
		system.debug('caseObject --->' + caseObject);
	system.debug('fieldId --->' + fieldId);
	List < String > alloptions = new list < String > ();
		
	 // Get the object type of the SObject.
	Schema.sObjectType objType = caseObject.getSObjectType();
 
	// Describe the SObject using its object type.
	Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
 
	// Get a map of fields for the SObject
	map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
 
	// Get the list of picklist values for this field.
	list < Schema.PicklistEntry > allValues =
		fieldMap.get(fieldId).getDescribe().getPickListValues();
 
	// Add these values to the selectoption list.
	for (Schema.PicklistEntry a: allValues) {
			alloptions.add(a.getValue());
	}
	system.debug('alloptions ---->' + alloptions);
	alloptions.sort();
	return alloptions;
	}
}