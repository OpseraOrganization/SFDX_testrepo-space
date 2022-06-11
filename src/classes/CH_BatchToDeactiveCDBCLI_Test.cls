@Istest(seealldata = false)
public class CH_BatchToDeactiveCDBCLI_Test {
	
	public static testMethod void validationRuleTest(){	
		
		test.startTest();
		CH_TestDataFactory.createCustomSettings();
		CH_TestDataFactory.createNokiaUsers();
		CH_TestDataFactory.createAccounts();
		CH_TestDataFactory.createProducts();
		CH_TestDataFactory.createContracts(true); 
		
		List<Asset> asset = [select Id,Name ,Product2Id, CH_ProductRelease__c, CH_Solution__c, CH_ProductVariant__c,
		CH_Solution__r.Name, CH_ProductVariant__r.Name, CH_ProductRelease__r.Name
		from Asset where AccountId = :CH_TestDataFactory.tempLegalAccount.Id];
		system.assert(asset.size()>0);
		System.debug('asset ='+ asset[0].Id); 
		List<ContractLineItem> cli = [select Id,LineItemNumber, AssetId, CH_ServiceClassification__c, serviceContractID, ServiceContract.Status  from ContractLineItem where AssetId = :asset[0].Id];
		System.debug('cli = '+ cli[0].Id); 
		string cliNumber = cli[0].Id;
		Id serviceContractRecordTypeId = Schema.SObjectType.ServiceContract.getRecordTypeInfosByName().get('CARE Service Contract').getRecordTypeId();
		
		ServiceContract oSc = new ServiceContract();
		oSc.recordTypeId = serviceContractRecordTypeId;
		oSC.Id = cli[0].serviceContractID;  
		oSc.CH_LastFullResyncDate__c =System.now()+1;
		oSC.NCP_External_Status__c ='Active';
		update oSc;
		
		String chatterGroup = null;
		for(CollaborationGroup cg : [select id, name from CollaborationGroup where Name='Error-CLI Last Full Synch Date mismatch' limit 1 ]){
			chatterGroup = cg.Name;
		}
		if( chatterGroup==null  ){
			CollaborationGroup cliGroup = new CollaborationGroup();
			cliGroup.Name='Error-CLI Last Full Synch Date mismatch';
			cliGroup.CollaborationType='Public';	
			try{
				insert cliGroup;
			}catch(Exception ex){
				
			}
			
		}
		
		 
		
		String sch = '0 0 2 * * ?';
		CH_ScheduleBatchToDeactiveCDBCLI sh1 = new CH_ScheduleBatchToDeactiveCDBCLI();
		system.schedule('DeactivateCLI', sch, sh1);
		
		
		
		test.stopTest();  
	}
	
}