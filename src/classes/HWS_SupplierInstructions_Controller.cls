/****************************************
* Class Name : HWS_SupplierInstructions_Controller
* User Story :NOKIASC-31226
* Created Date: 16 Sept 2020
* Created By : TCS
* Last Modified by: 
* Last Modified Date:
* @description : Controller for Supplier Instructions
* Test Class: HWS_SupplierInstructions_Controller_Test
*****************************************/
public with sharing class HWS_SupplierInstructions_Controller {
	
	/****************************************
* Name : getReferralInstructions
* @description : This method is uesd to get related child records
* By Afif Reja
* Created Date: 16 Sept 2020
* User story : NOKIASC-31226
*****************************************/ 
	@AuraEnabled
	public static List<Case> getReferralInstructions(Id caseId){
		
		// added for pmd error - NOKIASC-32425
		return [SELECT Id,subject,HWS_LogisticNodeCode__c,HWS_LogisticNodeName__c,HWS_Part_Code__c, 
				HWS_Faulty_Serial_Number__c,CH_InternalStatus__c  
				FROM Case 
				WHERE ParentId =: caseId 
				AND Status!='Cancelled'  ORDER BY HWS_LogisticNodeCode__c ASC ];

	} 
	
	/****************************************
* Name : changeInternalStatus
* Description : This method is uesd to change Internal Status for child case
* By Afif Reja
* Created Date: 07 Oct 2020
* User story : NOKIASC-31275
*****************************************/  
	@AuraEnabled
	Public Static String changeInternalStatus(String childCaseIDs){
		String errorMsg='';		   
		Set<Id> selectedChildCaseIds = new Set<Id>();
		try{
			//deserialize the JSON to a list of cases
			List<Case> selectedCases = (List<Case>) JSON.deserialize(childCaseIDs, List<Case>.class);
			for (Case selectedCase : selectedCases){
				selectedChildCaseIds.add(selectedCase.Id);
			}
			// added  for pmd error - NOKIASC-32425
			List<Case>childCaseList = [SELECT Id  
									   FROM Case 
									   WHERE Id IN :selectedChildCaseIds AND CH_InternalStatus__c ='Pending Referral Instruction' 
									   AND Status!='Cancelled' ];
			
			selectedCases.clear();		
			for( Case caseDetail : childCaseList){
				Case caseValue = new Case();
				caseValue=caseDetail;
				caseValue.CH_InternalStatus__c='Completed Referral Instruction';
				selectedCases.add(caseValue);			  
			}
			if (selectedCases.Size()>0){
				update selectedCases;
			}						
		}	  
		catch(Exception e){			
			throw new AuraHandledException(e.getMessage());
		}
		return errorMsg;
	}
	@AuraEnabled
	Public Static String updateParentCase(Id caseId){
		String errorMsg=''; 
		try{
			// added  for pmd error - NOKIASC-32425
			List<Case> childPendingInstructionList = [SELECT id  
													  FROM Case 
													  WHERE ParentId =: caseId AND CH_InternalStatus__c ='Pending Referral Instruction' ];
			
			if (childPendingInstructionList.size()==0){
				// added  for pmd error - NOKIASC-32425
				Case updateCase =[SELECT id,CH_InternalStatus__c from Case where Id=:caseId  LIMIT 1];
				updateCase.CH_InternalStatus__c='Completed Referral Instruction';
				Update updateCase;
			}
		}
		catch(Exception e){			
			throw new AuraHandledException(e.getMessage());
		}
		return errorMsg;
	}
	/****************************************
* Name : GetEscalationInstruction
* Description : This method is uesd get Escalation Instruction from SOO calout
* By Afif Reja
* Created Date: 28 Oct 2020
* User story : NOKIASC-31236
*****************************************/  
	@auraEnabled
	public static String getEscalationInstruction(String parentCaseId,String childCaseId){
		String  escalationInstruction = ''; 
		String actionName='GetEscalationInstruction';
		try{
			
			// Passing Other method to make callout
			HWS_CancelcaseSendSRtoSOO_SVC.processResponse pr= HWS_CancelcaseSendSRtoSOO_SVC.getEscalationInstruction(parentCaseId,childCaseId,actionName);			
			if(!pr.isError){
				
				escalationInstruction=  String.isBlank(pr.EscalationInstruction)?'<div class="slds-align_absolute-center"><b>No Escalation Instructions found.</b></div>': EncodingUtil.base64Decode(pr.EscalationInstruction).toString();
			}  
			else{
				escalationInstruction='<div class="slds-align_absolute-center"><b>No Response from SOO , Try again.</b></div>';
			}			
		}		
		Catch(Exception e){			
			return null;
		}
		return escalationInstruction;
	}
}