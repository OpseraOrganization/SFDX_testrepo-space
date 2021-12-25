/****************************************
 * Name : CampaignTriggerTest 
 * Author : Accenture
 * Description : Test class for CampaignTrigger, CampaignHandler and CampaignHelper
 *****************************************/
@istest
private class CampaignTriggerTest {
	
	public static List<Account> accountList = new List<Account>();
	public static List<campaign> campaignList= new List<campaign>();
	public static List<Opportunity> opportunityList = new List<Opportunity>();

	/***********************
	* Method Name: retrictCampaign
	* Description: Sales Process : campaignCreationTest
	* Parameters: NA
	************************/ 
	static testMethod void campaignCreationTest(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		System.runAs(userCreation){
			List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);
			database.insert(opportunityList); 
			campaignList = TestDataFactory.createCampaign(1,opportunityList[0]);
			database.insert(campaignList);
			campaignList[0].name = 'UpdateName';
			database.update(campaignList);
			database.delete(campaignList);
		}
	}
	
	/***********************
	* Method Name: competitorMethodNegative
	* Description: Sales Process : competitorMethodNegative
	* Parameters: NA
	************************/ 
	static testMethod void competitorMethodNegative(){
		Competitor__c comp = new Competitor__c();
		user userCreation = TestDataFactory.userCreation(1,'Nokia Sales Profile')[0];
		database.insert(userCreation);
		System.runAs(userCreation){
			List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			Test.startTest();
			try{
				accountList = TestDataFactory.createAccount(1);
				database.insert(accountList);
				opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);
				opportunityList[0].StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
				opportunityList[0].Phase_Status__c = 'Planned';
				opportunityList[0].Sales_Outcome__c = 'Obsolete';
				database.insert(opportunityList);
				campaignList = TestDataFactory.createCampaign(1,opportunityList[0]);
				database.insert(campaignList);
				campaignList[0].name = 'UpdateName';
				database.update(campaignList);
				database.delete(campaignList);
			}catch(Exception e){
				Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false; 
				System.assertEquals(expectedExceptionThrown, true);
			}
			Test.stopTest();
		}
	}
	
	/***********************
	* Method Name: competitorMethodMethodNegativeUpdate
	* Description: Sales Process : competitorMethodMethodNegativeUpdate
	* Parameters: NA
	************************ 
	static testMethod void competitorMethodMethodNegativeUpdate(){
		Competitor__c comp = new Competitor__c();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		user userCreationOtherProfile = TestDataFactory.userCreation(1,'Global Process Admin Profile')[0];
		database.insert(userCreationOtherProfile );
		
		System.runAs(userCreation){
			
			accountList = TestDataFactory.createAccount(2);
			database.insert(accountList);
			opportunityList = TestDataFactory.OpportunityCreation(1,accountList[0]);   
			opportunityList[0].StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			opportunityList[0].Phase_Status__c = 'Planned';
		  //  opportunityList[0].Sales_Outcome__c = 'Obsolete';
			database.insert(opportunityList);
		   
			campaignList = TestDataFactory.createCampaign(1,opportunityList[0]);
			database.insert(campaignList);					   
		}
			 
		System.runAs(userCreationOtherProfile ){
			try{
				campaignList[0].name = 'UpdateName';
				database.update(campaignList);					 
			}catch(Exception e){
				Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false; 
				System.assertEquals(expectedExceptionThrown, true);
			}
		}		
	}
	
	/***********************
	* Method Name: competitorMethodNegativeDelete
	* Description: Sales Process : competitorMethodNegativeDelete
	* Parameters: NA
	************************
	static testMethod void competitorMethodNegativeDelete(){
		Competitor__c comp = new Competitor__c();
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
			opportunityList[0].Sales_Outcome__c = 'Obsolete';
			database.insert(opportunityList);
		   
			campaignList = TestDataFactory.createCampaign(1,opportunityList[0]);
			database.insert(campaignList);
			
									
		}
			 
		System.runAs(userCreationOtherProfile ){
			try{				
			   database.delete(campaignList);				 
			}catch(Exception e){
				Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false; 
				System.assertEquals(expectedExceptionThrown, true);
			}
		}		
	}*/
}