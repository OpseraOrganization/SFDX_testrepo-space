@isTest(SeeAllData=false)
private class Testcls_Apextrgr_webtooladditional{
    static testMethod void Testcls_Apextrgr_webtooladditional(){ 
    test.starttest();
      // ID ProfileID = [ Select id from Profile where name = 'Training - Customer Portal'].id;
        Account A1 = new Account(Name = 'Test Account');
        insert A1;
        Account A2 = new Account(Name = 'Test Account');
        insert A2;
        List<Contact> ContactList = new List<Contact>();
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User',Honeywell_ID__c='E801543', 
        email = 'test-user@fakeemail.com' );
        insert C1;
 
        User u1 = new User( email='rathinam.ayyappan@honeywell.com', contactid = c1.id, profileid = label.Custom_Customer_Portal, 
                UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User',employeenumber='E407308' );
        insert u1;          
        try
        {
          C1.Customer_Portal_UserId__c =u1.id;
          upsert C1;
        }
        catch(Exception e){}
        system.runas(u1)
        {
       Web_Portal_Contact_Citizenship__c vlt= new Web_Portal_Contact_Citizenship__c
       (   
        First_Name__c='venkat',
        Last_Name__c='vvvvvv',
        Email_Address__c='rathinam.ayyappan@honeywell.com',
        Company_Name__c=A2.id,
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
        createddate = system.today()-10,
        Is_US_Citizen__c = false        
       );
       try
       {
            update(vlt);
            u1.firstname = 'venkat';
            u1.lastname='test';
            u1.email='mythreyee.sureshkumar@honeywell.com';                        
            u1.title = 'developer';                               
            u1.phone = '1234567891';
            u1.Extension ='88143419'; 
            u1.MobilePhone = '9999999999'; 
            u1.fax ='FAX123'; 
            u1.postalcode = '999999'; 
            u1.city = 'bangalore';
            u1.state = 'karnatka';              
            u1.country = 'india';
            //upsert(u1);
            
       } 
       catch(exception e){}             
      }    
      test.stoptest();         
    }
}