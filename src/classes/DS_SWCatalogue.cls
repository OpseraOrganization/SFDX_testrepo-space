/******************************
*Class Name: DS_SWCatalogue
*Description: This class used to get ListView of RMP DP
********************************/
public without sharing class DS_SWCatalogue {
	
	Public static integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows();	
	
	/******************************
*Method Name: getCurrentUserData
*Description: This Method will get the required data for the logged in user
********************************/
	@AuraEnabled
	public static User getCurrentUserData()
	{   
		try{
			return [SELECT Accountid,Contactid,ProfileId,FirstName,Name, LastName from User where id=:UserInfo.getUserId() limit 1] ;
		}catch(Exception ex){
			ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_ContractOverview, CSWXGlobalConstant.getCurrentUserData);
			return NULL;  
		}
	}
	
	/******************************
*Method Name: getCurrentUserProfile
*Description: This Method will get the profile of current User
********************************/
	public static String getCurrentUserProfile()
	{	
		try{
			Id profileID = getCurrentUserData().ProfileId;
			System.debug('profileID--->'+profileID);
			String profileName = [SELECT ID ,NAME FROM PROFILE WHERE ID=:profileID limit 1].NAME;
			System.debug('profileName--->'+profileName);
			return profileName;
		}catch(Exception ex){
			ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_ContractOverview, CSWXGlobalConstant.getCurrentUserProfile);
			return NULL;  
		}
	}
	
	
	/******************************
*Method Name: getFrameContractReference
*Description: This Method will get Frame Contract Reference from fileupload obj.
********************************/ 
	@AuraEnabled
	public static List<String> getFrameContractReference() {
		List<String> frameContractRefList = new List<String>();
		Set<String> frameContractRef = new Set<String>();
		Set<Id> accountIdSet = new Set<Id>();
		try{
			accountIdSet.add(getCurrentUserData().accountId);
			String profileName =  getCurrentUserProfile();
			System.debug('accountIdSetBefore---->'+accountIdSet);
			if(profileName!=CSWXGlobalConstant.customerProfile){
				
				Set<Id> territoryId = new Set<Id>();
				for(UserTerritory2Association UserTerritory2Associationobj : [Select id, Territory2Id, UserId from UserTerritory2Association where UserId = :UserInfo.getUserId() LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())] ){
					territoryId.add(UserTerritory2Associationobj.Territory2Id);
				}
				
				System.debug('territoryId---->'+territoryId);
				
				for(ObjectTerritory2Association ObjectTerritory2Associationobj : [select id, Territory2Id, Territory2.name, SobjectType, ObjectId, AssociationCause from ObjectTerritory2Association where Territory2Id in: territoryId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
					if(ObjectTerritory2Associationobj.SobjectType == CSWXGlobalConstant.accObj)
					{
						accountIdSet.add(ObjectTerritory2Associationobj.ObjectId); 
					}
				}
				
				System.debug('accountIdSet---->'+accountIdSet);
			}
			list<Account> legalentityaccIdSet = [select Id from account where ParentId in:accountIdSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			system.debug('legalentityaccIdSet --->'+legalentityaccIdSet);
			
			for(Apttus__APTS_Agreement__c str : [select id,Apttus__FF_Agreement_Number__c, Name from Apttus__APTS_Agreement__c WHERE Apttus__Account__c IN :legalentityaccIdSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
				frameContractRef.add(str.Name + CSWXGlobalConstant.dash + str.Apttus__FF_Agreement_Number__c );
			}
			frameContractRefList.addAll(frameContractRef);
			system.debug('frameContractRefListFinal>>>>'+frameContractRefList);
			return frameContractRefList;
		}catch (Exception ex) { 
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_ContractOverview ,CSWXGlobalConstant.getFrameContractReference);
			return null;
		}   
	}
	
	/******************************
*Method Name: getPO
*Description: This Method will get PO from fileupload obj.
********************************/ 
	@AuraEnabled
	public static List<String> getPO() {
		List<String> poList = new List<String>();
		Set<Id> accountIdSet = new Set<Id>();
		accountIdSet.add(getCurrentUserData().accountId);
		String profileName =  getCurrentUserProfile();
		System.debug('accountIdSetBefore---->'+accountIdSet);
		if(profileName!=CSWXGlobalConstant.customerProfile){
			
			Set<Id> territoryId = new Set<Id>();
			for(UserTerritory2Association UserTerritory2Associationobj : [Select id, Territory2Id, UserId from UserTerritory2Association where UserId = :UserInfo.getUserId() LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				territoryId.add(UserTerritory2Associationobj.Territory2Id);
			}
			
			System.debug('territoryId---->'+territoryId);
			
			for(ObjectTerritory2Association ObjectTerritory2Associationobj : [select id, Territory2Id, Territory2.name, SobjectType, ObjectId, AssociationCause from ObjectTerritory2Association where Territory2Id in: territoryId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				if(ObjectTerritory2Associationobj.SobjectType == CSWXGlobalConstant.accObj && ObjectTerritory2Associationobj.ObjectId != null)
				{
					accountIdSet.add(ObjectTerritory2Associationobj.ObjectId); 
				}
			}
			
			System.debug('accountIdSet---->'+accountIdSet);
		}	 
		Set<String> poSet = new Set<String>();
		try{
			
			for(Apttus_Config2__CustomerPurchaseOrder__c str : [select id,Name from Apttus_Config2__CustomerPurchaseOrder__c where Apttus_Config2__AccountId__c IN :accountIdSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
				poSet.add(str.Name);
			}
			
			poList.addAll(poSet);
			return poList;
		}catch (Exception ex) { ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_ContractOverview ,CSWXGlobalConstant.getPO);
							   return null;
							  }   
	}
	
	
	/******************************
*Class Name: wrapperClass
*Description: This class used to get DP Line Item with Feature
********************************/
	public class wrapperClass{
		@AuraEnabled public boolean statusInNetWork{get;set;}
		@AuraEnabled public String productName{get;set;}
		@AuraEnabled public String productCode{get;set;}
		@AuraEnabled public String featureDescription {get;set;}
		@AuraEnabled public String dpId {get;set;}
		@AuraEnabled public boolean acceptanceInitiation {get;set;}
		@AuraEnabled public boolean deliveryExecution {get;set;}
		@AuraEnabled public boolean acceptanceOfDelivery {get;set;}
		@AuraEnabled public String agreement {get;set;}
		@AuraEnabled public String agreementName {get;set;}
		@AuraEnabled public String po {get;set;}
		@AuraEnabled public String technology {get;set;}
		@AuraEnabled public String usecase {get;set;}
		@AuraEnabled public String dP_Id {get;set;}
	}
	
	/******************************
*Method Name: getfeature
*Description: This Method will get Feature and Feature Details to display on community portal
********************************/
	@AuraEnabled
	public static List<wrapperClass> getFeature(String agreement,String poNum,String tech,String uCase,String sin)
	{   
		System.debug('agreement----->'+agreement);	   
		System.debug('poNum----->'+poNum); 
		System.debug('tech----->'+tech); 
		System.debug('uCase----->'+uCase); 
		System.debug('sin----->'+sin); 
		
		try{
			
			Set<Id> accountIdSet = new Set<Id>();
			accountIdSet.add(getCurrentUserData().accountId);
			String profileName =  getCurrentUserProfile();
			System.debug('accountIdSetBefore---->'+accountIdSet);
			if(profileName!=CSWXGlobalConstant.customerProfile){
				List<UserTerritory2Association> UserTerritory2AssociationList=[Select id, Territory2Id, UserId from UserTerritory2Association where UserId = :UserInfo.getUserId() LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
				System.debug('UserTerritory2AssociationList---->'+UserTerritory2AssociationList);
				Set<Id> territoryId = new Set<Id>();
				for(UserTerritory2Association UserTerritory2Associationobj : UserTerritory2AssociationList){
					territoryId.add(UserTerritory2Associationobj.Territory2Id);
				}
				
				System.debug('territoryId---->'+territoryId);
				List<ObjectTerritory2Association> ObjectTerritory2AssociationList = [select id, Territory2Id, Territory2.name, SobjectType, ObjectId, AssociationCause from ObjectTerritory2Association where Territory2Id in: territoryId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
				System.debug('ObjectTerritory2AssociationList ---->'+ObjectTerritory2AssociationList);
				for(ObjectTerritory2Association ObjectTerritory2Associationobj : ObjectTerritory2AssociationList){
					if(ObjectTerritory2Associationobj.SobjectType == CSWXGlobalConstant.accObj )
					{
						accountIdSet.add(ObjectTerritory2Associationobj.ObjectId); 
						
					}
				}
			}
			
			System.debug('accountIdSet---->'+accountIdSet);
			//select legal entity ID
			list<Account> legalentityaccIdSet = [select Id from account where ParentId in:accountIdSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			system.debug('legalentityaccIdSet --->'+legalentityaccIdSet);
			
			String Analytics_Source=CSWXGlobalConstant.SourceID_RMP;
			String UpsellStatusDraft = CSWXGlobalConstant.draft;
			
			String sSoql1=CSWXGlobalConstant.SW_catalogueQueryforDP;
			
			if(agreement != null && poNum != null && tech != null && uCase != null && sin != null ){
				boolean status_in_network;
				if(sin.equals(CSWXGlobalConstant.ONString)){
					status_in_network= True;  
				}else{
					status_in_network= False;
				}
				
				
				if(agreement!=CSWXGlobalConstant.NONE  && agreement!=null){
					String[] agreementNumber = agreement.split(CSWXGlobalConstant.dash);
					String agreementNo =agreementNumber[1];
					system.debug('agreementNo----'+agreementNo);
					sSoql1=sSoql1+CSWXGlobalConstant.SW_catalogueQueryforAgreement;   
				}
				
				System.debug('tech before if----->'+tech);	 
				if(!(tech.equalsIgnoreCase(CSWXGlobalConstant.BLANK_VALUE) || tech.equalsIgnoreCase(CSWXGlobalConstant.NONE_OPTION_VALUE) || tech==null || tech.equalsIgnoreCase(CSWXGlobalConstant.nullValue))){
					System.debug('tech inside if----->'+tech);
					sSoql1=sSoql1+CSWXGlobalConstant.SW_catalogueQueryforTech;
				}
				
				If(!poNum.equalsIgnoreCase(CSWXGlobalConstant.NONE) && poNum !=null){
					sSoql1=sSoql1+CSWXGlobalConstant.SW_catalogueQueryforPONo;
				}
				
				if(!(uCase.equalsIgnoreCase(CSWXGlobalConstant.NONE_OPTION_VALUE) || uCase.equalsIgnoreCase(CSWXGlobalConstant.BLANK_VALUE) || uCase== null ||uCase.equalsIgnoreCase(CSWXGlobalConstant.nullValue))){
					sSoql1=sSoql1+CSWXGlobalConstant.SW_catalogueQueryforUSeCase;
				}
				
			}
			
			system.debug('sSoql1>>>>>' +sSoql1);
			
			
			List<SWx_Upsell_Proposal__c> dpList= Database.query(sSoql1);		
			
			
			Set<String> dpId = new Set<String>();
			Set<String> swxId = new Set<String>();
			
			for(SWx_Upsell_Proposal__c dbObj:dpList){
				dpId.add(dbObj.Id);
			}
			
			
			List<SWx_Upsell_Items__c> lstResult;
			List<SWx_Upsell_Items__c> swxLineItemList= new List<SWx_Upsell_Items__c>();
			String sSoql=CSWXGlobalConstant.DS_SWCatalague_query1;
			if(sin != CSWXGlobalConstant.nullValue  ){
				sSoql+= CSWXGlobalConstant.DS_SWCatalague_query2;
			}
			try{
				lstResult = Database.query(sSoql); 
				
				if(!lstResult.isEmpty() && lstResult!=null){
					for (SWx_Upsell_Items__c c: lstResult) {
						swxLineItemList.add(c);
					}
				} 
			}catch (Exception ex) {ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_SWCatalague,CSWXGlobalConstant.getFeature);
								   return null;
								  }
			
			for(SWx_Upsell_Items__c dbItemObj : swxLineItemList){
				swxId.add(dbItemObj.SWx_Product_Code__c);
			}
			
			
			List<Product_Feature_Junction__c> productFeatureJunctionList = [SELECT ID,NAME,Product_Code__c,Product__r.Name,Product_Feature__c,Product_Feature__r.Description__c FROM Product_Feature_Junction__c WHERE Product_Code__c IN :swxId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			
			
			Map<String, List<Product_Feature_Junction__c>> productCodeToPFJObjNameMap = new  Map<String,List<Product_Feature_Junction__c>>();
			
			for (Product_Feature_Junction__c productFeatureJunctionObj : productFeatureJunctionList) { 
				if (productCodeToPFJObjNameMap.containsKey(productFeatureJunctionObj.Product_Code__c)) {
					productCodeToPFJObjNameMap.get(productFeatureJunctionObj.Product_Code__c).add(productFeatureJunctionObj);
				} 
				else {
					productCodeToPFJObjNameMap.put(productFeatureJunctionObj.Product_Code__c, new List<Product_Feature_Junction__c>{ productFeatureJunctionObj });
				}
			} 
			
			
			
			
			List<wrapperClass> wrpclasslist = new List<wrapperClass>();
			
			for(SWx_Upsell_Items__c dbItemObj : swxLineItemList){
				
				if(productCodeToPFJObjNameMap.containskey(dbItemObj.SWx_Product_Code__c)){
					for(Product_Feature_Junction__c productFeatureJunctionObj : productCodeToPFJObjNameMap.get(dbItemObj.SWx_Product_Code__c)){
						
						wrapperClass wrpclass = new wrapperClass();
						wrpclass.statusInNetWork=dbItemObj.Status_In_Network__c;
						wrpclass.productName= productFeatureJunctionObj.Product__r.Name;
						wrpclass.productCode=productFeatureJunctionObj.Product_Code__c;
						wrpclass.featureDescription=productFeatureJunctionObj.Product_Feature__r.Description__c ;
						wrpclass.dpId = dbItemObj.SWx_Upsell_Proposal__r.Name;
						wrpclass.acceptanceInitiation=dbItemObj.Acceptance_Initiation__c;
						wrpclass.deliveryExecution=dbItemObj.Delivery_Execution__c;
						wrpclass.acceptanceOfDelivery=dbItemObj.Acceptance_of_Delivery__c;
						wrpclass.agreement=dbItemObj.SWx_Upsell_Proposal__r.Agreement_Number__c;
						wrpclass.agreementName=dbItemObj.SWx_Upsell_Proposal__r.Frame_Contract__r.Name;
						wrpclass.po=dbItemObj.SWx_Upsell_Proposal__r.PO__r.Name ; 
						wrpclass.technology=dbItemObj.SWx_Upsell_Proposal__r.Technology__c;
						wrpclass.usecase=dbItemObj.SWx_Upsell_Proposal__r.Use_Case__c;
						wrpclass.dP_Id =dbItemObj.SWx_Upsell_Proposal__c;
						wrpclasslist.add(wrpclass);
						
						
					}
				}else{
					wrapperClass wrpclass = new wrapperClass();
					wrpclass.statusInNetWork=dbItemObj.Status_In_Network__c;
					wrpclass.productName= dbItemObj.Product_Name__c;
					wrpclass.productCode=dbItemObj.SWx_Product_Code__c;
					
					wrpclass.dpId = dbItemObj.SWx_Upsell_Proposal__r.Name;
					wrpclass.acceptanceInitiation=dbItemObj.Acceptance_Initiation__c;
					wrpclass.deliveryExecution=dbItemObj.Delivery_Execution__c;
					wrpclass.acceptanceOfDelivery=dbItemObj.Acceptance_of_Delivery__c;
					wrpclass.agreement=dbItemObj.SWx_Upsell_Proposal__r.Agreement_Number__c;
					wrpclass.agreementName=dbItemObj.SWx_Upsell_Proposal__r.Frame_Contract__r.Name;
					wrpclass.po=dbItemObj.SWx_Upsell_Proposal__r.PO__r.Name ; 
					wrpclass.technology=dbItemObj.SWx_Upsell_Proposal__r.Technology__c;
					wrpclass.usecase=dbItemObj.SWx_Upsell_Proposal__r.Use_Case__c;
					wrpclass.dP_Id =dbItemObj.SWx_Upsell_Proposal__c;
					wrpclasslist.add(wrpclass); 
					
				}
			}
			return wrpclasslist;
			
		}catch (Exception ex) { ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_ContractOverview ,CSWXGlobalConstant.getPO);
							   return null;
							  }  
	}
	
	/******************************
*Method Name: getTechnologies
*Description: This Method is used to get technology and use case values from the object.

********************************/	
	@AuraEnabled
	public static List<String> getTechnologies() {
		try{
			List<String>  objResults = new List<String>();
			objResults.add(CSWXGlobalConstant.NONE_OPTION_VALUE);
			List<String> subList = DS_Util.getTechnologiesForLC();
			
			
			objResults.addAll(subList);
			return objResults;
		}
		catch(Exception ex){
			ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_ContractOverview, CSWXGlobalConstant.getTechnologies);
			return NULL;  
		}
		
	}
	
	
	/******************************
*Method Name: getUseCaseOnTechnology
*Description: This Method is used to get technology and use case values from the object.

********************************/	
	
	@AuraEnabled
	public static List<String> getUseCaseOnTechnology(String selectedTechnology) {
		try{  
			List<String>  objResults = new List<String>();
			objResults.add(CSWXGlobalConstant.NONE_OPTION_VALUE);
			if(selectedTechnology == CSWXGlobalConstant.NONE_OPTION_VALUE) {
				
			}	  
			else {
				List<String> subList = DS_Util.getUseCaseOnTechnologyForLC(selectedTechnology);
				objResults.addAll(subList);
			}
			
			return objResults;
			
		}
		
		catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_ContractOverview, CSWXGlobalConstant.getUseCaseOnTechnology);
							return NULL;  
						   }
	} 
	
}