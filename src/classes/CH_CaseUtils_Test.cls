/** 
* About 
* ----- 
* @Description	  : Case Handling Case Object Utility Test Class.
* @Project	: Case Handling.
* @Modification Log : 
*  Created  : 2020 02 17 – tiago.almeida@nokia.com
* ----- 
**/ 
@isTest
public class CH_CaseUtils_Test {
	private static Case oCase;

	@testSetup	
	static void setupTestData() {
		List<Account> oProspectList = TestDataFactory.createAccount('Prospect', 1, null);
		insert oProspectList;
		//
		Account oLegalEntity = TestDataFactory.createAccount('Legal_Entity', 1, oProspectList.get(0).Id).get(0);
		insert oLegalEntity;
		//
		Contact oContact = TestDataFactory.createContact(1, oProspectList.get(0)).get(0);
		oContact.LastName = 'Test LastName';
		oContact.CH_ContactType__c = 'customer';
		insert oContact;
		//
		List<Product2> oProduct2List = TestDataFactory.createProduct(1);
		insert oProduct2List;
		//
		Asset oAsset = TestDataFactory.createAsset('CH_CoveredProduct', 1, oLegalEntity, oProduct2List.get(0)).get(0);
		insert oAsset;
		//
		List<Entitlement> oEntitlementList = TestDataFactory.createEntitlement(1, oProspectList.get(0), oAsset);
		insert oEntitlementList;
		//
		List<EntitlementContact> oEntitlementContactList = TestDataFactory.createEntitlementContact(1, oEntitlementList.get(0), oContact);
		insert oEntitlementContactList;
		//
		oCase = TestDataFactory.createCase('CH_NokiaIncidentWithRestoration', 1, oLegalEntity, oContact, oProduct2List.get(0)).get(0);
	}
	public static testMethod void test() {
		setupTestData();
		// 
		test.startTest();
		CH_CaseUtils.getStandardCaseRecordTypeId();
		try { Id caseId = CH_CaseUtils.database('insert', oCase, true);
		oCase = CH_CaseUtils.getCase(caseId);
		CH_CaseUtils.getMilestoneDetails((String) caseId);
		CH_CaseUtils.database('update', oCase, true);
		CH_CaseUtils.database('delete', oCase, true);
		CH_CaseUtils.database('update', oCase, true);
		CH_CaseUtils.database('delete', oCase, true);
		} catch(Exception e) { /* Do Nothing */ }
		
		try { CH_CaseUtils.database('insert', null, true); } catch(Exception e) { /* Do Nothing */ }
		try { CH_CaseUtils.getCase(null); } catch(Exception e) { /* Do Nothing */ }
		try { CH_CaseUtils.getCaseData(oCase.Id); } catch(Exception e) { /* Do Nothing */ }
		try { CH_CaseUtils.getVirtualPortalAttendantId(); } catch(Exception e) { /* Do Nothing */ }
		
		test.stopTest();
	}
}