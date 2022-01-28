/****************************************
* Class Name : DS_Customcommmunitycontroller
* Created Date: 13 Nov 2018
* Created By : Accenture
* Last Modified by: Accenture
* Description : class used  for retrieving related products in Technical recommendation page
* Controller class for DS_Prop_RelatedProducts component
*/
public without sharing class DS_Customcommmunitycontroller
{
	   private static integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows();
/*****************************
*Method Name: showProducts
*Description: This method used to determine whether user should see products or not
#DSI-953-Sprint-19-Customer should be able to see products on technical recommendation page
*******************************/
	@AuraEnabled
	public static boolean showProducts(Id currentRecordId)
	{
		Boolean status = false;
		try
		{
			SWx_Upsell_Proposal__c swxproposal = [Select Id,Name 
												  from SWx_Upsell_Proposal__c 
												  where /*Analytics_Source__c = :CSWXGlobalConstant.CXM_Type
												  and */ID = :currentRecordId
												  Limit 1];   
			if(swxproposal <> null){
			status = true;}
			
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_Customcommunitycontroller,CSWXGlobalConstant.DS_showProducts);
		}
		return status;
	}
	
	/*****************************
*Method Name: Relatedproducts
*Description: This method will display line items of digital proposal along with features
#DSI-953-Sprint-19-Customer should be able to see products on technical recommendation page
*******************************/
	@AuraEnabled 
	public static List<Relatedproductspage> Relatedproducts(Id currentRecordId)
	{ 
		List<Relatedproductspage> Relatedproductspagelist=new List<Relatedproductspage> ();
		 try
		{
		Set<String> relatedProducts = new Set<String>();
		Map<string,List<Product_Feature_Junction__c>> ProductFeature=new Map<string,List<Product_Feature_Junction__c>>();
		List<SWx_Upsell_Items__c> SWX_Upsell_list=new List<SWx_Upsell_Items__c> ();
		
		
		//Collect all swx line items for the current digital proposal
		for(SWx_Upsell_Items__c SWX_upsell_product : [SELECT Id, 
													  Product_Name__c,
													  Quantity__c,
													  SWx_Product_Code__c,
													  Entitlement_Status__c,
													  Commercial_Entitlement__r.Name,
													  Entitlement_Status_Prioirty__c,
													  SWx_Upsell_Proposal__c,
													  Status_In_Network__c,
													  Sales_Item_Code__r.Description
													  FROM SWx_Upsell_Items__c 
													  where SWx_Upsell_Proposal__c =:currentRecordId
													  Order by Status_In_Network__c LIMIT: limitRows])
		{
			//relatedProducts.put(SWX_upsell_product.SWx_Product_Code__c,SWX_upsell_product);
			relatedProducts.add(SWX_upsell_product.SWx_Product_Code__c);
			SWX_Upsell_list.add(SWX_upsell_product);
		}
		
		
		for(Product_Feature_Junction__c prodFeatureJunction : [SELECT Name,Feature_Commercial_Number__c,
															   Feature__c,
															   Product_Feature__r.Description__c,
															   Product_Code__c, Is_New__c,
															   Release__c,
															   Release_NSN_Code__c
															   FROM Product_Feature_Junction__c
															   where Product_Code__c IN:relatedProducts
															   And GBOM_type__c = :CSWXGlobalConstant.DS_FeatureComponent LIMIT:limitRows])
		{
			if(prodFeatureJunction.Product_Code__c <> null && 
			   ProductFeature.containsKey(prodFeatureJunction.Product_Code__c)){
			   ProductFeature.get(prodFeatureJunction.Product_Code__c).add(prodFeatureJunction);}
			else{
			ProductFeature.put(prodFeatureJunction.Product_Code__c,new List<Product_Feature_Junction__c>{prodFeatureJunction});}
		}
		
		
		for(SWx_Upsell_Items__c Upsell_products: SWX_Upsell_list)
		{
			Relatedproductspage Relatedproduct_page = new Relatedproductspage(); 
			Relatedproduct_page.upsellitems=Upsell_products;
			Relatedproduct_page.featureboxopen=false;
			Relatedproduct_page.isactivated=Upsell_products.Status_In_Network__c;
			Relatedproduct_page.isFeatureAvailable = false;
			if(ProductFeature.containskey(Upsell_products.SWx_Product_Code__c))
			{
				Relatedproduct_page.isFeatureAvailable = true;
				Relatedproduct_page.featurejunction=ProductFeature.get(Upsell_products.SWx_Product_Code__c);
			}
			
			Relatedproductspagelist.add(Relatedproduct_page);
		}
		// system.debug('Relatedproductspagelist'+Relatedproductspagelist);   
		}	
	  
		
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_Customcommunitycontroller,CSWXGlobalConstant.DS_Relatedproducts);
		}
		
		 Return Relatedproductspagelist;  
	}
	
	/*****************************
*Class Name: Relatedproductspage
*Description: Wrapper class for displaying products with features
#DSI-953-Sprint-19-Customer should be able to see products on technical recommendation page
*******************************/
	public without sharing class Relatedproductspage 
	{
		@AuraEnabled public SWx_Upsell_Items__c upsellitems {get;set;}
		@AuraEnabled public List<Product_Feature_Junction__c> featurejunction {get;set;}
		@AuraEnabled public boolean featureboxopen {get;set;}
		@AuraEnabled public boolean isactivated {get;set;}
		@AuraEnabled public boolean isFeatureAvailable {get;set;}
		@AuraEnabled public String selectedRow {get;set;}
	}
	
	/*****************************
*Class Name: activateproducts
*Description: method for activating products 

*******************************/
	@AuraEnabled 
	public static void activateproducts(list<SWx_Upsell_Items__c> updateupsellitems)
	{ 
		//system.debug('updateupsellitems++>'+updateupsellitems); 
		try
		{
			if(updateupsellitems <> null && updateupsellitems.size() > 0){
			database.update(updateupsellitems,false);}
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_Customcommunitycontroller,
											CSWXGlobalConstant.DS_activateProductMethod);
		}
		
	}
	
	/*****************************
*Class Name: getcurrentuser
*Description: method for retrieving current user details

*******************************/
	@AuraEnabled 
	public static user getcurrentuser()
	{ 
		User Currentuser = new User();
		try
		{
			Id userId = UserInfo.getUserId();
			Currentuser = [SELECT Id,MediumPhotoUrl,lastName,SmallPhotoUrl,Name 
								FROM User 
								where Id=:userId 
								Limit 1];
			
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_Customcommunitycontroller,CSWXGlobalConstant.DS_getcurrentuser);
			
		}
		return Currentuser;
	}
	
	/*****************************
*Class Name: getcurrentuserContactcard
*Description: method for retrieving current user contact details

*******************************/
	@AuraEnabled 
	public static user getcurrentuserContactcard()
	{	
		User Currentuserowner = new User();
		Account CurrentuserAccount = new Account();
		try
		{	   
		Id userId =UserInfo.getUserId();
		
		User Currentuser = [SELECT Id,Name,Email,ContactId,SmallPhotoUrl,AccountId 
							FROM User 
							where Id=:userId Limit 1];
		
		// system.debug('Currentuser++>'+Currentuser);
		
		if(Currentuser<>null&&Currentuser.AccountId<>null)
		{
			CurrentuserAccount = [SELECT Id,ownerid 
								  FROM Account 
								  where Id=:Currentuser.AccountId
								 Limit 1];
		}
				   
		// system.debug('CurrentuserAccount++>'+CurrentuserAccount);
		if(CurrentuserAccount<>null&&CurrentuserAccount.ownerid<>null)
		{
			Currentuserowner = [SELECT Id,Name,firstName,SmallPhotoUrl,MediumPhotoUrl,ContactId,Phone,Email 
								FROM User 
								where Id = :CurrentuserAccount.ownerid
							   Limit 1];
		}				   
		//  system.debug('Currentuserowner++>'+Currentuserowner);
		
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_Customcommunitycontroller,
											CSWXGlobalConstant.getcurrentuserContactcard);
		}
		return Currentuserowner;
	}
}