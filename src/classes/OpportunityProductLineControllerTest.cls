@isTest
Public class OpportunityProductLineControllerTest {
    //public String oppId;
    public String accId{get;set;}
    public String stage{get;set;}
    public String rt{get;set;}
    public String rorg{get;set;}
    public String soltype{get;set;}
    public String oppId{get;set;}
    public String actMsg{get;set;}
    public String accNameToSearch{get;set;}
   // public String quantity{get;set;}
    public String platform{get;set;}
    public String platformtype{get;set;}
    public String tableheader{get;set;}
    public String tableheader1{get;set;}
    public String tableheader2{get;set;}
    
    
    
    public List<Opportunity_Product_Line__c> searchResults1{get;set;}
    public List<OppProdLine__c> searchResults{get;set;}
    public List<Account_Email_Domains__c> emailDomains{get;set;}
    public List<EmailDomains> emailDomainsList{get;set;}
    
    public Set<String> selectedEmailDomains{
        get {
            if(selectedEmailDomains == null) selectedEmailDomains= new Set<String>();
                return selectedEmailDomains;
        }
        set;
    }
    static testMethod void OpportunityProductLineControllerTest(){
        
        EmailDomains ed2 = new EmailDomains();
        ed2.checked = true;
        ed2.checked1 = true;
        ed2.checked2 = true;
        OppProdLine__c oppLine = new OppProdLine__c();
        oppLine.name ='Test';
        insert oppLine;
        
        List<Id> OpptyId= new List<Id> ();
        
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
        opp.Name = 'Test Method Opportunity';
        opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'OE Complex' limit 1].Id;
        opp.SBU__c = 'D&S';
        opp.CBT_Tier_2__c = 'DAA';
        opp.CBT_Team_Tier_3__c = 'CBMS';
        opp.AccountId = acc.Id;
        opp.End_User__c = acc.Id;
        opp.Opportunity_Type__c = 'OE Complex';
        opp.StageName = 'Closed Cancelled';
        opp.CloseDate = System.Today();
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'LTA';
        opp.Solution_Type__c = 'BFE / SSFE';
        opp.Incumbent__c = 'Incumbent';
        opp.Opportunity_Product_Line_Quantity__c = 10;
        opp.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
        opp.Opportunity_Product_Line_Platform__c = 'Airbus';
        opp.ATR_Review_Org__c = 'Avionics LRU';
        
        
        //insert opp;
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Method Opportunity1';
        opp1.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'AM Complex' limit 1].Id;
        opp1.SBU__c = 'D&S';
        opp1.CBT_Tier_2__c = 'DAA';
        opp1.CBT_Team_Tier_3__c = 'CBMS';
        opp1.AccountId = acc.Id;
        opp1.End_User__c = acc.Id;
        opp1.Tech_Sales_Product_Area__c = 'APU';
        opp1.Tech_Sales__c = 'Mechanical Systems';
        opp1.Prime_Sub__c = 'Prime';
        opp1.Opportunity_Type__c = 'AM Complex';
        opp1.StageName = 'Closed Won';
        opp1.CloseDate = System.Today();
        opp1.Revenue_Type__c = 'ENG';
        opp1.Bid_Type_Name__c = 'LTA';
        opp1.International_Code__c = 'FMS';
        opp1.Incumbent__c = 'Incumbent';
        opp1.RMU__c = 'YES';
        opp1.Opportunity_Product_Line_Quantity__c = 11;
        opp1.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
        opp1.Opportunity_Product_Line_Platform__c = 'Airbus Widebody';
        opp1.Active__c = TRUE;
        opp1.ATR_Review_Org__c = 'Avionics & Lighting Services';
        opp1.Type_of_Opportunity__c = 'RMU – Level 3 (Low Probability)';
        opp1.Amount=1;
        opp1.Program_Terms__c='1';
        //oppId = opp.Id;
        
        //insert opp1;
        
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Test Method Opportunity2';
        opp2.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'AM Complex' limit 1].Id;
        opp2.SBU__c = 'D&S';
        opp2.CBT_Tier_2__c = 'DAA';
        opp2.CBT_Team_Tier_3__c = 'CBMS';
        opp2.AccountId = acc.Id;
        opp2.End_User__c = acc.Id;
        opp2.Tech_Sales_Product_Area__c = 'APU';
        opp2.Tech_Sales__c = 'Mechanical Systems';
        opp2.Prime_Sub__c = 'Prime';
        opp2.Opportunity_Type__c = 'AM Complex';
        opp2.StageName = 'Closed Won';
        opp2.CloseDate = System.Today();
        opp2.Revenue_Type__c = 'ENG';
        opp2.Bid_Type_Name__c = 'LTA';
        opp2.International_Code__c = 'FMS';
        opp2.Incumbent__c = 'Incumbent';
        opp2.RMU__c = 'YES';
        opp2.Opportunity_Product_Line_Quantity__c = 11;
        opp2.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
        opp2.Opportunity_Product_Line_Platform__c = 'Airbus Widebody';
        opp2.Active__c = TRUE;
        opp2.ATR_Review_Org__c = 'Avionics LRU';
        
        
        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(opp);
        oppList.add(opp1);
        insert opplist;
       
        
        Opportunity_Product_Line__c oplc = new Opportunity_Product_Line__c();
        oplc.Opportunity__c = opp.Id;
        oplc.Product_Line__c = 'ADIRS';
        oplc.Maintain_Incumbency__c = true;
        oplc.New_Customer_No_Incumbency__c = false;
        oplc.Overturn_Non_Incumbency__c = false;
               
        insert oplc; 
        
       /*  Opportunity_Product_Line__c oplc1 = new Opportunity_Product_Line__c();
        oplc1.Opportunity__c = opp1.Id;
        oplc1.Product_Line__c = 'ADIRS';
        oplc1.Maintain_Incumbency__c = false;
        oplc1.New_Customer_No_Incumbency__c = true;
        oplc1.Overturn_Non_Incumbency__c = false;
               
        insert oplc1; 
        
        Opportunity_Product_Line__c oplc2 = new Opportunity_Product_Line__c();
        oplc2.Opportunity__c = opp2.Id;
        oplc2.Product_Line__c = 'RDR';
        oplc2.Maintain_Incumbency__c = false;
        oplc2.New_Customer_No_Incumbency__c = false;
        oplc2.Overturn_Non_Incumbency__c = true;
               
        insert oplc2; */
        
        OpportunityProductLineController opc = new OpportunityProductLineController();
        opc.platform='test';
        opc.platformtype='Airbus Widebody';
        //opc.quantity='10';
        ApexPages.CurrentPage().getParameters().Put('id',oplc.id);
        ApexPages.CurrentPage().getParameters().Put('rorg','Avionics LRU');
        ApexPages.CurrentPage().getParameters().Put('rtype','OE Complex');
        ApexPages.CurrentPage().getParameters().Put('stage','Closed Lost');
        ApexPages.CurrentPage().getParameters().Put('oppId',opp.Id);
        opc.setString('test');
        
        opc.search();
        OpportunityProductLineController.EmailDomains domain = new OpportunityProductLineController.EmailDomains();
        domain.checked = true;
        domain.checked1 = true;
        domain.checked2 = true;
        domain.pLine = 'Test';
        domain.pComments = 'Test';
        domain.emailDomain = 'Test';
        
      /* OpportunityProductLineController opc1 = new OpportunityProductLineController();
        opc1.platform='test1';
        opc1.platformtype='Airbus Narrowbody';
        opc1.quantity='12';
        ApexPages.CurrentPage().getParameters().Put('id',opc1.id);
        ApexPages.CurrentPage().getParameters().Put('rorg','Avionics & Lighting Services');
        ApexPages.CurrentPage().getParameters().Put('rtype','AM Complex');
        ApexPages.CurrentPage().getParameters().Put('stage','Closed Won');
        ApexPages.CurrentPage().getParameters().Put('soltype','BFE / SSFE');
        opc1.search();
        
        
        OpportunityProductLineController opc2 = new OpportunityProductLineController();
        opc2.platform='tes test1';
        opc2.platformtype='Airbus Narrowbody';
        opc2.quantity='13';
        ApexPages.CurrentPage().getParameters().Put('id',opc2.id);
        ApexPages.CurrentPage().getParameters().Put('rorg','Avionics LRU');
        ApexPages.CurrentPage().getParameters().Put('rtype','AM Complex');
        ApexPages.CurrentPage().getParameters().Put('stage','Closed Cancelled');
        ApexPages.CurrentPage().getParameters().Put('soltype','BFE / SSFE');
        opc2.search();
         */         
        //opc.addToAccount();
        try {
            opc.addToAccount();
        }catch(Exception ex){}
        
        opc.doCancel();
        }
         
        
        public class EmailDomains{
            public Boolean checked{get;set;}
            public Boolean checked1{get;set;}
            public Boolean checked2{get;set;}
            public String pLine{get;set;}
            public String pComments{get;set;}
            
            public String emailDomain{get;set;}
        }
        
        static testMethod void OpportunityProductLineControllerTest1(){
        
        EmailDomains ed2 = new EmailDomains();
        ed2.checked = true;
        ed2.checked1 = true;
        ed2.checked2 = true;
        
        List<Id> OpptyId= new List<Id> ();
        
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
        opp.Name = 'Test Method Opportunity';
        opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'OE Complex' limit 1].Id;
        opp.SBU__c = 'D&S';
        opp.CBT_Tier_2__c = 'DAA';
        opp.CBT_Team_Tier_3__c = 'CBMS';
        opp.AccountId = acc.Id;
        opp.End_User__c = acc.Id;
        opp.Opportunity_Type__c = 'OE Complex';
        opp.StageName = 'Closed Cancelled';
        opp.CloseDate = System.Today();
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'LTA';
        opp.Solution_Type__c = 'BFE / SSFE';
        opp.Incumbent__c = 'Incumbent';
        opp.Opportunity_Product_Line_Quantity__c = 10;
        opp.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
        opp.Opportunity_Product_Line_Platform__c = 'Airbus';
        opp.ATR_Review_Org__c = 'Avionics LRU';
        
        
        //insert opp;
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Method Opportunity1';
        opp1.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'AM Complex' limit 1].Id;
        opp1.SBU__c = 'D&S';
        opp1.CBT_Tier_2__c = 'DAA';
        opp1.CBT_Team_Tier_3__c = 'CBMS';
        opp1.AccountId = acc.Id;
        opp1.End_User__c = acc.Id;
        opp1.Tech_Sales_Product_Area__c = 'APU';
        opp1.Tech_Sales__c = 'Mechanical Systems';
        opp1.Prime_Sub__c = 'Prime';
        opp1.Opportunity_Type__c = 'AM Complex';
        opp1.StageName = 'Closed Won';
        opp1.CloseDate = System.Today();
        opp1.Revenue_Type__c = 'ENG';
        opp1.Bid_Type_Name__c = 'LTA';
        opp1.International_Code__c = 'FMS';
        opp1.Incumbent__c = 'Incumbent';
        opp1.RMU__c = 'YES';
        opp1.Opportunity_Product_Line_Quantity__c = 11;
        opp1.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
        opp1.Opportunity_Product_Line_Platform__c = 'Airbus Widebody';
        opp1.Active__c = TRUE;
        opp1.ATR_Review_Org__c = 'Avionics & Lighting Services';
        opp1.Type_of_Opportunity__c = 'RMU – Level 3 (Low Probability)';
        opp1.Amount=1;
        opp1.Program_Terms__c='1';
        //oppId = opp.Id;
        
        //insert opp1;
        
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Test Method Opportunity2';
        opp2.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'AM Complex' limit 1].Id;
        opp2.SBU__c = 'D&S';
        opp2.CBT_Tier_2__c = 'DAA';
        opp2.CBT_Team_Tier_3__c = 'CBMS';
        opp2.AccountId = acc.Id;
        opp2.End_User__c = acc.Id;
        opp2.Tech_Sales_Product_Area__c = 'APU';
        opp2.Tech_Sales__c = 'Mechanical Systems';
        opp2.Prime_Sub__c = 'Prime';
        opp2.Opportunity_Type__c = 'AM Complex';
        opp2.StageName = 'Closed Won';
        opp2.CloseDate = System.Today();
        opp2.Revenue_Type__c = 'ENG';
        opp2.Bid_Type_Name__c = 'LTA';
        opp2.International_Code__c = 'FMS';
        opp2.Incumbent__c = 'Incumbent';
        opp2.RMU__c = 'YES';
        opp2.Opportunity_Product_Line_Quantity__c = 11;
        opp2.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
        opp2.Opportunity_Product_Line_Platform__c = 'Airbus Widebody';
        opp2.Active__c = TRUE;
        opp2.ATR_Review_Org__c = 'Avionics LRU';
        
        
        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(opp);
        oppList.add(opp1);
        insert opplist;
       
        
        Opportunity_Product_Line__c oplc = new Opportunity_Product_Line__c();
        oplc.Opportunity__c = opp.Id;
        oplc.Product_Line__c = 'ADIRS';
        oplc.Maintain_Incumbency__c = true;
        oplc.New_Customer_No_Incumbency__c = false;
        oplc.Overturn_Non_Incumbency__c = false;
               
        insert oplc; 
        
       /*  Opportunity_Product_Line__c oplc1 = new Opportunity_Product_Line__c();
        oplc1.Opportunity__c = opp1.Id;
        oplc1.Product_Line__c = 'ADIRS';
        oplc1.Maintain_Incumbency__c = false;
        oplc1.New_Customer_No_Incumbency__c = true;
        oplc1.Overturn_Non_Incumbency__c = false;
               
        insert oplc1; 
        
        Opportunity_Product_Line__c oplc2 = new Opportunity_Product_Line__c();
        oplc2.Opportunity__c = opp2.Id;
        oplc2.Product_Line__c = 'RDR';
        oplc2.Maintain_Incumbency__c = false;
        oplc2.New_Customer_No_Incumbency__c = false;
        oplc2.Overturn_Non_Incumbency__c = true;
               
        insert oplc2; */
        
        
        ApexPages.CurrentPage().getParameters().Put('id',oplc.id);
        ApexPages.CurrentPage().getParameters().Put('rorg','Avionics LRU');
        ApexPages.CurrentPage().getParameters().Put('rtype','OE Complex');
        ApexPages.CurrentPage().getParameters().Put('stage','Closed Won');
        ApexPages.CurrentPage().getParameters().Put('oppId',opp.Id);
        
        OpportunityProductLineController opc = new OpportunityProductLineController();
        opc.platform='test';
        opc.platformtype='Airbus Widebody';
        //opc.quantity='10';
        opc.setString('test');
        
        opc.search();
        OpportunityProductLineController.EmailDomains domain = new OpportunityProductLineController.EmailDomains();
        domain.checked = true;
        domain.checked1 = true;
        domain.checked2 = true;
        domain.pLine = 'Test';
        domain.pComments = 'Test';
        domain.emailDomain = 'Test';
        
      /* OpportunityProductLineController opc1 = new OpportunityProductLineController();
        opc1.platform='test1';
        opc1.platformtype='Airbus Narrowbody';
        opc1.quantity='12';
        ApexPages.CurrentPage().getParameters().Put('id',opc1.id);
        ApexPages.CurrentPage().getParameters().Put('rorg','Avionics & Lighting Services');
        ApexPages.CurrentPage().getParameters().Put('rtype','AM Complex');
        ApexPages.CurrentPage().getParameters().Put('stage','Closed Won');
        ApexPages.CurrentPage().getParameters().Put('soltype','BFE / SSFE');
        opc1.search();
        
        
        OpportunityProductLineController opc2 = new OpportunityProductLineController();
        opc2.platform='tes test1';
        opc2.platformtype='Airbus Narrowbody';
        opc2.quantity='13';
        ApexPages.CurrentPage().getParameters().Put('id',opc2.id);
        ApexPages.CurrentPage().getParameters().Put('rorg','Avionics LRU');
        ApexPages.CurrentPage().getParameters().Put('rtype','AM Complex');
        ApexPages.CurrentPage().getParameters().Put('stage','Closed Cancelled');
        ApexPages.CurrentPage().getParameters().Put('soltype','BFE / SSFE');
        opc2.search();
         */         
        //opc.addToAccount();
        try {
            opc.addToAccount();
        }catch(Exception ex){}
        
        opc.doCancel();
        }
        
        
        static testMethod void OpportunityProductLineControllerTest2(){
        
        EmailDomains ed2 = new EmailDomains();
        ed2.checked = true;
        ed2.checked1 = true;
        ed2.checked2 = true;
        
        List<Id> OpptyId= new List<Id> ();
        
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
        opp.Name = 'Test Method Opportunity';
        opp.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'OE Complex' limit 1].Id;
        opp.SBU__c = 'D&S';
        opp.CBT_Tier_2__c = 'DAA';
        opp.CBT_Team_Tier_3__c = 'CBMS';
        opp.AccountId = acc.Id;
        opp.End_User__c = acc.Id;
        opp.Opportunity_Type__c = 'OE Complex';
        opp.StageName = 'Closed Cancelled';
        opp.CloseDate = System.Today();
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'LTA';
        opp.Solution_Type__c = 'BFE / SSFE';
        opp.Incumbent__c = 'Incumbent';
        opp.Opportunity_Product_Line_Quantity__c = 10;
        opp.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
        opp.Opportunity_Product_Line_Platform__c = 'Airbus';
        opp.ATR_Review_Org__c = 'Avionics LRU';
        
        
        //insert opp;
        
        Opportunity opp1 = new Opportunity();
        opp1.Name = 'Test Method Opportunity1';
        opp1.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'AM Complex' limit 1].Id;
        opp1.SBU__c = 'D&S';
        opp1.CBT_Tier_2__c = 'DAA';
        opp1.CBT_Team_Tier_3__c = 'CBMS';
        opp1.AccountId = acc.Id;
        opp1.End_User__c = acc.Id;
        opp1.Tech_Sales_Product_Area__c = 'APU';
        opp1.Tech_Sales__c = 'Mechanical Systems';
        opp1.Prime_Sub__c = 'Prime';
        opp1.Opportunity_Type__c = 'AM Complex';
        opp1.StageName = 'Closed Won';
        opp1.CloseDate = System.Today();
        opp1.Revenue_Type__c = 'ENG';
        opp1.Bid_Type_Name__c = 'LTA';
        opp1.International_Code__c = 'FMS';
        opp1.Incumbent__c = 'Incumbent';
        opp1.RMU__c = 'YES';
        opp1.Opportunity_Product_Line_Quantity__c = 11;
        opp1.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
        opp1.Opportunity_Product_Line_Platform__c = 'Airbus Widebody';
        opp1.Active__c = TRUE;
        opp1.ATR_Review_Org__c = 'Avionics & Lighting Services';
        opp1.Type_of_Opportunity__c = 'RMU – Level 3 (Low Probability)';
        opp1.Amount=1;
        opp1.Program_Terms__c='1';
        //oppId = opp.Id;
        
        //insert opp1;
        
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Test Method Opportunity2';
        opp2.RecordTypeId = [SELECT id FROM RecordType WHERE SobjectType = 'Opportunity' AND Name = 'AM Complex' limit 1].Id;
        opp2.SBU__c = 'D&S';
        opp2.CBT_Tier_2__c = 'DAA';
        opp2.CBT_Team_Tier_3__c = 'CBMS';
        opp2.AccountId = acc.Id;
        opp2.End_User__c = acc.Id;
        opp2.Tech_Sales_Product_Area__c = 'APU';
        opp2.Tech_Sales__c = 'Mechanical Systems';
        opp2.Prime_Sub__c = 'Prime';
        opp2.Opportunity_Type__c = 'AM Complex';
        opp2.StageName = 'Closed Won';
        opp2.CloseDate = System.Today();
        opp2.Revenue_Type__c = 'ENG';
        opp2.Bid_Type_Name__c = 'LTA';
        opp2.International_Code__c = 'FMS';
        opp2.Incumbent__c = 'Incumbent';
        opp2.RMU__c = 'YES';
        opp2.Opportunity_Product_Line_Quantity__c = 11;
        opp2.Opportunity_Product_Line_Platform_Type__c = 'Test Platform';
        opp2.Opportunity_Product_Line_Platform__c = 'Airbus Widebody';
        opp2.Active__c = TRUE;
        opp2.ATR_Review_Org__c = 'Avionics LRU';
        
        
        List<Opportunity> oppList = new List<Opportunity>();
        oppList.add(opp);
        oppList.add(opp1);
        insert opplist;
       
        
        Opportunity_Product_Line__c oplc = new Opportunity_Product_Line__c();
        oplc.Opportunity__c = opp.Id;
        oplc.Product_Line__c = 'ADIRS';
        oplc.Maintain_Incumbency__c = true;
        oplc.New_Customer_No_Incumbency__c = false;
        oplc.Overturn_Non_Incumbency__c = false;
               
        insert oplc; 
        
       /*  Opportunity_Product_Line__c oplc1 = new Opportunity_Product_Line__c();
        oplc1.Opportunity__c = opp1.Id;
        oplc1.Product_Line__c = 'ADIRS';
        oplc1.Maintain_Incumbency__c = false;
        oplc1.New_Customer_No_Incumbency__c = true;
        oplc1.Overturn_Non_Incumbency__c = false;
               
        insert oplc1; 
        
        Opportunity_Product_Line__c oplc2 = new Opportunity_Product_Line__c();
        oplc2.Opportunity__c = opp2.Id;
        oplc2.Product_Line__c = 'RDR';
        oplc2.Maintain_Incumbency__c = false;
        oplc2.New_Customer_No_Incumbency__c = false;
        oplc2.Overturn_Non_Incumbency__c = true;
               
        insert oplc2; */
        
        
        ApexPages.CurrentPage().getParameters().Put('id',oplc.id);
        ApexPages.CurrentPage().getParameters().Put('rorg','Avionics LRU');
        ApexPages.CurrentPage().getParameters().Put('rtype','OE Complex');
        ApexPages.CurrentPage().getParameters().Put('stage','Closed Lost');
        ApexPages.CurrentPage().getParameters().Put('oppId',opp.Id);
        
        OpportunityProductLineController opc = new OpportunityProductLineController();
        opc.platform='test';
        opc.platformtype='Airbus Widebody';
        //opc.quantity='10';
        opc.setString('test');
        
        opc.search();
        OpportunityProductLineController.EmailDomains domain = new OpportunityProductLineController.EmailDomains();
        domain.checked = true;
        domain.checked1 = true;
        domain.checked2 = true;
        domain.pLine = 'Test';
        domain.pComments = 'Test';
        domain.emailDomain = 'Test';
        
      /* OpportunityProductLineController opc1 = new OpportunityProductLineController();
        opc1.platform='test1';
        opc1.platformtype='Airbus Narrowbody';
        opc1.quantity='12';
        ApexPages.CurrentPage().getParameters().Put('id',opc1.id);
        ApexPages.CurrentPage().getParameters().Put('rorg','Avionics & Lighting Services');
        ApexPages.CurrentPage().getParameters().Put('rtype','AM Complex');
        ApexPages.CurrentPage().getParameters().Put('stage','Closed Won');
        ApexPages.CurrentPage().getParameters().Put('soltype','BFE / SSFE');
        opc1.search();
        
        
        OpportunityProductLineController opc2 = new OpportunityProductLineController();
        opc2.platform='tes test1';
        opc2.platformtype='Airbus Narrowbody';
        opc2.quantity='13';
        ApexPages.CurrentPage().getParameters().Put('id',opc2.id);
        ApexPages.CurrentPage().getParameters().Put('rorg','Avionics LRU');
        ApexPages.CurrentPage().getParameters().Put('rtype','AM Complex');
        ApexPages.CurrentPage().getParameters().Put('stage','Closed Cancelled');
        ApexPages.CurrentPage().getParameters().Put('soltype','BFE / SSFE');
        opc2.search();
         */         
        //opc.addToAccount();
        try {
            opc.addToAccount();
        }catch(Exception ex){}
        
        opc.doCancel();
        }
}