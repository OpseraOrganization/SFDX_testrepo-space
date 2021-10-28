/*************
* Replacing NF_EditAssignmentsTriggerHelperTest
* author: Joao Rodrigues
* *****************/
@isTest
Private class SalesRoleTriggerTest
{
	static testMethod void insertupdatetest()
	{
		Sales_Role__c currentSalesOrg;
		Sales_Role__c currentSalesOrg1;
		Sales_Role__c currentSalesOrg2;
		Sales_Role__c currentSalesOrg3;
		Sales_Role__c currentSalesOrg4;
		Sales_Role__c currentSalesOrg5;
		Sales_Role__c currentSalesOrg6;
		
		List<User> testUser = NF_TestDataFactory.getUsers(3,'System Administrator');
		insert testUSer;
		System.runAs(testUSer[0])
		{ 
			List<Sales_Role__c> SRList = new List<Sales_Role__c>();
			List<Sales_Role__c> SR_List = new List<Sales_Role__c>();
			
			CurrentSalesOrg = NF_TestDataFactory.createSalesRole(testUser[0],'NSNC_BGTDV','Market India','4 - BG Trial Demo Validator');
			CurrentSalesOrg1 = NF_TestDataFactory.createSalesRole(testUser[0],'NSNC_BGTDV','Market Europe','4 - BG Trial Demo Validator');
			CurrentSalesOrg2 = NF_TestDataFactory.createSalesRole(testUser[0],'NSNC_BGTDV','Market Greater China','4 - BG Trial Demo Validator');
			CurrentSalesOrg3 = NF_TestDataFactory.createSalesRole(testUser[0],'NSNG_BGTDA','NAM GEPS TEPS Canada','7 - BG Trial Demo Approver');
			CurrentSalesOrg4 = NF_TestDataFactory.createSalesRole(testUser[0],'NSNG_BGTDA','NAM GEPS TEPS Canada','7 - BG Trial Demo Approver');
			CurrentSalesOrg5 = NF_TestDataFactory.createSalesRole(testUser[0],'NSNC_BGTDY','Market India','4 - BG Trial Demo');
			CurrentSalesOrg6 = NF_TestDataFactory.createSalesRole(testUser[0],'NSNC_BGTDY','Market India','4 - BG Trial Demo');
			CurrentSalesOrg.Process_SRT_Audit__c = true;
			CurrentSalesOrg1.Process_SRT_Audit__c = false;
			SRList.add(CurrentSalesOrg);
			SRList.add(CurrentSalesOrg1);
			SRList.add(CurrentSalesOrg2);
			SRList.add(CurrentSalesOrg5);
			SRList.add(CurrentSalesOrg6);
			insert SRList;
			
			List<NF_Rolecode__c> RCList = new List<NF_Rolecode__c>();
			NF_Rolecode__c currentRCode1 = new NF_Rolecode__c( Name = 'NSNC_BGTDV', NF_Multiple_level__c = true,A_S__c=true,Hierarchy_Level__c='L4',Role_Name__c='BG Trial Demo Validator' );
			NF_Rolecode__c currentRCode2 = new NF_Rolecode__c( Name = 'NSNG_BGTDA', NF_Multiple_level__c = true,A_S__c=true,Hierarchy_Level__c='L7',Role_Name__c='BG Trial Demo Approver' );
			NF_Rolecode__c currentRCode3 = new NF_Rolecode__c( Name = 'NSNC_BGTDA', NF_Multiple_level__c = true,A_S__c=true,Hierarchy_Level__c='L4',Role_Name__c='BG Trial Demo Approver' );
			NF_Rolecode__c currentRCode4 = new NF_Rolecode__c( Name = 'NSNC_BGTDY', NF_Multiple_level__c = true,A_S__c=false,Hierarchy_Level__c='L4',Role_Name__c='BG Trial Demo' );
			RCList.add(currentRCode1);
			RCList.add(currentRCode2);
			RCList.add(currentRCode3);
			RCList.add(currentRCode4);
			
			Test.startTest();
			insert RCList;
			CurrentSalesOrg.Organisation__c='Market Asia Pacific & Japan';
			CurrentSalesOrg.User__c=testUser[1].id;
			CurrentSalesOrg1.Organisation__c='Market Asia Pacific & Japan';
			CurrentSalesOrg2.Organisation__c='Market India';
			update CurrentSalesOrg;
			update CurrentSalesOrg1;
			update CurrentSalesOrg2;
			insert CurrentSalesOrg3;
			SalesRoleTriggerHelper.onBeforeInsert_Update_salesroledata(SRList,SR_List);
			SRList[0].Process_SRT_Audit__c = false;
			SRList[1].Process_SRT_Audit__c = true;
			update SRList;
			
			Test.StopTest();
		}
	}
	
	static testMethod void createUpdateSalesRole()
	{
		List<NF_Rolecode__c> RCList = new List<NF_Rolecode__c>();
		NF_Rolecode__c currentRCode1 = new NF_Rolecode__c( Name = 'CODE1', NF_Multiple_level__c = true,A_S__c=true,Hierarchy_Level__c='L4',Role_Name__c='BG Trial Demo Validator' );
		NF_Rolecode__c currentRCode2 = new NF_Rolecode__c( Name = 'CODE2', NF_Multiple_level__c = true,A_S__c=true,Hierarchy_Level__c='L4',Role_Name__c='Project Manager' );
		NF_Rolecode__c currentRCode3 = new NF_Rolecode__c( Name = 'CODE3', NF_Multiple_level__c = true,A_S__c=true,Hierarchy_Level__c='L4',Role_Name__c='BG Account Manager' );
		NF_Rolecode__c currentRCode4 = new NF_Rolecode__c( Name = 'CODE4', NF_Multiple_level__c = true,A_S__c=true,Hierarchy_Level__c='L4',Role_Name__c='BG Project Manager' );
		
		RCList.add(currentRCode1);
		RCList.add(currentRCode2);
		RCList.add(currentRCode3);
		RCList.add(currentRCode4);
		insert RCList;
		
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		insert oAdminUser;	  
		List<User> oUsers = TestDataFactory.userCreation(3,'Nokia Sales Profile');
		insert oUsers;
		
		System.runAs(oAdminUser)
		{
			Test.startTest();
			List<Sales_Role__c> SRList = new List<Sales_Role__c>();
			Sales_Role__c CurrentSalesOrg1 = NF_TestDataFactory.createSalesRole(oUsers[0],'CODE1','Market Europe','4 - BG Trial Demo Validator');
			Sales_Role__c CurrentSalesOrg2 = NF_TestDataFactory.createSalesRole(oUsers[0],'CODE2','Market Europe','4 - Project Manager');
			Sales_Role__c CurrentSalesOrg3 = NF_TestDataFactory.createSalesRole(oUsers[1],'CODE3','Market Europe','4 - BG Account Manager');
			Sales_Role__c CurrentSalesOrg4 = NF_TestDataFactory.createSalesRole(oUsers[2],'CODE4','Market Europe','4 - BG Project Manager');
			
			SRList.add(CurrentSalesOrg1);
			SRList.add(CurrentSalesOrg2);
			SRList.add(CurrentSalesOrg3);
			SRList.add(CurrentSalesOrg4);
			insert SRList;
			
			SRList[0].Role_Code__c = 'CODE2';
			SRList[0].Role_Name__c = '4 - Project Manager';
			SRList[1].Role_Code__c = 'CODE4';
			SRList[1].Role_Name__c = '4 - BG Project Manager';
			SRList[2].Role_Code__c = 'CODE1';
			SRList[2].Role_Name__c = '4 - BG Trial Demo Validator';
			
			update SRList;
			//User 0 without permission set, user 1 with permission set
			
			delete SRList;
			//Both users without permission set
			Test.stopTest();
		}
	}
}