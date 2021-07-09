public class GDMFSL_TimeSheetEntryProcessor {

    private static Map<Id, TimeSheetEntry> retVals = new Map<Id, TimeSheetEntry>();

    public static Map<Id, List<TimeSheetEntry>> getRecordsForWOs(Set<Id> workorderIds) {

        Map<Id, List<TimeSheetEntry>> woIdToTSEs = new Map<Id, List<TimeSheetEntry>>();

        for (TimeSheetEntry thisTSE : getRecordsByWOId(workorderIds).values()) {

            if (!woIdToTSEs.containsKey(thisTSE.WorkOrderId)) {
                woIdToTSEs.put(thisTSE.WorkOrderId, new List<TimeSheetEntry>());
            }

            woIdToTSEs.get(thisTSE.WorkOrderId).add(thisTSE);
        }

        return woIdToTSEs;
    }

    @TestVisible
    private static Map<Id, TimeSheetEntry> getRecordsByWOId(Set<Id> woIdsToUse) {

        Set<Id> moreWOIds = new Set<Id>();

        if (woIdsToUse != null && !woIdsToUse.isEmpty()) {

            System.debug('Adding in specified recordIDs');

            if (retVals.isEmpty()) {
                moreWOIds.addAll(woIdsToUse);
            } else {
                for (Id thisRecId : woIdsToUse) {
                    if (!retVals.containsKey(thisRecId)) {
                        moreWOIds.add(thisRecId);
                    }
                }
            }
        }

        if (!moreWOIds.isEmpty()) {

            retVals.putAll(new Map<Id, TimeSheetEntry>([
                    SELECT Id, GDMFSL_Classification__c, Type, DurationInMinutes, GDMFSL_Invoicing_Duration__c, WorkOrderId
                    FROM TimeSheetEntry
                    WHERE WorkOrderId IN :moreWOIds
            ]));

            System.debug('Retrieved TimeSheetEntries: ' + retVals);
        }

        return retVals;
    }


}