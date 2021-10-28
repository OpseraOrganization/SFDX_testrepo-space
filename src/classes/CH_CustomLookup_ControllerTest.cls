@isTest(seealldata = false)
private class CH_CustomLookup_ControllerTest {
	public static testMethod void fetchRecordsTest(){
		try{
			 CH_TestDataFactory.createCustomSettings();
			CH_TestDataFactory.createNokiaUsers();
			CH_TestDataFactory.createAccounts();
			CH_CustomLookup_Controller.fetchRecords('Account', 'Name', 'searchString', 'value');
			
		}catch(Exception ex){
			
		}
		
		
	}
	public static testMethod void fetchRecordsTest1(){
		 
		 try{
			 CH_TestDataFactory.createCustomSettings();
			CH_TestDataFactory.createNokiaUsers();
			CH_TestDataFactory.createAccounts();
			CH_CustomLookup_Controller.fetchRecords('Contact', 'Name', 'searchString', 'value');
		   
		}catch(Exception ex){ 
			
		}
	}
	public static testMethod void fetchRecordsTest2(){
		
		 try{
			 CH_TestDataFactory.createCustomSettings();
			CH_TestDataFactory.createNokiaUsers();
			CH_TestDataFactory.createAccounts();
			  CH_CustomLookup_Controller.RecordsData newRecordsData = new CH_CustomLookup_Controller.RecordsData('test','45','876');
			CH_CustomLookup_Controller.fetchRecords('Contact', 'Name', 'searchString', '');
		   
		}catch(Exception ex){
			
		}
	}
	public static testMethod void fetchRecordsTest3(){
		
		 try{
			 CH_TestDataFactory.createCustomSettings();
			CH_TestDataFactory.createNokiaUsers();
			CH_TestDataFactory.createAccounts();
			CH_CustomLookup_Controller.fetchRecords('Account', 'Name', 'searchString', '');
		   
		}catch(Exception ex){
			
		}
	}
}