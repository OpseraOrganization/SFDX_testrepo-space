@isTest
public class CSTCampaignDataInterfaceSchedularTest {
	
	public static testMethod void testschedule() {			   
		Test.startTest();				 
		System.Test.setMock(HttpCalloutMock.class, new CSTCampaignMock());
		CSTCampaignDataInterfaceSchedular sh1 = new CSTCampaignDataInterfaceSchedular();
		String sch = '0 0 23 * * ?'; 
		system.schedule('Test Territory Check', sch, sh1); 
		Test.stopTest();
	}
	
}