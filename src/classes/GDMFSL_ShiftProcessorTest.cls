/**
 * @description       : 
 * @author            : Bryant Daniels
 * @group             : 
 * @last modified on  : 01-25-2021
 * @last modified by  : Bryant Daniels
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   01-25-2021   Bryant Daniels   Initial Version
**/
@IsTest
private class GDMFSL_ShiftProcessorTest {

    @TestSetup
    static void init() {

        Skip_Automation_Process__c automationprocess = GDMFSL_DataFactory.createProfileCustomSetting(false);
        insert automationprocess;
        System.debug('Automation Process Inserted : ' + automationprocess);

        OperatingHours operatingHours = GDMFSL_DataFactory.createOperatingHour();
        insert operatingHours;
        System.debug('operatingHours  Inserted : ' + operatingHours);

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('Shift Test', operatingHours.Id);
        insert st;
        System.debug('ServiceTerritory Inserted : ' + st);

        Schema.Location location = GDMFSL_DataFactory.createLocation('Campus', st.Id, operatingHours.Id);
        Schema.Location location1 = GDMFSL_DataFactory.createLocation('Campus', null, operatingHours.Id);
        List<Schema.Location > lstlocation = new List<Schema.Location >();
        lstlocation.add(location);
        lstlocation.add(location1);
        insert lstlocation;
        System.debug('location Inserted : ' + location);

        Schema.Address address = GDMFSL_DataFactory.createAddress('169 SpruceTree Lane', 'Ballwin', 'Missouri', '63021', 'United States', lstlocation[0].Id);
        List<Schema.Address> lstaddress = new List<Schema.Address>();
        lstaddress.add(address);
        insert lstaddress;
        System.debug('address Inserted : ' + address);

        User testUser = GDMFSL_DataFactory.createTestUser();
        insert testUser;
        System.debug('User Inserted : ' + testUser);

        ServiceResource sr = GDMFSL_DataFactory.createServiceResource(testUser.Id, lstlocation[0].Id);
        insert sr;
        System.debug('ServiceResource Inserted : ' + sr);

        User testUser2 = GDMFSL_DataFactory.createTestUser();
        testUser2.Username = testUser2.Username + '2';
        testUser2.LastName = 'SecondUser';
        insert testUser2;
        System.debug('User2 Inserted : ' + testUser2);

        ServiceResource sr2 = GDMFSL_DataFactory.createServiceResource(testUser2.Id, lstlocation[1].Id);
        insert sr2;
        System.debug('ServiceResource Inserted : ' + sr2);

        List<Shift> shifts = GDMFSL_DataFactory.createShift(1);
        insert shifts;


    }

    @IsTest
    static void testAssignShiftOwner() {
        Test.startTest();
        User u = [SELECT Id, Name FROM User WHERE LastName = 'Testing' LIMIT 1];
        ServiceResource sr = [SELECT Id, RelatedRecord.Id FROM ServiceResource WHERE Name = 'TestUserSR' LIMIT 1];
        System.debug('User' + u);
        System.debug('Service Resource ' + sr);
        System.runAs(u) {
            List<Shift> shifts = GDMFSL_DataFactory.createShift(1);
            shifts[0].ServiceResourceId = sr.Id;
            shifts[0].Label = 'My shift';
            insert shifts;
        }
        Test.stopTest();

        List<Shift> sh = [SELECT Id, OwnerId FROM Shift where Label = 'My shift'];
        System.assertEquals(sr.RelatedRecord.Id, sh[0].OwnerId, 'Shift Owner Is InCorrect');
    }

    @IsTest
    static void testAssignInactiveShiftOwner() {
        Test.startTest();
        List<User> uList = [SELECT Id, Name FROM User WHERE LastName = 'Testing' OR LastName = 'SecondUser'];
        uList[0].IsActive = false;
        update uList;
        System.runAs(uList[1]) {
            ServiceResource sr = [SELECT Id, RelatedRecord.Id FROM ServiceResource WHERE RelatedRecord.IsActive = FALSE LIMIT 1];
            List<Shift> shifts = GDMFSL_DataFactory.createShift(1);
            shifts[0].ServiceResourceId = sr.Id;
            shifts[0].Label ='test shift 1';
            insert shifts;
            List<Shift> sh = [SELECT Id, OwnerId FROM Shift where Label = 'test shift 1'];
            System.assert(sh[0].OwnerId != sr.RelatedRecord.Id, 'Shift Owner was set to Service Resource Related Record');
        }
        Test.stopTest();

    }

    @IsTest
    static void testUpdateShiftOwner() {
        User u = [SELECT Id, Name FROM User WHERE LastName = 'Testing' LIMIT 1];
        Test.startTest();
        List<ServiceResource> srList = [SELECT Id, RelatedRecord.Id FROM ServiceResource];
        List<Shift> shifts = GDMFSL_DataFactory.createShift(1);
        shifts[0].Label ='my shift';
        System.runAs(u) {
            shifts[0].ServiceResourceId = srList[0].Id;
            insert shifts;

        }
        Test.stopTest();
        shifts[0].ServiceResourceId = srList[1].Id;
        update shifts;

        List<Shift> sh = [SELECT Id, OwnerId FROM Shift where Label = 'my shift'];
        System.assertEquals(sh[0].OwnerId, srList[1].RelatedRecord.Id, 'Shift Owner Is InCorrect');
    }

    @IsTest
    Static void UpdateShift()
    {
        shift s = [Select id, StartTime, EndTime from Shift limit  1];

        s.StartTime = Datetime.now() + 1;
        update s;



    }
}