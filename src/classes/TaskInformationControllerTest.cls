@isTest
public class TaskInformationControllerTest 
{
	private static List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = new List<File_Sharing_Custom_Setting__c>();
	
	static testMethod void getOpptyOfferValues(){
		Test.startTest();
		List<user> userList = new List<User>();
		List<Account> accountList = new List<Account>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Offer__c> offerList = new List<Offer__c>();
		userList = TestDataFactory.userCreation(1, 'System Administrator');
		database.insert(userList) ;
		system.runAs(userList[0])
		{ 
			GlobalConstants.RUN_USER_TRIGGER_ON_FILESHARING = FALSE;
			GlobalConstants.RUN_CONTENTDOCUMENTLINK_TRIGGER_ON_FILESHARING = FALSE;
			GlobalConstants.RUN_CONTENTDOCUMENT_TRIGGER_ON_FILESHARING = FALSE;
			
			//Create an Account Record
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			id accountId  = accountList[0].id;
			system.assert(accountId!=null);
		
			// create an Opportunity Record
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			opportunityList = TestDataFactory.OpportunityCreation(1, accountList[0]);
			database.insert(opportunityList);
			id opportunityId = opportunityList[0].id;
			
			// Create an Offer Record
			offerList = TestDataFactory.OfferCreation(1,opportunityList[0]);
			database.insert(offerList);
			id offerId = offerList[0].id;
			system.assert(offerId!=null);
			
			TaskInformationController.getOpptyOfferValues(opportunityId);
			Test.stoptest();
		}
	} 

	static testMethod void getOpportunityPhaseStatusValues()
	{
	   Test.startTest();
	   List<user> userList = new List<User>();
	   userList = TestDataFactory.userCreation(1, 'System Administrator');
	   database.insert(userList) ;
	   system.runAs(userList[0])
	   {
			GlobalConstants.RUN_USER_TRIGGER_ON_FILESHARING = FALSE;
			GlobalConstants.RUN_CONTENTDOCUMENTLINK_TRIGGER_ON_FILESHARING = FALSE;
			GlobalConstants.RUN_CONTENTDOCUMENT_TRIGGER_ON_FILESHARING = FALSE;
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			TaskInformationController.getOpportunityPhaseStatusValues();
			Test.stoptest();
	   } 
	}
	
	// Covering catch block for getOpportunityPhaseStatusValues
	static testMethod void getOpportunityPhaseStatusValues1()
	{
	   Test.startTest();
	   List<user> userList = new List<User>();
	   userList = TestDataFactory.userCreation(1, 'System Administrator');
	   database.insert(userList) ;
	   system.runAs(userList[0])
	   {
			GlobalConstants.RUN_USER_TRIGGER_ON_FILESHARING = FALSE;
			GlobalConstants.RUN_CONTENTDOCUMENTLINK_TRIGGER_ON_FILESHARING = FALSE;
			GlobalConstants.RUN_CONTENTDOCUMENT_TRIGGER_ON_FILESHARING = FALSE;
			//fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			//database.insert(fileSharingCustomSettingList);
			TaskInformationController.getOpportunityPhaseStatusValues();
			Test.stoptest();
	   } 
	} 
	static testMethod void saveTaskDetails()
	{
	   
		List<user> userList = new List<User>();
		List<Account> accountList = new List<Account>();
		List<Opportunity> opportunityList = new List<Opportunity>();
		List<Offer__c> offerList = new List<Offer__c>();
		userList = TestDataFactory.userCreation(1, 'System Administrator');
		database.insert(userList);
		system.runAs(userList[0])
		{ 
			GlobalConstants.RUN_USER_TRIGGER_ON_FILESHARING = FALSE;
			GlobalConstants.RUN_CONTENTDOCUMENTLINK_TRIGGER_ON_FILESHARING = FALSE;
			GlobalConstants.RUN_CONTENTDOCUMENT_TRIGGER_ON_FILESHARING = FALSE;
			
			InvalidEmailDomain__c invalidDomain = new InvalidEmailDomain__c();
			invalidDomain.Domain__c = 'nokia,invalid';
			insert invalidDomain;
			
			//Create an Account Record
			accountList = TestDataFactory.createAccount(1);
			database.insert(accountList);
			id accountId  = accountList[0].id;
			system.assert(accountId!=null);
			
			/*Create a Contact Record
			Contact cont = new Contact();
			cont.FirstName='Test';
			cont.LastName='Test';
			cont.Accountid= accountId;
			insert cont;
			Id conRec = cont.id;
			System.debug('conRec::'+conRec);*/
		
			// create an Opportunity Record
			fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
			database.insert(fileSharingCustomSettingList);
			opportunityList = TestDataFactory.OpportunityCreation(1, accountList[0]);
			database.insert(opportunityList);
			id opportunityId = opportunityList[0].id;
			
			// Create an Offer Record
			offerList = TestDataFactory.OfferCreation(1,opportunityList[0]);
			database.insert(offerList);
			id offerId = offerList[0].id;
			system.assert(offerId!=null);
			// Create a Task Record
			Test.startTest();			
			Task taskRec = new Task();
			//taskRec.WhoId = conRec;
			//taskRec.OwnerId = userList[0].id; 
			//insert taskRec;
			//system.debug('taskRec::::::::'+taskRec);
			TaskInformationController.saveTaskDetails(taskRec, '123',opportunityId,offerId,'G2');
			Test.stoptest();
		}	   
	}
	
	static testMethod void getAssignedToVal()
	{
	  Test.startTest();
	  //String inputDate = date.today().format();
	  List<user> userList = new List<User>();
	  userList = TestDataFactory.userCreation(1, 'System Administrator');
	  database.insert(userList) ;
	  system.runAs(userList[0])
	  {
			GlobalConstants.RUN_USER_TRIGGER_ON_FILESHARING = FALSE;
			GlobalConstants.RUN_CONTENTDOCUMENTLINK_TRIGGER_ON_FILESHARING = FALSE;
			GlobalConstants.RUN_CONTENTDOCUMENT_TRIGGER_ON_FILESHARING = FALSE;
			TaskInformationController.getAssignedToVal('TestAssignVal','2017-03-03');
			TaskInformationController.getAssignedToVal(null,'2017-03-03');
			TaskInformationController.getAssignedToVal('TestAssignVal',null);
			TaskInformationController.getAssignedToVal(null,null);		  	
			Test.stopTest();
	  }   
	}
}