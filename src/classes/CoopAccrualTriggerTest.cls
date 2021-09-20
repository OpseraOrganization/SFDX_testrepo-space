@isTest
public class CoopAccrualTriggerTest {
  //test class for processHFLOFClaims method
	
	
	static testMethod void activeAllcOnSubmittedClaimTest(){
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;  
		
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
			Test.startTest();
			Account acc = new Account();
			acc = TestDataFactory.createAccount(1)[0];
			acc.Enrolled_in_Co_Op__c = true;
			insert acc;
			
			Fund__c mainFund = [Select Id, Name, Partner_Name__c from Fund__c where Partner_Name__c = :acc.id and PRM_Main_Fund__c = true limit 1];	 
			List<Co_Op_Allocation__c> allocationList1 = new List<Co_Op_Allocation__c>();
			List<Co_Op_Allocation__c> allocationList2 = new List<Co_Op_Allocation__c>();
			Co_Op_Allocation__c allocation1 = new Co_Op_Allocation__c(Fund_Id__c = mainFund.id,Co_Op_Allocation_Amount__c = 400.00,Transfers_in_Amount__c = 100.00,Transfers_out_Amount__c = 50.00, Status__c = 'Active',CurrencyIsoCode='EUR',Allocation_Month__c='May',Allocation_Year__c='2015');
			Co_Op_Allocation__c allocation3 = new Co_Op_Allocation__c(Fund_Id__c = mainFund.id,Co_Op_Allocation_Amount__c = 400.00,Transfers_in_Amount__c = 100.00,Transfers_out_Amount__c = 50.00, Status__c = 'Active',CurrencyIsoCode='EUR',Allocation_Month__c='May',Allocation_Year__c='');
			Co_Op_Allocation__c allocation4 = new Co_Op_Allocation__c(Fund_Id__c = mainFund.id,Co_Op_Allocation_Amount__c = 400.00,Transfers_in_Amount__c = 100.00,Transfers_out_Amount__c = 50.00, Status__c = 'Active',CurrencyIsoCode='EUR',Allocation_Month__c='',Allocation_Year__c='2016');
			Co_Op_Allocation__c allocation5 = new Co_Op_Allocation__c(Fund_Id__c = mainFund.id,Co_Op_Allocation_Amount__c = 400.00,Transfers_in_Amount__c = 100.00,Transfers_out_Amount__c = 50.00, Status__c = 'Active',CurrencyIsoCode='EUR',Allocation_Month__c='',Allocation_Year__c='');
			allocationList1.add(allocation1);
			allocationList1.add(allocation3);
			allocationList1.add(allocation4);
			allocationList1.add(allocation5);
			insert allocationList1;
			Map<Id,Co_Op_Allocation__c> mapofCoop = new Map<Id,Co_Op_Allocation__c>();
			mapofCoop.put(allocation1.id,allocation1);
			mapofCoop.put(allocation3.id,allocation3);
			mapofCoop.put(allocation4.id,allocation4);
			mapofCoop.put(allocation5.id,allocation5);
			system.debug('allocationList1 +' + allocation1.Allocation_Period_Balance__c);
			Co_Op_Allocation__c allocation2 = new Co_Op_Allocation__c(Fund_Id__c = mainFund.id,Co_Op_Allocation_Amount__c = 500.00,Transfers_in_Amount__c = 100.00,Transfers_out_Amount__c = 50.00, Status__c = 'Active',id=allocation1.id,CurrencyIsoCode='EUR',Allocation_Month__c='',Allocation_Year__c='');			
			Co_Op_Allocation__c allocation6 = new Co_Op_Allocation__c(Fund_Id__c = mainFund.id,Co_Op_Allocation_Amount__c = 500.00,Transfers_in_Amount__c = 100.00,Transfers_out_Amount__c = 50.00, Status__c = 'Active',id=allocation3.id,CurrencyIsoCode='EUR',Allocation_Month__c='May',Allocation_Year__c='2015');			
			Co_Op_Allocation__c allocation7 = new Co_Op_Allocation__c(Fund_Id__c = mainFund.id,Co_Op_Allocation_Amount__c = 500.00,Transfers_in_Amount__c = 100.00,Transfers_out_Amount__c = 50.00, Status__c = 'Active',id=allocation4.id,CurrencyIsoCode='EUR',Allocation_Month__c='',Allocation_Year__c='2015');			
			Co_Op_Allocation__c allocation8 = new Co_Op_Allocation__c(Fund_Id__c = mainFund.id,Co_Op_Allocation_Amount__c = 500.00,Transfers_in_Amount__c = 100.00,Transfers_out_Amount__c = 50.00, Status__c = 'Active',id=allocation5.id,CurrencyIsoCode='EUR',Allocation_Month__c='May',Allocation_Year__c='');
			allocationList2.add(allocation2);
			allocationList2.add(allocation6);
			allocationList2.add(allocation7);
			allocationList2.add(allocation8);
			
			update allocationList2;

			list<Co_Op_Activity__c> activityList = new list<Co_Op_Activity__c>();
			Co_Op_Activity__c activity1 = new Co_Op_Activity__c(Cost_of_Activity__c=10, Reimbursement_Amount_Requested__c=20,Partner_Account__c = acc.id, Activity_Type__c = 'Advertising', Start_Date__c = system.today()+15, End_Date__c = system.today()+100, Fund_Id__c = mainFund.id, Activity_Status__c = 'New');
			activityList.add(activity1);
			insert activityList;
			
			list<Claim__c> claimList = new list<Claim__c>();
			Claim__c claim1 = new Claim__c(Partner_Account__c = acc.id, Fund__c= mainFund.id, Activity_Number__c = activity1.id, /*HFLOF_Amount__c = 10.00*/ Claim_Status__c = 'Submitted', Claim_Amount_Passed_Audit__c = 900.00);
			claimList.add(claim1);
			insert claimList;
			List<Accrual_junction__c> accrualjuncList = new List<Accrual_junction__c>();
			Accrual_junction__c accrualjunc1 = new Accrual_junction__c(Accrual__c = allocation1.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 800.00);
			accrualjuncList.add(accrualjunc1);
			insert accrualjuncList;
			
			CoOpAccrualHelper.activeAllcOnSubmittedClaim(allocationList1);
			CoOpAccrualHandler.afterUpdateOperation(allocationList1, mapofCoop);
			CoOpAccrualHandler.afterUpdateOperation(allocationList1, null);
			Test.stopTest();  
	 
		}
	}
	
	static testMethod void sendEmailForAlloactionupdateTest(){
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;  
		
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
			Test.startTest();
			Account acc = new Account();
			acc = TestDataFactory.createAccount(1)[0];
			acc.Enrolled_in_Co_Op__c = true;
			insert acc;
			Contact con = new Contact();
			con.LastName = PRMGlobalConstants.contactLastname;
			con.AccountId = acc.Id;
			con.Co_op_Eligible__c = true;
			Database.insert(con);
			
			Fund__c mainFund = [Select Id, Name, Partner_Name__c from Fund__c where Partner_Name__c = :acc.id and PRM_Main_Fund__c = true limit 1];
			List<Co_Op_Allocation__c> allocationList1 = new List<Co_Op_Allocation__c>();
			Co_Op_Allocation__c allocation1 = new Co_Op_Allocation__c(Partner_Name__c=acc.Id,Fund_Id__c = mainFund.id,Co_Op_Allocation_Amount__c = 400.00,Transfers_in_Amount__c = 100.00,Transfers_out_Amount__c = 50.00, Status__c = 'Active');
			allocationList1.add(allocation1);
			insert allocationList1;
			system.debug('allocationList1 +' + allocation1.Allocation_Period_Balance__c);
	  Profile pp = [SELECT Id, Name FROM Profile WHERE Name ='PRM Partner Community User Login' LIMIT 1];
			User partnerUser = new User(alias = 'test123', email=PRMGlobalConstants.TestEmailPartnerUser,
	emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
	localesidkey='en_US', profileid = pp.Id, country='United States of America',IsActive =true,
	ContactId = con.Id,
	timezonesidkey='America/Los_Angeles', username='testertestttt@noemail.com', Nokia_ID__c = '211512');
			Database.insert(partnerUser);
			CoOpAccrualHelper.sendEmailForAlloactionupdate(allocationList1);
			Test.stopTest();  
	}
	}
	static testMethod void createNewTaskTest(){
			String orgId = UserInfo.getOrganizationId();
			String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
			Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
			String uniqueName =   dateString + randomInt;  
		
			List<user> runAsUSer = new List<user>();
			runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
			runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
			runAsUSer[0].NSA_Compliant__c = true;
			database.insert(runAsUSer);
			system.runAs(runAsUSer[0]){
			Test.startTest();
			Account acc = new Account();
			acc = TestDataFactory.createAccount(1)[0];
			acc.Enrolled_in_Co_Op__c = true;
			insert acc;
			Contact con = new Contact();
			con.LastName = PRMGlobalConstants.contactLastname;
			con.AccountId = acc.Id;
			con.Co_op_Eligible__c = true;
			Database.insert(con);
			
			Fund__c mainFund = [Select Id, Name, Partner_Name__c from Fund__c where Partner_Name__c = :acc.id and PRM_Main_Fund__c = true limit 1];
			Date d1 = date.today();
			List<Co_Op_Allocation__c> la= new List<Co_Op_Allocation__c>();
			Co_Op_Allocation__c allocation1 = new Co_Op_Allocation__c(Expiration_Date__c=d1,days_to_expire__C='15 DAY',Fund_Id__c = mainFund.id,Partner_Name__c=acc.Id,Co_Op_Allocation_Amount__c = 400.00, Status__c = 'Active');
			la.add(allocation1);
			insert la;
	 
			List<Co_Op_Allocation__c> la2= new List<Co_Op_Allocation__c>();
			Co_Op_Allocation__c allocation2 = new Co_Op_Allocation__c(Expiration_Date__c=d1,days_to_expire__C='30 DAY',Fund_Id__c = mainFund.id,Partner_Name__c=acc.Id,Co_Op_Allocation_Amount__c = 500.00, Status__c = 'Active');
			la2.add(allocation2);
			insert la2;
	 
			List<User> lu = new List<User>();
			Profile pp = [SELECT Id, Name FROM Profile WHERE Name ='PRM Partner Community User Login' LIMIT 1];
	User partnerUser = new User(alias = 'test123', email=PRMGlobalConstants.TestEmailPartnerUser,
	emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
	localesidkey='en_US', profileid = pp.Id, country='United States of America',IsActive =true,
	ContactId = con.Id,
	timezonesidkey='America/Los_Angeles', username='testertestttt@noemail.com', Nokia_ID__c = '211512');
			Database.insert(partnerUser);
			List<Task> inserttask = new List<Task>();
		 
			for(User u : lu)
			{ 
	Task t = new Task();
	Date d = date.today();
	t.OwnerId = u.id;
	t.Status='Open';
	t.Priority='Normal';
	t.WhatId=la[0].Id;
		//system.debug('t.WhatId '+t.WhatId);
	
	
	if(la[0].days_to_expire__c == '15 DAY' && la[0].Allocation_Period_Balance__c != 0 && la[0].Status__c == PRMGlobalConstants.ActiveSt)
		 {
		t.ActivityDate=d + 15 ;
		t.Subject='15 Days Co-op Allocation Expiry Notification. Please submit claims for audit.';
		t.Description='The identified Co-op allocation will expire in 15 days and will be removed from your Co-op balance. Submit claims for audit prior to the Allocation expiry date. Allocations may NOT be reinstated or extended.';
		inserttask.add(t);
		 }
			
	else if(la2[0].days_to_expire__c == '30 DAY' && la2[0].Allocation_Period_Balance__c != 0 && la2[0].Status__c == PRMGlobalConstants.ActiveSt)
		 {
		t.ActivityDate=d + 30 ;
		t.Subject='30 Days Co-op Allocation Expiry Notification. Please submit claims for audit.';
		t.Description='The identified Co-op allocation will expire in 30 days and will be removed from your Co-op balance. Submit claims for audit prior to the Allocation expiry date. Allocations may NOT be reinstated or extended.';
		inserttask.add(t);
		 }
		}
		 insert inserttask;
			CoOpAccrualHelper.createNewTask(la);
			CoOpAccrualHelper.createNewTask(la2);
			Test.stopTest();  
	}
	}
	
	static testMethod void processHFLOFClaimsTest(){
		String orgId = UserInfo.getOrganizationId();
		String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String uniqueName =   dateString + randomInt;  
		
		List<user> runAsUSer = new List<user>();
		runAsUSer = TestDataFactory.userCreation(2,'System Administrator');
		runAsUSer[0].UserRoleId  = system.Label.Global_Role_ID;
		runAsUSer[0].NSA_Compliant__c = true;
		database.insert(runAsUSer);
		system.runAs(runAsUSer[0]){
			Test.startTest();
			Account acc = new Account();
			acc = TestDataFactory.createAccount(1)[0];
			acc.Enrolled_in_Co_Op__c = true;
			insert acc;
			
			Fund__c mainFund = [Select Id, Name, Partner_Name__c from Fund__c where Partner_Name__c = :acc.id and PRM_Main_Fund__c = true limit 1];
			List<Co_Op_Allocation__c> allocationList1 = new List<Co_Op_Allocation__c>();
			Co_Op_Allocation__c allocation1 = new Co_Op_Allocation__c(Expiration_Amount__c=50, Co_Op_Allocation_Amount__c=1000, Fund_Id__c = mainFund.id,Transfers_in_Amount__c = 100.00,Transfers_out_Amount__c = 50.00, Status__c = 'Active');
			allocationList1.add(allocation1);
			insert allocationList1;

			list<Co_Op_Activity__c> activityList = new list<Co_Op_Activity__c>();
			Co_Op_Activity__c activity1 = new Co_Op_Activity__c(Cost_of_Activity__c=10, Reimbursement_Amount_Requested__c=20,Partner_Account__c = acc.id, Activity_Type__c = 'Advertising', Start_Date__c = system.today()+15, End_Date__c = system.today()+100, Fund_Id__c = mainFund.id, Activity_Status__c = 'New');
			activityList.add(activity1);
			insert activityList;
			
			list<Claim__c> claimList = new list<Claim__c>();
			Claim__c claim1 = new Claim__c(HFLOF_Amount__c= 10, Partner_Account__c = acc.id, Fund__c= mainFund.id, Activity_Number__c = activity1.id, /*HFLOF_Amount__c = 10.00*/ Claim_Status__c = 'Submitted', Claim_Amount_Passed_Audit__c = 900.00);
			claimList.add(claim1);
			insert claimList;
			List<Accrual_junction__c> accrualjuncList = new List<Accrual_junction__c>();
			Accrual_junction__c accrualjunc1 = new Accrual_junction__c(Status__c = 'Pending Reimbursement', Amount_deducted_from_accrual__c = 50, Accrual__c = allocation1.id,Partner_Fund_Claim__c = claim1.id);
			accrualjuncList.add(accrualjunc1);
			Accrual_junction__c accrualjun2 = new Accrual_junction__c(Status__c = 'Reimbursed', Amount_deducted_from_accrual__c = 50, Accrual__c = allocation1.id,Partner_Fund_Claim__c = claim1.id);
			accrualjuncList.add(accrualjun2);
			insert accrualjuncList;
			List<Co_Op_Allocation__c> allocationList2 = [select id,Expiration_Amount__c, Co_Op_Allocation_Amount__c, Fund_Id__c, Transfers_in_Amount__c, Transfers_out_Amount__c, Status__c, Allocation_Period_Balance__c from Co_Op_Allocation__c where id =: allocation1.Id];
			system.debug('allocationList2 +' + [select id,Fund_Id__c,Allocation_Period_Balance__c from Co_Op_Allocation__c where id =: allocation1.Id].Allocation_Period_Balance__c);
			CoOpAccrualHelper.processHFLOFClaims(allocationList2);
			Test.stopTest();  
	 
		}
	}
}