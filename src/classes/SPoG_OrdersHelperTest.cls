/***********************************************
* @Description: Apex Class for Unit Code coverage
* ********************************************/
@isTest(seeAllData = false)
public with Sharing class SPoG_OrdersHelperTest { 
    testmethod static void deleteAttachments() {
        Test.setMock(HttpCalloutMock.Class, new SPoG_TestMockService()); 
        Map<String,String> mapTestInputs = new Map<String,String>(); 
        mapTestInputs.put('documentId','test'); 
        mapTestInputs.put('componentId','test'); 
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
        mapTestInputs.put('doAction','deleteAttachment'); 
       SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
    }
    
    /******************************************************
* @Description: Test method for order summary and line items
* ***************************************************/
    testmethod static void testOrderInformation() {
        
        Test.setMock(HttpCalloutMock.Class, new SPoG_TestMockService()); 
        
        Map<String,String> mapTestInputs = new Map<String,String>(); 
        
       //mapTestInputs.put('doAction','getOrderSummary'); 
        mapTestInputs.put('searchBy','Honeywell Purchase Order'); 
        mapTestInputs.put('searchKey','Test'); 
        mapTestInputs.put('materialNumber','test'); 
        mapTestInputs.put('partNumber','test'); 
        mapTestInputs.put('soldToNumber','test'); 
        try{
            SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs)); 
            System.debug('Requet 1 done-----------------------');
            mapTestInputs.put('searchBy','Honeywell Sales Order'); 
            SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
            System.debug('Requet 2 done-----------------------');
            mapTestInputs.put('doAction','getOrderDetails'); 
            mapTestInputs.put('IP_SALES_ORDER','test'); 
            SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
            System.debug('Requet 3 done-----------------------');
        } catch(exception e){
        }
        /* mapTestInputs.put('doAction','getPOAttachment'); 
mapTestInputs.put('soldToNumber','test'); 
SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs)); */
        Test.startTest();
        mapTestInputs.put('doAction','searchOrders'); 
        mapTestInputs.put('soldToNumber','test');
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
        System.debug('Requet 4 done-----------------------');
        /*mapTestInputs.put('doAction','deleteAttachment'); 
SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));*/
        Test.stopTest(); 
    }
    testmethod static void testOrderInformation1() {
        
        Test.setMock(HttpCalloutMock.Class, new SPoG_TestMockService()); 
        
        Map<String,String> mapTestInputs = new Map<String,String>(); 
      //  mapTestInputs.put('doAction','getOrderSummary'); 
        mapTestInputs.put('searchBy','Honeywell Purchase Order'); 
        mapTestInputs.put('searchKey','Test'); 
        mapTestInputs.put('materialNumber','test'); 
        mapTestInputs.put('partNumber','test');
        mapTestInputs.put('salesOrganization','test');
        mapTestInputs.put('distributionChannel','test');
        mapTestInputs.put('soldToNumber','test'); 
        try{
            SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
            System.debug('Requet 1 done 2-----------------------');
            mapTestInputs.put('searchBy','Honeywell Sales Order'); 
            SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
            System.debug('Requet 2 done 2-----------------------');
            mapTestInputs.put('doAction','getOrderDetails'); 
            mapTestInputs.put('IP_SALES_ORDER','test'); 
            SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
            System.debug('Requet 3 done 2-----------------------');
        } catch(exception e){
        }
        /* mapTestInputs.put('doAction','getPOAttachment'); 
mapTestInputs.put('soldToNumber','test'); 
SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs)); */
        Test.startTest();
        mapTestInputs.put('doAction','searchOrders'); 
        mapTestInputs.put('searchBy','custPO'); 
        mapTestInputs.put('searchKey','456768'); 
        mapTestInputs.put('custNO',''); 
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
        System.debug('Requet 4 done 2-----------------------');
        //SPoG_OrderHelper.deleteAttachment(mapTestInputs);
        
        Test.stopTest(); 
    }
    
    testmethod static void testOrderInformation2() {
        
        Test.setMock(HttpCalloutMock.Class, new SPoG_TestMockService()); 
        Map<String,String> mapTestInputs = new Map<String,String>(); 
        mapTestInputs.put('doAction','getDeliverySummary'); 
        mapTestInputs.put('searchBy','Honeywell Purchase Order'); 
        mapTestInputs.put('searchKey','Test'); 
        mapTestInputs.put('materialNumber','test'); 
        mapTestInputs.put('partNumber','test');
        mapTestInputs.put('salesOrganization','test');
        mapTestInputs.put('distributionChannel','test');
        mapTestInputs.put('soldToNumber','test');
        mapTestInputs.put('orderNumber','test'); 
        test.startTest();
        try{
            SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs)); 
        }catch(Exception ex){
            
        }
        test.stopTest();
    }
    
    testmethod static void attachments() {
        Test.setMock(HttpCalloutMock.Class, new SPoG_TestMockService()); 
        Map<String,String> mapTestInputs = new Map<String,String>(); 
        mapTestInputs.put('doAction','getPOAttachment'); 
        mapTestInputs.put('documentId','test'); 
        mapTestInputs.put('componentId','test'); 
        SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
        mapTestInputs.put('doAction','deleteAttachment'); 
       SPoG_Handler.executeRequest(JSON.serialize(mapTestInputs));
    }
     
        
    
}