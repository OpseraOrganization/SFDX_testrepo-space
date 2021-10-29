@isTest
private class sendmailclass_detail_TestCls1{ 

static testMethod void sendmailclass_detail_TM1()
{

Account acc= new Account(name='Test Account');
 insert acc;

 //creating contact;
 Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567' );
 insert cont;

 //creating case
 
 test.starttest();
 Case cases=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
 //No_FCR_Reason__c='Not Trained', For Ticket INC000009687923
 Type='Order');
 insert cases;



emailmessage emlrec2=new emailmessage();
emlrec2.parentId=cases.id;
emlrec2.status='2';
emlrec2.ToAddress='test@test.com';
emlrec2.Incoming=False;
insert emlrec2;

emailmessage emlrec3=new emailmessage();
emlrec3.parentId=cases.id;
emlrec3.status='3';
emlrec3.ToAddress='test@test.com';
emlrec3.Incoming=False;
insert emlrec3;

emailmessage emlrec4=new emailmessage();
emlrec4.parentId=cases.id;
emlrec4.status='0';
emlrec4.ToAddress='test@test.com';
emlrec4.Incoming=False;
insert emlrec4;




emailmessage emlrec1=new emailmessage();
emlrec1.parentId=cases.id;
emlrec1.status='1';
emlrec1.FromAddress='anila.francis@wipro.com';
emlrec1.ToAddress='anila.francis@wipro.com';
emlrec1.INCOMING=True;

insert emlrec1;
//sendmailclass_detail1 controller = new thecontroller();




  PageReference pageRef1 = Page.SendMailPage_detailHTML;
  Test.setCurrentPage(pageRef1);

pageRef1.getParameters().put('id', emlrec1.id);
pageRef1.getParameters().put('caseid', cases.id);

sendmailclass_detail1 sendmailDetl= new sendmailclass_detail1();

// ApexPages.currentPage().getParameters().put('qp', 'yyyy');

//sendmailclass_detail1 sendmailDetl=new sendmailclass_detail1();



sendmailDetl.getemssg();

 test.stoptest();
}



}