@isTest
public class RepriceCartRestResourceTest{ 
    @isTest
    static void repriceCarttest1(){
        test.startTest();
        Apttus_Config2__Order__c objOrder= new Apttus_Config2__Order__c();
        objOrder.Apttus_Config2__Type__c='New';
        objOrder.CurrencyIsoCode='EUR';
        objOrder.Apttus_Config2__PODate__c=system.today();
        objOrder.Apttus_Config2__PONumber__c='1234';
        insert objOrder;
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        insert proposal;
        Apttus_Config2__ProductConfiguration__c config = new Apttus_Config2__ProductConfiguration__c(
            Apttus_Config2__ContractNumbers__c = '0',
            Apttus_Config2__BusinessObjectRefId__c = proposal.id
        );
        insert config;
        
        String json='{'+
            '}';
        RestRequest request = new RestRequest();
        request.requestUri ='services/apexrest/orders/'+objOrder.id+'/cart/'+config.id;
        request.httpMethod = 'POST';
        request.addParameter('action', 'reprice');
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        RepriceCartRestResource.repriceCart();
        test.stoptest();
    }
    @isTest
    static void repriceCarttest2(){
        test.startTest();
        Apttus_Config2__Order__c objOrder= new Apttus_Config2__Order__c();
        objOrder.Apttus_Config2__Type__c='New';
        objOrder.CurrencyIsoCode='EUR';
        objOrder.Apttus_Config2__PODate__c=system.today();
        objOrder.Apttus_Config2__PONumber__c='1234';
        insert objOrder;
        Apttus_Proposal__Proposal__c proposal = new Apttus_Proposal__Proposal__c();
        insert proposal;
        Apttus_Config2__ProductConfiguration__c config = new Apttus_Config2__ProductConfiguration__c(
            Apttus_Config2__ContractNumbers__c = '0',
            Apttus_Config2__BusinessObjectRefId__c = proposal.id
        );
        insert config;
        String json='{'+
            '}';
        RestRequest request = new RestRequest();
        request.requestUri ='services/apexrest/orders/'+objOrder.id+'/cart/'+config.id;
        request.httpMethod = 'POST';
        //request.addParameter('action', 'reprice');
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        RepriceCartRestResource.repriceCart();
        test.stoptest();
    }
    
}