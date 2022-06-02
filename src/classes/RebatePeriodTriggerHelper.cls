/**
* @description: Trigger helper to send email notifications
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION		   AUTHOR				DATE		   DETAIL				 FEATURES/CSR/TTP
* 1.0		  PRATEEK PRASOON		  15/09/2017	Sprint 2 PRM
* ============================================================================ 
*/
public without sharing class RebatePeriodTriggerHelper {
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Rebate_Period__c rebatePeriod
* Return: void
* Description: Method to send notifications to PRMs
* High Level Process : 
**********************************************************************************************************************/ 
	public static void sendEmails(Rebate_Period__c rebatePeriod) {
		Set<id> accId = new Set<id>();
	   // List<account> accList = new List<account>();
		List<Account_Member__c> accountMemberList = new List<Account_Member__c>();
		//List<Account_Member__c> accountMemberList1 = new List<Account_Member__c>();
		Set<String> contractTypeSet = new Set<String>();
		List<id> accIdList = new List<id> ();
		List<id> eligibleAccountIds = new List<id>();
		Map<Id,String> accMemberMap = new Map<Id,String>();
		Set<String> rebateRegion = new Set<String>();
		
		try{
			rebateRegion.addAll(rebatePeriod.Rebate_Region__c.split(PRMGlobalConstants.SemiColon));
			for(Contract_Eligible_for_Rebate__c con :[Select name from Contract_Eligible_for_Rebate__c limit 2]){
				contractTypeSet.add(con.name);
			}
			//accList = [Select id from Account where isPartner = true and partner_type__c =:  rebatePeriod.Partner_Type__c and Market__c IN :rebateRegion  Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())] ;
			for(account acc : [Select id from Account where isPartner = true and partner_type__c =:  rebatePeriod.Partner_Type__c and Market__c IN :rebateRegion  Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
				accIdList.add(acc.Id);
			}
			if(!accIdList.IsEmpty()){
				for(Contract contract : [SELECT id,AccountId from Contract where AccountId IN : accIdList and EndDate >: System.Today() and Contract_Type__c IN : contractTypeSet Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
					eligibleAccountIds.add(contract.AccountId);
				}
				if(!eligibleAccountIds.IsEmpty()){
					accountMemberList = [SELECT Account_Role__c,Id,Name__c,Name__r.Name,Type__c, Email__c, Account__c FROM Account_Member__c WHERE Account__c IN : eligibleAccountIds AND (Account_Role__c =: PRMGlobalConstants.Partner_Relationship_Manager OR Account_Role__c =: PRMGlobalConstants.PARTNER_SALES_MANAGER)  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];	
				}   
				if(!accountMemberList.IsEmpty()){
					EmailNotification.sendMailsToPRM(accountMemberList , rebatePeriod); 
					
					//Req 3574
					List<Rebate_Enrollment__c> rebateEnrollementList = new List<Rebate_Enrollment__c>();
					for(Id eaccId : eligibleAccountIds){
						Rebate_Enrollment__c rebateEnrollement1 = new Rebate_Enrollment__c(Enrollment_Status__c =PRMGlobalConstants.Not_Enrolled, Initial_Date_Sent__c = system.today(), Partner_Account__c = eaccId, Rebate_Period__c = rebatePeriod.Id );
						rebateEnrollementList.add(rebateEnrollement1);
					}								
						for(Account_Member__c memInstance : accountMemberList){
								String string1 ;
								if(accMemberMap.ContainsKey(memInstance.Account__c)){
									string1 = accMemberMap.get(memInstance.Account__c);
									string1 = string1 + PRMGlobalConstants.comma + memInstance.Email__c;
									accMemberMap.put(memInstance.Account__c, string1);
								}else{
									string1 = memInstance.Email__c;
									accMemberMap.put(memInstance.Account__c, string1);
								}
							}
						for(Rebate_Enrollment__c enrollmentInstance : rebateEnrollementList){   
								if(accMemberMap.containskey(enrollmentInstance.Partner_Account__c)){
									enrollmentInstance.PRM_Email__c = accMemberMap.get(enrollmentInstance.Partner_Account__c);
								}
								
						}							   
					
					Database.SaveResult[] srList = Database.insert(rebateEnrollementList, false);
				}
			}

		}catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.RebatePeriodHelper,PRMGlobalConstants.getCurrentUser);
		}
	}
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Rebate_Period__c rebatePeriod
* Return: void
* Description: Method to send notifications to PRMs
* High Level Process : 
**********************************************************************************************************************/ 
	public static void sendEmailForExpiredContract(Rebate_Period__c rebatePeriod) {
		List<Account_Member__c> accountMemberList = new List<Account_Member__c>();
		Map<id,Rebate_form__c> accToRebateMap = new Map<id,Rebate_form__c>();
		List<Rebate_form__c> rebateToUpdate = new List<Rebate_form__c>();
		Set<String> contractTypeSet = new Set<String>();
		Set<Id> accountSet = new Set<Id>();
		Set<Id> eligibleAccountId = new Set<Id>();
		Set<Id> ValidAccredAccountId = new Set<Id>();
		Set<Id> expiredAccountId = new Set<Id>();
		try{
			for(Contract_Eligible_for_Rebate__c con :[Select name from Contract_Eligible_for_Rebate__c limit 2]){
				contractTypeSet.add(con.name);
			}
			for(Rebate_form__c form : [Select Id,Rebate_Period__c,Rebate_Form_Status__c,Partner_Account__c from Rebate_form__c Where Rebate_Period__c = : rebatePeriod.Id Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
				accountSet.add(form.Partner_Account__c);
				accToRebateMap.put(form.Partner_Account__c,form);
			}
			for(Accreditation__c accreditation : [Select id,Partner__c from Accreditation__c where Partner__c IN : accountSet AND Pricing_Accreditation__c !=: PRMGlobalConstants.NoAccreditation Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())] ){
					ValidAccredAccountId.add(accreditation.Partner__c);
				}
			if(!ValidAccredAccountId.IsEmpty()){
				for(Contract contract : [SELECT id,AccountId from Contract where AccountId IN : ValidAccredAccountId and EndDate >: System.Today() and Contract_Type__c IN : contractTypeSet Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
					eligibleAccountId.add(contract.AccountId);  
				}
			}
			for(id eligibleAccId : eligibleAccountId ){
				Rebate_form__c rebateForm = new Rebate_form__c();
				rebateForm = accToRebateMap.get(eligibleAccId);
				rebateForm.Rebate_Form_Status__c = PRMGlobalConstants.AcceptedSecondReview;
				rebateToUpdate.add(rebateForm); 
			}
			//
			for(id accid : accountSet){
				if(!eligibleAccountId.contains(accid)){
					expiredAccountId.add(accid);
					Rebate_form__c rebateForm = new Rebate_form__c();
					rebateForm = accToRebateMap.get(accid);
					rebateForm.Rebate_Form_Status__c = PRMGlobalConstants.Pending;
					rebateForm.Pending_Rejection_Reason__c = PRMGlobalConstants.PPAContractExpired;
					rebateToUpdate.add(rebateForm);
				}
			}
			Database.update(rebateToUpdate);
			
			if(!expiredAccountId.IsEmpty()){
				accountMemberList = [SELECT Account_Role__c,Account__c,Account__r.name,Id,Name__c,Name__r.Name,Type__c FROM Account_Member__c WHERE Account__c IN : expiredAccountId AND (Account_Role__c =: PRMGlobalConstants.PARTNER_SALES_MANAGER)   Limit 1 ];  
			}
			if(!accountMemberList.IsEmpty()){
				
				EmailNotification.sendMailsForExpiredContract(accountMemberList,accToRebateMap);
			} 
		}catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.RebatePeriodHelper,PRMGlobalConstants.getCurrentUser);
			
		}
	}
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Rebate_Period__c rebatePeriod
* Return: void
* Description: Method to send notifications to PRMs
* High Level Process : 
**********************************************************************************************************************/ 
	public static void sendReminders(Rebate_Period__c rebatePeriod) {
		Set<id> accId = new Set<id>();
		List<Account_Member__c> accountMemberList = new List<Account_Member__c>();
		Set<Id> accountSet = new Set<Id>();
		Set<String> contractTypeSet = new Set<String>();
		//List<account> accList = new List<account>();
		List<id> accIdList = new List<id> ();
		List<id> eligibleAccountIds = new List<id>();
		List<Rebate_Enrollment__c> rebateEnrollementList = new List<Rebate_Enrollment__c>();
		Set<String> rebateRegion = new Set<String>();
		try{
			rebateRegion.addAll(rebatePeriod.Rebate_Region__c.split(PRMGlobalConstants.SemiColon));
			for(Contract_Eligible_for_Rebate__c con :[Select name from Contract_Eligible_for_Rebate__c limit 2]){
				contractTypeSet.add(con.name);
			}
			
			for(Rebate_form__c form :[Select Id,Rebate_Period__c,Partner_Account__c from Rebate_form__c Where Rebate_Period__c = : rebatePeriod.Id Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
				accountSet.add(form.Partner_Account__c);
			}
			//accList = [Select id from Account where isPartner = true and partner_type__c =:  rebatePeriod.Partner_Type__c and Market__c In : rebateRegion  Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())] ;
			for(account acc : [Select id from Account where isPartner = true and partner_type__c =:  rebatePeriod.Partner_Type__c and Market__c In : rebateRegion  Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())] ){
				accIdList.add(acc.Id);
			}
			if(!accIdList.IsEmpty()){
				
				for(Contract contract : [SELECT id,AccountId from Contract where AccountId IN : accIdList and EndDate >: System.Today() and Contract_Type__c IN : contractTypeSet Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
					if(!accountSet.Contains(contract.AccountId)){
						eligibleAccountIds.add(contract.AccountId);
					}
					
				}
				if(!eligibleAccountIds.IsEmpty()){
					accountMemberList = [SELECT Account_Role__c,Id,Name__c,Name__r.Name,Type__c FROM Account_Member__c WHERE Account__c IN : eligibleAccountIds AND (Account_Role__c =: PRMGlobalConstants.Partner_Relationship_Manager OR Account_Role__c =: PRMGlobalConstants.PARTNER_SALES_MANAGER)  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];	
				}
				if(!accountMemberList.IsEmpty()){
					EmailNotification.sendMailReminders(accountMemberList,rebatePeriod);
					
					rebateEnrollementList = [SELECT Id, PRM_Email__c, Reminder_Date_Sent__c FROM Rebate_Enrollment__c  WHERE Partner_Account__c IN : eligibleAccountIds AND Rebate_Period__c =: rebatePeriod.id Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
				   
					if(!rebateEnrollementList.IsEmpty()){
							for(Rebate_Enrollment__c instance : rebateEnrollementList){
								instance.Reminder_Date_Sent__c = system.today();
								
							}
							database.update(rebateEnrollementList);
					}
				}
								   
			}
					
		}catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.RebatePeriodHelper,PRMGlobalConstants.getCurrentUser);
		}
	}
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Rebate_Period__c rebatePeriod
* Return: void
* Description: Method to send notifications to PRMs
* High Level Process : 
**********************************************************************************************************************/ 
	public static void avoidDuplicate(Rebate_Period__c rebatePeriod) {
		List<Rebate_Period__c> rebateList = new List<Rebate_Period__c>();
		try{
			rebateList = [SELECT Rebate_Terms_and_Conditions__c ,Partner_Type__c,Enrollment_start_date__c,End_Date__c,Enrollment_End_Date__c,Id,Name,Start_Date__c,Technologies__c FROM Rebate_Period__c 
			WHERE ((start_Date__c =: rebatePeriod.End_Date__c)  
					AND 
					(End_Date__c =: rebatePeriod.Start_Date__c) 
					AND  
					Partner_Type__c =: rebatePeriod.Partner_Type__c) limit 1];
			if(!rebateList.IsEmpty()){
				rebatePeriod.addError(PRMGlobalConstants.Duplicate_Rebate_Period_is_not_allowed);
			}
		}catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.RebatePeriodHelper,PRMGlobalConstants.getCurrentUser);
		}
	}
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Rebate_Period__c rebatePeriod
* Return: void
* Description: Method to send notifications to PRMs for VARs
* High Level Process : 
**********************************************************************************************************************/ 
	public static void sendEmailForExpiredContractVar(Rebate_Period__c rebatePeriod) {
		List<Account_Member__c> accountMemberList = new List<Account_Member__c>();
		Map<id,Rebate_form__c> accToRebateMap = new Map<id,Rebate_form__c>();
		Map<id,List<Rebate_amount__c>> rebateToAmountMap = new Map<id,List<Rebate_amount__c>>();
		Map<id,Set<String>> accToAccreditationMap = new Map<id,Set<String>>();
		List<Rebate_form__c> rebateToUpdate = new List<Rebate_form__c>();
		List<Rebate_amount__c> rebateAmountToUpdate = new List<Rebate_amount__c>();
		Set<String> contractTypeSet = new Set<String>();
		List<account> noAccreditationAccounts = new List<account>();
		List<account> missingAccreditationAccounts = new List<account>();
		Set<Id> accountSet = new Set<Id>();
		Set<Id> noAccreditationAccountId = new Set<Id>();
		Set<Id> missingAccreditationAccountId = new Set<Id>();
		Set<Id> eligibleAccountId = new Set<Id>();
		Set<Id> ValidAccredAccountId = new Set<Id>();
		Set<Id> expiredAccountId = new Set<Id>();
		 try{
			for(Contract_Eligible_for_Rebate__c con :[Select name from Contract_Eligible_for_Rebate__c limit 2]){
				contractTypeSet.add(con.name);
			}
			for(Rebate_form__c form : [Select Id,Rebate_Period__c,Rebate_Form_Status__c,Partner_Account__c from Rebate_form__c Where Rebate_Period__c = : rebatePeriod.Id Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
				accountSet.add(form.Partner_Account__c);
				accToRebateMap.put(form.Partner_Account__c,form);
			}
			if(!accountSet.IsEmpty()){
				for(Contract contract : [SELECT id,AccountId from Contract where AccountId IN : accountSet and EndDate >: System.Today() and Contract_Type__c IN : contractTypeSet Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())]){
					eligibleAccountId.add(contract.AccountId);  
				}
			}
			for(Accreditation__c accreditation : [Select id,Portfolio__c,Partner__c from Accreditation__c where Partner__c IN : eligibleAccountId AND Pricing_Accreditation__c !=: PRMGlobalConstants.NoAccreditation Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())] ){
					ValidAccredAccountId.add(accreditation.Partner__c);
					Set<String> porfoliosName = new Set<String>();
					if(accToAccreditationMap.containsKey(accreditation.Partner__c)){
						porfoliosName = accToAccreditationMap.get(accreditation.Partner__c);
					}
					porfoliosName.add(accreditation.Portfolio__c);
					accToAccreditationMap.put(accreditation.Partner__c,porfoliosName);
				}
			for(Rebate_amount__c amounts: [SELECT Amount__c,Id,Name,Portfolio__c,Rebate_Status__c,Rebate__c FROM Rebate_Amount__c where Rebate__c IN: accToRebateMap.Values() Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())] ){
				List<Rebate_amount__c> amountList = new List<Rebate_amount__c>();
				if(rebateToAmountMap.containsKey(amounts.Rebate__c)){
					amountList = rebateToAmountMap.get(amounts.Rebate__c);
				}
				amountList.add(amounts);
				rebateToAmountMap.put(amounts.Rebate__c,amountList);
			}
			for(id eligibleAccId : eligibleAccountId ){
				boolean allAccepted = true;
				boolean allRejected = true;
				if(accToRebateMap.containsKey(eligibleAccId)){
					for(Rebate_amount__c rebateAmount  : rebateToAmountMap.get(accToRebateMap.get(eligibleAccId).Id) ){
						if(accToAccreditationMap.get(eligibleAccId) == null){
							allAccepted = false;
							rebateAmount.Rebate_Status__c = PRMGlobalConstants.StatusRejected;
							rebateAmountToUpdate.add(rebateAmount);
						}else if(accToAccreditationMap.get(eligibleAccId).contains(rebateAmount.Portfolio__c)){
							allRejected = false;
							rebateAmount.Rebate_Status__c = PRMGlobalConstants.StatusAccepted;
							rebateAmountToUpdate.add(rebateAmount);
						}else{
							allAccepted = false;
							rebateAmount.Rebate_Status__c = PRMGlobalConstants.StatusRejected;
							rebateAmountToUpdate.add(rebateAmount);
						}
					}
					Rebate_form__c rebateForm = accToRebateMap.get(eligibleAccId);
					if(allRejected == true &&  allAccepted == false){
						rebateForm.Rebate_Form_Status__c = PRMGlobalConstants.Pending;
						rebateForm.Pending_Rejection_Reason__c= PRMGlobalConstants.No_Eligible_Accreditations;
						noAccreditationAccountId.add(eligibleAccId);
					}else if(allAccepted == true && allRejected == false){
						rebateForm.Rebate_Form_Status__c = PRMGlobalConstants.AcceptedSecondReview;		 
					}else if(allAccepted == false && allRejected == false){
						rebateForm.Rebate_Form_Status__c = PRMGlobalConstants.Pending;
						rebateForm.Pending_Rejection_Reason__c= PRMGlobalConstants.Missing_Accreditations;
						missingAccreditationAccountId.add(eligibleAccId);
					}else{}
					rebateToUpdate.add(rebateForm); 
				}
			}
			//
			for(id accid : accountSet){
				if(!eligibleAccountId.contains(accid)){
					expiredAccountId.add(accid);
					Rebate_form__c rebateForm = new Rebate_form__c();
					rebateForm = accToRebateMap.get(accid);
					rebateForm.Rebate_Form_Status__c = PRMGlobalConstants.Pending;
					rebateForm.Pending_Rejection_Reason__c = PRMGlobalConstants.PPAContractExpired;
					rebateToUpdate.add(rebateForm);
				}
			}
			Database.update(rebateAmountToUpdate); 
			Database.update(rebateToUpdate);
			if(!noAccreditationAccountId.IsEmpty()){
				noAccreditationAccounts  = [SELECT OwnerId,name,Owner.Name FROM Account WHERE Id IN : noAccreditationAccountId Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
				EmailNotification.sendMailforNoAccreditation(noAccreditationAccounts,accToRebateMap);
			}
			if(!missingAccreditationAccountId.IsEmpty()){
				missingAccreditationAccounts  = [SELECT OwnerId,name,Owner.Name FROM Account WHERE Id IN : missingAccreditationAccountId Limit : (Limits.getLimitQueryRows()-Limits.getQueryRows())];
				EmailNotification.sendMailforMissingAccreditation(missingAccreditationAccounts,accToRebateMap);
			}
			if(!expiredAccountId.IsEmpty()){
				accountMemberList = [SELECT Account_Role__c,Account__c,Account__r.name,Id,Name__c,Name__r.Name,Type__c FROM Account_Member__c WHERE Account__c IN : expiredAccountId AND (Account_Role__c =: PRMGlobalConstants.PARTNER_SALES_MANAGER)   Limit 1 ];  
			}
			if(!accountMemberList.IsEmpty()){
				
				EmailNotification.sendMailsForExpiredContract(accountMemberList,accToRebateMap);
			} 
		}catch(System.Exception e){
			ExceptionHandler.addException(e,PRMGlobalConstants.RebatePeriodHelper,PRMGlobalConstants.getCurrentUser);
			
		}
	}
}