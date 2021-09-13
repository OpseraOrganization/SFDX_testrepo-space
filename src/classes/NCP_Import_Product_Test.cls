/**
 * Created by tweinberger on 2019-01-09.
 */

@isTest
private class NCP_Import_Product_Test {
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
	static testmethod void test() {
		Test.startTest();
		NCP_Import_Product_BATCH productBatch = new NCP_Import_Product_BATCH();
		Id batchId = Database.executeBatch(productBatch);
		Test.stopTest();
		// after the testing stops, assert records were updated properly

		System.assertEquals(1, [SELECT Count() FROM Product_Portfolio_Item__c WHERE NCP_Processed__c = True]);
		System.assertEquals(2, [SELECT Count() FROM NCP_Product_Content__c]);
	}
}