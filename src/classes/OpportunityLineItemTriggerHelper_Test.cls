/**
 * Created by Satya Mohanty on 4/16/2019.
 * OWNED BY THE CRM SALES TEAM.
 */

@IsTest
private class OpportunityLineItemTriggerHelper_Test {
    private static Product_Line__c productLine;
    private static Product_Line__c productLineTwo;
    private static Set<Id> productLineIds = new Set<Id>();
    private static Set<Id> productLineCrossReferenceIds = new Set<Id>();
    private static Set<Id> opportunityIds = new Set<Id>();
    private final static String BENDIXKING = 'BendixKing';
    private final static String BK_FLIGHT_CONTROLS = 'BK-Flight Controls';
    private final static String CROSS_REF_ONE = 'Cross Ref One';
    private final static String CROSS_REF_TWO = 'Cross Ref Two';
    private final static String SBU_ONE = 'BGA';
    private final static String SBU_TWO = 'D&S';
    private final static String AMERICAS = 'Americas';
    private final static String AMERICA = 'America';
    private static Set<String> userNames = new Set<String>();
    private static User userOne;
    private static User userTwo;
    private static RMU_VALUE__c rmuValueOne;
    private static RMU_VALUE__c rmuValueTwo;
    private static RMU_Product__c rmuProductOne;
    private static Product2 productOne;
    private static Product2 productTwo;
    private static OFFERING_MAPPER__c offeringMapperOne;
    private static OFFERING_MAPPER__c offeringMapperTwo;
    private static Platform__c platformOne;
    private static Platform__c platformTwo;

    static void init() {
        Contact contact = new TestContactBuilder().generate();
        // Insert Product Line
        productLine = new TestProductTypeBuilder().generate();
        productLineTwo = new TestProductTypeBuilder().generate();
        productLineIds.add(productLine.Id);
        productLineIds.add(productLineTwo.Id);
        // Insert Product Line Tech Sales
        Product_Line_Tech_Sales__c productLineTechSales = new TestProductLineTechSalesBuilder()
                .setSBU(SBU_ONE)
                .setRegion(AMERICAS)
                .setProductLine(productLine.Id)
                .addField('Country__c', AMERICA)
                .addField('Tech_Sales__c', BENDIXKING)
                .addField('Tech_Sales_Product__c', BK_FLIGHT_CONTROLS)
                .generate();
        Product_Line_Tech_Sales__c productLineTechSalesTwo = new TestProductLineTechSalesBuilder()
                .setSBU(SBU_TWO)
                .setRegion(AMERICAS)
                .addField('Country__c', AMERICA)
                .setProductLine(productLineTwo.Id)
                .addField('Tech_Sales__c', BENDIXKING)
                .addField('Tech_Sales_Product__c', BK_FLIGHT_CONTROLS)
                .generate();
        // Insert Product Line Cross Reference
        productLineCrossReferenceIds.add(new TestProductLineCrossRefBuilder(CROSS_REF_ONE)
                .setProductType(productLine.Id)
                .setProductLeader(contact.Id)
                .generate().Id);
        productLineCrossReferenceIds.add(new TestProductLineCrossRefBuilder(CROSS_REF_TWO)
                .setProductType(productLineTwo.Id)
                .setProductLeader(contact.Id)
                .generate().Id);
        userOne = new TestUserBuilder().setFirstName('John').setLastName('Doe').generate();
        userTwo = new TestUserBuilder().setFirstName('Jane').setLastName('Doe').generate();

        userNames.add([
                SELECT Name
                FROM User
                WHERE Id = :userOne.Id
        ].Name);
        userNames.add([
                SELECT Name
                FROM User
                WHERE Id = :userTwo.Id
        ].Name);

        opportunityIds.add(new TestOpportunityBuilder().generate().Id);
        opportunityIds.add(new TestOpportunityBuilder().generate().Id);

        productOne  = new TestProductBuilder('My Product One')
                .generate();
        productTwo  = new TestProductBuilder('My Product Two')
                .generate();

        rmuValueOne = new TestRmuValueBuilder().generate();
        rmuValueTwo = new TestRmuValueBuilder().generate();

        rmuProductOne = new TestRmuProductBuilder()
                .setName('My Rmu Product One')
                .addField('Rmu_Product__c', productOne.Id)
                .setRmuValue(rmuValueOne.Id)
                .generate();

        rmuProductOne = new TestRmuProductBuilder()
                .setName('My Rmu Product Two')
                .addField('Rmu_Product__c', productTwo.Id)
                .setRmuValue(rmuValueTwo.Id)
                .generate();

        platformOne = new TestPlatformBuilder()
                .setName('TestPlatformOne')
                .setModel('36-16A')
                .setMake('Various OEMS')
                .setSAPExternalSystem(true)
                .addField('Active__c', true)
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

        offeringMapperOne = new TestOfferingMapperBuilder()
                .setRmuValue(rmuValueOne.Id)
                .addField('Aircraft_Platform__c', platformOne.Id)
                .generate();

        offeringMapperTwo = new TestOfferingMapperBuilder()
                .setRmuValue(rmuValueOne.Id)
                .addField('Aircraft_Platform__c', platformTwo.Id)
                .generate();
    }
    @IsTest
    static void getProductLinesThroughCrossRef() {
        init();

        // Pass both product line cross ref and empty product line Ids but ensure it's pulling through the cross reference.
        System.Test.startTest();
        Map<Id, Product_Line__c> returnedProductLines = OpportunityLineItemTriggerHelper.getProductLines(
                productLineCrossReferenceIds,
                productLineIds
        );
        System.Test.stopTest();

        // Assert that map is not empty
        System.assertEquals(true, !returnedProductLines.isEmpty());
        // Assert that Product Line Tech Sales were retrieved correctly for product line one
        System.assertEquals(productLine.Id, returnedProductLines.get(productLine.Id).Id);
        System.assertEquals(1, returnedProductLines.get(productLine.Id).Product_Line_Tech_Sales__r.size());
        System.assertEquals(SBU_ONE, returnedProductLines.get(productLine.Id).Product_Line_Tech_Sales__r.get(0).SBU__c);
        System.assertEquals(
                productLine.Id,
                returnedProductLines.get(productLine.Id).Product_Line_Tech_Sales__r.get(0).Product_Line__c
        );
        System.assertEquals(
                AMERICAS,
                returnedProductLines.get(productLine.Id).Product_Line_Tech_Sales__r.get(0).Region__c
        );
        System.assertEquals(
                AMERICA,
                returnedProductLines.get(productLine.Id).Product_Line_Tech_Sales__r.get(0).Country__c
        );
        // Assert product line tech sales for product line two.
        System.assertEquals(productLine.Id, returnedProductLines.get(productLine.Id).Id);
        System.assertEquals(1, returnedProductLines.get(productLineTwo.Id).Product_Line_Tech_Sales__r.size());
        System.assertEquals(SBU_TWO, returnedProductLines.get(productLineTwo.Id).Product_Line_Tech_Sales__r.get(0).SBU__c);
        System.assertEquals(
                productLineTwo.Id,
                returnedProductLines.get(productLineTwo.Id).Product_Line_Tech_Sales__r.get(0).Product_Line__c
        );
        System.assertEquals(
                AMERICAS,
                returnedProductLines.get(productLineTwo.Id).Product_Line_Tech_Sales__r.get(0).Region__c
        );
        System.assertEquals(
                AMERICA,
                returnedProductLines.get(productLineTwo.Id).Product_Line_Tech_Sales__r.get(0).Country__c
        );
        // Assert that Product Line Cross Ref were retrieved correctly for product line one
        System.assertEquals(1, returnedProductLines.get(productLine.Id).Product_Line_Cross_Ref__r.size());
        System.assertEquals(
                productLine.Id,
                returnedProductLines.get(productLine.Id).Product_Line_Cross_Ref__r.get(0).Product_Line__c
        );
        System.assertEquals(
                CROSS_REF_ONE,
                returnedProductLines.get(productLine.Id).Product_Line_Cross_Ref__r.get(0).Name
        );
        // Assert that Product Line Cross Ref were retrieved correctly for product line two
        System.assertEquals(1, returnedProductLines.get(productLineTwo.Id).Product_Line_Cross_Ref__r.size());
        System.assertEquals(
                productLineTwo.Id,
                returnedProductLines.get(productLineTwo.Id).Product_Line_Cross_Ref__r.get(0).Product_Line__c
        );
        System.assertEquals(
                CROSS_REF_TWO,
                returnedProductLines.get(productLineTwo.Id).Product_Line_Cross_Ref__r.get(0).Name
        );
    }
    @IsTest
    static void getProductLinesThroughProductLine() {
        init();

        // Emptying the list of product line cross reference ids.
        productLineCrossReferenceIds = new Set<Id>();

        // Pass empty product line cross ref and but correct product line Ids and ensure it's pulling through the
        // product line.
        System.Test.startTest();
        Map<Id, Product_Line__c> returnedProductLines = OpportunityLineItemTriggerHelper.getProductLines(
                productLineCrossReferenceIds,
                productLineIds
        );
        System.Test.stopTest();

        // Assert that map is not empty
        System.assertEquals(true, !returnedProductLines.isEmpty());
        // Assert that Product Line Tech Sales were retrieved correctly for product line one
        System.assertEquals(productLine.Id, returnedProductLines.get(productLine.Id).Id);
        System.assertEquals(1, returnedProductLines.get(productLine.Id).Product_Line_Tech_Sales__r.size());
        System.assertEquals(SBU_ONE, returnedProductLines.get(productLine.Id).Product_Line_Tech_Sales__r.get(0).SBU__c);
        System.assertEquals(
                productLine.Id,
                returnedProductLines.get(productLine.Id).Product_Line_Tech_Sales__r.get(0).Product_Line__c
        );
        System.assertEquals(
                AMERICAS,
                returnedProductLines.get(productLine.Id).Product_Line_Tech_Sales__r.get(0).Region__c
        );
        System.assertEquals(
                AMERICA,
                returnedProductLines.get(productLine.Id).Product_Line_Tech_Sales__r.get(0).Country__c
        );
        // Assert product line tech sales for product line two.
        System.assertEquals(productLine.Id, returnedProductLines.get(productLine.Id).Id);
        System.assertEquals(1, returnedProductLines.get(productLineTwo.Id).Product_Line_Tech_Sales__r.size());
        System.assertEquals(SBU_TWO, returnedProductLines.get(productLineTwo.Id).Product_Line_Tech_Sales__r.get(0).SBU__c);
        System.assertEquals(
                productLineTwo.Id,
                returnedProductLines.get(productLineTwo.Id).Product_Line_Tech_Sales__r.get(0).Product_Line__c
        );
        System.assertEquals(
                AMERICAS,
                returnedProductLines.get(productLineTwo.Id).Product_Line_Tech_Sales__r.get(0).Region__c
        );
        System.assertEquals(
                AMERICA,
                returnedProductLines.get(productLineTwo.Id).Product_Line_Tech_Sales__r.get(0).Country__c
        );
        // Assert that Product Line Cross Ref were retrieved correctly for product line one
        System.assertEquals(1, returnedProductLines.get(productLine.Id).Product_Line_Cross_Ref__r.size());
        System.assertEquals(
                productLine.Id,
                returnedProductLines.get(productLine.Id).Product_Line_Cross_Ref__r.get(0).Product_Line__c
        );
        System.assertEquals(
                CROSS_REF_ONE,
                returnedProductLines.get(productLine.Id).Product_Line_Cross_Ref__r.get(0).Name
        );
        // Assert that Product Line Cross Ref were retrieved correctly for product line two
        System.assertEquals(1, returnedProductLines.get(productLineTwo.Id).Product_Line_Cross_Ref__r.size());
        System.assertEquals(
                productLineTwo.Id,
                returnedProductLines.get(productLineTwo.Id).Product_Line_Cross_Ref__r.get(0).Product_Line__c
        );
        System.assertEquals(
                CROSS_REF_TWO,
                returnedProductLines.get(productLineTwo.Id).Product_Line_Cross_Ref__r.get(0).Name
        );
    }
    @IsTest
    static void getProductLinesNoIds() {
        init();

        // Emptying the list of product line cross reference ids.
        productLineCrossReferenceIds = new Set<Id>();
        productLineIds = new Set<Id>();

        // Pass empty lists for both lists of ids and ensure an empty map was returned.
        System.Test.startTest();
        Map<Id, Product_Line__c> returnedProductLines = OpportunityLineItemTriggerHelper.getProductLines(
                productLineCrossReferenceIds,
                productLineIds
        );
        System.Test.stopTest();

        // Assert that map is empty
        System.assertEquals(true, returnedProductLines.isEmpty());
    }
    @IsTest
    static void testGetUserMap() {
        init();

        // Inserting one more dummy user so that there are 3 in the database. Still assert that only 2 are returned.
        new TestUserBuilder().setFirstName('Justin').setLastName('Doe').generate();

        System.Test.startTest();
        Map<String, Id> returnedUsers = OpportunityLineItemTriggerHelper.getUserMap(userNames);
        System.Test.stopTest();

        Set<Id> returnedUserIds = new Set<Id>();
        for (String userName: userNames) {
            returnedUserIds.add(returnedUsers.get(userName));
        }

        System.assertEquals(2, returnedUsers.size());
        System.assertEquals(true, returnedUserIds.contains(userOne.Id));
        System.assertEquals(true, returnedUserIds.contains(userTwo.Id));
    }
    @IsTest
    static void testGetProductRmuIdToRmuValueId() {
        init();

        Set<Id> productIds = new Set<Id> {
                productOne.Id,
                productTwo.Id
        };

        System.Test.startTest();
        Map<Id, Id> producRmuToRmuValue = OpportunityLineItemTriggerHelper.getProductRmuIdToRmuValueId(productIds);
        System.Test.stopTest();

        System.assertEquals(rmuValueOne.Id, producRmuToRmuValue.get(productOne.Id));
        System.assertEquals(rmuValueTwo.Id, producRmuToRmuValue.get(productTwo.Id));
    }
    @IsTest
    static void testGetRmuValueToOfferingMappers() {
        init();

        Set<Id> platformIds = new Set<Id> {
                platformOne.Id,
                platformTwo.Id
        };

        System.Test.startTest();
        Map<Id, List<OFFERING_MAPPER__c>> RmuValueToOfferingMappers = OpportunityLineItemTriggerHelper.getRmuValueToOfferingMappers(platformIds);
        System.Test.stopTest();

        System.assertEquals(1, RmuValueToOfferingMappers.size());
        System.assertEquals(2, RmuValueToOfferingMappers.get(rmuValueOne.Id).size());
        List<Id> returnedPlatformIds = new List<Id>();
        for (OFFERING_MAPPER__c mapper: RmuValueToOfferingMappers.get(rmuValueOne.Id)) {
            returnedPlatformIds.add(mapper.Aircraft_Platform__c);
        }
        System.debug('returnedPlatformIds: ' + returnedPlatformIds);
        System.assertEquals(true, returnedPlatformIds.contains(platformOne.Id));
        System.assertEquals(true, returnedPlatformIds.contains(platformTwo.Id));
    }
    @IsTest
    static void testGetOpportunities() {
        init();

        // Adding an additional opportunity to assert it won't get returned.
        Opportunity dummyOpportunity = new TestOpportunityBuilder().generate();

        System.Test.startTest();
        Map<Id, Opportunity> opportunities = OpportunityLineItemTriggerHelper.getOpportunities(opportunityIds);
        System.Test.stopTest();

        // Casting to a list to get access to get().
        List<Id> opportunityIdsList = new List<Id> (opportunityIds);

        System.assertEquals(2, opportunities.size());
        System.assertEquals(true, opportunities.containsKey(opportunityIdsList.get(0)));
        System.assertEquals(true, opportunities.containsKey(opportunityIdsList.get(1)));
        System.assertEquals(false, opportunities.containsKey(dummyOpportunity.Id));
    }
    @IsTest
    static void testIsUserAnAdminTrue() {
        User adminUser = new TestUserBuilder().generate();

        Boolean isAdmin;

        System.runAs(adminUser) {
            System.Test.startTest();
            isAdmin = OpportunityLineItemTriggerHelper.isUserAnAdmin();
            System.Test.stopTest();
        }

        System.assertEquals(true, isAdmin);
    }
    @IsTest
    static void testIsUserAnAdminFalse() {
        User standardUser = new TestUserBuilder()
                .addField('ProfileId', [
                        SELECT Id
                        FROM Profile
                        WHERE Name = 'Standard User'
                        ].Id)
                .generate();

        Boolean isAdmin;

        System.runAs(standardUser) {
            System.Test.startTest();
            isAdmin = OpportunityLineItemTriggerHelper.isUserAnAdmin();
            System.Test.stopTest();
        }

        System.assertEquals(false, isAdmin);
    }
}