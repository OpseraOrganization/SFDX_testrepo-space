/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : DiscretionaryLineItem_UpdtEmalFieldsTest
* Description           : Test Class to test the functionality of the trigger DiscretionaryLineItem_UpdateEmailFields.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 08-Nov-2013      0.1               NTTData               Initial Version
***********************************************************************************************************/
@isTest(SeeAllData=true)
private class DiscretionaryLineItem_UpdtEmalFieldsTest{
    static testMethod void TestMthd_DiscretionaryLineItem_UpdateEmailFields(){  
        List<Discretionary_Line_Item__c> dlilist = new List<Discretionary_Line_Item__c>();
        User usr =[select id from user where profile.name = 'System Administrator' and isactive = true order by createddate desc limit 1];
        User usr1 =[select id from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
        
        Contact con = new Contact();
        con.LastName = 'hari';
        con.FirstName = 'vnv';
        con.AccountId = acc.Id;
        con.SBU_Contact__c='ACS Labs';
        con.CBT__c='ACS Sensors Lab';
        con.CBT_Team__c='ACS Advanced Sensors';
        con.Contact_Is_Employee__c = true;
        con.employee_number__c = 'E918273';
        con.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con.Email='harikishore.vutukuri@honeywell.com';        
        insert con;
        
        Opportunity opp = [select id from Opportunity where SBU__c = 'D&S' and RecordType.name like '%D&S PrePriced' limit 1];
        
        Discretionary__c dr = new Discretionary__c();
        dr.Fiscal_Year__c = '2013';
        dr.Opportunity__c = opp.id;
        dr.M_PM_Funded_VOC_Project__c = 'No';
        dr.Estimated_Completion_Date__c = system.today();
        dr.Account__c = acc.id;
        dr.SBU__c = 'D&S';
        dr.CBT__c = 'DAA';
        dr.CBT_Team__c = 'CBMS';
        dr.Type__c = 'Demo';
        dr.Approval_Status__c = 'New';
        dr.Engineering_lead_Contact__c = con.id;
        dr.CC_Email_id_from_Disc__c = 'harikishore.vutukuri@honeywell.com';
        dr.Program__c = 'Testing';
        dr.Engineering_lead_Contact_email_id__c = 'harikishore.vutukuri@honeywell.com';
        insert dr;
        
        Plant_Code_Master__c pcm = new Plant_Code_Master__c();
        pcm.Postal_Code__c = 'Test1';
        pcm.Plant_Name__c = 'Test2';
        pcm.Public_Plant_Name__c = 'Test3';
        pcm.City__c = 'Bangalore';
        pcm.Country_Code__c = 'IN';
        insert pcm;
        
        Plant_Code_del__c pc = new Plant_Code_del__c();
        pc.Name = 'Test23';
        pc.Plant_Code_Master__c = pcm.id;
        pc.SBU__c = 'BGA';
        pc.CBT__c = 'HBC';
        pc.Primary_Account_Opener__c = usr.Id;
        pc.Backup_Account_Opener__c = usr1.Id;
        insert pc;
        
        test.startTest();
        Discretionary_Line_Item__c dli = new Discretionary_Line_Item__c();
        dli.Discretionary_Request__c = dr.Id;
        dli.Plant_Code__c = pc.Id;
        dli.Plant_Code_Master__c = pcm.Id;
        dli.Discretionary_Account__c = '523555214235';
        dli.Cost_Type__c = 'Labor';
        dli.Approval_Status__c = 'New';
        dli.Funding_Amount__c = 23.55;
        dli.Requested_Amount__c = 23.55;
        dli.Engineering_lead_Contact__c = con.Id;
        dli.Discretionary_CC_List_Email__c = dli.Discretionary_CC_List_Email_Formulae__c;
        dli.Discretionary_Engineer_Lead_ContactEmail__c = dli.DisEngr_Lead_Contact_EmailFormule__c;
        dli.CC_Email_from_Disc__c = dli.CC_Emailid_from_Disc__c;
        dli.Eng_Lead_contact_email_from_Disc__c = dli.Engineering_Contact_emailid_from_Disc__c;
        dli.Account_Opener_Email__c = dli.AccountOpener__c;
        dli.Account_Opener_Backup_Email__c = dli.Account_Opener_Backup__c;
        dli.DLIFlag__c = true;
        insert dli;
        //dr.Approval_Status__c = 'Pending Approval';
        //dr.CBT__c = 'EMS';
        //Update dr;
        dr.Approval_Status__c = 'Approved';
        Update dr;
        
        Discretionary_Spend__c ds = new Discretionary_Spend__c();
        ds.Discretionary_Line_Item__c = dli.Id;
        ds.Weekly_Actuals__c = 20.12;
        insert ds;
        test.stopTest();
    }
    static testMethod void TestMthd_DiscretionaryLineItem_UpdateEmailFields1(){  
        List<Discretionary_Line_Item__c> dlilist = new List<Discretionary_Line_Item__c>();
        User usr2 =[select id from user where profile.name = 'System Administrator' and isactive = true order by createddate desc limit 1];
        User usr3 =[select id from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account acc1=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
        
        Contact con1 = new Contact();
        con1.LastName = 'hari';
        con1.FirstName = 'vnv';
        con1.AccountId = acc1.Id;
        con1.SBU_Contact__c='ACS Labs';
        con1.CBT__c='ACS Sensors Lab';
        con1.CBT_Team__c='ACS Advanced Sensors';
        con1.Contact_Is_Employee__c = true;
        con1.Employee_Number__c = 'E888888';
        con1.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con1.Email='harikishore.vutukuri@honeywell.com';        
        insert con1;
        
        Opportunity opp1 = [select id from Opportunity where SBU__c = 'D&S' and RecordType.name like '%D&S PrePriced' limit 1];
        
        Discretionary__c dr1 = new Discretionary__c();
        dr1.Fiscal_Year__c = '2013';
        dr1.Opportunity__c = opp1.id;
        dr1.M_PM_Funded_VOC_Project__c = 'No';
        dr1.Estimated_Completion_Date__c = system.today();
        dr1.Account__c = acc1.id;
        dr1.SBU__c = 'D&S';
        dr1.CBT__c = 'EMS';
        dr1.CBT_Team__c = 'CBMS';
        dr1.Type__c = 'Demo';
        dr1.Approval_Status__c = 'New';
        dr1.Engineering_lead_Contact__c = con1.id;
        dr1.CC_Email_id_from_Disc__c = 'harikishore.vutukuri@honeywell.com';
        dr1.Program__c = 'Testing';
        dr1.Engineering_lead_Contact_email_id__c = 'harikishore.vutukuri@honeywell.com';
        insert dr1;
        
        Plant_Code_Master__c pcm1 = new Plant_Code_Master__c();
        pcm1.Postal_Code__c = 'Test1';
        pcm1.Plant_Name__c = 'Test2';
        pcm1.Public_Plant_Name__c = 'Test3';
        pcm1.City__c = 'Bangalore';
        pcm1.Country_Code__c = 'IN';
        insert pcm1;
        
        Plant_Code_del__c pc1 = new Plant_Code_del__c();
        pc1.Name = 'Test23';
        pc1.Plant_Code_Master__c = pcm1.id;
        pc1.SBU__c = 'BGA';
        pc1.CBT__c = 'HBC';
        pc1.Primary_Account_Opener__c = usr2.Id;
        pc1.Backup_Account_Opener__c = usr3.Id;
        insert pc1;
        
        test.startTest();
        Discretionary_Line_Item__c dli1 = new Discretionary_Line_Item__c();
        dli1.Discretionary_Request__c = dr1.Id;
        dli1.Plant_Code__c = pc1.Id;
        dli1.Plant_Code_Master__c = pcm1.Id;
        dli1.Discretionary_Account__c = '214235';
        dli1.Cost_Type__c = 'Labor';
        dli1.Approval_Status__c = 'New';
        dli1.Funding_Amount__c = 30;
        dli1.Engineering_lead_Contact__c = con1.Id;
        dli1.Discretionary_CC_List_Email__c = dli1.Discretionary_CC_List_Email_Formulae__c;
        dli1.Discretionary_Engineer_Lead_ContactEmail__c = dli1.DisEngr_Lead_Contact_EmailFormule__c;
        dli1.CC_Email_from_Disc__c = dli1.CC_Emailid_from_Disc__c;
        dli1.Eng_Lead_contact_email_from_Disc__c = dli1.Engineering_Contact_emailid_from_Disc__c;
        dli1.Account_Opener_Email__c = dli1.AccountOpener__c;
        dli1.Account_Opener_Backup_Email__c = dli1.Account_Opener_Backup__c;
        dli1.DLIFlag__c = true;
        insert dli1;
        
        Discretionary_Spend__c ds1 = new Discretionary_Spend__c();
        ds1.Discretionary_Line_Item__c = dli1.Id;
        ds1.Weekly_Actuals__c = 15;
        insert ds1;
        test.stopTest();
    }
    /*static testMethod void TestMthd_DiscretionaryLineItem_UpdateEmailFields2(){  
        List<Discretionary_Line_Item__c> dlilist = new List<Discretionary_Line_Item__c>();
        User usr4 =[select id from user where profile.name = 'System Administrator' and isactive = true order by createddate desc limit 1];
        User usr5 =[select id from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account acc2=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
        
        Contact con2 = new Contact();
        con2.LastName = 'hari';
        con2.FirstName = 'vnv';
        con2.AccountId = acc2.Id;
        con2.SBU_Contact__c='ACS Labs';
        con2.CBT__c='ACS Sensors Lab';
        con2.CBT_Team__c='ACS Advanced Sensors';
        con2.Contact_Is_Employee__c = true;
        con2.employee_number__c = 'E777777';
        con2.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con2.Email='harikishore.vutukuri@honeywell.com';        
        insert con2;
        
        Opportunity opp2 = [select id from Opportunity where SBU__c = 'D&S' and RecordType.name like '%D&S PrePriced' limit 1];
        
        Discretionary__c dr2 = new Discretionary__c();
        dr2.Fiscal_Year__c = '2013';
        dr2.Opportunity__c = opp2.id;
        dr2.M_PM_Funded_VOC_Project__c = 'No';
        dr2.Estimated_Completion_Date__c = system.today();
        dr2.Account__c = acc2.id;
        dr2.SBU__c = 'D&S';
        dr2.CBT__c = 'DAA';
        dr2.CBT_Team__c = 'CBMS';
        dr2.Type__c = 'Demo';
        dr2.Approval_Status__c = 'New';
        dr2.Engineering_lead_Contact__c = con2.id;
        dr2.CC_Email_id_from_Disc__c = 'harikishore.vutukuri@honeywell.com';
        dr2.Program__c = 'Testing';
        dr2.Engineering_lead_Contact_email_id__c = 'harikishore.vutukuri@honeywell.com';
        insert dr2;
        
        Plant_Code_Master__c pcm2 = new Plant_Code_Master__c();
        pcm2.Postal_Code__c = 'Test1';
        pcm2.Plant_Name__c = 'Test2';
        pcm2.Public_Plant_Name__c = 'Test3';
        pcm2.City__c = 'Bangalore';
        pcm2.Country_Code__c = 'IN';
        insert pcm2;
        
        Plant_Code_del__c pc2 = new Plant_Code_del__c();
        pc2.Name = 'Test23';
        pc2.Plant_Code_Master__c = pcm2.id;
        pc2.SBU__c = 'BGA';
        pc2.CBT__c = 'HBC';
        pc2.Primary_Account_Opener__c = usr4.Id;
        pc2.Backup_Account_Opener__c = usr5.Id;
        insert pc2;
        
        test.startTest();
        Discretionary_Line_Item__c dli2 = new Discretionary_Line_Item__c();
        dli2.Discretionary_Request__c = dr2.Id;
        dli2.Plant_Code__c = pc2.Id;
        dli2.Plant_Code_Master__c = pcm2.Id;
        dli2.Discretionary_Account__c = '400214235';
        dli2.Cost_Type__c = 'Labor';
        dli2.Approval_Status__c = 'New';
        dli2.Funding_Amount__c = 40;
        dli2.Engineering_lead_Contact__c = con2.Id;
        dli2.Discretionary_CC_List_Email__c = dli2.Discretionary_CC_List_Email_Formulae__c;
        dli2.Discretionary_Engineer_Lead_ContactEmail__c = dli2.DisEngr_Lead_Contact_EmailFormule__c;
        dli2.CC_Email_from_Disc__c = dli2.CC_Emailid_from_Disc__c;
        dli2.Eng_Lead_contact_email_from_Disc__c = dli2.Engineering_Contact_emailid_from_Disc__c;
        dli2.Account_Opener_Email__c = dli2.AccountOpener__c;
        dli2.Account_Opener_Backup_Email__c = dli2.Account_Opener_Backup__c;
        dli2.DLIFlag__c = true;
        insert dli2;
        
        DLI_Site_CC_List__c ccl = new DLI_Site_CC_List__c();
        ccl.Contact__c = con2.Id;
        ccl.Discretionary_Line_Item__c = dli2.id;
        insert ccl;
        
        Discretionary_Spend__c ds2 = new Discretionary_Spend__c();
        ds2.Discretionary_Line_Item__c = dli2.Id;
        ds2.Weekly_Actuals__c = 42;
        insert ds2;
        dli2.Approval_Status__c = 'Pending open';
        update dli2;
        dli2.Approval_Status__c = 'Pending Close';
        dli2.Site_Comment_Drop_Down__c = 'Close';
        update dli2;
        dr2.Approval_Status__c = 'Pending Approval';
        test.stopTest();
    }*/
    static testMethod void TestMthd_DiscretionaryLineItem_UpdateEmailFields3(){  
        List<Discretionary_Line_Item__c> dlilist = new List<Discretionary_Line_Item__c>();
        User usr4 =[select id from user where profile.name = 'System Administrator' and isactive = true order by createddate desc limit 1];
        User usr5 =[select id from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account acc2=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
        
        Contact con2 = new Contact();
        con2.LastName = 'hari';
        con2.FirstName = 'vnv';
        con2.AccountId = acc2.Id;
        con2.SBU_Contact__c='ACS Labs';
        con2.CBT__c='ACS Sensors Lab';
        con2.CBT_Team__c='ACS Advanced Sensors';
        con2.Contact_Is_Employee__c = true;
        con2.employee_number__c = 'E777777';
        con2.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con2.Email='harikishore.vutukuri@honeywell.com';        
        insert con2;
        
        Service_request__c sr2 = [select id from Service_request__c limit 1];
        Opportunity opp2 = [select id from Opportunity where SBU__c = 'D&S' and RecordType.name like '%D&S PrePriced' limit 1];
        Discretionary__c dr2 = new Discretionary__c();
        dr2.Fiscal_Year__c = '2013';
        dr2.Service_request__c = sr2.id;
        dr2.Opportunity__c = opp2.id;
        dr2.M_PM_Funded_VOC_Project__c = 'No';
        dr2.Estimated_Completion_Date__c = system.today();
        dr2.Account__c = acc2.id;
        dr2.SBU__c = 'D&S';
        dr2.CBT__c = 'DAA';
        dr2.CBT_Team__c = 'CBMS';
        dr2.Type__c = 'Demo';
        dr2.Approval_Status__c = 'New';
        dr2.Engineering_lead_Contact__c = con2.id;
        dr2.CC_Email_id_from_Disc__c = 'harikishore.vutukuri@honeywell.com';
        dr2.Program__c = 'Testing';
        dr2.Engineering_lead_Contact_email_id__c = 'harikishore.vutukuri@honeywell.com';
        insert dr2;
        
        test.startTest();
        Discretionary_Line_Item__c dli2 = new Discretionary_Line_Item__c();
        dli2.Discretionary_Request__c = dr2.Id;
        dli2.Discretionary_Account__c = '400214235';
        dli2.Cost_Type__c = 'Labor';
        dli2.Approval_Status__c = 'New';
        dli2.Funding_Amount__c = 40;
        dli2.Engineering_lead_Contact__c = con2.Id;
        dli2.Discretionary_CC_List_Email__c = dli2.Discretionary_CC_List_Email_Formulae__c;
        dli2.Discretionary_Engineer_Lead_ContactEmail__c = dli2.DisEngr_Lead_Contact_EmailFormule__c;
        dli2.CC_Email_from_Disc__c = dli2.CC_Emailid_from_Disc__c;
        dli2.Eng_Lead_contact_email_from_Disc__c = dli2.Engineering_Contact_emailid_from_Disc__c;
        dli2.Account_Opener_Email__c = dli2.AccountOpener__c;
        dli2.Account_Opener_Backup_Email__c = dli2.Account_Opener_Backup__c;
        dli2.DLIFlag__c = true;
        insert dli2;
        
        DLI_Site_CC_List__c ccl = new DLI_Site_CC_List__c();
        ccl.Contact__c = con2.Id;
        ccl.Discretionary_Line_Item__c = dli2.id;
        insert ccl;
        
        Discretionary_Spend__c ds2 = new Discretionary_Spend__c();
        ds2.Discretionary_Line_Item__c = dli2.Id;
        ds2.Weekly_Actuals__c = 30;
        insert ds2;
        Discretionary_Spend__c ds3 = new Discretionary_Spend__c();
        ds3.Discretionary_Line_Item__c = dli2.Id;
        ds3.Weekly_Actuals__c = 35;
        insert ds3;
        Discretionary_Spend__c ds4 = new Discretionary_Spend__c();
        ds4.Discretionary_Line_Item__c = dli2.Id;
        ds4.Weekly_Actuals__c = 40;
        insert ds4;
        dli2.Approval_Status__c = 'Pending open';
        //update dli2;
        dli2.Approval_Status__c = 'Pending Close';
        dli2.Site_Comment_Drop_Down__c = 'Close';
        //update dli2;
        test.stopTest();}}