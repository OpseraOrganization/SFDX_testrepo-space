/**************************************** 
* Class Name : BatchOifUpdate   
* Created Date: 15 January 2018
* Created By : SDC
* Last Modified by: HCL Technologies 
* Last Modified Date: 10 Jan 2021   
* Description : Seperate the OIF lines by CurrencyIsoCode(Not equal EUR & USD)
* Test Class: BatchOifUpdateTest
*****************************************/

global inherited sharing class BatchOifUpdate  implements Database.Batchable<sObject>, Database.Stateful {
	Map<String,Decimal> Loadrecords = new Map<String,Decimal> ();
	Map<String,String> Picklist = new Map<String,String>();
	Set<ID> Opptyid = new Set<ID>();
	Date DERdate;
	Set<ID> DERPeriodID = New Set<ID>();
	Map<Id,Order_Intake_Forecast__c> failedRecords =new  Map<Id,Order_Intake_Forecast__c>();
	Integer totalProcessedRecords = 0;
	
	public BatchOifUpdate(List<Dated_Exchange_Rates__c > records){
		try{
			for(Dated_Exchange_Rates__c datelist:records){
				Loadrecords.put(datelist.CurrencyIsoCode,datelist.Exchange_Rate__c);
				DERPeriodID.add(datelist.DER_Period__c);
				if(datelist.CurrencyIsoCode <> GlobalConstants.USD && datelist.CurrencyIsoCode <> GlobalConstants.EUR){
					picklist.put(datelist.CurrencyIsoCode,datelist.CurrencyIsoCode);
				}
				
			}
		}catch (Exception ex){  
			ExceptionHandler.addException(ex, GlobalConstants.BATCH_OIF_CURRENCY_UPDATE, GlobalConstants.BATCH_EXECUTE);				
		}			 
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		for(Nokia_Financial_Calendar__c NFCPeriod : [select id,Start_Date__c,End_Date__c from Nokia_Financial_Calendar__c where id=:DERPeriodID LIMIT 1]){
			DERdate = NFCPeriod.Start_Date__c;
		}
		
		return Database.getQueryLocator([SELECT Id,Name,Opportunity__c,CurrencyIsoCode,BusinessLine__c,OIF_Value_USD__c,OIF_Value__c,OIF_Value_EUR__c,NFC_Start_Date__c,POPlanReceipt__r.name FROM Order_Intake_Forecast__c WHERE  CurrencyIsoCode =: picklist.keySet() AND  (POPlanReceipt__r.Start_Date__c>=:DERDate) AND OIF_Value__c !=Null AND BusinessLine__c != NULL order by createddate DESC]);
	}
	
	global void execute(Database.BatchableContext BC, List<Order_Intake_Forecast__c>  oifUpdate) {
		Map<Id,Order_Intake_Forecast__c> OIFMapUpdate =new  Map<Id,Order_Intake_Forecast__c>();
		Set<ID> Opptyid =new Set<ID>();
		try{
			for(Order_Intake_Forecast__c oifconvert :oifUpdate){
				if(Loadrecords.get(oifconvert.CurrencyIsoCode) <> Null && oifconvert != NULL){
					if(oifconvert.OIF_Value__c <> 0){
						oifconvert.OIF_Value_EUR__c = (oifconvert.OIF_Value__c/(Loadrecords.get(oifconvert.CurrencyIsoCode))).setScale(2);
						oifconvert.OIF_Value_USD__c = ((oifconvert.OIF_Value__c/(Loadrecords.get(oifconvert.CurrencyIsoCode)))*Loadrecords.get(GlobalConstants.USD)).setScale(2);
					}
					if(oifconvert.OIF_Value__c == 0){
						oifconvert.OIF_Value_EUR__c = 0;
						oifconvert.OIF_Value_USD__c = 0;
						oifconvert.Last_Batch_Update_Period__c = BC.getJobId();
					}
					Opptyid.add(oifconvert.Opportunity__c);
					
					OIFMapUpdate.put(oifconvert.id,oifconvert); 
					oifconvert.Last_Batch_Update_Period__c = BC.getJobId(); 
				} 
			}
			if(!OIFMapUpdate.isEmpty()){
				totalProcessedRecords = totalProcessedRecords + OIFMapUpdate.size();
				List<Database.saveResult> srs = Database.update(OIFMapUpdate.values(),false);
				ExceptionHandler.addExceptionForOIFBtach(OIFMapUpdate.values(), srs);  
				
				for( Order_Intake_Forecast__c updatedOIF : [SELECT Id,Last_Batch_Update_Period__c,CurrencyIsoCode,OIF_Value_USD__c,OIF_Value__c,OIF_Value_EUR__c FROM Order_Intake_Forecast__c WHERE id in: OIFMapUpdate.keySet()])
				{
					if((updatedOIF.Last_Batch_Update_Period__c == null) || (updatedOIF.Last_Batch_Update_Period__c != BC.getJobId()))
					{
						failedRecords.put(updatedOIF.id,OIFMapUpdate.get(updatedOIF.id));	  
					}
					else 
						if((updatedOIF.OIF_Value_USD__c != OIFMapUpdate.get(updatedOIF.ID).OIF_Value_USD__c ) || (updatedOIF.OIF_Value_EUR__c != OIFMapUpdate.get(updatedOIF.ID).OIF_Value_EUR__c ) )
					{
						failedRecords.put(updatedOIF.id,OIFMapUpdate.get(updatedOIF.id));
					}
				}
			} 
			// updating the Oppty unweighted amount 
			if(Opptyid.size() > 0){
				OpportunityTriggerHelper OpptTrigHelper = new OpportunityTriggerHelper();
				OpptTrigHelper.BatchCurrenychangeDL(OpptyID);
			}
		}catch (Exception ex){  
			ExceptionHandler.addException(ex, GlobalConstants.BATCH_OIF_CURRENCY_UPDATE, GlobalConstants.BATCH_EXECUTE);
		} 
		
	}
	
	global void finish(Database.BatchableContext BC) {
		List<Order_Intake_Forecast__c> pastPeriodRecords = new List<Order_Intake_Forecast__c>();
		for( Order_Intake_Forecast__c updatedOIF : [SELECT Id,
													Name,
													Opportunity__c,
													Last_Batch_Update_Period__c,
													CurrencyIsoCode,
													OIF_Value_USD__c,
													OIF_Value__c,
													OIF_Value_EUR__c,
													POPlanReceipt__r.name
													FROM Order_Intake_Forecast__c 
													WHERE Last_Batch_Update_Period__c =: BC.getJobId()  
													and (POPlanReceipt__r.Start_Date__c<:DERDate)])
		{
			pastPeriodRecords.add(updatedOIF);  
		}
		OIF_Exception_Email.sendEmail(failedRecords, BC.getJobId(),totalProcessedRecords, GlobalConstants.BATCHOIFUPDATE, pastPeriodRecords);
	}
	
}