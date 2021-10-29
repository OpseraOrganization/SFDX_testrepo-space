/********************************************************************************************************************
Name         :TestClass_AircraftBaseUpdateValue 
Created By   :Mythreyee Sureshkumar 
company Name :Honeywell
Project      :Aero sales
created Date :4/24/2013 7:01 AM
Usages       :This Test class will update the value of Aircraftbase

Modification History:
Date           Version no.      Modified By          Brief Descricption 
 2/28/2017     1.1              Haritha Lekkala      we have changed Platform field name instead fleet Asset Aircraft 
 *********************************************************************************************************************/
@isTest
private class TestClass_AircraftBaseUpdateValue {

    static testMethod void TestMthd_AircraftBase_UpdateValue() 
    {
        Aircraft_Base__c airbas1 = new Aircraft_Base__c(Name = 'Test Flight1',Base_ICAO__c = '1AAAAA');
        insert airbas1;
        Platform__c pltFrm = new Platform__c(name='Test Platform');
        insert pltFrm;
            
        Fleet_Asset_Detail__c fltast = new Fleet_Asset_Detail__c(Name = 'Test Fleet Asset', Aircraft_Base__c = airbas1.id, Tail_Number__c = '5555',Serial_Number__c = '6666',Platform_Name__c = pltFrm.id);
        insert fltast;
        
        Account acc = new Account();
        acc.Name = 'Hon test';
        acc.Customer_Status__c = 'Active';
        acc.Strategic_Business_Unit__c = 'D&S';
        acc.CBT__c = 'DAA';
        acc.Region_Name__c = 'Americas';
        acc.Sub_Region_Name__c = 'Canada';
        acc.Service_Level__c = 'Standard';
        acc.Type = 'OEM';
        acc.REPORT_ACCOUNT_NAME__c = 'HON TEST1';        
        insert acc; 
        
        Contact con = new Contact();
        con.LastName = 'Latha';
        con.FirstName = 'Priya';
        con.AccountId = acc.Id;
        con.Primary_Email_Address__c = 'sindhuja11.velmurugan@nttdata.com';
        con.Email='sindhuja@nttdata.com';
        insert con;
        
        Map<String,ID> profiles = new Map<String,ID>();
        List<Profile> ps = [select id, name from Profile where name ='Standard User' or name = 'System Administrator'];
        
        for(Profile p : ps){
         profiles.put(p.name, p.id);
        }
       
      User standard = new User(alias = 'standt', 
      email='standarduser@testorg.com', 
      emailencodingkey='UTF-8', 
      lastname='Testing', languagelocalekey='en_US', 
      localesidkey='en_US', 
      profileid = profiles.get('Standard User'), 
      timezonesidkey='America/Los_Angeles', 
      username='sample1user@test.com', EMPLOYEENUMBER ='E085790');

      insert standard;
        
        
        Case objcase1 = new Case();        
        objcase1.Aircraft_Name__c = fltast.id;
        objcase1.Status = 'Open';
        objcase1.Due_Date__c = system.today();
        //Objcase1.No_FCR_Reason__c = 'Research'; For Ticket INC000009687923
        insert objcase1;
        
        airbas1.Base_ICAO__c = '1BBBBB';
        update airbas1;
        
    }
}