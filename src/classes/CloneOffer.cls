/*******************************
Class Name: CloneOffer
Created by: Accenture
Created Date: 15th September 2017
Last modified by: Accenture
Last modified date: 22nd September 2017
Description: Requirement 1239,1240: Sales Process: Offer Cloning 
*******************************/
public with sharing class CloneOffer {
	@AuraEnabled
  /*******************************
Method Name: getCloneOffer
Description: Requirement 1239,1240: Sales Process: Offer Cloning 
Parameters: Offer record id
*******************************/
  public static String getCloneOffer(String recordId) {
	Schema.DescribeSObjectResult sc = Opportunity.sObjectType.getDescribe();
	Boolean isCreateable = sc.isCreateable();
	String returnMessage;
	system.debug('isCreateable' + isCreateable);
	Id profileId = UserInfo.getProfileId();
	List < Id > profiles = System.Label.Clone_Restricted_Profiles.Split(',');
	set < Id > profileIdSet = new set < Id > ();
	profileIdSet.addAll(profiles);
	if (isCreateable && (!profileIdSet.contains(profileId))) {
	  String query = GlobalConstants.SELECT_QUERY;
	  for (CloneObject__c s: [SELECT Field_API__c FROM CloneObject__c where Object__c = :GlobalConstants.OBJECT_OFFER_1]) {
		query += GlobalConstants.SPACE + s.Field_API__c + GlobalConstants.COMMA;
	  }
	  system.debug('query.subString(query.Length())?>>>>' + query.Length());
	  system.debug('query.subString(query.Length()-1,query.Length())?>>>>' + query.subString(query.Length() - 1, query.Length()));
	  // Strip off the last comma if it exists.[from last query statement]
	  if (query.subString(query.Length() - 1, query.Length()) == GlobalConstants.COMMA) {
		system.debug('in if... query?>>>>' + query);
		query = query.subString(0, query.Length() - 1);
		system.debug('in if after substring... query?>>>>' + query);
	  }
	  // Add complete query
	  query += GlobalConstants.SOQLFROM + GlobalConstants.OBJECT_OFFER;
	  query += GlobalConstants.SOQLWHERE + recordId + GlobalConstants.SOQLLIMIT;
	  system.debug(query);
	  try {
		Offer__c offerObj = database.query(query);
		Offer__c newofferObj = offerObj.clone(false, false, false, false);
		newofferObj.Name = offerObj.Name + GlobalConstants.CLONEOPTYNAME;
		insert newofferObj;
		system.debug('Insert successful');
		returnMessage = newofferObj.Id;
		cloneOfferTeam(newofferObj.id, recordId);
	  }

	  catch(Exception ex) {
		returnMessage = ex.getDmlMessage(0);
		ExceptionHandler.addException(ex, GlobalConstants.CLONE_OPPORTUNITY, GlobalConstants.GET_CLONE_OPPTY);
		return returnMessage;
	  }
	} else {
	  returnMessage = system.label.AccessDenied;
	  //returnedList.add('You do not have sufficient permission to clone opportunity');				
	}
	return returnMessage;
  }
  /*******************************
Method Name: cloneOfferTeam
Description: Requirement 1239,1240: Sales Process: Offer Cloning 
Parameters: Old Offer record id , new offer id
*******************************/
  public static void cloneOfferTeam(ID newofferObjId, string oldOfferID) {
	List < Offer_Team__c > offerTeamList = new List < Offer_Team__c > ();
	List < Offer_Team__c > newOfferTeamList = new List < Offer_Team__c > ();
	//Team cloned from opportunity
	List < Offer_Team__c > offerTeamFromOpptyList = new List < Offer_Team__c > ();
	Offer_Team__c offerTeamObj = new Offer_Team__c();
	try {
	  //Retrieving team cloned from Oppty
	  offerTeamFromOpptyList = [SELECT Id FROM Offer_Team__c where Offer__c = :newofferObjId LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
	  system.debug('offerTeamFromOpptyList' + offerTeamFromOpptyList);

	  //removing team cloned from Oppty
	  if (!offerTeamFromOpptyList.isEmpty()) {
		delete offerTeamFromOpptyList;
	  }

	  offerTeamList = [SELECT
			Additional_Team_Role__c, Name__c, Name, Offer_Access__c, Offer__c, 
						Team_Member_Role__c, BG__c, Name__r.IsActive
			FROM Offer_Team__c where Offer__c = :oldOfferID AND
			Team_Member_Role__c != NULL AND Name__r.IsActive = True
			LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
	  system.debug('offerTeamList' + offerTeamList);
	  if (!offerTeamList.isEmpty()) {
		system.debug('Inside if offerteamlist');
		for (Offer_Team__c obj: offerTeamList) {
		  system.debug('obj' + obj);
		  offerTeamObj = new Offer_Team__c();
		  offerTeamObj.Name__c = obj.Name__c;
		  offerTeamObj.Offer_Access__c = obj.Offer_Access__c;
		  offerTeamObj.Offer__c = newofferObjId;
		  offerTeamObj.Team_Member_Role__c = obj.Team_Member_Role__c;
		  offerTeamObj.Additional_Team_Role__c = obj.Additional_Team_Role__c;
		  offerTeamObj.BG__c = obj.BG__c ;
		  newOfferTeamList.add(offerTeamObj);
		}
		system.debug('Final newOfferTeamList' + newOfferTeamList);
		if (!newOfferTeamList.isEmpty()) {
		  Database.SaveResult[] savedResults = Database.insert(newOfferTeamList, false);
		  Boolean someFailure = false;
		  for (Database.SaveResult sr: savedResults) {
			if (!sr.isSuccess()) {
			  someFailure = true;
			  for (Database.Error err: sr.getErrors()) {
				System.debug('Error occured : ' + err.getStatusCode() + ' : ' + err.getMessage());
				System.debug('Fields that affected this error : ' + err.getFields());
			  }
			}
		  }
		  if (!someFailure) {
			System.debug('Opty Team added successfully');
		  }
		}

		//  database.insert(newOfferTeamList);
		system.debug('OfferTeam Insert successful');
	  }
	}
	catch(Exception ex) {
	  ExceptionHandler.addException(ex, GlobalConstants.CLONE_OPPORTUNITY, GlobalConstants.GET_CLONE_OPPTY);
	}
  }
}