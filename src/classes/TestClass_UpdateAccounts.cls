@isTest(SeeALLData=True)
public class TestClass_UpdateAccounts{
    static testMethod void testBatch(){
        /* Profile p = [select id from profile where name='System Administrator' limit 1];
        User usr = new User();
        usr.alias = 'hari';
        usr.email = 'hari23@test.com';
        usr.emailencodingkey='UTF-8';
        usr.lastname='vnv';
        usr.languagelocalekey='en_US';
        usr.localesidkey='en_US';
        usr.profileid = p.Id;
        usr.timezonesidkey='America/Los_Angeles';
        usr.username='standarduser@testing.com';
        insert usr; */
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1]; 
        system.runAs(usr){
        List<Account> acclist = new List<Account>();
        List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
        Account a = new Account();
        AccountTeamMember c = new AccountTeamMember();
        Account acc = new Account();
        acc.Name = 'Testweb';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'Honeywell';
        acc.RAI_Excluded__c = TRUE;
        acc.REPORT_ACCOUNT_NAME__c = 'Honeywell';
        acclist.add(acc);
        insert acclist;
        for (Integer i = 0; i<3; i++){
            //a = new Account(name = 'test' + 'i', OwnerId = usr.id ,Team_Member__c = usr.id);
            c = new AccountTeamMember(TeamMemberRole = 'Customer Service Manager'+'i', AccountId = acclist[0].id,UserId = usr.id);
            //acclist.add(a);
            atmlist.add(c);
        }
        //insert acclist;
        Test.StartTest();
        insert atmlist;
        
        updateAccounts count = new updateAccounts();
        count.start( (Database.BatchableContext) null );
        count.execute( (Database.BatchableContext) null, new List<AccountTeamMember>{c} );
        count.finish( (Database.BatchableContext) null );
        //Database.executeBatch(count,500);
        }
        }
     static testMethod void testsendCaseEmailMethodInsert6Two(){
     User runUser = [Select id From User where profile.name = 'System Administrator' and isactive = true  Limit 1];
     System.runAs(runUser){
     Account a = new Account();
            a.OwnerId = UserInfo.getUserId();
            a.Name = 'Test Account Star';
            a.type = 'Energy';
            a.Strategic_Business_Unit__c = 'BGA';
            a.Service_Level__c = 'Unauthorized Dist/Brkr';
            a.Do_Not_Send_to_Portal__c = false;
            a.PFECN__c = null;
            a.Region_Name__c ='Asia/Pacific Rim';
            a.Customer_Status__c='Temporary';
         insert a;
         
         a.Customer_Status__c='Active';
         update a;
         
      Account a1 = new Account();
            a1.OwnerId = UserInfo.getUserId();
            a1.Name = 'Test Account Star1';
            a1.type = 'Energy';
            a1.Strategic_Business_Unit__c = 'Intercompany';
            a1.Service_Level__c = 'Unauthorized Dist/Brkr';
            a1.Do_Not_Send_to_Portal__c = false;
            a1.PFECN__c = null;
            a1.Region_Name__c ='Asia/Pacific Rim';
         
         insert a1;
         
            a.Strategic_Business_Unit__c = 'Intercompany';
         update a;
         
     Account_Address__c AA = new Account_Address__c();
        AA.Account_Name__c = a.id;
        AA.Address_Type__c= 'Account';
        AA.CurrencyIsoCode = 'USD';
        AA.Report_Address_Line_1__c = '7950 Legacy Dr Suite 900';
        AA.Report_City_Name__c = 'Plano, Texas';
        AA.Report_Country_Codes__c= 'US';
        AA.Denied_Party_Status__c = 'Whitelist';
           Test.startTest(); 
     insert AA;  
     update a;
         
        Account_Address__c AA1 = new Account_Address__c();
        AA1.Account_Name__c = a.id;
        AA1.Address_Type__c= 'Account';
        AA1.CurrencyIsoCode = 'USD';
        AA1.Report_Address_Line_1__c = 'Legacy Dr Suite';
        AA1.Report_City_Name__c = 'Plano';
        AA1.Report_Country_Codes__c= 'US';
        AA1.Denied_Party_Status__c = 'Not Reviewed';
     insert AA1;
     update a;
         VOC_Accounts__c va = new VOC_Accounts__c();
         va.name= 'Voc Account Star';
         va.CurrencyIsoCode = 'USD';
         va.Account__c =a.id;
         insert va;
         
         a.Name='Test Account Starluck';
         VOC_Accounts__c va1 = new VOC_Accounts__c();
         va1.name= a.Name;
         va1.CurrencyIsoCode = 'USD';
         va1.Account__c =a.id;
         insert va1;
         update a;
         
        contact objContact= (contact)SObjectFactory.create(
            contact.sObjectType, new Map<Schema.SObjectField, Object>
            {
                contact.OwnerId => UserInfo.getUserId(),
                    contact.LastName => 'Test;CreateBulkEmailsNavDB_4',
                    contact.AccountId => a.Id,
                    contact.fax_web__C => '4343434343',
                    contact.Email=>'test_radha@in.ibm.com'
            }); 
         Test.StopTest();
         }
     }    
}