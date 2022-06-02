/***
* Test Class created for the PRM_Helper class
* Created By: Joao Rodrigues - COE Sales team - Portugal
* Created Date: 18/12/2019
***/
@isTest
public class PRMHelperTest 
{
	/**
	* Description : Test data to be created.
	* @param Id NA 
	* @return NA
	**/
	@testSetup 
	static void datasetup() 
	{	  
		Account distributorAcc = PRM_TestDataFactory.createPartnerAccount(1, GlobalConstants.PARTNER_TYPE_DISTR)[0];
		List<Account> resellerAccList = PRM_TestDataFactory.createPartnerAccount(2, GlobalConstants.PARTNER_TYPE_IR);
		List<Account> accountList = new List<Account>();
		accountList.add(distributorAcc);
		accountList.addAll(resellerAccList);
		Database.insert(accountList);
		
		List<Partner> partnerList = PRM_TestDataFactory.createPartnerRelation(2, distributorAcc.Id, GlobalConstants.PARTNER_TYPE_IR);
		partnerList[0].AccountToId = resellerAccList[0].Id;
		partnerList[1].AccountToId = resellerAccList[1].Id;
		Database.insert(partnerList);
	}
	
	/**
	* Description : Test method to cover functionality.
	* @param Id NA 
	* @return NA
	**/
	static testmethod void test1()
	{
		Account acc = [SELECT Id FROM Account WHERE BusinessPartnerRole__c = :GlobalConstants.PARTNER_TYPE_DISTR LIMIT 1];

		Test.startTest();
		PRMHelper.getBpDetails(acc.Id);
		PRMHelper.getDistAndIR(acc.Id, false);
		PRMHelper.orderSet(new Set<String>());
		Test.stopTest();
	}
}