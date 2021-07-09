/*******************************************************************************************
Name       :    GDMFSL_WorkOrderProcessor
Purpose    :    Business Logic for WorkOrder object . See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Sep-01    Created
Bryant                  2020-Sep-30    Updated Operator to check if location is classified
**********************************************************************************************/

public without sharing class GDMFSL_WorkOrderProcessor implements Queueable {

    public static final String CANCELLEDSTATUS = 'Canceled';
    public static final String COMPLETEDSTATUS = 'Completed';
    public static final String INPROGRESSSTATUS = 'In Progress';
    public static final String EXPORTSTATUS = 'Export';
    public static final String CLOSEDSTATUS = 'Closed';
    public static final String NEWSTATUS = 'New';
    public static final Integer DEFAULTENDDATEOFFSET_DAYS = 1;
    public static final String MAINTWOSUBJECTPREFIX = 'Maintenance ';

    public static final Map<String, Integer> WOSTATUSLEVEL = new Map<String, Integer>{
            'None' => 0,
            'New' => 1,
            'Scheduled' => 2,
            'Dispatched' => 3,
            'InProgress' => 4
    };

    public static final Map<Integer, String> WOLEVELTOSTATUS = new Map<Integer, String>{
            0 => 'None',
            1 => 'New',
            2 => 'Scheduled',
            3 => 'Dispatched',
            4 => 'InProgress'
    };

    public static final Set<String> STATUSFORUPDATES = new Set<String>{
            'New',
            'Scheduled',
            'Dispatched',
            'Pending Review',
            'None'
    };

    public static final Set<String> STATUSFORACTIVELOCATIONSETTING = new Set<String>{
            'New',
            'Scheduled',
            'Dispatched',
            'Reject',
            'In Progress',
            'Paused'
    };

    public static final Set<String> STATUSFORACTIVELOCATIONCLEARING = new Set<String>{
            CANCELLEDSTATUS,
            'Completed'
    };

    public static final Set<String> STATUSFORCANCELLATION = new Set<String>{
            'New',
            'Scheduled',
            'Dispatched'
    };

    public static final Set<String> SAPJOBTYPE = new Set<String>{
            'Install Project',
            'Service Project'
    };

    private static final Set<String> STATUSFORSERVRESCREATION = new Set<String>{
            'New',
            'None',
            'Pending Review'
    };

    private static Map<Id, WorkOrder> theWOs = new Map<Id, WorkOrder>();
    private static Map<Id, List<WorkOrder>> maintPlanIDToWOs = new Map<Id, List<WorkOrder>>();
    private static Map<Id, Schema.Location> mapLocations = new Map<Id, Schema.Location>();
    private static Map<Id, Asset> mapAssets = new Map<Id, Asset>();
    private static Map<Id, ServiceTerritory> mapServiceTerritory = new Map<Id, ServiceTerritory>();
    private static Map<Id, WorkType> mapWorkType = new Map<Id, WorkType>();
    private static Map<Id, MaintenancePlan> mapMaintenancePlan = new Map<Id, MaintenancePlan>();
    private static Map<Id, MaintenanceWorkRule> mapMaintenanceWorkRule = new Map<Id, MaintenanceWorkRule>();
    private static Map<Id, Map<Id, List<ContractLineItem>>> scAssetCliItemMap = new Map<Id, Map<Id, List<ContractLineItem>>>();
    private static Map<Id, GDMFSL_Associated_Contract__c> mapAssociatedContract = new Map<Id, GDMFSL_Associated_Contract__c>();
    private static Map<Id, ServiceContract> mapServiceContracts = new Map<Id, ServiceContract>();
    private static Map<Id, List<GDMFSL_SLA__c>> mapSLA = new Map<Id, List<GDMFSL_SLA__c>>();
    private static Map<Id, Map<Id, GDMFSL_Profit_Center__c>> mapProfitCenter = new Map<Id, Map<Id, GDMFSL_Profit_Center__c>>();
    private static Map<Id, OperatingHours> mapOperatingHours = new Map<Id, OperatingHours>();
    private static Map<String, ServiceReportLayout> mapStringToSRL = new Map<String, ServiceReportLayout>();
    private static Map<Id, Case> mapCases = new Map<Id, Case>();
    private static Map<String, List<GDMFSL_Job_Type_Mapping__mdt>> mapWorkTypeCategoryToJobTypes = new Map<String, List<GDMFSL_Job_Type_Mapping__mdt>>();

    public static void setWOFields(List<WorkOrder> lstWorkOrders, Map<Id, WorkOrder> oldRecs) {

        System.debug('Inside setWOFields Method');
        System.debug('WorkOrder List Input : ' + lstWorkOrders);

        System.debug('Need to set WorkType on any WO from MaintPlan Generation without one');
        Boolean needAutoPMWType = false;

        for (WorkOrder theWO : lstWorkOrders) {

            if (theWO.MaintenancePlanId != null
                    && theWO.WorkTypeId == null) {
                needAutoPMWType = true;
                break;
            }
        }

        WorkType theAutoGenPMWorkType;

        if (needAutoPMWType) {
            theAutoGenPMWorkType = GDMFSL_WorkTypeProcessor.getWorkTypeForAutoGeneratedWOs();
        }

        Set<Id> locationIds = new Set<Id>();
        Set<Id> serviceContractIds = new Set<Id>();
        List<WorkOrder> theWOsToUse = new List<WorkOrder>();
        List<WorkOrder> withoutWorkTypeWOs = new List<WorkOrder>();

        for (WorkOrder theWO : lstWorkOrders) {

            if (theWO.MaintenancePlanId != null
                    && theWO.WorkTypeId == null
                    && theAutoGenPMWorkType != null) {

                System.debug('Setting WorkType to autoGenPM WorkType');
                theWO.WorkTypeId = theAutoGenPMWorkType.Id;
            }

            System.debug('WorkOrder Status: ' + theWO.Status);

            if (STATUSFORUPDATES.contains(theWO.Status)) {

                if (theWO.LocationId != null) {
                    locationIds.add(theWO.LocationId);
                }

                if (woCanBeProcessed(theWO)) {
                    theWOsToUse.add(theWO);
                } else {
                    withoutWorkTypeWOs.add(theWO);
                }
            }
        }

        System.debug('Location Ids Found Count: ' + locationIds.size());

        mapLocations = GDMFSL_LocationProcessor.getRecords(locationIds);

        Set<String> compNums = new Set<String>();

        for (Schema.Location theLoc : mapLocations.values()) {
            if(theLoc.GDMFSL_SAP_Customer_Number__c!=null) {
                compNums.add(theLoc.GDMFSL_SAP_Customer_Number__c);
            }
        }

        Map<String, Source_System__c> srcSystemByCompanyNumber = GDMFSL_SourceSystemProcessor.getSourceSystemByCompanyNumber(compNums);

        if (!theWOsToUse.isEmpty()) {

            Set<Id> caseIds = new Set<Id>();
            Set<Id> assetIds = new Set<Id>();
            Set<Id> workTypeIds = new Set<Id>();
            Set<Id> maintenancePlanIds = new Set<Id>();
            Set<Id> maintenanceWorkRuleIds = new Set<Id>();
            Set<Id> serviceTerritoryIds = new Set<Id>();
            Set<Id> operatingHoursIds = new Set<Id>();

            for (WorkOrder wo : theWOsToUse) {

                if (wo.AssetId != null) {
                    assetIds.add(wo.AssetId);
                }
                if (wo.WorkTypeId != null) {
                    workTypeIds.add(wo.WorkTypeId);
                }
                if (wo.ServiceContractId != null) {
                    serviceContractIds.add(wo.ServiceContractId);
                }
                if (wo.MaintenancePlanId != null) {
                    maintenancePlanIds.add(wo.MaintenancePlanId);
                }
                if (wo.MaintenanceWorkRuleId != null) {
                    maintenanceWorkRuleIds.add(wo.MaintenanceWorkRuleId);
                }
                if (wo.ServiceTerritoryId != null) {
                    serviceTerritoryIds.add(wo.ServiceTerritoryId);
                }

                if (Trigger.isInsert && Trigger.isBefore && wo.CaseId != null) {
                    caseIds.add(wo.CaseId);
                }
            }

            System.debug('Asset Ids: ' + assetIds);
            System.debug('ServiceContract Ids: ' + serviceContractIds);

            mapCases = GDMFSL_CaseProcessor.getRecords(caseIds);

            mapAssets = GDMFSL_AssetProcessor.getRecords(assetIds);

            mapWorkType = GDMFSL_WorkTypeProcessor.getRecords(workTypeIds);

            mapMaintenancePlan = GDMFSL_MaintenancePlanProcessor.getRecords(maintenancePlanIds);

            mapMaintenanceWorkRule = GDMFSL_MaintenancePlanProcessor.getMaintWorkRuleRecords(maintenanceWorkRuleIds);

            scAssetCliItemMap = GDMFSL_ContractLineItemProcessor.getRecords(serviceContractIds, assetIds);

            mapServiceContracts = GDMFSL_ServiceContractProcessor.getRecords(serviceContractIds);

            mapAssociatedContract = GDMFSL_AssociatedContractProcessor.getRecords(serviceContractIds, locationIds);

            mapSLA = GDMFSL_SLAProcessor.getRecords(mapAssociatedContract.keySet(), GDMFSL_Associated_Contract__c.getSObjectType());

            System.debug('Count of Assets: ' + mapAssets.size());
            System.debug('Count of WorkTypes: ' + mapWorkType.size());
            System.debug('Count of Service Contract: ' + mapServiceContracts.size());
            System.debug('Count of Associated Contract: ' + mapAssociatedContract.size());
            System.debug('Count of SLAs: ' + mapSLA.size());

            for (WorkOrder wo : theWOsToUse) {

                System.debug('Looking at WO: ' + wo.WorkOrderNumber);

                if (wo.ServiceTerritoryId != null) {
                    System.debug('Adding ServiceTerritoryId: ' + wo.ServiceTerritoryId);
                    serviceTerritoryIds.add(wo.ServiceTerritoryId);
                }

                if (Trigger.isBefore && Trigger.isInsert) {

                    if (wo.CaseId != null && mapCases.containsKey(wo.CaseId)) {
                        System.debug('Setting Asset from the Case');
                        wo.AssetId = mapCases.get(wo.CaseId).AssetId;
                    }

                    System.debug('Setting WO Entitlement Services Flags on Creation');

                    if (wo.ServiceContractId != null) {

                        if (wo.AssetId != null
                                && scAssetCliItemMap.containsKey(wo.ServiceContractId)
                                && scAssetCliItemMap.get(wo.ServiceContractId).containsKey(wo.AssetId)) {

                            System.debug('Set WO Entitlement Services Flags from the CLI');

                            for (ContractLineItem theCLI : scAssetCliItemMap.get(wo.ServiceContractId).get(wo.AssetId)) {

                                System.debug('Using first CLI for the Asset: ' + theCLI.Id);

                                wo.GDMFSL_Warranty__c = theCLI.GDMFSL_Warranty_Services__c;
                                wo.GDMFSL_Parts_Chargeable__c = !theCLI.GDMFSL_Parts_Replacement_Managment__c;
                                wo.GDMFSL_PO_Required_for_Reactive_Coverage__c = theCLI.GDMFS_PO_Number_Reactive_Coverage__c;
                                break;
                            }
                        } else if (mapServiceContracts.containsKey(wo.ServiceContractId)) {

                            System.debug('Set WO Entitlement Services Flags from Service Contract');

                            wo.GDMFSL_Warranty__c = mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Warranty_Services__c;
                            wo.GDMFSL_Parts_Chargeable__c = !mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Parts_Replacement_Management__c;
                            wo.GDMFSL_PO_Required_for_Reactive_Coverage__c = mapServiceContracts.get(wo.ServiceContractId).GDMFS_PO_Number_Reactive_Coverage__c;
                        }

                        System.debug('WO Warranty: ' + wo.GDMFSL_Warranty__c);
                        System.debug('WO Part Chargeable:  ' + wo.GDMFSL_Parts_Chargeable__c);
                        System.debug('WO PO Required: ' + wo.GDMFSL_PO_Required_for_Reactive_Coverage__c);
                    }
                }


                if ((Trigger.isBefore && Trigger.isInsert && wo.Status == 'New')
                        || (oldRecs != null
                        && ((wo.Status != oldRecs.get(wo.Id).Status) || (wo.LocationId != oldRecs.get(wo.Id).LocationId))
                        && STATUSFORACTIVELOCATIONSETTING.contains(wo.Status))) {

                    System.debug('Setting WO Location Active WO field from WO Location field');
                    wo.GDMFSL_Location_ActiveWO__c = wo.LocationId;
                }

                System.debug('Defaulting WO ServiceTerritory, Region, Address, and ShipTo Account to NULL');
                wo.ServiceTerritoryId = null;
                wo.GDMFSL_Ship_To_Account__c = null;
                wo.GDMFSL_Region__c = null;
                wo.Street = null;
                wo.City = null;
                wo.State = null;
                wo.PostalCode = null;
                wo.Country = null;

                if (wo.LocationId != null
                        && mapLocations.containsKey(wo.LocationId)) {

                    if (Trigger.isInsert
                            && mapLocations.get(wo.LocationId).GDMFSL_SAP_Customer_Number__c != null
                            && srcSystemByCompanyNumber.containsKey(mapLocations.get(wo.LocationId).GDMFSL_SAP_Customer_Number__c)) {

                        System.debug('Setting WO Currency Code from SourceSystem Customer Number: ' + mapLocations.get(wo.LocationId).GDMFSL_SAP_Customer_Number__c);
                        wo.CurrencyIsoCode = srcSystemByCompanyNumber.get(mapLocations.get(wo.LocationId).GDMFSL_SAP_Customer_Number__c).CurrencyIsoCode;
                        System.debug('Setting WO Currency Code to: ' + wo.CurrencyIsoCode);
                    }

                    if (mapLocations.get(wo.LocationId).GDMFSL_Service_Territory__c != null) {

                        wo.ServiceTerritoryId = mapLocations.get(wo.LocationId).GDMFSL_Service_Territory__c;
                        wo.GDMFSL_Region__c = mapLocations.get(wo.LocationId).GDMFSL_Region__c;
                        serviceTerritoryIds.add(wo.ServiceTerritoryId);
                        System.debug('Setting ServiceTerritory: ' + wo.ServiceTerritoryId);
                        System.debug('Setting Region: ' + wo.GDMFSL_Region__c);

                        if (mapLocations.get(wo.LocationId).GDMFSL_Service_Territory__r.GDMFSL_Price_Book__c != null) {

                            wo.Pricebook2Id = mapLocations.get(wo.LocationId).GDMFSL_Service_Territory__r.GDMFSL_Price_Book__c;
                            System.debug('Setting Price Book from Service Territory: ' + wo.Pricebook2Id);
                        }
                    }

                    if (mapLocations.get(wo.LocationId).GDMFSL_Ship_To_Account__c != null) {

                        System.debug('Setting WO ShipTo Account from Location');
                        wo.GDMFSL_Ship_To_Account__c = mapLocations.get(wo.LocationId).GDMFSL_Ship_To_Account__c;

                        if (wo.GDMFSL_Created_by_WO_Merge_Process__c && wo.Subject == MAINTWOSUBJECTPREFIX) {

                            System.debug('Setting Subject for Auto-generated Maintenance WOs');
                            wo.Subject += mapLocations.get(wo.LocationId).GDMFSL_Ship_To_Account__r.Name;
                        }

                    }

                    if (mapLocations.get(wo.LocationId).GDMFSL_Address__c != null) {

                        System.debug('Setting WO Address from Location Address');
                        System.debug('Location Address : ' + mapLocations.get(wo.LocationId).GDMFSL_Address__c);
                        wo.Street = mapLocations.get(wo.LocationId).GDMFSL_Address__r.Street;
                        wo.City = mapLocations.get(wo.LocationId).GDMFSL_Address__r.City;
                        wo.State = mapLocations.get(wo.LocationId).GDMFSL_Address__r.State;
                        wo.PostalCode = mapLocations.get(wo.LocationId).GDMFSL_Address__r.PostalCode;
                        wo.Country = mapLocations.get(wo.LocationId).GDMFSL_Address__r.Country;
                        System.debug('WorkOrder Address being set to :' + wo.Street + '-' + wo.City + '-' + wo.State + '-' + wo.PostalCode + '-' + wo.Country);
                    }

                }

                System.debug('WO ServiceTerritory: ' + wo.ServiceTerritoryId);
                System.debug('WO ShipTo Account set to: ' + wo.GDMFSL_Ship_To_Account__c);
                System.debug('WO Region set to: ' + wo.GDMFSL_Region__c);

                if (wo.AssetId != null && mapAssets.containsKey(wo.AssetId)) {
                    System.debug('Setting WO SubLocation from Asset ' + wo.AssetId);
                    wo.GDMFSL_Sub_Location__c = mapAssets.get(wo.AssetId).LocationId;
                }

                System.debug('WorkOrder SubLocation set to: ' + wo.GDMFSL_Sub_Location__c);

                System.debug('Defaulting WO Minimum Charge to NULL');
                wo.GDMFSL_Min_Charge_Time__c = null;

                for (GDMFSL_Associated_Contract__c ac : mapAssociatedContract.values()) {
                    System.debug('Associated Contract: ' + ac);
                    System.debug('Location: ' + ac.Location__c);
                    System.debug('Service Contract: ' + ac.Service_Contract__c);
                    System.debug('Min Charge: ' + ac.GDMFSL_Min_Charge_Time__c);

                    if (ac.Location__c == wo.LocationId
                            && ac.Service_Contract__c == wo.ServiceContractId) {

                        System.debug('Found Associated Contract for WO Location & Service Contract: ' + ac.Id);
                        wo.GDMFSL_Min_Charge_Time__c = ac.GDMFSL_Min_Charge_Time__c;
                        break;
                    }
                }

                System.debug('WO Min Charge Time set to: ' + wo.GDMFSL_Min_Charge_Time__c);

                System.debug('Setting WO Start and EndDate');

                //Default to creation Date to avoid any scenario where it will be NULL
                System.debug('WO Created Date : ');


                if (wo.CaseId != null && mapCases.containsKey(wo.CaseId)) {

                    wo.StartDate = mapCases.get(wo.CaseId).CreatedDate != null ? mapCases.get(wo.CaseId).CreatedDate : System.Datetime.now();
                    System.debug('WO Start Date set from the related Case CreatedDate:  ' + wo.StartDate);

                    if (mapWorkType.containsKey(wo.WorkTypeId) && mapWorkType.get(wo.WorkTypeId).FSL__Due_Date_Offset__c != null) {
                        wo.EndDate = wo.StartDate.addMinutes((Integer) mapWorkType.get(wo.WorkTypeId).FSL__Due_Date_Offset__c);
                    } else {
                        wo.EndDate = wo.StartDate.addDays(DEFAULTENDDATEOFFSET_DAYS);
                    }
                }

                if (wo.LocationId != null && mapLocations.containsKey(wo.LocationId)) {

                    if (wo.Duration != null) {
                        Decimal extraTravelTime = mapLocations.get(wo.LocationId).GDMFSL_Extra_Travel_Time__c != null ? mapLocations.get(wo.LocationId).GDMFSL_Extra_Travel_Time__c : 0;
                        setWODurationwithExtraTime(wo, oldRecs != null ? oldRecs.get(wo.Id) : null, extraTravelTime);
                        System.debug('WO Duration set to: ' + wo.Duration);
                    }

                    System.debug('Finding related Operating Hour Id on WO from Location else its Service Territory');

                    if (mapLocations.get(wo.LocationId).GDMFSL_Working_Hours__c != null) {
                        System.debug('operating hour from location');
                        operatingHoursIds.add(mapLocations.get(wo.LocationId).GDMFSL_Working_Hours__c);
                    }
                }
            }

            mapServiceTerritory = GDMFSL_ServiceTerritoryProcessor.getRecords(serviceTerritoryIds);

            for (ServiceTerritory st : mapServiceTerritory.values()) {
                operatingHoursIds.add(st.OperatingHoursId);
            }

            mapOperatingHours = GDMFSL_OperatingHoursProcessor.getRecords(operatingHoursIds);
            System.debug('size of MapOperating Hours fetched : ' + mapOperatingHours.size());

            setVisitingHoursOnWO(theWOsToUse);
            setProfitCenterOnWO(theWOsToUse, serviceTerritoryIds, oldRecs);
            setReactiveCoverageOnWO(theWOsToUse);
            setSLAOnWO(theWOsToUse);
            setJobTypeOnWO(theWOsToUse, oldRecs);
            setSAPAccountNumbersOnWO(theWOsToUse, oldRecs);

            System.debug('Final WorkOrders with WorkTypes updated: ' + lstWorkOrders);
        }

        if (!withoutWorkTypeWOs.isEmpty()) {

            System.debug('Found WO without WorkTypes: ' + withoutWorkTypeWOs.size());

            for (WorkOrder wo : withoutWorkTypeWOs) {

                if (wo.LocationId != null
                        && mapLocations.containsKey(wo.LocationId)) {

                    if (mapLocations.get(wo.LocationId).GDMFSL_Service_Territory__c != null) {

                        System.debug('Setting without WorkTypes WO Service Territory and Region');
                        wo.ServiceTerritoryId = mapLocations.get(wo.LocationId).GDMFSL_Service_Territory__c;
                        wo.GDMFSL_Region__c = mapLocations.get(wo.LocationId).GDMFSL_Region__c;
                    }

                    if (Trigger.isInsert
                            && mapLocations.get(wo.LocationId).GDMFSL_SAP_Customer_Number__c != null
                            && srcSystemByCompanyNumber.containsKey(mapLocations.get(wo.LocationId).GDMFSL_SAP_Customer_Number__c)) {

                        System.debug('Setting WO Currency Code from SourceSystem Customer Number: ' + mapLocations.get(wo.LocationId).GDMFSL_SAP_Customer_Number__c);
                        wo.CurrencyIsoCode = srcSystemByCompanyNumber.get(mapLocations.get(wo.LocationId).GDMFSL_SAP_Customer_Number__c).CurrencyIsoCode;
                        System.debug('Setting WO Currency Code to: ' + wo.CurrencyIsoCode);
                    }
                }
            }

            System.debug('For WO without WorkTypes - Setting all WO Accounts');
            setSAPAccountNumbersOnWO(withoutWorkTypeWOs, oldRecs);
        }
    }

    public static void setVisitingHoursOnWO(List<WorkOrder> theWOs) {


        Set<Id> workOrderIds = new Set<Id>();

        for (WorkOrder theWO : theWOs) {

            if ((theWO.LocationId != null && mapLocations.containsKey(theWO.LocationId))) {
                if (Trigger.isUpdate && theWO.Work_Type_Category__c == GDMFSL_WorkOrderLIProcessor.PMWORKTYPECATEGORY) {
                    workOrderIds.add(theWO.Id);
                }
                System.debug('Working hours set from Location on WO : ' + theWO.LocationId);
                theWO.FSL__VisitingHours__c = mapLocations.get(theWO.LocationId).GDMFSL_Working_Hours__c;

            }
        }

        if (!workOrderIds.isEmpty()) {

            System.debug('WorkOrder got udpated with a PM WorkType,need to check if Operating hour can be derived from a WOLI');
            Map<Id, Id> mapWOIdToVisitingHourId = new Map<Id, Id>();
            List<WorkOrderLineItem> theWOLIs = new List<WorkOrderLineItem>();
            System.debug('PM WOs which got updated :' + workOrderIds.size());

            Map<Id, List<WorkOrderLineItem>> mapWOIdToWOLIs = GDMFSL_WorkOrderLIProcessor.getRecordsByWorkOrderId(workOrderIds);
            if (!mapWOIdToWOLIs.isEmpty()) {
                for (Id woId : workOrderIds) {
                    for (WorkOrderLineItem woli : mapWOIdToWOLIs.get(woId)) {
                        theWOLIs.add(woli);
                    }
                }
            }
            if (theWOLIs.size() > 0) {
                System.debug('Checking to see if we can derive Operating Hour from CLI related to WOLI if any');
                mapWOIdToVisitingHourId = GDMFSL_WorkOrderLIProcessor.deriveVisitingHoursForWO(theWOLIs);
                if (!mapWOIdToVisitingHourId.isEmpty()) {
                    for (WorkOrder wo : theWOs) {
                        if (mapWOIdToVisitingHourId.containsKey(wo.Id)) {
                            wo.FSL__VisitingHours__c = mapWOIdToVisitingHourId.get(wo.Id);
                        } else if (wo.FSL__VisitingHours__c == null) {
                            System.debug('Visiting Hour is still null,set it from location');
                            wo.FSL__VisitingHours__c = mapLocations.get(wo.LocationId).GDMFSL_Working_Hours__c;
                        }
                    }
                }
            }

        }

    }


    public static void copyFilesFromCaseToWO(List<WorkOrder> theWOs) {

        List<WorkOrder> toBeUsedWOs = new List<WorkOrder>();
        Set<Id> caseIds = new Set<Id>();
        Map<Id, List<ContentDocumentLink>> mapCaseAndLinkedFiles = new Map<Id, List<ContentDocumentLink>>();
        List<ContentDocumentLink> toBeCreatedContentDocument = new List<ContentDocumentLink>();

        for (WorkOrder wo : theWOs) {
            if (wo.CaseId != null) {
                toBeUsedWOs.add(wo);
                caseIds.add(wo.CaseId);
            }
        }
        System.debug('Found these Many WorkOrder having a related Case : ' + toBeUsedWOs.size());
        mapCaseAndLinkedFiles = GDMFSL_ContentDocumentProcessor.getCaseRelatedFileRecords(caseIds);
        System.debug('Number of Cases with Files attached to that are : ' + mapCaseAndLinkedFiles.size());
        if (!mapCaseAndLinkedFiles.isEmpty()) {
            for (WorkOrder wo : toBeUsedWOs) {
                if (mapCaseAndLinkedFiles.containsKey(wo.CaseId)) {
                    System.debug('WO : ' + wo.WorkOrderNumber + ' related case has these number of Files attached :' + mapCaseAndLinkedFiles.get(wo.CaseId).size());
                    for (ContentDocumentLink cd : mapCaseAndLinkedFiles.get(wo.CaseId)) {
                        ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
                        contentDocumentLink.LinkedEntityId = wo.Id;
                        contentDocumentLink.ContentDocumentId = cd.ContentDocumentId;
                        toBeCreatedContentDocument.add(contentDocumentLink);
                    }
                }
            }
        }
        if (!toBeCreatedContentDocument.isEmpty()) {
            System.debug('Creating Files related to WO');
            GDMFSL_CommonUtilities.insertRecords(toBeCreatedContentDocument);
            System.debug('Inserted number of File Records : ' + toBeCreatedContentDocument.size());
        }

    }

    @TestVisible
    private static void setSLAOnWO(List<WorkOrder> lstWorkOrders) {
        System.debug('Deriving SLA on WO now.');
        System.debug('Map Operating Hour  : ' + mapOperatingHours);
        for (WorkOrder wo : lstWorkOrders) {

            if (wo.MaintenancePlanId == null && wo.Work_Type_Category__c == GDMFSL_WorkTypeProcessor.WORKTYPECATEGORY_BF
                    && wo.ServiceContractId != null && scAssetCliItemMap.containsKey(wo.ServiceContractId)
                    && wo.AssetId != null && scAssetCliItemMap.get(wo.ServiceContractId).containsKey(wo.AssetId)
                    && !scAssetCliItemMap.get(wo.ServiceContractId).get(wo.AssetId).isEmpty()) {

                System.debug('Using SLAs from the CLI Asset');

                for (ContractLineItem theCLI : scAssetCliItemMap.get(wo.ServiceContractId).get(wo.AssetId)) {
                    System.debug('Checking CLI: ' + theCLI.Id);

                    if (theCLI.SLAs__r != null) {
                        for (GDMFSL_SLA__c sla : theCLI.SLAs__r) {
                            System.debug('Checking SLA: ' + sla.Id);

                            if (sla.GDMFSL_Priority__c == wo.Priority) {
                                System.debug('SLA matches: ' + sla.Id);
                                System.debug('SLA Response Time: ' + sla.GDMFSL_Response_Time__c);
                                System.debug('SLA Arrival Time: ' + sla.GDMFSL_Arrival_Time__c);
                                System.debug('SLA Resolution Time: ' + sla.GDMFSL_Resolution_Time__c);

                                wo.StartDate = wo.CreatedDate != null ? wo.CreatedDate : System.Datetime.now();
                                wo.StartDate = calculateSLAStartDate(wo, theCLI, 0, wo.StartDate);

                                if (sla.GDMFSL_Resolution_Time__c != null) {
                                    wo.EndDate = calculateSLAStartDate(wo, theCLI, (Integer) sla.GDMFSL_Resolution_Time__c, wo.StartDate);
                                    System.debug('WO END DATE calculation finished using CLI : ' + wo.EndDate);
                                }

                                if (sla.GDMFSL_Response_Time__c != null) {
                                    wo.GDMFSL_Response_Time__c = calculateSLAStartDate(wo, theCLI, (Integer) sla.GDMFSL_Response_Time__c, wo.StartDate);
                                    System.debug('WO RESPONSE DATE calculation finished using CLI : ' + wo.GDMFSL_Response_Time__c);
                                }

                                if (sla.GDMFSL_Arrival_Time__c != null) {
                                    wo.GDMFSL_Arrival_Time__c = calculateSLAStartDate(wo, theCLI, (Integer) sla.GDMFSL_Arrival_Time__c, wo.StartDate);
                                    System.debug('WO ARRIVAL DATE calculation finished using CLI : ' + wo.GDMFSL_Arrival_Time__c);
                                }

                                break;
                            }
                        }
                    }
                }
            } else if (wo.MaintenancePlanId == null && wo.Work_Type_Category__c == GDMFSL_WorkTypeProcessor.WORKTYPECATEGORY_BF
                    && wo.ServiceContractId != null && wo.LocationId != null && !mapAssociatedContract.isEmpty()) {

                System.debug('Using SLAs from the Associated Contract');

                for (GDMFSL_Associated_Contract__c ac : mapAssociatedContract.values()) {
                    System.debug('Associated Contract: ' + ac.Id);

                    if (ac.Location__c == wo.LocationId && ac.Service_Contract__c == wo.ServiceContractId && mapSLA.containsKey(ac.Id)) {

                        for (GDMFSL_SLA__c theSLA : mapSLA.get(ac.Id)) {
                            System.debug('Checking SLA: ' + theSLA.Id);

                            if (theSLA.GDMFSL_Priority__c == wo.Priority) {

                                System.debug('SLA matches');

                                wo.StartDate = wo.CreatedDate != null ? wo.CreatedDate : System.Datetime.now();
                                wo.StartDate = calculateSLAStartDate(wo, ac, 0, wo.StartDate);

                                if (theSLA.GDMFSL_Resolution_Time__c != null) {
                                    wo.EndDate = calculateSLAStartDate(wo, ac, (Integer) theSLA.GDMFSL_Resolution_Time__c, wo.StartDate);
                                    System.debug('WO END DATE calculation finished using ASSOCIATED CONTRACT : ' + wo.EndDate);
                                }

                                System.debug('WO START DATE calculation finished using ASSOCIATED CONTRACT : ' + wo.StartDate);
                                if (theSLA.GDMFSL_Response_Time__c != null) {
                                    wo.GDMFSL_Response_Time__c = calculateSLAStartDate(wo, ac, (Integer) theSLA.GDMFSL_Response_Time__c, wo.StartDate);
                                    System.debug('WO RESPONSE DATE calculation finished using ASSOCIATED CONTRACT : ' + wo.GDMFSL_Response_Time__c);
                                }

                                if (theSLA.GDMFSL_Arrival_Time__c != null) {
                                    wo.GDMFSL_Arrival_Time__c = calculateSLAStartDate(wo, ac, (Integer) theSLA.GDMFSL_Arrival_Time__c, wo.StartDate);
                                    System.debug('WO ARRIVAL DATE calculation finished using ASSOCIATED CONTRACT : ' + wo.GDMFSL_Arrival_Time__c);
                                }

                                break;
                            }
                        }
                    }
                }
            } else if (wo.MaintenancePlanId != null && mapMaintenancePlan.containsKey(wo.MaintenancePlanId)) {

                System.debug('Using SLAs from Maintenance Plan');
                System.debug('Suggested Maintenance Date on WO  : ' + wo.SuggestedMaintenanceDate);
                System.debug('Map of MP : ' + mapMaintenancePlan.get(wo.MaintenancePlanId));

                if (mapMaintenancePlan.get(wo.MaintenancePlanId).MaintenanceWindowStartDays != null
                        && wo.SuggestedMaintenanceDate != null) {

                    System.debug('Setting StartDate from MP MaintenanceWindowStartDays');
                    wo.StartDate = wo.SuggestedMaintenanceDate - mapMaintenancePlan.get(wo.MaintenancePlanId).MaintenanceWindowStartDays;

                } else {
                    System.debug('Setting StartDate from WO Suggested Date');
                    wo.StartDate = wo.SuggestedMaintenanceDate != null ? wo.SuggestedMaintenanceDate : Date.today();
                }

                System.debug('Start Date set to before TimeZone Adjustment : ' + wo.StartDate);

                if (mapMaintenancePlan.get(wo.MaintenancePlanId).MaintenanceWindowEndDays != null
                        && wo.SuggestedMaintenanceDate != null && mapMaintenancePlan.get(wo.MaintenancePlanId).MaintenanceWindowEndDays!=0) {

                    System.debug('Setting EndDate from MP MaintenanceWindowEndDays');
                    wo.EndDate = wo.SuggestedMaintenanceDate + mapMaintenancePlan.get(wo.MaintenancePlanId).MaintenanceWindowEndDays;
                } else {
                    System.debug('Setting EndDate based on WO Suggested Date');
                    wo.EndDate = wo.SuggestedMaintenanceDate != null ? wo.SuggestedMaintenanceDate.addDays(1) : Date.today().addDays(1);
                }

                System.debug('EndDate set to before looking for WorkRule Adjustment Logic: ' + wo.EndDate);

                if (wo.MaintenanceWorkRuleId != null
                        && mapMaintenanceWorkRule.containsKey(wo.MaintenanceWorkRuleId)
                        && mapMaintenanceWorkRule.get(wo.MaintenanceWorkRuleId).RecurrencePattern.containsIgnoreCase('FREQ=MONTHLY')) {

                    System.debug('Adjust EndDate to 15th or last day in month when the WO.MaintWorkRule is Monthly');
                    System.debug('WO StartDate Month & End Date Month : ' + wo.StartDate.month() + ' & ' + wo.EndDate.month());

                    if (wo.StartDate.monthGmt() == wo.EndDate.monthGmt()) {
                        System.debug('EndDate is in the same month as StartDate');

                        Integer dayToUse = wo.EndDate.dayGmt() < 16 ? 15 : Date.daysInMonth(wo.EndDate.yearGmt(), wo.EndDate.monthGmt());

                        System.debug('Adjusting EndDate day from: ' + wo.EndDate.dayGmt() + ' to ' + dayToUse);

                        wo.EndDate = Datetime.newInstance(wo.EndDate.year(), wo.EndDate.month(), dayToUse, wo.EndDate.hour(), wo.EndDate.minute(), wo.EndDate.second());

                    } else if (wo.StartDate.monthGmt() != wo.EndDate.monthGmt()) {
                        System.debug('EndDate is in different Month than StartDate - setting to last day of the StartDate Month');

                        wo.EndDate = Datetime.newInstance(wo.StartDate.year(), wo.StartDate.month(), Date.daysInMonth(wo.StartDate.year(), wo.StartDate.month()), wo.EndDate.hour(), wo.EndDate.minute(), wo.EndDate.second());
                        System.debug('EndDate set as end of StartDate Month: ' + wo.EndDate);
                    }

                    System.debug('EndDate adjusted from Monthly MaintWorkRule is: ' + wo.EndDate);
                }
                wo.StartDate = GDMFSL_CommonUtilities.addTimeZoneOffset(wo.StartDate, mapMaintenancePlan.get(wo.MaintenancePlanId).Location.GDMFSL_Service_Territory__r.OperatingHours.TimeZone);
                System.debug('StartDate after TimeZone Adjustment: ' + wo.StartDate);
                System.debug('End Date set to before TimeZone Adjustment : ' + wo.EndDate);
                wo.EndDate = GDMFSL_CommonUtilities.addTimeZoneOffset(wo.EndDate, mapMaintenancePlan.get(wo.MaintenancePlanId).Location.GDMFSL_Service_Territory__r.OperatingHours.TimeZone);
                System.debug('End Date set to after TimeZone Adjustment : ' + wo.EndDate);
                wo.EndDate = wo.EndDate.addMinutes(-1);
                System.debug('Final EndDate time : ' + wo.EndDate);
            }

            System.debug('WO Response Time currently: ' + wo.GDMFSL_Response_Time__c);
            System.debug('WO Arrival Time currently: ' + wo.GDMFSL_Arrival_Time__c);

            System.debug('Trying to set Response Time and Arrival Time from WorkType if not set');

            if (wo.Work_Type_Category__c == GDMFSL_WorkTypeProcessor.WORKTYPECATEGORY_BF
                    && wo.GDMFSL_Response_Time__c == null
                    && wo.WorkTypeId != null
                    && mapWorkType.containsKey(wo.WorkTypeId)) {

                wo.GDMFSL_Response_Time__c = mapWorkType.get(wo.WorkTypeId).GDMFSL_Response_Time_Offset__c != null ? wo.StartDate.addMinutes((Integer) mapWorkType.get(wo.WorkTypeId).GDMFSL_Response_Time_Offset__c) : null;
                System.debug('WO Response Time set to: ' + wo.GDMFSL_Response_Time__c);
            }

            if (wo.Work_Type_Category__c == GDMFSL_WorkTypeProcessor.WORKTYPECATEGORY_BF
                    && wo.GDMFSL_Arrival_Time__c == null
                    && wo.WorkTypeId != null
                    && mapWorkType.containsKey(wo.WorkTypeId)) {

                wo.GDMFSL_Arrival_Time__c = mapWorkType.get(wo.WorkTypeId).GDMFSL_Arrival_Time_Offset__c != null ? wo.StartDate.addMinutes((Integer) mapWorkType.get(wo.WorkTypeId).GDMFSL_Arrival_Time_Offset__c) : null;
                System.debug('WO Arrival Time set to: ' + wo.GDMFSL_Arrival_Time__c);
            }

            System.debug('Checking if WO Start Date is not yet dervied set it to a DEFAULT one');
            if (wo.StartDate == null) {

                System.debug('Start Date & EndDate on WorkOrder not yet derived so setting it up to default');
                wo.StartDate = System.Datetime.now();
                System.debug('Start Date set from default to : ' + wo.StartDate);
                if (mapWorkType.containsKey(wo.WorkTypeId) && mapWorkType.get(wo.WorkTypeId).FSL__Due_Date_Offset__c != null) {
                    wo.EndDate = wo.StartDate.addMinutes((Integer) mapWorkType.get(wo.WorkTypeId).FSL__Due_Date_Offset__c);
                } else {
                    wo.EndDate = wo.StartDate.addDays(DEFAULTENDDATEOFFSET_DAYS);
                }
                System.debug('End Date set from default to : ' + wo.EndDate);
            }

            System.debug('WO Response Time set to: ' + wo.GDMFSL_Response_Time__c);
            System.debug('WO Arrival Time set to: ' + wo.GDMFSL_Arrival_Time__c);
            System.debug('WO StartDate set to: ' + wo.StartDate);
            System.debug('WO EndDate set to: ' + wo.EndDate);
        }
    }

    @TestVisible
    private static Datetime calculateSLAStartDate(WorkOrder w, SObject sObj, Integer numberOfHoursToAdd, Datetime finalDate) {

        System.debug('Date Passed to calculate SLA : ' + finalDate);
        Boolean Is24HrBusinessDaysCoverage = false;
        Boolean IsAfterHourCoverage = false;
        Boolean IsHolidayNoCoverage = false;
        Boolean Is24HrCoverage = false;
        Boolean IsBusinessHourCoverage = false;
        if (sObj.getSObjectType() == ContractLineItem.getSObjectType()) {
            System.debug('Passed Sobject is a CLI');
            Is24HrBusinessDaysCoverage = (Boolean) sObj.get('GDMFSL_24HrCoverage_BusinessDays__c');
            IsAfterHourCoverage = (Boolean) sObj.get('GDMFSL_After_Hr_Reactive_Response__c');
            IsHolidayNoCoverage = (Boolean) sObj.get('GDMFSL_HolidayNoReactiveCoverage__c');
            Is24HrCoverage = (Boolean) sObj.get('GDMFSL_X24hr_Reactive_Response__c');
            IsBusinessHourCoverage = (Boolean) sObj.get('GDMFSL_Office_Hr_Reactive_Response__c');
        } else if (sObj.getSObjectType() == GDMFSL_Associated_Contract__c.getSObjectType()) {
            System.debug('Passed Sobject is an Associated Contract');
            Is24HrBusinessDaysCoverage = (Boolean) sObj.getSObject ('Service_Contract__r').get('GDMFSL_24HrCoverage_BusinessDays__c');
            IsAfterHourCoverage = (Boolean) sObj.getSObject ('Service_Contract__r').get('GDMFSL_After_Hr_Reactive_Response__c');
            IsHolidayNoCoverage = (Boolean) sObj.getSObject ('Service_Contract__r').get('GDMFSL_HolidayNoReactiveCoverage__c');
            Is24HrCoverage = (Boolean) sObj.getSObject ('Service_Contract__r').get('GDMFSL_X24hr_Reactive_Response__c');
            IsBusinessHourCoverage = (Boolean) sObj.getSObject ('Service_Contract__r').get('GDMFSL_Office_Hr_Reactive_Response__c');

        }
        Id woOperatingHourId = null;
        String timeZoneOperatingHours = null;

        System.debug('Finding Operating Hour');
        if (w.LocationId != null
                && mapLocations.containsKey(w.LocationId)
                && mapLocations.get(w.LocationId).GDMFSL_Working_Hours__c != null) {

            woOperatingHourId = mapLocations.get(w.LocationId).GDMFSL_Working_Hours__c;
            timeZoneOperatingHours = mapLocations.get(w.LocationId).GDMFSL_Working_Hours__r.TimeZone;

        } else if (w.ServiceTerritoryId != null
                && mapServiceTerritory.containsKey(w.ServiceTerritoryId)
                && mapServiceTerritory.get(w.ServiceTerritoryId).OperatingHoursId != null) {

            woOperatingHourId = mapServiceTerritory.get(w.ServiceTerritoryId).OperatingHoursId;
            timeZoneOperatingHours = mapServiceTerritory.get(w.ServiceTerritoryId).OperatingHours.TimeZone;
        }

        System.debug('Operating Hour being used is : ' + woOperatingHourId);
        System.debug('Operating Hour Map : ' + mapOperatingHours);
        if (mapOperatingHours.containsKey(woOperatingHourId)
                && mapOperatingHours.get(woOperatingHourId).TimeSlots.size() > 0) {

            if (timeZoneOperatingHours != null
                    && (numberOfHoursToAdd == 0 || numberOfHoursToAdd == null)) {

                Datetime StartDateInOperatingHourTz = GDMFSL_CommonUtilities.subtractTimeZoneOffset(finalDate, timeZoneOperatingHours);
                finalDate = StartDateInOperatingHourTz;
                System.debug('The converted DateTime of Start Date in Operating Hour TimeZone is: ' + StartDateInOperatingHourTz);
            }

            if (numberOfHoursToAdd > 0) {

                Datetime StartDateInOperatingHourTz = GDMFSL_CommonUtilities.subtractTimeZoneOffset(finalDate, timeZoneOperatingHours);
                finalDate = StartDateInOperatingHourTz;
                System.debug('The converted DateTime of Passed Date for Addition in Operating Hour TimeZone is: ' + StartDateInOperatingHourTz);
            }

            if (IsHolidayNoCoverage) {
                finalDate = checkOrGetNextBusinessDay(woOperatingHourId, finalDate, true, !IsHolidayNoCoverage);
            }

            if (Is24HrCoverage) {
                System.debug('24/7 coverage is true');
                if (numberOfHoursToAdd == null || numberOfHoursToAdd == 0) {
                    System.debug('Calculating the Start Date of WO');
                    finalDate = checkOrGetNextBusinessDay(woOperatingHourId, finalDate, true, !IsHolidayNoCoverage);
                } else {
                    finalDate = checkOrGetNextBusinessDay(woOperatingHourId, finalDate, true, !IsHolidayNoCoverage);
                    finalDate = finalDate.addHours(numberOfHoursToAdd);
                }
            } else if (Is24HrBusinessDaysCoverage) {
                System.debug('24 Hours business Day Coverage is True');
                if (numberOfHoursToAdd == null || numberOfHoursToAdd == 0) {
                    finalDate = checkOrGetNextBusinessDay(woOperatingHourId, finalDate, false, !IsHolidayNoCoverage);
                } else {
                    finalDate = checkOrGetNextBusinessDay(woOperatingHourId, finalDate, false, !IsHolidayNoCoverage);
                    finalDate = getDateAfterAddingHours(woOperatingHourId, finalDate, numberOfHoursToAdd, true, true, !IsHolidayNoCoverage);
                }

            } else if (IsBusinessHourCoverage || IsAfterHourCoverage) {

                System.debug('Business Hour Coverage is :' + IsBusinessHourCoverage);
                System.debug('AfterHour Coverage is : ' + IsAfterHourCoverage);

                if (numberOfHoursToAdd == null || numberOfHoursToAdd == 0) {
                    finalDate = getBusinessHoursStartDate(woOperatingHourId, finalDate, IsBusinessHourCoverage, IsAfterHourCoverage, !IsHolidayNoCoverage);
                } else {
                    finalDate = getDateAfterAddingHours(woOperatingHourId, finalDate, numberOfHoursToAdd, IsBusinessHourCoverage, false, !IsHolidayNoCoverage);
                }
            } else {
                numberOfHoursToAdd = numberOfHoursToAdd == null ? 0 : numberOfHoursToAdd;
                finalDate = finalDate.addHours(numberOfHoursToAdd);
            }

            if (timeZoneOperatingHours != null) {
                finalDate = GDMFSL_CommonUtilities.addTimeZoneOffset(finalDate, timeZoneOperatingHours);
            }

        } else {
            System.debug('No Time Slots Defined within Operating Hour or No Operating Hour Fetched');
            numberOfHoursToAdd = numberOfHoursToAdd == null ? 0 : numberOfHoursToAdd;
            finalDate = finalDate.addHours(numberOfHoursToAdd);
        }

        return finalDate;
    }

    @TestVisible
    private static Datetime checkOrGetNextBusinessDay(Id operatingHoursId, Datetime toBeCheckedDate, Boolean includeWeekends, Boolean ignoreHolidays) {

        Datetime derivedDate = toBeCheckedDate;
        Boolean fetchedTheNextBusinessDay = false;
        Boolean derivedDateNotAHoliday = false;
        Boolean isABusinessDay = false;
        if (!mapOperatingHours.isEmpty() && mapOperatingHours.containsKey(operatingHoursId)) {

            if (!ignoreHolidays || !includeWeekends) {


                while (fetchedTheNextBusinessDay == false) {

                    System.debug('Still fetching Next Business Day');
                    if (!ignoreHolidays) {
                        System.debug('Need to check if the Passed date is a Holiday');
                        if (isDateAHolidayForOperatingHours(operatingHoursId, derivedDate)) {
                            System.debug('Passed Date was a Holiday,Move on to Next Day');
                            derivedDate = derivedDate.addDays(1);
                        } else {
                            System.debug('Passed Date is not a Holiday : ' + derivedDate);
                            derivedDateNotAHoliday = true;
                            if (includeWeekends) {
                                System.debug('As include Weekends is TRUE ,no need to run the logic to check for weekends');
                                fetchedTheNextBusinessDay = true;
                                break;
                            }
                        }
                    }

                    if ((ignoreHolidays || derivedDateNotAHoliday) && !includeWeekends) {
                        System.debug('Till Now Derived Date is not a Holiday  :' + derivedDate);
                        System.debug('Checking if it lies on a non Working Day');
                        if (mapOperatingHours.get(operatingHoursId).TimeSlots == null || mapOperatingHours.get(operatingHoursId).TimeSlots.size() == 0) {
                            fetchedTheNextBusinessDay = true;
                        } else {
                            for (TimeSlot ts : mapOperatingHours.get(operatingHoursId).TimeSlots) {
                                if (derivedDate.format('EEEE') == ts.DayOfWeek) {
                                    isABusinessDay = true;
                                    fetchedTheNextBusinessDay = true;
                                    System.debug('Date derived currently is in a Business Day');
                                    break;
                                }
                            }
                            if (!isABusinessDay) {
                                System.debug('Current Date in Process is not a working day');
                                derivedDate = derivedDate.addDays(1);
                            }

                        }
                    }

                }
            }
        }

        System.debug('Business Day derived is  : ' + derivedDate);
        return derivedDate;
    }

    @TestVisible
    private static Datetime getBusinessHoursStartDate(Id operatingHoursId, Datetime toBeCheckedDate, Boolean considerBusinessHours, Boolean considerAfterHours, Boolean ignoreHolidays) {

        System.debug('The Date passed should be a Business Day  : ' + toBeCheckedDate);
        Datetime derivedDate = checkOrGetNextBusinessDay(operatingHoursId, toBeCheckedDate, false, ignoreHolidays);
        System.debug('Date Which was passed to the method : ' + toBeCheckedDate);
        System.debug('If the Start Date which was passed is a Holiday Or Weekend then the Business Day would be returned or it will be same : ' + derivedDate);


        Time derivedDateTime = derivedDate.timeGmt();
        System.debug('Derived DateTime in GMT is :' + derivedDateTime);
        Boolean isDateDerivationDone = false;

        if (!mapOperatingHours.isEmpty() && mapOperatingHours.containsKey(operatingHoursId) && mapOperatingHours.get(operatingHoursId).TimeSlots.size() > 0) {

            while (!isDateDerivationDone) {

                System.debug('Still in the While Loop Current Passed Date is : ' + derivedDate);
                derivedDateTime = derivedDate.timeGmt();
                for (TimeSlot ts : mapOperatingHours.get(operatingHoursId).TimeSlots) {
                    if (derivedDate.format('EEEE') == ts.DayOfWeek) {

                        if (derivedDate != toBeCheckedDate) {
                            System.debug('Check if the Date Passed and Date Derived do not match then will have to set the Time Part of the Derived Date to be ');
                            if (considerBusinessHours) {
                                derivedDate = Datetime.newInstanceGmt(derivedDate.date(), ts.StartTime);
                            } else {
                                derivedDate = Datetime.newInstanceGmt(derivedDate.date(), Time.newInstance(00, 00, 00, 0));
                            }
                        }
                        derivedDateTime = derivedDate.timeGmt();
                        System.debug('Time Slot Start Time & End Time: ' + ts.StartTime + ' : ' + ts.EndTime);

                        if (ts.StartTime <= derivedDateTime && derivedDateTime <= ts.EndTime) {
                            System.debug('Current Date Time lies between Business Hours : ' + derivedDateTime);
                            if (considerBusinessHours) {
                                isDateDerivationDone = true;
                                break;
                            } else if (considerAfterHours) {
                                derivedDate = Datetime.newInstanceGmt(derivedDate.date(), ts.EndTime);
                                System.debug('As current Time lies between business hours ,setting it to start at end of Business Hours : ' + derivedDateTime);
                                isDateDerivationDone = true;
                                break;
                            } else {
                                System.debug('After Hour ,Business Hour both are false,just exit');
                                isDateDerivationDone = true;
                                break;
                            }
                        } else {
                            System.debug('Current Time not within the Business Hours : ' + derivedDateTime);
                            if (considerAfterHours) {

                                System.debug('As it is After Hours Case ,the Date is already not within Business Hours : ' + derivedDate);
                                isDateDerivationDone = true;
                                break;

                            } else if (considerBusinessHours) {
                                if (derivedDateTime <= ts.StartTime) {
                                    System.debug('Date is within Business Date but before Business Hours');
                                    derivedDate = Datetime.newInstanceGmt(derivedDate.date(), ts.StartTime);
                                    System.debug('Date Set to be within Business Date and at the Start of Business Hours: ' + derivedDate);
                                    isDateDerivationDone = true;
                                    break;
                                } else {
                                    System.debug('Date is within Business Day but after the business hours,so will have to move it to next day start of business hour');
                                    derivedDate = checkOrGetNextBusinessDay(operatingHoursId, derivedDate.addDays(1), false, ignoreHolidays);
                                    derivedDate = Datetime.newInstanceGmt(derivedDate.date(), ts.StartTime);
                                    System.debug('Next Business Day found is  : ' + derivedDate);
                                    break;
                                }
                            } else {
                                System.debug('After Hour ,Business Hour both are false,just exit');
                                isDateDerivationDone = true;
                                break;
                            }

                        }
                    }

                }

            }
        }
        System.debug('Final Date Derived is  : ' + derivedDate);
        return derivedDate;
    }

    @TestVisible
    private static Datetime getDateAfterAddingHours(Id OperatingHoursId, Datetime toBeUsedDate, Integer numberOfHours, Boolean considerBusinessHours, Boolean is24HoursValid, Boolean ignoreHolidays) {

        toBeUsedDate = checkOrGetNextBusinessDay(OperatingHoursId, toBeUsedDate, false, ignoreHolidays);
        System.debug('The Date should be a Business Day : ' + toBeUsedDate);
        Datetime dateReceived = toBeUsedDate;
        Datetime calculatedDate = toBeUsedDate;
        Integer numberOfHoursLeft = numberOfHours;
        Integer totalTimeWithinTS;
        Integer timeLeftToday = 0;
        Time midnightTime = Time.newInstance(00, 00, 00, 0);
        Integer tobeUsedTimeHour;

        System.debug('mapOperatingHours.containsKey(OperatingHoursId)' + mapOperatingHours.containsKey(OperatingHoursId));
        System.debug('mapOperatingHours' + mapOperatingHours);
        System.debug('!mapOperatingHours.get(OperatingHoursId).TimeSlots.isEmpty()' + !mapOperatingHours.get(OperatingHoursId).TimeSlots.isEmpty());

        if (mapOperatingHours.containsKey(OperatingHoursId) && !mapOperatingHours.get(OperatingHoursId).TimeSlots.isEmpty()) {

            while (numberOfHoursLeft > 0) {

                System.debug('The number of hours are still greater than 0');
                Time toBeUsedTime = toBeUsedDate.timeGmt();
                System.debug('Current Passed Time part :' + toBeUsedTime);


                for (TimeSlot ts : mapOperatingHours.get(OperatingHoursId).TimeSlots) {

                    if (toBeUsedDate.format('EEEE') == ts.DayOfWeek) {
                        System.debug('Date Recieved: ' + dateReceived);
                        System.debug('To Be Used Date: ' + toBeUsedDate);

                        if (dateReceived != toBeUsedDate) {
                            System.debug('Initial Date Passed was  :' + dateReceived);
                            System.debug('Current Date Passed is  :' + toBeUsedDate);
                            if (is24HoursValid) {
                                toBeUsedDate = Datetime.newInstanceGmt(toBeUsedDate.date(), midnightTime);
                            } else if (considerBusinessHours) {
                                System.debug('As Before Hours is true,for the next day need to set the time to start at the Time Slot start Time');
                                toBeUsedDate = Datetime.newInstanceGmt(toBeUsedDate.date(), ts.StartTime);
                                System.debug('Current Passed Date now set to : ' + toBeUsedDate);
                            } else if (!considerBusinessHours) {
                                System.debug('Current Passed Date now set to : ' + toBeUsedDate);
                            }
                            toBeUsedTime = toBeUsedDate.timeGmt();

                        }

                        totalTimeWithinTS = ts.EndTime.hour() - ts.StartTime.hour();
                        System.debug('Total Time Duration  in between slot :  ' + totalTimeWithinTS);

                        if (considerBusinessHours) {

                            tobeUsedTimeHour = toBeUsedTime.hour();
                            if (toBeUsedTime.minute() > 30) {
                                tobeUsedTimeHour = tobeUsedTimeHour + 1;
                            }
                            if (is24HoursValid) {
                                timeLeftToday = 24 - tobeUsedTimeHour;
                                System.debug('As SLA can be worked 24Hours on a Business Day then Number of hours left to be worked on next day would be  : ' + numberOfHoursLeft) ;
                            } else if (ts.StartTime <= toBeUsedTime && toBeUsedTime <= ts.EndTime) {
                                tobeUsedTimeHour = toBeUsedTime.hour();
                                if (toBeUsedTime.minute() > 30) {
                                    tobeUsedTimeHour = tobeUsedTimeHour + 1;
                                }
                                timeLeftToday = ts.EndTime.hour() - tobeUsedTimeHour;
                                System.debug('Time Slot End Time:' + ts.EndTime);
                                System.debug('Hours Left Today before Business Hour end is  : ' + timeLeftToday);
                                System.debug('Number of Hours Left : ' + numberOfHoursLeft);

                            } else {
                                System.debug('Should never be here ,as it should be a business day and Time should lie between Business Hours');
                                numberOfHoursLeft = 0;
                            }
                            if (numberOfHoursLeft <= timeLeftToday) {
                                System.debug('Number of Hours Left will fit in the current dates business hours : ' + numberOfHoursLeft);
                                calculatedDate = toBeUsedDate.addHours(numberOfHoursLeft);
                                numberOfHoursLeft = numberOfHoursLeft - timeLeftToday;
                                break;
                            } else {
                                System.debug('Number Of Hour Left is more than what can fit in Today : ' + numberOfHoursLeft);
                                if (numberOfHoursLeft > 0) {
                                    System.debug('Number of Hours Left to be added now is : ' + numberOfHoursLeft);
                                    numberOfHoursLeft = numberOfHoursLeft - timeLeftToday;
                                    toBeUsedDate = toBeUsedDate.addHours(timeLeftToday);
                                    System.debug('Date and Time which could be consumed within todays Business Day : ' + toBeUsedDate);
                                    System.debug('To Work Within the Business Hour will have to check the next business day and add remaining hours to those');
                                    toBeUsedDate = checkOrGetNextBusinessDay(OperatingHoursId, toBeUsedDate.addDays(1), false, ignoreHolidays);
                                }
                            }
                        } else {

                            System.debug('The SLA needs to be in After Hours');
                            tobeUsedTimeHour = toBeUsedTime.hour();
                            if (toBeUsedTime.minute() > 30) {
                                tobeUsedTimeHour = tobeUsedTimeHour + 1;
                            }
                            Integer hoursBetweenEndOfBHAndMidnight = 24 - ts.EndTime.hour();
                            System.debug('Hours left from End Of Business HOurs to MidNight: ' + hoursBetweenEndOfBHAndMidnight);
                            System.debug('Time part of currently passed date :' + toBeUsedTime);
                            if (ts.StartTime <= toBeUsedTime && toBeUsedTime <= ts.EndTime) {
                                System.debug('Time is between the Business Hours move the time of the current Date to End Time of the Slot');
                                toBeUsedDate = Datetime.newInstanceGmt(toBeUsedDate.date(), ts.EndTime);
                                toBeUsedTime = toBeUsedDate.timeGmt();
                                System.debug('Date after moving to end of Slot :' + toBeUsedDate);
                                System.debug('To Be Used Time changed to :' + toBeUsedTime);
                            }
                            if (toBeUsedTime <= ts.StartTime) {
                                System.debug('Current Date Time is less than the Start Time of the Slot');
                                Integer timeTillStartOfBH = ts.StartTime.hour() - tobeUsedTimeHour;
                                System.debug('Hours available till the start of Business Hour :' + timeTillStartOfBH);
                                System.debug('Number of Hours Left to be adjusted   :' + numberOfHoursLeft);
                                if (numberOfHoursLeft < timeTillStartOfBH) {
                                    System.debug('As Number of Hours Left is Less than available hours before Business Start Time');
                                    toBeUsedDate = toBeUsedDate.addHours(numberOfHoursLeft);
                                    numberOfHoursLeft = numberOfHoursLeft - timeTillStartOfBH;
                                    calculatedDate = toBeUsedDate;
                                    break;
                                } else {
                                    System.debug('Can add these many hours till start of Business Hour comes : ' + timeTillStartOfBH);
                                    toBeUsedDate = toBeUsedDate.addHours(timeTillStartOfBH);
                                    toBeUsedTime = toBeUsedDate.timeGmt();
                                    numberOfHoursLeft = numberOfHoursLeft - timeTillStartOfBH;
                                    System.debug('Number Of Hours left now after adding hours to the date till start of Business Hour :' + numberOfHoursLeft);
                                    if (numberOfHoursLeft > hoursBetweenEndOfBHAndMidnight) {
                                        System.debug('Need to move to End Time of Business Hours and add rest of the Hours');
                                        System.debug('Number Of hours after Left Now : ' + numberOfHoursLeft);
                                        toBeUsedDate = Datetime.newInstanceGmt(toBeUsedDate.date(), ts.EndTime);
                                        toBeUsedDate = toBeUsedDate.addHours(hoursBetweenEndOfBHAndMidnight);
                                        toBeUsedTime = toBeUsedDate.timeGmt();
                                        numberOfHoursLeft = numberOfHoursLeft - hoursBetweenEndOfBHAndMidnight;
                                        toBeUsedDate = checkOrGetNextBusinessDay(OperatingHoursId, toBeUsedDate, false, ignoreHolidays);
                                        toBeUsedTime = toBeUsedDate.timeGmt();
                                    } else if (numberOfHoursLeft == 0) {
                                        calculatedDate = toBeUsedDate;
                                        break;
                                    } else {
                                        toBeUsedDate = Datetime.newInstanceGmt(toBeUsedDate.date(), ts.EndTime);
                                        calculatedDate = toBeUsedDate.addHours(numberOfHoursLeft);
                                        numberOfHoursLeft = numberOfHoursLeft - hoursBetweenEndOfBHAndMidnight;
                                        System.debug('Number Of hours Left after moving the date to End Time of Business Hour and as hours can be adjusted till Midnight :' + numberOfHoursLeft);
                                        break;
                                    }
                                }
                            } else if (toBeUsedTime >= ts.EndTime) {
                                System.debug('Current Date Time is greater than or equal to the End Time of the Slot');
                                System.debug('Number Of Hours Left till now to be added: ' + numberOfHoursLeft);
                                if (numberOfHoursLeft > hoursBetweenEndOfBHAndMidnight) {
                                    System.debug('Hours Left is more than what can be add to the current Day,we can only add :' + hoursBetweenEndOfBHAndMidnight);
                                    toBeUsedDate = toBeUsedDate.addHours(hoursBetweenEndOfBHAndMidnight);
                                    System.debug('Current Date after adding hours till midnight : ' + toBeUsedDate);
                                    System.debug('Number Of Hours Left after adding the Hours for that day  :' + (numberOfHoursLeft - hoursBetweenEndOfBHAndMidnight));
                                    toBeUsedDate = checkOrGetNextBusinessDay(OperatingHoursId, toBeUsedDate, false, ignoreHolidays);
                                    toBeUsedTime = toBeUsedDate.timeGmt();
                                    System.debug('Moving on with the next Business Day now : ' + toBeUsedDate);
                                    numberOfHoursLeft = numberOfHoursLeft - hoursBetweenEndOfBHAndMidnight;
                                } else {
                                    calculatedDate = toBeUsedDate.addHours(numberOfHoursLeft);
                                    numberOfHoursLeft = numberOfHoursLeft - hoursBetweenEndOfBHAndMidnight;
                                    System.debug('As Number of Hours can be adjusted in the same day after hours,number of hours left will be :' + numberOfHoursLeft);
                                    break;
                                }
                            }

                        }
                        break;
                    }

                }

            }
        }
        System.debug('Date Being returned after adding Hours is  :' + calculatedDate);
        return calculatedDate;
    }

    @TestVisible
    private static void setSAPAccountNumbersOnWO(List<WorkOrder> theWOs, Map<Id, WorkOrder> oldRecs) {
        System.debug('Inside Method to derive Account Numbers on WO');

        for (WorkOrder wo : theWOs) {

            if ((oldRecs == null || (oldRecs.get(wo.Id).WorkTypeId != wo.WorkTypeId)
                    || (oldRecs.get(wo.Id).ServiceContractId != wo.ServiceContractId) ||
                    (oldRecs.get(wo.Id).LocationId != wo.LocationId))) {

                System.debug('WorkOrder is newly Created or WorkType,Service Contract or Location on WO was updated');

                if (wo.LocationId != null && !mapLocations.isEmpty() && mapLocations.containsKey(wo.LocationId)
                        && mapLocations.get(wo.LocationId).GDMFSL_SAP_Customer_Number__c != null && wo.GDMFSL_Ship_To_Source__c == null) {
                    wo.GDMFSL_Ship_To_Source__c = mapLocations.get(wo.LocationId).GDMFSL_SAP_Customer_Number__c;
                    System.debug('WO SHIP TO Source set to : ' + wo.GDMFSL_Ship_To_Source__c);
                }
                if (wo.ServiceContractId != null && !mapServiceContracts.isEmpty() && mapServiceContracts.containsKey(wo.ServiceContractId)) {
                    System.debug('Deriving Bill To Sold To Account Numbers for WO from Service Contract : ' + wo.WorkOrderNumber);

                    if (wo.AccountId == null) {
                        wo.AccountId = mapServiceContracts.get(wo.ServiceContractId).AccountId;
                        System.debug('WO Sold To Account Set to  : ' + wo.AccountId);
                    }
                    if (wo.GDMFSL_Bill_to_Account__c == null) {
                        wo.GDMFSL_Bill_to_Account__c = mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Bill_to_Account__c;
                        System.debug('WO Bill To Account Set to  : ' + wo.GDMFSL_Bill_to_Account__c);
                    }
                    if (wo.GDMFSL_Bill_To_Source__c == null) {
                        wo.GDMFSL_Bill_To_Source__c = mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Bill_To_Account_Number__c;
                        System.debug('WO Bill To Account Number Set to  : ' + wo.GDMFSL_Bill_To_Source__c);
                    }
                    if (wo.GDMFSL_Sold_To_Source__c == null) {
                        wo.GDMFSL_Sold_To_Source__c = mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Sold_To_Account_Number__c;
                        System.debug('WO Sold To Account Number Set to  : ' + wo.GDMFSL_Sold_To_Source__c);
                    }
                    if (wo.GDMFSL_Sold_To_Source_System_Reference__c == null) {
                        wo.GDMFSL_Sold_To_Source_System_Reference__c = mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Sold_To_Source_System__c;
                        System.debug('WO Sold To Source System Ref Set to  : ' + wo.GDMFSL_Sold_To_Source_System_Reference__c);
                    }
                    if (wo.GDMFSL_Bill_To_Source_System_Reference__c == null) {
                        wo.GDMFSL_Bill_To_Source_System_Reference__c = mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Bill_To_Source_System__c;
                        System.debug('WO BillGDMFSL_Ship_To_Source__c To Source System Ref Set to  : ' + wo.GDMFSL_Bill_To_Source_System_Reference__c);
                    }
                    if (wo.GDMFSL_Sales_Office__c == null) {
                        wo.GDMFSL_Sales_Office__c = mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Sales_Office__c;
                        System.debug('WO Sales Off Set to  : ' + wo.GDMFSL_Sales_Office__c);
                    }
                    if (wo.GDMFSL_Sales_Organization__c == null || mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Sales_Organization__c != null) {
                        System.debug('The Sales Org will be overridden if there is a Sales Org on Service Contract');
                        wo.GDMFSL_Sales_Organization__c = mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Sales_Organization__c;
                        System.debug('WO Sales Organization Set to  : ' + wo.GDMFSL_Sales_Organization__c);
                    }
                    if (mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Distribution_Channel__c != null) {
                        System.debug('Found a Distribution Channel on SC,overriding the default value of 10');
                        wo.GDMFSL_Distribution_Channel__c = mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Distribution_Channel__c;
                        System.debug('WO Distribution Channel Set to  : ' + wo.GDMFSL_Distribution_Channel__c);
                    }
                }
            }
        }
    }

    @TestVisible
    private static void setJobTypeOnWO(List<WorkOrder> theWOs, Map<Id, WorkOrder> oldRecs) {

        List<WorkOrder> woWithNoJobType = new List<WorkOrder>();
        Set<Id> workTypeIds = new Set<Id>();
        Set<String> workTypeCategory = new Set<String>();

        for (WorkOrder wo : theWOs) {
            if (oldRecs == null || (oldRecs.get(wo.Id).WorkTypeId != wo.WorkTypeId)) {

                if (wo.SAP_Job_Type__c == null) {
                    woWithNoJobType.add(wo);
                    if (wo.Work_Type_Category__c != null) {
                        workTypeCategory.add(wo.Work_Type_Category__c);
                    } else {
                        if (wo.WorkTypeId != null) {
                            workTypeIds.add(wo.WorkTypeId);
                        }
                    }
                }
            }
        }

        Map<Id, WorkType> mapWorkType = new Map<Id, WorkType>();

        if (!workTypeIds.isEmpty()) {
            System.debug('Not All WorkOrders have WorkTypeId Populated');
            mapWorkType = GDMFSL_WorkTypeProcessor.getRecords(workTypeIds);
        }

        for (WorkType wt : mapWorkType.values()) {
            workTypeCategory.add(wt.GDMFSL_WorkType_Category__c);
        }

        System.debug('Related WorkTypeCategories on the WorkOrder : ' + workTypeCategory);

        Map<String, List<GDMFSL_Job_Type_Mapping__mdt>> mapJobTypeMapping = getJobTypeMappingByWorkTypeCat(workTypeCategory);

        System.debug('Number of records fetched from the Job Type Mapping : ' + mapJobTypeMapping);

        if (!mapJobTypeMapping.isEmpty()) {

            for (WorkOrder wo : woWithNoJobType) {

                System.debug('Working on WO: ' + wo.Id);

                Boolean woHasSC = wo.ServiceContractId != null ? true : false;
                System.debug('Wo Has Service Contract : ' + woHasSC);

                String workTypeCategoryName = (wo.Work_Type_Category__c == null && mapWorkType.containsKey(wo.WorkTypeId)) ? mapWorkType.get(wo.WorkTypeId).GDMFSL_WorkType_Category__c : wo.Work_Type_Category__c;
                System.debug('WO workTypeCategoryName : ' + workTypeCategoryName);

                if (mapJobTypeMapping.containsKey(workTypeCategoryName)) {

                    for (GDMFSL_Job_Type_Mapping__mdt jobType : mapJobTypeMapping.get(workTypeCategoryName)) {

                        System.debug('Job Type Mapping: ' + jobType);
                        if (wo.GDMFSL_Chargeable__c == jobType.GDMFSL_Chargeable__c
                                && woHasSC == jobType.GDMFSL_HasServiceContract__c
                                && workTypeCategoryName == jobType.GDMFSL_WorkType_Category__c) {
                            System.debug('Inside IF to set JobType to : '+jobType.SAP_JobType__c);
                            wo.SAP_Job_Type__c = jobType.SAP_JobType__c;
                            System.debug('JobType for WorkOrder : ' + wo.WorkOrderNumber + 'being set to : ' + wo.SAP_Job_Type__c);
                            break;
                        }
                    }
                }
            }
        }
    }


    @TestVisible
    private static Map<String, List<GDMFSL_Job_Type_Mapping__mdt>> getJobTypeMappingByWorkTypeCat(Set<String> workTypeCategories) {

        if (workTypeCategories != null && !workTypeCategories.isEmpty()) {

            Set<String> newWTypeCats = new Set<String>();

            if (mapWorkTypeCategoryToJobTypes.isEmpty()) {
                newWTypeCats.addAll(workTypeCategories);
            } else {
                for (String thisCat : workTypeCategories) {
                    if (!mapWorkTypeCategoryToJobTypes.containsKey(thisCat)) {
                        newWTypeCats.add(thisCat);
                    }
                }
            }

            if (!newWTypeCats.isEmpty()) {

                for (GDMFSL_Job_Type_Mapping__mdt theJTMapping : [SELECT Id,
                        GDMFSL_WorkType_Category__c,
                        GDMFSL_HasServiceContract__c,
                        GDMFSL_Chargeable__c,
                        SAP_JobType__c
                FROM GDMFSL_Job_Type_Mapping__mdt
                WHERE GDMFSL_WorkType_Category__c IN :newWTypeCats
                ]) {

                    if (!mapWorkTypeCategoryToJobTypes.containsKey(theJTMapping.GDMFSL_WorkType_Category__c)) {
                        mapWorkTypeCategoryToJobTypes.put(theJTMapping.GDMFSL_WorkType_Category__c, new List<GDMFSL_Job_Type_Mapping__mdt>());
                    }

                    mapWorkTypeCategoryToJobTypes.get(theJTMapping.GDMFSL_WorkType_Category__c).add(theJTMapping);
                }

                System.debug('Retrieved GDMFSL_Job_Type_Mapping__mdt by Job Category: ' + mapWorkTypeCategoryToJobTypes);
            }
        }

        return mapWorkTypeCategoryToJobTypes;
    }

    @TestVisible
    private static void setReactiveCoverageOnWO(List<WorkOrder> lstWOs) {

        mapStringToSRL = GDMFSL_ServiceReportLayoutProcessor.getRecords();

        System.debug('Operating Hours data count: ' + mapOperatingHours.size());

        for (WorkOrder wo : lstWOs) {


            Boolean reactiveChargeableEntitlement = false;
            Boolean entitlementDerivedFromSC = false;

            if (wo.WorkTypeId != null
                    && mapWorkType.containsKey(wo.WorkTypeId)
                    && mapWorkType.get(wo.WorkTypeId).GDMFSL_WorkType_Category__c == GDMFSL_WorkTypeProcessor.WORKTYPECATEGORY_BF) {
                System.debug('Process BreakFix WO');
                wo.GDMFSL_Chargeable__c = true;
                System.debug('WO is BreakFix so evaluate reactive');

                if (wo.ServiceContractId != null) {

                    if (scAssetCliItemMap.containsKey(wo.ServiceContractId)
                            && scAssetCliItemMap.get(wo.ServiceContractId).containsKey(wo.AssetId)) {

                        System.debug('WO has a SC and CLI with Asset');

                        if (scAssetCliItemMap.get(wo.ServiceContractId).get(wo.AssetId)[0].GDMFSL_Reactive_Work_Not_Chargeable__c == true) {
                            reactiveChargeableEntitlement = true;
                        }
                    } else if (mapServiceContracts.containsKey(wo.ServiceContractId)
                            && mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Reactive_Work_Not_Chargeable__c == true) {

                        System.debug('WO has no CLI so get the entitlement from SC');
                        reactiveChargeableEntitlement = true;
                        entitlementDerivedFromSC = true;
                    }
                }

                System.debug('Reactive Work Chargeable: ' + reactiveChargeableEntitlement);

                if (reactiveChargeableEntitlement && wo.StartDate != null) {

                    Boolean withinBZHours = isWOStartDateWithinBZHours(wo);
                    System.debug('WO Start date is within Business Hours ' + withinBZHours);

                    if (withinBZHours) {

                        if (entitlementDerivedFromSC && mapServiceContracts.containsKey(wo.ServiceContractId)) {

                            System.debug('Business Hour reactive Coverage from SC is ' + mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Office_Hr_Reactive_Response__c);
                            wo.GDMFSL_Chargeable__c = mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Office_Hr_Reactive_Response__c == true ? false : true;

                        } else if (scAssetCliItemMap.containsKey(wo.ServiceContractId) && scAssetCliItemMap.get(wo.ServiceContractId).containsKey(wo.AssetId)) {

                            System.debug('Business Hour reactive Coverage from CLI is  ' + scAssetCliItemMap.get(wo.ServiceContractId).get(wo.AssetId)[0].GDMFSL_Office_Hr_Reactive_Response__c);
                            wo.GDMFSL_Chargeable__c = scAssetCliItemMap.get(wo.ServiceContractId).get(wo.AssetId)[0].GDMFSL_Office_Hr_Reactive_Response__c == true ? false : true;
                        }
                    } else {

                        if (entitlementDerivedFromSC && mapServiceContracts.containsKey(wo.ServiceContractId)) {

                            System.debug('After Hour Reactive Coverage from SC is  ' + mapServiceContracts.get(wo.ServiceContractId).GDMFSL_After_Hr_Reactive_Response__c);
                            wo.GDMFSL_Chargeable__c = mapServiceContracts.get(wo.ServiceContractId).GDMFSL_After_Hr_Reactive_Response__c == true ? false : true;

                        } else if (scAssetCliItemMap.containsKey(wo.ServiceContractId) && scAssetCliItemMap.get(wo.ServiceContractId).containsKey(wo.AssetId)) {

                            System.debug('After Hour Reactive Coverage from CLI is ' + scAssetCliItemMap.get(wo.ServiceContractId).get(wo.AssetId)[0].GDMFSL_After_Hr_Reactive_Response__c);
                            wo.GDMFSL_Chargeable__c = scAssetCliItemMap.get(wo.ServiceContractId).get(wo.AssetId)[0].GDMFSL_After_Hr_Reactive_Response__c == true ? false : true;
                        }
                    }
                }

                System.debug('WO Reactive Coverage being set to: ' + wo.GDMFSL_Chargeable__c);
            }

            System.debug('Set Service Report Templates on WO now that Chargeable has been set');

            mapStringToSRL = GDMFSL_ServiceReportLayoutProcessor.getRecords();

            if (!mapStringToSRL.isEmpty()) {

                System.debug('Have Service Report Layouts');

                if (wo.GDMFSL_Chargeable__c) {

                    System.debug('WorkOrder is Chargeable');

                    if (wo.LocationId != null && mapLocations.containsKey(wo.LocationId)
                            && mapLocations.get(wo.LocationId).GDMFSL_Is_Classified__c && mapStringToSRL.containsKey('Chargeable Classified')) {

                        System.debug('WorkOrder is chargeable and has a Classified Location,set respective Service Report Template');
                        wo.ServiceReportTemplateId = mapStringToSRL.get('Chargeable Classified').Id;

                    } else if (mapStringToSRL.containsKey('Chargeable')) {

                        System.debug('WorkOrder is chargeable and location is not Classified ,set respective Service Report Template');
                        wo.ServiceReportTemplateId = mapStringToSRL.get('Chargeable').Id;
                    } else {

                        System.debug('No ServRepLayout entry for Chargeable');
                        wo.ServiceReportTemplateId = null;
                    }

                } else {

                    System.debug('WorkOrder is not Chargeable');

                    if (wo.LocationId != null && mapLocations.containsKey(wo.LocationId)
                            && mapLocations.get(wo.LocationId).GDMFSL_Is_Classified__c && mapStringToSRL.containsKey('NonChargeable Classified')) {

                        System.debug('WorkOrder is Not chargeable and has a Classified Location,set respective Service Report Template');
                        wo.ServiceReportTemplateId = mapStringToSRL.get('NonChargeable Classified').Id;

                    } else if (mapStringToSRL.containsKey('NonChargeable')) {

                        System.debug('WorkOrder is Not chargeable and location is not Classified ,set respective Service Report Template');
                        wo.ServiceReportTemplateId = mapStringToSRL.get('NonChargeable').Id;
                    } else {

                        System.debug('No ServRepLayout entry for NonChargeable');
                        wo.ServiceReportTemplateId = null;
                    }
                }
            }

            System.debug('Service Report Template set to : ' + wo.ServiceReportTemplateId);
        }

    }

    @TestVisible
    private static Boolean isWOStartDateWithinBZHours(WorkOrder w) {

        String timeZoneOperatingHours = null;
        Id operatingHourId;

        if (w.LocationId != null
                && mapLocations.containsKey(w.LocationId)
                && mapLocations.get(w.LocationId).GDMFSL_Working_Hours__c != null) {

            operatingHourId = mapLocations.get(w.LocationId).GDMFSL_Working_Hours__c;
            timeZoneOperatingHours = mapLocations.get(w.LocationId).GDMFSL_Working_Hours__r.TimeZone;

        } else if (w.ServiceTerritoryId != null
                && mapServiceTerritory.containsKey(w.ServiceTerritoryId)
                && mapServiceTerritory.get(w.ServiceTerritoryId).OperatingHoursId != null) {

            operatingHourId = mapServiceTerritory.get(w.ServiceTerritoryId).OperatingHoursId;
            timeZoneOperatingHours = mapServiceTerritory.get(w.ServiceTerritoryId).OperatingHours.TimeZone;
        }

        Datetime woStartDateTz = w.StartDate;
        woStartDateTz = getDateInWoOperatingHoursTimeZone(w, woStartDateTz);

        Boolean isHoliday = isDateAHolidayForOperatingHours(operatingHourId, woStartDateTz);

        Boolean isWithinBZHours = false;

        if (!mapOperatingHours.isEmpty()
                && mapOperatingHours.containsKey(operatingHourId)
                && mapOperatingHours.get(operatingHourId).TimeSlots != null) {

            if (isHoliday == false) {

                Time woStartDate_Time = woStartDateTz.time();

                if (timeZoneOperatingHours == null) {
                    timeZoneOperatingHours = UserInfo.getTimeZone().toString();
                }

                Integer getOffsetseconds = (TimeZone.getTimeZone(timeZoneOperatingHours).getOffset(w.StartDate)) / 1000;

                System.debug('WO Start Date -  Time Part is : ' + w.StartDate.timeGmt().addSeconds(getOffsetseconds));
                System.debug('WO Start Date Day is  : ' + woStartDateTz.format('EEEE'));

                woStartDate_Time = w.StartDate.timeGmt().addSeconds(getOffsetseconds);

                for (TimeSlot ts : mapOperatingHours.get(operatingHourId).TimeSlots) {

                    if (woStartDateTz.format('EEEE') == ts.DayOfWeek) {

                        System.debug('Time Slot Start Time & End Time: ' + ts.StartTime + ' : ' + ts.EndTime);

                        if (ts.StartTime <= woStartDate_Time && woStartDate_Time <= ts.EndTime) {
                            System.debug('WO StartDate Time lies between Regular Hours');
                            isWithinBZHours = true;
                            break;
                        }
                    }
                }
            }
        } else {

            System.debug('Is Business Hours depends on isHoliday value of: ' + isHoliday);
            isWithinBZHours = !isHoliday;
        }

        return isWithinBZHours;
    }

    @TestVisible
    private static Boolean isDateAHolidayForOperatingHours(Id operatingHourId, Datetime dateToCheck) {

        Boolean isHoliday = false;
        String woStartDateString = dateToCheck.month() + '/' + dateToCheck.day() + '/' + dateToCheck.year();
        System.debug('Date as String : ' + woStartDateString);

        if (operatingHourId != null && mapOperatingHours.containsKey(operatingHourId)) {

            for (OperatingHoursHoliday theOpHrsHol : mapOperatingHours.get(operatingHourId).OperatingHoursHolidays) {

                System.debug('Operating Hours Holiday Date : ' + theOpHrsHol.DateAndTime.substringBefore(' '));

                if (theOpHrsHol.DateAndTime.substringBefore(' ').equals(woStartDateString)) {
                    System.debug('Has a Holiday Date');
                    isHoliday = true;
                    break;
                }
            }
        }
        return isHoliday;
    }

    @TestVisible
    private static Datetime getDateInWoOperatingHoursTimeZone(WorkOrder w, Datetime tobeUsedDate) {

        String timeZoneOperatingHours = null;
        Datetime woDateInTz = tobeUsedDate;
        Id operatingHourId;

        if (w.LocationId != null
                && mapLocations.containsKey(w.LocationId)
                && mapLocations.get(w.LocationId).GDMFSL_Working_Hours__c != null) {

            operatingHourId = mapLocations.get(w.LocationId).GDMFSL_Working_Hours__c;
            timeZoneOperatingHours = mapLocations.get(w.LocationId).GDMFSL_Working_Hours__r.TimeZone;

        } else if (w.ServiceTerritoryId != null
                && mapServiceTerritory.containsKey(w.ServiceTerritoryId)
                && mapServiceTerritory.get(w.ServiceTerritoryId).OperatingHoursId != null) {

            operatingHourId = mapServiceTerritory.get(w.ServiceTerritoryId).OperatingHoursId;
            timeZoneOperatingHours = mapServiceTerritory.get(w.ServiceTerritoryId).OperatingHours.TimeZone;

        }

        if (operatingHourId != null && tobeUsedDate != null) {

            woDateInTz = GDMFSL_CommonUtilities.subtractTimeZoneOffset(tobeUsedDate, timeZoneOperatingHours);
            System.debug('Date in Operating Hours TimeZone is : ' + woDateInTz);
        }

        return woDateInTz;
    }

    @TestVisible
    private static void setProfitCenterOnWO(List<WorkOrder> lstworkOrders, Set<Id> serviceTerritoryIds, Map<Id, WorkOrder> oldRecs) {

        List<WorkOrder> woToUse = new List<WorkOrder>();
        System.debug('Count of ServiceTerritoryIds : ' + serviceTerritoryIds.size());

        for (WorkOrder wo : lstworkOrders) {
            if (oldRecs == null || (oldRecs.get(wo.Id).WorkTypeId != wo.WorkTypeId)) {
                woToUse.add(wo);
            }
        }

        if (!woToUse.isEmpty()
                && mapProfitCenter.isEmpty()
                && !serviceTerritoryIds.isEmpty()) {

            mapProfitCenter = GDMFSL_ProfitCenterProcessor.getRecords(serviceTerritoryIds);
        }

        for (WorkOrder wo : woToUse) {

            if (wo.WorkTypeId != null && mapWorkType.containsKey(wo.WorkTypeId)) {

                System.debug('Set Activity Type on WO');
                wo.GDMFSL_Activity_Type__c = mapWorkType.get(wo.WorkTypeId).GDMFSL_Discipline__c;
            }

            System.debug('Set Profit Center on WO');

            if (wo.ServiceContractId != null
                    && mapServiceContracts.containsKey(wo.ServiceContractId)
                    && mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Profit_Center__c != null) {

                wo.GDMFSL_Profit_Center__c = mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Profit_Center__c;

                if (wo.GDMFSL_Sales_Organization__c == null) {
                    System.debug('Setting Sales Organization on WO as it is currently NULL');
                    wo.GDMFSL_Sales_Organization__c = mapServiceContracts.get(wo.ServiceContractId).GDMFSL_Profit_Center__r.GDMFSL_Sales_Organization__c;
                }

            } else if (wo.WorkTypeId != null
                    && wo.ServiceTerritoryId != null
                    && mapProfitCenter.containsKey(wo.ServiceTerritoryId)
                    && mapWorkType.containsKey(wo.WorkTypeId)) {

                if (mapProfitCenter.get(wo.ServiceTerritoryId).get(mapWorkType.get(wo.WorkTypeId).GDMFSL_Discipline__c) != null) {

                    wo.GDMFSL_Profit_Center__c = mapProfitCenter.get(wo.ServiceTerritoryId).get(mapWorkType.get(wo.WorkTypeId).GDMFSL_Discipline__c).Id;

                    if (wo.GDMFSL_Sales_Organization__c == null) {
                        System.debug('Setting Sales Organization on WO as it is currently NULL');
                        wo.GDMFSL_Sales_Organization__c = mapProfitCenter.get(wo.ServiceTerritoryId).get(mapWorkType.get(wo.WorkTypeId).GDMFSL_Discipline__c).GDMFSL_Sales_Organization__c;
                    }
                } else if (mapProfitCenter.get(wo.ServiceTerritoryId).get(null) != null) {

                    wo.GDMFSL_Profit_Center__c = mapProfitCenter.get(wo.ServiceTerritoryId).get(null).Id;

                    if (wo.GDMFSL_Sales_Organization__c == null) {
                        System.debug('Setting Sales Organization on WO as it is currently NULL from else if');
                        wo.GDMFSL_Sales_Organization__c = mapProfitCenter.get(wo.ServiceTerritoryId).get(null).GDMFSL_Sales_Organization__c;
                    }
                }
            }

            System.debug('Profit Center on WO set to  : ' + wo.GDMFSL_Profit_Center__c);
            System.debug('Sales Organization set to :' + wo.GDMFSL_Sales_Organization__c);
            System.debug('Activity Type on WO Set to : ' + wo.GDMFSL_Activity_Type__c);
        }
    }

    public static void clearWOFields(List<WorkOrder> lstWorkOrders, Map<Id, WorkOrder> oldRecs) {

        System.debug('Inside clearWOFields Method');
        System.debug('WorkOrder List Input : ' + lstWorkOrders);

        if (lstWorkOrders != null) {

            List<WorkOrder> theWOsToUse = new List<WorkOrder>();

            for (WorkOrder theWO : lstWorkOrders) {

                if (woCanBeProcessed(theWO) && STATUSFORACTIVELOCATIONCLEARING.contains(theWO.Status)) {
                    theWOsToUse.add(theWO);
                }
            }

            for (WorkOrder wo : theWOsToUse) {

                System.debug('Looking at WO: ' + wo.WorkOrderNumber);

                if ((Trigger.isBefore && Trigger.isInsert)
                        || (oldRecs != null && wo.Status != oldRecs.get(wo.Id).Status)) {

                    System.debug('Clearing WO Location Active WO field');
                    wo.GDMFSL_Location_ActiveWO__c = null;
                }
            }
        }
    }

    @TestVisible
    private static void setWODurationwithExtraTime(WorkOrder wo, WorkOrder oldRec, Decimal extraTravelTime) {

        if (extraTravelTime > 0) {

            wo.GDMFSL_Extra_Travel__c = true;

            if (Trigger.isInsert) {
                System.debug('Adding extra time on WO Duration during Creation: ' + extraTravelTime);

                if (wo.DurationType == 'Hours') {
                    wo.Duration += extraTravelTime / 60;
                } else {
                    wo.Duration += extraTravelTime;
                }
            } else if (Trigger.isUpdate
                    && oldRec != null
                    && wo.LocationId != oldRec.LocationId
                    && mapWorkType != null
                    && mapWorkType.containsKey(wo.WorkTypeId)) {

                System.debug('WorkOrder Location Updated,Duration getting recalculated');

                wo.Duration = mapWorkType.get(wo.WorkTypeId).DurationInMinutes + extraTravelTime;

                if (wo.DurationType != null && wo.DurationType == 'Hours') {
                    wo.Duration = wo.Duration / 60;
                }
            }

        } else if (Trigger.isUpdate
                && extraTravelTime == 0
                && oldRec != null
                && wo.LocationId != oldRec.LocationId
                && wo.WorkTypeId != null
                && mapWorkType != null
                && mapWorkType.containsKey(wo.WorkTypeId)) {

            System.debug('WO Updated with a location having No Extra Travel Time');

            wo.GDMFSL_Extra_Travel__c = false;
            wo.Duration = mapWorkType.get(wo.WorkTypeId).DurationInMinutes;

            if (wo.DurationType == 'Hours') {
                wo.Duration = wo.Duration / 60;
            }
        }
    }

    public static Map<Id, WorkOrder> getRecords(Set<Id> recIds) {

        if (recIds != null && !recIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (theWOs.isEmpty()) {
                newRecIds.addAll(recIds);
            } else {
                for (Id thisRecId : recIds) {
                    if (!theWOs.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                Map<Id, WorkOrder> theRecs = new Map<Id, WorkOrder>([
                        SELECT Id, CaseId, ServiceTerritoryId, StartDate, Status, StatusCategory, EndDate, GDMFSL_Arrival_Time__c,
                                GDMFSL_Response_Time__c, Street, City, State, PostalCode, Country, Duration, GDMFSL_Extra_Travel_Time__c,
                                DurationType, SuggestedMaintenanceDate, MaintenancePlanId, LocationId, ServiceContractId, WorkTypeId,
                                ServiceContract.GDMFSL_ATS_BreakFix_Hours__c,
                                ServiceContract.GDMFSL_ATS_PM_Hours__c,
                                ServiceContract.GDMFSL_Contract_Type__c,
                                ServiceContract.GDMFSL_Actual_Time_Consumed_BF_Hours__c,
                                ServiceContract.GDMFSL_Actual_Time_Consumed_PM_Hours__c,
                                WorkType.GDMFSL_WorkType_Category__c,
                                Location.GDMFSL_Vertical__c,
                                Location.GDMFSL_Site_License__c,
                                GDMFSL_Extra_Travel__c, GDMFSL_PO_Number__c, GDMFSL_PO_Required_for_Reactive_Coverage__c,
                                ServiceTerritory.GDMFSL_Disable_GeoTracking__c,
                                GDMFSL_Created_by_WO_Merge_Process__c, ServiceTerritory.GDMFSL_Maximum_SA_Duration_Hrs__c,
                                ServiceTerritory.GDMFSL_Discarded_SA_Duration_Min__c,
                                Work_Type_Category__c,
                                GDMFSL_Total_OT_Travel_in_minutes__c,
                                GDMFSL_Total_PT_Travel_in_minutes__c,
                                GDMFSL_Total_Regular_Travel_in_minutes__c,
                                GDMFSL_Travel_Time_Chargeable__c,
                                GDMFSL_Executed_by_Sub_Contractor__c,
                                MaintenanceWorkRuleId,
                                GDMFSL_Sold_To_Source_System_Reference__c,
                                GDMFSL_Non_Reactive_Work__c,
                                WorkOrderNumber,
                                GDMFSL_Chargeable__c,
                                GDMFSL_Re_Calculate_Invoice_Totals__c,
                                GDMFSL_Region__c

                        FROM WorkOrder
                        WHERE Id IN :newRecIds

                ]);

                theWOs.putAll(theRecs);
                System.debug('Retrieved WorkOrders: ' + theWOs);
            }
        }

        return theWOs;
    }


    public static Map<Id, List<WorkOrder>> getMaintPlanWOs(Set<Id> maintPlanIDs) {

        if (maintPlanIDs != null && !maintPlanIDs.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (maintPlanIDToWOs.isEmpty()) {
                newRecIds.addAll(maintPlanIDs);
            } else {
                for (Id thisRecId : maintPlanIDs) {
                    if (!maintPlanIDToWOs.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                for (WorkOrder theWO : [
                        SELECT Id, CaseId, ServiceTerritoryId, StartDate, EndDate, SuggestedMaintenanceDate,
                                MaintenancePlanId, LocationId, ServiceContractId
                        FROM WorkOrder
                        WHERE MaintenancePlanId IN :newRecIds
                        AND GDMFSL_Created_by_WO_Merge_Process__c = FALSE
                ]) {

                    if (!maintPlanIDToWOs.containsKey(theWO.MaintenancePlanId)) {
                        System.debug('Adding MaintPlan ID for return: ' + theWO.MaintenancePlanId);
                        maintPlanIDToWOs.put(theWO.MaintenancePlanId, new List<WorkOrder>());
                    }

                    System.debug('Adding WorkOrder: ' + theWO);
                    maintPlanIDToWOs.get(theWO.MaintenancePlanId).add(theWO);
                }

                System.debug('Retrieved WOs for MaintPlans: ' + maintPlanIDToWOs);
            }
        }

        return maintPlanIDToWOs;
    }

    public static void updateRelatedServiceAppointment(List<WorkOrder> lstworkorder, Map<Id, WorkOrder> oldWorkOrderMap) {

        System.debug('updateRelatedServiceAppointment()');

        Map<Id, WorkOrder> wosToWorkWith = new Map<Id, WorkOrder>();

        for (WorkOrder wo : lstworkorder) {
            if (GDMFSL_WorkOrderProcessor.STATUSFORUPDATES.contains(wo.Status) && wo.Status == oldWorkOrderMap.get(wo.Id).Status) {
                wosToWorkWith.put(wo.Id, wo);
            }
        }

        System.debug('WOs to check: ' + wosToWorkWith);

        if (!wosToWorkWith.isEmpty()) {
            GDMFSL_ServiceAppointmentProcessor.updateSAFieldsfromWO(wosToWorkWith);
        }
    }

    public static Map<Id, Boolean> canWOBeCanceled(Set<Id> caseIdsToCancel) {

        System.debug('canWOBeCanceled()');

        Map<Id, Boolean> keyIdCanBeCancelled = new Map<Id, Boolean>();
        Map<Id, WorkOrder> theWOs = new Map<Id, WorkOrder>([SELECT Id, Status, CaseId FROM WorkOrder WHERE CaseId IN :caseIdsToCancel]);

// TODO: major bug here -- if any WO is found, all are sent
        for (WorkOrder w : theWOs.values()) {
            if (STATUSFORCANCELLATION.contains(w.Status)) {
                return cancelWOs(theWOs, 'CaseId');
            } else {
                keyIdCanBeCancelled.put(w.CaseId, false);
            }
        }

        return keyIdCanBeCancelled;
    }

    @TestVisible
    private static Map<Id, Boolean> cancelWOs(Map<Id, WorkOrder> wosToCheck, String fieldAPIforReturnId) {

        Map<Id, Boolean> keyIdCanBeCancelled = new Map<Id, Boolean>();

        if (wosToCheck != null && !wosToCheck.isEmpty()) {

            keyIdCanBeCancelled = GDMFSL_ServiceAppointmentProcessor.canSABeCanceled(wosToCheck, fieldAPIforReturnId);
            System.debug('Key Id to be cancelled : ' + keyIdCanBeCancelled);
            List<WorkOrder> woToBeCancelled = new List<WorkOrder>();

            for (WorkOrder theWO : wosToCheck.values()) {

                System.debug('Checking WO: ' + theWO.Id);
                System.debug('WO Status: ' + theWO.Status);

                if (fieldAPIforReturnId == null || fieldAPIforReturnId == 'ParentRecordId') {
                    if (keyIdCanBeCancelled.containsKey(theWO.Id) && keyIdCanBeCancelled.get(theWO.Id)) {
                        theWO.Status = CANCELLEDSTATUS;
                        woToBeCancelled.add(theWO);
                        System.debug('Setting WO to be Cancelled from SC with No Case');
                    }
                } else if (fieldAPIforReturnId == 'CaseId') {
                    System.debug('fieldAPIforReturnId WorkOrder Processor = caseId');
                    System.debug('keyIdCanBeCancelled.containsKey(theWO.CaseId) && keyIdCanBeCancelled.get(theWO.CaseId)' + keyIdCanBeCancelled.containsKey(theWO.CaseId) + keyIdCanBeCancelled.get(theWO.CaseId));
                    if (keyIdCanBeCancelled.containsKey(theWO.CaseId) && keyIdCanBeCancelled.get(theWO.CaseId)) {
                        theWO.Status = CANCELLEDSTATUS;
                        woToBeCancelled.add(theWO);
                    }
                }
            }

            System.debug('This many WOs to be Canceled: ' + woToBeCancelled.size());
            System.debug('woToBeCancelled.isEmpty(): ' + woToBeCancelled.isEmpty());
            if (!woToBeCancelled.isEmpty()) {
                System.debug('!woToBeCancelled.isEmpty(): ' + !woToBeCancelled.isEmpty());
                GDMFSL_CommonUtilities.updateRecords(woToBeCancelled);
            }
        }

        return keyIdCanBeCancelled;
    }

    public static void updateWorkOrderStatusFromServiceAppointment(List<ServiceAppointment> newSaList) {

        Map<Id, ServiceAppointment> newSAIdToSA = new Map<Id, ServiceAppointment>();
        Set<Id> saIdSet = new Set<Id>();
        Map<Id, WorkOrder> woToUpdate = new Map<Id, WorkOrder>();

        for (ServiceAppointment sa : newSaList) {
            if (sa.ParentRecordId != null) {
                saIdSet.add(sa.ParentRecordId);
                newSAIdToSA.put(sa.Id, sa);
            }
        }

        System.debug('Have SAs to set WO Status: ' + saIdSet.size());

        if (!saIdSet.isEmpty()) {

            Map<Id, WorkOrder> theWOs = getRecords(saIdSet);
            Map<Id, List<ServiceAppointment>> woIDToSAs = GDMFSL_ServiceAppointmentProcessor.getRecordsForWOs(theWOs.keySet());
            Map<Id, Integer> woIdToStatusLevel = new Map<Id, Integer>();
            Boolean isCompleted = false;
            Boolean isInProg = false;

            for (Id woID : theWOs.keySet()) {

                for (ServiceAppointment sa : woIDToSAs.get(woID)) {

                    System.debug('SA for WO : ' + sa.ParentRecordId);
                    System.debug('Total SAs in this WO : ' + woIDToSAs.get(woID).size());
                    System.debug('SA for Status : ' + sa.Status);

                    if (newSAIdToSA.containsKey(sa.Id)) {
                        System.debug('Overriding the Database Fetched SA with the latest one in the transaction if any');
                        sa = newSAIdToSA.get(sa.Id);
                    }
                    if (sa.Status == GDMFSL_ServiceAppointmentProcessor.COMPLETEDSTATUS) {
                        isCompleted = true;
                    } else {
                        isInProg = true;
                    }
                }

                if (isCompleted){
                    System.debug('WorkOrder being set to In progress has at least one Completed SA: ' + woID);

                    theWOs.get(woID).Status = isInProg ? INPROGRESSSTATUS : COMPLETEDSTATUS;

                    woToUpdate.put(woID, theWOs.get(woID));
                    woIDToSAs.remove(woID);
                }
            }

            for (Id woId : woIDToSAs.keySet()) {
                System.debug('WorkOrders Left to be updated from an SA : ' + woIDToSAs.size());
                if (woIDToSAs.containsKey(woId)) {
                    for (ServiceAppointment sa : woIDToSAs.get(woId)) {

                        System.debug('Looking at current SA: ' + sa.Id);

                        if (sa.ParentRecordId != null && theWOs.containsKey(sa.ParentRecordId)) {

                            if (!woIdToStatusLevel.containsKey(sa.ParentRecordId)) {
                                woIdToStatusLevel.put(sa.ParentRecordId, WOSTATUSLEVEL.get('New'));
                            }
                            System.debug('Current SA status is: ' + sa.Status);
                            System.debug('Current SA statusCategory is: ' + GDMFSL_ServiceAppointmentProcessor.SASTATUSTOSTATUSCATEGORYMAP.get(sa.Status));
                            System.debug('WO status is: ' + theWOs.get(sa.ParentRecordId).Status);
                            System.debug('WO Order Status Level : ' + woIdToStatusLevel.get(sa.ParentRecordId));
                            System.debug('SA Status Category level : ' + WOSTATUSLEVEL.get(GDMFSL_ServiceAppointmentProcessor.SASTATUSTOSTATUSCATEGORYMAP.get(sa.Status)));


                            if (GDMFSL_ServiceAppointmentProcessor.SASTATUSTOSTATUSCATEGORYMAP.containsKey(sa.Status) &&
                                    woIdToStatusLevel.get(sa.ParentRecordId) < WOSTATUSLEVEL.get(GDMFSL_ServiceAppointmentProcessor.SASTATUSTOSTATUSCATEGORYMAP.get(sa.Status))) {
                                System.debug('WorkOrder Status is at a lower level then SA Status Category so set WO Status to match the SA StatusCategory');
                                woIdToStatusLevel.put(sa.ParentRecordId, WOSTATUSLEVEL.get(GDMFSL_ServiceAppointmentProcessor.SASTATUSTOSTATUSCATEGORYMAP.get(sa.Status)));
                                System.debug('WO Order Status Level set to : ' + woIdToStatusLevel.get(sa.ParentRecordId));
                            }

                        }
                    }
                }
            }

            for (Id woId : woIdToStatusLevel.keySet()) {
                if (theWOs.containsKey(woId) && theWOs.get(woId).Status != WOLEVELTOSTATUS.get(woIdToStatusLevel.get(woId))) {
                    System.debug('WO Status being updated to  : ' + WOLEVELTOSTATUS.get(woIdToStatusLevel.get(woId)));
                    theWOs.get(woId).Status = WOLEVELTOSTATUS.get(woIdToStatusLevel.get(woId)) == 'InProgress' ? 'In Progress' : WOLEVELTOSTATUS.get(woIdToStatusLevel.get(woId));
                    if (!woToUpdate.containsKey(theWOs.get(woId).Id)) {
                        woToUpdate.put(theWOs.get(woId).Id, theWOs.get(woId));
                    }
                }
            }

            System.debug('Have this many WOs to update: ' + woToUpdate.size());

            if (!woToUpdate.isEmpty()) {
                GDMFSL_CommonUtilities.updateRecords(woToUpdate.values());
            }
        }
    }

    public static void createWorkOrderResourcePreference(List<WorkOrder> theWOs, Map<Id, WorkOrder> oldWorkOrderMap) {

        if (theWOs != null) {
            System.debug('createWorkOrderResourcePreference() got: ' + theWOs.size());
            List<WorkOrder> wosForResPrefCheck = new List<WorkOrder>();
            for (WorkOrder wo : theWOs) {
                System.debug('WOLI Count on WO : ' + wo.LineItemCount);
                if (woCanBeProcessed(wo) && STATUSFORSERVRESCREATION.contains(wo.Status) &&
                        (oldWorkOrderMap == null || (oldWorkOrderMap != null && wo.LineItemCount != oldWorkOrderMap.get(wo.Id).LineItemCount))) {
                    System.debug('WOLi Added to WO or WO Inserted');
                    wosForResPrefCheck.add(wo);
                }
            }
            if (!wosForResPrefCheck.isEmpty()) {
                GDMFSL_ResourcePreferenceProcessor.assessExistingWOResourcePreferences(wosForResPrefCheck);
            }
        }
    }


    public static void updateParentCaseStatus(List<WorkOrder> theWOs) {

        if (theWOs != null) {
            System.debug('updateParentCaseStatus() has this many WOs: ' + theWOs.size());

            List<WorkOrder> wosToProcess = new List<WorkOrder>();

            for (WorkOrder wo : theWOs) {
                if (wo.CaseId != null) {
                    wosToProcess.add(wo);
                }
            }

            System.debug('Work Orders with CaseIDs: ' + wosToProcess.size());

            if (wosToProcess.size() > 0) {
                GDMFSL_CaseProcessor.updateCaseStatusFromWorkOrder(wosToProcess);
            }
        }
    }

    public static void cancelNonCaseRelatedWOs(Map<Id, ServiceContract> serviceContractMap) {

        Map<Id, WorkOrder> tobeCancelledWOs = new Map<Id, WorkOrder>();

        if (serviceContractMap != null && !serviceContractMap.isEmpty()) {

            for (WorkOrder wo : [
                    SELECT Id,
                            Status,
                            EndDate,
                            ServiceContractId
                    FROM WorkOrder
                    WHERE Status IN :STATUSFORUPDATES
                    AND ServiceContractId IN :serviceContractMap.keySet()
                    AND CaseId = NULL
            ]) {

                if (wo.EndDate == null || (wo.EndDate.date() > serviceContractMap.get(wo.ServiceContractId).EndDate)) {
                    tobeCancelledWOs.put(wo.Id, wo);
                    System.debug('WO can be cancelled because EndDate is blank or EndDate after the Contract End Date: ' + wo.Id);
                }
            }

            System.debug('Found Non-Case Related WOs for cancellation: ' + tobeCancelledWOs.size());
            cancelWOs(tobeCancelledWOs, null);
        }
    }


    public static void rollUpTimeOnWOFromSA(List<WorkOrder> newWorkOrders, Map<Id, WorkOrder> oldWorkOrdersMap) {

        Set<Id> completedWOs = new Set<Id>();
        for (WorkOrder w : newWorkOrders) {
            if (woCanBeProcessed(w)
                    && w.Status == COMPLETEDSTATUS &&
                    (w.Status != oldWorkOrdersMap.get(w.Id).Status
                            || w.GDMFSL_Re_Calculate_Invoice_Totals__c && !oldWorkOrdersMap.get(w.Id).GDMFSL_Re_Calculate_Invoice_Totals__c)) {
                completedWOs.add(w.Id);
            }
        }

        System.debug('Count of Completed WOs: ' + completedWOs.size());

        if (completedWOs.size() > 0) {
            setRollUpTimeFields(completedWOs);
        }
    }

    @TestVisible
    @Future
    private static void setRollUpTimeFields(Set<Id> completedWOs) {

        Map<Id, List<TimeSheetEntry>> mapWOsTSE = GDMFSL_TimeSheetEntryProcessor.getRecordsForWOs(completedWOs);

        List<WorkOrder> tobeUpdateWOs = new List<WorkOrder>();

        for (Id compWOId : mapWOsTSE.keySet()) {

            WorkOrder w = new WorkOrder(Id = compWOId);
            w.GDMFSL_Re_Calculate_Invoice_Totals__c = false;
            w.GDMFSL_Total_OT_Labor_in_minutes__c = 0;
            w.GDMFSL_Total_OT_Travel_in_minutes__c = 0;
            w.GDMFSL_Total_PT_Labor_in_minutes__c = 0;
            w.GDMFSL_Total_PT_Travel_in_minutes__c = 0;
            w.GDMFSL_Total_Regular_Labor_in_minutes__c = 0;
            w.GDMFSL_Total_Regular_Travel_in_minutes__c = 0;

            w.GDMFSL_Invoicing_Labor_Regular__c = 0;
            w.GDMFSL_Invoicing_Labor_OT__c = 0;
            w.GDMFSL_Invoicing_Labor_PT__c = 0;
            w.GDMFSL_Invoicing_Travel_Regular__c = 0;
            w.GDMFSL_Invoicing_Travel_OT__c = 0;
            w.GDMFSL_Invoicing_Travel_PT__c = 0;

            for (TimeSheetEntry tse : mapWOsTSE.get(w.Id)) {

                if ((tse.GDMFSL_Classification__c == 'Labor') && (tse.Type == 'OT')) {

                    w.GDMFSL_Total_OT_Labor_in_minutes__c += tse.DurationInMinutes;
                    w.GDMFSL_Invoicing_Labor_OT__c += tse.GDMFSL_Invoicing_Duration__c;
                }

                if ((tse.GDMFSL_Classification__c == 'Travel') && (tse.Type == 'OT')) {

                    w.GDMFSL_Total_OT_Travel_in_minutes__c += tse.DurationInMinutes;
                    w.GDMFSL_Invoicing_Travel_OT__c += tse.GDMFSL_Invoicing_Duration__c;
                }

                if ((tse.GDMFSL_Classification__c == 'Labor') && (tse.Type == 'PT')) {

                    w.GDMFSL_Total_PT_Labor_in_minutes__c += tse.DurationInMinutes;
                    w.GDMFSL_Invoicing_Labor_PT__c += tse.GDMFSL_Invoicing_Duration__c;
                }

                if ((tse.GDMFSL_Classification__c == 'Travel') && (tse.Type == 'PT')) {

                    w.GDMFSL_Total_PT_Travel_in_minutes__c += tse.DurationInMinutes;
                    w.GDMFSL_Invoicing_Travel_PT__c += tse.GDMFSL_Invoicing_Duration__c;
                }

                if ((tse.GDMFSL_Classification__c == 'Labor') && (tse.Type == 'RT')) {

                    w.GDMFSL_Total_Regular_Labor_in_minutes__c += tse.DurationInMinutes;
                    w.GDMFSL_Invoicing_Labor_Regular__c += tse.GDMFSL_Invoicing_Duration__c;
                }

                if ((tse.GDMFSL_Classification__c == 'Travel') && (tse.Type == 'RT')) {

                    w.GDMFSL_Total_Regular_Travel_in_minutes__c += tse.DurationInMinutes;
                    w.GDMFSL_Invoicing_Travel_Regular__c += tse.GDMFSL_Invoicing_Duration__c;
                }
            }

            tobeUpdateWOs.add(w);

            System.debug('Total Labor OT,PT,Regular hours set to : ' + w.GDMFSL_Total_OT_Labor_in_minutes__c + ' , ' + w.GDMFSL_Total_PT_Labor_in_minutes__c + ' , ' + w.GDMFSL_Total_Regular_Labor_in_minutes__c);
            System.debug('Total Travel OT,PT,Regular hours set to : ' + w.GDMFSL_Total_OT_Travel_in_minutes__c + ' , ' + w.GDMFSL_Total_PT_Travel_in_minutes__c + ' , ' + w.GDMFSL_Total_Regular_Travel_in_minutes__c);
        }

        System.debug('Total WOs being updated to set Labor and Travel Time ' + tobeUpdateWOs.size());
        if (GDMFSL_CommonUtilities.updateRecords(tobeUpdateWOs)) {
            GDMFSL_ServiceContractProcessor.setATSHours(tobeUpdateWOs);
        }
    }

    public static void createRequireAssistWOs(Set<Id> maintPlanIdsToUse) {

        System.debug('Creating Require Assist WOs for these MaintPlans:  ' + maintPlanIdsToUse);

        if (maintPlanIdsToUse != null && !maintPlanIdsToUse.isEmpty()) {

            Map<Id, List<WorkOrder>> maintPlanIdToWOs = getMaintPlanWOs(maintPlanIdsToUse);

            System.debug('Find the WorkType for Assistant Work Orders');

            WorkType assistantWorkType = GDMFSL_WorkTypeProcessor.getWorkTypeForAssistanceWOs();

            System.debug('Assigning this WorkType to Assistant Work Orders: ' + assistantWorkType);


            List<WorkOrder> wosToCreate = new List<WorkOrder>();

            for (Id theMaintPlanId : maintPlanIdToWOs.keySet()) {

                for (WorkOrder origWO : maintPlanIdToWOs.get(theMaintPlanId)) {

                    System.debug('Defining ReqAssist WO for: ' + origWO.Id);

                    WorkOrder thisWO = new WorkOrder();
                    thisWO.ParentWorkOrderId = origWO.Id;
                    thisWO.ServiceContractId = origWO.ServiceContractId;
                    thisWO.WorkTypeId = assistantWorkType != null ? assistantWorkType.Id : null;
                    thisWO.LocationId = origWO.LocationId;
                    thisWO.StartDate = origWO.StartDate;
                    thisWO.EndDate = origWO.EndDate;
                    thisWO.MaintenancePlanId = origWO.MaintenancePlanId;
                    thisWO.SuggestedMaintenanceDate = origWO.SuggestedMaintenanceDate;

                    System.debug('Defined WO to be created: ' + thisWO);
                    wosToCreate.add(thisWO);
                }
            }

            System.debug('Have this many ReqAssist WOs to create: ' + wosToCreate.size());

            if (!wosToCreate.isEmpty()) {
                GDMFSL_CommonUtilities.insertRecords(wosToCreate);
            }
        }
    }

    public static void setStatusforIntegration(List<WorkOrder> newWorkOrders, Map<Id, WorkOrder> oldWorkOrdersMap) {

        if (newWorkOrders != null && oldWorkOrdersMap != null) {

            for (WorkOrder w : newWorkOrders) {

                if (woCanBeProcessed(w) && w.Status == COMPLETEDSTATUS && w.Status != oldWorkOrdersMap.get(w.Id).Status) {

                    if (SAPJOBTYPE.contains(w.SAP_Job_Type__c)) {

                        w.Status = CLOSEDSTATUS;

                    } else if (!w.GDMFSL_Executed_by_Sub_Contractor__c
                            && !w.GDMFSL_Chargeable__c
                            && w.Work_Type_Category__c != GDMFSL_WorkTypeProcessor.WORKTYPECATEGORY_BF) {

                        w.Status = EXPORTSTATUS;
                    }
                }
            }
        }
    }

    public static Boolean woCanBeProcessed(WorkOrder theWO) {
        return (theWO.WorkTypeId != null);
    }

    @TestVisible
    private List<WorkOrder> wosToBeDeleted = new List<WorkOrder>();

// This method is for queueable iface to allow chained deletes
    public GDMFSL_WorkOrderProcessor(List<WorkOrder> wosToDelete) {
        wosToBeDeleted.addAll(wosToDelete);
    }

    public void execute(QueueableContext qc) {

        System.debug('Number of WOs to be deleted: ' + wosToBeDeleted.size());

        if (!wosToBeDeleted.isEmpty()) {
            System.debug('About to delete WO: ' + wosToBeDeleted[0].Id);
            GDMFSL_CommonUtilities.deleteRecords(new List<WorkOrder>{
                    wosToBeDeleted[0]
            });

            wosToBeDeleted.remove(0);
        }

        if (!wosToBeDeleted.isEmpty() && !Test.isRunningTest()) {

            GDMFSL_WorkOrderProcessor delWOs = new GDMFSL_WorkOrderProcessor(wosToBeDeleted);
            Id jobId = System.enqueueJob(delWOs);
            System.debug('WO Delete Job Id being sent to Queue: ' + jobId);
        }
    }

    public static void checkIfWOCanBeUnscheduledAlongWithSA(Set<Id> theWOIds) {

        Set<Id> toBeUnscheduledWOIds = new Set<Id>();
        Map<Id, List<ServiceAppointment>> mapWOIdToSAs = new Map<Id, List<ServiceAppointment>>();
        List<ServiceAppointment> canUnScheduleSAs = new List<ServiceAppointment>();

        System.debug('Number of WorkOrders to be checked if they can be set to New Status : ' + theWOIds.size());

        if (!theWOIds.isEmpty()) {
            mapWOIdToSAs = GDMFSL_ServiceAppointmentProcessor.getRecordsForWOs(theWOIds);
        }

        if (!mapWOIdToSAs.isEmpty()) {

            System.debug('Check the WOs and see if WO can be set to New Status if all the related SAs are not In Progress');

            for (Id woId : theWOIds) {

                Boolean canWOBeUnscheduled = true;

                if (mapWOIdToSAs.containsKey(woId)) {

                    for (ServiceAppointment sa : mapWOIdToSAs.get(woId)) {

                        if (GDMFSL_ServiceAppointmentProcessor.STATUSFORUNSCHEDULING.contains(sa.Status)) {
                            canUnScheduleSAs.add(sa);

                        } else if (canWOBeUnscheduled) {
                            System.debug('WorkOrder with Id : ' + woId + 'has a SA which cannot be Unscheduled : ' + sa.Id);
                            canWOBeUnscheduled = false;
                        }
                    }
                }

                if (canWOBeUnscheduled) {
                    toBeUnscheduledWOIds.add(woId);
                }
            }
        }

        System.debug('Count of SAs that will be unscheduled : ' + canUnScheduleSAs.size());
        GDMFSL_ServiceAppointmentProcessor.unScheduleAccountBlockedSAs(canUnScheduleSAs);

        System.debug('Number of WOs to be updated: ' + toBeUnscheduledWOIds.size());

        if (!toBeUnscheduledWOIds.isEmpty()) {

            List<WorkOrder> canUnScheduleWOs = new List<WorkOrder>();

            for (Id woId : toBeUnscheduledWOIds) {
                canUnScheduleWOs.add(new WorkOrder(Id = woId, Status = NEWSTATUS));
            }

            GDMFSL_CommonUtilities.updateRecords(canUnScheduleWOs);
        }
    }

}