/*******************************
Class Name: ProductTriggerHandler
Created By: Accenture - October 2019
Last Modified By: Accenture
Last Modified Date: 10-10-2019
Description: Handler Class for Product Trigger 
*******************************/

public without sharing class ProductTriggerHandler {
	
	/*****************************
*Method Name: updateproductdata
*Description: This method is used to update product fields when product hierarchy is changed
*Parameters: Product List,Old Product Map,New Product Map  
*Created By: Accenture - October 2019
*Last Modified By: Accenture
*Last Modified Date: 10-10-2019
*******************************/
	
	public static void updateproductdata(map<Id,Product2> oldprodmap, map<Id,Product2> newprodmap){
		List<Product2> ProductList = new List<Product2>();
		Map<Id,Product_Hierarchy__c> hiermap = new Map<Id,Product_Hierarchy__c>();
		
		Set<Id> Producthierset=new Set<Id>();
		try{
			
			for(Product2 prod:newprodmap.values())
			{
	if(newprodmap.get(prod.Id).Product_Hierarchy__c <> oldprodmap.get(prod.Id).Product_Hierarchy__c)
	{
		Producthierset.add(prod.Product_Hierarchy__c);
		
	}
			}
			
			if(!Producthierset.isempty()){
	for(Product_Hierarchy__c Prodhierrec: [select Id, Business_Group_Code__c, Business_Unit_Code__c,Portfolio_Package_Code__c,Business_Line_Code__c from Product_Hierarchy__c where Id in :(Producthierset)])
	{
		hiermap.put(Prodhierrec.Id,Prodhierrec);
	}
			}
			
			for(Product2 pro:newprodmap.values())
			{
	if(hiermap.containskey(pro.Product_Hierarchy__c))
	{
		pro.Business_Group__c=hiermap.get(pro.Product_Hierarchy__c).Business_Group_Code__c;
		pro.Family=hiermap.get(pro.Product_Hierarchy__c).Business_Unit_Code__c;
		pro.NokiaCPQ_Portfolio_Package_Code__c=hiermap.get(pro.Product_Hierarchy__c).Portfolio_Package_Code__c;
		pro.Business_Line_Code__c=hiermap.get(pro.Product_Hierarchy__c).Business_Line_Code__c;
	}
			}
			
			/*if(!ProductList.isEmpty())
{
List<database.SaveResult> Updateresult = database.update(ProductList,false);
system.debug('Updateresult: '+Updateresult); 
}*/
			
		}
		
		catch(exception ex)
		{
			system.debug('exception'+ex.getMessage());
			ExceptionHandler.addException(ex,GlobalConstants.ProductTriggerHandler, GlobalConstants.PTH_updateproductdata);
		}   
	}

	/**
	* @description After update handler
	* @author Yashdeep Prajapati | 06-09-2021 
	* @param newMap 
	* @param oldMap 
	**/
	public static void onafterUpdate(Map < Id,Product2> newMap, Map <Id,Product2> oldMap) {
		Set <Id> inactiveProdIds = new Set <Id>();
		Set <Id> activeProdIds = new Set <Id>();
		for (Product2 product: newMap.values()) {
	if (oldMap.get(product.Id) != null && (oldMap.get(product.Id).IsActive != product.IsActive) && (product.Is_Dummy_Bundle_CPQ__c == null || product.Is_Dummy_Bundle_CPQ__c == 'No') && !product.Is_Dummy_Product__c && (String.isNotBlank(product.Portfolio__c) || String.isNotBlank(product.Direct_Portfolio__c))) {
			if (product.IsActive) {
	 activeProdIds.add(product.Id);
			} else {
	 inactiveProdIds.add(product.Id);
			}
	}
		}
		if (inactiveProdIds.size() > 0) {
			Set <Id> prodInsert = new Set <Id> ();
			for (Apttus_Config2__ProductOptionComponent__c poc: [SELECT Id, Apttus_Config2__ComponentProductId__c FROM Apttus_Config2__ProductOptionComponent__c WHERE Apttus_Config2__ComponentProductId__c IN: inactiveProdIds]) {
			  prodInsert.add(poc.Apttus_Config2__ComponentProductId__c);
			}
			if (prodInsert.size() > 0) { 
				List<NokiaCPQ_Deactivated_Products__c> daps = new List<NokiaCPQ_Deactivated_Products__c>();
				for (string prodId : prodInsert) {
				  NokiaCPQ_Deactivated_Products__c dap = new NokiaCPQ_Deactivated_Products__c();
				  dap.NCPQ_Product__c = prodId;
				  daps.add(dap);
				}
				Database.insert(daps);
			}
		  }
		  if (activeProdIds.size() > 0) {
			Map <Id, NokiaCPQ_Deactivated_Products__c> daps = new Map <Id, NokiaCPQ_Deactivated_Products__c> ([SELECT Id FROM NokiaCPQ_Deactivated_Products__c WHERE NCPQ_Product__c IN: activeProdIds]);
			if (daps != null && daps.size() > 0) {
			  List<Id> toDeleteIds = new List<Id>(daps.keyset());
			  Database.DeleteResult[] deleteResults  = Database.delete(toDeleteIds);
			  for(Database.DeleteResult dr : deleteResults) {				   
				  if (!dr.isSuccess()) {
					  for(Database.Error err : dr.getErrors()) {
						  System.debug(LoggingLevel.Error, 'The following error has occurred.'
							  + '\n' + err.getStatusCode() + ': ' + err.getMessage()
							  + '\n fields that affected this error: ' + err.getFields());
					  }
				  }
			  }
			}
		  }
	  }
}