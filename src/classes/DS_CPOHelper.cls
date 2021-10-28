/******************************************************************************************************
Name : DS_CPOHelper
Created Date: 18th October 2018
Created by: Accenture
Description : This class is having  logic to map fields between cpo, agreement and quote.
*********************************************************************************************************/
Public without sharing Class DS_CPOHelper{
 Public static integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows();
	
/******************************************************************************************************
Name : getCPOFields
Created Date: 18th October 2018
Created by: Accenture
Description : This method is used to get Mandatory fields on CPO based on Status from Custom Setting 'DS_CPO_validation__c'. 
Parameter : none
*********************************************************************************************************/
	public static String getQuoteFields(){
		try{
			List<String> agrrmntFieldsList = new List<String>();
			List<String> quoteFieldsList = new List<String>();
			String CPOFields;
			for(DS_CPOMapping__c csObj : [Select Name,Source__c,Object__c from DS_CPOMapping__c LIMIT:limitRows]){
				if(csObj.Object__c == CSWXGlobalConstant.OBJECT_Quotes){
					
					quoteFieldsList.add(csObj.Source__c);
				}
			}
			
			CPOFields = String.join(quoteFieldsList, CSWXGlobalConstant.comma);
			return CPOFields;
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_CPOHelper,CSWXGlobalConstant.getQuoteField);
			return null;
			
		}
	}
	
	/*****************************************************************************************************
Name : getAgreementFields
Created Date: 18th October 2018
Created by: Accenture
Description : This method is used to get Mandatory fields on CPO based on Status from Custom Setting 'DS_CPO_validation__c'. 
Parameter : none
*********************************************************************************************************/
	   public static String getAgreementFields(){
		try{
			List<String> agrrmntFieldsList = new List<String>();
			String CPOFields;
			for(DS_CPOMapping__c csObj : [Select Name,Source__c,Object__c from DS_CPOMapping__c LIMIT :limitRows]){
				if(csObj.Object__c == CSWXGlobalConstant.OBJECT_Agreement){
					agrrmntFieldsList.add(csObj.Source__c);
				}
				
			}
			CPOFields = String.join(agrrmntFieldsList, CSWXGlobalConstant.comma);
			return CPOFields;
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_CPOHelper,CSWXGlobalConstant.getAgreementFields);
			return null;
			
		}
	}
	
	
 /*****************************************************************************************************
Name : getAgreementFields
Created Date: 18th October 2018
Created by: Accenture
Description : This method is used to get Mandatory fields on CPO based on Status from Custom Setting 'DS_CPO_validation__c'. 
Parameter : none
*********************************************************************************************************/
		public static String getQuoteLIFields(){
		try{
			List<String> quoteItemFieldsList = new List<String>();
			String CPOFields;
			for(DS_CPOMapping__c csObj : [Select Name,Source__c,Object__c from DS_CPOMapping__c LIMIT:limitRows]){
				if(csObj.Object__c == CSWXGlobalConstant.OBJECT_QuoteItem ){
					quoteItemFieldsList.add(csObj.Source__c);
				   
				}
			}
			 quoteItemFieldsList.add(CSWXGlobalConstant.OBJECT_Quotes);
			
			CPOFields = String.join(quoteItemFieldsList, CSWXGlobalConstant.comma);
			return CPOFields;
			
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_CPOHelper,CSWXGlobalConstant.getQuoteLIFields);
			return null;
		}
	}
	
	/******************************************************************************************************
Name : DS_CreateCPO
Created Date: 18th October 2018
Created by: Accenture
Description : This method is used to get Mandatory fields on CPO based on Status from Custom Setting 'DS_CPO_validation__c'. 
Parameter : List<Apttus_Proposal__Proposal__c> updatedQuoteList
*********************************************************************************************************/
	public static void DS_CreateCPO(List<Apttus_Proposal__Proposal__c> updatedQuoteList) {
		
		List<Apttus_Config2__CustomerPurchaseOrder__c> cpoList = new List<Apttus_Config2__CustomerPurchaseOrder__c>();
		try{	  
			set<id> CurrentRecordId = new set<id>();
			set<id> accountRecordIdSet = new set<id>();
			set<id> agreementRecordId = new set<id>();
			List<Id>cpoIdList = new List<Id>();
			
			for(Apttus_Proposal__Proposal__c  prop: updatedQuoteList){
				
				if(prop.Apttus_Proposal__Approval_Stage__c == CSWXGlobalConstant.Approval_stage_accepted){
					CurrentRecordId.add(prop.id);
					agreementRecordId.add(prop.Agreement_Lookup__c);
					accountRecordIdSet.add(prop.Apttus_Proposal__Account__c);
				}
				
			}
			
			
			Map<String,String> AccountL7TerritoryMap = new Map<String,String>();

			for(Account objAcc : [SELECT ID,L7Name__c FROM Account WHERE ID IN:accountRecordIdSet]) {
				if(!AccountL7TerritoryMap.containsKey(objAcc.L7Name__c)) {
					AccountL7TerritoryMap.put(objAcc.Id,objAcc.L7Name__c);
				}
			}
			
			
			CPO_CSMCDM CPO_CSMCDMobj = getCSMandCDM(AccountL7TerritoryMap);	  
			Map<String,String> accountIDToCSMMap = CPO_CSMCDMobj.accountIDTOCSM;
			Map<String,String> accountIDToCDMMap = CPO_CSMCDMobj.accountIDTOCDM;  
			
			String cpoFields = getQuoteFields(); 
			String agreementField = getAgreementFields();   
			String soqlQueryQuote=CSWXGlobalConstant.soql_partQuote1 + cpoFields + CSWXGlobalConstant.soql_partQuote2;
			String soqlQueryAgree=CSWXGlobalConstant.soql_partQuote1 + agreementField + CSWXGlobalConstant.soql_partAgree2;
			
			//This field will store the list of CPO's			 
			List<Apttus_Proposal__Proposal__c> quoteList = Database.query(soqlQueryQuote);
			List<Apttus__APTS_Agreement__c> AgreementList = Database.query(soqlQueryAgree);
			
			
			/* -------- logic to map fields on CPO from related objects ---------------*/
			
			list<DS_CPOMapping__c> allCPOMapping = DS_CPOMapping__c.getAll().Values();
			 Apttus_Config2__CustomerPurchaseOrder__c cpo;
			for(Apttus_Proposal__Proposal__c quoteProp : quoteList){
				cpo = new Apttus_Config2__CustomerPurchaseOrder__c();
				for(DS_CPOMapping__c mapping : allCPOMapping){
					
					if(mapping.Object__c == CSWXGlobalConstant.OBJECT_Quotes){
						
						String fieldName = (String)mapping.name;
						if(!String.isBlank(fieldName) && quoteProp.get(mapping.Source__c) !=null ){
							cpo.put(fieldName, quoteProp.get(mapping.Source__c));
						}
						
						cpo.Apttus_Config2__Status__c = Label.DS_CPOStatus;
					 String str =  accountIDToCSMMap.get(quoteProp.Apttus_Proposal__Account__c);
					 //--   System.debug('str---->'+str);
						
					 //--   System.debug('accountIDToCDMMap.get(quoteProp.Apttus_Proposal__Account__c)---->'+accountIDToCDMMap.get(quoteProp.Apttus_Proposal__Account__c));
						
						if(accountIDToCSMMap.get(quoteProp.Apttus_Proposal__Account__c)!=CSWXGlobalConstant.nullValue){
							cpo.OwnerID =accountIDToCSMMap.get(quoteProp.Apttus_Proposal__Account__c);
					   //--	 System.debug('True------>');
						}else{
							cpo.OwnerID = quoteProp.OwnerId;
							accountIDToCSMMap.put(quoteProp.Apttus_Proposal__Account__c,quoteProp.OwnerId);
							
						}
						
						
					   if(accountIDToCDMMap.get(quoteProp.Apttus_Proposal__Account__c)!=CSWXGlobalConstant.nullValue){
							cpo.DS_CDM__c =accountIDToCDMMap.get(quoteProp.Apttus_Proposal__Account__c);
						}else{
							cpo.DS_CDM__c =accountIDToCSMMap.get(quoteProp.Apttus_Proposal__Account__c);
						}
						
						
					} 
				}
				
				
				
				if(quoteProp.Agreement_Lookup__c != null){
					
					for(Apttus__APTS_Agreement__c agree:AgreementList){
						if(agree.id ==quoteProp.Agreement_Lookup__c){
							
							for(DS_CPOMapping__c mapping : allCPOMapping){
								
								if(mapping.Object__c == CSWXGlobalConstant.OBJECT_Agreement ){
									
									String fieldName = (String)mapping.name;
									
									if(!String.isBlank(fieldName) && agree.get(mapping.Source__c) !=null ){
										cpo.put(fieldName, agree.get(mapping.Source__c));
										
									}
								}
							}
						}
						
					}
				}

				cpoList.add(cpo);
				system.debug('cpoList>>'+cpoList);
			}
			/*--UAT Defect fix Start ------- */
			/* -------- logic to validate CPO ------------------ */
			if(!cpoList.isEmpty()){
				database.insert(cpoList);
				 for(Apttus_Config2__CustomerPurchaseOrder__c cpovar : cpoList){
					cpoIdList.add(cpovar.Id);
				}
			} 
	   
			/* -------- logic to clone file record from quote to cpo file  ----------*/
			
			Set<String> stQutId = new Set<String>();
			For(Apttus_Proposal__Proposal__c quote : updatedQuoteList)
			{
				stQutId.add(quote.id);
			} 
		   // List<ContentDocumentLink> filelist = new List<ContentDocumentLink>();
			
		   /*  if(!stQutId.isEmpty()){
					filelist = [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,
					ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType
					FROM ContentDocumentLink 
					WHERE LinkedEntityId in :stQutId Limit :limitRows];
			 }*/
			
			Map<String,List<ContentDocumentLink>> mapQuotewithfile = new Map<String,List<ContentDocumentLink>>();
			For( ContentDocumentLink fileRec: [SELECT Id, LinkedEntityId, ContentDocumentId, Visibility, IsDeleted, ShareType,
					ContentDocument.Title, ContentDocument.createdDate, ContentDocument.FileType
					FROM ContentDocumentLink 
					WHERE LinkedEntityId in :stQutId Limit :limitRows])		
			{
				if(mapQuotewithfile.containsKey(fileRec.LinkedEntityId))
				{
					List<ContentDocumentLink> lstfile = mapQuotewithfile.get(fileRec.LinkedEntityId);
					lstfile.add(fileRec);
				}
				else
				{
					List<ContentDocumentLink> lstfile = new List<ContentDocumentLink>();
					lstfile.add(fileRec);
					mapQuotewithfile.put(fileRec.LinkedEntityId ,lstfile);
				}
			}
			
			List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
			ContentDocumentLink cDe ;
			 if(!cpoList.isEmpty()){
				for(Apttus_Config2__CustomerPurchaseOrder__c  cpoRec : cpoList)
				{   if(mapQuotewithfile.get(cpoRec.Apttus_QPConfig__ProposalId__c )!= null){
						for(ContentDocumentLink docLink :mapQuotewithfile.get(cpoRec.Apttus_QPConfig__ProposalId__c ) ){
				
						cDe = new ContentDocumentLink();
						cDe.ContentDocumentId = docLink.ContentDocumentId;
						cDe.LinkedEntityId = cpoRec.id ; 
						cDe.ShareType = CSWXGlobalConstant.fileShareType; 
						cDe.Visibility = CSWXGlobalConstant.fileVisiblity;
						cdlList.add(cDe);
		
						}
					}
				}
			}
			
			if(!cdlList.isEmpty()){
				
				insert cdlList;
				
			}
			
			
			/* -------- logic to clone quote LI in cpo lineitem ---------------*/
			List<Apttus_Config2__CustomerPOItem__c> cpoItemList = new List<Apttus_Config2__CustomerPOItem__c>();
			String cpoFields_draft = getQuoteLIFields();  
			List<String> fieldlist = cpoFields_draft.split(CSWXGlobalConstant.comma);
			String soql=CSWXGlobalConstant.soql_part1 + cpoFields_draft + CSWXGlobalConstant.soql_CPOItem;
			
			System.debug('soql--->'+soql);
			List<Apttus_Proposal__Proposal_Line_Item__c> listQutItem = Database.query(soql);
			
			Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>> mapQuotewithItem = new Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>>();
			
			For(Apttus_Proposal__Proposal_Line_Item__c Qitem: listQutItem)		
			{
				if(mapQuotewithItem.containsKey(Qitem.Apttus_Proposal__Proposal__c ))
				{
					List<Apttus_Proposal__Proposal_Line_Item__c> lstQitem = mapQuotewithItem.get(Qitem.Apttus_Proposal__Proposal__c);
					lstQitem.add(Qitem);
				}
				else
				{
					List<Apttus_Proposal__Proposal_Line_Item__c> lstQitem = new List<Apttus_Proposal__Proposal_Line_Item__c>();
					lstQitem.add(Qitem);
					mapQuotewithItem.put(Qitem.Apttus_Proposal__Proposal__c ,lstQitem);
				}
			}
			
			Apttus_Config2__CustomerPOItem__c cpoItem;
			if(!cpoList.isEmpty()){
				for(Apttus_Config2__CustomerPurchaseOrder__c  cpoRec : cpoList)
					{
					if(mapQuotewithItem.get(cpoRec.Apttus_QPConfig__ProposalId__c ) != null){
						
						for(Apttus_Proposal__Proposal_Line_Item__c  qLI :mapQuotewithItem.get(cpoRec.Apttus_QPConfig__ProposalId__c ) ){
							 
							 if(cpoRec.Apttus_QPConfig__ProposalId__c == qLI.Apttus_Proposal__Proposal__c){
								
							  cpoItem = new Apttus_Config2__CustomerPOItem__c();
									if(!allCPOMapping.isEmpty()){
										for(DS_CPOMapping__c mapping : allCPOMapping){
											if(mapping.Object__c == CSWXGlobalConstant.OBJECT_QuoteItem){ 
												cpoItem.Apttus_Config2__PurchaseOrderId__c =cpoRec.id;
												String fieldName = (String)mapping.name;
											   /* if(qLI.Nokia_Base_Price__c != null && qLI.Apttus_QPConfig__Quantity2__c !=null){
										   
													 cpoItem.Apttus_Config2__NetPrice__c = qLI.Nokia_Base_Price__c * qLI.Apttus_QPConfig__Quantity2__c;
												 }*/
												 if(qLI.get(mapping.Source__c) != null && !String.isblank(fieldName)){
													 cpoItem.put(fieldName,qLI.get(mapping.Source__c));
												 }
											 }
										 }
									 }
						
							   cpoItemList.add(cpoItem);
							   
						
							 }
						}
					}
						
				} 
				
			} 
			
			if(!cpoItemList.isEmpty()){
				database.insert(cpoItemList);
			}
			
			/*------------------------Update Customer Facing Attribute------------------------------*/
			  DS_Populate_CFAttributes.UpdateCFAforCPO(cpoList,cpoitemList);
				/*---------------------End of addition-------------------------------*/
			/* ---- ---------Moved validity check logic after Line item craetion to fix UAT defect as Line item creation is allowed in only Darf statue ------------------*/
			 /* -------- logic to validate CPO ------------------*/

				if(!cpoIdList.isEmpty()){
					DS_CPOValidity_Check.checkCPOValidity(cpoIdList);
				}
			
			
		}catch(Exception ex){
			System.debug('Exception --->'+ex);
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_CPOHelper,CSWXGlobalConstant.DS_CreateCPO);
			
		}
	}  
	
	/******************************************************************************************************
Name : getCSMandCDM
Created Date: 31th October 2018
Created by: Accenture
Description : This method is used to get CSM and CDM User 
Parameter : Set<ID> accountIDSet
*********************************************************************************************************/
   public static CPO_CSMCDM getCSMandCDM(Map<String,String> accountIDToTerritoryIDMap){
		try{
		   
			
			Map<String,String> accountIDToCSMMap = new Map<String,String>();
			Map<String,String> accountIDToCDMMap = new Map<String,String>();
			Map<String,List<String>> TerritoryIDToUserMap = new Map<String,List<String>>();
			Map<String,List<String>> accountIDToUserMap = new Map<String,List<String>>();
			//List<ObjectTerritory2Association> ObjectTerritory2AssociationList = [select id, Territory2Id, Territory2.name, SobjectType, ObjectId, AssociationCause from ObjectTerritory2Association where ObjectId IN :accountIDSet Limit :limitRows];
			Set<Id> userIDSet = new Set<Id>(); 
			
		   
			
			List<Sales_Role__c> salesRoleList = [SELECT ID,Organisation__c,User__c,Role_Name__c,BG__c  FROM Sales_Role__c WHERE Organisation__c IN:accountIDToTerritoryIDMap.values() Limit :limitRows];			
			
			for(String accID : accountIDToTerritoryIDMap.keySet()){			  //Create Map<AccountID,CSM> and Map<AccountID,CDM>
				String territoryName = accountIDToTerritoryIDMap.get(accID);
				Boolean isBGCheck = false;
				
				accountIDToCSMMap.put(accID,CSWXGlobalConstant.nullValue);
				accountIDToCDMMap.put(accID,CSWXGlobalConstant.nullValue);
				for(Sales_Role__c SalesRoleObj : salesRoleList){ 
					  
					if(SalesRoleObj.Role_Name__c == Label.DS_CSM_Role_Name && SalesRoleObj.Organisation__c==territoryName){
					   
						accountIDToCSMMap.put(accID,SalesRoleObj.User__c);
					}
					
					if(SalesRoleObj.Role_Name__c == Label.DS_CDM_Role_Name && SalesRoleObj.Organisation__c==territoryName && isBGCheck!=true && SalesRoleObj.BG__c == CSWXGlobalConstant.MN){
					   
						accountIDToCDMMap.put(accID,SalesRoleObj.User__c); 
						 isBGCheck = true;
						
					}else if(SalesRoleObj.Role_Name__c == Label.DS_CDM_Role_Name && SalesRoleObj.Organisation__c==territoryName && isBGCheck!=true) {
						
						accountIDToCDMMap.put(accID,SalesRoleObj.User__c);
					   
						
					}else{
						
					}
					
					
				}
				
				
			}
		   
			CPO_CSMCDM CPO_CSMCDMRecObj = new CPO_CSMCDM();
			CPO_CSMCDMRecObj.accountIDTOCSM = accountIDToCSMMap;
			CPO_CSMCDMRecObj.accountIDTOCDM = accountIDToCDMMap;
			return CPO_CSMCDMRecObj;
			
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_CPOHelper,CSWXGlobalConstant.getCSMandCDM);
			
			return null;
		}
	}
	
	
/*****************************
*Class Name: CPO_CSMCDM
*Description: This class is used as wrapper class to get CSM and CDM
*******************************/
	public with sharing class CPO_CSMCDM{
		
		public Map<String,String> accountIDTOCSM;
		public Map<String,String> accountIDTOCDM;
		
		
	}	   
	
	
}