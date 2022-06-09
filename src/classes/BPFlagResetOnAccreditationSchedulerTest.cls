//Test class to cover BPFlagResetOnAccreditation and AccreditationBPFlagResetScheduler
@isTest(SeeAllData=false)
public class BPFlagResetOnAccreditationSchedulerTest {
	@istest
	public static void scheduleBPFlagReset(){
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(1,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		runAsUSer[0].Nokia_ID__c= '6777777666';
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
			Test.startTest();
			Account accountTest = TestDataFactory.createAccount(1)[0];
			accountTest.AccountNumber = '1234'; 
			accountTest.Market__c = 'Market India' ;
			accountTest.Partner_Program__c = 'GPP 0.0' ;
			accountTest.Partner_Type__c = 'Distributor' ;
			insert accountTest;
			
			List<Accreditation__c> accredList = new List<Accreditation__c>();		
			Accreditation__c accrdAprv = new Accreditation__c();
			accrdAprv.RecordTypeId = '01241000000v9mE';
			accrdAprv.Partner__c = accountTest.Id;
			accrdAprv.Accreditation_Date__c = System.today();	  
			accrdAprv.Accreditation_Type__c='Product';
			accrdAprv.Accreditation_Level__c = 'Advanced';
			accrdAprv.Partner_Business_Plan_Status__c = 'Approved';			
			   
			accredList.add(accrdAprv);
			insert accredList;			   
			
			AccreditationBPFlagResetScheduler sc = new AccreditationBPFlagResetScheduler();
			String schdl = '0 0 21 ? * *';
			String jobID = System.schedule('Test Schedule',schdl,sc);
			System.debug('JobID'+jobID);
			Test.stopTest();
		}
	}
}