@RestResource(UrlMapping = '/ngbss/orders/*/cart/*/invoice/*')
global with sharing class FinalizeCartRestResource
{

    @HttpPost
    global static void finalizeCart()
    {
         List<CPQ_Platform__c> pflist = new List<CPQ_Platform__c>();
         List <Apttus_Billing__Invoice__c> invoices = new List <Apttus_Billing__Invoice__c>();
         Date invoiceDate = Date.Today();
         DateTime targetDateTime= DateTime.now().AddDays(1);
         String Accountid;
         String InvoiceTemplate;
         String InvoiceStatementTemplate;
         String InvoiceStatementTemplate1;
        String InvoiceStatementTemplate2;
        String InvoiceStatementTemplate3;
        String InvoiceStatementTemplate4;
        String InvoiceStatementTemplate5;
        String InvoiceStatementTemplate6;
        String InvoiceStatementTemplate7;
        String InvoiceStatementTemplate8;
        String InvoiceStatementTemplate9;
        String InvoiceStatementTemplate10;
        String InvoiceStatementTemplate11;
        String InvoiceStatementTemplate12;
        String InvoiceStatementTemplate13;
        String InvoiceStatementTemplate14;
        String InvoiceStatementTemplate15;
        String InvoiceStatementTemplate16;
        String InvoiceStatementTemplate17;
        String InvoiceStatementTemplate18;
        String InvoiceStatementTemplate19;
        String InvoiceStatementTemplate20;
        String InvoiceStatementTemplate21;
        String InvoiceStatementTemplate22;
        String InvoiceStatementTemplate23;
        String InvoiceStatementTemplate24;
        String InvoiceStatementTemplate25;
        String InvoiceStatementTemplate26;
        String InvoiceStatementTemplate27;
        String InvoiceStatementTemplate28;
        String InvoiceStatementTemplate29;
        String InvoiceStatementTemplate30;
        String InvoiceStatementTemplate31;
        String InvoiceStatementTemplate32;
        String InvoiceStatementTemplate33;
        String InvoiceStatementTemplate34;
        String InvoiceStatementTemplate35;
        String InvoiceStatementTemplate36;
        String InvoiceStatementTemplate37;
        String InvoiceStatementTemplate38;
        String InvoiceStatementTemplate39;
        String InvoiceStatementTemplate40;
        String InvoiceStatementTemplate41;
        String InvoiceStatementTemplate42;
        String InvoiceStatementTemplate43;
        String InvoiceStatementTemplate44;
        String InvoiceStatementTemplate45;
        String InvoiceStatementTemplate46;
        String InvoiceStatementTemplate47;
        String InvoiceStatementTemplate48;
        String InvoiceStatementTemplate49;
        String InvoiceStatementTemplate50;
        String InvoiceStatementTemplate51;
        String InvoiceStatementTemplate52;
        String InvoiceStatementTemplate53;
        String InvoiceStatementTemplate54;
        String InvoiceStatementTemplate55;
        String InvoiceStatementTemplate56;
        String InvoiceStatementTemplate57;
        String InvoiceStatementTemplate58;
        String InvoiceStatementTemplate59;
        String InvoiceStatementTemplate60;
        String InvoiceStatementTemplate61;
        String InvoiceStatementTemplate62;
        String InvoiceStatementTemplate63;
        String InvoiceStatementTemplate64;
        String InvoiceStatementTemplate65;
        String InvoiceStatementTemplate66;
        String InvoiceStatementTemplate67;
        String InvoiceStatementTemplate68;
        String InvoiceStatementTemplate69;
        String InvoiceStatementTemplate70;
        String InvoiceStatementTemplate71;
        String InvoiceStatementTemplate72;
        String InvoiceStatementTemplate73;
        String InvoiceStatementTemplate74;
        String InvoiceStatementTemplate75;
        String InvoiceStatementTemplate76;
        String InvoiceStatementTemplate77;
        String InvoiceStatementTemplate78;
        String InvoiceStatementTemplate79;
        String InvoiceStatementTemplate80;
        String InvoiceStatementTemplate81;
        String InvoiceStatementTemplate82;
        String InvoiceStatementTemplate83;
        String InvoiceStatementTemplate84;
        String InvoiceStatementTemplate85;
        String InvoiceStatementTemplate86;
        String InvoiceStatementTemplate87;
        String InvoiceStatementTemplate88;
        String InvoiceStatementTemplate89;
        String InvoiceStatementTemplate90;
        String InvoiceStatementTemplate91;
        String InvoiceStatementTemplate92;
        String InvoiceStatementTemplate93;
        String InvoiceStatementTemplate94;
        String InvoiceStatementTemplate95;
        String InvoiceStatementTemplate96;
        String InvoiceStatementTemplate97;
        String InvoiceStatementTemplate98;
        String InvoiceStatementTemplate99;
        
        
        RestRequest request = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type','application/json');
        
        system.debug('URL Data >> '+ request.requestURI.split('/')[5]);
        String cartId = request.requestURI.split('/')[5];
        String orderId = request.requestURI.split('/')[3];
        integer orderCount = [select count() from Apttus_Config2__Order__c where id=:orderId];
        integer cartCount = [select count() from Apttus_Config2__ProductConfiguration__c where id=:cartId];
        
      try
      { 
       if(orderCount==0){
        // throw exception
          throw new MyException('OrderId is Invalid');
        }
        if(cartCount==0){
        // throw exception
          throw new MyException('cartId is Invalid');
        }
        Map<String,String> m = new Map<String,String>();
        Apttus_Config2__Order__c ord = [select AspireInvoice_Created__c,Aspire_InvoiceId__c,Apttus_Config2__PaymentTermId__c from Apttus_Config2__Order__c  where id =: orderId]; 
        
        if(ord.AspireInvoice_Created__c == false){
        
            Apttus_Config2.CPQStruct.SynchronizeCartRequestDO sync = new Apttus_Config2.CPQStruct.SynchronizeCartRequestDO();
            sync.CartId = cartId;
            Apttus_Config2.CPQStruct.SynchronizeCartResponseDO result2 = Apttus_Config2.OrderWebService.synchronizeCart(sync);
                 
            
            //Create Assets
            Apttus_Config2.CPQStruct.CreateAssetRequestDO request3 = new Apttus_Config2.CPQStruct.CreateAssetRequestDO();
            request3.OrderId = orderId;
            Apttus_Config2.CPQStruct.CreateAssetResponseDO result3 = Apttus_Config2.OrderWebService.createAsset(request3);
            
            system.debug(result3 );
            
            //Accepting the order
            Apttus_Config2.CPQStruct.AcceptOrderRequestDO request1  = new Apttus_Config2.CPQStruct.AcceptOrderRequestDO();
            request1.OrderId = orderId;
            Apttus_Config2.CPQStruct.AcceptOrderResponseDO response = Apttus_Config2.OrderWebService.acceptOrder(request1);
           
           
           
            //Update Platforms with order line item id
            //Fetch Line items along with platforms
            List<Apttus_Config2__LineItem__c> lineitems = [select id, Apttus_Config2__OrderLineItemId__c, (select Order_Line_Item__c, Line_Item__c from CPQ_Platforms__r) from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c =: cartId];
            //Fetch order line items for the given order id
             system.debug(lineitems );
            
            List<Apttus_Config2__OrderLineItem__c> orderLi = [select id, Apttus_Config2__DerivedFromId__c,Apttus_Config2__OrderId__r.Apttus_Config2__SoldToAccountId__c,
            Apttus_Config2__OrderId__r.Apttus_Config2__SoldToAccountId__r.Apttus_Config2__DefaultInvoiceStatementTemplate__c,
            Apttus_Config2__OrderId__r.Apttus_Config2__SoldToAccountId__r.Apttus_Config2__DefaultInvoiceTemplate__c from Apttus_Config2__OrderLineItem__c where Apttus_Config2__OrderId__c =: orderId];
             system.debug(orderLi);
            
           
            //Update OrderLineItem id in line items
            for(Apttus_Config2__OrderLineItem__c oli:orderLi)
            {
                Accountid = Oli.Apttus_Config2__OrderId__r.Apttus_Config2__SoldToAccountId__c;
                InvoiceTemplate = Oli.Apttus_Config2__OrderId__r.Apttus_Config2__SoldToAccountId__r.Apttus_Config2__DefaultInvoiceTemplate__c ;
                InvoiceStatementTemplate = Oli.Apttus_Config2__OrderId__r.Apttus_Config2__SoldToAccountId__r.Apttus_Config2__DefaultInvoiceStatementTemplate__c;
                for(Apttus_Config2__LineItem__c li:lineitems)
                {
                    if(oli.Apttus_Config2__DerivedFromId__c == li.id)
                    {
                        //li.Apttus_Config2__OrderLineItemId__c = oli.id;
                        for(CPQ_Platform__c pf:li.CPQ_Platforms__r)
                        {
                            pf.Order_Line_Item__c = oli.id;
                            pflist.add(pf);
                        }
                        break;
                    }
                }
             }   
            
            //update lineitems;
            update pflist;
            
            Account Acc = New Account(id = Accountid,Apttus_Config2__DefaultInvoiceTemplate__c = '',Apttus_Config2__DefaultInvoiceStatementTemplate__c ='' );
            Update Acc;
            
            
            
          //Create Invoice       
            
            invoices = Apttus_Billing.BillingService.createInvoicesForOrder(orderID, targetDateTime, invoiceDate);
            Acc.Apttus_Config2__DefaultInvoiceTemplate__c = InvoiceTemplate ;
            Acc.Apttus_Config2__DefaultInvoiceStatementTemplate__c = InvoiceStatementTemplate ;
            
            Update Acc;
            
            if(invoices.size() == 1)
            {
                ord.AspireInvoice_Created__c = true;
                ord.Aspire_InvoiceId__c = invoices[0].id;
                update ord;
                                
                m.put('invoiceId',invoices[0].id);
                invoices[0].APTS_Integration_Status__c = 'To be Processed';
                invoices[0].Apttus_Billing__PaymentTermId__c = ord.Apttus_Config2__PaymentTermId__c;
                update invoices[0];
                res.responseBody = Blob.valueOf(JSON.serialize(m));
                res.statusCode = 200;
            }
            
            else{
                throw new MyException('Issue in Invoice generation');
            }
        }
        else 
        {
            m.put('invoiceId',ord.Aspire_InvoiceId__c);
            res.responseBody = Blob.valueOf(JSON.serialize(m));
            res.statusCode = 200;
              
        }
        
        
        
      }
      catch(Exception e)
      {
          MyExc error = new MyExc('BAD_REQUEST',e.getMessage());
          res.responseBody = Blob.valueOf(json.serialize(error));
          res.statusCode = 400;    
      }
    
    }
    
    
    global class OrderandCartIds
    {
      public string cartId;
      public string orderId;
    
    }
    
    public class MyException extends Exception {}
    
     global class MyExc 
     { 
        public string errorCode;
        public string message;
        
        MyExc(string errorCode, string message)
        {
            this.errorCode = errorCode;
            this.message = message;
        }
    
     }


}