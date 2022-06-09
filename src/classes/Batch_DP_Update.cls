/**************************************** 
 * Class Name : Batch_DP_Update 
 * Created Date: 25 Nov 18
 * Created By : Accenture
 * Last Modified by:  
 * Last Modified Date:  
 * Description : Batch used to update quantities on CPO Line Items
 * Test Class: 
 *****************************************/
global class Batch_DP_Update implements Database.Batchable<sObject>, Database.Stateful {
	Set<Id> dpId = new Set<Id>();
	Map<String,Commercial_Entitlement__c> soldToPartyProductEntitlementMap = new Map<String,Commercial_Entitlement__c>();
	Map<Id, Map<Id, Decimal>> swxItem_POItem_Qty = new Map<Id, Map<Id, Decimal>>(); //Map<SWX Item ID, Map<CPO LI Id, Qty Used>>
	Map<Id, List<Apttus_Config2__CustomerPOItem__c>> swxItem_POItem = new Map<Id, List<Apttus_Config2__CustomerPOItem__c>>(); //Map<SWX Item ID, Map<CPO LI Id,CPO LI Record>>
	Map<Id,Apttus_Config2__CustomerPOItem__c> parameterCPOItems = new  Map<Id,Apttus_Config2__CustomerPOItem__c>(); 
 
   /******************************
	*Method Name: Batch_DP_Update
	*Description: Constructor for batch class
	*Parameters:  soldToPartyProductEntitlementMap,swxItem_POItem_Qty,swxItem_POItem,parameterCPOItems
	********************************/ 
	public Batch_DP_Update(Set<Id> dpId, Map<String,Commercial_Entitlement__c> soldToPartyProductEntitlementMap, Map<Id, Map<Id, Decimal>> swxItem_POItem_Qty, Map<Id, List<Apttus_Config2__CustomerPOItem__c>> swxItem_POItem, Map<Id,Apttus_Config2__CustomerPOItem__c> parameterCPOItems ){ 
		this.dpId = dpId;
		this.soldToPartyProductEntitlementMap = soldToPartyProductEntitlementMap;
		this.parameterCPOItems = parameterCPOItems;
		this.swxItem_POItem_Qty = swxItem_POItem_Qty;
		this.swxItem_POItem = swxItem_POItem;
	}
   /******************************
	*Method Name: start
	*Description: Collects all DPs to be used for final processing
	*Parameters:  N.A
	********************************/	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator([SELECT id, SWX_Item_Can_Be_Entitled__c, Total_SWX_Items__c, SWX_Item_Entitled__c, Entitlement_Info__c, SWX_Item_Pending__c, SWX_Item_Cant_Be_Entitled__c from SWx_Upsell_Proposal__c where id in: dpId ]);
	}
   /******************************
	*Method Name: execute
	*Description: execute method for test class
	*Parameters:  N.A
	********************************/ 
	global void execute(Database.BatchableContext BC, List<SWx_Upsell_Proposal__c>  digitalProposal)  {
		system.debug('Batch 3 : Inside Execute');
		system.debug('Batch 3:digitalProposal>>'+digitalProposal);
		List<SWx_Upsell_Items__c> dpSwxList;
		List<SWx_Upsell_Items__c> updateSWXItems = new List<SWx_Upsell_Items__c>();
		List<SWx_Upsell_Proposal__c> updateDP = new List<SWx_Upsell_Proposal__c>();
		Map<Id, List<SWx_Upsell_Items__c>> DP_SWXItemMap = new Map<Id, List<SWx_Upsell_Items__c>> ();
		Map<String,String> mapOfDpIdToCpoId = new Map<String,String>();
		

		try{
		//Collect all SWX Items corresponding to DPs in this chunk
		for(SWx_Upsell_Items__c item : [Select id,SWx_Upsell_Proposal__c,Entitlement_Status_Prioirty__c,Product_Code_Account__c,Acceptance_Initiation_Date__c,Entitlement_Status__c, Temp_Customer_PO_Item__c,Temp_Customer_PO_Item__r.Apttus_Config2__PurchaseOrderId__c, Temp_Entitlement_Status__c , Customer_PO_Item__c,Temp_Commercial_Entitlement__c,Quantity__c,Commercial_Entitlement__c from SWx_Upsell_Items__c where SWx_Upsell_Proposal__c  in :digitalProposal and Temp_Entitlement_Status__c != null order by SWx_Upsell_Proposal__c  Limit :(Limits.getLimitQueryRows()-Limits.getQueryRows()) ])
		{
			//Create Map of DPs and associated SWX Items
			if (DP_SWXItemMap.containsKey(item.SWx_Upsell_Proposal__c)) 
			{
				dpSwxList = new List <SWx_Upsell_Items__c> ();
				dpSwxList = DP_SWXItemMap.get(item.SWx_Upsell_Proposal__c);
				dpSwxList.add(item);
				DP_SWXItemMap.put(item.SWx_Upsell_Proposal__c, dpSwxList);
			} else {
				dpSwxList = new List <SWx_Upsell_Items__c> ();
				dpSwxList.add(item);
				DP_SWXItemMap.put(item.SWx_Upsell_Proposal__c, dpSwxList);
	
			}   
		}
		system.debug('DP_SWXItemMap>>'+DP_SWXItemMap);
		
		
		for(SWx_Upsell_Proposal__c dp : digitalProposal ) //Traverse DP
		{
			system.debug('Total_SWX_Items__c>>'+ dp.Total_SWX_Items__c + 'SWX_Item_Entitled__c>>'+dp.SWX_Item_Entitled__c + 'SWX_Item_Can_Be_Entitled__c>>'+dp.SWX_Item_Can_Be_Entitled__c);
			if((dp.Total_SWX_Items__c - dp.SWX_Item_Can_Be_Entitled__c) == 0) //Check if all SWX Items are 'Can BE Entitled'
			{
				system.debug('Inside if : all SWX = Can Be Entitled');
				for(SWx_Upsell_Items__c swxItem : DP_SWXItemMap.get(dp.Id)) //Update status of all SWX Items
				{
					if( swxItem.Temp_Entitlement_Status__c == CSWXGlobalConstant.CAN_BE_ENTITLED)
					{
					swxItem.Entitlement_Status__c = swxItem.Temp_Entitlement_Status__c;
					swxItem.Temp_Entitlement_Status__c = null;
					updateSWXItems.add(swxItem);
					}
				}
				dp.Entitlement_Info__c = CSWXGlobalConstant.CAN_BE_ENTITLED ;
				updateDP.add(dp);
			}
			else if((dp.Total_SWX_Items__c - dp.SWX_Item_Entitled__c) == 0.0)
			{
				system.debug('Inside Completely Entitled');
				system.debug('Batch 3 : DP_SWXItemMap.get(dp.Id)' +DP_SWXItemMap.get(dp.Id));
				for(SWx_Upsell_Items__c swxItem : DP_SWXItemMap.get(dp.Id))
				{   
					if(swxItem.Temp_Entitlement_Status__c == CSWXGlobalConstant.entitledValue){
						//update SWX Items
			if(!mapOfDpIdToCpoId.containsKey(swxItem.SWx_Upsell_Proposal__c)){
		mapOfDpIdToCpoId.put(swxItem.SWx_Upsell_Proposal__c,swxItem.Temp_Customer_PO_Item__r.Apttus_Config2__PurchaseOrderId__c);	
			}			
						swxItem.Entitlement_Status__c = swxItem.Temp_Entitlement_Status__c;
						swxItem.Temp_Entitlement_Status__c = null;
						swxItem.Customer_PO_Item__c = swxItem.Temp_Customer_PO_Item__c;
						swxItem.Temp_Customer_PO_Item__c = null;
						swxItem.Commercial_Entitlement__c = swxItem.Temp_Commercial_Entitlement__c;
						swxItem.Temp_Commercial_Entitlement__c = null;			
						updateSWXItems.add(swxItem);
					
					//Update Entitlement Map
					 soldToPartyProductEntitlementMap.get(swxItem.Product_Code_Account__c).Consumed_Quantity__c = soldToPartyProductEntitlementMap.get(swxItem.Product_Code_Account__c).Consumed_Quantity__c + swxItem.Quantity__c;
					//update CPO Items
					for( Apttus_Config2__CustomerPOItem__c cpoItem : swxItem_POItem.get(swxItem.Id))
				   {
						parameterCPOItems.get(cpoItem.Id).Consumed_Quantity__c = parameterCPOItems.get(cpoItem.Id).Consumed_Quantity__c + (swxItem_POItem_Qty.get(swxItem.Id)).get(cpoItem.Id); 
				   }
				   } 
				}
					//update DP
					dp.Entitlement_Info__c =  CSWXGlobalConstant.entitledValue;
					dp.Proposal_Status__c = CSWXGlobalConstant.proposalCloseValidate;
					dp.Upsell_Status__c = CSWXGlobalConstant.VALIDATED;
		dp.PO__c=mapOfDpIdToCpoId.get(dp.Id);
					updateDP.add(dp);
					
				
			}
		   else if((dp.Total_SWX_Items__c - dp.SWX_Item_Can_Be_Entitled__c > 0 && dp.Total_SWX_Items__c - dp.SWX_Item_Cant_Be_Entitled__c	> 0) || (dp.Total_SWX_Items__c - dp.SWX_Item_Entitled__c > 0 && dp.Total_SWX_Items__c - dp.SWX_Item_Pending__c > 0) ) 
			{
				system.debug('Inside if : all SWX != Can Be Entitled or entitled');
				for(SWx_Upsell_Items__c swxItem : DP_SWXItemMap.get(dp.Id))
				{
					if( swxItem.Temp_Entitlement_Status__c == CSWXGlobalConstant.CAN_BE_ENTITLED)
					{
						swxItem.Temp_Entitlement_Status__c = null; //Clear out temp variables
						updateSWXItems.add(swxItem);
					}
					if( swxItem.Temp_Entitlement_Status__c == CSWXGlobalConstant.entitledValue)
					{
					swxItem.Temp_Entitlement_Status__c = null;
					swxItem.Temp_Customer_PO_Item__c = null;
					swxItem.Temp_Commercial_Entitlement__c = null;
					updateSWXItems.add(swxItem);
					}
				}
			} 
			
		}
		if(!updateSWXItems.isEmpty()){
			system.debug('Batch 3 : updateSWXItems>>'+updateSWXItems);
			Database.update(updateSWXItems,false);
		}
		if(!updateDP.isEmpty()){
			system.debug('Batch 3 : updateDP>>'+updateDP);
			Database.update(updateDP,false);
		}
	
		}
	   
		catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.BATCH_DP_UPDATE,CSWXGlobalConstant.BATCH_DP_UPDATE_EXECUTE );
		}
	}
   /******************************
	*Method Name: finish
	*Description: finish method for test class
	*Parameters:  N.A
	********************************/ 
	global void finish(Database.BatchableContext BC) {
		try{
		//Update Entitlememts
			if(!soldToPartyProductEntitlementMap.values().isEmpty()){
				system.debug('Batch 3 : soldToPartyProductEntitlementMap>>'+soldToPartyProductEntitlementMap);
				Database.update(soldToPartyProductEntitlementMap.values(),false);
			}  
			//Update CPO LI
			if(!parameterCPOItems.values().isEmpty()){
				system.debug('Batch 3 : parameterCPOItems>>'+parameterCPOItems);
				Database.update(parameterCPOItems.values(),false);
			}
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.BATCH_DP_UPDATE,CSWXGlobalConstant.BATCH_DP_UPDATE_FINISH );
		}	   
	}
  
}