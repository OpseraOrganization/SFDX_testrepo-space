@isTest
public class BGACSM_REST_Test {
    
   @testSetup static void getData(){
        Contact c = new Contact(LastName='ABC',Mobile_Directory_App__c = true,Sales_and_Support_Market__c ='Commercial Helicopters');
        insert c;
        Contact c1 = new Contact(LastName='XYZ',Mobile_Directory_App__c = true,Sales_and_Support_Market__c ='Commercial Helicopter'/*Mobile_App_Role__c=??*/);
        insert c1;
        
        
        List<Skills2__c> SkillValueList = new List<Skills2__c>();
        Skills2__c s1 = new Skills2__c(Skill_Type__c='Area Covered US',Contact__c=c.Id );
        SkillValueList.add(s1);
        Skills2__c s2 = new Skills2__c(Skill_Type__c='Area Covered India',Contact__c=c.Id);
        SkillValueList.add(s2);
        Skills2__c s3 = new Skills2__c(Skill_Type__c='Areas Covered Intl A-K',Skill_Value__c='Australia',Contact__c=c.Id);
        SkillValueList.add(s3);
        
        Skills2__c s4 = new Skills2__c(Skill_Type__c='Area Covered US',Contact__c=c1.Id );
        SkillValueList.add(s4);
        Skills2__c s5 = new Skills2__c(Skill_Type__c='Area Covered India',Contact__c=c1.Id);
        SkillValueList.add(s5);
        Skills2__c s6 = new Skills2__c(Skill_Type__c='Areas Covered Intl A-K',Skill_Value__c='Australia',Contact__c=c1.Id);
        SkillValueList.add(s6);
        
        insert SkillValueList;
    }
    
    
    static testMethod void testGetStatevalues(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/bgacsm';  
        req.addParameter('method', 'getStatevalues');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGACSM_REST.bgacsmGet();
        Test.stopTest();
    }
    static testMethod void testGetASMCountryvalues(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/bgacsm';  
        req.addParameter('method', 'getASMCountryvalues');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGACSM_REST.bgacsmGet();
        Test.stopTest();
    }
    static testMethod void testGethelisupport(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/bgacsm';  
        req.addParameter('method', 'gethelisupport');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGACSM_REST.bgacsmGet();
        Test.stopTest();
    }
    static testMethod void testGetASM(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/bgacsm';  
        req.addParameter('method', 'getASM');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGACSM_REST.bgacsmGet();
        Test.stopTest();
    }
    static testMethod void testGetResultValue(){ 
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/bgacsm';  
        req.addParameter('method', 'getResultValue');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGACSM_REST.bgacsmGet();
        Test.stopTest();
    }
    static testMethod void testGetResValue(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/bgacsm';  
        req.addParameter('method', 'getResValue');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGACSM_REST.bgacsmGet();
        Test.stopTest();
    }
    static testMethod void testNoData(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/bgacsm';  
        //req.addParameter('method', 'getResValue');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGACSM_REST.bgacsmGet();
        Test.stopTest();
    }

}