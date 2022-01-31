/****************************************
* Name : Batch_CalculateCurrentValueforPSRO
* Author : Accenture
* Description : calculate cost of BG in all RO/RS opportunities and update current value in Threshold object - Adapted in March 2021
****************************************/
global without sharing class Batch_CalculateCurrentValueforPSRO implements Database.Batchable<sObject>, Database.Stateful 
{ 
	public Map<String,PSRO_Market_Threshold__c> thresholdsMap = new Map<String,PSRO_Market_Threshold__c>();
	public Map<String,Decimal> updatedTHValMap = new Map<String,Decimal>();
	public Set<Id> thresholdsExceeded = new Set<Id>();
	Map<String,String> mapMarketUnit_Market = new Map<String,String>();
	
	/********************
	*Method Name:execute 
	*Parameter:SchedulableContext SC
	*Description:Execute the bacth 
	*******************/
	global void execute(SchedulableContext SC)
	{
		Batch_CalculateCurrentValueforPSRO  batch= new Batch_CalculateCurrentValueforPSRO();
		Database.executebatch(batch,200);	 
	}
	
	/****************************************
	* Name : start
	* Description : this method will contain the SOQL query for the batch 
	*****************************************/
	global Database.QueryLocator start(Database.BatchableContext BC)
	{			 
		//on the thresholds to facilitate finding the right one on market and BG or BU it's used a map with key Market/BG or Market/BU if the threshold is either defined at BG level or BU level
		for(PSRO_Market_Threshold__c threshold : OpportunityTriggerHelper_PreSales.getPSROMarketThresholds(null))
		{
			String key = threshold.Market__c+GlobalConstants.BackSlash+ (threshold.Business_Unit__c != null ? threshold.Business_Unit__c : threshold.Business_Group__c);
			thresholdsMap.put(key, threshold);
			updatedTHValMap.put(key,0.0);
		}

		//get the matrix for the correspondent market for specific market units
		for(Map_Enterprise_MUs_and_Market__c mapping : Map_Enterprise_MUs_and_Market__c.getAll().values()){
			mapMarketUnit_Market.put(mapping.Enterprise_MU__c, mapping.Market__c);
		}
		
		return Database.getQueryLocator([SELECT Id, PSR_Cost_BU_NI_FN__c , PSR_Cost_BU_NI_IPRTG__c , PSR_Cost_BU_NI_OPTICS__c , PSR_Cost_BG_MN__c , PSR_Cost_BG_CNS__c, PSR_Cost_BG_NI__c,
										 Org_L3__c,Org_L4__c,Org_L5__c,CurrencyIsoCode FROM Opportunity 
										 WHERE PSR_Pre_Sales_Risk_Opportunity_Type__c = :GlobalConstants.RISK_ORDER AND StageName = 'In Execution']);
	}
	
	/****************************************
	* Name : execute
	* Description : Execution of the batch
	*****************************************/
	global void execute(Database.BatchableContext BC, List<Opportunity> psros)
	{	
		Set<String> psroCurrencies = new Set<String>();
		Map<String,Decimal> datedRatesMap = new Map<String,Decimal>();
		try
		{		 
			for(Opportunity psro : psros){
				psroCurrencies.add(psro.CurrencyIsoCode);
			}

			for (Dated_Exchange_Rates__c ratecollect : OpportunityTriggerHelper_PreSales.getDatedExchangeRates(psroCurrencies))
			{
				datedRatesMap.put(ratecollect.CurrencyIsoCode, ratecollect.Exchange_Rate__c);
			}
			
			for(Opportunity psro : psros) {
				Decimal costValue = 0.0;
				Decimal datedRate = datedRatesMap.get(psro.CurrencyIsoCode);
				if(datedRate == null) continue;
				String market = mapMarketUnit_Market.containsKey(psro.Org_L5__c) ? mapMarketUnit_Market.get(psro.Org_L5__c) : psro.Org_L4__c;
				//starting with NI - FN
				String keyFilter = market+GlobalConstants.BackSlash+GlobalConstants.BU_NI_FN;
				if(psro.PSR_Cost_BU_NI_FN__c != null && updatedTHValMap.containsKey(keyFilter)){
					costValue = (returnValueOfField(psro.PSR_Cost_BU_NI_FN__c)).divide(datedRate,2,System.RoundingMode.HALF_UP) ;
					updatedTHValMap.put(keyFilter, updatedTHValMap.get(keyFilter)+costValue);
				}
				//checking NI - IPRTG
				keyFilter = market+GlobalConstants.BackSlash+GlobalConstants.BU_NI_IPRTG;
				if(psro.PSR_Cost_BU_NI_IPRTG__c != null && updatedTHValMap.containsKey(keyFilter)){
					costValue = (returnValueOfField(psro.PSR_Cost_BU_NI_IPRTG__c)).divide(datedRate,2,System.RoundingMode.HALF_UP) ;
					updatedTHValMap.put(keyFilter, updatedTHValMap.get(keyFilter)+costValue);
				}
				//checking NI - OPTICS
				keyFilter = market+GlobalConstants.BackSlash+GlobalConstants.BU_NI_OPTICS;
				if(psro.PSR_Cost_BU_NI_OPTICS__c != null && updatedTHValMap.containsKey(keyFilter)){
					costValue = (returnValueOfField(psro.PSR_Cost_BU_NI_OPTICS__c)).divide(datedRate,2,System.RoundingMode.HALF_UP) ;
					updatedTHValMap.put(keyFilter, updatedTHValMap.get(keyFilter)+costValue);
				}
				//checking NI (if active)
				keyFilter = market+GlobalConstants.BackSlash+GlobalConstants.BG_NI;
				if(psro.PSR_Cost_BG_NI__c != null && updatedTHValMap.containsKey(keyFilter)){
					costValue = (returnValueOfField(psro.PSR_Cost_BG_NI__c)).divide(datedRate,2,System.RoundingMode.HALF_UP) ;
					updatedTHValMap.put(keyFilter, updatedTHValMap.get(keyFilter)+costValue);
				}
				//checking CNS
				keyFilter = market+GlobalConstants.BackSlash+GlobalConstants.BG_CNS;
				if(psro.PSR_Cost_BG_CNS__c != null && updatedTHValMap.containsKey(keyFilter)){
					costValue = (returnValueOfField(psro.PSR_Cost_BG_CNS__c)).divide(datedRate,2,System.RoundingMode.HALF_UP) ;
					updatedTHValMap.put(keyFilter, updatedTHValMap.get(keyFilter)+costValue);
				}
				//checking MN
				keyFilter = market+GlobalConstants.BackSlash+GlobalConstants.LEAD_BG_MN;
				if(psro.PSR_Cost_BG_MN__c != null && updatedTHValMap.containsKey(keyFilter)){
					costValue = (returnValueOfField(psro.PSR_Cost_BG_MN__c)).divide(datedRate,2,System.RoundingMode.HALF_UP) ;
					updatedTHValMap.put(keyFilter, updatedTHValMap.get(keyFilter)+costValue);
				}
			}

		}
		catch(Exception ex)
		{	
			ExceptionHandler.addException(ex, GlobalConstants.Batch_CalculateCurrentValueforPSRO, GlobalConstants.Batch_CalculateCurrentValueforPSRO);
		}	
	}
	
	/****************************************
	* Name : finish
	* Description : Logic to be performed when finished all processing all rows
	*****************************************/
	global void finish(Database.BatchableContext BC)
	{	
		try
		{
						
			for(String key : updatedTHValMap.KeySet()){
				if(thresholdsMap.containsKey(key)){
					thresholdsMap.get(key).Current_value__c = updatedTHValMap.get(key);
				}
			}
			for(PSRO_Market_Threshold__c threshold : thresholdsMap.values())
			{
				if(threshold.Current_value__c > threshold.Threshold_Value__c && !threshold.Value_exceeded__c) {
					threshold.Value_exceeded__c = true;
					thresholdsExceeded.add(threshold.Id);
				} else if (threshold.Current_value__c <= threshold.Threshold_Value__c && threshold.Value_exceeded__c) {
					threshold.Value_exceeded__c = false;
					thresholdsExceeded.remove(threshold.Id);
				}
			}
			
			Database.update(thresholdsMap.values());
			
			if(!thresholdsExceeded.isEmpty()){
				EmailTemplate et = [SELECT Id FROM EmailTemplate WHERE developerName =:Label.NF_ThresholdExceededNotification LIMIT 1];		  
				List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
				Set<String> roleList = new Set<String>(Label.PSRO_Threshold_send_Mail.split(';'));
				List<Sales_Role__c> salesRoleList = [Select Id, BG__c, O__c, User__C from Sales_Role__c where Role_Code__c in :roleList];
				for(Id thresholdId : thresholdsExceeded)
				{
					PSRO_Market_Threshold__c threshold = thresholdsMap.get(thresholdId);
					for(Sales_Role__c salesRole : salesRoleList)
					{
						if(salesRole.BG__C == threshold.Business_Group__c || salesRole.BG__C == threshold.Business_Unit__c)
						{
							Messaging.SingleEmailMessage newEmail = new Messaging.SingleEmailMessage();
							newEmail.setWhatId(threshold.Id);
							newEmail.setTargetObjectId(salesRole.User__c);
							newEmail.setTemplateId(et.Id);
							newEmail.setSaveAsActivity(false);
							mailList.add(newEmail);
						}
					}
				}
				
				if(!mailList.isEmpty() && !Test.isRunningTest()){
					system.debug('Send mail: ' + mailList);
					Messaging.SendEmailResult[] results = Messaging.sendEmail(mailList);  
					system.debug('Send mail results: ' + results); 
				}
			}
		}
		catch(Exception ex)
		{	
			ExceptionHandler.addException(ex, GlobalConstants.Batch_CalculateCurrentValueforPSRO, GlobalConstants.Batch_CalculateCurrentValueforPSRO);
		}
	}
	
	/****************************************
	* Name : returnValueOfField
	* Description : Util method to check if a value is null
	*****************************************/
	public static Decimal returnValueOfField(Decimal fieldValue){
		return fieldValue == null ? 0 : fieldValue;	   
	}
}