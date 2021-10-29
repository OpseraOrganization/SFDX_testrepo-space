@isTest
private class sendmailclass_TM{

 static testMethod void sendmailclass_Testcls1() 
 {
    
    //List<Folder> EMTFolder = [Select Id, Name, DeveloperName from Folder where type = 'email' and (( Name like 'CSO%') or ( Name like 'GTO%') or ( Name like 'Survey%'))];
    //system.debug('@@@@TEST:EmailTemplate='+ EMTFolder);
    
    //EmailTemplate etemp = [Select Name, HtmlValue, Subject, Body, DeveloperName, TemplateType, IsActive, FolderId from EmailTemplate where Name LIKE 'CSO - Account Request'];
    
    //creating account;
     Account acc= new Account(name='Test Account');
     insert acc;
     
     //creating contact;
     Contact cont = new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
      Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='T123567' );
     insert cont;
    
    
    Skills2__c skill = new Skills2__c (Primary_Secondary__c='Primary' ,Supported_Product__c='Radio',   Contact__c=cont.Id);
    insert skill;
   test.starttest();    
     //creating case
    Case cases3=new Case(AccountId=acc.Id,subject='Test Case2:Do not Delete',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
     //No_FCR_Reason__c='Not Trained',
     Type='Order',
     Supported_Product__c='Radio',Origin ='Email-Anniston.RFQ');
     insert cases3;
    
    
//    Case newcase = [Select id, Contactid, Origin, Classification__c, Status, HON_Commit_Date__c, Export_Compliance_Content_ITAR_EAR__c, Government_Compliance_SM_M_Content__c, Sub_Class__c, Detail_Class__c, Resolution__c from Case where subject='Test Case2:Do not Delete' limit 1];
  //  system.debug('**************'+newcase);
       
    
/*    Attachment attach = new Attachment();
    attach.Name = 'NewAttachment';
    attach.ParentId = newcase.ID;
    String asd = 'asd';
    attach.Body = blob.valueof(asd);
    insert attach;
*/
    
    EmailMessage emess = new EmailMessage();
    emess.BccAddress = 'anup.narayanan@wipro.com';
    emess.CcAddress = 'albin.arul@wipro.com';
    emess.HtmlBody = 'This is Html body Case:';
    emess.Subject = 'Test Subject';
    emess.TextBody = 'This is Text body';
    emess.ToAddress = 'niveda.jeyaseelan@wipro.com';
    emess.FromAddress = 'anup.narayanan@wipro.com'; 
    emess.ParentID = cases3.id;
    
    insert emess;
    
    PageReference pageRef1 = Page.SendmailPage;
    Test.setCurrentPage(pageRef1);
    ApexPages.CurrentPage().getParameters().Put('BCClist','anup.narayanan@gmail.com');
    ApexPages.CurrentPage().getParameters().Put('AddCClist','n.anup89@gmail.com');
    ApexPages.CurrentPage().getParameters().Put('ToList','anup.narayanan@wipro.com');
    ApexPages.CurrentPage().getParameters().Put('caseid',cases3.id); 
    ApexPages.CurrentPage().getParameters().Put('isHtml','true'); 
    ApexPages.CurrentPage().getParameters().Put('isHTMLval','true');
    ApexPages.CurrentPage().getParameters().Put('templateId',Null);
    Apexpages.currentPage().getParameters().put('textemailBody','<html><br/>amp;&nbsp&ndash;{!Case. hello how are you{!Case.}</html>');
    Apexpages.currentPage().getParameters().put('HtmlemailBody','<html><br/>amp;&nbsp&ndash;{!Case. hello how are you{!Case.}</html>');
     
    ApexPages.StandardController std1 = new ApexPages.StandardController(emess);  
    sendmailclass test2 = new sendmailclass(std1);
    test2.doref();
    test.stoptest();
 }

static testMethod void sendmailclass_Testcls() 
 {
    //List<Folder> EMTFolder = [Select Id, Name, DeveloperName from Folder where type = 'email' and (( Name like 'CSO%') or ( Name like 'GTO%') or ( Name like 'Survey%'))];
    //system.debug('@@@@TEST:EmailTemplate='+ EMTFolder);
    
    //EmailTemplate etemp = [Select Name, HtmlValue, Subject, Body, DeveloperName, TemplateType, IsActive, FolderId from EmailTemplate where Name LIKE 'CSO - Account Request'];
    Id etemp = Label.CSO_Account_Request_Temp_Id;
     
    //creating account;
     Account acc= new Account(name='Test Account');
     insert acc;
     
     //creating contact;
     Contact cont = new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
      Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='H123567' );
     insert cont;
    
    
    Skills2__c skill = new Skills2__c (Primary_Secondary__c='Primary' ,Supported_Product__c='Radio',   Contact__c=cont.Id);
    insert skill;
      
     //creating case
    Case cases3=new Case(AccountId=acc.Id,subject='Test Case2:Do not Delete',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
     //No_FCR_Reason__c='Not Trained',
     Type='Order',Supported_Product__c='Radio',Origin ='Email-Anniston.RFQ');
     test.starttest();
     insert cases3;
    
    
//    Case newcase = [Select id, Contactid, Origin, Classification__c, Status, HON_Commit_Date__c, Export_Compliance_Content_ITAR_EAR__c, Government_Compliance_SM_M_Content__c, Sub_Class__c, Detail_Class__c, Resolution__c from Case where subject='Test Case2:Do not Delete' limit 1];
  //  system.debug('**************'+newcase);
       
    
    Attachment attach = new Attachment();
    attach.Name = 'NewAttachment';
    attach.ParentId = cases3.ID;
    String asd = 'asd';
    attach.Body = blob.valueof(asd);
    insert attach;

    
    EmailMessage emess = new EmailMessage();
    emess.BccAddress = 'anup.narayanan@wipro.com';
    emess.CcAddress = 'albin.arul@wipro.com';
    emess.HtmlBody = 'This is Html body Case:';
    emess.Subject = 'Test Subject';
    emess.TextBody = 'This is Text body';
    emess.ToAddress = 'niveda.jeyaseelan@wipro.com';
    emess.FromAddress = 'anup.narayanan@wipro.com'; 
    emess.ParentID = cases3.id;
     
    insert emess;
    
    PageReference pageRef = Page.SendmailPage;
    Test.setCurrentPage(pageRef);
    ApexPages.CurrentPage().getParameters().Put('BCClist','anup.narayanan@gmail.com');
    ApexPages.CurrentPage().getParameters().Put('AddCClist','n.anup89@gmail.com');
    ApexPages.CurrentPage().getParameters().Put('ToList','anup.narayanan@wipro.com');
    ApexPages.CurrentPage().getParameters().Put('caseid',cases3.id); 
    ApexPages.CurrentPage().getParameters().Put('isHtml','true'); 
    ApexPages.CurrentPage().getParameters().Put('isHTMLval','true');
    ApexPages.CurrentPage().getParameters().Put('templateId',etemp);
    Apexpages.currentPage().getParameters().put('textemailBody','<html><br/>amp;&nbsp&ndash;{!Case. hello how are you{!Case.}</html>');
    Apexpages.currentPage().getParameters().put('HtmlemailBody','<html><br/>amp;&nbsp&ndash;{!Case. hello how are you{!Case.}</html>');
    ApexPages.StandardController std = new ApexPages.StandardController(emess);  
    
    sendmailclass test1 = new sendmailclass(std);

  
    test1.fileName = 'asd';
    
    String bb = 'dsa';       
    test1.filebody = blob.valueof(bb); 
    test1.Aname='test hello';
    test1.doref1();
    test1.attachtemplate();
    test1.template();
    test1.getemsg();
    String s = test1.getEmailTemplate();
    test1.setEmailTemplate(s);
   
    String s1 = test1.gettemplateId();
    test1.settemplateId(s1);
 
    List<SelectOption> templist = test1.getTempList();
    List<EmailTemplate> etmp = test1.getemailTemplates();   
    
    Case c = test1.getcaseRecord();  
    test1.cancelTemplate();
    test1.ViewDetails();
    test1.ViewTemplateDetails();
    test1.ViewTemplateDetails1();
    test1.send();
    test1.cancel();
    //test1.attachfile();
    //test1.nodisp();
    //test1.UploadFile();
    //test1.query();
     List<SelectOption> selOpts=test1.getFrmAdd();
    String s2 = test1.getsubject();
    test1.setsubject(s2);
    
    String s3 = test1.getTolist();
    test1.setTolist(s3);
    
    String s4 = test1.getAddCClist();
    test1.setAddCClist(s4);
    
    String s5 = test1.getBCClist();
    test1.setBCClist(s5);
    
    String s6 = test1.getHtmlemailBody();
    test1.setHtmlemailBody('{!Case.}');
    
    String s7 = test1.gettextemailBody();
    
    test1.settextemailBody('{!Case.}');
    
    String s8 = test1.getFrmlst();
    test1.setFrmlst(s8);
    
    test1.search();
  
    String s9 = test1.getfname();
    test1.setfname(s9);
    
    test1.getSelected();
    test1.Anamecc = 'aname';  
    test1.searchcc();
    //test1.querycc();
    test1.Anamebcc = 'aname'; 
    test1.aname  = 'aname'; 
    sendmailclass.contactwrapper con2= new sendmailclass.contactwrapper(cont);
    sendmailclass.contactwrappercc con1= new sendmailclass.contactwrappercc(cont);
    sendmailclass.contactwrapperbcc con3= new sendmailclass.contactwrapperbcc(cont);
    sendmailclass.attachmentwrapper att= new sendmailclass.attachmentwrapper(attach);
    
    String[] str = new String[]{'asd','dsa'};
    
    String s10 = test1.getfnamecc();
    test1.setfnamecc(s10);
    test1.setoptions(str);
    
    String[] s11233 = test1.getoptions();
    
    test1.searchbcc();
    //test1.querybcc();
    test1.Anamecc = 'wipro';
    
    String s12 = test1.getfnamebcc();
    test1.setfnamebcc(s12);
    
    test1.hidemessage();
    
    List<Id> selattach = test1.GetSelectedattachments(); 
  //  test1.attachfromcase();
  //  test1.attachfileCase();    
    List<Attachment> attch = test1.getattachments(); 
  //  test1.cancelAttachment();
    test1.getSelected1();
    List<Attachment> showatt = test1.getshowatt();
    test1.del();
  //  test1.query();
//**************************** 
   
  /*  List<Contact> c3234 = new List<Contact>([select Id,FirstName,LastName,AccountID from Contact limit 5]);
    test1.conresults.addAll(c3234);
    test1.conresultscc.addAll(c3234);
    test1.conresultsbcc.addAll(c3234);*/
    
/*  List<SelectOption> test123 = test1.getFrmAdd();
    List<String> str1 = new List<String>();
    str1 = test1.GetSelectedContacts();
    String[] str2 = test1.getoptionscc();
    test1.setoptionscc(str); 
    str1 = test1.GetSelectedContactscc();
    test1.getSelectedcc();
    str1 = test1.getoptionsbcc();
    test1.setoptionsbcc(str);
    str1 = test1.GetSelectedContactsbcc();
    test1.getSelectedbcc();
    test1.getresults();
    test1.getresultscc();
    test1.getresultsbcc();
    test1.getresults1();
*/

test.stoptest();
 }
    static testMethod void sendmailclass_Testcls2() 
 {
    //List<Folder> EMTFolder = [Select Id, Name, DeveloperName from Folder where type = 'email' and (( Name like 'CSO%') or ( Name like 'GTO%') or ( Name like 'Survey%'))];
    //system.debug('@@@@TEST:EmailTemplate='+ EMTFolder);
    
    //EmailTemplate etemp = [Select Name, HtmlValue, Subject, Body, DeveloperName, TemplateType, IsActive, FolderId from EmailTemplate where Name LIKE 'CSO - Account Request'];
    Id etemp = Label.CSO_Account_Request_Temp_Id;
     
    //creating account;
     Account acc= new Account(name='Test Account');
     insert acc;
     
     //creating contact;
     Contact cont = new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
      Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='H123567' );
     insert cont;
    
    
    Skills2__c skill = new Skills2__c (Primary_Secondary__c='Primary' ,Supported_Product__c='Radio',   Contact__c=cont.Id);
    insert skill;
      
     //creating case
    Case cases3=new Case(AccountId=acc.Id,subject='Test Case2:Do not Delete',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
     //No_FCR_Reason__c='Not Trained',
     Type='Order',Supported_Product__c='Radio',Origin ='Email-Anniston.RFQ');
     //test.starttest();
     insert cases3;
    
    
//    Case newcase = [Select id, Contactid, Origin, Classification__c, Status, HON_Commit_Date__c, Export_Compliance_Content_ITAR_EAR__c, Government_Compliance_SM_M_Content__c, Sub_Class__c, Detail_Class__c, Resolution__c from Case where subject='Test Case2:Do not Delete' limit 1];
  //  system.debug('**************'+newcase);
       
    
    Attachment attach = new Attachment();
    attach.Name = 'NewAttachment';
    attach.ParentId = cases3.ID;
    String asd = 'asd';
    attach.Body = blob.valueof(asd);
    insert attach;

    
    EmailMessage emess = new EmailMessage();
    emess.BccAddress = 'anup.narayanan@wipro.com';
    emess.CcAddress = 'albin.arul@wipro.com';
    emess.HtmlBody = 'This is Html body Case:';
    emess.Subject = 'Test Subject';
    emess.TextBody = 'This is Text body';
    emess.ToAddress = 'niveda.jeyaseelan@wipro.com';
    emess.FromAddress = 'anup.narayanan@wipro.com'; 
    emess.ParentID = cases3.id;
     
    insert emess;
    test.starttest();
    PageReference pageRef = Page.SendmailPage;
    Test.setCurrentPage(pageRef);
    ApexPages.CurrentPage().getParameters().Put('BCClist','anup.narayanan@gmail.com');
    ApexPages.CurrentPage().getParameters().Put('AddCClist','n.anup89@gmail.com');
    ApexPages.CurrentPage().getParameters().Put('ToList','anup.narayanan@wipro.com');
    ApexPages.CurrentPage().getParameters().Put('caseid',cases3.id); 
    ApexPages.CurrentPage().getParameters().Put('isHtml','true'); 
    ApexPages.CurrentPage().getParameters().Put('isHTMLval','false');
   // ApexPages.CurrentPage().getParameters().Put('templateId',etemp);
   ApexPages.CurrentPage().getParameters().Put('subject','');
    ApexPages.StandardController std = new ApexPages.StandardController(emess);  
    sendmailclass test1 = new sendmailclass(std);
   
  
    test1.fileName = 'asd';
    
    String bb = 'dsa';       
    test1.filebody = blob.valueof(bb); 
    test1.Aname='test hello';
    test1.doref1();
    test1.attachtemplate();
    test1.template();
    test1.getemsg();
    String s = test1.getEmailTemplate();
    test1.setEmailTemplate(s);
   
    String s1 = test1.gettemplateId();
    test1.settemplateId(s1);
 
    List<SelectOption> templist = test1.getTempList();
    List<EmailTemplate> etmp = test1.getemailTemplates();   
    
    Case c = test1.getcaseRecord();  
    /*test1.cancelTemplate();
    test1.ViewDetails();
    test1.ViewTemplateDetails();
    test1.ViewTemplateDetails1();
    test1.send();
    test1.cancel();*/
    test1.attachfile();
    test1.nodisp();
    test1.UploadFile();
    test1.query();
   
     List<SelectOption> selOpts=test1.getFrmAdd();
    String s2 = test1.getsubject();
    
    test1.setsubject(s2);
    
    String s3 = test1.getTolist();
    test1.setTolist(s3);
    
    String s4 = test1.getAddCClist();
    test1.setAddCClist(s4);
    
    String s5 = test1.getBCClist();
    test1.setBCClist(s5);
    
    String s6 = test1.getHtmlemailBody();
    test1.setHtmlemailBody(s6);
    
    String s7 = test1.gettextemailBody();
    test1.settextemailBody(s7);
    
    String s8 = test1.getFrmlst();
    test1.setFrmlst(s8);
    
    test1.search();
  
    String s9 = test1.getfname();
    test1.setfname(s9);
    
    test1.getSelected();
    test1.Anamecc = 'aname';  
    test1.searchcc();
    //test1.querycc();
    test1.Anamebcc = 'aname'; 
    test1.aname  = 'aname'; 
    sendmailclass.contactwrapper con2= new sendmailclass.contactwrapper(cont);
    sendmailclass.contactwrappercc con1= new sendmailclass.contactwrappercc(cont);
    sendmailclass.contactwrapperbcc con3= new sendmailclass.contactwrapperbcc(cont);
    sendmailclass.attachmentwrapper att= new sendmailclass.attachmentwrapper(attach);
    
    String[] str = new String[]{'asd','dsa'};
    
    String s10 = test1.getfnamecc();
    test1.setfnamecc(s10);
    test1.setoptions(str);
    
    String[] s11233 = test1.getoptions();
    
    test1.searchbcc();
    //test1.querybcc();
    test1.Anamecc = 'wipro';
    
    String s12 = test1.getfnamebcc();
    test1.setfnamebcc(s12);
    
    test1.hidemessage();
    
    List<Id> selattach = test1.GetSelectedattachments(); 
  //  test1.attachfromcase();
  //  test1.attachfileCase();    
    List<Attachment> attch = test1.getattachments(); 
  //  test1.cancelAttachment();
    test1.getSelected1();
    List<Attachment> showatt = test1.getshowatt();
    test1.del();
    Boolean a = test1.success;
    test1.getresults();
    List<String> aa = test1.GetSelectedContacts();
    Boolean b = test1.noquerycc;
    Boolean cs = test1.noresultscc;    
    Boolean d = test1.successcc;
    test1.querycc();
    test1.lnamecc = 'test';
    List<String> cc = test1.getoptionscc();
    test1.setoptionscc(cc);
    test1.getresultscc();
    List<String> aaa = test1.GetSelectedContactscc();
    PageReference aaaaa = test1.getSelectedcc();
    Boolean e = test1.noquerybcc;
    Boolean f = test1.noresultsbcc;
    Boolean g = test1.successbcc;
    test1.querybcc();
    test1.lnamebcc = 'test';
    List<String> qq = test1.getoptionsbcc();
    test1.setoptionsbcc(qq);
    test1.getresultsbcc();
    List<String> ww = test1.GetSelectedContactsbcc();
    PageReference pp = test1.getSelectedbcc();
    test1.attachfromcase();
    test1.attachfileCase();
    test1.cancelAttachment();
    test1.getresults1();
     test1.setfname('');
    test1.lname = '';
    test1.aname = '';
   test1.setfname('test');
    test1.lname = '';
    test1.aname = '';
    test1.query();
    test1.setfname('');
    test1.lname = '';
    test1.aname = '';
   test1.setfname('');
    test1.lname = 'test';
    test1.aname = '';
    test1.query();
   test1.setfname('');
    test1.lname = '';
    test1.aname = '';
     test1.setfname('test');
    test1.lname = '';
    test1.aname = 'test';
    test1.query();
   test1.setfname('');
    test1.lname = '';
    test1.aname = '';
    
    test1.setfname('');
    test1.lname = 'test';
    test1.aname = 'test';
    test1.query();
    test1.setfname('');
    test1.lname = '';
    test1.aname = '';
   test1.setfname('');
    test1.lname = '';
    test1.aname = 'test';
    test1.query();
   test1.setfname('');
    test1.lname = '';
    test1.aname = '';
  test1.setfname('test');
    test1.lname = 'test';
    test1.aname = '';
    test1.query();
  test1.setfname('');
    test1.lname = '';
    test1.aname = '';
     test1.query();
        test1.setfnamecc('');
    test1.lnamecc = '';
    test1.anamecc = '';
   test1.setfnamecc('test');
    test1.lnamecc = '';
    test1.anamecc = '';
    test1.query();
    test1.setfnamecc('');
    test1.lnamecc = '';
    test1.anamecc = '';
   test1.setfnamecc('');
    test1.lnamecc = 'test';
    test1.anamecc = '';
    test1.query();
   test1.setfnamecc('');
    test1.lnamecc = '';
    test1.anamecc = '';
     test1.setfnamecc('test');
    test1.lnamecc = '';
    test1.anamecc = 'test';
    test1.query();
   test1.setfnamecc('');
    test1.lnamecc = '';
    test1.anamecc = '';
    
    test1.setfnamecc('');
    test1.lnamecc = 'test';
    test1.anamecc = 'test';
    test1.query();
    test1.setfnamecc('');
    test1.lnamecc = '';
    test1.anamecc = '';
   test1.setfnamecc('');
    test1.lnamecc = '';
    test1.anamecc = 'test';
    test1.query();
   test1.setfnamecc('');
    test1.lnamecc = '';
    test1.anamecc = '';
  test1.setfnamecc('test');
    test1.lnamecc = 'test';
    test1.anamecc = '';
    test1.query();
  test1.setfnamecc('');
    test1.lnamecc = '';
    test1.anamecc = '';
     test1.query();
      test1.setfnamebcc('');
    test1.lnamebcc = '';
    test1.anamebcc = '';
   test1.setfnamebcc('test');
    test1.lnamebcc = '';
    test1.anamebcc = '';
    test1.query();
    test1.setfnamebcc('');
    test1.lnamebcc = '';
    test1.anamebcc = '';
   test1.setfnamebcc('');
    test1.lnamebcc = 'test';
    test1.anamebcc = '';
    test1.query();
   test1.setfnamebcc('');
    test1.lnamebcc = '';
    test1.anamebcc = '';
     test1.setfnamebcc('test');
    test1.lnamebcc = '';
    test1.anamebcc = 'test';
    test1.query();
   test1.setfnamebcc('');
    test1.lnamebcc = '';
    test1.anamebcc = '';
    
    test1.setfnamebcc('');
    test1.lnamebcc = 'test';
    test1.anamebcc = 'test';
    test1.query();
    test1.setfnamebcc('');
    test1.lnamebcc = '';
    test1.anamebcc = '';
   test1.setfnamebcc('');
    test1.lnamebcc = '';
    test1.anamebcc = 'test';
    test1.query();
   test1.setfnamebcc('');
    test1.lnamebcc = '';
    test1.anamebcc = '';
  test1.setfnamebcc('test');
    test1.lnamebcc = 'test';
    test1.anamebcc = '';
    test1.query();
  test1.setfnamebcc('');
    test1.lnamebcc = '';
    test1.anamebcc = '';
     test1.query();
    
   
   
    Boolean vb = test1.showlist;
    
    
  //  test1.query();
//**************************** 
   
  /*  List<Contact> c3234 = new List<Contact>([select Id,FirstName,LastName,AccountID from Contact limit 5]);
    test1.conresults.addAll(c3234);
    test1.conresultscc.addAll(c3234);
    test1.conresultsbcc.addAll(c3234);*/
    
/*  List<SelectOption> test123 = test1.getFrmAdd();
    List<String> str1 = new List<String>();
    str1 = test1.GetSelectedContacts();
    String[] str2 = test1.getoptionscc();
    test1.setoptionscc(str); 
    str1 = test1.GetSelectedContactscc();
    test1.getSelectedcc();
    str1 = test1.getoptionsbcc();
    test1.setoptionsbcc(str);
    str1 = test1.GetSelectedContactsbcc();
    test1.getSelectedbcc();
    test1.getresults();
    test1.getresultscc();
    test1.getresultsbcc();
    test1.getresults1();
*/

test.stoptest();
 }
}