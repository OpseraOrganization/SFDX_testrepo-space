@IsTest(seeAllData=false)
public class createPartnerLibraryTest{
	
	@testSetup
	static void createTestData() {
		Partner_Library_Admins__c pl = new Partner_Library_Admins__c();
		pl.Library_Permission_ID__c = '05P41000000SZlY';
		pl.Member_Id__c = '00GW0000001KA71';
		pl.Name = 'PEM Team';
		insert pl;
		Partner_Library_Folder__c plObj = new Partner_Library_Folder__c();
		plObj.Folder_Level__c = '2';
		plObj.Parent_Folder__c = 'Pricing';
		plObj.Partner_Type__c = 'Distributor';
		plObj.Name = 'Mw Pricing';
		insert plObj;
		PRM_LibraryAutoCreation_Partner_Type__c plib = new PRM_LibraryAutoCreation_Partner_Type__c();
		plib.Name = 'Alliance Partner';
		insert plib; 
	}
	
	private static testMethod void createLibraryTest(){
		
		//Account creation
	//	User runUser = [select id, name from USER where ID ='00541000002bvUt'];
		
		List<Account> AccountList = new List<Account>();
		List<Account> accountCreation = TestDataFactory.createAccount(6);
	  /*  accountCreation[0].CH_LE_Customer_Compliance__c='';
		accountCreation[0].Customer_Compliance__c = 'US_AT&T'; */
		accountCreation[0].partner_type__c = 'Value Added Reseller';
		accountCreation[1].partner_type__c = 'Indirect Reseller';
		accountCreation[2].partner_type__c = 'Distributor';
		accountCreation[3].partner_type__c = 'Service Provider';
		accountCreation[4].partner_type__c = 'Industrial Partner / System Integrator';
		accountCreation[5].partner_type__c = 'Alliance Partner';
		AccountList.add(accountCreation[0]);  
	/*	AccountList.add(accountCreation[1]);  
		AccountList.add(accountCreation[2]);  
		AccountList.add(accountCreation[3]);  
		AccountList.add(accountCreation[4]);  
		AccountList.add(accountCreation[5]);  */
		database.insert(AccountList); 
		system.debug('Account insertion'+AccountList);
		//AccountTriggerHelperPRM.createPartnerLibraryAfterInsert(AccountList);
		set<ID> createLibraryAcc = new set<ID>();
		
		for(Account acc : accountCreation){
			createLibraryAcc.add(acc.id);
		}
	//	ID jobID = System.enqueueJob(new createPartnerLibrary(createLibraryAcc));	
		
		//system.runas(runUser){
		set<ID> libParentFolder = new set<ID>(); 
		set<ID> libID = new set<ID>(); 
		List<ContentWorkspace> lib = new List<ContentWorkspace>();
		lib = [select ID,RootContentFolderId from contentworkspace where id ='058W00000000ylW' limit 1];
		if (lib .size()>0){
			
			libID.add(lib[0].ID);
		}
		libParentFolder.add('07HW0000000CckkMAC');
		createPartnerLibrary.createVarSubFolder(libParentFolder);
		createPartnerLibrary.createDistSubFolder(libParentFolder);
		createPartnerLibrary.createSProviderSubFolder(libParentFolder);
		createPartnerLibrary.createIResllerSubFolder(libParentFolder);
		createPartnerLibrary.createIndPartnerSubFolder(libParentFolder);
		createPartnerLibrary.createAllPartnerSubFolder(libParentFolder);
		createPartnerLibrary.addMembers(libID);  
		List<Partner_Library_Folder__c> allFolders = new List<Partner_Library_Folder__c> ();
		allFolders = [select id, name, Folder_Level__c, Parent_Folder__c  
	from Partner_Library_Folder__c 
	where Partner_Type__c = 'Alliance Partner'];
		System.debug('allFolders:::'+allFolders);
		
	}
	private static testMethod void createLibraryTest5(){
		
		//Account creation
		//User runUser = [select id, name from USER where ID ='00541000002bvUt'];
		
		List<Account> AccountList = new List<Account>();
		List<Account> accountCreation = TestDataFactory.createAccount(6);
	  /*  accountCreation[0].CH_LE_Customer_Compliance__c='';
		accountCreation[0].Customer_Compliance__c = 'US_AT&T'; */
		accountCreation[0].partner_type__c = 'Value Added Reseller';
		accountCreation[1].partner_type__c = 'Indirect Reseller';
		accountCreation[2].partner_type__c = 'Distributor';
		accountCreation[3].partner_type__c = 'Service Provider';
		accountCreation[4].partner_type__c = 'Industrial Partner / System Integrator';
		accountCreation[5].partner_type__c = 'Alliance Partner';
		//AccountList.add(accountCreation[0]);  
		AccountList.add(accountCreation[1]);  
	/*	AccountList.add(accountCreation[2]);  
		AccountList.add(accountCreation[3]);  
		AccountList.add(accountCreation[4]);  
		AccountList.add(accountCreation[5]);  */
		database.insert(AccountList); 
		system.debug('Account insertion'+AccountList);
		//AccountTriggerHelperPRM.createPartnerLibraryAfterInsert(AccountList);
		set<ID> createLibraryAcc = new set<ID>();
		
		for(Account acc : accountCreation){
			createLibraryAcc.add(acc.id);
		}
		//ID jobID = System.enqueueJob(new createPartnerLibrary(createLibraryAcc));	
		
		//system.runas(runUser){
		set<ID> libParentFolder = new set<ID>(); 
		set<ID> libID = new set<ID>(); 
		List<ContentWorkspace> lib = new List<ContentWorkspace>();
		lib = [select ID,RootContentFolderId from contentworkspace where id ='058W00000000ylW' limit 1];
		if (lib .size()>0){
			
			libID.add(lib[0].ID);
		}
		libParentFolder.add('07HW0000000CckkMAC');
		createPartnerLibrary.createVarSubFolder(libParentFolder);
		createPartnerLibrary.createDistSubFolder(libParentFolder);
		createPartnerLibrary.createSProviderSubFolder(libParentFolder);
		createPartnerLibrary.createIResllerSubFolder(libParentFolder);
		createPartnerLibrary.createIndPartnerSubFolder(libParentFolder);
		createPartnerLibrary.createAllPartnerSubFolder(libParentFolder);
		createPartnerLibrary.addMembers(libID);  
		List<Partner_Library_Folder__c> allFolders = new List<Partner_Library_Folder__c> ();
		allFolders = [select id, name, Folder_Level__c, Parent_Folder__c  
	from Partner_Library_Folder__c 
	where Partner_Type__c = 'Alliance Partner'];
		System.debug('allFolders:::'+allFolders);
		
	}
	 private static testMethod void createLibraryTest7(){
		
		//Account creation
		//User runUser = [select id, name from USER where ID ='00541000002bvUt'];
		
		List<Account> AccountList = new List<Account>();
		List<Account> accountCreation = TestDataFactory.createAccount(6);
	  /*  accountCreation[0].CH_LE_Customer_Compliance__c='';
		accountCreation[0].Customer_Compliance__c = 'US_AT&T'; */
		accountCreation[0].partner_type__c = 'Value Added Reseller';
		accountCreation[1].partner_type__c = 'Indirect Reseller';
		accountCreation[2].partner_type__c = 'Distributor';
		accountCreation[3].partner_type__c = 'Service Provider';
		accountCreation[4].partner_type__c = 'Industrial Partner / System Integrator';
		accountCreation[5].partner_type__c = 'Alliance Partner';
		//AccountList.add(accountCreation[0]);  
	//	AccountList.add(accountCreation[1]);  
		AccountList.add(accountCreation[2]);  
	/*	AccountList.add(accountCreation[3]);  
		AccountList.add(accountCreation[4]);  
		AccountList.add(accountCreation[5]);  */
		database.insert(AccountList); 
		system.debug('Account insertion'+AccountList);
		//AccountTriggerHelperPRM.createPartnerLibraryAfterInsert(AccountList);
		set<ID> createLibraryAcc = new set<ID>();
		
		for(Account acc : accountCreation){
			createLibraryAcc.add(acc.id);
		}
		//ID jobID = System.enqueueJob(new createPartnerLibrary(createLibraryAcc));	
		
		//system.runas(runUser){
		set<ID> libParentFolder = new set<ID>(); 
		set<ID> libID = new set<ID>(); 
		List<ContentWorkspace> lib = new List<ContentWorkspace>();
		lib = [select ID,RootContentFolderId from contentworkspace where id ='058W00000000ylW' limit 1];
		if (lib .size()>0){
			
			libID.add(lib[0].ID);
		}
		libParentFolder.add('07HW0000000CckkMAC');
		createPartnerLibrary.createVarSubFolder(libParentFolder);
		createPartnerLibrary.createDistSubFolder(libParentFolder);
		createPartnerLibrary.createSProviderSubFolder(libParentFolder);
		createPartnerLibrary.createIResllerSubFolder(libParentFolder);
		createPartnerLibrary.createIndPartnerSubFolder(libParentFolder);
		createPartnerLibrary.createAllPartnerSubFolder(libParentFolder);
		createPartnerLibrary.addMembers(libID);  
		List<Partner_Library_Folder__c> allFolders = new List<Partner_Library_Folder__c> ();
		allFolders = [select id, name, Folder_Level__c, Parent_Folder__c  
	from Partner_Library_Folder__c 
	where Partner_Type__c = 'Alliance Partner'];
		System.debug('allFolders:::'+allFolders);
		
	}
	 private static testMethod void createLibraryTest4(){
		
		//Account creation
	//	User runUser = [select id, name from USER where ID ='00541000002bvUt'];
		
		List<Account> AccountList = new List<Account>();
		List<Account> accountCreation = TestDataFactory.createAccount(6);
	  /*  accountCreation[0].CH_LE_Customer_Compliance__c='';
		accountCreation[0].Customer_Compliance__c = 'US_AT&T'; */
		accountCreation[0].partner_type__c = 'Value Added Reseller';
		accountCreation[1].partner_type__c = 'Indirect Reseller';
		accountCreation[2].partner_type__c = 'Distributor';
		accountCreation[3].partner_type__c = 'Service Provider';
		accountCreation[4].partner_type__c = 'Industrial Partner / System Integrator';
		accountCreation[5].partner_type__c = 'Alliance Partner';
		//AccountList.add(accountCreation[0]);  
		//AccountList.add(accountCreation[1]);  
	//	AccountList.add(accountCreation[2]);  
		AccountList.add(accountCreation[3]);  
	/*	AccountList.add(accountCreation[4]);  
		AccountList.add(accountCreation[5]);  */
		database.insert(AccountList); 
		system.debug('Account insertion'+AccountList);
		//AccountTriggerHelperPRM.createPartnerLibraryAfterInsert(AccountList);
		set<ID> createLibraryAcc = new set<ID>();
		
		for(Account acc : accountCreation){
			createLibraryAcc.add(acc.id);
		}
	//	ID jobID = System.enqueueJob(new createPartnerLibrary(createLibraryAcc));	
		
		//system.runas(runUser){
		set<ID> libParentFolder = new set<ID>(); 
		set<ID> libID = new set<ID>(); 
		List<ContentWorkspace> lib = new List<ContentWorkspace>();
		lib = [select ID,RootContentFolderId from contentworkspace where id ='058W00000000ylW' limit 1];
		if (lib .size()>0){
			
			libID.add(lib[0].ID);
		}
		libParentFolder.add('07HW0000000CckkMAC');
		createPartnerLibrary.createVarSubFolder(libParentFolder);
		createPartnerLibrary.createDistSubFolder(libParentFolder);
		createPartnerLibrary.createSProviderSubFolder(libParentFolder);
		createPartnerLibrary.createIResllerSubFolder(libParentFolder);
		createPartnerLibrary.createIndPartnerSubFolder(libParentFolder);
		createPartnerLibrary.createAllPartnerSubFolder(libParentFolder);
		createPartnerLibrary.addMembers(libID);  
		List<Partner_Library_Folder__c> allFolders = new List<Partner_Library_Folder__c> ();
		allFolders = [select id, name, Folder_Level__c, Parent_Folder__c  
	from Partner_Library_Folder__c 
	where Partner_Type__c = 'Alliance Partner'];
		System.debug('allFolders:::'+allFolders);
		
	}
	 private static testMethod void createLibraryTest1(){
		
		//Account creation
		//User runUser = [select id, name from USER where ID ='00541000002bvUt'];
		
		List<Account> AccountList = new List<Account>();
		List<Account> accountCreation = TestDataFactory.createAccount(6);
	  /*  accountCreation[0].CH_LE_Customer_Compliance__c='';
		accountCreation[0].Customer_Compliance__c = 'US_AT&T'; */
		accountCreation[0].partner_type__c = 'Value Added Reseller';
		accountCreation[1].partner_type__c = 'Indirect Reseller';
		accountCreation[2].partner_type__c = 'Distributor';
		accountCreation[3].partner_type__c = 'Service Provider';
		accountCreation[4].partner_type__c = 'Industrial Partner / System Integrator';
		accountCreation[5].partner_type__c = 'Alliance Partner';
		//AccountList.add(accountCreation[0]);  
	//	AccountList.add(accountCreation[1]);  
	//	AccountList.add(accountCreation[2]);  
	//	AccountList.add(accountCreation[3]);  
		AccountList.add(accountCreation[4]);  
	//	AccountList.add(accountCreation[5]);  */
		database.insert(AccountList); 
		system.debug('Account insertion'+AccountList);
		//AccountTriggerHelperPRM.createPartnerLibraryAfterInsert(AccountList);
		set<ID> createLibraryAcc = new set<ID>();
		
		for(Account acc : accountCreation){
			createLibraryAcc.add(acc.id);
		}
		//ID jobID = System.enqueueJob(new createPartnerLibrary(createLibraryAcc));	
		
		//system.runas(runUser){
		set<ID> libParentFolder = new set<ID>(); 
		set<ID> libID = new set<ID>(); 
		List<ContentWorkspace> lib = new List<ContentWorkspace>();
		lib = [select ID,RootContentFolderId from contentworkspace where id ='058W00000000ylW' limit 1];
		if (lib .size()>0){
			
			libID.add(lib[0].ID);
		}
		libParentFolder.add('07HW0000000CckkMAC');
		createPartnerLibrary.createVarSubFolder(libParentFolder);
		createPartnerLibrary.createDistSubFolder(libParentFolder);
		createPartnerLibrary.createSProviderSubFolder(libParentFolder);
		createPartnerLibrary.createIResllerSubFolder(libParentFolder);
		createPartnerLibrary.createIndPartnerSubFolder(libParentFolder);
		createPartnerLibrary.createAllPartnerSubFolder(libParentFolder);
		createPartnerLibrary.addMembers(libID);  
		List<Partner_Library_Folder__c> allFolders = new List<Partner_Library_Folder__c> ();
		allFolders = [select id, name, Folder_Level__c, Parent_Folder__c  
	from Partner_Library_Folder__c 
	where Partner_Type__c = 'Alliance Partner'];
		System.debug('allFolders:::'+allFolders);
		
	}
	private static testMethod void createLibraryTest2(){
		
		//Account creation
		User runUser = [select id, name from USER where ID ='00541000002bvUt'];
		
		List<Account> AccountList = new List<Account>();
		List<Account> accountCreation = TestDataFactory.createAccount(6);
	  /*  accountCreation[0].CH_LE_Customer_Compliance__c='';
		accountCreation[0].Customer_Compliance__c = 'US_AT&T'; */
		accountCreation[0].partner_type__c = 'Value Added Reseller';
		accountCreation[1].partner_type__c = 'Indirect Reseller';
		accountCreation[2].partner_type__c = 'Distributor';
		accountCreation[3].partner_type__c = 'Service Provider';
		accountCreation[4].partner_type__c = 'Industrial Partner / System Integrator';
		accountCreation[5].partner_type__c = 'Alliance Partner';
	/*	//AccountList.add(accountCreation[0]);  
		//AccountList.add(accountCreation[1]);  
		AccountList.add(accountCreation[2]);  
		AccountList.add(accountCreation[3]);  
		AccountList.add(accountCreation[4]);  */
		AccountList.add(accountCreation[5]);  
		database.insert(AccountList); 
		system.debug('Account insertion'+AccountList);
		//AccountTriggerHelperPRM.createPartnerLibraryAfterInsert(AccountList);
		set<ID> createLibraryAcc = new set<ID>();
		
		for(Account acc : accountCreation){
			createLibraryAcc.add(acc.id);
		}
		ID jobID = System.enqueueJob(new createPartnerLibrary(createLibraryAcc));	
		
		//system.runas(runUser){
		set<ID> libParentFolder = new set<ID>(); 
		set<ID> libID = new set<ID>(); 
		List<ContentWorkspace> lib = new List<ContentWorkspace>();
		lib = [select ID,RootContentFolderId from contentworkspace where id ='058W00000000ylW' limit 1];
		if (lib .size()>0){
			
			libID.add(lib[0].ID);
		}
		libParentFolder.add('07HW0000000CckkMAC');
		createPartnerLibrary.createVarSubFolder(libParentFolder);
		createPartnerLibrary.createDistSubFolder(libParentFolder);
		createPartnerLibrary.createSProviderSubFolder(libParentFolder);
		createPartnerLibrary.createIResllerSubFolder(libParentFolder);
		createPartnerLibrary.createIndPartnerSubFolder(libParentFolder);
		createPartnerLibrary.createAllPartnerSubFolder(libParentFolder);
		createPartnerLibrary.addMembers(libID);  
		List<Partner_Library_Folder__c> allFolders = new List<Partner_Library_Folder__c> ();
		allFolders = [select id, name, Folder_Level__c, Parent_Folder__c  
	from Partner_Library_Folder__c 
	where Partner_Type__c = 'Alliance Partner'];
		System.debug('allFolders:::'+allFolders);
		
	}
	 
}