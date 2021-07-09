@IsTest
private class GDMFSL_ServiceReportProcessorTest {

    @TestSetup
    static void init() {
        Account a = new Account(Name = 'Test Account', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        insert a;

        WorkType wt = GDMFSL_DataFactory.createWorkType('Break/Fix', 4);
        insert wt;
        OperatingHours ohs = GDMFSL_DataFactory.createOperatingHour();
        insert ohs;
        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('SSProc Test', ohs.Id);
        insert st;
        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        insert lo;

        Source_System__c ss = GDMFSL_DataFactory.createSourceSystem(a.Id, '11111');
        ss.Customer_Order_Block__c = true;
        ss.GDMFSL_Delivery_Block__c = false;
        ss.Type__c = 'SOLDTO';
        insert ss;

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wt.Id, a.Id, lo.Id, System.now(), System.now());
        wo.GDMFSL_Sold_To_Source_System_Reference__c = ss.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        insert wo;

        ServiceAppointment theSA = GDMFSL_DataFactory.createServiceAppointmentwithParentWO(wo.Id, GDMFSL_WorkOrderProcessor.COMPLETEDSTATUS);
        theSA.SchedStartTime = System.now();
        theSA.SchedEndTime = System.now().addHours(4);
        insert theSA;

        ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
        );
        insert contentVersion;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = theSA.Id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.ShareType = 'V';
        insert cdl;


        ServiceReport sr = new ServiceReport();
        sr.DocumentBody = Blob.valueOf('Test Content') ;
        sr.DocumentContentType ='application/pdf';
        sr.DocumentName='Test';
        sr.ParentId = theSA.Id;
        insert sr ;
    }

    @IsTest
    static void getorgNoReplyEmailAddressTest() {

        OrgWideEmailAddress theEmail = GDMFSL_ServiceReportProcessor.getOrgWideNoReplyAddress();

        System.assertEquals(GDMFSL_ServiceReportProcessor.NO_REPLY_EMAIL, theEmail.DisplayName, 'Wrong Org wide email address returned');
    }

    @IsTest
    static void sendSiteContactEmailCompletedWOsTest(){

        // we can't test this method directly because of the way Contact info is checked on the WOrder.  So we have to do DML
        Map<Id, WorkOrder> theWOs = new Map<Id, WorkOrder>([SELECT Id, ContactId, GDMFSL_Contact_Email__c,
                                                            Status, GDMFSL_Executed_by_Sub_Contractor__c
                                                            FROM WorkOrder]);


        Account theAccount = [SELECT Id FROM Account LIMIT 1];

        Contact theContact = GDMFSL_DataFactory.createTestContact(theAccount.Id);
        insert theContact;

        for (WorkOrder thisWO : theWOs.values()){
            thisWO.ContactId = theContact.Id;
            thisWO.GDMFSL_Executed_by_Sub_Contractor__c = false;
            thisWO.Status = GDMFSL_WorkOrderProcessor.COMPLETEDSTATUS;
        }

        Integer origEmailSends = Limits.getEmailInvocations();

        System.debug('TEST start');

        System.debug('The GDMFSL_ServiceReportProcessor.sendSiteContactEmailCompletedWOs() method is tested via its call in the WO trigger');
        update theWOs.values();

        System.assertNotEquals(origEmailSends, Limits.getEmailInvocations(), 'sendSiteContactEmailCompletedWOs(): Email was not sent as expected');

    }
}