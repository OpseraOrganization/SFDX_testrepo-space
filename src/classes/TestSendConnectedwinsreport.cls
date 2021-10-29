@isTest
    private class TestSendConnectedwinsreport{
        public static String CRON_EXP = '0 0 0 15 3 ? 2022';
        static testmethod void SendConnectedwinsreporttest(){
        list<Opportunity>op =[SELECT StageName,Pipeline_Amount__c,Opportunity_Type__c ,CBT_Tier_2__c ,closedate, Name, Account.Name ,id, Sales_Channel__c FROM Opportunity where closedate >= 2018-01-01 and closedate <= 2018-12-31 and (stageName = 'closed won' or stageName = 'closed lost') and (NOT Opportunity_Type__c   like '%Run Rate%') and CBT_Tier_2__c <> 'HTSI'   and (NOT Name like '%Blanket%') order by Pipeline_Amount__c Desc limit 1]; 
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.Pgo__c ='1';
        opp.PWin__c ='1';
        opp.StageName= 'Cultivate' ;   
        opp.Type= 'BGA Aftermarket';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
      
        opp.recordtypeid='01213000000AWudAAG';
        opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;
        opp.Is_Restricted_Opportunity__c = false;
        opp.Is_Follow_On_Opportunity__c = false;
        opp.Certification_Requirements__c = 'FAR 15 Tina';
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Revenue_Type__c = 'ENG';
        opp.Solution_Type__c = 'Direct Sales';
        opp.SBU__c = 'D&S';
        insert opp;
        SendConnectedwinsreport sod = new SendConnectedwinsreport();
        
        Test.startTest();
        // Schedule the test job

        String jobId = System.schedule('Test Oppty', CRON_EXP, new SendConnectedwinsreport());
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        // Verify the next time the job will run
        System.assertEquals('2022-03-15 00:00:00',
        String.valueOf(ct.NextFireTime));
        Test.stopTest();
    }
}