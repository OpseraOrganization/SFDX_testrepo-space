/****************************************
* Name : NF_User_Helper_Test
* Author : Accenture Nov-2018
* Description : Test class for NF_User_Helper
*****************************************/


@isTest
public class NF_User_Helper_Test {
 
	static testmethod void create(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		user userCreation1= TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation1;
		system.runas(userCreation1){
		userCreation.IsActive=true;
	  userCreation.Admin_Notes__c='Admin';
		insert userCreation;
		Sales_Role__c Sales_role;
		Sales_Role = NF_TestDataFactory.createSalesRole(userCreation,'NSNB_BGCM','Customer Operations','3 - BG Trial Demo Validator');
	insert Sales_Role ;
		test.startTest();
		userCreation.IsActive=false;
		update userCreation;
		system.enqueueJob(new NF_User_Helper(null));
		test.stoptest();
		}
	}
	
   // static testmethod void test(){
	  //  Id userid=[Select Id from User where userCreation.id]
   // }  
}