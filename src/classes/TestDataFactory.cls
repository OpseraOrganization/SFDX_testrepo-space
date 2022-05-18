/** 
 * About 
 * ----- 
 * @Description : TestDataFactory - Data creation
 * @testClass	: None.
 * @project		: All. 
 * @changeLog 	: 
 *  Created  : Accenture
 *  Modified : 2020 03 03 – tiago.almeida@nokia.com
 * ----- 
**/
@isTest
public without sharing class TestDataFactory {
	public static List<Territory2> territoryIdList = new List<Territory2>();
	public static List<Territory2> territoryIdListAnother = new List<Territory2>();
	private static List<Schema.Document> documentList = new List<Schema.Document>();
	private static final String SUFFIX_FIELD = 'trigger__c';
	public static final String BID_MANAGER='Bid Manager';
	public static final String AMERICA_LOSANGELES='America/Los_Angeles';
	public static final String MARKET_NORTH_AMERICA='MARKET NORTH AMERICA';



	public static List<User> userCreation(integer size, string profileName) {
		List<User> userList = new List<User>();
		Id sp = [SELECT Id FROM profile WHERE name =: profileName limit 1].id;
		for (integer i = 0; i < size; i++) {
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
			Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
			String uniqueName = /* orgId + */ dateString + randomInt;
			User user = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */ , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
	languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = sp, Country__c = 'Canada', Market__c = TestDataFactory.MARKET_NORTH_AMERICA, NSA_Compliant__c = False,
	timezonesidkey = TestDataFactory.AMERICA_LOSANGELES, Username = uniqueName + '@nokia.com' + orgId + '.org' /*,Restriction_Level__c = 'Confidential'*/ , Nokia_ID__c = randomInt + '0');

			userList.add(user);
		}
		return userList;
	}

	//Contact Creation with one more field: LastName
	public static List<Contact> createContact2(integer size, Account acc) {
		List<Contact> contactList = new list<Contact>();
		for (integer i = 0; i < size; i++) {
			Contact contactObj = new Contact();
			contactObj.AccountId = acc.id;
			contactObj.LastName = 'Roger';
			contactList.add(contactObj);
		}
		return contactList;
	}

	/*
	 * @description : Method to create a user community
	 * @param size : number of community users to create
	 * @param profileName : name of the profile name
	 * @param roleName : a user role name
	 * @param cont : a contact
	 * @return User : a user
	 */
	public static List<User> userCommunityCreation(Integer size, String profileName, String roleName, Contact cont) {
		List<User> userCommunityList = new List<User>();
		Id sp = [SELECT Id FROM profile WHERE name =: profileName limit 1].Id;
		Id roleId = [SELECT Id FROM userrole WHERE Name =: roleName limit 1].Id;
		User communityUser;
		for (integer i = 0; i < size; i++) {
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
			Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
			String uniqueName = dateString + randomInt;

			communityUser = new User(alias = 'abc', email = uniqueName + '@nokia.com', emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
	languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = sp, Country__c = 'Canada', Market__c = TestDataFactory.MARKET_NORTH_AMERICA, NSA_Compliant__c = False,
	timezonesidkey = TestDataFactory.AMERICA_LOSANGELES, UserRoleId = roleId, Username = uniqueName + '@nokia.com' + orgId + '.org', Nokia_ID__c = randomInt + '0', ContactId = cont.Id);
			userCommunityList.add(communityUser);
		}
		return userCommunityList;
	}

	public static List<User> userWithRoleCreation(Integer size, String profileName, String roleName) {
		List<User> userCommunityList = new List<User>();
		Id sp = [SELECT Id FROM profile WHERE name =: profileName limit 1].Id;
		Id roleId = [SELECT Id FROM userrole WHERE Name =: roleName limit 1].Id;
		User communityUser;
		for (integer i = 0; i < size; i++) {
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
			Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
			String uniqueName = dateString + randomInt;

			communityUser = new User(alias = 'abc', email = uniqueName + '@nokia.com', emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
	languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = sp, Country__c = 'Canada', Market__c = TestDataFactory.MARKET_NORTH_AMERICA, NSA_Compliant__c = False,
	timezonesidkey = TestDataFactory.AMERICA_LOSANGELES, UserRoleId = roleId, Username = uniqueName + '@nokia.com' + orgId + '.org', Nokia_ID__c = randomInt + '0');
			userCommunityList.add(communityUser);
		}
		return userCommunityList;
	}

	public static List<User> userCommunityCreation2(Integer size, String profileName, Contact cont, Account acc) {
		List<User> userCommunityList = new List<User>();
		Id sp = [SELECT Id FROM profile WHERE name =: profileName limit 1].Id;
		User communityUser;
		for (integer i = 0; i < size; i++) {
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
			Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
			String uniqueName = dateString + randomInt;

			communityUser = new User(alias = 'abc', email = uniqueName + '@nokia.com', emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
	languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = sp, Country__c = 'Canada', Market__c = TestDataFactory.MARKET_NORTH_AMERICA, NSA_Compliant__c = False,
	timezonesidkey = TestDataFactory.AMERICA_LOSANGELES, isActive = true, Username = uniqueName + '@nokia.com' + orgId + '.org', Nokia_ID__c = randomInt + '0', ContactId = cont.Id);
			userCommunityList.add(communityUser);
		}
		return userCommunityList;
	}

	/*
	 * @desc	this method creates admin users
	 * @param   lastNAme : string representing users lastName
	 * @param   profileName : the profile to associate to users
	 * @return  User : the created user.
	 */
	public static User createUser(String profileName, String lastName) {
		Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
		String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');
		String uniqueName = dateString + randomInt;
		String orgId = UserInfo.getOrganizationId();
		Profile p;
		User u;
		if ('Admin'.equalsIgnoreCase(profileName)) {
			p = [SELECT Id, Name FROM Profile Where UserType = 'Standard'
	AND PermissionsCustomizeApplication = true AND PermissionsModifyAllData = true AND PermissionsApiUserOnly = false Limit 1
			];
		} else {
			p = [SELECT Id FROM Profile WHERE Name =: profileName];
		}

		u = new User();
		u.alias = 'abc';
		u.email = uniqueName + '@nokia.com';
		u.emailencodingkey = 'UTF-8';
		u.firstName = 'test';
		u.lastname = lastName;
		u.languagelocalekey = 'en_US';
		u.localesidkey = 'en_US';
		u.profileid = p.Id;
		u.Country__c = 'Canada';
		u.Market__c = TestDataFactory.MARKET_NORTH_AMERICA;
		u.NSA_Compliant__c = False;
		u.timezonesidkey = TestDataFactory.AMERICA_LOSANGELES;
		u.Username = uniqueName + '@nokia.com' + orgId + '.org';
		u.Nokia_ID__c = randomInt + '0';
		return u;
	}

	public static list<Account> createAccount(integer size) {
		list<Account> accList = new list<Account>();
		for (integer i = 0; i < size; i++) {
			Account acc = new Account();
			acc.Name = 'Test Account -' + i + Utils.generateRandomInteger(2) + Utils.generateRandomString(2);
			acc.BillingStreet = '1660 International Dr';
			acc.BillingCity = 'McLean';
			acc.BillingState = 'maharashtra';
			acc.BillingPostalCode = '22102';
			acc.BillingCountry = 'india';
			acc.AccountStatusInCRMOM__c = 'Active';
			acc.Industry = 'Enterprise';
			acc.Market__c = 'Market India';
			acc.Country__c = 'India';
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
			acc.AccountNumber = '301030871';

			accList.add(acc);
		}
		return accList;
	}

	/*
	 * @description : this function creates survey questions
	 * @param size : number of the surveys questions
	 * @return List<Survey> : list of suveys questons created
	 */
	public static List<NIA_SurveyQuestionResponse__c> createSurveyQuestionResponse(Integer size) {
		List<NIA_SurveyQuestionResponse__c> surveyQuestionResponseList = new List<NIA_SurveyQuestionResponse__c>();

		for (Integer i = 0; i < size; i++) {
			NIA_SurveyQuestionResponse__c surveyQuestionResponse = new NIA_SurveyQuestionResponse__c();
			surveyQuestionResponse.ResponseShortText__c = 'Nokia Response ' + i;
			surveyQuestionResponseList.add(surveyQuestionResponse);
		}
		return surveyQuestionResponseList;
	}

	//Deal Creation: Requirement: 924
	public static list<Deal__c> createDeal(integer size) {
		list<Deal__c> dealList = new list<Deal__c>();
		for (integer i = 0; i < size; i++) {
			Deal__c dealObject = new Deal__c();
			dealObject.name = 'Test Deal-' + i;
			dealList.add(dealObject);
		}
		return dealList;
	}

	public static list<ContentVersion> createContentVersion(integer size) {
		list<ContentVersion> contentVersionList = new list<ContentVersion>();
		for (integer i = 0; i < size; i++) {
			ContentVersion contentVersion = new ContentVersion();
			contentVersion.Title = 'Test ContentVersion File - ' + i;
			contentVersion.PathOnClient = contentVersion.Title;
			Blob bodyBlob = EncodingUtil.base64Decode('TestFileData' + i);
			contentVersion.VersionData = bodyBlob;
			contentVersion.IsMajorVersion = false;
			contentVersion.origin = GlobalConstants.CONTENT_ORIGIN;
			contentVersionList.add(contentVersion);
		}
		return contentVersionList;
	}

	public static list<ContentDocumentLink> createContentDocumentLink(integer size, Id linkedEntityId, Id contentDocumentId) {
		list<ContentDocumentLink> contentDocumentLinkList = new list<ContentDocumentLink>();
		for (integer i = 0; i < size; i++) {
			ContentDocumentLink contentlink = new ContentDocumentLink();
			contentlink.LinkedEntityId = linkedEntityId;
			contentlink.ContentDocumentId = contentDocumentId;
			contentlink.ShareType = GlobalConstants.FILE_SHARE_TYPE_I;
			contentlink.Visibility = GlobalConstants.ALL_USERS;
			contentDocumentLinkList.add(contentlink);
		}
		return contentDocumentLinkList;
	}

	public static CollaborationGroupMember createCollaborationGroupMember(Id groupId, Id userId) {
		CollaborationGroupMember CollaborationGroupMemberObj = new CollaborationGroupMember();
		CollaborationGroupMemberObj.CollaborationGroupId = groupId;
		CollaborationGroupMemberObj.MemberId = userId;
		return CollaborationGroupMemberObj;
	}

	public static list<ContentDocumentLink> createContentDocumentLinkWithShareTypeV(integer size, Id linkedEntityId, Id contentDocumentId) {
		list<ContentDocumentLink> contentDocumentLinkList = new list<ContentDocumentLink>();
		for (integer i = 0; i < size; i++) {
			ContentDocumentLink contentlink = new ContentDocumentLink();
			contentlink.LinkedEntityId = linkedEntityId;
			contentlink.ContentDocumentId = contentDocumentId;
			contentlink.ShareType = GlobalConstants.FILE_SHARE_TYPE_V;
			contentlink.Visibility = GlobalConstants.ALL_USERS;
			contentDocumentLinkList.add(contentlink);
		}
		return contentDocumentLinkList;
	}

	public static List<product2> productCreation(Integer size) {
		List<product2> productList = new List<product2>();
		for (integer i = 0; i < size; i++) {
			product2 prod = new product2();
			prod.name = '5G';
			prod.CurrencyIsoCode = 'USD';
			prod.Business_Group__c = 'CNS';
			prod.Family = 'NSW SER';
			prod.IsActive = True;
			prod.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Business_Line').getRecordTypeId();
			productList.add(prod);

		}
		return productList;
	}

	public static List<OpportunityTeamMember> optyTeamMemberCreation(integer size, User user, Opportunity opty) {
		List<OpportunityTeamMember> optyTeamList = new List<OpportunityTeamMember>();
		for (integer i = 0; i < size; i++) {
			OpportunityTeamMember optyTeamMember = new OpportunityTeamMember();
			optyTeamMember.TeamMemberRole = TestDataFactory.BID_MANAGER;
			optyTeamMember.UserId = user.id;
			optyTeamMember.OpportunityId = opty.id;
			optyTeamMember.OpportunityAccessLevel = 'Edit';
			optyTeamList.add(optyTeamMember);
		}
		return optyTeamList;
	}

	public static Apttus_Proposal__Proposal_Line_Item__c proposalLineItemCreation(Id QuoteId) {
		Apttus_Proposal__Proposal_Line_Item__c proposalLineItem = new Apttus_Proposal__Proposal_Line_Item__c();
		proposalLineItem.Apttus_QPConfig__ItemSequence__c = 2;
		proposalLineItem.Apttus_QPConfig__LineNumber__c = 4;
		proposalLineItem.Apttus_Proposal__Proposal__c = QuoteId;
		return proposalLineItem;
	}

	public static List<Opportunity> OpportunityCreation(integer size, Account acc) {
		list<Opportunity> optyList = new list<Opportunity>();

		for (integer i = 0; i < size; i++) {
			Opportunity opty = new Opportunity();
			opty.Name = 'Test Opportunity';
			opty.CloseDate = system.today();
			opty.StageName = 'Identify Opportunity';
			opty.AccountId = acc.id;
			opty.End_Customer__c = acc.id;
			opty.Contract_Signing_Entity__c = 'fALU';
			opty.Phase_Status__c = 'Planned';
			opty.Apttus_Approval__Approval_Status__c = 'Approved';
			opty.CurrencyIsoCode = 'USD';
			opty.Business_Type__c = 'Standard Opportunity';
			opty.Amount = 300;
			opty.Sales_Outcome_Reason__c = 'Commercial';
			opty.Unweighted_Amount_EUR__c = 0;
			opty.Lead_BG__c = 'MN';
			opty.Lead_BU__c = 'MN';
			opty.G2_Planned_Date__c = system.today();
			opty.G3_Planned_Date__c = system.today() + 1;
			opty.G4_Planned_Date__c = system.today() + 2;
			opty.G5_Planned_Date__c = system.today() + 3;
			optyList.add(opty);
		}
		return optyList;
	}

	public static List<Task> TaskCreation(integer size) {
		List<Task> taskList = new list<Task>();
		for (integer i = 0; i < size; i++) {
			Task taskRec = new Task();
			taskRec.Status = 'Open';
			taskList.add(taskRec);
		}
		return taskList;
	}

	//Questionnaire Creation
	public static list<Questionnaire__c> createQuestionnaire(integer size, Opportunity oppty) {
		List<Questionnaire__c> QuestionnaireList = new List<Questionnaire__c>();
		for (integer i = 0; i < size; i++) {
			Questionnaire__c ques = new Questionnaire__c();
			ques.Opportunity__c = oppty.id;
			QuestionnaireList.add(ques);
		}
		return QuestionnaireList;
	}

	//Quote/Proposal Creation
	public static List<Apttus_Proposal__Proposal__c> createProposal(Integer size) {
		List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
		for (integer i = 0; i < size; i++) {
			Apttus_Proposal__Proposal__c proposalObj = new Apttus_Proposal__Proposal__c();
			proposalObj.NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
			proposalObj.NokiaCPQ_ION_Maintenance_Type__c = 'Gold';
			proposalObj.NokiaCPQ_Existing_FN_Maint_Contract__c = 'No';
			proposalObj.NokiaCPQ_FN_Maintenance_Type__c = 'Gold';
			proposalObj.NokiaCPQ_SSP_Level__c = 'Biennial';
			proposalObj.NokiaCPQ_SRS_Level__c = 'Biennial';
			proposalObj.CurrencyIsoCode = 'EUR';

			proposalObj.Proposal_Recommendation_Type__c = 'SW Recommendation';
			proposalObj.Apttus_Proposal__Approval_Stage__c = 'Accepted';
			proposalObj.Creation_Date__c = system.today();
			proposalObj.Apttus_Proposal__Proposal_Name__c = 'Test Quote';
			proposalObj.Analytics_Source__c = CSWXGlobalConstant.AnalyticsSource_CCRE;
			proposalList.add(proposalObj);
		}
		return proposalList;
	}

	//Cart Creation
	public static Apttus_Config2__ProductConfiguration__c createProductConfiguration(Apttus_Proposal__Proposal__c proposal) {
		Apttus_Config2__ProductConfiguration__c cart = new Apttus_Config2__ProductConfiguration__c(Apttus_QPConfig__Proposald__c = proposal.Id);
		cart.Apttus_Config2__BusinessObjectRefId__c = proposal.Id;
		cart.Apttus_Config2__PriceListId__c = proposal.Apttus_QPConfig__PriceListId__c;
		cart.Apttus_Config2__AccountId__c = proposal.Apttus_Proposal__Account__c;
		cart.OwnerID = userinfo.getuserid();
		cart.Apttus_Config2__EffectivePriceListId__c = proposal.Apttus_QPConfig__PriceListId__c;
		cart.Apttus_Config2__VersionNumber__c = 1;
		cart.Apttus_Config2__Status__c = CSWXGlobalConstant.cartStatus;
		cart.name = CSWXGlobalConstant.cartName + proposal.Apttus_Proposal__Proposal_Name__c;
		cart.createdById = userinfo.getuserid();
		return cart;
	}

	//CCRE Line Items Creation
	public static List<CCRE_UpSell_LineItem__c> createCCRELineItems(Set < Id> lstUpsellId, Integer size) {
		List<CCRE_UpSell_LineItem__c> lstCCRELineItems = new List<CCRE_UpSell_LineItem__c>();
		for (Id upsellId: lstUpsellId) {
			for (integer i = 0; i < size; i++) {
	CCRE_UpSell_LineItem__c CCRELineItem = new CCRE_UpSell_LineItem__c();
	CCRELineItem.Upsell_Proposal__c = upsellId;
	CCRELineItem.Line_Item_Type__c = 'sales_line_items';
	CCRELineItem.Service_PCI__c = '151421';
	CCRELineItem.Sales_Item_Code__c = '151421';
	CCRELineItem.Optiongroup__c = 'OptionGroup01';
	lstCCRELineItems.add(CCRELineItem);
			}
		}
		return lstCCRELineItems;
	}

	//SWX Line Items Creation
	public static List<SWx_Upsell_Items__c> createSWXLineItems(Set < Id> lstUpsellId, Integer size) {
		List<SWx_Upsell_Items__c> lstSWXLineItems = new List<SWx_Upsell_Items__c>();
		for (Id upsellId: lstUpsellId) {
			for (integer i = 0; i < size; i++) {
	SWx_Upsell_Items__c SWXLineItem = new SWx_Upsell_Items__c();
	SWXLineItem.SWx_Upsell_Proposal__c = upsellId;
	SWXLineItem.Quantity__c = 5;
	SWXLineItem.Feature_ID__c = '151421';
	SWXLineItem.Sales_Item_Code_SWx__c = '151421';
	lstSWXLineItems.add(SWXLineItem);
			}
		}
		return lstSWXLineItems;
	}

	//Product Option Component Creation
	public static List<Apttus_Config2__ProductOptionComponent__c> CreateproductOptionComponent(Id id1, integer size) {
		List<Apttus_Config2__ProductOptionComponent__c> optionComponentList = new list<Apttus_Config2__ProductOptionComponent__c>();
		for (integer i = 0; i < size; i++) {
			Apttus_Config2__ProductOptionComponent__c optionComponentObj = new Apttus_Config2__ProductOptionComponent__c();
			optionComponentObj.Apttus_Config2__ComponentProductId__c = id1;
			optionComponentList.add(optionComponentObj);
		}

		return optionComponentList;
	}

	public static List<Offer__c> OfferCreation(integer size, Opportunity opp) {
		List<Offer__c> offerList = new List<Offer__c>();
		for (integer i = 0; i < size; i++) {
			Offer__c offer = new Offer__c();
			offer.Name = 'Test Offer';
			offer.Opportunity__c = opp.id;
			DateTime dT = System.now();
			Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
			offer.Customer_Offer_Due_Date__c = myDate;
			offerList.add(offer);
		}
		return offerList;
	}

	public static List<Offer_Team__c> offerTeamCreation(Integer size, Offer__c offr, User user) {
		List<Offer_Team__c> offerTeamList = new List<Offer_Team__c>();
		for (integer i = 0; i < size; i++) {
			Offer_Team__c offerTeam = new Offer_Team__c();
			offerTeam.Offer__c = offr.id;
			offerTeam.Offer_Access__c = 'Read/Write';
			offerTeam.Team_Member_Role__c = TestDataFactory.BID_MANAGER;
			offerTeam.Name__c = user.id;
			offerTeamList.add(offerTeam);
		}
		return offerTeamList;

	}

	public static List<Offer_Team__c> offerTeamCreationWithReadOnly(Integer size, Offer__c offr, User user) {
		List<Offer_Team__c> offerTeamList = new List<Offer_Team__c>();
		for (integer i = 0; i < size; i++) {
			Offer_Team__c offerTeam = new Offer_Team__c();
			offerTeam.Offer__c = offr.id;
			offerTeam.Offer_Access__c = 'Read Only';
			offerTeam.Team_Member_Role__c = TestDataFactory.BID_MANAGER;
			offerTeam.Name__c = user.id;
			offerTeamList.add(offerTeam);
		}
		return offerTeamList;
	}

	public static List<Dated_Exchange_Rates__c> datedExchnageRateCreation(Integer size) {
		List<Dated_Exchange_Rates__c> datedExchnageRateList = new List<Dated_Exchange_Rates__c>();
		for (integer i = 0; i < size; i++) {
			Dated_Exchange_Rates__c newRate = new Dated_Exchange_Rates__c();
			newRate.CurrencyIsoCode = 'USD';
			newRate.Exchange_Rate__c = 1.38;
			newRate.Start_Date__c = system.today();

			datedExchnageRateList.add(newRate);
		}
		return datedExchnageRateList;
	}

	public static List<Nokia_Financial_Calendar__c> nokiaFinCalCreation(Integer size) {
		List<Nokia_Financial_Calendar__c> nokiaFinCalList = new List<Nokia_Financial_Calendar__c>();
		for (integer i = 0; i < size; i++) {
			Nokia_Financial_Calendar__c nokiaFinCal = new Nokia_Financial_Calendar__c();
			nokiaFinCal.Name = 'Test Nokia Calendar';
			nokiaFinCal.Start_Date__c = system.today();
			nokiaFinCal.End_Date__c = system.today();
			nokiaFinCal.CurrencyIsoCode = 'USD';
			nokiaFinCal.Period_Number__c = '1';
			nokiaFinCalList.add(nokiaFinCal);
		}
		return nokiaFinCalList;
	}

	public static List<Order_Intake_Forecast__c> orderIntakeCreation(Integer size, Opportunity oppty, Product2 prod, Nokia_Financial_Calendar__c nokiaFinCal) {
		List<Order_Intake_Forecast__c> orderIntakeList = new List<Order_Intake_Forecast__c>();
		for (integer i = 0; i < size; i++) {
			Order_Intake_Forecast__c orderIntake = new Order_Intake_Forecast__c();

			orderIntake.BusinessLine__c = prod.id;
			orderIntake.Business_Group__c = 'CNS';
			orderIntake.Opportunity__c = oppty.id;
			orderIntake.Software__c = 22;
			orderIntake.OIF_Value__c = 100;
			orderIntake.Forecast_Category__c = 'Risk';
			orderIntake.POPlanReceipt__c = nokiaFinCal.id;
			orderIntake.Close_Date__c = system.today();
			orderIntakeList.add(orderIntake);
		}
		return orderIntakeList;
	}

	public static List<ObjectTerritory2Association> assigningAccountToTerritory(Integer size, Account acc, Id Territory2Id) {
		List<ObjectTerritory2Association> objTerritory2AssociationList = new List<ObjectTerritory2Association>();
		for (integer i = 0; i < size; i++) {
			ObjectTerritory2Association objTerritory2AssociationObj = new ObjectTerritory2Association();
			objTerritory2AssociationObj.AssociationCause = 'Territory2Manual';
			objTerritory2AssociationObj.Territory2Id = Territory2Id;
			objTerritory2AssociationObj.ObjectId = acc.Id;
			objTerritory2AssociationList.add(objTerritory2AssociationObj);
		}
		return objTerritory2AssociationList;
	}

	public static Id getTerritoryId() {
		List<Territory2Model> terrModelList1 = [SELECT Id, State FROM Territory2Model where State = 'Active'
			LIMIT 1
		];
		List<Territory2> territoryIdList1 = [SELECT Id, Territory2ModelId FROM Territory2 where Territory2ModelId =: terrModelList1[0].id];
		Id territoryId = territoryIdList1[0].Id;
		return territoryId;
	}

	public static Id getAnotherL7TerritoryId() {
		Id territoryId;
		if (TestDataFactory.territoryIdList.isEmpty()) {
			TestDataFactory.territoryIdList = [SELECT Id FROM Territory2 where Hierarchy_Level__c = 'L7'
	and territory2Model.state =: GlobalConstants.TERRITORY2MODEL_STATE_ACTIVE LIMIT 1
			];
		}
		territoryId = TestDataFactory.territoryIdList[0].Id;
		return territoryId;
	}

	public static Id getAnotherL7TerritoryId(Id terryId) {
		Id territoryId;
		if (TestDataFactory.territoryIdList.isEmpty()) {
			TestDataFactory.territoryIdList = [SELECT Id FROM Territory2 where Hierarchy_Level__c = 'L7'
	and Id !=: terryId
	and territory2Model.state =: GlobalConstants.TERRITORY2MODEL_STATE_ACTIVE LIMIT 1
			];
		}
		territoryId = TestDataFactory.territoryIdList[0].Id;
		return territoryId;
	}

	public static Id getL7TerritoryId() {
		Id territoryId;

		if (TestDataFactory.territoryIdListAnother.isEmpty()) {
			TestDataFactory.territoryIdListAnother = [SELECT Id FROM Territory2 where Hierarchy_Level__c = 'L7'
	and territory2Model.state =: GlobalConstants.TERRITORY2MODEL_STATE_ACTIVE LIMIT 2
			];
		}
		territoryId = TestDataFactory.territoryIdListAnother[1].Id;
		return territoryId;
	}

	public static Id getL3TerritoryId() {
		Id territoryId;

		if (TestDataFactory.territoryIdListAnother.isEmpty()) {
			TestDataFactory.territoryIdListAnother = [SELECT Id FROM Territory2 where Hierarchy_Level__c = 'L3'
	and territory2Model.state =: GlobalConstants.TERRITORY2MODEL_STATE_ACTIVE and(not(DeveloperName like '%_NSA'))
			];
		}
		territoryId = TestDataFactory.territoryIdListAnother[0].Id;
		return territoryId;
	}

	public static List<UserTerritory2Association> assigningUserToTerritory(Integer size, User user, Id TerritoryId) {
		List<UserTerritory2Association> userAssignedToTerritoryList = new List<UserTerritory2Association>();
		for (integer i = 0; i < size; i++) {
			UserTerritory2Association userTerritory2AssociationObj = new UserTerritory2Association();
			userTerritory2AssociationObj.Territory2Id = TerritoryId;
			userTerritory2AssociationObj.UserId = user.Id;
			userAssignedToTerritoryList.add(userTerritory2AssociationObj);
		}
		return userAssignedToTerritoryList;
	}

	public static list<Lead> createLead(integer size) {
		list<Lead> leadList = new list<Lead>();
		for (integer i = 0; i < size; i++) {
			Lead lead = new Lead(LastName = 'Doe', FirstName = 'John', Company = 'Test', Status = 'Inquiry');
			lead.Job_Function__c = 'Sales & Marketing Management';
			lead.Budget__c = '0 - 99K';
			lead.Industry = 'Enterprise';
			lead.Purchasing_Role__c = 'Contact';
			lead.rating = 'A';
			lead.Business_Type__c = 'Consultant';
			lead.Email = 'john.doe@accenture.com';
			leadList.add(lead);
		}
		return leadList;
	}

	public static List<ContentVersion> getContentVersions(List<Id> Ids) {
		return [SELECT Id, ContentDocumentId, Title FROM ContentVersion where Id In: Ids];
	}

	/**********************************************************************************************************************
	 * author: Accenture
	 * Date: Jan-2017
	 * Param: NA
	 * Return: NA
	 * Description: Create records File_Sharing_Custom_Setting__c custom setting
	 * High Level Process :
	 ********************************************************************************************************************* */
	public static list<File_Sharing_Custom_Setting__c> create_File_Sharing_Custom_Setting() {
		list<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new list<File_Sharing_Custom_Setting__c>();

		File_Sharing_Custom_Setting__c fileSharingCustomSetting1 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting1.Name = 'ReschedulingTime';
		fileSharingCustomSetting1.Value__c = '900';
		fileSharingCustomSettingList.add(fileSharingCustomSetting1);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting2 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting2.Name = 'UserTerritoryAdditionScheduler';
		fileSharingCustomSetting2.Value__c = 'UserTerritoryAdditionScheduler';
		fileSharingCustomSettingList.add(fileSharingCustomSetting2);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting3 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting3.Name = 'ScheduleShareFileAfterConDocLink';
		fileSharingCustomSetting3.Value__c = 'ContentDocumentLinkBatch';
		fileSharingCustomSettingList.add(fileSharingCustomSetting3);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting4 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting4.Name = 'Batch_UserRestrictionLevelUpdateSize';
		fileSharingCustomSetting4.Description__c = 'Defines the batch size for UserRestrictionLevelUpdateBatch';
		fileSharingCustomSetting4.Value__c = '5';
		fileSharingCustomSettingList.add(fileSharingCustomSetting4);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting5 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting5.Name = 'Scheduler_UserRestrictionLevelUpdate';
		fileSharingCustomSetting5.Description__c = 'Specifies the name of the scheduler for UserRestrictionLevelUpdateBatch';
		fileSharingCustomSetting5.Value__c = 'Scheduler_UserRestrictionLevelUpdate';
		fileSharingCustomSettingList.add(fileSharingCustomSetting5);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting6 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting6.Name = 'TerritoriesForSharing';
		fileSharingCustomSetting6.Description__c = 'List all the territories (Hierarchy_Level__c) levels in comma seperation';
		fileSharingCustomSetting6.Value__c = 'L7,L6,L5,L4';
		fileSharingCustomSettingList.add(fileSharingCustomSetting6);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting7 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting7.Name = 'SchedulingTime';
		fileSharingCustomSetting7.Description__c = 'This is used for scheduling the batch';
		fileSharingCustomSetting7.Value__c = '2';
		fileSharingCustomSettingList.add(fileSharingCustomSetting7);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting8 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting8.Name = GlobalConstants.ALLOWED_TOTAL_FILE_SHARE_LIMIT;
		fileSharingCustomSetting8.Value__c = '5';
		fileSharingCustomSettingList.add(fileSharingCustomSetting8);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting9 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting9.Name = GlobalConstants.USERTERRITORYADDITIONBATCHSIZE;
		fileSharingCustomSetting9.Value__c = '5';
		fileSharingCustomSettingList.add(fileSharingCustomSetting9);

		File_Sharing_Custom_Setting__c setting10 = new File_Sharing_Custom_Setting__c();
		setting10.Name = GlobalConstants.CONTENTDOCUMENTLINKBATCHSIZE;
		setting10.Value__c = '10';
		fileSharingCustomSettingList.add(setting10);

		File_Sharing_Custom_Setting__c setting12 = new File_Sharing_Custom_Setting__c();
		setting12.Name = GlobalConstants.OPPORTUNITYTEAMBATCHSIZE;
		setting12.Value__c = '10';
		fileSharingCustomSettingList.add(setting12);

		File_Sharing_Custom_Setting__c setting13 = new File_Sharing_Custom_Setting__c();
		setting13.Name = GlobalConstants.OFFERTEAMBATCHSIZE;
		setting13.Value__c = '10';
		fileSharingCustomSettingList.add(setting13);

		File_Sharing_Custom_Setting__c setting14 = new File_Sharing_Custom_Setting__c();
		setting14.Name = GlobalConstants.SCHEDULEROPPTYTEAMFILESHAREBATCH;
		setting14.Value__c = 'SchedulerOpptyTeamFileShareBatch';
		fileSharingCustomSettingList.add(setting14);

		File_Sharing_Custom_Setting__c setting15 = new File_Sharing_Custom_Setting__c();
		setting15.Name = GlobalConstants.SCHEDULEROPPTYTEAMFILEDELETEBATCH;
		setting15.Value__c = 'Scheduler_UserRestrictionLevelUpdate';
		fileSharingCustomSettingList.add(setting15);

		File_Sharing_Custom_Setting__c setting16 = new File_Sharing_Custom_Setting__c();
		setting16.Name = GlobalConstants.CHATTER_FILE_UPLOAD_ERROR_MESSAGE_CUST_SETTING;
		setting16.Description__c = 'Display error during file upload from chatter post';
		setting16.Value__c = 'Nokia Compliance Restriction: You are not allowed to upload file in chatter post.';
		fileSharingCustomSettingList.add(setting16);

		File_Sharing_Custom_Setting__c setting17 = new File_Sharing_Custom_Setting__c();
		setting17.Name = GlobalConstants.ALLOWED_PROFILES_FOR_CHATTER_FILES;
		setting17.Description__c = 'List out the profile Names in Comma Separation without any extra space after comma';
		setting17.Value__c = 'System Administrator';
		fileSharingCustomSettingList.add(setting17);

		File_Sharing_Custom_Setting__c setting18 = new File_Sharing_Custom_Setting__c();
		setting18.Name = GlobalConstants.CHATTER_FILE_INLINE_BODY_CUST_SETTING;
		setting18.Description__c = 'Image file body continent in Chatter post';
		setting18.Value__c = '<img src="sfdc://';
		fileSharingCustomSettingList.add(setting18);

		File_Sharing_Custom_Setting__c setting19 = new File_Sharing_Custom_Setting__c();
		setting19.Name = GlobalConstants.SCHEDULEINSERTDATAINTOSERVICEOBJECT;
		setting19.Description__c = '';
		setting19.Value__c = 'InsertDataIntoServiceObjectBatch';
		fileSharingCustomSettingList.add(setting19);

		File_Sharing_Custom_Setting__c setting20 = new File_Sharing_Custom_Setting__c();
		setting20.Name = GlobalConstants.INSERTDATAINTOSERVICEOBJECTBATCHSIZE;
		setting20.Description__c = '';
		setting20.Value__c = '10';
		fileSharingCustomSettingList.add(setting20);

		File_Sharing_Custom_Setting__c setting21 = new File_Sharing_Custom_Setting__c();
		setting21.Name = GlobalConstants.INTERNALUSERID;
		setting21.Description__c = 'Internal user id contain the user Id of the user who is the default owner of files uploaded by nokia sales profile user';
		setting21.Value__c = '0056E000000NhaoQAC';
		fileSharingCustomSettingList.add(setting21);

		File_Sharing_Custom_Setting__c setting22 = new File_Sharing_Custom_Setting__c();
		setting22.Name = GlobalConstants.TERRITORIES_FOR_NSA_COMPLIANCE;
		setting22.Description__c = 'This defines territories levels for which, their users needs to be added/removed from NSA Compliance groups.';
		setting22.Value__c = 'L1, L2, L3';
		fileSharingCustomSettingList.add(setting22);

		File_Sharing_Custom_Setting__c setting23 = new File_Sharing_Custom_Setting__c();
		setting23.Name = GlobalConstants.NSA_ADMIN_PROFILES_ID;
		setting23.Description__c = '  18 digit salesforce Id of NSA Admin Profiles, users belonging to these Admin Profiles would be added in NSA Admin groups';
		setting23.Value__c = '00e6E000000QHJAQA4, 00e6E000000QHcpQAG';
		fileSharingCustomSettingList.add(setting23);

		File_Sharing_Custom_Setting__c setting24 = new File_Sharing_Custom_Setting__c();
		setting24.Name = GlobalConstants.ACCOUNT_MOVEMENT_BATCH_SIZE;
		setting24.Description__c = '';
		setting24.Value__c = '5';
		fileSharingCustomSettingList.add(setting24);

		File_Sharing_Custom_Setting__c setting25 = new File_Sharing_Custom_Setting__c();
		setting25.Name = GlobalConstants.USERTERRITORYREMOVALBATCHSIZE;
		setting25.Description__c = 'Defines the batch size for UserTerritoryRemovalBatch';
		setting25.Value__c = '2';
		fileSharingCustomSettingList.add(setting25);

		File_Sharing_Custom_Setting__c setting26 = new File_Sharing_Custom_Setting__c();
		setting26.Name = GlobalConstants.ALLOWED_SIZE_FOR_CONTENTDOCIDS_LIMIT;
		setting26.Description__c = 'Max allowed size 131072 - 30';
		setting26.Value__c = '131042';
		fileSharingCustomSettingList.add(setting26);

		File_Sharing_Custom_Setting__c setting27 = new File_Sharing_Custom_Setting__c();
		setting27.Name = GlobalConstants.SHAREFILESONUPLOADBATCHSIZE;
		setting27.Description__c = 'Files To be shared in one batch';
		setting27.Value__c = '200';
		fileSharingCustomSettingList.add(setting27);

		File_Sharing_Custom_Setting__c setting36 = new File_Sharing_Custom_Setting__c();
		setting36.Name = 'Scheduler_AccountTerritoryRemoval';
		setting36.Description__c = 'Scheduler name for AccountTerritoryRemoval Batch';
		setting36.Value__c = 'Scheduler_AccountTerritoryRemoval';
		fileSharingCustomSettingList.add(setting36);

		File_Sharing_Custom_Setting__c setting37 = new File_Sharing_Custom_Setting__c();
		setting37.Name = 'Batch_AccountTerritoryRemovalSize';
		setting37.Description__c = 'Defines the batch size for AccountTerritoryRemoval batch';
		setting37.Value__c = '200';
		fileSharingCustomSettingList.add(setting37);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting38 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting38.Name = 'UserTerritoryRemovalScheduler';
		fileSharingCustomSetting38.Value__c = 'UserTerritoryRemovalScheduler';
		fileSharingCustomSettingList.add(fileSharingCustomSetting38);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting39 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting39.Name = 'Scheduler_UnshareFileTerritoryUser';
		fileSharingCustomSetting39.Value__c = 'Scheduler_UnshareFileTerritoryUser';
		fileSharingCustomSettingList.add(fileSharingCustomSetting39);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting40 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting40.Name = 'BatchSize_UnshareFileTerritoryUser';
		fileSharingCustomSetting40.Value__c = '10';
		fileSharingCustomSettingList.add(fileSharingCustomSetting40);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting41 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting41.Name = 'NonComplaintAccount_Value';
		fileSharingCustomSetting41.Value__c = 'Unassigned';
		fileSharingCustomSettingList.add(fileSharingCustomSetting41);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting42 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting42.Name = 'Opportunity_SalesPhase_FinalStage';
		fileSharingCustomSetting42.Value__c = 'Completed';
		fileSharingCustomSettingList.add(fileSharingCustomSetting42);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting43 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting43.Name = 'OpportunityPhaseStatusValues';
		fileSharingCustomSetting43.Value__c = 'Submitted for G2 Approval, Submitted for G3 Approval, Submitted for G4 Approval, Submitted for G5 Approval, Submitted for G6 Approval, Closed (not won), Closed';
		fileSharingCustomSettingList.add(fileSharingCustomSetting43);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting44 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting44.Name = GlobalConstants.MULTI_DOC_OPERATION_LIMIT;
		fileSharingCustomSetting44.Value__c = '5';
		fileSharingCustomSettingList.add(fileSharingCustomSetting44);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting45 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting45.Name = GlobalConstants.NSACOMPLIANTVALUE;
		fileSharingCustomSetting45.Value__c = 'US_Govern';
		fileSharingCustomSettingList.add(fileSharingCustomSetting45);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting46 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting46.Name = 'OpportunityGateValue';
		fileSharingCustomSetting46.Value__c = 'G2, G3, G4, G5, G6';
		fileSharingCustomSettingList.add(fileSharingCustomSetting46);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting47 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting47.Name = 'LoA_G4_G5_DocumentTypes';
		fileSharingCustomSetting47.Value__c = 'LoA G4 Template (without financials), LoA G5 Template (without financials)';
		fileSharingCustomSettingList.add(fileSharingCustomSetting47);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting48 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting48.Name = 'UpsellOIF_RevRecException';
		fileSharingCustomSetting48.Value__c = TestDataFactory.MARKET_NORTH_AMERICA;
		fileSharingCustomSettingList.add(fileSharingCustomSetting48);

		Profile proRec = [select id from profile where name = 'System Administrator'];
		File_Sharing_Custom_Setting__c fileSharingCustomSetting49 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting49.Name = GlobalConstants.SYSTEM_ADMIN_PROFILEID;
		fileSharingCustomSetting49.Value__c = proRec.id;
		fileSharingCustomSettingList.add(fileSharingCustomSetting49);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting50 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting50.Name = 'LightningCmpRestrictedProfileId';
		fileSharingCustomSetting50.Value__c = '21321,123321';
		fileSharingCustomSettingList.add(fileSharingCustomSetting50);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting51 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting51.Name = 'Undeletable_Doc_RestrictionLevel';
		fileSharingCustomSetting51.Value__c = 'Confidential';
		fileSharingCustomSettingList.add(fileSharingCustomSetting51);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting52 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting52.Name = 'Undeletable_Doc_Profile';
		fileSharingCustomSetting52.Value__c = 'System Administrator';
		fileSharingCustomSettingList.add(fileSharingCustomSetting52);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting53 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting53.Name = 'Undeletable_Doc_Type';
		fileSharingCustomSetting53.Value__c = 'LoA G4 Template, LoA G5 Template';
		fileSharingCustomSettingList.add(fileSharingCustomSetting53);

		File_Sharing_Custom_Setting__c fileSharingCustomSetting54 = new File_Sharing_Custom_Setting__c();
		fileSharingCustomSetting54.Name = 'ApprovalCompletionDays';
		fileSharingCustomSetting54.Value__c = '1';
		fileSharingCustomSettingList.add(fileSharingCustomSetting54);

		
		//Creating groups related custom settings
		createCollaborationGroupsAndCustomSettings();
		return fileSharingCustomSettingList;
	}

	public static list<cloneObject__c> cloneObjectCustom_Setting() {
		list<cloneObject__c> cloneObjectCustomSettingList = new list<cloneObject__c>();

		cloneObject__c cloneObjectCustomSetting = new cloneObject__c();
		cloneObjectCustomSetting.Name = 'Customer Offer Due Date';
		cloneObjectCustomSetting.Field_API__c = 'Customer_Offer_Due_Date__c';
		cloneObjectCustomSetting.Object__c = 'Offer';
		cloneObjectCustomSettingList.add(cloneObjectCustomSetting);

		cloneObject__c cloneObjectCustomSetting1 = new cloneObject__c();
		cloneObjectCustomSetting1.Name = 'Owner';
		cloneObjectCustomSetting1.Field_API__c = 'CreatedById';
		cloneObjectCustomSetting1.Object__c = 'Offer';
		cloneObjectCustomSettingList.add(cloneObjectCustomSetting1);

		cloneObject__c cloneObjectCustomSetting2 = new cloneObject__c();
		cloneObjectCustomSetting2.Name = 'Offer Name';
		cloneObjectCustomSetting2.Field_API__c = 'Name';
		cloneObjectCustomSetting2.Object__c = 'Offer';
		cloneObjectCustomSettingList.add(cloneObjectCustomSetting2);

		cloneObject__c cloneObjectCustomSetting3 = new cloneObject__c();
		cloneObjectCustomSetting3.Name = 'Opportunity';
		cloneObjectCustomSetting3.Field_API__c = 'Opportunity__c';
		cloneObjectCustomSetting3.Object__c = 'Offer';
		cloneObjectCustomSettingList.add(cloneObjectCustomSetting3);

		cloneObject__c cloneObjectCustomSetting5 = new cloneObject__c();
		cloneObjectCustomSetting5.Name = 'No Offer Support Condition';
		cloneObjectCustomSetting5.Object__c = 'Offer';
		cloneObjectCustomSettingList.add(cloneObjectCustomSetting5);

		return cloneObjectCustomSettingList;
	}

	public static list<Campaign> createCampaign(integer size, Opportunity opp) {
		list<Campaign> campList = new list<Campaign>();
		for (integer i = 0; i < size; i++) {
			Campaign camp = new Campaign();
			camp.Name = 'Test Campaign-' + i;
			camp.CurrencyIsoCode = 'EUR';
			camp.Campaign_id__c = 'T9901658' + i;
			camp.Marketing_Campaign_Opportunity__c = opp.id;
			campList.add(camp);
		}
		return campList;
	}

	public static void createCollaborationGroupsAndCustomSettings() {
		List<CollaborationGroup> collGroupList = new List<CollaborationGroup>();
		List<File_Sharing_Custom_Setting__c> sharingList = new List<File_Sharing_Custom_Setting__c>();
		
		CollaborationGroup CollaborationGroupObject1 = new CollaborationGroup();
		CollaborationGroupObject1 = createCollaborationGroup('Unlisted', 'NSACompliantAdmin');
		collGroupList.add(CollaborationGroupObject1);

		CollaborationGroup CollaborationGroupObject2 = new CollaborationGroup();
		CollaborationGroupObject2 = createCollaborationGroup('Unlisted', 'NSACompliant-Confidential');
		collGroupList.add(CollaborationGroupObject2);
		
		CollaborationGroup CollaborationGroupObject3 = new CollaborationGroup();
		CollaborationGroupObject3 = createCollaborationGroup('Unlisted', 'NSACompliant-Restricted');
		collGroupList.add(CollaborationGroupObject3);
		
		CollaborationGroup CollaborationGroupObject4 = new CollaborationGroup();
		CollaborationGroupObject4 = createCollaborationGroup('Unlisted', 'NSACompliant-Unrestricted');
		collGroupList.add(CollaborationGroupObject4);
		
		CollaborationGroup CollaborationGroupObject5 = new CollaborationGroup();
		CollaborationGroupObject5 = createCollaborationGroup('Unlisted', 'NSANonCompliantAdmin');
		collGroupList.add(CollaborationGroupObject5);
		
		CollaborationGroup CollaborationGroupObject6 = new CollaborationGroup();
		CollaborationGroupObject6 = createCollaborationGroup('Unlisted', 'NSANonCompliant-Confidential');
		collGroupList.add(CollaborationGroupObject6);
		
		CollaborationGroup CollaborationGroupObject7 = new CollaborationGroup();
		CollaborationGroupObject7 = createCollaborationGroup('Unlisted', 'NSANonCompliant-Restricted');
		collGroupList.add(CollaborationGroupObject7);
		
		CollaborationGroup CollaborationGroupObject8 = new CollaborationGroup();
		CollaborationGroupObject8 = createCollaborationGroup('Unlisted', 'NSANonCompliant-Unrestricted');
		collGroupList.add(CollaborationGroupObject8);
		insert collGroupList;
		
		File_Sharing_Custom_Setting__c fileSharingCustomSettingList1 = createCollaborationGroupCustomSetting('NSACompliantAdmin', CollaborationGroupObject1.Id);
		sharingList.add(fileSharingCustomSettingList1);
		
		File_Sharing_Custom_Setting__c fileSharingCustomSettingList2 = createCollaborationGroupCustomSetting('NSACompliant-Confidential', CollaborationGroupObject2.Id);
		sharingList.add(fileSharingCustomSettingList2);
		
		File_Sharing_Custom_Setting__c fileSharingCustomSettingList3 = createCollaborationGroupCustomSetting('NSACompliant-Restricted', CollaborationGroupObject3.Id);
		sharingList.add(fileSharingCustomSettingList3);
		
		File_Sharing_Custom_Setting__c fileSharingCustomSettingList4 = createCollaborationGroupCustomSetting('NSACompliant-Unrestricted', CollaborationGroupObject4.Id);
		sharingList.add(fileSharingCustomSettingList4);

		File_Sharing_Custom_Setting__c fileSharingCustomSettingList5 = createCollaborationGroupCustomSetting('NSANonCompliantAdmin', CollaborationGroupObject5.Id);
		sharingList.add(fileSharingCustomSettingList5);

		File_Sharing_Custom_Setting__c fileSharingCustomSettingList6 = createCollaborationGroupCustomSetting('NSANonCompliant-Confidential', CollaborationGroupObject6.Id);
		sharingList.add(fileSharingCustomSettingList6);

		File_Sharing_Custom_Setting__c fileSharingCustomSettingList7 = createCollaborationGroupCustomSetting('NSANonCompliant-Restricted', CollaborationGroupObject7.Id);
		sharingList.add(fileSharingCustomSettingList7);

		File_Sharing_Custom_Setting__c fileSharingCustomSettingList8 = createCollaborationGroupCustomSetting('NSANonCompliant-Unrestricted', CollaborationGroupObject8.Id);
		sharingList.add(fileSharingCustomSettingList8);
		insert sharingList;
	}

	public static CollaborationGroup createCollaborationGroup(String type, String name) {
		CollaborationGroup CollaborationGroupObject = new CollaborationGroup();
		CollaborationGroupObject.CollaborationType = type;
		CollaborationGroupObject.Name = name;
		return CollaborationGroupObject;
	}

	public static FeedItem createFeedItem() {
		FeedItem FI = new FeedItem();
		FI.Body = 'Test Body';
		return FI;
	}

	public static File_Sharing_Custom_Setting__c createCollaborationGroupCustomSetting(String name, String value) {
		File_Sharing_Custom_Setting__c theSetting = new File_Sharing_Custom_Setting__c();
		theSetting.Name = name;
		theSetting.Description__c = 'Blah..blah';
		theSetting.Value__c = value;

		return theSetting;
	}

	/**********************************************************************************************************************
	 * author: Accenture
	 * Date: Apr-2017
	 * Param: NA
	 * Return: List<Schema.Document>
	 * Description: Create Document Records.
	 * High Level Process : 
	 ********************************************************************************************************************* */
	public static List<Schema.Document> getDocument() {
		List<Folder> lstFolder = [Select Id From Folder Where Name = 'Public Images'];
		Schema.Document docHeader = new Schema.Document(FolderId = lstFolder[0].Id, Name = GlobalConstants.HEADER);
		Schema.Document docFooter = new Schema.Document(FolderId = lstFolder[0].Id, Name = GlobalConstants.FOOTER);
		documentList.add(docHeader);
		documentList.add(docFooter);
		return documentList;
	}

	/**********************************************************************************************************************
	 * author: Accenture
	 * Date: May-2017
	 * Param: NA
	 * Return: List<Opportunity>
	 * Description: Create PreSales Opty.
	 * High Level Process : Pre-Sales:Sprint 6: Req#2171
	 ********************************************************************************************************************* */
	public static List<Opportunity> preSalesOpportunityCreation(integer size, Account acc, Opportunity opp) {
		list<Opportunity> optyList = new list<Opportunity>();
		for (integer i = 0; i < size; i++) {
			Opportunity opty = new Opportunity();
			opty.Name = 'Test Opportunity';
			opty.CloseDate = system.today();
			opty.StageName = 'Preparation';
			opty.AccountId = acc.id;
			opty.PSR_Reference_Opportunity__c = opp.id;

			optyList.add(opty);
		}
		return optyList;
	}

	//Digital Sales US: 163/164
	public static List<Account_Member__c> accountTeamCustom(integer size, Account acc) {
		list<Account_Member__c> accMemberList = new list<Account_Member__c>();
		for (integer i = 0; i < size; i++) {
			Account_Member__c accMember = new Account_Member__c();
			accMember.Account__c = acc.id;
			accMemberList.add(accMember);
		}
		return accMemberList;
	}

	//Digital Sales
	public static List<CCRE_UpSell_LineItem__c> upsellLineItem(integer size, Id upsell) {
		List<CCRE_UpSell_LineItem__c> upsellLineItemList = new list<CCRE_UpSell_LineItem__c>();
		for (integer i = 0; i < size; i++) {
			CCRE_UpSell_LineItem__c upsellObj = new CCRE_UpSell_LineItem__c();
			upsellObj.Upsell_Proposal__c = upsell;
			upsellLineItemList.add(upsellObj);
		}
		return upsellLineItemList;
	}

	//Digital Sales
	public static List<Apttus_Config2__PriceList__c> priceList(integer size) {
		List<Apttus_Config2__PriceList__c> priceListObjList = new list<Apttus_Config2__PriceList__c>();
		for (integer i = 0; i < size; i++) {
			Apttus_Config2__PriceList__c priceListObj = new Apttus_Config2__PriceList__c();
			priceListObjList.add(priceListObj);
		}
		return priceListObjList;
	}

	//Digital Sales
	public static List<SWx_Upsell_Proposal__c> upsellList(integer size, Account acc) {
		List<SWx_Upsell_Proposal__c> upsellListObjList = new list<SWx_Upsell_Proposal__c>();
		for (integer i = 0; i < size; i++) {
			SWx_Upsell_Proposal__c upsellObj = new SWx_Upsell_Proposal__c();
			upsellListObjList.add(upsellObj);
		}
		return upsellListObjList;
	}

	//Contact Creation
	public static List<Contact> createContact(integer size, Account acc) {
		List<Contact> contactList = new list<Contact>();
		for (integer i = 0; i < size; i++) {
			Contact contactObj = new Contact();
			contactObj.AccountId = acc.id;
			contactList.add(contactObj);
		}
		return contactList;
	}



	//SWX Upsell Item Creation
	public static List<SWx_Upsell_Items__c> createUpsellItem(integer size, SWx_Upsell_Proposal__c upsellProposal) {
		List<SWx_Upsell_Items__c> upsellItemList = new list<SWx_Upsell_Items__c>();
		for (integer i = 0; i < size; i++) {
			SWx_Upsell_Items__c upsellItemObj = new SWx_Upsell_Items__c();
			upsellItemObj.SWx_Upsell_Proposal__c = upsellProposal.id;
			upsellItemList.add(upsellItemObj);
		}
		return upsellItemList;
	}

	//CCRE Line Item Creation
	public static List<CCRE_UpSell_LineItem__c> createCCRELineItem(integer size, SWx_Upsell_Proposal__c upsellProposal) {
		List<CCRE_UpSell_LineItem__c> upsellItemList = new list<CCRE_UpSell_LineItem__c>();
		for (integer i = 0; i < size; i++) {
			CCRE_UpSell_LineItem__c upsellItemObj = new CCRE_UpSell_LineItem__c();
			upsellItemObj.Line_Item_Type__c = 'Product_Info_line_items';
			upsellItemObj.Name = 'Test Item';
			upsellItemObj.CurrencyIsoCode = 'EUR';
			upsellItemObj.Upsell_Proposal__c = upsellProposal.Id;
			upsellItemList.add(upsellItemObj);
		}

		for (integer i = 0; i < size; i++) {
			CCRE_UpSell_LineItem__c upsellItemObj = new CCRE_UpSell_LineItem__c();
			upsellItemObj.Line_Item_Type__c = 'Service_Invoice_Info_line_items';
			upsellItemObj.Name = 'Test Item';
			upsellItemObj.CurrencyIsoCode = 'EUR';
			upsellItemObj.Upsell_Proposal__c = upsellProposal.Id;
			upsellItemList.add(upsellItemObj);
		}
		return upsellItemList;
	}

	//Quote/Proposal Creation
	public static List<Apttus_Proposal__Proposal__c> createOffer(integer size, SWx_Upsell_Proposal__c upsellProposal) {
		List<Apttus_Proposal__Proposal__c> offerList = new list<Apttus_Proposal__Proposal__c>();
		for (integer i = 0; i < size; i++) {
			Apttus_Proposal__Proposal__c proposalObj = new Apttus_Proposal__Proposal__c();
			proposalObj.Apttus_Proposal__Proposal_Name__c = 'Test Offer';
			proposalObj.CurrencyIsoCode = 'EUR';
			proposalObj.Analytics_Source__c = 'CCRE';
			proposalObj.SWx_Upsell_Proposal__c = upsellProposal.Id;
			proposalObj.NokiaCPQ_Existing_IONMaint_Contract__c = 'No';
			proposalObj.NokiaCPQ_ION_Maintenance_Type__c = 'Gold';
			proposalObj.NokiaCPQ_Existing_FN_Maint_Contract__c = 'No';
			proposalObj.NokiaCPQ_FN_Maintenance_Type__c = 'Gold';
			proposalObj.NokiaCPQ_SSP_Level__c = 'Unlimited';
			proposalObj.NokiaCPQ_SRS_Level__c = 'Unlimited';

			offerList.add(proposalObj);
		}
		return offerList;
	}

	//Price List Item Creation
	public static List<Apttus_Config2__PriceListItem__c> createPriceListItem(integer size, Apttus_Config2__PriceList__c priceListObj) {
		List<Apttus_Config2__PriceListItem__c> pricrListItemList = new list<Apttus_Config2__PriceListItem__c>();
		for (integer i = 0; i < size; i++) {
			Apttus_Config2__PriceListItem__c priceListItemObj = new Apttus_Config2__PriceListItem__c();
			priceListItemObj.Apttus_Config2__PriceListId__c = priceListObj.id;
			pricrListItemList.add(priceListItemObj);
		}
		return pricrListItemList;
	}

	//Product Option Component Creation
	public static List<Apttus_Config2__ProductOptionComponent__c> productOptionComponent(integer size) {
		List<Apttus_Config2__ProductOptionComponent__c> optionComponentList = new list<Apttus_Config2__ProductOptionComponent__c>();
		for (integer i = 0; i < size; i++) {
			Apttus_Config2__ProductOptionComponent__c optionComponentObj = new Apttus_Config2__ProductOptionComponent__c();
			optionComponentList.add(optionComponentObj);
		}
		return optionComponentList;
	}

	public static List<Apttus_Config2__ClassificationHierarchy__c> CreateClassificationHierarchy(integer size) {
		List<Apttus_Config2__ClassificationHierarchy__c> ClassificationComponentList = new list<Apttus_Config2__ClassificationHierarchy__c>();
		Apttus_Config2__ClassificationName__c hier = new Apttus_Config2__ClassificationName__c();
		hier.Name = 'TestCategory';
		hier.APTS_Ext_ID__c = '53121';
		hier.Apttus_Config2__Type__c = 'Option Group';
		hier.Apttus_Config2__Active__c = true;
		hier.Apttus_Config2__HierarchyLabel__c = 'TestCategories';
		insert hier;
		for (integer i = 0; i < size; i++) {
			Apttus_Config2__ClassificationHierarchy__c classificationComponentObj = new Apttus_Config2__ClassificationHierarchy__c();
			classificationComponentObj.Apttus_Config2__Label__c = 'Standard';
			classificationComponentObj.Apttus_Config2__HierarchyId__c = hier.id;
			ClassificationComponentList.add(classificationComponentObj);
		}
		return ClassificationComponentList;
	}

	public static User createSystemAdminUser() {
		UserRole userRole_1 = [SELECT Id FROM UserRole where PortalType = 'None'
			LIMIT 1
		];
		Profile pf = [Select Id from profile where Name = 'System Administrator'];
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ', '').replace(':', '').replace('-', '');

		Integer RandomId = Integer.valueOf(Math.rint(Math.random() * 1000000));
		String uniqueName = orgId + dateString + RandomId;

		User uu = new User(firstname = 'Alan',
			lastName = 'McCarthy',
			email = uniqueName + '@test' + orgId + '.org',
			Username = uniqueName + '@test' + orgId + '.org',
			EmailEncodingKey = 'ISO-8859-1',
			Alias = uniqueName.substring(18, 23),
			TimeZoneSidKey = TestDataFactory.AMERICA_LOSANGELES,
			LocaleSidKey = 'en_US',
			LanguageLocaleKey = 'en_US',
			ProfileId = pf.Id,
			UserRoleId = userRole_1.Id,
			CompanyName = 'Accenture',
			FederationIdentifier = RandomId + '0',
			Nokia_ID__c = '1234s5');
		return uu;
	}

	public static list<ContentVersion> createContentVersion_New(integer size, string strDocumentType) {
		list<ContentVersion> contentVersionList = new list<ContentVersion>();
		for (integer i = 0; i < size; i++) {
			ContentVersion contentVersion = new ContentVersion();
			contentVersion.Title = 'Test ContentVersion File - ' + i;
			contentVersion.PathOnClient = contentVersion.Title;
			contentVersion.Document_Type_POC__c = strDocumentType;
			Blob bodyBlob = EncodingUtil.base64Decode('TestFileData' + i);
			contentVersion.VersionData = bodyBlob;
			contentVersion.IsMajorVersion = false;
			contentVersion.origin = GlobalConstants.CONTENT_ORIGIN;
			contentVersionList.add(contentVersion);
		}
		return contentVersionList;
	}


	public static list<ContentDocumentLink> createContentDocumentLink_New(integer size, Id linkedEntityId, Id contentDocumentId) {
		list<ContentDocumentLink> contentDocumentLinkList = new list<ContentDocumentLink>();
		for (integer i = 0; i < size; i++) {
			ContentDocumentLink contentlink = new ContentDocumentLink();
			contentlink.LinkedEntityId = linkedEntityId;
			contentlink.ContentDocumentId = contentDocumentId;
			contentlink.ShareType = GlobalConstants.FILE_SHARE_TYPE_I;
			contentlink.Visibility = GlobalConstants.ALL_USERS;
			contentDocumentLinkList.add(contentlink);
		}
		return contentDocumentLinkList;
	}



	public static Confidential_File__c createConfidentialFile(string strdocumentid, id offerid, id accountid) {
		Confidential_File__c oDoc = new Confidential_File__c();
		oDoc.ContentDocumentId__c = strdocumentid;
		oDoc.Content_Version_Name__c = 'Test Document';
		oDoc.Document_Type__c = 'LoA G4 Template';
		oDoc.Offer__c = offerid;
		oDoc.account__c = accountid;
		return oDoc;
	}

	public static List<Opportunity_Group__c> DealOpptyGroupingCreation(integer size, Opportunity opp, Deal__c deal) {
		list<Opportunity_Group__c> optygroupList = new list<Opportunity_Group__c>();
		for (integer i = 0; i < size; i++) {
			Opportunity_Group__c optyGroup = new Opportunity_Group__c();
			optyGroup.Opportunity__c = opp.id;
			optyGroup.Deal__c = deal.id;
			optyGroup.Opportunity_Relation__c = 'Subordinate';
			optygroupList.add(optyGroup);
		}
		return optygroupList;
	}

	public static List<Competitor__c> CompetitorCreation(integer size, Opportunity opp) {
		list<Competitor__c> compList = new list<Competitor__c>();
		for (integer i = 0; i < size; i++) {
			Competitor__c compObject = new Competitor__c();
			compObject.Opportunity__c = opp.id;
			compList.add(compObject);
		}
		return compList;
	}

	/*
	 * @desc	this method creates ByPassOrgTrigger
	 * @param   nb : a boolean to byPass, sObjectType to ByPass.
	 * @return  custom Setting bypass record.
	 */
	public static ByPassTriggers__c createByPassOrgTrigger(Boolean byPass, String sObjectType) {
		ByPassTriggers__c settings = ByPassTriggers__c.getOrgDefaults();
		settings.put(sObjectType + SUFFIX_FIELD, byPass);
		return settings;
	}

	/*
	 * @desc	this method create Venue__c
	 * @param   nb : an integer representing the number of records to create for each Venue__c
	 * @return  list of Venue__c
	 */
	public static List<Venue__c> createVenues(Integer nb) {
		List<Venue__c> oVenues = new List<Venue__c>();

		for (Integer i = 0; i < nb; i++) {
			oVenues.add(
	new Venue__c(
		Name = 'ROOM NUMBER' + i, //Text 80
		Street_Address_1__c = 'ROOM ON STREET NUMBER' + i, //Text 80
		Postal_Code_Zip__c = '1234' + i, //Text 80
		Country__c = 'PORTUGAL', //Text 80
		Venue_Capacity__c = '' + i, //Text Area 255
		Venue_Details__c = 'TEST CLASS FOR VENUE', //Rich Text Area(32768)
		Venue_Type__c = 'Other', //Picklist
		City__c = 'LISBON' //Text 80
	)
			);
		}
		return oVenues;
	}

	/*
	 * @desc	this method create Event__c
	 * @param   nb : an integer representing the number of records to create for each Event__c
	 * @return  list of Event__c
	 */
	public static List<Event__c> createEvents(Integer nb, String sRecordTypeName, List<Account> oAccounts, List<Venue__c> oVenues) {
		List<Event__c> oEvents = new List<Event__c>();
		Id venueId;
		Id eventRecordType = Utils.MapRecordType('Event__c').get(sRecordTypeName);

		for (Venue__c oVenue: oVenues) {
			venueId = oVenue.Id;
		}

		for (Account oAccount: oAccounts) {
			for (Integer i = 0; i < nb; i++) {
	oEvents.add(
		new Event__c(
			Name = 'EVENT NUMBER' + i, //Text 80
			Account__c = oAccount.Id, //Lookup
			Venue__c = venueId, //Lookup
			Kick_off_call_date__c = System.today().addDays(5), //Date
			Event_Start_Date__c = System.today().addDays(5), //Date
			Event_End_Date__c = System.today().addDays(15), //Date
			De_briefing_call_date__c = System.today().addDays(5), //Date
			RecordTypeId = eventRecordType //Loopup
		)
	);
			}
		}
		ERM_CreateEventAsynchQueue.doChainJob = false;
		return oEvents;
	}



	/*
	 * @desc	this method create Session__c
	 * @param   nb : an integer representing the number of records to create for each Session__c
	 * @return  list of Session__c
	 */
	public static List<Session__c> createSessions(Integer nb, List<Event__c> oEvents, Time startHour, Time endHour) {
		List<Session__c> oSessions = new List<Session__c>();
		for (Event__c oEvent: oEvents) {
			for (Integer i = 0; i < nb; i++) {
	oSessions.add(
		new Session__c(
			Name = 'SESSION NUMBER' + i, //Text 80
			Event__c = oEvent.Id, //Lookup
			Send_Individual_Notification__c = true, //Checkbox
			Session_Notes__c = 'SESSION NOTES', //Long Text Area(32000),
			Start_hour__c = startHour, //time
			End_hour__c = endHour, //time
			Start_time__c = System.today().addDays(5), //Date
			End_time__c = System.today().addDays(5) //Date
		)
	);
			}
		}
		return oSessions;
	}

	/*
	 * @desc	this method create Event_Registration__c
	 * @param   nb : an integer representing the number of records to create for each Event_Registration__c
	 * @return  list of Event_Registration__c
	 */
	public static List<Event_Registration__c> createEventRegistrations(Integer nb, List<Event__c> oEvents, List<User> oUsers, String sRecordTypeName) {
		List<Event_Registration__c> oEventRegistrations = new List<Event_Registration__c>();
		Id eventRegistrationRecordType = Utils.MapRecordType('Event_Registration__c').get(sRecordTypeName);
		Id eventId;

		for (Event__c oEvent: oEvents) {
			eventId = oEvent.Id;
		}

		for (User oUser: oUsers) {
			for (Integer i = 0; i < nb; i++) {
	oEventRegistrations.add(
		new Event_Registration__c(
			Name = 'PARTICIPANT NUMBER' + i, //Text 80
			Event__c = eventId, //Lookup
			User__c = oUser.Id, //Lookup
			Status__c = 'Invited', //Picklist
			Role__c = 'Content', //Picklist
			RecordTypeId = eventRegistrationRecordType //Loopup
		)
	);
			}
		}
		return oEventRegistrations;
	}

	/*
	 * @desc	this method create ERM_Stakeholder__c
	 * @param   nb : an integer representing the number of records to create for each ERM_Stakeholder__c
	 * @return  list of ERM_Stakeholder__c
	 */
	public static List<ERM_Stakeholder__c> createEventStakeholders(Integer nb, List<Session__c> oSessions, List<Event_Registration__c> oParticipants) {
		List<ERM_Stakeholder__c> oStakeholders = new List<ERM_Stakeholder__c>();

		for (Session__c oSession: oSessions) {
			for (Event_Registration__c oParticipant: oParticipants) {
	for (Integer i = 0; i < nb; i++) {
		oStakeholders.add(
			new ERM_Stakeholder__c(
	Name = 'PARTICIPANT NUMBER' + i,
	Event__c = oSession.Event__c, //Lookup
	Session__c = oSession.Id, //Lookup
	Participant__c = oParticipant.Id //Lookup
			)
		);
	}
			}
		}
		return oStakeholders;
	}

	public static String generateRandomInteger(Integer len) {
		final String chars = '1234567890123454327658902348901234565487690678453789';
		String randStr = '';
		while (randStr.length() < len) {
			Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
			randStr += chars.substring(idx, idx + 1);
		}
		return randStr;
	}

	public static ProductFeature__c createFeature() {

		ProductFeature__c objProdFeature = new ProductFeature__c();

		objProdFeature.Description__c = 'C.2200 MCS Base Package SMB';
		objProdFeature.NSN_Code__c = 'Test11111';
		objProdFeature.NSNClassification__c = 'Sales Marketing Bundle';

		return objProdFeature;
	}

	public static String generateRandomString(Integer len) {
		final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
		String randStr = '';
		while (randStr.length() < len) {
			Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
			randStr += chars.substring(idx, idx + 1);
		}
		return randStr;
	}

	public static List<Apttus_Proposal__Proposal__c> createCQ(Integer size, Account acc, Opportunity opp) {
		List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
		id rcdtype = [select id from recordtype where developername = 'Contracted_quote'].id;
		for (integer i = 0; i < size; i++) {
			Apttus_Proposal__Proposal__c proposalObj = new Apttus_Proposal__Proposal__c();
			proposalObj.Apttus_Proposal__Opportunity__c = opp.id;
			proposalObj.Apttus_Proposal__Account__c = acc.id;
			proposalObj.Apttus_Proposal__Proposal_Name__c = 'Test' + i;
			proposalObj.CurrencyIsoCode = 'EUR';
			proposalObj.RecordTypeId = rcdtype;
			proposalList.add(proposalObj);
		}
		return proposalList;
	}

	public static List<Sales_Order_Reporting__c> createSalesOrder(Integer size, Apttus_Proposal__Proposal__c cq, Account acc) {
		List<Sales_Order_Reporting__c> SOList = new List<Sales_Order_Reporting__c>();
		for (integer i = 0; i < size; i++) {
			Sales_Order_Reporting__c SO = new Sales_Order_Reporting__c();
			so.ALU_Order_Number__c = '10001' + i;
			SO.PO_Amount__c = 500;
			SO.Order_Created__c = system.today();
			SO.CurrencyIsoCode = 'EUR';
			SOList.add(SO);
		}
		return SOList;
	}

	public static List<Account> createAccount(String recordTypeName, Integer size, Id ParentId) {
		List<Account> oAccountList = new List<Account>();
		Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
		for (Integer i = 0; i < size; i++) {
			Account oAccount = new Account();
			oAccount.Name = 'Test ' + recordTypeName + ' Account -' + i + Utils.generateRandomInteger(2) + Utils.generateRandomString(2);
			if (recordTypeName.equals('Customer') || recordTypeName.equals('Prospect')) {
	oAccount.BillingStreet = 'Estrada Seminario 4';
	oAccount.BillingCity = 'Lisbon';
	oAccount.BillingPostalCode = '2610171';
	oAccount.BillingCountry = 'Portugal';
	oAccount.AccountStatusInCRMOM__c = 'Active';
	oAccount.Industry = 'Enterprise';
	oAccount.Market__c = 'Market Europe';
	oAccount.Country__c = 'Portugal';
	oAccount.AccountNumber = '301030871';
			} else if (recordTypeName.equals('Legal_Entity')) {
	oAccount.ParentId = ParentId;
			}
			oAccount.RecordTypeId = recordTypeId;
			oAccountList.add(oAccount);
		}
		return oAccountList;
	}

	public static List<Product2> createProduct(Integer size) {
		List<Product2> oProductList = new List<Product2>();
		for (Integer i = 0; i < size; i++) {
			Product2 oProduct = new Product2();
			oProduct.Name = 'Test Product - ' + i + Utils.generateRandomInteger(2) + Utils.generateRandomString(2);
			oProduct.ProductCode = '133-047489_' + i;
			oProduct.DataUsage__c = 'CARES';
			oProduct.PMD_Portfolio_Classification__c = 'Product';
			oProduct.NCP_CAREACTIVATE__c = 'Test';
			oProduct.DataUsage__c = 'CARES';
			oProduct.NCP_Nokia_Product_Id__c = i + Utils.generateRandomInteger(5);
			oProduct.NCP_CAREACTIVATE__c = 'Test';
			oProductList.add(oProduct);
		}
		return oProductList;
	}

	public static List<Product_Relation__c> createProductRelation(Integer size, Product2 parentProduct, Product2 childProduct) {
		List<Product_Relation__c> oProductRelationList = new List<Product_Relation__c>();
		for (Integer i = 0; i < size; i++) {
			Product_Relation__c oProductRelation = new Product_Relation__c();
			oProductRelation.Child_Name__c = childProduct.NCP_Nokia_Product_Id__c;
			oProductRelation.Parent_Type__c = 'Design Item';
			oProductRelation.Child_Type__c = 'NSN Complementary Item';
			oProductRelation.RelationFor__c = 'ProductRelation';
			oProductRelation.Parent_Name__c = parentProduct.NCP_Nokia_Product_Id__c;
			oProductRelation.RelationType__c = 'NSN Is Complemented By';
			oProductRelation.EDPActiveStatus__c = true;
			oProductRelationList.add(oProductRelation);
		}
		return oProductRelationList;
	}

	public static List<PriceBookEntry> createPriceBookEntry(Integer size, Product2 oProduct) {
		List<PriceBookEntry> oPriceBookEntryList = new List<PriceBookEntry>();
		for (Integer i = 0; i < size; i++) {
			PriceBookEntry oPriceBookEntry = new PriceBookEntry(
	Pricebook2Id = Test.getStandardPricebookId(),
	Product2Id = oProduct.id,
	UnitPrice = 0,
	CurrencyIsoCode = 'EUR',
	IsActive = true
			);
			oPriceBookEntryList.add(oPriceBookEntry);
		}
		return oPriceBookEntryList;
	}

	public static List<Asset> createAsset(String recordTypeName, Integer size, Account oAccount, Product2 oProduct) {
		List<Asset> oAssetList = new List<Asset>();
		Id recordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
		for (Integer i = 0; i < size; i++) {
			Asset oAsset = new Asset();
			oAsset.Name = 'Test ' + recordTypeName + ' Asset -' + i + Utils.generateRandomInteger(2) + Utils.generateRandomString(2);
			if (recordTypeName.equals('CH_CoveredProduct')) {
	oAsset.AccountId = oAccount.id;
	oAsset.Product2Id = oProduct.id;
			}
			if (recordTypeName.equals('CH_NetworkElementAsset')) {
	oAsset.AccountId = oAccount.id;
	oAsset.Product2Id = oProduct.id;
	oAsset.CH_CountryISOName__c = 'Albania';
	oAsset.CH_NetworkManagementSystemID__c='TestManageSysId'+String.valueOf(System.now());
	
			}
			oAsset.RecordTypeId = recordTypeId;
			oAssetList.add(oAsset);
		}
		return oAssetList;
	}

	public static List<Entitlement> createEntitlement(Integer size, Account oAccount, Asset oAsset) {
		List<Entitlement> oEntitlementList = new List<Entitlement>();
		for (Integer i = 0; i < size; i++) {
			Entitlement oEntitlement = new Entitlement();
			oEntitlement.Name = 'Test Entitlement -' + i + Utils.generateRandomInteger(2) + Utils.generateRandomString(2);
			oEntitlement.AccountId = oAccount.Id;
			oEntitlement.CH_CDB_EntitlementId__c = 'Entitlement' + i;
			oEntitlement.StartDate = System.today();
			oEntitlement.EndDate = System.today() + 10;
			oEntitlement.AssetId = oAsset.Id;
			oEntitlement.CH_EntitlementType__c = 'Entitled Asset';
			oEntitlement.CH_ServiceMappingId__c = 'Legacy Customer Support Service - No Severity 24x7';
			oEntitlementList.add(oEntitlement);
		}
		return oEntitlementList;
	}

	public static List<EntitlementContact> createEntitlementContact(Integer size, Entitlement oEntitlement, Contact oContact) {
		List<EntitlementContact> oEntitlementContactList = new List<EntitlementContact>();
		for (Integer i = 0; i < size; i++) {
			EntitlementContact oEntitlementContact = new EntitlementContact();
			oEntitlementContact.EntitlementId = oEntitlement.id;
			oEntitlementContact.ContactId = oContact.id;
			oEntitlementContactList.add(oEntitlementContact);
		}
		return oEntitlementContactList;
	}

	public static List<ServiceContract> createServiceContract(Integer size, Account oAccount, Boolean hasEntitlementScript) {
		return createServiceContract('', size, oAccount, hasEntitlementScript);
	}

	public static List<ServiceContract> createServiceContract(String recordTypeName, Integer size, Account oAccount, Boolean hasEntitlementScript) {
		List<ServiceContract> oServiceContractList = new List<ServiceContract>();
		Id recordTypeId = !String.isBlank(recordTypeName)?Schema.SObjectType.ServiceContract.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId():null;
		for (Integer i = 0; i < size; i++) {
			ServiceContract oServiceContract = new ServiceContract();
			oServiceContract.AccountId = oAccount.id;
			oServiceContract.Name = 'Test ' + recordTypeName + ' - ' + i + Utils.generateRandomInteger(2) + Utils.generateRandomString(2);
			oServiceContract.Pricebook2Id = Test.getStandardPricebookId();
			if(recordTypeId != null) oServiceContract.RecordTypeId = recordTypeId;
			if(recordTypeName.equals('CH_ServiceContract')) {
	oServiceContract.CH_CDB_ContractId__c = 'Test';
	oServiceContract.CH_EntitlementScript__c = (hasEntitlementScript) ? 'Header Script' : '';
			}
			else if(recordTypeName.equals('CH_VendorContract')) {
	oServiceContract.StartDate = System.today();
			}
			oServiceContractList.add(oServiceContract);
		}
		return oServiceContractList;
	}

	public static List<ContractLineItem> createContractLineItem(Integer size, ServiceContract oServiceContract, Asset oAsset, PricebookEntry oPricebookEntry, Boolean hasEntitlementScript) {
		//
		List<ContractLineItem> oContractLineItemList = new List<ContractLineItem>();
		for (Integer i = 0; i < size; i++) {
			ContractLineItem oContractLineItem = new ContractLineItem();
			oContractLineItem.ServiceContractId = oServiceContract.Id;
			oContractLineItem.AssetId = oAsset.Id;
			oContractLineItem.UnitPrice = 0;
			oContractLineItem.Quantity = 1;
			oContractLineItem.CH_LineItemEntitlementScript__c = (hasEntitlementScript) ? 'Script' : '';
			oContractLineItem.CH_CDB_EntitlementId__c = 'TEST';
			oContractLineItem.CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7';
			oContractLineItem.PricebookEntryId = oPricebookEntry.Id;
			oContractLineItemList.add(oContractLineItem);
		}
		return oContractLineItemList;
	}

	public static List<Case> createCase(String recordTypeName, Integer size, Account oAccount, Contact oContact, Product2 oProduct) {
		List<Case> oCaseList = new List<Case>();
		Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
		for (Integer i = 0; i < size; i++) {
			Case oCase = new Case();
			oCase.AccountId = oAccount.Id;
			oCase.ContactId = oContact.Id;
			oCase.CH_ReportedDate__c = DateTime.Now();
			oCase.Mobile_Phone__c = '123-456789';
			oCase.Country__c = 'Portugal';
			oCase.reason = 'New problem';
			oCase.Subject = 'Test ' + recordTypeName + ' Case -' + i + Utils.generateRandomInteger(2) + Utils.generateRandomString(2);
			oCase.CH_Summary__c = 'Test ' + recordTypeName + ' Case -' + i + Utils.generateRandomInteger(2) + Utils.generateRandomString(2);
			oCase.Type = 'Incident';
			oCase.Description = 'TEST';
			oCase.Severity__c = 'Critical';
			oCase.CH_Outage__c = 'Yes';
			oCase.Status = 'Created';
			oCase.CH_IssueOccurenceDate__c = system.today();
			oCase.ProductId = oProduct.Id;
			oCase.CH_Initial_Assignment__c = true;
			oCase.CH_SystemRestoredTargetDate__c = system.now();
			oCase.CH_Reassignment__c = true;
			oCase.recordTypeId = recordTypeId;
			oCaseList.add(oCase);
		}
		return oCaseList;
	}
}