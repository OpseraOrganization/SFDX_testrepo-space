@isTest
    private class TestReportExporter{
        public static String CRON_EXP = '0 0 0 15 3 ? 2022';
        static testmethod void ReportExportertest(){
             list<Report_Exporter__c>Rex=[Select Id, Name, Report_ID__c, OwnerId, Attachment_Name__c, Email_Subject__c, Email_Body__c, Email_Recipients__c,Weekly_Days__c, Frequency__c, Monthly_Day__c, Last_Run__c from Report_Exporter__c limit 1];
             Report_Exporter__c e = new  Report_Exporter__c();
             e.Name = 'Test Exporter Record';
             e.Report_ID__c = '00OU0000001xEWe';
             e.Attachment_Name__c = 'Test Attachment Name';
             e.Email_Subject__c = 'Test Email Subject';
             e.Email_Body__c = 'Test Email Body';
             e.Email_Recipients__c = 'abc@abc.com';
             e.Weekly_Days__c = 'Sunday; Monday; Tuesday; Wednesday; Friday';
             e.Frequency__c = 'Weekly';
            Insert(e);
            
          /*  Profile pf= [select id from Profile where name = 'Sales Developer'];
         User u2 = new User(LastName = 'Test User78788',Username = 'tu178788@test.com',Email = 'testuser@test.com',ProfileId = pf.Id,Alias = 'tu178788' ,CommunityNickname= 'tu178788' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
           insert u2;*/
           Test.startTest();
          // Schedule the test job

           String jobId = System.schedule('TestReportExporter', CRON_EXP, new ReportExporter());
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
    static testmethod void ReportExportertest1(){
             list<Report_Exporter__c>Rex=[Select Id, Name, Report_ID__c, OwnerId, Attachment_Name__c, Email_Subject__c, Email_Body__c, Email_Recipients__c,Weekly_Days__c, Frequency__c, Monthly_Day__c, Last_Run__c from Report_Exporter__c limit 1];
             Report_Exporter__c e = new  Report_Exporter__c();
             e.Name = 'Test Exporter Record';
             e.Report_ID__c = '00OU0000001xEWe';
             e.Attachment_Name__c = 'Test Attachment Name';
             e.Email_Subject__c = 'Test Email Subject';
             e.Email_Body__c = 'Test Email Body';
             e.Email_Recipients__c = 'abc@abc.com';
             //e.Monthly_Day__c = '28';
             e.Monthly_Day__c = String.valueOf(System.today().day());
             e.Frequency__c = 'Monthly';
            Insert(e);
          
         
           Test.startTest();
          // Schedule the test job

           String jobId = System.schedule('TestReportExporter', CRON_EXP, new ReportExporter());
          // Get the information from the CronTrigger API object
          CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
          // Verify the expressions are the same
         System.assertEquals(CRON_EXP,ct.CronExpression);
          // Verify the job has not run
          System.assertEquals(0, ct.TimesTriggered);
          // Verify the next time the job will run
          System.assertEquals('2022-03-15 00:00:00',
            String.valueOf(ct.NextFireTime));
          Test.stopTest(); 
    }
}