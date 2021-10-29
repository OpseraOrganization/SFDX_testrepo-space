@istest
public class CaseOwnerNotificationTest {

    @istest
    public static void sendCaseNotificationToOwnerTest(){
             List<Country__c> lstCountry = SObjectFactory.create(
            1, Country__c.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Country__c.OwnerId => UserInfo.getUserId(),
                Country__c.Name => 'USA',
                Country__c.SFDC_Country_Name__c => 'USA'
                }
             );
             List<Account> lstAccount = SObjectFactory.create(
            1, Account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                Account.OwnerId => UserInfo.getUserId(),
                Account.Name => 'Test Account', 
                Account.Type => 'OEM',
                Account.Country__c => lstCountry[0].Id,
                Account.Customer_Status__c => 'Active',
                Account.Strategic_Business_Unit__c => 'ATR',
                Account.CBT__c => 'Airbus',
                Account.CBT_Team__c => 'None',
                Account.Region_Name__c => 'Americas',
                Account.Market_Name__c => 'Marine',
                Account.Service_Level__c => 'Standard',
                Account.REPORT_ACCOUNT_NAME__c => 'test Account New',
                Account.Stop_to_Send_Surveys__c => 'test'
            }
        );
        List<Contact> lstContact = SObjectFactory.build(1,Contact.sObjectType);

               lstContact[0].LastName = 'Test';
               lstContact[0].FirstName = 'Contact';
               lstContact[0].AccountId = lstAccount[0].Id;
               lstContact[0].Primary_Email_Address__c = 'gatotuka@in.ibm.com';
               //lstContact[0].Last_Survey_Date__c = Date.parse('12/16/15');
               lstContact[0].Last_Survey_Date__c = system.Today()-90;
               lstContact[0].Email = 'test0@in.ibm.com';
               lstContact[0].Survey_Opt_Out__c = false;
               lstContact[0].NPS_Survey__c = 'No';
               
               insert lstContact;
               
        Case c=new case();
        c.subject='test subject';
        c.RecordTypeId=schema.sobjecttype.case.getRecordtypeInfosByName().get('Technical Issue').getrecordtypeId();
        c.contactid=lstContact[0].id;
        insert c;
        emailmessage em=new emailmessage();
        em.subject='test subject';
        em.htmlbody='test description';
        em.parentid=c.id;
        em.Incoming=true;
        insert em;
        list<emailmessage> listem=new List<EmailMessage>();
        listem.add(em);
        CaseOwnerNotification.sendCaseNotificationToOwner(listem);
    }
}