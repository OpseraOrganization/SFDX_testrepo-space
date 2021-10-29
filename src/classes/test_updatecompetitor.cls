@isTest(SeeAllData=true)
private class test_updatecompetitor{
   static testMethod void updatecompetitor(){
        
       Set<String> stringList =new Set<String>();
        List<String> stringList6 =new List<String>();
        List<String> stringList7 =new List<String>();
        List<String> stringList8 =new List<String>();
        List<String> stringList9 =new List<String>();
        set<id> oppid=new set<id>();
        Set<id> csid=new Set<id>(); 
        List<Opportunity> oppListUpdate= new List<Opportunity>();
        List<Id> oppList= new List<Id>();
        List<Opportunity_Sales_Team__c> oppTeamList= new List<Opportunity_Sales_Team__c>();
        String teamName;
        String tmName;
        String body;
        
        Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'D&S';
        acc.CBT__c = 'DAA';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';
        
        insert acc;
        
        date testdate = date.parse('03/27/2011');
        
        Platform__c p = new Platform__c();
        p.Name = 'Test Paltform';
        p.Model__c = '36-16A';
        p.Make__c = 'VARIOUS OEMS';
        p.SAP_External_System__c = true;
        p.Parent_Platform__c = null;
        insert p;
        
        Product_Line__c prodline=new Product_Line__c();
        prodline.name='test prodline';
        insert prodline;
        
        product2 prod=new product2();
        prod.name='test product';
        prod.Product_Line__c=prodline.id;
        insert prod;
        stringList9.add(prod.Name);
        stringList6.add(prod.Product_Line__c);
        
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Method Opportunity';
        //opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'Focus'].Id;
        //opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'Catalog' limit 1].Id;
        opp.RecordTypeId = label.D_S_PrePriced;
        opp.SBU__c = 'D&S';
        opp.CBT_Tier_2__c = 'DAA';
        opp.CBT_Team_Tier_3__c = 'CBMS';
        opp.AccountId = acc.Id;
        opp.End_User__c = acc.Id;
        opp.Tech_Sales_Product_Area__c = 'APU';
        opp.Tech_Sales__c = 'Mechanical Systems';
        opp.Prime_Sub__c = 'Prime';
        opp.Opportunity_Type__c = 'D&S PrePriced';
        opp.StageName = 'Offer/Negotiate/Close';
        opp.CloseDate = testdate;
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'LTA';
        opp.International_Code__c = 'FMS';
        opp.Incumbent__c = 'Incumbent';
        opp.RMU__c = 'YES';
        opp.Platform__c = p.Id;
        opp.ATR_Aircraft_Quantity__c=1;
        //opp.Is_Restricted_Opportunity__c = TRUE;
        opp.Active__c = FALSE;       
        insert opp;
        
        
        
         Profile ProfRec = [select name from Profile where name = 'System Administrator'];
        User userRec = new User(LastName = 'venkat',Username = 'venkat@test.com.seven',Email = 'venkat@test55.com',Alias = 'venkat7' ,CommunityNickname= 'venkat7' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec.Id, LanguageLocaleKey = 'en_US');
        insert userRec;
              
        OpportunityCompetitor oppco=new OpportunityCompetitor();
        oppco.OpportunityId=opp.id;
        oppco.CompetitorName='test';
        insert oppco;
        
        CustomerStory__c cs=new CustomerStory__c();
        cs.Related_Opportunity__c=opp.id;
        cs.Name='test';
        cs.Competitors__c='test';
        cs.Story_Type__c='Win';
        cs.Status__c='Backlog';
        cs.Sales_Reference__c='Yes';
        cs.Sharing_Restriction__c='Educational Use Only - Do Not Mention Customer Name';
        cs.Region1__c='APAC';
        cs.SBU__c='BGA';
        cs.Story_Owner__c=userRec.id;
        insert cs;
        
        Related_Customer_Stories__c p1=new Related_Customer_Stories__c();
        p1.name='releted customer';
        p1.Summary__c='new test customer story';
        p1.Files_Links_1__c='google.com';
        p1.Files_Links_2__c='yahoo.com';
        p1.Solutions__c='new tset';
        p1.CustomerStory__c=cs.id;
        p1.Opportunity__c=opp.Id;
        //p1.Product__c='';
        p1.Product_Line__c='new product line';
        p1.Make__c='test';
        p1.CustomerName__c=acc.Id;
        p1.Reason__c='Product';
        insert p1;
        
        
 }      
}