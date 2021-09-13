/**
 * Created By: Accenture IDC
 * Created Date: 5/2/2017
 **/
@isTest
public class CommunityDynamicImageTest {
/**
* Description : Method to create the test data.
* @param NA 
* @return NA
**/	@testSetup static void datasetup(){
		User_Partner_Type__c obj = new User_Partner_Type__c();
		obj.name = PRMGlobalConstants.Testtext;
		obj.Heading__c = PRMGlobalConstants.Testtext;
		Database.insert(obj);
	}
	/**
* Description : Method to cover the class functionality.
* @param NA 
* @return NA
**/
	public static testmethod void test1(){
		Test.startTest();
		CommunityDynamicImage.getUserPartner();
		CommunityDynamicImage.getUserHeading();
		Test.stopTest();
	}
}