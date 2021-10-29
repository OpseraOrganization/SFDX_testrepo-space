/**************************************************
* @Description: Test class for unit code coverage
* ************************************************/
@isTest(seeAllData = false)
public with Sharing class SPoG_DashboardMetricHelperTest {
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
    /*********************************************************
    * @Description: Method to test the dashboard metric
    * *******************************************************/
    testmethod static void testDashboardOpenMetric(){
        //set the SPoG Mock Service.
        Test.setMock(HttpCalloutMock.Class, new SPoG_TestMockService()); 
        try{
            Test.startTest(); 
            Map<String,Object> mapTestInputs = new Map<String,Object>();
            Map<String,String> mapInputs = new Map<String,String>();
			mapInputs.put('accname','Test'); 
            mapInputs.put('assgnval','');
            mapInputs.put('segval',''); 
            mapInputs.put('regionval','');
            mapInputs.put('typeval',''); 
            mapTestInputs.put('doAction','getOrderMetrics'); 
            mapTestInputs.put('filtersData',JSON.deserializeUntyped(JSON.serialize(mapInputs))); 
            SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs)); 
            Test.stopTest();
        }
        catch(exception ex)
        {
            System.debug(':: '+ex.getMessage());
        }
    }
    /*************************************************************
    * @Description: Test method for shipment information
    * **********************************************************/
    testmethod static void testShipmentMetricInfo() {
        //set the SPoG Mock Service.
        Test.setMock(HttpCalloutMock.Class, new SPoG_TestMockService()); 
        try{
            Test.startTest();
             SPoG_DashboardMetricHelper.ChartInfo chrtinfo = new SPoG_DashboardMetricHelper.ChartInfo('' , 2, '') ;
            SPoG_DashboardMetricHelper.ShipmentMetricInfo obj1 = new SPoG_DashboardMetricHelper.ShipmentMetricInfo() ;
            obj1.GenID = '';
            obj1.SOLD_TO_NUMBER = '';
            obj1.SOLD_TO_NAME = '';
            obj1.SALES_ORDER_NUMBER= '';
            obj1.PURCHASE_ORDER_NUMBER = '';
            obj1.SERIAL_NUMBER = '';
            obj1.CLIN= '';
            obj1.PLANT= '';
            obj1.MATERIAL = '';
            obj1.AWB = '';
            obj1.ACTUAL_GI_DATE = '';
            obj1.DELIVERY_NUMBER = '';
			obj1.DELIVERY_DATE = '';
            obj1.DELIVERY_CATEGORY= '';
            obj1.LINE_ITEM = '';
            obj1.SCHEDULE_LINE = '';
            obj1.YOMT_WADAT = ''; 
            SPoG_DashboardMetricHelper.EncumberedMetricInfo obj2 = new SPoG_DashboardMetricHelper.EncumberedMetricInfo() ;
            Map<String,Object> mapTestInputs = new Map<String,Object>(); 
            Map<String,String> mapInputs = new Map<String,String>();
            mapInputs.put('accname','Test'); 
            mapInputs.put('assgnval','');
            mapInputs.put('segval',''); 
            mapInputs.put('regionval','');
            mapInputs.put('typeval',''); 
            mapTestInputs.put('doAction','getShipmentMetrics'); 
            mapTestInputs.put('filtersData',JSON.deserializeUntyped(JSON.serialize(mapInputs)));
            SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs)); 
            Test.stopTest();
        }
        catch(exception ex)
        {
            System.debug(':: '+ex.getMessage());
        }
    }
}