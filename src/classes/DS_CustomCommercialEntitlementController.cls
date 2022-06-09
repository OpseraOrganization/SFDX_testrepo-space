/****************************************
* Class Name : DS_CustomCommercialEntitlementController
* Created Date: 13 Nov 2018
* Created By : Accenture
* Last Modified by: Accenture
* Description : class used  for retrieving related products in commercial proposal page
* Controller class for DS_CommercialEntitlement_RelatedDP component
*/
public with sharing class DS_CustomCommercialEntitlementController {
	 Public static integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows();
	
	/*****************************
*Method Name: relatedDigitalProposals
*Description: This method used to show all the related products for the commercial entitlement
#DSI-987-Sprint-19-Customer should be able to see products on commercial entitlement page
*******************************/
	@AuraEnabled 
	public static List<Relatedproductspage> relatedDigitalProposals(Id currentRecordId)
	{	  
		Set<String> relatedProducts = new Set<String>();
		Map<string,List<Product_Feature_Junction__c>> ProductFeature=new Map<string,List<Product_Feature_Junction__c>>();
		List<SWx_Upsell_Items__c> SWX_Upsell_list=new List<SWx_Upsell_Items__c> ();
		List<Relatedproductspage> Relatedproductspagelist=new List<Relatedproductspage> ();  
		
		try{
			//Collect all swx line items for the current commercial entitlement
			for(SWx_Upsell_Items__c SWX_upsell_product : [SELECT Id, 
														  Customer_PO_Item__r.Name,
														  SWx_Upsell_Proposal__r.Name,
														  Name,
														  SWx_Upsell_Proposal__r.Creation_Date__c,
														  Quantity__c,
														  Acceptance_Initiation__c,				
				Delivery_Completed__c,
														  Active_in_Network_Date__c,
														  Status_In_Network__c,
														  SWx_Product_Code__c,
														  Acceptance_Initiation_Date__c,
														  Delivery_Completed_Date__c
														  FROM SWx_Upsell_Items__c 
														  where Commercial_Entitlement__c =:currentRecordId
														  Order by Status_In_Network__c LIMIT: limitRows])
			{
				relatedProducts.add(SWX_upsell_product.SWx_Product_Code__c);
				system.debug('Acceptance_Initiation_Date__c>>'+SWX_upsell_product.Acceptance_Initiation_Date__c);							   
				SWX_Upsell_list.add(SWX_upsell_product);
			}
			system.debug('SWX_Upsell_list>>'+SWX_Upsell_list);
			for(Product_Feature_Junction__c prodFeatureJunction : [SELECT Name,Feature_Commercial_Number__c,
																   Feature__c,
																   Product_Feature__r.Description__c,
																   Product_Code__c,
																   Release__c,
																   Release_NSN_Code__c,
																   Is_New__c
																   FROM Product_Feature_Junction__c
																   where Product_Code__c IN:relatedProducts 
																   And GBOM_type__c = :CSWXGlobalConstant.DS_FeatureComponent LIMIT: limitRows])
				
			{
				system.debug('prodFeatureJunction.Product_Code__c>>'+prodFeatureJunction.Product_Code__c);
				
				if(prodFeatureJunction.Product_Code__c <> null && 
				   ProductFeature.containsKey(prodFeatureJunction.Product_Code__c))
				{
					ProductFeature.get(prodFeatureJunction.Product_Code__c).add(prodFeatureJunction);
				}					
				else
				{
					ProductFeature.put(prodFeatureJunction.Product_Code__c,new List<Product_Feature_Junction__c>{prodFeatureJunction});
				}					
			}
			
			for(SWx_Upsell_Items__c Upsell_products: SWX_Upsell_list)
			{
				Relatedproductspage Relatedproduct_page = new Relatedproductspage(); 
				Relatedproduct_page.upsellitems=Upsell_products;
				Relatedproduct_page.featureboxopen=false;
				Relatedproduct_page.selectedRow=CSWXGlobalConstant.slds_hint_parent;
				Relatedproduct_page.isactivated=Upsell_products.Status_In_Network__c;
	Relatedproduct_page.isdeliverycompleted=Upsell_products.Delivery_Completed__c;
	
	//String strDt = Upsell_products.Acceptance_Initiation_Date__c.format('MM/dd/yyyy', UserInfo.getLocale());
	//system.debug('strDt>>'+strDt);
				if(Upsell_products.Acceptance_Initiation_Date__c!=null){
				system.debug('in if');
				Relatedproduct_page.acceptanceinitiationdate=DS_Controller_locale_formatted_datetime.getTimeZoneValue(Upsell_products.Acceptance_Initiation_Date__c);	
				system.debug('date is>>'+DS_Controller_locale_formatted_datetime.getTimeZoneValue(Upsell_products.Acceptance_Initiation_Date__c));
				}else{
				   Relatedproduct_page.acceptanceinitiationdate=''; 
				}
				
				if(Upsell_products.Delivery_Completed_Date__c!=null){
					system.debug('in another if');
					Relatedproduct_page.deliverycompleteddate=DS_Controller_locale_formatted_datetime.getTimeZoneValue(Upsell_products.Delivery_Completed_Date__c);					
					system.debug('d date is'+DS_Controller_locale_formatted_datetime.getTimeZoneValue(Upsell_products.Delivery_Completed_Date__c));
				}else{
					Relatedproduct_page.deliverycompleteddate=''; 
				}				
							 
				if(Upsell_products.Active_in_Network_Date__c!=null){
					system.debug('in another another if');
					Relatedproduct_page.activenetworkdate=DS_Controller_locale_formatted_datetime.getTimeZoneValue(Upsell_products.Active_in_Network_Date__c);					
					system.debug('d date is'+DS_Controller_locale_formatted_datetime.getTimeZoneValue(Upsell_products.Active_in_Network_Date__c));
				}else{
					Relatedproduct_page.activenetworkdate=''; 
				}
				//String strDt1 = Upsell_products.Delivery_Completed_Date__c.format('MM/dd/yyyy', UserInfo.getLocale());
	//system.debug('strDt>>'+strDt);
				
				Relatedproduct_page.isFeatureAvailable = false;
				if(ProductFeature.containskey(Upsell_products.SWx_Product_Code__c))
				{
					Relatedproduct_page.isFeatureAvailable = true;
					Relatedproduct_page.featurejunction=ProductFeature.get(Upsell_products.SWx_Product_Code__c);
				}
				Relatedproductspagelist.add(Relatedproduct_page);
				system.debug('Relatedproductspagelist>>'+Relatedproductspagelist);
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_CustomCommercialEntitlementController,CSWXGlobalConstant.DS_relatedDigitalProposals);
		}
		return Relatedproductspagelist;
		
	}
	
	/*****************************
*Class Name: Relatedproductspage
*Description: This class is a wrapper for displaying products alone with its features
#DSI-987-Sprint-19-Customer should be able to see products along with option to activate in commercial entitlement
related technical recommendation items section
*******************************/
	public without sharing class Relatedproductspage 
	{
		@AuraEnabled public SWx_Upsell_Items__c upsellitems {get;set;}
		@AuraEnabled public List<Product_Feature_Junction__c> featurejunction {get;set;}
		@AuraEnabled public boolean featureboxopen {get;set;}
		@AuraEnabled public boolean isactivated {get;set;}
		@AuraEnabled public boolean isdeliverycompleted {get;set;} //DSI-1254
		@AuraEnabled public String deliverycompleteddate {get;set;}  //DSI-1254
		@AuraEnabled public String acceptanceinitiationdate {get;set;} //DSI-1254
		@AuraEnabled public String activenetworkdate {get;set;} //DSI-1254
		@AuraEnabled public boolean isFeatureAvailable {get;set;}
		@AuraEnabled public String selectedRow {get;set;}
	}
	
	/*****************************
*Method Name: activateproducts
*Description: This method used to activate product from commercial entitlement page
#DSI-953-Sprint-19-Customer should be able to activate product from commercial entitlement page
*******************************/
	@AuraEnabled 
	public static void activateproducts(list<SWx_Upsell_Items__c> updateupsellitems)
	{ 
		try
		{
			if(updateupsellitems <> null && updateupsellitems.size() > 0)
			{
				database.update(updateupsellitems,false);
			}			   
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_CustomCommercialEntitlementController,CSWXGlobalConstant.DS_activateProductMethod);
		}
		
	}
}