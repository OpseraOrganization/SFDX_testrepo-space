/***************************************************
* @Description: Test Class for unit code coverage for SPoG_Handler
* *************************************************/
@isTest(seeAllData = false)
private with Sharing class SPoG_HandlerTest {
    
    testmethod static void testExecuteReq() {
        //ALL handler classes are tested in separate classes. 
        //Run all SPoG_ test classes to get coverage
        SPoG_Handler.executeRequest(null); 
    }
    
    testmethod static void testOrderDetails() {
        String input = '{"doAction":"getOrderDetails","orderNumber":"9646048","soldToNumber":"304626"}';
        Test.setMock(HttpCalloutMock.Class, new SPoG_TestMockService()); 
        SPoG_Handler.executeRequest(input); 
    }
    
    
}