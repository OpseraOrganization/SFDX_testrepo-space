/**
 * Name       :    GDMFSL_ServiceResourceProcessorTest
 * Purpose    :    test class for GDMFSL_ServiceResourceProcessorTest
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Jmay                  2020-Sep-11    Created
 **/
@IsTest
private class GDMFSL_ServiceResourceProcessorTest {

    @TestSetup
    static void init() {

        Holiday theHol = [SELECT Id FROM Holiday LIMIT 1];

        Skip_Automation_Process__c automationprocess = GDMFSL_DataFactory.createProfileCustomSetting(false);
        insert automationprocess;

        List<OperatingHours> oHrsToInsert = new List<OperatingHours>();

        OperatingHours opHrs1 = GDMFSL_DataFactory.createOperatingHour();
        oHrsToInsert.add(opHrs1);

        OperatingHours opHrs2 = GDMFSL_DataFactory.createOperatingHour();
        opHrs2.GDMFSL_Holiday_Operating_Hours__c = true;
        oHrsToInsert.add(opHrs2);
        insert oHrsToInsert;

        OperatingHoursHoliday oHrsHoliday = new OperatingHoursHoliday(OperatingHoursId = opHrs1.Id, HolidayId = theHol.Id);
        insert oHrsHoliday;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('ServResProcessor Test', opHrs1.Id);
        insert st;
        System.debug('ServiceTerritory Inserted : ' + st);

        List<WorkType> lstworkType = new List<WorkType>();
        lstworkType.addAll(GDMFSL_DataFactory.createWorkTypes('BFWorkType', 1, 30, GDMFSL_WorkTypeProcessor.WORKTYPECATEGORY_BF, 'Critical'));
        insert lstworkType;
        System.debug('WorkType Inserted : ' + lstworkType);

        Account ac = GDMFSL_DataFactory.createTestAccount('TestAccount');
        insert ac;
        System.debug('Account Inserted : ' + ac);

        Schema.Location location = GDMFSL_DataFactory.createLocation('Campus', st.Id, opHrs1.Id);
        Schema.Location location1 = GDMFSL_DataFactory.createLocation('Campus', null, opHrs1.Id);
        List<Schema.Location > lstlocation = new List<Schema.Location >();
        lstlocation.add(location);
        lstlocation.add(location1);
        insert lstlocation;
        System.debug('location Inserted : ' + location);

        Schema.Address address = GDMFSL_DataFactory.createAddress('169 SpruceTree Lane', 'Ballwin', 'Missouri', '63021',
                'United States', lstlocation[0].Id);
        List<Schema.Address> lstaddress = new List<Schema.Address>();
        lstaddress.add(address);
        insert lstaddress;
        System.debug('address Inserted : ' + address);

        List<User> usrsToAdd = new List<User>();

        User testUser = GDMFSL_DataFactory.createTestUser();
        usrsToAdd.add(testUser);

        User testUser2 = GDMFSL_DataFactory.createTestUser();
        usrsToAdd.add(testUser2);
        insert usrsToAdd;
        System.debug('User Inserted : ' + usrsToAdd);

        List<ServiceResource> srToInsert = new List<ServiceResource>();

        ServiceResource sr = GDMFSL_DataFactory.createServiceResource(usrsToAdd[0].Id, lstlocation[0].Id);
        srToInsert.add(sr);
        ServiceResource sr2 = GDMFSL_DataFactory.createServiceResource(usrsToAdd[1].Id, lstlocation[0].Id);
        srToInsert.add(sr2);
        insert srToInsert;
        System.debug('ServiceResource Inserted : ' + srToInsert);


        WorkOrder wo = GDMFSL_DataFactory.createWorkOrder(lstworkType[0].Id, ac.Id, lstlocation[0].Id, Datetime.now(), Datetime.now());
        wo.Subject = 'TestWO';
        wo.GDMFSL_PO_Number__c = '123';
        wo.ServiceTerritoryId = st.Id;
        wo.LocationId = lstlocation[0].Id;
        insert wo;
        System.debug('WorkOrder Inserted : ' + wo);

        ServiceAppointment sa = GDMFSL_DataFactory.createServiceAppointment(wo.Id, 'None');
        sa.SchedStartTime = Datetime.now();
        sa.SchedEndTime = Datetime.now().addDays(10);
        insert sa;
        System.debug('Service Appointment Inserted : ' + wo);


        ServiceTerritoryMember stm =  GDMFSL_DataFactory.createServiceTerritoryMember( srToInsert[0].Id,  st.Id);
        stm.TerritoryType = 'P';
        stm.OperatingHoursId = opHrs1.Id;
        insert stm;
        System.debug('Service Territory Member Inserted : ' + stm);

        AssignedResource ar = GDMFSL_DataFactory.createAssignedResource(sa.Id, sr.Id);
        insert ar;
        System.debug('Assigned Resource Inserted : ' + ar);
    }

    @IsTest
    static void removeGeoTrackingOnServResourceTest() {

        ServiceResource sr = [SELECT Id,LastKnownLatitude, LastKnownLongitude, LastKnownLocationDate FROM ServiceResource LIMIT 1];

        sr.LastKnownLatitude = 42.234234;
        sr.LastKnownLongitude = 70.234324;

        ServiceAppointment theSA = [SELECT Id FROM ServiceAppointment LIMIT 1];
        theSA.GDMFSL_Disable_GeoTracking__c = true;

        update theSA;

        System.debug('TEST: start');
        GDMFSL_ServiceResourceProcessor.removeGeoTracking(new List<ServiceResource>{
                sr
        });

        System.debug('TEST: end');

        System.assertEquals(null, sr.LastKnownLatitude, 'removeGeoTracking did not clear LastKnownLatitude');
        System.assertEquals(null, sr.LastKnownLongitude, 'removeGeoTracking did not clear LastKnownLongitude');
        System.assertEquals(null, sr.LastKnownLocationDate, 'removeGeoTracking did not clear LastKnownLocationDate');

    }

    @IsTest
    static void getRecords() {

        List<ServiceResource> theSRs = [SELECT Id FROM ServiceResource];

        Map<Id, ServiceResource> mapServiceResource = GDMFSL_ServiceResourceProcessor.getRecords(new Set<Id>{theSRs[0].Id});

        System.assertEquals(true, !mapServiceResource.isEmpty(), 'getRecords() returned no records');
        System.assertEquals(theSRs[0].Id, mapServiceResource.get(theSRs[0].Id).Id, 'getRecords() returned the wrong record');

        Integer origRecCount = mapServiceResource.size();

        mapServiceResource = GDMFSL_ServiceResourceProcessor.getRecords(new Set<Id>{theSRs[1].Id});

        System.assert(origRecCount < mapServiceResource.size(), 'getRecords() returned no more records on subsequent call');
        System.assertEquals(theSRs[0].Id, mapServiceResource.get(theSRs[0].Id).Id, 'getRecords() returned wrong record in original key on subsequent call');
        System.assertEquals(theSRs[1].Id, mapServiceResource.get(theSRs[1].Id).Id, 'getRecords() returned the wrong subsequent record');

    }

    @IsTest
    static void processHolidaysTest() {

        ServiceResource sr = [SELECT Id, IsActive, GDMFSL_Holiday_Processing_Range_Start__c, GDMFSL_Holiday_Processing_Range_End__c FROM ServiceResource LIMIT 1];

        ServiceResource origSR = sr.clone(true, true, true, true);

        sr.GDMFSL_Holiday_Processing_Range_Start__c = Date.today().addDays(-5);
        sr.GDMFSL_Holiday_Processing_Range_End__c = Date.today().addDays(365);

        Map<Id, ServiceTerritoryMember> origSTM = new Map<Id, ServiceTerritoryMember>([SELECT Id FROM ServiceTerritoryMember]);

        Test.startTest();

        System.debug('TEST: start');
        GDMFSL_ServiceResourceProcessor.processHolidays(new List<ServiceResource>{sr}, new Map<Id, ServiceResource>{
                origSR.Id => origSR
        });

        Test.stopTest();

        Map<Id, ServiceTerritoryMember> finalSTM = new Map<Id, ServiceTerritoryMember>([SELECT Id FROM ServiceTerritoryMember]);

        System.assertNotEquals(0, finalSTM.size(), 'STMS not created during Holiday processing');

        for (Id thisOrigId : origSTM.keySet()){
            if(finalSTM.containsKey(thisOrigId)){
                System.assert(false, 'ServiceTerritoryMember was not deleted during Holiday processing');
            }
        }
    }

}