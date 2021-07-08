/*******************************************************************************************
Name       :    GDMFSL_CaseProcessorTest
Purpose    :    Test class for GDMFSL_CaseProcessor.
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Varun Misra           2021-Jan-26      Created
Bryant Daniels        2021-May-06     Updating to add assertions
**********************************************************************************************/


@IsTest
private class GDMFSL_CaseProcessorTest {

    @TestSetup
    static void makeData(){
            //Normal Complete status Transition
            FSL.GlobalAPIS.addStatusTransition('None', 'Scheduled');
            FSL.GlobalAPIS.addStatusTransition('Scheduled', 'Dispatched');
            FSL.GlobalAPIS.addStatusTransition('Dispatched', 'Accepted');
            FSL.GlobalAPIS.addStatusTransition('Accepted', 'Travel');
            FSL.GlobalAPIS.addStatusTransition('Travel', 'Onsite');
            FSL.GlobalAPIS.addStatusTransition('Onsite', 'Check Out');
            FSL.GlobalAPIS.addStatusTransition('Check Out', 'Completed');

            //Variations status stransitions
            FSL.GlobalAPIS.addStatusTransition('None', 'Canceled');
            FSL.GlobalAPIS.addStatusTransition('None', 'Onsite');

        Account acct = new Account(Name='Test Account',Phone = '1234561234',BillingStreet = 'Anywhere',BillingCity = 'City',BillingState = 'Florida',BillingCountry = 'United States');
        insert acct;

        List<Product2> p = GDMFSL_DataFactory.createProducts('Test Product',1);
        insert p;

        List<Asset> a = GDMFSL_DataFactory.createAssets('Test Asset',p[0].Id,acct.Id,1);
        insert a;

        WorkType wt = GDMFSL_DataFactory.createWorkType('Break/Fix',4);
        wt.GDMFSL_WorkType_Category__c = 'BF';
        insert wt;

        OperatingHours oh = GDMFSL_DataFactory.createOperatingHour();
        insert oh;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('CaseProc Test', oh.Id);
        insert st;

        Schema.Location lo = GDMFSL_DataFactory.createLocation('Test Location',st.Id);
        insert lo;

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        Id genInqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_General_Inquiry').getRecordTypeId();
        Case ca = GDMFSL_DataFactory.createCase('APAC',a[0].Id);
        ca.RecordTypeId = servReqRecTypeId;
        insert ca;

        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(wt.Id,acct.Id,lo.Id,System.now(),System.now());
        wo.CaseId = ca.Id;
        wo.GDMFSL_PO_Number__c = '12345';
        wo.Subject = 'Test Work Order';
        insert wo;

        WorkOrderLineItem woli = GDMFSL_DataFactory.createWorkOrderLineItem(wt.Id,wo.Id,a[0].Id);
        insert woli;

        ServiceContract servct = GDMFSL_DataFactory.createServiceContract('Test servContract',acct.Id);
        insert servct;

        ServiceAppointment sa = GDMFSL_DataFactory.createServiceAppointment(acct.Id, 'None');
        sa.ParentRecordId = wo.Id;
        insert sa;
        
    }

    @IsTest
    static void updateCaseStatusFromWorkOrderTestNotCompleted() {
        WorkOrder wo = [SELECT Id, Status, StatusCategory, CaseId FROM WorkOrder WHERE Subject =: 'Test Work Order'];
        wo.Status = 'Scheduled';
        update wo;


        List<WorkOrder> woToTest = new List<WorkOrder>();
        woToTest.add(wo);

        Test.startTest();
        GDMFSL_CaseProcessor.updateCaseStatusFromWorkOrder(woToTest);
        Test.stopTest();

        Case c = [SELECT Id, Status FROM Case WHERE Id =: wo.CaseId];

        System.assertEquals(wo.StatusCategory, c.Status, 'Case Status does not match the Work Order Status Category');
        
        
    }
    @IsTest
    static void updateCaseStatusFromWorkOrderTestCompleted() {
        WorkOrder wo = [SELECT Id, Status, StatusCategory, CaseId FROM WorkOrder WHERE Subject =: 'Test Work Order'];
        wo.Status = 'Completed';
        update wo;


        List<WorkOrder> woToTest = new List<WorkOrder>();
        woToTest.add(wo);

        Test.startTest();
        GDMFSL_CaseProcessor.updateCaseStatusFromWorkOrder(woToTest);
        Test.stopTest();

        Case c = [SELECT Id, Status FROM Case WHERE Id =: wo.CaseId];

        System.assertEquals(wo.StatusCategory, c.Status, 'Case Status does not match Work Order Status Category');
        
        
    }
    

    
    
    @IsTest
    static void closeRelatedWorkOrdersAndServiceAppointmentsTestValid() {

        Map<Id, Case> newMap = new Map<Id, Case>();
        Map<Id, Case> oldMap = new Map<Id, Case>();
        
        List<Case> cases = [SELECT Id, Status, RecordTypeId FROM Case];
        for(Case c : cases){
            oldMap.put(c.Id, c);
        }

        Test.startTest();
        try {
            for(Case c : cases){
                c.Status = 'Canceled';
                newMap.put(c.Id, c);
            }
            update newMap.values();
            GDMFSL_CaseProcessor.closeRelatedWorkOrdersAndServiceAppointments(newMap, oldMap);
            
        } catch (DmlException e) {
            Boolean expectedExceptionThrown =  e.getMessage().contains('The current case cannot be canceled because either the associated work order or service appointment is in a status does not meet the criteria to be canceled') ? true : false;
            System.assertEquals(false, expectedExceptionThrown, 'Exception Should not have been thrown');
        }
           
        Test.stopTest();

        WorkOrder woToVerify = [SELECT Id, Status FROM WorkOrder];
        System.debug('GDMFSL_CaseProcessorTest woToVerify: ' + woToVerify);

        ServiceAppointment saToVerify = [SELECT Id,ParentRecordId, Status FROM ServiceAppointment WHERE ParentRecordId =: woToVerify.Id];
        System.debug('GDMFSL_CaseProcessorTest saToVerify: ' + saToVerify);

        Case caseToVerify = [SELECT Id, Status FROM Case];
        System.debug('GDMFSL_CaseProcessorTest caseToVerify: ' + caseToVerify);

        System.assertEquals(caseToVerify.Status, saToVerify.Status, 'SA Status is not canceled');
        System.assertEquals(caseToVerify.Status, woToVerify.Status, 'WO Status is not canceled');
    }

    @IsTest
    static void closeRelatedWorkOrdersAndServiceAppointmentsTestInValid() {

        Map<Id, Case> newMap = new Map<Id, Case>();
        Map<Id, Case> oldMap = new Map<Id, Case>();

        Case oldCase = [SELECT Id, Status, RecordTypeId FROM Case];
        oldCase.Status = 'In Progress';
        oldMap.put(oldCase.Id, oldCase);
        

        Case newCase = [SELECT Id, Status, RecordTypeId FROM Case];
        newCase.Status = 'Canceled';
        newMap.put(newCase.Id, newCase);
        

        WorkOrder wo = [SELECT Id, Status FROM WorkOrder];
        wo.Status = 'In Progress';

        ServiceAppointment sa = [SELECT Id, Status FROM ServiceAppointment WHERE ParentRecordId=: wo.Id ];
        sa.Status = 'Onsite';
       
        Test.startTest();
            try {
                GDMFSL_CaseProcessor.closeRelatedWorkOrdersAndServiceAppointments(newMap, oldMap);
            } catch (Exception ex) {
                Boolean expectedExceptionThrown =  ex.getMessage().contains('The current case cannot be canceled because either the associated work order or service appointment is in a status does not meet the criteria to be canceled') ? true : false;
                System.assertEquals(expectedExceptionThrown, true);
            }
           
        Test.stopTest();

        Case caseToVerify = [SELECT Id, Status FROM Case];
       
        System.assertNotEquals(sa.Status,caseToVerify.Status, 'SA Status has been cancelled');
        System.assertNotEquals(wo.Status,caseToVerify.Status, 'WO Status has been cancelled');
    }

    
    @IsTest
    static void assessCaseCompletedTest() {

        Id genInqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_General_Inquiry').getRecordTypeId();
        List<Case> casesToUse = new List<Case>();
        Map<Id, Case> oldMap = new Map<Id, Case>();

        Case oldCase = [SELECT Id, Status, RecordTypeId FROM Case];
        oldCase.RecordTypeId = genInqRecTypeId;
        oldCase.Status = 'Completed';
        oldMap.put(oldCase.Id, oldCase);
        

        Case c = [SELECT Id, Status, RecordTypeId FROM Case];
        c.Status = 'Canceled';
        c.RecordTypeId = genInqRecTypeId;
        casesToUse.add(c);
    
        Test.startTest();
        try {
            GDMFSL_CaseProcessor.assessCaseCompleted(casesToUse, oldMap);
        } catch (Exception ex) {
            Boolean expectedExceptionThrown =  ex.getMessage().contains('You can only cancel a case from New or In Progress status.') ? true : false;
            System.assertEquals(true, expectedExceptionThrown);
        }
       
        Test.stopTest();
        
    }
    
    @IsTest
    static void getCaseIDsThatCanBeClosedTest() {
        
        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
        List<Case> casesToUse = new List<Case>();
        Map<Id, Case> oldMap = new Map<Id, Case>();

        Case oldCase = [SELECT Id, Status, RecordTypeId FROM Case];
        oldCase.RecordTypeId = servReqRecTypeId; 
        oldCase.Status = 'In Progress';
        oldMap.put(oldCase.Id, oldCase);
        

        Case c = [SELECT Id, Status, RecordTypeId FROM Case];
        c.Status = 'Canceled';
        c.RecordTypeId = servReqRecTypeId;
        casesToUse.add(c);
    
        Test.startTest();
        Set<Id> idsToCheck =  GDMFSL_CaseProcessor.getCaseIDsThatCanBeClosed(casesToUse, oldMap);
        Test.stopTest();
        
        System.assert(idsToCheck.size() > 0);
        System.assertEquals(true, !idsToCheck.isEmpty(), 'Condition Should be true');
        
    }

    @IsTest 
    static void getRecordTest(){
        Map<Id, Case> mapToTest = new Map<Id, Case>();
        Set<Id> setToUse = new Set<Id>();
        Asset ast = [SELECT Id FROM Asset LIMIT 1];
        Case c = [SELECT Id, AssetId, CreatedDate FROM Case];
        c.AssetId = ast.Id;
        update c;
        setToUse.add(c.Id);

        Test.startTest();
        mapToTest = GDMFSL_CaseProcessor.getRecords(setToUse);
        Test.stopTest();

        System.assertNotEquals(false, !mapToTest.isEmpty(), 'Map should not be null');
    }
    
    
    @IsTest
    static void setCaseFieldsTest() {
       Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GDMFSL_Service_Request').getRecordTypeId();
       List<Case> caseToUse = new List<Case>(); 
       Case c = [SELECT Id, Origin, Region__c, OwnerId, RecordTypeId FROM Case];
       c.Origin = 'Community';
       c.Region__c = 'North America';
       c.RecordTypeId = servReqRecTypeId;
       update c;
       caseToUse.add(c);

       Test.startTest();
       GDMFSL_CaseProcessor.setCaseFields(caseToUse);
       Test.stopTest();

       Case updateCase = [SELECT Id, OwnerId FROM Case];
       Group queueGrp = [SELECT Id, Name FROM Group WHERE Name = 'HBS US Customer Community' AND Type = 'Queue'];
    

       System.assertNotEquals(updateCase.OwnerId, caseToUse[0].OwnerId,  'Owner Should have been changed by setCaseFields()');
       System.assertEquals( queueGrp.Id, caseToUse[0].OwnerId, 'Owner Should Match Queue');
        
    }

    @IsTest
    static void getQueueIdFromNamesTest(){
       List<String> stringsToTest = new List<String>{'HBS US Customer Community'};
       Test.startTest();
       Map<String, Id> mapToVerify = GDMFSL_CaseProcessor.getQueueIdFromNames(stringsToTest);
       Test.stopTest();

       System.assertEquals(false, mapToVerify.isEmpty(), 'getQueueIdFromNames() did not find and records');
      
    }

    @IsTest
    static void getQueueIdFromNamesNoMatchTest(){
       List<String> stringsToTest = new List<String>{'No Queue'};

       Map<String, Id> mapToVerify = GDMFSL_CaseProcessor.getQueueIdFromNames(stringsToTest);

       System.assertEquals(true, mapToVerify.isEmpty(), 'getQueueIdFromNames() found records but should not have');
    }

    @IsTest
    static void cancelContractRelatedCasesTest(){
       Set<Id> scIds = new Set<Id>();
       ServiceContract sc = [SELECT Id, Status FROM ServiceContract];
       scIds.add(sc.Id);

       Case cs = [SELECT Id, Status, ServiceContractId FROM Case];
       cs.ServiceContractId = sc.Id;
       update cs;


       Test.startTest();
       GDMFSL_CaseProcessor.cancelContractRelatedCases(scIds);
       Test.stopTest();

       Case updateCase = [SELECT Id, Status, ServiceContractId FROM Case WHERE ServiceContractId IN: scIds];

       System.assertEquals('Canceled', updateCase.Status,  'Case Should Be Canceled');
      
    }

   

 
    
}