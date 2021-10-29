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
 */
@isTest
private class casecreate_sitecontroller_test {

    static testMethod void myUnitTest() {
        
        //creating account;
        Account acc= new Account(name='Test Account',GCE_Customer_Segment__c='Airline',GCE_CSS__c='Phoenix/America');
        insert acc;
 
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Email='test.11@test.com' );
        insert cont;
        
        Case cases11=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',Customer_PO_RO_WONumber__c='43545',workstrem__c='Spares' ,CSM_Region__c='EMEAI', 
        Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com',Case_Complexity__c = 'OMS');
        insert cases11;
        attachment att = new attachment();
        att.Name='Unit Test Attachment';
        att.Body=Blob.valueOf('Unit Test Attachment Body');
        att.ParentId=cases11.id;
        insert att;
        // TO DO: implement unit test
        Test.startTest(); 
        pageReference pageRef = Page.CaseCreation_sitepage;
        ApexPages.StandardController ctr=new ApexPages.StandardController(cases11);
        casecreate_sitecontroller ccs = new casecreate_sitecontroller(ctr);
        //ccs.text3='Spares';\
        ccs.c.Customer_Name__c=acc.id;
        ccs.addinfo='Payment received';
        ccs.c.CSM_Region__c='EMEAI';
        ccs.c.Primary_Email__c='test.11@test.com';
        ccs.c.Workstrem__c='Spares';
        ccs.helpinfo = 'False';
     ///   ccs.getpriority();
     ///   ccs.getpriorityadd();
        ccs.getworkstrem();
        ccs.accountSelected();
        ccs.gethelpinfoInput();
        ccs.helpInfoSave();
        ccs.caseSelected();
        //ccs.getRegion();
     ///   ccs.check();
        ccs.getoptions();
        ccs.att=att;
        ccs.callattach();
        ccs.add();
        ccs.callpopup();
        ccs.makereq();
        ccs.savecase();
        Test.stopTest();
    }
    static testMethod void myUnitTest1() {
        
        //creating account;
        Account acc= new Account(name='Test Account');
        insert acc;
 
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Email='test.11@test.com' );
        insert cont;
        
        Case parentcase=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Repair Inquiry',Customer_PO_RO_WONumber__c='43545', workstrem__c='Repair and Overhaul' ,CSM_Region__c='Americas', 
        Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com',Case_Complexity__c = 'CSS');
        insert parentcase;
        
        
        
        Case cases11=new Case(ParentId=parentcase.Id,AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Repair Inquiry',Customer_PO_RO_WONumber__c='43545', workstrem__c='Repair and Overhaul' ,CSM_Region__c='Americas', 
        Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com',Case_Complexity__c = 'CSS');
        insert cases11;
         Test.startTest(); 
        attachment att = new attachment();
        att.Name='Unit Test Attachment';
        att.Body=Blob.valueOf('Unit Test Attachment Body');
        att.ParentId=cases11.id;
        insert att;
        // TO DO: implement unit test
       
        pageReference pageRef = Page.CaseCreation_sitepage;
        ApexPages.StandardController ctr=new ApexPages.StandardController(cases11);
        casecreate_sitecontroller ccs = new casecreate_sitecontroller(ctr);
        ccs.c.Priority='High';
        ccs.c.Primary_Email__c='test.11@test.com';
         ccs.addinfo='Line Stop';
        ccs.c.CSM_Region__c='Americas';
        ccs.c.Workstrem__c='Repair and Overhaul';
        ccs.c.Customer_Name__c='Test';
        ccs.helpinfo = 'True';
        ccs.add();
        ccs.callpopup();
      ///  ccs.getpriority();
     ///   ccs.getpriorityadd();
        ccs.getworkstrem();
      ///  ccs.getRegion();
   ///     ccs.check();
        ccs.getoptions();
        
          
        ccs.accountSelected();
        ccs.gethelpinfoInput();
        ccs.helpInfoSave();
        ccs.caseSelected();
        
        
        ccs.att=att;
        ccs.callattach();
        ccs.makereq();
        ccs.savecase();
        Test.stopTest();
    }
    static testMethod void myUnitTest2() {
        
        //creating account;
        Account acc= new Account(name='Test Account');
        insert acc;
 
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Email='test.11@test.com' );
        insert cont;
        
        Case cases11=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Repair Inquiry',Customer_PO_RO_WONumber__c='43545', workstrem__c='OEM' ,CSM_Region__c='Americas',Priority='high', 
        Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com');
        insert cases11;
        attachment att = new attachment();
        att.Name='Unit Test Attachment';
        att.Body=Blob.valueOf('Unit Test Attachment Body');
        att.ParentId=cases11.id;
        insert att;
        // TO DO: implement unit test
        Test.startTest(); 
        pageReference pageRef = Page.CaseCreation_sitepage;
        ApexPages.StandardController ctr=new ApexPages.StandardController(cases11);
        casecreate_sitecontroller ccs = new casecreate_sitecontroller(ctr);
         ccs.c.Priority='High';
         ccs.addinfo='OTTR';
         ccs.c.CSM_Region__c='Americas';
         ccs.c.Customer_Name__c='Test';
        ccs.c.Workstrem__c='OEM';
        ccs.add();
        ccs.callpopup();
      ///  ccs.getpriority();
      ///  ccs.getpriorityadd();
        ccs.getworkstrem();
      ///  ccs.getRegion();
      ///  ccs.check();
        ccs.getoptions();
        
        ccs.att=att;
        ccs.callattach();
        ccs.makereq();
        ccs.savecase();
        Test.stopTest();
    }
    
    static testMethod void myUnitTest3() {
        
        //creating account;
        Account acc= new Account(name='Test Account');
        insert acc;
 
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567',Email='test.11@test.com' );
        insert cont;
        
        Case cases11=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Repair Inquiry',Customer_PO_RO_WONumber__c='43545', workstrem__c='Repair and Overhaul' ,CSM_Region__c='Americas', 
        Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com');
        insert cases11;
        attachment att = new attachment();
        att.Name='Unit Test Attachment';
        att.Body=Blob.valueOf('Unit Test Attachment Body');
        att.ParentId=cases11.id;
        insert att;
        // TO DO: implement unit test
        Test.startTest(); 
        pageReference pageRef = Page.CaseCreation_sitepage;
        ApexPages.StandardController ctr=new ApexPages.StandardController(cases11);
        casecreate_sitecontroller ccs = new casecreate_sitecontroller(ctr);
        ccs.att.Name='Unit Test Attachment';
        ccs.c.Priority='High';
        ccs.c.Primary_Email__c='test.11@test.com';
         ccs.addinfo='';
         ccs.text2='Quotes Escalation';
        ccs.c.CSM_Region__c='Asia/Pacific Rim';
        ccs.c.Workstrem__c='Repair and Overhaul';
        ccs.c.Customer_Name__c='Test';
        ccs.add();
        ccs.callpopup();
      ///  ccs.getpriority();
      ///  ccs.getpriorityadd();
        ccs.getworkstrem();
      ///  ccs.getRegion();
      ///  ccs.check();
        ccs.getoptions();
        
        ccs.att=att;
        ccs.callattach();
        ccs.makereq();
        ccs.savecase();
        Test.stopTest();
    }
}