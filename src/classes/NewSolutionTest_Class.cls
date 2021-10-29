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
private class NewSolutionTest_Class {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
  Profile pf1= [select id from Profile where name = 'System Administrator'];
  User usr = new User(LastName = 'Test UserSol1',Username = 'tu1cso@test.com',
  Email = 'testuser@test.com',Alias = 'tu1' ,CommunityNickname= 'tu1sol1' ,
  TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
  ProfileId = pf1.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
  insert usr;
        
      Solution sol= new solution(SolutionName ='test',Categorization__c ='DataBase',Export_Controlled__c='yes',
      FAQ__c='test',Product_Type__c='Services',Catalog_Product_Group__c='Displays(BK)',
      Supported_Product__c='Displays',Secure_Notes__c='testing',
      Export_Review_Date__c=System.today(),
 Export_Review_By__c=usr.Id);
        insert sol;
        
        
         ApexPages.StandardController solCtrl = new ApexPages.Standardcontroller(sol);
         
         NewSolution newsln = new NewSolution(solCtrl); 
         newsln.docontin();
         newsln.docancel();
         newsln.getvalues();
    }
}