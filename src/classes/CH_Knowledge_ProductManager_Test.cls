@isTest
public class CH_Knowledge_ProductManager_Test {

	public static final string WORKGROUPNAME = 'TEST';
	@isTest
	public static void test() {
		
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		Test.isRunningTest();
		test.starttest();
		// Create Knowledge Article
		String RecTypeId = Schema.getGlobalDescribe().get('Knowledge__kav').getDescribe().getRecordTypeInfosByDeveloperName().get('CH_HowTo').getRecordTypeId();
		String MemberRecTypeId = Schema.getGlobalDescribe().get('CH_Workgroup_Member__c').getDescribe().getRecordTypeInfosByDeveloperName().get('CH_KB_Workgroup_Members').getRecordTypeId();
		
		Id recordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByDeveloperName().get('CH_KB_Workgroup').getRecordTypeId();
		CH_Workgroup__c workgroup = new CH_Workgroup__c(RecordTypeId = recordTypeId);
		workgroup.name = WORKGROUPNAME;
		workgroup.CH_End_of_Business_Hours_Threshold__c = 120;
		workgroup.CH_Start_of_Business_Hours_Threshold__c = 120;
		insert workgroup;
		
		CH_Workgroup_Member__c wgMember = new CH_Workgroup_Member__c();
		wgMember.CH_Workgroup__c = workgroup.id;
		wgMember.CH_User__c = UserInfo.getUserId();
		wgMember.CH_Role__c = 'Author';
		wgMember.RecordTypeId = MemberRecTypeId;
		insert wgMember;
		
		System.debug('workgroup id --> '+workgroup.id);
		System.debug('workgroup member id --> '+wgMember.id);
		
		Knowledge__kav oArticle = new Knowledge__kav(Title = 'How To Test', urlName = 'HowToTest', RecordTypeId = RecTypeId, CH_Workgroup__c = workgroup.id, CH_PurposeRequired__c = 'd', CH_ProcedureRequired__c = 'TEST');
		insert oArticle;
		System.assertNotEquals(oArticle, null);
		// Asssociate the Products
		CH_TestDataFactory.createProducts();
		Id productId = [SELECT Id FROM Product2 LIMIT 1].Id;
		CH_ProductRelation__c oProductRelation = new CH_ProductRelation__c(CH_Knowledge__c = oArticle.id, CH_Parent_Product__c = productId);
		insert oProductRelation;
		System.assertNotEquals(oProductRelation, null);
		// Create and associate Product Releases
		CH_ProductRelease__c oProductRelease = new CH_ProductRelease__c();
		oProductRelease.Name = 'Test Product Release';
		oProductRelease.CH_ProductId__c = oArticle.CH_ProductId__c;
		insert oProductRelease;
		System.assertNotEquals(oProductRelease, null);
		System.assertNotEquals(CH_Knowledge_ProductManager_Controller.getArticleProductsAndReleases(oArticle.Id), null);
		System.assertNotEquals(CH_Knowledge_ProductManager_Controller.getValidArticleProducts(oArticle.Id), null);
		System.assertNotEquals(CH_Knowledge_ProductManager_Controller.canEdit(oArticle.Id), null);
		System.assertNotEquals(CH_Knowledge_ProductManager_Controller.getValidProductReleases(oArticle.Id, productId), null);
		System.assertNotEquals(CH_Knowledge_ProductManager_Controller.saveProductRelation(oArticle.id, JSON.serialize(new CH_ProductRelation__c(CH_Knowledge__c = oArticle.id, CH_Parent_Product__c = productId))), null);
		System.assertNotEquals(CH_Knowledge_ProductManager_Controller.removeProductOrReleaseRelation(oArticle.Id, 'Product Release', oProductRelease.Id), null);
		System.assertNotEquals(CH_Knowledge_ProductManager_Controller.removeProductOrReleaseRelation(oArticle.Id, 'Product', productId), null);
		test.stoptest();
	}
}