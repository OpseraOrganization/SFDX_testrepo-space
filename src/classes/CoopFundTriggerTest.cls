@isTest
public class CoopFundTriggerTest { 
  //test class for fundshare
  static testMethod void fundShare(){
	String orgId = UserInfo.getOrganizationId();
	String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
	Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
	String uniqueName =   dateString + randomInt; 
   
	List<user> runUSer = new List<user>(); 
	runUSer = TestDataFactory.userCreation(2,'System Administrator');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
	  Test.startTest(); 
	  Account acc = new Account();
	  acc = TestDataFactory.createAccount(1)[0];
	  acc.Enrolled_in_Co_Op__c = true;
	  insert acc;
	  Account acc2 = new Account();
	  acc2 = TestDataFactory.createAccount(1)[0];
	  acc2.Enrolled_in_Co_Op__c = true;
	  acc2.AccountNumber = '301011872';
	  insert acc2;
	  List<OTM_Sharing_Exception__c> accountSharingSettingList = new List<OTM_Sharing_Exception__c>();
	  OTM_Sharing_Exception__c sharing1 = new OTM_Sharing_Exception__c(Name = acc.id, Contact_Account_Name__c=acc2.id);
	  OTM_Sharing_Exception__c sharing2 = new OTM_Sharing_Exception__c(Name = acc2.id, Contact_Account_Name__c=acc.id);
	  accountSharingSettingList.add(sharing1);
	  accountSharingSettingList.add(sharing2);
	  insert accountSharingSettingList;
	  Contact conPRM = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc.id,Email=PRMGlobalConstants.EmailContactNamePRM );
	  database.insert(conPRM);
	  List<user> userList = new List<user>();
	  User userPRM1 = new User(alias = 'abc', email = uniqueName + '@nokia.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test',	 lastname = 'Testing',
	 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
	 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM.Id );
	  userList.add(userPRM1);
	  database.insert(userList); 
	  
	  Contact conPRM1 = new Contact(lastName=PRMGlobalConstants.ContactNamePRM,AccountId=acc2.id,Email='fundsharetest@prm.com');
	  database.insert(conPRM1);
	  User userPRM2 = new User(alias = 'abc1', email = uniqueName + '@nokiaa.com' /*+ orgId '.org' */, emailencodingkey = 'UTF-8', firstName = 'test1', lastname = 'Testing1',
	 languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = system.Label.PRM_Partner_Relationship_Manager_Login_ID,  Country__c= 'Canada',Market__c='MARKET NORTH AMERICA',
	 timezonesidkey = 'America/Los_Angeles', Username = uniqueName + '@nokia1.com' + orgId + '.org',Restriction_Level__c = 'Confidential', ContactId  = conPRM1.Id );
	  insert userPRM2;
	  userList.add(userPRM2);
	  
	  CoOpFundBatch batch = new CoOpFundBatch(userList);
	  Database.executeBatch(batch);
	  
	  Test.stopTest(); 

	  
	}
	
  }
  
  static testMethod void MonthlyAccrualCreation(){
   
	List<user> runUSer = new List<user>();
	runUSer = TestDataFactory.userCreation(2,'System Administrator');
	runUSer[0].UserRoleId  = system.Label.Global_Role_ID;
	runUSer[0].NSA_Compliant__c = true;
	database.insert(runUSer);
	system.runAs(runUSer[0]){
	  Account acc = new Account();
	  acc = TestDataFactory.createAccount(1)[0];
	  acc.Enrolled_in_Co_Op__c = true;
	  insert acc;
	  
	  
	  Test.startTest();
	  MonthlyAccrualCreation sc= new MonthlyAccrualCreation(date.newinstance(2018, 01, 01));
	  sc.execute(null);
	  sc= new MonthlyAccrualCreation(date.newinstance(2018, 01, 01));
	  sc.execute(null);
	  
	  Test.stopTest(); 

	  
	}
	
  }
  //Test class for accrualClaimAssociation
  static testMethod void accrualClaimAssociationTest(){
	
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
		List<Fund__c> fund = new list<Fund__c>();
		Fund__c Fundlist = new Fund__c(Partner_Name__c = acc.id, PRM_Main_Fund__c = true);
		fund.add(Fundlist);
	// insert fund;
	  Fund__c fund1 = [Select Id from Fund__c where Partner_Name__c = :acc.id and PRM_Main_Fund__c = true limit 1];
	  
	  List<Co_Op_Allocation__c> allocationList = new List<Co_Op_Allocation__c>();
	  Co_Op_Allocation__c allocation1 = new Co_Op_Allocation__c(Name = 'Gopi', Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 100,Transfers_in_Amount__c = 100,Transfers_out_Amount__c = 50, Status__c = 'Active');
	  allocationList.add(allocation1);
	  Co_Op_Allocation__c allocation2 = new Co_Op_Allocation__c(Name = 'Gopi-1', Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 200, Status__c = 'Active');
	  allocationList.add(allocation2);
	  Co_Op_Allocation__c allocation3 = new Co_Op_Allocation__c(Name = 'Gopi-2', Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 100,Transfers_in_Amount__c = 100,Transfers_out_Amount__c = 50, Status__c = 'Expired');
	  allocationList.add(allocation3);
	  insert allocationList;
   
	  allocation1.Co_Op_Allocation_Amount__c = 200;
	  update allocation1;
	  allocation3.Co_Op_Allocation_Amount__c = 200;
	  update allocation3;
	 
  
	  list<Co_Op_Activity__c> activityList = new list<Co_Op_Activity__c>();
	  Co_Op_Activity__c activity1 = new Co_Op_Activity__c(Partner_Account__c = acc.id, Activity_Type__c = 'Advertising', Start_Date__c = system.today()+15, End_Date__c = system.today()+100, Fund_Id__c = fund1.id, Activity_Status__c = 'New' , Cost_of_Activity__c = 5.0, Reimbursement_Amount_Requested__c = 20.0);
	  activityList.add(activity1);
	  Co_Op_Activity__c activity2 = new Co_Op_Activity__c(Partner_Account__c = acc.id, Activity_Type__c = 'Telemarketing', Start_Date__c = system.today()+15, End_Date__c = system.today()+100, Fund_Id__c = fund1.id, Activity_Status__c = 'New', Cost_of_Activity__c = 5.0, Reimbursement_Amount_Requested__c = 20.0);
	  activityList.add(activity2);
	  Co_Op_Activity__c activity3 = new Co_Op_Activity__c(Partner_Account__c = acc.id, Activity_Type__c = 'Demonstration Equipment', Start_Date__c = system.today(), End_Date__c = system.today()+100, Fund_Id__c = fund1.id, Activity_Status__c = 'New', Cost_of_Activity__c = 5.0, Reimbursement_Amount_Requested__c = 20.0);
	  activityList.add(activity3);
	  
	  
	  insert activityList;
	  
	  list<Claim__c> claimList = new list<Claim__c>();
	  Claim__c claim1 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, HFLOF_Amount__c = 10, Claim_Status__c = 'Submitted', Claim_Amount_Passed_Audit__c = 100,Activity_Claim_Amount__c=50);
	  claimList.add(claim1);
	  Claim__c claim2 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, HFLOF_Amount__c = 150, Claim_Status__c = 'HFLOF', Claim_Amount_Passed_Audit__c = 300, Is_this_Last_Claim__c = PRMGlobalConstants.YES,Activity_Claim_Amount__c=50);
	  claimList.add(claim2);
   Claim__c claim3 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, HFLOF_Amount__c = 150, Claim_Status__c = 'created', Claim_Amount_Passed_Audit__c = 300, Is_this_Last_Claim__c = PRMGlobalConstants.YES);
	  claimList.add(claim3);
  Claim__c claim4 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, Claim_Status__c = 'created', Claim_Amount_Passed_Audit__c = 300, Is_this_Last_Claim__c = PRMGlobalConstants.NO);
	  claimList.add(claim4);
	  insert claimList;
   
	  List<Accrual_junction__c> accrualjuncList = new List<Accrual_junction__c>();
	  Accrual_junction__c accrualjunc1 = new Accrual_junction__c(Accrual__c = allocation1.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 30,Reimbursed_Type__c='Normal',Status__c='Submitted');
	  accrualjuncList.add(accrualjunc1);
	  Accrual_junction__c accrualjunc2 = new Accrual_junction__c(Accrual__c = allocation1.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 10);
	  accrualjuncList.add(accrualjunc2);
	  Accrual_junction__c accrualjunc5 = new Accrual_junction__c(Accrual__c = allocation1.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 40,Reimbursed_Type__c='Normal',Status__c='Submitted');
	  accrualjuncList.add(accrualjunc5);
	  Accrual_junction__c accrualjunc3 = new Accrual_junction__c(Accrual__c = allocation3.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 30);
	  accrualjuncList.add(accrualjunc3);
	  Accrual_junction__c accrualjunc4 = new Accrual_junction__c(Accrual__c = allocation3.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 10);
	  accrualjuncList.add(accrualjunc4);
	  insert accrualjuncList;
	  
	  List<Co_Op_Activity__c> activityList2 = new List<Co_Op_Activity__c>();
	  activity1.Activity_Status__c = 'Approved';
	  activityList2.add(activity1);
	  activity2.Activity_Status__c = 'Approved';
	  activityList2.add(activity2);
	  activity3.Activity_Status__c = 'Approved';
	  activityList2.add(activity3);
	  update activityList2;
	  
	  List<Claim__c> claimList2 = new List<Claim__c>();
	  claim1.Claim_Status__c = PRMGlobalConstants.CoopPassedAudit;
	  claim1.Activity_Claim_Amount__c =100;
	  //claim1.Amount_Pending_for_Reimbursement__c = 10;
	  claimList2.add(claim1);
	  claim2.Claim_Status__c = PRMGlobalConstants.CoopPassedAudit;
  //claim2.Amount_Pending_for_Reimbursement__c = 10;
	  claimList2.add(claim2);
	  claim3.Claim_Status__c = PRMGlobalConstants.Claimable;
	  claimList2.add(claim3);
	  update claimList2;
	  
	  claim3.Claim_Status__c = PRMGlobalConstants.CoopSubmitted;
	  update claim3;
	  //claim3.Claim_Amount_Passed_Audit__c=1000;
	  //claim3.Claim_Amount_Passed_Audit__c=100; 
   // update claim3;
   // 
   
   
	  List<CoOp_Claim_Payment__c> PaymentList = new List<CoOp_Claim_Payment__c>();
	  CoOp_Claim_Payment__c payment1 = new CoOp_Claim_Payment__c(Claim__c = claim1.id );
	  PaymentList.add(payment1);
	  CoOp_Claim_Payment__c payment2 = new CoOp_Claim_Payment__c(Claim__c = claim2.id );
	  PaymentList.add(payment2);
	  
	  insert PaymentList;
	  payment1.Reimbursement_Reference_Number__c = '123456';
	  payment2.Reimbursement_Reference_Number__c = '789456';
	  payment1.Amount_Pending_for_Reimbursement__c = 100;
	  payment2.Amount_Pending_for_Reimbursement__c = 300;
	  update PaymentList;
	  
	  claim1.Claim_Status__c = PRMGlobalConstants.CoopReimbursed;
	  claim1.HFLOF_Amount__c = 0;
	  
	  claim2.Claim_Status__c = PRMGlobalConstants.CoopReimbursed;
	  claim2.HFLOF_Amount__c = 0;
	  update claimList2;
	  
	  List<Accrual_junction__c> accrualClaimJunction = new List<Accrual_junction__c>();
	  Accrual_junction__c junction1 = new Accrual_junction__c(Payment__c = payment1.Id, Accrual__c = allocation2.id, Partner_Fund_Claim__c = claim2.id);
	  accrualClaimJunction.add(junction1);
	  Accrual_junction__c junction2 = new Accrual_junction__c(Payment__c = payment2.Id, Accrual__c = allocation2.id, Partner_Fund_Claim__c = claim2.id);
	  accrualClaimJunction.add(junction2);
   
	  insert accrualClaimJunction;
	  //for exception
	  Map<Id,Claim__c> claimOldMap = new Map<Id,Claim__c>();
	  Map<Id,CoOp_Claim_Payment__c> paymentOldMap = new Map<Id,CoOp_Claim_Payment__c>();
	  system.debug('allocation1'+allocation1);
	  system.debug('allocation1.'+allocation3);
	  CoOpClaimHandler.afterUpdateOperation(claimList, claimOldMap);
	  CoOpPaymentHandler.afterUpdateOperation(PaymentList,paymentOldMap);
	  CoOpClaimTriggerHelper.accrualpipelineclaims(claimList);
	  Test.stopTest();
	  
	  
  
	}
  }
  
  static testMethod void accrualClaimAssociationTest3(){
	
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
	 List<Fund__c> fund = new list<Fund__c>();
		Fund__c Fundlist = new Fund__c(Partner_Name__c = acc.id, PRM_Main_Fund__c = true);
		fund.add(Fundlist);
	// insert fund;
	  Fund__c fund1 = [Select Id from Fund__c where Partner_Name__c = :acc.id and PRM_Main_Fund__c = true limit 1];
	  
	  List<Co_Op_Allocation__c> allocationList = new List<Co_Op_Allocation__c>();
	  Co_Op_Allocation__c allocation1 = new Co_Op_Allocation__c(Name = 'Gopi', Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 100,Transfers_in_Amount__c = 100,Transfers_out_Amount__c = 50, Status__c = 'Active');
	  allocationList.add(allocation1);
	  Co_Op_Allocation__c allocation2 = new Co_Op_Allocation__c(Name = 'Gopi-1', Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 200, Status__c = 'Active');
	  allocationList.add(allocation2);
	  Co_Op_Allocation__c allocation3 = new Co_Op_Allocation__c(Name = 'Gopi-2', Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 100,Transfers_in_Amount__c = 100,Transfers_out_Amount__c = 50, Status__c = 'Expired');
	  allocationList.add(allocation3);
	  insert allocationList;
   
	  allocation1.Co_Op_Allocation_Amount__c = 200;
	  update allocation1;
	  allocation3.Co_Op_Allocation_Amount__c = 200;
	  update allocation3;
	 
  
	  list<Co_Op_Activity__c> activityList = new list<Co_Op_Activity__c>();
	  Co_Op_Activity__c activity1 = new Co_Op_Activity__c(Partner_Account__c = acc.id, Activity_Type__c = 'Advertising', Start_Date__c = system.today()+15, End_Date__c = system.today()+100, Fund_Id__c = fund1.id, Activity_Status__c = 'New' , Cost_of_Activity__c = 5.0, Reimbursement_Amount_Requested__c = 20.0);
	  activityList.add(activity1);
	  Co_Op_Activity__c activity2 = new Co_Op_Activity__c(Partner_Account__c = acc.id, Activity_Type__c = 'Telemarketing', Start_Date__c = system.today()+15, End_Date__c = system.today()+100, Fund_Id__c = fund1.id, Activity_Status__c = 'New', Cost_of_Activity__c = 5.0, Reimbursement_Amount_Requested__c = 20.0);
	  activityList.add(activity2);
	  Co_Op_Activity__c activity3 = new Co_Op_Activity__c(Partner_Account__c = acc.id, Activity_Type__c = 'Demonstration Equipment', Start_Date__c = system.today(), End_Date__c = system.today()+100, Fund_Id__c = fund1.id, Activity_Status__c = 'New', Cost_of_Activity__c = 5.0, Reimbursement_Amount_Requested__c = 20.0);
	  activityList.add(activity3);
	  
	  
	  insert activityList;
	  
	  list<Claim__c> claimList = new list<Claim__c>();
	  Claim__c claim1 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, HFLOF_Amount__c = 10, Claim_Status__c = 'Submitted', Claim_Amount_Passed_Audit__c = 100);
	  claimList.add(claim1);
	  Claim__c claim2 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, HFLOF_Amount__c = 150, Claim_Status__c = 'Submitted', Claim_Amount_Passed_Audit__c = 300, Is_this_Last_Claim__c = PRMGlobalConstants.YES);
	  claimList.add(claim2);
   Claim__c claim3 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, HFLOF_Amount__c = 150, Claim_Status__c = 'created', Claim_Amount_Passed_Audit__c = 300, Is_this_Last_Claim__c = PRMGlobalConstants.YES);
	  claimList.add(claim3);
  Claim__c claim4 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, Claim_Status__c = 'created', Claim_Amount_Passed_Audit__c = 300, Is_this_Last_Claim__c = PRMGlobalConstants.NO);
	  claimList.add(claim4);
	  insert claimList;
   
	  List<Accrual_junction__c> accrualjuncList = new List<Accrual_junction__c>();
	  Accrual_junction__c accrualjunc1 = new Accrual_junction__c(Accrual__c = allocation1.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 30);
	  accrualjuncList.add(accrualjunc1);
	  Accrual_junction__c accrualjunc2 = new Accrual_junction__c(Accrual__c = allocation1.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 10);
	  accrualjuncList.add(accrualjunc2);
  // Accrual_junction__c accrualjunc3 = new Accrual_junction__c(Accrual__c = allocation1.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 20);
	//  accrualjuncList.add(accrualjunc3);
	  Accrual_junction__c accrualjunc3 = new Accrual_junction__c(Accrual__c = allocation3.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 30);
	  accrualjuncList.add(accrualjunc3);
	  Accrual_junction__c accrualjunc4 = new Accrual_junction__c(Accrual__c = allocation3.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 10);
	  accrualjuncList.add(accrualjunc4);
	  insert accrualjuncList;
	  
	  List<Co_Op_Activity__c> activityList2 = new List<Co_Op_Activity__c>();
	  activity1.Activity_Status__c = 'Approved';
	  activityList2.add(activity1);
	  activity2.Activity_Status__c = 'Approved';
	  activityList2.add(activity2);
	  activity3.Activity_Status__c = 'Approved';
	  activityList2.add(activity3);
	  update activityList2;
	  
	  List<Claim__c> claimList2 = new List<Claim__c>();
	  claim1.Claim_Status__c = PRMGlobalConstants.CoopPassedAudit;
	  claim1.Activity_Claim_Amount__c =100;
	  //claim1.Amount_Pending_for_Reimbursement__c = 10;
	  claimList2.add(claim1);
	  claim2.Claim_Status__c = PRMGlobalConstants.CoopPassedAudit;
  //claim2.Amount_Pending_for_Reimbursement__c = 10;
	  claimList2.add(claim2);
	  claim3.Claim_Status__c = PRMGlobalConstants.Claimable;
	  claimList2.add(claim3);
	  update claimList2;
	  
	  claim3.Claim_Status__c = PRMGlobalConstants.CoopSubmitted;
	  update claim3;
   
   
	  List<CoOp_Claim_Payment__c> PaymentList = new List<CoOp_Claim_Payment__c>();
	  CoOp_Claim_Payment__c payment1 = new CoOp_Claim_Payment__c(Claim__c = claim1.id );
	  PaymentList.add(payment1);
	  CoOp_Claim_Payment__c payment2 = new CoOp_Claim_Payment__c(Claim__c = claim2.id );
	  PaymentList.add(payment2);
	  
	  insert PaymentList;
	  payment1.Reimbursement_Reference_Number__c = '123456';
	  payment2.Reimbursement_Reference_Number__c = '789456';
	  payment1.Amount_Pending_for_Reimbursement__c = 100;
	  payment2.Amount_Pending_for_Reimbursement__c = 300;
	  update PaymentList;
	  
	  claim1.Claim_Status__c = PRMGlobalConstants.CoopReimbursed;
	  claim1.HFLOF_Amount__c = 0;
	  claim2.Claim_Status__c = PRMGlobalConstants.CoopReimbursed;
	  claim2.HFLOF_Amount__c = 0;
	  update claimList2;
	  
	  List<Accrual_junction__c> accrualClaimJunction = new List<Accrual_junction__c>();
	  Accrual_junction__c junction1 = new Accrual_junction__c(Payment__c = payment1.Id, Accrual__c = allocation2.id, Partner_Fund_Claim__c = claim2.id);
	  accrualClaimJunction.add(junction1);
	  Accrual_junction__c junction2 = new Accrual_junction__c(Payment__c = payment2.Id, Accrual__c = allocation2.id, Partner_Fund_Claim__c = claim2.id);
	  accrualClaimJunction.add(junction2);
   
	  insert accrualClaimJunction;
	  CoOpClaimTriggerHelper.accrualClaimAssociation(claimList);
	  Test.stopTest(); 
	}
  }
  static testMethod void accrualClaimAssociationTest2(){
	
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
	  List<Fund__c> fund = new list<Fund__c>();
		Fund__c Fundlist = new Fund__c(Partner_Name__c = acc.id, PRM_Main_Fund__c = true);
		fund.add(Fundlist);
		// insert fund;
	  Fund__c fund1 = [Select Id from Fund__c where Partner_Name__c = :acc.id and PRM_Main_Fund__c = true limit 1];
	  
	  List<Co_Op_Allocation__c> allocationList = new List<Co_Op_Allocation__c>();
	  //Co_Op_Allocation__c allocation1 = new Co_Op_Allocation__c(Name = 'Gopi', Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 100,Transfers_in_Amount__c = 100,Transfers_out_Amount__c = 50, Status__c = 'Active');
	  //allocationList.add(allocation1);
	  //Co_Op_Allocation__c allocation2 = new Co_Op_Allocation__c(Name = 'Gopi-1', Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 200, Status__c = 'Active');
	  //allocationList.add(allocation2);
	  Co_Op_Allocation__c allocation3 = new Co_Op_Allocation__c(Name = 'Gopi-2', Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 100,Transfers_in_Amount__c = 100,Transfers_out_Amount__c = 50, Status__c = 'Expired');
	  allocationList.add(allocation3);
	  insert allocationList;
   
	  //allocation1.Co_Op_Allocation_Amount__c = 200;
	  //update allocation1;
	  allocation3.Co_Op_Allocation_Amount__c = 200;
	  update allocation3;
	 
  
	  list<Co_Op_Activity__c> activityList = new list<Co_Op_Activity__c>();
	  Co_Op_Activity__c activity1 = new Co_Op_Activity__c(Partner_Account__c = acc.id, Activity_Type__c = 'Advertising', Start_Date__c = system.today()+15, End_Date__c = system.today()+100, Fund_Id__c = fund1.id, Activity_Status__c = 'New' , Cost_of_Activity__c = 5.0, Reimbursement_Amount_Requested__c = 20.0);
	  activityList.add(activity1);
	  Co_Op_Activity__c activity2 = new Co_Op_Activity__c(Partner_Account__c = acc.id, Activity_Type__c = 'Telemarketing', Start_Date__c = system.today()+15, End_Date__c = system.today()+100, Fund_Id__c = fund1.id, Activity_Status__c = 'New', Cost_of_Activity__c = 5.0, Reimbursement_Amount_Requested__c = 20.0);
	  activityList.add(activity2);
	  Co_Op_Activity__c activity3 = new Co_Op_Activity__c(Partner_Account__c = acc.id, Activity_Type__c = 'Demonstration Equipment', Start_Date__c = system.today(), End_Date__c = system.today()+100, Fund_Id__c = fund1.id, Activity_Status__c = 'New', Cost_of_Activity__c = 5.0, Reimbursement_Amount_Requested__c = 20.0);
	  activityList.add(activity3);
	  
	  
	  insert activityList;
	  
	  list<Claim__c> claimList = new list<Claim__c>();
	  Claim__c claim1 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, HFLOF_Amount__c = 10, Claim_Status__c = 'Submitted', Claim_Amount_Passed_Audit__c = 100);
	  claimList.add(claim1);
	  Claim__c claim2 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, HFLOF_Amount__c = 150, Claim_Status__c = 'Submitted', Claim_Amount_Passed_Audit__c = 300, Is_this_Last_Claim__c = PRMGlobalConstants.YES);
	  claimList.add(claim2);
   Claim__c claim3 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, HFLOF_Amount__c = 150, Claim_Status__c = 'created', Claim_Amount_Passed_Audit__c = 300, Is_this_Last_Claim__c = PRMGlobalConstants.YES);
	  claimList.add(claim3);
  Claim__c claim4 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, Claim_Status__c = 'created', Claim_Amount_Passed_Audit__c = 300, Is_this_Last_Claim__c = PRMGlobalConstants.NO);
	  claimList.add(claim4);
	  insert claimList;
   
	  //List<Accrual_junction__c> accrualjuncList = new List<Accrual_junction__c>();
   // Accrual_junction__c accrualjunc1 = new Accrual_junction__c(Accrual__c = allocation1.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 30);
   // accrualjuncList.add(accrualjunc1);
   // Accrual_junction__c accrualjunc2 = new Accrual_junction__c(Accrual__c = allocation1.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 10);
   // accrualjuncList.add(accrualjunc2);
  // Accrual_junction__c accrualjunc3 = new Accrual_junction__c(Accrual__c = allocation1.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 20);
	//  accrualjuncList.add(accrualjunc3);
	  /*Accrual_junction__c accrualjunc3 = new Accrual_junction__c(Accrual__c = allocation3.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 30);
	  accrualjuncList.add(accrualjunc3);
	  Accrual_junction__c accrualjunc4 = new Accrual_junction__c(Accrual__c = allocation3.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 10);
	  accrualjuncList.add(accrualjunc4);
	  insert accrualjuncList;*/
	  
	  List<Co_Op_Activity__c> activityList2 = new List<Co_Op_Activity__c>();
	  activity1.Activity_Status__c = 'Approved';
	  activityList2.add(activity1);
	  activity2.Activity_Status__c = 'Approved';
	  activityList2.add(activity2);
	  activity3.Activity_Status__c = 'Approved';
	  activityList2.add(activity3);
	  update activityList2;
	  
	  List<Claim__c> claimList2 = new List<Claim__c>();
	  claim1.Claim_Status__c = PRMGlobalConstants.CoopPassedAudit;
	  claim1.Activity_Claim_Amount__c =100;
	  //claim1.Amount_Pending_for_Reimbursement__c = 10;
	  claimList2.add(claim1);
	  claim2.Claim_Status__c = PRMGlobalConstants.CoopPassedAudit;
  //claim2.Amount_Pending_for_Reimbursement__c = 10;
	  claimList2.add(claim2);
	  claim3.Claim_Status__c = PRMGlobalConstants.Claimable;
	  claimList2.add(claim3);
	  update claimList2;
	  
	  claim3.Claim_Status__c = PRMGlobalConstants.CoopSubmitted;
	  update claim3;
   
   
	  List<CoOp_Claim_Payment__c> PaymentList = new List<CoOp_Claim_Payment__c>();
	  CoOp_Claim_Payment__c payment1 = new CoOp_Claim_Payment__c(Claim__c = claim1.id );
	  PaymentList.add(payment1);
	  CoOp_Claim_Payment__c payment2 = new CoOp_Claim_Payment__c(Claim__c = claim2.id );
	  PaymentList.add(payment2);
	  
	  insert PaymentList;
	  payment1.Reimbursement_Reference_Number__c = '123456';
	  payment2.Reimbursement_Reference_Number__c = '789456';
	  payment1.Amount_Pending_for_Reimbursement__c = 100;
	  payment2.Amount_Pending_for_Reimbursement__c = 300;
	  update PaymentList;
	  
	  claim1.Claim_Status__c = PRMGlobalConstants.CoopReimbursed;
	  claim1.HFLOF_Amount__c = 0;
	  update claim1;
	  claim2.Claim_Status__c = PRMGlobalConstants.CoopReimbursed;
	  claim2.HFLOF_Amount__c = 0;
	  update claim2;
	  
   // List<Accrual_junction__c> accrualClaimJunction = new List<Accrual_junction__c>();
  //  Accrual_junction__c junction1 = new Accrual_junction__c(Payment__c = payment1.Id, Accrual__c = allocation2.id, Partner_Fund_Claim__c = claim2.id);
  //  accrualClaimJunction.add(junction1);
  //  Accrual_junction__c junction2 = new Accrual_junction__c(Payment__c = payment2.Id, Accrual__c = allocation2.id, Partner_Fund_Claim__c = claim2.id);
  //  accrualClaimJunction.add(junction2);
   
  //  insert accrualClaimJunction;
	  //for exception
	  Map<Id,Claim__c> claimOldMap = new Map<Id,Claim__c>();
	  Map<Id,CoOp_Claim_Payment__c> paymentOldMap = new Map<Id,CoOp_Claim_Payment__c>();
  //  system.debug('allocation1'+allocation1);
   // system.debug('allocation1.'+allocation3);
	  CoOpClaimHandler.afterUpdateOperation(claimList, claimOldMap);
	  CoOpPaymentHandler.afterUpdateOperation(PaymentList,paymentOldMap);
	  CoOpClaimTriggerHelper.accrualpipelineclaims(claimList);
	  CoOpClaimTriggerHelper.accrualClaimAssociation(claimList);
	  Test.stopTest(); 
	}
  }
 public testMethod static void fundShareToAccMemberTest1() {
	User user = TestDataFactory.userCreation(1, 'System Administrator')[0];
	insert user;
	
	List<File_Sharing_Custom_Setting__c> fileSharingCustomSettingList = TestDataFactory.create_File_Sharing_Custom_Setting();
	database.insert(fileSharingCustomSettingList);
	
	
	Account acc = new Account();
	acc = TestDataFactory.createAccount(1)[0];
	acc.Enrolled_in_Co_Op__c = true;
   test.StartTest();
	insert acc;
  
  List<Fund__c> fundList = new List<Fund__c>();
  Fund__c fd = new Fund__c(Name = 'abcd', Partner_Name__c = acc.id);
  fundList.add(fd);
  database.insert(fundList);
  
	List<Account_Member__c> accMember = TestDataFactory.accountTeamCustom(1, acc);
	insert accMember;
  CoopFundHandlerPRM.afterInsertOperation(fundList);
	Test.StopTest();
  }
   
	
	
	static testMethod void accrualClaimAssociationTest5(){
	
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
	 List<Fund__c> fund = new list<Fund__c>();
		Fund__c Fundlist = new Fund__c(Partner_Name__c = acc.id, PRM_Main_Fund__c = true);
		fund.add(Fundlist);
	// insert fund;
	  Fund__c fund1 = [Select Id from Fund__c where Partner_Name__c = :acc.id and PRM_Main_Fund__c = true limit 1];
	  
	  List<Co_Op_Allocation__c> allocationList = new List<Co_Op_Allocation__c>();
	  Co_Op_Allocation__c allocation1 = new Co_Op_Allocation__c(Name = 'Gopi', Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 100,Transfers_in_Amount__c = 100,Transfers_out_Amount__c = 50, Status__c = 'Active');
	  allocationList.add(allocation1);
	  Co_Op_Allocation__c allocation2 = new Co_Op_Allocation__c(Name = 'Gopi-1', Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 200, Status__c = 'Active');
	  allocationList.add(allocation2);
	  Co_Op_Allocation__c allocation3 = new Co_Op_Allocation__c(Name = 'Gopi-2', Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 100,Transfers_in_Amount__c = 100,Transfers_out_Amount__c = 50, Status__c = 'Expired');
	  allocationList.add(allocation3);
	  insert allocationList;
   
	  allocation1.Co_Op_Allocation_Amount__c = 200;
	  update allocation1;
	  allocation3.Co_Op_Allocation_Amount__c = 200;
	  update allocation3;
	 
  
	  list<Co_Op_Activity__c> activityList = new list<Co_Op_Activity__c>();
	  Co_Op_Activity__c activity1 = new Co_Op_Activity__c(Partner_Account__c = acc.id, Activity_Type__c = 'Advertising', Start_Date__c = system.today()+15, End_Date__c = system.today()+100, Fund_Id__c = fund1.id, Activity_Status__c = 'New' , Cost_of_Activity__c = 5.0, Reimbursement_Amount_Requested__c = 20.0);
	  activityList.add(activity1);
	  Co_Op_Activity__c activity2 = new Co_Op_Activity__c(Partner_Account__c = acc.id, Activity_Type__c = 'Telemarketing', Start_Date__c = system.today()+15, End_Date__c = system.today()+100, Fund_Id__c = fund1.id, Activity_Status__c = 'New', Cost_of_Activity__c = 5.0, Reimbursement_Amount_Requested__c = 20.0);
	  activityList.add(activity2);
	  Co_Op_Activity__c activity3 = new Co_Op_Activity__c(Partner_Account__c = acc.id, Activity_Type__c = 'Demonstration Equipment', Start_Date__c = system.today(), End_Date__c = system.today()+100, Fund_Id__c = fund1.id, Activity_Status__c = 'New', Cost_of_Activity__c = 5.0, Reimbursement_Amount_Requested__c = 20.0);
	  activityList.add(activity3);
	  
	  
	  insert activityList;
	  
	  list<Claim__c> claimList = new list<Claim__c>();
	  Claim__c claim1 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, HFLOF_Amount__c = 10, Claim_Status__c = 'Submitted', Claim_Amount_Passed_Audit__c = 100);
	  claimList.add(claim1);
	  Claim__c claim2 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, HFLOF_Amount__c = 150, Claim_Status__c = 'Submitted', Claim_Amount_Passed_Audit__c = 300, Is_this_Last_Claim__c = PRMGlobalConstants.YES);
	  claimList.add(claim2);
   Claim__c claim3 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, HFLOF_Amount__c = 150, Claim_Status__c = 'created', Claim_Amount_Passed_Audit__c = 300, Is_this_Last_Claim__c = PRMGlobalConstants.YES);
	  claimList.add(claim3);
  Claim__c claim4 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, Claim_Status__c = 'created', Claim_Amount_Passed_Audit__c = 300, Is_this_Last_Claim__c = PRMGlobalConstants.NO);
	  claimList.add(claim4);
	  insert claimList;
   
	  List<Accrual_junction__c> accrualjuncList = new List<Accrual_junction__c>();
	  Accrual_junction__c accrualjunc1 = new Accrual_junction__c(Accrual__c = allocation1.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 300);
	  accrualjuncList.add(accrualjunc1);
	  Accrual_junction__c accrualjunc2 = new Accrual_junction__c(Accrual__c = allocation1.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 300);
	  accrualjuncList.add(accrualjunc2);
  // Accrual_junction__c accrualjunc3 = new Accrual_junction__c(Accrual__c = allocation1.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 20);
	//  accrualjuncList.add(accrualjunc3);
	  Accrual_junction__c accrualjunc3 = new Accrual_junction__c(Accrual__c = allocation3.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 300);
	  accrualjuncList.add(accrualjunc3);
	  Accrual_junction__c accrualjunc4 = new Accrual_junction__c(Accrual__c = allocation3.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 300);
	  accrualjuncList.add(accrualjunc4);
	  insert accrualjuncList;
	  
	  List<Co_Op_Activity__c> activityList2 = new List<Co_Op_Activity__c>();
	  activity1.Activity_Status__c = 'Approved';
	  activityList2.add(activity1);
	  activity2.Activity_Status__c = 'Approved';
	  activityList2.add(activity2);
	  activity3.Activity_Status__c = 'Approved';
	  activityList2.add(activity3);
	  update activityList2;
	  
	  List<Claim__c> claimList2 = new List<Claim__c>();
	  claim1.Claim_Status__c = PRMGlobalConstants.CoopPassedAudit;
	  claim1.Activity_Claim_Amount__c =100;
	  //claim1.Amount_Pending_for_Reimbursement__c = 10;
	  claimList2.add(claim1);
	  claim2.Claim_Status__c = PRMGlobalConstants.CoopPassedAudit;
  //claim2.Amount_Pending_for_Reimbursement__c = 10;
	  claimList2.add(claim2);
	  claim3.Claim_Status__c = PRMGlobalConstants.Claimable;
	  claimList2.add(claim3);
	  update claimList2;
	  
	  claim3.Claim_Status__c = PRMGlobalConstants.CoopSubmitted;
	  update claim3;
   
   
	  List<CoOp_Claim_Payment__c> PaymentList = new List<CoOp_Claim_Payment__c>();
	  CoOp_Claim_Payment__c payment1 = new CoOp_Claim_Payment__c(Claim__c = claim1.id );
	  PaymentList.add(payment1);
	  CoOp_Claim_Payment__c payment2 = new CoOp_Claim_Payment__c(Claim__c = claim2.id );
	  PaymentList.add(payment2);
	  
	  insert PaymentList;
	  payment1.Reimbursement_Reference_Number__c = '123456';
	  payment2.Reimbursement_Reference_Number__c = '789456';
	  payment1.Amount_Pending_for_Reimbursement__c = 100;
	  payment2.Amount_Pending_for_Reimbursement__c = 300;
	  update PaymentList;
	  
	  claim1.Claim_Status__c = PRMGlobalConstants.CoopReimbursed;
	  claim1.HFLOF_Amount__c = 0;
	  claim2.Claim_Status__c = PRMGlobalConstants.CoopReimbursed;
	  claim2.HFLOF_Amount__c = 0;
	  update claimList2;
	  
	  List<Accrual_junction__c> accrualClaimJunction = new List<Accrual_junction__c>();
	  Accrual_junction__c junction1 = new Accrual_junction__c(Payment__c = payment1.Id, Accrual__c = allocation2.id, Partner_Fund_Claim__c = claim2.id);
	  accrualClaimJunction.add(junction1);
	  Accrual_junction__c junction2 = new Accrual_junction__c(Payment__c = payment2.Id, Accrual__c = allocation2.id, Partner_Fund_Claim__c = claim2.id);
	  accrualClaimJunction.add(junction2);
   
	  insert accrualClaimJunction;
	  CoOpClaimTriggerHelper.accrualClaimAssociation(claimList);
	  Test.stopTest(); 
	}
  }
		static testMethod void accrualClaimAssociationTest6(){
	String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
	Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
	
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
	 List<Fund__c> fund = new list<Fund__c>();
		Fund__c Fundlist = new Fund__c(Partner_Name__c = acc.id, PRM_Main_Fund__c = true);
		fund.add(Fundlist);
	// insert fund;
	  Fund__c fund1 = [Select Id from Fund__c where Partner_Name__c = :acc.id and PRM_Main_Fund__c = true limit 1];
	  
	  List<Co_Op_Allocation__c> allocationList = new List<Co_Op_Allocation__c>();
	  Co_Op_Allocation__c allocation1 = new Co_Op_Allocation__c(Name = 'Gopi', Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 100,Transfers_in_Amount__c = 100,Transfers_out_Amount__c = 50, Status__c = 'Active');
	  allocationList.add(allocation1);
	  Co_Op_Allocation__c allocation2 = new Co_Op_Allocation__c(Name = 'Gopi-1', Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 200, Status__c = 'Active');
	  allocationList.add(allocation2);
	  Co_Op_Allocation__c allocation3 = new Co_Op_Allocation__c(Name = 'Gopi-2', Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 100,Transfers_in_Amount__c = 100,Transfers_out_Amount__c = 50, Status__c = 'Expired');
	  allocationList.add(allocation3);
	  insert allocationList;
   
	  allocation1.Co_Op_Allocation_Amount__c = 200;
	  update allocation1;
	  allocation3.Co_Op_Allocation_Amount__c = 200;
	  update allocation3;
	 
  
	  list<Co_Op_Activity__c> activityList = new list<Co_Op_Activity__c>();
	  Co_Op_Activity__c activity1 = new Co_Op_Activity__c(Partner_Account__c = acc.id, Activity_Type__c = 'Advertising', Start_Date__c = system.today()+15, End_Date__c = system.today()+100, Fund_Id__c = fund1.id, Activity_Status__c = 'New' , Cost_of_Activity__c = 5.0, Reimbursement_Amount_Requested__c = 20.0);
	  activityList.add(activity1);
	  Co_Op_Activity__c activity2 = new Co_Op_Activity__c(Partner_Account__c = acc.id, Activity_Type__c = 'Telemarketing', Start_Date__c = system.today()+15, End_Date__c = system.today()+100, Fund_Id__c = fund1.id, Activity_Status__c = 'New', Cost_of_Activity__c = 5.0, Reimbursement_Amount_Requested__c = 20.0);
	  activityList.add(activity2);
	  Co_Op_Activity__c activity3 = new Co_Op_Activity__c(Partner_Account__c = acc.id, Activity_Type__c = 'Demonstration Equipment', Start_Date__c = system.today(), End_Date__c = system.today()+100, Fund_Id__c = fund1.id, Activity_Status__c = 'New', Cost_of_Activity__c = 5.0, Reimbursement_Amount_Requested__c = 20.0);
	  activityList.add(activity3);
	  
	  
	  insert activityList;
	  
	  list<Claim__c> claimList = new list<Claim__c>();
	  Claim__c claim1 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, HFLOF_Amount__c = 10, Claim_Status__c = 'Submitted', Claim_Amount_Passed_Audit__c = 100);
	  claimList.add(claim1);
	  Claim__c claim2 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, HFLOF_Amount__c = 150, Claim_Status__c = 'Submitted', Claim_Amount_Passed_Audit__c = 300, Is_this_Last_Claim__c = PRMGlobalConstants.YES);
	  claimList.add(claim2);
   Claim__c claim3 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, HFLOF_Amount__c = 150, Claim_Status__c = 'created', Claim_Amount_Passed_Audit__c = 300, Is_this_Last_Claim__c = PRMGlobalConstants.YES);
	  claimList.add(claim3);
  Claim__c claim4 = new Claim__c(Partner_Account__c = acc.id, Fund__c= fund1.id, Activity_Number__c = activity1.id, Claim_Status__c = 'created', Claim_Amount_Passed_Audit__c = 300, Is_this_Last_Claim__c = PRMGlobalConstants.NO);
	  claimList.add(claim4);
	  insert claimList;
   
	  List<Accrual_junction__c> accrualjuncList = new List<Accrual_junction__c>();
	  Accrual_junction__c accrualjunc1 = new Accrual_junction__c(Accrual__c = allocation1.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 100);
	  accrualjuncList.add(accrualjunc1);
	  Accrual_junction__c accrualjunc2 = new Accrual_junction__c(Accrual__c = allocation1.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 100);
	  accrualjuncList.add(accrualjunc2);
  // Accrual_junction__c accrualjunc3 = new Accrual_junction__c(Accrual__c = allocation1.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 20);
	//  accrualjuncList.add(accrualjunc3);
	  Accrual_junction__c accrualjunc3 = new Accrual_junction__c(Accrual__c = allocation3.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 100);
	  accrualjuncList.add(accrualjunc3);
	  Accrual_junction__c accrualjunc4 = new Accrual_junction__c(Accrual__c = allocation3.id,Partner_Fund_Claim__c = claim1.id,Amount_deducted_from_accrual__c = 100);
	  accrualjuncList.add(accrualjunc4);
	  insert accrualjuncList;
	  
	  List<Co_Op_Activity__c> activityList2 = new List<Co_Op_Activity__c>();
	  activity1.Activity_Status__c = 'Approved';
	  activityList2.add(activity1);
	  activity2.Activity_Status__c = 'Approved';
	  activityList2.add(activity2);
	  activity3.Activity_Status__c = 'Approved';
	  activityList2.add(activity3);
	  update activityList2;
	  
	  List<Claim__c> claimList2 = new List<Claim__c>();
	  claim1.Claim_Status__c = PRMGlobalConstants.CoopPassedAudit;
	  claim1.Activity_Claim_Amount__c =100;
	  //claim1.Amount_Pending_for_Reimbursement__c = 10;
	  claimList2.add(claim1);
	  claim2.Claim_Status__c = PRMGlobalConstants.CoopPassedAudit;
  //claim2.Amount_Pending_for_Reimbursement__c = 10;
	  claimList2.add(claim2);
	  claim3.Claim_Status__c = PRMGlobalConstants.Claimable;
	  claimList2.add(claim3);
	  update claimList2;
	  
	  claim3.Claim_Status__c = PRMGlobalConstants.CoopSubmitted;
	  update claim3;
   
   
	  List<CoOp_Claim_Payment__c> PaymentList = new List<CoOp_Claim_Payment__c>();
	  CoOp_Claim_Payment__c payment1 = new CoOp_Claim_Payment__c(Claim__c = claim1.id );
	  PaymentList.add(payment1);
	  CoOp_Claim_Payment__c payment2 = new CoOp_Claim_Payment__c(Claim__c = claim2.id );
	  PaymentList.add(payment2);
	  
	  insert PaymentList;
	  payment1.Reimbursement_Reference_Number__c = '123456';
	  payment2.Reimbursement_Reference_Number__c = '789456';
	  payment1.Amount_Pending_for_Reimbursement__c = 100;
	  payment2.Amount_Pending_for_Reimbursement__c = 300;
	  update PaymentList;
	  
	  claim1.Claim_Status__c = PRMGlobalConstants.CoopReimbursed;
	  claim1.HFLOF_Amount__c = 0;
	  claim2.Claim_Status__c = PRMGlobalConstants.CoopReimbursed;
	  claim2.HFLOF_Amount__c = 0;
	  update claimList2;
	  
	  List<Accrual_junction__c> accrualClaimJunction = new List<Accrual_junction__c>();
	  Accrual_junction__c junction1 = new Accrual_junction__c(Payment__c = payment1.Id, Accrual__c = allocation2.id, Partner_Fund_Claim__c = claim2.id);
	  accrualClaimJunction.add(junction1);
	  Accrual_junction__c junction2 = new Accrual_junction__c(Payment__c = payment2.Id, Accrual__c = allocation2.id, Partner_Fund_Claim__c = claim2.id);
	  accrualClaimJunction.add(junction2);
   
	  insert accrualClaimJunction;
	  CoOpClaimTriggerHelper.accrualClaimAssociation(claimList);
	  Test.stopTest(); 
	}
  }
}