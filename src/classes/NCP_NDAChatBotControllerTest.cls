@isTest
private class NCP_NDAChatBotControllerTest {
	@isTest
	static void testchatBotRefresh() {
		System.assertEquals(NCP_NDAChatBotController.chatBotRefresh(),UserInfo.getSessionId());
	}
	@isTest
	static void testIsProductionOrg() {
		System.assertEquals(NCP_NDAChatBotController.isProductionOrg(),!NCP_Utils.isSandbox());
	}
	@isTest
	static void testIsGuestUser() {
		System.assertEquals(NCP_NDAChatBotController.isGuestUser(),false, 'It not a guest user');
	}
}