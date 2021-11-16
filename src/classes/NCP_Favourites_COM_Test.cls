@isTest
private class NCP_Favourites_COM_Test {

	@isTest
	static void TestIsAuthenticated(){
		Test.startTest();
		boolean b = NCP_Favourites_COM.isAuthenticated();
		System.assertEquals(b,true);
		Test.stopTest();
	}

	@isTest
	static void TestCheckForEntitledProducts(){
		Test.startTest();
		boolean b = NCP_Favourites_COM.checkForEntitledProducts();
		Test.stopTest();
	}

	@isTest
	static void TestCheckForEntitlements(){
		Test.startTest();
		List<NCP_MyEntitlements_Wrapper> wrapp = NCP_Favourites_COM.checkForEntitlements();
		Test.stopTest();
	}

	@isTest
	static void TestGetLink(){
		Test.startTest();
		Map<string, object> getLinksMap  = NCP_Favourites_COM.getLinks();
		System.assertEquals(getLinksMap.size()>0,true);
		Test.stopTest();
	}

}