@isTest
public class TestBatchUpdateExpAmountInCoallocation {

	static testMethod void activeAllcOnSubmittedClaimTest(){
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;  
		
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
			Fund__c fund1 = new Fund__c(Name = 'abcd', Partner_Name__c = acc.id);
			fundList.add(fund1);
			insert fundList;
			
			List<Co_Op_Allocation__c> allocationList1 = new List<Co_Op_Allocation__c>();
	 // List<Co_Op_Allocation__c> allocationList2 = new List<Co_Op_Allocation__c>();
			Co_Op_Allocation__c allocation1 = new Co_Op_Allocation__c(Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 400.00,Transfers_in_Amount__c = 100.00,Transfers_out_Amount__c = 50.00, Status__c = 'Active',CurrencyIsoCode='EUR',Allocation_Month__c='May',Allocation_Year__c='2015');
			allocationList1.add(allocation1);
			insert allocationList1;
			allocation1.Expiration_Date__c = System.today() - 5;
			update allocation1;
			
			system.debug('date is displayed here'+allocation1.Expiration_Date__c);
			system.debug('status'+allocation1.Status__c);
			
			BatchUpdateExpAmontInCoAllocation  batch= new BatchUpdateExpAmontInCoAllocation();
		batch.execute(null);
			
			Test.stopTest();  
	 
		}
	}
}