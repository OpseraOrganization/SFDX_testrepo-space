/**
 * Name       :    GDMFSL_SLAProcessor
 * Purpose    :    Business Logic for SLA object . See method descriptions for proper context for calling each method
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Udbhav                  2020-Sep-11    Created
 **/
public without sharing class GDMFSL_SLAProcessor {

    private static Map<Id, List<GDMFSL_SLA__c>> retVals = new Map<Id, List<GDMFSL_SLA__c>>();

    /**
     * Method to get AssociatedContract Fields
     *
     * @param relatedIds
     * @param idSObjectType
     *
     * @return Map of Id and lsit od SLA
     **/
    public static Map<Id, List<GDMFSL_SLA__c>> getRecords(Set<Id> relatedIds, SObjectType idSObjectType) {

        System.debug('GDMFSL_SLAProcessor.getRecords()');
        System.debug('given IDs: ' + relatedIds);

        if (relatedIds != null && !relatedIds.isEmpty()) {

            Set<Id> moreIdsToGet = new Set<Id>();

            if (retVals.isEmpty()){
                moreIdsToGet.addAll(relatedIds);
            } else {
                for (Id checkId : relatedIds) {
                    if (!retVals.containsKey(checkId)) {
                        moreIdsToGet.add(checkId);
                    }
                }
            }

            System.debug('More IDs to get: ' + moreIdsToGet);

            if (!moreIdsToGet.isEmpty()) {

                if (idSObjectType == ContractLineItem.SObjectType) {

                    System.debug('Getting SLA based on CLI');

                    for (GDMFSL_SLA__c sla : [
                            SELECT Id,GDMFSL_Priority__c, GDMFSL_Resolution_Time__c,
                                    GDMFSL_Response_Time__c, GDMFSL_Arrival_Time__c,
                                    GDMFSL_Associated_Contract__c, GDMFSL_Contract_Line_Item__c
                            FROM
                                    GDMFSL_SLA__c
                            WHERE GDMFSL_Contract_Line_Item__c IN :relatedIds
                    ]) {

                        if (!retVals.containsKey(sla.GDMFSL_Contract_Line_Item__c)) {
                            retVals.put(sla.GDMFSL_Contract_Line_Item__c, new List<GDMFSL_SLA__c>());
                        }

                        retVals.get(sla.GDMFSL_Contract_Line_Item__c).add(sla);
                    }

                } else if (idSObjectType == GDMFSL_Associated_Contract__c.SObjectType) {

                    System.debug('Getting SLA based on Associated Contract');

                    for (GDMFSL_SLA__c sla : [
                            SELECT Id,GDMFSL_Priority__c, GDMFSL_Resolution_Time__c,
                                    GDMFSL_Response_Time__c, GDMFSL_Arrival_Time__c,
                                    GDMFSL_Associated_Contract__c, GDMFSL_Contract_Line_Item__c
                            FROM GDMFSL_SLA__c
                            WHERE GDMFSL_Associated_Contract__c IN :relatedIds
                    ]) {

                        if (!retVals.containsKey(sla.GDMFSL_Associated_Contract__c)) {
                            retVals.put(sla.GDMFSL_Associated_Contract__c, new List<GDMFSL_SLA__c>());
                        }

                        retVals.get(sla.GDMFSL_Associated_Contract__c).add(sla);
                    }
                }
            }
        }

        System.debug('Returning this many SLAs: ' + retVals.size());

        return retVals;
    }

}