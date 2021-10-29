/****************************************************
* @Description: Apex Class for unit code coverage. 
* **************************************************/
@isTest(seeAllData = false)
public with Sharing class SPoG_MyCasesHelperTest {
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
     * @Description: testmethod for specific account id value
     * ***********************************************************/
    testmethod static void testGetCaseForAccount() {
        Map<String,Object> mapTestInputs = new Map<String,Object>(); 
        Account testAccount = [SELECT Id FROM Account LIMIT 1]; //get the test inserted account
        Contact testContact = [SELECT Id FROM Contact LIMIT 1]; //get the test inserted contact
        mapTestInputs.put('doAction','getCaseData'); 
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
        mapTestInputs.put('selectedAccountId',JSON.deserializeUntyped(JSON.serialize(new List<String>{testAccount.Id})));// Fix 
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs)); 
        mapTestInputs.put('isDashboardView','true');
        mapTestInputs.put('filtersData',null);
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
        Map<String,Object> mapInputs = new Map<String,Object>();
        mapInputs.put('accname','Test'); 
        mapInputs.put('assgnval',testContact.Id);
        mapInputs.put('segval','OEM'); 
        mapInputs.put('regionval','PHOENIX/AMERICA');
        mapInputs.put('typeval','Shared');
        mapTestInputs.put('filtersData',JSON.deserializeUntyped(JSON.serialize(mapInputs)));
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
        mapInputs = new Map<String,Object>();
        mapInputs.put('accname','Test'); 
        mapTestInputs.put('filtersData',JSON.deserializeUntyped(JSON.serialize(mapInputs)));
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
    }
    /****************************************************************
     * @Description: Method to test cases list view data
     * **************************************************************/
    testmethod static void testCasesList() {
        Case objCase = [SELECT id , AccountId, Status,CaseNumber FROM Case LIMIT 1]; // get the test cases inserted in setup. 
        CaseFilter objFilter = new CaseFilter();
        List<string> customerids = new List<string>();
        customerids.add(objCase.AccountId); 
        objFilter.customerId = customerids;
        objFilter.status = objCase.Status ; 
        objFilter.searchInput = objCase.CaseNumber ; 
        Map<String,String> mapTestInputs = new Map<String,String>(); 
        mapTestInputs.put('doAction','getCasesList'); 
        mapTestInputs.put('filterParams',JSON.serialize(objFilter)); 
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
    }
    public with Sharing Class CaseFilter {
        List<String> customerId = new List<string>() ; 
        String status = null ; 
        String searchInput = null ; 
    }
}