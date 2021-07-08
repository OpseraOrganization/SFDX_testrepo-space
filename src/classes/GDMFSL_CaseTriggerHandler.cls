/*******************************************************************************************
Name       :    GDMFSL_CaseTriggerHandler
Purpose    :    Handler for Case object trigger. See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Bryant                  2020-Oct-8    Created
**********************************************************************************************/

public without sharing class GDMFSL_CaseTriggerHandler {

    /*************************************************************
  * @Description  Handler method for Trigger on Case Object
  * ***********************************************************/
    public static void handleOperations(TriggerOperation operation, List<Case> newCases, Map<Id,Case> newRecsMap, Map<Id, Case> oldRecsMap) {

        if (GDMFSL_CommonUtilities.isProcessingDisabled()){
            System.debug('Processing is disabled via Custom Setting');
            return;
        }

        switch on operation {

            when BEFORE_INSERT {
                doBeforeInsertWork(newCases);
            }
            when AFTER_UPDATE {
                doAfterUpdateWork(newRecsMap, oldRecsMap);
            }
            when BEFORE_UPDATE {
                doBeforeUpdateWork(newCases, oldRecsMap);
                
            }
        }
    }

    
    @TestVisible
    private static void doBeforeInsertWork(List<Case> newCases) {
        if(!GDMFSL_CommonUtilities.isFlagSet('doBeforeInsertWork')) {
            GDMFSL_CommonUtilities.setFlag('doBeforeInsertWork');
            GDMFSL_CaseProcessor.setCaseFields(newCases);

        }
    }

    @TestVisible
    private static void doAfterUpdateWork(Map<Id, Case> newRecsMap, Map<Id, Case> oldCasesMap) {
        if(!GDMFSL_CommonUtilities.isFlagSet('doAfterUpdateWork')) {
            GDMFSL_CommonUtilities.setFlag('doAfterUpdateWork');
            GDMFSL_CaseProcessor.closeRelatedWorkOrdersAndServiceAppointments(newRecsMap, oldCasesMap);
    
        }
    }

    @TestVisible
    private static void doBeforeUpdateWork(List<Case> newRecs, Map<Id, Case> oldCasesMap) {
        if(!GDMFSL_CommonUtilities.isFlagSet('beforeUpdateCaseDone')){
            GDMFSL_CommonUtilities.setFlag('beforeUpdateCaseDone');
            GDMFSL_CaseProcessor.assessCaseCompleted(newRecs, oldCasesMap);
                
        }
    }


}