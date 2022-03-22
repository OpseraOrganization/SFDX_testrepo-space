public class SupportingMaterialTriggerHelper {
	/*****************************
*Method Name: validateDuplicateSupportingMaterialRecord
*Description: This is method used to check duplicate record of Supporting Material
*Parameters: supportingMaterialList
*******************************/	
	public static void validateDuplicateSupportingMaterialRecord(List<File_Upload__c> supportingMaterialList){
		Set<Id> accId = new Set<Id>();
		Set<Id> agreementId = new Set<Id>();
		Set<Id> purchaseOrderId = new Set<Id>();
		Set<Id> accIdFordbRecord = new Set<Id>();
		Set<Id> agreementIdFordbRecord = new Set<Id>();
		Set<Id> purchaseOrderIdFordbRecord = new Set<Id>();
		System.debug('In Helper');
		System.debug('In supportingMaterialList'+supportingMaterialList);
		
		try{
		for(File_Upload__c spRec : supportingMaterialList){
			accId.add(spRec.Account__c);
			agreementId.add(spRec.Frame_Contract_Reference__c);
			purchaseOrderId.add(spRec.Purchase_Order__c);
			 
		}
		
		List<File_Upload__c> tempsupportingMaterialList = [SELECT ID,Account__c,Frame_Contract_Reference__c,Purchase_Order__c FROM File_Upload__c WHERE Account__c IN :accId AND Frame_Contract_Reference__c IN :agreementId AND Purchase_Order__c IN:purchaseOrderId];
		Set<Id> errorsupportingMaterialSetId = new  Set<Id>();
		System.debug('In tempsupportingMaterialList'+tempsupportingMaterialList);
		
		for(File_Upload__c tempSpRec : tempsupportingMaterialList){
			accIdFordbRecord.add(tempSpRec.Account__c);
			agreementIdFordbRecord.add(tempSpRec.Frame_Contract_Reference__c);
			purchaseOrderIdFordbRecord.add(tempSpRec.Purchase_Order__c);
		}
		 
		System.debug('In errorsupportingMaterialSetId'+errorsupportingMaterialSetId);
		for(File_Upload__c spRec : supportingMaterialList){
			if(accIdFordbRecord.contains(spRec.Account__c) && agreementIdFordbRecord.contains(spRec.Frame_Contract_Reference__c) && purchaseOrderIdFordbRecord.contains(spRec.Purchase_Order__c)){
				 spRec.addError('Supporting Material Record already exist');
			}
		   
		}
		}catch(Exception ex){
					   ExceptionHandler.addException(ex,CSWXGlobalConstant.SupportingMaterialTriggerHelper,CSWXGlobalConstant.validateDuplicateSupportingMaterialRecord);


		}
	   
	  }
	 
}