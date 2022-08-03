@isTest
private class NCP_MyEntitledProducts_Wrapper_Test {
	@isTest
	static void TestMyEntitledProducts_Wrapper(){
		Test.startTest();		 
		List<NCP_MyEntitledProducts_Wrapper> records = new List<NCP_MyEntitledProducts_Wrapper>();
		NCP_MyEntitledProducts_Wrapper defaultView = new NCP_MyEntitledProducts_Wrapper();
		defaultView.product = null;
		defaultView.checked = true;
		records.add(defaultView);
		System.assertEquals(records.size(),1);
		Test.stopTest();   
	}  
}