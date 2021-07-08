/*******************************************************************************************
Name       :    GDMFSL_OnDemandAssignmentProcessor
Purpose    :    Business Logic for On Demand Assignment object . See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Bryant Daniels        2020-Dec-30      Created
**********************************************************************************************/
public without sharing class GDMFSL_OnDemandAssignmentProcessor {

    private static Map<Id, List<GDMFSL_On_Demand_Assignment__c>> servTerrIDToOnDemandAssigns = new Map<Id, List<GDMFSL_On_Demand_Assignment__c>>();

    public static Map<Id, List<GDMFSL_On_Demand_Assignment__c>> getRecordsByTerritoryId(Set<Id> servTerrIds) {

        System.debug('GDMFSL_OnDemandAssignmentProcessor.getRecordsByTerritoryId()');


        if (servTerrIds != null && !servTerrIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (servTerrIDToOnDemandAssigns.isEmpty()) {
                newRecIds.addAll(servTerrIds);
            } else {
                for (Id thisRecId : servTerrIds) {
                    if (!servTerrIDToOnDemandAssigns.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                for (GDMFSL_On_Demand_Assignment__c thisOnDemAssign : [
                        SELECT Id,
                                GDMFSL_Start_Date_Time__c,
                                GDMFSL_End_Date_Time__c,
                                GDMFSL_Service_Territory__c,
                                GDMFSL_Service_Resource__c
                        FROM GDMFSL_On_Demand_Assignment__c
                        WHERE GDMFSL_Service_Territory__c IN :newRecIds
                        AND GDMFSL_Service_Resource__r.ResourceType != 'D'
                        AND GDMFSL_Service_Resource__r.IsActive = TRUE
                ]){

                    if (!servTerrIDToOnDemandAssigns.containsKey(thisOnDemAssign.GDMFSL_Service_Territory__c)){
                        servTerrIDToOnDemandAssigns.put(thisOnDemAssign.GDMFSL_Service_Territory__c, new List<GDMFSL_On_Demand_Assignment__c>());
                    }

                    servTerrIDToOnDemandAssigns.get(thisOnDemAssign.GDMFSL_Service_Territory__c).add(thisOnDemAssign);
                }

                System.debug('Retrieved OnDemandAssignments: ' + servTerrIDToOnDemandAssigns);
            }
        }

        return servTerrIDToOnDemandAssigns;
    }
}