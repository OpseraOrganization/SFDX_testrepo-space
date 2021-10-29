// Test class for "UpdateTextFieldwithTeammember" trigger
@isTest(SeeAllData=true)
private class TestCls_ApxTrgr_UpdtTxtFieldwithTeammem{
    static testMethod void TestCls_ApxTrgr_UpdtTxtFieldwithTeammem()
    {
        User usr =[select id,Name from user where profile.name = 'System Administrator' and isactive = true order by createddate desc limit 1];
        
        Account acc = new Account();
        acc.Name='Accountss';
        acc.Customer_Status__c='Active';
        acc.Region_Name__c='Americas';
        acc.Sub_Region_Name__c='Africa';
        acc.Service_Level__c='Comprehensive';
        acc.Strategic_Business_Unit__c='BGA';
        acc.CBT__c='Airbus';
        acc.CBT_Team__c='Airbus';
        acc.Market_Name__c='Air Transport';
        acc.Business_Owner__c='Ryan, Justin';
        acc.Type='Air Cargo Transporter';
        acc.REPORT_ACCOUNT_NAME__c='Test Report';
        acc.Team_Member__c = '';
        acc.BGA_Contract__c = '';
        acc.BGA_COntract_Test__c = true;
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name='Accountss';
        acc1.Customer_Status__c='Active';
        acc1.Region_Name__c='Americas';
        acc1.Sub_Region_Name__c='Africa';
        acc1.Service_Level__c='Comprehensive';
        acc1.Strategic_Business_Unit__c='BGA';
        acc1.CBT__c='Airbus';
        acc1.CBT_Team__c='Airbus';
        acc1.Market_Name__c='Air Transport';
        acc1.Business_Owner__c='Ryan, Justin';
        acc1.Type='Air Cargo Transporter';
        acc1.REPORT_ACCOUNT_NAME__c='Test Report';
        acc1.Team_Member__c = '';        
        insert acc1;
         
        Contact con1= new Contact();
        con1.AccountId=acc.Id;
        con1.LastName='Hariii1';
        con1.email='venkatesh.athanti@honeywell.com';
        con1.SBU_Contact__c='ACS Labs1';
        con1.CBT__c='ACS Sensors Lab1';
        con1.CBT_Team__c='ACS Advanced Sensors1';
        con1.Primary_Email_Address__c='venkatesh.athanti@honeywell.com';
        con1.Employee_number__c = 'E123123';
        con1.Phone_1__c= '12345676789';
        con1.Mobile_App_Role__c='Area Sales Manager';   
        con1.Job_Title__c='Honeywell1';     
        insert con1;
        
        Contact con= new Contact();
        con.AccountId=acc.Id;
        con.LastName='Hariii';
        con.email='venkatesh.athanti@honeywell.com';
        con.SBU_Contact__c='ACS Labs';
        con.CBT__c='ACS Sensors Lab';
        con.CBT_Team__c='ACS Advanced Sensors';
        con.Primary_Email_Address__c='venkatesh.athanti@honeywell.com';
        con.Employee_Number__C = 'E123121';
        con.Phone_1__c= '1234567678';
        con.Mobile_App_Role__c='Customer Support Manager';  
        con.Job_Title__c='Honeywell';
        con.Employee_Manager_Name__c=con1.id;       
        insert con;
        
        //SR# 433112 starts
        Platform__c pf = new Platform__c();
        pf.Name = 'TestHari';
        pf.Make__c = 'Testing';
        pf.Model__c = 'Testing';
        insert pf;
        
        Fleet_Asset_Aggregate__c fa = new FLeet_Asset_Aggregate__c();
        fa.Platform_Name__c = pf.id;
        fa.BGA_Contract__c = true;
        fa.Account_Name__c = acc.id;
        insert fa;
        //SR# 433112 Ends
                                            
        test.startTest();
        AccountTeamMember am = new AccountTeamMember();
        am.UserId = usr.id;
        am.TeamMemberRole = 'Customer Service Manager';
        am.AccountId = acc.id;
        insert am;
        acc.Team_Member__c = usr.Name;
       
        //SR#425128 starts
                                        
        Account_Address__c accadd=new Account_Address__c();
        accadd.Account_Name__c=acc1.id;
        accadd.Address_Type__c='Home';
        accadd.Report_Address_Line_1__c='test account address';
        accadd.Report_City_Name__c='test accadd report';
        accadd.Report_Country_Name__c='Report State Code';
        accadd.Mobile_App_Visibility_Check__c=true;
        accadd.Mobile_App_Visibility__c=true;
        insert accadd;
        
        Account_Address__c accadd1=new Account_Address__c();
        accadd1.Account_Name__c=acc.id;
        accadd1.Address_Type__c='Home';
        accadd1.Report_Address_Line_1__c='test account address';
        accadd1.Report_City_Name__c='test accadd report';
        accadd1.Report_Country_Name__c='Report State Code';
        accadd1.Mobile_App_Visibility_Check__c=true;
        accadd1.Mobile_App_Visibility__c=false;
        insert accadd1;
        
        user u=[select id,name from user where email='venkatesh.athanti@honeywell.com' limit 1];
        acc1.OwnerId =u.id;
        acc1.Customer_Status__c='inactive';     
        acc1.Strategic_Business_Unit__c='ATR';
        update acc1;
        
        acc.Strategic_Business_Unit__c='Intercompany';
        update acc;
        
        Account acc2 = new Account();
        acc2.Name='Accountss';
        acc2.Customer_Status__c='inActive';
        acc2.Region_Name__c='Americas';
        acc2.Sub_Region_Name__c='Africa';
        acc2.Service_Level__c='Comprehensive';
        acc2.Strategic_Business_Unit__c='Intercompany';
        acc2.CBT__c='Airbus';
        acc2.CBT_Team__c='Airbus';
        acc2.Market_Name__c='Air Transport';
        acc2.Business_Owner__c='Ryan, Justin';
        acc2.Type='Air Cargo Transporter';
        acc2.REPORT_ACCOUNT_NAME__c='Test Report';
        acc2.Team_Member__c = '';        
        insert acc2;
                        
        acc2.Customer_Status__c='active';
        update acc2;
                
        con.Job_Title__c='Honeywell NTTDATA';
        con.SBU_Contact__c='BGA';
        update con;
                            
        con1.SBU_Contact__c='ATR';
        con1.Job_Title__c='Honeywell NTTDATA';
        con1.Contact_Status__c='inactive';
        try{
        update con1;       
        }Catch(DMLException e){}
        
        //Skills2__c skill=[select id,name from Skills2__c where Skill_Type__c='Aircraft Type D-I' limit 1];
        //skill.Skill_Type__c='COE Product Type';
        //skill.Skill_Value__c='Electrical';
        //update skill;
        //SR#425128 ends
        test.stopTest();
    }
}