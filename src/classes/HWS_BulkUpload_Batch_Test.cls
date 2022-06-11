@isTest
public class HWS_BulkUpload_Batch_Test
{
	@testSetup static void testDataSetup(){
		HWS_GenericSettings__c record = new HWS_GenericSettings__c();
		record.Name='HWS_ServicedAccountNumber';
		record.HWS_Field1__c = '1234';
		insert record;
		Id customerAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.Customer) ;
		Id legalEntityAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY) ;
		Id assetRecordType = HWS_Utilty.getRecordTypeByName('Asset','HWS_Covered_Part');
		
		Account acc = HWS_DataFactory_TEST.insertAccount()  ; 
		acc.RecordTypeId =  customerAccountType;
		acc.Customer_Compliance__c = HWS_Constants.USATT ;
		insert acc; 
		 
		Account acc1 = HWS_DataFactory_TEST.insertAccount() ;  
		acc1.RecordTypeId =  legalEntityAccountType ;
		acc1.ParentId = acc.Id;
		acc1.Name = 'TestLE';
		insert acc1;
		
		Contact con = HWS_DataFactory_TEST.insertContact() ;
		con.AccountId = acc.Id;
		con.Contact_Status__c = 'Active';
		con.CH_ContactType__c = 'Customer';
		con.email='testemai@gmail.com';
		insert con;
		
		Product2 prod = HWS_DataFactory_TEST.insertproduct2();	  
		insert prod;
		
		PriceBook2 pb = HWS_DataFactory_TEST.createPriceBook(); 
		insert pb;   
		
		PriceBookEntry pbety = new PriceBookEntry(
			Pricebook2Id = Test.getStandardPricebookId(),
			Product2Id = prod.id,
			UnitPrice = 0,
			CurrencyIsoCode = 'EUR',
			IsActive = true
		);
		Insert pbety;
		
		ServiceContract sc = HWS_DataFactory_TEST.insertServiceContract(acc1);	  
		sc.Pricebook2Id = Test.getStandardPricebookId();
		sc.CurrencyIsoCode = pbety.CurrencyIsoCode;
		insert sc;
		
		ContractLineItem cli = HWS_DataFactory_TEST.insertContractLineItem(sc,pbety);	   
		cli.PricebookEntryId = pbety.id;		
		insert cli;
		
		Asset ast = HWS_DataFactory_TEST.insertAsset(acc1,prod);		
		ast.RecordTypeId = assetRecordType; 
		insert ast; 
		
		hws_versionitem__c hwsv = HWS_DataFactory_TEST.insertHwsversionitem();
		hwsv.HWS_Hardware_Sellable_Item__c = prod.Id;
		hwsv.HWS_Serial_Number_Traceable__c='';	 
		insert hwsv;
		
		Entitlement entitlement = new Entitlement(
			AccountId = acc1.Id,
			AssetId = ast.Id,
			Startdate = Date.Today().addDays(-1), // To get an Active entitlement
			CH_CDB_EntitlementId__c = '12345',
			ContractLineItemId = cli.Id,
			ServiceContractId = sc.Id,
			CH_EntitlementType__c = 'Entitled Asset',
			RecordtypeId =  Schema.SObjectType.Entitlement.getRecordTypeInfosByDeveloperName().get('HWS_Entitlement').getRecordTypeId(),
			Name = 'TestEntitlement',
			CH_ServiceMappingId__c = 'Legacy Customer Support Service - Critical Major Minor 24x7'
		);
		Insert entitlement;
		
		HWS_AlternateProductCode__c apc = new HWS_AlternateProductCode__c();
		
		apc.Name = '5ABTEST';
		apc.HWS_VersionItem__c = hwsv.Id;
		apc.HWS_AlternateCodeType__c = 'KIT';
		insert apc;
		
		Case parentCase = HWS_DataFactory_TEST.insertParentCase();
		parentCase.AccountId = acc1.id;
		insert parentCase;
		
		Case caseRecOrdered = HWS_DataFactory_TEST.insertChildCase();
		caseRecOrdered.Status ='Ordered';
		caseRecOrdered.AccountId = acc1.id;
		caseRecOrdered.AssetId = ast.Id;
		caseRecOrdered.HWS_Faulty_Serial_Number__c = '12345';	   
		caseRecOrdered.ParentId = parentCase.Id;
		caseRecOrdered.HWS_Sellable_Product__c = prod.Id;
		caseRecOrdered.HWS_Contract_Line_Item__c = cli.id;
		insert caseRecOrdered;
		
		Id LegalEntyAccountType = HWS_Utilty.getRecordTypeByName('Account',HWS_Constants.LEGAL_ENTITY);
		Id parentCaseRecordType = HWS_Utilty.getRecordTypeByName('Case',HWS_Constants.HWS_PARENT_CASE_READ_ONLY);	   
		Account legalAcc = [Select id from Account where RecordTypeId =:LegalEntyAccountType limit 1];
		Account logAcc=HWS_DataFactory_TEST.createLogisticAccount();
		insert logAcc;
		Contact cont = [Select id from Contact limit 1];
		Case parentCase2 = HWS_DataFactory_TEST.createCase(parentCaseRecordType);
		parentCase2.AccountId = legalAcc.Id;
		insert parentCase2;
		List<HWS_BulkUpload__c> bulkList = new List<HWS_BulkUpload__c>();
		for(integer i = 0; i< 25; i++){
			HWS_BulkUpload__c bu = HWS_DataFactory_TEST.createBulkUpload(); 
			bu.HWS_Ship_to_Address__c = logAcc.Id;
			bu.Site_Id__c ='test';
			bu.Failure_Description_Server_ID__c ='FSDes';
			bu.HWS_Part_Revision__c = 'ANY';
			bu.HWS_Bulk_Reference_Number__c = '6dbeiz';
			bu.Support_Ticket__c=parentCase2.id;
			bu.HWS_Job_Update__c ='Queued';
			 bulkList.add(bu);
		}
		
	   
		insert bulkList;  
		
	}
	static testMethod void testMethod1()
	{
		Account acc = [select id from account limit 1];
		contact con = [select id from contact limit 1];
		List<HWS_BulkUpload__c> lstBU = [select id from HWS_BulkUpload__c WHERE HWS_Bulk_Reference_Number__c='6dbeiz'];
		System.AssertEquals( 25, lstBU.size());
		HWS_BulkUpload_Batch cls = new HWS_BulkUpload_Batch('6dbeiz', 'Submit', 'Return for Repair or Replacement',true,acc.id,con.id,0,'Parentinsert', null);
					
						Database.executeBatch(cls, 25);
						
						
					
				   
	}
	static testMethod void testMethod2()
	{
		List<case> ss = [select id from case  where parentId!= '' limit 1];
						set<id> sId = new set<id>();
						sId.add(ss[0].id);
		HWS_BulkUpload_SOOCallout_Batch cls2 = new HWS_BulkUpload_SOOCallout_Batch (sId, 'Submit');  
						Database.executeBatch(cls2, 1);
	}
	
	static testMethod void testMethod3()
	{
		List<case> ss = [select id from case  where parentId!= '' limit 1];
						set<id> sId = new set<id>();
						sId.add(ss[0].id);
		HWS_BulkUpload_SOOCallout_Batch cls2 = new HWS_BulkUpload_SOOCallout_Batch (sId, 'SaveReview');  
						Database.executeBatch(cls2, 1);
						
	}
	
	static testMethod void testMethod4()
	{
		List<case> ss = [select id from case where parentId!= '' limit 1];
						set<id> sId = new set<id>();
						sId.add(ss[0].id);
						try{
						HWS_BulkUpload_SOOCallout_Batch cls3 = new HWS_BulkUpload_SOOCallout_Batch (sId, 'SaveReview'); 
						Database.executeBatch(cls3, 1); 
						}
						catch(exception e){
						System.debug('Exception ===== '+e.getMessage());
						}
	}
	static testMethod void testMethod5()
	{
		Account acc = [select id from account limit 1];
		contact con = [select id from contact limit 1];
		List<HWS_BulkUpload__c> lstBU = [select id from HWS_BulkUpload__c WHERE HWS_Bulk_Reference_Number__c='6dbeiz'];
		System.AssertEquals( 25, lstBU.size());
					for(integer i = 0 ; i<10; i++){
					HWS_BulkUpload_Batch cls = new HWS_BulkUpload_Batch('6dbeiz', 'Submit', 'Return for Repair or Replacement',true,acc.id,con.id,0,'Parentinsert', null);
					
						Database.executeBatch(cls, 25);
						}
					for(integer i = 0 ; i<90; i++){
					Datetime dt = Datetime.now()+0.000344; // to add 1 sec delay
					String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
						HWS_BulkUploadScheduler cls = new HWS_BulkUploadScheduler('6dbeiz', 'Submit', 'Return for Repair or Replacement',true,acc.id,con.id);
						System.schedule('HWS_BulkUploadScheduler - '+timeForScheduler+' - '+i , timeForScheduler, cls);
					}
				   
	}
	
		static testMethod void testMethod6()
	{
		Account acc = [select id from account limit 1];
		contact con = [select id from contact limit 1];
		List<HWS_BulkUpload__c> lstBU = [select id from HWS_BulkUpload__c WHERE HWS_Bulk_Reference_Number__c='6dbeiz'];
		
					for(integer i = 0 ; i<10; i++){
					HWS_BulkUpload_Batch cls = new HWS_BulkUpload_Batch('6dbeiz', 'Submit', 'Return for Repair or Replacement',true,acc.id,con.id,0,'retry0Parentinsert', null);
					
						Database.executeBatch(cls, 25);
						}
					for(integer i = 0 ; i<90; i++){
					Datetime dt = Datetime.now()+0.000344; // to add 1 sec delay
					String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
						HWS_BulkUploadScheduler cls = new HWS_BulkUploadScheduler('6dbeiz-Rd', 'Submit', 'Return for Repair or Replacement',true,acc.id,con.id);
						System.schedule('HWS_BulkUploadScheduler - '+timeForScheduler+' - '+i , timeForScheduler, cls);
					}
				   
	}
	
		static testMethod void testMethod7()
	{
		Account acc = [select id from account limit 1];
		contact con = [select id from contact limit 1];
		List<HWS_BulkUpload__c> lstBU = [select id from HWS_BulkUpload__c WHERE HWS_Bulk_Reference_Number__c='6dbeiz'];
		
					for(integer i = 0 ; i<10; i++){
					HWS_BulkUpload_Batch cls = new HWS_BulkUpload_Batch('6dbeiz', 'Submit', 'Return for Repair or Replacement',true,acc.id,con.id,5,'childinsert', null);
					
						Database.executeBatch(cls, 25);
						}
					for(integer i = 0 ; i<90; i++){
					Datetime dt = Datetime.now()+0.000344; // to add 1 sec delay
					String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
						HWS_BulkUploadScheduler cls = new HWS_BulkUploadScheduler('6dbeiz-Rd', 'Submit', 'Return for Repair or Replacement',true,acc.id,con.id);
						System.schedule('HWS_BulkUploadScheduler - '+timeForScheduler+' - '+i , timeForScheduler, cls);
					}
				   
	}
	 static testMethod void testMethod8()
	{
		Account acc = [select id from account limit 1];
		contact con = [select id from contact limit 1];
		List<HWS_BulkUpload__c> lstBU = [select id,Support_Ticket__c from HWS_BulkUpload__c WHERE HWS_Bulk_Reference_Number__c='6dbeiz'];
		 HWS_BulkUpload_Batch cls = new HWS_BulkUpload_Batch('6dbeiz', 'Submit', 'Return for Repair or Replacement',true,acc.id,con.id,5,'childinsert', null);
					
					
		  cls.logError('', 'start', '', 'Exception type - - Error line  - Message - - Stack Trace'  , lstBU , lstBU[0].Support_Ticket__c , '');
		   
					
				   
	}

}