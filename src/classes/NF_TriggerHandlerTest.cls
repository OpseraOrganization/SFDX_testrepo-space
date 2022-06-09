/**
 * @Name	NF_TriggerHandlerTest
 * @Author  Abdallah dahjou (adahjou@salesforce.com)
 * @Since   Nov 28, 2015
 * @Desc	test class of Triggerhandler
 * @History 
 */
@isTest
private class NF_TriggerHandlerTest {
	
	private static final String TRIGGER_CONTEXT_ERROR = 'Trigger handler called outside of Trigger execution';
	
	private static String lastMethodCalled;
	
	private static NF_TriggerHandlerTest.TestHandler handler;
	
	static {
		handler = new NF_TriggerHandlerTest.TestHandler();
		// override its internal trigger detection
		handler.isTriggerExecuting = true;
	}
	
	/***************************************
	* unit tests
	***************************************/
	
	// contexts tests
	
	@isTest
	static void testBeforeInsert() {
		beforeInsertMode();
		handler.run();
		System.assertEquals('beforeInsert', lastMethodCalled, 'last method should be beforeInsert');
	}
	
	@isTest
	static void testBeforeUpdate() {
		beforeUpdateMode();
		handler.run();
		System.assertEquals('beforeUpdate', lastMethodCalled, 'last method should be beforeUpdate');
	}
	
	@isTest
	static void testBeforeDelete() {
		beforeDeleteMode();
		handler.run();
		System.assertEquals('beforeDelete', lastMethodCalled, 'last method should be beforeDelete');
	}
	
	@isTest
	static void testAfterInsert() {
		afterInsertMode();
		handler.run();
		System.assertEquals('afterInsert', lastMethodCalled, 'last method should be afterInsert');
	}
	
	@isTest
	static void testAfterUpdate() {
		afterUpdateMode();
		handler.run();
		System.assertEquals('afterUpdate', lastMethodCalled, 'last method should be afterUpdate');
	}
	
	@isTest
	static void testAfterDelete() {
		afterDeleteMode();
		handler.run();
		System.assertEquals('afterDelete', lastMethodCalled, 'last method should be afterDelete');
	}
	
	@isTest
	static void testAfterUndelete() {
		afterUndeleteMode();
		handler.run();
		System.assertEquals('afterUndelete', lastMethodCalled, 'last method should be afterUndelete');
	}
	
	@isTest 
	static void testNonTriggerContext() {
		try{
			handler.run();
			System.assert(false, 'the handler ran but should have thrown');
		}
		catch(NF_TriggerHandler.TriggerHandlerException te) {
			System.assertEquals(TRIGGER_CONTEXT_ERROR, te.getMessage(), 'the exception message should match');
		}
		catch(Exception e) {
			System.assert(false, 'the exception thrown was not expected: ' + e.getTypeName() + ': ' + e.getMessage());
		}
	}
	
	// private method tests
	
	@isTest 
	static void testGetHandlerName() {
		System.assertEquals('TestHandler', handler.getHandlerName(), 'handler name should match class name');
	}
	
	// test virtual methods
	
	@isTest
	static void testVirtualMethods() {
		NF_TriggerHandler h = new NF_TriggerHandler();
		h.beforeInsert();
		h.beforeUpdate();
		h.beforeDelete();
		h.afterInsert();
		h.afterUpdate();
		h.afterDelete();
		h.afterUndelete();
		System.assertEquals('No need to do an assert', 'No need to do an assert', 'No need to do an assert, Methods are virtual');
	}
	
	/***************************************
	* testing utilities
	***************************************/
	
	private static void resetTest() {
		lastMethodCalled = null;
		system.assertEquals(lastMethodCalled, null,'Last Method not equals to null');
	}
	
	// modes for testing
	
	private static void beforeInsertMode() {
		handler.setTriggerContext('before insert', true);
	}
	
	private static void beforeUpdateMode() {
		handler.setTriggerContext('before update', true);
	}
	
	private static void beforeDeleteMode() {
		handler.setTriggerContext('before delete', true);
	}
	
	private static void afterInsertMode() {
		handler.setTriggerContext('after insert', true);
	}
	
	private static void afterUpdateMode() {
		handler.setTriggerContext('after update', true);
	}
	
	private static void afterDeleteMode() {
		handler.setTriggerContext('after delete', true);
	}
	
	private static void afterUndeleteMode() {
		handler.setTriggerContext('after undelete', true);
	}
	
	// test implementation of the TriggerHandler
	
	private class TestHandler extends NF_TriggerHandler {
		
		public override void beforeInsert() {
			NF_TriggerHandlerTest.lastMethodCalled = 'beforeInsert';
		}
		
		public override void  beforeUpdate() {
			NF_TriggerHandlerTest.lastMethodCalled = 'beforeUpdate';
		}
		
		public override void beforeDelete() {
			NF_TriggerHandlerTest.lastMethodCalled = 'beforeDelete';
		}
		
		public override void afterInsert() {
			NF_TriggerHandlerTest.lastMethodCalled = 'afterInsert';
		}
		
		public override void afterUpdate() {
			NF_TriggerHandlerTest.lastMethodCalled = 'afterUpdate';
		}
		
		public override void afterDelete() {
			NF_TriggerHandlerTest.lastMethodCalled = 'afterDelete';
		}
		
		public override void afterUndelete() {
			NF_TriggerHandlerTest.lastMethodCalled = 'afterUndelete';
		}
		
	}
	
}