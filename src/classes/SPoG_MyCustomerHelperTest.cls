/*****************************************************
* @Description: Apex Class for Unit code coverage
* *************************************************/
@isTest(seeAllData = false)
public with Sharing class SPoG_MyCustomerHelperTest {
    
    /****************************************************
* @Description: method to create test data
* **************************************************/
    @testsetup
    static void testData() {
        //create test account
        SPoG_TestDataUtility objTestDataUtility = new SPoG_TestDataUtility(); 
        Account testAccount = objTestDataUtility.createTestAccount(); 
        
        //create test Contact
        Contact objContact = objTestDataUtility.createContact(testAccount.Id); 
        
        //create test case
        objTestDataUtility.createCase(testAccount.Id,objContact.Id);
        Account_Cross_Ref__c accref = new Account_Cross_Ref__c(external_account_id__c='028902',
                                                               external_account_name__c='Test',
                                                               external_address_line_1__c='test',
                                                               external_address_line_2__c='Test',
                                                               external_address_line_3__c='test', 
                                                               external_city_name__c='test', 
                                                               external_country_name__c='test',
                                                               Site_Code__c='08798765',
                                                               //account_status__c='Active',
                                                               xref_type__c='SAP_SOLD_TO',
                                                               Account_Name__c=testAccount.Id);
        insert accref;
    }
    
    /******************************************************
* @Description: Test Method to get related account SAP info
* ***************************************************/
    testmethod static void testGetSAPInfo() {
        Case objCase = [SELECT Id FROM Case LIMIT 1]; 
        Map<String,String> mapTestInputs = new Map<String,String>(); 
        mapTestInputs.put('doAction','getCustomerInfo'); 
        mapTestInputs.put('caseId',objCase.Id); 
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs)); 
        mapTestInputs.put('doAction','searchAccounts'); 
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
        mapTestInputs.put('doAction','getAccountData'); 
        mapTestInputs.put('searchString','Test');
        //mapTestInputs.put('selectedData','[]');
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
    }
    
    /*********************************************************
* @Description: Test Method for customer Search
* ******************************************************/
    testmethod static void testCustomerSearch() {
        //set the test mock class to get callout responses
        Test.setMock(HttpCalloutMock.Class, new SPoG_TestMockService()); 
              //  Account testacc=[select id,name from Account where name =:'Test Account'];

        Map<String,String> mapTestInputs = new Map<String,String>(); 
        mapTestInputs.put('doAction','customerSearch') ; 
        
        mapTestInputs.put('searchValue','test'); 
        mapTestInputs.put('searchBy','Customer Sold To Name') ; 
        Test.startTest(); 
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs)); 
        
        mapTestINputs.put('searchBy','VAT Number'); 
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs)); 
        
        mapTestINputs.put('searchBy','Postal Code'); 
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs)); 
        
        mapTestINputs.put('searchBy','Customer Sold To Number'); 
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs)); 
         mapTestInputs.put('doAction','countryInfo') ; 
         SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs)); 
        // SPoG_MyCustomerHelper.CustomerInfo custinfo=new SPoG_MyCustomerHelper.CustomerInfo(testacc.Id,testacc.Name,'test');
        Test.stopTest() ; 
        
        
    }
}