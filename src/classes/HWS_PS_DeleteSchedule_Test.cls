@isTest
public class HWS_PS_DeleteSchedule_Test {
	public static testMethod void testschedule() {
		List<HWS_GenericSettings__c> gsList = new List<HWS_GenericSettings__c>();
		HWS_GenericSettings__c gs = new HWS_GenericSettings__c();
		gs.Name = 'HWS_PS_RelationsDelete';
		gs.HWS_Field1__c = 'true';
		gsList.add(gs);
		HWS_GenericSettings__c gs1 = new HWS_GenericSettings__c();
		gs1.Name = 'HWS_PS_SalesDelete';
		gs1.HWS_Field1__c = 'true';
		gsList.add(gs1);
		HWS_GenericSettings__c gs2 = new HWS_GenericSettings__c();
		gs2.Name = 'HWS_PS_VersionDelete';
		gs2.HWS_Field1__c = 'true';
		gsList.add(gs2);
		HWS_GenericSettings__c gs3 = new HWS_GenericSettings__c();
		gs3.Name = 'HWS_BulkUploadDelete';
		gs3.HWS_Field1__c = 'true';
		gsList.add(gs3);
		insert gsList;
		Test.StartTest();
		HWS_PS_DeleteSchedule testsche = new HWS_PS_DeleteSchedule();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
	public static testMethod void testschedule1() {
		List<HWS_GenericSettings__c> gsList = new List<HWS_GenericSettings__c>();
		HWS_GenericSettings__c gs = new HWS_GenericSettings__c();
		gs.Name = 'HWS_PS_RelationsDelete';
		gs.HWS_Field1__c = 'false';
		gsList.add(gs);
		HWS_GenericSettings__c gs1 = new HWS_GenericSettings__c();
		gs1.Name = 'HWS_PS_SalesDelete';
		gs1.HWS_Field1__c = 'true';
		gsList.add(gs1);
		HWS_GenericSettings__c gs2 = new HWS_GenericSettings__c();
		gs2.Name = 'HWS_PS_VersionDelete';
		gs2.HWS_Field1__c = 'true';
		gsList.add(gs2);
		HWS_GenericSettings__c gs3 = new HWS_GenericSettings__c();
		gs3.Name = 'HWS_BulkUploadDelete';
		gs3.HWS_Field1__c = 'true';
		gsList.add(gs3);
		insert gsList;
		Test.StartTest();
		HWS_PS_DeleteSchedule testsche = new HWS_PS_DeleteSchedule();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
	public static testMethod void testschedule2() {
		List<HWS_GenericSettings__c> gsList = new List<HWS_GenericSettings__c>();
		HWS_GenericSettings__c gs = new HWS_GenericSettings__c();
		gs.Name = 'HWS_PS_RelationsDelete';
		gs.HWS_Field1__c = 'false';
		gsList.add(gs);
		HWS_GenericSettings__c gs1 = new HWS_GenericSettings__c();
		gs1.Name = 'HWS_PS_SalesDelete';
		gs1.HWS_Field1__c = 'false';
		gsList.add(gs1);
		HWS_GenericSettings__c gs2 = new HWS_GenericSettings__c();
		gs2.Name = 'HWS_PS_VersionDelete';
		gs2.HWS_Field1__c = 'true';
		gsList.add(gs2);
		HWS_GenericSettings__c gs3 = new HWS_GenericSettings__c();
		gs3.Name = 'HWS_BulkUploadDelete';
		gs3.HWS_Field1__c = 'true';
		gsList.add(gs3);
		insert gsList;
		Test.StartTest();
		HWS_PS_DeleteSchedule testsche = new HWS_PS_DeleteSchedule();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
	public static testMethod void testschedule3() {
		List<HWS_GenericSettings__c> gsList = new List<HWS_GenericSettings__c>();
		HWS_GenericSettings__c gs = new HWS_GenericSettings__c();
		gs.Name = 'HWS_PS_RelationsDelete';
		gs.HWS_Field1__c = 'false';
		gsList.add(gs);
		HWS_GenericSettings__c gs1 = new HWS_GenericSettings__c();
		gs1.Name = 'HWS_PS_SalesDelete';
		gs1.HWS_Field1__c = 'false';
		gsList.add(gs1);
		HWS_GenericSettings__c gs2 = new HWS_GenericSettings__c();
		gs2.Name = 'HWS_PS_VersionDelete';
		gs2.HWS_Field1__c = 'false';
		gsList.add(gs2);
		HWS_GenericSettings__c gs3 = new HWS_GenericSettings__c();
		gs3.Name = 'HWS_BulkUploadDelete';
		gs3.HWS_Field1__c = 'true';
		gsList.add(gs3);
		insert gsList;
		Test.StartTest();
		HWS_PS_DeleteSchedule testsche = new HWS_PS_DeleteSchedule();
		String sch = '0 0 23 * * ?';
		system.schedule('Test status Check', sch, testsche );
		Test.stopTest();
	}
}