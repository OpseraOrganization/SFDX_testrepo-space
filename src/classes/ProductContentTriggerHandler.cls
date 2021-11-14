/**
About
-----
Description: This Class is used as handler for ProductContentTrigger Trigger .

Created: 11 Feb 2021
  
Update History
--------------

-------------
**/

public class ProductContentTriggerHandler extends TriggerHandler {
	private List<NCP_Product_Content__c> newProductContentList;
	private List<NCP_Product_Content__c> oldProductContentList;

	public ProductContentTriggerHandler() {
		newProductContentList = (List<NCP_Product_Content__c>) Trigger.new;
		oldProductContentList = (List<NCP_Product_Content__c>) Trigger.old;
	}

	protected override void afterInsert() {
		ProductContentTriggerHelper.updateProductContentCount(newProductContentList, oldProductContentList);
	}
	protected override void afterDelete() {
		ProductContentTriggerHelper.updateProductContentCount(newProductContentList, oldProductContentList);
	}
	protected override void afterUpdate() {
		ProductContentTriggerHelper.updateProductContentCount(newProductContentList, oldProductContentList);
	}  
}