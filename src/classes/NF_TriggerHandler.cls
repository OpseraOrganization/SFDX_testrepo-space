/**
 * @Name	NF_TriggerHandler
 * @Author  Kevin M. O'Hara
 * @Since   
 * @Desc	Modified version of the Trigger Framework: https://github.com/kevinohara80/sfdc-trigger-framework
 *		  This version is a "light" version of the initial framework, some parts have been removed (such as loop controls and bypass,
 *		  which will be still managed with the "PAD" framework).
 * @History Nov 20, 2015. by Abdallah dahjou 
 */

/* 
	Copyright (c) 2013 Kevin M. O'Hara
	
	Permission is hereby granted, free of charge, to any person
	obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without
	restriction, including without limitation the rights to use,
	copy, modify, merge, publish, distribute, sublicense, and/or
	sell copies of the Software, and to permit persons to whom
	the Software is furnished to do so, subject to the following
	conditions:
	
	The above copyright notice and this permission notice shall
	be included in all copies or substantial portions of the
	Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
	KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
	WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
	PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
	OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
	OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
	OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
public virtual class NF_TriggerHandler {
	
	// the current context of the trigger, overridable in tests
	@TestVisible
	private TriggerContext context;
	
	// the current context of the trigger, overridable in tests
	@TestVisible
	private Boolean isTriggerExecuting;
	
	// constructor
	public NF_TriggerHandler() {
		this.setTriggerContext();
	}
	
	/***************************************
	* public instance methods
	***************************************/
	
	// main method that will be called during execution
	public void run() {
		
		if(!validateRun()) return;
		
		// dispatch to the correct handler method
		if(this.context == TriggerContext.BEFORE_INSERT) {
			this.beforeInsert();
			} else if(this.context == TriggerContext.BEFORE_UPDATE) {
			this.beforeUpdate();
			} else if(this.context == TriggerContext.BEFORE_DELETE) {
			this.beforeDelete();
			} else if(this.context == TriggerContext.AFTER_INSERT) {
			this.afterInsert();
			} else if(this.context == TriggerContext.AFTER_UPDATE) {
			this.afterUpdate();
			} else if(this.context == TriggerContext.AFTER_DELETE) {
			this.afterDelete();
			} else if(this.context == TriggerContext.AFTER_UNDELETE) {
			this.afterUndelete();
		}
		
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
		if(!Trigger.isExecuting && !testMode) {
			this.isTriggerExecuting = false;
			return;
			} else {
			this.isTriggerExecuting = true;
		}
		
		if((Trigger.isExecuting && Trigger.isBefore && Trigger.isInsert) || (ctx != null && ctx == 'before insert')) {
			this.context = TriggerContext.BEFORE_INSERT;
		} else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isUpdate) || (ctx != null && ctx == 'before update')){
			this.context = TriggerContext.BEFORE_UPDATE;
		} else if((Trigger.isExecuting && Trigger.isBefore && Trigger.isDelete) || (ctx != null && ctx == 'before delete')) {
			this.context = TriggerContext.BEFORE_DELETE;
		} else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isInsert) || (ctx != null && ctx == 'after insert')) {
			this.context = TriggerContext.AFTER_INSERT;
		} else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUpdate) || (ctx != null && ctx == 'after update')) {
			this.context = TriggerContext.AFTER_UPDATE;
		} else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isDelete) || (ctx != null && ctx == 'after delete')) {
			this.context = TriggerContext.AFTER_DELETE;
		} else if((Trigger.isExecuting && Trigger.isAfter && Trigger.isUndelete) || (ctx != null && ctx == 'after undelete')) {
			this.context = TriggerContext.AFTER_UNDELETE;
		}
	}
	
	// make sure this trigger should continue to run
	@TestVisible
	private Boolean validateRun() {
		if(!this.isTriggerExecuting || this.context == null) {
			throw new TriggerHandlerException('Trigger handler called outside of Trigger execution');
		}
		return true;
	}
	
	@TestVisible
	private String getHandlerName() {
		return String.valueOf(this).substring(0,String.valueOf(this).indexOf(':'));
	}
	
	/***************************************
	* context methods
	***************************************/
	
	// context-specific methods for override
	@TestVisible
	protected virtual void beforeInsert(){}
	@TestVisible
	protected virtual void beforeUpdate(){}
	@TestVisible
	protected virtual void beforeDelete(){}
	@TestVisible
	protected virtual void afterInsert(){}
	@TestVisible
	protected virtual void afterUpdate(){}
	@TestVisible
	protected virtual void afterDelete(){}
	@TestVisible
	protected virtual void afterUndelete(){}
	
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