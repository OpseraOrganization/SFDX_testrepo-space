/* Type:  Test Class
* Name - CH_CA_Workgroup_Member_Test
* Description - This class is used to test CH_CA_Workgroup_Member apex class
* Developer: TCS
* */
@isTest
public class CH_CA_Workgroup_Member_Test {  
	@testSetup
	static void setuptestdata(){
		CH_UTIL_TEST.setupCase(false);
	}
	
	// Get all case team members based on search criteria
	static testMethod void testGetWorkgroupMembersCaseTeam(){
		test.startTest();
		List<CH_Workgroup_Rule__c> validWorkgroupRules = [SELECT Id,Name,CH_Workgroup__c,CH_Workgroup__r.Name,
														   CH_OrderNumber__c,CH_Severity__c,CH_Outage__c,CH_Active__c 
														  FROM CH_Workgroup_Rule__c 
														  WHERE Name ='ACTIVE'];
		CH_CA_Workgroup_Member member = new CH_CA_Workgroup_Member();
		CH_CA_Assignment_Criteria_DTO caseAssignmentDetails = new CH_CA_Assignment_Criteria_DTO ();
		new CH_CA_Workgroup_Member().getWorkgroupMembersCaseTeam(validWorkgroupRules);
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembers = member.getWorkgroupMembersCaseTeam(validWorkgroupRules);
		test.stopTest();
		System.assert(workgroupMembers.size() == 6, 'Expected 6. Actual ' + workgroupMembers.size());
	}
	
	// Get all workgroup members for an active case with ROTA
	static testMethod void testGetWorkgroupMembersActiveCaseInitialAssignment(){
		test.startTest();
		List<CH_Workgroup_Rule__c> validWorkgroupRules = [SELECT Id,Name,CH_Workgroup__c,CH_Workgroup__r.Name,
														   CH_OrderNumber__c,CH_Severity__c,CH_Outage__c,CH_Active__c 
														  FROM CH_Workgroup_Rule__c 
														  WHERE Name ='ACTIVE'];
		CH_CA_Workgroup_Member member = new CH_CA_Workgroup_Member();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembers = member.getWorkgroupMembersActiveCaseInitialAssignment(validWorkgroupRules);
		test.stopTest();
		System.assert(workgroupMembers.size() == 5, 'Expected 5. Actual ' + workgroupMembers.size());		
	}

	// Get all workgroup members for an active case with ROTA
	static testMethod void testGetWorkgroupMembersActiveReCaseAssignment(){
		test.startTest();
		List<CH_Workgroup_Rule__c> validWorkgroupRules = [SELECT Id,Name,CH_Workgroup__c,CH_Workgroup__r.Name,
														   CH_OrderNumber__c,CH_Severity__c,CH_Outage__c,CH_Active__c 
														  FROM CH_Workgroup_Rule__c 
														  WHERE Name ='ACTIVE'];
		CH_CA_Workgroup_Member member = new CH_CA_Workgroup_Member();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembers = member.getWorkgroupMembersActiveCaseReAssignment(validWorkgroupRules);
		test.stopTest();
		System.assert(workgroupMembers.size() == 6, 'Expected 6. Actual ' + workgroupMembers.size());		
	}
	
	// Get all workgroup members for a passive case
	static testMethod void testGetWorkgroupMembersPassiveCaseAssignment(){
		test.startTest();
		CH_Workgroup__c workgroup = [SELECT Id FROM CH_Workgroup__c WHERE Name = 'Test' LIMIT 1];
		//Creating additional workgroup rule to cover
		CH_Workgroup_Rule__c rule = new CH_Workgroup_Rule__c ();
		rule.name = 'ACTIVE';
		rule.CH_Workgroup__c = workgroup.Id;
		rule.CH_Severity__c = 'Major';
		rule.CH_Outage__c = 'Yes';
		rule.CH_OrderNumber__c = 5;
		insert rule;
		List<CH_Workgroup_Rule__c> validWorkgroupRules = [SELECT Id,Name,CH_Workgroup__c,CH_Workgroup__r.Name,
														   CH_OrderNumber__c,CH_Severity__c,CH_Outage__c,CH_Active__c 
														  FROM CH_Workgroup_Rule__c 
														  WHERE Name ='ACTIVE'];
		
		
		
		CH_CA_Workgroup_Member member = new CH_CA_Workgroup_Member();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMembers = member.getWorkgroupMembersPassiveCaseAssignment(validWorkgroupRules);
		test.stopTest();
		System.assert(workgroupMembers.size() == 3, 'Expected 3. Actual ' + workgroupMembers.size());		
	}
}