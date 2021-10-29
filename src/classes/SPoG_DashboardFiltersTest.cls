/****************************************************
* @Description: Apex Class for unit code coverage. 
* **************************************************/
@isTest(seeAllData = false)
public with Sharing class SPoG_DashboardFiltersTest {
	/*********************************************
    * @Description: method to create test data for test execution. 
    * *******************************************/
    @testsetup
    static void testData() {
        //create test account
        SPoG_TestDataUtility objTestDataUtility = new SPoG_TestDataUtility(); 
        Account testAccount = objTestDataUtility.createTestAccount(); 
        //create test Contact
        Contact objContact = objTestDataUtility.createContact(testAccount.Id); 
        //create test case
        objTestDataUtility.createCase(testAccount.Id,objContact.Id);
    }
    /**************************************************************
     * @Description: testmethod for loadfilters & dynamic filters 
     * ***********************************************************/
    testmethod static void mainTest() {
        Map<String,Object> mapTestInputs = new Map<String,Object>(); 
        mapTestInputs.put('doAction','loadDashboardFilters'); 
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
        Account acc = [Select Id from Account LIMIT 1];
        mapTestInputs.put('doAction','getAccountFilterData'); 
        mapTestInputs.put('selectedData',JSON.deserializeUntyped(JSON.serialize(new List<String>{acc.Id})));
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
        mapTestInputs.put('doAction','getContactFilterData'); 
        mapTestInputs.put('searchString','Test');
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
    }
}