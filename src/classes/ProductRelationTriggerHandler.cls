/** 
 * About 
 * ----- 
 * @Description	  : Product_Relation__c Object Trigger Handler.
 * @TestClass		: ProductRelationTriggerTest.
 * @Project		  : Case Handling.
 * @Modification Log : 
 *  Created  : 2020 01 23 – tiago.almeida@nokia.com
 * ----- 
**/
public with sharing class ProductRelationTriggerHandler extends TriggerHandler {
	private List<Product_Relation__c> oldList;
	private List<Product_Relation__c> newList;
	private Map<Id, Product_Relation__c> oldMap;
	private Map<Id, Product_Relation__c> newMap;
	private static final String OBJECT_NAME = String.valueOf(Product_Relation__c.sObjectType).replace('__c', '');
	
	public ProductRelationTriggerHandler() {
		this.oldList = (List<Product_Relation__c>) Trigger.Old;
		this.newList = (List<Product_Relation__c>) Trigger.New;
		this.oldMap  = (Map<Id, Product_Relation__c>) Trigger.OldMap;
		this.newMap  = (Map<Id, Product_Relation__c>) Trigger.NewMap;
	}
	
	public override void beforeInsert(){
		if (!PAD.cantRun(OBJECT_NAME)){
			ProductRelationTriggerHelper.CH_AutoCompleteRelations(newList);
		}
	}
	
	public override void beforeUpdate(){
		if (!PAD.cantRun(OBJECT_NAME)){
			ProductRelationTriggerHelper.CH_AutoCompleteRelations(newList);
		}
	}
}