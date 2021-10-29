@isTest
class sendGDCRemindersBatch_TestClass{
    //Test method for sendGDCRemindersBatch
    static testMethod void testSendGDCReminder() 
    {
       
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
        Id rt= [select id,name from recordtype where sobjecttype='Case' and name='GDC Tech Issue'].id;
        Contact con = new Contact();
        con.LastName = 'Kulkarni';
        con.FirstName = 'Shrivaths';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'shrivaths.kulkarni@nttdata.com';
        con.Email='shrivaths.kulkarni@nttdata.com';
        insert con;
        
        test.startTest();
        Case cseLow = new Case();
        cseLow.Origin = 'Email';
        cseLow.Status = 'Open';
         cseLow.RecordTypeId = rt;
         cseLow.Classification__c = 'MyGDC';
         cseLow.ContactId = con.Id;
         cseLow.Type_of_Change__c = 'New Account';
         cseLow.Type = 'Other';
         cseLow.Export_Compliance_Content_ITAR_EAR__c = 'NO';
         cseLow.Government_Compliance_SM_M_Content__c = 'NO';
         cseLow.priority = 'Low';
         cseLow.DateSetForOpen__c = system.Today().adddays(-10);
         insert cseLow;
          
         sendGDCRemindersBatch gdcNew = new sendGDCRemindersBatch ();
         Database.executeBatch(gdcNew,200);
        test.stopTest();
         
    }
    static testMethod void testSendGDCReminder1() 
    {
       
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
        Id rt= [select id,name from recordtype where sobjecttype='Case' and name='GDC Tech Issue'].id;
        Contact con = new Contact();
        con.LastName = 'Kulkarni';
        con.FirstName = 'Shrivaths';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'shrivaths.kulkarni@nttdata.com';
        con.Email='shrivaths.kulkarni@nttdata.com';
        insert con;
        
        test.startTest();
        
        
        //for Normal priority case
        Case cseNormal = new Case();
        cseNormal.Origin = 'Email';
        cseNormal.Status = 'Open';
         cseNormal.RecordTypeId = rt;
         cseNormal.Classification__c = 'MyGDC';
         cseNormal.ContactId = con.Id;
         cseNormal.Type_of_Change__c = 'New Account';
         cseNormal.Type = 'Other';
         cseNormal.Export_Compliance_Content_ITAR_EAR__c = 'NO';
         cseNormal.Government_Compliance_SM_M_Content__c = 'NO';
         cseNormal.priority = 'Normal';
        cseNormal.DateSetForOpen__c = system.Today().adddays(-5);
         insert cseNormal;
        
         sendGDCRemindersBatch gdcNew = new sendGDCRemindersBatch ();
         Database.executeBatch(gdcNew,200);
         test.stopTest();
         
    }
    
    static testMethod void testSendGDCReminder2() 
    {
       
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
        Id rt= [select id,name from recordtype where sobjecttype='Case' and name='GDC Tech Issue'].id;
        Contact con = new Contact();
        con.LastName = 'Kulkarni';
        con.FirstName = 'Shrivaths';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'shrivaths.kulkarni@nttdata.com';
        con.Email='shrivaths.kulkarni@nttdata.com';
        insert con;
        
        test.startTest();
        
        //for High priority case
        List<case> cas1=new List<case>();
        Case cseHigh = new Case();
        cseHigh.Origin = 'Email';
        cseHigh.Status = 'Open';
         cseHigh.RecordTypeId = rt;
         cseHigh.Classification__c = 'MyGDC';
         cseHigh.ContactId = con.Id;
         cseHigh.Type_of_Change__c = 'New Account';
         cseHigh.Type = 'Other';
         cseHigh.Export_Compliance_Content_ITAR_EAR__c = 'NO';
         cseHigh.Government_Compliance_SM_M_Content__c = 'NO';
         cseHigh.priority = 'High';
        cseHigh.DateSetForOpen__c = system.Today().adddays(-2);
        cas1.add(cseHigh);
         insert cas1; 
        sendGDCRemindersBatch gdcNew = new sendGDCRemindersBatch ();
        sendGDCRemindersBatch cb = New sendGDCRemindersBatch();
        Database.QueryLocator ql = cb.start(null);
        cb.execute(null,cas1);
        cb.Finish(null);
         test.stopTest();
         
    }
   
}