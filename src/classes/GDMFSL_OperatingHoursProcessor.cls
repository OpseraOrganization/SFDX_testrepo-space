/*******************************************************************************************
Name       :    GDMFSL_OperatingHoursProcessor
Purpose    :    Processor Logic for OperatingHours object . See method descriptions for proper context for calling each method
--------------------------------------------------------------------------
Developer               Date          Description
--------------------------------------------------------------------------
Udbhav                  2021-Jan-05    Created
**********************************************************************************************/

public without sharing class GDMFSL_OperatingHoursProcessor {

    private static Map<Id, OperatingHours> retVals = new Map<Id, OperatingHours>();

    public static Map<Id, OperatingHours> getRecords(Set<Id> recIds) {

        System.debug('GDMFSL_OperatingHoursProcessor.getRecords()');

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

                Map<Id, OperatingHours> theRecs = new Map<Id, OperatingHours>([
                        SELECT Id,
                                TimeZone, (
                                SELECT Id,
                                        DateAndTime
                                FROM OperatingHoursHolidays
                        ), (
                                SELECT Id,
                                        StartTime,
                                        EndTime,
                                        DayOfWeek
                                FROM TimeSlots
                        )
                        FROM OperatingHours
                        WHERE Id IN :newRecIds

                ]);

                retVals.putAll(theRecs);
                System.debug('Retrieved Operating Hours: ' + retVals);
            }
        }

        return retVals;
    }

}