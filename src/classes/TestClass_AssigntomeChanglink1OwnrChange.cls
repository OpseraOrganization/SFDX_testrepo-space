@isTest
public class TestClass_AssigntomeChanglink1OwnrChange{
    static testMethod void TestClass_Assigntometest(){
        Profile p = [select id, name from Profile where name = 'System Administrator'];
        Account a= new Account();
        a.Name='Tesstty Account';
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
        a.REPORT_ACCOUNT_NAME__c='Testrt Report';
        insert a;

        Contact c= new Contact();
        c.AccountId=a.Id;
        c.LastName='Hari';
        c.SBU_Contact__c='ACS Labs';
        c.CBT__c='ACS Sensors Lab';
        c.CBT_Team__c='ACS Advanced Sensors';
        c.Primary_Email_Address__c='test@testtytr.com';
        c.Phone_1__c= '12345678';
        insert c;
        
        Case cas= new Case();
        cas.Origin='Email';
        cas.Export_Compliance_Content_ITAR_EAR__c='No';
        cas.Government_Compliance_SM_M_Content__c='No';
        cas.Status='Open';  
        cas.Type='AOG';
        cas.HON_Commit_Date__c=date.Today()+5;
        cas.ContactId=c.Id;
        cas.Classification__c = 'GTO Product Support';
        insert cas;
        
        apexpages.currentpage().getparameters().put('id',cas.id);
        User usr = new User();
        usr.alias = 'hari';
        usr.email = 'hari23@test.com';
        usr.emailencodingkey='UTF-8';
        usr.lastname='vnv';
        usr.languagelocalekey='en_US';
        usr.localesidkey='en_US';
        usr.profileid = p.Id;
        usr.timezonesidkey='America/Los_Angeles';
        usr.username='standarduser@testinghari.com';
        insert usr;
        
        cas.OwnerId = usr.Id;
        update Cas;
        ApexPages.StandardController sc = new ApexPages.StandardController(cas);
        Assigntome asme = new Assigntome(sc);
        asme.redirect();
        asme.UpdateOwner();
        changelink1 chli = new changelink1(sc);
        chli.redirect();
        chli.UpdateOwner();
        OwnerChange och = new OwnerChange(sc);
        och.popup();
    }
}