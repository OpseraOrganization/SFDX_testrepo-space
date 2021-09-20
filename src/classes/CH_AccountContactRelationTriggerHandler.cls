/****************************************
 * Class Name : CH_AccountContactRelationTriggerHandler 
 * Created Date: 14 September 2018
 * Created By : TCS
 * Last Modified by: TCS
 * Last Modified Date: 14 September 2018
 * Description : Contains common business logic
 * Test Class: CH_AccountContactRelationTriggerTest
 *****************************************/
public class CH_AccountContactRelationTriggerHandler extends TriggerHandler {
	private List<AccountContactRelation> oldList;
	private List<AccountContactRelation> newList;
	private Map<Id, AccountContactRelation> oldMap;
	private Map<Id, AccountContactRelation> newMap;
	 
	public CH_AccountContactRelationTriggerHandler() {
		this.oldList = (List<AccountContactRelation>) Trigger.Old;
		this.newList = (List<AccountContactRelation>) Trigger.New;
		this.oldMap  = (Map<Id, AccountContactRelation>) Trigger.OldMap;
		this.newMap  = (Map<Id, AccountContactRelation>) Trigger.NewMap;
	}
	
	/*
	* @description : beforeInsert handle the AccountContactRelation beforeInsert event on AccountContactRelation.
	*/
	public override void beforeInsert(){
		
	}
	
	/*
	* @description : afterInsert handle the AccountContactRelation afterInsert event on AccountContactRelation.
	*/
	public override void afterInsert(){
		CH_AccountContactRelationTriggerHelper.createEntitlementContact(newList);
	}
	
	/*
	* @description : beforeUpdate handle the AccountContactRelation beforeUpdate event on AccountContactRelation.
	*/
	public override void beforeUpdate(){
		
	}
	
	/*
	* @description : afterUpdate handle the AccountContactRelation afterUpdate event on AccountContactRelation.
	*/
	public override void afterUpdate(){
		CH_AccountContactRelationTriggerHelper.updateEntitlementContact(oldMap, newMap);
	}
	
	/*
	* @description : beforeDelete handle the AccountContactRelation beforeDelete event on AccountContactRelation.
	*/
	public override void beforeDelete(){
		
	}
	
	/*
	* @description : afterDelete handle the AccountContactRelation afterDelete event on AccountContactRelation.
	*/
	public override void afterDelete(){
		CH_AccountContactRelationTriggerHelper.deleteEntitlementContact(oldList);
	}
}