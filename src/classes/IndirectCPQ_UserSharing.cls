/****************************************
* Class Name : IndirectCPQ_UserSharing
* Created Date: 29 November 2019
* Created By : Accenture
* Description : Sharing of Opportunity owner with partner users
* Test Class: 
*****************************************/
public without sharing class IndirectCPQ_UserSharing {
/****************************************
* Method Name : optyOwnertoPartnerSharing
* Description : Sharing of Opportunity owner with partner users
*****************************************/	
public static void optyOwnertoPartnerSharing(ID optyOwnerId){
try{
	System.debug('Inside optyOwnertoPartnerSharing method');
	
	List<UserShare> userShareList = new List<UserShare>();
	UserShare userShareRecord;
	Id partnerUserID = UserInfo.getuserId(); 
	System.debug('partnerUserID>>>'+partnerUserID);
	userShareList = [Select ID, UserOrGroupId, UserId from UserShare where UserId =: optyOwnerId AND UserOrGroupId =:partnerUserID LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]  ;
	
	System.debug('ListSize>>>'+userShareList.size());	   
	if((userShareList.size() == 0) && (partnerUserID != Null && optyOwnerId != Null) ){
		System.debug('inside final if>>>');
		userShareRecord   = new UserShare();
		userShareRecord.UserAccessLevel = GlobalConstants.READ;
		userShareRecord.UserOrGroupId=  partnerUserID ;	  
		userShareRecord.UserId = optyOwnerId; 
		
		Database.insert(userShareRecord);
	} 
	
  }Catch(Exception ex){
	ExceptionHandler.addException(ex, IndirectCPQ_UserSharing.class.getName(),GlobalConstants.optyOwnertoPartnerSharingMethod);
}

}

}