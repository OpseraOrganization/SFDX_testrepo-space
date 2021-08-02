@istest
public class CH_Workgroup_Controller_Test {
	
	@testSetup
	public static void setup(){
		Test.startTest();	
		CH_UTIL_TEST.setupCase(false);	
		Test.stopTest();
	}
	
	@istest
	static void getRecordTypeName(){
		string recordTypeNameToSearch = 'CH_CA_WorkgroupMember';
		string objectType = 'CH_Workgroup_Member__c';
		id recordTypeIdToSearch = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByName().get(recordTypeNameToSearch).getRecordTypeId();
		string recordTypeNameRetrieved = CH_Workgroup_Controller.getRecordTypeName(recordTypeIdToSearch, objectType);
		System.assert(recordTypeNameRetrieved == recordTypeNameToSearch, 'Expected ' + recordTypeNameToSearch + '. Actual ' + recordTypeNameRetrieved);

		recordTypeNameToSearch = 'CH_KB_WorkgroupMember';
		recordTypeIdToSearch = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByName().get(recordTypeNameToSearch).getRecordTypeId();
		recordTypeNameRetrieved = CH_Workgroup_Controller.getRecordTypeName(recordTypeIdToSearch, objectType);
		// Warning: there's a difference between the KB recordtype name and api name. CH_KB_WorkgroupMember and CH_KB_Workgroup_Members
		System.assert(recordTypeNameRetrieved == 'CH_KB_Workgroup_Members', 'Expected ' + recordTypeNameToSearch + '. Actual ' + recordTypeNameRetrieved);
	}

	@istest
	static void getDefaultRecordTypeName(){
		string recordTypeNameToSearch = 'CH_CA_WorkgroupMember';
		string objectType = 'CH_Workgroup_Member__c';
		id recordTypeIdToSearch = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByName().get(recordTypeNameToSearch).getRecordTypeId();
		string recordTypeNameRetrieved = CH_Workgroup_Controller.getDefaultRecordTypeName(objectType);
		System.assert(recordTypeNameRetrieved == recordTypeNameToSearch, 'Expected ' + recordTypeNameToSearch + '. Actual ' + recordTypeNameRetrieved);
	}
	
	@istest
	static void getaccessCheck(){
		Test.startTest();	
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		Id getworkgroupRecordId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByName().get('CH_CA_Workgroup').getRecordTypeId();
		CH_Workgroup__c workgroup = new CH_Workgroup__c();
		workgroup.name = 'TestWorkgroup';
		workgroup.CH_Workgroup_Instructions__c = 'This is a workgroup instruction';
		workgroup.CH_Type__c = 'Engineer;Smart Tier 1';
		workgroup.RecordTypeId = getworkgroupRecordId;
		insert workgroup;
		
		id getworkgroupRuleRecordId = Schema.SObjectType.CH_Workgroup_Rule__c.getRecordTypeInfosByName().get('CH_CA_WorkgroupRule').getRecordTypeId();
		List<CH_Workgroup_Rule__c> newWorkgroupRules = new List<CH_Workgroup_Rule__c>();
		// Create an active rule
		CH_Workgroup_Rule__c rule = new CH_Workgroup_Rule__c ();
		rule.name = 'ACTIVE';
		rule.CH_Workgroup__c = workgroup.Id;
		rule.CH_Severity__c = 'Major';
		rule.CH_Outage__c = 'Yes';
		rule.CH_OrderNumber__c = 10;
		rule.RecordTypeId = getworkgroupRuleRecordId;
		insert rule;
		
		Boolean getAcess=CH_Workgroup_Controller.accessCheck(rule.Id);
		System.assert(getAcess== True,'Expect True. Actual: ' + getAcess);
		CH_Workgroup_Rule__c getRecrdTypeName=CH_Workgroup_Controller.getRecrdTypeName(rule.Id);
		Boolean getProfileCheck=CH_Workgroup_Controller.getValidUser();
		Test.StopTest(); 
	}
	
	@istest
	static void accessCheckMember(){
	 Test.startTest(); 
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;
		Id getworkgroupRecordId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByName().get('CH_CA_Workgroup').getRecordTypeId();
		CH_Workgroup__c workgroup = new CH_Workgroup__c();
		workgroup.name = 'TestWorkgroup';
		workgroup.CH_Workgroup_Instructions__c = 'This is a workgroup instruction';
		workgroup.CH_Type__c = 'Engineer;Smart Tier 1';
		workgroup.RecordTypeId = getworkgroupRecordId;
		insert workgroup;

		
		id getworkgroupMemberRecordId = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByName().get('CH_CA_WorkgroupMember').getRecordTypeId();
		List<CH_Workgroup_Member__c> newWorkgroupMember = new List<CH_Workgroup_Member__c>();
		// Create an active rule
		
		CH_Workgroup_Member__c member = new CH_Workgroup_Member__c ();
		 /*CH_Workgroup_Member__c workgroupMember = [SELECT Id,CH_User__c,	
												  FROM CH_Workgroup_Member__c 
												  WHERE CH_Role__c = 'Engineer' LIMIT 1];*/
		CH_Workgroup_Member__c workgroupMember = [SELECT Id,CH_User__c FROM CH_Workgroup_Member__c WHERE Name =:CH_UTIL_TEST.TEST_QUEUE_LABEL LIMIT 1];
		System.debug('---->'+workgroupMember);
		member.CH_Workgroup_Member_Type__c = 'Queue';
		member.CH_Workgroup__c = workgroup.Id;
		member.CH_Role__c = 'Queue';
		member.CH_User__c = workgroupMember.CH_User__c;
		member.RecordTypeId = getworkgroupMemberRecordId;
		insert member;
	   
		
		Boolean getAcess=CH_Workgroup_Controller.accessCheckMember(member.Id);
		//System.assert(getAcess== True,'Expect True. Actual: ' + getAcess);
		CH_Workgroup_Member__c getRecrdTypeNameMember=CH_Workgroup_Controller.getRecrdTypeNameMember(member.Id);
		 Test.stopTest();
	} 
}