/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : TestClass_Marcomcls
* Description           : Test Class to test the functionality of Request Form.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 18-Dec-2012      0.01           NTTData               Initial Version

***********************************************************************************************************/
@isTest(SeeAllData=true)
private class TestClass_Marcomcls
{
  
    static testMethod void Test_Marcom_RequestMthd()
    {      
        PageReference objPageRef  = Page.Marcom_Request_Form;  
       objPageRef.getParameters().put('Var01', 'true');
        Test.setCurrentPage(objPageRef);
        
        Marcom_Service_Request__c objMarcomSR = new Marcom_Service_Request__c();     
        
        ApexPages.StandardController objController = new ApexPages.StandardController(objMarcomSR);
        Marcomrequestformcls objMarcomrequestformcls  = new Marcomrequestformcls(objController);
        
        Attachment objAttachment = new Attachment();
        objMarcomrequestformcls.myfile = objAttachment;
        objMarcomrequestformcls.getmyfile();  
        objMarcomrequestformcls.dosave();
        
    }
    
     static testMethod void Test_Marcom_ContactMthd()
    {      
        PageReference objPageRef  = Page.Marcom_Contactus_Form;  
       
        Test.setCurrentPage(objPageRef);
        String descrption = 'testing';
        string firstname = 'Mrina';
        string lastname = 'lini';
        string email = 'Mrinalini.Ilangovan@nttdata.com';
        string phonenumber = '9894469309';
              
        MarcomContactcls  objMarcomcontactformcls  = new MarcomContactcls ();
        objMarcomcontactformcls.setfirstname(firstname);
        objMarcomcontactformcls.setdescrption(descrption);
        objMarcomcontactformcls.setlastname(lastname);
        objMarcomcontactformcls.setemail(email);
        objMarcomcontactformcls.setphonenumber(phonenumber);
       objMarcomcontactformcls.setfiledata(null);
       objMarcomcontactformcls.setfilename('test');
        objMarcomcontactformcls.save();
        
    }
    
     static testMethod void Test_Marcom_ListViewMthd()
    {      
        PageReference objPageRef  = Page.MarkCommListView;  
            
       Marcom_Service_Request__c msr=new Marcom_Service_Request__c();     
       msr.Marcom_Business__c='test';     
       msr.Marcom_Audience__c='Internal';     
       msr.Marcom_Related_Activity__c='test2';     
       msr.Marcom_Market__c='BGA';     
       msr.Marcom_Request_Region__c='Americas';     
       msr.Marcom_Request_Timeline__c=date.Today()+5;     
       insert msr;  
       msr.Marcom_SR_Status__c = 'null';
       update msr;
        MarcommPageController objMarcomview  = new MarcommPageController();
       ApexPages.StandardSetController objController = objMarcomview.caseList; 
        List<Marcom_Service_Request__c > objMarList = objMarcomview.getCases();
        
        
    }
    
    static testMethod void Test_Marcom_ViewReqMthd()
    {      
        PageReference objPageRef  = Page.MarcomViewRequest;  
            
       
       
       Marcom_Service_Request__c msr=new Marcom_Service_Request__c();     
       msr.Marcom_Business__c='test';     
       msr.Marcom_Audience__c='Internal';     
       msr.Marcom_Related_Activity__c='test2';     
       msr.Marcom_Market__c='BGA';     
       msr.Marcom_Request_Region__c='Americas';     
       msr.Marcom_Request_Timeline__c=date.Today()+5;     
       insert msr;    
       objPageRef.getParameters().put('caseid', msr.Id);
        Test.setCurrentPage(objPageRef);       
       MarcomViewRequestController  objMarcomviewreq  = new MarcomViewRequestController ();
        
        objMarcomviewreq.cancelattach();
        objMarcomviewreq.cancelComments();
        String strattId = objMarcomviewreq.attchId;
        Marcom_Service_Request__c  objMarcom = objMarcomviewreq.objCase;
        boolean showrender = objMarcomviewreq.showrender;
        showrender = objMarcomviewreq.getShowrender();
        objMarcomviewreq.setShowrender();
        boolean textrender = objMarcomviewreq.textrender;
        textrender = objMarcomviewreq.getTextrender();
        objMarcomviewreq.setTextrender();
        boolean showattach = objMarcomviewreq.showattach;
        showattach = objMarcomviewreq.getShowattach();
        boolean viewattach = objMarcomviewreq.viewattach;
        objMarcomviewreq.getViewattach();
        objMarcomviewreq.setViewattach();
        boolean viewnotes  = objMarcomviewreq.viewnotesdet;
        objMarcomviewreq.getviewnotesdet();
        objMarcomviewreq.setviewnotesdet();
        boolean addattach  = objMarcomviewreq.addattach;
        
        String txtComments = objMarcomviewreq.txtComments; 
        objMarcomviewreq.getTxtComments();
        objMarcomviewreq.setTxtComments();
        objMarcomviewreq.getobjfile();
       
                Note objNotes       = new Note();
        objNotes.Title = 'Testing';
        objNotes.Body = 'test class testing';
        objNotes.ParentId = msr.Id;
        insert objNotes;
      //  objMarcomviewreq.setobjNote();
         objMarcomviewreq.getobjNote();
        objNotes = objMarcomviewreq.objNote;
        Blob objblb = null;
          Attachment attobj = new Attachment();
          attobj.name = 'New';
          attobj.body = objblb ;
         // objMarcomviewreq.setobjfile(attobj);
          Attachment objfile = objMarcomviewreq.objfile;

        List<Attachment> attList = objMarcomviewreq.attList;    
        List<Note> notelist      = objMarcomviewreq.notelist;
        objMarcomviewreq.editComments();
        objMarcomviewreq.addattach();
        objMarcomviewreq.viewattach();        
        objMarcomviewreq.viewcomments();
        objMarcomviewreq.saveComments();
        objMarcomviewreq.saveattach();
       
    }
    
}