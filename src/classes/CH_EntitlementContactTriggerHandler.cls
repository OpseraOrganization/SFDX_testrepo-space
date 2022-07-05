/** 
 * About 
 * ----- 
 * @Description	  : EntitlementContact Object Trigger Handler.
 * @TestClass	  : CH_EntitlementContactUtils_Test.
 * @Project	: Case Handling.
 * @Modification Log : 
 *  Created  : 2021 03 01 – tiago.almeida@nokia.com
 * ----- 
**/
public with sharing class CH_EntitlementContactTriggerHandler extends TriggerHandler {
	public static Boolean skipAuthorizationHistory = false;
	private List<EntitlementContact> oldList;
	private List<EntitlementContact> newList;
	private Map<Id, EntitlementContact> oldMap;
	private Map<Id, EntitlementContact> newMap;
	
	public CH_EntitlementContactTriggerHandler() {
		this.oldList = (List<EntitlementContact>) Trigger.Old;
		this.newList = (List<EntitlementContact>) Trigger.New;
		this.oldMap  = (Map<Id, EntitlementContact>) Trigger.OldMap;
		this.newMap  = (Map<Id, EntitlementContact>) Trigger.NewMap;
	}

	public override void beforeInsert(){
		EntitlementContactTriggerHelper.validateCompetitorSCForCompetitorContacts(newList);
	}
	
	public override void afterInsert(){
		if(!skipAuthorizationHistory && UserInfo.getUserId() != System.Label.CH_IPaas_User_Id) {
			CH_AuthorizationHistory.create('Add', newList);
		}
		// Manage sharing of authorization contacts
		CH_AuthorizedContactSharing.handleSharing(newMap, oldMap, true, false); 
	}
	
	public override void afterDelete(){
		if(!skipAuthorizationHistory && UserInfo.getUserId() != System.Label.CH_IPaas_User_Id) {
			CH_AuthorizationHistory.create('Delete', oldList);
		}
		// Manage sharing of authorization contacts
		CH_AuthorizedContactSharing.handleSharing(newMap, oldMap, false, true); 
	}
}