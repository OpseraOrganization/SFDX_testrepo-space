@isTest(SeeAllData=true)
Public class TestClass_ApexTrigger_UpdateAccountType{ 
    /*Commenting COde for no longer used for trigger UpdateAccountType
    static testMethod void TestClass_ApexTrigger_UpdateAccountTypeTest(){
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%HONEYWELL%' and Type = 'Honeywell' limit 1];
        Account acc1=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Customer_Status__c = 'Active' and Type = 'Owner/Operator' limit 1];
        Account acc2=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Customer_Status__c = 'Active' and Type = 'OEM' limit 1];
        Account acc3=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Customer_Status__c = 'Active' and Type = 'Service Center' limit 1];
        Account acc4=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Customer_Status__c = 'Active' and Type = 'Repair Shop' limit 1];
        Account acc5=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Customer_Status__c = 'Active' and Type = 'Commercial Airline' limit 1];
        
        List<Contact> conlist = new List<Contact>();
        Contact con = new Contact();
        con.LastName = 'Maintainer';
        con.FirstName = 'app';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con.Email='harikishore.vutukuri@honeywell.com';
        con.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        con.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;     
        conlist.add(con);
        
        Contact con1 = new Contact();
        con1.LastName = 'Maintainer';
        con1.FirstName = 'app1';
        con1.AccountId = acc1.Id;
        con1.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con1.Email='harikishore.vutukuri@honeywell.com';
        con1.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        con1.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;     
        conlist.add(con1);
        
        Contact con2 = new Contact();
        con2.LastName = 'Maintainer';
        con2.FirstName = 'app2';
        con2.AccountId = acc2.Id;
        con2.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con2.Email='harikishore.vutukuri@honeywell.com';
        con2.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        con2.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;     
        conlist.add(con2);
        
        Contact con3 = new Contact();
        con3.LastName = 'Maintainer';
        con3.FirstName = 'app3';
        con3.AccountId = acc3.Id;
        con3.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con3.Email='harikishore.vutukuri@honeywell.com';
        con3.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        con3.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;     
        conlist.add(con3);
        
        Contact con4 = new Contact();
        con4.LastName = 'Maintainer';
        con4.FirstName = 'app4';
        con4.AccountId = acc4.Id;
        con4.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con4.Email='harikishore.vutukuri@honeywell.com';
        con4.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        con4.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;     
        conlist.add(con4);
        
        Contact con5 = new Contact();
        con5.LastName = 'Maintainer';
        con5.FirstName = 'app5';
        con5.AccountId = acc5.Id;
        con5.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        con5.Email='harikishore.vutukuri@honeywell.com';
        con5.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        con5.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;     
        conlist.add(con5);
        try{
            insert conlist;
        }catch(DMLException e){}
        
        List<Contact_Tool_Access__c> ctalist = new List<Contact_Tool_Access__c>();
        List<Contact_Tool_Access__c> ctalistupdate = new List<Contact_Tool_Access__c>();
        Contact_Tool_Access__c cta = new Contact_Tool_Access__c();
        cta.Name = 'Fault Analyser Services (MyMaintainer)';
        cta.Portal_Tool_Master__c = label.MyMaintainer_Tool_ID;
        cta.CRM_Contact_ID__c = con.id;
        cta.Request_Status__c = 'Pending';
        cta.MyMaintainer_Roles__c = '';
        cta.Portal_Honeywell_ID__c = 'hontest123';
        ctalist.add(cta);
        
        Contact_Tool_Access__c cta1 = new Contact_Tool_Access__c();
        cta1.Name = 'Fault Analyser Services (MyMaintainer)';
        cta1.Portal_Tool_Master__c = label.MyMaintainer_Tool_ID;
        cta1.CRM_Contact_ID__c = con1.id;
        cta1.Request_Status__c = 'Pending';
        cta1.MyMaintainer_Roles__c = '';
        cta1.Portal_Honeywell_ID__c = 'hontest1231';
        ctalist.add(cta1);
        
        Contact_Tool_Access__c cta2 = new Contact_Tool_Access__c();
        cta2.Name = 'Fault Analyser Services (MyMaintainer)';
        cta2.Portal_Tool_Master__c = label.MyMaintainer_Tool_ID;
        cta2.CRM_Contact_ID__c = con2.id;
        cta2.Request_Status__c = 'Pending';
        cta2.MyMaintainer_Roles__c = '';
        cta2.Portal_Honeywell_ID__c = 'hontest1232';
        ctalist.add(cta2);
        
        Contact_Tool_Access__c cta3 = new Contact_Tool_Access__c();
        cta3.Name = 'Fault Analyser Services (MyMaintainer)';
        cta3.Portal_Tool_Master__c = label.MyMaintainer_Tool_ID;
        cta3.CRM_Contact_ID__c = con3.id;
        cta3.Request_Status__c = 'Pending';
        cta3.MyMaintainer_Roles__c = '';
        cta3.Portal_Honeywell_ID__c = 'hontest1233';
        ctalist.add(cta3);
        
        Contact_Tool_Access__c cta4 = new Contact_Tool_Access__c();
        cta4.Name = 'Fault Analyser Services (MyMaintainer)';
        cta4.Portal_Tool_Master__c = label.MyMaintainer_Tool_ID;
        cta4.CRM_Contact_ID__c = con4.id;
        cta4.Request_Status__c = 'Pending';
        cta4.MyMaintainer_Roles__c = '';
        cta4.Portal_Honeywell_ID__c = 'hontest1234';
        ctalist.add(cta4);
        
        Contact_Tool_Access__c cta5 = new Contact_Tool_Access__c();
        cta5.Name = 'Fault Analyser Services (MyMaintainer)';
        cta5.Portal_Tool_Master__c = label.MyMaintainer_Tool_ID;
        cta5.CRM_Contact_ID__c = con5.id;
        cta5.Request_Status__c = 'Pending';
        cta5.MyMaintainer_Roles__c = '';
        cta5.Portal_Honeywell_ID__c = 'hontest1235';
        ctalist.add(cta5);
        try{
            insert ctalist;
        }catch(DMLException ee){}
        
        Test.startTest();
        ctalist[0].MyMaintainer_Roles__c = 'Honeywell Admin';
        ctalistupdate.add(ctalist[0]);
        
        ctalist[1].MyMaintainer_Roles__c = 'Operator Admin';
        ctalistupdate.add(ctalist[1]);
        
        ctalist[2].MyMaintainer_Roles__c = 'OEM Admin';
        ctalistupdate.add(ctalist[2]);
        
        ctalist[3].MyMaintainer_Roles__c = 'Operator Admin';
        ctalistupdate.add(ctalist[3]);
        
        ctalist[4].MyMaintainer_Roles__c = 'Operator Admin';
        ctalistupdate.add(ctalist[4]);
        
        ctalist[5].MyMaintainer_Roles__c = 'Operator Admin';
        ctalistupdate.add(ctalist[5]);
        
        try{
            update ctalistupdate;
        }catch(DMLException eee){}
        Test.stopTest();
    }*/
}