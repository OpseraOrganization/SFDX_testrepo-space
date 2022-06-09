public without sharing class CPQ_ProductStatusCheckController {
	
	 @AuraEnabled
	//public static Map<String, List<string>> getProductStatusResult(Id proposalId) {
	public static List<string> getProductStatusResult(Id proposalId) {
		// COllect Proposal Line Item with Status Value and Check are they active or not.
		// based on Check prepare Map<String, List<string>> key: Status Inactive; Values: Warning message list for PLIs
		
		List<string> listProductWarningMessage = new List<string>();
		Map<String, String> mapQDSIProdCodeAndMainBundleName = new Map<String, String>();
		Map<String, String> mapNokiaCPQProductStatus = new Map<String, String>();
		
		//Added
		Map<String, set<String>> mapQDSIProdCodeAndPCIcode = new Map<String, set<String>>();
		set<string> QDSIProdCodeSet = new set<string>();
		
		
		for(NokiaCPQ_Product_Status__c prodstatus : NokiaCPQ_Product_Status__c.getall().values())
			mapNokiaCPQProductStatus.put(prodstatus.Name,prodstatus.Error_Message__c);
		
		// collect Product And its parent main bundle name
		for(Quote_Delivery_Sales_Item__c objDeliverySalesItem : [Select Id, Name, Product_Code__c,PCI_Code__c,Parent_Line_Item__r.NokiaCPQ_Product_Name__c from Quote_Delivery_Sales_Item__c WHERE Proposal__c=: proposalId and Product_Code__c != null]){
			mapQDSIProdCodeAndMainBundleName.put(objDeliverySalesItem.Product_Code__c, objDeliverySalesItem.Parent_Line_Item__r.NokiaCPQ_Product_Name__c);
		}
		
		// collect QDSIs products status 
		List<Product2> listProductFromDeliverySalesItem = [SELECT Id, Name, ProductCode, NokiaCPQ_State__c FROM Product2 WHERE ProductCode =: mapQDSIProdCodeAndMainBundleName.keySet() and NokiaCPQ_State__c =: mapNokiaCPQProductStatus.keyset()];
		
		List<Apttus_Proposal__Proposal_Line_Item__c> listPLIOfQuotes = new List<Apttus_Proposal__Proposal_Line_Item__c>();
		listPLIOfQuotes = [Select id,Name,Product_Code__c, NokiaCPQ_Configuration_Type__c, Apttus_QPConfig__ChargeType__c, Apttus_QPConfig__LineType__c,Apttus_Proposal__Product__c,Apttus_Proposal__Product__r.NokiaCPQ_State__c,Apttus_Proposal__Product__r.ProductCode,Apttus_Proposal__Product__r.Name,Apttus_QPConfig__LineNumber__c,Apttus_QPConfig__OptionId__r.Name,Apttus_QPConfig__OptionId__r.NokiaCPQ_State__c,Apttus_QPConfig__OptionId__r.ProductCode,Apttus_QPConfig__ParentBundleNumber__c,Apttus_Proposal__Proposal_Line_Item__c.PCI_Code__c from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c = :proposalId ];	  
		
		//**Added**//
		//Map<string,set<string>> optionPCICodeMap = new Map<string,set<string>>();
		Map<string,set<string>> prodRelationMap = new Map<string,set<string>>();
		Map<string,set<string>> cspExportMappingMap = new Map<string,set<string>>();
		set<string> plicodesSet = new set<string>();
		set<string> pciCodecspSet = new set<string>();
		List<String> ruleSet = new List<String>();
		set<string> csppcicodes = new set<string>();
		set<string> QDSIpcicodes = new set<string>();
		set<string> QDSIProdcodeNOTinCSPExport = new set<string>();
		
		
		for(Apttus_Proposal__Proposal_Line_Item__c objPLI :  listPLIOfQuotes){		  
			if(objPLI.Apttus_QPConfig__LineType__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PRODUCT_SERVICES) && objPLI.Apttus_QPConfig__ParentBundleNumber__c == null && mapNokiaCPQProductStatus.containskey(objPLI.Apttus_Proposal__Product__r.NokiaCPQ_State__c)){				
				string error_msg = mapNokiaCPQProductStatus.get(objPLI.Apttus_Proposal__Product__r.NokiaCPQ_State__c);
				system.debug(error_msg);
				string final_errormsg = error_msg.replace('{ProdName}',objPLI.Apttus_Proposal__Product__r.Name);
				final_errormsg = final_errormsg.replace('{ProdCode}',objPLI.Apttus_Proposal__Product__r.ProductCode);
				system.debug(final_errormsg);
				listProductWarningMessage.add(final_errormsg);	 
				
			}
			else if(objPLI.Apttus_QPConfig__LineType__c.equalsIgnoreCase(Nokia_CPQ_Constants.OPTION) && mapNokiaCPQProductStatus.containskey(objPLI.Apttus_QPConfig__OptionId__r.NokiaCPQ_State__c)){
				string error_msg = mapNokiaCPQProductStatus.get(objPLI.Apttus_QPConfig__OptionId__r.NokiaCPQ_State__c);
				system.debug(error_msg);				
				string final_errormsg = error_msg.replace('{ProdName}',objPLI.Apttus_QPConfig__OptionId__r.Name);
				final_errormsg = final_errormsg.replace('{ProdCode}',objPLI.Apttus_QPConfig__OptionId__r.ProductCode); 
				system.debug(final_errormsg);
				listProductWarningMessage.add(final_errormsg);								
				
			}									 
		}				   
			 
		// Iterate on Product 2 and generate warning message for QDSI.
		System.debug('list-->'+listProductFromDeliverySalesItem);
		if(!listProductFromDeliverySalesItem.isEmpty()){
			for(Product2 objProductWithWarningStatue: listProductFromDeliverySalesItem){
				
					String steMainBundleName = mapQDSIProdCodeAndMainBundleName.get(objProductWithWarningStatue.ProductCode);
					
					string error_msg = mapNokiaCPQProductStatus.get(objProductWithWarningStatue.NokiaCPQ_State__c);
					system.debug(error_msg);
					string final_errormsg;
					if(!String.isblank(steMainBundleName)){
						 final_errormsg = error_msg.replace('{ProdName}',steMainBundleName);
					}
					
					if(!String.isblank(final_errormsg)){
						final_errormsg = final_errormsg.replace('{ProdCode}',objProductWithWarningStatue.ProductCode);
					}
					system.debug(final_errormsg);
					listProductWarningMessage.add(final_errormsg); 
					
			}
		}
		
		system.debug('listProductWarningMessage>>>'+listProductWarningMessage);
		return listProductWarningMessage;
	}
}