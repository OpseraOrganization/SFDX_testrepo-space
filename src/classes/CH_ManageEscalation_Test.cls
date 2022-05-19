@isTest
public class CH_ManageEscalation_Test {

	@testsetup
	static void testDataSetup() {
		String userval=UserInfo.getUserId();
		CH_Manage_Escalation__c medetails= new CH_Manage_Escalation__c();		
		medetails.CH_EscalationSource__c='Other';
		medetails.CH_EscalationDomain__c='Care';
		medetails.CH_EscalationEntryCriteria__c ='Customer management escalation at Corporate Level to Nokia confirmed';
		medetails.CH_EscalationDescription__c='Test Description';
		medetails.CH_CustomerTone__c='Red';
		medetails.CH_LevelofEscalation__c='Level 1';
		medetails.CH_ImpactedOrganization__c='Fixed Networks';
		medetails.CH_EscalationRequester__c=userval;
		medetails.CH_EscalationManagerLevel1__c=userval;		
		insert medetails;
	}
	
	@isTest
	public static void meTest(){
		Test.startTest();
		CH_Manage_Escalation__c getME= [Select Id from CH_Manage_Escalation__c LIMIT 1];
		getME.CH_EscalationStatus__c ='In-Progress';
		update getME;
		try
	  	{
	  	string errormsg= CH_ManageEscalation.closeME(getME.Id);
	  	}
		catch(Exception e){
		 //*No statement is required*//
		}
		Test.stopTest();				
	}
	
}