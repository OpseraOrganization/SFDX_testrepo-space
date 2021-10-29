/*
Created By : Swastika Rajkhowa
Created Date : Nov-27-2017
Usages : test class methods for CaseTrigger      
*/
@isTest 
public class CaseTriggerTest {
    @testSetup
    static void setupData() {
         Case cas = (Case)SObjectFactory.create(
               Case.sObjectType, new Map<Schema.SObjectField, Object>
                {   Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Status', 
                    Case.recordtypeid => RecordTypeServices.getRecordTypeByName('Orders','Case').Id ,
                    Case.Status =>'Open',
                    Case.Sub_Status__c => 'WIS',
                    Case.Tool_Name__c=> 'test'
                });  
    }
    static testMethod void testMethodCaseTrigger1()
     {      
        Test.startTest();
        TriggerInactive.testTrigger = true;  
                  
        List<Case>listObjCaseNew = SObjectFactory.create(
               1, Case.sObjectType, new Map<Schema.SObjectField, Object>
                {   Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Status', 
                    Case.recordtypeid => RecordTypeServices.getRecordTypeByName('Orders','Case').Id ,
                    Case.Status =>'Open',
                    Case.Sub_Status__c => 'WIS',
                    Case.Tool_Name__c=> 'test'
                });                 
        Test.stopTest();
     }  
     static testMethod void testMethodCaseTrigger2()
     {      
        Test.startTest();
        TriggerInactive.testTrigger = true;  
        case cas = [SELECT Id FROM Case WHERE Case.Type = 'Order Status'];
        if(cas!=null)          
            Update cas;         
        Test.stopTest();
     }  
      static testMethod void testMethodCaseTrigger3()
     {      
        TriggerInactive.testTrigger = true;  
                  
        List<Case>listObjCaseNew = SObjectFactory.create(
               1, Case.sObjectType, new Map<Schema.SObjectField, Object>
                {   Case.OwnerId => UserInfo.getUserId(),
                    Case.Type => 'Order Status', 
                    Case.recordtypeid => Schema.SObjectType.Case.getRecordTypeInfosByName().get('One-Off Discount').getRecordTypeId(),
                    Case.Status =>'Open',
                    Case.Sub_Status__c => 'WIS',
                    Case.Tool_Name__c=> 'test'
                });                 
     }  
     
     static testmethod void validateCaseInsertLookups(){
       test.starttest();
        Id devRecordTypeId = RecordTypeServices.getRecordTypeByName('One-Off Discount','Case').Id;
        Id OptyRecordTypeId = RecordTypeServices.getRecordTypeByName('AM Standard','Opportunity').Id;
        system.debug('recordtypeid inserted********'+devRecordTypeId);
       // Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        ID newuser = Userinfo.getUserid();
        
        
        Account acc = new Account();
        acc.name ='Test';
        acc.Region_Name__c = 'Americas';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CurrencyIsoCode = 'EUR';
        insert acc;
        
        Contact con = new Contact();
        con.Lastname = 'Test';
        con.SBU_Contact__c = 'ATR';
        con.CurrencyIsoCode = 'EUR';
        con.AccountId = acc.id;
        con.Contact_Status__c = 'Active';
        insert con;
        
        Platform__c pf = new Platform__c();
        pf.Name = 'Test';
        pf.CurrencyIsoCode = 'EUR';
        Insert pf;
        
        Opportunity opp = new Opportunity();
        opp.Name='Test';
        opp.AccountId = acc.id;
        opp.Platform__c = pf.id;
        opp.SBU__c = 'ATR';
        opp.StageName ='Prospecting';
        opp.CloseDate = System.today();
        opp.CurrencyIsoCode = 'EUR';
        opp.Tech_Sales__c = 'AT';
        opp.Prime_Sub__c = 'Joint Venture';
        opp.Contract_Type__c = 'BPA';
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'Bridge';
        opp.International_Code__c = 'Domestic';
        opp.Incumbent__c = 'Incumbent';
        opp.RecordTypeId = OptyRecordTypeId;
        insert opp;
        
        
         Profile profileId = [SELECT Id FROM Profile WHERE Name = 'One off Community Profile' LIMIT 1];
        
        
        User newuser111 = new User(LastName = 'Test',
                                FirstName='Myname',
                                Alias = 'tmlv',
                                Email = 'Test.mytest@abc.com',
                                Username = 'test.mytests@abcd.com',
                                ProfileId = profileId.id,
                                TimeZoneSidKey = 'GMT',
                                LanguageLocaleKey = 'en_US',
                                EmailEncodingKey = 'UTF-8',
                                LocaleSidKey = 'en_US',
                                ContactId = con.id
                               );
        insert newuser111;
        
         Case newcase11=new Case(recordTypeId = devRecordTypeId,subject='Fax:{9986502495} test data',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No', ContactId=con.id,AccountId = acc.id,
                Type='Order',Customer_PO_RO_WONumber__c='43545',workstrem__c='Spares' ,CSM_Region__c='EMEAI',FSE_Name_1__c=Userinfo.getUserid(),FSE_Name_2__c=Userinfo.getUserid(),FSE_Name_3__c=Userinfo.getUserid(),
                Sub_Status__c='Rejected' , Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com');
        
         try{
             insert newcase11;
             }
          catch(Exception e)
          {
          system.debug('exception in RDF_EscalatedToInsert_Test class'+e);
          }   
         
         test.stoptest();
    }  
    
}