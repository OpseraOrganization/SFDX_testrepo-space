@isTest(SeeAllData=false)

	public with sharing class NokiaCPQ_AttachmentHandlerTest{
	   
		static testMethod void testMethod1(){		   
			User sysAdminUser = TestDataFactory.createSystemAdminUser();   
			System.runAs(sysAdminUser){
			//create			
			 List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
			insert accounts;
			//create File sharing custom setting object
			File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
			fscs.name= 'Opportunity_SalesPhase_FinalStage';
			fscs.Value__c = 'Completed';
			insert fscs;
			List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
			accreditations[0].partner__c = accounts[0].Id;
			accreditations[1].partner__c = accounts[0].Id;
			accreditations[1].Accreditation_Type__c = 'Maintenance';
			accreditations[1].Accreditation_Level__c = 'Premium';
			accreditations[1].Pricing_Level_Override__c = 'Premium';   
			insert accreditations;
		   
		accreditations[0].app_name__c = 'Q2C_'+ accreditations[0].Portfolio__c+' '+Nokia_CPQ_Constants.NOKIA_Q2C+' '+Nokia_CPQ_Constants.PRODUCTCATALOG;
		update accreditations;
  System.debug('Acc:-'+accreditations);
  Attachment attachment = new Attachment();

  attachment.Body = Blob.valueOf('Hello');

  attachment.Name = String.valueOf('test.txt');

  attachment.ParentId = accreditations[0].Id;
			  List<Contact> con = TestDataFactory.createContact(1,accounts[0]);
		con[0].LastName = 'testCon';
		insert con;
		
			 user userCreation = TestDataFactory.userCreation(1,'PRM Partner Community User Login')[0];
				userCreation.contactId = con[0].id;
				userCreation.FirstName = 'Test';
				userCreation.LastName  = 'test';
			System.runAs(userCreation) 
			{
			Test.startTest();
		   insert attachment;
		   System.debug('Attachment:-'+attachment);
			Test.stopTest();
			}
			 }
		}
		
		static testMethod void testMethod2(){
				
			User sysAdminUser = TestDataFactory.createSystemAdminUser();   
			System.runAs(sysAdminUser){
			   //create File sharing custom setting object
				//User sysAdminUser = TestDataFactory.createSystemAdminUser();
				Id LERecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
			   Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(); 
			   

				File_Sharing_Custom_Setting__c fscs = new File_Sharing_Custom_Setting__c();
				fscs.name= 'Opportunity_SalesPhase_FinalStage';
				fscs.Value__c = 'Completed';
				insert fscs;
		
		List<Account> accounts = NOKIA_CPQ_TestDataFactory.getAccounts(1);
		 insert accounts;
		
		GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = true;
		List<opportunity> opportunities = NOKIA_CPQ_TestDataFactory.getOpportunities(1,accounts);
		opportunities[0].RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Create Direct Sales Opportunity').getRecordTypeId();
		insert opportunities; 
		
		
				//Create Product
				List<Product2> prods = new List<Product2>();
				Product2 prod1 = new product2(
				Name = 'Test1', 
				ProductCode = '123', 
				Business_Group__c = 'NSW', 
				CurrencyIsoCode = 'USD',
				IsActive = true
				); 
				prods.add(prod1);
		
		
				Product2 prod2 = new product2(
				Name = 'Test2', 
				ProductCode = '1234', 
				Business_Group__c = 'NSW', 
				CurrencyIsoCode = 'USD',
				IsActive = true
				); 
				prods.add(prod2);
				insert prods;
		
				//Create PriceList
		
				Apttus_Config2__PriceList__c ApttusTestPriceList = new Apttus_Config2__PriceList__c(
				Name = 'Commercial Price List', 
				Apttus_Config2__Active__c = True
				);
				insert ApttusTestPriceList;
		
				//create price list items
				List<Apttus_Config2__PriceListItem__c> plistItems = new List<Apttus_Config2__PriceListItem__c>();
				Apttus_Config2__PriceListItem__c pLI1 = new Apttus_Config2__PriceListItem__c(
					Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id,
					Apttus_Config2__ListPrice__c = 100, 
					Apttus_Config2__ProductId__c = prod1.Id, 
					Apttus_Config2__ChargeType__c = 'Standard Price'
				);
				//insert pLI1;
				plistItems.add(pLI1);
		
				Apttus_Config2__PriceListItem__c pLI2 = new Apttus_Config2__PriceListItem__c(
					Apttus_Config2__PriceListId__c = ApttusTestPriceList.Id, 
					Apttus_Config2__ListPrice__c = 200, 
					Apttus_Config2__ProductId__c = prod2.Id, 
					Apttus_Config2__ChargeType__c = 'Maintenance Y1'
				);
				//insert pLI2;
				plistItems.add(pLI2);
				   
				List<Accreditation__c > accreditations = NOKIA_CPQ_TestDataFactory.createAccreditation(2);
				accreditations[0].partner__c = accounts[0].Id;
				accreditations[1].partner__c = accounts[0].Id;
				accreditations[1].Accreditation_Type__c = 'Maintenance';
				accreditations[1].Accreditation_Level__c = 'Premium';
				accreditations[1].Pricing_Level_Override__c = 'Premium';   
				insert accreditations;
				
				Test.startTest();
			   List<Apttus_Proposal__Proposal__c > proposals = NOKIA_CPQ_TestDataFactory.createProposalDirect(1);
	proposals[0].Apttus_Proposal__Account__c = accounts[0].Id;
	proposals[0].Apttus_Proposal__Opportunity__c = opportunities[0].Id;
	proposals[0].NokiaCPQ_Needs_Reprice__c = true; 
				proposals[0].NokiaCPQ_Proposal_Id__c = '19..857057.A00A';
			//	proposals[0].Reprice_In_Progress__c = false;
	 proposals[0].RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get('Direct Quote').getRecordTypeId();

		insert proposals; 
		
				
				proposals[0].app_Name__c='BOM'+proposals[0].NokiaCPQ_Proposal_Id__c+'.xlsm';
				update proposals;
		
				List<Attachment> attachment = new List<Attachment>();
				Attachment attachment1 = new Attachment();
				attachment1.Body = Blob.valueOf('Hello');
				attachment1.Name = 'BOM'+proposals[0].NokiaCPQ_Proposal_Id__c+'.xlsm';
				attachment1.ParentId = proposals[0].Id;  
				attachment.add(attachment1);
				Attachment attachment2 = new Attachment();
				attachment2.Body = Blob.valueOf('Hello');
				attachment2.Name = Nokia_CPQ_Constants.PRMEXPORT + '.xlsm';
				attachment2.ParentId = proposals[0].Id;			   
				attachment.add(attachment2);
				Attachment attachment5 = new Attachment();
				attachment5.Body = Blob.valueOf('Hello');
				attachment5.Name = Nokia_CPQ_Constants.LOAEXPORT + proposals[0].NokiaCPQ_Proposal_Id__c +Nokia_CPQ_Constants.xlsm;
				attachment5.ParentId = proposals[0].Id; 
				attachment.add(attachment5);
				Attachment attachment6 = new Attachment();
				attachment6.Body = Blob.valueOf('Hello');
				attachment6.Name = Nokia_CPQ_Constants.CSPEXPORT + proposals[0].NokiaCPQ_Proposal_Id__c +Nokia_CPQ_Constants.xlsm;
				attachment6.ParentId = proposals[0].Id; 
				attachment.add(attachment6);
				 Attachment attachment7 = new Attachment();
				attachment7.Body = Blob.valueOf('Hello');
				attachment7.Name = Nokia_CPQ_Constants.NOKIA_Q2C;
				attachment7.ParentId = accreditations[0].Id; 
				attachment.add(attachment7);
				Database.insert(attachment);
				
				Test.stopTest();
		
			}	
		
		}

}