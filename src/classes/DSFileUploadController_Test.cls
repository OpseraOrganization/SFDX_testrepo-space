@IsTest
public class DSFileUploadController_Test {
    @IsTest
    public static void LightningFileUploadHandlerTestMethod() {
        
        Account acc = new Account(
            BillingStreet = '123 ST',
            BillingState = 'NY',
            BillingCountry = 'US',
            BillingPostalCode = '00000',
            BillingCity = 'City',
            Name = 'Test'
        );
        
        insert acc;
        
        ContentVersion cv = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'test.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert cv;    
        ContentVersion cv1 = new ContentVersion(
            Title = 'Test1',
            PathOnClient = 'test1.jpg',
            VersionData = Blob.valueOf('Test1 Content'),
            IsMajorVersion = true
        );
        insert cv1; 
        
        List<ContentDocument> cdList = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument ];
        //create ContentDocumentLink record 
        ContentDocumentLink cdl = New ContentDocumentLink(
            LinkedEntityId = acc.id,
            ContentDocumentId = cdList[0].Id,
            ShareType = 'V'
        );
        insert cdl;
        ContentDocumentLink cd2 = New ContentDocumentLink(
            LinkedEntityId = acc.id,
            ContentDocumentId = cdList[1].Id,
            ShareType = 'V'
        );
        insert cd2;
        
        DSFileUploadController.getFiles(String.valueOf(acc.Id));
        DSFileUploadController.deleteFile(String.valueOf(cdl.Id));
        DSFileUploadController.deleteAllFiles(acc.Id);
    }
}