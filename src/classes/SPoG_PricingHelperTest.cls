/***********************************************
* @Description: Apex Class for Unit Test Coverage
* ********************************************/
@isTest(seeAllData = false)
public with Sharing class SPoG_PricingHelperTest {
    
    /***************************************************
* @Description: Test method for Pricing
* **************************************************/
    testmethod static void testPricing(){
        //Test Mock Service
        Test.setMock(HttpCalloutMock.Class, new SPoG_TestMockService()); 
        Map<String,Object> mapTestInputs = new Map<String,Object>(); 
        SPoG_PriceTypeMapping__c objprice = new SPoG_PriceTypeMapping__c();
        objprice.subType__c = 'TEST';
        objprice.tranType__c = 'TEST1';
        objprice.Name = 'TEST2';
        //insert objprice;
        
        mapTestInputs.put('doAction','getPricingInfo');
        mapTestInputs.put('soldTo','test'); 
        mapTestInputs.put('salesOrg','test'); 
        mapTestInputs.put('dChannel','test');
        mapTestInputs.put('pricingDate','2020-02-24'); 
        mapTestInputs.put('shipTo','test'); 
        mapTestInputs.put('lstMaterials', JSON.serialize(new List<MatInput>{new MatInput()})); 
        
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs)); 
        
    }
    
    
    private with Sharing Class MatInput {
        String quoteId = 'test' ; 
        Integer materialQuantity = 2 ; 
        String materialNumber = 'test'; 
    }
    
}