@isTest(SeeAllData=false)
public class RDF_OneOffInternalApprovalPageCtrlTest
{ 
    @testSetup 
    static void setupForTestData(){    
        Id devRecordTypeId = RecordTypeServices.getRecordTypeByName('One-Off Discount','Case').Id;
        system.debug('recordtypeid inserted********'+devRecordTypeId);
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        ID newuser = Userinfo.getUserid();
        
        //Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User newuser12 = new User(LastName = 'Test',
                                  FirstName='Myname',
                                  Alias = 'tmlv',
                                  Email = 'Test.mytest@abc.com',
                                  Username = 'test.mytests@abcd.com',
                                  ProfileId = profileId.id,
                                  TimeZoneSidKey = 'GMT',
                                  LanguageLocaleKey = 'en_US',
                                  EmailEncodingKey = 'UTF-8',
                                  LocaleSidKey = 'en_US'
                                 );
        insert newuser12;
        
        List<Case> caseList = new List<Case>();
        Case newcase0 = new Case();
        newcase0.User_VN_Name__c = newuser12.id; 
        newcase0.FSE_Name_1__c=newuser;
        newcase0.FSE_Name_2__c=newuser;
        newcase0.FSE_Name_3__c=newuser;
        newcase0.status = 'Open';
        newcase0.RecordTypeId = devRecordTypeId;
        //newcase0.Is_Record_Submited_for_Approval__c = true;
         newcase0.Show_in_Community_Flag__c =false;
        //newcase0.Sub_Status__c='Approved';
        newcase0.Classification__c='Customer Approved';
        //newcase.Show_in_Community_Flag__c = true;        
        caseList.add(newcase0);
        
        Case newcase = new Case();
        newcase.User_VN_Name__c = newuser12.id; 
        newcase.FSE_Name_1__c=newuser;
        newcase.FSE_Name_2__c=newuser;
        newcase.FSE_Name_3__c=newuser;
        newcase.status = 'Open';
        newcase.RecordTypeId = devRecordTypeId;
        newcase.Is_Record_Submited_for_Approval__c = true;
        newcase.Show_in_Community_Flag__c =false;
        newcase.Sub_Status__c='Approved';
        newcase.Classification__c='Customer Approved';
        //newcase.Show_in_Community_Flag__c = true;        
        caseList.add(newcase);
        
        Case newcase1 = new Case();
        newcase1.User_VN_Name__c = newuser12.id;
        newcase1.status = '';
        newcase1.RecordTypeId = devRecordTypeId;
        newcase1.Show_in_Community_Flag__c = true;        
        newcase1.Classification__c='Customer Approved'; 
        newcase1.Sub_Status__c =null;   
        newcase1.Is_Record_Submited_for_Approval__c = true;               
        caseList.add(newcase1);
        
        Case newcase2 = new Case();
        newcase2.User_VN_Name__c = newuser12.id;
        newcase2.status = 'Rejected';
        newcase2.RecordTypeId = devRecordTypeId;
        newcase2.Show_in_Community_Flag__c = true;        
        newcase2.Classification__c='Customer Approved'; 
        newcase2.Sub_Status__c ='Rejected';   
        //newcase2.Is_Record_Submited_for_Approval__c = true;               
        caseList.add(newcase2);
        
        insert caseList;
        
        SEA_Approval__c sea = new SEA_Approval__c();
        sea.case__c = newcase.id;
        sea.Name ='Test';
        sea.Approval_Status__c = 'Not Submitted';
        sea.Approver_Name__c = newuser12.id;
        insert sea;
        sea.Approval_Status__c = 'Approved';
        update sea;
        
        /*Blob b = Blob.valueOf('Test Data');
        
        Attachment attachment = new Attachment();
        attachment.ParentId = newcase.id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        
        
        insert attachment;*/
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='Test'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob;         
        content.origin = 'H';
        insert content;
        List<ContentDocumentLink> contentList = new List<ContentDocumentLink>();
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=newcase.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'V';  
        contentList.add(contentlink);   
        ContentDocumentLink contentlink1=new ContentDocumentLink();
        contentlink1.LinkedEntityId=newcase1.id;
        contentlink1.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink1.ShareType = 'V'; 
        contentList.add(contentlink1);  
        ContentDocumentLink contentlink2=new ContentDocumentLink();
        contentlink2.LinkedEntityId=newcase2.id;
        contentlink2.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink2.ShareType = 'V'; 
        contentList.add(contentlink2);          
        insert contentList;        
    }    
    static testmethod void submitForApprovalTest(){       
        Set<String> contentDocIdSet = new Set<String>();
        Case newcase = [Select id from case where Is_Record_Submited_for_Approval__c = true limit 1];
        ContentDocumentLink contentlink =[Select Id from ContentDocumentLink where LinkedEntityId =:newcase.id limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(newcase);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase.id);
        contentDocIdSet.add(contentlink.Id);
        Test.StartTest();
        RDF_OneOffInternalApprovalPageController rdf = new RDF_OneOffInternalApprovalPageController(sc);
        rdf.validateandSubmit();
        rdf.back();
        rdf.sendEmail(newcase,contentDocIdSet,'Internal');
        
        newcase.User_VN_Name__c = null;        
        newcase.Classification__c=null;
        newcase.Show_in_Community_Flag__c= true;  
        
        update newcase;
        
        RDF_OneOffInternalApprovalPageController rdf1 = new RDF_OneOffInternalApprovalPageController(sc);
        rdf1.sendEmail(newcase,contentDocIdSet,'External');
        rdf1.validateandSubmit();
        Test.StopTest();
    }
    
    static testmethod void submitForApprovalTest1(){       
        Set<String> contentDocIdSet = new Set<String>();
        Case newcase = [Select id from case where Is_Record_Submited_for_Approval__c = true limit 1];
        newcase.Is_Record_Submited_for_Approval__c =false;
        ContentDocumentLink contentlink =[Select Id from ContentDocumentLink where LinkedEntityId =:newcase.id limit 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(newcase);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase.id);
        contentDocIdSet.add(contentlink.Id);
       Test.StartTest();
        RDF_OneOffInternalApprovalPageController rdf = new RDF_OneOffInternalApprovalPageController(sc);
        rdf.validateandSubmit();
        newcase.Is_Record_Submited_for_Approval__c = false;     
        update newcase;              
        RDF_OneOffInternalApprovalPageController rdf1 = new RDF_OneOffInternalApprovalPageController(sc);   
        rdf1.validateandSubmit();        
        Test.StopTest();
    }    
    static testmethod void submitForApprovalTest2(){       
        Set<String> contentDocIdSet = new Set<String>();
        Case newcase = [Select id from case where status = 'Rejected'limit 1];
        newcase.Is_Record_Submited_for_Approval__c =false;
        ContentDocumentLink contentlink =[Select Id from ContentDocumentLink where LinkedEntityId =:newcase.id limit 1];
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(newcase);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase.id);
        contentDocIdSet.add(contentlink.Id);
        RDF_OneOffInternalApprovalPageController rdf = new RDF_OneOffInternalApprovalPageController(sc);
        rdf.validateandSubmit();  
        Test.StopTest();
    }
    static testmethod void submitForApprovalTest3(){       
         Test.StartTest();
        Set<String> contentDocIdSet = new Set<String>();
        Case newcase=new Case(subject='Fax:{9986502495} test data',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
                              Type='Order',Customer_PO_RO_WONumber__c='43545',workstrem__c='Spares' ,CSM_Region__c='EMEAI',FSE_Name_1__c=Userinfo.getUserid(),FSE_Name_2__c=Userinfo.getUserid(),FSE_Name_3__c=Userinfo.getUserid(),
                              User_VN_Name__c=Userinfo.getUserid(),Show_in_Community_Flag__c = True,Classification__c = 'Customer Approved' , Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com');
        insert newcase;       
        ApexPages.StandardController sc = new ApexPages.StandardController(newcase);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase.id);
       //Test.StartTest();
        RDF_OneOffInternalApprovalPageController rdf2=new RDF_OneOffInternalApprovalPageController (sc);
        rdf2.sendEmail(newcase,contentDocIdSet,'Internal');
        rdf2.validateandSubmit();
        rdf2.back();
        Test.StopTest();
    }   
    static testmethod void submitForApprovalTest4(){       
        Test.StartTest();
        Set<String> contentDocIdSet = new Set<String>();
        Case newcase=new Case(subject='Fax:{9986502495} test data',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
                              Type='Order',Customer_PO_RO_WONumber__c='43545',workstrem__c='Spares' ,CSM_Region__c='EMEAI',FSE_Name_1__c=Userinfo.getUserid(),FSE_Name_2__c=Userinfo.getUserid(),FSE_Name_3__c=Userinfo.getUserid(),
                              User_VN_Name__c=Userinfo.getUserid(),Classification__c = '' , Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com',
                              Show_in_Community_Flag__c= True,Sub_Status__c ='');
        insert newcase;       
        ApexPages.StandardController sc = new ApexPages.StandardController(newcase);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase.id);      
       // Test.StartTest();
        RDF_OneOffInternalApprovalPageController rdf2=new RDF_OneOffInternalApprovalPageController(sc);
        rdf2.sendEmail(newcase,contentDocIdSet,'Internal');
        rdf2.validateandSubmit();
        rdf2.back();
        Test.StopTest();
    }  
    static testmethod void submitForApprovalTest5(){       
        Set<String> contentDocIdSet = new Set<String>();
        Case newcase = [Select id from case where Is_Record_Submited_for_Approval__c = true limit 1];
        newcase.Is_Record_Submited_for_Approval__c =false;
        ContentDocumentLink contentlink =[Select Id from ContentDocumentLink where LinkedEntityId =:newcase.id limit 1];
        newcase.Is_Record_Submited_for_Approval__c = true;
        newcase.Sub_Status__c='Rejected'; 
        update newcase;              
        ApexPages.StandardController sc = new ApexPages.StandardController(newcase);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase.id);
        contentDocIdSet.add(contentlink.Id);
        Test.StartTest();
        RDF_OneOffInternalApprovalPageController rdf = new RDF_OneOffInternalApprovalPageController(sc);
        rdf.validateandSubmit();    
        Test.StopTest();
    }    
    
    static testmethod void submitForApprovalTest6(){
     Test.StartTest();       
        Set<String> contentDocIdSet = new Set<String>();
        Case newcase=new Case(subject='Fax:{9986502495} test data',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
                              Type='Order',Customer_PO_RO_WONumber__c='43545',workstrem__c='Spares' ,CSM_Region__c='EMEAI',FSE_Name_1__c=Userinfo.getUserid(),FSE_Name_2__c=Userinfo.getUserid(),FSE_Name_3__c=Userinfo.getUserid(),
                              User_VN_Name__c=Userinfo.getUserid(),Sub_Status__c='Rejected' , Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com');
        insert newcase; 
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='Test'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob;         
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=newcase.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'V';  
        insert  contentlink;      
        
        ApexPages.StandardController sc = new ApexPages.StandardController(newcase);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase.id);
        contentDocIdSet.add(contentlink.Id);
       //Test.StartTest();
        RDF_OneOffInternalApprovalPageController rdf = new RDF_OneOffInternalApprovalPageController(sc);
        rdf.validateandSubmit();    
        Test.StopTest();
    }
    static testmethod void submitForApprovalTest7(){       
         Test.StartTest();
        Set<String> contentDocIdSet = new Set<String>();
        Case newcase=new Case(subject='Fax:{9986502495} test data',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
                              Type='Order',Customer_PO_RO_WONumber__c='43545',workstrem__c='Spares' ,CSM_Region__c='EMEAI',FSE_Name_1__c=Userinfo.getUserid(),FSE_Name_2__c=Userinfo.getUserid(),FSE_Name_3__c=Userinfo.getUserid(),
                              User_VN_Name__c=Userinfo.getUserid(),Is_Record_Submited_for_Approval__c=false, Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com');
        insert newcase; 
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='Test'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob;         
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=newcase.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'V';  
        insert  contentlink;      
        
        ApexPages.StandardController sc = new ApexPages.StandardController(newcase);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase.id);
        contentDocIdSet.add(contentlink.Id);
      
        RDF_OneOffInternalApprovalPageController rdf = new RDF_OneOffInternalApprovalPageController(sc);
        rdf.validateandSubmit();    
        Test.StopTest();
        
    }
    static testmethod void submitForApprovalTest8(){       
        Test.StartTest();
        Set<String> contentDocIdSet = new Set<String>();
        Case newcase=new Case(subject='Fax:{9986502495} test data',Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',Sub_Status__c ='Approved',
                              Type='Order',Customer_PO_RO_WONumber__c='43545',workstrem__c='Spares' ,CSM_Region__c='EMEAI',FSE_Name_1__c=Userinfo.getUserid(),FSE_Name_2__c=Userinfo.getUserid(),FSE_Name_3__c=Userinfo.getUserid(),
                              User_VN_Name__c=Userinfo.getUserid(),Show_in_Community_Flag__c = True,Classification__c = 'Customer Approved' , Supported_Product__c='Radio',Origin ='Email-Disputes',Primary_Email__c='test.11@test.com');
        insert newcase;   
        Blob b = Blob.valueOf('Test Data');
        
        Attachment attachment = new Attachment();
        attachment.ParentId = newcase.id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        
        
        insert attachment;
        
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='Test'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob;         
        content.origin = 'H';
        insert content;
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=newcase.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        contentlink.ShareType = 'V';  
        insert  contentlink;      
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(newcase);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase.id);      
        
        RDF_OneOffInternalApprovalPageController rdf2=new RDF_OneOffInternalApprovalPageController (sc);
        rdf2.sendEmail(newcase,contentDocIdSet,'Internal');
        rdf2.validateandSubmit();
        rdf2.back();
        Test.StopTest();
    }
    static testmethod void submitForApprovalTest9(){
        Test.StartTest();
        Set<String> contentDocIdSet = new Set<String>();
        Id devRecordTypeId = RecordTypeServices.getRecordTypeByName('One-Off Discount','Case').Id;
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        ID newuser = Userinfo.getUserid();
        
        //Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User newuser123 = new User(LastName = 'Test',
                                  FirstName='Myname',
                                  Alias = 'tmlv',
                                  Email = 'Test.mytest@abcf.com',
                                  Username = 'test.mytests@abcde.com',
                                  ProfileId = profileId.id,
                                  TimeZoneSidKey = 'GMT',
                                  LanguageLocaleKey = 'en_US',
                                  EmailEncodingKey = 'UTF-8',
                                  LocaleSidKey = 'en_US'
                                 );
        insert newuser123;
        
        List<Case> caseList = new List<Case>();
        
        Case newcase9 = new Case();
        newcase9.User_VN_Name__c = newuser123.id; 
        newcase9.FSE_Name_1__c=newuser;
        newcase9.FSE_Name_2__c=newuser;
        newcase9.FSE_Name_3__c=newuser;
        newcase9.status = 'Open';
        newcase9.RecordTypeId = devRecordTypeId;
        newcase9.Is_Record_Submited_for_Approval__c = false;
        //newcase9.Show_in_Community_Flag__c =false;
        ///newcase9.Sub_Status__c='Approved';
        //newcase9.Classification__c ='Customer Approved';
        newcase9.Show_in_Community_Flag__c = false;        
        
        insert newcase9;
            SEA_Approval__c sea = new SEA_Approval__c();
        sea.case__c = newcase9.id;
        sea.Name ='Test';
        sea.Approval_Status__c = 'Not Submitted';
        sea.Approver_Name__c = newuser123.id;
        insert sea;
        //sea.Approval_Status__c = 'Approved';
        //update sea;
        
        Blob b = Blob.valueOf('Test Data');
        
        Attachment attachment = new Attachment();
        attachment.ParentId = newcase9.id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        
        
        insert attachment;
        
         ApexPages.StandardController sc = new ApexPages.StandardController(newcase9);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase9.id);      
        
        RDF_OneOffInternalApprovalPageController rdf2=new RDF_OneOffInternalApprovalPageController (sc);
        rdf2.sendEmail(newcase9,contentDocIdSet,'Internal');
        rdf2.validateandSubmit();
        rdf2.back();
        Test.StopTest();
    }
    static testmethod void submitForApprovalTest10(){
        Test.StartTest();
        Set<String> contentDocIdSet = new Set<String>();
         Id devRecordTypeId = RecordTypeServices.getRecordTypeByName('One-Off Discount','Case').Id;
        ID newuser = Userinfo.getUserid();
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
          User newuser1234 = new User(LastName = 'Test',
                                  FirstName='Myname',
                                  Alias = 'tmlv',
                                  Email = 'Test.mytest@abcf.com',
                                  Username = 'test.mytests@abcde.com',
                                  ProfileId = profileId.id,
                                  TimeZoneSidKey = 'GMT',
                                  LanguageLocaleKey = 'en_US',
                                  EmailEncodingKey = 'UTF-8',
                                  LocaleSidKey = 'en_US'
                                 );
        insert newuser1234;
          Case newcase9 = new Case();
        newcase9.User_VN_Name__c = newuser1234.id; 
        newcase9.FSE_Name_1__c=newuser;
        newcase9.FSE_Name_2__c=newuser;
       newcase9.FSE_Name_3__c=newuser;
        newcase9.status = 'Awaiting Approval';
       newcase9.RecordTypeId = devRecordTypeId;
        //newcase9.Is_Record_Submited_for_Approval__c = false;
        newcase9.Show_in_Community_Flag__c =false;
        newcase9.Sub_Status__c='Approved';
       // newcase9.Classification__c ='Customer Approved';
       // newcase9.Show_in_Community_Flag__c = false;        
        
        insert newcase9;
        
        SEA_Approval__c sea = new SEA_Approval__c();
        sea.case__c = newcase9.id;
        sea.Name ='Test';
        sea.Approval_Status__c = 'Not Submitted';
        sea.Approver_Name__c = newuser1234.id;
        insert sea;
        //sea.Approval_Status__c = 'Approved';
        //update sea;
        
         Blob b = Blob.valueOf('Test Data');
        
        Attachment attachment = new Attachment();
        attachment.ParentId = newcase9.id;
        attachment.Name = 'Test Attachment for Parent';
        attachment.Body = b;
        
        
        insert attachment;
        
       // newcase9.Is_Record_Submited_for_Approval__c = true;
        //update newcase9;
        
          ApexPages.StandardController sc = new ApexPages.StandardController(newcase9);
        Id currentRecordId  = ApexPages.CurrentPage().getparameters().put('id',newcase9.id);      
        
        RDF_OneOffInternalApprovalPageController rdf2=new RDF_OneOffInternalApprovalPageController (sc);
         rdf2.validateandSubmit();
        case c =new case();
        rdf2.sendEmail(c,contentDocIdSet,'Internal');
       
        rdf2.back();
        Test.StopTest();
    }
}