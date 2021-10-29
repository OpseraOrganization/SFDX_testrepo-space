@isTest(SeeAllData=true)
private class TestClass_ApexTrgr_Opp_insert_DrAppList {
    static testMethod void Opportunity_insertTest() {
        /*String prfId = [Select id from Profile where name=:'System Administrator'].id;
        User userRec = new User(
            LastName = 'Test User',
            Username = 'testuser@test3.com.honeywell',
            Email = 'testuser@test.com',
            Alias = 't3user',
            CommunityNickname = 't3user',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey ='en_US',
            EmailEncodingKey = 'ISO-8859-1',
            ProfileId = prfId,
            LanguageLocaleKey = 'en_US',
            Functional_Role__c = 'testrole'
        );
        insert userRec;
        User userRec1 = new User(
            LastName = 'Test User1',
            Username = 'testuser1@test3honeywell.com',
            Email = 'testuser1@testhoneywell.com',
            Alias = 't3user11',
            CommunityNickname = 't3user11',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey ='en_US',
            EmailEncodingKey = 'ISO-8859-1',
            ProfileId = prfId,
            LanguageLocaleKey = 'en_US',
            Functional_Role__c = 'testroles'
        );
        insert userRec1;
        
        Account acc = new Account();
        acc.Name='Tesst Account';
        acc.Customer_Status__c='Active';
        acc.Region_Name__c='Americas';
        acc.Sub_Region_Name__c='Africa';
        acc.Service_Level__c='Comprehensive';
        acc.Strategic_Business_Unit__c='ATR';
        acc.CBT__c='Airbus';
        acc.CBT_Team__c='Airbus';
        acc.Market_Name__c='Air Transport';
        acc.Business_Owner__c='Ryan, Justin';
        acc.Type='Air Cargo Transporter';
        acc.REPORT_ACCOUNT_NAME__c='Test Report';
        insert acc;
        */
        Account acc = [select id from account where Strategic_Business_Unit__c='ATR' and CBT__c='Airbus' limit 1];
        User userRec =[select id from user where profile.name = 'System Administrator' and isactive = true order by createddate desc limit 1];
        User userRec1 =[select id from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Contact c= new Contact();
        c.AccountId = acc.id;
        c.LastName='Harivnv';
        c.SBU_Contact__c='ACS Labs';
        c.CBT__c='ACS Sensors Lab';
        c.CBT_Team__c='ACS Advanced Sensors';
        c.Primary_Email_Address__c='testing@honeywell.com';
        c.Phone_1__c= '123456789';
        insert c; 
                
        Platform__c pf = new Platform__c();
        pf.Name = 'Test';
        pf.Model__c = 'hari';
        pf.Make__c = 'vnv';
        insert pf;
        
        DR_Approvers_List__c DRAL = new DR_Approvers_List__c(
            SBU__c = 'D&S',
            CBT__c = 'Advanced Technology',
            Approver__c = userRec.Id
        );
        insert DRAL;
        /*
        Opportunity tstOpp = new Opportunity();
        tstOpp.Name='Test Opp';
        tstOpp.Account = acc;
        tstOpp.End_User__c = acc.id;
        tstOpp.amount =100.00;
        tstOpp.Type = 'OCM Programs';
        tstOpp.closedate = System.today();
        tstOpp.ForecastCategoryName = 'Pipeline';
        tstOpp.SBU__c = 'D&S';
        tstOpp.CBT_Tier_2__c = 'DAA';
        tstOpp.CBT_Team_Tier_3__c = 'ATEC';
        tstOpp.StageName = 'Prospecting';
        tstOpp.Prime_Sub__c = 'Prime';
        tstOpp.Revenue_Type__c = 'Licence';
        tstOpp.Bid_Type_Name__c = 'Sole Source';
        tstOpp.International_Code__c = 'FMS';
        tstOpp.Platform__c = pf.id;
        tstOpp.Incumbent__c = 'Incumbent';
        tstOpp.RMU__c = 'Yes';
        tstOpp.Owner = userRec;
        tstOpp.Tech_Sales_Product_Area__c = 'AT';
        tstOpp.RecordtypeId = [select id , name from RecordType where name like '%D&S PrePriced' limit 1].id;
        insert tstOpp;
        */
        Opportunity tstOpp = [select id from Opportunity where SBU__c = 'D&S' and RecordType.name like '%D&S PrePriced' limit 1];
        DRAL.Approver__c = userRec1.Id;
        Update DRAL;
        
        Opportunity_Sales_Team__c oppteam1 = new Opportunity_Sales_Team__c();
        oppteam1.User__c = userRec.id;
        oppteam1.Opportunity_team_role__c = 'Growth Leader';
        oppteam1.Created_due_to_CBT__c=true;
        oppteam1.Opportunity__c = tstOpp.id;
        insert oppteam1;
        system.assertEquals(oppteam1.Opportunity_team_role__c, 'Growth Leader');
    }
}