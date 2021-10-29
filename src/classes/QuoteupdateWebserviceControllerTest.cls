@isTest
public class QuoteupdateWebserviceControllerTest {
    static testMethod void test_QuoteUpdate(){
       test.startTest();     
            quote__c quo=new quote__c();
           quo.name='123';   
           insert quo;  
        QuoteupdateWebserviceController.QuoteRecord clsQutRec = new  QuoteupdateWebserviceController.QuoteRecord();      
        clsQutRec.SFDCQuoteID = quo.id;     
         clsQutRec.QuoteRevenueAmount = '23.4234';
          clsQutRec.QuoteExpirationDate = '10-08-2019';  
        String myJson = JSON.serialize(clsQutRec);
       
       RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/AerospaceQuoteService/*';
        RestContext.request.addHeader('Content-Type', 'application/json');
       RestContext.request.requestBody = Blob.valueOf(JSON.serializePretty(clsQutRec));
       QuoteupdateWebserviceController.QuoteRecord clsQutRec1 = (QuoteupdateWebserviceController.QuoteRecord)JSON.deserialize(myJson, QuoteupdateWebserviceController.QuoteRecord.class);
       
       RestRequest req = new RestRequest();
        req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
        req.requestURI = '/AerospaceQuoteService/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(myJson); // Add JSON Message as a POST
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
               
        QuoteupdateWebserviceController.doPost();
          
        test.stopTest();
       
    }
     static testMethod void test_QuoteUpdate1(){
       test.startTest();     
          
        QuoteupdateWebserviceController.QuoteRecord clsQutRec = new  QuoteupdateWebserviceController.QuoteRecord();      
        //clsQutRec.SFDCQuoteID = '123456';    
         //QuoteupdateWebserviceController.errMessage='Error';  
        String myJson = JSON.serialize(clsQutRec);       
      
       RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/AerospaceQuoteService/*';
        RestContext.request.addHeader('Content-Type', 'application/json');
       RestContext.request.requestBody = Blob.valueOf(JSON.serializePretty(clsQutRec));
       QuoteupdateWebserviceController.QuoteRecord clsQutRec1 = (QuoteupdateWebserviceController.QuoteRecord)JSON.deserialize(myJson, QuoteupdateWebserviceController.QuoteRecord.class);
       
       RestRequest req = new RestRequest();
        req.addHeader('Content-Type', 'application/json'); // Add a JSON Header as it is validated
        req.requestURI = '/AerospaceQuoteService/*';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(myJson); // Add JSON Message as a POST
        RestResponse res = new RestResponse();
        RestContext.request = req;
        RestContext.response = res;
        QuoteupdateWebserviceController.doPost();
          
        test.stopTest();
       
    }
}