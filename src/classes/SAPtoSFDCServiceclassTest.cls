@isTest(SeeAllData=true)
global class  SAPtoSFDCServiceclassTest{ 
    testMethod static void SAPtoSFDCTest(){
        Test.startTest();
   List<SAPtoSFDCServiceclass.Attachmentlist> at1 = new List<SAPtoSFDCServiceclass.Attachmentlist >();
        
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
        SAPtoSFDCServiceclass.Attachmentlist att = new  SAPtoSFDCServiceclass.Attachmentlist();
        att.Attbody='test';
        att.AttFileName='testfile'; 
        att.AttContentType='test'; 
        at1.add(att);
        
        cs.SALES_ORDER_NUMBER = '12345678';
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'sofiya.peermohamed@nttdata.com'; 
        cs.ORDER_ENTERED_DT='2016-08-12' ;
        cs.CUSTOMER_REQUEST_DT='12/08/2016';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'PPO Downpayment document';
        cs.DESCRIPTION = 'PPO Downpayment document';
       
        cs.REPAIR_LOCATION = '4144';
        cs.SAP_ACCOUNT_NAME = '0000300952';
        cs.CASENUMBER = '';
       
        cs.CaseType = 'ATR';
        cs.APUWorkcenter = 'ZRA';  
        cs.DistributionChannel = 'PPO';  
       /* SAPtoSFDCServiceclass.Attachmentlist att1 =new  SAPtoSFDCServiceclass.Attachmentlist();
        att1.Attbody='test';
        att1.AttFileName='testfile'; 
        att1.AttContentType='test'; 
        at1.add(att1);*/
        
        cs.Attachments=at1;
         
       
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP sfdcdata = SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        
        Test.stopTest();
    }
    
        testMethod static void SAPtoSFDCTest1(){
        Test.startTest();
        /*Account acc= new Account(name='Test Account123',Strategic_Business_Unit__c='ATR',Sbl_Account_Row_Id__c='123');
        insert acc;
        
        Account act=[select id,name,Sbl_Account_Row_Id__c from account where id=:acc.id];*/
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
      
        //cs.ACCOUNT_NAME=act.Sbl_Account_Row_Id__c;
        cs.SALES_ORDER_NUMBER = '12345678';
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'null'; 
        //cs.ORDER_ENTERED_DT= '17-08-2016';
        //cs.CUSTOMER_REQUEST_DT='17-08-2016';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'PPO Downpayment document';
        cs.DESCRIPTION = 'PPO Downpayment document';
       
        cs.REPAIR_LOCATION = '4144';
        cs.SAP_ACCOUNT_NAME = '0000300952';
        cs.CASENUMBER = '';
       
        cs.CaseType = 'ATR';
        cs.APUWorkcenter = 'ZRA';  
        cs.DistributionChannel = 'PPO';   
            
                      
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP sfdcdata = SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        Test.stopTest();
    }
    testMethod static void SAPtoSFDCTest2(){
        Test.startTest();
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
       // CreateCaseServiceclassPPO cs = new CreateCaseServiceclassPPO();
        cs.SALES_ORDER_NUMBER = '12345678';
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'null'; 
        //cs.ORDER_ENTERED_DT= '17-08-2016';
        //cs.CUSTOMER_REQUEST_DT='17-08-2016';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'PPO Downpayment document';
        cs.DESCRIPTION = 'PPO Downpayment document';
       
        //cs.REPAIR_LOCATION = 'null';
        //cs.SAP_ACCOUNT_NAME = 'null';
        cs.CASENUMBER = '';
       
        cs.CaseType = 'ATR';
        cs.APUWorkcenter = 'ZRA';  
        cs.DistributionChannel = 'PPO';   
        
        
           
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP sfdcdata = SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        Test.stopTest();
    }
    
    testMethod static void SAPtoSFDCTest3(){
        
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
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
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
       // CreateCaseServiceclassPPO cs = new CreateCaseServiceclassPPO();
        cs.SALES_ORDER_NUMBER = '12345678';
        cs.CUSTOMER_PO_RO_WO_NUM = 'CUSTPORO12345';        
        cs.CONTACT_EMAIL = 'sofiya.peermohamed@nttdata.com'; 
        cs.ORDER_ENTERED_DT= '2016-08-12';
        cs.CUSTOMER_REQUEST_DT='12/08/2016';
        cs.PRODUCT_SERIAL_NUM = '50001313';
        cs.SUBJECT = 'PPO Downpayment document';
        cs.DESCRIPTION = 'PPO Downpayment document';
       
        cs.REPAIR_LOCATION = '4144';
        cs.SAP_ACCOUNT_NAME = '0000300952';
        cs.CASENUMBER = c.casenumber;
       
        cs.CaseType = 'ATR';
        cs.APUWorkcenter = 'ZRPR';  
        cs.DistributionChannel = 'PPO'; 
        
        
        
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP sfdcdata = SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        
       
        Test.stopTest();
    }
    testMethod static void SAPtoSFDCTest4(){
        Test.startTest();
        List<SAPtoSFDCServiceclass.Attachmentlist> at1 = new List<SAPtoSFDCServiceclass.Attachmentlist >();
        
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
        cs.DistributionChannel = 'test'; 
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP sfdcdata = SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        //SAPtoSFDCServiceclass.CaseDataSFDCtoSAP sfdcdata = SAPtoSFDCServiceclass.RnO_CASE_cls();
        
        Test.stopTest();
    }
      
    testMethod static void SAPtoSFDCcaseclosetest(){
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
        /*Case_Extension__c ce = new Case_Extension__c();
        
        ce.Case_object__c=cas.id;
        insert ce;*/
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        //Case_Extension__c Casext = [select Case_object__c from Case_Extension__c where id=:ce.id];
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
       // CreateCaseServiceclassPPO cs = new CreateCaseServiceclassPPO();
        cs.SALES_ORDER_NUMBER = c.Sales_Order_Number__c;
        
        cs.RESOLUTION='Down payment received';
       
        cs.DESCRIPTION = 'Down payment received';
       
       
        cs.CASENUMBER = c.casenumber;
        cs.DistributionChannel = 'PPO Case Close';   
           
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP sfdcdata = SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        Test.stopTest();
    }
    testMethod static void SAPtoSFDCcaseclosetest1(){
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
       /* Case_Extension__c ce = new Case_Extension__c();
        
        ce.Case_object__c=cas.id;
        insert ce;*/
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        //Case_Extension__c Casext = [select Case_object__c from Case_Extension__c where id=:ce.id];
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
       // CreateCaseServiceclassPPO cs = new CreateCaseServiceclassPPO();
        cs.SALES_ORDER_NUMBER = c.Sales_Order_Number__c;
        
        cs.RESOLUTION='Cancelled due to non-payment';
       
        cs.DESCRIPTION ='Cancelled due to non-payment';
       
       
        cs.CASENUMBER = c.casenumber;
        
        cs.DistributionChannel = 'PPO Case Close';   
           
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP sfdcdata = SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        Test.stopTest();
    }
    testMethod static void SAPtoSFDCcaseclosetest2(){
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
        /*Case_Extension__c ce = new Case_Extension__c();
        
        ce.Case_object__c=cas.id;
        insert ce;*/
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        //Case_Extension__c Casext = [select Case_object__c from Case_Extension__c where id=:ce.id];
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
       // CreateCaseServiceclassPPO cs = new CreateCaseServiceclassPPO();
        cs.SALES_ORDER_NUMBER = c.Sales_Order_Number__c;
        
        cs.RESOLUTION='No Payment made 3-day';
       
        cs.DESCRIPTION ='No Payment made 3-day';
       
       
        cs.CASENUMBER = c.casenumber;
        
        cs.DistributionChannel = 'PPO Case Close';   
           
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP sfdcdata = SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        Test.stopTest();
    }
    testMethod static void SAPtoSFDCcaseclosetest3(){
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
        /*Case_Extension__c ce = new Case_Extension__c();
       
        ce.Case_object__c=cas.id;
        insert ce;*/
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        //Case_Extension__c Casext = [select Case_object__c from Case_Extension__c where id=:ce.id];
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
       // CreateCaseServiceclassPPO cs = new CreateCaseServiceclassPPO();
        cs.SALES_ORDER_NUMBER = c.Sales_Order_Number__c;
        
        cs.RESOLUTION='No Payment made 6-day';
       
        cs.DESCRIPTION ='No Payment made 6-day';
       
       
        cs.CASENUMBER = c.casenumber;
        
        cs.DistributionChannel = 'PPO Case Close';   
           
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP sfdcdata = SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        Test.stopTest();
    }
    testMethod static void SAPtoSFDCcaseclosetest4(){
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = label.Repair_Overhaul_RT_ID;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
        //Case_Extension__c Casext = [select Case_object__c from Case_Extension__c where id=:ce.id];
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
       // CreateCaseServiceclassPPO cs = new CreateCaseServiceclassPPO();
        cs.SALES_ORDER_NUMBER = c.Sales_Order_Number__c;
        
        cs.RESOLUTION='Down payment received';
       
        cs.DESCRIPTION = 'Down payment received';
       
        cs.CASENUMBER = c.casenumber;
       
        
        
        cs.DistributionChannel = 'PPO Case Close';   
           
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP sfdcdata = SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        Test.stopTest();
    }
    testMethod static void SAPtoSFDCCCReauthtest(){
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
       
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
       // CreateCaseServiceclassPPO cs = new CreateCaseServiceclassPPO();
        cs.SALES_ORDER_NUMBER = c.Sales_Order_Number__c;
        
        cs.SAP_ACCOUNT_NAME='12345';
       
        cs.SAP_ACCOUNT_INFO ='ZRA';
       
       
        cs.CASENUMBER = 'E854-7230-W8AH2B8ZVSGH6C';
       
        cs.CaseType = 'Master';
        
        cs.DistributionChannel = 'PPO Credit';   
           
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP sfdcdata = SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        Test.stopTest();
    }
    testMethod static void SAPtoSFDCCCReauthtest1(){
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = Label.Repair_Overhaul_RT_ID;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        cas.Repair_Notification_Number__c='12345';
        insert cas;
        
        
        Test.startTest();
        Case c = [select id,CaseNumber,Repair_Notification_Number__c,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
       
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
       // CreateCaseServiceclassPPO cs = new CreateCaseServiceclassPPO();
        cs.SALES_ORDER_NUMBER = c.Sales_Order_Number__c;
        
        cs.SAP_ACCOUNT_NAME='12345';
        cs.NotificationNumber=c.Repair_Notification_Number__c;
        cs.SAP_ACCOUNT_INFO ='ZRPR';
       
       
        cs.CASENUMBER = 'E854-7230-W8AH2B8ZVSGH6C';
       
        cs.CaseType = 'Master';
        
        cs.DistributionChannel = 'PPO Credit';   
           
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP sfdcdata = SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        Test.stopTest();
    }
    testMethod static void SAPtoSFDCCCReauthtest2(){
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'On Hold';  
        cas.Sub_Status__c= 'Business Hold';
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
       
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
       // CreateCaseServiceclassPPO cs = new CreateCaseServiceclassPPO();
        cs.SALES_ORDER_NUMBER = c.Sales_Order_Number__c;
        
        cs.SAP_ACCOUNT_NAME='12345';
       
        cs.SAP_ACCOUNT_INFO ='ZRA';
       
       
        cs.CASENUMBER = 'E854-7230-W8AH2B8ZVSGH6C';
       
        cs.CaseType = 'Master';
        
        cs.DistributionChannel = 'PPO Credit';   
           
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP sfdcdata = SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        Test.stopTest();
    }
    testMethod static void SAPtoSFDCCCReauthtest3(){
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'On Hold';  
        cas.Sub_Status__c= 'Business Hold';
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = Label.Repair_Overhaul_RT_ID;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='test case';
        cas.Sales_Order_Number__c =  '12345678';
        cas.Repair_Notification_Number__c='12345';
        insert cas;
        
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Repair_Notification_Number__c,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
       
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
       // CreateCaseServiceclassPPO cs = new CreateCaseServiceclassPPO();
        cs.SALES_ORDER_NUMBER = c.Sales_Order_Number__c;
        
        cs.SAP_ACCOUNT_NAME='12345';
       
        cs.SAP_ACCOUNT_INFO ='ZRPR';
       
        cs.NotificationNumber=c.Repair_Notification_Number__c;
        cs.CASENUMBER = 'E854-7230-W8AH2B8ZVSGH6C';
       
        cs.CaseType = 'Master';
        
        cs.DistributionChannel = 'PPO Credit';   
           
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP sfdcdata = SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        Test.stopTest();
    }
   
   testMethod static void SAPtoSFDCCCReauthtest4(){
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='Credit Card Re-Auth Error. Sales order Number - 0012345678';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
       
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
       // CreateCaseServiceclassPPO cs = new CreateCaseServiceclassPPO();
        cs.SALES_ORDER_NUMBER = c.Sales_Order_Number__c;
        
        cs.SAP_ACCOUNT_NAME='12345';
       
        cs.SAP_ACCOUNT_INFO ='ZRA';
       
       
        cs.CASENUMBER = 'E854-7230-W8AH2B8ZVSGH6C';
       
        cs.CaseType = 'Master';
        
        cs.DistributionChannel = 'PPO Credit';   
           
        SAPtoSFDCServiceclass.CaseDataSFDCtoSAP sfdcdata = SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        Test.stopTest();
    }
    testMethod static void CaseDataSFDCtoSAP1(){
        Case cas = new Case();
        cas.Origin = 'web';
        cas.Status = 'Open';  
        cas.OwnerId = Label.UFR_Owner_Id;
        //cas.ContactId = objContact.Id;
        cas.RecordtypeId = Label.OEM_Spares;
        cas.Classification__c = 'CSO Repair Order';
        //cas.Sub_Class__c = 'Quotes COE - Customer Response';
        
        cas.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cas.Government_Compliance_SM_M_Content__c = 'No';
        cas.Sales_Order_Number__c = '12345678';
        //cas.Order_Entered_By__c = 'Harikishore';
        cas.CaseOwnerChanged__c = 'sofiya.peermohamed@nttdata.com';
        cas.Description = 'Test cases';
        cas.subject='Credit Card Re-Auth Error. Sales order Number - 0012345678';
        cas.Sales_Order_Number__c =  '12345678';
        insert cas;
        
        
        Test.startTest();
        Case c = [select id,CaseNumber,Description,Resolution__c, Sales_Order_Number__c,Status,Ownerid from Case where id =:cas.id];
       
        SAPtoSFDCServiceclass.RnO_CASE_cls cs = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
       // CreateCaseServiceclassPPO cs = new CreateCaseServiceclassPPO();
        cs.SALES_ORDER_NUMBER = c.Sales_Order_Number__c;
        
        cs.SAP_ACCOUNT_NAME='12345';
       
        cs.SAP_ACCOUNT_INFO ='ZRA';
       
       
        cs.CASENUMBER = 'E854-7230-W8AH2B8ZVSGH6C';
       
        cs.CaseType = 'Master';
        
        cs.DistributionChannel = 'PPO Credit';  
         SAPtoSFDCServiceclass.CaseDataSFDCtoSAP sfdcdata = SAPtoSFDCServiceclass.SAP_RO_AUTOMATION_PROC(cs);
        SAPtoSFDCServiceclass.RnO_CASE_cls cs1 = new  SAPtoSFDCServiceclass.RnO_CASE_cls();
        Test.stopTest();
        
        
    }
    
    
   }