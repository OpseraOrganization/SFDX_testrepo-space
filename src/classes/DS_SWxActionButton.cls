/******************************
	*Class Name : DS_SWxActionButton
	*Description: This class is used to update dashboard on click of different button
	********************************/
public class DS_SWxActionButton {

	 Public static integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows();	
	
	/******************************
	*Method Name: getCurrentUserData
	*Description: This Method will get the required data for the logged in user
	********************************/
	@AuraEnabled
	public static User getCurrentUserData()
	{   
		try{
			  return [SELECT Accountid,Contactid,Profile.Name,FirstName,Name, LastName from User where id=:UserInfo.getUserId() limit 1] ;
		 }catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_ContractOverview, CSWXGlobalConstant.getCurrentUserData);
			 return NULL;  
		 }
	}
	
	   
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
	
	/******************************
	*Method Name: getDPType
	*Description: This Method will getthe type of DP(CXM or RMP)
	********************************/
	@AuraEnabled
	public static String getCurrentUserProfile()
	{	
		try{
			 Id profileID = getCurrentUserData().ProfileId;
			 System.debug('profileID--->'+profileID);
			 String profileName = [SELECT ID ,NAME FROM PROFILE WHERE ID=:profileID limit 1].NAME;
			  System.debug('profileName--->'+profileName);
			 return profileName;
		 }catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_ContractOverview, CSWXGlobalConstant.getCurrentUserData);
			 return NULL;  
		 }
	}
	
	 /******************************
	*Method Name: getfeature
	*Description: This Method will get Feature and Feature Details to display on community portal
	********************************/
	@AuraEnabled
	public static List<wrapperClass> getFeature(Id recordId)
	{   
	   try{
		Set<String> swxId = new Set<String>();
		List<SWx_Upsell_Items__c> swxLineItemList = [SELECT ID,SWx_Product_Code__c,Product_Name__c,Is_Rejected__c,Acceptance_Initiation_Date__c,Acceptance_of_Delivery_Date__c,Delivery_Execution_Date__c,Quantity__c,Status_In_Network__c,SWx_Upsell_Proposal__r.Name,SWx_Upsell_Proposal__r.Use_Case__c,SWx_Upsell_Proposal__r.PO__r.Name,SWx_Upsell_Proposal__r.Technology__c,SWx_Upsell_Proposal__r.Agreement_Number__c,Acceptance_Initiation__c,Delivery_Execution__c, Acceptance_of_Delivery__c FROM SWx_Upsell_Items__c WHERE SWx_Upsell_Proposal__c = :recordId limit :limitRows];
		 for(SWx_Upsell_Items__c dbItemObj : swxLineItemList){
			swxId.add(dbItemObj.SWx_Product_Code__c);
		}
		//List<Product_Feature_Junction__c> productFeatureJunctionList = [SELECT ID,NAME,Feature__r.Name,Product_Code__c,Product__r.Name,Feature__c,Feature__r.Description__c FROM Product_Feature_Junction__c WHERE Product_Code__c IN :swxId limit :limitRows];
		
		List<Product_Feature_Junction__c> productFeatureJunctionList = [SELECT ID,NAME,Product_Feature__r.Feature_Commercial_Number__c,Product_Code__c,Product__r.Name,Product_Feature__c,Product_Feature__r.Description__c FROM Product_Feature_Junction__c WHERE Product_Code__c IN :swxId limit :limitRows];
		
		System.debug('productFeatureJunctionList--->'+productFeatureJunctionList);
	   
		 Map<String, List<Product_Feature_Junction__c>> productCodeToPFJObjNameMap = new  Map<String,List<Product_Feature_Junction__c>>();
		
		for (Product_Feature_Junction__c productFeatureJunctionObj : productFeatureJunctionList) { 
					if (productCodeToPFJObjNameMap.containsKey(productFeatureJunctionObj.Product_Code__c)) {
						productCodeToPFJObjNameMap.get(productFeatureJunctionObj.Product_Code__c).add(productFeatureJunctionObj);
					} 
					else {
						productCodeToPFJObjNameMap.put(productFeatureJunctionObj.Product_Code__c, new List<Product_Feature_Junction__c>{ productFeatureJunctionObj });
					}
		} 
 
		 System.debug('productCodeToPFJObjNameMap--->'+productCodeToPFJObjNameMap);  
		
			 //wrapperClass wrpclass = new wrapperClass();
		List<wrapperClass> wrpclasslist = new List<wrapperClass>();
	   
		 for(SWx_Upsell_Items__c dbItemObj : swxLineItemList){
			  system.debug('productCodeToPFJObjNameMap>>>'+productCodeToPFJObjNameMap.get(dbItemObj.SWx_Product_Code__c));
			 if(productCodeToPFJObjNameMap.containskey(dbItemObj.SWx_Product_Code__c)){
			 for(Product_Feature_Junction__c productFeatureJunctionObj : productCodeToPFJObjNameMap.get(dbItemObj.SWx_Product_Code__c)){
				wrapperClass wrpclass = new wrapperClass(); 
				 wrpclass.acceptanceInitiationStatus=dbItemObj.Acceptance_Initiation__c;
				 wrpclass.deliveryExecutionStatus=dbItemObj.Delivery_Execution__c;
				 wrpclass.acceptanceOfDeliveryStatus=dbItemObj.Acceptance_of_Delivery__c;
				 wrpclass.statusInNetWork= dbItemObj.Status_In_Network__c;
				 wrpclass.productCode= productFeatureJunctionObj.Product_Code__c;
				 wrpclass.productName= productFeatureJunctionObj.Product__r.Name;
				 wrpclass.quantity= dbItemObj.Quantity__c;
				 wrpclass.featureCode=productFeatureJunctionObj.Product_Feature__r.Feature_Commercial_Number__c;
				 wrpclass.featureDescription=productFeatureJunctionObj.Product_Feature__r.Description__c;
				 wrpclass.acceptanceInitiation=dbItemObj.Acceptance_Initiation_Date__c;
				 wrpclass.deliveryExecution=dbItemObj.Delivery_Execution_Date__c;
				 wrpclass.deliveryExecution=dbItemObj.Delivery_Execution_Date__c;
				 wrpclass.acceptanceOfDelivery=dbItemObj.Acceptance_of_Delivery_Date__c;
				 wrpclass.isRejected=dbItemObj.Is_Rejected__c;
				 
				
				 
				 wrpclasslist.add(wrpclass);
				 
			 }
			 }else{
				 wrapperClass wrpclass = new wrapperClass(); 
				 wrpclass.acceptanceInitiationStatus=dbItemObj.Acceptance_Initiation__c;
				 wrpclass.deliveryExecutionStatus=dbItemObj.Delivery_Execution__c;
				 wrpclass.acceptanceOfDeliveryStatus=dbItemObj.Acceptance_of_Delivery__c;
				 wrpclass.statusInNetWork= dbItemObj.Status_In_Network__c;
				 wrpclass.productCode= dbItemObj.SWx_Product_Code__c;
				 wrpclass.productName= dbItemObj.Product_Name__c;
				 wrpclass.quantity= dbItemObj.Quantity__c;
				 wrpclass.acceptanceInitiation=dbItemObj.Acceptance_Initiation_Date__c;
				 wrpclass.deliveryExecution=dbItemObj.Delivery_Execution_Date__c;
				 wrpclass.deliveryExecution=dbItemObj.Delivery_Execution_Date__c;
				 wrpclass.acceptanceOfDelivery=dbItemObj.Acceptance_of_Delivery_Date__c;
				 wrpclass.isRejected=dbItemObj.Is_Rejected__c;
				 
				
				 
				 wrpclasslist.add(wrpclass);
				 
			 }
			
		}
	 return wrpclasslist;
	   }catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_ContractOverview, CSWXGlobalConstant.getCurrentUserData);
			 return NULL;  
		 }	   
  }
	
	 
	/******************************
	*Method Name: updateDeliveryExecutionStatus
	*Description: This Method will update DeliveryExecutionStatus of SWx Line Item
	********************************/
	@AuraEnabled
	public static List<wrapperClass> updateDeliveryExecutionStatus(String productCode,Id recordId)
	{   
		List<wrapperClass> returnWrapper;  
		try{
				 System.debug('productCode------>'+productCode);
				 List<SWx_Upsell_Items__c> swxLineItemList = [SELECT ID,SWx_Product_Code__c,Acceptance_Initiation_Date__c,Acceptance_of_Delivery_Date__c,Delivery_Execution_Date__c,Quantity__c,Status_In_Network__c,SWx_Upsell_Proposal__r.Name,SWx_Upsell_Proposal__r.Use_Case__c,SWx_Upsell_Proposal__r.PO__r.Name,SWx_Upsell_Proposal__r.Technology__c,SWx_Upsell_Proposal__r.Agreement_Number__c,Acceptance_Initiation__c,Delivery_Execution__c, Acceptance_of_Delivery__c FROM SWx_Upsell_Items__c WHERE SWx_Upsell_Proposal__c = :recordId and SWx_Product_Code__c  = :productCode limit :limitRows];
				 System.debug('swxLineItemList------>'+swxLineItemList);
				 for(SWx_Upsell_Items__c swxLineItemObj : swxLineItemList){
						   swxLineItemObj.Delivery_Execution__c = true;
						   swxLineItemObj.Delivery_Execution_Date__c=System.now();
				 }
		
				 update swxLineItemList;
				 
				 returnWrapper = getFeature(recordId);
				 return returnWrapper;
				
		}catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_ContractOverview, CSWXGlobalConstant.getCurrentUserData);
			 return NULL;
		 }  
	}
	
	
	/******************************
	*Method Name: updateStatusInNetwork
	*Description: This Method will update updateStatusInNetwork1 of SWx Line Item
	********************************/
	@AuraEnabled
		public static List<wrapperClass> updateStatusInNetwork1(String productCode,Id recordId){ 
			List<wrapperClass> returnWrapper;  
			try{
				 System.debug('productCode------>'+productCode);
				 List<SWx_Upsell_Items__c> swxLineItemList = [SELECT ID,SWx_Product_Code__c,Acceptance_Initiation_Date__c,Acceptance_of_Delivery_Date__c,Delivery_Execution_Date__c,Quantity__c,Status_In_Network__c,SWx_Upsell_Proposal__r.Name,SWx_Upsell_Proposal__r.Use_Case__c,SWx_Upsell_Proposal__r.PO__r.Name,SWx_Upsell_Proposal__r.Technology__c,SWx_Upsell_Proposal__r.Agreement_Number__c,Acceptance_Initiation__c,Delivery_Execution__c, Acceptance_of_Delivery__c FROM SWx_Upsell_Items__c WHERE SWx_Upsell_Proposal__c = :recordId and SWx_Product_Code__c  = :productCode limit :limitRows];
				 System.debug('swxLineItemList------>'+swxLineItemList);
				 for(SWx_Upsell_Items__c swxLineItemObj : swxLineItemList){
					 if(swxLineItemObj.Status_In_Network__c){
						 swxLineItemObj.Status_In_Network__c = false;
					 }else{
						 swxLineItemObj.Status_In_Network__c = true;
					 }
				 }
		
				 update swxLineItemList;
				 returnWrapper = getFeature(recordId);
				 System.debug('After update swxLineItemList------>'+swxLineItemList);
				 return returnWrapper;
			}catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_ContractOverview, CSWXGlobalConstant.getCurrentUserData);
			  return NULL;
		 }
		
	}

	 /******************************
	*Method Name: updateDeliveryExecutionStatus
	*Description: This Method will update DeliveryExecutionStatus of SWx Line Item
	********************************/
	@AuraEnabled
	public static List<wrapperClass> updateAcceptanceOfDeliveryStatus(String productCode,Id recordId)
	{   
		try{
				 List<wrapperClass> returnWrapper;  
				 System.debug('productCode------>'+productCode);
				 List<SWx_Upsell_Items__c> swxLineItemList = [SELECT ID,SWx_Product_Code__c,Acceptance_Initiation_Date__c,Acceptance_of_Delivery_Date__c,Delivery_Execution_Date__c,Quantity__c,Status_In_Network__c,SWx_Upsell_Proposal__r.Name,SWx_Upsell_Proposal__r.Use_Case__c,SWx_Upsell_Proposal__r.PO__r.Name,SWx_Upsell_Proposal__r.Technology__c,SWx_Upsell_Proposal__r.Agreement_Number__c,Acceptance_Initiation__c,Delivery_Execution__c, Acceptance_of_Delivery__c FROM SWx_Upsell_Items__c WHERE SWx_Upsell_Proposal__c =:recordId and SWx_Product_Code__c  = :productCode limit :limitRows];
				 System.debug('swxLineItemList------>'+swxLineItemList);
				 for(SWx_Upsell_Items__c swxLineItemObj : swxLineItemList){
						   swxLineItemObj.Acceptance_of_Delivery__c = true;
						   swxLineItemObj.Acceptance_of_Delivery_Date__c=System.now();
							if(!swxLineItemObj.Status_In_Network__c){
						 swxLineItemObj.Status_In_Network__c = true;
					 }
				 }
				 update swxLineItemList;
				 returnWrapper = getFeature(recordId);
				 return returnWrapper;
				
		}catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_ContractOverview, CSWXGlobalConstant.getCurrentUserData);
			 return NULL;
		 } 
	}
	  
	// wrapper or Inner class with @AuraEnabled {get;set;} properties*	
	public class wrapperClass{
		
		@AuraEnabled public boolean acceptanceInitiationStatus {get;set;}
		@AuraEnabled public boolean deliveryExecutionStatus {get;set;}
		@AuraEnabled public boolean acceptanceOfDeliveryStatus {get;set;}
		@AuraEnabled public boolean statusInNetWork{get;set;}
		@AuraEnabled public String productCode{get;set;}
		@AuraEnabled public String productName{get;set;}
		@AuraEnabled public Decimal quantity{get;set;}
		@AuraEnabled public String featureCode {get;set;}
		@AuraEnabled public String featureDescription {get;set;}
		@AuraEnabled public String featurePackage {get;set;}
		@AuraEnabled public String featureStatus {get;set;}
		@AuraEnabled public Datetime acceptanceInitiation {get;set;}
		@AuraEnabled public Datetime deliveryExecution {get;set;}
		@AuraEnabled public Datetime acceptanceOfDelivery {get;set;} 
		@AuraEnabled public boolean isRejected {get;set;} 
	}

}