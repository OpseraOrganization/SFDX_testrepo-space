/****************************************
 * Class Name : CH_ManageEscalation
 * Created Date: 21 June 2021
 * Created By : TCS
 * Last Modified by: Akhil Ramisetty
 * Last Modified Date: 24-June 2021
 * Description : 
 * Test Class : CH_ManageEscalation_Test
*****************************************/

public without sharing class CH_ManageEscalation {


/****************************************
* Name : closeME
* Description : Updating status and stage of Manage Esclation - NOKIASC-32609
* Parameters: recordId
* Returns : Validation erros of Manage Esclation object
*****************************************/
   @AuraEnabled
	public static string closeME(string recordId){
	  String errorMsg; 
		CH_Manage_Escalation__c manageEscaltion=[SELECT Id, Name, CH_EscalationStatus__c, CH_EscalationProcessStage__c, CH_EscalationManagerLevel1__c, CH_EscalationManagerLevel2__c, CH_EscalationManagerLevel3__c 
			FROM CH_Manage_Escalation__c WHERE Id =:recordId limit 1];
		if(manageEscaltion.CH_EscalationStatus__c != 'In-Progress'){
		   errorMsg=System.Label.CH_ME_Inprogress;			
		}
		else{	
			try{
			CH_Manage_Escalation__c closeME = new CH_Manage_Escalation__c();
			closeME.Id = recordId;			
			closeME.CH_EscalationProcessStage__c='Close';
			closeME.CH_EscalationStatus__c ='Closed';
			update closeME;
			errorMsg= '';
			
			}
			catch(DmlException e){
			for (Integer i = 0; i < e.getNumDml(); i++) {			   
				errorMsg =+ e.getDmlMessage(i) +  '\n' ;
			}			
			throw new AuraHandledException(errorMsg);
			}		
		}		
		return errorMsg;
	}
}