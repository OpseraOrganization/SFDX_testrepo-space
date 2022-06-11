@istest
public class CQ_CloneQuoteControllerTest {
	Private static final Id Contracted_Quote_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get(Label.CQ_RecordTypeId).getRecordTypeId();
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	private static  Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	private static  Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	
	public Static List<Apttus_Proposal__Proposal__c> Quotes=new List<Apttus_Proposal__Proposal__c>();
	public Static List<User> userList = new List<User>();
	public Static List<Contact> Contacts=new List<Contact>();
	public Static List<objectTerritory2Association> objectTerritory2Associationlist = new List<objectTerritory2Association>();
	public Static List<Account> accounts=new List<Account>();
	
	static testMethod void test() {
		user SysAdmin1= TestDataFactory.userCreation(1,'System Administrator')[0];
		user SysAdmin2 = TestDataFactory.userCreation(1,'System Administrator')[0];
		user SysAdmin3 = TestDataFactory.userCreation(1,'System Administrator')[0];
		userList.add(SysAdmin1);
		userList.add(SysAdmin2);
		userList.add(SysAdmin3);
		database.insert(userList);
		Territory2 L7ter=[Select id,developerName from Territory2 where Territory2Model.state = 'Active' AND Hierarchy_Level__c=:GlobalConstants.L7_level ORDER BY NAME DESC limit 1];
		Userterritory2Association U2Ter=new Userterritory2Association(Territory2Id=L7ter.id,UserId=SysAdmin1.id);	
		
		System.runAs(SysAdmin1){
			database.insert(U2Ter);
			File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
			fscs.name= 'Opportunity_SalesPhase_FinalStage';
			fscs.Value__c = 'Completed';
			database.insert(fscs);
			
			Account accountNoNvzw = NF_TestDataFactory.createAccount('1TestNONVZW0000');
			accountNoNvzw.RecordTypeId=custRecordTypeId;
			accounts.add(accountNoNvzw);
			Database.insert(accounts);
			
			Contacts = TestDataFactory.createContact2(1,accounts[0]);
			Contacts[0].CH_ContactType__c = 'Customer';
			Contacts[0].Contact_Status__c = 'Active';
			//Contacts[1].CH_ContactType__c = 'Customer';
			//Contacts[1].Contact_Status__c = 'Active';
			//Contacts[1].LastName = 'TestRojer';
			Database.insert(Contacts);
			
			Account accountNoNvzw_LegalEnt = NF_TestDataFactory.createAccount('10308719999AISIS');
			accountNoNvzw_LegalEnt.Accountnumber='1323242223i';
			accountNoNvzw_LegalEnt.Recordtypeid=LERecordTypeId;
			accountNoNvzw_LegalEnt.ParentId=accounts[0].Id;
			accountNoNvzw_LegalEnt.Default_Legal_Entity__c = true;
			accountNoNvzw_LegalEnt.Partner_Program__c=null;
			accounts.add(accountNoNvzw_LegalEnt);
			Database.upsert(accounts);
			
			objectTerritory2Association NonVzWAcc=new objectTerritory2Association(objectId=accounts[0].Id,Territory2Id=L7ter.Id,AssociationCause='Territory2Manual');
			objectTerritory2Associationlist.add(NonVzWAcc);
			Database.insert(objectTerritory2Associationlist); 
			
			Opportunity OpportunityNonVZW = NF_TestDataFactory.createOpportunity(accounts[0].Id, 'Create offer (bid)', 'Offer in Progress', Date.today().addDays(10), 7000000);
			OpportunityNonVZW.Lead_BG__c='MN';//modified to fix the error: INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST, bad value for restricted picklist field: NSW: [Lead_BG__c]
			OpportunityNonVZW.RecordTypeId = oppDirectRecordTypeId;
			OpportunityNonVZW.Business_Type__c = 'Standard Opportunity';
			List<opportunity> opportunities=new List<opportunity>();
			opportunities.add(OpportunityNonVZW);
			Database.insert(opportunities);
			
			Test.startTest(); 
			Apttus_Proposal__Proposal__c Quote_ObjNoNVZW = new Apttus_Proposal__Proposal__c(
	RecordtypeId=Contracted_Quote_RecId,
	CQ_Value__c=100,
	Apttus_Proposal__Proposal_Expiration_Date__c=system.today(),
	Apttus_Proposal__Proposal_Name__c = 'quote',
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Approval_Stage__c = 'Draft',
	Account_Legal_Entity__c=accounts[1].Id,
	Apttus_Proposal__Opportunity__c = opportunities[0].Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	isCQ__C=true,
	CQ_Documents_Attached__c=true,
	CQ_Due_Date__c  =system.Today()+30,
	CQ_Lead__c=userList[0].id,
	CQ_Sales_Lead__c=userList[1].id,
	Surround_QTC_Code__c='4455115',
	NokiaCPQ_Proposal_Id__c = '19..123456.A00A'
			);
			Quotes.add(Quote_ObjNoNVZW);
			Database.insert(Quotes);
			System.debug('Quotes::> '+Quotes[0]);
			group grp= [SELECT DeveloperName,Id,RelatedId,Type FROM Group WHERE Type = 'territory' and RelatedId=:L7ter.id];
			Apttus_Proposal__Proposal__Share QuoteShare=new Apttus_Proposal__Proposal__Share(ParentId=Quotes[0].id,AccessLevel='Edit',UserOrGroupId=grp.id);
			Database.insert(QuoteShare); 
			
			List<CQ_Quote_Team__c> cqTeamList = new List<CQ_Quote_Team__c>();
			CQ_Quote_Team__c cqteam = new CQ_Quote_Team__c();
			cqTeam.CQ_CQ_Name__c = Quotes[0].Id;
			cqTeam.CQ_Quote_Team_Member__c = userList[2].Id;
			cqTeamList.add(cqTeam);
			Database.insert(cqTeamList);
			
			List<CQ_Customer_Contact__c> ccList = new List<CQ_Customer_Contact__c>();
			CQ_Customer_Contact__c cc = new CQ_Customer_Contact__c();
			cc.CQ_Contact__c = Contacts[0].Id;
			cc.CQ_CQ_Name__c = Quotes[0].Id;
			cc.CQ_Account__c = accounts[0].Id;
			ccList.add(cc);
			Database.insert(ccList);

			CQ_CloneQuoteController.fetchquoteDetails(Quotes[0].Id);
			CQ_CloneQuoteController.fetchpicklistValues('CQ_Customer_Organization_Segment__c');
			CQ_CloneQuoteController.fetchUser(userList[0].Id,userList[1].Id);
			CQ_CloneQuoteController.getQuoteTeam(Quotes[0].Id);
			CQ_CloneQuoteController.getCustomerContact(Quotes[0].Id);
			CQ_CloneQuoteController.cloneQuote(Quotes[0]);
			
			CQ_CloneQuoteController.quoteWrapper wrap = new CQ_CloneQuoteController.quoteWrapper();
			List<CQ_CloneQuoteController.quoteWrapper> wraplist = new List<CQ_CloneQuoteController.quoteWrapper>();
			
			wrap.Quoteteam = userList[2];
			wrap.usersearch = 'test';
			wraplist.add(wrap);
			String wrapperselializedstring = JSON.serialize(wraplist);
			CQ_CloneQuoteController.saveQuoteTeam(wrapperselializedstring, Quotes[0].Id, Quotes[0]);
			
			CQ_CloneQuoteController.quoteWrapper cwrap = new CQ_CloneQuoteController.quoteWrapper();
			List<CQ_CloneQuoteController.quoteWrapper> cwraplist = new list<CQ_CloneQuoteController.quoteWrapper>();
			cwrap.Cus_Contacts = Contacts[0];
			cwrap.consearch = 'test';
			cwrap.isPrimary = true;
			cwraplist.add(cwrap);
			String wrapperstring = JSON.serialize(cwraplist);
			CQ_CloneQuoteController.saveCustomerContact(wrapperstring,Quotes[0].Id,Quotes[0].Apttus_Proposal__Account__c);
			//CQ_CloneQuoteController.cloneCustomerContact(Quotes[0].Id,Quotes[0].Id);
			Test.stopTest();
		}
	}
	static testMethod void testexp() {
		CQ_CloneQuoteController.fetchquoteDetails(null);
		CQ_CloneQuoteController.fetchpicklistValues(null);
		CQ_CloneQuoteController.fetchUser(null,null);
	}
	static testMethod void testexcep() {
		CQ_CloneQuoteController.getQuoteTeam(null);
		CQ_CloneQuoteController.getCustomerContact(null);
		CQ_CloneQuoteController.cloneQuote(null);
		CQ_CloneQuoteController.saveQuoteTeam(null, null, null);
		CQ_CloneQuoteController.saveCustomerContact(null, null, null);
	}
	static testMethod void testCus(){
		try{
			List<CQ_Customer_Contact__c> ccList = new List<CQ_Customer_Contact__c>();
			CQ_Customer_Contact__c cc = new CQ_Customer_Contact__c();
			cc.CQ_Is_Primary__c = TRUE;
			ccList.add(cc);
			CQ_CustomerContactTriggerHandler.restrictDeleteOnPrimary(ccList);
		}
		catch(exception ex){
			Boolean expectedExceptionThrown =  ex.getMessage().contains('one') ? true : false;
			System.assertEquals(expectedExceptionThrown, true);
		}
	}
}