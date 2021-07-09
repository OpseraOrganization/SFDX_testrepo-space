@IsTest(IsParallel=true)
private class GDMFSL_ServiceReportLayoutProcessorTest {

    @IsTest
    static void testBehavior() {
        list<ServiceReportLayout> lstSRL = [SELECT Id FROM ServiceReportLayout];
        System.debug('These many Service report templates found from query::' + lstSRL.size());

        Map<String, ServiceReportLayout> SRL = GDMFSL_ServiceReportLayoutProcessor.getRecords();
        System.debug('These many ServiceReportsTemplates returned by GetRecords' + SRL.size());
        System.assertEquals(lstSRL.size(), SRL.size(), 'No. of Service Report templates does not match');
    }
}