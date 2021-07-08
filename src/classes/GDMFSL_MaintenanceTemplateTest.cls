@IsTest(IsParallel=true)
public without sharing class GDMFSL_MaintenanceTemplateTest {
    public GDMFSL_MaintenanceTemplateTest() {
    }


    @IsTest
    static void testGetMaintenanceTemplateForProducts(){
        Product2 testProduct = new Product2(Name = 'TestProduct');
        insert testProduct;
        WorkType wt = new WorkType(Name='PM',EstimatedDuration=8);
        insert wt;
        GDMFSL_Maintenance_Template__c source = new GDMFSL_Maintenance_Template__c(GDMFSL_Product__c=testProduct.Id,GDMFSL_Work_Type__c=wt.Id,GDMFSL_Duration_minutes__c=10,
                                                                                    GDMFSL_Frequency_Every_N__c=60,GDMFSL_Frequency_Type__c='Weekly',
                                                                                    GDMFSL_Recurrence_Type__c='Weekly On Day of Week',GDMFSL_Sort_Order__c=1,
                                                                                    Name='TheMaintTemp');
        insert source;

        Map<Id,List<GDMFSL_MaintenanceTemplate>> mtResultMap;
        Test.startTest();
            mtResultMap = GDMFSL_MaintenanceTemplate.getMaintenanceTemplateForProducts(new Set<Id>{testProduct.Id});
        Test.stopTest();

        System.assert(mtResultMap != null,'No Maintenance Template Found ');
        System.assert(mtResultMap.get(testProduct.Id) != null,'No MaintenanceTemplate found for the Product');
        System.assertEquals(1,mtResultMap.get(testProduct.Id).size(),'Returned size of Maintenance template is not as expected');

        GDMFSL_MaintenanceTemplate mt = mtResultMap.get(testProduct.Id)[0];
        System.assertEquals(mt.recordId, source.Id,'SourceId dont match');
        System.assertEquals(mt.theProductId, testProduct.Id,'Product dont match');
        System.assertEquals(mt.theWorkTypeId, wt.Id,'WorkType dont match');
        System.assertEquals(10,mt.durationInMinutes,'Duration In Minutes dont match');
        System.assertEquals(60,mt.frequency,'Frequency dont match');
        System.assertEquals(mt.frequencyType, 'Weekly','Frequency Type dont match');
        System.assertEquals(mt.recurrenceType, 'Weekly On Day of Week','Recurrence Type dont match');
        System.assertEquals(mt.rRuleTemplate, 'FREQ=WEEKLY;BYDAY=TBD;INTERVAL=60','RRule Template dont match');
        System.assertEquals(1,mt.sortOrder,'Sort Order dont match');
        System.assertEquals('TheMaintTemp',mt.name,'Name dont match');
    }

    @IsTest
    static void testGetMaintenanceTemplateForEmptyProducts(){
        Product2 testProduct = new Product2(Name = 'TestProduct');
        insert testProduct;

        Map<Id,List<GDMFSL_MaintenanceTemplate>> mtResultMap;
        Test.startTest();
            mtResultMap = GDMFSL_MaintenanceTemplate.getMaintenanceTemplateForProducts(new Set<Id>{testProduct.Id});
        Test.stopTest();

        System.assert(mtResultMap != null,'Returned Map is Null');
        System.assert(mtResultMap.get(testProduct.Id) == null,'Wrong Map returned for the this product');
    }

    @IsTest
    static void testMapsObjectToMaintTemplate(){
        Product2 testProduct = new Product2(Name = 'TestProduct');
        insert testProduct;
        WorkType wt = new WorkType(Name='PM',EstimatedDuration=8);
        insert wt;
        GDMFSL_Maintenance_Template__c source = new GDMFSL_Maintenance_Template__c(GDMFSL_Product__c=testProduct.Id,GDMFSL_Work_Type__c=wt.Id,GDMFSL_Duration_minutes__c=10,
                                                                                    GDMFSL_Frequency_Every_N__c=60,GDMFSL_Frequency_Type__c='Weekly',
                                                                                    GDMFSL_Recurrence_Type__c='Weekly On Day of Week',GDMFSL_Sort_Order__c=1,
                                                                                    Name='TheMaintTemp');
        insert source;
        GDMFSL_Maintenance_Template__c source2 = [select GDMFSL_Product__c,GDMFSL_Work_Type__c,GDMFSL_Duration_minutes__c,GDMFSL_Frequency_Every_N__c,GDMFSL_Frequency_Type__c,GDMFSL_Recurrence_Type__c,GDMFSL_Sort_Order__c,Name, GDMFSL_RRULE_Template__c from GDMFSL_Maintenance_Template__c limit 1];

        GDMFSL_MaintenanceTemplate temp = null;
        Test.startTest();
            temp = GDMFSL_MaintenanceTemplate.mapsObjectToMaintTemplate(source2);
        Test.stopTest();

        System.assertEquals(temp.recordId, source.Id,'SourceId dont match');
        System.assertEquals(temp.theProductId, testProduct.Id,'Product dont match');
        System.assertEquals(temp.theWorkTypeId, wt.Id,'WorkType dont match');
        System.assertEquals(10,temp.durationInMinutes,'Duration In Minutes dont match');
        System.assertEquals(60,temp.frequency,'Frequency dont match');
        System.assertEquals(temp.frequencyType, 'Weekly','Frequency Type dont match');
        System.assertEquals(temp.recurrenceType, 'Weekly On Day of Week','Recurrence Type dont match');
        System.assertEquals(temp.rRuleTemplate, 'FREQ=WEEKLY;BYDAY=TBD;INTERVAL=60','RRule Template dont match');
        System.assertEquals(1,temp.sortOrder,'Sort Order dont match');
        System.assertEquals('TheMaintTemp',temp.name,'Name dont match');
    }    

    @IsTest
    static void testMapsEmptyObjectToMaintTemplate(){
        GDMFSL_MaintenanceTemplate temp = null;
        Test.startTest();
            temp = GDMFSL_MaintenanceTemplate.mapsObjectToMaintTemplate(null);
        Test.stopTest();
        System.assertEquals(null,temp,'Found record expecting Null');
    }        
}