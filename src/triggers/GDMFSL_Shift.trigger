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
trigger GDMFSL_Shift on Shift (before insert, before update) {
	
	GDMFSL_ShiftTriggerHandler.handleOperations(Trigger.operationType, Trigger.new, Trigger.oldMap);
}