public with sharing class Reprice_Quote_TP_Controller {
  
public Apttus_Proposal__Proposal__c quote;
  public String currentquoteId {get;set;}
  public List<Apttus_Config2__ProductConfiguration__c> productConfigs = new List<Apttus_Config2__ProductConfiguration__c>();
  public List<Apttus_Config2__LineItem__c> configLineItems = new List<Apttus_Config2__LineItem__c>();
  public List<Apttus_Config2__LineItem__c> configLineItemsUpdate = new List<Apttus_Config2__LineItem__c>();
  public List<Apttus_Config2__LineItem__c> configLineItemsOptions = new List<Apttus_Config2__LineItem__c>();
  public List<Apttus_Config2__LineItem__c> configLineItemsBundles = new List<Apttus_Config2__LineItem__c>();
  public List<Apttus_Config2__LineItem__c> configLineItemsArcadiaBundles = new List<Apttus_Config2__LineItem__c>();
  public List<Apttus_Config2__LineItem__c> configLineItemsBundleAndSRSMaint = new List<Apttus_Config2__LineItem__c>();
  public List<Apttus_Config2__LineItem__c> configLineItemsBundlesAgain = new List<Apttus_Config2__LineItem__c>();
  public List<Apttus_Config2__LineItem__c> productPriceconfigLineItems = new List<Apttus_Config2__LineItem__c>();
  public List<Apttus_Config2__LineItem__c> productPriceconfigLineItemFinal = new List<Apttus_Config2__LineItem__c>();
  public List<Apttus_Config2__LineItem__c> configLineItemToDelete = new List<Apttus_Config2__LineItem__c>();
  public List<Apttus_Config2__LineItem__c> configLineItemToDelete_QWM = new List<Apttus_Config2__LineItem__c>();
  public Apttus_Config2__ProductConfiguration__c productConfig; 
  public Id configId;
  public Boolean actionPollerActive{get; set;}
  public Boolean hasPendingItems{get; set;}  
  public Boolean flagUpdatePrice; 
  public Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO ;
  public Boolean pricingNotRequired;
  public Boolean isError{get; set;}
  public Boolean isChangedLEO{get; set;}
  public Integer totalLineItems {get; set;}
  public transient Integer completedLineItems {get; set;} 
  public Boolean isFinalized {get; set;}
  public Boolean isDirect {get; set;}
  public Integer countOptions {get; set;}
  public Integer countBundles {get; set;}
  public Integer countSRSMaintenance {get; set;}
  public Integer countArcadiaItems {get; set;}
  public Integer countFlag {get; set;}
  public Boolean isMainChanged = false;
  public Integer configLineItemsCount  {get; set;}
  public List<Apttus_Config2__LineItem__c> configLineItemsSRSMaintenance = new List<Apttus_Config2__LineItem__c>();
  Set<String> srsMaintenanceSet = new Set<String>{Nokia_CPQ_Constants.NOKIA_PRODUCT_NAME_SRS,Nokia_CPQ_Constants.NOKIA_YEAR2_BEYOND,Nokia_CPQ_Constants.NOKIA_YEAR1_MAINTENANCE,Nokia_CPQ_Constants.NOKIA_PRODUCT_NAME_SSP};
  
  //constructor defined

  public Reprice_Quote_TP_Controller(){
  isChangedLEO=false;
	currentquoteId = ApexPages.currentPage().getParameters().get(Nokia_CPQ_Constants.QUOTEIDPARAMETER);
	quote = [Select id,is_Maintenance_quotechecked__c,Configure_button_field_TP__c,NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c,NokiaCPQ_Last_Reprice__c,NokiaCPQ_Needs_Reprice__c, Reprice_In_Progress__c,IsCollaborationProgress__c,NokiaCPQ_Environment_Access_URL__c,
   Quote_Type__c,Direct_Price_List_Number__c,Project_Price_List_Number__c,NokiaCPQ_Is_Maintenance_Quote__c,NokiaCPQ_Portfolio__c,
   NokiaCPQ_Prior_Leo_Value__c,NokiaCPQ_LEO_Discount__c,NokiaCPQ_No_of_Years__c,NokiaCPQ_Existing_IONMaint_Contract__c,
   NokiaCPQ_Prior_Number_of_years__c,Is_Turbo_Pricing__c from Apttus_Proposal__Proposal__c where id = :currentquoteId];
	
	//Heema: Req 6383
	if(quote.NokiaCPQ_Is_Maintenance_Quote__c){
	productConfigs = [SELECT id,Apttus_Config2__Status__c,Apttus_Config2__ContractNumbers__c,NokiaCPQ_IsMainSSPAdded__c,Name,
	Apttus_Config2__PriceListId__c,Apttus_Config2__EffectivePriceListId__c 
	FROM Apttus_Config2__ProductConfiguration__c WHERE Apttus_QPConfig__Proposald__c = :currentquoteId 
	AND Apttus_Config2__BusinessObjectType__c =: Nokia_CPQ_Constants.NOKIA_PROPOSAL 
	AND (Apttus_Config2__Status__c = 'Saved' OR Apttus_Config2__Status__c='Finalized') ORDER BY CreatedDate DESC];
	}
	else{
	productConfigs = [Select id,Apttus_Config2__Status__c,Apttus_Config2__ContractNumbers__c,NokiaCPQ_IsMainSSPAdded__c,Name,
	Apttus_Config2__PriceListId__c,Apttus_Config2__EffectivePriceListId__c 
	from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c = :currentquoteId 
	AND Apttus_Config2__BusinessObjectType__c =: Nokia_CPQ_Constants.NOKIA_PROPOSAL Order by CreatedDate DESC]; 
	}
	
	if(quote.Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ)){
	  isDirect = true;
	}
	else if(quote.Quote_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ)){
	  isDirect = false;
	}
	//heema D-13889
	if(quote.NokiaCPQ_No_of_Years__c!=quote.NokiaCPQ_Prior_Number_of_years__c){
	  isChangedLEO = true;
	}
	if(quote.is_Maintenance_quotechecked__c!=null && quote.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c!=quote.is_Maintenance_quotechecked__c){
	  isMainChanged = true;
	  system.debug('isMainChanged --==='+isMainChanged);
	 }

	//Varsha: Fixed for Defect D-7623
	if(!productConfigs.isEmpty()){
	  configId = productConfigs.get(0).Id;
	}
  }

  /*public void callConstraintRule(){
	if(isChangedLEO){
  List<Integer> primaryLines = new List<Integer>();
  Apttus_CPQApi.CPQWebService.associateConstraintRules(configId,primaryLines);
  Apttus_CPQApi.CPQWebService.applyConstraintRules(configId, false);
	}
  }*/
  //This method uses logic for reprice
  public PageReference init(){
	try{
	// Shubham ITCEPP-811 two parameters added for Quote_With_Maintenance
	  configLineItems = [Select Id,Apttus_Config2__PricingStatus__c, NokiaCPQ_Configuration_Type__c,Apttus_Config2__IsPrimaryLine__c, Apttus_Config2__ChargeType__c,Apttus_Config2__LineType__c,Apttus_Config2__IsHidden__c,Apttus_Config2__PrimaryLineNumber__c,
	  is_Custom_Product__c,  Nokia_Maint_Y1_Per__c 
	  from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = :configId];
   // Shubham ITCEPP-811 - Start-1
	  Boolean showCustomObjectError = false;
	  if(quote.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c && configLineItems != null && !configLineItems.isEmpty())
	  {
  for(Apttus_Config2__LineItem__c cli : configLineItems ){
	 if(cli.is_Custom_Product__c && cli.Nokia_Maint_Y1_Per__c == null){
	  showCustomObjectError = true;
	}	 
  }
	  } // Shubham ITCEPP-811 - End-1  
	
	  if(quote.NokiaCPQ_Needs_Reprice__c == false){
  pricingNotRequired = true;
  hasPendingItems = false;
  actionPollerActive = false;
  isError = true;
  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Nokia_CPQ_Constants.SINGLEREPRICENOTREQ));
  return null;
	  }
	  else if(quote.NokiaCPQ_Needs_Reprice__c == true && quote.IsCollaborationProgress__c == true){
  pricingNotRequired = true;
  hasPendingItems = false;
  actionPollerActive = false;
  isError = true;
  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Nokia_CPQ_Constants.SINGLEREPRICEINCOLLAB));
  return null;
	  }
	  else if(configId == null){
  quote.NokiaCPQ_Needs_Reprice__c = false;
  Database.update(quote, false);
  pricingNotRequired = true;
  hasPendingItems = false;
  actionPollerActive = false;
  isError = true;
  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Nokia_CPQ_Constants.CONFIGUREFIRST));
  return null;
	  }
	  else if(showCustomObjectError) // Shubham ITCEPP-811
	  {
  pricingNotRequired = true;
  hasPendingItems = false;
  actionPollerActive = false;
  isError = true;
  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Nokia_CPQ_Constants.REMOVECUSTOMPRODUCT));
	  }
	  else{
  //update Product Config with Contract Number for Direct
	if(isdirect)  {
  if(quote.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c!=true){
	  productConfigs.get(0).NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c= false;
	   productConfigs.get(0).Apttus_Config2__Status__c = 'Saved';
	}
	else{
	  productConfigs.get(0).NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c= true;
	   productConfigs.get(0).Apttus_Config2__Status__c = 'Saved';
	}
  if(quote.Direct_Price_List_Number__c != productConfigs.get(0).Apttus_Config2__ContractNumbers__c){
	productConfigs.get(0).Apttus_Config2__ContractNumbers__c = quote.Direct_Price_List_Number__c;
	}
	if(productConfigs.get(0)!=null)
	  Database.update(productConfigs.get(0), false);
   
  }
  if(isChangedLEO){
	if(quote.NokiaCPQ_No_of_Years__c != null && quote.NokiaCPQ_No_of_Years__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_1YEAR)){
	  productConfigs.get(0).NokiaCPQ_IsMainSSPAdded__c = true;
	  //Added by Dhharvi
	  productConfigs.get(0).Apttus_Config2__Status__c = 'Saved';
	  for(Apttus_Config2__LineItem__c productPriceconfigLI : configLineItems){
		if(productPriceconfigLI.Apttus_Config2__ChargeType__c == 'Maintenance for Y2 & Beyond'){
	configLineItemToDelete.add(productPriceconfigLI);
		}
	  }
	   delete configLineItemToDelete;
	  
	}
	else{
	  productConfigs.get(0).NokiaCPQ_IsMainSSPAdded__c = false;
	  //Added by Dhharvi
	  productConfigs.get(0).Apttus_Config2__Status__c = 'Saved';
	}
	Database.update(productConfigs.get(0), false);
  }
  if(isMainChanged && isDirect && quote.NokiaCPQ_Quote_With_Maintenance_SSP_SRS__c != true){
  system.debug('ddddddd');
   for(Apttus_Config2__LineItem__c configLI_QWM : configLineItems){
		if(srsMaintenanceSet.contains(configLI_QWM.Apttus_Config2__ChargeType__c)){
	configLineItemToDelete_QWM.add(configLI_QWM);
	system.debug('configLineItemToDelete_QWM====='+configLineItemToDelete_QWM);
		}
		
	  }   
	  delete configLineItemToDelete_QWM;
  }

  configLineItems = [SELECT Id,Apttus_Config2__ChargeType__c,Apttus_Config2__IsHidden__c,NokiaCPQ_Configuration_Type__c,
	   Name,Apttus_Config2__PricingStatus__c,Apttus_Config2__IsPrimaryLine__c, Apttus_Config2__LineType__c,
	   Apttus_Config2__ItemSequence__c,Apttus_Config2__LineNumber__c,Apttus_Config2__PrimaryLineNumber__c,
	   Apttus_Config2__ProductId__c,Apttus_Config2__PriceListId__c 
	   from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = :configId];
  configLineItemsCount = configLineItems.size();
  //Heema : 6383 Req Start
  if(quote.NokiaCPQ_Is_Maintenance_Quote__c){
	For(Apttus_Config2__LineItem__c productPriceconfigLineItem : configLineItems){
	  if(productPriceconfigLineItem.Apttus_Config2__ChargeType__c.equalsIgnoreCase('Standard Price')){
	  productPriceconfigLineItem.Apttus_Config2__IsHidden__c = false;
	  productPriceconfigLineItems.add(productPriceconfigLineItem);
	  }
	}
  
	if(!productPriceconfigLineItems.isEmpty()){
	  Database.update(productPriceconfigLineItems, false);
	}
  }
  //Heema : 6383 Req End
  if(!configLineItems.isEmpty()){ 
	quote.Reprice_In_Progress__c = true;	
	Database.update(quote, false);
	totalLineItems  = configLineItems.size();
	system.debug('configLineItems before status update>>'+configLineItems);

	for(Apttus_Config2__LineItem__c configLineItem : configLineItems){
	  if(isDirect == true){
		//top level bundles
		if(configLineItem.Apttus_Config2__LineType__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PRODUCT_SERVICES) && configLineItem.NokiaCPQ_Configuration_Type__c != null && configLineItem.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.BUNDLE) && configLineItem.Apttus_Config2__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD_PRICE)){
	configLineItem.Apttus_Config2__PricingStatus__c = Nokia_CPQ_Constants.PENDING_STRING;
	configLineItemsBundles.add(configLineItem);
		}
		//Arcadia items
		else if(configLineItem.Apttus_Config2__LineType__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_OPTION) && configLineItem.NokiaCPQ_Configuration_Type__c != null && configLineItem.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.BUNDLE)){
	configLineItem.Apttus_Config2__PricingStatus__c= Nokia_CPQ_Constants.PENDING_STRING;
	configLineItemsArcadiaBundles.add(configLineItem);
		}
		//options with standard price charge type
		else if(configLineItem.NokiaCPQ_Configuration_Type__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_STANDALONE) && configLineItem.Apttus_Config2__ChargeType__c.equalsIgnoreCase(Nokia_CPQ_Constants.STANDARD_PRICE)){
	configLineItem.Apttus_Config2__PricingStatus__c= Nokia_CPQ_Constants.PENDING_STRING;
	configLineItemsOptions.add(configLineItem);
		}
		//options with charge type other than standard price
		else if(srsMaintenanceSet.contains(configLineItem.Apttus_Config2__ChargeType__c)){
	configLineItem.Apttus_Config2__PricingStatus__c= Nokia_CPQ_Constants.PENDING_STRING;
	configLineItemsSRSMaintenance.add(configLineItem);
		}
		if(quote.NokiaCPQ_Portfolio__c == 'Nokia Software'){
	if(configLineItem.Apttus_Config2__LineType__c.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PRODUCT_SERVICES)){
	  configLineItem.Apttus_Config2__PricingStatus__c= Nokia_CPQ_Constants.PENDING_STRING;
	  configLineItemsBundlesAgain.add(configLineItem);
	}
		}
	  }
	  else if(isDirect == false){
		// For Indirect, both Bundles and Options are processed together
		configLineItem.Apttus_Config2__PricingStatus__c= 'Pending';
		configLineItemsOptions.add(configLineItem);	
	  }  
	}
	system.debug('configLineItemsBundles-->'+configLineItemsBundles);
	system.debug('configLineItemsArcadiaBundles-->'+configLineItemsArcadiaBundles);
	system.debug('configLineItemsOptions-->'+configLineItemsOptions);
	system.debug('configLineItemsSRSMaintenance-->'+configLineItemsSRSMaintenance);
	
	Database.update(configLineItemsOptions,false); 
	countOptions = configLineItemsOptions.size();
	if(isDirect == true){
	  countBundles = configLineItemsBundles.size();
	  countSRSMaintenance = configLineItemsSRSMaintenance.size();
	  countArcadiaItems = configLineItemsArcadiaBundles.size();
	}
  }
  
  /*ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Nokia_CPQ_Constants.REPRICING_WAIT_MSG));
  pricingNotRequired  = false;
  hasPendingItems = false; 
  actionPollerActive = true;
  objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
  objUpdatePriceRequestDO.CartId = configId;
  isError = false;
  
  if(!Test.isRunningTest()){
  Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
	hasPendingItems = result.IsPricePending;
	system.debug('hasPendingItems in runningtest--> '+hasPendingItems);
  }
  else{
	 hasPendingItems = true; 
  }
  
  if(hasPendingItems){
	actionPollerActive = true;
	flagUpdatePrice = true;
	system.debug('flagUpdatePrice-->'+flagUpdatePrice);
  }
   
  if(isDirect == true){
	completedLineItems = countOptions;
	countFlag=1;
  }
  else if(isDirect == false){
	completedLineItems = [Select Count() from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = :configId AND Apttus_Config2__PricingStatus__c =: Nokia_CPQ_Constants.COMPLETE_MSG]; 
  }*/
	  }
	  Apttus_Config2__ProductConfiguration__c prodConfigToUpdate = new Apttus_Config2__ProductConfiguration__c();
	  prodConfigToUpdate.Id = configId;
	  prodConfigToUpdate.Apttus_Config2__Status__c = 'Saved';
	  prodConfigToUpdate.Apttus_Config2__FinalizedDate__c = null;
	  //update prodConfigToUpdate;
	  
	  Apttus_Proposal__Proposal__c quoteToUpdate = new Apttus_Proposal__Proposal__c();
	  quoteToUpdate.Id = currentquoteId;
	  //quoteToUpdate.Apttus_QPConfig__DisableCartVersioning__c = true;
	  quoteToUpdate.NokiaCPQ_Last_Reprice__c = System.Now();
	  quoteToUpdate.NokiaCPQ_Needs_Reprice__c = false;
	  quoteToUpdate.Reprice_In_Progress__c = false;
	  
	  update quoteToUpdate;
	  
	  //String turboURL = [SELECT Apttus__Value__c FROM Apttus__APTS_Admin__c WHERE Name =: 'APTS_PricingServiceOverrideURI'].Apttus__Value__c;
	  //String sessionId = UserInfo.getOrganizationId()+''+UserInfo.getSessionId().SubString(15);
	  //Boolean initializeCallStatus = initialize(turboURL,sessionId,productConfigs.get(0));
	  
	  //Integer linecount = getCartStatus(turboURL,sessionId,productConfigs.get(0).Id);
	  //if (configLineItemsCount == linecount){
	  //  Boolean updatePricingCallStatus = updatePricingStatus(turboURL,sessionId,configLineItems,productConfigs.get(0).Id);  
	  //}
  List<Integer> primaryLines = new List<Integer>();
  Apttus_CPQApi.CPQWebService.associateConstraintRules(configId,primaryLines);
  Apttus_CPQApi.CPQWebService.applyConstraintRules(configId, false);
	}
	catch(Exception e){
	  System.debug('Excpetion'+e);
	  ExceptionHandler.addException(e,NokiaCPQ_Reprice_Quote_Ctrlr.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	}
	String flow= '';
	if(quote.Is_Turbo_Pricing__c == true && quote.NokiaCPQ_Portfolio__c== 'Fixed Network'){
	flow = isDirect? 'Turbo Flow for FN' : 'IndirectFlow';
	}else if(quote.Is_Turbo_Pricing__c == false && quote.NokiaCPQ_Portfolio__c== 'Fixed Network'){
	flow = isDirect? 'Direct FN Flow' : 'IndirectFlow';
	}
	else{
	flow = isDirect? 'DirectFlow' : 'IndirectFlow';
	} 
	String cntrNbr_1 =  isDirect? quote.Direct_Price_List_Number__c : quote.Project_Price_List_Number__c;  
	//return new PageReference('/apex/Apttus_QPConfig__ProposalConfiguration?id='+currentquoteId+'&flow='+flow);

	if(String.isBlank(cntrNbr_1)){
	  cntrNbr_1 = '';
	}
	// Added by Nandeesh
	if(isDirect == true){
	return new PageReference('/apex/Apttus_Lightning_Page_Redirect?id='+currentquoteId+'&flow='+flow+'&cntrNbr_1='+cntrNbr_1);
	}else{
	string pageUrl = '';
		if(!Test.isRunningtest()){
		pageUrl = quote.Configure_button_field_TP__c.replace(quote.NokiaCPQ_Environment_Access_URL__c,'');
		}
		return new PageReference(pageUrl);		
		//return new PageReference(quote.Configure_button_field_TP__c!= null ? quote.Configure_button_field_TP__c : '');	 
		
	}
  }
  
  //This method contains the logic to cancel button action.
  public PageReference cancel(){
	return new PageReference(Nokia_CPQ_Constants.SLASH+currentquoteId);
  }
  
  /*public Boolean updatePricingStatus(String turboURL,String sessionId,List<Apttus_Config2__LineItem__c> configLineItems,String productConfigId){
	Boolean updatePricingCallStatus = false;
	List<ConfigLineItemPutRequest> configLIUpdateReqList = new List<ConfigLineItemPutRequest>();
	
	for (Apttus_Config2__LineItem__c lineItem : configLineItems){
	  ConfigLineItemPutRequest configLIUpdateReq = new ConfigLineItemPutRequest();
	  configLIUpdateReq.Id = lineItem.Id;
	  configLIUpdateReq.Name = lineItem.Name;
	  configLIUpdateReq.PriceListId = lineItem.Apttus_Config2__PriceListId__c;
	  configLIUpdateReq.IsPrimaryLine = lineItem.Apttus_Config2__IsPrimaryLine__c;
	  configLIUpdateReq.ItemSequence = lineItem.Apttus_Config2__ItemSequence__c;
	  configLIUpdateReq.LineNumber = lineItem.Apttus_Config2__LineNumber__c;
	  configLIUpdateReq.LineType = lineItem.Apttus_Config2__LineType__c;
	  configLIUpdateReq.PrimaryLineNumber = lineItem.Apttus_Config2__PrimaryLineNumber__c;
	  configLIUpdateReq.PricingStatus = 'Pending';
	  configLIUpdateReq.ProductId = lineItem.Apttus_Config2__ProductId__c;
	  
	  configLIUpdateReqList.add(configLIUpdateReq);
	}
	String body = JSON.serialize(configLIUpdateReqList);
	Http http = new Http();
	HttpRequest request = new HttpRequest();
	request.setEndpoint (turboURL + '/pricing/carts/'+productConfigId+'/lines');
	request.setMethod('PUT');
	request.setHeader('Content-Type', 'application/json;charset=UTF-8');
	request.setHeader('Authorization', 'Bearer ' + sessionId);
	request.setBody(body);
	
	HttpResponse response = http.send (request);
	if (response.getStatusCode () == 200) {
	  updatePricingCallStatus = true;
	}
	return updatePricingCallStatus;
  }
  
  public Integer getCartStatus(String turboURL,String sessionId,String productConfigId){
	
	Integer linecount = 0;
	
	Http http = new Http();
	HttpRequest request = new HttpRequest();
	request.setEndpoint (turboURL + '/pricing/carts/'+productConfigId);
	request.setMethod('GET');
	request.setHeader('Content-Type', 'application/json;charset=UTF-8');
	request.setHeader('Authorization', 'Bearer ' + sessionId);
	
	HttpResponse response = http.send(request);
	if (response.getStatusCode () == 200) {
	  Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
	  linecount = Integer.ValueOf(responseMap.get('TotalLines'));
	}
	return linecount;
  }
  
  public Boolean initialize(String turboURL,String sessionId,Apttus_Config2__ProductConfiguration__c productConfig){
	
	Boolean initializeCallStatus = false;
	
	ProductConfiguration prodConfig = new ProductConfiguration();
	prodConfig.id = productConfig.Id;
	prodConfig.name = productConfig.Name;
	prodConfig.priceListId = productConfig.Apttus_Config2__PriceListId__c;
	prodConfig.effectivepriceListId = productConfig.Apttus_Config2__EffectivePriceListId__c;
	
	initializeRequest initializeReq = new initializeRequest();
	initializeReq.prodConfig = prodConfig;
	
	String body = JSON.serialize(initializeReq);
	
	Http http = new Http();
	HttpRequest request = new HttpRequest();
	request.setEndpoint (turboURL + '/pricing/carts');
	request.setMethod('POST');
	request.setHeader('Content-Type', 'application/json;charset=UTF-8');
	request.setHeader('Authorization', 'Bearer ' + sessionId);
	request.setBody(body);
	
	HttpResponse response = http.send (request);
	if (response.getStatusCode () == 200) {
	  initializeCallStatus = true;
	}
	return initializeCallStatus;
  }

  //This method contains logic to update the price
  public void doUpdatePrice(){
	try{
	  if(flagUpdatePrice == true){  
  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Nokia_CPQ_Constants.REPRICING_WAIT_MSG));   
  objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
  objUpdatePriceRequestDO.CartId = configId;
  if(!Test.isRunningTest()){
	Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart (objUpdatePriceRequestDO);
	hasPendingItems = result.IsPricePending; 
  
	system.debug('doUpdatePrice hasPendingItems-->'+hasPendingItems);
	List<Integer> pendingLineNumbers = result.PendingLineNumbers;  
	List<Integer> completedLineNumbers = result.CompletedLineNumbers;
  }
  else{
	 hasPendingItems = false; 
  }
  //Update arcadia items in 2nd call
  if(configLineItemsArcadiaBundles.size() > 0 && hasPendingItems == False && isDirect == true){   
	Database.update(configLineItemsArcadiaBundles,false);
	hasPendingItems = true; 
	completedLineItems = countOptions+countArcadiaItems;
	countFlag = 2;
	configLineItemsArcadiaBundles.clear();
	system.debug('in 2nd call configLineItemsArcadiaBundles' + completedLineItems);
  }
  
  //Update Main Bundle in 3rd call
  if(configLineItemsArcadiaBundles.size()==0 && configLineItemsBundles.size() > 0 && isDirect == true && hasPendingItems == False){   
	Database.update(configLineItemsBundles,false);
	hasPendingItems = true; 
	completedLineItems = countOptions+countArcadiaItems+countBundles;
	countFlag = 3;
	configLineItemsBundles.clear();
	system.debug('in 3rd call configLineItemsBundles' + completedLineItems);
  }
  
  //Update Maintenance Lines in 4th call
  if(configLineItemsArcadiaBundles.size()==0 && configLineItemsBundles.size()==0 && configLineItemsSRSMaintenance.size()>0 && isDirect == true && hasPendingItems == False){   
	Database.update(configLineItemsSRSMaintenance,false);
	hasPendingItems = true;
	completedLineItems = countOptions+countBundles+countArcadiaItems+countSRSMaintenance;
	countFlag=4;
	configLineItemsSRSMaintenance.clear();
	system.debug('in 4th call configLineItemsSRSMaintenance' + completedLineItems);
	  
  }
  
  //Update Main Bundle again in 5th call
  if(configLineItemsSRSMaintenance.size()==0 && countFlag == 4 && isDirect == true && hasPendingItems == False){
	
	countFlag=5;
	completedLineItems = countOptions+countBundles+countArcadiaItems+countSRSMaintenance;
	system.debug('in 5th call configLineItemsBundlesAgain' + completedLineItems);  
	 if(!configLineItemsBundlesAgain.isEmpty()){
	  Database.update(configLineItemsBundlesAgain,false);
	  hasPendingItems = true; 
	  configLineItemsBundlesAgain.clear();
	}
  }

  //Set completedlineItems for Direct
  if(isDirect && countFlag == 1){
	completedLineItems = countOptions;
  }
  else if(isDirect && countFlag == 2){
	completedLineItems = countOptions+countArcadiaItems;
  }
  else if(isDirect && countFlag == 3){
	completedLineItems = countOptions+countArcadiaItems+countBundles;
  }
  else if(isDirect){
	completedLineItems = countOptions+countBundles+countArcadiaItems+countSRSMaintenance;
  }

  if(hasPendingItems == false){   
	
	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Nokia_CPQ_Constants.REPRICING_COMPLETE_MSG));	  
	Apttus_CpqApi.CPQ.FinalizeCartRequestDO requestFinalizeCart = new Apttus_CpqApi.CPQ.FinalizeCartRequestDO(); 
	requestFinalizeCart.CartId = configId; 
	if(!Test.isRunningTest()){	
	  Apttus_CpqApi.CPQ.FinalizeCartResponseDO responseFinalizeCart = Apttus_CpqApi.CPQWebService.finalizeCart(requestFinalizeCart);
  
	  if(responseFinalizeCart.IsSuccess){
		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Nokia_CPQ_Constants.FINALIZE_MSG));
		isFinalized = true;
		actionPollerActive = false; 
		quote.NokiaCPQ_Last_Reprice__c = System.Now();
		quote.NokiaCPQ_Needs_Reprice__c = false;
		quote.Reprice_In_Progress__c = false;
	  
		update quote;
	  }
	}
  }
  else if(hasPendingItems == true ){ 
	actionPollerActive = true;  
  }

  if(countFlag == 5 && isDirect == true){
	completedLineItems = countOptions+countBundles+countSRSMaintenance+countArcadiaItems;
  }
  else if(isDirect == false){
	if(quote.NokiaCPQ_Is_Maintenance_Quote__c){
	  For(Apttus_Config2__LineItem__c productPriceconfigLineItem : productPriceconfigLineItems){
	  productPriceconfigLineItem.Apttus_Config2__IsHidden__c = true;
	  productPriceconfigLineItemFinal.add(productPriceconfigLineItem);
	}
  
	if(!productPriceconfigLineItemFinal.isEmpty()){
	  Database.update(productPriceconfigLineItemFinal, false);
	}
	}
	else{
	completedLineItems = [Select Count() from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = :configId AND Apttus_Config2__PricingStatus__c =: Nokia_CPQ_Constants.COMPLETE_MSG]; 
	}
  }
	  }
	}
	catch(Exception e){
	  ExceptionHandler.addException(e,NokiaCPQ_Reprice_Quote_Ctrlr.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	}
  }

  //This method contains the logic to cancel button action.
  public PageReference cancel(){
	return new PageReference(Nokia_CPQ_Constants.SLASH+currentquoteId);
  }*/
  
  public class initializeRequest{
	public ProductConfiguration prodConfig {get;set;}
  }
  
  public class ProductConfiguration{
	public String id {get;set;}
	public String name {get;set;}
	public String priceListId {get;set;}
	public String effectivepriceListId {get;set;}
  }
  
  public class ConfigLineItemPutRequest{
	public String Id {get;set;}
	public String Name {get;set;}
	public String PriceListId {get;set;}
	public String PricingStatus {get;set;}
	public String ProductId {get;set;}
	public Decimal ItemSequence {get;set;}
	public String LineType {get;set;}
	public Boolean IsPrimaryLine {get;set;}
	public Decimal PrimaryLineNumber {get;set;}
	public Decimal LineNumber {get;set;}
  }
}