/****************************************
 * Name : UpdateOpportunityLegalEntitiesBatchTest 
 * Author : Accenture
 * Description : Test class for UpdateOpportunityLegalEntitiesBatch
 *****************************************/
@isTest
public class UpdateOpportunityLegalEntitiesBatchTest {
	Private static List<User> userList = new List<User>();
	Private static List<Account> accountList = new List<Account>();
	Private static List<Account> accountListTemp = new  List<Account>();
	Private static List<string> parentIdList = new List<string>();
	private static List<Opportunity> OppList = new List<Opportunity>();
	//Private static UpdateOpportunityLegalEntitiesBatch batchObj;
	/******************************
	*Method Name: updateOppLegalEntityTest
	*Description: Test Method to cover UpdateOpportunityLegalEntitiesBatch Execute method functionality
	********************************/
	@isTest
	static void updateOppLegalEntityTest(){
		
			Test.startTest();			
			//Account Creation of Customer Type
			Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
		
			accountList = TestDataFactory.createAccount(1);
			accountList[0].recordtypeid = custRecordTypeId;
			accountList[0].AccountStatusInCRMOM__c = 'Active';
			database.insert(accountList);  
			List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			//Opportunity Creation
			OppList= TestDataFactory.OpportunityCreation(1,accountList[0]);
			database.insert(OppList);
			
			//Account Creation of Legal Entity Type
			accountListTemp = TestDataFactory.createAccount(1);
			accountListTemp[0].Name = 'Test_Legal_Entity';
			accountListTemp[0].recordtypeid = LERecordTypeId;
			accountListTemp[0].parentid = accountList[0].id;
			accountListTemp[0].Default_Legal_Entity__c = true;
			accountListTemp[0].AccountNumber = '100030032017';

			database.insert(accountListTemp);
			parentIdList.add(accountListTemp[0].parentid);

			//Executing batch 
			UpdateOpportunityLegalEntitiesBatch batchObj = new UpdateOpportunityLegalEntitiesBatch(parentIdList);
			Database.executeBatch(batchObj ,5);
			
			Test.stopTest();
		}
		
	}