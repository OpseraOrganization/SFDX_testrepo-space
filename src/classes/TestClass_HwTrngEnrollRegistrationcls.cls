@isTest(seealldata=true)
private class TestClass_HwTrngEnrollRegistrationcls
{
    //public string radiovalue{get;set;}
    //public boolean requiredval{get;set;}
    static testMethod void TestClass_HwTrngEnrollRegistrationclsTest() {
       
        boolean requiredval=true;
        string radiovalue='NO';
            
        //ID ProfileID = [ Select id from Profile where name = 'Training - Customer Portal'].id;
        Account A1 = new Account(Name = 'Test Account');
        insert A1;
        
        List<Contact> ContactList = new List<Contact>();
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User',Honeywell_ID__c='E407308', 
        email = 'test-user@fakeemail.com' );
        insert C1;
 
        
        User u1 = [select id,email,Contactid,profileid,UserName,EmployeeNumber,isactive,Contact.Honeywell_ID__c from User where isactive=true and profileid=:label.Custom_Customer_Portal and Contact.Honeywell_ID__c like 'e%' limit 1];
        try
        {
          C1.Customer_Portal_UserId__c =u1.id;
          //c1.Honeywell_ID__c =u1.Contact.Honeywell_ID__c;
          upsert C1;
          //upsert A1;
        }
        catch(Exception e){}
        test.starttest();
        //system.runas(u1)
        //{
        Web_Portal_Contact_Citizenship__c vlt= new Web_Portal_Contact_Citizenship__c
        (   
            First_Name__c='venkat',
            Last_Name__c='vvvvvv',
            Email_Address__c='testinggg@testingplssss.com',
            Company_Name__c=A1.id,
            City_Name__c='bangalore',
            Web_Portal_Company_Name__c='nttdata',
            Job_Title__c='developer',
            Company_E_Mail_Address__c='rathinam.ayyappan@honeywell.com',
            Primary_Work_Number__c='7894561231',
            Alternate_Work_Number__c='9999999999',
            Fax_Number__c='GT456789',
            Market__c='Business Aviation',
            Phone_1_Ext__c='88143419',
            MobilePhone__c='9999999999',
            Company_Address__c='bangalore',
            State_Code__c='bangalore',
            Country_Name__c='india',
            Postal_Code__c='123456789',
            Name = 'test',
            Birth_city__c='India',
            Contact_Birth_Country__c = 'GDC',
            Contact_Citizenship_Country__c = 'High',
            Contact_Citizenship_Country2__c = 'Monitor',
            Passport_Number__c = 'H7777',
            Passport_Expiry_Date__c = system.today()+5,
            Visa_Number__c= 'T7777',
            Visa_Type__c='H1-B',
            Address_Line_1_c__c='basavnna Gudi',
            Address_Line_2__c='south end circle',
            Address_Line_3__c='bangalore',
            Visa_Expiry_Date__c = system.today()+3,
            createddate = system.today()+10,
            Is_US_Citizen__c = false        
        );
        try{
        insert vlt;
        }catch(DMLException e){}
    //Setup page for standard controller
    /*ApexPages.StandardController sc = new ApexPages.StandardController(vlt);
    //Test.startTest();  
    HwTrng_Enroll_Registration_cls controller = new HwTrng_Enroll_Registration_cls(sc);
    //Test.stopTest();
    controller.getLstcon();
    controller.makereq();
    controller.getoptions();
    controller.save11();*/
    
    
     Web_Portal_Contact_Citizenship__c vlt1= new Web_Portal_Contact_Citizenship__c
     (   
        First_Name__c=null ,
        Last_Name__c=null ,
        Email_Address__c='testinggg@testingplssss.com',
        Company_Name__c=A1.id,
        City_Name__c='bangalore',
        Web_Portal_Company_Name__c='nttdata',
        Job_Title__c='developer',
        Market__c='Business Aviation',
        Phone_1_Ext__c='88143419',
        MobilePhone__c='9999999999',
        Company_E_Mail_Address__c='rathinam.ayyappan@honeywell.com',
        Primary_Work_Number__c='7894561231',
        Alternate_Work_Number__c='9999999999',
        Fax_Number__c='GT456789',
        Company_Address__c=null ,
        State_Code__c=null ,
        Birth_city__c='India',
        Country_Name__c='',
        Postal_Code__c='',
        Name = 'test',
        Contact_Birth_Country__c = 'GDC',
        Contact_Citizenship_Country__c = 'High',
        Contact_Citizenship_Country2__c = 'Monitor',
        Passport_Number__c = 'H7777',
        Passport_Expiry_Date__c = system.today()+5,
        Visa_Number__c= 'T7777',
        Visa_Type__c='H1-B',
        Address_Line_1_c__c='basavnna Gudi',
        Address_Line_2__c='south end circle',
        Address_Line_3__c='bangalore',
        Visa_Expiry_Date__c = system.today()+3,
        createddate = system.today()-10,
        Is_US_Citizen__c = false   
                    
    );
    try{
    insert vlt1;
    }catch(DMLException e23){}
    //Setup page for standard controller
   /* ApexPages.StandardController sc1 = new ApexPages.StandardController(vlt1);  
    HwTrng_Enroll_Registration_cls controller11 = new HwTrng_Enroll_Registration_cls(sc1);
    controller11.getLstcon();
    controller11.makereq();
    controller11.getoptions();
    controller11.save11();
    controller.doCancel();
    //controller.MyMethod();*/
    
  
    //}
    test.stoptest();
    }
}