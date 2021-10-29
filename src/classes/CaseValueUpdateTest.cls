/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class CaseValueUpdateTest 
{
   static testMethod void myUnitTest() 
    {
        TriggerInactive.testTrigger = false;
         Profile pf= [select id from Profile where name = 'System Administrator'];
         //Adding record type to case before 
                  User u2 =new User( Alias = 'newUser1' ,
                            Email ='newuser123@testorg.com',
                            EmailEncodingKey = 'UTF-8',
                            LastName = 'Testing',
                            LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', 
                            UserName='newuser1234@testorg.com',
                            ProfileId=pf.Id,
                            TimeZoneSidKey    = 'America/Los_Angeles');
         Id recrdtypid=[select id from recordtype where name='Repair & Overhaul' and sobjecttype='case' limit 1].Id;
         Account acc= new Account(name='Test Account');
         insert acc;
         //creating contact;
         Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
         Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E125675' );
         insert cont;
         Case cases=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', 
         Government_Compliance_SM_M_Content__c='No',//No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
         Type='Order',recordtypeid=recrdtypid);
         insert cases;
         System.runAs(u2) {
         test.startTest();
          
         cases.OwnerId=label.R_O_Basingstoke_Quotes_Queue_ID;
        // update cases;
          //cases.OwnerId=Label.D_S_PR_Quotes_Team;
        //update cases;
          cases.OwnerId=label.D_S_Clearing_House;
         update cases;
         // cases.OwnerId=Label.D_S_PR_Quotes_Team;
         //update cases;
         Test.stopTest();
         }
     }
}