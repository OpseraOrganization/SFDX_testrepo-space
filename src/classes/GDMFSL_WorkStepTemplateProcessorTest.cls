@IsTest
private class GDMFSL_WorkStepTemplateProcessorTest {

    @IsTest
    static void getRecordsTest() {

        List<WorkStepTemplate> wstToInsert = new List<WorkStepTemplate>();
        WorkStepTemplate theWSTemplate = new WorkStepTemplate(Name = 'Test', IsActive = true);
        wstToInsert.add(theWSTemplate);

        WorkStepTemplate theOtherWSTemplate = new WorkStepTemplate(Name = 'Test 2', IsActive = true);
        wstToInsert.add(theOtherWSTemplate);

        insert wstToInsert;

        System.debug('TEST: start');

        Map<Id, WorkStepTemplate> recMap = GDMFSL_WorkStepTemplateProcessor.getRecords(new Set<Id>{theWSTemplate.Id});

        System.assertEquals(1, recMap.size(), 'Wrong number of WorkStepTemplates were retrieved');
        System.assertEquals(theWSTemplate.Id, recMap.get(theWSTemplate.Id).Id, 'WorkStepTemplate does not match the ID key');

        System.debug('Now testing that additional WorkStepTemplates are retrieved');

        Map<Id, WorkStepTemplate> recMap2 = GDMFSL_WorkStepTemplateProcessor.getRecords(new Set<Id>{theOtherWSTemplate.Id});

        System.assertEquals(2, recMap2.size(), 'Wrong number of WorkStepTemplates were retrieved on second method call');
        System.assertEquals(theWSTemplate.Id, recMap2.get(theWSTemplate.Id).Id, 'Original WorkStepTemplate does not match the ID key');
        System.assertEquals(theOtherWSTemplate.Id, recMap2.get(theOtherWSTemplate.Id).Id, 'Second WorkStepTemplate does not the ID key');
    }


    @IsTest
    static void testCreateWorkStepFromTemplate(){

        Schema.Location vanLoc = GDMFSL_DataFactory.createLocation('Van', null, null);
        vanLoc.TimeZone = 'America/New_York';
        insert vanLoc;

        Account theAcct = GDMFSL_DataFactory.createTestAccount('Test');
        Id stdAcctRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Standard').getRecordTypeId();
        theAcct.RecordTypeId = stdAcctRecTypeId;
        theAcct.Source_System_Types__c = 'ShipTo';
        insert theAcct;

        WorkType theWType = GDMFSL_DataFactory.createWorkType('Test', 1);
        insert theWType;

        ServiceContract theSC = GDMFSL_DataFactory.createServiceContract('Main SC', theAcct.Id);
        insert theSC;

        WorkOrder theWO = GDMFSL_DataFactory.createWorkOrder(theWType.Id, theAcct.Id, vanLoc.Id, Datetime.now(), Datetime.now().addDays(5));
        theWO.ServiceContractId = theSC.Id;
        theWO.GDMFSL_Ship_To_Account__c = theAcct.Id;
        insert theWO;


        WorkOrderLineItem  theWOLI = GDMFSL_DataFactory.createWorkOrderLineItem(theWType.Id, theWO.Id, null);
        insert theWOLI;

        WorkPlan theWPlan = new WorkPlan(Name = 'Test', WorkOrderId = theWO.Id, ExecutionOrder = 1,WorkOrderLineItemId = theWOLI.Id);
        insert theWPlan;


        WorkStepTemplate theWSTemplate = new WorkStepTemplate(Name = 'Test', IsActive = true);
        theWSTemplate.GDMFSL_Is_Reading__c=false;
        insert theWSTemplate;

        System.debug('TEST: start');

        Integer execOrderToUse = 3;

        WorkStep theWStep = GDMFSL_WorkStepTemplateProcessor.createWorkStepFromWorkStepTemplate(theWSTemplate,theWO.Id, theWPlan.Id, execOrderToUse,theWOLI.Id);
        theWStep.GDMFSL_Is_Reading__c=false;
        insert theWStep;

        List<WorkStep> wSteps = [SELECT WorkOrderId,WorkOrderLineItemId,GDMFSL_Is_Reading__c FROM WorkStep WHERE WorkPlanId = : theWPlan.Id];

        System.debug('WorkStep found : '+ wSteps);

        System.assertEquals(theWO.Id, wSteps[0].WorkOrderId, 'WorkStep WorkOrderId is not set correctly');
        System.assertEquals(theWPlan.Id, theWStep.WorkPlanId, 'WorkStep WorkPlanId is not set correctly');
        System.assertEquals(theWOLI.Id, wSteps[0].WorkOrderLineItemId, 'WorkStep WorkOrderLineItemId is not set correctly');
        System.assertEquals(execOrderToUse, theWStep.ExecutionOrder, 'WorkStep ExecutionOrder is not set correctly');

        for (String wstFieldName : GDMFSL_WorkStepTemplateProcessor.STEPTEMPLATETOWORKSTEP.keySet()) {
            System.assertEquals(theWSTemplate.get(GDMFSL_WorkStepTemplateProcessor.STEPTEMPLATETOWORKSTEP.get(wstFieldName)), theWStep.get(wstFieldName), 'WorkStep field ' + GDMFSL_WorkStepTemplateProcessor.STEPTEMPLATETOWORKSTEP.get(wstFieldName) + ' is not set correctly frmo WStep Template field: ' + wstFieldName);
        }
    }

    @IsTest
    static void testCreateWorkStepFromTemplateExecOrderDefault(){

        Schema.Location vanLoc = GDMFSL_DataFactory.createLocation('Van', null, null);
        vanLoc.TimeZone = 'America/New_York';
        insert vanLoc;

        Account theAcct = GDMFSL_DataFactory.createTestAccount('Test');
        Id stdAcctRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Standard').getRecordTypeId();
        theAcct.RecordTypeId = stdAcctRecTypeId;
        theAcct.Source_System_Types__c = 'ShipTo';
        insert theAcct;

        WorkType theWType = GDMFSL_DataFactory.createWorkType('Test', 1);
        insert theWType;

        ServiceContract theSC = GDMFSL_DataFactory.createServiceContract('Main SC', theAcct.Id);
        insert theSC;

        WorkOrder theWO = GDMFSL_DataFactory.createWorkOrder(theWType.Id, theAcct.Id, vanLoc.Id, Datetime.now(), Datetime.now().addDays(5));
        theWO.ServiceContractId = theSC.Id;
        theWO.GDMFSL_Ship_To_Account__c = theAcct.Id;
        insert theWO;

        WorkPlan theWPlan = new WorkPlan(Name = 'Test', WorkOrderId = theWO.Id, ExecutionOrder = 1);
        insert theWPlan;

        WorkOrderLineItem  theWOLI = GDMFSL_DataFactory.createWorkOrderLineItem(theWType.Id, theWO.Id, null);
        insert theWOLI;

        WorkStepTemplate theWSTemplate = new WorkStepTemplate(Name = 'Test', IsActive = true);
        insert theWSTemplate;

        System.debug('TEST: start');

        WorkStep theWStep = GDMFSL_WorkStepTemplateProcessor.createWorkStepFromWorkStepTemplate(theWSTemplate,theWO.Id, theWPlan.Id, null,theWOLI.Id);

        System.assertEquals(0, theWStep.ExecutionOrder, 'WorkStep ExecutionOrder is not defaulting to 0 as expected');
    }

}