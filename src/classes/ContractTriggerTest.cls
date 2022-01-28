@isTest(SeeAllData=false)
public class ContractTriggerTest {
	@isTest
	public static void testContractTrigger(){
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){			
			Test.startTest();
			Account acntPartner = TestDataFactory.createAccount(1)[0];
			acntPartner.AccountNumber = '1234';
			acntPartner.Partner_Type__c='Value Added Reseller';
			acntPartner.Partner_Program__c ='GPP 3.0';
			database.insert(acntPartner);
			
			Accreditation__c accrdSub = new Accreditation__c();
			accrdSub.RecordTypeId = '01241000000v9mE';
			accrdSub.Partner__c = acntPartner.Id;
			accrdSub.Accreditation_Level__c = 'Advanced';
			accrdSub.Accreditation_Date__c = System.today();
			accrdSub.Accreditation_Type__c='Product';	 
			accrdSub.Partner_Business_Plan_Status__c = 'Submitted';
			accrdSub.Active_Contract_Types__c = 'NIRA';
			accrdSub.Partner_Business_Plan_Status__c = 'Submitted';
			insert accrdSub;  
			
			List<Contract> contractList = new List<Contract>();
			Contract newContract1 = new Contract(AccountId=acntPartner.Id, Name = 'Test Contract 1',StartDate = System.today(),Status = 'Draft', Contract_Status__c = PRMGlobalConstants.ActiveSt, Contract_Type__c = 'NIRA');
			Contract newContract2 = new Contract(AccountId=acntPartner.Id, Name = 'Test Contract 2',StartDate = System.today()+1,Status = 'Draft', Contract_Status__c = PRMGlobalConstants.EXPIRED,  Contract_Type__c = 'NIRA');
			contractList.add(newContract1);
			contractList.add(newContract2);
			insert contractList;
			newContract1.StartDate = Date.today().addDays(-2);
			newContract1.EndDate = Date.today().addDays(-1);
			//newContract2.Contract_Status__c = PRMGlobalConstants.ActiveSt;
			update newContract1;
			newContract2.StartDate = Date.today().addDays(-2);
			newContract2.EndDate = Date.today().addDays(1);
			delete newContract2;
			Test.stopTest();
		}
	}
}