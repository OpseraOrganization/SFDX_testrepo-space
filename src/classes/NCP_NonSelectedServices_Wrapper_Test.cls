@isTest
	private class NCP_NonSelectedServices_Wrapper_Test {
	 @isTest
	 static void TestNonSelectedServices_Wrapper(){
		 Test.startTest();		 
		 List<NCP_NonSelectedServices_Wrapper> records = new List<NCP_NonSelectedServices_Wrapper>();
		 NCP_NonSelectedServices_Wrapper defaultView = new NCP_NonSelectedServices_Wrapper(NCP_TestFactory.loadServiceTiles(),true);
		 System.assertNotEquals(defaultView,null);
		 Test.stopTest();   
	 }  
	}