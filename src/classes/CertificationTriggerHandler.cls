/****************************************
* Class Name : CertificationTriggerHandler 
* Created Date: 
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 
* Description : Handle the sequence of the AccountTriggerHelper
* Test Class: 
*  * Updated by HCL Tech on 01/09/2021 to release in 21.2 as SF Performance improvement activity - 
 * afterInsertCertificateOperation is optimized- removed SOQL(profilePSM = [SELECT Id,Name FROM Profile WHERE Name LIKE : PRMGlobalConstants.NOKIA_SALES_PROFILE Limit 1];) which is not used further
*****************************************/
public without sharing class CertificationTriggerHandler {	
	/********************
*Method Name: afterUpdateCertificateOperation
*Parameter: Cerfication List
*Description: Used to handle after Insert actions Certification Share
*******************/	
	/***added by sneha to optimise ****/
	public static void afterInsertCertificateOperation(Map<Id,Certification__c> certificationNewMap, Map<Id,Certification__c> certificationOldMap){
		List<Certification__c> certificationListPSM = new List<Certification__c>();
			try{
	for(Certification__c certify :[SELECT Id,Owner.ProfileId,OwnerID,Partner__r.Id,Name FROM Certification__c 
			  WHERE id IN : certificationNewMap.values() Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			   if(CertificationOldMap.get(certify.Id).OwnerID != CertificationNewMap.get(certify.Id).OwnerID){
				certificationListPSM.add(certify);  
			   } 
			  }
	if(!certificationListPSM.IsEmpty()){
		CertificationTriggerHelper.afterUpdateCertificationSharePSM(certificationListPSM);
	}
			}
			catch(Exception e) {
	ExceptionHandler.addException(e,PRMGlobalConstants.CertificationTriggerHandler ,PRMGlobalConstants.afterInsertCertificateOperation);}
		
	}
	/*******************************
*******************************
*Method name: certification afterUpdate
*Description: 
*Parameter: 
*******************************/
	public static void afterUpdate( Map<id,Certification__c> CertificationOldMap , Map<id,Certification__c> CertificationNewMap  ){
		try{
			CertificationTriggerHelper.updateGPPFieldsonCert(CertificationOldMap, CertificationNewMap);
		}
		catch(exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CertificationTriggerHandler ,PRMGlobalConstants.afterUpdate);}
	}
	/*******************************
*******************************
*Method name: certification afterInsert
*Description: 
*Parameter: 
*******************************/
	public static void afterInsert(Map<id,Certification__c> CertificationNewMap, List<Certification__c> CertificationNewList){
		try{
			CertificationTriggerHelper.updateGPPFieldsonCertonInsert(CertificationNewMap);
			
			List<Certification__c> completedCertList = new List<Certification__c>();
			for(Certification__c cert : CertificationNewList){
	if(cert.Certification_Status__c == PRMGlobalConstants.Completed){
		completedCertList.add(cert);
	}   
			}
			if(completedCertList.size() > 0){
	CertificationTriggerHelper.accreditationUpdate(completedCertList);
			}
		}
		catch(exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CertificationTriggerHandler ,PRMGlobalConstants.afterInsert);}
	}
	/*******************************
*******************************
*Method name: certification afterUpdateOperations
*Description: 
*Parameter: 
*******************************/
	public static void afterUpdateOperations( Map<id,Certification__c> CertificationOldMap , list<Certification__c> newCertificationList  ){
		try{
			list<Certification__c> completedorExpiredCert =  new list<Certification__c>();
			for(Certification__c newcert : newCertificationList){	
	if(newcert.Certification_Status__c != CertificationOldMap.get(newcert.id).Certification_Status__c && 
	(newcert.Certification_Status__c == PRMGlobalConstants.Completed || 
		newcert.Certification_Status__c == PRMGlobalConstants.EXPIRED)){
			completedorExpiredCert.add(newcert);
		}
			}
			if(!completedorExpiredCert.isempty()){
	CertificationTriggerHelper.accreditationUpdate(completedorExpiredCert);
			}
		}
		catch(exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CertificationTriggerHandler ,PRMGlobalConstants.afterUpdate);}
	}
		/*******************************
*******************************
*Method name: certification afterUpdateOperations
*Description: 
*Parameter: List of deleted Certifications
*******************************/
	public static void beforeDeleteOperations(List<Certification__c> deletedCertList){
		try{
			List<Certification__c> completedCertList = new List<Certification__c>();
			for(Certification__c cert : deletedCertList){
	if(cert.Certification_Status__c == PRMGlobalConstants.Completed){
		completedCertList.add(cert);
	}   
			}
			if(completedCertList.size() > 0){
	CertificationTriggerHelper.accreditationUpdate(completedCertList);
			}
		}
		catch(exception e){ExceptionHandler.addException(e,PRMGlobalConstants.CertificationTriggerHandler ,PRMGlobalConstants.beforeDelete);}
	}
}