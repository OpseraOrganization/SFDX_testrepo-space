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
private class UpdateManagernRoleTrigger {

    static testMethod void myUnitTest() {
        
        UserRole role = [select Id, Name from UserRole where name = 'ALT' limit 1];
        
  		Profile profile = [select id from Profile where name = 'System Administrator'];
  		User manager = new User(LastName = 'Test Task Manager and Role',Username = 'testtaskmanagerandrole@test.com',
  							Email = 'testmanager@test.com',Alias = 'tm1' ,CommunityNickname= 'tmanager' ,
  							TimeZoneSidKey = 'America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',
  							ProfileId = profile.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
  		insert manager;
  		
  		Task task = new Task();
  		task.OwnerId = manager.Id;
  		task.Priority = 'Normal';
  		task.Status = 'Open';
  		task.Assigned_Manager__c = manager.Id;
  		task.Assigned_Role__c = role.Id;
  		
  		insert task;
        
    }
}