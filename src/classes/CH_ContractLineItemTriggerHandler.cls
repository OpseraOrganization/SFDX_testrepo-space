/****************************************
* Class Name : CH_ContractLineItemTriggerHandler
* Created Date: 02 September 2018
* Created By : TCS
* Last Modified by: Sónia Reis
* Last Modified Date: 09 October 2019
* Description : Handle the sequence of the ContractLineItemTriggerHelper
* Test Class: CH_ContractLineItemTriggerHelperTest
*****************************************/
public class CH_ContractLineItemTriggerHandler extends TriggerHandler {
	private List<ContractLineItem> oldList;
	private List<ContractLineItem> newList = new List<ContractLineItem>();
	private Map<Id, ContractLineItem> oldMap;
	private Map<Id, ContractLineItem> newMap;
	
	public CH_ContractLineItemTriggerHandler() {
		
			List<ContractLineitem> listConLineItem = new List<ContractLineitem>();
			listConLineItem = CH_ContractLineItemTriggerHelper.getListCHAndSupportServiceContracts((List<ContractLineItem>) Trigger.new,'Cares');
			if(listConLineItem !=null && listConLineItem.size()>0){
				this.newList = listConLineItem;
				
			}
		
		system.debug('### newList---'+newList.size());
		if(newList!=null){
			system.debug('#### insideif--'+newList.size());
		}
		this.newMap  = (Map<Id, ContractLineItem>) Trigger.newMap;
		this.oldList =(List<ContractLineItem>) Trigger.old;
		this.oldMap  = (Map<Id, ContractLineItem>) Trigger.OldMap;		
	}
	
	/*
* @description : beforeInsert handle the ContractLineItem beforeInsert event on ContractLineItem.
*/
	public override void beforeInsert(){
		if(newList!=null && newList.size()>0){
			system.debug('#### beforeInsert--'+newList.size());
			CH_ContractLineItemTriggerHelper.populateLookupIds(newList);
			CH_ContractLineItemTriggerHelper.populateCountryName(newList);
			ContractLineItemTriggerHelper.createBeforeInsertContractLineItem(newList); 
		}
	}
	
	/*
* @description : afterInsert handle the ContractLineItem afterInsert event on ContractLineItem.
*/
	
	protected override void afterInsert() {	
		if(newList!=null && newList.size()>0){
			system.debug('#### afterInsert--'+newList.size());
			Id jobId =System.enqueueJob(new CH_ContractLineItemQueueableProcess(new Map<Id,ContractLineItem>(), newMap, true,false));
		}
	}
	
	
	/*
* @description : beforeUpdate handle the ContractLineItem beforeUpdate event on ContractLineItem.
*/
	public override void beforeUpdate(){
		if(newList!=null && newList.size()>0){
			system.debug('#### beforeupdate--'+newList.size());
			CH_ContractLineItemTriggerHelper.updateLookupIds(oldMap, newList);
			CH_ContractLineItemTriggerHelper.populateCountryName(newList);
		}
	}
	
	
	/*
* @description : afterUpdate handle the ContractLineItem afterUpdate event on ContractLineItem.
*/
	
	
	/*
* @description : beforeDelete handle the ContractLineItem beforeDelete event on ContractLineItem.
*/
	//   public override void beforeDelete(){
	
	//   }
	
	/*
* @description : afterDelete handle the ContractLineItem afterDelete event on ContractLineItem.
*/
	//   public override void afterDelete(){
	
	//  }
}