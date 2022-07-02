/**
About
-----
Description: This Class is used as handler for CH_KnowledgeTrigger

Created for: Nokia Portugal COE
Created: 17 04 2019

Update History
--------------
Created: 17 04 2019 – flavio.toscano@nokia.com
-------------
**/
public with sharing class CH_KnowledgeHandler_TH extends TriggerHandler {
	private List<Knowledge__kav> oldList;
	private List<Knowledge__kav> newList;
	private Map<Id, Knowledge__kav> oldMap;
	private Map<Id, Knowledge__kav> newMap;

	public CH_KnowledgeHandler_TH() {
		this.oldList = (List<Knowledge__kav>) Trigger.Old;
		this.newList = (List<Knowledge__kav>) Trigger.New;
		this.oldMap  = (Map<Id, Knowledge__kav>) Trigger.OldMap;
		this.newMap  = (Map<Id, Knowledge__kav>) Trigger.NewMap;
	}

	/*
	* @description : beforeInsert handle the CH_Workgroup afterInsert event on Knowledge__kav.
	*/
	public override void beforeInsert(){

	}

	/*
	* @description : afterInsert handle the CH_Workgroup afterInsert event on Knowledge__kav.	
	*/
	public override void afterInsert(){
		System.debug('*******articleList' + newList);
		CH_KnowledgeHandler_TL.setDefaultDataCategories(isolateCHArticlesByRecordType(newList));
		CH_KnowledgeHandler_TL.getProductFromLatestVersion(isolateCHArticlesByRecordType(newList));
	}

	/*
	* @description beforeUpdate handle the CH_Workgroup afterUpdate event on Knowledge__kav.
	*/
	public override void beforeUpdate(){
		/* Commenting below code, 35225 US no longer reqyuired
		CH_KnowledgeHandler_TL.updateKnowledgeArticleId(isolateCHArticlesByRecordType(newList));//NOKIASC-35225 */
		CH_KnowledgeHandler_TL.updateKBProducts(newList);
	}

	/*
	* @description afterUpdate handle the CH_Workgroup afterUpdate event on Knowledge__kav.
	*/ 
	public override void afterUpdate(){
		if(CH_AvoidRecursion.runBeforeUpdateOnce()) {
			CH_KnowledgeHandler_TL.validateIfUserCanEditArticle(newList);
			CH_KnowledgeHandler_TL.assignOwnerIfInApprovalStatus(oldList,newList);
		}
	}

	/*
	* @description beforeDelete handle the CH_Workgroup afterDelete event on Knowledge__kav.
	*/
	public override void beforeDelete(){
		CH_KnowledgeHandler_TL.validateIfUserCanDeleteArticle(oldList);
	}

	/*
	* @description afterDelete handle the CH_Workgroup afterUpdate event on Knowledge__kav.
	*/
	public override void afterDelete(){

	}
	
   /********************
	*Method Name: isolateCHArticlesByRecordType
	*Parameter: New Article List 
	*Last updated by: MMiemiec (2019.01.09)
	*Description: isolate only the Case Handling articles (by record type)
	*	  This is to reduce the size of the list if a bulk amount of Cases are being loaded (that are not CH specific)
	*	  (Performance improvement step)
	*	  User Story: NOKIASC-12569
	*******************/
	public static List<Knowledge__kav> isolateCHArticlesByRecordType(List<Knowledge__kav> articleList){
		List<Knowledge__kav> chArticles = new List<Knowledge__kav>();
		for(Knowledge__kav articleObj: articleList){
			//checks hidden formula field on article - boolean that returns true for CH Record Types
			if(articleObj.CH_KnowledgeRecordTypeCheck__c){
	chArticles.add(articleObj);
			}
		}
		return chArticles;
	}
}