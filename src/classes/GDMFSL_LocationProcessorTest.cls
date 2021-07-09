/*******************************************************************************************
Name       :    GDMFSL_LocationProcessorTest
Purpose    :    Test class for GDMFSL_LocationProcessor.
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Sep-14    Created
**********************************************************************************************/

@IsTest
private class GDMFSL_LocationProcessorTest {

    @IsTest
    static void getRecordsTest() {

        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;
        System.debug('operatingHours  Inserted : ' + operatingHours);

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('Loc Test', operatingHours.Id);
        insert st;
        System.debug('ServiceTerritory Inserted : ' + st);

        Schema.Location location = GDMFSL_DataFactory.createLocation('Campus', st.Id, operatingHours.Id);
        Schema.Location location1 = GDMFSL_DataFactory.createLocation('Campus', null, operatingHours.Id);

        List<Schema.Location> lstlocation = new List<Schema.Location >();
        lstlocation.add(location);
        lstlocation.add(location1);
        insert lstlocation;

        System.debug('location Inserted : ' + location);

        Set<Id> locationIds = new Set<Id>();

        for (Schema.Location loc : lstlocation) {
            locationIds.add(loc.Id);
        }

        Test.startTest();

        Map<Id, Schema.Location> maplocation = GDMFSL_LocationProcessor.getRecords(locationIds);

        System.assertEquals(2, maplocation.size(), 'Wrong number of Location Records returned');

        Schema.Location location3 = GDMFSL_DataFactory.createLocation('Building', st.Id, operatingHours.Id);
        List<Schema.Location> newLocation = new List<schema.Location>();
        newLocation.add(location3);
        insert newLocation;

        lstlocation.addAll(newLocation);

        for (Schema.Location loc : lstlocation) {
            if (!locationIds.contains(loc.Id)) {
                locationIds.add(loc.Id);
            }
        }

        Test.stopTest();

        Map<Id, Schema.Location> maplocation1 = GDMFSL_LocationProcessor.getRecords(locationIds);

        System.assertEquals(3, maplocation1.size(), 'Wrong number of Location Records returned for added IDs');

    }

    @IsTest
    private static void locationShareBatchTest(){

        Account theAcct = GDMFSL_DataFactory.createTestAccount('Test');
        theAcct.Source_System_Types__c = 'ShipTo';
        insert theAcct;


        Contact theContact = GDMFSL_DataFactory.createTestContact(theAcct.Id);
        insert theContact;


        Profile commProfile = [SELECT Id FROM Profile WHERE Name = :GDMFSL_LocationTriggerHandler.COMMUNPROFILENAME LIMIT 1];

        User commUser = new User(ContactId = theContact.Id,
                ProfileId = commProfile.Id,
                Alias = 'commUser', Email='commUserZasdaf@asdrte.com',
                EmailEncodingKey='UTF-8',
                LastName='Testing',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Los_Angeles',
                Username='commUserZasdaf@asdrte.com',
                IsActive = true);
        insert commUser;

        OperatingHours theOpHrs = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHrs;

        ServiceTerritory theServTerr = GDMFSL_DataFactory.createServiceTerritory('Loc Test', theOpHrs.Id);
        insert theServTerr;

        Schema.Location theLoc = GDMFSL_DataFactory.createLocation('Building', theServTerr.Id, theOpHrs.Id);
        theLoc.GDMFSL_Ship_To_Account__c = theAcct.Id;
        insert theLoc;

        Test.startTest();

        System.debug('TEST: start');

        GDMFSL_LocationShare_Batch obj = new GDMFSL_LocationShare_Batch();
        obj.queryString = 'SELECT AccountId, ContactId, Id, IsActive FROM AccountContactRelation where CreatedDate = TODAY LIMIT 1';
        Database.executeBatch(obj);

        Test.stopTest();

        List<LocationShare> theLocShares = new List<LocationShare>([SELECT Id, AccessLevel FROM LocationShare WHERE UserOrGroupId = :commUser.Id AND ParentId = :theLoc.Id]);

        System.assertEquals(1, theLocShares.size(), 'Incorrect number of LocationShares created');
        System.assertEquals('Read', theLocShares[0].AccessLevel,'LocationShare AccessLevel is incorrect');

    }

    @IsTest
    private static void locationUpdateTest(){

        Account theAcct = GDMFSL_DataFactory.createTestAccount('Test');
        theAcct.Source_System_Types__c = 'ShipTo';
        insert theAcct;


        Contact theContact = GDMFSL_DataFactory.createTestContact(theAcct.Id);
        insert theContact;


        Profile commProfile = [SELECT Id FROM Profile WHERE Name = :GDMFSL_LocationTriggerHandler.COMMUNPROFILENAME LIMIT 1];

        User commUser = new User(ContactId = theContact.Id,
                ProfileId = commProfile.Id,
                Alias = 'commUser', Email='commUserZasdaf@asdrte.com',
                EmailEncodingKey='UTF-8',
                LastName='Testing',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Los_Angeles',
                Username='commUserZasdaf@asdrte.com',
                IsActive = true);
        insert commUser;

        OperatingHours theOpHrs = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHrs;

        ServiceTerritory theServTerr = GDMFSL_DataFactory.createServiceTerritory('Loc Test', theOpHrs.Id);
        insert theServTerr;

        Schema.Location theLoc = GDMFSL_DataFactory.createLocation('Building', theServTerr.Id, theOpHrs.Id);
        theLoc.GDMFSL_Ship_To_Account__c = theAcct.Id;
        insert theLoc;

        Account theOtherAcct = GDMFSL_DataFactory.createTestAccount('Test2');
        theOtherAcct.Source_System_Types__c = 'ShipTo';
        insert theOtherAcct;

        Test.startTest();

        System.debug('TEST: start');

        theLoc.GDMFSL_Ship_To_Account__c = theOtherAcct.Id;
        update theLoc;

        Test.stopTest();

        List<LocationShare> theLocShares = new List<LocationShare>([SELECT Id, AccessLevel FROM LocationShare WHERE UserOrGroupId = :commUser.Id AND ParentId = :theLoc.Id]);

        System.assertEquals(0, theLocShares.size(), 'LocationShares were not deleted');

    }

    @IsTest
    private static void locationShareSchedulableTest(){

        Account theAcct = GDMFSL_DataFactory.createTestAccount('Test');
        theAcct.Source_System_Types__c = 'ShipTo';
        insert theAcct;


        Contact theContact = GDMFSL_DataFactory.createTestContact(theAcct.Id);
        insert theContact;


        Profile commProfile = [SELECT Id FROM Profile WHERE Name = :GDMFSL_LocationTriggerHandler.COMMUNPROFILENAME LIMIT 1];

        User commUser = new User(ContactId = theContact.Id,
                ProfileId = commProfile.Id,
                Alias = 'commUser', Email='commUserZasdaf@asdrte.com',
                EmailEncodingKey='UTF-8',
                LastName='Testing',
                LanguageLocaleKey='en_US',
                LocaleSidKey='en_US',
                TimeZoneSidKey='America/Los_Angeles',
                Username='commUserZasdaf@asdrte.com',
                IsActive = true);
        insert commUser;

        OperatingHours theOpHrs = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHrs;

        ServiceTerritory theServTerr = GDMFSL_DataFactory.createServiceTerritory('Loc Test', theOpHrs.Id);
        insert theServTerr;

        Schema.Location theLoc = GDMFSL_DataFactory.createLocation('Building', theServTerr.Id, theOpHrs.Id);
        theLoc.GDMFSL_Ship_To_Account__c = theAcct.Id;
        insert theLoc;

        Test.startTest();

        System.debug('TEST: start');

        GDMFSL_LocationShare_Batch obj = new GDMFSL_LocationShare_Batch();
        obj.queryString = 'SELECT AccountId, ContactId, Id, IsActive FROM AccountContactRelation where CreatedDate = TODAY LIMIT 1';
        system.schedule('Location Sched', '0 0 23 * * ?', obj);
        Test.stopTest();

        List<LocationShare> theLocShares = new List<LocationShare>([SELECT Id, AccessLevel FROM LocationShare WHERE UserOrGroupId = :commUser.Id AND ParentId = :theLoc.Id]);

        System.assertEquals(1, theLocShares.size(), 'Incorrect number of LocationShares created');
        System.assertEquals('Read', theLocShares[0].AccessLevel,'LocationShare AccessLevel is incorrect');

    }

}