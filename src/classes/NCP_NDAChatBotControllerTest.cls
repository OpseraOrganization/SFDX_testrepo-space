@isTest
private class NCP_NDAChatBotControllerTest {
	@isTest
	static void testIsRendered() {
		System.assertEquals(NCP_NDAChatBotController.isRendered(), true, 'It is not a Guest User');
	}
}