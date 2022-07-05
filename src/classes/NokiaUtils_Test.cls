/** 
* About 
* ----- 
* @Description	 	: Nokia Global Utility Test Class.
* @Project	: All.
* @Modification Log :
*  Created  : 2021 12 17 – tiago.almeida@nokia.com
* -----
**/
@isTest
public class NokiaUtils_Test {

	@isTest
	public static void testMethods() {
		NokiaUtils.getCurrentDateTime();
		NokiaUtils.isCommunity();
		NokiaUtils.getBaseURL();
		NokiaUtils.getPicklistValues('Account', 'Type');
		NokiaUtils.checkUserPermissions(UserInfo.getUserId(), new List<String>{'Test'}, new List<String>{'Test'}, false);
		try { NokiaUtils.getCommunityLink('Customers1'); }
		catch(Exception e) { /* Do Nothing */ }
		try { NokiaUtils.checkUserAccess(UserInfo.getUserId(), UserInfo.getUserId(), true, true, true, false); }
		catch(Exception e) { /* Do Nothing */ }
		try { NokiaUtils.checkUserAccess(UserInfo.getUserId(), new Set<String>{UserInfo.getUserId()}, true, true, true, false); }
		catch(Exception e) { /* Do Nothing */ }
	}
}