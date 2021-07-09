/*******************************************************************************************
Name       :    GDMFSL_ShiftPatternAssignmentProcessor
Purpose    :    Processor for GDMFSL_ShiftPatternAssignment object
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
UZaroo                  2021-Feb-10    Created
**********************************************************************************************/

public without sharing class GDMFSL_ShiftPatternAssignmentProcessor {

    public static final String SHIFTPATTERNASSIGNMENTCOMPLETEDSTATUS = 'Completed';

    private static final String SHIFTSTATUSCONFIRMED = 'Confirmed';
    private static final String SHIFTTIMESLOTTYPE = 'Normal';

    private static Map<Id, ShiftPattern> mapShiftPattern = new Map<Id, ShiftPattern>();
    private static Map<Id, ServiceTerritory> mapServiceTerritory = new Map<Id, ServiceTerritory>();
    private static Map<Id, ServiceResource> mapServiceResource = new Map<Id, ServiceResource>();
    private static Map<String, RecordsetFilterCriteria> mapNameAndRecordSetFilter = new Map<String, RecordsetFilterCriteria>();
    private static List<Shift_Pattern_Assignment__c> tobeUpdatedSPAs = new List<Shift_Pattern_Assignment__c>();


    private static Map<Id, ShiftPattern> theShiftPatternMap = new Map<Id, ShiftPattern>();
    private static Map<String, RecordsetFilterCriteria> recSetMapByName = new Map<String, RecordsetFilterCriteria>();

    public static void findShiftPattern(List<Shift_Pattern_Assignment__c> theSPatternAssignments) {

        Set<Id> serviceTerriToryIds = new Set<Id>();
        Set<Id> serviceResourceIds = new Set<Id>();
        List<Shift_Pattern_Assignment__c> toBeUsedSPA = new List<Shift_Pattern_Assignment__c>();

        Set<String> recordSetFilterCriteriaStrings = new Set<String>();
        Map<Id, List<Shift_Pattern_Assignment__c>> mapShiftPatternAndSPatternAssignments = new Map<Id, List<Shift_Pattern_Assignment__c>>();

        for (Shift_Pattern_Assignment__c spa : theSPatternAssignments) {

            if (spa.Status__c != SHIFTPATTERNASSIGNMENTCOMPLETEDSTATUS) {

                toBeUsedSPA.add(spa);

                if (spa.Service_Territory__c != null) {
                    serviceTerriToryIds.add(spa.Service_Territory__c);
                } else if (spa.Service_Resource__c != null) {
                    serviceResourceIds.add(spa.Service_Resource__c);
                }

                System.debug('Service resource IDs Count : ' + serviceResourceIds);
                System.debug('Service Territory IDs Count : ' + serviceTerriToryIds);

                if (spa.Recordset_Filter_Criteria__c != null) {
                    recordSetFilterCriteriaStrings.add(spa.Recordset_Filter_Criteria__c);
                }

                System.debug('Record Set Filter Names : ' + recordSetFilterCriteriaStrings);

                if (spa.Shift_Pattern__c != null && !mapShiftPatternAndSPatternAssignments.containsKey(spa.Shift_Pattern__c)) {
                    mapShiftPatternAndSPatternAssignments.put(spa.Shift_Pattern__c, new List<Shift_Pattern_Assignment__c>());
                }

                mapShiftPatternAndSPatternAssignments.get(spa.Shift_Pattern__c).add(spa);
            }
        }

        System.debug('Number of unique Shift Patterns related to shiftPatternAssignments : ' + mapShiftPatternAndSPatternAssignments.size());
        System.debug('Fetching Shift Pattern and Related Shift Entries');

        if (!mapShiftPatternAndSPatternAssignments.isEmpty()) {

            mapShiftPattern = getShiftPatternRecords(mapShiftPatternAndSPatternAssignments.keySet());
            System.debug('Map of Shift pattern : + ' + mapShiftPattern);
        }

        if (!serviceTerriToryIds.isEmpty()) {
            mapServiceTerritory = GDMFSL_ServiceTerritoryProcessor.getRecords(serviceTerriToryIds);
            System.debug('Map of Service Territory : ' + mapServiceTerritory);
        }

        if (!serviceResourceIds.isEmpty()) {
            mapServiceResource = GDMFSL_ServiceResourceProcessor.getRecords(serviceResourceIds);
        }

        if (!recordSetFilterCriteriaStrings.isEmpty()) {
            mapNameAndRecordSetFilter = getRecordSetFilterCriteria(recordSetFilterCriteriaStrings);
            System.debug('Fetched Map of RecordFilterCriteria : ' + mapNameAndRecordSetFilter);
        }

        List<Shift> tobeCreatedShifts = new List<Shift>();

        for (Shift_Pattern_Assignment__c spa : toBeUsedSPA) {

            Double numberOfShiftsToBeCreated = 0;

            System.debug('Finding number of Shifts to be created for Shift PatterAssignment : ' + spa);

            if (spa.Scheduling_End_Date__c != null) {

                Double dayBetween = spa.Scheduling_Start_Date__c.daysBetween(spa.Scheduling_End_Date__c) + 1;

                System.debug('Total Number of Days within Shift Pattern Assignment : ' + dayBetween);

                Integer sizeofPatternEntries = mapShiftPattern.get(spa.Shift_Pattern__c).ShiftPatternEntries.size();
                Integer shiftPatternLength = mapShiftPattern.get(spa.Shift_Pattern__c).PatternLength;

                System.debug('Related Shift Pattern Entries Size : ' + sizeofPatternEntries);
                System.debug('ShiftPattern Lenght is  : ' + shiftPatternLength);

                if (dayBetween > shiftPatternLength) {

                    //Days-(Mod(Days,PattLen) * Diff(PattLen,Entries))
                    numberOfShiftsToBeCreated = dayBetween - (Math.floor(dayBetween / shiftPatternLength) * (shiftPatternLength - sizeofPatternEntries));

                } else if (dayBetween <= shiftPatternLength) {

                    if (dayBetween < sizeofPatternEntries) {
                        numberOfShiftsToBeCreated = dayBetween;
                    } else {
                        numberOfShiftsToBeCreated = sizeofPatternEntries ;
                    }
                }

            } else if (spa.Scheduling_Occurrences__c != null) {
                numberOfShiftsToBeCreated = mapShiftPattern.get(spa.Shift_Pattern__c).ShiftPatternEntries.size() * (Integer) spa.Scheduling_Occurrences__c;
            }

            System.debug('Going to method for creating shifts for SPA  :  ' + spa);
            System.debug('Number of Shifts to be created for SPA  :  ' + numberOfShiftsToBeCreated);

            tobeCreatedShifts.addAll(createShifts(spa, (Integer) numberOfShiftsToBeCreated));
        }

        if (!tobeCreatedShifts.isEmpty()) {

            System.debug('Shifts which will get created ' + tobeCreatedShifts);

            if (GDMFSL_CommonUtilities.insertRecords(tobeCreatedShifts)
                    && !tobeUpdatedSPAs.isEmpty()) {

                System.debug('Shift Pattern Assignments related shifts have been created, setting status to complete');
                System.debug('Updating records on SPA: ' + tobeUpdatedSPAs);

                for (Shift_Pattern_Assignment__c spa : tobeUpdatedSPAs) {
                    spa.Status__c = SHIFTPATTERNASSIGNMENTCOMPLETEDSTATUS;
                }
            }
        }
    }

    @TestVisible
    private static List<Shift> createShifts(Shift_Pattern_Assignment__c theSPA, Integer numberOfShiftsToBeCreated) {


        List<Shift> newShiftsToReturn = new List<Shift>();

        if (theSPA == null || numberOfShiftsToBeCreated < 1) {
            System.debug('No shifts to be created, returning');
            return newShiftsToReturn;
        }

        System.debug('Creating Shifts for SPA: ' + theSPA.Id);
        System.debug('Number of Shifts to Create: ' + numberOfShiftsToBeCreated);

        Id recordSetFilterCriteriaId = mapNameAndRecordSetFilter.containsKey(theSPA.Recordset_Filter_Criteria__c)
                ? mapNameAndRecordSetFilter.get(theSPA.Recordset_Filter_Criteria__c).Id
                : null;

        System.debug('RecordSetFilterId to be used: ' + recordSetFilterCriteriaId);

        Integer maxDayPosition = 7;
        Map<Integer, ShiftPatternEntry> mapDayToShiftPatternEntry = new Map<Integer, ShiftPatternEntry>();

        if (mapShiftPattern.containsKey(theSPA.Shift_Pattern__c)) {

            if (mapShiftPattern.get(theSPA.Shift_Pattern__c).PatternLength != null) {
                maxDayPosition = mapShiftPattern.get(theSPA.Shift_Pattern__c).PatternLength;
                System.debug('Shift pattern Length is: ' + mapShiftPattern.get(theSPA.Shift_Pattern__c).PatternLength);
            }

            if (!mapShiftPattern.get(theSPA.Shift_Pattern__c).ShiftPatternEntries.isEmpty()) {

                for (ShiftPatternEntry spe : mapShiftPattern.get(theSPA.Shift_Pattern__c).ShiftPatternEntries) {
                    mapDayToShiftPatternEntry.put(spe.DayOrder, spe);
                }

                System.debug('Shift Pattern Entry Count is: ' + mapDayToShiftPatternEntry.size());
                System.debug('Shift Pattern Entry: ' + mapDayToShiftPatternEntry);
            }
        }

        Datetime currentStartDate = (Datetime) theSPA.Scheduling_Start_Date__c;
        Integer numShiftRecordsCreated = 0;

        while (numShiftRecordsCreated < numberOfShiftsToBeCreated) {

            System.debug('Max Day Position is: ' + maxDayPosition);
            System.debug('Current Started Date: ' + currentStartDate);

            for (Integer thisDayPosition = 0; thisDayPosition < maxDayPosition; thisDayPosition++) {

                System.debug('Looking at Day: ' + thisDayPosition);

                Datetime currentLoopedStartDate = currentStartDate.addDays(thisDayPosition);

                Integer shiftPatternEntryDayNumber = ((Integer) Math.mod(currentStartDate.date().daysBetween(currentLoopedStartDate.date()), maxDayPosition) + 1);

                System.debug('Day for which it will search the Shift Pattern Entry: ' + shiftPatternEntryDayNumber);

                if (mapDayToShiftPatternEntry.containsKey(shiftPatternEntryDayNumber)) {

                    ShiftPatternEntry spe = mapDayToShiftPatternEntry.get(shiftPatternEntryDayNumber);

                    System.debug('Shift Pattern Entry to use: ' + spe);

                    if (spe.ShiftTemplate != null) {

                        System.debug('Have a ShiftTemplate so creating Shifts for Day: ' + thisDayPosition);

                        Shift aNewShift = new Shift();

                        aNewShift.StartTime = currentStartDate.addDays(thisDayPosition);
                        System.debug('Start Time before adding Time part : ' + aNewShift.StartTime);
                        String durationType = spe.ShiftTemplate.ShiftTemplateDurationType;
                        System.debug('Duration Type : ' + durationType);
                        Decimal totalDuration = spe.ShiftTemplate.Duration;
                        System.debug('Total Duration : ' + totalDuration);


                        // if (durationType != null && durationType == 'Minutes') {
                        // totalDuration = totalDuration / 60;
                        //  }

                        if (durationType != null && durationType == 'H') {
                            System.debug('Converting hours to Minutes: ' + totalDuration);
                            totalDuration = totalDuration * 60;
                            System.debug('Duration in Minutes: ' + totalDuration);
                        }

                        System.debug('Time to start the shift : ' + spe.ShiftTemplate.StartTime);
                        aNewShift.StartTime = Datetime.newInstance(aNewShift.StartTime.dateGmt(), spe.ShiftTemplate.StartTime);
                        aNewShift.EndTime = aNewShift.StartTime.addMinutes((Integer) totalDuration);

                        System.debug('shift Start date set to: ' + aNewShift.StartTime);
                        System.debug('shift End date set to: ' + aNewShift.EndTime);

                        aNewShift.ServiceResourceId = theSPA.Service_Resource__c;
                        aNewShift.ServiceTerritoryId = theSPA.Service_Territory__c;
                        aNewShift.RecordsetFilterCriteriaId = recordSetFilterCriteriaId;
                        aNewShift.Status = SHIFTSTATUSCONFIRMED;
                        aNewShift.TimeSlotType = SHIFTTIMESLOTTYPE;

                        newShiftsToReturn.add(aNewShift);
                        numShiftRecordsCreated++;
                    } else {
                        System.debug('No ShiftTemplate so note creating Shifts for Day: ' + thisDayPosition);
                    }
                } else {
                    System.debug('No Entry in Shift Pattern Entries for Day: ' + thisDayPosition);
                }

                if (numShiftRecordsCreated < numberOfShiftsToBeCreated) {
                    if (thisDayPosition == (maxDayPosition - 1)) {
                        System.debug('Adjust currentStartDate in case we need shifts on a different day');
                        currentStartDate = currentLoopedStartDate.addDays(1);
                    }
                } else {
                    System.debug('Already created maxRequestedShifts exiting dayPosition Loop');
                    break;
                }
            }
        }

        tobeUpdatedSPAs.add(theSPA);

        System.debug('Number of Shifts to be Created are: ' + newShiftsToReturn.size());
        return newShiftsToReturn;
    }


    public static Map<Id, ShiftPattern> getShiftPatternRecords(Set<Id> shiftPatterIds) {


        if (shiftPatterIds != null && !shiftPatterIds.isEmpty()) {

            Set<Id> newRecIds = new Set<Id>();

            if (theShiftPatternMap.isEmpty()) {
                newRecIds.addAll(shiftPatterIds);
            } else {
                for (Id thisRecId : shiftPatterIds) {
                    if (!theShiftPatternMap.containsKey(thisRecId)) {
                        newRecIds.add(thisRecId);
                    }
                }
            }

            if (!newRecIds.isEmpty()) {

                Map<Id, ShiftPattern> theRecs = new Map<Id, ShiftPattern>([
                        SELECT Id,
                                Name,
                                PatternLength, (
                                SELECT Id
                                        , ShiftTemplateId,
                                        DayOrder,
                                        ShiftTemplate.StartTime,
                                        ShiftTemplate.Duration,
                                        ShiftTemplate.ShiftTemplateDurationType

                                FROM ShiftPatternEntries
                        )
                        FROM ShiftPattern
                        WHERE Id IN :newRecIds

                ]);

                theShiftPatternMap.putAll(theRecs);
                System.debug('Retrieved ShiftPatterns: ' + theShiftPatternMap);
            }
        }

        return theShiftPatternMap;
    }

    public static Map<String, RecordsetFilterCriteria> getRecordSetFilterCriteria(Set<String> recordSetNames) {


        if (recordSetNames != null && !recordSetNames.isEmpty()) {

            Set<String> newNames = new Set<String>();

            if (recSetMapByName.isEmpty()) {
                newNames.addAll(recordSetNames);
            } else {
                for (String thisName : recordSetNames) {
                    if (!recSetMapByName.containsKey(thisName)) {
                        newNames.add(thisName);
                    }
                }
            }

            if (!newNames.isEmpty()) {

                for (RecordsetFilterCriteria thisRecSet : [
                        SELECT Id, Name
                        FROM RecordsetFilterCriteria
                        WHERE Name IN :recordSetNames

                ]) {
                    recSetMapByName.put(thisRecSet.Name, thisRecSet);
                }

                System.debug('Retrieved RecordSetFilterCriteria: ' + recSetMapByName);
            }
        }

        return recSetMapByName;
    }

}