@isTest
/***
* Test Class created for the PartnerCompaniesRecord class
* Created By: Joao Rodrigues - COE Sales team - Portugal
* Created Date: 18/12/2019
***/
public class PartnerCompaniesRecordsTest
{
	/**
	* Description : Test data to be created.
	* @param Id NA 
	* @return NA
	**/
	@testSetup static void datasetup() 
	{
		Account partnerAcc = PRM_TestDataFactory.createPartnerAccount(1, GlobalConstants.PARTNER_TYPE_IR)[0];
		Database.insert(partnerAcc);
		
		List<Partner_Company__c> lstPartnerComp = new List<Partner_Company__c>();
		lstPartnerComp.addAll(PRM_TestDataFactory.createrPartnerCompany(1, partnerAcc.id, GlobalConstants.PARTNER_TYPE_IR,'Market Europe','Portugal'));
		lstPartnerComp.addAll(PRM_TestDataFactory.createrPartnerCompany(1, partnerAcc.id, GlobalConstants.PARTNER_TYPE_IR,'Market Europe','Spain')); 
		Database.insert(lstPartnerComp);
	}
	/**
	* Description : Test method to cover functionality.
	* @param Id NA 
	* @return NA
	**/
	static testmethod void test1()
	{
		Account acc = [SELECT Id FROM Account WHERE BusinessPartnerRole__c = :GlobalConstants.PARTNER_TYPE_IR LIMIT 1];
		Test.startTest();
		PartnerCompaniesRecords.getPartnerCompforComponent(acc.Id);
		Test.stopTest();
	}
}