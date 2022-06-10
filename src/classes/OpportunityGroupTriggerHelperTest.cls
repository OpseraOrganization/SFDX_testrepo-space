/****************************************
* Name : OpportunityGroupTriggerHelperTest
* Author : Accenture
* Description : Test class for OpportunityGroupTriggerHelper
*****************************************/
@istest
private with sharing class OpportunityGroupTriggerHelperTest
{
	private static List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
	private static Id oppIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_record_type).getRecordTypeId();
	private static Id frameDealRecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByDeveloperName().get('Framed_Deal').getRecordTypeId();
	private static Id upsellDealRecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByDeveloperName().get('Upsell_Deal').getRecordTypeId();
	private static Id simpleDealRecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByDeveloperName().get('Simple_Deal').getRecordTypeId();
	static testMethod void populateUnweightedValueofOpptyGroupTest()
	{
		Test.startTest();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		insert accountCreation;
		Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
		optyCreation.Unweighted_Amount_EUR__c = 545;
		database.insert(optyCreation);
		Deal__c dealCreation = TestDataFactory.createDeal(1)[0];
		database.insert(dealCreation);
		Opportunity_Group__c opptyGroup = TestDataFactory.DealOpptyGroupingCreation(1,optyCreation, dealCreation)[0];
		database.insert(opptyGroup);
		OpportunityGroupTriggerHelper.populateUnweightedValueofGroupingObject(Null);
		Test.stopTest();
	}
	static testMethod void restrictOpptyAssociationWithSameDealTest()
	{

		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		insert accountCreation;
		List<Opportunity> optyCreationList = TestDataFactory.OpportunityCreation(2,accountCreation);
		database.insert(optyCreationList);
		List<Deal__c> dealCreationList = TestDataFactory.createDeal(2);
		database.insert(dealCreationList);
		Test.startTest();
		List<Opportunity_Group__c> opptyGroupList = TestDataFactory.DealOpptyGroupingCreation(3,optyCreationList[0], dealCreationList[0]);
		database.insert(opptyGroupList[0]);
		Test.stopTest();
		try{
			database.insert(opptyGroupList[1]);
			database.insert(opptyGroupList[2]);
		}catch(Exception ex){
	String message = ex.getMessage();
	system.assert(message.contains(System.label.ExistingOpptyDealCombinationError), 'message=' + message);
		}
		OpportunityGroupTriggerHelper.restrictOpptyAssociationWithSameDeal(Null);
	}
/*
	static testMethod void associationChangeFromMasterToSubordinateTest()
	{
		Test.startTest();
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		insert accountCreation;
		List<Opportunity> optyCreationList = TestDataFactory.OpportunityCreation(2,accountCreation);
		database.insert(optyCreationList);
		List<Deal__c> dealCreationList = TestDataFactory.createDeal(4);
		dealCreationList[0].RecordTypeId = frameDealRecordTypeId;
		dealCreationList[1].RecordTypeId = upsellDealRecordTypeId;
		dealCreationList[2].RecordTypeId = upsellDealRecordTypeId;
		dealCreationList[3].RecordTypeId = frameDealRecordTypeId;
		database.insert(dealCreationList);
		List<Opportunity_Group__c> opptyGroupList = TestDataFactory.DealOpptyGroupingCreation(4,optyCreationList[0], dealCreationList[0]);
		opptyGroupList[0].Opportunity_Relation__c = 'Master';
		opptyGroupList[1].deal__c = dealCreationList[2].id;
		opptyGroupList[1].Opportunity__c = optyCreationList[1].id;
		opptyGroupList[1].Opportunity_Relation__c = 'Master';
		opptyGroupList[2].deal__c = dealCreationList[1].id;
		opptyGroupList[2].Opportunity_Relation__c = 'Master';
		opptyGroupList[3].deal__c = dealCreationList[3].id;
		opptyGroupList[3].Opportunity__c = optyCreationList[1].id;
		opptyGroupList[3].Opportunity_Relation__c = 'Master';
		database.insert(opptyGroupList);
		opptyGroupList[1].Opportunity_Relation__c = 'Subordinate';
		opptyGroupList[0].Opportunity_Relation__c = 'Subordinate';
		opptyGroupList[3].Opportunity_Relation__c = 'Subordinate';
		try{
			update opptyGroupList; }
		catch(Exception ex){
			String message = ex.getMessage();
			system.assert(message.contains('This deal combination is only valid for master opportunities.'), 'message=' + message);
		}

		OpportunityGroupTriggerHelper.associationChangeFromMasterToSubordinate(Null,Null);
		Test.stopTest();
	}
	*/
	static testMethod void checkIfDealHasMasterOpptyOnAssociationUpdateTest()
	{

		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		insert accountCreation;
		List<Opportunity> optyCreationList = TestDataFactory.OpportunityCreation(2,accountCreation);
		database.insert(optyCreationList);
		List<Deal__c> dealCreationList = TestDataFactory.createDeal(2);
		dealCreationList[0].RecordTypeId = frameDealRecordTypeId;
		dealCreationList[1].RecordTypeId = frameDealRecordTypeId;
		database.insert(dealCreationList);
		Test.startTest();
		List<Opportunity_Group__c> opptyGroupList = TestDataFactory.DealOpptyGroupingCreation(2,optyCreationList[0], dealCreationList[0]);
		opptyGroupList[1].Opportunity__c = optyCreationList[1].id;
		opptyGroupList[1].Opportunity_Relation__c = 'Master';
		database.insert(opptyGroupList);
		opptyGroupList[0].Opportunity_Relation__c = 'Master';
		try{
			update opptyGroupList; }
		catch(Exception ex){
			String message = ex.getMessage();
			system.assert(message.contains(System.label.MasterOpptyonDealError), 'message=' + message);
		}
		OpportunityGroupTriggerHelper.checkIfDealHasMasterOpptyOnAssociationUpdate(Null,Null);
		Test.stopTest();
	}
	static testMethod void checkIfDealHasAlreadyMasterOpptyTest()
	{

		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		insert accountCreation;
		List<Opportunity> optyCreationList = TestDataFactory.OpportunityCreation(3,accountCreation);
		database.insert(optyCreationList);
		List<Deal__c> dealCreationList = TestDataFactory.createDeal(2);
		dealCreationList[0].RecordTypeId = frameDealRecordTypeId;
		dealCreationList[1].RecordTypeId = frameDealRecordTypeId;
		database.insert(dealCreationList);
		Test.startTest();
		List<Opportunity_Group__c> opptyGroupList = TestDataFactory.DealOpptyGroupingCreation(3,optyCreationList[0], dealCreationList[0]);
		opptyGroupList[1].Opportunity__c = optyCreationList[1].id;
		opptyGroupList[0].Opportunity_Relation__c = 'Master';
		database.insert(opptyGroupList[0]);
		opptyGroupList[2].Opportunity__c = optyCreationList[2].id;
		opptyGroupList[1].Opportunity_Relation__c = 'Master';
		opptyGroupList[2].Opportunity_Relation__c = 'Master';
		try{
			database.insert(opptyGroupList[1]);
			database.insert(opptyGroupList[2]);}
		catch(Exception ex){
			String message = ex.getMessage();
			system.assert(message.contains(System.label.MasterOpptyonDealError), 'message=' + message);
		}
		OpportunityGroupTriggerHelper.checkIfDealHasAlreadyMasterOppty(Null);
		Test.stopTest();
	}
	static testMethod void validateCorrectDealOpptyCombinationTest()
	{
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		insert accountCreation;
		List<Opportunity> optyCreationList = TestDataFactory.OpportunityCreation(2,accountCreation);
		database.insert(optyCreationList);
		List<Deal__c> dealCreationList = TestDataFactory.createDeal(4);
		dealCreationList[0].RecordTypeId = frameDealRecordTypeId;
		dealCreationList[1].RecordTypeId = upsellDealRecordTypeId;
		dealCreationList[2].RecordTypeId = upsellDealRecordTypeId;
		dealCreationList[3].RecordTypeId = frameDealRecordTypeId;
		database.insert(dealCreationList);
		Test.startTest();
		List<Opportunity_Group__c> opptyGroupList = TestDataFactory.DealOpptyGroupingCreation(4,optyCreationList[0], dealCreationList[0]);
		opptyGroupList[2].Deal__c = dealCreationList[3].id;
		opptyGroupList[1].Opportunity_Relation__c = 'Master';
		opptyGroupList[1].Opportunity__c = optyCreationList[1].id;
		opptyGroupList[3].Opportunity__c = optyCreationList[1].id;
		opptyGroupList[1].Deal__c = dealCreationList[1].id;
		opptyGroupList[3].Deal__c = dealCreationList[3].id;
		try{
			database.insert(opptyGroupList[0]);
			database.insert(opptyGroupList[2]);}
		catch(Exception ex){
			String message = ex.getMessage();
			system.assert(message.contains(System.label.InvalidDealCombinationError), 'message=' + message);
		}
		try{
			database.insert(opptyGroupList[1]);
			database.insert(opptyGroupList[3]);}
		catch(Exception ex){
			String message = ex.getMessage();
			system.assert(message.contains(System.label.InvalidDealCombinationError_MasterOppty), 'message=' + message);
		}
		OpportunityGroupTriggerHelper.checkIfDealHasAlreadyMasterOppty(Null);
		Test.stopTest();
	}
	static testMethod void beforeDeleteCheckOpptyRecordTypeTest()
	{

		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		insert accountCreation;
		Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
		database.insert(optyCreation);
		Deal__c dealCreation = TestDataFactory.createDeal(1)[0];
		database.insert(dealCreation);
		Test.startTest();
		Opportunity_Group__c opptyGroup = TestDataFactory.DealOpptyGroupingCreation(1,optyCreation,dealCreation)[0];
		database.insert(opptyGroup);
		optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
		optyCreation.Phase_Status__c = GlobalConstants.SUBMITTED_FOR_G3_APPROVAL;
		database.update(optyCreation);
		try{
			database.delete(opptyGroup);}
		catch(Exception ex){
			String message = ex.getMessage();
			system.assert(message.contains(System.label.ErrorOnDeletingDealOpptyGroupRecord), 'message=' + message);
		}
		optyCreation.StageName = 'Closed - Obsolete';
		optyCreation.Phase_Status__c = GlobalConstants.PHASE_STATUS;
		database.update(optyCreation);
		try{
			database.delete(opptyGroup);}
		catch(Exception ex){
			String message = ex.getMessage();
			system.assert(message.contains(System.label.ErrorOnDeletingDealOpptyGroupRecord), 'message=' + message);
		}
		OpportunityGroupTriggerHelper.beforeDeleteCheckOpptyRecordType(Null);
		Test.stopTest();
	}
}