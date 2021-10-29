@isTest
public class BGAProductCategory_REST_Test {
    
    @testSetup static void getData(){
       
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        insert acc;
        
        List<Contact> conList = new List<Contact>();
        Contact con = new Contact();
        con.LastName = 'Gupta';
        con.FirstName = 'Sumit';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sumit13.gupta@nttdata.com';
        con.Email='sumit13.gupta@nttdata.com';
        con.Mobile_App_Role__c=Label.BGAMob_MechanicalFSE;
        con.Mobile_Directory_App__c = true;
        conList.add(con);
        
        Contact con1 = new Contact();
        con1.LastName = 'Gupta1';
        con1.FirstName = 'Sumit';
        con1.AccountId = acc.Id;
        con1.Primary_Email_Address__c = 'sumit13.gupta@nttdata.com';
        con1.Email='sumit13.gupta@nttdata.com';
        con1.Mobile_App_Role__c=Label.BGAMob_MechanicalFSE;
        con1.Mobile_Directory_App__c = true;
        conList.add(con1);
        insert conList;
        
        List<Skills2__c> skill2List = new List<Skills2__c>();
        Skills2__c skill1 = new Skills2__c();
        skill1.Contact__c=con.Id;
        skill1.Skill_Type__c='Area Covered US';
        skill1.Skill_Value__c='New York';
        skill2List.add(skill1);
        
        Skills2__c skill2 = new Skills2__c();
        skill2.Contact__c=con.Id;
        skill2.Skill_Type__c='Areas Covered Intl A-K';
        skill2.Skill_Value__c='India';
        skill2List.add(skill2);
        
        Skills2__c skill = new Skills2__c();
        skill.Contact__c=con.Id;
        skill.Skill_Value__c='Test Avionics';
        skill2List.add(skill);
        insert skill2List;
        
        Skill_DataBase__c sd = new Skill_DataBase__c();
        sd.Master_Skill_Type__c='Test Skill';
        sd.Mobile_App_Products_Description__c='TEst Description';
        sd.Product_Ext__c='Test Product';
        sd.Mobile_App_Products_Image_Url__c='Test URL';
        sd.Skill_Type__c='Mobile App Products';
        sd.Skill_Value__c='Mechanical Other';
        sd.Value1__c='Test Value1';
        sd.Value2__c='Test Value2';
        sd.Value3__c='Test Value3';
        insert sd;
        
        Skill_DataBase__c sd1 = new Skill_DataBase__c();
        sd1.Master_Skill_Type__c='Test Skill';
        sd1.Mobile_App_Products_Description__c='TEst Description';
        sd1.Product_Ext__c='Test Product';
        sd1.Mobile_App_Products_Image_Url__c='Test URL';
        sd1.Skill_Type__c='Mobile App Products';
        sd1.Skill_Value__c='Test Mechanical';
        sd1.Value1__c='Avionics';
        sd1.Value2__c='Test Value2';
        sd1.Value3__c='Test Value3';
        insert sd1;
        
        Skill_DataBase__c sd2 = new Skill_DataBase__c();
        sd2.Master_Skill_Type__c='Test Skill';
        sd2.Mobile_App_Products_Description__c='TEst Description';
        sd2.Product_Ext__c='Test Product';
        sd2.Mobile_App_Products_Image_Url__c='Test URL';
        sd2.Skill_Type__c='Mobile App Products';
        sd2.Skill_Value__c='Test Mechanical';
        sd2.Value1__c='Mechanical';
        sd2.Value2__c='Test Value2';
        sd2.Value3__c='Test Value3';
        insert sd2;
        
        Skill_DataBase__c sd3 = new Skill_DataBase__c();
        sd3.Master_Skill_Type__c='Test Skill';
        sd3.Mobile_App_Products_Description__c='TEst Description';
        sd3.Product_Ext__c='Test Product';
        sd3.Mobile_App_Products_Image_Url__c='Test URL';
        sd3.Skill_Type__c='Mobile App Products';
        sd3.Skill_Value__c='Test Avionics';
        sd3.Value1__c='Avionics';
        sd3.Value2__c='Test Value2';
        sd3.Value3__c='Test Value3';
        insert sd3;
        
        DirectAccessInformation__c d1 = new DirectAccessInformation__c(Name='DirectAccess_TechnicalExpert',Email__c='abc@abc.com',PrimaryNoUSA__c='1234587894');
        insert d1;
        DirectAccessInformation__c d2 = new DirectAccessInformation__c(Name='DirectAccess_TS_ContactEmail',PhoneNo__c='124578963',Email__c='abc11@abc.com');
        insert d2;
        
    }
    
    static testMethod void testgetProduct(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/technicalexpert';  
        req.addParameter('method', 'getProduct');
        req.addParameter('prod', 'all');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGAProductCategory_REST.bgaProductCatGet();
        Test.stopTest();
    }
    static testMethod void testgetProductfilter(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/technicalexpert';  
        req.addParameter('method', 'getProductfilter');
        req.addParameter('prod', 'all');
        req.addParameter('region', 'Area Covered US');
        req.addParameter('state', 'New York');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGAProductCategory_REST.bgaProductCatGet();
        Test.stopTest();
    }
    
    static testMethod void testgetProductfilter1(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/technicalexpert';  
        req.addParameter('method', 'getProductfilter');
        req.addParameter('prod', 'all');
        req.addParameter('region', 'India');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGAProductCategory_REST.bgaProductCatGet();
        Test.stopTest();
    }
    static testMethod void testgetTSElist(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/technicalexpert';  
        req.addParameter('method', 'getTSElist');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGAProductCategory_REST.bgaProductCatGet();
        Test.stopTest();
    }
    static testMethod void testgetTollfreeno(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/technicalexpert';  
        req.addParameter('method', 'getTollfreeno');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGAProductCategory_REST.bgaProductCatGet();
        Test.stopTest();
    }
    static testMethod void testgetTollfreenodetails(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/technicalexpert';  
        req.addParameter('method', 'getTollfreenodetails');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGAProductCategory_REST.bgaProductCatGet();
        Test.stopTest();
    }
    static testMethod void testgetcontactlst(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        List<Skill_DataBase__c> sDB = [SELECT id FROM Skill_DataBase__c WHERE Skill_Value__c='Test Avionics' LIMIT 1];
        req.requestURI = '/services/apexrest/technicalexpert';  
        req.addParameter('method', 'getcontactlst');
        req.addParameter('skillSetId', sDB[0].Id);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGAProductCategory_REST.bgaProductCatGet();
        Test.stopTest();
    }
    static testMethod void testgetContactdetails(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        List<contact> conList = [SELECT id,Name FROM Contact LIMIT 1];
        req.requestURI = '/services/apexrest/technicalexpert';  
        req.addParameter('method', 'getContactdetails');
        req.addParameter('strid', conList[0].Name);
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGAProductCategory_REST.bgaProductCatGet();
        Test.stopTest();
    }
    static testMethod void testgetEscalationContact(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/technicalexpert';  
        req.addParameter('method', 'getEscalationContact');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGAProductCategory_REST.bgaProductCatGet();
        Test.stopTest();
    }
    static testMethod void testgetgetContact(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/technicalexpert';  
        req.addParameter('method', 'getContact');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGAProductCategory_REST.bgaProductCatGet();
        Test.stopTest();
    }
    static testMethod void testgetContact1(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/technicalexpert';  
        req.addParameter('method', 'getContact1');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGAProductCategory_REST.bgaProductCatGet();
        Test.stopTest();
    }
    static testMethod void testgetContactlist1(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/technicalexpert';  
        req.addParameter('method', 'getContactlist1');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGAProductCategory_REST.bgaProductCatGet();
        Test.stopTest();
    }
    static testMethod void testgetProductdeatils(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/technicalexpert';  
        req.addParameter('method', 'getProductdeatils');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGAProductCategory_REST.bgaProductCatGet();
        Test.stopTest();
    }
    static testMethod void testgetcontactlist(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/technicalexpert';  
        req.addParameter('method', 'getcontactlist');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGAProductCategory_REST.bgaProductCatGet();
        Test.stopTest();
    }
    static testMethod void testsupport(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/technicalexpert';  
        req.addParameter('method', 'support');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGAProductCategory_REST.bgaProductCatGet();
        Test.stopTest();
    }
    static testMethod void getSkillListTest(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/technicalexpert';  
        req.addParameter('method', 'allskills');
        req.addParameter('region', 'Area Covered US');
        req.addParameter('state', 'New York');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGAProductCategory_REST.bgaProductCatGet();
        Test.stopTest();
    }
    static testMethod void testNoData(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/technicalexpert';  
        //req.addParameter('method', 'getContact1');
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        BGAProductCategory_REST.bgaProductCatGet();
        Test.stopTest();
    }
}