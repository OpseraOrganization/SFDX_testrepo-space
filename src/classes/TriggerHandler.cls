/** 
 * About 
 * ----- 
 * @Description	  : Object Trigger Handler Framework Virtual Class.
 * @TestClass		: TriggerHandler_Test.
 * @Project		  : All.
 * @Modification Log : 
 *  Created  : 2020 10 28 – kevinohara80
 *  Modified  : 2020 10 28 – tiago.almeida@nokia.com & flavio.toscano@nokia.com
 * ----- 
**/
public virtual class TriggerHandler {
	// static map of handlername, times run() was invoked
	private String ObjectName = '';
	private static Map<String, LoopCount> loopCountMap;
	private static Set<String> bypassedHandlers;
	// the current context of the trigger, overridable in tests
	@TestVisible
	private TriggerContext context;
	// the current context of the trigger, overridable in tests
	@TestVisible
	private Boolean isTriggerExecuting;
	// static initialization
	static {
		loopCountMap = new Map<String, LoopCount>();
		bypassedHandlers = new Set<String>();
	}
	// constructor
	public TriggerHandler() {
		this.ObjectName = getObjectName();
		this.setTriggerContext();
	}
	// constructor
	public TriggerHandler(String ObjectName) {
		this.ObjectName = ObjectName;
		this.setTriggerContext();
	}
	/***************************************
	* public instance methods
	***************************************/
	// main method that will be called during execution
	public void run() {
		if(!validateRun()) { // Check Custom Setting for Future
			return;
		}
		//Check for global by pass, or specific bypass
		addToLoopCount();
		// dispatch to the correct handler method
		switch on this.context {
			when BEFORE_INSERT {
				this.beforeInsert();
			}
			when BEFORE_UPDATE {
				this.beforeUpdate();
			}
			when BEFORE_DELETE {
				this.beforeDelete();
			}
			when AFTER_INSERT {
				this.afterInsert();
			}
			when AFTER_UPDATE {
				this.afterUpdate();
			}
			when AFTER_DELETE {
				this.afterDelete();
			}
			when AFTER_UNDELETE {
				this.afterUndelete();
			}
			when else {
				//Do nothing
			}
		}
	}
	
	public void setMaxLoopCount(Integer max) {
		if(!TriggerHandler.loopCountMap.containsKey(this.ObjectName)) {
			TriggerHandler.loopCountMap.put(this.ObjectName, new LoopCount(max));
		} else {
			TriggerHandler.loopCountMap.get(this.ObjectName).setMax(max);
		}
	}
	
	public void clearMaxLoopCount() {
		this.setMaxLoopCount(-1);
	}
	/***************************************
	* public static methods
	***************************************/
	public static void bypass(String ObjectName) {
		TriggerHandler.bypassedHandlers.add(ObjectName);
	}
	
	public static void clearBypass(String ObjectName) {
		TriggerHandler.bypassedHandlers.remove(ObjectName);
	}
	
	public static Boolean isBypassed(String ObjectName) {
		return TriggerHandler.bypassedHandlers.contains(ObjectName);
	}
	
	public static void clearAllBypasses() {
		TriggerHandler.bypassedHandlers.clear();
	}
	
	/***************************************
	* private instancemethods
	***************************************/
	@TestVisible
	private void setTriggerContext() {
		this.setTriggerContext(null, false);
	}
	
	@TestVisible
	private void setTriggerContext(String ctx, Boolean testMode) {
		if (!Trigger.isExecuting && !testMode) {
			this.isTriggerExecuting = false;
			return;
		} else {
			this.isTriggerExecuting = true;
		}

		if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) ||
	(ctx != null && ctx == 'before insert')) {
			this.context = TriggerContext.BEFORE_INSERT;
		} else if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) ||
	(ctx != null && ctx == 'before update')) {
			this.context = TriggerContext.BEFORE_UPDATE;
		} else if ((Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) ||
	(ctx != null && ctx == 'before delete')) {
			this.context = TriggerContext.BEFORE_DELETE;
		} else if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) ||
	(ctx != null && ctx == 'after insert')) {
			this.context = TriggerContext.AFTER_INSERT;
		} else if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) ||
	(ctx != null && ctx == 'after update')) {
			this.context = TriggerContext.AFTER_UPDATE;
		} else if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) ||
	(ctx != null && ctx == 'after delete')) {
			this.context = TriggerContext.AFTER_DELETE;
		} else if ((Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) ||
	(ctx != null && ctx == 'after undelete')) {
			this.context = TriggerContext.AFTER_UNDELETE;
		}
	}
	
	// increment the loop count
	@TestVisible
	private void addToLoopCount() {
		if(TriggerHandler.loopCountMap.containsKey(this.ObjectName)) {
			Boolean exceeded = TriggerHandler.loopCountMap.get(this.ObjectName).increment();
			if(exceeded) {
				Integer max = TriggerHandler.loopCountMap.get(this.ObjectName).max;
				throw new TriggerHandlerException('Maximum loop count of ' + String.valueOf(max) + ' reached in ' + this.ObjectName + ' Trigger Handler');
			}
		}
	}
	
	// make sure this trigger should continue to run
	@TestVisible
	private Boolean validateRun() {
		if(!this.isTriggerExecuting || this.context == null) {
			throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
		}
		return !TriggerHandler.bypassedHandlers.contains(this.ObjectName);
	}
	
	@TestVisible
	private String getObjectName() {
		return String.isNotBlank(this.ObjectName) ? this.ObjectName : String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')).replace('Trigger','').replace('Handler','');
	}
	
	/***************************************
	* context methods
	***************************************/
	
	// context-specific methods for override
	@TestVisible
	protected virtual void beforeInsert() {}
	@TestVisible
	protected virtual void beforeUpdate() {}
	@TestVisible
	protected virtual void beforeDelete() {}
	@TestVisible
	protected virtual void afterInsert() {}
	@TestVisible
	protected virtual void afterUpdate() {}
	@TestVisible
	protected virtual void afterDelete() {}
	@TestVisible
	protected virtual void afterUndelete() {}
	
	/***************************************
	* inner classes
	***************************************/
	
	// inner class for managing the loop count per handler
	@TestVisible
	private class LoopCount {
		private Integer max;
		private Integer count;
		
		public LoopCount() {
			this.max = 5;
			this.count = 0;
		}
		
		public LoopCount(Integer max) {
			this.max = max;
			this.count = 0;
		}
		
		public Boolean increment() {
			this.count++;
			return this.exceeded();
		}
		
		public Boolean exceeded() {
			return this.max >= 0 && this.count > this.max;
		}
		
		public Integer getMax() {
			return this.max;
		}
		
		public Integer getCount() {
			return this.count;
		}
		
		public void setMax(Integer max) {
			this.max = max;
		}
	}
	
	// possible trigger contexts
	@TestVisible
	private enum TriggerContext {
		BEFORE_INSERT, BEFORE_UPDATE, BEFORE_DELETE,
		AFTER_INSERT, AFTER_UPDATE, AFTER_DELETE,
		AFTER_UNDELETE
	}
	
	// exception class
	public class TriggerHandlerException extends Exception {}
}