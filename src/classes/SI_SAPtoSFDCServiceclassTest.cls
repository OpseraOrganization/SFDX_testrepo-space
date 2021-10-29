/*******************************************************************************
Name         : SI_SAPtoSFDCServiceclassTest
Created By   : Nandini N
Company Name : NTT Data
Project      : <SI_SAPtoSFDCServiceclass>
Created Date : 20-Sep-2016
Usages       : Test Class for CaseCreationPortaltoSFDC
*******************************************************************************/
@isTest(seealldata=true)
global class SI_SAPtoSFDCServiceclassTest{ 
    testMethod static void SI_SAPtoSFDCServiceclassTest()
    {
        //Case cs= [select id,contactid,Customer_PO_RO_WONumber__c,RecordtypeId,Origin,Type,Additional_Web_Form_Info__c,Order_Type__c,Order_Status_Info_Requested__c,Portal_Contact_Email__c,Honeywell_ID__c,Priority,Classification__c,Sales_Order_Number__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Subject,Status,OwnerId,Description  from case  limit 1];    
        Test.startTest();
        SI_SAPtoSFDCServiceclass.RnO_CASE_cls cas = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls(); 
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> ztasklstlist = new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();       
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS tasklist = new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();           
        tasklist.Tasktype='Z106 Order Review and Completion';
        tasklist.Type='Task Creation';
        tasklist.TaskNumber='0001';
        tasklist.Taskid=null;      
        tasklist.TaskShorttext='Test';
        tasklist.Tasklongtext='Test';
        tasklist.TaskCreatedBy ='test id ztestNUS0004';
        tasklist.TaskChangedBy ='venkat';
        tasklist.TaskClosedBy='venkat';
        tasklist.TaskCreatedDate ='2016-09-22';
        tasklist.TaskChangedDate ='2016-09-22';
        tasklist.TaskClosedDate = '2016-09-22';
        tasklist.TaskStatus = 'Open';
        tasklist.TaskOwner='CSO';
        tasklist.LanguageKey='0003238978630001';    
        ztasklstlist.add(tasklist); 
        // cas.NotificationNumber = '21324'; 
        cas.CaseType = 'Datalink';
        //  cas.QuoteNumber='3435';
        // cas.CASENUMBER= 'Test123';   
        cas.Classification= 'AIRCRAFT';
        cas.CUSTOMER_PO_RO_WO_NUM = '12332';
        cas.SALES_ORDER_NUMBER = '6553';     
        cas.EXPORT_COMPLIANCE_IND = 'No';
        cas.GOVT_COMPLIANCE_IND = 'No';
        cas.SUBJECT = 'Portal data test';
        cas.STATUS = 'Open';
        cas.DESCRIPTION= 'Test'; 
        cas.NotificationNumber = '000331353458'; 
        cas.ZTASKITEMS=ztasklstlist;
        cas.CUSTOMER_REQUEST_DT='2018-05-03';
        cas.ORDER_ENTERED_DT= '2018-05-03';
        cas.PRODUCT_SERIAL_NUM='12345';  
        cas.SPEX_EXG_IND='true';
        cas.Status='open';
        cas.SUB_CLASS='Pending';
        cas.CUSTOMER_PO_RO_WO_NUM='Test';
        cas.PRODUCT_SERIAL_NUM='Test';
        cas.PRODUCT_NUM='Test';
        cas.Y1_PARTNER_FIRSTNAME = 'Test';
        cas.Y1_PARTNER_LASTNAME = 'Contact';
        cas.Y1_PARTNER_EMAIL = 'test@test.com';
        cas.Y1_PARTNER_PHONE = '9876543210';
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cas);
        Test.stopTest();
    }
    testMethod static void SI_SAPtoSFDCServiceclassTest1(){
        //Case cs= [select id,contactid,Customer_PO_RO_WONumber__c,RecordtypeId,Origin,Type,Additional_Web_Form_Info__c,Order_Type__c,Order_Status_Info_Requested__c,Portal_Contact_Email__c,Honeywell_ID__c,Priority,Classification__c,Sales_Order_Number__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Subject,Status,OwnerId,Description  from case  limit 1]; 
        
        Test.startTest();
        SI_SAPtoSFDCServiceclass.RnO_CASE_cls cas = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls();    
        cas.NotificationNumber = '000331353458'; 
        cas.CaseType = 'Datalink';
        cas.QuoteNumber='3435';
        cas.CASENUMBER= 'Test123';   
        cas.Classification= 'AIRCRAFT';
        cas.CUSTOMER_PO_RO_WO_NUM = '12332';
        cas.SALES_ORDER_NUMBER = '6553';     
        cas.EXPORT_COMPLIANCE_IND = 'No';
        cas.GOVT_COMPLIANCE_IND = 'No';
        cas.SUBJECT = 'Portal data test';
        cas.STATUS = 'Open';
        cas.DESCRIPTION= 'Test'; 
        //cas.Repair_Notification_Number__c =
        cas.CUSTOMER_REQUEST_DT='2018-05-03';
        cas.ORDER_ENTERED_DT= '2018-05-03';
        cas.Y1_PARTNER_FIRSTNAME = 'Test';
        cas.Y1_PARTNER_LASTNAME = 'Contact';
        cas.Y1_PARTNER_EMAIL = 'test@test.com';
        cas.Y1_PARTNER_PHONE = '9876543210';
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cas);
        Test.stopTest();
        
    }
    
    testMethod static void SI_SAPtoSFDCServiceclassTest2(){
   
    List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
    List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();

    Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        cas.Classification__c = 'CSO Repair Order';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        cas.Quote_Number__c= '213424';
        cas.CaseOwnerChanged__c = 'nandini.nanjappan@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        cas.Repair_Notification_Number__c = '3243';
        insert cas;
        //cas.Casenumber = 'CASE-121324';
        
        Z_Task__c zt11 = new Z_Task__c();
        zt11.SAP_ZTask_Number__c = 'Test123';
        zt11.Name = 'Tasktest1';
        zt11.RelatedTo__c = cas.id;
        zt11.Short_Text__c = 'Test';
        zt11.Comments__c = 'Test Ztask';
        zt11.Long_Text__c = 'Test122';
        zt11.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
        zt11.Other_Short_Text__c = 'Test text';
        zt11.Status__c = 'Closed';
        insert zt11;
        
         
        Activitiy_Line_Item__c Act = new Activitiy_Line_Item__c();
        Act.Case__c = cas.id;
        Act.Task_Activities__c = zt11.id;
        Act.Status__c = 'Open';
        Act.SAPUserStatusObjectNumber__c = 'Test';
        Act.Email_Status__c = 'Sent';
        insert Act;
        
        Test.startTest();
        SI_SAPtoSFDCServiceclass.RnO_CASE_cls cse = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls();
        cas=[select id,status,casenumber,Quote_Number__c,Sales_Order_Number__c,Requestor_Email__c,Repair_Notification_Number__c,ownerid from case where id=:cas.id];
        cse.CASENUMBER = cas.casenumber;
        cse.NotificationNumber  = '00023424';
        cse.SALES_ORDER_NUMBER  = cas.Sales_Order_Number__c;
        cse.QuoteNumber =cas.Quote_Number__c;
        cse.CUSTOMER_EMAIL_VBAK = cas.Requestor_Email__c;
        cse.NotificationNumber = cas.Repair_Notification_Number__c;
        cse.STATUS = 'closed';
        cse.Caseowner = 'Aero default';
        
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS ztask= new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();      
        //List<Z_Task__c> castklst= [SELECT Name,Id,SAP_ZTask_Number__c,Long_Text__c,Language_Key__c,Sub_Type__c,Comments__c,Status__c,Other_Short_Text__c,Type__c,SAPTaskObjectNo__c,Short_Text__c FROM Z_Task__c where  RelatedTo__c=:cas.Id ];  
        ztask.TaskNumber = '434523';
        zlst.add(ztask);
        cse.ZTASKITEMS = zlst;
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();  
        usr.Status = 'Open'; 
        usr.ParentObjectNo = '3213';   
        usrlst.add(usr);
        cse.Userstatuslst= usrlst;
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cse);
        Test.stopTest();

        
    }
 
    testMethod static void SI_SAPtoSFDCServiceclassTest3(){
    List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
    List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();
    
    Test.startTest();
    SI_SAPtoSFDCServiceclass.RnO_CASE_cls cas = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls();    
    cas.NotificationNumber = '000331353458'; 
    cas.CUSTOMER_EMAIL_VBAK = 'nandini.nanjappan@nttdata.com';
    cas.STATUS = 'Open';
    cas.SUB_CLASS = 'Test';
    cas.SUBJECT = 'Test';
    cas.CaseType = 'UFR PO Mismatch';

    SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS ztask= new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();      
    ztask.TaskNumber = '434523';
    zlst.add(ztask);
    cas.ZTASKITEMS = zlst;
    SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();  
    usr.Status = 'Open'; 
    usr.ParentObjectNo = '3213';   
    usrlst.add(usr);
    cas.Userstatuslst= usrlst;
    SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cas);
    Test.stopTest();
    
    }
    testMethod static void SI_SAPtoSFDCServiceclassTest4()
    {
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();  
        Test.startTest();
        SI_SAPtoSFDCServiceclass.RnO_CASE_cls cas = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls();    
        cas.NotificationNumber = '000331353458'; 
       // cas.CUSTOMER_EMAIL_VBAK = 'nandini.nanjappan@nttdata.com';
        cas.ACCOUNT_NAME = 'TestAccount';
        cas.SAP_ACCOUNT_NAME = 'TestSAPAccount';
        cas.REPAIR_LOCATION = 'Chennai';
        cas.PRODUCT_NUM = '2312';
        cas.Caseowner = 'Aero Default';
        cas.ORDER_ENTERED_DT = '17-08-2016';
        cas.CUSTOMER_REQUEST_DT = '17-08-2016';
        cas.PRODUCT_SERIAL_NUM = '232';
        cas.SPEX_EXG_IND = 'Test';
        cas.QuoteNumber = '2324';
        cas.RESOLUTION = 'Test';
        cas.SALES_ORDER_NUMBER = '7678';
        cas.SAP_ACCOUNT_INFO = 'Testacct';
        cas.STATUS = 'Open';
        cas.SUB_CLASS = 'Test';
        cas.SUBJECT = 'Test';
        cas.CaseType = 'UFR Unfunded PO';   
        cas.Y1_PARTNER_FIRSTNAME = 'Test';
        cas.Y1_PARTNER_LASTNAME = 'Contact';
        cas.Y1_PARTNER_EMAIL = 'test@test.com';
        cas.Y1_PARTNER_PHONE = '9876543210';
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS ztask= new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();      
        ztask.TaskNumber = '434523';
        zlst.add(ztask);
        cas.ZTASKITEMS = zlst;
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();  
        usr.Status = 'Open'; 
        usr.ParentObjectNo = '3213';   
        usrlst.add(usr);
        cas.Userstatuslst= usrlst;
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cas);
        Test.stopTest();
    } 
    testMethod static void SI_SAPtoSFDCServiceclassTest44()
    {
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();  
        Test.startTest();
        Account acc= [Select Id,Name from Account where Strategic_Business_Unit__c='ATR' LIMIT 1];
        //insert acc;
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',Account_Name__c=acc.id,External_Account_ID__c='3456',Site_Code__c='765');
        insert acref;
        Plant_Code_Master__c Plt=new Plant_Code_Master__c(name='test plant',SAP_Plant_Code__c='4093');
        insert plt;
        Product2 pr= new Product2(name='Test Product',Product_Number__c='23145');
        insert pr;
        
        Account act=[select id,name,Sbl_Account_Row_Id__c,REPORT_ACCOUNT_NAME__c from account where id=:acc.id];
        Account_Cross_Ref__c acrf=[select id,name,Account_Name__r.Sbl_Account_Row_Id__c,External_Account_ID__c,Site_Code__c from Account_Cross_Ref__c where id=:acref.id];
        Plant_Code_Master__c plnt=[SELECT Name,id,SAP_Plant_Code__c FROM Plant_Code_Master__c where id=:plt.id];
        Product2 pro=[SELECT Id,Product_Number__c FROM Product2 where id=:pr.id];
        
        SI_SAPtoSFDCServiceclass.RnO_CASE_cls cas = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls();    
        cas.NotificationNumber = '000331353458'; 
       // cas.CUSTOMER_EMAIL_VBAK = 'nandini.nanjappan@nttdata.com';
        cas.ACCOUNT_NAME = act.Sbl_Account_Row_Id__c;
        cas.SAP_ACCOUNT_NAME =acrf.External_Account_ID__c;
        cas.REPAIR_LOCATION = plnt.SAP_Plant_Code__c;
        cas.PRODUCT_NUM = pro.Product_Number__c;
        cas.Caseowner = 'Aero Default';
        cas.ORDER_ENTERED_DT = '17-08-2016';
        cas.CUSTOMER_REQUEST_DT = '17-08-2016';
        cas.PRODUCT_SERIAL_NUM = '232';
        cas.SPEX_EXG_IND = 'Test';
        cas.QuoteNumber = '2324';
        cas.RESOLUTION = 'Test';
        cas.SALES_ORDER_NUMBER = '7678';
        cas.SAP_ACCOUNT_INFO = 'Testacct';
        cas.STATUS = 'Open';
        cas.SUB_CLASS = 'Test';
        cas.SUBJECT = 'Test';
        cas.CaseType = 'UFR Unfunded PO';  
        cas.CASENUMBER=''; 
        cas.Y1_PARTNER_FIRSTNAME = 'Test';
        cas.Y1_PARTNER_LASTNAME = 'Contact';
        cas.Y1_PARTNER_EMAIL = 'test@test.com';
        cas.Y1_PARTNER_PHONE = '';
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS ztask= new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();      
        ztask.TaskNumber = '434523';
        zlst.add(ztask);
        cas.ZTASKITEMS = zlst;
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();  
        usr.Status = 'Open'; 
        usr.ParentObjectNo = '3213';   
        usrlst.add(usr);
        cas.Userstatuslst= usrlst;
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cas);
        
        Case cs= [select id,contactid,casenumber,Customer_PO_RO_WONumber__c,RecordtypeId,Origin,Type,Additional_Web_Form_Info__c,Order_Type__c,Order_Status_Info_Requested__c,Portal_Contact_Email__c,Honeywell_ID__c,Priority,Classification__c,Sales_Order_Number__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Subject,Status,OwnerId,Description,(SELECT id,Type__c,RelatedTo__c,Task_Closed__c,CreatedDate,LastModifiedDate,Status__c from Case.Z_Tasks__r),(SELECT id,APU_Workcenter__c,Case_object__c,Case_object__r.casenumber,Warranty_requested__c,Warranty_Accepted__c,Warranty_Start_Date__c,Warranty_End_Date__c,Notification_Number__c,Receipt_Date__c,IDS_OTTR_Date__c from case.Case_Extensions__r )  from case where Quote_Number__c != null and Sales_Order_Number__c != null and Repair_Notification_Number__c != null  limit 1];    
        CreateCaseServiceclass cls_obj= new CreateCaseServiceclass();
        cls_obj.getCaseNumber(cs.id);
        Test.stopTest();
    } 
    testMethod static void SI_SAPtoSFDCServiceclassTest6()
    {
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();
                
        
        SI_SAPtoSFDCServiceclass.RnO_CASE_cls cas = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls();    
        cas.NotificationNumber = '000331353458'; 
        cas.CUSTOMER_EMAIL_VBAK = 'nandini.nanjappan@nttdata.com';
        cas.ACCOUNT_NAME = '1+5Y1+1502';
        cas.APUWorkcenter='APMAIN';
        cas.SAP_ACCOUNT_NAME = 'TestSAPAccount';
        cas.REPAIR_LOCATION = 'Chennai';
        cas.PRODUCT_NUM = '2312';
        cas.Caseowner = 'Aero Default';
        cas.ORDER_ENTERED_DT = '17-08-2016';
        cas.CUSTOMER_REQUEST_DT = '17-08-2016';
        cas.PRODUCT_SERIAL_NUM = '232';
        cas.SPEX_EXG_IND = 'Test';
        cas.QuoteNumber = '2324';
        cas.RESOLUTION = 'Test';
        cas.SALES_ORDER_NUMBER = '7678';
        cas.SAP_ACCOUNT_INFO = 'Testacct';
        cas.STATUS = 'Open';
        cas.SUB_CLASS = 'Test';
        cas.SUBJECT = 'Test';
        cas.CaseType = 'UFR PO Mismatch'; 
        cas.CASENUMBER='';     
        cas.Y1_PARTNER_FIRSTNAME = 'Test';
        cas.Y1_PARTNER_LASTNAME = 'Contact';
        cas.Y1_PARTNER_EMAIL = 'test@test.com';
        cas.Y1_PARTNER_PHONE = '9876543210';
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS tasklist = new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();           
        tasklist.Tasktype='Z106 Order Review and Completion';
        tasklist.Type='Task Creation';
        tasklist.TaskNumber='0001';
        tasklist.Taskid=null;      
        tasklist.TaskShorttext='Test';
        tasklist.Tasklongtext='Test';
        tasklist.TaskCreatedBy ='test id ztestNUS0004';
        tasklist.TaskChangedBy ='venkat';
        tasklist.TaskClosedBy='venkat';
        tasklist.TaskCreatedDate ='2016-09-22';
        tasklist.TaskChangedDate ='2016-09-22';
        tasklist.TaskClosedDate = '2016-09-22';
        tasklist.TaskStatus = 'Open';
        tasklist.TaskOwner='CSO';
        tasklist.LanguageKey='0003238978630001';    
        zlst.add(tasklist); 
        cas.ZTASKITEMS = zlst;
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();     
        usr.CaseNumber=null;
        usr.ChangeNumber='001';
        usr.Emailstatus=null; 
        usr.NotificationNumber=null;
        usr.ParentObjectNo='QM000323897863';
        usr.ParentRoot='Case';
        usr.SAPUserStatusObjectNumber='000323897863001PPOC';
        usr.SFDCUserStatusId=null;
        usr.SalesOrder=null;
        usr.Status='Open';
        usr.UserStatus='PPOC';
        usr.UserStatusName='Pre payment Customer';
        usr.UserStatusRelationship=null;
        usr.CaseNumber=null;
        usr.ChangeNumber='002';
        usr.Emailstatus=null; 
        usr.NotificationNumber=null;
        usr.ParentObjectNo='QM000323897863';
        usr.ParentRoot='Task';
        usr.SAPUserStatusObjectNumber='000323897863002PPOC';
        usr.SFDCUserStatusId=null;
        usr.SalesOrder=null;
        usr.Status='Open';
        usr.UserStatus='PPOC';
        usr.UserStatusName='Pre payment Customer';
        usr.UserStatusRelationship=null;        
        usrlst.add(usr);
        cas.Userstatuslst= usrlst;
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cas);
        Case cs= [select id,contactid,casenumber,Customer_PO_RO_WONumber__c,RecordtypeId,Origin,Type,Additional_Web_Form_Info__c,Order_Type__c,Order_Status_Info_Requested__c,Portal_Contact_Email__c,Honeywell_ID__c,Priority,Classification__c,Sales_Order_Number__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Subject,Status,OwnerId,Description,(SELECT id,Type__c,RelatedTo__c,Task_Closed__c,CreatedDate,LastModifiedDate,Status__c from Case.Z_Tasks__r),(SELECT id,APU_Workcenter__c,Case_object__c,Case_object__r.casenumber,Warranty_requested__c,Warranty_Accepted__c,Warranty_Start_Date__c,Warranty_End_Date__c,Notification_Number__c,Receipt_Date__c,IDS_OTTR_Date__c from case.Case_Extensions__r )  from case where Quote_Number__c != null and Sales_Order_Number__c != null and Repair_Notification_Number__c != null  limit 1];    
        //CaseTaskList12 = [SELECT Name,Id,SAP_ZTask_Number__c,Long_Text__c,Language_Key__c,Sub_Type__c,Comments__c,Status__c,Other_Short_Text__c,Type__c,SAPTaskObjectNo__c,Short_Text__c FROM Z_Task__c where  RelatedTo__c=:cs.Id ];  
        /*Case_Extension__c e = new Case_Extension__c();
        e.Notification_Number__c = '3435';
        e.Case_Object__c = cs.id;
        insert e;
        Case_Extension__c csext = [select id,Notification_Number__c,Case_Object__c  from Case_Extension__c  where id=:e.id];*/
        ROI_Order_Information__c roi= new ROI_Order_Information__c();
        roi.CaseNumber__c=cs.id;
        roi.Customer_Email_ID__c='sofiya.peermohamed@nttdata.com';
        roi.RAI_DAYS__c='10';
        insert roi;
        Test.startTest();
        CreateCaseServiceclass cls_obj= new CreateCaseServiceclass();
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP cse = new SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP();
        ZtaskServiceclass ztask=new ZtaskServiceclass();
        cse=ZtaskServiceclass.ZTASK(cas,cs.caseNumber);
        cse=UserstatusServiceClass.UserStatus(cas,cs.caseNumber);
        cls_obj.getCaseNumber(cs.id);
        //cls_obj.getCaseExtension(cs.id,'','','','','','','','','');
        cls_obj.getCaseroiorderinfo(cs.id,'1','1','1','1','1','','1','1','1','1','1','1','1','1','1','test');
        //ztask.getCaseExtension(cs.id);
        ztask.getCaseNumber(cs.id);
        string datestring='10-12-2016';
        ztask.FORMAT_DATE(datestring);
        //ztask.stringToDate(datestring);
        //cls_obj.getCaseroiorderinfo(cs.id);
        //cls_obj.GET_ACCOUNT_ID(cs.id);
        Test.stopTest();
    }  
    
        testMethod static void SI_SAPtoSFDCServiceclassTest67()
    {
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();
                
        
        SI_SAPtoSFDCServiceclass.RnO_CASE_cls cas = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls();    
        cas.NotificationNumber = '000331353458'; 
        cas.CUSTOMER_EMAIL_VBAK = 'nandini.nanjappan@nttdata.com';
        cas.ACCOUNT_NAME = '1+5Y1+1502';
        cas.APUWorkcenter='APMAIN';
        cas.SAP_ACCOUNT_NAME = 'TestSAPAccount';
        cas.REPAIR_LOCATION = 'Chennai';
        cas.PRODUCT_NUM = '2312';
        cas.Caseowner = 'Aero Default';
        cas.ORDER_ENTERED_DT = '17-08-2016';
        cas.CUSTOMER_REQUEST_DT = '17-08-2016';
        cas.PRODUCT_SERIAL_NUM = '232';
        cas.SPEX_EXG_IND = 'Test';
        cas.QuoteNumber = '2324';
        cas.RESOLUTION = 'Test';
        cas.SALES_ORDER_NUMBER = '7678';
        cas.SAP_ACCOUNT_INFO = 'Testacct';
        cas.STATUS = 'Open';
        cas.SUB_CLASS = 'Test';
        cas.SUBJECT = 'Test';
        cas.CaseType = 'UFR PO Mismatch'; 
        cas.CASENUMBER=''; 
        cas.Y1_PARTNER_FIRSTNAME = 'Test';
        cas.Y1_PARTNER_LASTNAME = 'Test';
        cas.Y1_PARTNER_EMAIL = 'test@test.com';
        cas.Y1_PARTNER_PHONE = '9876543210';
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS tasklist = new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();           
        tasklist.Tasktype='Z106 Order Review and Completion';
        tasklist.Type='Task Creation';
        tasklist.TaskNumber='0001';
        tasklist.Taskid=null;      
        tasklist.TaskShorttext='Test';
        tasklist.Tasklongtext='Lorem ipsum dolor sit amet, fermentum pharetra ipsum sed mauris scelerisque culpa, laoreet libero etiam pharetra eu lacus, sed varius magna hac tellus praesent in, suspendisse urna tellus placerat non risus. Porttitor nonummy vehicula wisi sint tempor, vitae tellus nulla fermentum quis quis, mauris dignissim omnis porta ac volutpat, hac eget viverra in gravida nonummy pulvinar, velit nulla feugiat parturient netus mollis aliquam. Arcu leo scelerisque quisque blandit pellentesque, ultricies nascetur purus cursus imperdiet accumsan sagittis, praesent nunc sed dapibus dui in. Cubilia lorem lacus tellus diam debitis, commodo fusce dolor adipisicing consectetuer et vitae, vestibulum ornare accumsan vitae accumsan praesent, morbi faucibus justo lorem augue porta sodales, molestie nulla ac nibh nec est aenean. Praesent erat maecenas odio ante dolor, vehicula nam mi ultrices ut dolor ante, fusce ridiculus at arcu urna felis vel, a pellentesque arcu accumsan nulla deserunt. Nunc ornare nec a diam aliquam urna, maecenas vivamus senectus sagittis tellus ac faucibus, mi leo quam tempor amet facilisis, sapien per cras placerat libero porta, vitae mauris quis sit nec ut. Sit magna vitae donec leo urna, nascetur eu viverra massa amet pharetra proident, elit commodo ipsum proin pellentesque consequat feugiat, elit sit quis facilisis ipsum ornare pellentesque. Morbi enim et et pretium et tortor, praesent adipiscing placerat aliquet dolor vestibulum, tempus at consectetuer ut diam fermentum nulla. Pellentesque lorem phasellus tristique a ac donec, augue suspendisse orci consequat rhoncus dapibus, magna quam habitasse assumenda duis imperdiet scelerisque. Turpis iaculis ipsum phasellus vitae et, nunc congue rhoncus eu diam in, rutrum dui mauris leo est sodales. Ut ante tempora imperdiet orci in ut, turpis laoreet dapibus penatibus ut in, tempor ac gravida est nam lorem dictum. Lacinia bibendum vitae ante lacus in, orci per orci amet sed dolor lorem, ullamcorper at a praesent quis dictum consectetuer, dolor nunc fermentum interdum tortor voluptatem. Vestibulum cursus nunc nunc risus nec metus, diam mauris vestibulum nullam pellentesque ipsum, maecenas et semper platea wisi porttitor curabitur. Quis adipiscing adipiscing purus vestibulum gravida, lacinia justo vel interdum sociosqu lacus, wisi leo fusce aenean arcu sapien volutpat, ipsum accumsan a ornare tellus et. Sagittis sit malesuada pellentesque nulla enim, accumsan tempor a in vehicula et ipsum, montes est risus adipiscing wisi amet, sed tempus eu purus quisque donec. In non purus wisi donec vel amet, maecenas enim cursus etiam dapibus ac, in fringilla facilisis nibh congue et, commodo et curabitur sapien ut facilisis, morbi turpis facilisis sit tortor faucibus in. Ut aenean erat tempor purus et venenatis, cursus feugiat amet blandit vel bibendum, mi purus felis odio suspendisse sed, nunc urna eum tincidunt a consequat, venenatis curabitur elit nullam aliquam nec laboriosam. Vestibulum integer ut cursus laoreet odio, tincidunt maecenas vel sed ut ac varius, malesuada diam libero sodales ipsum sed, viverra erat sit integer quisque iaculis volutpat, penatibus quam donec accumsan duis in a. Sodales ipsum torquent tempus dolore sit, sagittis mauris nisl in sed rutrum a, amet ut elit fusce libero netus egestas, lobortis sit turpis augue maecenas integer. Eget porttitor nunc risus faucibus enim, donec nec convallis egestas pellentesque lectus felis, vulputate suspendisse risus metus blandit quis, a suspendisse nonummy enim fermentum per dapibus. Et faucibus vestibulum iaculis sapiente per accumsan, fringilla elementum auctor praesent sollicitudin rutrum laoreet, fugit suspendisse duis et vestibulum eu euismod, feugiat quis sit nunc dolor urna. Id suscipit porta sed wisi nam vehicula, integer ut massa donec eget dolor sapien, elit tincidunt condimentum rutrum magna pede, est tellus pellentesque facilisi dictum laoreet amet, ac quam ligula pede vitae pellentesque. Litora sed a cubilia dui vestibulum felis, nascetur hac parturient integer convallis in, donec tellus ipsum aliquam proin massa. In pede eu parturient nisl lectus, amet magna at sit massa ipsum pellentesque, pharetra augue dolor egestas porta dictum mi. Leo etiam dui mauris turpis erat vel, velit bibendum odio sagittis sagittis in, sodales vitae et massa at mattis. Vulputate nonummy pede rhoncus est ut, placerat placerat tristique in aliquet id, lobortis sed non ornare vestibulum consectetuer. Risus augue sed ac lectus volutpat, nulla arcu iaculis aenean aliquam ut lacinia, at mi amet facilisis purus morbi sollicitudin. Eget nulla molestie lectus tincidunt vel, tellus quo odio nonummy mauris felis, integer sapien tellus dignissim viverra lorem suspendisse. Duis molestiae sem vel eu orci, a nibh a lorem porttitor quisque tincidunt, euismod a dui sodales aliquam aliquet, fusce mollis maecenas aenean etiam vestibulum. Neque bibendum cras vitae turpis in, eget pulvinar curabitur non voluptatibus sit, malesuada sodales non quam bibendum malesuada rutrum, velit lacus at sit diam ultrices tempus, pellentesque in a hendrerit dictumst aenean a. Tellus praesent elit sodales sodales neque diam, odio aliquam lorem nulla accumsan nec, eget vestibulum nunc eget dignissim mauris eu, tristique etiam sapien nulla cillum pharetra dolor, at sapien auctor quis fringilla faucibus. Suspendisse hendrerit morbi auctor nulla imperdiet tortor, nunc risus ut id justo adipiscing, amet vivamus cursus aenean hendrerit nec nibh. Cursus dui maecenas at suspendisse morbi, lectus hymenaeos viverra in erat nesciunt, et tempore nesciunt nibh non excepturi. Dignissim nullam blandit mauris turpis quam, ac litora ipsum pellentesque ipsum ultrices, a nec curabitur vel tortor praesent. Justo vel sit phasellus mauris pede aliquet, donec ante sed vulputate quis consectetuer urna, eu non metus a hendrerit praesent, pellentesque lobortis arcu quis consectetuer scelerisque, vel excepturi risus imperdiet auctor neque. Et dictumst non mattis nibh mi, sed id semper et commodo morbi, amet eget mollis morbi urna in lobortis. Purus proin morbi mi arcu nostra minima, sed id elit purus justo a enim, lectus placerat fusce ante consequat wisi tellus, donec donec tortor ut orci eu, tincidunt amet venenatis tristique in aliquam integer. Nulla in vehicula cras suscipit urna voluptas, dolor aliquet porttitor ornare fermentum amet adipiscing, ipsum nec mauris tellus mauris aliquam, suscipit ac dignissim sodales sem suscipit. Feugiat tincidunt vitae ornare elit faucibus aliquid, volutpat posuere libero labore sollicitudin ultricies, porttitor aliquam vestibulum ac non lacinia vitae. Magna suscipit suscipit sapien imperdiet tristique, morbi in et vulputate ut adipiscing cum, lorem libero justo mauris non pede donec, suspendisse iaculis porta turpis ut integer. Et lacinia in elementum nulla quam, posuere quam nisl vivamus et maecenas eros, magna lectus a rutrum malesuada nonummy. Sociosqu mi quis ligula lectus vel, mauris vestibulum ipsum vulputate in pede, pulvinar aliquam at justo wisi in elit. Ullamcorper proin nec in suscipit nibh sagittis, justo magna a purus in dictum morbi, donec nullam etiam tellus consectetuer mauris, felis morbi ante sapien sit nibh etiam. Varius malesuada est ultrices fusce ridiculus, leo nulla libero nec sed habitasse, et dignissim ad mi justo pellentesque odio. Interdum potenti donec a tincidunt nibh lorem, eleifend sagittis mollit ipsum at donec, cursus at tincidunt cras sit eget, varius vel pharetra ut in donec, at urna viverra sed magnis feugiat. Fames dapibus vivamus fringilla adipiscing quas, ut risus eget mauris sed ante, cras a ac orci cursus nascetur risus, dis gravida egestas turpis id vestibulum. Iaculis eget sem tortor odio lectus pede, condimentum dictum feugiat massa odio hendrerit aperiam, felis et nulla ut ligula wisi praesent, justo nonummy tempor dignissim lorem arcu dapibus. Luctus donec vulputate eu vestibulum maecenas laoreet, consequat mauris hendrerit ipsum elit sed natoque, tellus placerat vitae donec pharetra nulla. Conubia dictum orci nec quam sed, donec congue neque luctus vitae quam, lectus ornare blandit vestibulum semper nullam sollicitudin. Nam sem non aut justo vel enim, eu metus orci arcu lobortis amet, ac sem phasellus velit ac turpis adipiscing, nulla tempus purus vel orci quisque ac. Sed et metus sed ligula purus, consectetuer illo ut sed faucibus suspendisse suspendisse, cursus sed orci ipsum aenean in et, viverra maecenas nec nec lectus tempus. Id nec fusce hymenaeos vitae laboriosam, placerat condimentum diam amet ullamcorper risus, pellentesque mollis magna non enim dolor semper. Sem nullam a dui venenatis a, massa consectetuer in aenean eget condimentum, scelerisque eum euismod ultricies sint velit. A mattis sit nec aenean tempus cras, ligula dignissim nullam mauris curae neque, a dignissim morbi mi curabitur nulla, non tellus orci nonummy sed posuere aliquam, sapien incidunt in sed duis ac etiam. Etiam eget nonummy bibendum praesent eget aliquam, sed auctor erat neque in metus maecenas, amet id pellentesque gravida in wisi tristique, in eu eros non vitae diam turpis, massa et vel litora massa sagittis vehicula. Pede amet vivamus elementum donec maecenas erat, a dolor elit aptent orci pretium ligula, velit proin vestibulum wisi lorem eget, euismod fusce amet libero et id, nunc imperdiet consectetuer elementum integer repellat sodales. In risus morbi nibh rerum ut nonummy, ligula suscipit pharetra dolor diam ornare, ullamcorper nonummy ut wisi vestibulum vivamus convallis. Est porta eros euismod nulla ullamcorper, metus vestibulum libero est mauris tortor nulla, a nulla non vivamus sed non vestibulum, suscipit sed euismod ut nisl et elit. Vel at eget orci fringilla leo, non maecenas vestibulum mauris dictum justo rutrum, integer ultrices sit purus aliquam phasellus, turpis iaculis non non commodo tortor pulvinar, habitasse tincidunt integer lorem vestibulum porta. Magna libero purus imperdiet neque molestie, nonummy eget repellendus volutpat nulla elit, in in varius metus nam vel dictum, libero ultricies justo felis duis ante sit, turpis amet sociis sit dolor cras est. Risus id mattis eget commodo faucibus, porttitor vulputate quis tellus wisi interdum dictum, mauris a sodales erat elementum amet. Ligula odio pellentesque nam et vitae eu, dui eleifend consequat at id eget, imperdiet malesuada arcu suspendisse faucibus ipsum, vivamus ullamcorper semper volutpat sit in, dignissim feugiat litora dapibus porta id purus. Lorem mi vehicula ultrices massa tortor in, lacus pellentesque donec enim feugiat volutpat quis, dictum pede pellentesque elit massa in, at cras urna enim sem posuere explicabo, nibh eget vitae nunc interdum egestas. Sagittis a amet penatibus nec tincidunt felis, feugiat nascetur quisque phasellus justo ligula vestibulum, magnis aptent felis integer tempor sodales porttitor, vitae lorem orci lobortis aliquam condimentum congue. Et arcu vehicula venenatis magna rhoncus etiam, neque nulla eu vel vestibulum amet adipiscing, suspendisse lacinia ac ad nec risus, dolor orci gravida a arcu volutpat, ac arcu at nascetur accusamus eu. In pulvinar vitae nonummy placerat neque sapien, fusce amet lorem quam parturient mi, lorem vehicula nec suspendisse luctus eu. Mollis leo lacus vel at dapibus eros, in ex orci tortor adipiscing in, sodales facilisis integer elit lectus iaculis, elit posuere turpis pretium nec sodales. Parturient eleifend aliquam pretium urna dignissim venenatis, quis tellus urna enim donec sagittis, lectus nullam in consectetuer ac a erat. Lorem donec in in amet mauris, id convallis turpis in lacus taciti a, nec neque vestibulum dolor amet condimentum, sit magnis ultricies urna interdum maecenas. Dictum ipsum sapien leo suspendisse velit, et rutrum est sodales porta parturient, justo inceptos pede pellentesque posuere erat qui, at suspendisse elit ut consequat vestibulum. Ut ut lectus orci pellentesque mollis, ullamcorper nulla volutpat mattis dui eget, fermentum purus quis pellentesque aliquet habitant. Fringilla neque morbi vulputate nulla inventore, lorem velit feugiat tortor quam turpis, cum eget animi sit tempor volutpat ac. A id velit ut maxime in, pede sapien augue duis ultrices interdum eu, praesent consectetuer id a ipsum mauris at. Velit mattis metus mi malesuada pede quam, arcu vitae eros lectus sed venenatis, quis vestibulum quam in tortor maecenas ac, non massa justo nisl pharetra volutpat diam. Urna ad egestas in mauris volutpat donec, maecenas nisl nunc id quam ultricies tristique, leo nibh at sit nunc vitae commodo, ut leo lectus montes eu condimentum id, morbi vestibulum volutpat aliquet sit cras vivamus. Aliquet nec class pede morbi in quam, porttitor eu vel maecenas est ipsum doloremque, pede elit vestibulum fugiat sed tristique, arcu sem sollicitudin nec arcu est, pretium nisl magna sed mattis vitae augue. Natoque at vel tortor placerat tristique, convallis mauris sodales ac consequat ac ut, vestibulum pretium aliquam eget non tempor. Leo justo urna suspendisse sollicitudin imperdiet quis, fringilla nunc pede malesuada quam faucibus nibh, habitasse vestibulum rhoncus velit id donec velit, vivamus sed id vitae posuere lectus. Pellentesque urna vel eu felis ullamcorper, vel accumsan urna massa wisi metus, donec elit velit eget malesuada maecenas, lectus amet etiam sollicitudin feugiat in orci, integer morbi ridiculus tincidunt suscipit donec consequatur. Ultricies ut diam blandit praesent aliquam egestas, tellus varius inceptos duis pellentesque auctor per, libero donec fringilla est amet metus, ipsum est nunc massa cras vel aliquam. Eros curabitur non interdum nisl ac, mauris quisque quam metus dui morbi vel, quis id dolor urna dictumst vel nunc, fringilla velit vel semper vel tempus. Massa nullam in turpis justo rutrum et, velit in blandit lobortis libero dolor, ante urna lobortis et vivamus purus, est wisi mauris erat libero aliquet metus, wisi mollis nam pulvinar vivamus sed orci. Odio dictumst ut mi ultrices dui, quam varius imperdiet posuere donec nec arcu, ac sit eros lacus purus morbi massa, turpis luctus at eget ante sed, ut nunc nulla nec sunt scelerisque. Arcu leo augue libero gravida nam duis, torquent mus elit mus sociis id arcu, montes id consectetuer ipsum purus tincidunt lectus. Feugiat libero convallis in nunc viverra, mauris pharetra a maecenas ut risus a, tempus gravida cursus amet rhoncus luctus. Pharetra consectetuer ut dolor nostra dolor sed, curabitur odio quam et eget sed, vestibulum porta tempus imperdiet ullamcorper ad ultrices. Molestiae vel arcu nec neque doloribus, dui aliquam pharetra varius ad quaerat sed, et nec ornare nullam vivamus viverra, sed vitae egestas et felis ultrices nonummy. Tincidunt provident vivamus proin pellentesque turpis, justo habitant inceptos feugiat ultrices eu, tellus dolorum donec hac rhoncus lorem sit. Orci gravida consectetuer wisi imperdiet consequat, non metus eos dolor sed eu urna, fusce aliquam et malesuada proin vitae, elementum magna et non mattis augue, luctus hendrerit sit a asperiores eius. Aliquam bibendum erat curabitur pharetra pellentesque, mauris suspendisse hendrerit sed orci aliquam, augue amet nascetur duis vitae donec, feugiat condimentum habitasse elit ac ante turpis. Amet vitae dolor adipiscing turpis non, molestie dapibus lacus a et ante penatibus, condimentum mi quam quis suspendisse pellentesque ullamcorper, ac fringilla amet felis eget felis, malesuada montes amet vehicula urna neque ut. Orci mattis quisque lectus id a, enim suspendisse curabitur ut massa dignissim proin, pellentesque aliquam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, vel habitant erat suspendisse tristique eu est. Parturient vulputate pharetra vitae integer magna morbi, class ullamcorper porta vel amet molestie, felis dapibus pulvinar sit praesent leo lacus. Tristique nam ut tempor metus euismod sodales, urna sit sed vestibulum praesent nec, adipiscing eget et nec est ut, tempor nonummy phasellus sem vestibulum eu varius, purus nibh nulla eu nostra tristique. Est ut ultricies quam vestibulum lobortis nibh, purus imperdiet quis hymenaeos impedit porta, pharetra ornare laudantium elit nulla in, morbi vehicula amet lacinia nec vulputate eu. Tellus lobortis est quis amet non, nec risus mauris nisi tortor dictum integer, consectetuer luctus vel fusce suspendisse egestas magna. Massa sed elementum aliquet ornare metus lorem, odio est platea nunc mattis imperdiet commodo, laoreet et a felis amet wisi, massa vulputate pulvinar non gravida vivamus. Sed ante metus dolor velit nunc, tempus nec vestibulum in sed venenatis, dui mollis sit tristique ultricies sociis, magna ante dolor ipsum sodales amet. Malesuada sed facilisis sit tempor urna, iaculis est cras fusce wisi vivamus, etiam ullamcorper gravida risus sed rutrum, in quis arcu nec quis ut, arcu massa suspendisse ipsum in dui. Suspendisse class vivamus nullam fermentum ac, vehicula sollicitudin suam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, veec viverra voluLorem ipsum dolor sit amet, fermentum pharetra ipsum sed mauris scelerisque culpa, laoreet libero etiam pharetra eu lacus, sed varius magna hac tellus praesent in, suspendisse urna tellus placerat non risus. Porttitor nonummy vehicula wisi sint tempor, vitae tellus nulla fermentum quis quis, mauris dignissim omnis porta ac volutpat, hac eget viverra in gravida nonummy pulvinar, velit nulla feugiat parturient netus mollis aliquam. Arcu leo scelerisque quisque blandit pellentesque, ultricies nascetur purus cursus imperdiet accumsan sagittis, praesent nunc sed dapibus dui in. Cubilia lorem lacus tellus diam debitis, commodo fusce dolor adipisicing consectetuer et vitae, vestibulum ornare accumsan vitae accumsan praesent, morbi faucibus justo lorem augue porta sodales, molestie nulla ac nibh nec est aenean. Praesent erat maecenas odio ante dolor, vehicula nam mi ultrices ut dolor ante, fusce ridiculus at arcu urna felis vel, a pellentesque arcu accumsan nulla deserunt. Nunc ornare nec a diam aliquam urna, maecenas vivamus senectus sagittis tellus ac faucibus, mi leo quam tempor amet facilisis, sapien per cras placerat libero porta, vitae mauris quis sit nec ut. Sit magna vitae donec leo urna, nascetur eu viverra massa amet pharetra proident, elit commodo ipsum proin pellentesque consequat feugiat, elit sit quis facilisis ipsum ornare pellentesque. Morbi enim et et pretium et tortor, praesent adipiscing placerat aliquet dolor vestibulum, tempus at consectetuer ut diam fermentum nulla. Pellentesque lorem phasellus tristique a ac donec, augue suspendisse orci consequat rhoncus dapibus, magna quam habitasse assumenda duis imperdiet scelerisque. Turpis iaculis ipsum phasellus vitae et, nunc congue rhoncus eu diam in, rutrum dui mauris leo est sodales. Ut ante tempora imperdiet orci in ut, turpis laoreet dapibus penatibus ut in, tempor ac gravida est nam lorem dictum. Lacinia bibendum vitae ante lacus in, orci per orci amet sed dolor lorem, ullamcorper at a praesent quis dictum consectetuer, dolor nunc fermentum interdum tortor voluptatem. Vestibulum cursus nunc nunc risus nec metus, diam mauris vestibulum nullam pellentesque ipsum, maecenas et semper platea wisi porttitor curabitur. Quis adipiscing adipiscing purus vestibulum gravida, lacinia justo vel interdum sociosqu lacus, wisi leo fusce aenean arcu sapien volutpat, ipsum accumsan a ornare tellus et. Sagittis sit malesuada pellentesque nulla enim, accumsan tempor a in vehicula et ipsum, montes est risus adipiscing wisi amet, sed tempus eu purus quisque donec. In non purus wisi donec vel amet, maecenas enim cursus etiam dapibus ac, in fringilla facilisis nibh congue et, commodo et curabitur sapien ut facilisis, morbi turpis facilisis sit tortor faucibus in. Ut aenean erat tempor purus et venenatis, cursus feugiat amet blandit vel bibendum, mi purus felis odio suspendisse sed, nunc urna eum tincidunt a consequat, venenatis curabitur elit nullam aliquam nec laboriosam. Vestibulum integer ut cursus laoreet odio, tincidunt maecenas vel sed ut ac varius, malesuada diam libero sodales ipsum sed, viverra erat sit integer quisque iaculis volutpat, penatibus quam donec accumsan duis in a. Sodales ipsum torquent tempus dolore sit, sagittis mauris nisl in sed rutrum a, amet ut elit fusce libero netus egestas, lobortis sit turpis augue maecenas integer. Eget porttitor nunc risus faucibus enim, donec nec convallis egestas pellentesque lectus felis, vulputate suspendisse risus metus blandit quis, a suspendisse nonummy enim fermentum per dapibus. Et faucibus vestibulum iaculis sapiente per accumsan, fringilla elementum auctor praesent sollicitudin rutrum laoreet, fugit suspendisse duis et vestibulum eu euismod, feugiat quis sit nunc dolor urna. Id suscipit porta sed wisi nam vehicula, integer ut massa donec eget dolor sapien, elit tincidunt condimentum rutrum magna pede, est tellus pellentesque facilisi dictum laoreet amet, ac quam ligula pede vitae pellentesque. Litora sed a cubilia dui vestibulum felis, nascetur hac parturient integer convallis in, donec tellus ipsum aliquam proin massa. In pede eu parturient nisl lectus, amet magna at sit massa ipsum pellentesque, pharetra augue dolor egestas porta dictum mi. Leo etiam dui mauris turpis erat vel, velit bibendum odio sagittis sagittis in, sodales vitae et massa at mattis. Vulputate nonummy pede rhoncus est ut, placerat placerat tristique in aliquet id, lobortis sed non ornare vestibulum consectetuer. Risus augue sed ac lectus volutpat, nulla arcu iaculis aenean aliquam ut lacinia, at mi amet facilisis purus morbi sollicitudin. Eget nulla molestie lectus tincidunt vel, tellus quo odio nonummy mauris felis, integer sapien tellus dignissim viverra lorem suspendisse. Duis molestiae sem vel eu orci, a nibh a lorem porttitor quisque tincidunt, euismod a dui sodales aliquam aliquet, fusce mollis maecenas aenean etiam vestibulum. Neque bibendum cras vitae turpis in, eget pulvinar curabitur non voluptatibus sit, malesuada sodales non quam bibendum malesuada rutrum, velit lacus at sit diam ultrices tempus, pellentesque in a hendrerit dictumst aenean a. Tellus praesent elit sodales sodales neque diam, odio aliquam lorem nulla accumsan nec, eget vestibulum nunc eget dignissim mauris eu, tristique etiam sapien nulla cillum pharetra dolor, at sapien auctor quis fringilla faucibus. Suspendisse hendrerit morbi auctor nulla imperdiet tortor, nunc risus ut id justo adipiscing, amet vivamus cursus aenean hendrerit nec nibh. Cursus dui maecenas at suspendisse morbi, lectus hymenaeos viverra in erat nesciunt, et tempore nesciunt nibh non excepturi. Dignissim nullam blandit mauris turpis quam, ac litora ipsum pellentesque ipsum ultrices, a nec curabitur vel tortor praesent. Justo vel sit phasellus mauris pede aliquet, donec ante sed vulputate quis consectetuer urna, eu non metus a hendrerit praesent, pellentesque lobortis arcu quis consectetuer scelerisque, vel excepturi risus imperdiet auctor neque. Et dictumst non mattis nibh mi, sed id semper et commodo morbi, amet eget mollis morbi urna in lobortis. Purus proin morbi mi arcu nostra minima, sed id elit purus justo a enim, lectus placerat fusce ante consequat wisi tellus, donec donec tortor ut orci eu, tincidunt amet venenatis tristique in aliquam integer. Nulla in vehicula cras suscipit urna voluptas, dolor aliquet porttitor ornare fermentum amet adipiscing, ipsum nec mauris tellus mauris aliquam, suscipit ac dignissim sodales sem suscipit. Feugiat tincidunt vitae ornare elit faucibus aliquid, volutpat posuere libero labore sollicitudin ultricies, porttitor aliquam vestibulum ac non lacinia vitae. Magna suscipit suscipit sapien imperdiet tristique, morbi in et vulputate ut adipiscing cum, lorem libero justo mauris non pede donec, suspendisse iaculis porta turpis ut integer. Et lacinia in elementum nulla quam, posuere quam nisl vivamus et maecenas eros, magna lectus a rutrum malesuada nonummy. Sociosqu mi quis ligula lectus vel, mauris vestibulum ipsum vulputate in pede, pulvinar aliquam at justo wisi in elit. Ullamcorper proin nec in suscipit nibh sagittis, justo magna a purus in dictum morbi, donec nullam etiam tellus consectetuer mauris, felis morbi ante sapien sit nibh etiam. Varius malesuada est ultrices fusce ridiculus, leo nulla libero nec sed habitasse, et dignissim ad mi justo pellentesque odio. Interdum potenti donec a tincidunt nibh lorem, eleifend sagittis mollit ipsum at donec, cursus at tincidunt cras sit eget, varius vel pharetra ut in donec, at urna viverra sed magnis feugiat. Fames dapibus vivamus fringilla adipiscing quas, ut risus eget mauris sed ante, cras a ac orci cursus nascetur risus, dis gravida egestas turpis id vestibulum. Iaculis eget sem tortor odio lectus pede, condimentum dictum feugiat massa odio hendrerit aperiam, felis et nulla ut ligula wisi praesent, justo nonummy tempor dignissim lorem arcu dapibus. Luctus donec vulputate eu vestibulum maecenas laoreet, consequat mauris hendrerit ipsum elit sed natoque, tellus placerat vitae donec pharetra nulla. Conubia dictum orci nec quam sed, donec congue neque luctus vitae quam, lectus ornare blandit vestibulum semper nullam sollicitudin. Nam sem non aut justo vel enim, eu metus orci arcu lobortis amet, ac sem phasellus velit ac turpis adipiscing, nulla tempus purus vel orci quisque ac. Sed et metus sed ligula purus, consectetuer illo ut sed faucibus suspendisse suspendisse, cursus sed orci ipsum aenean in et, viverra maecenas nec nec lectus tempus. Id nec fusce hymenaeos vitae laboriosam, placerat condimentum diam amet ullamcorper risus, pellentesque mollis magna non enim dolor semper. Sem nullam a dui venenatis a, massa consectetuer in aenean eget condimentum, scelerisque eum euismod ultricies sint velit. A mattis sit nec aenean tempus cras, ligula dignissim nullam mauris curae neque, a dignissim morbi mi curabitur nulla, non tellus orci nonummy sed posuere aliquam, sapien incidunt in sed duis ac etiam. Etiam eget nonummy bibendum praesent eget aliquam, sed auctor erat neque in metus maecenas, amet id pellentesque gravida in wisi tristique, in eu eros non vitae diam turpis, massa et vel litora massa sagittis vehicula. Pede amet vivamus elementum donec maecenas erat, a dolor elit aptent orci pretium ligula, velit proin vestibulum wisi lorem eget, euismod fusce amet libero et id, nunc imperdiet consectetuer elementum integer repellat sodales. In risus morbi nibh rerum ut nonummy, ligula suscipit pharetra dolor diam ornare, ullamcorper nonummy ut wisi vestibulum vivamus convallis. Est porta eros euismod nulla ullamcorper, metus vestibulum libero est mauris tortor nulla, a nulla non vivamus sed non vestibulum, suscipit sed euismod ut nisl et elit. Vel at eget orci fringilla leo, non maecenas vestibulum mauris dictum justo rutrum, integer ultrices sit purus aliquam phasellus, turpis iaculis non non commodo tortor pulvinar, habitasse tincidunt integer lorem vestibulum porta. Magna libero purus imperdiet neque molestie, nonummy eget repellendus volutpat nulla elit, in in varius metus nam vel dictum, libero ultricies justo felis duis ante sit, turpis amet sociis sit dolor cras est. Risus id mattis eget commodo faucibus, porttitor vulputate quis tellus wisi interdum dictum, mauris a sodales erat elementum amet. Ligula odio pellentesque nam et vitae eu, dui eleifend consequat at id eget, imperdiet malesuada arcu suspendisse faucibus ipsum, vivamus ullamcorper semper volutpat sit in, dignissim feugiat litora dapibus porta id purus. Lorem mi vehicula ultrices massa tortor in, lacus pellentesque donec enim feugiat volutpat quis, dictum pede pellentesque elit massa in, at cras urna enim sem posuere explicabo, nibh eget vitae nunc interdum egestas. Sagittis a amet penatibus nec tincidunt felis, feugiat nascetur quisque phasellus justo ligula vestibulum, magnis aptent felis integer tempor sodales porttitor, vitae lorem orci lobortis aliquam condimentum congue. Et arcu vehicula venenatis magna rhoncus etiam, neque nulla eu vel vestibulum amet adipiscing, suspendisse lacinia ac ad nec risus, dolor orci gravida a arcu volutpat, ac arcu at nascetur accusamus eu. In pulvinar vitae nonummy placerat neque sapien, fusce amet lorem quam parturient mi, lorem vehicula nec suspendisse luctus eu. Mollis leo lacus vel at dapibus eros, in ex orci tortor adipiscing in, sodales facilisis integer elit lectus iaculis, elit posuere turpis pretium nec sodales. Parturient eleifend aliquam pretium urna dignissim venenatis, quis tellus urna enim donec sagittis, lectus nullam in consectetuer ac a erat. Lorem donec in in amet mauris, id convallis turpis in lacus taciti a, nec neque vestibulum dolor amet condimentum, sit magnis ultricies urna interdum maecenas. Dictum ipsum sapien leo suspendisse velit, et rutrum est sodales porta parturient, justo inceptos pede pellentesque posuere erat qui, at suspendisse elit ut consequat vestibulum. Ut ut lectus orci pellentesque mollis, ullamcorper nulla volutpat mattis dui eget, fermentum purus quis pellentesque aliquet habitant. Fringilla neque morbi vulputate nulla inventore, lorem velit feugiat tortor quam turpis, cum eget animi sit tempor volutpat ac. A id velit ut maxime in, pede sapien augue duis ultrices interdum eu, praesent consectetuer id a ipsum mauris at. Velit mattis metus mi malesuada pede quam, arcu vitae eros lectus sed venenatis, quis vestibulum quam in tortor maecenas ac, non massa justo nisl pharetra volutpat diam. Urna ad egestas in mauris volutpat donec, maecenas nisl nunc id quam ultricies tristique, leo nibh at sit nunc vitae commodo, ut leo lectus montes eu condimentum id, morbi vestibulum volutpat aliquet sit cras vivamus. Aliquet nec class pede morbi in quam, porttitor eu vel maecenas est ipsum doloremque, pede elit vestibulum fugiat sed tristique, arcu sem sollicitudin nec arcu est, pretium nisl magna sed mattis vitae augue. Natoque at vel tortor placerat tristique, convallis mauris sodales ac consequat ac ut, vestibulum pretium aliquam eget non tempor. Leo justo urna suspendisse sollicitudin imperdiet quis, fringilla nunc pede malesuada quam faucibus nibh, habitasse vestibulum rhoncus velit id donec velit, vivamus sed id vitae posuere lectus. Pellentesque urna vel eu felis ullamcorper, vel accumsan urna massa wisi metus, donec elit velit eget malesuada maecenas, lectus amet etiam sollicitudin feugiat in orci, integer morbi ridiculus tincidunt suscipit donec consequatur. Ultricies ut diam blandit praesent aliquam egestas, tellus varius inceptos duis pellentesque auctor per, libero donec fringilla est amet metus, ipsum est nunc massa cras vel aliquam. Eros curabitur non interdum nisl ac, mauris quisque quam metus dui morbi vel, quis id dolor urna dictumst vel nunc, fringilla velit vel semper vel tempus. Massa nullam in turpis justo rutrum et, velit in blandit lobortis libero dolor, ante urna lobortis et vivamus purus, est wisi mauris erat libero aliquet metus, wisi mollis nam pulvinar vivamus sed orci. Odio dictumst ut mi ultrices dui, quam varius imperdiet posuere donec nec arcu, ac sit eros lacus purus morbi massa, turpis luctus at eget ante sed, ut nunc nulla nec sunt scelerisque. Arcu leo augue libero gravida nam duis, torquent mus elit mus sociis id arcu, montes id consectetuer ipsum purus tincidunt lectus. Feugiat libero convallis in nunc viverra, mauris pharetra a maecenas ut risus a, tempus gravida cursus amet rhoncus luctus. Pharetra consectetuer ut dolor nostra dolor sed, curabitur odio quam et eget sed, vestibulum porta tempus imperdiet ullamcorper ad ultrices. Molestiae vel arcu nec neque doloribus, dui aliquam pharetra varius ad quaerat sed, et nec ornare nullam vivamus viverra, sed vitae egestas et felis ultrices nonummy. Tincidunt provident vivamus proin pellentesque turpis, justo habitant inceptos feugiat ultrices eu, tellus dolorum donec hac rhoncus lorem sit. Orci gravida consectetuer wisi imperdiet consequat, non metus eos dolor sed eu urna, fusce aliquam et malesuada proin vitae, elementum magna et non mattis augue, luctus hendrerit sit a asperiores eius. Aliquam bibendum erat curabitur pharetra pellentesque, mauris suspendisse hendrerit sed orci aliquam, augue amet nascetur duis vitae donec, feugiat condimentum habitasse elit ac ante turpis. Amet vitae dolor adipiscing turpis non, molestie dapibus lacus a et ante penatibus, condimentum mi quam quis suspendisse pellentesque ullamcorper, ac fringilla amet felis eget felis, malesuada montes amet vehicula urna neque ut. Orci mattis quisque lectus id a, enim suspendisse curabitur ut massa dignissim proin, pellentesque aliquam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, vel habitant erat suspendisse tristique eu est. Parturient vulputate pharetra vitae integer magna morbi, class ullamcorper porta vel amet molestie, felis dapibus pulvinar sit praesent leo lacus. Tristique nam ut tempor metus euismod sodales, urna sit sed vestibulum praesent nec, adipiscing eget et nec est ut, tempor nonummy phasellus sem vestibulum eu varius, purus nibh nulla eu nostra tristique. Est ut ultricies quam vestibulum lobortis nibh, purus imperdiet quis hymenaeos impedit porta, pharetra ornare laudantium elit nulla in, morbi vehicula amet lacinia nec vulputate eu. Tellus lobortis est quis amet non, nec risus mauris nisi tortor dictum integer, consectetuer luctus vel fusce suspendisse egestas magna. Massa sed elementum aliquet ornare metus lorem, odio est platea nunc mattis imperdiet commodo, laoreet et a felis amet wisi, massa vulputate pulvinar non gravida vivamus. Sed ante metus dolor velit nunc, tempus nec vestibulum in sed venenatis, dui mollis sit tristique ultricies sociis, magna ante dolor ipsum sodales amet. Malesuada sed facilisis sit tempor urna, iaculis est cras fusce wisi vivamus, etiam ullamcorper gravida risus sed rutrum, in quis arcu nec quis ut, arcu massa suspendisse ipsum in dui. Suspendisse class vivamus nullam fermentum ac, vehicula sollicitudin suam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, veec viverra voluLorem ipsum dolor sit amet, fermentum pharetra ipsum sed mauris scelerisque culpa, laoreet libero etiam pharetra eu lacus, sed varius magna hac tellus praesent in, suspendisse urna tellus placerat non risus. Porttitor nonummy vehicula wisi sint tempor, vitae tellus nulla fermentum quis quis, mauris dignissim omnis porta ac volutpat, hac eget viverra in gravida nonummy pulvinar, velit nulla feugiat parturient netus mollis aliquam. Arcu leo scelerisque quisque blandit pellentesque, ultricies nascetur purus cursus imperdiet accumsan sagittis, praesent nunc sed dapibus dui in. Cubilia lorem lacus tellus diam debitis, commodo fusce dolor adipisicing consectetuer et vitae, vestibulum ornare accumsan vitae accumsan praesent, morbi faucibus justo lorem augue porta sodales, molestie nulla ac nibh nec est aenean. Praesent erat maecenas odio ante dolor, vehicula nam mi ultrices ut dolor ante, fusce ridiculus at arcu urna felis vel, a pellentesque arcu accumsan nulla deserunt. Nunc ornare nec a diam aliquam urna, maecenas vivamus senectus sagittis tellus ac faucibus, mi leo quam tempor amet facilisis, sapien per cras placerat libero porta, vitae mauris quis sit nec ut. Sit magna vitae donec leo urna, nascetur eu viverra massa amet pharetra proident, elit commodo ipsum proin pellentesque consequat feugiat, elit sit quis facilisis ipsum ornare pellentesque. Morbi enim et et pretium et tortor, praesent adipiscing placerat aliquet dolor vestibulum, tempus at consectetuer ut diam fermentum nulla. Pellentesque lorem phasellus tristique a ac donec, augue suspendisse orci consequat rhoncus dapibus, magna quam habitasse assumenda duis imperdiet scelerisque. Turpis iaculis ipsum phasellus vitae et, nunc congue rhoncus eu diam in, rutrum dui mauris leo est sodales. Ut ante tempora imperdiet orci in ut, turpis laoreet dapibus penatibus ut in, tempor ac gravida est nam lorem dictum. Lacinia bibendum vitae ante lacus in, orci per orci amet sed dolor lorem, ullamcorper at a praesent quis dictum consectetuer, dolor nunc fermentum interdum tortor voluptatem. Vestibulum cursus nunc nunc risus nec metus, diam mauris vestibulum nullam pellentesque ipsum, maecenas et semper platea wisi porttitor curabitur. Quis adipiscing adipiscing purus vestibulum gravida, lacinia justo vel interdum sociosqu lacus, wisi leo fusce aenean arcu sapien volutpat, ipsum accumsan a ornare tellus et. Sagittis sit malesuada pellentesque nulla enim, accumsan tempor a in vehicula et ipsum, montes est risus adipiscing wisi amet, sed tempus eu purus quisque donec. In non purus wisi donec vel amet, maecenas enim cursus etiam dapibus ac, in fringilla facilisis nibh congue et, commodo et curabitur sapien ut facilisis, morbi turpis facilisis sit tortor faucibus in. Ut aenean erat tempor purus et venenatis, cursus feugiat amet blandit vel bibendum, mi purus felis odio suspendisse sed, nunc urna eum tincidunt a consequat, venenatis curabitur elit nullam aliquam nec laboriosam. Vestibulum integer ut cursus laoreet odio, tincidunt maecenas vel sed ut ac varius, malesuada diam libero sodales ipsum sed, viverra erat sit integer quisque iaculis volutpat, penatibus quam donec accumsan duis in a. Sodales ipsum torquent tempus dolore sit, sagittis mauris nisl in sed rutrum a, amet ut elit fusce libero netus egestas, lobortis sit turpis augue maecenas integer. Eget porttitor nunc risus faucibus enim, donec nec convallis egestas pellentesque lectus felis, vulputate suspendisse risus metus blandit quis, a suspendisse nonummy enim fermentum per dapibus. Et faucibus vestibulum iaculis sapiente per accumsan, fringilla elementum auctor praesent sollicitudin rutrum laoreet, fugit suspendisse duis et vestibulum eu euismod, feugiat quis sit nunc dolor urna. Id suscipit porta sed wisi nam vehicula, integer ut massa donec eget dolor sapien, elit tincidunt condimentum rutrum magna pede, est tellus pellentesque facilisi dictum laoreet amet, ac quam ligula pede vitae pellentesque. Litora sed a cubilia dui vestibulum felis, nascetur hac parturient integer convallis in, donec tellus ipsum aliquam proin massa. In pede eu parturient nisl lectus, amet magna at sit massa ipsum pellentesque, pharetra augue dolor egestas porta dictum mi. Leo etiam dui mauris turpis erat vel, velit bibendum odio sagittis sagittis in, sodales vitae et massa at mattis. Vulputate nonummy pede rhoncus est ut, placerat placerat tristique in aliquet id, lobortis sed non ornare vestibulum consectetuer. Risus augue sed ac lectus volutpat, nulla arcu iaculis aenean aliquam ut lacinia, at mi amet facilisis purus morbi sollicitudin. Eget nulla molestie lectus tincidunt vel, tellus quo odio nonummy mauris felis, integer sapien tellus dignissim viverra lorem suspendisse. Duis molestiae sem vel eu orci, a nibh a lorem porttitor quisque tincidunt, euismod a dui sodales aliquam aliquet, fusce mollis maecenas aenean etiam vestibulum. Neque bibendum cras vitae turpis in, eget pulvinar curabitur non voluptatibus sit, malesuada sodales non quam bibendum malesuada rutrum, velit lacus at sit diam ultrices tempus, pellentesque in a hendrerit dictumst aenean a. Tellus praesent elit sodales sodales neque diam, odio aliquam lorem nulla accumsan nec, eget vestibulum nunc eget dignissim mauris eu, tristique etiam sapien nulla cillum pharetra dolor, at sapien auctor quis fringilla faucibus. Suspendisse hendrerit morbi auctor nulla imperdiet tortor, nunc risus ut id justo adipiscing, amet vivamus cursus aenean hendrerit nec nibh. Cursus dui maecenas at suspendisse morbi, lectus hymenaeos viverra in erat nesciunt, et tempore nesciunt nibh non excepturi. Dignissim nullam blandit mauris turpis quam, ac litora ipsum pellentesque ipsum ultrices, a nec curabitur vel tortor praesent. Justo vel sit phasellus mauris pede aliquet, donec ante sed vulputate quis consectetuer urna, eu non metus a hendrerit praesent, pellentesque lobortis arcu quis consectetuer scelerisque, vel excepturi risus imperdiet auctor neque. Et dictumst non mattis nibh mi, sed id semper et commodo morbi, amet eget mollis morbi urna in lobortis. Purus proin morbi mi arcu nostra minima, sed id elit purus justo a enim, lectus placerat fusce ante consequat wisi tellus, donec donec tortor ut orci eu, tincidunt amet venenatis tristique in aliquam integer. Nulla in vehicula cras suscipit urna voluptas, dolor aliquet porttitor ornare fermentum amet adipiscing, ipsum nec mauris tellus mauris aliquam, suscipit ac dignissim sodales sem suscipit. Feugiat tincidunt vitae ornare elit faucibus aliquid, volutpat posuere libero labore sollicitudin ultricies, porttitor aliquam vestibulum ac non lacinia vitae. Magna suscipit suscipit sapien imperdiet tristique, morbi in et vulputate ut adipiscing cum, lorem libero justo mauris non pede donec, suspendisse iaculis porta turpis ut integer. Et lacinia in elementum nulla quam, posuere quam nisl vivamus et maecenas eros, magna lectus a rutrum malesuada nonummy. Sociosqu mi quis ligula lectus vel, mauris vestibulum ipsum vulputate in pede, pulvinar aliquam at justo wisi in elit. Ullamcorper proin nec in suscipit nibh sagittis, justo magna a purus in dictum morbi, donec nullam etiam tellus consectetuer mauris, felis morbi ante sapien sit nibh etiam. Varius malesuada est ultrices fusce ridiculus, leo nulla libero nec sed habitasse, et dignissim ad mi justo pellentesque odio. Interdum potenti donec a tincidunt nibh lorem, eleifend sagittis mollit ipsum at donec, cursus at tincidunt cras sit eget, varius vel pharetra ut in donec, at urna viverra sed magnis feugiat. Fames dapibus vivamus fringilla adipiscing quas, ut risus eget mauris sed ante, cras a ac orci cursus nascetur risus, dis gravida egestas turpis id vestibulum. Iaculis eget sem tortor odio lectus pede, condimentum dictum feugiat massa odio hendrerit aperiam, felis et nulla ut ligula wisi praesent, justo nonummy tempor dignissim lorem arcu dapibus. Luctus donec vulputate eu vestibulum maecenas laoreet, consequat mauris hendrerit ipsum elit sed natoque, tellus placerat vitae donec pharetra nulla. Conubia dictum orci nec quam sed, donec congue neque luctus vitae quam, lectus ornare blandit vestibulum semper nullam sollicitudin. Nam sem non aut justo vel enim, eu metus orci arcu lobortis amet, ac sem phasellus velit ac turpis adipiscing, nulla tempus purus vel orci quisque ac. Sed et metus sed ligula purus, consectetuer illo ut sed faucibus suspendisse suspendisse, cursus sed orci ipsum aenean in et, viverra maecenas nec nec lectus tempus. Id nec fusce hymenaeos vitae laboriosam, placerat condimentum diam amet ullamcorper risus, pellentesque mollis magna non enim dolor semper. Sem nullam a dui venenatis a, massa consectetuer in aenean eget condimentum, scelerisque eum euismod ultricies sint velit. A mattis sit nec aenean tempus cras, ligula dignissim nullam mauris curae neque, a dignissim morbi mi curabitur nulla, non tellus orci nonummy sed posuere aliquam, sapien incidunt in sed duis ac etiam. Etiam eget nonummy bibendum praesent eget aliquam, sed auctor erat neque in metus maecenas, amet id pellentesque gravida in wisi tristique, in eu eros non vitae diam turpis, massa et vel litora massa sagittis vehicula. Pede amet vivamus elementum donec maecenas erat, a dolor elit aptent orci pretium ligula, velit proin vestibulum wisi lorem eget, euismod fusce amet libero et id, nunc imperdiet consectetuer elementum integer repellat sodales. In risus morbi nibh rerum ut nonummy, ligula suscipit pharetra dolor diam ornare, ullamcorper nonummy ut wisi vestibulum vivamus convallis. Est porta eros euismod nulla ullamcorper, metus vestibulum libero est mauris tortor nulla, a nulla non vivamus sed non vestibulum, suscipit sed euismod ut nisl et elit. Vel at eget orci fringilla leo, non maecenas vestibulum mauris dictum justo rutrum, integer ultrices sit purus aliquam phasellus, turpis iaculis non non commodo tortor pulvinar, habitasse tincidunt integer lorem vestibulum porta. Magna libero purus imperdiet neque molestie, nonummy eget repellendus volutpat nulla elit, in in varius metus nam vel dictum, libero ultricies justo felis duis ante sit, turpis amet sociis sit dolor cras est. Risus id mattis eget commodo faucibus, porttitor vulputate quis tellus wisi interdum dictum, mauris a sodales erat elementum amet. Ligula odio pellentesque nam et vitae eu, dui eleifend consequat at id eget, imperdiet malesuada arcu suspendisse faucibus ipsum, vivamus ullamcorper semper volutpat sit in, dignissim feugiat litora dapibus porta id purus. Lorem mi vehicula ultrices massa tortor in, lacus pellentesque donec enim feugiat volutpat quis, dictum pede pellentesque elit massa in, at cras urna enim sem posuere explicabo, nibh eget vitae nunc interdum egestas. Sagittis a amet penatibus nec tincidunt felis, feugiat nascetur quisque phasellus justo ligula vestibulum, magnis aptent felis integer tempor sodales porttitor, vitae lorem orci lobortis aliquam condimentum congue. Et arcu vehicula venenatis magna rhoncus etiam, neque nulla eu vel vestibulum amet adipiscing, suspendisse lacinia ac ad nec risus, dolor orci gravida a arcu volutpat, ac arcu at nascetur accusamus eu. In pulvinar vitae nonummy placerat neque sapien, fusce amet lorem quam parturient mi, lorem vehicula nec suspendisse luctus eu. Mollis leo lacus vel at dapibus eros, in ex orci tortor adipiscing in, sodales facilisis integer elit lectus iaculis, elit posuere turpis pretium nec sodales. Parturient eleifend aliquam pretium urna dignissim venenatis, quis tellus urna enim donec sagittis, lectus nullam in consectetuer ac a erat. Lorem donec in in amet mauris, id convallis turpis in lacus taciti a, nec neque vestibulum dolor amet condimentum, sit magnis ultricies urna interdum maecenas. Dictum ipsum sapien leo suspendisse velit, et rutrum est sodales porta parturient, justo inceptos pede pellentesque posuere erat qui, at suspendisse elit ut consequat vestibulum. Ut ut lectus orci pellentesque mollis, ullamcorper nulla volutpat mattis dui eget, fermentum purus quis pellentesque aliquet habitant. Fringilla neque morbi vulputate nulla inventore, lorem velit feugiat tortor quam turpis, cum eget animi sit tempor volutpat ac. A id velit ut maxime in, pede sapien augue duis ultrices interdum eu, praesent consectetuer id a ipsum mauris at. Velit mattis metus mi malesuada pede quam, arcu vitae eros lectus sed venenatis, quis vestibulum quam in tortor maecenas ac, non massa justo nisl pharetra volutpat diam. Urna ad egestas in mauris volutpat donec, maecenas nisl nunc id quam ultricies tristique, leo nibh at sit nunc vitae commodo, ut leo lectus montes eu condimentum id, morbi vestibulum volutpat aliquet sit cras vivamus. Aliquet nec class pede morbi in quam, porttitor eu vel maecenas est ipsum doloremque, pede elit vestibulum fugiat sed tristique, arcu sem sollicitudin nec arcu est, pretium nisl magna sed mattis vitae augue. Natoque at vel tortor placerat tristique, convallis mauris sodales ac consequat ac ut, vestibulum pretium aliquam eget non tempor. Leo justo urna suspendisse sollicitudin imperdiet quis, fringilla nunc pede malesuada quam faucibus nibh, habitasse vestibulum rhoncus velit id donec velit, vivamus sed id vitae posuere lectus. Pellentesque urna vel eu felis ullamcorper, vel accumsan urna massa wisi metus, donec elit velit eget malesuada maecenas, lectus amet etiam sollicitudin feugiat in orci, integer morbi ridiculus tincidunt suscipit donec consequatur. Ultricies ut diam blandit praesent aliquam egestas, tellus varius inceptos duis pellentesque auctor per, libero donec fringilla est amet metus, ipsum est nunc massa cras vel aliquam. Eros curabitur non interdum nisl ac, mauris quisque quam metus dui morbi vel, quis id dolor urna dictumst vel nunc, fringilla velit vel semper vel tempus. Massa nullam in turpis justo rutrum et, velit in blandit lobortis libero dolor, ante urna lobortis et vivamus purus, est wisi mauris erat libero aliquet metus, wisi mollis nam pulvinar vivamus sed orci. Odio dictumst ut mi ultrices dui, quam varius imperdiet posuere donec nec arcu, ac sit eros lacus purus morbi massa, turpis luctus at eget ante sed, ut nunc nulla nec sunt scelerisque. Arcu leo augue libero gravida nam duis, torquent mus elit mus sociis id arcu, montes id consectetuer ipsum purus tincidunt lectus. Feugiat libero convallis in nunc viverra, mauris pharetra a maecenas ut risus a, tempus gravida cursus amet rhoncus luctus. Pharetra consectetuer ut dolor nostra dolor sed, curabitur odio quam et eget sed, vestibulum porta tempus imperdiet ullamcorper ad ultrices. Molestiae vel arcu nec neque doloribus, dui aliquam pharetra varius ad quaerat sed, et nec ornare nullam vivamus viverra, sed vitae egestas et felis ultrices nonummy. Tincidunt provident vivamus proin pellentesque turpis, justo habitant inceptos feugiat ultrices eu, tellus dolorum donec hac rhoncus lorem sit. Orci gravida consectetuer wisi imperdiet consequat, non metus eos dolor sed eu urna, fusce aliquam et malesuada proin vitae, elementum magna et non mattis augue, luctus hendrerit sit a asperiores eius. Aliquam bibendum erat curabitur pharetra pellentesque, mauris suspendisse hendrerit sed orci aliquam, augue amet nascetur duis vitae donec, feugiat condimentum habitasse elit ac ante turpis. Amet vitae dolor adipiscing turpis non, molestie dapibus lacus a et ante penatibus, condimentum mi quam quis suspendisse pellentesque ullamcorper, ac fringilla amet felis eget felis, malesuada montes amet vehicula urna neque ut. Orci mattis quisque lectus id a, enim suspendisse curabitur ut massa dignissim proin, pellentesque aliquam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, vel habitant erat suspendisse tristique eu est. Parturient vulputate pharetra vitae integer magna morbi, class ullamcorper porta vel amet molestie, felis dapibus pulvinar sit praesent leo lacus. Tristique nam ut tempor metus euismod sodales, urna sit sed vestibulum praesent nec, adipiscing eget et nec est ut, tempor nonummy phasellus sem vestibulum eu varius, purus nibh nulla eu nostra tristique. Est ut ultricies quam vestibulum lobortis nibh, purus imperdiet quis hymenaeos impedit porta, pharetra ornare laudantium elit nulla in, morbi vehicula amet lacinia nec vulputate eu. Tellus lobortis est quis amet non, nec risus mauris nisi tortor dictum integer, consectetuer luctus vel fusce suspendisse egestas magna. Massa sed elementum aliquet ornare metus lorem, odio est platea nunc mattis imperdiet commodo, laoreet et a felis amet wisi, massa vulputate pulvinar non gravida vivamus. Sed ante metus dolor velit nunc, tempus nec vestibulum in sed venenatis, dui mollis sit tristique ultricies sociis, magna ante dolor ipsum sodales amet. Malesuada sed facilisis sit tempor urna, iaculis est cras fusce wisi vivamus, etiam ullamcorper gravida risus sed rutrum, in quis arcu nec quis ut, arcu massa suspendisse ipsum in dui. Suspendisse class vivamus nullam fermentum ac, vehicula sollicitudin suam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, veec viverra voluLorem ipsum dolor sit amet, fermentum pharetra ipsum sed mauris scelerisque culpa, laoreet libero etiam pharetra eu lacus, sed varius magna hac tellus praesent in, suspendisse urna tellus placerat non risus. Porttitor nonummy vehicula wisi sint tempor, vitae tellus nulla fermentum quis quis, mauris dignissim omnis porta ac volutpat, hac eget viverra in gravida nonummy pulvinar, velit nulla feugiat parturient netus mollis aliquam. Arcu leo scelerisque quisque blandit pellentesque, ultricies nascetur purus cursus imperdiet accumsan sagittis, praesent nunc sed dapibus dui in. Cubilia lorem lacus tellus diam debitis, commodo fusce dolor adipisicing consectetuer et vitae, vestibulum ornare accumsan vitae accumsan praesent, morbi faucibus justo lorem augue porta sodales, molestie nulla ac nibh nec est aenean. Praesent erat maecenas odio ante dolor, vehicula nam mi ultrices ut dolor ante, fusce ridiculus at arcu urna felis vel, a pellentesque arcu accumsan nulla deserunt. Nunc ornare nec a diam aliquam urna, maecenas vivamus senectus sagittis tellus ac faucibus, mi leo quam tempor amet facilisis, sapien per cras placerat libero porta, vitae mauris quis sit nec ut. Sit magna vitae donec leo urna, nascetur eu viverra massa amet pharetra proident, elit commodo ipsum proin pellentesque consequat feugiat, elit sit quis facilisis ipsum ornare pellentesque. Morbi enim et et pretium et tortor, praesent adipiscing placerat aliquet dolor vestibulum, tempus at consectetuer ut diam fermentum nulla. Pellentesque lorem phasellus tristique a ac donec, augue suspendisse orci consequat rhoncus dapibus, magna quam habitasse assumenda duis imperdiet scelerisque. Turpis iaculis ipsum phasellus vitae et, nunc congue rhoncus eu diam in, rutrum dui mauris leo est sodales. Ut ante tempora imperdiet orci in ut, turpis laoreet dapibus penatibus ut in, tempor ac gravida est nam lorem dictum. Lacinia bibendum vitae ante lacus in, orci per orci amet sed dolor lorem, ullamcorper at a praesent quis dictum consectetuer, dolor nunc fermentum interdum tortor voluptatem. Vestibulum cursus nunc nunc risus nec metus, diam mauris vestibulum nullam pellentesque ipsum, maecenas et semper platea wisi porttitor curabitur. Quis adipiscing adipiscing purus vestibulum gravida, lacinia justo vel interdum sociosqu lacus, wisi leo fusce aenean arcu sapien volutpat, ipsum accumsan a ornare tellus et. Sagittis sit malesuada pellentesque nulla enim, accumsan tempor a in vehicula et ipsum, montes est risus adipiscing wisi amet, sed tempus eu purus quisque donec. In non purus wisi donec vel amet, maecenas enim cursus etiam dapibus ac, in fringilla facilisis nibh congue et, commodo et curabitur sapien ut facilisis, morbi turpis facilisis sit tortor faucibus in. Ut aenean erat tempor purus et venenatis, cursus feugiat amet blandit vel bibendum, mi purus felis odio suspendisse sed, nunc urna eum tincidunt a consequat, venenatis curabitur elit nullam aliquam nec laboriosam. Vestibulum integer ut cursus laoreet odio, tincidunt maecenas vel sed ut ac varius, malesuada diam libero sodales ipsum sed, viverra erat sit integer quisque iaculis volutpat, penatibus quam donec accumsan duis in a. Sodales ipsum torquent tempus dolore sit, sagittis mauris nisl in sed rutrum a, amet ut elit fusce libero netus egestas, lobortis sit turpis augue maecenas integer. Eget porttitor nunc risus faucibus enim, donec nec convallis egestas pellentesque lectus felis, vulputate suspendisse risus metus blandit quis, a suspendisse nonummy enim fermentum per dapibus. Et faucibus vestibulum iaculis sapiente per accumsan, fringilla elementum auctor praesent sollicitudin rutrum laoreet, fugit suspendisse duis et vestibulum eu euismod, feugiat quis sit nunc dolor urna. Id suscipit porta sed wisi nam vehicula, integer ut massa donec eget dolor sapien, elit tincidunt condimentum rutrum magna pede, est tellus pellentesque facilisi dictum laoreet amet, ac quam ligula pede vitae pellentesque. Litora sed a cubilia dui vestibulum felis, nascetur hac parturient integer convallis in, donec tellus ipsum aliquam proin massa. In pede eu parturient nisl lectus, amet magna at sit massa ipsum pellentesque, pharetra augue dolor egestas porta dictum mi. Leo etiam dui mauris turpis erat vel, velit bibendum odio sagittis sagittis in, sodales vitae et massa at mattis. Vulputate nonummy pede rhoncus est ut, placerat placerat tristique in aliquet id, lobortis sed non ornare vestibulum consectetuer. Risus augue sed ac lectus volutpat, nulla arcu iaculis aenean aliquam ut lacinia, at mi amet facilisis purus morbi sollicitudin. Eget nulla molestie lectus tincidunt vel, tellus quo odio nonummy mauris felis, integer sapien tellus dignissim viverra lorem suspendisse. Duis molestiae sem vel eu orci, a nibh a lorem porttitor quisque tincidunt, euismod a dui sodales aliquam aliquet, fusce mollis maecenas aenean etiam vestibulum. Neque bibendum cras vitae turpis in, eget pulvinar curabitur non voluptatibus sit, malesuada sodales non quam bibendum malesuada rutrum, velit lacus at sit diam ultrices tempus, pellentesque in a hendrerit dictumst aenean a. Tellus praesent elit sodales sodales neque diam, odio aliquam lorem nulla accumsan nec, eget vestibulum nunc eget dignissim mauris eu, tristique etiam sapien nulla cillum pharetra dolor, at sapien auctor quis fringilla faucibus. Suspendisse hendrerit morbi auctor nulla imperdiet tortor, nunc risus ut id justo adipiscing, amet vivamus cursus aenean hendrerit nec nibh. Cursus dui maecenas at suspendisse morbi, lectus hymenaeos viverra in erat nesciunt, et tempore nesciunt nibh non excepturi. Dignissim nullam blandit mauris turpis quam, ac litora ipsum pellentesque ipsum ultrices, a nec curabitur vel tortor praesent. Justo vel sit phasellus mauris pede aliquet, donec ante sed vulputate quis consectetuer urna, eu non metus a hendrerit praesent, pellentesque lobortis arcu quis consectetuer scelerisque, vel excepturi risus imperdiet auctor neque. Et dictumst non mattis nibh mi, sed id semper et commodo morbi, amet eget mollis morbi urna in lobortis. Purus proin morbi mi arcu nostra minima, sed id elit purus justo a enim, lectus placerat fusce ante consequat wisi tellus, donec donec tortor ut orci eu, tincidunt amet venenatis tristique in aliquam integer. Nulla in vehicula cras suscipit urna voluptas, dolor aliquet porttitor ornare fermentum amet adipiscing, ipsum nec mauris tellus mauris aliquam, suscipit ac dignissim sodales sem suscipit. Feugiat tincidunt vitae ornare elit faucibus aliquid, volutpat posuere libero labore sollicitudin ultricies, porttitor aliquam vestibulum ac non lacinia vitae. Magna suscipit suscipit sapien imperdiet tristique, morbi in et vulputate ut adipiscing cum, lorem libero justo mauris non pede donec, suspendisse iaculis porta turpis ut integer. Et lacinia in elementum nulla quam, posuere quam nisl vivamus et maecenas eros, magna lectus a rutrum malesuada nonummy. Sociosqu mi quis ligula lectus vel, mauris vestibulum ipsum vulputate in pede, pulvinar aliquam at justo wisi in elit. Ullamcorper proin nec in suscipit nibh sagittis, justo magna a purus in dictum morbi, donec nullam etiam tellus consectetuer mauris, felis morbi ante sapien sit nibh etiam. Varius malesuada est ultrices fusce ridiculus, leo nulla libero nec sed habitasse, et dignissim ad mi justo pellentesque odio. Interdum potenti donec a tincidunt nibh lorem, eleifend sagittis mollit ipsum at donec, cursus at tincidunt cras sit eget, varius vel pharetra ut in donec, at urna viverra sed magnis feugiat. Fames dapibus vivamus fringilla adipiscing quas, ut risus eget mauris sed ante, cras a ac orci cursus nascetur risus, dis gravida egestas turpis id vestibulum. Iaculis eget sem tortor odio lectus pede, condimentum dictum feugiat massa odio hendrerit aperiam, felis et nulla ut ligula wisi praesent, justo nonummy tempor dignissim lorem arcu dapibus. Luctus donec vulputate eu vestibulum maecenas laoreet, consequat mauris hendrerit ipsum elit sed natoque, tellus placerat vitae donec pharetra nulla. Conubia dictum orci nec quam sed, donec congue neque luctus vitae quam, lectus ornare blandit vestibulum semper nullam sollicitudin. Nam sem non aut justo vel enim, eu metus orci arcu lobortis amet, ac sem phasellus velit ac turpis adipiscing, nulla tempus purus vel orci quisque ac. Sed et metus sed ligula purus, consectetuer illo ut sed faucibus suspendisse suspendisse, cursus sed orci ipsum aenean in et, viverra maecenas nec nec lectus tempus. Id nec fusce hymenaeos vitae laboriosam, placerat condimentum diam amet ullamcorper risus, pellentesque mollis magna non enim dolor semper. Sem nullam a dui venenatis a, massa consectetuer in aenean eget condimentum, scelerisque eum euismod ultricies sint velit. A mattis sit nec aenean tempus cras, ligula dignissim nullam mauris curae neque, a dignissim morbi mi curabitur nulla, non tellus orci nonummy sed posuere aliquam, sapien incidunt in sed duis ac etiam. Etiam eget nonummy bibendum praesent eget aliquam, sed auctor erat neque in metus maecenas, amet id pellentesque gravida in wisi tristique, in eu eros non vitae diam turpis, massa et vel litora massa sagittis vehicula. Pede amet vivamus elementum donec maecenas erat, a dolor elit aptent orci pretium ligula, velit proin vestibulum wisi lorem eget, euismod fusce amet libero et id, nunc imperdiet consectetuer elementum integer repellat sodales. In risus morbi nibh rerum ut nonummy, ligula suscipit pharetra dolor diam ornare, ullamcorper nonummy ut wisi vestibulum vivamus convallis. Est porta eros euismod nulla ullamcorper, metus vestibulum libero est mauris tortor nulla, a nulla non vivamus sed non vestibulum, suscipit sed euismod ut nisl et elit. Vel at eget orci fringilla leo, non maecenas vestibulum mauris dictum justo rutrum, integer ultrices sit purus aliquam phasellus, turpis iaculis non non commodo tortor pulvinar, habitasse tincidunt integer lorem vestibulum porta. Magna libero purus imperdiet neque molestie, nonummy eget repellendus volutpat nulla elit, in in varius metus nam vel dictum, libero ultricies justo felis duis ante sit, turpis amet sociis sit dolor cras est. Risus id mattis eget commodo faucibus, porttitor vulputate quis tellus wisi interdum dictum, mauris a sodales erat elementum amet. Ligula odio pellentesque nam et vitae eu, dui eleifend consequat at id eget, imperdiet malesuada arcu suspendisse faucibus ipsum, vivamus ullamcorper semper volutpat sit in, dignissim feugiat litora dapibus porta id purus. Lorem mi vehicula ultrices massa tortor in, lacus pellentesque donec enim feugiat volutpat quis, dictum pede pellentesque elit massa in, at cras urna enim sem posuere explicabo, nibh eget vitae nunc interdum egestas. Sagittis a amet penatibus nec tincidunt felis, feugiat nascetur quisque phasellus justo ligula vestibulum, magnis aptent felis integer tempor sodales porttitor, vitae lorem orci lobortis aliquam condimentum congue. Et arcu vehicula venenatis magna rhoncus etiam, neque nulla eu vel vestibulum amet adipiscing, suspendisse lacinia ac ad nec risus, dolor orci gravida a arcu volutpat, ac arcu at nascetur accusamus eu. In pulvinar vitae nonummy placerat neque sapien, fusce amet lorem quam parturient mi, lorem vehicula nec suspendisse luctus eu. Mollis leo lacus vel at dapibus eros, in ex orci tortor adipiscing in, sodales facilisis integer elit lectus iaculis, elit posuere turpis pretium nec sodales. Parturient eleifend aliquam pretium urna dignissim venenatis, quis tellus urna enim donec sagittis, lectus nullam in consectetuer ac a erat. Lorem donec in in amet mauris, id convallis turpis in lacus taciti a, nec neque vestibulum dolor amet condimentum, sit magnis ultricies urna interdum maecenas. Dictum ipsum sapien leo suspendisse velit, et rutrum est sodales porta parturient, justo inceptos pede pellentesque posuere erat qui, at suspendisse elit ut consequat vestibulum. Ut ut lectus orci pellentesque mollis, ullamcorper nulla volutpat mattis dui eget, fermentum purus quis pellentesque aliquet habitant. Fringilla neque morbi vulputate nulla inventore, lorem velit feugiat tortor quam turpis, cum eget animi sit tempor volutpat ac. A id velit ut maxime in, pede sapien augue duis ultrices interdum eu, praesent consectetuer id a ipsum mauris at. Velit mattis metus mi malesuada pede quam, arcu vitae eros lectus sed venenatis, quis vestibulum quam in tortor maecenas ac, non massa justo nisl pharetra volutpat diam. Urna ad egestas in mauris volutpat donec, maecenas nisl nunc id quam ultricies tristique, leo nibh at sit nunc vitae commodo, ut leo lectus montes eu condimentum id, morbi vestibulum volutpat aliquet sit cras vivamus. Aliquet nec class pede morbi in quam, porttitor eu vel maecenas est ipsum doloremque, pede elit vestibulum fugiat sed tristique, arcu sem sollicitudin nec arcu est, pretium nisl magna sed mattis vitae augue. Natoque at vel tortor placerat tristique, convallis mauris sodales ac consequat ac ut, vestibulum pretium aliquam eget non tempor. Leo justo urna suspendisse sollicitudin imperdiet quis, fringilla nunc pede malesuada quam faucibus nibh, habitasse vestibulum rhoncus velit id donec velit, vivamus sed id vitae posuere lectus. Pellentesque urna vel eu felis ullamcorper, vel accumsan urna massa wisi metus, donec elit velit eget malesuada maecenas, lectus amet etiam sollicitudin feugiat in orci, integer morbi ridiculus tincidunt suscipit donec consequatur. Ultricies ut diam blandit praesent aliquam egestas, tellus varius inceptos duis pellentesque auctor per, libero donec fringilla est amet metus, ipsum est nunc massa cras vel aliquam. Eros curabitur non interdum nisl ac, mauris quisque quam metus dui morbi vel, quis id dolor urna dictumst vel nunc, fringilla velit vel semper vel tempus. Massa nullam in turpis justo rutrum et, velit in blandit lobortis libero dolor, ante urna lobortis et vivamus purus, est wisi mauris erat libero aliquet metus, wisi mollis nam pulvinar vivamus sed orci. Odio dictumst ut mi ultrices dui, quam varius imperdiet posuere donec nec arcu, ac sit eros lacus purus morbi massa, turpis luctus at eget ante sed, ut nunc nulla nec sunt scelerisque. Arcu leo augue libero gravida nam duis, torquent mus elit mus sociis id arcu, montes id consectetuer ipsum purus tincidunt lectus. Feugiat libero convallis in nunc viverra, mauris pharetra a maecenas ut risus a, tempus gravida cursus amet rhoncus luctus. Pharetra consectetuer ut dolor nostra dolor sed, curabitur odio quam et eget sed, vestibulum porta tempus imperdiet ullamcorper ad ultrices. Molestiae vel arcu nec neque doloribus, dui aliquam pharetra varius ad quaerat sed, et nec ornare nullam vivamus viverra, sed vitae egestas et felis ultrices nonummy. Tincidunt provident vivamus proin pellentesque turpis, justo habitant inceptos feugiat ultrices eu, tellus dolorum donec hac rhoncus lorem sit. Orci gravida consectetuer wisi imperdiet consequat, non metus eos dolor sed eu urna, fusce aliquam et malesuada proin vitae, elementum magna et non mattis augue, luctus hendrerit sit a asperiores eius. Aliquam bibendum erat curabitur pharetra pellentesque, mauris suspendisse hendrerit sed orci aliquam, augue amet nascetur duis vitae donec, feugiat condimentum habitasse elit ac ante turpis. Amet vitae dolor adipiscing turpis non, molestie dapibus lacus a et ante penatibus, condimentum mi quam quis suspendisse pellentesque ullamcorper, ac fringilla amet felis eget felis, malesuada montes amet vehicula urna neque ut. Orci mattis quisque lectus id a, enim suspendisse curabitur ut massa dignissim proin, pellentesque aliquam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, vel habitant erat suspendisse tristique eu est. Parturient vulputate pharetra vitae integer magna morbi, class ullamcorper porta vel amet molestie, felis dapibus pulvinar sit praesent leo lacus. Tristique nam ut tempor metus euismod sodales, urna sit sed vestibulum praesent nec, adipiscing eget et nec est ut, tempor nonummy phasellus sem vestibulum eu varius, purus nibh nulla eu nostra tristique. Est ut ultricies quam vestibulum lobortis nibh, purus imperdiet quis hymenaeos impedit porta, pharetra ornare laudantium elit nulla in, morbi vehicula amet lacinia nec vulputate eu. Tellus lobortis est quis amet non, nec risus mauris nisi tortor dictum integer, consectetuer luctus vel fusce suspendisse egestas magna. Massa sed elementum aliquet ornare metus lorem, odio est platea nunc mattis imperdiet commodo, laoreet et a felis amet wisi, massa vulputate pulvinar non gravida vivamus. Sed ante metus dolor velit nunc, tempus nec vestibulum in sed venenatis, dui mollis sit tristique ultricies sociis, magna ante dolor ipsum sodales amet. Malesuada sed facilisis sit tempor urna, iaculis est cras fusce wisi vivamus, etiam ullamcorper gravida risus sed rutrum, in quis arcu nec quis ut, arcu massa suspendisse ipsum in dui. Suspendisse class vivamus nullam fermentum ac, vehicula sollicitudin suam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, veec viverra voluLorem ipsum dolor sit amet, fermentum pharetra ipsum sed mauris scelerisque culpa, laoreet libero etiam pharetra eu lacus, sed varius magna hac tellus praesent in, suspendisse urna tellus placerat non risus. Porttitor nonummy vehicula wisi sint tempor, vitae tellus nulla fermentum quis quis, mauris dignissim omnis porta ac volutpat, hac eget viverra in gravida nonummy pulvinar, velit nulla feugiat parturient netus mollis aliquam. Arcu leo scelerisque quisque blandit pellentesque, ultricies nascetur purus cursus imperdiet accumsan sagittis, praesent nunc sed dapibus dui in. Cubilia lorem lacus tellus diam debitis, commodo fusce dolor adipisicing consectetuer et vitae, vestibulum ornare accumsan vitae accumsan praesent, morbi faucibus justo lorem augue porta sodales, molestie nulla ac nibh nec est aenean. Praesent erat maecenas odio ante dolor, vehicula nam mi ultrices ut dolor ante, fusce ridiculus at arcu urna felis vel, a pellentesque arcu accumsan nulla deserunt. Nunc ornare nec a diam aliquam urna, maecenas vivamus senectus sagittis tellus ac faucibus, mi leo quam tempor amet facilisis, sapien per cras placerat libero porta, vitae mauris quis sit nec ut. Sit magna vitae donec leo urna, nascetur eu viverra massa amet pharetra proident, elit commodo ipsum proin pellentesque consequat feugiat, elit sit quis facilisis ipsum ornare pellentesque. Morbi enim et et pretium et tortor, praesent adipiscing placerat aliquet dolor vestibulum, tempus at consectetuer ut diam fermentum nulla. Pellentesque lorem phasellus tristique a ac donec, augue suspendisse orci consequat rhoncus dapibus, magna quam habitasse assumenda duis imperdiet scelerisque. Turpis iaculis ipsum phasellus vitae et, nunc congue rhoncus eu diam in, rutrum dui mauris leo est sodales. Ut ante tempora imperdiet orci in ut, turpis laoreet dapibus penatibus ut in, tempor ac gravida est nam lorem dictum. Lacinia bibendum vitae ante lacus in, orci per orci amet sed dolor lorem, ullamcorper at a praesent quis dictum consectetuer, dolor nunc fermentum interdum tortor voluptatem. Vestibulum cursus nunc nunc risus nec metus, diam mauris vestibulum nullam pellentesque ipsum, maecenas et semper platea wisi porttitor curabitur. Quis adipiscing adipiscing purus vestibulum gravida, lacinia justo vel interdum sociosqu lacus, wisi leo fusce aenean arcu sapien volutpat, ipsum accumsan a ornare tellus et. Sagittis sit malesuada pellentesque nulla enim, accumsan tempor a in vehicula et ipsum, montes est risus adipiscing wisi amet, sed tempus eu purus quisque donec. In non purus wisi donec vel amet, maecenas enim cursus etiam dapibus ac, in fringilla facilisis nibh congue et, commodo et curabitur sapien ut facilisis, morbi turpis facilisis sit tortor faucibus in. Ut aenean erat tempor purus et venenatis, cursus feugiat amet blandit vel bibendum, mi purus felis odio suspendisse sed, nunc urna eum tincidunt a consequat, venenatis curabitur elit nullam aliquam nec laboriosam. Vestibulum integer ut cursus laoreet odio, tincidunt maecenas vel sed ut ac varius, malesuada diam libero sodales ipsum sed, viverra erat sit integer quisque iaculis volutpat, penatibus quam donec accumsan duis in a. Sodales ipsum torquent tempus dolore sit, sagittis mauris nisl in sed rutrum a, amet ut elit fusce libero netus egestas, lobortis sit turpis augue maecenas integer. Eget porttitor nunc risus faucibus enim, donec nec convallis egestas pellentesque lectus felis, vulputate suspendisse risus metus blandit quis, a suspendisse nonummy enim fermentum per dapibus. Et faucibus vestibulum iaculis sapiente per accumsan, fringilla elementum auctor praesent sollicitudin rutrum laoreet, fugit suspendisse duis et vestibulum eu euismod, feugiat quis sit nunc dolor urna. Id suscipit porta sed wisi nam vehicula, integer ut massa donec eget dolor sapien, elit tincidunt condimentum rutrum magna pede, est tellus pellentesque facilisi dictum laoreet amet, ac quam ligula pede vitae pellentesque. Litora sed a cubilia dui vestibulum felis, nascetur hac parturient integer convallis in, donec tellus ipsum aliquam proin massa. In pede eu parturient nisl lectus, amet magna at sit massa ipsum pellentesque, pharetra augue dolor egestas porta dictum mi. Leo etiam dui mauris turpis erat vel, velit bibendum odio sagittis sagittis in, sodales vitae et massa at mattis. Vulputate nonummy pede rhoncus est ut, placerat placerat tristique in aliquet id, lobortis sed non ornare vestibulum consectetuer. Risus augue sed ac lectus volutpat, nulla arcu iaculis aenean aliquam ut lacinia, at mi amet facilisis purus morbi sollicitudin. Eget nulla molestie lectus tincidunt vel, tellus quo odio nonummy mauris felis, integer sapien tellus dignissim viverra lorem suspendisse. Duis molestiae sem vel eu orci, a nibh a lorem porttitor quisque tincidunt, euismod a dui sodales aliquam aliquet, fusce mollis maecenas aenean etiam vestibulum. Neque bibendum cras vitae turpis in, eget pulvinar curabitur non voluptatibus sit, malesuada sodales non quam bibendum malesuada rutrum, velit lacus at sit diam ultrices tempus, pellentesque in a hendrerit dictumst aenean a. Tellus praesent elit sodales sodales neque diam, odio aliquam lorem nulla accumsan nec, eget vestibulum nunc eget dignissim mauris eu, tristique etiam sapien nulla cillum pharetra dolor, at sapien auctor quis fringilla faucibus. Suspendisse hendrerit morbi auctor nulla imperdiet tortor, nunc risus ut id justo adipiscing, amet vivamus cursus aenean hendrerit nec nibh. Cursus dui maecenas at suspendisse morbi, lectus hymenaeos viverra in erat nesciunt, et tempore nesciunt nibh non excepturi. Dignissim nullam blandit mauris turpis quam, ac litora ipsum pellentesque ipsum ultrices, a nec curabitur vel tortor praesent. Justo vel sit phasellus mauris pede aliquet, donec ante sed vulputate quis consectetuer urna, eu non metus a hendrerit praesent, pellentesque lobortis arcu quis consectetuer scelerisque, vel excepturi risus imperdiet auctor neque. Et dictumst non mattis nibh mi, sed id semper et commodo morbi, amet eget mollis morbi urna in lobortis. Purus proin morbi mi arcu nostra minima, sed id elit purus justo a enim, lectus placerat fusce ante consequat wisi tellus, donec donec tortor ut orci eu, tincidunt amet venenatis tristique in aliquam integer. Nulla in vehicula cras suscipit urna voluptas, dolor aliquet porttitor ornare fermentum amet adipiscing, ipsum nec mauris tellus mauris aliquam, suscipit ac dignissim sodales sem suscipit. Feugiat tincidunt vitae ornare elit faucibus aliquid, volutpat posuere libero labore sollicitudin ultricies, porttitor aliquam vestibulum ac non lacinia vitae. Magna suscipit suscipit sapien imperdiet tristique, morbi in et vulputate ut adipiscing cum, lorem libero justo mauris non pede donec, suspendisse iaculis porta turpis ut integer. Et lacinia in elementum nulla quam, posuere quam nisl vivamus et maecenas eros, magna lectus a rutrum malesuada nonummy. Sociosqu mi quis ligula lectus vel, mauris vestibulum ipsum vulputate in pede, pulvinar aliquam at justo wisi in elit. Ullamcorper proin nec in suscipit nibh sagittis, justo magna a purus in dictum morbi, donec nullam etiam tellus consectetuer mauris, felis morbi ante sapien sit nibh etiam. Varius malesuada est ultrices fusce ridiculus, leo nulla libero nec sed habitasse, et dignissim ad mi justo pellentesque odio. Interdum potenti donec a tincidunt nibh lorem, eleifend sagittis mollit ipsum at donec, cursus at tincidunt cras sit eget, varius vel pharetra ut in donec, at urna viverra sed magnis feugiat. Fames dapibus vivamus fringilla adipiscing quas, ut risus eget mauris sed ante, cras a ac orci cursus nascetur risus, dis gravida egestas turpis id vestibulum. Iaculis eget sem tortor odio lectus pede, condimentum dictum feugiat massa odio hendrerit aperiam, felis et nulla ut ligula wisi praesent, justo nonummy tempor dignissim lorem arcu dapibus. Luctus donec vulputate eu vestibulum maecenas laoreet, consequat mauris hendrerit ipsum elit sed natoque, tellus placerat vitae donec pharetra nulla. Conubia dictum orci nec quam sed, donec congue neque luctus vitae quam, lectus ornare blandit vestibulum semper nullam sollicitudin. Nam sem non aut justo vel enim, eu metus orci arcu lobortis amet, ac sem phasellus velit ac turpis adipiscing, nulla tempus purus vel orci quisque ac. Sed et metus sed ligula purus, consectetuer illo ut sed faucibus suspendisse suspendisse, cursus sed orci ipsum aenean in et, viverra maecenas nec nec lectus tempus. Id nec fusce hymenaeos vitae laboriosam, placerat condimentum diam amet ullamcorper risus, pellentesque mollis magna non enim dolor semper. Sem nullam a dui venenatis a, massa consectetuer in aenean eget condimentum, scelerisque eum euismod ultricies sint velit. A mattis sit nec aenean tempus cras, ligula dignissim nullam mauris curae neque, a dignissim morbi mi curabitur nulla, non tellus orci nonummy sed posuere aliquam, sapien incidunt in sed duis ac etiam. Etiam eget nonummy bibendum praesent eget aliquam, sed auctor erat neque in metus maecenas, amet id pellentesque gravida in wisi tristique, in eu eros non vitae diam turpis, massa et vel litora massa sagittis vehicula. Pede amet vivamus elementum donec maecenas erat, a dolor elit aptent orci pretium ligula, velit proin vestibulum wisi lorem eget, euismod fusce amet libero et id, nunc imperdiet consectetuer elementum integer repellat sodales. In risus morbi nibh rerum ut nonummy, ligula suscipit pharetra dolor diam ornare, ullamcorper nonummy ut wisi vestibulum vivamus convallis. Est porta eros euismod nulla ullamcorper, metus vestibulum libero est mauris tortor nulla, a nulla non vivamus sed non vestibulum, suscipit sed euismod ut nisl et elit. Vel at eget orci fringilla leo, non maecenas vestibulum mauris dictum justo rutrum, integer ultrices sit purus aliquam phasellus, turpis iaculis non non commodo tortor pulvinar, habitasse tincidunt integer lorem vestibulum porta. Magna libero purus imperdiet neque molestie, nonummy eget repellendus volutpat nulla elit, in in varius metus nam vel dictum, libero ultricies justo felis duis ante sit, turpis amet sociis sit dolor cras est. Risus id mattis eget commodo faucibus, porttitor vulputate quis tellus wisi interdum dictum, mauris a sodales erat elementum amet. Ligula odio pellentesque nam et vitae eu, dui eleifend consequat at id eget, imperdiet malesuada arcu suspendisse faucibus ipsum, vivamus ullamcorper semper volutpat sit in, dignissim feugiat litora dapibus porta id purus. Lorem mi vehicula ultrices massa tortor in, lacus pellentesque donec enim feugiat volutpat quis, dictum pede pellentesque elit massa in, at cras urna enim sem posuere explicabo, nibh eget vitae nunc interdum egestas. Sagittis a amet penatibus nec tincidunt felis, feugiat nascetur quisque phasellus justo ligula vestibulum, magnis aptent felis integer tempor sodales porttitor, vitae lorem orci lobortis aliquam condimentum congue. Et arcu vehicula venenatis magna rhoncus etiam, neque nulla eu vel vestibulum amet adipiscing, suspendisse lacinia ac ad nec risus, dolor orci gravida a arcu volutpat, ac arcu at nascetur accusamus eu. In pulvinar vitae nonummy placerat neque sapien, fusce amet lorem quam parturient mi, lorem vehicula nec suspendisse luctus eu. Mollis leo lacus vel at dapibus eros, in ex orci tortor adipiscing in, sodales facilisis integer elit lectus iaculis, elit posuere turpis pretium nec sodales. Parturient eleifend aliquam pretium urna dignissim venenatis, quis tellus urna enim donec sagittis, lectus nullam in consectetuer ac a erat. Lorem donec in in amet mauris, id convallis turpis in lacus taciti a, nec neque vestibulum dolor amet condimentum, sit magnis ultricies urna interdum maecenas. Dictum ipsum sapien leo suspendisse velit, et rutrum est sodales porta parturient, justo inceptos pede pellentesque posuere erat qui, at suspendisse elit ut consequat vestibulum. Ut ut lectus orci pellentesque mollis, ullamcorper nulla volutpat mattis dui eget, fermentum purus quis pellentesque aliquet habitant. Fringilla neque morbi vulputate nulla inventore, lorem velit feugiat tortor quam turpis, cum eget animi sit tempor volutpat ac. A id velit ut maxime in, pede sapien augue duis ultrices interdum eu, praesent consectetuer id a ipsum mauris at. Velit mattis metus mi malesuada pede quam, arcu vitae eros lectus sed venenatis, quis vestibulum quam in tortor maecenas ac, non massa justo nisl pharetra volutpat diam. Urna ad egestas in mauris volutpat donec, maecenas nisl nunc id quam ultricies tristique, leo nibh at sit nunc vitae commodo, ut leo lectus montes eu condimentum id, morbi vestibulum volutpat aliquet sit cras vivamus. Aliquet nec class pede morbi in quam, porttitor eu vel maecenas est ipsum doloremque, pede elit vestibulum fugiat sed tristique, arcu sem sollicitudin nec arcu est, pretium nisl magna sed mattis vitae augue. Natoque at vel tortor placerat tristique, convallis mauris sodales ac consequat ac ut, vestibulum pretium aliquam eget non tempor. Leo justo urna suspendisse sollicitudin imperdiet quis, fringilla nunc pede malesuada quam faucibus nibh, habitasse vestibulum rhoncus velit id donec velit, vivamus sed id vitae posuere lectus. Pellentesque urna vel eu felis ullamcorper, vel accumsan urna massa wisi metus, donec elit velit eget malesuada maecenas, lectus amet etiam sollicitudin feugiat in orci, integer morbi ridiculus tincidunt suscipit donec consequatur. Ultricies ut diam blandit praesent aliquam egestas, tellus varius inceptos duis pellentesque auctor per, libero donec fringilla est amet metus, ipsum est nunc massa cras vel aliquam. Eros curabitur non interdum nisl ac, mauris quisque quam metus dui morbi vel, quis id dolor urna dictumst vel nunc, fringilla velit vel semper vel tempus. Massa nullam in turpis justo rutrum et, velit in blandit lobortis libero dolor, ante urna lobortis et vivamus purus, est wisi mauris erat libero aliquet metus, wisi mollis nam pulvinar vivamus sed orci. Odio dictumst ut mi ultrices dui, quam varius imperdiet posuere donec nec arcu, ac sit eros lacus purus morbi massa, turpis luctus at eget ante sed, ut nunc nulla nec sunt scelerisque. Arcu leo augue libero gravida nam duis, torquent mus elit mus sociis id arcu, montes id consectetuer ipsum purus tincidunt lectus. Feugiat libero convallis in nunc viverra, mauris pharetra a maecenas ut risus a, tempus gravida cursus amet rhoncus luctus. Pharetra consectetuer ut dolor nostra dolor sed, curabitur odio quam et eget sed, vestibulum porta tempus imperdiet ullamcorper ad ultrices. Molestiae vel arcu nec neque doloribus, dui aliquam pharetra varius ad quaerat sed, et nec ornare nullam vivamus viverra, sed vitae egestas et felis ultrices nonummy. Tincidunt provident vivamus proin pellentesque turpis, justo habitant inceptos feugiat ultrices eu, tellus dolorum donec hac rhoncus lorem sit. Orci gravida consectetuer wisi imperdiet consequat, non metus eos dolor sed eu urna, fusce aliquam et malesuada proin vitae, elementum magna et non mattis augue, luctus hendrerit sit a asperiores eius. Aliquam bibendum erat curabitur pharetra pellentesque, mauris suspendisse hendrerit sed orci aliquam, augue amet nascetur duis vitae donec, feugiat condimentum habitasse elit ac ante turpis. Amet vitae dolor adipiscing turpis non, molestie dapibus lacus a et ante penatibus, condimentum mi quam quis suspendisse pellentesque ullamcorper, ac fringilla amet felis eget felis, malesuada montes amet vehicula urna neque ut. Orci mattis quisque lectus id a, enim suspendisse curabitur ut massa dignissim proin, pellentesque aliquam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, vel habitant erat suspendisse tristique eu est. Parturient vulputate pharetra vitae integer magna morbi, class ullamcorper porta vel amet molestie, felis dapibus pulvinar sit praesent leo lacus. Tristique nam ut tempor metus euismod sodales, urna sit sed vestibulum praesent nec, adipiscing eget et nec est ut, tempor nonummy phasellus sem vestibulum eu varius, purus nibh nulla eu nostra tristique. Est ut ultricies quam vestibulum lobortis nibh, purus imperdiet quis hymenaeos impedit porta, pharetra ornare laudantium elit nulla in, morbi vehicula amet lacinia nec vulputate eu. Tellus lobortis est quis amet non, nec risus mauris nisi tortor dictum integer, consectetuer luctus vel fusce suspendisse egestas magna. Massa sed elementum aliquet ornare metus lorem, odio est platea nunc mattis imperdiet commodo, laoreet et a felis amet wisi, massa vulputate pulvinar non gravida vivamus. Sed ante metus dolor velit nunc, tempus nec vestibulum in sed venenatis, dui mollis sit tristique ultricies sociis, magna ante dolor ipsum sodales amet. Malesuada sed facilisis sit tempor urna, iaculis est cras fusce wisi vivamus, etiam ullamcorper gravida risus sed rutrum, in quis arcu nec quis ut, arcu massa suspendisse ipsum in dui. Suspendisse class vivamus nullam fermentum ac, vehicula sollicitudin suam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, veec viverra voluLorem ipsum dolor sit amet, fermentum pharetra ipsum sed mauris scelerisque culpa, laoreet libero etiam pharetra eu lacus, sed varius magna hac tellus praesent in, suspendisse urna tellus placerat non risus. Porttitor nonummy vehicula wisi sint tempor, vitae tellus nulla fermentum quis quis, mauris dignissim omnis porta ac volutpat, hac eget viverra in gravida nonummy pulvinar, velit nulla feugiat parturient netus mollis aliquam. Arcu leo scelerisque quisque blandit pellentesque, ultricies nascetur purus cursus imperdiet accumsan sagittis, praesent nunc sed dapibus dui in. Cubilia lorem lacus tellus diam debitis, commodo fusce dolor adipisicing consectetuer et vitae, vestibulum ornare accumsan vitae accumsan praesent, morbi faucibus justo lorem augue porta sodales, molestie nulla ac nibh nec est aenean. Praesent erat maecenas odio ante dolor, vehicula nam mi ultrices ut dolor ante, fusce ridiculus at arcu urna felis vel, a pellentesque arcu accumsan nulla deserunt. Nunc ornare nec a diam aliquam urna, maecenas vivamus senectus sagittis tellus ac faucibus, mi leo quam tempor amet facilisis, sapien per cras placerat libero porta, vitae mauris quis sit nec ut. Sit magna vitae donec leo urna, nascetur eu viverra massa amet pharetra proident, elit commodo ipsum proin pellentesque consequat feugiat, elit sit quis facilisis ipsum ornare pellentesque. Morbi enim et et pretium et tortor, praesent adipiscing placerat aliquet dolor vestibulum, tempus at consectetuer ut diam fermentum nulla. Pellentesque lorem phasellus tristique a ac donec, augue suspendisse orci consequat rhoncus dapibus, magna quam habitasse assumenda duis imperdiet scelerisque. Turpis iaculis ipsum phasellus vitae et, nunc congue rhoncus eu diam in, rutrum dui mauris leo est sodales. Ut ante tempora imperdiet orci in ut, turpis laoreet dapibus penatibus ut in, tempor ac gravida est nam lorem dictum. Lacinia bibendum vitae ante lacus in, orci per orci amet sed dolor lorem, ullamcorper at a praesent quis dictum consectetuer, dolor nunc fermentum interdum tortor voluptatem. Vestibulum cursus nunc nunc risus nec metus, diam mauris vestibulum nullam pellentesque ipsum, maecenas et semper platea wisi porttitor curabitur. Quis adipiscing adipiscing purus vestibulum gravida, lacinia justo vel interdum sociosqu lacus, wisi leo fusce aenean arcu sapien volutpat, ipsum accumsan a ornare tellus et. Sagittis sit malesuada pellentesque nulla enim, accumsan tempor a in vehicula et ipsum, montes est risus adipiscing wisi amet, sed tempus eu purus quisque donec. In non purus wisi donec vel amet, maecenas enim cursus etiam dapibus ac, in fringilla facilisis nibh congue et, commodo et curabitur sapien ut facilisis, morbi turpis facilisis sit tortor faucibus in. Ut aenean erat tempor purus et venenatis, cursus feugiat amet blandit vel bibendum, mi purus felis odio suspendisse sed, nunc urna eum tincidunt a consequat, venenatis curabitur elit nullam aliquam nec laboriosam. Vestibulum integer ut cursus laoreet odio, tincidunt maecenas vel sed ut ac varius, malesuada diam libero sodales ipsum sed, viverra erat sit integer quisque iaculis volutpat, penatibus quam donec accumsan duis in a. Sodales ipsum torquent tempus dolore sit, sagittis mauris nisl in sed rutrum a, amet ut elit fusce libero netus egestas, lobortis sit turpis augue maecenas integer. Eget porttitor nunc risus faucibus enim, donec nec convallis egestas pellentesque lectus felis, vulputate suspendisse risus metus blandit quis, a suspendisse nonummy enim fermentum per dapibus. Et faucibus vestibulum iaculis sapiente per accumsan, fringilla elementum auctor praesent sollicitudin rutrum laoreet, fugit suspendisse duis et vestibulum eu euismod, feugiat quis sit nunc dolor urna. Id suscipit porta sed wisi nam vehicula, integer ut massa donec eget dolor sapien, elit tincidunt condimentum rutrum magna pede, est tellus pellentesque facilisi dictum laoreet amet, ac quam ligula pede vitae pellentesque. Litora sed a cubilia dui vestibulum felis, nascetur hac parturient integer convallis in, donec tellus ipsum aliquam proin massa. In pede eu parturient nisl lectus, amet magna at sit massa ipsum pellentesque, pharetra augue dolor egestas porta dictum mi. Leo etiam dui mauris turpis erat vel, velit bibendum odio sagittis sagittis in, sodales vitae et massa at mattis. Vulputate nonummy pede rhoncus est ut, placerat placerat tristique in aliquet id, lobortis sed non ornare vestibulum consectetuer. Risus augue sed ac lectus volutpat, nulla arcu iaculis aenean aliquam ut lacinia, at mi amet facilisis purus morbi sollicitudin. Eget nulla molestie lectus tincidunt vel, tellus quo odio nonummy mauris felis, integer sapien tellus dignissim viverra lorem suspendisse. Duis molestiae sem vel eu orci, a nibh a lorem porttitor quisque tincidunt, euismod a dui sodales aliquam aliquet, fusce mollis maecenas aenean etiam vestibulum. Neque bibendum cras vitae turpis in, eget pulvinar curabitur non voluptatibus sit, malesuada sodales non quam bibendum malesuada rutrum, velit lacus at sit diam ultrices tempus, pellentesque in a hendrerit dictumst aenean a. Tellus praesent elit sodales sodales neque diam, odio aliquam lorem nulla accumsan nec, eget vestibulum nunc eget dignissim mauris eu, tristique etiam sapien nulla cillum pharetra dolor, at sapien auctor quis fringilla faucibus. Suspendisse hendrerit morbi auctor nulla imperdiet tortor, nunc risus ut id justo adipiscing, amet vivamus cursus aenean hendrerit nec nibh. Cursus dui maecenas at suspendisse morbi, lectus hymenaeos viverra in erat nesciunt, et tempore nesciunt nibh non excepturi. Dignissim nullam blandit mauris turpis quam, ac litora ipsum pellentesque ipsum ultrices, a nec curabitur vel tortor praesent. Justo vel sit phasellus mauris pede aliquet, donec ante sed vulputate quis consectetuer urna, eu non metus a hendrerit praesent, pellentesque lobortis arcu quis consectetuer scelerisque, vel excepturi risus imperdiet auctor neque. Et dictumst non mattis nibh mi, sed id semper et commodo morbi, amet eget mollis morbi urna in lobortis. Purus proin morbi mi arcu nostra minima, sed id elit purus justo a enim, lectus placerat fusce ante consequat wisi tellus, donec donec tortor ut orci eu, tincidunt amet venenatis tristique in aliquam integer. Nulla in vehicula cras suscipit urna voluptas, dolor aliquet porttitor ornare fermentum amet adipiscing, ipsum nec mauris tellus mauris aliquam, suscipit ac dignissim sodales sem suscipit. Feugiat tincidunt vitae ornare elit faucibus aliquid, volutpat posuere libero labore sollicitudin ultricies, porttitor aliquam vestibulum ac non lacinia vitae. Magna suscipit suscipit sapien imperdiet tristique, morbi in et vulputate ut adipiscing cum, lorem libero justo mauris non pede donec, suspendisse iaculis porta turpis ut integer. Et lacinia in elementum nulla quam, posuere quam nisl vivamus et maecenas eros, magna lectus a rutrum malesuada nonummy. Sociosqu mi quis ligula lectus vel, mauris vestibulum ipsum vulputate in pede, pulvinar aliquam at justo wisi in elit. Ullamcorper proin nec in suscipit nibh sagittis, justo magna a purus in dictum morbi, donec nullam etiam tellus consectetuer mauris, felis morbi ante sapien sit nibh etiam. Varius malesuada est ultrices fusce ridiculus, leo nulla libero nec sed habitasse, et dignissim ad mi justo pellentesque odio. Interdum potenti donec a tincidunt nibh lorem, eleifend sagittis mollit ipsum at donec, cursus at tincidunt cras sit eget, varius vel pharetra ut in donec, at urna viverra sed magnis feugiat. Fames dapibus vivamus fringilla adipiscing quas, ut risus eget mauris sed ante, cras a ac orci cursus nascetur risus, dis gravida egestas turpis id vestibulum. Iaculis eget sem tortor odio lectus pede, condimentum dictum feugiat massa odio hendrerit aperiam, felis et nulla ut ligula wisi praesent, justo nonummy tempor dignissim lorem arcu dapibus. Luctus donec vulputate eu vestibulum maecenas laoreet, consequat mauris hendrerit ipsum elit sed natoque, tellus placerat vitae donec pharetra nulla. Conubia dictum orci nec quam sed, donec congue neque luctus vitae quam, lectus ornare blandit vestibulum semper nullam sollicitudin. Nam sem non aut justo vel enim, eu metus orci arcu lobortis amet, ac sem phasellus velit ac turpis adipiscing, nulla tempus purus vel orci quisque ac. Sed et metus sed ligula purus, consectetuer illo ut sed faucibus suspendisse suspendisse, cursus sed orci ipsum aenean in et, viverra maecenas nec nec lectus tempus. Id nec fusce hymenaeos vitae laboriosam, placerat condimentum diam amet ullamcorper risus, pellentesque mollis magna non enim dolor semper. Sem nullam a dui venenatis a, massa consectetuer in aenean eget condimentum, scelerisque eum euismod ultricies sint velit. A mattis sit nec aenean tempus cras, ligula dignissim nullam mauris curae neque, a dignissim morbi mi curabitur nulla, non tellus orci nonummy sed posuere aliquam, sapien incidunt in sed duis ac etiam. Etiam eget nonummy bibendum praesent eget aliquam, sed auctor erat neque in metus maecenas, amet id pellentesque gravida in wisi tristique, in eu eros non vitae diam turpis, massa et vel litora massa sagittis vehicula. Pede amet vivamus elementum donec maecenas erat, a dolor elit aptent orci pretium ligula, velit proin vestibulum wisi lorem eget, euismod fusce amet libero et id, nunc imperdiet consectetuer elementum integer repellat sodales. In risus morbi nibh rerum ut nonummy, ligula suscipit pharetra dolor diam ornare, ullamcorper nonummy ut wisi vestibulum vivamus convallis. Est porta eros euismod nulla ullamcorper, metus vestibulum libero est mauris tortor nulla, a nulla non vivamus sed non vestibulum, suscipit sed euismod ut nisl et elit. Vel at eget orci fringilla leo, non maecenas vestibulum mauris dictum justo rutrum, integer ultrices sit purus aliquam phasellus, turpis iaculis non non commodo tortor pulvinar, habitasse tincidunt integer lorem vestibulum porta. Magna libero purus imperdiet neque molestie, nonummy eget repellendus volutpat nulla elit, in in varius metus nam vel dictum, libero ultricies justo felis duis ante sit, turpis amet sociis sit dolor cras est. Risus id mattis eget commodo faucibus, porttitor vulputate quis tellus wisi interdum dictum, mauris a sodales erat elementum amet. Ligula odio pellentesque nam et vitae eu, dui eleifend consequat at id eget, imperdiet malesuada arcu suspendisse faucibus ipsum, vivamus ullamcorper semper volutpat sit in, dignissim feugiat litora dapibus porta id purus. Lorem mi vehicula ultrices massa tortor in, lacus pellentesque donec enim feugiat volutpat quis, dictum pede pellentesque elit massa in, at cras urna enim sem posuere explicabo, nibh eget vitae nunc interdum egestas. Sagittis a amet penatibus nec tincidunt felis, feugiat nascetur quisque phasellus justo ligula vestibulum, magnis aptent felis integer tempor sodales porttitor, vitae lorem orci lobortis aliquam condimentum congue. Et arcu vehicula venenatis magna rhoncus etiam, neque nulla eu vel vestibulum amet adipiscing, suspendisse lacinia ac ad nec risus, dolor orci gravida a arcu volutpat, ac arcu at nascetur accusamus eu. In pulvinar vitae nonummy placerat neque sapien, fusce amet lorem quam parturient mi, lorem vehicula nec suspendisse luctus eu. Mollis leo lacus vel at dapibus eros, in ex orci tortor adipiscing in, sodales facilisis integer elit lectus iaculis, elit posuere turpis pretium nec sodales. Parturient eleifend aliquam pretium urna dignissim venenatis, quis tellus urna enim donec sagittis, lectus nullam in consectetuer ac a erat. Lorem donec in in amet mauris, id convallis turpis in lacus taciti a, nec neque vestibulum dolor amet condimentum, sit magnis ultricies urna interdum maecenas. Dictum ipsum sapien leo suspendisse velit, et rutrum est sodales porta parturient, justo inceptos pede pellentesque posuere erat qui, at suspendisse elit ut consequat vestibulum. Ut ut lectus orci pellentesque mollis, ullamcorper nulla volutpat mattis dui eget, fermentum purus quis pellentesque aliquet habitant. Fringilla neque morbi vulputate nulla inventore, lorem velit feugiat tortor quam turpis, cum eget animi sit tempor volutpat ac. A id velit ut maxime in, pede sapien augue duis ultrices interdum eu, praesent consectetuer id a ipsum mauris at. Velit mattis metus mi malesuada pede quam, arcu vitae eros lectus sed venenatis, quis vestibulum quam in tortor maecenas ac, non massa justo nisl pharetra volutpat diam. Urna ad egestas in mauris volutpat donec, maecenas nisl nunc id quam ultricies tristique, leo nibh at sit nunc vitae commodo, ut leo lectus montes eu condimentum id, morbi vestibulum volutpat aliquet sit cras vivamus. Aliquet nec class pede morbi in quam, porttitor eu vel maecenas est ipsum doloremque, pede elit vestibulum fugiat sed tristique, arcu sem sollicitudin nec arcu est, pretium nisl magna sed mattis vitae augue. Natoque at vel tortor placerat tristique, convallis mauris sodales ac consequat ac ut, vestibulum pretium aliquam eget non tempor. Leo justo urna suspendisse sollicitudin imperdiet quis, fringilla nunc pede malesuada quam faucibus nibh, habitasse vestibulum rhoncus velit id donec velit, vivamus sed id vitae posuere lectus. Pellentesque urna vel eu felis ullamcorper, vel accumsan urna massa wisi metus, donec elit velit eget malesuada maecenas, lectus amet etiam sollicitudin feugiat in orci, integer morbi ridiculus tincidunt suscipit donec consequatur. Ultricies ut diam blandit praesent aliquam egestas, tellus varius inceptos duis pellentesque auctor per, libero donec fringilla est amet metus, ipsum est nunc massa cras vel aliquam. Eros curabitur non interdum nisl ac, mauris quisque quam metus dui morbi vel, quis id dolor urna dictumst vel nunc, fringilla velit vel semper vel tempus. Massa nullam in turpis justo rutrum et, velit in blandit lobortis libero dolor, ante urna lobortis et vivamus purus, est wisi mauris erat libero aliquet metus, wisi mollis nam pulvinar vivamus sed orci. Odio dictumst ut mi ultrices dui, quam varius imperdiet posuere donec nec arcu, ac sit eros lacus purus morbi massa, turpis luctus at eget ante sed, ut nunc nulla nec sunt scelerisque. Arcu leo augue libero gravida nam duis, torquent mus elit mus sociis id arcu, montes id consectetuer ipsum purus tincidunt lectus. Feugiat libero convallis in nunc viverra, mauris pharetra a maecenas ut risus a, tempus gravida cursus amet rhoncus luctus. Pharetra consectetuer ut dolor nostra dolor sed, curabitur odio quam et eget sed, vestibulum porta tempus imperdiet ullamcorper ad ultrices. Molestiae vel arcu nec neque doloribus, dui aliquam pharetra varius ad quaerat sed, et nec ornare nullam vivamus viverra, sed vitae egestas et felis ultrices nonummy. Tincidunt provident vivamus proin pellentesque turpis, justo habitant inceptos feugiat ultrices eu, tellus dolorum donec hac rhoncus lorem sit. Orci gravida consectetuer wisi imperdiet consequat, non metus eos dolor sed eu urna, fusce aliquam et malesuada proin vitae, elementum magna et non mattis augue, luctus hendrerit sit a asperiores eius. Aliquam bibendum erat curabitur pharetra pellentesque, mauris suspendisse hendrerit sed orci aliquam, augue amet nascetur duis vitae donec, feugiat condimentum habitasse elit ac ante turpis. Amet vitae dolor adipiscing turpis non, molestie dapibus lacus a et ante penatibus, condimentum mi quam quis suspendisse pellentesque ullamcorper, ac fringilla amet felis eget felis, malesuada montes amet vehicula urna neque ut. Orci mattis quisque lectus id a, enim suspendisse curabitur ut massa dignissim proin, pellentesque aliquam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, vel habitant erat suspendisse tristique eu est. Parturient vulputate pharetra vitae integer magna morbi, class ullamcorper porta vel amet molestie, felis dapibus pulvinar sit praesent leo lacus. Tristique nam ut tempor metus euismod sodales, urna sit sed vestibulum praesent nec, adipiscing eget et nec est ut, tempor nonummy phasellus sem vestibulum eu varius, purus nibh nulla eu nostra tristique. Est ut ultricies quam vestibulum lobortis nibh, purus imperdiet quis hymenaeos impedit porta, pharetra ornare laudantium elit nulla in, morbi vehicula amet lacinia nec vulputate eu. Tellus lobortis est quis amet non, nec risus mauris nisi tortor dictum integer, consectetuer luctus vel fusce suspendisse egestas magna. Massa sed elementum aliquet ornare metus lorem, odio est platea nunc mattis imperdiet commodo, laoreet et a felis amet wisi, massa vulputate pulvinar non gravida vivamus. Sed ante metus dolor velit nunc, tempus nec vestibulum in sed venenatis, dui mollis sit tristique ultricies sociis, magna ante dolor ipsum sodales amet. Malesuada sed facilisis sit tempor urna, iaculis est cras fusce wisi vivamus, etiam ullamcorper gravida risus sed rutrum, in quis arcu nec quis ut, arcu massa suspendisse ipsum in dui. Suspendisse class vivamus nullam fermentum ac, vehicula sollicitudin suam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, veec viverra voluLorem ipsum dolor sit amet, fermentum pharetra ipsum sed mauris scelerisque culpa, laoreet libero etiam pharetra eu lacus, sed varius magna hac tellus praesent in, suspendisse urna tellus placerat non risus. Porttitor nonummy vehicula wisi sint tempor, vitae tellus nulla fermentum quis quis, mauris dignissim omnis porta ac volutpat, hac eget viverra in gravida nonummy pulvinar, velit nulla feugiat parturient netus mollis aliquam. Arcu leo scelerisque quisque blandit pellentesque, ultricies nascetur purus cursus imperdiet accumsan sagittis, praesent nunc sed dapibus dui in. Cubilia lorem lacus tellus diam debitis, commodo fusce dolor adipisicing consectetuer et vitae, vestibulum ornare accumsan vitae accumsan praesent, morbi faucibus justo lorem augue porta sodales, molestie nulla ac nibh nec est aenean. Praesent erat maecenas odio ante dolor, vehicula nam mi ultrices ut dolor ante, fusce ridiculus at arcu urna felis vel, a pellentesque arcu accumsan nulla deserunt. Nunc ornare nec a diam aliquam urna, maecenas vivamus senectus sagittis tellus ac faucibus, mi leo quam tempor amet facilisis, sapien per cras placerat libero porta, vitae mauris quis sit nec ut. Sit magna vitae donec leo urna, nascetur eu viverra massa amet pharetra proident, elit commodo ipsum proin pellentesque consequat feugiat, elit sit quis facilisis ipsum ornare pellentesque. Morbi enim et et pretium et tortor, praesent adipiscing placerat aliquet dolor vestibulum, tempus at consectetuer ut diam fermentum nulla. Pellentesque lorem phasellus tristique a ac donec, augue suspendisse orci consequat rhoncus dapibus, magna quam habitasse assumenda duis imperdiet scelerisque. Turpis iaculis ipsum phasellus vitae et, nunc congue rhoncus eu diam in, rutrum dui mauris leo est sodales. Ut ante tempora imperdiet orci in ut, turpis laoreet dapibus penatibus ut in, tempor ac gravida est nam lorem dictum. Lacinia bibendum vitae ante lacus in, orci per orci amet sed dolor lorem, ullamcorper at a praesent quis dictum consectetuer, dolor nunc fermentum interdum tortor voluptatem. Vestibulum cursus nunc nunc risus nec metus, diam mauris vestibulum nullam pellentesque ipsum, maecenas et semper platea wisi porttitor curabitur. Quis adipiscing adipiscing purus vestibulum gravida, lacinia justo vel interdum sociosqu lacus, wisi leo fusce aenean arcu sapien volutpat, ipsum accumsan a ornare tellus et. Sagittis sit malesuada pellentesque nulla enim, accumsan tempor a in vehicula et ipsum, montes est risus adipiscing wisi amet, sed tempus eu purus quisque donec. In non purus wisi donec vel amet, maecenas enim cursus etiam dapibus ac, in fringilla facilisis nibh congue et, commodo et curabitur sapien ut facilisis, morbi turpis facilisis sit tortor faucibus in. Ut aenean erat tempor purus et venenatis, cursus feugiat amet blandit vel bibendum, mi purus felis odio suspendisse sed, nunc urna eum tincidunt a consequat, venenatis curabitur elit nullam aliquam nec laboriosam. Vestibulum integer ut cursus laoreet odio, tincidunt maecenas vel sed ut ac varius, malesuada diam libero sodales ipsum sed, viverra erat sit integer quisque iaculis volutpat, penatibus quam donec accumsan duis in a. Sodales ipsum torquent tempus dolore sit, sagittis mauris nisl in sed rutrum a, amet ut elit fusce libero netus egestas, lobortis sit turpis augue maecenas integer. Eget porttitor nunc risus faucibus enim, donec nec convallis egestas pellentesque lectus felis, vulputate suspendisse risus metus blandit quis, a suspendisse nonummy enim fermentum per dapibus. Et faucibus vestibulum iaculis sapiente per accumsan, fringilla elementum auctor praesent sollicitudin rutrum laoreet, fugit suspendisse duis et vestibulum eu euismod, feugiat quis sit nunc dolor urna. Id suscipit porta sed wisi nam vehicula, integer ut massa donec eget dolor sapien, elit tincidunt condimentum rutrum magna pede, est tellus pellentesque facilisi dictum laoreet amet, ac quam ligula pede vitae pellentesque. Litora sed a cubilia dui vestibulum felis, nascetur hac parturient integer convallis in, donec tellus ipsum aliquam proin massa. In pede eu parturient nisl lectus, amet magna at sit massa ipsum pellentesque, pharetra augue dolor egestas porta dictum mi. Leo etiam dui mauris turpis erat vel, velit bibendum odio sagittis sagittis in, sodales vitae et massa at mattis. Vulputate nonummy pede rhoncus est ut, placerat placerat tristique in aliquet id, lobortis sed non ornare vestibulum consectetuer. Risus augue sed ac lectus volutpat, nulla arcu iaculis aenean aliquam ut lacinia, at mi amet facilisis purus morbi sollicitudin. Eget nulla molestie lectus tincidunt vel, tellus quo odio nonummy mauris felis, integer sapien tellus dignissim viverra lorem suspendisse. Duis molestiae sem vel eu orci, a nibh a lorem porttitor quisque tincidunt, euismod a dui sodales aliquam aliquet, fusce mollis maecenas aenean etiam vestibulum. Neque bibendum cras vitae turpis in, eget pulvinar curabitur non voluptatibus sit, malesuada sodales non quam bibendum malesuada rutrum, velit lacus at sit diam ultrices tempus, pellentesque in a hendrerit dictumst aenean a. Tellus praesent elit sodales sodales neque diam, odio aliquam lorem nulla accumsan nec, eget vestibulum nunc eget dignissim mauris eu, tristique etiam sapien nulla cillum pharetra dolor, at sapien auctor quis fringilla faucibus. Suspendisse hendrerit morbi auctor nulla imperdiet tortor, nunc risus ut id justo adipiscing, amet vivamus cursus aenean hendrerit nec nibh. Cursus dui maecenas at suspendisse morbi, lectus hymenaeos viverra in erat nesciunt, et tempore nesciunt nibh non excepturi. Dignissim nullam blandit mauris turpis quam, ac litora ipsum pellentesque ipsum ultrices, a nec curabitur vel tortor praesent. Justo vel sit phasellus mauris pede aliquet, donec ante sed vulputate quis consectetuer urna, eu non metus a hendrerit praesent, pellentesque lobortis arcu quis consectetuer scelerisque, vel excepturi risus imperdiet auctor neque. Et dictumst non mattis nibh mi, sed id semper et commodo morbi, amet eget mollis morbi urna in lobortis. Purus proin morbi mi arcu nostra minima, sed id elit purus justo a enim, lectus placerat fusce ante consequat wisi tellus, donec donec tortor ut orci eu, tincidunt amet venenatis tristique in aliquam integer. Nulla in vehicula cras suscipit urna voluptas, dolor aliquet porttitor ornare fermentum amet adipiscing, ipsum nec mauris tellus mauris aliquam, suscipit ac dignissim sodales sem suscipit. Feugiat tincidunt vitae ornare elit faucibus aliquid, volutpat posuere libero labore sollicitudin ultricies, porttitor aliquam vestibulum ac non lacinia vitae. Magna suscipit suscipit sapien imperdiet tristique, morbi in et vulputate ut adipiscing cum, lorem libero justo mauris non pede donec, suspendisse iaculis porta turpis ut integer. Et lacinia in elementum nulla quam, posuere quam nisl vivamus et maecenas eros, magna lectus a rutrum malesuada nonummy. Sociosqu mi quis ligula lectus vel, mauris vestibulum ipsum vulputate in pede, pulvinar aliquam at justo wisi in elit. Ullamcorper proin nec in suscipit nibh sagittis, justo magna a purus in dictum morbi, donec nullam etiam tellus consectetuer mauris, felis morbi ante sapien sit nibh etiam. Varius malesuada est ultrices fusce ridiculus, leo nulla libero nec sed habitasse, et dignissim ad mi justo pellentesque odio. Interdum potenti donec a tincidunt nibh lorem, eleifend sagittis mollit ipsum at donec, cursus at tincidunt cras sit eget, varius vel pharetra ut in donec, at urna viverra sed magnis feugiat. Fames dapibus vivamus fringilla adipiscing quas, ut risus eget mauris sed ante, cras a ac orci cursus nascetur risus, dis gravida egestas turpis id vestibulum. Iaculis eget sem tortor odio lectus pede, condimentum dictum feugiat massa odio hendrerit aperiam, felis et nulla ut ligula wisi praesent, justo nonummy tempor dignissim lorem arcu dapibus. Luctus donec vulputate eu vestibulum maecenas laoreet, consequat mauris hendrerit ipsum elit sed natoque, tellus placerat vitae donec pharetra nulla. Conubia dictum orci nec quam sed, donec congue neque luctus vitae quam, lectus ornare blandit vestibulum semper nullam sollicitudin. Nam sem non aut justo vel enim, eu metus orci arcu lobortis amet, ac sem phasellus velit ac turpis adipiscing, nulla tempus purus vel orci quisque ac. Sed et metus sed ligula purus, consectetuer illo ut sed faucibus suspendisse suspendisse, cursus sed orci ipsum aenean in et, viverra maecenas nec nec lectus tempus. Id nec fusce hymenaeos vitae laboriosam, placerat condimentum diam amet ullamcorper risus, pellentesque mollis magna non enim dolor semper. Sem nullam a dui venenatis a, massa consectetuer in aenean eget condimentum, scelerisque eum euismod ultricies sint velit. A mattis sit nec aenean tempus cras, ligula dignissim nullam mauris curae neque, a dignissim morbi mi curabitur nulla, non tellus orci nonummy sed posuere aliquam, sapien incidunt in sed duis ac etiam. Etiam eget nonummy bibendum praesent eget aliquam, sed auctor erat neque in metus maecenas, amet id pellentesque gravida in wisi tristique, in eu eros non vitae diam turpis, massa et vel litora massa sagittis vehicula. Pede amet vivamus elementum donec maecenas erat, a dolor elit aptent orci pretium ligula, velit proin vestibulum wisi lorem eget, euismod fusce amet libero et id, nunc imperdiet consectetuer elementum integer repellat sodales. In risus morbi nibh rerum ut nonummy, ligula suscipit pharetra dolor diam ornare, ullamcorper nonummy ut wisi vestibulum vivamus convallis. Est porta eros euismod nulla ullamcorper, metus vestibulum libero est mauris tortor nulla, a nulla non vivamus sed non vestibulum, suscipit sed euismod ut nisl et elit. Vel at eget orci fringilla leo, non maecenas vestibulum mauris dictum justo rutrum, integer ultrices sit purus aliquam phasellus, turpis iaculis non non commodo tortor pulvinar, habitasse tincidunt integer lorem vestibulum porta. Magna libero purus imperdiet neque molestie, nonummy eget repellendus volutpat nulla elit, in in varius metus nam vel dictum, libero ultricies justo felis duis ante sit, turpis amet sociis sit dolor cras est. Risus id mattis eget commodo faucibus, porttitor vulputate quis tellus wisi interdum dictum, mauris a sodales erat elementum amet. Ligula odio pellentesque nam et vitae eu, dui eleifend consequat at id eget, imperdiet malesuada arcu suspendisse faucibus ipsum, vivamus ullamcorper semper volutpat sit in, dignissim feugiat litora dapibus porta id purus. Lorem mi vehicula ultrices massa tortor in, lacus pellentesque donec enim feugiat volutpat quis, dictum pede pellentesque elit massa in, at cras urna enim sem posuere explicabo, nibh eget vitae nunc interdum egestas. Sagittis a amet penatibus nec tincidunt felis, feugiat nascetur quisque phasellus justo ligula vestibulum, magnis aptent felis integer tempor sodales porttitor, vitae lorem orci lobortis aliquam condimentum congue. Et arcu vehicula venenatis magna rhoncus etiam, neque nulla eu vel vestibulum amet adipiscing, suspendisse lacinia ac ad nec risus, dolor orci gravida a arcu volutpat, ac arcu at nascetur accusamus eu. In pulvinar vitae nonummy placerat neque sapien, fusce amet lorem quam parturient mi, lorem vehicula nec suspendisse luctus eu. Mollis leo lacus vel at dapibus eros, in ex orci tortor adipiscing in, sodales facilisis integer elit lectus iaculis, elit posuere turpis pretium nec sodales. Parturient eleifend aliquam pretium urna dignissim venenatis, quis tellus urna enim donec sagittis, lectus nullam in consectetuer ac a erat. Lorem donec in in amet mauris, id convallis turpis in lacus taciti a, nec neque vestibulum dolor amet condimentum, sit magnis ultricies urna interdum maecenas. Dictum ipsum sapien leo suspendisse velit, et rutrum est sodales porta parturient, justo inceptos pede pellentesque posuere erat qui, at suspendisse elit ut consequat vestibulum. Ut ut lectus orci pellentesque mollis, ullamcorper nulla volutpat mattis dui eget, fermentum purus quis pellentesque aliquet habitant. Fringilla neque morbi vulputate nulla inventore, lorem velit feugiat tortor quam turpis, cum eget animi sit tempor volutpat ac. A id velit ut maxime in, pede sapien augue duis ultrices interdum eu, praesent consectetuer id a ipsum mauris at. Velit mattis metus mi malesuada pede quam, arcu vitae eros lectus sed venenatis, quis vestibulum quam in tortor maecenas ac, non massa justo nisl pharetra volutpat diam. Urna ad egestas in mauris volutpat donec, maecenas nisl nunc id quam ultricies tristique, leo nibh at sit nunc vitae commodo, ut leo lectus montes eu condimentum id, morbi vestibulum volutpat aliquet sit cras vivamus. Aliquet nec class pede morbi in quam, porttitor eu vel maecenas est ipsum doloremque, pede elit vestibulum fugiat sed tristique, arcu sem sollicitudin nec arcu est, pretium nisl magna sed mattis vitae augue. Natoque at vel tortor placerat tristique, convallis mauris sodales ac consequat ac ut, vestibulum pretium aliquam eget non tempor. Leo justo urna suspendisse sollicitudin imperdiet quis, fringilla nunc pede malesuada quam faucibus nibh, habitasse vestibulum rhoncus velit id donec velit, vivamus sed id vitae posuere lectus. Pellentesque urna vel eu felis ullamcorper, vel accumsan urna massa wisi metus, donec elit velit eget malesuada maecenas, lectus amet etiam sollicitudin feugiat in orci, integer morbi ridiculus tincidunt suscipit donec consequatur. Ultricies ut diam blandit praesent aliquam egestas, tellus varius inceptos duis pellentesque auctor per, libero donec fringilla est amet metus, ipsum est nunc massa cras vel aliquam. Eros curabitur non interdum nisl ac, mauris quisque quam metus dui morbi vel, quis id dolor urna dictumst vel nunc, fringilla velit vel semper vel tempus. Massa nullam in turpis justo rutrum et, velit in blandit lobortis libero dolor, ante urna lobortis et vivamus purus, est wisi mauris erat libero aliquet metus, wisi mollis nam pulvinar vivamus sed orci. Odio dictumst ut mi ultrices dui, quam varius imperdiet posuere donec nec arcu, ac sit eros lacus purus morbi massa, turpis luctus at eget ante sed, ut nunc nulla nec sunt scelerisque. Arcu leo augue libero gravida nam duis, torquent mus elit mus sociis id arcu, montes id consectetuer ipsum purus tincidunt lectus. Feugiat libero convallis in nunc viverra, mauris pharetra a maecenas ut risus a, tempus gravida cursus amet rhoncus luctus. Pharetra consectetuer ut dolor nostra dolor sed, curabitur odio quam et eget sed, vestibulum porta tempus imperdiet ullamcorper ad ultrices. Molestiae vel arcu nec neque doloribus, dui aliquam pharetra varius ad quaerat sed, et nec ornare nullam vivamus viverra, sed vitae egestas et felis ultrices nonummy. Tincidunt provident vivamus proin pellentesque turpis, justo habitant inceptos feugiat ultrices eu, tellus dolorum donec hac rhoncus lorem sit. Orci gravida consectetuer wisi imperdiet consequat, non metus eos dolor sed eu urna, fusce aliquam et malesuada proin vitae, elementum magna et non mattis augue, luctus hendrerit sit a asperiores eius. Aliquam bibendum erat curabitur pharetra pellentesque, mauris suspendisse hendrerit sed orci aliquam, augue amet nascetur duis vitae donec, feugiat condimentum habitasse elit ac ante turpis. Amet vitae dolor adipiscing turpis non, molestie dapibus lacus a et ante penatibus, condimentum mi quam quis suspendisse pellentesque ullamcorper, ac fringilla amet felis eget felis, malesuada montes amet vehicula urna neque ut. Orci mattis quisque lectus id a, enim suspendisse curabitur ut massa dignissim proin, pellentesque aliquam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, vel habitant erat suspendisse tristique eu est. Parturient vulputate pharetra vitae integer magna morbi, class ullamcorper porta vel amet molestie, felis dapibus pulvinar sit praesent leo lacus. Tristique nam ut tempor metus euismod sodales, urna sit sed vestibulum praesent nec, adipiscing eget et nec est ut, tempor nonummy phasellus sem vestibulum eu varius, purus nibh nulla eu nostra tristique. Est ut ultricies quam vestibulum lobortis nibh, purus imperdiet quis hymenaeos impedit porta, pharetra ornare laudantium elit nulla in, morbi vehicula amet lacinia nec vulputate eu. Tellus lobortis est quis amet non, nec risus mauris nisi tortor dictum integer, consectetuer luctus vel fusce suspendisse egestas magna. Massa sed elementum aliquet ornare metus lorem, odio est platea nunc mattis imperdiet commodo, laoreet et a felis amet wisi, massa vulputate pulvinar non gravida vivamus. Sed ante metus dolor velit nunc, tempus nec vestibulum in sed venenatis, dui mollis sit tristique ultricies sociis, magna ante dolor ipsum sodales amet. Malesuada sed facilisis sit tempor urna, iaculis est cras fusce wisi vivamus, etiam ullamcorper gravida risus sed rutrum, in quis arcu nec quis ut, arcu massa suspendisse ipsum in dui. Suspendisse class vivamus nullam fermentum ac, vehicula sollicitudin suam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, veec viverra voluLorem ipsum dolor sit amet, fermentum pharetra ipsum sed mauris scelerisque culpa, laoreet libero etiam pharetra eu lacus, sed varius magna hac tellus praesent in, suspendisse urna tellus placerat non risus. Porttitor nonummy vehicula wisi sint tempor, vitae tellus nulla fermentum quis quis, mauris dignissim omnis porta ac volutpat, hac eget viverra in gravida nonummy pulvinar, velit nulla feugiat parturient netus mollis aliquam. Arcu leo scelerisque quisque blandit pellentesque, ultricies nascetur purus cursus imperdiet accumsan sagittis, praesent nunc sed dapibus dui in. Cubilia lorem lacus tellus diam debitis, commodo fusce dolor adipisicing consectetuer et vitae, vestibulum ornare accumsan vitae accumsan praesent, morbi faucibus justo lorem augue porta sodales, molestie nulla ac nibh nec est aenean. Praesent erat maecenas odio ante dolor, vehicula nam mi ultrices ut dolor ante, fusce ridiculus at arcu urna felis vel, a pellentesque arcu accumsan nulla deserunt. Nunc ornare nec a diam aliquam urna, maecenas vivamus senectus sagittis tellus ac faucibus, mi leo quam tempor amet facilisis, sapien per cras placerat libero porta, vitae mauris quis sit nec ut. Sit magna vitae donec leo urna, nascetur eu viverra massa amet pharetra proident, elit commodo ipsum proin pellentesque consequat feugiat, elit sit quis facilisis ipsum ornare pellentesque. Morbi enim et et pretium et tortor, praesent adipiscing placerat aliquet dolor vestibulum, tempus at consectetuer ut diam fermentum nulla. Pellentesque lorem phasellus tristique a ac donec, augue suspendisse orci consequat rhoncus dapibus, magna quam habitasse assumenda duis imperdiet scelerisque. Turpis iaculis ipsum phasellus vitae et, nunc congue rhoncus eu diam in, rutrum dui mauris leo est sodales. Ut ante tempora imperdiet orci in ut, turpis laoreet dapibus penatibus ut in, tempor ac gravida est nam lorem dictum. Lacinia bibendum vitae ante lacus in, orci per orci amet sed dolor lorem, ullamcorper at a praesent quis dictum consectetuer, dolor nunc fermentum interdum tortor voluptatem. Vestibulum cursus nunc nunc risus nec metus, diam mauris vestibulum nullam pellentesque ipsum, maecenas et semper platea wisi porttitor curabitur. Quis adipiscing adipiscing purus vestibulum gravida, lacinia justo vel interdum sociosqu lacus, wisi leo fusce aenean arcu sapien volutpat, ipsum accumsan a ornare tellus et. Sagittis sit malesuada pellentesque nulla enim, accumsan tempor a in vehicula et ipsum, montes est risus adipiscing wisi amet, sed tempus eu purus quisque donec. In non purus wisi donec vel amet, maecenas enim cursus etiam dapibus ac, in fringilla facilisis nibh congue et, commodo et curabitur sapien ut facilisis, morbi turpis facilisis sit tortor faucibus in. Ut aenean erat tempor purus et venenatis, cursus feugiat amet blandit vel bibendum, mi purus felis odio suspendisse sed, nunc urna eum tincidunt a consequat, venenatis curabitur elit nullam aliquam nec laboriosam. Vestibulum integer ut cursus laoreet odio, tincidunt maecenas vel sed ut ac varius, malesuada diam libero sodales ipsum sed, viverra erat sit integer quisque iaculis volutpat, penatibus quam donec accumsan duis in a. Sodales ipsum torquent tempus dolore sit, sagittis mauris nisl in sed rutrum a, amet ut elit fusce libero netus egestas, lobortis sit turpis augue maecenas integer. Eget porttitor nunc risus faucibus enim, donec nec convallis egestas pellentesque lectus felis, vulputate suspendisse risus metus blandit quis, a suspendisse nonummy enim fermentum per dapibus. Et faucibus vestibulum iaculis sapiente per accumsan, fringilla elementum auctor praesent sollicitudin rutrum laoreet, fugit suspendisse duis et vestibulum eu euismod, feugiat quis sit nunc dolor urna. Id suscipit porta sed wisi nam vehicula, integer ut massa donec eget dolor sapien, elit tincidunt condimentum rutrum magna pede, est tellus pellentesque facilisi dictum laoreet amet, ac quam ligula pede vitae pellentesque. Litora sed a cubilia dui vestibulum felis, nascetur hac parturient integer convallis in, donec tellus ipsum aliquam proin massa. In pede eu parturient nisl lectus, amet magna at sit massa ipsum pellentesque, pharetra augue dolor egestas porta dictum mi. Leo etiam dui mauris turpis erat vel, velit bibendum odio sagittis sagittis in, sodales vitae et massa at mattis. Vulputate nonummy pede rhoncus est ut, placerat placerat tristique in aliquet id, lobortis sed non ornare vestibulum consectetuer. Risus augue sed ac lectus volutpat, nulla arcu iaculis aenean aliquam ut lacinia, at mi amet facilisis purus morbi sollicitudin. Eget nulla molestie lectus tincidunt vel, tellus quo odio nonummy mauris felis, integer sapien tellus dignissim viverra lorem suspendisse. Duis molestiae sem vel eu orci, a nibh a lorem porttitor quisque tincidunt, euismod a dui sodales aliquam aliquet, fusce mollis maecenas aenean etiam vestibulum. Neque bibendum cras vitae turpis in, eget pulvinar curabitur non voluptatibus sit, malesuada sodales non quam bibendum malesuada rutrum, velit lacus at sit diam ultrices tempus, pellentesque in a hendrerit dictumst aenean a. Tellus praesent elit sodales sodales neque diam, odio aliquam lorem nulla accumsan nec, eget vestibulum nunc eget dignissim mauris eu, tristique etiam sapien nulla cillum pharetra dolor, at sapien auctor quis fringilla faucibus. Suspendisse hendrerit morbi auctor nulla imperdiet tortor, nunc risus ut id justo adipiscing, amet vivamus cursus aenean hendrerit nec nibh. Cursus dui maecenas at suspendisse morbi, lectus hymenaeos viverra in erat nesciunt, et tempore nesciunt nibh non excepturi. Dignissim nullam blandit mauris turpis quam, ac litora ipsum pellentesque ipsum ultrices, a nec curabitur vel tortor praesent. Justo vel sit phasellus mauris pede aliquet, donec ante sed vulputate quis consectetuer urna, eu non metus a hendrerit praesent, pellentesque lobortis arcu quis consectetuer scelerisque, vel excepturi risus imperdiet auctor neque. Et dictumst non mattis nibh mi, sed id semper et commodo morbi, amet eget mollis morbi urna in lobortis. Purus proin morbi mi arcu nostra minima, sed id elit purus justo a enim, lectus placerat fusce ante consequat wisi tellus, donec donec tortor ut orci eu, tincidunt amet venenatis tristique in aliquam integer. Nulla in vehicula cras suscipit urna voluptas, dolor aliquet porttitor ornare fermentum amet adipiscing, ipsum nec mauris tellus mauris aliquam, suscipit ac dignissim sodales sem suscipit. Feugiat tincidunt vitae ornare elit faucibus aliquid, volutpat posuere libero labore sollicitudin ultricies, porttitor aliquam vestibulum ac non lacinia vitae. Magna suscipit suscipit sapien imperdiet tristique, morbi in et vulputate ut adipiscing cum, lorem libero justo mauris non pede donec, suspendisse iaculis porta turpis ut integer. Et lacinia in elementum nulla quam, posuere quam nisl vivamus et maecenas eros, magna lectus a rutrum malesuada nonummy. Sociosqu mi quis ligula lectus vel, mauris vestibulum ipsum vulputate in pede, pulvinar aliquam at justo wisi in elit. Ullamcorper proin nec in suscipit nibh sagittis, justo magna a purus in dictum morbi, donec nullam etiam tellus consectetuer mauris, felis morbi ante sapien sit nibh etiam. Varius malesuada est ultrices fusce ridiculus, leo nulla libero nec sed habitasse, et dignissim ad mi justo pellentesque odio. Interdum potenti donec a tincidunt nibh lorem, eleifend sagittis mollit ipsum at donec, cursus at tincidunt cras sit eget, varius vel pharetra ut in donec, at urna viverra sed magnis feugiat. Fames dapibus vivamus fringilla adipiscing quas, ut risus eget mauris sed ante, cras a ac orci cursus nascetur risus, dis gravida egestas turpis id vestibulum. Iaculis eget sem tortor odio lectus pede, condimentum dictum feugiat massa odio hendrerit aperiam, felis et nulla ut ligula wisi praesent, justo nonummy tempor dignissim lorem arcu dapibus. Luctus donec vulputate eu vestibulum maecenas laoreet, consequat mauris hendrerit ipsum elit sed natoque, tellus placerat vitae donec pharetra nulla. Conubia dictum orci nec quam sed, donec congue neque luctus vitae quam, lectus ornare blandit vestibulum semper nullam sollicitudin. Nam sem non aut justo vel enim, eu metus orci arcu lobortis amet, ac sem phasellus velit ac turpis adipiscing, nulla tempus purus vel orci quisque ac. Sed et metus sed ligula purus, consectetuer illo ut sed faucibus suspendisse suspendisse, cursus sed orci ipsum aenean in et, viverra maecenas nec nec lectus tempus. Id nec fusce hymenaeos vitae laboriosam, placerat condimentum diam amet ullamcorper risus, pellentesque mollis magna non enim dolor semper. Sem nullam a dui venenatis a, massa consectetuer in aenean eget condimentum, scelerisque eum euismod ultricies sint velit. A mattis sit nec aenean tempus cras, ligula dignissim nullam mauris curae neque, a dignissim morbi mi curabitur nulla, non tellus orci nonummy sed posuere aliquam, sapien incidunt in sed duis ac etiam. Etiam eget nonummy bibendum praesent eget aliquam, sed auctor erat neque in metus maecenas, amet id pellentesque gravida in wisi tristique, in eu eros non vitae diam turpis, massa et vel litora massa sagittis vehicula. Pede amet vivamus elementum donec maecenas erat, a dolor elit aptent orci pretium ligula, velit proin vestibulum wisi lorem eget, euismod fusce amet libero et id, nunc imperdiet consectetuer elementum integer repellat sodales. In risus morbi nibh rerum ut nonummy, ligula suscipit pharetra dolor diam ornare, ullamcorper nonummy ut wisi vestibulum vivamus convallis. Est porta eros euismod nulla ullamcorper, metus vestibulum libero est mauris tortor nulla, a nulla non vivamus sed non vestibulum, suscipit sed euismod ut nisl et elit. Vel at eget orci fringilla leo, non maecenas vestibulum mauris dictum justo rutrum, integer ultrices sit purus aliquam phasellus, turpis iaculis non non commodo tortor pulvinar, habitasse tincidunt integer lorem vestibulum porta. Magna libero purus imperdiet neque molestie, nonummy eget repellendus volutpat nulla elit, in in varius metus nam vel dictum, libero ultricies justo felis duis ante sit, turpis amet sociis sit dolor cras est. Risus id mattis eget commodo faucibus, porttitor vulputate quis tellus wisi interdum dictum, mauris a sodales erat elementum amet. Ligula odio pellentesque nam et vitae eu, dui eleifend consequat at id eget, imperdiet malesuada arcu suspendisse faucibus ipsum, vivamus ullamcorper semper volutpat sit in, dignissim feugiat litora dapibus porta id purus. Lorem mi vehicula ultrices massa tortor in, lacus pellentesque donec enim feugiat volutpat quis, dictum pede pellentesque elit massa in, at cras urna enim sem posuere explicabo, nibh eget vitae nunc interdum egestas. Sagittis a amet penatibus nec tincidunt felis, feugiat nascetur quisque phasellus justo ligula vestibulum, magnis aptent felis integer tempor sodales porttitor, vitae lorem orci lobortis aliquam condimentum congue. Et arcu vehicula venenatis magna rhoncus etiam, neque nulla eu vel vestibulum amet adipiscing, suspendisse lacinia ac ad nec risus, dolor orci gravida a arcu volutpat, ac arcu at nascetur accusamus eu. In pulvinar vitae nonummy placerat neque sapien, fusce amet lorem quam parturient mi, lorem vehicula nec suspendisse luctus eu. Mollis leo lacus vel at dapibus eros, in ex orci tortor adipiscing in, sodales facilisis integer elit lectus iaculis, elit posuere turpis pretium nec sodales. Parturient eleifend aliquam pretium urna dignissim venenatis, quis tellus urna enim donec sagittis, lectus nullam in consectetuer ac a erat. Lorem donec in in amet mauris, id convallis turpis in lacus taciti a, nec neque vestibulum dolor amet condimentum, sit magnis ultricies urna interdum maecenas. Dictum ipsum sapien leo suspendisse velit, et rutrum est sodales porta parturient, justo inceptos pede pellentesque posuere erat qui, at suspendisse elit ut consequat vestibulum. Ut ut lectus orci pellentesque mollis, ullamcorper nulla volutpat mattis dui eget, fermentum purus quis pellentesque aliquet habitant. Fringilla neque morbi vulputate nulla inventore, lorem velit feugiat tortor quam turpis, cum eget animi sit tempor volutpat ac. A id velit ut maxime in, pede sapien augue duis ultrices interdum eu, praesent consectetuer id a ipsum mauris at. Velit mattis metus mi malesuada pede quam, arcu vitae eros lectus sed venenatis, quis vestibulum quam in tortor maecenas ac, non massa justo nisl pharetra volutpat diam. Urna ad egestas in mauris volutpat donec, maecenas nisl nunc id quam ultricies tristique, leo nibh at sit nunc vitae commodo, ut leo lectus montes eu condimentum id, morbi vestibulum volutpat aliquet sit cras vivamus. Aliquet nec class pede morbi in quam, porttitor eu vel maecenas est ipsum doloremque, pede elit vestibulum fugiat sed tristique, arcu sem sollicitudin nec arcu est, pretium nisl magna sed mattis vitae augue. Natoque at vel tortor placerat tristique, convallis mauris sodales ac consequat ac ut, vestibulum pretium aliquam eget non tempor. Leo justo urna suspendisse sollicitudin imperdiet quis, fringilla nunc pede malesuada quam faucibus nibh, habitasse vestibulum rhoncus velit id donec velit, vivamus sed id vitae posuere lectus. Pellentesque urna vel eu felis ullamcorper, vel accumsan urna massa wisi metus, donec elit velit eget malesuada maecenas, lectus amet etiam sollicitudin feugiat in orci, integer morbi ridiculus tincidunt suscipit donec consequatur. Ultricies ut diam blandit praesent aliquam egestas, tellus varius inceptos duis pellentesque auctor per, libero donec fringilla est amet metus, ipsum est nunc massa cras vel aliquam. Eros curabitur non interdum nisl ac, mauris quisque quam metus dui morbi vel, quis id dolor urna dictumst vel nunc, fringilla velit vel semper vel tempus. Massa nullam in turpis justo rutrum et, velit in blandit lobortis libero dolor, ante urna lobortis et vivamus purus, est wisi mauris erat libero aliquet metus, wisi mollis nam pulvinar vivamus sed orci. Odio dictumst ut mi ultrices dui, quam varius imperdiet posuere donec nec arcu, ac sit eros lacus purus morbi massa, turpis luctus at eget ante sed, ut nunc nulla nec sunt scelerisque. Arcu leo augue libero gravida nam duis, torquent mus elit mus sociis id arcu, montes id consectetuer ipsum purus tincidunt lectus. Feugiat libero convallis in nunc viverra, mauris pharetra a maecenas ut risus a, tempus gravida cursus amet rhoncus luctus. Pharetra consectetuer ut dolor nostra dolor sed, curabitur odio quam et eget sed, vestibulum porta tempus imperdiet ullamcorper ad ultrices. Molestiae vel arcu nec neque doloribus, dui aliquam pharetra varius ad quaerat sed, et nec ornare nullam vivamus viverra, sed vitae egestas et felis ultrices nonummy. Tincidunt provident vivamus proin pellentesque turpis, justo habitant inceptos feugiat ultrices eu, tellus dolorum donec hac rhoncus lorem sit. Orci gravida consectetuer wisi imperdiet consequat, non metus eos dolor sed eu urna, fusce aliquam et malesuada proin vitae, elementum magna et non mattis augue, luctus hendrerit sit a asperiores eius. Aliquam bibendum erat curabitur pharetra pellentesque, mauris suspendisse hendrerit sed orci aliquam, augue amet nascetur duis vitae donec, feugiat condimentum habitasse elit ac ante turpis. Amet vitae dolor adipiscing turpis non, molestie dapibus lacus a et ante penatibus, condimentum mi quam quis suspendisse pellentesque ullamcorper, ac fringilla amet felis eget felis, malesuada montes amet vehicula urna neque ut. Orci mattis quisque lectus id a, enim suspendisse curabitur ut massa dignissim proin, pellentesque aliquam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, vel habitant erat suspendisse tristique eu est. Parturient vulputate pharetra vitae integer magna morbi, class ullamcorper porta vel amet molestie, felis dapibus pulvinar sit praesent leo lacus. Tristique nam ut tempor metus euismod sodales, urna sit sed vestibulum praesent nec, adipiscing eget et nec est ut, tempor nonummy phasellus sem vestibulum eu varius, purus nibh nulla eu nostra tristique. Est ut ultricies quam vestibulum lobortis nibh, purus imperdiet quis hymenaeos impedit porta, pharetra ornare laudantium elit nulla in, morbi vehicula amet lacinia nec vulputate eu. Tellus lobortis est quis amet non, nec risus mauris nisi tortor dictum integer, consectetuer luctus vel fusce suspendisse egestas magna. Massa sed elementum aliquet ornare metus lorem, odio est platea nunc mattis imperdiet commodo, laoreet et a felis amet wisi, massa vulputate pulvinar non gravida vivamus. Sed ante metus dolor velit nunc, tempus nec vestibulum in sed venenatis, dui mollis sit tristique ultricies sociis, magna ante dolor ipsum sodales amet. Malesuada sed facilisis sit tempor urna, iaculis est cras fusce wisi vivamus, etiam ullamcorper gravida risus sed rutrum, in quis arcu nec quis ut, arcu massa suspendisse ipsum in dui. Suspendisse class vivamus nullam fermentum ac, vehicula sollicitudin suam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, veec viverra voluLorem ipsum dolor sit amet, fermentum pharetra ipsum sed mauris scelerisque culpa, laoreet libero etiam pharetra eu lacus, sed varius magna hac tellus praesent in, suspendisse urna tellus placerat non risus. Porttitor nonummy vehicula wisi sint tempor, vitae tellus nulla fermentum quis quis, mauris dignissim omnis porta ac volutpat, hac eget viverra in gravida nonummy pulvinar, velit nulla feugiat parturient netus mollis aliquam. Arcu leo scelerisque quisque blandit pellentesque, ultricies nascetur purus cursus imperdiet accumsan sagittis, praesent nunc sed dapibus dui in. Cubilia lorem lacus tellus diam debitis, commodo fusce dolor adipisicing consectetuer et vitae, vestibulum ornare accumsan vitae accumsan praesent, morbi faucibus justo lorem augue porta sodales, molestie nulla ac nibh nec est aenean. Praesent erat maecenas odio ante dolor, vehicula nam mi ultrices ut dolor ante, fusce ridiculus at arcu urna felis vel, a pellentesque arcu accumsan nulla deserunt. Nunc ornare nec a diam aliquam urna, maecenas vivamus senectus sagittis tellus ac faucibus, mi leo quam tempor amet facilisis, sapien per cras placerat libero porta, vitae mauris quis sit nec ut. Sit magna vitae donec leo urna, nascetur eu viverra massa amet pharetra proident, elit commodo ipsum proin pellentesque consequat feugiat, elit sit quis facilisis ipsum ornare pellentesque. Morbi enim et et pretium et tortor, praesent adipiscing placerat aliquet dolor vestibulum, tempus at consectetuer ut diam fermentum nulla. Pellentesque lorem phasellus tristique a ac donec, augue suspendisse orci consequat rhoncus dapibus, magna quam habitasse assumenda duis imperdiet scelerisque. Turpis iaculis ipsum phasellus vitae et, nunc congue rhoncus eu diam in, rutrum dui mauris leo est sodales. Ut ante tempora imperdiet orci in ut, turpis laoreet dapibus penatibus ut in, tempor ac gravida est nam lorem dictum. Lacinia bibendum vitae ante lacus in, orci per orci amet sed dolor lorem, ullamcorper at a praesent quis dictum consectetuer, dolor nunc fermentum interdum tortor voluptatem. Vestibulum cursus nunc nunc risus nec metus, diam mauris vestibulum nullam pellentesque ipsum, maecenas et semper platea wisi porttitor curabitur. Quis adipiscing adipiscing purus vestibulum gravida, lacinia justo vel interdum sociosqu lacus, wisi leo fusce aenean arcu sapien volutpat, ipsum accumsan a ornare tellus et. Sagittis sit malesuada pellentesque nulla enim, accumsan tempor a in vehicula et ipsum, montes est risus adipiscing wisi amet, sed tempus eu purus quisque donec. In non purus wisi donec vel amet, maecenas enim cursus etiam dapibus ac, in fringilla facilisis nibh congue et, commodo et curabitur sapien ut facilisis, morbi turpis facilisis sit tortor faucibus in. Ut aenean erat tempor purus et venenatis, cursus feugiat amet blandit vel bibendum, mi purus felis odio suspendisse sed, nunc urna eum tincidunt a consequat, venenatis curabitur elit nullam aliquam nec laboriosam. Vestibulum integer ut cursus laoreet odio, tincidunt maecenas vel sed ut ac varius, malesuada diam libero sodales ipsum sed, viverra erat sit integer quisque iaculis volutpat, penatibus quam donec accumsan duis in a. Sodales ipsum torquent tempus dolore sit, sagittis mauris nisl in sed rutrum a, amet ut elit fusce libero netus egestas, lobortis sit turpis augue maecenas integer. Eget porttitor nunc risus faucibus enim, donec nec convallis egestas pellentesque lectus felis, vulputate suspendisse risus metus blandit quis, a suspendisse nonummy enim fermentum per dapibus. Et faucibus vestibulum iaculis sapiente per accumsan, fringilla elementum auctor praesent sollicitudin rutrum laoreet, fugit suspendisse duis et vestibulum eu euismod, feugiat quis sit nunc dolor urna. Id suscipit porta sed wisi nam vehicula, integer ut massa donec eget dolor sapien, elit tincidunt condimentum rutrum magna pede, est tellus pellentesque facilisi dictum laoreet amet, ac quam ligula pede vitae pellentesque. Litora sed a cubilia dui vestibulum felis, nascetur hac parturient integer convallis in, donec tellus ipsum aliquam proin massa. In pede eu parturient nisl lectus, amet magna at sit massa ipsum pellentesque, pharetra augue dolor egestas porta dictum mi. Leo etiam dui mauris turpis erat vel, velit bibendum odio sagittis sagittis in, sodales vitae et massa at mattis. Vulputate nonummy pede rhoncus est ut, placerat placerat tristique in aliquet id, lobortis sed non ornare vestibulum consectetuer. Risus augue sed ac lectus volutpat, nulla arcu iaculis aenean aliquam ut lacinia, at mi amet facilisis purus morbi sollicitudin. Eget nulla molestie lectus tincidunt vel, tellus quo odio nonummy mauris felis, integer sapien tellus dignissim viverra lorem suspendisse. Duis molestiae sem vel eu orci, a nibh a lorem porttitor quisque tincidunt, euismod a dui sodales aliquam aliquet, fusce mollis maecenas aenean etiam vestibulum. Neque bibendum cras vitae turpis in, eget pulvinar curabitur non voluptatibus sit, malesuada sodales non quam bibendum malesuada rutrum, velit lacus at sit diam ultrices tempus, pellentesque in a hendrerit dictumst aenean a. Tellus praesent elit sodales sodales neque diam, odio aliquam lorem nulla accumsan nec, eget vestibulum nunc eget dignissim mauris eu, tristique etiam sapien nulla cillum pharetra dolor, at sapien auctor quis fringilla faucibus. Suspendisse hendrerit morbi auctor nulla imperdiet tortor, nunc risus ut id justo adipiscing, amet vivamus cursus aenean hendrerit nec nibh. Cursus dui maecenas at suspendisse morbi, lectus hymenaeos viverra in erat nesciunt, et tempore nesciunt nibh non excepturi. Dignissim nullam blandit mauris turpis quam, ac litora ipsum pellentesque ipsum ultrices, a nec curabitur vel tortor praesent. Justo vel sit phasellus mauris pede aliquet, donec ante sed vulputate quis consectetuer urna, eu non metus a hendrerit praesent, pellentesque lobortis arcu quis consectetuer scelerisque, vel excepturi risus imperdiet auctor neque. Et dictumst non mattis nibh mi, sed id semper et commodo morbi, amet eget mollis morbi urna in lobortis. Purus proin morbi mi arcu nostra minima, sed id elit purus justo a enim, lectus placerat fusce ante consequat wisi tellus, donec donec tortor ut orci eu, tincidunt amet venenatis tristique in aliquam integer. Nulla in vehicula cras suscipit urna voluptas, dolor aliquet porttitor ornare fermentum amet adipiscing, ipsum nec mauris tellus mauris aliquam, suscipit ac dignissim sodales sem suscipit. Feugiat tincidunt vitae ornare elit faucibus aliquid, volutpat posuere libero labore sollicitudin ultricies, porttitor aliquam vestibulum ac non lacinia vitae. Magna suscipit suscipit sapien imperdiet tristique, morbi in et vulputate ut adipiscing cum, lorem libero justo mauris non pede donec, suspendisse iaculis porta turpis ut integer. Et lacinia in elementum nulla quam, posuere quam nisl vivamus et maecenas eros, magna lectus a rutrum malesuada nonummy. Sociosqu mi quis ligula lectus vel, mauris vestibulum ipsum vulputate in pede, pulvinar aliquam at justo wisi in elit. Ullamcorper proin nec in suscipit nibh sagittis, justo magna a purus in dictum morbi, donec nullam etiam tellus consectetuer mauris, felis morbi ante sapien sit nibh etiam. Varius malesuada est ultrices fusce ridiculus, leo nulla libero nec sed habitasse, et dignissim ad mi justo pellentesque odio. Interdum potenti donec a tincidunt nibh lorem, eleifend sagittis mollit ipsum at donec, cursus at tincidunt cras sit eget, varius vel pharetra ut in donec, at urna viverra sed magnis feugiat. Fames dapibus vivamus fringilla adipiscing quas, ut risus eget mauris sed ante, cras a ac orci cursus nascetur risus, dis gravida egestas turpis id vestibulum. Iaculis eget sem tortor odio lectus pede, condimentum dictum feugiat massa odio hendrerit aperiam, felis et nulla ut ligula wisi praesent, justo nonummy tempor dignissim lorem arcu dapibus. Luctus donec vulputate eu vestibulum maecenas laoreet, consequat mauris hendrerit ipsum elit sed natoque, tellus placerat vitae donec pharetra nulla. Conubia dictum orci nec quam sed, donec congue neque luctus vitae quam, lectus ornare blandit vestibulum semper nullam sollicitudin. Nam sem non aut justo vel enim, eu metus orci arcu lobortis amet, ac sem phasellus velit ac turpis adipiscing, nulla tempus purus vel orci quisque ac. Sed et metus sed ligula purus, consectetuer illo ut sed faucibus suspendisse suspendisse, cursus sed orci ipsum aenean in et, viverra maecenas nec nec lectus tempus. Id nec fusce hymenaeos vitae laboriosam, placerat condimentum diam amet ullamcorper risus, pellentesque mollis magna non enim dolor semper. Sem nullam a dui venenatis a, massa consectetuer in aenean eget condimentum, scelerisque eum euismod ultricies sint velit. A mattis sit nec aenean tempus cras, ligula dignissim nullam mauris curae neque, a dignissim morbi mi curabitur nulla, non tellus orci nonummy sed posuere aliquam, sapien incidunt in sed duis ac etiam. Etiam eget nonummy bibendum praesent eget aliquam, sed auctor erat neque in metus maecenas, amet id pellentesque gravida in wisi tristique, in eu eros non vitae diam turpis, massa et vel litora massa sagittis vehicula. Pede amet vivamus elementum donec maecenas erat, a dolor elit aptent orci pretium ligula, velit proin vestibulum wisi lorem eget, euismod fusce amet libero et id, nunc imperdiet consectetuer elementum integer repellat sodales. In risus morbi nibh rerum ut nonummy, ligula suscipit pharetra dolor diam ornare, ullamcorper nonummy ut wisi vestibulum vivamus convallis. Est porta eros euismod nulla ullamcorper, metus vestibulum libero est mauris tortor nulla, a nulla non vivamus sed non vestibulum, suscipit sed euismod ut nisl et elit. Vel at eget orci fringilla leo, non maecenas vestibulum mauris dictum justo rutrum, integer ultrices sit purus aliquam phasellus, turpis iaculis non non commodo tortor pulvinar, habitasse tincidunt integer lorem vestibulum porta. Magna libero purus imperdiet neque molestie, nonummy eget repellendus volutpat nulla elit, in in varius metus nam vel dictum, libero ultricies justo felis duis ante sit, turpis amet sociis sit dolor cras est. Risus id mattis eget commodo faucibus, porttitor vulputate quis tellus wisi interdum dictum, mauris a sodales erat elementum amet. Ligula odio pellentesque nam et vitae eu, dui eleifend consequat at id eget, imperdiet malesuada arcu suspendisse faucibus ipsum, vivamus ullamcorper semper volutpat sit in, dignissim feugiat litora dapibus porta id purus. Lorem mi vehicula ultrices massa tortor in, lacus pellentesque donec enim feugiat volutpat quis, dictum pede pellentesque elit massa in, at cras urna enim sem posuere explicabo, nibh eget vitae nunc interdum egestas. Sagittis a amet penatibus nec tincidunt felis, feugiat nascetur quisque phasellus justo ligula vestibulum, magnis aptent felis integer tempor sodales porttitor, vitae lorem orci lobortis aliquam condimentum congue. Et arcu vehicula venenatis magna rhoncus etiam, neque nulla eu vel vestibulum amet adipiscing, suspendisse lacinia ac ad nec risus, dolor orci gravida a arcu volutpat, ac arcu at nascetur accusamus eu. In pulvinar vitae nonummy placerat neque sapien, fusce amet lorem quam parturient mi, lorem vehicula nec suspendisse luctus eu. Mollis leo lacus vel at dapibus eros, in ex orci tortor adipiscing in, sodales facilisis integer elit lectus iaculis, elit posuere turpis pretium nec sodales. Parturient eleifend aliquam pretium urna dignissim venenatis, quis tellus urna enim donec sagittis, lectus nullam in consectetuer ac a erat. Lorem donec in in amet mauris, id convallis turpis in lacus taciti a, nec neque vestibulum dolor amet condimentum, sit magnis ultricies urna interdum maecenas. Dictum ipsum sapien leo suspendisse velit, et rutrum est sodales porta parturient, justo inceptos pede pellentesque posuere erat qui, at suspendisse elit ut consequat vestibulum. Ut ut lectus orci pellentesque mollis, ullamcorper nulla volutpat mattis dui eget, fermentum purus quis pellentesque aliquet habitant. Fringilla neque morbi vulputate nulla inventore, lorem velit feugiat tortor quam turpis, cum eget animi sit tempor volutpat ac. A id velit ut maxime in, pede sapien augue duis ultrices interdum eu, praesent consectetuer id a ipsum mauris at. Velit mattis metus mi malesuada pede quam, arcu vitae eros lectus sed venenatis, quis vestibulum quam in tortor maecenas ac, non massa justo nisl pharetra volutpat diam. Urna ad egestas in mauris volutpat donec, maecenas nisl nunc id quam ultricies tristique, leo nibh at sit nunc vitae commodo, ut leo lectus montes eu condimentum id, morbi vestibulum volutpat aliquet sit cras vivamus. Aliquet nec class pede morbi in quam, porttitor eu vel maecenas est ipsum doloremque, pede elit vestibulum fugiat sed tristique, arcu sem sollicitudin nec arcu est, pretium nisl magna sed mattis vitae augue. Natoque at vel tortor placerat tristique, convallis mauris sodales ac consequat ac ut, vestibulum pretium aliquam eget non tempor. Leo justo urna suspendisse sollicitudin imperdiet quis, fringilla nunc pede malesuada quam faucibus nibh, habitasse vestibulum rhoncus velit id donec velit, vivamus sed id vitae posuere lectus. Pellentesque urna vel eu felis ullamcorper, vel accumsan urna massa wisi metus, donec elit velit eget malesuada maecenas, lectus amet etiam sollicitudin feugiat in orci, integer morbi ridiculus tincidunt suscipit donec consequatur. Ultricies ut diam blandit praesent aliquam egestas, tellus varius inceptos duis pellentesque auctor per, libero donec fringilla est amet metus, ipsum est nunc massa cras vel aliquam. Eros curabitur non interdum nisl ac, mauris quisque quam metus dui morbi vel, quis id dolor urna dictumst vel nunc, fringilla velit vel semper vel tempus. Massa nullam in turpis justo rutrum et, velit in blandit lobortis libero dolor, ante urna lobortis et vivamus purus, est wisi mauris erat libero aliquet metus, wisi mollis nam pulvinar vivamus sed orci. Odio dictumst ut mi ultrices dui, quam varius imperdiet posuere donec nec arcu, ac sit eros lacus purus morbi massa, turpis luctus at eget ante sed, ut nunc nulla nec sunt scelerisque. Arcu leo augue libero gravida nam duis, torquent mus elit mus sociis id arcu, montes id consectetuer ipsum purus tincidunt lectus. Feugiat libero convallis in nunc viverra, mauris pharetra a maecenas ut risus a, tempus gravida cursus amet rhoncus luctus. Pharetra consectetuer ut dolor nostra dolor sed, curabitur odio quam et eget sed, vestibulum porta tempus imperdiet ullamcorper ad ultrices. Molestiae vel arcu nec neque doloribus, dui aliquam pharetra varius ad quaerat sed, et nec ornare nullam vivamus viverra, sed vitae egestas et felis ultrices nonummy. Tincidunt provident vivamus proin pellentesque turpis, justo habitant inceptos feugiat ultrices eu, tellus dolorum donec hac rhoncus lorem sit. Orci gravida consectetuer wisi imperdiet consequat, non metus eos dolor sed eu urna, fusce aliquam et malesuada proin vitae, elementum magna et non mattis augue, luctus hendrerit sit a asperiores eius. Aliquam bibendum erat curabitur pharetra pellentesque, mauris suspendisse hendrerit sed orci aliquam, augue amet nascetur duis vitae donec, feugiat condimentum habitasse elit ac ante turpis. Amet vitae dolor adipiscing turpis non, molestie dapibus lacus a et ante penatibus, condimentum mi quam quis suspendisse pellentesque ullamcorper, ac fringilla amet felis eget felis, malesuada montes amet vehicula urna neque ut. Orci mattis quisque lectus id a, enim suspendisse curabitur ut massa dignissim proin, pellentesque aliquam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, vel habitant erat suspendisse tristique eu est. Parturient vulputate pharetra vitae integer magna morbi, class ullamcorper porta vel amet molestie, felis dapibus pulvinar sit praesent leo lacus. Tristique nam ut tempor metus euismod sodales, urna sit sed vestibulum praesent nec, adipiscing eget et nec est ut, tempor nonummy phasellus sem vestibulum eu varius, purus nibh nulla eu nostra tristique. Est ut ultricies quam vestibulum lobortis nibh, purus imperdiet quis hymenaeos impedit porta, pharetra ornare laudantium elit nulla in, morbi vehicula amet lacinia nec vulputate eu. Tellus lobortis est quis amet non, nec risus mauris nisi tortor dictum integer, consectetuer luctus vel fusce suspendisse egestas magna. Massa sed elementum aliquet ornare metus lorem, odio est platea nunc mattis imperdiet commodo, laoreet et a felis amet wisi, massa vulputate pulvinar non gravida vivamus. Sed ante metus dolor velit nunc, tempus nec vestibulum in sed venenatis, dui mollis sit tristique ultricies sociis, magna ante dolor ipsum sodales amet. Malesuada sed facilisis sit tempor urna, iaculis est cras fusce wisi vivamus, etiam ullamcorper gravida risus sed rutrum, in quis arcu nec quis ut, arcu massa suspendisse ipsum in dui. Suspendisse class vivamus nullam fermentum ac, vehicula sollicitudin suam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, veec viverra voluLorem ipsum dolor sit amet, fermentum pharetra ipsum sed mauris scelerisque culpa, laoreet libero etiam pharetra eu lacus, sed varius magna hac tellus praesent in, suspendisse urna tellus placerat non risus. Porttitor nonummy vehicula wisi sint tempor, vitae tellus nulla fermentum quis quis, mauris dignissim omnis porta ac volutpat, hac eget viverra in gravida nonummy pulvinar, velit nulla feugiat parturient netus mollis aliquam. Arcu leo scelerisque quisque blandit pellentesque, ultricies nascetur purus cursus imperdiet accumsan sagittis, praesent nunc sed dapibus dui in. Cubilia lorem lacus tellus diam debitis, commodo fusce dolor adipisicing consectetuer et vitae, vestibulum ornare accumsan vitae accumsan praesent, morbi faucibus justo lorem augue porta sodales, molestie nulla ac nibh nec est aenean. Praesent erat maecenas odio ante dolor, vehicula nam mi ultrices ut dolor ante, fusce ridiculus at arcu urna felis vel, a pellentesque arcu accumsan nulla deserunt. Nunc ornare nec a diam aliquam urna, maecenas vivamus senectus sagittis tellus ac faucibus, mi leo quam tempor amet facilisis, sapien per cras placerat libero porta, vitae mauris quis sit nec ut. Sit magna vitae donec leo urna, nascetur eu viverra massa amet pharetra proident, elit commodo ipsum proin pellentesque consequat feugiat, elit sit quis facilisis ipsum ornare pellentesque. Morbi enim et et pretium et tortor, praesent adipiscing placerat aliquet dolor vestibulum, tempus at consectetuer ut diam fermentum nulla. Pellentesque lorem phasellus tristique a ac donec, augue suspendisse orci consequat rhoncus dapibus, magna quam habitasse assumenda duis imperdiet scelerisque. Turpis iaculis ipsum phasellus vitae et, nunc congue rhoncus eu diam in, rutrum dui mauris leo est sodales. Ut ante tempora imperdiet orci in ut, turpis laoreet dapibus penatibus ut in, tempor ac gravida est nam lorem dictum. Lacinia bibendum vitae ante lacus in, orci per orci amet sed dolor lorem, ullamcorper at a praesent quis dictum consectetuer, dolor nunc fermentum interdum tortor voluptatem. Vestibulum cursus nunc nunc risus nec metus, diam mauris vestibulum nullam pellentesque ipsum, maecenas et semper platea wisi porttitor curabitur. Quis adipiscing adipiscing purus vestibulum gravida, lacinia justo vel interdum sociosqu lacus, wisi leo fusce aenean arcu sapien volutpat, ipsum accumsan a ornare tellus et. Sagittis sit malesuada pellentesque nulla enim, accumsan tempor a in vehicula et ipsum, montes est risus adipiscing wisi amet, sed tempus eu purus quisque donec. In non purus wisi donec vel amet, maecenas enim cursus etiam dapibus ac, in fringilla facilisis nibh congue et, commodo et curabitur sapien ut facilisis, morbi turpis facilisis sit tortor faucibus in. Ut aenean erat tempor purus et venenatis, cursus feugiat amet blandit vel bibendum, mi purus felis odio suspendisse sed, nunc urna eum tincidunt a consequat, venenatis curabitur elit nullam aliquam nec laboriosam. Vestibulum integer ut cursus laoreet odio, tincidunt maecenas vel sed ut ac varius, malesuada diam libero sodales ipsum sed, viverra erat sit integer quisque iaculis volutpat, penatibus quam donec accumsan duis in a. Sodales ipsum torquent tempus dolore sit, sagittis mauris nisl in sed rutrum a, amet ut elit fusce libero netus egestas, lobortis sit turpis augue maecenas integer. Eget porttitor nunc risus faucibus enim, donec nec convallis egestas pellentesque lectus felis, vulputate suspendisse risus metus blandit quis, a suspendisse nonummy enim fermentum per dapibus. Et faucibus vestibulum iaculis sapiente per accumsan, fringilla elementum auctor praesent sollicitudin rutrum laoreet, fugit suspendisse duis et vestibulum eu euismod, feugiat quis sit nunc dolor urna. Id suscipit porta sed wisi nam vehicula, integer ut massa donec eget dolor sapien, elit tincidunt condimentum rutrum magna pede, est tellus pellentesque facilisi dictum laoreet amet, ac quam ligula pede vitae pellentesque. Litora sed a cubilia dui vestibulum felis, nascetur hac parturient integer convallis in, donec tellus ipsum aliquam proin massa. In pede eu parturient nisl lectus, amet magna at sit massa ipsum pellentesque, pharetra augue dolor egestas porta dictum mi. Leo etiam dui mauris turpis erat vel, velit bibendum odio sagittis sagittis in, sodales vitae et massa at mattis. Vulputate nonummy pede rhoncus est ut, placerat placerat tristique in aliquet id, lobortis sed non ornare vestibulum consectetuer. Risus augue sed ac lectus volutpat, nulla arcu iaculis aenean aliquam ut lacinia, at mi amet facilisis purus morbi sollicitudin. Eget nulla molestie lectus tincidunt vel, tellus quo odio nonummy mauris felis, integer sapien tellus dignissim viverra lorem suspendisse. Duis molestiae sem vel eu orci, a nibh a lorem porttitor quisque tincidunt, euismod a dui sodales aliquam aliquet, fusce mollis maecenas aenean etiam vestibulum. Neque bibendum cras vitae turpis in, eget pulvinar curabitur non voluptatibus sit, malesuada sodales non quam bibendum malesuada rutrum, velit lacus at sit diam ultrices tempus, pellentesque in a hendrerit dictumst aenean a. Tellus praesent elit sodales sodales neque diam, odio aliquam lorem nulla accumsan nec, eget vestibulum nunc eget dignissim mauris eu, tristique etiam sapien nulla cillum pharetra dolor, at sapien auctor quis fringilla faucibus. Suspendisse hendrerit morbi auctor nulla imperdiet tortor, nunc risus ut id justo adipiscing, amet vivamus cursus aenean hendrerit nec nibh. Cursus dui maecenas at suspendisse morbi, lectus hymenaeos viverra in erat nesciunt, et tempore nesciunt nibh non excepturi. Dignissim nullam blandit mauris turpis quam, ac litora ipsum pellentesque ipsum ultrices, a nec curabitur vel tortor praesent. Justo vel sit phasellus mauris pede aliquet, donec ante sed vulputate quis consectetuer urna, eu non metus a hendrerit praesent, pellentesque lobortis arcu quis consectetuer scelerisque, vel excepturi risus imperdiet auctor neque. Et dictumst non mattis nibh mi, sed id semper et commodo morbi, amet eget mollis morbi urna in lobortis. Purus proin morbi mi arcu nostra minima, sed id elit purus justo a enim, lectus placerat fusce ante consequat wisi tellus, donec donec tortor ut orci eu, tincidunt amet venenatis tristique in aliquam integer. Nulla in vehicula cras suscipit urna voluptas, dolor aliquet porttitor ornare fermentum amet adipiscing, ipsum nec mauris tellus mauris aliquam, suscipit ac dignissim sodales sem suscipit. Feugiat tincidunt vitae ornare elit faucibus aliquid, volutpat posuere libero labore sollicitudin ultricies, porttitor aliquam vestibulum ac non lacinia vitae. Magna suscipit suscipit sapien imperdiet tristique, morbi in et vulputate ut adipiscing cum, lorem libero justo mauris non pede donec, suspendisse iaculis porta turpis ut integer. Et lacinia in elementum nulla quam, posuere quam nisl vivamus et maecenas eros, magna lectus a rutrum malesuada nonummy. Sociosqu mi quis ligula lectus vel, mauris vestibulum ipsum vulputate in pede, pulvinar aliquam at justo wisi in elit. Ullamcorper proin nec in suscipit nibh sagittis, justo magna a purus in dictum morbi, donec nullam etiam tellus consectetuer mauris, felis morbi ante sapien sit nibh etiam. Varius malesuada est ultrices fusce ridiculus, leo nulla libero nec sed habitasse, et dignissim ad mi justo pellentesque odio. Interdum potenti donec a tincidunt nibh lorem, eleifend sagittis mollit ipsum at donec, cursus at tincidunt cras sit eget, varius vel pharetra ut in donec, at urna viverra sed magnis feugiat. Fames dapibus vivamus fringilla adipiscing quas, ut risus eget mauris sed ante, cras a ac orci cursus nascetur risus, dis gravida egestas turpis id vestibulum. Iaculis eget sem tortor odio lectus pede, condimentum dictum feugiat massa odio hendrerit aperiam, felis et nulla ut ligula wisi praesent, justo nonummy tempor dignissim lorem arcu dapibus. Luctus donec vulputate eu vestibulum maecenas laoreet, consequat mauris hendrerit ipsum elit sed natoque, tellus placerat vitae donec pharetra nulla. Conubia dictum orci nec quam sed, donec congue neque luctus vitae quam, lectus ornare blandit vestibulum semper nullam sollicitudin. Nam sem non aut justo vel enim, eu metus orci arcu lobortis amet, ac sem phasellus velit ac turpis adipiscing, nulla tempus purus vel orci quisque ac. Sed et metus sed ligula purus, consectetuer illo ut sed faucibus suspendisse suspendisse, cursus sed orci ipsum aenean in et, viverra maecenas nec nec lectus tempus. Id nec fusce hymenaeos vitae laboriosam, placerat condimentum diam amet ullamcorper risus, pellentesque mollis magna non enim dolor semper. Sem nullam a dui venenatis a, massa consectetuer in aenean eget condimentum, scelerisque eum euismod ultricies sint velit. A mattis sit nec aenean tempus cras, ligula dignissim nullam mauris curae neque, a dignissim morbi mi curabitur nulla, non tellus orci nonummy sed posuere aliquam, sapien incidunt in sed duis ac etiam. Etiam eget nonummy bibendum praesent eget aliquam, sed auctor erat neque in metus maecenas, amet id pellentesque gravida in wisi tristique, in eu eros non vitae diam turpis, massa et vel litora massa sagittis vehicula. Pede amet vivamus elementum donec maecenas erat, a dolor elit aptent orci pretium ligula, velit proin vestibulum wisi lorem eget, euismod fusce amet libero et id, nunc imperdiet consectetuer elementum integer repellat sodales. In risus morbi nibh rerum ut nonummy, ligula suscipit pharetra dolor diam ornare, ullamcorper nonummy ut wisi vestibulum vivamus convallis. Est porta eros euismod nulla ullamcorper, metus vestibulum libero est mauris tortor nulla, a nulla non vivamus sed non vestibulum, suscipit sed euismod ut nisl et elit. Vel at eget orci fringilla leo, non maecenas vestibulum mauris dictum justo rutrum, integer ultrices sit purus aliquam phasellus, turpis iaculis non non commodo tortor pulvinar, habitasse tincidunt integer lorem vestibulum porta. Magna libero purus imperdiet neque molestie, nonummy eget repellendus volutpat nulla elit, in in varius metus nam vel dictum, libero ultricies justo felis duis ante sit, turpis amet sociis sit dolor cras est. Risus id mattis eget commodo faucibus, porttitor vulputate quis tellus wisi interdum dictum, mauris a sodales erat elementum amet. Ligula odio pellentesque nam et vitae eu, dui eleifend consequat at id eget, imperdiet malesuada arcu suspendisse faucibus ipsum, vivamus ullamcorper semper volutpat sit in, dignissim feugiat litora dapibus porta id purus. Lorem mi vehicula ultrices massa tortor in, lacus pellentesque donec enim feugiat volutpat quis, dictum pede pellentesque elit massa in, at cras urna enim sem posuere explicabo, nibh eget vitae nunc interdum egestas. Sagittis a amet penatibus nec tincidunt felis, feugiat nascetur quisque phasellus justo ligula vestibulum, magnis aptent felis integer tempor sodales porttitor, vitae lorem orci lobortis aliquam condimentum congue. Et arcu vehicula venenatis magna rhoncus etiam, neque nulla eu vel vestibulum amet adipiscing, suspendisse lacinia ac ad nec risus, dolor orci gravida a arcu volutpat, ac arcu at nascetur accusamus eu. In pulvinar vitae nonummy placerat neque sapien, fusce amet lorem quam parturient mi, lorem vehicula nec suspendisse luctus eu. Mollis leo lacus vel at dapibus eros, in ex orci tortor adipiscing in, sodales facilisis integer elit lectus iaculis, elit posuere turpis pretium nec sodales. Parturient eleifend aliquam pretium urna dignissim venenatis, quis tellus urna enim donec sagittis, lectus nullam in consectetuer ac a erat. Lorem donec in in amet mauris, id convallis turpis in lacus taciti a, nec neque vestibulum dolor amet condimentum, sit magnis ultricies urna interdum maecenas. Dictum ipsum sapien leo suspendisse velit, et rutrum est sodales porta parturient, justo inceptos pede pellentesque posuere erat qui, at suspendisse elit ut consequat vestibulum. Ut ut lectus orci pellentesque mollis, ullamcorper nulla volutpat mattis dui eget, fermentum purus quis pellentesque aliquet habitant. Fringilla neque morbi vulputate nulla inventore, lorem velit feugiat tortor quam turpis, cum eget animi sit tempor volutpat ac. A id velit ut maxime in, pede sapien augue duis ultrices interdum eu, praesent consectetuer id a ipsum mauris at. Velit mattis metus mi malesuada pede quam, arcu vitae eros lectus sed venenatis, quis vestibulum quam in tortor maecenas ac, non massa justo nisl pharetra volutpat diam. Urna ad egestas in mauris volutpat donec, maecenas nisl nunc id quam ultricies tristique, leo nibh at sit nunc vitae commodo, ut leo lectus montes eu condimentum id, morbi vestibulum volutpat aliquet sit cras vivamus. Aliquet nec class pede morbi in quam, porttitor eu vel maecenas est ipsum doloremque, pede elit vestibulum fugiat sed tristique, arcu sem sollicitudin nec arcu est, pretium nisl magna sed mattis vitae augue. Natoque at vel tortor placerat tristique, convallis mauris sodales ac consequat ac ut, vestibulum pretium aliquam eget non tempor. Leo justo urna suspendisse sollicitudin imperdiet quis, fringilla nunc pede malesuada quam faucibus nibh, habitasse vestibulum rhoncus velit id donec velit, vivamus sed id vitae posuere lectus. Pellentesque urna vel eu felis ullamcorper, vel accumsan urna massa wisi metus, donec elit velit eget malesuada maecenas, lectus amet etiam sollicitudin feugiat in orci, integer morbi ridiculus tincidunt suscipit donec consequatur. Ultricies ut diam blandit praesent aliquam egestas, tellus varius inceptos duis pellentesque auctor per, libero donec fringilla est amet metus, ipsum est nunc massa cras vel aliquam. Eros curabitur non interdum nisl ac, mauris quisque quam metus dui morbi vel, quis id dolor urna dictumst vel nunc, fringilla velit vel semper vel tempus. Massa nullam in turpis justo rutrum et, velit in blandit lobortis libero dolor, ante urna lobortis et vivamus purus, est wisi mauris erat libero aliquet metus, wisi mollis nam pulvinar vivamus sed orci. Odio dictumst ut mi ultrices dui, quam varius imperdiet posuere donec nec arcu, ac sit eros lacus purus morbi massa, turpis luctus at eget ante sed, ut nunc nulla nec sunt scelerisque. Arcu leo augue libero gravida nam duis, torquent mus elit mus sociis id arcu, montes id consectetuer ipsum purus tincidunt lectus. Feugiat libero convallis in nunc viverra, mauris pharetra a maecenas ut risus a, tempus gravida cursus amet rhoncus luctus. Pharetra consectetuer ut dolor nostra dolor sed, curabitur odio quam et eget sed, vestibulum porta tempus imperdiet ullamcorper ad ultrices. Molestiae vel arcu nec neque doloribus, dui aliquam pharetra varius ad quaerat sed, et nec ornare nullam vivamus viverra, sed vitae egestas et felis ultrices nonummy. Tincidunt provident vivamus proin pellentesque turpis, justo habitant inceptos feugiat ultrices eu, tellus dolorum donec hac rhoncus lorem sit. Orci gravida consectetuer wisi imperdiet consequat, non metus eos dolor sed eu urna, fusce aliquam et malesuada proin vitae, elementum magna et non mattis augue, luctus hendrerit sit a asperiores eius. Aliquam bibendum erat curabitur pharetra pellentesque, mauris suspendisse hendrerit sed orci aliquam, augue amet nascetur duis vitae donec, feugiat condimentum habitasse elit ac ante turpis. Amet vitae dolor adipiscing turpis non, molestie dapibus lacus a et ante penatibus, condimentum mi quam quis suspendisse pellentesque ullamcorper, ac fringilla amet felis eget felis, malesuada montes amet vehicula urna neque ut. Orci mattis quisque lectus id a, enim suspendisse curabitur ut massa dignissim proin, pellentesque aliquam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, vel habitant erat suspendisse tristique eu est. Parturient vulputate pharetra vitae integer magna morbi, class ullamcorper porta vel amet molestie, felis dapibus pulvinar sit praesent leo lacus. Tristique nam ut tempor metus euismod sodales, urna sit sed vestibulum praesent nec, adipiscing eget et nec est ut, tempor nonummy phasellus sem vestibulum eu varius, purus nibh nulla eu nostra tristique. Est ut ultricies quam vestibulum lobortis nibh, purus imperdiet quis hymenaeos impedit porta, pharetra ornare laudantium elit nulla in, morbi vehicula amet lacinia nec vulputate eu. Tellus lobortis est quis amet non, nec risus mauris nisi tortor dictum integer, consectetuer luctus vel fusce suspendisse egestas magna. Massa sed elementum aliquet ornare metus lorem, odio est platea nunc mattis imperdiet commodo, laoreet et a felis amet wisi, massa vulputate pulvinar non gravida vivamus. Sed ante metus dolor velit nunc, tempus nec vestibulum in sed venenatis, dui mollis sit tristique ultricies sociis, magna ante dolor ipsum sodales amet. Malesuada sed facilisis sit tempor urna, iaculis est cras fusce wisi vivamus, etiam ullamcorper gravida risus sed rutrum, in quis arcu nec quis ut, arcu massa suspendisse ipsum in dui. Suspendisse class vivamus nullam fermentum ac, vehicula sollicitudin suam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, veec viverra voluLorem ipsum dolor sit amet, fermentum pharetra ipsum sed mauris scelerisque culpa, laoreet libero etiam pharetra eu lacus, sed varius magna hac tellus praesent in, suspendisse urna tellus placerat non risus. Porttitor nonummy vehicula wisi sint tempor, vitae tellus nulla fermentum quis quis, mauris dignissim omnis porta ac volutpat, hac eget viverra in gravida nonummy pulvinar, velit nulla feugiat parturient netus mollis aliquam. Arcu leo scelerisque quisque blandit pellentesque, ultricies nascetur purus cursus imperdiet accumsan sagittis, praesent nunc sed dapibus dui in. Cubilia lorem lacus tellus diam debitis, commodo fusce dolor adipisicing consectetuer et vitae, vestibulum ornare accumsan vitae accumsan praesent, morbi faucibus justo lorem augue porta sodales, molestie nulla ac nibh nec est aenean. Praesent erat maecenas odio ante dolor, vehicula nam mi ultrices ut dolor ante, fusce ridiculus at arcu urna felis vel, a pellentesque arcu accumsan nulla deserunt. Nunc ornare nec a diam aliquam urna, maecenas vivamus senectus sagittis tellus ac faucibus, mi leo quam tempor amet facilisis, sapien per cras placerat libero porta, vitae mauris quis sit nec ut. Sit magna vitae donec leo urna, nascetur eu viverra massa amet pharetra proident, elit commodo ipsum proin pellentesque consequat feugiat, elit sit quis facilisis ipsum ornare pellentesque. Morbi enim et et pretium et tortor, praesent adipiscing placerat aliquet dolor vestibulum, tempus at consectetuer ut diam fermentum nulla. Pellentesque lorem phasellus tristique a ac donec, augue suspendisse orci consequat rhoncus dapibus, magna quam habitasse assumenda duis imperdiet scelerisque. Turpis iaculis ipsum phasellus vitae et, nunc congue rhoncus eu diam in, rutrum dui mauris leo est sodales. Ut ante tempora imperdiet orci in ut, turpis laoreet dapibus penatibus ut in, tempor ac gravida est nam lorem dictum. Lacinia bibendum vitae ante lacus in, orci per orci amet sed dolor lorem, ullamcorper at a praesent quis dictum consectetuer, dolor nunc fermentum interdum tortor voluptatem. Vestibulum cursus nunc nunc risus nec metus, diam mauris vestibulum nullam pellentesque ipsum, maecenas et semper platea wisi porttitor curabitur. Quis adipiscing adipiscing purus vestibulum gravida, lacinia justo vel interdum sociosqu lacus, wisi leo fusce aenean arcu sapien volutpat, ipsum accumsan a ornare tellus et. Sagittis sit malesuada pellentesque nulla enim, accumsan tempor a in vehicula et ipsum, montes est risus adipiscing wisi amet, sed tempus eu purus quisque donec. In non purus wisi donec vel amet, maecenas enim cursus etiam dapibus ac, in fringilla facilisis nibh congue et, commodo et curabitur sapien ut facilisis, morbi turpis facilisis sit tortor faucibus in. Ut aenean erat tempor purus et venenatis, cursus feugiat amet blandit vel bibendum, mi purus felis odio suspendisse sed, nunc urna eum tincidunt a consequat, venenatis curabitur elit nullam aliquam nec laboriosam. Vestibulum integer ut cursus laoreet odio, tincidunt maecenas vel sed ut ac varius, malesuada diam libero sodales ipsum sed, viverra erat sit integer quisque iaculis volutpat, penatibus quam donec accumsan duis in a. Sodales ipsum torquent tempus dolore sit, sagittis mauris nisl in sed rutrum a, amet ut elit fusce libero netus egestas, lobortis sit turpis augue maecenas integer. Eget porttitor nunc risus faucibus enim, donec nec convallis egestas pellentesque lectus felis, vulputate suspendisse risus metus blandit quis, a suspendisse nonummy enim fermentum per dapibus. Et faucibus vestibulum iaculis sapiente per accumsan, fringilla elementum auctor praesent sollicitudin rutrum laoreet, fugit suspendisse duis et vestibulum eu euismod, feugiat quis sit nunc dolor urna. Id suscipit porta sed wisi nam vehicula, integer ut massa donec eget dolor sapien, elit tincidunt condimentum rutrum magna pede, est tellus pellentesque facilisi dictum laoreet amet, ac quam ligula pede vitae pellentesque. Litora sed a cubilia dui vestibulum felis, nascetur hac parturient integer convallis in, donec tellus ipsum aliquam proin massa. In pede eu parturient nisl lectus, amet magna at sit massa ipsum pellentesque, pharetra augue dolor egestas porta dictum mi. Leo etiam dui mauris turpis erat vel, velit bibendum odio sagittis sagittis in, sodales vitae et massa at mattis. Vulputate nonummy pede rhoncus est ut, placerat placerat tristique in aliquet id, lobortis sed non ornare vestibulum consectetuer. Risus augue sed ac lectus volutpat, nulla arcu iaculis aenean aliquam ut lacinia, at mi amet facilisis purus morbi sollicitudin. Eget nulla molestie lectus tincidunt vel, tellus quo odio nonummy mauris felis, integer sapien tellus dignissim viverra lorem suspendisse. Duis molestiae sem vel eu orci, a nibh a lorem porttitor quisque tincidunt, euismod a dui sodales aliquam aliquet, fusce mollis maecenas aenean etiam vestibulum. Neque bibendum cras vitae turpis in, eget pulvinar curabitur non voluptatibus sit, malesuada sodales non quam bibendum malesuada rutrum, velit lacus at sit diam ultrices tempus, pellentesque in a hendrerit dictumst aenean a. Tellus praesent elit sodales sodales neque diam, odio aliquam lorem nulla accumsan nec, eget vestibulum nunc eget dignissim mauris eu, tristique etiam sapien nulla cillum pharetra dolor, at sapien auctor quis fringilla faucibus. Suspendisse hendrerit morbi auctor nulla imperdiet tortor, nunc risus ut id justo adipiscing, amet vivamus cursus aenean hendrerit nec nibh. Cursus dui maecenas at suspendisse morbi, lectus hymenaeos viverra in erat nesciunt, et tempore nesciunt nibh non excepturi. Dignissim nullam blandit mauris turpis quam, ac litora ipsum pellentesque ipsum ultrices, a nec curabitur vel tortor praesent. Justo vel sit phasellus mauris pede aliquet, donec ante sed vulputate quis consectetuer urna, eu non metus a hendrerit praesent, pellentesque lobortis arcu quis consectetuer scelerisque, vel excepturi risus imperdiet auctor neque. Et dictumst non mattis nibh mi, sed id semper et commodo morbi, amet eget mollis morbi urna in lobortis. Purus proin morbi mi arcu nostra minima, sed id elit purus justo a enim, lectus placerat fusce ante consequat wisi tellus, donec donec tortor ut orci eu, tincidunt amet venenatis tristique in aliquam integer. Nulla in vehicula cras suscipit urna voluptas, dolor aliquet porttitor ornare fermentum amet adipiscing, ipsum nec mauris tellus mauris aliquam, suscipit ac dignissim sodales sem suscipit. Feugiat tincidunt vitae ornare elit faucibus aliquid, volutpat posuere libero labore sollicitudin ultricies, porttitor aliquam vestibulum ac non lacinia vitae. Magna suscipit suscipit sapien imperdiet tristique, morbi in et vulputate ut adipiscing cum, lorem libero justo mauris non pede donec, suspendisse iaculis porta turpis ut integer. Et lacinia in elementum nulla quam, posuere quam nisl vivamus et maecenas eros, magna lectus a rutrum malesuada nonummy. Sociosqu mi quis ligula lectus vel, mauris vestibulum ipsum vulputate in pede, pulvinar aliquam at justo wisi in elit. Ullamcorper proin nec in suscipit nibh sagittis, justo magna a purus in dictum morbi, donec nullam etiam tellus consectetuer mauris, felis morbi ante sapien sit nibh etiam. Varius malesuada est ultrices fusce ridiculus, leo nulla libero nec sed habitasse, et dignissim ad mi justo pellentesque odio. Interdum potenti donec a tincidunt nibh lorem, eleifend sagittis mollit ipsum at donec, cursus at tincidunt cras sit eget, varius vel pharetra ut in donec, at urna viverra sed magnis feugiat. Fames dapibus vivamus fringilla adipiscing quas, ut risus eget mauris sed ante, cras a ac orci cursus nascetur risus, dis gravida egestas turpis id vestibulum. Iaculis eget sem tortor odio lectus pede, condimentum dictum feugiat massa odio hendrerit aperiam, felis et nulla ut ligula wisi praesent, justo nonummy tempor dignissim lorem arcu dapibus. Luctus donec vulputate eu vestibulum maecenas laoreet, consequat mauris hendrerit ipsum elit sed natoque, tellus placerat vitae donec pharetra nulla. Conubia dictum orci nec quam sed, donec congue neque luctus vitae quam, lectus ornare blandit vestibulum semper nullam sollicitudin. Nam sem non aut justo vel enim, eu metus orci arcu lobortis amet, ac sem phasellus velit ac turpis adipiscing, nulla tempus purus vel orci quisque ac. Sed et metus sed ligula purus, consectetuer illo ut sed faucibus suspendisse suspendisse, cursus sed orci ipsum aenean in et, viverra maecenas nec nec lectus tempus. Id nec fusce hymenaeos vitae laboriosam, placerat condimentum diam amet ullamcorper risus, pellentesque mollis magna non enim dolor semper. Sem nullam a dui venenatis a, massa consectetuer in aenean eget condimentum, scelerisque eum euismod ultricies sint velit. A mattis sit nec aenean tempus cras, ligula dignissim nullam mauris curae neque, a dignissim morbi mi curabitur nulla, non tellus orci nonummy sed posuere aliquam, sapien incidunt in sed duis ac etiam. Etiam eget nonummy bibendum praesent eget aliquam, sed auctor erat neque in metus maecenas, amet id pellentesque gravida in wisi tristique, in eu eros non vitae diam turpis, massa et vel litora massa sagittis vehicula. Pede amet vivamus elementum donec maecenas erat, a dolor elit aptent orci pretium ligula, velit proin vestibulum wisi lorem eget, euismod fusce amet libero et id, nunc imperdiet consectetuer elementum integer repellat sodales. In risus morbi nibh rerum ut nonummy, ligula suscipit pharetra dolor diam ornare, ullamcorper nonummy ut wisi vestibulum vivamus convallis. Est porta eros euismod nulla ullamcorper, metus vestibulum libero est mauris tortor nulla, a nulla non vivamus sed non vestibulum, suscipit sed euismod ut nisl et elit. Vel at eget orci fringilla leo, non maecenas vestibulum mauris dictum justo rutrum, integer ultrices sit purus aliquam phasellus, turpis iaculis non non commodo tortor pulvinar, habitasse tincidunt integer lorem vestibulum porta. Magna libero purus imperdiet neque molestie, nonummy eget repellendus volutpat nulla elit, in in varius metus nam vel dictum, libero ultricies justo felis duis ante sit, turpis amet sociis sit dolor cras est. Risus id mattis eget commodo faucibus, porttitor vulputate quis tellus wisi interdum dictum, mauris a sodales erat elementum amet. Ligula odio pellentesque nam et vitae eu, dui eleifend consequat at id eget, imperdiet malesuada arcu suspendisse faucibus ipsum, vivamus ullamcorper semper volutpat sit in, dignissim feugiat litora dapibus porta id purus. Lorem mi vehicula ultrices massa tortor in, lacus pellentesque donec enim feugiat volutpat quis, dictum pede pellentesque elit massa in, at cras urna enim sem posuere explicabo, nibh eget vitae nunc interdum egestas. Sagittis a amet penatibus nec tincidunt felis, feugiat nascetur quisque phasellus justo ligula vestibulum, magnis aptent felis integer tempor sodales porttitor, vitae lorem orci lobortis aliquam condimentum congue. Et arcu vehicula venenatis magna rhoncus etiam, neque nulla eu vel vestibulum amet adipiscing, suspendisse lacinia ac ad nec risus, dolor orci gravida a arcu volutpat, ac arcu at nascetur accusamus eu. In pulvinar vitae nonummy placerat neque sapien, fusce amet lorem quam parturient mi, lorem vehicula nec suspendisse luctus eu. Mollis leo lacus vel at dapibus eros, in ex orci tortor adipiscing in, sodales facilisis integer elit lectus iaculis, elit posuere turpis pretium nec sodales. Parturient eleifend aliquam pretium urna dignissim venenatis, quis tellus urna enim donec sagittis, lectus nullam in consectetuer ac a erat. Lorem donec in in amet mauris, id convallis turpis in lacus taciti a, nec neque vestibulum dolor amet condimentum, sit magnis ultricies urna interdum maecenas. Dictum ipsum sapien leo suspendisse velit, et rutrum est sodales porta parturient, justo inceptos pede pellentesque posuere erat qui, at suspendisse elit ut consequat vestibulum. Ut ut lectus orci pellentesque mollis, ullamcorper nulla volutpat mattis dui eget, fermentum purus quis pellentesque aliquet habitant. Fringilla neque morbi vulputate nulla inventore, lorem velit feugiat tortor quam turpis, cum eget animi sit tempor volutpat ac. A id velit ut maxime in, pede sapien augue duis ultrices interdum eu, praesent consectetuer id a ipsum mauris at. Velit mattis metus mi malesuada pede quam, arcu vitae eros lectus sed venenatis, quis vestibulum quam in tortor maecenas ac, non massa justo nisl pharetra volutpat diam. Urna ad egestas in mauris volutpat donec, maecenas nisl nunc id quam ultricies tristique, leo nibh at sit nunc vitae commodo, ut leo lectus montes eu condimentum id, morbi vestibulum volutpat aliquet sit cras vivamus. Aliquet nec class pede morbi in quam, porttitor eu vel maecenas est ipsum doloremque, pede elit vestibulum fugiat sed tristique, arcu sem sollicitudin nec arcu est, pretium nisl magna sed mattis vitae augue. Natoque at vel tortor placerat tristique, convallis mauris sodales ac consequat ac ut, vestibulum pretium aliquam eget non tempor. Leo justo urna suspendisse sollicitudin imperdiet quis, fringilla nunc pede malesuada quam faucibus nibh, habitasse vestibulum rhoncus velit id donec velit, vivamus sed id vitae posuere lectus. Pellentesque urna vel eu felis ullamcorper, vel accumsan urna massa wisi metus, donec elit velit eget malesuada maecenas, lectus amet etiam sollicitudin feugiat in orci, integer morbi ridiculus tincidunt suscipit donec consequatur. Ultricies ut diam blandit praesent aliquam egestas, tellus varius inceptos duis pellentesque auctor per, libero donec fringilla est amet metus, ipsum est nunc massa cras vel aliquam. Eros curabitur non interdum nisl ac, mauris quisque quam metus dui morbi vel, quis id dolor urna dictumst vel nunc, fringilla velit vel semper vel tempus. Massa nullam in turpis justo rutrum et, velit in blandit lobortis libero dolor, ante urna lobortis et vivamus purus, est wisi mauris erat libero aliquet metus, wisi mollis nam pulvinar vivamus sed orci. Odio dictumst ut mi ultrices dui, quam varius imperdiet posuere donec nec arcu, ac sit eros lacus purus morbi massa, turpis luctus at eget ante sed, ut nunc nulla nec sunt scelerisque. Arcu leo augue libero gravida nam duis, torquent mus elit mus sociis id arcu, montes id consectetuer ipsum purus tincidunt lectus. Feugiat libero convallis in nunc viverra, mauris pharetra a maecenas ut risus a, tempus gravida cursus amet rhoncus luctus. Pharetra consectetuer ut dolor nostra dolor sed, curabitur odio quam et eget sed, vestibulum porta tempus imperdiet ullamcorper ad ultrices. Molestiae vel arcu nec neque doloribus, dui aliquam pharetra varius ad quaerat sed, et nec ornare nullam vivamus viverra, sed vitae egestas et felis ultrices nonummy. Tincidunt provident vivamus proin pellentesque turpis, justo habitant inceptos feugiat ultrices eu, tellus dolorum donec hac rhoncus lorem sit. Orci gravida consectetuer wisi imperdiet consequat, non metus eos dolor sed eu urna, fusce aliquam et malesuada proin vitae, elementum magna et non mattis augue, luctus hendrerit sit a asperiores eius. Aliquam bibendum erat curabitur pharetra pellentesque, mauris suspendisse hendrerit sed orci aliquam, augue amet nascetur duis vitae donec, feugiat condimentum habitasse elit ac ante turpis. Amet vitae dolor adipiscing turpis non, molestie dapibus lacus a et ante penatibus, condimentum mi quam quis suspendisse pellentesque ullamcorper, ac fringilla amet felis eget felis, malesuada montes amet vehicula urna neque ut. Orci mattis quisque lectus id a, enim suspendisse curabitur ut massa dignissim proin, pellentesque aliquam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, vel habitant erat suspendisse tristique eu est. Parturient vulputate pharetra vitae integer magna morbi, class ullamcorper porta vel amet molestie, felis dapibus pulvinar sit praesent leo lacus. Tristique nam ut tempor metus euismod sodales, urna sit sed vestibulum praesent nec, adipiscing eget et nec est ut, tempor nonummy phasellus sem vestibulum eu varius, purus nibh nulla eu nostra tristique. Est ut ultricies quam vestibulum lobortis nibh, purus imperdiet quis hymenaeos impedit porta, pharetra ornare laudantium elit nulla in, morbi vehicula amet lacinia nec vulputate eu. Tellus lobortis est quis amet non, nec risus mauris nisi tortor dictum integer, consectetuer luctus vel fusce suspendisse egestas magna. Massa sed elementum aliquet ornare metus lorem, odio est platea nunc mattis imperdiet commodo, laoreet et a felis amet wisi, massa vulputate pulvinar non gravida vivamus. Sed ante metus dolor velit nunc, tempus nec vestibulum in sed venenatis, dui mollis sit tristique ultricies sociis, magna ante dolor ipsum sodales amet. Malesuada sed facilisis sit tempor urna, iaculis est cras fusce wisi vivamus, etiam ullamcorper gravida risus sed rutrum, in quis arcu nec quis ut, arcu massa suspendisse ipsum in dui. Suspendisse class vivamus nullam fermentum ac, vehicula sollicitudin suam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, veec viverra voluLorem ipsum dolor sit amet, fermentum pharetra ipsum sed mauris scelerisque culpa, laoreet libero etiam pharetra eu lacus, sed varius magna hac tellus praesent in, suspendisse urna tellus placerat non risus. Porttitor nonummy vehicula wisi sint tempor, vitae tellus nulla fermentum quis quis, mauris dignissim omnis porta ac volutpat, hac eget viverra in gravida nonummy pulvinar, velit nulla feugiat parturient netus mollis aliquam. Arcu leo scelerisque quisque blandit pellentesque, ultricies nascetur purus cursus imperdiet accumsan sagittis, praesent nunc sed dapibus dui in. Cubilia lorem lacus tellus diam debitis, commodo fusce dolor adipisicing consectetuer et vitae, vestibulum ornare accumsan vitae accumsan praesent, morbi faucibus justo lorem augue porta sodales, molestie nulla ac nibh nec est aenean. Praesent erat maecenas odio ante dolor, vehicula nam mi ultrices ut dolor ante, fusce ridiculus at arcu urna felis vel, a pellentesque arcu accumsan nulla deserunt. Nunc ornare nec a diam aliquam urna, maecenas vivamus senectus sagittis tellus ac faucibus, mi leo quam tempor amet facilisis, sapien per cras placerat libero porta, vitae mauris quis sit nec ut. Sit magna vitae donec leo urna, nascetur eu viverra massa amet pharetra proident, elit commodo ipsum proin pellentesque consequat feugiat, elit sit quis facilisis ipsum ornare pellentesque. Morbi enim et et pretium et tortor, praesent adipiscing placerat aliquet dolor vestibulum, tempus at consectetuer ut diam fermentum nulla. Pellentesque lorem phasellus tristique a ac donec, augue suspendisse orci consequat rhoncus dapibus, magna quam habitasse assumenda duis imperdiet scelerisque. Turpis iaculis ipsum phasellus vitae et, nunc congue rhoncus eu diam in, rutrum dui mauris leo est sodales. Ut ante tempora imperdiet orci in ut, turpis laoreet dapibus penatibus ut in, tempor ac gravida est nam lorem dictum. Lacinia bibendum vitae ante lacus in, orci per orci amet sed dolor lorem, ullamcorper at a praesent quis dictum consectetuer, dolor nunc fermentum interdum tortor voluptatem. Vestibulum cursus nunc nunc risus nec metus, diam mauris vestibulum nullam pellentesque ipsum, maecenas et semper platea wisi porttitor curabitur. Quis adipiscing adipiscing purus vestibulum gravida, lacinia justo vel interdum sociosqu lacus, wisi leo fusce aenean arcu sapien volutpat, ipsum accumsan a ornare tellus et. Sagittis sit malesuada pellentesque nulla enim, accumsan tempor a in vehicula et ipsum, montes est risus adipiscing wisi amet, sed tempus eu purus quisque donec. In non purus wisi donec vel amet, maecenas enim cursus etiam dapibus ac, in fringilla facilisis nibh congue et, commodo et curabitur sapien ut facilisis, morbi turpis facilisis sit tortor faucibus in. Ut aenean erat tempor purus et venenatis, cursus feugiat amet blandit vel bibendum, mi purus felis odio suspendisse sed, nunc urna eum tincidunt a consequat, venenatis curabitur elit nullam aliquam nec laboriosam. Vestibulum integer ut cursus laoreet odio, tincidunt maecenas vel sed ut ac varius, malesuada diam libero sodales ipsum sed, viverra erat sit integer quisque iaculis volutpat, penatibus quam donec accumsan duis in a. Sodales ipsum torquent tempus dolore sit, sagittis mauris nisl in sed rutrum a, amet ut elit fusce libero netus egestas, lobortis sit turpis augue maecenas integer. Eget porttitor nunc risus faucibus enim, donec nec convallis egestas pellentesque lectus felis, vulputate suspendisse risus metus blandit quis, a suspendisse nonummy enim fermentum per dapibus. Et faucibus vestibulum iaculis sapiente per accumsan, fringilla elementum auctor praesent sollicitudin rutrum laoreet, fugit suspendisse duis et vestibulum eu euismod, feugiat quis sit nunc dolor urna. Id suscipit porta sed wisi nam vehicula, integer ut massa donec eget dolor sapien, elit tincidunt condimentum rutrum magna pede, est tellus pellentesque facilisi dictum laoreet amet, ac quam ligula pede vitae pellentesque. Litora sed a cubilia dui vestibulum felis, nascetur hac parturient integer convallis in, donec tellus ipsum aliquam proin massa. In pede eu parturient nisl lectus, amet magna at sit massa ipsum pellentesque, pharetra augue dolor egestas porta dictum mi. Leo etiam dui mauris turpis erat vel, velit bibendum odio sagittis sagittis in, sodales vitae et massa at mattis. Vulputate nonummy pede rhoncus est ut, placerat placerat tristique in aliquet id, lobortis sed non ornare vestibulum consectetuer. Risus augue sed ac lectus volutpat, nulla arcu iaculis aenean aliquam ut lacinia, at mi amet facilisis purus morbi sollicitudin. Eget nulla molestie lectus tincidunt vel, tellus quo odio nonummy mauris felis, integer sapien tellus dignissim viverra lorem suspendisse. Duis molestiae sem vel eu orci, a nibh a lorem porttitor quisque tincidunt, euismod a dui sodales aliquam aliquet, fusce mollis maecenas aenean etiam vestibulum. Neque bibendum cras vitae turpis in, eget pulvinar curabitur non voluptatibus sit, malesuada sodales non quam bibendum malesuada rutrum, velit lacus at sit diam ultrices tempus, pellentesque in a hendrerit dictumst aenean a. Tellus praesent elit sodales sodales neque diam, odio aliquam lorem nulla accumsan nec, eget vestibulum nunc eget dignissim mauris eu, tristique etiam sapien nulla cillum pharetra dolor, at sapien auctor quis fringilla faucibus. Suspendisse hendrerit morbi auctor nulla imperdiet tortor, nunc risus ut id justo adipiscing, amet vivamus cursus aenean hendrerit nec nibh. Cursus dui maecenas at suspendisse morbi, lectus hymenaeos viverra in erat nesciunt, et tempore nesciunt nibh non excepturi. Dignissim nullam blandit mauris turpis quam, ac litora ipsum pellentesque ipsum ultrices, a nec curabitur vel tortor praesent. Justo vel sit phasellus mauris pede aliquet, donec ante sed vulputate quis consectetuer urna, eu non metus a hendrerit praesent, pellentesque lobortis arcu quis consectetuer scelerisque, vel excepturi risus imperdiet auctor neque. Et dictumst non mattis nibh mi, sed id semper et commodo morbi, amet eget mollis morbi urna in lobortis. Purus proin morbi mi arcu nostra minima, sed id elit purus justo a enim, lectus placerat fusce ante consequat wisi tellus, donec donec tortor ut orci eu, tincidunt amet venenatis tristique in aliquam integer. Nulla in vehicula cras suscipit urna voluptas, dolor aliquet porttitor ornare fermentum amet adipiscing, ipsum nec mauris tellus mauris aliquam, suscipit ac dignissim sodales sem suscipit. Feugiat tincidunt vitae ornare elit faucibus aliquid, volutpat posuere libero labore sollicitudin ultricies, porttitor aliquam vestibulum ac non lacinia vitae. Magna suscipit suscipit sapien imperdiet tristique, morbi in et vulputate ut adipiscing cum, lorem libero justo mauris non pede donec, suspendisse iaculis porta turpis ut integer. Et lacinia in elementum nulla quam, posuere quam nisl vivamus et maecenas eros, magna lectus a rutrum malesuada nonummy. Sociosqu mi quis ligula lectus vel, mauris vestibulum ipsum vulputate in pede, pulvinar aliquam at justo wisi in elit. Ullamcorper proin nec in suscipit nibh sagittis, justo magna a purus in dictum morbi, donec nullam etiam tellus consectetuer mauris, felis morbi ante sapien sit nibh etiam. Varius malesuada est ultrices fusce ridiculus, leo nulla libero nec sed habitasse, et dignissim ad mi justo pellentesque odio. Interdum potenti donec a tincidunt nibh lorem, eleifend sagittis mollit ipsum at donec, cursus at tincidunt cras sit eget, varius vel pharetra ut in donec, at urna viverra sed magnis feugiat. Fames dapibus vivamus fringilla adipiscing quas, ut risus eget mauris sed ante, cras a ac orci cursus nascetur risus, dis gravida egestas turpis id vestibulum. Iaculis eget sem tortor odio lectus pede, condimentum dictum feugiat massa odio hendrerit aperiam, felis et nulla ut ligula wisi praesent, justo nonummy tempor dignissim lorem arcu dapibus. Luctus donec vulputate eu vestibulum maecenas laoreet, consequat mauris hendrerit ipsum elit sed natoque, tellus placerat vitae donec pharetra nulla. Conubia dictum orci nec quam sed, donec congue neque luctus vitae quam, lectus ornare blandit vestibulum semper nullam sollicitudin. Nam sem non aut justo vel enim, eu metus orci arcu lobortis amet, ac sem phasellus velit ac turpis adipiscing, nulla tempus purus vel orci quisque ac. Sed et metus sed ligula purus, consectetuer illo ut sed faucibus suspendisse suspendisse, cursus sed orci ipsum aenean in et, viverra maecenas nec nec lectus tempus. Id nec fusce hymenaeos vitae laboriosam, placerat condimentum diam amet ullamcorper risus, pellentesque mollis magna non enim dolor semper. Sem nullam a dui venenatis a, massa consectetuer in aenean eget condimentum, scelerisque eum euismod ultricies sint velit. A mattis sit nec aenean tempus cras, ligula dignissim nullam mauris curae neque, a dignissim morbi mi curabitur nulla, non tellus orci nonummy sed posuere aliquam, sapien incidunt in sed duis ac etiam. Etiam eget nonummy bibendum praesent eget aliquam, sed auctor erat neque in metus maecenas, amet id pellentesque gravida in wisi tristique, in eu eros non vitae diam turpis, massa et vel litora massa sagittis vehicula. Pede amet vivamus elementum donec maecenas erat, a dolor elit aptent orci pretium ligula, velit proin vestibulum wisi lorem eget, euismod fusce amet libero et id, nunc imperdiet consectetuer elementum integer repellat sodales. In risus morbi nibh rerum ut nonummy, ligula suscipit pharetra dolor diam ornare, ullamcorper nonummy ut wisi vestibulum vivamus convallis. Est porta eros euismod nulla ullamcorper, metus vestibulum libero est mauris tortor nulla, a nulla non vivamus sed non vestibulum, suscipit sed euismod ut nisl et elit. Vel at eget orci fringilla leo, non maecenas vestibulum mauris dictum justo rutrum, integer ultrices sit purus aliquam phasellus, turpis iaculis non non commodo tortor pulvinar, habitasse tincidunt integer lorem vestibulum porta. Magna libero purus imperdiet neque molestie, nonummy eget repellendus volutpat nulla elit, in in varius metus nam vel dictum, libero ultricies justo felis duis ante sit, turpis amet sociis sit dolor cras est. Risus id mattis eget commodo faucibus, porttitor vulputate quis tellus wisi interdum dictum, mauris a sodales erat elementum amet. Ligula odio pellentesque nam et vitae eu, dui eleifend consequat at id eget, imperdiet malesuada arcu suspendisse faucibus ipsum, vivamus ullamcorper semper volutpat sit in, dignissim feugiat litora dapibus porta id purus. Lorem mi vehicula ultrices massa tortor in, lacus pellentesque donec enim feugiat volutpat quis, dictum pede pellentesque elit massa in, at cras urna enim sem posuere explicabo, nibh eget vitae nunc interdum egestas. Sagittis a amet penatibus nec tincidunt felis, feugiat nascetur quisque phasellus justo ligula vestibulum, magnis aptent felis integer tempor sodales porttitor, vitae lorem orci lobortis aliquam condimentum congue. Et arcu vehicula venenatis magna rhoncus etiam, neque nulla eu vel vestibulum amet adipiscing, suspendisse lacinia ac ad nec risus, dolor orci gravida a arcu volutpat, ac arcu at nascetur accusamus eu. In pulvinar vitae nonummy placerat neque sapien, fusce amet lorem quam parturient mi, lorem vehicula nec suspendisse luctus eu. Mollis leo lacus vel at dapibus eros, in ex orci tortor adipiscing in, sodales facilisis integer elit lectus iaculis, elit posuere turpis pretium nec sodales. Parturient eleifend aliquam pretium urna dignissim venenatis, quis tellus urna enim donec sagittis, lectus nullam in consectetuer ac a erat. Lorem donec in in amet mauris, id convallis turpis in lacus taciti a, nec neque vestibulum dolor amet condimentum, sit magnis ultricies urna interdum maecenas. Dictum ipsum sapien leo suspendisse velit, et rutrum est sodales porta parturient, justo inceptos pede pellentesque posuere erat qui, at suspendisse elit ut consequat vestibulum. Ut ut lectus orci pellentesque mollis, ullamcorper nulla volutpat mattis dui eget, fermentum purus quis pellentesque aliquet habitant. Fringilla neque morbi vulputate nulla inventore, lorem velit feugiat tortor quam turpis, cum eget animi sit tempor volutpat ac. A id velit ut maxime in, pede sapien augue duis ultrices interdum eu, praesent consectetuer id a ipsum mauris at. Velit mattis metus mi malesuada pede quam, arcu vitae eros lectus sed venenatis, quis vestibulum quam in tortor maecenas ac, non massa justo nisl pharetra volutpat diam. Urna ad egestas in mauris volutpat donec, maecenas nisl nunc id quam ultricies tristique, leo nibh at sit nunc vitae commodo, ut leo lectus montes eu condimentum id, morbi vestibulum volutpat aliquet sit cras vivamus. Aliquet nec class pede morbi in quam, porttitor eu vel maecenas est ipsum doloremque, pede elit vestibulum fugiat sed tristique, arcu sem sollicitudin nec arcu est, pretium nisl magna sed mattis vitae augue. Natoque at vel tortor placerat tristique, convallis mauris sodales ac consequat ac ut, vestibulum pretium aliquam eget non tempor. Leo justo urna suspendisse sollicitudin imperdiet quis, fringilla nunc pede malesuada quam faucibus nibh, habitasse vestibulum rhoncus velit id donec velit, vivamus sed id vitae posuere lectus. Pellentesque urna vel eu felis ullamcorper, vel accumsan urna massa wisi metus, donec elit velit eget malesuada maecenas, lectus amet etiam sollicitudin feugiat in orci, integer morbi ridiculus tincidunt suscipit donec consequatur. Ultricies ut diam blandit praesent aliquam egestas, tellus varius inceptos duis pellentesque auctor per, libero donec fringilla est amet metus, ipsum est nunc massa cras vel aliquam. Eros curabitur non interdum nisl ac, mauris quisque quam metus dui morbi vel, quis id dolor urna dictumst vel nunc, fringilla velit vel semper vel tempus. Massa nullam in turpis justo rutrum et, velit in blandit lobortis libero dolor, ante urna lobortis et vivamus purus, est wisi mauris erat libero aliquet metus, wisi mollis nam pulvinar vivamus sed orci. Odio dictumst ut mi ultrices dui, quam varius imperdiet posuere donec nec arcu, ac sit eros lacus purus morbi massa, turpis luctus at eget ante sed, ut nunc nulla nec sunt scelerisque. Arcu leo augue libero gravida nam duis, torquent mus elit mus sociis id arcu, montes id consectetuer ipsum purus tincidunt lectus. Feugiat libero convallis in nunc viverra, mauris pharetra a maecenas ut risus a, tempus gravida cursus amet rhoncus luctus. Pharetra consectetuer ut dolor nostra dolor sed, curabitur odio quam et eget sed, vestibulum porta tempus imperdiet ullamcorper ad ultrices. Molestiae vel arcu nec neque doloribus, dui aliquam pharetra varius ad quaerat sed, et nec ornare nullam vivamus viverra, sed vitae egestas et felis ultrices nonummy. Tincidunt provident vivamus proin pellentesque turpis, justo habitant inceptos feugiat ultrices eu, tellus dolorum donec hac rhoncus lorem sit. Orci gravida consectetuer wisi imperdiet consequat, non metus eos dolor sed eu urna, fusce aliquam et malesuada proin vitae, elementum magna et non mattis augue, luctus hendrerit sit a asperiores eius. Aliquam bibendum erat curabitur pharetra pellentesque, mauris suspendisse hendrerit sed orci aliquam, augue amet nascetur duis vitae donec, feugiat condimentum habitasse elit ac ante turpis. Amet vitae dolor adipiscing turpis non, molestie dapibus lacus a et ante penatibus, condimentum mi quam quis suspendisse pellentesque ullamcorper, ac fringilla amet felis eget felis, malesuada montes amet vehicula urna neque ut. Orci mattis quisque lectus id a, enim suspendisse curabitur ut massa dignissim proin, pellentesque aliquam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, vel habitant erat suspendisse tristique eu est. Parturient vulputate pharetra vitae integer magna morbi, class ullamcorper porta vel amet molestie, felis dapibus pulvinar sit praesent leo lacus. Tristique nam ut tempor metus euismod sodales, urna sit sed vestibulum praesent nec, adipiscing eget et nec est ut, tempor nonummy phasellus sem vestibulum eu varius, purus nibh nulla eu nostra tristique. Est ut ultricies quam vestibulum lobortis nibh, purus imperdiet quis hymenaeos impedit porta, pharetra ornare laudantium elit nulla in, morbi vehicula amet lacinia nec vulputate eu. Tellus lobortis est quis amet non, nec risus mauris nisi tortor dictum integer, consectetuer luctus vel fusce suspendisse egestas magna. Massa sed elementum aliquet ornare metus lorem, odio est platea nunc mattis imperdiet commodo, laoreet et a felis amet wisi, massa vulputate pulvinar non gravi tristique ultricies sociis, magna ante dolor ipsum sodales amet. Malesuada sed facilisis sit tempor urna, iaculis est cras fusce wisi vivamus, etiam ullamcorper gravida risus sed rutrum, in quis arcu nec quis ut, arcu massa suspendisse ipsum in dui. Suspendisse class vivamus nullam fermentum ac, vehicula sollicitudin suam sed fringilla et donec sit, in massa quis donec viverra voluptatem placeat, veec viverra voluptatem placeat, v';
        tasklist.TaskCreatedBy ='test id ztestNUS0004';
        tasklist.TaskChangedBy ='venkat';
        tasklist.TaskClosedBy='venkat';
        tasklist.TaskCreatedDate ='2016-09-22';
        tasklist.TaskChangedDate ='2016-09-22';
        tasklist.TaskClosedDate = '2016-09-22';
        tasklist.TaskStatus = 'Open';
        tasklist.TaskOwner='CSO';
        tasklist.LanguageKey='0003238978630001';  
        zlst.add(tasklist); 
        cas.ZTASKITEMS = zlst;
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();     
        usr.CaseNumber=null;
        usr.ChangeNumber='001';
        usr.Emailstatus=null; 
        usr.NotificationNumber=null;
        usr.ParentObjectNo='QM000323897863';
        usr.ParentRoot='Case';
        usr.SAPUserStatusObjectNumber='000323897863001PPOC';
        usr.SFDCUserStatusId=null;
        usr.SalesOrder=null;
        usr.Status='Open';
        usr.UserStatus='PPOC';
        usr.UserStatusName='Pre payment Customer';
        usr.UserStatusRelationship=null;
        usr.CaseNumber=null;
        usr.ChangeNumber='002';
        usr.Emailstatus=null; 
        usr.NotificationNumber=null;
        usr.ParentObjectNo='QM000323897863';
        usr.ParentRoot='Task';
        usr.SAPUserStatusObjectNumber='000323897863002PPOC';
        usr.SFDCUserStatusId=null;
        usr.SalesOrder=null;
        usr.Status='Open';
        usr.UserStatus='PPOC';
        usr.UserStatusName='Pre payment Customer';
        usr.UserStatusRelationship=null;        
        usrlst.add(usr);
        cas.Userstatuslst= usrlst;
        Test.startTest();
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cas);
        Test.stopTest();
        Case cs= [select id,contactid,casenumber,Customer_PO_RO_WONumber__c,RecordtypeId,Origin,Type,Additional_Web_Form_Info__c,Order_Type__c,Order_Status_Info_Requested__c,Portal_Contact_Email__c,Honeywell_ID__c,Priority,Classification__c,Sales_Order_Number__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Subject,Status,OwnerId,Description,(SELECT id,Type__c,RelatedTo__c,Task_Closed__c,CreatedDate,LastModifiedDate,Status__c from Case.Z_Tasks__r),(SELECT id,APU_Workcenter__c,Case_object__c,Case_object__r.casenumber,Warranty_requested__c,Warranty_Accepted__c,Warranty_Start_Date__c,Warranty_End_Date__c,Notification_Number__c,Receipt_Date__c,IDS_OTTR_Date__c from case.Case_Extensions__r )  from case where Quote_Number__c != null and Sales_Order_Number__c != null and Repair_Notification_Number__c != null  limit 1];    
        //CaseTaskList12 = [SELECT Name,Id,SAP_ZTask_Number__c,Long_Text__c,Language_Key__c,Sub_Type__c,Comments__c,Status__c,Other_Short_Text__c,Type__c,SAPTaskObjectNo__c,Short_Text__c FROM Z_Task__c where  RelatedTo__c=:cs.Id ];  
        /*Case_Extension__c e = new Case_Extension__c();
        e.Notification_Number__c = '3435';
        e.Case_Object__c = cs.id;
        insert e;
        Case_Extension__c csext = [select id,Notification_Number__c,Case_Object__c  from Case_Extension__c  where id=:e.id];*/
        CreateCaseServiceclass cls_obj= new CreateCaseServiceclass();
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP cse = new SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP();
        ZtaskServiceclass ztask=new ZtaskServiceclass();
        cse=ZtaskServiceclass.ZTASK(cas,cs.caseNumber);
        cse=UserstatusServiceClass.UserStatus(cas,cs.caseNumber);
        
        cls_obj.getCaseNumber(cs.id);
        cls_obj.getCaseroiorderinfo(cs.id,'1','1','1','1','1','','1','1','1','1','1','1','1','1','1','test');
        //cls_obj.getCaseExtension(cs.id,'','','','','','','','','');
        
    }
    
    testMethod static void SI_SAPtoSFDCServiceclassTest66()
    {
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();
        Case cass = new Case();
        cass.Origin = 'web';
        cass.Status = 'Open';  
        cass.OwnerId = Label.UFR_Owner_Id;
        cass.Classification__c = 'CSO Repair Order';
        cass.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cass.Government_Compliance_SM_M_Content__c = 'No';
        cass.Sales_Order_Number__c = '12345678';
        cass.Quote_Number__c= '213424';
        cass.CaseOwnerChanged__c = 'nandini.nanjappan@nttdata.com';
        cass.Description = 'Test cases';
        cass.subject='test case';
        cass.Sales_Order_Number__c =  '12345678';
        cass.Repair_Notification_Number__c = '3243';
        insert cass; 
        Z_Task__c zt11 = new Z_Task__c();
        zt11.SAP_ZTask_Number__c = 'Test123';
        zt11.Name = 'Tasktest1';
        zt11.RelatedTo__c = cass.id;
        zt11.Short_Text__c = 'Test';
        zt11.Comments__c = 'Test Ztask';
        zt11.Long_Text__c = 'Test122';
        zt11.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
        zt11.Other_Short_Text__c = 'Test text';
        zt11.Status__c = 'Closed';
        insert zt11;
        Activitiy_Line_Item__c userstatus=new Activitiy_Line_Item__c();
        userstatus.Task_Activities__c=zt11.id;
        userstatus.Case__c=cass.id;
        userstatus.status__c = 'open';
        insert userstatus;
        //Case_Extension__c cet = new Case_Extension__c (name='Testextension',Case_object__c=cass.id) ;
        // insert cet;      
        Test.startTest();
        Activitiy_Line_Item__c actln = [SELECT id,Notification_Number__c,ParentObjectNo__c,Case__c from Activitiy_Line_Item__c  where Case__c=:cass.id];
        case ca=[select id,status,casenumber,Quote_Number__c,Sales_Order_Number__c,Requestor_Email__c,Repair_Notification_Number__c,ownerid from case where id=:cass.id and Repair_Notification_Number__c!=null];
        Z_Task__c zz=[SELECT Name,Id,SAP_ZTask_Number__c,Long_Text__c,Language_Key__c,Sub_Type__c,Comments__c,Status__c,Other_Short_Text__c,Type__c,SAPTaskObjectNo__c,Short_Text__c FROM Z_Task__c where  id=:zt11.Id];
        SI_SAPtoSFDCServiceclass.RnO_CASE_cls cas = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls();    
        cas.NotificationNumber = ca.Repair_Notification_Number__c; 
        cas.CUSTOMER_EMAIL_VBAK = 'nandini.nanjappan@nttdata.com';
        cas.ACCOUNT_NAME = '1+5Y1+1502';
        cas.APUWorkcenter='APMAIN';
        cas.SAP_ACCOUNT_NAME = 'TestSAPAccount';
        cas.REPAIR_LOCATION = 'Chennai';
        cas.PRODUCT_NUM = '2312';
        cas.Caseowner = 'Aero Default';
        cas.ORDER_ENTERED_DT = '17-08-2016';
        cas.CUSTOMER_REQUEST_DT = '17-08-2016';
        cas.PRODUCT_SERIAL_NUM = '232';
        cas.SPEX_EXG_IND = 'Test';
        cas.QuoteNumber = '2324';
        cas.RESOLUTION = 'Test';
        cas.SALES_ORDER_NUMBER = '7678';
        cas.SAP_ACCOUNT_INFO = 'Testacct';
        cas.STATUS = 'Open';
        cas.SUB_CLASS = 'Test';
        cas.SUBJECT = 'Test';
        cas.CaseType = 'UFR PO Mismatch'; 
        cas.Y1_PARTNER_FIRSTNAME = 'Test';
        cas.Y1_PARTNER_LASTNAME = 'Contact';
        cas.Y1_PARTNER_EMAIL = 'test@test.com';
        cas.Y1_PARTNER_PHONE = '9876543210';
        cas.CASENUMBER=ca.casenumber;     
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS tasklist = new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();           
        tasklist.Tasktype='Z106 Order Review and Completion';
        tasklist.Type='Task Creation';
        tasklist.TaskNumber='24234';
        //tasklist.Taskid=zz.id;      
        tasklist.TaskShorttext='Test';
        tasklist.Tasklongtext='Test';
        tasklist.TaskCreatedBy ='test id ztestNUS0004';
        tasklist.TaskChangedBy ='venkat';
        tasklist.TaskClosedBy='venkat';
        tasklist.TaskCreatedDate ='2016-09-22';
        tasklist.TaskChangedDate ='2016-09-22';
        tasklist.TaskClosedDate = '2016-09-22';
        tasklist.TaskStatus = 'Open';
        tasklist.TaskOwner='CSO';
        tasklist.LanguageKey=zz.Language_Key__c;    
        zlst.add(tasklist); 
        cas.ZTASKITEMS = zlst;
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();     
        usr.CaseNumber=ca.id;
        usr.ChangeNumber='001';
        usr.Emailstatus=null; 
        usr.NotificationNumber=actln.Notification_Number__c;
        usr.ParentObjectNo=actln.ParentObjectNo__c;
        usr.ParentRoot='Case';
        usr.SAPUserStatusObjectNumber='000323897863001PPOC';
        usr.SFDCUserStatusId=null;
        usr.SalesOrder=null;
        usr.Status='Open';
        usr.UserStatus='PPOC';
        usr.UserStatusName='Pre payment Customer';
        usr.UserStatusRelationship=null;
        usr.CaseNumber=actln.id;
        usr.ChangeNumber='002';
        usr.Emailstatus=null; 
        usr.NotificationNumber=null;
        usr.ParentObjectNo='QM000323897863';
        usr.ParentRoot='Task';
        usr.SAPUserStatusObjectNumber='000323897863002PPOC';
        usr.SFDCUserStatusId=null;
        usr.SalesOrder=null;
        usr.Status='Open';
        usr.UserStatus='PPOC';
        usr.UserStatusName='Pre payment Customer';
        usr.UserStatusRelationship=null;        
        usrlst.add(usr);
        cas.Userstatuslst= usrlst;
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cas);
        Case cs= [select id,contactid,casenumber,Customer_PO_RO_WONumber__c,RecordtypeId,Origin,Type,Additional_Web_Form_Info__c,Order_Type__c,Order_Status_Info_Requested__c,Portal_Contact_Email__c,Honeywell_ID__c,Priority,Classification__c,Sales_Order_Number__c,Export_Compliance_Content_ITAR_EAR__c,Government_Compliance_SM_M_Content__c,Subject,Status,OwnerId,Description,(SELECT id,Type__c,RelatedTo__c,Task_Closed__c,CreatedDate,LastModifiedDate,Status__c from Case.Z_Tasks__r),(SELECT id,APU_Workcenter__c,Case_object__c,Case_object__r.casenumber,Warranty_requested__c,Warranty_Accepted__c,Warranty_Start_Date__c,Warranty_End_Date__c,Notification_Number__c,Receipt_Date__c,IDS_OTTR_Date__c from case.Case_Extensions__r )  from case where Quote_Number__c != null and Sales_Order_Number__c != null and Repair_Notification_Number__c != null  limit 1];    
        
       /* Case_Extension__c e = new Case_Extension__c();
        e.Notification_Number__c = '3435';
        e.Case_Object__c = cs.id;
        insert e;
        UpdateCaseServiceclass cls_obj= new UpdateCaseServiceclass();*/
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP cse = new SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP();
        ZtaskServiceclass ztask=new ZtaskServiceclass();
        cse=ZtaskServiceclass.ZTASK(cas,cs.caseNumber);
        cse=UserstatusServiceClass.UserStatus(cas,cs.caseNumber);
        cse=UpdateCaseServiceclass.UPDATE_CASE(cas);
        //cls_obj.getCaseNumber(cs.id);
       //Z_Task__c CaseTaskList12 = [SELECT Name,Id,SAP_ZTask_Number__c,Long_Text__c,Language_Key__c,Sub_Type__c,Comments__c,Status__c,Other_Short_Text__c,Type__c,SAPTaskObjectNo__c,Short_Text__c FROM Z_Task__c where  RelatedTo__c=:cs.Id ];  
       // tasklist.SAP_ZTask_Number__c =  CaseTaskList12.TaskNumber;
        Test.stopTest();
    } 
    testMethod static void SI_SAPtoSFDCServiceclassTest5(){
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();
        Account acc= [Select Id,Name from Account where Strategic_Business_Unit__c='ATR' LIMIT 1];
        //insert acc;
        Account act=[select id,name,Sbl_Account_Row_Id__c,REPORT_ACCOUNT_NAME__c from account where id=:acc.id];
      
        Test.startTest();  
        SI_SAPtoSFDCServiceclass.RnO_CASE_cls cas = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls(); 
        cas.caseNumber = '029328434';   
        cas.NotificationNumber = '000331353458'; 
        cas.CUSTOMER_EMAIL_VBAK = 'nandini.nanjappan@nttdata.com';
        cas.ACCOUNT_NAME =  act.Sbl_Account_Row_Id__c;
        cas.SAP_ACCOUNT_NAME = 'TestSAPAccount';
        cas.REPAIR_LOCATION = 'Chennai';
        cas.PRODUCT_NUM = '2312';
        cas.Caseowner = 'Aero Default';
        cas.ORDER_ENTERED_DT = '17-08-2016';
        cas.CUSTOMER_REQUEST_DT = '17-08-2016';
        cas.PRODUCT_SERIAL_NUM = '232';
        cas.SPEX_EXG_IND = 'Test';
        cas.QuoteNumber = '2324';
        cas.RESOLUTION = 'Test';
        cas.SALES_ORDER_NUMBER = '7678';
        cas.SAP_ACCOUNT_INFO = 'Testacct';
        cas.STATUS = 'Open';
        cas.SUB_CLASS = 'Test';
        cas.SUBJECT = 'Test'; 
        cas.Y1_PARTNER_FIRSTNAME = 'Test';
        cas.Y1_PARTNER_LASTNAME = 'Contact';
        cas.Y1_PARTNER_EMAIL = 'test@test.com';
        cas.Y1_PARTNER_PHONE = '9876543210';
        //cas.CaseType = 'UFR Unfunded PO';
        //cas.getCaseNumber(cas);
        //cas.casenumber = '983728323';    
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS ztask= new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();      
        ztask.TaskNumber = '434523';
        zlst.add(ztask);
        cas.ZTASKITEMS = zlst;
        //string casenumber1 =cas.caseNumber;
       // cas.ZtaskItemlist = zlst;
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();  
        usr.Status = 'Open'; 
        usr.ParentObjectNo = '3213';
        usr.CaseNumber = cas.CaseNumber;
        usr.NotificationNumber = '00023435';  
        usrlst.add(usr);
        cas.Userstatuslst= usrlst;
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cas);
        Test.stopTest();
    }
     testMethod static void SI_SAPtoSFDCTest(){
        Test.startTest();
        //List<SAPtoSFDCServiceclass.Attachmentlist> at1 = new List<SAPtoSFDCServiceclass.Attachmentlist >();
        
       SI_SAPtoSFDCServiceclass.RnO_CASE_cls cs = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls(); 
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();  
        usr.Status = 'Open'; 
        usr.ParentObjectNo = '3213';
        usr.CaseNumber = '236789';
        usr.NotificationNumber = '00023435';  
        usrlst.add(usr);
        
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS tasklist= new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();    
      
        tasklist.Tasktype='Z106 Order Review and Completion';
        tasklist.Type='Task Creation';
        tasklist.TaskNumber='24234';
        //tasklist.Taskid=zz.id;      
        tasklist.TaskShorttext='Test';
        tasklist.Tasklongtext='Test';
           
        zlst.add(tasklist); 
        
        cs.SALES_ORDER_NUMBER = '12345678';
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'sofiya.peermohamed@nttdata.com'; 
        cs.ORDER_ENTERED_DT='2016-08-12' ;
        cs.CUSTOMER_REQUEST_DT='2021-04-01';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'PPO Downpayment document';
        cs.DESCRIPTION = 'PPO Downpayment document';
        cs.NotificationNumber='672345';
        cs.REPAIR_LOCATION = '4144';
        cs.SAP_ACCOUNT_NAME = '0000300952';
        cs.CUSTOMER_EMAIL_VBAK = 'nandini.nanjappan@nttdata.com';
        cs.CASENUMBER = '';
        cs.ZTASKITEMS = zlst;
        cs.Userstatuslst= usrlst; 
        cs.Y1_PARTNER_FIRSTNAME = 'Test';
        cs.Y1_PARTNER_LASTNAME = 'Contact';
        cs.Y1_PARTNER_EMAIL = 'test@test.com';
        cs.Y1_PARTNER_PHONE = '9876543210';
        
         SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        
        Test.stopTest();
    }
     testMethod static void SI_SAPtoSFDCTest1(){
        
       Test.startTest();
       SI_SAPtoSFDCServiceclass.RnO_CASE_cls cs = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls(); 
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();  
        usr.Status = 'Open'; 
        usr.ParentObjectNo = '3213';
        usr.CaseNumber = '236789';
        usr.NotificationNumber = '00023435';  
        usrlst.add(usr);
        
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS tasklist= new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();    
      
        tasklist.Tasktype='Z106 Order Review and Completion';
        tasklist.Type='Task Creation';
        tasklist.TaskNumber='24234';
        //tasklist.Taskid=zz.id;      
        tasklist.TaskShorttext='Test';
        tasklist.Tasklongtext='Test';
           
        zlst.add(tasklist); 
        cs.SALES_ORDER_NUMBER = '12345678';
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'sofiya.peermohamed@nttdata.com'; 
        cs.ORDER_ENTERED_DT='2016-08-12' ;
        cs.CUSTOMER_REQUEST_DT='2021-04-01';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'PPO Downpayment document';
        cs.DESCRIPTION = 'PPO Downpayment document';
        cs.NotificationNumber='672345';
        cs.REPAIR_LOCATION = '4144';
        cs.SAP_ACCOUNT_NAME = '0000300952';
        cs.CUSTOMER_EMAIL_VBAK = 'test@test.com';
        cs.ACCOUNT_NAME='1+5Y1+1502';
        cs.CASENUMBER = '';
        cs.ZTASKITEMS = zlst;
        cs.Userstatuslst= usrlst; 
        
         SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        
        Test.stopTest();
    }
    testMethod static void SI_SAPtoSFDCTest2(){
    Test.startTest();
        Account acc= [Select Id,Name from Account where Strategic_Business_Unit__c='ATR' LIMIT 1];
        //insert acc;
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',Account_Name__c=acc.id,External_Account_ID__c='3456',Site_Code__c='765');
        insert acref;
        Plant_Code_Master__c Plt=new Plant_Code_Master__c(name='test plant',SAP_Plant_Code__c='4093');
        insert plt;
        Product2 pr= new Product2(name='Test Product',Product_Number__c='23145');
        insert pr;
        
        Account act=[select id,name,Sbl_Account_Row_Id__c,REPORT_ACCOUNT_NAME__c from account where id=:acc.id];
        Account_Cross_Ref__c acrf=[select id,name,Account_Name__r.Sbl_Account_Row_Id__c,External_Account_ID__c,Site_Code__c from Account_Cross_Ref__c where id=:acref.id];
        Plant_Code_Master__c plnt=[SELECT Name,id,SAP_Plant_Code__c FROM Plant_Code_Master__c where id=:plt.id];
        Product2 pro=[SELECT Id,Product_Number__c FROM Product2 where id=:pr.id];
        
       SI_SAPtoSFDCServiceclass.RnO_CASE_cls cs = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls(); 
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();  
        usr.Status = 'Open'; 
        usr.ParentObjectNo = '3213';
        usr.CaseNumber = '236789';
        usr.NotificationNumber = '00023435';  
        usrlst.add(usr);
        
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS tasklist= new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();    
      
        tasklist.Tasktype='Z106 Order Review and Completion';
        tasklist.Type='Task Creation';
        tasklist.TaskNumber='24234';
        //tasklist.Taskid=zz.id;      
        tasklist.TaskShorttext='Test';
        tasklist.Tasklongtext='Test';
           
        zlst.add(tasklist); 
        
        cs.ACCOUNT_NAME = act.Sbl_Account_Row_Id__c;
        cs.SAP_ACCOUNT_NAME =acrf.External_Account_ID__c;
        cs.REPAIR_LOCATION = plnt.SAP_Plant_Code__c;
        cs.PRODUCT_NUM = pro.Product_Number__c;
        cs.SALES_ORDER_NUMBER = '12345678';
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'sofiya.peermohamed@nttdata.com'; 
        cs.ORDER_ENTERED_DT = '17-08-2016';
        cs.CUSTOMER_REQUEST_DT = '17-08-2016';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.STATUS = 'Open';
        cs.SUB_CLASS = 'Test';
        cs.SUBJECT = 'Test';
        cs.DESCRIPTION = 'PPO Downpayment document';
        cs.NotificationNumber='672345';
        cs.PRODUCT_SERIAL_NUM = '232';
        cs.ORDER_ENTERED_DT='2016-08-12' ;
        cs.CUSTOMER_REQUEST_DT='2021-04-01';
        cs.CUSTOMER_EMAIL_VBAK = 'test@test.com';
        cs.Caseowner='Aero Default';
        cs.CaseType = 'UFR PO Mismatch';
        cs.SPEX_EXG_IND = 'Test'; 
        cs.CASENUMBER = '';
        cs.ZTASKITEMS = zlst;
        cs.Userstatuslst= usrlst; 
        cs.Y1_PARTNER_FIRSTNAME = 'Test';
        cs.Y1_PARTNER_LASTNAME = 'Contact';
        cs.Y1_PARTNER_EMAIL = 'test@test.com';
        cs.Y1_PARTNER_PHONE = '9876543210';
         SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        
        Test.stopTest();
    }
    testMethod static void SI_SAPtoSFDCTest44()
    {
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();  
        Test.startTest();
        Account acc= [Select Id,Name from Account where Strategic_Business_Unit__c='ATR' LIMIT 1];
        //insert acc;
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',Account_Name__c=acc.id,External_Account_ID__c='3456',Site_Code__c='765');
        insert acref;
        Plant_Code_Master__c Plt=new Plant_Code_Master__c(name='test plant',SAP_Plant_Code__c='4093');
        insert plt;
        Product2 pr= new Product2(name='Test Product',Product_Number__c='23145');
        insert pr;
        
        Account act=[select id,name,Sbl_Account_Row_Id__c,REPORT_ACCOUNT_NAME__c from account where id=:acc.id];
        Account_Cross_Ref__c acrf=[select id,name,Account_Name__r.Sbl_Account_Row_Id__c,External_Account_ID__c,Site_Code__c from Account_Cross_Ref__c where id=:acref.id];
        Plant_Code_Master__c plnt=[SELECT Name,id,SAP_Plant_Code__c FROM Plant_Code_Master__c where id=:plt.id];
        Product2 pro=[SELECT Id,Product_Number__c FROM Product2 where id=:pr.id];
        
        SI_SAPtoSFDCServiceclass.RnO_CASE_cls cas = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls();    
        cas.NotificationNumber = '000331353458'; 
       // cas.CUSTOMER_EMAIL_VBAK = 'nandini.nanjappan@nttdata.com';
        cas.ACCOUNT_NAME = act.Sbl_Account_Row_Id__c;
        cas.SAP_ACCOUNT_NAME =acrf.External_Account_ID__c;
        cas.REPAIR_LOCATION = plnt.SAP_Plant_Code__c;
        cas.PRODUCT_NUM = pro.Product_Number__c;
        cas.Caseowner = 'Aero Default';
        cas.ORDER_ENTERED_DT = '17-08-2016';
        cas.CUSTOMER_REQUEST_DT = '17-08-2016';
        cas.PRODUCT_SERIAL_NUM = '232';
        cas.SPEX_EXG_IND = 'Test';
        cas.QuoteNumber = '2324';
        cas.RESOLUTION = 'Test';
        cas.SALES_ORDER_NUMBER = '7678';
        cas.SAP_ACCOUNT_INFO = 'Testacct';
        cas.STATUS = 'Open';
        cas.SUB_CLASS = 'Test';
        cas.SUBJECT = 'Test';
        cas.CaseType = 'UFR PO Mismatch';
        cas.CUSTOMER_EMAIL_VBAK = 'nandini.nanjappan@nttdata.com';  
        cas.CASENUMBER=''; 
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS ztask= new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();      
        ztask.TaskNumber = '434523';
        zlst.add(ztask);
        cas.ZTASKITEMS = zlst;
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();  
        usr.Status = 'Open'; 
        usr.ParentObjectNo = '3213';   
        usrlst.add(usr);
        cas.Userstatuslst= usrlst;
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cas);
        
        Test.stopTest();
    } 
    testMethod static void SI_SAPtoSFDCUpdateTest(){
       
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        cas.Quote_Number__c = '3456';
        cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        cas.Repair_Notification_Number__c='12345';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        insert cas;
        
        Test.startTest();
         Case c = [select id,CaseNumber,Description, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
         string casenum=c.casenumber;
        //List<SAPtoSFDCServiceclass.Attachmentlist> at1 = new List<SAPtoSFDCServiceclass.Attachmentlist >();
        
       SI_SAPtoSFDCServiceclass.RnO_CASE_cls cs = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls(); 
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();  
        usr.Status = 'Open'; 
        usr.ParentObjectNo = '3213';
        usr.CaseNumber = '236789';
        usr.NotificationNumber = '00023435';  
        usrlst.add(usr);
        
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS tasklist= new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();    
      
        tasklist.Tasktype='Z106 Order Review and Completion';
        tasklist.Type='Task Creation';
        tasklist.TaskNumber='24234';
        //tasklist.Taskid=zz.id;      
        tasklist.TaskShorttext='Test';
        tasklist.Tasklongtext='Test';
           
        zlst.add(tasklist); 
        
        cs.SALES_ORDER_NUMBER = '12345678';
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'sofiya.peermohamed@nttdata.com'; 
        cs.ORDER_ENTERED_DT='2016-08-12' ;
        cs.CUSTOMER_REQUEST_DT='2021-04-01';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'PPO Downpayment document';
        cs.DESCRIPTION = 'PPO Downpayment document';
        cs.NotificationNumber='12345';
        cs.REPAIR_LOCATION = '4144';
        cs.SAP_ACCOUNT_NAME = '0000300952';
        cs.CUSTOMER_EMAIL_VBAK = 'nandini.nanjappan@nttdata.com';
        cs.CASENUMBER = casenum.subString(5,casenum.length());
        cs.ZTASKITEMS = zlst;
        cs.Userstatuslst= usrlst; 
        cs.notificationnumber='000331353458';
        cs.Y1_PARTNER_FIRSTNAME = 'Test';
        cs.Y1_PARTNER_LASTNAME = 'Test';
        cs.Y1_PARTNER_EMAIL = 'test@test.com';
         SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        
        Test.stopTest();
    }
    testMethod static void SI_SAPtoSFDCUpdateTest1(){
       
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        cas.Repair_Notification_Number__c='12345';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        insert cas;
        
        Test.startTest();
         Case c = [select id,CaseNumber,Description,Repair_Notification_Number__c,Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
         string casenum=c.casenumber;
        //List<SAPtoSFDCServiceclass.Attachmentlist> at1 = new List<SAPtoSFDCServiceclass.Attachmentlist >();
        
       SI_SAPtoSFDCServiceclass.RnO_CASE_cls cs = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls(); 
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();  
        usr.Status = 'Open'; 
        usr.ParentObjectNo = '3213';
        usr.CaseNumber = '236789';
        usr.NotificationNumber = '00023435';  
        usrlst.add(usr);
        
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS tasklist= new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();    
      
        tasklist.Tasktype='Z106 Order Review and Completion';
        tasklist.Type='Task Creation';
        tasklist.TaskNumber='24234';
        //tasklist.Taskid=zz.id;      
        tasklist.TaskShorttext='Test';
        tasklist.Tasklongtext='Test';
           
        zlst.add(tasklist); 
        
        cs.SALES_ORDER_NUMBER = '12345678';
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'sofiya.peermohamed@nttdata.com'; 
        cs.ORDER_ENTERED_DT='2016-08-12' ;
        cs.CUSTOMER_REQUEST_DT='2021-04-01';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'PPO Downpayment document';
        cs.DESCRIPTION = 'PPO Downpayment document';
        cs.NotificationNumber=c.Repair_Notification_Number__c;
        cs.REPAIR_LOCATION = '4144';
        cs.QuoteNumber='84567';
        cs.SAP_ACCOUNT_NAME = '0000300952';
        cs.STATUS='Open';
        cs.Caseowner='Aero Default';
        cs.CUSTOMER_EMAIL_VBAK = 'test@test.com';
        cs.CASENUMBER ='';
        cs.ZTASKITEMS = zlst;
        cs.Userstatuslst= usrlst; 
        cs.Y1_PARTNER_FIRSTNAME = 'Test';
        cs.Y1_PARTNER_LASTNAME = 'Contact';
        cs.Y1_PARTNER_EMAIL = 'test@test.com';
        cs.Y1_PARTNER_PHONE = '';
         SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        
        Test.stopTest();
    }
    testMethod static void SI_SAPtoSFDCUpdateTest2(){
       
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        cas.Repair_Notification_Number__c='12345';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        insert cas;
        Account acc= [Select Id,Name from Account where Strategic_Business_Unit__c='ATR' LIMIT 1];
        //insert acc;
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',Account_Name__c=acc.id,External_Account_ID__c='3456',Site_Code__c='765');
        insert acref;
        Plant_Code_Master__c Plt=new Plant_Code_Master__c(name='test plant',SAP_Plant_Code__c='4093');
        insert plt;
        Product2 pr= new Product2(name='Test Product',Product_Number__c='23145');
        insert pr;
        
        Account act=[select id,name,Sbl_Account_Row_Id__c,REPORT_ACCOUNT_NAME__c from account where id=:acc.id];
        Account_Cross_Ref__c acrf=[select id,name,Account_Name__r.Sbl_Account_Row_Id__c,External_Account_ID__c,Site_Code__c from Account_Cross_Ref__c where id=:acref.id];
        Plant_Code_Master__c plnt=[SELECT Name,id,SAP_Plant_Code__c FROM Plant_Code_Master__c where id=:plt.id];
        Product2 pro=[SELECT Id,Product_Number__c FROM Product2 where id=:pr.id];
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Repair_Notification_Number__c,Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        string casenum=c.casenumber;
        //List<SAPtoSFDCServiceclass.Attachmentlist> at1 = new List<SAPtoSFDCServiceclass.Attachmentlist >();
        
        SI_SAPtoSFDCServiceclass.RnO_CASE_cls cs = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls(); 
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();  
        usr.Status = 'Open'; 
        usr.ParentObjectNo = '3213';
        usr.CaseNumber = '236789';
        usr.NotificationNumber = '00023435';  
        usrlst.add(usr);
        
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS tasklist= new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();    
      
        tasklist.Tasktype='Z106 Order Review and Completion';
        tasklist.Type='Task Creation';
        tasklist.TaskNumber=null;
        //tasklist.Taskid=zz.id;      
        tasklist.TaskShorttext='Test';
        tasklist.Tasklongtext='Test';
           
        zlst.add(tasklist); 
        cs.ACCOUNT_NAME = act.Sbl_Account_Row_Id__c;
        cs.SAP_ACCOUNT_NAME =acrf.External_Account_ID__c;
        cs.REPAIR_LOCATION = plnt.SAP_Plant_Code__c;
        cs.PRODUCT_NUM = pro.Product_Number__c;
        cs.SALES_ORDER_NUMBER = '12345678';
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'sofiya.peermohamed@nttdata.com'; 
        cs.ORDER_ENTERED_DT='2016-08-12' ;
        cs.CUSTOMER_REQUEST_DT='2021-04-01';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'PPO Downpayment document';
        cs.DESCRIPTION = 'PPO Downpayment document';
        cs.NotificationNumber='54389';
        cs.STATUS='Closed';
        cs.CaseType = 'UFR Unfunded PO';   
        cs.Caseowner='Aero Default';
        cs.QuoteNumber='84567';
        cs.CUSTOMER_EMAIL_VBAK = 'test@test.com';
        cs.CASENUMBER =casenum.subString(5,casenum.length());
        cs.ZTASKITEMS = zlst;
        cs.Userstatuslst= usrlst; 
        cs.WORKSCOPECHANGE='Test';
        cs.TESTFAILURENOTE='Test';
        cs.MAINTLOCATION='Test';
        cs.REPLEVEL='Test';
        cs.REPTYPE='Test';
        cs.ORDERCREATED_DATE='2016-08-12';
        cs.CUSTMATERIALNUM='67495';
        cs.CUSTMATERIALSERIAL='83920';
        cs.POPRICE='22';
        cs.ORDERPRICE='45';
        cs.STDSHORTTEXT='test';
        cs.WARRANTYREQ='test';
        cs.REMINDERFLAG='4';
        cs.REMINDERDAYS='4';
        cs.RAIDAY='2';
        
        
         SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        
        Test.stopTest();
    }
    testMethod static void SI_SAPtoSFDCUpdateTest3(){
       
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        cas.Repair_Notification_Number__c='12345';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        insert cas;
        
        Case c = [select id,CaseNumber,Description,Repair_Notification_Number__c,Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        
        ROI_Order_Information__c ROI=new ROI_Order_Information__c();
        ROI.CaseNumber__c=c.id;
        insert ROI;
        
        Account acc= [Select Id,Name from Account where Strategic_Business_Unit__c='ATR' LIMIT 1];
        //insert acc;
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',Account_Name__c=acc.id,External_Account_ID__c='3456',Site_Code__c='765');
        insert acref;
        Plant_Code_Master__c Plt=new Plant_Code_Master__c(name='test plant',SAP_Plant_Code__c='4093');
        insert plt;
        Product2 pr= new Product2(name='Test Product',Product_Number__c='23145');
        insert pr;
        
        Account act=[select id,name,Sbl_Account_Row_Id__c,REPORT_ACCOUNT_NAME__c from account where id=:acc.id];
        Account_Cross_Ref__c acrf=[select id,name,Account_Name__r.Sbl_Account_Row_Id__c,External_Account_ID__c,Site_Code__c from Account_Cross_Ref__c where id=:acref.id];
        Plant_Code_Master__c plnt=[SELECT Name,id,SAP_Plant_Code__c FROM Plant_Code_Master__c where id=:plt.id];
        Product2 pro=[SELECT Id,Product_Number__c FROM Product2 where id=:pr.id];
        ROI_Order_Information__c ro=[select id,CaseNumber__c,WORKSCOPE_CHANGE__c,TEST_FAILURE_NOTE__c,MAINT_LOCATION__c,REP_LEVEL__c,REP_TYPE__c,ORDER_CREATED_DATE__c,CUST_MATERIAL_NUM__c,CUST_MATERIAL_SERIAL__c,PO_PRICE__c,ORDER_PRICE__c,SI_STD_SHORT_TEXT__c,WARRANTY_REQ__c,SI_REMINDER_FLAG__c,SI_REMINDER_DAYS__c,RAI_DAYS__c from ROI_Order_Information__c where id=:ROI.id];
        
        Test.startTest();

        string casenum=c.casenumber;
        //List<SAPtoSFDCServiceclass.Attachmentlist> at1 = new List<SAPtoSFDCServiceclass.Attachmentlist >();
        
        SI_SAPtoSFDCServiceclass.RnO_CASE_cls cs = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls(); 
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();  
        usr.Status = 'Open'; 
        usr.ParentObjectNo = null;
        usr.CaseNumber = '236789';
        usr.NotificationNumber = '00023435';  
        usrlst.add(usr);
        
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS tasklist= new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();    
      
        tasklist.Tasktype='Z106 Order Review and Completion';
        tasklist.Type='Task Creation';
        tasklist.TaskNumber=null;
        //tasklist.Taskid=zz.id;      
        tasklist.TaskShorttext='Test';
        tasklist.Tasklongtext='Test';
           
        zlst.add(tasklist); 
        cs.ACCOUNT_NAME = act.Sbl_Account_Row_Id__c;
        cs.SAP_ACCOUNT_NAME =acrf.External_Account_ID__c;
        cs.REPAIR_LOCATION = plnt.SAP_Plant_Code__c;
        cs.PRODUCT_NUM = pro.Product_Number__c;
        cs.SALES_ORDER_NUMBER = '12345678';
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'sofiya.peermohamed@nttdata.com'; 
        cs.ORDER_ENTERED_DT='2016-08-12';
        cs.CUSTOMER_REQUEST_DT='2021-04-01';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'PPO Downpayment document';
        cs.DESCRIPTION = 'PPO Downpayment document';
        cs.NotificationNumber='54389';
        cs.STATUS='Closed';
        cs.CaseType = 'UFR Unfunded PO';   
        cs.Caseowner='Aero Default';
        cs.QuoteNumber='84567';
        cs.CUSTOMER_EMAIL_VBAK = 'test@test.com';
        cs.Y1_PARTNER_FIRSTNAME = 'Test';
        cs.Y1_PARTNER_LASTNAME = 'Contact';
        cs.Y1_PARTNER_EMAIL = 'test@test.com';
        cs.Y1_PARTNER_PHONE = '9876543210';
        cs.CASENUMBER =casenum.subString(5,casenum.length());
        cs.ZTASKITEMS = zlst;
        cs.Userstatuslst= usrlst; 
        cs.WORKSCOPECHANGE='Test';
        cs.TESTFAILURENOTE='Test';
        cs.MAINTLOCATION='Test';
        cs.REPLEVEL='Test';
        cs.REPTYPE='Test';
        cs.ORDERCREATED_DATE='2016-08-12';
        cs.CUSTMATERIALNUM='67495';
        cs.CUSTMATERIALSERIAL='83920';
        cs.POPRICE='22';
        cs.ORDERPRICE='45';
        cs.STDSHORTTEXT='test';
        cs.WARRANTYREQ='test';
        cs.REMINDERFLAG='4';
        cs.REMINDERDAYS='4';
        cs.RAIDAY='2';
        
         SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        
        Test.stopTest();
    }
     testMethod static void SI_SAPtoSFDCUpdateTest4(){
       
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        cas.Repair_Notification_Number__c='12345';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        insert cas;
        
        Test.startTest();
         Case c = [select id,CaseNumber,Description,Repair_Notification_Number__c,Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
         string casenum=c.casenumber;
        //List<SAPtoSFDCServiceclass.Attachmentlist> at1 = new List<SAPtoSFDCServiceclass.Attachmentlist >();
        
       SI_SAPtoSFDCServiceclass.RnO_CASE_cls cs = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls(); 
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();  
        usr.Status = 'Open'; 
        usr.ParentObjectNo = '3213';
        usr.CaseNumber = '236789';
        usr.NotificationNumber = '00023435';  
        usrlst.add(usr);
        
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS tasklist= new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();    
      
        tasklist.Tasktype='Z106 Order Review and Completion';
        tasklist.Type='Task Creation';
        tasklist.TaskNumber='24234';
        //tasklist.Taskid=zz.id;      
        tasklist.TaskShorttext='Test';
        tasklist.Tasklongtext='Test';
           
        zlst.add(tasklist); 
        
        cs.SALES_ORDER_NUMBER = '12345678';
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'sofiya.peermohamed@nttdata.com'; 
        cs.ORDER_ENTERED_DT='2016-08-12' ;
        cs.CUSTOMER_REQUEST_DT='2021-04-01';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'PPO Downpayment document';
        cs.DESCRIPTION = 'PPO Downpayment document';
        cs.NotificationNumber=c.Repair_Notification_Number__c;
        cs.REPAIR_LOCATION = '4144';
        cs.QuoteNumber='84567';
        cs.CaseType = 'UFR PO Mismatch'; 
        cs.APUWorkcenter='test';
        cs.CaseObjectNo='007';  
        cs.SAP_ACCOUNT_NAME = '0000300952';
        cs.STATUS='Open';
        cs.Caseowner='Aero Default';
        cs.CUSTOMER_EMAIL_VBAK = 'test@test.com';
        cs.CASENUMBER ='';
        cs.ZTASKITEMS = zlst;
        cs.Userstatuslst= usrlst; 
        
         SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        
        Test.stopTest();
    }
         testMethod static void SI_SAPtoSFDCUpdateTest5(){
         
          Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        cas.Repair_Notification_Number__c='12345';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        insert cas;
        
        Z_Task__c zt11 = new Z_Task__c();
        zt11.SAP_ZTask_Number__c = 'Test123';
        zt11.Name = 'Tasktest1';
        zt11.RelatedTo__c = cas.id;
        zt11.Short_Text__c = 'Test';
        zt11.Comments__c = 'Test Ztask';
        zt11.Long_Text__c = 'Test122';
        zt11.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
        zt11.Other_Short_Text__c = 'Test text';
        zt11.Status__c = 'Open';
        insert zt11;
        
        Activitiy_Line_Item__c ac = new Activitiy_Line_Item__c();
        ac.SAPUserStatusObjectNumber__c='Case234';
        ac.ParentRoot__c='Task';
        ac.ParentObjectNo__c='35262';
        ac.Case__c=cas.id;
        ac.Task_Activities__c=zt11.id;
        ac.Status__c='open';
        ac.Description__c='test';
        ac.Email_Status__c='open';
        ac.Email_flag__c=true;
        //ac.CaseNumber__c=cas.casenumber;
        //ac.DateCompare__c=true;
        ac.LastModifiedDate=date.today();
        ac.CreatedDate=date.today();
        //ac.name='test';
        insert ac;
        
        ROI_Order_Information__c roi= new ROI_Order_Information__c();
        roi.CaseNumber__c=cas.id;
        roi.Customer_Email_ID__c='sofiya.peermohamed@nttdata.com';
        roi.RAI_DAYS__c='10';
        insert roi;
        
        Account acc= [Select Id,Name from Account where Strategic_Business_Unit__c='ATR' LIMIT 1];
        //insert acc;
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',Account_Name__c=acc.id,External_Account_ID__c='3456',Site_Code__c='765');
        insert acref;
        Plant_Code_Master__c Plt=new Plant_Code_Master__c(name='test plant',SAP_Plant_Code__c='4093');
        insert plt;
        Product2 pr= new Product2(name='Test Product',Product_Number__c='23145');
        insert pr;
        
        Account act=[select id,name,Sbl_Account_Row_Id__c,REPORT_ACCOUNT_NAME__c from account where id=:acc.id];
        Account_Cross_Ref__c acrf=[select id,name,Account_Name__r.Sbl_Account_Row_Id__c,External_Account_ID__c,Site_Code__c from Account_Cross_Ref__c where id=:acref.id];
        Plant_Code_Master__c plnt=[SELECT Name,id,SAP_Plant_Code__c FROM Plant_Code_Master__c where id=:plt.id];
        Product2 pro=[SELECT Id,Product_Number__c FROM Product2 where id=:pr.id];
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Repair_Notification_Number__c,Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        string casenum=c.casenumber;
       
        Z_Task__c zt=[select Name,Id,SAP_ZTask_Number__c,Long_Text__c,Language_Key__c,Sub_Type__c from Z_Task__c where id=:zt11.id];
        Activitiy_Line_Item__c us=[select id,name,Case__c,CaseNumber__c,CreatedDate,LastModifiedDate,DateCompare__c,ParentObjectNo__c,Email_flag__c,Email_Status__c,Description__c,SAPUserStatusObjectNumber__c,Status__c,Task_Activities__c from Activitiy_Line_Item__c where id=:ac.id];
        ROI_Order_Information__c RO=[select id,CaseNumber__c,Customer_Email_ID__c from ROI_Order_Information__c where id=:roi.id];
         
        
        
        SI_SAPtoSFDCServiceclass.RnO_CASE_cls cs = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls(); 
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();
        
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();  
        usr.Status = 'Open'; 
        usr.ParentObjectNo = '3213';
        usr.CaseNumber = c.casenumber;
        usr.ParentRoot = 'Case234';
        usr.NotificationNumber = '00023435'; 
        usr.SAPUserStatusObjectNumber=us.SAPUserStatusObjectNumber__c;
        usrlst.add(usr);
        
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS tasklist= new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();    
        tasklist.Tasktype='Z106 Order Review and Completion';
        tasklist.Type='Task Creation';
        tasklist.TaskNumber=null;
        //tasklist.Taskid=zz.id;      
        tasklist.TaskShorttext='Test';
        tasklist.Tasklongtext='Test';
        zlst.add(tasklist); 
           
     
        cs.ACCOUNT_NAME = act.Sbl_Account_Row_Id__c;
        cs.SAP_ACCOUNT_NAME =acrf.External_Account_ID__c;
        cs.REPAIR_LOCATION = plnt.SAP_Plant_Code__c;
        cs.PRODUCT_NUM = pro.Product_Number__c;
        cs.SALES_ORDER_NUMBER = '12345678';
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'sofiya.peermohamed@nttdata.com'; 
        cs.ORDER_ENTERED_DT='2016-08-12' ;
        cs.CUSTOMER_REQUEST_DT='12/08/2016';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'PPO Downpayment document';
        cs.DESCRIPTION = 'PPO Downpayment document';
        cs.NotificationNumber=c.Repair_Notification_Number__c;
        cs.STATUS='Closed';
        cs.CaseType = 'UFR Unfunded PO';   
        cs.Caseowner='Aero Default';
        cs.QuoteNumber='84567';
        cs.CUSTOMER_EMAIL_VBAK = 'test@test.com';
        cs.CASENUMBER =casenum.subString(5,casenum.length());
        cs.ZTASKITEMS = zlst;
        cs.Userstatuslst= usrlst; 
        cs.WORKSCOPECHANGE='Test';
        cs.TESTFAILURENOTE='Test';
        cs.MAINTLOCATION='Test';
        cs.REPLEVEL='Test';
        cs.REPTYPE='Test';
        cs.ORDERCREATED_DATE='2016-08-12';
        cs.CUSTMATERIALNUM='67495';
        cs.CUSTMATERIALSERIAL='83920';
        cs.POPRICE='22';
        cs.ORDERPRICE='45';
        cs.STDSHORTTEXT='test';
        cs.WARRANTYREQ='test';
        cs.REMINDERFLAG='4';
        cs.REMINDERDAYS='4';
        cs.RAIDAY='2';
        
        
         SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        
        Test.stopTest();
       
    }
      testMethod static void SI_SAPtoSFDCUpdateTest6(){
         
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        cas.Repair_Notification_Number__c='12345';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        insert cas;
        
        Z_Task__c zt11 = new Z_Task__c();
        zt11.SAP_ZTask_Number__c = 'Test123';
        zt11.Name = 'Tasktest1';
        zt11.RelatedTo__c = cas.id;
        zt11.Short_Text__c = 'Test';
        zt11.Comments__c = 'Test Ztask';
        zt11.Long_Text__c = 'Test122';
        zt11.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
        zt11.Other_Short_Text__c = 'Test text';
        zt11.Status__c = 'Open';
        insert zt11;
        
        Activitiy_Line_Item__c ac = new Activitiy_Line_Item__c();
        ac.SAPUserStatusObjectNumber__c='Case234';
        ac.ParentRoot__c='Task';
        ac.ParentObjectNo__c='35262';
        ac.Case__c=cas.id;
        ac.Task_Activities__c=zt11.id;
        ac.Status__c='open';
        ac.Description__c='test';
        ac.Email_Status__c='open';
        ac.Email_flag__c=true;
        //ac.CaseNumber__c=cas.casenumber;
        //ac.DateCompare__c=true;
        ac.LastModifiedDate=date.today();
        ac.CreatedDate=date.today();
        //ac.name='test';
        insert ac;
        
        ROI_Order_Information__c roi= new ROI_Order_Information__c();
        roi.CaseNumber__c=cas.id;
        roi.Customer_Email_ID__c='sofiya.peermohamed@nttdata.com';
        roi.RAI_DAYS__c='10';
        insert roi;
        
        Account acc= [Select Id,Name from Account where Strategic_Business_Unit__c='ATR' LIMIT 1];
        //insert acc;
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',Account_Name__c=acc.id,External_Account_ID__c='3456',Site_Code__c='765');
        insert acref;
        Plant_Code_Master__c Plt=new Plant_Code_Master__c(name='test plant',SAP_Plant_Code__c='4093');
        insert plt;
        Product2 pr= new Product2(name='Test Product',Product_Number__c='23145');
        insert pr;
        
        Account act=[select id,name,Sbl_Account_Row_Id__c,REPORT_ACCOUNT_NAME__c from account where id=:acc.id];
        Account_Cross_Ref__c acrf=[select id,name,Account_Name__r.Sbl_Account_Row_Id__c,External_Account_ID__c,Site_Code__c from Account_Cross_Ref__c where id=:acref.id];
        Plant_Code_Master__c plnt=[SELECT Name,id,SAP_Plant_Code__c FROM Plant_Code_Master__c where id=:plt.id];
        Product2 pro=[SELECT Id,Product_Number__c FROM Product2 where id=:pr.id];
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Repair_Notification_Number__c,Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        string casenum=c.casenumber;
       
        Z_Task__c zt=[select Name,Id,SAP_ZTask_Number__c,Long_Text__c,Language_Key__c,Sub_Type__c from Z_Task__c where id=:zt11.id];
        Activitiy_Line_Item__c us=[select id,name,Case__c,CaseNumber__c,CreatedDate,LastModifiedDate,DateCompare__c,ParentObjectNo__c,Email_flag__c,Email_Status__c,Description__c,SAPUserStatusObjectNumber__c,Status__c,Task_Activities__c from Activitiy_Line_Item__c where id=:ac.id];
        ROI_Order_Information__c RO=[select id,CaseNumber__c,Customer_Email_ID__c from ROI_Order_Information__c where id=:roi.id];
         
        
        
        SI_SAPtoSFDCServiceclass.RnO_CASE_cls cs = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls(); 
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();
        
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();  
        usr.Status = 'Open'; 
        usr.ParentObjectNo = '3213';
        usr.CaseNumber = c.casenumber;
        usr.ParentRoot = 'Case234';
        usr.NotificationNumber = '00023435'; 
        //usr.SAPUserStatusObjectNumber=us.SAPUserStatusObjectNumber__c;
        usrlst.add(usr);
        
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS tasklist= new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();    
        tasklist.Tasktype='Z106 Order Review and Completion';
        tasklist.Type='Task Creation';
        tasklist.TaskNumber=null;
        //tasklist.Taskid=zz.id;      
        tasklist.TaskShorttext='Test';
        tasklist.Tasklongtext='Test';
        zlst.add(tasklist); 
           
     
        cs.ACCOUNT_NAME = act.Sbl_Account_Row_Id__c;
        cs.SAP_ACCOUNT_NAME =acrf.External_Account_ID__c;
        cs.REPAIR_LOCATION = plnt.SAP_Plant_Code__c;
        cs.PRODUCT_NUM = pro.Product_Number__c;
        cs.SALES_ORDER_NUMBER = '12345678';
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'sofiya.peermohamed@nttdata.com'; 
        cs.ORDER_ENTERED_DT='2016-08-12' ;
        cs.CUSTOMER_REQUEST_DT='2021-04-01';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'PPO Downpayment document';
        cs.DESCRIPTION = 'PPO Downpayment document';
        cs.NotificationNumber=c.Repair_Notification_Number__c;
        cs.STATUS='Closed';
        cs.CaseType = 'UFR Unfunded PO';   
        cs.Caseowner='Aero Default';
        cs.QuoteNumber='84567';
        cs.CUSTOMER_EMAIL_VBAK = 'test@test.com';
        cs.CASENUMBER =casenum.subString(5,casenum.length());
        cs.ZTASKITEMS = zlst;
        cs.Userstatuslst= usrlst; 
        cs.WORKSCOPECHANGE='Test';
        cs.TESTFAILURENOTE='Test';
        cs.MAINTLOCATION='Test';
        cs.REPLEVEL='Test';
        cs.REPTYPE='Test';
        cs.ORDERCREATED_DATE='2016-08-12';
        cs.CUSTMATERIALNUM='67495';
        cs.CUSTMATERIALSERIAL='83920';
        cs.POPRICE='22';
        cs.ORDERPRICE='45';
        cs.STDSHORTTEXT='test';
        cs.WARRANTYREQ='test';
        cs.REMINDERFLAG='4';
        cs.REMINDERDAYS='4';
        cs.RAIDAY='2';
        
        
         SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        
        Test.stopTest();
       
    }
    testMethod static void SI_SAPtoSFDCUpdateTest7(){
         
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        cas.Repair_Notification_Number__c='12345';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        insert cas;
        
        Z_Task__c zt11 = new Z_Task__c();
        zt11.SAP_ZTask_Number__c = 'Test123';
        zt11.Name = 'Tasktest1';
        zt11.RelatedTo__c = cas.id;
        zt11.Short_Text__c = 'Test';
        zt11.Comments__c = 'Test Ztask';
        zt11.Long_Text__c = 'Test122';
        zt11.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
        zt11.Other_Short_Text__c = 'Test text';
        zt11.Status__c = 'Open';
        insert zt11;
        
        Activitiy_Line_Item__c ac = new Activitiy_Line_Item__c();
        ac.SAPUserStatusObjectNumber__c='Task234';
        ac.ParentRoot__c='Task';
        ac.ParentObjectNo__c='35262';
        ac.Case__c=cas.id;
        ac.Task_Activities__c=zt11.id;
        ac.Status__c='open';
        ac.Description__c='test';
        ac.Email_Status__c='open';
        ac.Email_flag__c=true;
        //ac.CaseNumber__c=cas.casenumber;
        //ac.DateCompare__c=true;
        ac.LastModifiedDate=date.today();
        ac.CreatedDate=date.today();
        //ac.name='test';
        insert ac;
        
        ROI_Order_Information__c roi= new ROI_Order_Information__c();
        roi.CaseNumber__c=cas.id;
        roi.Customer_Email_ID__c='sofiya.peermohamed@nttdata.com';
        roi.RAI_DAYS__c='10';
        insert roi;
        
        Account acc= [Select Id,Name from Account where Strategic_Business_Unit__c='ATR' LIMIT 1];
        //insert acc;
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',Account_Name__c=acc.id,External_Account_ID__c='3456',Site_Code__c='765');
        insert acref;
        Plant_Code_Master__c Plt=new Plant_Code_Master__c(name='test plant',SAP_Plant_Code__c='4093');
        insert plt;
        Product2 pr= new Product2(name='Test Product',Product_Number__c='23145');
        insert pr;
        
        Account act=[select id,name,Sbl_Account_Row_Id__c,REPORT_ACCOUNT_NAME__c from account where id=:acc.id];
        Account_Cross_Ref__c acrf=[select id,name,Account_Name__r.Sbl_Account_Row_Id__c,External_Account_ID__c,Site_Code__c from Account_Cross_Ref__c where id=:acref.id];
        Plant_Code_Master__c plnt=[SELECT Name,id,SAP_Plant_Code__c FROM Plant_Code_Master__c where id=:plt.id];
        Product2 pro=[SELECT Id,Product_Number__c FROM Product2 where id=:pr.id];
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Repair_Notification_Number__c,Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        string casenum=c.casenumber;
       
        Z_Task__c zt=[select Name,Id,SAP_ZTask_Number__c,Long_Text__c,Language_Key__c,Sub_Type__c from Z_Task__c where id=:zt11.id];
        Activitiy_Line_Item__c us=[select id,name,Case__c,CaseNumber__c,CreatedDate,LastModifiedDate,DateCompare__c,ParentObjectNo__c,Email_flag__c,Email_Status__c,Description__c,SAPUserStatusObjectNumber__c,Status__c,Task_Activities__c from Activitiy_Line_Item__c where id=:ac.id];
        ROI_Order_Information__c RO=[select id,CaseNumber__c,Customer_Email_ID__c from ROI_Order_Information__c where id=:roi.id];
                      
        SI_SAPtoSFDCServiceclass.RnO_CASE_cls cs = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls(); 
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();
        
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();  
        usr.Status = 'Open'; 
        usr.ParentObjectNo = '3213';
        usr.CaseNumber = c.casenumber;
        usr.ParentRoot = 'Task234';
        usr.NotificationNumber = '00023435'; 
        usr.SAPUserStatusObjectNumber=us.SAPUserStatusObjectNumber__c;
        usrlst.add(usr);
        
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS tasklist= new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();    
        tasklist.Tasktype='Z106 Order Review and Completion';
        tasklist.Type='Task Creation';
        tasklist.TaskNumber='24234';
        tasklist.Taskid=zt.id;      
        tasklist.TaskShorttext='Test';
        tasklist.Tasklongtext='Test';
        zlst.add(tasklist); 
           
     
        cs.ACCOUNT_NAME = act.Sbl_Account_Row_Id__c;
        cs.SAP_ACCOUNT_NAME =acrf.External_Account_ID__c;
        cs.REPAIR_LOCATION = plnt.SAP_Plant_Code__c;
        cs.PRODUCT_NUM = pro.Product_Number__c;
        cs.SALES_ORDER_NUMBER = '12345678';
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'sofiya.peermohamed@nttdata.com'; 
        cs.ORDER_ENTERED_DT='2016-08-12' ;
        cs.CUSTOMER_REQUEST_DT='2021-04-01';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'PPO Downpayment document';
        cs.DESCRIPTION = 'PPO Downpayment document';
        cs.NotificationNumber=c.Repair_Notification_Number__c;
        cs.STATUS='Closed';
        cs.CaseType = 'UFR Unfunded PO';   
        cs.Caseowner='Aero Default';
        cs.QuoteNumber='84567';
        cs.CUSTOMER_EMAIL_VBAK = 'test@test.com';
        cs.CASENUMBER =casenum.subString(5,casenum.length());
        cs.ZTASKITEMS = zlst;
        cs.Userstatuslst= usrlst; 
        cs.WORKSCOPECHANGE='Test';
        cs.TESTFAILURENOTE='Test';
        cs.MAINTLOCATION='Test';
        cs.REPLEVEL='Test';
        cs.REPTYPE='Test';
        cs.ORDERCREATED_DATE='2016-08-12';
        cs.CUSTMATERIALNUM='67495';
        cs.CUSTMATERIALSERIAL='83920';
        cs.POPRICE='22';
        cs.ORDERPRICE='45';
        cs.STDSHORTTEXT='test';
        cs.WARRANTYREQ='test';
        cs.REMINDERFLAG='4';
        cs.REMINDERDAYS='4';
        cs.RAIDAY='2';
                
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);       
        Test.stopTest();      
    }
    testMethod static void SI_SAPtoSFDCUpdateTest8(){
         
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        cas.Repair_Notification_Number__c='12345';
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        insert cas;
                
        Z_Task__c zt11 = new Z_Task__c();
        zt11.SAP_ZTask_Number__c = 'Test123';
        zt11.Name = 'Tasktest1';
        zt11.RelatedTo__c = cas.id;
        zt11.Short_Text__c = 'Test & and <> and "';
        zt11.Comments__c = 'Test Ztask';
        zt11.Long_Text__c = 'Test122 & and <> and "';
        zt11.New_Long_Text__c='Test122 & and <> and "';
        zt11.Sub_Type__c = 'Test & and <> and "';
        zt11.Other_Short_Text__c = 'Test text';
        zt11.Status__c = 'Open';
        zt11.Followuptask__c=false;
        zt11.ownerid=label.CSO_R_O_Team;
        insert zt11;
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());
        set<id> ztaskid=new set<id>();
        ztaskid.add(zt11.id);
        //SI_ZtaskStatustoSAP.SendTaskStatus(ztaskid);
        List<id> ztaskid1=new List<id>();
        ztaskid1.add(zt11.id);
        SI_ZtaskStatustoSAP1.SendTaskStatus(ztaskid1);
        Activitiy_Line_Item__c ac = new Activitiy_Line_Item__c();
        ac.SAPUserStatusObjectNumber__c='Task234';
        ac.ParentRoot__c='Task';
        ac.ParentObjectNo__c='35262';
        ac.Case__c=cas.id;
        ac.Task_Activities__c=zt11.id;
        ac.Status__c='open';
        ac.Description__c='test';
        ac.Email_Status__c='open';
        ac.Email_flag__c=true;
        //ac.LastModifiedDate=date.today();
        //ac.CreatedDate=today();
        insert ac;
        
        ROI_Order_Information__c roi= new ROI_Order_Information__c();
        roi.CaseNumber__c=cas.id;
        roi.Customer_Email_ID__c='sofiya.peermohamed@nttdata.com';
        roi.RAI_DAYS__c='10';
        insert roi;
        
        Account acc= [Select Id,Name from Account where Strategic_Business_Unit__c='ATR' LIMIT 1];
        //insert acc;
        Account_Cross_Ref__c acref= new Account_Cross_Ref__c(name='test',Account_Name__c=acc.id,External_Account_ID__c='3456',Site_Code__c='765');
        insert acref;
        Plant_Code_Master__c Plt=new Plant_Code_Master__c(name='test plant',SAP_Plant_Code__c='4093');
        insert plt;
        Product2 pr= new Product2(name='Test Product',Product_Number__c='23145');
        insert pr;
        
        Account act=[select id,name,Sbl_Account_Row_Id__c,REPORT_ACCOUNT_NAME__c from account where id=:acc.id];
        Account_Cross_Ref__c acrf=[select id,name,Account_Name__r.Sbl_Account_Row_Id__c,External_Account_ID__c,Site_Code__c from Account_Cross_Ref__c where id=:acref.id];
        Plant_Code_Master__c plnt=[SELECT Name,id,SAP_Plant_Code__c FROM Plant_Code_Master__c where id=:plt.id];
        Product2 pro=[SELECT Id,Product_Number__c FROM Product2 where id=:pr.id];
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Repair_Notification_Number__c,Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        string casenum=c.casenumber;
       
        Z_Task__c zt=[select Name,Id,SAP_ZTask_Number__c,Long_Text__c,Language_Key__c,Sub_Type__c from Z_Task__c where id=:zt11.id];
        Activitiy_Line_Item__c us=[select id,name,Case__c,CaseNumber__c,CreatedDate,LastModifiedDate,DateCompare__c,ParentObjectNo__c,Email_flag__c,Email_Status__c,Description__c,SAPUserStatusObjectNumber__c,Status__c,Task_Activities__c from Activitiy_Line_Item__c where id=:ac.id];
        ROI_Order_Information__c RO=[select id,CaseNumber__c,Customer_Email_ID__c from ROI_Order_Information__c where id=:roi.id];
              
        SI_SAPtoSFDCServiceclass.RnO_CASE_cls cs = new SI_SAPtoSFDCServiceclass.RnO_CASE_cls(); 
        List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS> zlst= new List<SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS>();
        List<SI_SAPtoSFDCServiceclass.Userstatus> usrlst= new List<SI_SAPtoSFDCServiceclass.Userstatus>();
        
        SI_SAPtoSFDCServiceclass.Userstatus usr= new SI_SAPtoSFDCServiceclass.Userstatus();  
        usr.Status = 'Open'; 
        usr.ParentObjectNo = '3213';
        usr.CaseNumber = c.casenumber;
        usr.ParentRoot = 'Task234';
        usr.NotificationNumber = '00023435'; 
        //usr.SAPUserStatusObjectNumber=us.SAPUserStatusObjectNumber__c;
        usrlst.add(usr);
        
        SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS tasklist= new SI_SAPtoSFDCServiceclass.ZTASKITEMDETAILS();    
        tasklist.Tasktype='Z106 Order Review and Completion';
        tasklist.Type='Task Creation';
        tasklist.TaskNumber='24234';
        tasklist.Taskid=zt.id;      
        tasklist.TaskShorttext='Test';
        tasklist.Tasklongtext='Test';
        zlst.add(tasklist); 
                 
        cs.ACCOUNT_NAME = act.Sbl_Account_Row_Id__c;
        cs.SAP_ACCOUNT_NAME =acrf.External_Account_ID__c;
        cs.REPAIR_LOCATION = plnt.SAP_Plant_Code__c;
        cs.PRODUCT_NUM = pro.Product_Number__c;
        cs.SALES_ORDER_NUMBER = '12345678';
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'sofiya.peermohamed@nttdata.com'; 
        cs.ORDER_ENTERED_DT='2016-08-12' ;
        cs.CUSTOMER_REQUEST_DT='2021-04-01';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'PPO Downpayment document';
        cs.DESCRIPTION = 'PPO Downpayment document';
        cs.NotificationNumber=c.Repair_Notification_Number__c;
        cs.STATUS='Closed';
        cs.CaseType = 'UFR Unfunded PO';   
        cs.Caseowner='Aero Default';
        cs.QuoteNumber='84567';
        cs.CUSTOMER_EMAIL_VBAK = 'test@test.com';
        cs.CASENUMBER =casenum.subString(5,casenum.length());
        cs.ZTASKITEMS = zlst;
        cs.Userstatuslst= usrlst; 
        cs.WORKSCOPECHANGE='Test';
        cs.TESTFAILURENOTE='Test';
        cs.MAINTLOCATION='Test';
        cs.REPLEVEL='Test';
        cs.REPTYPE='Test';
        cs.ORDERCREATED_DATE='2016-08-12';
        cs.CUSTMATERIALNUM='67495';
        cs.CUSTMATERIALSERIAL='83920';
        cs.POPRICE='22';
        cs.ORDERPRICE='45';
        cs.STDSHORTTEXT='test';
        cs.WARRANTYREQ='test';
        cs.REMINDERFLAG='4';
        cs.REMINDERDAYS='4';
        cs.RAIDAY='2'; 
        cs.Y1_PARTNER_FIRSTNAME = 'Test';
        cs.Y1_PARTNER_LASTNAME = 'Test';
        cs.Y1_PARTNER_EMAIL = 'test@test.com';
        cs.Y1_PARTNER_PHONE = '9876543210';
        SI_SAPtoSFDCServiceclass.CaseDataSFDCtoSAP casetoportal = SI_SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);        
        Test.stopTest();       
    }
 }