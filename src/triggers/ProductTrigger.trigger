/****************************************
* Trigger Name : ProductTrigger 
* Created Date: 15 Jan 2018
* Created By : Accenture
* Description : This trigger routes the records to a helper class 

* Before delete added. Delete related favorite products of Product
* Updated for : Nokia Customer Portal 
* Modified date: 01 31 2018
* Modified by: ABO 

* Product activation based on state added
* updated for PMDI
* Modified date: 08 31 2018

*****************************************/ 
Trigger ProductTrigger on Product2 (before delete, After Update, Before Insert, Before Update, After Insert){
	Boolean byPass = String.IsEmpty((Global_Control__c.getInstance().ObjectTriggerByPass__c))  ? true : !(Global_Control__c.getInstance().ObjectTriggerByPass__c).containsIgnoreCase('PROD2');
	if(byPass){
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) && Nokia_CPQ_Constants.ProductAfterTriggerExecute.equalsignoreCase(Nokia_CPQ_Constants.FALSE_CONSTANT)){
		if(Trigger.isAfter){
			List<Product2> validProdList = new List<Product2>();
			if(Trigger.isUpdate){
	Nokia_CPQ_Constants.ProductAfterTriggerExecute.equalsignoreCase(Nokia_CPQ_Constants.TRUE_STRING);
	
	for(Product2 prod : Trigger.new){
		if(Trigger.oldMap.get(prod.Id) != null && Trigger.newMap.get(prod.Id) != null && Trigger.oldMap.get(prod.Id).Apttus_Config2__Version__c != Trigger.newMap.get(prod.Id).Apttus_Config2__Version__c && String.isNotBlank(Trigger.newMap.get(prod.Id).Portfolio__c)){
			validProdList.add(prod);
		}	  
	}	 
			}
			
			if(!validProdList.isEmpty()){
	ProductTriggerHelper.sendChatter(validProdList);
			}	
		}	 
	}
		
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)) {
		if(Trigger.isBefore){
			if(Trigger.isDelete){
	NCP_Product2TriggerHandler.beforeDeleteOperation(Trigger.oldMap.keySet());
			}	 
			if(Trigger.isUpdate || Trigger.isInsert){   
	List<Product2> ProdupdList = new List<Product2>();
	Map<ID, RecordType> m_rectype = new Map<ID, RecordType>([SELECT Id, DeveloperName FROM RecordType]);
	for(Product2 prod : Trigger.new){
		
		if (m_rectype.get(prod.RecordTypeId).DeveloperName == 'NokiaCPQ_Sales_Product' && prod.Portfolio__c != null) 
		{
			
			if (prod.NokiaCPQ_State__c == 'Release' || prod.NokiaCPQ_State__c == 'Ramp Down') 
			{
	
	prod.Nokia_CPQ_Marketing_Status__c = 'GA';
			}
			else if ((prod.NokiaCPQ_State__c != 'Release') && (prod.NokiaCPQ_State__c != 'Ramp Down') && (prod.NokiaCPQ_State__c != null))
			{
	
	prod.Nokia_CPQ_Marketing_Status__c = 'Non-GA';
	
			}
			else if (prod.NokiaCPQ_State__c == null)
			{
	
	prod.Nokia_CPQ_Marketing_Status__c = null;
	
			}
			
			
			
		}
		
		
	}
	
	
			}
			
			if(Trigger.isUpdate)
	{
	Map<ID, RecordType> m_rectype = new Map<ID, RecordType>([SELECT Id, DeveloperName FROM RecordType]);
		for(Product2 prod : Trigger.new){
		 if (m_rectype.get(prod.RecordTypeId).DeveloperName == 'NokiaCPQ_Sales_Product'){
	if(prod.Product_Hierarchy__c != null  ){
	//prod.Business_Group__c = prod.Product_Hierarchy__r.Business_Group_Code__c;
	//prod.Family = prod.Product_Hierarchy__r.Business_Unit_Code__c;
	ProductTriggerHandler.updateproductdata(trigger.oldmap,trigger.newmap);
	}
			}
		}
	
	}
			
		}
		
		//call product activation to check if the state has been changed to active state
		if(PMDI_Constants.productTriggerExecuteRecursion == false)
		{
			//Marking recursion check for product activation as true, so that recursion does not happen again
			PMDI_Constants.productTriggerExecuteRecursion = true;
			
			if( Trigger.isBefore  && Trigger.isUpdate)
			{
	PMDITriggerHandler.reactivateProduct(Trigger.NewMap.values());
	
			}
		}
		
		//call pricelist activation if the product state is changed from inactive to active
		//and update pricelist item state if product state is changed from inactive to active
		
		{
			if( Trigger.isAfter  && Trigger.isUpdate)	
	if(PMDI_Constants.priceListItemTriggerExecuteRecursion == false)
			{
	//Marking recursion check for price list activation as true, so that recursion does not happen again
	PMDI_Constants.priceListItemTriggerExecuteRecursion = true;
	
	PMDITriggerHandler.reactivatePriceListItem(Trigger.OldMap,Trigger.NewMap);
			}
			
		}
		
	}
	
	//if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
		if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
			NCP_Product2TriggerHandler.upsertPricebookEntries(Trigger.New);
		}
	//}  
	
	if( Trigger.isBefore  && Trigger.isUpdate){
		HWS_ProductTriggerHandler.beforeUpdateOperation(Trigger.oldMap, Trigger.New);   
	}
}
	if(Trigger.isAfter && Trigger.isUpdate){
	//  ProductTriggerHelper helper= new ProductTriggerHelper();
	//  helper.inactiveProductUpdate(Trigger.newMap,Trigger.oldMap);
	ProductTriggerHandler.onafterUpdate(Trigger.NewMap,Trigger.OldMap);
	}
}