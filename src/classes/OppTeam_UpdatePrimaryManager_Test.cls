/**
 * Created by Meiying Liang on 1/8/2020.
 */

@IsTest
private class OppTeam_UpdatePrimaryManager_Test {
    private final static String BENDIXKING = 'BendixKing';
    private final static String AMERICAS = 'Americas';
    private final static String AMERICA = 'America';
    private static Opportunity opportunity;
    private static Account acct;
    private static OppType__c oppType;
    private static Contact contact;

    static void init() {
        acct = new TestAccountBuilder()
                .addField( 'Report_Country_Name__c', AMERICA )
                .addField( 'Region_Name__c', AMERICAS )
                .generate();
        oppType = new OppType__c( RestrictedAccount__c = acct.Id, Name = 'Test' );
        insert oppType;
        opportunity = new TestOpportunityBuilder( 'Test', BENDIXKING )
                .addField( 'AccountId', acct.Id )
                .addField( 'SBU__c', 'BGA' )
                .addField( 'StageName', 'Closed Won' )
                .build();

        contact = new TestContactBuilder().generate();
        Product2 product = new TestProductBuilder()
                .addField( 'CanUseRevenueSchedule', true )
                .generate();
        PricebookEntry standardPricebookEntry = new PriceBookEntry(
                Pricebook2Id = System.Test.getStandardPricebookId(),
                Product2Id = product.Id,
                UnitPrice = 50
        );

        Database.insert(standardPricebookEntry);
    }

    @IsTest
    static void AU_OppTeam_UpdatePrimaryManager_Engineering() {
        init();

        insert opportunity;

        Test.startTest();

        User user = new TestUserBuilder()
                .setFirstName( 'Engineering' )
                .setLastName( 'Test' )
                .generate();

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .setUserId(user.Id)
                .addField('Opportunity_Team_Role__c','Engineering')
                .generate();

        oppTeam.Opportunity_Team_Role__c = 'Program Mgr';
        update oppTeam;

        system.assertEquals(opportunity.Programme_Manager__c,oppTeam.Team_Member_Full_Name__c);

        Test.stopTest();
    }

    @IsTest
    static void AU_OppTeam_UpdatePrimaryManager_ProgramManager() {
        init();

        insert opportunity;

        Test.startTest();

        User user = new TestUserBuilder()
                .setFirstName( 'ProgramManager' )
                .setLastName( 'Test' )
                .generate();

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .setUserId(user.Id)
                .addField('Opportunity_Team_Role__c','Program Mgr')
                .generate();

        oppTeam.Opportunity_Team_Role__c = 'Co-Owner2';
        update oppTeam;

        system.assertEquals(opportunity.Co_Owner2__c,oppTeam.Team_Member_Full_Name__c);

        Test.stopTest();
    }

    @IsTest
    static void AU_OppTeam_UpdatePrimaryManager_ISC() {
        init();

        insert opportunity;

        Test.startTest();

        User user = new TestUserBuilder()
                .setFirstName( 'ISC' )
                .setLastName( 'Test' )
                .generate();

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .setUserId(user.Id)
                .addField('Opportunity_Team_Role__c','ISC')
                .generate();

        oppTeam.Opportunity_Team_Role__c = 'Engineering';
        update oppTeam;

        system.assertEquals(opportunity.Engineering__c,oppTeam.Team_Member_Full_Name__c);

        Test.stopTest();
    }

    @IsTest
    static void AU_OppTeam_UpdatePrimaryManager_Pricing() {
        init();

        insert opportunity;

        Test.startTest();

        User user = new TestUserBuilder()
                .setFirstName( 'Pricing' )
                .setLastName( 'Test' )
                .generate();

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .setUserId(user.Id)
                .addField('Opportunity_Team_Role__c','Pricing')
                .generate();

        oppTeam.Opportunity_Team_Role__c = 'ISC';
        update oppTeam;

        system.assertEquals(opportunity.ISC__c,oppTeam.Team_Member_Full_Name__c);

        Test.stopTest();
    }

    @IsTest
    static void AU_OppTeam_UpdatePrimaryManager_TechnicalSales() {
        init();

        insert opportunity;

        Test.startTest();

        User user = new TestUserBuilder()
                .setFirstName( 'TechnicalSales' )
                .setLastName( 'Test' )
                .generate();

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .setUserId(user.Id)
                .addField('Opportunity_Team_Role__c','Technical Sales')
                .generate();

        oppTeam.Opportunity_Team_Role__c = 'Pricing';
        update oppTeam;

        system.assertEquals(opportunity.Pricing__c,oppTeam.Team_Member_Full_Name__c);

        Test.stopTest();
    }

    @IsTest
    static void AU_OppTeam_UpdatePrimaryManager_TechnicalSalesSecondary() {
        init();

        insert opportunity;

        Test.startTest();

        User user = new TestUserBuilder()
                .setFirstName( 'TechnicalSalesSecondary' )
                .setLastName( 'Test' )
                .generate();

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .setUserId(user.Id)
                .addField('Opportunity_Team_Role__c','Tech Sales Secondary')
                .generate();

        oppTeam.Opportunity_Team_Role__c = 'Technical Sales';
        update oppTeam;

        system.assertEquals(opportunity.Tech_Sales1__c,oppTeam.Team_Member_Full_Name__c);

        Test.stopTest();
    }

    @IsTest
    static void AU_OppTeam_UpdatePrimaryManager_SalesLead() {
        init();

        insert opportunity;

        Test.startTest();

        User user = new TestUserBuilder()
                .setFirstName( 'SalesLead' )
                .setLastName( 'Test' )
                .generate();

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .setUserId(user.Id)
                .addField('Opportunity_Team_Role__c','Sales Lead')
                .generate();

        oppTeam.Opportunity_Team_Role__c = 'Tech Sales Secondary';
        update oppTeam;

        system.assertEquals(opportunity.Tech_Sales2__c,oppTeam.Team_Member_Full_Name__c);

        Test.stopTest();
    }

    @IsTest
    static void AU_OppTeam_UpdatePrimaryManager_CoOwner() {
        init();

        insert opportunity;

        Test.startTest();

        User user = new TestUserBuilder()
                .setFirstName( 'Co-Owner' )
                .setLastName( 'Test' )
                .generate();

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .setUserId(user.Id)
                .addField('Opportunity_Team_Role__c','Co-Owner')
                .generate();

        oppTeam.Opportunity_Team_Role__c = 'Sales Lead';
        update oppTeam;

        system.assertEquals(opportunity.Sales_Lead__c,oppTeam.Team_Member_Full_Name__c);

        Test.stopTest();
    }

    @IsTest
    static void AU_OppTeam_UpdatePrimaryManager_CoOwner2() {
        init();

        insert opportunity;

        Test.startTest();

        User user = new TestUserBuilder()
                .setFirstName( 'Co-Owner2' )
                .setLastName( 'Test' )
                .generate();

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .setUserId(user.Id)
                .addField('Opportunity_Team_Role__c','Co-Owner2')
                .generate();

        oppTeam.Opportunity_Team_Role__c = 'Co-Owner';
        update oppTeam;

        system.assertEquals(opportunity.Co_Owner__c,oppTeam.Team_Member_Full_Name__c);

        Test.stopTest();
    }

    @IsTest
    static void AD_OppTeam_UpdatePrimaryManager_Engineering()
    {
        init();

        insert opportunity;

        Test.startTest();

        User user = new TestUserBuilder()
                .setFirstName( 'John' )
                .setLastName( 'Doe' )
                .generate();

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .setUserId(user.Id)
                .addField('Opportunity_Team_Role__c','Engineering')
                .generate();

        delete oppTeam;

        system.assertEquals(opportunity.Engineering__c,null);

        Test.stopTest();
    }

    @IsTest
    static void AD_OppTeam_UpdatePrimaryManager_ProgramManager()
    {
        init();

        insert opportunity;

        Test.startTest();

        User user = new TestUserBuilder()
                .setFirstName( 'John' )
                .setLastName( 'Doe' )
                .generate();

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .setUserId(user.Id)
                .addField('Opportunity_Team_Role__c','Program Mgr')
                .generate();

        delete oppTeam;

        system.assertEquals(opportunity.Programme_Manager__c,null);

        Test.stopTest();
    }

    @IsTest
    static void AD_OppTeam_UpdatePrimaryManager_ISC()
    {
        init();

        insert opportunity;

        Test.startTest();

        User user = new TestUserBuilder()
                .setFirstName( 'John' )
                .setLastName( 'Doe' )
                .generate();

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .setUserId(user.Id)
                .addField('Opportunity_Team_Role__c','ISC')
                .generate();

        delete oppTeam;

        system.assertEquals(opportunity.ISC__c,null);

        Test.stopTest();
    }

    @IsTest
    static void AD_OppTeam_UpdatePrimaryManager_Pricing()
    {
        init();

        insert opportunity;

        Test.startTest();

        User user = new TestUserBuilder()
                .setFirstName( 'John' )
                .setLastName( 'Doe' )
                .generate();

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .setUserId(user.Id)
                .addField('Opportunity_Team_Role__c','Pricing')
                .generate();

        delete oppTeam;

        system.assertEquals(opportunity.Pricing__c,null);

        Test.stopTest();
    }

    @IsTest
    static void AD_OppTeam_UpdatePrimaryManager_TechnicalSales()
    {
        init();

        insert opportunity;

        Test.startTest();

        User user = new TestUserBuilder()
                .setFirstName( 'John' )
                .setLastName( 'Doe' )
                .generate();

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .setUserId(user.Id)
                .addField('Opportunity_Team_Role__c','Technical Sales')
                .generate();

        delete oppTeam;

        system.assertEquals(opportunity.Tech_Sales1__c,null);

        Test.stopTest();
    }

    @IsTest
    static void AD_OppTeam_UpdatePrimaryManager_TechnicalSalesSecondary()
    {
        init();

        insert opportunity;

        Test.startTest();

        User user = new TestUserBuilder()
                .setFirstName( 'John' )
                .setLastName( 'Doe' )
                .generate();

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .setUserId(user.Id)
                .addField('Opportunity_Team_Role__c','Tech Sales Secondary')
                .generate();

        delete oppTeam;

        system.assertEquals(opportunity.Tech_Sales2__c,null);

        Test.stopTest();
    }

    @IsTest
    static void AD_OppTeam_UpdatePrimaryManager_SalesLead()
    {
        init();

        insert opportunity;

        Test.startTest();

        User user = new TestUserBuilder()
                .setFirstName( 'John' )
                .setLastName( 'Doe' )
                .generate();

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .setUserId(user.Id)
                .addField('Opportunity_Team_Role__c','Sales Lead')
                .generate();

        delete oppTeam;

        system.assertEquals(opportunity.Sales_Lead__c,null);

        Test.stopTest();
    }

    @IsTest
    static void AD_OppTeam_UpdatePrimaryManager_CoOwner()
    {
        init();

        insert opportunity;

        Test.startTest();

        User user = new TestUserBuilder()
                .setFirstName( 'John' )
                .setLastName( 'Doe' )
                .generate();

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .setUserId(user.Id)
                .addField('Opportunity_Team_Role__c','Co-Owner')
                .generate();

        delete oppTeam;

        system.assertEquals(opportunity.Co_Owner__c,null);

        Test.stopTest();
    }

    @IsTest
    static void AD_OppTeam_UpdatePrimaryManager_CoOwner2()
    {
        init();

        insert opportunity;

        Test.startTest();

        User user = new TestUserBuilder()
                .setFirstName( 'John' )
                .setLastName( 'Doe' )
                .generate();

        Opportunity_Sales_Team__c oppTeam = new TestOpportunityTeamBuilder()
                .addField('Opportunity__c', opportunity.Id)
                .setUserId(user.Id)
                .addField('Opportunity_Team_Role__c','Co-Owner2')
                .generate();

        delete oppTeam;

        system.assertEquals(opportunity.Co_Owner2__c,null);

        Test.stopTest();
    }

}