@IsTest(IsParallel=true)
private class GDMFSL_AccountProcessorTest {

    @IsTest
    static void getRecordsTest() {

        List<Account> actsToAdd = new List<Account>();
        actsToAdd.add(GDMFSL_DataFactory.createTestAccount('Test 1'));
        actsToAdd.add(GDMFSL_DataFactory.createTestAccount('Test 2'));

        insert actsToAdd;

        List<ServiceAppointment> sasToAdd = new List<ServiceAppointment>();
        sasToAdd.add(GDMFSL_DataFactory.createServiceAppointment(actsToAdd[0].Id, 'Active'));
        sasToAdd.add(GDMFSL_DataFactory.createServiceAppointment(actsToAdd[1].Id, 'Active'));

        insert sasToAdd;

        Map<Id, Account> theAccounts = GDMFSL_AccountProcessor.getRecords(new Set<Id>{actsToAdd[0].Id});

        System.assertEquals(1, theAccounts.size(), 'getRecords() did not return any Accounts');
        System.assertEquals(actsToAdd[0].Id, theAccounts.get(actsToAdd[0].Id).Id, 'getRecords() did not return the right account');
        System.assertNotEquals(null, theAccounts.get(actsToAdd[0].Id).ServiceAppointmentAccount, 'getRecords() did not return related ServiceAppointmentAccount records');

        theAccounts = GDMFSL_AccountProcessor.getRecords(new Set<Id>{actsToAdd[1].Id});

        System.assertEquals(2, theAccounts.size(), 'getRecords() did not return the correct number of Accounts on subsequent call');
        System.assertEquals(actsToAdd[0].Id, theAccounts.get(actsToAdd[0].Id).Id, 'getRecords() did not return the first requested account on subsequent call');
        System.assertEquals(actsToAdd[1].Id, theAccounts.get(actsToAdd[1].Id).Id, 'getRecords() did not return the second requested account on subsequent call');

    }
}