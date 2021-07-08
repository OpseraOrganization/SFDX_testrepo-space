@IsTest(IsParallel=true)
private class GDMFSL_OperatingHoursProcessorTest {

    @IsTest
    static void getRecordsTest() {

        OperatingHours theOpHrs = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHrs;

        Test.startTest();

        Map<Id, OperatingHours> mapOpHrs = GDMFSL_OperatingHoursProcessor.getRecords(new Set<Id>{theOpHrs.Id});

        System.assertEquals(1, mapOpHrs.size(), 'Wrong number of OperatingHours returned on initial query');
        System.assertEquals(theOpHrs.Id, mapOpHrs.get(theOpHrs.Id).Id, 'Wrong record returned on initial query');

        OperatingHours theNewOpHrs = GDMFSL_DataFactory.createOperatingHour();
        insert theNewOpHrs;

        Map<Id, OperatingHours> mapOpHrs2 = GDMFSL_OperatingHoursProcessor.getRecords(new Set<Id>{theNewOpHrs.Id});

        Test.stopTest();


        System.assertEquals(2, mapOpHrs2.size(), 'Wrong number of OperatingHours returned for added IDs');
        System.assertEquals(theOpHrs.Id, mapOpHrs.get(theOpHrs.Id).Id, 'Wrong original record returned on subsequent query');
        System.assertEquals(theNewOpHrs.Id, mapOpHrs.get(theNewOpHrs.Id).Id, 'Wrong subsequent record returned on subsequent query');
    }


}