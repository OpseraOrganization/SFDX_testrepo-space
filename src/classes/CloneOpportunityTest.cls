/**
 * OWNED BY THE CRM SALES TEAM.
 */
@IsTest
private class CloneOpportunityTest{
    static testMethod void TestUnit1(){

        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Opportunity opp1 = new Opportunity (Name='Opp1',
                                            StageName='Prospecting',
                                            CloseDate=Date.today(),
                                            AccountId = acc.Id);
        insert opp1;

        Test.startTest();
            opp1.StageName='Closed Won';
            update opp1;
            CloneOpportunity.getCloneOpp(opp1.Id);
            CloneOpportunity.deleteOpp(opp1.Id);
            CloneOpportunity.fetchDRRecords(opp1.Id);
        Test.stopTest();
    }
}