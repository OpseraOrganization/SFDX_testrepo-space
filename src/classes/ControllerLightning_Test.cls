@isTest
public class ControllerLightning_Test {
   
  public static testmethod void closeTasks_test(){
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
        
        Id rt= Label.D_S_Quotes_Orders_RT_ID;
        
        Contact con = new Contact();
        con.LastName = 'teststat';
        con.FirstName = 'toopen';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con.Employee_Number__c = 'E123123';
        con.Email='harikishore.vutukuri@honeywell.com';
        con.Contact_Function__c = 'Contracts';
        insert con;
        
        Case cse1 = new Case();
        cse1.Origin = 'Email';
        cse1.Status = 'On Hold';
        cse1.RecordTypeId = rt;
       // cse1.Classification__c = 'CSO D&S Internal';
        cse1.ContactId = con.Id;
        cse1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cse1.Government_Compliance_SM_M_Content__c = 'NO';
        cse1.Sub_Status__c = 'Business Hold';
        cse1.Internal_HW_Action__c  = 'Test';
        cse1.reason_for_hold__c = 'Amended PO';
        cse1.vn_name__c = con.id;
        cse1.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
        cse1.Government_Compliance_SM_M_Content__c = 'Undetermined';
        insert cse1;
        
        
                Task task = new Task();
      //  task.OwnerId = manager.Id;
        task.Priority = 'Normal';
        task.Status = 'Open';
     
          task.whatid = cse1.id;
          insert task;
          
          Supported_Products__c sp = new Supported_Products__c();
            sp.Name = 'Dummy';
            sp.Status__c = 'Active';
            insert sp;
            
       // ControllerLightning cl = new ControllerLightning();
       test.starttest();
        ControllerLightning.closeTasks(cse1.id);
        ControllerLightning.assigntome(cse1.id);
        ControllerLightning.discardCase(cse1.id);
        ControllerLightning.myAeroSpaceViewOrder(cse1.id);
        ControllerLightning.notificationNumber(cse1.id);
        ControllerLightning.quoteNumber(cse1.id);
        ControllerLightning.salesOrderNumber(cse1.id);
        test.stoptest();
    }
    
    public static testmethod void closeTasks_test1(){
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
        
        Id rt= Label.D_S_Quotes_Orders_RT_ID;
        
        Contact con = new Contact();
        con.LastName = 'teststat';
        con.FirstName = 'toopen';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con.Employee_Number__c = 'E123123';
        con.Email='harikishore.vutukuri@honeywell.com';
        con.Contact_Function__c = 'Contracts';
        insert con;
        
        Case cse1 = new Case();
        cse1.Origin = 'Email';
        cse1.Status = 'On Hold';
        cse1.RecordTypeId = rt;
       // cse1.Classification__c = 'CSO D&S Internal';
        cse1.ContactId = con.Id;
        cse1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cse1.Government_Compliance_SM_M_Content__c = 'NO';
        cse1.Sub_Status__c = 'Business Hold';
        cse1.Internal_HW_Action__c  = 'Test';
        cse1.reason_for_hold__c = 'Amended PO';
        cse1.vn_name__c = con.id;
        cse1.Export_Compliance_Content_ITAR_EAR__c = 'Undetermined';
        cse1.Government_Compliance_SM_M_Content__c = 'Undetermined';
        cse1.Sales_Order_Number__c = '123';
        cse1.Repair_Notification_Number__c = '123';
        cse1.Quote_Number__c = '123';
        //cse1.Sales_Order_Number__c = '123';
        insert cse1;
        
        
          
           test.starttest();
       
        ControllerLightning.myAeroSpaceViewOrder(cse1.id);
        ControllerLightning.notificationNumber(cse1.id);
        ControllerLightning.quoteNumber(cse1.id);
        ControllerLightning.salesOrderNumber(cse1.id);
        test.stoptest();
    }
    
   public static testmethod void exportCLI_test(){
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
        
        Id rt= Label.D_S_Quotes_Orders_RT_ID;
        
        Contact con = new Contact();
        con.LastName = 'teststat';
        con.FirstName = 'toopen';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con.Employee_Number__c = 'E123123';
        con.Email='harikishore.vutukuri@honeywell.com';
        con.Contact_Function__c = 'Contracts';
        insert con;
        
        Case cse1 = new Case();
        cse1.Origin = 'Email';
        cse1.Status = 'On Hold';
        cse1.RecordTypeId = rt;
        cse1.Classification__c = 'CSO D&S Internal';
        cse1.ContactId = con.Id;
        cse1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cse1.Government_Compliance_SM_M_Content__c = 'NO';
        cse1.Sub_Status__c = 'Business Hold';
        cse1.Internal_HW_Action__c  = 'Test';
        cse1.reason_for_hold__c = 'Amended PO';
        cse1.vn_name__c = con.id;
        
        insert cse1;
      Case_Line_Item__c cl = new Case_Line_Item__c();
       cl.case_number__c = cse1.id;
       cl.Part_Number__c  = '123';
       insert cl;
       list<Case_Line_Item__c>cls = new list<Case_Line_Item__c>();
       cls.add(cl);
       ControllerLightning.exportCLI(cse1.id);
   }
   
  private static testMethod void testAutoRun() {
  
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
        
        Id rt= Label.D_S_Quotes_Orders_RT_ID;
        
        Contact con = new Contact();
        con.LastName = 'teststat';
        con.FirstName = 'toopen';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con.Employee_Number__c = 'E123123';
        con.Email='harikishore.vutukuri@honeywell.com';
        con.Contact_Function__c = 'Contracts';
        insert con;
        
        Case cse1 = new Case();
        cse1.Origin = 'Email';
        cse1.Status = 'On Hold';
        cse1.RecordTypeId = rt;
        cse1.Classification__c = 'CSO D&S Internal';
        cse1.ContactId = con.Id;
        cse1.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cse1.Government_Compliance_SM_M_Content__c = 'NO';
        cse1.Sub_Status__c = 'Business Hold';
        cse1.Internal_HW_Action__c  = 'Test';
        cse1.reason_for_hold__c = 'Amended PO';
        cse1.vn_name__c = con.id;
        
        insert cse1;
        
        Supported_Products__c sp = new Supported_Products__c();
        sp.Name = 'Dummy';
        insert sp;
   List<case>csList = new list<Case>();
   csList.add(cse1);
      Test.startTest();
ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(csList);
setCon.setSelected(csList);
discardLightningController ext = new discardLightningController(setcon);
 ext.selectCases();
   
   test.stopTest();
}
   
    
}