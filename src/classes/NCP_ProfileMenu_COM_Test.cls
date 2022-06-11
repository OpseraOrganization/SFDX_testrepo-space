@isTest
private class NCP_ProfileMenu_COM_Test {
	@isTest
	static void TestIsSandox() {

		Test.startTest();

		Boolean b = NCP_ProfileMenu_COM.isInSandbox();
		NCP_ProfileMenu_COM.isInternalUser();
		NCP_ProfileMenu_COM.getOrgUrl();

		Test.stopTest();
	}
}