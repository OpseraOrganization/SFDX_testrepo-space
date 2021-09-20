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
		if(!listConLineItem.isEmpty()){
		this.newList = listConLineItem;
		}
		else{
		this.newList = (List<ContractLineItem>) Trigger.new;
		}
		this.newMap  = (Map<Id, ContractLineItem>) Trigger.newMap;
		this.oldList =(List<ContractLineItem>) Trigger.old;
		this.oldMap  = (Map<Id, ContractLineItem>) Trigger.OldMap;		
	}
	
	/*
	* @description : beforeInsert handle the ContractLineItem beforeInsert event on ContractLineItem.
	*/
	public override void beforeInsert(){
		
		CH_ContractLineItemTriggerHelper.populateLookupIds(newList);
		CH_ContractLineItemTriggerHelper.populateCountryName(newList);
		ContractLineItemTriggerHelper.createBeforeInsertContractLineItem(newList);
	}
	
	/*
	* @description : afterInsert handle the ContractLineItem afterInsert event on ContractLineItem.
	*/
	public override void afterInsert(){

	}
	
	/*
	* @description : beforeUpdate handle the ContractLineItem beforeUpdate event on ContractLineItem.
	*/
	public override void beforeUpdate(){
	
		CH_ContractLineItemTriggerHelper.updateLookupIds(oldMap, newList);
		CH_ContractLineItemTriggerHelper.populateCountryName(newList);
		//ContractLineItemTriggerHelper.createBeforeInsertContractLineItem(newList);
	}
	
	
	/*
	* @description : afterUpdate handle the ContractLineItem afterUpdate event on ContractLineItem.
	*/
	public override void afterUpdate(){
		
	}
	
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