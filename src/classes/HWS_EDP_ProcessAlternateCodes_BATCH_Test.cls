@isTest 

public class HWS_EDP_ProcessAlternateCodes_BATCH_Test {
	
	@isTest 
	static void testproductServicableAltcode5001() 
	{   
		list<hws_versionitem__c> HWVList =new  list<hws_versionitem__c>();
		hws_versionitem__c hwvitem =new  hws_versionitem__c();
		hwvitem.Name='test';
		hwvitem.HWS_Serial_Number_Traceable__c='Yes';
		hwvitem.HWS_Material_Type__c ='123';
		hwvitem.Material_Code__c= '1234';
		hwvitem.HWS_Version_Code__c='test';
		HWVList.add(hwvitem);
		insert HWVList;
		
		list<HWS_AlternateProductCode__c> altcodelist = new list<HWS_AlternateProductCode__c>();
		HWS_AlternateProductCode__c alt2 = new HWS_AlternateProductCode__c();
		alt2.HWS_VersionItem__c=HWVList[0].id;
		alt2.HWS_PartType__c='PART';
		alt2.HWS_AlternateCodeType__c = 'CARESID';
		alt2.Name='test';
		alt2.HWS_IsProcessed__c=true;
		alt2.HWS_EDP_DeletedAtSource__c=true;
		alt2.HWS_NSNCode__c='NSN123';
		altcodelist.add(alt2);
		
		HWS_AlternateProductCode__c alt3 = new HWS_AlternateProductCode__c();
		alt3.HWS_VersionItem__c=HWVList[0].id;
		alt3.HWS_PartType__c='PART';
		alt3.HWS_AlternateCodeType__c = 'CARESID';
		alt3.Name='test';
		alt3.HWS_IsProcessed__c=true;
		alt3.HWS_EDP_DeletedAtSource__c=true;
		alt3.HWS_NSNCode__c='NSN456';
		altcodelist.add(alt3);
		
		HWS_AlternateProductCode__c alt = new HWS_AlternateProductCode__c();
		alt.HWS_VersionItem__c=HWVList[0].id;
		alt.HWS_PartType__c='PART';
		alt.Name='test';
		alt.HWS_IsProcessed__c=true;
		alt.HWS_EDP_DeletedAtSource__c=true;
		alt.HWS_NSNCode__c='NSN123';
		altcodelist.add(alt);
		
		HWS_AlternateProductCode__c alt1 = new HWS_AlternateProductCode__c();
		alt1.HWS_VersionItem__c=HWVList[0].id;
		alt1.HWS_PartType__c='PART';
		alt1.Name='test';
		alt1.HWS_IsProcessed__c=true;
		alt.HWS_EDP_DeletedAtSource__c=true;
		alt1.HWS_NSNCode__c='NSN456';
		altcodelist.add(alt1);
		
		hws_versionitem__c hwvitem1 =new  hws_versionitem__c();
		hwvitem1.Name='test';
		hwvitem1.HWS_Serial_Number_Traceable__c='Yes';
		hwvitem1.HWS_Material_Type__c ='123';
		hwvitem1.Material_Code__c= '1234';
		hwvitem1.HWS_Version_Code__c='test';
		hwvitem1.HWS_NSNCode__c='NSN123';
		hwvitem1.HWS_Source__c='PUMA2';
		insert hwvitem1;
		
		List<product2> prodlist =new List<product2>();
		product2 pr1 = new product2();
		Id rtId = Schema.SObjectType.product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
		pr1.RecordTypeId =rtId;
		pr1.Name ='ProductCode';
		pr1.IsActive = true;
		pr1.Description='ProductCode';
		pr1.ProductCode = 'NSN123';
		pr1.HWS_DoNotConsider__c=false;
		pr1.CARE_PartCode__c='test';
 		prodlist.add(pr1);
		
		product2 pr2 = new product2();
		pr2.RecordTypeId =rtId;
		pr2.Name ='ProductCode';
		pr2.IsActive = true;
		pr2.Description='ProductCode';
		pr2.ProductCode = 'NSN456';
		pr2.HWS_DoNotConsider__c=false;
		pr2.CARE_PartCode__c='test';
 		prodlist.add(pr2);
		List<Database.SaveResult> prodInsert1 = new List<Database.SaveResult>();
		prodInsert1 = Database.insert(prodlist, false); 
		 
		// Create Accounts
		List<Account> newAccounts1 = new List<Account>();
		Account tempParentAccount1 = new Account();
		Account tempLegalAccount1 = new Account();
		Id accountCustomerRecordType1 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		tempParentAccount1 = new Account(
			Name = 'PARENT-ACCOUNT',
			RecordTypeId = accountCustomerRecordType1
		);
		newAccounts1.add(tempParentAccount1);
		
		Id accountLegalEntityRecordType1 = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		tempLegalAccount1 = new Account(
			Name = 'ACCOUNT_NAME',
			RecordTypeId = accountLegalEntityRecordType1			
		);
		newAccounts1.add(tempLegalAccount1);
		
		Insert newAccounts1;
		if (newAccounts1[1].Name == 'ACCOUNT_NAME'){
			newAccounts1[1].ParentId = newAccounts1[0].id;
			Update newAccounts1[1];
		}
		
		List<Asset> assetList1 = new List<Asset>();
		Id assetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CH_CoveredProduct').getRecordTypeId();
		Asset assetRecord = new Asset(AccountId = newAccounts1[0].Id, Name = 'TestAsset1', 
		 Product2Id = prodlist[1].Id, recordTypeId = assetRecordTypeId, 
		 HWS_CDB_ExternalAssetId__c = 'XXXX|XXXX|test', HWS_SourceSystem__c = 'Puma2');
		assetList1.add(assetRecord);
		List<Database.SaveResult> assetInsert = new List<Database.SaveResult>();
		assetInsert = Database.insert(assetList1, false);
		
		
		Test.startTest();
		HWS_EDP_ProcessAlternateCodes_BATCH batch = new HWS_EDP_ProcessAlternateCodes_BATCH();
		Database.BatchableContext BC;
		SchedulableContext SC;
		batch.start(BC);
		batch.execute(SC);
		batch.execute(BC,altcodelist);		 
		batch.finish(BC);
		
		//update the test data so as to trigger intentional DML errors 
		for(Product2 prod : prodlist){
			prod.Name = null;
		}
		prodInsert1 = Database.update(prodlist, false);
		batch.dmlOperationError(prodInsert1, 'Product', prodList, assetList1, altcodelist);
		
		for(Asset asset : assetList1){
			asset.Name = null;
		}
		assetInsert = Database.update(assetList1, false);
		batch.dmlOperationError(assetInsert, 'Asset', prodList, assetList1, altcodelist);
		
		
		Test.StopTest();
	}
	
	@isTest 
	static void testproductServicableAltcode5002() 
	{   
		hws_versionitem__c hwvitem =new  hws_versionitem__c();
		hwvitem.Name='test';
		hwvitem.HWS_Serial_Number_Traceable__c='Yes';
		hwvitem.HWS_Material_Type__c ='123';
		hwvitem.Material_Code__c= '1234';
		hwvitem.HWS_Version_Code__c='test';
		 insert hwvitem;
		
		list<HWS_AlternateProductCode__c> altcodelist = new list<HWS_AlternateProductCode__c>();
		HWS_AlternateProductCode__c alt = new HWS_AlternateProductCode__c();
		alt.Name='test';
		alt.HWS_VersionItem__c=hwvitem.id;
		alt.HWS_PartType__c='Material';
		alt.HWS_IsProcessed__c=true;
		alt.HWS_NSNCode__c='NSN123';
		altcodelist.add(alt);

		List<product2> prodlist =new List<product2>();
		product2 pr2 = new product2();
		Id rtId = Schema.SObjectType.product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
		pr2.RecordTypeId =rtId;
		pr2.Name ='ProductCode';
		pr2.IsActive = true;
		pr2.Description='ProductCode';
		pr2.ProductCode = 'NSN123';
		pr2.HWS_DoNotConsider__c=false;
		pr2.CARE_PartCode__c='test';
 		prodlist.add(pr2);
		insert prodlist;
		
		Test.startTest();
		
		
		HWS_EDP_ProcessAlternateCodes_BATCH batch = new HWS_EDP_ProcessAlternateCodes_BATCH();
		Database.BatchableContext BC;
		SchedulableContext SC;
		batch.start(BC);
		batch.execute(SC);
		batch.execute(BC,altcodelist);		 
		 batch.finish(BC);
		Test.StopTest();
	
		
	}
	@isTest 
	static void testproductServicableAltcode5003() 
	{   
		hws_versionitem__c hwvitem =new  hws_versionitem__c();
		hwvitem.Name='test';
		hwvitem.HWS_Serial_Number_Traceable__c='Yes';
		hwvitem.HWS_Material_Type__c ='123';
		hwvitem.Material_Code__c= '1234';
		hwvitem.HWS_Version_Code__c='test';
		 insert hwvitem;
		
		list<HWS_AlternateProductCode__c> altcodelist = new list<HWS_AlternateProductCode__c>();
		HWS_AlternateProductCode__c alt = new HWS_AlternateProductCode__c();
		alt.HWS_VersionItem__c=hwvitem.id;
		alt.HWS_PartType__c='PART';
		alt.Name='test';
		alt.HWS_IsProcessed__c=true;
		alt.HWS_EDP_DeletedAtSource__c=true;
		alt.HWS_NSNCode__c='NSN123';
		altcodelist.add(alt);
		
		HWS_AlternateProductCode__c alt1 = new HWS_AlternateProductCode__c();
		alt1.HWS_VersionItem__c=hwvitem.id;
		alt1.HWS_PartType__c='PART';
		alt1.Name='test';
		alt1.HWS_IsProcessed__c=true;
		alt.HWS_EDP_DeletedAtSource__c=false;
		alt1.HWS_NSNCode__c='NSN456';
		altcodelist.add(alt1);
		

		List<product2> prodlist =new List<product2>();
		product2 pr2 = new product2();
		Id rtId = Schema.SObjectType.product2.getRecordTypeInfosByDeveloperName().get('NokiaCPQ_Sales_Product').getRecordTypeId();
		pr2.RecordTypeId =rtId;
		pr2.Name ='ProductCode';
		pr2.IsActive = true;
		pr2.Description='ProductCode';
		pr2.ProductCode = 'NSN123';
		pr2.HWS_DoNotConsider__c=false;
		pr2.CARE_PartCode__c='test';
 		prodlist.add(pr2);
		
		product2 pr3 = new product2();
		pr3.RecordTypeId =rtId;
		pr3.Name ='ProductCode';
		pr3.IsActive = true;
		pr3.Description='ProductCode';
		pr3.ProductCode = 'NSN456';
		pr3.HWS_DoNotConsider__c=false;
		pr3.CARE_PartCode__c='test';
 		prodlist.add(pr3);
		
		
		List<Database.SaveResult> prodInsert = new List<Database.SaveResult>();
		prodInsert = Database.insert(prodlist, false);
		
		//Create Accounts
		List<Account> newAccounts = new List<Account>();
		Account tempParentAccount = new Account();
		Account tempLegalAccount = new Account();
		Id accountCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Customer').getRecordTypeId();
		tempParentAccount = new Account(
			Name = 'PARENT-ACCOUNT',
			RecordTypeId = accountCustomerRecordType
		);
		newAccounts.add(tempParentAccount);
		
		Id accountLegalEntityRecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Legal_Entity').getRecordTypeId();
		tempLegalAccount = new Account(
			Name = 'ACCOUNT_NAME',
			RecordTypeId = accountLegalEntityRecordType			
		);
		newAccounts.add(tempLegalAccount);
		
		Insert newAccounts;
		if (newAccounts[1].Name == 'ACCOUNT_NAME'){
			newAccounts[1].ParentId = newAccounts[0].id;
			Update newAccounts[1];
		}
		
		List<Asset> assetList = new List<Asset>();
		Id assetRecordTypeId = Schema.SObjectType.Asset.getRecordTypeInfosByDeveloperName().get('CH_CoveredProduct').getRecordTypeId();
		Asset asset1 = new Asset(AccountId = newAccounts[0].Id, Name = 'TestAsset1', 
		 Product2Id = prodlist[0].Id, recordTypeId = assetRecordTypeId, 
		 HWS_CDB_ExternalAssetId__c = 'XXXX|XXXX|test', HWS_SourceSystem__c = 'Puma2');
		assetList.add(asset1);
		List<Database.SaveResult> assetInsert = new List<Database.SaveResult>();
		assetInsert = Database.insert(assetList, false);
		
		Test.startTest();
		
		
		HWS_EDP_ProcessAlternateCodes_BATCH batch = new HWS_EDP_ProcessAlternateCodes_BATCH();
		Database.BatchableContext BC;
		SchedulableContext SC;
		batch.start(BC);
		batch.execute(SC);
		batch.execute(BC,altcodelist);		 
		 batch.finish(BC);
		
		for(Asset asset : assetList){
			asset.AccountId = null;
			asset.Product2Id = null;
		}
		assetInsert = Database.update(assetList, false);
		batch.dmlOperationError(assetInsert, 'Asset', prodlist, assetList, altcodelist);
		Test.StopTest();
	
		
	}
	@isTest
	static void test3(){
		hws_versionitem__c hwvitem =new  hws_versionitem__c();
		hwvitem.Name='test';
		hwvitem.HWS_Serial_Number_Traceable__c='Yes';
		hwvitem.HWS_Material_Type__c ='123';
		hwvitem.Material_Code__c= '1234';
		hwvitem.HWS_Version_Code__c='test';
		 insert hwvitem;
		
		list<HWS_AlternateProductCode__c> altcodelist = new list<HWS_AlternateProductCode__c>();
		HWS_AlternateProductCode__c alt2 = new HWS_AlternateProductCode__c();
		alt2.HWS_VersionItem__c=hwvitem.id;
		alt2.HWS_PartType__c='PART';
		alt2.HWS_AlternateCodeType__c='CARESID';
		alt2.Name='C11111';
		alt2.HWS_IsProcessed__c=false;
		alt2.HWS_EDP_DeletedAtSource__c=false;
		alt2.HWS_NSNCode__c='N11111';
		altcodelist.add(alt2);
		
		HWS_AlternateProductCode__c alt3 = new HWS_AlternateProductCode__c();
		alt3.HWS_VersionItem__c=hwvitem.id;
		alt3.HWS_PartType__c='PART';
		alt2.HWS_AlternateCodeType__c='CARESID';
		alt3.Name='C22222';
		alt3.HWS_IsProcessed__c=false;
		alt3.HWS_EDP_DeletedAtSource__c=false;
		alt3.HWS_NSNCode__c='N11111';
		altcodelist.add(alt3);
		
		HWS_AlternateProductCode__c alt4 = new HWS_AlternateProductCode__c();
		alt4.HWS_VersionItem__c=hwvitem.id;
		alt4.HWS_PartType__c='PART';
		alt4.HWS_AlternateCodeType__c='CARESID';
		alt4.Name='C33333';
		alt4.HWS_IsProcessed__c=false;
		alt4.HWS_EDP_DeletedAtSource__c=false;
		alt4.HWS_NSNCode__c='N33333';
		altcodelist.add(alt4);
		
		HWS_AlternateProductCode__c alt5 = new HWS_AlternateProductCode__c();
		alt5.HWS_VersionItem__c=hwvitem.id;
		alt5.HWS_PartType__c='PART';
		alt5.HWS_AlternateCodeType__c='CARESID';
		alt5.Name='CCC111';
		alt5.HWS_IsProcessed__c=false;
		alt5.HWS_EDP_DeletedAtSource__c=false;
		alt5.HWS_NSNCode__c='NNN111';
		altcodelist.add(alt5);
		
		HWS_AlternateProductCode__c alt6 = new HWS_AlternateProductCode__c();
		alt6.HWS_VersionItem__c=hwvitem.id;
		alt6.HWS_PartType__c='PART';
		alt6.HWS_AlternateCodeType__c='CARESID';
		alt6.Name='CCC222';
		alt6.HWS_IsProcessed__c=false;
		alt6.HWS_EDP_DeletedAtSource__c=false;
		alt6.HWS_NSNCode__c='NNN111';
		altcodelist.add(alt6);
		insert altcodelist; 
		
		Test.startTest();
		
		
		HWS_EDP_ProcessAlternateCodes_BATCH batch = new HWS_EDP_ProcessAlternateCodes_BATCH();
		Database.executeBatch(batch);
		Test.stopTest();
	}
}