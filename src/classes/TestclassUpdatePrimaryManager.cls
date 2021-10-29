@isTest
private class TestclassUpdatePrimaryManager   {
 
    static testMethod void TestclassUpdatePrimaryManager() { 
    
        Profile p1 = [select id from profile where name='Master Data Administrator' ];
        Date d1 =Date.newInstance(2009,08,12);
        List<User> usr = [Select Id,Profile.Name from User where Profile.Name='System Administrator' limit 4];

        User u = new User();
        u.alias = 'standt';
        u.email='standarduser@testorg.com';
        u.emailencodingkey='UTF-8'; 
        u.lastname='Testing';
        u.languagelocalekey='en_US';
        u.localesidkey='en_US'; 
        u.profileid = p1.Id;
        u.timezonesidkey='America/Los_Angeles';
        u.username='Testinguser123testing@gmail.com';
        insert u;
      
        Profile p2 = [select id from profile where name='ACS Sales Admin' ];   
        User u1 = new User();
        u1.alias = 'standtt';
        u1.email='standarduser1@testorg.com';
        u1.emailencodingkey='UTF-8'; 
        u1.lastname='Testing1';
        u1.languagelocalekey='en_US';
        u1.localesidkey='en_US'; 
        u1.profileid = p2.Id;
        u1.timezonesidkey='America/Los_Angeles';
        u1.username='Tesuser12testing@gmail.com';
        insert u1;
         Account a= new Account();
        System.runAs(u){
        a.Name='Test Account';
        a.Customer_Status__c='Active';
        a.Strategic_Business_Unit__c='ATR';
        a.Region_Name__c='Americas';
        a.Service_Level__c='Comprehensive';
        a.Type='Air Cargo Transporter';
        a.REPORT_ACCOUNT_NAME__c='Test report';
        insert a;
        }
        Contact c=new Contact();
        c.LastName='Chiranthghjhgj';
        c.AccountId=a.Id;
        c.Email='tesghjghte@sales.com';
        c.Primary_Email_Address__c='aruin@sales.com';
        c.Phone_3__c='4545412';
        c.SBU_Contact__c='ACS Labs';
        insert c;
   
        Platform__c p=new Platform__c();
        p.Model__c='Test Platform';
        p.Make__c='Test make';
        insert p;
   
        Opportunity o= new Opportunity();
        o.Name='Test Opportunity';
        o.RecordtypeId='01230000000ZIv2';
        o.Engineering__c='testeng';
        o.ISC__c='Testisc';
        o.Pricing__c='Test Pricwe';
        o.Tech_Sales1__c='tt';
        o.SBU__c='ATR';
        o.AccountId=a.Id;
        o.StageName='Closed Won';
        o.End_User__c=a.Id;
        o.CloseDate=d1;
        o.Prime_Sub__c='Joint Venture';
        o.Platform__c=p.Id;
        o.Revenue_Type__c='ENG';
        o.Type='PrePriced';
        o.Bid_Type_Name__c='Competitive';
        o.ATR_Actual_Close_Date__c=d1;
        o.Win_Loss_Reason_Code__c='Best Value Solution';
        o.Win_Loss_Reason_Text__c='Test23';
        o.Incumbent__c='Incumbent';
        o.RMU__c='Yes';
        o.International_Code__c='Domestic';

        insert o;
        o.Engineering__c='test cases';
        //o.ISC__c='Testin123';
        update o;
     
        o.ISC__c='Testin123';
        update o;
        
        List<Opportunity_Sales_Team__c> ostlist = new List<Opportunity_Sales_Team__c>();
        Opportunity_Sales_Team__c ost1 = new Opportunity_Sales_Team__c();
        ost1.Opportunity__c = o.Id;
        ost1.User__c = [Select Id from User where LastName like '%kumar%' limit 1].Id;
        ost1.Opportunity_Team_Role__c='Engineering';
        ostlist.add(ost1);      
        
        Opportunity_Sales_Team__c ost2 = new Opportunity_Sales_Team__c();
        ost2.Opportunity__c = o.Id;
        ost2.Opportunity_Team_Role__c='Program Mgr';
        ost2.User__c = u.Id;
        ostlist.add(ost2);
        
        Opportunity_Sales_Team__c ost3 = new Opportunity_Sales_Team__c();
        ost3.Opportunity__c = o.Id;
        ost3.Opportunity_Team_Role__c='ISC';
        ost3.User__c = u1.Id;
        ostlist.add(ost3);
        
        Opportunity_Sales_Team__c ost4 = new Opportunity_Sales_Team__c();
        ost4.Opportunity__c = o.Id;
        ost4.Opportunity_Team_Role__c='Pricing';
        ost4.User__c = usr[0].Id;
        ostlist.add(ost4);
        
        Opportunity_Sales_Team__c ost5 = new Opportunity_Sales_Team__c();
        ost5.Opportunity__c = o.Id;
        ost5.Opportunity_Team_Role__c='Technical Sales';
        ost5.User__c = usr[1].Id;
        ostlist.add(ost5);
        
        Opportunity_Sales_Team__c ost6 = new Opportunity_Sales_Team__c();
        ost6.Opportunity__c = o.Id;
        ost6.Opportunity_Team_Role__c='Tech Sales Secondary';
        ost6.User__c = usr[2].Id;
        ostlist.add(ost6);
        
        Opportunity_Sales_Team__c ost7 = new Opportunity_Sales_Team__c();
        ost7.Opportunity__c = o.Id;
        ost7.Opportunity_Team_Role__c='Sales Lead';
        ost7.User__c = usr[3].Id;
        ostlist.add(ost7);
        try{
        insert ostlist;
         Test.startTest();
        update ostlist;
        delete ostlist;
        Test.stopTest();
        }catch(Exception e){} 
    }
 }