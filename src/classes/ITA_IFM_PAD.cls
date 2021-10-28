public with sharing class ITA_IFM_PAD {

	private static ITA_IFM_PAD instance = null;
	private static Id currentUserId = null;
	public Map<String, Boolean> triggerStatus = null;

	private void load() {
		currentUserId = UserInfo.getUserId();
		String bypassApex = [SELECT ITA_IFM_By_Triggers__c FROM User 
							WHERE Id = :UserInfo.getUserId() LIMIT 1].ITA_IFM_By_Triggers__c;
		triggerStatus = new Map<String, Boolean>();				
		if (byPassApex != null) {
			List<String> triggerList = bypassApex.split(';');			
			for (String triggerName : triggerList) {
				if (triggerName != null && triggerName != '') {
					triggerStatus.put(triggerName, false);
				}
			}
		}
	}
							
	public static ITA_IFM_PAD getInstance() {
		if (instance == null) { 
			instance = new ITA_IFM_PAD();
		}
		if (currentUserId != UserInfo.getUserId()) {
			instance.load();
		}
		return instance;
	}
	
	public static void deactivateTrigger(String name) {
		getInstance().triggerStatus.put(name, false);
	}

	public static void activateTrigger(String name) {
		getInstance().triggerStatus.put(name, true);
	}
   
	public static boolean canRun(String name) {
		if (getInstance().triggerStatus.containsKey(name)) {
			/*System.debug('#### Classe PAD : le trigger ' + name + ' est-il exécutable? : ' + 
						 getInstance().triggerStatus.get(name));*/
			 
			return (getInstance().triggerStatus.get(name));
			
		}
		return true;
	}	
}