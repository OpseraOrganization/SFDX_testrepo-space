@isTest
public class LightningLookupControllerTest {

	static testMethod void myTest1() {

		Account accountTest = new Account();
		accountTest.Name		= 'COE Account Test';
		accountTest.Website		= 'www.coe.portugal.com';
		accountTest.Market_Segment__c 		= 'UNASSIGNED';
		accountTest.Customer_Compliance__c	= 'unassign';
		accountTest.BusinessPartnerRole__c  = 'Direct Customer';
		accountTest.Market__c	= 'Market Europe';
		accountTest.Activity_Sector_Name__c = 'GOOGLE, AMAZON & MiCROSOFT';	
		accountTest.BillingCountry	= 'Portugal';
		accountTest.BillingStreet	= 'Alfragide';
		accountTest.BillingCity	='Lisboa';
		accountTest.CBT_CT_Code__c	= 'EUR CECA Armenia Accounts';
		insert accountTest;
		Account accountTest1 = new Account();
		accountTest1.Name		 = 'COE Test';
		accountTest1.Website		 = 'www.coe.portugal.com';
		accountTest1.Market_Segment__c	= 'UNASSIGNED';
		accountTest1.Customer_Compliance__c	 = 'unassign';
		accountTest1.BusinessPartnerRole__c  = 'Direct Customer';
		accountTest1.Market__c	 = 'Market Europe';
		accountTest1.Activity_Sector_Name__c = 'GOOGLE, AMAZON & MiCROSOFT';	
		accountTest1.BillingCountry	= 'Portugal';
		accountTest1.BillingStreet	 = 'Alfragide';
		accountTest1.BillingCity	 = 'Lisboa';
		accountTest1.CBT_CT_Code__c	= 'EUR CECA Armenia Accounts';
		insert accountTest1;
		
		LightningLookupController.LookupRecords res = LightningLookupController.getRecords('Account', '', 'Name', '', 'Name like \'test%\'');
		System.assertEquals(null,res);
		res = LightningLookupController.getRecords('Account', 'Id', '', '', 'Name like \'test%\'');
		System.assertEquals(null,res);
		res = LightningLookupController.getRecords('Account', 'Id', '', 'CreatedDate', 'Name like \'test%\'');
		System.assertEquals(null,res);
		res = LightningLookupController.getRecords('Account', '', '', 'CreatedDate', 'Name like \'test%\'');
		System.assertEquals(null,res);
		res = LightningLookupController.getRecords('Account', 'Id', 'Name', 'CreatedDate', 'Name like \'test%\'');
		System.assertEquals(1,res.lstDisplay.size());
		res = LightningLookupController.getRecords('Account', 'Id', 'Name', 'CreatedDate', 'Name like \'COE%\'');
		System.assertEquals(2,res.lstDisplay.size());
		res = LightningLookupController.getRecords('Account', 'Id', 'Name', 'CreatedDate', 'Name like \'hufdehf%\'');
		System.assertEquals(1,res.lstDisplay.size());
		System.assertEquals('No records found!',res.lstDisplay[0]);
		String s = LightningLookupController.getHelpText('Account.Name');
		s = LightningLookupController.getReference('Account.OwnerId');
		System.assertEquals('User',s);
		res = LightningLookupController.getFieldValue('Account', accountTest.Id, 'Name');
		System.assertEquals(accountTest.Name,res.lstDisplay[0]);
		System.assertEquals(accountTest.Id,res.lstValue[0]);
		System.assertEquals(1, res.lstRecords.size());
	}
	
}