@isTest
public  class Test_ApexTrigger_User
{
static testmethod void ApexTrigger_User()
{
Account a1 = New Account(Name= 'sbuaccount', Strategic_Business_Unit__c = 'D&S',CBT__c = 'Advanced Technology', CBT_Team__c='ASM: Advanced Sensors & Microsystems',CBT_Directorate__c='Advanced Sensing Technology');
insert a1;
Contact c1 = new Contact(lastname='Sumitha',firstname='Test',accountId=a1.Id,
Contact_Is_Employee__c=false,Phone_3__c ='9986555678',Honeywell_ID__c ='6776');
insert c1;
/*Profile pf= [select id from Profile where name = 'Custom Customer Portal'];
User u1 = new User(LastName = 'Test User787',Username = 'tu1787@test.com',Email = 'testuser@test.com',Alias = 'tu1787' ,CommunityNickname= 'tu1787' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',contactid=c1.Id);
insert u1;
*/

User u1;
        List<User> lstU1 = [select id from user where profileid = '00e30000001Y4ARAA0' and IsActive =true];
        if(lstU1!=null && lstU1.size() > 0)
        {
            u1=lstu1[0];
        }
        else
        {
            u1=new User (id=userinfo.getuserid());
        }
        
        
Contact c2 = new Contact(lastname='Sumitha',firstname='Test',accountId=a1.Id,
Contact_Is_Employee__c=false,Phone_3__c ='9986555678');
insert c2;

/*User u2 = new User(LastName = 'Test User78788',Username = 'tu178788@test.com',Email = 'testuser@test.com',Alias = 'tu178788' ,CommunityNickname= 'tu178788' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S',contactid=c2.Id);
try
{
insert u2;
}
catch(System.DMLException e){System.assert(e.getMessage().contains(
                'Please enter Honeywell Id in Contact Record'),
                  e.getMessage());
      }*/
}
}