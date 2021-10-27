/****************************************
* Class Name : CH_KnowledgeArticlesRestAPITest 
* Created Date: 27 August 2020
* Created By : TCS
* Description : Test class for CH_KnowledgeArticlesRestAPI
************/
@isTest
public class CH_KnowledgeArticlesRestAPITest {
	@testsetup static void usersetup(){
		PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'CH_Author'];
		Insert new PermissionSetAssignment(AssigneeId =UserInfo.getUserId(), PermissionSetId = ps.Id);
	}
	
	private static void testDataSetup(){
		
		String howToRecTypeId = Schema.getGlobalDescribe().get('Knowledge__kav').getDescribe().getRecordTypeInfosByDeveloperName().get('CH_HowTo').getRecordTypeId();
		Id kbRecordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByDeveloperName().get('CH_KB_Workgroup').getRecordTypeId();
		Id prodRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
		
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
		testArticle.Title = 'How To Test By Gizmo2313'; 
		testArticle.urlName = 'HowToTestByGizmo123123123'; 
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
		pr.CH_Parent_Release__c = prodRel.Id;
		insert pr;
		
		Product2 prod2= new Product2();
		prod2.RecordTypeId = prodRecordTypeId;
		prod2.Name = 'KIT-CENTER CORE APPL';
		prod2.ProductCode = '833-073605';
		insert prod2;
		
		CH_ProductRelease__c prodRel2 = new CH_ProductRelease__c();
		prodRel2.Name = 'KIT-CENTER1';
		insert prodRel2;
		
		CH_ProductRelation__c pr2 = new CH_ProductRelation__c();
		pr2.CH_Knowledge__c = testArticle.Id;
		pr2.CH_Parent_Product__c = prod2.Id;
		pr2.CH_Parent_Release__c = prodRel2.Id;
		insert pr2;
		
	}
	static testMethod void testGetForEmployees() {
		
		testDataSetup();
		
		Knowledge__kav ka = [SELECT Id,KnowledgeArticleId,ArticleNumber,PublishStatus,CreatedDate,LastModifiedDate,Title,UrlName,CH_Solution__c,
		CH_WorkAround__c,CH_QuestionOrProductDescription__c,CH_ProcedureRequired__c,CH_PurposeRequired__c,Source__c,CH_Category__c FROM Knowledge__kav LIMIT 1];
		KnowledgeArticle knowledgeArticle = [SELECT Id FROM KnowledgeArticle WHERE ArticleNumber = :ka.get('ArticleNumber').toString()];
		Product2 prod = [SELECT Id FROM Product2 LIMIT 1];
		CH_ProductRelation__c pr = [SELECT Id,CH_Parent_Product__c FROM CH_ProductRelation__c WHERE CH_Parent_Product__c=:prod.Id];		
		List<Product2> prodList = new List<Product2>();  
		KbManagement.PublishingService.publishArticle(ka.KnowledgeArticleId, true);
		ka = [SELECT Id,KnowledgeArticleId,ArticleNumber,PublishStatus,CreatedDate,LastModifiedDate,Title,UrlName,CH_Solution__c,
	 CH_WorkAround__c,CH_QuestionOrProductDescription__c,CH_ProcedureRequired__c,CH_PurposeRequired__c,Source__c,CH_Category__c FROM Knowledge__kav LIMIT 1];
		Id [] fixedSearchResults= new Id[1];
		fixedSearchResults[0] = ka.Id;
		Test.setFixedSearchResults(fixedSearchResults);
		System.debug('PUBLISHSTATUS;##'+ka);
		prodList.add(prod);
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();	 
		req.params.put('SearchText', 'Test');
		req.params.put('Size', '1');		
		req.params.put('ProductCode', '134-073605'); 
		req.params.put('Category', 'Known Issue'); 
		req.params.put('ProductRelease', 'KIT-CENTER'); 
		RestContext.request = req;
		RestContext.response= res;	 
		List<CH_KnowledgeArticlesRestAPI.KnowledgeArticleWrapper> wrap = new List<CH_KnowledgeArticlesRestAPI.KnowledgeArticleWrapper>();
		wrap.add(new CH_KnowledgeArticlesRestAPI.KnowledgeArticleWrapper(ka,prodList,new List<CH_ProductRelease__c>(),'Internal'));
		wrap = CH_KnowledgeArticlesRestAPI.doGet();
	}
	static testMethod void testGetForUserDetails() {
		testDataSetup();
		
		RestRequest req = new RestRequest(); 
		RestResponse res = new RestResponse();   
		req.params.put('FederationId', '1234567');	
		RestContext.request = req;
		RestContext.response= res;		  
		CH_GetUserDetailsRestAPI wrap = new CH_GetUserDetailsRestAPI();
		CH_GetUserDetailsRestAPI.doGet();
	}
}