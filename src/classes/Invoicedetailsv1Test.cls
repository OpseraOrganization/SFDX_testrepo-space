@isTest
public with sharing class Invoicedetailsv1Test{
    static testMethod void getInvoicetest1(){
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
            Apttus_Billing__Status__c = 'Draft'
        );
        insert invoice;
         //Creating Standalone product
        product2 prod1 = new product2();
        prod1.Name = 'test1'; 
        prod1.IsActive = true;   
        prod1.Apttus_Config2__ConfigurationType__c = 'Standalone'; 
        prod1.family = 'Nav Database';
        prod1.Is_License_Required__c=true;
        prod1.Term__c= 'Indefinite';
        insert prod1;
        Apttus_Config2__Order__c objOrder= new Apttus_Config2__Order__c();
        objOrder.Apttus_Config2__Type__c='New';
        objOrder.CurrencyIsoCode='EUR';
        objOrder.Apttus_Config2__PODate__c=system.today();
        objOrder.Apttus_Config2__PONumber__c='1234';
        objOrder.SoldTo_Number__c='32324';
        insert objOrder;
        Apttus_Config2__Order__c objOrder2= new Apttus_Config2__Order__c();
        objOrder2.Apttus_Config2__Type__c='New';
        objOrder2.CurrencyIsoCode='EUR';
        objOrder2.Apttus_Config2__PODate__c=system.today();
        objOrder2.Apttus_Config2__PONumber__c='1234';
        objOrder2.SoldTo_Number__c='2443144';
        insert objOrder2;
        Apttus_Config2__OrderLineItem__c objLineitem = new Apttus_Config2__OrderLineItem__c();
        objLineitem.Apttus_Config2__LineNumber__c=1;
        objLineitem.Apttus_Config2__ItemSequence__c=1;
        objLineitem.CurrencyIsoCode='EUR';
        objLineitem.Apttus_Config2__OrderId__c=objOrder.id;
        objLineitem.Apttus_Config2__ProductId__c=prod1.id;
        objLineitem.Apttus_Config2__OptionId__c=prod1.id;
        objLineitem.Apttus_Config2__EndDate__c=system.today();
        insert objLineitem;
        Apttus_Billing__BillingSchedule__c billingSchedule = new Apttus_Billing__BillingSchedule__c();
        billingSchedule.Apttus_Billing__OrderLineItemId__c=objLineitem.Id;
        insert billingSchedule;
        Apttus_Billing__InvoiceLineItem__c invoiceLineItem = new Apttus_Billing__InvoiceLineItem__c(
          Apttus_Billing__InvoiceId__c = invoice.id,
            Apttus_Billing__BillingScheduleId__c = billingSchedule.id
        );
        insert invoiceLineItem;
        //date.newinstance(2017,1,7);
        Apttus_Billing__InvoiceLineItem__c invoiceLineItem2 = new Apttus_Billing__InvoiceLineItem__c(
          Apttus_Billing__InvoiceId__c = invoice.id,
            Apttus_Billing__StartDate__c =date.newinstance(2017,1,7)
        );
        insert invoiceLineItem2;
        
        //-----/services/apexrest//ngbss/invoices/01t0U000002Kzj0
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = 'https://hon-aero--apttusdev.my.salesforce.com/services/apexrest//ngbss/invoices/'+invoice.id;
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        Invoicedetailsv1.getInvoice();
        
        
        RestRequest req2 = new RestRequest(); 
        RestResponse res2 = new RestResponse();
        req2.requestURI = 'https://hon-aero--apttusdev.my.salesforce.com/services/apexrest//ngbss/invoices';
        req2.addHeader('Content-Type', 'application/json');
        req2.httpMethod = 'GET';
        RestContext.request = req2;
        RestContext.response= res2;
        Invoicedetailsv1.getInvoice();
        
        RestRequest req3 = new RestRequest(); 
        RestResponse res3 = new RestResponse();
        req3.requestURI = 'https://hon-aero--apttusdev.my.salesforce.com/services/apexrest//ngbss/invoices'+invoice.id+1;
        req3.addHeader('Content-Type', 'application/json');
        req3.httpMethod = 'GET';
        RestContext.request = req3;
        RestContext.response= res3;
        Invoicedetailsv1.getInvoice();
        Test.stopTest();
    }
    @isTest static void postrequesttest1() {
        test.startTest();
    Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
            Apttus_Billing__Status__c = 'Draft',
            Apttus_Billing__TotalFeeAmount__c=20
        );
        insert invoice;
    Apttus_Billing__InvoiceLineItem__c invLineItem = new Apttus_Billing__InvoiceLineItem__c();
        invLineItem.Apttus_Billing__InvoiceId__c = invoice.id;       
        insert invLineItem;
        String json=    '{'+
    '    "billingDocument": "test",'+
    '    "dmrCMR": "stestg",'+
    '    "ccauthRefNo": "strning",'+
    '    "ccauthorizationBlock": "string",'+
    '    "integrationMethod": "Debit Memo Request",'+
    '    "integrationStatus": "Requested",'+
    '    "integrationResult": "string",'+
    '    "invoiceStatus": "string",'+
    '    "tax": 2,'+
    '    "items": ['+
    '        {'+
    '            "lineItemId": "'+invLineItem.id+'",'+
    '            "xr1": "0",'+
    '            "xr2": 0,'+
    '            "xr3": 5,'+
    '            "xr4": 0,'+
    '            "xr5": 6,'+
    '            "xr6": 0,'+
    '            "mwst": 0,'+
    '            "totalTaxAmount": 0'+
    '        }'+
    '    ]'+
    '}';
        RestRequest request = new RestRequest();
        request.requestUri ='https://hon-aero--apttusdev.my.salesforce.com/services/apexrest//ngbss/invoices/'+invoice.id;
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        Invoicedetailsv1.postrequest();
        test.stoptest();
    }
}