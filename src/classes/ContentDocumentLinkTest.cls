@isTest
public class ContentDocumentLinkTest{    
    static testMethod void TestContentDocumentLink(){
         Planned_Meeting__c tstPlM = new Planned_Meeting__c(
            Name = 'Test PLanned Meeting',
            Start_Date__c = System.today(),
            Location__c = 'Bangalore',
            End_Date__c = System.today() + 3,
            Meeting_Purpose__c = 'Test Meeting Purpose',
            Attachment_Name__c = 'test'
        );
        insert tstPlM;
        
        system.debug('plan meet' +tstPlM.id);
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;
        cv.Origin = 'C';          
        insert cv;       

        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id AND IsLatest=true];

        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=tstPlM.id;
        contentlink.ShareType= 'V';         
        contentlink.ContentDocumentId=testcontent.ContentDocumentId;
        contentlink.Visibility = 'InternalUsers'; 
        insert contentlink;  
   }
   static testMethod void TestContentDocumentLink1(){
         Planned_Meeting__c tstPlM = new Planned_Meeting__c(
            Name = 'Test PLanned Meeting',
            Start_Date__c = System.today(),
            Location__c = 'Bangalore',
            End_Date__c = System.today() + 3,
            Meeting_Purpose__c = 'Test Meeting Purpose'
        );
        insert tstPlM;
        
        system.debug('plan meet' +tstPlM.id);
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;
        cv.Origin = 'C';          
        insert cv;       

        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id AND IsLatest=true];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=tstPlM.id;
        contentlink.ShareType= 'V';         
        contentlink.ContentDocumentId=testcontent.ContentDocumentId;
        contentlink.Visibility = 'InternalUsers'; 
        insert contentlink;
        ContentDocumentTriggerHandler.conDocBeforeDelete(documents);
   }
       static testMethod void TestContentDocumentLinkSRD(){
              account testAccount = (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.OwnerId => UserInfo.getUserId(),
                    account.Name => 'Test Account Energy',
                    account.type => 'Energy',
                    account.Customer_Status__c =>'Active',
                    account.Strategic_Business_Unit__c => 'BGA',
                    account.CBT__c => 'Airbus',
                    account.Region_Name__c => 'Americas',
                    account.Sub_Region_Name__c => 'Canada',
                    account.Service_Level__c => 'Refer to Network', 
                    account.Type => 'OEM',
                    account.REPORT_ACCOUNT_NAME__c => 'Test Account',
                    account.Market_Name__c => 'Marine',
                    account.CBT_Team__c=>'Americas'         
                    });   
           SRD_Customer_Communication__c testSRD = new SRD_Customer_Communication__c(
            Name = 'Test PLanned Meeting',
            Account__c= testAccount.Id      
        );
        insert testSRD;
        
        system.debug('plan meet' +testSRD.id);
        Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;
        cv.Origin = 'C';          
        insert cv;       

        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id AND IsLatest=true];

        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=testSRD.id;
        contentlink.ShareType= 'V';         
        contentlink.ContentDocumentId=testcontent.ContentDocumentId;
        contentlink.Visibility = 'InternalUsers'; 
        insert contentlink;
   }
   // Added for Quote Automation Project - Code coverage for QA_EmailNotificationHandler
   static testMethod void TestContentDocumentLink2(){
        test.startTest();
            Account acc                 = new Account(); 
            acc.Name                    = 'CHROMALLOY POWER SERVICES CORP';
            acc.GCE_Customer_Segment__c = 'Airline';
            acc.GCE_CSS__c              = 'Phoenix/America';
            acc.GCE_CSS_Type__c         = 'Dedicated';
            insert acc;
            Contact con     = new Contact();
            con.LastName    = 'Martin';
            con.AccountId   = acc.Id;
            con.Email       = 'Martin.Luther@mail.com';
            insert con;
            Case cs = new Case();
            cs.Status = 'Open';
            cs.AccountId = acc.Id;
            cs.ContactId = con.Id;
            cs.RecordtypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('OEM_Spares').getRecordTypeId();
            cs.OwnerId = Label.CSO_OEM_Spares;
            cs.APU_Workcenter__c = 'ZRPR';
            cs.IsAttachment__c = false;
            insert cs;
        
            Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');
            //User us = [SELECT Id,Name FROM User WHERE Id = :System.Label.QA_ApiUser];
            ContentVersion cv = new ContentVersion();
            cv.title = 'V1_0223947379_ZAN1_EN_20201030_013509_ARV_900.PDF';      
            cv.PathOnClient ='test';           
            cv.VersionData =beforeblob;
            cv.Origin = 'C'; 
            //System.runAs(us){
                insert cv;       
        
                ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id AND IsLatest=true];
                List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
                
                ContentDocumentLink contentlink=new ContentDocumentLink();
                contentlink.LinkedEntityId=cs.id;
                contentlink.ShareType= 'I';         
                contentlink.ContentDocumentId=testcontent.ContentDocumentId;
                contentlink.Visibility = 'InternalUsers'; 
                insert contentlink;
                
                List<ContentDocumentLink> contlist = new List<ContentDocumentLink>();
                contlist.add(contentlink);
                /*list<ContentDocument> condoc = new list<ContentDocument>();
                condoc.add(contentlink.ContentDocumentId);*/
                
                ContentDocumentTriggerHandler.conDocLinkAfterInsert(contlist);
                ContentDocumentTriggerHandler.conDocBeforeDelete(documents);
            test.stopTest();
        //}
    } 
}