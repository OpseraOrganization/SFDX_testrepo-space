/**
* @description: File uploaded on Account/ Opportunity/ Offer using lightning component of sCRM. 
* File share Logic change: Collect L7 Territory Users +Collect Opp. 
* & Offer team users Share file with first 100 users
*
* ============================================================================
* History:
* -------
* 
* VERSION AUTHOR	DATE		DETAIL			FEATURES/CSR/TTP
* 1.0	 Accenture	20/1/2017 Sprint 4 Doc Stretegy & LoA requirements.
* 2.0	 Accenture	03/3/2017 Sprint 5 Doc Stretegy requirements. Req- 862 and Req-866
* ============================================================================ 
*/

trigger ContentDocumentLinkTrigger on ContentDocumentLink (Before insert, After insert,After delete)
{
	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) &&

	!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Excel_Add_In_Profile_SF_Id) &&

	!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Integration_API_Only_Profile))
	{
		System.debug('getQueries()......'+Limits.getQueries());  
		System.debug('getLimitQueries()......'+Limits.getLimitQueries()); 
//PRM Code to restrict file upload starts
		if(Trigger.isBefore && Trigger.isInsert )
		{
	Id profileId = userinfo.getProfileId();
	String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
	String Objectname;
	if(profileName == 'Customers' || profileName == 'Customers Login'){
	for(ContentDocumentLink cont : trigger.New){
	
			Objectname = cont.LinkedEntityId.getSObjectType().getDescribe().getName();
			
			if (Objectname != PRMGlobalConstants.CLAIM_OBJECT && Objectname !=PRMGlobalConstants.USER_OBJECT){
			Trigger.new[0].addError('You dont have access to upload files');
			}
		
	}	
			}
		}
		// PRM Code to restrict file upload ends
		 
		if(Trigger.isInsert)
		{
			list<contentDocumentLink> linkList = new list<contentDocumentLink>();
			list<Id> cdIdList = new List<Id>();
			Map<Id,ContentDocument> cdMap;
			System.debug('LeadConevrtDocHandler.isLeadConversion......'+LeadConevrtDocHandler.isLeadConversion);
			if(!LeadConevrtDocHandler.isLeadConversion){	
	for(ContentDocumentLink cdl : trigger.new){
		cdIdList.add(cdl.ContentDocumentId);
	}
	
	cdMap = new Map<Id,ContentDocument>([select id,FileType  from contentDocument where FileType <> 'SNOTE' and Id In:cdIdList]);
	System.debug('cdMap ......'+cdMap );  
	  
	for(ContentDocumentLink cdl : trigger.new){
		if(cdMap!= null && cdMap.containsKey(cdl.ContentDocumentId))
			linkList.add(cdl);
	}
			}else{
	linkList= trigger.new;
			}
			System.debug('linkList......'+linkList); 
	 
			if(linkList.size()>0){			
			
	Boolean isLeadConversion = LeadConevrtDocHandler.detectLeadConvert(linkList);
	if(Trigger.isBefore){
					ContentDocumentLinkHelper.PS_ModifyFileShareTypeAndVisibility(linkList);
		System.debug('inside contentdocumentlink before insert isLeadConversion ......'+isLeadConversion );
		if(!isLeadConversion){
			ContentDocumentLinkHandler.beforeInsert(linkList);
			ContentDocumentLinkHandlerPRM.beforeInsert(linkList);
			
			ContentDocumentLinkHelper.createFileRecord(linkList);
		}
		if(LeadConevrtDocHandler.isLeadConversion){
			ContentDocumentLinkHelper.shareWithAllUsers(linkList);
		}  
	}
	else if(Trigger.isAfter){
		System.debug('inside contentdocumentlink after insert isLeadConversion ......'+isLeadConversion );
		if(!isLeadConversion){
			system.debug('......Trigger.New....'+linkList);
			ContentDocumentLinkHandler.afterInsert(linkList);
			CCRE_ContentDocumentLinkTriggerHandler.afterInsert(linkList);
		}else{
			system.debug('Trigger.New>>>>>>>>>>>'+linkList);
			if(!LeadConevrtDocHandler.isLeadConversion){
				LeadConevrtDocHandler.alloWConvert(linkList);
			}
		}
	}
			}
		}
	}
	
	//sCPQ related methods

	if(!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Data_Loader_Profile_Id) &&

	!UserInfo.getProfileId().equalsIgnoreCase(system.Label.Excel_Add_In_Profile_SF_Id))

	{

		if(Trigger.isInsert)

		{

			list<contentDocumentLink> linkList = new list<contentDocumentLink>();

	 

			for(ContentDocumentLink cdl : trigger.new){

	 if(cdl.LinkedEntityId.getSObjectType().getDescribe().getName().equalsIgnoreCase(GlobalConstants.quoteProposal) && Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get(Label.CQ_RecordTypeId).getDeveloperName()==Globalconstants.QuoteProposal_RecordType_1)

	 {

		 linkList.add(cdl);

	 }

			}

		

			if(linklist.size()>0){

			if(Trigger.isAfter)
		 {
			ContentDocumentLinkHandler.CQ_afterInsert(linkList);
		 }
		 
			if(Trigger.isAfter)

		 {

			ContentDocumentLinkHandler.CQ_afterInsert(linkList);

		 }

	if(Trigger.isBefore)
	{
	 ContentDocumentLinkHandler.CQ_beforeInsert(linkList);
	} 
	
	
	}
	
	

	

	}

	

 }
}