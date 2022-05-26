@isTest
private class Batch_deleteOIFProgramJunctions_Test  {
	@testSetup 
	static void setup() {
	   List<Account> a = NF_TestDataFactory.getAccounts(1);
	   insert a;
	   list<Opportunity> oppo =  NF_TestDataFactory.getOpportunities(1, a);
	   insert oppo;
	   
	   oppo[0].Is_Auto_Upsell__c=true;
	   update oppo;
	   Product2 p = new Product2(Name = 'Test',CurrencyIsoCode = 'EUR',Business_Group__c = 'NSW',IsActive = true,RecordTypeID ='01241000001EPXgAAO');
	   insert p;
	   date myDate1 = date.newInstance(2019, 6, 30);
	   date myDate2 = date.newInstance(2019, 8, 8);
	   Nokia_Financial_Calendar__c nfc = new Nokia_Financial_Calendar__c(Name ='2019 - P7',Period_Number__c = '7',
																		 Start_Date__c = myDate1,End_Date__c = myDate2 );
	   insert nfc;
	   Order_Intake_Forecast__c oif = new Order_Intake_Forecast__c(BusinessLine__c = p.id ,Forecast_Category__c = 'RoP',
																  OIF_Value__c = 100,POPlanReceipt__c = nfc.id,Opportunity__c = oppo[0].id);
		
	   insert oif;
	   Program_Flag__c pf = new Program_Flag__c(Name = 'test');
	   insert pf;
	   OIFProgramFlagJunction__c junction = new OIFProgramFlagJunction__c();
	   junction.Order_Intake_Forecast__c = oif.id;
	   junction.Program_Flag_Data__c = pf.id;
		insert junction;
	}
	static testmethod void test() {		
		Test.startTest();
		Batch_deleteOIFProgramJunctions uca = new Batch_deleteOIFProgramJunctions();
		Database.executeBatch(uca);
		Test.stopTest();
	}
	
}