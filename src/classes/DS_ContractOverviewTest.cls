/****************************************
* Name : DS_ContractOverviewTest
* Author : Accenture

*****************************************/
@isTest
private with sharing class DS_ContractOverviewTest {

	static testmethod void DS_ContractOverviewTest_1(){
			User userDS;
			User sysAdminUser = TestDataFactory.createSystemAdminUser();
			System.runAs(sysAdminUser){ 
			Account accountCreationDP = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreationDP);
			
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;
			
			Contact conDS = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accountCreationDP.id,Email=CSWXGlobalConstant.EmailContactNameDS );
			insert conDS;
			
			User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
			database.insert(user1); 
			
			userDS = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = '00e410000022ds8'/*system.Label.PRM_Partner_Relationship_Manager_Login_ID*/,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA', timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '00',ContactId  = conDS.Id  );
			system.runas(user1){
			insert userDS;
			} 
			Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c () ;
			agreement.Apttus__Account__c = accountCreationDP.Id;
			database.insert(agreement);
	  
			Apttus_Config2__CustomerPurchaseOrder__c cpoTest = new Apttus_Config2__CustomerPurchaseOrder__c();
			cpoTest.Apttus_Config2__ReferencePONumber__c ='12345';
			cpoTest.Apttus_Config2__AccountId__c=accountCreationDP.id;
			cpoTest.Apttus_CMConfig__AgreementId__c = agreement.id;
			  cpoTest.Legacy_CPO__c=true;  
			database.insert(cpoTest);				  
			
			File_Upload__c suppmaterial = new File_Upload__c();
			suppmaterial.Account__c = accountCreationDP.Id;
			suppmaterial.Frame_Contract_Reference__c = agreement.id;
			suppmaterial.Purchase_Order__c = cpoTest.id;
			database.insert(suppmaterial);  

			}
			System.runAs(userDS)
			{
			User us = [SELECT Accountid,Contactid,FirstName,Name, LastName from User where id=:UserInfo.getUserId() limit 1][0];
			system.debug('User>>>>'+us);
	String frame = DS_ContractOverview.getFrameContractReference()[0];
	String PO = DS_ContractOverview.getPO()[0];
	DS_ContractOverview.getFiles(frame , PO);
				DS_ContractOverview.getFiles('frame-0000','PO');
			}   

			}
	static testmethod void DS_ContractOverviewTest_2(){
		User userDS;
		User sysAdminUser = TestDataFactory.createSystemAdminUser();
		System.runAs(sysAdminUser){ 
			Account accountCreationDP = TestDataFactory.createAccount(1)[0];
			database.insert(accountCreationDP);
		
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;
		
			Contact conDS = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accountCreationDP.id,Email=CSWXGlobalConstant.EmailContactNameDS );
			insert conDS;
		
			User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
			database.insert(user1); 
		
			userDS = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = '00e410000022ds8'/*system.Label.PRM_Partner_Relationship_Manager_Login_ID*/,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA', timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '00',ContactId  = conDS.Id  );
			system.runas(user1){
	insert userDS;
			} 
			Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c () ;
			agreement.Apttus__Account__c = accountCreationDP.Id;
			database.insert(agreement);
	 
			Apttus_Config2__CustomerPurchaseOrder__c cpoTest = new Apttus_Config2__CustomerPurchaseOrder__c();
			cpoTest.Apttus_Config2__ReferencePONumber__c ='12345';
			cpoTest.Apttus_Config2__AccountId__c=accountCreationDP.id;
			cpoTest.Apttus_CMConfig__AgreementId__c = agreement.id;
			cpoTest.Legacy_CPO__c=true;
			database.insert(cpoTest);				  
		
			File_Upload__c suppmaterial = new File_Upload__c();
			suppmaterial.Account__c = accountCreationDP.Id;
			suppmaterial.Frame_Contract_Reference__c = agreement.id;
			suppmaterial.Purchase_Order__c = cpoTest.id;
			database.insert(suppmaterial);  
	  
			ContentVersion contentVersion = new ContentVersion();
			ContentDocumentLink contentlink = new ContentDocumentLink();

			contentVersion = TestDataFactory.createContentVersion(1)[0];  
			contentVersion.title = CSWXGlobalConstant.contractOverview;
			database.insert(contentVersion) ;					 
	  
			Id theContentDocumentId = [select ContentDocumentId from ContentVersion where Id =: contentVersion.Id limit 1].ContentDocumentId;
		 
	  contentlink = TestDataFactory.createContentDocumentLink(1,accountCreationDP.id, theContentDocumentId)[0];
			contentlink.LinkedEntityId=suppmaterial.id;
			database.insert(contentlink) ;				 
		
		}
		System.runAs(userDS)
		{
			User us = [SELECT Accountid,Contactid,FirstName,Name, LastName from User where id=:UserInfo.getUserId() limit 1][0];
			String frame = DS_ContractOverview.getFrameContractReference()[0];
			String PO = DS_ContractOverview.getPO()[0];
			DS_ContractOverview.getFiles(frame , PO);
		}   

		} 
   
}