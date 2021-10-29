/***********************************************
 * @Description : Test Class for SPoG_UserStatusHelper Class.
 * *********************************************/
@isTest
public class SPoG_UserStatusHelperTest {
    public static testMethod void mainTest(){
        Test.setMock(HttpCalloutMock.Class, new SPoG_TestMockService()); 
        Map<String,String> mapTestInputs = new Map<String,String>();
        Test.startTest();
        mapTestInputs.put('doAction','getUserStatus');
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
        Test.stopTest();
    }
    
    public static testMethod void mainTest_Negative2(){
        SPoG_TestMockServiceError.body = 'Error';
        Test.setMock(HttpCalloutMock.Class, new SPoG_TestMockServiceError()); 
        Map<String,String> mapTestInputs = new Map<String,String>();
        Test.startTest();
        mapTestInputs.put('doAction','getUserStatus');
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
        Test.stopTest();
    }
}