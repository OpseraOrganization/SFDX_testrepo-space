/**
* @description: Claim Trigger Helper to handle complex logic called from Handler on specific event
* @author:  Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION  AUTHOR	DATE   DETAIL   FEATURES/CSR/TTP
* 1.0   Sonali Kothavale	25/05/2018   PRM Release 3
* ============================================================================ 
*/
public without sharing class CoOpClaimTriggerHelper {
  
  /**********************************************************************************************************************
* author: HCL
* Date: Nov-2019
* Param: 
* Return: void
* Description: Method to Associate Accrual with claim, when Claim Submitted and claim amount hold in coop allocation
* High Level Process : 
**********************************************************************************************************************/   
  public static void accrualpipelineclaims(List<Claim__c> claimsList){
	  try{
	set<ID> closeActivityId = new set<ID>();
	list<Co_Op_Activity__c> closeActivities = new list<Co_Op_Activity__c>();
	list<Accrual_junction__c> newAccrualClaims = new list<Accrual_junction__c>();
	set<ID> fundId = new set<ID>();
	set<ID> hFLOFClaimIds = new Set<ID>(); 
	Map<id, Decimal> claimHFLOFAmount = new MAP<ID, Decimal>();
	Map<ID, List<Co_Op_Allocation__c>> accArruals = new Map<ID, List<Co_Op_Allocation__c>>();
	Map<ID, List<Co_Op_Allocation__c>> accArruals1 = new Map<ID, List<Co_Op_Allocation__c>>();
	list<CoOp_Claim_Payment__c> newPayments = new list<CoOp_Claim_Payment__c>();
	for(Claim__c claim : claimsList){
	  fundId.add(claim.Fund__c);
	  if(claim.Is_this_Last_Claim__c == PRMGlobalConstants.YES){
		closeActivityId.add(claim.Activity_Number__c);
	  }
	}
	system.debug('>> fundId : ' + fundId);
	//  system.debug('>> closeActivityId : ' + closeActivityId);
	
/*	for (Co_Op_Activity__c ClosedAct : [select id, name, Activity_Status__c from Co_Op_Activity__c 
		  where id in: closeActivityId 
		  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			
			ClosedAct.Activity_Status__c = PRMGlobalConstants.Closed;
			ClosedAct.Activity_Path_Status__c = PRMGlobalConstants.Closed;
			closeActivities.add(ClosedAct);
		  } */
	
	//   System.debug('>> ClosedAct : ' + closeActivities);
   // database.update(closeActivities);   
	
	
	for(Co_Op_Allocation__c accrual : [Select id, name, Allocation_Period_Balance__c, Partner_Name__c, Fund_Id__c, Status__c,Pipeline_Claims__c,Expiration_Amount__c 
		from Co_Op_Allocation__c 
		where Fund_Id__c in : fundId   
		AND Allocation_Period_Balance__c !=: PRMGlobalConstants.Zero
		AND Allocation_Period_Balance__c > 0 order by Expiration_Date__c 
		Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ]){
			 // system.debug('COOp allocation >>>>'+accrual);
			 List<Co_Op_Allocation__c> accrualRec = accArruals.get(accrual.Fund_Id__c);
			 if (accrualRec == null) {
		 accrualRec = new List<Co_Op_Allocation__c>();
		 accArruals.put(accrual.Fund_Id__c, accrualRec);
			 }
			 accrualRec.add(accrual);
		  
		}  
	
	
	
	list<Claim__c> updateclaim = new list<Claim__c>();
	list<Co_Op_Allocation__c> allAccAccruals = new list<Co_Op_Allocation__c>();
	  List<Co_Op_Allocation__c> accrualSub = new List<Co_Op_Allocation__c>();			 
	List<Fund__c> fundList = [Select id,Name, Current_Balance__c FROM Fund__c WHERE id in:fundId];
	for(Claim__c claim : claimsList){
	  Decimal activityClimeAmount = claim.Activity_Claim_Amount__c;
	  for(Fund__c fundclaim : fundList){
		Decimal claimfund = fundclaim.Current_Balance__c;
		if(activityClimeAmount < claimfund || activityClimeAmount == claimfund){
	
	
	if(!accArruals.Keyset().IsEmpty()){
			allAccAccruals = accArruals.get(claim.Fund__c);
	}

	If(!allAccAccruals.IsEmpty()){
			for(Co_Op_Allocation__c accrual : allAccAccruals ){
	 
	 Decimal Pipelineclaim = accrual.Pipeline_Claims__c;
	 
	 if(activityClimeAmount != PRMGlobalConstants.Zero && accrual.Fund_Id__c == claim.Fund__c) {
	Accrual_junction__c claimAccrual = new Accrual_junction__c();
	claimAccrual.Accrual__c = accrual.id;
	claimAccrual.Partner_Fund_Claim__c = claim.id;
	claimAccrual.Reimbursed_Type__c = PRMGlobalConstants.CoopNormal;
	claimAccrual.Status__c= PRMGlobalConstants.CoopSubmitted;
	claimAccrual.CurrencyIsoCode=claim.CurrencyIsoCode;
	newAccrualClaims.add(claimAccrual);

	
	if(activityClimeAmount < accrual.Allocation_Period_Balance__c || activityClimeAmount == accrual.Allocation_Period_Balance__c){
	  if(accrual.Pipeline_Claims__c == null){
		claimAccrual.Amount_deducted_from_accrual__c= activityClimeAmount;
		accrual.Pipeline_Claims__c =  activityClimeAmount;
		activityClimeAmount = activityClimeAmount - claimAccrual.Amount_deducted_from_accrual__c;
		
		accrualSub.add(accrual);
	 
	  }else{
		claimAccrual.Amount_deducted_from_accrual__c= activityClimeAmount;
		accrual.Pipeline_Claims__c = Pipelineclaim + activityClimeAmount;
		activityClimeAmount = activityClimeAmount - claimAccrual.Amount_deducted_from_accrual__c;
		
		accrualSub.add(accrual);
	
	  } 
	}
	else if(accrual.Pipeline_Claims__c == null){
	  claimAccrual.Amount_deducted_from_accrual__c = accrual.Allocation_Period_Balance__c;
	  accrual.Pipeline_Claims__c = claimAccrual.Amount_deducted_from_accrual__c;
	  activityClimeAmount = activityClimeAmount - accrual.Allocation_Period_Balance__c;
	  
	  accrualSub.add(accrual);
	  
	  
	  
	}
	else{
	  claimAccrual.Amount_deducted_from_accrual__c = accrual.Allocation_Period_Balance__c;
	  accrual.Pipeline_Claims__c =  Pipelineclaim + claimAccrual.Amount_deducted_from_accrual__c;
	  activityClimeAmount = activityClimeAmount - accrual.Allocation_Period_Balance__c;
	  
	  accrualSub.add(accrual);
		
	  
	}
	 }
	 
	 
	 
	 
			}
			
			
	}
	
		}else{
		  if(!accArruals.Keyset().IsEmpty()){
			allAccAccruals = accArruals.get(claim.Fund__c);
	}
	
	If(!allAccAccruals.IsEmpty()){
			for(Co_Op_Allocation__c accrual : allAccAccruals ){
	 
	 Decimal Pipelineclaim = accrual.Pipeline_Claims__c;
	 
	 if(activityClimeAmount != PRMGlobalConstants.Zero && accrual.Fund_Id__c == claim.Fund__c) {
	Accrual_junction__c claimAccrual = new Accrual_junction__c();
	// claimAccrual.Amount_deducted_from_accrual__c = activityClimeAmount;
	claimAccrual.Accrual__c = accrual.id;
	claimAccrual.Partner_Fund_Claim__c = claim.id;
	claimAccrual.Reimbursed_Type__c = PRMGlobalConstants.CoopNormal;
	claimAccrual.Status__c= PRMGlobalConstants.CoopSubmitted;
	claimAccrual.CurrencyIsoCode=claim.CurrencyIsoCode;
	newAccrualClaims.add(claimAccrual);
	
	 if(accrual.Pipeline_Claims__c == null){
	  claimAccrual.Amount_deducted_from_accrual__c = accrual.Allocation_Period_Balance__c;
	  //   system.debug('claim amount greaterthen submitted amount'+claimAccrual.Amount_deducted_from_accrual__c);
	  accrual.Pipeline_Claims__c = claimAccrual.Amount_deducted_from_accrual__c;
				   activityClimeAmount = activityClimeAmount - accrual.Allocation_Period_Balance__c;
	//  claim.Activity_Claim_Amount__c = activityClimeAmount - accrual.Allocation_Period_Balance__c;
			  
				 system.debug('activityClimeAmount'+activityClimeAmount);
	
	  accrualSub.add(accrual);
				 
	  
	  
	}
				 
	else{
					
	  claimAccrual.Amount_deducted_from_accrual__c = accrual.Allocation_Period_Balance__c;
	  //  system.debug('claim amount greaterthen submitted amount'+claimAccrual.Amount_deducted_from_accrual__c);
	  accrual.Pipeline_Claims__c =  Pipelineclaim + claimAccrual.Amount_deducted_from_accrual__c;
	  activityClimeAmount = activityClimeAmount - accrual.Allocation_Period_Balance__c;
				  

	  accrualSub.add(accrual);
				 // updateclaim.add(claim);
	 
	  
				  
				}
				 
	 }
	 
	 if(activityClimeAmount > PRMGlobalConstants.Zero ){
			//system.debug('>> Claim goes to HFLoF');
			claimHFLOFAmount.put(claim.id, activityClimeAmount);
			
			hFLOFClaimIds.add(claim.id);
			// hFLOFClaims.add(claim);
			
	}
	 
	 
			}
			
			
	}
		}
		  
		  
	  }
	  
	}
	  list<Claim__c> updateClaims = [select ID,Partner_Account__c,Fund__c,Activity_Name__c,Activity_Type__c,Claim_Submitted_By__c,Activity_Number__c, Claim_Amount_Passed_Audit__c, Claim_Due_By__c, Date_Passed_Audit__c,Activity_Number__r.End_Date__c, 
			 Claim_Status__c, Reimbursed_Amount_Claim_Paid_Amount__c, Amount_Pending_for_Reimbursement__c from Claim__c 
			 where id in: hFLOFClaimIds  
			 Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
	  
	  List<Claim__c> HFLOFclaim = new List<Claim__c>(); 
		  for(Claim__c claimToUpdate : updateClaims){
	
	claimToUpdate.Date_Passed_Audit__c = system.today(); 
	//system.debug('claimHFLOFAmount.get(claimToUpdate.id) === '+ claimHFLOFAmount.get(claimToUpdate.id));
	if((claimHFLOFAmount.get(claimToUpdate.id))!=Null){
			Claim__c claimHF = new Claim__c();
			claimHF.Activity_Type__c = claimToUpdate.Activity_Type__c;
			claimHF.Fund__c = claimToUpdate.Fund__c;
			claimHF.Activity_Number__c = claimToUpdate.Activity_Number__c;
			claimHF.Partner_Account__c = claimToUpdate.Partner_Account__c; 
			claimHF.HFLOF_Amount__c = claimHFLOFAmount.get(claimToUpdate.id);
			claimHF.Claim_Submitted_By__c = claimToUpdate.Claim_Submitted_By__c;
			claimHF.Claim_Status__c = PRMGlobalConstants.CoopHFLOF;
			claimHF.Activity_Claim_Amount__c = claimHFLOFAmount.get(claimToUpdate.id);
			claimHF.Claim_Due_By__c = claimToUpdate.Date_Passed_Audit__c + PRMGlobalConstants.CoopHFLOFExpiryDuration;
			
			claimToUpdate.HFLOF_Amount__c = claimHFLOFAmount.get(claimToUpdate.id);
	 //  claimToUpdate.Claim_Status__c = PRMGlobalConstants.CoopHFLOF;
	   //  claimToUpdate.Claim_Status__c = PRMGlobalConstants.CoopAwaitingReimbursement;
			//claimToUpdate.Claim_Due_By__c = claimToUpdate.Date_Passed_Audit__c + PRMGlobalConstants.CoopHFLOFExpiryDuration;
	HFLOFclaim.add(claimHF);
		  }
	else{
			claimToUpdate.Claim_Status__c = PRMGlobalConstants.CoopAwaitingReimbursement;
	}
	
	
	
		}
		//system.debug('updateClaims : ' + updateClaims);
		  IF(!HFLOFclaim.IsEmpty()){
			database.insert(HFLOFclaim);
		  }
		IF(!updateClaims.IsEmpty()){
	database.update(updateClaims);
		}
		Map<id,Co_Op_Allocation__c>coopall = new Map<id,Co_Op_Allocation__c>();
	  coopall.putall(accrualSub);
	 // database.update(updateclaim);
	  if(coopall.size()>0){
		  update coopall.values();
	  }
		
	  If(!newAccrualClaims.IsEmpty()){
			database.insert(newAccrualClaims); 
	}
		  
	  }catch(exception e){
		  system.assertEquals(e.getMessage(), e.getMessage());
	  }
  }
  
  /**********************************************************************************************************************
* author: Accenture & HCL
* Date: May-2018
* Param: List<CoOp_Claim_Payment__c> ReimbursedPaymentList
* Return: void
* Description: Method to calculate the claim amount when claim is Passed Audit and process HFLOF claims
* High Level Process : 
**********************************************************************************************************************/   
  public static void accrualClaimAssociation(List<Claim__c> claimsList){
	try{
	  set<ID> fundId = new set<ID>();
	  Map<ID, List<Co_Op_Allocation__c>> accArruals = new Map<ID, List<Co_Op_Allocation__c>>();
	  Map<id, Decimal> claimHFLOFAmount = new MAP<ID, Decimal>();
	  set<ID> hFLOFClaimIds = new Set<ID>(); 
	  list<Co_Op_Activity__c> closeActivities = new list<Co_Op_Activity__c>(); 
	  set<ID> closeActivityId = new set<ID>();   
	  list<Accrual_junction__c> newAccrualClaims = new list<Accrual_junction__c>();
	  Set<id> claimPendingReimbursement = new set<ID>();
	  list<CoOp_Claim_Payment__c> newPayments = new list<CoOp_Claim_Payment__c>();
	  Map<Id, Id> claimPayment = new Map<Id, Id>();
	  set<id> newclaims = new set<id>();
	  set<id> claimjunctionid = new set<id>();
	  set<id> coopjunction = new set<id>();
	  list<Claim__c> claimjun1 = new list<Claim__c>();
	  list<Claim__c> claimupdate1 = new list<Claim__c>();
	  list<Co_Op_Allocation__c> coopall = new list<Co_Op_Allocation__c>();
	  Map<id,Co_Op_Allocation__c> coopallocation = new Map<id,Co_Op_Allocation__c>();
	  list<Accrual_junction__c> acc = new list<Accrual_junction__c>();
	  Map<id,Accrual_junction__c> accjunction = new map<id,Accrual_junction__c>();
	  Map<id,List<Accrual_junction__c>> claimAccMap = new Map<id,List<Accrual_junction__c>>();
	  
	  
	  
	  Map<ID, Claim__c> Newclaim = new Map<ID, Claim__c>([select id, Name, Claim_Status__c, Claim_Amount_Passed_Audit__c,CurrencyIsoCode, Activity_Claim_Amount__c FROM Claim__c where id IN: Trigger.new]);
	  system.debug('claim id' + Newclaim);
	  for(Claim__c claim : [select id, Name FROM Claim__c where id IN: Trigger.new]){
		
		newclaims.add(claim.id);
	  } 
	  list<Accrual_junction__c> claimjunction = new list<Accrual_junction__c>([select Id, Accrual__r.id, Partner_Fund_Claim__r.id, Amount_deducted_from_accrual__c FROM Accrual_junction__c where Partner_Fund_Claim__r.id IN: newclaims ORDER BY Name ASC]);
	  //  accjunction.add(claimjunction);
	  accjunction.putall(claimjunction);
	  for(Accrual_junction__c junction: accjunction.values()){
		claimjunctionid.add(junction.Partner_Fund_Claim__r.id);  
		coopjunction.add(junction.Accrual__r.id);
  if(!claimAccMap.keySet().contains(junction.Partner_Fund_Claim__c)){
	List<Accrual_junction__c> tempList = new List<Accrual_junction__c>{junction};
	claimAccMap.put(junction.Partner_Fund_Claim__c, tempList);
  }else{
	claimAccMap.get(junction.Partner_Fund_Claim__c).add(junction);
  }
	  }
	  Map<ID, Co_Op_Allocation__c> coop = new Map<ID, Co_Op_Allocation__c>([select id, Name, Pipeline_Claims__c, Expiration_Amount__c, Status__c FROM Co_Op_Allocation__c where id IN: coopjunction]);
	  If(!claimjunction.IsEmpty()){
		
		
		for(Accrual_junction__c j4: accjunction.Values()){
	Claim__c claimjun = Newclaim.get(j4.Partner_Fund_Claim__c);
	Co_Op_Allocation__c coopjun = coop.get(j4.Accrual__c);
	system.debug('>> Claimid : ' + claimjun);
	system.debug('>> Coopid : ' + coopjun);
	claimjun1.add(claimjun);
	coopall.add(coopjun);
	coopallocation.putAll(coopall);
		}
		system.debug('coopall'+coopall);
		system.debug('claimjunction'+claimjunction);
		system.debug('Map of claimjunction id'+accjunction);
		system.debug('claim junction' +accjunction.Values());
		
		//Ruban Code Started
		list<Accrual_junction__c> accuralupdate = new list<Accrual_junction__c>();
		list<Accrual_junction__c> accuraldelete = new list<Accrual_junction__c>();
		list<Co_Op_Allocation__c> coopupdate = new list<Co_Op_Allocation__c>();
		list<Claim__c> claimstobeupdate = new list<Claim__c>();
		
		
		for(Claim__c claimupdate : claimsList){
	
	boolean done=false;
	decimal passedamount=claimupdate.Claim_Amount_Passed_Audit__c;
	
	decimal balanceamounttobededucted=passedamount;
	
	for(Accrual_junction__c accuraljunction: claimAccMap.get(claimupdate.Id)){
			decimal amountdeductionfrompipeline=accuraljunction.Amount_deducted_from_accrual__c;
			if(balanceamounttobededucted < amountdeductionfrompipeline && balanceamounttobededucted>0){
	 
	 accuraljunction.Amount_deducted_from_accrual__c=balanceamounttobededucted;
	 accuraljunction.Status__c='Pending Reimbursement';
			}
			
			if(balanceamounttobededucted > amountdeductionfrompipeline) {
	 accuraljunction.Status__c='Pending Reimbursement'; 
			}
			
			if(balanceamounttobededucted == amountdeductionfrompipeline) {
	 accuraljunction.Status__c='Pending Reimbursement'; 
			}
			if(balanceamounttobededucted <= 0){
	 done=true;
	 accuraljunction.Amount_deducted_from_accrual__c=0;
	 accuraldelete.add(accuraljunction);
			}
			accuralupdate.add(accuraljunction);
			
			Co_Op_Allocation__c coopallocationinstance = coop.get(accuraljunction.Accrual__c);
			if(balanceamounttobededucted < amountdeductionfrompipeline && balanceamounttobededucted>0){
	 coopallocationinstance.Pipeline_Claims__c=coopallocationinstance.Pipeline_Claims__c - amountdeductionfrompipeline;
	 if(coopallocationinstance.Status__c=='Expired'){
	decimal Expirationamount=amountdeductionfrompipeline-balanceamounttobededucted;
	if(coopallocationinstance.Expiration_Amount__c > 0){
	  coopallocationinstance.Expiration_Amount__c = coopallocationinstance.Expiration_Amount__c + Expirationamount;
	}
	else{
	  coopallocationinstance.Expiration_Amount__c=Expirationamount;
	}
	 }
	 balanceamounttobededucted=balanceamounttobededucted-amountdeductionfrompipeline;
	 //done=true;
			}
			
			if(balanceamounttobededucted==amountdeductionfrompipeline && balanceamounttobededucted>0)
			{
	 coopallocationinstance.Pipeline_Claims__c=coopallocationinstance.Pipeline_Claims__c - amountdeductionfrompipeline;  
	 balanceamounttobededucted=0;
	 //done=true;
			}
			
			if(balanceamounttobededucted > amountdeductionfrompipeline && balanceamounttobededucted>0)
			{
	 coopallocationinstance.Pipeline_Claims__c=coopallocationinstance.Pipeline_Claims__c - amountdeductionfrompipeline; 
	 balanceamounttobededucted=balanceamounttobededucted-amountdeductionfrompipeline;
			}
			
			if(done==true){
	 
	 coopallocationinstance.Pipeline_Claims__c=coopallocationinstance.Pipeline_Claims__c - amountdeductionfrompipeline;  
	 
	 if(coopallocationinstance.Status__c=='Expired'){
	if(coopallocationinstance.Expiration_Amount__c > 0){
	  coopallocationinstance.Expiration_Amount__c = coopallocationinstance.Expiration_Amount__c + amountdeductionfrompipeline;  
	}
	else
	{
	  coopallocationinstance.Expiration_Amount__c = amountdeductionfrompipeline;	
	}
	 }
			}
			coopupdate.add(coopallocationinstance);
			
	
	}
	//claimupdate.Claim_Status__c='Awaiting Reimbursement';
	//  claimstobeupdate.add(claimupdate);
	 CoOp_Claim_Payment__c newclaimPayment = new CoOp_Claim_Payment__c();
			newclaimPayment.Claim__c = claimupdate.id;
	 newclaimPayment.Amount_Pending_for_Reimbursement__c = passedamount;
	 // newclaimPayment.Amount_Pending_for_Reimbursement__c = accuraljunction.Amount_deducted_from_accrual__c;
			newclaimPayment.CurrencyIsoCode = claimupdate.CurrencyIsoCode;
			//system.debug('CurrencyIsoCode'+ claim.CurrencyIsoCode);
	 
	 newPayments.add(newclaimPayment);
			
	 
			
	
		}
		If(!newPayments.IsEmpty()){
			database.insert(newPayments);
	}
	 for(CoOp_Claim_Payment__c payment : newPayments){
	claimPayment.put(payment.Claim__c, payment.id);
		}
		//system.debug('claimPayment map: '+ claimPayment);
		for(Accrual_junction__c AccrualClaimToUpdate :accjunction.values()){
	AccrualClaimToUpdate.Payment__c = claimPayment.get(AccrualClaimToUpdate.Partner_Fund_Claim__c);
		}
		// Gopi Adding code END
		
		
		database.update(coopupdate);
		database.update(accuralupdate);
		database.delete(accuraldelete);
	  }  
	  
	  else {
		
		/* for(Claim__c claim : claimsList){
	fundId.add(claim.Fund__c);
	if(claim.Is_this_Last_Claim__c == PRMGlobalConstants.YES){
			closeActivityId.add(claim.Activity_Number__c);
	}
		}
		//system.debug('>> fundId : ' + fundId);
		//system.debug('>> closeActivityId : ' + closeActivityId);
		
		for (Co_Op_Activity__c ClosedAct : [select id, name, Activity_Status__c from Co_Op_Activity__c 
		where id in: closeActivityId 
		Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				
				ClosedAct.Activity_Status__c = PRMGlobalConstants.Closed;
				ClosedAct.Activity_Path_Status__c = PRMGlobalConstants.Closed;
				closeActivities.add(ClosedAct);
		}
		
		//System.debug('>> ClosedAct : ' + closeActivities);
		database.update(closeActivities);   
		
		
		for(Co_Op_Allocation__c accrual : [Select id, name, Allocation_Period_Balance__c, Partner_Name__c, Fund_Id__c, Status__c 
		 from Co_Op_Allocation__c 
		 where Fund_Id__c in : fundId   
		 AND Allocation_Period_Balance__c !=: PRMGlobalConstants.Zero 
		 AND Allocation_Period_Balance__c > 0 order by Expiration_Date__c 
		 Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
		
		List<Co_Op_Allocation__c> accrualRec = accArruals.get(accrual.Fund_Id__c);
		if (accrualRec == null) {
		  accrualRec = new List<Co_Op_Allocation__c>();
		  accArruals.put(accrual.Fund_Id__c, accrualRec);
		}
		accrualRec.add(accrual);
		 }
		
		//system.debug('accArruals : '  + accArruals ); 
		list<Co_Op_Allocation__c> allAccAccruals = new list<Co_Op_Allocation__c>();
		for(Claim__c claim : claimsList){
	Decimal claimAmount = claim.Claim_Amount_Passed_Audit__c;
	Decimal pendingReimbursement = PRMGlobalConstants.Zero;
	if(!accArruals.Keyset().IsEmpty()){
			allAccAccruals = accArruals.get(claim.Fund__c);
	}
	//system.debug('allAccAccruals asscoated with account: ' + allAccAccruals);
	If(!allAccAccruals.IsEmpty()){	  
			for(Co_Op_Allocation__c accrual : allAccAccruals ){
	 //system.debug('>> claimAmount : ' + claimAmount);
	 if(claimAmount != PRMGlobalConstants.Zero && accrual.Fund_Id__c == claim.Fund__c){
	//system.debug('>> claimAmount != 0 and and fund');
	Accrual_junction__c claimAccrual = new Accrual_junction__c();
	claimAccrual.Accrual__c = accrual.id;
	claimAccrual.Partner_Fund_Claim__c = claim.id;
	claimAccrual.Reimbursed_Type__c = PRMGlobalConstants.CoopNormal;
	claimAccrual.Status__c= PRMGlobalConstants.CoopPendingReimbursement;
	claimAccrual.CurrencyIsoCode=claim.CurrencyIsoCode;
	newAccrualClaims.add(claimAccrual);
	if(claimAmount < accrual.Allocation_Period_Balance__c || claimAmount == accrual.Allocation_Period_Balance__c){
	  //system.debug('>> Claim less than accrual');
	  //system.debug('>> Claim less than accrual- previous claimAmount'+ claimAmount);
	  claimAccrual.Amount_deducted_from_accrual__c= claimAmount;
	  pendingReimbursement = pendingReimbursement + claimAmount;
	  claimAmount = PRMGlobalConstants.Zero;
	  claimPendingReimbursement.add(claim.id);
	  //system.debug('>> Claim less than accrual- after claimAmount'+ claimAmount);
	}
	else{
	  //system.debug('>> Claim greater than accrual');
	  //system.debug('>> Claim greater than accrual - previous claimAmount'+ claimAmount);
	  claimAccrual.Amount_deducted_from_accrual__c= accrual.Allocation_Period_Balance__c;
	  claimAmount = claimAmount - accrual.Allocation_Period_Balance__c; 
	  pendingReimbursement = pendingReimbursement + accrual.Allocation_Period_Balance__c;
	  
	  //system.debug('>> Claim greater than accrual - after claimAmount'+ claimAmount);
	}
	 }
			}
			
			CoOp_Claim_Payment__c newclaimPayment = new CoOp_Claim_Payment__c();
			newclaimPayment.Claim__c = claim.id;
			newclaimPayment.Amount_Pending_for_Reimbursement__c = pendingReimbursement;
			newclaimPayment.CurrencyIsoCode = claim.CurrencyIsoCode;
			//system.debug('CurrencyIsoCode'+ claim.CurrencyIsoCode);
			newPayments.add(newclaimPayment);
	}
	
	
	if(claimAmount > PRMGlobalConstants.Zero ){
			//system.debug('>> Claim goes to HFLoF');
			claimHFLOFAmount.put(claim.id, claimAmount);
			//system.debug('hflof amount : ' + claim.id + ' = ' + claimHFLOFAmount.get(claim.id));
			hFLOFClaimIds.add(claim.id);
			// hFLOFClaims.add(claim);
			
	}
	
		}
		//system.debug('claimHFLOFAmount : '+ claimHFLOFAmount);
		//system.debug('newAccrualClaims : '+ newAccrualClaims);
		//system.debug('newPayments: '+ newPayments);
		
		If(!newAccrualClaims.IsEmpty()){
	database.insert(newAccrualClaims);
		}
		
		If(!newPayments.IsEmpty()){
	database.insert(newPayments);
		}
		
		for(CoOp_Claim_Payment__c payment : newPayments){
	claimPayment.put(payment.Claim__c, payment.id);
		}
		//system.debug('claimPayment map: '+ claimPayment);
		for(Accrual_junction__c AccrualClaimToUpdate :newAccrualClaims){
	AccrualClaimToUpdate.Payment__c = claimPayment.get(AccrualClaimToUpdate.Partner_Fund_Claim__c);
		}
		//system.debug('newAccrualClaims : '+ newAccrualClaims);
		If(!newAccrualClaims.IsEmpty()){
	database.update(newAccrualClaims);
		}
		
		list<Claim__c> updateClaims = [select ID,Partner_Account__c,Activity_Name__c,Activity_Type__c,Claim_Submitted_By__c,Activity_Number__c, Claim_Amount_Passed_Audit__c, Claim_Due_By__c, Date_Passed_Audit__c,Activity_Number__r.End_Date__c, 
			 Claim_Status__c, Reimbursed_Amount_Claim_Paid_Amount__c, Amount_Pending_for_Reimbursement__c from Claim__c 
			 where id in: hFLOFClaimIds OR id in: claimPendingReimbursement 
			 Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		List<Claim__c> HFLOFclaim = new List<Claim__c>(); 
		  for(Claim__c claimToUpdate : updateClaims){
	
	claimToUpdate.Date_Passed_Audit__c = system.today(); 
	//system.debug('claimHFLOFAmount.get(claimToUpdate.id) === '+ claimHFLOFAmount.get(claimToUpdate.id));
	if((claimHFLOFAmount.get(claimToUpdate.id))!=Null){
			Claim__c claimHF = new Claim__c();
			claimHF.Activity_Type__c = claimToUpdate.Activity_Type__c;
			claimHF.Activity_Number__c = claimToUpdate.Activity_Number__c;
			claimHF.Partner_Account__c = claimToUpdate.Partner_Account__c; 
			claimHF.HFLOF_Amount__c = claimHFLOFAmount.get(claimToUpdate.id);
			claimHF.Claim_Submitted_By__c = claimToUpdate.Claim_Submitted_By__c;
			claimHF.Claim_Status__c = PRMGlobalConstants.CoopHFLOF;
			claimHF.Activity_Claim_Amount__c = claimHFLOFAmount.get(claimToUpdate.id);
			claimHF.Claim_Due_By__c = claimToUpdate.Date_Passed_Audit__c + PRMGlobalConstants.CoopHFLOFExpiryDuration;
			
			  
			//claimToUpdate.HFLOF_Amount__c = claimHFLOFAmount.get(claimToUpdate.id);
	  // claimToUpdate.Claim_Status__c = PRMGlobalConstants.CoopHFLOF;
	   //  claimToUpdate.Claim_Status__c = PRMGlobalConstants.CoopAwaitingReimbursement;
		//	claimToUpdate.Claim_Due_By__c = claimToUpdate.Date_Passed_Audit__c + PRMGlobalConstants.CoopHFLOFExpiryDuration;
	HFLOFclaim.add(claimHF);
		  }
	else{
			claimToUpdate.Claim_Status__c = PRMGlobalConstants.CoopAwaitingReimbursement;
	}
	
	
	
		}
		//system.debug('updateClaims : ' + updateClaims);
		  IF(!HFLOFclaim.IsEmpty()){
		   //  database.insert(HFLOFclaim);
		  }
		IF(!updateClaims.IsEmpty()){
	database.update(updateClaims);
		}
		
		
	 */
	  } 
	  
	}catch(Exception e){
	  ExceptionHandler.addException(e,PRMGlobalConstants.CoOpClaimTriggerHelper, PRMGlobalConstants.CoOpClaimTriggerHelper);
	}
	
  }
}