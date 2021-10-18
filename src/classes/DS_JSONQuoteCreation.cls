/**updated class**/
global without sharing class DS_JSONQuoteCreation implements Queueable {
	Id QuoteRecordTypeId = Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.QuoteRecordType).getRecordTypeId();
	List<Apttus_Config2__LineItem__c> QuoteCnfigLineItemSobjList=new List<Apttus_Config2__LineItem__c>();
	List<Sobject> CFA_ListSobj=new List<Sobject>();
	DS_Staging__c ds_staging = new DS_Staging__c();
	Interface_Log__c Ilog  = new Interface_Log__c();
	map<Integer,List<Sobject>> CFA_ListSobjwithmap=new map<Integer,List<Sobject>>();
	List<Apttus_Proposal__Proposal__c> QuoteList=new  List<Apttus_Proposal__Proposal__c>();
	List<Apttus_Proposal__Proposal__c> QPlist=new List<Apttus_Proposal__Proposal__c> ();
	map<Decimal,Apttus_Config2__LineItem__c> BundleLineNumMap=new map<Decimal,Apttus_Config2__LineItem__c>();
	map<Decimal,List<Apttus_Config2__LineItem__c>> BundleOptionLineNumMap=new map<Decimal,List<Apttus_Config2__LineItem__c>>();
	map<Decimal,Apttus_Config2__LineItem__c> StandaloneNummap=new map<Decimal,Apttus_Config2__LineItem__c>();
	map<String,set<Decimal>> QuotelineNummap=new map<String,set<Decimal>>();
	Map<String,Id> productCodeToPLIId = new Map<String,Id>();
	Set<String> accNumberSet = new Set<String>();
	Set<String> ProductCodeSet = new Set<String>();
	Set<String> Agreenumberset = new Set<String>();
	Set<String> Oppnumberset = new Set<String>();
	Set<String> FinalizecartIDset= new set<String>();
	Map<String,Id> bunPcodetoId = new Map<String,Id>();
	Set<String> bundleIdSet = new Set<String>();
	Map<String,Boolean> fixBundleMap = new Map<String,Boolean>();
	Boolean thirdBR = true;
	Map<String,List<String>> fixbundleToOption = new Map<String,List<String>>();
	Map<String,Set<String>> systembundleToOption = new Map<String,Set<String>>();
	Map<id,List<Apttus_Config2__ProductOptionComponent__c>> fixbundleToOptionobj = new Map<id,List<Apttus_Config2__ProductOptionComponent__c>>();
	Map<String,String> quoteIDnStatusMap = new Map<String,String>();
	Map<String,Set<String>> jsonBundleNOptionMap = new Map<String,Set<String>>();
	//List<Apttus_Proposal__Proposal__c> quoteRecListOuter = new List<Apttus_Proposal__Proposal__c>();
	
	
	
	public DS_JSONQuoteCreation(List<Apttus_Proposal__Proposal__c> QuotelIst,List<Apttus_Config2__LineItem__c> QuoteCnfigLineItemList,List<Sobject> CFA_List,map<Integer,List<Sobject>> CFA_Listwithmap,Set<String> accNumberSet, Set<String> ProductCodeSet, Set<String> Agreenumberset,  Set<String> Oppnumberset ,DS_Staging__c ds_staging,Interface_Log__c Ilog){
		this.QuotelIst=QuoteList;
		this.QuoteCnfigLineItemSobjList=QuoteCnfigLineItemList;
		this.CFA_ListSobj=CFA_List;
		this.CFA_ListSobjwithmap=CFA_Listwithmap;
		this.accNumberSet=accNumberSet;
		this.ProductCodeSet=ProductCodeSet;
		this.Agreenumberset=Agreenumberset;
		this.Oppnumberset=Oppnumberset;
		this.ds_staging=ds_staging;
		 this.Ilog=Ilog;
	}
	public void execute(QueueableContext context) {
		QuoteDataInsertion();
	}
	
	
	Public Map<String,Set<String>> getJsonBundleOptionMap(){
	
	
		for(Apttus_Config2__LineItem__c Config: QuoteCnfigLineItemSobjList){
		
			   if (!String.isBlank(Config.Apttus_Config2__ProductId__c)){
				
					If(!jsonBundleNOptionMap.containskey(Config.Apttus_Config2__ProductId__c) ){
						if(!String.isBlank(Config.Apttus_Config2__ProductOptionId__c)){
							jsonBundleNOptionMap.put(Config.Apttus_Config2__ProductId__c, new Set<String>{Config.Apttus_Config2__ProductOptionId__c});
						}
					}
					else{
						 if(!String.isBlank(Config.Apttus_Config2__ProductOptionId__c)){
							jsonBundleNOptionMap.get(Config.Apttus_Config2__ProductId__c).add(Config.Apttus_Config2__ProductOptionId__c);  
						 }
					}
			   }
			   
			   
		   
			
			
			
			
		}
		
		return jsonBundleNOptionMap;
		
		
	}
	
	public void LineItemDataChange(){
		
		for(Apttus_Config2__LineItem__c ConfigObj:QuoteCnfigLineItemSobjList)
		{
			If(!QuotelineNummap.containskey(QPlist[0].Id) )
				QuotelineNummap.put(QPlist[0].Id, new set<Decimal>{ConfigObj.Apttus_Config2__LineNumber__c});
			else
				QuotelineNummap.get(QPlist[0].Id).add(ConfigObj.Apttus_Config2__LineNumber__c); 
			
			if(!string.isblank(ConfigObj.Apttus_Config2__ProductId__c)&&string.isblank(ConfigObj.Apttus_Config2__ProductOptionId__c))
				BundleLineNumMap.put(ConfigObj.Apttus_Config2__LineNumber__c,ConfigObj);
			else if(string.isblank(ConfigObj.Apttus_Config2__ProductId__c))
				StandaloneNummap.put(ConfigObj.Apttus_Config2__LineNumber__c,ConfigObj);
		}
		
		for(Apttus_Config2__LineItem__c Config:QuoteCnfigLineItemSobjList)
		{
			if(BundleLineNumMap.containskey(Config.Apttus_Config2__LineNumber__c))
			{   
				bundleIdSet.add(Config.Apttus_Config2__ProductId__c);
				if(!string.isblank(Config.Apttus_Config2__ProductOptionId__c)){
				If(!BundleOptionLineNumMap.containskey(Config.Apttus_Config2__LineNumber__c) )
					BundleOptionLineNumMap.put(Config.Apttus_Config2__LineNumber__c, new List<Apttus_Config2__LineItem__c>{Config});
				else
					BundleOptionLineNumMap.get(Config.Apttus_Config2__LineNumber__c).add(Config);  
			}
			}
		}
		
		
	}
	public void QuoteDataInsertion(){
		try{
			list<Apttus_Config2__ProductConfiguration__c> ConfigList = new list<Apttus_Config2__ProductConfiguration__c>(); 
			Map<String,String> productCodeToIdmap= new Map<String,String>();
			Map<String,String> QuotetoCartIDmap= new Map<String,String>();
			Map<String,Account> parentaccmap=new map<String,Account> ();
			Map<string,Opportunity> OppNumwithOppmap=new Map<string,Opportunity>();
			Set<Id> priceListIdSet = new Set<Id>();
			Set<Id> ParentIdset = new Set<Id>(); 
			Map<String,String> productCodeToPLIId = new Map<String,String>();
			map<String,string> Agrnumpricelistmap=new map<string,string>();
			map<String,Apttus__APTS_Agreement__c> AgrnumAgrrementmap=new map<string,Apttus__APTS_Agreement__c>();
			map<String,string> ProductidandproductOptionidMap=new map<string,string>();
			
			
			for(Account Acco:[Select Id,name,Parentid,Parent.ownerid,AccountNumber from Account where AccountNumber IN:accNumberSet LIMIT : Limits.getLimitQueryRows()- Limits.getQueryRows()])
			{
				parentaccmap.put(Acco.AccountNumber,Acco);
				ParentIdset.add(Acco.parentId);
			}
			
			Map<Id,Account> accIdWithPriceListmap = new Map<Id,Account>([Select Id,name,(SELECT Id,CurrencyIsoCode,Apttus_Config2__AccountId__c,Type__c,PriceList_Type__c FROM Apttus_Config2__PriceLists__r where PriceList_Type__c=:CSWXGlobalConstant.DSPriceListType) from account where Id in:ParentIdset LIMIT : Limits.getLimitQueryRows()- Limits.getQueryRows()]);		 
			System.debug('ProductCodeSet --->'+ProductCodeSet);
			
			Map<String,Set<String>>  bNoMap =  getJsonBundleOptionMap();
			
			Set<String> optionSet = new Set<String>();
			
			Set<String> jsonVBundle = new Set<String>();
			for(Product2 prod : [select ProductCode,Apttus_Config2__ConfigurationType__c,Apttus_Config2__Customizable__c from Product2 where ProductCode in: ProductCodeSet]){
				
				if(prod.Apttus_Config2__ConfigurationType__c == 'Bundle' && prod.Apttus_Config2__Customizable__c == true){
					jsonVBundle.add(prod.ProductCode);
					
					
					
				}
				
				
				
			}
			
			System.debug('jsonVBundle--->'+jsonVBundle);
			
			
			for(Apttus_Config2__ProductOptionComponent__c ui: [select id,BundledProduct_Code__c,ProductCode__c,Apttus_Config2__ParentProductId__c,Apttus_Config2__DefaultQuantity__c,Apttus_Config2__ComponentProductId__c from Apttus_Config2__ProductOptionComponent__c where  BundledProduct_Code__c in :ProductCodeSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				if(systembundleToOption.containsKey(ui.BundledProduct_Code__c)){
							systembundleToOption.get(ui.BundledProduct_Code__c).add(ui.ProductCode__c);
						   // optionCodeSet.add(ui.ProductCode__c);// option pro of fixed bundle
						}
						else{
							optionSet = new Set<String>();
							optionSet.add(ui.ProductCode__c);
						   // optionCodeSet.add(ui.ProductCode__c);// option pro of fixed bundle
							systembundleToOption.put(ui.BundledProduct_Code__c, optionSet);  
						}
			
			
			
			}
				
			
			/*-------------- Logic for Third BR --------------------*/
			 
			 System.debug('bNoMap--->'+bNoMap);
			
			 
			 
			 
			 Set<String> jsonVBunWOpt =bNoMap.keySet();
			 
			 System.debug('jsonVBunWOpt--->'+jsonVBunWOpt);
			 
			 System.debug('jsonVBundle--->'+jsonVBundle);
			 
			 for(String jsonBund: jsonVBundle){
				if(!jsonVBunWOpt.contains(jsonBund))
					 thirdBR =false;
				}
			 
			 
			 System.debug('thirdBR-->'+thirdBR);
			 
			
			
			for(String jsonBundle : bNoMap.keySet()){
			  System.debug('systembundleToOption--->'+systembundleToOption);
			 Set<String> systOptions=  systembundleToOption.get(jsonBundle);
			 System.debug('systOptions--->'+systOptions);
			 
				if(bNoMap.containskey(jsonBundle) && thirdBR){
					 Set<String> jsonOptions=  bNoMap.get(jsonBundle);
					 System.debug('jsonOptions--->'+jsonOptions);
			 
					if(!systOptions.containsAll(jsonOptions)){
				
						thirdBR =false;
						break;
					}
			
				}else if(!systembundleToOption.containsKey(jsonBundle) && thirdBR)
				{
					 thirdBR =false;
						break;
				}
			
			}
			
			System.debug('thirdBR --->'+thirdBR);
			
			
			for(Opportunity Opp:[Select Id,name,Opportunity_ID__c,Reference_Opportunity__c from Opportunity where Opportunity_ID__c IN:Oppnumberset LIMIT : Limits.getLimitQueryRows()- Limits.getQueryRows()])
				OppNumwithOppmap.put(Opp.Opportunity_ID__c,Opp);
			
			if(!ProductCodeSet.isEmpty()) {
				for(Product2 productObj : [select id,ProductCode from Product2 where ProductCode in :ProductCodeSet Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()] ){
					productCodeToIdmap.put(productObj.ProductCode,productObj.Id);
					if(!productCodeToIdmap.isempty()){
						for(Apttus_Config2__ProductOptionComponent__c optionComp:[Select id,Apttus_Config2__ComponentProductId__c from Apttus_Config2__ProductOptionComponent__c where Apttus_Config2__ComponentProductId__c  in : productCodeToIdmap.values() Limit : Limits.getLimitQueryRows()- Limits.getQueryRows()])
							ProductidandproductOptionidMap.put(optionComp.Apttus_Config2__ComponentProductId__c, optionComp.id);
					}
				}
				
				for(Apttus__APTS_Agreement__c Agreement:[Select Id,Apttus_CMConfig__PaymentTermId__c,Apttus__Contract_Start_Date__c,Apttus__Contract_End_Date__c,Apttus__FF_Agreement_Number__c,Apttus__Related_Opportunity__r.Name,Apttus__Related_Opportunity__c,Apttus_CMConfig__PriceListId__c,Apttus_CMConfig__PriceListId__r.currencyisocode from Apttus__APTS_Agreement__c where Apttus__FF_Agreement_Number__c IN :Agreenumberset])
				{
					AgrnumAgrrementmap.put(Agreement.Apttus__FF_Agreement_Number__c,Agreement);
					Agrnumpricelistmap.put(Agreement.Apttus__FF_Agreement_Number__c,Agreement.Apttus_CMConfig__PriceListId__c);
				}
				
				
				
				for(Apttus_Config2__PriceListItem__c PLItem:[Select Id,Apttus_Config2__PriceListId__c,Apttus_Config2__ProductId__c,Apttus_Config2__ProductId__r.ProductCode from Apttus_Config2__PriceListItem__c where Apttus_Config2__PriceListId__c IN :Agrnumpricelistmap.values() ])
				{
					if(ProductCodeSet.contains(PLItem.Apttus_Config2__ProductId__r.ProductCode))
						ProductCodeSet.remove(PLItem.Apttus_Config2__ProductId__r.ProductCode);
						  productCodeToPLIId.put(PLItem.Apttus_Config2__ProductId__r.Id,PLItem.id);
				}
				System.debug('QuoteList--->'+QuoteList);
				for(Apttus_Proposal__Proposal__c Quote: QuoteList){
					Quote.RecordTypeId= QuoteRecordTypeId;
					  if(OppNumwithOppmap.Containskey(Quote.Apttus_Proposal__Opportunity__c) ||AgrnumAgrrementmap.containskey(Quote.Agreement_Lookup__c))
					{
						Quote.DS_Staging__c= DS_Staging.id;
						Quote.Contract_Type_Name__c= 'Project';
						Quote.Apttus_Proposal__Approval_Stage__c = ProductCodeSet.isempty() && thirdBR?CSWXGlobalConstant.Approved:CSWXGlobalConstant.draft;
						if(CSWXGlobalConstant.Approved.contains(Quote.Apttus_Proposal__Approval_Stage__c)) Quote.LOA_Status__c=CSWXGlobalConstant.Approved;
						 if(!String.isblank(Quote.Analytics_Source__c)){
						 Quote.Analytics_Source__c=Quote.Analytics_Source__c.substringBefore('-').Trim();
						 if(!String.isblank(Quote.Analytics_Source__c))
						Quote.Analytics_Source__c=Quote.Analytics_Source__c.deleteWhitespace();
					   }  
						Quote.Apttus_Proposal__Proposal_Name__c=OppNumwithOppmap.containskey(Quote.Apttus_Proposal__Opportunity__c)?OppNumwithOppmap.Get(Quote.Apttus_Proposal__Opportunity__c).Name:AgrnumAgrrementmap.containskey(Quote.Agreement_Lookup__c)?AgrnumAgrrementmap.get(Quote.Agreement_Lookup__c).Apttus__Related_Opportunity__r.Name:Null;
					  
						Quote.Apttus_Proposal__Opportunity__c= OppNumwithOppmap.containskey(Quote.Apttus_Proposal__Opportunity__c)?OppNumwithOppmap.Get(Quote.Apttus_Proposal__Opportunity__c).Id:AgrnumAgrrementmap.containskey(Quote.Agreement_Lookup__c)?AgrnumAgrrementmap.get(Quote.Agreement_Lookup__c).Apttus__Related_Opportunity__c:Null; 
					}
					Quote.Apttus_Proposal__Account__c =parentaccmap.get( Quote.Sold_To_Party__c).Parentid;
					Quote.DS_Account_Owner__c =parentaccmap.get( Quote.Sold_To_Party__c).Parent.ownerid;
					Quote.Sold_To_Party__c = parentaccmap.get( Quote.Sold_To_Party__c).Id;
					Quote.Apttus_Proposal__Valid_Until_Date__c = System.today().AddDays(28);
		  Quote.Contract_Start_Date__c = AgrnumAgrrementmap.get( Quote.Agreement_Lookup__c).Apttus__Contract_Start_Date__c;
					Quote.Contract_End_Date__c = AgrnumAgrrementmap.get( Quote.Agreement_Lookup__c).Apttus__Contract_End_Date__c;
					 Quote.Apttus_QPConfig__PaymentTermId__c = AgrnumAgrrementmap.get( Quote.Agreement_Lookup__c).Apttus_CMConfig__PaymentTermId__c;//HCL
					if(AgrnumAgrrementmap.containskey(Quote.Agreement_Lookup__c)&&AgrnumAgrrementmap.get(Quote.Agreement_Lookup__c).Apttus_CMConfig__PriceListId__c<>null){
						Quote.Apttus_QPConfig__PriceListId__c = AgrnumAgrrementmap.get(Quote.Agreement_Lookup__c).Apttus_CMConfig__PriceListId__c;
						Quote.CurrencyIsoCode =AgrnumAgrrementmap.get(Quote.Agreement_Lookup__c).Apttus_CMConfig__PriceListId__r.currencyisocode;
						priceListIdSet.add(AgrnumAgrrementmap.get(Quote.Agreement_Lookup__c).Apttus_CMConfig__PriceListId__c);
					}
		  Quote.Agreement_Lookup__c = AgrnumAgrrementmap.get( Quote.Agreement_Lookup__c).id;

					QPlist.add(Quote);
				}
				
				if(!QPlist.isempty()){
					Database.saveresult[] Quoteresult=Database.insert(QPlist);
					List<Apttus_Proposal__Proposal__c> quoteRecList = new List<Apttus_Proposal__Proposal__c>();
					If(Quoteresult[0].issuccess()){
						ds_staging.DP_Status__c=Globalconstants.Success;
						Database.update(ds_staging);
						System.debug('QPList--->'+QPList);
						DS_Populate_CFAttributes.createCFAforQuote(CFA_ListSobj,QPList);
						LineItemDataChange();
						
						for(Apttus_Proposal__Proposal__c quoteRec : [Select NokiaCPQ_Proposal_Id__c,Apttus_Proposal__Proposal_Name__c,Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c   where id in: QPlist]){
						  System.debug('num--->'+quoteRec.Apttus_Proposal__Proposal_Name__c);
						   
							String quoteName =  quoteRec.NokiaCPQ_Proposal_Id__c;
							quoteRec.Apttus_Proposal__Proposal_Name__c= quoteRec.Apttus_Proposal__Proposal_Name__c+' '+CSWXGlobalConstant.dash+' '+quoteName;
							quoteRecList.add(quoteRec); 
							quoteIDnStatusMap.put(quoteRec.id,quoteRec.Apttus_Proposal__Approval_Stage__c);
						
							
						}
						List<id> List_ids = new List<id>();
						for(Apttus_Proposal__Proposal__c app : quoteRecList){
							
							List_ids.add(app.Id);
						}
						
					   // quoteRecListOuter.addAll(quoteRecList);
			updateRecordsTest(List_ids);						
						
						System.debug('bundleIdSet --->'+bundleIdSet);
					   for(Product2 productObj : [SELECT Id,Apttus_Config2__Customizable__c,ProductCode FROM Product2 WHERE ProductCode IN :bundleIdSet LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
						if(productObj.Apttus_Config2__Customizable__c== false){
							fixBundleMap.put(productObj.ProductCode, productObj.Apttus_Config2__Customizable__c); 
							bunPcodetoId.put(productObj.ProductCode,productObj.id);			  
						  }
			
						}  
						
						
				 List<String> tempSet = new List<String>();
				 List<Apttus_Config2__ProductOptionComponent__c> optIdRec = new List<Apttus_Config2__ProductOptionComponent__c>();
			if(!fixBundleMap.isEmpty()){
				for(Apttus_Config2__ProductOptionComponent__c ui: [select id,BundledProduct_Code__c,ProductCode__c,Apttus_Config2__ParentProductId__c,Apttus_Config2__DefaultQuantity__c,Apttus_Config2__ComponentProductId__c from Apttus_Config2__ProductOptionComponent__c where BundledProduct_Code__c in:fixBundleMap.keyset() LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				
				   //optPcodetoId.put();
					system.debug('ui.BundledProduct_Code__c>>'+ui.BundledProduct_Code__c);
					if(ui.BundledProduct_Code__c!=null){
						if(fixbundleToOption.containsKey(ui.BundledProduct_Code__c)){
							fixbundleToOption.get(ui.BundledProduct_Code__c).add(ui.ProductCode__c);
						   
						}
						else{
							tempSet = new List<String>();
							tempSet.add(ui.ProductCode__c);
						   
							fixbundleToOption.put(ui.BundledProduct_Code__c, tempSet);   
						}
						
						if(fixbundleToOptionobj.containsKey(ui.Apttus_Config2__ParentProductId__c)){
							fixbundleToOptionobj.get(ui.Apttus_Config2__ParentProductId__c).add(ui);
						   
						}
						else{
							optIdRec = new List<Apttus_Config2__ProductOptionComponent__c>();
							optIdRec.add(ui);
							fixbundleToOptionobj.put(ui.Apttus_Config2__ParentProductId__c, optIdRec);   
						}
						
					}   
				}
			}
					   
						
						
						
						
						
						if(!priceListIdSet.isEmpty()) {		   
							for(Apttus_Config2__PriceListItem__c pliRec :[SELECT Id,Apttus_Config2__ProductId__r.Id,Apttus_Config2__ProductId__r.ProductCode, Name FROM Apttus_Config2__PriceListItem__c WHERE Apttus_Config2__PriceListItem__c.Apttus_Config2__PriceListId__c IN :priceListIdSet])
								productCodeToPLIId.put(pliRec.Apttus_Config2__ProductId__r.Id,pliRec.id);
						}
						
						QuotetoCartIDmap=QuoteConfigurationInsertion(QPlist);
						if(!QuotetoCartIDmap.isempty())
						{
							if(!BundleLineNumMap.isempty() ||!StandaloneNummap.isempty())
								Bundle_Standalone_ConfigurationLineItemInsertion(QuotetoCartIDmap,productCodeToPLIId,productCodeToIdmap,ProductidandproductOptionidMap);
							System.debug('Populate CFA...');
							 DS_Populate_CFAttributes.createCFAforConfigItem(CFA_ListSobjwithmap,QPList);   
							if(!FinalizecartIDset.isempty())
								CartFinalisation(FinalizecartIDset);
							
							   
						}
					}
					else
					{
						ds_staging.DP_Status__c=Globalconstants.failure;
					Database.update(ds_staging);
					}
					}
				else
					  {
						ds_staging.DP_Status__c=Globalconstants.failure;
					Database.update(ds_staging);
					}

			}
		}
		catch(Exception ex){
			ds_staging.DP_Status__c=Globalconstants.failure;
					Database.update(ds_staging);
			Ilog.Comment__c=ex.getMessage();
			 database.update(Ilog);
			system.debug('Exception>>>>'+ex.getMessage());
			//ExceptionHandler.addException(ex, CSWXGlobalConstant.CSWX_OpportunityTriggerHelper, CSWXGlobalConstant.CREATEPROPOSAL);
		}   
	}
	
	@future
	public static void updateRecordsTest(List<id> l)
	   
	{   
		list <Apttus_Proposal__Proposal__c> quoteTest = new list <Apttus_Proposal__Proposal__c>();
		   quoteTest = [Select NokiaCPQ_Proposal_Id__c,Apttus_Proposal__Proposal_Name__c,Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c WHERE id IN:l];
		
		 // Get those records based on the IDs
						update quoteTest;
		 // Process records
	}
	public Map<String,String>  QuoteConfigurationInsertion(list<Apttus_Proposal__Proposal__c> quoteProposalList){
		list<Apttus_Config2__ProductConfiguration__c> ConfigList = new list<Apttus_Config2__ProductConfiguration__c>(); 
		Map<String,String> QuotetoCartIDmap= new Map<String,String>();
		set<String> finalizeset=new set<string>();
		for(Apttus_Proposal__Proposal__c proposal : quoteProposalList){
			Apttus_Config2__ProductConfiguration__c cart = new Apttus_Config2__ProductConfiguration__c();
			cart.Apttus_Config2__BusinessObjectRefId__c = proposal.Id;
			cart.Apttus_QPConfig__Proposald__c = proposal.Id;
			cart.Apttus_Config2__PriceListId__c = proposal.Apttus_QPConfig__PriceListId__c;
			cart.Apttus_Config2__AccountId__c = proposal.Apttus_Proposal__Account__c;
			cart.OwnerID = userinfo.getuserid(); 
			cart.Apttus_Config2__EffectivePriceListId__c = proposal.Apttus_QPConfig__PriceListId__c;
			cart.Apttus_Config2__VersionNumber__c = 1;
			cart.Apttus_Config2__Status__c = CSWXGlobalConstant.cartStatus;
			cart.name = proposal.Apttus_Proposal__Proposal_Name__c ;
			cart.createdById = userinfo.getuserid();
			cart.Apttus_Config2__BusinessObjectType__c =CSWXGlobalConstant.BusinessObjectType;
			if(proposal.Apttus_Proposal__Approval_Stage__c == CSWXGlobalConstant.Approved){
			ConfigList.add(cart);
			}
			if(GlobalConstants.Approved.contains(proposal.Apttus_Proposal__Approval_Stage__c))
				finalizeset.add(proposal.id);
		}
		if(!ConfigList.isempty()){
			Database.saveresult[] Configresult=Database.insert(ConfigList);
			for(Apttus_Config2__ProductConfiguration__c Cart:ConfigList){
				QuotetoCartIDmap.put(Cart.Apttus_QPConfig__Proposald__c,Cart.Id);
				if(finalizeset.contains(Cart.Apttus_QPConfig__Proposald__c)) 
					FinalizecartIDset.add(Cart.Id);
			}
		}
		return QuotetoCartIDmap;
	}
	public Void Bundle_Standalone_ConfigurationLineItemInsertion(Map<String,String> QuotetoCartIDmap,map<String,string>productCodeToPLIId,map<String,string>productCodeToIdmap, map<String,string> ProductidandproductOptionidMap)
	{
		try{ 
			List<Apttus_CPQApi.CPQ.AddBundleRequestDO> Bundlelist = new List<Apttus_CPQApi.CPQ.AddBundleRequestDO>();
			map<String,List <Apttus_CPQApi.CPQ.SelectedProductDO>> StandAloneproductQuotemap=new   map<String,List <Apttus_CPQApi.CPQ.SelectedProductDO>> ();
			List<String> customFields = new List<String>();
			customFields.add(CSWXGlobalConstant.priceListItem);
			customFields.add('Apttus_Config2__LineNumber__c');
			List<String> customFieldsStandalone = new List<String>();
			customFieldsStandalone.add(CSWXGlobalConstant.priceListItem);
			customFieldsStandalone.add(CSWXGlobalConstant.quantityField);
			customFieldsStandalone.add('Apttus_Config2__LineNumber__c');
			set<id> setids = new set<id>();
			for(String Quoteid:QuotelineNummap.keyset())
			{
			System.debug('quote stage--->'+quoteIDnStatusMap.get(Quoteid));
			System.debug('thirdBR --->'+thirdBR);
			System.debug('Quoteid --->'+Quoteid);
			System.debug('ProductCodeSet--->'+ProductCodeSet);
			  IF(quoteIDnStatusMap.get(Quoteid)=='Approved' && thirdBR && ProductCodeSet.isempty()) {
				if(QuotelineNummap.containsKey(Quoteid)){
					List <Apttus_CPQApi.CPQ.SelectedProductDO> StandaloneProductList = new List <Apttus_CPQApi.CPQ.SelectedProductDO>();
					system.debug('QuotelineNummap.get(Quoteid)====>>'+QuotelineNummap.get(Quoteid));
					system.debug('QuotelineNummap.getMAP==>>'+QuotelineNummap);
					set<Decimal> linenumbers=QuotelineNummap.get(Quoteid);
					system.debug('linenumbers ==== >R>'+linenumbers);
					system.debug('QuotelineNummap.get(Quoteid) ==== >R222>'+QuotelineNummap.get(Quoteid));
					for(Decimal Num:linenumbers)
					{
						system.debug('Num ===== >'+Num);
						if(BundleLineNumMap.Containskey(Num))
						{
							Apttus_Config2__LineItem__c ConfigBundle=BundleLineNumMap.get(Num);
							Apttus_CPQApi.CPQ.AddBundleRequestDO Bundle = new Apttus_CPQApi.CPQ.AddBundleRequestDO();
							List<Apttus_CPQApi.CPQ.SelectedOptionDO> BundleoptionsList = new List<Apttus_CPQApi.CPQ.SelectedOptionDO>();
							String CartID=QuotetoCartIDmap.get(Quoteid);
							String BundleProductID=productCodeToIdmap.get(ConfigBundle.Apttus_Config2__ProductId__c);
							Decimal BundleQuantity=ConfigBundle.Apttus_Config2__Quantity__c;
							Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c();
							customData.Apttus_Config2__PriceListItemId__c = productCodeToPLIId.get(BundleProductID);
							customData.Apttus_Config2__LineNumber__c = Num;
							customData.DS_Grouping_Name__c ='Other';
							
							
							  /*-------------- logic for fixed bundle --------------------*/
							
							System.debug('fixBundleMap--->'+fixBundleMap);
							System.debug('BundleLineNumMap.get(Num).Apttus_Config2__ProductId__c--->'+BundleLineNumMap.get(Num).Apttus_Config2__ProductId__c);
							if(fixBundleMap.containsKey(BundleLineNumMap.get(Num).Apttus_Config2__ProductId__c)){
								
								System.debug('inside opton product section');
								System.debug('fixed bundle option--->'+fixBundleMap.get(BundleLineNumMap.get(Num).Apttus_Config2__ProductId__c));
								
								System.debug('all options--->'+ProductidandproductOptionidMap);
								System.debug('fixbundleToOption--->'+fixbundleToOption);
								
								System.debug('fixbundleToOptionobj size---->'+fixbundleToOptionobj.keySet().size());
								System.debug('fixbundleToOptionobj---->'+fixbundleToOptionobj.keySet());
								//Fix made for SF case 00211746 by HCL
								Product2 prd = [Select Id from Product2 Where ProductCode =: BundleLineNumMap.get(Num).Apttus_Config2__ProductId__c LIMIT : 1];
								if(!fixbundleToOptionobj.isEmpty() && fixbundleToOptionobj.get(prd.Id) != Null){	
									for(Apttus_Config2__ProductOptionComponent__c optcomp :fixbundleToOptionobj.get(prd.Id)){
									// if(!setids.contains(optcomp.Apttus_Config2__ComponentProductId__c))
										 Apttus_CPQApi.CPQ.SelectedOptionDO NewOption = new Apttus_CPQApi.CPQ.SelectedOptionDO();
										 System.debug('component--->'+optcomp.Apttus_Config2__ComponentProductId__c);
										 NewOption.ComponentProductId = optcomp.Apttus_Config2__ComponentProductId__c;
										 System.debug('optcomp.id--->'+optcomp.id);
										 NewOption.ComponentId = optcomp.id;
										 NewOption.Quantity =optcomp.Apttus_Config2__DefaultQuantity__c;
										 BundleoptionsList.Add(NewOption);
										//setids.add(optcomp.Apttus_Config2__ComponentProductId__c); 
										system.debug('BundleoptionsList=FIX= =11==>R>>'+BundleoptionsList);
									}
								}
							}
							
							/*-------------- logic for variable bundle --------------------*/
							
							if(!fixBundleMap.containsKey(BundleLineNumMap.get(Num).Apttus_Config2__ProductId__c)){
								if(BundleOptionLineNumMap.containskey(Num)){
									List<Apttus_Config2__LineItem__c> ConfigOptionList=BundleOptionLineNumMap.get(Num);
								for(Apttus_Config2__LineItem__c Config:ConfigOptionList)
								{
									Apttus_CPQApi.CPQ.SelectedOptionDO NewOption = new Apttus_CPQApi.CPQ.SelectedOptionDO();
								 string OptionProductId=productCodeToIdmap.containskey(Config.Apttus_Config2__ProductOptionId__c)?productCodeToIdmap.get(Config.Apttus_Config2__ProductOptionId__c):Null;
									NewOption.ComponentProductId =OptionProductId ;
									if(!string.isempty(OptionProductId))NewOption.ComponentId =ProductidandproductOptionidMap.containskey(OptionProductId)?ProductidandproductOptionidMap.get(OptionProductId):Null;
									NewOption.Quantity = (Config.Apttus_Config2__Quantity__c<>null&&Config.Apttus_Config2__Quantity__c<>0)?Config.Apttus_Config2__Quantity__c:CSWXGlobalConstant.ccredefaultQuantity;
									BundleoptionsList.Add(NewOption);
									system.debug('BundleoptionsList==VARI==222= >R>>'+BundleoptionsList);
								}
								}
							}
							Bundle.CartID = CartID;
							Bundle.SelectedBundle = new Apttus_CPQApi.CPQ.SelectedBundleDO();
							Bundle.SelectedBundle.SelectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
							Bundle.SelectedBundle.SelectedProduct.ProductId = BundleProductID;
							Bundle.SelectedBundle.SelectedProduct.Quantity =BundleQuantity; 
							Bundle.SelectedBundle.SelectedProduct.CustomFields = customFields;
							Bundle.SelectedBundle.SelectedProduct.CustomData = customData;
							if(!BundleoptionsList.isempty())Bundle.SelectedBundle.SelectedOptions = BundleoptionsList ;
							Bundlelist.add(Bundle);
							system.debug('Bundlelist >==33==R>>'+Bundlelist);
						}
						
						if(StandaloneNummap.Containskey(Num))
						{
							
							Apttus_Config2__LineItem__c Config=StandaloneNummap.get(Num);
							Apttus_CPQApi.CPQ.SelectedProductDO StandaloneProduct  = new Apttus_CPQApi.CPQ.SelectedProductDO();
							string ProDuctID=productCodeToIdmap.get(Config.Apttus_Config2__ProductOptionId__c);
							Apttus_Config2__LineItem__c customData = new Apttus_Config2__LineItem__c();
							customData.Apttus_Config2__PriceListItemId__c = productCodeToPLIId.get(ProDuctID);
							customData.Apttus_Config2__LineNumber__c = Num;
							customData.Apttus_Config2__Quantity__c =(Config.Apttus_Config2__Quantity__c<>null)?Config.Apttus_Config2__Quantity__c:CSWXGlobalConstant.ccredefaultQuantity;
							StandaloneProduct.CustomData = customData;
							StandaloneProduct.ProductId = ProDuctID;
							StandaloneProduct.CustomFields = customFieldsStandalone;
							StandaloneProductList.add(StandaloneProduct);
							system.debug('StandaloneProductList==444== >R>>'+StandaloneProductList);
							
						}
						
					}
					if(!StandaloneProductList.isempty())
						StandAloneproductQuotemap.put(Quoteid,StandaloneProductList); 
				}
			}
			}
			
			if(!StandAloneproductQuotemap.isempty())
			{
				for(String QuoteID:StandAloneproductQuotemap.keyset())
				{
					Apttus_CPQApi.CPQ.AddMultiProductRequestDO StandAloneProDs = new Apttus_CPQApi.CPQ.AddMultiProductRequestDO();
					StandAloneProDs.cartID =QuotetoCartIDmap.get(QuoteID);
					StandAloneProDs.SelectedProducts = StandAloneproductQuotemap.get(QuoteID);
					Apttus_CPQApi.CPQ.AddMultiProductResponseDO StandAloneProDsResponse = Apttus_CPQApi.CPQWebService.addMultiProducts(StandAloneProDs);
				}
			}
			if(!Bundlelist.isempty())
			{
				for(Apttus_CPQApi.CPQ.AddBundleRequestDO Bundle:Bundlelist){
					Apttus_CPQApi.CPQ.AddBundleResponseDO BundleOptionInsertResponse = Apttus_CPQApi.CPQWebService.addBundle(Bundle);
				}
			}
			
		}
		Catch(Exception Ex)
	   {
			system.debug('Exceptiond>>>>'+ex.getMessage());
			
		}
	}
	
	
	public Void CartFinalisation(set<string> CartIdList){
		
		for(String CartID:CartIdList){
			boolean  IsPricePending;
			// create the update price request
			do{
		Apttus_CpqApi.CPQ.UpdatePriceRequestDO objUpdatePriceRequestDO = new Apttus_CpqApi.CPQ.UpdatePriceRequestDO();
		
		// add request parameters
		objUpdatePriceRequestDO.CartId = CartID;
		// update price for the cart
		Apttus_CpqApi.CPQ.UpdatePriceResponseDO result = Apttus_CpqApi.CPQWebService.updatePriceForCart(objUpdatePriceRequestDO);
		
		  IsPricePending = result.IsPricePending;
		 system.debug('IsPricePending :'+ IsPricePending);
		 }while(IsPricePending);
	 
		 if( IsPricePending== false){
						
						
		  // System.debug('Is Pending--->'+);
		   Apttus_CpqApi.CPQ.FinalizeCartRequestDO Cartfinalrequest = new Apttus_CpqApi.CPQ.FinalizeCartRequestDO();
		   Cartfinalrequest.CartId = CartID; 
		   Apttus_CpqApi.CPQ.FinalizeCartResponseDO response = Apttus_CpqApi.CPQWebService.finalizeCart(Cartfinalrequest); 
		   }
		}
		
	}
	
	   
	
	
	
}