/***********************************************************************************************************
* Company Name          : Honeywell Aero
* Name                  : DiscretionaryLineItems_UpdtEmalFieldsTest
* Description           : Test Class to test the functionality of the Apex batch Job DiscretionaryLineItems_UpdateEmailFields.
* 
* Modification History  :
* Date             Version No.    Modified by           Brief Description of Modification
* 27-Apr-2018      0.1            Honeywell Aero               Initial Version
***********************************************************************************************************/
@isTest(seealldata=true)
private class DiscretionaryLineItems_UpdtEmalFieldTest{
    static testMethod void TestMthd_DiscretionaryLineItems_UpdateEmailFields(){  
        /*List<Discretionary_Line_Item__c> dlilist = new List<Discretionary_Line_Item__c>();
        User usr =[select id from user where profile.name = 'System Administrator' and isactive = true order by createddate desc limit 1];
        User usr1 =[select id from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        //Account accs=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1];
        
        account acc = new account();
        acc.name = 'EMS TECHNOLOGIES LTD./HONEYWELL N1235';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'Intercompany';
        acc.CBT__c = 'Temporary';
        acc.REPORT_ACCOUNT_NAME__c = 'Ems Technologies Ltd./Honeywell N1235';
        insert acc;
        
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
        
        //Opportunity opp = [select id from Opportunity where SBU__c = 'D&S' and RecordType.name like '%D&S PrePriced' limit 1];
        Opportunity opp = new Opportunity();
        opp.name='test';
        opp.SBU__c='D&S';
        opp.AccountId = acc.Id;
        opp.StageName='Dropped';
        opp.CloseDate=system.today();
        insert opp;
        
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
        insert dli;*/
        
        /*dr.Approval_Status__c = 'Approved';
        Update dr;
        
        Discretionary_Spend__c ds = new Discretionary_Spend__c();
        ds.Discretionary_Line_Item__c = dli.Id;
        ds.Weekly_Actuals__c = 20.12;
        insert ds;
        */
        test.startTest();
        DiscretionaryLineItems_UpdateEmailFields DLIUpdateEmail = new DiscretionaryLineItems_UpdateEmailFields ();
        Database.executeBatch(DLIUpdateEmail,1);
        
        test.stopTest();
    }
}