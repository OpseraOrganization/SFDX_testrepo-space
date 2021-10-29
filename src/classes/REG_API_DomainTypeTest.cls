@isTest
public class REG_API_DomainTypeTest {
    
    @TestSetup
    static void fncDataSetup() {
        Reg_TestDataFactory.createTestRecords();        
    }
    
    public static TestMethod void restTest(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'apexrest/domain/testdomain.com';
        req.httpMethod = 'GET';//HTTP Request Type
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        REG_API_DomainType.doGet();
        Test.stopTest();
        String result = res.responseBody.toString();
        List<sObject> sobjectList = (List<sObject>)JSON.deserialize(result, List<sObject>.class);
        System.assert(!sobjectList.isEmpty());
    }
    
    public static TestMethod void restTestDomainDoesNotExist(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'apexrest/domain/tcsdomain.com';
        req.httpMethod = 'GET';//HTTP Request Type
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        REG_API_DomainType.doGet();
        Test.stopTest();
        //String result = res.responseBody.toString();
        //List<sObject> sobjectList = (List<sObject>)JSON.deserialize(result, List<sObject>.class);
        //System.assert(!sobjectList.isEmpty());
    }    
    public static TestMethod void restTestInternal(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'apexrest/domain/internal';
        req.httpMethod = 'GET';//HTTP Request Type
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        REG_API_DomainType.doGet();
        Test.stopTest();
        String result = res.responseBody.toString();
        List<sObject> sobjectList = (List<sObject>)JSON.deserialize(result, List<sObject>.class);
        System.assert(!sobjectList.isEmpty());
    } 
    public static TestMethod void restTestExternal(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'apexrest/domain/external';
        req.httpMethod = 'GET';//HTTP Request Type
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        REG_API_DomainType.doGet();
        Test.stopTest();
        String result = res.responseBody.toString();
        List<sObject> sobjectList = (List<sObject>)JSON.deserialize(result, List<sObject>.class);
        System.assert(!sobjectList.isEmpty());
    }       
    public static TestMethod void restInvalidDomainTest(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'apexrest/domain/ ';
        req.httpMethod = 'GET';//HTTP Request Type
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        REG_API_DomainType.doGet();
        Test.stopTest();
        String result = res.responseBody.toString();
        System.assert(result!=Null);
    }
    
    public static TestMethod void restInvalidDomainTest1(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = 'apexrest/domain/';
        req.httpMethod = 'GET';//HTTP Request Type
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        REG_API_DomainType.doGet();
        Test.stopTest();
        String result = res.responseBody.toString();
        System.assert(result!=Null);
    }
}