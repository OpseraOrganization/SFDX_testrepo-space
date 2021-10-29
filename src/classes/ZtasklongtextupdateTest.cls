@isTest 
public class ZtasklongtextupdateTest{

static testMethod void testMethod1() {
        test.startTest();
         Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';       
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Nanjappan';
        con.FirstName = 'Nandini';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'nandini.nanjappan@nttdata.com';
        con.Email='nandini.nanjappan@nttdata.com';
        insert con;
        
        
        Case cs= new Case();
        cs.Origin = 'Email-EMS-Norcross';
        //cs.Status = 'New';
        cs.RecordTypeId = Label.Repair_Overhaul_RT_ID;
        cs.Classification__c = 'CSO Repair/Overhaul';
        cs.ContactId = con.Id;
        cs.Type_of_Change__c = 'New Account';
        cs.Type = 'Other';
        cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs.Government_Compliance_SM_M_Content__c = 'NO';  
        cs.OwnerId=label.aero_default_user_id;
        cs.Repair_Notification_Number__c = '2132';
        cs.Sales_Order_Number__c = '123134';
        insert cs; 
        
        Z_Task__c zt = new Z_Task__c();
        zt.SAP_ZTask_Number__c = 'Test123';
        zt.Name = 'Tasktest1';
        zt.RelatedTo__c = cs.id;
        zt.Status__c = null;
        zt.type__c='Z107 Order Information Required';
        zt.lastmodifiedbyid = label.DeniedPartyScreening_APIUser_ID;
        zt.Requested_By__c = label.Task_Activities_Requested_By;
        zt.New_Long_Text__c= 'testcase';
        zt.Followuptask__c = false;
        zt.Language_Key__c = 'test11';
        zt.SI_SAP_Task__c = false;
        zt.Event_Type__c = 'test';
        zt.Name = 'TestZtask';
        zt.Sub_Type__c = 'test';
        insert zt;
       
        zt.Status__c = 'Closed';
        zt.SAP_ZTask_Number__c = 'TM003241';
       
        update zt;
        
        Activitiy_Line_Item__c Act = new Activitiy_Line_Item__c();
        Act.Case__c = cs.id;
        Act.Task_Activities__c = zt.id;
        Act.Status__c = 'Open';
        Act.SAPUserStatusObjectNumber__c = 'Test';
        Act.Email_Status__c = 'Sent';
        insert Act;
        
       // SI_ZtaskStatustoSAP ts = new SI_ZtaskStatustoSAP();
       // SI_ZtaskStatustoSAP .SendTaskStatus();
        Test.stoptest();
        }
    static testMethod void testMethod2() {
        test.startTest();
         Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airbus';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Marine';       
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Nanjappan';
        con.FirstName = 'Nandini';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'nandini.nanjappan@nttdata.com';
        con.Email='nandini.nanjappan@nttdata.com';
        insert con;
        
        
        Case cs= new Case();
        cs.Origin = 'Email-EMS-Norcross';
        //cs.Status = 'New';
        cs.RecordTypeId = Label.Repair_Overhaul_RT_ID;
        cs.Classification__c = 'CSO Repair/Overhaul';
        cs.ContactId = con.Id;
        cs.Type_of_Change__c = 'New Account';
        cs.Type = 'Other';
        cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs.Government_Compliance_SM_M_Content__c = 'NO';  
        cs.OwnerId=label.aero_default_user_id;
        cs.Repair_Notification_Number__c = '2132';
        cs.Sales_Order_Number__c = '123134';
        insert cs; 
        
        ROI_Order_Information__c Roi = new ROI_Order_Information__c();
        Roi.CaseNumber__c = cs.id;
        Roi.Reminder_Email_Start_Date__c = Date.valueOf(system.today())-2;
        Roi.SI_REMINDER_FLAG__c = TRUE;
        Roi.SI_REMINDER_DAYS__c = '2';
        Roi.RAI_DAYS__c = '10';
        Roi.ORDER_PRICE__c = '23';
        Roi.TEST_FAILURE_NOTE__c = 'Testing';
        insert Roi;
        
        Z_Task__c zt = new Z_Task__c();
        zt.SAP_ZTask_Number__c = 'Test123';
        zt.Name = 'Tasktest1';
        zt.RelatedTo__c = cs.id;
        zt.Status__c = null;
        zt.type__c='Z136 Order Information Required';
        zt.lastmodifiedbyid = label.DeniedPartyScreening_APIUser_ID;
        zt.Requested_By__c = label.Task_Activities_Requested_By;
        zt.New_Long_Text__c= 'testcase';
        zt.Followuptask__c = false;
        zt.Language_Key__c = 'test11';
        zt.SI_SAP_Task__c = false;
        zt.Event_Type__c = 'test';
        zt.Name = 'TestZtask';
        zt.Sub_Type__c = 'test';        
        insert zt;
       
        
        
        Activitiy_Line_Item__c Act = new Activitiy_Line_Item__c();
        Act.Case__c = cs.id;
        Act.Task_Activities__c = zt.id;
        Act.Status__c = 'Open';
        Act.SAPUserStatusObjectNumber__c = 'Test';
        Act.Email_Status__c = 'Sent';
        insert Act;
        
       // SI_ZtaskStatustoSAP ts = new SI_ZtaskStatustoSAP();
       // SI_ZtaskStatustoSAP .SendTaskStatus();
        Test.stoptest();
        }
        }