/****************************************
* Name : OpportunitytriggerHelperTest 
* Author : Accenture
* Description : Test class for CloneOfferTeam and OpportunityTriggerHelper
*****************************************/
@istest
private with sharing class OpportunityTriggerHelperTest{
	private static List<OpportunityTeamMember> opptyTeamMemberList = new List<OpportunityTeamMember>(); 
	private static List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
	private static List<Schema.Document> docList = new List<Schema.Document>();
	private static Id oppDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_DIRECT_SALES_OPPORTUNITY).getRecordTypeId();
	private static Id oppReadOnlyDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.READONLYDIRECT).getRecordTypeId();
	private static Id oppIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.CREATE_INDIRECT_SALES_OPPORTUNITY).getRecordTypeId();
	private static Id readOnlyIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.READONLYINDIRECT).getRecordTypeId();
	private static List<user> userList = new List<user>();
	private static List<Account> accList = new List<Account>();
	private static List<Opportunity> optyList = new List<Opportunity>();
	private static List<Competitor__c> compList = new List<Competitor__c>();
	private static final Id PSR_ReadOnlyRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.PRESALESRISKOPPORTUNITY_READONLY).getRecordTypeId();
	private static final Id PSR_EditRecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.PRESALESRISKOPPORTUNITY).getRecordTypeId();  
	private static Id upsellDealRecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Upsell Deal').getRecordTypeId();
	private static final Id inDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.INDIRECT_OPPTY).getRecordTypeId();
	
	  /******************************
*Method Name: CurrenychangeTest
*Description: Test Method to cover OpportunityTriggerHelper class
********************************/
	
	static testMethod void CurrenychangeTest(){
		List<Opportunity> opplist= new List<Opportunity>();
		List<Opportunity> updatelist=new List<Opportunity>();
		List<Opportunity> Emptylist=new List<Opportunity>();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		system.runAs(userCreation){
			test.startTest();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234'; 
			database.insert(accountCreation);
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(3,accountCreation)[0];
			optyCreation.Probability = 22;
			database.insert(optyCreation);
			opplist.add(optyCreation);
			
			Opportunity optyCreation1 = TestDataFactory.OpportunityCreation(3,accountCreation)[0];
			optyCreation1.Sales_Outcome__c='Obsolete';
			optyCreation1.Sales_Outcome_Reason__c = 'Commercial';
			database.insert(optyCreation1);
			updatelist.add(optyCreation1);
			OpportunityTriggerHelper.Currenychange(new Map<Id,SObject>(updatelist).keySet());
			OpportunityTriggerHelper.Currenychange(new Map<Id,SObject>(updatelist).keySet());
			OpportunityTriggerHelper.MassupdateonOIFLines(new Map<Id,SObject>(updatelist).keySet());
			OpportunityTriggerHelper.MassupdateonOIFLines(null);
			OpportunityTriggerHelper.Currenychange(NULL);
			test.stoptest();
			
		}
		
	}	
	/******************************
*Method Name: CurrencyUpdateTest
*Description: Test Method to cover OpportunityTriggerHelper class
********************************/
	
	static testMethod void CurrencyUpdateTest(){
		Apttus_Approval__Approval_Request__c currentApprovalRequest;
		List<Apttus_Approval__Approval_Request__c> approvalrequests=new List<Apttus_Approval__Approval_Request__c>();
		
		List<User> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		//user userCreation1 = TestDataFactory.userCreation(1,'System Administrator')[0];
		//insert userCreation1;
		userCreation[0].DelegatedApproverId = userCreation[1].id;
		database.update(userCreation[0]);
		system.runAs(userCreation[0]){
			
			List<Opportunity> optylist3 = new List<Opportunity>();
			Map<id,Opportunity> opptyMap = new Map<id,Opportunity>();
			List<Dated_Exchange_Rates__c> newExchange=new List<Dated_Exchange_Rates__c>();
			newExchange=TestDataFactory.datedExchnageRateCreation(4);
			database.insert(newExchange);
			
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '301301301'; 
			database.insert(accountCreation);
			List<Opportunity> optyCreation = new List<Opportunity>();
			Opportunity optyCreation1=TestDataFactory.OpportunityCreation(3,accountCreation)[0];
			//database.insert(optyCreation1);
			optyCreation.add(optyCreation1);
			optyCreation.get(0).CurrencyIsoCode='USD';
			optyCreation.get(0).Amount=100;
			database.insert(optyCreation1);
			test.startTest();
			optyCreation.add(optyCreation1);
			
			
			List<Opportunity> optylist1 = new List<Opportunity>();
			Opportunity optyCreation2=TestDataFactory.OpportunityCreation(2,accountCreation)[0]; 
			database.insert(optyCreation2);
			optylist1.add(optyCreation2);
			for(Opportunity oppty:optylist1){
	opptyMap.put(oppty.id, oppty);
	opptyMap.get(oppty.id).Facilitator_Delegate_1__c = userCreation[0].id;
	opptyMap.get(oppty.id).Facilitator_Delegate_2__c = userCreation[1].id;
	opptyMap.get(oppty.id).Facilitator_Backup__c = userCreation[0].id;
	opptyMap.get(oppty.id).NF_Facilitator_User__c  = userCreation[0].id;
			}
			opptyTeamMemberList = TestDataFactory.optyTeamMemberCreation(1,userCreation[0],optylist1[0]);
			database.insert(opptyTeamMemberList);
			Apttus_Approval__Approval_Request__c approvalrequest = 
	NF_TestDataFactory.createApprovalRequest('Not Submitted', 'User', 'Test Object',string.valueOf(optyCreation2.Id), True, True, userCreation[1].Name,string.valueOf(userCreation[1].Id), 'Sub step Name Test');
			approvalrequest.Apttus_Approval__DelegateApproverIds__c=userCreation[1].id;
			approvalrequest.Apttus_Approval__Step_Name__c='G2';
			approvalrequests.add(approvalrequest);
			database.insert(approvalrequests);
			OpportunityTriggerHelper.convertionrateupdate(optyCreation);
			OpportunityTriggerHelper.convertionrateupdate(optylist);
			OpportunityTriggerHelper.convertionrateupdate(optylist3);
			OpportunityTriggerHelper.convertionrateupdate(null);
			OpportunityTriggerHelper.createOpportunityTeamMembers(opptyMap);
			//OpportunityTriggerHelper.NotifyOpportunityRelatedUsers(opptyMap);
			OpportunityTriggerHelper.UpdateUserinformation(optylist);
			test.stoptest();
		}
	}
	
	
	/******************************
*Method Name: setAluasTrueTest
*Description: Test Method to cover setAluasTrue method from OpportunityTriggerHelper class
********************************/
	static testMethod void setAluasTrueTest(){
		List<Account> accList1 = new List<Account>();
		List<Opportunity> opptyList = new List<Opportunity>();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		//RecordType rt = [select id from RecordType where SobjectType='Account' and Name='Customer' Limit 1];
		system.runAs(userCreation){
			test.startTest();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			//creating a sample custom setting, positive scenerio
			ALUI__c aluCustomSetting = new ALUI__c();
			aluCustomSetting.name = '17';
			aluCustomSetting.country__c = 'Benin';
			database.insert(aluCustomSetting);
			//creating account with country same as custom setting
			List<Account> accountCreation = TestDataFactory.createAccount(2);
			//Positive scenerio
			accountCreation[0].Market__c = 'Market Middle East and Africa';
			accountCreation[0].Country__c = 'Benin';
			//accountCreation[0].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
			//Negative scenerio
			accountCreation[1].Market__c = 'Market Middle East and Africa';
			accountCreation[1].Country__c = 'Angola';
			accList1.add(accountCreation[0]);
			accList1.add(accountCreation[1]);
			database.insert(accList1);
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation[0])[0];
			Opportunity optyCreation1 = TestDataFactory.OpportunityCreation(1,accountCreation[1])[0];
			opptyList.add(optyCreation);
			opptyList.add(optyCreation1);
			database.insert(opptyList);
			system.assertEquals(aluCustomSetting.country__c,accountCreation[0].Country__c);
			OpportunityTriggerHelper.setAluasTrue(null);
			Test.stopTest();
		}
	}
	/******************************
*Method Name: probabilityUpdateTest
*Description: Test Method to cover probabilityUpdate method from OpportunityTriggerHelper class
********************************/
	static testMethod void probabilityUpdateTest(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		system.runAs(userCreation){
			Test.startTest();
			Map < Id, Opportunity > opptyMap = new Map < Id, Opportunity > ();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			//List<Account> accList7 = new List<Account>();
			List<Account> accountCreation = TestDataFactory.createAccount(2);
			database.insert(accountCreation);
			system.debug('accountCreation>>'+accountCreation);
			Map<ID, Opportunity>opptyOldMap = new Map<ID, Opportunity>();			
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation[0]);
			optyCreation[0].StageName = 'Closed - Obsolete';
			//optyCreation[0].Phase_Status__c = 'Planned';
			optyCreation[0].Phase_Status__c = GlobalConstants.PHASE_STATUS;
			database.insert(optyCreation);
	
			List<Opportunity> optyCreation1 = TestDataFactory.OpportunityCreation(1,accountCreation[1]);
			optyCreation1[0].StageName = 'Identify Opportunity';
			optyCreation1[0].Phase_Status__c = 'Planned';
			database.insert(optyCreation1);
	opptyOldMap.put(optyCreation[0].Id,optyCreation1[0]);
			//Changing account
			optyCreation[0].AccountId = accountCreation[1].id;
			database.update(optyCreation);  
			test.stopTest();
			//createChatterPost Method
	//  opportunityTriggerHelper.createChatterPost(new map<Id,Opportunity>(optyCreation),opptyOldMap);
			//populateG5ContractApprovalDate Method
			opportunityTriggerHelper.populateG5ContractApprovalDate(optyCreation,opptyOldMap);

		}
	}
   
	
	/******************************
*Method Name: updateOfferswhenG4approvaldateIsUpdatedTest
*Description: Test Method to cover updateOfferswhenG4approvaldateIsUpdated method from OpportunityTriggerHelper class
********************************/
	static testMethod void updateOfferswhenG4approvaldateIsUpdatedTest(){
		Map < ID, Opportunity > opptyMap = new Map < ID, Opportunity >();
		Map < ID, List < Offer__c >> oppOfferListMap = new Map < ID, List < Offer__c >> ();
		List<Offer__c> offerList = new List<Offer__c>();
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		system.runAs(userCreation){
			//Creating Account
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			//Creating Opportunity
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			optyCreation.G4_Approval_Date__c = system.today();
			database.insert(optyCreation);
			Test.startTest();
			//Creating Offer
			Offer__c offerCreation = TestDataFactory.OfferCreation(1,optyCreation)[0];
			offerCreation.Expected_LoA_G4_Approval_Level__c = 'A';
			offerCreation.ActiveOffer__c = True;
			offerList.add(offerCreation);
			insert offerList;
			oppOfferListMap.put(offerCreation.Opportunity__c,offerList);
			opptyMap.put(offerCreation.Opportunity__c, optyCreation);
			//Calling the class
			// OpportunityTriggerHelper.updateOfferswhenG4approvaldateIsUpdated(null,null);
			Test.stopTest();
		}
	}
   
	static testMethod void afterUpdateOppnotifyHSSERiskCountryDirect(){
		Test.startTest();
	   /* SendTo__c SendToCS = new SendTo__c();
		SendToCS.Name = 'avnika.goyal@accenture.com';
		database.insert(SendToCS);
	   
		Risk_Country__c riskCountry = new Risk_Country__c();
		riskCountry.Name = 'India';
		riskCountry.ExtremeRisk__c = true;
		riskCountry.HighRisk__c = false;
		riskCountry.LowRisk__c = false;
		database.insert(riskCountry);
		
		List<user> userList1 = new List<user>();
		userList1 = TestDataFactory.userCreation(1,'System Administrator') ;
		database.insert(userList1);
		system.runas(userList1[0]){
			
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			List<Account> accList2 = new List<Account>();
			List<Opportunity> optyList1 = new List<Opportunity>();
			List<OpportunityTeamMember> optyTeamMember = new List<OpportunityTeamMember>();
			
			//Create Account
			accList2 = TestDataFactory.createAccount(1);
			accList2[0].CountryNameISO2__c ='IN';
			database.insert(accList2);
			
			//Create Opty
			optyList1 = TestDataFactory.OpportunityCreation(3,accList2[0]);
			optyList1[0].RecordTypeId= oppDirectRecordTypeId;
			optyList1[0].country__C = 'India';
			optyList1[0].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyList1[0].Phase_Status__c = 'Opportunity in Progress';
			database.insert(optyList1);
			//Create Team Member
			optyTeamMember = TestDataFactory.optyTeamMemberCreation(1,userList1[0],optyList1[0]);
			optyTeamMember[0].TeamMemberRole =  GlobalConstants.PROJECTEXECUTIONOWNER;
			database.insert(optyTeamMember);
			//Update Opty
			optyList1[0].StageName = GlobalConstants.CREATE_OFFER;
			optyList1[0].Phase_Status__c  = 'Offer in Progress';
			database.update(optyList1);*/
			//OpportunityTriggerHelper.notifyHSSERiskCountry(optyList1);
			OpportunityTriggerHelper.sendEmail(null,null,null);
			Test.stopTest();
		// }
	}
	static testMethod void afterUpdateOppnotifyHSSERiskCountryDirect2(){
		Test.startTest();
	 /*   SendTo__c SendToCS = new SendTo__c();
		SendToCS.Name = 'avnika.goyal@accenture.com';
		database.insert(SendToCS);
	   
		Risk_Country__c riskCountry = new Risk_Country__c();
		riskCountry.Name = 'India';
		riskCountry.ExtremeRisk__c = true;
		riskCountry.HighRisk__c = false;
		riskCountry.LowRisk__c = false;
		database.insert(riskCountry); */
		
		List<user> userList1 = new List<user>();
		userList1 = TestDataFactory.userCreation(1,'System Administrator') ;
		database.insert(userList1);
		system.runas(userList1[0]){
			
		/*	fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);*/
			List<Account> accList2 = new List<Account>();
			List<Opportunity> optyList1 = new List<Opportunity>();
			List<OpportunityTeamMember> optyTeamMember = new List<OpportunityTeamMember>();
			
			//Create Account
			accList2 = TestDataFactory.createAccount(1);
			accList2[0].CountryNameISO2__c ='IN';
			database.insert(accList2);
			
			//Create Opty
			optyList1 = TestDataFactory.OpportunityCreation(3,accList2[0]);
			optyList1[0].RecordTypeId= oppDirectRecordTypeId;
			optyList1[0].country__C = 'India';
		//	optyList1[0].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
		//	optyList1[0].Phase_Status__c = 'Opportunity in Progress';
			optyList1[0].StageName = GlobalConstants.CREATE_OFFER;
			optyList1[0].Phase_Status__c  = 'Offer in Progress';
			database.insert(optyList1);
			//Create Team Member
			optyTeamMember = TestDataFactory.optyTeamMemberCreation(1,userList1[0],optyList1[0]);
			optyTeamMember[0].TeamMemberRole =  GlobalConstants.PROJECTEXECUTIONOWNER;
			database.insert(optyTeamMember);
			//Update Opty
		/*	optyList1[0].StageName = GlobalConstants.CREATE_OFFER;
			optyList1[0].Phase_Status__c  = 'Offer in Progress';
			database.update(optyList1);*/
			OpportunityTriggerHelper.notifyHSSERiskCountry(optyList1);
			//OpportunityTriggerHelper.sendEmail(null,null,null);
			Test.stopTest();
		}
	}
	static testMethod void afterUpdateOppnotifyHSSERiskCountryDirectWoCMD(){
		Test.startTest();
	   /* SendTo__c SendToCS = new SendTo__c();
		SendToCS.Name = 'avnika.goyal@accenture.com';
		database.insert(SendToCS);
		Risk_Country__c riskCountry = new Risk_Country__c();
		riskCountry.Name = 'India';
		riskCountry.ExtremeRisk__c = true;
		riskCountry.HighRisk__c = false;
		riskCountry.LowRisk__c = false;
		database.insert(riskCountry);*/
		
		List<user> userList2 = new List<user>();
		userList2 = TestDataFactory.userCreation(1,'System Administrator') ;
		database.insert(userList2);
		system.runas(userList2[0]){
			
			/*fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			//Create Document
			doclist = TestDataFactory.getDocument();
			database.insert(doclist);*/
			
			List<Account> accList3 = new List<Account>();
			List<Opportunity> optyList2 = new List<Opportunity>();
			List<OpportunityTeamMember> optyTeamMember = new List<OpportunityTeamMember>();
			//Create Account
			accList3 = TestDataFactory.createAccount(1);
			database.insert(accList3);
			//Create Opty
			optyList2 = TestDataFactory.OpportunityCreation(3,accList3[0]);
			optyList2[0].RecordTypeId= oppDirectRecordTypeId ;
			optyList2[0].country__C = 'India';
			optyList2[0].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyList2[0].Phase_Status__c = 'Opportunity in Progress';
			database.insert(optyList2);
			//Insert OptyTeamMember
			optyTeamMember = TestDataFactory.optyTeamMemberCreation(1,userList2[0],optyList2[0]);
			optyTeamMember[0].TeamMemberRole = GlobalConstants.PROJECTEXECUTIONOWNER;
			database.insert(optyTeamMember);
			
			optyList2[0].StageName = GlobalConstants.CREATE_OFFER;
			optyList2[0].Phase_Status__c  = 'Offer in Progress';
			database.update(optyList2);
			OpportunityTriggerHelper.notifyHSSERiskCountry(optyList2);
			//OpportunityTriggerHelper.sendEmail(null,null,null);
			test.StopTest();
		}
	}
	static testMethod void afterUpdateOppnotifyHSSERiskCountryIndirect(){
		SendTo__c SendToCS = new SendTo__c();
		SendToCS.Name = 'avnika.goyal@accenture.com';
		database.insert(SendToCS);
		Risk_Country__c riskCountry = new Risk_Country__c();
		riskCountry.Name = 'India';
		riskCountry.ExtremeRisk__c = true;
		riskCountry.HighRisk__c = false;
		riskCountry.LowRisk__c = false;
		database.insert(riskCountry);		
		List<user> userList3 = new List<user>();
		userList3 = TestDataFactory.userCreation(1,'System Administrator') ;	
		database.insert(userList3);
		
		system.runas(userList3[0]){
			Test.startTest();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			//Insert Document
			doclist = TestDataFactory.getDocument();
			database.insert(doclist);
			
			
			//Insert Account
			List<Account> accList4 = new List<Account>();
			List<Opportunity> optyList3 = new List<Opportunity>();
			accList4 = TestDataFactory.createAccount(1);
			database.insert(accList4);
			//Insert Opty
			optyList3 = TestDataFactory.OpportunityCreation(3,accList4[0]);
			optyList3[1].RecordTypeId= oppIndirectRecordTypeId ;
			optyList3[1].Country__c = 'India';
			optyList3[1].G3_Approval_Date__c = system.now();
			optyList3[1].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyList3[1].Phase_Status__c = 'Opportunity in Progress';
			database.insert(optyList3);
			
			//Update Opty
			optyList3[1].StageName = GlobalConstants.CREATE_OFFER;
			optyList3[1].Phase_Status__c  = 'Offer in Progress';
			database.update(optyList3);
			OpportunityTriggerHelper.notifyHSSERiskCountry(optyList3);
			OpportunityTriggerHelper.notifyHSSERiskCountry(null);
			Test.stoptest();
		}
	}
	
	/*   static testMethod void setOffer_Submitted_To_Customer_DateTest(){
List<user> userList4 = new List<user>();
userList4 = TestDataFactory.userCreation(1,'System Administrator') ;
database.insert(userList4);
system.runas(userList4[0]){
List<Account> accList5 = new List<Account>();
List<Opportunity> optyList4 = new List<Opportunity>();
List<Offer__c> offerList= new List<Offer__c>();
accList5 = TestDataFactory.createAccount(1);
database.insert(accList5);
optyList4 = TestDataFactory.OpportunityCreation(3,accList5[0]);
optyList4[0].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
optyList4[0].Phase_Status__c = 'Opportunity in Progress';
database.insert(optyList4) ;
offerList =  TestDataFactory.OfferCreation(1,optyList4[0]);
offerList[0].Expected_LoA_G4_Approval_Level__c = 'A';
database.insert(offerList);
optyList4[0].StageName = GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE;
optyList4[0].Phase_Status__c = GlobalConstants.OFFERSUBMITTEDTOCUSTOMER;
database.update(optyList4);
//OpportunityTriggerHelper.setOffer_Submitted_To_Customer_Date(null,null);
}

}*/
	
	static testMethod void beforeInsertUpdateRecordTypeWhenPreSaleTypeIsOtherThanRSRO(){
		
		List<user> userList5 = new List<user>();
		userList5 = TestDataFactory.userCreation(1,'System Administrator') ;
		database.insert(userList5);
		system.runas(userList5[0]){
			test.startTest();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			
			List<Account> accList6 = new List<Account>();
			List<Opportunity> optyList5 = new List<Opportunity>();
			
			//Create Account
			accList6 = TestDataFactory.createAccount(1);
			database.insert(accList6);
			
			//Create Opty
			optyList5 = TestDataFactory.OpportunityCreation(3,accList6[0]);
			optyList5[0].RecordTypeId= oppDirectRecordTypeId ;
			optyList5[0].country__C = 'India';
			optyList5[0].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyList5[0].Phase_Status__c = 'Opportunity in Progress';
			database.insert(optyList5);
			Test.stopTest();
			
		}
	}
	
	/******************************
*Method Name: ValidateTest
*Description: Test Method to cover Validate method from OpportunityTriggerHelper class
********************************/
	/*static testMethod void ValidateTest_PTA_True(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;			
		system.runAs(userCreation){
			Test.startTest();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			list<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2,accountCreation);
			insert optyCreation;
			
			//Updating oppty with PTA= True and stage to'Handover (Prepare for Delivery)'
			optyCreation[0].PTA_Signed__c = TRUE;
			optyCreation[0].Reference_Opportunity__c = optyCreation[1].id;
			update optyCreation[0];
			
			Offer__c offerCreation = TestDataFactory.OfferCreation(1,optyCreation[0])[0];
			offerCreation.Expected_LoA_G4_Approval_Level__c = 'A';
			offerCreation.ActiveOffer__c = True;
			offerCreation.LOA_Bypass__c = GlobalConstants.NO_LOA;
			insert offerCreation;

			//Covering clone Opportunity Class
			CloneOpportunity.getCloneOpp(optyCreation[0].id);
			test.stopTest();
		}
	}*/
	
	static testMethod void validatevalidateRefOpptyAndPTASignedTest_PTA_False(){
		//Creating User
		User sysAdminUser = TestDataFactory.userCreation(1,'System Administrator')[0];
		System.runAs(sysAdminUser){
		List<user> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		insert accountCreation;
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		//Creating Opportunity
		list<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2,accountCreation);
		insert optyCreation;
		optyCreation[0].PTA_Signed__c = false;
		optyCreation[0].Reference_Opportunity__c = optyCreation[1].id;
		update optyCreation[0];
		system.runAs(userCreation[0]){
			//Craeting Account
			Test.startTest();
			//Updating opportunity with PTA= False and stage to 'Handover (Prepare for Delivery)'
			Offer__c offerCreation = TestDataFactory.OfferCreation(1,optyCreation[0])[0];
			offerCreation.Expected_LoA_G4_Approval_Level__c = 'A';
			offerCreation.ActiveOffer__c = true;
			offerCreation.LOA_Bypass__c = GlobalConstants.NO_LOA;
			offerCreation.Product_Only_Offer__c = true;
			insert offerCreation;
			
			optyCreation[0].StageName = 'Handover (Prepare for Delivery)';
			optyCreation[0].Phase_Status__c = 'PTA (PROJECT TARGET AGREEMENT) HANDOVER TO DELIVERY/OPERATIONS';
			update optyCreation[0];
			system.debug('optyCreation>>>'+optyCreation);
			//Offer creation with Product_Only_Offer__c = false and LOA Bypass as NO LOA 
			
			system.debug('offerCreation>>>'+offerCreation);
			//Updating oppty with PTA= false and stage to'Execute (Start Delivery)'
	  /*	  optyCreation[0].StageName = 'Execute (Start Delivery)';
			optyCreation[0].Phase_Status__c = 'In Execution';
			optyCreation[0].PTA_Signed__c = False;
			update optyCreation[0];
			//Covering clone Opportunity Class
			CloneOpportunity.getCloneOpp(optyCreation[0].id);*/
			test.stopTest();
		}
	  }
	}
	
	static testMethod void checkLEIsEmptyTest(){
		 user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		 insert userCreation;
		 system.runAs(userCreation){
			Test.startTest();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			list <Account> accountCreation = TestDataFactory.createAccount(2);
			insert accountCreation;
			accountCreation[1].ParentId = accountCreation[0].Id;
			update accountCreation[1];
			// Oppty Creation
			list <Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2,accountCreation[0]);
			optyCreation[0].StageName = 'Identify Opportunity';
			optyCreation[0].Phase_Status__c = 'Planned';
			optyCreation[0].RecordTypeId = oppIndirectRecordTypeId;
			optyCreation[0].Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;	
			optyCreation[0].Legal_Entity__c = accountCreation[1].Id;
			optyCreation[1].StageName = 'Identify Opportunity';
			optyCreation[1].Phase_Status__c = 'Planned';
			optyCreation[1].RecordTypeId = oppIndirectRecordTypeId;
			optyCreation[1].Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;
			optyCreation[1].Legal_Entity__c = accountCreation[1].Id;
			insert optyCreation;
			Map<Id,Opportunity> OldOptyMap = new Map<Id,Opportunity>();
			accountCreation[1].ParentId = null;
			update accountCreation[1];
			optyCreation[0].Legal_Entity__c = null;
			optyCreation[1].Legal_Entity__c = null;
			update optyCreation ;
			list <Opportunity> optyCreation1 = TestDataFactory.OpportunityCreation(2,accountCreation[0]);
			optyCreation1[0].StageName = 'Identify Opportunity';
			optyCreation1[0].Phase_Status__c = 'Planned';
			optyCreation1[0].RecordTypeId = oppIndirectRecordTypeId;
			optyCreation1[0].Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;	
			optyCreation1[0].Legal_Entity__c = accountCreation[1].Id;
			optyCreation1[1].StageName = 'Identify Opportunity';
			optyCreation1[1].Phase_Status__c = 'Planned';
			optyCreation1[1].RecordTypeId = oppIndirectRecordTypeId;
			optyCreation1[1].Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;
			optyCreation1[1].Legal_Entity__c = accountCreation[1].Id;
			OldOptyMap.put(optyCreation[0].id, optyCreation1[0]);
			OldOptyMap.put(optyCreation[1].id, optyCreation1[1]);
			
			Map<Id,Opportunity> newOptyMap = new Map<Id,Opportunity>(optyCreation);
			
			OpportunityTriggerHelper.checkLEIsEmpty(newOptyMap.values(),OldOptyMap);
			OpportunityTriggerHelper.checkLEIsEmpty(Null,null); 
			Test.stopTest();	 
	}
}
	
	static testMethod void offerPriceChangeTest(){
		//Creating User
		Test.startTest();
		User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		System.runAs(userCreation){
			
			/*fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);*/
			//Account Creation
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			
			//Creating Opportunity
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2,accountCreation);
			optyCreation[0].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[0].Amount = 1000;
			optyCreation[1].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[1].Amount = 1000;
			insert optyCreation;
			
			
			//Updating opportunity with PTA= False and stage to 'Handover (Prepare for Delivery)'
			Offer__c offerCreation = TestDataFactory.OfferCreation(1,optyCreation[0])[0];
			offerCreation.Price__c = 900;
			offerCreation.ActiveOffer__c = true;
			offerCreation.Opportunity__c = optyCreation[0].id;
			insert offerCreation;
			
			optyCreation[0].Amount = 1111;
			
			//update optyCreation;
			//calling method
			Map<Id,Opportunity> OldOptyMap = new Map<Id,Opportunity>();
			oldOptyMap.put(optyCreation[0].id,optyCreation[1]);
			Map<Id,Opportunity> newOptyMap = new Map<Id,Opportunity>();
			newOptyMap.put(optyCreation[0].id,optyCreation[0]);
			OpportunityTriggerHelper.offerPriceChange(newOptyMap.values(), OldOptyMap);
			Test.stopTest();
		}
	}
	static testMethod void DecisionUpdateTest(){
		//Creating User
		User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		System.runAs(userCreation){
			Test.startTest();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			//Account Creation
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;			
			//Creating Opportunity
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation);
			optyCreation[0].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[0].Amount = 1000;
			insert optyCreation;  
			OpportunityTriggerHelper.DecisonUpdate(optyCreation);
			OpportunityTriggerHelper.DecisonUpdate(null); 
			//FollowOpportunity
			OpportunityTriggerHelper.FollowOpportunity(NULL);
			Test.stopTest();		 
		}
	}

	 static testMethod void chatterPostToAccountmanagerTest(){
		//User creation
		list<user> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		//Variable declaration
		Account accountCreation ;
		List<Opportunity> oppty;
		Product2 prod;
		List<Order_Intake_Forecast__c> orderIntake ;
		Nokia_Financial_Calendar__c nokiaFinCalCreation;
		
		system.runAs(userCreation[0]){			
			//Creating Account
			accountCreation = TestDataFactory.createAccount(1)[0];	  
			database.insert(accountCreation);	 
			//inserting oppty
			oppty = TestDataFactory.OpportunityCreation(2,accountCreation);
			oppty[0].stageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			oppty[0].RecordTypeId = oppDirectRecordTypeId;
			oppty[0].Phase_Status__c = GlobalConstants.PLANNED;
			oppty[1].stageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			oppty[1].RecordTypeId = oppDirectRecordTypeId;
			oppty[1].Phase_Status__c = GlobalConstants.PLANNED;
			oppty[0].Lead_BG__c = 'FN';
			oppty[1].Lead_BG__c = 'FN';
			oppty[1].Supporting_BG_MN__c = 'MN';
			oppty[0].Supporting_BG_MN__c = 'MN';
			database.insert(oppty);
			
			
			nokiaFinCalCreation = TestdataFactory.nokiaFinCalCreation(1)[0];
			insert nokiaFinCalCreation;
			//creating Order Intake Forecast	 
			prod = TestDataFactory.productCreation(1)[0];
			prod.Family= '5G';
			database.insert(prod);
			orderIntake = TestDataFactory.orderIntakeCreation(4,oppty[0],prod,nokiaFinCalCreation); 
			orderIntake[0].Business_Group__c = 'NSW';
			orderIntake[0].Forecast_Category__c = 'Risk';
			orderIntake[1].Forecast_Category__c = 'Secure';			
			orderIntake[0].OIF_Value__c= 1000; 
			orderIntake[2].Opportunity__c = oppty[1].Id;
			orderIntake[3].Opportunity__c = oppty[1].Id;
			orderIntake[2].Business_Group__c = 'NSW';
			orderIntake[2].Forecast_Category__c = 'Risk';
			orderIntake[3].Forecast_Category__c = 'Secure';			
			orderIntake[2].OIF_Value__c= 1000; 
			database.insert(orderIntake);
			
			oppty[1].Apttus_Approval__Approval_Status__c = 'Approved';
			oppty[1].ApprovalStatusTechField__c = 'Approved G2,Approved G3';
			oppty[1].StageName = GlobalConstants.CREATE_OFFER;
			oppty[1].Phase_Status__c = GlobalConstants.OFFER_IN_PROGRESS;
			oppty[0].Apttus_Approval__Approval_Status__c = 'Approved';
			oppty[0].ApprovalStatusTechField__c = 'Approved G2,Approved G3,Approved G4';
			oppty[0].StageName = GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE;
			oppty[0].Phase_Status__c = GlobalConstants.OFFER_SUBMITTED_TO_CUSTOMER_MANUAL;
	//oppty[0].Sales_Outcome__c=GlobalConstants.OPP_LOST_TO_COMPETITOR;
			
			database.update(oppty[0]); 
			
			Map<Id,Opportunity> oldMap = new Map<Id,Opportunity>();
			oldMap.put(oppty[0].id,oppty[1]);
			Map<Id,Opportunity> newMap = new Map<Id,Opportunity>();
			newMap.put(oppty[0].id,oppty[0]);
			Set<ID> NullID= new Set<ID>();
			
			test.startTest();
			GlobalConstants.CHATTER_POST_TO_ACCOUNT_MANAGER_FLAG = false;
			OpportunityTriggerHelper.chatterPostToAccountManager(newMap,oldmap);
			oppty[0].Winning_Competitor__c = 'ABB';
			oppty[0].StageName = 'Closed - Lost to Competitor';
			oppty[0].Phase_Status__c = 'Closed(not won)';
			oppty[0].Sales_Outcome__c=GlobalConstants.OPP_LOST_TO_COMPETITOR;
			
			database.update(oppty[0]); 
			
			OpportunityTriggerHelper.MassupdateonOIFLines(newMap.Keyset());
	
			OpportunityTriggerHelper.MassupdateonOIFLines(NullID);
			test.stopTest();
		}
	}
	
	static testMethod void probabilityUpdateInlineTest(){
		//User creation
		list<user> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		//Variable declaration
		Account accountCreation ;
		List<Opportunity> oppty;
		Product2 prod;
		List<Order_Intake_Forecast__c> orderIntake ;
		Nokia_Financial_Calendar__c nokiaFinCalCreation;
		Stage_Sales_Outcome__c stageValue = new Stage_Sales_Outcome__c ();
		stageValue.Stage_Type__c = GlobalConstants.ClosedLost;
		stageValue.name = 'Closed - Obsolete';
		database.insert(stageValue);
		Stage_Sales_Outcome__c stageValue1 = new Stage_Sales_Outcome__c ();
		stageValue1.Stage_Type__c = GlobalConstants.ClosedWon;
		stageValue1.name = 'Handover (Prepare for Delivery)';
		database.insert(stageValue1);
		Stage_Sales_Outcome__c stageValue2 = new Stage_Sales_Outcome__c ();
		stageValue2.Stage_Type__c = GlobalConstants.Open;
		stageValue2.name = 'Win the Case (Negotiate)';
		database.insert(stageValue2);
		system.runAs(userCreation[0]){			
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			//Creating Account
			accountCreation = TestDataFactory.createAccount(1)[0];  
			accountCreation.AccountNumber = '1287738289';
			database.insert(accountCreation);	 
			//inserting oppty
			oppty = TestDataFactory.OpportunityCreation(3,accountCreation);
			oppty[0].stageName = GlobalConstants.CREATE_OFFER ;
			oppty[0].recordTypeId = oppDirectRecordTypeId;
			oppty[0].Phase_Status__c = 'Offer in Progress';
			oppty[0].Lead_BG__c = 'FN';
			oppty[0].probability = 0;
			
			Map<Id,Opportunity> opptyOldMap = new Map<Id,Opportunity>();
			Map<Id,Opportunity> opptyNewMap = new Map<Id,Opportunity>();
			
			oppty[1].stageName = GlobalConstants.CREATE_OFFER ;
			oppty[1].recordTypeId = oppDirectRecordTypeId;
			oppty[1].Phase_Status__c = 'Offer in Progress';
			oppty[1].Lead_BG__c = 'FN';
			oppty[1].probability = 10;
			oppty[1].Opportunity_Sales_Phase_Tracking__c = 'Closed - Obsolete';
			
			oppty[2].stageName = 'Closed - Obsolete';
			oppty[2].recordTypeId = oppDirectRecordTypeId;
			oppty[2].Phase_Status__c = 'Closed(not won)';
			oppty[2].Lead_BG__c = 'FN';
			oppty[2].Opportunity_Sales_Phase_Tracking__c = GlobalConstants.IDENTIFY_OPPORTUNITY;
			database.insert(oppty);
			//oppty[1].stageName = GlobalConstants.DEVELOP_OPPORTUNITY  ;
			oppty[1].stageName ='Win the Case (Negotiate)';
			oppty[1].Phase_Status__c = 'Closed(Not Won)';
	oppty[1].Sales_Outcome__c=GlobalConstants.CANCEL_BY_CUSTOMER;
			test.startTest();
			
			oppty[2].stageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			update oppty[2];
			opptyOldMap.put(oppty[0].id,oppty[1]);
			opptyNewMap.put(oppty[0].id,oppty[0]);
			//database.update(oppty);  
			OpportunityTriggerHelper.probabilityUpdateInline(opptyNewMap,opptyOldMap);
			OpportunityTriggerHelper.probabilityUpdateInline(null,null);
			//populateSalesOutcome
			OpportunityTriggerHelper.populateSalesOutcome(oppty,opptyOldMap);
			//BatchCurrenychange coverage
			Set<Id> opptyId = new Set<Id>();
			for(opportunity opptyObj : oppty){
	opptyId.add(opptyObj.id);
			}
			OpportunityTriggerHelper.BatchCurrenychange(opptyId);
			OpportunityTriggerHelper.MassupdateonOIFLines(opptyId);
			
			//DeleteAllocationLine
			OpportunityTriggerHelper.DeleteAllocationLine(opptyId);
			//Exception
			OpportunityTriggerHelper.BatchCurrenychange(NULL);
			OpportunityTriggerHelper.populateSalesOutcome(NULL, NULL);
			test.stopTest();
		}
		
	}

	static testMethod void opportuntityClosedOrActiveTest(){
		//User creation
		list<user> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		//Variable declaration
		Account accountCreation ;
		Opportunity oppty;
		Product2 prod;
		
		system.runAs(userCreation[0]){			
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			//Creating Account
			accountCreation = TestDataFactory.createAccount(1)[0];	  
			database.insert(accountCreation);	 
			//inserting oppty
			oppty = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			oppty.stageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
			oppty.recordTypeId = oppDirectRecordTypeId;
			oppty.Phase_Status__c = GlobalConstants.PLANNED;
			oppty.Lead_BG__c = 'FN';
			database.insert(oppty);
			OpportunityTriggerHelper.opportuntityClosedOrActive(oppty.Id);
		}
	}
	
	
	
	
/******************************
*Method Name: populateReasonsTest
*Description: Test Method to cover OpportunityTriggerHelper class
********************************/
	static testMethod void populateReasonsTest(){
		 //User creation
		list<user> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		system.runAs(userCreation[0]){ 
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2,accountCreation);
			optyCreation[0].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[0].Amount = 11000;
			
			optyCreation[1].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[1].Amount = 11000;
			database.insert(optyCreation);
			Test.startTest();
			Offer__c offerCreation = TestDataFactory.OfferCreation(1,optyCreation[0])[0];
			offerCreation.ActiveOffer__c = true;
			insert offerCreation;
			
			optyCreation[0].StageName = GlobalConstants.CANCELLED_BY_CUSTOMER;
			optyCreation[0].Apttus_Approval__Approval_Status__c = GlobalConstants.STATUS_NOT_SUBMITTED;
			optyCreation[0].Sales_Outcome_Reason__c = GlobalConstants.FREASON;
			optyCreation[0].Second_Reason__c = GlobalConstants.SREASON;
			optyCreation[0].Third_Reason__c = GlobalConstants.TREASON;
			optyCreation[1].StageName = GlobalConstants.WITH_DRAW_BY_NOKIA;
			optyCreation[1].Apttus_Approval__Approval_Status__c = GlobalConstants.STATUS_NOT_SUBMITTED;
			optyCreation[1].Sales_Outcome_Reason__c = GlobalConstants.FREASON;
			optyCreation[1].Second_Reason__c = GlobalConstants.SREASON;
			optyCreation[1].Third_Reason__c = GlobalConstants.TREASON;
			database.update(optyCreation);
			OpportunityTriggerHelper.populateReasons(null,null);
			OpportunityTriggerHelper.populateG5ContractApprovalDate(Null,Null);
			OpportunityTriggerHelper.DeleteAllocationLine(Null);
			Test.stopTest();
		}	  
	 }  
	
	static testMethod void convertionrateupdateTest(){
		Nokia_Financial_Calendar__c nokiaFinCalCreation;
		Dated_Exchange_Rates__c datedExchangeRates;
		 //User creation
		list<user> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		system.runAs(userCreation[0]){ 
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			nokiaFinCalCreation = TestdataFactory.nokiaFinCalCreation(1)[0];
			insert nokiaFinCalCreation;
			datedExchangeRates = TestdataFactory.datedExchnageRateCreation(1)[0];
			datedExchangeRates.DER_Period__c = nokiaFinCalCreation.Id;
			database.insert(datedExchangeRates);
			
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			accountCreation.AccountNumber = '1234'; 
			database.insert(accountCreation);
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2,accountCreation);
			optyCreation[0].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[0].Amount = 11000;	
			optyCreation[0].CurrencyIsoCode = 'USD';
			optyCreation[1].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[1].Amount = 11000;
			optyCreation[1].CurrencyIsoCode = 'USD';
			database.insert(optyCreation);
		}
	 }  
	
	static testMethod void populateEndCustomerAndEndCustomerLegalEntityForDirectRecordTypeTest(){
		 //User creation
		list<user> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		system.runAs(userCreation[0]){ 
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			
			List<Account> accountCreation = TestDataFactory.createAccount(2);
			accountCreation[0].AccountNumber = '1234';
			accountCreation[1].AccountNumber = '301'; 
			database.insert(accountCreation);
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2,accountCreation[0]);
			optyCreation[0].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[0].Amount = 11000;	
			optyCreation[0].End_Customer__c = accountCreation[0].Id;
			optyCreation[1].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[1].Amount = 11000;	
			optyCreation[1].End_Customer__c = accountCreation[0].Id;
			database.insert(optyCreation);
			optyCreation[0].End_Customer__c = accountCreation[1].Id;
			//update optyCreation;   
			
			Map<Id,Opportunity> OldOptyMap = new Map<Id,Opportunity>();
			oldOptyMap.put(optyCreation[0].id,optyCreation[1]);
			Map<Id,Opportunity> newOptyMap = new Map<Id,Opportunity>();
			newOptyMap.put(optyCreation[0].id,optyCreation[0]);
			OpportunityTriggerHelper.populateEndCustomerAndEndCustomerLegalEntityForDirectRecordType(newOptyMap.values(), OldOptyMap);
			OpportunityTriggerHelper.populateEndCustomerAndEndCustomerLegalEntityForDirectRecordType(null, null);
		}
	 }
 /******************************
*Method Name: freezeAccountNameTest
*Description: Test Method to cover OpportunityTriggerHelper class
********************************/
	/*static testMethod void freezeAccountNameTest(){
		 //User creation
		list<user> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		system.runAs(userCreation[0]){ 
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			List<Account> accountCreation = TestDataFactory.createAccount(2);
			insert accountCreation;
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2,accountCreation[0]);
			optyCreation[0].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[1].PSR_Reference_Opportunity__c = optyCreation[0].id;
			optyCreation[1].RecordTypeId = PSR_EditRecordTypeID;
			database.insert(optyCreation);
			optyCreation[0].AccountId = accountCreation[1].Id;
			database.update(optyCreation);
			OpportunityTriggerHelper.freezeAccountName(null,null);
		}	  
	 }  */   
	static testMethod void PopulateEndCustTest(){
			List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
			List<Opportunity> lstOpty= new List<Opportunity>();
			List<Opportunity> lstOpty1= new List<Opportunity>();
			List<Account> accList = new List<Account>();
			Id oppIndirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Indirect Sales Opportunity').getRecordTypeId();
			Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
			
			accList = TestDataFactory.createAccount(3);
			
			accList[0].RecordTypeId=custRecordTypeId;		
			accList[1].RecordTypeId=LERecordTypeId;
			accList[2].RecordTypeId=LERecordTypeId;  
			accList[1].AccountNumber='301030872';
			accList[2].AccountNumber='301030873';
			database.insert(accList);
	
			
			lstOpty = TestDataFactory.OpportunityCreation(2,accList[0]);
			lstOpty[1].RecordTypeId= oppIndirectRecordTypeId ;
			lstOpty[1].End_Customer__c = null;
			lstOpty[1].Account_Role__c ='Alliance Partner';
			lstOpty[1].End_Customer_LE__c=accList[1].id;
			database.insert(lstOpty);
	
			/*lstOpty1 = TestDataFactory.OpportunityCreation(2,accList[0]);		 
			lstOpty1[1].RecordTypeId= oppIndirectRecordTypeId ;
			lstOpty1[1].End_Customer__c = null;
			lstOpty1[1].Account_Role__c ='Alliance Partner';
			lstOpty1[1].End_Customer_LE__c=accList[2].id;
			database.insert(lstOpty1); */	
	 test.startTest();  
			accList[1].parentId=accList[0].id;	
			database.update(accList[1]);
	 test.stopTest();
			//OpportunityTriggerHelper.populateEndCustomer(null,null);
	}
	
	/******************************
	*Method Name: populateSalesOutcomeTest
	*Description: Test Method to cover OpportunityTriggerHelper class
	********************************/
	 static testMethod void populateSalesOutcomeTest(){
		 //User creation
		list<user> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		//Variable declaration
		Account accountCreation ;
		List<Opportunity> oppty;
		
		system.runAs(userCreation[0]){			
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			List<Stage_Sales_Outcome__c> customSettingData = new List<Stage_Sales_Outcome__c>();
			Stage_Sales_Outcome__c customSettingData1 = new Stage_Sales_Outcome__c();
			Stage_Sales_Outcome__c customSettingData2 = new Stage_Sales_Outcome__c();
			customSettingData1.Name = 'Identify Opportunity';
			customSettingData1.Related_Phase_Status__c = 'Planned';
			customSettingData1.Stage_Type__c = 'Open';
			customSettingData2.Name = 'Closed - Obsolete';
			customSettingData2.Related_Phase_Status__c = 'Closed(not won)';
			customSettingData2.Stage_Type__c = 'Closed/Lost';
			customSettingData2.Related_Sales_Outcome__c = 'Obsolete';
			customSettingData.add(customSettingData1);
			customSettingData.add(customSettingData2);
			database.insert(customSettingData); 
			//Creating Account
			accountCreation = TestDataFactory.createAccount(1)[0];	  
			database.insert(accountCreation);	 
			//inserting oppty
			oppty = TestDataFactory.OpportunityCreation(2,accountCreation);
			oppty[0].StageName = 'Identify Opportunity';
			oppty[0].Phase_Status__c = 'Planned';
			oppty[0].Amount = 100;
			oppty[0].RecordTypeId= oppDirectRecordTypeId;
			oppty[1].StageName = 'Identify Opportunity';
			oppty[1].Phase_Status__c = 'Planned';
			oppty[1].Amount = 100;
			oppty[1].RecordTypeId= oppDirectRecordTypeId;
			//oppty.Opportunity_Sales_Phase_Tracking__c  = 'Identify Opportunity';
			database.insert(oppty);
			
			/*oppty.stageName = GlobalConstants.HANDOVER_OPPTY;
			oppty.Phase_Status__c = GlobalConstants.PTA_HANDOVER;
			oppty.Apttus_Approval__Approval_Status__c = 'Approved';
			oppty.ApprovalStatusTechField__c = 'Approved G2,Approved G3,Approved G4,Approved G5';
			database.update(oppty);*/
			

			oppty[1].stageName = 'Closed - Obsolete';
			oppty[1].Phase_Status__c = 'Closed(not won)';
			oppty[1].Opportunity_Sales_Phase_Tracking__c  = 'Identify Opportunity';
			database.update(oppty[1]);
			
			/*oppty.StageName = 'Identify Opportunity';
			oppty.Phase_Status__c = 'Planned';
			database.update(oppty);*/
			
	 /* Opportunity opp = new Opportunity();
			opp.stageName = 'Closed - Obsolete';
			opp.Phase_Status__c = 'Closed(not won)';
			opp.Sales_Outcome_Reason__c = 'Obsolete';
			opp.Opportunity_Sales_Phase_Tracking__c  = 'Identify Opportunity';*/
			
			Map<Id,Opportunity> OldOptyMap = new Map<Id,Opportunity>();
			oldOptyMap.put(oppty[0].id,oppty[1]);
			List<opportunity> opptyList = new List<Opportunity>();
			opptyList.add(oppty[0]);
			
			OpportunityTriggerHelper.populateSalesOutcome(opptyList,oldOptyMap);
	
		}	  
	 }
		
	/**************************************************************
	*Method Name: deleteOpenTasksTest
	*Description: Test Method to cover OpportunityTriggerHelper 
	class deleteOpenTasks method
	*************************************************************/
	
	
	 static testMethod void deleteOpenTasksTest(){
		//Creating User
		User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		System.runAs(userCreation){
			Test.startTest();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			
			//Creating Opportunity
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2,accountCreation);
			optyCreation[0].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[0].Amount = 1000;
			optyCreation[1].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[1].Amount = 1000;
			
			optyCreation[1].StageName = GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE;
			optyCreation[1].Phase_Status__c = 'Offer Submitted to Customer (Manual)';
			insert optyCreation;
			
			optyCreation[1].stageName = GlobalConstants.OBSOLETE;
			optyCreation[1].Phase_Status__c = 'Closed(not won)';
			update optyCreation;
			
			List<Task> taskCreationList = TestDataFactory.TaskCreation(1);
			taskCreationList[0].WhatId = optyCreation[1].Id;
			taskCreationList[0].Status = GlobalConstants.CLOSED_NOT_COMPLETED;
			taskCreationList[0].Task_Creation_By_Pass_Check__c = GlobalConstants.VALUE_TRUE;
			//insert taskCreationList;
			
			Map<Id,Opportunity> opptyOldMap = new Map<Id,Opportunity>();
			opptyOldMap.put(optyCreation[1].id,optyCreation[1]);
			
			Map<Id,Opportunity> opptyNewMap = new Map<Id,Opportunity>();
			opptyNewMap.put(optyCreation[1].id,optyCreation[1]);
			
			OpportunityTriggerHelper.deleteOpenTasks(opptyNewMap,opptyOldMap);
			OpportunityTriggerHelper.deleteOpenTasks(null, null);
			
		}
	 } 

	
	 /******************************
*Method Name: G4_Planned_Date_MandatoryTest
*Description: Test Method to cover OpportunityTriggerHelper class
********************************/
	static testMethod void G4_Planned_Date_MandatoryTest(){
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			optyCreation.RecordTypeId = oppDirectRecordTypeId;
			database.insert(optyCreation);
			Test.startTest();
			Offer__c offerCreation = TestDataFactory.OfferCreation(1,optyCreation)[0];
			offerCreation.ActiveOffer__c = true;
			offerCreation.No_Support_Offer_Condition__c = GlobalConstants.PICKLIST_VALUE_NO;
			insert offerCreation;
			
	 optyCreation.G4_Planned_Date__c = null;
			database.update(optyCreation); 
		Test.stopTest();
			//OpportunityTriggerHelper.G4_Planned_Date_Mandatory(null, null);
	 }
	
	/******************************
	*Method Name: committedUpsellOptyClosureValidationTest 
	*Description: Release 8: Sales Process: Req#4999 Test Method 
			to cover avoidClosingCommittedUpsellByCOSalesOpMarketHead 
	  method from OpportunityTriggerHelper class
	********************************/
	static testMethod void committedUpsellOptyClosureValidationTest(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		system.runAs(userCreation){
			Test.startTest();
			Map < Id, Opportunity > opptyMap = new Map < Id, Opportunity > ();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			//insert account
			List<Account> accountCreation = TestDataFactory.createAccount(2);
			database.insert(accountCreation);
			system.debug('accountCreation>>'+accountCreation);
			
			//insert opportunity
			List<Opportunity> optyCreation1 = TestDataFactory.OpportunityCreation(1,accountCreation[1]);	
			optyCreation1[0].Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			optyCreation1[0].StageName = 'Identify Opportunity';  
			optyCreation1[0].Phase_Status__c = 'Planned';  
			database.insert(optyCreation1);
			
			//closing opty
			try{
	optyCreation1[0].StageName = GlobalConstants.CANCELLED_BY_CUSTOMER;
	optyCreation1[0].Phase_Status__c = GlobalConstants.PHASE_STATUS_CLOSED_NOT_WON;
	database.update(optyCreation1);	
			} catch(Exception ex){
	String message = ex.getMessage();
	system.assert(message.contains(Label.AvoidClosingCommitedUpsellByCoSalesOpMarketHead), 'message=' + message);   
			}
			//cover catch block 
			OpportunityTriggerHelper.committedUpsellOptyClosureValidation(null,null);
			test.stopTest();
		}
	}
	
		static testMethod void updateSSOOnUnweightedValueChangeTest(){
		//Creating User
		User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		System.runAs(userCreation){
			
			//Account Creation
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			
			//Creating Opportunity
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			optyCreation.RecordTypeId = oppDirectRecordTypeId;
			optyCreation.Amount = 1000;
			insert optyCreation;
			
			Test.startTest();
			//creating offer
			Offer__c offerCreation = TestDataFactory.OfferCreation(1,optyCreation)[0];
			offerCreation.ActiveOffer__c = true;
			offerCreation.Opportunity__c = optyCreation.id;
			offerCreation.Expected_LoA_G4_Approval_Level__c =  GlobalConstants.LOA_Level_A_Plus ;
			insert offerCreation;
			
			
			optyCreation.Amount = 11000000;
			optyCreation.Unweighted_Amount_EUR__c =11000000; 
			update optyCreation;
			
			Test.stopTest();
		}
	}  
	
			static testMethod void updateSSOOnUnweightedValueChangeTest1(){
		//Creating User
		User userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		insert userCreation;
		System.runAs(userCreation){
			
			//Account Creation
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			
			//Creating Opportunity
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			optyCreation.RecordTypeId = oppDirectRecordTypeId;
			optyCreation.Amount = 1000;
			insert optyCreation;
			
			Test.startTest();
			//creating offer
			Offer__c offerCreation = TestDataFactory.OfferCreation(1,optyCreation)[0];
			offerCreation.ActiveOffer__c = true;
			offerCreation.Opportunity__c = optyCreation.id;
			offerCreation.Expected_LoA_G4_Approval_Level__c = 'E' ;
			insert offerCreation;
			
			
			optyCreation.Amount = 1100;
			optyCreation.Unweighted_Amount_EUR__c =1100; 
			update optyCreation;
			
			Test.stopTest();
		}
	}
	
	/******************************
*Method Name: associateUpsellOpptyWithUpsellDealTest
*Description: Test Method to cover OpportunityTriggerHelper class
********************************/
  /*  static testMethod void associateUpsellOpptyWithUpsellDealTest(){
		 //User creation
		list<user> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		system.runAs(userCreation[0])
		{ 
			Test.StartTest();
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2,accountCreation);
			optyCreation[0].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[0].Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			optyCreation[1].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[1].Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			database.insert(optyCreation);
			Deal__c dealCreation = TestDataFactory.createDeal(1)[0];
			dealCreation.RecordTypeId = upsellDealRecordTypeId;
			database.insert(dealCreation);
			Opportunity_Group__c opptyGroup = TestDataFactory.DealOpptyGroupingCreation(1,optyCreation[0],dealCreation)[0];
			database.insert(opptyGroup);
			optyCreation[0].Description = 'Test';
			optyCreation[1].Description = 'Test';
			try{
			database.update(optyCreation[1]);
			}
			catch(Exception ex){
			String message = ex.getMessage();
			system.assert(message.contains(System.label.AssociateUpsellDealToUpsellOppty_Error), 'message=' + message);
			}
			OpportunityTriggerHelper.associateUpsellOpptyWithUpsellDeal(null, null);
			test.stopTest();
		}  
	}*/
   static testMethod void associateUpsellOpptyWithUpsellDealTest(){
		 //User creation
		list<user> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		system.runAs(userCreation[0])
		{ 
			Test.StartTest();
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			List<Opportunity> optyCreation = TestDataFactory.OpportunityCreation(2,accountCreation);
			optyCreation[0].RecordTypeId = oppDirectRecordTypeId;
			optyCreation[0].Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			optyCreation[1].RecordTypeId = oppIndirectRecordTypeId;
			optyCreation[1].Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			database.insert(optyCreation);
			/*Deal__c dealCreation = TestDataFactory.createDeal(1)[0];
			//dealCreation.RecordTypeId = upsellDealRecordTypeId;
			database.insert(dealCreation);
			Opportunity_Group__c opptyGroup = TestDataFactory.DealOpptyGroupingCreation(1,optyCreation,dealCreation)[0];
			database.insert(opptyGroup);*/
			optyCreation[0].Description = 'Test';
			optyCreation[1].Description = 'Test';
			try{
			database.update(optyCreation);
			}
			catch(Exception ex){
			String message = ex.getMessage();
			system.assert(message.contains(System.label.AssociateUpsellDealToUpsellOppty_Error), 'message=' + message);
			}
			OpportunityTriggerHelper.associateUpsellOpptyWithUpsellDeal(null, null);
			test.stopTest();
		}  
	}
	/******************************
*Method Name: updateUnweightedValueofOpptyGroupTest
*Description: Test Method to cover OpportunityTriggerHelper class
********************************/
	static testMethod void updateUnweightedValueofOpptyGroupTest(){
		 //User creation
		list<user> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		system.runAs(userCreation[0])
		{ 
			Test.StartTest();
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			optyCreation.RecordTypeId = oppDirectRecordTypeId;
			optyCreation.Unweighted_Amount_EUR__c = 1000;
			database.insert(optyCreation);
			Deal__c dealCreation = TestDataFactory.createDeal(1)[0];
			database.insert(dealCreation);
			Opportunity_Group__c opptyGroup = TestDataFactory.DealOpptyGroupingCreation(1,optyCreation,dealCreation)[0];
			database.insert(opptyGroup);
			optyCreation.Unweighted_Amount_EUR__c = 2000;
			database.update(optyCreation);
			OpportunityTriggerHelper.updateUnweightedValueofOpptyGroup(null, null);
			//OpportunityTriggerHelper.updateUnweightedValueofOpptyGroupInFuture(null);
			test.stopTest();
		}  
	}

	 /******************************
*Method Name: restrictOpptyTypeChangeTest
*Description: Test Method to cover OpportunityTriggerHelper class
********************************/
	static testMethod void restrictOpptyTypeChangeTest(){
		 //User creation
		list<user> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		system.runAs(userCreation[0])
		{ 
			Test.StartTest();
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			optyCreation.RecordTypeId = oppDirectRecordTypeId;
			database.insert(optyCreation);
			Deal__c dealCreation = TestDataFactory.createDeal(1)[0];
			dealCreation.RecordTypeId = upsellDealRecordTypeId;
			database.insert(dealCreation);
			Opportunity_Group__c opptyGroup = TestDataFactory.DealOpptyGroupingCreation(1,optyCreation,dealCreation)[0];
			opptyGroup.Opportunity_Relation__c = 'Master';
			database.insert(opptyGroup);
			optyCreation.Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			try{
			database.update(optyCreation);
			}
			catch(Exception ex){
			String message = ex.getMessage();
			system.assert(message.contains(System.label.ErrorOnChangingOpptyType), 'message=' + message);
			}
			OpportunityTriggerHelper.restrictOpptyTypeChange(null, null);
			test.stopTest();
		}  
	}
	
		 /******************************
*Method Name: opportunityTypeChangeRestrictionTest
*Description: Test Method to cover OpportunityTriggerHelper class
********************************/
	static testMethod void opportunityTypeChangeRestrictionTest(){
		 //User creation
		list<user> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		system.runAs(userCreation[0])
		{ 
			
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			optyCreation.RecordTypeId = oppDirectRecordTypeId;
			database.insert(optyCreation);
			Test.StartTest();
			optyCreation.Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			try{
			database.update(optyCreation);
			}
			catch(Exception ex){
			String message = ex.getMessage();
			system.assert(message.contains('Opportunity Type cannot be changed once an Opportunity has been created. If the wrong type is chosen, then the case should be closed as Obsolete, and open a new one with the correct Opportunity Type.'), 'message=' + message);
			}
			OpportunityTriggerHelper.opportunityTypeChangeRestriction(null, null);
			test.stopTest();
		}  
	}
	/******************************
*Method Name: opportunityTypeChangeRestrictionCoverErrorTest
*Description: Test Method to cover OpportunityTriggerHelper class
********************************/
	static testMethod void opportunityTypeChangeRestrictionCoverErrorTest(){
		 //User creation
		list<user> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		system.runAs(userCreation[0])
		{	 
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			optyCreation.RecordTypeId = oppDirectRecordTypeId;
			database.insert(optyCreation);
			optyCreation.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation.Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS ;
			optyCreation.Apttus_Approval__Approval_Status__c = 'Approved';
			optyCreation.ApprovalStatusTechField__c = 'Approved G2';
			database.update(optyCreation);
			Test.StartTest();
			optyCreation.Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			try{
			database.update(optyCreation);
			}
			catch(Exception ex){
			String message = ex.getMessage();
			system.assert(message.contains('The opportunity type cannot be changed after G2.'), 'message=' + message);
			}
			OpportunityTriggerHelper.opportunityTypeChangeRestriction(null, null);
			test.stopTest();
		}  
	}
	 static testMethod void testupsellDeltaDifference(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		system.runAs(userCreation){
			Test.startTest();
			Map < Id, Opportunity > opptyMap = new Map < Id, Opportunity > ();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			//insert account
			List<Account> accountCreation = TestDataFactory.createAccount(2);
			database.insert(accountCreation);
			system.debug('accountCreation>>'+accountCreation);
			
			//insert opportunity
			List<Opportunity> optyCreation1 = TestDataFactory.OpportunityCreation(1,accountCreation[1]);	
			optyCreation1[0].Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			optyCreation1[0].StageName = 'Identify Opportunity';  
			optyCreation1[0].Phase_Status__c = 'Planned';
			optyCreation1[0].Unweighted_Amount_EUR__c= 10;
			optyCreation1[0].Committed_Unweighted_Value_in_EUR__c =10 ;
			
			database.insert(optyCreation1);
			
			optyCreation1[0].Unweighted_Amount_EUR__c= 20;
			
			database.update(optyCreation1); 
			
			test.stopTest();
		}
	}
	
	static testMethod void testException(){
	 //   OpptyTriggerHelper.upsellDeltaDifference(null,null);
	// OpptyTriggerHelper.getCommittedUpsellOpptyList(null);
	// OpptyTriggerHelper.upsellChangeAccepted(null);
	}
	
	//private static Id upsellDealRecordTypeId = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Upsell Deal').getRecordTypeId();
	static testMethod void testcommittedUnweightedValue()
	{
		
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		system.runAs(userCreation){
	 
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			
			Sales_Role__c objsalesrole = new Sales_Role__c();
			objsalesrole.First_Name__c = 'Apoorv';
			objsalesrole.Last_Name__c = 'Jain';
			objsalesrole.Organisation__c = 'APJ ANO CBT Myanmar';
			objsalesrole.Role_Code__c = 'BG Commercial Manage';
			objsalesrole.Role_Name__c = 'BG Commercial Management,OC Level C Validator';
			objsalesrole.User__c = UserInfo.getUserId();
			
			insert objsalesrole;
			
			List<Opportunity> optyCreationList = TestDataFactory.OpportunityCreation(2,accountCreation);
			optyCreationList[0].Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
			optyCreationList[1].Unweighted_Amount_EUR__c = 20;
			database.insert(optyCreationList);
			
			List<Deal__c> dealCreationList = TestDataFactory.createDeal(1);
			
			dealCreationList[0].RecordTypeId = upsellDealRecordTypeId;
			database.insert(dealCreationList);
			
			List<Opportunity_Group__c> opptyGroupList = TestDataFactory.DealOpptyGroupingCreation(2,optyCreationList[0], dealCreationList[0]);
			Test.startTest();
			opptyGroupList[1].Opportunity_Relation__c = 'Master';
			opptyGroupList[1].Opportunity__c= optyCreationList[1].id;
			database.insert(opptyGroupList);
			
			
			optyCreationList[1].stagename= 'Create Offer (Bid)';
			optyCreationList[1].phase_status__c= 'Offer in Progress';
			
			update optyCreationList;
			
			optyCreationList[1].stagename= 'Win the Case (Negotiate)';
			optyCreationList[1].phase_status__c= 'Offer Submitted to Customer (Manual)';
			
			update optyCreationList;
			test.stopTest();
		}
	}
	
	static testMethod void testupsellChangeAccepted()
	{
		
		fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
		database.insert(fileSharingCustomSettingList);
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		system.runAs(userCreation){
		Test.startTest();
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			
			Sales_Role__c objsalesrole = new Sales_Role__c();
			objsalesrole.First_Name__c = 'Apoorv';
			objsalesrole.Last_Name__c = 'Jain';
			objsalesrole.Organisation__c = 'APJ ANO CBT Myanmar';
			objsalesrole.Role_Code__c = 'BG Commercial Manage';
			objsalesrole.Role_Name__c = 'BG Commercial Management,OC Level C Validator';
			objsalesrole.User__c = UserInfo.getUserId();
			
			insert objsalesrole;
			
			List<Opportunity> optyCreationList = TestDataFactory.OpportunityCreation(2,accountCreation);
			optyCreationList [0].Upsell_Change_Accepted__c=true;
			
			try
			{
	database.insert(optyCreationList);
			}
			catch(Exception ex){
			}
			
			test.stopTest();
		}
	}
	
	/******************************
*Method Name: ClosedOpptyStatustoTeamTest
*Description: Test Method to cover OpportunityTriggerHelper class
********************************/
	static testMethod void ClosedOpptyStatustoTeamTest(){
		 //User creation
		list<user> userCreation = TestDataFactory.userCreation(2,'System Administrator');
		insert userCreation;
		Set <Id> opptyId = new Set<Id>();
		system.runAs(userCreation[0])
		{	 
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			insert accountCreation;
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			optyCreation.RecordTypeId = oppDirectRecordTypeId;
			optyCreation.Lead_BG__c = 'ION';
			optyCreation.Supporting_BG_FN__c = 'FN';
			optyCreation.Supporting_BG_MN__c = 'MN';
			optyCreation.Supporting_BG_GS__c = 'GS';
			optyCreation.Supporting_BG_AA__c = 'NSW';
			optyCreation.Supporting_BG_ION__c = 'ION';
			optyCreation.Supporting_BG_NEN__c = 'NEN';
			optyCreation.Lead_BU__c = 'ION Optics';
			optyCreation.Supporting_BU_ION__c = 'ION IPR';
			optyCreation.Supporting_BUs_NEN__c = 'NE EOP';
			
			database.insert(optyCreation);
			//Oppty Team
			OpportunityTeamMember team = TestDataFactory.optyTeamMemberCreation(1,userCreation[0],optyCreation)[0];
			database.insert(team);
			
			Test.StartTest();
			//Creating Offer
			Offer__c offerCreation = TestDataFactory.OfferCreation(1,optyCreation)[0];
			offerCreation.Expected_LoA_G4_Approval_Level__c = 'E';
			offerCreation.ActiveOffer__c = True;
			offerCreation.LoA_Approval_Level__c = 'E';
			offerCreation.LoA_Level_Before_Trigger_Approval__c = 'E';
			database.insert(offerCreation);
			
			optyCreation.StageName = GlobalConstants.OBSOLETE;
			//database.update(optyCreation);
			opptyId.add(optyCreation.id);
			OpportunityTriggerHelper.ClosedOpptyStatustoTeam(opptyId);
			test.stopTest();
		}  
	}
	
	/******************************
	*Method Name: validateSubstituteOptyWithSameUpsellDealTest
	*Description: Test Method to cover validateSubstituteOptyWithSameUpsellDeal method from OpportunityTriggerHelper class
	********************************/
	static testMethod void validateSubstituteOptyWithSameUpsellDealTest(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		system.runAs(userCreation){
			Test.startTest();
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			
			//insert account
			List<Account> accountCreation = TestDataFactory.createAccount(2);
			database.insert(accountCreation);
			system.debug('accountCreation>>'+accountCreation);
			
			//insert opportunity
			List<Opportunity> optyCreation1 = TestDataFactory.OpportunityCreation(2,accountCreation[1]);	
			optyCreation1[0].StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
			optyCreation1[0].Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
			optyCreation1[0].Business_Type__c = GlobalConstants.COMMITTED_UPSELL;	
			database.insert(optyCreation1);
			
			//insert upsell deal
			List<Deal__c> dealCreationList = TestDataFactory.createDeal(2);
			dealCreationList[0].RecordTypeId = upsellDealRecordTypeId; 
			dealCreationList[1].RecordTypeId = upsellDealRecordTypeId; 
			database.insert(dealCreationList);
			
			List<Opportunity_Group__c > opportunityGroupList = TestDataFactory.DealOpptyGroupingCreation(2,optyCreation1[0], dealCreationList[0]);
			opportunityGroupList[1].Opportunity__c = optyCreation1[1].Id;
			opportunityGroupList[1].Deal__c = dealCreationList[1].Id;
			database.insert(opportunityGroupList);
			optyCreation1[0].Substitute_Opportunity__c = optyCreation1[1].Id;  
	 
	try{
	 Database.update(optyCreation1);		 
			} catch(Exception ex){
	String message = ex.getMessage();
	system.assert(message.contains(Label.UpsellOpportunityDealErrorMessage), 'message=' + message);   
			}
			OpportunityTriggerHelper.validateSubstituteOptyWithSameUpsellDeal(null, null);
			Test.stopTest();
		}	
	}
   /******************************
*Method Name: populate_G4ApprovalCycleTimeOnOfferTest
*Description: Test Method to cover populate_G4ApprovalCycleTimeOnOffer method from OpportunityTriggerHelper class
********************************/
	static testMethod void populate_G4ApprovalCycleTimeOnOfferTest(){
		user userCreation = TestDataFactory.userCreation(1,'System Administrator')[0];
		database.insert(userCreation);
		system.runAs(userCreation)
		{
			
			//Creating Account
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			//Creating Opportunity
			List<Opportunity> optyCreationList = TestDataFactory.OpportunityCreation(2,accountCreation);
			database.insert(optyCreationList);
			Test.startTest();
			//Creating Offer
			List<Offer__c> offerCreationList = TestDataFactory.OfferCreation(2,optyCreationList[0]);
			offerCreationList[0].ActiveOffer__c = True;
			offerCreationList[1].Opportunity__c = optyCreationList[1].id;
			offerCreationList[1].ActiveOffer__c = True;
			database.insert(offerCreationList);
			
			optyCreationList[0].G4_Submission_Date__c = system.today();
			optyCreationList[1].G4_Submission_Date__c = system.today();
			optyCreationList[1].G4_Approval_Date__c = system.today();
			database.update(optyCreationList);
			OpportunityTriggerHelper.populate_G4ApprovalCycleTimeOnOffer(null,null);
			Test.stopTest();
		}
	} 
  /******************************
*Method Name: createCompetitorWhenOpportunityClosedNegativelyTest
*Description: Test Method to cover createCompetitorWhenOpportunityClosedNegatively method from OpportunityTriggerHelper class
********************************/
	static testMethod void createCompetitorWhenOpportunityClosedNegativelyTest()
	{
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreation);
		
		List<Opportunity> optyCreationList = TestDataFactory.OpportunityCreation(2,accountCreation);
		optyCreationList[1].RecordTypeId = oppIndirectRecordTypeId;
		database.insert(optyCreationList);
		Map<Id, Opportunity> opptyMap = new Map<Id, Opportunity>();
		opptyMap.put(optyCreationList[0].id, optyCreationList[0]);
		opptyMap.put(optyCreationList[1].id, optyCreationList[1]);
		compList = TestDataFactory.CompetitorCreation(2,optyCreationList[0]);
		compList[0].Competitor_New__c = 'Accenture';
		compList[1].Competitor_New__c = 'Autodesk';
		compList[1].Opportunity__c = optyCreationList[1].id;
		database.insert(compList);
		
		optyCreationList[0].StageName = GlobalConstants.LOST_TO_COMPETITOR;
		optyCreationList[0].RecordTypeId = oppReadOnlyDirectRecordTypeId;
		optyCreationList[0].G4_planned_date__c = System.today();
		optyCreationList[0].Phase_Status__c = 'Closed not(Won)';
		optyCreationList[0].Winning_Competitor__c = 'Facebook;Accenture';
		
		optyCreationList[1].StageName = GlobalConstants.LOST_TO_COMPETITOR;
		optyCreationList[1].RecordTypeId = readOnlyIndirectRecordTypeId;
		optyCreationList[1].G4_planned_date__c = System.today();
		optyCreationList[1].Phase_Status__c = 'Closed not(Won)';
		optyCreationList[1].Winning_Competitor__c = 'Accenture';
		//database.update(optyCreationList);
		OpportunityTriggerHelper.createCompetitorWhenOpportunityClosedNegatively(optyCreationList,opptyMap);
		system.debug('In test class>>'+optyCreationList);
		OpportunityTriggerHelper.createCompetitorWhenOpportunityClosedNegatively(null,null);
	}
	
	/******************************
*Method Name: updateOwnerInOpptyTeamTest
*Description: Test Method to cover updateOwnerInOpptyTeam method from OpportunityTriggerHelper class
********************************/
	static testMethod void updateOwnerInOpptyTeamTest(){
		List<User> userCreationList = TestDataFactory.userCreation(2,'System Administrator');
		database.insert(userCreationList);
		system.runAs(userCreationList[0])
		{			
			//Creating Account
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			//Creating Opportunity
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			database.insert(optyCreation);
			Test.startTest();
			optyCreation.OwnerId = userCreationList[1].Id;
			Database.update(optyCreation);
			Test.stopTest();
		}
	}
		/******************************
*Method Name: insertOwnerInTeamOnReopeningTest
*Description: Test Method to cover insertOwnerInTeamOnReopening method from OpportunityTriggerHelper class
********************************/
	static testMethod void insertOwnerInTeamOnReopeningTest(){
		List<User> userCreationList = TestDataFactory.userCreation(2,'System Administrator');
		database.insert(userCreationList);
		system.runAs(userCreationList[0])
		{			
			//Creating Account
			Account accountCreation = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreation);
			//Creating Opportunity
			Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
			database.insert(optyCreation);
			optyCreation.StageName = Globalconstants.OBSOLETE ; 
			Database.update(optyCreation); 
			Test.startTest();
			OpportunityTeamMember oppTeam= [Select Id from OpportunityTeamMember where UserId =: userCreationList[0].Id
		and OpportunityId =: optyCreation.Id limit 1];
			if(oppTeam!= Null){
	Database.Delete(oppTeam); 
			}
			optyCreation.StageName = Globalconstants.IDENTIFY_OPPORTUNITY;
			Database.update(optyCreation);
			Test.stopTest();
		}
	}
	/******************************
	*Method Name: updateWinningCompOnOpptyTest
	*Description: Test Method to cover createCompetitorWhenOpportunityClosedNegatively method from OpportunityTriggerHelper class
	********************************
	static testMethod void updateWinningCompOnOpptyTest()
	{
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreation);
		test.startTest();
		Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
		optyCreation.RecordTypeId = oppIndirectRecordTypeId;
		database.insert(optyCreation);  
		optyCreation.StageName = GlobalConstants.LOST_TO_COMPETITOR;
		optyCreation.RecordTypeId = oppReadOnlyDirectRecordTypeId;
		optyCreation.G4_planned_date__c = System.today();
		optyCreation.Winning_Competitor__c = null;
		database.update(optyCreation);
		test.stopTest();
		OpportunityTriggerHelper.updateWinningCompOnOppty(null,null);
	}*/
	/******************************
*Method Name: createUnknownCompetitorRecordTest
*Description: Test Method to cover createCompetitorWhenOpportunityClosedNegatively method from OpportunityTriggerHelper class
********************************/
	static testMethod void createUnknownCompetitorRecordTest()
	{
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreation);
		
		List<Opportunity> optyCreationList = TestDataFactory.OpportunityCreation(2,accountCreation);
		optyCreationList[1].RecordTypeId = oppIndirectRecordTypeId;
		database.insert(optyCreationList);
	/* compList = TestDataFactory.CompetitorCreation(2,optyCreationList[0]);
		compList[0].Competitor_New__c = 'Unknown';
		compList[1].Competitor_New__c = 'Unknown';
		compList[1].Opportunity__c = optyCreationList[1].id;
		database.insert(compList);*/
		test.startTest();
		optyCreationList[0].StageName = GlobalConstants.LOST_TO_COMPETITOR;
		optyCreationList[0].RecordTypeId = oppReadOnlyDirectRecordTypeId;
		optyCreationList[0].G4_planned_date__c = System.today();
		optyCreationList[0].Winning_Competitor__c = 'ABB';
		
		optyCreationList[1].StageName = GlobalConstants.LOST_TO_COMPETITOR;
		optyCreationList[1].RecordTypeId = readOnlyIndirectRecordTypeId;
		optyCreationList[1].G4_planned_date__c = System.today();
		optyCreationList[1].Winning_Competitor__c = 'ABB';
		database.update(optyCreationList);
		test.stopTest();
		OpportunityTriggerHelper.createUnknownCompetitorRecord(null,null);
	}
	
/******************************
*Method Name: UpdateOffer
*Description: Test Method to cover createCompetitorWhenOpportunityClosedNegatively method from OpportunityTriggerHelper class
********************************/
	static testMethod void UpdateOffer()
	{
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreation);
		
		Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
		database.insert(optyCreation);
		
		List<Offer__c> offerObj = new List<Offer__c>();
		offerObj = TestDataFactory.OfferCreation(1, optyCreation);	
		database.insert(offerObj);
		
		test.startTest();
		optyCreation.StageName = GlobalConstants.CREATE_OFFER;
		optyCreation.RecordTypeId = oppReadOnlyDirectRecordTypeId;
		optyCreation.G4_planned_date__c = System.today();
		database.update(optyCreation);
		
		optyCreation.StageName = GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE;
		optyCreation.RecordTypeId = oppReadOnlyDirectRecordTypeId;
		optyCreation.G4_planned_date__c = System.today();
		database.update(optyCreation);
			
		test.stopTest();
		OpportunityTriggerHelper.UpdateOffer(null,null);
	}
	
/******************************
*Method Name: updateCustomerOfferDueDatetest
*Description: Test Method to cover updateCustomerOfferDueDate method from OpportunityTriggerHelper class
********************************/
	public static testmethod void updateCustomerOfferDueDatetest()
	{   
	 Account accountCreation = TestDataFactory.createAccount(1)[0];	
	 insert accountCreation;	 
	 Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
	 optyCreation.RecordTypeId = inDirectRecordTypeId;
	 insert optyCreation;
	 Offer__c offerCreation = TestDataFactory.OfferCreation(1,optyCreation)[0];
	 offerCreation.Opportunity__c = optyCreation.id;
	 insert offerCreation;
	 optyCreation.G2_Planned_Date__c = system.today()+1;
	 optyCreation.G3_Planned_Date__c = system.today()+2;
	 optyCreation.G4_Planned_Date__c = system.today()+3;
	 optyCreation.G5_Planned_Date__c = system.today()+4;
	 Test.startTest();
	 update optyCreation;
	 Test.stopTest();
	}
	
	/******************************
*Method Name: validateWonShareAllocationSumTest
*Description: Test Method to cover validateWonShareAllocationSum method from OpportunityTriggerHelper class
********************************/
	static testMethod void validateWonShareAllocationSumTest()
	{
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		database.insert(accountCreation);
		Opportunity optyCreation = TestDataFactory.OpportunityCreation(1,accountCreation)[0];
		optyCreation.RecordTypeId = oppIndirectRecordTypeId;
		database.insert(optyCreation);
		test.startTest();
		compList = TestDataFactory.CompetitorCreation(2,optyCreation);
		compList[0].Competitor_New__c = 'ABB';
		compList[0].Opportunity_Won__c = true;
		compList[0].Won_Share_Allocation_in__c = 70;
		compList[1].Competitor_New__c = 'Accenture';
		compList[1].Opportunity_Won__c = false;
		compList[1].Won_Share_Allocation_in__c = 50;
		compList[1].Opportunity__c = optyCreation.id;
		database.insert(compList);
		optyCreation.StageName = GlobalConstants.LOST_TO_COMPETITOR;
		optyCreation.RecordTypeId = oppReadOnlyDirectRecordTypeId;
		optyCreation.Winning_Competitor__c = 'Accenture';
		try{
			database.update(optyCreation);
		}
		catch(Exception e)
		{
			Boolean expectedExceptionThrown = e.getMessage().contains(System.Label.Won_Share_Sum_Validation) ? true : false; 
			System.assertEquals(expectedExceptionThrown, true); 
		}
		test.stopTest();
		OpportunityTriggerHelper.validateWonShareAllocationSum(null,null);
	}
}