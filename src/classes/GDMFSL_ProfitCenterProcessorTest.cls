@IsTest
private class GDMFSL_ProfitCenterProcessorTest {

    @TestSetup
    static void init() {

        Account theAccount = GDMFSL_DataFactory.createTestAccount('TestAcc');
        insert theAccount;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;

        List<ServiceTerritory> stToInsert = new List<ServiceTerritory>();
        stToInsert.add(GDMFSL_DataFactory.createServiceTerritory('ProfCtr Test', theOpHours.Id));
        stToInsert.add(GDMFSL_DataFactory.createServiceTerritory('ProfCtr Test2', theOpHours.Id));
        insert stToInsert;
    }

    @IsTest
    static void getRecordsTest() {

        List<ServiceTerritory> servTerrs = new List<ServiceTerritory>([SELECT Id FROM ServiceTerritory LIMIT 2]);

        List<GDMFSL_Discipline__c> theDisciplinesToInsert = new List<GDMFSL_Discipline__c>();

        theDisciplinesToInsert.add(GDMFSL_DataFactory.createDiscipline('Test'));
        theDisciplinesToInsert.add(GDMFSL_DataFactory.createDiscipline('Test2'));
        insert theDisciplinesToInsert;

        List<GDMFSL_Profit_Center__c> thePCtrsToInsert = new List<GDMFSL_Profit_Center__c>();

        thePCtrsToInsert.add(GDMFSL_DataFactory.createProfitCenter('Test', servTerrs[0].Id, theDisciplinesToInsert[0].Id, 'ZYXW'));
        thePCtrsToInsert.add(GDMFSL_DataFactory.createProfitCenter('Test2', servTerrs[1].Id, theDisciplinesToInsert[1].Id, 'ZYXWZ'));
        insert thePCtrsToInsert;

        Map<Id, Map<Id, GDMFSL_Profit_Center__c>> foundRecs = GDMFSL_ProfitCenterProcessor.getRecords(new Set<Id>{servTerrs[0].Id});

        System.assertEquals(1, foundRecs.size(), 'getRecords() did not return the right number of ServiceTerritory Ids');
        System.assertEquals(1, foundRecs.get(servTerrs[0].Id).size(), 'getRecords() did not return the right number of ProfitCenter records for the ServiceTerritory');
        System.assertEquals(servTerrs[0].Id, foundRecs.get(servTerrs[0].Id).get(theDisciplinesToInsert[0].Id).GDMFSL_Service_Territory__c, 'getRecords() did not return the right ProfitCenter record for the ServiceTerritory / Discipline combination');
        System.assertEquals(thePCtrsToInsert[0].Id, foundRecs.get(servTerrs[0].Id).get(theDisciplinesToInsert[0].Id).Id, 'getRecords() did not return the right ProfitCenter record for the ServiceTerritory / Discipline');

        System.debug('Now testing that additional ProfitCenter are also retrieved');

        foundRecs = GDMFSL_ProfitCenterProcessor.getRecords(new Set<Id>{servTerrs[1].Id});

        System.assertEquals(2, foundRecs.size(), 'getRecords() did not return the right number of ServiceTerritory Ids on subsequent call');
        System.assertEquals(1, foundRecs.get(servTerrs[1].Id).size(), 'getRecords() did not return the right number of ProfitCenter records for the ServiceTerritory on subsequent call');
        System.assertEquals(servTerrs[1].Id, foundRecs.get(servTerrs[1].Id).get(theDisciplinesToInsert[1].Id).GDMFSL_Service_Territory__c, 'getRecords() did not return the right ProfitCenter record for the ServiceTerritory / Discipline combination on subsequent call');
        System.assertEquals(thePCtrsToInsert[1].Id, foundRecs.get(servTerrs[1].Id).get(theDisciplinesToInsert[1].Id).Id, 'getRecords() did not return the right ProfitCenter record for the ServiceTerritory / Discipline on the subsequent call');

    }

}