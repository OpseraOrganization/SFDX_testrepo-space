/**
About
-----
Description: This Class is used as Test Class for Utils.

Created for: Nokia Portugal COE (ERM)
Created: 12 05 2018

Update History
--------------
Created: 12 05 2018 – flavio.toscano@nokia.com
-------------
**/
@isTest
public with sharing class Utils_Test {
	
	static testMethod void tesMapRecordType() {
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		Map<String,Id> recordtypeMap = new Map<String,Id>();
		
		System.runAs(oAdminUser) {
			Test.startTest();
			
			recordtypeMap = Utils.MapRecordType('Account');
			
			System.assertEquals(false,recordtypeMap.isEmpty());
			
			Test.stopTest();
		}
	}
	
	static testMethod void testgetRecordTypesBySobjectName() {
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		List<RecordType> recordTypeList = new List<RecordType>();
		
		System.runAs(oAdminUser) {
			Test.startTest();
			
			recordTypeList = Utils.getRecordTypesBySobjectName('Account');
			
			System.assertEquals(false,recordTypeList.isEmpty());
			
			Test.stopTest();
		}
	}
	
	static testMethod void testgetMapPickLabelAndValues() {
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		Map<String,String> pickLabelAndValuesMap = new Map<String,String>();
		
		System.runAs(oAdminUser) {
			Test.startTest();
			
			pickLabelAndValuesMap = Utils.getMapPickLabelAndValues('Case','Type');
			
			System.assertEquals(false,pickLabelAndValuesMap.isEmpty());
			
			Test.stopTest();
		}
	}
	
	static testMethod void testgetIdSetFromSObjectList() {
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		Set<String> idSetFromSObjectList = new Set<String>();
		
		System.runAs(oAdminUser) {
			Test.startTest();
			List<User> oUsers = TestDataFactory.userCreation(5,'System Administrator');
			
			idSetFromSObjectList = Utils.getIdSetFromSObjectList(oUsers);
			
			System.assertEquals(false,idSetFromSObjectList.isEmpty());
			
			Test.stopTest();
		}
	}
	
	static testMethod void testgetRecordTypeIdByDeveloperName() {
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		String recordType;
		
		System.runAs(oAdminUser) {
			Test.startTest();
			
			recordType = Utils.getRecordTypeIdByDeveloperName('Account','Prospect');
			
			Test.stopTest();
		}
	}
	
	static testMethod void testgenerateRandomInteger() {
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		
		System.runAs(oAdminUser) {
			Test.startTest();
			
			Utils.generateRandomInteger(13);
			
			Test.stopTest();
		}
	}
	
	static testMethod void testgenerateRandomString() {
		User oAdminUser = TestDataFactory.createUser('Admin', 'Test');
		
		System.runAs(oAdminUser) {
			Test.startTest();
			
			Utils.generateRandomString(13);
			
			Test.stopTest();
		}
	}
	
	static testMethod void testgetPermissionSetIdByPermissionSetName() {
		
		Test.startTest();
		
		Utils.getPermissionSetIdByPermissionSetName('Test');
		
		Test.stopTest();
	}
	
	
}