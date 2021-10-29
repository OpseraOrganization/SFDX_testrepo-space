@isTest(SeeAllData=true)
private class TestClass_RandOCaseFieldUpdates
{
    public static testMethod void RandOEmailNotification()
    {            
       
        Account objAccnt = new Account();
        objAccnt.Name = 'Honeywell Test';
        objAccnt.Customer_Status__c = 'Active';
        objAccnt.Strategic_Business_Unit__c = 'D&S';
        objAccnt.CBT__c = 'DAA';
        objAccnt.Region_Name__c = 'Americas';
        objAccnt.Sub_Region_Name__c = 'Canada';
        objAccnt.Service_Level__c = 'Standard';
        objAccnt.Type = 'OEM';
        objAccnt.REPORT_ACCOUNT_NAME__c = 'HONEYWELL TEST';        
        insert objAccnt;
        
        Contact objContact = new Contact();
        objContact.LastName = 'Nannapaneni';
        objContact.FirstName = 'Siva';
        objContact.AccountId = objAccnt.Id;
        objContact.Primary_Email_Address__c = 'Siva.nannapaneni@honeywell.com';
        objContact.Email='Siva.nannapaneni@honeywell.com';  
        objContact.Employee_Number__c = 'E123123';      
        insert objContact;
        
     
        
        Case objInsrtCase1 = new Case();
        objInsrtCase1.Origin = 'Email-R&O MechComponents';
        objInsrtCase1.Status = 'Open';
        objInsrtCase1.ContactId = objContact.Id;
        objInsrtCase1.case_origin_email__C = 'Shiva.nannapaneni@yahoo.com';
        objInsrtCase1.Mail_Box_Name__c = 'Email-R&O MechComponents';
        insert objInsrtCase1;
    }
}