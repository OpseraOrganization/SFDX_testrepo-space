@isTest
public class APIGEE_Error_ResultTest {
    
    @isTest static void APIGEE_ResulErrorTestCovrage(){
        APIGEE_Error error = new APIGEE_Error(400,System.now(),'Test','Test');
        APIGEE_Result result = new APIGEE_Result();
        result.StatusMessage = 'test';
        result.resourceId = 'Test';
        result.resource= null;
    }
}