/*******************************************************************************************
Name       :    GDMFSL_AssociatedContractProcessor
Purpose    :    Business Logic for AssociatedContract object . See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Sep-09    Created
**********************************************************************************************/

public without sharing class GDMFSL_AssociatedContractProcessor {

    private static Map<Id, GDMFSL_Associated_Contract__c> retVals = new Map<Id, GDMFSL_Associated_Contract__c>();
    private static Set<Id> prevServContractIds = new Set<Id>();
    private static Set<Id> prevLocationIds = new Set<Id>();

    public static Map<Id, GDMFSL_Associated_Contract__c> getRecords(Set<Id> serviceContractIds, Set<Id> locationIds) {

        if ((serviceContractIds != null && !serviceContractIds.isEmpty())
                || (locationIds != null && !locationIds.isEmpty())) {

            Set<Id> theServContIds = new Set<Id>();
            Set<Id> theLocIds = new Set<Id>();

            if (retVals.isEmpty()) {
                theServContIds.addAll(serviceContractIds);
                theLocIds.addAll(locationIds);
            } else {

                if (serviceContractIds != null){
                    for (Id thisSCId : serviceContractIds) {
                        if (!prevServContractIds.contains(thisSCId)) {
                            theServContIds.add(thisSCId);
                        }
                    }
                }

                if (locationIds != null) {
                    for (Id thisLocId : locationIds) {
                        if (!prevLocationIds.contains(thisLocId)) {
                            theLocIds.add(thisLocId);
                        }
                    }
                }
            }

            if (!theServContIds.isEmpty() || !theLocIds.isEmpty()) {

                for (GDMFSL_Associated_Contract__c theRec : [
                        SELECT Id,
                                GDMFSL_Min_Charge_Time__c,
                                Service_Contract__c,
                                Location__c,
                                Service_Contract__r.GDMFSL_24HrCoverage_BusinessDays__c,
                                Service_Contract__r.GDMFSL_After_Hr_Reactive_Response__c,
                                Service_Contract__r.GDMFSL_X24hr_Reactive_Response__c,
                                Service_Contract__r.GDMFSL_HolidayNoReactiveCoverage__c,
                                Service_Contract__r.GDMFSL_Office_Hr_Reactive_Response__c,
                        (SELECT Id,
                                GDMFSL_Preference_Type__c,
                                GDMFSL_Service_Resource__c
                        FROM GDMFSL_Service_Contract_Resource_Pref__r
                        WHERE GDMFSL_Service_Resource__r.IsActive = TRUE
                        AND GDMFSL_Service_Resource__r.ResourceType != 'D'
                        )
                        FROM GDMFSL_Associated_Contract__c
                        WHERE Service_Contract__c IN :serviceContractIds
                        AND Location__c IN :locationIds
                ]){

                    prevServContractIds.add(theRec.Service_Contract__c);
                    prevLocationIds.add(theRec.Location__c);

                    retVals.put(theRec.Id, theRec);
                    System.debug('Retrieved AgreementLevel: ' + theRec);
                }
            }
        }

        return retVals;
    }
}