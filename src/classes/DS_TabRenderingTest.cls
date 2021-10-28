/****************************************
* Name : DS_TabRenderingTest
* Author : Accenture
*****************************************/
@isTest
private class DS_TabRenderingTest{
	public testmethod static void createTestDP(){
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser) {
			Account account = TestDataFactory.createAccount(1)[0];
			insert account;

			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName = dateString + randomInt;

			User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com', emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
			languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = UserInfo.getProfileId(), Country__c= 'Canada', Market__c = 'MARKET NORTH AMERICA',
			timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org', Restriction_Level__c = 'Confidential', Nokia_ID__c = randomInt + '0');
			insert user1;

			//Creating Custom Setting Data
			CH_AccountName__c accauth = new CH_AccountName__c();
			accauth.CH_InvalidName__c = 'Nokia';
			accauth.CH_ValidName__c = 'Nokia-OYJ';
			insert accauth;

			List<Contact> contacts = new List<Contact>();
			Contact c = new Contact(lastName = CSWXGlobalConstant.ContactNameDS, AccountId = account.Id, Email = CSWXGlobalConstant.EmailContactNameDS);
			Contact c2 = new Contact(lastName = CSWXGlobalConstant.ContactNameDS, AccountId = account.Id, Email = CSWXGlobalConstant.EmailContactNameDS);
			contacts.add(c);
			contacts.add(c2);
			database.insert(contacts);

			User userDS = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
			languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = '00e410000022ds8'/*system.Label.PRM_Partner_Relationship_Manager_Login_ID*/,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
			timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '00',ContactId  = c.Id );


			system.runAs(user1){
	insert userDS;
	userDS.IsPortalEnabled =  True;
	update userDS;
			}

			File_Upload__c fu = new File_Upload__c();
			fu.Technology__c = CSWXGlobalConstant.Technology ;
			fu.Use_Case__c = CSWXGlobalConstant.Usecase  ;
			fu.Account__c = account.id;
			insert fu;

			ContentVersion contentVersion = new ContentVersion();
			ContentDocumentLink cdLink = new ContentDocumentLink();
			contentVersion = TestDataFactory.createContentVersion(1)[0];

			contentVersion.title = CSWXGlobalConstant.benchmarking;
			insert contentVersion;

			Id cdId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1].ContentDocumentId;
			cdLink = TestDataFactory.createContentDocumentLink(1, account.id, cdId)[0];
			cdLink.LinkedEntityId = fu.id;
			insert cdLink;

			List<DP_PortalFilter__c> csList = new List<DP_PortalFilter__c>();
			DP_PortalFilter__c cs1 = new DP_PortalFilter__c();
			cs1.Name = CSWXGlobalConstant.csAllProposal;
			cs1.ProposalStage__c = CSWXGlobalConstant.ACTIVE;
			cs1.Upsell_Stage__c = CSWXGlobalConstant.readyForReview;
			csList.add(cs1);


			DP_PortalFilter__c cs2 = new DP_PortalFilter__c();
			cs2.Name = CSWXGlobalConstant.csClosedProposal;
			cs2.ProposalStage__c = CSWXGlobalConstant.Approval_stage_Cancel;
			cs2.Upsell_Stage__c = CSWXGlobalConstant.Approval_stage_Cancel;
			csList.add(cs2);

			DP_PortalFilter__c cs3 = new DP_PortalFilter__c();
			cs3.Name = CSWXGlobalConstant.csForYourReview;
			cs3.ProposalStage__c = CSWXGlobalConstant.ACTIVE;
			cs3.Upsell_Stage__c = CSWXGlobalConstant.readyForReview;
			csList.add(cs3);

			DP_PortalFilter__c cs4 = new DP_PortalFilter__c();
			cs4.Name = CSWXGlobalConstant.csValidatedProposal;
			cs4.ProposalStage__c = CSWXGlobalConstant.VALIDATED ;
			cs4.Upsell_Stage__c = CSWXGlobalConstant.convert;
			csList.add(cs4);

			insert csList;

			SWx_Upsell_Proposal__c proposal = TestDataFactory.upsellList(1, account)[0];
			proposal.Analytics_File_Refer_ID__c = 'GBR-61940-82356';
			proposal.Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource_CCRE ;
			proposal.Proposal_Status__c = CSWXGlobalConstant.ACTIVE;
			proposal.Upsell_Status__c = CSWXGlobalConstant.readyForReview ;

			proposal.Proposal_Recommendation_Type__c = 'renewal';
			proposal.P20_Id__c = 215616;
			proposal.CurrencyIsoCode = 'EUR';
			proposal.Unweighted_Value__c = 429052.07;
			proposal.Account_ID__c = account.id;
			proposal.Technology__c = CSWXGlobalConstant.Technology ;
			proposal.Use_Case__c = CSWXGlobalConstant.Usecase ;
			proposal.DS_Show_In_Portal__c = true;
			proposal.Sold_To_Party__c = account.id;
			insert proposal;

			DS_Recommendation_Type__c recommendationType = new DS_Recommendation_Type__c(name = 'CXM');
			insert recommendationType;

			System.runAs(userDS) {
	Test.startTest();
	List<String> recommendationTypeList = DS_TabRendering.Get_typepicklist();
	List<String> technologyList = DS_TabRendering.getTechnologies();
	List<String> useCaseList = DS_TabRendering.getUseCaseOnTechnology('TDD LTE');

	List<String> techList = new List<String>();
	techList.add('TDD LTE');
	techList.add('FDD LTE');

	List<String> ucList = new List<String>();
	ucList.add('Energy Efficiency');
	ucList.add('eNB User Capacity');
	ucList.add('Load Balancing');

	List<SWx_Upsell_Proposal__c> filterDP = DS_TabRendering.filterDPRecord(techList[0], ucList[0], CSWXGlobalConstant.allProposal, CSWXGlobalConstant.NONE, recommendationType.name);
	List<SWx_Upsell_Proposal__c> filterDP2 = DS_TabRendering.filterDPRecord(techList[0], ucList[0], CSWXGlobalConstant.csClosedProposal, CSWXGlobalConstant.NONE, recommendationType.name);
	List<SWx_Upsell_Proposal__c> filterDP4 = DS_TabRendering.filterDPRecord(techList[0], ucList[0], CSWXGlobalConstant.csForYourReview, CSWXGlobalConstant.NONE, recommendationType.name);
	List<SWx_Upsell_Proposal__c> filterDP3 = DS_TabRendering.filterDPRecord(techList[0], ucList[0], CSWXGlobalConstant.csValidatedProposal, CSWXGlobalConstant.NONE, recommendationType.name);
	List<SWx_Upsell_Proposal__c> filterDP5 = DS_TabRendering.filterDPRecord(CSWXGlobalConstant.NONE, CSWXGlobalConstant.NONE, CSWXGlobalConstant.NONE,CSWXGlobalConstant.NONE, recommendationType.name);
	List<SWx_Upsell_Proposal__c> filterDP6 = DS_TabRendering.filterDPRecord('234', '123', CSWXGlobalConstant.NONE, CSWXGlobalConstant.NONE, recommendationType.name);

	List<SWx_Upsell_Proposal__c> filterDP7 = DS_TabRendering.filterDPRecord(techList[0], CSWXGlobalConstant.NONE_OPTION_VALUE, CSWXGlobalConstant.allProposal, CSWXGlobalConstant.QuoteNeeded, recommendationType.name);
	List<SWx_Upsell_Proposal__c> filterDP8 = DS_TabRendering.filterDPRecord(techList[0], CSWXGlobalConstant.NONE_OPTION_VALUE, CSWXGlobalConstant.csClosedProposal, CSWXGlobalConstant.CanNotEntitled, recommendationType.name);
	List<SWx_Upsell_Proposal__c> filterDP9 = DS_TabRendering.filterDPRecord(techList[0], CSWXGlobalConstant.NONE_OPTION_VALUE, CSWXGlobalConstant.csForYourReview, CSWXGlobalConstant.CanBeEntitled, recommendationType.name);
	List<SWx_Upsell_Proposal__c> filterDP10 = DS_TabRendering.filterDPRecord(techList[0], CSWXGlobalConstant.NONE_OPTION_VALUE, CSWXGlobalConstant.csValidatedProposal, CSWXGlobalConstant.Entitled, recommendationType.name);

	List<SWx_Upsell_Proposal__c> filterDP11 = DS_TabRendering.filterDPRecord(CSWXGlobalConstant.NONE_OPTION_VALUE, CSWXGlobalConstant.NONE_OPTION_VALUE, CSWXGlobalConstant.allProposal, CSWXGlobalConstant.NONE, recommendationType.name);
	List<SWx_Upsell_Proposal__c> filterDP12 = DS_TabRendering.filterDPRecord(CSWXGlobalConstant.NONE_OPTION_VALUE, CSWXGlobalConstant.NONE_OPTION_VALUE, CSWXGlobalConstant.csClosedProposal, CSWXGlobalConstant.NONE, recommendationType.name);
	List<SWx_Upsell_Proposal__c> filterDP13 = DS_TabRendering.filterDPRecord(CSWXGlobalConstant.NONE_OPTION_VALUE, CSWXGlobalConstant.NONE_OPTION_VALUE, CSWXGlobalConstant.csForYourReview, CSWXGlobalConstant.NONE, recommendationType.name);
	List<SWx_Upsell_Proposal__c> filterDP14 = DS_TabRendering.filterDPRecord(CSWXGlobalConstant.NONE_OPTION_VALUE, CSWXGlobalConstant.NONE_OPTION_VALUE, CSWXGlobalConstant.csValidatedProposal, CSWXGlobalConstant.NONE, recommendationType.name);

	List <SWx_Upsell_Proposal__c> sorttest = DS_TabRendering.sortDPRec('Entitlement_Info__c', true, techList[0], ucList[0], CSWXGlobalConstant.csAllProposal, CSWXGlobalConstant.NONE, recommendationType.name);
	List <SWx_Upsell_Proposal__c> sorttest2 = DS_TabRendering.sortDPRec('Identified_Cells__c', true, techList[0], ucList[0], CSWXGlobalConstant.csAllProposal, CSWXGlobalConstant.NONE, recommendationType.name);
	List <SWx_Upsell_Proposal__c> sorttest3 = DS_TabRendering.sortDPRec('Name', false, techList[0], ucList[0], CSWXGlobalConstant.csAllProposal, CSWXGlobalConstant.Entitled, recommendationType.name);
	List <SWx_Upsell_Proposal__c> sorttest4 = DS_TabRendering.sortDPRec('Recommendation_Type__c', false, techList[0], ucList[0], CSWXGlobalConstant.csAllProposal, CSWXGlobalConstant.Entitled, recommendationType.name);
	DS_TabRendering.Get_entitlepicklist();
	System.assertEquals(CSWXGlobalConstant.NONE_OPTION_VALUE, technologyList[0]);
	Test.stopTest();
			}
		}
	}

	public testmethod static void getTechnologyUseCaseTest(){
		Test.startTest();
		DS_Technology_Usecase_Combination__c techCS = new DS_Technology_Usecase_Combination__c();
		techCS.DS_Technology__c = 'TDD LTE';
		techCS.DS_Usecase__c = 'Energy Efficiency';
		techCS.Name = 'Tech_usecase';
		insert techCS;

		DS_Util.getTechnologies();
		DS_Util.getUseCaseOnTechnology(techCS.DS_Technology__c);
		List<String> technologyList = DS_TabRendering.getTechnologies();
		DS_TabRendering.getUseCaseOnTechnology(techCS.DS_Technology__c);
		System.assertEquals(CSWXGlobalConstant.NONE_OPTION_VALUE, technologyList[0]);
		Test.stopTest();
	}

}