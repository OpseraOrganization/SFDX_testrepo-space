/*Class Name - CollaborationGroupTriggerHelper 
*This class is being called from CollaborationGroupTrigger
*/
public class CollaborationGroupTriggerHandler extends TriggerHandler {

	public CollaborationGroupTriggerHandler()
	{
	}	
	protected override void beforeInsert()
	{
		try {
			CollaborationGroupTriggerHelper.beforeInsertTriggerHandle();	
		} catch(Exception e){ System.debug('Exception occurred in before insert ' + e.getStackTraceString()); }
		
	}
	protected override void beforeUpdate()
	{
		try {
			CollaborationGroupTriggerHelper.beforeUpdateTriggerHandle();	
		} catch(Exception e){ System.debug('Exception occurred in before update ' + e.getStackTraceString()); }
	}
	protected override void afterInsert()
	{		
	}
	protected override void afterUpdate()
	{
	}
}