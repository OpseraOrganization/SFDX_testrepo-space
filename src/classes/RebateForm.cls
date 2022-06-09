/**
* @description: RebateForm
* @author:	Accenture IDC.
* @class name : RebateForm
* ============================================================================
* History:
* -------
* 
* VERSION		   AUTHOR				DATE		   DETAIL				 FEATURES/CSR/TTP
* 1.0		  PRATEEK PRASOON		  15/09/2017	Sprint 2 PRM
* ============================================================================ 
*/
public without sharing class RebateForm {
	 
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: string,List<String>
* Return: string
* Method Name : saveRebate
*  
**********************************************************************************************************************/
@AuraEnabled
	public static string saveRebate(string details , List<String> technologiesList) {
		string ab;
		try{
			
			List<String> tech = new List<String>();
			List<Rebate_Amount__c> rebateAmountList = new List<Rebate_Amount__c>();
			user userInstance = [SELECT Name,address,ContactId,Contact.AccountId,Contact.FirstName,Contact.LastName,Email,Id,Phone,Contact.Account.BillingAddress,Contact.Account.LegalAccountName__c,Contact.Account.Country__c   
									FROM User where id =: userinfo.getUserId() limit 1];
			Rebate_form__c rebate = new Rebate_form__c();
			List<String> detailsList = (List<String>)JSON.deserialize(details,List<String>.class);
			rebate.Partner_Account__c = userInstance.Contact.AccountId;
			rebate.phone__c = userInstance.phone;
			rebate.Email__c = userInstance.email;
			rebate.Rebate_Period__c = getRebatePeriod().Id;
			for(string str : technologiesList){
				if(str == PRMGlobalConstants.AirscaleWifi){
					rebate.Airscale_Wifi__c = true;
				}else if(str == PRMGlobalConstants.FixedAccessFBA){
					rebate.Fixed_Access_FBA__c = true;
				}else if(str == PRMGlobalConstants.FixedAccessPOL){
					rebate.Fixed_Access_POL__c = true;
				}else if(str == PRMGlobalConstants.IPRouting){
					rebate.IP_Routing__c = true;
				}else if(str == PRMGlobalConstants.Microwave){
					rebate.Microwave__c = true;
				}else if(str == PRMGlobalConstants.Nuage){
					rebate.Nuage__c = true;
				}else if(str == PRMGlobalConstants.Optics){
					rebate.Optics__c = true;
				}else if(str == PRMGlobalConstants.VitalQIP){
					rebate.Vital_QIP__c = true;
				}else if(str == PRMGlobalConstants.VitalSuite){
					rebate.Vital_Suite__c = true;
				}else if(str == PRMGlobalConstants.OpticsWaveLite){
					rebate.Optics_WaveLite__c = true;
				}
			}
			rebate.Payment_Method__c = detailsList[1];
			insert rebate;
			for(string str : technologiesList){
				Rebate_Amount__c rebateAmount = new Rebate_Amount__c();
				rebateAmount.Portfolio__c = str;
				rebateAmount.Rebate__c = rebate.Id;
				rebateAmountList.add(rebateAmount);
			}
			insert rebateAmountList;
			
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.RebateFormClass ,PRMGlobalConstants.getCurrentUser);}
		return ab;
	}
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: void
* Return: user
* 
* 
**********************************************************************************************************************/
	 @AuraEnabled
	public static user getUserInstance() {
		user userInstance = new user();
		try{
			userInstance = [SELECT Name,address,ContactId,Contact.FirstName,Contact.AccountId,Contact.MailingCountry ,Contact.MailingCity ,Contact.Email,Contact.Phone,Contact.LastName,Email,Id,Phone,Contact.Account.BillingStreet,Contact.Account.BillingCity,Contact.Account.BillingState,Contact.Account.BillingPostalCode,Contact.Account.partner_type__c ,Contact.Account.LegalAccountName__c,Contact.Account.Country__c FROM User where id =: userinfo.getUserId() limit 1];
			
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.RebateFormClass ,PRMGlobalConstants.getCurrentUser);}
		return userInstance ;
	}
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Void
* Return: Rebate_Period__c
* 
**********************************************************************************************************************/
		 @AuraEnabled
	public static Rebate_Period__c getRebatePeriod() {
		List<Rebate_Period__c> rebatePeriod  = new List<Rebate_Period__c>();
		try{
			rebatePeriod = [SELECT Rebate_Terms_and_Conditions__c ,Partner_Type__c,Enrollment_start_date__c,End_Date__c,Enrollment_End_Date__c,Id,Name,Start_Date__c,Technologies__c FROM Rebate_Period__c WHERE (Enrollment_start_date__c <=: system.today() AND End_Date__c >=: system.today()) AND  Partner_Type__c =: getUserInstance().Contact.Account.partner_type__c limit 1];
		   
			
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.RebateFormClass ,PRMGlobalConstants.getCurrentUser);}
		if(!rebatePeriod.IsEmpty() ){
			return rebatePeriod[0];
		}
		else{
			return null;
		}
	}
	
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Void
* Return: string
* 
**********************************************************************************************************************/
		 @AuraEnabled
	public static string checkValidUser(){
		string error;
		List<account> acclist = new List<account> ();
		try{
			Rebate_Period__c rebatePeriod = getRebatePeriod();
			if(rebatePeriod == null){
				error = PRMGlobalConstants.ContractExpired; 
			}else{
				//partnerType.addAll(rebatePeriod.Partner_Type_Available_for_Rebate_Period__c.split(';'));
				user userInstance = [SELECT Contact.AccountId  
											FROM User where id =: userinfo.getUserId() limit 1];
				if(system.today() > rebatePeriod.Enrollment_End_Date__c){
					error = PRMGlobalConstants.EndOfEnrollment;
				}else{
					List<Rebate_form__c> rebateFormList = new List<Rebate_form__c>();
					
					List<Contract> contractList = new List<Contract>();
					Set<String> contractTypeSet = new Set<String>();
					for(Contract_Eligible_for_Rebate__c con :[Select name from Contract_Eligible_for_Rebate__c limit 2]){
						contractTypeSet.add(con.name);
					}
					contractList = [SELECT id,AccountId from Contract where AccountId = : userInstance.Contact.accountId and EndDate >: System.Today() and Contract_Type__c IN : contractTypeSet Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
					if(!contractList.IsEmpty() ){
						rebateFormList = [Select Id,Rebate_Period__c,Partner_Account__c from Rebate_form__c Where Rebate_Period__c = : rebatePeriod.Id Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
						for(Rebate_form__c rf : rebateFormList){
							if(rf.Partner_Account__c == userInstance.Contact.AccountId ){
								error = PRMGlobalConstants.duplicateAccount;
								break;
							}else{
								error = PRMGlobalConstants.NoError;
							}
						}
					}else{
						error = PRMGlobalConstants.ContractExpired;
					}
				}
				if(rebatePeriod.Partner_Type__c == PRMGlobalConstants.Distr){
					acclist = [Select id from Account where id =: userInstance.Contact.accountId  and partner_type__c = :  rebatePeriod.Partner_Type__c and Market__c =:rebatePeriod.Rebate_Region__c  Limit 1];
				}else{
					acclist = [Select id from Account where id =: userInstance.Contact.accountId  and partner_type__c = :  rebatePeriod.Partner_Type__c Limit 1];
				}
				if(acclist.IsEmpty()){
					error = PRMGlobalConstants.ContractExpired; 
				}
				
			}
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.RebateFormClass ,PRMGlobalConstants.getCurrentUser);}
		return error;	   
	}
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Void
* Return: List<string>
*  
**********************************************************************************************************************/	
	@AuraEnabled
	public static List<string> availableTech(){
		Set<string> portfolioSet = new Set<string>();
		List<string> portfolioList = new List<string>();
		try{
			user userInstance = getUserInstance();
			for(Accreditation__c accreditation : [Select id,Partner__c,Portfolio__c from Accreditation__c where Partner__c =: userInstance.Contact.accountId AND Pricing_Accreditation__c !=: PRMGlobalConstants.NoAccreditation Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())] ){
				portfolioSet.add(accreditation.Portfolio__c);
			}
			portfolioList.addAll(portfolioSet);
			
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.RebateFormClass ,PRMGlobalConstants.getCurrentUser);}
		return portfolioList;
	}


}