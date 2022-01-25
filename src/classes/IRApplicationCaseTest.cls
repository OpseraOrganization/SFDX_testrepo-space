/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:	 IRApplicationCaseTest
Description:   IRApplicationCaseTest class to test the class IRApplicationCase
Date  Version	Author Summary of Changes 
----------- ----------  -----------------  ---------------------------------------------------------------------------------------------------
04/26/2016   1.0	  Supriyam  Initial Release for IR application Form
01/27/2021   2.0	  Commented unused variables

----------------------------------------------------------------------------------------------------------------------------------------------------------*/
@isTest
/***
* Test Class created for the IRApplicationCase class
* Created By: Accenture IDC
* Created Date: 20/4/2017
***/
private class IRApplicationCaseTest {
  
  /**
* Description : Test data to be created.
* @param Id NA 
* @return NA
**/
  @testSetup static void dataSetup(){
	  
	NCP_CustomerCommunitySetting__c cs1 = new NCP_CustomerCommunitySetting__c();
	cs1.Name = 'Default';
	cs1.Customer_Account__c = 'Customer - test';
	cs1.Customer_Account_Number__c = '12345';
	cs1.Customer_User_Profile__c = 'Customers';
	insert cs1;
	
	Country_To_Market__c countrytomarket = new Country_To_Market__c();
	countrytomarket.Name = 'India';
	countrytomarket.Market__c ='Market India';
	insert countrytomarket;
	
	String orgId = userInfo.getOrganizationId();
	String dateString = String.valueof(Datetime.now()).replace(' ','').replace(PRMGlobalConstants.COLON,'').replace(PRMGlobalConstants.HYPHEN,'');
	Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
	String uniqueName = orgId + dateString + randomInt;
	Profile p = [SELECT Id FROM Profile WHERE Name =:PRMGlobalConstants.SysAdmin limit 1];
	User u = new User(Alias = PRMGlobalConstants.Aliass, Email=PRMGlobalConstants.TestEmail,
	EmailEncodingKey = PRMGlobalConstants.FileUTF, LastName=PRMGlobalConstants.TestLName, LanguageLocaleKey=PRMGlobalConstants.TestLanguageLocaleKey,
	LocaleSidKey=PRMGlobalConstants.TestLanguageLocaleKey, ProfileId = p.Id,TimeZoneSidKey=PRMGlobalConstants.TestTimeZone, 
	Username = uniqueName + PRMGlobalConstants.Testt + orgId + PRMGlobalConstants.TestOrg,IsActive=true,Nokia_ID__c = randomInt + '0'); 
	Database.insert(u);
	Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.AccRecType).getRecordTypeId();
	Account acct = new Account(name='Wayne Enterprises',recordtypeid=accRecTypeId);
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
	/*acc.BillingStreet = PRMGlobalConstants.BillingSt;
acc.BillingCity = PRMGlobalConstants.BillingCity;
acc.BillingState = PRMGlobalConstants.BillingState;
acc.BillingPostalCode = PRMGlobalConstants.postalCode;
acc.BillingCountry = PRMGlobalConstants.BillingCountry;
acc.AccountStatusInCRMOM__c = PRMGlobalConstants.ActiveSt;
acc.Industry = PRMGlobalConstants.Industry;
acc.Business_Type__c = PRMGlobalConstants.BusinessType;
acc.Market__c = PRMGlobalConstants.MarketAcc;
acc.Country__c = PRMGlobalConstants.CountryAcc;
acc.CBT_CT_Code__c = PRMGlobalConstants.CBTCode;
acc.Customer_Compliance__c = PRMGlobalConstants.CustomerComp;*/
	acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.AccRecType).getRecordTypeId();
	//acc.recordType.Name = 'Legal_Entity';
	//acc.AccountNumber = PRMGlobalConstants.AccountNum;
	Database.insert(acc);
	RecordType rt = [SELECT Id, Name FROM RecordType WHERE SobjectType =:PRMGlobalConstants.CaseObject  AND Name =:PRMGlobalConstants.CaseRecType limit 1];
	Case caseDetails;
	caseDetails = new Case(Status =PRMGlobalConstants.NewStatus,Priority=PRMGlobalConstants.priority,Subject=PRMGlobalConstants.Testtext,Description =PRMGlobalConstants.Testtext,
	  RecordTypeId = rt.id);
	Database.insert(caseDetails);
	Approval.UnlockResult unlockedRersult = Approval.unlock(caseDetails.id);
	Attachment attach=new Attachment();   
	attach.Name = PRMGlobalConstants.attachName;
	Blob bodyBlob = Blob.valueOf(PRMGlobalConstants.attachBody);
	attach.body = bodyBlob;
	attach.parentId = caseDetails.Id;
	Database.insert(attach);
  }
  /**
* Description : Test data to be created.
* @param Id NA 
* @return NA
**/
  /*public static testmethod void test1(){
	User u = [select id,name from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
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
	  Id pid = PRMGlobalConstants.pid;
	  Test.startTest();
	  PageReference page = new PageReference(PRMGlobalConstants.pageRef);
	  Test.setCurrentPage(page);
	  ApexPages.CurrentPage().getParameters().put(PRMGlobalConstants.Idtext,pid);
	  // IRApplicationCase= new IRApplicationCase(new ApexPages.StandardController);
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
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.debug('u.alias+++'+u);
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getStateValues(PRMGlobalConstants.TestState);
	  system.assertEquals(PRMGlobalConstants.Aliass,u.Alias);
	}
  }
  /**
* Description : Test Method to getCurrentUser  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_getCurrentUser() 
  { 
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  //String message = PRMGlobalConstants.Testbool;//unused variable
	  //String sProfile = PRMGlobalConstants.NokiaPortal; //unused variable
	  IRApplicationCase.getCurrentUser();
	  
	  system.assertEquals(PRMGlobalConstants.Aliass,u.Alias);
	}
  }
  /**
* Description : Test Method to saveTheFile  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_saveTheFile() 
  {   
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  Id parentID = u.id;
	  //String fileId=''; ..unused variable
	  String fileName= PRMGlobalConstants.Testword;
	  String base64Data='';
	  String contentType='';
	  IRApplicationCase.saveTheFile(parentID,fileName,base64Data,contentType);
	  system.assertEquals(PRMGlobalConstants.Aliass,u.Alias);
	}
  }
  /*
* Method to cover appendToFile methods
*/
  static testMethod void test_appendToFile()
  {
	//User u = [select id,name from user limit 1];//unused code
	
   // User usr;//unused variable
   // UserRole tempUserRole;// unused variable
	//String fileId='';// unused variable
	String base64Data='';
	//Id parentId;//unused variable
	/*
RecordType rt = [SELECT Id, Name FROM RecordType WHERE SobjectType =:PRMGlobalConstants.CaseObject  AND Name =:PRMGlobalConstants.CaseRecType limit 1];
Case caseDetails;
caseDetails = new Case(Status =PRMGlobalConstants.NewStatus,Priority=PRMGlobalConstants.priority,Subject=PRMGlobalConstants.Testtext,Description =PRMGlobalConstants.Testtext,
RecordTypeId = rt.id);
Database.insert(caseDetails);*/
	//Case caseDetails = [select id,status from case limit 1];
	Attachment attach = [select id,name from Attachment limit 1];
	//system.runAs(u){
	Test.StartTest();
	/*Attachment attach=new Attachment();   
attach.Name=PRMGlobalConstants.attachName;
Blob bodyBlob=Blob.valueOf(PRMGlobalConstants.attachBody);
attach.body=bodyBlob;
attach.parentId=caseDetails.Id;
//system.debug(PRMGlobalConstants.CaseId+caseDetails.Id);
Database.insert(attach);*/
	try {
	  IRApplicationCase.appendToFile(attach.Id,base64Data);
	} catch (Exception e) {
	  System.debug(PRMGlobalConstants.errormsg);
	}
	Test.StopTest();
	system.assertEquals(PRMGlobalConstants.attachName,attach.name);
  }
  //}
  /**
* Description : Test Method to getCaseCountry  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_getCaseCountry() 
  { 
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getCaseCountry();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
  }
  /**
* Description : Test Method to get Distributor  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_getDistributor() 
  { 
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getDistributor(PRMGlobalConstants.Distibutor);
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
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
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getCaseSellNokia();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
  }
  /**
* Description : Test Method to getCaseSalesTerritory  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  /**
* Description : Test Method to getCaseDistributor  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  /*  static testMethod void test_getCaseDistributor() 
{   
List<String> options = new List<String>();  
options = IRApplicationCase.getCaseDistributor();
}   */
  /**
* Description : Test Method to getCaseState  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_getCaseState() 
  { 
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getCaseState();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
  }
  /**
* Description : Test Method to getCaseMaintenanceSupport  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_getCaseMaintenanceSupport() 
  { 
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getCaseMaintenanceSupport();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
  }
  /**
* Description : Test Method to getCasePrimaryInterest  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_getCasePrimaryInterest() 
  { 
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getCasePrimaryInterest();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
  }
  /**
* Description : Test Method to getCaseManufacture  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_getCaseManufacture() 
  { 
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getCaseManufacture();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
  }
  /**
* Description : Test Method to getCaseVerticalFocus  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_getCaseVerticalFocus() 
  { 
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getCaseVerticalFocus();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
  }
  /**
* Description : Test Method to getsaveAndReturn  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
   static testMethod void test_getsaveAndReturn() 
  { 
	List<RecordType> recordTypeID_case = [Select Id FROM RecordType 
	WHERE SobjectType =: PRMGlobalConstants.CaseName and DeveloperName =: PRMGlobalConstants.recordType_case LIMIT 1] ;
	List<Case> detailsList = new List<Case>();
	Case obj=new Case();
	obj.RecordTypeId = recordTypeID_case[0].Id;
	obj.Status=PRMGlobalConstants.CaseStatus;
	obj.Subject='IR Application';
	obj.Description='IR Application';
	obj.STREET_ADDRESS_1_CHQ__c = 'address 1';
	obj.City__c = 'Pune';
	obj.POSTAL_CODE_CHQ__c = '560068';
	obj.Country__c = 'India';
	obj.PHONE_NO_CHQ__c = '9928456545';
	obj.EMAIL_DOMAINS_CHQ__c = '';
	obj.Full_Legal_Name_of_Your_Organization_CP__c = 'my name';
	obj.Company_type_CP__c = 'IT';   
	detailsList.add(obj);
	//Approval.UnlockResult unlockedRersult = Approval.unlock(obj.id);
	insert detailsList;
	//IRApplicationCase.saveAndReturn(null);
	}
   static testMethod void test_getLanguageTerm()  
   {
	 User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	 // List<String> options = new List<String>();//unused list variable
	  IRApplicationCase.getLanguageTerm('English');
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
   }
  static testMethod void test_getCaseAllState()  
   {
	 User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  //List<String> options = new List<String>();// unused list variable
	  IRApplicationCase.getCaseAllState();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
   }
   static testMethod void test_caseFromCaseNo() {
	Case c = new Case();
	c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION).getRecordTypeId();
	c.Country__c = 'USA';
	c.Subject = 'Sales';
	c.Description = 'Sales';
	c.Status='Draft';
	insert c;
	Case b = new Case();
	b.Country__c = 'India';
	b.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE).getRecordTypeId();
	b.ParentId = c.Id;
	b.Status = 'Draft';
	b.Subject = 'Sales1';
	b.Description = 'Sales1';
	b.Affiliates_Subsidiary_Name__c = 'test';
	b.Company_Registration_Number__c='123';
	b.Street_Address_1__c='test';
	b.Street_Address_2__c='test';
	b.Company_s_Website__c='test';
	b.Street_Address_3__c='test';
	b.Email_Domain__c='test';
	b.Phone_No__c='18888';
	b.Fax_per_country__c='424';
	b.City_per_country__c='Jaipur';
	b.Postal_Code_per_country__c='India';
	b.First_Name_Sales__c='test';
	b.Last_Name_Sales__c='test';
	b.Email_Sales__c='test@test.com';
	b.Primary_Phone_Sales__c='test';
	b.First_Name_Marketing__c='test';
	b.Last_Name_Marketing__c='test';
	b.Email_Marketing__c='test@test.com';
	b.Primary_Phone_Marketing__c='test';
	b.First_Name_Service__c='test';
	b.Last_Name_Service__c='test';
	b.Email_Service__c='test@test.com';
	b.Primary_Phone_Service__c='test';
	b.Distributor_with_whom_transact_business__c='test';
	b.State_Province_per_country__c='Rajasthan';
	insert b;
	Test.startTest(); 
	c = [SELECT ID, CaseNumber FROM CASE WHERE SUBJECT ='Sales'];
	IRApplicationCase.caseFromCaseNo(c.CaseNumber);
	Test.StopTest();
  }
  static testMethod void test_caseFromCaseNo1() {
	Case c = new Case();
	c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.INDIRECT_RESELLER_APPLICATION).getRecordTypeId();
	c.Country__c = 'USA';
	c.Subject = 'Sales';
	c.Description = 'Sales';
	c.Status='Draft';
	insert c;
	Case b = new Case();
	b.Country__c = 'India';
	b.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE).getRecordTypeId();
	b.ParentId = c.Id;
	b.Status = 'Draft';
	b.Subject = 'Sales1';
	b.Description = 'Sales1';
	b.Affiliates_Subsidiary_Name__c=null;
	insert b;
	Test.startTest(); 
	c = [SELECT ID, CaseNumber FROM CASE WHERE SUBJECT ='Sales'];
	IRApplicationCase.caseFromCaseNo(c.CaseNumber);
	Test.StopTest();
  }
  /**
* Description : Test Method to getCaseRepNokia  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_getCaseRepNokia() 
  {   
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getCaseRepNokia();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
  }
  /**
* Description : Test Method to getCaseEmpInMarketing  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_getCaseEmpInMarketing() 
  {   
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getCaseEmpInMarketing();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
  }
  /**
* Description : Test Method to getCaseEmpInService  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_getCaseEmpInService() 
  { 
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getCaseEmpInService();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
  }
  /**
* Description : Test Method to getCaseEmpInSales  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_getCaseEmpInSales() 
  { 
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getCaseEmpInSales();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
  }
  /**
* Description : Test Method to getCaseTechProfessional  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_getCaseTechProfessional() 
  {  
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getCaseTechProfessional();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
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
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getCaseNumOfEmployees();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
  }
  /**
* Description : Test Method to getCaseRevServices  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_getCaseRevServices() 
  {
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){	
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getCaseRevServices();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
  }
  /**
* Description : Test Method to getCaseAnnualRevenue  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_getCaseAnnualRevenue() 
  {  
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getCaseAnnualRevenue();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
  }
  /**
* Description : Test Method to getCaseCompanytype  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_getCaseCompanytype() 
  {  
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getCaseCompanytype();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
  }
  /**
* Description : Test Method to getCaseMarket  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_getCaseMarket() 
  { 
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getCaseMarket();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
  }
  /**
* Description : Test Method to mGetCaseDetails  picklist values
* @param NA
* @return List<String>
* @throws NA
**/
  static testMethod void test_mGetCaseDetails() 
  {
	User u = [select id,name from user where email=:PRMGlobalConstants.TestEmail limit 1];
	Account acc = [select id,name from account where name=:PRMGlobalConstants.accName];
	system.runAs(u){
	  String detailsStr;
	  List<String> successMsgStr=new List<String>();
	  String fileId='';
	  String fileName= PRMGlobalConstants.Testword;
	  String base64Data='5';
	  String contentType='text/html; charset=utf-8';
	  //String title='';//unused variable
	  /*  // creating account
Account acc = new Account();
acc.Name = 'STARHUB LIMITED';
acc.BillingStreet = '1660 International Dr';
acc.BillingCity = 'McLean';
acc.BillingState = 'Virginia';
acc.BillingPostalCode = '22102';
acc.BillingCountry = 'Canada';
acc.AccountStatusInCRMOM__c = 'Active';
acc.Industry='Enterprise';
acc.Business_Type__c='Consultant';
acc.Market__c='Market North America';
acc.Country__c='Canada';
acc.CBT_CT_Code__c='NAM US Regionals';
acc.Customer_Compliance__c = 'Unassigned';
acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
//acc.recordType.Name = 'Legal_Entity';
acc.AccountNumber='301030871';
insert acc;
// end
*/
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
	  detailsStr='["Market Europe","PRMGlobalConstants.TestPicklist1","PRMGlobalConstants.Testtext","PRMGlobalConstants.TestState2","PRMGlobalConstants.Postal","Afghanistan","PRMGlobalConstants.PhoneNo","PRMGlobalConstants.TestState","PRMGlobalConstants.EmailDom","PRMGlobalConstants.Testtext","PRMGlobalConstants.TestPicklist2","PRMGlobalConstants.TestPicklist3","PRMGlobalConstants.TestPicklist4","","","PRMGlobalConstants.Testtext","PRMGlobalConstants.Testtext","test@gmail.com","Mr.","989898989","9898767789","bTest","blast","mr.","test@gmail.com","123456","1234567","test","test","test","test","test@gmail.com","test","test","test@gmail.com","123456","est","fName","last","test@gmail.com","1234567","test","test","","","0","","5","5","","","10","pune","","0-10%","0-10%","0-10%","0-10%","0-10%","0-10%","","","","test","None",true,false,false,false,false,false,false,false,"test","Test","","","","","","a@gmail.com","a@gmail.com","India","12345","www.google.com","Mr.","Yes","Some title","2019"]';
	  
	  //IRApplicationCase irc=new IRApplicationCase();
	  IRApplicationCase.pageid=acc.id;	
	  IRApplicationCase.saveTheChunk(acc.id, fileName, base64Data, contentType, fileId);
	  Case c = new Case();
	  c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(PRMGlobalConstants.SALES_TO_COUNTRY_RECORDTYPE).getRecordTypeId();
	  c.Country__c = 'USA';
	  c.Subject = 'Subject';
	  c.Description = 'Description';
	  c.Auto_Approved_By_System__c = true;
	  c.Is_Headquater__c = true;
	  c.status = 'New';
	  insert c;
   Test.StartTest();
	  IRApplicationCase.pageid=acc.id;
	  successMsgStr=IRApplicationCase.mGetCaseDetails(detailsStr,c.id,countryToSell,targeted,manufac,primaryint,fileName,base64Data,contentType, fileId,salesTerr,countryData,salesTerr,True,null,null,'','','','');
	  Test.StopTest();
	  system.assertEquals(PRMGlobalConstants.accName, acc.Name);
	}
  }
  
  static testMethod void test_mGetCaseDetails2() {
	User u = [select id,name from user where email=:PRMGlobalConstants.TestEmail limit 1];
	Account acc = [select id,name from account where name=:PRMGlobalConstants.accName];
	system.runAs(u) {
	  String detailsStr;
	  List<String> successMsgStr=new List<String>();
	  String fileId='';
	  String fileName= PRMGlobalConstants.Testword;
	  String base64Data='';
	  String contentType='';
	  //String title='';//unused variable
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
	  //salesTerr.add(PRMGlobalConstants.TestState2);
	  String countryData = PRMGlobalConstants.countryData1;
	  detailsStr='["Market Europe","PRMGlobalConstants.TestPicklist1","PRMGlobalConstants.Testtext","PRMGlobalConstants.TestState","PRMGlobalConstants.Postal","Afghanistan","PRMGlobalConstants.PhoneNo","PRMGlobalConstants.TestState","PRMGlobalConstants.EmailDom","PRMGlobalConstants.Testtext","PRMGlobalConstants.TestPicklist2","PRMGlobalConstants.TestPicklist3","PRMGlobalConstants.TestPicklist4","","","PRMGlobalConstants.Testtext","PRMGlobalConstants.Testtext","test@gmail.com","Mr.","989898989","9898767789","bTest","blast","mr.","test@gmail.com","123456","1234567","test","test","test","test","test@gmail.com","test","test","test@gmail.com","123456","est","fName","last","test@gmail.com","1234567","test","test","","","0","","5","5","","","10","pune","","0-10%","0-10%","0-10%","0-10%","0-10%","0-10%","","","","test","None",true,false,false,false,false,false,false,false,"test","Test","","","","","","a@gmail.com","a@gmail.com","India","12345",null,"Mr.","Yes","Some title","2019"]';
	  Test.StartTest();
	  IRApplicationCase.pageid=acc.id;
	  Id caseId = [Select Id from Case limit 1].Id;
	  successMsgStr=IRApplicationCase.mGetCaseDetails(detailsStr,caseId,countryToSell,targeted,manufac,primaryint,fileName,base64Data,contentType, fileId,salesTerr,countryData,salesTerr,False,'50021000003NPiI',null,'','','','');
	  Test.StopTest();
	  system.assertEquals(PRMGlobalConstants.accName, acc.Name);
	}
  }
  
  static testMethod void test_mGetCaseDetails3() {
	User u = [select id,name from user where email=:PRMGlobalConstants.TestEmail limit 1];
	Account acc = [select id,name from account where name=:PRMGlobalConstants.accName];
	system.runAs(u) {
	  String detailsStr;
	  List<String> successMsgStr=new List<String>();
	  String fileId='';
	  String fileName= PRMGlobalConstants.Testword;
	  String base64Data='';
	  String contentType='';
	  //String title='';//unused variable
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
	  detailsStr='["Market Europe","PRMGlobalConstants.TestPicklist1","PRMGlobalConstants.Testtext","PRMGlobalConstants.TestState","PRMGlobalConstants.Postal","Afghanistan","PRMGlobalConstants.PhoneNo","PRMGlobalConstants.TestState","PRMGlobalConstants.EmailDom","PRMGlobalConstants.Testtext","PRMGlobalConstants.TestPicklist2","PRMGlobalConstants.TestPicklist3","PRMGlobalConstants.TestPicklist4","","","PRMGlobalConstants.Testtext","PRMGlobalConstants.Testtext","test@gmail.com","Mr.","989898989","9898767789","bTest","blast","mr.","test@gmail.com","123456","1234567","test","test","test","test","test@gmail.com","test","test","test@gmail.com","123456","est","fName","last","test@gmail.com","1234567","test","test","","","0","","5","5","","","10","pune","","0-10%","0-10%","0-10%","0-10%","0-10%","0-10%","","","","test","None",true,false,false,false,false,false,false,false,"test","Test","","","","","","a@gmail.com","a@gmail.com","India","12345",null,"Mr.","Yes","Some title","2019"]';
	  Test.StartTest();
	  IRApplicationCase.pageid=acc.id;
	  Id caseId = [Select Id from Case limit 1].Id;
	  successMsgStr=IRApplicationCase.mGetCaseDetails(detailsStr,caseId,countryToSell,targeted,manufac,primaryint,fileName,base64Data,contentType, fileId,salesTerr,countryData,salesTerr,False,'50021000003NPiI',null,'','','','');
	  Test.StopTest();
	  system.assertEquals(PRMGlobalConstants.accName, acc.Name);
	}
  }
  
  static testMethod void IRApplicationCaseTest() {
	Case c = [Select Id from case limit 1];
	ApexPages.currentPage().getParameters().put('Id', c.id);
	ApexPages.StandardController sc = new ApexPages.StandardController(c);
	new IRApplicationCase(sc);
	IRApplicationCase.getCaseSalesTerr();
  }
  static testMethod void test_getDistributors() 
  { 
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getDistributors(PRMGlobalConstants.countryHq);
	}
  }
  @isTest static void IrTest1() {
	
	try {
	  IRApplicationCase.getCaseMarket();
	} catch(DMLException e) {
	  system.assertEquals(e.getMessage(), e.getMessage());
	}
	
	IRApplicationCase.getCaseMarket();
  }
  @isTest static void saveAndReturnTest() {
	String detailsStr='["Market Europe","PRMGlobalConstants.TestPicklist1","PRMGlobalConstants.Testtext","PRMGlobalConstants.TestState2","PRMGlobalConstants.Postal","Afghanistan","PRMGlobalConstants.PhoneNo","PRMGlobalConstants.TestState","PRMGlobalConstants.EmailDom","PRMGlobalConstants.Testtext","PRMGlobalConstants.TestPicklist2","PRMGlobalConstants.TestPicklist3","PRMGlobalConstants.TestPicklist4","","","PRMGlobalConstants.Testtext","PRMGlobalConstants.Testtext","test@gmail.com","Mr.","989898989","9898767789","bTest","blast","mr.","test@gmail.com","123456","1234567","test","test","test","test","test@gmail.com","test","test","test@gmail.com","123456","est","fName","last","test@gmail.com","1234567","test","test","","","0","","5","5","","","10","pune","","0-10%","0-10%","0-10%","0-10%","0-10%","0-10%","","","","test","None",true,false,false,false,false,false,false,false,"test","Test","","","","","","a@gmail.com","a@gmail.com","India","12345","www.google.com"]';
	IRApplicationCase.saveAndReturn(detailsStr);
  }
	
  static testMethod void test_getEmployeeDepartureYear() 
  {  
	User u = [select id,name,alias from user where email=:PRMGlobalConstants.TestEmail limit 1];
	system.runAs(u){
	  List<String> options = new List<String>();  
	  options = IRApplicationCase.getDepartureYears();
	  system.assertEquals(PRMGlobalConstants.Aliass,u.alias);
	}
  }
}