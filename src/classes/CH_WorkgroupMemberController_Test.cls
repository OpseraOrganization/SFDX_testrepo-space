@istest
public class CH_WorkgroupMemberController_Test {
	@istest
	static void getRecordTypeName(){
		string recordTypeNameToSearch = 'CH_CA_WorkgroupMember';
		id recordTypeIdToSearch = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByName().get(recordTypeNameToSearch).getRecordTypeId();
		string recordTypeNameRetrieved = CH_WorkgroupMemberController.getRecordTypeName(recordTypeIdToSearch);
		System.assert(recordTypeNameRetrieved == recordTypeNameToSearch, 'Expected ' + recordTypeNameToSearch + '. Actual ' + recordTypeNameRetrieved);

		recordTypeNameToSearch = 'CH_KB_WorkgroupMember';
		recordTypeIdToSearch = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByName().get(recordTypeNameToSearch).getRecordTypeId();
		recordTypeNameRetrieved = CH_WorkgroupMemberController.getRecordTypeName(recordTypeIdToSearch);
		// Warning: there's a difference between the KB recordtype name and api name. CH_KB_WorkgroupMember and CH_KB_Workgroup_Members
		System.assert(recordTypeNameRetrieved == 'CH_KB_Workgroup_Members', 'Expected ' + recordTypeNameToSearch + '. Actual ' + recordTypeNameRetrieved);
	}
}