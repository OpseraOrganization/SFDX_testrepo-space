/**
 * Created by Satya Mohanty on 1/3/2020.
 * OWNED BY THE CRM SALES TEAM.
 */
@IsTest
private class showBriefcaseDataTest{
    static testMethod void showBriefcaseDataTest(){
        /*Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

        ContentVersion cv = new ContentVersion();
     //   CV = [SELECT Id, Title FROM ContentVersion ];
        cv.title = 'test content trigger';
        cv.PathOnClient ='test';
        cv.VersionData =beforeblob;
        insert cv;

        ContentDistribution cd = new ContentDistribution();
        cv = [SELECT Id, Title FROM ContentVersion WHERE Id =:cv.id  AND IsLatest = true];
        cd.ContentVersionId = cv.Id;
        cd.name = cv.Title;
        cd.PreferencesAllowOriginalDownload = false;
        cd.PreferencesAllowPDFDownload = false;
        cd.PreferencesAllowViewInBrowser = true;
        insert cd;

        displayBrifcase.brifcaseDocWrapper tstwrp = new displayBrifcase.brifcaseDocWrapper();
        tstwrp.pageUrl = 'https://';
        List<ContentDistribution> getContentDoc= [SELECT Id, DistributionPublicUrl, ContentDocumentId FROM ContentDistribution WHERE ContentVersionId =: cv.Id LIMIT 1];

        tstwrp.brifcaseDoc = getContentDoc;
        displayBrifcase.fetchContent(getContentDoc[0].ContentDocumentId);
        displayContentDocLightning.fetchContentData(getContentDoc[0].ContentDocumentId);*/

        Account acct = new Account(Name = 'TEST_ACCT');
        insert acct;

        ContentVersion cv = new ContentVersion();
        cv.title ='ABC';
        cv.SBU__c = 'BGA';
        cv.PathOnClient ='test';
        cv.Group_By__c = 'External Link';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata = EncodingUtil.base64Decode('Unit Test Attachment Body');
        cv.IsMajorVersion = true;
        insert cv;

        update cv;

        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];

        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = acct.id;
        Contentlink.sharetype = 'v';
        contentlink.ContentDocumentId = testcontent.ContentDocumentId;
        contentlink.Visibility = 'AllUsers';
        insert contentlink;

        ApexPages.currentPage().getParameters().put('docId', testcontent.ContentDocumentId);

        showBriefcaseData.getAllContentDoc();
    }
    static testMethod void showBriefcaseDataTest1(){
        /*Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

        ContentVersion cv = new ContentVersion();
     //   CV = [SELECT Id, Title FROM ContentVersion ];
        cv.title = 'test content trigger';
        cv.PathOnClient ='test';
        cv.VersionData =beforeblob;
        insert cv;

        ContentDistribution cd = new ContentDistribution();
        cv = [SELECT Id, Title FROM ContentVersion WHERE Id =:cv.id  AND IsLatest = true];
        cd.ContentVersionId = cv.Id;
        cd.name = cv.Title;
        cd.PreferencesAllowOriginalDownload = false;
        cd.PreferencesAllowPDFDownload = false;
        cd.PreferencesAllowViewInBrowser = true;
        insert cd;

        displayBrifcase.brifcaseDocWrapper tstwrp = new displayBrifcase.brifcaseDocWrapper();
        tstwrp.pageUrl = 'https://';
        List<ContentDistribution> getContentDoc= [SELECT Id, DistributionPublicUrl, ContentDocumentId FROM ContentDistribution WHERE ContentVersionId =: cv.Id LIMIT 1];

        tstwrp.brifcaseDoc = getContentDoc;
        displayBrifcase.fetchContent(getContentDoc[0].ContentDocumentId);
        displayContentDocLightning.fetchContentData(getContentDoc[0].ContentDocumentId);*/

        Account acct = new Account(Name = 'TEST_ACCT');
        insert acct;

        ContentVersion cv = new ContentVersion();
        cv.title ='ABC';
        cv.SBU__c = 'BGA';
        cv.PathOnClient ='test';
        cv.Group_By__c = 'Briefcase Other Files';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata = EncodingUtil.base64Decode('Unit Test Attachment Body');
        cv.IsMajorVersion = true;
        insert cv;

        update cv;

        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];

        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = acct.id;
        Contentlink.sharetype = 'v';
        contentlink.ContentDocumentId = testcontent.ContentDocumentId;
        contentlink.Visibility = 'AllUsers';
        insert contentlink;

        ApexPages.currentPage().getParameters().put('docId', testcontent.ContentDocumentId);

        showBriefcaseData.getAllContentDoc();
    }
    static testMethod void showBriefcaseDataTest2(){
        /*Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

        ContentVersion cv = new ContentVersion();
     //   CV = [SELECT Id, Title FROM ContentVersion ];
        cv.title = 'test content trigger';
        cv.PathOnClient ='test';
        cv.VersionData =beforeblob;
        insert cv;

        ContentDistribution cd = new ContentDistribution();
        cv = [SELECT Id, Title FROM ContentVersion WHERE Id =:cv.id  AND IsLatest = true];
        cd.ContentVersionId = cv.Id;
        cd.name = cv.Title;
        cd.PreferencesAllowOriginalDownload = false;
        cd.PreferencesAllowPDFDownload = false;
        cd.PreferencesAllowViewInBrowser = true;
        insert cd;

        displayBrifcase.brifcaseDocWrapper tstwrp = new displayBrifcase.brifcaseDocWrapper();
        tstwrp.pageUrl = 'https://';
        List<ContentDistribution> getContentDoc= [SELECT Id, DistributionPublicUrl, ContentDocumentId FROM ContentDistribution WHERE ContentVersionId =: cv.Id LIMIT 1];

        tstwrp.brifcaseDoc = getContentDoc;
        displayBrifcase.fetchContent(getContentDoc[0].ContentDocumentId);
        displayContentDocLightning.fetchContentData(getContentDoc[0].ContentDocumentId);*/

        Account acct = new Account(Name = 'TEST_ACCT');
        insert acct;

        ContentVersion cv = new ContentVersion();
        cv.title ='ABC';
        cv.SBU__c = 'BGA';
        cv.PathOnClient ='test';
        cv.Group_By__c = 'Briefcase Primary';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata = EncodingUtil.base64Decode('Unit Test Attachment Body');
        cv.IsMajorVersion = true;
        insert cv;

        update cv;

        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];

        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = acct.id;
        Contentlink.sharetype = 'v';
        contentlink.ContentDocumentId = testcontent.ContentDocumentId;
        contentlink.Visibility = 'AllUsers';
        insert contentlink;

        ApexPages.currentPage().getParameters().put('docId', testcontent.ContentDocumentId);

        showBriefcaseData.getAllContentDoc();
    }
    static testMethod void showBriefcaseDataTest3(){
        /*Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

        ContentVersion cv = new ContentVersion();
     //   CV = [SELECT Id, Title FROM ContentVersion ];
        cv.title = 'test content trigger';
        cv.PathOnClient ='test';
        cv.VersionData =beforeblob;
        insert cv;

        ContentDistribution cd = new ContentDistribution();
        cv = [SELECT Id, Title FROM ContentVersion WHERE Id =:cv.id  AND IsLatest = true];
        cd.ContentVersionId = cv.Id;
        cd.name = cv.Title;
        cd.PreferencesAllowOriginalDownload = false;
        cd.PreferencesAllowPDFDownload = false;
        cd.PreferencesAllowViewInBrowser = true;
        insert cd;

        displayBrifcase.brifcaseDocWrapper tstwrp = new displayBrifcase.brifcaseDocWrapper();
        tstwrp.pageUrl = 'https://';
        List<ContentDistribution> getContentDoc= [SELECT Id, DistributionPublicUrl, ContentDocumentId FROM ContentDistribution WHERE ContentVersionId =: cv.Id LIMIT 1];

        tstwrp.brifcaseDoc = getContentDoc;
        displayBrifcase.fetchContent(getContentDoc[0].ContentDocumentId);
        displayContentDocLightning.fetchContentData(getContentDoc[0].ContentDocumentId);*/

        Account acct = new Account(Name = 'TEST_ACCT');
        insert acct;

        ContentVersion cv = new ContentVersion();
        cv.title ='ABC';
        cv.SBU__c = 'BGA';
        cv.PathOnClient ='test';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata = EncodingUtil.base64Decode('Unit Test Attachment Body');
        cv.IsMajorVersion = true;
        insert cv;

        update cv;

        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];

        ContentDocumentLink contentlink = new ContentDocumentLink();
        contentlink.LinkedEntityId = acct.id;
        Contentlink.sharetype = 'v';
        contentlink.ContentDocumentId = testcontent.ContentDocumentId;
        contentlink.Visibility = 'AllUsers';
        insert contentlink;

        ApexPages.currentPage().getParameters().put('docId', testcontent.ContentDocumentId);

        showBriefcaseData.getAllContentDoc();
    }

}