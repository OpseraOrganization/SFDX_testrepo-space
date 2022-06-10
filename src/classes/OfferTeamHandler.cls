/***********************************************
*	Class Name : OfferTeamHandler
*	Created By : Accenture IDC
*	Created Date :14/Dec/2016
*	Description : This will give access to Offer Team same as Opportunity Team 
*				  This will give access or delete access to new Offer Team member to the documents on that Offer
*	Requirement : Sales Process Requirement 649 & Doc Strategy Requirement 657
*********************************************/
public with sharing  class OfferTeamHandler {
	
	/****************************************
	*Method Name: afterInsertUpdate
	*Description: This will handle the methods from OfferTeamHelper that will fire before Insert
	*Parameters: Offer Team  List
	*****************************************/
	public static void afterInsertUpdate(List<Offer_Team__c> offerTeamListNew){
		//Calling method from OfferTeamHelper
		// skip trigger execution for Data Loader profile users
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			OfferTeamHelper.offerTeamRecordShare(offerTeamListNew, true);
			OfferTeamHelper.offerTeamPrMValidation(offerTeamListNew);
		}
	}
		
	/****************************************
	*Method Name: beforeDelete
	*Description: This will handle the methods from OfferTeamHelper that will fire before Delete
	*Parameters: Offer Team  List
	*****************************************/	  
	public static void beforeDelete(List<Offer_Team__c> offerTeamListNew){
		
		if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id)){
			OfferTeamHelper.offerTeamRecordShare(offerTeamListNew, false);
		}  
	}
}