public without sharing class NCP_ActAsHelper {
	public static void assignLastActAsUser(User usr) {
		//Update User field Last Act As with userinfo.username. It will be used in SP portal landing page controller to remove Permission Set once User is logged in Community using Act As
		if (usr != null) {
			System.debug('UserInfo.getUserId():' + Userinfo.getUserId() + ', UserInfo.getUserName():' + Userinfo.getUserName() + ', usr.username: ' + usr.username);
			//User adminUser = [SELECT id, username, NCP_Last_Act_As_User__c FROM User WHERE id = :usr.id];
			usr.NCP_Last_Act_As_User__c = Userinfo.getUserName();
			update usr;

		}

	}

	public static void removeActAsPermission() {
		String psActAsCustomer = NCP_CustomerCommunitySetting__c.getValues('Default').Act_As_Customer_Permission_Set__c;
		System.debug('psActAsCustomer: ' + psActAsCustomer);
		if (psActAsCustomer != null && psActAsCustomer != '') {
			try {
				System.debug('Userinfo.getUserId(): ' + Userinfo.getUserId() + 'Userinfo.getUserName():' + Userinfo.getUserName());
				User customerUser = [Select id, NCP_Last_Act_As_User__c From User where id = :Userinfo.getUserId()];
				System.debug('customerUser.NCP_Last_Act_As_User__c: ' + customerUser.NCP_Last_Act_As_User__c);
				if (customerUser.NCP_Last_Act_As_User__c != null && customerUser.NCP_Last_Act_As_User__c != '') {
					User adminUser = [Select id, username from User where username = :customerUser.NCP_Last_Act_As_User__c];
					System.debug('adminUser.id :' + adminUser.id + ', adminUser.username: ' + adminUser.username);

					PermissionSet ps = [select id, name from permissionSet where name = :psActAsCustomer];
					System.debug('ps :: ' + ps);
					List<PermissionSetAssignment> psaList = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId = :ps.Id AND AssigneeId = :adminUser.id LIMIT 1];
					if (!psaList.isEmpty()) {
						System.debug('psaList : ' + psaList);
						delete psaList;
					}
				}
			} catch (Exception ex) {
				System.debug('ERROR :: ' + ex.getMessage());
			}

		}
	}
}