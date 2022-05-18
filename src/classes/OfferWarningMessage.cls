/*******************************
Class Name: OfferWarningMessage
Created by: Accenture
Created Date: 28th April 2017
Last modified by: Accenture
Last modified date: 28th April 2017
Description: This class will handle the logic for warning message on Offer and Opportunity
Test coverage : OfferWarningMessageTest
Sales process: Sprint 5: requirement 955
*******************************/
public with sharing class OfferWarningMessage{
	//This class will handle the logic for warning message on Offer and Opportunity
	private static final Id directRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	private static final Id inDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_record_type).getRecordTypeId();

	/******************************
*Method Name: getOfferId
*Description: Test Method will get Opportunity/Offer id for displaying the error message
*Parameters: Id recordId
********************************/
	@AuraEnabled
	public static String getOfferId(Id recordId, String url){
		try{
			if(recordId != null && url.contains(recordId) && String.isNotBlank(url)){

				List<Offer__c> offerList = [SELECT id, Opportunity__r.Phase_Status__c FROM Offer__c WHERE Opportunity__r.Business_Type__c != :GlobalConstants.FAST_TRACK_OPP_TYPE AND Opportunity__r.Phase_Status__c =: GlobalConstants.OFFERSUBMITTEDTOCUSTOMER  and ActiveOffer__c = true and id=:recordId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];

				if(!offerList.isEmpty()){
					return System.label.Warning_Message;
				}
			}
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OFFER_WARNING_MSG, GlobalConstants.GET_OFFER_ID);
		}
		return GlobalConstants.BLANK_VALUE;
	}

	//F1999 - COE Portugal - verify if the offer team already have all tricorn roles assigned
	@AuraEnabled
	public static String verifyOfferTeamTricornRoles(Id recordId){

		if(recordId.getSObjectType().getDescribe().getName()!='Offer__c'){
			return null;
		}
		//check if the offer belongs to a Fast Track Opportunity - if so, show no error message
		List<Offer__c> offerLst = [SELECT Id FROM Offer__c WHERE Id = :recordId AND Opportunity__r.Business_Type__c = :GlobalConstants.FAST_TRACK_OPP_TYPE];
		if(!offerLst.isEmpty()){
			return null;
		}

		List<Offer_Team__c> team = [Select Id, Name, Team_Member_Role__c, Additional_Team_Role__c from Offer_Team__c Where Offer__c = :recordId ];
		List<String> tricornRoles = GlobalConstants.TRICORN_ROLES.split(';');

		if(team.isEmpty()){
			return GlobalConstants.OFFER_TEAM_INCOMPLETE_WARNING;
		}

		Integer k;
		for(String role : tricornRoles) {
			for(k = 0 ; k < team.size(); k++) {
				Offer_Team__c member = team[k];
				String[] additionalRoles = member.Additional_Team_Role__c != null ? member.Additional_Team_Role__c.split(';') : new String[]{};
					if(member.Team_Member_Role__c == role ||  additionalRoles.contains(role)) {
						break;
					}
			}
			if(k == team.size()){
				return GlobalConstants.OFFER_TEAM_INCOMPLETE_WARNING;
			}
		}
		return null;
	}

}