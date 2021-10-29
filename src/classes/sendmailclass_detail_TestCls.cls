@isTest
private class sendmailclass_detail_TestCls{ 

static testMethod void sendmailclass_detail_TM()
{

Account acc= new Account(name='Test Account');
 insert acc;

 //creating contact;
 Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
  Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='H123567' );
 insert cont;

 //creating case
 Case cases=new Case(AccountId=acc.Id,subject='test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
 //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
 Type='Order');
 insert cases;


test.starttest(); 
list<emailmessage> eml=new list<emailmessage>();
emailmessage emlrec2=new emailmessage();
emlrec2.parentId=cases.id;
emlrec2.status='2';
emlrec2.ToAddress='test@test.com';
emlrec2.Incoming=False;
eml.add(emlrec2);
emailmessage emlrec3=new emailmessage();
emlrec3.parentId=cases.id;
emlrec3.status='3';
emlrec3.Incoming=False;
emlrec3.ToAddress='test@test.com';
eml.add(emlrec3);
emailmessage emlrec4=new emailmessage();
emlrec4.parentId=cases.id;
emlrec4.status='0';
emlrec4.Incoming=False;
emlrec4.ToAddress='test@test.com';
eml.add(emlrec4);
insert eml;
    Attachment Attrec= new Attachment();
    Attrec.Name = 'TestAttachment';
    Attrec.ParentId = cases.ID;
    String body= 'testbody';       
    Blob myBlob = Blob.valueof(body);
    Attrec.body=myBlob;
    insert Attrec;



emailmessage emlrec1=new emailmessage();
emlrec1.parentId=cases.id;
emlrec1.status='1';
emlrec1.FromAddress='anila.francis@wipro.com';
emlrec1.ToAddress='anila.francis@wipro.com';
emlrec1.INCOMING=True;

insert emlrec1;

Attachment_Object__c newattobjrec= new Attachment_Object__c();
newattobjrec.case_id__c=cases.id;
newattobjrec.Attachment_Id__c=attrec.id;
insert newattobjrec;
 
ApexPages.StandardController controller= new ApexPages.StandardController(cases);
System.currentPagereference().getParameters().put('id', emlrec1.id);
System.currentPagereference().getParameters().put('caseid', cases.id);
sendmailclass_detail sendmailDetl=new sendmailclass_detail(controller);

string cclst=sendmailDetl.getCClist();
cclst='anila.francis@wipro.com';
sendmailDetl.setCClist(cclst);

string Tolst=sendmailDetl.getTolist();
Tolst='anila.francis@wipro.com';
sendmailDetl.setTolist(Tolst);

string frmlst=sendmailDetl.getFrmlst();
frmlst='anila.francis@wipro.com';
sendmailDetl.setFrmlst(frmlst);


string htmlbody =sendmailDetl.getHtmlemailBody();
htmlbody='testbody';
sendmailDetl.setHtmlemailBody(htmlbody);

sendmailDetl.getcaseRecord();
sendmailDetl.getEmailRec();

sendmailDetl.getcaseid();
sendmailDetl.template();
sendmailDetl.attachfile();
sendmailDetl.preview();
sendmailDetl.spelling();
sendmailDetl.cancel();
sendmailDetl.getFrmAdd();
sendmailDetl.getalist();
sendmailDetl.send();
test.stoptest(); 
}



}