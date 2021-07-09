/**
 * Created by uzaroo on 3/26/21.
 */

@IsTest
private class GDMFSL_SourceSystemProcessorTest {
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

        List<Source_System__c> ssToInsert = new List<Source_System__c>();

        Source_System__c ss = GDMFSL_DataFactory.createSourceSystem(a.Id, '11111');
        ss.Customer_Order_Block__c = true;
        ss.GDMFSL_Delivery_Block__c = false;
        ss.Source_System_Company_Id__c = ss.Source_Id__c;
        ss.Type__c = 'SOLDTO';
        ssToInsert.add(ss);

        Source_System__c ss1 = GDMFSL_DataFactory.createSourceSystem(a.Id, '222222');
        ss1.Customer_Order_Block__c = true;
        ss1.GDMFSL_Delivery_Block__c = false;
        ss1.Source_System_Company_Id__c = ss1.Source_Id__c;
        ss1.Type__c = 'SHIPTO';
        ssToInsert.add(ss1);

        insert ssToInsert;

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wt.Id, a.Id, lo.Id, System.Now(), System.Now());
        wo.GDMFSL_Sold_To_Source_System_Reference__c = ss.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        insert wo;

        ServiceAppointment serviceAppointment = GDMFSL_DataFactory.createServiceAppointmentwithParentWO(wo.Id, 'Scheduled');
        serviceAppointment.SchedStartTime = System.now();
        serviceAppointment.SchedEndTime = System.now().addHours(4);
        insert serviceAppointment;
    }


    @IsTest
    static void checkWOsRelatedToBlockedSourceSystemTest() {
        List<Source_System__c> sourceSystems1 = [SELECT Id,Customer_Order_Block__c,GDMFSL_Delivery_Block__c FROM Source_System__c];
        sourceSystems1[0].GDMFSL_Delivery_Block__c = true;
        update sourceSystems1;

        List<ServiceAppointment> sa1 = [SELECT Id,Status FROM ServiceAppointment];


        System.assertEquals(GDMFSL_ServiceAppointmentProcessor.UNSCHEDULEDSTATUS, sa1[0].Status, 'SA did not unschedule even when Delivery Block was updated to True');
    }


    @IsTest
    static void getSourceSystemWOIdsTest() {
        Set<Id> ssIds = new Set<Id>();
        Map<Id, List<Id>> mapSSIdToWO = new Map<Id, List<Id>>();

        List<Source_System__c> ss1 = [SELECT Id,Source_Id__c FROM Source_System__c];
        ssIds.add(ss1[0].Id);
        mapSSIdToWO = GDMFSL_SourceSystemProcessor.getSourceSystemWOIds(ssIds);
        System.assertEquals(1, mapSSIdToWO.size(), 'The Maps Count has more than the expected records');
        System.assert(mapSSIdToWO.containsKey(ss1[0].Id), 'The Id of Source System in the Map is not correct to the one it was supposed to fetch');


        List<Account> a = [SELECT Id FROM Account];
        List<WorkType> wt = [SELECT Id FROM WorkType];
        List<Schema.Location> lo = [SELECT Id FROM Location];

        Source_System__c ss2 = GDMFSL_DataFactory.createSourceSystem(a[0].Id, '222');
        ss2.Type__c = 'SOLDTO';
        insert ss2;

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wt[0].Id, a[0].Id, lo[0].Id, System.Now(), System.Now());
        wo.GDMFSL_Sold_To_Source_System_Reference__c = ss2.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        insert wo;

        ssIds.add(ss2.Id);
        mapSSIdToWO = GDMFSL_SourceSystemProcessor.getSourceSystemWOIds(ssIds);
        System.assertEquals(2, mapSSIdToWO.size(), 'The map retrieved did not bring the Source system from Get Records');
        for (Id ssId : mapSSIdToWO.keySet()) {
            System.assert(ssIds.contains(ssId), 'Wrong record in Set');
        }
    }



    @IsTest
    static void getSourceSystemByCompNumTest() {

        List<Source_System__c> srcSysLst = [SELECT Id, Source_System_Company_Id__c FROM Source_System__c];

        Map<String, Source_System__c> compNumToSSys = GDMFSL_SourceSystemProcessor.getSourceSystemByCompanyNumber(new Set<String>{srcSysLst[0].Source_System_Company_Id__c});

        System.assertEquals(1, compNumToSSys.size(), 'getSourceSystemByCompanyNumber() returned wrong number of records on first call');
        System.assertEquals(true, compNumToSSys.containsKey(srcSysLst[0].Source_System_Company_Id__c), 'getSourceSystemByCompanyNumber() returned wrong Key value on first call');
        System.assertEquals(srcSysLst[0].Source_System_Company_Id__c, compNumToSSys.get(srcSysLst[0].Source_System_Company_Id__c).Source_System_Company_Id__c, 'getSourceSystemByCompanyNumber() returned wrong record on first call');

        compNumToSSys = GDMFSL_SourceSystemProcessor.getSourceSystemByCompanyNumber(new Set<String>{srcSysLst[1].Source_System_Company_Id__c});

        System.assertEquals(2, compNumToSSys.size(), 'getSourceSystemByCompanyNumber() returned wrong number of records on second call');
        System.assertEquals(true, compNumToSSys.containsKey(srcSysLst[0].Source_System_Company_Id__c), 'getSourceSystemByCompanyNumber() second call did not return original key value');
        System.assertEquals(srcSysLst[0].Source_System_Company_Id__c, compNumToSSys.get(srcSysLst[0].Source_System_Company_Id__c).Source_System_Company_Id__c, 'getSourceSystemByCompanyNumber() returned wrong record on second call');
        System.assertEquals(true, compNumToSSys.containsKey(srcSysLst[1].Source_System_Company_Id__c), 'getSourceSystemByCompanyNumber() second call did not return newly requested key value');
        System.assertEquals(srcSysLst[1].Source_System_Company_Id__c, compNumToSSys.get(srcSysLst[1].Source_System_Company_Id__c).Source_System_Company_Id__c, 'getSourceSystemByCompanyNumber() returned wrong record on second call');
    }

    @IsTest
    static void skipProcessTest() {

        Skip_Automation_Process__c profileCustomSetting = new Skip_Automation_Process__c();
        profileCustomSetting.SetupOwnerId = UserInfo.getOrganizationId();
        profileCustomSetting.ByPass_Automation__c = true;
        insert profileCustomSetting;

        List<Source_System__c> sourceSystems = [SELECT Id, (SELECT Id,Status from Service_Appointments__r) FROM Source_System__c];
        sourceSystems[0].GDMFSL_Delivery_Block__c = true;
        update sourceSystems;


        List<ServiceAppointment> sa = [SELECT Id,Status,GDMFSL_Sold_To_Source_System_Reference__c FROM ServiceAppointment];
        sa[0].status = 'Scheduled';
        update sa;

        List<ServiceAppointment> sa1 = [SELECT Id,Status FROM ServiceAppointment];

        System.assertNotEquals(GDMFSL_ServiceAppointmentProcessor.UNSCHEDULEDSTATUS, sa[0].Status, 'SA got unscheduled but Skip Process was True');
    }


}