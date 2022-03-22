@isTest
public class SearchAndAddEndCustomerTest {
   
	static testMethod void EndCustOpty(){
		List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		List<Opportunity> lstOpty= new List<Opportunity>();
		List<Account> accList = new List<Account>();
		Id oppIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Indirect Sales Opportunity').getRecordTypeId();
		Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 

		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		
		accList = TestDataFactory.createAccount(3);
		
		accList[0].RecordTypeId=custRecordTypeId;
		//Parent Account:
		accList[1].RecordTypeId=custRecordTypeId;
		//Child Account:
		accList[2].RecordTypeId=LERecordTypeId;
		database.insert(accList);

		
		lstOpty = TestDataFactory.OpportunityCreation(2,accList[0]);
		lstOpty[1].RecordTypeId= oppIndirectRecordTypeId ;
		lstOpty[1].End_Customer__c = null;
		lstOpty[1].End_Customer_LE__c=accList[2].id;
		database.insert(lstOpty);
		
			
		accList[2].parentId=accList[0].id;		  
		database.update(accList[2]);
		test.starttest();
		
		List<Opportunity> OptyQry =[select Id,End_Customer__c,End_Customer_LE__c,End_Customer_LE__r.parentId 
									from opportunity 
									where End_Customer_LE__r.parentId<>NULL 
									and End_Customer__c=NULL 
									and End_Customer_LE__c<>NULL 
									and End_Customer_LE__r.lastmodifieddate=TODAY 
									and recordtypeId=:oppIndirectRecordTypeId];
	
		System.debug('Size of List'+OptyQry.size());
		SearchAndAddEndCustomer obj = new SearchAndAddEndCustomer();
		DataBase.executeBatch(obj);		
	   System.debug('-------Size of List'+OptyQry.size());
		test.stoptest();
		
	}


}