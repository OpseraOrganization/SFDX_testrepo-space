public class ERM_StakeholderController
{
	public static String getSobjectType(Id iDToValidate)
	{
		try
		{
			List<Id> idList = new List<Id>();
			idList.add(idToValidate);
			return String.valueof(idList[0].getSObjectType());
		}
		catch(Exception e)
		{
			System.debug('[ERM_StakeholderController].getSobjectType: '+e.getLineNumber()+' '+e.getTypeName()+' '+ e.getMessage()+' '+e.getStackTraceString());
			return '';
		}		
	}//end getSobjectType method
	
	@AuraEnabled
	public static String getRelatedEvent(Id recordId)
	{
		try
		{
			Session__c	  s = null;
			Event_Registration__c p = null; // represents participant
			
			Map<String,String> mappingEventAndType = new Map<String,String>();
			String sobjType  = getSobjectType(recordId);
			String query = 'SELECT Event__c FROM '+sobjType+' WHERE ID= \''+recordId+'\'';			
			
			if(sobjType.equals('Session__c'))
			{
				System.debug('[ERM_StakeholderController].getRelatedEvent: query --> '+query);
				s = Database.query(query);
				mappingEventAndType.put('eventId',s.Event__c);
				mappingEventAndType.put('isSession','TRUE'); 
			}				
			else
			{
				System.debug('[ERM_StakeholderController].getRelatedEvent: query --> '+query);
				p = Database.query(query);
				mappingEventAndType.put('eventId',p.Event__c);
				mappingEventAndType.put('isSession','FALSE');
			}
			return JSON.serialize(mappingEventAndType);
		}
		catch(Exception e){
			System.debug('[ERM_StakeholderController] --> '+e.getLineNumber()+' '+e.getTypeName()+' '+ e.getMessage()+' '+e.getStackTraceString());
			return '';
		}
	}//end getRelatedEvent method
	
	@AuraEnabled
	public static ERM_Stakeholder__c saveStakeholderRecord(ERM_Stakeholder__c stakeholderRecord)
	{
		try
		{
			System.debug('[ERM_StakeholderController].saveStakeholderRecord: stakeholderRecord será --> '+stakeholderRecord);
			List<Event_Registration__c> participantName = [SELECT Name 
															 FROM Event_Registration__c 
															WHERE ID =:stakeholderRecord.Participant__c 
															LIMIT 1];
			if(!participantName.isEmpty())
				stakeholderRecord.Name = participantName[0].Name;			
			insert stakeholderRecord;
			System.debug('[ERM_StakeholderController].saveStakeholderRecord: O save correu bem. O id é --> '+stakeholderRecord.id);
			return stakeholderRecord;
		}
		catch(Exception e)
		{
			System.debug('[ERM_StakeholderController] --> '+e.getLineNumber()+' '+e.getTypeName()+' '+ e.getMessage()+' '+e.getStackTraceString());
			return null;
		}
	}
}//end class