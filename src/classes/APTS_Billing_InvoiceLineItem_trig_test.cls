@istest public class APTS_Billing_InvoiceLineItem_trig_test {
    static testMethod void getInvoicetest1(){
        Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
            Apttus_Billing__Status__c = 'Draft'
        );
        insert invoice;
        //Creating Standalone product
         List<Product2> prodids = New List<Product2>();
        product2 prod1 = new product2();
        prod1.Name = 'test1'; 
        prod1.IsActive = true;   
        prod1.Apttus_Config2__ConfigurationType__c = 'Standalone'; 
        prod1.family = 'Nav Database';
        prod1.Is_License_Required__c=true;
        prod1.Term__c= 'Indefinite';
        insert prod1;
        prodids.Add(prod1);
       
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
        objOrder2.Generic_xref_SoldTo__c=true;
        objOrder2.Generic_xref_BillTo__c =true;
        objOrder2.Generic_xref_ShipTo__c =true;
        insert objOrder2;
        Apttus_Config2__OrderLineItem__c objLineitem2 = new Apttus_Config2__OrderLineItem__c();
        objLineitem2.Apttus_Config2__LineNumber__c=1;
        objLineitem2.Apttus_Config2__ItemSequence__c=1;
        objLineitem2.CurrencyIsoCode='EUR';
        objLineitem2.Apttus_Config2__OrderId__c=objOrder2.id;
        objLineitem2.Apttus_Config2__ProductId__c=prod1.id;
        objLineitem2.Apttus_Config2__OptionId__c=prod1.id;
        objLineitem2.Apttus_Config2__EndDate__c=system.today();
        insert objLineitem2;
        Apttus_Config2__OrderLineItem__c objLineitem = new Apttus_Config2__OrderLineItem__c();
        objLineitem.Apttus_Config2__LineNumber__c=1;
        objLineitem.Apttus_Config2__ItemSequence__c=1;
        objLineitem.CurrencyIsoCode='EUR';
        objLineitem.Apttus_Config2__OrderId__c=objOrder.id;
        objLineitem.Apttus_Config2__ProductId__c=prod1.id;
        objLineitem.Apttus_Config2__OptionId__c=prod1.id;
        objLineitem.Apttus_Config2__EndDate__c=system.today();
        insert objLineitem;
        
        Apttus_Config2__AssetLineItem__c Assetlines = New Apttus_Config2__AssetLineItem__c();
        Assetlines.Name = prod1.Name;
        Assetlines.Apttus_Config2__OptionId__c = prod1.id;
        Insert Assetlines;
        
        Apttus_Billing__BillingSchedule__c billingSchedule = new Apttus_Billing__BillingSchedule__c();
        billingSchedule.Apttus_Billing__OrderLineItemId__c=objLineitem.Id;
        insert billingSchedule;
        Apttus_Billing__BillingSchedule__c billingSchedule2 = new Apttus_Billing__BillingSchedule__c();
        billingSchedule2.Apttus_Billing__OrderLineItemId__c=objLineitem2.Id;
        insert billingSchedule2;
        Apttus_Billing__InvoiceLineItem__c invoiceLineItem = new Apttus_Billing__InvoiceLineItem__c(
            Apttus_Billing__InvoiceId__c = invoice.id,
            Apttus_Billing__BillingScheduleId__c = billingSchedule.id
        );
        
        insert invoiceLineItem;
        //date.newinstance(2017,1,7);
        Apttus_Billing__InvoiceLineItem__c invoiceLineItem2 = new Apttus_Billing__InvoiceLineItem__c(
            Apttus_Billing__InvoiceId__c = invoice.id,
            Apttus_Billing__StartDate__c =date.newinstance(2017,1,7),
            Apttus_Billing__BillingScheduleId__c = billingSchedule2.id
        );
        insert invoiceLineItem2;
        
        Product_Helper.checkIs_License_Required(prodids);
        Product_Helper.processIs_License_Required(prodids,false,null,null,false,null,null);
        
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
}