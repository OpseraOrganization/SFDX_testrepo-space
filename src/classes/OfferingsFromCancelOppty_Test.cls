/**
 * Created by Satya Mohanty on 9/25/2020.
 * OWNED BY THE CRM SALES TEAM.
 */
@isTest
private class OfferingsFromCancelOppty_Test{
    private final static String AMERICAS = 'Americas';
    private final static String AMERICA = 'America';
    private final static String BENDIXKING = 'BendixKing';
    private static Opportunity opportunity;
    private static Account acct;
    private static User userOne;
    private static Contact contact;
    private static Pricebook2 pbook;
    private static PricebookEntry pbookEntry;
    private static User techSalesManager;
    private static Product2 productOne;
    private static Platform__c platformOne;
    private static Platform__c platformTwo;
    private static Product_Line_Cross_Ref__c productLineCrossRef;
    private static Product_Line__c productLine;
    private static Fleet_Asset_Detail__c fleetAssetDetail;
    private static OFFERING_MAPPER__c offeringPlatform;
    private static RMU_VALUE__c offering;
    
        static void init() {
        Account acct = new TestAccountBuilder()
                .addField('Report_Country_Name__c', AMERICA)
                .addField('Region_Name__c', AMERICAS)
                .generate();

        opportunity = new TestOpportunityBuilder('Test', BENDIXKING)
                .addField('AccountId', acct.Id)
                .addField('SBU__c', 'BGA')
                .addField('StageName', 'Cultivate')             
                .generate();

        Contact contact = new TestContactBuilder()
         .addField( 'AccountId', acct.Id )
         .generate();
         
        userOne = new TestUserBuilder()
                .setFirstName( 'John' )
                .setLastName( 'Doe' )
                .generate();  
        platformOne = new TestPlatformBuilder()
        .setName('TestPlatformOne')
        .setModel('36-16A')
        .setMake('Various OEMS')
        .setSAPExternalSystem(true)
        .addField('Active__c', true)
        .generate();
        
        fleetAssetDetail = new TestFleetAssetDetailBuilder()
                .setPlatform(platformOne.Id)
                .generate();
        platformTwo = new TestPlatformBuilder()
                .setName('TestPlatformTwo')
                .setModel('36-16A')
                .setMake('Various OEMS')
                .setSAPExternalSystem(true)
                .addField('Active__c', true)
                .generate();

        Platform_cross_ref__c platformCrossRef = new Platform_cross_ref__c();
        platformCrossRef.External_System_Name__c = 'FleetAnalyzer';
        platformCrossRef.Platform_Parent__c = platformOne.Id;
        insert platformCrossRef;

        Platform_cross_ref__c platformCrossRefTwo = new Platform_cross_ref__c();
        platformCrossRefTwo.External_System_Name__c = 'FleetAnalyzer';
        platformCrossRefTwo.Platform_Parent__c = platformTwo.Id;
        insert platformCrossRefTwo;

        pbook = new TestPricebookBuilder()
                .generate();
        Product2 product = new TestProductBuilder()
                .addField('CanUseRevenueSchedule', true)
                .generate();
        PricebookEntry standardPricebookEntry= new PriceBookEntry(
                Pricebook2Id = System.Test.getStandardPricebookId(),
                Product2Id = product.Id,
                UnitPrice = 50
                );
        Database.insert(standardPricebookEntry);
        pbookEntry = new TestPricebookEntryBuilder()
                .setPricebook(pbook.Id)
                .setProduct(product.Id)
                .generate();
        productLine = new TestProductTypeBuilder().generate();
        productLineCrossRef = new TestProductLineCrossRefBuilder('TestName')
                .setProductType(productLine.Id)
                .setProductLeader(contact.Id)
                .generate();
        techSalesManager = new TestUserBuilder().generate();        
           }
      @IsTest
    static void OfferingforCancelopportunity() {
        init();
        OpportunityLineItem lineItem;
         Test.startTest();
      
         opportunity.Win_Loss_Reason_Code__c ='Parked opportunity';
         opportunity.StageName= 'Closed Cancelled';
         update opportunity;

        Fleet_Asset_Detail__c fleetAssetDetail = new TestFleetAssetDetailBuilder()
                .setName('My_Fleet_Asset_Detail')
                .build();

        offering = new RMU_VALUE__c();
        offering.Name = 'testOffering';
        insert offering;
        
        offeringPlatform = new OFFERING_MAPPER__c();
        offeringPlatform.Name = 'testOfferingPlatform';
        offeringPlatform.RMU_VALUE__c = offering.Id;
        insert offeringPlatform;
        
        
        lineItem = new TestOpportunityLineItemBuilder()
                .setServiceDate( Date.today() )                      
                .setUnitPrice(100)
                .setQuantity(10)
                .setPricebookEntryId(pbookEntry.Id)
                .setType('Forecast')
                .setOpportunityId(opportunity.Id)
                .addField('RMU__c',offering.Id)
                .generate();
        
        lineItem.Quantity= 15;
        update lineItem;  
                                                  
        OpportunityLineItem insertedLineItem = [
                SELECT
                    Id,
                    Opportunity.sbu__c,
                    RMU_Platform__c                        
                FROM OpportunityLineItem
                WHERE Id =: lineItem.Id                
        ];
                                   
        ApexPages.StandardController sc = new ApexPages.StandardController(opportunity);
        offeringsFromCancelOppty Canceloppty = new offeringsFromCancelOppty(sc);
        Test.stopTest();
    }
    
}