@isTest
public class CreateOrderRestResourceTest{
    @isTest static void testcreateOrderHeader() {
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
        
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',
        External_Account_ID__c='300669',
        XREF_Type__c = 'SAP_SOLD_TO',
        Account_Name__c=acc.id,
        Site_Code__c='765');
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
        Prod1.ProductCode = '131-9HEM';  
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
        
         
        Apttus_Config2__PaymentTerm__c Paymentterm = New Apttus_Config2__PaymentTerm__c();
        Paymentterm.Name= 'Net30';
        Paymentterm.Apttus_Config2__Sequence__c = 1;
        Paymentterm.APTS_External_Id__c = 'C003';
        Insert Paymentterm;
        
         APTS_Aspire_Order__c cso = new APTS_Aspire_Order__c();
        cso.name = 'Portal_To_Apttus';
        cso.Price_List_Id__c = Pricelist.id;
        cso.Payment_Terms_Id__c = Paymentterm.id;
        APTS_Aspire_Order__c cso2 = new APTS_Aspire_Order__c();
        cso2.name = 'Portal_To_Apttus';
        cso2.Price_List_Id__c = Pricelist.id;
        cso2.Payment_Terms_Id__c = Paymentterm.id;
        insert cso;
        insert cso2;
       
                
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
        
        attachment att=new attachment();
        att.parentId = objOrder.Id;
        att.name = 'File Name.pdf'; 
        att.ContentType = 'PDF'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob; 
       
       // Insert att;     
           
    Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(
        CurrencyIsoCode = 'USD',
        Apttus_Config2__ProductId__c = prod1.id,
        Apttus_Config2__ConfigurationId__c = config.id,
        Apttus_Config2__Description__c = 'TEST Line Item',
        Apttus_Config2__NetPrice__c = 100,
        Apttus_Config2__BasePrice__c = 200,
        Apttus_Config2__ItemSequence__c = 1,
        Apttus_Config2__LineNumber__c = 1,
        Apttus_Config2__OptionId__c = prod1.id,
        Apttus_Config2__PrimaryLineNumber__c = 2
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
            '    "soldTo": "300669",'+
            '    "shipTo": "300669",'+
            '    "billTo": "300669",'+
            '    "origin": "Portal_To_Apttus",'+
            '    "userid": "H147664",'+
            '    "deliveryNo": "H147664",'+
            '    "paymentTerm": "C003",'+
            '    "emailIds": ['+
            '        "test@gmail.com",'+
            '        "trtr@gmail.com"'+
            '    ],'+
             /*  '    "purchaseOrder": {'+  
            '        "poNumber": "12345",'+
            '        "poDate": "20072020",'+
            '        "poDocument": "poDocument",'+
            '        "poFileName": "fileName.pdf",'+
            '        "poContentType": "pdf",'+  
            '    },'+ */
            '    "creditCard": {'+
            '        "cardType": "test",'+
            '        "cardToken": "-E803-4003-0Q046ZKQDFDFD4V",'+
            '        "validTo": "21072020",'+
            '        "cardHolderName": "Test stalingsfdca test"'+
            '    },'+
            '    "shipToAddr": {'+
            '        "name": "test",'+
            '        "street": "tets street",'+
            '        "city": "bangalore",'+
            '        "region": "KA",'+
            '        "country": "INDIA",'+
            '        "zip": "560036"'+
            '    },'+
            '    "soldToAddr": {'+
            '        "name": "test",'+
            '        "street": "tets street",'+
            '        "city": "bangalore",'+
            '        "region": "KA",'+
            '        "country": "INDIA",'+
            '        "zip": "560036"'+
            '    },'+
            '    "billToAddr": {'+
            '        "name": "test",'+
            '        "street": "tets street",'+
            '        "city": "bangalore",'+
            '        "region": "KA",'+
            '        "country": "INDIA",'+
            '        "zip": "560036"'+
            '    }'+
            '}';
            
        RestRequest request = new RestRequest();
        request.requestUri ='https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/ngbss/orders';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        // Update status of existing record to Working
       CreateOrderRestResource.checkValidEmail('test@gmail.com');
        CreateOrderRestResource.createOrderHeader();
        // Verify record was updated
        //System.assert(thisorderId != null);
        test.stopTest();
        
    }
     @isTest static void testcreateOrderHeader1() {
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
        
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',
        External_Account_ID__c='300669',
        XREF_Type__c = 'SAP_SOLD_TO',
        Account_Name__c=acc.id,
        Site_Code__c='765');
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
        Prod1.ProductCode = '131-9HEM';  
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
        
         
        Apttus_Config2__PaymentTerm__c Paymentterm = New Apttus_Config2__PaymentTerm__c();
        Paymentterm.Name= 'Net30';
        Paymentterm.Apttus_Config2__Sequence__c = 1;
        Paymentterm.APTS_External_Id__c = 'C003';
        Insert Paymentterm;
        
         APTS_Aspire_Order__c cso = new APTS_Aspire_Order__c();
        cso.name = 'Portal_To_Apttus';
        cso.Price_List_Id__c = Pricelist.id;
        cso.Payment_Terms_Id__c = Paymentterm.id;
        APTS_Aspire_Order__c cso2 = new APTS_Aspire_Order__c();
        cso2.name = 'SAP_To_Apttus';
        cso2.Price_List_Id__c = Pricelist.id;
        cso2.Payment_Terms_Id__c = Paymentterm.id;
        insert cso;
        insert cso2;
       
                
        Apttus_Config2__Order__c objOrder= new Apttus_Config2__Order__c();
        objOrder.Apttus_Config2__Type__c='New';
        objOrder.CurrencyIsoCode='EUR';
        objOrder.Apttus_Config2__SoldToAccountId__c = Acc.id;
        objOrder.Apttus_Config2__PODate__c=system.today();
        objOrder.Apttus_Config2__PONumber__c='1234';
        objOrder.Apttus_Config2__PriceListId__c = Pricelist.id;
        objOrder.Send_INV_To_SAP__c = false;
        objOrder.SoldTo_Number__c  = '300669';
        objOrder.SoldTo_SAP_Account_Name__c = 'test';
        objOrder.Sold_To_Street__c = 'tets street';
        objOrder.Sold_To_City__c =  'bangalore';
        objOrder.Sold_To_State__c =  'KA';
        objOrder.Sold_To_Country__c =  'INDIA';
        objOrder.Sold_To_Postal_Code__c =  '560036';
        objOrder.Generic_xref_SoldTo__c = true;
                
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
        Apttus_Config2__LineNumber__c = 1,
        Apttus_Config2__OptionId__c = prod1.id,
        Apttus_Config2__PrimaryLineNumber__c = 2
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
        
         attachment att=new attachment();
        att.parentId = objOrder.Id;
        att.name = 'File Name.Doc'; 
        att.ContentType = 'Doc'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob; 
       try{
       Insert att;
       }
       Catch(Exception Ex)
       {
       
       }  
        
         String json='{'+
            '    "soldTo": "300669",'+
            '    "shipTo": "300669",'+
            '    "billTo": "300669",'+
            '    "origin": "SAP_To_Apttus",'+
            '    "userid": "H147664",'+
            '    "deliveryNo": "H147664",'+
            '    "paymentTerm": "",'+
            '    "emailIds": ['+
            '        "test@gmail.com",'+
            '        "trtr@gmail.com"'+
            '    ],'+
            '    "purchaseOrder": {'+  
            '    },'+ 
            '    "creditCard": {'+
            '        "cardType": "test",'+
            '        "cardToken": "-E803-4003-0Q046ZKQDFDFD4V",'+
            '        "validTo": "21072020",'+
            '        "cardHolderName": "Test stalingsfdca test"'+
            '    },'+
            '    "shipToAddr": {'+
            '        "name": "test",'+
            '        "street": "tets street",'+
            '        "city": "bangalore",'+
            '        "region": "KA",'+
            '        "country": "INDIA",'+
            '        "zip": "560036"'+
            '    },'+
            '    "soldToAddr": {'+
            '        "name": "test",'+
            '        "street": "tets street",'+
            '        "city": "bangalore",'+
            '        "region": "KA",'+
            '        "country": "INDIA",'+
            '        "zip": "560036"'+
            '    },'+
            '    "billToAddr": {'+
            '        "name": "test",'+
            '        "street": "tets street",'+
            '        "city": "bangalore",'+
            '        "region": "KA",'+
            '        "country": "INDIA",'+
            '        "zip": "560036"'+
            '    }'+
            '}';
            
        RestRequest request = new RestRequest();
        request.requestUri ='https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/ngbss/orders';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        // Update status of existing record to Working
       CreateOrderRestResource.checkValidEmail('test@gmail.com');
        CreateOrderRestResource.createOrderHeader();
        // Verify record was updated
        //System.assert(thisorderId != null);
        test.stopTest();
        
    }
    @isTest static void testcreateOrderHeader2() {
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
        
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',
        External_Account_ID__c='300669',
        XREF_Type__c = 'SAP_SOLD_TO',
        Account_Name__c=acc.id,
        Site_Code__c='765');
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
        Prod1.ProductCode = '131-9HEM';  
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
        
         
        Apttus_Config2__PaymentTerm__c Paymentterm = New Apttus_Config2__PaymentTerm__c();
        Paymentterm.Name= 'Net30';
        Paymentterm.Apttus_Config2__Sequence__c = 1;
        Paymentterm.APTS_External_Id__c = 'C003';
        Insert Paymentterm;
        
         APTS_Aspire_Order__c cso = new APTS_Aspire_Order__c();
        cso.name = 'Portal_To_Apttus';
        cso.Price_List_Id__c = Pricelist.id;
        cso.Payment_Terms_Id__c = Paymentterm.id;
        APTS_Aspire_Order__c cso2 = new APTS_Aspire_Order__c();
        cso2.name = 'SAP_To_Apttus';
        cso2.Price_List_Id__c = Pricelist.id;
        cso2.Payment_Terms_Id__c = Paymentterm.id;
        insert cso;
        insert cso2;
       
                
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
        
        attachment att=new attachment();
        att.parentId = objOrder.Id;
        att.name = 'File Name.pdf'; 
        att.ContentType = 'PDF'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob; 
       
       // Insert att;     
           
    Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(
        CurrencyIsoCode = 'USD',
        Apttus_Config2__ProductId__c = prod1.id,
        Apttus_Config2__ConfigurationId__c = config.id,
        Apttus_Config2__Description__c = 'TEST Line Item',
        Apttus_Config2__NetPrice__c = 100,
        Apttus_Config2__BasePrice__c = 200,
        Apttus_Config2__ItemSequence__c = 1,
        Apttus_Config2__LineNumber__c = 1,
        Apttus_Config2__OptionId__c = prod1.id,
        Apttus_Config2__PrimaryLineNumber__c = 2
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
            '    "soldTo": "",'+
            '    "shipTo": "",'+
            '    "billTo": "",'+
            '    "origin": "SAP_To_Apttus",'+
            '    "userid": "H147664",'+
            '    "deliveryNo": "12345",'+
            '    "paymentTerm": "",'+
            '    "emailIds": ['+
           
            '    ],'+
             '    "purchaseOrder": {'+  
          
            '    },'+ 
            '    "creditCard": {'+
            '        "cardType": "test",'+
            '        "cardToken": "-E803-4003-0Q046ZKQDFDFD4V",'+
            '        "validTo": "21072020",'+
            '        "cardHolderName": "Test stalingsfdca test"'+
            '    },'+
            '    "shipToAddr": {'+
            
            '    },'+
            '    "soldToAddr": {'+
           
            '    },'+
            '    "billToAddr": {'+
           
            '    }'+
            '}';
            
        RestRequest request = new RestRequest();
        request.requestUri ='https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/ngbss/orders';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        // Update status of existing record to Working
       CreateOrderRestResource.checkValidEmail('test@gmail.com');
        CreateOrderRestResource.createOrderHeader();
        // Verify record was updated
        //System.assert(thisorderId != null);
        test.stopTest();
        
    }
    
     @isTest static void testcreateOrderHeader3() {
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
        
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',
        External_Account_ID__c='300669',
        XREF_Type__c = 'SAP_SOLD_TO',
        Account_Name__c=acc.id,
        Site_Code__c='765');
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
        Prod1.ProductCode = '131-9HEM';  
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
        
         
        Apttus_Config2__PaymentTerm__c Paymentterm = New Apttus_Config2__PaymentTerm__c();
        Paymentterm.Name= 'Net30';
        Paymentterm.Apttus_Config2__Sequence__c = 1;
        Paymentterm.APTS_External_Id__c = 'C003';
        Insert Paymentterm;
        
         APTS_Aspire_Order__c cso = new APTS_Aspire_Order__c();
        cso.name = 'Portal_To_Apttus';
        cso.Price_List_Id__c = Pricelist.id;
        cso.Payment_Terms_Id__c = Paymentterm.id;
        APTS_Aspire_Order__c cso2 = new APTS_Aspire_Order__c();
        cso2.name = 'SAP_To_Apttus';
        cso2.Price_List_Id__c = Pricelist.id;
        cso2.Payment_Terms_Id__c = Paymentterm.id;
        insert cso;
        insert cso2;
       
                
        Apttus_Config2__Order__c objOrder= new Apttus_Config2__Order__c();
        objOrder.Apttus_Config2__Type__c='New';
        objOrder.CurrencyIsoCode='EUR';
        objOrder.Apttus_Config2__SoldToAccountId__c = Acc.id;
        objOrder.Apttus_Config2__PODate__c=system.today();
        objOrder.Apttus_Config2__PONumber__c='1234';
        objOrder.Apttus_Config2__PriceListId__c = Pricelist.id;
        objOrder.SoldTo_Number__c  = '3006691';
        objOrder.SoldTo_SAP_Account_Name__c = 'test';
        objOrder.Sold_To_Street__c = 'tets street';
        objOrder.Sold_To_City__c =  'bangalore';
        objOrder.Sold_To_State__c =  'KA';
        objOrder.Sold_To_Country__c =  'INDIA';
        objOrder.Sold_To_Postal_Code__c =  '560036';
        objOrder.Generic_xref_SoldTo__c = true;
                
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
        Apttus_Config2__LineNumber__c = 1,
        Apttus_Config2__OptionId__c = prod1.id,
        Apttus_Config2__PrimaryLineNumber__c = 2
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
        
         attachment att=new attachment();
        att.parentId = objOrder.Id;
        att.name = 'File Name.Doc'; 
        att.ContentType = 'Doc'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob; 
       try{
       Insert att;
       }
       Catch(Exception Ex)
       {
       
       }  
        
         String json='{'+
            '    "soldTo": "3006691",'+
            '    "shipTo": "3006691",'+
            '    "billTo": "3006691",'+
            '    "origin": "SAP_To_Apttus",'+
            '    "userid": "H147664",'+
            '    "deliveryNo": "H147664",'+
            '    "paymentTerm": "C003",'+
            '    "emailIds": ['+
            '        "test@gmail.com",'+
            '        "trtr@gmail.com"'+
            '    ],'+
            '    "purchaseOrder": {'+  
            '    },'+ 
            '    "creditCard": {'+
            '        "cardType": "test",'+
            '        "cardToken": "-E803-4003-0Q046ZKQDFDFD4V",'+
            '        "validTo": "21072020",'+
            '        "cardHolderName": "Test stalingsfdca test"'+
            '    },'+
            '    "shipToAddr": {'+
            '        "name": "test",'+
            '        "street": "tets street",'+
            '        "city": "bangalore",'+
            '        "region": "KA",'+
            '        "country": "INDIA",'+
            '        "zip": "560036"'+
            '    },'+
            '    "soldToAddr": {'+
            '        "name": "test",'+
            '        "street": "tets street",'+
            '        "city": "bangalore",'+
            '        "region": "KA",'+
            '        "country": "INDIA",'+
            '        "zip": "560036"'+
            '    },'+
            '    "billToAddr": {'+
            '        "name": "test",'+
            '        "street": "tets street",'+
            '        "city": "bangalore",'+
            '        "region": "KA",'+
            '        "country": "INDIA",'+
            '        "zip": "560036"'+
            '    }'+
            '}';
            
        RestRequest request = new RestRequest();
        request.requestUri ='https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/ngbss/orders';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        // Update status of existing record to Working
       CreateOrderRestResource.checkValidEmail('test');
        CreateOrderRestResource.createOrderHeader();
        // Verify record was updated
        //System.assert(thisorderId != null);
        test.stopTest();
        
    } 
    @isTest static void testcreateOrderHeader4() {
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
        
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',
        External_Account_ID__c='300669',
        XREF_Type__c = 'SAP_SOLD_TO',
        Account_Name__c=acc.id,
        Site_Code__c='765');
        insert acref; 
        Account_Cross_Ref__c acref1= new Account_Cross_Ref__c(name='test',
        External_Account_ID__c='300669',
        XREF_Type__c = 'SAP_SOLD_TO',
        Account_Name__c=acc.id,
        Site_Code__c='765');
        insert acref1; 
        
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
        Prod1.ProductCode = '131-9HEM';  
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
        
         
        Apttus_Config2__PaymentTerm__c Paymentterm = New Apttus_Config2__PaymentTerm__c();
        Paymentterm.Name= 'Net30';
        Paymentterm.Apttus_Config2__Sequence__c = 1;
        Paymentterm.APTS_External_Id__c = 'C003';
        Insert Paymentterm;
        
         APTS_Aspire_Order__c cso = new APTS_Aspire_Order__c();
        cso.name = 'Portal_To_Apttus';
        cso.Price_List_Id__c = Pricelist.id;
        cso.Payment_Terms_Id__c = Paymentterm.id;
        APTS_Aspire_Order__c cso2 = new APTS_Aspire_Order__c();
        cso2.name = 'SAP_To_Apttus';
        cso2.Price_List_Id__c = Pricelist.id;
        cso2.Payment_Terms_Id__c = Paymentterm.id;
        insert cso;
        insert cso2;
       
                
        Apttus_Config2__Order__c objOrder= new Apttus_Config2__Order__c();
        objOrder.Apttus_Config2__Type__c='New';
        objOrder.CurrencyIsoCode='EUR';
        objOrder.Apttus_Config2__SoldToAccountId__c = Acc.id;
        objOrder.Apttus_Config2__PODate__c=system.today();
        objOrder.Apttus_Config2__PONumber__c='1234';
        objOrder.Apttus_Config2__PriceListId__c = Pricelist.id;
        objOrder.Send_INV_To_SAP__c = false;
        objOrder.SoldTo_Number__c  = '300669';
        objOrder.SoldTo_SAP_Account_Name__c = 'test';
        objOrder.Sold_To_Street__c = 'tets street';
        objOrder.Sold_To_City__c =  'bangalore';
        objOrder.Sold_To_State__c =  'KA';
        objOrder.Sold_To_Country__c =  'INDIA';
        objOrder.Sold_To_Postal_Code__c =  '560036';
        objOrder.Generic_xref_SoldTo__c = true;
                
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
        Apttus_Config2__LineNumber__c = 1,
        Apttus_Config2__OptionId__c = prod1.id,
        Apttus_Config2__PrimaryLineNumber__c = 2
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
        
         attachment att=new attachment();
        att.parentId = objOrder.Id;
        att.name = 'File Name.Doc'; 
        att.ContentType = 'Doc'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob; 
       try{
       Insert att;
       }
       Catch(Exception Ex)
       {
       
       }  
        
         String json='{'+
            '    "soldTo": "300669",'+
            '    "shipTo": "300669",'+
            '    "billTo": "300669",'+
            '    "origin": "SAP_To_Apttus",'+
            '    "userid": "H147664",'+
            '    "deliveryNo": "H147664",'+
            '    "paymentTerm": "",'+
            '    "emailIds": ['+
            '        "test@gmail.com",'+
            '        "trtr@gmail.com"'+
            '    ],'+
            '    "purchaseOrder": {'+  
            '    },'+ 
            '    "creditCard": {'+
            '        "cardType": "test",'+
            '        "cardToken": "-E803-4003-0Q046ZKQDFDFD4V",'+
            '        "validTo": "21072020",'+
            '        "cardHolderName": "Test stalingsfdca test"'+
            '    },'+
            '    "shipToAddr": {'+
            '        "name": "test",'+
            '        "street": "tets street",'+
            '        "city": "bangalore",'+
            '        "region": "KA",'+
            '        "country": "INDIA",'+
            '        "zip": "560036"'+
            '    },'+
            '    "soldToAddr": {'+
            '        "name": "test",'+
            '        "street": "tets street",'+
            '        "city": "bangalore",'+
            '        "region": "KA",'+
            '        "country": "INDIA",'+
            '        "zip": "560036"'+
            '    },'+
            '    "billToAddr": {'+
            '        "name": "test",'+
            '        "street": "tets street",'+
            '        "city": "bangalore",'+
            '        "region": "KA",'+
            '        "country": "INDIA",'+
            '        "zip": "560036"'+
            '    }'+
            '}';
            
        RestRequest request = new RestRequest();
        request.requestUri ='https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/ngbss/orders';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        // Update status of existing record to Working
       CreateOrderRestResource.checkValidEmail('test@gmail.com');
        CreateOrderRestResource.createOrderHeader();
        // Verify record was updated
        //System.assert(thisorderId != null);
        test.stopTest();
        
    }
     @isTest static void testcreateOrderHeader5() {
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
        
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',
        External_Account_ID__c='3006691',
        XREF_Type__c = 'SAP_SOLD_TO',
        Account_Name__c=acc.id,
        Site_Code__c='765');
        insert acref; 
        Account_Cross_Ref__c acref1= new Account_Cross_Ref__c(name='test',
        External_Account_ID__c='3006691',
        XREF_Type__c = 'SAP_SOLD_TO',
        Account_Name__c=acc.id,
        Site_Code__c='765');
        insert acref1; 
        
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
        Prod1.ProductCode = '131-9HEM';  
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
        
         
        Apttus_Config2__PaymentTerm__c Paymentterm = New Apttus_Config2__PaymentTerm__c();
        Paymentterm.Name= 'Net30';
        Paymentterm.Apttus_Config2__Sequence__c = 1;
        Paymentterm.APTS_External_Id__c = 'C003';
        Insert Paymentterm;
        
         APTS_Aspire_Order__c cso = new APTS_Aspire_Order__c();
        cso.name = 'Portal_To_Apttus';
        cso.Price_List_Id__c = Pricelist.id;
        cso.Payment_Terms_Id__c = Paymentterm.id;
        APTS_Aspire_Order__c cso2 = new APTS_Aspire_Order__c();
        cso2.name = 'SAP_To_Apttus';
        cso2.Price_List_Id__c = Pricelist.id;
        cso2.Payment_Terms_Id__c = Paymentterm.id;
        insert cso;
        insert cso2;
       
                
        Apttus_Config2__Order__c objOrder= new Apttus_Config2__Order__c();
        objOrder.Apttus_Config2__Type__c='New';
        objOrder.CurrencyIsoCode='EUR';
        objOrder.Apttus_Config2__SoldToAccountId__c = Acc.id;
        objOrder.Apttus_Config2__PODate__c=system.today();
        objOrder.Apttus_Config2__PONumber__c='1234';
        objOrder.Apttus_Config2__PriceListId__c = Pricelist.id;
        objOrder.Send_INV_To_SAP__c = false;
        objOrder.SoldTo_Number__c  = '300669';
        objOrder.SoldTo_SAP_Account_Name__c = 'test';
        objOrder.Sold_To_Street__c = 'tets street';
        objOrder.Sold_To_City__c =  'bangalore';
        objOrder.Sold_To_State__c =  'KA';
        objOrder.Sold_To_Country__c =  'INDIA';
        objOrder.Sold_To_Postal_Code__c =  '560036';
        objOrder.Generic_xref_SoldTo__c = true;
                
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
        Apttus_Config2__LineNumber__c = 1,
        Apttus_Config2__OptionId__c = prod1.id,
        Apttus_Config2__PrimaryLineNumber__c = 2
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
        
         attachment att=new attachment();
        att.parentId = objOrder.Id;
        att.name = 'File Name.Doc'; 
        att.ContentType = 'Doc'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob; 
       try{
       Insert att;
       }
       Catch(Exception Ex)
       {
       
       }  
        
         String json='{'+
            '    "soldTo": "300669",'+
            '    "shipTo": "3006691",'+
            '    "billTo": "300669",'+
            '    "origin": "SAP_To_Apttus",'+
            '    "userid": "H147664",'+
            '    "deliveryNo": "H147664",'+
            '    "paymentTerm": "",'+
            '    "emailIds": ['+
            '        "test@gmail.com",'+
            '        "trtr@gmail.com"'+
            '    ],'+
            '    "purchaseOrder": {'+  
            '    },'+ 
            '    "creditCard": {'+
            '        "cardType": "test",'+
            '        "cardToken": "-E803-4003-0Q046ZKQDFDFD4V",'+
            '        "validTo": "21072020",'+
            '        "cardHolderName": "Test stalingsfdca test"'+
            '    },'+
            '    "shipToAddr": {'+
            '        "name": "test",'+
            '        "street": "tets street",'+
            '        "city": "bangalore",'+
            '        "region": "KA",'+
            '        "country": "INDIA",'+
            '        "zip": "560036"'+
            '    },'+
            '    "soldToAddr": {'+
            '        "name": "test",'+
            '        "street": "tets street",'+
            '        "city": "bangalore",'+
            '        "region": "KA",'+
            '        "country": "INDIA",'+
            '        "zip": "560036"'+
            '    },'+
            '    "billToAddr": {'+
            '        "name": "test",'+
            '        "street": "tets street",'+
            '        "city": "bangalore",'+
            '        "region": "KA",'+
            '        "country": "INDIA",'+
            '        "zip": "560036"'+
            '    }'+
            '}';
            
        RestRequest request = new RestRequest();
        request.requestUri ='https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/ngbss/orders';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        // Update status of existing record to Working
       CreateOrderRestResource.checkValidEmail('test@gmail.com');
        CreateOrderRestResource.createOrderHeader();
        // Verify record was updated
        //System.assert(thisorderId != null);
        test.stopTest();
        
    }
     @isTest static void testcreateOrderHeader6() {
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
        
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',
        External_Account_ID__c='3006691',
        XREF_Type__c = 'SAP_SOLD_TO',
        Account_Name__c=acc.id,
        Site_Code__c='765');
        insert acref; 
        Account_Cross_Ref__c acref1= new Account_Cross_Ref__c(name='test',
        External_Account_ID__c='3006691',
        XREF_Type__c = 'SAP_SOLD_TO',
        Account_Name__c=acc.id,
        Site_Code__c='765');
        insert acref1; 
        
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
        Prod1.ProductCode = '131-9HEM';  
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
        
         
        Apttus_Config2__PaymentTerm__c Paymentterm = New Apttus_Config2__PaymentTerm__c();
        Paymentterm.Name= 'Net30';
        Paymentterm.Apttus_Config2__Sequence__c = 1;
        Paymentterm.APTS_External_Id__c = 'C003';
        Insert Paymentterm;
        
         APTS_Aspire_Order__c cso = new APTS_Aspire_Order__c();
        cso.name = 'Portal_To_Apttus';
        cso.Price_List_Id__c = Pricelist.id;
        cso.Payment_Terms_Id__c = Paymentterm.id;
        APTS_Aspire_Order__c cso2 = new APTS_Aspire_Order__c();
        cso2.name = 'SAP_To_Apttus';
        cso2.Price_List_Id__c = Pricelist.id;
        cso2.Payment_Terms_Id__c = Paymentterm.id;
        insert cso;
        insert cso2;
       
                
        Apttus_Config2__Order__c objOrder= new Apttus_Config2__Order__c();
        objOrder.Apttus_Config2__Type__c='New';
        objOrder.CurrencyIsoCode='EUR';
        objOrder.Apttus_Config2__SoldToAccountId__c = Acc.id;
        objOrder.Apttus_Config2__PODate__c=system.today();
        objOrder.Apttus_Config2__PONumber__c='1234';
        objOrder.Apttus_Config2__PriceListId__c = Pricelist.id;
        objOrder.Send_INV_To_SAP__c = false;
        objOrder.SoldTo_Number__c  = '300669';
        objOrder.SoldTo_SAP_Account_Name__c = 'test';
        objOrder.Sold_To_Street__c = 'tets street';
        objOrder.Sold_To_City__c =  'bangalore';
        objOrder.Sold_To_State__c =  'KA';
        objOrder.Sold_To_Country__c =  'INDIA';
        objOrder.Sold_To_Postal_Code__c =  '560036';
        objOrder.Generic_xref_SoldTo__c = true;
                
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
        Apttus_Config2__LineNumber__c = 1,
        Apttus_Config2__OptionId__c = prod1.id,
        Apttus_Config2__PrimaryLineNumber__c = 2
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
        
         attachment att=new attachment();
        att.parentId = objOrder.Id;
        att.name = 'File Name.Doc'; 
        att.ContentType = 'Doc'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob; 
       try{
       Insert att;
       }
       Catch(Exception Ex)
       {
       
       }  
        
         String json='{'+
            '    "soldTo": "300669",'+
            '    "shipTo": "300669",'+
            '    "billTo": "3006691",'+
            '    "origin": "SAP_To_Apttus",'+
            '    "userid": "H147664",'+
            '    "deliveryNo": "H147664",'+
            '    "paymentTerm": "",'+
            '    "emailIds": ['+
            '        "test@gmail.com",'+
            '        "trtr@gmail.com"'+
            '    ],'+
            '    "purchaseOrder": {'+  
            '    },'+ 
            '    "creditCard": {'+
            '        "cardType": "test",'+
            '        "cardToken": "-E803-4003-0Q046ZKQDFDFD4V",'+
            '        "validTo": "21072020",'+
            '        "cardHolderName": "Test stalingsfdca test"'+
            '    },'+
            '    "shipToAddr": {'+
            '        "name": "test",'+
            '        "street": "tets street",'+
            '        "city": "bangalore",'+
            '        "region": "KA",'+
            '        "country": "INDIA",'+
            '        "zip": "560036"'+
            '    },'+
            '    "soldToAddr": {'+
            '        "name": "test",'+
            '        "street": "tets street",'+
            '        "city": "bangalore",'+
            '        "region": "KA",'+
            '        "country": "INDIA",'+
            '        "zip": "560036"'+
            '    },'+
            '    "billToAddr": {'+
            '        "name": "test",'+
            '        "street": "tets street",'+
            '        "city": "bangalore",'+
            '        "region": "KA",'+
            '        "country": "INDIA",'+
            '        "zip": "560036"'+
            '    }'+
            '}';
            
        RestRequest request = new RestRequest();
        request.requestUri ='https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/ngbss/orders';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        // Update status of existing record to Working
       CreateOrderRestResource.checkValidEmail('test@gmail.com');
        CreateOrderRestResource.createOrderHeader();
        // Verify record was updated
        //System.assert(thisorderId != null);
        test.stopTest();
        
    }
     @isTest static void testcreateOrderHeader7() {
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
        
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',
        External_Account_ID__c='300669',
        XREF_Type__c = 'SAP_SOLD_TO',
        Account_Name__c=acc.id,
        Site_Code__c='765');
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
        Prod1.ProductCode = '131-9HEM';  
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
        
         
        Apttus_Config2__PaymentTerm__c Paymentterm = New Apttus_Config2__PaymentTerm__c();
        Paymentterm.Name= 'Net30';
        Paymentterm.Apttus_Config2__Sequence__c = 1;
        Paymentterm.APTS_External_Id__c = 'C003';
        Insert Paymentterm;
        
         APTS_Aspire_Order__c cso = new APTS_Aspire_Order__c();
        cso.name = 'Portal_To_Apttus';
        cso.Price_List_Id__c = Pricelist.id;
        cso.Payment_Terms_Id__c = Paymentterm.id;
        APTS_Aspire_Order__c cso2 = new APTS_Aspire_Order__c();
        cso2.name = 'SAP_To_Apttus';
        cso2.Price_List_Id__c = Pricelist.id;
        cso2.Payment_Terms_Id__c = Paymentterm.id;
        insert cso;
        insert cso2;
       
                
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
        
        attachment att=new attachment();
        att.parentId = objOrder.Id;
        att.name = 'File Name.pdf'; 
        att.ContentType = 'PDF'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob; 
       
       // Insert att;     
           
    Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(
        CurrencyIsoCode = 'USD',
        Apttus_Config2__ProductId__c = prod1.id,
        Apttus_Config2__ConfigurationId__c = config.id,
        Apttus_Config2__Description__c = 'TEST Line Item',
        Apttus_Config2__NetPrice__c = 100,
        Apttus_Config2__BasePrice__c = 200,
        Apttus_Config2__ItemSequence__c = 1,
        Apttus_Config2__LineNumber__c = 1,
        Apttus_Config2__OptionId__c = prod1.id,
        Apttus_Config2__PrimaryLineNumber__c = 2
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
            '    "soldTo": "300669",'+
            '    "shipTo": "",'+
            '    "billTo": "",'+
            '    "origin": "SAP_To_Apttus",'+
            '    "userid": "H147664",'+
            '    "deliveryNo": "12345",'+
            '    "paymentTerm": "",'+
            '    "emailIds": ['+
           
            '    ],'+
             '    "purchaseOrder": {'+  
          
            '    },'+ 
            '    "creditCard": {'+
            '        "cardType": "test",'+
            '        "cardToken": "-E803-4003-0Q046ZKQDFDFD4V",'+
            '        "validTo": "21072020",'+
            '        "cardHolderName": "Test stalingsfdca test"'+
            '    },'+
            '    "shipToAddr": {'+
            
            '    },'+
            '    "soldToAddr": {'+
           
            '    },'+
            '    "billToAddr": {'+
           
            '    }'+
            '}';
            
        RestRequest request = new RestRequest();
        request.requestUri ='https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/ngbss/orders';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        // Update status of existing record to Working
       CreateOrderRestResource.checkValidEmail('test@gmail.com');
        CreateOrderRestResource.createOrderHeader();
        // Verify record was updated
        //System.assert(thisorderId != null);
        test.stopTest();
        
    }
     @isTest static void testcreateOrderHeader8() {
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
        
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',
        External_Account_ID__c='300669',
        XREF_Type__c = 'SAP_SOLD_TO',
        Account_Name__c=acc.id,
        Site_Code__c='765');
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
        Prod1.ProductCode = '131-9HEM';  
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
        
         
        Apttus_Config2__PaymentTerm__c Paymentterm = New Apttus_Config2__PaymentTerm__c();
        Paymentterm.Name= 'Net30';
        Paymentterm.Apttus_Config2__Sequence__c = 1;
        Paymentterm.APTS_External_Id__c = 'C003';
        Insert Paymentterm;
        
         APTS_Aspire_Order__c cso = new APTS_Aspire_Order__c();
        cso.name = 'Portal_To_Apttus';
        cso.Price_List_Id__c = Pricelist.id;
        cso.Payment_Terms_Id__c = Paymentterm.id;
        APTS_Aspire_Order__c cso2 = new APTS_Aspire_Order__c();
        cso2.name = 'SAP_To_Apttus';
        cso2.Price_List_Id__c = Pricelist.id;
        cso2.Payment_Terms_Id__c = Paymentterm.id;
        insert cso;
        insert cso2;
       
                
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
        
        attachment att=new attachment();
        att.parentId = objOrder.Id;
        att.name = 'File Name.pdf'; 
        att.ContentType = 'PDF'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob; 
       
       // Insert att;     
           
    Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(
        CurrencyIsoCode = 'USD',
        Apttus_Config2__ProductId__c = prod1.id,
        Apttus_Config2__ConfigurationId__c = config.id,
        Apttus_Config2__Description__c = 'TEST Line Item',
        Apttus_Config2__NetPrice__c = 100,
        Apttus_Config2__BasePrice__c = 200,
        Apttus_Config2__ItemSequence__c = 1,
        Apttus_Config2__LineNumber__c = 1,
        Apttus_Config2__OptionId__c = prod1.id,
        Apttus_Config2__PrimaryLineNumber__c = 2
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
            '    "soldTo": "300669",'+
            '    "shipTo": "300669",'+
            '    "billTo": "",'+
            '    "origin": "SAP_To_Apttus",'+
            '    "userid": "H147664",'+
            '    "deliveryNo": "12345",'+
            '    "paymentTerm": "",'+
            '    "emailIds": ['+
           
            '    ],'+
             '    "purchaseOrder": {'+  
          
            '    },'+ 
            '    "creditCard": {'+
            '        "cardType": "test",'+
            '        "cardToken": "-E803-4003-0Q046ZKQDFDFD4V",'+
            '        "validTo": "21072020",'+
            '        "cardHolderName": "Test stalingsfdca test"'+
            '    },'+
            '    "shipToAddr": {'+
            
            '    },'+
            '    "soldToAddr": {'+
           
            '    },'+
            '    "billToAddr": {'+
           
            '    }'+
            '}';
            
        RestRequest request = new RestRequest();
        request.requestUri ='https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/ngbss/orders';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        // Update status of existing record to Working
       CreateOrderRestResource.checkValidEmail('test@gmail.com');
        CreateOrderRestResource.createOrderHeader();
        // Verify record was updated
        //System.assert(thisorderId != null);
        test.stopTest();
        
    }
         @isTest static void testcreateOrderHeader9() {
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
        
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',
        External_Account_ID__c='300669',
        XREF_Type__c = 'SAP_SOLD_TO',
        Account_Name__c=acc.id,
        Site_Code__c='765');
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
        Prod1.ProductCode = '131-9HEM';  
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
        
         
        Apttus_Config2__PaymentTerm__c Paymentterm = New Apttus_Config2__PaymentTerm__c();
        Paymentterm.Name= 'Net30';
        Paymentterm.Apttus_Config2__Sequence__c = 1;
        Paymentterm.APTS_External_Id__c = 'C003';
        Insert Paymentterm;
        
         APTS_Aspire_Order__c cso = new APTS_Aspire_Order__c();
        cso.name = 'Portal_To_Apttus';
        cso.Price_List_Id__c = Pricelist.id;
        cso.Payment_Terms_Id__c = Paymentterm.id;
        APTS_Aspire_Order__c cso2 = new APTS_Aspire_Order__c();
        cso2.name = 'SAP_To_Apttus';
        cso2.Price_List_Id__c = Pricelist.id;
        cso2.Payment_Terms_Id__c = Paymentterm.id;
        insert cso;
        insert cso2;
       
                
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
        
        attachment att=new attachment();
        att.parentId = objOrder.Id;
        att.name = 'File Name.pdf'; 
        att.ContentType = 'PDF'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob; 
       
       // Insert att;     
           
    Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(
        CurrencyIsoCode = 'USD',
        Apttus_Config2__ProductId__c = prod1.id,
        Apttus_Config2__ConfigurationId__c = config.id,
        Apttus_Config2__Description__c = 'TEST Line Item',
        Apttus_Config2__NetPrice__c = 100,
        Apttus_Config2__BasePrice__c = 200,
        Apttus_Config2__ItemSequence__c = 1,
        Apttus_Config2__LineNumber__c = 1,
        Apttus_Config2__OptionId__c = prod1.id,
        Apttus_Config2__PrimaryLineNumber__c = 2
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
            '    "soldTo": "300669",'+
            '    "shipTo": "300669",'+
            '    "billTo": "300669",'+
            '    "origin": "SAP_To_Apttus",'+
            '    "userid": "H147664",'+
            '    "deliveryNo": "12345",'+
            '    "paymentTerm": "c004",'+
            '    "emailIds": ['+
           
            '    ],'+
             '    "purchaseOrder": {'+  
          
            '    },'+ 
            '    "creditCard": {'+
            '        "cardType": "test",'+
            '        "cardToken": "-E803-4003-0Q046ZKQDFDFD4V",'+
            '        "validTo": "21072020",'+
            '        "cardHolderName": "Test stalingsfdca test"'+
            '    },'+
            '    "shipToAddr": {'+
            
            '    },'+
            '    "soldToAddr": {'+
           
            '    },'+
            '    "billToAddr": {'+
           
            '    }'+
            '}';
            
        RestRequest request = new RestRequest();
        request.requestUri ='https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/ngbss/orders';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        // Update status of existing record to Working
       CreateOrderRestResource.checkValidEmail('test@gmail.com');
        CreateOrderRestResource.createOrderHeader();
        // Verify record was updated
        //System.assert(thisorderId != null);
        test.stopTest();
        
    }
         @isTest static void testcreateOrderHeader10() {
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
        
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',
        External_Account_ID__c='300669',
        XREF_Type__c = 'SAP_SOLD_TO',
        Account_Name__c=acc.id,
        Site_Code__c='765');
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
        Prod1.ProductCode = '131-9HEM';  
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
        
         
        Apttus_Config2__PaymentTerm__c Paymentterm = New Apttus_Config2__PaymentTerm__c();
        Paymentterm.Name= 'Net30';
        Paymentterm.Apttus_Config2__Sequence__c = 1;
        Paymentterm.APTS_External_Id__c = 'C003';
        Insert Paymentterm;
        
         APTS_Aspire_Order__c cso = new APTS_Aspire_Order__c();
        cso.name = 'Portal_To_Apttus';
        cso.Price_List_Id__c = Pricelist.id;
        cso.Payment_Terms_Id__c = Paymentterm.id;
        APTS_Aspire_Order__c cso2 = new APTS_Aspire_Order__c();
        cso2.name = 'SAP_To_Apttus';
        cso2.Price_List_Id__c = Pricelist.id;
        cso2.Payment_Terms_Id__c = Paymentterm.id;
        insert cso;
        insert cso2;
       
                
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
        
        attachment att=new attachment();
        att.parentId = objOrder.Id;
        att.name = 'File Name.pdf'; 
        att.ContentType = 'PDF'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob; 
       
       // Insert att;     
           
    Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(
        CurrencyIsoCode = 'USD',
        Apttus_Config2__ProductId__c = prod1.id,
        Apttus_Config2__ConfigurationId__c = config.id,
        Apttus_Config2__Description__c = 'TEST Line Item',
        Apttus_Config2__NetPrice__c = 100,
        Apttus_Config2__BasePrice__c = 200,
        Apttus_Config2__ItemSequence__c = 1,
        Apttus_Config2__LineNumber__c = 1,
        Apttus_Config2__OptionId__c = prod1.id,
        Apttus_Config2__PrimaryLineNumber__c = 2
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
            '    "soldTo": "3006691",'+
            '    "shipTo": "300669",'+
            '    "billTo": "300669",'+
            '    "origin": "Portal_To_Apttus",'+
            '    "userid": "H147664",'+
            '    "deliveryNo": "12345",'+
            '    "paymentTerm": "c003",'+
            '    "emailIds": ['+
           
            '    ],'+
             '    "purchaseOrder": {'+  
          
            '    },'+ 
            '    "creditCard": {'+
            '        "cardType": "test",'+
            '        "cardToken": "-E803-4003-0Q046ZKQDFDFD4V",'+
            '        "validTo": "21072020",'+
            '        "cardHolderName": "Test stalingsfdca test"'+
            '    },'+
            '    "shipToAddr": {'+
            
            '    },'+
            '    "soldToAddr": {'+
           
            '    },'+
            '    "billToAddr": {'+
           
            '    }'+
            '}';
            
        RestRequest request = new RestRequest();
        request.requestUri ='https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/ngbss/orders';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        // Update status of existing record to Working
       CreateOrderRestResource.checkValidEmail('test@gmail.com');
        CreateOrderRestResource.createOrderHeader();
        // Verify record was updated
        //System.assert(thisorderId != null);
        test.stopTest();
        
    }
    
         @isTest static void testcreateOrderHeader11() {
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
        
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',
        External_Account_ID__c='300669',
        XREF_Type__c = 'SAP_SOLD_TO',
        Account_Name__c=acc.id,
        Site_Code__c='765');
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
        Prod1.ProductCode = '131-9HEM';  
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
        
         
        Apttus_Config2__PaymentTerm__c Paymentterm = New Apttus_Config2__PaymentTerm__c();
        Paymentterm.Name= 'Net30';
        Paymentterm.Apttus_Config2__Sequence__c = 1;
        Paymentterm.APTS_External_Id__c = 'C003';
        Insert Paymentterm;
        
         APTS_Aspire_Order__c cso = new APTS_Aspire_Order__c();
        cso.name = 'Portal_To_Apttus';
        cso.Price_List_Id__c = Pricelist.id;
        cso.Payment_Terms_Id__c = Paymentterm.id;
        APTS_Aspire_Order__c cso2 = new APTS_Aspire_Order__c();
        cso2.name = 'SAP_To_Apttus';
        cso2.Price_List_Id__c = Pricelist.id;
        cso2.Payment_Terms_Id__c = Paymentterm.id;
        insert cso;
        insert cso2;
       
                
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
        
        attachment att=new attachment();
        att.parentId = objOrder.Id;
        att.name = 'File Name.pdf'; 
        att.ContentType = 'PDF'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob; 
       
       // Insert att;     
           
    Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(
        CurrencyIsoCode = 'USD',
        Apttus_Config2__ProductId__c = prod1.id,
        Apttus_Config2__ConfigurationId__c = config.id,
        Apttus_Config2__Description__c = 'TEST Line Item',
        Apttus_Config2__NetPrice__c = 100,
        Apttus_Config2__BasePrice__c = 200,
        Apttus_Config2__ItemSequence__c = 1,
        Apttus_Config2__LineNumber__c = 1,
        Apttus_Config2__OptionId__c = prod1.id,
        Apttus_Config2__PrimaryLineNumber__c = 2
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
            '    "soldTo": "300669",'+
            '    "shipTo": "3006691",'+
            '    "billTo": "300669",'+
            '    "origin": "Portal_To_Apttus",'+
            '    "userid": "H147664",'+
            '    "deliveryNo": "12345",'+
            '    "paymentTerm": "c003",'+
            '    "emailIds": ['+
           
            '    ],'+
             '    "purchaseOrder": {'+  
          
            '    },'+ 
            '    "creditCard": {'+
            '        "cardType": "test",'+
            '        "cardToken": "-E803-4003-0Q046ZKQDFDFD4V",'+
            '        "validTo": "21072020",'+
            '        "cardHolderName": "Test stalingsfdca test"'+
            '    },'+
            '    "shipToAddr": {'+
            
            '    },'+
            '    "soldToAddr": {'+
           
            '    },'+
            '    "billToAddr": {'+
           
            '    }'+
            '}';
            
        RestRequest request = new RestRequest();
        request.requestUri ='https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/ngbss/orders';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        // Update status of existing record to Working
       CreateOrderRestResource.checkValidEmail('test@gmail.com');
        CreateOrderRestResource.createOrderHeader();
        // Verify record was updated
        //System.assert(thisorderId != null);
        test.stopTest();
        
    }
    
         @isTest static void testcreateOrderHeader12() {
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
        
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',
        External_Account_ID__c='300669',
        XREF_Type__c = 'SAP_SOLD_TO',
        Account_Name__c=acc.id,
        Site_Code__c='765');
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
        Prod1.ProductCode = '131-9HEM';  
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
        
         
        Apttus_Config2__PaymentTerm__c Paymentterm = New Apttus_Config2__PaymentTerm__c();
        Paymentterm.Name= 'Net30';
        Paymentterm.Apttus_Config2__Sequence__c = 1;
        Paymentterm.APTS_External_Id__c = 'C003';
        Insert Paymentterm;
        
         APTS_Aspire_Order__c cso = new APTS_Aspire_Order__c();
        cso.name = 'Portal_To_Apttus';
        cso.Price_List_Id__c = Pricelist.id;
        cso.Payment_Terms_Id__c = Paymentterm.id;
        APTS_Aspire_Order__c cso2 = new APTS_Aspire_Order__c();
        cso2.name = 'SAP_To_Apttus';
        cso2.Price_List_Id__c = Pricelist.id;
        cso2.Payment_Terms_Id__c = Paymentterm.id;
        insert cso;
        insert cso2;
       
                
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
        
        attachment att=new attachment();
        att.parentId = objOrder.Id;
        att.name = 'File Name.pdf'; 
        att.ContentType = 'PDF'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob; 
       
       // Insert att;     
           
    Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(
        CurrencyIsoCode = 'USD',
        Apttus_Config2__ProductId__c = prod1.id,
        Apttus_Config2__ConfigurationId__c = config.id,
        Apttus_Config2__Description__c = 'TEST Line Item',
        Apttus_Config2__NetPrice__c = 100,
        Apttus_Config2__BasePrice__c = 200,
        Apttus_Config2__ItemSequence__c = 1,
        Apttus_Config2__LineNumber__c = 1,
        Apttus_Config2__OptionId__c = prod1.id,
        Apttus_Config2__PrimaryLineNumber__c = 2
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
            '    "soldTo": "300669",'+
            '    "shipTo": "300669",'+
            '    "billTo": "3006691",'+
            '    "origin": "Portal_To_Apttus",'+
            '    "userid": "H147664",'+
            '    "deliveryNo": "12345",'+
            '    "paymentTerm": "c003",'+
            '    "emailIds": ['+
           
            '    ],'+
             '    "purchaseOrder": {'+  
          
            '    },'+ 
            '    "creditCard": {'+
            '        "cardType": "test",'+
            '        "cardToken": "-E803-4003-0Q046ZKQDFDFD4V",'+
            '        "validTo": "21072020",'+
            '        "cardHolderName": "Test stalingsfdca test"'+
            '    },'+
            '    "shipToAddr": {'+
            
            '    },'+
            '    "soldToAddr": {'+
           
            '    },'+
            '    "billToAddr": {'+
           
            '    }'+
            '}';
            
        RestRequest request = new RestRequest();
        request.requestUri ='https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/ngbss/orders';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        // Update status of existing record to Working
       CreateOrderRestResource.checkValidEmail('test@gmail.com');
        CreateOrderRestResource.createOrderHeader();
        // Verify record was updated
        //System.assert(thisorderId != null);
        test.stopTest();
        
    }
      @isTest static void testcreateOrderHeader13() {
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
        
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',
        External_Account_ID__c='300669',
        XREF_Type__c = 'SAP_SOLD_TO',
        Account_Name__c=acc.id,
        Site_Code__c='765');
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
        Prod1.ProductCode = '131-9HEM';  
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
        
         
        Apttus_Config2__PaymentTerm__c Paymentterm = New Apttus_Config2__PaymentTerm__c();
        Paymentterm.Name= 'Net30';
        Paymentterm.Apttus_Config2__Sequence__c = 1;
        Paymentterm.APTS_External_Id__c = 'C003';
        Insert Paymentterm;
        
         APTS_Aspire_Order__c cso = new APTS_Aspire_Order__c();
        cso.name = 'Portal_To_Apttus';
        cso.Price_List_Id__c = Pricelist.id;
        cso.Payment_Terms_Id__c = Paymentterm.id;
        APTS_Aspire_Order__c cso2 = new APTS_Aspire_Order__c();
        cso2.name = 'SAP_To_Apttus';
        cso2.Price_List_Id__c = Pricelist.id;
        cso2.Payment_Terms_Id__c = Paymentterm.id;
        insert cso;
        insert cso2;
       
                
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
        
        attachment att=new attachment();
        att.parentId = objOrder.Id;
        att.name = 'File Name.pdf'; 
        att.ContentType = 'PDF'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob; 
       
       // Insert att;     
           
    Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(
        CurrencyIsoCode = 'USD',
        Apttus_Config2__ProductId__c = prod1.id,
        Apttus_Config2__ConfigurationId__c = config.id,
        Apttus_Config2__Description__c = 'TEST Line Item',
        Apttus_Config2__NetPrice__c = 100,
        Apttus_Config2__BasePrice__c = 200,
        Apttus_Config2__ItemSequence__c = 1,
        Apttus_Config2__LineNumber__c = 1,
        Apttus_Config2__OptionId__c = prod1.id,
        Apttus_Config2__PrimaryLineNumber__c = 2
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
            '    "soldTo": "300669",'+
            '    "shipTo": "300669",'+
            '    "billTo": "300669",'+
            '    "origin": "APU",'+
            '    "userid": "H147664",'+
            '    "deliveryNo": "12345",'+
            '    "paymentTerm": "c003",'+
            '    "emailIds": ['+
           
            '    ],'+
             '    "purchaseOrder": {'+  
          
            '    },'+ 
            '    "creditCard": {'+
            '        "cardType": "test",'+
            '        "cardToken": "-E803-4003-0Q046ZKQDFDFD4V",'+
            '        "validTo": "21072020",'+
            '        "cardHolderName": "Test stalingsfdca test"'+
            '    },'+
            '    "shipToAddr": {'+
            
            '    },'+
            '    "soldToAddr": {'+
           
            '    },'+
            '    "billToAddr": {'+
           
            '    }'+
            '}';
            
        RestRequest request = new RestRequest();
        request.requestUri ='https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/ngbss/orders';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        // Update status of existing record to Working
       CreateOrderRestResource.checkValidEmail('test@gmail.com');
        CreateOrderRestResource.createOrderHeader();
        // Verify record was updated
        //System.assert(thisorderId != null);
        test.stopTest();
        
    }
    @isTest static void testcreateOrderHeader14() {
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
        
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',
        External_Account_ID__c='300669',
        XREF_Type__c = 'SAP_SOLD_TO',
        Account_Name__c=acc.id,
        Site_Code__c='765');
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
        Prod1.ProductCode = '131-9HEM';  
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
        
         
        Apttus_Config2__PaymentTerm__c Paymentterm = New Apttus_Config2__PaymentTerm__c();
        Paymentterm.Name= 'Net30';
        Paymentterm.Apttus_Config2__Sequence__c = 1;
        Paymentterm.APTS_External_Id__c = 'C003';
        Insert Paymentterm;
        
         APTS_Aspire_Order__c cso = new APTS_Aspire_Order__c();
        cso.name = 'Portal_To_Apttus';
        cso.Price_List_Id__c = Pricelist.id;
        cso.Payment_Terms_Id__c = Paymentterm.id;
        APTS_Aspire_Order__c cso2 = new APTS_Aspire_Order__c();
        cso2.name = 'SAP_To_Apttus';
        cso2.Price_List_Id__c = Pricelist.id;
        cso2.Payment_Terms_Id__c = Paymentterm.id;
        insert cso;
        insert cso2;
       
                
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
        
        attachment att=new attachment();
        att.parentId = objOrder.Id;
        att.name = 'File Name.pdf'; 
        att.ContentType = 'PDF'; 
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        att.body=bodyBlob; 
       
       // Insert att;     
           
    Apttus_Config2__LineItem__c lineItem = new Apttus_Config2__LineItem__c(
        CurrencyIsoCode = 'USD',
        Apttus_Config2__ProductId__c = prod1.id,
        Apttus_Config2__ConfigurationId__c = config.id,
        Apttus_Config2__Description__c = 'TEST Line Item',
        Apttus_Config2__NetPrice__c = 100,
        Apttus_Config2__BasePrice__c = 200,
        Apttus_Config2__ItemSequence__c = 1,
        Apttus_Config2__LineNumber__c = 1,
        Apttus_Config2__OptionId__c = prod1.id,
        Apttus_Config2__PrimaryLineNumber__c = 2
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
            '    "soldTo": "300669",'+
            '    "shipTo": "300669",'+
            '    "billTo": "300669",'+
            '    "origin": "",'+
            '    "userid": "H147664",'+
            '    "deliveryNo": "12345",'+
            '    "paymentTerm": "C003",'+
            '    "emailIds": ['+
           
            '    ],'+
             '    "purchaseOrder": {'+  
          
            '    },'+ 
            '    "creditCard": {'+
            '        "cardType": "test",'+
            '        "cardToken": "-E803-4003-0Q046ZKQDFDFD4V",'+
            '        "validTo": "21072020",'+
            '        "cardHolderName": "Test stalingsfdca test"'+
            '    },'+
            '    "shipToAddr": {'+
            
            '    },'+
            '    "soldToAddr": {'+
           
            '    },'+
            '    "billToAddr": {'+
           
            '    }'+
            '}';
            
        RestRequest request = new RestRequest();
        request.requestUri ='https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/ngbss/orders';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        // Update status of existing record to Working
       CreateOrderRestResource.checkValidEmail('test@gmail.com');
        CreateOrderRestResource.createOrderHeader();
        // Verify record was updated
        //System.assert(thisorderId != null);
        test.stopTest();
        
    }
 }