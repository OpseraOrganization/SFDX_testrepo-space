@isTest
public class SIPFieldsAutoPopulate_Test
{
    public static testmethod void SIPFieldsAutoPopulate_Method()
    {
        Profile[] ProfRec = [select id,name from Profile limit 1];
        if (ProfRec.size() > 0) {
        User userRec = new User(LastName = 'Test User',Username = 'testuser@test3.com.honeywell',Email = 'testuser@test.com',Alias = 't3user' ,CommunityNickname= 't3user' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec[0].Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole');
        insert userRec;
        
        test.starttest();
        SIP_Tickets__c sip = new SIP_Tickets__c ();
        sip.RecordTypeId = System.label.SIP_Ticket;
        sip.Reason_for_Request__c = 'General Issue';
        sip.Ticket_on_behalf_of__c = userRec.id;
        sip.Amount__c = 500.00;
        insert sip;
        test.stopTest();
        }
    }
}