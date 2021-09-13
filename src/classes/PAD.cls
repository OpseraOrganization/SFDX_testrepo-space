/**
About
-----
Description: PAD Framework to ByPass / Enable / Disable Triggers.

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 12 05 2018 – flavio.toscano@nokia.com
-------------
**/
public with sharing class PAD {
	private static PAD instance = null;
	private static Id currentUserId = null;
	public Map<String, Boolean> triggerStatus = null;
	private static final String SUFFIX_FIELD = 'trigger__c';
	private final Map<String, Schema.SObjectField> mbyPassObjectField = Schema.SObjectType.ByPassTriggers__c.fields.getMap();

	/**
	*   @desc : Load Org/User Configuration for Trigger byPass
	*/
	private void load() {
		currentUserId = UserInfo.getUserId();
		triggerStatus = new Map < String, Boolean > ();
		ByPassTriggers__c bypassTrigg = ByPassTriggers__c.getValues(currentUserId);
		if(bypassTrigg == null){
			bypassTrigg = ByPassTriggers__c.getOrgDefaults();
		}
		if(bypassTrigg != null){
			for(String fieldName : mbyPassObjectField.keySet()){
				if(fieldName.toLowerCase().contains(SUFFIX_FIELD) && mbyPassObjectField.get(fieldName).getDescribe().isCustom()){
					triggerStatus.put(fieldName.replace(SUFFIX_FIELD, ''), (Boolean)bypassTrigg.get(fieldName));
				}
			}
		}
	}

	/**
	*   @desc   :  Unique instance for the Pad framework
	*   @return :  PAD
	*/
	public static PAD getInstance() {
		if (instance == null) {
			instance = new PAD();
		}
		if (currentUserId != UserInfo.getUserId()) {
			instance.load();
		}
		return instance;
	}

	/**
	*   @desc   :  Deactivate Trigger General
	*/
	public static void deactivateTrigger(String name) {
		name = name.replace('__c', '');
		getInstance().triggerStatus.put(name.toLowerCase(), true);
	}

	/**
	*   @desc   :  Deactivate Trigger by Context
	*/
	public static void deactivateTrigger(String name, TriggerContext context) {
		name = name.replace('__c', '');
		getInstance().triggerStatus.put(name.toLowerCase() + '_' + String.valueOf(context), true);
	}

	/**
	*   @desc   :  Deactivate Trigger by Set of Contexts
	*/
	public static void deactivateTrigger(String name, Set<TriggerContext> contextSet) {
		for (TriggerContext context : contextSet) {
			deactivateTrigger(name, context);
		}
	}

	/**
	*   @desc   :  activate Trigger General
	*/
	public static void activateTrigger(String name) {
		name = name.replace('__c', '');
		getInstance().triggerStatus.put(name.toLowerCase(), false);
	}

	/**
	*   @desc   :  activate Trigger by Context
	*/
	public static void activateTrigger(String name, TriggerContext context) {
		name = name.replace('__c', '');
		getInstance().triggerStatus.put(name.toLowerCase() + '_' + String.valueOf(context), false);
	}

	/**
	*   @desc   :  activate Trigger by Set of Contexts
	*/
	public static void activateTrigger(String name, Set<TriggerContext> contextSet) {
		for (TriggerContext context : contextSet) {
			activateTrigger(name, context);
		}
	}

	/**
	*   @desc   : Used to check if we can run or not the Trigger by Object.
	*   @param  : Object Name
	*   @return : Boolean
	*/
	public static boolean cantRun(String sname) {
		sname = sname.replace('__c', '');

		TriggerContext tc = null;

		if(Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) {
			tc = TriggerContext.BEFORE_INSERT;
		} else if(Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) {
			tc = TriggerContext.BEFORE_UPDATE;
		} else if(Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) {
			tc = TriggerContext.BEFORE_DELETE;
		} else if(Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) {
			tc = TriggerContext.AFTER_INSERT;
		} else if(Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) {
			tc = TriggerContext.AFTER_UPDATE;
		} else if(Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) {
			tc = TriggerContext.AFTER_DELETE;
		} else if(Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) {
			tc = TriggerContext.AFTER_UNDELETE;
		}

		Boolean generalStatus = false;
		Boolean contextStatus = false;

		String slowerCaseName = sname.toLowerCase();

		if (getInstance().triggerStatus.containsKey(slowerCaseName)) {
			generalStatus = (getInstance().triggerStatus.get(slowerCaseName) == null ? false : getInstance().triggerStatus.get(slowerCaseName));
		}

		if (tc != null) {
			String slowerCaseNameWithContext = sname.toLowerCase() + '_' + String.valueOf(tc);

			if (getInstance().triggerStatus.containsKey(slowerCaseNameWithContext)) {
				contextStatus = (getInstance().triggerStatus.get(slowerCaseNameWithContext) == null ? false : getInstance().triggerStatus.get(slowerCaseNameWithContext));
			}
		}
		return generalStatus || contextStatus;
	}

	public enum TriggerContext {
		BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
		AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
		AFTER_UNDELETE
	}
}