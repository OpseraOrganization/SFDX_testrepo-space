/****************************************
* class Name : AccreditationTriggerHelper 
* Created Date: July 2018
* Created By : Accenture
* Last Modified by: Accenture
* Last Modified Date: 
* Description :Logic related to chatter Notification
*****************************************/
public without sharing class AccreditationTriggerHelper{
	
	/****************************************
* Method Name : sendChatter 
* Created Date: July 2018
* Created By : Accenture
* Parameters : List<Accreditation__c> validAccreList
* returns : null 
* Description :Logic related to chatter Notification
*****************************************/
	public static void sendChatter(List<Accreditation__c> validAccreList){
		//Map<Id,Id> contactIdUserIdMap = new Map<Id,Id>();
		//Set<String> chatterGroupSet = new Set<String>();
		//Set<String> chatterGroupId = new Set<String>();
		List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
		List<CollaborationGroup> collGroupList = new List<CollaborationGroup>();
		List<Id> accountId = new List<Id>();
		//Map<Id,String> accountName = new Map<Id,String>();
		ConnectApi.FeedItemInput input;
		ConnectApi.FeedItemInput input1;
		ConnectApi.MessageBodyInput body;
		ConnectApi.MentionSegmentInput mentionSegment;
		ConnectApi.TextSegmentInput textSegment;
		ConnectApi.BatchInput batchInput;
		ConnectApi.MessageBodyInput body1;
		ConnectApi.MentionSegmentInput mentionSegment1;
		ConnectApi.TextSegmentInput textSegment1;
		ConnectApi.BatchInput batchInput1;
		
		try{
			collGroupList = [SELECT Id FROM CollaborationGroup WHERE Name =: Nokia_CPQ_Constants.PRICING_TEAM limit 1];
			
			//system.debug('collGroupList --->'+collGroupList);
			
			for(Accreditation__c accred : validAccreList){
	accountId.add(accred.Partner__c);
			}
			
			//system.debug('accountId --->'+accountId);
			
			Map<ID, Account> mapIdAcc = new Map<ID, Account>([SELECT Id, Name FROM Account where Id in : accountId  Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
			for(Accreditation__c accre : validAccreList){
	//  for(String st : chatterGroupId){
	input = new ConnectApi.FeedItemInput();
	input.subjectId = accre.id;
	
	//system.debug('input --->'+input);
	
	body = new ConnectApi.MessageBodyInput();
	body.messageSegments = new List<ConnectApi.MessageSegmentInput>();
	
	//system.debug('body 1--->'+body);
	
	mentionSegment = new ConnectApi.MentionSegmentInput();
	mentionSegment.id = collGroupList[0].id;
	body.messageSegments.add(mentionSegment);
	
	//system.debug('mentionSegment --->'+mentionSegment);
	
	textSegment = new ConnectApi.TextSegmentInput();
	
	if(mapIdAcc.containsKey(accre.Partner__c) && mapIdAcc.get(accre.Partner__c)!=null){
		textSegment.text =  Nokia_CPQ_Constants.CHATTER1 +mapIdAcc.get(accre.Partner__c).Name + Nokia_CPQ_Constants.CHATTER2 + accre.Accreditation_Type__c + Nokia_CPQ_Constants.CHATTER3 + accre.Portfolio__c + Nokia_CPQ_Constants.CHATTER4 + accre.Accreditation_Level__c + Nokia_CPQ_Constants.CHATTER5 + accre.Reason_for_Level_Change__c + Nokia_CPQ_Constants.CHATTER6 + accre.Pricing_Level_Override__c + Nokia_CPQ_Constants.CHATTER7 + accre.Pricing_Override_Expiration__c + Nokia_CPQ_Constants.CHATTER8 +accre.Pricing_Accreditation__c;
	}
	
	body.messageSegments.add(textSegment);
	
	//system.debug('body 2--->'+body);
	
	input.body = body;
	input.visibility = ConnectApi.FeedItemVisibilityType.InternalUsers;
	//system.debug('input--->'+input);
	batchInput = new ConnectApi.BatchInput(input);
	//system.debug('batchInput --->'+batchInput );
	//Post in Chatter group logic 
	input1 = new ConnectApi.FeedItemInput();
	input1.subjectId = collGroupList[0].id;
	
	
	body1 = new ConnectApi.MessageBodyInput();
	body1.messageSegments = new List<ConnectApi.MessageSegmentInput>();
	
	mentionSegment1 = new ConnectApi.MentionSegmentInput();
	mentionSegment1.id = collGroupList[0].id;
	body1.messageSegments.add(mentionSegment1);
	
	textSegment1 = new ConnectApi.TextSegmentInput();
	
	if(mapIdAcc.containsKey(accre.Partner__c) && mapIdAcc.get(accre.Partner__c)!=null){
		textSegment1.text =  Nokia_CPQ_Constants.CHATTER1 +mapIdAcc.get(accre.Partner__c).Name + Nokia_CPQ_Constants.CHATTER2 + accre.Accreditation_Type__c + Nokia_CPQ_Constants.CHATTER3 + accre.Portfolio__c + Nokia_CPQ_Constants.CHATTER4 + accre.Accreditation_Level__c + Nokia_CPQ_Constants.CHATTER5 + accre.Reason_for_Level_Change__c + Nokia_CPQ_Constants.CHATTER6 + accre.Pricing_Level_Override__c + Nokia_CPQ_Constants.CHATTER7 + accre.Pricing_Override_Expiration__c + Nokia_CPQ_Constants.CHATTER8 +accre.Pricing_Accreditation__c;
	}
	
	body1.messageSegments.add(textSegment1);
	
	//system.debug('body1 --->'+body1);
	
	input1.body = body1;
	input1.visibility = ConnectApi.FeedItemVisibilityType.AllUsers;
	
	//system.debug('input1 --->'+input1);
	
	batchInput1 = new ConnectApi.BatchInput(input1);
	//system.debug('batchInput1 --->'+batchInput1);
	batchInputs.add(batchInput1);
	//system.debug('batchInput0--->'+batchInputs);
	batchInputs.add(batchInput);
	//system.debug('batchInput00--->'+batchInputs);   
	//  }
	
			} 
			
			//Post the chatter for internal users   
			ConnectApi.ChatterFeeds.postFeedElementBatch(null, batchInputs);
			
		}
		
		catch(Exception e)
		{
			ExceptionHandler.addException(e,AccreditationTriggerHelper.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
		}
		
	}
	/****************************************
* Method Name : updateAccreditaion 
* Created Date: September 2018
* Created By : Accenture
* Parameters : List<Accreditation__c> validAccreList
* returns : null 
* Description :
*****************************************/
 public static void updateAccreditaion(List<Accreditation__c> validAccreList){
	 try{
		set<Id> accIds = new set<Id>();
		Date myDate = date.today();
		//system.debug(myDate.year());
		String sDate = String.valueOf(myDate.year());
		//system.debug(sDate);
	  //  map<ID, list<Certification__c>> accCert = new map<ID, list<Certification__c>>();
		for(Accreditation__c accrevalue : validAccreList){
			accIds.add(accrevalue.Partner__c);	
		}
		
		//system.debug('accIds>>>'+accIds);
		//List<Accreditation__c> accreditaionList = new List<Accreditation__c>();
		Map<Id,Account> accMap = new Map<Id,Account>();
		for(Account acc : [SELECT Id,Shift_Model__c,Third_Party_Screening__c FROM Account where Id In: accIds 
		 LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
	accMap.put(acc.Id,acc);  
		 }
		//Start
		
		Map<Id,List<String>> accToContractMap = new Map<Id,List<String>>();
		Map<Id,String> accToBusinessPlanMap = new Map<Id,String>();
		map<ID, map<String, integer>> contactNumCert = new map<id, map<String, integer>>();
	// List<String> contractTypeList = new List<String>();
		for(Contract con : [SELECT AccountId,Contract_Status__c,Contract_Type__c FROM Contract WHERE Contract_Status__c = : PRMGlobalConstants.ActiveSt and AccountId IN: accIds LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
		{
			if(accToContractMap.containskey(con.AccountId))
			{
	accToContractMap.get(con.AccountId).add(con.Contract_Type__c);	 
			}
			else{		
	accToContractMap.put(con.AccountId,new List<String>{con.Contract_Type__c});	  
	  // system.debug('accToContractMap>>'+accToContractMap);
			}	
		}
		
		for(Business_Plan__c bPlan : [SELECT Account_BP__c,Business_Plan_Status__c,Year__c FROM Business_Plan__c WHERE Account_BP__c IN: accIds LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
		{	 
			
			if(bPlan.Year__c.equals(sDate)){
	system.debug('True');
	accToBusinessPlanMap.put(bPlan.Account_BP__c,bPlan.Business_Plan_Status__c);	  
	//system.debug('accToContractMap>>'+accToBusinessPlanMap);
	
			}	 
		}
		
		for(Certification__c usercert : [select id, Name__c, Partner__c,Job_Function__c, Technologies_Portfolio__c from Certification__c 
	 where Partner__c in: accIds AND Certification_Status__c =: PRMGlobalConstants.Completed 
	 Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
			//system.debug('usercert .....' + usercert);
			//map<string, integer> portfolioCert = contactNumCert.get(usercert.Name__c);
			map<string, integer> portfolioCert = contactNumCert.get(usercert.Partner__c);
			string key = usercert.Technologies_Portfolio__c + usercert.Job_Function__c;
			if(portfolioCert == null){
	map<string, integer> portfCert = new map<string, integer>();
	portfCert.put(key, 1);
	//contactNumCert.put(usercert.Name__c, portfCert);
	contactNumCert.put(usercert.Partner__c, portfCert);
			}
			else{
	integer certCount = portfolioCert.get(key);
	if(certCount == null){
	 portfolioCert.put(key, 1);	  
	}
	else{
	 certCount = certCount + 1;
	 portfolioCert.put(key, certCount);
	}
	//contactNumCert.put(usercert.Name__c, portfolioCert);
	contactNumCert.put(usercert.Partner__c, portfolioCert);
			}	
	 }	
		//system.debug('contactNumCert>>>'+contactNumCert);   
		
		
		//system.debug('contactNumCert ==== ' + contactNumCert);			
		
		//system.debug('accToContractMap>>'+accToContractMap.values());
		//system.debug('accToContractMap>>'+accToContractMap.keySet());
		Map<Id,String> accountIdToString = new Map<Id,String>();
		for(Id accountId:accToContractMap.keySet()){
			List<String> listOfContractType =accToContractMap.get(accountId);
			String srt;
			for(String s:listOfContractType){
	if(srt==null){
		srt =s;
	}else{
			srt=srt+PRMGlobalConstants.SemiColon+s;
		system.debug('s is'+srt);
	}
			}
			accountIdToString.put(accountId,srt);
		}
		
		//system.debug('s is'+accountIdToString);
		
		
		//End
		for(Accreditation__c accrevalue : validAccreList){
			
			//Accreditation__c accrevalue1 = new Accreditation__c();
			accrevalue.Shift_Model__c = accMap.get(accrevalue.Partner__c).Shift_Model__c;
			accrevalue.Third_Party_Screening__c = accMap.get(accrevalue.Partner__c).Third_Party_Screening__c;			
			accrevalue.Active_Contract_Types__c = accountIdToString.get(accrevalue.Partner__c);
			if(contactNumCert.get(accrevalue.Partner__c) != null){
	accrevalue.Sales_Associate__c = (contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Sales_Associate) != null ? contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Sales_Associate) : 0);			
	accrevalue.Sales_Engineer__c = (contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Sales_Engineer) != null ? contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Sales_Engineer) : 0);
	accrevalue.Field_Technician__c = (contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Field_Technician) != null ? contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Field_Technician) : 0);
	accrevalue.Network_Integration_Engineer__c = (contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Network_Integration_Engineer) != null ? contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Network_Integration_Engineer) : 0);
	accrevalue.Service_Desk_Clerk__c = (contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Service_Desk_Clerk) != null ? contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Service_Desk_Clerk) : 0);
	accrevalue.Administration_Software_Only__c = (contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Administration_Software_Only) != null ? contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Administration_Software_Only) : 0);
	accrevalue.Partner_Marketing_Manager__c = (contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Partner_Marketing_Manager) != null ? contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Partner_Marketing_Manager) : 0);
	accrevalue.Partner_Relationship_Manager__c = (contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Partner_Relationship_Manager_acc) != null ? contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Partner_Relationship_Manager_acc) : 0);
	accrevalue.Technical_Support_Level_1__c = (contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Technical_Support_Level1) != null ? contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Technical_Support_Level1) : 0);
	accrevalue.Technical_Support_Level_2__c = (contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Technical_Support_Level2) != null ? contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Technical_Support_Level2) : 0); 
	accrevalue.Network_Planning_Engineer__c = (contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Network_Planning_Engineer) != null ? contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.Network_Planning_Engineer) : 0);
	accrevalue.No_Certification_Optional__c = (contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.No_Certification_Optional) != null ? contactNumCert.get(accrevalue.Partner__c).get(accrevalue.Portfolio__c + PRMGlobalConstants.No_Certification_Optional) : 0);
			}
			accrevalue.Evaluated_Accreditation__c=True;
			accrevalue.Partner_Business_Plan_Status__c=accToBusinessPlanMap.get(accrevalue.Partner__c);
			//accreditaionList.add(accrevalue1);
			
		}
	 }
	  catch(Exception e)
		{
			ExceptionHandler.addException(e,AccreditationTriggerHelper.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
		}
		//Database.insert(accreditaionList);
	}
	
 /****************************************
* Method Name : populateIncotermOnAccreditaion 
* Created Date: April 2019
* Created By : Accenture
* Parameters : List<Accreditation__c> accreList
* returns : null 
* Description : Used to populate incoterm  and Incoterm% on Accreditation from Account
*****************************************/	
	public static void populateIncotermOnAccreditaion(List<Accreditation__c> accreList){
		
		try{
	set<Id> accIds = new set<Id>();
	for(Accreditation__c accreRecord : accreList){
	accIds.add(accreRecord.Partner__c);
			}
			
	Map<Id,Account> accMap = new Map<Id,Account>();
	for(Account acc : [SELECT Id, NokiaCPQ_Incoterm__c, Incoterms__c FROM Account where Id In: accIds 
		 LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
	accMap.put(acc.Id,acc);  
		 }
			
			for(Accreditation__c accre : accreList){
	 if(accre.Accreditation_Type__c == 'Product'){
		 accre.NokiaCPQ_Incoterm__c = accMap.get(accre.Partner__c).Incoterms__c;
		 accre.NokiaCPQ_Incoterm_Percentage__c = accMap.get(accre.Partner__c).NokiaCPQ_Incoterm__c;   
	 }	
	}
			
		}catch(Exception ex){
	 ExceptionHandler.addException(ex, AccreditationTriggerHelper.class.getName(), Nokia_CPQ_Constants.ERROR_MSD) ;
		}
		
		
	}
	
	/****************************************
* Method Name : displayOnPartnerPortal 
* Created Date: Feb 2021
* Created By : Miguel Silva
* Parameters : List<Accreditation__c> accreList, Map<Id, Accreditation__c> accreOldMap
* returns : null 
* Description : Pulls Display on Partner Portal field from the Account
*****************************************/	
	public static void displayOnPartnerPortal(List<Accreditation__c> accreList, Map<Id, Accreditation__c> accreOldMap){
		Set<Id> accIds = new Set<Id>();
		for(Accreditation__c a : accreList){
			accIds.add(a.Partner__c);
		}
		Map<Id, Account> accMap = new Map<Id, Account>([Select Id, Co_Op_Account_Created__c from Account where Id in: accIds]);
		for(Accreditation__c a : accreList){
			if(a.Accreditation_Level__c == PRMGlobalConstants.AccredAdvanced
	  || a.Accreditation_Level__c == PRMGlobalConstants.AccredExpert
	  || a.Accreditation_Level__c == PRMGlobalConstants.AccredPremier){
	   if(accreOldMap == null){
		a.PRM_Display_On_Partner_Locator__c = accMap.get(a.Partner__c).Co_Op_Account_Created__c;
	   }else if(a.Accreditation_Level__c != accreOldMap.get(a.Id).Accreditation_Level__c){
		a.PRM_Display_On_Partner_Locator__c = accMap.get(a.Partner__c).Co_Op_Account_Created__c;
	   }
	  }
		}
	}

/****************************************
* Method Name : getTierDiscountDetail 
* Created Date: Apr 2021
* Created By : Miguel Silva
* Parameters : List<Accreditation__c> accredList
* returns : null 
* Description : Sets the Tier Discount Detail lookup field
*****************************************/	
	public static void getTierDiscountDetail(List<Accreditation__c> accredList){
		List<Tier_Discount_Detail__c> tddList = [Select Id, NokiaCPQ_Partner_Type__c, NokiaCPQ_Pricing_Tier__c, NokiaCPQ_Tier_Type__c, NokiaCPQ_Tier_Discount__c from Tier_Discount_Detail__c];
		for(Accreditation__c accred : accredList){
			accred.PRM_Tier_Discount_Detail__c = null;
			for(Tier_Discount_Detail__c tdd : tddList){
				if(accred.Accreditation_Type__c == tdd.NokiaCPQ_Tier_Type__c && accred.Pricing_Accreditation__c == tdd.NokiaCPQ_Pricing_Tier__c && accred.Partner_Type__c == tdd.NokiaCPQ_Partner_Type__c){
					accred.PRM_Tier_Discount_Detail__c = tdd.Id;
				}
			}
		}
	}
}