/*******************************
Class Name: CCRE_CreateQuoteProposal
Created by: Accenture
Created Date: 27th Nov 2017
Last modified by: Accenture
Description: This class will be used to generate JSON format
*******************************/
global without sharing class CCRE_CreateQuoteProposal{
   /* get QuoteName */
	@AuraEnabled
		public static String getQuoteName(Id recordId){
		try{
			List<Apttus_Proposal__Proposal__c> quoteProposalList = new List<Apttus_Proposal__Proposal__c>();
			quoteProposalList = [select id, Name from Apttus_Proposal__Proposal__c where id =: recordId];
			String quoteName = quoteProposalList[0].Name;
			return quoteName;
		   }catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.CCRE_CreateQuoteProposal,CSWXGlobalConstant.getQuoteName); return null;
			   
		   }  
		}
	 /* upsert quote */
	@AuraEnabled
	public static String UpsertQuote(Id recordId){
		try{
		ObjectType objectList = new ObjectType();
		Set<Id> upsellIdSet = new Set<Id>();
		Set<Id> accountIdSet = new Set<Id>();
		List<Account> accountList = new List<Account>();
		List<Object> TryList = new List<Object>();
		//Quote/Proposal object data
		List<Apttus_Proposal__Proposal__c> quoteProposalList = new List<Apttus_Proposal__Proposal__c>();
		List<SWx_Upsell_Proposal__c> upsellProposalList = new List<SWx_Upsell_Proposal__c>();
		List<CCRE_UpSell_LineItem__c> upsellLineItemList = new List<CCRE_UpSell_LineItem__c>();
		List<CCRE_product_info_line_items__c> productInfoLineList = new List<CCRE_product_info_line_items__c>();
		List<CCRE_Service_Invoice_Info_line_items__c> serviceInfoList = new List<CCRE_Service_Invoice_Info_line_items__c>();
		if(recordId != NULL){
			quoteProposalList = [SELECT id,
										SWx_Upsell_Proposal__c FROM Apttus_Proposal__Proposal__c 
										WHERE id =: recordId];
		   
		}
		/* Quote Related Upsell id */
		if(quoteProposalList != NULL){
			for(Apttus_Proposal__Proposal__c quoteProposalObj : quoteProposalList){
				upsellIdSet.add(quoteProposalObj.SWx_Upsell_Proposal__c);
			}
		}
	   
		//SWx_Upsell_Proposal__c data
		if(upsellIdSet.size()>0){
			upsellProposalList = [SELECT id,
										Analytics_Source__c ,
										Account_ID__c,
										Proposal_Recommendation_Type__c,
										Analytics_File_Refer_ID__c, 
										P20_Id__c,
										CurrencyIsoCode,
										Unweighted_Value__c,
										Creation_Date__c
										FROM SWx_Upsell_Proposal__c
										WHERE id IN: upsellIdSet];
		   
			if(upsellProposalList != NULL){
				for(SWx_Upsell_Proposal__c upsellProposalObj : upsellProposalList){
					objectList.header.source_id = upsellProposalObj.Analytics_Source__c ;
					objectList.header.file_reference_id = upsellProposalObj.Analytics_File_Refer_ID__c;
					//objectList.header.account_id = string.valueof(upsellProposalObj.Account_ID__c);
					objectList.header.category_Type = upsellProposalObj.Proposal_Recommendation_Type__c;   
					objectList.header.P20_ID = string.valueof(upsellProposalObj.P20_Id__c);			 
					objectList.header.dolCurrency = upsellProposalObj.CurrencyIsoCode;				
					objectList.header.Unweighted_Value = upsellProposalObj.Unweighted_Value__c;
					objectList.header.creation_date = upsellProposalObj.Creation_Date__c;
					accountIdSet.add(upsellProposalObj.Account_ID__c);

				}
			}

			accountList = [SELECT AccountNumber FROM Account WHERE ID IN: accountIdSet];
			if(accountList != NULL){
				for(Account accObj : accountList){
					objectList.header.account_id = accObj.AccountNumber;
				}
			}
			ObjectHeader wrapHeader = new ObjectHeader();
			wrapHeader.header = objectList.header;
			TryList.add(wrapHeader);
		   
			 
			//Upsell Proposal Line Item Data
			upsellLineItemList = [SELECT id, 
										 Sales_Item_Code__c,
										 Upsell_Proposal__c,
										 Service_PCI__c FROM CCRE_UpSell_LineItem__c
										 WHERE Upsell_Proposal__c IN: upsellIdSet AND Line_Item_Type__c = :CSWXGlobalConstant.Sales_line_items];
		   
			if(upsellLineItemList != NULL){
				for(CCRE_UpSell_LineItem__c upsellLineItemObj : upsellLineItemList){
						objectList.sales_line_items.add(new Sales_line_items(upsellLineItemObj.Service_PCI__c,upsellLineItemObj.Sales_Item_Code__c));
				}
				ObjectSI wrapSI = new ObjectSI();
				wrapSI.sales_line_items = objectList.sales_line_items;
				TryList.add(wrapSI);
			   
				
			}
		}
		
		//CCRE Service Invoice Info line item mapping
		if(recordId != NULL){
			//CCRE Product Info Line Items mapping
				productInfoLineList = [SELECT id,
											  C10_date_for_product_release__c,
											  C8_date_for_product_release__c,
											  Contracted_NEs_per_contract__c,
											  Contracted_NEs_per_customer__c,
											  Info_Type__c,
											  M7_date_for_product__c,
											  Product__c,
											  Product_Family__c,
											  Product_Group__c,
											  Product_Release__c,
											  Offer__c FROM CCRE_product_info_line_items__c 
											  WHERE Offer__c =: recordId];
				if(productInfoLineList != NULL){	 
					product_info_line_items prjlineitems;						 
					for(CCRE_product_info_line_items__c productInfoLineObj : productInfoLineList){
						
						prjlineitems =  new product_info_line_items();
						prjlineitems.Info_Type = productInfoLineObj.Info_Type__c;
						prjlineitems.Product_Family = productInfoLineObj.Product_Family__c;
						prjlineitems.Product_group = productInfoLineObj.Product_Group__c;
						prjlineitems.Product = productInfoLineObj.Product__c;
						prjlineitems.M7_date_for_product = productInfoLineObj.M7_date_for_product__c;
						prjlineitems.C8_date_for_product_release = productInfoLineObj.C8_date_for_product_release__c;
						prjlineitems.C10_date_for_product_release = productInfoLineObj.C10_date_for_product_release__c;
						prjlineitems.Product_Release = productInfoLineObj.Product_Release__c;
						prjlineitems.Contracted_NEs_per_customer = integer.valueof(productInfoLineObj.Contracted_NEs_per_customer__c);
						prjlineitems.Contracted_NEs_per_contract = productInfoLineObj.Contracted_NEs_per_contract__c;
						objectList.product_info_line_items.add(prjlineitems);
					}
				}
				ObjectPLI wrapPLI = new ObjectPLI();
				wrapPLI.product_info_line_items = objectList.product_info_line_items;
				TryList.add(wrapPLI);
			   
				
			serviceInfoList = [SELECT id,
									  Attribute_for_customer__c,
									  Attribute_Label__c,
									  Attribute_Type__c,
									  Attribute_Value__c,
									  Offer__c FROM CCRE_Service_Invoice_Info_line_items__c 
									  WHERE Offer__c =: recordId];
			if(serviceInfoList != NULL){						  
				for(CCRE_Service_Invoice_Info_line_items__c serviceInfoObj: serviceInfoList){
					objectList.Service_Invoice_Info_line_items.add(new Service_Invoice_Info_line_items(serviceInfoObj.Attribute_Label__c,serviceInfoObj.Attribute_Value__c,serviceInfoObj.Attribute_Type__c,serviceInfoObj.Attribute_for_customer__c));	 

				}
				ObjectSLI wrapSLI = new ObjectSLI();
				wrapSLI.Service_Invoice_Info_line_items = objectList.Service_Invoice_Info_line_items;
				TryList.add(wrapSLI);
				//TryList.add(3,wrapSLI);
			}
		   
			
		}
		
		
		String generateJSON = JSON.serializepretty(TryList);
				return generateJSON;
	  }catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.CCRE_CreateQuoteProposal,CSWXGlobalConstant.UpsertQuote); return null;
			   
		   }   
	}
	/* objType */
	public without sharing class ObjectType {
		public Header header;
		public List<Sales_line_items> sales_line_items;
		public List<Service_Invoice_Info_line_items> Service_Invoice_Info_line_items;
		public List<Product_info_line_items> product_info_line_items;
		
		public ObjectType()
		{
			this.header = new Header();
			this.sales_line_items = new List<Sales_line_items>();
			this.Service_Invoice_Info_line_items = new List<Service_Invoice_Info_line_items>();
			this.product_info_line_items = new List<Product_info_line_items>();
		}
		
	}
	/*  objheader */
	public without sharing class ObjectHeader{
		public Header header;
	}
   /* objSI */
	public without sharing class ObjectSI{
		public List<Sales_line_items> sales_line_items;
	}
	/* obj PLI */
	public without sharing class ObjectPLI{
		public List<Product_info_line_items> product_info_line_items;
	}
   /* obj SLI */
	public without sharing class ObjectSLI{
		public List<Service_Invoice_Info_line_items> Service_Invoice_Info_line_items;
	}
	
	/* CCRE Header */
	public without sharing class Header {
		public String source_id ;
		public String file_reference_id;
		public String account_id;
		public Date creation_date;
		public String category_Type;
		public String P20_ID;
		public String dolCurrency;
		public Double Unweighted_Value;
	}
	
	/* Upsell Proposal Line Item */
	public without sharing class Sales_line_items {
		public String service_PCI;
		public String sales_item_code;
		public Sales_line_items(String service_PCI,String sales_item_code){
			this.service_PCI = service_PCI;
			this.sales_item_code = sales_item_code;
		}
	}
	
	/* CCRE Service Invoice Info line item */
	public without sharing class Service_Invoice_Info_line_items {
		public String Attribute_Label;
		public String Attribute_Value;
		public String Attribute_Type;
		public String Attribute_for_customer;
		public Service_Invoice_Info_line_items(String Attribute_Label,String Attribute_Value,String Attribute_Type,String Attribute_for_customer){
			this.Attribute_Label = Attribute_Label;
			this.Attribute_Value = Attribute_Value;
			this.Attribute_Type = Attribute_Type;
			this.Attribute_for_customer = Attribute_for_customer;
		}
		
	}
	
	/* CCRE Product Info Line Items*/
	public without sharing class Product_info_line_items {
		public Date C10_date_for_product_release;
		public Date C8_date_for_product_release;
		public Decimal Contracted_NEs_per_contract;
		public Integer Contracted_NEs_per_customer;
		public String Info_Type;
		public Date M7_date_for_product;
		public String Product;
		public String Product_Family;
		public String Product_group;
		public String Product_Release;
	}

}