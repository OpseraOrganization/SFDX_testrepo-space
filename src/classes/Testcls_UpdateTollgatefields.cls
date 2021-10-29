@isTest(SeeAllData = true)
private class Testcls_UpdateTollgatefields{
    static testMethod void Testcls_UpdateTollgateFields(){
      //RecordType rId = [select id from RecordType where Name =: 'Standard'];
        Profile p = [select id from profile where name='System Administrator'];
        User u = new User();
        u.alias = 'standt';
        u.email='reply2manjuys@gmail.com';
        u.emailencodingkey='UTF-8';
        u.lastname='Testing';
        u.languagelocalekey='en_US';
        u.localesidkey='en_US';
        u.profileid = p.Id;
        u.timezonesidkey='America/Los_Angeles';
        u.username='yourresponse@test.com';
        insert u;
        Account a= new Account();
        a.Name='Tesst Account';
        a.Customer_Status__c='Active';
        a.Region_Name__c='Americas';
        a.Sub_Region_Name__c='Africa';
        a.Service_Level__c='Comprehensive';
        a.Strategic_Business_Unit__c='ATR';
        a.CBT__c='Airbus';
        a.CBT_Team__c='Airbus';
        a.Market_Name__c='Air Transport';
        a.Business_Owner__c='Ryan, Justin';
        a.Type='Air Cargo Transporter';
        a.REPORT_ACCOUNT_NAME__c='Test Report';
        insert a;
        Platform__c pl = new Platform__c(Name = 'hi', Make__c = 'hello', Model__c = 'test');
        insert pl;
        Opportunity opp = new Opportunity();
      //opp.RecordTypeId = rId.id;
        opp.RecordTypeId = label.D_S_Standard;
        opp.Name = 'Test';
        opp.SBU__c = 'D&S';
        opp.CBT_Tier_2__c = 'HBC';
        opp.CBT_Team_Tier_3__c = 'HBC';
        opp.End_User__c = a.id;
        opp.StageName = 'Closed Won';
        opp.Win_Loss_Reason_Code__c = 'Other';
        opp.CloseDate = system.today();
        opp.Accountid = a.id;
        opp.Prime_Sub__c = 'Prime';
        opp.Revenue_Type__c = 'ENG';
        opp.Bid_Type_Name__c = 'LTA';
        opp.International_Code__c = 'FMS';
        opp.Incumbent__c = 'Incumbent';
        opp.RMU__c = 'Yes';
        opp.RFP_Expected_Date__c = system.today();
        opp.Tech_Sales_Product_Area__c='APU';
        opp.ATR_Aircraft_Quantity__c = 1;
        opp.Win_Loss_Amount__c = 100;
        opp.Win_Loss_Reason_Text__c = 'Test';
        insert opp;
        
        Opportunity_Gate__c oppgate = new Opportunity_Gate__c();
        oppgate.Opportunity__c = opp.Id;
        oppgate.name = 'Solicitation Review';
        oppgate.Stage__c = 'launch';
        insert oppgate;
       
        Opportunity_Gate__c oppgate1 = new Opportunity_Gate__c();
        oppgate1.Opportunity__c = opp.Id;
        oppgate1.name = 'Pricing Meeting';
        oppgate1.Stage__c = 'propose';
        insert oppgate1;
        
        opp.RFP_Expected_Date__c = null;
        opp.RFP_Receipt_Date__c = system.today();
       opp.Win_Loss_Amount__c = 10;
       opp.Win_Loss_Reason_Text__c = 'abc';

        try{
           update opp;
        }catch(DMLException ee){}
    }
}