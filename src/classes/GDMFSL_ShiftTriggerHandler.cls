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
public without sharing class GDMFSL_ShiftTriggerHandler {

    public static void handleOperations(TriggerOperation operation, List<Shift> newShifts, Map<Id, Shift> oldShiftMap) {

        if (GDMFSL_CommonUtilities.isProcessingDisabled()) {
            System.debug('Processing is disabled via Custom Setting');
            return;
        }

        switch on operation {

            when BEFORE_INSERT {
                doBeforeInsertWork(newShifts);
            }
            when BEFORE_UPDATE {
                doBeforeUpdateWork(newShifts, oldShiftMap);
            }
        }
    }


    @TestVisible
    private static void doBeforeInsertWork(List<Shift> newShifts){
        GDMFSL_CommonUtilities.setFlag('beforeInsertShiftDone');
        GDMFSL_ShiftProcessor.assignShiftOwner(newShifts);
        GDMFSL_ShiftProcessor.setShiftStartEndBasedOnTimezone(newShifts,null);

    }

    @TestVisible
    private static void doBeforeUpdateWork(List<Shift> newShifts, Map<Id, Shift> oldShiftMap) {

        if(!GDMFSL_CommonUtilities.isFlagSet('beforeUpdateShiftDone')){
            System.debug('SA beforeUpdate');
            GDMFSL_CommonUtilities.setFlag('beforeUpdateShiftDone');
            GDMFSL_ShiftProcessor.updateShiftOwner(newShifts, oldShiftMap);
            GDMFSL_ShiftProcessor.setShiftStartEndBasedOnTimezone(newShifts,oldShiftMap);
        }

    }

}