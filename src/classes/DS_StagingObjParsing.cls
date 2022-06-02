/******************************************************************************************************
Name : DS_StagingObjParsing
Created Date: 18 July 2018
Created by: Accenture
Description : This class used to parse JSON stored in payload field of Staging Object and create digital proposal	  
*********************************************************************************************************/
global with sharing class DS_StagingObjParsing implements Queueable {
	private  String payload;
	private DS_Staging__c stagingObjRec;
	private ID stagingRecID;
	private  ID AccountID; 
	private  ID ParentAccountID;
	public ID accountOwnerID;
	public static Map<String, Object> reqMap;
	Set<String> useCase = new Set<String>();
	Set<String> SalesItemCode = new Set<String>();
	Set<String> BundleIDCode = new Set<String>();
	Map<String,String> useCaseToDPId =  new  Map<String,String>(); 
	Map<String,String> pCodeToDPId = new Map<String,String>();
	List<SWx_Upsell_Proposal__c> headerObjList = new List<SWx_Upsell_Proposal__c>();
	List<SWx_Upsell_Items__c> cxmLines = new List<SWx_Upsell_Items__c>();
	Map<String,SWx_Upsell_Proposal__c> useCaseToDPObjMap =  new  Map<String,SWx_Upsell_Proposal__c>(); 
	Id SWxUpsellRecordType = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.SWX_RecordType).getRecordTypeId();
	Id SWMPRecordType = Schema.SObjectType.SWx_Upsell_Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.SWMP_RecordType).getRecordTypeId();
	/******************************************************************************************************
Method Name : execute
parameter   : QueueableContext context
Created Date: 20th July 2018
Created by  : Accenture
Description : This method is Queueable Interface Standard method
*********************************************************************************************************/		   
	public void execute(QueueableContext context) {
		try{
			cxmDPCreation();
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_StagingObjParsing ,CSWXGlobalConstant.execute);
		}
	}
	
	/******************************************************************************************************
Method Name : cxmDPCreation
parameter   : 
Created Date: 20th July 2018
Created by  : Accenture
Description : This method is used to parse JSON Stored in Staging Object and create Digital Proposal and Line Item
*********************************************************************************************************/		  
	public void cxmDPCreation(){
		try{
			InboundRequest requestObj = (InboundRequest)JSON.deserialize(payload, InboundRequest.class);
			Set<String> productCode = new Set<String>();
			Map<String,String> productCodeToIdmap = new Map<String,String>();
			Map<String,Set<String>> useCaseToProductCode = new Map<String,Set<String>>();
			Map<String,SWx_Upsell_Proposal__c> dpIdToDPMap = new Map<String,SWx_Upsell_Proposal__c>(); 
			Map<String,String> entitledProductCodeEntStatus = new Map<String,String>();
			Map<String,DSBlanKUseCaseTechnology__c> blankUseCaseTech =DSBlanKUseCaseTechnology__c.getAll();
			Set<String> blankUseCaseTechSet = blankUseCaseTech.keySet();
			Map<String,SWx_Upsell_Proposal__c> dpIdToDPMapCheckBRule = new Map<String,SWx_Upsell_Proposal__c>();
			Map<String,SWx_Upsell_Proposal__c>  dpIdToDPMapCheckByPassBRule = new Map<String,SWx_Upsell_Proposal__c> ();
			system.debug('blankUseCaseTech>>'+blankUseCaseTech);
			system.debug('blankUseCaseTechSet>>'+blankUseCaseTechSet); 
			
			//Spring- 15-start------------------
			
			Map<String,List<String>> techuscaseList = new Map<String,List<String>>();
			List<id> techId = new List<Id>();
			Map<id,String> techidnameMap = new Map<id,String>();
			
			Set<String> productCodeSet = new Set<String>();
			Set<String> pCodeSet = new Set<String>();
			//Creates Set<product Code> from JSON Line Item
			for(LineItems Item : requestObj.line_items){
				productCodeSet.add(Item.sales_item_code);
				productCodeSet.add(Item.bundle_id);  
				pCodeSet.add(Item.sales_item_code);
				
			}	 
			
			system.debug('AccountID>>'+AccountID);
			system.debug('pCodeSet>>'+pCodeSet);
			Date todaysDate =date.today();
			Map<String,Commercial_Entitlement__c> mapOfpCodeToItemObj = new Map<String,Commercial_Entitlement__c>();
			Map<String,Commercial_Entitlement__c> pCodeToComEntitleMap = new Map<String,Commercial_Entitlement__c>();
			for(Commercial_Entitlement__c centitle:[SELECT Available_Quantity__c,Entitlement_Start_Date__c,Entitlement_End_Date__c,Id,Product_Code__c,Product_Name__c,Sold_To_Party__c,Technology__c,Use_Case__c FROM Commercial_Entitlement__c where Product_Code__c In :pCodeSet and Sold_To_Party__c = :AccountID LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){			   
				mapOfpCodeToItemObj.put(centitle.Product_Code__c,centitle);				
				if(centitle.Available_Quantity__c>0){
					pCodeToComEntitleMap.put(centitle.Product_Code__c,centitle);
				}  
			}
			
			system.debug('pCodeToComEntitleMap>>'+pCodeToComEntitleMap);
			system.debug('mapOfpCodeToQuantity>>'+mapOfpCodeToItemObj);
			
			
			Map<String,String> productcodeToTechnologyMap = new Map<String,String>();
			for(Apttus_Config2__ProductClassification__c prodclass :[select id,Apttus_Config2__ClassificationId__r.Apttus_Config2__Label__c,Apttus_Config2__ClassificationId__r.Apttus_Config2__Level__c,Apttus_Config2__ClassificationId__r.Apttus_Config2__AncestorId__r.Name,Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.ProductCode,Apttus_Config2__ClassificationId__r.Name 
																	 from Apttus_Config2__ProductClassification__c where Apttus_Config2__ProductId__r.ProductCode in : productCodeSet and Apttus_Config2__ClassificationId__r.Apttus_Config2__HierarchyId__c=:Label.DS_Category_Id LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
																		 System.debug('prodclass.Apttus_Config2__ProductId__r.ProductCode--->'+prodclass.Apttus_Config2__ProductId__r.ProductCode);
																		 System.debug('prodclass.Apttus_Config2__ClassificationId__r.Apttus_Config2__Level__c--->'+prodclass.Apttus_Config2__ClassificationId__r.Apttus_Config2__Level__c);
																		 
																		 
																		 if(prodclass.Apttus_Config2__ProductId__r.ProductCode!=NULL && prodclass.Apttus_Config2__ClassificationId__r.Apttus_Config2__Level__c==3){
																			 
																			 productcodeToTechnologyMap.put(prodclass.Apttus_Config2__ProductId__r.ProductCode,prodclass.Apttus_Config2__ClassificationId__r.Apttus_Config2__AncestorId__r.Name);
																			 System.debug('productcodeToTechnologyMap--->'+productcodeToTechnologyMap);
																		 }else if(prodclass.Apttus_Config2__ProductId__r.ProductCode!=NULL && prodclass.Apttus_Config2__ClassificationId__r.Apttus_Config2__Level__c==2){
																			 
																			 productcodeToTechnologyMap.put(prodclass.Apttus_Config2__ProductId__r.ProductCode,prodclass.Apttus_Config2__ClassificationId__r.Apttus_Config2__Label__c);
																			 
																		 }
																	 }
			
			System.debug('productcodeToTechnologyMap-->'+productcodeToTechnologyMap);					   
			
			for(Apttus_Config2__ClassificationHierarchy__c techlist:[select id,Name from Apttus_Config2__ClassificationHierarchy__c 
																	 where Apttus_Config2__Level__c =2 and Apttus_Config2__HierarchyId__c =:Label.DS_Category_Id LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())] ){
																		 techId.add(techlist.id);
																		 techidnameMap.put(techlist.id,techlist.Name);
																		 
																	 }
			
			System.debug('techId-->'+techId);
			System.debug('techidnameMap-->'+techidnameMap);
			
			Map<String,Set<String>> techusecase = new Map<String,Set<String>>();
			set<id> usecaseId = new set<Id>();
			for(Apttus_Config2__ClassificationHierarchy__c cls :[select id, Name,Apttus_Config2__AncestorId__c From Apttus_Config2__ClassificationHierarchy__c where Apttus_Config2__Level__c = 3 and Apttus_Config2__AncestorId__c in:techId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				
				usecaseId.add(cls.id);											
				String technology = techidnameMap.get(cls.Apttus_Config2__AncestorId__c);
				if(!techusecase.containsKey(technology)){
					system.debug('inside if--->'+technology);
					techusecase.put(technology, new Set<String>{cls.Name});
					
				}else{
					system.debug('inside else--->'+technology);
					//techusecase.get(technology, new Set<String>{cls.Name});
					
					techusecase.get(technology).add(cls.Name);
				}
				
			}
			Map<String,String> pcodeusecaseMap = new Map<String,String>();
			for(Apttus_Config2__ProductClassification__c prodclass :[select id,Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.ProductCode, Apttus_Config2__ClassificationId__r.Apttus_Config2__Label__c,Apttus_Config2__ClassificationId__r.Name from Apttus_Config2__ProductClassification__c 
																	 where Apttus_Config2__ClassificationId__c in : usecaseId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
																		 pcodeusecaseMap.put(prodclass.Apttus_Config2__ProductId__r.ProductCode,prodclass.Apttus_Config2__ClassificationId__r.Apttus_Config2__Label__c);
																		 
																	 }
			
			System.debug('pcodeusecaseMap--->'+pcodeusecaseMap);
			//System.debug('techusecase--->'+techusecase);
			
			
			//Sprint - 15 end
			//Parse the JSON and create DP by identifying distinct use case in Line Item
			String dpUseCase;
			Map<String,String> mapOfUsecaseToStatus = new Map<String,String>();			
			List<String> listOfProductCode = new List<String>();
			List<String> listOfPCodeQuoteNeeded = new List<String>();
			Map<String,String> mapOfPcodeToCanBeEntitledStatus = new Map<String,String>();
			Map<String,String> mapOfPcodeToQuoteNeededStatus = new Map<String,String>();
			Map<String,String> mapOfSalesItemCodeToTech = new Map<String,String>();
			for(LineItems Item : requestObj.line_items){
				
				
				System.debug('Item.use_case--->'+Item.use_case);
				if(Item.use_case == null || Item.use_case==CSWXGlobalConstant.Blank){
					dpUseCase= pcodeusecaseMap.get(Item.sales_item_code);
				}else{
					dpUseCase= Item.use_case;
				}
				
				System.debug('dpUseCase----->'+dpUseCase);
				
				System.debug('useCase-- inside if->'+useCase);		   
				System.debug('Item.use_case--->'+Item.use_case);
				SWx_Upsell_Proposal__c tempObj = new SWx_Upsell_Proposal__c();
				SWx_Upsell_Proposal__c headerObj = new SWx_Upsell_Proposal__c();
				Date createDate = Date.valueOf(requestObj.header.creation_date);
				String strTest = requestObj.header.source_id;
				String[] arrTest = strTest.split(CSWXGlobalConstant.dash);
							 
				
				
				headerObj.RecordTypeId = SWxUpsellRecordType;
				
				
				headerObj.Analytics_Source__c = arrTest[0];  
				headerObj.Collection_Period_End_Date__c =requestObj.header.end_date;
				headerObj.Collection_Period_Start_Date__c =requestObj.header.start_date;
				headerObj.Analytics_File_Refer_ID__c = requestObj.header.file_reference_id;
				headerObj.Proposal_Recommendation_Type__c = requestObj.header.category_Type;
				headerObj.SWx_Source_ID__c = requestObj.header.source_id;
				headerObj.Account_ID__c = ParentAccountID;
				headerObj.Sold_To_Party__c = AccountID;
				headerObj.P20_Id__c = requestObj.header.P20_ID;
				//DSI-985
				headerObj.Analysed_Cells__c = requestObj.header.scope;
				headerObj.Identified_Cells__c = requestObj.header.cell_quantity;
				
				
				// headerObj.RecordTypeId = SWxUpsellRecordType; 
				headerObj.Creation_Date__c = requestObj.header.creation_date;
				System.debug('>>>>>'+Item.use_case); 
				if(arrTest.size()>=3){   
					//String  Masterdatausecase   =  pcodeusecaseMap.get(Item.sales_item_code);
					//System.debug('Masterdatausecase---->'+Masterdatausecase);
					//headerObj.Use_Case__c =Masterdatausecase;//Item.use_case;
				}
				if(arrTest.size()==2){  
					
					//headerObj.Use_Case__c = null;
				}
				System.debug('>>>>>'+Item.use_case); 
				headerObj.Unweighted_Value__c = requestObj.header.Unweighted_Value;
				headerObj.DS_Staging__c = stagingObjRec.Id;  
				
				
				/* DSI-961 */
				//mapOfpCodeToItemObj.get(Item.sales_item_code).Sold_To_Party__c==AccountId &&
				
				system.debug('Item.sales_item_code>>'+Item.sales_item_code);
				if(mapOfpCodeToItemObj.containsKey(Item.sales_item_code)&& mapOfpCodeToItemObj.containsKey(Item.sales_item_code)!=null && mapOfpCodeToItemObj.get(Item.sales_item_code).Available_Quantity__c>CSWXGlobalConstant.ZERO){
					system.debug('map contains value');
					if(mapOfpCodeToItemObj.get(Item.sales_item_code).Sold_To_Party__c==AccountId && mapOfpCodeToItemObj.containsKey(Item.sales_item_code) && Item.quantity<=mapOfpCodeToItemObj.get(Item.sales_item_code).Available_Quantity__c){
						
						headerObj.Entitlement_Info__c=CSWXGlobalConstant.CanBeEntitled;	 
						mapOfPcodeToCanBeEntitledStatus.put(Item.sales_item_code,headerObj.Entitlement_Info__c);
						mapOfUsecaseToStatus.put(Item.use_case,headerObj.Entitlement_Info__c);
						entitledProductCodeEntStatus.put(Item.sales_item_code,headerObj.Entitlement_Info__c);
						system.debug('mapOfUsecaseToStatus>>'+mapOfUsecaseToStatus);
						listOfProductCode.add(Item.sales_item_code);
						system.debug('listOfProductCode>>'+listOfProductCode);
						system.debug('asking for less and equal');
						
						String tech=fetchTechnology(Item.sales_item_code,productcodeToTechnologyMap,pcodeusecaseMap,requestObj.header.source_id,headerObj.Entitlement_Info__c,pCodeToComEntitleMap);
						headerObj.Technology__c=tech;
						system.debug('tech>>'+tech);
						
						String Ucase = fetchUseCase(tech,Item.use_case,Item.sales_item_code,productcodeToTechnologyMap,pcodeusecaseMap,headerObj.Entitlement_Info__c,pCodeToComEntitleMap,requestObj.header.source_id);
						headerObj.Use_Case__c=Ucase;
						system.debug('Ucase>>'+Ucase);
						mapOfSalesItemCodeToTech.put(Item.sales_item_code,tech);
						//AccountId==mapOfpCodeToItemObj.get(Item.sales_item_code).Sold_To_Party__c &&
					}else if(mapOfpCodeToItemObj.get(Item.sales_item_code).Sold_To_Party__c==AccountId && mapOfpCodeToItemObj.containsKey(Item.sales_item_code) && Item.quantity>mapOfpCodeToItemObj.get(Item.sales_item_code).Available_Quantity__c){
						
						//Decimal temp =Item.quantity-mapOfpCodeToItemObj.get(Item.sales_item_code).Available_Quantity__c;
						mapOfUsecaseToStatus.put(Item.use_case,headerObj.Entitlement_Info__c);	
						listOfPCodeQuoteNeeded.add(Item.sales_item_code);								
						system.debug('asking for max');  
						system.debug('headerObj>>'+headerObj);
						tempObj=headerObj.clone();
						system.debug('tempObj>>'+tempObj);								  
						tempObj.Entitlement_Info__c=CSWXGlobalConstant.CanBeEntitled;
						mapOfPcodeToCanBeEntitledStatus.put(Item.sales_item_code,tempObj.Entitlement_Info__c);
						headerObj.Entitlement_Info__c=CSWXGlobalConstant.QuoteNeeded;
						mapOfPcodeToQuoteNeededStatus.put(Item.sales_item_code,headerObj.Entitlement_Info__c);
						mapOfUsecaseToStatus.put(Item.use_case,tempObj.Entitlement_Info__c);
						entitledProductCodeEntStatus.put(Item.sales_item_code,tempObj.Entitlement_Info__c);
						system.debug('tempObj>>'+tempObj);  
						system.debug('headerObj>>'+headerObj);
						headerObjList.add(tempObj);						   
						system.debug('headerObjList>>'+headerObjList); 
						String tech=fetchTechnology(Item.sales_item_code,productcodeToTechnologyMap,pcodeusecaseMap,requestObj.header.source_id,tempObj.Entitlement_Info__c,pCodeToComEntitleMap);
						tempObj.Technology__c=tech;
						system.debug('tech>>'+tech);
						
						String Ucase = fetchUseCase(tech,Item.use_case,Item.sales_item_code,productcodeToTechnologyMap,pcodeusecaseMap,tempObj.Entitlement_Info__c,pCodeToComEntitleMap,requestObj.header.source_id);
						tempObj.Use_Case__c=Ucase;
						system.debug('Ucase>>'+Ucase);
						
						String tech1=fetchTechnology(Item.sales_item_code,productcodeToTechnologyMap,pcodeusecaseMap,requestObj.header.source_id,headerObj.Entitlement_Info__c,pCodeToComEntitleMap);
						headerObj.Technology__c=tech;
						system.debug('tech1>>'+tech1);
						
						String Ucase1 = fetchUseCase(tech,Item.use_case,Item.sales_item_code,productcodeToTechnologyMap,pcodeusecaseMap,headerObj.Entitlement_Info__c,pCodeToComEntitleMap,requestObj.header.source_id);
						headerObj.Use_Case__c=Ucase1;
						system.debug('Ucase1>>'+Ucase1);
						mapOfSalesItemCodeToTech.put(Item.sales_item_code,tech);
						mapOfSalesItemCodeToTech.put(Item.sales_item_code,tech1);
						
					}
				}
				else{
					
						headerObj.Entitlement_Info__c=CSWXGlobalConstant.QuoteNeeded;
						mapOfUsecaseToStatus.put(Item.use_case,headerObj.Entitlement_Info__c); 
						mapOfPcodeToQuoteNeededStatus.put(Item.sales_item_code,headerObj.Entitlement_Info__c);
						listOfPCodeQuoteNeeded.add(Item.sales_item_code);
						system.debug('No Entitlement present');
						String tech=fetchTechnology(Item.sales_item_code,productcodeToTechnologyMap,pcodeusecaseMap,requestObj.header.source_id,headerObj.Entitlement_Info__c,pCodeToComEntitleMap);
						headerObj.Technology__c=tech;
						system.debug('tech>>'+tech);
						
						String Ucase = fetchUseCase(tech,Item.use_case,Item.sales_item_code,productcodeToTechnologyMap,pcodeusecaseMap,headerObj.Entitlement_Info__c,pCodeToComEntitleMap,requestObj.header.source_id);
						headerObj.Use_Case__c=Ucase;
						system.debug('Ucase>>'+Ucase);
						mapOfSalesItemCodeToTech.put(Item.sales_item_code,tech);
					
					
				}				 
					headerObjList.add(headerObj);														 
					system.debug('headerObjList>>'+headerObjList);				
				useCase.add(dpUseCase);
				
			}
			
			system.debug('headerObjList>>'+headerObjList);
			
			List<SWx_Upsell_Proposal__c> listToInsertDp = new List<SWx_Upsell_Proposal__c>();
			List<String> listOfUseCase = new List<String>();
			Map<String,list<String>> mapOfUseCaseToEntitlementStatus = new Map<String,list<String>>();
			for(SWx_Upsell_Proposal__c insertDp : headerObjList){
				system.debug('insertDp>>'+ insertDp);				
					if(listOfUseCase.contains(insertDp.Use_Case__c)){
						if(mapOfUseCaseToEntitlementStatus.get(insertDp.Use_Case__c).size()<2){
							List<String> useCaseValues = new List<String>();
							for(String a:mapOfUseCaseToEntitlementStatus.get(insertDp.Use_Case__c)){
								if((a!=insertDp.Entitlement_Info__c)){
									system.debug('insertDp>>123'+insertDp);
									listToInsertDp.add(insertDp);   
									useCaseValues.add(insertDp.Entitlement_Info__c);									
									//mapOfUseCaseToEntitlementStatus.get(insertDp.Use_Case__c).add(insertDp.Entitlement_Info__c);
								}   
							}
							mapOfUseCaseToEntitlementStatus.get(insertDp.Use_Case__c).addAll(useCaseValues);							
						}
						
					}else{				   
						listToInsertDp.add(insertDp);					   
						listOfUseCase.add(insertDp.Use_Case__c);						
						mapOfUseCaseToEntitlementStatus.put(insertDp.Use_Case__c,new list<String>{insertDp.Entitlement_Info__c});
						
					}
								
			}
			system.debug('listToInsertDp>>>'+listToInsertDp);
			system.debug('listToInsertDp>>>'+listToInsertDp.size());
			
			if(!listToInsertDp.isEmpty()){
				insert listToInsertDp;
			}
			
			//insert headerObjList;
			//Check whether DP is already exist in database with same combination(Analytics File Reference ID + Use Case)
			// headerObjList = checkReadyForReview(useCaseToDPObjMap,headerObjList[0].Analytics_File_Refer_ID__c);			
			
			
			
			//Below code will check for the usecase and Header count . If there is  a difference then will update 
			//the failure status to stage
			
			System.debug('listToInsertDp--->'+listToInsertDp);
			
			//Creates Map<Use Case,DPId> and Map<DPId,DPObject>  
			Set<Id> insertedDpIds = new Set<Id>();
			for(SWx_Upsell_Proposal__c headerObj : listToInsertDp){
				System.debug('headerObj--->'+headerObj);
				//
				if(headerObj.Use_Case__c!=null && headerObj.Use_Case__c!=CSWXGlobalConstant.Blank){
					useCaseToDPId.put(headerObj.Use_Case__c, headerObj.Id); 
				}else{
					if(blankUseCaseTechSet.contains(headerObj.Technology__c)){
						useCaseToDPId.put(CSWXGlobalConstant.DS_BLANKString, headerObj.Id);						
					} 
				}
				
				dpIdToDPMap.put(headerObj.Id,headerObj);
				insertedDpIds.add(headerObj.Id);
			} 
			System.debug('useCaseToDPId-->'+useCaseToDPId);
			System.debug('insertedDpIds-->'+insertedDpIds);
			
			
			
			//listToInsertDp = [SELECT Analytics_Source__c,Upsell_Status__c,Business_Rules_Check__c,Technology__c,Account_ID__r.OwnerId ,Account_ID__r.Owner.FirstName,Account_ID__r.Owner.LastName ,Analytics_File_Refer_ID__c,Proposal_Recommendation_Type__c,Account_ID__c,Account_ID__r.Name,Name,Use_Case__c FROM SWx_Upsell_Proposal__c WHERE ID IN:useCaseToDPId.values() Limit : limits.getLimitQueryRows()];
			
			listToInsertDp = [SELECT Analytics_Source__c,DS_Staging__c,Entitlement_Info__c,Upsell_Status__c,Business_Rules_Check__c,Technology__c,Account_ID__r.OwnerId ,Account_ID__r.Owner.FirstName,Account_ID__r.Owner.LastName ,Analytics_File_Refer_ID__c,Proposal_Recommendation_Type__c,Account_ID__c,Account_ID__r.Name,Name,Use_Case__c 
							  FROM SWx_Upsell_Proposal__c WHERE ID IN:insertedDpIds LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			system.debug('listToInsertDpQueryoutput>>'+listToInsertDp);
			Map<String,String> mapOfCoveredUcaseToId = new Map<String,String>();
			Map<String,String> mapOfQuoteNddUcaseToId = new Map<String,String>();
			for(SWx_Upsell_Proposal__c headerObj : listToInsertDp){
				
				dpIdToDPMap.put(headerObj.Id,headerObj);
			if(headerObj.Entitlement_Info__c==CSWXGlobalConstant.CanBeEntitled){
					if(!blankUseCaseTechSet.contains(headerObj.Technology__c)){
						if(headerObj.Use_Case__c!=null && headerObj.Use_Case__c!=CSWXGlobalConstant.Blank){
							system.debug('use case is not blank on dp');
							String useCase =headerObj.Use_Case__c;
							mapOfCoveredUcaseToId.put(useCase.toUpperCase(),headerObj.Id);
							dpIdToDPMapCheckByPassBRule.put(headerObj.Id,headerObj);			  
						}else{							
							system.debug('use case is blank on dp');
							mapOfCoveredUcaseToId.put(CSWXGlobalConstant.DS_BLANKString,headerObj.Id);
							dpIdToDPMapCheckByPassBRule.put(headerObj.Id,headerObj);
						}
					}else{
						if(blankUseCaseTechSet.contains(headerObj.Technology__c)){  
							if(headerObj.Use_Case__c!=null && headerObj.Use_Case__c!=CSWXGlobalConstant.Blank){
								system.debug('use case is not blank on dp');
								String useCase =headerObj.Use_Case__c;
								mapOfCoveredUcaseToId.put(useCase.toUpperCase(),headerObj.Id);
								dpIdToDPMapCheckByPassBRule.put(headerObj.Id,headerObj);  
							}else{
								system.debug('headerObj.Technology__c>>'+headerObj.Technology__c);
								system.debug('use case is blank for above tech');
								mapOfCoveredUcaseToId.put(CSWXGlobalConstant.DS_BLANKString,headerObj.Id);
								dpIdToDPMapCheckByPassBRule.put(headerObj.Id,headerObj);
							}
							
						}
					}
					
					system.debug('CanBeEntitled');
				}else if(headerObj.Entitlement_Info__c==CSWXGlobalConstant.QuoteNeeded){
					if(!blankUseCaseTechSet.contains(headerObj.Technology__c)){
						if(headerObj.Use_Case__c!=null && headerObj.Use_Case__c!=CSWXGlobalConstant.Blank){
							String useCase =headerObj.Use_Case__c;
							system.debug('use case is not blank on dp');
							mapOfQuoteNddUcaseToId.put(useCase.toUpperCase(),headerObj.Id);
							dpIdToDPMapCheckBRule.put(headerObj.Id,headerObj);
						}else{										 
							mapOfQuoteNddUcaseToId.put(CSWXGlobalConstant.DS_BLANKString,headerObj.Id);
							dpIdToDPMapCheckBRule.put(headerObj.Id,headerObj);
							system.debug('use case is blank on dp');
						}
						
					}else{
						if(blankUseCaseTechSet.contains(headerObj.Technology__c)){  
							if(headerObj.Use_Case__c!=null && headerObj.Use_Case__c!=CSWXGlobalConstant.Blank){
								String useCase =headerObj.Use_Case__c;
								system.debug('use case is not blank on dp');
								mapOfQuoteNddUcaseToId.put(useCase.toUpperCase(),headerObj.Id);
								dpIdToDPMapCheckBRule.put(headerObj.Id,headerObj);
							}else{
								mapOfQuoteNddUcaseToId.put(CSWXGlobalConstant.DS_BLANKString,headerObj.Id);
								system.debug('use case is blank for above tech');
								dpIdToDPMapCheckBRule.put(headerObj.Id,headerObj);
							}
							
						}
					}
					system.debug('Quote Needed');
				}									
			} 
			
			System.debug('dpIdToDPMap-->'+dpIdToDPMap);
			System.debug('mapOfCoveredUcaseToId-->'+mapOfCoveredUcaseToId);
			System.debug('mapOfQuoteNddUcaseToId-->'+mapOfQuoteNddUcaseToId);
			system.debug('dpIdToDPMapCheckByPassBRule>>'+dpIdToDPMapCheckByPassBRule);
			system.debug('dpIdToDPMapCheckBRule>>'+dpIdToDPMapCheckBRule);
			
			
			
			//Creates Set<product Code> from JSON Line Item
			for(LineItems Item : requestObj.line_items){
				SalesItemCode.add(Item.sales_item_code);
				BundleIDCode.add(Item.bundle_id);  
				
			}
			
			productCode.addAll(SalesItemCode);
			productCode.addAll(BundleIDCode);
			
			System.debug('all DP Item Product code--->'+productCode);
			
			List<Apttus_Config2__ProductOptionComponent__c> ProductOptionComponentList =[select id,BundledProduct_Code__c,ProductCode__c from Apttus_Config2__ProductOptionComponent__c where (ProductCode__c in : SalesItemCode OR BundledProduct_Code__c in:BundleIDCode) LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];  
			
			//Create List<Product> by using Set<product Code> 
			//Create Map<Product Code,ProductId>
			for(Product2 productObj : [SELECT Id,ProductCode FROM Product2 WHERE ProductCode IN :productCode LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				productCodeToIdmap.put(productObj.ProductCode, productObj.Id);   
			}
			
			//This is used to create line Item and to check whether product exist in database or not.						
			
			Set<String> failedDP = new Set<String>();
			for(LineItems Item : requestObj.line_items){
				system.debug('insert line item');
				SWx_Upsell_Items__c upsellItem = new SWx_Upsell_Items__c();
				SWx_Upsell_Items__c tempObj = new SWx_Upsell_Items__c();
				String strTest = requestObj.header.source_id;
				String[] arrTest = strTest.split(CSWXGlobalConstant.dash);
				//This is used to check whether Bundle ID is exist in database or not
				if(productCodeToIdmap.containsKey(Item.bundle_id) && Item.bundle_id!=GlobalConstants.BLANK_VALUE){
					upsellItem.Bundle_ID__c = productCodeToIdmap.get(Item.bundle_id);
					
				}if(!productCodeToIdmap.containsKey(Item.bundle_id) && Item.bundle_id!=GlobalConstants.BLANK_VALUE){
					//failedDP.add(useCaseToDPId.get(Item.use_case));
					upsellItem.Error_Message__c = System.Label.ErrorMessageForProductValidation;
					upsellItem.Ready_to_Convert__c = false;
					
				}
				
				//This is used to check whether Sales Item Code is exist in database or not
				if(productCodeToIdmap.containsKey(Item.sales_item_code) && Item.sales_item_code!=GlobalConstants.BLANK_VALUE && mapOfPcodeToCanBeEntitledStatus.get(Item.sales_item_code)!=CSWXGlobalConstant.CanBeEntitled){
					upsellItem.Sales_Item_Code__c = productCodeToIdmap.get(Item.sales_item_code);
					
				}
				
				if(!productCodeToIdmap.containsKey(Item.sales_item_code) && Item.sales_item_code!=GlobalConstants.BLANK_VALUE && mapOfPcodeToCanBeEntitledStatus.get(Item.sales_item_code)!=CSWXGlobalConstant.CanBeEntitled){
					upsellItem.Error_Message__c = System.Label.ErrorMessageForProductValidation;
					upsellItem.Ready_to_Convert__c = false;
					//failedDP.add(useCaseToDPId.get(Item.use_case));
					
				}if(mapOfPcodeToCanBeEntitledStatus.containsKey(Item.sales_item_code) && mapOfPcodeToCanBeEntitledStatus.get(Item.sales_item_code)==CSWXGlobalConstant.CanBeEntitled){
					system.debug('Dp status is can be entitled');
					if(pCodeToComEntitleMap.containsKey(Item.sales_item_code)){					   
						upsellItem.Sales_Item_Code__c = pCodeToComEntitleMap.get(Item.sales_item_code).Product_Name__c;						
						system.debug('product not present in database but it is entitled');
					}					
				}
				System.debug('useCaseToDPId-->'+useCaseToDPId);
				System.debug('useCaseToDPId-->'+useCaseToDPId);
				
				if(productcodeToTechnologyMap.containsKey(Item.sales_item_code) && blankUseCaseTechSet.contains(productcodeToTechnologyMap.get(Item.sales_item_code))){
					if(Item.sales_item_code!=GlobalConstants.BLANK_VALUE && mapOfPcodeToCanBeEntitledStatus.containsKey(Item.sales_item_code) && mapOfPcodeToCanBeEntitledStatus.get(Item.sales_item_code)==CSWXGlobalConstant.CanBeEntitled){
						upsellItem.Use_Case__c = pCodeToComEntitleMap.get(Item.sales_item_code).Use_Case__c;   
					}else{
						upsellItem.Use_Case__c = Item.use_case;	
					}
					
				}else{
					if(Item.use_case==null && Item.use_case==GlobalConstants.BLANK_VALUE){
						if(Item.sales_item_code!=GlobalConstants.BLANK_VALUE && mapOfPcodeToCanBeEntitledStatus.containsKey(Item.sales_item_code) && mapOfPcodeToCanBeEntitledStatus.get(Item.sales_item_code)==CSWXGlobalConstant.CanBeEntitled){
							upsellItem.Use_Case__c = pCodeToComEntitleMap.get(Item.sales_item_code).Use_Case__c;   
						}else if(pcodeusecaseMap.containsKey(Item.sales_item_code) && Item.sales_item_code!=GlobalConstants.BLANK_VALUE && mapOfPcodeToQuoteNeededStatus.get(Item.sales_item_code)==CSWXGlobalConstant.QuoteNeeded){
							upsellItem.Use_Case__c=pcodeusecaseMap.get(Item.sales_item_code);
						}else{
							upsellItem.Use_Case__c = Item.use_case;
						}
					}else{
						upsellItem.Use_Case__c = Item.use_case;
					}
				}
				
				//upsellItem.Use_Case__c = Item.use_case;
				upsellItem.SWx_Product_Code__c = Item.sales_item_code;
				system.debug(mapOfpCodeToItemObj.containsKey(Item.sales_item_code));
				system.debug('mapOfQuoteNddUcaseToId>>>--'+mapOfQuoteNddUcaseToId);
				system.debug('mapOfCoveredUcaseToId>>>--'+mapOfQuoteNddUcaseToId);
				system.debug('mapOfSalesItemCodeToTech>>'+mapOfSalesItemCodeToTech);
				if(mapOfpCodeToItemObj.containsKey(Item.sales_item_code) && mapOfpCodeToItemObj.get(Item.sales_item_code).Available_Quantity__c>CSWXGlobalConstant.ZERO){
					system.debug('check use case'+useCaseToDPId.get(Item.use_case));
					if(Item.use_case!=NULL && Item.use_case!=null && Item.use_case!=CSWXGlobalConstant.Blank){
						system.debug('in usecase not null check');
						//upsellItem.SWx_Upsell_Proposal__c = useCaseToDPId.get(Item.use_case);
						//upsellItem.SWx_Upsell_Proposal__c = productCodeToDPId.get(Item.sales_item_code);
						if(Item.quantity<=mapOfpCodeToItemObj.get(Item.sales_item_code).Available_Quantity__c){
							system.debug('in availble quantity greater');
							
							if(blankUseCaseTechSet.contains(mapOfSalesItemCodeToTech.get(Item.sales_item_code))){
								system.debug('SI belongs to HW/Antena Tech');
								String useCase =Item.use_case;
								upsellItem.SWx_Upsell_Proposal__c =mapOfCoveredUcaseToId.get(useCase.toUpperCase()); 
							}else{
								if(blankUseCaseTechSet.contains(productcodeToTechnologyMap.get(Item.sales_item_code))){  
									String useCase =Item.use_case;				
									upsellItem.SWx_Upsell_Proposal__c =mapOfCoveredUcaseToId.get(useCase.toUpperCase());				   
								}else{
									String useCase =Item.use_case;
									if(mapOfCoveredUcaseToId.containsKey(useCase.toUpperCase())){
										upsellItem.SWx_Upsell_Proposal__c =mapOfCoveredUcaseToId.get(useCase.toUpperCase());  
									}
								}
								
							}							
							upsellItem.Entitlement_Status__c=CSWXGlobalConstant.CanBeEntitled;
							system.debug('CoveredId>>'+mapOfCoveredUcaseToId.get(Item.use_case));
							upsellItem.Quantity__c = Item.quantity; 
						}
						system.debug('Item.quantity>>'+Item.quantity);
						system.debug('mapOfpCodeToItemObj.get(Item.sales_item_code).Available_Quantity__c>>'+mapOfpCodeToItemObj.get(Item.sales_item_code).Available_Quantity__c);
						if(Item.quantity>mapOfpCodeToItemObj.get(Item.sales_item_code).Available_Quantity__c){						
							system.debug('in availble quantity less');
							tempObj=upsellItem.clone();
							tempObj.Entitlement_Status__c=CSWXGlobalConstant.CanBeEntitled;
							tempObj.Quantity__c=mapOfpCodeToItemObj.get(Item.sales_item_code).Available_Quantity__c;
							String useCase =Item.use_case; 
							if(blankUseCaseTechSet.contains(mapOfSalesItemCodeToTech.get(Item.sales_item_code))){
								system.debug('SI belongs to HW/Antena Tech');
								tempObj.SWx_Upsell_Proposal__c =mapOfCoveredUcaseToId.get(useCase.toUpperCase()); 
							}else{
								if(blankUseCaseTechSet.contains(productcodeToTechnologyMap.get(Item.sales_item_code))){				  
									tempObj.SWx_Upsell_Proposal__c =mapOfCoveredUcaseToId.get(useCase.toUpperCase());				   
								}else{
									if(mapOfCoveredUcaseToId.containsKey(useCase.toUpperCase())){
										tempObj.SWx_Upsell_Proposal__c=mapOfCoveredUcaseToId.get(useCase.toUpperCase());
									}
								}
							}
							Decimal remQuantity=Item.quantity-mapOfpCodeToItemObj.get(Item.sales_item_code).Available_Quantity__c;
							upsellItem.Quantity__c = remQuantity;
							
							upsellItem.Entitlement_Status__c=CSWXGlobalConstant.QuoteNeeded;
							if(blankUseCaseTechSet.contains(mapOfSalesItemCodeToTech.get(Item.sales_item_code))){
								system.debug('SI belongs to HW/Antena Tech');
								system.debug('mapOfQuoteNddUcaseToId.get(useCase.toUpperCase())>'+mapOfQuoteNddUcaseToId.get(useCase.toUpperCase()));
								upsellItem.SWx_Upsell_Proposal__c =mapOfQuoteNddUcaseToId.get(useCase.toUpperCase()); 
							}else{
								if(blankUseCaseTechSet.contains(productcodeToTechnologyMap.get(Item.sales_item_code))){				  
									upsellItem.SWx_Upsell_Proposal__c =mapOfQuoteNddUcaseToId.get(useCase.toUpperCase());				   
								}else{
									if(mapOfQuoteNddUcaseToId.containsKey(useCase.toUpperCase())){
										upsellItem.SWx_Upsell_Proposal__c =mapOfQuoteNddUcaseToId.get(useCase.toUpperCase());
									}
								}
							}
							cxmLines.add(tempObj);
						}					 
						
					}else{
						//upsellItem.SWx_Upsell_Proposal__c = useCaseToDPId.get(pcodeusecaseMap.get(Item.sales_item_code));//useCaseToDPId.get(null);				 
						//upsellItem.SWx_Upsell_Proposal__c = productCodeToDPId.get(Item.sales_item_code);//useCaseToDPId.get(null);
						if(Item.quantity<=mapOfpCodeToItemObj.get(Item.sales_item_code).Available_Quantity__c){							
							
							if(blankUseCaseTechSet.contains(mapOfSalesItemCodeToTech.get(Item.sales_item_code))){
								system.debug('SI belongs to HW/Antena Tech');
								upsellItem.SWx_Upsell_Proposal__c =mapOfCoveredUcaseToId.get(CSWXGlobalConstant.DS_BLANKString); 
							}else{
								if(blankUseCaseTechSet.contains(productcodeToTechnologyMap.get(Item.sales_item_code))){				  
									upsellItem.SWx_Upsell_Proposal__c =mapOfCoveredUcaseToId.get(CSWXGlobalConstant.DS_BLANKString);				   
								}else{
									if(pCodeToComEntitleMap.containsKey(Item.sales_item_code)){
										String useCase =pCodeToComEntitleMap.get(Item.sales_item_code).Use_Case__c;
										system.debug('useCase>>'+useCase);
										system.debug('mapOfCoveredUcaseToId>>'+mapOfCoveredUcaseToId);
										if(mapOfCoveredUcaseToId.containsKey(useCase.toUpperCase())){				  
											upsellItem.SWx_Upsell_Proposal__c =mapOfCoveredUcaseToId.get(useCase.toUpperCase());		  
										}
									}  
								}					
							}							
							upsellItem.Entitlement_Status__c=CSWXGlobalConstant.CanBeEntitled;
							upsellItem.Quantity__c = Item.quantity;
						}
						
						if(Item.quantity>mapOfpCodeToItemObj.get(Item.sales_item_code).Available_Quantity__c){
							
							tempObj=upsellItem.clone();
							tempObj.Entitlement_Status__c=CSWXGlobalConstant.CanBeEntitled;	 
							tempObj.Quantity__c=mapOfpCodeToItemObj.get(Item.sales_item_code).Available_Quantity__c;													   
							
							if(blankUseCaseTechSet.contains(mapOfSalesItemCodeToTech.get(Item.sales_item_code))){
								tempObj.SWx_Upsell_Proposal__c =mapOfCoveredUcaseToId.get(CSWXGlobalConstant.DS_BLANKString); 
								system.debug('SI belongs to HW/Antena Tech');
							}else{
								if(blankUseCaseTechSet.contains(productcodeToTechnologyMap.get(Item.sales_item_code))){				  
									tempObj.SWx_Upsell_Proposal__c =mapOfCoveredUcaseToId.get(CSWXGlobalConstant.DS_BLANKString);				   
								}else{
									if(pCodeToComEntitleMap.containsKey(Item.sales_item_code)){
										String useCase =pCodeToComEntitleMap.get(Item.sales_item_code).Use_Case__c;
										system.debug('useCase>>'+useCase);				  
										if(mapOfCoveredUcaseToId.containsKey(useCase.toUpperCase())){
											system.debug('mapOfCoveredUcaseToId>>'+mapOfCoveredUcaseToId);
											system.debug('mapOfQuoteNddUcaseToId>>'+mapOfQuoteNddUcaseToId);
											tempObj.SWx_Upsell_Proposal__c=mapOfCoveredUcaseToId.get(useCase.toUpperCase()); 
										}
									}
								}
							}													   
							
							Decimal remQuantity=Item.quantity-mapOfpCodeToItemObj.get(Item.sales_item_code).Available_Quantity__c;
							upsellItem.Quantity__c = remQuantity;						   
							
							upsellItem.Entitlement_Status__c=CSWXGlobalConstant.QuoteNeeded; 
							if(blankUseCaseTechSet.contains(mapOfSalesItemCodeToTech.get(Item.sales_item_code))){
								upsellItem.SWx_Upsell_Proposal__c =mapOfQuoteNddUcaseToId.get(CSWXGlobalConstant.DS_BLANKString); 
							}else{  
								if(blankUseCaseTechSet.contains(productcodeToTechnologyMap.get(Item.sales_item_code))){				  
									upsellItem.SWx_Upsell_Proposal__c =mapOfQuoteNddUcaseToId.get(CSWXGlobalConstant.DS_BLANKString);				   
								}else{			  
									if(pcodeusecaseMap.containsKey(Item.sales_item_code)){
										String useCase =pcodeusecaseMap.get(Item.sales_item_code);
										if(mapOfQuoteNddUcaseToId.containsKey(useCase.toUpperCase())){				  
											upsellItem.SWx_Upsell_Proposal__c =mapOfQuoteNddUcaseToId.get(useCase.toUpperCase()); 
										}
									}			  
								} 
							}  
							cxmLines.add(tempObj);			  
						}
						
						
					}
				}else{
					
						system.debug('not entitled');
						upsellItem.Quantity__c = Item.quantity;
						upsellItem.Entitlement_Status__c=CSWXGlobalConstant.QuoteNeeded;
						system.debug('Item.use_case>>'+Item.use_case);
						if(Item.use_case!=NULL && Item.use_case!=CSWXGlobalConstant.Blank){
							if(blankUseCaseTechSet.contains(mapOfSalesItemCodeToTech.get(Item.sales_item_code))){
								String useCase =Item.use_case; 
								upsellItem.SWx_Upsell_Proposal__c =mapOfQuoteNddUcaseToId.get(useCase.toUpperCase()); 
							}else{
								if(blankUseCaseTechSet.contains(productcodeToTechnologyMap.get(Item.sales_item_code))){				  
									String useCase =Item.use_case;	
									upsellItem.SWx_Upsell_Proposal__c =mapOfQuoteNddUcaseToId.get(useCase.toUpperCase());				   
								}else{
									String useCase =Item.use_case;
									system.debug('mapOfQuoteNddUcaseToId.get(Item.use_case)>>'+mapOfQuoteNddUcaseToId.get(useCase.toUpperCase()));
									if(mapOfQuoteNddUcaseToId.containsKey(useCase.toUpperCase())){
										upsellItem.SWx_Upsell_Proposal__c =mapOfQuoteNddUcaseToId.get(useCase.toUpperCase());
									}
								}
							}
						}else{
							if(blankUseCaseTechSet.contains(mapOfSalesItemCodeToTech.get(Item.sales_item_code))){
								upsellItem.SWx_Upsell_Proposal__c =mapOfQuoteNddUcaseToId.get(CSWXGlobalConstant.DS_BLANKString); 
							}else{
								if(blankUseCaseTechSet.contains(productcodeToTechnologyMap.get(Item.sales_item_code))){				  
									upsellItem.SWx_Upsell_Proposal__c =mapOfQuoteNddUcaseToId.get(CSWXGlobalConstant.DS_BLANKString);				   
								}else{
									if(pcodeusecaseMap.containsKey(Item.sales_item_code)){
										String useCase =pcodeusecaseMap.get(Item.sales_item_code);
										system.debug('useCase>>'+useCase);
										if(mapOfQuoteNddUcaseToId.containsKey(useCase.toUpperCase())){
											upsellItem.SWx_Upsell_Proposal__c = mapOfQuoteNddUcaseToId.get(useCase.toUpperCase());
											system.debug('mapOfQuoteNddUcaseToId.get(useCase.toUpperCase())>>'+mapOfQuoteNddUcaseToId.get(useCase.toUpperCase()));
										}				
									}
								}
							}			  
						}						
										
					
				}
				
				
				
				cxmLines.add(upsellItem);
			}
			
			system.debug('cxmLines>>'+cxmLines);					
			
			if(!cxmLines.isEmpty()){
				insert cxmLines;
			}
			
			
			Map<Id,List<SWx_Upsell_Items__c>> dpTolineItemMap = new Map<Id,List<SWx_Upsell_Items__c>>();
			List<SWx_Upsell_Items__c> tempList;
			//create Map<dpID,List<lineItemAssociatedwith DP>>
			for(SWx_Upsell_Items__c ui : [select id,Feature_ID__c,Ready_to_Convert__c,Sales_Item_Code__r.ProductCode,Bundle_ID__r.ProductCode,SWx_Upsell_Proposal__r.Id,Sales_Item_Code_SWx__c,SWx_Upsell_Proposal__c from SWx_Upsell_Items__c where SWx_Upsell_Proposal__c in : dpIdToDPMap.keySet() LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				if(dpTolineItemMap.containsKey(ui.SWx_Upsell_Proposal__c)){
					dpTolineItemMap.get(ui.SWx_Upsell_Proposal__c).add(ui);
				}
				else{
					tempList = new List<SWx_Upsell_Items__c>();
					tempList.add(ui);
					dpTolineItemMap.put(ui.SWx_Upsell_Proposal__c, tempList);
				}
				if(ui.Ready_to_Convert__c==false){
					failedDP.add(ui.SWx_Upsell_Proposal__c);
					dpIdToDPMapCheckBRule.remove(ui.SWx_Upsell_Proposal__c);
				}
			} 
			
			system.debug('failedDP>>'+failedDP);
			system.debug('dpIdToDPMapCheckBRule after remove>>'+dpIdToDPMapCheckBRule);
			//Update Digital Proposal based on 1st business rule(whether product is exist in DB or not)
			Map<String,SWx_Upsell_Proposal__c> dpIdToDPObjMap = updateDPonFailure(failedDP,dpIdToDPMap);
			
			//This method is used to check 2nd and 3rd business rule
			Map<String,SWx_Upsell_Proposal__c> successDPAfterBusinessRuleMap = DS_BusinessRulesCheck_Controller.checkRulesfromStagingObjParserClass(dpIdToDPMapCheckBRule,productCode,ParentAccountID,dpTolineItemMap,ProductOptionComponentList);
			//checkReadyForReview(successDPAfterBusinessRuleMap,listToInsertDp[0].Analytics_File_Refer_ID__c,useCaseToDPId,listToInsertDp[0].DS_Staging__c);
			system.debug('successDPAfterBusinessRuleMap>>'+successDPAfterBusinessRuleMap);
			checkReadyForReview(dpIdToDPMapCheckByPassBRule,listToInsertDp[0].Analytics_File_Refer_ID__c,useCaseToDPId,listToInsertDp[0].DS_Staging__c);
			checkReadyForReview(successDPAfterBusinessRuleMap,listToInsertDp[0].Analytics_File_Refer_ID__c,useCaseToDPId,listToInsertDp[0].DS_Staging__c);
			
			if(!listToInsertDp.isEmpty()){
				stagingObjRec.DP_Status__c = CSWXGlobalConstant.Success;
			}
			else  {
				stagingObjRec.DP_Status__c = CSWXGlobalConstant.Failure;
			}
			
			
			
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_StagingObjParsing ,CSWXGlobalConstant.cxmDPCreation);
			stagingObjRec.DP_Status__c = CSWXGlobalConstant.Failure;
			
			
			
		}
		update stagingObjRec;
	}
	
	
	//Constructor to assign values to class variable
	/******************************************************************************************************
Method Name : DS_StagingObjParsing
parameter   : String jsonPayload,DS_Staging__c stagingObjRec,id AccountID
Created Date:
Created by  : 
Description : This method is used update DP on failure of 1st Business Rule
*********************************************************************************************************/
	public DS_StagingObjParsing(String jsonPayload,DS_Staging__c stagingObjRec,id AccountID,Id ParentAccountID) {
		this.payload = jsonPayload;
		this.stagingObjRec = stagingObjRec;
		this.AccountID = AccountID;
		this.ParentAccountID = ParentAccountID;
		
	}
	
	/******************************************************************************************************
Method Name : checkForDifferentTechnology
parameter   : Map<String,String> productCodeToTechnologyMap
Created Date: 8th Oct 2018(Sprint-15,US:DSI-717)
Created by  : Accenture
Description : This method is used to check whether all useCase belongs to same technology or not
*********************************************************************************************************/  
	public Boolean checkForDifferentTechnology(Map<String,String> productCodeToTechMap) {
		Boolean isDifferent = false;
		List<String> techList = productCodeToTechMap.values();
		try{
			if(productCodeToTechMap.isEmpty() || productCodeToTechMap==null){
				isDifferent=true;
			}else{
				for(Integer i=0;i<techList.size()-1;i++){
					if(techList[i]!=techList[i+1]){
						isDifferent=true;
						break;
					}
					
				}
			}
			return isDifferent; 
		}catch(Exception ex){
			return null;
		}
	}
	
	/******************************************************************************************************
Method Name : checkForFailureDP
parameter   : String productCode, Map<String,String> productcodeToTechnologyMap,Map<String,String> pcodeusecaseMap
Created Date: 10 Oct 2018
Created by  : Accenture
Description : This method is to check whether to DP status is failure or not<SPRINT 15-----DSI:770>
*********************************************************************************************************/  
	public Boolean checkForFailureDP(String productCode, Map<String,String> productcodeToTechnologyMap,Map<String,String> pcodeusecaseMap){
		try{
			Boolean isDPFailure = false;
			if(!productcodeToTechnologyMap.keySet().contains(productCode)){
				isDPFailure =  true; 
			}
			return isDPFailure;
		}catch(Exception ex){
			return null;
		}
	}
	
	/******************************************************************************************************
Method Name : updateDPonFailure
parameter   : Set<String> failedDPRec, Map<String,SWx_Upsell_Proposal__c> dpIdToDPMapRec
Created Date: 20th July 2018
Created by  : Accenture
Description : This method is used update DP on failure of 1st Business Rule
*********************************************************************************************************/  
	public  Map<String,SWx_Upsell_Proposal__c> updateDPonFailure(Set<String> failedDPRec, Map<String,SWx_Upsell_Proposal__c> dpIdToDPMapRec) {
		//Update Digital Proposal based on 1st business rule(whether product is exist in DB or not)
		List<SWx_Upsell_Proposal__c> updateDPList = new List<SWx_Upsell_Proposal__c>(); 
		Map<String,SWx_Upsell_Proposal__c> dpIdToDPObjMap = new Map<String,SWx_Upsell_Proposal__c>();  
		try{
			for(String str: dpIdToDPMapRec.keySet()){
				if(failedDPRec.contains(str)){
					SWx_Upsell_Proposal__c headerObjRec = dpIdToDPMapRec.get(str);
					headerObjRec.Business_Rules_Check__c = CSWXGlobalConstant.RED;
					headerObjRec.Error_Message__c = System.Label.ErrorMessageForProductValidation;
					updateDPList.add(headerObjRec);
					
				}
				else{
					
					dpIdToDPObjMap.put(str, dpIdToDPMapRec.get(str));					
				}
			} 
			
			
			update updateDPList;
			
			sendChatterMessageToAM(updateDPList);
			return dpIdToDPMapRec;
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_StagingObjParsing ,CSWXGlobalConstant.updateDPonFailure);
			return null; 
		}		   
	}
	
	/******************************************************************************************************
Method Name : sendChatterMessageToAM
parameter   : List<SWx_Upsell_Proposal__c> dpList
Created Date: 20th July 2018
Created by  : Accenture
Description : Send Chatter Message to Account Manager
*********************************************************************************************************/		  
	public static void sendChatterMessageToAM(List<SWx_Upsell_Proposal__c> dpList) {
		
		try{
			List<FeedItem> feedItemList = new List<FeedItem>();  
			
			for(SWx_Upsell_Proposal__c dpObj : dpList){
				//DSI-1252,Sprint 21 - Removed the analytic resource  dependency
				if(dpObj.Upsell_Status__c == CSWXGlobalConstant.draft && dpObj.Analytics_Source__c != null ){
					
				   /* String MessagePartOne = dpObj.Name + CSWXGlobalConstant.msgPartTwo + dpObj.Account_ID__r.Name+ CSWXGlobalConstant.msgPartThree;
					
					String MessagePartTwo = CSWXGlobalConstant.msgPartFour  +dpObj.Name+ CSWXGlobalConstant.msgPartFive;*/
					
					String DPURL = URL.getSalesforceBaseUrl().toExternalForm()+ CSWXGlobalConstant.slash + dpObj.Id; 
					
					String accountURL = URL.getSalesforceBaseUrl().toExternalForm()+ CSWXGlobalConstant.slash + dpObj.Account_ID__c;
					
					String Message =  CSWXGlobalConstant.helloMessage + dpObj.Account_ID__r.Owner.FirstName +  dpObj.Account_ID__r.Owner.LastName+','+ dpObj.Name+CSWXGlobalConstant.DPMsgPart1 + dpObj.Account_ID__r.Name+ CSWXGlobalConstant.DPMsgPart2;
					
					FeedItem myPost = new FeedItem(); 
					myPost.Parentid = dpObj.Account_ID__r.OwnerId; //Record Id
					myPost.body = Message +  CSWXGlobalConstant.DPLink  +DPURL + CSWXGlobalConstant.accountLink +accountURL;
					feedItemList.add(myPost);
					
					
					
				}
				/*else if(dpObj.Upsell_Status__c == CSWXGlobalConstant.draft && dpObj.Analytics_Source__c == CSWXGlobalConstant.SourceID_RMP){
					
					String helloMessage = CSWXGlobalConstant.helloMessage;
					String remainingMessage = CSWXGlobalConstant.remainingMessage;
					String SecondMessage = CSWXGlobalConstant.SecondMessage;
					FeedItem myPost = new FeedItem(); 
					String DPURL = URL.getSalesforceBaseUrl().toExternalForm()+ CSWXGlobalConstant.slash + dpObj.Id; 
					myPost.Parentid = dpObj.Account_ID__r.OwnerId; //Record Id
					myPost.body = helloMessage + dpObj.Account_ID__r.Owner.FirstName + dpObj.Account_ID__r.Owner.LastName  + SecondMessage + dpObj.Name + remainingMessage + CSWXGlobalConstant.DPLink  +DPURL;
					feedItemList.add(myPost);
					
				}*/
				else{
					String Message = dpObj.Name + CSWXGlobalConstant.msgPartSix +dpObj.Account_ID__r.Name;
					FeedItem myPost = new FeedItem(); 
					myPost.Parentid = dpObj.Account_ID__r.OwnerId; //Record Id
					String DPURL = URL.getSalesforceBaseUrl().toExternalForm()+CSWXGlobalConstant.slash+ dpObj.Id;   
					String accountURL = URL.getSalesforceBaseUrl().toExternalForm()+ CSWXGlobalConstant.slash+ dpObj.Account_ID__c;
					myPost.body = Message +CSWXGlobalConstant.DPLink+DPURL+CSWXGlobalConstant.accountLink+accountURL;
					feedItemList.add(myPost);
					
				}
			}
			insert feedItemList;  
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_StagingObjParsing ,CSWXGlobalConstant.sendChatterMessageToAM);
		}
	}
	
	/******************************************************************************************************
Method Name : checkReadyForReview
parameter   : Map<String,SWx_Upsell_Proposal__c> dpMap,String analyticalFileRefId,Map<String,String> useCaseToDPId
Created Date: 20th July 2018
Created by  : Accenture
Description : /Check whether DP is already exist in database with same combination(Analytics File Reference ID + Use Case)
*********************************************************************************************************/		  
	public void checkReadyForReview(Map<String,SWx_Upsell_Proposal__c> dpMap,String analyticalFileRefId,Map<String,String> useCaseToDPId,String DSStagingId){
		
		try{
			system.debug('dpMap checkReadyForReview>>'+dpMap);
			system.debug('analyticalFileRefId checkReadyForReview>>'+analyticalFileRefId);
			system.debug('useCaseToDPId checkReadyForReview>>'+useCaseToDPId);
			//Stores existing DP from database which has((Analytics File Reference ID + Use Case))
			List<SWx_Upsell_Proposal__c> listobj = [Select id, Use_Case__c,Analytics_File_Refer_ID__c from SWx_Upsell_Proposal__c where (Use_Case__c  IN : useCaseToDPId.keySet() AND Analytics_File_Refer_ID__c = :analyticalFileRefId AND ID NOT IN :dpMap.keySet() AND Account_ID__c =:ParentAccountID AND DS_Staging__c !=:DSStagingId) LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
			system.debug('listobj checkReadyForReview>>>'+listobj);
			List<SWx_Upsell_Proposal__c> listobjToInsertSuccess = new List<SWx_Upsell_Proposal__c>();
			List<SWx_Upsell_Proposal__c> listobjToInsertFailed= new List<SWx_Upsell_Proposal__c>();
			
			Set<String> existingUseCse= new Set<String>();
			
			//create Set<Usecase>
			for(SWx_Upsell_Proposal__c obj:listobj){
				existingUseCse.add(obj.Use_Case__c);
				
			}
			system.debug('existingUseCse>>'+existingUseCse);
			
			//Update Upsell Status of DP to Ready for Review if DP is not exist 
			for(String key: dpMap.KeySet()){
				SWx_Upsell_Proposal__c swxObj = dpMap.get(key);
				if(existingUseCse.contains(swxObj.Use_Case__c)){
					system.debug('swxObj>>'+swxObj);
					listobjToInsertFailed.add(swxObj);
					
				}
				else{
					
					swxObj.Upsell_Status__c = CSWXGlobalConstant.readyForReview;
					if(swxObj.Entitlement_Info__c==CSWXGlobalConstant.CanBeEntitled){
						swxObj.Error_Message__c = CSWXGlobalConstant.Blank;
						swxObj.Ready_to_Convert__c = true;   
						swxObj.Business_Rules_Check__c = CSWXGlobalConstant.GREEN;
					}
					listobjToInsertSuccess.add(swxObj);
					
				}
				
			}
			
			system.debug('before analytics check>>'+listobjToInsertSuccess);
			
			update listobjToInsertSuccess;
			system.debug('after insert >>>>'+listobjToInsertSuccess);
			sendChatterMessageToAM(listobjToInsertSuccess);
			sendChatterMessageToAM(listobjToInsertFailed);
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_StagingObjParsing ,CSWXGlobalConstant.checkReadyForReview);
		}
	}
	
	/******************************************************************************************************
Method Name : fetchTechnology 
parameter   : Set<String> failedDPRec, Map<String,SWx_Upsell_Proposal__c> dpIdToDPMapRec
Created Date: 20th July 2018
Created by  : Accenture
Description : This method is used fetch Tech based on Entitlement status of DP
*********************************************************************************************************/  
	public String fetchTechnology(String salesItemCode,Map<String,String> productcodeToTechnologyMap,Map<String,String> pcodeusecaseMap,String sourceId,String entitlementStatus,Map<String,Commercial_Entitlement__c> pCodeToComEntitleMap) {
		
		//try{
		system.debug('salesItemCode>>'+salesItemCode);
		system.debug('productcodeToTechnologyMap>>'+productcodeToTechnologyMap);
		system.debug('pcodeusecaseMap>>'+pcodeusecaseMap);
		system.debug('sourceId>>'+sourceId);
		system.debug('entitlementStatus>>'+entitlementStatus);
		system.debug('pCodeToComEntitleMap>>'+pCodeToComEntitleMap);
		
		String technology ;
		String strTest = sourceId;
		String[] arrTest = strTest.split(CSWXGlobalConstant.dash);
		
		system.debug('arrTest.size()>>'+arrTest.size());
		if(arrTest.size()>=3){									//Check if Technology is Blank or not	
			System.debug('arrTest[1]--->'+arrTest[1]);   
			if(arrTest[1]!=CSWXGlobalConstant.Blank){								   //Technology is not blank in JSON,therefore assign technology from JSON  
				technology = arrTest[1];
			}else if(arrTest[1]==CSWXGlobalConstant.Blank && entitlementStatus==CSWXGlobalConstant.CanBeEntitled){							 //Technology is blank in JSON,therefore assign technology from MasterData  
				technology = pCodeToComEntitleMap.get(salesItemCode).Technology__c;
				
				/*Boolean isDifferentTechnology = checkForDifferentTechnology(productcodeToTechnologyMap);
				
				if(isDifferentTechnology){
					
					CustomException CustomEx = new CustomException(GlobalConstants.ERROR_TEXT);
					throw CustomEx; 
				}
				
				Boolean isDPFailure = checkForFailureDP(salesItemCode,productcodeToTechnologyMap,pcodeusecaseMap);   //Check if Product is Not present in Product Catalogue ,if not present throw exception
				System.debug('isDPFailure --->'+isDPFailure);
				if(isDPFailure){
					
					CustomException CustomEx = new CustomException(GlobalConstants.ERROR_TEXT);
					throw CustomEx; 
				}*/
			}else if(arrTest[1]==CSWXGlobalConstant.Blank && entitlementStatus==CSWXGlobalConstant.QuoteNeeded){							 //Technology is blank in JSON,therefore assign technology from MasterData  
				technology = productcodeToTechnologyMap.get(salesItemCode);
				Boolean isDifferentTechnology = checkForDifferentTechnology(productcodeToTechnologyMap);
				
				if(isDifferentTechnology){
					
					CustomException CustomEx = new CustomException(GlobalConstants.ERROR_TEXT);
					throw CustomEx; 
				}
				Boolean isDPFailure = checkForFailureDP(salesItemCode,productcodeToTechnologyMap,pcodeusecaseMap);   //Check if Product is Not present in Product Catalogue ,if not present throw exception
				System.debug('isDPFailure --->'+isDPFailure);
				if(isDPFailure){
					
					CustomException CustomEx = new CustomException(GlobalConstants.ERROR_TEXT);
					throw CustomEx; 
				}
			} 
		}else{
			system.debug('arrTest.size()-->>'+arrTest.size());
			system.debug('entitlementStatus-->>'+entitlementStatus);
			system.debug('arrTest[0]-->>'+arrTest[0]);
			
			if(arrTest.size()==2 && entitlementStatus==CSWXGlobalConstant.CanBeEntitled){   //Check if Technology is Blank or not,if blank assign from MasterData  
				system.debug('in can be entitled');
				technology = pCodeToComEntitleMap.get(salesItemCode).Technology__c;
				/*Boolean isDifferentTechnology = checkForDifferentTechnology(productcodeToTechnologyMap);
				
				if(isDifferentTechnology){
					
					CustomException CustomEx = new CustomException(GlobalConstants.ERROR_TEXT);
					throw CustomEx; 
				}*/
			}else if(arrTest.size()==2 && entitlementStatus==CSWXGlobalConstant.QuoteNeeded){
				system.debug('quote needed');
				technology = productcodeToTechnologyMap.get(salesItemCode);
				Boolean isDifferentTechnology = checkForDifferentTechnology(productcodeToTechnologyMap);
				system.debug('isDifferentTechnology>>'+isDifferentTechnology);
				if(isDifferentTechnology){
					
					CustomException CustomEx = new CustomException(GlobalConstants.ERROR_TEXT);
					throw CustomEx; 
				}
			}
		}
		
		
		return technology;
		/*}catch(Exception ex){
ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_StagingObjParsing ,CSWXGlobalConstant.updateDPonFailure);
return null; 
}*/		   
	}
	
	/******************************************************************************************************
Method Name : getUseCase
parameter   : String tech,String useCasevalue,String salesitemcode,Map<String,String> productcodeToTechnologyMap,Map<String,String> pcodeusecaseMap
Created Date: 09th Jan 2019
Created by  : Accenture
Description : This method run logic based Tech value for Usecase
*********************************************************************************************************/  
	public  String fetchUseCase(String tech,String useCasevalue,String salesitemcode,Map<String,String> productcodeToTechnologyMap,Map<String,String> pcodeusecaseMap,String entitlementStatus,Map<String,Commercial_Entitlement__c> pCodeToComEntitleMap,String sourceId) {
		//Check tech and return usecase value
		String strTest = sourceId;
		String[] arrTest = strTest.split(CSWXGlobalConstant.dash);
		system.debug('tech>>'+tech);
		system.debug('useCasevalue>>'+useCasevalue);
		system.debug('salesitemcode>>'+salesitemcode);
		system.debug('productcodeToTechnologyMap>>'+productcodeToTechnologyMap);
		system.debug('pcodeusecaseMap>>'+pcodeusecaseMap);
		Map<String,DSBlanKUseCaseTechnology__c> blankUseCaseTech =DSBlanKUseCaseTechnology__c.getAll();
		Set<String> blankUseCaseTechSet = blankUseCaseTech.keySet();
		system.debug('blankUseCaseTech>>'+blankUseCaseTech);
		system.debug('blankUseCaseTechSet>>'+blankUseCaseTechSet);
		String useCaseReturn;
		
		// try{
		if(!blankUseCaseTechSet.contains(tech)){
			if(useCasevalue!=CSWXGlobalConstant.Blank && useCasevalue != null){
				useCaseReturn = useCasevalue;
				system.debug('useCaseReturn'+useCaseReturn);
			}else if(entitlementStatus==CSWXGlobalConstant.CanBeEntitled){		   //Check if UseCase is Blank or not
				system.debug('usecase blank entitled dp');
				if(blankUseCaseTechSet.contains(productcodeToTechnologyMap.get(salesitemcode))){
					useCaseReturn=useCasevalue;
					system.debug('useCase>>'+useCase);
				}else{
					system.debug('pCodeToComEntitleMap.get(salesItemCode).Use_Case__c>>'+pCodeToComEntitleMap.get(salesItemCode).Use_Case__c);
					useCaseReturn =  pCodeToComEntitleMap.get(salesItemCode).Use_Case__c;			
				   /* Boolean isDPFailure = checkForFailureDP(salesItemCode,productcodeToTechnologyMap,pcodeusecaseMap);   //Check if Product is Not present in Product Catalogue ,if not present throw exception
					System.debug('isDPFailure --->'+isDPFailure);
					if(isDPFailure){
						CustomException CustomEx = new CustomException(GlobalConstants.ERROR_TEXT);
						throw CustomEx; 
					}*/
				}
				
			}else if(entitlementStatus==CSWXGlobalConstant.QuoteNeeded){		   //Check if UseCase is Blank or not
				system.debug('usecase blank quote needed dp');
				if(blankUseCaseTechSet.contains(productcodeToTechnologyMap.get(salesitemcode))){
					useCaseReturn=useCasevalue;
					system.debug('useCase>>'+useCase);
				}else{		  
					useCaseReturn =  pcodeusecaseMap.get(salesItemCode);
					Boolean isDPFailure = checkForFailureDP(salesItemCode,productcodeToTechnologyMap,pcodeusecaseMap);   //Check if Product is Not present in Product Catalogue ,if not present throw exception
					System.debug('isDPFailure --->'+isDPFailure);
					if(isDPFailure){
						CustomException CustomEx = new CustomException(GlobalConstants.ERROR_TEXT);
						throw CustomEx; 
					}
				}
			}
			
		}else{
			
			if(blankUseCaseTechSet.contains(tech)){
				
				useCaseReturn=  useCasevalue;  
				
			}
		}
		
		
		return useCaseReturn;
		
		/*}catch(Exception ex){
ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_StagingObjParsing ,CSWXGlobalConstant.updateDPonFailure);
return null; 
}  */		  
	}  
	
	
	/*****************************
*Class Name: InboundRequest
*Description: This class will process the SWx line items
*******************************/  
	global without sharing class InboundRequest
	{
		SWx_Upsell_Proposal header;
		List<LineItems> line_items;
		List<LineItems> sales_item_code;
	}
	
	/*****************************
*Class Name: SWx_Upsell_Proposal
*Description: This class will process the tags of the header Json file
*******************************/
	global without sharing class SWx_Upsell_Proposal{
		public String source_id;
		public String file_reference_id;
		public String account_id {get;set;}
		public String strcreation_date;
		public Date creation_date;
		public String category_Type;
		public Integer P20_ID;
		public String dolCurrency;
		public Decimal Unweighted_Value;
		public Date start_date;
		public Date end_date;
		public Integer cell_quantity;
		public Integer scope;
		
	}	
	
	
	
	/*****************************
*Class Name: LineItems
*Description: This class will process the line item tags
*******************************/
	global without sharing class LineItems{
		//CXM Lines
		public String bundle_id; 
		public String sales_item_code;
		public Integer quantity;
		public string use_case;
	}  
	
	
}