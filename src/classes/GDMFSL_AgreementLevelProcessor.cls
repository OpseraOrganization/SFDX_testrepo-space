/**
 * Name       :    GDMFSL_AgreementLevelProcessor
 * Purpose    :    Wrapper class to encapsulate Agreement Level data
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Udbhav                  2020-Oct-14    Created
 **/

public without sharing class GDMFSL_AgreementLevelProcessor {


    private static Map<Id, GDMFSL_Agreement_Level__c> retVals = new Map<Id, GDMFSL_Agreement_Level__c>();

    /**
     * Method to get Agreement Level Fields
     *
     * @param AgreementLevelIds Set of Ids for AgreementLevel
     *
     * @return Map of Id and Record for Agreement Level
     **/
    public static Map<Id, GDMFSL_Agreement_Level__c> getRecords(Set<Id> recIds) {

        System.debug('Agreement Level Ids Passed: ' + recIds);

        if (recIds != null && !recIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (retVals.isEmpty()) {
                newRecIds.addAll(recIds);
            } else {
                for (Id thisRecId : recIds) {
                    if (!retVals.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                Map<Id, GDMFSL_Agreement_Level__c> theRecs = new Map<Id, GDMFSL_Agreement_Level__c>([
                        SELECT Id,
                                Name,
                                GDMFSL_24hr_Reactive_Coverage__c,
                                GDMFSL_After_Hr_Reactive_Coverage__c,
                                GDMFSL_Connected_Digital_Services__c,
                                GDMFSL_SLA_Guarantee_Financial_Penalty__c,
                                GDMFSL_Office_Hr_Reactive_Coverage__c,
                                GDMFSL_Parts_Replacement_Management__c,
                                GDMFSL_PO_Number_Reactive_Coverage__c,
                                GDMFSL_Preventative_Maintenance__c,
                                GDMFSL_Reactive_Work_Chargeable__c,
                                GDMFSL_Reactive_Work_Not_Chargeable__c,
                                GDMFSL_Site_Resident_Labour_Present__c,
                                GDMFSL_Software_Assurance__c,
                                GDMFSL_Tech_Phone_Support__c,
                                GDMFSL_Third_Party_Support__c,
                                GDMFSL_Warranty_Services__c,
                                GDMFSL_DigitalServices_OTS__c,
                                GDMFSL_DigitalServices_CS__c,
                                GDMFSL_RemoteSupport_SH__c,
                                GDMFSL_RemoteSupport_AM__c,
                                GDMFSL_RemoteSupport_BO__c,
                                GDMFSL_ReactiveWork_Chargeable_L__c,
                                GDMFSL_RemoteReactiveWork_Chargeable_L__c,
                                GDMFSL_RemoteReactiveWork_NotChargeable__c,
                                GDMFSL_HolidayNoReactiveCoverage__c,
                                GDMFSL_24HrCoverage_BusinessDays__c,
                                GDMFSL_PartsStockManagement__c,
                                GDMFSL_PartsReplacementManagement_L__c

                        FROM GDMFSL_Agreement_Level__c
                        WHERE Id IN :newRecIds

                ]);

                retVals.putAll(theRecs);
                System.debug('Retrieved AgreementLevel: ' + retVals);
            }
        }

        return retVals;
    }

}