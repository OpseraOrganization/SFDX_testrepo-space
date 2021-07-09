/**
 * @description       : 
 * @author            : Bryant Daniels
 * @group             : 
 * @last modified on  : 01-25-2021
 * @last modified by  : Bryant Daniels
 * Modifications Log 
 * Ver   Date         Author           Modification
 * 1.0   01-22-2021   Bryant Daniels   Initial Version
**/
public without sharing class GDMFSL_ShiftProcessor {
    public static String PRIMARYTERRITORYTYPEVALUE = 'P';

    private static Map<Id, Shift> mapShifts = new Map<Id, Shift>();


    public static void assignShiftOwner(List<Shift> newList) {
        Set<Id> srIds = new Set<Id>();

        for (Shift s : newList) {
            if (s.ServiceResourceId != null) {
                srIds.add(s.ServiceResourceId);
            }
        }

        System.debug('srIds: ' + srIds);

        if (!srIds.isEmpty()) {
            Map<Id, ServiceResource> serviceResourceMap = GDMFSL_ServiceResourceProcessor.getRecords(srIds);
            for (Shift sh : newList) {
                if (sh.ServiceResourceId != null) {
                    if (serviceResourceMap.containsKey(sh.ServiceResourceId)
                            && serviceResourceMap.get(sh.ServiceResourceId).IsActive == true) {

                        sh.OwnerId = serviceResourceMap.get(sh.ServiceResourceId).RelatedRecordId;
                    }
                }
            }
        }
    }

    public static void updateShiftOwner(List<Shift> Shifts, Map<Id, Shift> oldShiftMap) {
        List<Shift> tempList = new List<Shift>();

        for (Shift theShift : Shifts) {
            if (theShift.ServiceResourceId != oldShiftMap.get(theShift.Id).ServiceResourceId) {
                System.debug('Switching Service Resources for Shift: ' + theShift.Id);
                tempList.add(theShift);
            }
        }

        if (tempList.size() > 0) {
            assignShiftOwner(tempList);
        }
    }

    public static void setShiftStartEndBasedOnTimezone(List<Shift> Shifts, Map<Id, Shift> oldShiftMap) {
        Set<Id> serviceTerriToryIds = new Set<Id>();
        Set<Id> serviceResourceIds = new Set<Id>();

        Map<Id, ServiceTerritory> mapServiceTerritory = new Map<Id, ServiceTerritory>();
        Map<Id, ServiceResource> mapServiceResource = new Map<Id, ServiceResource>();

        Set<Id> ShiftSet = new Set<Id>();
        List<Shift> shiftsToWorkWith = new List<Shift>();
        system.debug('inside setShiftStartEndBasedOnTimezone');

        for (Shift shift : Shifts) {
            if (oldShiftMap != null) {
                System.debug('oldShiftMap is NOT null - case of Update');
                if (shift.StartTime != oldShiftMap.get(shift.Id).StartTime || shift.EndTime != oldShiftMap.get(shift.Id).EndTime) {
                    if (shift.ServiceTerritory != null) {
                        serviceTerriToryIds.add(shift.ServiceTerritoryId);
                    }
                    if (shift.ServiceResourceId != null) {
                        serviceResourceIds.add(shift.ServiceResourceId);
                    }
                    shiftsToWorkWith.add(shift);
                    ShiftSet.add(shift.Id);
                }
            } else if (oldShiftMap == null) {
                System.debug('oldShiftMap is  null - case of create');
                System.debug('Shift.ST' + shift.ServiceTerritory);
                System.debug('Shift.STID' + shift.ServiceTerritoryId);
                if (shift.ServiceTerritoryId != null) {
                    serviceTerriToryIds.add(shift.ServiceTerritoryId);
                }
                if (shift.ServiceResourceId != null) {
                    serviceResourceIds.add(shift.ServiceResourceId);
                }
                shiftsToWorkWith.add(shift);
            }

        }
        system.debug('shiftsToWorkWith' + shiftsToWorkWith);
        if (!serviceTerriToryIds.isEmpty()) {
            mapServiceTerritory = GDMFSL_ServiceTerritoryProcessor.getRecords(serviceTerriToryIds);
            System.debug('Map of Service Territory : ' + mapServiceTerritory);
        }

        if (!serviceResourceIds.isEmpty()) {
            mapServiceResource = GDMFSL_ServiceResourceProcessor.getRecords(serviceResourceIds);
            System.debug('Map of Service Resources : ' + mapServiceResource);
        }

        string timezone;
        for (Shift theShift : shiftsToWorkWith) {
            system.debug('this shift has detected change in start/finish time:' + theShift);
            timezone = GDMFSL_ShiftProcessor.getShiftTimeZoneForShift(theShift,mapServiceTerritory,mapServiceResource);
            GDMFSL_ShiftProcessor.updateShiftStartFinishWithTimezoneOffset(theShift, timezone, true);
        }
    }
    @TestVisible
    private static String getShiftTimeZoneForShift(Shift theShift, Map<Id, ServiceTerritory> mapServiceTerritory, Map<Id, ServiceResource> mapServiceResource) {
        system.debug('inside getShiftTimeZoneForShift');
        string timezoneTobeUsed;
        system.debug('mapServiceTerritory' + mapServiceTerritory);
        System.debug('mapServiceResource' + mapServiceResource);

        if (theShift.ServiceTerritoryId != null
                && mapServiceTerritory.containsKey(theShift.ServiceTerritoryId)) {
            timezoneTobeUsed = mapServiceTerritory.get(theShift.ServiceTerritoryId).OperatingHours.TimeZone;
            System.debug('Timezone got when ST->Operating Hours -> timezone:  ' + timezoneTobeUsed);
        } else if (theShift.ServiceResourceId != null && mapServiceResource.containsKey(theShift.ServiceResourceId)) {
            for (ServiceTerritoryMember stm : mapServiceResource.get(theShift.ServiceResourceId).ServiceTerritories) {
                if (stm.TerritoryType == PRIMARYTERRITORYTYPEVALUE && theShift.StartTime >= stm.EffectiveStartDate && (stm.EffectiveEndDate == null || theShift.StartTime <= stm.EffectiveEndDate)) {
                    System.debug('Found a Primary Territory Member for the Service Resource');
                    if (stm.OperatingHours != null && stm.OperatingHours.TimeZone != null) {
                        System.debug('Timezone got when ST->Operating Hours -> timezone');
                        timezoneTobeUsed = stm.OperatingHours.TimeZone;
                        System.debug('TimeZone fetched from STM Operating Hours');
                    } else if (stm.ServiceTerritoryId != null && stm.ServiceTerritory.OperatingHours.TimeZone != null) {
                        timezoneTobeUsed = stm.ServiceTerritory.OperatingHours.TimeZone;
                        System.debug('Time Zone Fetched from Primary STM Service Territory Operating Hours TimeZone');
                    }
                }
            }
        }
        return timezoneTobeUsed;
    }
    @TestVisible
    private static void updateShiftStartFinishWithTimezoneOffset(Shift sh, String timezoneTobeUsed, Boolean requiredShiftFinishTimeAdjustment) {
        System.debug('inside updateShiftStartFinishWithTimezoneOffset()');
        System.debug('Shift received: ' + sh);
        System.debug('Timezone to be used received: ' + timezoneTobeUsed);
        System.debug('requiredShiftFinishTimeAdjustment:' + requiredShiftFinishTimeAdjustment);
        Datetime shiftStartDateTimeInUTC = sh.StartTime;

        System.debug('current firstname : '+UserInfo.getFirstName());
        System.debug('Last Modified By : '+sh.LastModifiedBy.Name);

        if(UserInfo.getUserName().contains('HBT API Integration')) {
            System.debug('Not a HBT Integration User');
            shiftStartDateTimeInUTC= Datetime.newInstanceGmt(sh.StartTime.dateGmt(), sh.StartTime.Time());
        }
        System.debug('Setting shift start date with UTC: ' + shiftStartDateTimeInUTC);
        if (timeZoneToBeUsed != null && shiftStartDateTimeInUTC != null) {
            sh.StartTime = GDMFSL_CommonUtilities.addTimeZoneOffset(shiftStartDateTimeInUTC, timeZoneToBeUsed);
            System.debug('TimeZone Offset added  to Start time: ' + sh.StartTime);
            if (requiredShiftFinishTimeAdjustment) {
                Datetime shiftFinishDateTimeInUTC=sh.EndTime;
                System.debug('EndDateTime received :  '+shiftFinishDateTimeInUTC);
                if(UserInfo.getUserName().contains('HBT API Integration')) {
                    shiftFinishDateTimeInUTC   = Datetime.newInstanceGmt(sh.EndTime.dateGmt(), sh.EndTime.Time());
                }
                System.debug('Setting shift End date with UTC: ' + shiftFinishDateTimeInUTC);
                sh.EndTime = GDMFSL_CommonUtilities.addTimeZoneOffset(shiftFinishDateTimeInUTC, timeZoneToBeUsed);
                System.debug('TimeZone Offset added  to End time: ' + sh.EndTime);
            }
        }
    }
}