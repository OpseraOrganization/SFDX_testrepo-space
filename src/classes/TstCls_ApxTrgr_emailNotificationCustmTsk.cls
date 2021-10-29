@isTest(SeeAllData=true)
private class TstCls_ApxTrgr_emailNotificationCustmTsk{
    static testMethod void Tstcls_ApxTrgr_emailNotificationCustmTsk(){
        Profile p = [select id from profile where name='System Administrator'];
        User usr = new User();
        usr.alias = 'hariii';
        usr.email = 'hari2355@test.com';
        usr.emailencodingkey='UTF-8';
        usr.lastname='vnvb';
        usr.languagelocalekey='en_US';
        usr.localesidkey='en_US';
        usr.profileid = p.Id;
        usr.timezonesidkey='America/Los_Angeles';
        usr.username='standardhfuser@testinfghg.com';
        insert usr;
        
        Account acc = new Account();
        acc.Name='Accountss';
        acc.Customer_Status__c='Active';
        acc.Region_Name__c='Americas';
        acc.Sub_Region_Name__c='Africa';
        acc.Service_Level__c='Comprehensive';
        acc.Strategic_Business_Unit__c='ATR';
        acc.CBT__c='Airbus';
        acc.CBT_Team__c='Airbus';
        acc.Market_Name__c='Air Transport';
        acc.Business_Owner__c='Ryan, Justin';
        acc.Type='Air Cargo Transporter';
        acc.REPORT_ACCOUNT_NAME__c='Test Report';
        insert acc;
        
        Contact con= new Contact();
        con.AccountId=acc.Id;
        con.LastName='Hariii';
        con.SBU_Contact__c='ACS Labs';
        con.CBT__c='ACS Sensors Lab';
        con.CBT_Team__c='ACS Advanced Sensors';
        con.Primary_Email_Address__c='testintug@testiuyng.com';
        con.Phone_1__c= '1234567678';
        insert con;
        
        Case cas= new Case();
        cas.Origin='Email';
        cas.Export_Compliance_Content_ITAR_EAR__c='No';
        cas.Government_Compliance_SM_M_Content__c='No';
        cas.Status='Open';  
        cas.Type='AOG';
        cas.HON_Commit_Date__c=date.Today();
        cas.ContactId=con.Id;
        cas.Classification__c = 'GTO Product Support';
        cas.OwnerId = usr.Id;
        insert cas;
        
        Custom_Task__c ct = new Custom_Task__c();
        ct.A_C_Serial_Number__c = 'test';
        ct.A_C_Tail_number__c = 'test2';
        ct.Status__c = 'Completed';
        ct.Case__c = cas.id;
        ct.Core_Failed_Serial_number__c = 'hii';
        ct.Customer_Company_Name__c = 'test';
        ct.Customer_contact_phone_number__c = '5465484546';
        ct.Customer_contact_email_address__c = 'bs@gmail.com';
        ct.Customer_contact_fax_number__c = '46546498';
        ct.Customer_contact_name__c = 'ftef';
        ct.Customer_requested_date__c = system.today();
        ct.Customer_SAP_Sold_to_Account_Number__c = 'test';
        ct.Days_in_shop__c = '23';
        ct.End_user_operator__c = 'hari';
        ct.FOC_contract_MSA_agreement__c = 'teysatd';
        ct.FOC_econ__c = 'trw';
        ct.Part_number_requested__c = '48466';
        ct.PO_RO__c = '35346';
        ct.Quoted_repair_price_exchange_price__c = 'egre';
        ct.Reason_for_exchange_if_not_MSA_or_Econ__c= 'ebrfweyg';
        ct.Reason_for_repair_delay__c = 'hiiii';
        ct.Repair_CSR_contact_name__c = 'testing';
        ct.Repair_Shop_location__c = 'hyd';
        ct.SAP_Bill_to_Cust__c='46654';
        ct.SAP_Ship_to_cust__c = '4e6456';
        ct.SAP_Sold_to_Cust__c= '325346';
        ct.Shipping_Carrier__c= 'fbweryg';
        ct.Shipping_Method_Overnight_etc__c='rtr';
        ct.Special_Instructions__c='hello';
        insert ct;
        ct.EmailId__c = usr.Email;
        update ct;
    }
}