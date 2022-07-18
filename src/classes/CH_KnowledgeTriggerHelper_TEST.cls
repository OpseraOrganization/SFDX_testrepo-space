@isTest
public class CH_KnowledgeTriggerHelper_TEST {
	public static final string WORKGROUPNAME = 'TEST';
	@isTest
	public static void testSetDefaultDataCategories(){
		CH_ManageCreateQueueAsynchQueue.doChainJob = false;
		List<CH_Workgroup__c> workGroups = new List<CH_Workgroup__c>();
		Id recordTypeId = Schema.SObjectType.CH_Workgroup__c.getRecordTypeInfosByDeveloperName().get('CH_KB_Workgroup').getRecordTypeId();
		CH_Workgroup__c workgroup = new CH_Workgroup__c(RecordTypeId = recordTypeId);
		workgroup.name = WORKGROUPNAME;
		workgroup.CH_End_of_Business_Hours_Threshold__c = 120;
		workgroup.CH_Start_of_Business_Hours_Threshold__c = 120;
		workGroups.add(workgroup);
		insert workgroup;
		
		CH_Workgroup_Member__c wgm = new CH_Workgroup_Member__c();
		wgm.CH_User__c = UserInfo.getUserId();
		wgm.CH_Role__c = 'Author';
		wgm.CH_Workgroup__c = workgroup.id;
		wgm.RecordTypeId = Schema.SObjectType.CH_Workgroup_Member__c.getRecordTypeInfosByDeveloperName().get('CH_KB_Workgroup_Members').getRecordTypeId();
		insert wgm;
		
		System.debug('workgroup id'+workgroup.id);
		
		//Create Knowledge Article witch 'CH' Record Type
		String RecTypeId = Schema.getGlobalDescribe().get('Knowledge__kav').getDescribe().getRecordTypeInfosByDeveloperName().get('CH_HowTo').getRecordTypeId();
		Knowledge__kav testArticle = new Knowledge__kav(Title = 'How To Test By Gizmo2313', urlName = 'HowToTestByGizmo123123123', RecordTypeId = RecTypeId, CH_PurposeRequired__c = 'd', CH_ProcedureRequired__c = 'Gizem is the best',CH_Workgroup__c = workgroup.id);
		insert testArticle; 
		
		system.debug('lista ---> ' + [select id, DataCategoryGroupName, DataCategoryName from Knowledge__DataCategorySelection where ParentId =: testArticle.Id]);
		
		List<Knowledge__DataCategorySelection> ExistingDataCategories = [select id, DataCategoryGroupName, DataCategoryName from Knowledge__DataCategorySelection where ParentId =: testArticle.Id];
		if(!ExistingDataCategories.isEmpty()){
			delete ExistingDataCategories;
		}
		
		//Check if Data Category was set appropriately via querying the junction object between DataCategory and Knowledge Object
		List<Knowledge__DataCategorySelection> dataCategories = new List<Knowledge__DataCategorySelection>();
		Knowledge__DataCategorySelection testArticleDataCategorySelection = new Knowledge__DataCategorySelection();
			testArticleDataCategorySelection.DataCategoryGroupName = 'Case_Handling';
			testArticleDataCategorySelection.DataCategoryName = 'All';
			testArticleDataCategorySelection.ParentId = testArticle.Id;
			dataCategories.add(testArticleDataCategorySelection);
			insert testArticleDataCategorySelection;
			
		System.assertEquals('Case_Handling', testArticleDataCategorySelection.DataCategoryGroupName); 
		System.assertEquals('All', testArticleDataCategorySelection.DataCategoryName);
	}  
}