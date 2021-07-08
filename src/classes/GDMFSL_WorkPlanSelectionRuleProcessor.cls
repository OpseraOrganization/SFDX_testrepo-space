/*******************************************************************************************
Name       :    GDMFSL_WorkPlanSelectionRuleProcessor
Purpose    :    Business Logic for Work Plan Selection Rule object . See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav Zaroo        2020-Jan-13      Created
**********************************************************************************************/
public without sharing class GDMFSL_WorkPlanSelectionRuleProcessor {

    private static Map<Id, WorkPlanSelectionRule> retVals = new Map<Id, WorkPlanSelectionRule>();

    public static Map<Id, WorkPlanSelectionRule> getRecords(Set<Id> serviceTerritoryIds, Set<Id> serviceContractIds, Set<Id> workTypeIds, Set<Id> productIds) {

        System.debug('GDMFSL_WorkPlanSelectionRule.getRecords()');
        System.debug('ServiceTerritoryIds received :' + serviceTerritoryIds);
        System.debug('ServiceContractIds received :' + serviceContractIds);
        System.debug('WorkTypesIds received :' + workTypeIds);
        System.debug('ProductIds received :' + productIds);

        if (retVals.isEmpty()) {

            retVals = new Map<Id, WorkPlanSelectionRule>([
                    SELECT Id,
                            ServiceContractId,
                            ServiceTerritoryId,
                            Product2Id,
                            WorkTypeId,
                            WorkPlanTemplateId
                    FROM WorkPlanSelectionRule
                    WHERE IsActive = TRUE
                    AND (ServiceTerritoryId IN :serviceTerritoryIds
                    OR ServiceContractId IN :serviceContractIds
                    OR WorkTypeId IN :workTypeIds
                    OR Product2Id IN :productIds)
            ]);

        }

        System.debug('Retrieved this many WorkPlanSelectionRules: ' + retVals.size());
        return retVals;
    }

}