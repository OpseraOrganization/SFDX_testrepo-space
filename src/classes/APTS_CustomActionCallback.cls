global with sharing class APTS_CustomActionCallback implements Apttus_Config2.CustomClass.IActionCallback3{
	
   /**
	 * Callback to perform pre-cloneBundle tasks
	 * @param CartId the Cart Id
	 * @param BundleLineItemIds Bundle Line Item Ids to be copied
	 * @return <code>true</code> if the operation is successful, <code>false</code> otherwise with List of error messages
	 */
	  global Apttus_Config2.CustomClass.ActionCallbackResponse beforeCopyBundleLineItems(Apttus_Config2.CustomClass.ActionCallbackRequest request) {
		  //System.debug('**** APTS_CustomActionCallback.beforeCopyBundleLineItems called *****'); 
		  Apttus_Config2.CustomClass.ActionCallbackResponse response =  new Apttus_Config2.CustomClass.ActionCallbackResponse();
		  response.isSuccess = true;
		  Id cartId = request.CartId;
		  
		  List<String> bundleLineItemIds=request.BundleLineItemIds;
		 
		  
		  List<Apttus_Config2__ProductConfiguration__c> configs = [Select Id,Apttus_QPConfig__Proposald__c, Apttus_QPConfig__Proposald__r.Apttus_Proposal__Proposal_Category__c 
																	  From Apttus_Config2__ProductConfiguration__c Where Id = :cartId];
		  List<Apttus_Config2__LineItem__c> LineitemDetails = [Select Id,Source__c,NokiaCPQ_Product_Name__c from Apttus_Config2__LineItem__c  where (Source__c = 'EPT' OR Source__c = 'Wavelite') AND Id IN:bundleLineItemIds]; //OR Source__c = 'Wavelite' Added by RG: for RE:6428
		 
																	   
		  if(!LineitemDetails.isEmpty())
		  {
			   for(Apttus_Config2__LineItem__c name1 :  LineitemDetails)
			  {
			// system.debug('Copy ke andar aaya');
			 response.isSuccess = false;
			 response.errorMessages.add('Copy is not allowed on EPT Products: '+name1.NokiaCPQ_Product_Name__c); 
			  }
		  }
		   return response;
		   
		   
	  }
	  
	  /**
	 * Callback to perform pre-deleteBundle tasks
	 * @param CartId the Cart Id
	 * @param BundleLineItemIds Bundle Line Item Ids to be deleted
	 * @return <code>true</code> if the operation is successful, <code>false</code> otherwise with List of error messages
	 */
	   global Apttus_Config2.CustomClass.ActionCallbackResponse beforeDeleteBundleLineItems(Apttus_Config2.CustomClass.ActionCallbackRequest request) {
		  //System.debug('**** APTS_CustomActionCallback.beforeCopyBundleLineItems called *****');
		  Map<String, String> mapValues = Apttus_Config2.RuntimeContext.getParameters();
		  String PageAction = mapValues.get(GlobalConstants.PAGEACTION);
		  Apttus_Config2.CustomClass.ActionCallbackResponse response =  new Apttus_Config2.CustomClass.ActionCallbackResponse();
		  response.isSuccess = true;
		  //Added by Christie JJ for rqmt 6987
		  if(PageAction != GlobalConstants.ABANDON){
		  Id cartId = request.CartId;
		  List<String> bundleLineItemIds=request.BundleLineItemIds;
		  //system.debug('[+] BundleLine Size = '+bundleLineItemIds.size()); 
		  List<Apttus_Config2__ProductConfiguration__c> configs = [Select Id,Apttus_QPConfig__Proposald__c
																	  From Apttus_Config2__ProductConfiguration__c Where Id = :cartId];
			  
				 
		  List<Apttus_Config2__LineItem__c> LineitemDetails = [Select Id,Source__c,NokiaCPQ_Product_Name__c from Apttus_Config2__LineItem__c where (Source__c = 'EPT' OR Source__c = 'Wavelite') AND Id IN:bundleLineItemIds];  //OR Source__c = 'Wavelite' Added by RG: for RE:6428
		 
		 
			   
			   
		  

		  if(!LineitemDetails.isEmpty() )
			 
		  {   // List<String> addLineItems = new List<String>();
			  for(Apttus_Config2__LineItem__c name :  LineitemDetails)
			  {
			 response.isSuccess = false;
			 response.errorMessages.add('Removal is not allowed on following EPT Products:'+ name.NokiaCPQ_Product_Name__c); 
			  }
		  }
			
		  }
		  return response;
															  
	  } 
 
 }