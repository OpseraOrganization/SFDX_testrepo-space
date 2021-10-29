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
@isTest
private class AttachTranscriptToDescriptiontest {

  static testMethod void myUnitTest() 
  {
    Account acc= new Account(name='Test Account');
    insert acc;
  
   //creating contact;
   Contact cont=new Contact(firstname='Test',LastName='Contact',AccountId=acc.Id,Phone_3__c='9986502495',
   Contact_Is_Employee__c=true,  Contact_Status__c='Active', Employee_Contact_Role__c='Analyst',Employee_Number__c='E567567' );
   insert cont;
   //userid
   string userid = userinfo.getUserId();
    //creating case
    Case cases=new Case(AccountId=acc.Id,subject='Fax:{9986502495} test data',ContactId=cont.Id,Export_Compliance_Content_ITAR_EAR__c='No', Government_Compliance_SM_M_Content__c='No',
    //No_FCR_Reason__c='Not Trained',For Ticket INC000009687923
    Type='Order', ownerid = userid);
    insert cases;
 
    LiveChatVisitor livechatvis= new LiveChatVisitor ();
    insert livechatvis;
   
    LiveChatTranscript lt= new LiveChatTranscript();
    lt.LiveChatVisitorId=livechatvis.id;
    lt.CaseId=cases.id;
    lt.Body='Chat Started: Tuesday, September 24, 2013, 08:18:00 (+0000)Chat Origin: GDC ChatAgent Martin W( 5s ) Martin W: Welcome to the GDC.( 6s ) Emanuel: Need help on "Hello im looking for training for FMS 6.1"';
    insert lt;
  }
}