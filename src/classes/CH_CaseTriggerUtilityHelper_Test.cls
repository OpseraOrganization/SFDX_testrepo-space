@isTest(seeAlldata=false)
public class CH_CaseTriggerUtilityHelper_Test {
	public static final string WORKGROUPNAME = 'TEST1';
	public static CaseTeamRole ctr ;
	public static case newProblemCase = new case ();
	public static string	newProblemCaseId = null;
	@testSetup static void testDataSetup(){
		String userval=UserInfo.getUserId();
		Profile pf= [Select Id from profile where Name='System Administrator']; 
		String orgId=UserInfo.getOrganizationId(); 
		String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000));
		String uniqueName=orgId+dateString+RandomId; 
		User uu=new User(firstname = 'ABC', 
						 lastName = 'XYZ', 
						 email = uniqueName + '@test' + orgId + '.org', 
						 Username = uniqueName + '@test' + orgId + '.org', 
						 EmailEncodingKey = 'ISO-8859-1', 
						 Alias = uniqueName.substring(18, 23), 
						 TimeZoneSidKey = 'America/Los_Angeles', 
						 LocaleSidKey = 'en_US', 
						 LanguageLocaleKey = 'en_US', 
						 ProfileId = pf.Id,
						 Nokia_ID__c = '12345'
						); 
		insert uu;
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CH_Expert'];
		PermissionSetAssignment psa = new PermissionSetAssignment();
		psa.AssigneeId = uu.Id;
		psa.PermissionSetId = ps.Id;
		insert psa;
		
		Group grp =  [SELECT Id, Name , type FROM Group where type='Regular' and name = 'SEC_GWC|ALL'];
		GroupMember grpMem1 = new GroupMember();
		grpMem1.UserOrGroupId = UserInfo.getUserId();
		grpMem1.GroupId = grp.Id;
		Insert grpMem1;
		
		
		
		system.runAs(uu){
			Test.startTest();
			
			List<CH_Workgroup__c> workGroups = new List<CH_Workgroup__c>();
			Id recordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByDeveloperName().get('CH_KB_Workgroup').getRecordTypeId();
			String MemberRecTypeId = Schema.getGlobalDescribe().get('CH_Workgroup_Member__c').getDescribe().getRecordTypeInfosByDeveloperName().get('CH_KB_Workgroup_Members').getRecordTypeId();
			CH_Workgroup__c workgroup = new CH_Workgroup__c(RecordTypeId = recordTypeId);
			workgroup.name = WORKGROUPNAME;
			workgroup.CH_End_of_Business_Hours_Threshold__c = 120;
			workgroup.CH_Start_of_Business_Hours_Threshold__c = 120;
			insert workgroup;
			
			CH_Workgroup_Member__c wgMember = new CH_Workgroup_Member__c();
			wgMember.CH_Workgroup__c = workgroup.id;
			wgMember.CH_User__c = UserInfo.getUserId();
			wgMember.CH_Role__c = 'Author';
			wgMember.RecordTypeId = MemberRecTypeId;
			insert wgMember;
			CH_Workgroup_Member__c wgMember2 = new CH_Workgroup_Member__c();
			wgMember2.CH_Workgroup__c = workgroup.id;
			wgMember2.CH_User__c = userval;
			wgMember2.CH_Role__c = 'Author';
			wgMember2.RecordTypeId = MemberRecTypeId;
			insert wgMember2;
			Product2 prodRec = new Product2();
			try{
				List<Case> caseList1 = new List<Case>();
				caseList1 = CAPS_TestDataUtil.createCaseRecord(1);
				
				prodRec.id =  caseList1[0].ProductId;
				prodRec.CH_Business_Unit__c = 'NSW Network Management'+caseList1[0].ProductId;
				update prodRec;
				caseList1[0].CH_Workgroup__c = workgroup.Id;
				caseList1[0].CH_ServiceType__c ='Customer Support';
				caseList1[0].Severity__c ='Critical';
				caseList1[0].CH_Outage__c ='Yes';
				insert caseList1;
				CH_CaseTriggerUtilityHelper.createCaseTeamHistoryOnAddingTeam(UserInfo.getUserId(),  caseList1[0].ID, 'Case Owner');
				ctr = [select id, name from CaseTeamRole where name= 'Incident Expert'];
				CaseTeamMember caseTeamMember;
				caseTeamMember = new CaseTeamMember();
				caseTeamMember.ParentId = caseList1[0].Id;
				caseTeamMember.MemberId = userval;
				caseTeamMember.TeamRoleId = ctr.Id;
				insert caseTeamMember;
				List<CaseTeamMember> membersForCaseTeam = new List<CaseTeamMember>();
				membersForCaseTeam.add(caseTeamMember);
				CH_CaseTriggerUtilityHelper.createCaseTeamHistoryOnCaseCreation(membersForCaseTeam);
				
				
			}catch(Exception ex){
				system.debug('Exception in test class'+ex);
			}
		  
			Test.stopTest();
			  List<CH_Settings__c> chSetList = new List<CH_Settings__c>();
		CH_Settings__c chSet = new CH_Settings__c();
		chSet.Name = 'Switch Between ROTA and Schedule';
		chSet.SettingValue__c = 'CH_CA_WorkgroupMemberSchedule';
		chSetList.add(chSet);
		insert chSet;
		system.assert(chSet.Id != null);
		newProblemCase = new Case();
		newProblemCase.CH_ReportedDate__c = DateTime.Now();
		newProblemCase.Mobile_Phone__c = '123-456789';
		newProblemCase.Country__c = 'Bahrain';
		newProblemCase.reason = 'New problem';
		newProblemCase.Subject = 'Survey Closed Case';
		newProblemCase.CH_Summary__c = 'TestSub';
		newProblemCase.Description = 'TEST';
		newProblemCase.Severity__c = 'Major';
		newProblemCase.CH_Outage__c = 'No';
		newProblemCase.Status = 'Created';
		newProblemCase.CH_IssueOccurenceDate__c = system.today();
		newProblemCase.ProductId = prodRec.Id;
		newProblemCase.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('CH_Problem').getRecordTypeId();
		newProblemCase.CH_RouteCase__c = true;
		newProblemCase.CH_Initial_Assignment__c = false;
		newProblemCase.ownerId = userinfo.getUserId();
	   
		insert newProblemCase;
		newProblemCaseId = newProblemCase.Id;
		system.assert(newProblemCase.Id !=null);
		}
	}
	
	public static testmethod void getOwnerBasedCase(){
		Case caseRec = [Select id,ProductId, OwnerId, CaseNumber,CH_Product_Name__c,CreatedDate,CH_ServiceType__c,Severity__c, CH_Outage__c, CH_Account_Name__c, CH_BusinessUnit__c, CH_ExternalBridge__c, Country__c  from Case limit 1];
		User userRec = [Select Id,Nokia_ID__c from User where Name Like '%XYZ%']; 
		
		
		String userval = userInfo.getUserId();
		system.runAs(userRec){
			test.startTest();
			try{
				
				caseRec.ownerId = userval;
				update caseRec;
				List<CaseTeamMember> membersForCaseTeam = [select id , MemberId, ParentId, TeamRole.Name from CaseTeamMember limit 1];
				CH_CaseTriggerUtilityHelper.updateExitTimeCaseHistory(membersForCaseTeam[0]);
			}catch(Exception ex){
				system.debug('Exception in test class'+ex);
			}
			
			test.stopTest();
			Case prbCAse = [select id from case where recordType.Name = 'Problem' ];
			caseRec.CH_Problem__c = prbCAse.Id;
			update caseRec;
		}
	}
}