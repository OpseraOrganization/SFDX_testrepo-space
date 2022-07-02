/************************************************************************************************************
* Apex Class Name   : NokiaCPQShareProposalsWithOTM_Test.cls
* Version	 : 1.0 
* Created Date	  : 17 Sep 2017
* Function	: test class for NokiaCPQShareProposalsWithOTM
* Modification Log  :
* Developer	   Date		Description
* -----------------------------------------------------------------------------------------------------------
* Aditya Pareek	  17/09/2017	 Created Test Class for NokiaCPQShareProposalsWithOTM
*
************************************************************************************************************/
@isTest(SeeAllData=false)// we use seeAllData equals to true because of chatter api can't work
private class NokiaCPQShareProposalsWithOTM_Test{
	
	static testMethod void testMthod() {
		User sysAdminUser = TestDataFactory.createSystemAdminUser();   
		System.runAs(sysAdminUser){
			File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
			fscs.name= 'Opportunity_SalesPhase_FinalStage';
			fscs.Value__c = 'Completed';
			insert fscs;
			
			Account account = NF_TestDataFactory.createAccount('123');
			List<Account> accounts=new List<Account>();
			accounts.add(account);
			insert accounts;
			
			List<Opportunity> opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
			insert opportunities;
			Test.startTest();
		 Apttus_Proposal__Proposal__c proposal =new Apttus_Proposal__Proposal__c(
		 Apttus_Proposal__Account__c = accounts[0].Id,  
		 Apttus_Proposal__Opportunity__c = opportunities[0].Id,
		 NokiaCPQ_Portfolio__c  = 'IP Routing',
		 NokiaCPQ_No_of_Years__c	= '1',
		 NokiaCPQ_Maintenance_Type__c  = 'Gold (Return for Repair)',
		 //Offer__c = offer.id,   
		 Quote_Status__c='Price',
		 //Offer__c= offer.id,
		 Submitted_Date__c = System.today(),
		 RecordTypeId =Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId()//direct draft quote
		 );
		 insert proposal;
			Apttus_Proposal__Proposal__c proposal2 = proposal.clone();
		 insert proposal2;
			
			NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
			cs.Name = 'Default';
			cs.Customer_Account__c = 'Customer - test';
			cs.Customer_Account_Number__c = '12345';
			cs.Customer_User_Profile__c = 'Customers';
			insert cs;
			
			List<User> users = NF_TestDataFactory.getUsers(2,'System Administrator');
			users[0].Nokia_ID__c = '234567';
			users[1].Nokia_ID__c = '334567';
			insert users;
			
			List<Apttus_Approval__Approval_Request__c> approvalrequests = NF_TestDataFactory.getApprovalRequests(1,opportunities,users);
			insert approvalrequests;
			set<id> opportunityteammemberset = new set<id>();
			list<OpportunityTeamMember> opportunityteammembers = NF_TestDataFactory.getOpportunityTeamMember(2,opportunities,users);
			insert opportunityteammembers;
			
			NokiaCPQShareProposalsWithOTM.quoteProposalShare(opportunityteammemberset);
			Test.stopTest();
			NokiaCPQShareProposalsWithOTM.unshareProposalRecordAfterOTMTriggerDelete(null);
			
			delete opportunityteammembers;
			//for(OpportunityTeamMember obj : opportunityteammembers){
			//  opportunityteammemberset.add(obj.id);
			//}
			
			//
		}
	}
}