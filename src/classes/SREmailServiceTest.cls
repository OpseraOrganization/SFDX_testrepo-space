@isTest(seeAlldata=true)
public class SREmailServiceTest{    
    static testMethod void TestSREmailService()    
    {        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Unauthorized Dist/Brkr';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';
        insert acc;
        Contact con = new Contact();

        con.LastName = 'Testcon';
        con.FirstName = 'test';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'test.test1@nttdata.com';
        con.Email='test.test1@nttdata.com';
        insert con;
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'BGA Service Request';
        email.fromAddress = 'Fanita.Nathireddy@honeywell.com';
        email.plaintextbody='Service Request Deliverable';
        Service_Request__c sr=new Service_Request__c();
        sr.Subject__c=email.subject;
        
        sr.Customer_Due_Date_BGA_S__c=system.now();
        sr.HON_Commit_Date_BGA__c=system.now();
      
        sr.Contact_Name__c = con.id;

         sr.IsAttachment__c=true;
         //sr.recordtypeid='012e00000000aln';
         //sr.Contact_Name__c='003e000000OQfZg';
         insert sr;
         
         //Text attachment
         Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
         attachmenttext.body = 'my attachment text';
         attachmenttext.fileName = 'textfiletwo3.txt'; 
         attachmenttext.mimeTypeSubType = 'texttwo/plain';
         email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext }; 
         
         //Binary Attachment
         Messaging.InboundEmail.BinaryAttachment attachmentbinary = new Messaging.InboundEmail.BinaryAttachment();
         attachmentbinary.body = blob.valueOf('my attachment binary file');
         attachmentbinary.fileName = 'textfileone.txt';
         attachmentbinary.mimeTypeSubType = 'text/plain';
         email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachmentbinary };

         SREmailService ti=new SREmailService(); 
         ti.handleInboundEmail(email,env); 
         
     }
     static testMethod void TestSREmailService1()    
    { 
        Account acc= new Account(name='Test Account');
        insert acc;
         Profile ProfRec1 = [select name from Profile where name = 'D&S Sales API User'];

        User usr = new User(LastName = 'Test User',Username = 'testuser@test31.com.honeywell',Email = 'testuser@test.com',Alias = 't3user1' ,CommunityNickname= 't3user1' ,TimeZoneSidKey   = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec1.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole');
        insert usr;
        Service_Request__c sr=new Service_Request__c(Ownerid=usr.id,Account_Name__c=acc.id);
        insert sr;
        Service_Request__c SRlist=[select id,name from Service_Request__c where id=:sr.id];
        string name='SR#'+SRlist.Name;
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();

        //string ggpnumber = 'GGP-00801';
        //Go_green_plan__c[]   ggp=[select id,Name,ownerId from Go_green_plan__c where name=:gp.name];

        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfile.txt';
        attachment.mimeTypeSubType = 'text/plain';
     
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
        //email.subject = 'GGP#GGP-00801';
         email.subject = name;
         email.PlainTextBody = 'test';
           SREmailService  emailProcess = new  SREmailService();
         emailProcess.handleInboundEmail(email, envelope);
    }
}