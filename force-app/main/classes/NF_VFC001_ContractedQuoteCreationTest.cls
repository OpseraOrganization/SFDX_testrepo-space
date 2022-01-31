/**
	* @name	NF_VFC001_ContractedQuoteCreationTest
	* @author  Abdallah Dahjou 
	* @since   Jan 03, 2017
	* @desc	This Class is used to test NF_VFC001_ContractedQuoteCreation controller used to check if the user 
	*		   have the permission to manage contracted quote			   
	* @history 
**/
@isTest
private class NF_VFC001_ContractedQuoteCreationTest {
	/*
	 * @desc This method is used to test user who access access to the VF without having the permission to manage contracted quote
	 */
	
	static testMethod void testConnectedUserWithoutPermissionSet() {
		// The test data
	  
		PageReference pageRef = Page.NF_VF001_ContractedQuoteCreation;
		Test.setCurrentPage(pageRef);
		//List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		//fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		//database.insert(fileSharingCustomSettingList); 

		ApexPages.StandardController stdopportunity = new ApexPages.StandardController([SELECT Id, isOpportunitySync__c, StageName, Business_Type__c FROM Opportunity Limit 1]);  
		NF_VFC001_ContractedQuoteCreation ctrl = new NF_VFC001_ContractedQuoteCreation(stdopportunity);

		ctrl.init();
		ctrl.cancel();
	  
	}
	
		/*
	 * @desc This method is used to test user who access access to the VF with having the permission to manage contracted quote
	 */
	
	static testMethod void testConnectedUserWitPermissionSet() {
	PermissionSet permissionset;
	//List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		//fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		//database.insert(fileSharingCustomSettingList); 
	List<permissionsetassignment > lstPermission = new List<permissionsetassignment >();
	lstPermission = [SELECT AssigneeId
								FROM PermissionSetAssignment
								WHERE (PermissionSet.Name = :Label.NF_CQ_Permission_Set_Admin OR  PermissionSet.Name=:Label.NF_CQ_Permission_Set_Management_User)
								AND AssigneeId =: UserInfo.getUserId()
							   ];
	permissionset=[SELECT Id,Name FROM PermissionSet  WHERE PermissionSet.Name = :Label.NF_CQ_Permission_Set_Admin LIMIT 1 ] ;						
	if(lstPermission.isEmpty()){
	PermissionSetAssignment permissionsetassignment = new PermissionSetAssignment( AssigneeId=UserInfo.getUserId(),PermissionSetId=permissionset.Id);
	//insert permissionsetassignment;
	}

	
	PageReference pageRef = Page.NF_VF001_ContractedQuoteCreation;
	Test.setCurrentPage(pageRef);

	ApexPages.StandardController stdopportunity = new ApexPages.StandardController([SELECT Id, isOpportunitySync__c, StageName, Business_Type__c FROM Opportunity Limit 1]);
	NF_VFC001_ContractedQuoteCreation ctrl = new NF_VFC001_ContractedQuoteCreation(stdopportunity);
	
	ctrl.init();
	ctrl.cancel();
		

	}
	
	@testSetup static void setupDataTest() {
		 // The test data
		 
		 //List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		//fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		//database.insert(fileSharingCustomSettingList); 
		List<Account> accounts = NF_TestDataFactory.getAccounts(1);
		insert accounts;
		
		List<Opportunity> opportunities = NF_TestDataFactory.getOpportunities(1,accounts);
		insert opportunities;
		
	}
}