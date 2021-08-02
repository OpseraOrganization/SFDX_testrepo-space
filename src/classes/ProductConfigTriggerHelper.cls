/*******************************
Class Name: ProductConfigTriggerHelper
Created By: 
Last Modified By: 
Last Modified Date: 
Description: 
*******************************/
public class ProductConfigTriggerHelper{
	/*****************************
*Method Name: calculatePrice
*Description: 
*Parameters: 
*Created By: 
*Last Modified By: 
*Last Modified Date: 
*******************************/ 
	public static String calculatePrice(Decimal currencyField){		 
		system.debug('currencyField' + currencyField);
		String adjustedField = '';
		//if(currencyField != null && currencyField.setscale(2) >= 1){
		system.debug('>=1 ' +  String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.Two)));
		if(String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.Two)) != null && String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.Two)).indexOf(Nokia_CPQ_Constants.DOT ) == Nokia_CPQ_Constants.minusOne){
			adjustedField = String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.Two)) +  Nokia_CPQ_Constants.dotZero;
		}
		else if(String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.Two)) != null && String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.Two)).right(Nokia_CPQ_Constants.Two).contains(Nokia_CPQ_Constants.DOT)){
			adjustedField = String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.Two)) + Nokia_CPQ_Constants.ZERO ;
		}
		else if(String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.Two)) != null && String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.two)).right(Nokia_CPQ_Constants.Three).contains(Nokia_CPQ_Constants.DOT)){
			adjustedField = String.valueOf(currencyField.setscale(Nokia_CPQ_Constants.Two));
		}
		//}
		/*else if(currencyField != null && currencyField.setscale(2) < 1){
system.debug('<1 ' + String.valueOf(currencyField.setscale(2)));
if(String.valueOf(currencyField.setscale(2)) != null && String.valueOf(currencyField.setscale(2)).indexOf('.') == -1){
adjustedField = String.valueOf(currencyField.setscale(2)) + '.00';
}
else if(String.valueOf(currencyField.setscale(2)) != null && String.valueOf(currencyField.setscale(2)).right(2).contains('.')){
adjustedField = String.valueOf(currencyField.setscale(2)) + '0';
}
else if(String.valueOf(currencyField.setscale(2)) != null && String.valueOf(currencyField.setscale(2)).right(3).contains('.')){
adjustedField = String.valueOf(currencyField.setscale(2));
}
}*/
		return adjustedField;
	}
	
	/************************************
* Method :  updateFieldsOnProdConfig
* Paramater: List<Apttus_Config2__ProductConfiguration__c>
* Comments: Used to assign values to fields before creation of Product Configuration
* Created By: Piyush Tawari 26-09-2019 
* Nokia CPQ REQ:6624  
* ************************************/
	public static void updateFieldsOnProdConfig(List<Apttus_Config2__ProductConfiguration__c> prodConfigList)
	{
		Map<Id,Apttus_Proposal__Proposal__c> quoteMap = new Map<Id,Apttus_Proposal__Proposal__c>();
		Set<Id> quoteIdSet = new Set<Id>();
		try{
			if(!prodConfigList.isEmpty())
			{
				for(Apttus_Config2__ProductConfiguration__c config : prodConfigList)
				{
					if(String.isNotBlank(config.Apttus_QPConfig__Proposald__c))
						quoteIdSet.add(config.Apttus_QPConfig__Proposald__c);
				}
				if(quoteIdSet.size() > 0)
				{
					for(Apttus_Proposal__Proposal__c quote : [Select Id,End_Customer_Country_Code__c,NokiaCPQ_Portfolio__c,NokiaCPQ_Existing_IONMaint_Contract__c,NokiaCPQ_LEO_Discount__c,NokiaCPQPricing_Cluster__c,
															  Quote_Type__c,NokiaCPQ_Is_Maintenance_Quote__c,NokiaCPQ_Maintenance_Level__c,
															  NokiaCPQ_No_of_Years__c from Apttus_Proposal__Proposal__c 
															  where id in:quoteIdSet
															  LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
					{
						quoteMap.put(quote.Id,quote);
					}
					
					for(Apttus_Config2__ProductConfiguration__c config : prodConfigList)
					{
						if(quoteMap.containsKey(config.Apttus_QPConfig__Proposald__c)){
							if(quoteMap.get(config.Apttus_QPConfig__Proposald__c).Quote_Type__c!= Null)
								config.NokiaCPQ_Quote_Type__c = quoteMap.get(config.Apttus_QPConfig__Proposald__c).Quote_Type__c;
							if(quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQ_Portfolio__c != Null)
								config.NokiaCPQ_Portfolio__c = quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQ_Portfolio__c;
							if(quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQPricing_Cluster__c != Null)
								config.NokiaCPQ_Pricing_Cluster__c = quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQPricing_Cluster__c;
								if(quoteMap.get(config.Apttus_QPConfig__Proposald__c).  End_Customer_Country_Code__c != Null)
								config.PCcountry__c = quoteMap.get(config.Apttus_QPConfig__Proposald__c).End_Customer_Country_Code__c;
							
							
							//Heema : Re 6593
							if(/*quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQ_LEO_Discount__c ==  true && quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQ_Existing_IONMaint_Contract__c.equalsIgnoreCase('No') && */quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQ_No_of_Years__c=='1'){
								config.NokiaCPQ_IsMainSSPAdded__c = true;
							} 
							if(quoteMap!=null && quoteMap.get(config.Apttus_QPConfig__Proposald__c).Quote_Type__c!=Nokia_CPQ_Constants.directDS && config.Apttus_Config2__BusinessObjectType__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PROPOSAL) && config.NokiaCPQ_Portfolio_From_Quote__c!=Nokia_CPQ_Constants.QTC_PORTFOLIO){
								if(quoteMap.get(config.Apttus_QPConfig__Proposald__c).NokiaCPQ_LEO_Discount__c){
									config.Search_Filter_Leo__c = true;
								}
								else{
									config.Search_Filter_Leo__c = false;
								}
							}
						}
					}
				}
			}
		}catch(Exception ex)
		{
			System.debug('ProductConfigTriggerHelper class and updateFieldsOnProdConfig Method '+ex.getCause()+ex.getLineNumber()+ex.getMessage());
			ExceptionHandler.addException(ex,Nokia_CPQ_Constants.updateFieldsOnProdConfig, Nokia_CPQ_Constants.ProductConfigTriggerHelper);
		}
	}
	/************************************
* Method :  updateFieldsOnProdConfig
* Paramater: List<Apttus_Config2__ProductConfiguration__c>
* Comments: Clear Sites on Configuration Line Item
* Created By: priyanka Agrawal 23-01-2019 
* Nokia CPQ REQ:6624  
* ************************************/
	public static void clearSiteOnConfiguration(Set<id> prodConfigSet)
	{
		List<Apttus_Config2__LineItem__c> lineItemList = new List<Apttus_Config2__LineItem__c>();
		try{
			if(!prodConfigSet.isEmpty())
			{
				for(Apttus_Config2__LineItem__c lineItem : [select id,NokiaCPQ_Opportunity_Site__c from Apttus_Config2__LineItem__c 
															where Apttus_Config2__ConfigurationId__c in: prodConfigSet
															LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()])
				{
					lineItem.NokiaCPQ_Opportunity_Site__c= null;
					lineItemList.add(lineItem);
				}
			}
				if(!lineItemList.isEmpty()){
								  database.update(lineItemList);  
				}
				
		  }catch(Exception ex)
		{
			ExceptionHandler.addException(ex,'clearSiteOnConfiguration', Nokia_CPQ_Constants.ProductConfigTriggerHelper+ex.getLineNumber());
		}
	}
}