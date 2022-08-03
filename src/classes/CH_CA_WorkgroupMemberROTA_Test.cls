@istest
public class CH_CA_WorkgroupMemberROTA_Test {
	
	@testSetup   
	static void setuptestdata(){  
		CH_UTIL_TEST.setupCase(false);   
	}	
	
	@istest
	static void getWorkgroupMembersCaseTeam(){
		test.starttest();
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = [SELECT Id, CH_Workgroup__c, CH_OrderNumber__c 
	FROM CH_Workgroup_Rule__c];		

		CH_CA_WorkgroupMemberROTA rota = new CH_CA_WorkgroupMemberROTA();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTOs = rota.getWorkgroupMembersCaseTeam(foundWorkgroupRules, null);
		test.stoptest();

		system.assert(workgroupMemberDTOs.size()==6,'Expected 6. Actual ' + workgroupMemberDTOs.size());
	}

	@istest
	static void getWorkgroupMembersCaseTeamAvailability(){
		test.starttest();
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = [SELECT Id, CH_Workgroup__c, CH_OrderNumber__c 
	FROM CH_Workgroup_Rule__c];		

		CH_CA_WorkgroupMemberROTA rota = new CH_CA_WorkgroupMemberROTA();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTOs = rota.getWorkgroupMembersCaseTeamAvailability(foundWorkgroupRules, null);
		test.stoptest();

		system.assert(workgroupMemberDTOs.size()==6,'Expected 6. Actual ' + workgroupMemberDTOs.size());		
	}
	
	@istest
	static void getWorkgroupMembersActiveCaseInitialAssignment(){
		test.starttest();
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = [SELECT Id, CH_Workgroup__c, CH_OrderNumber__c 
	FROM CH_Workgroup_Rule__c];		

		CH_CA_WorkgroupMemberROTA rota = new CH_CA_WorkgroupMemberROTA();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTOs = rota.getWorkgroupMembersActiveCaseInitialAssignment(foundWorkgroupRules, null);
		test.stoptest();

		system.assert(workgroupMemberDTOs.size()==5,'Expected 5. Actual ' + workgroupMemberDTOs.size());		
	}
	
	@istest
	static void getWorkgroupMembersActiveCaseReAssignment(){
		test.starttest();
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = [SELECT Id, CH_Workgroup__c, CH_OrderNumber__c 
	FROM CH_Workgroup_Rule__c];		

		CH_CA_WorkgroupMemberROTA rota = new CH_CA_WorkgroupMemberROTA();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTOs = rota.getWorkgroupMembersActiveCaseReAssignment(foundWorkgroupRules, null);
		test.stoptest();

		system.assert(workgroupMemberDTOs.size()==6,'Expected 6. Actual ' + workgroupMemberDTOs.size());		
	}
	
	@istest
	static void getWorkgroupMembersPassiveCaseAssignment(){
		test.starttest();
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = [SELECT Id, CH_Workgroup__c, CH_OrderNumber__c 
	FROM CH_Workgroup_Rule__c];		

		CH_CA_WorkgroupMemberROTA rota = new CH_CA_WorkgroupMemberROTA();
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTOs = rota.getAllWorkgroupMembersPassiveCaseAssignment(foundWorkgroupRules, null);
		test.stoptest();

		system.assert(workgroupMemberDTOs.size()==3,'Expected 3. Actual ' + workgroupMemberDTOs.size());		
	}
}