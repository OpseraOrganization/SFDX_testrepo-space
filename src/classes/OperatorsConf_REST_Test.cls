@isTest
public class OperatorsConf_REST_Test {
    public static testmethod  void  testDoGET(){        
        event__c eve = new event__c();
        eve.name = 'test';
        eve.Location__c='test';
        eve.Website__c= 'www.google.com';
        eve.Start_Date__c = system.today().addDays(1);
        eve.Active__c = true;
        eve.type__C = 'BGA Events';        
        insert eve;
        
        
        event__c eve1 = new event__c();
        eve1.name = 'test';
        eve1.Location__c='test';
        eve1.Website__c= 'www.google.com';
        eve1.Start_Date__c = system.today().addDays(1);
        eve.Active__c = true;
        eve.type__C = 'BGA Events';        
        insert eve1;
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/bgawebtocase';  
        req.httpMethod = 'GET';
        
        RestContext.request = req;
        RestContext.response = res;
        OperatorsConf_REST.getConferences();
        
        DirectAccess_operatorconference controller = new DirectAccess_operatorconference();
        String pgURL = controller.phoneGapUrl;
    }
}