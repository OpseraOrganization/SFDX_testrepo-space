@istest
public class CQ_RebidQuoteControllerTest {
	Private static final Id Contracted_Quote_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get(Label.CQ_RecordTypeId).getRecordTypeId();
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	private static  Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	private static  Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	Private static final Id CQ_new_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_CQ_Quote').getRecordTypeId();
	
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
	NokiaCPQ_Proposal_Id__c = '19.123456.A001'
			);
			Quotes.add(Quote_ObjNoNVZW);
			Database.insert(Quotes);
			System.debug('Quotes::> '+Quotes[0].NokiaCPQ_Proposal_Id__c);
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
			Apttus_Proposal__Proposal__c quoteq = [Select id, name,RecordtypeId,CQ_Value__c,CPQ_NCQ_Check__c,CPQ_CQ_Check__c, Apttus_Proposal__Proposal_Expiration_Date__c,Apttus_Proposal__Proposal_Name__c,  Apttus_Proposal__Account__c, Apttus_Proposal__Approval_Stage__c, Account_Legal_Entity__c, Apttus_Proposal__Opportunity__c,Apttus_QPConfig__ConfigurationFinalizedDate__c, isCQ__c,CQ_Documents_Attached__c,CQ_Due_Date__c ,CQ_Lead__c,CQ_Sales_Lead__c,Surround_QTC_Code__c,NokiaCPQ_Proposal_Id__c  from Apttus_Proposal__Proposal__c limit 1];
			CQ_RebidQuoteController.fetchquoteDetails(Quotes[0].Id);
			CQ_RebidQuoteController.fetchpicklistValues('CQ_Customer_Organization_Segment__c');
			CQ_RebidQuoteController.rebidQuote(quoteq, Quotes[0].Id);
			CQ_RebidQuoteController.getNextChar('A');
			CQ_RebidQuoteController.updateQuote(Quotes[0].Id,Quotes);
			CQ_RebidQuoteController.cloneQuoteTeam(Quotes[0].Id,Quotes[0].Id);
			CQ_RebidQuoteController.cloneCustomerContact(Quotes[0].Id,Quotes[0].Id);
			Test.stopTest();
		}
	}
	
	 static testMethod void test2() {
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
	RecordtypeId=CQ_new_RecId,
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
	NokiaCPQ_Proposal_Id__c = '19.123456.A001'
			);
			Quotes.add(Quote_ObjNoNVZW);
			Database.insert(Quotes);
			System.debug('Quotes::> '+Quotes[0].NokiaCPQ_Proposal_Id__c);
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
			Apttus_Proposal__Proposal__c quoteq = [Select id, name,RecordtypeId,CQ_Value__c,CPQ_NCQ_Check__c,CPQ_CQ_Check__c, Apttus_Proposal__Proposal_Expiration_Date__c,Apttus_Proposal__Proposal_Name__c,  Apttus_Proposal__Account__c, Apttus_Proposal__Approval_Stage__c, Account_Legal_Entity__c, Apttus_Proposal__Opportunity__c,Apttus_QPConfig__ConfigurationFinalizedDate__c, isCQ__c,CQ_Documents_Attached__c,CQ_Due_Date__c ,CQ_Lead__c,CQ_Sales_Lead__c,Surround_QTC_Code__c,NokiaCPQ_Proposal_Id__c  from Apttus_Proposal__Proposal__c where CPQ_CQ_Check__c = true limit 1];
			CQ_RebidQuoteController.fetchquoteDetails(Quotes[0].Id);
			CQ_RebidQuoteController.fetchpicklistValues('CQ_Customer_Organization_Segment__c');
			CQ_RebidQuoteController.rebidQuote(quoteq, Quotes[0].Id);
			CQ_RebidQuoteController.getNextChar('A');
			CQ_RebidQuoteController.updateQuote(Quotes[0].Id,Quotes);
			CQ_RebidQuoteController.cloneQuoteTeam(Quotes[0].Id,Quotes[0].Id);
			CQ_RebidQuoteController.cloneCustomerContact(Quotes[0].Id,Quotes[0].Id);
			Test.stopTest();
		}
	}
	static testMethod void testexp() {
		CQ_RebidQuoteController.fetchquoteDetails(null);
		CQ_RebidQuoteController.fetchpicklistValues(null);
		CQ_RebidQuoteController.updateQuote(null,null);
	}
	static testMethod void testexcep() {
		CQ_RebidQuoteController.cloneQuoteTeam('','');
		CQ_RebidQuoteController.cloneCustomerContact('','');
	}
}