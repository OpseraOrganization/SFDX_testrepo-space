@IsTest(IsParallel=true)
private class GDMFSL_AgreementLevelProcessorTest {

    @TestSetup
    static void init() {
        GDMFSL_Agreement_Level__c agreementLevel = GDMFSL_DataFactory.createAgreementLevel('ALE1');
        System.debug('Agreement Level Inserted : ' + agreementLevel);
        insert agreementLevel;
    }


    @IsTest
    static void testGetRecords() {

        Set<Id> ALIds = new Set<Id>();
        Map<Id, GDMFSL_Agreement_Level__c> mapAL = new Map<Id, GDMFSL_Agreement_Level__c>();

        List<GDMFSL_Agreement_Level__c> agreementlevels = [SELECT Id FROM GDMFSL_Agreement_Level__c];
        ALIds.add(agreementlevels[0].Id);

        mapAL = GDMFSL_AgreementLevelProcessor.getRecords(ALIds);
        System.assertEquals(1, mapAL.size(), 'The Maps Count has more than the expected records');
        System.assert(mapAL.containsKey(agreementlevels[0].Id), 'The Id of Agreement Level in the Set is not correct to the one it was supposed to fetch');

        GDMFSL_Agreement_Level__c agreementLevel2 = GDMFSL_DataFactory.createAgreementLevel('ALE2');
        System.debug('Agreement Level Inserted : ' + agreementLevel2);
        insert agreementLevel2;
        ALIds.add(agreementLevel2.Id);

        mapAL = GDMFSL_AgreementLevelProcessor.getRecords(ALIds);
        System.assertEquals(2, mapAL.size(), 'The map retrieved did not bring the Agreement Level from Get Records');
        for (Id ssId : mapAL.keySet()) {
            System.assert(ALIds.contains(ssId), 'Wrong record in Set');
        }

    }
}