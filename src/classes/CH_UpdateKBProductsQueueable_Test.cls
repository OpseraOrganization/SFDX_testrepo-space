@isTest 
private class CH_UpdateKBProductsQueueable_Test {
	static testMethod void testUpdateKBProducts() {
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		System.runAs(oAdminUser) {			
			String howToRecTypeId = Schema.getGlobalDescribe().get('Knowledge__kav').getDescribe().getRecordTypeInfosByDeveloperName().get('CH_HowTo').getRecordTypeId();
			Id kbRecordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByDeveloperName().get('CH_KB_Workgroup').getRecordTypeId();
			Id prodRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
			
			Test.startTest();
			
			CH_Workgroup__c workgroup = new CH_Workgroup__c();
			workgroup.RecordTypeId = kbRecordTypeId;
			workgroup.name = 'WORKGROUPNAME';
			workgroup.CH_End_of_Business_Hours_Threshold__c = 120;
			workgroup.CH_Start_of_Business_Hours_Threshold__c = 120;
			insert workgroup;
			
			CH_Workgroup_Member__c wgm = new CH_Workgroup_Member__c();
			wgm.CH_User__c = UserInfo.getUserId();
			wgm.CH_Role__c = 'Author';
			wgm.CH_Workgroup__c = workgroup.id;
			wgm.RecordTypeId = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByDeveloperName().get('CH_KB_Workgroup_Members').getRecordTypeId();
			insert wgm;
			
			Knowledge__kav testArticle = new Knowledge__kav();
			testArticle.Title = 'How To Test By Gizmo23131'; 
			testArticle.urlName = 'HowToTestByGizmo1231231231'; 
			testArticle.RecordTypeId = howToRecTypeId;
			testArticle.CH_PurposeRequired__c = 'd';
			testArticle.CH_ProcedureRequired__c = 'Test';
			testArticle.CH_Workgroup__c = workgroup.id;
			testArticle.Language = 'en_US';
			testArticle.CH_Category__c = 'Known Issue';
			insert testArticle;
			
			Product2 prod = new Product2();
			prod.RecordTypeId = prodRecordTypeId;
			prod.Name = 'KIT-CENTER CORE APPL OCE';
			prod.ProductCode = '134-073605';
			insert prod;
			
			CH_ProductRelease__c prodRel = new CH_ProductRelease__c();
			prodRel.Name = 'KIT-CENTER';
			insert prodRel;
			
			CH_ProductRelation__c pr = new CH_ProductRelation__c();
			pr.CH_Knowledge__c = testArticle.Id;
			pr.CH_Parent_Product__c = prod.Id;
			
			insert pr;

			Test.stopTest();
		}
	}
}