/***************************************************************
* Class Name : CH_lookUpControllerTest
* Created Date: 28 June 2019
* Description : Test class for CH_lookUpController
***************************************************************/
@IsTest
public class CH_lookUpControllerTest {
	
	public testMethod static void fetchWorkGroupTest()
	{
		 Product2 prodObj = new Product2();
			prodObj.Name ='Test';
			prodObj.ProductCode ='133-047489_00';
			prodObj.DataUsage__c = 'CARES';
			prodObj.PMD_Portfolio_Classification__c = 'Product';
			prodObj.NCP_CAREACTIVATE__c ='Test';
			prodObj.DataUsage__c='CARES';
			prodObj.NCP_CAREACTIVATE__c='Test';
			prodObj.CH_ParentProductId__c=prodObj.Id;
	insert prodObj;
	
		 test.startTest();
		 CH_lookUpController.fetchWorkGroup('Test',prodObj.Id);
		 test.stopTest();
		
	}

}