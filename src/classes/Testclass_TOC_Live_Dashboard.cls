@isTest(SeeAllData=true)
public class Testclass_TOC_Live_Dashboard{
    static testMethod void Testclass_TOC_Live_Dashboard(){
                   
        User usr =[select id,Primary_Manager_Name__c,Primary_Manager_EID__c from user where profile.name = 'System Administrator' and isactive = true order by createddate asc limit 1];
        Account a=[select id,name,Customer_Status__c,Strategic_Business_Unit__c,CBT__c,Region_Name__c,Sub_Region_Name__c,Service_Level__c,Type,REPORT_ACCOUNT_NAME__c from account where Name LIKE '%HONEYWELL%' limit 1];
        
        Platform__c pl = new Platform__c();
        pl.Name = 'Test Paltform';
        pl.Model__c = '36-16A';
        pl.Make__c = 'VARIOUS OEMS';
        pl.SAP_External_System__c=True;
        insert pl;
        
        /*Account a= new Account();
        a.Name='Tetty Account';
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
        a.REPORT_ACCOUNT_NAME__c='Tert Report';
        insert a;*/

        Contact c= new Contact();
        c.AccountId=a.Id;
        c.LastName='Hari';
        c.SBU_Contact__c='ACS Labs';
        c.CBT__c='ACS Sensors Lab';
        c.CBT_Team__c='ACS Advanced Sensors';
        c.Primary_Email_Address__c='test@teytr.com';
        c.Phone_1__c= '12345678';
        insert c;
        
        /*User usr = new User();
        usr.alias = 'hari';
        usr.email = 'hi23@test.com';
        usr.emailencodingkey='UTF-8';
        usr.lastname='vnv';
        usr.languagelocalekey='en_US';
        usr.localesidkey='en_US';
        usr.profileid = p.Id;
        usr.timezonesidkey='America/Los_Angeles';
        usr.username='standaser@testinghari.com';
        insert usr;*/
        
        Supported_Products__c sp = new Supported_Products__c();
        sp.Name = 'Test';
        sp.Product_Type__c = 'Electrical';
        sp.Status__c = 'Active';
        insert sp;
        
        List<Case> caslist = new List<Case>();
        Case ca= new Case();
        ca.Origin='Email';
        ca.Export_Compliance_Content_ITAR_EAR__c='No';
        ca.Government_Compliance_SM_M_Content__c='No';
        ca.Status='Done';  
        ca.Type='AOG';
        ca.Aircraft_Type__c=pl.id;
        ca.HON_Commit_Date__c=date.Today()+5;
        ca.ContactId=c.Id;
        ca.RecordtypeId = label.TechnicalIssueId;
        ca.Classification__c = 'EMS';
        ca.Sub_Class__c = 'Publications';
        ca.Detail_Class__c = 'STC';
        ca.Supported_Products__c = sp.id;
        ca.Resolution_Tool__c = 'VN Other';
        ca.Resolution__c = 'hi';
        ca.User_VN_Name__c = usr.id;
        ca.Ownerid = '005300000042h68';
        ca.SBU_w2c__c = 'ATR';
        caslist.add(ca);
        
        Case ca1 = new Case();
        ca1.Origin = 'Phone';
        ca1.Closed_Date__c = date.Today();
        ca1.Export_Compliance_Content_ITAR_EAR__c='No';
        ca1.Government_Compliance_SM_M_Content__c='No';
        ca1.Status='Open';
        ca1.Aircraft_Type__c=pl.id;  
        ca1.Type='AOG';
        ca1.HON_Commit_Date__c=date.Today();
        ca1.ContactId=c.Id;
        ca1.RecordtypeId = label.TechnicalIssueId;
        ca1.Classification__c = 'GTO Product Support';
        ca1.Sub_Class__c = 'D&S';
        ca1.Detail_Class__c = 'Other';
        ca1.Supported_Products__c = sp.id;
        ca1.Resolution_Tool__c = 'VN PSE';
        ca1.Resolution__c = 'hello';
        ca1.Ownerid = '005300000042h68';
        ca1.Age_Custom__c = 10;
        caslist.add(ca1);
        try{
        insert caslist;
        }catch(DMLException e){}
        
        Feedback__c fb = new Feedback__c();
        fb.Account__c = a.id;
        fb.RecordtypeId = '01230000000ZewI';
        fb.Case__c = caslist[0].id;
        insert fb;
        Test.startTest(); 
        TOC_Live_Dashboard toc = new TOC_Live_Dashboard();
        toc.thisweekcase();
        toc.lastmonthcase();
        pagereference pg = page.TOCLiveDashboard;
        pg.getparameters().put('curval2',String.valueOf(ca1.id));   
        pg.getparameters().put('lastval2',String.valueOf(ca1.id));    
        Test.stopTest();
   }
}