/*************************************************************
@Name: NokiaCPQ_QuoteCreationCtrlExtn
@Author: Wipro
@Description: Controler Extension class for NokiaCPQ_newQuoteVF.
			This class creates quote based on the quote record type selected by the user. 
Test Class: NokiaCPQ_QuoteCreationCtrlExtnTest
******************************************************************/

public with sharing class NokiaCPQ_QuoteCreationCtrlExtn {
	
	private Apttus_Proposal__Proposal__c quote{get;set;}
	Opportunity opty;
	Map<String, CPQ_Quote_RT_and_FS_mapping__mdt> quoteRtFsMapingMdtMap; 
	//List<SelectOption> getRTOptionsItems;
	
	//Database.SaveResult sr{get;set;}
	
	String quoteSuccessURL{get;set;}
	//Boolean isRedirect{get;set;}
	Boolean displayOnQuote{get;set;}
 	Boolean displayOnQTCQuote{get;set;}
	Boolean displayOnQTCQuotePT{get;set;}
	Boolean displayNewQuotePB{get;set;}
	Boolean displayRecordTypeSelectionPB{get;set;}
	Boolean displaySuccessMessagePB{get;set;}
	Boolean fixedNetworkSelected{get;set;}
	
	
	String recordTypeSelection{get;set;}
	
	
	 public NokiaCPQ_QuoteCreationCtrlExtn(ApexPages.StandardController stdController)
	{
		List<String> optyFieldList = new List<String>{'Id', 'Name', 'OwnerId', 'LastModifiedById'};
		 if (!Test.isRunningTest()) stdController.addFields(optyFieldList);
		opty = (Opportunity) stdController.getRecord();
		
		quote = new Apttus_Proposal__Proposal__c();
		//quote.RecordTypeId = ID.valueOf('01241000001coFvAAI');
		//quote.RecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CPQ_QTC_NCQ_Quote').getRecordTypeId();
		quote.Apttus_Proposal__Opportunity__c = opty.Id;
		quote.CQ_Sales_Lead__c = opty.OwnerId;
		quote.CQ_Lead__c = opty.LastModifiedById;
		
		this.displayOnQuote = true;
		this.displayOnQTCQuote = true;
		this.displayOnQTCQuotePT = true;
		
		quoteRtFsMapingMdtMap = new Map<String, CPQ_Quote_RT_and_FS_mapping__mdt>{};
		for(CPQ_Quote_RT_and_FS_mapping__mdt rTfs : [SELECT MasterLabel, Record_Type_Name__c, Field_Set_Name__c, Is_Active__c, Display_Order__c FROM CPQ_Quote_RT_and_FS_mapping__mdt  where Is_Active__C = true  order by Display_Order__c])
		{
			quoteRtFsMapingMdtMap.put(rTfs.Record_Type_Name__c, rTfs);
		} 
		/*** On select record type : Hide/Show Record Selection PB, New Quote PB and Show Success Message PB ***/
		this.displayRecordTypeSelectionPB = true;
		this.displayNewQuotePB = false;
		this.displaySuccessMessagePB = false;
		/******************/
		fixedNetworkSelected = false;
	}
	
	public PageReference recordTypeChange()
	{
		/*** On select record type : Hide/Show Record Selection PB, New Quote PB and Show Success Message PB ***/
		this.displayRecordTypeSelectionPB = false;
		this.displayNewQuotePB = true;
		this.displaySuccessMessagePB = false;
		/******************/
		quote.RecordTypeId = 
			Schema.SObjectType.Apttus_Proposal__Proposal__c	.getRecordTypeInfosByDeveloperName().get(recordTypeSelection).getRecordTypeId();
		if(recordTypeSelection.equalsIgnoreCase('Direct_Quote'))
		{
			this.displayOnQuote = true;
			this.displayOnQTCQuote = false;
			this.displayOnQTCQuotePT = false;			
		}else if(recordTypeSelection.equalsIgnoreCase('CPQ_QTC_NCQ_Quote'))
		{
			this.displayOnQuote = false;
			this.displayOnQTCQuote = true;
			this.displayOnQTCQuotePT = false;
		}else if(recordTypeSelection.equalsIgnoreCase('Contracted_Quote')){
			this.displayOnQuote = false;
			this.displayOnQTCQuote = false;
			this.displayOnQTCQuotePT = true;
		}else
		{
			this.displayOnQuote = false;
			this.displayOnQTCQuote = false;
			this.displayOnQTCQuotePT = false;
		}
		return null;
	}
	
	public PageReference portfolioChanged()
	{
		if(quote.NokiaCPQ_Portfolio__c.equalsIgnoreCase('Fixed Network') )
		{
			fixedNetworkSelected = true;
			quote.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c = false;
			quote.NokiaCPQ_Maintenance_Type__c = null;
			quote.NokiaCPQ_Existing_IONMaint_Contract__c = null;
			quote.NokiaCPQ_No_of_Years__c = null;
		}else
		{
			fixedNetworkSelected = false;
		}
		
		return null;
	}
	
	public List<SelectOption> getRTOptionsItems() {
		List<SelectOption> rToptions = new List<SelectOption>();
		for(CPQ_Quote_RT_and_FS_mapping__mdt rTfs : quoteRtFsMapingMdtMap.values() )
		{
			rToptions.add(new SelectOption(rTfs.Record_Type_Name__c, rTfs.MasterLabel));
		}
		//options.add(new SelectOption('Direct Quote','New Quote'));
		//options.add(new SelectOption('QTC NCQ Quote','New QTC Quote - CPQ'));
		//options.add(new SelectOption('CQ Editable Record Type','New QTC Quote - Surround/PT'));
 
		return rToptions;
	}
	
	public List<Schema.FieldSetMember> getFields() {
		//New_Quote_FieldSet, New_QTC_Quote_CPQ_FieldSet, New_QTC_Quote_Surround_PT_FieldSet	
		return Schema.SObjectType.Apttus_Proposal__Proposal__c.fieldSets.getMap().get(quoteRtFsMapingMdtMap.get(recordTypeSelection).Field_Set_Name__c).getFields();
	}
		
	// Save quote and redirect to quote
	public PageReference save() {
  	Boolean isRedirect = false;
	Database.SaveResult sr = Database.insert(quote, false);
 	
		 if (sr.isSuccess()) {
			isRedirect = true;
		}
		else {
			for(Database.Error err : sr.getErrors()) {
				Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL,err.getMessage()));
			}
			isRedirect = false;
		}
	
		if(isRedirect)
		{	
			PageReference quotePage = new ApexPages.StandardController(quote).view();
			quotePage.setRedirect(true);
			return quotePage;
		}else{
			return NULL;
		}
	}
	
	public PageReference saveAndSuccessMessage() {
  	Boolean isRedirect = false;
	Database.SaveResult sr = Database.insert(quote, false);
 	
		 if (sr.isSuccess()) {
			 
			String quotePageURL = new ApexPages.StandardController(quote).view().getUrl();
			String quoteURL = '<a id="theLink" name="theLink" href="'+ quotePageURL+'" style="font-style:italic">'+quote.Apttus_Proposal__Proposal_Name__c+'</a>';
			quoteSuccessURL =  ' Quote ' +quoteURL+' created successfully ';
			Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.CONFIRM,quoteSuccessURL));
			 
			/*** On select record type : Hide/Show Record Selection PB, New Quote PB and Show Success Message PB ***/
			this.displayRecordTypeSelectionPB = false;
			this.displayNewQuotePB = false;
			this.displaySuccessMessagePB = true;
			/******************/ 
		 }
		else {
			 for(Database.Error err : sr.getErrors()) {
				Apexpages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.FATAL,err.getMessage()));
			}
		 }
		return null;
	}
	
	public PageReference goToOpportunity()
	{
		PageReference optyPage = new ApexPages.StandardController(opty).view();
		optyPage.setRedirect(true);
		return optyPage;
	}
	
		
	public Apttus_Proposal__Proposal__c getQuote() 
	{	return this.quote; 	}
	
	
	public String getQuoteSuccessURL()
	{	return this.quoteSuccessURL; }
	/*public Boolean getIsRedirect()
	{	return this.isRedirect; }*/
	public Boolean getDisplayOnQuote()
	{	return this.displayOnQuote; }
	public Boolean getDisplayOnQTCQuote()
	{	return this.displayOnQTCQuote; }
	public Boolean getDisplayOnQTCQuotePT()
	{	return this.displayOnQTCQuotePT; }

	public Boolean getDisplayNewQuotePB()
	{	return this.displayNewQuotePB; }
	public Boolean getDisplayRecordTypeSelectionPB()
	{ 	return this.displayRecordTypeSelectionPB; }
	public Boolean getDisplaySuccessMessagePB()
	{ 	return this.displaySuccessMessagePB; 	}
	public Boolean getFixedNetworkSelected()
	{ 	return this.fixedNetworkSelected; 	}
	
	   
	
	public String getRecordTypeSelection()
	{ 	return this.recordTypeSelection; 	}
	public String setRecordTypeSelection(String recordSelection)
	{ 	return this.recordTypeSelection = recordSelection; 	}
}