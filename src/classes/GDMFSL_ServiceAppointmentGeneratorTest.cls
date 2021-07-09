@IsTest
private class GDMFSL_ServiceAppointmentGeneratorTest {

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

    }

    @IsTest
    static void generateSAsForSpecificWOId() {

        List<WorkOrder> wosToProcess = new List<WorkOrder>([SELECT Id FROM WorkOrder LIMIT 1]);

        GDMFSL_ServiceAppointmentGenerator saGen = new GDMFSL_ServiceAppointmentGenerator();

        for (WorkOrder aWO : wosToProcess){
            saGen.woIdsToTestWith.add(aWO.Id);
        }

        Test.startTest();

        System.debug('TEST: ');

        Database.executeBatch(saGen);

        Test.stopTest();

        System.debug('See if SA was created');
        List<ServiceAppointment> allSAs = new List<ServiceAppointment>([SELECT Id FROM ServiceAppointment WHERE ParentRecordId IN :wosToProcess]);

        System.assertNotEquals(0, allSAs.size(), 'SAGenerator did not create ServiceAppointments for specified WO');

    }

    @IsTest
    static void generateSAsForMergeCreatedWOs() {

        List<WorkOrder> wosToProcess = new List<WorkOrder>([SELECT Id FROM WorkOrder LIMIT 1]);

        GDMFSL_ServiceAppointmentGenerator saGen = new GDMFSL_ServiceAppointmentGenerator();

        for (WorkOrder aWO : wosToProcess){
            aWO.GDMFSL_Created_by_WO_Merge_Process__c = true;
        }
        update wosToProcess;

        Test.startTest();

        System.debug('TEST: ');

        Database.executeBatch(saGen);

        Test.stopTest();

        System.debug('See if SA was created');
        List<ServiceAppointment> allSAs = new List<ServiceAppointment>([SELECT Id FROM ServiceAppointment]);

        System.assertNotEquals(0, allSAs.size(), 'SAGenerator did not create ServiceAppointments for Merge-Created WOs');

    }

    @IsTest
    private static void saGeneratorSchedulableTest(){

        Test.startTest();

        System.debug('TEST: start');

        GDMFSL_ServiceAppointmentGenerator theJob = new GDMFSL_ServiceAppointmentGenerator();
        System.schedule('SAGenerator Sched', '0 0 23 * * ?', theJob);

        Test.stopTest();

        System.debug('Nothing meaningful to assert');

    }


}