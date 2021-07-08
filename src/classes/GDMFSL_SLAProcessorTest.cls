/*******************************************************************************************
Name       :    GDMFSL_SLAProcessorTest
Purpose    :    Test class for GDMFSL_SLAProcessor.
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Sep-14    Created
**********************************************************************************************/
@IsTest
private class GDMFSL_SLAProcessorTest {

    @IsTest
    static void getRecordsTest() {

        Account ac = GDMFSL_DataFactory.createTestAccount('TestAccount');
        insert ac;

        ServiceContract sc = GDMFSL_DataFactory.createServiceContract('TestServiceContract', ac.Id);
        insert sc;


        OperatingHours theOpHrs = GDMFSL_DataFactory.createOperatingHour();
        insert theOpHrs;

        ServiceTerritory st = GDMFSL_DataFactory.createServiceTerritory('SLA Test', theOpHrs.Id);
        insert st;

        Schema.Location theLoc = GDMFSL_DataFactory.createLocation('Campus', st.Id, theOpHrs.Id);
        Schema.Location location1 = GDMFSL_DataFactory.createLocation('Campus', null, theOpHrs.Id);
        List<Schema.Location > lstlocation = new List<Schema.Location >();
        lstlocation.add(theLoc);
        lstlocation.add(location1);
        insert lstlocation;

        GDMFSL_Associated_Contract__c theAssocCont = GDMFSL_DataFactory.createAssociatedContract(lstlocation[0].Id, sc.Id, 30);
        insert theAssocCont;

        List<Product2> lstproduct = GDMFSL_DataFactory.createProducts('TestProduct', 1);
        insert lstproduct;

        GDMFSL_SLA__c theSLAForAssocCont = GDMFSL_DataFactory.createSLAforAssociatedContract(theAssocCont.Id, 'High', 10, 5, 24);
        insert theSLAForAssocCont;

        Pricebook2 thePriceBook = GDMFSL_DataFactory.createPriceBook('TestPriceBook');
        insert thePriceBook;

        List<PricebookEntry> pbesToInsert = new List<PricebookEntry>();

        PricebookEntry thePBE = GDMFSL_DataFactory.createPriceBookEntry(lstproduct[0].Id);
        pbesToInsert.add(thePBE);

        PricebookEntry theCustomPBE = GDMFSL_DataFactory.createPriceBookEntry(lstproduct[0].Id);
        theCustomPBE.Pricebook2Id = thePriceBook.Id;
        pbesToInsert.add(theCustomPBE);

        insert pbesToInsert;

        sc.Pricebook2Id = thePriceBook.Id;
        update sc;

        ContractLineItem theCLI = GDMFSL_DataFactory.createCLI(sc.Id, theCustomPBE.Id);
        theCLI.Quantity = 10;
        insert theCLI;

        GDMFSL_SLA__c SLAForCLI = GDMFSL_DataFactory.createSLAforCLI(theCLI.Id, 'Medium', 20, 10, 20);
        insert SLAForCLI;

        Test.startTest();

        List<GDMFSL_SLA__c> lstSLAForAssocContracts = new List<GDMFSL_SLA__c>([SELECT Id FROM GDMFSL_SLA__c WHERE GDMFSL_Associated_Contract__c = :theAssocCont.Id]);

        Map<Id, List<GDMFSL_SLA__c>> parentIDToSLAs = GDMFSL_SLAProcessor.getRecords(new Set<Id>{theAssocCont.Id}, GDMFSL_Associated_Contract__c.getSObjectType());

        System.assertEquals(1, parentIDToSLAs.size(), 'getRecords() returned the wrong number of parent record AssocContract ID');
        System.assertEquals(lstSLAForAssocContracts.size(), parentIDToSLAs.get(theAssocCont.Id).size(),'getRecords() returned the wrong number of SLAs for the parent record AssocContract ID');
        System.assertEquals(theAssocCont.Id, parentIDToSLAs.get(theAssocCont.Id)[0].GDMFSL_Associated_Contract__c, 'getRecords() returned SLAs that are not related to the parent record AssocContract ID');


        List<GDMFSL_SLA__c> lstSLAForCLIs = new List<GDMFSL_SLA__c>([SELECT Id FROM GDMFSL_SLA__c WHERE GDMFSL_Contract_Line_Item__c = :theCLI.Id]);

        parentIDToSLAs = GDMFSL_SLAProcessor.getRecords(new Set<Id>{theCLI.Id}, ContractLineItem.getSObjectType());

        System.assertEquals(2, parentIDToSLAs.size(), 'getRecords() returned the wrong number of parent records on subsequent call');
        System.assertEquals(lstSLAForAssocContracts.size(), parentIDToSLAs.get(theAssocCont.Id).size(),'getRecords() returned the wrong number of SLAs for the parent record AssocContract ID on subsequent call');
        System.assertEquals(theAssocCont.Id, parentIDToSLAs.get(theAssocCont.Id)[0].GDMFSL_Associated_Contract__c,'getRecords() returned SLAs that are not related to the parent record AssocContract ID on subsequent call');

        System.assertEquals(lstSLAForCLIs.size(), parentIDToSLAs.get(theCLI.Id).size(),'getRecords() returned the wrong number of SLAs for the parent record CLI ID');
        System.assertEquals(theCLI.Id, parentIDToSLAs.get(theCLI.Id)[0].GDMFSL_Contract_Line_Item__c,'getRecords() returned SLAs that are not related to the parent record CLI ID');

        Test.stopTest();
    }
}