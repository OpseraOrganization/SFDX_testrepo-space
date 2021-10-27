public with sharing class Territory2TriggerHandler extends TriggerHandler{
	
	public Map<Id,Territory2> oldMap = (Map<Id,Territory2>)Trigger.oldMap;
	public Map<Id,Territory2> newMap = (Map<Id,Territory2>)Trigger.newMap;
	public List<Territory2> oldList = Trigger.old;
	public List<Territory2> newList = Trigger.new;

	public Territory2TriggerHandler(){
	}

	public override void afterDelete(){	  
		Territory2TriggerHelper.deleteSalesRolesFromTerritory(oldList);
	}
}