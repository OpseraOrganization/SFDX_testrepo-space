@isTest
public class CreateOrderLineItemsRestResourceTest   {   
    @isTest
    static void createLineItemstest(){
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
        
        Apttus_Config2__AssetLineItem__c assetLineItem = new Apttus_Config2__AssetLineItem__c(
            APTS_External_Id__c = '123',
            APTS_External_Source__c = 'JIRA',
            Apttus_Config2__OptionId__c=prod1.id
        );
        insert assetLineItem;
        
       
        Apttus_Billing__BillingSchedule__c billingSchedule = new Apttus_Billing__BillingSchedule__c();
        billingSchedule.Apttus_Billing__OrderLineItemId__c= Orderli.Id;
        insert billingSchedule; 
        
        String json='{'+
    '    "products": ['+
    '        {'+
    '            "productId": "'+prod1.id+'",'+
    '            "subProducts": ['+
    '                {'+
    '                    "subProductId": "'+cpog.id+'",'+
    '                    "materialno": "'+prod1.productcode +'",'+  
    '                    "platforms": ['+
    '                        {'+
    '                            "type": "123",'+
    '                            "serialNumber": "s1234567",'+
    '                            "distributionNo": "23432",'+
    '                            "expiryDate":"'+ System.today() +'"'+
    '                        }'+
    '                    ]'+
    '                }'+
    '            ]'+
    '        }'+
    '    ],'+
    '            "lockBox" : "21380" ' +
    '}';
    
    System.debug('json='+json);
        RestRequest request = new RestRequest();
        request.requestUri = 'services/apexrest/orders/'+objOrder.id+'/cart/products';
        request.httpMethod = 'POST';
        request.addParameter('input-type', 'MNO');
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        
        CreateOrderLineItemsRestResource.createLineItems();
        test.stoptest();
    }
      @isTest
    static void createLineItemstest1(){
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
        
        Apttus_Config2__AssetLineItem__c assetLineItem = new Apttus_Config2__AssetLineItem__c(
            APTS_External_Id__c = '123',
            APTS_External_Source__c = 'JIRA',
            Apttus_Config2__OptionId__c=prod1.id
        );
        insert assetLineItem;
        
       
        Apttus_Billing__BillingSchedule__c billingSchedule = new Apttus_Billing__BillingSchedule__c();
        billingSchedule.Apttus_Billing__OrderLineItemId__c= Orderli.Id;
        insert billingSchedule; 
        
        String json='{'+
    '    "products": ['+
    '        {'+
    '            "productId": "'+prod1.id+'",'+
    '            "subProducts": ['+
    '                {'+
    '                    "subProductId": "'+cpog.id+'",'+
    '                    "materialno":"131-9HEM",'+
    '                    "platforms": ['+
    '                        {'+
    '                            "type": "123",'+
    '                            "serialNumber": "s1234567",'+
    '                            "distributionNo": "23432",'+
    '                            "expiryDate":"'+ System.today() +'"'+
    '                        }'+
    '                    ]'+
    '                }'+
    '            ]'+
    '        }'+
    '    ],'+
    '            "lockBox" : "" ' +
    '}';
        RestRequest request = new RestRequest();
        request.requestUri = 'services/apexrest/orders/'+objOrder.id+'/cart/products';
        request.httpMethod = 'POST';
        request.addParameter('input-type', 'PID');
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        
        CreateOrderLineItemsRestResource.createLineItems();
        test.stoptest();
    }
     @isTest
    static void createLineItemstest2()
    {
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
        
        Apttus_Config2__AssetLineItem__c assetLineItem = new Apttus_Config2__AssetLineItem__c(
            APTS_External_Id__c = '123',
            APTS_External_Source__c = 'JIRA',
            Apttus_Config2__OptionId__c=prod1.id
        );
        insert assetLineItem;
        
       
        Apttus_Billing__BillingSchedule__c billingSchedule = new Apttus_Billing__BillingSchedule__c();
        billingSchedule.Apttus_Billing__OrderLineItemId__c= Orderli.Id;
        insert billingSchedule;
          String json='{'+
    '    "products": ['+
    '        {'+
    '            "productId": "'+prod1.id+'",'+
    '            "subProducts": ['+
    '                {'+
    '                    "subProductId": "'+cpog.id+'",'+
    '                     "materialno":"'+prod1.productcode+'",'+
    '                    "platforms": ['+
    '                        {'+
    '                            "type": "123",'+
    '                            "serialNumber": "s1234567",'+
    '                            "distributionNo": "23432",'+
    '                            "expiryDate":"'+ System.today() +'"'+
    '                        }'+
    '                    ]'+
    '                }'+
    '            ]'+
    '        }'+
     '    ],'+
    '            "lockBox" : "" ' +
    '}';
        RestRequest request = new RestRequest();
        request.requestUri = 'services/apexrest/orders/'+cpog.id+'/cart/products';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(json);
        RestContext.request = request;
        RestResponse response = new RestResponse();
        RestContext.response = response;
        system.debug('response'+response);
        CreateOrderLineItemsRestResource.createLineItems();
        
        RestRequest request1 = new RestRequest();
        request1.requestUri = 'services/apexrest/orders/'+objOrder.id+'/cart/products';
        request1.httpMethod = 'POST';
        request1.addHeader('Content-Type', 'application/json');
        request1.addParameter('input-type', '');
        request1.requestBody = Blob.valueOf(json);
        RestContext.request = request1;
        RestResponse response1 = new RestResponse();
        RestContext.response = response1;
        system.debug('response'+response1);
        CreateOrderLineItemsRestResource.createLineItems();
        
        RestRequest request2 = new RestRequest();
        request2.requestUri = 'services/apexrest/orders/'+objOrder.id+'/cart/products';
        request2.httpMethod = 'POST';
        request2.addHeader('Content-Type', 'application/json');
        request2.addParameter('input-type', 'SAP');
        request2.requestBody = Blob.valueOf(json);
        RestContext.request = request2;
        RestResponse response2 = new RestResponse();
        RestContext.response = response2;
        system.debug('response'+response2);
        CreateOrderLineItemsRestResource.createLineItems();   
    }    
    
     @isTest
    static void createLineItemstest3()
    {
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
        
        Apttus_Config2__AssetLineItem__c assetLineItem = new Apttus_Config2__AssetLineItem__c(
            APTS_External_Id__c = '123',
            APTS_External_Source__c = 'JIRA',
            Apttus_Config2__OptionId__c=prod1.id
        );
        insert assetLineItem;
        
       
        Apttus_Billing__BillingSchedule__c billingSchedule = new Apttus_Billing__BillingSchedule__c();
        billingSchedule.Apttus_Billing__OrderLineItemId__c= Orderli.Id;
        insert billingSchedule;
          String json='{'+
    '    "products": ['+
    '        {'+
    '            "subProducts": ['+
    '                {'+
    '                    "subProductId": "'+cpog.id+'",'+
    '                     "materialno":" ",'+
    '                    "platforms": ['+
    '                        {'+
    '                            "type": "123",'+
    '                            "serialNumber": "s1234567",'+
    '                            "distributionNo": "23432",'+
    '                            "expiryDate":"'+ System.today() +'"'+
    '                        }'+
    '                    ]'+
    '                }'+
    '            ]'+
    '        }'+
     '    ],'+
    '            "lockBox" : "" ' +
    '}';
               
        RestRequest request2 = new RestRequest();
        request2.requestUri = 'services/apexrest/orders/'+objOrder.id+'/cart/products';
        request2.httpMethod = 'POST';
        request2.addHeader('Content-Type', 'application/json');
        request2.addParameter('input-type', 'PID');
        request2.requestBody = Blob.valueOf(json);
        RestContext.request = request2;
        RestResponse response2 = new RestResponse();
        RestContext.response = response2;
        system.debug('response'+response2);
        CreateOrderLineItemsRestResource.createLineItems();   
    }     
}