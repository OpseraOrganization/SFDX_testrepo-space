@isTest//(seeAlldata=true)
public class DContentDocumentTest{    
    static testMethod void ContentDocumentTest(){        
        Planned_Meeting__c tstPlM = new Planned_Meeting__c(
            Name = 'Test PLanned Meeting',
            Start_Date__c = System.today(),
            Location__c = 'Bangalore',
            End_Date__c = System.today() + 3,
            Meeting_Purpose__c = 'Test Meeting Purpose',
            Attachment_Name__c = 'test'
        );
        insert tstPlM; 
        
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        ContentVersion contentVersion_1 = new ContentVersion(
            Title='Header_Picture1', 
            PathOnClient ='/Header_Picture1.jpg',
            VersionData = bodyBlob, 
            origin = 'H'
        );
        insert contentVersion_1;
       
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = tstPlM.id;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink;
        System.debug('test contentlink ====>'+contentlink);
        delete [SELECT Id FROM ContentDocument WHERE Id =: contentVersion_2.contentdocumentid];
    }
    static testMethod void ContentDocumentTest1(){        
        Account acc 				= new Account(); 
        acc.Name    				= 'CHROMALLOY POWER SERVICES CORP';
        acc.GCE_Customer_Segment__c = 'Airline';
        acc.GCE_CSS__c 				= 'Phoenix/America';
        acc.GCE_CSS_Type__c 		= 'Dedicated';
        insert acc;
        Contact con     = new Contact();
        con.LastName    = 'Martin';
        con.AccountId   = acc.Id;
        con.Email 		= 'Martin.Luther@honeywell.com';
        insert con;
        Case cs = new Case();
        cs.Status = 'Open';
        cs.AccountId = acc.Id;
        cs.ContactId = con.Id;
        insert cs; 
        
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        ContentVersion contentVersion_1 = new ContentVersion(
            Title='Header_Picture1', 
            PathOnClient ='/Header_Picture1.jpg',
            VersionData = bodyBlob, 
            origin = 'H'
        );
        insert contentVersion_1;
       
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = cs.id;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink;
        System.debug('test contentlink ====>'+contentlink);
        delete [SELECT Id FROM ContentDocument WHERE Id =: contentVersion_2.contentdocumentid];
    }
    static testMethod void ContentDocumentTest2(){        
        Event__c tstPlM = new Event__c(
            Name = 'Test PLanned Meeting',
            Start_Date__c = System.today(),
            Location__c = 'Bangalore',
            End_Date__c = System.today() + 3
        );
        insert tstPlM;
        
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        ContentVersion contentVersion_1 = new ContentVersion(
            Title='Header_Picture1', 
            PathOnClient ='/Header_Picture1.jpg',
            VersionData = bodyBlob, 
            origin = 'H'
        );
        insert contentVersion_1;
       
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = tstPlM.id;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink;
         ContentDocumentTriggerHandler.conDocBeforeDelete(documents);
        System.debug('test contentlink ====>'+contentlink);
        delete [SELECT Id FROM ContentDocument WHERE Id =: contentVersion_2.contentdocumentid];
    }
    static testMethod void ContentDocumentTest3(){        
        Account objAccount = new Account();
        objAccount.Name = 'Test';
        Insert objAccount;
        
        //Create an opportunity.
        Opportunity objOpporunity = new Opportunity();
        objOpporunity.Name = 'Test Opporutnity';
        objOpporunity.AccountId = objAccount.Id;
        objOpporunity.StageName = 'Prospecting';
        objOpporunity.SBU__c= 'BGA';
        objOpporunity.CloseDate = system.Today();
        Insert objOpporunity;
        
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        ContentVersion contentVersion_1 = new ContentVersion(
            Title='Header_Picture1', 
            PathOnClient ='/Header_Picture1.jpg',
            VersionData = bodyBlob, 
            origin = 'H'
        );
        insert contentVersion_1;
       
        ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion_1.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];
        
        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = objOpporunity.id;
        contentlink.contentdocumentid = contentVersion_2.contentdocumentid;
        contentlink.ShareType = 'V';
        insert contentlink;
        ContentDocumentTriggerHandler.conDocBeforeDelete(documents);
        System.debug('test contentlink ====>'+contentlink);
        delete [SELECT Id FROM ContentDocument WHERE Id =: contentVersion_2.contentdocumentid];
    }
}