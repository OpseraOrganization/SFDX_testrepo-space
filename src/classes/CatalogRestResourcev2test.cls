@isTest
public class CatalogRestResourcev2test
{
    
    public static product2 prodtest = new product2();
    static testMethod void getCatalogtest1(){
        CatalogRestResourcev2test.testdata();
        //-----/services/apexrest/categories/products/features?soldTo=300669&productId=01t0U000002Kzj0
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //CatalogRestResourcev2 classToTest = new CatalogRestResourcev2();
        req.requestURI = 'https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/categories/products/features';
        req.params.put('soldTo','300669');
        req.params.put('productId',prodtest.id);
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        CatalogRestResourcev2.getCatalog();
        Test.stopTest();
    }
    static testMethod void getCatalogtest3(){
    CatalogRestResourcev2test.testdata();
        //-----/services/apexrest/categories/products/features?soldTo=300669&productId=01t0U000002Kzj0
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //CatalogRestResourcev2 classToTest = new CatalogRestResourcev2();
        req.requestURI = 'https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/categories/products/features';
        req.params.put('soldTo','3006692');
        req.params.put('productId',prodtest.id);
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        CatalogRestResourcev2.getCatalog();
        Test.stopTest();
    }
    static testMethod void getCatalogtest2(){
    //CatalogRestResourcev2test.testdata();
        //-----/services/apexrest/categories/products/features?soldTo=300669&productId=01t0U000002Kzj0
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        //CatalogRestResourcev2 classToTest = new CatalogRestResourcev2();
        req.requestURI = 'https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/categories/products/features';
        req.params.put('soldTo','3006692');
        req.addHeader('Content-Type', 'application/json');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        CatalogRestResourcev2.getCatalog();
        Test.stopTest();
    }
    
    public static void testdata(){
        //Creating Standalone product
        product2 prod1 = new product2();
        prod1.Name ='test1'; 
        prod1.IsActive = true;   
        prod1.Apttus_Config2__ConfigurationType__c = 'Standalone'; 
        prod1.family='Aspire';
        prod1.ProductCode = 'Aspire';
        insert prod1;
        prodtest=prod1;
        
        //Creating Bundle product
        product2 prod2 = new product2();
        prod2.Name = 'test2'; 
        prod2.IsActive = true;   
        prod2.Apttus_Config2__ConfigurationType__c = 'Bundle';  
        insert prod2;
        
        Account acc= new Account(name='Test Account',Strategic_Business_Unit__c='ATR',Sbl_Account_Row_Id__c='123',REPORT_ACCOUNT_NAME__c = 'Test',SAP_Sold_To__c='300669',Customer_Status__c = 'Active');
        insert acc;
        Account acc2= new Account(name='Test Account2',Strategic_Business_Unit__c='ATR',Sbl_Account_Row_Id__c='1234',REPORT_ACCOUNT_NAME__c = 'Test2',SAP_Sold_To__c='326039',Customer_Status__c = 'Active');
        insert acc2;
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',External_Account_ID__c='300669',XREF_Type__c = 'SAP_SOLD_TO',Account_Name__c=acc.id,Site_Code__c='765');
        insert acref;
        Account_Cross_Ref__c acref2= new Account_Cross_Ref__c(name='test',External_Account_ID__c='3006692',XREF_Type__c = 'SAP_SOLD_TO',Account_Name__c=acc2.id,Site_Code__c='765');
        insert acref2;
        //Creating Price list 
        Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c();
        pl.name = 'TestPriceList';
        insert pl;
        APTS_Aspire_Order__c cso = new APTS_Aspire_Order__c();
        cso.name = 'Portal_To_Apttus';
        cso.Price_List_Id__c = pl.id;
        APTS_Aspire_Order__c cso2 = new APTS_Aspire_Order__c();
        cso2.name = 'SAP_To_Apttus';
        cso2.Price_List_Id__c = pl.id;
        insert cso;
        insert cso2;
         //Creating Price list and price list item for standalone product
        //Apttus_Config2__PriceList__c plist = new Apttus_Config2__PriceList__c();
        //plist.name = 'TestPriceList';
        //insert plist;
        Apttus_Config2__PriceListItem__c pli = new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c = pl.id;
        pli.Apttus_Config2__ProductId__c = prod1.id;
        pli.Apttus_Config2__ListPrice__c = 100.00;
        pli.CurrencyIsoCode = 'USD';
        insert pli;
    }
    /*
    static void createTestRecord(String productName){
        Apttus_Config2__ClassificationName__c classif = new Apttus_Config2__ClassificationName__c();
        classif.name = 'TestClassification1';
        classif.Apttus_Config2__HierarchyLabel__c = 'TestClassification1';
        classif.Required_For_Portal__c = true;
        classif.Apttus_Config2__Type__c = 'Offering';
        insert classif;
        
        //Creating Standalone product
        product2 prod1 = new product2();
        prod1.Name = productName + '1'; 
        prod1.IsActive = true;   
        prod1.Apttus_Config2__ConfigurationType__c = 'Standalone'; 
        
        //Creating Bundle product
        product2 prod2 = new product2();
        prod2.Name = productName; 
        prod2.IsActive = true;   
        prod2.Apttus_Config2__ConfigurationType__c = 'Bundle';  
        
        List<Product2> prod = new List<Product2>();
        prod.add(prod1);
        prod.add(prod2);
        insert prod;
        
        //Creating Price list and price list item for standalone product
        Apttus_Config2__PriceList__c pl = new Apttus_Config2__PriceList__c();
        pl.name = 'TestPriceList';
        insert pl;
        
        Apttus_Config2__PriceListItem__c pli = new Apttus_Config2__PriceListItem__c();
        pli.Apttus_Config2__PriceListId__c = pl.id;
        pli.Apttus_Config2__ProductId__c = prod[0].id;
        pli.Apttus_Config2__ListPrice__c = 100.00;
        pli.CurrencyIsoCode = 'USD';
        
        insert pli;
        
        //Creating product hierarchy view
        List<Apttus_Config2__ProductHierarchyView__c> prodhierList = new List<Apttus_Config2__ProductHierarchyView__c >();
        for(integer i=0;i<2;i++){
            Apttus_Config2__ProductHierarchyView__c prodhier = new Apttus_Config2__ProductHierarchyView__c();
            prodhier.Apttus_Config2__ChildProductId__c = prod[i].id;
            prodhier.Apttus_Config2__HierarchyId__c = classif.id;
            prodhier.Apttus_Config2__ParentLevel__c = 0;
            prodhier.Apttus_Config2__ChildLevel__c = 1;
            prodhierList.add(prodhier);
        }
        insert prodhierList;
    }    
  */
}