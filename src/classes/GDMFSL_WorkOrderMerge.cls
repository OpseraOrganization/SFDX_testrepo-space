/*******************************************************************************************
Name       :    GDMFSL_WorkOrderMerge
Purpose    :    Schedulable WorkOrder merge utility to create a single WorkOrder for each Location/Skill
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
JMay                  2020-Nov-30    Created
**********************************************************************************************/

global without sharing class GDMFSL_WorkOrderMerge implements Schedulable, Database.Batchable<SObject>, Database.Stateful {

    public Boolean deleteOrigWOs;
    public List<Id> woIdsToTestWith;
    public String str_SOQL;
    public Integer mergeBatchSize = 50;

    @TestVisible
    private static final String DEFAULTSYSTEMID = 'NO_SYS';
    @TestVisible
    private static final String DEFAULTSKILLKEY = 'NONE';


    @TestVisible
    private static final String KEYSEP = '~';

    global GDMFSL_WorkOrderMerge() {
        woIdsToTestWith = new List<Id>();
        deleteOrigWOs = true;

        str_SOQL = 'SELECT Id, StartDate, EndDate, ServiceContractId, MaintenancePlan.LocationId,MaintenancePlan.Location.GDMFSL_Service_Territory__r.OperatingHours.TimeZone , ';
        str_SOQL += ' (Select Address, AssetId, AssetWarrantyId, City, Country, CountryCode, CurrencyIsoCode, Description, Discount, Duration, DurationInMinutes ';
        str_SOQL += ' , DurationType, EndDate, FSL__IsFillInCandidate__c, FSL__VisitingHours__c, GeocodeAccuracy, Id, IsClosed, IsGeneratedFromMaintenancePlan ';
        str_SOQL += ' , Latitude, LineItemNumber, ListPrice, LocationId, Longitude, MaintenancePlanId, MaintenanceWorkRuleId, MinimumCrewSize, OrderId ';
        str_SOQL += ' , ParentWorkOrderLineItemId, PostalCode, PricebookEntryId, Priority, Product2Id, Quantity, RecommendedCrewSize, ReturnOrderId ';
        str_SOQL += ' , ReturnOrderLineItemId, RootWorkOrderLineItemId, ServiceAppointmentCount, ServiceReportTemplateId, ServiceTerritoryId, StartDate ';
        str_SOQL += ' , State, StateCode, Status, StatusCategory, Street, Subject, Subtotal, SuggestedMaintenanceDate, TotalPrice, UnitPrice, WorkOrderId ';
        str_SOQL += ' , WorkTypeId, Asset.GDMFSL_Off_Jobsite_System__c From WorkOrderLineItems) ';
        str_SOQL += ' FROM WorkOrder ';
        str_SOQL += ' WHERE (GDMFSL_Created_by_WO_Merge_Process__c = TRUE OR (MaintenanceWorkRule.RecurrencePattern LIKE \'%FREQ=MONTHLY%\' AND IsGeneratedFromMaintenancePlan = TRUE)) ';
        str_SOQL += '  AND MaintenancePlan.GDMFSL_Requires_Assistant__c = FALSE AND MaintenancePlan.GDMFSL_Multi_day_Asset_Maintenance__c = FALSE';
        str_SOQL += '  AND ServiceContractId != NULL AND MaintenancePlan.LocationId != NULL AND MaintenancePlanId != NULL AND (Status = \'New\' OR Status = \'Scheduled\') ';
    }

    global database.QueryLocator start(Database.BatchableContext BC) {

        if (!woIdsToTestWith.isEmpty()) {
            str_SOQL += ' AND Id IN :woIdsToTestWith ';
        }

        str_SOQL += '  ORDER BY ServiceContractId, MaintenancePlan.LocationId ';

        return Database.getQueryLocator(str_SOQL);
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {

        doMerge((List<WorkOrder>) scope);
    }


    global void finish(Database.BatchableContext BC) {

        System.debug('Done merge. Calling GDMFSL_ServiceAppointmentGenerator()');

        GDMFSL_ServiceAppointmentGenerator genSAs = new GDMFSL_ServiceAppointmentGenerator();
        Database.executeBatch(genSAs);
    }

    global void execute(SchedulableContext ctx) {

        Database.executeBatch(new GDMFSL_WorkOrderMerge(), mergeBatchSize);
    }

    @TestVisible
    private void doMerge(List<WorkOrder> theWOs) {

        Map <Id, String> mapLocationIdToTimeZone = new Map<Id, String>();

        if (theWOs != null && !theWOs.isEmpty()) {
            System.debug('Have this many WOs to merge: ' + theWOs.size());

            Set<Id> woIds = new Set<Id>();

            for (WorkOrder thisWO : theWOs) {
                woIds.add(thisWO.Id);
            }

            System.debug('Get WO Skills (if any)');
            Map<Id, List<SkillRequirement>> woIDToSkillReqs = GDMFSL_SkillRequirementProcessor.getRecordsForParentId(woIds);

            Map<Id, String> woIdToSkillIDKey = createWOIdSkillKeys(woIDToSkillReqs);

            // we need this so we can set the max SkillLevel for each Skill on each finished WO
            Map<Id, Map<Id, Decimal>> woIdToSkillIdToMaxLevel = GDMFSL_SkillRequirementProcessor.getParentRecordIdSkillLevels(woIDToSkillReqs);

            System.debug('Ready to start building WO merge buckets');

            Map<Id, Map<Id, Map<String, Map<Date, Map<String, WorkOrder>>>>> bucketMap = new Map<Id, Map<Id, Map<String, Map<Date, Map<String, WorkOrder>>>>>();

            for (WorkOrder thisWO : theWOs) {

                System.debug('WO Id: ' + thisWO.Id);
                System.debug('WO SC: ' + thisWO.ServiceContractId);
                System.debug('WO Location: ' + thisWO.MaintenancePlan.LocationId);
                System.debug('WO Skill Key: ' + getSkillKeyToUse(thisWO.Id, woIdToSkillIDKey));
                System.debug('WO StartDate: ' + thisWO.StartDate != null ? thisWO.StartDate.date() : null);
                System.debug('WO Location TimeZone : ' + thisWO.MaintenancePlan.Location.GDMFSL_Service_Territory__r.OperatingHours.TimeZone);

                if (!bucketMap.containsKey(thisWO.ServiceContractId)) {
                    System.debug('Creating bucket for SC: ' + thisWO.ServiceContractId);
                    bucketMap.put(thisWO.ServiceContractId, new Map<Id, Map<String, Map<Date, Map<String, WorkOrder>>>>());
                }

                if (!bucketMap.get(thisWO.ServiceContractId).containsKey(thisWO.MaintenancePlan.LocationId)) {
                    System.debug('Creating bucket for Location: ' + thisWO.MaintenancePlan.LocationId);
                    bucketMap.get(thisWO.ServiceContractId).put(thisWO.MaintenancePlan.LocationId, new Map<String, Map<Date, Map<String, WorkOrder>>>());
                }

                String skillKeyToUse = getSkillKeyToUse(thisWO.Id, woIdToSkillIDKey);

                if (!bucketMap.get(thisWO.ServiceContractId).get(thisWO.MaintenancePlan.LocationId).containsKey(skillKeyToUse)) {
                    System.debug('Creating bucket for Skill Key: ' + skillKeyToUse);
                    bucketMap.get(thisWO.ServiceContractId).get(thisWO.MaintenancePlan.LocationId).put(skillKeyToUse, new Map<Date, Map<String, WorkOrder>>());
                }

                System.debug('Subtracting Offset on Start Date for timezone : ' + thisWO.MaintenancePlan.Location.GDMFSL_Service_Territory__r.OperatingHours.TimeZone);
                if (!mapLocationIdToTimeZone.containsKey(thisWO.MaintenancePlan.LocationId)) {
                    mapLocationIdToTimeZone.put(thisWO.MaintenancePlan.LocationId, thisWO.MaintenancePlan.Location.GDMFSL_Service_Territory__r.OperatingHours.TimeZone);
                }
                System.debug('WO StartDate Before Subtracting Offset : ' + thisWO.StartDate);
                thisWO.StartDate = GDMFSL_CommonUtilities.subtractTimeZoneOffset(thisWO.StartDate, thisWO.MaintenancePlan.Location.GDMFSL_Service_Territory__r.OperatingHours.TimeZone);
                System.debug('StartDate after Subtracting Offset  :' + thisWO.StartDate);
                Date startDateToUse = thisWO.StartDate.dateGmt();
                System.debug('Start Date to Use in GMT : ' + startDateToUse);

                if (!bucketMap.get(thisWO.ServiceContractId).get(thisWO.MaintenancePlan.LocationId).get(skillKeyToUse).containsKey(startDateToUse)) {
                    System.debug('Creating bucket for Start Date: ' + startDateToUse);
                    bucketMap.get(thisWO.ServiceContractId).get(thisWO.MaintenancePlan.LocationId).get(skillKeyToUse).put(startDateToUse, new Map<String, WorkOrder>());
                }

                if (thisWO.WorkOrderLineItems != null) {
                    for (WorkOrderLineItem woli : thisWO.WorkOrderLineItems) {
                        String sysIdToUse = getSystemIDToUse(woli.Asset.GDMFSL_Off_Jobsite_System__c);

                        if (!bucketMap.get(thisWO.ServiceContractId).get(thisWO.MaintenancePlan.LocationId).get(skillKeyToUse).get(startDateToUse).containsKey(sysIdToUse)) {
                            System.debug('Creating bucket for WOLI Asset System: ' + sysIdToUse);
                            bucketMap.get(thisWO.ServiceContractId).get(thisWO.MaintenancePlan.LocationId).get(skillKeyToUse).get(startDateToUse).put(sysIdToUse, new WorkOrder());
                        }
                    }
                }
            }

            System.debug('Bucket maps are created.  Need to populate the new WOs');
            System.debug('Location TimeZone Map Created : ' + mapLocationIdToTimeZone);
            System.debug('First, get the needed ServiceContract fields');
            Map<Id, ServiceContract> servContractRecs = GDMFSL_ServiceContractProcessor.getRecords(bucketMap.keySet());

            System.debug('Have ServiceContracts to reference: ' + servContractRecs.size());

            System.debug('Find the WorkType for Auto-Generated Work Orders');

            WorkType autoGenWorkType = GDMFSL_WorkTypeProcessor.getWorkTypeForAutoGeneratedWOs();

            System.debug('Assigning this WorkType to Auto-Generated Work Orders: ' + autoGenWorkType);

            List<WorkOrder> wosToCreate = new List<WorkOrder>();

            for (Id scId : bucketMap.keySet()) {
                System.debug('Building WO for SC: ' + scId);

                for (Id locId : bucketMap.get(scId).keySet()) {
                    System.debug('and Location: ' + locId);

                    for (String skillKey : bucketMap.get(scId).get(locId).keySet()) {
                        System.debug('and SkillKey: ' + skillKey);

                        for (Date startDate : bucketMap.get(scId).get(locId).get(skillKey).keySet()) {
                            System.debug('and StartDate: ' + startDate);

                            for (String sysId : bucketMap.get(scId).get(locId).get(skillKey).get(startDate).keySet()) {
                                System.debug('and SystemID: ' + sysId);

                                WorkOrder thisWO = bucketMap.get(scId).get(locId).get(skillKey).get(startDate).get(sysId);

                                thisWO.GDMFSL_Created_by_WO_Merge_Process__c = true;
                                thisWO.WorkTypeId = autoGenWorkType != null ? autoGenWorkType.Id : null;
                                thisWO.ServiceContractId = scId;
                                thisWO.AccountId = servContractRecs.containsKey(scId) ? servContractRecs.get(scId).AccountId : null;
                                thisWO.GDMFSL_Bill_to_Account__c = servContractRecs.containsKey(scId) ? servContractRecs.get(scId).GDMFSL_Bill_to_Account__c : null;
                                thisWO.Subject = 'Maintenance ';
                                thisWO.LocationId = locId;
                                thisWO.StartDate = Datetime.newInstanceGmt(startDate, Time.newInstance(0, 0, 0, 0));

                                System.debug('After setting StartDate with midnight time  : ' + thisWO.StartDate);

                                if (thisWO.StartDate.dayGmt() < 15) {
                                    System.debug('Setting EndDate to the 15th');
                                    thisWO.EndDate = Datetime.newInstanceGmt(thisWO.StartDate.yearGmt(), thisWO.StartDate.monthGmt(), 15, 23, 59, 0);
                                } else {
                                    System.debug('Setting EndDate to the end of the month');
                                    thisWO.EndDate = Datetime.newInstanceGmt(thisWO.StartDate.yearGmt(), thisWO.StartDate.monthGmt(), Date.daysInMonth(thisWO.StartDate.yearGmt(), thisWO.StartDate.monthGmt()), 23, 59, 0);
                                }

                                System.debug('End Date before Offset Calculation : ' + thisWO.EndDate);
                                System.debug('Adding offset to derived Start and EndDate for timezone: ' + mapLocationIdToTimeZone.get(thisWO.LocationId));

                                thisWO.StartDate = GDMFSL_CommonUtilities.addTimeZoneOffset(thisWO.StartDate, mapLocationIdToTimeZone.get(thisWO.LocationId));
                                thisWO.EndDate = GDMFSL_CommonUtilities.addTimeZoneOffset(thisWO.EndDate, mapLocationIdToTimeZone.get(thisWO.LocationId));

                                System.debug('Start Date being commited to DB: ' + thisWO.StartDate);
                                System.debug('End Date being commited to DB: ' + thisWO.EndDate);
                                System.debug('Defined WO to be created: ' + thisWO);

                                wosToCreate.add(thisWO);
                            }
                        }
                    }
                }
            }

            System.debug('Have this many WOs to create: ' + wosToCreate.size());
            if (!wosToCreate.isEmpty()) {
                GDMFSL_CommonUtilities.insertRecords(wosToCreate);
                System.debug('Inserted WOs for Merge: ' + wosToCreate);
            }

            System.debug('Need to create WO Skills');

            List<SkillRequirement> woSkillsToCreate = new List<SkillRequirement>();

            for (Id scId : bucketMap.keySet()) {

                for (Id locId : bucketMap.get(scId).keySet()) {

                    for (String skillKey : bucketMap.get(scId).get(locId).keySet()) {

                        for (Date startDate : bucketMap.get(scId).get(locId).get(skillKey).keySet()) {

                            for (String sysId : bucketMap.get(scId).get(locId).get(skillKey).get(startDate).keySet()) {

                                WorkOrder thisWO = bucketMap.get(scId).get(locId).get(skillKey).get(startDate).get(sysId);

                                System.debug('Building Skills for WO: ' + thisWO.Id);

                                List<String> skillIds = skillKey.split(KEYSEP);

                                for (String thisSkillId : skillIds) {

                                    System.debug('Adding Skill: ' + thisSkillId);

                                    if (thisSkillId != 'NONE') {
                                        SkillRequirement sr = new SkillRequirement(RelatedRecordId = thisWO.Id, SkillId = thisSkillId, SkillLevel = 1);

                                        if (woIdToSkillIdToMaxLevel.containsKey(thisWO.Id) && woIdToSkillIdToMaxLevel.get(thisWO.Id).containsKey(thisSkillId)) {
                                            System.debug('Setting SkillLevel based on Max Level: ' + woIdToSkillIdToMaxLevel.get(thisWO.Id).get(thisSkillId));
                                            sr.SkillLevel = woIdToSkillIdToMaxLevel.get(thisWO.Id).get(thisSkillId);
                                        }

                                        woSkillsToCreate.add(sr);
                                    }
                                }
                            }
                        }
                    }
                }
            }

            System.debug('Have this many WO Skills to create: ' + woSkillsToCreate.size());
            GDMFSL_CommonUtilities.insertRecords(woSkillsToCreate);

            System.debug('Finally, add WOLIs from the original WOs to the newly-created WOs');


            List<WorkOrderLineItem> wolisToInsert = new List<WorkOrderLineItem>();

            for (WorkOrder thisWO : theWOs) {

                System.debug('WO Id: ' + thisWO.Id);
                System.debug('WO SC: ' + thisWO.ServiceContractId);
                System.debug('WO Location: ' + thisWO.MaintenancePlan.LocationId);
                System.debug('WO Skill Key: ' + getSkillKeyToUse(thisWO.Id, woIdToSkillIDKey));
                System.debug('WO StartDate: ' + thisWO.StartDate.dateGmt());

                System.debug('WO has WOLIs: ' + (thisWO.WorkOrderLineItems != null));

                if (thisWO.WorkOrderLineItems != null && thisWO.ServiceContractId != null
                        && thisWO.MaintenancePlan.LocationId != null
                        && thisWO.StartDate != null
                        && mapLocationIdToTimeZone.containsKey(thisWO.MaintenancePlan.LocationId)) {

                    System.debug('Finding the WO to merge WOLIs onto');

                    String skillKeyToUse = getSkillKeyToUse(thisWO.Id, woIdToSkillIDKey);

                    for (WorkOrderLineItem woli : thisWO.WorkOrderLineItems) {
                        String sysIdToUse = getSystemIDToUse(woli.Asset.GDMFSL_Off_Jobsite_System__c);

                        System.debug('Creating new WOLI');
                        WorkOrderLineItem newWoli = woli.clone(false, true, false, false);

                        System.debug('Bucket map : ' + bucketMap);
                        System.debug('Bucket map till start date : ' + bucketMap.get(thisWO.ServiceContractId).get(thisWO.MaintenancePlan.LocationId).get(skillKeyToUse).get(thisWO.StartDate.date()));

                        newWoli.WorkOrderId = bucketMap.get(thisWO.ServiceContractId).get(thisWO.MaintenancePlan.LocationId).get(skillKeyToUse).get(thisWO.StartDate.dateGmt()).get(sysIdToUse).Id;
                        wolisToInsert.add(newWoli);
                    }
                }
            }

            System.debug('This many WOLIs to insert: ' + wolisToInsert.size());
            GDMFSL_CommonUtilities.insertRecords(wolisToInsert);

            System.debug('After the Merge, delete the original WOs? ' + deleteOrigWOs);

            if (deleteOrigWOs) {
                for (WorkOrder theWO : theWOs) {
                    System.debug('Deleting this WO Id: ' + theWO.Id);
                }
                GDMFSL_CommonUtilities.deleteRecords(theWOs);
            }
        }
    }


    @TestVisible
    private static Map<Id, String> createWOIdSkillKeys(Map<Id, List<SkillRequirement>> woIDToSkillReqs) {

        Map<Id, String> retval = new Map<Id, String>();

        if (woIDToSkillReqs != null) {

            for (Id theWOId : woIDToSkillReqs.keySet()) {

                System.debug('Building Skill Keys for WO ID: ' + theWOId);

                retval.put(theWOId, '');

                for (SkillRequirement skillReq : woIDToSkillReqs.get(theWOId)) {
                    retval.put(theWOId, retval.get(theWOId) + skillReq.SkillId + KEYSEP);
                }

                if (retval.get(theWOId) == '') {
                    retval.put(theWOId, DEFAULTSKILLKEY);
                }
                System.debug('The Skill Keys: ' + retval.get(theWOId));
            }
        }

        return retval;
    }

    @TestVisible
    private static String getSkillKeyToUse(Id woId, Map<Id, String> skillKeyMap) {
        return (skillKeyMap.containsKey(woId) ? skillKeyMap.get(woId) : DEFAULTSKILLKEY);
    }

    @TestVisible
    private static String getSystemIDToUse(String assetSystem) {
        return (assetSystem != null ? assetSystem : DEFAULTSYSTEMID);
    }


}