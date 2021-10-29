@istest
public class Aero_MSPAvionicsReminderBatch_Test {
    @istest 
    public static void testm1(){
        Profile pf= [Select Id from profile where Name='System Administrator']; 
                Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();

        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
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
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        
        cas.Type='HAPP Renewal';
        cas.Status='Open';
        cas.recordtypeid=RecordTypeIdCase;
        cas.Contract_Number__c='12345';
        cas.Contract_End_Date__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Contract_End_Date__c=date.today()+30; 
        cas.Sub_Status__c='1st Follow-up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone1=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone1);
        test.stopTest();
        
    }
     @istest 
    public static void testm1negative(){
        Profile pf= [Select Id from profile where Name='System Administrator']; 
                Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();

        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
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
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='HAPP Renewal';
        cas.Status='Open';
       // cas.Contract_Number__c='12345';
        cas.Contract_End_Date__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Contract_End_Date__c=date.today()+30;
        cas.Sub_Status__c='1st Follow-up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone1=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone1);
        test.stopTest();
        
    }
    @istest
    public static void testm2(){
        Profile pf= [Select Id from profile where Name='System Administrator']; 
                Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();

        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp2@test.org', 
                         Username ='testbatchmsp+2@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp2',
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
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='HAPP Renewal';
        cas.Status='Open';
        cas.Contract_Number__c='12345';
        cas.Contract_End_Date__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Contract_End_Date__c=date.today()+10;
        cas.Sub_Status__c='2nd Follow-up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone2=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone2);
        test.stopTest();
    }
    
    @istest
    public static void testm2negative(){
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp2@test.org', 
                         Username ='testbatchmsp+2@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp2',
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
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='HAPP Renewal';
        cas.Status='Open';
        //cas.Contract_Number__c='12345';
        cas.Contract_End_Date__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Contract_End_Date__c=date.today()+10;
        cas.Sub_Status__c='2nd Follow-up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone2=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone2);
        test.stopTest();
    }
    @istest
    public static void testm3(){
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp3@test.org', 
                         Username ='testbatchmsp+3@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp3',
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
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='2nd YR HAPP';
        cas.Status='Open';
        cas.Contract_Number__c='12345';
        cas.Contract_End_Date__c=date.today();
        cas.ContactId=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Contract_End_Date__c=date.today()+30;
        cas.Sub_Status__c='1st Follow-up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone3=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone3);
        test.stopTest();
    }
    
    @istest
    public static void testm3negative(){
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp3@test.org', 
                         Username ='testbatchmsp+3@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp3',
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
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='2nd YR HAPP';
        cas.Status='Open';
        cas.Contract_End_Date__c=date.today();
        cas.ContactId=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Contract_End_Date__c=date.today()+30;
        cas.Sub_Status__c='1st Follow-up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone3=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone3);
        test.stopTest();
    }
    
    @istest
    public static void testm4(){
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp4@test.org', 
                         Username ='testbatchmsp+4@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp4',
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
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='2nd YR HAPP';
        cas.Status='Open';
        cas.Contract_Number__c='12345';
        cas.Contract_End_Date__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Contract_End_Date__c=date.today()+10;
        cas.Sub_Status__c='2nd Follow-up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
    
     @istest
    public static void testm4negative(){
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();

        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp4@test.org', 
                         Username ='testbatchmsp+4@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp4',
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
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='2nd YR HAPP';
        cas.Status='Open';
        //cas.Contract_Number__c='12345';
        cas.Contract_End_Date__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Contract_End_Date__c=date.today()+10;
        cas.Sub_Status__c='2nd Follow-up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
   
    
     @istest
    public static void testm5(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();

        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp4@test.org', 
                         Username ='testbatchmsp+4@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp4',
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
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='HAPP Transfer';
        cas.Status='Open';
        cas.Contract_Number__c='12345';
        cas.Date_needed__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Date_needed__c=date.today()+15;
        cas.Sub_Status__c='1st Follow-up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
    
    @istest
    public static void testm5negative(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();

        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp4@test.org', 
                         Username ='testbatchmsp+4@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp4',
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
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='HAPP Transfer';
        cas.Status='Open';
        //cas.Contract_Number__c='12345';
        cas.Date_needed__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Date_needed__c=date.today()+15;
        cas.Sub_Status__c='1st Follow-up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
     @istest
    public static void testm6(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp4@test.org', 
                         Username ='testbatchmsp+4@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp4',
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
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='HAPP Transfer';
        cas.Status='Open';
        cas.Contract_Number__c='12345';
        cas.Date_needed__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Date_needed__c=date.today()+5;
        cas.Sub_Status__c='2nd Follow-up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
    
    @istest
    public static void testm6negative(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp4@test.org', 
                         Username ='testbatchmsp+4@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp4',
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
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='HAPP Transfer';
        cas.Status='Open';
        //cas.Contract_Number__c='12345';
        cas.Date_needed__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Date_needed__c=date.today()+5;
        cas.Sub_Status__c='2nd Follow-up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
     @istest
    public static void testm7(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp4@test.org', 
                         Username ='testbatchmsp+4@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp4',
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
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='MSPA Collections';
        cas.Status='Open';
        cas.Contract_Number__c='12345';
        cas.Contract_End_Date__c=date.today()-1;
        cas.contactid=con.id;
        cas.subject='test mail';
        cas.Receivable_Document__c='876543';
        insert cas;
        
        test.startTest();
        cas.Contract_End_Date__c=date.today()-1;
        cas.Sub_Status__c='1st Follow-up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    } 
   
     @istest
    public static void testm7negative(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp4@test.org', 
                         Username ='testbatchmsp+4@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp4',
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
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='MSPA Collections';
        cas.Status='Open';
        //cas.Contract_Number__c='12345';
        //cas.Contract_End_Date__c=date.today()-1;
        cas.contactid=con.id;
        cas.subject='test mail';
        //cas.Receivable_Document__c='876543';
        insert cas;
        
        test.startTest();
        cas.Contract_End_Date__c=date.today()-1;
        cas.Sub_Status__c='1st Follow-up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
         @istest
    public static void testm8(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp4@test.org', 
                         Username ='testbatchmsp+4@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp4',
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
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='MSPA Collections';
        cas.Status='Open';
        cas.Contract_Number__c='12345';
        cas.Contract_End_Date__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        cas.Receivable_Document__c='9876543';
        insert cas;
        
        test.startTest();
        cas.Contract_End_Date__c=date.today()-15;
        cas.Sub_Status__c='2nd Follow-up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
  @istest
    public static void testm8negative(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp4@test.org', 
                         Username ='testbatchmsp+4@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp4',
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
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='MSPA Collections';
        cas.Status='Open';
        //cas.Contract_Number__c='12345';
        //cas.Contract_End_Date__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        //cas.Receivable_Document__c='9876543';
        insert cas;
        
        test.startTest();
        cas.Contract_End_Date__c=date.today()-15;
        cas.Sub_Status__c='2nd Follow-up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
          
    @istest
    public static void testm9(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp4@test.org', 
                         Username ='testbatchmsp+4@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp4',
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
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='MSPA Collections';
        cas.Status='Open';
        cas.Contract_Number__c='12345';
        cas.Contract_End_Date__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        cas.Receivable_Document__c='87654';
        insert cas;
        
        test.startTest();
        cas.Contract_End_Date__c=date.today()-30;
        cas.Sub_Status__c='Final Notice Sent';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
    @istest
    public static void testm9negative(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('HAPP MPP Contracts').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp4@test.org', 
                         Username ='testbatchmsp+4@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp4',
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
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='MSPA Collections';
        cas.Status='Open';
        cas.Contract_Number__c='12345';
        //cas.Contract_End_Date__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        //cas.Receivable_Document__c='87654';
        insert cas;
        
        test.startTest();
        cas.Contract_End_Date__c=date.today()-30;
        cas.Sub_Status__c='Final Notice Sent';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
    @istest
    public static void testm10(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MSP Contract').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp5@test.org', 
                         Username ='testbatchmsp+5@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp5',
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
        con.lastname='msptest10';
        con.Primary_Email_Address__c='test@test10.com';
        con.Accountid=acc.id;
        insert con;
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='MSP Renewal Legacy';
        cas.Status='Open';
        cas.Contract_Number__c='12345';
        cas.Contract_End_Date__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Contract_End_Date__c=date.today()+30;
        cas.Sub_Status__c='1st Follow up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
    
     @istest
    public static void testm10negative(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MSP Contract').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp5@test.org', 
                         Username ='testbatchmsp+5@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp5',
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
        con.lastname='msptest10';
        con.Primary_Email_Address__c='test@test10.com';
        con.Accountid=acc.id;
        insert con;
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='MSP Renewal Legacy';
        cas.Status='Open';
        //cas.Contract_Number__c='12345';
        cas.Contract_End_Date__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Contract_End_Date__c=date.today()+30;
        cas.Sub_Status__c='1st Follow up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
   
    @istest
    public static void testm11(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MSP Contract').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp5@test.org', 
                         Username ='testbatchmsp+5@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp5',
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
        con.lastname='msptest10';
        con.Primary_Email_Address__c='test@test10.com';
        con.Accountid=acc.id;
        insert con;
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='MSP Renewal Legacy';
        cas.Status='Open';
        cas.Contract_Number__c='12345';
        cas.Contract_End_Date__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Contract_End_Date__c=date.today()+10;
        cas.Sub_Status__c='1st Follow up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
    
    @istest
    public static void testm11negative(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MSP Contract').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp5@test.org', 
                         Username ='testbatchmsp+5@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp5',
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
        con.lastname='msptest10';
        con.Primary_Email_Address__c='test@test10.com';
        con.Accountid=acc.id;
        insert con;
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='MSP Renewal Legacy';
        cas.Status='Open';
        //cas.Contract_Number__c='12345';
        cas.Contract_End_Date__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Contract_End_Date__c=date.today()+10;
        cas.Sub_Status__c='1st Follow up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
    
     @istest
    public static void testm12(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MSP Contract').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp5@test.org', 
                         Username ='testbatchmsp+5@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp5',
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
        con.lastname='msptest10';
        con.Primary_Email_Address__c='test@test10.com';
        con.Accountid=acc.id;
        insert con;
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='MSP Transfer';
        cas.Status='Open';
        cas.Contract_Number__c='12345';
        cas.Date_Needed__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Date_Needed__c=date.today()+60;
        cas.Sub_Status__c='1st Follow up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
   
     @istest
    public static void testm12negative(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MSP Contract').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp5@test.org', 
                         Username ='testbatchmsp+5@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp5',
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
        con.lastname='msptest10';
        con.Primary_Email_Address__c='test@test10.com';
        con.Accountid=acc.id;
        insert con;
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='MSP Transfer';
        cas.Status='Open';
        //cas.Contract_Number__c='12345';
        cas.Date_Needed__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Date_Needed__c=date.today()+60;
        cas.Sub_Status__c='1st Follow up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
   
    @istest
    public static void testm13(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MSP Contract').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp5@test.org', 
                         Username ='testbatchmsp+5@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp5',
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
        con.lastname='msptest10';
        con.Primary_Email_Address__c='test@test10.com';
        con.Accountid=acc.id;
        insert con;
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='MSP Transfer';
        cas.Status='Open';
        cas.Contract_Number__c='12345';
        cas.Date_Needed__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Date_Needed__c=date.today()+30;
        cas.Sub_Status__c='2nd Follow up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
  
    @istest
    public static void testm13negative(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MSP Contract').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp5@test.org', 
                         Username ='testbatchmsp+5@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp5',
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
        con.lastname='msptest10';
        con.Primary_Email_Address__c='test@test10.com';
        con.Accountid=acc.id;
        insert con;
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='MSP Transfer';
        cas.Status='Open';
        //cas.Contract_Number__c='12345';
        cas.Date_Needed__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Date_Needed__c=date.today()+30;
        cas.Sub_Status__c='2nd Follow up';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
     @istest
    public static void testm14(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MSP Contract').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp5@test.org', 
                         Username ='testbatchmsp+5@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp5',
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
        con.lastname='msptest10';
        con.Primary_Email_Address__c='test@test10.com';
        con.Accountid=acc.id;
        insert con;
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='MSP Transfer';
        cas.Status='Open';
        cas.Contract_Number__c='12345';
        cas.Date_Needed__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Date_Needed__c=date.today()+10;
        cas.Sub_Status__c='Final Notice Sent';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
  
     @istest
    public static void testm14negative(){
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MSP Contract').getRecordTypeId();

        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatchmsp5@test.org', 
                         Username ='testbatchmsp+5@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstmsp5',
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
        con.lastname='msptest10';
        con.Primary_Email_Address__c='test@test10.com';
        con.Accountid=acc.id;
        insert con;
        
        Case cas=new Case();
        cas.ownerid=uu.id;
        cas.recordtypeid=RecordTypeIdCase;
        cas.Type='MSP Transfer';
        cas.Status='Open';
        //cas.Contract_Number__c='12345';
        cas.Date_Needed__c=date.today();
        cas.contactid=con.id;
        cas.subject='test mail';
        insert cas;
        
        test.startTest();
        cas.Date_Needed__c=date.today()+10;
        cas.Sub_Status__c='Final Notice Sent';
        update cas;
        Aero_MSPAvionicsReminderBatch idone4=new Aero_MSPAvionicsReminderBatch();
        database.executeBatch(idone4);
        test.stopTest();
    }
  
    

}