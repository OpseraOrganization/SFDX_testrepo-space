@isTest(SeeAllData=true)
private class test_CSForce_SearchController
{
    public String tSearch {get; set;}   
    public CustomerStory__c csSearch   {get; set;}
    static testMethod void test_CSForce_SearchController()
    {                   
        /*Account acc = new Account();
        acc.Name = 'Honeywell Test';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'D&S';
        acc.CBT__c = 'DAA';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';        
        insert acc; */
        Account acc=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%honeywell%' limit 1]; 
        
        contact cnt = new contact();       
        cnt.AccountId= acc.id;
        cnt.firstname='venkat';
        cnt.SBU_Contact__c='BGA';
        cnt.CBT__c='HBC';
        cnt.CBT_Team__c='EMEAI';
        cnt.LastName='test';
        cnt.Primary_Email_Address__c='sindhuja.velmurugan@testsample.com';  
        cnt.Phone_3__c='555555';
        cnt.Phone_1__c='666666';
        insert cnt;
        
         Fleet_Asset_Detail__c fd=new Fleet_Asset_Detail__c();
        fd.name='Embraer 145 T=2582 S=495';
        
        Platform__c p = new Platform__c();
        p.Name = 'Test Paltform';
        p.Model__c = '36-16A';
        p.Make__c = 'VARIOUS OEMS';
        p.SAP_External_System__c = true;
        p.Parent_Platform__c = null;
        insert p;
        /*Opportunity opp = new Opportunity();
        opp.Name = 'Test Method Opportunity';        
        opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'AM Catalog' limit 1].Id;
        opp.SBU__c = 'D&S';
        opp.Aircraft_Ref__c=fd.id;
        opp.CBT_Tier_2__c = 'DAA';
        opp.CBT_Team_Tier_3__c = 'CBMS';
        opp.AccountId = acc.Id;
        opp.End_User__c = acc.Id;
        opp.Tech_Sales_Product_Area__c = 'APU';
        opp.Tech_Sales__c = 'Mechanical Systems';
        opp.Prime_Sub__c = 'Prime';
        opp.Opportunity_Type__c = 'D&S PrePriced';
        opp.StageName = 'Offer/Negotiate/Close';
        opp.CloseDate = Date.today();
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'LTA';
        opp.International_Code__c = 'FMS';
        opp.Incumbent__c = 'Incumbent';
        opp.RMU__c = 'YES';
        opp.Is_Reference_Materials_used__c = TRUE;
        opp.Active__c = FALSE;       
        insert opp;*/
        date testdate = date.parse('03/27/2011');
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Method Opportunity';
        //opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'Focus'].Id;
        //opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'AM Catalog' limit 1].Id;
        opp.RecordTypeId = label.AM_Catalog;
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
        //opp.Is_Restricted_Opportunity__c = TRUE;
        opp.Active__c = TRUE;
        opp.Proposal_Submitted_Date__c = System.today();
        opp.RFP_Expected_Date__c = System.today();
        opp.Proposal_Complexity_Description__c = 'test';
        opp.Ship_Set_Parts__c = 'test';
        opp.Ship_Set_Quantity__c = 11;
        opp.Certification_Requirements__c = 'FAR 15 TINA';
        opp.Ship_Set_Delivery_Period__c = 'test';
        opp.Proposal_Due_Date__c = System.today();
        opp.Proposal_Kickoff_Date__c = System.today();
        opp.Type_of_Opportunity__c = 'RMU – Level 3 (Low Probability)';
        opp.Amount=1;
        opp.Program_Terms__c='1';
        opp.ATR_Aircraft_Quantity__c=1;
        insert opp;
                     
        Profile ProfRec = [select name from Profile where name = 'System Administrator'];
        User userRec = new User(LastName = 'venkat',Username = 'venkat@test.com.two',Email = 'venkat@test55.com',Alias = 'venkat2' ,CommunityNickname= 'venkat2' ,TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = ProfRec.Id, LanguageLocaleKey = 'en_US');
        insert userRec;
        
        CustomerStory__c cs=new CustomerStory__c();
        cs.Related_Opportunity__c=opp.id;
        cs.Name='test';
        cs.Story_Type__c='Win';
        cs.Files_Links_1__c='google.com';
        cs.Files_Links_2__c='www.nttdata.com';
        cs.Video_Link_mac__c='yahoo.com';
        cs.Status__c='Backlog';
        cs.Sales_Reference__c='Yes';
        cs.Sharing_Restriction__c='Educational Use Only - Do Not Mention Customer Name';
        cs.Region1__c='APAC';
        cs.SBU__c='BGA';
        cs.Story_Owner__c=userRec.id;
        insert cs;
      
            
    String strCondition = '';   
    CSForce_testingutil tu = new CSForce_testingutil();
    tu.addData();
    CSForce_SearchController sc = new CSForce_SearchController();
    sc.productSelected = 'All';
    sc.competitorSelected = 'All';
    sc.doSearch();
    //System.assert(sc.csHelperList.size()>0);
    sc.tSearch = 'blah';
    sc.doSearch();  
   // System.assert(sc.csHelperList!=null);
    
    //sc.soqlSearch();
    String storyType='test';
    String title='test1';
    String salesRef='test3';
    String sharingRes='test4';
    String product='test5';
    String competitor='test6';
    String makeVar='test7';
    String modelVar='test8';
    String custVar='test9';   
        
    sc.productSelected = 'test';
    sc.competitorSelected = 'test';
    sc.csSearch.Related_Opportunity__c=opp.id;
    //sc.csSearch.Make__c='test';
    //sc.csSearch.Model__c='148';
    //sc.csSearch.Customer__c='venkatesh';
    sc.csSearch.Win_Again__c = 'Ralph Wiggum';
    sc.csSearch.Story_Type__c = 'test';
    sc.csSearch.Name = 'test';
    sc.csSearch.Sales_Reference__c = 'blah';
    sc.csSearch.Sharing_Restriction__c = 'blah';    
    sc.tSearch = 'blah';
    sc.doSearch();
    sc.tSearch = '';
    sc.doSearch();

 
    
   }
}