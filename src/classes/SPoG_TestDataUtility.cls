/*************************************************
* @Description: Utility Class to create all test data, 
* which will be used in Apex Test Code for SPoG Classes
* **********************************************/
@isTest(seeAllData = false)
public with Sharing class SPoG_TestDataUtility {
    
    /*******************************************
* @Description: Method to create test account
* ****************************************/
    
    public   Account createTestAccount() {
        Account acc = new Account(); 
       /* Id RecordTypeId = [SELECT id FROM RecordType WHERE DeveloperName =  'OEM'
                           AND sObjectType ='Account' LIMIT 1].id; */
        //acc.RecordTypeId = RecordTypeId ; 
        acc.Name = 'Test Account';
        acc.AccountNumber = '70184';
        acc.Type  = 'Customer';
        acc.CurrencyIsoCode ='EUR';
        //acc.SBU__c= 'Retail';
        acc.BillingCity='London';
        acc.BillingStreet='Brike lane';
        acc.BillingCountry='United Kingdom';
        // acc.BillingState='London';
        acc.Phone='999 245 6612';
        // acc.Subtype__c='Distributor';
        //acc.SBE__c = 'Specialty Products';
        //acc.Sales_Organization__c = '3400';
        //acc.Distribution_Channel__c = '35'; 
		acc.Customer_Status__c = 'Active';
		acc.SAP_Sold_To__c = '324567';        
        INSERT acc ;
        
        
        return acc ; 
    }
    /********************************************
* @Description: Test method to create contact
* ******************************************/
    public  Contact createContact(Id accountId) {
        Contact objContact = new Contact(); 
        Id recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Honeywell_Employee'
                           AND sObjectType = 'Contact' LIMIT 1].Id; 
        objContact.LastName = 'Test Contact';
        objContact.Email = 'test@test.com';
        objContact.MailingCity = 'Test'; 
        objContact.MailingStreet = 'Test'; 
        // objContact.MailingState = 'FL';
        objContact.MailingCountry = 'United Kingdom';
        objContact.MailingPostalCode = '560103'; 
        objContact.RecordTypeId = recordTypeId ; 
        objContact.Accountid = accountId;
        INSERT objContact ; 
        return objContact ; 
    }
    
    /**********************************************
* @Description: Test method to create case
* *******************************************/
    public Case createCase(Id accountId, Id contactId) {
        Case objCase = new Case(); 
        
        Id recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Orders'
                           AND sObjectType = 'Case' LIMIT 1].Id; 
        
        objCase.Subject = 'Test Case'; 
        objCase.Status = 'Open';
        objCase.Description = 'Test Case'; 
        objCase.AccountId = accountId ; 
        objCase.ContactId = contactId ; 
        objCase.RecordTypeId = recordTypeId ; 
        objCase.OwnerId = UserInfo.getUserId() ; 
        INSERT objCase ; 
        return objCase ; 
    }
    
    
}