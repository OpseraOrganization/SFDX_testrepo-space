/** 
* About 
* ----- 
* @Description	  : Clears User from Case Owner and Case Team Test Class.
* @Project	: Case Handling.
* @Modification Log : 
*  Created  : 2020 10 28 – tiago.almeida@nokia.com
* ----- 
**/
@isTest
public class CH_ClearGroupUserCases_Test {
	private static Set<Id> oUserIdSet = new Set<Id>();
	private static Set<Id> oGroupIdSet = new Set<Id>();
	private static List<Case> oCaseList;

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
		String groupName = 'CH_Test' + Utils.generateRandomInteger(2) + Utils.generateRandomString(2);
		Group oGroup = new Group(
			Name = groupName,
			DeveloperName = groupName,
			Type = 'Regular'
		);
		insert oGroup;
		oUserIdSet.add(UserInfo.getUserId());
		oGroupIdSet.add(oGroup.Id);
		//
		CH_SecurityRule__c oSecurityRule = new CH_SecurityRule__c(
			CH_OrderofExecution__c = 1,
			CH_SecurityGroup__c = groupName,
			CH_GWCSecurityGroup__c = null,
			CH_AccountNumber__c = null,
			CH_AccountCustomerCompliance__c = null,
			CH_ContractNumber__c = null,
			CH_NokiaProductId__c = oProduct2List.get(0).NCP_Nokia_Product_Id__c,
			CH_Country__c = null,
			CH_CARESServiceAgreement__c = null,
			CH_3rdPartySecurityGroup__c = null,
			CH_Active__c = true
		);
		insert oSecurityRule;
		//
		oCaseList = TestDataFactory.createCase('CH_NokiaIncidentWithRestoration', 2, oLegalEntity, oContact, oProduct2List.get(0));
		for(Case oCase : oCaseList) {
			oCase.CH_SecurityGroup__c = groupName;
			oCase.OwnerId = UserInfo.getUserId();
		}
	}
	
	public static testMethod void test() {
		setupTestData();
		test.startTest();
		insert oCaseList;
		CaseTeamMember caseTeamMember = new CaseTeamMember();
		caseTeamMember.ParentId = oCaseList.get(0).Id;
		caseTeamMember.MemberId = UserInfo.getUserId();
		caseTeamMember.TeamRoleId = [SELECT Id FROM CaseTeamRole LIMIT 1].Id;
		insert caseTeamMember;
		//
		CH_ClearGroupUserCases.execute(oUserIdSet, oGroupIdSet);
		test.stopTest();
	}

}