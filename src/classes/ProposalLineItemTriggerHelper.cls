public with sharing class ProposalLineItemTriggerHelper {
public static boolean isFutureCalled=false;
	public static void updateQuoteValue(List<Apttus_Proposal__Proposal_Line_Item__c> lines){
		Map<String, Decimal> quoteValueMap = new Map<String, Decimal>();
		Map<Id, Decimal> quoteServicePriceMap = new Map<Id, Decimal>();
		Map<Id, Decimal> quoteOtherPriceMap = new Map<Id, Decimal>();
		List<Apttus_Proposal__Proposal__c> proposalList = new List<Apttus_Proposal__Proposal__c>();
		try{
			for(Apttus_Proposal__Proposal_Line_Item__c line : lines){
	quoteValueMap.put(line.Apttus_Proposal__Proposal__c, 0.0);
			}
			for(Apttus_Proposal__Proposal_Line_Item__c line : [SELECT id, Apttus_Proposal__Proposal__c, Apttus_QPConfig__NetPrice__c, Item_Type__c,Apttus_Proposal__Proposal__r.CPQ_CQ_Check__c,Apttus_QPConfig__LineType__c,CPQ_Price_Class__c
	  FROM Apttus_Proposal__Proposal_Line_Item__c
	  WHERE Apttus_Proposal__Proposal__c IN : quoteValueMap.keySet()]){
	if(quoteValueMap.containsKey(line.Apttus_Proposal__Proposal__c)){
		if(line.Apttus_Proposal__Proposal__r.CPQ_CQ_Check__c) {
			if(line.Apttus_QPConfig__LineType__c != 'Option') {
	quoteValueMap.put(line.Apttus_Proposal__Proposal__c, quoteValueMap.get(line.Apttus_Proposal__Proposal__c)+line.Apttus_QPConfig__NetPrice__c);
			}
		} else {
			quoteValueMap.put(line.Apttus_Proposal__Proposal__c, quoteValueMap.get(line.Apttus_Proposal__Proposal__c)+line.Apttus_QPConfig__NetPrice__c);
		}
	}
		
		if(String.isNotEmpty(line.Item_Type__c) && line.Item_Type__c.contains('Service')){
			if(quoteServicePriceMap.containsKey(line.Apttus_Proposal__Proposal__c)){
	quoteServicePriceMap.put(line.Apttus_Proposal__Proposal__c, quoteServicePriceMap.get(line.Apttus_Proposal__Proposal__c)+line.Apttus_QPConfig__NetPrice__c) ;
			} else {
	quoteServicePriceMap.put(line.Apttus_Proposal__Proposal__c, line.Apttus_QPConfig__NetPrice__c) ;
			}
		}
		if(String.isEmpty(line.Item_Type__c) ||
			!(line.Item_Type__c.contains('Service') ||
			line.Item_Type__c.contains('Hardware') ||
			line.Item_Type__c.contains('Software') ||
			line.Item_Type__c.contains('Option') ||
			(String.isNotBlank(line.CPQ_Price_Class__c) && line.CPQ_Price_Class__c.contains('Transportation')))
			){
	if(quoteOtherPriceMap.containsKey(line.Apttus_Proposal__Proposal__c)){
		quoteOtherPriceMap.put(line.Apttus_Proposal__Proposal__c, quoteOtherPriceMap.get(line.Apttus_Proposal__Proposal__c)+line.Apttus_QPConfig__NetPrice__c) ;
	} else{
		quoteOtherPriceMap.put(line.Apttus_Proposal__Proposal__c, line.Apttus_QPConfig__NetPrice__c) ;
	}
			}
			}
			for(String qId : quoteValueMap.keySet()){
	Apttus_Proposal__Proposal__c ncq = new Apttus_Proposal__Proposal__c(id = qId, CQ_Value__c = quoteValueMap.get(qId),CPQ_Templates_Auto_Generated__c = false);
	if(quoteServicePriceMap.containsKey(qId)){
		ncq.Services_Total__c = quoteServicePriceMap.get(qId);
	} else {
		ncq.Services_Total__c = 0;
	}
	if( quoteOtherPriceMap.containsKey(qId)){
		ncq.Other_Total__c = quoteOtherPriceMap.get(qId);
	} else{
		ncq.Other_Total__c = 0;
	}
	proposalList.add(ncq);
			}
			if(proposalList != null && !proposalList.isEmpty()){
	system.debug('proposalList'+proposalList);
	update proposalList;
			}
		}catch(Exception ex){
			system.debug('in exp'+ex.getMessage());
			ExceptionHandler.addException(ex, 'ProposalLineItemTriggerHelper', 'updateQuoteValue');
		}
	}
	
	
	/*********************************
	* author: Standav
	* Date: 20 SEP 2021
	* Developers: Jithin
	* Description: Method to autogenerate default reports for CQ quotes   
	**********************************/
	public static void autoGenerateQuoteReports(List<Apttus_Proposal__Proposal_Line_Item__c> plItems){
		
		Set<Id> quoteIds = new Set<Id>();
		Set<Id> cqQuotes= new Set<Id>();
		Map<Id, Set<String>> defaultTemplateNamesByQuoteId = new Map<Id, Set<String>>();
		for(Apttus_Proposal__Proposal_Line_Item__c pli:plItems){
			quoteIds.add(pli.Apttus_Proposal__Proposal__c);   
		}
		List<Apttus_Proposal__Proposal__c> allProposals = new  List<Apttus_Proposal__Proposal__c>([Select id,CPQ_CQ_Check__c,RecordType.Name,Apttus_Proposal__Account__r.CPQ_CQ_Default_Template__r.Name from Apttus_Proposal__Proposal__c where Id in:quoteIds]);
		
		for(Apttus_Proposal__Proposal__c proposal:allProposals){
			if(proposal.CPQ_CQ_Check__c) {
				cqQuotes.add(proposal.Id);
				if(proposal.Apttus_Proposal__Account__r.CPQ_CQ_Default_Template__r.Name != null) {
					defaultTemplateNamesByQuoteId.put(proposal.Id, new Set<String>{proposal.Apttus_Proposal__Account__r.CPQ_CQ_Default_Template__r.Name, Nokia_CPQ_Constants.QTC_CQ_Quote_PDS_Report_Name});
				} else {
					defaultTemplateNamesByQuoteId.put(proposal.Id, new Set<String>{Nokia_CPQ_Constants.QTC_CQ_Quote_Generic_Report_Name, Nokia_CPQ_Constants.QTC_CQ_Quote_PDS_Report_Name});
				}
			}
		}
		System.debug('******cqQuotes******'+cqQuotes);
		
		if(cqQuotes.size()>0){
			if(isFutureCalled==false && !System.isFuture()){  
				List<Apttus__APTS_Template__c> cqTemplates= new List<Apttus__APTS_Template__c>([select id,name from Apttus__APTS_Template__c where Apttus__Agreement_Types__c =:Nokia_CPQ_Constants.QTC_CQ_Quote AND Apttus__IsActive__c =true]);
				if(cqTemplates.size()>0){
					for(Id proposalId:cqQuotes){
						Set<String> validTemplateNames = defaultTemplateNamesByQuoteId.get(proposalId);
						for( Apttus__APTS_Template__c tempCQ: cqTemplates) {
							if(validTemplateNames != null && validTemplateNames.contains(tempCQ.Name)) {
								String proposalId1=proposalId;
								String templateId=tempCQ.Id;
								ProposalLineItemTriggerHelper.autoGenerateDocument(templateId,proposalId1);
							}
						}
					}			
				}
			}
		}
	}
	
	@future(callout=true)
	public static void autoGenerateDocument(String templateId,String proposalId){
		
		try{
	String pLevel = Nokia_CPQ_Constants.pLevel;
	String docFormat = Nokia_CPQ_Constants.docFormat; 
	String apiServerURL = Nokia_CPQ_Constants.apiServerURL ;
	String SessionId = Nokia_CPQ_Constants.SessionId ;	
	String generatedDocId=Apttus_Proposal.MergeWebService.generateDoc(templateId, proposalId, pLevel, docFormat, sessionId, apiServerURL);
	System.debug('******generatedDocId1******'+generatedDocId);			
	 }
		catch(Exception exc){
		System.debug('Could not generate document for ProposalID:'+proposalId+ 'and templateID:'+templateId);
		System.debug('Exception:'+exc);
		}	
	}

	/*********************************
	* author: Standav
	* Date: 24 MAR 2021
	* Developers: harsh and Ravi
	* Description: methods collect Proposal Trigger List on before insert and pass to ProposalTriggerHelper.	
	**********************************/
	
	public static void createFRULineItems(List<Apttus_Proposal__Proposal_Line_Item__c> plItems){
		
		Set<Id> proIdSet = new Set<Id>();
		List<CPQ_FRUCustItemCdMap__c> fruList = new List<CPQ_FRUCustItemCdMap__c>();
		
		for(Apttus_Proposal__Proposal_Line_Item__c pli : plItems){
			
			if(pli.CPQ_CQ_Check__c){	
	if(pli.Apttus_QPConfig__OptionId__c != null){
		proIdSet.add(pli.Apttus_QPConfig__OptionId__c);
	}else{
		proIdSet.add(pli.Apttus_Proposal__Product__c);
		
	}
			}
		}
		
		if(!proIdSet.isEmpty()){
			
			string recTtypeId = 'FRU';
			
			fruList = [SELECT Id,CPQ_FRU_Description__c,CPQ_Asset_Quantity__c,CPQ_Product__c,CPQ_Product_Code__c,
	RecordType.name 
		FROM CPQ_FRUCustItemCdMap__c 
		WHERE CPQ_Product__c IN :proIdSet 
		AND RecordType.name = :recTtypeId];
		 }
		
		if(!fruList.isEmpty()){
			List<CPQ_FRULineItem__c> fliList = new List<CPQ_FRULineItem__c>();
			
			for(Apttus_Proposal__Proposal_Line_Item__c pli : plItems){
	
	if(pli.CPQ_CQ_Check__c){
		
		for(CPQ_FRUCustItemCdMap__c fru : fruList){ 
			
			CPQ_FRULineItem__c fli = new CPQ_FRULineItem__c();
			
			if(pli.Apttus_QPConfig__OptionId__c != null && pli.Apttus_QPConfig__OptionId__c == fru.CPQ_Product__c){
	fli.CPQ_Proposal_Line_item__c = pli.Id;
	fli.CPQ_Proposal__c = pli.Apttus_Proposal__Proposal__c;
	fli.CPQ_Product__c = fru.CPQ_Product__c;
	fli.CPQ_FRU_Description__c = fru.CPQ_FRU_Description__c;
	fli.CPQ_Asset_Quantity__c = fru.CPQ_Asset_Quantity__c;
	fliList.add(fli);
			
			}else if(pli.Apttus_Proposal__Product__c == fru.CPQ_Product__c){
	fli.CPQ_Proposal_Line_item__c = pli.Id;
	fli.CPQ_Proposal__c = pli.Apttus_Proposal__Proposal__c;
	fli.CPQ_Product__c = fru.CPQ_Product__c;
	fli.CPQ_FRU_Description__c = fru.CPQ_FRU_Description__c;
	fli.CPQ_Asset_Quantity__c = fru.CPQ_Asset_Quantity__c;
	fliList.add(fli);
			}   
		}   
	}
			}
			
			if(!fliList.isEmpty()){
	insert fliList;
			}
		}
	}

	public static void ServiceRollupValues(List < Apttus_Proposal__Proposal_Line_Item__c > proposalLineItemList) {

		try {
			List < Apttus_Proposal__Proposal_Line_Item__c > pliCQlist = new List < Apttus_Proposal__Proposal_Line_Item__c > ();

			for (Apttus_Proposal__Proposal_Line_Item__c pli: proposalLineItemList) {

	if (pli.CPQ_CQ_Check__c) {
		pliCQlist.add(pli);
	}
			}



			if (!pliCQlist.isEmpty()) {

	List < Apttus_Proposal__Proposal__c > proptobeUpdated = new List < Apttus_Proposal__Proposal__c > ();

	Map < Id, Map < Decimal, Decimal >> rollupPriceMap = new Map < Id, Map < Decimal, Decimal >> ();
	Map < Id, wrapPriceClass > propSummaryMap = new Map < Id, wrapPriceClass > ();

	for (Apttus_Proposal__Proposal_Line_Item__c pr: pliCQlist) {

		//For Roll up Parent Prices
		//
		if (pr.CPQ_Rollup_Group_Num__c != null) {

			if (rollupPriceMap.containsKey(pr.Apttus_Proposal__Proposal__c)) {

	if (rollupPriceMap.get(pr.Apttus_Proposal__Proposal__c).containsKey(pr.CPQ_Rollup_Group_Num__c)) {

		Decimal netPriceSum = rollupPriceMap.get(pr.Apttus_Proposal__Proposal__c).get(pr.CPQ_Rollup_Group_Num__c) + pr.Apttus_QPConfig__NetPrice__c;

		Map < Decimal, Decimal > m1 = new Map < Decimal, Decimal > ();
		m1 = rollupPriceMap.get(pr.Apttus_Proposal__Proposal__c);
		m1.put(pr.CPQ_Rollup_Group_Num__c, netPriceSum);

		rollupPriceMap.put(pr.Apttus_Proposal__Proposal__c, m1);

	} else {

		Map < Decimal, Decimal > m1 = new Map < Decimal, Decimal > ();
		m1 = rollupPriceMap.get(pr.Apttus_Proposal__Proposal__c);

		m1.put(pr.CPQ_Rollup_Group_Num__c, pr.Apttus_QPConfig__NetPrice__c);

		rollupPriceMap.put(pr.Apttus_Proposal__Proposal__c, m1);

	}

			} else {
	Map < Decimal, Decimal > m2 = new Map < Decimal, Decimal > ();
	m2.put(pr.CPQ_Rollup_Group_Num__c, pr.Apttus_QPConfig__NetPrice__c);
	rollupPriceMap.put(pr.Apttus_Proposal__Proposal__c, m2);

			}
		}
		//For Proposal Price Summary
		//
		if (pr.CPQ_Price_Class__c == 'Engineering' && pr.CPQ_Rollup_Group_Num__c == Null) {

			if (propSummaryMap.containsKey(pr.Apttus_Proposal__Proposal__c)) {
	if (propSummaryMap.get(pr.Apttus_Proposal__Proposal__c).Engineering != null) {
		Decimal tempE = propSummaryMap.get(pr.Apttus_Proposal__Proposal__c).Engineering + pr.Apttus_QPConfig__NetPrice__c;
		wrapPriceClass wp = new wrapPriceClass();
		wp = propSummaryMap.get(pr.Apttus_Proposal__Proposal__c);
		wp.Engineering = tempE;
		propSummaryMap.put(pr.Apttus_Proposal__Proposal__c, wp);
	} else {
		wrapPriceClass wp = new wrapPriceClass();
		wp = propSummaryMap.get(pr.Apttus_Proposal__Proposal__c);
		wp.Engineering = pr.Apttus_QPConfig__NetPrice__c;
		propSummaryMap.put(pr.Apttus_Proposal__Proposal__c, wp);
	}
			} else {
	wrapPriceClass wp = new wrapPriceClass();
	wp.Engineering = pr.Apttus_QPConfig__NetPrice__c;
	propSummaryMap.put(pr.Apttus_Proposal__Proposal__c, wp);
			}

		} else if (pr.CPQ_Price_Class__c == 'Installation' && pr.CPQ_Rollup_Group_Num__c == Null) {

			if (propSummaryMap.containsKey(pr.Apttus_Proposal__Proposal__c)) {
	if (propSummaryMap.get(pr.Apttus_Proposal__Proposal__c).Installation != null) {
		Decimal tempE = propSummaryMap.get(pr.Apttus_Proposal__Proposal__c).Installation + pr.Apttus_QPConfig__NetPrice__c;
		wrapPriceClass wp = new wrapPriceClass();
		wp = propSummaryMap.get(pr.Apttus_Proposal__Proposal__c);
		wp.Installation = tempE;
		propSummaryMap.put(pr.Apttus_Proposal__Proposal__c, wp);
	} else {
		wrapPriceClass wp = new wrapPriceClass();
		wp = propSummaryMap.get(pr.Apttus_Proposal__Proposal__c);
		wp.Installation = pr.Apttus_QPConfig__NetPrice__c;
		propSummaryMap.put(pr.Apttus_Proposal__Proposal__c, wp);
	}
			} else {
	wrapPriceClass wp = new wrapPriceClass();
	wp.Installation = pr.Apttus_QPConfig__NetPrice__c;
	propSummaryMap.put(pr.Apttus_Proposal__Proposal__c, wp);
			}

		} else if ((pr.CPQ_Price_Class__c == 'Other' && pr.CPQ_Rollup_Group_Num__c == Null) || (pr.CPQ_Rollup_Group_Num__c != Null)) {

			if (propSummaryMap.containsKey(pr.Apttus_Proposal__Proposal__c)) {
	if (propSummaryMap.get(pr.Apttus_Proposal__Proposal__c).Other != null) {
		Decimal tempE = propSummaryMap.get(pr.Apttus_Proposal__Proposal__c).Other + pr.Apttus_QPConfig__NetPrice__c;
		wrapPriceClass wp = new wrapPriceClass();
		wp = propSummaryMap.get(pr.Apttus_Proposal__Proposal__c);
		wp.Other = tempE;
		propSummaryMap.put(pr.Apttus_Proposal__Proposal__c, wp);
	} else {
		wrapPriceClass wp = new wrapPriceClass();
		wp = propSummaryMap.get(pr.Apttus_Proposal__Proposal__c);
		wp.Other = pr.Apttus_QPConfig__NetPrice__c;
		propSummaryMap.put(pr.Apttus_Proposal__Proposal__c, wp);
	}
			} else {
	wrapPriceClass wp = new wrapPriceClass();
	wp.Other = pr.Apttus_QPConfig__NetPrice__c;
	propSummaryMap.put(pr.Apttus_Proposal__Proposal__c, wp);
			}

		}

	}



	//For Roll up Parent Prices
	//
	for (Apttus_Proposal__Proposal_Line_Item__c pr: pliCQlist) {
		if (pr.CPQ_Rollup_Group_Parent__c && rollupPriceMap.containsKey(pr.Apttus_Proposal__Proposal__c) && rollupPriceMap.get(pr.Apttus_Proposal__Proposal__c).containsKey(pr.CPQ_Rollup_Group_Num__c)) {

			pr.CPQ_Service_Rollup_Quantity__c = 1;
			pr.CPQ_Service_Rollup_Price__c = rollupPriceMap.get(pr.Apttus_Proposal__Proposal__c).get(pr.CPQ_Rollup_Group_Num__c);

		}
	}

	//For Roll up Parent Prices
	//
	for (Id pr: propSummaryMap.Keyset()) {
		Apttus_Proposal__Proposal__c prop = new Apttus_Proposal__Proposal__c();
		prop.Id = pr;
		prop.CPQ_Service_Engineering_Rollup_Price__c = 0;
		prop.CPQ_Service_Installation_Rollup_Price__c = 0;
		prop.CPQ_Service_Other_Rollup_Price__c = 0;
		if (propSummaryMap.get(pr).Engineering != null) {
			prop.CPQ_Service_Engineering_Rollup_Price__c = propSummaryMap.get(pr).Engineering;
		}
		if (propSummaryMap.get(pr).Installation != null) {
			prop.CPQ_Service_Installation_Rollup_Price__c = propSummaryMap.get(pr).Installation;
		}
		if (propSummaryMap.get(pr).Other != null) {
			prop.CPQ_Service_Other_Rollup_Price__c = propSummaryMap.get(pr).Other;
		}
		proptobeUpdated.add(prop);
	}

	if (!proptobeUpdated.isEmpty()) {
		Update proptobeUpdated;
	}
			}
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, 'ProposalLineItemTriggerHelper', 'ServiceRollupValues');
		}
	}

	/*********************************
	* author: Standav
	* Date: 7 June 2021
	* Developers: Ravi
	* Description: methods used to created output line items which prints on Output Document.	
	**********************************/
	
	public static void processOutputLineItems(List<Apttus_Proposal__Proposal_Line_Item__c> propList) {
		List<CPQ_Output_Line_Item__c> oliListtobeInserted = new List <CPQ_Output_Line_Item__c>();
		List<CPQ_Output_Line_Item__c> oliListtobeDeleted = new List <CPQ_Output_Line_Item__c>();
		Set<String> propId = new Set<String>();
		Set<Id> proIdSet = new Set<Id>();
		
		Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>> transmap = new Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>>();
		Map<String,List<CPQ_FRUCustItemCdMap__c>> frumap = new Map<String,List<CPQ_FRUCustItemCdMap__c>>();
		List<CPQ_FRUCustItemCdMap__c> fruList = new List<CPQ_FRUCustItemCdMap__c>();
		Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>> siteLinesmap = new Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>>();
		Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>> transmapChild = new Map<String,List<Apttus_Proposal__Proposal_Line_Item__c>>();
		set<String> subheadingSet = new set<String>(); 
		set<String> SortedOrderSet = new set<String>();
		set<String> ChildheadingSet = new set<String>();
		system.debug('testing2 - '+ Limits.getQueries());
		//Map creation based on Headings as key and pli as values
		//
		for(Apttus_Proposal__Proposal_Line_Item__c pli:propList){
			
			if(pli.CPQ_CQ_Check__c && (pli.CPQ_Parent_Secondary_Category__c != null && pli.CPQ_Parent_Secondary_Category__c == 'Site Model')){
	
	system.debug('testing4 - '+ Limits.getQueries());
	  /* if(siteLinesmap.containsKey(pli.Apttus_Proposal__Proposal__c+'_'+pli.Apttus_QPConfig__LineNumber__c)) {
			List<Apttus_Proposal__Proposal_Line_Item__c> opliList = siteLinesmap.get(pli.Apttus_Proposal__Proposal__c+'_'+pli.Apttus_QPConfig__LineNumber__c);
			opliList.add(pli);
			siteLinesmap.put(pli.Apttus_Proposal__Proposal__c+'_'+pli.Apttus_QPConfig__LineNumber__c, opliList);
		} else {
			List<Apttus_Proposal__Proposal_Line_Item__c> opliList1 = new List<Apttus_Proposal__Proposal_Line_Item__c>();
			opliList1.add(pli);
			siteLinesmap.put(pli.Apttus_Proposal__Proposal__c+'_'+pli.Apttus_QPConfig__LineNumber__c,opliList1);
		}*/
		
		if(pli.CPQ_Sub_Heading__c != null){
   
		if(transmapChild.containsKey(pli.Apttus_Proposal__Proposal__c+'_'+pli.Apttus_QPConfig__LineNumber__c+'_'+pli.CPQ_Sub_Heading__c)) {
			List<Apttus_Proposal__Proposal_Line_Item__c> liListC = transmapChild.get(pli.Apttus_Proposal__Proposal__c+'_'+pli.Apttus_QPConfig__LineNumber__c+'_'+pli.CPQ_Sub_Heading__c);
			liListC.add(pli);
			transmapChild.put(pli.Apttus_Proposal__Proposal__c+'_'+pli.Apttus_QPConfig__LineNumber__c+'_'+pli.CPQ_Sub_Heading__c, liListC);
			ChildheadingSet.add(pli.CPQ_Sub_Heading__c);
		} else {
			List<Apttus_Proposal__Proposal_Line_Item__c> liListC1 = new List<Apttus_Proposal__Proposal_Line_Item__c>();
			liListC1.add(pli);
			transmapChild.put(pli.Apttus_Proposal__Proposal__c+'_'+pli.Apttus_QPConfig__LineNumber__c+'_'+pli.CPQ_Sub_Heading__c,liListC1);
			ChildheadingSet.add(pli.CPQ_Sub_Heading__c);
		}
		
		
	}else{
		
		if(transmapChild.containsKey(pli.Apttus_Proposal__Proposal__c+'_'+pli.Apttus_QPConfig__LineNumber__c+'_'+'Other')) {
			List<Apttus_Proposal__Proposal_Line_Item__c> liListC = transmapChild.get(pli.Apttus_Proposal__Proposal__c+'_'+pli.Apttus_QPConfig__LineNumber__c+'_'+'Other');
			liListC.add(pli);
			transmapChild.put(pli.Apttus_Proposal__Proposal__c+'_'+pli.Apttus_QPConfig__LineNumber__c+'_'+'Other', liListC);
		} else {
			List<Apttus_Proposal__Proposal_Line_Item__c> liListC1 = new List<Apttus_Proposal__Proposal_Line_Item__c>();
			liListC1.add(pli);
			transmapChild.put(pli.Apttus_Proposal__Proposal__c+'_'+pli.Apttus_QPConfig__LineNumber__c+'_'+'Other',liListC1);
		}
		
		
	}
	
	
			}
			//Parent lines
			//
			if(pli.CPQ_CQ_Check__c && ((pli.CPQ_Parent_Secondary_Category__c != null && (pli.CPQ_Parent_Secondary_Category__c != 'Solution Model' && pli.CPQ_Parent_Secondary_Category__c != 'Site Model'))|| pli.Apttus_QPConfig__LineType__c == 'Product/Service')){		
	propId.add(pli.Apttus_Proposal__Proposal__c);
	
	if(pli.Apttus_QPConfig__OptionId__c != null){
		proIdSet.add(pli.Apttus_QPConfig__OptionId__c);
	}else{
		proIdSet.add(pli.Apttus_Proposal__Product__c);
	}
	
	
	if(pli.CPQ_Sub_Heading__c != null){
		
		if(pli.CPQ_Price_Class__c == null || (pli.CPQ_Price_Class__c != null && pli.CPQ_Display_in_quote_report_as_line_item__c)){
		
		if(transmap.containsKey(pli.Apttus_Proposal__Proposal__c+'_'+'SH'+'_'+pli.CPQ_Sub_Heading__c)) {
			List<Apttus_Proposal__Proposal_Line_Item__c> liList = transmap.get(pli.Apttus_Proposal__Proposal__c+'_'+'SH'+'_'+pli.CPQ_Sub_Heading__c);
			liList.add(pli);
			transmap.put(pli.Apttus_Proposal__Proposal__c+'_'+'SH'+'_'+pli.CPQ_Sub_Heading__c, liList);
		} else {
			List<Apttus_Proposal__Proposal_Line_Item__c> liList1 = new List<Apttus_Proposal__Proposal_Line_Item__c>();
			liList1.add(pli);
			transmap.put(pli.Apttus_Proposal__Proposal__c+'_'+'SH'+'_'+pli.CPQ_Sub_Heading__c,liList1);
		}
		
		subheadingSet.add(pli.CPQ_Sub_Heading__c);
		
		}
		
	}else if(pli.CPQ_Price_Class__c != null){
		
		if(pli.CPQ_Price_Class__c != 'Transportation' && pli.CPQ_Price_Class__c != 'Other' && pli.CPQ_Display_in_quote_report_as_line_item__c){
		if(transmap.containsKey(pli.Apttus_Proposal__Proposal__c+'_'+'PC'+'_'+pli.CPQ_Price_Class__c)) {
			List<Apttus_Proposal__Proposal_Line_Item__c> liList = transmap.get(pli.Apttus_Proposal__Proposal__c+'_'+'PC'+'_'+pli.CPQ_Price_Class__c);
			liList.add(pli);
			transmap.put(pli.Apttus_Proposal__Proposal__c+'_'+'PC'+'_'+pli.CPQ_Price_Class__c, liList);
		} else {
			List<Apttus_Proposal__Proposal_Line_Item__c> liList1 = new List<Apttus_Proposal__Proposal_Line_Item__c>();
			liList1.add(pli);
			transmap.put(pli.Apttus_Proposal__Proposal__c+'_'+'PC'+'_'+pli.CPQ_Price_Class__c,liList1);
		}
		}else if(pli.CPQ_Price_Class__c == 'Transportation' || pli.CPQ_Price_Class__c == 'Other'){
		 if(transmap.containsKey(pli.Apttus_Proposal__Proposal__c+'_'+'PC'+'_'+'Other Services')) {
			List<Apttus_Proposal__Proposal_Line_Item__c> liList = transmap.get(pli.Apttus_Proposal__Proposal__c+'_'+'PC'+'_'+'Other Services');
			liList.add(pli);
			transmap.put(pli.Apttus_Proposal__Proposal__c+'_'+'PC'+'_'+'Other Services', liList);
		} else {
			List<Apttus_Proposal__Proposal_Line_Item__c> liList1 = new List<Apttus_Proposal__Proposal_Line_Item__c>();
			liList1.add(pli);
			transmap.put(pli.Apttus_Proposal__Proposal__c+'_'+'PC'+'_'+'Other Services',liList1);
		}   
			
		}
		
	}else if(pli.CPQ_Price_Class__c == null){
		
		if(pli.CPQ_Secondary_Category__c != null && (pli.CPQ_Secondary_Category__c == 'Site Model' || pli.CPQ_Secondary_Category__c == 'Incentive')){
			if(transmap.containsKey(pli.Apttus_Proposal__Proposal__c+'_'+'SC'+'_'+pli.CPQ_Secondary_Category__c)) {
	List<Apttus_Proposal__Proposal_Line_Item__c> liList = transmap.get(pli.Apttus_Proposal__Proposal__c+'_'+'SC'+'_'+pli.CPQ_Secondary_Category__c);
	liList.add(pli);
	transmap.put(pli.Apttus_Proposal__Proposal__c+'_'+'SC'+'_'+pli.CPQ_Secondary_Category__c, liList);
			} else {
	List<Apttus_Proposal__Proposal_Line_Item__c> liList1 = new List<Apttus_Proposal__Proposal_Line_Item__c>();
	liList1.add(pli);
	transmap.put(pli.Apttus_Proposal__Proposal__c+'_'+'SC'+'_'+pli.CPQ_Secondary_Category__c,liList1);
			}
			
		}else{
			if(transmap.containsKey(pli.Apttus_Proposal__Proposal__c+'_'+'SC'+'_'+'Other')) {
	List<Apttus_Proposal__Proposal_Line_Item__c> liList = transmap.get(pli.Apttus_Proposal__Proposal__c+'_'+'SC'+'_'+'Other');
	liList.add(pli);
	transmap.put(pli.Apttus_Proposal__Proposal__c+'_'+'SC'+'_'+'Other', liList);
			} else {
	List<Apttus_Proposal__Proposal_Line_Item__c> liList1 = new List<Apttus_Proposal__Proposal_Line_Item__c>();
	liList1.add(pli);
	transmap.put(pli.Apttus_Proposal__Proposal__c+'_'+'SC'+'_'+'Other',liList1);
			}
			
			
		}
		
		
	}
			}
		}
		ChildheadingSet.add('Other');
		//Deleting the existing Output lines for new finalizations
		//
		system.debug('testing6 - '+ Limits.getQueries());
		oliListtobeDeleted = [select id from CPQ_Output_Line_Item__c where CPQ_Output_Quote_Proposal__c IN: propId];
		
		if(!oliListtobeDeleted.isEmpty()){
			Delete oliListtobeDeleted;
		}
		//For Sorting the headings on Output document
		//
		if(!propId.isEmpty()){
			for(String st:propId){
	SortedOrderSet.add(st+'_'+'SC'+'_'+'Site Model');
	
	  if(!subheadingSet.isEmpty()){
		for(String sb:subheadingSet){
			SortedOrderSet.add(st+'_'+'SH'+'_'+sb);
		}   
	}
	SortedOrderSet.add(st+'_'+'SC'+'_'+'Other');
	SortedOrderSet.add(st+'_'+'PC'+'_'+'Engineering');
	SortedOrderSet.add(st+'_'+'PC'+'_'+'Installation');
	SortedOrderSet.add(st+'_'+'PC'+'_'+'Other Services');
	SortedOrderSet.add(st+'_'+'SC'+'_'+'Incentive');
	
			}
			
		}
		//Getting FRU lines
		//
		if(!proIdSet.isEmpty()){
			
			string recTtypeId = 'FRU';
			
			fruList = [SELECT Id,CPQ_FRU_Description__c,CPQ_Asset_Quantity__c,CPQ_Product__c,CPQ_Product_Code__c,
		RecordType.name 
		FROM CPQ_FRUCustItemCdMap__c 
		WHERE CPQ_Product__c IN :proIdSet 
		AND RecordType.name = :recTtypeId];
			
			for(CPQ_FRUCustItemCdMap__c fr:fruList){		
	
	if(frumap.containsKey(fr.CPQ_Product__c)) {
		List<CPQ_FRUCustItemCdMap__c> fruList1 = frumap.get(fr.CPQ_Product__c);
		fruList1.add(fr);
		frumap.put(fr.CPQ_Product__c, fruList1);
	} else {
		List<CPQ_FRUCustItemCdMap__c> fruList2 = new List<CPQ_FRUCustItemCdMap__c>();
		fruList2.add(fr);
		frumap.put(fr.CPQ_Product__c, fruList2);
	}
			}	
			
		}
		
		//Creating sort ordered lines for printing in the output document
		//
		if(!transmap.Keyset().isEmpty() && !SortedOrderSet.isEmpty()){
			Integer sno = 0;
			for(String ts:SortedOrderSet){
	if(transmap.containsKey(ts)){
	CPQ_Output_Line_Item__c oli1 = new CPQ_Output_Line_Item__c();
	List<String> tr = new List<String>();
	tr = ts.split('_');
	oli1.CPQ_Type__c = 'Heading';
	
	if(tr[1] == 'SC' && tr[2] == 'Incentive' && tr[2] != 'Site Model'){
		oli1.CPQ_Product_Code__c = 'Incentive Credit';
	}else if(tr[2] != 'Site Model'){
		oli1.CPQ_Product_Code__c = tr[2];
	}   
	oli1.CPQ_Output_Quote_Proposal__c = tr[0];
	
	if(oli1.CPQ_Product_Code__c != null){
	oliListtobeInserted.add(oli1);
	}
	Boolean spaceCheck = false;
	for(Apttus_Proposal__Proposal_Line_Item__c pli:transmap.get(ts)){
		
		if(tr[1] == 'SC' && tr[2] == 'Site Model'){
	CPQ_Output_Line_Item__c oli8 = new CPQ_Output_Line_Item__c();
	oli8.CPQ_Type__c = 'Heading';
	oli8.CPQ_Product_Code__c = tr[2];
	oli8.CPQ_Output_Quote_Proposal__c = tr[0];
	oliListtobeInserted.add(oli8);
	
		}
		
		Boolean Transport = false;
		if(pli.CPQ_Price_Class__c != null && pli.CPQ_Price_Class__c == 'Transportation'){
		Transport = true;
		}
		
		CPQ_Output_Line_Item__c oli2 = new CPQ_Output_Line_Item__c();
		oli2.CPQ_Type__c = 'Line Item';
		oli2.CPQ_Output_Quote_Proposal__c = tr[0];
		oli2.CPQ_Product_Code__c = pli.Product_Code__c;
		oli2.CPQ_Description__c = pli.CPQ_Final_Product_Name__c;
		
		if(pli.CPQ_Price_Class__c != null && pli.CPQ_Rollup_Group_Parent__c 
		&& pli.CPQ_Service_Rollup_Price__c != null && pli.CPQ_Service_Rollup_Quantity__c != null){
		oli2.CPQ_Quantity_2__c = pli.CPQ_Service_Rollup_Quantity__c;
		oli2.CPQ_Net_Price__c = pli.CPQ_Service_Rollup_Price__c;			
		}else{
		oli2.CPQ_Quantity_2__c = pli.Apttus_QPConfig__Quantity2__c;
		oli2.CPQ_Net_Price__c = pli.Apttus_QPConfig__NetPrice__c;
		}
		

		if((pli.NokiaCPQ_Configuration_Type__c == 'Standalone' && pli.NokiaCPQ_Item_Type__c != null && (pli.NokiaCPQ_Item_Type__c == 'Software' || pli.NokiaCPQ_Item_Type__c == 'Hardware'))){
			
	if(pli.Apttus_QPConfig__BasePriceOverride__c != null){
			oli2.CPQ_DA_Unit_Price__c = pli.Apttus_QPConfig__BasePriceOverride__c;  
			}else if(pli.CPQ_Agreement_Contract_Price__c != null){
			oli2.CPQ_DA_Unit_Price__c = pli.CPQ_Agreement_Contract_Price__c;	
			}else if(pli.Apttus_QPConfig__ListPrice__c != null){
			oli2.CPQ_DA_Unit_Price__c = pli.Apttus_QPConfig__ListPrice__c;  
			}
			oli2.CPQ_List_Price__c = pli.Apttus_QPConfig__ListPrice__c;
			
		}
		
		if(((pli.NokiaCPQ_Configuration_Type__c == 'Standalone' && pli.NokiaCPQ_Item_Type__c != null && (pli.NokiaCPQ_Item_Type__c == 'Software' || pli.NokiaCPQ_Item_Type__c == 'Hardware')) || pli.CPQ_Secondary_Category__c == 'Site Model' || pli.CPQ_Secondary_Category__c == 'Solution Model' ) && pli.Apttus_QPConfig__NetUnitPrice__c != null){
		oli2.CPQ_Net_Unit_Price__c = pli.Apttus_QPConfig__NetUnitPrice__c;  
			
		}
		
		if(pli.CPQ_Customer_Item_Code__c != null){
		oli2.CPQ_Customer_Item_Code__c = pli.CPQ_Customer_Item_Code__c;
		}
		
		if(Transport){
		oli2.CPQ_Transportation__c = true;  
		}
		
		sno = sno + 1;
		oli2.CPQ_Line_Number__c = sno;
		
		oliListtobeInserted.add(oli2);
		
		String prodID;
		if(pli.Apttus_QPConfig__OptionId__c != null){
			prodID = pli.Apttus_QPConfig__OptionId__c;
		}else{
			prodID = pli.Apttus_Proposal__Product__c;
		}
		if(frumap.containsKey(prodID)){
			for(CPQ_FRUCustItemCdMap__c fru:frumap.get(prodID)){
	CPQ_Output_Line_Item__c oli3 = new CPQ_Output_Line_Item__c();
	oli3.CPQ_Type__c = 'FRU'; 
	oli3.CPQ_Output_Quote_Proposal__c = tr[0];	  
	oli3.CPQ_Description__c = fru.CPQ_FRU_Description__c;
	oli3.CPQ_Asset_Line_Quantity__c = fru.CPQ_Asset_Quantity__c;
	if(Transport){
	oli3.CPQ_Transportation__c = true;  
	}
	oliListtobeInserted.add(oli3);
			}	
			
		}
		
		/*if(siteLinesmap.containsKey(pli.Apttus_Proposal__Proposal__c+'_'+pli.Apttus_QPConfig__LineNumber__c)){
			for(Apttus_Proposal__Proposal_Line_Item__c cLi:siteLinesmap.get(pli.Apttus_Proposal__Proposal__c+'_'+pli.Apttus_QPConfig__LineNumber__c)){
	
	CPQ_Output_Line_Item__c oli5 = new CPQ_Output_Line_Item__c();
	oli5.CPQ_Type__c = 'Child Line Item'; 
	oli5.CPQ_Output_Quote_Proposal__c = tr[0];	  
	oli5.CPQ_Description__c = cLi.Apttus_Proposal__Description__c;
	oli5.CPQ_Asset_Line_Quantity__c = cLi.Apttus_QPConfig__Quantity2__c;
	oliListtobeInserted.add(oli5);
	
			}	
			
		}*/
		
		for(string chstr:ChildheadingSet){
			if(transmapChild.containsKey(pli.Apttus_Proposal__Proposal__c+'_'+pli.Apttus_QPConfig__LineNumber__c+'_'+chstr)){
	CPQ_Output_Line_Item__c oli6 = new CPQ_Output_Line_Item__c();
	oli6.CPQ_Type__c = 'Heading';
	oli6.CPQ_Product_Code__c = chstr;  
	oli6.CPQ_Output_Quote_Proposal__c = tr[0];
	if(Transport){
	oli6.CPQ_Transportation__c = true;  
	}
	oliListtobeInserted.add(oli6);
	
	
	for(Apttus_Proposal__Proposal_Line_Item__c cLi:transmapChild.get(pli.Apttus_Proposal__Proposal__c+'_'+pli.Apttus_QPConfig__LineNumber__c+'_'+chstr)){
		
		CPQ_Output_Line_Item__c oli5 = new CPQ_Output_Line_Item__c();
		oli5.CPQ_Type__c = 'Child Line Item'; 
		oli5.CPQ_Output_Quote_Proposal__c = tr[0]; 
		oli5.CPQ_Product_Code__c = cLi.Product_Code__c;		
		oli5.CPQ_Description__c = cLi.CPQ_Final_Product_Name__c;
		oli5.CPQ_Quantity_2__c = cLi.Apttus_QPConfig__Quantity2__c;
		if(cLi.Apttus_QPConfig__ListPrice__c != null){
		oli5.CPQ_DA_Unit_Price__c = cLi.Apttus_QPConfig__ListPrice__c;
		oli5.CPQ_List_Price__c = cLi.Apttus_QPConfig__ListPrice__c;
		}
		if(pli.CPQ_Customer_Item_Code__c != null){
	 oli5.CPQ_Customer_Item_Code__c = pli.CPQ_Customer_Item_Code__c;
		 }
		if(Transport){
		oli5.CPQ_Transportation__c = true;  
		 }
		oliListtobeInserted.add(oli5);
		
		
	}
	
		CPQ_Output_Line_Item__c oli7 = new CPQ_Output_Line_Item__c();
		oli7.CPQ_Type__c = 'Space';
		oli7.CPQ_Output_Quote_Proposal__c = tr[0];
		if(Transport){
		oli7.CPQ_Transportation__c = true;  
		 }
		oliListtobeInserted.add(oli7);
		spaceCheck = true;
	
			}
		}
	
		
	}
	
	if(!spaceCheck){
	CPQ_Output_Line_Item__c oli4 = new CPQ_Output_Line_Item__c();
	oli4.CPQ_Type__c = 'Space';
	oli4.CPQ_Output_Quote_Proposal__c = tr[0];
	oliListtobeInserted.add(oli4);
	}
			}
			}
			
			
			if(!oliListtobeInserted.isEmpty()){
	Insert oliListtobeInserted;   
	
			}
			
		} 
	}

	/*********************************
	* author: Standav
	* Date: 11 July 2021
	* Developers: Jithin
	* Description: methods used to created output line items which prints on Output Document.	
	**********************************/
	public static void processDiscountsApplied(List<Apttus_Proposal__Proposal_Line_Item__c> propList) {
		try {
			String appliedDiscountsInfo;
			String quoteId;
			for(Apttus_Proposal__Proposal_Line_Item__c pli:propList){
	if(String.isNotBlank(pli.CPQ_Applied_Discounts_Info__c)) {
		appliedDiscountsInfo = pli.CPQ_Applied_Discounts_Info__c;
		quoteId = pli.Apttus_Proposal__Proposal__c;
	}
			}
			if(String.isNotBlank(appliedDiscountsInfo)) {
	Map<Id, CPQ_QuoteContractualDiscount__c> discountEntryById = new Map<Id, CPQ_QuoteContractualDiscount__c>([
		SELECT Id, CPQ_Applied_Discount__c FROM CPQ_QuoteContractualDiscount__c WHERE CPQ_Proposal__c = :quoteId
	]);
	for(String discountInfo : appliedDiscountsInfo.split(';')) {
		String discountEntryId = discountInfo.split(':')[0].trim();
		Decimal appliedDiscount = Decimal.valueOf(discountInfo.split(':')[1].trim());
		if(discountEntryById.containsKey(discountEntryId)) {
			discountEntryById.get(discountEntryId).CPQ_Applied_Discount__c = appliedDiscount;
		}
	}
	if(!discountEntryById.isEmpty()) {
		update discountEntryById.values();
	}
			}
		} catch(Exception e) {
			System.debug('Exception parsing Discounts applied under quote: ' + e.getStackTraceString());
		}
	}

		public class wrapPriceClass {

		public Decimal Engineering {
			get;
			set;
		}
		public Decimal Installation {
			get;
			set;
		}
		public Decimal Other {
			get;
			set;
		}
	}
}