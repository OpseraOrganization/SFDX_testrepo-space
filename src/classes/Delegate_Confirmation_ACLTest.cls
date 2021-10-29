/** 
* File Name: Delegate_Confirmation_ACLTest
* Description: Test Method
* Test Method for  Delegate_Confirmation_ACL
* Copyright : Wipro Technologies Limited Copyright (c) 2010 * 
* @author : Wipro
* Modification Log 
* =============================================================== 
* Ver   Date        Author      Modification 
* --- ---- ------ ------------- ---------------------------------
* 1.0  Wipro  Created 
*/ 
@isTest
public class Delegate_Confirmation_ACLTest{
 //Test method for Delegate_Confirmation_ACL
  static testMethod void testDelegate_Confirmation_ACL()
  {
  Date date1 =Date.newInstance(2009,08,12);
Profile pf= [select id from Profile where name = 'System Administrator'];


User usr = new User(FirstName = 'Test', LastName = 'UserEgreen',Username = 'tu1egreen1@test.com',Email = 'testuser@test.com',
Alias = 'tu11' ,CommunityNickname= 'tu1cso1' ,TimeZoneSidKey = 'America/Los_Angeles',
LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert usr;
system.debug('ccccccc'+usr.id);

User usr1 = new User(FirstName = 'Test', LastName = 'UserEgreen1',Username = 'tu11egreen1@test.com',Email = 'testuser@test.com',
Alias = 'tu111' ,CommunityNickname= 'tu1cso2' ,TimeZoneSidKey = 'America/Los_Angeles',
LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert usr1;

User usr2 = new User(FirstName = 'Test', LastName = 'UserEgreen2',Username = 'tu11egreen2@test.com',Email = 'testuser@test.com',
Alias = 'tu111' ,CommunityNickname= 'tu1cso3' ,TimeZoneSidKey = 'America/Los_Angeles',
LocaleSidKey='en_US',EmailEncodingKey= 'ISO-8859-1',ProfileId = pf.Id, LanguageLocaleKey = 'en_US',SBU_User__c = 'D&S');
insert usr2;

list<Approver__c> applst= new list<Approver__c>();


  Approver__c app1 = new Approver__c(Approver_Name__c=usr.Id,Terms_and_Conditions__c='Standard'
  ); 
  insert app1;
  
  Approver__c app2 = new Approver__c( Approver_Name__c=usr1.Id, Terms_and_Conditions__c='Standard', Out_of_Office__c = True, 
  Delegate_Name_dummy__c=app1.id, From__c = System.today(), To__c = System.today()+1,
  Delegate_Name1__c=app1.Id, Delegation_Valid_From1__c = System.today()+2, Delegation_Valid_To1__c = System.today()+3,
  Delegate_Name2__c=app1.Id, Delegation_Valid_From2__c = System.today()+4, Delegation_Valid_To2__c = System.today()+5,
  Delegate_Name3__c=app1.Id, Delegation_Valid_From3__c = System.today()+6, Delegation_Valid_To3__c = System.today()+7,
  Delegate_Name4__c=app1.Id, Delegation_Valid_From4__c = System.today()+8, Delegation_Valid_To4__c = System.today()+9
  ); 
  insert app2;

  Approver__c app3 = new Approver__c(Approver_Name__c=usr2.Id,Terms_and_Conditions__c='Standard', Out_of_office__c = True,
  Delegate_Name_dummy__c=app1.id, From__c = System.today()
  );

  insert app3;
  
  test.starttest();
   
    
   ApexPages.StandardController con1 = new ApexPages.StandardController(app1);
   System.currentPagereference().getParameters().put('id',app1.Id);
   Delegate_Confirmation_ACL wrkDetails1 = new Delegate_Confirmation_ACL(con1);
   Delegate_Confirmation_ACL.MyInnerClass c1 = new Delegate_Confirmation_ACL.MyInnerClass();
   wrkDetails1.Confirm();
   
   ApexPages.StandardController con2 = new ApexPages.StandardController(app2);
   System.currentPagereference().getParameters().put('id',app2.Id);
   Delegate_Confirmation_ACL wrkDetails2 = new Delegate_Confirmation_ACL(con2);
   wrkDetails2.getAPPlist1();
   wrkDetails2.setAPPlist1(app2);
   wrkDetails2.Confirm();
   wrkDetails2.Submit();
   wrkDetails2.Cancel(); 

   ApexPages.StandardController con3 = new ApexPages.StandardController(app3);
   System.currentPagereference().getParameters().put('id',app3.Id);
   Delegate_Confirmation_ACL wrkDetails3 = new Delegate_Confirmation_ACL(con3);
   wrkDetails3.getAPPlist1();
   wrkDetails3.setAPPlist1(app3);
   wrkDetails3.Confirm();


     
  test.stoptest();
 }
}