/******************************************************************************************************
Name : DS_BusinessRulesCheck_Controller
Created Date: 2nd June 2018
Created by: Accenture
Description : This class is controller for lightning component DS_BusinessValidationRules	 

<Sprint-13-US-725 -Generate Jsonfile and Insert into file object when user click on Downloadjson button on Digital proposal > 
*********************************************************************************************************/
global without sharing class DS_BusinessRulesCheck_Controller{

	private static SWx_Upsell_Proposal__c digital_Proposal_Obj;
	private Id digitalProposalId;
	public static Boolean flag1;
	public static Boolean flag2;
	public static Boolean flag3;
	
	
	/******************************
	*Method Name: checkRules
	*Description: This Method will call appropriate methods for business validations
	********************************/
	@AuraEnabled
	public static void checkRules(Id currentRecordId) {
		try{
			digital_Proposal_Obj = [select id, Upsell_Status__c, Analytics_Source__c,Business_Rules_Check__c, Ready_to_Convert__c, Error_Message__c, Account_ID__c from SWx_Upsell_Proposal__c where id =: currentRecordId Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()];
			Set<String> productCode = new Set<String>();
			List<SWx_Upsell_Items__c> upsellLineItemList;
			List<SWx_Upsell_Items__c> upsellLineItemListToUpdate = new  List<SWx_Upsell_Items__c>();
			List<SWx_Upsell_Items__c> uniqueupsellLineItemListToUpdate = new  List<SWx_Upsell_Items__c>();
			Set<SWx_Upsell_Items__c> upsellLineItemSetToUpdate = new set<SWx_Upsell_Items__c>();
			List<SWx_Upsell_Proposal__c> dpListToUpdate = new List<SWx_Upsell_Proposal__c>();
			List<Apttus_Config2__PriceList__c> lstOfPriceList = new List<Apttus_Config2__PriceList__c>();
			Set<String> SalesItemCode = new Set<String>();
			Set<String> BundleIDCode = new Set<String>();
			List<Product2> productList = new List<Product2>();
			
		   
			upsellLineItemList = [select id,Feature_ID__c,SWx_Product_Code__c,Sales_Item_Code__r.ProductCode,Bundle_ID__r.ProductCode,SWx_Upsell_Proposal__r.Id,Sales_Item_Code_SWx__c,SWx_Upsell_Proposal__c from SWx_Upsell_Items__c where SWx_Upsell_Proposal__c = :digital_Proposal_Obj.Id LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			 
			if(!upsellLineItemList.isEmpty()){	  
					for(SWx_Upsell_Items__c ui: upsellLineItemList){
						BundleIDCode.add(ui.Bundle_ID__r.ProductCode);
						SalesItemCode.add(ui.Sales_Item_Code__r.ProductCode);
					}
			}
		
			productCode.addAll(SalesItemCode);
			productCode.addAll(BundleIDCode);
			System.debug('productCode--->'+productCode);
			productList = [select id,ProductCode from Product2 where ProductCode in :productCode LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		

			List<Apttus_Config2__ProductOptionComponent__c> ProductOptionComponentList =[select id,BundledProduct_Code__c,ProductCode__c from Apttus_Config2__ProductOptionComponent__c where (ProductCode__c in : SalesItemCode OR BundledProduct_Code__c in:BundleIDCode) LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];  
			List<Apttus_Config2__PriceListItem__c> priceListItemList = new List<Apttus_Config2__PriceListItem__c>();
			List<Apttus_Config2__PriceList__c> accontIdToPriceList = new List<Apttus_Config2__PriceList__c>();
			String accId = digital_Proposal_Obj.Account_ID__c;
			Map<Id, String> priceListType = new Map<Id, String>();
			 
		  
		  
			lstOfPriceList = DS_DigitalProposalbusinessRules.getListOfPriceList(accId);
			priceListItemList = DS_DigitalProposalbusinessRules.createPriceItemList(productCode);
			priceListType = DS_DigitalProposalbusinessRules.createMapPriceListToType(accId);
		  
			 DS_DigitalProposalBusinessRules.DPStatus DPObjRec = DS_DigitalProposalBusinessRules.validateProductForCart(digital_Proposal_Obj,upsellLineItemList,productList);
		 
			  upsellLineItemListToUpdate.addAll(DPObjRec.CXMLineItemList);
			
				 
				 DPObjRec = DS_DigitalProposalBusinessRules.validateProductForPriceList(digital_Proposal_Obj,lstOfPriceList,priceListItemList,DPObjRec.CXMLineItemListSuccess,priceListType);
			   
				upsellLineItemListToUpdate.addAll(DPObjRec.CXMLineItemList);
				
				if(!DPObjRec.flagForDp){
						   DPObjRec = DS_DigitalProposalBusinessRules.validateUpsellItem(digital_Proposal_Obj,upsellLineItemList,ProductOptionComponentList);
						  
					   upsellLineItemListToUpdate.addAll(DPObjRec.CXMLineItemList);
					  
				  }
		  
		   
			upsellLineItemSetToUpdate.addAll(upsellLineItemListToUpdate);
			uniqueupsellLineItemListToUpdate.addAll(upsellLineItemSetToUpdate);
			
			update DPObjRec.DPObj;
			update uniqueupsellLineItemListToUpdate;
			
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_BusinessRulesCheck_Controller,CSWXGlobalConstant.checkRules);
		}
	}
	
	
	/******************************************************************************************************
Method Name : checkRulesfromStagingObjParserClass
parameter   : Map<Id,SWx_Upsell_Proposal__c> dpIdTodpObjectMap,Set<String> productCode,String accountId
Created Date: 20th Juny 2018
Created by  : Accenture
Description : This method is used to check 2nd and 3rd Business Rule from StagingObjParserClass
*********************************************************************************************************/  
	 public static Map<String,SWx_Upsell_Proposal__c> checkRulesfromStagingObjParserClass(Map<String,SWx_Upsell_Proposal__c> dpIdTodpObjectMap,Set<String> productCode,String accountId, Map<Id,List<SWx_Upsell_Items__c>> dpTolineItemMap,  List<Apttus_Config2__ProductOptionComponent__c>  ProductOptionComponentList){
			try{
			
			
			System.debug('dpIdTodpObjectMap-->'+dpIdTodpObjectMap);
			System.debug('productCode-->'+productCode);
			System.debug('accountId-->'+accountId);
			System.debug('dpTolineItemMap-->'+dpTolineItemMap);
			System.debug('ProductOptionComponentList-->'+ProductOptionComponentList);
		   
			
			List<Apttus_Config2__PriceListItem__c> priceListItemList = new List<Apttus_Config2__PriceListItem__c>();
			List<Apttus_Config2__PriceList__c> lstOfPriceList = new List<Apttus_Config2__PriceList__c>();
			List<SWx_Upsell_Proposal__c> failedDP =  new List<SWx_Upsell_Proposal__c>(); 
			Map<String,SWx_Upsell_Proposal__c> successDPAfterSecondRuleMap =  new Map<String,SWx_Upsell_Proposal__c>(); 
			 
			Map<Id, String> priceListTypeMap = new Map<Id, String>();

			lstOfPriceList = DS_DigitalProposalbusinessRules.getListOfPriceList(accountId);
			priceListItemList = DS_DigitalProposalbusinessRules.createPriceItemList(productCode);
			priceListTypeMap = DS_DigitalProposalbusinessRules.createMapPriceListToType(accountId);
		   
			Set<SWx_Upsell_Items__c> upsellLineItemListToUpdate = new  Set<SWx_Upsell_Items__c>();
			  List<SWx_Upsell_Items__c>	upsellLineItemListToUpdate1   = new List<SWx_Upsell_Items__c>();
				
				
			Set<SWx_Upsell_Proposal__c> dpListToUpdate = new Set<SWx_Upsell_Proposal__c> ();
				List<SWx_Upsell_Proposal__c> dpListToUpdateList = new List<SWx_Upsell_Proposal__c> ();
			
			for(String dpObjId : dpIdTodpObjectMap.keySet()){
				   
				   SWx_Upsell_Proposal__c dpObj = dpIdTodpObjectMap.get(dpObjId);
				   List<SWx_Upsell_Items__c> upsellLineItemList = dpTolineItemMap.get(dpObjId);
				   System.debug('dpTolineItemMap--->'+dpTolineItemMap);
				   System.debug('dpObjId--->'+dpObjId);
				   System.debug('upsellLineItemList--->'+upsellLineItemList);
				   
				   DS_DigitalProposalBusinessRules.DPStatus DP = DS_DigitalProposalBusinessRules.validateProductForPriceList(dpObj,lstOfPriceList,priceListItemList,upsellLineItemList,priceListTypeMap);
					 System.debug('DP------->'+DP);
				  if(DP.DPObj.Business_Rules_Check__c == CSWXGlobalConstant.RED){
							failedDP.add(DP.DPObj);
							dpListToUpdate.add(DP.DPObj);
							
				   }
				   upsellLineItemListToUpdate.addAll(DP.CXMLineItemList);
				   if(!DP.flagForDp){
						  
						  DS_DigitalProposalBusinessRules.DPStatus DP1 = DS_DigitalProposalBusinessRules.validateUpsellItem(dpObj,upsellLineItemList,ProductOptionComponentList);
						   System.debug('DP1------->'+DP1);
					   if(DP1.DPObj.Business_Rules_Check__c == CSWXGlobalConstant.RED){
									   failedDP.add(DP.DPObj);
										dpListToUpdate.add(DP1.DPObj);
									 
							 }else{
										 successDPAfterSecondRuleMap.put(DP.DPObj.Id,DP.DPObj);
							 }
					  
					   upsellLineItemListToUpdate.addAll(DP1.CXMLineItemList);
					  
				  }
				  
				  
			}	
			
			upsellLineItemListToUpdate1.addAll(upsellLineItemListToUpdate);  
				dpListToUpdateList.addAll(dpListToUpdate);
				system.debug('dpListToUpdateList>>'+dpListToUpdateList);
				system.debug('upsellLineItemListToUpdate1>>'+upsellLineItemListToUpdate1);
			update dpListToUpdateList;
			update upsellLineItemListToUpdate1;
			DS_StagingObjparsing.sendChatterMessageToAM(failedDP);
			System.debug('successDPAfterSecondRuleMap--->'+successDPAfterSecondRuleMap);
			return successDPAfterSecondRuleMap;
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_BusinessRulesCheck_Controller,CSWXGlobalConstant.checkRulesfromStagingObjParserClass);
			 return null;
		}	   

	}
	
	
	
	
	 /* getDPInfo */
	@AuraEnabled
		public static void InsertJson(Id recordId){
		try{
				
				if(recordId !=null){
					SWxUpsellProposalTriggerHelper.InsertFile(recordId); 
					
				}
				
		   }catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_BusinessRulesCheck_Controller,CSWXGlobalConstant.InsertJson); 
			   
		   }  
		}
	
	/*Sprint-13-US-725 - Capability to download a json based on a DP representing a roadmap feature proposal via a dedicated user profile 
	Created Date: 7 September 2018
	Created by  : Accenture
	*/
	
	  
	/* getDPInfo */
	@AuraEnabled
		public static String getDPInfo(Id recordId){
		try{
				String dpName, dpStatus,dpType,dpupsellStatus,entitlementStatus,deliverySystem;
				if(recordId !=null){
					SWx_Upsell_Proposal__c digitalProposalRec = [select id,Delivery_System__c, Name , Analytics_Source__c,Upsell_Status__c,Proposal_Status__c,Entitlement_Info__c from SWx_Upsell_Proposal__c where id =: recordId Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()];
					dpName = digitalProposalRec.Name;
					dpStatus = digitalProposalRec.Proposal_Status__c ;
					dpType = digitalProposalRec.Analytics_Source__c ;
					dpupsellStatus = digitalProposalRec.Upsell_Status__c;
					entitlementStatus = digitalProposalRec.Entitlement_Info__c;
					deliverySystem = digitalProposalRec.Delivery_System__c;
					
					

					
				}
				return dpName + CSWXGlobalConstant.splitBy + dpStatus + CSWXGlobalConstant.splitBy + dpType + CSWXGlobalConstant.splitBy + dpupsellStatus + CSWXGlobalConstant.splitBy + entitlementStatus +CSWXGlobalConstant.splitBy + deliverySystem;
			
		   }catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_BusinessRulesCheck_Controller,CSWXGlobalConstant.getDPInfoMethod); 
			   return null;
			   
		   }  
		}
		

 
		
		
	 /* getJsonFile */
	@AuraEnabled
		public static String getJsonFile(Id recordId){
			try{
				String proposalStatus;
				 String upsellSatge;
				 Boolean downloadJson;
				ObjectType objectList = new ObjectType();
				List<Object> jsonList = new List<Object>();
				List<SWx_Upsell_Proposal__c> upsellProposalList = new List<SWx_Upsell_Proposal__c>();
				List<SWx_Upsell_Items__c> upsellLineItemList = new List<SWx_Upsell_Items__c>();
				upsellProposalList = [SELECT id,Analytics_Source__c,Sold_To_Party__c,Analytics_File_Refer_ID__c,PO__r.Id,PO__r.Apttus_Config2__Status__c,
											PO_valid_until_date__c,
											Account_ID__r.Name,
											PO__r.Apttus_Config2__ContactName__c,
											Customer_Address__c ,Name,
											PO__r.Apttus_QPConfig__ProposalId__r.Apttus_Proposal__Approval_Stage__c,
											Frame_Contract__c,
											Frame_contract_valid_until_date__c,
											PO__r.Apttus_CMConfig__AgreementId__r.Apttus__Contract_End_Date__c,
											PO__r.Apttus_CMConfig__AgreementId__c,
											PO__r.Apttus_CMConfig__AgreementId__r.name,
											PO__r.DS_Customer_Reference__c,
											PO__r.Name,
											Frame_Contract__r.Name,
											PO__r.Apttus_Config2__PODate__c,
											PO__r.Apttus_QPConfig__ProposalId__r.Apttus_QPConfig__PONumber__c,
											Proposal_Status__c,
											PO__r.PO_number__c,
											Upsell_Status__c,
											Account_ID__r.AccountNumber,
											Sold_To_Party__r.AccountNumber,
											Document_Generation_Date__c
											FROM SWx_Upsell_Proposal__c
											WHERE id =: recordId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			   
				if(upsellProposalList != NULL){
					for(SWx_Upsell_Proposal__c upsellProposalObj : upsellProposalList){
						objectList.header.source_id = upsellProposalObj.Analytics_Source__c ;
						objectList.header.file_reference_id = upsellProposalObj.Analytics_File_Refer_ID__c;
						objectList.header.cpo_internal= upsellProposalObj.PO__r.Id ;
						objectList.header.cpo = upsellProposalObj.PO__r.Name;
						objectList.header.digital_proposal = upsellProposalObj.Name ;
						objectList.header.agreement= upsellProposalObj.PO__r.Apttus_CMConfig__AgreementId__r.name;
						objectList.header.agreement_internal= upsellProposalObj.PO__r.Apttus_CMConfig__AgreementId__c;
						objectList.header.cpo_status = upsellProposalObj.PO__r.Apttus_Config2__Status__c ;
						//DSI-1255,Sprint 21 - updated customer account to sold to party
						objectList.header.customer_name = upsellProposalObj.Sold_To_Party__c ;
						objectList.header.customer_address = upsellProposalObj.Customer_Address__c ;
						objectList.header.digital_proposal = upsellProposalObj.Name ;
						if(upsellProposalObj.Proposal_Status__c == CSWXGlobalConstant.proposalCloseValidate ){
							objectList.header.proposal_status = CSWXGlobalConstant.Approval_stage_accepted;
						}
						else if(upsellProposalObj.Proposal_Status__c == CSWXGlobalConstant.CLOSE_REJECT){
							objectList.header.proposal_status = CSWXGlobalConstant.Approval_stage_rejected;
						}
						else{
						
						objectList.header.proposal_status = upsellProposalObj.Proposal_Status__c ;
						
						}
						
						objectList.header.po_number = upsellProposalObj.PO__r.PO_number__c ;
						objectList.header.po_date = string.valueOf(upsellProposalObj.PO__r.Apttus_Config2__PODate__c) ;
						objectList.header.cpo_valid_until_date= string.valueOf(upsellProposalObj.PO_valid_until_date__c);
						objectList.header.agreement_valid_until_date = string.valueOf(upsellProposalObj.PO__r.Apttus_CMConfig__AgreementId__r.Apttus__Contract_End_Date__c);
						objectList.header.customer_contact = string.valueOf(upsellProposalObj.PO__r.Apttus_Config2__ContactName__c);
						objectList.header.customer_reference = upsellProposalObj.Sold_To_Party__r.AccountNumber;
						objectList.header.document_generation_date =string.valueOf(upsellProposalObj.Document_Generation_Date__c);
						
						
					   if((upsellProposalObj.Upsell_Status__c == CSWXGlobalConstant.VALIDATED && upsellProposalObj.Proposal_Status__c == CSWXGlobalConstant.proposalCloseValidate) || (upsellProposalObj.Upsell_Status__c ==CSWXGlobalConstant.Rejected  && upsellProposalObj.Proposal_Status__c == CSWXGlobalConstant.CLOSE_REJECT )){
					  
						proposalStatus = upsellProposalObj.Proposal_Status__c ;
						upsellSatge =upsellProposalObj.Upsell_Status__c;
						downloadJson = true;
						}

					}
				}

				ObjectHeader wrapHeader = new ObjectHeader();
				wrapHeader.header = objectList.header;
				System.debug('wrapHeader---->'+wrapHeader);
				jsonList.add(wrapHeader);
				
				String headerserialize =JSON.serializepretty(wrapHeader);
				System.debug('headerserialize --->'+headerserialize );
				headerserialize = headerserialize.removeEnd('}') ;
				headerserialize = headerserialize.removeStart('{');
				  System.debug('headerserialize --->'+headerserialize );
				
				//jsonList.add(objectList.header)
				
				//Upsell Proposal Line Item Data
				if(recordId!=null){
				upsellLineItemList = [SELECT id, 
											 SWx_Product_Code__c,
											 Quantity__c
											 FROM SWx_Upsell_Items__c
											  WHERE SWx_Upsell_Proposal__c =: recordId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
				}
				String lineitemserialize;
				if(upsellLineItemList != NULL){
					for(SWx_Upsell_Items__c upsellLineItemObj : upsellLineItemList){
							objectList.sales_line_items.add(new sales_line_items(upsellLineItemObj.SWx_Product_Code__c,upsellLineItemObj.Quantity__c,upsellLineItemObj.id));
					}
					ObjectSI wrapSI = new ObjectSI();
					wrapSI.sales_line_items = objectList.sales_line_items;
					System.debug('wrapSI---->'+wrapSI);
					jsonList.add(wrapSI);
					lineitemserialize =JSON.serializepretty(wrapSI);
					 lineitemserialize = lineitemserialize.removeStart('{');
					lineitemserialize = lineitemserialize.removeEnd('}') ;
					System.debug('lineitemserialize --->'+lineitemserialize );
				   
					
				}
				String jsonHeader =CSWXGlobalConstant.jsonHeader;
				String jsonFooter= CSWXGlobalConstant.jsonFooter; 
		

				String generateJSON = jsonHeader+headerserialize+','+lineitemserialize+','+jsonFooter;
		
				System.debug('generateJSON--->'+generateJSON);
		
				return generateJSON;
			}catch(Exception ex){
				ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_BusinessRulesCheck_Controller,CSWXGlobalConstant.getJsonFileMethod); 
				return  null;
			   
			}   
		}
		/* objType */
		public without sharing class ObjectType {
			public Header header;
			public List<sales_line_items> sales_line_items;
		 
			/*Constructor*/		
			public ObjectType()
			{
				this.header = new Header();
				this.sales_line_items = new List<sales_line_items>();
		 
			}
		
		}
		/*  objheader */
		public without sharing class ObjectHeader{
			public Header header;
		}
		/* objSI */
		public without sharing class ObjectSI{
			public List<sales_line_items> sales_line_items;
		}
   
	
		/* RMP Header */
		public without sharing class Header {
			public String source_id ;
			public String file_reference_id;
			
			public String cpo_status;
			public String customer_name;
			public String customer_address;
			public String digital_proposal;
			public String agreement;
			public String po_number;
			public String po_date;
			public String document_generation_date;
			Public String agreement_valid_until_date ;
			Public String cpo_valid_until_date;
			Public String proposal_status;
			public String customer_contact;
			Public String customer_reference;
			Public String cpo_internal;
			Public String agreement_internal;
			Public String cpo;
		}
		
	
		/* Upsell Proposal Line Item */
		public without sharing class sales_line_items {
			public String product_code;
			public Decimal quantity;
			Public Id line_item_id;
			/*Constructor*/
			public sales_line_items(String product_code ,Decimal quantity,Id line_item_id){
				this.product_code = product_code;
				this.quantity = quantity;
				this.line_item_id = line_item_id;
			}
		}
}