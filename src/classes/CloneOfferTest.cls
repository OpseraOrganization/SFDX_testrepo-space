@istest
private with sharing class CloneOfferTest
{
	private static List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
	private static List<cloneObject__c> cloneObjectCustomSettingList = new List<cloneObject__c>();
	private static List<Offer_Team__c> offerTeamList= new List<Offer_Team__c>();
	private static Offer__c offerCreation;
	static testMethod void CloneOfferTest_True()
	{
		try{
		
		List<user> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
			system.runas(userCreation[0]){
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		cloneObjectCustomSettingList = TestDataFactory.cloneObjectCustom_Setting();
		database.insert(cloneObjectCustomSettingList);
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		insert accountCreation;
		Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
		optyCreation.Probability = 22;
		optyCreation.Sales_Outcome__c='Obsolete';
		optyCreation.Sales_Outcome_Reason__c = 'Commercial';
		insert optyCreation;
		offerCreation = TestDataFactory.OfferCreation(1,optyCreation)[0];
		insert offerCreation;
			}
		system.runAs(userCreation[1]){
			test.startTest();
		offerTeamList = TestDataFactory.offerTeamCreation(1, offerCreation ,userCreation[1]);
		database.insert(offerTeamList);
			CloneOffer.getCloneOffer(offerCreation.id);
			 CloneOffer.cloneOfferTeam(null,offerCreation.id);
			test.stopTest();
		}
		}
		Catch(Exception ex){
			system.debug('Exception :: '  +  ex);
		}		
	}
	  static testMethod void CloneOfferTest_False()
	{
		Try{
			CloneOffer.getCloneOffer(null);
			CloneOffer.cloneOfferTeam(null,null);
		} Catch(Exception ex){
			system.debug('Exception :: '  +  ex);
		}  
		  
	}
}