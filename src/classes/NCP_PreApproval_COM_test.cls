@isTest(seeAllData=false)
public class NCP_PreApproval_COM_test {
	/*
	@isTest
	Public Static void testPreApproval(){
		
		BatchConUserEmailUpdate uca = new BatchConUserEmailUpdate();
		Id batchId = Database.executeBatch(uca);		
		
		List<AsyncApexJob> jobInfo = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob limit 1];
		String jobId = jobInfo[0].id;
		Test.startTest();
		//NCP_PreApproval_COM PA = new NCP_PreApproval_COM();   
		NCP_PreApproval_COM.pollAsyncJob(jobId); 
		Test.stopTest();
	}
	*/
	@isTest
	Public Static void testCaseUpdate() {
		Test.startTest();
		Case testCase = NCP_TestFactory.createEntitlementCase(null, null, 'CARES', 'AcSys Portal;ASLM;CARES');
		NCP_PreApproval_COM.getNAMResponse(testCase.Id);
		NCP_PreApproval_COM.updateCaseStatus(testCase.Id);
		//Testing for negate condition
		NCP_PreApproval_COM.updateCaseStatus(null);
		
		Test.stopTest();
	}
	
	
}