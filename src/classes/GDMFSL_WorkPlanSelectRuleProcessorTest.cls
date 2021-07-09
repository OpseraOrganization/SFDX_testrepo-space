@IsTest
private class GDMFSL_WorkPlanSelectRuleProcessorTest {

    @IsTest
    static void testGetRecords() {


        Account theAccount = new Account(Name = 'WorkPlanSelectionRule Test', Phone = '1234561234', BillingStreet = 'Anywhere', BillingCity = 'City', BillingState = 'Florida', BillingCountry = 'United States');
        insert theAccount;

        List<Product2> p = GDMFSL_DataFactory.createProducts('WOLI Test Product', 2);
        insert p;

        OperatingHours ohs = GDMFSL_DataFactory.createOperatingHour();
        insert ohs;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('WOLI Test Test', ohs.Id);
        insert st;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('WOLI Test Location', st.Id);
        lo.GDMFSL_Region__c = 'META';
        insert lo;


        ServiceContract sc1 = GDMFSL_DataFactory.createServiceContract('SC1', theAccount.Id);
        sc1.GDMFSL_ATS_BreakFix_Hours__c = 100;
        insert sc1;
        System.debug('Inserted Test SCs from GDMFSL_ServiceContractProcessorTest.init');


        WorkType wt = GDMFSL_DataFactory.createWorkType('PM Test', 4);
        wt.GDMFSL_WorkType_Category__c = 'PM';
        wt.GDMFSL_Asset_Certification__c = true;
        insert wt;

        List<WorkPlanTemplate> wptToInsert = new List<WorkPlanTemplate>();
        WorkPlanTemplate theWPTemplate = new WorkPlanTemplate(Name = 'Heating Coil', RelativeExecutionOrder = 5, Description = 'Test WPT', IsActive = true);
        wptToInsert.add(theWPTemplate);

        insert wptToInsert;

        WorkPlanSelectionRule workPlanSelRule = GDMFSL_DataFactory.createWorkPlanSelectionRule(sc1.Id, st.Id, p[0].Id, wptToInsert[0].Id, wt.Id);
        insert workPlanSelRule;

        Test.startTest();
        Map<Id, WorkPlanSelectionRule> mapWPSRules = GDMFSL_WorkPlanSelectionRuleProcessor.getRecords(new Set<Id>{st.Id},new Set<Id>{sc1.Id},new Set<Id>{wt.Id},new Set<Id>{p[0].Id});
        Test.stopTest();

        System.assertEquals(1,mapWPSRules.size(),'Wrong Number of Work Plan Selected Rules Fetched');

    }


}