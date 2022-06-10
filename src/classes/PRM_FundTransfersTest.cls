@isTest
public class PRM_FundTransfersTest{ 
	static testMethod void PRM_FundTransfersTest(){
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
			Test.startTest();
			Account acc = new Account();
			acc = TestDataFactory.createAccount(1)[0];
			acc.Enrolled_in_Co_Op__c = true;
			insert acc;
			List<Fund__c> fundList = new List<Fund__c>();
			Fund__c fund = [Select Id from Fund__c where Partner_Name__c = :acc.id];
			fund.PRM_Co_Op_Eligible__c = 2;
			Fund__c fund1 = new Fund__c(Name = 'abcd', Partner_Name__c = acc.id, PRM_Co_Op_Eligible__c = 2);
			fundList.add(fund1);
			Fund__c fund2 = new Fund__c(Name = 'abcd 2', Partner_Name__c = acc.id, PRM_Co_Op_Eligible__c = 2);
			fundList.add(fund2);
			insert fundList;
			update fund;
			
			List<Co_Op_Allocation__c> allocationList1 = new List<Co_Op_Allocation__c>();
			Co_Op_Allocation__c allocation = new Co_Op_Allocation__c(Fund_Id__c = fund.id, A_A_VITAL_Revenue__c = 10000, FN_Revenue__c = 5000, ION_Revenue__c = 0, ION_NUAGE_Revenue__c = 1000,
				ION_Optics_Revenue__c = 3000, ION_Routing_Revenue__c = 1000, MN_Revenue__c = 0, Status__c = 'Active', Allocation_Month__c = PRMGlobalConstants.November, Allocation_Year__c = String.valueOf(System.today().year()),
					  Expiration_Amount__c = 0, Pipeline_Claims__c = 0, Transfers_in_Amount__c = 0, Transfers_out_Amount__c = 0, Available_Date__c = System.today(), Expiration_Date__c = System.today().addYears(1));
			Co_Op_Allocation__c allocation1 = new Co_Op_Allocation__c(Fund_Id__c = fund.id, A_A_VITAL_Revenue__c = -10000, FN_Revenue__c = -5000, ION_Revenue__c = 0, ION_NUAGE_Revenue__c = 1000,
				ION_Optics_Revenue__c = 3000, ION_Routing_Revenue__c = -1000, MN_Revenue__c = 0, Status__c = 'Active', Allocation_Month__c = PRMGlobalConstants.December, Allocation_Year__c = String.valueOf(System.today().year()),
					  Expiration_Amount__c = 0, Pipeline_Claims__c = 0, Transfers_in_Amount__c = 0, Transfers_out_Amount__c = 0, Available_Date__c = System.today(), Expiration_Date__c = System.today().addYears(1));
			Co_Op_Allocation__c allocation2 = new Co_Op_Allocation__c(Fund_Id__c = fund1.id, A_A_VITAL_Revenue__c = 10000, FN_Revenue__c = -2000, ION_Revenue__c = 0, ION_NUAGE_Revenue__c = 1000,
				ION_Optics_Revenue__c = 3000, ION_Routing_Revenue__c = 1000, MN_Revenue__c = 0, Status__c = 'Active', Allocation_Month__c = PRMGlobalConstants.November, Allocation_Year__c = String.valueOf(System.today().year()),
					  Expiration_Amount__c = 0, Pipeline_Claims__c = 0, Transfers_in_Amount__c = 0, Transfers_out_Amount__c = 0, Available_Date__c = System.today(), Expiration_Date__c = System.today().addYears(1));
			Co_Op_Allocation__c allocation3 = new Co_Op_Allocation__c(Fund_Id__c = fund2.id, A_A_VITAL_Revenue__c = -10000, FN_Revenue__c = -2000, ION_Revenue__c = 1000, ION_NUAGE_Revenue__c = 1000,
				ION_Optics_Revenue__c = -3000, ION_Routing_Revenue__c = 1000, MN_Revenue__c = 1000, Status__c = 'Active', Allocation_Month__c = PRMGlobalConstants.November, Allocation_Year__c = String.valueOf(System.today().year()),
					  Expiration_Amount__c = 0, Pipeline_Claims__c = 0, Transfers_in_Amount__c = 0, Transfers_out_Amount__c = 0, Available_Date__c = System.today(), Expiration_Date__c = System.today().addYears(1));
			allocationList1.add(allocation);
			allocationList1.add(allocation1);
			allocationList1.add(allocation2);
			allocationList1.add(allocation3);
			insert allocationList1;
			
			
			PRM_FundTransfers transf = new PRM_FundTransfers();
			transf.execute(null);
			Test.stopTest();  
	 
		}
	}
}