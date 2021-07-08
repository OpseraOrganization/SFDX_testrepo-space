/**
 * Name       :    GDMFSL_WorkOrderLIProcessor
 * Purpose    :    WorkOrderLineItem processing class
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * JMay                  2020-Sep-25    Created
 **/
public inherited sharing class GDMFSL_WorkOrderLIProcessor implements Queueable {


    public static final String PMWORKTYPECATEGORY = 'PM';

    private static final Map<String, String> WOLIFIELDSTOWO = new Map<String, String>{

            'SuggestedMaintenanceDate' => 'SuggestedMaintenanceDate',
            'MaintenancePlanId' => 'MaintenancePlanId',
            'LocationId' => 'LocationId',
            'AssetId' => 'AssetId',
            'WorkTypeId' => 'WorkTypeId'
    };

    @TestVisible
    private enum WOGenerationMethod {WOLIPerAsset}

    @TestVisible
    private static final Map<WOGenerationMethod, String> WOGENERATIONMETHODTOVALUE = new Map<WOGenerationMethod, String>{

        WOGenerationMethod.WOLIPerAsset => 'WorkOrderLineItemPerAsset'
    };

    private static Map<Id, WorkOrderLineItem> theWOLIRecords = new Map<Id, WorkOrderLineItem>();

    @TestVisible
    private Map<Id, List<WorkOrderLineItem>> mapWOIdToWOLI = new Map<Id, List<WorkOrderLineItem>>();

    public GDMFSL_WorkOrderLIProcessor(Map<Id, List<WorkOrderLineItem>> submittedIdToWOLI) {
        mapWOIdToWOLI.putAll(submittedIdToWOLI);
    }

    public void execute(QueueableContext qc) {

        System.debug('Size of Map to be executed: ' + mapWOIdToWOLI.size());

        for (Id thisWOId : mapWOIdToWOLI.keySet()) {
            GDMFSL_WorkOrderLIProcessor.setWorkPlanWorkStepsOnWOLI(mapWOIdToWOLI.get(thisWOId));
            mapWOIdToWOLI.remove(thisWOId);
            break;
        }

        if (!mapWOIdToWOLI.isEmpty() && !Test.isRunningTest()) {
            GDMFSL_WorkOrderLIProcessor generateWP = new GDMFSL_WorkOrderLIProcessor(mapWOIdToWOLI);
            Id jobId = System.enqueueJob(generateWP);
            System.debug('Job Id being sent to Queue : ' + jobId);
        }
    }

    public static void setFields(List<WorkOrderLineItem> theWOLIs) {
        setServiceReportTemplateId(theWOLIs);
    }

    public static void createWOLIForWOs(List<WorkOrder> theWOs, Map<Id, WorkOrder> oldRecs) {

        if (theWOs != null && !theWOs.isEmpty()) {

            System.debug('Have WOs to consider for WOLI auto-creation');

            Set<Id> maintPlanIdsNeeded = new Set<Id>();

            System.debug('Skip any WOs that are created by MaintPlans where WOGeneration is 1 WOLI Per Asset (wolis will be auto-created)');

            for (WorkOrder theWO : theWOs) {

                if (GDMFSL_WorkOrderProcessor.woCanBeProcessed(theWO)
                        && theWO.WorkTypeId != null
                        && theWO.MaintenancePlanId != null
                        && !theWO.GDMFSL_Created_by_WO_Merge_Process__c
                        && (oldRecs == null || oldRecs.get(theWO.Id).WorkTypeId == null)) {

                    maintPlanIdsNeeded.add(theWO.MaintenancePlanId);
                }
            }

            Map<Id, MaintenancePlan> maintPlans = GDMFSL_MaintenancePlanProcessor.getRecords(maintPlanIdsNeeded);

            List<WorkOrder> wosToUse = new List<WorkOrder>();

            for (WorkOrder theWO : theWOs) {

                if (GDMFSL_WorkOrderProcessor.woCanBeProcessed(theWO)
                        && theWO.WorkTypeId != null
                        && !theWO.GDMFSL_Created_by_WO_Merge_Process__c
                        && (oldRecs == null || oldRecs.get(theWO.Id).WorkTypeId == null)) {

                    if (theWO.MaintenancePlanId == null
                            || (maintPlans.containsKey(theWO.MaintenancePlanId)
                                    && maintPlans.get(theWO.MaintenancePlanId).WorkOrderGenerationMethod != WOGENERATIONMETHODTOVALUE.get(WOGenerationMethod.WOLIPerAsset))){

                        System.debug('MaintPlan is not auto-generating WOLIs, we need to for WO: ' + theWO.Id);
                        wosToUse.add(theWO);
                    }
                }
            }

            List<WorkOrderLineItem> woliToCreate = new List<WorkOrderLineItem>();

            for (WorkOrder theWO : wosToUse) {

                System.debug('Creating WOLI for WO: ' + theWO.Id);
                WorkOrderLineItem newWOLI = new WorkOrderLineItem();
                newWOLI.WorkOrderId = theWO.Id;
                for (String woliFieldName : WOLIFIELDSTOWO.keySet()) {
                    System.debug('WOLI Field : Value ' + woliFieldName + ' : ' + theWO.get(WOLIFIELDSTOWO.get(woliFieldName)));
                    newWOLI.put(woliFieldName, theWO.get(WOLIFIELDSTOWO.get(woliFieldName)));
                }
                woliToCreate.add(newWOLI);

            }

            System.debug('WOLIs to create: ' + woliToCreate.size());

            if (!woliToCreate.isEmpty()) {
                GDMFSL_CommonUtilities.insertRecords(woliToCreate);
            }
        }
    }

    public static void deriveWorkPlansAndStepsOnWOLI(List<WorkOrderLineItem> theWOLIs, Map<Id, WorkOrderLineItem> oldMWorkOrderLineItemsByIds) {

        List<WorkOrderLineItem> toBeUsedWOLIs = new List<WorkOrderLineItem>();
        for (WorkOrderLineItem woli : theWOLIs) {
            if (oldMWorkOrderLineItemsByIds == null || (oldMWorkOrderLineItemsByIds.containsKey(woli.Id) && oldMWorkOrderLineItemsByIds.get(woli.Id).AssetId != woli.AssetId)) {
                System.debug('WOLI got created or Asset on the WOLI was updated');
                toBeUsedWOLIs.add(woli);
            }
        }
        System.debug('Total WOLIs to be worked upon : ' + toBeUsedWOLIs.size());

        Map<Id, List<WorkOrderLineItem>> mapWOIdToWOLI = new Map<Id, List<WorkOrderLineItem>>();

        for (WorkOrderLineItem woli : toBeUsedWOLIs) {
            if (!mapWOIdToWOLI.containsKey(woli.WorkOrderId)) {
                mapWOIdToWOLI.put(woli.WorkOrderId, new List<WorkOrderLineItem>());
            }
            mapWOIdToWOLI.get(woli.WorkOrderId).add(woli);
        }
        System.debug('Number of WO with related WOLIs :' + mapWOIdToWOLI.size());

        if (!mapWOIdToWOLI.isEmpty()) {
            System.debug('Calling the Queue to execute the derivation');
            GDMFSL_WorkOrderLIProcessor generateWP = new GDMFSL_WorkOrderLIProcessor(mapWOIdToWOLI);
            Id JobId = System.enqueueJob(generateWP);
            System.debug('Job in Queue with Id : ' + JobId);
        }
    }

    @TestVisible
    private static void setServiceReportTemplateId(List<WorkOrderLineItem> theWOLIs) {

        Set<Id> workTypeIds = new Set<Id>();

        for (WorkOrderLineItem woli : theWOLIs) {
            if (woli.WorkTypeId != null) {
                workTypeIds.add(woli.WorkTypeId);
            }
        }

        if (!workTypeIds.isEmpty()) {

            Map<Id, WorkType> mapWorkType = GDMFSL_WorkTypeProcessor.getRecords(workTypeIds);

            for (WorkOrderLineItem woli : theWOLIs) {

                if (mapWorkType.containsKey(woli.WorkTypeId)) {

                    System.debug('WOLI ServiceReportTemplateId set to: ' + mapWorkType.get(woli.WorkTypeId).ServiceReportTemplateId);
                    woli.ServiceReportTemplateId = mapWorkType.get(woli.WorkTypeId).ServiceReportTemplateId;
                }
            }
        }
    }

    @TestVisible
    private static Map<Id, WorkPlanSelectionRule> fetchWOLIWorkPlanSelectionRule(List<WorkOrderLineItem> theWOLIs) {

        List<WorkOrderLineItem> tobeUsedWOLI = new List<WorkOrderLineItem>();

        Set<Id> assetIds = new Set<Id>();
        Set<Id> workTypesIds = new Set<Id>();
        Set<Id> serviceTerritoryIds = new Set<Id>();
        Set<Id> workOrderIds = new Set<Id>();

        for (WorkOrderLineItem woli : theWOLIs) {

            if (woli.GDMFSL_Created_From_Mobile__c == false) {

                tobeUsedWOLI.add(woli);

                if (woli.AssetId != null) {
                    assetIds.add(woli.AssetId);
                }

                if (woli.ServiceTerritoryId != null) {
                    serviceTerritoryIds.add(woli.ServiceTerritoryId);
                }

                if (woli.WorkTypeId != null) {
                    workTypesIds.add(woli.WorkTypeId);
                }

                if (woli.WorkOrderId != null) {
                    workOrderIds.add(woli.WorkOrderId);
                }
            }
        }

        Set<Id> productIds = new Set<Id>();

        if (assetIds.size() > 0) {

            Map<Id, Asset> mapAssets = GDMFSL_AssetProcessor.getRecords(assetIds);

            for (Id theAssetId : assetIds) {

                if (mapAssets.containsKey(theAssetId) && mapAssets.get(theAssetId).Product2Id != null) {
                    productIds.add(mapAssets.get(theAssetId).Product2Id);
                }
            }
        }

        Set<Id> serviceContractIds = new Set<Id>();

        if (workOrderIds.size() > 0) {

            Map<Id, WorkOrder> mapWorkOrder = GDMFSL_WorkOrderProcessor.getRecords(workOrderIds);
            System.debug('Map of WorOrders retrieved  : ' + mapWorkOrder.size());

            for (Id theWOId : workOrderIds) {

                if (mapWorkOrder.containsKey(theWOId) && mapWorkOrder.get(theWOId).ServiceContractId != null) {
                    serviceContractIds.add(mapWorkOrder.get(theWOId).ServiceContractId);
                }
            }
        }

        return GDMFSL_WorkPlanSelectionRuleProcessor.getRecords(serviceTerritoryIds, serviceContractIds, workTypesIds, productIds);
    }

    public static void setWorkPlanWorkStepsOnWOLI(List<WorkOrderLineItem> theWOLIs) {


        if (theWOLIs != null && !theWOLIs.isEmpty()) {

            System.debug('Fetching WOLI related Work Plan Selection Rule');

            Map<Id, WorkPlanSelectionRule> mapWorkPlanSelectionRule = fetchWOLIWorkPlanSelectionRule(theWOLIs);

            if (!mapWorkPlanSelectionRule.isEmpty()) {

                Set<Id> workPlanTemplateIds = new Set<Id>();
                Map<Id, Set<Id>> mapWOLI_WPlanTemplateIDs = new Map<Id, Set<Id>>();

                for (WorkOrderLineItem woli : theWOLIs) {

                    mapWOLI_WPlanTemplateIDs.put(woli.Id, getWOLIRelatedWorkPlanTemplateIds(woli));

                    for (Id wpTId : mapWOLI_WPlanTemplateIDs.get(woli.Id)) {
                        workPlanTemplateIds.add(wpTId);
                    }
                }

                Map<Id, WorkPlanTemplate> mapWorkPlanTemplate = GDMFSL_WorkPlanTemplateProcessor.getRecords(workPlanTemplateIds);

                System.debug('Count of WorkPlans templates retrieved related to WOLIs: ' + mapWorkPlanTemplate.size());

                Map<Id, List<Id>> mapWorkPlanTemplateIdToWorkStepTemplateIds = new Map<Id, List<Id>>();
                Map<Id, Map<Id, WorkPlanTemplateEntry>> mapWorkPlanTempIdToWorkStepTemplateIdToWorkPlanEntry = new Map<Id, Map<Id, WorkPlanTemplateEntry>>();
                Set<Id> workStepTemplateIds = new Set<Id>();

                for (WorkPlanTemplate wpt : mapWorkPlanTemplate.values()) {

                    System.debug('Count of associated WorkSteps: ' + wpt.WorkStepTemplates.size());

                    if (wpt.WorkStepTemplates.size() > 0) {

                        for (WorkPlanTemplateEntry wpTE : wpt.WorkStepTemplates) {

                            workStepTemplateIds.add(wpTE.WorkStepTemplateId);

                            if (!mapWorkPlanTemplateIdToWorkStepTemplateIds.containsKey(wpt.Id)) {
                                mapWorkPlanTemplateIdToWorkStepTemplateIds.put(wpt.Id, new List<Id>());
                            }

                            mapWorkPlanTemplateIdToWorkStepTemplateIds.get(wpt.Id).add(wpTE.WorkStepTemplateId);
                            if (!mapWorkPlanTempIdToWorkStepTemplateIdToWorkPlanEntry.containsKey(wpt.Id)) {
                                mapWorkPlanTempIdToWorkStepTemplateIdToWorkPlanEntry.put(wpt.Id, new Map<Id, WorkPlanTemplateEntry>());
                            }
                            mapWorkPlanTempIdToWorkStepTemplateIdToWorkPlanEntry.get(wpt.Id).put(wpTE.WorkStepTemplateId, wpTE);
                        }
                    }

                    System.debug('Map of related WorkStep Template to WPTemplate Ids ' + mapWorkPlanTemplateIdToWorkStepTemplateIds);
                    System.debug('WOLI : Count of Fetched WorkStepTemplate Ids from Related Work Plan templates : ' + wpt.Id + ' : ' + workStepTemplateIds.size());
                }

                List<WorkPlan> newWPs = new List<WorkPlan>();
                Map<Id, Map<Id, WorkPlan>> mapWOLIIdToMapWPTemplateIdToWP = new Map<Id, Map<Id, WorkPlan>>();
                Map<Id, List<WorkPlan>> mapWOLIRelatedWorkPlans = new Map<Id, List<WorkPlan>>();

                for (WorkOrderLineItem woli : theWOLIs) {

                    if (mapWOLI_WPlanTemplateIDs.containsKey(woli.Id)) {

                        System.debug('Count of WorkPlansTemplates associated with WOLI : ' + woli.Id + ' : ' + mapWOLI_WPlanTemplateIDs.get(woli.Id).size());

                        for (Id workPlanTId : mapWOLI_WPlanTemplateIDs.get(woli.Id)) {

                            if (mapWorkPlanTemplate.containsKey(workPlanTId)
                                    && mapWorkPlanTemplate.get(workPlanTId).IsActive == true) {

                                System.debug('Found active WorkPlanTemplate for WOLI : ' + woli.LineItemNumber);

                                WorkPlan newWPlan = GDMFSL_WorkPlanTemplateProcessor.createWOWorkPlanFromWorkPlanTemplate(mapWorkPlanTemplate.get(workPlanTId), woli.WorkOrderId, woli.Id);

                                if (!mapWOLIIdToMapWPTemplateIdToWP.containsKey(woli.Id)) {
                                    mapWOLIIdToMapWPTemplateIdToWP.put(woli.Id, new Map<Id, WorkPlan>());
                                }
                                mapWOLIIdToMapWPTemplateIdToWP.get(woli.Id).put(mapWorkPlanTemplate.get(workPlanTId).Id, newWPlan);
                                newWPs.add(newWPlan);
                                System.debug('Map of WOLI Id to Map of WP Template Id to WorkPlan : ' + mapWOLIIdToMapWPTemplateIdToWP);


                                if (!mapWOLIRelatedWorkPlans.containsKey(woli.Id)) {
                                    mapWOLIRelatedWorkPlans.put(woli.Id, new List<WorkPlan>());
                                }

                                mapWOLIRelatedWorkPlans.get(woli.Id).add(newWPlan);

                                System.debug('WOLI and its associated WorkPlan : ' + mapWOLIRelatedWorkPlans);
                            }
                        }
                    }
                }


                if (newWPs.size() > 0) {

                    System.debug('WOLI : Count of New Work Plans to create: ' + newWPs.size());

                    GDMFSL_CommonUtilities.insertRecords(newWPs, false, true);
                    System.debug('Work Plans inserted : ' + newWPs);

                    Map<Id, WorkStepTemplate> mapWorkStepTemplate = new Map<Id, WorkStepTemplate>();

                    if (workStepTemplateIds.size() > 0) {
                        mapWorkStepTemplate = GDMFSL_WorkStepTemplateProcessor.getRecords(workStepTemplateIds);
                    }

                    List<WorkStep> newWSs = new List<WorkStep>();

                    for (WorkOrderLineItem woli : theWOLIs) {

                        if (mapWOLI_WPlanTemplateIDs.containsKey(woli.Id) && mapWOLIRelatedWorkPlans.containsKey(woli.Id)) {

                            for (Id workPlanTId : mapWOLI_WPlanTemplateIDs.get(woli.Id)) {

                                System.debug('Creating Steps for WP');

                                if (mapWorkPlanTemplate.containsKey(workPlanTId)
                                        && mapWorkPlanTemplateIdToWorkStepTemplateIds.containsKey(mapWorkPlanTemplate.get(workPlanTId).Id)) {

                                    System.debug('WorkStep found for WorkPlanTemplate Id : ' + workPlanTId);
                                    System.debug('WorkPlan associated with this WPTemplateId : ' + mapWOLIIdToMapWPTemplateIdToWP.get(woli.Id).get(workPlanTId));
                                    for (Id wstId : mapWorkPlanTemplateIdToWorkStepTemplateIds.get(mapWorkPlanTemplate.get(workPlanTId).Id)) {

                                        WorkStepTemplate wst = mapWorkStepTemplate.get(wstId);

                                        if (wst.IsActive == true) {
                                            WorkStep ws = GDMFSL_WorkStepTemplateProcessor.createWorkStepFromWorkStepTemplate(wst, woli.WorkOrderId, mapWOLIIdToMapWPTemplateIdToWP.get(woli.Id).get(workPlanTId).Id, mapWorkPlanTempIdToWorkStepTemplateIdToWorkPlanEntry.get(workPlanTId).get(wst.Id).ExecutionOrder, woli.Id);
                                            newWSs.add(ws);
                                        }
                                    }
                                }
                            }
                        }
                    }

                    if (newWSs.size() > 0) {
                        System.debug('Count of New WorkSteps to create: ' + newWSs.size());
                        GDMFSL_CommonUtilities.insertRecords(newWSs);
                        System.debug('Work Steps inserted: ' + newWSs);
                    }
                }
            }
        }
    }

    @TestVisible
    private static Set<Id> getWOLIRelatedWorkPlanTemplateIds(WorkOrderLineItem woli) {

        System.debug('Fetching WorkPlan Template Id Related to WOLI');

        Set<Id> workPlanTemplateIds = new Set<Id>();

        Map<Id, WorkOrder> mapWorkOrder = GDMFSL_WorkOrderProcessor.getRecords(new Set<Id>{
                woli.WorkOrderId
        });
        Map<Id, Asset> mapAssets = GDMFSL_AssetProcessor.getRecords(new Set<Id>{
                woli.AssetId
        });
        Map<Id, WorkPlanSelectionRule> mapWorkPlanSelectionRule = fetchWOLIWorkPlanSelectionRule(new List<WorkOrderLineItem>{
                woli
        });

        if (mapWorkOrder.containsKey(woli.WorkOrderId)) {

            if (mapWorkOrder.get(woli.WorkOrderId).ServiceContractId != null
                    && woli.ServiceTerritoryId != null
                    && woli.WorkTypeId != null
                    && woli.AssetId != null
                    && mapAssets.containsKey(woli.AssetId)
                    && mapAssets.get(woli.AssetId).Product2Id != null) {

                for (WorkPlanSelectionRule wps : mapWorkPlanSelectionRule.values()) {

                    if (wps.WorkTypeId == woli.WorkTypeId
                            && wps.ServiceTerritoryId == woli.ServiceTerritoryId
                            && wps.ServiceContractId == mapWorkOrder.get(woli.WorkOrderId).ServiceContractId
                            && wps.Product2Id == mapAssets.get(woli.AssetId).Product2Id) {

                        System.debug('Found WPlan templates using SC, ServiceTerritory, WType, and Asset.Product: ' + wps.WorkPlanTemplateId);
                        workPlanTemplateIds.add(wps.WorkPlanTemplateId);
                    }
                }
            }

            if (workPlanTemplateIds.isEmpty()
                    && mapWorkOrder.get(woli.WorkOrderId).ServiceContractId != null
                    && woli.WorkTypeId != null
                    && woli.AssetId != null
                    && mapAssets.containsKey(woli.AssetId)
                    && mapAssets.get(woli.AssetId).Product2Id != null) {

                for (WorkPlanSelectionRule wps : mapWorkPlanSelectionRule.values()) {

                    if (wps.WorkTypeId == woli.WorkTypeId
                            && wps.ServiceContractId == mapWorkOrder.get(woli.WorkOrderId).ServiceContractId
                            && wps.Product2Id == mapAssets.get(woli.AssetId).Product2Id) {

                        System.debug('Found WPlan templates using SC, WType, and Asset.Product: ' + wps.WorkPlanTemplateId);
                        workPlanTemplateIds.add(wps.WorkPlanTemplateId);
                    }
                }
            }

            if (workPlanTemplateIds.isEmpty()
                    && woli.ServiceTerritoryId != null
                    && woli.WorkTypeId != null
                    && woli.AssetId != null
                    && mapAssets.containsKey(woli.AssetId)
                    && mapAssets.get(woli.AssetId).Product2Id != null) {

                for (WorkPlanSelectionRule wps : mapWorkPlanSelectionRule.values()) {

                    if (wps.WorkTypeId == woli.WorkTypeId
                            && wps.ServiceTerritoryId == woli.ServiceTerritoryId
                            && wps.Product2Id == mapAssets.get(woli.AssetId).Product2Id) {

                        System.debug('Found WPlan templates using ServiceTerritory, WType, and Asset.Product: ' + wps.WorkPlanTemplateId);
                        workPlanTemplateIds.add(wps.WorkPlanTemplateId);
                    }
                }
            }

            if (workPlanTemplateIds.isEmpty()
                    && woli.WorkTypeId != null
                    && woli.AssetId != null
                    && mapAssets.containsKey(woli.AssetId)
                    && mapAssets.get(woli.AssetId).Product2Id != null) {

                for (WorkPlanSelectionRule wps : mapWorkPlanSelectionRule.values()) {

                    if (wps.WorkTypeId == woli.WorkTypeId
                            && wps.Product2Id == mapAssets.get(woli.AssetId).Product2Id) {

                        System.debug('Found WPlan templates using WType, and Asset.Product: ' + wps.WorkPlanTemplateId);
                        workPlanTemplateIds.add(wps.WorkPlanTemplateId);
                    }
                }
            }
        }

        System.debug('Retrieved WorkPlanTemplateIds: ' + workPlanTemplateIds);
        return workPlanTemplateIds;
    }

    public static Map<Id, WorkOrderLineItem> getRecords(List<Id> recIds) {

        if (recIds != null && !recIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (theWOLIRecords.isEmpty()) {
                newRecIds.addAll(recIds);
            } else {
                for (Id thisRecId : recIds) {
                    if (!theWOLIRecords.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                Map<Id, WorkOrderLineItem> theRecs = new Map<Id, WorkOrderLineItem>([
                        SELECT Id, WorkOrderId, AssetId
                        FROM WorkOrderLineItem
                        WHERE Id IN :newRecIds

                ]);

                theWOLIRecords.putAll(theRecs);
                System.debug('Retrieved WOLI: ' + theWOLIRecords);
            }
        }

        return theWOLIRecords;
    }

    public static Map<Id, List<WorkOrderLineItem>> getRecordsByWorkOrderId(Set<Id> workOrderIds) {

        System.debug('WorkOrder Id received: ' + workOrderIds);

        Map<Id, List<WorkOrderLineItem>> retValue = new Map<Id, List<WorkOrderLineItem>>();
        if (retValue.isEmpty() && workOrderIds != null && !workOrderIds.isEmpty()) {

            for (WorkOrderLineItem woli : [
                    SELECT Id, MaintenanceWorkRuleId, LocationId, WorkOrderId, WorkTypeId, AssetId,WorkOrder.ServiceContractId
                    FROM WorkOrderLineItem
                    WHERE WorkOrderId IN :workOrderIds
            ]) {

                System.debug('WOLI fetched: ' + woli);

                if (!retValue.containsKey(woli.WorkOrderId)) {
                    retValue.put(woli.WorkOrderId, new List<WorkOrderLineItem>());
                }
                retValue.get(woli.WorkOrderId).add(woli);
            }
        }

        return retValue;
    }

    public static Map<Id, Map<Id, WorkOrderLineItem>> getRecordsByWorkOrderIdForMaintPlanIds(Set<Id> maintPlanIds) {

        System.debug('Looking for WOLIs on WO for these MaintPlan IDs: ' + maintPlanIds);

        Map<Id, Map<Id, WorkOrderLineItem>> retValue = new Map<Id, Map<Id, WorkOrderLineItem>>();

        if (maintPlanIds != null && !maintPlanIds.isEmpty()) {

            for (WorkOrderLineItem woli : [
                    SELECT Id, WorkOrderId
                    FROM WorkOrderLineItem
                    WHERE WorkOrder.MaintenancePlanId IN :maintPlanIds
            ]) {

                if (!retValue.containsKey(woli.WorkOrderId)) {
                    retValue.put(woli.WorkOrderId, new Map<Id, WorkOrderLineItem>());
                }
                retValue.get(woli.WorkOrderId).put(woli.Id, woli);
            }
        }

        return retValue;
    }

    @TestVisible
    private static Map<Id, Map<String, Integer>> getAssetComponentsProductsCount(Set<Id> recIds) {

        Map<Id, Map<String, Integer>> mapAssetAndProductsCount = new Map<Id, Map<String, Integer>>();

        if (recIds != null && recIds.isEmpty()) {

            AggregateResult[] results = [
                    SELECT
                            GDMFSL_Product__r.Name productName,SUM(GDMFSL_Qty__c) sumOfQuantity,GDMFSL_Parent_Asset__c
                    FROM GDMFSL_Asset_Component__c
                    WHERE GDMFSL_Parent_Asset__c IN :recIds
                    GROUP BY GDMFSL_Product__r.Name, GDMFSL_Parent_Asset__c
            ];

            if (!results.isEmpty()) {
                for (AggregateResult a : results) {

                    System.debug(a.get('Product: ' + 'productName'));
                    System.debug('Qty sum: ' + a.get('sumOfQuantity'));

                    if (!mapAssetAndProductsCount.containsKey((Id) a.get('GDMFSL_Parent_Asset__c'))) {
                        mapAssetAndProductsCount.put((Id) a.get('GDMFSL_Parent_Asset__c'), new Map<String, Integer>());
                    }

                    mapAssetAndProductsCount.get((Id) a.get('GDMFSL_Parent_Asset__c')).put(a.get('productName').toString(), Integer.valueOf(a.get('sumOfQuantity')));
                }
            }
        }

        return mapAssetAndProductsCount;
    }

    public static void createAssetComponentSummaryForWOLI(List<WorkOrderLineItem> theWOLIs, Map<Id, WorkOrderLineItem> oldRecs) {

        System.debug('Initiating Creation of Asset Component Summary Logic');

        Set<Id> workTypeIds = new Set<Id>();

        for (WorkOrderLineItem woli : theWOLIs) {
            if (woli.WorkTypeId != null) {
                workTypeIds.add(woli.WorkTypeId);
            }
        }

        Map<Id, WorkType> mapWorkType = GDMFSL_WorkTypeProcessor.getRecords(workTypeIds);

        List<WorkOrderLineItem> wOLIsToUse = new List<WorkOrderLineItem>();
        Set<Id> assetIds = new Set<Id>();

        for (WorkOrderLineItem woli : theWOLIs) {

            if (woli.WorkTypeId != null
                    && woli.AssetId != null
                    && (oldRecs == null || (oldRecs.containsKey(woli.Id) && oldRecs.get(woli.Id).AssetId != woli.AssetId))
                    && mapWorkType.containsKey(woli.WorkTypeId) && mapWorkType.get(woli.WorkTypeId).GDMFSL_Asset_Certification__c) {

                System.debug('WOLI with Asset Cert WorkType got inserted or Asset was updated on a WOLI:' + woli.Id);
                wOLIsToUse.add(woli);
                assetIds.add(woli.AssetId);
            }
        }

        System.debug('Number of WOLI with Asset Certification True and have a related Asset are : ' + wOLIsToUse.size());
        System.debug('Fetch the Asset Component for the Assets');

        Map<Id, Map<String, Integer>> mapWOLIAssetAndProductsCount = getAssetComponentsProductsCount(assetIds);

        List<GDMFSL_Asset_Component_Summary__c> theAssetComponentSummaries = new List<GDMFSL_Asset_Component_Summary__c>();

        if (!mapWOLIAssetAndProductsCount.isEmpty()) {

            for (WorkOrderLineItem woli : wOLIsToUse) {

                if (mapWOLIAssetAndProductsCount.containsKey(woli.AssetId)) {

                    System.debug('WOLI ' + woli.Id + 'has an Asset Component with number of products equal to : ' + mapWOLIAssetAndProductsCount.get(woli.AssetId).size());

                    for (String productName : mapWOLIAssetAndProductsCount.get(woli.AssetId).keySet()) {

                        GDMFSL_Asset_Component_Summary__c assetComponentSummary = new GDMFSL_Asset_Component_Summary__c();
                        assetComponentSummary.Name = productName;
                        assetComponentSummary.GDMFSL_Total__c = mapWOLIAssetAndProductsCount.get(woli.AssetId).get(productName);
                        assetComponentSummary.GDMFSL_Work_Order_Line_Item__c = woli.Id;
                        theAssetComponentSummaries.add(assetComponentSummary);
                    }
                }
            }
        }

        System.debug('Total Number of Asset component Summary being created: ' + theAssetComponentSummaries.size());

        if (theAssetComponentSummaries.size() > 0) {
            System.debug('Creating Asset Component Summary Record');
            GDMFSL_CommonUtilities.insertRecords(theAssetComponentSummaries);
        }
    }

    public static Map<Id, Id> deriveVisitingHoursForWO(List<WorkOrderLineItem> theWOLIs) {

        Map<Id, Id> retMapWOIdToVisitingHourId = new Map<Id, Id>();

        Set<Id> workTypeIds = new Set<Id>();

        for (WorkOrderLineItem woli : theWOLIs) {
            if (woli.WorkTypeId != null) {
                workTypeIds.add(woli.WorkTypeId);
            }
        }

        Map<Id, WorkType> mapWorkType = GDMFSL_WorkTypeProcessor.getRecords(workTypeIds);

        System.debug('Map of WorkType retrieved: ' + mapWorkType);

        Set<Id> pmWOIdsWithWOLIAssets = new Set<Id>();

        for (WorkOrderLineItem woli : theWOLIs) {

            System.debug('WOLI WorkType: ' + woli.WorkTypeId);

            if (woli.AssetId != null && woli.WorkTypeId != null
                    && mapWorkType.containsKey(woli.WorkTypeId)
                    && mapWorkType.get(woli.WorkTypeId).GDMFSL_WorkType_Category__c == PMWORKTYPECATEGORY) {

                System.debug('PM related WO for WOLI that has an Asset: ' + woli.WorkOrderId);
                pmWOIdsWithWOLIAssets.add(woli.WorkOrderId);
            }
        }

        System.debug('Number of unique PM WorkOrders with Asset: ' + pmWOIdsWithWOLIAssets.size());

        System.debug('Fetching WO Ids related to All PM WOLIs');

        Map<Id, List<WorkOrderLineItem>> mapWOIdToWOLIs = getRecordsByWorkOrderId(pmWOIdsWithWOLIAssets);

        System.debug('Select only the PM WOs with 1 related WOLI');

        Set<Id> pmWOIdsToBeWorkedOn = new Set<Id>();
        Set<Id> serviceContractIds = new Set<Id>();
        Set<Id> assetIds = new Set<Id>();

        for (Id theWOId : mapWOIdToWOLIs.keySet()) {

            if (mapWOIdToWOLIs.get(theWOId).size() == 1) {

                System.debug('WorkOrder has only 1 associated WOLI : ' + theWOId);
                pmWOIdsToBeWorkedOn.add(theWOId);

                serviceContractIds.add(mapWOIdToWOLIs.get(theWOId)[0].WorkOrder.ServiceContractId);
                assetIds.add(mapWOIdToWOLIs.get(theWOId)[0].AssetId);
            }
        }

        System.debug('Fetching the CLI record related to WOLI Asset and WO ServiceContract');

        Map<Id, Map<Id, List<ContractLineItem>>> scIdToAssetIdoCLIs = GDMFSL_ContractLineItemProcessor.getRecords(serviceContractIds, assetIds);

        for (Id thisWOId : pmWOIdsToBeWorkedOn) {

            if (scIdToAssetIdoCLIs.containsKey(mapWOIdToWOLIs.get(thisWOId)[0].WorkOrder.ServiceContractId)
                    && scIdToAssetIdoCLIs.get(mapWOIdToWOLIs.get(thisWOId)[0].WorkOrder.ServiceContractId).containsKey(mapWOIdToWOLIs.get(thisWOId)[0].AssetId)) {

                if (scIdToAssetIdoCLIs.get(mapWOIdToWOLIs.get(thisWOId)[0].WorkOrder.ServiceContractId).get(mapWOIdToWOLIs.get(thisWOId)[0].AssetId)[0].GDMFSL_Maintenance_Hours__c != null) {
                    System.debug('The CLI related to WOLI Asset and WO Service Contract is: ' + scIdToAssetIdoCLIs.get(mapWOIdToWOLIs.get(thisWOId)[0].WorkOrder.ServiceContractId).get(mapWOIdToWOLIs.get(thisWOId)[0].AssetId)[0].Id);
                    retMapWOIdToVisitingHourId.put(thisWOId, scIdToAssetIdoCLIs.get(mapWOIdToWOLIs.get(thisWOId)[0].WorkOrder.ServiceContractId).get(mapWOIdToWOLIs.get(thisWOId)[0].AssetId)[0].GDMFSL_Maintenance_Hours__c);
                }
            }
        }

        return retMapWOIdToVisitingHourId;
    }

    public static void setWOVisitingHoursFromWOLIs(List<WorkOrderLineItem> theWOLIs) {

        Map<Id, Id> mapWOIdToOHId = deriveVisitingHoursForWO(theWOLIs);
        List<WorkOrder> toBeUpdatedWOs = new List<WorkOrder>();

        for (Id woId : mapWOIdToOHId.keySet()) {
            WorkOrder wo = new WorkOrder(Id = woId, FSL__VisitingHours__c = mapWOIdToOHId.get(woId));
            toBeUpdatedWOs.add(wo);
        }

        System.debug('WO updated with Operating Hour on WOLI insert');
        GDMFSL_CommonUtilities.updateRecords(toBeUpdatedWOs);
    }

    public static void addWOLIRelatedRecordsToMaintPlanWOs(Set<Id> maintPlanIdsToUse) {

        System.debug('Finding WOLI related records to add to PM WOs for MaintPlans: ' + maintPlanIdsToUse);

        if (maintPlanIdsToUse != null && !maintPlanIdsToUse.isEmpty()) {

            System.debug('find all the WOLIs related to WOs related to the MaintPlan IDs');

            Map<Id, Map<Id, WorkOrderLineItem>> woIdsToWOLIs = getRecordsByWorkOrderIdForMaintPlanIds(maintPlanIdsToUse);

            Set<Id> recIdsForRelatedRecords = new Set<Id>();

            System.debug('Adding all WO Ids so we can find existing related records');
            recIdsForRelatedRecords.addAll(woIdsToWOLIs.keySet());

            for (Id theWOID : woIdsToWOLIs.keySet()) {
                recIdsForRelatedRecords.addAll(woIdsToWOLIs.get(theWOID).keySet());
            }

            System.debug('For each WO, add the related records for its WOLIs (but make sure not to duplicate');

            Map<Id, List<SkillRequirement>> parentRecIDToExistingSkillReqs = GDMFSL_SkillRequirementProcessor.getRecordsForParentId(recIdsForRelatedRecords);

            Map<Id, Map<Id, SkillRequirement>> woIDToSkillIDToExistingSkillReqs = new Map<Id, Map<Id, SkillRequirement>>();

            for (Id parentId : parentRecIDToExistingSkillReqs.keySet()) {

                if (parentId.getSobjectType() == WorkOrder.getSObjectType()) {

                    woIDToSkillIDToExistingSkillReqs.put(parentId, new Map<Id, SkillRequirement>());

                    for (SkillRequirement theSkillReq : parentRecIDToExistingSkillReqs.get(parentId)) {
                        woIDToSkillIDToExistingSkillReqs.get(parentId).put(theSkillReq.SkillId, theSkillReq);
                    }
                }
            }

/*
            Map<Id, List<ProductRequired>> parentRecIDToExistingProdReqs = GDMFSL_ProductRequirementProcessor.getRecordsForParentId(recIdsForRelatedRecords);

            Map<Id, Map<Id, ProductRequired>> woIDToProdIDToExistingProdReqs = new Map<Id, Map<Id, ProductRequired>>();

            for (Id parentId : parentRecIDToExistingProdReqs.keySet()) {

                if (parentId.getSobjectType() == WorkOrder.getSObjectType()) {

                    woIDToProdIDToExistingProdReqs.put(parentId, new Map<Id, SkillRequirement>());

                    for (ProductRequired theProdReq : parentRecIDToExistingProdReqs.get(parentId)) {
                        woIDToProdIDToExistingProdReqs.get(parentId).put(theProdReq.Product2Id, theProdReq);
                    }
                }
            }
*/

            System.debug('add the WOLI related records to the WO');

            Map<Id, SkillRequirement> existingSkillReqsToUpdate = new Map<Id, SkillRequirement>();
            Map<Id, Map<Id, Decimal>> woIDToSkillIDToSkillLevelForCreate = new Map<Id, Map<Id, Decimal>>();

            for (Id theWOID : woIdsToWOLIs.keySet()) {

                System.debug('Checking WO: ' + theWOID);

                for (Id theWOLIId : woIdsToWOLIs.get(theWOID).keySet()) {

                    System.debug('Checking WOLI: ' + theWOLIId);

                    System.debug('Getting ready to work on WOLI Skill Requirements');

                    if (parentRecIDToExistingSkillReqs.containsKey(theWOLIId)) {

                        System.debug('Found WOLI Skill Requirements');

                        for (SkillRequirement theSkillReq : parentRecIDToExistingSkillReqs.get(theWOLIId)) {

                            System.debug('Checking if WO has the same skill: ' + theSkillReq);

                            if (woIDToSkillIDToExistingSkillReqs.containsKey(theWOID)
                                    && woIDToSkillIDToExistingSkillReqs.get(theWOID).containsKey(theSkillReq.SkillId)) {

                                System.debug('WO already has this Skill: ' + theSkillReq.SkillId);

                                if (woIDToSkillIDToExistingSkillReqs.get(theWOID).get(theSkillReq.SkillId).SkillLevel < theSkillReq.SkillLevel) {

                                    System.debug('Existing skill has lower level, updating');
                                    woIDToSkillIDToExistingSkillReqs.get(theWOID).get(theSkillReq.SkillId).SkillLevel = theSkillReq.SkillLevel;

                                    System.debug('Add or overwrite the SkillReq for update');
                                    existingSkillReqsToUpdate.put(woIDToSkillIDToExistingSkillReqs.get(theWOID).get(theSkillReq.SkillId).Id, woIDToSkillIDToExistingSkillReqs.get(theWOID).get(theSkillReq.SkillId));
                                }
                            } else {

                                System.debug('WO does not have this existing Skill: ' + theSkillReq.SkillId);

                                System.debug('Are we already adding it as a new SkillReq?');

                                if (!woIDToSkillIDToSkillLevelForCreate.containsKey(theWOID)) {
                                    woIDToSkillIDToSkillLevelForCreate.put(theWOID, new Map<Id, Decimal>());
                                }

                                if (!woIDToSkillIDToSkillLevelForCreate.get(theWOID).containsKey(theSkillReq.SkillId)
                                        || woIDToSkillIDToSkillLevelForCreate.get(theWOID).get(theSkillReq.SkillId) < theSkillReq.SkillLevel) {

                                    System.debug('Adding the new Skill and SkillLevel for the WO');
                                    woIDToSkillIDToSkillLevelForCreate.get(theWOID).put(theSkillReq.SkillId, theSkillReq.SkillLevel);
                                }
                            }
                        }
                    }

/*
                    System.debug('Getting ready to work on WOLI Prod Requirements');

                    if (parentRecIDToExistingProdReqs.containsKey(theWOLIId)) {

                        System.debug('Adding Prod Requirements');

                        for (ProductRequired theProdReq : parentRecIDToExistingProdReqs.get(theWOLIId)) {

                            System.debug('Cloning ProdReq: ' + theProdReq);

                            ProductRequired newProdReq = theProdReq.clone(false, true, false, false);
                            newProdReq.ParentRecordId = theWOID;
                        }
                    }
*/
                }
            }

            System.debug('This many existing SkillReqs to update: ' + existingSkillReqsToUpdate.size());
            System.debug('And this many WOs need new SkillReqs: ' + woIDToSkillIDToSkillLevelForCreate.size());

            List<SObject> recsForTheDB = new List<SObject>();

            if (!existingSkillReqsToUpdate.isEmpty()){
                recsForTheDB.addAll(existingSkillReqsToUpdate.values());
            }

            if (!woIDToSkillIDToSkillLevelForCreate.isEmpty()){

                for (Id theWOId : woIDToSkillIDToSkillLevelForCreate.keySet()){

                    System.debug('Adding SkillReqs for WO: ' + theWOId);

                    for (Id theSkillId : woIDToSkillIDToSkillLevelForCreate.get(theWOId).keySet()){

                        System.debug('Adding SkillId: ' + theSkillId);
                        System.debug('And  SkillLevel: ' + woIDToSkillIDToSkillLevelForCreate.get(theWOId).get(theSkillId));

                        recsForTheDB.add(new SkillRequirement(SkillId = theSkillId,
                                RelatedRecordId = theWOId,
                                SkillLevel = woIDToSkillIDToSkillLevelForCreate.get(theWOId).get(theSkillId)));
                    }
                }
            }

            if (!recsForTheDB.isEmpty()) {
                GDMFSL_CommonUtilities.upsertRecords(recsForTheDB, false);
            }
        }
    }
}