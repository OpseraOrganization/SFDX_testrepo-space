@isTest
private class NCP_BannerNews_COM_Test {

	private static final String pageBannerNews = NCP_Constants.PAGE_BANNER_NEWS;
	private static final String topBannerNews = NCP_Constants.TOP_BANNER_NEWS;

	@isTest
	static void TestGetBannerNews() {

		User customerUser;

		System.runAs(NCP_TestFactory.createUser(true, 'AES Admin', null, 'test@nokia.com.dev')) {

			Account acc = NCP_TestFactory.createAccount();
			Account acc2 = NCP_TestFactory.createLegalAccount(acc.Id);
			Contact cont = NCP_TestFactory.createContact(acc);
			customerUser = NCP_TestFactory.createUser(false, 'test', cont, 'test2@nokian.com.dev');
			insert customerUser;
			AccountContactRelation acr = NCP_TestFactory.createAccountContactRelation(cont.Id,acc2.Id,true);
			ServiceContract sc = NCP_TestFactory.createServiceContract(acc2, 'CDB');
		}

		System.runAs(customerUser){
			System.assert([select isPortalEnabled from user where id = :customerUser.id].isPortalEnabled, 'User was not flagged as portal enabled.');
			DateTime currentTime = System.now();
			List<NCP_Banner_News__mdt> bannerNews = [
					SELECT NCP_Subject__c,NCP_Body__c,NCP_URL__c,NCP_Urgency_Level__c,NCP_Type__c,NCP_End_Time__c
					FROM NCP_Banner_News__mdt
					WHERE NCP_End_Time__c > :currentTime
			];
			Test.startTest();
			Integer countPageBannerNews = 0, countTopBannerNews = 0;
			Boolean pageBannerAdded = false, topBannerAdded = false;
			for (NCP_Banner_News__mdt b : bannerNews) {
				if (b.NCP_Type__c == pageBannerNews && !pageBannerAdded) {
					countPageBannerNews++;
					pageBannerAdded = true;
				}
				if (b.NCP_Type__c == topBannerNews && !topBannerAdded) {
					countTopBannerNews++;
					topBannerAdded = true;
				}
			}
			System.assertEquals(countPageBannerNews + countTopBannerNews, NCP_BannerNews_COM.getBannerNews().size());
			Test.stopTest();
		}
	}
}