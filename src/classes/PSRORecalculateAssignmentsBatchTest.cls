@isTest
Private class PSRORecalculateAssignmentsBatchTest
{
	@testSetup
	private static void setup()
	{
		//Set project manager as PSRO in metadata
		List<PSRO_Costs_Visibilities_Manager__mdt>  psroList = new List<PSRO_Costs_Visibilities_Manager__mdt>();
		PSRO_Costs_Visibilities_Manager__mdt psroMD1 = createPSROCostVisMan('BG Trial Demo Validator','NSW', 'BG_Trial_Demo_Validator');
		PSRO_Costs_Visibilities_Manager__mdt psroMD2 = createPSROCostVisMan('BG Project Manager','', 'BG_Project_Manager');
		PSRO_Costs_Visibilities_Manager__mdt psroMD3 = createPSROCostVisMan('BG Account Manager','ION', 'BG_Account_Manager');
		PSRO_Costs_Visibilities_Manager__mdt psroMD4 = createPSROCostVisMan('Non valid','', 'Non_valid');
		psroList.add(psroMD1);
		psroList.add(psroMD2);
		psroList.add(psroMD3);
		psroList.add(psroMD4);
		
		List<NF_Rolecode__c> RCList = new List<NF_Rolecode__c>();
		NF_Rolecode__c currentRCode1 = new NF_Rolecode__c( Name = 'CODE1', NF_Multiple_level__c = true,A_S__c=true,Hierarchy_Level__c='L4',Role_Name__c='BG Trial Demo Validator' );
		NF_Rolecode__c currentRCode2 = new NF_Rolecode__c( Name = 'CODE2', NF_Multiple_level__c = true,A_S__c=true,Hierarchy_Level__c='L4',Role_Name__c='BG Project Manager' );
		NF_Rolecode__c currentRCode3 = new NF_Rolecode__c( Name = 'CODE3', NF_Multiple_level__c = true,A_S__c=true,Hierarchy_Level__c='L4',Role_Name__c='BG Account Manager' );
		RCList.add(currentRCode1);
		RCList.add(currentRCode2);
		RCList.add(currentRCode3);
		insert RCList;
		
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		insert oAdminUser;		
		List<User> oUsers = TestDataFactory.userCreation(2,'Nokia Sales Profile');
		oUsers[0].LastName = 'TestUserForBatch';
		oUsers[1].LastName = 'TestUserForBatch';
		insert oUsers;
		
		List<Sales_Role__c> SRList = new List<Sales_Role__c>();
		Sales_Role__c CurrentSalesOrg1 = NF_TestDataFactory.createSalesRole(oUsers[0],'CODE1','Market Europe','4 - BG Trial Demo Validator');
		Sales_Role__c CurrentSalesOrg2 = NF_TestDataFactory.createSalesRole(oUsers[0],'CODE2','Market Europe','4 - Project Manager');
		Sales_Role__c CurrentSalesOrg3 = NF_TestDataFactory.createSalesRole(oUsers[1],'CODE3','Market Europe','4 - BG Account Manager');
		SRList.add(CurrentSalesOrg1);
		SRList.add(CurrentSalesOrg2);
		SRList.add(CurrentSalesOrg3);
		insert SRList;
	}
	
	private static testMethod void runBatch()
	{
		Test.startTest();
		PSRORecalculateAssignmentsBatch obj = new PSRORecalculateAssignmentsBatch();
		DataBase.executeBatch(obj, 100); 
		Test.stopTest();
	 }
	
	private static PSRO_Costs_Visibilities_Manager__mdt createPSROCostVisMan(String roleName, String bg, String ApiName)
	{
		PSRO_Costs_Visibilities_Manager__mdt psroRecord = new PSRO_Costs_Visibilities_Manager__mdt();
		psroRecord.BG__c = bg;
		psroRecord.Role_Name__c = roleName;
		psroRecord.Label = roleName;
		psroRecord.DeveloperName = ApiName;
		return psroRecord;
	 }
}