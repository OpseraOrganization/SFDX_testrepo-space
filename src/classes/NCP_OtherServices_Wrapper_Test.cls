@isTest
	private class NCP_OtherServices_Wrapper_Test {
	 @isTest
	 static void TestOtherServices_Wrapper(){
		 Test.startTest();		 
		 List<NCP_OtherServices_Wrapper> records = new List<NCP_OtherServices_Wrapper>();
		 NCP_OtherServices_Wrapper defaultView = new NCP_OtherServices_Wrapper();
		 defaultView.title = 'test';
		 defaultView.disabled = true;
		 records.add(defaultView);	  
		 System.assertEquals(records.size(),1);
		 Test.stopTest();   
	 }  
	}