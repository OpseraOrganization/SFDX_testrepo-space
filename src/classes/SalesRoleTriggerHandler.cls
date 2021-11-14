public with sharing class SalesRoleTriggerHandler extends TriggerHandler
{
	private Map<Id,Sales_Role__c> oldMap = (Map<Id,Sales_Role__c>)Trigger.oldMap;
	private Map<Id,Sales_Role__c> newMap = (Map<Id,Sales_Role__c>)Trigger.newMap;
	private List<Sales_Role__c> oldList = Trigger.old;
	private List<Sales_Role__c> newList = Trigger.new;
	private List<PSRO_Costs_Visibilities_Manager__mdt> psroAllowedRoles = [SELECT ID,Role_Name__c,BG__c FROM PSRO_Costs_Visibilities_Manager__mdt];
	private List<PermissionSet> PSROCostsVisibilities = [SELECT ID,Name FROM PermissionSet WHERE name='PSRO_Costs_Visibilities'];

	public SalesRoleTriggerHandler()
	{
	}
	
	protected override void beforeInsert()
	{
		SalesRoleTriggerHelper.onBeforeInsert_Update_salesroledata(newList, null);
	}
	protected override void beforeUpdate()
	{
		SalesRoleTriggerHelper.onBeforeInsert_Update_salesroledata(newList, oldList);
	}
	protected override void beforeDelete()
	{
		SalesRoleTriggerHelper.deleteSalesHisoryRecord(oldMap.values());
		SalesRoleTriggerHelper.managePSROCostsVisibilities(oldMap,newMap,PSROCostsVisibilities[0].id,psroAllowedRoles);
	}
	protected override void afterInsert()
	{
		SalesRoleTriggerHelper.createSalesHisoryRecord(oldMap,newMap);
		SalesRoleTriggerHelper.managePSROCostsVisibilities(oldMap,newMap,PSROCostsVisibilities[0].id,psroAllowedRoles);
	}
	protected override void afterUpdate()
	{
		SalesRoleTriggerHelper.modifySalesHisoryRecord(oldMap,newMap);
		SalesRoleTriggerHelper.managePSROCostsVisibilities(oldMap,newMap,PSROCostsVisibilities[0].id,psroAllowedRoles);
	}
	protected override void afterDelete()
	{
	}
}