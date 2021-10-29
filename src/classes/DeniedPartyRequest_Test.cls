@isTest
private class DeniedPartyRequest_Test{
    static testMethod void DeniedPartyRequest_TestMethod()
    {
        Profile pf = [select name from Profile where name = 'DeniedPartyScreeningAPIUser'];
        
        User testUser1 = new User(LastName = 'Trigger Test User1',Username = 'triggertstuser1@test.com.honeywell',Email = 'testuser1@test.com',Alias = 
            'tuser1' ,CommunityNickname= 'tuserhoney1' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
            'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 
            'en_US',Functional_Role__c='testrole1',SBU_User__c='testsbu1',CBT__c='HTSI1',CBT_Team__c ='testcbtteam1',
            Phone='1234567890',Extension='2345',Fax='1234567890',MobilePhone='1234567880'
            );
        insert testUser1;   
        User testUser = new User(LastName = 'Trigger Test User',Username = 'triggertstuser@test.com.honeywell',Email = 'testuser@test.com',Alias = 
            'tuser' ,CommunityNickname= 'tuserhoney' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 
            'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 
            'en_US',Functional_Role__c='testrole',SBU_User__c='testsbu',CBT__c='HTSI',CBT_Team__c ='testcbtteam',
            Phone='123456789',Extension='234',Fax='123456789',MobilePhone='123456788',ManagerId=testUser1.id
            );
        insert testUser;
        system.runAs(testUser)
        {
            Account ac=new Account();
            ac.name='testclass deniedpart test';
            ac.Customer_Status__c='Active';
            ac.Region_Name__c='Americas';
            ac.Service_Level__c='Standard';
            ac.Strategic_Business_Unit__c='ATR';
            //BGA stats
            ac.ownerid=testUser.id;
            //BGA Ends
            ac.Type='Parent';
            ac.REPORT_ACCOUNT_NAME__c='test';
            insert ac;
            
            Account ac1=new Account();
            ac1.name='testclass deniedpart test';
            ac1.Customer_Status__c='Active';
            ac1.Region_Name__c='Americas';
            ac1.Service_Level__c='Standard';
            ac1.Strategic_Business_Unit__c='ATR';
            ac1.Type='Parent';
            ac1.REPORT_ACCOUNT_NAME__c='test';
            insert ac1;
           
            Account_Address__C acad=new Account_Address__C();
            acad.Account_Name__c=ac.id;
            acad.Address_Type__c='Account';
            acad.Report_Address_Line_1__c='test';
            acad.Report_Country_Name__c='India';
            acad.Report_City_Name__c='testcity';
            acad.Denied_Party_Status__c='Blocked';
            acad.Mobile_App_Visibility_Uncheck__c = false;
            insert acad;
            
            Account_Address__C acad1=new Account_Address__C();
            acad1.Account_Name__c=ac1.id;
            acad1.Address_Type__c='Account';
            acad1.Report_Address_Line_1__c='test';
            acad1.Report_Country_Name__c='India';
            acad1.Report_City_Name__c='testcity';
            acad1.Denied_Party_Status__c='Blocked';
            acad1.Mobile_App_Visibility_Uncheck__c = true;
            insert acad1;
            
            List<Account_Address__C> listAccAdd = new List<Account_Address__C>();
            DeniedPartyRequest.sendRequest(listAccAdd);
                                        
            acad.Denied_Party_Status__c='Released';
            update acad;
            acad.Denied_Party_Status__c='Conditional Release';
            update acad;
            acad.Denied_Party_Status__c='Pending Block';
            update acad;
            acad.Denied_Party_Status__c='Further Review Needed';
            update acad;
            acad.Denied_Party_Status__c='Blocked';
            update acad;
            acad.BGAMob_Contact_Name__c='venkatesh';
            update acad;

            acad1.BGAMob_Contact_Name__c='venkatesh1';
            update acad1;  
           
            //testUser.ManagerId=null;
            //update testUser;            
          
        }
    }
}