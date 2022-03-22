/****************************************
* Name : DS_RecordbannerTest
* Author : Accenture

*****************************************/
@isTest
private class DS_RecordbannerTest {
	
	public testmethod static void createTestDP(){
		 
		try{		
			User sysAdminUser = TestDataFactory.createSystemAdminUser();
			System.runAs(sysAdminUser){
	
	
	Account accountCreationDP = TestDataFactory.createAccount(1)[0];
	database.insert(accountCreationDP);
	Account accountCreationDP1 = TestDataFactory.createAccount(1)[0];
	accountCreationDP1.Name = 'Sold to account';
	accountCreationDP1.type = 'Prospect';
	accountCreationDP1.Default_Legal_Entity__c = true;
	accountCreationDP1.ParentId = accountCreationDP.Id;
	accountCreationDP1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Legal Entity').getRecordTypeId();
	database.insert(accountCreationDP1);
	Test.startTest();
	String orgId = UserInfo.getOrganizationId();
	String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
	Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
	String uniqueName =   dateString + randomInt;
	
	  
	User user1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' , emailencodingkey = 'UTF-8', firstName = 'test', lastname = 'Testing',
			  languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = UserInfo.getProfileId(),  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
			  timezonesidkey = 'America/Los_Angeles', Username = uniqueName+'a' + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '0');
	database.insert(user1); 
	
	//Creating Custom Setting Data
	CH_AccountName__c accauth = new CH_AccountName__c();
	accauth.CH_InvalidName__c = 'Nokia';
	accauth.CH_ValidName__c = 'Nokia-OYJ';
	insert accauth;
	
	List<Contact> ContactList = new List<Contact>();
	Contact conDS = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accountCreationDP.id,Email=CSWXGlobalConstant.EmailContactNameDS );
	Contact conDS2 = new Contact(lastName=CSWXGlobalConstant.ContactNameDS,AccountId=accountCreationDP.id,Email=CSWXGlobalConstant.EmailContactNameDS );
	ContactList.add(conDS);
	ContactList.add(conDS2);
	database.insert(ContactList); 
	  
	User userDS = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',lastname = 'Testing',
			languagelocalekey = 'en_US', localesidkey = 'en_US',  profileid = '00e410000022ds8'/*system.Label.PRM_Partner_Relationship_Manager_Login_ID*/,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
			timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential',Nokia_ID__c = randomInt + '00',ContactId  = conDS.Id );
	
	
	system.runAs(user1){			
		database.insert(userDS); 
		
		userDS.IsPortalEnabled =  True;
		
		database.update(userDS);
	}
	Test.stopTest();
   
	 
	SWx_Upsell_Proposal__c UpsellProposal=TestDataFactory.upsellList(1,accountCreationDP)[0];
	upsellProposal.Analytics_File_Refer_ID__c='GBR-61940-82356';
	upsellProposal.Analytics_Source__c=CSWXGlobalConstant.analyticSourceCXM;
	upsellProposal.Proposal_Status__c=CSWXGlobalConstant.ACTIVE; 
	upsellProposal.Upsell_Status__c=CSWXGlobalConstant.readyForReview ;
	
	upsellProposal.Proposal_Recommendation_Type__c='renewal';
	upsellProposal.P20_Id__c=215616;
	upsellProposal.CurrencyIsoCode='EUR';
	upsellProposal.Unweighted_Value__c=429052.07;
	upsellProposal.Account_ID__c=accountCreationDP.id;
	upsellProposal.Technology__c=CSWXGlobalConstant.Technology ;
	upsellProposal.Use_Case__c=CSWXGlobalConstant.Usecase ;
	upsellProposal.DS_Show_In_Portal__c=true;
	upsellProposal.Sold_To_Party__c = accountCreationDP.id;
	database.insert(UpsellProposal);  
	
	//Create a product record for the product feature junction link
			Product2 product = TestDataFactory.productCreation(1)[0];
			product.ProductCode = '151421';
			database.insert(product);
	
	Commercial_Entitlement__c commercialEntitlement = new Commercial_Entitlement__c();
	commercialEntitlement.Activated_Quantity__c = 1;
	commercialEntitlement.Authorised_Quantity__c = 2;
	commercialEntitlement.Parent_Account__c = accountCreationDP.id;
	commercialEntitlement.Product_Name__c = product.id;
	commercialEntitlement.Technology__c = CSWXGlobalConstant.Technology ;
	commercialEntitlement.Use_Case__c = CSWXGlobalConstant.Usecase ;
	commercialEntitlement.Sold_To_Party__c = accountCreationDP1.id;
	insert commercialEntitlement;
	
	System.runAs(userDS) {
		
	DS_Recordbanner.getCurrentRecommendation(upsellProposal.Id);
	 DS_Recordbanner.getCurrentRecommendation(null);
	  
	   List<String> techList = new List<String>();
	   techList.add('TDD LTE');
	   techList.add('FDD LTE');
	   
	   List<String> ucaseList = new List<String>();
	   ucaseList.add('Energy Efficiency');
	   ucaseList.add('eNB User Capacity');
	   ucaseList.add('Load Balancing');
		
	   List<String> entitlementList = new List<String>();
	   ucaseList.add('Can be Entitled');
	   ucaseList.add('Cannot be entitled');
	   ucaseList.add('Load Balancing');
	
	   
	   List<Commercial_Entitlement__c> filterDP = DS_Recordbanner.filtercommercialRecord(techList[0] ,ucaseList[0] ,CSWXGlobalConstant.NONE);
		 List<Commercial_Entitlement__c> filterDP1 = DS_Recordbanner.filtercommercialRecord(null,null ,null);
	   List<Commercial_Entitlement__c> filterDP5 = DS_Recordbanner.filtercommercialRecord(CSWXGlobalConstant.NONE ,CSWXGlobalConstant.NONE,CSWXGlobalConstant.NONE);
	   List<Commercial_Entitlement__c> filterDP6 = DS_Recordbanner.filtercommercialRecord('234' ,'123' ,CSWXGlobalConstant.NONE);
	
	   List<Commercial_Entitlement__c> filterDP7 = DS_Recordbanner.filtercommercialRecord(techList[0], CSWXGlobalConstant.NONE_OPTION_VALUE, CSWXGlobalConstant.allProposal);
		
	   List<Commercial_Entitlement__c> filterDP11 = DS_Recordbanner.filtercommercialRecord(CSWXGlobalConstant.NONE_OPTION_VALUE, CSWXGlobalConstant.NONE_OPTION_VALUE, CSWXGlobalConstant.allProposal);
		
	   List <Commercial_Entitlement__c> sorttest = DS_Recordbanner.sortCPRec( 'Name',true,CSWXGlobalConstant.Technology,CSWXGlobalConstant.Usecase ,'--None--');
	   List <Commercial_Entitlement__c> sorttest1 = DS_Recordbanner.sortCPRec( 'Null',true,CSWXGlobalConstant.Technology,CSWXGlobalConstant.Usecase ,'--None--');
	   List <Commercial_Entitlement__c> sorttest2 = DS_Recordbanner.sortCPRec( 'Product_Name__c',false,CSWXGlobalConstant.Technology,CSWXGlobalConstant.Usecase ,accountCreationDP1.id);
	   List <Commercial_Entitlement__c> sorttest3 = DS_Recordbanner.sortCPRec( null,true,techList[0],ucaseList[0] ,null);
	}	
			}			
		}catch (Exception ex) {		 
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_TabRenderingTest,CSWXGlobalConstant.createTestDP);		  
		} 
	 
	}
	 
	public testmethod static void getTech_UsecaseTest(){
		 test.startTest();
		 
		DS_Technology_Usecase_Combination__c techCS = new DS_Technology_Usecase_Combination__c();
		techCS.DS_Technology__c='TDD LTE';
		techCS.DS_Usecase__c='Energy Efficiency';
		techCS.Name= 'Tech_usecase';
		insert techCS ;
		
		DS_Util.getTechnologies();
		DS_Util.getUseCaseOnTechnology(techCS.DS_Technology__c);
		DS_RecordBanner.getTechnologies();
		DS_RecordBanner.getUseCaseOnTechnology(techCS.DS_Technology__c);
		 DS_RecordBanner.getUseCaseOnTechnology(Null);
		DS_RecordBanner.Get_entitlepicklist();
	  
		test.stopTest();
		
	}

}