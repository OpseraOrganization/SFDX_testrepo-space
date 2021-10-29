@isTest
private class sendmailclass_edit_TestCls{

    static testMethod void sendmailclass_edit_Testcls()
    {
        TriggerInactive.testTrigger = false;
        List<Folder> EMTFolder = [Select Id, Name, DeveloperName from Folder where type = 'email' and (( Name like 'CSO%') or ( Name like 'GTO%') or ( Name like 'Survey%'))];
        system.debug('@@@@TEST:EmailTemplate='+ EMTFolder);
        test.starttest(); 
        EmailTemplate etemp = [Select Name, HtmlValue, Subject, Body, DeveloperName, TemplateType, IsActive, FolderId from EmailTemplate where Name LIKE 'CSO - Account Request'];
        //creating account;
        Account acc= new Account(name='Test Accountabc123', Market_Name__c = 'Military', Sbl_Account_Row_Id__c = 'A-9999999');
        insert acc;
        
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact1',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='T123567' );
        insert cont;        
        
        //creating case
        Case newcase =new Case(AccountId=acc.Id,subject='Test Case:Do not Delete',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',Supported_Product__c='Radio',Origin ='Email-Anniston.RFQ',Resolution__c='Test Resolution');
        insert newcase ;
            
        //Case newcase = [Select id, Contactid, Origin, Classification__c, Status, HON_Commit_Date__c, Export_Compliance_Content_ITAR_EAR__c, Government_Compliance_SM_M_Content__c, Sub_Class__c, Detail_Class__c,Resolution__c from Case where subject='Test Case:Do not Delete' limit 1];
        //system.debug('**************'+newcase);
        
        /*Attachment attach = new Attachment();
        attach.Name = 'NewAttachment';
        attach.ParentId = newcase.ID;
        String asd = 'asd';
        attach.Body = blob.valueof(asd);
        insert attach;*/
        
        EmailMessage emess = new EmailMessage();
        emess.BccAddress = 'anup.narayanan@wipro.com';
        emess.CcAddress = 'albin.arul@wipro.com';
        emess.HtmlBody = 'This is Html body Case:';
        emess.Subject = 'Test Subject';
        emess.TextBody = 'This is Text body';
        emess.ToAddress = 'niveda.jeyaseelan@wipro.com';
        emess.FromAddress = 'anup.narayanan@wipro.com'; 
        emess.ParentID = newcase.id;
        emess.INCOMING=True;
        insert emess;
        
        ApexPages.CurrentPage().getParameters().Put('BCClist','anup.narayanan@gmail.com');
        ApexPages.CurrentPage().getParameters().Put('AddCClist','n.anup89@gmail.com');
        ApexPages.CurrentPage().getParameters().Put('ToList','anup.narayanan@wipro.com');
        ApexPages.CurrentPage().getParameters().Put('caseid',newcase.id); 
        ApexPages.CurrentPage().getParameters().Put('isHtml','true'); 
        ApexPages.CurrentPage().getParameters().Put('isHTMLval','true');
        ApexPages.CurrentPage().getParameters().Put('templateId',etemp.id);
        
        ApexPages.CurrentPage().getParameters().Put('Id',emess.id);
        ApexPages.CurrentPage().getParameters().Put('forward','True');
        ApexPages.StandardController std = new ApexPages.StandardController(emess);  
        sendmailclass_edit test1 = new sendmailclass_edit(std);
        
        
        test1.fileName = 'asd';
        String bb = 'dsa';       
        test1.filebody = blob.valueof(bb); 
        test1.doref();
        test1.doref1();
        test1.attachtemplate();
        test1.template();
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
        
        test1.send();
        test1.cancel();
        test1.attachfile();
        test1.nodisp();
        
        List<Id> selattach = test1.GetSelectedattachments(); 
        List<Attachment> attch = test1.getattachments(); 
        List<Attachment> showatt = test1.getshowatt();
        
        id pageid=test1.getPageId();
        pageid=emess.id;
        test1.setPageid(pageid);    
    
    }
    
    static testMethod void sendmailclass_edit_Testcls1()
    {
        TriggerInactive.testTrigger = false;
        List<Folder> EMTFolder = [Select Id, Name, DeveloperName from Folder where type = 'email' and (( Name like 'CSO%') or ( Name like 'GTO%') or ( Name like 'Survey%'))];
        system.debug('@@@@TEST:EmailTemplate='+ EMTFolder);
        test.starttest(); 
        EmailTemplate etemp = [Select Name, HtmlValue, Subject, Body, DeveloperName, TemplateType, IsActive, FolderId from EmailTemplate where Name LIKE 'CSO - Account Request'];
        //creating account;
        Account acc= new Account(name='Test Accountabc123', Market_Name__c = 'Military', Sbl_Account_Row_Id__c = 'A-9999999');
        insert acc;
        
        //creating contact;
        Contact cont=new Contact(firstname='Test',LastName='Contact1',AccountId=acc.Id,Phone_3__c='9986502495',
        Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E123567' );
        insert cont;        
        
        //creating case
        Case newcase =new Case(AccountId=acc.Id,subject='Test Case:Do not Delete',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
        //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
        Type='Order',Supported_Product__c='Radio',Origin ='Email-Anniston.RFQ',Resolution__c='Test Resolution');
        insert newcase ;
            
        //Case newcase = [Select id, Contactid, Origin, Classification__c, Status, HON_Commit_Date__c, Export_Compliance_Content_ITAR_EAR__c, Government_Compliance_SM_M_Content__c, Sub_Class__c, Detail_Class__c,Resolution__c from Case where subject='Test Case:Do not Delete' limit 1];
        //system.debug('**************'+newcase);
        
        /*Attachment attach = new Attachment();
        attach.Name = 'NewAttachment';
        attach.ParentId = newcase.ID;
        String asd = 'asd';
        attach.Body = blob.valueof(asd);
        insert attach;*/
        
        EmailMessage emess = new EmailMessage();
        emess.BccAddress = 'anup.narayanan@wipro.com';
        emess.CcAddress = 'albin.arul@wipro.com';
        emess.HtmlBody = 'This is Html body Case:';
        emess.Subject = 'Test Subject';
        emess.TextBody = 'This is Text body';
        emess.ToAddress = 'niveda.jeyaseelan@wipro.com';
        emess.FromAddress = 'anup.narayanan@wipro.com'; 
        emess.ParentID = newcase.id;
        emess.INCOMING=True;
        insert emess;
        
        ApexPages.CurrentPage().getParameters().Put('BCClist','anusuya.murugiah@honeywell.com');
        ApexPages.CurrentPage().getParameters().Put('AddCClist','latha.priya@nttdata.com');
        ApexPages.CurrentPage().getParameters().Put('ToList','anusuya.murugiah@nttdata.com');
        ApexPages.CurrentPage().getParameters().Put('caseid',newcase.id); 
        ApexPages.CurrentPage().getParameters().Put('isHtml','true'); 
        ApexPages.CurrentPage().getParameters().Put('isHTMLval','false');
        ApexPages.CurrentPage().getParameters().Put('templateId',null);
        ApexPages.CurrentPage().getParameters().Put('HtmlemailBody','test< & >test-ing');
        ApexPages.CurrentPage().getParameters().Put('Id',emess.id);
        ApexPages.CurrentPage().getParameters().Put('forward','True');
        ApexPages.StandardController std2 = new ApexPages.StandardController(emess);  
        sendmailclass_edit test3 = new sendmailclass_edit(std2);
        
        
        test3.fileName = 'asd';
        
        String bb = 'dsa';       
        test3.filebody = blob.valueof(bb); 
        test3.doref();
        test3.doref1();
        test3.attachtemplate();
        test3.template();
        
        String s = test3.getEmailTemplate();
        test3.setEmailTemplate(s);
        
        String s1 = test3.gettemplateId();
        test3.settemplateId(s1);
        
        List<SelectOption> templist2 = test3.getTempList();
        List<EmailTemplate> etmp2 = test3.getemailTemplates();   
        
        Case c2 = test3.getcaseRecord();
        test3.setsubject(null);
        String s2 = test3.getsubject();
         test3.UploadFile();
        
        test3.ViewDetails();
        
        test3.cancel();
        test3.attachfile();
        test3.nodisp();
        List<Id> selattach2 = test3.GetSelectedattachments();     
        List<Attachment> attch2 = test3.getattachments(); 
        List<Attachment> showatt2 = test3.getshowatt();
        id pageid2=test3.getPageId();
        pageid2=emess.id;
        test3.setPageid(pageid2);
        
        //////////////////////////////////////////////////////////////////////////////////////////
        test.stoptest();
    }
    
}