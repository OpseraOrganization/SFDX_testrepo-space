@isTest
public class PS_PartnerSupportApplicationUtility_Test {
	final static ID caseRectype = Schema.describeSObjects(new List<String> {'Case'})[0].getRecordTypeInfosByDeveloperName().get('PS_Partner_Support').getRecordTypeId();
	
	final static ID accRectype = Schema.describeSObjects(new List<String> {'Account'})[0].getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	
	@isTest
	public static void supportTicketShare_TestMethod(){
	
		Account acc = new Account();
		acc.Name = 'PRM test Account';
		acc.Partner_Status__c='Active';
		acc.recordTypeId = accRectype;
		insert acc;
		
		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
		
		User u = new User(Alias = 'testpar', Email='partnersupport@supportpartner.co', 
		EmailEncodingKey='UTF-8', LastName='PartnerSupport', LanguageLocaleKey='en_US', 
		LocaleSidKey='en_US', ProfileId = p.Id, 
		TimeZoneSidKey='America/Los_Angeles', UserName='partnersupport@supportpartner.co.testorg');
		
		insert u;
		
		ID caseRectype = Schema.describeSObjects(new List<String> {'Case'})[0].getRecordTypeInfosByDeveloperName().get('PS_Partner_Support').getRecordTypeId();
		
		
		
		Case c = new Case();
		c.AccountId = acc.Id;
		c.RecordTypeId = caseRectype;
		c.Issue_Reported_By__c = u.Id;
		c.Subject = 'Test Subject';
		c.Description = 'Test Description';
		c.Type = 'Compliance';
		
		Test.startTest();
		PS_PartnerSupportApplicationUtility.CaseFlowParams casePara = new PS_PartnerSupportApplicationUtility.CaseFlowParams();
		casePara.caseNew = c;
		c.Issue_Reported_By__c = null;
		casePara.caseOld = c;
		
		PS_PartnerSupportApplicationUtility.partnerSupportTicketShare(new List<PS_PartnerSupportApplicationUtility.CaseFlowParams>{casePara});
		Test.stopTest();
		
	}
	
	@isTest
	public static void createPartnerTicket_Test(){
		 UserRole ur = new UserRole(name='Test Role');
			insert ur;
		User u1 = new User();
		u1.Id = UserInfo.getUserId();
		u1.UserRoleId = ur.Id;
		
		update u1;
		
		System.runAs(u1){
		
		Profile p1 = [SELECT Id FROM Profile WHERE Name='PRM Partner Community User Login']; 
		
	
		
		Account acc = new Account();
		acc.Name = 'PRM Test Account';
		acc.Partner_Status__c='Active';
		acc.Partner_type__c = 'Alliance Partner';
		acc.recordTypeId = accRectype;
		insert acc;
		
		Contact c = new Contact();
		c.FirstName = 'partner';
		c.LastName = 'User';
		c.AccountId = acc.Id;
		c.Email = 'partner.user@email1.com';
		
		insert c;
		
		acc.IsPartner = true;
		update acc;
		
	
		 User u = new User(Alias = 'testpar1', Email='partnersupport1@supportpartner.co', 
		 EmailEncodingKey='UTF-8', LastName='PartnerSupport1', LanguageLocaleKey='en_US', 
		 LocaleSidKey='en_US', ProfileId = p1.Id,
		 TimeZoneSidKey='America/Los_Angeles', UserName='partneruser@organization.com', ContactId = c.Id);
		insert u;
		
		
		
		PS_CreatePartnerTicket.getPartnerCaseRecordTypeId();
		PS_CreatePartnerTicket.getPickListValues();
		PS_CreatePartnerTicket.getAllAvailableListViews();
		
		System.runAs(u){
			PS_CreatePartnerTicket.getPartnerUserType();
			PS_CreatePartnerTicket.getPartnerUserDetails();
		}
		
		PS_CreatePartnerTicket.getPartnerUserType();
		
		Case c1 = new Case();
		c1.AccountId = acc.Id;
		c1.RecordTypeId = caseRectype;
		c1.Issue_Reported_By__c = u.Id;
		c1.Subject = 'Test Subject';
		c1.Description = 'Test Description';
		c1.Type = 'Compliance';
		
		PS_CreatePartnerTicket.saveExternalCase(c1);
		}
	}
}