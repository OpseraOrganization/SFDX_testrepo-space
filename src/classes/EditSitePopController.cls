/*************************************************************
@Name: EditSitePopController
@Author: Mitul Parmar
@CreateDate: 03-Aug-2017
@Description: This is for updating sitename on required line items

@Modified By: Mitul Parmar
@Modified Date : 16-Aug-2017
@Description : Updated logic for updating site name on line item


@Modified By: Chhedika Deshmukh
@Modified Date : 23-March-2018
@Description : Updated logic for getting correct currency format on UI Req 4043
*/
public class EditSitePopController {
public List<LineItemSiteWrapper> siteWrapperList{get;set;}
public List<OptionItem> optionItemList{get;set;}  
public Id currentRecordId{get;set;}
public String selectedSite{get;set;}
public Id opportunityId;
public String configId2; 
public String flowName; 
public String configRequestId; 
public pageReference pr;
public Integer itemsPerPage{get;set;}
public static String finalUrl{get;set;}
public static String quoteType{get;set;}


//user defined constructor for initializing required parameters
public EditSitePopController(){										 
	currentRecordId  = ApexPages.CurrentPage().getparameters().get(GlobalConstants.PROPOSALID);
	siteWrapperList = new list<LineItemSiteWrapper>();
	prepareSiteWrapper();
	configId2 = ApexPages.currentPage().getParameters().get(GlobalConstants.PROPOSALID); 
	configRequestId = ApexPages.currentPage().getParameters().get(GlobalConstants.REQUESTID);
	
	Apttus_Config2__ConfigUserPreferences__c userPreference = Apttus_Config2__ConfigUserPreferences__c.getOrgDefaults();
	itemsPerPage = Integer.valueOf(userPreference.Apttus_Config2__ItemsPerPage__c);
	finalUrl = Site.getPathPrefix()+GlobalConstants.CONFIGID + configId2  + GlobalConstants.AMPREQUESTID + configRequestId; 
}

//init method which populates all the required objects
public PageReference prepareSiteWrapper(){
	try{ if(currentRecordId != null){
		for(Apttus_Config2__LineItem__c lineItem : getLineItem()){
			siteWrapperList.add(new LineItemSiteWrapper(false,lineItem));
			if(lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c != null){
	opportunityId = lineItem.Apttus_Config2__ConfigurationId__r.Apttus_QPConfig__Proposald__r.Apttus_Proposal__Opportunity__c;
	quoteType = lineItem.Quote_Type__c;
	system.debug('quote type--'+lineItem.Quote_Type__c);
			}
		}			
	}
	}
	catch(Exception e){
	  ExceptionHandler.addException(e,EditSitePopController.class.getName(),GlobalConstants.ERROR_ST);
	}
	system.debug('Record List :--- '+siteWrapperList.size());
	return null;
}

//get JSON object of selected line items
public String getSiteWrapperList() {  
	try{ system.debug('==lineItemWrapperList=='+siteWrapperList.size());
	}
	catch(Exception e){
	  ExceptionHandler.addException(e,EditSitePopController.class.getName(),GlobalConstants.ERROR_ST);
	}
		return JSON.serialize(siteWrapperList);
}

//prepares the site wrapper list and loads all the selected line item to be updated on page.
public String getSiteWrapper() {  
	siteWrapperList = new list<LineItemSiteWrapper>();
	try{ if(currentRecordId != null){			
		LineItemSiteWrapper swrapper;
		for(Apttus_Config2__LineItem__c lineItem : getLineItem()){
			siteWrapperList.add(new LineItemSiteWrapper(false,lineItem));
		}	  
	}
	}
	catch(Exception e){
	  ExceptionHandler.addException(e,EditSitePopController.class.getName(),GlobalConstants.ERROR_ST);
	}
	return JSON.serialize(siteWrapperList);
}

//this method gets the data for line item from the field set
public list<Apttus_Config2__LineItem__c> getLineItem(){
	String lineItemType = GlobalConstants.PROVICE;
	String  lineItemsourceType = GlobalConstants.SOURCE;
	String  lineItemWavelitesource = GlobalConstants.WAVELITESOURCE;  //Added by RG:[11/09] for Defect D-12930 
	set<String> chargeTypeSet = new set<String>();
	chargeTypeSet.addall(system.label.Charge_Type.split(GlobalConstants.COMMAS));
	
	String query = GlobalConstants.SELECTQUERY;
	try{for(Schema.FieldSetMember f : SObjectType.Apttus_Config2__LineItem__c.FieldSets.EditSite_Column_Field_Set.getFields()) {
		query += f.getFieldPath() + GlobalConstants.COMMASPACE;
	}
	}
	catch(Exception e){
	  ExceptionHandler.addException(e,EditSitePopController.class.getName(),GlobalConstants.ERROR_ST);
	}
	query += GlobalConstants.QUERYID;
	//System.debug('query-->'+query);
	//System.debug('Database query-->'+Database.query(query));
	return Database.query(query);	 
}

//this method gets the list of Site Names for be updated from opportunity 
public String getSitesOptions() {
	List<OptionItem> sitesOptions = new List<OptionItem>();
	sitesOptions.add(new OptionItem(GlobalConstants.MINUSNONE,GlobalConstants.MINUSONE)); 
	try{ for(NokiaCPQ_Site__c site : [select Id, Name from NokiaCPQ_Site__c where Opportunity__c =: opportunityId]){
		 sitesOptions.add(new OptionItem(site.Name,site.Id)); 
	}   
	}
	catch(Exception e){
	  ExceptionHandler.addException(e,EditSitePopController.class.getName(),GlobalConstants.ERROR_ST);
	}
	return JSON.serialize(sitesOptions);
}

//This is a remoting action call which updates site name on line items
@RemoteAction
public static void updateAssociatSite(String associateName, String siteName) {
	
	List<Apttus_Config2__LineItem__c> updateLineItemList = new List<Apttus_Config2__LineItem__c>();
	List<LineItemSiteWrapper> siteWrapperList = (List<LineItemSiteWrapper>)JSON.deserialize(associateName, List<LineItemSiteWrapper>.class);
	
	system.debug('associateName ---- '+associateName);
	system.debug('siteName---- '+siteName);
	if(siteName == '-1'){
		for(LineItemSiteWrapper wrap : siteWrapperList){
			if(wrap.selectSite){
	updateLineItemList.add( new Apttus_Config2__LineItem__c(id = wrap.lineItem.Id, NokiaCPQ_Opportunity_Site__c =  NULL));
	system.debug('selected id : '+wrap.lineItem.Id);
			}
		}
	}
	else{
		for(LineItemSiteWrapper wrap : siteWrapperList){
			if(wrap.selectSite){
	updateLineItemList.add( new Apttus_Config2__LineItem__c(id = wrap.lineItem.Id, NokiaCPQ_Opportunity_Site__c =  siteName));
	system.debug('selected id : '+wrap.lineItem.Id);
			}
		}
	}
	
	
	//if the line item is selected than update
	if(!updateLineItemList.isEmpty()){
		update updateLineItemList;
		assignSitesToOptions(updateLineItemList);
		}
	
}

public static void assignSitesToOptions(List<Apttus_Config2__LineItem__c> assignedLineItems) {
 
 List<Id> assignedLineItemsIds = new List<Id>();
 List<Apttus_Config2__LineItem__c> updateOptionsList = new List<Apttus_Config2__LineItem__c>();
 for(Apttus_Config2__LineItem__c assignedLineItem : assignedLineItems)
  {
	
	  assignedLineItemsIds.add(assignedLineItem.Id); 
	  system.debug('assignedLineItem'+assignedLineItemsIds);
	
  }
 
 
 
 Map<String,Id> productIdToSiteMap = new Map<String,Id>();
 
 List<Apttus_Config2__LineItem__c> lineItems = [Select id,Apttus_Config2__OptionId__c,Apttus_Config2__ProductId__c,NokiaCPQ_Opportunity_Site__c,Apttus_Config2__ConfigurationId__c,Apttus_Config2__AttributeValueId__c,Apttus_Config2__PrimaryLineNumber__c, Apttus_Config2__LineNumber__c
			from Apttus_Config2__LineItem__c 
			where id in :assignedLineItemsIds AND (Apttus_Config2__LineType__c =: GlobalConstants.OPTION OR Apttus_Config2__LineType__c =: GlobalConstants.PROVICE)];
 
 
 if(!lineItems.isEmpty())
   {
	 for(Apttus_Config2__LineItem__c lineItem : lineItems)
	{
		 
		 productIdToSiteMap.put(String.valueOf(lineItem.Apttus_Config2__ProductId__c)+String.valueOf(lineItem.Apttus_Config2__LineNumber__c),lineItem.NokiaCPQ_Opportunity_Site__c);
	
	}
	 
   
   }
 
 System.debug('Product Site Map'+productIdToSiteMap);   
 
 Apttus_Config2__LineItem__c configIdLineItem = lineItems.get(0);
 
 Id configId = configIdLineItem.Apttus_Config2__ConfigurationId__c;



 List<Apttus_Config2__LineItem__c> options = [Select id,Apttus_Config2__OptionId__c,Apttus_Config2__ProductId__c,NokiaCPQ_Opportunity_Site__c,Apttus_Config2__ConfigurationId__c,Apttus_Config2__AttributeValueId__c,Apttus_Config2__ParentBundleNumber__c , Apttus_Config2__LineNumber__c  
			from Apttus_Config2__LineItem__c 
			where Apttus_Config2__ConfigurationId__c = :configId AND (Apttus_Config2__LineType__c =: GlobalConstants.OPTION OR Apttus_Config2__LineType__c =: GlobalConstants.PROVICE)];
 
 System.debug('Options List********'+options); 
	
	if(!options.isEmpty())
	 {
	  
	for(Apttus_Config2__LineItem__c option : options)
	{
	 
	 if(productIdToSiteMap.containskey(String.valueOf(option.Apttus_Config2__ProductId__c)+String.valueOf(option.Apttus_Config2__LineNumber__c))) {
	  option.NokiaCPQ_Opportunity_Site__c = productIdToSiteMap.get(String.valueOf(option.Apttus_Config2__ProductId__c)+String.valueOf(option.Apttus_Config2__LineNumber__c));
	  System.debug('Site Assigned******'+option.NokiaCPQ_Opportunity_Site__c);
	  
	  // if(option.NokiaCPQ_Opportunity_Site__c != null)
	  //  {
	  
	  updateOptionsList.add(option);
	  
	  // }  
	  
	 }
	 
	 
	}
	 
	 
	 }
	 
update updateOptionsList;  

}
  
//this is a wrapper class used for line item object array
public class LineItemSiteWrapper{
	public boolean selectSite{get;set;}
	public Apttus_Config2__LineItem__c lineItem{get;set;}
//Added below getter setter to get the corect currency format on basis of user locale for 4043 req
public String formattedNumber {get;set;}
	
	public LineItemSiteWrapper(boolean selectSite, Apttus_Config2__LineItem__c lineItem){
		this.selectSite = selectSite;
		this.lineItem = lineItem;
//Setting formattedNumber value for 4043 req
  
		string extendedprice = string.valueof(lineItem.NokiaCPQ_Extended_Partner_Price__c);
		string lastthreedigi = extendedprice.right(3);
		string quoteType = lineItem.Quote_Type__c;
		string extendedCNPprice = string.valueof(lineItem.NokiaCPQ_ExtendedPrice_CNP__c);
		string lastthreedigiCNP = extendedCNPprice.right(3);
		
		if(quoteType == 'Direct CPQ'){
	if(lastthreedigiCNP!=GlobalConstants.NOTHING && (lastthreedigiCNP.equalsIgnoreCase(GlobalConstants.DOUBLEZERO) || (lastthreedigiCNP.endsWith(GlobalConstants.SINGLEZERO) && lastthreedigiCNP.startsWith(GlobalConstants.FULLSTOP))) ){
	string  localeId ='';
	localeId = [select LocaleSidKey from User where id =: UserInfo.getUserId()].LocaleSidKey;
	List<CurrencyPointCommaFormat__mdt> ccomma = [select MasterLabel from CurrencyPointCommaFormat__mdt where MasterLabel=:localeId]; 
	if(ccomma.size()>0) {
		if(lastthreedigiCNP.equalsIgnoreCase(GlobalConstants.DOUBLEZERO)){
	this.formattedNumber= lineItem.NokiaCPQ_ExtendedPrice_CNP__c.format()+ lastthreedigiCNP.replace(GlobalConstants.FULLSTOP,GlobalConstants.COMMAS);
	  
		}
		else{
			this.formattedNumber = lineItem.NokiaCPQ_ExtendedPrice_CNP__c.format() + GlobalConstants.SINGLEZERO;
			
		}
	}
	else{
		if(lastthreedigiCNP.equalsIgnoreCase(GlobalConstants.DOUBLEZERO)){
		this.formattedNumber= lineItem.NokiaCPQ_ExtendedPrice_CNP__c.format()+ GlobalConstants.DOUBLEZERO;
		
		}
		else{
			this.formattedNumber = lineItem.NokiaCPQ_ExtendedPrice_CNP__c.format() + GlobalConstants.SINGLEZERO;
			
		}
	}
			}
			else{
	 this.formattedNumber= lineItem.NokiaCPQ_ExtendedPrice_CNP__c.format();
	 
			}
		}
		
		
		else{
		if(lastthreedigi!=GlobalConstants.NOTHING && (lastthreedigi.equalsIgnoreCase(GlobalConstants.DOUBLEZERO) || (lastthreedigi.endsWith(GlobalConstants.SINGLEZERO) && lastthreedigi.startsWith(GlobalConstants.FULLSTOP))) ){
			string  localeId ='';
			localeId = [select LocaleSidKey from User where id =: UserInfo.getUserId()].LocaleSidKey;
			List<CurrencyPointCommaFormat__mdt> ccomma = [select MasterLabel from CurrencyPointCommaFormat__mdt where MasterLabel=:localeId]; 
			if(ccomma.size()>0) {
	if(lastthreedigi.equalsIgnoreCase(GlobalConstants.DOUBLEZERO)){
			this.formattedNumber= lineItem.NokiaCPQ_Extended_Partner_Price__c.format()+ lastthreedigi.replace(GlobalConstants.FULLSTOP,GlobalConstants.COMMAS);
	 
	}
	else{
		this.formattedNumber = lineItem.NokiaCPQ_Extended_Partner_Price__c.format() + GlobalConstants.SINGLEZERO;
		
	}
			}
			else{
	if(lastthreedigi.equalsIgnoreCase(GlobalConstants.DOUBLEZERO)){
	this.formattedNumber= lineItem.NokiaCPQ_Extended_Partner_Price__c.format()+ GlobalConstants.DOUBLEZERO;
	
	}
	else{
		this.formattedNumber = lineItem.NokiaCPQ_Extended_Partner_Price__c.format() + GlobalConstants.SINGLEZERO;
		
	}
			}
		}
		else{
	this.formattedNumber= lineItem.NokiaCPQ_Extended_Partner_Price__c.format();
	
		}
		}
	}
}
//Changes End By Chhedika for 2 decimal POints 4043 req
//this is the wrapper class used for site drop down population on page
public class OptionItem {
	public String label;
	public String value;
	public OptionItem(String label, String value) {
		this.label = label;
		this.value = value;
	}
}
}