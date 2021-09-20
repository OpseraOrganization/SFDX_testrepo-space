/****************************************
* Class Name : OrderIntakeHandler
* Created Date: 11 November 2016
* Created By : Accenture
* Last Modified by: HCL Technologies
* Last Modified Date: 10 Jan 2021
* Description : Handle the sequence of the OrderIntakeHelper
* Test Class: 
*****************************************/
public with sharing class OrderIntakeHandler
{
	public static boolean insertExecuted = GlobalConstants.VALUE_FALSE ;
	public static boolean updateExecuted = GlobalConstants.VALUE_FALSE ;
	public static Integer CounterVar=0;
	/********************
	*Method Name: beforeOperation
	*Parameter: Order_Intake_Forecast__c List
	*Description: Used to update current period based Intake Forecast List 
	*******************/
	public static void BeforeInsert(List<Order_Intake_Forecast__c> orderIntakeList){  
		try
		{
			if(!orderIntakeList.isEmpty() && !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
			{
				Set<Id> opportunityIDSet= new Set<Id>();
				Map<Id,Opportunity> opportunityDataMap = new Map<Id,Opportunity>();
				Map<Id, opportunity> commupsellmap_oppty = new Map<Id,Opportunity>();
				List<Order_Intake_Forecast__c> OIFOriganalLine =new List<Order_Intake_Forecast__c>();
				List<Order_Intake_Forecast__c> NonAllocationOIF =new List<Order_Intake_Forecast__c>();
				 
				//Calling this function to get all opportunties associated with order intake list
				//PLEASE USE THIS OPPORTUNITYIDLIST AND AVOID DOING A FOR LOOP IN HELPER
				opportunityIDSet = OrderIntakeHepler.getOpportuntityID(orderIntakeList);
		
				//Retrive opportunity data for the oif's
				//pass this opportunity data to helper methods to reduce soql for oportunity in helper
				//PLEASE USE THIS OPPORTUNITYDATA AND AVOID DOING A SOQL LOOP IN HELPER
				if(opportunityIDSet <> null && opportunityIDSet.size() > 0)
				{
					opportunityDataMap = OrderIntakeHepler.getOpportuntityData(opportunityIDSet);
				}
		
				for(Order_Intake_Forecast__c OIFinsert :orderIntakeList)
				{
					if(OIFinsert.Allocation__c==FALSE &&((OIFinsert.Forecast_Category__c.equalsIgnoreCase(GlobalConstants.BOOKED)) || (OIFinsert.Forecast_Category__c.equalsIgnoreCase(GlobalConstants.CANCEL)) || (OIFinsert.Forecast_Category__c.equalsIgnoreCase(GlobalConstants.LOST))))
						OIFOriganalLine.add(OIFinsert);
					if(OIFinsert.Allocation__c==FALSE)
						NonAllocationOIF.add(OIFinsert);
				}
				if(OIFOriganalLine.Size()>0)
					OrderIntakeHepler.updateCurrentPeriod(OIFOriganalLine);
		
				//Check if any of the order intake belongs to committed upsell opportunity by checking the opportunity list
				commupsellmap_oppty = OrderIntakeHepler.checkForCommittedUpsellOppty(opportunityDataMap.values());
				
				//ITBACRM-252 INI	
				OrderIntakeHepler.setOIFtoZeroAfterG5(orderIntakeList, null, opportunityDataMap);
				//ITBACRM-252 END
				OrderIntakeHepler.ChangeCurrency(orderIntakeList,opportunityDataMap);
				OrderIntakeHepler.clearAllocationOIF(orderIntakeList);
				OrderIntakeHepler.updateOIFCurrencyIsoCode(orderIntakeList,opportunityDataMap);
				OrderIntakeHepler.businessLineDataInsert(orderIntakeList,null);
				
		
				/*****Add all committed upsell validations here*************/
				if(commupsellmap_oppty.size() > 0)
				{
					// Throw error if Committed Upsell opportunity dont have Upsell Deal associated
					// By pass the validation for customer users as they dont have access to Oppty and dont use CU Oppty
					//Added check to stop recursive execution of this method
					System.debug('GlobalConstants.isOrderIntakeFirstRun:'+GlobalConstants.isOrderIntakeInsertFirstRun);
					if((GlobalConstants.isOrderIntakeInsertFirstRun) &&
					(!UserInfo.getProfileId().equalsIgnoreCase(GlobalConstants.PROFILE_DS_SALES_CUST)) && 
					(!UserInfo.getProfileId().equalsIgnoreCase(GlobalConstants.PROFILE_DS_CUSTOMERS)) &&
					(orderIntakeList != null && orderIntakeList.size()>0)){			
						 GlobalConstants.isOrderIntakeInsertFirstRun = false;
						 System.debug('orderIntakeList inside upsell validator'+orderIntakeList);
						 OrderIntakeHepler.UpsellDealvalidator(orderIntakeList,commupsellmap_oppty);			
					}
					if(NonAllocationOIF.size() > 0 && OrderIntakeHepler.firstRun_Insert == true && orderIntakeList.size() > 0)
					{
						OrderIntakeHepler.UpsellDelta_OpptyCheckInsert(orderIntakeList,commupsellmap_oppty);
					} 
				}
			}
		} catch (Exception ex) 
		{ ExceptionHandler.addException(ex, GlobalConstants.ORDERINTAKE_HANDLER, GlobalConstants.BEFORE_INSERT);
		} 
	}
	
	/********************
	*Method Name: AfterInsert
	*Parameter: Order_Intake_Forecast__c List
	*Description:  to handle Helper After Insert Opporation 
	*******************/
	public static void AfterInsert(List<Order_Intake_Forecast__c> orderIntakeList)
	{
		List<Order_Intake_Forecast__c> OIFchatter =new List<Order_Intake_Forecast__c>();
		List<Order_Intake_Forecast__c> OIFAfterInsert =new List<Order_Intake_Forecast__c>();
		List<Order_Intake_Forecast__c> OIFRec= new List<Order_Intake_Forecast__c>();
		Set<ID> OpptyId= new Set<ID>();
		
		for(Order_Intake_Forecast__c OIFAfter:orderIntakeList){
			if(!OIFAfter.Allocation__c && !OIFAfter.Modified_by_Owner__c)
			{
	OIFchatter.add(OIFAfter);  
			}
			if(OIFAfter.Allocation__c<>TRUE)
			{
	OpptyId.add(OIFAfter.Opportunity__c);
			}

			OIFAfterInsert.add(OIFAfter);

			if(!OIFAfter.Allocation__c && OIFAfter.Opportuity_Competitor_Count__c==0 && OIFAfter.Competitor_Bypass__c!=True)
	OIFRec.add(OIFAfter);
		}
		if(OIFchatter.size()>0 && !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && (!System.isBatch() && !System.isFuture()  ))
		{
			OrderIntakeHepler.chatterOnInsert(OIFchatter);
			OrderIntakeHandler.insertExecuted = GlobalConstants.VALUE_TRUE ;
		}
		if(!OIFRec.isEmpty() &&  !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && !GlobalConstants.OIF_ERROR_CHECK)
			OrderIntakeHepler.CompetitorErrorCheck(OIFRec);

		if(OpptyId.size()>0 && !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && (!System.isBatch() && !System.isFuture()  ))
		{			
			OpportunityTriggerHelper.Currenychange(OpptyId);
		}
		
		//Requirement 1454, Sales Process
		if(OIFAfterInsert.size()>0 ){
			OrderIntakeHepler.copyOpptyProgramFlagToOif(OIFAfterInsert);
		}
		
		//Support Ticket 12826
		try{
			if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && OIFAfterInsert.size()>0 ){
	OrderIntakeHepler.createAllocationOIF(OIFAfterInsert);
			}
		}catch (Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.ORDERINTAKE_HANDLER, GlobalConstants.BEFORE_INSERT);
		}
	}
	
	/********************
	*Method Name:beforeUpdateCurrency
	*Parameter:oifUpdateList
	*Description: Used to update as per the Latest Exchnage Rate
	*******************/   
	public static void BeforeUpdate(List<Order_Intake_Forecast__c> oifUpdateList,List<Order_Intake_Forecast__c> oifoldvalue ){  

		List<Order_Intake_Forecast__c> Oifperiodupdate =new List<Order_Intake_Forecast__c>();
		List<Order_Intake_Forecast__c> ChangesoifCurrency =new List<Order_Intake_Forecast__c>();
		List<Order_Intake_Forecast__c> ChangesoifBL =new List<Order_Intake_Forecast__c>();
		Map<Id, opportunity> commupsellmap_oppty = new Map<Id,Opportunity>();
		Map<Id,Opportunity> opportunityDataMap = new Map<Id,Opportunity>();
		
		Set<ID> OpptyId= new Set<ID>();
		Set<ID> AllocationID =new Set<ID>();
		Set<Id> opportunityIDSet= new Set<Id>();
		Set<ID> OpptyIdForecastCancleAndLost= new Set<ID>();
		
		try{
			
			if(!oifUpdateList.isEmpty() && !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
			{
	//Calling this function to get all opportunties associated with order intake list
	//PLEASE USE THIS OPPORTUNITYIDLIST AND AVOID DOING A FOR LOOP IN HELPER
	opportunityIDSet = OrderIntakeHepler.getOpportuntityID(oifUpdateList);
	
	for (Integer count = 0; count< oifUpdateList.size(); count++){
		
		// collecting the values when ever the catageory or OIF value changes 
		if (((oifUpdateList[count].Forecast_Category__c!= oifoldvalue[count].Forecast_Category__c &&((oifUpdateList[count].Forecast_Category__c.equalsIgnoreCase(GlobalConstants.BOOKED)) || (oifUpdateList[count].Forecast_Category__c.equalsIgnoreCase(GlobalConstants.CANCEL)) || (oifUpdateList[count].Forecast_Category__c.equalsIgnoreCase(GlobalConstants.LOST))))||  (oifUpdateList[count].POPlanReceipt__c!=oifoldvalue[count].POPlanReceipt__c) ) &&oifUpdateList[count].Allocation__c==FALSE )
			Oifperiodupdate.add(oifUpdateList[count]);
		
		//collecting the Origanal currency update records
		if ((oifUpdateList[count].Forecast_Category__c!= oifoldvalue[count].Forecast_Category__c||(oifUpdateList[count].OIF_Value__c!= oifoldvalue[count].OIF_Value__c) || (oifUpdateList[count].POPlanReceipt__c!=oifoldvalue[count].POPlanReceipt__c)) && !oifUpdateList[count].Allocation__c)
			ChangesoifCurrency.add(oifUpdateList[count]);
		
		
		// collecting the Allocation currency update records
		if ((oifUpdateList[count].Forecast_Category__c!= oifoldvalue[count].Forecast_Category__c||(oifUpdateList[count].OIF_Value__c!= oifoldvalue[count].OIF_Value__c) || (oifUpdateList[count].POPlanReceipt__c!=oifoldvalue[count].POPlanReceipt__c)) && oifUpdateList[count].Allocation__c )
			AllocationID.add(oifUpdateList[count].ID);
		
		//collecting the New BL Info
		if ((oifUpdateList[count].BusinessLine__c!= oifoldvalue[count].BusinessLine__c) &&  (oifUpdateList[count].Total_BL_Allocation__c<=0 || oifUpdateList[count].Total_BL_Allocation__c>0) )
			ChangesoifBL.add(oifUpdateList[count]);
	}
	
	opportunityDataMap = OrderIntakeHepler.getOpportuntityData(opportunityIDSet);
	//ITBACRM-252 INI	
	OrderIntakeHepler.setOIFtoZeroAfterG5(oifUpdateList, oifoldvalue, opportunityDataMap);
	//ITBACRM-252 END			 
				
	//Retrive opportunity data for the oif's
	//pass this opportunity data to helper methods to reduce soql for oportunity in helper
	//PLEASE USE THIS OPPORTUNITYDATA AND AVOID DOING A SOQL IN HELPER
	if((opportunityIDSet <> null && opportunityIDSet.size() > 0) &&
	(ChangesoifCurrency.size() > 0 || GlobalConstants.isOrderIntakeUpdateFirstRun)){
		opportunityDataMap = OrderIntakeHepler.getOpportuntityData(opportunityIDSet);
	}
	
	if(GlobalConstants.isOrderIntakeUpdateFirstRun){
		
		//Check if any of the order intake belongs to committed upsell opportunity by checking the opportunity list
		commupsellmap_oppty = OrderIntakeHepler.checkForCommittedUpsellOppty(opportunityDataMap.values());
		
		if(commupsellmap_oppty.size() > 0)
		{
			// Throw error if Committed Upsell opportunity dont have Upsell Deal associated
			// By pass the validation for customer users as they dont have access to Oppty and dont use CU Oppty
			//Added check to stop recursive execution of this method
			
			if((!UserInfo.getProfileId().equalsIgnoreCase(GlobalConstants.PROFILE_DS_SALES_CUST)) &&		
		 (!UserInfo.getProfileId().equalsIgnoreCase(GlobalConstants.PROFILE_DS_CUSTOMERS))){
	GlobalConstants.isOrderIntakeUpdateFirstRun = false;
	System.debug('After update isOrderIntakeFirstRun'+GlobalConstants.isOrderIntakeUpdateFirstRun);
	OrderIntakeHepler.UpsellDealvalidator(oifUpdateList,commupsellmap_oppty);
		 }
		}
		else
			GlobalConstants.isOrderIntakeUpdateFirstRun = false;
	}
	//calling the period update
	if(!Oifperiodupdate.isEmpty())
		OrderIntakeHepler.updateCurrentPeriod(Oifperiodupdate);
	
	//update the EUR and USD fields as per the period rates
	if(!ChangesoifCurrency.isEmpty())
		OrderIntakeHepler.ChangeCurrency(ChangesoifCurrency,opportunityDataMap);
	
	//update  Allocation Lines EUR and USD fields as per the period rates
	if(!ChangesoifBL.isEmpty())
		OrderIntakeHepler.DeletecloneLines(ChangesoifBL);
	
	//call the future method to update the Oppty amount
	for(Order_Intake_Forecast__c OIFOppty:oifUpdateList){
		if(OIFOppty.Allocation__c==False)
			OpptyId.add(OIFOppty.Opportunity__c);
		if(OIFOppty.Forecast_Category__c == GlobalConstants.CANCEL || OIFOppty.Forecast_Category__c == GlobalConstants.LOST  ){
			OpptyIdForecastCancleAndLost.add(OIFOppty.Opportunity__c);  
			System.debug('Oif No==>'+OIFOppty.Name+'OIFOppty.Forecast_Category__c===>'+OIFOppty.Forecast_Category__c+'==>Opp ID ===> '+OIFOppty.Opportunity__c);	
		}   
		
	}
	
	if(!OpptyId.isEmpty() && (!System.isBatch() && !System.isFuture()))
	{  
		System.debug('Non Future Currenychange Call from Oif handler');
		OpportunityTriggerHelper.Currenychange(OpptyId);
	}	
	if(!OpptyIdForecastCancleAndLost.isEmpty() && (!System.isBatch() && System.isFuture()))
	{   
		CounterVar+=1; 
		if(Limits.getQueueableJobs() > 0){
			System.debug('Inside IF condtion More THAN 1 queable Call');
			String hour = String.valueOf(Datetime.now().hour());
			String min = String.valueOf(Datetime.now().minute()); 
			String ss = String.valueOf(Datetime.now().second() + 4);
			//parse to cron expression
			String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
			System.schedule('ScheduledJob ' + String.valueOf(Math.random()), nextFireTime, new CurrenychangeSchedulable(OpptyIdForecastCancleAndLost));
		}
		else{   
			System.debug('Else condtion Of Only 1 Queable call');	  
			System.enqueueJob( new Currenychangequeueablehelper(OpptyIdForecastCancleAndLost) ); 
		}
	} System.debug('CounterVar'+CounterVar);  
	
	System.debug('No of Queable Jobs========>'+Limits.getQueueableJobs());
			} 
		}
		catch (Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.ORDERINTAKE_HANDLER, GlobalConstants.BEFORE_UPDATE);
		} 
	}
	
	/********************
	*Method Name:BeforeDelete
	*Parameter:oifdeleteList
	*Description: Used to  delete the clone records.
	*******************/   
	public static void BeforeDelete(List<Order_Intake_Forecast__c> oifdeleteList){ 
		
		System.debug('<<<<<Before delete>>>>>>'+oifdeleteList);
		Set<ID> OpptyId =new Set<ID>();
		Set<Id> opportunityIDSet= new Set<Id>();
		Map<Id, opportunity> commupsellmap_oppty = new Map<Id,Opportunity>();
		Map<Id,Opportunity> opportunityDataMap = new Map<Id,Opportunity>();
		Boolean ALLOCATION_LINES_ONLY = true;
		
		try{
			if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
			{
	//Calling this function to get all opportunties associated with order intake list
	//PLEASE USE THIS OPPORTUNITYIDLIST AND AVOID DOING A FOR LOOP IN HELPER
	opportunityIDSet = OrderIntakeHepler.getOpportuntityID(oifdeleteList);
	//check whether delete contains only allocation lines
	for(Order_Intake_Forecast__c OIF:oifdeleteList){
		if(OIF.Allocation__c==False)
		{
			ALLOCATION_LINES_ONLY = false;
			break;
		}
	}
	if(ALLOCATION_LINES_ONLY) System.debug('<<<<<<<<<<<Allcoation lines only>>>>>>>>>>>>>');
	
	if(!ALLOCATION_LINES_ONLY)
	{
		//Retrive opportunity data for the oif's
		//pass this opportunity data to helper methods to reduce soql for oportunity in helper
		//PLEASE USE THIS OPPORTUNITYDATA AND AVOID DOING A SOQL IN HELPER
		//Check neccessary scenarios where this this map is needed
		if((GlobalConstants.isOrderIntakeDeleteFirstRun || OrderIntakeHepler.firstRun_Delete == true) &&
		(opportunityIDSet <> null && opportunityIDSet.size() > 0)){
		 opportunityDataMap = OrderIntakeHepler.getOpportuntityData(opportunityIDSet);
		}
		
		//Check if any of the order intake belongs to committed 
		//upsell opportunity by checking the opportunity list
		commupsellmap_oppty = OrderIntakeHepler.checkForCommittedUpsellOppty(opportunityDataMap.values());
		
		if(commupsellmap_oppty.size() > 0)
		{
			// Throw error if Committed Upsell opportunity dont have Upsell Deal associated
			// By pass the validation for customer users as they dont have access to Oppty and dont use CU Oppty
			// Added check to stop recursive execution of this method
			if((GlobalConstants.isOrderIntakeDeleteFirstRun) &&
		 (!UserInfo.getProfileId().equalsIgnoreCase(GlobalConstants.PROFILE_DS_SALES_CUST)) &&	
		 (!UserInfo.getProfileId().equalsIgnoreCase(GlobalConstants.PROFILE_DS_CUSTOMERS))){
	GlobalConstants.isOrderIntakeDeleteFirstRun = false;
	OrderIntakeHepler.UpsellDealvalidator(oifdeleteList,commupsellmap_oppty);
		 }
			if(OrderIntakeHepler.firstRun_Delete == true)
			{
	system.debug('lstOrderintake'+oifdeleteList);
	if(oifdeleteList.size() > 0 )
		OrderIntakeHepler.UpsellDelta_OpptyCheckDelete(oifdeleteList,commupsellmap_oppty);
			}
		}
		OrderIntakeHepler.DeletecloneLines(oifdeleteList);
	}
	
	
	//OrderIntakeHepler.ErrorcheckforOfferlevel(oifdeleteList,opportunityIDSet);// JOTATR
	// update the Oppty amount
	for(Order_Intake_Forecast__c OIFOppty:oifdeleteList){
		if(OIFOppty.Allocation__c<>TRUE)
			OpptyId.add(OIFOppty.Opportunity__c);
	}
	
	if(OpptyId.size()>0&&GlobalConstants.OPPORTUNITYTRIGGER_CURRENCY_CHANGE==False)
	{
		OpportunityTriggerHelper.Currenychange(OpptyId);
	}
			}
		}
		catch (Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.ORDERINTAKE_HANDLER, GlobalConstants.BEFORE_DELETE);
		}	
	}
	
	/********************
	*Method Name:AfterUpdate
	*Parameter:OIFAfterUpdate
	*Description: Display the Competitor Error Mesage
	*******************/   
	public static void AfterUpdate(List<Order_Intake_Forecast__c> OIFAfterUpdate)
	{ 
		List<Order_Intake_Forecast__c> OIFRec= new List<Order_Intake_Forecast__c>();
		
		try{
			
			for(Order_Intake_Forecast__c OIFInfo:OIFAfterUpdate)
			{
	if(!OIFinfo.Allocation__c && OIFInfo.Opportuity_Competitor_Count__c==0 && OIFinfo.Competitor_Bypass__c!=True)
		OIFRec.add(OIFInfo);
			}
			if(!OIFRec.isEmpty() &&  !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && !GlobalConstants.OIF_ERROR_CHECK)
	OrderIntakeHepler.CompetitorErrorCheck(OIFRec);
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.ORDERINTAKE_HANDLER, GlobalConstants.AFTER_UPDATE);
		}   
	}
	
	/********************
	*Method Name:AfterUpdate
	*Parameter:OIFAfterUpdate
	*Description: add for ticket 12942
	*******************/   
	public static void AfterUpdate(map<Id, Order_Intake_Forecast__c> map_oifId_newOif, map<Id, Order_Intake_Forecast__c> map_oifId_oldOif){ 
		
		try{
			if(!OrderIntakeHandler.insertExecuted && !OrderIntakeHandler.updateExecuted)
			{
	OrderIntakeHepler.chatterOnUpdate(map_oifId_newOif,map_oifId_oldOif);
	OrderIntakeHandler.updateExecuted = GlobalConstants.VALUE_TRUE ;
			}
			
			if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
	OrderIntakeHepler.updateAllocationOIF(map_oifId_newOif, map_oifId_oldOif);
	
	//Support Ticket 12826
	list<Order_Intake_Forecast__c> list_oifs = new list<Order_Intake_Forecast__c>();
	for(String oifId : map_oifId_newOif.keySet()) {
		Order_Intake_Forecast__c oldOIF = map_oifId_oldOif.get(oifId);
		Order_Intake_Forecast__c newOIF = map_oifId_newOif.get(oifId);
		
		if(String.isNotEmpty(oldOIF.BusinessLine__c) && String.isNotEmpty(newOIF.BusinessLine__c) && oldOIF.BusinessLine__c != newOIF.BusinessLine__c) {
			list_oifs.add(newOIF);
		}
	}
	
	if(list_oifs.size() > 0) {
		OrderIntakeHepler.createAllocationOIF(list_oifs);
	}
	//end Support Ticket 12826
			}
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.ORDERINTAKE_HANDLER, GlobalConstants.AFTER_UPDATE);
		}   
	}
	
	/*******************************
	*Method name: BeforeUpdate
	*Description: Before Insert with map as paramater
	*******************************/  
	public static void BeforeUpdate(List<Order_Intake_Forecast__c> oifNewMap,Map<Id,Order_Intake_Forecast__c> oifOldMap)
	{
		list<Order_Intake_Forecast__c> lstOrderintake = new list<Order_Intake_Forecast__c>();
		try
		{	 
			if(oifNewMap <> null && !oifNewMap.isEmpty() && !UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id))
			{
	if(OrderIntakeHepler.firstRun_Update == true)
	{ 
		for(Order_Intake_Forecast__c OpptyOIFData1 : oifNewMap)
		{
			if((!OpptyOIFData1.Allocation__c) &&
		 (OpptyOIFData1.OIF_Value_EUR__c != oifOldMap.get(OpptyOIFData1.id).OIF_Value_EUR__c ||
	OpptyOIFData1.Forecast_Category__c != oifOldMap.get(OpptyOIFData1.id).Forecast_Category__c )){
		lstOrderintake.add(OpptyOIFData1);
	}
		}
		OrderIntakeHepler.iCount++;
		if(lstOrderintake.size() > 0 )
			
			OrderIntakeHepler.UpsellDelta_OpptyCheck(lstOrderintake);
	}
	OrderIntakeHepler.businessLineDataInsert(oifNewMap,oifOldMap);	 
			}			
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.ORDERINTAKE_HANDLER, GlobalConstants.BEFORE_UPDATE);
		}	 
	}
}