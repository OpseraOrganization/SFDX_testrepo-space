@isTest
	private class NCP_AccessType_Wrapper_Test {
	 @isTest
	 static void TestAccessType_Wrapper(){
		 Test.startTest();		 
		 List<NCP_AccessType_Wrapper> records = new List<NCP_AccessType_Wrapper>();
		 NCP_AccessType_Wrapper defaultView = new NCP_AccessType_Wrapper(true, NCP_TestFactory.loadProductAccess());
		 records.add(defaultView);		
		 System.assertEquals(records.size(),1);
		 Test.stopTest();   
	 }  
	}