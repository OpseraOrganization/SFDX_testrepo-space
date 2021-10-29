@isTest(seealldata=true)
public class TestGGPEmailservice{
static testmethod void GGPEmailservicetest(){

    Account acc= new Account(name='Test Account');
    insert acc;

   Profile ProfRec1 = [select name from Profile where name = 'D&S Sales API User'];

    User usr = new User(LastName = 'Test User',Username = 'testuser@test31.com.honeywell',Email = 'testuser@test.com',Alias = 't3user1' ,CommunityNickname= 't3user1' ,TimeZoneSidKey   = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec1.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole');
insert usr;

   Go_Green_Plan__c gp= new Go_Green_Plan__c (Go_Green_Status__c='TestP',account__c=acc.Id, Prod_LN_Prgm_Product_LIne__c='APU', GGP_Status_del__c='open', Interviewer_Name__c=usr.id);
    insert gp;

   Go_Green_Plan__c gplist=[select id,name from Go_Green_Plan__c where id=:gp.id];

     string name='GGP#'+gplist.Name;
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
     GGPEmailservice  emailProcess = new GGPEmailservice();
     emailProcess.handleInboundEmail(email, envelope);
}
}