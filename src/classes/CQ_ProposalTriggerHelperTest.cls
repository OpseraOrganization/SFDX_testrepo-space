@isTest
public class CQ_ProposalTriggerHelperTest { 
	
	Private static final Id Contracted_Quote_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get(Label.CQ_RecordTypeId).getRecordTypeId();
	Private static final Id CQ_Read_Only_RecId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CQ_Read_Only').getRecordTypeId();
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Record_Type').getRecordTypeId();
	private static  Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	private static  Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	
	
	public Static List<Apttus_Proposal__Proposal__c> Quotes=new List<Apttus_Proposal__Proposal__c>();
	public Static List<Surround_document_links__c> SurroundDoclinks=new List<Surround_document_links__c>();
	public Static List<contentDocumentLink> ContentDoclinks=new List<contentDocumentLink>();
	public Static List<Contact> Contacts=new List<Contact>();
	public Static List<CQ_Customer_Contact__c> CustomerContacts=new List<CQ_Customer_Contact__c>();
	public Static List<CQ_Quote_Team__c> Quoteteams=new List<CQ_Quote_Team__c>();
	public Static List<User> userList = new List<User>();
	public Static List<CQ_Sync_Quote_EAI__c> SyncQuotetoEAI = new List<CQ_Sync_Quote_EAI__c>();
	public Static List<objectTerritory2Association> objectTerritory2Associationlist = new List<objectTerritory2Association>();
	
	
	
	@testSetup
	static void TestData() {

		user SysAdmin1= TestDataFactory.userCreation(1,'System Administrator')[0];
		user SysAdmin2 = TestDataFactory.userCreation(1,'System Administrator')[0];
		userList.add(SysAdmin1);
		userList.add(SysAdmin2);
		database.insert(userList);
		Territory2 L7ter=[Select id,developerName from Territory2 where Territory2Model.state = 'Active' AND Hierarchy_Level__c=:GlobalConstants.L7_level ORDER BY NAME DESC limit 1];
		System.runAs(SysAdmin1){
			Userterritory2Association U2Ter=new Userterritory2Association(Territory2Id=L7ter.id,UserId=SysAdmin1.id);
			database.insert(U2Ter);
			File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
			fscs.name= 'Opportunity_SalesPhase_FinalStage';
			fscs.Value__c = 'Completed';
			database.insert(fscs);
			
			CQ_Sync_Quote_EAI__c maxsize=new CQ_Sync_Quote_EAI__c(Name='CQ_MAX_SIZE',Size__c=25);
			CQ_Sync_Quote_EAI__c MAX_BULK_SIZE_ERROR=new CQ_Sync_Quote_EAI__c(Name='MAX_BULK_SIZE_ERROR',Message__c='max size');
			CQ_Sync_Quote_EAI__c CQ_SYNCQUOTE_INSERT=new CQ_Sync_Quote_EAI__c(Name='CQ_SYNCQUOTE_INSERT',sync__c=true);
			CQ_Sync_Quote_EAI__c CQ_SYNCQUOTE_UPDATE=new CQ_Sync_Quote_EAI__c(Name='CQ_SYNCQUOTE_UPDATE',sync__c=true);
			
			SyncQuotetoEAI.add(maxsize);
			SyncQuotetoEAI.add(MAX_BULK_SIZE_ERROR);
			SyncQuotetoEAI.add(CQ_SYNCQUOTE_INSERT);
			SyncQuotetoEAI.add(CQ_SYNCQUOTE_UPDATE);
			database.insert(SyncQuotetoEAI);
			
			
			
			
			Account accountNoNvzw = NF_TestDataFactory.createAccount('1TestNONVZW0000');
			Account accountVZW = NF_TestDataFactory.createAccount('1TestVZW00000');
			
			
			accountVZW.Qtc_sold_to__c=system.Label.VzW_Number;
			accountNoNvzw.RecordTypeId=custRecordTypeId;
			accountVZW.RecordTypeId=custRecordTypeId;
			
			List<Account> accounts=new List<Account>();
			accounts.add(accountNoNvzw);
			accounts.add(accountVZW);
			
			Database.insert(accounts);
			Account accountNoNvzw_LegalEnt = NF_TestDataFactory.createAccount('10308719999AISIS');
			Account accountVZW_LegalEnt = NF_TestDataFactory.createAccount('103087199999KDDKD');
			
			accountNoNvzw_LegalEnt.Accountnumber='1323242223i';
			accountNoNvzw_LegalEnt.Recordtypeid=LERecordTypeId;
			accountNoNvzw_LegalEnt.ParentId=accounts[0].Id;
			accountNoNvzw_LegalEnt.Default_Legal_Entity__c = true;
			accountNoNvzw_LegalEnt.Partner_Program__c=null;
			
			accountVZW_LegalEnt.Recordtypeid=LERecordTypeId;
			accountVZW_LegalEnt.Accountnumber='1493593549i';
			accountVZW_LegalEnt.ParentId=accounts[1].Id;
			accountVZW_LegalEnt.Default_Legal_Entity__c = true;
			accountVZW_LegalEnt.Partner_Program__c=null;
			accountVZW_LegalEnt.Qtc_sold_to__c=system.Label.VzW_Number;
			
			accounts.add(accountNoNvzw_LegalEnt);
			accounts.add(accountVZW_LegalEnt);
			
			Database.upsert(accounts);
			objectTerritory2Association NonVzWAcc=new objectTerritory2Association(objectId=accounts[0].Id,Territory2Id=L7ter.Id,AssociationCause='Territory2Manual');
			objectTerritory2Association VzWAcc=new objectTerritory2Association(objectId=accounts[1].Id,Territory2Id=L7ter.Id,AssociationCause='Territory2Manual');
			objectTerritory2Associationlist.add(NonVzWAcc);
			objectTerritory2Associationlist.add(VzWAcc);
			Database.insert(objectTerritory2Associationlist);
			
			
			Opportunity OpportunityNonVZW = NF_TestDataFactory.createOpportunity(accounts[0].Id, 'Create offer (bid)', 'Offer in Progress', Date.today().addDays(10), 7000000);
			OpportunityNonVZW.Lead_BG__c='MN';
			OpportunityNonVZW.RecordTypeId = oppDirectRecordTypeId;
			OpportunityNonVZW.Business_Type__c = 'Standard Opportunity';
			
			Opportunity OpportunityVZW = NF_TestDataFactory.createOpportunity(accounts[1].Id, 'Create offer (bid)', 'Offer in Progress', Date.today().addDays(10), 7000000);
			OpportunityVZW.Lead_BG__c='MN';
			OpportunityVZW.RecordTypeId = oppDirectRecordTypeId;
			OpportunityVZW.Business_Type__c = 'Standard Opportunity';
			
			List<opportunity> opportunities=new List<opportunity>();
			opportunities.add(OpportunityNonVZW);
			opportunities.add(OpportunityVZW);
			Database.insert(opportunities);
			
			Test.startTest();
			Apttus_Proposal__Proposal__c Quote_ObjNoNVZW = new Apttus_Proposal__Proposal__c(
	RecordtypeId=Contracted_Quote_RecId,
	CQ_Value__c=100,
	Apttus_Proposal__Proposal_Expiration_Date__c=system.today().addDays(2),
	Apttus_Proposal__Proposal_Name__c = 'quote',
	Apttus_Proposal__Account__c = accounts[0].Id,
	Apttus_Proposal__Approval_Stage__c = 'Draft',
	Account_Legal_Entity__c=accounts[2].Id,
	Apttus_Proposal__Opportunity__c = opportunities[0].Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	isCQ__C=true,
	CQ_Documents_Attached__c=true,
	CQ_Due_Date__c  =system.Today()+30,
	CQ_Lead__c=userList[0].id,
	CQ_Sales_Lead__c=userList[1].id,
	Surround_QTC_Code__c='4455115'
			);
			
			Apttus_Proposal__Proposal__c Quote_ObjVZW = new Apttus_Proposal__Proposal__c(
	RecordtypeId=Contracted_Quote_RecId,
	CQ_Value__c=100,
	Apttus_Proposal__Proposal_Expiration_Date__c=system.today(),
	Apttus_Proposal__Proposal_Name__c = 'quote',
	Apttus_Proposal__Approval_Stage__c = 'Draft',
	Apttus_Proposal__Account__c = accounts[1].Id,
	Account_Legal_Entity__c=accounts[3].Id,
	Apttus_Proposal__Opportunity__c = opportunities[1].Id,
	Apttus_QPConfig__ConfigurationFinalizedDate__c = date.today(),
	isCQ__C=true,
	CQ_eQuote__c=true,
	CQ_eQuote_Status__c=GlobalConstants.EQUOTE_STATUS_INPROGRESS,
	CQ_Due_Date__c  =system.Today()+30  ,
	CQ_Documents_Attached__c=true,
	CQ_Customer_Organization_Segment__c='VERIZON WIRELESS INC.',
	CQ_Lead__c=userList[0].id,
	CQ_Sales_Lead__c=userList[1].id
			);
			
			
			
			Quotes.add(Quote_ObjNoNVZW);
			Quotes.add(Quote_ObjVZW);
			Database.insert(Quotes);
			group grp= [SELECT DeveloperName,Id,RelatedId,Type FROM Group WHERE Type = 'territory' and RelatedId=:L7ter.id];
			Apttus_Proposal__Proposal__Share QuoteShare=new Apttus_Proposal__Proposal__Share(ParentId=Quotes[0].id,AccessLevel='Edit',UserOrGroupId=grp.id);
			Database.insert(QuoteShare);
			
			Test.stopTest();
		}
	}
	static testMethod void test(){
		
		
		Test.startTest();
		user SysAdmin1= TestDataFactory.userCreation(1,'System Administrator')[0];
		user SysAdmin2 = TestDataFactory.userCreation(1,'System Administrator')[0];
		userList.add(SysAdmin1);
		userList.add(SysAdmin2);
		database.insert(userList);
		Account accountNoNvzw = NF_TestDataFactory.createAccount('1TestNONVZW0ddd');
		system.runAs(userList[0]){
			database.insert(accountNoNvzw);
		} 
		Account accountNoNvzw_LegalEnt = NF_TestDataFactory.createAccount('1030871999disIS');
		
		accountNoNvzw_LegalEnt.Accountnumber='1323kmm223i';
		accountNoNvzw_LegalEnt.Recordtypeid=LERecordTypeId;
		accountNoNvzw_LegalEnt.ParentId=accountNoNvzw.Id;
		accountNoNvzw_LegalEnt.Default_Legal_Entity__c = true;
		accountNoNvzw_LegalEnt.Partner_Program__c=null;
		system.runAs(userList[0]){
			database.insert(accountNoNvzw_LegalEnt);
		}
		Territory2 L7ter=[Select id,developerName from Territory2 where Territory2Model.state = 'Active' AND Hierarchy_Level__c=:GlobalConstants.L7_level ORDER BY Name ASC limit 1 ];
		objectTerritory2Association NonVzWAcc=new objectTerritory2Association(objectId=accountNoNvzw.Id,Territory2Id=L7ter.Id,AssociationCause='Territory2Manual');
		system.runAs(userList[0]){  
			database.insert(NonVzWAcc);
		}
		Apttus_Proposal__Proposal__c NonvZWQuote=[Select Id,OwnerId ,Surround_QTC_Code__c,Apttus_Proposal__Approval_Stage__c,CQ_Sales_Lead__c,CQ_Lead__c,NokiaCPQ_Proposal_Id__c,Apttus_Proposal__Account__c,Account_Legal_Entity__c,Account_Legal_Entity__r.Qtc_sold_to__c from Apttus_Proposal__Proposal__c Where Account_Legal_Entity__r.Qtc_sold_to__c!=:system.Label.VzW_Number Limit 1];
		Apttus_Proposal__Proposal__c vZWQuote=[Select Id,Apttus_Proposal__Approval_Stage__c,CQ_eQuote_Status__c,CQ_eQuote__c,eQuote_Error__c,NokiaCPQ_Proposal_Id__c ,Account_Legal_Entity__r.Qtc_sold_to__c from Apttus_Proposal__Proposal__c Where Account_Legal_Entity__r.Qtc_sold_to__c=:system.Label.VzW_Number Limit 1];
		GlobalConstants.IS_INBOUND=true;
		NonvZWQuote.Apttus_Proposal__Approval_Stage__c='Approved';
		NonvZWQuote.CQ_Sales_Lead__c=userList[0].id;
		NonvZWQuote.CQ_Lead__c=userList[1].id;
		NonvZWQuote.OwnerId=userList[1].id;
		NonvZWQuote.Surround_QTC_Code__c='56564566';
		NonvZWQuote.Apttus_Proposal__Account__c=accountNoNvzw.id;
		NonvZWQuote.Account_Legal_Entity__c=accountNoNvzw_LegalEnt.id;
		vZWQuote.Apttus_Proposal__Approval_Stage__c='Accepted';
		vZWQuote.eQuote_Error__c=GlobalConstants.EQUOTE_ERROR_ACCEPT;
		vZWQuote.CQ_eQuote__c=true;
		vZWQuote.CQ_eQuote_Status__c=GlobalConstants.EQUOTE_STATUS_INPROGRESS;
		
		Quotes.add(NonvZWQuote);
		Quotes.add(vZWQuote);
		system.runAs(userList[0]){
			Database.update(Quotes);
		}
		//Added by Rajitha
	CQ_ProposalTriggerHelper.sendEmailtoCQLead(Quotes);
		//CQ_ProposalTriggerHelper.sendEmailtoCQLeadOnSAPApprove(Quotes);
		//end
		Test.stopTest();
		
	}
	
	static testmethod void excepcover(){
		Test.startTest();
		CQ_ProposalTriggerHelper.createQuoteTeamoncqcreation(null);
		CQ_ProposalTriggerHelper.createQuoteNumber(null);
		CQ_ProposalTriggerHelper.CQ_QuoteVersion_Active(null,null);
		CQ_ProposalTriggerHelper.CQ_QuoteTeammemberUpdate(null,null);
		CQ_ProposalTriggerHelper.updateSurroundPricedAccount(null,null);
		CQ_ProposalTriggerHelper.updateeQuoteStatus(null,null);
		//CQ_ProposalTriggerHelper.Sync_QuotestoEAI(null,null);
		CQ_ProposalTriggerHelper.CQ_eQuoteCheck(null);
		CQ_ProposalTriggerHelper.CQ_StatusChange_NotificationEmail(null,null);
		CQ_ProposalTriggerHelper.CQTerritorysharing(null,null);
		CQ_ProposalTriggerHelper.CQTerritorysharingupdate(null,null);
		Test.stopTest();
	}
}