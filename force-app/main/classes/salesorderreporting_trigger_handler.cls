/*******************************
Class Name: salesorderreporting_trigger_handler
Modified by: HCL
Modified Date: 8th Mar 2021
Description: This class will handle the logic implemented on salesorderreporting_trigger
*******************************/
public class salesorderreporting_trigger_handler {
	salesorderreporting_trigger_helper salesOrderHelper = new salesorderreporting_trigger_helper();
	public void BeforeInsert(List<Sales_Order_Reporting__c> SOinslist){
		if(!userinfo.getProfileId().equalsignorecase(system.label.Data_Loader_Profile_Id)){
			salesOrderHelper.Currencychange(SOinslist);
			salesOrderHelper.UpdateCQNumber(SOinslist);
		}
	}
	
	public void BeforeUpdate(List<Sales_Order_Reporting__c> SOupdlist , Map<Id,Sales_Order_reporting__c> oldSOMap, Map<Id,Sales_Order_reporting__c> newSOMap){
		if(!userinfo.getProfileId().equalsignorecase(system.label.Data_Loader_Profile_Id)){
			salesOrderHelper.Updatecurrencychange(SOupdlist, oldSOMap);
			salesOrderHelper.CheckCQChange(oldSOMap,newSOMap);
		}
	}
	
	public void AfterInsert(List<Sales_Order_Reporting__c> salesorderlist){
		if(!userinfo.getProfileId().equalsignorecase(system.label.Data_Loader_Profile_Id)){
			System.debug('before: '+Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
			System.enqueuejob(new UpdatecqdataQueueable(salesorderlist)); //Added for performance improvements
			System.enqueuejob(new EmailAlertQueueable(salesorderlist)); //Added for performance improvements
			System.debug('After: '+Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
		}		
	}
	
	public void AfterUpdate(List<Sales_Order_Reporting__c> salesorderlist){
		if(!userinfo.getProfileId().equalsignorecase(system.label.Data_Loader_Profile_Id)){
			System.debug('before: '+Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
			System.enqueuejob(new UpdatecqdataQueueable(salesorderlist)); //Added for performance improvements
			System.debug('After: '+Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
		}
	}
	
	public void AfterDelete(List<Sales_Order_Reporting__c> salesorderlist){
		if(!userinfo.getProfileId().equalsignorecase(system.label.Data_Loader_Profile_Id)){
			System.debug('before: '+Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
			System.enqueuejob(new UpdatecqdataQueueable(salesorderlist)); //Added for performance improvements
			System.debug('After: '+Limits.getHeapSize() + '/' + Limits.getLimitHeapSize());
		}		
	}
}