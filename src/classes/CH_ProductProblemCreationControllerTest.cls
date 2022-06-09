@isTest(seeAlldata=false)
public class CH_ProductProblemCreationControllerTest {
	
	static testmethod void CH_ProductProblemCreationControllerMethod(){
		Profile sa = [SELECT Id FROM Profile WHERE Name='System Administrator'];
		Profile ip = [SELECT Id FROM Profile WHERE Name='Integration API Only Profile'];
		CH_Integration_Profiles__c cp = new CH_Integration_Profiles__c();
		cp.Name = 'System Administrator';
		cp.CH_ProfileId__c = sa.Id;
		insert cp;
		
		CH_Integration_Profiles__c cp1 = new CH_Integration_Profiles__c();
		cp1.Name = 'Integration API Only Profile';
		cp1.CH_ProfileId__c = ip.Id;
		insert cp1;
		
		CH_ProductProblemCreationController_COE.getRecordProblemTypeID();
		CH_ProductProblemCreationController_COE.validatePermissionSet();
		List<Product2> productlist =new List<Product2>();
		productlist = CH_EntitlementTestData.createProductRecord(2);
		insert productlist;
		CH_ProductProblemCreationController_COE.getProductDataUsageForStandAloneProblem(productlist[0].id);
	}	
	
}