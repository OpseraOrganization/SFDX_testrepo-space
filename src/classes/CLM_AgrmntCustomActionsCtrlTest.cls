/****************************************
* Name : CLM_AgrmntCustomActionsCtrlTest
* Author : Forsys Inc
* Modified by: Rajeev Ketha 
*****************************************/
@isTest
private with sharing class CLM_AgrmntCustomActionsCtrlTest {
	
	@testSetup
	static void testSetup() {
		User u = TestDataFactory.userCreation(1, 'System Administrator')[0];
		insert u;
		System.runAs(u) {
			List<Account> accounts = TestDataFactory.createAccount(6);
			for(Integer i = 0; i < accounts.size(); i++) {
				accounts[i].AccountNumber = '301030999' + i;
			}
			accounts[5].RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(CSWXGlobalConstant.DS_legalEntity).getRecordTypeId();
			insert accounts;
			
			//OPPORTUNITIES
			List<Opportunity> opportunities = new List<Opportunity>();
			// direct Opportunity
			Opportunity o1 = TestDataFactory.OpportunityCreation(1, accounts[0])[0];
			o1.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			o1.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(CSWXGlobalConstant.DIRECTRECORDTYPEOPPORTUNITY).getRecordTypeId();
			o1.Description = 'Test Description 1';
			o1.Amount = 111111;
			o1.End_Customer__c = accounts[1].Id;
			o1.Indirect_Reseller_Account__c = accounts[2].Id;
			o1.Account_Role__c = 'GPP Distributor Partner';
			o1.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			opportunities.add(o1);
			
			// indirect Opportunity
			Opportunity o2 = TestDataFactory.OpportunityCreation(1, accounts[0])[0];
			o2.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			o2.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(CSWXGlobalConstant.INDIRECTRECORDTYPEOPPORTUNITY).getRecordTypeId();
			o2.Lead_BG__c = 'MN';
			o2.Description = 'Test Description 2';
			o2.Amount = 222222;
			o2.End_Customer__c = accounts[3].Id;
			o2.Indirect_Reseller_Account__c = accounts[4].Id;
			o2.Account_Role__c = 'GPP Distributor Partner';
			o2.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			o2.End_Customer_LE__c = accounts[5].Id;
			opportunities.add(o2);
			
			Opportunity o3 = TestDataFactory.OpportunityCreation(1, accounts[0])[0];
			o3.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			o3.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(CSWXGlobalConstant.INDIRECTRECORDTYPEOPPORTUNITY).getRecordTypeId();
			o3.Lead_BG__c = 'MN';
			o3.Description = 'Test Description 2';
			o3.Amount = 222222;
			o3.End_Customer__c = accounts[3].Id;
			o3.Indirect_Reseller_Account__c = accounts[4].Id;
			o3.Account_Role__c = 'GPP Distributor Partner';
			o3.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			o3.End_Customer_LE__c = accounts[5].Id;
			opportunities.add(o3);
			Nokia_CPQ_Constants.isCloneRun = true;
			insert opportunities;
			
			// OPPORTUNITY TEAM MEMBERS
			List<User> otmUsers = TestDataFactory.userCreation(3, 'Non-Sales User Profile');
			insert otmUsers;
			
			List<OpportunityTeamMember> otms = new List<OpportunityTeamMember>();
			OpportunityTeamMember otmCCM1 = TestDataFactory.optyTeamMemberCreation(1, otmUsers[0], opportunities[0])[0];
			otmCCM1.TeamMemberRole = 'Commercial Contract Manager (L&C)';
			otms.add(otmCCM1);
			OpportunityTeamMember otmPCM1 = TestDataFactory.optyTeamMemberCreation(1, otmUsers[1], opportunities[0])[0];
			otmPCM1.TeamMemberRole = 'Account Manager (TRICORN Sales Case Owner (SCO))';
			otms.add(otmPCM1);
			
			
			OpportunityTeamMember otmCCM2 = TestDataFactory.optyTeamMemberCreation(1, otmUsers[0], opportunities[1])[0];
			otmCCM2.TeamMemberRole = 'Commercial Contract Manager (L&C)';
			otms.add(otmCCM2);
			OpportunityTeamMember otmPCM2 = TestDataFactory.optyTeamMemberCreation(1, otmUsers[1], opportunities[1])[0];
			otmPCM2.TeamMemberRole = 'Account Manager (TRICORN Sales Case Owner (SCO))';
			otms.add(otmPCM2);
			
			insert otms;
			
			Apttus__APTS_Agreement__c agrmnt = new Apttus__APTS_Agreement__c();
			agrmnt.Name = 'Test Agreement ' ;
			agrmnt.Apttus__Account__c = accounts[1].Id;
			agrmnt.CurrencyIsoCode = 'EUR';
			agrmnt.Delivery_System__c = 'Scratch Order via P20';
			agrmnt.ERP__c = 'P20';
			agrmnt.Sales_Mode__c = 'Corporate Sales Mode';
			agrmnt.Confidence_Level__c = 'Low Level';
			agrmnt.Lead_BG__c = '';
			agrmnt.Apttus__Related_Opportunity__c = opportunities[0].Id;
			
			insert agrmnt;
			
			List<CLM_OpportunityFieldsToCopy__c> optyFieldCopyLst = new List<CLM_OpportunityFieldsToCopy__c>();
			CLM_OpportunityFieldsToCopy__c oppField = new CLM_OpportunityFieldsToCopy__c();
			oppField.OpportunityFieldAPI__c = 'Lead_BG__c';
			oppField.AgreementFieldAPI__c = 'Lead_BG__c';
			oppField.AgreementFieldLabel__c = 'Lead BG';
			oppField.Name = 'Lead BG';
			oppField.order__c = 1;
			optyFieldCopyLst.add(oppField);
			CLM_OpportunityFieldsToCopy__c oppField1 = new CLM_OpportunityFieldsToCopy__c();
			oppField1.OpportunityFieldAPI__c = 'Id';
			oppField1.AgreementFieldAPI__c = 'Apttus__Related_Opportunity__c';
			oppField1.AgreementFieldLabel__c = 'Related Opportunity';
			oppField1.Name = 'Related Opportunity';
			oppField1.order__c = 2;
			optyFieldCopyLst.add(oppField1);
			insert optyFieldCopyLst;
			
			CLM_AgreemntFieldsToCopy__c agrmntFileds = new CLM_AgreemntFieldsToCopy__c();
			agrmntFileds.AgreementFieldAPI__c = 'Lead_BG__c';
			agrmntFileds.AgreementFieldLabel__c = 'Lead_BG__c';
			agrmntFileds.Name = 'Lead BG';
			agrmntFileds.order__c = 1;
			insert agrmntFileds;
			
			List<CLM_RequiredFields__c> reqLst = new List<CLM_RequiredFields__c>();
			CLM_RequiredFields__c reqFileds = new CLM_RequiredFields__c();
			reqFileds.FieldAPI__c = 'Lead_BG__c';
			reqFileds.Action__c = 'SubmitRequest';
			reqFileds.FieldLabel__c = 'Lead BG';
			reqFileds.DependentField__c = '';
			reqFileds.DependentCondition__c = '';
			reqFileds.DependentValue__c = '';
			reqFileds.ObjectAPI__c = 'Apttus__APTS_Agreement__c';
			reqFileds.Name = 'Lead BG';
			reqFileds.Active__c = true; 
			reqFileds.Type_of_Request__c = 'Non-Transactional (NDA, LOI, MOU etc.)';
			reqLst.add(reqFileds);
			
			CLM_RequiredFields__c reqFileds1 = new CLM_RequiredFields__c();
			reqFileds1.FieldAPI__c = 'CLM_Document_Collaboration_Link__c';
			reqFileds1.Action__c = 'SubmitRequest';
			reqFileds1.FieldLabel__c = 'Link';
			reqFileds1.DependentField__c = '';
			reqFileds1.DependentCondition__c = '';
			reqFileds1.DependentValue__c = '';
			reqFileds1.ObjectAPI__c = 'Apttus__APTS_Agreement__c';
			reqFileds1.Name = 'Link';
			reqFileds1.Active__c = true;
			reqFileds1.Type_of_Request__c = 'Non-Transactional (NDA, LOI, MOU etc.)';
			reqLst.add(reqFileds1);
			
			CLM_RequiredFields__c reqFileds2 = new CLM_RequiredFields__c();
			reqFileds2.FieldAPI__c = 'Lead_BU__c';
			reqFileds2.Action__c = 'SubmitRequest';
			reqFileds2.FieldLabel__c = 'Lead Bu';
			reqFileds2.DependentField__c = 'Lead_BG__c';
			reqFileds2.DependentCondition__c = 'not equal to';
			reqFileds2.DependentValue__c = 'NI';
			reqFileds2.ObjectAPI__c = 'Apttus__APTS_Agreement__c';
			reqFileds2.Name = 'Lead BU';
			reqFileds2.Type_of_Request__c = 'Non-Transactional (NDA, LOI, MOU etc.)';
			reqFileds2.Active__c = true;
			
			
			reqLst.add(reqFileds2);
			
			CLM_RequiredFields__c reqFileds3 = new CLM_RequiredFields__c();
			reqFileds3.FieldAPI__c = 'CLM_Opportunity_Comments__c';
			reqFileds3.Action__c = 'SubmitRequest';
			reqFileds3.FieldLabel__c = 'Comments';
			reqFileds3.DependentField__c = 'Apttus__Related_Opportunity__c';
			reqFileds3.DependentCondition__c = 'equal to';
			reqFileds3.DependentValue__c = 'Null';
			reqFileds3.ObjectAPI__c = 'Apttus__APTS_Agreement__c';
			reqFileds3.Name = 'Comments';
			reqFileds3.Type_of_Request__c = 'Non-Transactional (NDA, LOI, MOU etc.)';
			reqFileds3.Active__c = true;
			reqFileds3.DependentCombination__c = 'OR';
			
			reqLst.add(reqFileds3);
			
			CLM_RequiredFields__c reqFileds4 = new CLM_RequiredFields__c();
			reqFileds4.FieldAPI__c = 'CLM_Product_Categories__c';
			reqFileds4.Action__c = 'ActivateRequest';
			reqFileds4.FieldLabel__c = 'Product Categories';
			reqFileds4.DependentField__c = 'APTS_Ext_ID__c';
			reqFileds4.DependentCondition__c = 'equal to';
			reqFileds4.DependentValue__c = 'null';
			reqFileds4.ObjectAPI__c = 'Apttus__APTS_Agreement__c';
			reqFileds4.Name = '49';
			reqFileds4.Active__c = true;
			reqFileds4.DependentCombination__c = 'AND';
			
			reqLst.add(reqFileds4);
			
			CLM_RequiredFields__c reqFileds5 = new CLM_RequiredFields__c();
			reqFileds5.FieldAPI__c = 'Apttus__Related_Opportunity__c';
			reqFileds5.Action__c = 'ActivateRequest';
			reqFileds5.FieldLabel__c = 'Related Opportunity';
			reqFileds5.DependentField__c = '';
			reqFileds5.DependentCondition__c = '';
			reqFileds5.DependentValue__c = '';
			reqFileds5.ObjectAPI__c = 'Apttus__APTS_Agreement__c';
			reqFileds5.Name = 'Related Opportunity';
			reqFileds5.Active__c = true;
			reqFileds5.DependentCombination__c = '';
			
			reqLst.add(reqFileds5);
			
			insert reqLst;	   
			
		}
	}
	
	public static testmethod void customActionsOnAgreement() {
		User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
		System.runAs (thisUser) {
			PermissionSet permiSet = [select id,Name from PermissionSet where name='CLM_Commercial_Contract_Manager'];  
			PermissionSetAssignment psa = new PermissionSetAssignment();
			psa.AssigneeId = UserInfo.getUserId();
			psa.PermissionSetId = permiSet.Id;
			Account account = getAccount();
			test.startTest();
			Territory2 L7ter=[Select id,developerName from Territory2 where Territory2Model.state = 'Active' AND Hierarchy_Level__c=:GlobalConstants.L7_level ORDER BY NAME DESC limit 1];
			
			
			objectTerritory2Association NonVzWAcc=new objectTerritory2Association(objectId=account.Id,Territory2Id=L7ter.Id,AssociationCause='Territory2Manual');
			Database.insert(new List<objectTerritory2Association>{NonVzWAcc});
			List<Opportunity> opportunities = getOpportunities();
			
			Apttus__APTS_Agreement__c a = [Select id,OwnerId FROM Apttus__APTS_Agreement__c];
			a.OwnerId = userInfo.getUserId();
			update a;
			
			List<Id> ownerIds = new List<Id>();
			for(Opportunity opp:opportunities){
				ownerIds.add(opp.OwnerId);
			}
			Map<Id,User> userMap = new Map<Id,User>([SELECT Name,Email from User WHERE Id IN:ownerIds ]);
			List<Apttus__APTS_Agreement__c> agreements = createAgreements(account, opportunities);
			insert agreements; 
			CLM_AgrmntCustomActionsCtrl.getCMUsersLst(account.Id, agreements[0].Id);
			
			
			CLM_AgrmntCustomActionsCtrl.checkCustomPermission();
			List<CLM_Agreement_Team__c> agreemntTeam = createAgreementTeams(agreements);
			insert agreemntTeam;
			Apttus__APTS_Agreement__c agrmnt = CLM_AgrmntCustomActionsCtrl.getRecordData(agreements[0].Id);
			system.assertEquals(opportunities[0].Id, agrmnt.Apttus__Related_Opportunity__c);
			CLM_AgrmntCustomActionsCtrl.objInfoWrapper wrap =  CLM_AgrmntCustomActionsCtrl.opptCopyToObj(opportunities[0].Id,CLM_GlobalConstants.optyAPIName,CLM_GlobalConstants.agrmntAPIName);
			System.assert(wrap.wrapRecdsList.size()>0);
			List<CLM_AgrmntCustomActionsCtrl.wrapper> wrapData = CLM_AgrmntCustomActionsCtrl.getDataToClone(agreements[0].Id,CLM_GlobalConstants.agrmntAPIName);
			System.assert(wrapData.size()>0);
			CLM_AgrmntCustomActionsCtrl.createNonTranAgrmnt(agreements[0].Id,CLM_GlobalConstants.agrmntAPIName);
			CLM_AgrmntCustomActionsCtrl.createAgrmntTeam(agreements[0].Id,agreements[1].Id);
			List<CLM_AgrmntCustomActionsCtrl.wrapper> reqWrap = CLM_AgrmntCustomActionsCtrl.getRequiredFields(agreements[0].Id, 'SubmitRequest', CLM_GlobalConstants.agrmntAPIName,JSON.Serialize(agreements[0]));
			System.assert(reqWrap.size()>0);
			
			List<CLM_AgrmntCustomActionsCtrl.wrapper> reqWrap1 = CLM_AgrmntCustomActionsCtrl.getRequiredFields(agreements[0].Id, 'ActivateRequest', CLM_GlobalConstants.agrmntAPIName,JSON.Serialize(agreements[0]));
			System.assert(reqWrap1.size()>0);
			
			CLM_AgrmntCustomActionsCtrl.createAgrmntTeamFromOpty(opportunities[0].Id, agreements[0].Id);
			
			Contact c = new Contact(FirstName = 'CLM', LastName= 'Services', email='test.ext@nokia.com');
			insert c; 
		   
			opportunities[0].stageName = 'Create Offer (Bid)';
			opportunities[0].Phase_Status__c=GlobalConstants.SUBMITTED_FOR_G4_APPROVAL;
			opportunities[0].Apttus_Approval__Approval_Status__c='Pending Approval';
			opportunities[0].ApprovalStatusTechField__c='Approved G2,Approved G3';
			opportunities[0].NF_Facilitator_User__c=userInfo.getUserId();
			opportunities[0].Facilitator_Delegate_1__c=userInfo.getUserId();
			opportunities[0].Facilitator_Delegate_2__c=userInfo.getUserId();
			opportunities[0].Facilitator_Delegate_3__c=userInfo.getUserId();
			opportunities[0].CLM_Contract_Request_Type__c='New Contract';
			checkRecursive.run = true;
			update opportunities[0];
			delete agreemntTeam[0];
			test.stopTest();
			
		}
	}
	
	public static testmethod void l2dTriggerActions() {
		
		CLM_L2D_Trigger__c trg = new CLM_L2D_Trigger__c();
		trg.CLM_Trigger_Name__c = 'L2D Trigger';
		trg.CLM_LoA_Level__c = 'A';
		trg.CLM_Status__c = 'Active';
		trg.CLM_L2DTrigger__c = 'YES';
		trg.CLM_Category__c = 'Assignment';
		trg.CLM_Subcategory__c = 'Right to assign agreement';
		insert trg;
		
		L2D_Trigger_Answer__c ans = new L2D_Trigger_Answer__c();
		ans.Answer__c = 'L2D Answer';
		ans.Help__c = 'L2d Help';
		ans.L2D_Trigger__c = trg.Id;
		ans.Level__c = 'A';
		insert ans;
		Account account = getAccount();
		List<Opportunity> opportunities = getOpportunities();
		List<Id> ownerIds = new List<Id>();
		for(Opportunity opp:opportunities){
			ownerIds.add(opp.OwnerId);
		}
		List<Apttus__APTS_Agreement__c> agreements = createAgreements(account, opportunities);
		agreements[2].RecordTypeId =Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByDeveloperName().get('NDA').getRecordTypeId();
		test.startTest();
		insert agreements; 
		
		List<Apttus__APTS_Agreement__c> agrmntLst = [Select id,OwnerId,CLM_Request_Number__c,Apttus__Status__c,Apttus__Account__c,Apttus__Account__r.Name,
													 Apttus__Status_Category__c FROM Apttus__APTS_Agreement__c limit 2];
		
		
		CLM_AgrmntCustomActionsCtrl.updateExistingCtrct(agrmntLst[0].Id, agrmntLst[0].Id, opportunities[0].Id);
		agrmntLst[0].Apttus__Agreement_Number__c = '555';
		agrmntLst[0].Apttus__Version_Number__c = 0;
		agrmntLst[1].Apttus__Status__c = 'In Amendment';
		agrmntLst[1].Apttus__Status_Category__c = 'Request';
		agrmntLst[1].Apttus__Agreement_Number__c = '555';
		agrmntLst[1].Apttus__Version_Number__c = 1;
		
		update agrmntLst;
		
		Apttus__Agreement_Clause__c cluse = new Apttus__Agreement_Clause__c();
		cluse.Apttus__Agreement__c = agrmntLst[0].Id;
		cluse.Apttus__Category__c = 'Assignment';
		cluse.Apttus__Subcategory__c = 'Right to assign agreement';
		cluse.Apttus__Action__c = 'Inserted';
		cluse.CLM_Question__c = trg.Id;
		insert cluse;
		
		cluse.Apttus__Status__c = 'Signed';
		update cluse;
		
		Apttus__APTS_Template__c temp = new Apttus__APTS_Template__c(Name ='CLM Generic Quote Template123',
																	 Apttus__Type__c='Agreement',
																	 Apttus__Agreement_Types__c = 'NDA',
																	 Apttus__IsActive__c=True,
																	CLM_Associated_Entity__c = agrmntLst[0].Apttus__Account__c);
		insert temp;
		
		
		
		
		try{
			CLM_AgrmntCustomActionsCtrl.getL2DAnswers(cluse.Id,trg.Id);
			CLM_AgrmntCustomActionsCtrl.getNonL2DAnswer(cluse.Id);
		}catch(Exception e){
			
		}
		CLM_AgrmntCustomActionsCtrl.saveNonL2DTriggerAnswer('TEST', cluse.Id);
		CLM_AgrmntCustomActionsCtrl.saveTriggerAnswer(Json.serialize(ans),cluse.Id);
		CLM_AgrmntCustomActionsCtrl.saveTriggerAnswer(Json.serialize(ans),temp.Id);
		Account acc = new Account();
		acc.Name = 'Test Account - NDA-'+system.today() ;
		acc.BillingStreet = '1660 International Dr';
		acc.BillingCity = 'McLean';
		acc.BillingState = 'maharashtra';
		acc.BillingPostalCode = '22102';
		acc.BillingCountry = 'india';
		acc.AccountStatusInCRMOM__c = 'Active';
		acc.Industry = 'Enterprise';
		acc.Market__c = 'Market India';
		acc.Country__c = 'India';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(CSWXGlobalConstant.DS_legalEntity).getRecordTypeId();
		acc.Default_Legal_Entity__c = true;
		acc.Parentid = account.Id;
		acc.Active__c = true;
		insert acc;
		  test.stopTest();
			
	}
	
	public static testmethod void l2dTriggerActions2() {
		
		
		Account account = getAccount();
		List<Opportunity> opportunities = getOpportunities();
		List<Id> ownerIds = new List<Id>();
		for(Opportunity opp:opportunities){
			ownerIds.add(opp.OwnerId);
		}
		List<Apttus__APTS_Agreement__c> agreements = createAgreements(account, opportunities);
		agreements[2].RecordTypeId =Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByDeveloperName().get('NDA').getRecordTypeId();
		test.startTest();
		insert agreements; 
		
		List<Apttus__APTS_Agreement__c> agrmntLst = [Select id,OwnerId,CLM_Request_Number__c,Apttus__Status__c,Apttus__Account__c,Apttus__Account__r.Name,
													 Apttus__Status_Category__c FROM Apttus__APTS_Agreement__c limit 2];
		
		
		CLM_AgrmntCustomActionsCtrl.updateExistingCtrct(agrmntLst[0].Id, agrmntLst[0].Id, opportunities[0].Id);
		agrmntLst[0].Apttus__Agreement_Number__c = '555';
		agrmntLst[0].Apttus__Version_Number__c = 0;
		
		Apttus__APTS_Template__c temp = new Apttus__APTS_Template__c(Name ='CLM Generic Quote Template123',
																	 Apttus__Type__c='Agreement',
																	 Apttus__Agreement_Types__c = 'NDA',
																	 Apttus__IsActive__c=True,
																	CLM_Associated_Entity__c = agrmntLst[0].Apttus__Account__c);
		insert temp;
		
		
		ApexPages.StandardController sc = new ApexPages.StandardController(agrmntLst[0]);
		CLM_AgrmntCustomActionsCtrl ctrller = new CLM_AgrmntCustomActionsCtrl(sc);
		Apttus__DocumentVersionDetail__c docVer = CLM_AgrmntCustomActionsCtrl.generateNDADoc(JSON.serialize(agrmntLst[0]),agrmntLst[0].Apttus__Account__r.Name,'');
		Apttus__DocumentVersion__c docVerss = [SELECT Id,Apttus__TemplateId__c From Apttus__DocumentVersion__c WHERE Id =:docVer.Apttus__DocumentVersionId__c];
		system.assert(docVer.Apttus__DocumentVersionId__c != null);
	  
		PageReference pageRef = Page.CLM_CallApttusAPI;
		pageRef.getParameters().put('Id', String.valueOf(agrmntLst[0].Id));
		pageRef.getParameters().put('docVersionId', String.valueOf(docVer.Id));
		pageRef.getParameters().put('docVersTempId', String.valueOf(docVer.Apttus__DocumentVersionId__c));
		Test.setCurrentPage(pageRef);
		ctrller.agrId = agrmntLst[0].Id;
		ctrller.docVerId = docVer.Id;
		ctrller.docVertempId = docVer.Apttus__DocumentVersionId__c;
		ctrller.generateDocument();
		 test.stopTest();
	   
		
	}
	
	public static testmethod void customActionsMethod2() {
		
		Account account = getAccount();
		List<Opportunity> opportunities = getOpportunities();
		List<Id> ownerIds = new List<Id>();
		for(Opportunity opp:opportunities){
			ownerIds.add(opp.OwnerId);
		}
		List<Apttus__APTS_Agreement__c> agreements = createAgreements(account, opportunities);
		agreements[2].RecordTypeId =Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByDeveloperName().get('NDA').getRecordTypeId();
		 test.startTest();
		insert agreements; 
		
		List<Apttus__APTS_Agreement__c> agrmntLst = [Select id,OwnerId,CLM_Request_Number__c,Apttus__Status__c,
													 Apttus__Status_Category__c FROM Apttus__APTS_Agreement__c limit 2];
		
	   
		CLM_AgrmntCustomActionsCtrl.updateExistingCtrct(agrmntLst[0].Id, agrmntLst[0].Id, opportunities[0].Id);
		agrmntLst[0].Apttus__Agreement_Number__c = '555';
		agrmntLst[0].Apttus__Version_Number__c = 0;
		 
		agrmntLst[1].Apttus__Status__c = 'In Amendment';
		agrmntLst[1].Apttus__Status_Category__c = 'Request';
		agrmntLst[1].Apttus__Agreement_Number__c = '555';
		agrmntLst[1].Apttus__Version_Number__c = 1;
		
		update agrmntLst;
	   
		Account acc = new Account();
		acc.Name = 'Test Account - NDA-'+system.today() ;
		acc.BillingStreet = '1660 International Dr';
		acc.BillingCity = 'McLean';
		acc.BillingState = 'maharashtra';
		acc.BillingPostalCode = '22102';
		acc.BillingCountry = 'india';
		acc.AccountStatusInCRMOM__c = 'Active';
		acc.Industry = 'Enterprise';
		acc.Market__c = 'Market India';
		acc.Country__c = 'India';
		acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(CSWXGlobalConstant.DS_legalEntity).getRecordTypeId();
		acc.Default_Legal_Entity__c = true;
		acc.Parentid = account.Id;
		acc.Active__c = true;
		
		CLM_AgrmntCustomActionsCtrl.getDefaultAccountFromHierarchy(account.Id);
		test.stopTest();
		Map<Id,User> userMap = new Map<Id,User>([SELECT Name,Email from User WHERE Id IN:ownerIds ]);
		
		CLM_AgrmntCustomActionsCtrl.userSearchWrapper userWrap = CLM_AgrmntCustomActionsCtrl.createAgreementTeamRecd(userInfo.getUserId(), agreements[0].Id);
		CLM_AgrmntCustomActionsCtrl.userSearchWrapper userWrap2 = CLM_AgrmntCustomActionsCtrl.createAgreementTeamRecd(userInfo.getUserId(), opportunities[0].Id);
		CLM_AgrmntCustomActionsCtrl.userSearchWrapper userWrap3 = CLM_AgrmntCustomActionsCtrl.createAgreementTeamRecd(userInfo.getUserId(), opportunities[2].Id);
		CLM_AgrmntCustomActionsCtrl.getRecordTypeInfo('ContractRequest', CLM_GlobalConstants.agrmntAPIName);
		CLM_AgrmntCustomActionsCtrl.updateExistingCtrct(agreements[0].Id, agreements[0].Id, opportunities[0].Id);
		CLM_OpportunityTriggerHelper.sendEmailToAM(opportunities,userMap);
		CLM_OpportunityTriggerHelper.sendEmailToOptyOwner(opportunities,userMap);
		
		
	}
	
	public static testmethod void agrmntActivationNDA() {
		
		List<Apttus__APTS_Agreement__c> agrmntLst = [Select id,OwnerId,CLM_Request_Number__c,Apttus__Status__c,
													 Apttus__Status_Category__c FROM Apttus__APTS_Agreement__c limit 1];
		Apttus__DocumentVersion__c dv = new Apttus__DocumentVersion__c(Apttus__AgreementId__c=agrmntLst[0].Id,
																	   Apttus__DocumentType__c = 'Executed Document',
																	   Apttus__LatestVersion__c = '1.0.0',
																	   Apttus__IsTransient__c =false,
																	   Apttus__Title__c = 'TestDocument.pdf' );
		 test.startTest();
		ContentDocumentLinkHandler.isConfidentialRecCreated = true;
		insert dv;
		
		ContentVersion contentVersion = new ContentVersion(
			Title	  = 'Test Document',
			PathOnClient   = 'TestDocument.pdf',
			VersionData  = Blob.valueOf('Test Content'),
			IsMajorVersion = true);
		insert contentVersion;
		
		List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument  limit 1];
		
		Apttus__DocumentVersionDetail__c docDet = new Apttus__DocumentVersionDetail__c(Apttus__DocumentVersionId__c = dv.Id, Apttus__ContentId__c = documents[0].Id,
																					   Apttus__Title__c ='TestDocument.pdf', Apttus__VersionMajor__c=1, Apttus__VersionMinor__c=0, Apttus__VersionRevision__c=0);
		insert docDet;
		
		dv.Apttus__LatestVersionId__c = docDet.Id;
		update dv;
		
		agrmntLst[0].Apttus__Status__c = 'Fully Signed';
		agrmntLst[0].RecordTypeId =Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByDeveloperName().get('NDA').getRecordTypeId();
		
		update agrmntLst;
		test.stopTest();
	}
	public static testmethod void agrmntActivationNonNDA() {
		
		List<Apttus__APTS_Agreement__c> agrmntLst = [Select id,OwnerId,CLM_Request_Number__c,Apttus__Status__c,
													 Apttus__Status_Category__c FROM Apttus__APTS_Agreement__c limit 1];
		Apttus__DocumentVersion__c dv = new Apttus__DocumentVersion__c(Apttus__AgreementId__c=agrmntLst[0].Id,
																	   Apttus__DocumentType__c = 'Executed Document',
																	   Apttus__LatestVersion__c = '1.0.0',
																	   Apttus__IsTransient__c =false,
																	   Apttus__Title__c = 'TestDocument.pdf' );
		test.startTest();
		ContentDocumentLinkHandler.isConfidentialRecCreated = true;
		insert dv;
		
		ContentVersion contentVersion = new ContentVersion(
			Title	  = 'Test Document',
			PathOnClient   = 'TestDocument.pdf',
			VersionData  = Blob.valueOf('Test Content'),
			IsMajorVersion = true);
		insert contentVersion;
		
		List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument  limit 1];
		
		
		Apttus__DocumentVersionDetail__c docDet = new Apttus__DocumentVersionDetail__c(Apttus__DocumentVersionId__c = dv.Id, Apttus__ContentId__c = documents[0].Id,
																					   Apttus__Title__c ='TestDocument.pdf', Apttus__VersionMajor__c=1, Apttus__VersionMinor__c=0, Apttus__VersionRevision__c=0);
		insert docDet;
		
		dv.Apttus__LatestVersionId__c = docDet.Id;
		update dv;
		
		agrmntLst[0].Apttus__Status__c = 'Fully Signed';
		agrmntLst[0].RecordTypeId =Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByDeveloperName().get('SSA').getRecordTypeId();
		
		update agrmntLst;
		
		test.stopTest();
	}
	
	public static testmethod void createCluaseRecord() {
		test.startTest();
		Account account = getAccount();
		List<Opportunity> opportunities = getOpportunities();
		List<Id> ownerIds = new List<Id>();
		for(Opportunity opp:opportunities){
			ownerIds.add(opp.OwnerId);
		}
		List<Apttus__APTS_Agreement__c> agreements = createAgreements(account, opportunities);
		insert agreements;
		Apttus__Agreement_Clause__c cluse = new Apttus__Agreement_Clause__c();
		cluse.Apttus__Agreement__c = agreements[0].Id;
		cluse.Apttus__Action__c = 'Inserted';
		insert cluse;
		
		Apttus__Agreement_Clause__c cluse1 = new Apttus__Agreement_Clause__c();
		cluse1.Apttus__Agreement__c = agreements[0].Id;
		cluse1.Apttus__Action__c = 'Modified';
		cluse1.Apttus__PrimordialVersionId__c = cluse.Id;
		insert cluse1;
		CLM_AgrmntCustomActionsCtrl.reactivateContract(JSON.Serialize(agreements[0]),system.today());
		test.stopTest();
	}
	
	private static List<Apttus__APTS_Agreement__c> createAgreements(Account account, List<Opportunity> opportunities) {
		// AGREEMENTS
		List<Apttus__APTS_Agreement__c> agreements = new List<Apttus__APTS_Agreement__c>();
		for (Integer i = 0; i < opportunities.size(); i++) {
			Apttus__APTS_Agreement__c a = new Apttus__APTS_Agreement__c();
			a.RecordTypeId =Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByDeveloperName().get('ContractRequest').getRecordTypeId();
			a.Name = 'Test Agreement ' + (i+1);
			a.Apttus__Account__c = account.Id;
			a.CurrencyIsoCode = 'EUR';
			a.Delivery_System__c = 'Scratch Order via P20';
			a.ERP__c = 'P20';
			a.Sales_Mode__c = 'Corporate Sales Mode';
			a.Confidence_Level__c = 'Low Level';
			a.Lead_BG__c = '';
			a.Apttus__Related_Opportunity__c = opportunities[i].Id;
			a.Apttus__Requestor__c = userInfo.getUserId();
			a.CLM_Contract_Category__c = 'Non-Transactional (NDA, LOI, MOU etc.)';
			agreements.add(a);
		}
		return agreements;
	}
	
	private static List<CLM_Agreement_Team__c> createAgreementTeams(List<Apttus__APTS_Agreement__c> agrmntLst) {
		// AGREEMENTS
		List<CLM_Agreement_Team__c> agreementTeamLst = new List<CLM_Agreement_Team__c>();
		for (Integer i = 0; i < agrmntLst.size(); i++) {
			CLM_Agreement_Team__c t = new CLM_Agreement_Team__c();
			t.CLM_Team_Member_Role__c = 'Commercial Contract Manager (L&C)';
			t.CLM_Agreement_Access__c = CLM_GlobalConstants.Access_Read;
			t.CLM_Team_Member__c = userInfo.getUserId();
			t.CLM_Agreement__c = agrmntLst[i].Id;
			agreementTeamLst.add(t);
			CLM_Agreement_Team__c t1 = new CLM_Agreement_Team__c();
			t1.CLM_Team_Member_Role__c = 'Account Manager (TRICORN Sales Case Owner (SCO))';
			t1.CLM_Agreement_Access__c = CLM_GlobalConstants.Access_Read;
			t1.CLM_Team_Member__c = userInfo.getUserId();
			t1.CLM_Agreement__c = agrmntLst[i].Id;
			
			agreementTeamLst.add(t1);
		}
		return agreementTeamLst;
	}
	
	private static Account getAccount() {
		return [SELECT Id,Name FROM Account LIMIT 1];
	}
	
	private static List<Opportunity> getOpportunities() {
		return [SELECT Id, Lead_BG__c, Description, Amount, Account_Role__c,Opportunity_ID__c,CLM_Contract_Request_Type__c, End_Customer__c,OwnerId,Name FROM Opportunity];
	}
}