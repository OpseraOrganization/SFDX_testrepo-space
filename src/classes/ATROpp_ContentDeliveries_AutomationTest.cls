/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seealldata=true)
private class ATROpp_ContentDeliveries_AutomationTest {

     ATROpp_ContentDeliveries_Automation ATRopp =  new ATROpp_ContentDeliveries_Automation();
    static testMethod void myUnitTest2() {
       /* list<ContentVersion> cvlist= new list<ContentVersion>();
        list<ContentWorkspaceDoc> cwdlist= new list<ContentWorkspaceDoc>();
        set<id>cvid= new set<id>();
        ContentVersion doc = new ContentVersion();
        string before = 'Testing base 64 encode'; 
        Blob beforeblob = Blob.valueOf(before);
        doc.Title ='title';
        doc.PathOnClient = 'xyz';
        doc.VersionData = beforeblob;
        doc.FirstPublishLocationId=userinfo.getUserId();
        doc.SBU__c='ATR';
        doc.TagCsv='Test Method Opportunity';
        cvlist.add(doc);
        ContentVersion doc1 = new ContentVersion();
        string before1 = 'Testing base 64 encode'; 
        Blob beforeblob1 = Blob.valueOf(before1);
        doc1.Title ='title1';
        doc1.SBU__c='ATR';
        doc1.PathOnClient = 'xyz';
        doc1.FirstPublishLocationId=userinfo.getUserId();
        doc1.VersionData = beforeblob1;
        doc1.TagCsv='Test Campaign';
        cvlist.add(doc1);
        insert cvlist;
        for(ContentVersion cv:cvlist)
          cvid.add(cv.id);
        cvlist = [select ContentDocumentId from ContentVersion where id IN: cvid];
        ContentWorkspace shareWorkspace = [select id from ContentWorkspace limit 1];

        for(ContentVersion cv:cvlist){
        ContentWorkspaceDoc docLink = new ContentWorkspaceDoc();
        docLink.ContentDocumentId = doc.ContentDocumentId;
        docLink.ContentWorkspaceId = shareWorkspace.id;
        cwdlist.add(docLink);
        }
        insert cwdlist;*/
        
        
        Campaign cam = new Campaign();
        cam.Name='Airlines BFE-SSFE Pursuits';
        cam.CampaignPrimarySBU__c='ATR';
        cam.CampaignPrimaryCBTTier2__c = 'Airbus';
        cam.CBT_Team__c = 'Airbus Companies';
        cam.Status = 'Planned';
        cam.Type = 'Competative';
        cam.RMU__c = 'No';
        cam.ExpectedRevenue = 33000000;
        cam.Tech_Sales__c = 'Integrated Systems';
        cam.Tech_Sales_Product_Area__c = 'CBM';
        cam.IsActive = true;
         insert cam;
         
         
        Campaign cam1 = new Campaign();
        cam1.Name='xxxxxx';
        cam1.campaignPrimarySBU__c='ATR';
        cam1.campaignPrimaryCBTTier2__c = 'Airbus';
        cam1.CBT_Team__c = 'Airbus Companies';
        cam1.Status = 'Planned';
        cam1.Type = 'Competative';
        cam1.RMU__c = 'No';
        cam1.ExpectedRevenue = 33000000;
        cam1.Tech_Sales__c = 'Integrated Systems';
        cam1.Tech_Sales_Product_Area__c = 'CBM';
        cam1.IsActive = true;
        insert cam1;
         

        
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
    
          Opportunity opp = new Opportunity();
            opp.Name = '10x 777 AIMS upgrade';
            opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'OE Complex' limit 1].Id;
            opp.SBU__c = 'ATR';
            opp.CampaignId=cam.id;
            opp.CBT_Tier_2__c = 'DAA';
            opp.CBT_Team_Tier_3__c = 'CBMS';
            opp.AccountId = acc.Id;
            opp.End_User__c = acc.Id;
            opp.Opportunity_Type__c = 'OE Complex';
            opp.StageName = 'Closed Cancelled';
            opp.CloseDate = System.Today();
            opp.Revenue_Type__c = 'ENG';
            opp.Content_Product_Name__c='A320';
            opp.Content_Platform_Name__c='Airbus';
            opp.Bid_Type_Name__c = 'LTA';
            opp.Solution_Type__c = 'BFE / SSFE';
            opp.Incumbent__c = 'Incumbent';
            opp.Opportunity_Product_Line_Quantity__c = 10;
            opp.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
            opp.Opportunity_Product_Line_Platform__c = 'Airbus';
            opp.ATR_Review_Org__c = 'Avionics LRU';
            opp.Lead_Number__c='Test Lead Number';
            opp.PWin__c ='1';
            opp.Pgo__c ='1';
            insert opp;
            
            
            Opportunity opp1 = new Opportunity();
            opp1.Name = 'ttttttttttttttt';
            opp1.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'OE Complex' limit 1].Id;
            opp1.SBU__c = 'ATR';
            opp1.CampaignId=cam1.id;
            opp1.CBT_Tier_2__c = 'DAA';
            opp1.CBT_Team_Tier_3__c = 'CBMS';
            opp1.AccountId = acc.Id;
            opp1.End_User__c = acc.Id;
            opp1.Opportunity_Type__c = 'OE Complex';
            opp1.StageName = 'Closed Cancelled';
            opp1.CloseDate = System.Today();
            opp1.Revenue_Type__c = 'ENG';
            opp1.Content_Product_Name__c='A320';
            opp1.Content_Platform_Name__c='Airbus';
            opp1.Bid_Type_Name__c = 'LTA';
            opp1.Solution_Type__c = 'BFE / SSFE';
            opp1.Incumbent__c = 'Incumbent';
            opp1.Opportunity_Product_Line_Quantity__c = 10;
            opp1.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
            opp1.Opportunity_Product_Line_Platform__c = 'Airbus';
            opp1.ATR_Review_Org__c = 'Avionics LRU';
            opp1.Lead_Number__c='Test Lead Number';
            opp1.PWin__c ='1';
            opp1.Pgo__c ='1';
            insert opp1;
    }  
     static testMethod void myUnitTest() {
        /*list<ContentVersion> cvlist= new list<ContentVersion>();
        list<ContentWorkspaceDoc> cwdlist= new list<ContentWorkspaceDoc>();
        set<id>cvid= new set<id>();
        ContentVersion doc = new ContentVersion();
        string before = 'Testing base 64 encode'; 
        Blob beforeblob = Blob.valueOf(before);
        doc.Title ='title';
        doc.PathOnClient = 'xyz';
        doc.VersionData = beforeblob;
        doc.FirstPublishLocationId=userinfo.getUserId();
        doc.SBU__c='ATR';
        doc.TagCsv='Airlines BFE-SSFE Pursuits';
        cvlist.add(doc);
        ContentVersion doc1 = new ContentVersion();
        string before1 = 'Airlines BFE-SSFE Pursuits'; 
        Blob beforeblob1 = Blob.valueOf(before1);
        doc1.Title ='title1';
        doc1.SBU__c='ATR';
        doc1.PathOnClient = 'xyz';
        doc1.FirstPublishLocationId=userinfo.getUserId();
        doc1.VersionData = beforeblob1;
        doc1.TagCsv='Test Campaign';
        cvlist.add(doc1);
        insert cvlist;
        for(ContentVersion cv:cvlist)
          cvid.add(cv.id);
        cvlist = [select ContentDocumentId from ContentVersion where id IN: cvid];
        ContentWorkspace shareWorkspace = [select id from ContentWorkspace limit 1];

        for(ContentVersion cv:cvlist){
        ContentWorkspaceDoc docLink = new ContentWorkspaceDoc();
        docLink.ContentDocumentId = doc.ContentDocumentId;
        docLink.ContentWorkspaceId = shareWorkspace.id;
        cwdlist.add(docLink);
        }
        insert cwdlist;*/
        
        list<ContentVersion> conversationRecList = [select TagCsv from ContentVersion where IsLatest=true limit 1000];
        String csvName = '';
        for(ContentVersion conversationRec:conversationRecList){
            if(conversationRec.TagCsv != null){
                csvName = (String)conversationRec.TagCsv;
                break;
            }
        }
        Campaign cam = new Campaign();
        cam.Name=csvName;
        cam.CampaignPrimarySBU__c='ATR';
        cam.CampaignPrimaryCBTTier2__c = 'Airbus';
        cam.CBT_Team__c = 'Airbus Companies';
        cam.Status = 'Planned';
        cam.Type = 'Competative';
        cam.RMU__c = 'No';
        cam.ExpectedRevenue = 33000000;
        cam.Tech_Sales__c = 'Integrated Systems';
        cam.Tech_Sales_Product_Area__c = 'CBM';
        cam.IsActive = true;
        insert cam;
         
         
        Campaign cam1 = new Campaign();
        cam1.Name='xxxxxx';
        cam1.campaignPrimarySBU__c='ATR';
        cam1.campaignPrimaryCBTTier2__c = 'Airbus';
        cam1.CBT_Team__c = 'Airbus Companies';
        cam1.Status = 'Planned';
        cam1.Type = 'Competative';
        cam1.RMU__c = 'No';
        cam1.ExpectedRevenue = 33000000;
        cam1.Tech_Sales__c = 'Integrated Systems';
        cam1.Tech_Sales_Product_Area__c = 'CBM';
        cam1.IsActive = true;
        insert cam1;
         

        
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
    
          Opportunity opp = new Opportunity();
            opp.Name = csvName+' '+csvName+' '+csvName;
            opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'OE Complex' limit 1].Id;
            opp.SBU__c = 'ATR';
            opp.CampaignId=cam.id;
            opp.CBT_Tier_2__c = 'DAA';
            opp.CBT_Team_Tier_3__c = 'CBMS';
            opp.AccountId = acc.Id;
            opp.End_User__c = acc.Id;
            opp.Opportunity_Type__c = 'OE Complex';
            opp.StageName = 'Closed Cancelled';
            opp.CloseDate = System.Today();
            opp.Revenue_Type__c = 'ENG';
            opp.Content_Product_Name__c='A320';
            opp.Content_Platform_Name__c=csvName;
            opp.Bid_Type_Name__c = 'LTA';
            opp.Solution_Type__c = 'BFE / SSFE';
            opp.Incumbent__c = 'Incumbent';
            opp.Opportunity_Product_Line_Quantity__c = 10;
            opp.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
            opp.Opportunity_Product_Line_Platform__c = csvName;
            opp.ATR_Review_Org__c = 'Avionics LRU';
            opp.Lead_Number__c='Test Lead Number';
            opp.PWin__c ='1';
            opp.Pgo__c ='1';
            insert opp;
            
            
            Opportunity opp1 = new Opportunity();
            opp1.Name = csvName+' '+csvName+' '+csvName;
            opp1.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'OE Complex' limit 1].Id;
            opp1.SBU__c = 'ATR';
            opp1.CampaignId=cam1.id;
            opp1.CBT_Tier_2__c = 'DAA';
            opp1.CBT_Team_Tier_3__c = 'CBMS';
            opp1.AccountId = acc.Id;
            opp1.End_User__c = acc.Id;
            opp1.Opportunity_Type__c = 'OE Complex';
            opp1.StageName = 'Closed Cancelled';
            opp1.CloseDate = System.Today();
            opp1.Revenue_Type__c = 'ENG';
            opp1.Content_Product_Name__c=csvName;
            opp1.Content_Platform_Name__c='Airbus'+', '+csvName+','+csvName;
            opp1.Bid_Type_Name__c = 'LTA';
            opp1.Solution_Type__c = 'BFE / SSFE';
            opp1.Incumbent__c = 'Incumbent';
            opp1.Opportunity_Product_Line_Quantity__c = 10;
            opp1.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
            opp1.Opportunity_Product_Line_Platform__c = csvName;
            opp1.ATR_Review_Org__c = 'Avionics LRU';
            opp1.Lead_Number__c='Test Lead Number';
            opp1.PWin__c ='1';
            opp1.Pgo__c ='1';
            insert opp1;
            
         Test.startTest();
            opp1.ATR_Probability__c = 20;
            opp1.Program_Go_Probability__c = 20;
            update opp1;
            
            Content_Delivery__c cdy = new Content_Delivery__c();
             cdy.Opportunity__c = opp1.Id;
             cdy.ID_Value__c = conversationRecList[0].Id;
             cdy.Content_Name__c = 'Test';
            insert cdy;
         Test.stopTest();
    } 
    
static testMethod void myUnitTest1() {
        /*list<ContentVersion> cvlist= new list<ContentVersion>();
        list<ContentWorkspaceDoc> cwdlist= new list<ContentWorkspaceDoc>();
        set<id>cvid= new set<id>();
        ContentVersion doc = new ContentVersion();
        string before = 'Testing base 64 encode'; 
        Blob beforeblob = Blob.valueOf(before);
        doc.Title ='title';
        doc.PathOnClient = 'xyz';
        doc.VersionData = beforeblob;
        doc.FirstPublishLocationId=userinfo.getUserId();
        doc.SBU__c='ATR';
        doc.TagCsv='Airlines BFE-SSFE Pursuits';
        cvlist.add(doc);
        ContentVersion doc1 = new ContentVersion();
        string before1 = 'Airlines BFE-SSFE Pursuits'; 
        Blob beforeblob1 = Blob.valueOf(before1);
        doc1.Title ='title1';
        doc1.SBU__c='ATR';
        doc1.PathOnClient = 'xyz';
        doc1.FirstPublishLocationId=userinfo.getUserId();
        doc1.VersionData = beforeblob1;
        doc1.TagCsv='Test Campaign';
        cvlist.add(doc1);
        insert cvlist;
        for(ContentVersion cv:cvlist)
          cvid.add(cv.id);
        cvlist = [select ContentDocumentId from ContentVersion where id IN: cvid];
        ContentWorkspace shareWorkspace = [select id from ContentWorkspace limit 1];

        for(ContentVersion cv:cvlist){
        ContentWorkspaceDoc docLink = new ContentWorkspaceDoc();
        docLink.ContentDocumentId = doc.ContentDocumentId;
        docLink.ContentWorkspaceId = shareWorkspace.id;
        cwdlist.add(docLink);
        }
        insert cwdlist;*/
        
        list<ContentVersion> conversationRecList = [select TagCsv from ContentVersion where IsLatest=true limit 1000];
        String csvName = '';
        for(ContentVersion conversationRec:conversationRecList){
            if(conversationRec.TagCsv != null){
                csvName = (String)conversationRec.TagCsv;
                break;
            }
        }
        Campaign cam = new Campaign();
        cam.Name=csvName;
        cam.CampaignPrimarySBU__c='ATR';
        cam.CampaignPrimaryCBTTier2__c = 'Airbus';
        cam.CBT_Team__c = 'Airbus Companies';
        cam.Status = 'Planned';
        cam.Type = 'Competative';
        cam.RMU__c = 'No';
        cam.ExpectedRevenue = 33000000;
        cam.Tech_Sales__c = 'Integrated Systems';
        cam.Tech_Sales_Product_Area__c = 'CBM';
        cam.IsActive = true;
        insert cam;
         
         
        Campaign cam1 = new Campaign();
        cam1.Name='xxxxxx';
        cam1.campaignPrimarySBU__c='ATR';
        cam1.campaignPrimaryCBTTier2__c = 'Airbus';
        cam1.CBT_Team__c = 'Airbus Companies';
        cam1.Status = 'Planned';
        cam1.Type = 'Competative';
        cam1.RMU__c = 'No';
        cam1.ExpectedRevenue = 33000000;
        cam1.Tech_Sales__c = 'Integrated Systems';
        cam1.Tech_Sales_Product_Area__c = 'CBM';
        cam1.IsActive = true;
        insert cam1;
         

        
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
            //Opportunity opp = [select id,CloseDate from Opportunity where  Related_Content_count__c>5 and SBU__c='ATR' limit 1];
           // opp.CloseDate = System.Today();
            //update opp;
            
          /*Opportunity opp = new Opportunity();
            opp.Name = csvName+' '+csvName+' '+csvName;
            opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'OE Complex' limit 1].Id;
            opp.SBU__c = 'ATR';
            opp.CampaignId=cam.id;
            opp.CBT_Tier_2__c = 'DAA';
            opp.CBT_Team_Tier_3__c = 'CBMS';
            opp.AccountId = acc.Id;
            opp.End_User__c = acc.Id;
            opp.Opportunity_Type__c = 'OE Complex';
            opp.StageName = 'Closed Cancelled';
            opp.CloseDate = System.Today();
            opp.Revenue_Type__c = 'ENG';
            opp.Content_Product_Name__c='A320';
            opp.Content_Platform_Name__c=csvName;
            opp.Bid_Type_Name__c = 'LTA';
            opp.Solution_Type__c = 'BFE / SSFE';
            opp.Incumbent__c = 'Incumbent';
            opp.Opportunity_Product_Line_Quantity__c = 10;
            opp.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
            opp.Opportunity_Product_Line_Platform__c = csvName;
            opp.ATR_Review_Org__c = 'Avionics LRU';
            opp.Lead_Number__c='Test Lead Number';
            insert opp;
            
            
            Opportunity opp1 = new Opportunity();
            opp1.Name = csvName+' '+csvName+' '+csvName;
            opp1.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'OE Complex' limit 1].Id;
            opp1.SBU__c = 'ATR';
            opp1.CampaignId=cam1.id;
            opp1.CBT_Tier_2__c = 'DAA';
            opp1.CBT_Team_Tier_3__c = 'CBMS';
            opp1.AccountId = acc.Id;
            opp1.End_User__c = acc.Id;
            opp1.Opportunity_Type__c = 'OE Complex';
            opp1.StageName = 'Closed Cancelled';
            opp1.CloseDate = System.Today();
            opp1.Revenue_Type__c = 'ENG';
            opp1.Content_Product_Name__c=csvName;
            opp1.Content_Platform_Name__c='Airbus'+', '+csvName+','+csvName;
            opp1.Bid_Type_Name__c = 'LTA';
            opp1.Solution_Type__c = 'BFE / SSFE';
            opp1.Incumbent__c = 'Incumbent';
            opp1.Opportunity_Product_Line_Quantity__c = 10;
            opp1.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
            opp1.Opportunity_Product_Line_Platform__c = csvName;
            opp1.ATR_Review_Org__c = 'Avionics LRU';
            opp1.Lead_Number__c='Test Lead Number';
            insert opp1;*/         
      

   
         
        Test.startTest();
        
        OpportunityLineItem oppLine = [select OpportunityID from OpportunityLineItem where ServiceDate<>null and Type__c = 'Forecast' limit 1];
        Opportunity opp = [select id,CloseDate from Opportunity where CloseDate<>null and id =:oppLine.OpportunityID];
        opp.CloseDate = opp.CloseDate+1;
        opp.Push_Product_Date__c = true;
        opp.ATR_Probability__c = 20;
        opp.Program_Go_Probability__c = 20;
        update opp;
        
        Content_Delivery__c cdy = new Content_Delivery__c();
             cdy.Opportunity__c = opp.Id;
             cdy.ID_Value__c = conversationRecList[0].Id;
             cdy.Content_Name__c = 'Test';
            insert cdy;
        
        Test.stopTest();
    }
    static testMethod void  myUnitTest3()    
    { 
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'ATR';
        acc.CBT__c = 'Airlines';
        acc.Region_Name__c = 'Europe/MiddleEast/Africa/India';
        acc.Sub_Region_Name__c = 'India';
        acc.Service_Level__c = 'Unauthorized Dist/Brkr';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'Test Account';
        acc.Market_Name__c = 'Air Transport';
        insert acc;
        
       
        Platform__c pf= new Platform__c();
        pf.Name='Test';
        pf.Platform_Type__c='Various';
        pf.Make__c= 'Cessna';
        pf.Model__c='Citation V';
        pf.Managing_SBU__c='ATR';
        insert pf;
        
        Fleet_Asset_Detail__c fleet= new Fleet_Asset_Detail__c();
        fleet.Name= 'Test Fleet';
        fleet.Platform_Name__c=pf.id;
        insert fleet;
        
        
        Pricebook2  standardPb= [select id from Pricebook2 where IsStandard = true limit 1];
        
        Opportunity opp= new opportunity();
        opp.Name= 'Test Oppty';
        opp.CloseDate=system.today();
        opp.AccountId= acc.id;
        opp.StageName= 'Prospecting' ;   
        opp.Type= 'Air Transport';
        opp.Regional_Sales_Manager__c= 'Mary Mcbride';
        opp.Sales_Type__c='Retrofit';
        opp.Aircraft_Ref__c=fleet.id;
        opp.Content_Product_Name__c='B777';
        opp.Content_Platform_Name__c='Beoing';
        opp.recordtypeid='01230000000ZQCM';//01230000000bN7l
        opp.dealer_account__c='0013000000bFvoD';
        opp.IC_Scorecard_Opportunity__c =false;
        opp.Win_Loss_Reason_Text__c='Test Oppurtunity for Win Loss Reason';
        opp.PWin__c ='1';
        opp.Pgo__c ='1';
        insert opp;
        
        list<ContentVersion> conversationRecList = [select Id, TagCsv from ContentVersion where IsLatest=true limit 100];
        String csvName = '';
        for(ContentVersion conversationRec:conversationRecList){
            if(conversationRec.TagCsv != null){
                csvName = (String)conversationRec.TagCsv;
                break;
            }
       }
       
        test.startTest();
        Workflow_details__c WFrec1= new Workflow_details__c();
        WFRec1.Opportunity_Description__c=opp.id;
        insert WFrec1;
        opp.recordtypeid='01230000000bN7l';
        opp.SBU__c='BGA';
        opp.CBT_Tier_2__c='Business Aviation';
        
        update opp;
        
        Content_Delivery__c cdy = new Content_Delivery__c();
             cdy.Opportunity__c = opp.Id;
             cdy.ID_Value__c = conversationRecList[0].Id;
             cdy.Content_Name__c = 'Test';
            insert cdy;
        test.stopTest();
    }
        
}