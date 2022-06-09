/**
 * Created by tweinberger on 2019-08-08.
 */


@isTest
private class NCP_Import_Product_Schedule_Test {

	public static String CRON_EXP = '0 0 0 28 2 ? 2022';

	@testSetup
	static void setup() {

		Product_Portfolio_Item__c pi=new Product_Portfolio_Item__c();
		pi.AlternateCode__c = '3MN00029AAAA';
		//pi.NSNLegacyCode__c = '833-007800';
		pi.NSNLegacyCode__c = '';
		pi.DataUsage__c = 'CARES,SWST,aaaa';
		pi.NCP_Processed__c = False;
		insert pi;

		Product2 p= new Product2();
		//p1.ProductCode = '833-007800';
		p.Name = 'TestProduct2';
		p.APTS_Ext_ID__c = '833-007800';
		//p1.NCP_Nokia_Product_id__c = '833-007800';
		p.NCP_Nokia_Product_id__c = '';
		insert p;

	}

	@isTest
	static void testScheduledJob() {
		Test.startTest();
		String jobId = System.schedule('Import Schedule',
		CRON_EXP,
		new NCP_Import_Product_Schedule());
		Test.stopTest();
	}

}