/****************************************
* Name : Batch_ProductUpdate
* Author : Accenture
* Description : This class is for updating related Product fields once Product hierachy is updated
* ReqNo : 
****************************************/

global class Batch_ProductUpdate implements Database.Batchable<sObject>{
	
	
	Set<Id> UpdateIds;
	Map<Id,Product_Hierarchy__c> Hiermap=new Map<Id,Product_Hierarchy__c>();
	
	global Batch_ProductUpdate(Set<Id> updatedhierset,Map<Id,Product_Hierarchy__c> newhiermap){
		UpdateIds=updatedhierset;
		Hiermap=newhiermap;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		String query = 'select Id, Family, Business_Group__c,Product_Hierarchy__c from Product2 where Product_Hierarchy__c in :UpdateIds';
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC,List<Product2> Prod2){
		List<Product2> ProductsList = new List<Product2>();
		try{
			for(Product2 obj: Prod2){
				obj.Business_Group__c = Hiermap.get(obj.Product_Hierarchy__c).Business_Group_Code__c;
				obj.Family = Hiermap.get(obj.Product_Hierarchy__c).Business_Unit_Code__c;
				obj.NokiaCPQ_Portfolio_Package_Code__c=Hiermap.get(obj.Product_Hierarchy__c).Portfolio_Package_Code__c;
				obj.Business_Line_Code__c=Hiermap.get(obj.Product_Hierarchy__c).Business_Line_Code__c;
				ProductsList.add(obj);
				system.debug('obj++'+obj);
			}
			//update ProductsList;
			List<database.SaveResult> Updateresult = database.update(ProductsList,false);
			system.debug('Updateresult: '+Updateresult);
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.Batch_ProductUpdate, 'Execute');
		}
		
	}
	
	
	global void finish(Database.BatchableContext BC) {
	}
	
}