@isTest 
public class ZtaskEditPageClsTest{
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
            // con.AccountId = acc.Id;
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
                    
            Z_Task__c zt11 = new Z_Task__c();
            zt11.SAP_ZTask_Number__c = 'Test123';
            zt11.Name = 'Tasktest1';
            zt11.RelatedTo__c = cs.id;
            zt11.Short_Text__c = 'Test';
            zt11.Comments__c = 'Test Ztask';
            zt11.Long_Text__c = 'Test122';
            // zt11.Event_Type__c = '';
            zt11.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
            zt11.Other_Short_Text__c = 'Test text';
            zt11.Status__c = 'Closed';
            insert zt11;
            zt11.Event_Type__c = 'TASK CLOSE';
            update zt11;
                    
            Z_Task__c zt12 = new Z_Task__c();
            zt12.SAP_ZTask_Number__c = 'Test123';
            zt12.Name = 'Tasktest1';
            zt12.RelatedTo__c = cs.id;
            zt12.Short_Text__c = '';
            zt12.Comments__c = 'Test Ztask';
            zt12.Long_Text__c = '';
            zt12.Followup_Task__c= 'Z144 Phone Call to Customer';
            zt12.Followup_Task1__c = 'Z146 Cust Follow Up Required - GAT0';
            zt12.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
            zt12.Other_Short_Text__c = 'Test text';
            zt12.Status__c = 'Open';
            insert zt12;
            //zt12.Event_Type__c = 'TASK CLOSE';
            // update zt12;
            
           zt12.Name ='Z136 CUSTOMER FOLLOW UP REQUIRED';
           update zt12;
            
            List<Activitiy_Line_Item__c> actvtyLineItemList = new List<Activitiy_Line_Item__c>();
            List<Activitiy_Line_Item__c> selectedstatus = new List<Activitiy_Line_Item__c>();
            
            Activitiy_Line_Item__c lineItem = new Activitiy_Line_Item__c();
            lineItem.status__c='Open';
            lineItem.name__c='WCF1';
            lineItem.Description__c='test des';
            lineItem.Task_Activities__c=zt12.Id;
            lineItem.Case__c = cs.id;
            actvtyLineItemList.add(lineItem);
            insert actvtyLineItemList;
            
            ZtaskEditPageCls.UserstatusInner usInner = new ZtaskEditPageCls.UserstatusInner(actvtyLineItemList[0]);
            usInner.selected = true;
            List<ZtaskEditPageCls.UserstatusInner> UserstatusInnerlist = new List<ZtaskEditPageCls.UserstatusInner>();
            UserstatusInnerlist.add(usInner);
           
            
            System.currentPageReference().getparameters().put('id' , zt11.id); 
            System.currentPageReference().getParameters().put('Id',zt12.id);       
            ApexPages.StandardController stdController = new ApexPages.StandardController(zt11);
            // ApexPages.StandardController stdController = new ApexPages.StandardController(zt12);
            ZtaskEditPageCls Us= new ZtaskEditPageCls(stdController); 
            Us.closetask=false;
            Us.CustomSave();
            Us.CloseSave();
            Us.changeshorttext();
            Us.getuserstatuslist();
            Us.closeuserstatus();
           // Us.UserstatusInner();
        }
        test.stopTest();          
    }
    static testMethod void testMethod3() 
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
                    
            Z_Task__c zt11 = new Z_Task__c();
            zt11.SAP_ZTask_Number__c = 'Test123';
            zt11.Name = 'Tasktest1';
            zt11.RelatedTo__c = cs.id;
            zt11.Short_Text__c = 'Test';
            zt11.Comments__c = 'Test Ztask';
            zt11.Long_Text__c = 'Test122';
            zt11.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
            zt11.Other_Short_Text__c = 'Test text';
            zt11.Status__c = 'Open';
            insert zt11;
            zt11.Event_Type__c = 'TASK CLOSE';
            update zt11;
                    
            Z_Task__c zt12 = new Z_Task__c();
            zt12.SAP_ZTask_Number__c = 'Test123';
            zt12.Name = 'Tasktest1';
            zt12.RelatedTo__c = cs.id;
            zt12.Short_Text__c = '';
            zt12.Comments__c = 'Test Ztask';
            zt12.Long_Text__c = '';
            zt12.Followup_Task__c= 'Z144 Phone Call to Customer';
            zt12.Followup_Task1__c = 'Z146 Cust Follow Up Required - GAT0';
            zt12.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
            zt12.Other_Short_Text__c = 'Test text';
            zt12.Status__c = 'Open';
            insert zt12;
            //zt12.Event_Type__c = 'TASK CLOSE';
            // update zt12;
            System.currentPageReference().getparameters().put('id' , zt11.id); 
            System.currentPageReference().getParameters().put('Id',zt12.id); 
            System.currentPageReference().getParameters().put('Cloneid','1');           
            ApexPages.StandardController stdController = new ApexPages.StandardController(zt11);
            // ApexPages.StandardController stdController = new ApexPages.StandardController(zt12);
            ZtaskEditPageCls Us= new ZtaskEditPageCls(stdController);        
            Us.CustomSave();
            Us.CloseSave();
            Us.changeshorttext();           
            ZtaskEditPageCls.getstatuslst(zt12.id);
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
                    
            Z_Task__c zt11 = new Z_Task__c();
            zt11.SAP_ZTask_Number__c = 'Test123';
            zt11.Name = 'Tasktest1';
            zt11.RelatedTo__c = cs.id;
            zt11.Short_Text__c = 'Test';
            zt11.Comments__c = 'Test Ztask';
            zt11.Long_Text__c = 'null';
            zt11.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
            zt11.Other_Short_Text__c = 'Test text';
            zt11.Status__c = 'Open';
            insert zt11;
            zt11.Event_Type__c = 'TASK CLOSE';
            update zt11;
                    
            Z_Task__c zt12 = new Z_Task__c();
            zt12.SAP_ZTask_Number__c = 'Test123';
            zt12.Name = 'Tasktest1';
            zt12.RelatedTo__c = cs.id;
            zt12.Short_Text__c = '';
            zt12.Comments__c = 'Test Ztask';
            zt12.Long_Text__c = 'null';
            zt12.Followup_Task__c= 'Z144 Phone Call to Customer';
            zt12.Followup_Task1__c = 'Z146 Cust Follow Up Required - GAT0';
            zt12.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
            zt12.Other_Short_Text__c = 'Test text';
            zt12.Status__c = 'Open';
            insert zt12;
            System.currentPageReference().getparameters().put('id' , zt11.id); 
            //System.currentPageReference().getParameters().put('Id',zt12.id); 
            System.currentPageReference().getParameters().put('Cloneid','1');           
            ApexPages.StandardController stdController = new ApexPages.StandardController(zt11);
            ZtaskEditPageCls Us= new ZtaskEditPageCls(stdController);        
            Us.CustomSave();
            Us.CloseSave();
            Us.changeshorttext();
            us.cancelfollowup();
            ZtaskEditPageCls.getstatuslst(zt12.id);
        }
        test.stopTest();          
    }
      static testMethod void testMethod1() 
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
                    
            Z_Task__c zt11 = new Z_Task__c();
            zt11.SAP_ZTask_Number__c = 'Test123';
            zt11.Name = 'Tasktest1';
            zt11.RelatedTo__c = cs.id;
            zt11.Short_Text__c = 'Test';
            zt11.Comments__c = 'Test Ztask';
            zt11.Long_Text__c = 'null';
            zt11.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
            zt11.Other_Short_Text__c = 'Test text';
            zt11.Status__c = 'Open';
            insert zt11;
            zt11.Event_Type__c = 'TASK CLOSE';
            update zt11;
                    
            Z_Task__c zt12 = new Z_Task__c();
            zt12.SAP_ZTask_Number__c = 'Test123';
            zt12.Name = 'Tasktest1';
            zt12.RelatedTo__c = cs.id;
            zt12.Short_Text__c = '';
            zt12.Comments__c = 'Test Ztask';
            zt12.Long_Text__c = 'null';
            zt12.Followup_Task__c= 'Z144 Phone Call to Customer';
            zt12.Followup_Task1__c = 'Z146 Cust Follow Up Required - GAT0';
            zt12.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
            zt12.Other_Short_Text__c = 'Test text';
            zt12.Status__c = 'Closed';
            insert zt12;
            System.currentPageReference().getparameters().put('id' , zt11.id); 
            //System.currentPageReference().getParameters().put('Id',zt12.id); 
            System.currentPageReference().getParameters().put('Cloneid','1');           
            ApexPages.StandardController stdController = new ApexPages.StandardController(zt11);
            ZtaskEditPageCls Us= new ZtaskEditPageCls(stdController);        
            Us.CustomSave();
            Us.CloseSave();
            Us.changeshorttext();
            us.cancelfollowup();
            ZtaskEditPageCls.getstatus(zt12.id);
        }
        test.stopTest();          
    }
    static testMethod void testMethod5() 
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
            // con.AccountId = acc.Id;
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
                    
            Z_Task__c zt11 = new Z_Task__c();
            zt11.SAP_ZTask_Number__c = 'Test123';
            zt11.Name = 'Tasktest1';
            zt11.RelatedTo__c = cs.id;
            zt11.Short_Text__c = 'Test';
            zt11.Comments__c = 'Test Ztask';
            zt11.Long_Text__c = 'Test122';
            // zt11.Event_Type__c = '';
            zt11.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
            zt11.Other_Short_Text__c = 'Test text';
            zt11.Status__c = 'Open';
            insert zt11;
            zt11.Event_Type__c = 'TASK CLOSE';
            update zt11;
                    
            Z_Task__c zt12 = new Z_Task__c();
            zt12.SAP_ZTask_Number__c = 'Test123';
            zt12.Name = 'Tasktest1';
            zt12.RelatedTo__c = cs.id;
            zt12.Short_Text__c = '';
            zt12.Comments__c = 'Test Ztask';
            zt12.Long_Text__c = '';
            zt12.Followup_Task__c= 'No Followup Task';
            zt12.Followup_Task1__c = 'Z146 Cust Follow Up Required - GAT0';
            zt12.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
            zt12.Other_Short_Text__c = 'Test text';
            zt12.Followuptask__c=True;
            zt12.Status__c = 'Closed';
            insert zt12;
            //zt12.Event_Type__c = 'TASK CLOSE';
            // update zt12;
            System.currentPageReference().getparameters().put('id' , zt11.id); 
            System.currentPageReference().getParameters().put('Id',zt12.id);       
            ApexPages.StandardController stdController = new ApexPages.StandardController(zt11);
            // ApexPages.StandardController stdController = new ApexPages.StandardController(zt12);
            ZtaskEditPageCls Us= new ZtaskEditPageCls(stdController);        
            Us.CustomSave();
            Us.CloseSave();
            Us.changeshorttext();
        }
        test.stopTest();          
    }
    static testMethod void testMethod6() 
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
            // con.AccountId = acc.Id;
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
                    
            Z_Task__c zt11 = new Z_Task__c();
            zt11.SAP_ZTask_Number__c = 'Test123';
            zt11.Name = 'Tasktest1';
            zt11.RelatedTo__c = cs.id;
            zt11.Short_Text__c = 'Test';
            zt11.Comments__c = 'Test Ztask';
            zt11.Long_Text__c = 'Test122';
            // zt11.Event_Type__c = '';
            zt11.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
            zt11.Other_Short_Text__c = 'Test text';
            zt11.Status__c = 'Open';
            insert zt11;
            zt11.Event_Type__c = 'TASK CLOSE';
            update zt11;
                    
            Z_Task__c zt12 = new Z_Task__c();
            zt12.SAP_ZTask_Number__c = 'Test123';
            zt12.Name = 'Tasktest1';
            zt12.RelatedTo__c = cs.id;
            zt12.Short_Text__c = '';
            zt12.Comments__c = 'Test Ztask';
            zt12.Long_Text__c = '';
            zt12.Followup_Task__c= 'Z144 Phone Call to Customer';
            zt12.Followup_Task1__c = 'Z146 Cust Follow Up Required - GAT0';
            zt12.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
            zt12.Other_Short_Text__c = 'Test text';
            zt12.Status__c = 'Closed';
            insert zt12;
            //zt12.Event_Type__c = 'TASK CLOSE';
            // update zt12;
            System.currentPageReference().getparameters().put('id' , zt11.id); 
            System.currentPageReference().getParameters().put('Id',zt12.id);       
            ApexPages.StandardController stdController = new ApexPages.StandardController(zt11);
            // ApexPages.StandardController stdController = new ApexPages.StandardController(zt12);
            ZtaskEditPageCls Us= new ZtaskEditPageCls(stdController);        
            Us.CustomSave();
            Us.CloseSave();
            Us.changeshorttext();
        }
        test.stopTest();          
    }
    static testMethod void testMethod7() 
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
            // con.AccountId = acc.Id;
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
                    
            Z_Task__c zt11 = new Z_Task__c();
            zt11.SAP_ZTask_Number__c = 'Test123';
            zt11.Name = 'Tasktest1';
            zt11.RelatedTo__c = cs.id;
            zt11.Short_Text__c = 'Test';
            zt11.Comments__c = 'Test Ztask';
            zt11.Long_Text__c = 'Test122';
            // zt11.Event_Type__c = '';
            zt11.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
            zt11.Other_Short_Text__c = 'Test text';
            zt11.Status__c = 'Closed';
            insert zt11;
            zt11.Event_Type__c = 'TASK CLOSE';
            update zt11;
                    
            Z_Task__c zt12 = new Z_Task__c();
            zt12.SAP_ZTask_Number__c = 'Test123';
            zt12.Name = 'Tasktest1';
            zt12.RelatedTo__c = cs.id;
            zt12.Short_Text__c = '';
            zt12.Comments__c = 'Test Ztask';
            zt12.Long_Text__c = '';
            zt12.Followup_Task__c= 'No Followup Task';
            zt12.Followup_Task1__c = 'Z146 Cust Follow Up Required - GAT0';
            zt12.Sub_Type__c = 'Z7 QSTC CBM EID [Case #] date';
            zt12.Other_Short_Text__c = 'Test text';
            zt12.Status__c = 'Open';
            zt12.Followuptask__c=True;
            insert zt12;
            //zt12.Event_Type__c = 'TASK CLOSE';
            // update zt12;
            System.currentPageReference().getparameters().put('id' , zt11.id); 
            System.currentPageReference().getParameters().put('Id',zt12.id);       
            ApexPages.StandardController stdController = new ApexPages.StandardController(zt11);
            // ApexPages.StandardController stdController = new ApexPages.StandardController(zt12);
            ZtaskEditPageCls Us= new ZtaskEditPageCls(stdController);        
            Us.CustomSave();
            Us.CloseSave();
            Us.changeshorttext();
        }
        test.stopTest();          
    }
}