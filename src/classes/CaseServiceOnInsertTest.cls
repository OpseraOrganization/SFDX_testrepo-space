/**
  *Created By : Swastika Rajkhowa
  *Created Date : Nov-27-2017
  *Usages : test class methods for CaseServiceOnInsert methods       
  */
@isTest 
public class CaseServiceOnInsertTest {
    
    static final Integer CASE_COUNT_PROVIDE = 1;
    static final Integer CASE_MATRIX_COUNT = 2;
    
    static final String rtIdOrders = RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id;
    static final String rtIdTechIssue = RecordTypeServices.getRecordTypeByName('Technical Issue', 'Case').Id;
    static final String rtIdRepairOverhaul = RecordTypeServices.getRecordTypeByName('Repair & Overhaul','Case').Id; //01230000000Zen5AAC
    static final String rtIdDSClearingHouse = RecordTypeServices.getRecordTypeByName('D&S Clearing House Proposal','Case').Id; //01230000000cN6e
    static final String rtIdA350FTTeschIssue = RecordTypeServices.getRecordTypeByName('A350 FT/EIS Tech Issue','Case').Id; //012a0000001ZPNjAAO
    static final String rtIdQuotes = RecordTypeServices.getRecordTypeByName('Quotes','Case').Id; //01230000000Zen4AAC
    static final String rtIdOEMQuoteOrders = RecordTypeServices.getRecordTypeByName('OEM Quotes Orders','Case').Id; //012a0000001ZLs9AAG
    static final String rtIdDSQuotesOrders = RecordTypeServices.getRecordTypeByName('D&S Quotes Orders','Case').Id; //01230000000Zemz
    static final String rtIdCSMToolbox = RecordTypeServices.getRecordTypeByName('CSM Toolbox','Case').Id; //01230000000bTK4
    
    static List<Case> listCaseOrder = new List<Case>();
    static List<Case> listCaseTech = new List<Case>();
    static List<Case> listCaseRepair = new List<Case>();
    static List<Case> listCaseDSClearing = new List<Case>();
    static List<Case> listCaseA350FT = new List<Case>();
    static List<Case> listCaseQuotes = new List<Case>();
    static List<Case> listCaseOEMQuote = new List<Case>();
    static List<Case> listCaseDSQuote = new List<Case>();
    static List<Case> listCaseOrderOld = new List<Case>();
    static List<Case> listCaseCSMToolbox = new List<Case>();
    
    static Profile adminProfile;
    static List<User> lstUser = new List<User>();
    static List<Group> lstgrpId = new List<Group>();
    static List<Country__c> lstCountry = new List<Country__c>();
    static List<Account> lstAccount = new List<Account>();

    static List<Case> list_CaseOrder10;
    static User currentUser;
    static Account accountWithBGA;
    static Account accountWithATR;
    static Contact contactWithBGA;
    static Contact contactWithATR;
    static Id recId; 
    static final Integer CASE_COUNT = 10;
    static Account accountWithCbtTeam;
    static Account accountWithoutCbtTeam;

    @testSetup
    static void setupData() {
        test.startTest();
        TriggerInactive.testTrigger = false;
        Profile p1 = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        User testUser = (User)SObjectFactory.create(User.sObjectType,new Map<Schema.SObjectField, Object>{
                    User.FirstName => 'TestFirstName',
                    User.LastName => 'TestLastName',
                    User.Email => 'test_radha@in.ibm.com',
                    User.Username => 'test_radha@in.ibm.com',
                    User.Alias => 'TestF',
                    User.ProfileId => p1.Id,
                    User.TimeZoneSidKey => 'America/Denver',
                    User.LocaleSidKey => 'en_US',
                    User.EmailEncodingKey => 'UTF-8',
                    User.LanguageLocaleKey => 'en_US'
                });
        account objAccount= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
                    account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account',
                    account.type => 'Energy'           
                });
        contact objContact= (contact)SObjectFactory.create(contact.sObjectType, new Map<Schema.SObjectField, Object>{
                    contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test last name',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'shilpabhatia@in.ibm.com'
                });  
        account objAccount1 = (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
                    account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test 34Account Energy',
                    account.Customer_Status__c =>'Active',
                    account.Strategic_Business_Unit__c => 'BGA',
                    account.CBT__c => 'Airbus',
                    account.Region_Name__c => 'Americas',
                    account.Sub_Region_Name__c => 'Canada',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr', 
                    account.Type => 'Leasing Company',
                    account.REPORT_ACCOUNT_NAME__c => 'Test Account',
                    account.Market_Name__c => 'Marine'
                });  
        account objAccount2= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
                    account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test 56Account OEM',
                    account.type => 'OEM',
                    account.Customer_Status__c =>'Active',
                    account.Strategic_Business_Unit__c => 'ATR',
                    account.CBT__c => 'Airbus',
                    account.Region_Name__c => 'Americas',
                    account.Sub_Region_Name__c => 'Canada',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',
                    account.Type => 'OEM',
                    account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                    account.Market_Name__c => 'Marine'           
                });  
       
        contact Contact1= (contact)SObjectFactory.create(contact.sObjectType, new Map<Schema.SObjectField, Object>{
                   contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test last name12',
                    contact.AccountId => objAccount1.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'shilpabhatia1@in.ibm.com'
                }); 
        contact Contact2= (contact)SObjectFactory.create(contact.sObjectType, new Map<Schema.SObjectField, Object>{ 
                   contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test last name34',
                    contact.AccountId => objAccount2.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'shilpabhatia2@in.ibm.com'
            });
        System.runAs(testUser){
            List<Case>listObjCaseNew = SObjectFactory.create(1, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.OwnerId => UserInfo.getUserId(),
                    //commented by Radha
                    //Case.Type => 'Order Status', 
                    Case.recordtypeid => RecordTypeServices.getRecordTypeByName('Technical Issue','Case').Id ,
                    Case.Status =>'Open',
                    Case.Sub_Status__c => 'Waiting for TCT',  
                    Case.ContactId => objContact.Id,
                    Case.Tool_Name__c=> 'test'
                });
            /*List<Technical_Issue_Case_Extensions__c>listObjTechIssue = SObjectFactory.create(
                1, Technical_Issue_Case_Extensions__c.sObjectType, new Map<Schema.SObjectField, Object>{
                    Technical_Issue_Case_Extensions__c.Name => 'test',
                    Technical_Issue_Case_Extensions__c.Case_object__c=>listObjCaseNew[0].Id 
                });*/
        }
        test.stoptest();             
    } 

    //Start of setup Methods From AfterInsertHelperClass
    static void setup(){
        TriggerInactive.testTrigger = false;
        Profile p1 = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        ID recordTypeIdTechIssue = RecordTypeServices.getRecordTypeByName('Technical Issue', 'Case').Id;  
        User testUser = (User)SObjectFactory.create(User.sObjectType,new Map<Schema.SObjectField, Object>{
                    User.FirstName => 'TestFirstName',
                    User.LastName => 'TestLastName',
                    User.Email => 'test_radha@in.ibm.com',
                    User.Username => 'test_radha@in.ibm.com',
                    User.Alias => 'TestF',
                    User.ProfileId => p1.Id,
                    User.TimeZoneSidKey => 'America/Denver',
                    User.LocaleSidKey => 'en_US',
                    User.EmailEncodingKey => 'UTF-8',
                    User.LanguageLocaleKey => 'en_US'
                });
        account objAccount= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
                    account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c =>'Aero Level'        
                });
        contact objContact= (contact)SObjectFactory.create(contact.sObjectType, new Map<Schema.SObjectField, Object>{
                    contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test last name',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343'     
                });
        System.runAs(testUser){
        List<Case>listObjCaseNew = SObjectFactory.create(1, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'Order Status', 
                Case.recordtypeid => RecordTypeServices.getRecordTypeByName('Technical Issue','Case').Id ,
                Case.Status =>'Open',
                Case.Sub_Status__c => 'Waiting for TCT',  
                Case.ContactId => objContact.Id,
                Case.Tool_Name__c=> 'test'
            });
        /*List<Technical_Issue_Case_Extensions__c>listObjTechIssue = SObjectFactory.create(
            1, Technical_Issue_Case_Extensions__c.sObjectType, new Map<Schema.SObjectField, Object>{
                Technical_Issue_Case_Extensions__c.Name => 'test',
                Technical_Issue_Case_Extensions__c.Case_object__c=>listObjCaseNew[0].Id 
            });*/
        }
    } 
    
    static testMethod void testCaseHandlerBeforeInsert_EmailQuotes(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Account accountWithBGA= [SELECT Id FROM Account WHERE name=:'Test 34Account Energy'];
            Contact contactWithBGA = [SELECT Id FROM Contact WHERE AccountId=:AccountWithBGA.Id];
            Set<Id> setCaseIds= new Set<Id>();
            recId = RecordTypeServices.getRecordTypeByName('WEB Portal Registration','Case').Id; 
            
            List<Case> list_CaseOrder= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.Origin => 'Email-Quotes',
                    Case.Status => 'Open',
                    Case.Sub_Status__c=>'Waiting for TCT',
                    Case.Subject=>'OCD Updates 620',
                    Case.Ownerid => label.ATR_API_User_id,
                    Case.RecordTypeId=> recId,
                    Case.Tool_Name__c=>'MCORE',
                    Case.Classification__c => 'US ACT Internal',
                    Case.ContactId =>contactWithBGA.Id,
                    Case.AccountId=>accountWithBGA.id,
                    Case.Requested_By_HON_Internal__c=> contactWithBGA.Id,
                    Case.Type => 'Other',
                    Case.CSM_Region__c => 'Americas',
                    Case.Workstrem__c => 'Spares',
                    Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                    Case.Government_Compliance_SM_M_Content__c => 'NO',
                    Case.CEC_Record_Type__c => 'C3 Test CEC Technical Issue'//,
                });
            CaseHandler objCaseHandler = new CaseHandler(true,1);   
            objCaseHandler.onBeforeInsert(list_CaseOrder);      
        }
        Test.stopTest();
    }
    
    static testMethod void testCaseHandlerBeforeInsert_EmailNavDB(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];

        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Account accountWithBGA= [SELECT Id FROM Account WHERE name=:'Test 34Account Energy'];
            Contact contactWithBGA = [SELECT Id FROM Contact WHERE AccountId=:AccountWithBGA.Id];
            Set<Id> setCaseIds= new Set<Id>();
            recId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;       
            List<Case> list_CaseOrder= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.Origin => 'Email-NavDB',
                    Case.Status => 'New',
                    Case.Sub_Status__c=>'Waiting for TCT',
                    Case.Subject=>'HONEYWELL FLIGHT TRACKING REQUESTS',
                    Case.Ownerid => label.NavDB_Accts_Team,
                    Case.RecordTypeId=> recId,
                    Case.Tool_Name__c=>'MCORE',
                    Case.Classification__c => 'R&O Americas Internal',
                    Case.ContactId =>contactWithBGA.Id,
                    Case.AccountId=>accountWithBGA.id,
                    Case.Type => 'Reapir Inquiry',
                    Case.CSM_Region__c => 'Americas',
                    Case.Workstrem__c => 'Repair and Overhaul',
                    Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                    Case.Government_Compliance_SM_M_Content__c => 'NO',
                    Case.CEC_Record_Type__c => 'C4 Test CEC Orders'                               
                });
            for(Case objCase: list_CaseOrder){
                setCaseIds.add(objCase.Id);
            }
            CaseHandler objCaseHandler = new CaseHandler(true,1);   
            objCaseHandler.onBeforeInsert(list_CaseOrder);   
        }   
        Test.stopTest();
    }

    static testMethod void testCaseHandlerBeforeInsert_EmailGDC(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];

        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Account accountWithBGA= [SELECT Id FROM Account WHERE name=:'Test 34Account Energy'];
            Contact contactWithBGA = [SELECT Id FROM Contact WHERE AccountId=:AccountWithBGA.Id];
            Set<Id> setCaseIds= new Set<Id>();
            recId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;       
            List<Case> list_CaseOrder= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.Origin => 'Email-GDC Accounts',
                    Case.Status => 'New',
                    Case.Sub_Status__c=>'Waiting for TCT',
                    Case.Subject=>'ARINC Update',
                    Case.Ownerid => label.NavDB_Accts_Team,
                    Case.RecordTypeId=> recId,
                    Case.Tool_Name__c=>'MCORE',
                    Case.Classification__c => 'R&O Americas Internal',
                    Case.ContactId =>contactWithBGA.Id,
                    Case.AccountId=>accountWithBGA.id,
                    Case.Type => 'Reapir Inquiry',
                    Case.CSM_Region__c => 'Americas',
                    Case.Workstrem__c => 'Repair and Overhaul',
                    Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                    Case.Government_Compliance_SM_M_Content__c => 'NO',
                    Case.CEC_Record_Type__c => 'C4 Test CEC Orders'                               
                });
            for(Case objCase: list_CaseOrder){
                setCaseIds.add(objCase.Id);
            }
            CaseHandler objCaseHandler = new CaseHandler(true,1);   
            objCaseHandler.onBeforeInsert(list_CaseOrder);  
        }   
        Test.stopTest();
    }

    static testMethod void testCaseHandlerBeforeInsert_ExceptionEmail(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;  
            Set<Id> setCaseIds= new Set<Id>();
            recId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;       
            List<Case> list_CaseOrder = new List<Case>();
            
            list_CaseOrder= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.Origin => 'Email-GDC Accounts',
                    Case.Status => 'New',
                    Case.Sub_Status__c=>'Waiting for TCT',
                    Case.Ownerid => label.NavDB_Accts_Team,
                    Case.RecordTypeId=> recId,
                    Case.Tool_Name__c=>'MCORE',
                    Case.Classification__c => 'R&O Americas Internal',
                    Case.Type => 'Reapir Inquiry',
                    Case.CSM_Region__c => 'Americas',
                    Case.Workstrem__c => 'Repair and Overhaul',
                    Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                    Case.Government_Compliance_SM_M_Content__c => 'NO',
                    Case.CEC_Record_Type__c => 'C4 Test CEC Orders'                               
                });            
            for(Case objCase: list_CaseOrder){
                setCaseIds.add(objCase.Id);
            }
            try{
                CaseHandler objCaseHandler = new CaseHandler(true,1);   
                objCaseHandler.onBeforeInsert(list_CaseOrder); 
            }catch(Exception ex){}  
        }       
        Test.stopTest();
    }

    static testMethod void testCaseHandlerBeforeInsert_InvalidSuppliedEmail(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Account accountWithBGA= [SELECT Id FROM Account WHERE name=:'Test 34Account Energy'];
            Contact contactWithBGA = [SELECT Id FROM Contact WHERE AccountId=:AccountWithBGA.Id];
            Set<Id> setCaseIds= new Set<Id>();
            recId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;       
            try{
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                        Case.Origin => 'Email-GDC Accounts',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.SuppliedEmail=>'georgereaver@fgrrb.org',
                        Case.Subject=>'ARINC Update',
                        Case.Ownerid => label.NavDB_Accts_Team,
                        Case.RecordTypeId=> recId,
                        Case.Tool_Name__c=>'MCORE',
                        Case.Classification__c => 'R&O Americas Internal',
                        Case.ContactId =>contactWithBGA.Id,
                        Case.AccountId=>accountWithBGA.id,
                        Case.Type => 'Reapir Inquiry',
                        Case.CSM_Region__c => 'Americas',
                        Case.Workstrem__c => 'Repair and Overhaul',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.CEC_Record_Type__c => 'C4 Test CEC Orders'                               
                    });  
                for(Case objCase: list_CaseOrder){
                setCaseIds.add(objCase.Id);
                }
                CaseHandler objCaseHandler = new CaseHandler(true,1);   
                objCaseHandler.onBeforeInsert(list_CaseOrder); 
            }catch(Exception ex){}     
        }
        Test.stopTest();
    }

    static testMethod void testCaseHandlerBeforeInsert_InvalidSubject(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){         
            TriggerInactive.testTrigger = false;
            Account accountWithBGA= [SELECT Id FROM Account WHERE name=:'Test 34Account Energy'];
            Contact contactWithBGA = [SELECT Id FROM Contact WHERE AccountId=:AccountWithBGA.Id];
            Set<Id> setCaseIds= new Set<Id>();
            recId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;       
            try{
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                        Case.Origin => 'Email-GDC Accounts',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Subject=>'How to Get Paid by Uncle Sam - Many New Topics and WAWF Demo',
                        Case.Ownerid => label.NavDB_Accts_Team,
                        Case.RecordTypeId=> recId,
                        Case.Tool_Name__c=>'MCORE',
                        Case.Classification__c => 'R&O Americas Internal',
                        Case.ContactId =>contactWithBGA.Id,
                        Case.AccountId=>accountWithBGA.id,
                        Case.Type => 'Reapir Inquiry',
                        Case.CSM_Region__c => 'Americas',
                        Case.Workstrem__c => 'Repair and Overhaul',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.CEC_Record_Type__c => 'C4 Test CEC Orders'                               
                    });
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                CaseHandler objCaseHandler = new CaseHandler(true,1);   
                objCaseHandler.onBeforeInsert(list_CaseOrder); 
            }catch(Exception ex){}
        }
        Test.stopTest();    
    }
 
    static testMethod void testCaseHandlerBeforeInsert_EMSOrders(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Account accountWithBGA= [SELECT Id FROM Account WHERE name=:'Test 34Account Energy'];
            Contact contactWithBGA = [SELECT Id FROM Contact WHERE AccountId=:AccountWithBGA.Id];
            Set<Id> setCaseIds= new Set<Id>();
            User currentUser1 = (User) SObjectFactory.create(
                User.SObjectType, new Map<SObjectField, Object>{
                    User.Alias => 'hasrole',
                    User.Email => 'userwithrole@mail.com',
                    User.EmailEncodingKey => 'UTF-8',
                    User.LastName => 'Testing',
                    User.LanguageLocaleKey => 'en_US',
                    User.LocalesIdKey => 'en_US',
                    User.ProfileId => UserInfo.getProfileId(),
                    User.TimezonesIdKey => 'America/Los_Angeles',
                    User.Username => 'userwithrole@mail.com'
                }); 
            recId = RecordTypeServices.getRecordTypeByName('EMS Orders','Case').Id;   
            List<Case> list_CaseOrder = new List<Case>();    
            System.runAs(currentUser1){
                list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                        Case.Origin => 'Email-Orders',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Subject=>'ARINC Update',
                        Case.Ownerid => currentUser1.id,
                        Case.RecordTypeId=> recId,
                        Case.Tool_Name__c=>'MCORE',
                        Case.Classification__c => 'R&O Americas Internal',
                        Case.ContactId =>contactWithBGA.Id,
                        Case.AccountId=>accountWithBGA.id,
                        Case.Type => 'Reapir Inquiry',
                        Case.CSM_Region__c => 'Americas',
                        Case.Workstrem__c => 'Repair and Overhaul',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.CEC_Record_Type__c => 'C4 Test CEC Orders'                               
                    });
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
            } 
            System.runAs(currentUser1){    
                CaseHandler objCaseHandler = new CaseHandler(true,1);   
                objCaseHandler.onBeforeInsert(list_CaseOrder);      
            }
        }
        Test.stopTest();
    }
    
    static testMethod void testCaseHandlerBeforeInsert_PilotRecordType(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Account accountWithBGA= [SELECT Id FROM Account WHERE name=:'Test 34Account Energy'];
            Contact contactWithBGA = [SELECT Id FROM Contact WHERE AccountId=:AccountWithBGA.Id];
            Set<Id> setCaseIds= new Set<Id>();
            recId = RecordTypeServices.getRecordTypeByName('Pilot’s Corner Avionics','Case').Id;       
            List<Case> list_CaseOrder= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.Origin => 'Email-GDC Accounts',
                    Case.Status => 'New',
                    Case.Sub_Status__c=>'Waiting for TCT',
                    Case.Subject=>'ARINC Update',
                    Case.Ownerid => label.NavDB_Accts_Team,
                    Case.RecordTypeId=> recId,
                    Case.Tool_Name__c=>'MCORE',
                    Case.Classification__c => 'R&O Americas Internal',
                    Case.ContactId =>contactWithBGA.Id,
                    Case.AccountId=>accountWithBGA.id,
                    Case.Type => 'Reapir Inquiry',
                    Case.CSM_Region__c => 'Americas',
                    Case.Workstrem__c => 'Repair and Overhaul',
                    Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                    Case.Government_Compliance_SM_M_Content__c => 'NO',
                    Case.CEC_Record_Type__c => 'C4 Test CEC Orders'                               
                });
            for(Case objCase: list_CaseOrder){
                setCaseIds.add(objCase.Id);
            }
            CaseHandler objCaseHandler = new CaseHandler(true,1);   
            objCaseHandler.onBeforeInsert(list_CaseOrder); 
        }     
        Test.stopTest();
    }

    static testMethod void testCaseHandlerBeforeInsert_EmailCSODefects(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Account accountWithBGA= [SELECT Id FROM Account WHERE name=:'Test 34Account Energy'];
            Contact contactWithBGA = [SELECT Id FROM Contact WHERE AccountId=:AccountWithBGA.Id];
            Set<Id> setCaseIds= new Set<Id>();
            recId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;       
            List<Case> list_CaseOrder= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.Origin => 'Email-CSODefects',
                    Case.Status => 'New',
                    Case.Sub_Status__c=>'Waiting for TCT',
                    Case.Ownerid => Label.NavDB_Accts_Team,
                    Case.Emailbox_Origin__c=>'Email-CSODefects',
                    Case.SuppliedEmail=>'DDIC@honeywell.com',
                    Case.RecordTypeId=> recId,
                    Case.Classification__c => 'R&O Americas Internal',
                    Case.ContactId => contactWithBGA.Id,
                    Case.AccountId=> accountWithBGA.id,
                    Case.Type =>'Reapir Inquiry',
                    Case.CSM_Region__c => 'Americas',
                    Case.Workstrem__c => 'Repair and Overhaul',
                    Case.SBU_w2c__c => 'BGA',
                    Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                    Case.Government_Compliance_SM_M_Content__c => 'NO',
                    Case.Subject => 'QNext',
                    Case.CEC_Record_Type__c => 'C4 Test CEC Orders' 
                }); 
            for(Case objCase: list_CaseOrder){
                setCaseIds.add(objCase.Id);
            }   
            CaseHandler objCaseHandler = new CaseHandler(true,1);   
            objCaseHandler.onBeforeInsert(list_CaseOrder);    
        } 
        Test.stopTest();
    }

    static testMethod void testCaseHandlerBeforeInsert_DeferredOrdersWeb(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Account accountWithBGA= [SELECT Id FROM Account WHERE name=:'Test 34Account Energy'];
            Contact contactWithBGA = [SELECT Id FROM Contact WHERE AccountId=:AccountWithBGA.Id];
            Set<Id> setCaseIds= new Set<Id>();
            recId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;       
            List<Case> list_CaseOrder= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.Origin => 'Email-deferredordersweb',
                    Case.Status => 'New',
                    Case.Sub_Status__c=>'Waiting for TCT',
                    Case.Ownerid => Label.NavDB_Accts_Team,
                    Case.Emailbox_Origin__c=>'Email-deferredordersweb',
                    Case.SuppliedEmail=>'CTSEFTCW@HONEYWELL.COM',
                    Case.RecordTypeId=> recId ,
                    Case.Classification__c => 'R&O Americas Internal',
                    Case.ContactId => contactWithBGA.Id,
                    Case.AccountId=>accountWithBGA.id,
                    Case.Type =>'Reapir Inquiry',
                    Case.CSM_Region__c => 'Americas',
                    Case.Workstrem__c => 'Repair and Overhaul',
                    Case.SBU_w2c__c => 'BGA',
                    Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                    Case.Government_Compliance_SM_M_Content__c => 'NO',
                    Case.Subject => 'Sub : [Deferred orders from web | Star of week | Right of Day |Release|SPEX]',
                    Case.CEC_Record_Type__c => 'C4 Test CEC Orders'                 
                });  
            for(Case objCase: list_CaseOrder){
                setCaseIds.add(objCase.Id);
            }
            CaseHandler objCaseHandler = new CaseHandler(true,1);   
            objCaseHandler.onBeforeInsert(list_CaseOrder);  
        }   
        Test.stopTest();
    }

    static testMethod void testCaseHandlerBeforeInsert_EmailTrandsupport(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Account accountWithBGA= [SELECT Id FROM Account WHERE name=:'Test 34Account Energy'];
            Contact contactWithBGA = [SELECT Id FROM Contact WHERE AccountId=:AccountWithBGA.Id];
            Set<Id> setCaseIds= new Set<Id>();
            recId = RecordTypeServices.getRecordTypeByName('CAMP Issues','Case').Id;       
            try{
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                        Case.Origin => 'Email-trandsupport',             
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Ownerid => Label.NavDB_Accts_Team,
                        Case.Emailbox_Origin__c=>'Email-trandsupport',
                        Case.SuppliedEmail=>'abc@gulfstream.com',
                        Case.RecordTypeId=> recId ,
                        Case.Classification__c => 'R&O Americas Internal',
                        Case.ContactId => contactWithBGA.Id,
                        Case.AccountId=>accountWithBGA.id,
                        Case.Type =>'Reapir Inquiry',
                        Case.CSM_Region__c => 'Americas',
                        Case.Workstrem__c => 'Repair and Overhaul',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.Subject => 'Welcome 1234567890',
                        Case.CEC_Record_Type__c => 'C4 Test CEC Orders'      
                    });  
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                CaseHandler objCaseHandler = new CaseHandler(true,1);   
                objCaseHandler.onBeforeInsert(list_CaseOrder);     
            }catch(Exception e){}
        }
        Test.stopTest();
    }

    static testMethod void testCaseHandlerBeforeInsert_Email_ACTinternal_1(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            List<Case> list_CaseOrder= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.Origin => 'Email-ACTinternal',
                    Case.Status => 'New',
                    Case.Sub_Status__c=>'Waiting for TCT',
                    Case.Subject=>'ARINC Update',
                    Case.Ownerid => label.NavDB_Accts_Team
            });
            CaseHandler objCaseHandler = new CaseHandler(true,1);   
            objCaseHandler.onBeforeInsert(list_CaseOrder);  
        }
        Test.stopTest();
    }
    
    static testMethod void testCaseHandlerBeforeInsert_Email_ACTinternal_2(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            List<Case> list_CaseOrder= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.Origin => 'Email-EMEAACTInternal',
                    Case.Status => 'New',
                    Case.Sub_Status__c=>'Waiting for TCT',
                    Case.Subject=>'ARINC Update',
                    Case.Ownerid => label.NavDB_Accts_Team
            });
            CaseHandler objCaseHandler = new CaseHandler(true,1);   
            objCaseHandler.onBeforeInsert(list_CaseOrder);  
        }
        Test.stopTest();
    }
    
    static testMethod void testCaseHandlerBeforeInsert_Email_ACTinternal_3(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            List<Case> list_CaseOrder= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.Origin => 'Email-APACACTinternal',
                    Case.Status => 'New',
                    Case.Sub_Status__c=>'Waiting for TCT',
                    Case.Subject=>'ARINC Update',
                    Case.Ownerid => label.NavDB_Accts_Team
            });
            CaseHandler objCaseHandler = new CaseHandler(true,1);   
            objCaseHandler.onBeforeInsert(list_CaseOrder);  
        }
        Test.stopTest();
    }
    
    static testMethod void testCaseHandlerBeforeInsert_Email_ACTinternal_4(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            List<Case> list_CaseOrder= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.Origin => 'Email-RO Americas Internal',
                    Case.Status => 'New',
                    Case.Sub_Status__c=>'Waiting for TCT',
                    Case.Subject=>'ARINC Update',
                    Case.Ownerid => label.NavDB_Accts_Team
            });
            CaseHandler objCaseHandler = new CaseHandler(true,1);   
            objCaseHandler.onBeforeInsert(list_CaseOrder);  
        }
        Test.stopTest();
    }
    
    static testMethod void testCaseHandlerBeforeInsert_Email_ACTinternal_5(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            List<Case> list_CaseOrder= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.Origin => 'Email-RO EMEAI Internal',
                    Case.Status => 'New',
                    Case.Sub_Status__c=>'Waiting for TCT',
                    Case.Subject=>'ARINC Update',
                    Case.Ownerid => label.NavDB_Accts_Team
            });
            CaseHandler objCaseHandler = new CaseHandler(true,1);   
            objCaseHandler.onBeforeInsert(list_CaseOrder);  
        }
        Test.stopTest();
    }
    
    static testMethod void testCaseHandlerBeforeInsert_Email_ACTinternal_6(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            List<Case> list_CaseOrder= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.Origin => 'Email-R&O APAC Internal',
                    Case.Status => 'New',
                    Case.Sub_Status__c=>'Waiting for TCT',
                    Case.Subject=>'ARINC Update',
                    Case.Ownerid => label.NavDB_Accts_Team
            });
            CaseHandler objCaseHandler = new CaseHandler(true,1);   
            objCaseHandler.onBeforeInsert(list_CaseOrder);  
        }
        Test.stopTest();
    }
    
    static testMethod void testCaseHandlerBeforeInsert_Email_ACTinternal_7(){
        Test.startTest(); 
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            List<Case> list_CaseOrder= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.Origin => 'Email-OEM Internal',
                    Case.Status => 'New',
                    Case.Sub_Status__c=>'Waiting for TCT',
                    Case.Subject=>'ARINC Update',
                    Case.Ownerid => label.NavDB_Accts_Team
            });
            CaseHandler objCaseHandler = new CaseHandler(true,1);   
            objCaseHandler.onBeforeInsert(list_CaseOrder);  
        }
        Test.stopTest();
    }
    static testMethod void testCaseHandlerBeforeInsert_EmailTrandsupportNegative(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Set<Id> setCaseIds= new Set<Id>();
            recId = RecordTypeServices.getRecordTypeByName('CAMP Issues','Case').Id;       
            try{
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                        Case.Origin => 'Email-trandsupport',             
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Ownerid => Label.NavDB_Accts_Team,
                        Case.Emailbox_Origin__c=>'Email-trandsupport',
                        Case.SuppliedEmail=>'abc@gulfstream.com',
                        Case.RecordTypeId=> recId ,
                        Case.Classification__c => 'R&O Americas Internal',
                        Case.ContactId => contactWithBGA.Id,
                        Case.AccountId=>accountWithBGA.id,
                        Case.Type =>'Reapir Inquiry',
                        Case.CSM_Region__c => 'Americas',
                        Case.Workstrem__c => 'Repair and Overhaul',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.Subject => 'Welcome to the Conference conducted By IBM',
                        Case.CEC_Record_Type__c => 'C4 Test CEC Orders'      
                    });  
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                CaseHandler objCaseHandler = new CaseHandler(true,1);   
                objCaseHandler.onBeforeInsert(list_CaseOrder);    
            }catch(Exception e){}
        }
        Test.stopTest();
    }


    static testMethod void testCaseHandlerBeforeInsert_EmailCPSQuotesCOE(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Set<Id> setCaseIds= new Set<Id>();
            recId = RecordTypeServices.getRecordTypeByName('CAMP Issues','Case').Id;       
            try{
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                        Case.Origin => 'Email-CPSQuotesCOE',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Subject=>'has sent fax',
                        Case.Ownerid =>  label.aero_default_user_id,
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.SuppliedEmail=>'CTSEFTCW@newslett.com'
                    }); 
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                CaseHandler objCaseHandler = new CaseHandler(true,1);   
                objCaseHandler.onBeforeInsert(list_CaseOrder);   
            }catch(Exception e){}
        }
        Test.stopTest();  
    }

    static testMethod void testCaseHandlerBeforeInsert_EmailGDCFS1(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Set<Id> setCaseIds= new Set<Id>();
            try{
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                        Case.Origin => 'Email-GDC FS1',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Subject=>'Reservation Details',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.Ownerid =>  label.aero_default_user_id
                    });   
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                CaseHandler objCaseHandler = new CaseHandler(true,1);   
                objCaseHandler.onBeforeInsert(list_CaseOrder); 
            }catch(Exception e){}    
        } 
        Test.stopTest();
    }

    static testMethod void testCaseHandlerBeforeInsert_EmailGDCGFO(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Set<Id> setCaseIds= new Set<Id>();
            try{
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                        Case.Origin => 'Email-GDC GFO',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Subject=>'ADNS MESSAGE TO KSNAXGXS',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.Ownerid =>  label.aero_default_user_id
                    });   
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                CaseHandler objCaseHandler = new CaseHandler(true,1);   
                objCaseHandler.onBeforeInsert(list_CaseOrder); 
            }catch(Exception e){}     
        }
        Test.stopTest();
    }

    static testMethod void testCaseHandlerBeforeInsert_EmailGDCFS(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Set<Id> setCaseIds= new Set<Id>();
            try{
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                        Case.Origin => 'Email-GDC FS',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Subject=>'FS MESSAGE',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.Ownerid =>  label.aero_default_user_id
                    });   
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                CaseHandler objCaseHandler = new CaseHandler(true,1);   
                objCaseHandler.onBeforeInsert(list_CaseOrder);
            }catch(Exception e){}
        }
        Test.stopTest();
    }

    static testMethod void testCaseHandlerBeforeInsert_EmailGDCGFO_SubChange(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Set<Id> setCaseIds= new Set<Id>();
            try{
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                        Case.Origin => 'Email-GDC GFO',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Subject=>'NET JET MSG',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.Ownerid =>  label.aero_default_user_id
                    });   
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                CaseHandler objCaseHandler = new CaseHandler(true,1);   
                objCaseHandler.onBeforeInsert(list_CaseOrder);  
            }catch(Exception e){}
        }
        Test.stopTest(); 
    }

    static testMethod void testCaseHandlerBeforeInsert_EmailGDCFS1_SubjChange(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Set<Id> setCaseIds= new Set<Id>();
            try{
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                        Case.Origin => 'Email-GDC FS1',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Subject=>'New ITF trip for',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.Ownerid =>  label.aero_default_user_id          
                    });   
                CaseHandler objCaseHandler = new CaseHandler(true,1);   
                objCaseHandler.onBeforeInsert(list_CaseOrder);   
            }catch(Exception e){} 
        }
        Test.stopTest();
    }

    
    static testMethod void testCaseHandlerBeforeInsert_EmailSFDC(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Set<Id> setCaseIds= new Set<Id>();
            try{
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                        Case.Origin => 'Email-SFDC_CustomerMaster',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Subject=>'Contract Expiration Mail',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.Ownerid =>  label.aero_default_user_id
                    });   
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                CaseHandler objCaseHandler = new CaseHandler(true,1);   
                objCaseHandler.onBeforeInsert(list_CaseOrder);     
            }catch(Exception e){}
        }
        Test.stopTest(); 
    }

    static testMethod void testCaseHandlerBeforeInsert_CaseLookup(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Set<Id> setCaseIds= new Set<Id>();
            Case_lookup__c caseLookupRec = (Case_lookup__c) SObjectFactory.create(
                Case_lookup__c.SObjectType, new Map<SObjectField, Object>{
                    Case_lookup__c.Subject__c => 'Email with Relative Order'
                }); 
            try{
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                        Case.Origin => 'Email-Orders',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Subject=>'Email with Relative Order',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.Ownerid =>  label.aero_default_user_id           
                    });   
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                CaseHandler objCaseHandler = new CaseHandler(true,1);   
                objCaseHandler.onBeforeInsert(list_CaseOrder); 
            }catch(Exception e){}     
        }
        Test.stopTest();
    }

    static testMethod void testCaseHandlerBeforeInsert_EmailSFDCCustomerMaster(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Set<Id> setCaseIds= new Set<Id>();
            try{
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.Origin => 'Email-SFDC_CustomerMaster',
                    Case.Status => 'New',
                    Case.Sub_Status__c=>'Waiting for TCT',
                    Case.Subject=>'USER HAS DOWNLOADED MORE THAN TIMES',
                    Case.Ownerid =>  label.aero_default_user_id,
                    Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                    Case.Government_Compliance_SM_M_Content__c => 'NO'
                    });    
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                CaseHandler objCaseHandler = new CaseHandler(true,1);   
                objCaseHandler.onBeforeInsert(list_CaseOrder); 
            }catch(Exception e){}
        }
        Test.stopTest();
    }
    
    static testMethod void testCaseHandlerBeforeInsert_DualCriteria(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Set<Id> setCaseIds= new Set<Id>();
            try{
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                        Case.Origin => 'Email-SFDC_CustomerMaster',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Ownerid =>  label.aero_default_user_id,
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.SuppliedEmail=>'gfo@mygdc.com',
                       Case.Subject=>'Flight Plan Request'        
                    });
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                CaseHandler objCaseHandler = new CaseHandler(true,1);   
                objCaseHandler.onBeforeInsert(list_CaseOrder);   
            }catch(Exception e){}   
        }
        Test.stopTest(); 
    }
    
    static testMethod void testCaseHandlerBeforeInsert_GDCAccount(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Set<Id> setCaseIds= new Set<Id>();
            try{
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                        Case.Origin => 'Email-GDC Accounts',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Ownerid =>  label.aero_default_user_id,
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.SuppliedEmail=>'CTSEFTCW@HONEYWELL.COM'           
                    });
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                CaseHandler objCaseHandler = new CaseHandler(true,1);   
                objCaseHandler.onBeforeInsert(list_CaseOrder); 
            }catch(Exception e){}    
        }
        Test.stopTest();
    }

    
    static testMethod void testCaseHandlerBeforeInsert_DontReply(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Set<Id> setCaseIds= new Set<Id>();
            try{
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                        Case.Origin => 'Email-CPSQuotesCOE',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.Subject=>'Hello user',
                        Case.Ownerid =>  label.aero_default_user_id,
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.SuppliedEmail=>'dont-reply-aog-desk@services.dlh.de'
                    });   
                for(Case objCase: list_CaseOrder){
                    setCaseIds.add(objCase.Id);
                }
                CaseHandler objCaseHandler = new CaseHandler(true,1);   
                objCaseHandler.onBeforeInsert(list_CaseOrder);
            }catch(Exception e){}
        }
        Test.stopTest(); 
    }
    
    static testMethod void testCaseHandlerBeforeInsert_CaseLineItem(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Account accountWithBGA= [SELECT Id FROM Account WHERE name=:'Test 34Account Energy'];
            Contact contactWithBGA = [SELECT Id FROM Contact WHERE AccountId=:AccountWithBGA.Id];
            Set<Id> setCaseIds= new Set<Id>();
            recId = RecordTypeServices.getRecordTypeByName('Quotes','Case').Id;
            
            List<Case> list_CaseOrder= SObjectFactory.create(
                CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                    Case.Origin => 'Web',
                    Case.Status => 'New',
                    Case.Sub_Status__c=>'Waiting for TCT',
                    Case.Ownerid => Label.NavDB_Accts_Team,
                    Case.SuppliedEmail=>'CTSEFTCW@HONEYWELL.COM',
                    Case.RecordTypeId=> recId ,
                    Case.Classification__c => 'R&O Americas Internal',
                    Case.ContactId => contactWithBGA.Id,
                    Case.AccountId=>accountWithBGA.id,
                    Case.Type =>'Reapir Inquiry',
                    Case.CSM_Region__c => 'Americas',
                    Case.Workstrem__c => 'Repair and Overhaul',
                    Case.SBU_w2c__c => 'BGA',
                    Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                    Case.Government_Compliance_SM_M_Content__c => 'NO',
                    Case.Subject => 'QNext',
                    Case.CEC_Record_Type__c => 'C4 Test CEC Orders'            
                });
            for(Case objCase: list_CaseOrder){
                setCaseIds.add(objCase.Id);
            }
            Case caseRelatedToCLI = new Case();
            caseRelatedToCLI = list_CaseOrder[0];
            Case_Line_Item__c caseLookupRec = (Case_Line_Item__c) SObjectFactory.create(
                Case_Line_Item__c.SObjectType, new Map<SObjectField, Object>{
                    Case_Line_Item__c.Case_Number__c=> caseRelatedToCLI.Id,
                    Case_Line_Item__c.Price__c => 20,
                    Case_Line_Item__c.Quantity__c => 2
                });   
            CaseHandler objCaseHandler = new CaseHandler(true,1);   
            objCaseHandler.onBeforeInsert(list_CaseOrder);  
        }  
        Test.stopTest();
    }





    static testMethod void testCaseHandlerBeforeInsert_HoneyWell()
     { Test.startTest();
     User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
         TriggerInactive.testTrigger = false;
        //setup();
        Set<Id> setCaseIds= new Set<Id>();
        recId = RecordTypeServices.getRecordTypeByName('ATR RMU Case','Case').Id;
        try{
        List<Case> list_CaseOrder= SObjectFactory.create(
            CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
            Case.Origin => 'Email-CPSQuotesCOE',
             Case.Status => 'New',
            Case.Sub_Status__c=>'Waiting for TCT',
           Case.Subject=>'has sent fax',
            Case.Ownerid =>  label.ATR_API_User_id,
             Case.SuppliedEmail=>'CTSEFTCW@mail.com',
             case.RecordTypeId=>  recId,
             Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
            Case.Government_Compliance_SM_M_Content__c => 'NO',
             Case.Honeywell_ID__c=>'ABC123'
            }
        ); 
        for(Case objCase: list_CaseOrder){
            setCaseIds.add(objCase.Id);
            }
        //Test.startTest();     
         CaseHandler objCaseHandler = new CaseHandler(true,1);   
            //call before insert handler method                   
            objCaseHandler.onBeforeInsert(list_CaseOrder); 
            }catch(Exception e){}
            }
            Test.stopTest();   
        
        
         /*for (case CaseTech : [SELECT CEC_Record_Type__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Origin FROM case WHERE Id IN :setCaseIds])
        {
            system.assertEquals(CaseTech.Origin,'Email-CPSQuotesCOE');
            system.assertEquals(CaseTech.Export_Compliance_Content_ITAR_EAR__c, 'No');
            system.assertEquals(CaseTech.Government_Compliance_SM_M_Content__c, 'No');                        
        }*/
    }
    static testMethod void testCaseHandlerBeforeInsert_HoneyWellCurrentUser()
     {     Test.startTest();
     User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
         TriggerInactive.testTrigger = false;
        //setup();
        Set<Id> setCaseIds= new Set<Id>();
        List<Case> list_CaseOrder = new List<Case> ();
        User currentUser2 = new User(Id = label.ATR_API_User_id);
        recId = RecordTypeServices.getRecordTypeByName('ATR RMU Case','Case').Id;
        try{
        System.runAs(currentUser2){
        
        list_CaseOrder= SObjectFactory.create(
            CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
            Case.Origin => 'Email-CPSQuotesCOE',
             Case.Status => 'New',
            Case.Sub_Status__c=>'Waiting for TCT',
           Case.Subject=>'has sent fax',
            Case.Ownerid =>  label.ATR_API_User_id,
             Case.SuppliedEmail=>'CTSEFTCW@mail.com',
             case.RecordTypeId=>  recId,
             Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
            Case.Government_Compliance_SM_M_Content__c => 'NO',
             Case.Honeywell_ID__c=>'ABC123'
            }
        ); 
        for(Case objCase: list_CaseOrder){
            setCaseIds.add(objCase.Id);
            }
         
        }
       // Test.startTest(); 
        System.runAs(currentUser2){    
             CaseHandler objCaseHandler = new CaseHandler(true,1);   
            //call before insert handler method                   
            objCaseHandler.onBeforeInsert(list_CaseOrder);   
              
        }
        }catch(Exception e){}
        }
        Test.stopTest();
        
         /*for (case CaseTech : [SELECT CEC_Record_Type__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Origin FROM case WHERE Id IN :setCaseIds])
        {
        system.assertEquals(CaseTech.Origin,'Email-CPSQuotesCOE');
            system.assertEquals(CaseTech.Export_Compliance_Content_ITAR_EAR__c, 'No');
            system.assertEquals(CaseTech.Government_Compliance_SM_M_Content__c, 'No');                        
        }*/
    }
    static testMethod void testCaseHandlerBeforeInsert_HoneyWellContact()
     { Test.startTest();
     User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
         TriggerInactive.testTrigger = false;
        //setup();
        Set<Id> setCaseIds= new Set<Id>();
        List<Case> list_CaseOrder = new List<Case> ();
        recId = RecordTypeServices.getRecordTypeByName('ATR RMU Case','Case').Id;
        try{
        list_CaseOrder= SObjectFactory.create(
            CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
            Case.Origin => 'Email-CPSQuotesCOE',
             Case.Status => 'New',
            Case.Sub_Status__c=>'Waiting for TCT',
            Case.ContactId =>contactWithATR.Id,
            Case.AccountId=>accountWithATR.id,
           Case.Subject=>'has sent fax',
            Case.Ownerid =>  label.ATR_API_User_id,
             Case.SuppliedEmail=>'CTSEFTCW@mail.com',
             case.RecordTypeId=>  recId,
             Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
            Case.Government_Compliance_SM_M_Content__c => 'NO',
             Case.Honeywell_ID__c=>'ABC123'
            }
        ); 
        for(Case objCase: list_CaseOrder){
            setCaseIds.add(objCase.Id);
            }
        
        //Test.startTest(); 
         CaseHandler objCaseHandler = new CaseHandler(true,1);   
            //call before insert handler method                   
            objCaseHandler.onBeforeInsert(list_CaseOrder); 
             }catch(Exception e){}
             }
               Test.stopTest();
        
        
         /*for (case CaseTech : [SELECT CEC_Record_Type__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Origin FROM case WHERE Id IN :setCaseIds])
        {
            system.assertEquals(CaseTech.Origin,'Email-CPSQuotesCOE');
            system.assertEquals(CaseTech.Export_Compliance_Content_ITAR_EAR__c, 'No');
            system.assertEquals(CaseTech.Government_Compliance_SM_M_Content__c, 'No');                        
        }*/
    }
        //End of Test Methods of BeforeInsertHelperClass
        
        //Start of Test Methods of BeforeInsert Method of OwnerAssignmentForCSOCasesClass
         static testMethod void testOwnerAssignmentBeforeInsert_DeferredOrdersWeb()
 {     Test.startTest();
 User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
         TriggerInactive.testTrigger = false;
        //setup();
        Account accountWithBGA= [SELECT Id FROM Account WHERE name=:'Test 34Account Energy'];
        Contact contactWithBGA = [SELECT Id FROM Contact WHERE AccountId=:AccountWithBGA.Id];
        Set<Id> setCaseIds= new Set<Id>();
        recId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;       
        //create case records
        try{
        List<Case> list_CaseOrder= SObjectFactory.create(
            CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
            Case.Origin => 'Email-deferredordersweb',
             Case.Status => 'New',
            Case.Sub_Status__c=>'Waiting for TCT',
            Case.Ownerid => Label.NavDB_Accts_Team,
            Case.Emailbox_Origin__c=>'Email-deferredordersweb',
           Case.SuppliedEmail=>'CTSEFTCW@HONEYWELL.COM',
           Case.RecordTypeId=> recId ,
            Case.Classification__c => 'R&O Americas Internal',
            Case.ContactId => contactWithBGA.Id,
            Case.AccountId=>accountWithBGA.id,
            Case.Type =>'Reapir Inquiry',
            Case.CSM_Region__c => 'Americas',
            Case.Workstrem__c => 'Repair and Overhaul',
            Case.SBU_w2c__c => 'BGA',
            Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
            Case.Government_Compliance_SM_M_Content__c => 'NO',
            //Case.Status => 'Closed',
            Case.Subject => 'Sub : [Deferred orders from web | Star of week | Right of Day |Release; SPEX]',
            Case.CEC_Record_Type__c => 'C4 Test CEC Orders' 
            
            }
        );  
        for(Case objCase: list_CaseOrder){
            setCaseIds.add(objCase.Id);
            }
       // Test.startTest();    
      CaseHandler objCaseHandler = new CaseHandler(true,1);   
            //call before insert handler method                   
            objCaseHandler.onBeforeInsert(list_CaseOrder);                 
              
         }catch(Exception e){}    
         }     
        Test.stopTest();

        /* for (case CaseTech : [SELECT CEC_Record_Type__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Origin FROM case WHERE Id IN :setCaseIds])
        {
            system.assertEquals(CaseTech.Export_Compliance_Content_ITAR_EAR__c, 'No');
            system.assertEquals(CaseTech.Government_Compliance_SM_M_Content__c, 'No');                        
        }*/
    }
    static testMethod void testOwnerAssignmentBeforeInsert_DeferredOrdersWebElse()
 {     Test.startTest();
 User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
         TriggerInactive.testTrigger = false;
        //setup();
        Account accountWithBGA= [SELECT Id FROM Account WHERE name=:'Test 34Account Energy'];
        Contact contactWithBGA = [SELECT Id FROM Contact WHERE AccountId=:AccountWithBGA.Id];
        Set<Id> setCaseIds= new Set<Id>();
        recId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;       
        //create case records
        List<Case> list_CaseOrder= SObjectFactory.create(
            CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
            Case.Origin => 'Email-deferredordersweb',
             Case.Status => 'New',
            Case.Sub_Status__c=>'Waiting for TCT',
            Case.ContactId => contactWithBGA.Id,
            Case.AccountId=>accountWithBGA.id,
            Case.Type =>'Reapir Inquiry',
            Case.CSM_Region__c => 'Americas',
            Case.Workstrem__c => 'Repair and Overhaul',
            Case.SBU_w2c__c => 'BGA',
            Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
            Case.Government_Compliance_SM_M_Content__c => 'NO',
            //Case.Status => 'Closed',
            Case.CEC_Record_Type__c => 'C4 Test CEC Orders' 
            
            }
        );  
        for(Case objCase: list_CaseOrder){
            setCaseIds.add(objCase.Id);
            }
        //Test.startTest();     
        CaseHandler objCaseHandler = new CaseHandler(true,1);   
            //call before insert handler method                   
            objCaseHandler.onBeforeInsert(list_CaseOrder);   
           
         for (case CaseTech : [SELECT CEC_Record_Type__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Origin FROM case WHERE Id IN :setCaseIds])
        {
            system.assertEquals(CaseTech.Export_Compliance_Content_ITAR_EAR__c, 'No');
            system.assertEquals(CaseTech.Government_Compliance_SM_M_Content__c, 'No');                        
        }
         }  
        Test.stopTest();
    }
        //End f Test Methods of BeforeInsert Method of OwnerAssignmentForCSOCasesClass
        
        
        //Start Of Test Methods of AfterInsertHelperClass
    static testMethod void testafterInsertMethod_TCT(){
    Test.startTest();
    User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
        TriggerInactive.testTrigger = false;
        User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
        account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1];           
        Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1];  
        List<Case>lstcasenew=[Select id,ContactId,Status,Sub_Status__c,recordtypeid,Case_Record_Type__c,Createddate,Type,OwnerId from Case where Sub_Status__c = 'Waiting for TCT'];             
        try{
        lstcasenew[0].Status = 'On Hold';
        update lstcasenew;        
            //Test.startTest();  
            // CaseHandler objCaseHandler = new CaseHandler(true,1);  
            //objCaseHandler.onafterInsert(lstcasenew); 
            CaseServiceOnInsert.afterInsertMethod(true,lstcasenew,null);  
                
                    
            //List<Technical_Issue_Case_Extensions__c>lstObjTechIssue = [Select id ,Name ,Case_object__c,Waiting_for_TCT_Start_Time__c from Technical_Issue_Case_Extensions__c where Case_object__c = : lstcasenew[0].Id]; 
          //System.assertNotEquals(lstObjTechIssue[0].Waiting_for_TCT_Start_Time__c ,null);
          }catch(Exception e){}
          }        
            Test.stopTest();
        }
      
       static testMethod void testafterInsertMethod_CustomerFeedback(){    
          Test.startTest();
          List<Case> lstcasenew = new List<Case>();
          User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
          TriggerInactive.testTrigger = false;
        User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
        account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1];           
        Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1];  
        
        lstcasenew = [Select id,ContactId,Status,Sub_Status__c,recordtypeid,Case_Record_Type__c,Createddate,Type,OwnerId from Case where Sub_Status__c = 'Waiting for TCT'];             
        try{
        lstcasenew[0].Status = 'On Hold';
        lstcasenew[0].Sub_Status__c = 'Waiting for Customer Feedback';
        update lstcasenew;
        
        //Test.startTest();        
              // CaseHandler objCaseHandler = new CaseHandler(true,1);  
            //objCaseHandler.onafterInsert(lstcasenew);
            CaseServiceOnInsert.afterInsertMethod(true,lstcasenew,null);
            }catch(Exception e){}
        }
        Test.stopTest();
               
        //List<Technical_Issue_Case_Extensions__c>lstObjTechIssue = [Select id ,Name ,Case_object__c,Waiting_for_TCT_Start_Time__c,Customer_Feedback_Hold_Start_time__c 
        //from Technical_Issue_Case_Extensions__c where Case_object__c = : lstcasenew[0].Id]; 
        //System.assertNotEquals(lstObjTechIssue[0].Customer_Feedback_Hold_Start_time__c ,null);
 
       }
       
       static testMethod void testafterInsertMethod_WaitingforEPSEngineering(){
       Test.startTest();
       List<Case> lstcasenew = new List<Case>();
       User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
       TriggerInactive.testTrigger = false;
       User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
        account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1];           
        Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1];  
        lstcasenew=[Select id,ContactId,Status,Sub_Status__c,recordtypeid,Case_Record_Type__c,Createddate,Type,OwnerId from Case where Sub_Status__c = 'Waiting for TCT'];             
     try{
        lstcasenew[0].Status = 'On Hold';
        lstcasenew[0].Sub_Status__c = 'Waiting for EPS/Engineering';
        update lstcasenew;
        
        //Test.startTest();        
               //CaseHandler objCaseHandler = new CaseHandler(true,1);  
            //objCaseHandler.onafterInsert(lstcasenew); 
            CaseServiceOnInsert.afterInsertMethod(true,lstcasenew,null);
                    }catch(Exception e){}  
        }
        Test.stopTest();

        //List<Technical_Issue_Case_Extensions__c>lstObjTechIssue = [Select id ,Name ,Case_object__c,Waiting_for_TCT_Start_Time__c,EPS_Engineering_Hold_Start_Time__c,Customer_Feedback_Hold_Start_time__c from Technical_Issue_Case_Extensions__c where Case_object__c = : lstcasenew[0].Id]; 
        //System.assertNotEquals(lstObjTechIssue[0].EPS_Engineering_Hold_Start_Time__c ,null);     
       }
       
    static  testMethod void testafterInsertMethod_WaitingforHoneywellInternal(){
        Test.startTest();
        List<Case> lstcasenew = new List<Case>();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
        TriggerInactive.testTrigger = false;
       User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
        account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1];           
        Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1];  
        lstcasenew=[Select id,ContactId,Status,Sub_Status__c,recordtypeid,Case_Record_Type__c,Createddate,Type,OwnerId from Case where Sub_Status__c = 'Waiting for TCT'];             
        try{
        //For creation of Test data , updating status of Case
        lstcasenew[0].Status = 'On Hold';
        lstcasenew[0].Sub_Status__c = 'Waiting for Honeywell Internal';
        update lstcasenew;
        
        //Test.startTest();        
             //CaseHandler objCaseHandler = new CaseHandler(true,1);  
            //objCaseHandler.onafterInsert(lstcasenew); 
            CaseServiceOnInsert.afterInsertMethod(true,lstcasenew,null);
        }catch(Exception e){}    
        }
        Test.stopTest();
               
      
       }
       
       static  testMethod void testafterInsertMethod_Orders(){
       Test.startTest();
       TriggerInactive.testTrigger = false;
        User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
        account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1];           
        Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1];  
        List<Case>lstcasenew=[Select id,ContactId,Status,Sub_Status__c,recordtypeid,Case_Record_Type__c,Createddate,Type,OwnerId from Case where Sub_Status__c = 'Waiting for TCT'];             
        
        //For creation of Test data , updating status of Case
        try{
        lstcasenew[0].recordtypeId = RecordTypeServices.getRecordTypeByName('OEM Quotes Orders', 'Case').Id;
        update lstcasenew;
        
        List<Case>lstcasenew1=[Select id,ContactId,AccountId,Status,Origin,Sub_Status__c,NSN__c,Part_Number__c,recordtypeid,Case_Record_Type__c,Createddate,Type,OwnerId from Case where Sub_Status__c = 'Waiting for TCT'];             
        
        //Test.startTest();        
              //CaseHandler objCaseHandler = new CaseHandler(true,1);  
            //objCaseHandler.onafterInsert(lstcasenew1); 
            CaseServiceOnInsert.afterInsertMethod(true,lstcasenew,null);
        }catch(Exception e){}   
        Test.stopTest();  
         
       }
       
       static  testMethod void testafterInsertMethod_TechPubs(){
         Test.startTest();
          User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
         TriggerInactive.testTrigger = false;
        User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
        account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1];           
        Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1];  
        List<Case>lstcasenew=[Select id,ContactId,Status,Sub_Status__c,recordtypeid,Case_Record_Type__c,Createddate,Type,OwnerId from Case where Sub_Status__c = 'Waiting for TCT'];             
        try{
        //For creation of Test data , updating status of Case
        lstcasenew[0].recordtypeId = RecordTypeServices.getRecordTypeByName('Tech Pubs','Case').Id;
        lstcasenew[0].HIPI_Opportunity__c = true;
        update lstcasenew;      
        S2SFRestService__c objS2SF = new S2SFRestService__c();
        objS2SF.Name = 'S2SFRestService11';
        objS2SF.Client_Id__c = '3MVG9dzpc3kWyeYadd5SFIAZYfRT0HTnAJXRkW8Hc7.5LpxdjaVJJ05iuJHTDvKITxa5EZ9Y40iSX47_r53mJ';
        objS2SF.OAuth2End_Point__c = 'https://test.salesforce.com/services/oauth2/token';
        objS2SF.Password__c = 'testHtygKefAzOUqQtJ3F5pEfjk3';
        objS2SF.Secret_Id__c = '17600332615211137021';
        objS2SF.User_Name__c = 'nandini.nanjappan@honeywell.com';
        insert objS2SF;   
        
        //Test.startTest();        
         //      CaseHandler objCaseHandler = new CaseHandler(true,1);  
         //   objCaseHandler.onafterInsert(lstcasenew); 
         CaseServiceOnInsert.afterInsertMethod(true,lstcasenew,null);
        }catch(Exception e){}    
        }
        Test.stopTest();
        
                      
       }
       
        static  testMethod void testafterInsertMethod_CaseExtensions(){
          Test.startTest();
           User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
          TriggerInactive.testTrigger = false;
            User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
            account testAccount =[SELECT Id, Name FROM Account WHERE Type=:'Energy' LIMIT 1];           
            Contact testContact =[SELECT Id, Name FROM Contact WHERE AccountId=:testAccount.Id LIMIT 1];  
            List<Case>lstcasenew=[Select id,ContactId,Status,Sub_Status__c,recordtypeid,Case_Record_Type__c,Createddate,Type,OwnerId from Case where Sub_Status__c = 'Waiting for TCT'];             
            try{
            lstcasenew[0].recordtypeId = RecordTypeServices.getRecordTypeByName('Orders','Case').Id;
            lstcasenew[0].Subject = 'Test MYMAINTAINER';
            update lstcasenew;
            Case_Extension__c CasExt = new Case_Extension__c();
            CasExt.Case_object__c = lstcasenew[0].Id;
            CasExt.Name = lstcasenew[0].CaseNumber+'_Ext';
            insert CasExt;
            
        //Test.startTest();        
             //  CaseHandler objCaseHandler = new CaseHandler(true,1);  
            //objCaseHandler.onafterInsert(lstcasenew); 
            CaseServiceOnInsert.afterInsertMethod(true,lstcasenew,null);
        }catch(Exception e){}    
        }
        Test.stopTest();
        
        
        
        }
        //End Of Test Methods of AfterInsertHelperClass
        //########################################################################################################################################//
        
        /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: setupForProvide
    ** Description : setup method for Case Provide Access contains Profile, user, Group, Country and Account
    */
    static void setupForProvide(){
    Test.startTest();
     User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        //Profile
        adminProfile = [select id from Profile where name = 'System Administrator'];
        
        //Create User
        lstUser = SObjectFactory.create(
            CASE_COUNT_PROVIDE, User.sObjectType, new Map<Schema.SObjectField, Object>{
                User.LastName => 'Test UserCSO',
                User.Username => 'testcsouser@test.com',
                User.Email => 'testuser1@test.com',
                User.Alias => 'tu0',
                User.CommunityNickname => 'tu0cso',
                User.TimeZoneSidKey => 'America/Los_Angeles',
                User.LocaleSidKey => 'en_US',
                User.EmailEncodingKey => 'ISO-8859-1',
                User.ProfileId => adminProfile.Id,
                User.LanguageLocaleKey => 'en_US',
                User.SBU_User__c => 'D&S',
                User.Country__c => 'Canada'
            }
        );

        //Group ID
        List<String> lstQueue = new List<String>();
            lstQueue.add('Compliance Queue CSO');
            lstQueue.add('Compliance Queue GTO');
            lstQueue.add('CSO');
            lstQueue.add('General Compliance Queue');
            lstQueue.add('Tech Issue');
        lstgrpId = new List<Group>([Select Id,Name From Group where Name in: lstQueue]);
        
        //Country__c
        lstCountry = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Country__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Country__c.OwnerId => UserInfo.getUserId(),
                Country__c.Name => 'USA',
                Country__c.SFDC_Country_Name__c => 'USA'
                }
             );
       
        //Account
        lstAccount = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Account.OwnerId => UserInfo.getUserId(),
                Account.Name => 'Test Account', 
                Account.Type => 'Honeywell',
                Account.Country__c => lstCountry[0].Id,
                Account.Customer_Status__c => 'Active',
                Account.Strategic_Business_Unit__c => 'D&S',
                Account.CBT__c => 'DMA',
                Account.CBT_Team__c => 'None',
                Account.Market_Name__c => 'Marine',
                Account.Service_Level__c => 'Standard',
                Account.REPORT_ACCOUNT_NAME__c => 'test Account New'
            }
        );
        }
       Test.stopTest();
    }
   

    /** Created By : Garvit Totuka   Date : 13 Nov 2017
      * method: afterInsertComplianceCase
      * Description : Insert compliance Case
      */
    static testMethod void afterInsertComplianceCase_1(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        listCaseDSClearing = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdDSClearingHouse,
                Case.Classification__c => 'CSO Spares',
                Case.Export_Compliance_Content_ITAR_EAR__c => 'Yes',
                Case.Status => 'In Process'
            });        
        CaseHandler objCaseHandler = new CaseHandler (true,1);   
        objCaseHandler.onAfterInsert(listCaseDSClearing);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        Set<String> strCaseNumber = new Set<String>();
        for(Case cases:caselst){
            strCaseNumber.add(cases.CaseNumber);
        }
    }
      
    /** Created By : Garvit Totuka   Date : 13 Nov 2017
      * method: afterInsertComplianceCase
      * Description : Insert compliance Case
      */
    static testMethod void afterInsertComplianceCase_2(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        listCaseRepair = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdRepairOverhaul,
                Case.Government_Compliance_SM_M_Content__c => 'Yes',
                Case.Status => 'In Process'
            });
        CaseHandler objCaseHandler = new CaseHandler (true,1);   
        objCaseHandler.onAfterInsert(listCaseRepair);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        Set<String> strCaseNumber = new Set<String>();
        for(Case cases:caselst){
            strCaseNumber.add(cases.CaseNumber);
        }
    }
   
    /** Created By : Garvit Totuka   Date : 13 Nov 2017
      * method: afterInsertComplianceCase
      * Description : Insert compliance Case
      */
    static testMethod void afterInsertComplianceCase_3(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        listCaseTech = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'Technical Issue',
                Case.recordtypeid => rtIdTechIssue,
                Case.Classification__c => 'GTO Field Service',
                Case.Government_Compliance_SM_M_Content__c => 'Yes',
                Case.Status => 'In Process'
            });
        CaseHandler objCaseHandler = new CaseHandler (true,1);   
        objCaseHandler.onAfterInsert(listCaseTech);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        Set<String> strCaseNumber = new Set<String>();
        for(Case cases:caselst){
            strCaseNumber.add(cases.CaseNumber);
        }
    }

   
    /** Created By : Garvit Totuka   Date : 13 Nov 2017
      * method: afterInsertComplianceCase
      * Description : Insert compliance Case
      */
    static testMethod void afterInsertComplianceCase_4(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        listCaseOEMQuote = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdOEMQuoteOrders,
                Case.Classification__c => 'GTO Field Service',
                Case.Government_Compliance_SM_M_Content__c => 'Yes',
                Case.Status => 'In Process'
            });        
        CaseHandler objCaseHandler = new CaseHandler (true,1);   
        objCaseHandler.onAfterInsert(listCaseOEMQuote);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        Set<String> strCaseNumber = new Set<String>();
        for(Case cases:caselst){
            strCaseNumber.add(cases.CaseNumber);
        }
   }

    /** Created By : Garvit Totuka   Date : 13 Nov 2017
      * method: afterInsertProvideAccess
      * Description : Insert CaseShare
      */
    static testMethod void afterInsertProvideAccess_1(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        listCaseRepair = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdRepairOverhaul,
                Case.Government_Compliance_SM_M_Content__c => 'No',
                Case.Export_Compliance_Content_ITAR_EAR__c => 'No',
                Case.IsAccountWebform__c => false,
                Case.Status => 'In Process'
            });
        CaseHandler objCaseHandler = new CaseHandler (true,1);   
        objCaseHandler.onAfterInsert(listCaseRepair);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        Set<Id> idCaseId = new Set<Id>();
        for(Case cases:caselst){
           idCaseId.add(cases.Id);
        }
        List<CaseShare> casesharelst = new List<CaseShare>([Select Id, caseid From CaseShare where CaseId in: idCaseId]);      
        System.assert(!casesharelst.isEmpty(), 'Compliance_Case__c should not be null');
    }



    
    /** Created By : Garvit Totuka   Date : 13 Nov 2017
      * method: afterInsertProvideAccess
      * Description : Insert CaseShare
      */
    static testMethod void afterInsertProvideAccess_2(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        listCaseTech = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdTechIssue,
                Case.Government_Compliance_SM_M_Content__c => 'No',
                Case.Export_Compliance_Content_ITAR_EAR__c => 'No',
                Case.IsAccountWebform__c => false,
                Case.Status => 'In Process'
            });
        CaseHandler objCaseHandler = new CaseHandler (true,1);   
        objCaseHandler.onAfterInsert(listCaseTech);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        Set<Id> idCaseId = new Set<Id>();
        for(Case cases:caselst){
           idCaseId.add(cases.Id);
        }
        List<CaseShare> casesharelst = new List<CaseShare>([Select Id, caseid From CaseShare where CaseId in: idCaseId]);      
        System.assert(!casesharelst.isEmpty(), 'Compliance_Case__c should not be null');
    }
    



    
   /* Created By : Garvit Totuka   Date : 13 Nov 2017
    ** method: caseFSENameByAccountTeamMember_Insert
    ** Description : insert FSE Name - After Insert
    */
    static testMethod void caseFSENameByAccountTeamMember_Insert(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        Profile pf = [select id from Profile where name = 'System Administrator'];
        Account acct = [Select id From Account Where Name =: 'Test Account' Limit 1];
        List<User> lstUser2 = SObjectFactory.create(
            CASE_COUNT_PROVIDE, User.sObjectType, new Map<Schema.SObjectField, Object>{
                User.LastName => 'Test UserCSO2',
                User.Username => 'tu2cso@test.com',
                User.Email => 'testuser2@test.com',
                User.Alias => 'tu2',
                User.CommunityNickname => 'tu1cso',
                User.TimeZoneSidKey => 'America/Los_Angeles',
                User.LocaleSidKey => 'en_US',
                User.EmailEncodingKey => 'ISO-8859-1',
                User.ProfileId => pf.Id,
                User.LanguageLocaleKey => 'en_US',
                User.SBU_User__c => 'D&S',
                User.Country__c => 'Canada'
            }
        );
        
        List<AccountTeamMember> lstATM = SObjectFactory.create(
            CASE_COUNT_PROVIDE, AccountTeamMember.sObjectType, new Map<Schema.SObjectField, Object>
            {
                AccountTeamMember.AccountId => acct.Id,
                AccountTeamMember.UserId => UserInfo.getUserId(),
                AccountTeamMember.TeamMemberRole => 'Field Service Engineer (FSE)'
            } 
        );
        List<AccountTeamMember> lstATMnew = SObjectFactory.build(2,AccountTeamMember.sObjectType);
            lstATMnew[0].AccountId = acct.Id;
            lstATMnew[0].UserId = runUser.Id;
            lstATMnew[0].TeamMemberRole = 'Field Service Engineer (FSE)';
            
            lstATMnew[1].AccountId = acct.Id;
            lstATMnew[1].UserId = lstUser2[0].Id;
            lstATMnew[1].TeamMemberRole = 'Field Service Manager';
            
            insert lstATMnew;
        
        listCaseOEMQuote = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => UserInfo.getUserId(),
                Case.accountid => acct.Id,
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdOEMQuoteOrders,
                Case.AOG__c => true,
                Case.Expected_Update__c => System.Now(),
                Case.Government_Compliance_SM_M_Content__c => 'Yes',
                Case.Export_Compliance_Content_ITAR_EAR__c => 'Yes',
                Case.Classification__c => 'GTO Field Service',
                Case.IsMemberOfCompliance__c => false,
                Case.Status => 'In Process'                
            }
        );
        
        //Test.startTest(); 
           List<Id> accidlist = CaseServiceOnInsert.beforeInsertGetAccountIds(listCaseOEMQuote); //added from Case_ProvideAccess
            CaseServiceForCommonMethods.caseFSENameByAccountTeamMember(listCaseOEMQuote,accidlist); //added from Case_ProvideAccess
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id, FSE_Name_1__c, FSE_Name_2__c, FSE_Name_3__c  From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        System.assertNotEquals(null,caselst[0].FSE_Name_1__c <> Null,'Case FSE_Name_1__c should not be null');
        System.assertNotEquals(null,caselst[0].FSE_Name_2__c <> Null,'Case FSE_Name_2__c should not be null');
        System.assertNotEquals(null,caselst[0].FSE_Name_3__c <> Null,'Case FSE_Name_3__c should not be null');
    }
   
static testMethod void testMethodAfterInsertUpdateCaseCEC()
    {    Test.startTest();
    User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        //Prepare test data for caseService.setcaseValues <start> 
        //get the record type id for Orders and Technical Issue        
        string recordTypeIdTIssue = RecordTypeServices.getRecordTypeByName('Technical Issue', 'Case').Id; 
        Set<Id> setCaseIds= new Set<Id>();          
        //create values for custom setting        
        List<CaseType_RecordType__c> list_CustomSetting2= SObjectFactory.create(
            1, CaseType_RecordType__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                CaseType_RecordType__c.Name=> '#2',
                CaseType_RecordType__c.Case_type__c=> 'Technical Issue',
                CaseType_RecordType__c.Record_Type__c=> 'Technical Issue'                
            }
        );
        //create case records
        List<Case> list_CaseTech= SObjectFactory.create(
            CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'Technical Issue',
                Case.recordtypeid => recordTypeIdTIssue,
                Case.CEC_Record_Type__c => 'C3 Test CEC Technical Issue',
                Case.Status => 'In Process'                              
            }
        );          
        //Create data for PartnerNetworkConnection  
        /*PartnerNetworkConnection network = [select Id, ConnectionStatus, ConnectionName from PartnerNetworkConnection
                                            where ConnectionStatus = 'Accepted' LIMIT 1];
        
        PartnerNetworkRecordConnection conrecord = new PartnerNetworkRecordConnection();
        conrecord.ConnectionId = network.Id;
        conrecord.LocalRecordId = list_CaseTech[0].id;  
        conrecord.SendClosedTasks = false;
        conrecord.SendOpenTasks = false;
        conrecord.SendEmails = false;          
        insert conrecord;      
        */
            
        //Prepare test data for caseService.setcaseValues <end> 
        //Test.startTest(); 
            CaseHandler objCaseHandler = new CaseHandler(true,1); 
            //call after insert handler method     
            objCaseHandler.onAfterInsert(list_CaseTech);
            
        for(Case objCase: list_CaseTech){
            setCaseIds.add(objCase.Id);
            }
        
        for (case CaseTech : [SELECT CEC_Record_Type__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Origin FROM case WHERE Id IN :setCaseIds])
        {
            system.assertEquals(CaseTech.Export_Compliance_Content_ITAR_EAR__c, 'Undetermined');
            system.assertEquals(CaseTech.Government_Compliance_SM_M_Content__c, 'Undetermined');                       
        }
        }
        Test.stopTest();
    }
  /* Created By : Swastika Rajkhowa Date : 04 Nov 2017
** Trigger : S2S_CEC_2_Aero_Case Line of Code : 46-67
** Description : added setcaseValues method to assign value of the Export_Compliance_Content_ITAR_EAR__c ,Government_Compliance_SM_M_Content 
    when case type in ('Technical Issue',Orders).
** Trigger Event : Before Insert 
*/       
  @isTest static void testMethodSetCaseValuesOrders(){
  Test.startTest();
  User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
  TriggerInactive.testTrigger = false;
    //Prepare test data for caseService.setcaseValues <start> 
    //get the record type id for Orders and Technical Issue
    string recordTypeIdOrders = RecordTypeServices.getRecordTypeByName('Orders', 'Case').Id;        
    Set<Id> setCaseIds= new Set<Id>();         
    //create values for custom setting        
    List<CaseType_RecordType__c> list_CustomSetting1= SObjectFactory.create(
        1, CaseType_RecordType__c.sObjectType, new Map<Schema.SObjectField, Object>{
                CaseType_RecordType__c.Name=> '#1',
                CaseType_RecordType__c.Case_type__c=> 'Order Status',
                CaseType_RecordType__c.Record_Type__c=> 'Orders'                
            }); 
    User testUser = [SELECT Id FROM User WHERE UserName =:'test_radha@in.ibm.com']; 
    System.runAs(testUser) {
        //List<Case> listCaseOrderType = new List<Case>();      
        //create case records        
        List<Case> listCaseOrderType = SObjectFactory.create(
            CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'Order Status', 
                Case.recordtypeid => recordTypeIdOrders,
                Case.CEC_Record_Type__c => 'C4 Test CEC Orders' 
            });
    //Prepare test data for caseService.setcaseValues <end> 
    //Test.startTest(); 
        CaseHandler objCaseHandler = new CaseHandler(true,1);   
        //call before insert handler method 
        objCaseHandler.onBeforeInsert(listCaseOrderType);     
       
    for(case caseList :listCaseOrderType) {
            system.assertEquals(caseList.Export_Compliance_Content_ITAR_EAR__c, 'Undetermined');
            system.assertEquals(caseList.Government_Compliance_SM_M_Content__c, 'Undetermined'); 
            system.assertEquals(caseList.Origin,'Honeywell.com.cn');   
        }
         }      
    Test.stopTest();
    }
}
/* Created By : Swastika Rajkhowa Date : 04 Nov 2017
** Trigger : S2S_CEC_2_Aero_Case Line of Code : 46-67
** Description : added setcaseValues method to assign value of the Export_Compliance_Content_ITAR_EAR__c ,Government_Compliance_SM_M_Content 
    when case type in ('Technical Issue',Orders).
** Trigger Event : Before Insert 
*/     
    static testMethod void testMethodSetCaseValuesOrdersTechIssue(){    
        Test.startTest();
        List<Case> list_CaseTech = new List<Case>();
        Set<Id> setCaseIds= new Set<Id>();          
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
        //Prepare test data for caseService.setcaseValues <start> 
        //get the record type id for Orders and Technical Issue        
        string recordTypeIdTIssue = RecordTypeServices.getRecordTypeByName('Technical Issue', 'Case').Id; 
        
        //create values for custom setting        
        List<CaseType_RecordType__c> list_CustomSetting2= SObjectFactory.create(
            1, CaseType_RecordType__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                CaseType_RecordType__c.Name=> '#2',
                CaseType_RecordType__c.Case_type__c=> 'Technical Issue',
                CaseType_RecordType__c.Record_Type__c=> 'Technical Issue'                
            }
        );
        //create case records
       list_CaseTech = SObjectFactory.create(
            CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'Technical Issue',
                Case.recordtypeid => recordTypeIdTIssue,
                Case.CEC_Record_Type__c => 'C3 Test CEC Technical Issue'                               
            }
        );   
        //Prepare test data for caseService.setcaseValues <end> 
        //Test.startTest(); 
            CaseHandler objCaseHandler = new CaseHandler(true,1);   
            //call before insert handler method                   
            objCaseHandler.onBeforeInsert(list_CaseTech);
        }           
        Test.stopTest();
        for(Case objCase: list_CaseTech){
            setCaseIds.add(objCase.Id);
            }
        
        for (case CaseTech : [SELECT CEC_Record_Type__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Origin FROM case WHERE Id IN :setCaseIds])
        {
            system.assertEquals(CaseTech.Export_Compliance_Content_ITAR_EAR__c, 'Undetermined');
            system.assertEquals(CaseTech.Government_Compliance_SM_M_Content__c, 'Undetermined');   
            //system.assertEquals(caseTech.Origin,'Honeywell.com CEC');                         
        }        
    } 
    @isTest static void testMethodCaseUtility(){
  Test.startTest(); 
  CaseServiceUtility.getITECUser();
  CaseServiceUtility.getAtrRmuApiUser();
  CaseServiceUtility.getDeniedScreeningAPIUser();
  CaseServiceUtility.getAircraftConnectivity();
  CaseServiceUtility.getEffortlessUser();
  CaseServiceUtility.getMyaerospacewebformUser();
  Test.stopTest();
  }
  
 //start of  test methods for OwnerAssignmentForCSOCasesAfterInsert
    static testMethod void OwnerAssignmentForCSOCasesAfterInsert_BGA(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Account accountWithBGA= [SELECT Id FROM Account WHERE name=:'Test 34Account Energy'];
            Contact contactWithBGA = [SELECT Id FROM Contact WHERE AccountId=:AccountWithBGA.Id];
            Set<Id> setCaseIds= new Set<Id>();
            recId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;       
            
                List<Case> list_CaseOrder= SObjectFactory.create(
                    CASE_COUNT, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                        Case.Origin => 'Email-Orders',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.SuppliedEmail=>'geo@heico.com',
                        Case.Subject=>'',
                        Case.Ownerid => label.NavDB_Accts_Team,
                        Case.RecordTypeId=> recId,
                        Case.Tool_Name__c=>'MCORE',
                        Case.Classification__c => 'R&O Americas Internal',
                        Case.ContactId =>contactWithBGA.Id,
                        Case.AccountId=>accountWithBGA.id,
                        Case.Type => 'Reapir Inquiry',
                        Case.CSM_Region__c => 'Asia/Pacific Rim',
                        Case.Workstrem__c => 'Repair and Overhaul',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.CEC_Record_Type__c => 'C4 Test CEC Orders'                               
                    });  
                
                for(Case objId :list_CaseOrder){
            setCaseIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, PreventCloseonupdate__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c,Work_Team__c
                                                    From Case
                                                    where Id in : setCaseIds]);
                CaseServiceOnInsert.OwnerAssignmentForCSOCasesAfterInsert(updatedCaseList) ;
                
          
        }
        Test.stopTest();
    }
    static testMethod void OwnerAssignmentForCSOCasesAfterInsert_D_S(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){ 
            TriggerInactive.testTrigger = false;
            Account accountWithBGA= [SELECT Id,Work_Team__c,Strategic_Business_Unit__c,Region_Name__c FROM Account WHERE name=:'Test 34Account Energy'];
            accountWithBGA.Work_Team__c= 'India Team';
            accountWithBGA.Strategic_Business_Unit__c= 'D&S';
            accountWithBGA.Region_Name__c= 'Asia/Pacific Rim';
            update accountWithBGA;
            Contact contactWithBGA = [SELECT Id FROM Contact WHERE AccountId=:AccountWithBGA.Id];
            Set<Id> setCaseIds= new Set<Id>();
            recId = RecordTypeServices.getRecordTypeByName('NavDB Accts','Case').Id;       
            
                List<Case> list_CaseOrder= SObjectFactory.create(
                    1, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                        Case.Origin => 'Email-Orders',
                        Case.Status => 'New',
                        Case.Sub_Status__c=>'Waiting for TCT',
                        Case.SuppliedEmail=>'geo@heico.com',
                        Case.Subject=>'',
                        Case.Ownerid => label.NavDB_Accts_Team,
                        Case.RecordTypeId=> recId,
                        Case.Tool_Name__c=>'MCORE',
                        Case.Classification__c => 'R&O Americas Internal',
                        Case.ContactId =>contactWithBGA.Id,
                        Case.AccountId=>accountWithBGA.id,
                        Case.Type => 'Reapir Inquiry',
                        Case.CSM_Region__c => 'Asia/Pacific Rim',
                        Case.Workstrem__c => 'Repair and Overhaul',
                        Case.Export_Compliance_Content_ITAR_EAR__c => 'NO',
                        Case.Government_Compliance_SM_M_Content__c => 'NO',
                        Case.CEC_Record_Type__c => 'C4 Test CEC Orders'                               
                    });  
                
                for(Case objId :list_CaseOrder){
            setCaseIds.add(objId.Id);
        }
        //Query
        List<Case> updatedCaseList = new List<Case>([Select Id, Status, CaseNumber, AccountId, AOG__c, Opportunity_Proposal__c, OwnerId, Iscompliance__c,
                                                    Expected_Update__c, resolution__c, Government_Compliance_SM_M_Content__c, ContactId, vn_name__c, 
                                                    Type_of_Change__c, Export_Compliance_Content_ITAR_EAR__c, recordtypeid, Classification__c, Type, 
                                                    Origin, Sub_Status__c, Reason_for_hold__c, RnOSAPCases__c, IsWorkflowTriggered__c, Mail_Box_Name__c, 
                                                    Subject, Supported_Product__c, Requestor_Email__c, vn_name__r.email, Tool_Name__c, Honeywell_ID__c,
                                                    Fleet_Asset_Aircraft_Number__c, New_Account_Name__c, Sales_Order_Number__c, HIPI_Opportunity__c, CreatedDate,
                                                    Description, SBU__c, Service_Level__c, Serv_Contract__c, User_CBT__c, Region__c, Owner_Manager__c,
                                                    Account_Name__c, Sub_Class__c, Detail_Class__c, Primary_Work_Number__c, Customer_PO_RO_WONumber__c,
                                                    Case_Ref_ID__c, Plant__c, Case_Record_Type__c, Do_not_send_to_portal__c, Quotes_Do_Not_Send_to_Portal__c,
                                                    LastModifiedDate, Account_Type__c, Priority, IsClosed, Emailbox_Origin__c, SuppliedEmail, Primary_Email_Address__c,
                                                    Total__c, Workstrem__c, CSM_Region__c, CreatedById, Date_Time_Stamp_First_Assigned_to_User__c,
                                                    Date_Time_Stamp_User_Assignment_Change__c, Removal_Sub_Status_Selected__c, Others_Sub_Status_Selected__c,
                                                    DSO_Sub_Status_Selected__c, Repair_Location__c, of_Open_Activity__c, SBU_w2c__c, PreventCloseonupdate__c,
                                                    PFECN__c, Account_Concierge__c, Shipment_Sub_Status_Selected__c,Work_Team__c
                                                    From Case
                                                    where Id in : setCaseIds]);
            
              system.debug('updatedCaseList'+updatedCaseList);
                CaseServiceOnInsert.OwnerAssignmentForCSOCasesAfterInsert(updatedCaseList) ;
                
          
        }
        Test.stopTest();
    }
 //end of test methods for OwnerAssignmentForCSOCasesAfterInsert
//Added for addAckemailtocase method 
public static testmethod void AddAckEmailTocaseTest() {
    LIST <
        case >bulkcase = new list <
        case >();
    List < Messaging.SingleEmailMessage > messageList = new List < Messaging.SingleEmailMessage > ();
    Country__c co1 = new Country__c();
    co1.Name = 'US';
    co1.SFDC_Country_Name__c = 'Test US';
    insert co1;
    EmailTemplate et = [select Id, name, body from EmailTemplate where name =: 'Case Creation Acknowledgement To Aero Tech Support'
        limit 1
    ];
    Account a1 = new Account();
        a1.name = 'Test A11AccountPrajny55';
        a1.Customer_Status__c = 'Active';
        a1.Region_Name__c = 'Americas';
        a1.Country__c = co1.id;
        a1.Service_Level__c = 'Comprehensive';
        a1.Strategic_Business_Unit__c = 'ATR';
        a1.CurrencyIsoCode = 'USD';
        a1.type = 'Dealer';
        a1.Tech_Support_Portal__c = true;
        a1.ATS_Redirect_to_Portal__c='Phone and Email';
    insert a1;
    Account a2 = new Account();
        a2.name = 'Test A22AccountPraj22';
        a2.Customer_Status__c = 'Active';
        a2.Region_Name__c = 'Americas';
        a2.Country__c = co1.id;
        a2.Service_Level__c = 'Comprehensive';
        a2.Strategic_Business_Unit__c = 'ATR';
        a2.CurrencyIsoCode = 'USD';
        a2.type = 'Dealer';
        a2.Tech_Support_Portal__c = true;
         a2.ATS_Redirect_to_Portal__c='Phone and Email';
    insert a2;
    Contact c1 = new Contact();
        c1.lastname = 'Test ContactPrajnya1';
        c1.Primary_Email_Address__c = 'mprajnya2895@gmail.com';
        c1.AccountId = a1.id;
        c1.Account = a1;
        c1.Contact_Function__c = 'Agent';
        c1.SBU_Contact__c = 'ATR';
    insert c1;
    Contact c2 = new Contact();
        c2.lastname = 'Test ContactPrajnya2';
        c2.Primary_Email_Address__c = 'mprajnya@outlook.com';
        c2.AccountId = a2.id;
        c2.Account = a2;
        c2.Contact_Function__c = 'Agent';
        c2.SBU_Contact__c = 'ATR';
    insert c2;
    
    Test.startTest();
    Case cs1 = new
    case ();
    //cs1.name='Test Case Prajnya1';
    cs1.origin = 'phone';
    cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
    cs1.Government_Compliance_SM_M_Content__c = 'No';
    cs1.status = 'Open';
    cs1.classification__c = 'GCC';
    cs1.type = 'Other';
    cs1.Emailbox_Origin__c = 'Email-Aerotechsupport';
    cs1.CurrencyIsoCode = 'USD';
    cs1.HON_Commit_Date__c = System.Today();
    cs1.Contact = c1;
    insert cs1;
    case cs2 = new
    case ();
    //cs2.name='Test Case Prajnya2';
    cs2.origin = 'phone';
    cs2.Export_Compliance_Content_ITAR_EAR__c = 'No';
    cs2.Government_Compliance_SM_M_Content__c = 'No';
    cs2.status = 'Open';
    cs2.classification__c = 'GCC';
    cs2.type = 'Other';
    cs2.Emailbox_Origin__c = 'Email-Aerotechsupport';
    cs2.CurrencyIsoCode = 'USD';
    cs2.HON_Commit_Date__c = System.Today();
    cs2.Contact = c2;
    insert cs2;

    //cs1.status='closed';
    //cs2.status='closed';
    if (cs1.Emailbox_Origin__c == 'Email-Aerotechsupport' && cs1.ContactId != null && cs1.account.Tech_Support_Portal__c == true)
        bulkcase.add(cs1);
    if (cs2.Emailbox_Origin__c == 'Email-Aerotechsupport' && cs2.ContactId != null && cs2.account.Tech_Support_Portal__c == true)
        bulkcase.add(cs2);

    if (bulkcase.size() > 0)
        update bulkcase;

    Caseserviceoninsert.AddAckEmailTocase(bulkcase);

    Test.stopTest();
}

static testMethod void test () {
Test.startTest();
//EmailTemplate e = new EmailTemplate (developerName = 'test', FolderId = '00l30000001ReId', TemplateType= 'Text', Name = 'test'); 

//insert e;

case testCase = new case();

//testCase.Case_Record_Type__c='AOG';
testCase.origin='web';
testCase.Is_Case_Owner_a_queue__c =true;

insert testCase;
Test.stopTest();
}
 /*------------------------------------------------------------ 
    Author:        Swathi T 
    Company:       NTT Data
    Description:   This method is used to test the functionality of Attachment Details update on Case object
    History:
    11/1/2021     Created for Intelligent Case Management project.
    */     
public static testMethod void attachmentUpdateTest(){
    List<Case> caseListCreate = new List<Case>();
    //Create Case
     RecordType  objcustomerSuppoert = [SELECT Id FROM RecordType WHERE DeveloperName = 'Orders' AND SobjectType = 'Case'].get(0);
        for(integer i=0;i<2;i++){
            Case caseobj= new Case(origin='Email',RecordTypeId = objcustomerSuppoert.Id);
            caseListCreate.add(caseobj);  
        }
        insert caseListCreate;
        //Create Email Message
        EmailMessage email=new EmailMessage(FromAddress = 'sunil.gampa@nttdata.com',
        ToAddress = 'orders@honeywell.com',
        Subject = '[Draft] ',
        TextBody = '',
        HtmlBody = 'hello' ,
        Status = '3',
        ParentId = caseListCreate[0].id);
        insert email;
        //Add Attachment to the email
        Blob b = Blob.valueOf('Test Data');
        Attachment attachment = new Attachment(ParentId = email.id,Name = 'Test Attachment for Parent',Body = b);
        //insert attachment;
        Test.startTest();
        system.debug('Case list: '+new Map<Id,Case>(caseListCreate).keySet());
        Caseserviceoninsert.attachmentUpdate(new Map<Id,Case>(caseListCreate).keySet()); 


        Test.stopTest();
        //Verify if the File Deatils is updates on the Case

        system.debug('Updated case'+caseListCreate[0].File_Details__c );
}
static testMethod void afterInsertOSContactUS(){
        Test.startTest();
        User runUser = [Select id From User Where Username =: 'test_radha@in.ibm.com' Limit 1];
        System.runAs(runUser){
        TriggerInactive.testTrigger = false;
         account objAccount= (account)SObjectFactory.create(account.sObjectType, new Map<Schema.SObjectField, Object>{
                    account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account',
                    account.type => 'Energy',
                    account.Strategic_Business_Unit__c =>'Aero Level'        
                });
         contact objContact= (contact)SObjectFactory.create(contact.sObjectType, new Map<Schema.SObjectField, Object>{
                    contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test last name',
                    contact.AccountId => objAccount.Id,
                    contact.fax_web__C => '4343434343'     
                });
        listCaseDSClearing = SObjectFactory.create(
            CASE_COUNT_PROVIDE, Case.sObjectType, new Map<Schema.SObjectField, Object>{
                Case.OwnerId => UserInfo.getUserId(),
                Case.Type => 'Order Status', 
                Case.recordtypeid => rtIdDSClearingHouse,
                Case.Classification__c => 'CSO Spares',
                Case.Export_Compliance_Content_ITAR_EAR__c => 'Yes',
                Case.Status => 'In Process',
                Case.Subject=> 'Order Number 453 PO Number ter7',
                Case.contactid => objContact.Id,
                Case.origin=>'Web' 
            });        
        CaseHandler objCaseHandler = new CaseHandler (true,1);   
        objCaseHandler.onAfterInsert(listCaseDSClearing);
        }
        Test.stopTest();
        List<Case> caselst = new List<Case>([Select Id,CaseNumber From Case]);
        system.assert(!caselst.isEmpty(), 'Case should not be null');
        Set<String> strCaseNumber = new Set<String>();
        for(Case cases:caselst){
            strCaseNumber.add(cases.CaseNumber);
        }
    }
    public static testmethod void AddEmailAckCOntactUS() {
    LIST <
        case >bulkcase = new list <
        case >();
    List < Messaging.SingleEmailMessage > messageList = new List < Messaging.SingleEmailMessage > ();
    Country__c co1 = new Country__c();
    co1.Name = 'US';
    co1.SFDC_Country_Name__c = 'Test US';
    insert co1;
    EmailTemplate et = [select Id, name, body from EmailTemplate where name =: 'Case Creation Acknowledgement To Aero Tech Support'
        limit 1
    ];
    Account a1 = new Account();
        a1.name = 'Test A11AccountPrajny55';
        a1.Customer_Status__c = 'Active';
        a1.Region_Name__c = 'Americas';
        a1.Country__c = co1.id;
        a1.Service_Level__c = 'Comprehensive';
        a1.Strategic_Business_Unit__c = 'ATR';
        a1.CurrencyIsoCode = 'USD';
        a1.type = 'Dealer';
        a1.Tech_Support_Portal__c = true;
    insert a1;
    Account a2 = new Account();
        a2.name = 'Test A22AccountPraj22';
        a2.Customer_Status__c = 'Active';
        a2.Region_Name__c = 'Americas';
        a2.Country__c = co1.id;
        a2.Service_Level__c = 'Comprehensive';
        a2.Strategic_Business_Unit__c = 'ATR';
        a2.CurrencyIsoCode = 'USD';
        a2.type = 'Dealer';
        a2.Tech_Support_Portal__c = true;
    insert a2;
    Contact c1 = new Contact();
        c1.lastname = 'Test ContactPrajnya1';
        c1.Primary_Email_Address__c = 'mprajnya2895@gmail.com';
        c1.AccountId = a1.id;
        c1.Account = a1;
        c1.Contact_Function__c = 'Agent';
        c1.SBU_Contact__c = 'ATR';
    insert c1;
    Contact c2 = new Contact();
        c2.lastname = 'Test ContactPrajnya2';
        c2.Primary_Email_Address__c = 'mprajnya@outlook.com';
        c2.AccountId = a2.id;
        c2.Account = a2;
        c2.Contact_Function__c = 'Agent';
        c2.SBU_Contact__c = 'ATR';
    insert c2;
    
    Test.startTest();
    
    case cs2 = new case ();
    //cs2.name='Test Case Prajnya2';
    cs2.origin = 'Web';
    cs2.Export_Compliance_Content_ITAR_EAR__c = 'No';
    cs2.Government_Compliance_SM_M_Content__c = 'No';
    cs2.status = 'Open';
    cs2.classification__c = 'GCC';
    cs2.type = 'Other';
    cs2.Emailbox_Origin__c = 'Email-Aerotechsupport';
    cs2.CurrencyIsoCode = 'USD';
    cs2.HON_Commit_Date__c = System.Today();
    cs2.Contact = c2;
    cs2.contactid=c2.id;
    cs2.Subject = 'Order Number 123 PO Number POUUI';
    cs2.CreatedById=label.API_User_My_Aerospace_Portal;
    insert cs2;
    
    Case cs3 = new case ();
    //cs2.name='Test Case Prajnya2';
    cs3.origin = 'Web';
    cs3.Export_Compliance_Content_ITAR_EAR__c = 'No';
    cs3.Government_Compliance_SM_M_Content__c = 'No';
    cs3.status = 'Open';
    cs3.classification__c = 'GCC';
    cs3.type = 'AOG';
    cs3.Emailbox_Origin__c = 'Email-Aerotechsupport';
    cs3.CurrencyIsoCode = 'USD';
    cs3.HON_Commit_Date__c = System.Today();
    cs3.Contact = c2;
    cs3.contactid=c2.id;
    cs3.Subject = 'MyAerospace AOG Order 3243';
    cs3.CreatedById=label.API_User_My_Aerospace_Portal;
    insert cs3;
    
    
    case cs4 = new case ();
    //cs2.name='Test Case Prajnya2';
    cs4.origin = 'Web';
    cs4.Export_Compliance_Content_ITAR_EAR__c = 'No';
    cs4.Government_Compliance_SM_M_Content__c = 'No';
    cs4.status = 'Open';
    cs4.classification__c = 'GCC';
    cs4.type = 'Other';
    cs4.Emailbox_Origin__c = 'Email-Aerotechsupport';
    cs4.CurrencyIsoCode = 'USD';
    cs4.HON_Commit_Date__c = System.Today();
    cs4.Contact = c2;
    cs4.contactid=c2.id;
    cs4.Subject = 'Order Number 123 PO Number POUUI';
    cs4.CreatedById=label.myaerospace_webform;
    insert cs4;

    bulkcase.add(cs2);
    bulkcase.add(cs3);
    bulkcase.add(cs4);

    if (bulkcase.size() > 0)
        update bulkcase;

    CaseServiceOnInsert.emailMessage(bulkcase);

    Test.stopTest();
}

      
    
   

}