@isTest
private class TestBatchOpportunityTeamMemberSharing{
    static testMethod void TestMethod1(){  
      List<Opportunity> oppList= new List<Opportunity>();
        
        List<user> listuser = new List<user>(); 
        Profile profileObj = [Select Id from Profile where name = 'System Administrator'];         
        UserRole ur=new UserRole(id=Userinfo.getUserRoleId(),Name='red test name');        
        User userObj = new User(ProfileId = profileObj.Id, Username = 'testuseraccount1@test.com',
                           Alias = 'Atanm1', Email = 'test1111@gf.com', EmailEncodingKey = 'UTF-8', Firstname = 'ATest',
                           Lastname = 'AUser1', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', TimeZoneSidKey = 'America/Chicago'
                          ); //user object created
        listuser.add(userObj);
        
        opportunity opp = new opportunity();
        opp.Name = 'Test method opportunity';
        opp.RecordTypeId = label.D_S_PrePriced;
        opp.SBU__c = 'D&S';
        opp.CBT_Tier_2__c = 'DAA';
        opp.CBT_Team_Tier_3__c = 'CBMS';
        opp.Tech_Sales_Product_Area__c = 'APU';
        opp.Tech_Sales__c = 'Mechanical Systems';
        opp.Prime_Sub__c = 'Prime';
        opp.Opportunity_Type__c = 'D&S PrePriced';
        opp.StageName = 'Offer/Negotiate/Close';
        opp.CloseDate = date.parse('09/13/2017');
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'LTA';
        opp.International_Code__c = 'FMS';
        opp.Incumbent__c = 'Incumbent';
        opp.RMU__c = 'YES';        
        opp.ATR_Aircraft_Quantity__c = 1;
        opp.Active__c = FALSE;        
        oppList.add(opp);
        insert oppList;
        
        
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'BGA';
        acc.CBT__c = 'BGA Aftermarket';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Unauthorized Dist/Brkr';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Business Aviation';
        insert acc;
        
        contact ca =new contact();
        ca.LastName = 'testlastname';
        ca.FirstName = 'testfirstname12';
        ca.AccountId = acc.id;
        insert ca;
        
        Opportunity_Sales_Team__c ost = new Opportunity_Sales_Team__c();
        ost.Opportunity__c = opp.Id;
        ost.User__c = userObj.id;
        ost.Contact__c = ca.id;
        insert ost;
        
        Test.startTest();
        OppTeamMemberBatchSchedule oppTeamBC = new OppTeamMemberBatchSchedule();
        String sch = '0 0 21 * * ?';
        system.schedule('Test Check', sch, oppTeamBC);
        Test.stopTest();
    }
}