@isTest(SeeAllData=true)
private class TestClass_addreferencematerial
{
        
     static testMethod void TestClass_addreferencematerial()
    { 
       List<Opportunity> oppListUpdate= new List<Opportunity>();
        List<Id> oppList= new List<Id>();
        List<Opportunity_Sales_Team__c> oppTeamList= new List<Opportunity_Sales_Team__c>();
        String teamName;
        String tmName;
        
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
        p.SAP_External_System__c=True;
        insert p;
        
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
        
       Related_Customer_Stories__c rt=new Related_Customer_Stories__c();
       rt.Files_Links_2__c='google.com';
       rt.Files_Links_1__c='yahoo.com';
       rt.Product_Line__c='new product';
       rt.Opportunity__c=opp.id;
       insert rt;
       
        
              
    }
}