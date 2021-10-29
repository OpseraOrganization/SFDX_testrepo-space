@isTest 
public class CaseClosureTests {

    public static testMethod void testMyController() {    
      
      Test.startTest(); 
        Profile p1 = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        User testUser = (User)SObjectFactory.create(User.sObjectType,new Map<Schema.SObjectField, Object>
                {
                    User.FirstName => 'TestFirstName',
                    User.LastName => 'TestLastName',
                    User.Email => 'test@in.ibm.com',
                    User.Username => 'test.123@in.ibm.com',
                    User.Alias => 'TestF',
                    User.ProfileId => p1.Id,
                    User.TimeZoneSidKey => 'America/Denver',
                    User.LocaleSidKey => 'en_US',
                    User.EmailEncodingKey => 'UTF-8',
                    User.LanguageLocaleKey => 'en_US'
                });
              user currentUser = (User) SObjectFactory.create(
              User.SObjectType,
            new Map<SObjectField, Object>{
                User.Alias => 'wvarg',
                User.Email => 'wilnellies.vargas=honeywell.com@example.com',
                User.EmailEncodingKey => 'UTF-8',
                User.LastName => 'Customer Master',
                User.FirstName=>'Salesforce',    
                User.LanguageLocaleKey => 'en_US',
                User.LocalesIdKey => 'en_US',
                User.ProfileId => UserInfo.getProfileId(),
                User.TimezonesIdKey => 'America/Los_Angeles',
                //User.Username => 'wilnellies.vargas@honeywell.com'
                User.Username => 'testtest.123@honeywell.com'
            }
        );     
    account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
            account.OwnerId => UserInfo.getUserId(),
            account.Name => 'Test Account1',
            account.type => 'Energy',
            account.Strategic_Business_Unit__c => 'D&S',
            account.Service_Level__c => 'Unauthorized Dist/Brkr',
            account.Do_Not_Send_to_Portal__c => false,
            Account.PFECN__c => null,
            account.Region_Name__c => 'Asia/Pacific Rim'         
            });
     contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
            contact.OwnerId => UserInfo.getUserId(),
            contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
            contact.AccountId => objAccount.Id,
            contact.fax_web__C => '4343434343',
            contact.Email=>'test@in.ibm.com'
            }); 
         User runUser = [Select id From User Where Username =: 'test.123@in.ibm.com' Limit 1];
        System.runAs(runUser ){ 
      TriggerInactive.testTrigger = false;     
      Contact cont;
      cont = [SELECT Id FROM Contact where email='test@in.ibm.com'];
      Account acc;
      acc = [SELECT Id FROM Account WHERE  Name ='Test Account1'];
      List<Case> caseList = new List<case>();      
      Platform__c pl = new Platform__c(name='test pt' );
        insert pl;
        case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
            Case.OwnerId => UserInfo.getUserId(),
            Case.Type => 'CPS BGA Process', 
            Case.Subject => 'Test',
            Case.Status=>'Open',
            Case.Sub_Status__c => 'Accts',
            Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Technical Issue','Case').Id,
            Case.SuppliedEmail => 'Test@gulfstream.com',
            Case.Origin => 'Email',
            Case.AccountId=> acc.Id,
            Case.ContactId=> cont.Id,
            Case.NSN__c => 'Test;NSN', 
            Case.Part_Number__c => 'Test;Part',
            Case.AOG__c=> False,
            Case.Classification__c=> 'GTO', 
            Case.Case_Priority__c => 'Priority 4 – Complex: 1 week to 30 days',
            Case.Customer_Update_Frequency__c => 'Every 7 days',
            Case.Communication_Channel__c => 'Text',
            Case.Sub_Class__c=> 'Electrical',
            Case.SBU_w2c__c =>  'ATR',
            Case.Aircraft_Type__c => pl.id,
            Case.Comments__c=>'test'
        });
        
        insert cas1;        
        system.debug('Aircraft_Type__c:'+cas1.Aircraft_Type__c);    
 
        PageReference pageRef = Page.CaseClosureApproval;
        Test.setCurrentPage(pageRef);

        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('Caseid', Cas1.id);
        ApexPages.currentPage().getParameters().put('Approve', 'True');
        
        // Instantiate a new controller with case status open
         caseclosure controller1 = new caseclosure();
         controller1.updateApprovalrecord();
         case cas=[select P2c_sent__c,status,Aircraft_Type__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c from case where id =: Cas1.id];
         cas.P2c_sent__c = 1;
         cas.status = 'Propose to Close';
         cas.Aircraft_Type__c=pl.id;
         cas.Export_Compliance_Content_ITAR_EAR__c='No';
         cas.Government_Compliance_SM_M_Content__c='No';
         update cas;
 
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('Caseid', Cas1.id);
        ApexPages.currentPage().getParameters().put('Approve', 'True');

        // Instantiate a new controller with case status open
        controller1 = new caseclosure();
        controller1.getItems();
        controller1.getItems1();
        controller1.getItems2();
        controller1.getItems3();
        controller1.getItems4();
        controller1.getItems4ch();
        controller1.getItems4FRA();
        controller1.getItems4GER();
        controller1.getItems4POR();
        controller1.getItems5();
        controller1.getItems6();
        controller1.getItemsjp(); 
        controller1.getItemsch();
        controller1.getItemsGER();
        controller1.getItemsFRA();
        controller1.getItemsPOR();
        controller1.getItems7();
        controller1.getItems7ch();
        controller1.getItems7FRA();
        controller1.getItems7GER();
        controller1.getItems7POR();
        controller1.updateApprovalrecord();
         
     // Instantiate a new controller with case status open
        controller1 = new caseclosure();
         controller1.updateApprovalrecord();
    Test.stopTest();
        
        }
    }
    
 public static testMethod void testMyController1() {

    Test.startTest(); 
        Profile p1 = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        User testUser = (User)SObjectFactory.create(User.sObjectType,new Map<Schema.SObjectField, Object>
                {
                    User.FirstName => 'TestFirstName',
                    User.LastName => 'TestLastName',
                    User.Email => 'test@in.ibm.com',
                    User.Username => 'test.879@in.ibm.com',
                    User.Alias => 'TestF',
                    User.ProfileId => p1.Id,
                    User.TimeZoneSidKey => 'America/Denver',
                    User.LocaleSidKey => 'en_US',
                    User.EmailEncodingKey => 'UTF-8',
                    User.LanguageLocaleKey => 'en_US'
                });
            user currentUser = (User) SObjectFactory.create(
            User.SObjectType,
            new Map<SObjectField, Object>{
                User.Alias => 'wvarg',
                User.Email => 'wilnellies.vargas=honeywell.com@example.com',
                User.EmailEncodingKey => 'UTF-8',
                User.LastName => 'Customer Master',
                User.FirstName=>'Salesforce',    
                User.LanguageLocaleKey => 'en_US',
                User.LocalesIdKey => 'en_US',
                User.ProfileId => UserInfo.getProfileId(),
                User.TimezonesIdKey => 'America/Los_Angeles',
                //User.Username => 'wilnellies.vargas@honeywell.com'
                User.Username => 'testtest.789@honeywell.com'
            }
        );     
    account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
            account.OwnerId => UserInfo.getUserId(),
            account.Name => 'Test Account1',
            account.type => 'Energy',
            account.Strategic_Business_Unit__c => 'D&S',
            account.Service_Level__c => 'Unauthorized Dist/Brkr',
            account.Do_Not_Send_to_Portal__c => false,
            Account.PFECN__c => null,
            account.Region_Name__c => 'Asia/Pacific Rim'         
            });
     contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
            contact.OwnerId => UserInfo.getUserId(),
            contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
            contact.AccountId => objAccount.Id,
            contact.fax_web__C => '4343434343',
            contact.Email=>'test@in.ibm.com'
            }); 
      User runUser = [Select id From User Where Username =: 'test.879@in.ibm.com' Limit 1];
      System.runAs(runUser ){ 
      TriggerInactive.testTrigger = false;
      //data create
      Contact cont;
      cont = [SELECT Id FROM Contact where email='test@in.ibm.com'];
      Account acc;
      acc = [SELECT Id FROM Account WHERE  Name ='Test Account1'];
      List<Case> caseList = new List<case>();     
      Platform__c pl = new Platform__c(name='test pt' );
        insert pl;
        case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
            Case.OwnerId => UserInfo.getUserId(),
            Case.Type => 'CPS BGA Process', 
            Case.Subject => 'Raf',
            Case.Status=>'Open',
            Case.Sub_Status__c => 'Accts',
            Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('Technical Issue','Case').Id,
            Case.SuppliedEmail => 'Test@gulfstream.com',
            Case.Origin => 'Email',
            Case.AccountId=> acc.Id,
            Case.ContactId=> cont.Id,
            Case.NSN__c => 'Test;NSN', 
            Case.Part_Number__c => 'Test;Part',
            Case.AOG__c=> False,
            Case.Classification__c=> 'GTO', 
            Case.Sub_Class__c=> 'Electrical',
            Case.SBU_w2c__c =>  'ATR',
            Case.Aircraft_Type__c => pl.id,
            Case.Comments__c=>'test',
            Case.Export_Compliance_Content_ITAR_EAR__c=> 'No', 
            Case.Government_Compliance_SM_M_Content__c=>'No'
        });
        
        insert cas1;        
        system.debug('Aircraft_Type__c:'+cas1.Aircraft_Type__c);   
 
         cas1.status = 'Closed';
         cas1.P2c_sent__c = 1;
         update cas1;
        list <Case_on_hold_log__c > cohlIST = NEW list < Case_on_hold_log__c >();
        Case_on_hold_log__c cohLog= new Case_on_hold_log__c();
        
        cohLog.Case_Number__c=cas1.id;
        cohLog.Hold_Stop__c = system.now();
        cohlog.CurrencyIsoCode ='USD';
        cohlIST.add(cohLog);
        insert cohlist;
        PageReference pageRef = Page.CaseClosureApproval;
        Test.setCurrentPage(pageRef);

        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('Caseid', cas1.id);
        ApexPages.currentPage().getParameters().put('Reject', 'True');
        
        // Instantiate a new controller with case status open
        caseclosure controller1 = new caseclosure();
        controller1 = new caseclosure();
        controller1.updateApprovalrecord();
        controller1.updateRejectedrecord();
        controller1.setComments('test');
        controller1.setCaseOpenATS('My request has not been resolved');
        controller1.setPhoneCallATS('Yes, have a Technical Support Engineer call me');
        controller1.setnoofcontacts('noofcontacts');
        controller1.setoverallsat(1);
        //controller1.setNpsrec(1);
        controller1.setNocon('2');
        controller1.setCesScore(1);
        controller1.updateRejectedrecord();
        controller1.updateNoOfContacts();
        controller1.disable();
        
        PageReference pageRef1 = Page.CaseClosureApproval;
        Test.setCurrentPage(pageRef1);
        ApexPages.currentPage().getParameters().put('phoneCallparamAOG', 'Yes, have');        
        ApexPages.currentPage().getParameters().put('paramforopenAOG', 'True');
        ApexPages.currentPage().getParameters().put('comments', 'True');
        ApexPages.currentPage().getParameters().put('Caseid', cas1.id);
        ApexPages.currentPage().getParameters().put('Reject', 'True');
        caseclosure controller2 = new caseclosure();
        
        controller2.updateApprovalrecord();
        controller2.updateRejectedrecord();
        controller2.setComments('test');
        controller2.setCaseOpenATS('My request has not been resolved');
        controller2.setPhoneCallATS('Yes, have a Technical Support Engineer call me');
        controller2.setnoofcontacts('noofcontacts');
        controller2.setoverallsat(1);
        //controller2.setNpsrec(1);
        controller2.setNocon('1');
        controller2.setCesScore(1);
        controller2.updateRejectedrecord();
        controller2.updateNoOfContacts();
        controller2.disable();
        
        PageReference pageRef2 = Page.CaseClosureApproval;
        Test.setCurrentPage(pageRef2);
        ApexPages.currentPage().getParameters().put('phoneCallparamAOG', 'No, have');        
        ApexPages.currentPage().getParameters().put('paramforopenAOG', 'True');
        ApexPages.currentPage().getParameters().put('comments', 'True');
        ApexPages.currentPage().getParameters().put('Caseid', cas1.id);
        ApexPages.currentPage().getParameters().put('Reject', 'True');
       
        caseclosure controller3 = new caseclosure();
        
        controller3.updateApprovalrecord();
        controller3.updateRejectedrecord();
        controller3.setComments('test');
        controller3.setCaseOpenATS('My request has not been resolved');
        controller3.setPhoneCallATS('Yes, have a Technical Support Engineer call me');
        controller3.setnoofcontacts('noofcontacts');
        controller3.setoverallsat(1);
        //controller3.setNpsrec(1);
        controller3.setNocon('1');
        controller3.setCesScore(1);
        controller3.updateRejectedrecord();
        controller3.updateNoOfContacts();
        controller3.disable();
    Test.stopTest();
        
    }
  }
/*public static testMethod void testMyController2() {

    Test.startTest(); 
        Profile p1 = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        User testUser = (User)SObjectFactory.create(User.sObjectType,new Map<Schema.SObjectField, Object>
                {
                    User.FirstName => 'TestFirstName',
                    User.LastName => 'TestLastName',
                    User.Email => 'test@in.ibm.com',
                    User.Username => 'test.453@in.ibm.com',
                    User.Alias => 'TestF',
                    User.ProfileId => p1.Id,
                    User.TimeZoneSidKey => 'America/Denver',
                    User.LocaleSidKey => 'en_US',
                    User.EmailEncodingKey => 'UTF-8',
                    User.LanguageLocaleKey => 'en_US'
                });
            user currentUser = (User) SObjectFactory.create(
            User.SObjectType,
            new Map<SObjectField, Object>{
                User.Alias => 'wvarg',
                User.Email => 'wilnellies.vargas=honeywell.com@example.com',
                User.EmailEncodingKey => 'UTF-8',
                User.LastName => 'Customer Master',
                User.FirstName=>'Salesforce',    
                User.LanguageLocaleKey => 'en_US',
                User.LocalesIdKey => 'en_US',
                User.ProfileId => UserInfo.getProfileId(),
                User.TimezonesIdKey => 'America/Los_Angeles',
                //User.Username => 'wilnellies.vargas@honeywell.com'
                User.Username => 'testtest.453@honeywell.com'
            }
        );     
    account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
            account.OwnerId => UserInfo.getUserId(),
            account.Name => 'Test Account1',
            account.type => 'Energy',
            account.Strategic_Business_Unit__c => 'D&S',
            account.Service_Level__c => 'Unauthorized Dist/Brkr',
            account.Do_Not_Send_to_Portal__c => false,
            Account.PFECN__c => null,
            account.Region_Name__c => 'Asia/Pacific Rim'         
            });
     contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
            contact.OwnerId => UserInfo.getUserId(),
            contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
            contact.AccountId => objAccount.Id,
            contact.fax_web__C => '4343434343',
            contact.Email=>'test@in.ibm.com'
            }); 
     User runUser = [Select id From User Where Username =: 'test.453@in.ibm.com' Limit 1];
     System.runAs(runUser ){ 
          TriggerInactive.testTrigger = false;
          //data create
          Contact cont;
          cont = [SELECT Id FROM Contact where email='test@in.ibm.com'];
          Account acc;
          acc = [SELECT Id FROM Account WHERE  Name ='Test Account1'];
          List<Case> caseList = new List<case>(); 
          Platform__c pl = new Platform__c(name='test pt' );
         insert pl;
        case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
            Case.OwnerId => UserInfo.getUserId(),
            Case.Type => 'CPS BGA Process', 
            Case.Subject => 'Raf',
            Case.Status=>'Open',
            Case.Sub_Status__c => 'Accts',
            Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('AOG','Case').Id,
            Case.SuppliedEmail => 'Test@gulfstream.com',
            Case.Origin => 'Email',
            Case.AccountId=> acc.Id,
            Case.ContactId=> cont.Id,
            Case.NSN__c => 'Test;NSN', 
            Case.Part_Number__c => 'Test;Part',
            Case.AOG__c=> False,
            Case.Classification__c=> 'GTO', 
            Case.Sub_Class__c=> 'Electrical',
            Case.SBU_w2c__c =>  'ATR',
            Case.Aircraft_Type__c => pl.id,
            Case.Comments__c=>'test',
            Case.Export_Compliance_Content_ITAR_EAR__c=> 'No', 
            Case.Government_Compliance_SM_M_Content__c=>'No'
        });        
        insert cas1;        
        system.debug('Aircraft_Type__c:'+cas1.Aircraft_Type__c);
   
        cas1.status = 'Propose to Close';
        update cas1;
 
        PageReference pageRef = Page.CaseClosureApproval;
        Test.setCurrentPage(pageRef);

        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('Caseid', cas1.id);
        ApexPages.currentPage().getParameters().put('Reject', 'True');
        
        // Instantiate a new controller with case status open
        caseclosure controller1 = new caseclosure();
        controller1 = new caseclosure();
        controller1.updateApprovalrecord();
        controller1.updateRejectedrecord();
        controller1.getComments();
        controller1.getCaseOpenAOG();
        controller1.getPhoneCallAOG();
        controller1.getCaseOpenATS();
        controller1.getPhoneCallATS();
        controller1.getnoofcontacts();
        controller1.getoverallsat();
        controller1.getNpsrec();
        controller1.getNocon();
        controller1.getCesScore();
        controller1.setCaseOpenAOG('My request has not been resolved');
        controller1.setPhoneCallAOG('Yes, have a Technical Support Engineer call me');
        controller1.updateRejectedrecord();
    Test.stopTest();
        
    }
 } */   
 public static testMethod void testMyController3() {
    
    Test.startTest(); 
         Profile p1 = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        User testUser = (User)SObjectFactory.create(User.sObjectType,new Map<Schema.SObjectField, Object>
                {
                    User.FirstName => 'TestFirstName',
                    User.LastName => 'TestLastName',
                    User.Email => 'test@in.ibm.com',
                    User.Username => 'test.090@in.ibm.com',
                    User.Alias => 'TestF',
                    User.ProfileId => p1.Id,
                    User.TimeZoneSidKey => 'America/Denver',
                    User.LocaleSidKey => 'en_US',
                    User.EmailEncodingKey => 'UTF-8',
                    User.LanguageLocaleKey => 'en_US'
                });
            user currentUser = (User) SObjectFactory.create(
            User.SObjectType,
            new Map<SObjectField, Object>{
                User.Alias => 'wvarg',
                User.Email => 'wilnellies.vargas=honeywell.com@example.com',
                User.EmailEncodingKey => 'UTF-8',
                User.LastName => 'Customer Master',
                User.FirstName=>'Salesforce',    
                User.LanguageLocaleKey => 'en_US',
                User.LocalesIdKey => 'en_US',
                User.ProfileId => UserInfo.getProfileId(),
                User.TimezonesIdKey => 'America/Los_Angeles',
                //User.Username => 'wilnellies.vargas@honeywell.com'
                User.Username => 'testtest.090@honeywell.com'
            }
        );     
    account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
            account.OwnerId => UserInfo.getUserId(),
            account.Name => 'Test Account1',
            account.type => 'Energy',
            account.Strategic_Business_Unit__c => 'D&S',
            account.Service_Level__c => 'Unauthorized Dist/Brkr',
            account.Do_Not_Send_to_Portal__c => false,
            Account.PFECN__c => null,
            account.Region_Name__c => 'Asia/Pacific Rim'         
            });
     contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
            contact.OwnerId => UserInfo.getUserId(),
            contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
            contact.AccountId => objAccount.Id,
            contact.fax_web__C => '4343434343',
            contact.Email=>'test@in.ibm.com'
            }); 
         User runUser = [Select id From User Where Username =: 'test.090@in.ibm.com' Limit 1];
         System.runAs(runUser ){ 
         TriggerInactive.testTrigger = false;
          //data create
          Contact cont;
          cont = [SELECT Id FROM Contact where email='test@in.ibm.com'];
          Account acc;
          acc = [SELECT Id FROM Account WHERE  Name ='Test Account1'];
          List<Case> caseList = new List<case>();          
          Platform__c pl = new Platform__c(name='test pt' );
        insert pl;
        //Case.RecordtypeId = RecordTypeServices.getrecordtypebyName('AOG','Case').Id;
        case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
            Case.OwnerId => UserInfo.getUserId(),
            Case.Type => 'CPS BGA Process', 
            Case.Subject => 'Raf',
            Case.Status=>'Open',
            Case.Sub_Status__c => 'Accts',
            Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('AOG','Case').Id,
            Case.SuppliedEmail => 'Test@gulfstream.com',
            Case.Origin => 'Email',
            Case.AccountId=> acc.Id,
            Case.ContactId=> cont.Id,
            Case.NSN__c => 'Test;NSN', 
            Case.Part_Number__c => 'Test;Part',
            Case.AOG__c=> false,            
            Case.Classification__c=> 'GTO', 
            Case.Sub_Class__c=> 'Electrical',
            Case.SBU_w2c__c =>  'ATR',
            Case.Aircraft_Type__c => pl.id,
            Case.Comments__c=>'test',
            Case.Export_Compliance_Content_ITAR_EAR__c=> 'No', 
            Case.Government_Compliance_SM_M_Content__c=>'No'
        });        
        insert cas1;
        
        system.debug('Aircraft_Type__c:'+cas1.Aircraft_Type__c);
   
        cas1.status = 'Close-Won';
        cas1.RecordtypeId = RecordTypeServices.getrecordtypebyName('AOG','Case').Id;
        Cas1.AOG__c = true;
        //cas1.isclosed = false;
        cas1.Expected_Update__c = system.now();
        update cas1;

        PageReference pageRef = Page.CaseClosureApproval;
        Test.setCurrentPage(pageRef);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('Caseid', cas1.id);
        ApexPages.currentPage().getParameters().put('Approve', 'True');
        
        // Instantiate a new controller with case status open
        caseclosure controller1 = new caseclosure();
        controller1 = new caseclosure();
        controller1.updateApprovalrecord();        
        controller1 = new caseclosure();
        controller1.updateApprovalrecord();         
    Test.stopTest();
       }    
  }
  public static testMethod void testMyController4() {
    
    Test.startTest(); 
        Profile p1 = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        User testUser = (User)SObjectFactory.create(User.sObjectType,new Map<Schema.SObjectField, Object>
                {
                    User.FirstName => 'TestFirstName',
                    User.LastName => 'TestLastName',
                    User.Email => 'test@in.ibm.com',
                    User.Username => 'test.1923@in.ibm.com',
                    User.Alias => 'TestF',
                    User.ProfileId => p1.Id,
                    User.TimeZoneSidKey => 'America/Denver',
                    User.LocaleSidKey => 'en_US',
                    User.EmailEncodingKey => 'UTF-8',
                    User.LanguageLocaleKey => 'en_US'
                });
            user currentUser = (User) SObjectFactory.create(
            User.SObjectType,
            new Map<SObjectField, Object>{
                User.Alias => 'wvarg',
                User.Email => 'wilnellies.vargas=honeywell.com@example.com',
                User.EmailEncodingKey => 'UTF-8',
                User.LastName => 'Customer Master',
                User.FirstName=>'Salesforce',    
                User.LanguageLocaleKey => 'en_US',
                User.LocalesIdKey => 'en_US',
                User.ProfileId => UserInfo.getProfileId(),
                User.TimezonesIdKey => 'America/Los_Angeles',
                //User.Username => 'wilnellies.vargas@honeywell.com'
                User.Username => 'testtest.1923@honeywell.com'
            }
        );     
    account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
            account.OwnerId => UserInfo.getUserId(),
            account.Name => 'Test Account1',
            account.type => 'Energy',
            account.Strategic_Business_Unit__c => 'D&S',
            account.Service_Level__c => 'Unauthorized Dist/Brkr',
            account.Do_Not_Send_to_Portal__c => false,
            Account.PFECN__c => null,
            account.Region_Name__c => 'Asia/Pacific Rim'         
            });
     contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
            contact.OwnerId => UserInfo.getUserId(),
            contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
            contact.AccountId => objAccount.Id,
            contact.fax_web__C => '4343434343',
            contact.Email=>'test@in.ibm.com'
            }); 
      User runUser = [Select id From User Where Username =: 'test.1923@in.ibm.com' Limit 1];
      System.runAs(runUser ){ 
      TriggerInactive.testTrigger = false;
      //data create
      Contact cont;
      cont = [SELECT Id FROM Contact where email='test@in.ibm.com'];
      Account acc;
      acc = [SELECT Id FROM Account WHERE  Name ='Test Account1'];
      List<Case> caseList = new List<case>(); 
     /* Platform__c pl = (Platform__c)SObjectFactory.build(Platform__c.sObjectType, new Map<Schema.SObjectField, Object>{
       Platform__c.name=>'test platform'
      });*/
      Platform__c pl = new Platform__c(name='test pt' );
        insert pl;
        case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
            Case.OwnerId => UserInfo.getUserId(),
            Case.Type => 'CPS BGA Process', 
            Case.Subject => 'Raf',
            Case.Status=>'Open',
            Case.Sub_Status__c => 'Accts',
            Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('AOG','Case').Id,
            Case.SuppliedEmail => 'Test@gulfstream.com',
            Case.Origin => 'Email',
            Case.AccountId=> acc.Id,
            Case.ContactId=> cont.Id,
            Case.NSN__c => 'Test;NSN', 
            Case.Part_Number__c => 'Test;Part',
            Case.AOG__c=> False,
            Case.Classification__c=> 'GTO', 
            Case.Sub_Class__c=> 'Electrical',
            Case.SBU_w2c__c =>  'ATR',
            Case.Aircraft_Type__c => pl.id,
            Case.Comments__c=>'test',
            Case.Export_Compliance_Content_ITAR_EAR__c=> 'No', 
            Case.Government_Compliance_SM_M_Content__c=>'No'
        });
        
        insert cas1;
        
        system.debug('Aircraft_Type__c:'+cas1.Aircraft_Type__c);
     
        cas1.status= 'Open-Rejected';
        cas1.ContactRequested__c='yes';
        update cas1;        

        PageReference pageRef = Page.CaseClosureApproval;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Caseid', cas1.id);
        ApexPages.currentPage().getParameters().put('I’m requesting a phone call to discuss my case:', 'True');
        
        caseclosure controller1 = new caseclosure();
        controller1 = new caseclosure();
        controller1.updateApprovalrecord();       
        controller1 = new caseclosure();
        controller1.updateApprovalrecord();
        controller1.disable();
        controller1.cancel1();
        controller1.cancel2();
        caseclosure.getUserDetails(runUser.Id);
        controller1.reasonforopenAOG ='test';
        controller1.reasonforopenATS ='test';
        controller1.issueResolution ='test';
        controller1.phoneCallRequestAOG ='test';
        controller1.phoneCallRequestATS ='test';
        //controller1.isTechPubs = true;
        //controller1.isSPEXOrders = true;
        controller1.cmts=true;
    Test.stopTest();
        
        }
    }
public static testMethod void testMyController5() {
    
    Test.startTest(); 
        Profile p1 = [SELECT Id FROM Profile WHERE Name ='System Administrator'];
        User testUser = (User)SObjectFactory.create(User.sObjectType,new Map<Schema.SObjectField, Object>
                {
                    User.FirstName => 'TestFirstName',
                    User.LastName => 'TestLastName',
                    User.Email => 'test@in.ibm.com',
                    User.Username => 'test.0282@in.ibm.com',
                    User.Alias => 'TestF',
                    User.ProfileId => p1.Id,
                    User.TimeZoneSidKey => 'America/Denver',
                    User.LocaleSidKey => 'en_US',
                    User.EmailEncodingKey => 'UTF-8',
                    User.LanguageLocaleKey => 'en_US'
                });
            user currentUser = (User) SObjectFactory.create(
            User.SObjectType,
            new Map<SObjectField, Object>{
                User.Alias => 'wvarg',
                User.Email => 'wilnellies.vargas=honeywell.com@example.com',
                User.EmailEncodingKey => 'UTF-8',
                User.LastName => 'Customer Master',
                User.FirstName=>'Salesforce',    
                User.LanguageLocaleKey => 'en_US',
                User.LocalesIdKey => 'en_US',
                User.ProfileId => UserInfo.getProfileId(),
                User.TimezonesIdKey => 'America/Los_Angeles',
                //User.Username => 'wilnellies.vargas@honeywell.com'
                User.Username => 'testtest.0282@honeywell.com'
            }
        );     
    account objAccount= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
            account.OwnerId => UserInfo.getUserId(),
            account.Name => 'Test Account1',
            account.type => 'Energy',
            account.Strategic_Business_Unit__c => 'D&S',
            account.Service_Level__c => 'Unauthorized Dist/Brkr',
            account.Do_Not_Send_to_Portal__c => false,
            Account.PFECN__c => null,
            account.Region_Name__c => 'Asia/Pacific Rim'         
            });
     contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
            contact.OwnerId => UserInfo.getUserId(),
            contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
            contact.AccountId => objAccount.Id,
            contact.fax_web__C => '4343434343',
            contact.Email=>'test@in.ibm.com'
            }); 
     User runUser = [Select id From User Where Username =: 'test.0282@in.ibm.com' Limit 1];
     System.runAs(runUser ){ 
      TriggerInactive.testTrigger = false;
      //data create
      Contact cont;
      cont = [SELECT Id FROM Contact where email='test@in.ibm.com'];
      Account acc;
      acc = [SELECT Id FROM Account WHERE  Name ='Test Account1'];
      List<Case> caseList = new List<case>();     
      Platform__c pl = new Platform__c(name='test pt' );
        insert pl;
        case Cas1 = (Case)SObjectFactory.build(Case.sObjectType, new Map<Schema.SObjectField, Object>{
            Case.OwnerId => UserInfo.getUserId(),
            Case.Type => 'CPS BGA Process', 
            Case.Subject => 'Raf',
            Case.Status=>'Open-Rejected',
            Case.Sub_Status__c => 'Accts',
            Case.RecordtypeId => RecordTypeServices.getrecordtypebyName('AOG','Case').Id,
            Case.SuppliedEmail => 'Test@gulfstream.com',
            Case.Origin => 'Email',
            Case.AccountId=> acc.Id,
            Case.ContactId=> cont.Id,
            Case.NSN__c => 'Test;NSN', 
            Case.Part_Number__c => 'Test;Part',
            Case.AOG__c=> False,
            Case.Classification__c=> 'GTO', 
            Case.Sub_Class__c=> 'Electrical',
            Case.SBU_w2c__c =>  'ATR',
            Case.Aircraft_Type__c => pl.id,
            Case.Comments__c=>'test',
            Case.Export_Compliance_Content_ITAR_EAR__c=> 'No', 
            Case.Government_Compliance_SM_M_Content__c=>'No',
            Case.contactrequested__c=> 'Yes, have a member of the management team call me'
        });
        
        insert cas1;
        
        system.debug('Aircraft_Type__c:'+cas1.Aircraft_Type__c);      
       
    Test.stopTest();
        
    }
  }     
 }