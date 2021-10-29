@isTest 
public class UserstatusEditPageClsTests {

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
        insert cs; 
        
        Z_Task__c zt = new Z_Task__c();
        zt.SAP_ZTask_Number__c = 'Test123';
        zt.Name = 'Tasktest1';
        zt.RelatedTo__c = cs.id;
        insert zt;
        
        Activitiy_Line_Item__c Act = new Activitiy_Line_Item__c();
        Act.Case__c = cs.id;
        Act.Task_Activities__c = zt.id;
        Act.Status__c = 'Open';
        Act.SAPUserStatusObjectNumber__c = 'Test';
        Act.Email_Status__c = 'Sent';
        insert Act;
        
        System.currentPageReference().getparameters().put('id' , Act.id);        
        ApexPages.StandardController stdController = new ApexPages.StandardController(Act);
        UserstatusEditPageCls Us= new UserstatusEditPageCls (stdController);        
        Us.CustomSave();
        test.stopTest();        
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
        cs.RecordTypeId = Label.Repair_Overhaul_RT_ID;
        cs.Classification__c = 'CSO Repair/Overhaul';
        cs.ContactId = con.Id;
        cs.Type_of_Change__c = 'New Account';
        cs.Type = 'Other';
        cs.Export_Compliance_Content_ITAR_EAR__c = 'NO';
        cs.Government_Compliance_SM_M_Content__c = 'NO';  
        cs.OwnerId=label.aero_default_user_id;
        insert cs; 
       
        
        Activitiy_Line_Item__c Act = new Activitiy_Line_Item__c();
        Act.Case__c = cs.id;
        //Act.Task_Activities__c = '';
        Act.Status__c = 'Closed';
        Act.SAPUserStatusObjectNumber__c = 'Test';
        Act.Email_Status__c = 'Sent';
        insert Act;
       
        System.currentPageReference().getparameters().put('id' , Act.id);        
        ApexPages.StandardController stdController = new ApexPages.StandardController(Act);
        UserstatusEditPageCls Us= new UserstatusEditPageCls (stdController);        
        Us.CustomSave();
        test.stopTest();
   
        
}
}