// Clicktools 2nd September 2010
/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 * Modification History  :
 * Date             Version No.    Modified by           Brief Description of Modification
 * Nov-08-2013      1.0            NTTDATA               Wrapping the testmethod with Start and Stop
 * Oct-29-2014      2.0            NTTDATA               INC000006793729 # Updated Cilick Tool URL
 * July-07-2017      3.0            NTTDATA              PRJ11585 Aero Improve SFDC for Conectivity Service updateclicktoolurl
 *************************************************************************************************
*/
@isTest(seealldata = true)
private class CreateSurveyURLTest {
    static void UnitTest(String strtype) {
        Test.startTest();
            // test switch
            CreateSurveyURL.testing = true;   
            // create account
            Account acc = new Account(Name = 'Test');
            insert acc;
            // create contact
            Contact con = new Contact(FirstName = 'First', LastName = 'Last', Email = 'support@clicktools.com', Primary_Email_Address__c = 'support@clicktools.com', AccountId = acc.Id, Survey_Opt_Out__c = False, NPS_Survey__c = 'No');
            insert con;         
            string rtId = Label.Case_AOG_RecordType;  
            String rt1 = Label.QuotesRecordID;  
            //Case c = new Case(ContactId = con.Id, RecordTypeId = rtId, ownerId = UserInfo.getUserId(), status='Open', AOG_Process_Type__c='WOR', Type='AOG', x4_hour_aog__c='4-hour',classification__c='ISC',Export_Compliance_Content_ITAR_EAR__c='NO',Government_Compliance_SM_M_Content__c='NO');
            //insert c; 
            
            Case c = new Case();
            c= [SELECT Id from Case LIMIT 1];
            Map<String,String> m = new Map<String,String>(); 
            m.put('&q1', c.Id); 
            CreateSurveyURL.createSurvey(c.id,strtype,m);
            
            Test.stopTest();
    }
    
    static void UnitTest2(String strtype) {
    Test.startTest();
        // test switch
        CreateSurveyURL.testing = true;   
        // create account
        Account acc = new Account(Name = 'Test');
        insert acc;
        // create contact
        Contact con = new Contact(FirstName = 'First', LastName = 'Last', Email = 'support@clicktools.com', Primary_Email_Address__c = 'support@clicktools.com', AccountId = acc.Id, Survey_Opt_Out__c = False, NPS_Survey__c = 'No');
        insert con;         
        string rtId = Label.Case_AOG_RecordType;  
        //String rt1 = Label.QuotesRecordID;  
        //Case c = new Case(ContactId = con.Id, RecordTypeId = rtId, ownerId = UserInfo.getUserId(), status='Open', AOG_Process_Type__c='WOR', Type='AOG', x4_hour_aog__c='4-hour',classification__c='ISC',Export_Compliance_Content_ITAR_EAR__c='NO',Government_Compliance_SM_M_Content__c='NO');
        //insert c; 
        
        
          String rt1 = Label.Repair_Overhaul_Rec_Id;  
            Case c1 = new Case(ContactId = con.Id, RecordTypeId = rt1, ownerId = UserInfo.getUserId(), status='Open',classification__c='CSO OEM',Export_Compliance_Content_ITAR_EAR__c='NO',Government_Compliance_SM_M_Content__c='NO',Sub_Class__c = 'MSP');
            Insert c1;
            
            Map<String,String> m = new Map<String,String>(); 
            m.put('&q1', c1.Id); 
            CreateSurveyURL.createSurvey(c1.id,strtype,m); 
        
        /*Case c = new Case();
        c= [SELECT Id from Case LIMIT 1];
        Map<String,String> m = new Map<String,String>(); 
        m.put('&q1', c.Id); 
        CreateSurveyURL.createSurvey(c.id,strtype,m);*/
        
        Test.stopTest();
    }
   static void UnitTest1(String strtype) {
        Test.startTest();
            // test switch
            CreateSurveyURL.testing = true;   
            // create account
            Account acc = new Account(Name = 'Test');
            insert acc;
            // create contact
            Contact con = new Contact(FirstName = 'First', LastName = 'Last', Email = 'support@clicktools.com', Primary_Email_Address__c = 'support@clicktools.com', AccountId = acc.Id, Survey_Opt_Out__c = False, NPS_Survey__c = 'No');
            insert con;         
            
            String rt1 = Label.Repair_Overhaul_Rec_Id;  
            Case c1 = new Case(ContactId = con.Id, RecordTypeId = rt1, ownerId = UserInfo.getUserId(), status='Open',classification__c='CSO OEM',Export_Compliance_Content_ITAR_EAR__c='NO',Government_Compliance_SM_M_Content__c='NO',Sub_Class__c = 'MSP');
            Insert c1;
            
            Map<String,String> m = new Map<String,String>(); 
            m.put('&q1', c1.Id); 
            CreateSurveyURL.createSurvey(c1.id,strtype,m);
            
            // Set mock callout class 
            Test.setMock(CreateSurveyURL.class, new MockHttpResponseGenerator());
            
            HttpResponse res;
            res.setBody('https://www.google.co.in/');
            // Verify response received contains fake values
            String contentType = res.getHeader('Content-Type');
            System.assert(contentType == 'application/json');
            String actualValue = res.getBody();
            String expectedValue = '{"foo":"bar"}';
            System.assertEquals(actualValue, expectedValue);
            System.assertEquals(200, res.getStatusCode());
            Test.stopTest();
    }
  static testMethod void testcaseGDC()
    {       
        UnitTest('GDC');
    }
    static testMethod void testcaseWebSupport()
    {       
        UnitTest('Web_Support');
    }
    static testMethod void testcaseMSPContract()
    {       
        UnitTest('MSP_Contract');
    }
    static testMethod void testcaseNavDbAccounts()
    {       
        UnitTest('NavDB_Accounts');
    }
    static testMethod void testcaseHAPPMPPContracts()
    {       
        UnitTest('HAPP_MPP_Contracts');
    }
    static testMethod void testcaseAOG()
    {       
        UnitTest('AOG');
    }
   static testMethod void testcaseJXSupport()
    {       
        UnitTest('Jx_Support');
    }
    static testMethod void testcaseFSSTechnicalIssue()
    {       
        UnitTest('FSS_Technical_Issue');
    }
    
    static testMethod void testcaseFSSAccounts()
    {       
        UnitTest('NewURL_PI');
    }
    static testMethod void testcaseAOGATS()
    {       
        UnitTest('AOGATS');
    }
    static testMethod void testcaseTCM()
    {     
        UnitTest('TCM');
    }
     static testMethod void testcaseER()
    {     
        UnitTest('ER');
    }
    static testMethod void testcaseRPh()
    {     
        UnitTest('PhoneOQGRRT');
    }
    static testMethod void testcaseORPh()
    {     
        UnitTest('OrderChangeORT');
    }
     static testMethod void testtest()
    {     
        UnitTest2('test');
    }
     /*static testMethod void testtest2()
    {     
        UnitTest1('test2');
    }*/
    static testMethod void testcaseBK()
    {     
        UnitTest('BK');
    }
    static testMethod void testcaseManual_CpFeedback()
    {     
        UnitTest('Manual_CpFeedback');
    }
    static testMethod void testcaseCustomer_Support()
    {     
        UnitTest('Customer_Support');
    }
    static testMethod void testcaseRGQO()
    {     
        UnitTest('RGQO');
    }
    static testMethod void testcaseManual_General()
    {     
        UnitTest('Manual_General');
    }
    static testMethod void testcaseManual_WebSupport()
    {     
        UnitTest('Manual_WebSupport');
    }
    static testMethod void testcaseServices_Support()
    {     
        UnitTest('Services_Support');
    }
    static testMethod void testcaseGoDirect()
    {     
        UnitTest('GoDirect');
    }

    static testMethod void testcaseBendixKing()
    {     
        UnitTest('BendixKing');
    }

    static testMethod void testcaseEngine_Rentals()
    {     
        UnitTest('Engine_Rentals');
    }

}