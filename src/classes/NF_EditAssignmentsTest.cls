@isTest
Private class NF_EditAssignmentsTest{
		private static List<NF_Rolecode__c> RCList = new List<NF_Rolecode__c>();
		private static Sales_Role__c currentSalesOrg;
		private static Sales_Role__c currentSalesOrg1;
		private static Sales_Role__c currentSalesOrg2;
		private static Sales_Role__c currentSalesOrg3;
		private static List<User> testUser = NF_TestDataFactory.getUsers(3,'System Administrator');
	
  public static void setup(){ 
		insert testUSer;
		NF_Rolecode__c currentRCode0 = new NF_Rolecode__c( Name = 'NSNB_BGTDV', NF_Multiple_level__c = true,A_S__c=true,Hierarchy_Level__c='L3',Role_Name__c='BG Trial Demo Validator' );
		NF_Rolecode__c currentRCode1 = new NF_Rolecode__c( Name = 'NSNC_BGTDV', NF_Multiple_level__c = true,A_S__c=true,Hierarchy_Level__c='L4',Role_Name__c='BG Trial Demo Validator' );
		NF_Rolecode__c currentRCode2 = new NF_Rolecode__c( Name = 'NSND_BGTDV', NF_Multiple_level__c = true,A_S__c=true,Hierarchy_Level__c='L5',Role_Name__c='BG Trial Demo Validator' );
		NF_Rolecode__c currentRCode3 = new NF_Rolecode__c( Name = 'NSNE_BGTDV', NF_Multiple_level__c = true,A_S__c=true,Hierarchy_Level__c='L6',Role_Name__c='BG Trial Demo Validator' );
		NF_Rolecode__c currentRCode4 = new NF_Rolecode__c( Name = 'NSNG_BGTDV', NF_Multiple_level__c = true,A_S__c=true,Hierarchy_Level__c='L7',Role_Name__c='BG Trial Demo Validator' );
		NF_Rolecode__c currentRCode5 = new NF_Rolecode__c( Name = 'NSNG_BGTDA', NF_Multiple_level__c = true,A_S__c=true,Hierarchy_Level__c='L7',Role_Name__c='BG Trial Demo Approver' );
		RCList.add(currentRCode0);
		RCList.add(currentRCode1);
		RCList.add(currentRCode2);
		RCList.add(currentRCode3);
		RCList.add(currentRCode4);
		RCList.add(currentRCode5);
		insert RCList;
	CurrentSalesOrg1 = NF_TestDataFactory.createSalesRole(testUser[0],'NSNC_BGTDV','Market Europe','4 - BG Trial Demo Validator');
		CurrentSalesOrg2 = NF_TestDataFactory.createSalesRole(testUser[0],'NSNC_BGTDV','Market EuropeNSA','4 - BG Trial Demo Validator');
		CurrentSalesOrg3 = NF_TestDataFactory.createSalesRole(testUser[0],'NSNC_BGTDV','Customer OperationsNSA','4 - BG Trial Demo Validator');
		CurrentSalesOrg1.BG__c='NSW';
		CurrentSalesOrg2.BG__c='NSW';
	
		insert CurrentSalesOrg2;
		insert CurrentSalesOrg1;
		insert CurrentSalesOrg3;

	  
  }
   
	static testMethod void test(){
		setup();
		NF_EditAssignments.salesRoleWrapper srw1= new NF_EditAssignments.salesRoleWrapper();
		NF_EditAssignments.salesRoleWrapper srw2= new NF_EditAssignments.salesRoleWrapper();
		NF_EditAssignments.salesRoleWrapper srw3= new NF_EditAssignments.salesRoleWrapper();
		List<NF_EditAssignments.SalesRoleWrapper> wrapperList = new List<NF_EditAssignments.salesRoleWrapper>();
		
	// List<Sales_Role__c> SRList = new List<Sales_Role__c>();
		
		
		//System.runAs(testUSer[0])
		 {
	  
		CurrentSalesOrg = NF_TestDataFactory.createSalesRole(testUser[0],'NSNC_BGTDV','Market India','BG Trial Demo Validator');
		
		srw1.SalesRoleObj=null;
		srw1.usercheck=testUSer[0];
		srw1.Organisation='Market India';
		srw1.BG='FN';
		srw1.Rolename='4 - BG Trial Demo Validator';
		wrapperList.add(srw1);
		
		srw3.SalesRoleObj=CurrentSalesOrg1;
		srw2.usercheck=null;
		srw3.Organisation='Market India';
		srw3.BG='FN';
		srw3.Rolename='4 - BG Trial Demo Validator';
		wrapperList.add(srw3);
	
		srw2.SalesRoleObj=CurrentSalesOrg1;
		srw2.usercheck=testUSer[1];
		srw2.Organisation='Market Europe';
		srw2.BG='FN';
		srw2.Rolename='4 - BG Trial Demo Validator';
		wrapperList.add(srw2);
	 
		String wrapperselializedstring = JSON.serialize(wrapperList);
		
		Test.startTest();
		NF_EditAssignments.returnL1Territories();
		NF_EditAssignments.returnL2toL7Territories();
		NF_EditAssignments.getDetails();
		NF_EditAssignments.getObjViews();
		NF_EditAssignments.getPermissionset();
		NF_EditAssignments.FrozenUSerCheck();
		NF_EditAssignments.returnsaleroleuser_Info(1,10,'Market EuropeNSA','NSW','BG Trial Demo Validator',false,false,null,null);
		NF_EditAssignments.savesales_roleUser(CurrentSalesOrg);
		NF_EditAssignments.saveListsalesroleUser(wrapperselializedstring);
		Test.StopTest();
	}
	}
	 static testMethod void test1(){
		setup();
		Test.startTest();
		NF_EditAssignments.returnsaleroleuser_Info(1,1,'Market Europe','NSW','BG Trial Demo Validator',true,true,null,null);
		Test.StopTest();
	}
	static testMethod void test2(){
		setup();
		Test.startTest();
		NF_EditAssignments.returnsaleroleuser_Info(1,1,'Market Europe','','BG Trial Demo Validator',false,true,null,null);
		Test.StopTest();
	}
	static testMethod void test4(){
		setup();
		Test.startTest();
		NF_EditAssignments.returnsaleroleuser_Info(1,1,'Market Europe','NSW','BG Trial Demo Validator',true,false,null,null);
		Test.StopTest();
	}
	static testMethod void test5(){
		setup();
		Test.startTest();
		NF_EditAssignments.returnsaleroleuser_Info(1,10,'INDIA BH CT Bharti','NSW','BG Trial Demo Validator',false,false,null,null);
		Test.StopTest();
	}
	static testMethod void test6(){
		setup();
		Test.startTest();
		NF_EditAssignments.returnsaleroleuser_Info(1,10,'EUR WCE SFR France','NSW','BG Trial Demo Validator',true,true,null,null);
		Test.StopTest();
	}
   static testMethod void test7(){
		setup();
		Test.startTest();
		NF_EditAssignments.returnsaleroleuser_Info(1,10,'EUR WCE SFR France','NSW','BG Trial Demo Validator',true,true,null,null);
		Test.StopTest();
	}
}