/**
* @description: Accrual Trigger Helper to handle complx logic called from Handler on specific event
* @author:  Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION  AUTHOR	DATE   DETAIL   FEATURES/CSR/TTP
* 1.0   Sonali Kothavale	25/05/2018   PRM Release 3
* ============================================================================ 
**/
public without sharing class CoOpAccrualHelper{
  /**********************************************************************************************************************
* author: Accenture
* Date: May-2018
* Param: List<Co_Op_Allocation__c> newAccruals
* Return: void
* Description: Method to process HFLOF Claims when Accrual balance r Transfer in amount is updated
* High Level Process : 
**********************************************************************************************************************/ 
  public static void processHFLOFClaims(List<Co_Op_Allocation__c> newAccruals){
	try{	  
	  set<ID> fundID = new set<ID>();
	  Map<ID, list<Claim__c>> fundClaims = new map<ID, list<Claim__c>>();
	  Map<ID, ID > fundAccrual = new map<ID, ID>();
	  Map<ID, list<Claim__c>> accrualClaims = new map<ID, list<Claim__c>>();
	  list<Accrual_junction__c> newAccrualClaims = new list<Accrual_junction__c>();
	  list<CoOp_Claim_Payment__c> newpayments = new list<CoOp_Claim_Payment__c>();
	  list<Claim__c> hflofClaimsToUpdate = new list<Claim__c>();
	  Map<Id, Id> claimPayment = new Map<Id, Id>();
	  for(Co_Op_Allocation__c Accrual : newAccruals){
  fundID.add(Accrual.Fund_Id__c);
  fundAccrual.put(Accrual.Fund_Id__c, Accrual.id);
	  }
	  
	  for(Claim__c  Claims : [Select id, name, Partner_Account__c, HFLOF_Amount__c, Fund__c,CurrencyIsoCode
	  from Claim__c 
	  where Fund__c in : fundID AND (HFLOF_Amount__c !=: PRMGlobalConstants.Zero AND HFLOF_Amount__c != Null) order by Claim_Due_By__c Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
  List<Claim__c> hflofClaim = accrualClaims.get(fundAccrual.get(Claims.Fund__c));
  if (hflofClaim == null) {
	hflofClaim = new List<Claim__c>();
	accrualClaims.put(fundAccrual.get(Claims.Fund__c), hflofClaim);
  }
  hflofClaim.add(Claims);
	  }
	  for(Co_Op_Allocation__c Accrual : newAccruals){
  Decimal availableBalance = Accrual.Allocation_Period_Balance__c;
  list<Claim__c> claimsHflof =accrualClaims.get(Accrual.id);
  If(!claimsHflof.IsEmpty()){for(Claim__c claimtoreimb : claimsHflof){if(availableBalance > 0 ){Decimal pendingReimbursement = 0;Accrual_junction__c claimAccrual = new Accrual_junction__c();CoOp_Claim_Payment__c claimPay = new CoOp_Claim_Payment__c();claimAccrual.Accrual__c = Accrual.id;claimAccrual.Partner_Fund_Claim__c = claimtoreimb.id;claimAccrual.Reimbursed_Type__c = PRMGlobalConstants.CoopHFLOF;claimAccrual.Status__c= PRMGlobalConstants.CoopPendingReimbursement;claimAccrual.CurrencyIsoCode=claimtoreimb.CurrencyIsoCode;newAccrualClaims.add(claimAccrual);if(claimtoreimb.HFLOF_Amount__c < availableBalance || claimtoreimb.HFLOF_Amount__c == availableBalance){claimAccrual.Amount_deducted_from_accrual__c= claimtoreimb.HFLOF_Amount__c;availableBalance = availableBalance - claimtoreimb.HFLOF_Amount__c;pendingReimbursement = pendingReimbursement + claimtoreimb.HFLOF_Amount__c;claimtoreimb.HFLOF_Amount__c = 0;claimtoreimb.Claim_Status__c = PRMGlobalConstants.CoopAwaitingReimbursement;hflofClaimsToUpdate.add(claimtoreimb);  
  }
	else{
	 claimAccrual.Amount_deducted_from_accrual__c= availableBalance;
	 pendingReimbursement = pendingReimbursement + availableBalance;
	 claimtoreimb.HFLOF_Amount__c = claimtoreimb.HFLOF_Amount__c - availableBalance;
	 claimtoreimb.Claim_Status__c = PRMGlobalConstants.CoopHFLOF;
	 availableBalance = 0;
	 hflofClaimsToUpdate.add(claimtoreimb);
	}
	claimPay.Claim__c = claimtoreimb.id;
	claimPay.Amount_Pending_for_Reimbursement__c = pendingReimbursement;
	claimPay.CurrencyIsoCode = claimtoreimb.CurrencyIsoCode;
	newpayments.add(claimPay);
	
  }
	}
	  }
	  }
	  If(!newpayments.IsEmpty()){
  database.insert(newpayments,false);
	  }
	  If(!newAccrualClaims.IsEmpty()){
  database.insert(newAccrualClaims,false);
	  }
	  
	  If(!hflofClaimsToUpdate.IsEmpty()){
  database.update(hflofClaimsToUpdate,false);
	  }
	  
	  for(CoOp_Claim_Payment__c payment : newPayments){
  claimPayment.put(payment.Claim__c, payment.id);
	  }
	  for(Accrual_junction__c AccrualClaimToUpdate :newAccrualClaims){
  AccrualClaimToUpdate.Payment__c = claimPayment.get(AccrualClaimToUpdate.Partner_Fund_Claim__c);
	  }
	  If(!newAccrualClaims.IsEmpty()){
  database.update(newAccrualClaims,false);
	  }
	  
	}catch(Exception e){
	  ExceptionHandler.addException(e,PRMGlobalConstants.CoopAccrualHelper, PRMGlobalConstants.CoopAccrualHelper);
	}  
  }  
  /**********************************************************************************************************************
* author: Accenture
* Date: june-2018
* Param: List<Co_Op_Allocation__c> allocationList
* Return: void
* Description: Method to send email to partner user for expiry
* High Level Process : 
**********************************************************************************************************************/ 
 public static void sendEmailForExpiredAllocation(List<Co_Op_Allocation__c> allocationList) {
//List<User> UserList = new List<USer>();
Map<id,List<String>>acctoUserMap = new Map<id,List<String>>();
//List<Co_Op_Allocation__c> allocationToUpdate = new List<Co_Op_Allocation__c>();
Set<Id> accountSet = new Set<Id>();
//Set<Id> UserSet = new Set<Id>();
try{ 
for(Co_Op_Allocation__c allocation : [Select Id,Expiration_Date__c,Allocation_Period_Balance__c,Partner_Name__c,Status__c,Market__c,Partner_Name__r.name from Co_Op_Allocation__c where Id In: allocationList  Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
accountSet.add(allocation.Partner_Name__c);
}
system.debug('>> accountSet' + accountSet);
for(User userInstance : [Select id, Email,IsPortalEnabled ,Co_op_User__c,accountid, contact.accountid from User where accountid IN : accountSet AND IsPortalEnabled  = true AND Co_op_User__c = true Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())] ){
system.debug('>> userInstance.contact.accountid' + userInstance.contact.accountid);
if(!acctoUserMap.containskey(userInstance.accountid) && userInstance.Co_op_User__c){
system.debug('>> userInstance.contact.accountid' + userInstance.contact.accountid);
acctoUserMap.put(userInstance.contact.accountid,new List<String>());

}
acctoUserMap.get(userInstance.contact.accountid).add(userInstance.Email);
}
system.debug('>> acctoUserMap' + acctoUserMap);
if(!acctoUserMap.IsEmpty()){
EmailNotification.sendMailforexpirenotification(allocationList,acctoUserMap);
}


}catch(System.Exception e){
ExceptionHandler.addException(e,PRMGlobalConstants.RebatePeriodHelper,PRMGlobalConstants.getCurrentUser);

}
} 
  /**********************************************************************************************************************
* author: Accenture
* Date: june-2018
* Param: List<Co_Op_Allocation__c> allocationList
* Return: void
* Description: Method to send email to partner user for reminder
* High Level Process : 
**********************************************************************************************************************/ 
 public static void sendEmailForAlloactionupdate(List<Co_Op_Allocation__c> allocationList) {
		Map<id,List<String>>acctoUserMap = new Map<id,List<String>>();
		Set<Id> accountSet = new Set<Id>();
		try{ 
			for(Co_Op_Allocation__c allocation : [Select Id,Expiration_Date__c,Allocation_Period_Balance__c,Partner_Name__c,Partner_Name__r.name,Status__c from Co_Op_Allocation__c where Id In: allocationList  Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
	accountSet.add(allocation.Partner_Name__c);
				system.debug('>>>>>>>>>>>allocation'+allocation);
			}
			for(User userInstance : [Select id,accountid,IsPortalEnabled, Email ,Co_op_User__c, contact.accountid from User where accountid IN : accountSet AND IsPortalEnabled  = true AND Co_op_User__c = true Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())] ){
				system.debug('userInstance'+userInstance);
				if(!acctoUserMap.containskey(userInstance.contact.accountid)){
	acctoUserMap.put(userInstance.contact.accountid,new List<String>()); 
				system.debug('userInstance'+userInstance);
			}
		acctoUserMap.get(userInstance.contact.accountid).add(userInstance.Email);
	}
			if(!acctoUserMap.IsEmpty()){
				system.debug('>>>>>>>Email test');
				EmailNotification.sendMailforUploadAllocation(allocationList,acctoUserMap);
			}
			
			
		}catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.RebatePeriodHelper,PRMGlobalConstants.getCurrentUser);
			
		}
	}
  
  //##############################################################***********************
  
  public static void createNewTask(List<Co_Op_Allocation__c> allocationList) {
	
	Set<Id> accountSet = new Set<Id>();
	Map<id,List<String>>acctoUserMap = new Map<id,List<String>>();
	for(Co_Op_Allocation__c allocation: allocationList)
	{
	  accountSet.add(allocation.Partner_Name__c);
	}
	
	try
	{ 
	  List<Co_Op_Allocation__c > la = new List<Co_Op_Allocation__c>([Select Id, Expiration_Date__c, days_to_expire__C, Allocation_Period_Balance__c, Partner_Name__c, Partner_Name__r.name, Status__c from Co_Op_Allocation__c where Id In: accountSet  Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]);
	  List<user> lu = new List<user>([Select id, Email ,contact.Co_op_Eligible__c, contact.accountid from User where contact.accountid IN : accountSet AND IsPortalEnabled  = true AND contact.Co_op_Eligible__c = true Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]);
	  
	  /*   for(Co_Op_Allocation__c allocation : allocationList)
{
accountSet.add(allocation.Partner_Name__c);
}
*/  
	  
	  
	  for(User userInstance : lu )
	  {
  if(!acctoUserMap.containskey(userInstance.contact.accountid))
  {
	acctoUserMap.put(userInstance.contact.accountid,new List<String>{userInstance.id}); 
  }
  
  else{
	
	List<string> usersId = acctoUserMap.get(userInstance.contact.accountid);
	usersId.add(userInstance.Id);
	acctoUserMap.put(userInstance.contact.accountid, usersId);
  }
	  }
	  
	  if(!acctoUserMap.IsEmpty())
	  {
  List<Task> inserttask = new List<Task>();  
  Set<Id> accountIdSet = new Set<Id>();
  for(Co_Op_Allocation__c coop : allocationList){
	accountIdSet.add(coop.Partner_Name__c);
  }
  List<User> userList = [Select id, Email ,contact.Co_op_Eligible__c, contact.accountid from User where contact.accountid in :accountIdSet AND IsPortalEnabled  = true AND contact.Co_op_Eligible__c = true];
  for(Co_Op_Allocation__c cop : allocationList)
  {
	id idvalue =cop.Partner_Name__c;
	id coopid=cop.id;
	string daystoexpire=cop.days_to_expire__c;
	string status=cop.status__c;
	decimal allocperiodbal=cop.Allocation_Period_Balance__c;
	
	for(User u : userList)
	{
	  if(cop.Partner_Name__c == u.Contact.AccountId){
  Task t = new Task();
  Date d = date.today();
  t.OwnerId = u.id;
  t.Status= PRMGlobalConstants.Open;
  t.Priority= PRMGlobalConstants.CoopNormal;
  t.WhatId=coopid;
  
  if(daystoexpire.equalsIgnoreCase(PRMGlobalConstants.Fifteen_DAY) && allocperiodbal != 0 && status.equalsIgnoreCase(PRMGlobalConstants.ActiveSt))
  {
	t.ActivityDate=d + 15 ;
	t.Subject = PRMGlobalConstants.FIFTEENDAYSUBJECT;
	t.Description = PRMGlobalConstants.FIFTEENDAYDISCRIPTION;
	inserttask.add(t);
  }
  
  else if(daystoexpire.equalsIgnoreCase(PRMGlobalConstants.THEERTYDAY) && allocperiodbal != 0 && status.equalsIgnoreCase(PRMGlobalConstants.ActiveSt))
  {
	t.ActivityDate=d + 30 ;
	t.Subject= PRMGlobalConstants.THEERTYDAYSUBJECT;
	t.Description= PRMGlobalConstants.THEERTYDAYDISCRIPTION;
	inserttask.add(t);
  }   
	  }
	}
  }
  Database.Insert(inserttask);   
	  }
	  
	  /* if(!acctoUserMap.IsEmpty())
	  {
  List<Task> inserttask = new List<Task>();
  
  
  for(User u : lu)
  { 
	Task t = new Task();
	Date d = date.today();
	t.OwnerId = u.id;
	t.Status= PRMGlobalConstants.Open;
	t.Priority= PRMGlobalConstants.CoopNormal;
	t.WhatId=la[0].Id;
	
	if(la[0].days_to_expire__c.equalsIgnoreCase(PRMGlobalConstants.Fifteen_DAY) && la[0].Allocation_Period_Balance__c != 0 && la[0].Status__c.equalsIgnoreCase(PRMGlobalConstants.ActiveSt))
	{
	  t.ActivityDate=d + 15 ;
	  t.Subject = PRMGlobalConstants.FIFTEENDAYSUBJECT;
	  t.Description = PRMGlobalConstants.FIFTEENDAYDISCRIPTION;
	  inserttask.add(t);
	}
	
	else if(la[0].days_to_expire__c.equalsIgnoreCase(PRMGlobalConstants.THEERTYDAY) && la[0].Allocation_Period_Balance__c != 0 && la[0].Status__c.equalsIgnoreCase(PRMGlobalConstants.ActiveSt))
	{
	  t.ActivityDate=d + 30 ;
	  t.Subject= PRMGlobalConstants.THEERTYDAYSUBJECT;
	  t.Description= PRMGlobalConstants.THEERTYDAYDISCRIPTION;
	  inserttask.add(t);
	}
	//inserttask.add(t);
  }
  //Upsert inserttask;
  Database.Insert(inserttask) ;
	  }*/
	}
	
	catch(System.Exception e)
	{
	  ExceptionHandler.addException(e,PRMGlobalConstants.RebatePeriodHelper,PRMGlobalConstants.getCurrentUser); 
	}
  } 
  //##############################################################********************
  
 /**********************************************************************************************************************
* author: Accenture
* Date: May-2018
* Param: List<Co_Op_Allocation__c> newAccruals
* Return: void
* Description: Method to process HFLOF Claims when Accrual balance r Transfer in amount is updated
* High Level Process : 
**********************************************************************************************************************/ 
  public static void activeAllcOnSubmittedClaim(List<Co_Op_Allocation__c> newAccruals){
	try{
	  set<ID> fundID = new set<ID>();
	  Map<ID, ID > fundAccrual = new map<ID, ID>();
	  Map<ID, list<Claim__c>> accrualClaims = new map<ID, list<Claim__c>>();
	  
	  for(Co_Op_Allocation__c Accrual : newAccruals){
  fundID.add(Accrual.Fund_Id__c);
  fundAccrual.put(Accrual.Fund_Id__c, Accrual.id);
	  }
	  system.debug('Status__c'+newAccruals[0].Status__c );
	  for(Claim__c  Claims : [Select id, name, Partner_Account__c,  Fund__c,Claim_Status__c,Activity_Claim_Amount__c
	  from Claim__c 
	  where Fund__c in : fundID AND Claim_Status__c =: PRMGlobalConstants.BPApprovalStatus Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
  List<Claim__c> submittedClaim = accrualClaims.get(fundAccrual.get(Claims.Fund__c));
  if (submittedClaim == null) {
	submittedClaim = new List<Claim__c>();
	accrualClaims.put(fundAccrual.get(Claims.Fund__c), submittedClaim);
  }
  submittedClaim.add(Claims);
	  }
	  
	  list<Co_Op_Allocation__c> updateallocation = [Select Id,Expiration_Date__c,Expiration_Amount__c,Co_Op_Allocation_Amount__c,Status__c,Reimbursed_Amount__c,Amount_Pending_for_Reimbursement__c,Transfers_in_Amount__c,Transfers_out_Amount__c,Allocation_Period_Balance__c,Partner_Name__c,Partner_Name__r.name,Days_to_expire__c from Co_Op_Allocation__c where Id In: newAccruals Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
	  
	  decimal submittedamount = 0;
	  for(Co_Op_Allocation__c allocationToUpdate : updateallocation){
  if(accrualClaims.containsKey(allocationToUpdate.id)){
	for(Claim__c claimToFetch: accrualClaims.get(allocationToUpdate.id)){
	  submittedamount =  claimToFetch.Activity_Claim_Amount__c +submittedamount  ;
	}
	system.debug('Status__c'+allocationToUpdate.Status__c );
	//allocationToUpdate.Status__c = PRMGlobalConstants.EXPIRED ;
	if(submittedamount > allocationToUpdate.Allocation_Period_Balance__c){
	  allocationToUpdate.Expiration_Amount__c = 0;
	}
	else{
	  system.debug('Status__c+elseife'+allocationToUpdate.Status__c );
	  allocationToUpdate.Expiration_Amount__c = allocationToUpdate.Co_Op_Allocation_Amount__c-allocationToUpdate.Reimbursed_Amount__c-allocationToUpdate.Amount_Pending_for_Reimbursement__c+allocationToUpdate.Transfers_in_Amount__c-allocationToUpdate.Transfers_out_Amount__c-submittedamount;
	}
  }
  else{
	system.debug('Status__c+else'+allocationToUpdate.Status__c );
	allocationToUpdate.Expiration_Amount__c = allocationToUpdate.Co_Op_Allocation_Amount__c-allocationToUpdate.Reimbursed_Amount__c-allocationToUpdate.Amount_Pending_for_Reimbursement__c+allocationToUpdate.Transfers_in_Amount__c-allocationToUpdate.Transfers_out_Amount__c;
  }
  allocationToUpdate.Status__c = PRMGlobalConstants.EXPIRED ;
	  }
	  
	  IF(!updateallocation.IsEmpty()){
  database.update(updateallocation,false);
	  }
	}
	catch(Exception e){
	  system.debug('Status__c+e'+e);
	  ExceptionHandler.addException(e,PRMGlobalConstants.CoopAccrualHelper, PRMGlobalConstants.CoopAccrualHelper);
	}   
  } 
  /**********************************************************************************************************************
* author: Accenture
* Date: May-2018
* Param: List<Co_Op_Allocation__c> newAccruals
* Return: void
* Description: Method to process HFLOF Claims when Accrual balance r Transfer in amount is updated
* High Level Process : 
**********************************************************************************************************************/  
  public static void beforeInsertCoopAllocationHelperMethod(List<Co_Op_Allocation__c> newAccruals){
	try{
	  system.debug(' before insert method');
	  Set<Id> fundIds = new Set<Id>();
	  Map<Id,Fund__c> mapOfIsoCode = new Map<Id,Fund__c>();
	  for(Co_Op_Allocation__c coop:newAccruals){
  fundIds.add(coop.Fund_Id__c);
	  }
	  
	  for(Fund__c fund:[Select Name,Id ,CurrencyIsoCode,Partner_Name__c, PRM_Co_Op_Eligible__c, Partner_Name__r.AccountNumber from Fund__c where Id In:fundIds Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
  mapOfIsoCode.put(fund.Id,fund);
	  }
	  List<Co_Op_Allocation__c> updateallocation = new List<Co_Op_Allocation__c>();
	  for(Co_Op_Allocation__c cp:newAccruals){
  cp.CurrencyIsoCode=mapOfIsoCode.get(cp.Fund_Id__c).CurrencyIsoCode;
  cp.Partner_Name__c=mapOfIsoCode.get(cp.Fund_Id__c).Partner_Name__c;
  if(cp.Allocation_Month__c==null && cp.Allocation_Year__c!=null){
	cp.Name=mapOfIsoCode.get(cp.Fund_Id__c).Name+PRMGlobalConstants.dash+cp.Allocation_Year__c;  
  }else if(cp.Allocation_Year__c==null && cp.Allocation_Month__c!=null){
	cp.Name=mapOfIsoCode.get(cp.Fund_Id__c).Name+PRMGlobalConstants.dash+cp.Allocation_Month__c;
  }else if(cp.Allocation_Year__c==null && cp.Allocation_Month__c==null){
	cp.Name=mapOfIsoCode.get(cp.Fund_Id__c).Name; 
  }else{
	cp.Name=mapOfIsoCode.get(cp.Fund_Id__c).Name+PRMGlobalConstants.dash+cp.Allocation_Month__c+PRMGlobalConstants.INlineSpace+cp.Allocation_Year__c;
  }
   
  if(cp.Name.length() > 80){
	cp.Name = cp.Allocation_Month__c+PRMGlobalConstants.INlineSpace+cp.Allocation_Year__c;
	
  } 
  //Miguel Silva: SFPRM-356 - setting Eligible Co-Op % before Insert 
  if(cp.Fund_Id__c != null){
	cp.PRM_Co_Op_Eligible__c = mapOfIsoCode.get(cp.Fund_Id__c).PRM_Co_Op_Eligible__c;
  }
	  }
	  //system.debug('updateallocation>>'+updateallocation);
	  //database.update(updateallocation);
	}
	catch(Exception e){
	  ExceptionHandler.addException(e,PRMGlobalConstants.CoopAccrualHelper, PRMGlobalConstants.CoopAccrualHelper);
	}   
	
  } 
  /**********************************************************************************************************************
* author: Accenture
* Date: May-2018
* Param: List<Co_Op_Allocation__c> newAccruals
* Return: void
* Description: Method to process HFLOF Claims when Accrual balance r Transfer in amount is updated
* High Level Process : 
**********************************************************************************************************************/ 
  public static void afterUpdateCoopAllocationHelperMethod(List<Co_Op_Allocation__c> CoOpAllocationNewList,Map<Id,Co_Op_Allocation__c> CoOpAllocationOldList){
	system.debug('after update helper');
	Set<Id> fundIds = new Set<Id>();
	Map<Id,Fund__c> mapOfIsoCode = new Map<Id,Fund__c>();
	for(Co_Op_Allocation__c coop:CoOpAllocationNewList){
	  fundIds.add(coop.Fund_Id__c);
	}
	system.debug('fundIds'+fundIds);
	for(Fund__c fund:[Select Name,Id ,CurrencyIsoCode,Partner_Name__c from Fund__c where Id In:fundIds Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
	  mapOfIsoCode.put(fund.Id,fund);
	}
	system.debug('mapOfIsoCode'+mapOfIsoCode);
	system.debug('CoOpAllocationNewList'+CoOpAllocationNewList);
	for(Co_Op_Allocation__c c:CoOpAllocationNewList){
	  if((c.Allocation_Month__c!=CoOpAllocationOldList.get(c.Id).Allocation_Month__c) || (c.Allocation_Year__c!=CoOpAllocationOldList.get(c.Id).Allocation_Year__c)){
  system.debug('in for loop');
  if(c.Allocation_Month__c==null && c.Allocation_Year__c!=null){
	c.Name=mapOfIsoCode.get(c.Fund_Id__c).Name+PRMGlobalConstants.dash+c.Allocation_Year__c;  
  }else if(c.Allocation_Year__c==null && c.Allocation_Month__c!=null){
	c.Name=mapOfIsoCode.get(c.Fund_Id__c).Name+PRMGlobalConstants.dash+c.Allocation_Month__c;
  }else if(c.Allocation_Year__c==null && c.Allocation_Month__c==null){
	c.Name=mapOfIsoCode.get(c.Fund_Id__c).Name;   
  }else{
	c.Name=mapOfIsoCode.get(c.Fund_Id__c).Name+PRMGlobalConstants.dash+c.Allocation_Month__c+PRMGlobalConstants.INlineSpace+c.Allocation_Year__c;
  }	
  if(c.Name.length() > 80){
	c.Name = c.Allocation_Month__c+PRMGlobalConstants.INlineSpace+c.Allocation_Year__c;
  } 
	  }	  
	}
  }
  public static void calculateAllocations(List<Co_Op_Allocation__c> CoOpAllocationNewList, Map<Id,Co_Op_Allocation__c> CoOpAllocationOldMap){
	for(Co_Op_Allocation__c allocation : CoOpAllocationNewList){
	  if(CoOpAllocationOldMap != null){
	  
  if((CoOpAllocationOldMap.get(allocation.Id).A_A_VITAL_Revenue__c == 0 || CoOpAllocationOldMap.get(allocation.Id).A_A_VITAL_Revenue__c == null)
  && allocation.A_A_VITAL_Revenue__c != 0){
	allocation.A_A_VITAL_Allocation__c = allocation.A_A_VITAL_Revenue__c * allocation.PRM_Co_Op_Eligible__c / 100;
  }
  if((CoOpAllocationOldMap.get(allocation.Id).FN_Revenue__c == 0 || CoOpAllocationOldMap.get(allocation.Id).FN_Revenue__c == null)
  && allocation.FN_Revenue__c != 0){
	allocation.FN_Allocation__c = allocation.FN_Revenue__c * allocation.PRM_Co_Op_Eligible__c / 100;
  }
  if((CoOpAllocationOldMap.get(allocation.Id).ION_Revenue__c == 0 || CoOpAllocationOldMap.get(allocation.Id).ION_Revenue__c == null)
  && allocation.ION_Revenue__c != 0){
	allocation.ION_Allocation__c = allocation.ION_Revenue__c * allocation.PRM_Co_Op_Eligible__c / 100;
  }
  if((CoOpAllocationOldMap.get(allocation.Id).ION_NUAGE_Revenue__c == 0 || CoOpAllocationOldMap.get(allocation.Id).ION_NUAGE_Revenue__c == null)
  && allocation.ION_NUAGE_Revenue__c != 0){
	allocation.ION_NUAGE_Allocation__c = allocation.ION_NUAGE_Revenue__c * allocation.PRM_Co_Op_Eligible__c / 100;
  }
  if((CoOpAllocationOldMap.get(allocation.Id).ION_Optics_Revenue__c == 0 || CoOpAllocationOldMap.get(allocation.Id).ION_Optics_Revenue__c == null)
  && allocation.ION_Optics_Revenue__c != 0){
	allocation.ION_Optics_Allocation__c = allocation.ION_Optics_Revenue__c * allocation.PRM_Co_Op_Eligible__c / 100;
  }
  if((CoOpAllocationOldMap.get(allocation.Id).ION_Routing_Revenue__c == 0 || CoOpAllocationOldMap.get(allocation.Id).ION_Routing_Revenue__c == null)
  && allocation.ION_Routing_Revenue__c != 0){
	allocation.ION_Routing_Allocation__c = allocation.ION_Routing_Revenue__c * allocation.PRM_Co_Op_Eligible__c / 100;
  }
  if((CoOpAllocationOldMap.get(allocation.Id).MN_Revenue__c == 0 || CoOpAllocationOldMap.get(allocation.Id).MN_Revenue__c == null)
  && allocation.MN_Revenue__c != 0){
	allocation.MN_Allocation__c = allocation.MN_Revenue__c * allocation.PRM_Co_Op_Eligible__c / 100;
  }
	  }else{
  if(allocation.A_A_VITAL_Revenue__c != 0){
	allocation.A_A_VITAL_Allocation__c = allocation.A_A_VITAL_Revenue__c * allocation.PRM_Co_Op_Eligible__c / 100;
  }
  if(allocation.FN_Revenue__c != 0){
	allocation.FN_Allocation__c = allocation.FN_Revenue__c * allocation.PRM_Co_Op_Eligible__c / 100;
  }
  if(allocation.ION_Revenue__c != 0){
	allocation.ION_Allocation__c = allocation.ION_Revenue__c * allocation.PRM_Co_Op_Eligible__c / 100;
  }
  if(allocation.ION_NUAGE_Revenue__c != 0){
	allocation.ION_NUAGE_Allocation__c = allocation.ION_NUAGE_Revenue__c * allocation.PRM_Co_Op_Eligible__c / 100;
  }
  if(allocation.ION_Optics_Revenue__c != 0){
	allocation.ION_Optics_Allocation__c = allocation.ION_Optics_Revenue__c * allocation.PRM_Co_Op_Eligible__c / 100;
  }
  if(allocation.ION_Routing_Revenue__c != 0){
	allocation.ION_Routing_Allocation__c = allocation.ION_Routing_Revenue__c * allocation.PRM_Co_Op_Eligible__c / 100;
  }
  if(allocation.MN_Revenue__c != 0){
	allocation.MN_Allocation__c = allocation.MN_Revenue__c * allocation.PRM_Co_Op_Eligible__c / 100;
  }
	  }
	}
  }
}