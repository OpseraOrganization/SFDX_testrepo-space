/**
 * Name       :    GDMFSL_CaseProcessor
 * Purpose    :    Business Logic for Case object . See method descriptions for proper context for calling each method
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Bryant                  2020-Oct-08    Created
 **/
public without sharing class GDMFSL_CaseProcessor {

    public static final String CANCELLEDSTATUS = 'Canceled';

    public static final Set<String> CASESTATUSFORCANCELLATION = new Set<String>{
            'New',
            'In Progress'
    };


    private static Map<Id, Case_Routing_Mapping__mdt> mapCaseAndCaseRouting = new Map<Id, Case_Routing_Mapping__mdt>();
    private static final String SERVICEREQUESTRECORDTYPENAME = 'GDMFSL_Service_Request';
    private static final String GENERALINQUIRYRECORDTYPENAME = 'GDMFSL_General_Inquiry';
    private static final String COMMUNITYORIGINNAME = 'Community';

    private static Map<Id, Case> caseMap;

    public static void updateCaseStatusFromWorkOrder(List<WorkOrder> theWOs) {
        Set<Id> woSetId = new Set<Id>();

        for (WorkOrder wo : theWOs) {
            if (wo.CaseId != null) {
                woSetId.add(wo.CaseId);
            }
        }

        if (!woSetId.isEmpty()) {

            Map<Id, Case> mapCase = new Map<Id, Case>([SELECT Id, Status, (SELECT Id, Status, toLabel(StatusCategory) FROM WorkOrders WHERE CaseId IN:woSetId AND Status != 'Completed') FROM Case WHERE Id IN:woSetId]);

            Set<Case> casesToUpdate = new Set<Case>();

            for (WorkOrder wo : theWOs) {

                System.debug('Checking WO: ' + wo.Id);

                if (wo.CaseId != null && mapCase.containsKey(wo.CaseId)) {

                    if (mapCase.get(wo.CaseId).Status != wo.StatusCategory) {
                        System.debug('WO StatusCategory does not match the Case Status');

                        if (wo.StatusCategory == 'Completed') {
                            if (mapCase.get(wo.CaseId).WorkOrders.isEmpty()) {
                                mapCase.get(wo.CaseId).Status = wo.StatusCategory == 'InProgress' ? 'In Progress' : wo.StatusCategory;
                                casesToUpdate.add(mapCase.get(wo.CaseId));
                            }
                        } else {
                            mapCase.get(wo.CaseId).Status = wo.StatusCategory == 'InProgress' ? 'In Progress' : wo.StatusCategory;
                            casesToUpdate.add(mapCase.get(wo.CaseId));
                        }
                    }
                }
            }

            if (!casesToUpdate.isEmpty()) {
                List<Case> c = new List<Case>();
                c.addAll(casesToUpdate);
                System.debug('cases To Update ' + c);
                GDMFSL_CommonUtilities.updateRecords(c);
            }
        }
    }

    public static void closeRelatedWorkOrdersAndServiceAppointments(Map<Id, Case> newMap, Map<Id, Case> oldMap) {

        Set<Id> caseIdsThatCanBeClosed = getCaseIDsThatCanBeClosed(newMap.values(), oldMap);

        System.debug('this many Case IDs can be closed: ' + caseIdsThatCanBeClosed.size());


        if (!caseIdsThatCanBeClosed.isEmpty()) {

            Map<Id, Boolean> tobeCancelledKeyIdMap = GDMFSL_WorkOrderProcessor.canWOBeCanceled(caseIdsThatCanBeClosed);

            System.debug('Map of returned Case Ids: ' + tobeCancelledKeyIdMap);

            for (Id tobeCancelledCaseId : tobeCancelledKeyIdMap.keySet()) {

                if (!tobeCancelledKeyIdMap.get(tobeCancelledCaseId)) {
                    newMap.get(tobeCancelledCaseId).addError(System.Label.Invalid_Case_Cancellation_Message);
                }
            }
        }
    }

    public static void assessCaseCompleted(List<Case> newRecs, Map<Id, Case> oldMap){
        Id genInqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(GENERALINQUIRYRECORDTYPENAME).getRecordTypeId();
        
        for (Case theCase : newRecs) {
            if(theCase.Status == CANCELLEDSTATUS
                        && theCase.Status != oldMap.get(theCase.Id).Status
                        && !CASESTATUSFORCANCELLATION.contains(oldMap.get(theCase.Id).Status)
                        && theCase.RecordTypeId == genInqRecTypeId){
                            theCase.addError(System.Label.Invalid_Gen_Inq_Case_Cancellation_Message);

            }
        }

    }

    @TestVisible
    private static Set<Id> getCaseIDsThatCanBeClosed(List<Case> newRecs, Map<Id, Case> oldMap) {

        Set<Id> caseIDCanBeClosed = new Set<Id>();

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(SERVICEREQUESTRECORDTYPENAME).getRecordTypeId();
        System.debug('Case Record Type  Id : '+servReqRecTypeId);
        for (Case theCase : newRecs) {

            System.debug('Checking Case: ' + theCase.Id);
            System.debug('Status: ' + theCase.Status);
            System.debug('Current Case Record Type Id : '+theCase.RecordTypeId);
            System.debug('Old Case Map : '+oldMap.get(theCase.Id));
            if (theCase.Status == CANCELLEDSTATUS
                   // && theCase.Status != oldMap.get(theCase.Id).Status
                   // && CASESTATUSFORCANCELLATION.contains(oldMap.get(theCase.Id).Status)
                    && theCase.RecordTypeId == servReqRecTypeId) {

                System.debug('Case can be closed');
                    caseIDCanBeClosed.add(theCase.Id);
                  
            }
        }

       return caseIDCanBeClosed; 
  
    }

    public static Map<Id, Case> getRecords(Set<Id> caseIds) {
        if (caseMap == null) {
            caseMap = new Map<Id, Case>([
                    SELECT Id,
                            AssetId,
                            CreatedDate
                    FROM Case
                    WHERE Id IN :caseIds
            ]);
        }
        return caseMap;
    }

    public static void setCaseFields(List<Case> theCases) {

        Set<String> origins = new Set<String>();
        Set<String> regions = new Set<String>();
        List<Case> toBeWorkedOnCases = new List<Case>();

        Id servReqRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(SERVICEREQUESTRECORDTYPENAME).getRecordTypeId();

        for (Case theCase : theCases) {

            System.debug('CaseRecordTypeId : Service Request recordType Id :' + theCase.RecordTypeId + ' : ' + Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(SERVICEREQUESTRECORDTYPENAME));

            if (theCase.Origin == COMMUNITYORIGINNAME
                    && theCase.RecordTypeId != null
                    && theCase.RecordTypeId == servReqRecTypeId) {

                toBeWorkedOnCases.add(theCase);
                origins.add(theCase.Origin);
                regions.add(theCase.Region__c);
            }
        }

        System.debug('Number of Cases with Service Request and Community Origin are  : ' + toBeWorkedOnCases.size());

        if (!toBeWorkedOnCases.isEmpty()) {

            if (!origins.isEmpty() && !regions.isEmpty()) {
                mapCaseAndCaseRouting = getCaseRoutingRecords(origins, regions);
            }

            Map<Id, String> mapCaseIdToQueueName = new Map<Id, String>();

            for (Case theCase : toBeWorkedOnCases) {

                for (Case_Routing_Mapping__mdt crm : mapCaseAndCaseRouting.values()) {

                    System.debug('Record Type Match : ' + (theCase.RecordTypeId == servReqRecTypeId));
                    System.debug('Region Match : ' + (crm.Region__c != null ? crm.Region__c.equals(theCase.Region__c) : false));
                    System.debug('Origin Match : ' + (crm.Origin__c != null ? crm.Origin__c.equals(theCase.Origin) : false));

                    if (theCase.RecordTypeId == servReqRecTypeId
                            && crm.Region__c != null && crm.Region__c.equals(theCase.Region__c)
                            && crm.Origin__c != null && crm.Origin__c.equals(theCase.Origin)
                            && crm.Queue__c != null) {

                        mapCaseIdToQueueName.put(theCase.Id, crm.Queue__c);
                        break;
                    }
                }
            }

            Map<String, Id> mapQueueIdToQueueName = getQueueIdFromNames(mapCaseIdToQueueName.values());

            for (Case theCase : toBeWorkedOnCases) {

                if (mapCaseIdToQueueName.containsKey(theCase.Id)
                        && mapQueueIdToQueueName.containsKey(mapCaseIdToQueueName.get(theCase.Id))) {

                    theCase.OwnerId = mapQueueIdToQueueName.get(mapCaseIdToQueueName.get(theCase.Id));
                    System.debug('Case OwnerId being set to : ' + theCase.OwnerId);
                }
            }
        }
    }

    @TestVisible
    private static Map<String, Id> getQueueIdFromNames(List<String> qNames) {

        System.debug('Queue Names Passed : ' + qNames);

        Map<String, Id> mapQueueIdAndQueueName = new Map<String, Id>();

        if (!qNames.isEmpty()) {

            for (Group queueGroup : [
                    SELECT Id,
                            Name
                    FROM Group
                    WHERE Name IN :qNames
                    AND Type = 'Queue'
            ]) {

                mapQueueIdAndQueueName.put(queueGroup.Name, queueGroup.Id);
            }
        }

        System.debug('Number of records returned from Group related to the queue :' + mapQueueIdAndQueueName.size());
        return mapQueueIdAndQueueName;
    }

    @TestVisible
    private static Map<Id, Case_Routing_Mapping__mdt> getCaseRoutingRecords(Set<String> origins, Set<String> regions) {

        if (mapCaseAndCaseRouting.isEmpty()) {

            mapCaseAndCaseRouting = new Map<Id, Case_Routing_Mapping__mdt>([
                    SELECT Id,
                            Origin__c,
                            Region__c,
                            Record_Type__c,
                            DeveloperName,
                            Queue__c
                    FROM Case_Routing_Mapping__mdt
                    WHERE Origin__c IN :origins
                    AND Region__c IN :regions

            ]);
        }

        System.debug('Number of records returned from Case Routing MetaData : ' + mapCaseAndCaseRouting.size());
        return mapCaseAndCaseRouting;
    }


    @Future
    public static void cancelContractRelatedCases(Set<Id> serviceContractIds) {

        List<Case> theCases = new List<Case>([
                SELECT Id,
                        Status, ServiceContractId,
                        ServiceContract.Name

                FROM Case
                WHERE
                ServiceContractId IN :serviceContractIds
                AND Status IN :CASESTATUSFORCANCELLATION
        ]);

        for (Case c : theCases) {
            System.debug('Setting Case Status to Canceled: ' + c.Id);
            c.Status = CANCELLEDSTATUS;
        }
        System.debug('theCases.isEmpty()' + theCases.isEmpty());
        if (!theCases.isEmpty()) {
            try {
                GDMFSL_CommonUtilities.updateRecords(theCases, false);
            } catch (Exception ex) {
                System.debug('The following error occurred while doing Cancellation of Cases: ' + ex.getMessage());
            }
        }
    }


}