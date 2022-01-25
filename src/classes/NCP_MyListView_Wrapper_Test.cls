@isTest
private class NCP_MyListView_Wrapper_Test {
	@isTest
	static void TestMyListView_Wrapper(){
		Test.startTest();		 
		List<NCP_MyListView_Wrapper> records = new List<NCP_MyListView_Wrapper>();
		NCP_MyListView_Wrapper defaultView = new NCP_MyListView_Wrapper();
		defaultView.Id = '0032E000008p4MR';
		defaultView.Name = 'All Contracts';
		defaultView.AccountName =  'test';
		records.add(defaultView);
		System.assertEquals(records.size(),1);
		Test.stopTest();   
	}  
}