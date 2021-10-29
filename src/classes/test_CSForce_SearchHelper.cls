@isTest(SeeAllData=true)
private class test_CSForce_SearchHelper
{
  static testMethod void test_CSForce_SearchHelper()
  { 
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
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Method Opportunity';        
        opp.RecordTypeId = label.D_S_PrePriced;
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
        opp.ATR_Aircraft_Quantity__c=1;   
        insert opp;
                     
        User userRec =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Product2 prd1 = new Product2 (Name='Test Product Entry 1',Description='Test Product Entry 1',productCode = 'ABC', isActive = true);
        insert prd1;
        
        Test.StartTest();
        CustomerStory__c cs=new CustomerStory__c();
        cs.Related_Opportunity__c=opp.id;
        cs.Name='test';
        cs.Story_Type__c='Win';
        cs.Files_Links_1__c='google.com';
        cs.Files_Links_2__c='www.nttdata.com';
        cs.Video_Link_mac__c='yahoo.com';
        cs.Status__c='Backlog';
        cs.Product__c=prd1.id;
        cs.Sales_Reference__c='Yes';
        cs.Sharing_Restriction__c='Approved for External Use - OK to Mention Customer Name';
        cs.Region1__c='APAC';
        cs.Win_Again__c='test win Educational Use; Only Mention Educational; Use Only Do Not Mention Customer Only Do Not Mention Customer Use  Use Use Educational';
        cs.SBU__c='BGA';
        cs.Story_Owner__c=userRec.id;
        cs.Synopsis__c='Educational Use Only Do Not Mention Customer Use  Use Use Educational Use Only Customer Use';
        insert cs;
        CSForce_SearchHelper sc1 = new CSForce_SearchHelper(cs);
        CustomerStory__c cs1=[select name,Story_Type__c,Synopsis__c,Story_Owner__c,SBU__c,Product_Name__c,Region1__c,Files_Links_1__c,Win_Again__c,Files_Links_2__c,Video_Link_mac__c,Product__c,Status__c,Sales_Reference__c,Sharing_Restriction__c,callRef__c,sharingR__c from CustomerStory__c where Sales_Reference__c='Yes' and callRef__c!=null and sharingR__c!=null limit 1];
        CSForce_SearchHelper sc2 = new CSForce_SearchHelper(cs1);
        sc2.salesRef = 'https://c.cs14.visual.force.com/resource/1366235397000/CSForce_Call';
        sc2.sharingRes = 'https://c.cs14.visual.force.com/resource/1366235397000/CSForce_ExtUse';
        Test.stopTest();           
    }  
}