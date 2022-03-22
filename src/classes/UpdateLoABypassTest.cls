/****************************************
 * Name : UpdateLoABypassTest
 * Author : Accenture
 * Description : Test class for UpdateLoABypass
 *****************************************/
@isTest
public class UpdateLoABypassTest {
	/******************************
	*Method Name: UpdateLoABypassExecuteTest
	*Description: Test Method to cover Execute method of UpdateLoABypass
	********************************/
	@isTest
	static void UpdateLoABypassExecuteTest(){
	  
		List<Offer__C> offerList = new List<Offer__c>();
		
		Account accObj = new Account();
		accObj = TestDataFactory.createAccount(1)[0];
		database.insert(accObj);
		
		Opportunity oppObj = new Opportunity();
		oppObj = TestDataFactory.OpportunityCreation(1, accObj)[0];
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		database.insert(oppObj);
		
		Opportunity oppObj1 = new Opportunity();
		oppObj1 = TestDataFactory.OpportunityCreation(1, accObj)[0];
		oppObj1.Migration_Source__c='fNOK';
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList1 = new List<File_Sharing_Custom_Setting__c>();
		fileSharingCustomSettingList1 = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList1);
		//database.insert(oppObj1);
		
		Offer__c offObj = new Offer__c();
		offObj = TestDataFactory.OfferCreation(1, oppObj)[0]; 
		offObj.No_LoA__c = true;
		offerList.add(offObj);
		
		Offer__c offObj1 = new Offer__c();
		offObj1 = TestDataFactory.OfferCreation(1, oppObj)[0]; 
		offObj1.Authorized_for_Pricing_Manager__c = true;
		offerList.add(offObj1);
		
		database.insert(offerList);
		
		test.startTest();
		
		UpdateLoABypass updateLoAObj = new UpdateLoABypass('fNOK');
		database.executeBatch(updateLoAObj);		
		updateLoAObj.execute(null,null);				
	  
		test.stopTest();
	}
}