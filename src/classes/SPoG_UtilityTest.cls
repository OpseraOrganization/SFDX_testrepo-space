/*************************************************
 * @Description: Apex class for test code unit coverage
 * **********************************************/
@isTest(seeAllData = false)
public with Sharing class SPoG_UtilityTest {
    
    /**************************************************
     * @Description: Test Setup data
     * ***********************************************/
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
     * @Description: Test method verify the utility methods
     * ***********************************************************/
    testmethod static void testUtilityMethods(){
        SPoG_Utility objUtility = new SPoG_Utility(); 
        String recordTypeId = objUtility.getClaimCaseRecordTypeId(); 
        //System.assertNotEquals(null, recordTypeId); 
        
        objUtility.parseDateForOutput('20200224'); 
        objUtility.parseDateForInput('2020-02-24'); 
        objUtility.getMyCustomers(null); 
        objUtility.getCurrentUserInfo(); 
        objUtility.getCases();
        objUtility.addPrefix('Test','PO_NUMBER'); 
        objUtility.addPrefix('Test','SOLD_TO_NUMBER'); 
        objUtility.addPrefix('Test','SALES_ORDER_NUMBER'); 
        objUtility.addPrefix('Test','MATERIAL_NUMBER'); 
        objUtility.addPrefix('Test','DELIVERY_NUMBER'); 
        
    }

}