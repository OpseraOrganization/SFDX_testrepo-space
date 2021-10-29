/**
* @author Luis Camacho
* @date 10/30/2017
*
* @description - Case trigger handler
*/
public class CaseHandler {
    
    private boolean m_isExecuting = false;
    private integer batchSize = 0;
    private static boolean run = true;
    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
             }else{
return run;
             }
    }
    
    //Variables Declaration
    List<ID> accidlist = new List<ID>();
    
    public CaseHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        batchSize = size;
    }
    
    public void onBeforeInsert_OneOffCase(List<Case> newCases){
        RDF_PopulateAccountandEscalatedToUser.populateAcctandEscalatedToUsr(newCases);
    }
    
    public void onBeforeInsert(List<Case> newCases){
        CaseServiceOnInsert.setCaseValues(newCases); //added from S2S_CEC_2_Aero_Case        
        CaseServiceOnInsert.beforeInsertMethod(newCases,null);//Added from beforeInsertHelpeClass
        CaseServiceOnInsert.beforeInsertOwnerAssignmentMethod(newCases);//Added from OwnerAssignmentForCSOCases Class
        CaseServiceForCommonMethods.InsertReasonForHold(newCases);//Added from AfterUpdateHelperClass Class - InsertReasonForHold
        CaseServiceForCommonMethods.onBeforeInsertAndUpdateAssignPrimary(true,false,newCases,null,null); //addedfrom case_updatePrimary trigger
        
        CaseServiceForCommonMethods.caseResolutionAndSubclass(newCases); //added from Case_ProvideAccess
        CaseServiceForCommonMethods.beforeCaseOwnerQueue(newCases); //added from Case_ProvideAccess
        CaseServiceForCommonMethods.beforeIsCaseOwnerQueue(newCases); //added from Case_ProvideAccess
        accidlist = CaseServiceOnInsert.beforeInsertGetAccountIds(newCases); //added from Case_ProvideAccess
        CaseServiceForCommonMethods.caseFSENameByAccountTeamMember(newCases,accidlist); //added from Case_ProvideAccess
        CaseServiceOnInsert.beforeInsertComplianceCase(newCases); //added from Case_ProvideAccess
        CaseServiceOnInsert.updateFieldsOnCase(newCases);  // Added to update portal status and request types
       
    }
        
    public void onAfterInsert(List<Case> newCases){
      // added by saurabh shukla for INC0003233109 to avoid running the method for guest users
        if(UserInfo.getUserType() != 'Guest'){
        CaseServiceOnInsert.AfterInsertUpdateCaseCEC(newCases); //added from S2S_CEC_2_Aero_Case 
        }
        // INC0003233109 end
        CaseServiceOnInsert.afterInsertComplianceCase(newCases); //added from Case_ProvideAccess
        CaseServiceOnInsert.afterInsertProvideAccess(newCases); //added from Case_ProvideAccess
        CaseServiceOnInsert.afterInsertMethod(true,newCases,null);//Added From AfterInsertHelper 
        CaseServiceOnInsert.OwnerAssignmentForCSOCasesAfterInsert(newCases); //Added from OwnerAssignmentForCSOCases Class
        CaseServiceForCommonMethods.Sendemail_TCT_TechnicalIssue(true,false,newCases,null,null);//added for SCTASK1616257
        CaseServiceOnInsert.AddAckEmailTocase(newCases);
        //MT-845 Ticket changes .
        CaseServiceOnInsert.emailMessage(newCases);
        //ICM Filedetails Update
        CaseServiceOnInsert.attachmentUpdate(new Map<Id,Case>(newCases).keySet());
        
    }
    
    public void onBeforeUpdate(List<Case> oldCases, List<Case> updatedCases, Map<ID,Case> newMap, Map<ID,Case> oldMap){
        CaseServiceOnUpdate.beforeUpdateCaseReopen(updatedCases,oldMap);
        CaseEscalationForHolds.setEscalationLevel(updatedCases, newMap, oldMap);//automatic escalation
		CaseServiceForCommonMethods.onBeforeInsertAndUpdateAssignPrimary(false,true,updatedCases,newMap,oldMap);//addedfrom case_updatePrimary trigger
        CaseServiceForCommonMethods.caseResolutionAndSubclass(updatedCases); //added from Case_ProvideAccess
        CaseServiceForCommonMethods.beforeCaseOwnerQueue(updatedCases); //added from Case_ProvideAccess
        CaseServiceForCommonMethods.beforeIsCaseOwnerQueue(updatedCases); //added from Case_ProvideAccess
        accidlist = CaseServiceOnUpdate.beforeUpdateGetAccountIds(updatedCases,oldMap,newMap); //added from Case_ProvideAccess
        CaseServiceForCommonMethods.caseFSENameByAccountTeamMember(updatedCases,accidlist); //added from Case_ProvideAccess
        CaseServiceOnUpdate.closeCaseError(updatedCases,oldMap,newMap); //added from Case_ProvideAccess
        CaseServiceOnUpdate.beforeUpdateComplianceCase(updatedCases,oldMap,newMap); //added from Case_ProvideAccess
        CaseServiceOnUpdate.beforeUpdateIsOwnerChanged(updatedCases,oldMap,newMap); //added from Case_ProvideAccess
        CaseServiceOnUpdate.beforeUpdateIsMemberCompliance(updatedCases,oldMap,newMap); //added from Case_ProvideAccess
        CaseServiceOnUpdate.beforeUpdateMethod(updatedCases,oldMap);
        //added by Radha
        CaseServiceOnUpdate.beforeUpdate_customerSupport_businessfocal(updatedCases); //SCTASK1191446
        
        //Added for NPS Neutral
        //CaseServiceOnUpdate.NPSNeutralTaskCreation(updatedCases,oldMap,newMap);
        
        //CaseServiceOnUpdate.ownerAssignmentForCSOCasesBeforeUpdateMethod(updatedCases,oldMap); //Added from OwnerAssignmentForCSOCases Class
        CaseServiceForCommonMethods.InsertReasonForHold(updatedCases);//Added from AfterUpdateHelperClass Class - InsertReasonForHold
        CaseServiceOnUpdate.updateFieldsOnCaseWhenUpdate(updatedCases);
    }
    
    public void onAfterUpdate(List<Case> oldCases, List<Case> updatedCases, Map<Id,Case> newMap, Map<ID,Case> oldMap){
       CaseServiceOnUpdate.updateComplianceCase(updatedCases,oldMap,newMap); //added from Case_ProvideAccess
        CaseEscalationForHolds.createcasecomment(updatedCases, oldMap);//automatic escalation
        //CaseEscalationForHolds.sendescalatedemailFirstEscalation(updatedCases);//automatic escalation
        //CaseServiceOnUpdate.conexiomtypeupdateautomation(updatedCases, oldMap);
        CaseServiceOnUpdate.updateOwnerAndCaseAeroIds(updatedCases,oldMap,newMap); //added from Case_ProvideAccess
        CaseServiceOnUpdate.afterUpdateProvideAccess(updatedCases,oldMap,newMap); //added from Case_ProvideAccess        
        CaseServiceOnUpdate.afterUpdateMethod(updatedCases,oldMap); //added from AfterUpdateHelperClass - afterUpdateMethod
        CaseServiceOnUpdate.createSurveyURLForCase(updatedCases,oldMap); //Create survey url
        CaseServiceOnUpdate.SendMailAfterSubStausChange(updatedCases,oldMap); //Added by Vel
       CaseServiceOnUpdate.CoreRecoverySendRemainder(updatedCases,oldMap); //Added by Vel for Core Recovery
        CaseServiceForCommonMethods.Sendemail_TCT_TechnicalIssue(false,true,null,newMap,oldMap);//added for SCTASK1616257
        CaseServiceOnUpdate.SendOutBoundOnISCHoldUpdate(updatedCases,oldMap);
        CaseServiceOnUpdate.SendReminderEmailOnCustomerHold(updatedCases,oldMap);
        CaseServiceOnUpdate.SendReminderEmailOnCustomerHoldOrders(updatedCases,oldMap);
        CaseServiceOnUpdate.SendAttachmentOrders(updatedCases,oldMap);
        CaseServiceOnUpdate.CaseAssociationRemove(updatedCases,oldMap); // APU Project
        AeroSFtoSAPOnInsertNdUpdate.afterUpdateofFscm(updatedCases,oldMap);//for transfer of updated fields on FSCM cases to SAP from SFDC
        
    }
    
}