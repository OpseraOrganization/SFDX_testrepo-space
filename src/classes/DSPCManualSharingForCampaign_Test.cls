@istest(seeAllData = false)
public class DSPCManualSharingForCampaign_Test {
    static testMethod void myUnitTest() {
    test.starttest();
        Account ac = new Account();
        ac.Name = 'Test Account one';
        ac.Customer_Status__c = 'Active';
        ac.Region_Name__c = 'Americas';
        ac.Sub_Region_Name__c = 'United States';
        ac.Service_Level__c = 'Standard';
        ac.Strategic_Business_Unit__c = 'D&S';
        ac.CBT__c = 'DSPC';
        ac.CBT_Team__c = 'Orion';
        ac.Market_Name__c = 'Space';
        ac.Type = 'OEM';
        ac.REPORT_ACCOUNT_NAME__c = 'Test Account';
        ac.DSPC_Account__c = true;
        insert ac;
        
        Contact con = new Contact();
        con.Lastname = 'Test Portal one';
        con.Accountid = ac.id;
        con.SBU_Contact__c = 'D&S';
        con.CBT__c = 'DSPC';
        con.CBT_Team__c = 'ORION';
        con.Email = 'test@test.com';
        insert con;
        
        //Profile p = [ select Id from Profile where Name=:'D&S_Partner_Portal_User'];
        
       /* User u = new User(ContactId = con.Id,
        Username = 'test@test.com.dspcone',
        Email = 'test@test.com',
        LastName = 'lastNameone',
        Alias = 'alias',
        ProfileID = label.D_S_Partner_ProfileId,
        PortalRole = 'Manager',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey='UTF-8'
        );
        insert u;*/
        user u=[select id,name from user where id=:label.test_user1]; 
        Campaign cmp = new Campaign();
        cmp.Name = 'Test Campaign1';
        cmp.CampaignPrimarySBU__c = 'D&S';
        cmp.CampaignPrimaryCBTTier2__c = 'DSPC';
        cmp.CBT_Team__c = 'ORION';
        cmp.Type = 'Catalog';
        cmp.D_S_Campaign__c = true;
        cmp.IsActive = true;
        insert cmp;
        
        Campaign_Team__c ct = new Campaign_Team__c();
        ct.Campaign__c = cmp.id;
        ct.Team_User__c = u.id;
        insert ct;
       
        Campaign_Gate__c cg = new Campaign_Gate__c();
        cg.Name = 'Test Tollgate';
        cg.Campaign__c = cmp.id;
        cg.Expected_Date__c = date.today();
        insert cg;
        cg.name = 'Test Tollgate1';
        update cg;
    test.stoptest();
    }
}