/**
 * Created by bkandov on 20/06/2018.
 */

public without sharing class NCP_Deactivate_Portal_User_COM {

	/**
   * returns nokia's
   * @param url
   *
   * @return http response
   */

	@AuraEnabled
	public static String disableUser(String recordId) {

		String psaName = NCP_CustomerCommunitySetting__c.getValues('Default').Deactivate_Portal_User_Permission_Set__c;
		PermissionSetAssignment psaDeactivatePortalUserPSA;

		Boolean permissionSetAssigned = false;
		try {
			psaDeactivatePortalUserPSA = [SELECT PermissionSet.Name, AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :userInfo.getUserId() AND PermissionSet.Name = :psaName];

			if (psaDeactivatePortalUserPSA != null) {
				permissionSetAssigned = true;
			}
		} catch (Exception e) {
			System.debug('Failure: ' + e);
			return 'Failure - User has no Permission for this functionality';
		}

		if (!permissionSetAssigned) {
			return 'Failure - User has no Permission for this functionality';
		}
		List<User> usersToUpdate = new List<User>();
		for (User u : [
				Select Id, IsActive, IsPortalEnabled, FederationIdentifier, NCP_NSN_ID__c, lastName, firstName, ncp_ssopid__c, ncp_cdb_contact_id__c, CommunityNickname
				from User
				where ContactId = :recordId
		]) {
			u.IsActive = false;
			u.IsPortalEnabled = false;
			u.FederationIdentifier = '';
			u.NCP_NSN_ID__c = '';
			u.ncp_cdb_contact_id__c = '';
			u.ncp_ssopid__c = '';
			datetime currentDateTime = datetime.now();
			Long gettime = currentDateTime.getTime();
			System.debug('gettime='+gettime+', currentDateTime='+currentDateTime);
			u.CommunityNickname = u.CommunityNickname+gettime;
			if(u.CommunityNickname.Length() > 40){
				u.CommunityNickname = u.CommunityNickname.substring(0, 40);
			}
			usersToUpdate.add(u);
		}

		if (usersToUpdate.size() > 0) {
			update usersToUpdate;
		} else {
			return 'Failure - There is no user assigned to the Contact Record';
		}
		return 'Success - User ' + usersToUpdate[0].lastName + ' ' + usersToUpdate[0].firstName + ' Deactivated';
	}
}