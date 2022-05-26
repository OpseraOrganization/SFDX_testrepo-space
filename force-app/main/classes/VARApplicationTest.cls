/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:			VARApplicationTest
Description:	 VARApplicationForm Test class to test the class
Date	Version		 Author		Summary of Changes 
-----------	  ----------	  -----------------	---------------------------------------------------------------------------------------------------
08/18/2017	1.0			Anukriti	  Initial Release for VAR application Form

----------------------------------------------------------------------------------------------------------------------------------------------------------*/
/***
* Test Class created for the VARApplicationCase class
* Created By: Accenture IDC
* Created Date: 18/8/2017
***/
@isTest
private class VARApplicationTest 
{
	/**
	* Description : Test data to be created.
	* @param Id NA 
	* @return NA
	**/
	@testSetup static void dataSetup() 
	{
		NCP_CustomerCommunitySetting__c cs1 = new NCP_CustomerCommunitySetting__c();
		cs1.Name = 'Default';
		cs1.Customer_Account__c = 'Customer - test';
		cs1.Customer_Account_Number__c = '12345';
		cs1.Customer_User_Profile__c = 'Customers';
		insert cs1;
		
		String orgId = userInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(PRMGlobalConstants.COLON,'').replace(PRMGlobalConstants.HYPHEN,'');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName = orgId + dateString + randomInt;
		/*Profile p = [SELECT Id FROM Profile WHERE Name =:PRMGlobalConstants.SysAdmin LIMIT 1];
		UserRole ur = [SELECT Id FROM UserRole WHERE Name ='Global' LIMIT 1];
		User u = new User(UserRoleId=ur.Id, Alias = PRMGlobalConstants.Aliass, Email=PRMGlobalConstants.TestEmail,
		EmailEncodingKey = PRMGlobalConstants.FileUTF, LastName=PRMGlobalConstants.TestLName, LanguageLocaleKey=PRMGlobalConstants.TestLanguageLocaleKey,
		LocaleSidKey=PRMGlobalConstants.TestLanguageLocaleKey, ProfileId = p.Id,TimeZoneSidKey=PRMGlobalConstants.TestTimeZone, 
		Username = uniqueName + PRMGlobalConstants.Testt + orgId + PRMGlobalConstants.TestOrg,IsActive=true,NSA_Compliant__c=true, Nokia_ID__c = '211512'); 
		Database.insert(u);*/
		List<user> runAsUSer = new List<user>();
		User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs ( thisUser ) 
		{
			runAsUSer = TestDataFactory.userCreation(2,'System Administrator');			
			runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
			runAsUSer[0].NSA_Compliant__c = true;
			database.insert(runAsUSer);
		}
		
		system.runAs(runAsUSer[0]) 
		{
			Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.AccRecType).getRecordTypeId();
			Account acct = new Account(name='Wayne Enterprises ' + Utils.generateRandomInteger(2)+Utils.generateRandomString(2) ,recordtypeid=accRecTypeId);
			Database.insert(acct);
			Partner_Company__c pc = new Partner_Company__c();
			pc.Partner_Name__c = acct.id;
			pc.Country_Headquarters__c = PRMGlobalConstants.countryHq;
			pc.Market__c = PRMGlobalConstants.Distibutor;
			pc.Partner_Type__c = PRMGlobalConstants.Distr;
			Database.insert(pc);
			Country_State_Dependency__c cs = new Country_State_Dependency__c();
			cs.Name = PRMGlobalConstants.Testtext;
			cs.Country__c = PRMGlobalConstants.Testtext;
			cs.State__c = PRMGlobalConstants.Testtext;
			Database.insert(cs);
			Account acc = new Account();
			acc.Name = PRMGlobalConstants.accName;
			acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.AccRecType).getRecordTypeId();
			Database.insert(acc);
			Contact con = new Contact();
			con.LastName = PRMGlobalConstants.contactLastname;
			con.AccountId = acc.Id;
			Database.insert(con);
			Fund__c fd = new Fund__c(Name = 'abcd', Partner_Name__c = acc.id);
			insert fd;
			Profile pp = [SELECT Id, Name FROM Profile WHERE Name ='PRM Partner Community User Login' LIMIT 1];
			User partnerUser = new User(alias = 'test123', email=PRMGlobalConstants.TestEmailPartnerUser,
										emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
										localesidkey='en_US', profileid = pp.Id, country='United States of America',IsActive =true,
										ContactId = con.Id,
										timezonesidkey='America/Los_Angeles', username='testertestttt@noemail.com', Nokia_ID__c = '211512');
			Database.insert(partnerUser);
			User ut = [SELECT Id, contact.AccountId, contact.Account.IsPartner FROM User WHERE ID =: partnerUser.ID];
			System.debug('ut::'+ut.ContactId);
			System.debug('ut 2::'+ut.contact.Account.IsPartner);
			Ut.Nokia_ID__c = '211512';
			RecordType rt = [SELECT Id, Name FROM RecordType WHERE SobjectType =:PRMGlobalConstants.CaseObject AND DeveloperName =:PRMGlobalConstants.CASE_VAR_RECORDTYPE limit 1];
			Case caseDetails;
			caseDetails = new Case(Status =PRMGlobalConstants.NewStatus,Priority=PRMGlobalConstants.priority,Subject=PRMGlobalConstants.Testtext,Description =PRMGlobalConstants.Testtext,
								   RecordTypeId = rt.id);
			Database.insert(caseDetails);
			Attachment attach=new Attachment();	 
			attach.Name = PRMGlobalConstants.attachName;
			Blob bodyBlob = Blob.valueOf(PRMGlobalConstants.attachBody);
			attach.body = bodyBlob;
			attach.parentId = caseDetails.Id;
			Database.insert(attach);
		}
		Country_To_Market__c country = new Country_To_Market__c();
		country.market__c = 'Market Latin America';
		country.Name = 'Afghanistan';
		insert country;
		
	}
	
	/**
	* Description : Test data to be created.
	* @param Id NA 
	* @return NA
	**/
	/*public static testmethod void test1() {
		User u = [SELECT id,name FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u) {
		String details = PRMGlobalConstants.Testtext;
		String country = '';
		String dist = '';
		String vert = '';
		String manuf = '';
		String prim = '';
		String fname = '';
		String base = '';
		String con = '';
		String fid = '';
		Id pid = [Select id from Lead limit 1].id;
		Test.startTest();
		PageReference page = new PageReference('/' + pid);
		Test.setCurrentPage(page);
		ApexPages.CurrentPage().getParameters().put(PRMGlobalConstants.Idtext,pid);
		
		Test.stopTest();
		system.assertEquals(pid,ApexPages.currentPage().getParameters().get(PRMGlobalConstants.Idtext));
		}
		}*/
			
			/**
		* Description : Test Method to getStateValues  picklist values
		* @param NA
		* @return List<String>
		* @throws NA
		**/
	static testMethod void test_getStateValues() 
	{		
		User u = [SELECT id,name,alias FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u) {
			List<String> options = new List<String>();  
			options = VARApplicationForm.getStateValues(PRMGlobalConstants.TestState);
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.Alias);
		}
	}
	
	/**
	* Description : Test Method to getCurrentUser  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_getCurrentUser() {	 
		User u = [SELECT id,name,alias,contactId FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u) {
			String message = PRMGlobalConstants.Testbool;
			String sProfile = PRMGlobalConstants.NokiaPortal;
			VARApplicationForm.getCurrentUser();
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.Alias);
		}
	}
	
	/**
	* Description : Test Method to getCaseCountry  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_getCaseCountry() {		
		User u = [SELECT id,name,alias FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u) {
			List<String> options = new List<String>();  
			options = VARApplicationForm.getCaseCountry();
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.alias);
		}
	}
	
	/**
	* Description : Test Method to get Distributor  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_getDistributor() {		
		User u = [SELECT id,name,alias FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u) {
			List<String> options = new List<String>();  
			options = VARApplicationForm.getDistributor(PRMGlobalConstants.Distibutor);
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.alias);
		}
	}
	
	/**
	* Description : Test Method to getCaseSellNokia  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_getCaseSellNokia() 
	{		
		User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u) {
			List<String> options = new List<String>();  
			options = VARApplicationForm.getCaseSellNokia();
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.alias);
		}
	}
	
	/**
	* Description : Test Method to getCaseState  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_getCaseState() {		
		User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u){
			List<String> options = new List<String>();  
			options = VARApplicationForm.getCaseState();
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.alias);
		}
	}
	
	/**
	* Description : Test Method to getCaseMaintenanceSupport  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_getCaseMaintenanceSupport() {		
		User u = [SELECT id,name,alias FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u){
			List<String> options = new List<String>();  
			options = VARApplicationForm.getCaseMaintenanceSupport();
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.alias);
		}
	}
	
	/**
	* Description : Test Method to getCaseManufacture  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_getCaseManufacture() {		
		User u = [SELECT id,name,alias FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser limit 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u){
			List<String> options = new List<String>();  
			options = VARApplicationForm.getCaseManufacture();
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.alias);
		}
	}
	
	/**
	* Description : Test Method to getCaseVerticalFocus  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_getCaseVerticalFocus() {	  
		User u = [ SELECT id,name,alias FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser limit 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u){
			List<String> options = new List<String>();  
			options = VARApplicationForm.getCaseVerticalFocus();
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.alias);
		}
	}
	
	/**
	* Description : Test Method to getCaseRepNokia  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_getCaseRepNokia() {	 
		User u = [SELECT id,name,alias FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser limit 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u){
			List<String> options = new List<String>();  
			options = VARApplicationForm.getCaseRepNokia();
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.alias);
		}
	}
	
	/**
	* Description : Test Method to getCaseEmpInMarketing  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_getCaseEmpInMarketing() {   
		User u = [SELECT id,name,alias FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u) {
			List<String> options = new List<String>();  
			options = VARApplicationForm.getCaseEmpInMarketing();
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.alias);
		}
	}
	/**
	* Description : Test Method to getCaseEmpInService  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_getCaseEmpInService() {		
		User u = [SELECT id,name,alias FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u){
			List<String> options = new List<String>();  
			options = VARApplicationForm.getCaseEmpInService();
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.alias);
		}
	}
	/**
	* Description : Test Method to getCaseEmpInSales  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_getCaseEmpInSales() { 
		User u = [SELECT id,name,alias FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u){
			List<String> options = new List<String>();  
			options = VARApplicationForm.getCaseEmpInSales();
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.alias);
		}
	}
	
	/**
	* Description : Test Method to getCaseTechProfessional  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_getCaseTechProfessional() {  
		User u = [SELECT id,name,alias FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u){
			List<String> options = new List<String>();  
			options = VARApplicationForm.getCaseTechProfessional();
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.alias);
		}
	}
	
	/**
	* Description : Test Method to getCaseNumOfEmployees  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_getCaseNumOfEmployees() 
	{  
		User u = [SELECT id,name,alias FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u){
			List<String> options = new List<String>();  
			options = VARApplicationForm.getCaseNumOfEmployees();
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.alias);
		}
	}
	
	/**
	* Description : Test Method to getCaseRevServices  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_getCaseRevServices() {
		User u = [SELECT id,name,alias from user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u){		
			List<String> options = new List<String>();  
			options = VARApplicationForm.getCaseRevServices();
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.alias);
		}
	}
	
	/**
	* Description : Test Method to getCaseAnnualRevenue  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_getCaseAnnualRevenue() {  
		User u = [SELECT id,name,alias FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u){
			List<String> options = new List<String>();  
			options = VARApplicationForm.getCaseAnnualRevenue();
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.alias);
		}
	}
	/**
	* Description : Test Method to getCaseCompanytype  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_getCaseCompanytype() {	
		User u = [SELECT id,name,alias FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u){
			List<String> options = new List<String>();  
			options = VARApplicationForm.getCaseCompanytype();
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.alias);
		}
	}
	
	/**
	* Description : Test Method to getCaseMarket  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_getCaseMarket() { 
		User u = [SELECT id,name,alias FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		system.runAs(u){
			List<String> options = new List<String>();  
			options = VARApplicationForm.getCaseMarket();
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.alias);
		}
	}
	
	/**
	* Description : Test Method to mGetCaseDetails  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_mGetCaseDetails() {
		User u = [SELECT id,name FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		Account acc = [SELECT id,name FROM account WHERE name=:PRMGlobalConstants.accName];
		Id parentId = [Select id from case limit 1].id;
		system.runAs(u) {
			String detailsStr;
			List<String> successMsgStr=new List<String>();
			String fileId='';
			String fileName= PRMGlobalConstants.Testword;
			String base64Data='';
			String contentType='';
			String title='';
			List<String> countryToSell=new List<String>();
			countryToSell.add(PRMGlobalConstants.TestState);
			List<String> distributor = new List<String>();
			distributor.add(PRMGlobalConstants.Testtext);
			List<String> targeted = new List<String>();
			targeted.add(PRMGlobalConstants.targeted);
			List<String> manufac = new List<String>();
			manufac.add(PRMGlobalConstants.manufact);
			List<String> primaryint = new List<String>();
			primaryint.add(PRMGlobalConstants.primaryInt);
			List<String> salesTerr = new List<String>();
			salesTerr.add(PRMGlobalConstants.TestState);
			String countryData = PRMGlobalConstants.countryData;
			detailsStr='["Market Europe","PRMGlobalConstants.TestPicklist1","PRMGlobalConstants.Testtext","PRMGlobalConstants.TestState2","PRMGlobalConstants.Postal","Afghanistan","PRMGlobalConstants.PhoneNo","PRMGlobalConstants.TestState","PRMGlobalConstants.EmailDom","PRMGlobalConstants.Testtext","PRMGlobalConstants.TestPicklist2","PRMGlobalConstants.TestPicklist3","PRMGlobalConstants.TestPicklist4","","","PRMGlobalConstants.Testtext","PRMGlobalConstants.Testtext","test@gmail.com","Mr.","989898989","9898767789","bTest","blast","mr.","test@gmail.com","123456","1234567","test","test","test","test","test@gmail.com","test","test","test@gmail.com","123456","est","fName","last","test@gmail.com","1234567","test","test","","","0","","5","5","","","10","pune","","0-10%","0-10%","0-10%","0-10%","0-10%","0-10%","","","","test","None",true,false,false,false,false,false,false,false,"test","Test","","","","","","a@gmail.com","a@gmail.com","India","12345",null]';
			Test.StartTest();
			VARApplicationForm.pageid=acc.id;
			successMsgStr=VARApplicationForm.mGetCaseDetails(detailsStr,parentId,countryToSell,targeted,manufac,primaryint,fileName,base64Data,contentType, fileId,salesTerr,countryData,salesTerr);
			Test.StopTest();
			system.assertEquals(PRMGlobalConstants.accName, acc.Name);
		}
	}
	/**
	* Description : Test Method to mGetCaseDetails  picklist values
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void test_mGetCaseDetails2() {
		User u = [SELECT id,name FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		Account acc = [SELECT id,name FROM account WHERE name=:PRMGlobalConstants.accName];
		Id parentId = [Select id from case limit 1].id;
		system.runAs(u) {
			String detailsStr;
			List<String> successMsgStr=new List<String>();
			String fileId='';
			String fileName= PRMGlobalConstants.Testword;
			String base64Data='';
			String contentType='';
			String title='';
			List<String> countryToSell=new List<String>();
			countryToSell.add(PRMGlobalConstants.TestState);
			List<String> distributor = new List<String>();
			distributor.add(PRMGlobalConstants.Testtext);
			List<String> targeted = new List<String>();
			targeted.add(PRMGlobalConstants.targeted);
			List<String> manufac = new List<String>();
			manufac.add(PRMGlobalConstants.manufact);
			List<String> primaryint = new List<String>();
			primaryint.add(PRMGlobalConstants.primaryInt);
			List<String> salesTerr = new List<String>();
			salesTerr.add(PRMGlobalConstants.TestState);
			salesTerr.add(PRMGlobalConstants.TestState2);
			String countryData = PRMGlobalConstants.countryData;
			detailsStr='["Market Europe","PRMGlobalConstants.TestPicklist1","PRMGlobalConstants.Testtext","PRMGlobalConstants.TestState","PRMGlobalConstants.Postal","Afghanistan","PRMGlobalConstants.PhoneNo","PRMGlobalConstants.TestState","PRMGlobalConstants.EmailDom","PRMGlobalConstants.Testtext","PRMGlobalConstants.TestPicklist2","PRMGlobalConstants.TestPicklist3","PRMGlobalConstants.TestPicklist4","","","PRMGlobalConstants.Testtext","PRMGlobalConstants.Testtext","test@gmail.com","Mr.","989898989","9898767789","bTest","blast","mr.","test@gmail.com","123456","1234567","test","test","test","test","test@gmail.com","test","test","test@gmail.com","123456","est","fName","last","test@gmail.com","1234567","test","test","","","0","","5","5","","","10","pune","","0-10%","0-10%","0-10%","0-10%","0-10%","0-10%","","","","test","None",true,false,false,false,false,false,false,false,"test","Test","","","","","","a@gmail.com","a@gmail.com","India","12345",null]';
			Test.StartTest();
			VARApplicationForm.pageid=acc.id;
			successMsgStr=VARApplicationForm.mGetCaseDetails(detailsStr,parentId,countryToSell,targeted,manufac,primaryint,fileName,base64Data,contentType, fileId,salesTerr,countryData,salesTerr);
			Test.StopTest();
			system.assertEquals(PRMGlobalConstants.accName, acc.Name);
		}
	}
	/**
	* Description : Test Method to VARApplicationFormTest CONSTRUCTOR
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void VARApplicationFormTest() {
		Case c = [SELECT Id FROM case LIMIT 1];
		ApexPages.currentPage().getParameters().put('Id', c.id);
		ApexPages.StandardController sc = new ApexPages.StandardController(c);
		new VARApplicationForm(sc);
		VARApplicationForm.getCaseSalesTerr();
	}
	
	/**
	* Description : Test Method to VARApplicationFormTest CONSTRUCTOR
	* @param NA
	* @return List<String>
	* @throws NA
	**/
	static testMethod void getValuesFromAccount_Test() {
		User u = [SELECT id, name, alias FROM user WHERE email=:PRMGlobalConstants.TestEmailPartnerUser LIMIT 1];
		U.Nokia_ID__c = '211512';
		Account acc = [SELECT id,name FROM account WHERE name=:PRMGlobalConstants.accName];
		system.runAs(u) {
			VARApplicationForm.getValuesFromAccount(acc.Id);
			system.assertEquals(PRMGlobalConstants.PartnerUserAlias,u.alias);
		}
	}
}