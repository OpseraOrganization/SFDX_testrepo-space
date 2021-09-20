/****************************************
* Class Name : OifBatchUpdate 
* Created Date: 14 December 2016
* Created By : Accenture
* Last Modified by: HCL Technologies 
* Last Modified Date: 10 Jan 2021 
* Description : Update the OIF object of relevant 'OIF Value EUR' as per the new currency rate
* Test Class: OifBatchUpdateTest
*****************************************/

global inherited sharing class OifBatchUpdate implements Database.Batchable<sObject>, Database.Stateful
{  
	List<Order_Intake_Forecast__c> updatelist =new  List<Order_Intake_Forecast__c>();
	List<Order_Intake_Forecast__c> notupdatinglist= new  List<Order_Intake_Forecast__c>();
	
	Map<String,Decimal> todayrecords= new Map<String,Decimal> ();
	Map<String,Decimal> Loadrecords= new Map<String,Decimal> ();
	List<Dated_Exchange_Rates__c> allrecords=new List<Dated_Exchange_Rates__c>();
	Map<String,String> Picklist= new Map<String,String>();
	set<ID> Opptyid =new Set<ID>();
	Set<String> missedCurrency =new  Set<String>();
	Date todayDate =Date.Today();
	Date DERdate;
	Set<ID> DERPeriodID= New Set<ID>();
	Map<String,String> CurrencyCode = new  Map<String,String>();
	
	/********************
	*Method Name:batchoifCurrencyUpdate
	*Parameter:List<Dated_Exchange_Rates__c > records
	*Description: Collecting today dated records
	*******************/
	
	Public  OifBatchUpdate (List<Dated_Exchange_Rates__c > records)		
	{ 
		try
		{
			for(Dated_Exchange_Rates__c datelist:records)
			{
				picklist.put(datelist.CurrencyIsoCode,datelist.CurrencyIsoCode);
				allrecords.add(datelist);
				todayrecords.put(datelist.CurrencyIsoCode,datelist.Exchange_Rate__c);
				Loadrecords.put(datelist.CurrencyIsoCode,datelist.Exchange_Rate__c);
				CurrencyCode.put(datelist.CurrencyIsoCode,datelist.CurrencyIsoCode);
				DERPeriodID.add(datelist.DER_Period__c);
				
				if(datelist.CurrencyIsoCode.equalsignorecase(GlobalConstants.USD))
				{
					Schema.DescribeFieldResult fieldResult = Order_Intake_Forecast__c.CurrencyIsoCode.getDescribe();	
					List<Schema.picklistEntry> AllCurrencycode = fieldResult.getPicklistValues(); 
					
					for(Schema.PicklistEntry Code :AllCurrencycode)
						picklist.put(Code.getValue(),Code.getValue());
				}
			}
			
			for(String Currencycodes:picklist.keyset())
			{
				IF(todayrecords.get(Currencycodes)==Null)
					missedCurrency.add(Currencycodes);
			}
			
			// USD data is not in the Map  
			if(!missedCurrency.IsEmpty())
			{
				// active period info
				List <Nokia_Financial_Calendar__c> currentPeiod = [select id, name, Start_Date__c ,End_Date__c from Nokia_Financial_Calendar__c Where Current_Period__c = True ORDER BY End_Date__c ASC LIMIT 1];
				
				//collect the data as per the active period info
				for(Dated_Exchange_Rates__c USDlist:[select Id, CurrencyIsoCode,DER_Period__c,DER_Start_Date__c,DER_Period__r.End_Date__c , Exchange_Rate__c, Start_Date__c from Dated_Exchange_Rates__c where  CurrencyIsoCode=:missedCurrency  AND  (DER_Period__c=:currentPeiod.get(0).id OR DER_Period__r.End_Date__c>=:todayDate) Order By DER_Start_Date__c ASC  LIMIT: Limits.getLimitQueryRows()])
				{
					todayrecords.put(USDlist.CurrencyIsoCode,USDlist.Exchange_Rate__c);
				}
			}
		}
		catch (Exception ex) 
		{  
			ExceptionHandler.addException(ex, GlobalConstants.BATCH_OIF_CURRENCY_UPDATE, GlobalConstants.BATCH_EXECUTE);
		} 
	}
	
	
	/********************
	*Method Name:start
	*Parameter:Database.BatchableContext BC
	*Description:Collect the  today updated records
	*******************/
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
		for(Nokia_Financial_Calendar__c NFCPeriod:[select id,Start_Date__c,End_Date__c from Nokia_Financial_Calendar__c where id=:DERPeriodID LIMIT 1])
			DERdate=NFCPeriod.Start_Date__c;
		
		return Database.getQueryLocator([SELECT Id,Opportunity__c,CurrencyIsoCode,BusinessLine__c,OIF_Value_USD__c,OIF_Value__c,OIF_Value_EUR__c,NFC_Start_Date__c,POPlanReceipt__c FROM Order_Intake_Forecast__c where CurrencyIsoCode=:picklist.keyset()  AND  (POPlanReceipt__r.Start_Date__c>=:DERDate)  AND OIF_Value__c!=0 AND OIF_Value__c !=Null AND BusinessLine__c != NULL order by createddate DESC]);
	}
	
	
	/********************
	*Method Name:execute
	*Parameter: BC,OifUpdate
	*Description:Update the OIF EUR value with new rate 
	*******************/
	global void execute(Database.BatchableContext BC, List<Order_Intake_Forecast__c>  oifUpdate)  
	{
		Map<Id,Order_Intake_Forecast__c> OIFMapUpdate =new  Map<Id,Order_Intake_Forecast__c>();
		Set<ID> Opptyid =new Set<ID>();
		try
		{
			// collect the today records
			for(Order_Intake_Forecast__c oifconvert :oifUpdate)
			{
				if(!oifconvert.CurrencyIsoCode.equalsignorecase(GlobalConstants.EUR) && Loadrecords.get(oifconvert.CurrencyIsoCode)<>Null && oifconvert != NULL && todayrecords.get(oifconvert.CurrencyIsoCode) != NULL )
				{
					oifconvert.OIF_Value_EUR__c = (oifconvert.OIF_Value__c/(Loadrecords.get(oifconvert.CurrencyIsoCode))).setScale(2);
					Opptyid.add(oifconvert.Opportunity__c);
				}
				
				if(todayrecords.get(GlobalConstants.USD)<>NUll && todayrecords.get(oifconvert.CurrencyIsoCode)<>Null && oifconvert.CurrencyIsoCode<>GlobalConstants.EUR && oifconvert.CurrencyIsoCode<>GlobalConstants.USD )
				{
					oifconvert.OIF_Value_USD__c=((oifconvert.OIF_Value__c/(todayrecords.get(oifconvert.CurrencyIsoCode)))*todayrecords.get(GlobalConstants.USD)).setScale(2);
					Opptyid.add(oifconvert.Opportunity__c);					
				}
				if(oifconvert.CurrencyIsoCode.equalsignorecase(GlobalConstants.EUR) && todayrecords.get(GlobalConstants.USD)<>NUll)
				{
					oifconvert.OIF_Value_USD__c=(oifconvert.OIF_Value__c*todayrecords.get(GlobalConstants.USD)).setScale(2);
					Opptyid.add(oifconvert.Opportunity__c);
				}
				
				if(oifconvert.CurrencyIsoCode.equalsignorecase(GlobalConstants.EUR) && Loadrecords.get(GlobalConstants.USD)<>Null )
				{
					oifconvert.OIF_Value_USD__c=(oifconvert.OIF_Value__c*Loadrecords.get(GlobalConstants.USD)).setScale(2);
					Opptyid.add(oifconvert.Opportunity__c);
				}
				OIFMapUpdate.put(oifconvert.id,oifconvert);  
			}
			
			if(!OIFMapUpdate.isEmpty()){
				
				List<Database.saveResult> srs = Database.update(OIFMapUpdate.values(),false);
				ExceptionHandler.addExceptionForOIFBtach(OIFMapUpdate.values(), srs);
			}  
			
			// updating the Oppty unweighted amount 
			if(Opptyid.size()>0)
			{
				OpportunityTriggerHelper OpptTrigHelper = new OpportunityTriggerHelper();
				OpptTrigHelper.BatchCurrenychange(OpptyID);
			}			
		}   
		catch (Exception ex) 
		{  ExceptionHandler.addException(ex, GlobalConstants.BATCH_OIF_CURRENCY_UPDATE, GlobalConstants.BATCH_EXECUTE);
		 
		} 
	}
	
	/********************
	*Method Name:finish
	*Parameter:BC
	*Description:No Operation here 
	*******************/	
	global void finish(Database.BatchableContext BC) {
	}
}