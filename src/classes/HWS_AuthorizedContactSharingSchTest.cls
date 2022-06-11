@istest
public class HWS_AuthorizedContactSharingSchTest {
	public static testMethod void testschedule() {
		
		Test.StartTest();
		List<Case> childCaseList = new List<Case>();		
		HWS_AuthorizedContactSharingSchedulable sh1 = new HWS_AuthorizedContactSharingSchedulable(childCaseList);
		String sch = '0 0 23 * * ?'; 
		system.schedule('Test Territory Check', sch, sh1); Test.stopTest(); 
	}
}