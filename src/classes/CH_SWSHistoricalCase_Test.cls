/*******************************************************************************************
* Class Name : CH_SWSHistoricalCase_Test
* Created By : TCS
* Last Modified by: TCS
* Description : Test Class for CH_SWSHistorical_CaseTeamHistUpdate, CH_SWSHistorical_DeleteCaseTeam
	and CH_SWSHistoricalCase_OwnerUpdate
* User Story : https://jiradc2.ext.net.nokia.com/browse/NOKIASC-33494 
********************************************************************************************/
@isTest(SeeAllData=false)
public class CH_SWSHistoricalCase_Test {  
	@testSetup
	static void setuptestdata(){ 
		Test.startTest();
		CH_UTIL_TEST.setupCase(false);
		Test.stopTest();
	}
	@istest
	static void caseTeamMemberdelte(){
		Test.startTest(); 
		CH_CaseStatus_Validation_Bypass__c cussett = new CH_CaseStatus_Validation_Bypass__c();
		cussett.CH_Disable_Validation_Rules__c = true;
		insert cussett;
		Case newCase = CH_UTIL_TEST.createCaseNotSaved('TEST1', 'Minor', 'No', 'CH_NokiaIncidentWithRestoration', false);
		CH_Workgroup_Member__c workgroupMember = [SELECT CH_User__c, CH_Workgroup__c	
			  FROM CH_Workgroup_Member__c 
			  WHERE CH_Role__c = 'Engineer' LIMIT 1];
		newCase.OwnerId = workgroupMember.CH_User__c;
		newCase.CH_Workgroup__c = workgroupMember.CH_Workgroup__c;
		newCase.Status = 'Cancelled';
		insert newCase;
		List<CaseTeamMember> caseTeamMembers = CH_CA_CaseTeam_Controller.getCaseTeamMembers(newCase.id);	
		CH_SWSHistorical_DeleteCaseTeam obj1 = new CH_SWSHistorical_DeleteCaseTeam();
		Database.executeBatch(obj1); 
		CH_SWSHistoricalCase_OwnerUpdate obj2 = new CH_SWSHistoricalCase_OwnerUpdate();
		Database.executeBatch(obj2);
		CH_SWSHistorical_CaseTeamHistUpdate obj3 = new CH_SWSHistorical_CaseTeamHistUpdate();
		Database.executeBatch(obj3);
		Test.stopTest();
	}
	
	
}