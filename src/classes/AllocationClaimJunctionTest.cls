@isTest
public class AllocationClaimJunctionTest {
	static testMethod void AllocationClaimJunctionTest1(){
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
			List<Fund__c> fundList = new List<Fund__c>();
			Fund__c fund1 = [Select Id from Fund__c where Partner_Name__c = :acc.id and PRM_Main_Fund__c = true limit 1];
			fund1.PRM_Co_Op_Eligible__c = 2;
			update fund1;
			
			List<Co_Op_Allocation__c> allocationList = new List<Co_Op_Allocation__c>();
			Co_Op_Allocation__c allocation1 = new Co_Op_Allocation__c(Name = 'Gopi', Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 100,Transfers_in_Amount__c = 100,Transfers_out_Amount__c = 50, Status__c = 'Active',
																	 	A_A_VITAL_Revenue__c = 10000, FN_Revenue__c = 5000, ION_Revenue__c = 0, ION_NUAGE_Revenue__c = 1000,
							ION_Optics_Revenue__c = 3000, ION_Routing_Revenue__c = 1000, MN_Revenue__c = 0);
			allocationList.add(allocation1);
			Co_Op_Allocation__c allocation2 = new Co_Op_Allocation__c(Name = 'Gopi-1', Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 200, Status__c = 'Active',
																	 A_A_VITAL_Revenue__c = 10000, FN_Revenue__c = 5000, ION_Revenue__c = 0, ION_NUAGE_Revenue__c = 1000,
							ION_Optics_Revenue__c = 3000, ION_Routing_Revenue__c = 1000, MN_Revenue__c = 0);
			allocationList.add(allocation2);
			Co_Op_Allocation__c allocation3 = new Co_Op_Allocation__c(Name = 'Gopi-2', Fund_Id__c = fund1.id,Co_Op_Allocation_Amount__c = 100,Transfers_in_Amount__c = 100,Transfers_out_Amount__c = 50, Status__c = 'Expired',
																	 A_A_VITAL_Revenue__c = 10000, FN_Revenue__c = 5000, ION_Revenue__c = 0, ION_NUAGE_Revenue__c = 1000,
							ION_Optics_Revenue__c = 3000, ION_Routing_Revenue__c = 1000, MN_Revenue__c = 0);
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
		//	accrualjuncList.add(accrualjunc3);
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
			Accrual_junction__c junction1 = new Accrual_junction__c(Payment__c = payment1.Id, Accrual__c = allocation2.id, Partner_Fund_Claim__c = claim2.id, Amount_deducted_from_accrual__c = 10);
			accrualClaimJunction.add(junction1);
			Accrual_junction__c junction2 = new Accrual_junction__c(Payment__c = payment2.Id, Accrual__c = allocation2.id, Partner_Fund_Claim__c = claim2.id, Amount_deducted_from_accrual__c = 10);
			accrualClaimJunction.add(junction2);
	 
			insert accrualClaimJunction;
			
			delete accrualClaimJunction;
			Test.stopTest(); 
		}
	}
}