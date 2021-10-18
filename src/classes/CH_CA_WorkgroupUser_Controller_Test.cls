/**********************************************************************************************************************
* Class Name :  CH_CA_WorkgroupUserController
* Created Date: 06-05-2019
* Created By :  TCS
* Description : This class is test class for  CH_CA_WorkgroupUser_Controller		
* Class:		CH_CA_WorkgroupUser_Controller
***********************************************************************************************************************/

@isTest
public class CH_CA_WorkgroupUser_Controller_Test {
	 
	@testSetup
	public static void setup(){
		CH_UTIL_TEST.setupCase(false); 
	}
		
	 //This method is used to test current logged in user
	@isTest
	static void testfetchCurrentUser(){
		User currentUser = new User();
		Test.startTest();
		currentUser = CH_CA_WorkgroupUserController.fetchCurrentUser();
		User expected = [Select Id,Name FROM User Where id =: userInfo.getUserId()];
		System.assertEquals(string.valueOf(expected), string.valueOf(currentUser));
		Test.stopTest(); 
	}
	 
	@isTest
	static void testsearchWorkgroupByUserSetupData(){
		Test.startTest();
		CH_ManageCreateQueueAsynchQueue.doChainJob= false;
		CH_ManagePSAndQueueToWGMemberAsynchQueue.doChainJob = false;		
		
		User chUser = [SELECT Id, Alias FROM User WHERE Alias in ('TSTP1','TSTNP1') Limit 1];
		CH_UTIL_TEST.createWorkgroupSchedules();
		CH_CA_WorkgroupUserController.searchWorkgroupByUser(chUser.Id);
		
		Test.stopTest();  
	}
}