@isTest(SeeAllData=true)
global class TestClass_NavDBandTPinterface{
    testMethod static void testNavDBandTPinterface() {
        test.startTest();
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account acc = new Account();
        acc.Name = 'Testweb';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'TestNavDB';
        acc1.Customer_Status__c = 'Active';
        acc1.Strategic_Business_Unit__c = 'BGA';
        acc1.CBT__c = 'BGA Aftermarket';
        acc1.Region_Name__c = 'Americas';
        acc1.Sub_Region_Name__c = 'Canada';
        acc1.Service_Level__c = 'Standard';
        acc1.Type = 'Honeywell';
        acc1.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        insert acc1;
        
        Contact objContact = new Contact();
        objContact.LastName = 'hariiii';
        objContact.FirstName = 'testweb';
        objContact.AccountId = acc.Id;
        objContact.Primary_Email_Address__c = 'harikishore.vutukuri@honeywell.com';
        objContact.Email='harikishore.vutukuri@honeywell.com';
        objContact.User_Primary_Manager_Name__c = usr.Primary_Manager_Name__c;   
        objContact.User_Primary_Manager_EID__c = usr.Primary_Manager_EID__c;
        objContact.Employee_Number__c = 'E123123';
        objContact.Honeywell_ID__c = 'E123123';
        insert objContact;
                
        List<Account_Cross_Ref__c> acflist = new List<Account_Cross_Ref__c>();
        List<Account_Cross_Ref__c> acflist1 = new List<Account_Cross_Ref__c>();
        Account_Cross_Ref__c acf = new Account_Cross_Ref__c();
        acf.XREF_Type__c = 'SAP_SOLD_TO';
        acf.Account_Name__c = acc.id;
        acf.External_Account_ID__c = 'TEST-01';
        acf.Site_Code__c = 'TEST-01';
        acflist.add(acf);
        
        Account_Cross_Ref__c acf1 = new Account_Cross_Ref__c();
        acf1.XREF_Type__c = 'SAP_SOLD_TO';
        acf1.Account_Name__c = acc.id;
        acf1.External_Account_ID__c = 'TEST-02';
        acf1.Site_Code__c = 'TEST-02';
        acflist.add(acf1);
        insert acflist;
        
        Account_Cross_Ref__c acf2 = new Account_Cross_Ref__c();
        acf2.XREF_Type__c = 'NonSAP_SOLD_TO';
        acf2.Account_Name__c = acc1.id;
        acf2.External_Account_ID__c = 'TEST-03';
        acf2.Site_Code__c = 'TEST-03';
        acflist1.add(acf2);
        insert acflist1;
        
        List<NavDBandTPinterface.AccountCorssRefdetails> listacf = new List<NavDBandTPinterface.AccountCorssRefdetails>();
        List<NavDBandTPinterface.AccountCorssRefdetails> listacf1 = new List<NavDBandTPinterface.AccountCorssRefdetails>();
        for(integer i=0;i<acflist.size();i++){
            NavDBandTPinterface.AccountCorssRefdetails a = new NavDBandTPinterface.AccountCorssRefdetails();
            a.AccountNumber = acflist[i].External_Account_ID__c;
            a.XREFType = acflist[i].XREF_Type__c;
            listacf.add(a);
        }
        for(integer i=0;i<acflist1.size();i++){
            NavDBandTPinterface.AccountCorssRefdetails a1 = new NavDBandTPinterface.AccountCorssRefdetails();
            listacf1.add(a1);
        }
        String honid = 'E801543',honid1 = '',honid2='12',honid3='E801544';
        NavDBandTPinterface.NavDBandTPMethod(honid);
        NavDBandTPinterface.Result acfData = new NavDBandTPinterface.Result();                  
        acfData.Resultstatus = 'Success';
        acfData.lstAccountCorssRefdetails = listacf;
        
        NavDBandTPinterface.NavDBandTPMethod(honid1);
        NavDBandTPinterface.Result acfData1 = new NavDBandTPinterface.Result(); 
        acfData1.Resultstatus = 'Invalid data:Please provide valid honeywell id';
        acfData1.lstAccountCorssRefdetails = null;
        
        NavDBandTPinterface.NavDBandTPMethod(honid2);
        NavDBandTPinterface.Result acfData2 = new NavDBandTPinterface.Result(); 
        acfData2.Resultstatus = 'No contact found with provided honeywell id';
        acfData2.lstAccountCorssRefdetails = null;
        
        NavDBandTPinterface.NavDBandTPMethod(honid3);
        NavDBandTPinterface.Result acfData3 = new NavDBandTPinterface.Result(); 
        acfData3.Resultstatus = 'No Account records found with provided honeywell id';
        acfData3.lstAccountCorssRefdetails = null;
        test.stopTest();
    }    
}