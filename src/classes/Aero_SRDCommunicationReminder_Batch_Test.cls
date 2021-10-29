@istest
public class Aero_SRDCommunicationReminder_Batch_Test {
    @istest
    public static void srdremtest1(){
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = 'testbatch@test.org', 
                         Username ='testbatch+1@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstbth1',
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        insert uu;
        
        
        Account acc=new Account();
        acc.Name='TestBatch';
        insert acc;
        
        SRD_Customer_Communication__c scc=new SRD_Customer_Communication__c();
        scc.ownerid=uu.id;
        scc.Attachment_Last_Modified__c=system.now();
        scc.Account__c=acc.id;
        insert scc;
        system.debug('scc is '+scc);
        system.debug('scc email id: '+scc.owner.email);
        
        test.startTest();
        scc.Attachment_Last_Modified__c=system.now()-25;
        update scc;
        Aero_SRDCommunicationReminder_Batch idone1=new Aero_SRDCommunicationReminder_Batch();
        database.executeBatch(idone1);
        test.stopTest();
        
    }
    @istest
    public static void srdremtest2(){
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'AB1C', 
                         lastName = 'XY1Z', 
                         email = 'testbatch2@test.org', 
                         Username ='testbatch+2@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstbth2',
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        insert uu;
        
        Account acc=new Account();
        acc.Name='TestBatch1';
        insert acc;
        
        SRD_Customer_Communication__c scc=new SRD_Customer_Communication__c();
        scc.ownerid=uu.id;
        scc.Attachment_Last_Modified__c=system.now();
        scc.Account__c=acc.id;
        insert scc;
        test.startTest();
        scc.Attachment_Last_Modified__c=system.now()-28;
        update scc;
        Aero_SRDCommunicationReminder_Batch idone1=new Aero_SRDCommunicationReminder_Batch();
        database.executeBatch(idone1);
        test.stopTest();
    }
    
    @istest
    public static void srdremtest3(){
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        User uu=new User(firstname = 'AB12C', 
                         lastName = 'XY12Z', 
                         email = 'testbatch21@test.org', 
                         Username ='testbatch+3@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstbth3',
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        insert uu;
        
        Account acc=new Account();
        acc.Name='TestBatch2';
        insert acc;
        
        SRD_Customer_Communication__c scc=new SRD_Customer_Communication__c();
        scc.ownerid=uu.id;
        scc.Attachment_Last_Modified__c=system.now();
        scc.Account__c=acc.id;
        insert scc;
        test.startTest();
        scc.Attachment_Last_Modified__c=system.now()-30;
        update scc;
        Aero_SRDCommunicationReminder_Batch idone1=new Aero_SRDCommunicationReminder_Batch();
        database.executeBatch(idone1);
        test.stopTest();
    }
    
    @istest
    public static void srdremtest4(){
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
         User uu1=new User(firstname = 'ABmgrC', 
                         lastName = 'XYmgrZ', 
                         email = 'testbatchmgr@test.org', 
                         Username ='testbatchmgr@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tthmgr',
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        insert uu1;
        
        User uu=new User(firstname = 'AB4C', 
                         lastName = 'XY4Z', 
                         email = 'testbatch4@test.org', 
                         Username ='testbatch+4@test.org', 
                         EmailEncodingKey = 'ISO-8859-1',
                         Alias='tstbth4',
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id,
                         ManagerId=uu1.id
                        ); 
        insert uu;
        
        Account acc=new Account();
        acc.Name='TestBatch4';
        insert acc;
        
        SRD_Customer_Communication__c scc=new SRD_Customer_Communication__c();
        scc.ownerid=uu.Id;
        scc.Attachment_Last_Modified__c=system.now();
        scc.Account__c=acc.id;
        insert scc;
        test.startTest();
        scc.Attachment_Last_Modified__c=system.now()-31;
        update scc;
        Aero_SRDCommunicationReminder_Batch idone1=new Aero_SRDCommunicationReminder_Batch();
        database.executeBatch(idone1);
        test.stopTest();
    }
    
}