@isTest
public class ProductMaterialRestResourceTest {
    @isTest
    static void getmaterialTest1(){
    
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
        prod1.family = 'Aspire';
        prod1.Is_License_Required__c=true;
        prod1.Term__c= 'Indefinite';
        Prod1.Plant__c = 1014;
        Prod1.Assignment__c= 'BMS';
        prod1.Inte__c = 'BMS Invoice';
        Prod1.purchase_Option__c= 'PO_CC';
        prod1.ProductCode = '131-9HEM';
        insert prod1;
        
         product2 prod2 = new product2();
        prod2.Name = 'test1'; 
        prod2.IsActive = true;   
        prod2.Apttus_Config2__ConfigurationType__c = 'Standalone'; 
        prod2.family = 'Aspire';
        prod2.Is_License_Required__c=true;
        prod2.Term__c= 'Indefinite';
        Prod2.Plant__c = 1014;
        Prod2.Assignment__c= 'BMS';
        prod2.Inte__c = 'BMS Invoice';
        Prod2.purchase_Option__c= 'PO_CC';
        prod2.ProductCode = '131-9HEM';
        insert prod2;
        
        Apttus_Config2__PriceList__c Pricelist = New Apttus_Config2__PriceList__c();
        
        Apttus_Config2__ProductOptionGroup__c pog = new Apttus_Config2__ProductOptionGroup__c();
        pog.Apttus_Config2__Sequence__c =0;
        pog.Apttus_Config2__ProductId__c=prod2.id;
        pog.Apttus_Config2__OptionGroupId__c=clashir.id;
        insert pog;
        system.debug('pog'+pog);
        //subproducts
        Apttus_Config2__ProductOptionComponent__c cpog= new Apttus_Config2__ProductOptionComponent__c();
        cpog.Apttus_Config2__ProductOptionGroupId__c=pog.id;
        cpog.Apttus_Config2__ComponentProductId__c=prod2.id;
        cpog.Apttus_Config2__ParentProductId__c =prod1.id;
        cpog.Apttus_Config2__Sequence__c=2;
        insert cpog;
        system.debug('cpog'+cpog);
        
        Account A = New Account();
        A.name = 'Test';
        A.SAP_Sold_To__c = '0000365123-01';
        A.ATR_Channel_Partner__c = True;
        A.BGA_Account__c = True;
        A.D_S_Channel_Partner__c = True;
        A.Customer_Status__c = 'Active';
        Insert A;
        
        Account_Cross_Ref__c ACR = New Account_Cross_Ref__c();
        ACR.Name = 'Test';
        ACR.Account_Name__c = A.id;
        ACR.XREF_Type__c = 'SAP_SOLD_TO';
        ACR.Site_Code__c='SAP';
        ACR.External_Account_ID__c = '0000365123-01';
        Insert ACR;
        
        APTS_Aspire_Order__c N = New APTS_Aspire_Order__c();
        N.Name = 'Portal_To_Apttus';
        N.Price_List_Id__c = 'aDc2g0000008azd';
        N.Payment_Terms_Id__c = 'aDV1B0000004CM7';
        N.Billing_Preference_Id__c ='aBu1B000000XZN1tj';
        Insert N;
        
        ProductMaterialRestResource.searchAccList('365123');
        //List<Product2> productIds = [Select id,name,Apttus_Config2__HasOptions__c,(Select id,Name,Apttus_Config2__ComponentProductId__r.name,Apttus_Config2__ComponentProductId__c,Apttus_Config2__ParentProductId__c,Apttus_Config2__ComponentProductId__r.ProductCode from Apttus_Config2__Options__r),Plant__c,Inte__c,Assignment__c,ProductCode from Product2 where Id =: prod1.id];
        //System.debug('product---'+productIds);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ngbss/api/v1/products/materials'; 
        req.httpMethod = 'GET';
        req.addParameter('bId', prod1.id);
        req.addParameter('soldTo',A.SAP_Sold_To__c);
        RestContext.request = req;
        RestContext.response = res;
        ProductMaterialRestResource.getmaterial();
       
      
       
    }
    @isTest
    static void getmaterialTest2(){
    
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
        prod1.family = 'Aspire';
        prod1.Is_License_Required__c=true;
        prod1.Term__c= 'Indefinite';
        insert prod1;
        
         product2 prod2 = new product2();
        prod2.Name = 'test1'; 
        prod2.IsActive = true;   
        prod2.Apttus_Config2__ConfigurationType__c = 'Standalone'; 
        prod2.family = 'Aspire';
        prod2.Is_License_Required__c=true;
        prod2.Term__c= 'Indefinite';
        insert prod2;
        
        Apttus_Config2__ProductOptionGroup__c pog = new Apttus_Config2__ProductOptionGroup__c();
        pog.Apttus_Config2__Sequence__c =0;
        pog.Apttus_Config2__ProductId__c=prod1.id;
        pog.Apttus_Config2__OptionGroupId__c=clashir.id;
        insert pog;
        system.debug('pog'+pog);
        //subproducts
        Apttus_Config2__ProductOptionComponent__c cpog= new Apttus_Config2__ProductOptionComponent__c();
        cpog.Apttus_Config2__ProductOptionGroupId__c=pog.id;
        cpog.Apttus_Config2__ComponentProductId__c=prod2.id;
        cpog.Apttus_Config2__ParentProductId__c =prod2.id;
        cpog.Apttus_Config2__Sequence__c=2;
        insert cpog;
        system.debug('cpog'+cpog);
        
        Account A = New Account();
        A.name = 'Test';
        A.SAP_Sold_To__c = '';
        A.ATR_Channel_Partner__c = True;
       // A.BGA_Account__c = True;
       // A.D_S_Channel_Partner__c = True;
        A.Customer_Status__c = 'Active';
        Insert A;
        
        Account_Cross_Ref__c ACR = New Account_Cross_Ref__c();
        ACR.Name = 'Test';
        ACR.Account_Name__c = A.id;
        ACR.XREF_Type__c = 'SAP_SOLD_TO';
        ACR.Site_Code__c='SAP';
        ACR.External_Account_ID__c = '0000365123-01';
        Insert ACR;
        
         APTS_Aspire_Order__c N = New APTS_Aspire_Order__c();
        N.Name = 'Portal_To_Apttus';
        N.Price_List_Id__c = 'aDc2g0000008azd';
        N.Payment_Terms_Id__c = 'aDV1B0000004CM7';
        N.Billing_Preference_Id__c ='aBu1B000000XZN1tj';
        Insert N;
        
        ProductMaterialRestResource.searchAccList('365123');
        //List<Product2> productIds = [Select id,name,Apttus_Config2__HasOptions__c,(Select id,Name,Apttus_Config2__ComponentProductId__r.name,Apttus_Config2__ComponentProductId__c,Apttus_Config2__ParentProductId__c,Apttus_Config2__ComponentProductId__r.ProductCode from Apttus_Config2__Options__r),Plant__c,Inte__c,Assignment__c,ProductCode from Product2 where Id =: prod1.id];
        //System.debug('product---'+productIds);
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ngbss/api/v1/products/materials'; 
        req.httpMethod = 'GET';
        req.addParameter('pId', prod2.id);
        req.addParameter('soldTo',A.SAP_Sold_To__c);
        RestContext.request = req;
        RestContext.response = res;
        ProductMaterialRestResource.getmaterial();
        
       
        
       
    }
      @isTest
    static void getmaterialTest3(){
    
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
        prod1.family = 'Aspire';
        prod1.Is_License_Required__c=true;
        prod1.Term__c= 'Indefinite';
        insert prod1;
        
         product2 prod2 = new product2();
        prod2.Name = 'test1'; 
        prod2.IsActive = true;   
        prod2.Apttus_Config2__ConfigurationType__c = 'Standalone'; 
        prod2.family = 'Aspire';
        prod2.Is_License_Required__c=true;
        prod2.Term__c= 'Indefinite';
        insert prod2;
        
        Apttus_Config2__ProductOptionGroup__c pog = new Apttus_Config2__ProductOptionGroup__c();
        pog.Apttus_Config2__Sequence__c =0;
        pog.Apttus_Config2__ProductId__c=prod1.id;
        pog.Apttus_Config2__OptionGroupId__c=clashir.id;
        insert pog;
        system.debug('pog'+pog);
        //subproducts
        Apttus_Config2__ProductOptionComponent__c cpog= new Apttus_Config2__ProductOptionComponent__c();
        cpog.Apttus_Config2__ProductOptionGroupId__c=pog.id;
        cpog.Apttus_Config2__ComponentProductId__c=prod2.id;
        cpog.Apttus_Config2__ParentProductId__c =prod2.id;
        cpog.Apttus_Config2__Sequence__c=2;
        insert cpog;
        system.debug('cpog'+cpog);
        
        Account A = New Account();
        A.name = 'Test';
        A.SAP_Sold_To__c = '0000365123-01';
        A.ATR_Channel_Partner__c = True;
        A.BGA_Account__c = True;
        A.D_S_Channel_Partner__c = True;
        A.Strategic_Business_Unit__c = 'D&S';
        A.Customer_Status__c = 'Active';
        Insert A;
        
        Account_Cross_Ref__c ACR = New Account_Cross_Ref__c();
        ACR.Name = 'Test';
        ACR.Account_Name__c = A.id;
        ACR.XREF_Type__c = 'SAP_SOLD_TO';
        ACR.Site_Code__c='SAP';
        ACR.External_Account_ID__c = '0000365123-01';
        Insert ACR;
        
         APTS_Aspire_Order__c N = New APTS_Aspire_Order__c();
        N.Name = 'Portal_To_Apttus';
        N.Price_List_Id__c = 'aDc2g0000008azd';
        N.Payment_Terms_Id__c = 'aDV1B0000004CM7';
        N.Billing_Preference_Id__c ='aBu1B000000XZN1tj';
        Insert N;
        
        ProductMaterialRestResource.searchAccList('365123');
        //List<Product2> productIds = [Select id,name,Apttus_Config2__HasOptions__c,(Select id,Name,Apttus_Config2__ComponentProductId__r.name,Apttus_Config2__ComponentProductId__c,Apttus_Config2__ParentProductId__c,Apttus_Config2__ComponentProductId__r.ProductCode from Apttus_Config2__Options__r),Plant__c,Inte__c,Assignment__c,ProductCode from Product2 where Id =: prod1.id];
        //System.debug('product---'+productIds);
        
        RestRequest req2 = new RestRequest(); 
        RestResponse res2 = new RestResponse();
        req2.requestURI = '/services/apexrest/ngbss/api/v1/products/materials'; 
        req2.httpMethod = 'GET';
        req2.addParameter('soldTo', prod1.id);
        req2.addParameter('bId', prod1.id);
        req2.addParameter('pId', prod2.id);
        RestContext.request = req2;
        RestContext.response = res2;
        ProductMaterialRestResource.getmaterial();
        
       
    }
      @isTest
    static void getmaterialTest4(){
    
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
        prod1.family = 'Aspire';
        prod1.Is_License_Required__c=true;
        prod1.Term__c= 'Indefinite';
        insert prod1;
        
         product2 prod2 = new product2();
        prod2.Name = 'test1'; 
        prod2.IsActive = true;   
        prod2.Apttus_Config2__ConfigurationType__c = 'Standalone'; 
        prod2.family = 'Aspire';
        prod2.Is_License_Required__c=true;
        prod2.Term__c= 'Indefinite';
        insert prod2;
        
        Apttus_Config2__ProductOptionGroup__c pog = new Apttus_Config2__ProductOptionGroup__c();
        pog.Apttus_Config2__Sequence__c =0;
        pog.Apttus_Config2__ProductId__c=prod1.id;
        pog.Apttus_Config2__OptionGroupId__c=clashir.id;
        insert pog;
        system.debug('pog'+pog);
        //subproducts
        Apttus_Config2__ProductOptionComponent__c cpog= new Apttus_Config2__ProductOptionComponent__c();
        cpog.Apttus_Config2__ProductOptionGroupId__c=pog.id;
        cpog.Apttus_Config2__ComponentProductId__c=prod2.id;
        cpog.Apttus_Config2__ParentProductId__c =prod2.id;
        cpog.Apttus_Config2__Sequence__c=2;
        insert cpog;
        system.debug('cpog'+cpog);
        
        Account A = New Account();
        A.name = 'Test';
        A.SAP_Sold_To__c = '0000365123-01';
        A.Strategic_Business_Unit__c = 'D&S';
        A.Customer_Status__c = 'Active';
        Insert A;
        
        Account_Cross_Ref__c ACR = New Account_Cross_Ref__c();
        ACR.Name = 'Test';
        ACR.Account_Name__c = A.id;
        ACR.XREF_Type__c = 'SAP_SOLD_TO';
        ACR.Site_Code__c='SAP';
        ACR.External_Account_ID__c = '0000365123-01';
        Insert ACR;
        
         APTS_Aspire_Order__c N = New APTS_Aspire_Order__c();
        N.Name = 'Portal_To_Apttus';
        N.Price_List_Id__c = 'aDc2g0000008azd';
        N.Payment_Terms_Id__c = 'aDV1B0000004CM7';
        N.Billing_Preference_Id__c ='aBu1B000000XZN1tj';
        Insert N;
        
        ProductMaterialRestResource.searchAccList('0000365123-01');
        //List<Product2> productIds = [Select id,name,Apttus_Config2__HasOptions__c,(Select id,Name,Apttus_Config2__ComponentProductId__r.name,Apttus_Config2__ComponentProductId__c,Apttus_Config2__ParentProductId__c,Apttus_Config2__ComponentProductId__r.ProductCode from Apttus_Config2__Options__r),Plant__c,Inte__c,Assignment__c,ProductCode from Product2 where Id =: prod1.id];
        //System.debug('product---'+productIds);
        
        RestRequest req2 = new RestRequest(); 
        RestResponse res2 = new RestResponse();
        req2.requestURI = '/services/apexrest/ngbss/api/v1/products/materials'; 
        req2.httpMethod = 'GET';
        req2.addParameter('bId', prod1.id);
        req2.addParameter('pId', prod2.id);
        RestContext.request = req2;
        RestContext.response = res2;
        ProductMaterialRestResource.getmaterial();
        
       
    }
    
     @isTest
    static void getmaterialTest5(){
    
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
        prod1.family = 'Aspire';
        prod1.Is_License_Required__c=true;
        prod1.Term__c= 'Indefinite';
        insert prod1;
        
         product2 prod2 = new product2();
        prod2.Name = 'test1'; 
        prod2.IsActive = true;   
        prod2.Apttus_Config2__ConfigurationType__c = 'Standalone'; 
        prod2.family = 'Aspire';
        prod2.Is_License_Required__c=true;
        prod2.Term__c= 'Indefinite';
        insert prod2;
        
        Apttus_Config2__ProductOptionGroup__c pog = new Apttus_Config2__ProductOptionGroup__c();
        pog.Apttus_Config2__Sequence__c =0;
        pog.Apttus_Config2__ProductId__c=prod1.id;
        pog.Apttus_Config2__OptionGroupId__c=clashir.id;
        insert pog;
        system.debug('pog'+pog);
        //subproducts
        Apttus_Config2__ProductOptionComponent__c cpog= new Apttus_Config2__ProductOptionComponent__c();
        cpog.Apttus_Config2__ProductOptionGroupId__c=pog.id;
        cpog.Apttus_Config2__ComponentProductId__c=prod2.id;
        cpog.Apttus_Config2__ParentProductId__c =prod2.id;
        cpog.Apttus_Config2__Sequence__c=2;
        insert cpog;
        system.debug('cpog'+cpog);
        
        Account A = New Account();
        A.name = 'Test';
        A.SAP_Sold_To__c = '0000365123-01';
        A.ATR_Channel_Partner__c = True;
        A.BGA_Account__c = True;
        A.D_S_Channel_Partner__c = True;
        A.Strategic_Business_Unit__c = 'D&S';
        A.Customer_Status__c = 'Active';
        Insert A;
        
        Account_Cross_Ref__c ACR = New Account_Cross_Ref__c();
        ACR.Name = 'Test';
        ACR.Account_Name__c = A.id;
        ACR.XREF_Type__c = 'SAP_SOLD_TO';
        ACR.Site_Code__c='SAP';
        ACR.External_Account_ID__c = '0000365123-01';
        Insert ACR;
        
         APTS_Aspire_Order__c N = New APTS_Aspire_Order__c();
        N.Name = 'Portal_To_Apttus';
        N.Price_List_Id__c = 'aDc2g0000008azd';
        N.Payment_Terms_Id__c = 'aDV1B0000004CM7';
        N.Billing_Preference_Id__c ='aBu1B000000XZN1tj';
        Insert N;
        
        ProductMaterialRestResource.searchAccList('365123');
        //List<Product2> productIds = [Select id,name,Apttus_Config2__HasOptions__c,(Select id,Name,Apttus_Config2__ComponentProductId__r.name,Apttus_Config2__ComponentProductId__c,Apttus_Config2__ParentProductId__c,Apttus_Config2__ComponentProductId__r.ProductCode from Apttus_Config2__Options__r),Plant__c,Inte__c,Assignment__c,ProductCode from Product2 where Id =: prod1.id];
        //System.debug('product---'+productIds);
        
        RestRequest req2 = new RestRequest(); 
        RestResponse res2 = new RestResponse();
        req2.requestURI = '/services/apexrest/ngbss/api/v1/products/materials'; 
        req2.httpMethod = 'GET';
        req2.addParameter('soldTo',ACR.External_Account_ID__c);
         RestContext.request = req2;
        RestContext.response = res2;
        ProductMaterialRestResource.getmaterial();
        
       
    }
}