@IsTest
private class displayContentDocLightningTest{
    static testMethod void displayContentDocLightningTest()
    {
     Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

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
        List<ContentDistribution> getContentDoc = [SELECT Id, DistributionPublicUrl, ContentDocumentId FROM ContentDistribution WHERE ContentVersionId =: cv.Id LIMIT 1];
        
        tstwrp.brifcaseDoc = getContentDoc;
        
        displayBrifcase.fetchContent(getContentDoc[0].ContentDocumentId);
        displayContentDocLightning.fetchContentData(getContentDoc[0].ContentDocumentId);
           }
    
   
}