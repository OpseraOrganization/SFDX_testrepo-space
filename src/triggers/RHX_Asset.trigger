trigger RHX_Asset on Asset (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
	//TODO: Shift the following to the trigger handler
  	 Type rollClass = System.Type.forName('rh2', 'ParentUtil');
	 if(rollClass != null) {
		rh2.ParentUtil pu = (rh2.ParentUtil) rollClass.newInstance();
		if (trigger.isAfter) {
			pu.performTriggerRollups(trigger.oldMap, trigger.newMap, new String[]{'Asset'}, null);
    	}
    }
    GDMFSL_AssetTriggerHandler.handleOperations(Trigger.OperationType, Trigger.new, Trigger.oldMap);
}