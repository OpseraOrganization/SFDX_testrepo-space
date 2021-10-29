@istest
public class OrderLicenseRestResourceTest{
    
    @isTest
    static void getOrderlicensestest1(){
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
        CPQ_Platform__c platf= new CPQ_Platform__c();
        platf.Order_Line_Item__c=objLineitem.id;
        platf.Type__c='test';
        insert platf;
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
            Apttus_Billing__Status__c = 'Draft'
        );
        insert invoice;
        Apttus_Billing__BillingSchedule__c billingSchedule = new Apttus_Billing__BillingSchedule__c();
        billingSchedule.Apttus_Billing__OrderLineItemId__c=objLineitem.Id;
        insert billingSchedule;
        
        Apttus_Billing__InvoiceLineItem__c invoiceLineItem = new Apttus_Billing__InvoiceLineItem__c(
            Apttus_Billing__InvoiceId__c = invoice.id,
            Apttus_Billing__BillingScheduleId__c = billingSchedule.id
        );
        
        RestRequest request = new RestRequest();    
        RestResponse response = new RestResponse();   
        request.requestUri = 'https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/ngbss/licenses';
        request.httpMethod = 'GET';
        request.addParameter('invoiceId', invoice.id);
        //request.addParameter('soldTos', '32324');
        request.addParameter('category', 'Nav Database');
        RestContext.request = request;
        RestContext.response = response;
        OrderLicenseRestResource.getOrderlicenses();
        
        RestRequest request2 = new RestRequest();    
        RestResponse response2 = new RestResponse();   
        request2.requestUri = 'https://hon-aero--apttusdev.my.salesforce.com/services/apexrest//ngbss/licenses';
        request2.httpMethod = 'GET';
        //request2.addParameter('invoiceId', invoice.id);
        request2.addParameter('soldTos', '32324');
        request2.addParameter('category', 'Nav Database');
        RestContext.request = request2;
        RestContext.response = response2;
        OrderLicenseRestResource.getOrderlicenses();
        
        RestRequest request3 = new RestRequest();    
        RestResponse response3 = new RestResponse();   
        request3.requestUri = 'https://hon-aero--apttusdev.my.salesforce.com/services/apexrest//ngbss/licenses';
        request3.httpMethod = 'GET';
        request3.addParameter('invoiceId', invoice.id);
        request3.addParameter('soldTos', '32324');
        request3.addParameter('category', 'Nav Database');
        RestContext.request = request3;
        RestContext.response = response3;
        OrderLicenseRestResource.getOrderlicenses();
    }
    @isTest
    static void getOrderlicensestest2(){
        //Creating Standalone product
        product2 prod1 = new product2();
        prod1.Name = 'test1'; 
        prod1.IsActive = true;   
        prod1.Apttus_Config2__ConfigurationType__c = 'Standalone'; 
        prod1.family = 'Nav Database';
        prod1.Is_License_Required__c=true;
        //prod1.Term__c= 'Indefinite';
    prod1.License_Type__c = 'APU';
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
        //objLineitem.License_Expiry_Date__c=;
        insert objLineitem;
        CPQ_Platform__c platf= new CPQ_Platform__c();
        platf.Order_Line_Item__c=objLineitem.id;
        platf.Type__c='test';
        insert platf;
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
            Apttus_Billing__Status__c = 'Draft'
        );
        insert invoice;
        Apttus_Billing__BillingSchedule__c billingSchedule = new Apttus_Billing__BillingSchedule__c();
        billingSchedule.Apttus_Billing__OrderLineItemId__c=objLineitem.Id;
        insert billingSchedule;
        
        Apttus_Billing__InvoiceLineItem__c invoiceLineItem = new Apttus_Billing__InvoiceLineItem__c(
            Apttus_Billing__InvoiceId__c = invoice.id,
            Apttus_Billing__BillingScheduleId__c = billingSchedule.id
        );
        
        RestRequest request = new RestRequest();    
        RestResponse response = new RestResponse();   
        request.requestUri = 'https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/ngbss/licenses';
        request.httpMethod = 'GET';
        request.addParameter('invoiceId', invoice.id);
        //request.addParameter('soldTos', '32324');
        request.addParameter('category', 'Nav Database');
        RestContext.request = request;
        RestContext.response = response;
        OrderLicenseRestResource.getOrderlicenses();
        
        RestRequest request2 = new RestRequest();    
        RestResponse response2 = new RestResponse();   
        request2.requestUri = 'https://hon-aero--apttusdev.my.salesforce.com/services/apexrest//ngbss/licenses';
        request2.httpMethod = 'GET';
        //request2.addParameter('invoiceId', invoice.id);
        request2.addParameter('soldTos', '32324');
        request2.addParameter('category', 'Nav Database');
        RestContext.request = request2;
        RestContext.response = response2;
        OrderLicenseRestResource.getOrderlicenses();
        
        RestRequest request3 = new RestRequest();    
        RestResponse response3 = new RestResponse();   
        request3.requestUri = 'https://hon-aero--apttusdev.my.salesforce.com/services/apexrest//ngbss/licenses';
        request3.httpMethod = 'GET';
        request3.addParameter('invoiceId', invoice.id);
        request3.addParameter('soldTos', '32324');
        request3.addParameter('category', 'Nav Database');
        RestContext.request = request3;
        RestContext.response = response3;
        OrderLicenseRestResource.getOrderlicenses();
    }
    @isTest
    static void OrderlicensesHeadertest1(){
        test.starttest();
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
        Apttus_Config2__OrderLineItem__c objLineitem = new Apttus_Config2__OrderLineItem__c();
        objLineitem.Apttus_Config2__LineNumber__c=1;
        objLineitem.Apttus_Config2__ItemSequence__c=1;
        objLineitem.CurrencyIsoCode='EUR';
        objLineitem.Apttus_Config2__OrderId__c=objOrder.id;
        objLineitem.Apttus_Config2__ProductId__c=prod1.id;
        objLineitem.Apttus_Config2__OptionId__c=prod1.id;
        objLineitem.Apttus_Config2__EndDate__c=system.today();
        insert objLineitem;
        CPQ_Platform__c platf= new CPQ_Platform__c();
        platf.Order_Line_Item__c=objLineitem.id;
        platf.Type__c='test';
        insert platf;
        Apttus_Config2__OrderLineItem__c objLineitem2 = new Apttus_Config2__OrderLineItem__c();
        objLineitem2.Apttus_Config2__LineNumber__c=1;
        objLineitem2.Apttus_Config2__ItemSequence__c=1;
        objLineitem2.CurrencyIsoCode='EUR';
        objLineitem2.Apttus_Config2__OrderId__c=objOrder.id;
        objLineitem2.Apttus_Config2__ProductId__c=prod1.id;
        objLineitem2.Apttus_Config2__OptionId__c=prod1.id;
        objLineitem2.Apttus_Config2__EndDate__c=system.today();
        insert objLineitem2;
        CPQ_Platform__c platf2= new CPQ_Platform__c();
        platf2.Order_Line_Item__c=objLineitem2.id;
        platf2.Type__c='test';
        insert platf2;
        
        String json='{'+
    '    "lineItems": ['+
    '        {'+
    '            "lineItemId": "'+objLineitem.id+'",'+
    '            "activationKey": "a123",'+
    '            "platforms": ['+
    '                {'+
    '                    "platformId": "'+platf.id+'",'+
    '                    "activationKey": "a456",'+
    '                    "licenseStatus": "Activation Key-Linked"'+
    '                },'+
        '          {'+
            '                    "platformId": "'+platf2.id+'",'+
    '                    "activationKey": "a456",'+
    '                    "licenseStatus": "Activation Key-Linked"'+
    '                }'+
    '            ]'+
    '        }'+
    '    ]'+
    '}';
        RestRequest request = new RestRequest();
        request.requestUri = 'https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/ngbss/licenses';
        request.httpMethod = 'POST';
        //request.addParameter('action', 'reprice');
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        OrderLicenseRestResource.OrderlicensesHeader();
        test.stoptest();
    }
}