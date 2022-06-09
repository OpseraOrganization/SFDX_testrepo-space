public class CH_WorkgroupMemberController {
	
	@AuraEnabled
	public static String getRecordTypeName(String recordTypeId){
		System.debug('CH_CA: recordTypeId ' + recordTypeId);
		String returnedRecordTypes;
		String objectName = 'CH_Workgroup_Member__c';
		List<RecordType> recordTypeList = [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'CH_Workgroup_Member__c' AND Id =: recordTypeId LIMIT 1];
		String recordTypeName = recordTypeList.get(0).DeveloperName;
		System.debug('CH_CA: RecordTypeName ' + recordTypeName);
		return recordTypeName;
	}
}