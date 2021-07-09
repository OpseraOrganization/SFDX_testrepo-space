/*******************************************************************************************
Name       :    GDMFSL_ServiceContractTriggerHandler
Purpose    :    Trigger handler for ServiceContract object
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
JMay                  2020-Oct-01    Created
**********************************************************************************************/
public without sharing class GDMFSL_ServiceContractTriggerHandler {

    public static void handleOperations(TriggerOperation operation, List<ServiceContract> newRecs,Map<Id, ServiceContract> newRecsMap, Map<Id, ServiceContract> oldRecsMap) {

        if (GDMFSL_CommonUtilities.isProcessingDisabled()) {
            System.debug('Processing is disabled via Custom Setting');
            return;
        }

        switch on operation {

            when BEFORE_INSERT {
                doBeforeInsertWork(newRecs);
            }
            when AFTER_UPDATE {
                doAfterUpdateWork(oldRecsMap,newRecsMap);
            }
            when BEFORE_UPDATE{
                doBeforeUpdateWork(newRecs,oldRecsMap);
            }
            
        }
    }

    @TestVisible
    private static void doBeforeInsertWork(List<ServiceContract> newRecs) {
        GDMFSL_ServiceContractProcessor.setInitialFields(newRecs);
        GDMFSL_ServiceContractProcessor.updateALEFieldsOnSC(newRecs);
        
    }

    @TestVisible
    private static void doBeforeUpdateWork(List<ServiceContract> newRecs,Map<Id,ServiceContract> oldRecsMap) {
        if(!GDMFSL_CommonUtilities.isFlagSet('beforeUpdateSCDone')) {
            GDMFSL_CommonUtilities.setFlag('beforeUpdateSCDone');
            
            
        }
    }
    @TestVisible
    private static void doAfterUpdateWork(Map<Id,ServiceContract> oldRecsMap,Map<Id,ServiceContract> newRecsMap) {
        if(!GDMFSL_CommonUtilities.isFlagSet('afterUpdateSCDone'))
        {
            GDMFSL_CommonUtilities.setFlag('afterUpdateSCDone');
            GDMFSL_ServiceContractProcessor.updateRelatedObjects(oldRecsMap,newRecsMap);
        }

    }
}