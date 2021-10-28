public class EventTriggerHandler extends TriggerHandler
{
	public EventTriggerHandler(){}	
	public static boolean isProcessing=false;
	/*
	protected override void beforeInsert()
	{
	
	}
	
	protected override void beforeUpdate()
	{
	
	}
	
	protected override void afterInsert()
	{
	
	}
	*/
	protected override void afterUpdate()
	{		
		updateSessionsDates();
	}
	
	private void updateSessionsDates()
	{
		Map<Id,List<Event__c>> mappingVersionSessionsIntoEventIds  = new Map<Id,List<Event__c>>();
		Set<Session__c>	  sessionsToUpdate		= new Set<Session__c>();
		
		for(Event__c newVersionEvent : (List<Event__c>)Trigger.new)
		{
			Event__c oldVersionEvent = (Event__c)Trigger.oldMap.get(newVersionEvent.id);
			if(newVersionEvent.Event_Start_Date__c != oldVersionEvent.Event_Start_Date__c || newVersionEvent.Event_End_Date__c != oldVersionEvent.Event_End_Date__c)
			{
				if(newVersionEvent.Event_Start_Date__c == null || newVersionEvent.Event_End_Date__c == null)
				{
					newVersionEvent.addError('If you would like to cancel the ERM, please use the "Event Cancelled" option under "Additional Information"');
					return;
				}
				List<Event__c> auxList= new List<Event__c>();
				auxList.add(oldVersionEvent);
				auxList.add(newVersionEvent);
				mappingVersionSessionsIntoEventIds.put(newVersionEvent.Id,auxList);  
			}							  
		}//end for loop
		
		if(!mappingVersionSessionsIntoEventIds.isEmpty())
		{
			List<Session__c> sessionsList = [SELECT id,name,Event__c,Start_time__c,End_time__c,start_hour__c,end_hour__c
											   FROM Session__c 
											  WHERE Event__c  IN: mappingVersionSessionsIntoEventIds.keySet()
										   ORDER BY Start_time__c,start_hour__c ASC];
			//System.debug('sessionsList --> '+sessionsList);
			//System.debug('mappingVersionSessionsIntoEventIds.keyset() --> '+mappingVersionSessionsIntoEventIds.keyset());
			for(Id eventId : mappingVersionSessionsIntoEventIds.keyset())
			{
				for(Session__c currentSession : sessionsList)
				{
					if(currentSession.Event__c == eventId )
					{
						System.debug('currentSession --> '+currentSession);
						Event__c oldEv	 	 = mappingVersionSessionsIntoEventIds.get(eventId).get(0);
						Event__c newEv	 	 = mappingVersionSessionsIntoEventIds.get(eventId).get(1);
						System.debug('oldEv --> '+oldEv);
						System.debug('newEv --> '+newEv);
						Integer diffStartDays 	 = (oldEv.Event_Start_Date__c).daysBetween(newEv.Event_Start_Date__c);
						Integer diffEndDays	 = (oldEv.Event_End_Date__c).daysBetween(newEv.Event_End_Date__c);
						System.debug('diffStartDays --> '+diffStartDays);
						System.debug('diffEndDays --> '+diffEndDays);
						System.debug('currentSession.name --> '+currentSession.name);
						System.debug('currentSession.Start_time__c BEFORE --> '+currentSession.Start_time__c);
						System.debug('currentSession.End_time__c BEFORE --> '+currentSession.End_time__c);
						//SAME RANGE
						if(diffEndDays == diffStartDays)
						{
							currentSession.End_time__c   = (currentSession.End_time__c).addDays(diffEndDays);
							currentSession.Start_time__c = (currentSession.Start_time__c).addDays(diffStartDays);
							System.debug('diffEndDays == diffStartDays with currentSession.Start_time__c --> '+currentSession.Start_time__c);
							System.debug('diffEndDays == diffStartDays with currentSession.End_time__c --> '+currentSession.End_time__c);
						}
						//RANGE INCREASE
						else if(diffEndDays>diffStartDays)
						{
							currentSession.End_time__c   = (currentSession.End_time__c).addDays(diffStartDays);
							currentSession.Start_time__c = (currentSession.Start_time__c).addDays(diffStartDays);
							System.debug('diffEndDays>diffStartDays with currentSession.Start_time__c --> '+currentSession.Start_time__c);
							System.debug('diffEndDays>diffStartDays with currentSession.End_time__c --> '+currentSession.End_time__c);
						}//end diffEndDays>diffStartDays if condition
						// RANGE REDUCED
						else//diffEndDays<diffStartDays
						{														  
							//intervalos sem contacto
							if((newEv.Event_Start_Date__c > oldEv.Event_End_Date__c && newEv.Event_End_Date__c > oldEv.Event_End_Date__c)
							   ||(newEv.Event_Start_Date__c < oldEv.Event_Start_Date__c && newEv.Event_End_Date__c < oldEv.Event_Start_Date__c))								
							{
								System.debug('intervalos sem contacto');
								currentSession.Start_time__c = (currentSession.Start_time__c).addDays(diffStartDays);
								currentSession.End_time__c   = (currentSession.End_time__c).addDays(diffStartDays);
							}
							//redução com o mesmo inicio
							else if(newEv.Event_Start_Date__c == oldEv.Event_Start_Date__c && newEv.Event_End_Date__c < oldEv.Event_End_Date__c)								
							{
								System.debug('redução com o mesmo inicio');
								if(currentSession.Start_time__c > newEv.Event_End_Date__c || currentSession.End_time__c > newEv.Event_End_Date__c)
								{
									System.debug('redução com o mesmo inicio 1.1');
									currentSession.Start_time__c = newEv.Event_End_Date__c;
									currentSession.End_time__c   = newEv.Event_End_Date__c;									 
								}								
							}
							//redução com o mesmo fim
							else if(newEv.Event_End_Date__c == oldEv.Event_End_Date__c && newEv.Event_Start_Date__c > oldEv.Event_Start_Date__c)
							{
							   System.debug('redução com o mesmo fim');
							   if(currentSession.Start_time__c < newEv.Event_Start_Date__c || currentSession.End_time__c < newEv.Event_Start_Date__c)
								{
									System.debug('redução com o mesmo fim 1.1');
									currentSession.Start_time__c = newEv.Event_Start_Date__c;
									currentSession.End_time__c   = newEv.Event_Start_Date__c;
								}								
							}
							//redução shiftada NOK yet
							else
							{
								System.debug('redução shiftada');
								currentSession.Start_time__c = (currentSession.Start_time__c).addDays(diffStartDays);
								currentSession.End_time__c   = (currentSession.End_time__c).addDays(diffStartDays);
								System.debug('redução shiftada currentSession.Start_time__c --> '+currentSession.Start_time__c);
								System.debug('redução shiftada currentSession.End_time__c --> '+currentSession.End_time__c);
							}
							System.debug('diffEndDays<diffStartDays with currentSession.Start_time__c before final start --> '+currentSession.Start_time__c);
							System.debug('diffEndDays<diffStartDays with currentSession.Start_time__c before final end --> '+currentSession.End_time__c);
							if(currentSession.Start_time__c < newEv.Event_Start_Date__c )
								currentSession.Start_time__c = newEv.Event_Start_Date__c;					
							else if(currentSession.Start_time__c > newEv.Event_End_Date__c)
								currentSession.Start_time__c = newEv.Event_End_Date__c;
							if(currentSession.End_time__c < newEv.Event_Start_Date__c )
								currentSession.End_time__c = newEv.Event_Start_Date__c;					
							else if(currentSession.End_time__c > newEv.Event_End_Date__c)
								currentSession.End_time__c = newEv.Event_End_Date__c;							
							System.debug('diffEndDays<diffStartDays with currentSession.Start_time__c after final start --> '+currentSession.Start_time__c);
							System.debug('diffEndDays<diffStartDays with currentSession.End_time__c after final end --> '+currentSession.End_time__c);
						}//end diffEndDays<diffStartDays if condition
						System.debug('currentSession.Start_time__c AFTER --> '+currentSession.Start_time__c);
						System.debug('currentSession.End_time__c AFTER --> '+currentSession.End_time__c);
						sessionsToUpdate.add(currentSession);
					}//end currentSession.Event__c == eventId IF CONDITION
				}//end Session__c currentSession : sessionsList FOR LOOP
				System.debug('sessionsToUpdate --> '+sessionsToUpdate);
				update new List<Session__c>(sessionsToUpdate);
			}//end Id eventId : mappingVersionSessionsIntoEventIds.keyset() FOR LOOP
		}//end mappingVersionSessionsIntoEventIds.isEmpty() IF CONDITION
	}//end updateSessionsDates method		
}