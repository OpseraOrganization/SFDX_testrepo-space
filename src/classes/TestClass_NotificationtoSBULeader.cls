@isTest(SeeAllData=true)
private class TestClass_NotificationtoSBULeader{ 
    static testMethod void TestClass_NotificationtoSBULeader(){
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'Honeywell System Administrator (Non US)' and isactive = true order by createddate asc limit 1];
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%HONEYWELL%' and (NOT Name LIKE '%HONEYWELL Unidentified Portal Users%') and (Strategic_Business_Unit__c='ATR' or Strategic_Business_Unit__c='BGA' or Strategic_Business_Unit__c='D&S') limit 1];
        
        Contact objContact = new Contact();
        objContact.LastName = 'test2424';
        objContact.FirstName = 'sbu2321';
        objContact.AccountId = acc.Id;
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        objContact.Email='harikishore.vutukuri@honeywell.com';
        objContact.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;  
        objContact.Employee_Number__c = 'E000002';
        insert objContact;
        
        List<case> c = new List<Case>();
        Case cs = new Case();
        cs.Origin = 'Email';
        cs.Status = 'Open';                
        cs.ContactId = objContact.Id;
        cs.RecordtypeId = label.Orders_Rec_ID;
        cs.Classification__c = 'EMS';
        cs.Type = 'Place Order';
        cs.HON_Commit_Date__c = system.today();
        cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs.Government_Compliance_SM_M_Content__c = 'No';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs.OwnerId = usr.id;
        c.add(cs);
        
        Case cs1 = new Case();
        cs1.Origin = 'Email';
        cs1.Status = 'Open';                
        cs1.ContactId = objContact.Id;
        cs1.RecordtypeId = label.Orders_Rec_ID;
        cs1.Classification__c = 'EMS';
        cs1.Type = 'Place Order';
        cs1.HON_Commit_Date__c = system.today();
        cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs1.Government_Compliance_SM_M_Content__c = 'No';
        cs1.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs1.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs1.OwnerId = usr.id;
        c.add(cs1);
        try{
            insert c;
        }catch(DMLException e){}
        
        List<Case> ca = [select id,CaseNumber,(select id,Age_in_Minutes__c,X7_Days_Case_Age_date__c,X7_Days_Case_Age__c,Eight_Emails_on_Case__c, Eight_Emails_on_Case_Date__c,Four_Owner_Change_count__c,Four_Owner_Changes_Date__c,Four_Owner_Changes__c,Three_ReOpen_Count__c,Three_Re_Opens_Date__c,Three_Re_Opens__c from CASE.Case_Extensions__r) from Case where id IN:c];
        Case_Extension__c CasExt = new Case_Extension__c();
        if(ca[0].Case_Extensions__r!=null && ca[0].Case_Extensions__r.size()>0){
            system.debug('---->If');
            CasExt = ca[0].Case_Extensions__r;
        }else{
            system.debug('---->else');
            CasExt.Case_object__c = ca[0].id;                
        }
        CasExt.Four_Owner_Change_count__c = 0;
        CasExt.Four_Owner_Changes_Date__c = null;
        CasExt.Four_Owner_Changes__c = FALSE;
        CasExt.Three_ReOpen_Count__c = 0;
        CasExt.Three_Re_Opens_Date__c = null;
        CasExt.Three_Re_Opens__c = FALSE;
        CasExt.Eight_Emails_on_Case_Date__c = null;
        CasExt.Eight_Emails_on_Case__c = FALSE;
        CasExt.X7_Days_Case_Age_date__c = null;
        CasExt.X7_Days_Case_Age__c = FALSE;
        upsert CasExt;
        
        Case_Extension__c CasExt1 = new Case_Extension__c();
        if(ca[1].Case_Extensions__r!=null && ca[1].Case_Extensions__r.size()>0){
            CasExt1 = ca[1].Case_Extensions__r;
        }else{
            system.debug('---->else');
            CasExt1.Case_object__c = ca[1].id;                
        }
        CasExt1.Four_Owner_Change_count__c = 0;
        CasExt1.Four_Owner_Changes_Date__c = null;
        CasExt1.Four_Owner_Changes__c = FALSE;
        CasExt1.Three_ReOpen_Count__c = 0;
        CasExt1.Three_Re_Opens_Date__c = null;
        CasExt1.Three_Re_Opens__c = FALSE;
        CasExt1.Eight_Emails_on_Case_Date__c = null;
        CasExt1.Eight_Emails_on_Case__c = FALSE;
        CasExt1.X7_Days_Case_Age_date__c = null;
        CasExt1.X7_Days_Case_Age__c = FALSE;
        upsert CasExt1;
        
        Test.StartTest();   
        CasExt.Four_Owner_Change_count__c = 4;
        CasExt.Four_Owner_Changes_Date__c = system.today();
        CasExt.Four_Owner_Changes__c = TRUE;
        CasExt.Three_ReOpen_Count__c = 3;
        CasExt.Three_Re_Opens_Date__c = system.today();
        CasExt.Three_Re_Opens__c = TRUE;
        try{
        update CasExt;
        }catch(DMLException e){}
        
        CasExt1.Four_Owner_Change_count__c = 4;
        CasExt1.Four_Owner_Changes_Date__c = system.today();
        CasExt1.Four_Owner_Changes__c = TRUE;
        try{
        update CasExt1;
        }catch(DMLException e1){}
        Test.StopTest();
    }
    static testMethod void TestClass_NotificationtoSBULeader1(){
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where alias = 'sadmin' and isactive = true order by createddate asc limit 1];
        //User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Strategic_Business_Unit__c='ATR' and Customer_Status__c = 'Active' limit 1];
        
        Contact objContact = new Contact();
        objContact.LastName = 'test2424';
        objContact.FirstName = 'sbu2321';
        objContact.AccountId = acc.Id;
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        objContact.Email='harikishore.vutukuri@honeywell.com';
        objContact.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;  
        objContact.Employee_Number__c = 'E000002';
        insert objContact;
        
        List<case> c = new List<Case>();
        Case cs = new Case();
        cs.Origin = 'Email';
        cs.Status = 'Open';                
        cs.ContactId = objContact.Id;
        cs.RecordtypeId = label.Orders_Rec_ID;
        cs.Classification__c = 'EMS';
        cs.Type = 'Place Order';
        cs.HON_Commit_Date__c = system.today();
        cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs.Government_Compliance_SM_M_Content__c = 'No';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs.OwnerId = usr.id;
        c.add(cs);
        
        Case cs1 = new Case();
        cs1.Origin = 'Email';
        cs1.Status = 'Open';                
        cs1.ContactId = objContact.Id;
        cs1.RecordtypeId = label.Orders_Rec_ID;
        cs1.Classification__c = 'EMS';
        cs1.Type = 'Place Order';
        cs1.HON_Commit_Date__c = system.today();
        cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs1.Government_Compliance_SM_M_Content__c = 'No';
        cs1.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs1.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs1.OwnerId = usr.id;
        c.add(cs1);
        try{
            insert c;
        }catch(DMLException e){}
        
        List<Case> ca = [select id,CaseNumber,(select id,Age_in_Minutes__c,X7_Days_Case_Age_date__c,X7_Days_Case_Age__c,Eight_Emails_on_Case__c, Eight_Emails_on_Case_Date__c,Four_Owner_Change_count__c,Four_Owner_Changes_Date__c,Four_Owner_Changes__c,Three_ReOpen_Count__c,Three_Re_Opens_Date__c,Three_Re_Opens__c from CASE.Case_Extensions__r) from Case where id IN:c];
        Case_Extension__c CasExt = new Case_Extension__c();
        if(ca[0].Case_Extensions__r!=null && ca[0].Case_Extensions__r.size()>0){
            system.debug('---->If');
            CasExt = ca[0].Case_Extensions__r;
        }else{
            system.debug('---->else');
            CasExt.Case_object__c = ca[0].id;                
        }
        CasExt.Four_Owner_Change_count__c = 0;
        CasExt.Four_Owner_Changes_Date__c = null;
        CasExt.Four_Owner_Changes__c = FALSE;
        CasExt.Three_ReOpen_Count__c = 0;
        CasExt.Three_Re_Opens_Date__c = null;
        CasExt.Three_Re_Opens__c = FALSE;
        CasExt.Eight_Emails_on_Case_Date__c = null;
        CasExt.Eight_Emails_on_Case__c = FALSE;
        CasExt.X7_Days_Case_Age_date__c = null;
        CasExt.X7_Days_Case_Age__c = FALSE;
        upsert CasExt;
        
        Case_Extension__c CasExt1 = new Case_Extension__c();
        if(ca[1].Case_Extensions__r!=null && ca[1].Case_Extensions__r.size()>0){
            CasExt1 = ca[1].Case_Extensions__r;
        }else{
            system.debug('---->else');
            CasExt1.Case_object__c = ca[1].id;                
        }
        CasExt1.Four_Owner_Change_count__c = 0;
        CasExt1.Four_Owner_Changes_Date__c = null;
        CasExt1.Four_Owner_Changes__c = FALSE;
        CasExt1.Three_ReOpen_Count__c = 0;
        CasExt1.Three_Re_Opens_Date__c = null;
        CasExt1.Three_Re_Opens__c = FALSE;
        CasExt1.Eight_Emails_on_Case_Date__c = null;
        CasExt1.Eight_Emails_on_Case__c = FALSE;
        CasExt1.X7_Days_Case_Age_date__c = null;
        CasExt1.X7_Days_Case_Age__c = FALSE;
        upsert CasExt1;
        
        Test.StartTest();   
        CasExt.Eight_Emails_on_Case_Date__c = system.today();
        CasExt.Eight_Emails_on_Case__c = TRUE;
        CasExt.Three_ReOpen_Count__c = 3;
        CasExt.Three_Re_Opens_Date__c = system.today();
        CasExt.Three_Re_Opens__c = TRUE;
        try{
        update CasExt;
        }catch(DMLException e){}
        
        CasExt1.Three_ReOpen_Count__c = 3;
        CasExt1.Three_Re_Opens_Date__c = system.today();
        CasExt1.Three_Re_Opens__c = TRUE;
        try{
        update CasExt1;
        }catch(DMLException e1){}
        Test.StopTest();
    }
    static testMethod void TestClass_NotificationtoSBULeader2(){
       User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where alias='sadmin' and isactive = true order by createddate asc limit 1];
       //  User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Strategic_Business_Unit__c='BGA' and Customer_Status__c = 'Active' limit 1];
        
        Contact objContact = new Contact();
        objContact.LastName = 'test2424';
        objContact.FirstName = 'sbu2321';
        objContact.AccountId = acc.Id;
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        objContact.Email='harikishore.vutukuri@honeywell.com';
        objContact.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;  
        objContact.Employee_Number__c = 'E000002';
        insert objContact;
        
        List<case> c = new List<Case>();
        Case cs = new Case();
        cs.Origin = 'Email';
        cs.Status = 'Open';                
        cs.ContactId = objContact.Id;
        cs.RecordtypeId = label.Orders_Rec_ID;
        cs.Classification__c = 'EMS';
        cs.Type = 'Place Order';
        cs.HON_Commit_Date__c = system.today();
        cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs.Government_Compliance_SM_M_Content__c = 'No';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs.OwnerId = usr.id;
        c.add(cs);
        
        Case cs1 = new Case();
        cs1.Origin = 'Email';
        cs1.Status = 'Open';                
        cs1.ContactId = objContact.Id;
        cs1.RecordtypeId = label.Orders_Rec_ID;
        cs1.Classification__c = 'EMS';
        cs1.Type = 'Place Order';
        cs1.HON_Commit_Date__c = system.today();
        cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs1.Government_Compliance_SM_M_Content__c = 'No';
        cs1.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs1.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs1.OwnerId = usr.id;
        c.add(cs1);
        try{
            insert c;
        }catch(DMLException e){}
        
        List<Case> ca = [select id,CaseNumber,(select id,Age_in_Minutes__c,X7_Days_Case_Age_date__c,X7_Days_Case_Age__c,Eight_Emails_on_Case__c, Eight_Emails_on_Case_Date__c,Four_Owner_Change_count__c,Four_Owner_Changes_Date__c,Four_Owner_Changes__c,Three_ReOpen_Count__c,Three_Re_Opens_Date__c,Three_Re_Opens__c from CASE.Case_Extensions__r) from Case where id IN:c];
        Case_Extension__c CasExt = new Case_Extension__c();
        if(ca[0].Case_Extensions__r!=null && ca[0].Case_Extensions__r.size()>0){
            system.debug('---->If');
            CasExt = ca[0].Case_Extensions__r;
        }else{
            system.debug('---->else');
            CasExt.Case_object__c = ca[0].id;                
        }
        CasExt.Four_Owner_Change_count__c = 0;
        CasExt.Four_Owner_Changes_Date__c = null;
        CasExt.Four_Owner_Changes__c = FALSE;
        CasExt.Three_ReOpen_Count__c = 0;
        CasExt.Three_Re_Opens_Date__c = null;
        CasExt.Three_Re_Opens__c = FALSE;
        CasExt.Eight_Emails_on_Case_Date__c = null;
        CasExt.Eight_Emails_on_Case__c = FALSE;
        CasExt.X7_Days_Case_Age_date__c = null;
        CasExt.X7_Days_Case_Age__c = FALSE;
        upsert CasExt;
        
        Case_Extension__c CasExt1 = new Case_Extension__c();
        if(ca[1].Case_Extensions__r!=null && ca[1].Case_Extensions__r.size()>0){
            CasExt1 = ca[1].Case_Extensions__r;
        }else{
            system.debug('---->else');
            CasExt1.Case_object__c = ca[1].id;                
        }
        CasExt1.Four_Owner_Change_count__c = 0;
        CasExt1.Four_Owner_Changes_Date__c = null;
        CasExt1.Four_Owner_Changes__c = FALSE;
        CasExt1.Three_ReOpen_Count__c = 0;
        CasExt1.Three_Re_Opens_Date__c = null;
        CasExt1.Three_Re_Opens__c = FALSE;
        CasExt1.Eight_Emails_on_Case_Date__c = null;
        CasExt1.Eight_Emails_on_Case__c = FALSE;
        CasExt1.X7_Days_Case_Age_date__c = null;
        CasExt1.X7_Days_Case_Age__c = FALSE;
        upsert CasExt1;
        
        Test.StartTest();   
        CasExt.X7_Days_Case_Age_date__c = system.today();
        CasExt.X7_Days_Case_Age__c = TRUE;
        CasExt.Eight_Emails_on_Case_Date__c = system.today();
        CasExt.Eight_Emails_on_Case__c = TRUE;
        try{
        update CasExt;
        }catch(DMLException e){}
        
        CasExt1.Eight_Emails_on_Case_Date__c = system.today();
        CasExt1.Eight_Emails_on_Case__c = TRUE;
        try{
        update CasExt1;
        }catch(DMLException e1){}
        Test.StopTest();
    }
    static testMethod void TestClass_NotificationtoSBULeader3(){
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where alias='sadmin' and isactive = true order by createddate asc limit 1];
        //User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Strategic_Business_Unit__c='ATR' and Customer_Status__c = 'Active' limit 1];
        
        Contact objContact = new Contact();
        objContact.LastName = 'test2424';
        objContact.FirstName = 'sbu2321';
        objContact.AccountId = acc.Id;
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        objContact.Email='harikishore.vutukuri@honeywell.com';
        objContact.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;  
        objContact.Employee_Number__c = 'E000002';
        insert objContact;
        
        List<case> c = new List<Case>();
        Case cs = new Case();
        cs.Origin = 'Email';
        cs.Status = 'Open';                
        cs.ContactId = objContact.Id;
        cs.RecordtypeId = label.Orders_Rec_ID;
        cs.Classification__c = 'EMS';
        cs.Type = 'Place Order';
        cs.HON_Commit_Date__c = system.today();
        cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs.Government_Compliance_SM_M_Content__c = 'No';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs.CreatedDate = system.today()-7;
        cs.OwnerId = usr.id;
        c.add(cs);
        
        Case cs1 = new Case();
        cs1.Origin = 'Email';
        cs1.Status = 'Open';                
        cs1.ContactId = objContact.Id;
        cs1.RecordtypeId = label.Orders_Rec_ID;
        cs1.Classification__c = 'EMS';
        cs1.Type = 'Place Order';
        cs1.HON_Commit_Date__c = system.today();
        cs1.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs1.Government_Compliance_SM_M_Content__c = 'No';
        cs1.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs1.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs1.OwnerId = usr.id;
        c.add(cs1);
        try{
            insert c;
        }catch(DMLException e){}
        
        List<Case> ca = [select id,CaseNumber,(select id,Age_in_Minutes__c,X7_Days_Case_Age_date__c,X7_Days_Case_Age__c,Eight_Emails_on_Case__c, Eight_Emails_on_Case_Date__c,Four_Owner_Change_count__c,Four_Owner_Changes_Date__c,Four_Owner_Changes__c,Three_ReOpen_Count__c,Three_Re_Opens_Date__c,Three_Re_Opens__c from CASE.Case_Extensions__r) from Case where id IN:c];
        Case_Extension__c CasExt = new Case_Extension__c();
        if(ca[0].Case_Extensions__r!=null && ca[0].Case_Extensions__r.size()>0){
            system.debug('---->If');
            CasExt = ca[0].Case_Extensions__r;
        }else{
            system.debug('---->else');
            CasExt.Case_object__c = ca[0].id;                
        }
        CasExt.Four_Owner_Change_count__c = 0;
        CasExt.Four_Owner_Changes_Date__c = null;
        CasExt.Four_Owner_Changes__c = FALSE;
        CasExt.Three_ReOpen_Count__c = 0;
        CasExt.Three_Re_Opens_Date__c = null;
        CasExt.Three_Re_Opens__c = FALSE;
        CasExt.Eight_Emails_on_Case_Date__c = null;
        CasExt.Eight_Emails_on_Case__c = FALSE;
        CasExt.X7_Days_Case_Age_date__c = null;
        CasExt.X7_Days_Case_Age__c = FALSE;
        upsert CasExt;
        
        Case_Extension__c CasExt1 = new Case_Extension__c();
        if(ca[1].Case_Extensions__r!=null && ca[1].Case_Extensions__r.size()>0){
            CasExt1 = ca[1].Case_Extensions__r;
        }else{
            system.debug('---->else');
            CasExt1.Case_object__c = ca[1].id;                
        }
        CasExt1.Four_Owner_Change_count__c = 0;
        CasExt1.Four_Owner_Changes_Date__c = null;
        CasExt1.Four_Owner_Changes__c = FALSE;
        CasExt1.Three_ReOpen_Count__c = 0;
        CasExt1.Three_Re_Opens_Date__c = null;
        CasExt1.Three_Re_Opens__c = FALSE;
        CasExt1.Eight_Emails_on_Case_Date__c = null;
        CasExt1.Eight_Emails_on_Case__c = FALSE;
        CasExt1.X7_Days_Case_Age_date__c = null;
        CasExt1.X7_Days_Case_Age__c = FALSE;
        upsert CasExt1;
        
        Test.StartTest();   
        CasExt.X7_Days_Case_Age_date__c = system.today();
        CasExt.X7_Days_Case_Age__c = TRUE;
        CasExt.Four_Owner_Change_count__c = 4;
        CasExt.Four_Owner_Changes_Date__c = system.today();
        CasExt.Four_Owner_Changes__c = TRUE;
        try{
        update CasExt;
        }catch(DMLException e){}
        
        CasExt1.X7_Days_Case_Age_date__c = system.today();
        CasExt1.X7_Days_Case_Age__c = TRUE;
        try{
        update CasExt1;
        }catch(DMLException e1){}
        Test.StopTest();
    }  
    static testMethod void TestClass_NotificationtoSBULeader4(){
       User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where alias='sadmin' and isactive = true order by createddate asc limit 1];
        // User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Strategic_Business_Unit__c='ATR' and Customer_Status__c = 'Active' limit 1];
        
        Contact objContact = new Contact();
        objContact.LastName = 'test2mmapp';
        objContact.FirstName = 'sbu2mmapp';
        objContact.AccountId = acc.Id;
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        objContact.Email='harikishore.vutukuri@honeywell.com';
        objContact.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;  
        objContact.Employee_Number__c = 'E000002';
        objContact.Address_Line_1__c = 'Test Address';
        objContact.Phone = '(520) 469-4066';
        objContact.Fax = '123467989';
        objContact.Middle_Name__c = 'testmm';
        insert objContact;
        
        List<case> c = new List<Case>();
        Case cs = new Case();
        cs.Origin = 'Web';
        cs.Status = 'Open';                
        cs.ContactId = objContact.Id;
        cs.RecordTypeId= label.web;
        cs.Classification__c = 'EMS';
        cs.Type = 'Place Order';
        cs.HON_Commit_Date__c = system.today();
        cs.Export_Compliance_Content_ITAR_EAR__c = 'No';
        cs.Government_Compliance_SM_M_Content__c = 'No';
        cs.Primary_Email__c = 'harikishore.vutukuri@honeywell.com';
        cs.SuppliedEmail = 'harikishore.vutukuri@honeywell.com'; 
        cs.CreatedDate = system.today()-7;
        cs.OwnerId = usr.id;
        cs.Subject = 'MyAerospace Registration Request – Fault Analyzer Services (MYMAINTAINER)';
        cs.Honeywell_ID__c = 'E801543';
        c.add(cs);
        
        try{
            insert c;
        }catch(DMLException e){}
        
        Portal_Honeywell_ID__c p = new Portal_Honeywell_ID__c();
        p.name = 'E801543';
        p.Primary_Honeywell_ID__c= true;
        insert p;
        
        List<Case> ca = [select id,CaseNumber,(select id,Age_in_Minutes__c,X7_Days_Case_Age_date__c,X7_Days_Case_Age__c,Eight_Emails_on_Case__c, Eight_Emails_on_Case_Date__c,Four_Owner_Change_count__c,Four_Owner_Changes_Date__c,Four_Owner_Changes__c,Three_ReOpen_Count__c,Three_Re_Opens_Date__c,Three_Re_Opens__c from CASE.Case_Extensions__r) from Case where id IN:c];
        Case_Extension__c CasExt = new Case_Extension__c();
        if(ca[0].Case_Extensions__r!=null && ca[0].Case_Extensions__r.size()>0){
            system.debug('---->If');
            CasExt = ca[0].Case_Extensions__r;
        }else{
            system.debug('---->else');
            CasExt.Case_object__c = ca[0].id;                
        }
        CasExt.Four_Owner_Change_count__c = 0;
        CasExt.Four_Owner_Changes_Date__c = null;
        CasExt.Four_Owner_Changes__c = FALSE;
        CasExt.Three_ReOpen_Count__c = 0;
        CasExt.Three_Re_Opens_Date__c = null;
        CasExt.Three_Re_Opens__c = FALSE;
        CasExt.Eight_Emails_on_Case_Date__c = null;
        CasExt.Eight_Emails_on_Case__c = FALSE;
        CasExt.X7_Days_Case_Age_date__c = null;
        CasExt.X7_Days_Case_Age__c = FALSE;
        CasExt.MyMaintainer_Roles__c = '';
        CasExt.status__c = '';
        upsert CasExt;
        Portal_Honeywell_ID__c aa =[Select id,name,status__c,MiddleName__c,MyMaintainer_Roles__c,Primary_Honeywell_ID__c,account_name__c,Account_Type__c,Address_Line_1__c,Primary_Email_Address__c,phone__c,Fax__c,FirstName__c,LastName__c,Name__c from Portal_Honeywell_ID__c where Primary_Honeywell_ID__c=true limit 1];
        Test.StartTest();   
        CasExt.X7_Days_Case_Age_date__c = system.today();
        CasExt.X7_Days_Case_Age__c = TRUE;
        CasExt.Four_Owner_Change_count__c = 4;
        CasExt.Four_Owner_Changes_Date__c = system.today();
        CasExt.Four_Owner_Changes__c = TRUE;
        CasExt.MyMaintainer_Roles__c = 'Line Maintainer';
        CasExt.status__c = 'Approved';
               
        try{
        update CasExt;
        }catch(DMLException e){}
        test.setCurrentPage(new PageReference('Page.MyMaintainer_Popup')); 
        ApexPages.StandardController sc = new ApexPages.standardController(ca[0]);
        ApexPages.currentPage().getParameters().put('id',ca[0].id);
        MyMaintainer_PopupClass controller = new MyMaintainer_PopupClass(sc);
        Test.StopTest();
    }
}