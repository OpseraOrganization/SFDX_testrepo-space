/**
 * Name       :    GDMFSL_SourceSystemProcessor
 * Purpose    :    Processor Logic for SourceSystem object . See method descriptions for proper context for calling each method
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Udbhav                  2021-02-04    Created
 **/
public without sharing class GDMFSL_SourceSystemProcessor {


    private static Map<Id, List<Id>> mapSSIdsToRelatedWOIds = new Map<Id, List<Id>>();
    private static Map<String, Source_System__c> srcSystemByCompanyNumber = new Map<String, Source_System__c>();

    public static Map<String, Source_System__c> getSourceSystemByCompanyNumber(Set<String> compNumbers) {

        if (compNumbers != null && !compNumbers.isEmpty()) {

            Set<String> newCompNums = new Set<String>();

            if (srcSystemByCompanyNumber.isEmpty()) {
                newCompNums.addAll(compNumbers);
            } else {
                for (String thisCompNum : compNumbers) {
                    if (!srcSystemByCompanyNumber.containsKey(thisCompNum)) {
                        newCompNums.add(thisCompNum);
                    }
                }
            }

            if (!newCompNums.isEmpty()) {

                for (Source_System__c theSS : [
                        SELECT Id, Source_System_Company_Id__c, CurrencyIsoCode
                        FROM Source_System__c
                        WHERE Source_System_Company_Id__c IN :newCompNums
                ]) {

                    srcSystemByCompanyNumber.put(theSS.Source_System_Company_Id__c, theSS);
                }
            }

            System.debug('Retrieved SourceSystems by Compnay Number: ' + srcSystemByCompanyNumber);
        }

        return srcSystemByCompanyNumber;
    }

    public static Map<Id, List<Id>> getSourceSystemWOIds(Set<Id> ssIds) {

        if (ssIds != null && !ssIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (mapSSIdsToRelatedWOIds.isEmpty()) {
                newRecIds.addAll(ssIds);
            } else {
                for (Id thisRecId : ssIds) {
                    if (!mapSSIdsToRelatedWOIds.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                Map<Id, Source_System__c> mapSSToIds = new Map<Id, Source_System__c>([
                        SELECT Id, (
                                SELECT Id,
                                        Status
                                FROM Work_Orders_SoldTo__r
                        )
                        FROM Source_System__c
                        WHERE Id IN :newRecIds
                ]);

                for (Source_System__c ss : mapSSToIds.values()) {
                    for (WorkOrder wo : ss.Work_Orders_SoldTo__r) {
                        if (!mapSSIdsToRelatedWOIds.containsKey(ss.Id)) {
                            mapSSIdsToRelatedWOIds.put(ss.Id, new List<Id>());
                        }

                        mapSSIdsToRelatedWOIds.get(ss.Id).add(wo.Id);
                    }
                }

            }

            System.debug('Retrieved Map of SourceSystem With Related WO : ' + mapSSIdsToRelatedWOIds);
        }


        return mapSSIdsToRelatedWOIds;
    }

    public static void checkWOsRelatedToBlockedSourceSystem(List<Source_System__c> newRecs, Map<Id, Source_System__c> oldMapRecs) {

        Set<Id> toBeUsedSourceSystemIds = new Set<Id>();
        Map<Id, List<Id>> mapSourceSystemIdsToWOIds = new Map<Id, List<Id>>();
        Set<Id> toBeCheckedWOIdsForUnSchedule = new Set<Id>();

        if (newRecs != null) {
            for (Source_System__c ss : newRecs) {

                if ((oldMapRecs == null || ((ss.GDMFSL_Delivery_Block__c != oldMapRecs.get(ss.Id).GDMFSL_Delivery_Block__c) ||
                        (ss.Customer_Order_Block__c != oldMapRecs.get(ss.Id).Customer_Order_Block__c))) &&
                        (ss.GDMFSL_Delivery_Block__c || ss.Customer_Order_Block__c)) {
                    System.debug('Source System got updated with Customer or Delivery Block set as TRUE :' + ss.Name);
                    toBeUsedSourceSystemIds.add(ss.Id);
                }
            }

        }
        if (!toBeUsedSourceSystemIds.isEmpty()) {
            mapSourceSystemIdsToWOIds = getSourceSystemWOIds(toBeUsedSourceSystemIds);
        }
        if (!mapSourceSystemIdsToWOIds.isEmpty()) {
            for (Id ssId : mapSourceSystemIdsToWOIds.keySet()) {
                toBeCheckedWOIdsForUnSchedule.addAll(mapSourceSystemIdsToWOIds.get(ssId));
            }

            System.debug('Number of SAs to be checked if Eligible for UnSchedule : ' + toBeCheckedWOIdsForUnSchedule.size());
            GDMFSL_WorkOrderProcessor.checkIfWOCanBeUnscheduledAlongWithSA(toBeCheckedWOIdsForUnSchedule);

        }


    }
}