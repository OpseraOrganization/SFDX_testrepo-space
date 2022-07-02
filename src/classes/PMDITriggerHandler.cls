public class PMDITriggerHandler {
	
	/****************************************
		 * Name : reactivateProduct
		 * Description : reactivates the inactive products when state is updated with a valid active state
		 * Parameters: List of Product
		 * Returns : 
		 * Requirement : 5041
	 *****************************************/  
	public static void reactivateProduct(List<Product2> productList)
	{
		
		for(Product2 product : productList)
		{
			//If portfolio is not empty and product is inactive, check if the state is valid or not
			if(product.Portfolio__c != null)
			{
				if( !(product.NokiaCPQ_State__c.equalsIgnoreCase(PMDI_Constants.CREATE_STATE) 
				   || product.NokiaCPQ_State__c.equalsIgnoreCase(PMDI_Constants.FIELD_MAINTENANCE_STATE) 
				   || product.NokiaCPQ_State__c.equalsIgnoreCase(PMDI_Constants.OBSOLETE_STATE) ) )
				{
					//If the state is valid
					product.IsActive = true;
				}
			}
		}
	}
	
	
	 /****************************************
		 * Name : reactivateProductPriceListItem
		 * Description : reactivates the price list items whenever product status is changed from active to inactive
		 * Parameters: List of Product map before and after update
		 * Returns : 
		 * Requirement : 5041
	 *****************************************/  
	public static void reactivatePriceListItem(Map<Id,Product2> productOldMap,Map<Id,Product2> productNewMap)
	{
		
		Set<String> activeProductIdSet = new Set<String>();
		for(Id productId : productNewMap.keySet())
		{
			if(productOldMap.get(productId).IsActive == false && productNewMap.get(productId).IsActive == true)
			{
				activeProductIdSet.add(productId);
			}
		}
		
	   
		//Activate all the pricelist items for the product
		List<Apttus_Config2__PriceListItem__c> priceListItem = [Select Id, 
															  	Apttus_Config2__ProductId__c,
				Apttus_Config2__Active__c
															  	From Apttus_Config2__PriceListItem__c 
															  	where Apttus_Config2__ProductId__c in :activeProductIdSet
															  	AND Apttus_Config2__PriceListId__r.Name like 'Global%'
																AND Apttus_Config2__Active__c = false
															 	];
	   if(priceListItem != null && priceListItem.size() > 0)
	   {
		   for(Apttus_Config2__PriceListItem__c plitem : priceListItem)
			{
				//Mark the status as active for the pricelist item
				plitem.Apttus_Config2__Active__c = true;
			   
			}
		Database.update(priceListItem,false);   
	   }
		
		
	}

}