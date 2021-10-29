@isTest
private class ShowRelatedlst_TestCls{ 

static testMethod void ShowRelatedlst_TM()
{
Account acc= new Account(name='Test Account');
 insert acc;

 //creating contact;
 Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567' );
 insert cont;

 
 //creating case
 Case cases=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
 //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
 Type='Order',status='Done');
 insert cases;
 
 Case cases2=new Case(AccountId=acc.Id,subject='Test Case',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
 //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
 Type='Order');
 insert cases2;
test.starttest();
emailmessage emlrec1=new emailmessage();
emlrec1.parentId=cases.id;
emlrec1.status='1';
emlrec1.Incoming=false;
emlrec1.ToAddress='testing@testing.com';
insert emlrec1;

emailmessage emlrec2=new emailmessage();
emlrec2.parentId=cases.id;
emlrec2.status='2';
emlrec2.Incoming=false;
emlrec2.ToAddress='testing@testing.com';
insert emlrec2;

emailmessage emlrec3=new emailmessage();
emlrec3.parentId=cases.id;
emlrec3.status='3';
emlrec3.Incoming=false;
emlrec3.ToAddress='testing@testing.com';
insert emlrec3;

emailmessage emlrec4=new emailmessage();
emlrec4.parentId=cases.id;
emlrec4.status='0';
emlrec4.Incoming=false;
emlrec4.ToAddress='testing@testing.com';
insert emlrec4;

emailmessage emlrec5=new emailmessage();
emlrec5.parentId=cases2.id;
emlrec5.status='1';
emlrec5.Incoming=false;
emlrec5.subject = 'Test Message';
emlrec5.ToAddress='testing@testing.com';
insert emlrec5;

ApexPages.StandardController controller= new ApexPages.StandardController(cases);
System.currentPagereference().getParameters().put('id', cases.id);
showrelatedlist showreltedlst=new showrelatedlist(controller);




showreltedlst.getdata();
showreltedlst.getallmodels();
 test.stoptest();
}


}