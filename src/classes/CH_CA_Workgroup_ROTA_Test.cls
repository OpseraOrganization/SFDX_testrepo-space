/* Type:  Test Class
* Name - CH_CA_Workgroup_ROTA_Test
* Description - This class is used to test CH_CA_Workgroup_ROTA apex class
* Developer: TCS
* */
@isTest
public class CH_CA_Workgroup_ROTA_Test {
	@testSetup   
	static void setuptestdata(){  
		CH_UTIL_TEST.setupCase(false);	
	}
	
	static testMethod void testFilterWorkgroupMembersByAvailability(){
		Test.startTest();
		// Create case
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Major', 'Yes', 'Nokia Standard Case', false);
		Insert newCase;
		
		// Get all workgroup members for active assignment
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = [SELECT Id, CH_Workgroup__c, CH_OrderNumber__c 
														  FROM CH_Workgroup_Rule__c];		
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTOs = service.getActiveWorkgroupMembers(foundWorkgroupRules);
		system.assert(workgroupMemberDTOs.size()==5,'Expected 5. Actual ' + workgroupMemberDTOs.size());				
		// Get all workgroup members filtered by ROTA availability
		CH_CA_Workgroup_ROTA rota = new CH_CA_Workgroup_ROTA();
		workgroupMemberDTOs = rota.filterWorkgroupMembersByAvailability(workgroupMemberDTOs);
		Test.stopTest();
		
		system.assert(workgroupMemberDTOs.size()==5,'Expected 5. Actual ' + workgroupMemberDTOs.size());
	}
	
	static testMethod void testFilterWorkgroupMembersByAvailabilityWithoutHotline(){
		Test.startTest();
		// Create a case
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Major', 'Yes', 'Nokia Standard Case', false);
		Insert newCase;

		// Delete the hotline workgroup member
		List<CH_Workgroup_Rule__c> foundWorkgroupRules = [SELECT Id, CH_Workgroup__c, CH_OrderNumber__c 
														  FROM CH_Workgroup_Rule__c];		
		CH_Workgroup_Member__c hotline = [SELECT Id FROM CH_Workgroup_Member__c WHERE CH_Role__c = 'Hotline' AND CH_Workgroup__c = :foundWorkgroupRules[0].CH_Workgroup__c ];
		delete hotline;
		
		// Get all workgroup members for active assignment
		CH_CA_Service service = new CH_CA_Service(newCase.id);
		List<CH_CA_DTO.WorkgroupMemberDTO> workgroupMemberDTOs = service.getActiveWorkgroupMembers(foundWorkgroupRules);
		system.assert(workgroupMemberDTOs.size()==3,'Expected 3. Actual ' + workgroupMemberDTOs.size());				
		// Get all workgroup members filtered by ROTA availability
		CH_CA_Workgroup_ROTA rota = new CH_CA_Workgroup_ROTA();
		workgroupMemberDTOs = rota.filterWorkgroupMembersByAvailability(workgroupMemberDTOs);
		Test.stopTest();
		
		system.assert(workgroupMemberDTOs.size()==3,'Expected 3. Actual ' + workgroupMemberDTOs.size());
	}
}