/**************************************** 
 * Class Name : Batch_CPOLineItems 
 * Created Date: 15 Nov 18
 * Created By : Accenture
 * Last Modified by:  
 * Last Modified Date:  
 * Description : Batch used to update quantities on CPO Line Items
 * Test Class: 
 *****************************************/
global class Batch_CPOItems implements Database.Batchable<sObject>, Database.Stateful {
	Map<String, Commercial_Entitlement__c> soldToPartyProductEntitlementMap = new Map<String, Commercial_Entitlement__c>();
	Map<String, Commercial_Entitlement__c> soldToPartyProductEntitlementMap2 = new Map<String, Commercial_Entitlement__c>();
   /******************************
	*Method Name: Batch_CPOItems
	*Description: Constructor for batch class
	*Parameters:  N.A.
	********************************/
	public Batch_CPOItems(){		  
	}
   /******************************
	*Method Name: start
	*Description: Retrives all CPO Items  to be processed by the batch
	*Parameters:  N.A.
	********************************/
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([SELECT Id, Apttus_Config2__StartDate__c, Apttus_Config2__Quantity__c, Apttus_Config2__EndDate__c, Authorised_Quantity__c, Available_Quantity__c,Consumed_Quantity__c, Pending_Quantity__c, Commercial_Entitlement_Status__c, Quantity_Batch_Update__c, Non_Consumed_Quantity__c, Commercial_Entitlement__c from Apttus_Config2__CustomerPOItem__c where ((Apttus_Config2__StartDate__c = TODAY and Commercial_Entitlement_Status__c = 'Pending') OR (Apttus_Config2__EndDate__c < TODAY and Commercial_Entitlement_Status__c = 'Entitled')) AND Quantity_Batch_Update__c = null]);
	}
   /******************************
	*Method Name: execute
	*Description: update quantities on various CPO Items
	*Parameters:  N.A.
	********************************/
	global void execute(Database.BatchableContext BC, List<Apttus_Config2__CustomerPOItem__c>  cpoItems)  {
		try{
		system.debug('cpoItems>>'+cpoItems);
		system.debug('Inside execute');
		List<Apttus_Config2__CustomerPOItem__c> entitledCPO = new List<Apttus_Config2__CustomerPOItem__c>();
		List<Apttus_Config2__CustomerPOItem__c> expiredCPO = new List<Apttus_Config2__CustomerPOItem__c>();
		Map<Id, List<Apttus_Config2__CustomerPOItem__c>> cpoEntitlementmap = new Map<Id, List<Apttus_Config2__CustomerPOItem__c>> ();
		List<Apttus_Config2__CustomerPOItem__c> cpoList;
		Map<Id, Commercial_Entitlement__c> entitlementMap = new Map<Id, Commercial_Entitlement__c>();
		List<Commercial_Entitlement__c> updateEntitlement = new List<Commercial_Entitlement__c>();
		
		
		for (Apttus_Config2__CustomerPOItem__c item: cpoItems )
		{   
			if (cpoEntitlementmap.containsKey(item.Commercial_Entitlement__c)) 
			{
				cpoList = new List <Apttus_Config2__CustomerPOItem__c> ();
				cpoList = cpoEntitlementmap.get(item.Commercial_Entitlement__c);
				cpoList.add(item);
				cpoEntitlementmap.put(item.Commercial_Entitlement__c, cpoList);
			} else {
				cpoList = new List <Apttus_Config2__CustomerPOItem__c> ();
				cpoList.add(item);
				cpoEntitlementmap.put(item.Commercial_Entitlement__c, cpoList);
			}
		}		   
		
		for(Commercial_Entitlement__c entitlement: [SELECT id,Authorised_Quantity__c,Pending_Quantity__c,Non_Consumed_Quantity__c,Sold_To_Party__c,Product_Name__c, Temp_Authorised_Quantity__c, Consumed_Quantity__c from Commercial_Entitlement__c where id in :cpoEntitlementmap.keyset() Limit :(Limits.getLimitQueryRows()-Limits.getQueryRows()) ])
		{
			entitlementMap.put(entitlement.id,entitlement ); 
		}  
		
		for(Commercial_Entitlement__c entitlement : entitlementMap.values())
		{
			Decimal authorizedQty = 0;
			Decimal nonConsumedQty = 0;
			for(Apttus_Config2__CustomerPOItem__c item : cpoEntitlementmap.get(entitlement.Id) )
			{ 
				if(item.Apttus_Config2__StartDate__c == system.today())
				{
					system.debug('In first if');
				  if(item.Apttus_Config2__Quantity__c == null)
					{
						item.Apttus_Config2__Quantity__c = 0;
					}
					item.Authorised_Quantity__c  = item.Apttus_Config2__Quantity__c;
					authorizedQty += item.Apttus_Config2__Quantity__c;
					item.Commercial_Entitlement_Status__c  = CSWXGlobalConstant.Entitled;
					item.Pending_Quantity__c  = 0;
					//item.Quantity_Batch_Update__c = system.today();
					entitledCPO.add(item);
				}
				else if(item.Apttus_Config2__EndDate__c <= system.today() )
				{
					system.debug('Inside 2nd if');
					item.Commercial_Entitlement_Status__c  = CSWXGlobalConstant.Expired ;
					item.Quantity_Batch_Update__c = system.today();
					if(item.Authorised_Quantity__c == null)
					{
						item.Authorised_Quantity__c = 0;	
					} 
					if(item.Consumed_Quantity__c == null)
					{
						item.Consumed_Quantity__c = 0;  
					} 
					item.Non_Consumed_Quantity__c = item.Authorised_Quantity__c - item.Consumed_Quantity__c;
					nonConsumedQty = nonConsumedQty + item.Authorised_Quantity__c - item.Consumed_Quantity__c;
					expiredCPO.add(item);
				}
			}
			if(authorizedQty!=0)
			{
				system.debug('Entitlement1>>'+entitlement+'qty>>'+entitlement.Pending_Quantity__c);
				if(entitlement.Authorised_Quantity__c == null)
				{
					entitlement.Authorised_Quantity__c = 0; 
				}   
				if(entitlement.Pending_Quantity__c == null)
				{
					entitlement.Pending_Quantity__c = 0;	
				}   
				entitlement.Authorised_Quantity__c += authorizedQty;
				entitlement.Pending_Quantity__c -= authorizedQty;
				
				soldToPartyProductEntitlementMap.put(entitlement.Sold_To_Party__c+ CSWXGlobalConstant.dash +entitlement.Product_Name__c,entitlement );
				
				Commercial_Entitlement__c entitlementClone = entitlement.clone();
				soldToPartyProductEntitlementMap2.put(entitlementClone.Sold_To_Party__c + CSWXGlobalConstant.dash + entitlementClone.Product_Name__c,entitlementClone );
			}
			if(nonConsumedQty != 0)
			{
			system.debug('Entitlement2>>'+entitlement+'qty>>'+entitlement.Non_Consumed_Quantity__c);
				if(entitlement.Non_Consumed_Quantity__c == null)
				{
					entitlement.Non_Consumed_Quantity__c = 0;   
				}				   
				entitlement.Non_Consumed_Quantity__c += nonConsumedQty;
			}
			updateEntitlement.add(entitlement);
		}
		system.debug('entitledCPO>>'+entitledCPO);
		//update CPO Items as Entitled
		if(!entitledCPO.isEmpty())
		{
			Database.update(entitledCPO,false);
		}
		 system.debug('expiredCPO>>'+expiredCPO);
		//update CPO Items as Expired
		if(!expiredCPO.isEmpty())
		{
			Database.update(expiredCPO,false);
		}
		  system.debug('updateEntitlement>>'+updateEntitlement);
		//Update corresponding quantities on Entitlement
		if(!updateEntitlement.isEmpty())
		{
			Database.update(updateEntitlement,false);
		}
		}
		catch(Exception ex){
			system.debug('<<Execute Exception>>'+ex);
			ExceptionHandler.addException(ex,CSWXGlobalConstant.BATCH_CPOITEMS ,CSWXGlobalConstant.CPOITEMS_EXECUTE );
		}		 
  } 
   /******************************
	*Method Name: finish
	*Description: calls Batch_DPFulfillment batch to process pending DPs
	*Parameters:  N.A.
	********************************/
	global void finish(Database.BatchableContext BC) {
		try{
		system.debug('Batch1:soldToPartyProductEntitlementMap>>'+soldToPartyProductEntitlementMap);
		system.debug('Batch1:soldToPartyProductEntitlementMap2>>'+soldToPartyProductEntitlementMap2);
	   if(!soldToPartyProductEntitlementMap.isEmpty() && !soldToPartyProductEntitlementMap2.isEmpty()){
			Database.executeBatch(new Batch_DPFulfillment(soldToPartyProductEntitlementMap,soldToPartyProductEntitlementMap2),100);
		}
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.BATCH_CPOITEMS,CSWXGlobalConstant.CPOITEMS_Finish  );
		} 
	}
  
}