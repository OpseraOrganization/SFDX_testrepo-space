/****************************************
 * Class Name : AccreditationHandler
 * Created Date: 1 Sep 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date:
 * Description : Handle the sequence of the Accreditation Trigger
 * Test Class:
 *****************************************/
public without sharing class AccreditationHandler {
/********************
 * Method Name: afterUpdateOperation
 * Parameter: newContractList, Old Accreditation Map
 * Description: Used to handle after Update activities
 *******************/
public static void afterUpdateOperation(List<Accreditation__c> newAccreditationList, Map<ID, Accreditation__c> accreditationOldMap) {
	list<Accreditation__c> updatedAccreditation = new list<Accreditation__c>();
	try{
		for(Accreditation__c newAccreditation : newAccreditationList) {
			if(newAccreditation.Meets_Lab_Equipment_Requirements__c != accreditationOldMap.get(newAccreditation.id).Meets_Lab_Equipment_Requirements__c) {
	updatedAccreditation.add(newAccreditation);
			}
		}
		if(updatedAccreditation.size() > 0) {
			AccreditationHelper.updateAccreditation(updatedAccreditation);
		}
	}
	catch(System.Exception e) {ExceptionHandler.addException(e, PRMGlobalConstants.AccreditationHandler, PRMGlobalConstants.afterUpdateOperation );}
}

/********************
 * Method Name: afterUpdateNeedsRepriceCheck
 * Parameter: accreditationNewMap, accreditationOldMap
 * Description: Used to handle Needs Reprice logic after Update activities
 *******************/
public static void afterUpdateNeedsRepriceCheck(Map<ID, Accreditation__c> accreditationNewMap, Map<ID, Accreditation__c> accreditationOldMap){

	List<Accreditation__c> accrdList = new List<Accreditation__c>();
	List<String> idList = new List<String>();

	//system.debug('In the afterUpdateNeedsRepriceCheck ----->');
	try{
		for(id accrdId : accreditationNewMap.keySet()) {

			if(PRMGlobalConstants.accreditationAutomationRepricing == false && ((!accreditationNewMap.get(accrdId).Accreditation_Level__c.equalsIgnoreCase(accreditationOldMap.get(accrdId).Accreditation_Level__c) && String.isBlank(accreditationNewMap.get(accrdId).Pricing_Level_Override__c)) || (accreditationNewMap.get(accrdId).Pricing_Accreditation__c!=accreditationOldMap.get(accrdId).Pricing_Accreditation__c))) {

	accrdList.add(accreditationNewMap.get(accrdId));
	idList.add(accrdId);

			}

		}
		if(!accrdList.isEmpty()) {
			NeedsRepriceAccreditationInvocable.updateQuotesInBulk(accrdList);
		}

	}

	catch(System.Exception e) {ExceptionHandler.addException(e,Nokia_CPQ_Constants.ACCRD_HANDLER,Nokia_CPQ_Constants.ACCRD_HANDLER);}

}

/**
 * @description After insert handler
 * @author Yashdeep Prajapati | 01-18-2022
 * @param accreditationList
 **/
public static void afterInsert(List<Accreditation__c> accreditationList){
	try{
		NeedsRepriceAccreditationInvocable.updateQuotesInBulk(accreditationList);
	}
	catch(System.Exception e) {
		ExceptionHandler.addException(e, PRMGlobalConstants.AccreditationHandler, 'afterInsert' );
	}
}
}