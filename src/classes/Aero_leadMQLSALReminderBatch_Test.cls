@isTest
public class Aero_leadMQLSALReminderBatch_Test {
@isTest
    public static void testmqlstatuspositive(){
        Profile pf= [Select Id from profile where Name='Sales BD']; 
        
        User uu=new User(firstname = 'Robert', 
                         lastName = 'Buddecke', 
                         email = 'testbatchmsp1@test.org', 
                         Username ='testbatchmsp+1@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp1',
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        insert uu;
        
        Account acc=new Account();
        acc.name='testacc';
        insert acc;
        
        contact con=new contact();
        con.lastname='msptest';
        con.Primary_Email_Address__c='test@test1.com';
        con.Accountid=acc.id;
        insert con;
        
        Lead ld=new Lead();
        ld.ownerid=uu.id;
        ld.LastName='test lead1';
        ld.Company='Open';
        ld.ATR_Product_Information__c='test info';
        ld.MQL_Date__c = date.today()-20;
        ld.SAL_Date__c = date.today()-2;
        //ld.Days_in_MQL_Status__c='03-10 Days';
        ld.Lead_Description__c='test desc';
        //ld.Name='test mail';
        insert ld;
        
        test.startTest();
        Aero_leadMQLSALReminderBatch idone1=new Aero_leadMQLSALReminderBatch();
        database.executeBatch(idone1);
        test.stopTest();
        
     }
    
    @isTest
    public static void testmqlstatusnegative(){
        Profile pf= [Select Id from profile where Name='Sales BD']; 
        
        User uu=new User(firstname = 'Robert', 
                         lastName = 'Buddecke', 
                         email = 'testbatchmsp1@test.org', 
                         Username ='testbatchmsp+1@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp1',
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        insert uu;
        
        Account acc=new Account();
        acc.name='testacc';
        insert acc;
        
        contact con=new contact();
        con.lastname='msptest';
        con.Primary_Email_Address__c='test@test1.com';
        con.Accountid=acc.id;
        insert con;
        
        Lead ld=new Lead();
        ld.ownerid=uu.id;
        ld.LastName='test lead1';
        ld.Company='Open';
        //ld.ATR_Product_Information__c='test info';
        ld.MQL_Date__c = date.today()-20;
        ld.SAL_Date__c = date.today()-2;
        //ld.Days_in_MQL_Status__c='03-10 Days';
        //ld.Lead_Description__c='test desc';
        //ld.Name='test mail';
        insert ld;
        
        test.startTest();
        Aero_leadMQLSALReminderBatch idone1=new Aero_leadMQLSALReminderBatch();
        database.executeBatch(idone1);
        test.stopTest();
        
     }
    @isTest
    public static void testsalstatuspositive(){
        Profile pf= [Select Id from profile where Name='Sales BD']; 
        
        User uu=new User(firstname = 'Robert', 
                         lastName = 'Buddecke', 
                         email = 'testbatchmsp1@test.org', 
                         Username ='testbatchmsp+1@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp1',
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        insert uu;
        
        Account acc=new Account();
        acc.name='testacc';
        insert acc;
        
        contact con=new contact();
        con.lastname='msptest';
        con.Primary_Email_Address__c='test@test1.com';
        con.Accountid=acc.id;
        insert con;
        
        Lead ld=new Lead();
        ld.ownerid=uu.id;
        ld.LastName='test lead2';
        ld.Company='Open';
        ld.SQL_Date__c = date.today()-2;
        //ld.MQL_Date__c = date.today()-60;
        ld.SAL_Date__c = date.today()-30;
        ld.ATR_Product_Information__c='test info';
        //ld.Days_in_MQL_Status__c='03-10 Days';
        ld.Lead_Description__c='test desc';
        //ld.Name='test mail';
        insert ld;
        
        test.startTest();
        Aero_leadMQLSALReminderBatch idone1=new Aero_leadMQLSALReminderBatch();
        database.executeBatch(idone1);
        test.stopTest();
        
     }
    @isTest
    public static void testsalstatusnegative(){
        Profile pf= [Select Id from profile where Name='Sales BD']; 
        
        User uu=new User(firstname = 'Robert', 
                         lastName = 'Buddecke', 
                         email = 'testbatchmsp1@test.org', 
                         Username ='testbatchmsp+1@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp1',
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        insert uu;
        
        Account acc=new Account();
        acc.name='testacc';
        insert acc;
        
        contact con=new contact();
        con.lastname='msptest';
        con.Primary_Email_Address__c='test@test1.com';
        con.Accountid=acc.id;
        insert con;
        
        Lead ld=new Lead();
        ld.ownerid=uu.id;
        ld.LastName='test lead2';
        ld.Company='Open';
        ld.SQL_Date__c = date.today()-2;
        //ld.MQL_Date__c = date.today()-60;
        ld.SAL_Date__c = date.today()-30;
        //ld.ATR_Product_Information__c='test info';
        //ld.Days_in_MQL_Status__c='03-10 Days';
        //ld.Lead_Description__c='test desc';
        //ld.Name='test mail';
        insert ld;
        
        test.startTest();
        Aero_leadMQLSALReminderBatch idone1=new Aero_leadMQLSALReminderBatch();
        database.executeBatch(idone1);
        test.stopTest();
        
     }
}