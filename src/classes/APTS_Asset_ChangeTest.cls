@isTest
public class APTS_Asset_ChangeTest {
    @isTest
    public static void testInsert() {
        Account account = TestDataFactory.createAccount();
        Apttus_Config2__AssetLineItem__c assetLineItem = new Apttus_Config2__AssetLineItem__c(
            Name = 'Test Asset Line Item'+TestDataFactory.generateRandomString(3),
            Apttus_Config2__ShipToAccountId__c = account.id,
            APTS_ISV_Impact__c = 'Yes',
            Apttus_Config2__AssetStatus__c = 'Activated',
            Apttus_Config2__NetPrice__c = 15.55
        );
        insert assetLineItem;
        account = [Select Id, Name, APTS_Aviaso_ISV__c From Account Where Id = :account.id];
        System.assertEquals(account.APTS_Aviaso_ISV__c, 15.55);
    }
    
    @isTest
    public static void testUpdate() {
        Account account = TestDataFactory.createAccount();
        Apttus_Config2__AssetLineItem__c assetLineItem = new Apttus_Config2__AssetLineItem__c(
            Name = 'Test Asset Line Item'+TestDataFactory.generateRandomString(3),
            Apttus_Config2__ShipToAccountId__c = account.id,
            APTS_ISV_Impact__c = 'Yes',
            Apttus_Config2__AssetStatus__c = 'Activated',
            Apttus_Config2__NetPrice__c = 15.55
        );
        insert assetLineItem;
        assetLineItem.Apttus_Config2__NetPrice__c = 18.15;
        update assetLineItem;
        account = [Select Id, Name, APTS_Aviaso_ISV__c From Account Where Id = :account.id];
        System.assertEquals(account.APTS_Aviaso_ISV__c, 18.15);
    }
    
    @isTest
    public static void testDelete() {
        Account account = TestDataFactory.createAccount();
        Apttus_Config2__AssetLineItem__c assetLineItem = new Apttus_Config2__AssetLineItem__c(
            Name = 'Test Asset Line Item'+TestDataFactory.generateRandomString(3),
            Apttus_Config2__ShipToAccountId__c = account.id,
            APTS_ISV_Impact__c = 'Yes',
            Apttus_Config2__AssetStatus__c = 'Activated',
            Apttus_Config2__NetPrice__c = 15.55
        );
        insert assetLineItem;
        delete assetLineItem;
        account = [Select Id, Name, APTS_Aviaso_ISV__c From Account Where Id = :account.id];
        System.assertEquals(account.APTS_Aviaso_ISV__c, 0);
    }
}