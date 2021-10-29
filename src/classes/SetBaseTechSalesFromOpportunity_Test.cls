/**
 * Created by Nikolay Kolev on 4/15/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
@IsTest
public class SetBaseTechSalesFromOpportunity_Test {
    private static Product_Line__c productLine;
    private static Contact contact;
    private static Product_Line_Cross_Ref__c productLineCrossRef;
    private static Opportunity testOpportunity;
    private final static String BENDIXKING = 'BendixKing';
    private static Pricebook2 pbook;
    private static PricebookEntry pbookEntry;
    private static OpportunityLineItem lineItem;
    private final static String BK_FLIGHT_CONTROLS = 'BK-Flight Controls';
    private static User techSalesManager;
    private static Map<String, Id> users;

    private static void init() {
        contact = new TestContactBuilder().generate();
        pbook = new TestPricebookBuilder()
                .generate();
        Product2 product  = new TestProductBuilder()
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
        testOpportunity = new TestOpportunityBuilder('Test', BENDIXKING)
                .addField('Tech_Sales__c', BENDIXKING)
                .addField('Tech_Sales_Product_Area__c', BK_FLIGHT_CONTROLS)
                .addField('Default_Tech_Sales_Manager__c', techSalesManager.Id)
                .addField('Tech_Sales1__c', techSalesManager.Name)
                .generate();
        // Create OpportunityLineItem using the lineItemBuilder class.
        lineItem = new TestOpportunityLineItemBuilder()
                .setServiceDate(Date.today())
                .setproductCrossReferenceId(productLineCrossRef.Id)
                .setOpportunityId(testOpportunity.Id)
                .setPricebookEntryId(pbookEntry.Id)
                .generate();

        users = new Map<String, Id>();
        users.put(techSalesManager.Name, techSalesManager.Id);
    }
    @IsTest
    static void testBehavior() {
        init();

        System.Test.startTest();
        SetBaseTechSalesFromOpportunity techSalesSetter = new SetBaseTechSalesFromOpportunity(
                lineItem,
                testOpportunity,
                users
        );
        techSalesSetter.setTechSales();
        System.Test.stopTest();

        System.assertEquals(BENDIXKING, lineItem.Tech_Sales__c);
        System.assertEquals(BK_FLIGHT_CONTROLS, lineItem.Tech_Sales_Product__c);
        System.assertEquals(techSalesManager.Id, lineItem.Tech_Sales_Manager__c);
    }
}