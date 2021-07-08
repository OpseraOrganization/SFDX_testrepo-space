/**
 * Name       :    GDMFSL_ContractLineItemProcessorTest
 * Purpose    :    Test class for GDMFSL_ContractLineItemProcessor.
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Varun Misra.            4/30/2021     Test class for GDMFSL_ContractLineItemProcessorTest.
 **/

@IsTest
private class GDMFSL_ContractLineItemProcessorTest {

    @IsTest
    static void triggerTest() {


        Account acct = GDMFSL_DataFactory.createTestAccount('Test Account');
        insert acct;

        List<Product2> lstproduct = GDMFSL_DataFactory.createProducts('TestProduct', 1);
        insert lstproduct;

        List<Asset> thisAsset = GDMFSL_DataFactory.createAssets('Test Asset', lstproduct[0].Id, acct.Id, 1);
        insert thisAsset;

        Set<Id> assetIds = new Set<Id>();
        assetIds.add(thisAsset[0].Id);

        ServiceContract sc = GDMFSL_DataFactory.createServiceContract('TestServiceContract', acct.Id);
        insert sc;

        Set<Id> serviceContractIds = new Set<Id>();
        serviceContractIds.add(sc.Id);

        Pricebook2 PriceBook = GDMFSL_DataFactory.createPriceBook('TestPriceBook');
        insert PriceBook;

        PricebookEntry pricebookentry = GDMFSL_DataFactory.createPriceBookEntry(lstproduct[0].Id);
        insert pricebookentry;

        PricebookEntry pricebookentryCustom = GDMFSL_DataFactory.createPriceBookEntry(lstproduct[0].Id);
        pricebookentryCustom.Pricebook2Id = PriceBook.Id;
        insert pricebookentryCustom;

        sc.Pricebook2Id = PriceBook.Id;
        update sc;

        ContractLineItem theCLI = GDMFSL_DataFactory.createCLI(sc.Id, pricebookentryCustom.Id);
        theCLI.Quantity = 10;
        insert theCLI;

        System.assertEquals(sc.Id, theCLI.ServiceContractId, 'CLI Service contractID is not set correctly');
        System.assertEquals(pricebookentryCustom.Id, theCLI.PricebookEntryId, 'CLI PriceBookEntry is not set correctly');

    }

    @IsTest
    static void updateCLIfromSCTest() {

        Date startDate = Date.newInstance(2021, 5, 15);
        Date endDate = Date.newInstance(2021, 9, 16);

        Account acct = GDMFSL_DataFactory.createTestAccount('Test Account');
        insert acct;

        List<Product2> lstproduct = GDMFSL_DataFactory.createProducts('TestProduct', 1);
        insert lstproduct;

        List<Asset> thisAsset = GDMFSL_DataFactory.createAssets('Test Asset', lstproduct[0].Id, acct.Id, 1);
        insert thisAsset;

        ServiceContract sc = GDMFSL_DataFactory.createServiceContract('TestServiceContract', acct.Id);
        sc.EndDate = endDate;
        sc.StartDate = startDate;
        insert sc;

        Map<Id, ServiceContract> serviceContractIds = new Map<Id, ServiceContract>();
        serviceContractIds.put(sc.Id, sc);

        Pricebook2 PriceBook = GDMFSL_DataFactory.createPriceBook('TestPriceBook');
        insert PriceBook;

        PricebookEntry pricebookentry = GDMFSL_DataFactory.createPriceBookEntry(lstproduct[0].Id);
        insert pricebookentry;

        PricebookEntry pricebookentryCustom = GDMFSL_DataFactory.createPriceBookEntry(lstproduct[0].Id);
        pricebookentryCustom.Pricebook2Id = PriceBook.Id;
        insert pricebookentryCustom;

        sc.Pricebook2Id = PriceBook.Id;
        update sc;

        ContractLineItem theCLI = GDMFSL_DataFactory.createCLI(sc.Id, pricebookentryCustom.Id);
        theCLI.Quantity = 10;
        theCLI.StartDate = startDate;

        insert theCLI;

        System.debug('TEST: start');

        Test.startTest();

        GDMFSL_ContractLineItemProcessor.updateCLIfromSC(serviceContractIds);

        Test.stopTest();


        for (ContractLineItem thisCLI : [SELECT Id, EndDate FROM ContractLineItem WHERE ServiceContractId IN :serviceContractIds.keySet()]){
            System.assertEquals(sc.EndDate, thisCLI.EndDate, 'updateCLIfromSC() did not set the CLI EndDate correctly');
        }

    }

    @IsTest
    static void getRecordsTest() {

        Account acct = GDMFSL_DataFactory.createTestAccount('Test Account');
        insert acct;

        List<Product2> lstproduct = GDMFSL_DataFactory.createProducts('TestProduct', 1);
        insert lstproduct;

        List<Asset> theAssets = GDMFSL_DataFactory.createAssets('Test Asset', lstproduct[0].Id, acct.Id, 2 );
        insert theAssets;

        Set<Id> assetIds = new Set<Id>();
        assetIds.add(theAssets[0].Id);

        List<ServiceContract> theSCs = new List<ServiceContract>();
        theSCs.add(GDMFSL_DataFactory.createServiceContract('TestServiceContract', acct.Id));
        theSCs.add(GDMFSL_DataFactory.createServiceContract('TestServiceContract2', acct.Id));
        insert theSCs;

        Set<Id> serviceContractIds = new Set<Id>();
        serviceContractIds.add(theSCs[0].Id);

        Pricebook2 PriceBook = GDMFSL_DataFactory.createPriceBook('TestPriceBook');
        insert PriceBook;

        PricebookEntry pricebookentry = GDMFSL_DataFactory.createPriceBookEntry(lstproduct[0].Id);
        insert pricebookentry;

        PricebookEntry pricebookentryCustom = GDMFSL_DataFactory.createPriceBookEntry(lstproduct[0].Id);
        pricebookentryCustom.Pricebook2Id = PriceBook.Id;
        insert pricebookentryCustom;

        theSCs[0].Pricebook2Id = PriceBook.Id;
        theSCs[1].Pricebook2Id = PriceBook.Id;
        update theSCs;

        List<ContractLineItem> theCLIs = new List<ContractLineItem>();

        ContractLineItem theCLI = GDMFSL_DataFactory.createCLI(theSCs[0].Id, pricebookentryCustom.Id);
        theCLI.Quantity = 10;
        theCLI.AssetId = theAssets[0].Id;
        theCLIs.add(theCLI);

        ContractLineItem theCLI2 = GDMFSL_DataFactory.createCLI(theSCs[1].Id, pricebookentryCustom.Id);
        theCLI2.Quantity = 10;
        theCLI2.AssetId = theAssets[1].Id;
        theCLIs.add(theCLI2);

        insert theCLIs;

        List<ContractLineItem> clisWeCreated = new List<ContractLineItem>([SELECT Id, AssetId, ServiceContractId FROM ContractLineItem WHERE Id IN :theCLIs]);

        Test.startTest();

        Map<Id, Map<Id, List<ContractLineItem>>> assetIdToCLIs = GDMFSL_ContractLineItemProcessor.getRecords(serviceContractIds, assetIds);

        System.assertEquals(1, assetIdToCLIs.size(), 'getRecords() did not return the right number of keys');
        System.assertEquals(theAssets[0].Id, assetIdToCLIs.get(theSCs[0].Id).get(theAssets[0].Id)[0].AssetId, 'getRecords() did not return the right CLIs');

        serviceContractIds.clear();
        serviceContractIds.add(theSCs[1].Id);

        assetIds.clear();
        assetIds.add(theAssets[1].Id);

        assetIdToCLIs = GDMFSL_ContractLineItemProcessor.getRecords(serviceContractIds, assetIds);

        System.assertEquals(1, assetIdToCLIs.size(), 'getRecords() did not return the right number of keys on subsequent call');
        System.assertEquals(theAssets[1].Id, assetIdToCLIs.get(theSCs[1].Id).get(theAssets[1].Id)[0].AssetId, 'getRecords() did not return the right CLIs on subsequent call');

        Test.stopTest();

    }

}