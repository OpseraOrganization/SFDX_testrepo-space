@istest
public class CSTCampaignMemberStatusSchedularTest {
 public static testMethod void testschedule() {  
	 	Campaign_Mem_Status_Date__c cmd = new Campaign_Mem_Status_Date__c();
		Test.startTest();
	  	cmd.Name = 'Date';
		DateTime dateValue = date.today();
		cmd.batchdate__c = '2019-10-10';
		insert cmd;
		System.Test.setMock(HttpCalloutMock.class, new CSTCampaignMemberStatusMock());
		CSTCampaignMemeberStatusSchedular sh1 = new CSTCampaignMemeberStatusSchedular();
		String sch = '0 0 23 * * ?'; 
		system.schedule('Test Territory Check', sch, sh1); 
		Test.stopTest();
	}
}