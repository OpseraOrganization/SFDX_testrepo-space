/**
* @description: Trigger helper to send email notifications
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
* 
* VERSION		   AUTHOR				DATE		   DETAIL				 FEATURES/CSR/TTP
* 1.0		  PRATEEK PRASOON		  26/12/2016	 Sprint 4 PRM
* ============================================================================ 
*/
public without sharing class rebateformTriggerHelper {
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Rebate_Form__c rebateForm
* Return: void
* Description: Method to send notifications to PRMs
* High Level Process : 
**********************************************************************************************************************/ 
	public static void sendEmailOnRebateSubmission(Rebate_Form__c rebateForm) {
		List<Account_Member__c> accountMemberList = new List<Account_Member__c>();
		try{
			string RFUrl = PRMGlobalConstants.RFUrl;
			Rebate_Enrollment__c enrollment = new Rebate_Enrollment__c();
			accountMemberList = [SELECT Account_Role__c,Id,Name__c,Name__r.Name,Type__c FROM Account_Member__c WHERE Account__c =:rebateForm.Partner_Account__c  AND( Account_Role__c =: PRMGlobalConstants.Partner_Relationship_Manager  OR Account_Role__c =: PRMGlobalConstants.PARTNER_SALES_MANAGER)  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ]; 
			if(!accountMemberList.IsEmpty()){
				EmailNotification.sendMailsOnRebateSubmission(accountMemberList,rebateForm);
				//Requirement 3574
				enrollment = [SELECT Id, Enrollment_Status__c, Partner_Account__c, PRM_Email__c, Rebate_Period__c FROM Rebate_Enrollment__c WHERE Partner_Account__c =: rebateForm.Partner_Account__c AND Rebate_Period__c =: rebateForm.Rebate_Period__c Limit 1];
				enrollment.Enrollment_Status__c = PRMGlobalConstants.Enrolled;
				enrollment.Rebate_Form_Id__c = rebateForm.Id;
				enrollment.Rebate_Form_Name__c = rebateForm.Name;
				database.update(enrollment);	
			}
			
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.RebateFormHelper,PRMGlobalConstants.getCurrentUser);}
	}
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Rebate_Form__c rebateForm
* Return: void
* Description: Method to send notifications to PSM
* High Level Process : 
**********************************************************************************************************************/ 
  /*  public static void sendEmailOnAmountFilling(Rebate_Form__c rebateForm) {
		List<Account_Member__c> accountMemberList = new List<Account_Member__c>();
		try{
			accountMemberList = [SELECT Account_Role__c,Id,Name__c,Name__r.Name,Type__c FROM Account_Member__c WHERE Account__c =:rebateForm.Partner_Account__c AND Account_Role__c =: PRMGlobalConstants.PARTNER_SALES_MANAGER  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ]; 
			if(!accountMemberList.IsEmpty()){
				EmailNotification.sendMailsForAmountFilling(accountMemberList,rebateform);
			}
			Rebate_Form__c rebate = [Select id,Partner_Acceptance_Status__c from Rebate_Form__c Where id =:rebateForm.Id limit 1 ];
			rebate.Partner_Acceptance_Status__c = PRMGlobalConstants.InReview;
			update rebate ;
		}catch(System.Exception e)
		{
			 ExceptionHandler.addException(e,PRMGlobalConstants.RebateFormHelper,PRMGlobalConstants.getCurrentUser);
			 
		}
	} */
	
 //Requirement 3574   
   /* public static void createEnrollementonRebateInsert(Rebate_Form__c rebateForm) {
		Set<id> accId = new Set<id>();
		List<Account_Member__c> accountMemberList = new List<Account_Member__c>();
		Map<Id,String> accMemberMap = new Map<Id,String>();
		try{
				accountMemberList = [SELECT Account_Role__c,Id, Account__c, Name__c,Name__r.Name,Type__c, Email__c FROM Account_Member__c WHERE Account__c =: rebateForm.Partner_Account__c AND Account_Role__c =: PRMGlobalConstants.Partner_Relationship_Manager Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ];  
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
				List<Rebate_Enrollment__c> rebateEnrollmentList = new List<Rebate_Enrollment__c>();
				for(Rebate_Enrollment__c enrollmentInstance : [SELECT Id, Partner_Account__c, PRM_Email__c FROM  Rebate_Enrollment__c WHERE Partner_Account__c =: rebateForm.Partner_Account__c]){
					if(accMemberMap.containskey(enrollmentInstance.Partner_Account__c)){
						enrollmentInstance.PRM_Email__c = accMemberMap.get(enrollmentInstance.Partner_Account__c);
					}
					rebateEnrollmentList.add(enrollmentInstance);   
				}
				database.update(rebateEnrollmentList,false);
		}catch(System.Exception e){
			
		}
	}
		 */   
/**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Rebate_Form__c rebateForm
* Return: void
* Description: Method to send notifications to PRM
* High Level Process : 
**********************************************************************************************************************/ 
	public static void sendMailsOnRejection(Rebate_Form__c rebateForm) {
		List<Account_Member__c> accountMemberList = new List<Account_Member__c>();
		try{
			accountMemberList = [SELECT Account_Role__c,Id,Name__c,Name__r.Name,Type__c FROM Account_Member__c WHERE Account__c =:rebateForm.Partner_Account__c  AND( Account_Role__c =: PRMGlobalConstants.Partner_Relationship_Manager )  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows()) ]; 
			if(!accountMemberList.IsEmpty()){
				EmailNotification.sendMailsOnRejection(accountMemberList,rebateForm);
			}
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.RebateFormHelper,PRMGlobalConstants.getCurrentUser);}
			 
		
	}
  /**********************************************************************************************************************
* author: Accenture
* Date: August-2017
* Param: Rebate_Form__c rebateForm
* Return: void
* Description: Method to send notifications to PSM
* High Level Process : 
**********************************************************************************************************************/   
   public static void sendEmailOnRejectionRebate(Rebate_Form__c rebateForm) {
		List<Account_Member__c> accountMemberList = new List<Account_Member__c>();
		try{
			accountMemberList = [SELECT Account_Role__c,Account__r.Name,Id,Name__c,Name__r.Name,Type__c FROM Account_Member__c WHERE (Account__c =:rebateForm.Partner_Account__c  AND(Account_Role__c =: PRMGlobalConstants.PARTNER_SALES_MANAGER) AND Name__c IN (SELECT OwnerId FROM Account WHERE Id =: rebateForm.Partner_Account__c )) Limit 1]; 
			if(!accountMemberList.IsEmpty()){
				EmailNotification.sendEmailOnRejectionRebate(accountMemberList,rebateForm);
			}
		}catch(System.Exception e){ExceptionHandler.addException(e,PRMGlobalConstants.RebateFormHelper,PRMGlobalConstants.getCurrentUser); }
	}
}