/*******************************************************************************************
 * Apex Class= CH_ME_Controller.apxc
 * This is a test class of the above apex class
 * Created By Gourisankar Patra on 28th March,2020
 * TestClass Coverage = 100%
 * Last Modified By Gourisankar Patra on 29th May,2020 to prevent duplicate lines
*******************************************************************************************/
@isTest(seeAlldata=false)
public class CH_ME_ControllerTest {
 @testSetup static void setup() {
//Create Support Ticket Record   
String userval=UserInfo.getUserId();
List<Case> caseList = new List<Case>();
caseList = CAPS_TestDataUtil.createCaseRecord(1);
insert caseList;
//Create Manage Escalation Record
CH_Manage_Escalation__c mevalue= new CH_Manage_Escalation__c();
mevalue.CH_EscalationSource__c='Business Impact Increased';
mevalue.CH_EscalationDomain__c='Care';
mevalue.CH_EscalationEntryCriteria__c ='Customer management escalation at Corporate Level to Nokia confirmed';
mevalue.CH_EscalationDescription__c='Test Description';
mevalue.CH_CustomerTone__c='Green';
mevalue.CH_LevelofEscalation__c='Level 1';
mevalue.CH_ImpactedOrganization__c='Fixed Networks';
mevalue.CH_EscalationRequester__c=userval;
mevalue.CH_EscalationManagerLevel1__c=userval;
mevalue.CH_CaseNumber__c=caseList[0].Id;
insert mevalue;
}
	
@isTest
	public static void MEControllerTestMethod1(){
		Test.startTest();
		// This is for ME Acceptance scenario
		CH_Manage_Escalation__c firstme1 =[Select id from CH_Manage_Escalation__c limit 1];
		CH_ME_Controller.acceptME(firstme1.id);
		CH_ME_Controller.transferMEFieldsQuery(firstme1.id);
		Test.stopTest();	 
 }
@isTest
	public static void MEControllerTestMethod2(){
		Test.startTest();
		// This is for ME Rejection scenario
		CH_Manage_Escalation__c firstme2 =[Select id,CH_RejectionCause__c from CH_Manage_Escalation__c limit 1];
		String rejectcause1='Rejected due to bad data';
		CH_ME_Controller.rejectME(firstme2.id,rejectcause1);
		Test.stopTest();
}
 @isTest
	public static void MEControllerTestMethod3(){
		Test.startTest();
		// This is for Exception Handling for null ME Record
		String a1=null;
		String b1=null;
		CH_ME_Controller.rejectME(a1,b1);
		CH_ME_Controller.acceptME(a1);
		Test.stopTest();
}
}