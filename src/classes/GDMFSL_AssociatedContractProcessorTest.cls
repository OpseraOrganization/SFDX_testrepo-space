/*******************************************************************************************
Name       :    GDMFSL_AssociatedContractProcessorTest
Purpose    :    Test class for GDMFSL_AssociatedContractProcessor.
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Sep-14    Created
Varun Misra.            2021-May-07.   Updated
**********************************************************************************************/

@IsTest
private class GDMFSL_AssociatedContractProcessorTest {

    @IsTest
    static void getRecordsTest() {

        Account ac = GDMFSL_DataFactory.createTestAccount('TestAccount');
        insert ac;

        ServiceContract sc = GDMFSL_DataFactory.createServiceContract('TestServiceContract', ac.Id);
        insert sc;

        OperatingHours theOpHours = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHours;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('AC Test', theOpHours.Id);
        insert st;

        Schema.Location loc = GDMFSL_DataFactory.createLocation('Campus', st.Id, theOpHours.Id);
        Schema.Location loc1 = GDMFSL_DataFactory.createLocation('Campus', null, theOpHours.Id);
        List<Schema.Location > lstlocation = new List<Schema.Location >();
        lstlocation.add(loc);
        lstlocation.add(loc1);
        insert lstlocation;

        GDMFSL_Associated_Contract__c theAsssocContract = GDMFSL_DataFactory.createAssociatedContract(lstlocation[0].Id, sc.Id, 30);
        insert theAsssocContract;

        Set<Id> locationIds = new Set<Id>();
        Set<Id> contractIds = new Set<Id>();
        for (Schema.Location thisLoc : lstlocation) {
            locationIds.add(thisLoc.Id);
        }
        contractIds.add(sc.Id);

        Map<Id, GDMFSL_Associated_Contract__c> mapAC = GDMFSL_AssociatedContractProcessor.getRecords(contractIds, locationIds);
        System.assertEquals(1, mapAC.size(), 'Only 1 associated contract was expected for this location and service contract');

        System.debug('Now testing that additional Associated Contract are retrieved');

        Set<Id> prevServContractIds = new Set<Id>();
        ServiceContract theOthersc = GDMFSL_DataFactory.createServiceContract('Sample ServiceContract', ac.Id);
        insert theOthersc;
        prevServContractIds.add(theOthersc.id);

        Set<Id> prevLocationIds = new Set<Id>();
        Schema.Location theOtherLocation = GDMFSL_DataFactory.createLocation('Sample Campus', null, theOpHours.Id);
        insert theOtherLocation;
        prevLocationIds.add(theOtherLocation.id);

        GDMFSL_Associated_Contract__c otherassociatedcontract = GDMFSL_DataFactory.createAssociatedContract(theOtherLocation.Id, theOthersc.Id, 30);
        insert otherassociatedcontract;

        System.debug('TEST: start');

        Map<Id, GDMFSL_Associated_Contract__c> theOthermapAC = GDMFSL_AssociatedContractProcessor.getRecords(prevServContractIds, prevLocationIds);
        System.assertEquals(2, theOthermapAC.size(), 'Wrong  associated contract records for this location and service contract found');

        System.debug('TEST: stop');


    }

}