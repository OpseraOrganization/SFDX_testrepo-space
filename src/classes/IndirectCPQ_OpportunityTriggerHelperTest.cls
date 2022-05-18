/**
 * @description	 : 
 * @author	  : Yashdeep Prajapati 
 * @group	   : 
 * @last modified on  : 06-16-2021
 * @last modified by  : Yashdeep Prajapati
 * Modifications Log 
 * Ver   Date	 Author		 Modification
 * 1.0   06-16-2021   Yashdeep Prajapati   Initial Version
**/
@isTest
public class IndirectCPQ_OpportunityTriggerHelperTest {
  
  public testmethod static void completeOpptyInfoTest(){
  
  Id oppInDirectRecordTypePartnerId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Indirect_Sales_Opportunity_For_Partner').getRecordTypeId();
  Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
  List<Opportunity> optyList = new List<Opportunity>();
  user partnerSalesManager;
  Opportunity refOppty;
  Sales_Role__c sales;
  Apttus_Approval__Backup_Approver__c objBA ;
  //Apttus_Approval__ApprovalProcessInstance__c appinstance;
  ID sysAdminID = UserInfo.getUserId();
  User sysAdmin = [Select ID,  name from User where id =: sysAdminID];
  
  System.debug('sysAdmin>>'+sysAdmin);
  
  System.runAs(sysAdmin){
	partnerSalesManager = new USer();
	partnerSalesManager = TestDataFactory.userCreation(1,'Nokia Sales Profile')[0];
	database.insert(partnerSalesManager);
	System.debug('userid>>'+partnerSalesManager.Id);
	
	PermissionSet ps = [Select id from PermissionSet Where name = 'Nokia_CPQ_Partner_Sales_Manager' Limit 1];
	System.debug('psid>>'+ps.Id);
	PermissionSetAssignment  psAssgnment = new PermissionSetAssignment();
	psAssgnment.AssigneeId = partnerSalesManager.Id;
	psAssgnment.PermissionSetId = ps.id;
	Database.insert(psAssgnment);
	System.debug('psAssgnmentid>>'+psAssgnment.Id);
	
	sales=new Sales_Role__c(); 
	sales.Organisation__c='APJ ANO CT Ooredoo Myanmar';
	sales.Role_Code__c=CSWXGlobalConstant.NSNG_COCT;
	sales.Role_Name__c='Amirthalingam';
	sales.User__c=sysAdmin.id;
	insert sales;
	
	Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
	Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
	
	User u = new User(
	Alias = 'testu',
	Email = 'testCPQ@nokia.com',
	EmailEncodingKey = 'UTF-8',
	LastName = 'Test',
	LanguageLocaleKey = 'en_US',
	LocaleSidKey = 'en_US',
	TimeZoneSidKey='America/Los_Angeles',
	ProfileId = p.Id,
	UserName='testCPQ@nokia.com',
	Nokia_ID__c=randomInt +'0',
	NSA_Compliant__c=True
	);
	
	INSERT u;
	
	User u1 = new User(
	Alias = 'testu',
	Email = 'testCPQ1@nokia.com',
	EmailEncodingKey = 'UTF-8',
	LastName = 'Test',
	LanguageLocaleKey = 'en_US',
	LocaleSidKey = 'en_US',
	TimeZoneSidKey='America/Los_Angeles',
	ProfileId = p.Id,
	UserName='testCPQ1@nokia.com',
	Nokia_ID__c=randomInt +'01',
	NSA_Compliant__c=True
	);
	
	INSERT u1;
	System.debug(u1.id + '@@@@@@@' + u.id);
	objBA = new Apttus_Approval__Backup_Approver__c();
	objBA.Apttus_Approval__Current_User__c =UserInfo.getUserId();
	objBA.Apttus_Approval__IsActive__c = true;
	objBA.Apttus_Approval__InEffect__c = true;
	objBA.Apttus_Approval__IsDelegate__c = true;
	objBA.Apttus_Approval__DelegateUserIds__c = u.Id + ',' + u1.ID;
	insert objBA;
	
	
	
  }
  
  
  
  test.startTest();
  System.runAs(partnerSalesManager){
	Account accCustomer = TestDataFactory.createAccount(1)[0];
	accCustomer.AccountNumber='100006843';
	//accCustomer.BusinessPartnerRole__c= GlobalConstants.Alliance;  // changed for SH2022 : Alliance deactivated
	accCustomer.BusinessPartnerRole__c = 'Direct Customer'; // changed for SH2022 : Alliance deactivated
	accCustomer.Market__c = 'Market India';
	accCustomer.L7Name__c = 'APJ ANO CT Ooredoo Myanmar'; 
	accCustomer.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
	accCustomer.GEOLevel1ID__c = 'Test';
	database.insert(accCustomer);
	
	Account accLegalEntity = TestDataFactory.createAccount(1)[0];
	accLegalEntity.AccountNumber='1000068431';
	accLegalEntity.ParentId=accCustomer.ID;
	accLegalEntity.Default_Legal_Entity__c = True ;
	accLegalEntity.Active__c = true;
	accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
	database.insert(accLegalEntity);
	
	refOppty = new Opportunity();
	refOppty.Name = 'test-ref oppty';
	refOppty.Lead_BG__c = 'MN';
	refOppty.Lead_BU__c = 'MN';
	refOppty.AccountId = accCustomer.Id;
	refOppty.Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;
	refOppty.Unweighted_Amount_EUR__c =0;
	refOppty.Contract_Signing_Entity__c = 'fALU';
	refOppty.G3_Planned_Date__c = System.today();
	refOppty.G4_Planned_Date__c = System.today();
	refOppty.G5_Planned_Date__c = System.today().addMonths(3);
	refOppty.G6_Planned_Date__c = System.today().addMonths(4);
	refOppty.CloseDate = System.today().addMonths(3);
	refOppty.StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
	refOppty.Phase_Status__c = GlobalConstants.PLANNED;
	refOppty.RecordTypeId = RecordTypeId;
	refOppty.End_Customer_LE__c =accLegalEntity.Id;
	//refOppty.Account_Role__c = 'Alliance Partner';//hcl // changed for SH2022: Alliance Partner Deactivated
	refOppty.Account_Role__c = 'Disti+SPaaP' ; // changed for SH2022: Alliance Partner Deactivated
	//database.insert(refOppty);
	optyList.add(refOppty); 
	
	
	opportunity opty = new Opportunity();
	opty.Name = 'test';
	opty.Lead_BG__c = 'MN';
	opty.Lead_BU__c = 'MN';
	opty.AccountId = accCustomer.Id;
	opty.RecordTypeId= oppInDirectRecordTypePartnerId;
	//opty.Account_Role__c = 'Alliance Partner';//hcl // changed for SH2022: Alliance Partner Deactivated
	opty.Account_Role__c = 'Disti+SPaaP' ; // changed for SH2022: Alliance Partner Deactivated
	opty.End_Customer_LE__c =accLegalEntity.Id;
	//database.insert(opty);
	optyList.add(opty); 

	opportunity opty1 = new Opportunity();
	opty1.Name = 'test';
	opty1.Lead_BG__c = 'MN';
	opty1.Lead_BU__c = 'MN';
	opty1.AccountId = accCustomer.Id;
	opty1.RecordTypeId= RecordTypeId;
	//opty1.Account_Role__c = 'Alliance Partner';//hcl // changed for SH2022: Alliance Partner Deactivated
	opty1.Account_Role__c = 'Disti+SPaaP' ; // changed for SH2022: Alliance Partner Deactivated
	opty1.End_Customer_LE__c =accLegalEntity.Id;
	opty1.StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
	opty1.Phase_Status__c = GlobalConstants.PLANNED;
	opty1.CloseDate = System.today().addMonths(3);
	optyList.add(opty1); 
	database.insert(optyList);
	
	Apttus_Approval__Approval_Process__c Aprocess=new Apttus_Approval__Approval_Process__c();
	insert Aprocess;
	
	Apttus_Approval__ApprovalProcessInstance__c processinstance=new Apttus_Approval__ApprovalProcessInstance__c(name=CSWXGlobalConstant.G2_Approvals_New,Apttus_Approval__BusinessObjectId__c=opty.id, Apttus_Approval__ApprovalProcessId__c=Aprocess.id);
	insert processinstance;
	
	
	Reference_Oppty_Based_on_Acc_Market__mdt referenceopty = new Reference_Oppty_Based_on_Acc_Market__mdt();
	referenceopty.Market_Value__c='Market India';
	referenceopty.Reference_Oppty__c=refOppty.Opportunity_ID__c;
	
	IndirectCPQ_OpportunityTriggerHelper.completeOpptyInfo(null);
	IndirectCPQ_OpportunityTriggerHelper.updateOpty_afterinsert(null);
	IndirectCPQ_OpportunityTriggerHelper.chatterNotificationToAccountOwner(null);
  }
  
  test.stopTest(); 
  }  
  
  public testmethod static void optyOwnertoPartnerSharingTest()  {
  test.startTest();
  Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
  List<Opportunity> optyList = new List<Opportunity>();
  User partnerSalesManager;
  Account accLegalEntity;
  Account accCustomer;
  
  //ID sysAdminID = UserInfo.getUserId();
  User sysAdmin = TestDataFactory.userCreation(1,'System Administrator')[0];
  database.insert(sysAdmin);
  
  System.runAs(sysAdmin){
	partnerSalesManager = new USer();
	partnerSalesManager = TestDataFactory.userCreation(1,'Nokia Sales Profile')[0];
	database.insert(partnerSalesManager);
	
	
	
  }
  
  //  System.runAs(partnerSalesManager){
  
  
  accCustomer = TestDataFactory.createAccount(1)[0];
  accCustomer.AccountNumber='100006843';
  //accCustomer.BusinessPartnerRole__c= GlobalConstants.Alliance; // changed for SH2022 : Alliance deactivated
  accCustomer.BusinessPartnerRole__c = 'Direct Customer'; // changed for SH2022 : Alliance deactivated
  accCustomer.Market__c = 'Market India';
  accCustomer.L7Name__c = 'APJ ANO CT Ooredoo Myanmar'; 
  accCustomer.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
  accCustomer.OwnerId = partnerSalesManager.Id;
  database.insert(accCustomer); 
  
  Contact Partnercon = TestDataFactory.createContact2(1,accCustomer)[0];
  database.insert(Partnercon);
  
  System.runAs(sysAdmin){
	//   UserRole r = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role', PortalType ='Partner', PortalAccountId=accCustomer.Id);
	UserRole r = [SELECT Id,Name,PortalType  FROM UserRole  where PortalType = 'Partner' Limit 1];
	//database.insert(r);
	/*   
User partneruser = new USer();
partneruser = TestDataFactory.userCreation(1,'PRM Partner Community User Login')[0];
partneruser.UserRoleId=r.id;
partneruser.ContactId = Partnercon.Id;
database.insert(partneruser); */
  }
  
  accLegalEntity = TestDataFactory.createAccount(1)[0];
  accLegalEntity.AccountNumber='1000068431';
  accLegalEntity.ParentId=accCustomer.ID;
  accLegalEntity.Default_Legal_Entity__c = True ;
  accLegalEntity.Active__c = true;
  accLegalEntity.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
  database.insert(accLegalEntity);
  //  } 
  Opportunity refOppty = new Opportunity();
  refOppty.Name = 'test-ref oppty';
  refOppty.Lead_BG__c = 'MN';
  refOppty.Lead_BU__c = 'MN';
  refOppty.AccountId = accCustomer.Id;
  refOppty.Business_Type__c = GlobalConstants.STANDARDOPPORTUNITY;
  refOppty.Unweighted_Amount_EUR__c =0;
  refOppty.Contract_Signing_Entity__c = 'fALU';
  refOppty.G3_Planned_Date__c = System.today();
  refOppty.G4_Planned_Date__c = System.today();
  refOppty.G5_Planned_Date__c = System.today().addMonths(3);
  refOppty.G6_Planned_Date__c = System.today().addMonths(4);
  refOppty.CloseDate = System.today().addMonths(3);
  refOppty.StageName = GlobalConstants.IDENTIFY_OPPORTUNITY;
  refOppty.Phase_Status__c = GlobalConstants.PLANNED;
  refOppty.RecordTypeId = RecordTypeId;
  refOppty.End_Customer_LE__c =accLegalEntity.Id;
  //refOppty.Account_Role__c = 'Alliance Partner';//hcl // changed for SH2022: Alliance Partner Deactivated
  refOppty.Account_Role__c = 'Disti+SPaaP' ; // changed for SH2022: Alliance Partner Deactivated
  database.insert(refOppty);
  
  test.stopTest();   
  
  } 
}