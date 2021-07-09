/*******************************************************************************************
Name       :    GDMFSL_MaintenancePlanProcessor
Purpose    :    Processor Logic for MaintenancePlan object . See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Sep-16    Created
**********************************************************************************************/

public without sharing class GDMFSL_MaintenancePlanProcessor {

    @TestVisible
    private static final String WORKORDERGENERATIONCOMPLETESTATUS = 'Complete';

    private static Map<Id, MaintenancePlan> retMaintPlans = new Map<Id, MaintenancePlan>();
    private static Map<Id, MaintenanceWorkRule> retMaintWorkRules = new Map<Id, MaintenanceWorkRule>();

    public static Map<Id, MaintenancePlan> getRecords(Set<Id> recIds) {

        System.debug('Maintenance Plan Ids Passed: ' + recIds);

        if (recIds != null && !recIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (retMaintPlans.isEmpty()) {
                newRecIds.addAll(recIds);
            } else {
                for (Id thisRecId : recIds) {
                    if (!retMaintPlans.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                Map<Id, MaintenancePlan> theRecs = new Map<Id, MaintenancePlan>([
                        SELECT Id, MaintenanceWindowStartDays, MaintenanceWindowEndDays,
                                WorkOrderGenerationMethod,
                                Location.GDMFSL_Service_Territory__r.OperatingHours.TimeZone
                        FROM MaintenancePlan
                        WHERE Id IN :newRecIds

                ]);

                retMaintPlans.putAll(theRecs);
                System.debug('Retrieved Maintenance Plan: ' + retMaintPlans);
            }
        }

        return retMaintPlans;
    }

    public static Map<Id, MaintenanceWorkRule> getMaintWorkRuleRecords(Set<Id> recIds) {

        System.debug('Maintenance WorkRule Ids: ' + recIds);

        if (recIds != null && !recIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (retMaintWorkRules.isEmpty()) {
                newRecIds.addAll(recIds);
            } else {
                for (Id thisRecId : recIds) {
                    if (!retMaintWorkRules.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                Map<Id, MaintenanceWorkRule> theRecs = new Map<Id, MaintenanceWorkRule>([
                        SELECT Id, RecurrencePattern
                        FROM MaintenanceWorkRule
                        WHERE Id IN :newRecIds

                ]);

                retMaintWorkRules.putAll(theRecs);
                System.debug('Retrieved Maintenance WorkRule: ' + retMaintWorkRules);
            }
        }

        return retMaintWorkRules;
    }


    public static void updateMaintenancePlanfromSC(Map<Id, ServiceContract> serviceContractMap) {

        System.debug('updateMaintenancePlanfromSC()');

        if (serviceContractMap != null && !serviceContractMap.isEmpty()) {

            System.debug('Have this many ServContracts: ' + serviceContractMap.size());

            List<MaintenancePlan> mPlansToBeUpdated = new List<MaintenancePlan>();

            for (MaintenancePlan mp : [
                    SELECT
                            StartDate,
                            EndDate,
                            Id,
                            ServiceContractId
                    FROM MaintenancePlan
                    WHERE
                            ServiceContractId IN :serviceContractMap.keySet()
            ]) {

                System.debug('Checking MPlan: ' + mp.Id);
                System.debug('For ServContract: ' + mp.ServiceContractId);

                if (mp.StartDate < serviceContractMap.get(mp.ServiceContractId).EndDate) {
                    System.debug('Setting MPlan EndDate to ServContractEndDate: ' + serviceContractMap.get(mp.ServiceContractId).EndDate);
                    mp.EndDate = serviceContractMap.get(mp.ServiceContractId).EndDate;
                    mPlansToBeUpdated.add(mp);
                }
            }

            if (!mPlansToBeUpdated.isEmpty()) {
                GDMFSL_CommonUtilities.updateRecords(mPlansToBeUpdated);
            }
        }
    }


    public static void createMaintenanceWorkRules(List<MaintenanceAsset> theMAs) {

        if (theMAs != null && !theMAs.isEmpty()) {

            System.debug('Need to create Maint Work Rules based on Monthly Asset_Maintenance_Frequency');

            Set<Id> theAssetIds = new Set<Id>();

            for (MaintenanceAsset theMA : theMAs) {
                theAssetIds.add(theMA.AssetId);
            }

            Map<Id, List<GDMFSL_Asset_Maintenance_Frequency__c>> assetIdToAFMS = GDMFSL_AssetMaintenance.getAssetMaintFrequencyRecords(theAssetIds);

            List<MaintenanceWorkRule> maintWorkRulesToCreate = new List<MaintenanceWorkRule>();

            for (MaintenanceAsset theMA : theMAs) {

                System.debug('Checking for AFMS for Maintenance Asset: ' + theMA.Id);
                System.debug('Asset: ' + theMA.AssetId);

                if (assetIdToAFMS.containsKey(theMA.AssetId)) {

                    for (GDMFSL_Asset_Maintenance_Frequency__c thisAFM : assetIdToAFMS.get(theMA.AssetId)) {

                        System.debug('Found AFM: ' + thisAFM.Id);

                        if (thisAFM.GDMFSL_Frequency_Type__c == 'Monthly' || thisAFM.GDMFSL_Frequency_Type__c == 'Yearly') {

                            System.debug('It is Monthly or Yearly so we need to create a Maint Work Rule');
                            maintWorkRulesToCreate.add(new MaintenanceWorkRule(
                                    Title = thisAFM.Name,
                                    ParentMaintenanceRecordId = theMA.Id,
                                    WorkTypeId = thisAFM.GDMFSL_Work_Type__c,
                                    SortOrder = (Integer) thisAFM.GDMFSL_Sort_Order__c,
                                    NextSuggestedMaintenanceDate = thisAFM.GDMFSL_Date_of_First_Work_Order__c,
                                    RecurrencePattern = thisAFM.GDMFSL_RRULE_Template__c

                            ));
                        }
                    }
                }

            }

            System.debug('Have this many Maintenance Work Rules to create: ' + maintWorkRulesToCreate.size());

            if (!maintWorkRulesToCreate.isEmpty()) {
                GDMFSL_CommonUtilities.insertRecords(maintWorkRulesToCreate);
                System.debug('After Maintenance Work Rules Inserted');
            }
        }
    }

    public static void processWOGenerationCompleted(List<MaintenancePlan> newRecs, Map<Id, MaintenancePlan> oldRecsMap) {

        System.debug('Checking MaintPlans to see if WO Generation has just completed');

        if (newRecs != null && !newRecs.isEmpty()) {

            Set<Id> maintPlanIdsForRequiredAssistWOs = new Set<Id>();
            Set<Id> maintPlanIdsForWOUpdates = new Set<Id>();

            for (MaintenancePlan theMP : newRecs) {

                if (theMP.WorkOrderGenerationStatus == WORKORDERGENERATIONCOMPLETESTATUS
                        && theMP.WorkOrderGenerationStatus != oldRecsMap.get(theMP.Id).WorkOrderGenerationStatus) {

                    System.debug('Maint Plan just had WO Gen Complete: ' + theMP.Id);

                    maintPlanIdsForWOUpdates.add(theMP.Id);

                    if (theMP.GDMFSL_Requires_Assistant__c){
                        System.debug('Maint Plan Req Assist: ' + theMP.Id);
                        maintPlanIdsForRequiredAssistWOs.add(theMP.Id);
                    }
                }
            }

            if (!maintPlanIdsForWOUpdates.isEmpty()) {
                GDMFSL_WorkOrderLIProcessor.addWOLIRelatedRecordsToMaintPlanWOs(maintPlanIdsForWOUpdates);
            }

            if (!maintPlanIdsForRequiredAssistWOs.isEmpty()) {
                GDMFSL_WorkOrderProcessor.createRequireAssistWOs(maintPlanIdsForRequiredAssistWOs);
            }
        }
    }

}