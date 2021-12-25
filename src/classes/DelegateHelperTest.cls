/****************************************
 * Class Name : DelegateHelper
 * Created Date: 9th Sep 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 
 * Description :  Test Class for DelegateHandelr and HelperClass
 * Test Class: 
 *****************************************/
 


@isTest
Private class DelegateHelperTest {
	 static testMethod void UserNSACheck()
	{
	   Test.startTest();
	   List<user> userList = new List<User>();
	   userList = TestDataFactory.userCreation(3, 'System Administrator');
	   userList[1].NSA_Compliant__c = true;   
	   userList[0].NSA_Compliant__c=False;
	   database.insert(userList);
	   system.runAs(userList[2])
	   {   
		List<Apttus_Approval__Backup_Approver__c> approvalRecList = new List<Apttus_Approval__Backup_Approver__c>();
		Apttus_Approval__Backup_Approver__c approvalRec = new Apttus_Approval__Backup_Approver__c();
		Apttus_Approval__Backup_Approver__c approvalRec1 = new Apttus_Approval__Backup_Approver__c();

		Map<ID,Apttus_Approval__Backup_Approver__c> delmap= new Map<ID,Apttus_Approval__Backup_Approver__c>();
		System.debug('Id**********'+userList[1].id);
	  
		approvalRec.Apttus_Approval__Current_User__c = userList[1].id;
		approvalRec.Apttus_Approval__Comment__c = 'Test Comments'; 
		approvalRec.Apttus_Approval__InEffect__c=True;
		approvalRec.Apttus_Approval__IsActive__c=True;
		   
		approvalRec.Apttus_Approval__IsDelegate__c=true;
		approvalRec.Apttus_Approval__DelegateUserIds__c= userList[0].id+','+ userList[1].id;
		approvalRec.Delegate_Approver1__c = userList[0].id;
		approvalRecList.add(approvalRec); 
		// 2nd record inserting
		approvalRec1.Apttus_Approval__Current_User__c = userList[1].id;
		approvalRec1.Apttus_Approval__Comment__c = 'Test Comments'; 
		//approvalRec.Apttus_Approval__InEffect__c=True;
		   
		approvalRec1.Apttus_Approval__IsDelegate__c=false;
		approvalRec1.Apttus_Approval__DelegateUserIds__c= userList[0].id;
		approvalRec1.Delegate_Approver1__c = userList[0].id;
		   
		approvalRecList.add(approvalRec1);		   
		database.insert(approvalRecList,false);
		delmap.put(approvalRec.id,approvalRec); 
		DelegateHelper.UserNSACheck(approvalRecList);
		DelegateHelper.DelegateUpdate(approvalRecList);
		DelegateHandler.ApproverRec=approvalRecList;
		DelegateHandler.BeforeInsert(approvalRecList);
		DelegateHandler.BeforeUpdate(approvalRecList,delmap);
		DelegateHandler.BeforeInsert(Null);
		DelegateHandler.BeforeUpdate(Null,Null);
		DelegateHelper.UserNSACheck(null);
		 DelegateHelper.DelegateUpdate(null);

		Test.stoptest();   
		} 
	}
}