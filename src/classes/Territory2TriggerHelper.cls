/******************************************************************************************************
Name : Territory2TriggerHelper
Created Date: 23 JULY 2020
Created by: CO Dev
Description : Helper for the territory2 trigger
*********************************************************************************************************/
public class Territory2TriggerHelper{
	
	/********************
	*Method Name: deleteSalesRolesFromTerritory
	*Parameter: TerritoryOldList
	*Description: Delete the sales roles associated to the deleted territory
	*******************/
	public static void deleteSalesRolesFromTerritory(List<Territory2> oldList){
		Set<String> organizationList = new Set<String>();
		List<Sales_Role__c> salesRoleList = new List<Sales_Role__c>();
		try{			
			for(Territory2 territoryDeleted : oldList){
				organizationList.add(territoryDeleted.Name);
			}
			if(!organizationList.isEmpty()){
				salesRoleList = [SELECT Id, Organisation__c FROM Sales_Role__c where Organisation__c in :organizationList];
				if(!salesRoleList.isEmpty()){
					ID jobID = System.enqueueJob(new DeleteSalesRole(salesRoleList));
					System.debug('Deleting Sales Roles - jobID = '+jobID);
				}
			}			
		}catch(Exception ex){
			ExceptionHandler.addException(ex, Territory2TriggerHelper.class.getName(), 'deleteSalesRolesFromTerritory');
		}
	}
	
	public class DeleteSalesRole implements Queueable {
		public List<Sales_Role__c> salesRoleList ; 
		public DeleteSalesRole(List<Sales_Role__c> salesRoleList){
			this.salesRoleList = salesRoleList ;  
		}
		public void execute(QueueableContext context) {
			try{
				GlobalConstants.Sales_Role_Bypass = true;
				delete salesRoleList;
			}catch(Exception ex){
				ExceptionHandler.addException(ex, DeleteSalesRole.class.getName(), 'DeleteSalesRole');
			}
		}
	}
}