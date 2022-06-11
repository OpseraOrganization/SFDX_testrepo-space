/*******************************
	Created by: Accenture
	Description: This helper is written for the Trigger of CPO Object
	Team: Digital Sales 
	*******************************/
	public  without sharing Class CPOTriggerHelper {
		Public static integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows();   
	/******************************************************************************************************
		Name : shareCSMandCDMwithCustomer
		Description : This method is used to validate if all the mandatory fields on CPO are filled or not
		Parameter : List of CurrentRecord ids
		*********************************************************************************************************/
			public static void shareCSMandCDMwithCustomer(List<Apttus_Config2__CustomerPurchaseOrder__c > cpoNewList){
	System.debug('cpoNewList[0].createdById-->'+cpoNewList[0].createdById);
	List<UserShare> usershare = new List<UserShare>();
	 try{
	
	for(Apttus_Config2__CustomerPurchaseOrder__c  cpoObj : cpoNewList){
		
			
			UserShare usershareCSM = new UserShare();
			usershareCSM.UserAccessLevel = 'Read';
			usershareCSM.UserId = cpoObj.OwnerId;
			usershareCSM.UserOrGroupId=cpoObj.createdById;
			usershare.add(usershareCSM);
			
			UserShare usershareCDM = new UserShare();
			usershareCDM.UserAccessLevel = 'Read';
			usershareCDM.UserId = cpoObj.DS_CDM__c;
			usershareCDM.UserOrGroupId=cpoObj.createdById;
			usershare.add(usershareCDM);
			
	   }
	  insert usershare;
	  }catch(Exception ex) {ExceptionHandler.addException(ex,CSWXGlobalConstant.CPOTriggerHelper,CSWXGlobalConstant.createEntitlementmethod);}   
			
			} 
			/******************************************************************************************************
		Name : checkMandatoryFields
		Description : This method is used to validate if all the mandatory fields on CPO are filled or not
		Parameter : List of CurrentRecord ids
		*********************************************************************************************************/
			public static void checkMandatoryFields(List<Apttus_Config2__CustomerPurchaseOrder__c > cpoNewList){
			try{
	List<String> cpoId = new List<String>();
	
	String cpoStatusRecord;
	
	for(Apttus_Config2__CustomerPurchaseOrder__c cpo:cpoNewList){
		cpoStatusRecord = cpo.Apttus_Config2__Status__c;
		cpoId.add(cpo.Id);
	}
		
	//method call to get list of mandatory fields from Custom setting
	String cpoFields = getCPOFields(cpoStatusRecord);
	
	if(!String.isBlank(cpoFields)){
		List<String> fieldlist = cpoFields.split(CSWXGlobalConstant.comma);
		List<String> allBypassFields = new List<String>();
		system.debug('fieldlist>>>>>>>>>>'+fieldlist);
		
		List<DS_Legacy_CPO_MandatoryCheckBypass__c> legacyBypassFields = DS_Legacy_CPO_MandatoryCheckBypass__c.getall().values();
		
		for(DS_Legacy_CPO_MandatoryCheckBypass__c bypadField : legacyBypassFields){
			allBypassFields.add(bypadField.name);
		}
		
		 system.debug('allBypassFields>>>>>>>>>>'+allBypassFields);
		
		String missingFieldsLabels = CSWXGlobalConstant.EMPTY_STRING;
		
		if(!cpoNewList.isEmpty()){
			//Below for loop iterate through the CPO result and checks for the empty values for the Required fields. 
			for (Apttus_Config2__CustomerPurchaseOrder__c cpo: cpoNewList) {
				for(String item : fieldlist) {
		  // if(!(cpo.Legacy_CPO__c == true && (item.equalsIgnoreCase(CSWXGlobalConstant.Quote_ProposalField) || item.equalsIgnoreCase(CSWXGlobalConstant.Opportunityfield)||item.equalsIgnoreCase(CSWXGlobalConstant.AgreementField)))){
		if(!(cpo.Legacy_CPO__c == true && allBypassFields.contains(item))){
		system.debug('item>>>>>'+item);
		if(cpo.get(item)==null){
			missingFieldsLabels = missingFieldsLabels + Schema.getGlobalDescribe().get(CSWXGlobalConstant.CPOObject).getDescribe().fields.getMap().get(item).getDescribe().getLabel() + CSWXGlobalConstant.comma;
			
		}
		if(cpo.get(item)==false){
			missingFieldsLabels = missingFieldsLabels + Schema.getGlobalDescribe().get(CSWXGlobalConstant.CPOObject).getDescribe().fields.getMap().get(item).getDescribe().getLabel() + CSWXGlobalConstant.comma;
		}
				}
				}		
				system.debug('missingFieldsLabels>>>>'+missingFieldsLabels);
				missingFieldsLabels= missingFieldsLabels.removeEnd(CSWXGlobalConstant.comma);
				if(missingFieldsLabels!=CSWXGlobalConstant.EMPTY_STRING){
		  cpo.addError('Please fill Mandatory Fields: '+missingFieldsLabels);
				}
			}
		
		}
	}
	  } catch (Exception ex) {ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_CPOValidity_Check,CSWXGlobalConstant.checkMandatoryFields);} 
	
			}
			
			
			
	 /* public static void updateCPO(String missingFieldsLabels, List<String> cpoId){
	//Apttus_Config2__CustomerPurchaseOrder__c cpoUpdate =[Select Id, Apttus_QPConfig__ProposalId__c from Apttus_Config2__CustomerPurchaseOrder__c where id in: cpoId];
	//system.debug('cpoUpdate>>>>>>'+cpoUpdate);
	
	//Apttus_Proposal__Proposal__c quo = [Select Id, Missing_Fields_CPO__c from Apttus_Proposal__Proposal__c where Id=: cpoUpdate.Apttus_QPConfig__ProposalId__c];
	
	//quo.Missing_Fields_CPO__c = missingFieldsLabels;
	//system.debug('quo.Missing_Fields_CPO__c>>>>>>>'+ quo.Missing_Fields_CPO__c);
	//update(quo);
	
	//cpoUpdate.Mandatory_Fields__c = missingFieldsLabels;
	//update(cpoUpdate);
			}
			*/
			/* Method to get CPO fields */
			public static String getCPOFields(String cpoStatusRecord){
	try{
		
		system.debug('cpoStatusRecord>>>>>>>'+cpoStatusRecord);
		String cpo_mandfields=CSWXGlobalConstant.EMPTY_STRING;
		
		for(DS_CPO_validation__c csObj : [Select Name, CPO_Status__c, CPO_MandatoryFields__c, CPO_Mandatory_Fields2__c, CPO_Mandatory_Fields3__c from DS_CPO_validation__c where Name!=Null AND CPO_Status__c =:cpoStatusRecord LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())] ){
			system.debug('csObj.CPO_Status__c>>>>>>>>>>>'+csObj.CPO_Status__c); 
			system.debug('csObj.CPO_Mandatory_Fields3__c>>>>>>>>>>>'+csObj.CPO_Mandatory_Fields3__c); 
			if(csObj.CPO_Mandatory_Fields3__c!=null){
				cpo_mandfields = CSWXGlobalConstant.CPOStatus+ csObj.CPO_MandatoryFields__c + CSWXGlobalConstant.comma + csObj.CPO_Mandatory_Fields2__c + CSWXGlobalConstant.comma + csObj.CPO_Mandatory_Fields3__c;
			}else{
				cpo_mandfields = CSWXGlobalConstant.CPOStatus+ csObj.CPO_MandatoryFields__c + CSWXGlobalConstant.comma + csObj.CPO_Mandatory_Fields2__c;
			}
			
		}
		system.debug('cpo_mandfields>>>>>>>>>'+cpo_mandfields);
		
		return cpo_mandfields;
	}catch (Exception ex) {ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_CPOValidity_Check,CSWXGlobalConstant.getCPOFields);} 
	return null;
			}
			/* Method to update CPO owner  */
	 /* 
			public static void updateCPOOwner(List<Apttus_Config2__CustomerPurchaseOrder__c > cpoList){
	try{
	Set<id> accountRecordIdSet = new Set<id>();
	for(Apttus_Config2__CustomerPurchaseOrder__c  cpo: cpoList){
		accountRecordIdSet.add(cpo.Apttus_Config2__AccountId__c);
	}
	 //  Map<String,String> accountIDToCSMMap = new Map<String,String>();
	  // accountIDToCSMMap=getCSM(accountRecordIdSet); 
	  // 
	CPO_CSMCDM CPO_CSMCDMobj = getCSMandCDM(accountRecordIdSet);  
	
	System.debug('CPO_CSMCDMobj --->'+CPO_CSMCDMobj);
	  
	
	 Map<String,String> accountIDToCSMMap = CPO_CSMCDMobj.accountIDTOCSM;
	 
	 Map<String,String> accountIDToCDMMap = CPO_CSMCDMobj.accountIDTOCDM; 
	  System.debug('accountIDToCSMMap --->'+accountIDToCSMMap);
	System.debug('accountIDToCDMMap--->'+accountIDToCDMMap);
	System.debug('cpoList--->'+cpoList);
	 
	for(Apttus_Config2__CustomerPurchaseOrder__c  cpo: cpoList){
		System.debug('cpo.Apttus_Config2__AccountId__c--->'+cpo.Apttus_Config2__AccountId__c);
		System.debug('accountIDToCSMMap.get(cpo.Apttus_Config2__AccountId__c)--->'+accountIDToCSMMap.get(cpo.Apttus_Config2__AccountId__c));
		if(accountIDToCSMMap.get(cpo.Apttus_Config2__AccountId__c)!=CSWXGlobalConstant.nullValue){
			System.debug('accountIDToCSMMap.get(cpo.Apttus_Config2__AccountId__c)--118->'+accountIDToCSMMap.get(cpo.Apttus_Config2__AccountId__c));
			cpo.OwnerID =accountIDToCSMMap.get(cpo.Apttus_Config2__AccountId__c);
			if(accountIDToCDMMap.get(cpo.Apttus_Config2__AccountId__c)!=CSWXGlobalConstant.nullValue){
		//System.debug('accountIDToCSMMap.get(cpo.Apttus_Config2__AccountId__c)--->'+accountIDToCSMMap.get(cpo.Apttus_Config2__AccountId__c));
			cpo.DS_CDM__c =accountIDToCDMMap.get(cpo.Apttus_Config2__AccountId__c);
		}else{
			cpo.DS_CDM__c =accountIDToCSMMap.get(cpo.Apttus_Config2__AccountId__c);
		}
		}
	}
	  }catch (Exception ex) {ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_CPOValidity_Check,CSWXGlobalConstant.updateCPOOwner);} 
			}
			
			/*Method to get CSM user 
			
			public static CPO_CSMCDM  getCSMandCDM(Set<ID> accountIDSet){
			try{
	Map<String,String> accountIDToTerritoryIDMap = new Map<String,String>();
	Map<String,String> accountIDToCSMMap = new Map<String,String>();
	Map<String,String> accountIDToCDMMap = new Map<String,String>();
	Map<String,List<String>> TerritoryIDToUserMap = new Map<String,List<String>>();
	Map<String,List<String>> accountIDToUserMap = new Map<String,List<String>>();
	
	  // List<ObjectTerritory2Association> ObjectTerritory2AssociationList = [select id, Territory2Id, Territory2.name, SobjectType, ObjectId, AssociationCause from ObjectTerritory2Association where ObjectId IN :accountIDSet];
	Set<Id> userIDSet = new Set<Id>(); 
		
	for(ObjectTerritory2Association objRec : [select id, Territory2Id, Territory2.name, SobjectType, ObjectId, AssociationCause from ObjectTerritory2Association where ObjectId IN :accountIDSet LIMIT:limitRows ]){	//Create Map<Account ID,Territory> to get User associate with territory
		accountIDToTerritoryIDMap.put(objRec.ObjectId,objRec.Territory2.name);
	}
	   
	List<Sales_Role__c> salesRoleList = [SELECT ID,Organisation__c,User__c,Role_Name__c,BG__c  FROM Sales_Role__c WHERE Organisation__c IN:accountIDToTerritoryIDMap.values() LIMIT:limitRows];			
		
	System.debug('salesRoleList-->'+salesRoleList);
		
		
		
		for(String accID : accountIDToTerritoryIDMap.keySet()){	 //Create Map<AccountID,CSM> and Map<AccountID,CDM>
			String territoryName = accountIDToTerritoryIDMap.get(accID);
			Boolean isBGCheck = false;
			
			accountIDToCSMMap.put(accID,CSWXGlobalConstant.nullValue);
			accountIDToCDMMap.put(accID,CSWXGlobalConstant.nullValue);
			
			for(Sales_Role__c SalesRoleObj : salesRoleList){ 
		 System.debug('SalesRoleObj ------>'+SalesRoleObj.Id);
		 System.debug('SalesRoleObj.Organisation__c ------>'+SalesRoleObj.Organisation__c);
		 System.debug('SalesRoleObj.BG__c ------>'+SalesRoleObj.BG__c);
		 System.debug('SalesRoleObj.Role_Name__c ------>'+SalesRoleObj.Role_Name__c);
				
				
				if(SalesRoleObj.Role_Name__c == Label.DS_CSM_Role_Name && SalesRoleObj.Organisation__c==territoryName){
		System.debug('SalesRoleObj ------>'+SalesRoleObj.Id);
		System.debug('SalesRoleObj.User__CSM----->'+SalesRoleObj.User__c);
		accountIDToCSMMap.put(accID,SalesRoleObj.User__c);
				}
		if(SalesRoleObj.Role_Name__c == Label.DS_CDM_Role_Name && SalesRoleObj.Organisation__c==territoryName && isBGCheck!=true && SalesRoleObj.BG__c == CSWXGlobalConstant.MN){
		System.debug('SalesRoleObj.User__cMN----->'+SalesRoleObj.User__c);
		accountIDToCDMMap.put(accID,SalesRoleObj.User__c); 
		 isBGCheck = true;
		
				}else{
				//else if(SalesRoleObj.Role_Name__c == Label.DS_CDM_Role_Name && SalesRoleObj.Organisation__c==territoryName && isBGCheck!=true) {
		System.debug('SalesRoleObj.User__cwoMN----->'+SalesRoleObj.User__c);
		accountIDToCDMMap.put(accID,SalesRoleObj.User__c);
		  
		
				}
		
			}
			
			
		}
		
		System.debug('accountIDToCSMMap --->'+accountIDToCSMMap);
		System.debug('accountIDToCDMMap--->'+accountIDToCDMMap);
		System.debug('accountIDToCSMMap--->'+accountIDToCSMMap);
		
		CPO_CSMCDM CPO_CSMCDMRecObj = new CPO_CSMCDM();
		CPO_CSMCDMRecObj.accountIDTOCSM = accountIDToCSMMap;
		CPO_CSMCDMRecObj.accountIDTOCDM = accountIDToCDMMap;
		return CPO_CSMCDMRecObj;
	   
		
		
	   // return accountIDToCSMMap;
	}catch (Exception ex) {ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_CPOValidity_Check,CSWXGlobalConstant.getCSMandCDM); 
		return null;
	}
	
			}*/
			
			/******************************************************************************************************
		Method Name : createEntitlement
		Description : This method is used to create commercial entitlement records 
		Parameter : List of CurrentRecord ids	
		*********************************************************************************************************/ 
			public static void createEntitlement(List<Apttus_Config2__CustomerPurchaseOrder__c> cpoList) {
			try{
	
	List <Apttus_Config2__CustomerPOItem__c> cpoLineItemList = [Select Id,Apttus_QPConfig__ProposalLineItemId__c,SI_Product_Code__c,SI_Product_ID__c,Configuration_Type__c,Line_Type__c,Name, Commercial_Entitlement__c, Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c,Apttus_Config2__ProductId__c, Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__PurchaseOrderId__r.Sold_to_party__r.ParentId, Apttus_Config2__StartDate__c,Apttus_Config2__EndDate__c, Apttus_Config2__Quantity__c,Apttus_Config2__PurchaseOrderId__c from Apttus_Config2__CustomerPOItem__c where Apttus_Config2__PurchaseOrderId__c in : cpoList  LIMIT:limitRows];
	Map<Id,List<Apttus_Config2__CustomerPOItem__c>> CPOOnCpoLineitemMap =new Map<Id,List<Apttus_Config2__CustomerPOItem__c>>();
	
	//Below code associate the CPO Line item associated to the CPO.
	Map<String,List<Apttus_Config2__CustomerPOItem__c>> soldToPartyProductCodeCPOLIMap =  new Map<String,List<Apttus_Config2__CustomerPOItem__c>>();
	Map<String,Commercial_Entitlement__c> commercialEntitlementMap = new Map<String,Commercial_Entitlement__c>();
	
	Set<String> ProductCodeIDSet = new Set<String>(); //Thsi will be used for querying the entitlement.
	Set<ID> soldToPartyIDSet = new Set<Id>(); //This is also used for filterig the entitlement.
	Map<String,Date> startDateMap = new Map<String,Date>();
	Map<String,Date> endDateMap = new Map<String,Date>();
	Set<Id> productIDSet = new Set<Id>();
	Map<String,Product2> PcodeProdMap = new Map<String,Product2>();
	
	Set<String> optionProdSet = new Set<String>();
	//D-17172-start
	System.debug('cpoLineItemList--->'+cpoLineItemList);
	for(Apttus_Config2__CustomerPOItem__c cporecList: cpoLineItemList ) {
		if(cporecList.Line_Type__c ==CSWXGlobalConstant.Option)  {
			optionProdSet.add(cporecList.SI_Product_Code__c);
		
		
		}
	
	
	}
	
	for(Product2 Prod : [select id,ProductCode from product2 where ProductCode in:optionProdSet LIMIT:limitRows]){
		PcodeProdMap.put(Prod.ProductCode,prod);
	}
	
	  
	Map<String,String> productTechnologyMap = new Map<String,String>();
	Map<String,String> productUseCaseMap = new Map<String,String>();
	for(Apttus_Config2__CustomerPOItem__c objItem : cpoLineItemList ) {
	  String keyVal;
	  
		if(objItem.Line_Type__c ==CSWXGlobalConstant.Option && objItem.Configuration_Type__c !=CSWXGlobalConstant.Bundle)  {
		 
		
		// ProductCodeIDSet.add(PcodeProdMap.get(objItem.SI_Product_Code__c).id);
		 ProductCodeIDSet.add(objItem.SI_Product_Code__c);
		 keyVal = objItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+CSWXGlobalConstant.dash+objItem.SI_Product_Code__c;
			
		
		}
		else if((objItem.Line_Type__c ==CSWXGlobalConstant.ProductService  && objItem.Configuration_Type__c==CSWXGlobalConstant.Standalone ) || (objItem.Apttus_QPConfig__ProposalLineItemId__c == null )){ 
		
		 ProductCodeIDSet.add(objItem.Apttus_Config2__ProductId__r.ProductCode);
		 keyVal = objItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+CSWXGlobalConstant.dash+objItem.Apttus_Config2__ProductId__r.ProductCode;
			
		
		}
		
		
		soldToPartyIDSet.add(objItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c);
		productIDSet.add(objItem.Apttus_Config2__ProductId__c);
	   // String keyVal = objItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+CSWXGlobalConstant.dash+objItem.Apttus_Config2__ProductId__r.ProductCode;
		//Below code will calculate the min of Start Date.
		if(startDateMap.containsKey(keyVal)) {
			DateTime existingStartDateValue  = startDateMap.get(keyVal);
			if (existingStartDateValue > objItem.Apttus_Config2__StartDate__c) {
				startDateMap.put(keyVal,objItem.Apttus_Config2__StartDate__c);
			}
		}
		else {
			startDateMap.put(keyVal,objItem.Apttus_Config2__StartDate__c);
		}
		
		//Below code will calculate the Max of End Date.
		if(endDateMap.containsKey(keyVal)) {
			DateTime existingEndDateValue  = endDateMap.get(keyVal);
			if (objItem.Apttus_Config2__EndDate__c > existingEndDateValue ) {
				endDateMap.put(keyVal,objItem.Apttus_Config2__EndDate__c);
			}
		}
		else{
			endDateMap.put(keyVal,objItem.Apttus_Config2__EndDate__c);
		}
		
		
		
		//Below code will calculate the CPO Line item map.
		if(CPOOnCpoLineitemMap.containsKey(objItem.Apttus_Config2__PurchaseOrderId__c)) {
			List<Apttus_Config2__CustomerPOItem__c> existingPOItem = CPOOnCpoLineitemMap.get(objItem.Apttus_Config2__PurchaseOrderId__c);
			existingPOItem.add(objItem);
			CPOOnCpoLineitemMap.put(objItem.Apttus_Config2__PurchaseOrderId__c,existingPOItem );
		}
		else {
			List<Apttus_Config2__CustomerPOItem__c> newPOItemList = new List<Apttus_Config2__CustomerPOItem__c>();
			newPOItemList.add(objItem);
			CPOOnCpoLineitemMap.put(objItem.Apttus_Config2__PurchaseOrderId__c,newPOItemList );
			
		}
		
		//This will for the Solod to party map by keeping Product code ,SoldTopary and CPOLI Id as key.
		if(objItem.Line_Type__c ==CSWXGlobalConstant.Option && objItem.Configuration_Type__c !=CSWXGlobalConstant.Bundle )  {
		
			if(!soldToPartyProductCodeCPOLIMap.containsKey(objItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+CSWXGlobalConstant.dash+objItem.SI_Product_Code__c)){
				List<Apttus_Config2__CustomerPOItem__c> cpoLIList = new List<Apttus_Config2__CustomerPOItem__c>();
				cpoLIList.add(objItem);
				soldToPartyProductCodeCPOLIMap.put(objItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+CSWXGlobalConstant.dash+objItem.SI_Product_Code__c,cpoLIList);
			}
			else {
				List<Apttus_Config2__CustomerPOItem__c> cpoLIList = soldToPartyProductCodeCPOLIMap.get(objItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+CSWXGlobalConstant.dash+objItem.SI_Product_Code__c);
				cpoLIList.add(objItem);
				soldToPartyProductCodeCPOLIMap.put(objItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+CSWXGlobalConstant.dash+objItem.SI_Product_Code__c,cpoLIList);
			}
		
		
		}
		
		if((objItem.Line_Type__c ==CSWXGlobalConstant.ProductService  && objItem.Configuration_Type__c==CSWXGlobalConstant.Standalone)|| (objItem.Apttus_QPConfig__ProposalLineItemId__c == null )){ 
			if(!soldToPartyProductCodeCPOLIMap.containsKey(objItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+CSWXGlobalConstant.dash+objItem.Apttus_Config2__ProductId__r.ProductCode)){
				List<Apttus_Config2__CustomerPOItem__c> cpoLIList = new List<Apttus_Config2__CustomerPOItem__c>();
				cpoLIList.add(objItem);
				soldToPartyProductCodeCPOLIMap.put(objItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+CSWXGlobalConstant.dash+objItem.Apttus_Config2__ProductId__r.ProductCode,cpoLIList);
			}
			else {
				List<Apttus_Config2__CustomerPOItem__c> cpoLIList = soldToPartyProductCodeCPOLIMap.get(objItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+CSWXGlobalConstant.dash+objItem.Apttus_Config2__ProductId__r.ProductCode);
				cpoLIList.add(objItem);
				soldToPartyProductCodeCPOLIMap.put(objItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+CSWXGlobalConstant.dash+objItem.Apttus_Config2__ProductId__r.ProductCode,cpoLIList);
			}
		
		}
	  
	}
	
	
	  // List<Apttus_Config2__ProductClassification__c>prodClassificationList = [Select   Name, Apttus_Config2__ClassificationId__r.Apttus_Config2__HierarchyId__r.Name, Apttus_Config2__ProductId__c,Apttus_Config2__ClassificationId__r.Apttus_Config2__Level__c, Apttus_Config2__ClassificationId__r.Apttus_Config2__Label__c, Apttus_Config2__ClassificationId__r.Apttus_Config2__AncestorId__r.Name,Apttus_Config2__ClassificationId__r.Apttus_Config2__HierarchyId__c from Apttus_Config2__ProductClassification__c where Apttus_Config2__ProductId__c IN : productIDSet AND Apttus_Config2__ClassificationId__r.Apttus_Config2__HierarchyId__r.Name =: CSWXGlobalConstant.ProductCatalogue] ;
	for(Apttus_Config2__ProductClassification__c prodClassification : [Select   Name, Apttus_Config2__ClassificationId__r.Apttus_Config2__HierarchyId__r.Name, Apttus_Config2__ProductId__c,Apttus_Config2__ClassificationId__r.Apttus_Config2__Level__c, Apttus_Config2__ClassificationId__r.Apttus_Config2__Label__c, Apttus_Config2__ClassificationId__r.Apttus_Config2__AncestorId__r.Name,Apttus_Config2__ClassificationId__r.Apttus_Config2__HierarchyId__c from Apttus_Config2__ProductClassification__c where Apttus_Config2__ProductId__c IN : productIDSet AND Apttus_Config2__ClassificationId__r.Apttus_Config2__HierarchyId__r.Name =: CSWXGlobalConstant.ProductCatalogue  LIMIT:limitRows]){
		
		if(prodClassification.Apttus_Config2__ClassificationId__r.Apttus_Config2__Level__c == 3 )
		{
			 productTechnologyMap.put(prodClassification.Apttus_Config2__ProductId__c, prodClassification.Apttus_Config2__ClassificationId__r.Apttus_Config2__AncestorId__r.Name) ;
			 productUseCaseMap.put(prodClassification.Apttus_Config2__ProductId__c,prodClassification.Apttus_Config2__ClassificationId__r.Apttus_Config2__Label__c); 
		}		 
	}
	
	
	//Below code will form the Eommercial Entitlement Map by keeping sold to party and Product Code as key.
	for(Commercial_Entitlement__c objCommEntitle :[SELECT Id, Name, Product_Name__c, Product_Code__c, Entitlement_Start_Date__c, Entitlement_End_Date__c, Authorised_Quantity__c, Consumed_Quantity__c, Available_Quantity__c, Parent_Account__c, Sold_To_Party__c, Status__c, Pending_Quantity__c FROM Commercial_Entitlement__c where Sold_To_Party__c IN :soldToPartyIDSet and  Product_Code__c IN :ProductCodeIDSet LIMIT :limitRows]) {
		if(!commercialEntitlementMap.containsKey(objCommEntitle.Sold_To_Party__c+CSWXGlobalConstant.dash+objCommEntitle.Product_Code__c)) {
			commercialEntitlementMap.put(objCommEntitle.Sold_To_Party__c+CSWXGlobalConstant.dash+objCommEntitle.Product_Code__c,objCommEntitle);
		}
	}
	
	  
	//Iterate throught the CPOLintemMap and see if entitlement created or not ?
	
	List<Apttus_Config2__CustomerPOItem__c> cpoLineitemListToBeUpdated = new List<Apttus_Config2__CustomerPOItem__c>();
	List<Commercial_Entitlement__c> commercialEntitlementList = new List<Commercial_Entitlement__c>();
	List<Commercial_Entitlement__c> existingEntitlementList = new List<Commercial_Entitlement__c>();
	List<Apttus_Config2__CustomerPOItem__c> cpoLineitemListToBeUpdatedOnEntitlement = new List<Apttus_Config2__CustomerPOItem__c>();
	Set<String> pastStartDateCPOKeySet = new Set<String>();
	Set<String> soldToPartyCPOKeySet = new Set<String>();
	Set<String> ProductCodeCPOKeySet = new Set<String>();
	String entitlementKey;
	for(String key : soldToPartyProductCodeCPOLIMap.keySet()) {
		
		List<Apttus_Config2__CustomerPOItem__c>  objCPOLineItemList = soldToPartyProductCodeCPOLIMap.get(key);
		//If not entitlement associate to CPO Lineitem 
		for(Apttus_Config2__CustomerPOItem__c  objCPOLineItem : objCPOLineItemList) {
		//D-17172-start
		//String entitlementKey;
		
	   
			 if(objCPOLineItem.Line_Type__c == CSWXGlobalConstant.Option  && objCPOLineItem.Configuration_Type__c !=CSWXGlobalConstant.Bundle)  {
		entitlementKey = objCPOLineItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+CSWXGlobalConstant.dash+objCPOLineItem.SI_Product_Code__c;
		
				}
				if((objCPOLineItem.Line_Type__c ==CSWXGlobalConstant.ProductService && objCPOLineItem.Configuration_Type__c==CSWXGlobalConstant.Standalone) ||  (objCPOLineItem.Apttus_QPConfig__ProposalLineItemId__c == null ) ){ 
		 
		entitlementKey = objCPOLineItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+CSWXGlobalConstant.dash+objCPOLineItem.Apttus_Config2__ProductId__r.ProductCode;
				}
		
		//D-17172-end
		 System.debug('entitlementKey--->'+entitlementKey);
			//objCPOLineItem.Apttus_Config2__Status__c = CSWXGlobalConstant.ReadyforExecution;
			objCPOLineItem.Apttus_Config2__Status__c = 'Fully Enriched';
			if(objCPOLineItem.Commercial_Entitlement__c == null) { //CPOLI does not have entitlement associate.
				//Check if entitlement already exist for Product and Sold_To_Party__c . 
				if(commercialEntitlementMap.containsKey(entitlementKey)) { // Commercial entitlement exist or not ? 
		  
		  Commercial_Entitlement__c existingEntitlementRecord = commercialEntitlementMap.get(entitlementKey);
		  
		  if(objCPOLineItem.Apttus_Config2__StartDate__c <=  date.today()) {
			  
			  pastStartDateCPOKeySet.add(entitlementKey);
			  soldToPartyCPOKeySet.add(objCPOLineItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c);
			  if(objCPOLineItem.Line_Type__c ==CSWXGlobalConstant.Option  && objCPOLineItem.Configuration_Type__c !=CSWXGlobalConstant.Bundle)  {
			ProductCodeCPOKeySet.add(PcodeProdMap.get(objCPOLineItem.SI_Product_Code__c).id); 
			
			  }
			  
			if((objCPOLineItem.Line_Type__c ==CSWXGlobalConstant.ProductService && objCPOLineItem.Configuration_Type__c==CSWXGlobalConstant.Standalone) ||  (objCPOLineItem.Apttus_QPConfig__ProposalLineItemId__c == null ) ){ 
			
				ProductCodeCPOKeySet.add(objCPOLineItem.Apttus_Config2__ProductId__c);
			
			}
			  
				
			objCPOLineItem.Commercial_Entitlement_Status__c = CSWXGlobalConstant.entitledValue;
			objCPOLineItem.Authorised_Quantity__c=objCPOLineItem.Apttus_Config2__Quantity__c;
			  //Call batch job map here
			if(existingEntitlementRecord.Authorised_Quantity__c != null)
			 existingEntitlementRecord.Authorised_Quantity__c = existingEntitlementRecord.Authorised_Quantity__c + objCPOLineItem.Apttus_Config2__Quantity__c;	  //Added because rollup is not possible on managed package
			else 
			 existingEntitlementRecord.Authorised_Quantity__c = objCPOLineItem.Apttus_Config2__Quantity__c;  
					
		  }
		  else{
			  
			objCPOLineItem.Commercial_Entitlement_Status__c = CSWXGlobalConstant.pendingValue;
			objCPOLineItem.Pending_Quantity__c = objCPOLineItem.Apttus_Config2__Quantity__c;
			if(existingEntitlementRecord.Pending_Quantity__c != null)
			 existingEntitlementRecord.Pending_Quantity__c = existingEntitlementRecord.Pending_Quantity__c + objCPOLineItem.Apttus_Config2__Quantity__c;	  //Added because rollup is not possible on managed package
			else 
			 existingEntitlementRecord.Pending_Quantity__c = objCPOLineItem.Pending_Quantity__c;  
			  // existingEntitlementRecord.Pending_Quantity__c = existingEntitlementRecord.Pending_Quantity__c != null ? existingEntitlementRecord.Pending_Quantity__c : 0 + objCPOLineItem.Apttus_Config2__Quantity__c;		//Added because rollup is not possible on managed package
			}
		   
		   if(objCPOLineItem.Apttus_Config2__EndDate__c > commercialEntitlementMap.get(entitlementKey).Entitlement_End_Date__c){
			existingEntitlementRecord.Entitlement_End_Date__c = objCPOLineItem.Apttus_Config2__EndDate__c;
			}
		
		//Additional Logic to update CPO Line Item Fields.
		cpoLineitemListToBeUpdated.add(objCPOLineItem);
		commercialEntitlementMap.put(entitlementKey,existingEntitlementRecord);
				}
				else {
		
		//Create a new Entitlement Record. 
		Commercial_Entitlement__c objEntitlement = new Commercial_Entitlement__c();
		 //D-17172-start  
		 String keyVal;
		if(objCPOLineItem.Line_Type__c ==CSWXGlobalConstant.Option && objCPOLineItem.Configuration_Type__c !=CSWXGlobalConstant.Bundle)  {
		
			keyVal = objCPOLineItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+CSWXGlobalConstant.dash+objCPOLineItem.SI_Product_Code__c;
			
			
		   if(objCPOLineItem.SI_Product_ID__c != null){
				objEntitlement.Product_Name__c  = PcodeProdMap.get(objCPOLineItem.SI_Product_ID__c).id;///objCPOLineItem.Apttus_Config2__ProductId__c;   
			}
			else if(objCPOLineItem.SI_Product_Code__c != null){
			objEntitlement.Product_Name__c  = PcodeProdMap.get(objCPOLineItem.SI_Product_Code__c).id;///objCPOLineItem.Apttus_Config2__ProductId__c;   
			  }		
		
			}
		 if((objCPOLineItem.Line_Type__c ==CSWXGlobalConstant.ProductService  && objCPOLineItem.Configuration_Type__c==CSWXGlobalConstant.Standalone) ||  (objCPOLineItem.Apttus_QPConfig__ProposalLineItemId__c == null )){ 
		
		
			keyVal = objCPOLineItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+CSWXGlobalConstant.dash+objCPOLineItem.Apttus_Config2__ProductId__r.ProductCode;
			
			objEntitlement.Product_Name__c  = objCPOLineItem.Apttus_Config2__ProductId__c;
		
		
			}
		objEntitlement.Sold_To_Party__c = objCPOLineItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c;
		objEntitlement.Parent_Account__c = objCPOLineItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__r.ParentId;
		  // objEntitlement.Product_Name__c  = objCPOLineItem.Apttus_Config2__ProductId__c;
		if(productTechnologyMap.containsKey(objCPOLineItem.Apttus_Config2__ProductId__c)) {
			objEntitlement.Technology__c  = productTechnologyMap.get(objCPOLineItem.Apttus_Config2__ProductId__c);
		}
		if(productUseCaseMap.containsKey(objCPOLineItem.Apttus_Config2__ProductId__c)) {
			objEntitlement.Use_Case__c   = productUseCaseMap.get(objCPOLineItem.Apttus_Config2__ProductId__c);
		}
		if(startDateMap.get(keyVal) != null){
			objEntitlement.Entitlement_Start_Date__c = startDateMap.get(keyVal);
			if(startDateMap.get(keyVal) < system.Today() || startDateMap.get(keyVal) == system.Today()){
			 objEntitlement.Status__c = CSWXGlobalConstant.entitledValue;
		}
		else{
			 objEntitlement.Status__c = CSWXGlobalConstant.pendingValue;
		}
		}
		if(endDateMap.get(keyVal) != null)
			objEntitlement.Entitlement_End_Date__c = endDateMap.get(keyVal);
		
		
		if(objCPOLineItem.Apttus_Config2__StartDate__c <=  date.today()) {
			pastStartDateCPOKeySet.add(entitlementKey);
			soldToPartyCPOKeySet.add(objCPOLineItem.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c);
			ProductCodeCPOKeySet.add(objCPOLineItem.Apttus_Config2__ProductId__c);
			objCPOLineItem.Commercial_Entitlement_Status__c = CSWXGlobalConstant.entitledValue;
			objCPOLineItem.Authorised_Quantity__c=objCPOLineItem.Apttus_Config2__Quantity__c;
			objEntitlement.Authorised_Quantity__c = objCPOLineItem.Apttus_Config2__Quantity__c;	//Added because rollup is not possible on managed package
			//call batchjob map here
		}
		else{
		   objCPOLineItem.Commercial_Entitlement_Status__c = CSWXGlobalConstant.pendingValue;
		   objCPOLineItem.Pending_Quantity__c = objCPOLineItem.Apttus_Config2__Quantity__c;
		   objEntitlement.Pending_Quantity__c = objCPOLineItem.Apttus_Config2__Quantity__c;	//Added because rollup is not possible on managed package
		}
		commercialEntitlementMap.put(entitlementKey,objEntitlement);
		cpoLineitemListToBeUpdated.add(objCPOLineItem);		
				}
			}
		}
	}
	if(!commercialEntitlementMap.isEmpty()) {
		database.upsert(commercialEntitlementMap.values());
	  }
	
	if(!cpoLineitemListToBeUpdated.isEmpty()) {
		database.update (cpoLineitemListToBeUpdated);
		database.update(existingEntitlementList);
	}
	 Map<id,Apttus_Config2__CustomerPOItem__c> CPOItemMap = new Map<id,Apttus_Config2__CustomerPOItem__c>();
	if(! commercialEntitlementMap.isEmpty()) {
		
		List<Id> entitlementIds = new List<Id>(new Map<Id, Commercial_Entitlement__c>(commercialEntitlementMap.values()).keySet());
		Map<String,Commercial_Entitlement__c> newCELMap = new Map<String,Commercial_Entitlement__c> ();
		
		for( Commercial_Entitlement__c objEntitlement :  [Select Id,Product_Code__c,Sold_to_party__c from Commercial_Entitlement__c where Id in :entitlementIds  LIMIT:limitRows] ) {
			String key = objEntitlement.Sold_to_party__c + CSWXGlobalConstant.dash + objEntitlement.Product_Code__c;
		if(!newCELMap.containsKey(key)) {
		 newCELMap.put(key,objEntitlement);
		}
			
		}
		
		for(String key : soldToPartyProductCodeCPOLIMap.keySet()) {
			
			for( Apttus_Config2__CustomerPOItem__c objCPOLI : soldToPartyProductCodeCPOLIMap.get(key)) {
		
				//D-17172-start
				String keyEntitlement;
				
				
		if(objCPOLI.Line_Type__c ==CSWXGlobalConstant.Option && objCPOLI.Configuration_Type__c !=CSWXGlobalConstant.Bundle)  {
		
			keyEntitlement = objCPOLI.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+CSWXGlobalConstant.dash+objCPOLI.SI_Product_Code__c;
		}
		if((objCPOLI.Line_Type__c ==CSWXGlobalConstant.ProductService && objCPOLI.Configuration_Type__c==CSWXGlobalConstant.Standalone)||(objCPOLI.Apttus_QPConfig__ProposalLineItemId__c == null )){ 
		
		
			keyEntitlement = objCPOLI.Apttus_Config2__PurchaseOrderId__r.Sold_to_party__c+CSWXGlobalConstant.dash+objCPOLI.Apttus_Config2__ProductId__r.ProductCode;
		  
		
		}
		
		//D-17172-end
				
				if(newCELMap.containsKey(keyEntitlement)) {
		objCPOLI.Commercial_Entitlement__c =  newCELMap.get(keyEntitlement).Id;
		cpoLineitemListToBeUpdatedOnEntitlement.add(objCPOLI);
		CPOItemMap.put(objCPOLI.id,objCPOLI);
		
				}
			}
		}
	}
			
	//Below code is used for updating the CPO LineItem after entitlement creation.
	System.debug('CPOItemMap--->'+CPOItemMap);
	  if(!CPOItemMap.isEmpty()) {
		update CPOItemMap.values();
	} 
	
	  
	  //Below code is used to call batch job
	Map<String, Commercial_Entitlement__c> commercialEntitlementMapforBatch = new Map<String, Commercial_Entitlement__c> ();
	Map<String, Commercial_Entitlement__c> commercialEntitlementMapforBatch2 = new Map<String, Commercial_Entitlement__c> ();
	if(!soldToPartyCPOKeySet.isEmpty() && !ProductCodeCPOKeySet.isEmpty()) {
			//Below code will form the Eommercial Entitlement Map by keeping sold to party and Product Code as key.
			for(Commercial_Entitlement__c objCommEntitle :[SELECT Id, Name, Product_Name__c, Product_Code__c, Entitlement_Start_Date__c, Entitlement_End_Date__c, Authorised_Quantity__c, Consumed_Quantity__c, Available_Quantity__c, Parent_Account__c, Sold_To_Party__c, Status__c, Pending_Quantity__c, Non_Consumed_Quantity__c FROM Commercial_Entitlement__c where Sold_To_Party__c IN :soldToPartyCPOKeySet and  Product_Name__c IN :ProductCodeCPOKeySet  LIMIT:limitRows]) {
				if(!commercialEntitlementMapforBatch.containsKey(objCommEntitle.Sold_To_Party__c+CSWXGlobalConstant.dash+objCommEntitle.Product_Code__c)) {
		commercialEntitlementMapforBatch.put(objCommEntitle.Sold_To_Party__c+CSWXGlobalConstant.dash+objCommEntitle.Product_Name__c,objCommEntitle);
		Commercial_Entitlement__c entitlementClone = objCommEntitle.clone();
		commercialEntitlementMapforBatch2.put(entitlementClone.Sold_To_Party__c+CSWXGlobalConstant.dash+entitlementClone.Product_Name__c,entitlementClone );
				}
			}
		
	}
	System.debug('commercialEntitlementMapforBatch***********'+commercialEntitlementMapforBatch);
	if(!commercialEntitlementMapforBatch.isEmpty()) {
		//Call the batch 
		Database.executeBatch(new Batch_DPFulfillment(commercialEntitlementMapforBatch,commercialEntitlementMapforBatch2),100);
	}
	
	
			}catch(Exception ex) {ExceptionHandler.addException(ex,CSWXGlobalConstant.CPOTriggerHelper,CSWXGlobalConstant.createEntitlementmethod);}   
			}
	 
			
		 }