/**
 * Created by Satya Mohanty on 4/25/2019.
 * OWNED BY THE CRM SALES TEAM.
 */
@IsTest
private class TestOpportunityTeamBuilder_Test {
    private static Opportunity testOpportunity;
    private static User user;
    private static final String BENDIXKING = 'Bendixking';
    private static void init() {
        testOpportunity = new TestOpportunityBuilder( 'Test', BENDIXKING )
                .generate();
        user = new TestUserBuilder()
                .generate();
    }
    @IsTest
    static void testDefaultBuild() {
        init();
        System.Test.startTest();
        Opportunity_Sales_Team__c opportunityTeam = new TestOpportunityTeamBuilder()
                .setUserId(user.Id)
                .build();
        System.Test.stopTest();

        System.assertEquals(null, opportunityTeam.Id);
        System.assertEquals(user.Id, opportunityTeam.User__c);
    }
    @IsTest
    static void testGenerateWithaddfield() {
        init();
        System.Test.startTest();
        Opportunity_Sales_Team__c opportunityTeam = new TestOpportunityTeamBuilder()
                .setUserId(user.Id)
                .addField('Opportunity__c', testOpportunity.Id)
                .generate();
        System.Test.stopTest();

        Opportunity_Sales_Team__c insertedOpportunityTeam = [
                SELECT Id
                FROM Opportunity_Sales_Team__c
                WHERE User__c = :user.Id
                AND Opportunity__c = :testOpportunity.Id
        ];
        System.assertEquals(insertedOpportunityTeam.Id, opportunityTeam.Id);
        System.assertEquals(user.Id, opportunityTeam.User__c);
        System.assertEquals(testOpportunity.Id, opportunityTeam.Opportunity__c);

    }
}