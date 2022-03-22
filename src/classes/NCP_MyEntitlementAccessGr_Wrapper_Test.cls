@isTest
private class NCP_MyEntitlementAccessGr_Wrapper_Test {
	@isTest
	static void TestNCP_MyEntitlementAccessGroup_Wrapper(){
	 Test.startTest();		 
	 List<NCP_MyEntitlementAccessGroup_Wrapper> records = new List<NCP_MyEntitlementAccessGroup_Wrapper>();
	 NCP_MyEntitlementAccessGroup_Wrapper defaultView = new NCP_MyEntitlementAccessGroup_Wrapper('Clics',true);
	 records.add(defaultView);
	 System.assertEquals(records.size(),1);
	 Test.stopTest();   
	}  
}