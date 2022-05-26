/*******************************
Class Name: DS_GetSMNPMTest
Created by: Accenture
Created Date: 2nd Aug 2019
Last modified by: Accenture
Description: Test class for DS_GetSMNPM
*******************************/

@isTest
private with sharing class DS_GetSMNPMTest{

Public Static Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(CSWXGlobalConstant.directOppty).getRecordTypeId();

public static Id swxQuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('SWx/CCRE Proposal').getRecordTypeId();

	static testMethod void JsonQuoteCreation(){
	

			Account accountCreationDP = TestDataFactory.createAccount(1)[0];
				   // accountCreationDP.L4Name__c = 'TESTTerritory'; 
			database.insert(accountCreationDP);
			
			
			//Account Insertion
			Account accLegalEntity = TestDataFactory.createAccount(1)[0];
			accLegalEntity.AccountNumber='100006843';
			accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			database.insert(accLegalEntity);
			
			
		   

			Opportunity oppty ;
 
			oppty = TestDataFactory.OpportunityCreation(1,accountCreationDP)[0];
			oppty.StageName = CSWXGlobalConstant.DEVELOP_OPPTY;
			oppty.RecordTypeId=RecordTypeId;
			oppty.Lead_BG__c ='MN';
			oppty.Phase_Status__c = CSWXGlobalConstant.Opty_phase_Status;
		   
			database.insert(oppty);
			
			
			 //Price List 
			Apttus_Config2__PriceList__c priceList= TestdataFactory.priceList(1)[0];
			database.insert(priceList);
			/*

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
			
		 */   
			
			Apttus_Proposal__Proposal__c quoteProposal2 = NOKIA_CPQ_TestDataFactory.createProposal(1)[0];
			quoteProposal2.Apttus_Proposal__Opportunity__c = oppty.id; 
			quoteProposal2.Apttus_QPConfig__PriceListId__c = priceList.Id;
			quoteProposal2.NokiaCPQ_Portfolio__c = 'IP Routing';
			quoteProposal2.NokiaCPQ_SSP_Level__c = 'Unlimited';
			quoteProposal2.RecordTypeId = swxQuoteRecordTypeId;
			quoteProposal2.Prices_Aligned__c=true;
			quoteProposal2.Apttus_Proposal__Account__c=accountCreationDP.id;
			quoteProposal2.Sold_To_Party__c = accLegalEntity.id;
			
	 
			database.insert(quoteProposal2); 
			


	}

			




}