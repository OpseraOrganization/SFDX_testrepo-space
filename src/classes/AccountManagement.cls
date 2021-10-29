@istest
public  class AccountManagement
{
static testmethod void EventAccountManagement()
{
Event__c ev1 = new Event__c(Name = 'Test Event1');
insert ev1;
Event__c ev2 = new Event__c(Name = 'Test Event2');
insert ev2;
Event__c ev3 = new Event__c(Name = 'Test Event3');
insert ev3;
Event__c ev4 = new Event__c(Name = 'Test Event4');
insert ev4;
Contact cnt1 = new Contact(LastName = 'Test contact',firstname='Test',Contact_Is_Employee__c =True,Functional_Role__c='testrole',phone_3__c='89652', Employee_Contact_Role__c='Analyst',Employee_Number__c='E121567',Primary_Email_Address__c='testuser@test.com',Contact_Function__c='Accident Investigator' );
insert cnt1;
cnt1.Functional_Role__c='testrolesupdate';
update cnt1;
Profile pf= [select id from Profile where name = 'D&S Sales'];
User u1 = new User(LastName = 'Test User',Username = 'testuser@test.com.honeywell',Email = 'testuser@test.com',Alias = 'tuser' ,CommunityNickname= 'tuser' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testroleuser',Primary_Manager_EID__c='H123456',Primary_Manager_Name__c='test Manager');
insert u1;
u1.Functional_Role__c='testroleupdate';
update u1;
User u2 = new User(LastName = 'Test User 2 ',Username = 'test213@test.com.honeywell',Email = 'testuser2@test.com',Alias = 'tuser2' ,CommunityNickname= 'tuser2' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US');
insert u2;

Event_Team__c ct1 = new Event_Team__c(Event__c = ev1.Id,Contact__c = cnt1.Id);
Event_Team__c ct2 = new Event_Team__c(Event__c = ev1.Id,User__c = u1.Id);
List<Event_Team__c> ctlist = new List<Event_Team__c>();
List<Event_Team__c> ctlist1 = new List<Event_Team__c>();
List<Event_Team__c> ctlist2 = new List<Event_Team__c>();
ctlist.add(ct1);
ctlist.add(ct2);
insert ctlist;
Event_Team__c ct8 = new Event_Team__c(Event__c = ev1.Id,User__c = u1.Id);
Event_Team__c ct9 = new Event_Team__c(Event__c = ev1.Id,User__c = u1.Id);
ctlist1.add(ct8);
ctlist1.add(ct9);
try
{
insert ctlist1;
}
catch(System.DMLException e){System.assert(e.getMessage().contains(
                'This User is already an Event Team Member'),
                  e.getMessage());
      }
Event_Team__c ct10 = new Event_Team__c(Event__c = ev1.Id,Contact__c = cnt1.Id);
Event_Team__c ct11 = new Event_Team__c(Event__c = ev1.Id,Contact__c = cnt1.Id);
ctlist2.add(ct10);
ctlist2.add(ct11);
try
{
insert ctlist2;
}
catch(System.DMLException e){System.assert(e.getMessage().contains(
                'This Contact is already an Event Team Member'),
                  e.getMessage());
      }

Event_Team__c ct3 = new Event_Team__c(Event__c = ev2.Id,Contact__c = cnt1.Id);
insert ct3;
Event_Team__c ct4 = new Event_Team__c(Event__c = ev2.Id,Contact__c = cnt1.Id);
try
{
insert ct4;
}
catch(System.DMLException e){System.assert(e.getMessage().contains(
                'This Contact is already an Event Team Member'),
                  e.getMessage());
      }
Event_Team__c ct5 = new Event_Team__c(Event__c = ev3.Id,User__c = u1.Id);
insert ct5;
Event_Team__c ct6 = new Event_Team__c(Event__c = ev3.Id,User__c = u2.Id);
insert ct6;
Event_Team__c ct7 = new Event_Team__c(Event__c = ev3.Id,User__c = u2.Id);
try
{
insert ct7;
}
catch(System.DMLException e){System.assert(e.getMessage().contains(
                'This User is already an Event Team Member'),
                  e.getMessage());
      }
}

}



/*global class AccountManagement
 {

    global class AccountRequest 
        {
            WebService String a;
            WebService String b;
            WebService String c;
        }
        
    WebService static String insertSiebelId(AccountRequest s) 
        {
            System.debug('From Java Application'+s);
           // String AccName=s;
           
           String s1=s.a;
                      String s2=s.b;
                                 String s3=s.c;
            
    //    AccName='Appenede'+AccName;
            return s1+s2+s3;
        }
        WebService static void publishAccount(String s) 
        {
            try 
            {
                System.debug('Publish Account  -- > '+s);
        //WeblogicClass.TestSFDCSoap wb =new WeblogicClass.TestSFDCSoap();
        //wb.testSFDCMethod('From SFDC :> '+s);
        System.debug('Publish Account Completes  -- > '+s);
            }
            catch (Exception e)
            {
                System.debug('Exception  -- > '+e);
            }
            
        }
        
}*/