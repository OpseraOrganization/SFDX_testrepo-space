/****************************************
* Class Name : DealProductHelper
* Created Date: 2 November 2018
* Created By : Accenture
* Last Modified by: Accenture
* Description : Business Logic pf Deal Product Trigger is written here 
* Test Class: 
 *****************************************/
public without sharing class DealProductHelper {
	
	/* 
	 * This Method is Updating Estimated Amount of Lead, after Deletetion of Deal Product.
	*/
	public static void afterInsertDealProductHelperMethod(List<DealProduct__c> dealProdList) { 
		try{
			Set<ID> leadid = new set<ID>();
			for(DealProduct__c dp : dealProdList) {
				 leadid.add(dp.Deal__c);
			}
			Map<Id, Lead> productleadmap = new Map<Id,Lead>([SELECT id,Estimated_Amount__c FROM Lead WHERE id in : leadid]);
			Double Estimate =0;
	 		for(DealProduct__c p : dealProdList) {  
				if(productleadmap.get(p.Deal__c).Estimated_Amount__c != null) {
					Estimate = productleadmap.get(p.Deal__c).Estimated_Amount__c - p.Value__c;
				}
				productleadmap.get(p.Deal__c).Estimated_Amount__c = Estimate;
			}
			update productleadmap.values();
		  }catch(System.Exception e) {
			 ExceptionHandler.addException(e,PRMGlobalConstants.DealProductHelper,PRMGlobalConstants.afterDeleteForDeal );
		  }
	}
	
}