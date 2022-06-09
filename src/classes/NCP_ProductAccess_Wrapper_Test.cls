@isTest
	private class NCP_ProductAccess_Wrapper_Test {
	 @isTest
	 static void TestProductAccess_Wrapper(){
		 Test.startTest();		 
		 List<NCP_AccessType_Wrapper> records = new List<NCP_AccessType_Wrapper>();
		 NCP_AccessType_Wrapper defaultView = new NCP_AccessType_Wrapper(true, NCP_TestFactory.loadProductAccess());
		 records.add(defaultView);	  
		 NCP_ProductAccess_Wrapper access = new NCP_ProductAccess_Wrapper('test',records);
		 System.assertNotEquals(access,null);
		 Test.stopTest();   
	 }  
	}