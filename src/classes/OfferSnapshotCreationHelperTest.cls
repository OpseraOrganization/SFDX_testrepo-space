@isTest 
public class OfferSnapshotCreationHelperTest
{
	private static final Id OpptyDirect = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.READ_ONLY_PSR_RECORD_TYPE).getRecordTypeId();

	private static User user = new User();
	private static Opportunity oppty = new Opportunity();
	private static List<Offer__c> offers = new List<Offer__c>();
	private static final String market = GlobalConstants.Const_Market + ' ' + GlobalConstants.Const_Ind;

	private static void setup(String userProfile) {
		user = TestDataFactory.userCreation(1,userProfile)[0];
		database.insert(user);
		Account account = new Account();
		account = TestDataFactory.createAccount(1)[0];
		account.L4name__c = market;
		database.insert(account);
		oppty = TestDataFactory.OpportunityCreation(1,account)[0];
		database.insert(oppty);
		offers = TestDataFactory.OfferCreation(2,oppty);
	}
	static testMethod void validateOfferFieldEditForPricingManager() {
		setup('System Administrator');
		Offer__c offer = offers[0];
		offer.Approval_Scope__c = 'Pending';
		database.insert(offer);
		List<Offer_Team__c> offerTeamMemberList = TestDataFactory.offerTeamCreation(1, offer,user);
		Map<Id, Offer__c> filteredOfferMap = new Map<Id, Offer__c>{offer.Id => offer};
		Map<Id, Id> offerIdOpptyIdMap = new Map<Id, Id>{offer.Id => oppty.Id};

		System.runAs(user) {
			Test.startTest();
			database.insert(offerTeamMemberList);
			OfferSnapshotCreationHelper.validateOfferFieldEditForPricingManager(filteredOfferMap,offerIdOpptyIdMap);
			OfferSnapshotCreationHelper.validateOfferFieldEditForPricingManager(null,null);
			Test.stopTest();
		}
	}

	static testMethod void validateApprovalScopeTest() {
		setup('Excel Add-In Profile');
		Map<ID,Offer__c> offerMap = new map<Id,Offer__c>();
		Offer__c offer = offers[0];
		offer.Approval_Scope__c = 'Pending';
		offer.Customer_and_Competitive_Situation__c = 'Pending';
		system.runAs(user){
			Test.startTest();
			insert offer;
			offerMap.put(offer.id,offer);
			OfferSnapshotCreationHelper.validateOfferFieldsLoA(offerMap,offerMap);
			Test.stopTest();
		}
	}

	static testMethod void validateLoABypassOfferConditionFieldValueTest(){

		Map<Id, Offer__c> newMap = new Map<Id, Offer__c>();
		Map<Id, Offer__c> oldMap = new Map<Id, Offer__c>();
		setup('System Administrator');
		Offer__c offer = offers[0];
		database.insert(offer);
		oldMap.put(offer.Id, offer);

		Test.startTest();
		Sales_Role__c salesRoleRec = NF_TestDataFactory.createSalesRole(user,'NSNC_PrMBG',market,'4 - BG Pricing Manager');
		insert salesRoleRec;

		Offer_Team__c offerTeamObj = TestDataFactory.offerTeamCreation(1,offer,user)[0];
		offerTeamObj.Team_Member_Role__c = GlobalConstants.OFFER_OPPTY_TEAM_ROLE_PRICING_MANAGER;

		Offer__c offerToUpdate = offer.clone(true,true,true,true);
		offerToUpdate.LOA_Bypass__c=GlobalConstants.PICKLIST_VALUE_AUTHORIZED_FOR_PRICING_MANAGER;

		System.runAs(user)
		{
			insert offerTeamObj;
			database.update(offerToUpdate);
			newMap.put(offerToUpdate.Id, offerToUpdate);
			OfferSnapshotCreationHelper.validateLoABypassOfferConditionFieldValue(oldMap,newMap);
		}
		Test.stopTest();
	}


	static testMethod void CatchException_Test()
	{
		user userCreation = TestDataFactory.userCreation(1,'Global Process Admin Profile')[0];
		database.insert(userCreation);
		system.runAs(userCreation){
			test.starttest();
			OfferSnapshotCreationHelper.validateLoABypassOfferConditionFieldValue(null,null);
			test.stopTest();
		}
	}

	static testMethod void updateOpportunity_ExceptionTest()
	{
		List<Opportunity> opptiesToUpdate = new List<Opportunity>();
		opptiesToUpdate.add(new Opportunity(Id=null));
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);

		system.runAs(userCreation){
			test.starttest();
			OfferSnapshotCreationHelper.updateOpportunity(opptiesToUpdate);
			test.stopTest();
		}
	}
}