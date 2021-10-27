global without sharing class CH_ProductBGBUBL_Batch implements Database.Batchable<sObject>, Schedulable {
	/****************************************
	* Name : execute
	* Description : executes the batch class using schedulable instance
	* Parameters: SchedulableContext
	*****************************************/
	global void execute(SchedulableContext SC) {
		CH_ProductBGBUBL_Batch batch = new CH_ProductBGBUBL_Batch();
		Database.executebatch(batch, 1000);		
	} 
	
	/****************************************
	* Name : start
	* Description : Retrieves the data to update product hierarchy
	* Parameters: Database.BatchableContext
	* Returns : Database.QueryLocator
	*****************************************/
	global Database.QueryLocator start(Database.BatchableContext BC) {
		try {
			return database.getQueryLocator([SELECT Id, Parent_Name__c, Parent_Type__c, Child_Name__c, RelationType__c, Parent_Product__r.Id, Parent_Product__r.NCP_NSNCode__c 
											 FROM Product_Relation__c 
											 WHERE Parent_Product__c != NULL 
											 AND RelationType__c = 'NSN Owner Organization Class' 
											 AND EDPActiveStatus__c = TRUE]);
		} catch(Exception ex) { ExceptionHandler.addException(ex, 'Error Processing Product BGBUBL Batch' , GlobalConstants.START);
			return null;
		}
	}
	
	/****************************************
	* Name : execute
	* Description : Retrieves the user data from user object
	* 	If any user has expiration <= today, then update NSA compliant flag to false
	* Parameters: Database.BatchableContext, List of User
	* Returns : 
	*****************************************/	
	global void execute(Database.BatchableContext BC, List<Product_Relation__c> productHierachyBLRecords) {
		try {
			CH_ProductBGBUBL_UTIL.buildProductHierarchyBGBUBL(productHierachyBLRecords);	 
		} catch(Exception ex) { ExceptionHandler.addException(ex, 'Error Processing CH Product BGBUBL Class' , GlobalConstants.BATCH_EXECUTE);
		}
	}
	
	/****************************************
	* Name : finish
	* Description : finish method of batch class
	* Parameters: 
	* Returns : 
	 *****************************************/ 
	global void finish(Database.BatchableContext BC) {
	
	}
}