@isTest
public class NewZtaskPageClsTest
{
    static testMethod void testMethod1() 
    {
        test.startTest();
        // string Clone1='Testclone';
        //string ztasksubtype = 'Z7 QSTC CBM EID [Case #] date';
        User usr =[select id,firstname,lastname,name,FederationIdentifier,profileid from user where  isactive=true and profile.name='system administrator'  limit 1];
        System.runas(usr)
        {
             account acctest= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.Name => 'Test Account New',
                    account.Customer_Status__c => 'Active',
                    account.Strategic_Business_Unit__c => 'ATR',
                    account.CBT__c => 'Airlines',
                    account.Region_Name__c => 'Americas',
                    account.Sub_Region_Name__c => 'Canada',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',               
                    account.Type => 'OEM',
                    account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                    account.Market_Name__c => 'Marine'        
                    });                        
            Contact con = new Contact();
            con.accountId=acctest.Id;
            con.LastName = 'Nanjappan';
            con.FirstName = 'Nandini';
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
            Z_Task__c zt = new Z_Task__c();
            zt.Type__c='Z136 CUSTOMER FOLLOW UP REQUIRED';
            zt.SAP_ZTask_Number__c = 'Test123';
            zt.Name = 'Tasktest1';
            zt.RelatedTo__c = cs.id;
            zt.Short_Text__c = 'Test';
            zt.Comments__c = 'Test Ztask';
            zt.Long_Text__c = 'Test122';
            zt.Event_Type__c = '';
            zt.Sub_Type__c = 'Z7.1 WWC CBM EID [Case #] date';
            zt.Other_Short_Text__c = 'Test text';
            zt.Status__c = 'Open';
            zt.Long_Text_Summary__c='test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111test111';
            insert zt;
            zt.Event_Type__c='';
            zt.Sub_Type__c = 'Z7.1 WWC CBM EID [Case #] date';
            zt.Status__c = 'Open';
            /* zt.Followup_Task__c='Z107 Order Information Required';
            zt.New_Long_Text__c='test';
            zt.Long_Text_Summary__c='test111'; */
            update zt;
            System.currentPageReference().getparameters().put('id' , zt.id);
            System.currentPageReference().getparameters().put('CF00N56000000VYtl_lkid' , cs.id);       
            ApexPages.StandardController stdController = new ApexPages.StandardController(zt);
            NewZtaskPageCls Us= new NewZtaskPageCls(stdController);                   
            Us.CustomSave();
            us.ZTask.Sub_Type__c = 'Z7.1 WWC CBM EID [Case #] date';
            Us.changeshorttext();                    
        }
        test.stopTest();        
    }
    static testMethod void testMethod2() 
    {
        test.startTest();
        User usr =[select id,firstname,lastname,name,FederationIdentifier,profileid from user where  isactive=true and profile.name='system administrator'  limit 1];
        System.runas(usr)
        {
             account acctest= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.Name => 'Test Account New',
                    account.Customer_Status__c => 'Active',
                    account.Strategic_Business_Unit__c => 'ATR',
                    account.CBT__c => 'Airlines',
                    account.Region_Name__c => 'Americas',
                    account.Sub_Region_Name__c => 'Canada',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',               
                    account.Type => 'OEM',
                    account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                    account.Market_Name__c => 'Marine'        
                    });                        
            Contact con = new Contact();
            con.accountId=acctest.Id;
             con.LastName = 'Nanjappan';
            con.FirstName = 'Nandini';
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
            Z_Task__c zt = new Z_Task__c();
            zt.Type__c='Z136 CUSTOMER FOLLOW UP REQUIRED';
            zt.SAP_ZTask_Number__c = 'Test123';
            zt.Name = 'Tasktest1';
            zt.RelatedTo__c = cs.id;
            zt.Short_Text__c = 'Test';
            zt.Comments__c = 'Test Ztask';
            zt.Long_Text__c = 'Test122';
            zt.Event_Type__c = '';
            zt.Sub_Type__c = 'Other';
            zt.Other_Short_Text__c = 'Test text';
            zt.Status__c = 'Closed';
            insert zt;
            zt.Event_Type__c='';
            zt.Sub_Type__c = 'Other';
            zt.Other_Short_Text__c='test';
            zt.Status__c = 'Closed';
            zt.Followup_Task__c='Z107 Order Information Required';
            zt.New_Long_Text__c='test';
            zt.Long_Text_Summary__c='test111';
            update zt;
            System.currentPageReference().getparameters().put('id' , zt.id);
            System.currentPageReference().getparameters().put('CF00N56000000VYtl_lkid' , cs.id);       
            ApexPages.StandardController stdController = new ApexPages.StandardController(zt);
            NewZtaskPageCls Us= new NewZtaskPageCls(stdController);                   
            zt.Status__c = 'Close Follow-Up Task';
            Us.CustomSave();
            us.ZTask.Sub_Type__c = 'Other';
            zt.Other_Short_Text__c='test';
            Us.changeshorttext();                  
        }
        test.stopTest();        
    }
    static testMethod void testMethod3() 
    {
        test.startTest();
        // string Clone1='Testclone';
        //string ztasksubtype = 'Z7 QSTC CBM EID [Case #] date';
        User usr =[select id,firstname,lastname,name,FederationIdentifier,profileid from user where  isactive=true and profile.name='system administrator'  limit 1];
        System.runas(usr)
        {
             account acctest= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.Name => 'Test Account New',
                    account.Customer_Status__c => 'Active',
                    account.Strategic_Business_Unit__c => 'ATR',
                    account.CBT__c => 'Airlines',
                    account.Region_Name__c => 'Americas',
                    account.Sub_Region_Name__c => 'Canada',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',               
                    account.Type => 'OEM',
                    account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                    account.Market_Name__c => 'Marine'        
                    });                        
            Contact con = new Contact();
            con.accountId=acctest.Id;
            con.LastName = 'Nanjappan';
            con.FirstName = 'Nandini';
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
            Z_Task__c zt = new Z_Task__c();
            zt.Type__c='Z107 Order Information Required';
            zt.SAP_ZTask_Number__c = 'Test123';
            zt.Name = 'Tasktest1';
            zt.RelatedTo__c = cs.id;
            zt.Short_Text__c = 'Test';
            zt.Comments__c = 'Test Ztask';
            zt.Long_Text__c = 'Test122';
            zt.Event_Type__c = '';
            zt.Sub_Type__c = 'Z7.1 WWC CBM EID [Case #] date';
            zt.Other_Short_Text__c = 'Test text';
            zt.Status__c = 'Open';
            insert zt;
            set<id> ztid=new set<id>();
            ztid.add(zt.id);
            ROI_ZtaskUserStatustoSAP.SendTaskStatus(ztid);             
        }
        test.stopTest();        
    }
    static testMethod void testMethod4() 
    {
        test.startTest();
        User usr =[select id,firstname,lastname,name,FederationIdentifier,profileid from user where  isactive=true and profile.name='system administrator'  limit 1];
        System.runas(usr)
        {
             account acctest= (account)SObjectFactory.create(
            account.sObjectType, new Map<Schema.SObjectField, Object>
            {
                account.Name => 'Test Account New',
                    account.Customer_Status__c => 'Active',
                    account.Strategic_Business_Unit__c => 'ATR',
                    account.CBT__c => 'Airlines',
                    account.Region_Name__c => 'Americas',
                    account.Sub_Region_Name__c => 'Canada',
                    account.Service_Level__c => 'Unauthorized Dist/Brkr',               
                    account.Type => 'OEM',
                    account.REPORT_ACCOUNT_NAME__c => 'Test Account New',
                    account.Market_Name__c => 'Marine'        
                    });                        
            Contact con = new Contact();
            con.accountId=acctest.Id;
              con.LastName = 'Nanjappan';
            con.FirstName = 'Nandini';
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
            Z_Task__c zt = new Z_Task__c();
            zt.Type__c='Z155 Airworthyness Board Approval from Cust.';
            zt.SAP_ZTask_Number__c = 'Test123';
            zt.Name = 'Tasktest1';
            zt.RelatedTo__c = cs.id;
            zt.Short_Text__c = 'Test';
            zt.Comments__c = 'Test Ztask';
            zt.Long_Text__c = 'Test122';
            zt.Event_Type__c = '';
            zt.Sub_Type__c = 'Z7.1 WWC CBM EID [Case #] date';
            zt.Other_Short_Text__c = 'Test text';
            zt.Status__c = 'Open';
            insert zt;
            Activitiy_Line_Item__c userstatus=new Activitiy_Line_Item__c();
            //userstatus.name='WHLB';
            userstatus.Task_Activities__c=zt.id;
            userstatus.Case__c=cs.id;
            userstatus.status__c = 'open';
            insert userstatus;
            set<id> ztid=new set<id>();
            ztid.add(zt.id);
            ROI_ZtaskUserStatustoSAP.SendTaskStatus(ztid);              
        }
        test.stopTest();        
    }
}