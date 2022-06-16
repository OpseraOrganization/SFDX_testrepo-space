public  without sharing class HWS_overridePortalEditButton {
 @AuraEnabled
	public static ID editCase(Case casRec){
		String msg = '';
		try {
			update casRec;
		return casRec.Id;	
		} catch(dmlException ex) {
			msg = ex.getMessage(); 
			throw new AuraHandledException(msg) ;   
		}
		
	} 
	@AuraEnabled
	public static case getCaseInfo(string caseId) {
		List<Case> caseList = [SELECT Id, HWS_Customer_PO__c, HWS_Site_Information__c,HWS_FaultyUnitAWBNumber__c,HWS_FaultyUnitShipmentDispatchDate__c,HWS_Sent_To_SOO__c,Parent.HWS_Sent_To_SOO__c,ParentId,HWS_FaultyUnitReceivedDate__c FROM Case WHERE Id =:caseId];
		return caseList[0];
	}
	@AuraEnabled
	public static String customerPoHide (Id parentCaseId){
		string isValue;
		List<Case> parentCase=[select id,HWS_Customer_PO__c from case where Id =:parentCaseId LIMIT 1];
		List<Case> childCases;
		Boolean invoicingType = false;
		if(parentCase.Size()>0){
			childCases = [select Id, HWS_ServiceType__c, Asset.HWS_ServiceOffering__c,HWS_Site_Information__c, HWS_Contract_Line_Item__r.HWS_InvoicingType__c
		FROM Case where ParentId =: parentCaseId AND Status!='Cancelled'];
	if(childCases.Size()>0){
		for(Case getChildCaseValues:childCases){
		String invoiceType = getChildCaseValues.HWS_Contract_Line_Item__r.HWS_InvoicingType__c;
			if(invoiceType == 'event based'){
		invoicingType = true;
				}
			string serviceItemDescription=getChildCaseValues.Asset.HWS_ServiceOffering__c;
			string servicetype =getChildCaseValues.HWS_ServiceType__c;
			if((servicetype =='Spare Part Sales') || (invoicingType) || (serviceItemDescription!='' && serviceItemDescription!=NULL) && (serviceItemDescription.contains('RES RFR PU')||serviceItemDescription.contains('RES AED PU'))){
		isValue = 'SPS';
		 
			}
		}
	}else {
		isValue = 'isChild';
	}
			
			}
			
			return isValue;
			
		}
	 
	
}