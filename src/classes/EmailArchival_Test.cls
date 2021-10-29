@isTest
public class EmailArchival_Test {
    @testSetup
    public static void testSetupMethod(){
        
        User u = new User(
            profileId=[select id from profile where name='API DATA LOAD'].id,
            firstname='test user',
            lastname='api',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert u;
    }
    
    @isTest
    public static void EmailArchivalTest(){
        user dataLoadUser=[select id from user where firstname='test user' and lastname='api' limit 1];
            Archival_date__c ar=new Archival_date__c(name=dataLoadUser.id,Object_Name__c='Case',From_Date__c=system.now(),To_date__c=system.now().addDays(5));
            insert ar;
        system.runAs(dataLoadUser){
            List<Case> caselist=new List<Case>();
            Contact con = new contact();
            con.Email = 'test@xyz.org';
            con.LastName = 'test';
            insert con; 
            archival_settings__c setting=new archival_settings__c(name='test',indexNumber__c=0);
            insert setting;
            setting.record_id__c=setting.id;
            update setting;
            Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Internal Escalations').getRecordTypeId();
            //Insert test case record
            Case c = new Case();
            c.recordtypeid=RecordTypeIdCase;
            //c.contactId =con.id;
            c.Subject = 'Om Test';  
            c.Status ='New';
            c.Priority = 'Medium';
            c.UFR_Standard_Price_Amount__c =12;
            c.Origin = 'Email';
            insert c;
            List<EmailMessage> emlist=new list<emailMessage>();
            //Insert emailmessage for case
            EmailMessage email = new EmailMessage();
            email.FromAddress = 'test@abxc.org';
            email.Incoming = false;
            email.ToAddress= 'test@xyxz.org';
            email.Subject = 'Repair & Overhaul ADVN Notification to Portal Customers';
            email.HtmlBody = 'Test email body';
            email.ParentId = c.Id; 
            email.status = '3';
            emlist.add(email);
            for(integer i=0;i<12;i++)
            {
                EmailMessage email2 = email.clone();
                emlist.add(email2);
            }
            insert emlist;
            /*list<attachment> attList=new List<Attachment>();
            for(emailmessage em:emlist){
            
            Attachment att=new Attachment();
            att.body=Blob.valueOf('test');
            att.ParentId=em.id;
            att.Name='testfile.txt';
            att.contentType='txt';
            attlist.add(att);
            }
            insert attlist;  */
            test.starttest();

            Database.executeBatch(new parentCaseIdBatch(),200);
            setting.name=dataLoadUser.id;
            update setting;
            Database.executeBatch(new parentCaseIdBatch(),200);
            test.stoptest();
        }
        
    }
    
    
    @isTest
    public static void EmailArchivalTest2(){ 
        user dataLoadUser=[select id from user where firstname='test user' and lastname='api' limit 1];
        Archival_date__c ar=new Archival_date__c(name='Att' +dataLoadUser.id,Object_Name__c='Case',From_Date__c=system.now(),To_date__c=system.now().addDays(5));
        insert ar;
        system.runAs(dataLoadUser){
            List<Case> caselist=new List<Case>();
            Contact con = new contact();
            con.Email = 'test@xyz.org';
            con.LastName = 'test';
            insert con; 
            Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Internal Escalations').getRecordTypeId();
            
            Case c = new Case();
            c.recordtypeid=RecordTypeIdCase;
            //c.contactId =con.id;
            c.Subject = 'Om Test';  
            c.Status ='New';
            c.Priority = 'Medium';
            c.UFR_Standard_Price_Amount__c =12;
            c.Origin = 'Email';
            insert c;
            EmailMessage email = new EmailMessage();
            email.FromAddress = 'test@abxc.org';
            email.Incoming = false;
            email.ToAddress= 'test@xyxz.org';
            email.Subject = 'Repair & Overhaul ADVN Notification to Portal Customers';
            email.HtmlBody = 'Test email body';
            email.ParentId = c.Id; 
            email.status = '3';
            insert email;
            Attachment att=new Attachment();
            att.body=Blob.valueOf('test');
            att.ParentId=email.id;
            att.Name='testfile.txt';
            att.contentType='txt';
            insert att;  
            //  List<EmailMessageArchive__b> emaList = [SELECT nameSpacePrefix.abbreviate(maxWidth)searchIndex__c,Archive_Id__c,Case__c,recordJSON__c,TextBody__c,From_Address__c,To_Address__c FROM EmailMessageArchive__b where SearchIndex__c=:SearchIndex];
            Savepoint sp = Database.setSavepoint();
            list<attachment> attlist=new list<attachment>();
            Archival_date__c dt=AttachToCaseController.getDate();
            List<Id> Idlist=new List<Id>();
            Attachment att2=att.clone();
            att2.id=null;
            att2.Body=Blob.valueOf('a'.repeat(1100000));
            att2.parentid=email.id;
            attlist.add( att2);
            insert attlist;
            test.startTest();
            AttachToCaseController.getAttachments(Idlist);
        }
        test.stoptest();
    }
    
     @isTest
    public static void EmailArchivalTest3(){ 
        user dataLoadUser=[select id from user where firstname='test user' and lastname='api' limit 1];
        Archival_date__c ar=new Archival_date__c(name='Att' +dataLoadUser.id,Object_Name__c='Case',From_Date__c=system.now(),To_date__c=system.now().addDays(5));
        insert ar;
        system.runAs(dataLoadUser){
            List<Case> caselist=new List<Case>();
            Contact con = new contact();
            con.Email = 'test@xyz.org';
            con.LastName = 'test';
            insert con; 
            Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Internal Escalations').getRecordTypeId();
            
            Case c = new Case();
            c.recordtypeid=RecordTypeIdCase;
            //c.contactId =con.id;
            c.Subject = 'Om Test';  
            c.Status ='New';
            c.Priority = 'Medium';
            c.UFR_Standard_Price_Amount__c =12;
            c.Origin = 'Email';
            insert c;
            EmailMessage email = new EmailMessage();
            email.FromAddress = 'test@abxc.org';
            email.Incoming = false;
            email.ToAddress= 'test@xyxz.org';
            email.Subject = 'Repair & Overhaul ADVN Notification to Portal Customers';
            email.HtmlBody = 'Test email body';
            email.ParentId = c.Id; 
            email.status = '3';
            insert email;
            Attachment att=new Attachment();
            att.body=Blob.valueOf('test');
            att.ParentId=email.id;
            att.Name='testfile.txt';
            att.contentType='txt';
            insert att;  
            //  List<EmailMessageArchive__b> emaList = [SELECT nameSpacePrefix.abbreviate(maxWidth)searchIndex__c,Archive_Id__c,Case__c,recordJSON__c,TextBody__c,From_Address__c,To_Address__c FROM EmailMessageArchive__b where SearchIndex__c=:SearchIndex];
            Savepoint sp = Database.setSavepoint();
            list<Id> emaillist=new list<Id>();
            emaillist.add(email.id);
            list<attachment> attlist=new list<attachment>();
            Archival_date__c dt=AttachToCaseController.getDate();
            List<Id> Idlist=new List<Id>();
            Attachment att2=att.clone();
            att2.id=null;
            att2.Body=Blob.valueOf('a'.repeat(1100000));
            att2.parentid=email.id;
            attlist.add( att2);
            insert attlist;
            test.startTest();
            map<Id,EmailMessage> emailmessageMap=new map<Id,EmailMessage>();
            emailMessageMap.put(email.id,email);
            system.enqueuejob(new AttachToCaseQueueable(attlist,emailMessageMap,emaillist));
            system.enqueuejob(new AttachToCaseQueueable(attlist,null,emaillist));
        }
        test.stoptest();
    }
    
    @istest
    public static void emailUnarchivalTest(){
        user dataLoadUser=[select id from user where firstname='test user' and lastname='api' limit 1];
        Archival_date__c ar=new Archival_date__c(name=dataLoadUser.id,Object_Name__c='Case',From_Date__c=system.now(),To_date__c=system.now().addDays(5));
        insert ar;
        system.runAs(dataLoadUser){
            Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Internal Escalations').getRecordTypeId();
            Case c = new Case();
            c.recordtypeid=RecordTypeIdCase;
            //c.contactId =con.id;
            c.Subject = 'Om Test';  
            c.Status ='New';
            c.Priority = 'Medium';
            c.UFR_Standard_Price_Amount__c =12;
            c.Origin = 'Email';
            c.email_Archive_indexes__c='1;';
            insert c;
            emailUnarchivalLight.getBatchStatus();
            emailUnarchivalLight.unarchiveEmailMessages([select casenumber from case where id=:c.id].casenumber);
        }
    }
}