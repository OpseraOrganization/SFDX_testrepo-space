/****************************************************
* @Description: Test Class for unit code coverage. 
* ************************************************/
@isTest(seeAllData = false)
public with Sharing class SPoG_StocksHelperTest {
    
    /*******************************************************
* @Description: test method for global stock
* *****************************************************/
    testmethod static void testGlobalStock() {
        
        Test.setMock(HttpCalloutMock.Class, new SPoG_TestMockService()); 
        Map<String,Object> mapTestInputs = new Map<String,Object>(); 
        try{
            mapTestInputs.put('doAction','getStockAvailability'); 
            mapTestInputs.put('materialNumber','test'); 
            mapTestInputs.put('plantNumber','test'); 
            mapTestInputs.put('unitOfMeasure','test'); 
            mapTestInputs.put('skipValue','test'); 
            mapTestInputs.put('isPlantSearch',false); 
            mapTestInputs.put('storageLocation','test'); //
            Test.startTest();
            SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
            Test.stopTest();
        }
        catch(exception ex)
        {
            System.debug('Error::::::::'+ex);
        }
        
    }
    
    /***************************************************
* @Description: test method for plant stock
* *************************************************/
    testmethod static void testPlantStock() 
    {
        Test.setMock(HttpCalloutMock.Class, new SPoG_TestMockService()); 
        Map<String,Object> mapTestInputs = new Map<String,Object>();
        try
        {
            mapTestInputs.put('doAction','getStockAvailability'); 
            mapTestInputs.put('materialNumber','test'); 
            mapTestInputs.put('plantNumber','test'); 
            mapTestInputs.put('unitOfMeasure','test'); 
            mapTestInputs.put('storageLocation','test'); //
            mapTestInputs.put('skipValue','test'); 
            mapTestInputs.put('isPlantSearch',true);// 
            mapTestInputs.put('salesOrg','test'); //
            mapTestInputs.put('dChannel','test'); //
            Test.startTest();
            SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
            Test.stopTest();
        }
        catch(exception ex)
        {
            System.debug('Error::::::::'+ex);
        }   
    }
    
}