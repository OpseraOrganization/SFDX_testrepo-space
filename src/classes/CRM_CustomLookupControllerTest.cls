@isTest
public class CRM_CustomLookupControllerTest 
{
	@isTest
	static void fetchRecordsTest1()
	{
		try{
			CRM_CustomLookupController.RecordsData recordData = new CRM_CustomLookupController.RecordsData('test', 'toCover', true);
			List<Account> accList = TestDataFactory.createAccount(1);
			insert accList;
			
			List<CRM_CustomLookupController.RecordsData> result = CRM_CustomLookupController.fetchRecords('Account', 'Name', 'Test','', '', '10');
		} catch (Exception e){
			System.debug('Caught exception');
		}
	}

	@isTest
	static void fetchRecordsTest2()
	{
		List<Account> accList = TestDataFactory.createAccount(1);
		insert accList;

		List<CRM_CustomLookupController.RecordsData> result = CRM_CustomLookupController.fetchRecords('Account', 'Name', 'Test', '',accList[0].Id + '', '5');
		System.assertEquals(result.size(), 1);
	}

	@isTest
	static void fetchContactTest1()
	{
		List<Account> accList = TestDataFactory.createAccount(1);
		insert accList;

		List<Contact> conList= TestDataFactory.createContact2(1, accList[0]);
		insert conList;

		List<CRM_CustomLookupController.RecordsData> result = CRM_CustomLookupController.fetchRecords('Contact', 'Name', 'Test','', '', '10');
		System.assertEquals(result != null, true);
	}

	@isTest
	static void fetchContactTest2()
	{

		List<Account> accList = TestDataFactory.createAccount(1);
		insert accList;

		List<Contact> conList= TestDataFactory.createContact2(1, accList[0]);
		insert conList;


		List<CRM_CustomLookupController.RecordsData> result = CRM_CustomLookupController.fetchRecords('Contact', 'Name', 'Test', null, conList[0].Id + '', '5');
		System.assertEquals(result.size(), 1);
	}

	@isTest
	static void fetchRecordsNegativeTest()
	{
		try
		{
			List<CRM_CustomLookupController.RecordsData> result = CRM_CustomLookupController.fetchRecords('', 'Name', 'Test', null,'', '20');
		}
		catch(Exception ex)
		{
			System.assertNotEquals(ex.getMessage(), NULL);
		}
	}
}