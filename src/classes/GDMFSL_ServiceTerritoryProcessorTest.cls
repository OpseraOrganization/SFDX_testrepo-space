@IsTest
private class GDMFSL_ServiceTerritoryProcessorTest {

    @IsTest
    static void testGetSTMQueryString() {
        String result;
        Test.startTest();
            result = GDMFSL_ServiceTerritoryProcessor.getSTMQueryString();
        Test.stopTest();
        System.assertEquals('\'SELECT Id,  EffectiveEndDate, EffectiveStartDate, OperatingHoursId, ServiceResourceId, TerritoryType  , City, Country, CountryCode, PostalCode, State, StateCode, Street  , GDMFSL_30_Minutes_Break__c,GDMFSL_45_Minutes_Break__c,GDMFSL_60_Minutes_Break__c, ServiceTerritoryId, ServiceTerritory.OperatingHoursId  FROM ServiceTerritoryMember \'', '\'' + result + '\'', 'the expected query string did not match the return');
    }

    @IsTest
    static void testGetRecords(){
        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;
        System.debug('operatingHours Inserted: ' + operatingHours);

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('ResPref Test', operatingHours.Id);
        insert st;
        ServiceTerritory st2 = GDMFSL_DataFactory.createServiceTerritory('ResPref Test 2', operatingHours.Id);
        insert st2;

        Map<Id,ServiceTerritory> resultMap;
        Test.startTest();
            resultMap = GDMFSL_ServiceTerritoryProcessor.getRecords(new Set<Id>{st.Id,st2.Id});
        Test.stopTest();

        System.assertEquals(2,resultMap.keySet().size(), 'getRecords returned the wrong number of items');
        System.assert(resultMap.containsKey(st.Id), 'ResPref Test Territory was not returned');
        System.assert(resultMap.containsKey(st2.Id),'ResPref Test 2 Territory was not returned');
    }

    @IsTest
    static void testGetRecordsSubsequentCall(){
        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;
        System.debug('operatingHours Inserted: ' + operatingHours);

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('ResPref Test', operatingHours.Id);
        insert st;
        ServiceTerritory st2 = GDMFSL_DataFactory.createServiceTerritory('ResPref Test 2', operatingHours.Id);
        insert st2;
        ServiceTerritory st3 = GDMFSL_DataFactory.createServiceTerritory('ResPref Test 3', operatingHours.Id);
        insert st3;
        ServiceTerritory st4 = GDMFSL_DataFactory.createServiceTerritory('ResPref Test 4', operatingHours.Id);
        insert st4;

        Map<Id,ServiceTerritory> resultMap;
        Test.startTest();
            resultMap = GDMFSL_ServiceTerritoryProcessor.getRecords(new Set<Id>{st.Id,st2.Id});

            System.assertEquals(2,resultMap.keySet().size(), 'getRecords returned the wrong number of items');
            System.assert(resultMap.containsKey(st.Id), 'ResPref Test Territory was not returned');
            System.assert(resultMap.containsKey(st2.Id),'ResPref Test 2 Territory was not returned');

            resultMap = GDMFSL_ServiceTerritoryProcessor.getRecords(new Set<Id>{st3.Id,st4.Id}); // Add new records
        Test.stopTest();

        System.assertEquals(4,resultMap.keySet().size(), 'getRecords returned the wrong number of items');
        System.assert(resultMap.containsKey(st.Id), 'ResPref Test Territory was not returned');
        System.assert(resultMap.containsKey(st2.Id),'ResPref Test 2 Territory was not returned');
        System.assert(resultMap.containsKey(st3.Id), 'ResPref Test 3 Territory was not returned');
        System.assert(resultMap.containsKey(st4.Id),'ResPref Test 4 Territory was not returned');
    }    

    @IsTest
    static void testGetSTMsByResource(){
        List<User> theUsers = new List<User>();
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        insert theUsers;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;
        
        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('Test Territory', theOpHours.Id);
        insert theServiceTerritory;
        
        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;
        System.debug('TestLocation Inserted : ' + aLocation);
        
        ServiceResource serviceResource = GDMFSL_DataFactory.createServiceResource(theUsers[0].Id, aLocation.Id);
        serviceResource.GDMFSL_IsContractor__c = true;
        ServiceResource serviceResource2 = GDMFSL_DataFactory.createServiceResource(theUsers[1].Id, aLocation.Id);
        serviceResource2.GDMFSL_IsContractor__c = true;
        insert new List<ServiceResource>{serviceResource,serviceResource2};
        
        ServiceTerritoryMember serviceTerritoryMember = GDMFSL_DataFactory.createServiceTerritoryMember(serviceResource.Id,theServiceTerritory.Id);
        serviceTerritoryMember.TerritoryType = 'P';
        insert serviceTerritoryMember;

        Map<Id,List<ServiceTerritoryMember>> resultMap;

        Test.startTest();
            resultMap = GDMFSL_ServiceTerritoryProcessor.getSTMs(new Set<ServiceResource>{serviceResource},true);
        Test.stopTest();

        System.assert(resultMap.containsKey(serviceResource.Id),'The expected Serviceresource was not returned');
        System.assertEquals(1, resultMap.get(serviceResource.Id).size(), 'The result map has no elements');
        System.assertEquals(serviceTerritoryMember.Id, resultMap.get(serviceResource.Id)[0].Id, 'The Service Resource for the provided ServiceTerritory did not match');
    }

    @IsTest
    static void testGetSTMsOnlyPrimaryByResource(){
        List<User> theUsers = new List<User>();
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        insert theUsers;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;
        
        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('Test Territory', theOpHours.Id);
        ServiceTerritory theServiceTerritory2 = GDMFSL_DataFactory.createServiceTerritory('Test Territory2', theOpHours.Id);
        insert new List<ServiceTerritory>{theServiceTerritory, theServiceTerritory2};        
        
        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        Schema.Location aLocation2 = GDMFSL_DataFactory.createLocation('Campus2',theServiceTerritory2.Id);
        insert new List<Schema.Location>{aLocation,aLocation2};     

        ServiceResource serviceResource = GDMFSL_DataFactory.createServiceResource(theUsers[0].Id, aLocation.Id);
        serviceResource.GDMFSL_IsContractor__c = true;
        insert serviceResource;
        
        ServiceTerritoryMember serviceTerritoryMember = GDMFSL_DataFactory.createServiceTerritoryMember(serviceResource.Id,theServiceTerritory.Id);
        serviceTerritoryMember.TerritoryType = 'P';
        ServiceTerritoryMember serviceTerritoryMember2 = GDMFSL_DataFactory.createServiceTerritoryMember(serviceResource.Id,theServiceTerritory2.Id);
        serviceTerritoryMember2.TerritoryType = 'S';
        insert new List<ServiceTerritoryMember>{serviceTerritoryMember,serviceTerritoryMember2};        

        Map<Id,List<ServiceTerritoryMember>> resultMap;

        Test.startTest();
            resultMap = GDMFSL_ServiceTerritoryProcessor.getSTMs(new Set<ServiceResource>{serviceResource},true);
        Test.stopTest();

        System.assertEquals(1,resultMap.keySet().size(), 'The getSTM method did not return any Service Territory Members');
        System.assert(resultMap.containsKey(serviceResource.Id), 'The getSTM method did not return the correct Service Resource');
        System.assertEquals(serviceTerritoryMember.Id,resultMap.get(serviceResource.Id)[0].Id, 'The getSTM method did not return the correct Service Resource Member');
    }    

    @IsTest
    static void testGetSTMsNoPrimaryByResource(){
        List<User> theUsers = new List<User>();
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        insert theUsers;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;
        
        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('Test Territory', theOpHours.Id);
        insert theServiceTerritory;        
        
        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;     

        ServiceResource serviceResource = GDMFSL_DataFactory.createServiceResource(theUsers[0].Id, aLocation.Id);
        serviceResource.GDMFSL_IsContractor__c = true;
        insert serviceResource;
        
        ServiceTerritoryMember serviceTerritoryMember = GDMFSL_DataFactory.createServiceTerritoryMember(serviceResource.Id,theServiceTerritory.Id);
        serviceTerritoryMember.TerritoryType = 'S';
        insert serviceTerritoryMember;        

        Map<Id,List<ServiceTerritoryMember>> resultMap;

        Test.startTest();
            resultMap = GDMFSL_ServiceTerritoryProcessor.getSTMs(new Set<ServiceResource>{serviceResource},true);
        Test.stopTest();

        System.assertEquals(0,resultMap.keySet().size(), 'The getSTM method unexpectedly returned a Service Territory Member');
    }       
    
    @IsTest
    static void testGetSTMsDontAllowSecondaryByResource(){
        List<User> theUsers = new List<User>();
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        insert theUsers;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;
        
        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('Test Territory', theOpHours.Id);
        insert theServiceTerritory;        
        
        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;     

        ServiceResource serviceResource = GDMFSL_DataFactory.createServiceResource(theUsers[0].Id, aLocation.Id);
        serviceResource.GDMFSL_IsContractor__c = true;
        insert serviceResource;
        
        ServiceTerritoryMember serviceTerritoryMember = GDMFSL_DataFactory.createServiceTerritoryMember(serviceResource.Id,theServiceTerritory.Id);
        serviceTerritoryMember.TerritoryType = 'S';
        insert serviceTerritoryMember;        

        Map<Id,List<ServiceTerritoryMember>> resultMap;

        Test.startTest();
            resultMap = GDMFSL_ServiceTerritoryProcessor.getSTMs(new Set<ServiceResource>{serviceResource},false);
        Test.stopTest();

        System.assertEquals(1,resultMap.keySet().size(), 'The getSTM method returned an unexpected number of STMs');
        System.assert(resultMap.containsKey(serviceResource.Id), 'The getSTM method did not return the correct Service Resource');
        System.assertEquals(serviceTerritoryMember.Id,resultMap.get(serviceResource.Id)[0].Id, 'The getSTM method did not return the correct Service Resource Member');

    }           

    @IsTest
    static void testGetSTMsByTerritory(){
        List<User> theUsers = new List<User>();
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        insert theUsers;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;
        
        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('Test Territory', theOpHours.Id);
        insert theServiceTerritory;
        
        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;
        System.debug('TestLocation Inserted : ' + aLocation);
        
        ServiceResource serviceResource = GDMFSL_DataFactory.createServiceResource(theUsers[0].Id, aLocation.Id);
        serviceResource.GDMFSL_IsContractor__c = true;
        ServiceResource serviceResource2 = GDMFSL_DataFactory.createServiceResource(theUsers[1].Id, aLocation.Id);
        serviceResource2.GDMFSL_IsContractor__c = true;
        insert new List<ServiceResource>{serviceResource};
        
        ServiceTerritoryMember serviceTerritoryMember = GDMFSL_DataFactory.createServiceTerritoryMember(serviceResource.Id,theServiceTerritory.Id);
        serviceTerritoryMember.TerritoryType = 'P';
        insert serviceTerritoryMember;

        Map<Id,List<ServiceTerritoryMember>> resultMap;

        Test.startTest();
            resultMap = GDMFSL_ServiceTerritoryProcessor.getSTMs(new Set<Id>{theServiceTerritory.Id},true);
        Test.stopTest();

        System.assert(resultMap.containsKey(theServiceTerritory.Id), 'The expected ServiceTerritory was not found');
        System.assertEquals(1, resultMap.get(theServiceTerritory.Id).size(), 'The getSTM method returned an unexpected number of STMs');
        System.assertEquals(serviceTerritoryMember.Id, resultMap.get(theServiceTerritory.Id)[0].Id, 'The STM\'s Territory did not match the provided Service Territory');
    }

    @IsTest
    static void testGetSTMsOnlyPrimaryByTerritory(){
        List<User> theUsers = new List<User>();
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        insert theUsers;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;
        
        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('Test Territory', theOpHours.Id);
        ServiceTerritory theServiceTerritory2 = GDMFSL_DataFactory.createServiceTerritory('Test Territory2', theOpHours.Id);
        insert new List<ServiceTerritory>{theServiceTerritory, theServiceTerritory2};        
        
        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        Schema.Location aLocation2 = GDMFSL_DataFactory.createLocation('Campus2',theServiceTerritory2.Id);
        insert new List<Schema.Location>{aLocation,aLocation2};     

        ServiceResource serviceResource = GDMFSL_DataFactory.createServiceResource(theUsers[0].Id, aLocation.Id);
        serviceResource.GDMFSL_IsContractor__c = true;
        insert serviceResource;
        
        ServiceTerritoryMember serviceTerritoryMember = GDMFSL_DataFactory.createServiceTerritoryMember(serviceResource.Id,theServiceTerritory.Id);
        serviceTerritoryMember.TerritoryType = 'P';
        ServiceTerritoryMember serviceTerritoryMember2 = GDMFSL_DataFactory.createServiceTerritoryMember(serviceResource.Id,theServiceTerritory2.Id);
        serviceTerritoryMember2.TerritoryType = 'S';
        insert new List<ServiceTerritoryMember>{serviceTerritoryMember,serviceTerritoryMember2};        

        Map<Id,List<ServiceTerritoryMember>> resultMap;

        Test.startTest();
            resultMap = GDMFSL_ServiceTerritoryProcessor.getSTMs(new Set<Id>{theServiceTerritory.Id},true);
        Test.stopTest();

        System.assertEquals(1,resultMap.keySet().size(), 'The getSTM method returned an unexpected number of results');
        System.assert(resultMap.containsKey(theServiceTerritory.Id), 'The getSTM method did not return the expected Service Territory');
        System.assertEquals(1, resultMap.get(theServiceTerritory.Id).size(), 'The getSTM method returned an unexpected number of Service Territories');
        System.assertEquals(serviceTerritoryMember.Id, resultMap.get(theServiceTerritory.Id)[0].Id, 'The getSTM method did not return the expected STM');        
    }    

    @IsTest
    static void testGetSTMsNoPrimaryByTerritory(){
        List<User> theUsers = new List<User>();
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        insert theUsers;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;
        
        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('Test Territory', theOpHours.Id);
        insert theServiceTerritory;        
        
        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;     

        ServiceResource serviceResource = GDMFSL_DataFactory.createServiceResource(theUsers[0].Id, aLocation.Id);
        serviceResource.GDMFSL_IsContractor__c = true;
        insert serviceResource;
        
        ServiceTerritoryMember serviceTerritoryMember = GDMFSL_DataFactory.createServiceTerritoryMember(serviceResource.Id,theServiceTerritory.Id);
        serviceTerritoryMember.TerritoryType = 'S';
        insert serviceTerritoryMember;        

        Map<Id,List<ServiceTerritoryMember>> resultMap;

        Test.startTest();
            resultMap = GDMFSL_ServiceTerritoryProcessor.getSTMs(new Set<Id>{theServiceTerritory.Id},true);
        Test.stopTest();

        System.assertEquals(0,resultMap.keySet().size(), 'The getSTM method unexpectedly returned results');
    }       
    
    @IsTest
    static void testGetSTMsAllowSecondaryByTerritory(){
        List<User> theUsers = new List<User>();
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        insert theUsers;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;
        
        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('Test Territory', theOpHours.Id);
        insert theServiceTerritory;        
        
        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;     

        ServiceResource serviceResource = GDMFSL_DataFactory.createServiceResource(theUsers[0].Id, aLocation.Id);
        serviceResource.GDMFSL_IsContractor__c = true;
        insert serviceResource;
        
        ServiceTerritoryMember serviceTerritoryMember = GDMFSL_DataFactory.createServiceTerritoryMember(serviceResource.Id,theServiceTerritory.Id);
        serviceTerritoryMember.TerritoryType = 'S';
        insert serviceTerritoryMember;        

        Map<Id,List<ServiceTerritoryMember>> resultMap;

        Test.startTest();
            resultMap = GDMFSL_ServiceTerritoryProcessor.getSTMs(new Set<Id>{theServiceTerritory.Id},false);
        Test.stopTest();

        System.assertEquals(1,resultMap.keySet().size(), 'The getSTM method returned an unexpected number of STMs');
        System.assert(resultMap.containsKey(theServiceTerritory.Id), 'The getSTM method returned an unexpected number of STMs');
        System.assertEquals(1, resultMap.get(theServiceTerritory.Id).size(), 'The getSTM method returned an unexpected number of STMs');
        System.assertEquals(serviceTerritoryMember.Id, resultMap.get(theServiceTerritory.Id)[0].Id, 'The getSTM method returned an unexpected number of STMs');   
    }

    @IsTest
    static void testGetOpHoursHolidayDates(){

        Holiday h = new Holiday(ActivityDate=System.today(),IsAllDay=true, IsRecurrence=false, Name='My Day');
        insert h;
        OperatingHours opHrs1;
        OperatingHours opHrs2;
        User u = GDMFSL_DataFactory.createTestUser();
        insert u;
        System.runAs(u){
            opHrs1 = GDMFSL_DataFactory.createOperatingHour();
            opHrs2 = GDMFSL_DataFactory.createOperatingHour();
            insert new List<OperatingHours>{opHrs1,opHrs2};

            OperatingHoursHoliday oHrsHoliday = new OperatingHoursHoliday(OperatingHoursId = opHrs1.Id, HolidayId = h.Id);
            insert oHrsHoliday;
        }
        Map<Id, List<Date>> resultsMap = new Map<Id, List<Date>>();

        Test.startTest();
            resultsMap = GDMFSL_ServiceTerritoryProcessor.getOpHoursHolidayDates(new Set<Id>{opHrs1.Id,opHrs2.Id});
        Test.stopTest();

        System.assertEquals(1,resultsMap.keySet().size(), 'No Dates were returned');
        System.assert(resultsMap.containsKey(opHrs1.Id), 'No Dates were found for opHrs1');
        System.assertEquals(System.today(),resultsMap.get(opHrs1.Id)[0], 'The date found did not match what wash expected');
    }

    @IsTest
    static void testGetOpHours(){
        OperatingHours opHrs1 = GDMFSL_DataFactory.createOperatingHour();
        opHrs1.GDMFSL_Holiday_Operating_Hours__c = true;
        OperatingHours opHrs2 = GDMFSL_DataFactory.createOperatingHour();
        insert new List<OperatingHours>{opHrs1,opHrs2};

        List<OperatingHours> results = new List<OperatingHours>();

        Test.startTest();
            results = GDMFSL_ServiceTerritoryProcessor.getOperatingHours(new Set<Id>{opHrs1.Id,opHrs2.Id});
        Test.stopTest();

        System.assertEquals(2,results.size(), 'getOpHoursHolidayDates found an unexpected number of Dates');
        System.assert(results[0].Id == opHrs1.Id || results[0].Id == opHrs2.Id, 'getOpHoursHolidayDates did not find the appropriate Dates for opHr1 or opHr2');
        System.assert(results[1].Id == opHrs1.Id || results[1].Id == opHrs2.Id, 'getOpHoursHolidayDates did not find the appropriate Dates for opHr1 or opHr2');
    }    

    @IsTest
    static void testUpdateRelatedServiceResources(){
        List<User> theUsers = new List<User>();
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        theUsers.add(GDMFSL_DataFactory.createTestUser());
        insert theUsers;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;
        
        ServiceTerritory theServiceTerritory = GDMFSL_DataFactory.createServiceTerritory('Test Territory', theOpHours.Id);
        insert theServiceTerritory;
        
        Schema.Location aLocation = GDMFSL_DataFactory.createLocation('Campus',theServiceTerritory.Id);
        insert aLocation;
        System.debug('TestLocation Inserted : ' + aLocation);
        
        ServiceResource theServResource = GDMFSL_DataFactory.createServiceResource(theUsers[0].Id, aLocation.Id);
        theServResource.GDMFSL_IsContractor__c = true;
        ServiceResource serviceResource2 = GDMFSL_DataFactory.createServiceResource(theUsers[1].Id, aLocation.Id);
        serviceResource2.GDMFSL_IsContractor__c = true;
        insert new List<ServiceResource>{theServResource, serviceResource2};
        
        ServiceTerritoryMember theSTM = GDMFSL_DataFactory.createServiceTerritoryMember(theServResource.Id,theServiceTerritory.Id);
        theSTM.TerritoryType = 'P';
        insert theSTM;

        Test.startTest();
            theServiceTerritory.GDMFSL_Holiday_Processing_Range_Start__c = System.today().addDays(-10);
            theServiceTerritory.GDMFSL_Holiday_Processing_Range_End__c = System.today().addDays(-1);
            update theServiceTerritory;
        Test.stopTest();

        List<ServiceResource> servResources = [SELECT id, GDMFSL_Holiday_Processing_Range_Start__c, GDMFSL_Holiday_Processing_Range_End__c FROM ServiceResource];
        System.assertEquals(2,servResources.size());

        for(ServiceResource sr : servResources){
            if(sr.Id == theServResource.Id){
                System.assertEquals(System.today().addDays(-10),sr.GDMFSL_Holiday_Processing_Range_Start__c, 'The expected holiday processing start was incorrect');
                System.assertEquals(System.today().addDays(-1),sr.GDMFSL_Holiday_Processing_Range_End__c, 'The expected holiday processing end was incorrect');
            } else {
                System.assertEquals(null,sr.GDMFSL_Holiday_Processing_Range_Start__c, 'Unexpectedly found a holiday processing start value');
                System.assertEquals(null,sr.GDMFSL_Holiday_Processing_Range_End__c, 'Unexpectedly found a holiday processing end value');
            }
        }
    }
}