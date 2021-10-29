@isTest(SeeAllData=true)
private class Contact_UpdateSBUTest{ 
    static testMethod void Contact_UpdateSBUTest(){
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account acc=[select id,name,Customer_Status__c,CBT_Team__c,CBT_Directorate__c,Strategic_Business_Unit__c,Sales_Channel__c,SC1__c,SC2__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%HONEYWELL%' limit 1];
        Account acc1=[select id,name,Customer_Status__c,CBT_Team__c,CBT_Directorate__c,Strategic_Business_Unit__c,Sales_Channel__C,SC1__c,SC2__C,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%HONEYWELL%' ORDER BY Name DESC limit 1];
        
        Contact con = new Contact();
        con.LastName = 'testupdate';
        con.FirstName = 'sbucon';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con.Employee_Number__c = 'E123123';
        con.Email='harikishore.vutukuri@honeywell.com';
        con.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        con.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
        con.Contact_Is_Employee__c = true;
        con.SBU_Contact__c = '';
        con.CBT__c = '';
        con.CBT_Team__c = '';
        con.CBT_Directorate__c = '';
        con.Sales_Channel_Contact__c='';
        con.SC1__c='';
        con.SC2__c='';
        insert con;
        
        Test.StartTest();                
        con.Contact_Is_Employee__c = false;
        con.SBU_Contact__c = con.SBU_Formulae__c;
        con.CBT__c = con.CBT_Formulae__c;
        con.CBT_Team__c = con.CBT_Team_Formulae__c;
        con.CBT_Directorate__c = con.CBT_Directorate_Formulae__c;
        con.Sales_Channel_Contact__C = con.Sales_Channel_Formulae__c;
        con.SC1__c = con.Sub_Channel_Formulae__c;
        con.SC2__c = con.Sub_Channel2_Formulae__c;
        update con;
        
        con.AccountId = acc1.id;
        update con;
        Test.StopTest();
        
        
      
    }
}