@isTest
public class CH_UtilsTest {
	public static testmethod void runDefaultMethods(){
		//Hard code the values to avoid DML and Query.
		//Note: These Ids are invalid and will work in any instance
		CH_Utils.getAccountMap(new Set<Id>{'0015C00000UGUac'});
		CH_Utils.getContactMap(new Set<Id>{'0035C00000LIuco'});
		CH_Utils.getEntitlementMap(new Set<Id>{'5505C0000004uen'});
		CH_Utils.getProductMap(new Set<Id>{'01t41000004gGpr'});
		CH_Utils.getAssetMap(new Set<Id>{'02i5C000001rPas'});
		Map<String, User> userMap = CH_Utils.getUserMap(new Set<String>{UserInfo.getUserId()});
		 
		CH_Utils.getAccountMap(new Set<Id>{'0015C00000UG1ac'});
		CH_Utils.getContactMap(new Set<Id>{'0035C00000LI1co'});
		CH_Utils.getEntitlementMap(new Set<Id>{'5505C00000041en'});
		CH_Utils.getProductMap(new Set<Id>{'01t41000004g1pr'});
		CH_Utils.getAssetMap(new Set<Id>{'02i5C000001r1as'});
		CH_Utils.getUserMap(new Set<String>{'0055C000002UFus'});
		System.assertNotEquals(userMap, null);
	}
}