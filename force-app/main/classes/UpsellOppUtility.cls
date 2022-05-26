/*******************************
Class Name: UpsellOppUtility
Created By: Accenture
Created Date: 19th Sept 2017
Description: Utility Class for Upsell opportunity creation
*******************************/
public inherited sharing class UpsellOppUtility 
{
	public static boolean firstRun = true;
	public static boolean opptyMaster = false;
	public static boolean bDealExist = false ;
	public static String strTemplateIdentifier = GlobalConstants.TEMPLATEIDENTIFIER_G5;
	
	/*****************************
*Method Name: toCreateUpsellOpportunity
*Description: This method filter the trigger list and remove all irrelavant upsellContainer records for upsell opportunity creation
*Parameters: Opportunity List
*******************************/	
	public static void toCreateUpsellOpportunity(Set<Id> parentOppIdSet)
	{   
		Map<Id,String> upsellWithoutOppIdMap = new Map<Id,String>();
		Map<Id,String> upsellWithInvalidOppIdMap = new Map<Id,String>();
		Map<Id,String> upsellWithMainOppIdMap = new Map<Id,String>();
		Set<String> upsellWithMainOppIdSet = new Set<String>();
		Set<Id> oppRecToCreatDealSet = new Set<Id>();
		Set<Id> upsellOppParentOppIdSet = new Set<Id>();
		Set<String> actualOppNumberSet = new Set<String>();
		Set<String> excistingOppNumberSet = new Set<String>();
		Set<ID> newUpsellOppIdSet = new Set<ID>();		
		Map<Id,Id> masterOppIdDealIdMap = new Map<Id,Id>();
		List<Opportunity> newUpsellOppList = new List<Opportunity>();
		List<Upsell_Container__c> updatedUpsellContainerList = new List<Upsell_Container__c>();
		Map<String, Upsell_Container__c> upsellNameContainerRecMap = new Map<String, Upsell_Container__c>();
		Set<String> toAvoidUpsellRecSet = new Set<String>();
		Set<String> parentOppNumberSet = new Set<String>();
		List<Upsell_Container__c> filteredUpsellContainerList = new List<Upsell_Container__c>();
		List<Upsell_Container__c> toCreateUpsellOIFList = new List<Upsell_Container__c>();	  
		
		try
		{
			Id upsellDealRecTypeId = Schema.SObjectType.Deal__C.getRecordTypeInfosByDeveloperName().get(GlobalConstants.UPSELL_DEAL_RECORD_TYPE).getRecordTypeId();
			
			filteredUpsellContainerList = [SELECT Id,Upsell_Opportunity__c,Parent_Opportunity__r.Opportunity_ID__c,Parent_Opportunity__r.OwnerId,Parent_Opportunity__r.Org_L4__c,Quarter1_Period_Value__c,Quarter2_Period_Value__c,Quarter3_Period_Value__c,
					 Quarter4_Period_Value__c,Quarter1_Period__c ,Quarter2_Period__c ,Quarter3_Period__c ,Quarter4_Period__c ,
					 Quarter1_Reverse_Period__c ,Quarter2_Reverse_Period__c ,Quarter3_Reverse_Period__c ,Quarter4_Reverse_Period__c ,
					 Parent_Opportunity__r.Legal_Entity__c,Parent_Opportunity__r.AccountId,Parent_Opportunity__r.Contract_Signing_Entity__c,
					 Parent_Opportunity__r.CurrencyIsoCode,Parent_Opportunity__r.RecordTypeId,Upsell_Opportunity_Main_BG__c,
					 Upsell_Opportunity_Main_BL__c,Upsell_Opportunity_Main_BU__c,Parent_Offer__c,Parent_Opportunity__c,
					 Upsell_Opportunity_Name__c,Upsell_Opportunity_Number__c 
					 FROM Upsell_Container__c WHERE Template_Identifier__c=: GlobalConstants.TEMPLATEIDENTIFIER_G5 and Upsell_Opportunity_Type__c =: GlobalConstants.COMMITTED_UPSELL and Parent_Offer__r.ActiveOffer__c  =: true and Parent_Opportunity__c IN: parentOppIdSet];	
			if(filteredUpsellContainerList.size() == 0)
			{
	filteredUpsellContainerList = [SELECT Id,Upsell_Opportunity__c,Parent_Opportunity__r.Opportunity_ID__c,Parent_Opportunity__r.OwnerId,Parent_Opportunity__r.Org_L4__c,Quarter1_Period_Value__c,Quarter2_Period_Value__c,Quarter3_Period_Value__c,
					 Quarter4_Period_Value__c,Quarter1_Period__c ,Quarter2_Period__c ,Quarter3_Period__c ,Quarter4_Period__c ,
					 Quarter1_Reverse_Period__c ,Quarter2_Reverse_Period__c ,Quarter3_Reverse_Period__c ,Quarter4_Reverse_Period__c ,
					 Parent_Opportunity__r.Legal_Entity__c,Parent_Opportunity__r.AccountId,Parent_Opportunity__r.Contract_Signing_Entity__c,
					 Parent_Opportunity__r.CurrencyIsoCode,Parent_Opportunity__r.RecordTypeId,Upsell_Opportunity_Main_BG__c,
					 Upsell_Opportunity_Main_BL__c,Upsell_Opportunity_Main_BU__c,Parent_Offer__c,Parent_Opportunity__c,
					 Upsell_Opportunity_Name__c,Upsell_Opportunity_Number__c 
					 FROM Upsell_Container__c WHERE Template_Identifier__c=: GlobalConstants.TEMPLATEIDENTIFIER_G4 and Upsell_Opportunity_Type__c =: GlobalConstants.COMMITTED_UPSELL and Parent_Offer__r.ActiveOffer__c  =: true and Parent_Opportunity__c IN: parentOppIdSet];	
	strTemplateIdentifier = GlobalConstants.TEMPLATEIDENTIFIER_G4;
			}

			for(Upsell_Container__c upsellContainerRec : filteredUpsellContainerList)
			{
	if(upsellContainerRec.Upsell_Opportunity_Number__c == null)			
	{	
		upsellWithoutOppIdMap.put(upsellContainerRec.Id,upsellContainerRec.Upsell_Opportunity_Name__c);
	}
	upsellOppParentOppIdSet.add(upsellContainerRec.Parent_Opportunity__c);
	actualOppNumberSet.add(upsellContainerRec.Upsell_Opportunity_Number__c); 
	parentOppNumberSet.add(upsellContainerRec.Parent_Opportunity__r.Opportunity_ID__c);
			} 
			for(Opportunity oppRec : [Select Id,Opportunity_ID__c,Business_Type__c from Opportunity where Opportunity_ID__c IN: actualOppNumberSet])
			{
	if(oppRec.Opportunity_ID__c != null)
	{
		if(parentOppNumberSet.contains(oppRec.Opportunity_ID__c))
		{
			upsellWithMainOppIdSet.add(oppRec.Opportunity_ID__c);  
		}
		else
		{		
			excistingOppNumberSet.add(oppRec.Opportunity_ID__c);	
		}
		
	}	 
			}

			for(Upsell_Container__c upsellContainRec : filteredUpsellContainerList)
			{
	if(upsellWithMainOppIdSet.contains(upsellContainRec.Upsell_Opportunity_Number__c))
	{
		upsellWithMainOppIdMap.put(upsellContainRec.Id, upsellContainRec.Upsell_Opportunity_Number__c);
	}
			}
			for(Upsell_Container__c upsellContainRec : filteredUpsellContainerList)
			{
	if(!excistingOppNumberSet.contains(upsellContainRec.Upsell_Opportunity_Number__c) && !upsellWithMainOppIdSet.contains(upsellContainRec.Upsell_Opportunity_Number__c) && upsellContainRec.Upsell_Opportunity_Number__c !=null)
	{
		upsellWithInvalidOppIdMap.put(upsellContainRec.Id,upsellContainRec.Upsell_Opportunity_Number__c);
	}
			}

			for(Upsell_Container__c upsellContainerRec : filteredUpsellContainerList)
			{
	if(!excistingOppNumberSet.contains(upsellContainerRec.Upsell_Opportunity_Number__c))
	{   
		if(!toAvoidUpsellRecSet.contains(upsellContainerRec.Upsell_Opportunity_Name__c))
		{
			upsellNameContainerRecMap.put(upsellContainerRec.Upsell_Opportunity_Name__c, upsellContainerRec);
			oppRecToCreatDealSet.add(upsellContainerRec.Parent_Opportunity__c);		
		}	
	}
	else
	{	 
		toAvoidUpsellRecSet.add(upsellContainerRec.Upsell_Opportunity_Name__c);
		if(upsellNameContainerRecMap.containsKey(upsellContainerRec.Upsell_Opportunity_Name__c)) 
		{			
			upsellNameContainerRecMap.remove(upsellContainerRec.Upsell_Opportunity_Name__c);			 
		}
	}
			}		
		
			
			map<id,id> mapIDOpptyDealMaster = new map<id,id>();
			for(Opportunity_Group__c objOpptyGroup : [Select Id,Opportunity__c,Deal__c from Opportunity_Group__c where  Opportunity__c IN: parentOppIdSet AND Opportunity_Relation__c =:GlobalConstants.MASTER])
			{
	mapIDOpptyDealMaster.put(objOpptyGroup.Opportunity__c,objOpptyGroup.Deal__c);
			}   
			
			map<id,id> mapIDOpptyDealRelative = new map<id,id>();
			
			for(Opportunity_Group__c objOpptyGroupRelative : [Select Id,Opportunity__c from Opportunity_Group__c where Opportunity__r.Is_Auto_Upsell__c=: true AND  Deal__c IN: mapIDOpptyDealMaster.values() AND Opportunity_Relation__c =: GlobalConstants.SUBORDINATE])
			{
	mapIDOpptyDealRelative.put(objOpptyGroupRelative.Opportunity__c,objOpptyGroupRelative.Deal__c);
			}   
			
			if(mapIDOpptyDealRelative.isEmpty())
			{
	if(mapIDOpptyDealMaster.isEmpty())
	{	
					//Creating Deal
					masterOppIdDealIdMap = upsellDealCreation(oppRecToCreatDealSet);
					groupOpptyCreation(masterOppIdDealIdMap);
					bDealExist = false;
	}  
	else
	{
		bDealExist = true;
					OpptyMaster = true;
		masterOppIdDealIdMap = mapIDOpptyDealMaster;
	}

	//Creating Upsell Opportunity
	newUpsellOppList = createUpsellOppty(upsellNameContainerRecMap.values(), masterOppIdDealIdMap);
	for(Opportunity oppRec : newUpsellOppList)
	{
		newUpsellOppIdSet.add(oppRec.Id);
	}

	//Update Upsell Container records	
	updatedUpsellContainerList = updateUpsellContainerRec(newUpsellOppList,parentOppIdSet);		
	
	toCreateUpsellOIFList = [Select Id,Upsell_Opportunity__c,Parent_Offer__r.ActiveOffer__c, Upsell_Opportunity_Main_BL__c,Quarter1_Period__c,
				 Quarter1_Period_Value__c,Quarter2_Period__c,Quarter2_Period_Value__c,Quarter3_Period__c,
				 Quarter3_Period_Value__c,Quarter4_Period__c,Quarter4_Period_Value__c,
				 Quarter1_Reverse_Period__c,Quarter2_Reverse_Period__c,Quarter3_Reverse_Period__c,
				 Quarter4_Reverse_Period__c,Parent_Opportunity__r.Org_L4__c,Total_Year_Sales__c  
				 from Upsell_Container__c Where Template_Identifier__c=:strTemplateIdentifier AND Upsell_Opportunity__c IN: newUpsellOppIdSet and Parent_Offer__r.ActiveOffer__c =: true];		

	//OIF Creation			
	createOIFforUpsellOpp(toCreateUpsellOIFList);
	
				OpportunityTriggerHelper OpptTrigHelper = new OpportunityTriggerHelper();
				OpptTrigHelper.BatchCurrenychange(newUpsellOppIdSet);
				
	//Chatter Post
	sendChatterToUpsellOppOwner(updatedUpsellContainerList,upsellWithInvalidOppIdMap,upsellWithoutOppIdMap,upsellWithMainOppIdMap); 
	
			}		
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, UpsellOpportunityUtility.class.getName(), GlobalConstants.METHOD_TO_CREATE_UPSELL_OPPORTUNITY);	  
		}	  
	}
	
	/*****************************
*Method Name: upsellDealCreation
*Description: This method is to create deal for master opportunity of upsell opportunity
*Parameters: Map<id,Opportunity>
*******************************/
	public static Map<Id,Id> upsellDealCreation (Set<Id> oppRecToCreatDealSet)
	{
		List<Deal__c> toCreateDealList = new List<Deal__c>(); 
		Deal__c dealRec;		
		Map<Id,Id> masterOppIdDealIdMap = new Map<Id,Id>();
		Map<Id,Deal__c> masterOppIdDealMap = new Map<Id,Deal__c>();
		try
		{
			// Added OwnerId field in SOQL to assign Master Opportunity OwnerId to Upsell Deal & Upsell Opportunity SF #00008588
			Map<Id,Opportunity> upSellCreationMap = New Map<Id,Opportunity>([Select Id ,OwnerId, Name from Opportunity where Id IN: oppRecToCreatDealSet]);
			Id upsellDealRecTypeId = Schema.SObjectType.Deal__C.getRecordTypeInfosByDeveloperName().get(GlobalConstants.UPSELL_DEAL_RECORD_TYPE).getRecordTypeId();
			for(Id masterOppId : oppRecToCreatDealSet)
			{
	dealRec = new Deal__c();
	dealRec.RecordTypeId = upsellDealRecTypeId;
	dealRec.OwnerId =  upSellCreationMap.get(masterOppId).OwnerId;
	dealRec.Name = GlobalConstants.UPSELL_DEAL+GlobalConstants.SPACE+GlobalConstants.HYPHEN+GlobalConstants.SPACE+upSellCreationMap.get(masterOppId).Name;
	toCreateDealList.add(dealRec);
	masterOppIdDealMap.put(masterOppId, dealRec);
			}
			Database.insert(toCreateDealList);		
			for(Id masterOpptyId : masterOppIdDealMap.keyset())
			{
	masterOppIdDealIdMap.put(masterOpptyId,masterOppIdDealMap.get(masterOpptyId).Id);
			}
		}		
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, UpsellOpportunityUtility.class.getName(), GlobalConstants.METHOD_UPSELL_DEAL_CREATION);	 
		} 
		return masterOppIdDealIdMap;
	}
	

/*****************************
*Method Name: groupOpptyCreation
*Description: This method Will create the Group-Opportunity Record 
*Parameters: Map<Id,Id>
*******************************/	
	public static void groupOpptyCreation (Map<Id,Id> mapOpptyDealID)
	{
		Opportunity_Group__c objOpptyGroup = new Opportunity_Group__c();
		list<Opportunity_Group__c> lstOpptyGroup = new List<Opportunity_Group__c>();
		try 
		{
			if(mapOpptyDealID.size() > 0)
			{
	for(Id objID : mapOpptyDealID.keyset())
	{
		objOpptyGroup = new Opportunity_Group__c();
		objOpptyGroup.Deal__c = mapOpptyDealID.get(objID);
		objOpptyGroup.Opportunity__c = objID;
		if(OpptyMaster == false && bDealExist == false)
		{
			objOpptyGroup.Opportunity_Relation__c = GlobalConstants.MASTER;
			OpptyMaster = true;
		}
		else if(OpptyMaster == true)
			objOpptyGroup.Opportunity_Relation__c = GlobalConstants.SUBORDINATE;
		lstOpptyGroup.add(objOpptyGroup);
	}
			}
			database.insert(lstOpptyGroup);
		}		
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, UpsellOpportunityUtility.class.getName(), GlobalConstants.METHOD_UPSELL_DEAL_CREATION);	 
		} 
		
	}
	
	/*****************************
*Method Name: createUpsellOppty
*Description: This method is to create OIF lines for upsell opportunity
*Parameters: List<Upsell_Container__c>, Map<Id,Id>
*******************************/
	public static List<Opportunity> createUpsellOppty(List<Upsell_Container__c> upsellContainerRec,Map<Id,Id> parentOppIdDealIdMap)
	{		
		Map<String,List<Upsell_Container__c>> upsellNameAndContainerRec = new Map<String,List<Upsell_Container__c>>();
		List<Opportunity> upsellOpptyLst = new List<Opportunity>();
		List<Opportunity> newlyCreatedOppList = new List<Opportunity>();
		List<Upsell_Container__c> tempUpsellRec ;
		map<id,List<opportunity>> mapDealIdOppty = new map<id,List<opportunity>>();
		try
		{
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES  = true;
			for(Upsell_Container__c upsellRec : upsellContainerRec)
			{			
	if(upsellNameAndContainerRec.containsKey(upsellRec.Upsell_Opportunity_Name__c))
	{
		upsellNameAndContainerRec.get(upsellRec.Upsell_Opportunity_Name__c).add(upsellRec);
	}
	else
	{
		tempUpsellRec = new List<Upsell_Container__c>();
		tempUpsellRec.add(upsellRec);
		upsellNameAndContainerRec.put(upsellRec.Upsell_Opportunity_Name__c,tempUpsellRec);
	}	
	
			}
			mapDealIdOppty = createUpsellOpptyRecord(upsellNameAndContainerRec,parentOppIdDealIdMap);
			for(ID objDealId : mapDealIdOppty.keyset())
			{
	for(opportunity objOppty : mapDealIdOppty.get(objDealId))
	{
		newlyCreatedOppList.add(objOppty);
	}
			}
			database.insert(newlyCreatedOppList);
			map<id,id> mapOpptyIDDealID = new map<id,id>();
			for(ID objDealId : mapDealIdOppty.keyset())
			{
	for(opportunity objOppty : mapDealIdOppty.get(objDealId))
	{
		mapOpptyIDDealID.put(objOppty.id,objDealId);
	}
			}
			groupOpptyCreation(mapOpptyIDDealID);
	upsellOpptyLst = [Select id, name,Opportunity_ID__c from Opportunity where Id IN: mapOpptyIDDealID.keyset()];
			
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, UpsellOpportunityUtility.class.getName(), GlobalConstants.METHOD_CREATE_UPSELL_OPPTY);	  
		} 
		return upsellOpptyLst;
	}
	
	/*****************************
*Method Name: createUpsellOpptyRecord
*Description: This method is to create upsell opportunity records for master opportunity
*Parameters: Map<String,List<Upsell_Container__c>> , Map<Id,Id> 
*******************************/
	public static map<id,List<opportunity>> createUpsellOpptyRecord(Map<String,List<Upsell_Container__c>> upsellNameAndContainerRec,Map<Id,Id> parentOppIdDealIdMap)
	{
		List<Upsell_Container__c> upsellContainerValues = new List<Upsell_Container__c>();
		List<Opportunity> upsellOpptyLst = new List<Opportunity>();
		map<id,List<opportunity>> mapDealIDOppty = new map<id,List<opportunity>>();
		Opportunity opptyRec = new Opportunity();
		try
		{
			for(String upsellKey : upsellNameAndContainerRec.keySet())
			{
	opptyRec = new Opportunity();
	upsellContainerValues = upsellNameAndContainerRec.get(upsellKey);
	opptyRec.AccountId = upsellContainerValues[0].Parent_Opportunity__r.AccountId;
	//Modifying Amount value because of a validation rule amount cannot be less than 10000
	opptyRec.Amount = 10010 ;
	opptyRec.ownerId = upsellContainerValues[0].Parent_Opportunity__r.OwnerId ;
	opptyRec.Business_Type__c = GlobalConstants.COMMITTED_UPSELL;
	opptyRec.CloseDate = system.today();
	opptyRec.Contract_Signing_Entity__c = upsellContainerValues[0].Parent_Opportunity__r.Contract_Signing_Entity__c;
	opptyRec.CurrencyIsoCode = upsellContainerValues[0].Parent_Opportunity__r.CurrencyIsoCode;
	opptyRec.Legal_Entity__c = upsellContainerValues[0].Parent_Opportunity__r.Legal_Entity__c;
	opptyRec.Name = upsellContainerValues[0].Upsell_Opportunity_Name__c; 
	opptyRec.Phase_Status__c = GlobalConstants.OPPORTUNITY_IN_PROGRESS;
	opptyRec.RecordTypeId = upsellContainerValues[0].Parent_Opportunity__r.RecordTypeId; 
	opptyRec.StageName = GlobalConstants.DEVELOP_OPPORTUNITY;
	opptyRec.Lead_BG__c = upsellContainerValues[0].Upsell_Opportunity_Main_BG__c;
	opptyRec.Lead_BU__c = upsellContainerValues[0].Upsell_Opportunity_Main_BU__c;
	opptyRec.G2_Planned_Date__c = system.today();
	opptyRec.Is_Auto_Upsell__c = true;
	//D-4426 fix
	opptyRec.G2_Approval_Date__c = system.now();
	//D-4604 set Opportunity.Probability = 90% {Enhancement}
	opptyRec.Probability= Double.valueOf(system.Label.Upsell_Opportunity_Win_Probability_Value.trim());
	upsellOpptyLst.add(opptyRec);
	mapDealIDOppty.put(parentOppIdDealIdMap.get(upsellContainerValues[0].Parent_Opportunity__c),upsellOpptyLst);
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, UpsellOpportunityUtility.class.getName(), GlobalConstants.METHOD_CREATE_UPSELL_OPPTY_RECORD);	  
		}   
		
		return mapDealIDOppty;
	}
	
	/*****************************
*Method Name: updateUpsellContainerRec
*Description: This method is to update  upsellcontainer records that are associated with newly created opportunity
*Parameters: List<Opportunity>
*******************************/
	public static List<Upsell_Container__c> updateUpsellContainerRec(List<Opportunity> upsellOpptyLst,Set<Id> oppRecToCreatDealSet)
	{
		List<Upsell_Container__c> upsellRecToUpdate = new List<Upsell_Container__c>();
		Map<String,Id> upsellOpptyNameandIdmap = new Map<String,Id>();	
		Map<String,String> upsellOpptyNameandUpsellOppNumMap = new Map<String,String>();
		try
		{
			for(Opportunity opptys : upsellOpptyLst)
			{
	upsellOpptyNameandIdmap.put(opptys.Name,opptys.Id);   
	upsellOpptyNameandUpsellOppNumMap.put(opptys.Name, opptys.Opportunity_ID__c);
			}		
			List<Upsell_Container__c> upsellOpptyRec = [Select Id,Parent_Offer__r.ActiveOffer__c,Upsell_Opportunity__r.Opportunity_ID__c,Parent_Opportunity__c,
					Name,Upsell_Opportunity_Name__c,Upsell_Opportunity_Number__c,
					Upsell_Opportunity_Type__c,Upsell_Opportunity__c,
					Parent_Opportunity__r.Account.Name,Total_Year_Sales__c 
					from Upsell_Container__c where Template_Identifier__c=:strTemplateIdentifier AND Upsell_Opportunity_Name__c IN : upsellOpptyNameandIdmap.keySet() 
					and Parent_Opportunity__c  IN: oppRecToCreatDealSet and Parent_Offer__r.ActiveOffer__c =: true];

			for(Upsell_Container__c upsellData : [Select Id,Parent_Offer__r.ActiveOffer__c,Upsell_Opportunity__r.Opportunity_ID__c,Parent_Opportunity__c,
					Name,Upsell_Opportunity_Name__c,Upsell_Opportunity_Number__c,
					Upsell_Opportunity_Type__c,Upsell_Opportunity__c,
					Parent_Opportunity__r.Account.Name,Total_Year_Sales__c 
					from Upsell_Container__c where Template_Identifier__c=:strTemplateIdentifier AND Upsell_Opportunity_Name__c IN : upsellOpptyNameandIdmap.keySet() 
					and Parent_Opportunity__c  IN: oppRecToCreatDealSet and Parent_Offer__r.ActiveOffer__c =: true])
			{
	if(upsellOpptyNameandIdmap.containsKey(upsellData.Upsell_Opportunity_Name__c))
	{
		upsellData.Upsell_Opportunity__c = upsellOpptyNameandIdmap.get(upsellData.Upsell_Opportunity_Name__c);
		upsellData.Automatic_Creation__c = true;
		upsellData.Upsell_Opportunity_Number__c = upsellOpptyNameandUpsellOppNumMap.get(upsellData.Upsell_Opportunity_Name__c);
		upsellRecToUpdate.add(upsellData);
	}
			}		
			if(!upsellRecToUpdate.isEmpty())
			{
	update upsellRecToUpdate;		
			}
			
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, UpsellOpportunityUtility.class.getName(), GlobalConstants.METHOD_UPDATE_UPSELL_CONTAINER_REC);
			System.debug('Exception message:::>'+ex.getMessage());	  
		} 
		return upsellRecToUpdate;
	}
	
	/*****************************
*Method Name: createOIFforUpsellOpp
*Description: This method is to create OIF lines for upsell opportunity
*Parameters: List<Upsell_Container__c>
*******************************/
	public static void createOIFforUpsellOpp(List<Upsell_Container__c> inputContainerList)
	{
		List<Order_Intake_Forecast__c> toCreateOIFList = new List<Order_Intake_Forecast__c>();
		Map<String,Id> upsellContainerIDBlIdMap = new Map<String,Id>();	
		Map<Id,String> buisnessLineIdContainerIdMap = new Map<Id,String>(); 
		Map<String,Id> upsellContainerIDQuaterPeriodIdMap = new Map<String,Id>();
		Set<String> quaterPeriodSet = new Set<String>();
	
		try{
			if(!inputContainerList.isEmpty())
			{
	for(Upsell_Container__c upsellRec : inputContainerList)
	{
		buisnessLineIdContainerIdMap.put(upsellRec.Id,upsellRec.Upsell_Opportunity_Main_BL__c);
		quaterPeriodSet.add(upsellRec.Quarter1_Period__c);
		quaterPeriodSet.add(upsellRec.Quarter2_Period__c);
		quaterPeriodSet.add(upsellRec.Quarter3_Period__c);
		quaterPeriodSet.add(upsellRec.Quarter4_Period__c);
		quaterPeriodSet.add(upsellRec.Quarter1_Reverse_Period__c);
		quaterPeriodSet.add(upsellRec.Quarter2_Reverse_Period__c);
		quaterPeriodSet.add(upsellRec.Quarter3_Reverse_Period__c);
		quaterPeriodSet.add(upsellRec.Quarter4_Reverse_Period__c );	
	}
	for(Product2 proRec : [SELECT Id,Name FROM Product2 WHERE Name IN: buisnessLineIdContainerIdMap.values()])
	{
		upsellContainerIDBlIdMap.put(proRec.Name,proRec.Id);
	}

	for(Nokia_Financial_Calendar__c finaCalenRec : [Select id,Name from Nokia_Financial_Calendar__c where Name IN: quaterPeriodSet])
	{
		upsellContainerIDQuaterPeriodIdMap.put(finaCalenRec.Name, finaCalenRec.Id);
	}
	if(!upsellContainerIDBlIdMap.isEmpty() || !upsellContainerIDQuaterPeriodIdMap.isEmpty())
	{
		toCreateOIFList = returnConstructedOIFList(inputContainerList,upsellContainerIDBlIdMap,upsellContainerIDQuaterPeriodIdMap);	
	}  
	//Printing Result
	for(Order_Intake_Forecast__c result : toCreateOIFList)
	{
		if(result.POPlanReceipt__c != null)
		{
			System.debug('Final Result::::>'+result);
		}
	}			

	if(!toCreateOIFList.isEmpty())
	{
		Database.SaveResult[] srList = Database.insert(toCreateOIFList, false);
		
		// Iterate through each returned result
		for (Database.SaveResult sr : srList) {
			if (!sr.isSuccess()) {
				// Operation failed, so get all errors	
				for(Database.Error err : sr.getErrors()) {
		System.debug('The following error has occurred.');		
		System.debug(err.getStatusCode() + ': ' + err.getMessage());
		System.debug('Fields that affected this error: ' + err.getFields());
				}
			}
		}	  
	}
			}		
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, UpsellOpportunityUtility.class.getName(), GlobalConstants.METHOD_CREATE_OIF_FOR_UPSELL_OPP);
			System.debug('Exception message:::>'+ex.getMessage());	  
		} 
	}
	
	/*****************************
*Method Name: returnConstructedOIFList
*Description: This method is to construct OIF records for upsell opportunity
*Parameters: List<Upsell_Container__c> , Map<String,Id> , Map<String,Id>
*******************************/
	public static List<Order_Intake_Forecast__c> returnConstructedOIFList(List<Upsell_Container__c> inputContainerList,Map<String,Id> upsellContainerIDBlIdMap,Map<String,Id> upsellContainerIDQuaterPeriodIdMap)
	{
		List<Order_Intake_Forecast__c> toCreateOIFList = new List<Order_Intake_Forecast__c>();
		Order_Intake_Forecast__c quater1,quater2,quater3,quater4;
		try
		{   
			String upSellOIFMarketException = File_Sharing_Custom_Setting__c.getInstance(GlobalConstants.UPSELL_OIF_REV_EXCEP).Value__c;	 
			for(Upsell_Container__c upsellRec : inputContainerList)
			{
	if(upsellRec.Quarter1_Period_Value__c>0 && upsellRec.Quarter1_Period_Value__c != null)
	{
		quater1 = new Order_Intake_Forecast__c();  
		quater1.Opportunity__c = upsellRec.Upsell_Opportunity__c;
		quater1.BusinessLine__c = upsellContainerIDBlIdMap.get(upsellRec.Upsell_Opportunity_Main_BL__c);
		quater1.Forecast_Category__c = GlobalConstants.SECURE;
		quater1.OIF_Value__c = upsellRec.Quarter1_Period_Value__c;
		quater1.POPlanReceipt__c = upsellContainerIDQuaterPeriodIdMap.get(upsellRec.Quarter1_Period__c);
		if(upSellOIFMarketException.equalsIgnoreCase(upsellRec.Parent_Opportunity__r.Org_L4__c))
		{
			quater1.Rev_RecPlan_Receipt__c = upsellContainerIDQuaterPeriodIdMap.get(upsellRec.Quarter1_Reverse_Period__c);
		}	
		toCreateOIFList.add(quater1);   
	}
	
	if(upsellRec.Quarter2_Period_Value__c>0  && upsellRec.Quarter2_Period_Value__c != null)
	{
		quater2 = new Order_Intake_Forecast__c();
		quater2.Opportunity__c = upsellRec.Upsell_Opportunity__c;
		quater2.BusinessLine__c = upsellContainerIDBlIdMap.get(upsellRec.Upsell_Opportunity_Main_BL__c);
		quater2.Forecast_Category__c = GlobalConstants.SECURE;
		quater2.OIF_Value__c = upsellRec.Quarter2_Period_Value__c;
		quater2.POPlanReceipt__c = upsellContainerIDQuaterPeriodIdMap.get(upsellRec.Quarter2_Period__c);
		if(upSellOIFMarketException.equalsIgnoreCase(upsellRec.Parent_Opportunity__r.Org_L4__c))
		{
			quater2.Rev_RecPlan_Receipt__c = upsellContainerIDQuaterPeriodIdMap.get(upsellRec.Quarter2_Reverse_Period__c);
		}
		toCreateOIFList.add(quater2);		
	}	
	
	if(upsellRec.Quarter3_Period_Value__c>0  && upsellRec.Quarter3_Period_Value__c != null)
	{
		quater3 = new Order_Intake_Forecast__c();
		quater3.Opportunity__c = upsellRec.Upsell_Opportunity__c;
		quater3.BusinessLine__c = upsellContainerIDBlIdMap.get(upsellRec.Upsell_Opportunity_Main_BL__c);
		quater3.Forecast_Category__c = GlobalConstants.SECURE;
		quater3.OIF_Value__c = upsellRec.Quarter3_Period_Value__c;
		quater3.POPlanReceipt__c = upsellContainerIDQuaterPeriodIdMap.get(upsellRec.Quarter3_Period__c);
		if(upSellOIFMarketException.equalsIgnoreCase(upsellRec.Parent_Opportunity__r.Org_L4__c))
		{
			quater3.Rev_RecPlan_Receipt__c = upsellContainerIDQuaterPeriodIdMap.get(upsellRec.Quarter3_Reverse_Period__c);
		}
		toCreateOIFList.add(quater3);
	}
	
	if(upsellRec.Quarter4_Period_Value__c>0  && upsellRec.Quarter4_Period_Value__c != null)
	{
		quater4 = new Order_Intake_Forecast__c();   
		quater4.Opportunity__c = upsellRec.Upsell_Opportunity__c;
		quater4.BusinessLine__c = upsellContainerIDBlIdMap.get(upsellRec.Upsell_Opportunity_Main_BL__c);
		quater4.Forecast_Category__c = GlobalConstants.SECURE;
		quater4.OIF_Value__c = upsellRec.Quarter4_Period_Value__c;
		quater4.POPlanReceipt__c = upsellContainerIDQuaterPeriodIdMap.get(upsellRec.Quarter4_Period__c);
		if(upSellOIFMarketException.equalsIgnoreCase(upsellRec.Parent_Opportunity__r.Org_L4__c))
		{
			quater4.Rev_RecPlan_Receipt__c = upsellContainerIDQuaterPeriodIdMap.get(upsellRec.Quarter4_Reverse_Period__c);
		}
		toCreateOIFList.add(quater4); 
	}
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, UpsellOpportunityUtility.class.getName(), GlobalConstants.METHOD_RETRUN_CONSTRUCTED_OIF_LIST);
			System.debug('Exception message:::>'+ex.getMessage());	  
		}   
		return toCreateOIFList; 
	}
	
	/*****************************
*Method Name: sendChatterToUpsellOppOwner
*Description: This method is to send chatter post to parent opportunity of upsell opportunity
*Parameters: List<Upsell_Container__c> 
*******************************/
	Public static void sendChatterToUpsellOppOwner(List<Upsell_Container__c> entryContainerList,Map<Id,String> upsellWithInvalidOppIdMap,Map<Id,String> upsellWithoutOppIdMap,Map<Id,String> upsellWithMainOppIdMap)
	{   
		System.debug('entryContainerList::>'+entryContainerList);
		List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();	
		Set<Id> parentOppIdSet = new Set<Id>();
		Map<Id,Upsell_Container__c> upsellWithMainOppIdMap1 = new Map<Id,Upsell_Container__c>(); 
		Map<Id,Upsell_Container__c> upsellWithoutOppIdMap1 = new Map<Id,Upsell_Container__c>(); 
		Map<Id,Upsell_Container__c> upsellWithInvalidOppIdMap1 = new Map<Id,Upsell_Container__c>(); 
		 ConnectApi.BatchInput batchInput ; 
		try
		{   
			if(!entryContainerList.isEmpty())	
			{
	ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
	ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();	
	ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
	ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
	ConnectApi.LinkCapabilityInput linkInput = new ConnectApi.LinkCapabilityInput();
	ConnectApi.MarkupBeginSegmentInput markupBeginInput = new ConnectApi.MarkupBeginSegmentInput();
	ConnectApi.MarkupEndSegmentInput markupEndSegment = new ConnectApi.MarkupEndSegmentInput();
	for(Upsell_Container__c upsellRec : entryContainerList)
	{
		if(upsellWithInvalidOppIdMap.keySet().contains(upsellRec.Id))
		{
			upsellWithInvalidOppIdMap1.put(upsellRec.Upsell_Opportunity__c, upsellRec);
		}
		else if(upsellWithoutOppIdMap.keySet().contains(upsellRec.Id))
		{
			upsellWithoutOppIdMap1.put(upsellRec.Upsell_Opportunity__c, upsellRec);
		}
		else if(upsellWithMainOppIdMap.keySet().contains(upsellRec.Id))
		{
			upsellWithMainOppIdMap1.put(upsellRec.Upsell_Opportunity__c, upsellRec);
		}
		parentOppIdSet.add(upsellRec.Parent_Opportunity__c);
	}	
	
	for(Opportunity c : [Select id,Name,OwnerId,Account.Name,Opportunity_ID__c from Opportunity 
			 where Id IN: parentOppIdSet])
	{		 
		messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();		 
		
		markupBeginInput = new ConnectApi.MarkupBeginSegmentInput();
		markupBeginInput.markupType = ConnectApi.MarkupType.Bold;
		messageBodyInput.messageSegments.add(markupBeginInput);  
		
		//Chatter Header
		textSegmentInput = new ConnectApi.TextSegmentInput();
		textSegmentInput.text = GlobalConstants.UPSELL_OPP_CHATTER_HEADER;
		messageBodyInput.messageSegments.add(textSegmentInput);	 
		
		markupBeginInput = new ConnectApi.MarkupBeginSegmentInput();
		markupEndSegment.markupType = ConnectApi.MarkupType.Bold;
		messageBodyInput.messageSegments.add(markupEndSegment);
		
		markupBeginInput = new ConnectApi.MarkupBeginSegmentInput();	 
		markupBeginInput.markupType = ConnectApi.MarkupType.Paragraph;
		messageBodyInput.messageSegments.add(markupBeginInput);
		
		
		markupEndSegment = new ConnectApi.MarkupEndSegmentInput();  
		markupEndSegment.markupType = ConnectApi.MarkupType.Paragraph;
		messageBodyInput.messageSegments.add(markupEndSegment);
		
		markupBeginInput = new ConnectApi.MarkupBeginSegmentInput();
		markupBeginInput.markupType = ConnectApi.MarkupType.Bold;
		messageBodyInput.messageSegments.add(markupBeginInput);
		
		textSegmentInput = new ConnectApi.TextSegmentInput();
		textSegmentInput.text = c.Opportunity_ID__c+GlobalConstants.HYPHEN+c.Name+GlobalConstants.HYPHEN+c.Account.Name;
		messageBodyInput.messageSegments.add(textSegmentInput); 
		
		markupEndSegment = new ConnectApi.MarkupEndSegmentInput();  
		markupEndSegment.markupType = ConnectApi.MarkupType.Bold;
		messageBodyInput.messageSegments.add(markupEndSegment);
		
		markupBeginInput = new ConnectApi.MarkupBeginSegmentInput();	 
		markupBeginInput.markupType = ConnectApi.MarkupType.Paragraph;
		messageBodyInput.messageSegments.add(markupBeginInput);
		
		textSegmentInput = new ConnectApi.TextSegmentInput();
		textSegmentInput.text = GlobalConstants.New_Black_Space;
		messageBodyInput.messageSegments.add(textSegmentInput);
		
		markupEndSegment = new ConnectApi.MarkupEndSegmentInput();  
		markupEndSegment.markupType = ConnectApi.MarkupType.Paragraph;
		messageBodyInput.messageSegments.add(markupEndSegment);
		
		markupBeginInput = new ConnectApi.MarkupBeginSegmentInput();	 
		markupBeginInput.markupType = ConnectApi.MarkupType.Underline;
		messageBodyInput.messageSegments.add(markupBeginInput);
		
		textSegmentInput = new ConnectApi.TextSegmentInput();
		textSegmentInput.text = GlobalConstants.Reason_For_AutoUpsell;
		messageBodyInput.messageSegments.add(textSegmentInput);  
		
		markupBeginInput = new ConnectApi.MarkupBeginSegmentInput();	 
		markupBeginInput.markupType = ConnectApi.MarkupType.Paragraph;
		messageBodyInput.messageSegments.add(markupBeginInput);
		
		
		markupEndSegment = new ConnectApi.MarkupEndSegmentInput();  
		markupEndSegment.markupType = ConnectApi.MarkupType.Paragraph;
		messageBodyInput.messageSegments.add(markupEndSegment);
		
		markupEndSegment = new ConnectApi.MarkupEndSegmentInput();  
		markupEndSegment.markupType = ConnectApi.MarkupType.Underline;
		messageBodyInput.messageSegments.add(markupEndSegment);
		
		
		if(!upsellWithoutOppIdMap1.isEmpty())
		{				
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Upsell_Without_OppId;
			messageBodyInput.messageSegments.add(textSegmentInput);
			
			for(Id upsellRec : upsellWithoutOppIdMap1.keySet())
			{
				markupBeginInput = new ConnectApi.MarkupBeginSegmentInput();	 
				markupBeginInput.markupType = ConnectApi.MarkupType.ListItem;
				messageBodyInput.messageSegments.add(markupBeginInput);  
				
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = upsellWithoutOppIdMap1.get(upsellRec).Upsell_Opportunity_Number__c+GlobalConstants.HYPHEN+upsellWithoutOppIdMap1.get(upsellRec).Upsell_Opportunity_Name__c+GlobalConstants.HYPHEN+upsellWithoutOppIdMap1.get(upsellRec).Parent_Opportunity__r.Account.Name+GlobalConstants.HYPHEN+upsellWithoutOppIdMap1.get(upsellRec).Total_Year_Sales__c;
				messageBodyInput.messageSegments.add(textSegmentInput);
				
				markupEndSegment = new ConnectApi.MarkupEndSegmentInput();  
				markupEndSegment.markupType = ConnectApi.MarkupType.ListItem;
				messageBodyInput.messageSegments.add(markupEndSegment);
			} 
		}
		
		if(!upsellWithInvalidOppIdMap1.isEmpty())
		{
			
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Upsell_With_Invalid_OppId;
			messageBodyInput.messageSegments.add(textSegmentInput);
			
			for(Id upsellRec : upsellWithInvalidOppIdMap1.keySet())
			{							  
				markupBeginInput = new ConnectApi.MarkupBeginSegmentInput();	 
				markupBeginInput.markupType = ConnectApi.MarkupType.ListItem;
				messageBodyInput.messageSegments.add(markupBeginInput);
				
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = upsellWithInvalidOppIdMap1.get(upsellRec).Upsell_Opportunity_Number__c+GlobalConstants.HYPHEN+upsellWithInvalidOppIdMap1.get(upsellRec).Upsell_Opportunity_Name__c+GlobalConstants.HYPHEN+upsellWithInvalidOppIdMap1.get(upsellRec).Parent_Opportunity__r.Account.Name+GlobalConstants.HYPHEN+upsellWithInvalidOppIdMap1.get(upsellRec).Total_Year_Sales__c;
				messageBodyInput.messageSegments.add(textSegmentInput);
				
				markupEndSegment = new ConnectApi.MarkupEndSegmentInput();  
				markupEndSegment.markupType = ConnectApi.MarkupType.ListItem;
				messageBodyInput.messageSegments.add(markupEndSegment);
			}
		}				
		
		if(!upsellWithMainOppIdMap1.isEmpty())
		{			  
			textSegmentInput = new ConnectApi.TextSegmentInput();
			textSegmentInput.text = GlobalConstants.Upsell_With_Parent_OppId;
			messageBodyInput.messageSegments.add(textSegmentInput);			
			
			for(Id upsellRec : upsellWithMainOppIdMap1.keySet())
			{
				markupBeginInput = new ConnectApi.MarkupBeginSegmentInput();	 
				markupBeginInput.markupType = ConnectApi.MarkupType.ListItem;
				messageBodyInput.messageSegments.add(markupBeginInput);  
				
				textSegmentInput = new ConnectApi.TextSegmentInput();
				textSegmentInput.text = upsellWithMainOppIdMap1.get(upsellRec).Upsell_Opportunity_Number__c+GlobalConstants.HYPHEN+upsellWithMainOppIdMap1.get(upsellRec).Upsell_Opportunity_Name__c+GlobalConstants.HYPHEN+upsellWithMainOppIdMap1.get(upsellRec).Parent_Opportunity__r.Account.Name+GlobalConstants.HYPHEN+upsellWithMainOppIdMap1.get(upsellRec).Total_Year_Sales__c;
				messageBodyInput.messageSegments.add(textSegmentInput);
				
				markupEndSegment = new ConnectApi.MarkupEndSegmentInput();  
				markupEndSegment.markupType = ConnectApi.MarkupType.ListItem;
				messageBodyInput.messageSegments.add(markupEndSegment);
			} 
		}
		
		
		//Mention Opportunity owner
		markupBeginInput = new ConnectApi.MarkupBeginSegmentInput();	 
		markupBeginInput.markupType = ConnectApi.MarkupType.Paragraph;
		messageBodyInput.messageSegments.add(markupBeginInput);
		
		markupEndSegment = new ConnectApi.MarkupEndSegmentInput();  
		markupEndSegment.markupType = ConnectApi.MarkupType.Paragraph;
		messageBodyInput.messageSegments.add(markupEndSegment);
		
		markupBeginInput = new ConnectApi.MarkupBeginSegmentInput();
		markupBeginInput.markupType = ConnectApi.MarkupType.Bold;
		messageBodyInput.messageSegments.add(markupBeginInput);
		
		textSegmentInput = new ConnectApi.TextSegmentInput();
		textSegmentInput.text = GlobalConstants.PARENT_OPP_OWNER;
		messageBodyInput.messageSegments.add(textSegmentInput); 
		
		markupEndSegment = new ConnectApi.MarkupEndSegmentInput();  
		markupEndSegment.markupType = ConnectApi.MarkupType.Bold;
		messageBodyInput.messageSegments.add(markupEndSegment);
		
		mentionSegmentInput.id = c.OwnerId;
		messageBodyInput.messageSegments.add(mentionSegmentInput);
				
		feedItemInput.body = messageBodyInput;	 
		feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
		feedItemInput.subjectId = c.Id;	  
				
		batchInput = new ConnectApi.BatchInput(feedItemInput);		 
		batchInputs.add(batchInput);
	}
	ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchinputs);
			}			
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, UpsellOpportunityUtility.class.getName(), GlobalConstants.METHOD_SEND_CHATTER_TO_UPSELL_OPP_OWNER);
			System.debug('Exception message:::>'+ex.getMessage());	  
		} 
	}
	
}