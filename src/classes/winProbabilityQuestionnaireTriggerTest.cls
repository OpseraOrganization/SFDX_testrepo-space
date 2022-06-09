/****************************************
 * Name : winProbabilityQuestionnaireTriggerTest 
 * Author : Accenture
 * Description : Test class for winProbabilityQuestionnaireTrigger, winProbabilityQuestionnaireHandler and winProbabilityQuestionnaireHelper
 *****************************************/
@istest
private class winProbabilityQuestionnaireTriggerTest {

	private static List<Account> accountList = new List<Account>();
	private static List<Opportunity> opportunityList = new List<Opportunity>();

	/***********************
	* Method Name: winProbabilityQuestionnaireMethodPositive
	* Description: Sales Process : winProbabilityQuestionnaireMethodPositive
	* Parameters: NA
	************************/ 
	static testMethod void winProbabilityQuestionnaireMethodPositive(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		System.runAs(userCreation){
			Test.startTest();
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);			
			database.insert(opportunityList);
			Questionnaire__c ques = new Questionnaire__c();
			ques.Opportunity__c = opportunityList[0].id;
			database.insert(ques);
			ques.Questionnaire_Label__c = 'Question';
			database.update(ques);
			database.delete(ques);
			Test.stopTest();
		}
	}
	
	/***********************
	* Method Name: winProbabilityQuestionnaireMethodNegative
	* Description: Sales Process : winProbabilityQuestionnaireMethodNegative
	* Parameters: NA
	************************ 
	static testMethod void winProbabilityQuestionnaireMethodNegative(){
		user userCreation = TestDataFactory.userCreation(1,'Nokia Sales Profile')[0];
		database.insert(userCreation);
		System.runAs(userCreation){
			Test.startTest();
			try{
				accountList = TestDataFactory.createAccount(1);
				database.insert(accountList);
				opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);
				opportunityList[0].StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
				opportunityList[0].Phase_Status__c = 'Planned';
			 //   opportunityList[0].Sales_Outcome__c = 'Obsolete';
				database.insert(opportunityList);
				Questionnaire__c ques = new Questionnaire__c();
				ques.Opportunity__c = opportunityList[0].id;
				database.insert(ques);
				ques.Questionnaire_Label__c = 'Question';
				database.update(ques);
				database.delete(ques);
			}catch(Exception e){
				Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false; 
				System.assertEquals(expectedExceptionThrown, true);
			}
			Test.stopTest();
		}
	}*/
	
	/***********************
	* Method Name: winProbabilityQuestionnaireMethodNegativeUpdate
	* Description: Sales Process : winProbabilityQuestionnaireMethodNegativeUpdate
	* Parameters: NA
	************************ 
	static testMethod void winProbabilityQuestionnaireMethodNegativeUpdate(){
		Questionnaire__c ques = new Questionnaire__c ();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		user userCreationOtherProfile = TestDataFactory.userCreation(1,'Global Process Admin Profile')[0];
		database.insert(userCreationOtherProfile );
		
		System.runAs(userCreation){
			
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);   
			opportunityList[0].StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			opportunityList[0].Phase_Status__c = 'Planned';
		 //   opportunityList[0].Sales_Outcome__c = 'Obsolete';
			database.insert(opportunityList);
		   
			ques.Opportunity__c = opportunityList[0].id;
			database.insert(ques);			
		}
			 
		System.runAs(userCreationOtherProfile ){
			try{
				ques.Questionnaire_Label__c = 'Question';
				database.update(ques);				
			}catch(Exception e){
				Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false; 
				System.assertEquals(expectedExceptionThrown, false);
			}
		}		
	}*/
	
	/***********************
	* Method Name: winProbabilityQuestionnaireMethodNegativeDelete
	* Description: Sales Process : winProbabilityQuestionnaireMethodNegativeDelete
	* Parameters: NA
	*********************** 
	static testMethod void winProbabilityQuestionnaireMethodNegativeDelete(){
		Questionnaire__c ques = new Questionnaire__c ();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		user userCreationOtherProfile = TestDataFactory.userCreation(1,'Global Process Admin Profile')[0];
		database.insert(userCreationOtherProfile );
		
		System.runAs(userCreation){
			
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);   
			opportunityList[0].StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			opportunityList[0].Phase_Status__c = 'Planned';
		   // opportunityList[0].Sales_Outcome__c = 'Obsolete';
			database.insert(opportunityList);
		   
			ques.Opportunity__c = opportunityList[0].id;
			database.insert(ques);			
		}
			 
		System.runAs(userCreationOtherProfile ){
			try{				
				database.delete(ques);
				system.debug(ques);
			}catch(Exception e){
				Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false; 
				System.assertEquals(expectedExceptionThrown, false);
			}
		}		
	}*/
	
}