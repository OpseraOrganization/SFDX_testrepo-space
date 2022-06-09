/***************************************
* Name : CRM_CompetitiveAnalysis_listViewTest
* Author : CRM Dev
* Description : Test class for CRM_CompetitiveAnalysis_listViewCtrl
*****************************************/
@istest
public class CRM_OppContactRoles_listViewTest
{
	@testSetup
	static void datasetup()
	{
		Account acc = TestDataFactory.createAccount(1)[0];
		acc.AccountNumber = '1234';
		insert acc;

		Opportunity opp = TestDataFactory.OpportunityCreation(1, acc)[0];
		opp.Name = 'test wp';
		insert opp;

		Contact contact = TestDataFactory.createContact2(1, acc)[0];
		contact.FirstName = 'test wp';
		insert contact;

		OpportunityContactRole oppConRole = new OpportunityContactRole();
		oppConRole.Role = 'Influencer';
		oppConRole.ContactId = contact.Id;
		oppConRole.OpportunityId = opp.Id;
		insert oppConRole;

		Task task = TestDataFactory.TaskCreation(1)[0];
		task.Subject = 'WP - test wp';
		insert task;
	}

	static testmethod void test1()
	{
		Contact con = [SELECT Id FROM Contact WHERE FirstName = 'test wp'];
		Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'test wp'];
		Task task = [SELECT Id, Subject, OwnerId, Owner.Name, Status, ActivityDate, Description, Priority, IsReminderSet, ReminderDateTime, whoid, whatid  FROM Task WHERE Subject = 'WP - test wp'];
		CRM_OppContactRoles_listViewController.WrapperFull wrapper = CRM_OppContactRoles_listViewController.getOppContactRolesApex(opp.Id);
		CRM_OppContactRoles_listViewController.WrapperOppContactRole contactRoleWrapper = wrapper.contactRoleWrapperList[0];
		CRM_OppContactRoles_listViewController.getContactDetailsApex(con.Id);
		CRM_OppContactRoles_listViewController.saveContactRoleApex(contactRoleWrapper);
		CRM_OppContactRoles_listViewController.deleteContactRoleApex(contactRoleWrapper);
		CRM_OppContactRoles_listViewController.updateCreateTaskApex(task);
		CRM_OppContactRoles_listViewController.deleteActivityApex(task);
	}
}