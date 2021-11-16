public with sharing class FlexibleGroupController {
   
	
	
	//================================================================================
	//
	//
	@AuraEnabled
	public static DataTableResponse getlineitems(Id configId,String groupName){
		
		DataTableResponse response = new DataTableResponse();
		try{
			Schema.FieldSet fieldSetObj = Schema.getGlobalDescribe().get('Apttus_Config2__LineItem__c').getDescribe().FieldSets.getMap().get('MarketModel_Listview');
			//To hold the table hearders 
			List<DataTableColumns> lstDataColumns = new List<DataTableColumns>();
			Apttus_Config2__ProductConfiguration__c configObj = [select CurrencyIsoCode, CPQ_IsCQ__c from Apttus_Config2__ProductConfiguration__c where id = :configId];
			String Currencycode = configObj.CurrencyIsoCode;
			Boolean isCQQuote = configObj.CPQ_IsCQ__c;
			//Field to be queried - fetched from fieldset
			List<String> lstFieldsToQuery = new List<String>();
			map<string, string> typeattributes = new map<string, string>();
			//The final wrapper response to return to component
			
			
			for( Schema.FieldSetMember eachFieldSetMember : fieldSetObj.getFields() ){
	String dataType = String.valueOf(eachFieldSetMember.getType()).toLowerCase();
	//This way we can set the type of a column
	//We do not get the exact type from schema object which matches to lightning:datatable component structure
	
	if(dataType == 'datetime'){
		dataType = 'date';
	}
	if(dataType == 'double'){
		dataType = 'number';
	}
	if(dataType == 'currency'){
		typeattributes.put('currencyCode',Currencycode);
	}
	//Create a wrapper instance and store label, fieldname and type.
	if(String.valueOf(eachFieldSetMember.getFieldPath()) != 'CPQ_Market_Model__c') { // added by jithin - flexible group
		DataTableColumns datacolumns = new DataTableColumns( String.valueOf(eachFieldSetMember.getLabel()) , 
					String.valueOf(eachFieldSetMember.getFieldPath()), 
					dataType,
				   typeattributes);
		lstDataColumns.add(datacolumns);
		lstFieldsToQuery.add(String.valueOf(eachFieldSetMember.getFieldPath()));
	}
			}
			
			//Form an SOQL to fetch the data - Set the wrapper instance and return as response
			if(! lstDataColumns.isEmpty()){		 
	response.lstDataTableColumns = lstDataColumns;
	String query = '';
	if(isCQQuote && groupName == null){
		query = 'SELECT Id, ' + String.join(lstFieldsToQuery, ',') + ' FROM Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = \''+configId+'\' and cpq_market_model__c = null and CPQ_Uploaded_via_SSF__c = false and Apttus_Config2__AddedBy__c != \'System\' and CPQ_SSF_Permission__c = null and Apttus_Config2__LineType__c = \'Product/Service\' AND Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c = \'Standalone\' order by Apttus_Config2__LineNumber__c ASC';
	} else if(groupName == null){
		query = 'SELECT Id, ' + String.join(lstFieldsToQuery, ',') + ' FROM Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = \''+configId+'\' and cpq_market_model__c = null order by Apttus_Config2__LineNumber__c ASC';
	}else{
		query = 'SELECT Id, ' + String.join(lstFieldsToQuery, ',') + ' FROM Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = \''+configId+'\' and cpq_market_model__c =\''+groupName+'\' order by Apttus_Config2__LineNumber__c ASC';
	}
	response.lstDataTableData = Database.query(query);
			}
			
			
		}
		catch(exception ex){
			system.debug('exception'+ex.getMessage());
			ExceptionHandler.addException(ex,GlobalConstants.FlexibleGroupController, GlobalConstants.getlineitems);
		}
		return response;
	}
	
	@AuraEnabled
	public static Boolean repriceCart(Id cartId) {
		Boolean IsPricePending = true;
		Apttus_CPQApi.CPQ.UpdatePriceRequestDO priceReqDO = new Apttus_CPQApi.CPQ.UpdatePriceRequestDO();
		priceReqDO.cartID = cartId;
		Apttus_CPQApi.CPQ.UpdatePriceResponseDO priceRespDO = Apttus_CPQApi.CPQWebService.updatePriceForCart(priceReqDO);	
		List<Decimal> complLineNums = priceRespDO.CompletedLineNumbers;
		System.debug('completed li: ' + complLineNums);
		IsPricePending = priceRespDO.IsPricePending;
		List<Decimal> PendingLineNumbers = priceRespDO.PendingLineNumbers;
		System.debug('pending li: ' + PendingLineNumbers);
		system.debug('IsPricePending :'+ IsPricePending);
		return IsPricePending;
	}
	
	@AuraEnabled
	public static bundlecreationwrapper updatemarketmodel (String modelname, Integer modelqty, List<Apttus_Config2__LineItem__c> LineitemIdList, Id configId, String GrpPicklist, Boolean QtyChanged, String adjustmentType, String adjustmentAmount, String unitOverridePrice){
		List<Apttus_Config2__LineItem__c> LIListupdate = new List<Apttus_Config2__LineItem__c>();
		bundlecreationwrapper BundleCreationData = new bundlecreationwrapper();
		map<Id, Apttus_Config2__LineItem__c> LineItemmap = new map<Id, Apttus_Config2__LineItem__c>() ;
		LineItemmap.putAll(LineitemIdList);
		try{
			system.debug('to update lis: '+LineItemmap.size());
			if(GrpPicklist == 'new'){
	Apttus_Config2__LineItem__c[] LIList = [Select Id, cpq_market_model__c,CPQ_Contracted_Price__c,Apttus_Config2__BasePriceOverride__c, CPQ_Original_Proposed_Price__c,Apttus_Config2__PricingStatus__c,Apttus_Config2__Quantity__c,Apttus_Config2__ConfigurationId__c from Apttus_Config2__LineItem__c where Id in :LineitemIdList and Apttus_Config2__ConfigurationId__c = :configId];
	
	Integer codeseq = getbundlecount(configId) + 1;
	IF(!LIList.isempty()){
		for(Apttus_Config2__LineItem__c LI :LIList){
			// LI.cpq_market_model__c = modelname+' QTY('+modelQty+')';
			LI.cpq_market_model__c = modelname;
			LI.CPQ_Group_Quantity__c = modelqty;
			LI.Flexible_group_code__c = 'SOLUTION00' +codeseq;
			LI.Apttus_Config2__PricingStatus__c = 'Pending';
			LI.Apttus_Config2__Quantity__c = LI.Apttus_Config2__Quantity__c * modelqty;
			setGroupPricingFields(LI, adjustmentType, adjustmentAmount, unitOverridePrice);//added by jithin - flexible group
			LIListupdate.add(LI);
		}
	}
			}else{
	Apttus_Config2__LineItem__c[] LIList = [Select Id, cpq_market_model__c,CPQ_Contracted_Price__c,CPQ_Group_Quantity__c, CPQ_Original_Proposed_Price__c, 
					Apttus_Config2__PricingStatus__c,Apttus_Config2__Quantity__c,
					Apttus_Config2__ConfigurationId__c,Apttus_Config2__BasePriceOverride__c,Flexible_group_code__c
					from Apttus_Config2__LineItem__c where (Id in :LineItemmap.keyset() or cpq_market_model__c = :GrpPicklist) and Apttus_Config2__ConfigurationId__c = :configId order by Flexible_group_code__c ASC NULLS LAST
	];//modified by jithin - to add Flexible_group_code__c field
	
	system.debug('Update flexible group, existing lines: '+LIList);
	IF(!LIList.isempty()){
		String existingGroupCode = LIList[0].Flexible_group_code__c;
		for(Apttus_Config2__LineItem__c LI :LIList){
			system.debug('LIbefore modifying :'+LI);
			Integer Currentflexiqty = (LI.CPQ_Group_Quantity__c == null || LI.CPQ_Group_Quantity__c == 0) ? 1 : Integer.valueOf(LI.CPQ_Group_Quantity__c);  
			// LI.cpq_market_model__c = modelname + ' QTY('+modelqty+')';
			LI.cpq_market_model__c = modelname;
			LI.CPQ_Group_Quantity__c = modelqty;
			LI.Flexible_group_code__c = existingGroupCode;
			LI.Apttus_Config2__PricingStatus__c = 'Pending';
			if(LineItemmap.containskey( LI.Id)){
				LI.Apttus_Config2__Quantity__c = LI.Apttus_Config2__Quantity__c * modelqty;
			}else{
				LI.Apttus_Config2__Quantity__c = (LI.Apttus_Config2__Quantity__c / Currentflexiqty) * modelqty ; 
			}
			setGroupPricingFields(LI, adjustmentType, adjustmentAmount, unitOverridePrice);
			LIListupdate.add(LI);
			system.debug('LI after modifying :'+LI);
		}
	}
			}
			if(!LIListupdate.isempty()){
	database.update(LIListupdate);
			}
			
		}
		catch(exception ex){
			system.debug('exception'+ex.getMessage());
			ExceptionHandler.addException(ex,GlobalConstants.FlexibleGroupController, GlobalConstants.updatemarketmodel);
		}
		return BundleCreationData;
	}
	
	// added by jithin - flexible groups - start
	// description: this method sets the group level fields on the line item
	private static void setGroupPricingFields(Apttus_Config2__LineItem__c li, String adjustmentType, String adjustmentAmount, String unitOverridePrice) {
		if(String.isNotBlank(adjustmentType) && adjustmentType.equalsIgnoreCase('Price Override')) {
			if(String.isNotBlank(unitOverridePrice)) {//removed condition Decimal.valueOf(unitOverridePrice) > 0 to allow negative values
	Decimal unitOverridePriceDecimal = Decimal.valueOf(unitOverridePrice);
	li.CPQ_Group_Adjustment_Type__c = adjustmentType;
	li.CPQ_Group_Unit_Override_Price__c = unitOverridePriceDecimal;
	li.CPQ_Group_Adjustment_Amount__c = unitOverridePriceDecimal * ((li.CPQ_Group_Quantity__c == null || li.CPQ_Group_Quantity__c == 0) ? 1 : li.CPQ_Group_Quantity__c);
			} else {
	li.CPQ_Group_Adjustment_Type__c = null;
	li.CPQ_Group_Unit_Override_Price__c = null;
	li.CPQ_Group_Adjustment_Amount__c = null;
	li.Apttus_Config2__BasePriceOverride__c = (li.CPQ_Original_Proposed_Price__c == null || li.CPQ_Original_Proposed_Price__c == 0 || li.CPQ_Contracted_Price__c != null) ? null : li.CPQ_Original_Proposed_Price__c;
			}
		}
	}
	// added by jithin - flexible groups - end


	//=================================================================================================
	
	@AuraEnabled
	public static map<String, String> getgrouplist (Id configId){
		system.debug('getgrouplist');
		map<String, String> grouplist = new map<String, String>();
		List<Apttus_Config2__LineItem__c> liList = [
			SELECT Id, cpq_market_model__c FROM Apttus_Config2__LineItem__c WHERE Apttus_Config2__ConfigurationId__c = :configId AND CPQ_Market_Model__c != null 
		];
		Set<String> groupNameSet = new Set<String>();
		for(Apttus_Config2__LineItem__c li : liList) {
			if(String.isNotBlank(li.cpq_market_model__c)) {
	groupNameSet.add(li.cpq_market_model__c.trim().toLowerCase());
			}
		}
		if(!groupNameSet.isEmpty()) {
			for(String gName : groupNameSet) {
	grouplist.put(gName, gName);
			}
		}
		system.debug(grouplist);
		return grouplist;
	}
	
	//added by jithin - flexible groups - start
	//=================================================================================================

	@AuraEnabled
	public static map<String, String> getGroupAdjustmentTypes (){
		system.debug('getGroupAdjustmentTypes');
		Map<String, String> adjustmentTypeOptions  = new Map<String, String>();
		Schema.DescribeFieldResult fieldResult = Apttus_Config2__LineItem__c.CPQ_Group_Adjustment_Type__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			adjustmentTypeOptions.put(pickListVal.getValue(), pickListVal.getLabel());
		} 
		system.debug(adjustmentTypeOptions);
		return adjustmentTypeOptions;
	}
	//added by jithin - flexible groups - start

	//=================================================================================================
	
	@AuraEnabled
	public static bundledatawrapper getbundledata (string groupName, Id configId ){
		system.debug('jithin getgrouplist' + groupName);
		Decimal TotalCLP = 0;
		Decimal TotalCNP = 0;
		String Currencycode;
		bundledatawrapper bundledata = new bundledatawrapper();
		List<String> grouplist = new List<String>();
		try{
			//uat bug fix
		List<Apttus_Config2__LineItem__c> LIlist = [Select cpq_market_model__c,CPQ_Group_Adjustment_Type__c,CPQ_Group_Unit_Override_Price__c, CPQ_Group_Adjustment_Amount__c,  CPQ_Group_Quantity__c, NokiaCPQ_Extended_CLP__c, NokiaCPQ_Partner_Price__c,currencyIsoCode from Apttus_Config2__LineItem__c 
				where Apttus_Config2__ConfigurationId__c = :configId and 
				cpq_market_model__c = :groupName ];
		System.debug('jithin LIlist--' + LIlist);
		bundledata.BundleList = getlineitems(configId, groupName);
		If(!LIlist.isempty()){
			Currencycode = LIlist[0].currencyIsoCode;
			for(Apttus_Config2__LineItem__c LI: LIlist){
	
	TotalCNP += LI.NokiaCPQ_Extended_CLP__c;
	
			}
			// TotalCLP = TotalCNP / Integer.valueOf(LIlist[0].cpq_market_model__c.substringBetween('QTY(',')'));
			Integer groupQuantity = (LIlist[0].CPQ_Group_Quantity__c == null || LIlist[0].CPQ_Group_Quantity__c == 0) ? 1 : Integer.valueOf(LIlist[0].CPQ_Group_Quantity__c);
			TotalCLP = TotalCNP / groupQuantity;
			// bundledata.rollupdata.put('GroupCode',LIlist[0].Flexible_group_code__c);
			bundledata.rollupdata.put('GroupName',LIlist[0].cpq_market_model__c);
			bundledata.rollupdata.put('adjustmentType',String.isBlank(LIlist[0].CPQ_Group_Adjustment_Type__c) ? '' :  LIlist[0].CPQ_Group_Adjustment_Type__c);//added by jithin - flexible group
			bundledata.rollupdata.put('unitOverridePrice',LIlist[0].CPQ_Group_Unit_Override_Price__c != null ? String.valueof(LIlist[0].CPQ_Group_Unit_Override_Price__c) : '');//added by jithin - flexible group
			bundledata.rollupdata.put('adjustmentAmount',LIlist[0].CPQ_Group_Adjustment_Amount__c != null ? String.valueof(LIlist[0].CPQ_Group_Adjustment_Amount__c) : '');//added by jithin - flexible group
			// bundledata.rollupdata.put('Quantity',LIlist[0].cpq_market_model__c.substringBetween('QTY(',')'));
			bundledata.rollupdata.put('Quantity',String.valueof(groupQuantity));//added by jithin - flexible group
			bundledata.rollupdata.put('CLP',String.valueof(TotalCLP));
			bundledata.rollupdata.put('CNP',String.valueof(TotalCNP));
			bundledata.rollupdata.put('Currency',Currencycode);
		}
		}
		catch(exception ex){
			system.debug('exception'+ex.getMessage());
			ExceptionHandler.addException(ex,GlobalConstants.FlexibleGroupController, GlobalConstants.getbundledata);
		}
		return bundledata;
	}
	
	//=======================================================================
	//
	//
	@AuraEnabled
	public static bundlecreationwrapper RemoveLineItems (List<Apttus_Config2__LineItem__c> LineitemIdList, Id configId ){
		
		Apttus_Config2__LineItem__c[] LIList = [Select Id, cpq_market_model__c,CPQ_Contracted_Price__c,Apttus_Config2__BasePriceOverride__c,Flexible_group_code__c,CPQ_Group_Quantity__c,CPQ_Original_Proposed_Price__c,Apttus_Config2__PricingStatus__c,Apttus_Config2__Quantity__c,Apttus_Config2__ConfigurationId__c from Apttus_Config2__LineItem__c where Id in :LineitemIdList];
		List<Apttus_Config2__LineItem__c> LIListupdate = new List<Apttus_Config2__LineItem__c>();
		bundlecreationwrapper BundleCreationData = new bundlecreationwrapper();
		try{
			String groupName = LIList[0].cpq_market_model__c.toLowerCase();
			Integer groupQuantity = (LIList[0].CPQ_Group_Quantity__c == null || LIList[0].CPQ_Group_Quantity__c == 0) ? 1 : Integer.valueOf(LIList[0].CPQ_Group_Quantity__c);
			for(Apttus_Config2__LineItem__c li :LIList){
	li.Flexible_group_code__c = null;
	li.Apttus_Config2__PricingStatus__c = 'Pending';
	// LI.Apttus_Config2__Quantity__c = LI.Apttus_Config2__Quantity__c / Integer.valueOf(LI.cpq_market_model__c.substringBetween('QTY(',')'));
	li.cpq_market_model__c = null;
	//added by jithin - flexible group - start
	li.Apttus_Config2__Quantity__c = LI.Apttus_Config2__Quantity__c / groupQuantity;
	li.CPQ_Group_Quantity__c = null;
	li.CPQ_Group_Adjustment_Type__c = null;
	li.CPQ_Group_Unit_Override_Price__c = null;
	li.CPQ_Group_Adjustment_Amount__c = null;
	li.Apttus_Config2__BasePriceOverride__c = (li.CPQ_Original_Proposed_Price__c == null || li.CPQ_Original_Proposed_Price__c == 0  || li.CPQ_Contracted_Price__c != null) ? null : li.CPQ_Original_Proposed_Price__c;
	//added by jithin - flexible group - end
	LIListupdate.add(LI);
	System.debug('to remove Li: ' + LI);
			}
			Apttus_Config2__LineItem__c[] existingLIList = [Select Id, Apttus_Config2__PricingStatus__c from Apttus_Config2__LineItem__c where (cpq_market_model__c = :groupName and Apttus_Config2__ConfigurationId__c = :configId and Id not in :LineitemIdList)];
			for(Apttus_Config2__LineItem__c li : existingLIList){
	li.Apttus_Config2__PricingStatus__c = 'Pending';
	LIListupdate.add(LI);
			}
			database.update(LIListupdate);
			
		} catch(exception ex) {
			system.debug('exception'+ex.getMessage());
			ExceptionHandler.addException(ex,GlobalConstants.FlexibleGroupController, GlobalConstants.RemoveLineItems);
		}
		return BundleCreationData;
	}
	
	//hybrid flexi change
	@AuraEnabled
	public static bundlecreationwrapper getCurrentState (Id configId, String groupName){
		bundlecreationwrapper BundleCreationData = new bundlecreationwrapper();
		try {
			BundleCreationData.StandaloneList =  getlineitems(configId, null);
			BundleCreationData.BundlePickLists = getgrouplist(configId);
			if(String.isNotBlank(groupName)) {
	groupName = groupName.trim().toLowerCase();
			}
			//remove - update market model
			if(!BundleCreationData.BundlePickLists.isEmpty() && String.isNotBlank(groupName) && BundleCreationData.BundlePickLists.containsKey(groupName)) {
	BundleCreationData.BundleData = getbundledata(groupName,configId);
	BundleCreationData.NewBundleCode = groupName;
			} else {
	BundleCreationData.BundleData = new bundledatawrapper();
	BundleCreationData.NewBundleCode = '';
			}

		} catch(exception ex) {
			system.debug('exception'+ex.getMessage());
			ExceptionHandler.addException(ex,GlobalConstants.FlexibleGroupController, 'getCurrentState');
		}

		return BundleCreationData;
	}
	//=======================================================================
	//
	//
	
	public Static Integer getbundlecount(Id ConfigId){
		
		Integer bundleCount = 0;
		for(AggregateResult Aggres : [select Flexible_group_code__c from Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = :configId and 
			  Flexible_group_code__c != null group by Flexible_group_code__c]){
			Integer Count = Integer.valueOf(((String)Aggres.get('Flexible_group_code__c')).right(3));
			
			bundleCount = bundleCount < Count ?Count : bundleCount;		  
			
			  }
		
		return bundleCount;
	}
	
	//=========================================================================
	
	//hybrid quote change
	@AuraEnabled
	public Static HierarchyDataResponse gethierarchydatafixedcol(Id configId){
		
		system.debug('configId: '+configId);
		HierarchyDataResponse response = new HierarchyDataResponse();
		try{
			Schema.FieldSet fieldSetObj = Schema.getGlobalDescribe().get('Apttus_Config2__LineItem__c').getDescribe().FieldSets.getMap().get('MarketModel_Listview');
			Apttus_Config2__ProductConfiguration__c configObj = [select CurrencyIsoCode, CPQ_IsCQ__c from Apttus_Config2__ProductConfiguration__c where id = :configId];
			String Currencycode = configObj.CurrencyIsoCode;
			Boolean isCQQuote = configObj.CPQ_IsCQ__c;
			map<string, string> typeattributes = new map<string, string>();
			
			//To hold the table hearders 
			List<DataTableColumns> lstDataColumns = new List<DataTableColumns>();
			
			//Field to be queried - fetched from fieldset
			List<String> lstFieldsToQuery = new List<String>();
			
			//The final wrapper response to return to component
			
			
			for( Schema.FieldSetMember eachFieldSetMember : fieldSetObj.getFields() ){
	String dataType = String.valueOf(eachFieldSetMember.getType()).toLowerCase();
	String fieldname = String.valueOf(eachFieldSetMember.getFieldPath());
	//This way we can set the type of a column
	//We do not get the exact type from schema object which matches to lightning:datatable component structure
	
	if(dataType == 'double'){
		dataType = 'number';
	}
	if(dataType == 'currency'){
		typeattributes.put('currencyCode',Currencycode);
	}
	//Create a wrapper instance and store label, fieldname and type.
	DataTableColumns datacolumns = new DataTableColumns( String.valueOf(eachFieldSetMember.getLabel()) , 
					fieldname.removeEndIgnoreCase('__c'), 
					dataType,
				   typeattributes);
	lstDataColumns.add(datacolumns);
	lstFieldsToQuery.add(String.valueOf(eachFieldSetMember.getFieldPath()));
			}
			
			//Form an SOQL to fetch the data - Set the wrapper instance and return as response
			if(! lstDataColumns.isEmpty()){		 
	response.lstDataTableColumns = lstDataColumns;
	
	map<String, List<Lineitemchildwrapper>> FlexiGrpwithrelatedLI = new map<String, List<Lineitemchildwrapper>>();
	map<String, Decimal> FlexiGrpwithrollupdata = new map<String, Decimal>();
	// map<String, String> FlexiGrpcodewithname = new map<String, String>();
	String query = '';
	String extra_fields =  ',Flexible_group_code__c,CPQ_Group_Quantity__c';
	if(isCQQuote){
		query = 'SELECT Id, ' + String.join(lstFieldsToQuery, ',') +extra_fields+ ' FROM Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = \''+configId+'\' and CPQ_Uploaded_via_SSF__c = false and Apttus_Config2__AddedBy__c != \'System\' and CPQ_SSF_Permission__c = null and Apttus_Config2__LineType__c = \'Product/Service\' AND Apttus_Config2__ProductId__r.Apttus_Config2__ConfigurationType__c = \'Standalone\' order by Apttus_Config2__LineNumber__c ASC';
	} else {
		query = 'SELECT Id, ' + String.join(lstFieldsToQuery, ',') +extra_fields+ ' FROM Apttus_Config2__LineItem__c where Apttus_Config2__ConfigurationId__c = \''+configId+'\'';
	}
	System.debug(query);
	
	For(Apttus_Config2__LineItem__c LineItem_rec:  Database.query(query)){
		Lineitemparentwrapper ParentLeveldata = new Lineitemparentwrapper();
		
		
		if(LineItem_rec.cpq_market_model__c != null && LineItem_rec.cpq_market_model__c != ''){
			Integer groupQuantity = (LineItem_rec.CPQ_Group_Quantity__c == null || LineItem_rec.CPQ_Group_Quantity__c == 0) ? 1 : Integer.valueOf(LineItem_rec.CPQ_Group_Quantity__c);
			Lineitemchildwrapper childdata = new Lineitemchildwrapper();
			// FlexiGrpcodewithname.put(LineItem_rec.Flexible_group_code__c,LineItem_rec.cpq_market_model__c);
			
			childdata.LineId = LineItem_rec.Id;
			childdata.CPQ_Market_Model = LineItem_rec.CPQ_Market_Model__c;
			childdata.NokiaCPQ_Part_Number = LineItem_rec.NokiaCPQ_Part_Number__c;
			childdata.NokiaCPQ_Product_Name = LineItem_rec.NokiaCPQ_Product_Name__c;
			childdata.Apttus_Config2_Quantity = LineItem_rec.Apttus_Config2__Quantity__c;
			childdata.NokiaCPQ_Extended_CLP = (LineItem_rec.NokiaCPQ_Extended_CLP__c).setscale(2);
			childdata.CPQ_Group_Quantity = groupQuantity;
			
			if(FlexiGrpwithrollupdata.containsKey(LineItem_rec.cpq_market_model__c.toLowerCase())){
				Decimal Total = LineItem_rec.NokiaCPQ_Extended_CLP__c + FlexiGrpwithrollupdata.get(LineItem_rec.cpq_market_model__c.toLowerCase()) ;
				FlexiGrpwithrollupdata.put(LineItem_rec.cpq_market_model__c.toLowerCase(), Total) ;
			}else{
				FlexiGrpwithrollupdata.put(LineItem_rec.cpq_market_model__c.toLowerCase(),LineItem_rec.NokiaCPQ_Extended_CLP__c);
			}
			
			if(FlexiGrpwithrelatedLI.containsKey(LineItem_rec.cpq_market_model__c.toLowerCase())){
				FlexiGrpwithrelatedLI.get(LineItem_rec.cpq_market_model__c.toLowerCase()).add(childdata);
			}else{
				FlexiGrpwithrelatedLI.put(LineItem_rec.cpq_market_model__c.toLowerCase(), new List<Lineitemchildwrapper>{childdata});
			}
			
		}else{
			ParentLeveldata.LineId = LineItem_rec.Id;
			ParentLeveldata.CPQ_Market_Model = LineItem_rec.CPQ_Market_Model__c;
			ParentLeveldata.NokiaCPQ_Part_Number = LineItem_rec.NokiaCPQ_Part_Number__c;
			ParentLeveldata.NokiaCPQ_Product_Name = LineItem_rec.NokiaCPQ_Product_Name__c;
			ParentLeveldata.Apttus_Config2_Quantity = LineItem_rec.Apttus_Config2__Quantity__c;
			ParentLeveldata.NokiaCPQ_Extended_CLP = LineItem_rec.NokiaCPQ_Extended_CLP__c;
			response.lstDataTableData.add(ParentLeveldata);
		}
		system.debug('ParentLeveldata: '+ParentLeveldata);
		
	}
	system.debug('FlexiGrpwithrelatedLI: '+FlexiGrpwithrelatedLI);
	List<String> FlexiGroupcodeList = new List<String>();
	FlexiGroupcodeList.addall(FlexiGrpwithrelatedLI.keyset());
	FlexiGroupcodeList.sort();
	
	for(String GroupCode: FlexiGroupcodeList){
		Lineitemparentwrapper Parentdata = new Lineitemparentwrapper();
		parentdata.childrenwrapper = new List<Lineitemchildwrapper>();

		Lineitemchildwrapper firstChild = FlexiGrpwithrelatedLI.get(GroupCode)[0];
		system.debug('FlexiGrpwithrelatedLI.get(GroupCode): '+FlexiGrpwithrelatedLI.get(GroupCode));		 
		Parentdata.LineId = getUUID();
		Parentdata.CPQ_Market_Model = firstChild.CPQ_Market_Model;
		Parentdata.NokiaCPQ_Part_Number = null;
		Parentdata.NokiaCPQ_Product_Name = null;
		Parentdata.NokiaCPQ_Extended_CLP = FlexiGrpwithrollupdata.get(GroupCode);
		// Parentdata.Apttus_Config2_Quantity = Decimal.valueOf(FlexiGrpcodewithname.get(GroupCode).substringBetween('QTY(',')')).setscale(0);
		Parentdata.Apttus_Config2_Quantity = Integer.valueOf(firstChild.CPQ_Group_Quantity);
		parentdata.childrenwrapper.addall(FlexiGrpwithrelatedLI.get(GroupCode)) ;
		system.debug('Parentdata: '+Parentdata);
		response.lstDataTableData.add(Parentdata);
		response.expandedrowslist.add(Parentdata.LineId);
	}
			}
			
			system.debug('response: '+response);
		}
		catch(exception ex){
			system.debug('exception'+ex.getMessage());
			ExceptionHandler.addException(ex,GlobalConstants.FlexibleGroupController, GlobalConstants.getlineitems);
		}
		return response;
	}
	//======================
	
	public static String getUUID()
	{
		Blob b = Crypto.GenerateAESKey(128);
		String h = EncodingUtil.ConvertTohex(b);
		String guid = h.SubString(0,8)+ '-' + h.SubString(8,12) + '-' + h.SubString(12,16) + '-' + h.SubString(16,20) + '-' + h.substring(20);
		system.debug(guid);
		return guid;
	}
	//=======================================================================
	//
	//
	public class bundledatawrapper{
		
		@AuraEnabled
		public map<string,string> rollupdata {get;set;}
		@AuraEnabled
		public DataTableResponse BundleList {get;set;}
		
		public bundledatawrapper(){
			
			BundleList = new DataTableResponse();
			rollupdata = new map<string,string>();
		}
		
	}   
	
	//=======================================================================
	//
	//
	public class bundlecreationwrapper{
		
		@AuraEnabled
		public DataTableResponse StandaloneList {get;set;}
		@AuraEnabled
		public bundledatawrapper BundleData {get;set;}
		@AuraEnabled
		public map<String, String> BundlePicklists {get;set;}
		@AuraEnabled
		public String NewBundleCode {get;set;}
		
		public bundlecreationwrapper(){
			
			StandaloneList = new DataTableResponse();
			BundlePicklists = new map<string,string>();
			BundleData = new bundledatawrapper();
			NewBundleCode = '';
		}
		
	}   
	//Wrapper class to hold Columns with headers
	public class DataTableColumns {
		@AuraEnabled
		public String label {get;set;}
		@AuraEnabled	
		public String fieldName {get;set;}
		@AuraEnabled
		public String type {get;set;}
		@AuraEnabled
		public map<string,string> typeAttributes {get;set;}
		
		//Create and set three variables label, fieldname and type as required by the lightning:datatable
		public DataTableColumns(String label, String fieldName, String type, map<string,string> typeAttributes){
			this.label = label;
			this.fieldName = fieldName;
			this.type = type;
			this.typeAttributes = typeAttributes;	  
		}
	}
	
	//Wrapper calss to hold response - This response is used in the lightning:datatable component
	public class DataTableResponse {
		@AuraEnabled
		public List<DataTableColumns> lstDataTableColumns {get;set;}
		@AuraEnabled
		public List<sObject> lstDataTableData {get;set;}
		
		
		public DataTableResponse(){
			lstDataTableColumns = new List<DataTableColumns>();
			lstDataTableData = new List<sObject>();
		}
	}
	
	public class TreeDataResponse {
		@AuraEnabled
		public List<DataTableColumns> lstDataTableColumns {get;set;}
		@AuraEnabled
		public List<Parentwrapper> lstDataTableData {get;set;}
		
		public TreeDataResponse(){
			lstDataTableColumns = new List<DataTableColumns>();
			lstDataTableData = new List<Parentwrapper>();
		}
	}
	
	public class Parentwrapper {
		@AuraEnabled
		public Apttus_Config2__LineItem__c parentobj {get;set;}
		@AuraEnabled
		public List<Apttus_Config2__LineItem__c> childdata {get;set;}
		@AuraEnabled
		public boolean isflexiblegroup {get;set;}
		@AuraEnabled
		public Decimal RollupAmount {get;set;}
		
		public Parentwrapper(){
			parentobj = new Apttus_Config2__LineItem__c() ;
			childdata = new List<Apttus_Config2__LineItem__c>();
			isflexiblegroup = false;
			RollupAmount =0;
			
		}
		
	}
	
	public Class Childwrapper{
		@AuraEnabled
		public sObject childobj {get;set;}
		@AuraEnabled
		public List<Childwrapper> childdata {get;set;}
	}
	
	public class HierarchyDataResponse {
		@AuraEnabled
		public List<DataTableColumns> lstDataTableColumns {get;set;}
		@AuraEnabled
		public List<Lineitemparentwrapper> lstDataTableData {get;set;}
		@AuraEnabled
		public List<String> expandedrowslist {get;set;}
		
		public HierarchyDataResponse(){
			lstDataTableColumns = new List<DataTableColumns>();
			lstDataTableData = new List<Lineitemparentwrapper>();
			expandedrowslist = new List<String>();
		}
	}
	
	public class Lineitemparentwrapper{
		@AuraEnabled
		public String LineId {get;set;}
		@AuraEnabled
		public String CPQ_Market_Model {get;set;}
		@AuraEnabled
		public String NokiaCPQ_Part_Number {get;set;}
		@AuraEnabled
		public String NokiaCPQ_Product_Name {get;set;}
		@AuraEnabled
		public Decimal Apttus_Config2_Quantity {get;set;}
		@AuraEnabled
		public Decimal NokiaCPQ_Extended_CLP {get;set;}
		@AuraEnabled
		public List<Lineitemchildwrapper> childrenwrapper {get;set;}
		
		}
	
	public class Lineitemchildwrapper{
		@AuraEnabled
		public String LineId {get;set;}
		@AuraEnabled
		public String CPQ_Market_Model {get;set;}
		@AuraEnabled
		public String NokiaCPQ_Part_Number {get;set;}
		@AuraEnabled
		public String NokiaCPQ_Product_Name {get;set;}
		@AuraEnabled
		public Decimal Apttus_Config2_Quantity {get;set;}
		@AuraEnabled
		public Decimal NokiaCPQ_Extended_CLP {get;set;}
		@AuraEnabled
		public Decimal CPQ_Group_Quantity {get;set;}
	}
}