/******************************************************************************************************
Name : DS_OpportunityTeamHandlerTest
Created Date: 14 Feb 2019
Created by: Accenture
Description : This Test class of OpportunityTeamHandlerDS 
*********************************************************************************************************/

@isTest
private with sharing class DS_OpportunityTeamHandlerTest{


	Public Static Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();
	public static Id swxRecordTypeId = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get('SWx Upsell Proposal').getRecordTypeId();
	public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();


	
	static testmethod void InsertOTMTest(){
	  
			try{
			
			//Account Insertion
			Account accLegalEntity = TestDataFactory.createAccount(1)[0];
			accLegalEntity.AccountNumber='100006843';
			accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(accLegalEntity);
			
			
			Account accountCreationDP = TestDataFactory.createAccount(1)[0];
			accountCreationDP.L4Name__c = 'TESTTerritory'; 
			database.insert(accountCreationDP);
	  
			// DP
			SWx_Upsell_Proposal__c upsellProposal_SWX= new SWx_Upsell_Proposal__c(); //TestDataFactory.upsellList(1,accountCreationDP)[0];
			upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
			upsellProposal_SWX.Analytics_Source__c='CXM';
			upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
			upsellProposal_SWX.P20_Id__c=215616;
			upsellProposal_SWX.Sold_To_Party__c = accLegalEntity.id;
			upsellProposal_SWX.CurrencyIsoCode='EUR';
			upsellProposal_SWX.Unweighted_Value__c=429052.07;
			upsellProposal_SWX.Account_ID__c=accLegalEntity.id;
			upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
			
			database.insert(upsellProposal_SWX);
			 
			 //opty Insertion
			Opportunity oppty ;
			oppty = TestDataFactory.OpportunityCreation(1,accountCreationDP)[0];
			oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			oppty.RecordTypeId=RecordTypeId;
			oppty.SWx_Upsell_Proposal__c =upsellProposal_SWX.Id;
			oppty.Lead_BG__c ='MN';
			oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
		   
			database.insert(oppty);
			
			
			
			//Price List 
			Apttus_Config2__PriceList__c priceList= TestdataFactory.priceList(1)[0];
			database.insert(priceList);
		   
			
			//quote
			
			//Quote Insertion	
			Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
			quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
			quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
			quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
			quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
			
			quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
			quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
			quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
			quoteProposal2.Prices_Aligned__c=true;
			quoteProposal2.Apttus_Proposal__Account__c=accountCreationDP.id;
			 quoteProposal2.Sold_To_Party__c = accLegalEntity.id;
			 
			 quoteProposal2.DSPricingManager__c=null;
			 quoteProposal2.DSSolutionManager__c=null;
	 
			database.insert(quoteProposal2); 
			
			
			
			String orgId = UserInfo.getOrganizationId();
					String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
					Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
					String uniqueName =   dateString + randomInt;
			
			
					User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
										  languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
										  timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
					
					
					insert user1;
			
			
			List<Sales_Role__c> srList = new List<Sales_Role__c>();
			Sales_Role__c sr = new Sales_Role__c();
			sr.Organisation__c = 'TESTTerritory';
			sr.User__c = user1.id;
			sr.Role_Name__c = Label.DS_CSM_Role_Name;
			sr.BG__c = 'MN';
			sr.Role_Code__c = 'NSNC_PrMBG';
			srList.add(sr);
			insert srList;
			
			Test.startTest();
			
			 OpportunityTeamMember OTM = new OpportunityTeamMember();
			
			OTM.UserId = userinfo.getuserid();
			OTM.OpportunityId =oppty.id;
			OTM.TeamMemberRole = 'Solution Manager';
			OTM.OpportunityAccessLevel ='Edit';
			
			insert OTM;
			
			
			OpportunityTeamMember OTM2 = new OpportunityTeamMember();
			
			OTM2.UserId = user1.id ;
			OTM2.OpportunityId =oppty.id;
			OTM2.TeamMemberRole = 'Pricing Manager';
			OTM2.OpportunityAccessLevel ='Edit';
			
			insert OTM2;
			
		   Test.StopTest();
		   }catch(Exception e){
				ExceptionHandler.addException(e,CSWXGlobalConstant.DS_OpportunityTeamHandlerTest,CSWXGlobalConstant.InsertOTMTest );
			}
	
	}
	
	
	static testmethod void DeleteOTMTest(){
	  
			try{
			
			//Account Insertion
			Account accLegalEntity = TestDataFactory.createAccount(1)[0];
			accLegalEntity.AccountNumber='100006843';
			accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(accLegalEntity);
			
			
			Account accountCreationDP = TestDataFactory.createAccount(1)[0];
			accountCreationDP.L4Name__c = 'TESTTerritory'; 
			database.insert(accountCreationDP);
	  
			// DP
			SWx_Upsell_Proposal__c upsellProposal_SWX= new SWx_Upsell_Proposal__c(); //TestDataFactory.upsellList(1,accountCreationDP)[0];
			upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
			upsellProposal_SWX.Analytics_Source__c='CXM';
			upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
			upsellProposal_SWX.P20_Id__c=215616;
			upsellProposal_SWX.Sold_To_Party__c = accLegalEntity.id;
			upsellProposal_SWX.CurrencyIsoCode='EUR';
			upsellProposal_SWX.Unweighted_Value__c=429052.07;
			upsellProposal_SWX.Account_ID__c=accLegalEntity.id;
			upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
			database.insert(upsellProposal_SWX);
			 
			 //opty Insertion
			Opportunity oppty ;
			oppty = TestDataFactory.OpportunityCreation(1,accountCreationDP)[0];
			oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			oppty.RecordTypeId=RecordTypeId;
			oppty.SWx_Upsell_Proposal__c =upsellProposal_SWX.Id;
			oppty.Lead_BG__c ='MN';
			oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
		   
			database.insert(oppty);
			
			
		   
			
			//Price List 
			Apttus_Config2__PriceList__c priceList= TestdataFactory.priceList(1)[0];
			database.insert(priceList);
			
			//Quote Insertion	
			Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
			quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
			quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
			quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
			quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
			
			quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
			quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
			quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
			quoteProposal2.Prices_Aligned__c=true;
			quoteProposal2.Apttus_Proposal__Account__c=accountCreationDP.id;
			 quoteProposal2.Sold_To_Party__c = accLegalEntity.id;
			
			 quoteProposal2.DSPricingManager__c=null;
			 quoteProposal2.DSSolutionManager__c=null;
			database.insert(quoteProposal2); 
			
			 OpportunityTeamMember OTM = new OpportunityTeamMember();
		   
			OTM.UserId = userinfo.getuserid();
			OTM.OpportunityId =oppty.id;
			OTM.TeamMemberRole = 'Solution Manager';
			OTM.OpportunityAccessLevel ='Edit';
			
			insert OTM;
			
			delete OTM;
	
		}catch(Exception e){
				ExceptionHandler.addException(e,CSWXGlobalConstant.DS_OpportunityTeamHandlerTest,CSWXGlobalConstant.DeleteOTMTest);
			}
	}
	
	
	static testmethod void UpdateOTMTest(){
	  
			try{
			
			//Account Insertion
			Account accLegalEntity = TestDataFactory.createAccount(1)[0];
			accLegalEntity.AccountNumber='100006843';
			accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(accLegalEntity);
			
			
			Account accountCreationDP = TestDataFactory.createAccount(1)[0];
			accountCreationDP.L4Name__c = 'TESTTerritory'; 
			database.insert(accountCreationDP);
	  
			// DP
			SWx_Upsell_Proposal__c upsellProposal_SWX= new SWx_Upsell_Proposal__c(); //TestDataFactory.upsellList(1,accountCreationDP)[0];
			upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
			upsellProposal_SWX.Analytics_Source__c='CXM';
			upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
			upsellProposal_SWX.P20_Id__c=215616;
			upsellProposal_SWX.Sold_To_Party__c = accLegalEntity.id;
			upsellProposal_SWX.CurrencyIsoCode='EUR';
			upsellProposal_SWX.Unweighted_Value__c=429052.07;
			upsellProposal_SWX.Account_ID__c=accLegalEntity.id;
			upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
			database.insert(upsellProposal_SWX);
			 
			 //opty Insertion
			Opportunity oppty ;
			oppty = TestDataFactory.OpportunityCreation(1,accountCreationDP)[0];
			oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			oppty.RecordTypeId=RecordTypeId;
			oppty.SWx_Upsell_Proposal__c =upsellProposal_SWX.Id;
			oppty.Lead_BG__c ='MN';
			oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
		   
			database.insert(oppty);
			
			
			String orgId = UserInfo.getOrganizationId();
					String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
					Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
					String uniqueName =   dateString + randomInt;
			
			
					User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
										  languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
										  timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
					
					
					insert user1;
			
			
			List<Sales_Role__c> srList = new List<Sales_Role__c>();
			Sales_Role__c sr = new Sales_Role__c();
			sr.Organisation__c = 'TESTTerritory';
			sr.User__c = user1.id;
			sr.Role_Name__c = Label.DS_CSM_Role_Name;
			sr.BG__c = 'MN';
			sr.Role_Code__c = 'NSNC_PrMBG';
			srList.add(sr);
			insert srList;
			
			
		   
			
			//Price List 
			Apttus_Config2__PriceList__c priceList= TestdataFactory.priceList(1)[0];
			database.insert(priceList);
			
			//Quote Insertion	
			Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
			quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
			quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
			quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
			quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
			
			quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
			quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
			quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
			quoteProposal2.Prices_Aligned__c=true;
			quoteProposal2.Apttus_Proposal__Account__c=accountCreationDP.id;
			 quoteProposal2.Sold_To_Party__c = accLegalEntity.id;
			 
			 quoteProposal2.DSPricingManager__c=null;
			 quoteProposal2.DSSolutionManager__c=null;
			database.insert(quoteProposal2); 
			
			  Test.startTest();
			
			 OpportunityTeamMember OTM = new OpportunityTeamMember();
			
			OTM.UserId = userinfo.getuserid();
			OTM.OpportunityId =oppty.id;
			OTM.TeamMemberRole = 'Solution Manager';
			OTM.OpportunityAccessLevel ='Edit';
			
			insert OTM;
			
			
			OpportunityTeamMember OTM2 = new OpportunityTeamMember();
		   
			OTM2.UserId = user1.id ;
			OTM2.OpportunityId =oppty.id;
			OTM2.TeamMemberRole = 'Pricing Manager';
			OTM2.OpportunityAccessLevel ='Edit';
			
			insert OTM2;
			
			OTM2.TeamMemberRole = 'Solution Manager';
			
			update OTM2;
	 
			
		   Test.StopTest();
			}catch(Exception e){
				ExceptionHandler.addException(e,CSWXGlobalConstant.DS_OpportunityTeamHandlerTest,CSWXGlobalConstant.InsertOTMTest );
			}
		  
	}
	
	
	
	static testmethod void UpdateOTMTest2(){
	  
			try{
			
			//Account Insertion
			Account accLegalEntity = TestDataFactory.createAccount(1)[0];
			accLegalEntity.AccountNumber='100006843';
			accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(accLegalEntity);
			
			
			Account accountCreationDP = TestDataFactory.createAccount(1)[0];
			accountCreationDP.L4Name__c = 'TESTTerritory'; 
			database.insert(accountCreationDP);
	  
			// DP
			SWx_Upsell_Proposal__c upsellProposal_SWX= new SWx_Upsell_Proposal__c(); //TestDataFactory.upsellList(1,accountCreationDP)[0];
			upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
			upsellProposal_SWX.Analytics_Source__c='CXM';
			upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
			upsellProposal_SWX.P20_Id__c=215616;
			upsellProposal_SWX.Sold_To_Party__c = accLegalEntity.id;
			upsellProposal_SWX.CurrencyIsoCode='EUR';
			upsellProposal_SWX.Unweighted_Value__c=429052.07;
			upsellProposal_SWX.Account_ID__c=accLegalEntity.id;
			upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
			database.insert(upsellProposal_SWX);
			 
			 //opty Insertion
			Opportunity oppty ;
			oppty = TestDataFactory.OpportunityCreation(1,accountCreationDP)[0];
			oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			oppty.RecordTypeId=RecordTypeId;
			oppty.SWx_Upsell_Proposal__c =upsellProposal_SWX.Id;
			oppty.Lead_BG__c ='MN';
			oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
		   
			database.insert(oppty);
			
			
			String orgId = UserInfo.getOrganizationId();
					String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
					Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
					String uniqueName =   dateString + randomInt;
			
			
					User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
										  languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
										  timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
					
					
					insert user1;
			
			
			List<Sales_Role__c> srList = new List<Sales_Role__c>();
			Sales_Role__c sr = new Sales_Role__c();
			sr.Organisation__c = 'TESTTerritory';
			sr.User__c = user1.id;
			sr.Role_Name__c = Label.DS_CSM_Role_Name;
			sr.BG__c = 'MN';
			sr.Role_Code__c = 'NSNC_PrMBG';
			srList.add(sr);
			insert srList;
			
			
		   
			
			//Price List 
			Apttus_Config2__PriceList__c priceList= TestdataFactory.priceList(1)[0];
			database.insert(priceList);
			
			//Quote Insertion	
			Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
			quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
			quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
			quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
			quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
			
			quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
			quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
			quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
			quoteProposal2.Prices_Aligned__c=true;
			quoteProposal2.Apttus_Proposal__Account__c=accountCreationDP.id;
			 quoteProposal2.Sold_To_Party__c = accLegalEntity.id;
			 
			 quoteProposal2.DSPricingManager__c=null;
			 quoteProposal2.DSSolutionManager__c=null;
			database.insert(quoteProposal2); 
			
			  Test.startTest();
			
			OpportunityTeamMember OTM = new OpportunityTeamMember();
			
			OTM.UserId = userinfo.getuserid();
			OTM.OpportunityId =oppty.id;
			OTM.TeamMemberRole = 'Solution Manager';
			OTM.OpportunityAccessLevel ='Edit';
			
			insert OTM;
			
			
			OpportunityTeamMember OTM2 = new OpportunityTeamMember();
			
			OTM2.UserId = user1.id ;
			OTM2.OpportunityId =oppty.id;
			OTM2.TeamMemberRole = 'Solution Manager';
			OTM2.OpportunityAccessLevel ='Edit';
			
			insert OTM2;
			
			OTM2.TeamMemberRole = 'Pricing Manager';
			
			update OTM2;
	 
			
		   Test.StopTest();
		   }catch(Exception e){
				ExceptionHandler.addException(e,CSWXGlobalConstant.DS_OpportunityTeamHandlerTest,CSWXGlobalConstant.UpdateOTMTest2 );
			}
			
		  
	}
	
	
	static testmethod void DeleteOTMTest2(){
	  
			
			try{
			//Account Insertion
			Account accLegalEntity = TestDataFactory.createAccount(1)[0];
			accLegalEntity.AccountNumber='100006843';
			accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(accLegalEntity);
			
			
			Account accountCreationDP = TestDataFactory.createAccount(1)[0];
			accountCreationDP.L4Name__c = 'TESTTerritory'; 
			database.insert(accountCreationDP);
	  
			// DP
			SWx_Upsell_Proposal__c upsellProposal_SWX= new SWx_Upsell_Proposal__c(); //TestDataFactory.upsellList(1,accountCreationDP)[0];
			upsellProposal_SWX.Analytics_File_Refer_ID__c='GBR-61940-82356';
			upsellProposal_SWX.Analytics_Source__c='CXM';
			upsellProposal_SWX.Proposal_Recommendation_Type__c='renewal';
			upsellProposal_SWX.P20_Id__c=215616;
			upsellProposal_SWX.Sold_To_Party__c = accLegalEntity.id;
			upsellProposal_SWX.CurrencyIsoCode='EUR';
			upsellProposal_SWX.Unweighted_Value__c=429052.07;
			upsellProposal_SWX.Account_ID__c=accLegalEntity.id;
			upsellProposal_SWX.RecordTypeID=swxRecordTypeId;
			database.insert(upsellProposal_SWX);
			 
			 //opty Insertion
			Opportunity oppty ;
			oppty = TestDataFactory.OpportunityCreation(1,accountCreationDP)[0];
			oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			oppty.RecordTypeId=RecordTypeId;
			oppty.SWx_Upsell_Proposal__c =upsellProposal_SWX.Id;
			oppty.Lead_BG__c ='MN';
			oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
		   
			database.insert(oppty);
			
			
			String orgId = UserInfo.getOrganizationId();
					String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
					Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
					String uniqueName =   dateString + randomInt;
			
			
					User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
										  languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
										  timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
					
					
					insert user1;
			
			
			List<Sales_Role__c> srList = new List<Sales_Role__c>();
			Sales_Role__c sr = new Sales_Role__c();
			sr.Organisation__c = 'TESTTerritory';
			sr.User__c = user1.id;
			sr.Role_Name__c = Label.DS_CSM_Role_Name;
			sr.BG__c = 'MN';
			sr.Role_Code__c = 'NSNC_PrMBG';
			srList.add(sr);
			insert srList;
			
			
		   
			
			//Price List 
			Apttus_Config2__PriceList__c priceList= TestdataFactory.priceList(1)[0];
			database.insert(priceList);
			
			//Quote Insertion	
			Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
			quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
			quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
			quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
			quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
			
			quoteProposal2.SWx_Upsell_Proposal__c=upsellProposal_SWX.Id;
			quoteProposal2.Analytics_Source__c  = CSWXGlobalConstant.AnalyticsSource;
			quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
			quoteProposal2.Prices_Aligned__c=true;
			quoteProposal2.Apttus_Proposal__Account__c=accountCreationDP.id;
			 quoteProposal2.Sold_To_Party__c = accLegalEntity.id;
			 
			 quoteProposal2.DSPricingManager__c=null;
			 quoteProposal2.DSSolutionManager__c=null;
			database.insert(quoteProposal2); 
			
			  Test.startTest();
			
			 OpportunityTeamMember OTM = new OpportunityTeamMember();
		   
			OTM.UserId = userinfo.getuserid();
			OTM.OpportunityId =oppty.id;
			OTM.TeamMemberRole = 'Solution Manager';
			OTM.OpportunityAccessLevel ='Edit';
			
			insert OTM;
			
			
			OpportunityTeamMember OTM2 = new OpportunityTeamMember();
			
			OTM2.UserId = user1.id ;
			OTM2.OpportunityId =oppty.id;
			OTM2.TeamMemberRole = 'Solution Manager';
			OTM2.OpportunityAccessLevel ='Edit';
			
			insert OTM2;
			
			OTM2.TeamMemberRole = 'Pricing Manager';
			
			update OTM2;
	 
			delete OTM2;
		   Test.StopTest();
		   
		   }catch(Exception e){
				ExceptionHandler.addException(e,CSWXGlobalConstant.DS_OpportunityTeamHandlerTest,CSWXGlobalConstant.DeleteOTMTest2);
			}
			
		  
	}
	






}