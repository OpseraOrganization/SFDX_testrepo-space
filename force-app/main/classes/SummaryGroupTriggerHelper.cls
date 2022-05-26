public class SummaryGroupTriggerHelper {

	/**********************************************
* Param: List<Apttus_Config2__SummaryGroup__c>
* Return: Map<Id,Apttus_Config2__ProductConfiguration__c> 
* Date: Nov 2019
* Details: This method returns product config map related to summary items
***********************************************/
	public static Map<Id,Apttus_Config2__ProductConfiguration__c> returnProdConfigMap(List<Apttus_Config2__SummaryGroup__c> summaryGroupList)
	{
		Set<Id> prodConfigIds = new Set<Id>();
		Map<Id,Apttus_Config2__ProductConfiguration__c> prodConfigMap = new Map<Id,Apttus_Config2__ProductConfiguration__c>();
		try{
			for(Apttus_Config2__SummaryGroup__c summaryGroup : summaryGroupList)
			{
				if(String.isNotBlank(summaryGroup.Apttus_Config2__ConfigurationId__c))
				{
					prodConfigIds.add(summaryGroup.Apttus_Config2__ConfigurationId__c);
				}
			}
			if(!prodConfigIds.isEmpty())
			{
				for(Apttus_Config2__ProductConfiguration__c prodConfig : [Select Id,Apttus_QPConfig__Proposald__r.Quote_Type__c,
																		  Apttus_Config2__PriceListId__r.CurrencyIsoCode,
																		  NokiaCPQ_Is_Cloned__c,NokiaCPQ_Clone_Flag__c,
																		  Apttus_QPConfig__Proposald__r.NokiaCPQ_Is_cloned__c,
																		  NokiaCPQ_Quote_Type__c
																		  from Apttus_Config2__ProductConfiguration__c 
																		  where Id in : prodConfigIds
																		  LIMIT:(Limits.getLimitQueryRows() - Limits.getQueryRows())])
				{
					if(prodConfig != Null)
					{
						prodConfigMap.put(prodConfig.Id,prodConfig);
					}
				}
			}
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex,SummaryGroupTriggerHelper.class.getName(),'Method Name: returnProdConfigMap'+'Line Number:'+ex.getLineNumber());
		}
		return prodConfigMap;
	}
	
	/**********************************************
* Param: List<Apttus_Config2__SummaryGroup__c>
* Return: None 
* Date: Nov 2019
* Details: Workflows converted to Trigger as 
part of Performance Improvement  
***********************************************/
	public static void updateFieldsBeforeInsert(List<Apttus_Config2__SummaryGroup__c> summaryGroupList)
	{	  
		List<Apttus_Config2__ProductConfiguration__c> prodConfigList = new List<Apttus_Config2__ProductConfiguration__c>();
		List<Apttus_Proposal__Proposal__c> quoteList = new List<Apttus_Proposal__Proposal__c>();
		Apttus_Proposal__Proposal__c quoteVar ;
		Apttus_Config2__ProductConfiguration__c prodConfigVar ;
		try{
			system.debug('summaryGroupList'+summaryGroupList);
			Map<Id,Apttus_Config2__ProductConfiguration__c> prodConfigMap = returnProdConfigMap(summaryGroupList);
			system.debug('prodConfigMap'+prodConfigMap);
			if(!prodConfigMap.isEmpty())
			{
				for(Apttus_Config2__SummaryGroup__c summaryGroup : summaryGroupList)
				{
					if(prodConfigMap.containsKey(summaryGroup.Apttus_Config2__ConfigurationId__c) &&
					  prodConfigMap.get(summaryGroup.Apttus_Config2__ConfigurationId__c)!= Null)
					{
						//Workflow 'Nokia CPQ update Adjustment Type for Direct' to code
						if(prodConfigMap.get(summaryGroup.Apttus_Config2__ConfigurationId__c).NokiaCPQ_Quote_Type__c == Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ &&
						  summaryGroup.Name != Nokia_CPQ_Constants.SUBTOTAL_ONE_TIME)
						{
							summaryGroup.Apttus_Config2__AdjustmentType__c = Nokia_CPQ_Constants.NOKIA_EMPTY;
						}
						// Workflow 'Nokia CPQ update adjustment type for indirect quotes' to code
						else if(prodConfigMap.get(summaryGroup.Apttus_Config2__ConfigurationId__c).NokiaCPQ_Quote_Type__c == Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ &&
						  summaryGroup.Name == Nokia_CPQ_Constants.TOTAL_ONE_TIME)
						{
							summaryGroup.Apttus_Config2__AdjustmentType__c = Nokia_CPQ_Constants.DISCOUNT_AMOUNT;
						}
						//Workflow 'Disallow Manual Adjustment on Summary Group' to code
						if((prodConfigMap.get(summaryGroup.Apttus_Config2__ConfigurationId__c).NokiaCPQ_Quote_Type__c == Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ &&
						  summaryGroup.Name != Nokia_CPQ_Constants.SUBTOTAL_ONE_TIME) ||
						  (prodConfigMap.get(summaryGroup.Apttus_Config2__ConfigurationId__c).NokiaCPQ_Quote_Type__c == Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ &&
						  summaryGroup.Name != Nokia_CPQ_Constants.TOTAL_ONE_TIME))
						{
							summaryGroup.Apttus_Config2__AllowManualAdjustment__c = false;
						}
						//Workflow 'Additional Information for CAD' to code
						if(prodConfigMap.get(summaryGroup.Apttus_Config2__ConfigurationId__c).NokiaCPQ_Quote_Type__c == Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ &&
						  summaryGroup.Apttus_Config2__AdjustmentAmount__c > 0)
						{
							system.debug('summaryGroup.Apttus_Config2__AdjustmentAmount__c'+summaryGroup.Apttus_Config2__AdjustmentAmount__c.setScale(2, RoundingMode.HALF_UP));
							//double adjustAmount = summaryGroup.Apttus_Config2__AdjustmentAmount__c.setScale(2, RoundingMode.HALF_UP);
							system.debug('adjustAmount >>'+summaryGroup.Apttus_Config2__AdjustmentAmount__c);
							summaryGroup.NokiaCPQ_Additional_Information__c = 'CAD-'+summaryGroup.Apttus_Config2__AdjustmentAmount__c.setScale(2, RoundingMode.HALF_UP)+prodConfigMap.get(summaryGroup.Apttus_Config2__ConfigurationId__c).Apttus_Config2__PriceListId__r.CurrencyIsoCode;
						}
						//ProcessBuilder 'Clear CAD on summary group when cloned' to code
					   
						if(prodConfigMap.get(summaryGroup.Apttus_Config2__ConfigurationId__c).NokiaCPQ_Quote_Type__c == Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ &&
						   prodConfigMap.get(summaryGroup.Apttus_Config2__ConfigurationId__c).NokiaCPQ_Is_cloned__c &&
						   /*!prodConfigMap.get(summaryGroup.Apttus_Config2__ConfigurationId__c).NokiaCPQ_Clone_Flag__c &&*/ 
						   summaryGroup.Name == Nokia_CPQ_Constants.TOTAL_ONE_TIME && summaryGroup.Apttus_Config2__AdjustmentAmount__c > 0 )
						{
							//summaryGroup.Apttus_Config2__AdjustmentAmount__c = 0;
							prodConfigVar =  new Apttus_Config2__ProductConfiguration__c();
							prodConfigVar = prodConfigMap.get(summaryGroup.Apttus_Config2__ConfigurationId__c);
							/*prodConfigVar.NokiaCPQ_Clone_Flag__c = false;*/
							prodConfigList.add(prodConfigVar);
							quoteVar = new Apttus_Proposal__Proposal__c(Id=prodConfigMap.get(summaryGroup.Apttus_Config2__ConfigurationId__c).Apttus_QPConfig__Proposald__c
																		/*NokiaCPQ_Is_cloned__c = false , NokiaCPQ_LEO_Discount__c= true */);
							quoteList.add(quoteVar);
						}
					}
				}
				system.debug('prodConfigList'+prodConfigList);
				system.debug('quoteList'+quoteList);
				if(!quoteList.isEmpty())
				{
					ID jobID = System.enqueueJob(new UpdateSObjectFlags(quoteList));
					//system.debug('Database.SaveResult'+sv);
				}
				if(!prodConfigList.isEmpty())
				{
					Database.SaveResult[] sv =  database.update(prodConfigList,false);
					system.debug('Database.SaveResult'+sv);
				}
				
			}
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex,SummaryGroupTriggerHelper.class.getName(),'Method Name: updateFieldsBeforeInsert'+'Line Number:'+ex.getLineNumber());		  
		}
	}
	
	/**********************************************
* Param: List<Apttus_Config2__SummaryGroup__c>
* Return: None 
* Date: Nov 2019
* Details: Workflows converted to Trigger as 
part of Performance Improvement  
***********************************************/
	public static void updateFieldsBeforeUpdate(List<Apttus_Config2__SummaryGroup__c> summaryGroupList)
	{
		try{
			system.debug('summaryGroupList'+summaryGroupList);
			Map<Id,Apttus_Config2__ProductConfiguration__c> prodConfigMap = returnProdConfigMap(summaryGroupList);
			system.debug('prodConfigMap'+prodConfigMap);
			if(!prodConfigMap.isEmpty())
			{
				for(Apttus_Config2__SummaryGroup__c summaryGroup : summaryGroupList)
				{
					if(prodConfigMap.containsKey(summaryGroup.Apttus_Config2__ConfigurationId__c) &&
					  prodConfigMap.get(summaryGroup.Apttus_Config2__ConfigurationId__c)!= Null)
					{
						//Workflow 'Additional Information for CAD' to code
						if(prodConfigMap.get(summaryGroup.Apttus_Config2__ConfigurationId__c).NokiaCPQ_Quote_Type__c == Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ &&
						  summaryGroup.Apttus_Config2__AdjustmentAmount__c > 0)
						{
							system.debug('summaryGroup.Apttus_Config2__AdjustmentAmount__c'+summaryGroup.Apttus_Config2__AdjustmentAmount__c.setScale(2, RoundingMode.HALF_UP));
							//double adjustAmount = summaryGroup.Apttus_Config2__AdjustmentAmount__c.setScale(2, RoundingMode.HALF_UP);
							system.debug('adjustAmount ==='+summaryGroup.Apttus_Config2__AdjustmentAmount__c);
							summaryGroup.NokiaCPQ_Additional_Information__c = 'CAD-'+summaryGroup.Apttus_Config2__AdjustmentAmount__c.setScale(2, RoundingMode.HALF_UP)+prodConfigMap.get(summaryGroup.Apttus_Config2__ConfigurationId__c).Apttus_Config2__PriceListId__r.CurrencyIsoCode;
						}
					}
				}
			}
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex,SummaryGroupTriggerHelper.class.getName(),'Method Name: updateFieldsBeforeUpdate'+'Line Number:'+ex.getLineNumber());		  
		}
	}
}