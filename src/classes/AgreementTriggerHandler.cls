/**
 * About
 * -----
 * @Description : This handler is written for the Trigger of Apttus Agreement Object
 * @TestClass : DS_ProposalControllerTest.
 * @Project : Digital Sales, QTO, CLM
 * @Modification Log :
 *  Created  : - Accenture
 *  Modified : 2020.11.17 - gyorgyi.kovacs@nokia.com
 * -----
**/
public without sharing class AgreementTriggerHandler {

	/**
	* @description : This method is used to validate if all the mandatory fields on Agreement are filled or not
	* @param: List of current record Ids of Apttus Agreement
	*/
	public static void checkMandatoryFields(List<Apttus__APTS_Agreement__c> newAgreements, Map<Id, Apttus__APTS_Agreement__c > oldAgreementsMap) {
		try {
			for (Apttus__APTS_Agreement__c newAgreement : newAgreements) {
	//Confidence level is changed to High Level
	if ((newAgreement.Confidence_Level__c != (oldAgreementsMap.get(newAgreement.id)).Confidence_Level__c) && (newAgreement.Confidence_Level__c.equals('High Level'))) {
	//if ((newAgreement.Confidence_Level__c != (oldAgreementsMap.get(newAgreement.id)).Confidence_Level__c) && (newAgreement.Confidence_Level__c.equals('High Level') && (oldAgreementsMap.get(newAgreement.Id)).Confidence_Level__c.equals('Low Level'))) {
	//if (newAgreement.Apttus__Status_Category__c != oldAgreementsMap.get(newAgreement.Id).Apttus__Status_Category__c && (newAgreement.Apttus__Status_Category__c.equals('In Application') || newAgreement.Apttus__Status_Category__c.equals('In Effect'))) {
		AgreementTriggerHelper.checkMandatoryFields(newAgreements);
	}
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, CSWXGlobalConstant.AgreementTriggerHandler, CSWXGlobalConstant.checkMandatoryFields);
		}
	}

	/**
	* @description : This method is used to do the necessary changes upon Agreement creation prior to insertion
	* @param: List of current record Ids of Apttus Agreement
	*/
	public static void beforeInsert(List<Apttus__APTS_Agreement__c> agreements) {
		AgreementTriggerHelper.populateFieldsForNewAgreement(agreements); /* DSI-1857 */
	}
	
	/**
	* @description : This method is used to do the necessary changes upon Agreement updation 
	* @param: Map of old record Ids of Apttus Agreement, Map of current record Ids of Apttus Agreement
	* CLM changes:Rajeev Ketha
	* CLM Services - E2ECLM- 3, 4,6, 9,10,11
	*/
	public static void afterUpdate(Map<Id,Apttus__APTS_Agreement__c> agrmntNewMap, Map<Id,Apttus__APTS_Agreement__c> agrmntOldMap) {
		
	}

	/**
	* @description : This method is used to do the necessary changes upon Agreement creation after insertion
	* @param: List of current record Ids of Apttus Agreement
	*/
	public static void afterInsert(List<Apttus__APTS_Agreement__c> agreements) {
		
		AgreementTriggerHelper.createMilestones(agreements); /* DSI-1857 */
		
	}
}