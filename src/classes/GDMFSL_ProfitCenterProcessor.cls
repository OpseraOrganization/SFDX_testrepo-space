/**
 * Name       :    GDMFSL_ProfitCenterProcessor
 * Purpose    :    Business Logic for ProfitCenter object . See method descriptions for proper context for calling each method
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Udbhav                  2020-Dec-17    Created
 **/
public without sharing class GDMFSL_ProfitCenterProcessor {


    private static Map<Id, Map<Id, GDMFSL_Profit_Center__c>> retVals = new Map<Id, Map<Id, GDMFSL_Profit_Center__c>>();

    public static Map<Id, Map<Id, GDMFSL_Profit_Center__c>> getRecords(Set<Id> serviceTerritoryIds) {


        if (serviceTerritoryIds != null && !serviceTerritoryIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (retVals.isEmpty()) {
                newRecIds.addAll(serviceTerritoryIds);
            } else {
                for (Id thisRecId : serviceTerritoryIds) {
                    if (!retVals.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                for (GDMFSL_Profit_Center__c pc : [
                        SELECT Id,
                                GDMFSL_Discipline__c,
                                GDMFSL_Service_Territory__c,
                                GDMFSL_Sales_Organization__c
                        FROM GDMFSL_Profit_Center__c
                        WHERE GDMFSL_Service_Territory__c IN :newRecIds
                ]) {

                    if (!retVals.containsKey(pc.GDMFSL_Service_Territory__c)) {
                        retVals.put(pc.GDMFSL_Service_Territory__c, new Map<Id, GDMFSL_Profit_Center__c>());
                    }

                    if (!retVals.get(pc.GDMFSL_Service_Territory__c).containsKey(pc.GDMFSL_Discipline__c)) {
                        retVals.get(pc.GDMFSL_Service_Territory__c).put(pc.GDMFSL_Discipline__c, pc);
                    }
                }

                System.debug('Retrieved Profit Centers: ' + retVals);
            }
        }

        return retVals;
    }
}