/***************************************
* Test Class : CH_ProductLogTypeTrigger_Test
* Description - Test class for Helper 'CH_ProductLogTypeTrigger_Helper '  
* Created Details - 
* Developer - TCS 
* Date - 16 June 2021
* User Story - NOKIASC-36516
*****************************************/
@IsTest
	private class CH_ProductLogTypeTrigger_Test {
  @testSetup
	  static void setuptestdata(){
		
		 CH_UTIL_TEST.createProducts();
	 
		 Product2 getProduct1 = [SELECT Id FROM Product2 WHERE Name =:CH_UTIL_TEST.PRODUCT_NAME LIMIT 1 ];
		 CH_ProductLogType__c ProductLog = new CH_ProductLogType__c();
		 ProductLog.CH_Product__c = getProduct1.Id;
		 ProductLog.CH_LogType__c = 'Product Type';
		 ProductLog.CH_CollectorLogType__c = 'Collector Type';
	 	 ProductLog.CH_Category__c = 'Mandatory';
		 ProductLog.CH_AutoLogCollection__c = true;
			 insert ProductLog;
		 }
	 static testmethod void testRecord(){
	 
	   Test.startTest();
	 
	   try
	  {
	 	Product2 getProduct1 = [SELECT Id FROM Product2 WHERE Name =:CH_UTIL_TEST.PRODUCT_NAME LIMIT 1 ];
	 	CH_ProductLogType__c ProductLg = [SELECT Id, 
							 CH_Product__c,
							 CH_LogType__c,
							 CH_CollectorLogType__c,
							 CH_Category__c FROM CH_ProductLogType__c where CH_Product__c=: getProduct1.Id AND 
													CH_LogType__c =: 'Product Type' AND 
													CH_CollectorLogType__c =: 'Collector Type' AND 
													CH_Category__c =: 'Mandatory' AND
																			CH_AutoLogCollection__c =: true LIMIT 1];
		  if(ProductLg == null){
	 		insert ProductLg;
		  }
	   }
	  catch(Exception duplicate)
		 {	
		System.debug(duplicate.getMessage());
		Boolean expectedExceptionThrown =  duplicate.getMessage().contains(System.Label.CH_Duplicate_ProductLogType_Found) ? true : false;

		 System.AssertEquals(expectedExceptionThrown, true);
		 }
		 Test.stopTest(); 
	}
		
	 static testmethod void testRecord1(){
	  
		 Test.startTest();
	 try
	{
	   Product2 getProduct1 = [SELECT Id FROM Product2 WHERE Name =:CH_UTIL_TEST.PRODUCT_NAME LIMIT 1 ];
	   CH_ProductLogType__c ProductLg1 = [SELECT Id, 
							 CH_Product__c,
							 CH_LogType__c,
							 CH_CollectorLogType__c,
							 CH_Category__c FROM CH_ProductLogType__c where CH_Product__c=: getProduct1.Id AND 
													CH_LogType__c =: 'Product Type' AND 
													CH_CollectorLogType__c =: 'Collector Type' AND 
													CH_Category__c =: 'Mandatory' AND  CH_AutoLogCollection__c =: true LIMIT 1];
		update ProductLg1;
	 }
	catch(Exception duplicate)
	{
		System.debug(duplicate.getMessage());
		Boolean expectedExceptionThrown =  duplicate.getMessage().contains(System.Label.CH_Duplicate_ProductLogType_Found) ? true : false;

		 System.AssertEquals(expectedExceptionThrown, true);   
	  
	}
		Test.stopTest(); 
		}
	}