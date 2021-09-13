@isTest
private class NCP_MyEntitlementPA_Wrapper_Test {
	@isTest
	static void TestMyEntitlementProductAccess_Wrapper(){
		Test.startTest();		 
		List<NCP_MyEntitlementAccessGroup_Wrapper> records = new List<NCP_MyEntitlementAccessGroup_Wrapper>();
	 NCP_MyEntitlementAccessGroup_Wrapper defaultView = new NCP_MyEntitlementAccessGroup_Wrapper('Clics',true);
	 records.add(defaultView);
		Product2 myProduct = new Product2();
		NCP_MyEntitlementProductAccess_Wrapper productAccess = new NCP_MyEntitlementProductAccess_Wrapper((Object)myProduct,records);
		System.assertNotEquals(productAccess,null);
		Test.stopTest();   
	}  
}