/*----------------  
 Class Name: DS_DPSWXLineItem 
Created By: Accenture
Created date - 8-7-2018,
Last Modified By: Accenture
Description: This class having logic to display product information in ccre lineitem.
 ---------------------------*/
public with sharing class DS_DPSWXLineItem {

/******************************
	*Method Name: getDPType
	*Description: This Method will getthe type of DP(CXM or RMP)
	********************************/
	@AuraEnabled
	public static String getDPType(Id recordId)
	{   
		try{
			 SWx_Upsell_Proposal__c swxObj = [SELECT ID,Analytics_Source__c FROM SWx_Upsell_Proposal__c WHERE ID =:recordId limit 1];
			 return swxObj.Analytics_Source__c;
		 }catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_ContractOverview, CSWXGlobalConstant.getCurrentUserData);
			 return NULL;  
		 }
	}

	Public static integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows();
	
	@AuraEnabled
	public static List<wrapperClass> method(Id recordId){
		List<wrapperClass> wrpclasslist = new List<wrapperClass>();
		Set<String> swxId = new Set<String>();
		for(SWx_Upsell_Items__c dbItemObj : [select SWx_Product_Code__c,Quantity__c from SWx_Upsell_Items__c  where SWx_Upsell_Proposal__c =: recordId]){
			swxId.add(dbItemObj.SWx_Product_Code__c);
		}
		
		// List<Product_Feature_Junction__c> productFeatureJunctionList = [SELECT ID,NAME,Product_Code__c,Product__r.Name,Feature__c,Feature__r.Name,Feature__r.Description__c, Feature__r.Is_New__c,Product_Fetaure_Release__r.Name FROM Product_Feature_Junction__c WHERE Product_Code__c IN :swxId];
		
		List<Product_Feature_Junction__c> productFeatureJunctionList = [SELECT ID,NAME,Product_Code__c,Product__r.Name,Product_Feature__c,Product_Feature__r.Feature_Commercial_Number__c,Product_Feature__r.Description__c, Is_New__c,Release__r.Description__c FROM Product_Feature_Junction__c WHERE Product_Code__c IN :swxId];
		
		Map<String, List<Product_Feature_Junction__c>> productCodeToPFJObjNameMap = new  Map<String,List<Product_Feature_Junction__c>>();
		for (Product_Feature_Junction__c productFeatureJunctionObj : productFeatureJunctionList) { 
					if (productCodeToPFJObjNameMap.containsKey(productFeatureJunctionObj.Product_Code__c)) {
						productCodeToPFJObjNameMap.get(productFeatureJunctionObj.Product_Code__c).add(productFeatureJunctionObj);
					} 
					else {
						productCodeToPFJObjNameMap.put(productFeatureJunctionObj.Product_Code__c, new List<Product_Feature_Junction__c>{ productFeatureJunctionObj });
					}
		} 
	   for(SWx_Upsell_Items__c dbItemObj : [select SWx_Product_Code__c,Product_Name__c,Quantity__c from SWx_Upsell_Items__c  where SWx_Upsell_Proposal__c =: recordId Limit:limitRows]){
		   if(productCodeToPFJObjNameMap.get(dbItemObj.SWx_Product_Code__c) !=null){
		
		for(Product_Feature_Junction__c productFeatureJunctionObj : productCodeToPFJObjNameMap.get(dbItemObj.SWx_Product_Code__c)){
				 
				 wrapperClass wrpclass = new wrapperClass();
				 wrpclass.productCode=productFeatureJunctionObj.Product_Code__c;
				 wrpclass.productName= productFeatureJunctionObj.Product__r.Name;
				 wrpclass.quantity= dbItemObj.Quantity__c ;
				 wrpclass.featureCode = productFeatureJunctionObj.Product_Feature__r.Feature_Commercial_Number__c ;
				 wrpclass.featureDescription = productFeatureJunctionObj.Product_Feature__r.Description__c ;
				 wrpclass.releasePackage= productFeatureJunctionObj.Release__r.Description__c;
				 if(productFeatureJunctionObj.Is_New__c == true){
					 wrpclass.featureStatus= 'New';
				 }
				 else{
					 wrpclass.featureStatus= 'Old' ;
				 }
				 
				 wrpclasslist.add(wrpclass);
			  }
			}
			else{
			 wrapperClass wrpclass = new wrapperClass();
				 wrpclass.productCode=dbItemObj.SWx_Product_Code__c;
				 wrpclass.productName= dbItemObj.Product_Name__c;
				 wrpclass.quantity= dbItemObj.Quantity__c ;
				  wrpclasslist.add(wrpclass);
			
			}
		}

 
			 return wrpclasslist;  
 }
 
 
 
	 // wrapper or Inner class with @AuraEnabled {get;set;} properties*	
	public class wrapperClass{
	  
	   
		@AuraEnabled public String productCode{get;set;}
		@AuraEnabled public String productName{get;set;}
		
		@AuraEnabled public decimal quantity{get;set;}
		@AuraEnabled public String featureCode {get;set;}
		@AuraEnabled public String featureDescription {get;set;}
		@AuraEnabled public String releasePackage{get;set;}
		@AuraEnabled public String featureStatus{get;set;}
		
		
	}
 
 
 
}