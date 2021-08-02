/**
* @description: Claim Trigger Helper to handle complex logic called from Handler on specific event
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION	AUTHOR	  DATE	 DETAIL	 FEATURES/CSR/TTP
* 1.0	 Sonali Kothavale		25/05/2018	 PRM Release 3
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
   set<ID> closeActivityId = new set<ID>();
   list<Co_Op_Activity__c> closeActivities = new list<Co_Op_Activity__c>();
   list<Accrual_junction__c> newAccrualClaims = new list<Accrual_junction__c>();
   set<ID> fundId = new set<ID>();
   Map<ID, List<Co_Op_Allocation__c>> accArruals = new Map<ID, List<Co_Op_Allocation__c>>();
	Map<ID, List<Co_Op_Allocation__c>> accArruals1 = new Map<ID, List<Co_Op_Allocation__c>>();
   for(Claim__c claim : claimsList){
			fundId.add(claim.Fund__c);
			if(claim.Is_this_Last_Claim__c == PRMGlobalConstants.YES){
				closeActivityId.add(claim.Activity_Number__c);
			}
		}
		system.debug('>> fundId : ' + fundId);
	  //  system.debug('>> closeActivityId : ' + closeActivityId);
		
		for (Co_Op_Activity__c ClosedAct : [select id, name, Activity_Status__c from Co_Op_Activity__c 
											where id in: closeActivityId 
											Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			
			ClosedAct.Activity_Status__c = PRMGlobalConstants.Closed;
			ClosedAct.Activity_Path_Status__c = PRMGlobalConstants.Closed;
			closeActivities.add(ClosedAct);
		}
		
	 //   System.debug('>> ClosedAct : ' + closeActivities);
		database.update(closeActivities);   
		
		
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
			 //   system.debug('COOp allocation >>>>'+accrualRec);							   
		}  
	
   
	
	 list<Claim__c> updateclaim = new list<Claim__c>();
	 list<Co_Op_Allocation__c> allAccAccruals = new list<Co_Op_Allocation__c>();
	  for(Claim__c claim : claimsList){
		  Decimal activityClimeAmount = claim.Activity_Claim_Amount__c;
		  for(Fund__c fundclaim : [Select id,Name, Current_Balance__c FROM Fund__c WHERE id in:fundId]){
			Decimal claimfund = fundclaim.Current_Balance__c;
			  system.debug('fundclaim>>>>>>'+fundclaim);
			  system.debug('fundclaim>>>>>' +claimfund);
			  system.debug('claimamount>>>>>' +activityClimeAmount);
			  if(activityClimeAmount < claimfund || activityClimeAmount == claimfund){
				  
			  
			Decimal claimAmount = claim.Claim_Amount_Passed_Audit__c;
					 if(!accArruals.Keyset().IsEmpty()){
				allAccAccruals = accArruals.get(claim.Fund__c);
			}
		 
	 List<Co_Op_Allocation__c> accrualSub = new List<Co_Op_Allocation__c>();
	  If(!allAccAccruals.IsEmpty()){
	 for(Co_Op_Allocation__c accrual : allAccAccruals ){
		 system.debug('Allocation related Fund' +accrual.Fund_Id__c);
		 
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
		  //	system.debug('claim Amount >>>>'+claimAccrual.Amount_deducted_from_accrual__c);
		   //   system.debug('Activity Amount >>>>'+activityClimeAmount);
			 
			 if(activityClimeAmount < accrual.Allocation_Period_Balance__c || activityClimeAmount == accrual.Allocation_Period_Balance__c){
		if(accrual.Pipeline_Claims__c == null){
			claimAccrual.Amount_deducted_from_accrual__c= activityClimeAmount;
			accrual.Pipeline_Claims__c =  activityClimeAmount;
		//   activityClimeAmount = claimAccrual.Amount_deducted_from_accrual__c;
			 activityClimeAmount = activityClimeAmount - claimAccrual.Amount_deducted_from_accrual__c;
			system.debug('First logic >>>>');
			accrualSub.add(accrual);
			database.update(accrualSub); 
		}else{
			claimAccrual.Amount_deducted_from_accrual__c= activityClimeAmount;
			accrual.Pipeline_Claims__c = Pipelineclaim + activityClimeAmount;
			//activityClimeAmount = claimAccrual.Amount_deducted_from_accrual__c;
		   activityClimeAmount = activityClimeAmount - claimAccrual.Amount_deducted_from_accrual__c;
		  system.debug('Second logic >>>>');
			accrualSub.add(accrual);
			database.update(accrualSub);
		} 
			 }
			 else if(accrual.Pipeline_Claims__c == null){
			   claimAccrual.Amount_deducted_from_accrual__c = accrual.Allocation_Period_Balance__c;
			//	 system.debug('claim amount greaterthen submitted amount'+claimAccrual.Amount_deducted_from_accrual__c);
			   accrual.Pipeline_Claims__c = claimAccrual.Amount_deducted_from_accrual__c;
			activityClimeAmount = activityClimeAmount - accrual.Allocation_Period_Balance__c;
				 system.debug('Third Logic');
				 accrualSub.add(accrual);
			database.update(accrualSub); 
				
				 
			 }
			 else{
			   claimAccrual.Amount_deducted_from_accrual__c = accrual.Allocation_Period_Balance__c;
			   //  system.debug('claim amount greaterthen submitted amount'+claimAccrual.Amount_deducted_from_accrual__c);
			   accrual.Pipeline_Claims__c =  Pipelineclaim + claimAccrual.Amount_deducted_from_accrual__c;
			activityClimeAmount = activityClimeAmount - accrual.Allocation_Period_Balance__c;
				 system.debug('Fourth Logic');
				 accrualSub.add(accrual);
			database.update(accrualSub);  
				 
			 }
		 }
		
	
		 

}


}
	  
 
	  If(!newAccrualClaims.IsEmpty()){
			database.insert(newAccrualClaims);
		}
		  }
		  }
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
			Map<id,Accrual_junction__c> acc1 = new Map<id,Accrual_junction__c>();
			
			
			
		   Map<ID, Claim__c> Newclaim = new Map<ID, Claim__c>([select id, Name, Claim_Status__c, Claim_Amount_Passed_Audit__c,CurrencyIsoCode, Activity_Claim_Amount__c FROM Claim__c where id IN: Trigger.new]);
			system.debug('claim id' + Newclaim);
			for(Claim__c claim : [select id, Name FROM Claim__c where id IN: Trigger.new]){
				
				newclaims.add(claim.id);
			} 
			list<Accrual_junction__c> claimjunction = new list<Accrual_junction__c>([select Id, Accrual__r.id, Partner_Fund_Claim__r.id FROM Accrual_junction__c where Partner_Fund_Claim__r.id IN: newclaims]);
		  //  accjunction.add(claimjunction);
			accjunction.putall(claimjunction);
			for(Accrual_junction__c junction: accjunction.values()){
			  claimjunctionid.add(junction.Partner_Fund_Claim__r.id);  
				coopjunction.add(junction.Accrual__r.id);  
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
					id claimid=claimupdate.id;
					decimal passedamount=claimupdate.Claim_Amount_Passed_Audit__c;
				  
					decimal balanceamounttobededucted=passedamount;
					
					system.debug('firstdone'+done);
					system.debug('firstclaimid'+claimid);
					system.debug('firstpassedamount'+passedamount);
					system.debug('firstbalanceamounttobededucted'+balanceamounttobededucted);
					
					for(Accrual_junction__c accuraljunction: [select Id, Accrual__r.id,Amount_deducted_from_accrual__c, Partner_Fund_Claim__r.id FROM Accrual_junction__c where Partner_Fund_Claim__r.id =: claimid ORDER BY Name ASC]){
						id coopallocationid=accuraljunction.Accrual__c;
						system.debug('junction inside') ;
						decimal amountdeductionfrompipeline=accuraljunction.Amount_deducted_from_accrual__c;
						system.debug('firstscoopallocationid'+coopallocationid);
						system.debug('firstsamountdeductionfrompipeline' +amountdeductionfrompipeline);
						system.debug('firstsbalanceamounttobededucted' +balanceamounttobededucted);
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
						
						for(Co_Op_Allocation__c coopallocationinstance : [select id, Name, Pipeline_Claims__c, Expiration_Amount__c, Status__c FROM Co_Op_Allocation__c where id =: coopallocationid]){
							system.debug('allocation inside');
							system.debug('firsttbalanceamounttobededucted'+balanceamounttobededucted);
							system.debug('firsttamountdeductionfrompipeline'+amountdeductionfrompipeline);
						   
							system.debug('firsttdone'+done);
							if(balanceamounttobededucted < amountdeductionfrompipeline && balanceamounttobededucted>0){
								system.debug('firsttfirstif');
								system.debug('coopallocationinstance.Pipeline_Claims__c'+coopallocationinstance.Pipeline_Claims__c);
								system.debug('amountdeductionfrompipeline'+amountdeductionfrompipeline);
							coopallocationinstance.Pipeline_Claims__c=coopallocationinstance.Pipeline_Claims__c - amountdeductionfrompipeline;
								system.debug('coopallocationinstance.Pipeline_Claims__c'+coopallocationinstance.Pipeline_Claims__c);
							if(coopallocationinstance.Status__c=='Expired'){
								system.debug('inside expiration');
							decimal Expirationamount=amountdeductionfrompipeline-balanceamounttobededucted;
								system.debug('amountdeductionfrompipeline'+amountdeductionfrompipeline);
								system.debug('balanceamounttobededucted'+balanceamounttobededucted);
								if(coopallocationinstance.Expiration_Amount__c > 0){
							coopallocationinstance.Expiration_Amount__c = coopallocationinstance.Expiration_Amount__c + Expirationamount;
								}
								else{
								  coopallocationinstance.Expiration_Amount__c=Expirationamount;
								}
								system.debug('coopallocationinstance.Expiration_Amount__c'+coopallocationinstance.Expiration_Amount__c);
							}
							balanceamounttobededucted=balanceamounttobededucted-amountdeductionfrompipeline;
							//done=true;
							}
							
							if(balanceamounttobededucted==amountdeductionfrompipeline && balanceamounttobededucted>0)
							{
								system.debug('firsttsecondif');
							coopallocationinstance.Pipeline_Claims__c=coopallocationinstance.Pipeline_Claims__c - amountdeductionfrompipeline;  
							balanceamounttobededucted=0;
							//done=true;
							}
							
							if(balanceamounttobededucted > amountdeductionfrompipeline && balanceamounttobededucted>0)
							{
								system.debug('firsttthirdif');
							coopallocationinstance.Pipeline_Claims__c=coopallocationinstance.Pipeline_Claims__c - amountdeductionfrompipeline; 
							balanceamounttobededucted=balanceamounttobededucted-amountdeductionfrompipeline;
							}
							
							if(done==true){
								system.debug('firsttfourthif');
								system.debug('coopallocationinstance.Pipeline_Claims__c'+coopallocationinstance.Pipeline_Claims__c);
								system.debug('amountdeductionfrompipeline'+amountdeductionfrompipeline);
						   
								coopallocationinstance.Pipeline_Claims__c=coopallocationinstance.Pipeline_Claims__c - amountdeductionfrompipeline;  
							
								
									
								
								system.debug('coopallocationinstance.Pipeline_Claims__c'+coopallocationinstance.Pipeline_Claims__c);
								system.debug('coopallocationinstance.Expiration_Amount__c'+coopallocationinstance.Expiration_Amount__c);
								system.debug('amountdeductionfrompipeline'+amountdeductionfrompipeline);
							if(coopallocationinstance.Status__c=='Expired'){
								if(coopallocationinstance.Expiration_Amount__c > 0){
								coopallocationinstance.Expiration_Amount__c = coopallocationinstance.Expiration_Amount__c + amountdeductionfrompipeline;	
								}
								else
								{
								  coopallocationinstance.Expiration_Amount__c = amountdeductionfrompipeline;	  
								}
							}
								system.debug('coopallocationinstance.Expiration_Amount__c'+coopallocationinstance.Expiration_Amount__c);
							}
							coopupdate.add(coopallocationinstance);
	
						}
						
						// Gopi Adding code Begin
						
						CoOp_Claim_Payment__c newclaimPayment = new CoOp_Claim_Payment__c();
						newclaimPayment.Claim__c = claimupdate.id;
					 //   newclaimPayment.Amount_Pending_for_Reimbursement__c = balanceamounttobededucted;
					   newclaimPayment.Amount_Pending_for_Reimbursement__c = accuraljunction.Amount_deducted_from_accrual__c;
					   newclaimPayment.CurrencyIsoCode = claimupdate.CurrencyIsoCode;
					//system.debug('CurrencyIsoCode'+ claim.CurrencyIsoCode);
						if(accuraljunction.Amount_deducted_from_accrual__c !=0){
						newPayments.add(newclaimPayment);
						}
						
					  
						
						
						
					}
					//claimupdate.Claim_Status__c='Awaiting Reimbursement';
				  //  claimstobeupdate.add(claimupdate);
				If(!newPayments.IsEmpty()){
					database.insert(newPayments);
			  }
					
				}
				
				// Gopi Adding code END
				
			 
			   database.update(coopupdate);
				database.update(accuralupdate);
				database.delete(accuraldelete);
			  //  database.update(claimstobeupdate);
			   // system.debug('accuralupdate'+accuralupdate);
			  //  system.debug('coopupdate'+coopupdate);
			   // system.debug('claimstobeupdate'+claimstobeupdate);

				
				//Ruban Code ended
				
				
				
				
				
	  /*		  for(Claim__c claimupdate : claimjun1){
				  system.debug('>>>>  claim' +claimupdate);
			   for(Accrual_junction__c accuraljunction: accjunction.Values()){
				system.debug('checking'+accuraljunction);
				system.debug('claim junction' +accjunction.Values());
				
			Decimal claimAmount = claimupdate.Claim_Amount_Passed_Audit__c;
			Decimal pendingReimbursement = PRMGlobalConstants.Zero;
			Decimal activityClimeAmount = claimupdate.Activity_Claim_Amount__c;
			Decimal ExpirationAmount = claimupdate.Activity_Claim_Amount__c - claimupdate.Claim_Amount_Passed_Audit__c; 
				 List<Co_Op_Allocation__c> updatecoopall = new List<Co_Op_Allocation__c>();
				for(Co_Op_Allocation__c updatecoop : coopallocation.Values()){
				  //  for(Accrual_junction__c accuraljunction: accjunction.Values()){
						system.debug(' Gopi coop allocation id'+updatecoop.id);
						system.debug('Gopi allocation'+updatecoop.Name);
					
					
					
				if(accuraljunction.Accrual__r.id == updatecoop.id){
					
					system.debug('Coopallocation id' +accuraljunction.Accrual__r.id);
					system.debug('Coopallocation id' +updatecoop.id);
					system.debug('>>> Coopallocation' +updatecoop);
					system.debug('>>> All Coopallocation' +coopallocation.Values());
				   Decimal Pipelineclaim = updatecoop.Pipeline_Claims__c;  
					
				  if((activityClimeAmount == claimAmount || claimAmount < activityClimeAmount) && updatecoop.Status__c == 'Active' && claimupdate.Claim_Amount_Passed_Audit__c != PRMGlobalConstants.Zero && updatecoop.Status__c == 'Active' && (claimAmount < updatecoop.Pipeline_Claims__c || claimAmount == updatecoop.Pipeline_Claims__c)){
					  
					 system.debug('>>> Coopallocation' +updatecoop.id);
					  system.debug('>>> Coopallocation' +updatecoop.Name);
					  system.debug('>>> activityClimeAmount' +activityClimeAmount);
					  system.debug('>>> passedaudit amount' +claimAmount); 
					  
							 accuraljunction.Amount_deducted_from_accrual__c= claimAmount;
							 accuraljunction.Status__c= PRMGlobalConstants.CoopPendingReimbursement;
							 pendingReimbursement = pendingReimbursement + claimAmount;
							 updatecoop.Pipeline_Claims__c =  Pipelineclaim - activityClimeAmount;
							 claimupdate.Claim_Status__c = PRMGlobalConstants.CoopAwaitingReimbursement;
						 
						   acc.add(accuraljunction);
						   claimupdate1.add(claimupdate);
						   updatecoopall.add(updatecoop);
					  database.update(acc);
					  database.update(claimupdate1);
					  database.update(updatecoopall);
					   
					  /*system.debug('>>>  pendingReimbursement' + pendingReimbursement);
						system.debug('>>>  claim' + claimupdate1);	
						system.debug('>>>  junction' + acc);
						system.debug('>>>  coopallocation' + updatecoopall);  ==========================
						//claimAmount = PRMGlobalConstants.Zero;
						
					  
							claimPendingReimbursement.add(claimupdate.id);
							}
							else if((activityClimeAmount == claimAmount || claimAmount < activityClimeAmount) && updatecoop.Status__c == 'Expired' && claimupdate.Claim_Amount_Passed_Audit__c != PRMGlobalConstants.Zero && (claimAmount < updatecoop.Pipeline_Claims__c || claimAmount == updatecoop.Pipeline_Claims__c)){
							accuraljunction.Amount_deducted_from_accrual__c= claimAmount;
							accuraljunction.Status__c= PRMGlobalConstants.CoopPendingReimbursement;	
							 updatecoop.Expiration_Amount__c = updatecoop.Expiration_Amount__c + ExpirationAmount;
							  updatecoop.Pipeline_Claims__c =  Pipelineclaim - activityClimeAmount;
							 pendingReimbursement = pendingReimbursement + claimAmount;
							  claimupdate.Claim_Status__c = PRMGlobalConstants.CoopAwaitingReimbursement;
							 updatecoopall.add(updatecoop);
								acc.add(accuraljunction);
								 claimupdate1.add(claimupdate);
							   
							 claimAmount = PRMGlobalConstants.Zero;
							claimPendingReimbursement.add(claimupdate.id); 
							  
								
							}
					
					
				   // if(accuraljunction.Accrual__r.id == updatecoop.id){
					 //   system.debug('Coopallocation id' +accuraljunction.Accrual__r.id);
					 //   system.debug('Coopallocation id' +updatecoop.id);
						
						if((claimAmount < activityClimeAmount || claimAmount == activityClimeAmount) && updatecoop.Status__c == 'Active' && claimAmount > updatecoop.Pipeline_Claims__c && claimupdate.Claim_Amount_Passed_Audit__c != PRMGlobalConstants.Zero){
								 system.debug('>>>> Hello');
								 accuraljunction.Amount_deducted_from_accrual__c = Pipelineclaim;
							 accuraljunction.Status__c= PRMGlobalConstants.CoopPendingReimbursement;
							 pendingReimbursement = pendingReimbursement + Pipelineclaim;
							 updatecoop.Pipeline_Claims__c =  Pipelineclaim - accuraljunction.Amount_deducted_from_accrual__c;
							 claimupdate.Claim_Status__c = PRMGlobalConstants.CoopAwaitingReimbursement;
							 claimupdate1.add(claimupdate);
								
						 system.debug(' >>>>Pipeline Claim amount' + updatecoop.Pipeline_Claims__c);
						 system.debug('>>> activityClimeAmount' +activityClimeAmount);
						 system.debug('>>> passedaudit amount' +claimAmount); 
						 system.debug('>>> coop allocation Name' + updatecoop);
						 system.debug('>>> junction record' + accuraljunction.id);
						 system.debug('>>> accuraljunction.Amount_deducted_from_accrual__c' + accuraljunction.Amount_deducted_from_accrual__c);	  
						 
							 acc.add(accuraljunction); 
								
						 //  acc1.putall(acc);
						  // acc1.add(acc);
						   claimupdate1.add(claimupdate);
						   updatecoopall.add(updatecoop);
							system.debug('junction Record list' +accuraljunction); 
							system.debug('junction Record list' +acc);
							   // database.update(acc);
								database.update(updatecoopall);
								database.update(claimupdate);
								system.debug('coop allocation records' +updatecoopall);
								system.debug('coop allocation records' +claimupdate);
							
							 database.update(acc);
								 // database.update(acc1);
							   // system.debug('>>>>>Map of accrual junction' +acc1);
								system.debug('>>>>>Map of accrual junction' +acc);
							  //  if(acc1.size()>0){
							  //  update acc1.values();
						   //	 }
							} 
						
			  //	  }
					
					 else if((claimAmount < activityClimeAmount || claimAmount == activityClimeAmount) && updatecoop.Status__c == 'Active' && claimAmount > updatecoop.Pipeline_Claims__c && claimupdate.Claim_Amount_Passed_Audit__c != PRMGlobalConstants.Zero && updatecoop.Pipeline_Claims__c != 0 ){
								 system.debug('>>>> Hello');
								 accuraljunction.Amount_deducted_from_accrual__c = Pipelineclaim;
							 accuraljunction.Status__c= PRMGlobalConstants.CoopPendingReimbursement;
							 pendingReimbursement = pendingReimbursement + Pipelineclaim;
							 updatecoop.Pipeline_Claims__c =  Pipelineclaim - accuraljunction.Amount_deducted_from_accrual__c;
							 claimupdate.Claim_Status__c = PRMGlobalConstants.CoopAwaitingReimbursement;
							 claimupdate1.add(claimupdate);
								
						 system.debug(' >>>>Pipeline Claim amount' + updatecoop.Pipeline_Claims__c);
						 system.debug('>>> activityClimeAmount' +activityClimeAmount);
						 system.debug('>>> passedaudit amount' +claimAmount); 
						 system.debug('>>> coop allocation Name' + updatecoop);
						 system.debug('>>> junction record' + accuraljunction.id);
						 system.debug('>>> accuraljunction.Amount_deducted_from_accrual__c' + accuraljunction.Amount_deducted_from_accrual__c);	  
						 
							 acc.add(accuraljunction); 
								
						 //  acc1.putall(acc);
						  // acc1.add(acc);
						   claimupdate1.add(claimupdate);
						   updatecoopall.add(updatecoop);
							system.debug('junction Record list' +accuraljunction); 
							system.debug('junction Record list' +acc);
							   // database.update(acc);
								database.update(updatecoopall);
								database.update(claimupdate);
								system.debug('coop allocation records' +updatecoopall);
								system.debug('coop allocation records' +claimupdate);
							
							 database.update(acc);
								 // database.update(acc1);
							   // system.debug('>>>>>Map of accrual junction' +acc1);
								system.debug('>>>>>Map of accrual junction' +acc);
							  //  if(acc1.size()>0){
							  //  update acc1.values();
						   //	 }
							}  
					
				
				}  
				
				system.debug('>>>> Hello');
				database.update(updatecoopall);
			   
				CoOp_Claim_Payment__c newclaimPayment = new CoOp_Claim_Payment__c();
				newclaimPayment.Claim__c = claimupdate.id;
				newclaimPayment.Amount_Pending_for_Reimbursement__c = pendingReimbursement;
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
		
			  
			  //  newAccrualClaims.add(accuraljunction);
			}
				} 
				}
				system.debug('>>>> Hello');
							database.update(claimupdate1);
							database.update(acc);
			  //  update acc1.values();
				system.debug('>>>> Hello');
				system.debug('>>>  claim' + claimupdate1);	
						system.debug('>>>  junction' + acc);
		 //----------------------------------------		
		 /*	   for(Accrual_junction__c accuraljunction: accjunction.Values()){
					for(Claim__c claimupdate : claimjun1){
					//	 system.debug('Claim>>' +claimupdate);
				 Decimal activityClimeAmount = claimupdate.Activity_Claim_Amount__c;
				 List<Co_Op_Allocation__c> updatecoopall = new List<Co_Op_Allocation__c>();
					for(Co_Op_Allocation__c updatecoop : coopall){
				  //  system.debug('>>> Coopallocation' +updatecoop);
				   Decimal Pipelineclaim = updatecoop.Pipeline_Claims__c;
				 if(claimupdate.Claim_Status__c == 'Rejected' && updatecoop.Status__c == 'Active'){
					// system.debug('Claim>>' +claimupdate);
					//  system.debug('Coopallocation>>' +updatecoop);
					 accuraljunction.Status__c='Rejected';
					 updatecoop.Pipeline_Claims__c =  Pipelineclaim - activityClimeAmount;
								 updatecoopall.add(updatecoop);
								database.update(updatecoopall);
					 acc.add(accuraljunction);
				 }	 else if(claimupdate.Claim_Status__c == 'Expired' && updatecoop.Status__c == 'Active' ){
					 accuraljunction.Status__c='Expired';
					 updatecoop.Pipeline_Claims__c =  Pipelineclaim - activityClimeAmount;
								 updatecoopall.add(updatecoop);
								database.update(updatecoopall);
					 acc.add(accuraljunction);
					 
				 }else if(claimupdate.Claim_Status__c == 'Expired' && updatecoop.Status__c == 'Expired'){
					 accuraljunction.Status__c='Expired';
					 updatecoop.Pipeline_Claims__c =  Pipelineclaim - activityClimeAmount;
					 updatecoop.Expiration_Amount__c = updatecoop.Expiration_Amount__c + activityClimeAmount;
								 updatecoopall.add(updatecoop);
								database.update(updatecoopall);
					 acc.add(accuraljunction);
					 
				 }
	 

		  }
	   }
	}
			   
				
				//---------------------------
			  for(Accrual_junction__c AccrualClaimToUpdate :newAccrualClaims){
			AccrualClaimToUpdate.Payment__c = claimPayment.get(AccrualClaimToUpdate.Partner_Fund_Claim__c);
		}
			If(!newAccrualClaims.IsEmpty()){
			database.update(newAccrualClaims);
		}  */ 
		   }  
			
			else{
	
	for(Claim__c claim : claimsList){
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
		
		list<Claim__c> updateClaims = [select ID, Claim_Amount_Passed_Audit__c, Claim_Due_By__c, Date_Passed_Audit__c,Activity_Number__r.End_Date__c, 
			Claim_Status__c, Reimbursed_Amount_Claim_Paid_Amount__c, Amount_Pending_for_Reimbursement__c from Claim__c 
			where id in: hFLOFClaimIds OR id in: claimPendingReimbursement 
			Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			for(Claim__c claimToUpdate : updateClaims){
	
	claimToUpdate.Date_Passed_Audit__c = system.today(); 
	//system.debug('claimHFLOFAmount.get(claimToUpdate.id) === '+ claimHFLOFAmount.get(claimToUpdate.id));
	if(!(claimHFLOFAmount.get(claimToUpdate.id)==Null)){
		
		claimToUpdate.HFLOF_Amount__c = claimHFLOFAmount.get(claimToUpdate.id);
		claimToUpdate.Claim_Status__c = PRMGlobalConstants.CoopHFLOF;
		claimToUpdate.Claim_Due_By__c = claimToUpdate.Date_Passed_Audit__c + PRMGlobalConstants.CoopHFLOFExpiryDuration;
	}
	else{
		claimToUpdate.Claim_Status__c = PRMGlobalConstants.CoopAwaitingReimbursement;
	}
	
	
	
		}
		//system.debug('updateClaims : ' + updateClaims);
		
		IF(!updateClaims.IsEmpty()){
			database.update(updateClaims);
		}

	 
	
}
	 
		}catch(Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.CoOpClaimTriggerHelper, PRMGlobalConstants.CoOpClaimTriggerHelper);
		}
		
	}  
}