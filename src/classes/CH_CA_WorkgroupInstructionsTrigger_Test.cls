@isTest
public class CH_CA_WorkgroupInstructionsTrigger_Test {
	
	@isTest
	static void testtWorkgroupInstructions(){ 
		system.runAs(new User(Id = Userinfo.getUserId())){
			CH_ManageCreateQueueAsynchQueue.doChainJob= false;
			CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;   
			Id recordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByName().get('CH_CA_Workgroup').getRecordTypeId();
			CH_Workgroup__c workgroup = new CH_Workgroup__c();
			workgroup.name = 'WORKGROUPNAME';
	workgroup.RecordTypeId=recordTypeId;
			workgroup.CH_Workgroup_Instructions__c = 'This is a workgroup instruction';
			workgroup.CH_Type__c = 'Engineer;Smart Tier 1';
			insert workgroup;
			List<CH_WorkgroupInstructions__c> getListWorkgroupInst=new List<CH_WorkgroupInstructions__c>();
			CH_WorkgroupInstructions__c testWorkgroupInst=new CH_WorkgroupInstructions__c();
			testWorkgroupInst.CH_Active__c=true;
			testWorkgroupInst.CH_Workgroup__c = workgroup.Id;
			testWorkgroupInst.CH_AssignmentType__c='Active';
			testWorkgroupInst.CH_Severity__c='Major';
			Test.startTest();
			insert testWorkgroupInst;
			System.assertEquals('Active',testWorkgroupInst.CH_AssignmentType__c);
			testWorkgroupInst.CH_WorkgroupInstructions__c='Get instructions';
			update testWorkgroupInst;
			Test.stopTest();
		}
	}
	
	
	
	@isTest
	static void testPassiveWorkgroupInstructions(){ 
		system.runAs(new User(Id = Userinfo.getUserId())){
			CH_ManageCreateQueueAsynchQueue.doChainJob= false;
			CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;   
			Id recordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByName().get('CH_CA_Workgroup').getRecordTypeId();
			CH_Workgroup__c workgroup = new CH_Workgroup__c();
			workgroup.name = 'WORKGROUPNAME';
			workgroup.RecordTypeId=recordTypeId;
			workgroup.CH_Workgroup_Instructions__c = 'This is a workgroup instruction';
			workgroup.CH_Type__c = 'Engineer;Smart Tier 1';
			insert workgroup;
			CH_WorkgroupInstructions__c testWorkgroupInst=new CH_WorkgroupInstructions__c();
			testWorkgroupInst.CH_Active__c=true;
			testWorkgroupInst.CH_Workgroup__c = workgroup.Id;
			testWorkgroupInst.CH_AssignmentType__c='Passive';
			Test.startTest();
			insert testWorkgroupInst;
			testWorkgroupInst.CH_WorkgroupInstructions__c='Get instructions';
			testWorkgroupInst.CH_Active__c=false;
			update testWorkgroupInst;
			System.assertEquals('Get instructions',testWorkgroupInst.CH_WorkgroupInstructions__c);
			Test.stopTest();
		}
	}
	
	@isTest
	static void testKbWorkgroupInstructions(){ 
		system.runAs(new User(Id = Userinfo.getUserId())){
			Id kbRecordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByName().get('Workgroup').getRecordTypeId();
			CH_ManageCreateQueueAsynchQueue.doChainJob= false;
			CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;   
			CH_Workgroup__c workgroup = new CH_Workgroup__c();
			workgroup.name = 'WORKGROUPNAME';
			workgroup.RecordTypeId=kbRecordTypeId;
			workgroup.CH_Workgroup_Instructions__c = 'This is a workgroup instruction';
			workgroup.CH_Type__c = 'Engineer;Smart Tier 1';
			insert workgroup;
			CH_WorkgroupInstructions__c testWorkgroupInst=new CH_WorkgroupInstructions__c();
			testWorkgroupInst.CH_Active__c=False;
			testWorkgroupInst.CH_Workgroup__c = workgroup.Id;
			testWorkgroupInst.CH_AssignmentType__c='Passive';
			Test.startTest();
			try{
				insert testWorkgroupInst;
			}
			catch(Exception error) {
				System.Assert(error.getMessage().contains('The selected Workgroup isn’t a Case Handling Workgroup'));
				
			}
			Test.stopTest();
		}
		
	}
	
	
	
	@isTest
	static void testActiveWorkgroupInstructions(){ 
		system.runAs(new User(Id = Userinfo.getUserId())){
			CH_ManageCreateQueueAsynchQueue.doChainJob= false;
			CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;   
			Id recordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByName().get('CH_CA_Workgroup').getRecordTypeId();
			CH_Workgroup__c workgroup = new CH_Workgroup__c();
			workgroup.name = 'WORKGROUPNAME';
			workgroup.RecordTypeId=recordTypeId;
			workgroup.CH_Workgroup_Instructions__c = 'This is a workgroup instruction';
			workgroup.CH_Type__c = 'Engineer;Smart Tier 1';
			insert workgroup;
			List<CH_WorkgroupInstructions__c> getwWrkgpInst=new List<CH_WorkgroupInstructions__c>();
			CH_WorkgroupInstructions__c testWorkgroupInst=new CH_WorkgroupInstructions__c();
			testWorkgroupInst.CH_Active__c=true;
			testWorkgroupInst.CH_Workgroup__c = workgroup.Id;
			testWorkgroupInst.CH_AssignmentType__c='Passive';
			testWorkgroupInst.CH_WorkgroupInstructions__c='Passive Get instructions';
			getwWrkgpInst.add(testWorkgroupInst);
			CH_WorkgroupInstructions__c addCaseTeam=new CH_WorkgroupInstructions__c();
			addCaseTeam.CH_Active__c=true;
			addCaseTeam.CH_Workgroup__c = workgroup.Id;
			addCaseTeam.CH_AssignmentType__c='Case Team';
			getwWrkgpInst.add(addCaseTeam);
			Test.startTest();
			insert getwWrkgpInst;
			CH_CA_WorkgroupInstructionsTriggerHelper.duplicateworkgroupInstructions(getwWrkgpInst);
			System.assertEquals('Passive Get instructions',getwWrkgpInst[0].CH_WorkgroupInstructions__c);
			Test.stopTest();
		}
	}
}