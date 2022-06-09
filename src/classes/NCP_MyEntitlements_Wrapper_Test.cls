@isTest
private class NCP_MyEntitlements_Wrapper_Test {
	@isTest
	static void TestMyEntitlements_Wrapper(){
		Test.startTest();	
		List<NCP_MyEntitlements_Wrapper> records = new List<NCP_MyEntitlements_Wrapper>();
		List<NCP_MyEntitlementProductAccess_Wrapper> prList = new List<NCP_MyEntitlementProductAccess_Wrapper>();
		ServiceContract sc = new ServiceContract();
		List<String> ser = new List<String>();
		NCP_MyEntitlements_Wrapper defaultView = new NCP_MyEntitlements_Wrapper(sc,prList,ser);
		records.add(defaultView);
		System.assertEquals(records.size(),1);
		Test.stopTest();   
	}  
}