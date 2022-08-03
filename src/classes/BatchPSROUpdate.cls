/****************************************
 * Class Name : BatchPSROUpdate
 * Created Date: 05 Dec 2019
 * Created By : Sudha Kumari
 * Last Modified by: 
 * Last Modified Date:  
 * Description : 
 * Test Class: BatchPSROUpdateTest
 *****************************************/

global class BatchPSROUpdate implements Database.Batchable<sObject>, Database.Stateful {
  Map<String,Decimal> Loadrecords = new Map<String,Decimal> ();
  Map<String,String> Picklist = new Map<String,String>();
  Set<ID> Opptyid = new Set<ID>();
  Date DERdate;
  Set<ID> DERPeriodID = New Set<ID>();
  Map<Id,Opportunity> failedRecords =new  Map<Id,Opportunity>();
  Integer totalProcessedRecords = 0;
  Id oppRecordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Pre-Sales Risk Opportunity').getRecordTypeId();
  Id oppRecordTypeIdReadOnly = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('Pre-Sales Risk Opportunity (read only)').getRecordTypeId();
  

	public BatchPSROUpdate(List<Dated_Exchange_Rates__c > records){
		try{
			for(Dated_Exchange_Rates__c datelist:records){
				Loadrecords.put(datelist.CurrencyIsoCode,datelist.Exchange_Rate__c);
				DERPeriodID.add(datelist.DER_Period__c);
			if(datelist.CurrencyIsoCode.equalsignorecase(GlobalConstants.EUR)){
					picklist.put(datelist.CurrencyIsoCode,datelist.CurrencyIsoCode);
					
			}
		}   
			
		}  catch (Exception ex){  
			ExceptionHandler.addException(ex, GlobalConstants.BatchPSROUpdate, GlobalConstants.START);				
		}			  
	}
	
  global Database.QueryLocator start(Database.BatchableContext BC) {
	for(Nokia_Financial_Calendar__c NFCPeriod : [select id,Start_Date__c,End_Date__c from Nokia_Financial_Calendar__c where id=:DERPeriodID LIMIT 1]){
		DERdate = NFCPeriod.Start_Date__c;
		
	}
	return Database.getQueryLocator([SELECT Id,Name,CurrencyIsoCode,PSR_Total_Sales_Value_In_Euro__c,PSR_Total_Cost_In_Euro__c,PSR_Total_Cost_in_Local_Currency__c,PSR_Total_Sales_Value_in_Local_Currency__c FROM Opportunity WHERE (RecordTypeId  =: oppRecordTypeId or RecordTypeId  =: oppRecordTypeIdReadOnly) and stagename  != 'Cancelled' and stagename  != 'Completed' and CurrencyIsoCode != 'EUR']);   
  }

  global void execute(Database.BatchableContext BC, List<opportunity> oppUpdate){
	List<opportunity> Opptyid =new List<opportunity>();
	try{
	  for(Opportunity oppconvert : oppUpdate){
		 If(oppconvert.currencyISOCODE <> GlobalConstants.EUR && oppconvert != NULL){
			if (Loadrecords.get(oppconvert.currencyISOCODE) <> Null && oppconvert != NULL){
				if(oppconvert.PSR_Total_Cost_In_Euro__c <> 0 && oppconvert.PSR_Total_Cost_In_Euro__c <> Null){
					oppconvert.PSR_Total_Cost_In_Euro__c = (oppconvert.PSR_Total_Cost_in_Local_Currency__c/Loadrecords.get(oppconvert.currencyISOCODE)).setScale(2);
					oppconvert.Last_Batch_Update_Period__c = BC.getJobId();
				}
				if(oppconvert.PSR_Total_Sales_Value_In_Euro__c <> 0 && oppconvert.PSR_Total_Sales_Value_In_Euro__c <> Null){
					oppconvert.PSR_Total_Sales_Value_In_Euro__c = (oppconvert.PSR_Total_Sales_Value_in_Local_Currency__c/Loadrecords.get(oppconvert.currencyISOCODE)).setScale(2);
					oppconvert.Last_Batch_Update_Period__c = BC.getJobId();
				}
			Opptyid.add(oppconvert);
			}
	  }	
	  
	  if(!Opptyid.isEmpty()){
			totalProcessedRecords = totalProcessedRecords + Opptyid.size();
			List<Database.saveResult> srs = Database.update(Opptyid,false);
			ExceptionHandler.addExceptionForPSROBatch(Opptyid, srs);
			for( opportunity updatedOpp : [SELECT Id,Last_Batch_Update_Period__c,CurrencyIsoCode,Name,PSR_Total_Cost_In_Euro__c,PSR_Total_Sales_Value_In_Euro__c FROM opportunity WHERE id in: Opptyid])
			{
				if((updatedOpp.Last_Batch_Update_Period__c == null) || (updatedOpp.Last_Batch_Update_Period__c != BC.getJobId())){
				
					failedRecords.put(updatedOpp.id,updatedOpp);
				}
			}  
	   }
	  }
	}catch (Exception ex){  
		ExceptionHandler.addException(ex, GlobalConstants.BatchPSROUpdate, GlobalConstants.BATCH_EXECUTE);
	} 
   
	
  }
	
  global void finish(Database.BatchableContext BC) {
	   List<opportunity> updatedClosedRecords = new List<opportunity>();
	   for( opportunity updatedOPP : [SELECT Id,
									 Name,
									 Last_Batch_Update_Period__c,
									 CurrencyIsoCode,
									 PSR_Total_Cost_In_Euro__c,
									 PSR_Total_Sales_Value_In_Euro__c
									 FROM opportunity 
									 WHERE Last_Batch_Update_Period__c =: BC.getJobId() and (RecordTypeId  =: oppRecordTypeId or RecordTypeId  =: oppRecordTypeIdReadOnly) and (stagename  = 'Cancelled' or stagename  = 'Completed')])
	   {
			updatedClosedRecords.add(updatedOPP);  
	   }
		   Opportunity_Exception_Email.sendEmail(failedRecords, BC.getJobId(),totalProcessedRecords, GlobalConstants.BatchPSROUpdate, updatedClosedRecords);
	}
  
}