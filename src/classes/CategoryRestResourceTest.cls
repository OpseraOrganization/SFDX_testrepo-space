@isTest
public class CategoryRestResourceTest{
    @isTest
    static void testGetCategories(){
        createTestRecord('Test7');
        RestRequest request = new RestRequest();    
        RestResponse response = new RestResponse();   
        request.requestUri = 'https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/categories/products';
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = response;
        CategoryRestResource.getCategories();
    }
    @isTest
    static void testGetCategoriesWithParams(){
        testGetCategories('field','category','Test1');
        //testGetCategories('search','450','Test2'); //Valid search string
        testGetCategories('search','abc','Test3');  //Invalid search string
        //testGetCategories('categoryId','aC20U0000004H6Z','Test4'); //Valid categoryId
        testGetCategories('categoryId','aC20U0000004H6U','Test5'); //Invalid categoryId
        testGetCategories('categoryId','aC20U0000004H6U','search','abc','Test6');
    }
    static void testGetCategories(String key,String value, String productName){
        createTestRecord(productName);
        RestRequest request = new RestRequest();    
        RestResponse response = new RestResponse();   
        request.requestUri = 'https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/categories/products';
        request.httpMethod = 'GET';
        request.addParameter(key,value);
        RestContext.request = request;
        RestContext.response = response;
        CategoryRestResource.getCategories();
    }
    static void testGetCategories(String key1,String value1,String key2,String value2,String productName){
        createTestRecord(productName);
        RestRequest request = new RestRequest();    
        RestResponse response = new RestResponse();   
        request.requestUri = 'https://hon-aero--apttusdev.my.salesforce.com/services/apexrest/categories/products';
        request.httpMethod = 'GET';
        request.addParameter(key1,value1);
        request.addParameter(key2,value2);
        RestContext.request = request;
        RestContext.response = response;
        CategoryRestResource.getCategories();
    }
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
}