/****************************************
* Name : DSSWXStagingTest
* Author : Accenture
* Description : Test class of DSSWXStaging
*****************************************/

@isTest
public class DSSWXStagingTest{

/*****************************
	*Method Name: DSSWXStagingTest
	*Description: This method will used for test coverage of UpsertProposal method
	*Parameters: 
	*******************************/   
	 public testmethod Static void DSSWXStagingTestMethod1(){
		Test.startTest();
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '301001432'; 
		database.insert(accountCreation);
		 
		String json = '{'+
		'  \"header\":{'+
		'   '+
		' '+
		'			\"source_id\":\"CXM-ASDFG\",'+
		'   '+
		'			\"file_reference_id\":\"LTE AIR Interface AR\",'+
		'   '+
		'			\"account_id\":\"301001432\",'+
		'   '+
		'			\"creation_date\":\"2017-12-15\",'+
		'  '+
		'			 \"start_date\":\"2017-12-15\",'+
		'  '+
		'			 \"end_date\":\"2018-12-31\",'+
		'   '+
		'			\"category_Type\":\"SW Recommendation\"'+
		'  } ,'+
		' '+
		' '+
		'  \"line_items\":['+
		'	{'+
		'		   \"bundle_id\":\"LTE1495\",'+
		'   '+
		'			\"sales_item_code\":\"RL000191.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\" LTE1495\",'+
		'   '+
		'			\"sales_item_code\":\"RL000186.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\"LTE2006\",'+
		'   '+
		'			\"sales_item_code\":\"RL000268.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	}'+
		']'+
		'}';
		 
		  
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/DSSWXStaging/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		DSSWXStaging.UpsertUpsellProposal();
	   // CCRE_CreateUpsellProposalHelper.UpsertProposal();
		Test.stopTest(); 
	 } 
	 
	 /*
	  public testmethod Static void DSSWXStagingTestMethod2(){
		Test.startTest();
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '301001432'; 
		database.insert(accountCreation);
		 
		String json = '{'+
		'  \"header\":{'+
		'   '+
		' '+
		'			\"source_id\":\"CXM-ASDFG\",'+
		'   '+
		'			\"file_reference_id\":\"LTE AIR Interface AR\",'+
		'   '+
		'			\"account_id\":\"301001432\",'+
		'   '+
		'			\"creation_date\":\"2017-12-15\",'+
		'  '+
		'			 \"start_date\":\"2017-12-15\",'+
		'  '+
		'			 \"end_date\":\"2018-12-31\",'+
		'   '+
		'			\"category_Type\":\"SW Recommendation\"'+
		'  } ,'+
		' '+
		' '+
		'  \"line_items\":['+
		'	{'+
		'		   \"bundle_id\":\"LTE1495\",'+
		'   '+
		'			\"sales_item_code\":\"RL000191.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\" LTE1495\",'+
		'   '+
		'			\"sales_item_code\":\"RL000186.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\"LTE2006\",'+
		'   '+
		'			\"sales_item_code\":\"RL000268.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	}'+
		']'+
		'}';
		 
		  
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/DSSWXStaging/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		DSSWXStaging.UpsertUpsellProposal();
	   // CCRE_CreateUpsellProposalHelper.UpsertProposal();
		Test.stopTest(); 
	 }
	 */
	  public testmethod Static void DSSWXStagingTestMethod2(){
		Test.startTest();
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '301001432'; 
		database.insert(accountCreation);
		 
		String json = '{'+
		'  \"header\":{'+
		'   '+
		' '+
		'			\"source_id\":\"ASDFG\",'+
		'   '+
		'			\"file_reference_id\":\"LTE AIR Interface AR\",'+
		'   '+
		'			\"account_id\":\"301001432\",'+
		'   '+
		'			\"creation_date\":\"2017-12-15\",'+
		'  '+
		'			 \"start_date\":\"2017-12-15\",'+
		'  '+
		'			 \"end_date\":\"2018-12-31\",'+
		'   '+
		'			\"category-Type\":\"SW Recommendation\"'+
		'  } ,'+
		' '+
		' '+
		'  \"line_items\":['+
		'	{'+
		'		   \"bundle_id\":\"LTE1495\",'+
		'   '+
		'			\"sales_item_code\":\"RL000191.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\" LTE1495\",'+
		'   '+
		'			\"sales_item_code\":\"RL000186.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\"LTE2006\",'+
		'   '+
		'			\"sales_item_code\":\"RL000268.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	}'+
		']'+
		'}';
		 
		  
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/DSSWXStaging/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		DSSWXStaging.UpsertUpsellProposal();
		Test.stopTest(); 
	 } 
	 
	 static Boolean createRecords=true;
	 public testmethod Static void DSSWXStagingTestMethod3(){
		
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '301001432'; 
		database.insert(accountCreation);
		 Boolean isCXMService = true;
		   Boolean createRecords = true;
		
		 
		String json = '{'+
		'  \"header\":{'+
		'   '+
		' '+
		'			\"source_id\":\"ASDFG\",'+
		'   '+
		'			\"file_reference_id\":\"LTE AIR Interface AR\",'+
		'   '+
		'			\"account_id\":\"301001432\",'+
		'   '+
		'			\"creation_date\":\"2017-12-15\",'+
		'  '+
		'			 \"start_date\":\"2017-12-15\",'+
		'  '+
		'			 \"start_date\":\"2018-12-31\",'+
		'   '+
		'			\"category-Type\":\"SW Recommendation\"'+
		'  } ,'+
		' '+
		' '+
		'  \"line_items\":['+
		'	{'+
		'		   \"bundle_id\":\"LTE1495\",'+
		'   '+
		'			\"sales_item_code\":\"RL000191.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\" LTE1495\",'+
		'   '+
		'			\"sales_item_code\":\"RL000186.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\"LTE2006\",'+
		'   '+
		'			\"sales_item_code\":\"RL000268.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	}'+
		']'+
		'}';
		 
		try{  
			RestRequest req = new RestRequest();
			RestResponse res = new RestResponse();
			req.requestURI = '/DSSWXStaging/*';
			req.httpMethod = 'POST';
			req.requestBody = Blob.valueof(json);
			RestContext.request = req;
			RestContext.response= res;
		   DSSWXStaging.UpsertUpsellProposal();
		}
		catch(Exception e){
			system.debug('error'+e.getMessage());
		}
		
	 } 
	 
	 
	 
	/*
	  public testmethod Static void DSSWXStagingTestMethod5(){
		
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '301001432'; 
		database.insert(accountCreation);
		 Boolean isCXMService = true;
		   Boolean createRecords = true;
		
		 String json = '{'+
		'  \"header\":{'+
		'   '+
		' '+
		'			\"source_id\":\"CXM-TDD LTE-Robot120000145\",'+
		'   '+
		'			\"file_reference_id\":\"LTE AIR Interface AR\",'+
		'   '+
		'			\"account_id\":\"301001432\",'+
		'   '+
		'			\"creation_date\":\"2017-12-15\",'+
		'  '+
		'			 \"start_date\":\"2017-12-15\",'+
		'  '+
		'			 \"end_date\":\"2018-12-31\",'+
		'   '+
		'			\"category_Type\":\"SW Recommendation\"'+
		'  } ,'+
		' '+
		' '+
		'  \"line_items\":['+
		'	{'+
		'		   \"bundle_id\":\"LTE1495\",'+
		'   '+
		'			\"sales_item_code\":\"RL000191.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\" LTE1495\",'+
		'   '+
		'			\"sales_item_code\":\"RL000186.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\"LTE2006\",'+
		'   '+
		'			\"sales_item_code\":\"RL000268.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	}'+
		']'+
		'}';
		 
		try{  
			RestRequest req = new RestRequest();
			RestResponse res = new RestResponse();
			req.requestURI = '/DSSWXStaging/*';
			req.httpMethod = 'POST';
			req.requestBody = Blob.valueof(json);
			RestContext.request = req;
			RestContext.response= res;
		   DSSWXStaging.UpsertUpsellProposal();
		}
		catch(Exception e){
			system.debug('error'+e.getMessage());
		}
		
	 }
	 */
	 //with date in  source id
	 
	 public testmethod Static void DSSWXStagingTestMethod4(){
	   // public static Boolean isCXMService = true;
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '301001432'; 
		database.insert(accountCreation);
		 Boolean isCXMService = true;
		   Boolean createRecords = true;
		
		 String json = '{'+
		'  \"header\":{'+
		'   '+
		' '+
		'			\"source_id\":\"CXM-WCDMA-Robot120000145  22-8-2018 \",'+
		'   '+
		'			\"file_reference_id\":\"LTE AIR Interface AR\",'+
		'   '+
		'			\"account_id\":\"301001432\",'+
		'   '+
		'			\"creation_date\":\"2017-12-15\",'+
		'  '+
		'			 \"start_date\":\"2017-12-15\",'+
		'  '+
		'			 \"end_date\":\"2018-12-31\",'+
		'   '+
		'			\"category_Type\":\"\"'+
		'  } ,'+
		' '+
		' '+
		'  \"line_items\":['+
		'	{'+
		'		   \"bundle_id\":\"LTE1495\",'+
		'   '+
		'			\"sales_item_code\":\"RL000191.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\" LTE1495\",'+
		'   '+
		'			\"sales_item_code\":\"RL000186.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\"LTE2006\",'+
		'   '+
		'			\"sales_item_code\":\"RL000268.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	}'+
		']'+
		'}';
		 
		try{  
			RestRequest req = new RestRequest();
			RestResponse res = new RestResponse();
			req.requestURI = '/DSSWXStaging/*';
			req.httpMethod = 'POST';
			req.requestBody = Blob.valueof(json);
			RestContext.request = req;
			RestContext.response= res;
		   DSSWXStaging.UpsertUpsellProposal();
		}
		catch(Exception e){
			system.debug('error'+e.getMessage());
		}
		
	 }	
	 // without Quantity
	 public testmethod Static void DSSWXStagingTestMethod5(){
		
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '301001432'; 
		database.insert(accountCreation);
		 Boolean isCXMService = true;
		   Boolean createRecords = true;
		
		 String json = '{'+
		'  \"header\":{'+
		'   '+
		' '+
		'			\"source_id\":\"CXM-WCDMA-Robot120000145  22-8-2018 \",'+
		'   '+
		'			\"file_reference_id\":\"LTE AIR Interface AR\",'+
		'   '+
		'			\"account_id\":\"301001432\",'+
		'   '+
		'			\"creation_date\":\"2017-12-15\",'+
		'  '+
		'			 \"start_date\":\"2017-12-15\",'+
		'  '+
		'			 \"end_date\":\"2018-12-31\",'+
		'   '+
		'			\"category_Type\":\"ecommendation\"'+
		'  } ,'+
		' '+
		' '+
		'  \"line_items\":['+
		'	{'+
		'		   \"bundle_id\":\"LTE1495\",'+
		'   '+
		'			\"sales_item_code\":\"RL000191.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\" LTE1495\",'+
		'   '+
		'			\"sales_item_code\":\"RL000186.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\"LTE2006\",'+
		'   '+
		'			\"sales_item_code\":\"RL000268.T\",'+
		'  '+
		'			 \"quantity\":'+
		'	}'+
		']'+
		'}';
		 
		try{  
			RestRequest req = new RestRequest();
			RestResponse res = new RestResponse();
			req.requestURI = '/DSSWXStaging/*';
			req.httpMethod = 'POST';
			req.requestBody = Blob.valueof(json);
			RestContext.request = req;
			RestContext.response= res;
		   DSSWXStaging.UpsertUpsellProposal();
		}
		catch(Exception e){
			system.debug('error'+e.getMessage());
		}
		
	 }		  
	 
	 // with usecase
	 public testmethod Static void DSSWXStagingTestMethod6(){
		
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '301001432'; 
		database.insert(accountCreation);
		 Boolean isCXMService = true;
		   Boolean createRecords = true;
			String json = '{'+
		'  \"header\":{'+
		'   '+
		' '+
		'			\"source_id\":\"CXM-WCDMA-Robot120000145  22-8-2018 \",'+
		'   '+
		'			\"file_reference_id\":\"LTE AIR Interface AR\",'+
		'   '+
		'			\"account_id\":\"301001432\",'+
		'   '+
		'			\"creation_date\":\"2017-12-15\",'+
		'  '+
		'			 \"start_date\":\"2017-12-15\",'+
		'  '+
		'			 \"end_date\":\"2018-12-31\",'+
		'   '+
		'			\"category_Type\":\"SW Recommendation\"'+
		'  } ,'+
		' '+
		' '+
		'  \"line_items\":['+
		'	{'+
		'		   \"use_case\":\"Energy Efficiency\",'+
		'   '+
		'		   \"bundle_id\":\"LTE1495\",'+
		'   '+
		
		'			\"sales_item_code\":\"RL000191.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\" LTE1495\",'+
		'   '+
		'			\"sales_item_code\":\"RL000186.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\"LTE2006\",'+
		'   '+
		'			\"sales_item_code\":\"RL000268.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	}'+
		']'+
		'}';
		 
		try{  
			RestRequest req = new RestRequest();
			RestResponse res = new RestResponse();
			req.requestURI = '/DSSWXStaging/*';
			req.httpMethod = 'POST';
			req.requestBody = Blob.valueof(json);
			RestContext.request = req;
			RestContext.response= res;
		   DSSWXStaging.UpsertUpsellProposal();
		}
		catch(Exception e){
			system.debug('error'+e.getMessage());
		}
		
	 }	
	 
	 
	 public testmethod Static void DSSWXStagingTechnologyException(){
	 
	 DS_StagingHelper.insertInterfaceLog('abc','xyz','pqr');
	 
	 
	 }  
	 
	 public testmethod Static void insertDSStagingException(){
	 id testId ='07M1F0000044WBs';
	 
	 DS_StagingHelper.insertDSStaging('abc','xyz',testId );
	 
	 
	 } 
	 
	  public testmethod Static void checkForErrorsInLineTest(){
	 Set<String> testset = new set<String>();
	 testset.add('test');
	// DS_StagingHelper.checkForErrorsInLine('abc',testset);
	  DS_StagingHelper.checkForErrorsInLine('product_info_line_items',testset);
	 
	 }  
	 
	   
	 // blank technology
	  public testmethod Static void BlankTechnologyTest(){
	   Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '301001432'; 
		database.insert(accountCreation);
		 Boolean isCXMService = true;
		   Boolean createRecords = true;
			String json = '{'+
		'  \"header\":{'+
		'   '+
		' '+
		'			\"source_id\":\"CXM-Robot120000145  22-8-2018 \",'+
		'   '+
		'			\"file_reference_id\":\"LTE AIR Interface AR\",'+
		'   '+
		'			\"account_id\":\"301001432\",'+
		'   '+
		'			\"creation_date\":\"2017-12-15\",'+
		'  '+
		'			 \"start_date\":\"2017-12-15\",'+
		'  '+
		'			 \"end_date\":\"2018-12-31\",'+
		'   '+
		'			\"category_Type\":\"SW Recommendation\"'+
		'  } ,'+
		' '+
		' '+
		'  \"line_items\":['+
		'	{'+
		'		   \"use_case\":\"Energy Efficiency\",'+
		'   '+
		'		   \"bundle_id\":\"LTE1495\",'+
		'   '+
		
		'			\"sales_item_code\":\"RL000191.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\" LTE1495\",'+
		'   '+
		'			\"sales_item_code\":\"RL000186.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\"LTE2006\",'+
		'   '+
		'			\"sales_item_code\":\"RL000268.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	}'+
		']'+
		'}';
		 
		try{  
			RestRequest req = new RestRequest();
			RestResponse res = new RestResponse();
			req.requestURI = '/DSSWXStaging/*';
			req.httpMethod = 'POST';
			req.requestBody = Blob.valueof(json);
			RestContext.request = req;
			RestContext.response= res;
		   DSSWXStaging.UpsertUpsellProposal();
		}
		catch(Exception e){
			system.debug('error'+e.getMessage());
		}
		
	 } 
	 
	 
	 
	 
	  // blank Technology Test
	  public testmethod Static void BlankAccNumTest(){
	   Account accountCreation = TestDataFactory.createAccount(1)[0];
	   accountCreation.AccountNumber = '301001432'; 
		database.insert(accountCreation);
		 Boolean isCXMService = true;
		   Boolean createRecords = true;
			String json = '{'+
		'  \"header\":{'+
		'   '+
		' '+
		'			\"source_id\":\"CXM-Robot120000145\",'+
		'   '+
		'			\"file_reference_id\":\"LTE AIR Interface AR\",'+
		'   '+
		'			\"account_id\":\"301001432\",'+
		'   '+
		'			\"creation_date\":\"2017-12-15\",'+
		'  '+
		'			 \"start_date\":\"2017-12-15\",'+
		'  '+
		'			 \"end_date\":\"2018-12-31\",'+
		'   '+
		'			\"category_Type\":\"SW Recommendation\"'+
		'  } ,'+
		' '+
		' '+
		'  \"line_items\":['+
		'	{'+
		'		   \"use_case\":\"Energy Efficiency\",'+
		'   '+
		'		   \"bundle_id\":\"LTE1495\",'+
		'   '+
		
		'			\"sales_item_code\":\"RL000191.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\" LTE1495\",'+
		'   '+
		'			\"sales_item_code\":\"RL000186.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	},'+
		'{'+
		'			\"bundle_id\":\"LTE2006\",'+
		'   '+
		'			\"sales_item_code\":\"RL000268.T\",'+
		'  '+
		'			 \"quantity\":1'+
		'	}'+
		']'+
		'}';
		 
		try{  
			RestRequest req = new RestRequest();
			RestResponse res = new RestResponse();
			req.requestURI = '/DSSWXStaging/*';
			req.httpMethod = 'POST';
			req.requestBody = Blob.valueof(json);
			RestContext.request = req;
			RestContext.response= res;
		   DSSWXStaging.UpsertUpsellProposal();
		}
		catch(Exception e){
			system.debug('error'+e.getMessage());
		}
		
	 }	   
		   
	 
	
	 
		
  




}