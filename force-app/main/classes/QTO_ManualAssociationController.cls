/**
* @Name: QTO_ManualAssociationController
* @Author: Raj Kamdar
* @CreateDate: 10/30/2020
* @Description: Controller for the flow to manually associate PO with Agreement/Quote.
---------------------------------------------------------------------------------------------
* @LastModifiedBy: <LastModifiedBy>
* @LastModifiedDate: <LastModifiedDate>
* @ChangeDescription: <ChangeDescription>
**/
public with sharing class QTO_ManualAssociationController {
	@AuraEnabled
	public static QTO_ManualAssociationControllerHelper.dataWrapper getAllAssociationData(String objectName,String CDId){
		return QTO_ManualAssociationControllerHelper.getAllAssociationData(objectName,CDId);
	}
	@AuraEnabled
	public static QTO_ManualAssociationControllerHelper.dataWrapper saveAssociationData(String saveData, String CDId,String objectName){
		system.debug('saveData-->'+saveData);
		//List<Apttus_Proposal__Proposal__c> lstQuote = (List<Apttus_Proposal__Proposal__c>)System.JSON.deserialize(saveData, List<Apttus_Proposal__Proposal__c>.class);
		QTO_ManualAssociationControllerHelper.saveAssociationData(saveData,CDId,objectName);
		return QTO_ManualAssociationControllerHelper.getAllAssociationData(objectName,CDId);
	}
	@AuraEnabled(cacheable=true)
	public static List<QTO_ManualAssociationControllerHelper.dataTableHeader> getTableHeaders(String objectName){
		return QTO_ManualAssociationControllerHelper.getTableHeaders(objectName);
	}
	@AuraEnabled(cacheable=true)
	public static boolean getStatus(String CDId){
		return QTO_ManualAssociationControllerHelper.getStatus(CDId);
	}
	
}