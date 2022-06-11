/**********************************************************************************************************************
* Class Name :  CH_CA_GenericLookupController_Test
* Created Date: 06-05-2019
* Created By :  TCS
* Description : This class is test class for  CH_CA_GenericLookupController		
* Class:		CH_CA_GenericLookupController
***********************************************************************************************************************/
@isTest
public class CH_CA_GenericLookupController_Test {
	
	//This method is used to test fetchRecords
	@isTest
	static void testfetchRecords(){
		CH_UTIL_TEST.createNokiaUsers();
		String searchString = 'NONPORTAL1';
		List<CH_CA_GenericLookupController.RecordsData> foundRecords = CH_CA_GenericLookupController.fetchRecords('User', 'Name', '', searchString, '');
		System.Assert(foundRecords.size() == 1, 'Expect 1 record for: ' + searchString + '. Actual ' + foundRecords.size());

		searchString = 'NON';
		foundRecords = CH_CA_GenericLookupController.fetchRecords('User', 'Name', '', searchString, '');
		
	}
	
	@isTest
	static void testfetchRecordsCatchError(){
		try{
			CH_UTIL_TEST.createNokiaUsers();
			String searchString = 'NONPORTAL1';
			CH_CA_GenericLookupController.fetchRecords('User', 'Names', '', searchString, '');
		}
		catch(Exception e){
		// This is empty block of code
		}
	}

	@isTest
	static void testfetchRecordsforAccount(){
		CH_UTIL_TEST.createLegalAccount();
		String searchString = 'LEGAL';
		List<CH_CA_GenericLookupController.RecordsData> foundRecords = CH_CA_GenericLookupController.fetchRecords('Account', 'Name', 'AccountNumber', searchString, '');
		System.Assert(foundRecords.size() == 1, 'Expect 1 record for: ' + searchString + '. Actual ' + foundRecords.size());
	}
}