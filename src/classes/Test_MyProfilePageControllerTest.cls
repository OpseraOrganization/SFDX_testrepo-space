@isTest(SeeAllData=false)
private class Test_MyProfilePageControllerTest
{
    //public string radiovalue{get;set;}
    //public boolean requiredval{get;set;}
    static testMethod void Test_MyProfilePageController() {
       test.starttest();
        //ID ProfileID = [ Select id from Profile where name = 'Training - Customer Portal'].id;
        Account A1 = new Account(Name = 'Test Account');
        insert A1;
        
        List<Contact> ContactList = new List<Contact>();
        Contact C1 = new Contact( AccountID = A1.id, FirstName = 'Test', LastName = 'User',Honeywell_ID__c='E801543', 
        email = 'test-user@fakeemail.com' );
        insert C1;
 
        User u1 = new User( email='test-user@fakeemail.com', contactid = c1.id, profileid = label.Custom_Customer_Portal, 
                UserName='test-user@fakeemail.com', alias='tuser1', CommunityNickName='tuser1', 
        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', 
        LanguageLocaleKey='en_US', FirstName = 'Test', LastName = 'User' );
        insert u1; 
         Web_Portal_Contact_Citizenship__c vlt= new Web_Portal_Contact_Citizenship__c
        (   
            First_Name__c='venkat',
            Last_Name__c='vvvvvv',
            Email_Address__c='testinggg@testingplssss.com',
            Company_Name__c=A1.id,
            City_Name__c='bangalore',
            Web_Portal_Company_Name__c='nttdata',
            Job_Title__c='developer',
            Company_E_Mail_Address__c='testinggg@testingplss.com',
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
          C1.Customer_Portal_UserId__c =u1.id;
          upsert C1;
        }
         catch(Exception e){}
        system.runas(u1)
        {
            MyProfilePageController  controller = new MyProfilePageController();            
            controller.getUser();           
            controller.getcon();
            controller.edit(); 
            controller.save(); 
            controller.cancel(); 
            controller.changePassword();
            controller.Updateopp(u1); 
            controller.getIsEdit();
            controller.getopp();        
        }
        test.stoptest();
    }
}