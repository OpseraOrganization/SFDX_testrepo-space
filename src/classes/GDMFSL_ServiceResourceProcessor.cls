/**
 * Name       :    GDMFSL_ServiceResourceProcessor
 * Purpose    :    Business Logic for ServiceResource records
 * --------------------------------------------------------------------------
 * Developer               Date          Description
 * --------------------------------------------------------------------------
 * Jmay                  2020-Sep-10    Created
 **/
public without sharing class GDMFSL_ServiceResourceProcessor {

    private static Map<Id, ServiceResource> theServiceResources = new Map<Id, ServiceResource>();

    public static void removeGeoTracking(List<ServiceResource> newRecs) {

        System.debug('Checking if GeoTracking needs to be removed from the ServRes record');

        Set<Id> servResIds = new Set<Id>();
        for (ServiceResource r : newRecs) {
            servResIds.add(r.Id);
        }

        Map<Id, List<AssignedResource>> servResIdToAssignedResource = GDMFSL_AssignedResourceProcessor.getAssignedResByServiceResourceId(servResIds);

        System.debug('Have these AssignedResources to check: ' + servResIdToAssignedResource);

        for (ServiceResource servRes : newRecs) {
            System.debug('Checking service resource: ' + servRes.Id);

            if (servResIdToAssignedResource.containsKey(servRes.Id)) {

                for (AssignedResource r : servResIdToAssignedResource.get(servRes.Id)) {

                    System.debug('Checking assigned resource: ' + r.Id);

                    if (r.ServiceAppointment.GDMFSL_Disable_GeoTracking__c) {
                        System.debug('ServAppt GDMFSL_Disable_GeoTracking__c is TRUE - need to clear geotracking');
                        clearGeoFields(servRes);
                        break;
                    }
                }
            }
        }
    }

    @TestVisible
    private static void clearGeoFields(ServiceResource servRes) {
        servRes.LastKnownLatitude = null;
        servRes.LastKnownLongitude = null;
    }


    public static Map<Id, ServiceResource> getRecords(Set<Id> recIds) {

        if (recIds != null && !recIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (theServiceResources.isEmpty()) {
                newRecIds.addAll(recIds);
            } else {
                for (Id thisRecId : recIds) {
                    if (!theServiceResources.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                Map<Id, ServiceResource> theRecs = new Map<Id, ServiceResource>([
                        SELECT Id,
                                IsActive,
                                Name,
                                RelatedRecordId, (
                                SELECT Id,
                                        OperatingHoursId,
                                        OperatingHours.TimeZone,
                                        EffectiveStartDate,
                                        EffectiveEndDate,
                                        TerritoryType,
                                        ServiceTerritoryId,
                                        ServiceTerritory.OperatingHours.TimeZone
                                FROM ServiceTerritories
                        )
                        FROM ServiceResource
                        WHERE Id IN :newRecIds

                ]);

                theServiceResources.putAll(theRecs);
                System.debug('Retrieved ServiceResources: ' + theServiceResources);
            }
        }

        return theServiceResources;
    }

    public static void processHolidays(List<ServiceResource> newRecs, Map<Id, ServiceResource> oldMap) {

        System.debug('Holiday processing check for Service Resources');

        if (newRecs != null && oldMap != null) {

            Set<ServiceResource> sResToProcess = new Set<ServiceResource>();

            for (ServiceResource thisSR : newRecs) {

                if (thisSR.IsActive
                        && thisSR.GDMFSL_Holiday_Processing_Range_Start__c != null
                        && thisSR.GDMFSL_Holiday_Processing_Range_End__c != null
                        && (thisSR.GDMFSL_Holiday_Processing_Range_Start__c != oldMap.get(thisSR.Id).GDMFSL_Holiday_Processing_Range_Start__c
                        || thisSR.GDMFSL_Holiday_Processing_Range_End__c != oldMap.get(thisSR.Id).GDMFSL_Holiday_Processing_Range_End__c)) {

                    System.debug('ServRes needs holiday processing: ' + thisSR.Id);
                    sResToProcess.add(thisSR);
                }
            }

            System.debug('Have this many SRes for holiday processing: ' + sResToProcess.size());

            if (!sResToProcess.isEmpty()) {
                adjustSTMsForHolidays(sResToProcess);
            }
        }
    }

    @TestVisible
    private static void adjustSTMsForHolidays(Set<ServiceResource> sResToProcess) {

        System.debug('About to process STMS for SRes: ' + sResToProcess);

        if (sResToProcess != null && !sResToProcess.isEmpty()) {

            System.debug('find STMS for all the ServRes');
            Map<Id, List<ServiceTerritoryMember>> servResIdToSTMs = GDMFSL_ServiceTerritoryProcessor.getSTMs(sResToProcess, true);

            System.debug('Need to get all the OpHours Ids involved');
            Set<Id> opHoursIdsNeeded = new Set<Id>();

            for (Id aServResId : servResIdToSTMs.keySet()) {
                for (ServiceTerritoryMember thisSTM : servResIdToSTMs.get(aServResId)) {
                    if (thisSTM.OperatingHoursId != null) {
                        System.debug('Adding OpHours from the STM: ' + thisSTM.OperatingHoursId);
                        opHoursIdsNeeded.add(thisSTM.OperatingHoursId);
                    } else if (thisSTM.ServiceTerritory.OperatingHoursId != null) {
                        System.debug('Adding OpHours from the ServTerr: ' + thisSTM.ServiceTerritory.OperatingHoursId);
                        opHoursIdsNeeded.add(thisSTM.ServiceTerritory.OperatingHoursId);
                    }
                }
            }

            System.debug('Working with this many Operating Hours: ' + opHoursIdsNeeded.size());

            if (!opHoursIdsNeeded.isEmpty()) {

                Map<Id, List<Date>> opHrsIdToHolidays = GDMFSL_ServiceTerritoryProcessor.getOpHoursHolidayDates(opHoursIdsNeeded);

                Map<Id, String> opHrsIdToTimeZone = new Map<Id, String>();
                Map<String, Id> timeZoneToHolidayOpHrsId = new Map<String, Id>();

                for (OperatingHours opHrs : GDMFSL_ServiceTerritoryProcessor.getOperatingHours(opHoursIdsNeeded)) {

                    opHrsIdToTimeZone.put(opHrs.Id, opHrs.TimeZone);

                    if (opHrs.GDMFSL_Holiday_Operating_Hours__c) {
                        System.debug('Adding Holiday Op Hours for timezone ' + opHrs.TimeZone);
                        timeZoneToHolidayOpHrsId.put(opHrs.TimeZone, opHrs.Id);
                    }
                }

                System.debug('Have OpHrs and Holidays: ' + opHrsIdToHolidays);

                System.debug('Examine all existing STM for each ServRes and insert Holidays as needed');

                Set<ServiceTerritoryMember> stmsToInsert = new Set<ServiceTerritoryMember>();
                Set<ServiceTerritoryMember> stmsToDelete = new Set<ServiceTerritoryMember>();

                for (ServiceResource theServRes : sResToProcess) {

                    System.debug('ServRes: ' + theServRes.Id);
                    System.debug('Holiday Processing Range Start: ' + theServRes.GDMFSL_Holiday_Processing_Range_Start__c);
                    System.debug('Holiday Processing Range End: ' + theServRes.GDMFSL_Holiday_Processing_Range_End__c);

                    if (servResIdToSTMs.containsKey(theServRes.Id)) {

                        System.debug('Found STMs');

                        Date latestProcessedHolidayDate;

                        for (ServiceTerritoryMember thisSTM : servResIdToSTMs.get(theServRes.Id)) {

                            System.debug('Working with Main STM: ' + thisSTM.Id);
                            System.debug('Main STM Effective Start: ' + thisSTM.EffectiveStartDate);
                            System.debug('Main STM Effective End: ' + thisSTM.EffectiveEndDate);

                            if (thisSTM.EffectiveStartDate < theServRes.GDMFSL_Holiday_Processing_Range_End__c
                                    && (thisSTM.EffectiveEndDate == null
                                    || thisSTM.EffectiveEndDate >= theServRes.GDMFSL_Holiday_Processing_Range_Start__c)) {

                                System.debug('STM falls inside the Holiday Processing Date Range');

                                Id opHrsIdToUse;

                                if (thisSTM.OperatingHoursId != null) {
                                    System.debug('Using Operating Hours from the STM');
                                    opHrsIdToUse = thisSTM.OperatingHoursId;
                                } else if (thisSTM.ServiceTerritory.OperatingHoursId != null) {
                                    System.debug('Using Operating Hours from the ServTerritory');
                                    opHrsIdToUse = thisSTM.ServiceTerritory.OperatingHoursId;
                                }

                                System.debug('Found OpHours: ' + opHrsIdToUse);

                                if (opHrsIdToUse == null || !opHrsIdToHolidays.containsKey(opHrsIdToUse)) {
                                    System.debug('Operating Hours are not defined or do not contain Holidays.  No Processing needed.');
                                    continue;
                                }

                                Id holidayOpHrsIdToUse;

                                if (opHrsIdToTimeZone.containsKey(opHrsIdToUse)
                                        && timeZoneToHolidayOpHrsId.containsKey(opHrsIdToTimeZone.get(opHrsIdToUse))) {

                                    holidayOpHrsIdToUse = timeZoneToHolidayOpHrsId.get(opHrsIdToTimeZone.get(opHrsIdToUse));
                                }

                                System.debug('Found Holiday OpHours: ' + holidayOpHrsIdToUse);

                                if (holidayOpHrsIdToUse == null) {
                                    System.debug('No Holiday Operating Hours are defined. No Processing to be done');
                                    continue;
                                }

                                System.debug('Processing Holidays for the OpHours');

                                System.debug('Adding the main STM to be checkedL: ' + thisSTM);
                                ServiceTerritoryMember existSTMToCheck = thisSTM;

                                for (Date thisHol : opHrsIdToHolidays.get(opHrsIdToUse)) {

                                    System.debug('Holiday Date: ' + thisHol);
                                    System.debug('Serv Res Processing Start: ' + theServRes.GDMFSL_Holiday_Processing_Range_Start__c);
                                    System.debug('Serv Res Processing Start: ' + theServRes.GDMFSL_Holiday_Processing_Range_End__c);

                                    if (theServRes.GDMFSL_Holiday_Processing_Range_Start__c <= thisHol
                                            && thisHol <= theServRes.GDMFSL_Holiday_Processing_Range_End__c) {

                                        System.debug('Holiday is inside the Holiday processing timeframe');

                                        System.debug('STMS to Check before while loop: ' + existSTMToCheck);

                                        while (existSTMToCheck != null) {

                                            System.debug('STM to check inside the while loop: ' + existSTMToCheck);

                                            ServiceTerritoryMember theSTM = existSTMToCheck;
                                            System.debug('stmID ' + theSTM.Id);

                                            System.debug('Checking STM with Start Date GMT: ' + theSTM.EffectiveStartDate);
                                            System.debug('Checking STM with End Date GMT: ' + theSTM.EffectiveEndDate);

                                            System.debug('Adjusting GMT Start and End to STM timezone Id: ' + opHrsIdToUse);
                                            System.debug('STM timezone name:  ' + opHrsIdToTimeZone.get(opHrsIdToUse));

                                            Date stmStartDateValueToUse = GDMFSL_CommonUtilities.subtractTimeZoneOffset(theSTM.EffectiveStartDate, opHrsIdToTimeZone.get(opHrsIdToUse)).dateGmt();
                                            Date stmEndDateValueToUse = theSTM.EffectiveEndDate != null ? GDMFSL_CommonUtilities.subtractTimeZoneOffset(theSTM.EffectiveEndDate, opHrsIdToTimeZone.get(opHrsIdToUse)).dateGmt() : null;

                                            System.debug('Checking STM with Start Date timezone adjusted: ' + stmStartDateValueToUse);
                                            System.debug('Checking STM with End Date timezone adjusted: ' + stmEndDateValueToUse);

                                            if (stmStartDateValueToUse <= thisHol
                                                    && (stmEndDateValueToUse == null || stmEndDateValueToUse >= thisHol)) {

                                                System.debug('Holiday is within the STM');

                                                // need to delete the orig so we don't have overlapping STM dates if it is in the DBase
                                                if (theSTM.Id != null) {
                                                    stmsToDelete.add(new ServiceTerritoryMember(Id = theSTM.Id));
                                                } else {
                                                    stmsToInsert.remove(theSTM);
                                                }

                                                System.debug('Create Holiday STM with a StartDate: ' + thisHol);
                                                stmsToInsert.add(createSTM(theSTM, holidayOpHrsIdToUse, thisHol, thisHol, opHrsIdToTimeZone.get(holidayOpHrsIdToUse)));

                                                if (stmStartDateValueToUse == thisHol) {

                                                    System.debug('STM Start is the same as the holiday Date');

                                                    if (stmEndDateValueToUse == null || stmEndDateValueToUse > thisHol) {
                                                        System.debug('Existing STM ends after the holiday so it needs Start moved to the day after the holiday');
                                                        theSTM.EffectiveStartDate = GDMFSL_CommonUtilities.addTimeZoneOffset(thisHol.addDays(1), opHrsIdToTimeZone.get(holidayOpHrsIdToUse));
                                                        theSTM.Id = null;
                                                        stmsToInsert.add(theSTM);
                                                    } else {
                                                        System.debug('STM ends at the holiday, no need for post slice STM');
                                                    }
                                                } else {
                                                    System.debug('STM Start is before the holiday date');

                                                    if (stmEndDateValueToUse == null || stmEndDateValueToUse >= thisHol.addDays(1)) {

                                                        System.debug('STM End is NULL or after the holiday date');

                                                        System.debug('Create the new STM for after the holiday');
                                                        ServiceTerritoryMember newSTM = createSTM(theSTM, null, thisHol.addDays(1), stmEndDateValueToUse, opHrsIdToTimeZone.get(opHrsIdToUse));
                                                        existSTMToCheck = newSTM;
                                                        stmsToInsert.add(newSTM);

                                                    } else {
                                                        System.debug('Existing STM ended at the holiday, no need to create after holiday portion');
                                                    }

                                                    Date preSliceStartDate = stmStartDateValueToUse;

                                                    if (latestProcessedHolidayDate != null && preSliceStartDate < latestProcessedHolidayDate) {
                                                        preSliceStartDate = latestProcessedHolidayDate;
                                                        System.debug('Adjusting pre-slice STM StartDate to previous holiday date + 1: ' + preSliceStartDate.addDays(1));
                                                    }

                                                    System.debug('Adjust Dates of STM to replace the original');
                                                    ServiceTerritoryMember newOrigSTM = createSTM(theSTM, null, preSliceStartDate, thisHol.addDays(-1), opHrsIdToTimeZone.get(opHrsIdToUse));
                                                    stmsToInsert.add(newOrigSTM);
                                                }

                                                latestProcessedHolidayDate = (latestProcessedHolidayDate == null || (latestProcessedHolidayDate < thisHol)) ? thisHol : latestProcessedHolidayDate;
                                                System.debug('Latest Processed Holiday Date set to: ' + latestProcessedHolidayDate);

                                                System.debug('Found the STM for this Holiday, no need to keep looking');
                                                break;

                                            } else {
                                                System.debug('STM does not need to be processed');
                                                break;
                                            }
                                        }
                                    } else {
                                        System.debug('Holiday is outside the Holiday processing timeframe');
                                    }
                                }
                            } else {
                                System.debug('STM Dates do not apply for the Holiday Processing Date range.  Nothing to do. ');
                            }
                        }
                    }
                }

                System.debug('Have this many STMs to delete: ' + stmsToDelete.size());

                if (!stmsToDelete.isEmpty()) {
                    List<ServiceTerritoryMember> stmsForDML = new List<ServiceTerritoryMember>();
                    stmsForDML.addAll(stmsToDelete);
                    GDMFSL_CommonUtilities.deleteRecords(stmsForDML);
                }

                System.debug('Have this many STMs to insert: ' + stmsToInsert.size());

                if (!stmsToInsert.isEmpty()) {
                    for (ServiceTerritoryMember anSTM : stmsToInsert) {
                        System.debug('STM TO BE INSERTED: ' + anSTM);
                    }
                    List<ServiceTerritoryMember> stmsForDML = new List<ServiceTerritoryMember>();
                    stmsForDML.addAll(stmsToInsert);
                    GDMFSL_CommonUtilities.insertRecords(stmsForDML);
                }
            }
        }
    }

    @TestVisible
    private static ServiceTerritoryMember createSTM(ServiceTerritoryMember origSTM, Id opHoursId, Date startDate, Date endDate, String timeZone) {

        ServiceTerritoryMember newSTM = origSTM.clone(false, true);

        if (opHoursId != null) {
            newSTM.OperatingHoursId = opHoursId;
        }

        newSTM.EffectiveStartDate = GDMFSL_CommonUtilities.addTimeZoneOffset(Datetime.newInstanceGmt(startDate, Time.newInstance(0, 0, 0, 0)), timeZone);
        newSTM.EffectiveEndDate = endDate != null ? GDMFSL_CommonUtilities.addTimeZoneOffset(Datetime.newInstanceGmt(endDate, Time.newInstance(23, 59, 59, 999)), timeZone) : null;

        System.debug('Newly-created STM StartDate: ' + newSTM.EffectiveStartDate);
        System.debug('Newly-created STM EndDate: ' + newSTM.EffectiveEndDate);

        return newSTM;
    }

}