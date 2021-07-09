@IsTest
private class GDMFSL_TimeSheetEntryProcessorTest {

    @IsTest
    static void getRecordsTest() {


        Account theAccount = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert theAccount;

        ServiceAppointment theSA = GDMFSL_DataFactory.createServiceAppointment(theAccount.Id, 'New');
        insert theSA;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;

        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('ServAppt Test', theOpHours.Id);
        insert theServiceTerritory;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;
        System.debug('TestLocation Inserted : ' + aLocation);

        List<WorkType> lstworktype = GDMFSL_DataFactory.createWorkTypes('W001',3,30);
        insert lstworktype;

        List<WorkOrder> wosToInsert = new List<WorkOrder>();

        WorkOrder theWorkOrder = GDMFSL_DataFactory.createWorkOrder(lstworktype[0].Id, theAccount.Id, aLocation.Id, Datetime.valueOfGmt('2020-09-04 18:00:00'), Datetime.valueOfGmt('2020-09-05 18:00:00'));
        theWorkOrder.GDMFSL_PO_Number__c = '12345';
        wosToInsert.add(theWorkOrder);

        WorkOrder theOtherWorkOrder = GDMFSL_DataFactory.createWorkOrder(lstworktype[0].Id, theAccount.Id, aLocation.Id, Datetime.valueOfGmt('2020-09-04 18:00:00'), Datetime.valueOfGmt('2020-09-05 18:00:00'));
        theOtherWorkOrder.GDMFSL_PO_Number__c = '999999';
        wosToInsert.add(theOtherWorkOrder);

        insert wosToInsert;

        Schema.Location theLoc = GDMFSL_DataFactory.createLocation('House', theServiceTerritory.Id);
        insert theLoc;

        User theServUser = GDMFSL_DataFactory.createTestUser();
        insert theServUser;

        ServiceResource theServRes = GDMFSL_DataFactory.createServiceResource(theServUser.id, theLoc.Id);
        insert theServRes;

        TimeSheet theTimeSheet = new TimeSheet(
                ServiceResourceId = theServRes.Id,
                StartDate = Date.today().addDays(-3),
                EndDate = Date.today());
        insert theTimeSheet;

        List<TimeSheetEntry> tsesToInsert = new List<TimeSheetEntry>();

        TimeSheetEntry theTimeSheetEntry = new TimeSheetEntry(TimeSheetId = theTimeSheet.Id,
                WorkOrderId = theWorkOrder.Id,
                StartTime = Datetime.now().addMinutes(-200),
                EndTime = Datetime.now(),
                GDMFSL_Service_Appointment__c = theSA.Id,
                Status = 'New',
                Type = 'RT',
                GDMFSL_Classification__c = 'Labor');
        tsesToInsert.add(theTimeSheetEntry);

        TimeSheetEntry theOtherTimeSheetEntry = new TimeSheetEntry(TimeSheetId = theTimeSheet.Id,
                WorkOrderId = theOtherWorkOrder.Id,
                StartTime = Datetime.now().addMinutes(-200),
                EndTime = Datetime.now(),
                GDMFSL_Service_Appointment__c = theSA.Id,
                Status = 'New',
                Type = 'RT',
                GDMFSL_Classification__c = 'Labor');

        tsesToInsert.add(theOtherTimeSheetEntry);

        System.debug('About to insert these TSEntries: ' + tsesToInsert);
        insert tsesToInsert;

        System.debug('TEST: start');

        Map<Id, List<TimeSheetEntry>> woTSEntries = GDMFSL_TimeSheetEntryProcessor.getRecordsForWOs(new Set<Id>{theWorkOrder.Id});

        System.assertEquals(1, woTSEntries.size(), 'Wrong number of WorkOrder Ids were retrieved');
        System.assertEquals(1, woTSEntries.get(theWorkOrder.Id).size(), 'Wrong number of TimeSheetEntries retrieved for the WorkOrder Id');


        System.debug('Now testing that additional TimeSheetEntries are retrieved for different  WorkOrder');

        woTSEntries.clear();
        woTSEntries = GDMFSL_TimeSheetEntryProcessor.getRecordsForWOs(new Set<Id>{theOtherWorkOrder.Id});

        System.assertEquals(2, woTSEntries.size(), 'Wrong number of WorkOrder Ids were retrieved on second method call');
        System.assertEquals(1, woTSEntries.get(theWorkOrder.Id).size(), 'Wrong number of TimeSheetEntries retrieved for the original WorkOrder Id');
        System.assertEquals(1, woTSEntries.get(theOtherWorkOrder.Id).size(), 'Wrong number of TimeSheetEntries retrieved for the new WorkOrder Id');

    }
}