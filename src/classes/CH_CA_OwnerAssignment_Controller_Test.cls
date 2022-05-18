@isTest
public class CH_CA_OwnerAssignment_Controller_Test {
	public static final string NSC='CH_NokiaStandardCase';
	@testSetup  
	static void setuptestdata(){   
		Test.startTest();
		CH_UTIL_TEST.setupCase(false); 
		Test.stopTest();
	}  
	
	@isTest
	static void TestisActiveAssignment(){  
		test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_OwnerAssignment_Controller_Test.NSC, false);
		Insert newCase; 
		
		Boolean activeAssignment = CH_CA_OwnerAssignment_Controller.isActiveAssignment(newCase.Id);
		System.assert(activeAssignment == false,'Expect passive assignment');
		test.stoptest();
	}
	
	@isTest
	static void TestGetWorkgroupMembersOutageNo(){ 
		test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_OwnerAssignment_Controller_Test.NSC, false);
		Insert newCase; 
		Test.stoptest();
		List<CH_CA_DTO.WorkgroupMemberDTO> foundWorkgroupMembers = CH_CA_OwnerAssignment_Controller.getWorkgroupMembers(newCase.Id, false);
		System.assert(foundWorkgroupMembers.size() == 3,'Expect 3. Actual ' + foundWorkgroupMembers.size());
		
	}
	
	@isTest
	static void TestGetWorkgroupMembersActiveAssignment(){ 
	 
		Test.starttest();
		Case newCase1 = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_OwnerAssignment_Controller_Test.NSC, false);
		Insert newCase1; 
		Test.stopTest();
		List<CH_CA_DTO.WorkgroupMemberDTO> foundWorkgroupMembers = CH_CA_OwnerAssignment_Controller.getWorkgroupMembers(newCase1.Id, false);
		System.assert(foundWorkgroupMembers.size() == 3,'Expect 3. Actual ' + foundWorkgroupMembers.size());
		
	}
	
	@isTest
	static void TestGetWorkgroupMembersSeverityCritical(){ 
		test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Critical', 'No', CH_CA_OwnerAssignment_Controller_Test.NSC, false);
		Insert newCase;	 
		Test.stopTest();
		List<CH_CA_DTO.WorkgroupMemberDTO> foundWorkgroupMembers = CH_CA_OwnerAssignment_Controller.getWorkgroupMembers(newCase.Id, false);
		System.assert(foundWorkgroupMembers.size() == 5,'Expect 5. Actual ' + foundWorkgroupMembers.size());
		
	}
	
	@isTest
	static void testgetWorkgroupInstructions(){ 
		test.starttest();
		//Setup a new case that has not been assigned so no workgroup
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_OwnerAssignment_Controller_Test.NSC, false);
		Id getCaseWorkgroupRecordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByDeveloperName().get('CH_CA_Workgroup').getRecordTypeId();
		CH_Workgroup__c workgroup = [select id, Name, RecordTypeId from CH_Workgroup__c where name=:CH_UTIL_TEST.WORKGROUPNAME LIMIT 1];
		workgroup.RecordTypeId = getCaseWorkgroupRecordTypeId; //replacing the exisitng workgroup's record type by CH_CA_Workgroup record type
		update workgroup;
		newCase.CH_Workgroup__c = workgroup.Id;
		insert newCase;
		CH_WorkgroupInstructions__c workGroupInstructions = new CH_WorkgroupInstructions__c(CH_Workgroup__c = workgroup.Id , CH_Active__c = TRUE, CH_AssignmentType__c = 'Passive', CH_Severity__c = 'Minor');
		insert workGroupInstructions;
		newCase = [SELECT Id, CH_Workgroup__c FROM Case WHERE Id =:newCase.Id];
		// Get the workgroup instructions of the workgroup from the first found rule
		CH_CA_OwnerAssignment_Controller.getWorkgroupInstructions(newCase.Id,newCase.CH_Workgroup__c,'');
		test.stoptest();
	}
	
	@isTest
	static void testgetWorkgroupName(){ 
		test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_OwnerAssignment_Controller_Test.NSC, false);
		Insert newCase; 
		CH_CA_OwnerAssignment_Controller.getWorkgroupName(newCase.Id); 
		test.stoptest();
	}
	
	@isTest
	static void TestUpdateActiveSupportTicketOwnerCoverCatchBlock(){
		test.starttest();
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', CH_CA_OwnerAssignment_Controller_Test.NSC, false);
		newCase.Status = null;
		Insert newCase; 
		test.stoptest();
		
		system.runAs(new User(Id = Userinfo.getUserId())){
			try {
	CH_Workgroup_Member__c workgroupMember = [SELECT Id   
				FROM CH_Workgroup_Member__c 
				WHERE CH_Role__c = 'Engineer' LIMIT 1];
	
	// Test active assignment
	CH_CA_OwnerAssignment_Controller.updateSupportTicketOwner(newCase.Id, workgroupMember.id);
			} catch (Exception e) {
	System.assert(e.getMessage()!=null);
			}   
		}
	}   
}