@isTest

private class DeleteNotAllowedTest{
static testmethod void DeleteNotAllowed_TstCls(){


Account acc= new Account(name='Test Account');
 insert acc;
 
 //creating contact;
 Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='T123567' );
 insert cont;


Case cases29=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
//No_FCR_Reason__c='Not Trained',For Ticket INC000009687923 
 Type='Order',Supported_Product__c='Radio',Origin = 'Email-deferredordersweb');
 insert cases29; 

EmailMessage Emlmsgrec=new EmailMessage();
Emlmsgrec.ParentId=cases29.id;
Emlmsgrec.Incoming=false;
Emlmsgrec.BccAddress='Sofiya.peermohamed@nttdata.com';
Emlmsgrec.ToAddress = 'test@test.com';
insert Emlmsgrec;

//Profile ProfRec = [select name from Profile where name = 'Honeywell System Administrator (Non US)'];
Profile ProfRec = [select name from Profile where name = 'Honeywell System Administrator'];

User userRec = new User(LastName = 'Test User',Username = 'testuser@test566.com.honeywell',Email = 'testuser@test.com',Alias = 't7user5' ,CommunityNickname= 't3user' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec.Id, LanguageLocaleKey = 'en_US',Functional_Role__c='testrole');
insert userRec;

system.runas(userRec)
{
try
{
delete Emlmsgrec;
}
catch(System.DMLException e){
System.debug('Exception '+e);
      }


}

}

}