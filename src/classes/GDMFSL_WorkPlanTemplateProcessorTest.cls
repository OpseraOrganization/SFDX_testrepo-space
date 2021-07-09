/**
 * Name       :    GDMFSL_WorkPlanTemplateProcessorTest
 * Purpose    :    Test class for GDMFSL_WorkPlanTemplateProcessor.
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Varun Misra.            3/25/2021     Test class for GDMFSL_WorkPlanTemplateProcessor.
 **/
@IsTest
private class GDMFSL_WorkPlanTemplateProcessorTest {


    @IsTest
    static void getRecordsTest() {

        List<WorkPlanTemplate> wptToInsert = new List<WorkPlanTemplate>();
        WorkPlanTemplate theWPTemplate = new WorkPlanTemplate(Name = 'Heating Coil', RelativeExecutionOrder = 5, Description = 'Test WPT', IsActive = true);
        wptToInsert.add(theWPTemplate);

        WorkPlanTemplate theOtherWPTemplate = new WorkPlanTemplate(Name = 'Acoustic joints', RelativeExecutionOrder = 3, Description = 'Test Another WPT', IsActive = true);
        wptToInsert.add(theOtherWPTemplate);

        insert wptToInsert;

        System.debug('TEST: start');

        Map<Id, WorkPlanTemplate> recMap = GDMFSL_WorkPlanTemplateProcessor.getRecords(new Set<Id>{theWPTemplate.Id});

        System.assertEquals(1, recMap.size(), 'Wrong number of WorkPlanTemplates were retrieved');
        System.assertEquals(theWPTemplate.Id, recMap.get(theWPTemplate.Id).Id, 'WorkPlanTemplate does not match the ID key');

        System.debug('Now testing that additional WorkPlanTemplates are retrieved');

        Map<Id, WorkPlanTemplate> recMap2 = GDMFSL_WorkPlanTemplateProcessor.getRecords(new Set<Id>{theOtherWPTemplate.Id});

        System.assertEquals(2, recMap2.size(), 'Wrong number of WorkPlanTemplates were retrieved on second method call');
        System.assertEquals(theWPTemplate.Id, recMap2.get(theWPTemplate.Id).Id, 'Original WorkPlanTemplate does not match the ID key');
        System.assertEquals(theOtherWPTemplate.Id, recMap2.get(theOtherWPTemplate.Id).Id, 'Second WorkPlanTemplate does not match the ID key');
    }
    
    
     @IsTest
    static void testCreateWOWorkPlanFromWorkPlanTemplate(){

        Account acct = GDMFSL_DataFactory.createTestAccount('Test Account');
        insert acct;

        System.debug('Account Inserted: ' + acct);

        List<Product2> p = GDMFSL_DataFactory.createProducts('Test Product', 1);
        insert p;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset', p[0].Id, acct.Id, 1);
        insert a;

        WorkType wt = GDMFSL_DataFactory.createWorkType('Break/Fix', 4);
        insert wt;

        System.debug('Work Type Inserted: ' + wt);

        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('WPlan Test', oh.Id);
        insert st;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location', st.Id);
        insert lo;

        System.debug('Location Inserted: ' + lo);

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wt.Id, acct.Id, lo.Id, System.now(), System.now());
        wo.GDMFSL_PO_Number__c = '12345';
        wo.WorkTypeId = wt.Id;
        insert wo;

        System.debug('Work order Inserted: ' + wo);

        WorkOrderLineItem woli = GDMFSL_DataFactory.createWorkOrderLineItem(wt.Id, wo.Id, a[0].Id);
        insert woli;

        WorkPlanTemplate wpt = new WorkPlanTemplate(Name = 'Heating Coil', RelativeExecutionOrder = 5, Description = 'Test WPT', IsActive = true);
        insert wpt;

        System.debug('Work Plan Template Inserted: ' + wpt);

        WorkPlan wp = new WorkPlan(Name = wpt.Name, Description = wpt.Description, ExecutionOrder = wpt.RelativeExecutionOrder, WorkOrderId = wo.Id, WorkOrderLineItemId = woli.Id);
        insert wp;

        System.debug('Work Plan Inserted: ' + wp);
        System.debug('TEST: start');

        WorkPlan theWPlan =  GDMFSL_WorkPlanTemplateProcessor.createWOWorkPlanFromWorkPlanTemplate(wpt, wo.Id, woli.Id);
        
        System.assertEquals(wo.Id, theWPlan.WorkOrderId, 'WorkPlan WorkOrderId is not set correctly');
        System.assertEquals(woli.Id, theWPlan.WorkOrderLineItemId, 'WorkPlan WorkOrderLineItemId is not set correctly');
       
    }

}