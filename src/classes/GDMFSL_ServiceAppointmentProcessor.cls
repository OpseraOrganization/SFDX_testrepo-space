/*******************************************************************************************
Name       :    GDMFSL_ServiceAppointmentProcessor
Purpose    :    Business Logic for ServiceAppointment object . See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2020-Sep-01    Created
**********************************************************************************************/

public without sharing class GDMFSL_ServiceAppointmentProcessor {


    public static final String CANCELLEDSTATUS = 'Canceled';
    public static final String UNSCHEDULEDSTATUS = 'None';
    public static final String COMPLETEDSTATUS = 'Completed';
    public static final String STATUSFORLOCSHARING = 'Dispatched';

    private static final String LOCATIONACCESSLEVEL = 'Read';

    public static final Set<String> STATUSFORCANCELLATION = new Set<String>{
            'None',
            'New',
            'Scheduled',
            'Dispatched',
            'Accepted',
            'Rejected'
    };

    public static final Set<String> CLOSEDSTATUSES = new Set<String>{
            'Closed',
            'Canceled',
            'Completed'
    };

    public static final Map<String, String> SASTATUSTOSTATUSCATEGORYMAP = new Map<String, String>{
            'Null' => 'None',
            'None' => 'None',
            'Scheduled' => 'Scheduled',
            'Dispatched' => 'Dispatched',
            'Accepted' => 'Dispatched',
            'Rejected' => 'Dispatched',
            'Travel' => 'InProgress',
            'Onsite' => 'InProgress',
            'Paused' => 'InProgress',
            'Follow Up Required' => 'InProgress',
            'Check Out' => 'InProgress',
            'Cannot Complete' => 'Cannot Complete',
            COMPLETEDSTATUS => 'Completed',
            CANCELLEDSTATUS => CANCELLEDSTATUS
    };

    private static final Set<String> STATUSFORUPDATES = new Set<String>{
            'None',
            'Scheduled'
    };

    public static final Set<String> STATUSFORUNSCHEDULING = new Set<String>{
            'Scheduled',
            'Dispatched',
            'Accepted'
    };

    //Service Appointment Fields ==> Work Order Fields mapping
    // make sure to add the WO fields to  GDMFSL_WorkOrderProcessor.getRecords()
    private static final Map<String, String> SERVAPPFIELDSTOWOMAP = new Map<String, String>{
            'ServiceTerritoryId' => 'ServiceTerritoryId',
            'EarliestStartTime' => 'StartDate',
            'DueDate' => 'EndDate',
            'ArrivalWindowEndTime' => 'GDMFSL_Arrival_Time__c',
            'ArrivalWindowStartTime' => 'GDMFSL_Response_Time__c',
            'GDMFSL_Extra_Travel__c' => 'GDMFSL_Extra_Travel__c',
            'GDMFSL_Service_Contract__c' => 'ServiceContractId',
            'GDMFSL_PO_Number__c' => 'GDMFSL_PO_Number__c',
            'GDMFSL_PO_Required_for_Reactive_Coverage__c' => 'GDMFSL_PO_Required_for_Reactive_Coverage__c',
            'GDMFSL_Location__c' => 'LocationId',
            'GDMFSL_Sold_To_Source_System_Reference__c' => 'GDMFSL_Sold_To_Source_System_Reference__c',
            'GDMFSL_Non_Reactive_Work__c' => 'GDMFSL_Non_Reactive_Work__c',
            'Work_Order_Number__c' => 'WorkOrderNumber',
            'GDMFSL_Region__c' => 'GDMFSL_Region__c'

    };

    /**
     * method to set Fields from WO to SA
     *
     * @param lstSA List of Service Appointment Passed
     **/
    public static void setSAFieldsFromWO(List<ServiceAppointment> lstSA) {

        Map<Id, List<ServiceAppointment>> woIDtoSAs = generateMapWOIdToSA(lstSA);

        setSAFieldsFromWO(woIDtoSAs, null);
    }


    /**
     * method to set Fields from WO to SA
     *
     * @param parentIDToSAs List of Service Appointment Passed
     * @param newWOMap workOrder map with Id and WorkOrder Object
     * @param oldWOMap WorkOrder Old Map passed from WorkOrder Processor
     *
     * @return Map of Id and List of Service Appointments
     **/
    public static Map<Id, List<ServiceAppointment>> setSAFieldsFromWO(Map<Id, List<ServiceAppointment>> parentIDToSAs, Map<Id, WorkOrder> newWOMap) {

        if (GDMFSL_CommonUtilities.isFlagSet('setSAFieldsFromWO')) {
            return parentIDToSAs;
        }

        GDMFSL_CommonUtilities.setFlag('setSAFieldsFromWO');

        Map<Id, WorkOrder> woInfo = newWOMap;

        Boolean calledFromWOTrigger = (newWOMap != null);
        System.debug('setSAFieldsFromWO() called from WO trigger: ' + calledFromWOTrigger);

        if (!calledFromWOTrigger) {
            System.debug('No WorkOrders passed to setSAFieldsFromWO() need to get WOs');
            woInfo = fetchSARelatedWO(parentIDToSAs);
        }

        System.debug('working with WOs: ' + woInfo.size());

        Map<Id, Schema.Location> locationMap = new Map<Id, Schema.Location>();

        if (calledFromWOTrigger && woInfo != null && !woInfo.isEmpty()) {
            System.debug('Called from WO trigger so we need to go get WO related records (Location)');
            Set<Id> locationIds = new Set<Id>();

            for (WorkOrder wo : woInfo.values()) {
                if (wo.LocationId != null) {
                    locationIds.add(wo.LocationId);
                }
            }

            if (!locationIds.isEmpty()) {
                locationMap = GDMFSL_LocationProcessor.getRecords(locationIds);
                System.debug('Locations fetched: ' + locationMap);
            }
        }

        for (WorkOrder theWO : woInfo.values()) {

            System.debug('WO ID: ' + theWO.Id);
            System.debug('WO Duration: ' + theWO.Duration);
            System.debug('WO Location: ' + theWO.LocationId);

            System.debug('has this many SAs: ' + (parentIDToSAs.containsKey(theWO.Id) ? parentIDToSAs.get(theWO.Id).size() : 0));

            if (parentIDToSAs.containsKey(theWO.Id)) {

                for (ServiceAppointment sa : parentIDToSAs.get(theWO.Id)) {

                    if (Trigger.isExecuting && Trigger.operationType == TriggerOperation.BEFORE_INSERT) {
                        System.debug('Set SA Disable GeoTracking field from the WO.ServiceTerritory');
                        sa.GDMFSL_Disable_GeoTracking__c = theWO.ServiceTerritory.GDMFSL_Disable_GeoTracking__c;
                    }

                    System.debug('Service Appointment Status: ' + sa.Status);

                    if (STATUSFORUPDATES.contains(sa.Status)) {

                        for (String saFieldName : SERVAPPFIELDSTOWOMAP.keySet()) {
                            System.debug('SA Field : Value ' + saFieldName + ' : ' + theWO.get(SERVAPPFIELDSTOWOMAP.get(saFieldName)));
                            sa.put(saFieldName, theWO.get(SERVAPPFIELDSTOWOMAP.get(saFieldName)));
                        }

                        System.debug('Deriving Chargeable field on SA from WO');
                        sa.GDMFSL_Chargeable__c = theWO.GDMFSL_Chargeable__c ? 'Yes' : 'No';
                        System.debug('SA Chargeable is now : ' + sa.GDMFSL_Chargeable__c);
                        if (!theWO.GDMFSL_Created_by_WO_Merge_Process__c && theWO.Duration != null
                                && (sa.Duration == null || !(sa.Duration > 0))) {
                            System.debug('Setting ServiceAppt Duration from WO');
                            sa.Duration = theWO.Duration;
                        }

                        System.debug('SA Duration is now: ' + sa.Duration);

                        if (theWO.LocationId != null && theWO.Location.GDMFSL_Vertical__c != null) {
                            System.debug('Setting SA Vertical from the WO: ' + theWO.Location.GDMFSL_Vertical__c);
                            sa.GDMFSL_Vertical__c = theWO.Location.GDMFSL_Vertical__c;
                        } else if (theWO.LocationId != null && locationMap != null && locationMap.containsKey(theWO.LocationId)) {
                            System.debug('Setting SA Vertical from the Location: ' + locationMap.get(theWO.LocationId).GDMFSL_Vertical__c);
                            sa.GDMFSL_Vertical__c = locationMap.get(theWO.LocationId).GDMFSL_Vertical__c;
                        }

                        System.debug('Vertical on SA is: ' + sa.GDMFSL_Vertical__c);


                        if (theWO.LocationId != null && theWO.Location.GDMFSL_Site_License__c != null) {
                            System.debug('Setting SA Site License from the WO: ' + theWO.Location.GDMFSL_Site_License__c);
                            sa.GDMFSL_Site_License__c = theWO.Location.GDMFSL_Site_License__c;
                        } else if (theWO.LocationId != null && locationMap != null && locationMap.containsKey(theWO.LocationId)) {
                            System.debug('Setting SA Site License from the Location: ' + locationMap.get(theWO.LocationId).GDMFSL_Site_License__c);
                            sa.GDMFSL_Site_License__c = locationMap.get(theWO.LocationId).GDMFSL_Site_License__c;
                        }

                        System.debug('Site License on SA is: ' + sa.GDMFSL_Site_License__c);
                    }
                }
            }
        }

        return parentIDToSAs;
    }


    /**
     * Retrieves ServiceAppointments from SF
     *
     * @param saIds the Set of SAppt Ids to retrieve
     *
     * @return a Map of Id to record
     */
    public static Map<Id, ServiceAppointment> getRecords(Set<Id> saIds) {

        Map<Id, ServiceAppointment> retVals = new Map<Id, ServiceAppointment>();

        for (ServiceAppointment sa : getRecords(saIds, ServiceAppointment.getSObjectType())) {
            retVals.put(sa.Id, sa);
        }

        System.debug('Retrieved ServiceAppointments: ' + retVals);
        return retVals;
    }

    public static Map<Id, Boolean> canSABeCanceled(Map<Id, WorkOrder> wOToCancel, String fieldAPIforReturnId) {
        Map<Id, Boolean> keyIdCanBeCanceled = new Map<Id, Boolean>();
        System.debug('fieldAPIforReturnId:' + fieldAPIforReturnId);
        System.debug('Setting all WO to Cancellable');
        for (Id woId : wOToCancel.keySet()) {
            if (fieldAPIforReturnId == null || fieldAPIforReturnId == 'ParentRecordId') {
                keyIdCanBeCanceled.put(woId, true);
            } else if (fieldAPIforReturnId == 'CaseId') {
                keyIdCanBeCanceled.put(wOToCancel.get(woId).CaseId, true);

            }
        }

        List<ServiceAppointment> theSAs = new List<ServiceAppointment>([
                SELECT Id, Status, ParentRecordId
                FROM ServiceAppointment
                WHERE Status NOT IN :CLOSEDSTATUSES
                AND ParentRecordId IN :wOToCancel.keySet()
        ]);

        List<ServiceAppointment> saToUpdate = new List<ServiceAppointment>();

        for (ServiceAppointment sa : theSAs) {

            System.debug('Looking at SA: ' + sa.Id);
            System.debug('SA Status: ' + sa.Status);

            if (STATUSFORCANCELLATION.contains(sa.Status)) {
                sa.Status = CANCELLEDSTATUS;
                saToUpdate.add(sa);
            } else {
                if (fieldAPIforReturnId == null || fieldAPIforReturnId == 'ParentRecordId') {
                    keyIdCanBeCanceled.put(sa.ParentRecordId, false);
                } else if (fieldAPIforReturnId == 'CaseId') {
                    System.debug('fieldAPIforReturnId = caseId');
                    System.debug('wOToCancel.get(sa.ParentRecordId).CaseId: ' + wOToCancel.get(sa.ParentRecordId).CaseId);
                    keyIdCanBeCanceled.put(wOToCancel.get(sa.ParentRecordId).CaseId, true);
                }
            }
        }

        System.debug('This many SAs to update: ' + saToUpdate.size());

        if (!saToUpdate.isEmpty()) {
            GDMFSL_CommonUtilities.updateRecords(saToUpdate);
        }

        return keyIdCanBeCanceled;
    }

    /**
     * Retrieves ServiceAppointments from WorkOrder
     *
     * @param workorderIds the Set of WorkOrder Ids to retrieve SA
     *
     * @return a List of SA
     */
    public static Map<Id, List<ServiceAppointment>> getRecordsForWOs(Set<Id> workorderIds) {
        Map<Id, List<ServiceAppointment>> woIdToSAs = new Map<Id, List<ServiceAppointment>>();

        for (ServiceAppointment sa : getRecords(workorderIds, WorkOrder.getSObjectType())) {

            if (!woIdToSAs.containsKey(sa.ParentRecordId)) {
                woIdToSAs.put(sa.ParentRecordId, new List<ServiceAppointment>());
            }
            woIdToSAs.get(sa.ParentRecordId).add(sa);
        }

        return woIdToSAs;
    }

    @TestVisible
    private static List<ServiceAppointment> getRecords(Set<Id> iDsToUse, SObjectType typeOfIds) {

        System.debug('ServiceAppointment getRecords() getting for ID type: ' + typeOfIds);

        String queryString = 'SELECT Id, AccountId, ParentRecordId, Status, DurationType, Duration, GDMFSL_Vertical__c, GDMFSL_Service_Contract__c,' +
                'GDMFSL_OT_Labor_in_minutes__c,GDMFSL_PT_Labor_in_minutes__c,GDMFSL_Regular_Labor_in_minutes__c,' +
                'GDMFSL_OT_Travel_in_minutes__c,GDMFSL_PT_Travel_in_minutes__c,GDMFSL_Regular_Travel_in_minutes__c ';
        queryString += ' FROM ServiceAppointment ';

        if (typeOfIds == null || typeOfIds == ServiceAppointment.getSObjectType()) {
            queryString += ' WHERE Id ';
        } else if (typeOfIds == WorkOrder.getSObjectType()) {
            queryString += ' WHERE ParentRecordId ';
        } else if (typeOfIds == ServiceContract.getSObjectType()) {
            queryString += ' WHERE GDMFSL_Service_Contract__c ';
        } else if (typeOfIds == Account.getSObjectType()) {
            queryString += ' WHERE AccountId ';
        }

        queryString += ' IN :iDsToUse';

        System.debug('SA getRecords query: ' + queryString);
        List<ServiceAppointment> saList = Database.query(queryString);

        return saList;
    }


    /**
     * Update ServiceAppointments from WorkOrder
     *
     * @param newWOMap
     * @param oldWOMap
     */
    public static void updateSAFieldsfromWO(Map<Id, WorkOrder> newWOMap) {
        System.debug('updateSAFieldsfromWO()');

        if (newWOMap != null && !newWOMap.isEmpty()) {

            Map<Id, List<ServiceAppointment>> theWOIdToSAs = getRecordsForWOs(newWOMap.keySet());

            System.debug('Fetched Service Appointments: ' + theWOIdToSAs);

            Map<Id, List<ServiceAppointment>> woIDToSAs = setSAFieldsFromWO(theWOIdToSAs, newWOMap);

            List<ServiceAppointment> sasToUpdate = new List<ServiceAppointment>();

            for (List<ServiceAppointment> saList : woIDToSAs.values()) {
                System.debug('Adding ServiceAppts to list for update: ' + saList);
                sasToUpdate.addAll(saList);
            }

            if (!sasToUpdate.isEmpty()) {
                GDMFSL_CommonUtilities.updateRecords(sasToUpdate);
            }
        }
    }

    /**
     * Update related Objects after SA is Completed
     *
     * @param theSAs list of SA's
     */
    public static void processCompletedSAs(List<ServiceAppointment> theSAs) {

        System.debug('Inside GDMFSL_ServiceAppointmentProcessor.processCompletedSAs()');

        Map<Id, ServiceAppointment> completedAppointments = new Map<Id, ServiceAppointment>();

        for (ServiceAppointment sa : theSAs) {
            if (sa.Status == COMPLETEDSTATUS
                    && sa.ParentRecordId != null
                    && sa.ParentRecordId.getSobjectType() == WorkOrder.getSObjectType()) {

                completedAppointments.put(sa.Id, sa);
            }
        }

        System.debug('Total number of Completed SAs: ' + completedAppointments.size());

        if (!completedAppointments.isEmpty()) {

            Map<Id, List<ServiceAppointment>> woIDtoSAs = generateMapWOIdToSA(completedAppointments.values());

            Map<Id, WorkOrder> workOrderMap = fetchSARelatedWO(woIDtoSAs);

            Map<Id, List<AssignedResource>> mapSAtoASR = GDMFSL_AssignedResourceProcessor.getAssignedResByServiceAppointmentId(completedAppointments.keySet());

            Set<WorkOrder> workOrdersToUpdate = new Set<WorkOrder>();
            Map<Id, ServiceContract> sContractsToUpdate = new Map<Id, ServiceContract>();

            for (ServiceAppointment sa : completedAppointments.values()) {

                System.debug('Checking SA: ' + sa.Id);

                if (mapSAtoASR.containsKey(sa.Id)) {

                    System.debug('Checking Assigned Resources');
                    for (AssignedResource r : mapSAtoASR.get(sa.Id)) {

                        if (r.ServiceResource.GDMFSL_IsContractor__c) {

                            for (WorkOrder wo : workOrderMap.values()) {

                                if (!wo.GDMFSL_Executed_by_Sub_Contractor__c) {
                                    wo.GDMFSL_Executed_by_Sub_Contractor__c = true;
                                    workOrdersToUpdate.add(wo);
                                }
                            }
                        }
                    }
                }
            }

            System.debug('Service Contracts to be Updated: ' + sContractsToUpdate.size());
            if (!sContractsToUpdate.isEmpty()) {
                GDMFSL_CommonUtilities.updateRecords(sContractsToUpdate.values());
            }

            System.debug('Work Orders to be Updated: ' + workOrdersToUpdate.size());
            if (!workOrdersToUpdate.isEmpty()) {
                List<WorkOrder> woToUpdate = new List<WorkOrder>();
                woToUpdate.addAll(workOrdersToUpdate);
                GDMFSL_CommonUtilities.updateRecords(woToUpdate);
            }
        }

    }

    /**
     * Generate Map of WorkOrder Id and related List of SA
     *
     * @param lstSA list of Service Appointments to generate Map
     *
     * @return Map of WorkOrder Id and List of ServiceAppointments
     */
    private static Map<Id, List<ServiceAppointment>> generateMapWOIdToSA(List<ServiceAppointment> lstSA) {

        Map<Id, List<ServiceAppointment>> woIDtoSAs = new Map<Id, List<ServiceAppointment>>();

        if (lstSA != null) {
            for (ServiceAppointment sa : lstSA) {
                if (sa.ParentRecordId != null && WorkOrder.SObjectType == sa.ParentRecordId.getSobjectType()) {

                    if (!woIDtoSAs.containsKey(sa.ParentRecordId)) {
                        woIDtoSAs.put(sa.ParentRecordId, new List<ServiceAppointment>());
                    }

                    woIDtoSAs.get(sa.ParentRecordId).add(sa);
                }
            }
        }

        return woIDtoSAs;
    }

    /**
     * Generate Map of WorkOrder Id and WorkOrder passing the list of Service Appointments and ParentId Map
     *
     * @param parentIDToSAs Map of ParentRecordId and List of related SAs
     *
     * @return Map of WorkOrder Id and  WorkOrder
     */
    private static Map<Id, WorkOrder> fetchSARelatedWO(Map<Id, List<ServiceAppointment>> parentIDToSAs) {
        Set<Id> workOrderRefId = new Set<Id>();

        for (List<ServiceAppointment> saList : parentIDToSAs.values()) {
            for (ServiceAppointment sa : saList) {
                if (sa.ParentRecordId != null) {
                    workOrderRefId.add(sa.ParentRecordId);
                }
            }
        }
        System.debug('Getting these WO Ids related to the SAs: ' + workOrderRefId);
        Map<Id, WorkOrder> woInfo = new Map<Id, WorkOrder>(GDMFSL_WorkOrderProcessor.getRecords(workOrderRefId));
        return woInfo;
    }

    public static void updateRelatedWorkOrderStatus(List<ServiceAppointment> theSAs, Map<Id, ServiceAppointment> oldSaMap) {

        List<ServiceAppointment> tempList = new List<ServiceAppointment>();

        System.debug('Service Appointment: ' + theSAs);
        System.debug('Service Appointment Old Map: ' + (oldSaMap != null ? oldSaMap.values() : null));

        for (ServiceAppointment sa : theSAs) {
            if (sa.ParentRecordId != null
                    && sa.ParentRecordId.getSobjectType() == WorkOrder.getSObjectType()
                    && oldSaMap != null
                    && sa.Status != oldSaMap.get(sa.Id).Status) {
                System.debug('SA ParentRecord != null AND SObject is WorkOrder And Old Map n0t null AND SA Status != Old Map Status');
                tempList.add(sa);
            }
        }

        System.debug('SA Temp List : ' + tempList);
        System.debug('SA Temp List : ' + tempList.size());

        if (tempList.size() > 0) {
            GDMFSL_WorkOrderProcessor.updateWorkOrderStatusFromServiceAppointment(tempList);
        }

    }

    public static void unscheduleServContractSAs(Set<Id> servContractIds) {

        List<ServiceAppointment> saToUpdate = new List<ServiceAppointment>();

        for (ServiceAppointment sa : getRecords(servContractIds, ServiceContract.getSObjectType())) {
            if (STATUSFORUNSCHEDULING.contains(sa.Status)) {
                sa.Status = UNSCHEDULEDSTATUS;
                saToUpdate.add(sa);
            }
        }

        System.debug('SAs to Unschedule: ' + saToUpdate.size());

        if (!saToUpdate.isEmpty()) {
            GDMFSL_CommonUtilities.updateRecords(saToUpdate);
        }
    }

    public static void unScheduleAccountBlockedSAs(List<ServiceAppointment> serviceAppointments) {

        for (ServiceAppointment sa : serviceAppointments) {

            if (STATUSFORUNSCHEDULING.contains(sa.Status)) {
                System.debug('SA: ' + sa.Id + ' is being set to Status ' + UNSCHEDULEDSTATUS);
                sa.Status = UNSCHEDULEDSTATUS;
            }
        }

        GDMFSL_CommonUtilities.updateRecords(serviceAppointments);
    }


    public static void deleteSAsIfNeeded(List<ServiceAppointment> saList) {

        List<ServiceAppointment> saToDelete = new List<ServiceAppointment>();
        Set<Id> woIdsToGenSA = new Set<Id>();

        if (saList != null && !saList.isEmpty()) {

            Set<Id> woIdsNeeded = new Set<Id>();

            for (ServiceAppointment theSA : saList) {

                if (theSA.ParentRecordId != null && theSA.ParentRecordId.getSobjectType() == WorkOrder.getSObjectType()) {
                    woIdsNeeded.add(theSA.ParentRecordId);
                }

                if (theSA.ParentRecordId != null && theSA.ParentRecordId.getSobjectType() == WorkOrderLineItem.getSObjectType()) {
                    System.debug('Always delete SA on WOLIs -- they are not needed, but might have been auto-created due to WorkType: ' + theSA.Id);
                    saToDelete.add(new ServiceAppointment(Id = theSA.Id));
                }
            }

            System.debug('Have this many WOs to get: ' + woIdsNeeded.size());

            if (!woIdsNeeded.isEmpty()) {

                Map<Id, WorkOrder> woInfo = new Map<Id, WorkOrder>(GDMFSL_WorkOrderProcessor.getRecords(woIdsNeeded));

                for (ServiceAppointment theSA : saList) {

                    if (theSA.ParentRecordId != null && woInfo.containsKey(theSA.ParentRecordId)
                            && woInfo.get(theSA.ParentRecordId).ServiceTerritoryId != null
                            && (woInfo.get(theSA.ParentRecordId).Status == 'New' || woInfo.get(theSA.ParentRecordId).Status == 'Scheduled')) {

                        System.debug('Checking SA against WO.ServTerr.Max: ' + theSA.Id);
                        System.debug('Checking SA Duration: ' + theSA.DurationInMinutes);
                        System.debug('Checking WO.ServTerr.Max: ' + woInfo.get(theSA.ParentRecordId).ServiceTerritory.GDMFSL_Maximum_SA_Duration_Hrs__c);

                        Double maxSADurationToUse = woInfo.get(theSA.ParentRecordId).ServiceTerritory.GDMFSL_Maximum_SA_Duration_Hrs__c != null
                                ? (woInfo.get(theSA.ParentRecordId).ServiceTerritory.GDMFSL_Maximum_SA_Duration_Hrs__c * 60)
                                : (GDMFSL_ServiceAppointmentGenerator.DEFAULTMAXSERVICEAPPTDURATIONHRS * 60);

                        System.debug('Max SA Duration being used: ' + maxSADurationToUse);

                        if (theSA.DurationInMinutes > maxSADurationToUse) {
                            System.debug('SA Duration is too long -- deleting the SA');
                            saToDelete.add(new ServiceAppointment(Id = theSA.Id));
                            woIdsToGenSA.add(theSA.ParentRecordId);
                        }
                    }
                }
            }

            System.debug('SAs to Delete: ' + saToDelete.size());

            if (!saToDelete.isEmpty() && !GDMFSL_CommonUtilities.isFlagSet('SA Generation from Trigger')) {

                System.debug('Setting flag to prevent Batch recursion');
                GDMFSL_CommonUtilities.setFlag('SA Generation from Trigger');

                GDMFSL_CommonUtilities.deleteRecords(saToDelete);

                if (!woIdsToGenSA.isEmpty()) {
                    System.debug('WO Ids to Generate new SAs: ' + woIdsToGenSA.size());
                    GDMFSL_ServiceAppointmentGenerator genSA = new GDMFSL_ServiceAppointmentGenerator();
                    genSA.woIdsToTestWith.addAll(woIdsToGenSA);
                    Database.executeBatch(genSA);
                }
            }
        }
    }

}