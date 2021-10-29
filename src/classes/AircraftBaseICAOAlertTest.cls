@isTest
public class AircraftBaseICAOAlertTest{
    public static testmethod void testmethod3(){
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

    Platform__c pf= new Platform__c();
        pf.Name='Test';
        pf.Platform_Type__c='Various';
        pf.Make__c= 'Cessna';
        pf.Model__c='Citation V';
        pf.Managing_SBU__c='ATR';
        pf.OEM_Name__c = acc.Id;
        insert pf;
        
        Aircraft_Base__c afb = new Aircraft_Base__c();
        afb.name = 'Testing';
        afb.Base_ICAO__c = 'KLGA';
        insert afb;
        
        Fleet_Asset_Detail__c fleet= new Fleet_Asset_Detail__c();
        fleet.Name= 'Test Fleet';
        fleet.Platform_Name__c=pf.id;
        fleet.Aircraft_Base__c=afb.Id;
        insert fleet;
    
    Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.CBT_Team_Tier_3__c = 'APAC BGA';
        opp.AccountId= acc.id;
        opp.StageName= 'Cultivate' ;   
        opp.Type= 'BGA Aftermarket';
        //opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.recordtypeid='01230000000bN7l';
       // opp.dealer_account__c='0013000000bFxtr';
        opp.ATR_Probability__c = 90;        
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.Revenue_Type__c = 'ENG';
        opp.Solution_Type__c = 'Direct Sales';
        opp.SBU__c = 'BGA';
        //opp.Aircraft_Base_ICAO__c = 'KLGA';
        opp.Package_Product__c = 'Test PP';
        opp.StageName='Testing';
        insert opp;
        Test.StartTest();
        ApexPages.CurrentPage().getParameters().put('id', opp.Id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
        AircraftBaseICAOAlert testopp = new AircraftBaseICAOAlert(sc);
        
        Test.StopTest();
    }
}