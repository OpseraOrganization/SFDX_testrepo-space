@isTest
private class CloseCallout_to_forgeIoTTest {
    
    @testSetup static void setup() {

        Account theAccount = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert theAccount;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;

        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('ServAppt Test', theOpHours.Id);
        insert theServiceTerritory;

        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;

        List<WorkType> lstworktype = GDMFSL_DataFactory.createWorkTypes('W001',3,30);
        insert lstworktype;

        WorkOrder theWorkOrder = GDMFSL_DataFactory.createWorkOrder(lstworktype[0].Id, theAccount.Id, aLocation.Id, Datetime.valueOfGmt('2020-09-04 18:00:00'), Datetime.valueOfGmt('2020-09-05 18:00:00'));
        theWorkOrder.GDMFSL_PO_Number__c = '12345';
        insert theWorkOrder;

        
        GDMFSL_Integration_Work_Order_Canonical__c woTestRec = new GDMFSL_Integration_Work_Order_Canonical__c();
        woTestRec.End_Date__c = System.today();
        woTestRec.Forge_Root_Cause_Code__c = 'TBD';
        woTestRec.Forge_Service_Case_Number__c='12345';
        woTestRec.Forge_Site_Id__c='12345';
        woTestRec.Priority__c='High';
        woTestRec.Related_Work_Order__c= theWorkOrder.id;
        woTestRec.Resolution_Code__c='TBD';
        woTestRec.Resolution_Notes__c='TBD';
        woTestRec.Status__c='Completed';
        woTestRec.Work_Order_Number__c='00002176';
        
        insert woTestRec;             
    }
        
    @isTest
    static void testGetAccessTokenSuccess()
    {
        GDMFSL_Integration_Work_Order_Canonical__c wo = [SELECT ID,Name,End_Date__c,Forge_Root_Cause_Code__c,Forge_Service_Case_Number__c,
                                                                                   Forge_Site_Id__c,Priority__c,Related_Work_Order__c,
                                                                                   Resolution_Code__c,Resolution_Notes__c,Status__c,Work_Order_Number__c
                                                                                   FROM GDMFSL_Integration_Work_Order_Canonical__c LIMIT 1
                                                                                   ];
        Set<Id> woIdSet = new Set<Id>();
        woIdSet.add(wo.Id);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new getAccessTokenMock());
        CloseCallout_to_forgeIoT.getAccessToken(woIdSet);
        Test.stopTest();
        
        GDMFSL_Integration_Work_Order_Canonical__c wo_obj = [SELECT ID, IoT_Integration_Status__c,IoT_Integration_Error_Message__c 
                                                             		    FROM GDMFSL_Integration_Work_Order_Canonical__c LIMIT 1];
        System.assertEquals('Completed', wo_obj.IoT_Integration_Status__c, 'Integrated Successfully');
    }
    
    @isTest
    static void testGetAccessTokenError()
    {
        GDMFSL_Integration_Work_Order_Canonical__c wo = [SELECT ID,Name,End_Date__c,Forge_Root_Cause_Code__c,Forge_Service_Case_Number__c,
                                                                                   Forge_Site_Id__c,Priority__c,Related_Work_Order__c,
                                                                                   Resolution_Code__c,Resolution_Notes__c,Status__c,Work_Order_Number__c
                                                                                   FROM GDMFSL_Integration_Work_Order_Canonical__c LIMIT 1
                                                                                   ];
        Set<Id> woIdSet = new Set<Id>();
        woIdSet.add(wo.Id);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new forgeCloseCalloutMock());
        CloseCallout_to_forgeIoT.getAccessToken(woIdSet);
        Test.stopTest();
        
        GDMFSL_Integration_Work_Order_Canonical__c wo_obj = [SELECT ID, IoT_Integration_Status__c,IoT_Integration_Error_Message__c 
                                                             		    FROM GDMFSL_Integration_Work_Order_Canonical__c LIMIT 1];
        System.assertEquals('Failed', wo_obj.IoT_Integration_Status__c, 'Integration Failed');
    }
    
    @isTest
    static void testInvocableMethod()
    {
        GDMFSL_Integration_Work_Order_Canonical__c wo = [SELECT ID,Name,End_Date__c,Forge_Root_Cause_Code__c,Forge_Service_Case_Number__c,
                                                                                   Forge_Site_Id__c,Priority__c,Related_Work_Order__c,
                                                                                   Resolution_Code__c,Resolution_Notes__c,Status__c,Work_Order_Number__c
                                                                                   FROM GDMFSL_Integration_Work_Order_Canonical__c LIMIT 1
                                                                                   ];
        List<Id> woIdSet = new List<Id>();
        woIdSet.add(wo.Id);
        
        Test.startTest();
        CloseCallout_to_forgeIoT.forgeCloseCallout(woIdSet);
        Test.stopTest();
        
        System.assertEquals(woIdSet.size() > 0, true, 'Work Order Canonical list is not null');
    }
    
}