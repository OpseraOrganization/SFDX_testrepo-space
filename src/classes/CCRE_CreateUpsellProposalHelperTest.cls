@isTest
/*******************************
	Created by: Accenture
	Created Date: 10 Jan 2018
	Last modified by: Accenture
	Last modified date: 11th Jan 2018
	Description: This class used to for Apex Class CCRE_CreateUpsellProposalHelper Test coverage
	*******************************/
public class CCRE_CreateUpsellProposalHelperTest{

/*****************************
	*Method Name: CCRE_UpsertNewProposalTest
	*Description: This method will used for test coverage of CCRE_UpsertNewProposal method
	*Parameters: 
	*******************************/
  public testmethod Static void CCRE_UpsertNewProposalTest(){
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '100006843'; 
		database.insert(accountCreation);   

	  Account legalentity = TestDataFactory.createAccount(1)[0];
	  legalentity.Parent = accountCreation;
	  legalentity.AccountNumber = '1000151001';
	  database.insert(legalentity);
	  
	  
		Test.startTest();
		String json = '{'+
		'  \"header\": {'+
		'	\"source_id\": \"CCRE\",'+
		'	\"file_reference_id\": \"GBR-61940-82390\",'+
		'	\"account_id\": \"1000151001\",'+
		'	\"creation_date\": \"2017-11-02\",'+
		'	\"category_Type\": \"renewal\",'+
		'	\"P20_ID\": \"215616\",'+
		'	\"dolCurrency\": \"EUR\",'+
		'	\"Unweighted_Value\": 429052.07'+
		'  },'+
		'  \"sales_line_items\": ['+
		'	{'+
		'	  \"bundle_id\": \"00073238\",'+
		'	  \"sales_item_code\": \"00073239\"'+
		'	},'+
		'	{'+
		'	  \"bundle_id\": \"00073238\",'+
		'	  \"sales_item_code\": \"00073240\"'+
		'	},'+
		'	{'+
		'	  \"bundle_id\": \"00073238\",'+
		'   \"sales_item_code\": \"P308514\"'+
		'	  '+
		'	}'+
		'  ],'+
		'  \"product_info_line_items\": ['+
		'	{'+
		'	  \"Info_Type\":\"Product\",'+
		'	  \"Product_Family\": \"Core Network\",'+
		'	  \"Product_group\": \"IP Multimedia Products\",'+
		'	  \"Product\": \"RadiSys CMS-9000 Media Server\",'+
		'	  \"M7_date_for_product\": \"2018-12-31\",'+
		'	  \"C8_date_for_product_release\": null,'+
		'	  \"C10_date_for_product_release\": \"2018-12-31\",'+
		'	  \"Product_Release\": \"RadiSys CMS-9000 MS R3.16\",'+
		'	  \"Contracted_NEs_per_customer\": null,'+
		'	  \"Contracted_NEs_per_contract\": null'+
		'	}'+
		'  ],'+
		'  \"Service_Invoice_Info_line_items\": ['+
		'	{'+
		'	  \"Attribute_Label\": null,'+
		'	  \"Attribute_Value\": \"Bronze\",'+
		'	  \"Attribute_Type\": null,'+
		'	  \"Attribute_for_customer\": \"Yes\"'+
		'	},'+
		'	{'+
		'	  \"Attribute_Label\": null,'+
		'	  \"Attribute_Value\": \"periodic\",'+
		'	  \"Attribute_Type\": \"Text\",'+
		'	  \"Attribute_for_customer\": \"NO\"'+
		'	},'+
		'	{'+
		'	  \"Attribute_Label\": \"Invoicing frequency\",'+
		'	  \"Attribute_Value\": null,'+
		'	  \"Attribute_Type\": \"Text\",'+
		'	  \"Attribute_for_customer\": \"NO\"'+
		'	}'+
		'  ]'+
		'}';
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/ccreCreateUpsellProposal/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		CCRE_CreateUpsellProposal.CCRE_UpsertProposal();
		CCRE_CreateUpsellProposalHelper.CCRE_UpsertNewProposal();
		Test.stopTest(); 
	}
	
	/*********************************************/
   public testmethod Static void CCRE_UpsertNewProposalTest1(){
		Account accountCreation = TestDataFactory.createAccount(1)[0];
		accountCreation.AccountNumber = '100006843'; 
		database.insert(accountCreation);   

		Test.startTest();
		String json = '{'+
		'  \"header\": {'+
		'	\"source_id\": \"CCRE\",'+
		'	\"file_reference_id\": \"GBR-61940-82390\",'+
		'	\"account_id\": \"1000151001\",'+
		'	\"creation_date\": \"2017-11-02\",'+
		'	\"category_Type\": \"renewal\",'+
		'	\"P20_ID\": \"215616\",'+
		'	\"dolCurrency\": null,'+
		'	\"Unweighted_Value\": 429052.07'+
		'  },'+
		'  \"sales_line_items\": ['+
		'	{'+
		'	  \"bundle_id\": \"00073238\",'+
		'	  \"sales_item_code\": \"00073239\"'+
		'	},'+
		'	{'+
		'	  \"bundle_id\": \"00073238\",'+
		'	  \"sales_item_code\": \"00073240\"'+
		'	},'+
		'	{'+
		'	  \"bundle_id\": \"00073238\",'+
		'   \"sales_item_code\": \"P308514\"'+
		'	  '+
		'	}'+
		'  ],'+
		'  \"product_info_line_items\": ['+
		'	{'+
		'	  \"Info_Type\":\"Product\",'+
		'	  \"Product_Family\": \"Core Network\",'+
		'	  \"Product_group\": \"IP Multimedia Products\",'+
		'	  \"Product\": \"RadiSys CMS-9000 Media Server\",'+
		'	  \"M7_date_for_product\": \"2018-12-31\",'+
		'	  \"C8_date_for_product_release\": null,'+
		'	  \"C10_date_for_product_release\": \"2018-12-31\",'+
		'	  \"Product_Release\": \"RadiSys CMS-9000 MS R3.16\",'+
		'	  \"Contracted_NEs_per_customer\": null,'+
		'	  \"Contracted_NEs_per_contract\": null'+
		'	}'+
		'  ],'+
		'  \"Service_Invoice_Info_line_items\": ['+
		'	{'+
		'	  \"Attribute_Label\": null,'+
		'	  \"Attribute_Value\": \"Bronze\",'+
		'	  \"Attribute_Type\": null,'+
		'	  \"Attribute_for_customer\": \"Yes\"'+
		'	},'+
		'	{'+
		'	  \"Attribute_Label\": null,'+
		'	  \"Attribute_Value\": \"periodic\",'+
		'	  \"Attribute_Type\": \"Text\",'+
		'	  \"Attribute_for_customer\": \"NO\"'+
		'	},'+
		'	{'+
		'	  \"Attribute_Label\": \"Invoicing frequency\",'+
		'	  \"Attribute_Value\": null,'+
		'	  \"Attribute_Type\": \"Text\",'+
		'	  \"Attribute_for_customer\": \"NO\"'+
		'	}'+
		'  ]'+
		'}';
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/ccreCreateUpsellProposal/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		CCRE_CreateUpsellProposal.CCRE_UpsertProposal();
		CCRE_CreateUpsellProposalHelper.CCRE_UpsertNewProposal();
		Test.stopTest(); 
	}
	
	
	
 

/*****************************
	*Method Name: CCRE_UpsertNewProposalTestError
	*Description: This method will used for error scenario
	*Parameters: 
	*******************************/
  public testmethod Static void CCRE_UpsertNewProposalTestError(){
		Test.startTest();
		String json = '{'+
		'  \"header\": {'+
		'	\"source_id\": \"CCRE\",'+
		'	\"file_reference_id\": \"GBR-61940-82390\",'+
		'	\"account_id\": \"1000151001\",'+
		'	\"creation_date\": \"2017-11-02\",'+
		'	\"category_Type\": \"renewal\",'+
		'	\"P20_ID\": \"215616\",'+
		'	\"dolCurrency\": \"EUR\",'+
		'	\"Unweighted_Value\": 429052.07'+
		'  },'+
		'  \"sales_line_items\": ['+
		'	{'+
		'	  \"bundle_id\": \"00073238\",'+
		'	  \"sales_item_code\": \"00073239\"'+
		'	},'+
		'	{'+
		'	  \"bundle_id\": \"00073238\",'+
		'	  \"sales_item_code\": \"00073240\"'+
		'	},'+
		'	{'+
		'	  \"bundle_id\": \"00073238\",'+
		'   \"sales_item_code\": \"P308514\"'+
		'	  '+
		'	}'+
		'  ],'+
		'  \"product_info_line_items\": ['+
		'	{'+
		'	  \"Info_Type\":\"Product\",'+
		'	  \"Product_Family\": \"Core Network\",'+
		'	  \"Product_group\": \"IP Multimedia Products\",'+
		'	  \"Product\": \"RadiSys CMS-9000 Media Server\",'+
		'	  \"M7_date_for_product\": \"2018-12-31\",'+
		'	  \"C8_date_for_product_release\": null,'+
		'	  \"C10_date_for_product_release\": \"2018-12-31\",'+
		'	  \"Product_Release\": \"RadiSys CMS-9000 MS R3.16\",'+
		'	  \"Contracted_NEs_per_customer\": null,'+
		'	  \"Contracted_NEs_per_contract\": null'+
		'	}'+
		'  ],'+
		'  \"Service_Invoice_Info_line_items\": ['+
		'	{'+
		'	  \"Attribute_Label\": null,'+
		'	  \"Attribute_Value\": \"Bronze\",'+
		'	  \"Attribute_Type\": null,'+
		'	  \"Attribute_for_customer\": \"Yes\"'+
		'	},'+
		'	{'+
		'	  \"Attribute_Label\": null,'+
		'	  \"Attribute_Value\": \"periodic\",'+
		'	  \"Attribute_Type\": \"Text\",'+
		'	  \"Attribute_for_customer\": \"NO\"'+
		'	},'+
		'	{'+
		'	  \"Attribute_Label\": \"Invoicing frequency\",'+
		'	  \"Attribute_Value\": null,'+
		'	  \"Attribute_Type\": \"Text\",'+
		'	  \"Attribute_for_customer\": \"NO\"'+
		'	}'+
		'  ]'+
		'}';
		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();
		req.requestURI = '/ccreCreateUpsellProposal/*';
		req.httpMethod = 'POST';
		req.requestBody = Blob.valueof(json);
		RestContext.request = req;
		RestContext.response= res;
		CCRE_CreateUpsellProposalHelper.CCRE_UpsertNewProposal();
		Test.stopTest(); 
	}


/*****************************
	*Method Name: CCRE_UpsertNewProposalJSONError
	*Description: This method will used for error scenario
	*Parameters: 
	*******************************/
  public testmethod Static void CCRE_UpsertNewProposalJSONError(){
		Test.startTest();
		String json = '{'+
		'  \"header\": {'+
		'	\"source_id\": \"CCRE\",'+
		'	\"file_reference_id\": \"GBR-61940-82390\",'+
		'	\"account_id\": \"1000151001\",'+
		'	\"creation_date\": \"2017-11-02\",'+
		'	\"category_Type\": \"renewal\",'+
		'	\"P20_ID\": \"215616\",'+
		'	\"dolCurrency\": \"EUR\",'+
		'	\"Unweighted_Value\": 429052.07'+
		'  },'+
		'  \"sales_line_items\": ['+
		'	{'+
		'	  \"bundle_id\": \"00073238\",'+
		'	  \"sales_item_code\": \"00073239\"'+
		'	},'+
		'	{'+
		'	  \"bundle_id\": \"00073238\",'+
		'	  \"bundle_id\": \"00073240\"'+
		'	},'+
		'	{'+
		'	  \"bundle_id\": \"00073238\",'+
		'   \"sales_item_code\": \"P308514\"'+
		'	  '+
		'	}'+
		'  ],'+
		'  \"product_info_line_items\": ['+
		'	{'+
		'	  \"Info_Type\":\"Product\",'+
		'	  \"Product_Family\": \"Core Network\",'+
		'	  \"Product_group\": \"IP Multimedia Products\",'+
		'	  \"Product\": \"RadiSys CMS-9000 Media Server\",'+
		'	  \"M7_date_for_product\": \"2018-12-31\",'+
		'	  \"C8_date_for_product_release\": null,'+
		'	  \"C10_date_for_product_release\": \"2018-12-31\",'+
		'	  \"Product_Release\": \"RadiSys CMS-9000 MS R3.16\",'+
		'	  \"Contracted_NEs_per_customer\": null,'+
		'	  \"Contracted_NEs_per_contract\": null'+
		'	}'+
		'  ],'+
		'  \"Service_Invoice_Info_line_items\": ['+
		'	{'+
		'	  \"Attribute_Label\": null,'+
		'	  \"Attribute_Value\": \"Bronze\",'+
		'	  \"Attribute_Type\": null,'+
		'	  \"Attribute_for_customer\": \"Yes\"'+
		'	},'+
		'  ]'+
		'}';
		try{
			RestRequest req = new RestRequest();
			RestResponse res = new RestResponse();
			req.requestURI = '/ccreCreateUpsellProposal/*';
			req.httpMethod = 'POST';
			req.requestBody = Blob.valueof(json);
			RestContext.request = req;
			RestContext.response= res;
			CCRE_CreateUpsellProposalHelper.CCRE_UpsertNewProposal();
		}
		catch(Exception e){
			system.debug('error'+e.getMessage());
		}
	}
}