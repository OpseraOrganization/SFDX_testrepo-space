@istest
	private class OpportunityTriggerHandlerPRMTest{
		@testSetup static void createTestData(){
		NCP_CustomerCommunitySetting__c cs = new NCP_CustomerCommunitySetting__c();
		cs.Name = 'Default';
		cs.Customer_Account__c = 'Customer - test';
		cs.Customer_Account_Number__c = '12345';
		cs.Customer_User_Profile__c = 'Customers';
		insert cs;
	}
		private static List<OpportunityTeamMember> opptyTeamMemberList = new List<OpportunityTeamMember>();	
		private static List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
		private static List<Schema.Document> docList = new List<Schema.Document>();
		private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.DIRECT_RECORD_TYPE).getRecordTypeId();
		private static Id oppIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.INDIRECT_RECORD_TYPE).getRecordTypeId();
		
		static testMethod void OpportunityTriggerHandlerPRM_afterUpdateOppty(){
	
			list <File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new list <File_Sharing_Custom_Setting__c>();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
	RecordType rt = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND Name = : GlobalConstants.CREATE_INDIRECT_SALES_OPPORTUNITY];
	
	
	List<Opportunity> opplist= new List<Opportunity>();
	List<Opportunity> updatelist=new List<Opportunity>();
	List<Opportunity> Emptylist=new List<Opportunity>();
	user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
	insert userCreation;
	system.runAs(userCreation){
			
	Account accountCreation = TestDataFactory.createAccount(1)[0];
	accountCreation.AccountNumber = '1234'; 
	database.insert(accountCreation);
	Opportunity optyCreation = TestDataFactory.OpportunityCreation(3,accountCreation)[0];
	optyCreation.Probability = 22;
		
	database.insert(optyCreation);	
			opplist.add(optyCreation);
		 
	  Test.StartTest();
			List<contact> lstCont = new List<contact>();
	Contact con = new Contact(lastName=PRMGlobalConstants.Testtext,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail1);
	lstCont.add(con);
	
	Database.insert(lstCont); 
	
	Partner_Company__c pc = new Partner_Company__c();
	pc.Partner_Name__c = accountCreation.id;
	pc.Country_Headquarters__c = 'Albania';
	pc.Partner_Type__c = 'Distributor';
	Database.insert(pc);
			
	Opportunity optyCreation1 = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
	optyCreation1.PRMPartner_User_Name__c = userCreation.Id;
	optyCreation1.Lead_Type__c = PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION;
	optyCreation1.PRMSales_Support_Requested__c = true;
	optyCreation1.PRMOther_Support_Requested__c = true;
	optyCreation1.PRMPricing_Support_Requested__c = true;
	optyCreation1.PRMTechnical_Support_Requested__c = true;
	optyCreation1.PRMSales_Support_Status__c   =null;
	optyCreation1.PRMOther_Support_Status__c	= null;
	optyCreation1.PRMDeal_Origination_Discount_Status__c = 'Approved with DOD';
	optyCreation1.RecordTypeId = rt.Id;
	optyCreation1.Account_Role__c='Alliance Partner';
	optyCreation1.End_Customer_Information__c='Multiple End Customer';
	optyCreation1.Multiple_or_Unknown_EC_Market_Segment__c='CABLE';
	optyCreation1.Multiple_or_Unknown_EC_Activity_Sector__c='CABL - CABLE OPERATORS';
	optyCreation1.Multiple_or_Unknown_EC_Country__c='Afghanistan';
	database.insert(optyCreation1);
	 
	List<Id> lstId = new List<Id>();
	
		List<Lead> leadList = new  List<Lead>();
		leadList = TestDataFactory.createLead(1);
		leadList[0].RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION_DEV).getRecordTypeId();
		leadList[0].email = 'test.junrel@lead.com';
		leadList[0].status = 'Rejected'; 
		leadList[0].Rejection_Status_For_Approval__c = 'Pending';
		leadList[0].Distributor_Partner_Company__c = pc.Id;
		leadList[0].OwnerId = userCreation.id;
		leadList[0].Bus_Ops_Approver__c = userCreation.id;
	leadList[0].Distributor_Account__c = accountCreation.id;
	leadList[0].IsConverted=true;
			leadList[0].ConvertedAccountId=accountCreation.Id;
			leadList[0].convertedOpportunityId=optyCreation1.id;
		insert leadList;
	  
	optyCreation1.PRMDeal_Origination_Discount_Status__c = 'Approved with DOD Deferred';
		optyCreation1.Deal_Registration__c = leadList[0].Deal_Registration_Auto_Number__c;
	optyCreation1.PRMSales_Support_Status__c = PRMGlobalConstants.Accepted;   
	optyCreation1.PRMOther_Support_Status__c = PRMGlobalConstants.Declined;
	database.update(optyCreation1);
	 Test.stopTest();
	
			}
			
		}
		
		static testMethod void OpportunityTriggerHandlerPRM_afterUpdate(){
		 list <File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new list <File_Sharing_Custom_Setting__c> ();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
	
	RecordType rt = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND Name = : GlobalConstants.CREATE_INDIRECT_SALES_OPPORTUNITY];
	
	
	List<Opportunity> opplist= new List<Opportunity>();
	List<Opportunity> updatelist=new List<Opportunity>();
	List<Opportunity> Emptylist=new List<Opportunity>();
	user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
	user userCreation1 = TestDataFactory.userCreation(1,'Nokia Sales Profile')[0];
	insert userCreation;
	system.runAs(userCreation){
	
	Account accountCreation = TestDataFactory.createAccount(1)[0];
	accountCreation.AccountNumber = '1234';
	database.insert(accountCreation);
	Opportunity optyCreation = TestDataFactory.OpportunityCreation(3,accountCreation)[0];
	optyCreation.Probability = 22;
	database.insert(optyCreation);
	opplist.add(optyCreation);
	
	Test.StartTest();
	 Map<Id,opportunity> opnewmap = new Map<Id,opportunity>();
	 opnewmap.put(optyCreation.id, optyCreation);
	 OpportunityTriggerHelperPRM.indirectToDirectUpdate(opnewmap);
	List<contact> lstCont = new List<contact>();
	Contact con = new Contact(lastName=PRMGlobalConstants.Testtext,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail1);
	
	lstCont.add(con);
			
	
	Database.insert(lstCont);
	
	Partner_Company__c pc = new Partner_Company__c();
	pc.Partner_Name__c = accountCreation.id;
	pc.Country_Headquarters__c = 'Albania';
	pc.Partner_Type__c = 'Indirect Reseller';
	Database.insert(pc);
		 
	Opportunity optyCreation1 = TestDataFactory.OpportunityCreation(3,accountCreation)[0];
	
	optyCreation1.Indirect_Reseller_Company__c = pc.Id;
	optyCreation1.PRMPartner_User_Name__c = userCreation.Id;
	optyCreation1.Lead_Type__c = PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION;
	optyCreation1.PRMSales_Support_Requested__c = true;
	optyCreation1.PRMOther_Support_Requested__c = true;
	optyCreation1.PRMPricing_Support_Requested__c = true;
	optyCreation1.PRMTechnical_Support_Requested__c = true;
	optyCreation1.PRMSales_Support_Status__c   =null;
	optyCreation1.PRMOther_Support_Status__c	= null;
	optyCreation1.RecordTypeId = rt.Id;
	optyCreation1.End_Customer_Information__c='Multiple End Customer';
	optyCreation1.Account_Role__c='Alliance Partner';
	optyCreation1.Multiple_or_Unknown_EC_Market_Segment__c='CABLE';
	optyCreation1.Multiple_or_Unknown_EC_Activity_Sector__c='CABL - CABLE OPERATORS';
	optyCreation1.Multiple_or_Unknown_EC_Country__c='Afghanistan';
	database.insert(optyCreation1);
	 
		List<Id> lstId = new List<Id>();
		
	OpportunityTeamMember otm = new OpportunityTeamMember(); 
	otm  = TestDataFactory.optyTeamMemberCreation(1,userCreation,optyCreation1)[0];
	opptyTeamMemberList.add(otm);
	database.insert(opptyTeamMemberList);
		
	optyCreation1.PRMPartner_User_Name__c = userCreation1.Id;
	optyCreation1.PRMSales_Support_Status__c   = PRMGlobalConstants.Declined;
	optyCreation1.PRMOther_Support_Status__c	= PRMGlobalConstants.Accepted;
	database.update(optyCreation1);
	 Test.stopTest();
			}
			
		}
	static testMethod void OpportunityTriggerHandlerPRM_afterUpdate2(){
	 list <File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new list <File_Sharing_Custom_Setting__c> ();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
	
	RecordType rt = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND Name = : GlobalConstants.CREATE_INDIRECT_SALES_OPPORTUNITY];
	
	
	List<Opportunity> opplist= new List<Opportunity>();
	List<Opportunity> updatelist=new List<Opportunity>();
	List<Opportunity> Emptylist=new List<Opportunity>();
	user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
	insert userCreation;
	system.runAs(userCreation){
	
	Account accountCreation = TestDataFactory.createAccount(1)[0];
	accountCreation.AccountNumber = '1234';
	database.insert(accountCreation);
	Opportunity optyCreation = TestDataFactory.OpportunityCreation(3,accountCreation)[0];
	optyCreation.Probability = 22;
	database.insert(optyCreation);
	opplist.add(optyCreation);
	
	
	Test.StartTest();
	List<contact> lstCont = new List<contact>();
	Contact con = new Contact(lastName=PRMGlobalConstants.Testtext,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail1);
	
	lstCont.add(con);
			
	
	Database.insert(lstCont);
	
	Partner_Company__c pc = new Partner_Company__c();
	pc.Partner_Name__c = accountCreation.id;
	pc.Country_Headquarters__c = 'Albania';
	pc.Partner_Type__c = 'Indirect Reseller';
	Database.insert(pc);
	
	  
	Opportunity optyCreation1 = TestDataFactory.OpportunityCreation(3,accountCreation)[0];
	
	optyCreation1.Indirect_Reseller_Company__c = pc.Id;
	optyCreation1.PRMPartner_User_Name__c = userCreation.Id;
	optyCreation1.Lead_Type__c = PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION;
	optyCreation1.PRMSales_Support_Requested__c = true;
	optyCreation1.PRMOther_Support_Requested__c = true;
	optyCreation1.PRMPricing_Support_Requested__c = true;
	optyCreation1.PRMTechnical_Support_Requested__c = true;
	optyCreation1.PRMPricing_Support_Status__c   =null;
	optyCreation1.PRMTechnical_Support_Status__c	= null;
	optyCreation1.End_Customer_Information__c='Multiple End Customer';
	optyCreation1.RecordTypeId = rt.Id;
	optyCreation1.Account_Role__c='Alliance Partner';
	optyCreation1.Multiple_or_Unknown_EC_Market_Segment__c='CABLE';
	optyCreation1.Multiple_or_Unknown_EC_Activity_Sector__c='CABL - CABLE OPERATORS';
	optyCreation1.Multiple_or_Unknown_EC_Country__c='Afghanistan';
	database.insert(optyCreation1);
	  
		List<Id> lstId = new List<Id>();
		
	OpportunityTeamMember otm = new OpportunityTeamMember(); 
	otm  = TestDataFactory.optyTeamMemberCreation(1,userCreation,optyCreation1)[0];
	opptyTeamMemberList.add(otm);
	database.insert(opptyTeamMemberList);
		
	optyCreation1.PRMPricing_Support_Status__c   =PRMGlobalConstants.Declined;
	optyCreation1.PRMTechnical_Support_Status__c	= PRMGlobalConstants.Accepted;
	optyCreation1.Pricing_Support_Declined_Reason__c = 'Other';
	database.update(optyCreation1);
	 Test.stopTest();
			}
			
		}
	static testMethod void OpportunityTriggerHandlerPRM_afterUpdate3(){
	 list <File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new list <File_Sharing_Custom_Setting__c> ();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
	
	RecordType rt = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND Name = : GlobalConstants.CREATE_INDIRECT_SALES_OPPORTUNITY];
	
	
	List<Opportunity> opplist= new List<Opportunity>();
	List<Opportunity> updatelist=new List<Opportunity>();
	List<Opportunity> Emptylist=new List<Opportunity>();
	user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
	insert userCreation;
	system.runAs(userCreation){
	
	Account accountCreation = TestDataFactory.createAccount(1)[0];
	accountCreation.AccountNumber = '1234';
	database.insert(accountCreation);
	Opportunity optyCreation = TestDataFactory.OpportunityCreation(3,accountCreation)[0];
	optyCreation.Probability = 22;
	database.insert(optyCreation);
	opplist.add(optyCreation);
	
	 Test.StartTest();
	
	List<contact> lstCont = new List<contact>();
	Contact con = new Contact(lastName=PRMGlobalConstants.Testtext,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail1);
	
	lstCont.add(con);
			
	
	Database.insert(lstCont);
	
	Partner_Company__c pc = new Partner_Company__c();
	pc.Partner_Name__c = accountCreation.id;
	pc.Country_Headquarters__c = 'Albania';
	pc.Partner_Type__c = 'Indirect Reseller';
	Database.insert(pc);
		 
	Opportunity optyCreation1 = TestDataFactory.OpportunityCreation(3,accountCreation)[0];
	
	optyCreation1.Indirect_Reseller_Company__c = pc.Id;
	optyCreation1.PRMPartner_User_Name__c = userCreation.Id;
	optyCreation1.Lead_Type__c = PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION;
	optyCreation1.PRMSales_Support_Requested__c = true;
	optyCreation1.PRMOther_Support_Requested__c = true;
	optyCreation1.PRMPricing_Support_Requested__c = true;
	optyCreation1.PRMTechnical_Support_Requested__c = true;
	optyCreation1.PRMPricing_Support_Status__c   =null;
	optyCreation1.PRMTechnical_Support_Status__c	= null;
	optyCreation1.RecordTypeId = rt.Id;
	optyCreation1.Account_Role__c='Alliance Partner';
	optyCreation1.End_Customer_Information__c='Multiple End Customer';
	optyCreation1.Multiple_or_Unknown_EC_Market_Segment__c='CABLE';
	optyCreation1.Multiple_or_Unknown_EC_Activity_Sector__c='CABL - CABLE OPERATORS';
	optyCreation1.Multiple_or_Unknown_EC_Country__c='Afghanistan';
	database.insert(optyCreation1);
		
		List<Id> lstId = new List<Id>();
		
	OpportunityTeamMember otm = new OpportunityTeamMember(); 
	otm  = TestDataFactory.optyTeamMemberCreation(1,userCreation,optyCreation1)[0];
	opptyTeamMemberList.add(otm);
	database.insert(opptyTeamMemberList);
		
	optyCreation1.PRMPricing_Support_Status__c   =PRMGlobalConstants.Accepted;
	optyCreation1.PRMTechnical_Support_Status__c	= PRMGlobalConstants.Declined;
	optyCreation1.Technical_Support_Declined_Reason__c = 'Other';
	database.update(optyCreation1);
	 Test.stopTest();
			}
			
		}
	static testMethod void OpportunityTriggerHandlerPRM_afterUpdate4(){
	  
	 list <File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new list <File_Sharing_Custom_Setting__c> ();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
	
	RecordType rt = [SELECT Id FROM RecordType WHERE sObjectType = 'Opportunity' AND Name = : GlobalConstants.CREATE_INDIRECT_SALES_OPPORTUNITY];
	
	
	List<Opportunity> opplist= new List<Opportunity>();
	List<Opportunity> updatelist=new List<Opportunity>();
	List<Opportunity> Emptylist=new List<Opportunity>();
	user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
	insert userCreation;
	system.runAs(userCreation){
	
	Account accountCreation = TestDataFactory.createAccount(1)[0];
	accountCreation.AccountNumber = '1234';
	database.insert(accountCreation);
	Opportunity optyCreation = TestDataFactory.OpportunityCreation(3,accountCreation)[0];
	optyCreation.Probability = 22;
	database.insert(optyCreation);
	opplist.add(optyCreation);
	
	  Test.StartTest();
	
	List<contact> lstCont = new List<contact>();
	Contact con = new Contact(lastName=PRMGlobalConstants.Testtext,AccountId=accountCreation.id,Email=PRMGlobalConstants.TestEmail1);
	
	lstCont.add(con);
	
	Database.insert(lstCont);
	
	Partner_Company__c pc = new Partner_Company__c();
	pc.Partner_Name__c = accountCreation.id;
	pc.Country_Headquarters__c = 'Albania';
	pc.Partner_Type__c = 'Indirect Reseller';
	Database.insert(pc);
	
	Opportunity optyCreation1 = TestDataFactory.OpportunityCreation(3,accountCreation)[0];
	
	optyCreation1.Indirect_Reseller_Company__c = pc.Id;
	optyCreation1.PRMPartner_User_Name__c = userCreation.Id;
	optyCreation1.Lead_Type__c = PRMGlobalConstants.INDIRECT_DEAL_REGISTRATION;
	optyCreation1.PRMSales_Support_Requested__c = true;
	
	optyCreation1.PRMSales_Support_Status__c = null;
	optyCreation1.RecordTypeId = rt.Id;
	optyCreation1.PRMRBC_Direct_Sales_Approver__c = userCreation.Id;
	optyCreation1.PRMPartner_User_Name__c = userCreation.Id;
	optyCreation1.End_Customer_Information__c='Multiple End Customer';
	optyCreation1.Account_Role__c='Alliance Partner';
	optyCreation1.Multiple_or_Unknown_EC_Market_Segment__c='CABLE';
	optyCreation1.Multiple_or_Unknown_EC_Activity_Sector__c='CABL - CABLE OPERATORS';
	optyCreation1.Multiple_or_Unknown_EC_Country__c='Afghanistan';
	database.insert(optyCreation1);
	
	optyCreation1.Indirect_Reseller_Company__c = null;
	optyCreation1.PRMSales_Support_Status__c = PRMGlobalConstants.Declined;
	optyCreation1.PRMOther_Support_Requested__c = true;
	optyCreation1.PRMPricing_Support_Requested__c = true;
	optyCreation1.PRMTechnical_Support_Requested__c = true;
	optyCreation1.Technical_Support_Declined_Reason__c = 'Other';
	database.update(optyCreation1);
	
	 Test.StopTest();
			}
			
		}
		
		static testMethod void OpportunityTriggerHandlerPRM_Exceptionhandling(){
	  
	 Test.StartTest();
			Opportunity opp = new Opportunity();
			List<OpportunityTeamMember> otm = new List<OpportunityTeamMember>();
			Map<Id,opportunity> opnewmap = new Map<Id,opportunity>();
	OpportunityTriggerHelperPRM.sendNotificationOnApproved(opp);
	OpportunityTriggerHelperPRM.shareOpptyWithRBCApprover(opp);
			OpportunityTriggerHelperPRM.sendNotificationOnDeclined(opp);
	OpportunityTriggerHelperPRM.partnerOpportunityTeam(opp);
	OpportunityTriggerHelperPRM.deletePartnerFromOTM(otm,opp,opp);
	OpportunityTriggerHelperPRM.indirectToDirectUpdate(opnewmap);
	 Test.StopTest();
			}
			
			
	}