/****************************************
* Name : DS_UserTrigger_HelperTest
* Author : Accenture

*****************************************/
@isTest
Private class DS_UserTrigger_HelperTest{

   /******************************
	*Method Name: getAccountAttchmentTest
	*Description: Test Method to cover DS_ExecSummaryTest class
	********************************/
static testmethod void UserShareTest(){
try{
	  User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){
		
		DS_Customer_Permission_Set__c dsp = new DS_Customer_Permission_Set__c();
		dsp.Name = 'DS_Digital_Sales_Customer';
		 dsp.ProfileName__c= 'Digital Sales Customer Profile';
		insert dsp; 
		
	   
			  
	  
		 DS_User_Profile_config_for_User_Sharing__c userProfile= new DS_User_Profile_config_for_User_Sharing__c();
		userProfile.Name = 'Digital Sales Customer Profile';
		database.insert(userProfile);  
		   
		 Account accountCreationDP = TestDataFactory.createAccount(1)[0];
		accountCreationDP.DMP_Account__c =  true;
		database.insert(accountCreationDP);
		 System.debug('accountCreationDP>>>>'+accountCreationDP); 
			
			
		Account accLegalEntity = TestDataFactory.createAccount(1)[0];
		accLegalEntity.AccountNumber='100006843';
		accLegalEntity.ParentId=accountCreationDP.id;
		accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
		database.insert(accLegalEntity);
			
		   
			
		Test.startTest();
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;
		
		
		User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
		database.insert(user1); 
		
	   
		List<Contact> ContactList = new List<Contact>();
		Contact conDS = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accountCreationDP.id,Email=CSWXGlobalConstant.EmailContactNameDS );
		Contact conDS2 = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accountCreationDP.id,Email=CSWXGlobalConstant.EmailContactNameDS );
		ContactList.add(conDS);
		ContactList.add(conDS2);
		database.insert(ContactList);
			System.debug('ContactList'+ContactList);
		
		User userDS = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
								 languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = '00e41000001yV28' /*00e410000022ds8'system.Label.PRM_Partner_Relationship_Manager_Login_ID*/,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
								 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '00',ContactId  = conDS.Id );
		
		
		  system.runAs(user1){						
		database.insert(userDS); 
		
		userDS.IsPortalEnabled =  True;
		//userDS.UserType='PowerCustomerSuccess';
		database.update(userDS);
			  System.debug('userDS>>>>'+userDS);
		Map<Id,User> userMap = new Map<Id,User>();
		userMap.put(userDS.Id, userDS); 
			  
		SWx_Upsell_Proposal__c upsellProposal_SWX= new SWx_Upsell_Proposal__c(); 
		upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
		upsellProposal_SWX.Analytics_Source__c='CXM';
		upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
		//upsellProposal_SWX.P20_Id__c=215616;
		upsellProposal_SWX.Sold_To_Party__c = accLegalEntity.id;
		upsellProposal_SWX.CurrencyIsoCode='EUR';
		//upsellProposal_SWX.Unweighted_Value__c=429052.07;
		upsellProposal_SWX.Account_ID__c=accountCreationDP.id;
		database.insert(upsellProposal_SWX); 
			  
		system.debug('upsellProposal_SWX>>>>>>>>>>'+upsellProposal_SWX);
		//opty Insertion
		 Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
		Opportunity oppty ;
		oppty = TestDataFactory.OpportunityCreation(1,accountCreationDP)[0];
		oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
		oppty.RecordTypeId=RecordTypeId;
		oppty.SWx_Upsell_Proposal__c =upsellProposal_SWX.Id;
		oppty.Lead_BG__c ='MN';
		oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
			  
	   // insert new File_Sharing_Custom_Setting__c(Name = GlobalConstants.OPPORTUNITY_DOC_FREEZE_STAGE,Value__c='7');
		database.insert(oppty);
	   system.debug('oppty>>>>>>>>>>>>>'+oppty);
			  
		Apttus_Proposal__Proposal__c proposal = TestDataFactory.createProposal(1)[0];
		proposal.Apttus_Proposal__Account__c = accountCreationDP.Id;
		proposal.Apttus_Proposal__Opportunity__c = oppty.id; 
		proposal.SWx_Upsell_Proposal__c= upsellProposal_SWX.Id;  
		proposal.Apttus_Proposal__Approval_Stage__c='Draft';
		proposal.NokiaCPQ_SSP_Level__c = 'Unlimited';
		proposal.NokiaCPQ_Portfolio__c ='IP Routing';
		//proposal.LOA_Status__c = 'Approved';
		proposal.Sold_To_Party__c = accLegalEntity.id;
		proposal.Changed_Approval_Stage__c = true;
		//proposal.isCQ__c = false;
		database.insert(proposal);
		  
		 proposal.Apttus_Proposal__Approval_Stage__c='In Review';   
		 proposal.LOA_Status__c = 'G4 Submission';	 
		 database.update(proposal);	 
		 proposal.Apttus_Proposal__Approval_Stage__c='Approved';		
		  proposal.LOA_Status__c = 'Approved'; 
		  database.update(proposal);	  
		System.debug('Quote type>>>'+proposal.Quote_Type__c);
			  
	  Apttus_Proposal__Proposal__c objProp = [Select Id,Apttus_Proposal__Opportunity__r.RecordType.Name/*,isCQ__c*/ from  
	 Apttus_Proposal__Proposal__c 
	 where Id =:proposal.Id];
		
	   /* Created new */
				  /*Apttus_Proposal__Proposal__Share objPropShare = new Apttus_Proposal__Proposal__Share();
								objPropShare.ParentId = proposal.Id;
								objPropShare.UserOrGroupId = user1.Id;
								objPropShare.AccessLevel = 'Read';
								insert objPropShare;*/
			  
			   
			 
			  
		  PermissionSet ps = [SELECT ID From PermissionSet WHERE Name = 'DS Digital Sales Customer'];
		insert new PermissionSetAssignment(AssigneeId = userDS.id, PermissionSetId = ps.Id);   
		
		
	   
			  
		}
	Test.stopTest();
	   
			
		
	   ContentVersion contentVersion = new ContentVersion();
		ContentDocumentLink contentlink = new ContentDocumentLink();
	 
		
		contentVersion = TestDataFactory.createContentVersion(1)[0]; 
		contentVersion.title = 'Executive Summary';
		database.insert(contentVersion) ;					 
		
		Id theContentDocumentId = [select ContentDocumentId from ContentVersion where Id =: contentVersion.Id limit 1].ContentDocumentId;		
		
		contentlink = TestDataFactory.createContentDocumentLink(1,accountCreationDP.Id, theContentDocumentId)[0];
		database.insert(contentlink) ;  
	 
		
			
	  System.runAs(userDS) {
	  
			DS_ExecSummary.getCurrentUserData();
			DS_ExecSummary.getAccountAttachment(); 
		}
			DS_UserTrigger_Helper.shareCustomerUserWithAM(null);
		DS_UserTrigger_Helper.shareCustomerUserWithPublicGroup(null);
		DS_UserTrigger_Helper.shareDSQuoteWithNewlyCreatedCustomer(null);
			
		 }
		 
	}catch (Exception ex) { ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_TabRenderingTest,CSWXGlobalConstant.createTestDP);
			
	   } 
   //list<Apttus_Proposal__Proposal__c> proposal = TestDataFactory.createProposal(1);

  
	
	}
	
	/******************************
	*Method Name: getAccountAttchmentNegativeTest
	*Description: Test Method to cover DS_ExecSummaryTest getAccountAttchment methods' catch block
	********************************/	
   static testmethod void getAccountAttchmentNegativeTest(){
			   
		Account accObj = TestDataFactory.createAccount(1)[0]; 
		accObj.AccountNumber = '30100596190';
		database.insert(accObj);

  
		Contact contact_1 = new Contact(AccountId = accObj.Id, LastName = 'xgeek');
		insert contact_1;
		  
		User user = TestDataFactory.userCreation(1,'System Administrator')[0]; 
		
		insert user;	   
		system.runAs(user){
		DS_ExecSummary.getCurrentUserData();
		DS_ExecSummary.getAccountAttachment(); 
			
		   }
		   }   
}