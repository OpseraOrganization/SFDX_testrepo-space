/******************************************************************************************************
Name : DS_DigitalProposalBusinessRules
Created Date: 2nd June 2018
Created by: Accenture
Description : This class contains logic for the 3 business rules on "Verify Proposal"		
*********************************************************************************************************/
global without sharing class DS_DigitalProposalBusinessRules{
/*****************************
 *Method Name: validateProductForPriceList
 *Description: This method is used to check 2nd Business Rule
 *Parameters: List<SWx_Upsell_Proposal__c>
 *Test coverage from: DS_DigitalProposalBusinessRulesTest
 *******************************/
	  public static DPStatus validateProductForPriceList(SWx_Upsell_Proposal__c upsellProposalObjRec,List<Apttus_Config2__PriceList__c> accontIdToPriceList,List<Apttus_Config2__PriceListItem__c> priceListItemList, List<SWx_Upsell_Items__c> upsellLineItemList ,Map<Id, String> priceListType){
	   Boolean flag = false; 
	   Set<Id> failedupsellProposalId  = new Set<Id>();  
	   SWx_Upsell_Proposal__c upsellProposalObj = upsellProposalObjRec;
	   Set<Id> inReadyToConvertStage  = new Set<Id>(); 
	   //List<SWx_Upsell_Proposal__c> updatedHeaderList = new List<SWx_Upsell_Proposal__c>();
	   Map<String,Set<String>> productCodeToPriceList= new Map<String,Set<String>>();
	   List<SWx_Upsell_Items__c> tempUpsellLineItemList = new List<SWx_Upsell_Items__c>();
	   List<SWx_Upsell_Items__c> tempSuccessUpsellLineItemList = new List<SWx_Upsell_Items__c>();
	 
	   System.debug('accontIdToPriceList--->'+accontIdToPriceList);
	   System.debug('priceListItemList--->'+priceListItemList);
	   System.debug('upsellLineItemList--->'+upsellLineItemList);
	   try{
			   //Used to collect Upsell Proposal whose Upsell Status is 'Ready To Convert'
			   if(upsellProposalObj.Upsell_Status__c == CSWXGlobalConstant.readyForConversion){
							inReadyToConvertStage.add(upsellProposalObj.id);
				}

				//Used to get price List associated with Account
				String priceListId = getPriceListId(upsellProposalObj,accontIdToPriceList,priceListType);
				
				System.debug('priceListId --->'+priceListId);
				
				//Return Map<Product Code,List<Price List Associated with product>
				productCodeToPriceList = SWxUpsellProposalTriggerHelper.getpriceListItem(priceListItemList);
				System.debug('productCodeToPriceList--->'+productCodeToPriceList);
				System.debug('priceListId--->'+priceListId);
			
				for(SWx_Upsell_Items__c ui : upsellLineItemList){
							
							System.debug('ui.Bundle_ID__r.ProductCode--->'+ui.Bundle_ID__c);
							System.debug('ui.Sales_Item_Code__r.ProductCode'+ui.Sales_Item_Code__c);
							
							//Retrieved Set<Price List Associted with Bundle Product>
							Set<String> featurePriceList = productCodeToPriceList.get(ui.Bundle_ID__r.ProductCode);
							
							//Retrieved Set<Price List Associted with Option Product>
							Set<String> salesItemPriceList = productCodeToPriceList.get(ui.Sales_Item_Code__r.ProductCode);			
							System.debug('featurePriceList--->'+featurePriceList);
							System.debug('salesItemPriceList--->'+salesItemPriceList);
							
							//If Bundle Product or Option Product does not belongs to price book 
							if((featurePriceList !=NULL && !featurePriceList.contains(priceListId))|| (salesItemPriceList!=NULL && !salesItemPriceList.contains(priceListId))){
									  ui.Error_Message__c = System.Label.ErrorMessageForPriceListValidation;
									  failedupsellProposalId.add(upsellProposalObj.Id); 
									  ui.Ready_to_Convert__c = false; 
									  flag = true;
							 
							} else if(salesItemPriceList ==NULL){
							 ui.Error_Message__c = System.Label.ErrorMessageForPriceListValidation;
									  failedupsellProposalId.add(upsellProposalObj.Id); 
									  ui.Ready_to_Convert__c = false; 
									  flag = true;
							 
							
							}
							
							//If Bundle Product or Option Product  belongs to price book
							 else if((featurePriceList !=NULL && featurePriceList.contains(priceListId))|| (salesItemPriceList!=NULL && salesItemPriceList.contains(priceListId))){
									  ui.Error_Message__c = CSWXGlobalConstant.Blank;
									  ui.Ready_to_Convert__c = true; 
									  tempSuccessUpsellLineItemList.add(ui);
							}
							tempUpsellLineItemList.add(ui);		   
				}
	   
				
			  
				System.debug('flag--->'+flag);
				upsellProposalObj=updateDPforPricingValidation(flag,upsellProposalObj);
				DPStatus DP = new DPStatus(); 
				DP.CXMLineItemList = tempUpsellLineItemList;
				DP.CXMLineItemListSuccess = tempSuccessUpsellLineItemList;
				DP.flagForDp = flag;
				DP.DPObj = upsellProposalObj;
				return DP;
	   
	}catch(Exception ex){
			   System.debug('Exceptio123------>'+ex);
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_DigitalProposalBusinessRules,CSWXGlobalConstant.validateProductForPriceList);
			   return null;
	} 
  }
/*****************************
 *Method Name: validateUpsellItem
 *Description:This method is used to test Third Business validation Rule 
 *Parameters:SWx_Upsell_Proposal__c upsellProposalObj,List<SWx_Upsell_Items__c> upsellLineItemList,List<Apttus_Config2__ProductOptionComponent__c> productList
 *Test coverage from: DS_DigitalProposalBusinessRulesTest
 *******************************/
  public static DPStatus validateUpsellItem(SWx_Upsell_Proposal__c upsellProposalObj,List<SWx_Upsell_Items__c> upsellLineItemList,List<Apttus_Config2__ProductOptionComponent__c> productList){
		   Set<Id> failedProposal = new Set<Id>();
		   Boolean flag = false;
		   Map<String,Set<String>> bundleToOption = new Map<String,Set<String>>();
		   Set<Id> inReadyToConvertStage  = new Set<Id>();  
		   
		   //Upsell Proposal having Upsell Status = 'Ready To Convert'
		   if(upsellProposalObj.Upsell_Status__c == CSWXGlobalConstant.readyForConversion){
							inReadyToConvertStage.add(upsellProposalObj.id);
		   }

		   try{
		   //List<DPLineItem> to update
		   List<SWx_Upsell_Items__c> tempUpsellLineItemList = new List<SWx_Upsell_Items__c>(); 

		   Set<String> tempSet1 = new Set<String>();
		   
		   //Map<Bundle Product Code,List<Option Product Code>>
		   bundleToOption =   SWxUpsellProposalTriggerHelper.getbundleToOptionMap(productList);
		   
		   System.debug('bundleToOption'+bundleToOption);
		   System.debug('upsellLineItemList'+upsellLineItemList);
			
		   //Checking whether Option is part of bundle or not		   
		   if(bundleToOption.keySet()!=NULL){  
				  System.debug('upsellLineItemList1111'+upsellLineItemList);
			   
				  for(SWx_Upsell_Items__c ui : upsellLineItemList){
					   System.debug('uoi'+ui);
					  if(ui.Bundle_ID__c!=NULL){
							tempSet1 =  bundleToOption.get(ui.Bundle_ID__r.ProductCode);
							System.debug('tempSet1'+tempSet1);
							System.debug('ui.Sales_Item_Code__c'+ui.Sales_Item_Code__r.ProductCode);
							if(!tempSet1.contains(ui.Sales_Item_Code__r.ProductCode)){
								 ui.Ready_to_Convert__c = false;
								 ui.Error_Message__c = System.Label.ErrorMessageForBundleValidation;
								 failedProposal.add(upsellProposalObj.Id);
								 System.debug('Test11111321');
							}
							else {
								ui.Ready_to_Convert__c = true;
								ui.Error_Message__c = CSWXGlobalConstant.Blank;
								System.debug('Test11111');
							}
							tempUpsellLineItemList.add(ui);
						
				  }
			   }
			} 
				
			System.debug('flag--->'+flag);
			upsellProposalObj = updateDPforBundleValidation(flag,upsellProposalObj);
			DPStatus DP = new DPStatus(); 
			DP.CXMLineItemList = tempUpsellLineItemList;
			DP.flagForDp = flag;
			DP.DPObj = upsellProposalObj;
			return DP;
			
			}catch(Exception ex){
			   System.debug('Exceptio123------>'+ex);
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_DigitalProposalBusinessRules,CSWXGlobalConstant.validateUpsellItem);
			   return null;
	} 
		   
	  }
 /*****************************
 *Method Name: getListOfPriceList
 *Description: This method is get List<PricerList> associated with current Account
 *Parameters: String accId
 *Test coverage from: DS_DigitalProposalBusinessRulesTest
 *******************************/
	  public static List<Apttus_Config2__PriceList__c> getListOfPriceList(String accId){
		 try{
			 List<Apttus_Config2__PriceList__c> priceList = [SELECT Id,Apttus_Config2__AccountId__c,Type__c FROM Apttus_Config2__PriceList__c where Apttus_Config2__AccountId__c = :accId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			 return priceList;
		 }catch(Exception ex){
			   System.debug('Exceptio123------>'+ex);
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_DigitalProposalBusinessRules,CSWXGlobalConstant.getListOfPriceList);
			   return null;
	} 
}

/*****************************
 *Method Name: createMapPriceListToType
 *Description:This method is used to create Map<PriceListId,priceListType>  
 *Parameters:String accId
 *Test coverage from: DS_DigitalProposalBusinessRulesTest
 *******************************/
public static  Map<Id, String>  createMapPriceListToType(String accId){
			 try{
		 List<Apttus_Config2__PriceList__c> priceList = [SELECT Id,Apttus_Config2__AccountId__c,PriceList_Type__c FROM Apttus_Config2__PriceList__c where Apttus_Config2__AccountId__c = :accId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		 Map<Id, String> priceListType = new Map<Id, String>();
		
		 if(!priceList.isEmpty()){
			 for(Apttus_Config2__PriceList__c priceListObj : priceList ){
				priceListType.put(priceListObj.id, priceListObj.PriceList_Type__c);
			   
			 } 
		}
 
		return priceListType;
		}catch(Exception ex){
			   System.debug('Exceptio123------>'+ex);
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_DigitalProposalBusinessRules,CSWXGlobalConstant.createMapPriceListToType);
			   return null;
	} 
}

/*****************************
 *Method Name: createPriceItemList
 *Description: This method is used to create List<PriceItemList>  
 *Parameters : String accId
 *Test coverage from: DS_DigitalProposalBusinessRulesTest
 *******************************/
public static List<Apttus_Config2__PriceListItem__c> createPriceItemList(Set<String> productCode){
		 System.debug('productCode====>'+productCode);	
		  try{
			 List<Apttus_Config2__PriceListItem__c> priceListItemList = new List<Apttus_Config2__PriceListItem__c>();
			  priceListItemList = [SELECT ID,Apttus_Config2__PriceListId__c,Apttus_Config2__ProductCode__c FROM Apttus_Config2__PriceListItem__c where Apttus_Config2__ProductCode__c in :productCode LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			 return priceListItemList;
		}catch(Exception ex){
			   System.debug('Exceptio123------>'+ex);
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_DigitalProposalBusinessRules,CSWXGlobalConstant.createPriceItemList);
			   return null;
	} 
}

 /*****************************
 *Method Name: getPriceListId
 *Description: This method is get Id of Price List Associted with Account
 *Parameters: SWx_Upsell_Proposal__c upsellProposalObj,List<Apttus_Config2__PriceList__c> accontIdToPriceList,Map<Id, String> priceListType
 *Test coverage from: DS_DigitalProposalBusinessRulesTest
 *******************************/
public static String getPriceListId(SWx_Upsell_Proposal__c upsellProposalObj,List<Apttus_Config2__PriceList__c> accontIdToPriceList,Map<Id, String> priceListType){		 
				System.debug('inside method---->');   
				   //List<Apttus_Config2__PriceList__c> currentPriceList;
				   String priceListId;
				   Boolean doesNotMatchType = false;  
					 try{
							for(Apttus_Config2__PriceList__c plobj : accontIdToPriceList){
							
							 System.debug('priceListType.get(plobj.id)---->'+priceListType.get(plobj.id));
							 // DSI-1252,Sprint 21 - Removed the analytic resource  dependency ** /
							 
							 if(priceListType.get(plobj.id).equalsIgnoreCase(CSWXGlobalConstant.DSPriceListType)){
										priceListId = plobj.Id;
										break;
									}
							 
									
							   /*	 if(priceListType.get(plobj.id).equalsIgnoreCase(upsellProposalObj.Analytics_Source__c)
									  ){
										priceListId = plobj.Id;
										break;
									}
									
									
									 
								if(priceListType.get(plobj.id).equalsIgnoreCase(CSWXGlobalConstant.AnalyticsSource) && upsellProposalObj.Analytics_Source__c.equalsIgnoreCase(CSWXGlobalConstant.SourceID_RMP) )
								 {
										priceListId = plobj.Id;
										break;
									}   */
							}
							
							 System.debug('doesNotMatchType ====>'+doesNotMatchType);  
				  
					
					
					return priceListId;
					}catch(Exception ex){
			   System.debug('Exceptio123------>'+ex);
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_DigitalProposalBusinessRules,CSWXGlobalConstant.getPriceListId);
			   return null;
	} 
				
}


 /*****************************
 *Method Name: updateDPforPricingValidation
 *Description: This method is used update DP for Pricing Validation
 *Parameters: Boolean failedupsellProposalId,SWx_Upsell_Proposal__c upsellProposalObjRec
 *Test coverage from: DS_DigitalProposalBusinessRulesTest
 *******************************/
  public static SWx_Upsell_Proposal__c updateDPforPricingValidation(Boolean failedupsellProposalId,SWx_Upsell_Proposal__c upsellProposalObjRec){
			System.debug('failedupsellProposalId'+failedupsellProposalId);
			try{
			if(failedupsellProposalId){
					  upsellProposalObjRec.Ready_to_Convert__c = false;
					  upsellProposalObjRec.Business_Rules_Check__c = CSWXGlobalConstant.RED;
					  upsellProposalObjRec.Error_Message__c = System.Label.ErrorMessageForPriceListValidation;
			  }else{
					 if(upsellProposalObjRec.Business_Rules_Check__c != CSWXGlobalConstant.RED){
							 upsellProposalObjRec.Business_Rules_Check__c = CSWXGlobalConstant.GREEN;
					 }
					 if(upsellProposalObjRec.Upsell_Status__c == CSWXGlobalConstant.readyForConversion){
							upsellProposalObjRec.Ready_to_Convert__c = true;
					 }
					 else{
							 upsellProposalObjRec.Ready_to_Convert__c = false;
					 }
			  }
			 
			 return upsellProposalObjRec;
			 }catch(Exception ex){
			   System.debug('Exceptio123------>'+ex);
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_DigitalProposalBusinessRules,CSWXGlobalConstant.updateDPforPricingValidation);
			   return null;
	} 
   
}
		

 /*****************************
 *Method Name: updateDPforBundleValidation
 *Description: This method is used update DP for BundleValidation
 *Parameters: Boolean failedupsellProposalId,SWx_Upsell_Proposal__c upsellProposalObjRec
 *Test coverage from: DS_DigitalProposalBusinessRulesTest
 *******************************/  
	public static SWx_Upsell_Proposal__c updateDPforBundleValidation(Boolean failedupsellProposalId,SWx_Upsell_Proposal__c upsellProposalObjRec){
						 
		   System.debug('failedupsellProposalId'+failedupsellProposalId);
		   try{
			if(failedupsellProposalId){
					  upsellProposalObjRec.Ready_to_Convert__c = false;
					  upsellProposalObjRec.Business_Rules_Check__c = CSWXGlobalConstant.RED;
					  upsellProposalObjRec.Error_Message__c = System.Label.ErrorMessageForBundleValidation;
			  }else{
					 
					 if(upsellProposalObjRec.Business_Rules_Check__c != CSWXGlobalConstant.RED){
							 upsellProposalObjRec.Business_Rules_Check__c = CSWXGlobalConstant.GREEN;
					 }
					 if(upsellProposalObjRec.Upsell_Status__c == CSWXGlobalConstant.readyForConversion){
							upsellProposalObjRec.Ready_to_Convert__c = true;
					 }
					 else{
							 upsellProposalObjRec.Ready_to_Convert__c = false;
					 }
			  }
			 
			 return upsellProposalObjRec;
		}catch(Exception ex){
			   System.debug('Exceptio123------>'+ex);
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_DigitalProposalBusinessRules,CSWXGlobalConstant.updateDPforBundleValidation);
			   return null;
	} 
		
  }
/*****************************
 *Method Name: validateProductForCart
 *Description: This method is used to check 1st business rule
 *Parameters: SWx_Upsell_Proposal__c upsellProposalObj,List<SWx_Upsell_Items__c> upsellLineItemList,List<Product2> productList, Set<String> upsellLineItemCode
 *Test coverage from: DS_DigitalProposalBusinessRulesTest
 *******************************/
	  public static DPStatus validateProductForCart(SWx_Upsell_Proposal__c upsellProposalObj,List<SWx_Upsell_Items__c> upsellLineItemList,List<Product2> productList){
		 Boolean flag = false; 
		 //Set<Id> failedupsellProposalId  = new Set<Id>();		   
		 Set<String> productCodeSet  = new Set<String>();
	   
		 System.debug('upsellProposalObj--->'+upsellProposalObj);
		 System.debug('upsellLineItemList--->'+upsellLineItemList);
		 System.debug('productList--->'+productList);
		  
		 List<SWx_Upsell_Items__c> sucesssUpsellItemList = new List<SWx_Upsell_Items__c>();
		 List<SWx_Upsell_Items__c> updateLineItemsList_swx = new List<SWx_Upsell_Items__c>();
		 try{
		 
		  if(!productList.isEmpty()){
			for(Product2 productObj : productList ){
			  productCodeSet.add(productObj.ProductCode);
			}
		  }	 
		 
		 System.debug('productCodeSet--->'+productCodeSet);
		 for(SWx_Upsell_Items__c upsellItemObj : upsellLineItemList){
								if(!productCodeSet.contains(upsellItemObj.Bundle_ID__r.ProductCode) || !productCodeSet.contains(upsellItemObj.SWx_Product_Code__c)){
									  upsellItemObj.Ready_to_Convert__c = false;
									  upsellItemObj.Error_Message__c = System.Label.ErrorMessageForProductValidation;
									  flag = true;
								}
								else{
									upsellItemObj.Ready_to_Convert__c = true;
									upsellItemObj.Error_Message__c = CSWXGlobalConstant.Blank ;
									sucesssUpsellItemList.add(upsellItemObj);
								}
								updateLineItemsList_swx.add(upsellItemObj);
		 }
		 
		 System.debug('updateLineItemsList_swx--->'+updateLineItemsList_swx);	

				upsellProposalObj = updateDPProductValidation(flag,upsellProposalObj);
				DPStatus DP = new DPStatus(); 
				DP.CXMLineItemList = updateLineItemsList_swx;
				DP.CXMLineItemListSuccess = sucesssUpsellItemList;
				DP.flagForDp = flag;
				DP.DPObj = upsellProposalObj;
				System.debug('DP--->'+DP);   
				return DP;
			
		
		}catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_DigitalProposalBusinessRules,CSWXGlobalConstant.validateProductForCart);
			   return null;
		}
	  }

	  /*****************************
 *Method Name: updateDPProductValidation
 *Description: This method is used update DP for after checking 1st Business Rule
 *Parameters: Boolean failedupsellProposalId,SWx_Upsell_Proposal__c upsellProposalObjRec
 *Test coverage from: DS_DigitalProposalBusinessRulesTest
 *******************************/  
  public static SWx_Upsell_Proposal__c updateDPProductValidation(Boolean failedupsellProposalId,SWx_Upsell_Proposal__c upsellProposalObjRec){
						 
		   System.debug('failedupsellProposalId'+failedupsellProposalId);
		   try{
			if(failedupsellProposalId){
					  upsellProposalObjRec.Ready_to_Convert__c = false;
					  upsellProposalObjRec.Business_Rules_Check__c = CSWXGlobalConstant.RED;
					  upsellProposalObjRec.Error_Message__c = System.Label.ErrorMessageForProductValidation;
			  }else{
					 if(upsellProposalObjRec.Business_Rules_Check__c != CSWXGlobalConstant.RED){
							 upsellProposalObjRec.Business_Rules_Check__c = CSWXGlobalConstant.GREEN;
					 }
					 if(upsellProposalObjRec.Upsell_Status__c == CSWXGlobalConstant.readyForConversion){
							upsellProposalObjRec.Ready_to_Convert__c = true;
					 }
					 else{
							 upsellProposalObjRec.Ready_to_Convert__c = false;
					 }
			  }
			 
			 return upsellProposalObjRec;
		}catch(Exception ex){
			   System.debug('Exceptio123------>'+ex);
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_DigitalProposalBusinessRules,CSWXGlobalConstant.updateDPProductValidation);
			   return null;
	} 
		
  }
		

	 /*****************************
	*Class Name: DPStatus
	*Description: This class is used to maintain status of DP
	*******************************/
	public with sharing class DPStatus{
 
		public Boolean flagForDp;
		public SWx_Upsell_Proposal__c DPObj;
		public List<SWx_Upsell_Items__c> CXMLineItemList;
		public List<SWx_Upsell_Items__c> CXMLineItemListSuccess;
	   
	}   
}