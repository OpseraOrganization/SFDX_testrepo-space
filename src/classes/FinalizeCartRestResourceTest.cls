@isTest
public class FinalizeCartRestResourceTest {
      @isTest 
    static void finalizeCartTest2(){
        test.startTest();
        Account Acc = New Account();
        acc.Name = 'Air indigo';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.RAI_Excluded__c = TRUE;
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        Insert acc;
        
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',External_Account_ID__c='300669',XREF_Type__c = 'SAP_SOLD_TO',Account_Name__c=acc.id,Site_Code__c='765');
        insert acref; 
        
        contact c = New contact();
        C.firstname = 'Test';
        C.LastName = 'Contact';
        C.Primary_Email_Address__c = 'test@gmail.com'; 
        C.AccountId = acc.id;
        C.Honeywell_ID__c = 'H147664';
        insert C;
       
        Apttus_Config2__ClassificationName__c classif = new Apttus_Config2__ClassificationName__c();
        classif.name = 'TestClassification1';
        classif.Apttus_Config2__HierarchyLabel__c = 'TestClassification1';
        classif.Required_For_Portal__c = true;
        classif.Apttus_Config2__Type__c = 'Offering';
        insert classif;
        Apttus_Config2__ClassificationHierarchy__c clashir = new Apttus_Config2__ClassificationHierarchy__c();
        clashir.Apttus_Config2__HierarchyId__c=classif.id;
        clashir.Name='Navigational Data';
        clashir.Apttus_Config2__Label__c='Navigational Data';
        insert clashir;
        //Creating Standalone product
        product2 prod1 = new product2();
        prod1.Name = 'test1'; 
        prod1.IsActive = true;   
        prod1.Apttus_Config2__ConfigurationType__c = 'Standalone'; 
        prod1.family = 'Nav Database';
        prod1.License_Type__c='APU';
        prod1.Is_License_Required__c=true;
        prod1.Term__c= 'Indefinite';
        insert prod1;
        
        Apttus_Config2__ProductOptionGroup__c pog = new Apttus_Config2__ProductOptionGroup__c();
        pog.Apttus_Config2__Sequence__c =0;
        pog.Apttus_Config2__ProductId__c=prod1.id;
        pog.Apttus_Config2__OptionGroupId__c=clashir.id; 
        insert pog;
        //subproducts
        Apttus_Config2__ProductOptionComponent__c cpog= new Apttus_Config2__ProductOptionComponent__c();
        cpog.Apttus_Config2__ProductOptionGroupId__c=pog.id;
        cpog.Apttus_Config2__ComponentProductId__c=prod1.id;
        cpog.Apttus_Config2__Sequence__c=2;
        insert cpog;
        
        Apttus_Config2__PriceList__c Pricelist =  New Apttus_Config2__PriceList__c();
        Pricelist.Name = 'Aspire PriceList';
        Insert Pricelist;
        
                
        Apttus_Config2__Order__c objOrder= new Apttus_Config2__Order__c();
        objOrder.Apttus_Config2__Type__c='New';
        objOrder.CurrencyIsoCode='EUR';
        objOrder.Apttus_Config2__SoldToAccountId__c = Acc.id;
        objOrder.Apttus_Config2__PODate__c=system.today();
        objOrder.Apttus_Config2__PONumber__c='1234';
        objOrder.Apttus_Config2__PriceListId__c = Pricelist.id;
        insert objOrder;
        
                
        Apttus_Config2__ProductConfiguration__c config = new Apttus_Config2__ProductConfiguration__c(
            Apttus_Config2__ContractNumbers__c = '0',
            Apttus_Config2__BusinessObjectRefId__c = objOrder.id
        );
        insert config;
        
    Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(
        CurrencyIsoCode = 'USD',
        Apttus_Config2__ProductId__c = prod1.id,
        Apttus_Config2__ConfigurationId__c = config.id,
        Apttus_Config2__Description__c = 'TEST Line Item',
        Apttus_Config2__NetPrice__c = 100,
        Apttus_Config2__BasePrice__c = 200,
        Apttus_Config2__ItemSequence__c = 1,
        Apttus_Config2__LineNumber__c = 1
        );
        insert lineItem; 
        
        Apttus_Config2__OrderLineItem__c Orderli = New Apttus_Config2__OrderLineItem__c();
        Orderli.Apttus_Config2__ProductId__c = prod1.id;
        Orderli.Apttus_Config2__OptionId__c = prod1.id;
        Orderli.Apttus_Config2__OrderId__c = objOrder.id;
        Orderli.License_Required_and_Linked__c= 'No';
        Orderli.Apttus_Config2__LineType__c='Option';
         
        Insert Orderli;
        
        CPQ_Platform__c Cpq = New CPQ_Platform__c();
        Cpq.Line_Item__c = lineItem.id;
        cpq.Name = '243643';
        cpq.Order_Line_Item__c = Orderli.id;
        cpq.License_Status__c= 'Activation Key-Created';
        cpq.Type__c='test';
        Insert cpq; 
        
        CPQ_Email__c  Cemaill = New CPQ_Email__c();
        Cemaill.Name = 'karanatakam.ganguraju@honeywell.com';
        Cemaill.Order__C = objOrder.id;
        
        Insert Cemaill;
        
        CPQ.License_Status__c= 'Activation Key-Linked';
        update CPQ;
        
        Orderli.License_Required_and_Linked__c= 'yes';
        Update Orderli;
        
        objOrder.Count_of_License_Status_Yes__c = 1;
        objOrder.Count_of_License_Status_No__c  = 0;
        objOrder.Licence_Key_Linked__c = True; 
        Update objOrder;
        
      
        String json='{'+
       
        '}';
         
        RestRequest request = new RestRequest();
        request.requestUri = 'services/apexrest/orders/'+objOrder.id+'/cart/'+objOrder.id+'/invoice/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        FinalizeCartRestResource.finalizeCart();
       
        
        RestRequest request1 = new RestRequest();
        request1.requestUri =  'services/apexrest/orders/'+config.id+'/cart/'+config.id+'/invoice/';
        request1.httpMethod = 'POST';
        request1.addHeader('Content-Type', 'application/json');
        request1.requestBody = Blob.valueOf(json);
        RestContext.request = request1;
        RestResponse response1 = new RestResponse();
        RestContext.response = response1;
        system.debug('response'+response);
        FinalizeCartRestResource.finalizeCart();
        test.stoptest();
        
         RestRequest request2 = new RestRequest();
        request2.requestUri = 'services/apexrest/orders/'+objOrder.id+'/cart/'+config.id+'/invoice/';
        request2.httpMethod = 'POST';
        //request.addParameter('input-type', 'PID');
        request2.addHeader('Content-Type', 'application/json');
        request2.requestBody = Blob.valueOf(json);
        RestContext.request = request2;
        RestResponse response2 = new RestResponse();
        RestContext.response = response2;
        system.debug('response'+response2);
        FinalizeCartRestResource.finalizeCart();
    }
    @isTest 
    static void finalizeCartTest1(){
        test.startTest();
        Account Acc = New Account();
        acc.Name = 'Air indigo';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.RAI_Excluded__c = TRUE;
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        acc.Apttus_Config2__DefaultInvoiceStatementTemplate__c = 'Blank Statment';
        acc.Apttus_Config2__DefaultInvoiceTemplate__c = 'FE Credit Memo 1000 (USD)';
        Insert acc;
        
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',External_Account_ID__c='300669',XREF_Type__c = 'SAP_SOLD_TO',Account_Name__c=acc.id,Site_Code__c='765');
        insert acref; 
        
        contact c = New contact();
        C.firstname = 'Test';
        C.LastName = 'Contact';
        C.Primary_Email_Address__c = 'test@gmail.com'; 
        C.AccountId = acc.id;
        C.Honeywell_ID__c = 'H147664';
        insert C;
       
        Apttus_Config2__ClassificationName__c classif = new Apttus_Config2__ClassificationName__c();
        classif.name = 'TestClassification1';
        classif.Apttus_Config2__HierarchyLabel__c = 'TestClassification1';
        classif.Required_For_Portal__c = true;
        classif.Apttus_Config2__Type__c = 'Offering';
        insert classif;
        
        Apttus_Config2__ClassificationHierarchy__c clashir = new Apttus_Config2__ClassificationHierarchy__c();
        clashir.Apttus_Config2__HierarchyId__c=classif.id;
        clashir.Name='APU';
        clashir.Apttus_Config2__Label__c='APU';
        insert clashir;
        
        //Creating Standalone product
        product2 prod1 = new product2();
        prod1.Name = 'test1'; 
        prod1.IsActive = true;   
        prod1.Apttus_Config2__ConfigurationType__c = 'Standalone'; 
        prod1.family = 'APU_SW_KEYS';
        prod1.License_Type__c='APU';
        prod1.Is_License_Required__c=true;
        prod1.Term__c= 'Indefinite';
        insert prod1;
        
        Apttus_Config2__ProductOptionGroup__c pog = new Apttus_Config2__ProductOptionGroup__c();
        pog.Apttus_Config2__Sequence__c =0;
        pog.Apttus_Config2__ProductId__c=prod1.id;
        pog.Apttus_Config2__OptionGroupId__c=clashir.id; 
        insert pog;
        //subproducts
        Apttus_Config2__ProductOptionComponent__c cpog= new Apttus_Config2__ProductOptionComponent__c();
        cpog.Apttus_Config2__ProductOptionGroupId__c=pog.id;
        cpog.Apttus_Config2__ComponentProductId__c=prod1.id;
        cpog.Apttus_Config2__Sequence__c=2;
        insert cpog;
        
        Apttus_Config2__PriceList__c Pricelist =  New Apttus_Config2__PriceList__c();
        Pricelist.Name = 'Aspire PriceList';
        Insert Pricelist;
        
        Apttus_Config2__PriceListItem__c pli = new Apttus_Config2__PriceListItem__c(
                Apttus_Config2__ProductId__c = prod1.Id,
                Apttus_Config2__PriceListId__c = priceList.Id,
                Apttus_Config2__ChargeType__c = 'Standard Price',
                Apttus_Config2__PriceType__c = 'One Time',
                Apttus_Config2__PriceUom__c = 'Each',
                Apttus_Config2__ListPrice__c = 1000,
                Apttus_Config2__PriceMethod__c = 'Per Unit',
                Apttus_Config2__Active__c = true,
                Apttus_Config2__Frequency__c = 'Monthly');

        Insert Pli;
                
        Apttus_Config2__Order__c objOrder= new Apttus_Config2__Order__c();
        objOrder.Apttus_Config2__Type__c='New';
        objOrder.CurrencyIsoCode='EUR';
        objOrder.Apttus_Config2__SoldToAccountId__c = Acc.id;
        objOrder.Apttus_Config2__PODate__c=system.today();
        objOrder.Apttus_Config2__PONumber__c='1234';
        objOrder.Apttus_Config2__PriceListId__c = Pricelist.id;
        objOrder.Apttus_Config2__ShipToAccountId__c = Acc.id; 
        objOrder.Apttus_Config2__ReadyForBillingDate__c=system.today();
        objOrder.Apttus_Config2__BillToAccountId__c = Acc.id; 
        objOrder.Apttus_Config2__AutoActivateOrder__c = True;
        objOrder.Apttus_Config2__ActivatedDate__c =system.today();
        objOrder.AspireInvoice_Created__c = false;
        insert objOrder;
        
                
        Apttus_Config2__ProductConfiguration__c config = new Apttus_Config2__ProductConfiguration__c(
            Apttus_Config2__ContractNumbers__c = '0',
            Apttus_Config2__BusinessObjectRefId__c = objOrder.id
        );
        insert config;
        
    Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(
        CurrencyIsoCode = 'USD',
        Apttus_Config2__ProductId__c = prod1.id,
        Apttus_Config2__ConfigurationId__c = config.id,
        Apttus_Config2__Description__c = 'TEST Line Item',
        Apttus_Config2__NetPrice__c = 100,
        Apttus_Config2__BasePrice__c = 200,
        Apttus_Config2__ItemSequence__c = 1,
        Apttus_Config2__LineNumber__c = 1
        );
        insert lineItem; 
        
               
        Apttus_Config2__OrderLineItem__c Orderli = New Apttus_Config2__OrderLineItem__c();
        Orderli.Apttus_Config2__ProductId__c = prod1.id;
        Orderli.Apttus_Config2__OptionId__c = prod1.id;
        Orderli.Apttus_Config2__OrderId__c = objOrder.id;
        Orderli.License_Required_and_Linked__c= 'No';
        Orderli.Apttus_Config2__LineType__c='Option';
        OrderLi.Apttus_Config2__DerivedFromId__c = lineItem.id;
       // orderli.Apttus_Config2__AssetLineItemId__c = assetLineItem.id;
        Insert Orderli;
        
        CPQ_Platform__c Cpq = New CPQ_Platform__c();
        Cpq.Line_Item__c = lineItem.id;
        cpq.Name = '243643';
        cpq.Order_Line_Item__c = Orderli.id;
        cpq.License_Status__c= 'Activation Key-Created';
        cpq.Type__c='test';
        Insert cpq; 
        
        CPQ_Email__c  Cemaill = New CPQ_Email__c();
        Cemaill.Name = 'karanatakam.ganguraju@honeywell.com';
        Cemaill.Order__C = objOrder.id;
        
        Insert Cemaill;
        
        CPQ.License_Status__c= 'Activation Key-Linked';
        update CPQ;
        
        Orderli.License_Required_and_Linked__c= 'yes';
        Update Orderli;
        
        objOrder.Count_of_License_Status_Yes__c = 1;
        objOrder.Count_of_License_Status_No__c  = 0;
        objOrder.Licence_Key_Linked__c = True; 
        Update objOrder;
        
        Apttus_Config2__OrderLineItem__c ol = [Select id,Apttus_Config2__AssetLineItemId__c,Apttus_Config2__DerivedFromId__c from Apttus_Config2__OrderLineItem__c where id =:Orderli.id];
        System.debug('ol'+ol);       
      Apttus_Config2__AssetLineItem__c assetLineItem = new Apttus_Config2__AssetLineItem__c();
      assetLineItem.APTS_External_Id__c = '123';
      assetLineItem.Name = 'Test';
      assetLineItem.APTS_External_Source__c = 'JIRA';
      assetLineItem.Apttus_Config2__ProductId__c = prod1.id;  
      assetLineItem.Apttus_Config2__OptionId__c=prod1.id;
       assetLineItem.Apttus_Config2__AdjustedPrice__c = 10;
       assetLineItem.Apttus_Config2__AssetCode__c = 'Test';
        assetLineItem.Apttus_Config2__AssetStatus__c = 'Activated';
        assetLineItem.Apttus_Config2__BasePrice__c = 10;
        assetLineItem.Apttus_Config2__BillingFrequency__c = 'Monthly';
        assetLineItem.Apttus_Config2__BillToAccountId__c = acc.ID;
        assetLineItem.Apttus_Config2__BusinessObjectId__c = acc.ID;
        assetLineItem.Apttus_Config2__AccountId__c = acc.ID;
        assetLineItem.Apttus_Config2__BusinessObjectType__c = 'Account';
        assetLineItem.Apttus_Config2__EndDate__c = Date.today().addMonths(12);
        assetLineItem.Apttus_Config2__ExtendedPrice__c = 10;
        assetLineItem.Apttus_Config2__IsPrimaryLine__c = true;
        assetLineItem.Apttus_Config2__ItemSequence__c = 1;
        assetLineItem.Apttus_Config2__LineNumber__c = 1;
        assetLineItem.Apttus_Config2__LineType__c = 'Product/Service';
        assetLineItem.Apttus_Config2__ListPrice__c = 10;
        assetLineItem.Apttus_Config2__NetPrice__c = 10;
        assetLineItem.Apttus_Config2__NetUnitPrice__c = 10;
        assetLineItem.Apttus_Config2__PriceMethod__c = 'Per Unit';
        assetLineItem.Apttus_Config2__PriceType__c = 'Recurring';
        assetLineItem.Apttus_Config2__Frequency__c = 'Monthly';
        assetLineItem.Apttus_Config2__Term__c = 12;
        assetLineItem.Apttus_Config2__PrimaryLineNumber__c = 1;
        assetLineItem.Apttus_Config2__Quantity__c = 1;
        assetLineItem.Apttus_Config2__SellingFrequency__c = 'Monthly';
        assetLineItem.Apttus_Config2__SellingTerm__c = 12;
        assetLineItem.Apttus_Config2__ShipToAccountId__c = acc.ID;
        assetLineItem.Apttus_Config2__StartDate__c = Date.today();  
        assetLineItem.Apttus_Config2__ParentAssetId__c = null;
        assetLineItem.Apttus_Config2__PriceListItemId__c = pli.id;
        assetLineItem.Apttus_Config2__PriceListId__c = priceList.Id;
        assetLineItem.Apttus_Config2__IsPrimaryLine__c = true;
        assetLineItem.Apttus_Config2__AssetStatus__c = 'Activated';
        assetLineItem.Apttus_Config2__EndDate__c = Date.today();
       
       insert assetLineItem; 
       update assetLineItem;
        System.debug('ol'+ol);
        System.debug('assetLineItem'+assetLineItem);
        orderli.Apttus_Config2__AssetLineItemId__c = assetLineItem.id;
        update Orderli; 
       System.debug('ol'+ol);
        Apttus_Billing__BillingSchedule__c billingSchedule = new Apttus_Billing__BillingSchedule__c();
        billingSchedule.Apttus_Billing__OrderLineItemId__c= Orderli.Id;
        BillingSchedule.Apttus_Billing__AssetLineItemId__c = assetLineItem.id;
        insert billingSchedule;
        
         Apttus_Billing__Invoice__c invoice = new Apttus_Billing__Invoice__c(
            Apttus_Billing__Status__c = 'Draft'
        );
        insert invoice; 
       
        Apttus_Billing__InvoiceLineItem__c invoiceLineItem = new Apttus_Billing__InvoiceLineItem__c(
          Apttus_Billing__InvoiceId__c = invoice.id,
            Apttus_Billing__BillingScheduleId__c = billingSchedule.id
        );
        insert invoiceLineItem;
        
        objOrder.AspireInvoice_Created__c = true;
        objOrder.Aspire_InvoiceId__c = invoice.id;
        update objOrder;
        
        invoice.APTS_Integration_Status__c = 'To be Processed';
        update invoice;
        
        String json='{'+
       
        '}';
        RestRequest request = new RestRequest();
        request.requestUri = 'services/apexrest/orders/'+objOrder.id+'/cart/'+config.id+'/invoice/';
        request.httpMethod = 'POST';
        //request.addParameter('input-type', 'PID');
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        FinalizeCartRestResource.finalizeCart();
        test.stoptest();
    }
    
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
                  
        Apttus_Config2__ProductConfiguration__c config = new Apttus_Config2__ProductConfiguration__c(
            Apttus_Config2__ContractNumbers__c = '0',
            Apttus_Config2__BusinessObjectRefId__c = objOrder.id
        );
        insert config;
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
        
        
         String json='{'+
       
        '}';
         RestRequest request2 = new RestRequest();
        request2.requestUri = 'services/apexrest/orders/'+objOrder.id+'/cart/'+config.id+'/invoice/';
        request2.httpMethod = 'POST';
        //request.addParameter('input-type', 'PID');
        request2.addHeader('Content-Type', 'application/json');
        request2.requestBody = Blob.valueOf(json);
        RestContext.request = request2;
        RestResponse response2 = new RestResponse();
        RestContext.response = response2;
        system.debug('response'+response2);
        FinalizeCartRestResource.finalizeCart();
    
  }
  
   
  
  }