@IsTest
private without sharing class GDMFSL_ContentDocumentProcessorTest {
    
    @IsTest
    static void testContentDocumentTriggerHandler() {

        Account acct = new Account(Name='Test Account',Phone = '1234561234',BillingStreet = 'Anywhere',BillingCity = 'City',BillingState = 'Florida',BillingCountry = 'United States');
        insert acct;
        List<Product2> p = GDMFSL_DataFactory.createProducts('Test Product',1);
        insert p;
        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset',p[0].Id,acct.Id,1);
        insert a;
        WorkType wt = GDMFSL_DataFactory.createWorkType('Break/Fix',4);
        insert wt;
        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;
        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('ContDocProd Test', oh.Id);
        insert st;
        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location',st.Id);
        insert lo;
        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wt.Id,acct.Id,lo.Id,System.now(),System.now());
        wo.GDMFSL_PO_Number__c = '12345';
        insert wo;
        WorkOrderLineItem woli = GDMFSL_DataFactory.createWorkOrderLineItem(wt.Id,wo.Id,a[0].Id);
        insert woli;

        Test.startTest();
            // Create a new ContentDocument, associated with the woli.  This will also call the ContentDocument's after update event
            ContentVersion contentVersion_1 = new ContentVersion(Title = 'Penguins', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true, FirstPublishLocationId=woli.Id);
            insert contentVersion_1;
        Test.stopTest();

        ContentDocument theDoc = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];

        // Get all ContentDocumentLinks for that ContentDocument, which are tied to the Asset
        List<ContentDocumentLink> cdl1 = [SELECT Id, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :a[0].Id AND ContentDocumentId = :theDoc.Id];

        System.assertEquals(1, cdl1.size(), 'Content Document is not linked to Asset');
    }       

    @IsTest
    static void testConnectContentDocumentToAsset() {

        Account acct = new Account(Name='Test Account',Phone = '1234561234',BillingStreet = 'Anywhere',BillingCity = 'City',BillingState = 'Florida',BillingCountry = 'United States');
        insert acct;
        List<Product2> p = GDMFSL_DataFactory.createProducts('Test Product',1);
        insert p;
        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset',p[0].Id,acct.Id,1);
        insert a;
        WorkType wt = GDMFSL_DataFactory.createWorkType('Break/Fix',4);
        insert wt;
        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;
        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('ContDocProd Test', oh.Id);
        insert st;
        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location',st.Id);
        insert lo;
        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wt.Id,acct.Id,lo.Id,System.now(),System.now());
        wo.GDMFSL_PO_Number__c = '12345';
        insert wo;
        WorkOrderLineItem woli = GDMFSL_DataFactory.createWorkOrderLineItem(wt.Id,wo.Id,a[0].Id);
        insert woli;
        // Create a new ContentDocument, associated with the woli.  This will also call the ContentDocument's after update event
        ContentVersion contentVersion_1 = new ContentVersion(Title = 'Penguins', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true, FirstPublishLocationId=woli.Id);
        insert contentVersion_1;
        ContentDocument theDoc = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument LIMIT 1];

        // 1. Delete the ContentDocumentLink that was created via the Trigger process
        delete [SELECT Id FROM ContentDocumentLink WHERE LinkedEntityId = :a[0].Id];

        // 2. Call the connectContentDocument method (without the Trigger's help)
        Test.startTest();
    
            GDMFSL_ContentDocumentProcessor.connectContentDocumentToAsset(new List<ContentDocument>{theDoc} );
        Test.stopTest();

        // Get all ContentDocumentLinks for that ContentDocument, which are tied to the Asset
        List<ContentDocumentLink> cdl1 = [SELECT Id, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :a[0].Id AND ContentDocumentId = :theDoc.Id];

        // 3. Verify that the method resulted in a new ContentDocumentLink being created
        System.assertEquals(1, cdl1.size(), 'Content Document is not linked to Asset');
    }

    @IsTest
    static void testGetCaseRelatedFilerecords() {

        Account acct = new Account(Name='Test Account',Phone = '1234561234',BillingStreet = 'Anywhere',BillingCity = 'City',BillingState = 'Florida',BillingCountry = 'United States');
        insert acct;
        List<Product2> p = GDMFSL_DataFactory.createProducts('Test Product',1);
        insert p;
        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset',p[0].Id,acct.Id,1);
        insert a;

        List<Case> casesToCreate = new List<Case>();

        Case c1 = GDMFSL_DataFactory.createCase('North America', a[0].Id);
        c1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        c1.Origin = 'Community';
        casesToCreate.add(c1);

        Case c2 = GDMFSL_DataFactory.createCase('North America', a[0].Id);
        c2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        c2.Origin = 'Community';
        casesToCreate.add(c2);

        insert casesToCreate;

        List<ContentVersion> contVerToCreate = new List<ContentVersion>();
        contVerToCreate.add(new ContentVersion(Title = 'Penguins', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true, FirstPublishLocationId = c1.Id));
        contVerToCreate.add(new ContentVersion(Title = 'Penguins2', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true, FirstPublishLocationId = c1.Id));
        contVerToCreate.add(new ContentVersion(Title = 'Penguins', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true, FirstPublishLocationId = c2.Id));
        contVerToCreate.add(new ContentVersion(Title = 'Penguins2', PathOnClient = 'Penguins.jpg', VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true, FirstPublishLocationId = c2.Id));
        insert contVerToCreate;

        Map<Id,List<ContentDocumentLink>> result = GDMFSL_ContentDocumentProcessor.getCaseRelatedFileRecords(new Set<Id>{c1.Id});

        System.assertEquals(1, result.keySet().size(), 'getCaseRelatedFileRecords() returned the wrong number of case matches');
        System.assertEquals(2, result.get(c1.Id).size(), 'getCaseRelatedFileRecords() did not return correct number of related ContentDocuments');
        System.assertEquals(c1.Id, result.get(c1.Id)[0].LinkedEntityId, 'getCaseRelatedFileRecords() returned first ContentDocument related to the wrong record');
        System.assertEquals(c1.Id, result.get(c1.Id)[1].LinkedEntityId, 'getCaseRelatedFileRecords() returned second ContentDocument related to the wrong record');

        result = GDMFSL_ContentDocumentProcessor.getCaseRelatedFileRecords(new Set<Id>{c2.Id});

        System.assertEquals(2, result.keySet().size(), 'getCaseRelatedFileRecords() returned the wrong number of case matches on subsequent call');

        System.assertEquals(2, result.get(c1.Id).size(), 'getCaseRelatedFileRecords() did not return correct number of related ContentDocuments from orig record on subsequent call');
        System.assertEquals(c1.Id, result.get(c1.Id)[0].LinkedEntityId, 'getCaseRelatedFileRecords() returned first ContentDocument related to the wrong record');
        System.assertEquals(c1.Id, result.get(c1.Id)[1].LinkedEntityId, 'getCaseRelatedFileRecords() returned second ContentDocument related to the wrong record');

        System.assertEquals(2, result.get(c2.Id).size(), 'getCaseRelatedFileRecords() did not return correct number of related ContentDocuments from subsequent record on subsequent call');
        System.assertEquals(c2.Id, result.get(c2.Id)[0].LinkedEntityId, 'getCaseRelatedFileRecords() returned first ContentDocument related to the wrong subsequent record on subsequent call');
        System.assertEquals(c2.Id, result.get(c2.Id)[1].LinkedEntityId, 'getCaseRelatedFileRecords() returned second ContentDocument related to the wrong subsequent record on subsequent call');


    }    
}