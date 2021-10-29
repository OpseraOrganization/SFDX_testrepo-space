@isTest
public class RDF_EmailAttachmentSeriviceHandler_Test{
    static testmethod void inboundemail(){
        
        Account acc = new Account();
        acc.Name ='TestAccount';
        acc.Customer_Status__c ='Active';
        insert acc;
        
       List<Contract> contractList = new List<Contract> ();
        Contract con = new Contract();
        con.Type__c ='APM';
        con.Contract_Number_I_Many__c ='1232132132';
        con.Asset_Program__c='No';
        con.Status='Draft';
        con.StartDate = system.today();
        con.End_date_Required__c ='No';
       // con.Revision__c=2;
       // con.CurrencyIsoCode = 'U.S. Dollar';        
        con.Currency__c='USD';
        con.AccountId = acc.Id;
        con.RPEmail__c = 'test123@gmail.com';
       contractList.add(con); 
        insert contractList;     
         
        
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Messaging.InboundEmail.BinaryAttachment inboundAttachment = new Messaging.InboundEmail.BinaryAttachment();
        
        email.subject = '[ref:'+contractList[0].Contract_Number_I_Many__c+']';      
        email.htmlBody= 'Approved';
        email.PlainTextBody='Approved';
        env.fromAddress = contractList[0].RPEmail__c ;
       
         Customer_Emails__c custEmails = new Customer_Emails__c();
         custEmails.From_Name__c = email.fromName;
         custEmails.From_Address__c = email.fromAddress;
         custEmails.To_Address__c = String.ValueOf(email.toAddresses);
         custEmails.Contract__c = contractList[0].Id;
         custEmails.Content_body__c = email.htmlBody;
         custEmails.has_Attachment__c= false;
        
        insert custEmails;
       
       
        inboundAttachment.body = blob.valueOf('test');
        inboundAttachment.fileName = 'Email_Attachment.txt';
        inboundAttachment.mimeTypeSubType = 'text/plain';
        
        List<Attachment> listTextAttachment = new List<Attachment>();  
            Attachment att1 = new Attachment();                             
            att1.Name = email.subject;
            att1.Body = blob.valueOf(email.htmlBody);
            att1.ParentId = custEmails.id;            
         listTextAttachment.add(att1);
        
        insert listTextAttachment;
        
          Messaging.InboundEmail.TextAttachment attachmenttext = new Messaging.InboundEmail.TextAttachment();
          attachmenttext.body = 'my attachment text';
          attachmenttext.fileName = 'textfiletwo3.txt';
          attachmenttext.mimeTypeSubType = 'texttwo/plain';
          email.textAttachments =   new Messaging.inboundEmail.TextAttachment[] { attachmenttext };
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { inboundAttachment };             
        
        Test.startTest();
        RDF_EmailAttachmentSeriviceHandler esh = new RDF_EmailAttachmentSeriviceHandler();
        esh.handleInboundEmail(email,env);
        
        Messaging.InboundEmail email1 = new Messaging.InboundEmail();
        email1.subject = '[ref:'+contractList[0].Contract_Number_I_Many__c+']';
        email1.plainTextBody='test';
        Messaging.InboundEnvelope env1 = new Messaging.InboundEnvelope();
        RDF_EmailAttachmentSeriviceHandler esh1= new RDF_EmailAttachmentSeriviceHandler();
        esh1.handleInboundEmail(email1,env1);
        Test.stopTest();
    }
    
        
}