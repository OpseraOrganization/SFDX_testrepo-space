/***************************************************
 * @Description: Test Class for Unit code coverage
 * ************************************************/
@isTest(seeAllData = false)
public with Sharing class SPoG_ClaimsHelperTest {
    
    /***************************************************
     * @Description: Method to test claims information
     * ************************************************/
    testmethod static void testClaims()  {
        Test.setMock(HttpCalloutMock.Class, new SPoG_TestMockService()); 
        Map<String,String> mapTestInputs = new Map<String,String>(); 
        try{
        mapTestInputs.put('doAction','getSAPClaims'); 
        mapTestInputs.put('soldTo','test'); 
        mapTestInputs.put('searchValue','test'); 

        mapTestInputs.put('searchBy','Return Delivery Number'); 
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs)); 
        
        mapTestInputs.put('searchBy',''); 
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs)); 

        mapTestInputs.put('searchBy','Honeywell Purchase Order Number'); 
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs)); 
        mapTestInputs.put('searchBy','Honeywell Return Order Number'); 
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs)); 
        
        }
        catch(exception ex)
        {
            system.debug('error::::::: '+ex);
        }
    }
 
 
}