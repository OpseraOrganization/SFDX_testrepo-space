/****************************************
 * Class Name : Batch_DupRCodeInSalesRoleTest
 * Created Date: 11 December 2017
 * Created By : Accenture
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for Batch Job to detect gaps in IWA role assignments
*****************************************/
@isTest
Private class Batch_GapsInRoleAssignmentTest{


	static testMethod void Batch_Gapstest(){ 


List<User> testUser = TestDataFactory.userCreation(3,'System Administrator');
insert testUser;
		
List<Apttus_Approval__ApprovalRuleAssignee__c> ruleAssigneeList = new List<Apttus_Approval__ApprovalRuleAssignee__c>();
List<Apttus_Approval__ApprovalRuleAssignee__c> ruleAssigneeList1 = new List<Apttus_Approval__ApprovalRuleAssignee__c>();
		list<String> RNamelist=new list<string>();
		list<String> RC_Levellist=new list<string>();
List<NF_Rolecode__c> roleCodeList = new List<NF_Rolecode__c>();
		
  NF_Rolecode__c currentRCode = new NF_Rolecode__c( Name = 'NSNE_PPS',Hierarchy_Level__c='L6', BG_Attribute__c='AA;FN;ION;MN;GS', NF_Multiple_level__c = true,A_S__c=true );
roleCodeList.add(currentRCode);
  NF_Rolecode__c currentRCode1 = new NF_Rolecode__c( Name = 'NSND_PPS',Hierarchy_Level__c='L5',BG_Attribute__c='AA;FN;ION;MN;GS', NF_Multiple_level__c = true,A_S__c=true );
roleCodeList.add(currentRCode1);
  NF_Rolecode__c currentRCode2 = new NF_Rolecode__c( Name = 'NSNC_HPS',Hierarchy_Level__c='L2', BG_Attribute__c='AA;FN;ION;MN;GS', A_S__c=true);
roleCodeList.add(currentRCode2);
 NF_Rolecode__c currentRCode3 = new NF_Rolecode__c( Name = 'NSND_NPS', Hierarchy_Level__c='L5',BG_Attribute__c='AA;FN;ION;MN;GS', A_S__c=true);
roleCodeList.add(currentRCode3);
 insert roleCodeList;
		
		
Sales_Role__c CurrentSalesOrg1 = NF_TestDataFactory.createSalesRole(testUser[0], 'NSNE_NPS', 'Market Europe', 'MN Market Head of Product Portfolio Sales');
CurrentSalesOrg1.BG__c = 'MN';
insert CurrentSalesOrg1;  

Sales_Role__c CurrentSalesOrg2 = NF_TestDataFactory.createSalesRole(testUser[0], 'NSNA_HPS', 'Market Europe', 'MN Market Head of Product Portfolio Sales');
CurrentSalesOrg2.BG__c = 'MN';
insert CurrentSalesOrg2;  
Apttus_Approval__ApprovalRule__c rule = NF_TestDataFactory.createApprovalRule('G3 Test', true, 'Opportunity', 'Condition', 1);
insert rule;

Apttus_Approval__ApprovalRuleEntry__c ruleEntry = NF_TestDataFactory.createRuleEntry(rule.Id,1);
insert ruleEntry;

String assigneeValue2 = 'Sales_Role__c(Role_Code__c LIKE \'%A__HPS\' AND O__c =\':Org_L2__c\' And Active__c=true AND (BG__C=\':Lead_BG__c\' OR BG__c=\':Lead_BU__c\').User__c';
Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee2 = NF_TestDataFactory.createArAssignee(ruleEntry.Id, 1, false, false,assigneeValue2);
ruleAssignee2.Apttus_Approval__AssigneeType__c = 'Custom User';
ruleAssignee2.Apttus_Approval__AssigneeDescription__c = 'HPS, Approver';
	ruleAssigneeList1.add(ruleAssignee2); 
	
String assigneeValue3 = 'Sales_Role__c(Role_Code__c LIKE \'%_NPS\' AND (O__c =\':Org_L4__c\' OR O__c =\':Org_L5__c\' OR O__c =\':Org_L6__c\'  OR O__c =\':Org_L7__c\') AND Active__c=true AND (BG__c=\'Lead_Bg__c\' OR BG__c=\'Lead_BU__c\')).User__c';
Apttus_Approval__ApprovalRuleAssignee__c ruleAssignee3 = NF_TestDataFactory.createArAssignee(ruleEntry.Id, 1, false, false,assigneeValue3);
ruleAssignee3.Apttus_Approval__AssigneeType__c = 'Custom User';
ruleAssignee3.Apttus_Approval__AssigneeDescription__c = 'NPS, Approver';
ruleAssigneeList.add(ruleAssignee3);   
 
		
insert ruleAssigneeList; 
insert ruleAssigneeList1; 


Test.startTest();

Batch_GapsInRoleAssignment batch= new Batch_GapsInRoleAssignment();
Database.BatchableContext BC;
SchedulableContext SC;  
batch.start(BC);
batch.Ar_Assignee_val_map.put(ruleAssignee3.Id,'_NPS');
batch.AssigneeID_Bgmap.put(ruleAssignee3.Id,'AA;FN;ION;MN;GS');
batch.RC_BGMap.put('_NPS','AA;FN;ION;MN;GS');
		 RNamelist.add('NSNE_NPS');
		RC_Levellist.add('L7');
batch.RC_Codemap.put('_NPS',RNamelist);
batch.execute(BC,ruleAssigneeList);
 batch.finish(BC);

Batch_GapsInRoleAssignment batch1= new Batch_GapsInRoleAssignment();
Database.BatchableContext BC1;

batch1.start(BC1);



batch1.Ar_Assignee_val_map.put(ruleAssignee2.Id,'_HPS');
batch1.AssigneeID_Bgmap.put(ruleAssignee2.Id,'AA;FN;ION;MN;GS');
batch1.RC_BGMap.put('_HPS','AA;FN;ION;MN;GS');
 RNamelist.add('NSNA_HPS');
batch1.RC_Codemap.put('_HPS',RNamelist);
batch1.execute(BC,ruleAssigneeList1);
batch1.finish(BC);
		
		
Test.StopTest();
}
}