/**
 * @File Name		  : CH_CaseFlow_Test.cls
 * @Description		: 
 * @Author			 : tiago.almeida@nokia.com
 * @Group			  : 
 * @Last Modified By   : tiago.almeida@nokia.com
 * @Last Modified On   : 6/18/2019, 2:24:18 PM
 * @Modification Log   : 
 *==============================================================================
 * Ver		 Date					 Author			  Modification
 *==============================================================================
 * 1.0	6/18/2019, 2:24:18 PM   tiago.almeida@nokia.com	 Initial Version
**/
@isTest(SeeAllData =False)
public class CH_CaseFlow_Test {
	private static Account oLegalEntity;
	private static Contact oContact;
	private static Asset oAsset;
	private static List<Entitlement> oEntitlementList;
	private static List<Product2> oProduct2List;
	private static Case oCase;

	@testSetup	
	static void setupTestData() {
		List<Account> oProspectList = TestDataFactory.createAccount('Prospect', 1, null);
		insert oProspectList;
		//
		oLegalEntity = TestDataFactory.createAccount('Legal_Entity', 1, oProspectList.get(0).Id).get(0);
		insert oLegalEntity;
		//
		oContact = TestDataFactory.createContact(1, oProspectList.get(0)).get(0);
		oContact.LastName = 'Test LastName';
		oContact.CH_ContactType__c = 'customer';
		insert oContact;
		//
		oProduct2List = TestDataFactory.createProduct(1);
		insert oProduct2List;
		//
		oAsset = TestDataFactory.createAsset('CH_CoveredProduct', 1, oLegalEntity, oProduct2List.get(0)).get(0);
		insert oAsset;
		//
		oEntitlementList = TestDataFactory.createEntitlement(1, oProspectList.get(0), oAsset);
		insert oEntitlementList;
		//
		List<EntitlementContact> oEntitlementContactList = TestDataFactory.createEntitlementContact(1, oEntitlementList.get(0), oContact);
		insert oEntitlementContactList;
		//
		oCase = TestDataFactory.createCase('CH_NokiaIncidentWithRestoration', 1, oLegalEntity, oContact, oProduct2List.get(0)).get(0);
	}
	
	public testMethod static void test1() {
		setupTestData() ;
		Test.StartTest();
		CH_CaseFlow_Controller.saveCase('insert', JSON.serialize(new List<case>{oCase}));
		//
		CH_CaseFlow_Controller.getCaseInitiationDateTime();
		CH_CaseFlow_Controller.getStandardCaseRecordTypeId();
		CH_CaseFlow_Controller.getContactNameAndId();
		CH_CaseFlow_Controller.getCaseOwnerId();
		CH_CaseFlow_Controller.getArticles();
		//	   
		CH_CaseFlow_Controller.getLegalEntities(true, oContact.id, true);
		CH_CaseFlow_Controller.getLegalEntities(true, oContact.id, false);
		CH_CaseFlow_Controller.getLegalEntities(false, oContact.id, true);
		CH_CaseFlow_Controller.getLegalEntities(false, oContact.id, false);
		//
		CH_CaseFlow_Controller.getAssets(true, oLegalEntity.Id, oContact.id, 'Customer Support', false);
		CH_CaseFlow_Controller.getAssets(true, oLegalEntity.Id, oContact.id, 'Internal Support', false);
		CH_CaseFlow_Controller.getAssets(true, oLegalEntity.Id, oContact.id, 'Customer Support', true);
		CH_CaseFlow_Controller.getAssets(false, oLegalEntity.Id, oContact.id, 'Customer Support', false);
		CH_CaseFlow_Controller.getAssets(false, oLegalEntity.Id, oContact.id, 'Internal Support', false);
		CH_CaseFlow_Controller.getAssets(false, oLegalEntity.Id, oContact.id, 'Customer Support', true);
		//
		CH_CaseFlow_Controller.getEntitlements(true, oLegalEntity.Id, oAsset.Id, oContact.id, 'Customer Support', false);
		CH_CaseFlow_Controller.getEntitlements(true, oLegalEntity.Id, oAsset.Id, oContact.id, 'Internal Support', false);
		CH_CaseFlow_Controller.getEntitlements(true, oLegalEntity.Id, oAsset.Id, oContact.id, 'Customer Support', true);
		CH_CaseFlow_Controller.getEntitlements(false, oLegalEntity.Id, oAsset.Id, oContact.id, 'Customer Support', false);
		CH_CaseFlow_Controller.getEntitlements(false, oLegalEntity.Id, oAsset.Id, oContact.id, 'Internal Support', false);
		CH_CaseFlow_Controller.getEntitlements(false, oLegalEntity.Id, oAsset.Id, oContact.id, 'Customer Support', true);
		Test.StopTest();		 
	}
	
	public testMethod static void test2() {
		setupTestData();
		Test.StartTest();
		insert oCase;
		CH_CaseFlow_Controller.getAllLegalEntities('Test', oContact.id, 'Customer Support');
		CH_CaseFlow_Controller.accountRelatedIsAuth(oContact.id, oLegalEntity.Id);
		try { CH_CaseFlow_Controller.getInternalAccount(); } catch(Exception e) {}
		CH_CaseFlow_Controller.getContactName(oContact.Id);
		CH_CaseFlow_Controller.enableReEntitlement(oCase.Id);
		CH_CaseFlow_Controller.checkPermissionSet('CH_KB_Workgroup_Admin');
		CH_CaseFlow_Controller.checkProfile('System Administrator');
		CH_CaseFlow_Controller.getCurrentUser();
		CH_CaseFlow_Controller.hasOnlyReadAccess(oCase.Id);
		CH_CaseFlow_Controller.getEntitlementTabData(oCase.Id);
		CH_CaseFlow_Controller.getCaseDetails(oCase.Id);
		CH_CaseFlow_Controller.updateEntitlementScript(oCase.Id);
		CH_CaseFlow_Controller.isP20OrderEditAllowed(oCase.Id);
		CH_CaseFlow_Controller.redirectScreen('System Administrator','CH_KB_Workgroup_Admin' );
		CH_CaseFlow_Controller.redirectScreen('System Administrator','CH_KB_Workgroup_Admin1');
		CH_CaseFlow_Controller.redirectScreen('','');
		CH_CaseFlow_Controller.checkProfile('');
		CH_CaseFlow_Controller.checkProfile('Standard');
		CH_CaseFlow_Controller.checkPermissionSet('');
		CH_CaseFlow_Controller.enableReEntitlement(null);
		CH_CaseFlow_Controller.displayP20fields(oEntitlementList.get(0).Id);
		Test.StopTest();
	}
	
	public testMethod static void test3() {
		setupTestData();
		Test.StartTest();
		insert oCase;
		Asset oNewAsset = TestDataFactory.createAsset('CH_CoveredProduct', 1, oLegalEntity, oProduct2List.get(0)).get(0);
		CH_CaseFlow_Controller.saveAsset('insert', JSON.serialize(new List<Asset>{oNewAsset}));
		CH_CaseFlow_Controller.getAssetDetails(oAsset.Id);
		CH_CaseFlow_Controller.hasAssetEditAcess(oAsset.Id, new List<String>{'Name'});
		CH_CaseFlow_Controller.hasCaseEditAcess(oCase.Id, new List<String>{'Subject'});
		CH_CaseFlow_Controller.accessCheck(oCase.Id);
		CH_CaseFlow_Controller.newPostToProblem(oCase.Id);
		CH_CaseFlow_Controller.disassociateNewProblem(oCase.Id);
		try { CH_CaseFlow_Controller.saveAsset('upsert', null); } catch(Exception e) {}
		try { CH_CaseFlow_Controller.saveAsset('update', null); } catch(Exception e) {}
		try { CH_CaseFlow_Controller.saveCase('upsert', null); } catch(Exception e) {}
		try { CH_CaseFlow_Controller.saveCase('update', null); } catch(Exception e) {}
		try { CH_CaseFlow_Controller.disassociateNewProblem('-1'); } catch(Exception e) {}
		try { CH_CaseFlow_Controller.newPostToProblem('-1'); } catch(Exception e) {}
		try { CH_CaseFlow_Controller.displayP20fields('-1'); } catch(Exception e) {}
		try { CH_CaseFlow_Controller.updateEntitlementScript('-1'); } catch(Exception e) {}
		Test.StopTest();
	}
}