@IsTest
public class DirectQuoteSharingWCustTriggerHelperTest {
	
	static testMethod void QuoteSharing1(){
		   Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		   Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
		 Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_DIRECT_SALES_OPPORTUNITY).getRecordTypeId();
		 Id QuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.QuoteRecordType).getRecordTypeId();
		 
		Set<String> customerUserTypes = new Set<String> {'CSPLiteUser', 'PowerPartner', 'PowerCustomerSuccess',   'CustomerSuccess'};
		List<Account> accounts=new List<Account>();
		Account Customeraccount;
		Account legalEntityaccount;
		Contact ContactDS;
		User newUser;
		List <Apttus_Proposal__Proposal__c> QPList = new List<Apttus_Proposal__Proposal__c>();
		Apttus_Proposal__Proposal__c Quote=new Apttus_Proposal__Proposal__c();
		Opportunity Opportunity_v1;
			
		UserRole r = new UserRole(name = 'Test Role');
		insert r;
		System.Debug('r.PortalType-->> '+r.PortalType);
		//UserRole ur1 = [Select PortalType, PortalAccountId From UserRole where PortalType =:'Global' limit 1];
		List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
		users[0].Nokia_ID__c = '234597';
		users[0].UserRoleId = r.Id;
		insert users;
		
		System.runAs (users[0]){
			Test.startTest();
			Customeraccount = NF_TestDataFactory.createAccount('1TestNONV0000');
			Customeraccount.DMP_Account__c=true;
			Customeraccount.Active__c = true;
			Customeraccount.OwnerId = users[0].Id;
			accounts.add(Customeraccount);
			//Database.insert(accounts);
			
			legalEntityaccount = NF_TestDataFactory.createAccount('10308719999AIA');
			legalEntityaccount.Accountnumber='1323242223i';
			//LegalEntityaccount.Recordtypeid=LERecordTypeId;
			legalEntityaccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
			legalEntityaccount.ParentId=accounts[0].Id;
			legalEntityaccount.Default_Legal_Entity__c = true;
			legalEntityaccount.Partner_Program__c=null;
			accounts.add(legalEntityaccount);
					   
			insert accounts;
						
			ContactDS = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,
							AccountId=Customeraccount.id,
							Email=CSWXGlobalConstant.EmailContactNameDS);
			database.insert(ContactDS);
						
			//Profile p = [select Id,name, UserType from Profile where UserType IN:CustomerSuccess limit 1];
		   // Profile p = [select Id,name, UserType from Profile WHERE Name='Customer Community Plus Login User' LIMIT 1]; 
			Profile p = [select Id,name, UserType from Profile WHERE Name='Customer Community User Digital Sales' LIMIT 1];
			System.Debug('>>> Profile>>> '+p);
			UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];   
			
			newUser = new User(
			//UserRoleId = ur.Id,
			profileId = p.id,
			isActive = true,
			username = 'newUser@yahoo.com.test',
			email = 'pbs@ff.com',
			CommunityNickname = 'test12345',
			emailencodingkey = 'UTF-8',
			localesidkey = 'en_US',
			languagelocalekey = 'en_US',
			timezonesidkey = 'America/Los_Angeles',
			alias='nuser',
			lastname='lastname',
			contactId = ContactDS.id
			);

			insert newUser;
			newUser.isPortalEnabled =true;
			update newUser;
						
			Opportunity_v1= NF_TestDataFactory.createOpportunity(newUser.AccountId, 'Execute (Start Delivery)', 'In Execution', Date.today().addDays(10), 7000000);
			//Opportunity_v1.Lead_BG__c='NSW';
			Opportunity_v1.Lead_BG__c='MN';
			Opportunity_v1.Opportunity_ID__c='19.IN.856951';
			Opportunity_v1.RecordTypeId = oppDirectRecordTypeId;
			Opportunity_v1.Business_Type__c = 'Standard Opportunity';
			Opportunity_v1.Legal_Entity__c=legalEntityaccount.id;
			Opportunity_v1.AccountId= Customeraccount.Id;
			Opportunity_v1.End_Customer_LE__c=legalEntityaccount.id;
			Database.insert(Opportunity_v1);
			
			Quote.RecordTypeId=QuoteRecordTypeId;
			Quote.Sold_To_Party__c=legalEntityaccount.id;
			Quote.Apttus_Proposal__Account__c =newUser.AccountId;
			// Quote.Agreement_Lookup__c=agreementobj.id;
			Quote.Apttus_Proposal__Opportunity__c=Opportunity_v1.id;
			Quote.Analytics_Source__c='CXM';
			Quote.Analytics_File_Refer_ID__c= 'LTE AIR Interface AR';
			Quote.Apttus_Proposal__Approval_Stage__c='Approved';
			Quote.Creation_Date__c=System.today();
			Quote.Proposal_Recommendation_Type__c='SW Recommendation';
			Quote.Contract_Start_Date__c=System.today();
			Quote.Contract_End_Date__c=System.today()+30;
			Quote.LOA_Status__c='Approved';
			QPList.add(Quote);
			insert QPList;
			
			QPList[0].Revision_Status__c='Revision';
			DirectQuoteSharingWCustTriggerHelper.shareDirectQuoteWithCustomer(QPList);
			Test.stopTest();
		}
	}
	static testMethod void QuoteSharing2(){
		List<User> users = NF_TestDataFactory.getUsers(1,'System Administrator');
		users[0].Nokia_ID__c = '234597';
		//users[0].UserRoleId = r.Id;
		insert users;
		System.runAs(users[0]){
			Test.startTest();
			List <Apttus_Proposal__Proposal__c> QPList = new List<Apttus_Proposal__Proposal__c>();
			insert QPList;
			
			Set<Id> quotId = new Set<Id>();
			for(Apttus_Proposal__Proposal__c q: QPList){
				quotId.add(q.Id);
			}
		
			List<Apttus_Proposal__Proposal__c> quotList = [SELECT Id FROM Apttus_Proposal__Proposal__c WHERE Id IN:quotId];
			Delete quotList;
			System.Debug('quotList-->> '+ quotList.size());
		
			DirectQuoteSharingWCustTriggerHandler.afterInsertDirectQuoteShares(null);
			Test.stopTest();
		}
	}
}