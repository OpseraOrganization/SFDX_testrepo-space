public without sharing class CH_NetworkElementAssetUtility {
	
	public static CH_NetworkElementAssetWrapper.AssetPagerWrapper fetchAsset(Decimal pageNumber ,Integer recordToDisply, String contractLineItemId,String searchKeyWord,String jsonFiterSelected, String sortedBy , String sortedDirection , String serviceCLType ) {
		
		CH_NetworkElementAssetWrapper.AssetPagerWrapper obj =  new CH_NetworkElementAssetWrapper.AssetPagerWrapper();
		obj = fetchAssetNetworkElementWithSearch(pageNumber, recordToDisply, contractLineItemId, searchKeyWord, jsonFiterSelected, sortedBy, sortedDirection,  serviceCLType);
		system.debug('@@@'+obj.oAssets);
		return obj;
	}
	
	   /****************************************
* Created By : Rajeshwari
* Description : get ServiceClassificationType from ContractLineItem
*****************************************/ 
	@AuraEnabled 
	public static CH_NetworkElementAssetWrapper.AssetPagerWrapper fetchAssetNetworkElementWithSearch(Decimal pageNumber ,Integer recordToDisply, String contractLineItemId,String searchKeyWord,String jsonFiterSelected, String sortedBy , String sortedDirection , String serviceCLType) {
		System.debug(serviceCLType+' fetchAssetNetworkElementWithSearch @@'+sortedDirection);
		List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper> selectedFilter = (List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper>) JSON.deserialize(jsonFiterSelected, List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper>.class);
		Integer pageSize = recordToDisply;
		Integer offset = ((Integer)pageNumber - 1) * pageSize;
		map<String,string> operator = CH_NetworkElementAssetServicesHelper.getQueryOperator();
		String orderByName = CH_NetworkElementAssetServicesHelper.getAPINameForDataTable().get(sortedBy).replace('CH_NetworkElementAsset__r.','');
		if(sortedBy =='AssetCity' ){
			orderByName = 'Address__r.City';
		}if(sortedBy =='AssetState'){
			orderByName = 'Address__r.State';
		}
		// create a instance of wrapper class.
		String rtName = 'Network Element Asset' ;
		string rid = Schema.getGlobalDescribe().get('Asset').getDescribe().getRecordTypeInfosByName().get('Network Element Asset').getRecordTypeId();
		system.debug(orderByName+'rid '+rid);
		CH_NetworkElementAssetWrapper.AssetPagerWrapper obj =  new CH_NetworkElementAssetWrapper.AssetPagerWrapper();
		// set the pageSize,Page(Number), total records and asset List(using OFFSET)   
		obj.pageSize = pageSize;
		obj.page = (Integer) pageNumber;
		set<String> accountId = new set<String>();
		map<string, string> assetContractMap = new map<string, string>();
		String contLIProductRelease = null;
		String productId = null;
		String Country = null;
		String pVariant = null;
		String solution = null;
		List<ContractLineItem> objContractLineItem = [select id ,  Asset.CH_Solution__c,Asset.CH_ProductVariant__c, Asset.Product2Id,ASset.CH_CountryISOName__c, AssetId, Asset.CH_ProductRelease__c, ServiceContractId ,ServiceContract.AccountId from ContractLineItem where id =:contractLineItemId];
		for(ContractLineItem cli :objContractLineItem){
			if(cli.ServiceContractId !=null){
				accountId.add(cli.ServiceContract.AccountId);
			}
			contLIProductRelease = cli.Asset.CH_ProductRelease__c;
			productId = cli.Asset.Product2Id;
			Country = cli.Asset.CH_CountryISOName__c;
			pVariant = cli.Asset.CH_ProductVariant__c;
			solution = cli.Asset.CH_Solution__c;
		} 
		system.debug(' accountId'+accountId);
		set<string> InactiveassetId = new set<string>();
		set<string> activeassetId = new set<string>();
		List<CH_CoveredNetworkElementAsset__c>  networkEleAssests = [select Id,CH_Status__c, Name, CH_NetworkElementAsset__r.Name, CH_NetworkElementAsset__r.CH_LabEnvironment__c,CH_NetworkElementAsset__c, CH_NetworkElementAsset__r.Status,CH_NetworkElementAsset__r.CH_NetworkElementID__c,
																	 CH_NetworkElementAsset__r.Product2.Name, CH_NetworkElementAsset__r.Product2Id, CH_NetworkElementAsset__r.CH_Solution__c,
																	 CH_NetworkElementAsset__r.CH_ProductVariant__c, CH_NetworkElementAsset__r.CH_ProductRelease__c, CH_NetworkElementAsset__r.CH_City__c, CH_NetworkElementAsset__r.CH_State_Province__c,
																	 CH_NetworkElementAsset__r.CH_ProductVariant__r.Name, CH_NetworkElementAsset__r.CH_Solution__r.Name, CH_NetworkElementAsset__r.CH_ProductRelease__r.Name,
																	 CH_NetworkElementAsset__r.Address__r.CH_AddressDetails__c, CH_NetworkElementAsset__r.Address__c, CH_NetworkElementAsset__r.Address__r.Street, CH_NetworkElementAsset__r.Address__r.Country, CH_NetworkElementAsset__r.Address__r.postalcode
																	 from CH_CoveredNetworkElementAsset__c  where CH_ContractLineItem__c= :contractLineItemId and CH_NetworkElementAsset__r.recordTypeId=:rid
																	  ];
		for( CH_CoveredNetworkElementAsset__c cneElement : networkEleAssests){
		   
			if( cneElement.CH_Status__c=='Active'){
				activeassetId.add(cneElement.CH_NetworkElementAsset__c);
			}else{
	 assetContractMap.put( cneElement.CH_NetworkElementAsset__c,cneElement.Id);				
			}
		}
		InactiveassetId = assetContractMap.Keyset();
		string status ='Active';
		system.debug(contLIProductRelease+' InactiveassetId -->'+InactiveassetId);
		// obj.total = [SELECT count() FROM CH_CoveredNetworkElementAsset__c  where CH_ContractLineItem__c= :contractLineItemId and CH_NetworkElementAsset__r.recordTypeId=:rid];
		string assetQueryCount = 'SELECT count() FROM Asset  where   status = : status and   (CH_ProductRelease__c = : contLIProductRelease or CH_ProductRelease__c =null ) and ( AccountId in : accountId  or id in : InactiveassetId  )  and id not in : activeassetId and recordTypeID = : rid and Product2Id = :productId and CH_CountryISOName__c = :Country and CH_ProductVariant__c = :pVariant and CH_Solution__c =:solution ';
		String assetQuery = '	select id, Name, AccountID, CH_LabEnvironment__c, Status, CH_NetworkElementID__c, ';
		assetQuery = assetQuery+ ' Product2.Name, Product2Id, CH_Solution__c,Address__r.City,Address__r.State, Address__c, Address__r.Street, Address__r.Country, Address__r.postalcode, ';
		assetQuery = assetQuery+ '  CH_ProductVariant__c, CH_ProductRelease__c, ';
		assetQuery = assetQuery+ '  CH_ProductVariant__r.Name, CH_Solution__r.Name, CH_ProductRelease__r.Name, Address__r.CH_AddressDetails__c ';
		assetQuery = assetQuery+ ' from Asset  where status = : status and   (AccountId in : accountId  or id in : InactiveassetId) and id not in : activeassetId and recordTypeID = : rid and Product2Id = :productId and CH_CountryISOName__c = :Country  ';
		if(serviceCLType !='HWS Service'){
				assetQueryCount = assetQueryCount+ '  and CH_ProductVariant__c = :pVariant and CH_Solution__c =:solution and (CH_ProductRelease__c = : contLIProductRelease or CH_ProductRelease__c =null ) ';
				assetQuery = assetQuery+ '  and CH_ProductVariant__c = :pVariant and CH_Solution__c =:solution  and (CH_ProductRelease__c = : contLIProductRelease or CH_ProductRelease__c =null ) ';
				
	   }
		if(selectedFilter !=null && !selectedFilter.isempty()){
			for(CH_NetworkElementAssetWrapper.FilterSelectionWrapper filterField : selectedFilter){
				system.debug(' @@ filterField '+filterField);
				String qOpt = operator.get(filterField.fieldOperator);
				String fieldAPIName = filterField.fieldAPI ;
				String fieldValue = filterField.fieldValue;
				if(fieldValue.contains('\'')){
					 fieldValue = fieldValue.replace('\'', '\\\''); //cases where the fieldvalue has '
				} 
				system.debug(fieldValue + 'fieldValue fieldAPIName'+fieldAPIName+' @@@ '+qOpt);
				
				if(qOpt =='LIKE'){
					fieldValue = '%'+fieldValue+'%';
				}
				assetQuery = assetQuery+ ' AND '+fieldAPIName+ ' '+qOpt+' \''+fieldValue+'\'';
				assetQueryCount = assetQueryCount+ ' AND '+fieldAPIName+ ' '+qOpt+' \''+fieldValue+'\'';
			}
		}
		if(searchKeyWord !=null && searchKeyWord !=''){
			searchKeyWord = '%'+searchKeyWord+'%';
			system.debug(' searchKeyWord @@'+searchKeyWord); 
			String assetQuery1 =  ' AND ( Status LIKE  \''+searchKeyWord+'\' ';
			assetQuery1 = assetQuery1+ 'OR Name LIKE \''+searchKeyWord+'\' ';
			assetQuery1 = assetQuery1+ 'OR Address__r.City LIKE \''+searchKeyWord+'\' ';
			assetQuery1 = assetQuery1+ 'OR Address__r.State LIKE \''+searchKeyWord+'\' ';
			assetQuery1 = assetQuery1+ 'OR Address__r.Street LIKE \''+searchKeyWord+'\' ';
			assetQuery1 = assetQuery1+ 'OR Address__r.postalcode LIKE \''+searchKeyWord+'\' ';
			assetQuery1 = assetQuery1+ 'OR Address__r.Country LIKE \''+searchKeyWord+'\' ';
			assetQuery1 = assetQuery1+ 'OR CH_NetworkElementID__c LIKE \''+searchKeyWord+'\' ';
			assetQuery1 = assetQuery1+ 'OR Product2.Name LIKE \''+searchKeyWord+'\' ';
			assetQuery1 = assetQuery1+ 'OR CH_ProductRelease__r.Name LIKE \''+searchKeyWord+'\' ';
			if(serviceCLType =='HWS Service'){
				assetQuery1 = assetQuery1+ ' OR CH_Solution__r.Name LIKE \''+searchKeyWord+'\' ';
				assetQuery1 = assetQuery1+ ' OR CH_ProductVariant__r.Name LIKE \''+searchKeyWord+'\' ';
			}
			assetQuery1 = assetQuery1+ ' )';
			
			assetQuery = assetQuery+assetQuery1; 
			assetQueryCount = assetQueryCount+ ' AND ( Status LIKE  \''+searchKeyWord+'\' ';
			assetQueryCount = assetQueryCount+ 'OR Name LIKE \''+searchKeyWord+'\' ';
			assetQueryCount = assetQueryCount+ 'OR Address__r.City LIKE \''+searchKeyWord+'\' ';
			assetQueryCount = assetQueryCount+ 'OR Address__r.State LIKE \''+searchKeyWord+'\' ';
			assetQueryCount = assetQueryCount+ 'OR Address__r.Street LIKE \''+searchKeyWord+'\' ';
			assetQueryCount = assetQueryCount+ 'OR Address__r.postalcode LIKE \''+searchKeyWord+'\' ';
			assetQueryCount = assetQueryCount+ 'OR Address__r.Country LIKE \''+searchKeyWord+'\' ';
			assetQueryCount = assetQueryCount+ 'OR CH_NetworkElementID__c LIKE \''+searchKeyWord+'\' ';
			assetQueryCount = assetQueryCount+ 'OR Product2.Name LIKE \''+searchKeyWord+'\' ';
			assetQueryCount = assetQueryCount+ 'OR CH_ProductRelease__r.Name LIKE \''+searchKeyWord+'\' ';
			if(serviceCLType =='HWS Service'){
				assetQueryCount = assetQueryCount+ ' OR CH_Solution__r.Name LIKE \''+searchKeyWord+'\' ';
				assetQueryCount = assetQueryCount+ ' OR CH_ProductVariant__r.Name LIKE \''+searchKeyWord+'\' ';
			}
			assetQueryCount = assetQueryCount+ ' )';

		}
		if(orderByName == 'Address__r.CH_AddressDetails__c'){
			orderByName ='Address__r.Street';
		}
		String assetQueryWithoutOffset = assetQuery;
		if(sortedDirection =='DESC'){
			assetQuery = assetQuery+ ' ORDER BY '+ orderByName+' '+ sortedDirection+'  NULLS LAST LIMIT :recordToDisply OFFSET :offset';
		}else{
			assetQuery = assetQuery+ ' ORDER BY '+ orderByName+' '+ sortedDirection+'  NULLS FIRST LIMIT :recordToDisply OFFSET :offset';
		}
		
		obj.oAssets = database.query(assetQuery);
		obj.total = database.countQuery(assetQueryCount);
		List<asset> assetWithoutOffset = database.query(assetQueryWithoutOffset);
		obj.assetId = getAllAssetId(assetWithoutOffset);
		system.debug(obj.total+'@@@ fetchAssetNetworkElementWithSearchMethod ends'+obj.networkEleAssests);
		
		return obj;
	}
	
	public static void addToCoveredNetworkElement (String contractLineItemId , List<string> selectedRowID){
		system.debug(contractLineItemId+'addToCoveredNetworkElement '+selectedRowID);
		String rtName = 'Network Element Asset' ;
		set<string> existingAsset = new set<string>();
		string rid = Schema.getGlobalDescribe().get('Asset').getDescribe().getRecordTypeInfosByName().get('Network Element Asset').getRecordTypeId();
		List<CH_CoveredNetworkElementAsset__c>  networkEleAssestUpdatestatus = new List<CH_CoveredNetworkElementAsset__c>();
		List<CH_CoveredNetworkElementAsset__c>  networkEleAssests = [select Id,Name, CH_NetworkElementAsset__r.Name, CH_NetworkElementAsset__r.CH_LabEnvironment__c,CH_NetworkElementAsset__c, CH_NetworkElementAsset__r.Status,CH_NetworkElementAsset__r.CH_NetworkElementID__c,
																	 CH_NetworkElementAsset__r.Product2.Name, CH_NetworkElementAsset__r.Product2Id, CH_NetworkElementAsset__r.CH_Solution__c,
																	 CH_NetworkElementAsset__r.CH_ProductVariant__c, CH_NetworkElementAsset__r.CH_ProductRelease__c, CH_NetworkElementAsset__r.CH_City__c, CH_NetworkElementAsset__r.CH_State_Province__c,
																	 CH_NetworkElementAsset__r.CH_ProductVariant__r.Name, CH_NetworkElementAsset__r.CH_Solution__r.Name, CH_NetworkElementAsset__r.CH_ProductRelease__r.Name, 
																	 CH_NetworkElementAsset__r.Address__r.CH_AddressDetails__c, CH_NetworkElementAsset__r.Address__c, CH_NetworkElementAsset__r.Address__r.Street, CH_NetworkElementAsset__r.Address__r.Country, CH_NetworkElementAsset__r.Address__r.postalcode
																	 from CH_CoveredNetworkElementAsset__c  where CH_ContractLineItem__c= :contractLineItemId and CH_NetworkElementAsset__r.recordTypeId=:rid
																	 and CH_Status__c !='Active'  and CH_NetworkElementAsset__c in : selectedRowID];
		for( CH_CoveredNetworkElementAsset__c cneElement : networkEleAssests){
			if(selectedRowID.Contains(cneElement.CH_NetworkElementAsset__c)){
				cneElement.CH_Status__c = 'Active';
				existingAsset.add(cneElement.CH_NetworkElementAsset__c);
			}
			networkEleAssestUpdatestatus.add(cneElement);
		}
		for(string rowId : selectedRowID){
			// if(existingAsset ==null && networkEleAssests.isempty()){
			if((existingAsset ==null && networkEleAssests.isempty()) || (existingAsset !=null && !existingAsset.contains(rowId)) ){
				existingAsset.add(rowId);
				CH_CoveredNetworkElementAsset__c cne = new CH_CoveredNetworkElementAsset__c();
				cne.CH_ContractLineItem__c = contractLineItemId;
				cne.CH_NetworkElementAsset__c = rowID;
				cne.CH_Status__c = 'Active';
				networkEleAssestUpdatestatus.add(cne);
			}
		}
		upsert networkEleAssestUpdatestatus;
		system.debug(' networkEleAssestUpdatestatus -->'+networkEleAssestUpdatestatus);
	}
	public static void unlinkToCoveredNetworkElement (String contractLineItemId , List<string> selectedRowID){
		system.debug(contractLineItemId+'addToCoveredNetworkElement '+selectedRowID);
		String rtName = 'Network Element Asset' ;
		set<string> existingAsset = new set<string>();
		string rid = Schema.getGlobalDescribe().get('Asset').getDescribe().getRecordTypeInfosByName().get('Network Element Asset').getRecordTypeId();
		List<CH_CoveredNetworkElementAsset__c>  networkEleAssestUpdatestatus = new List<CH_CoveredNetworkElementAsset__c>();
		List<CH_CoveredNetworkElementAsset__c>  networkEleAssests = [select Id,Name, CH_NetworkElementAsset__r.Name, CH_NetworkElementAsset__r.CH_LabEnvironment__c,CH_NetworkElementAsset__c, CH_NetworkElementAsset__r.Status,CH_NetworkElementAsset__r.CH_NetworkElementID__c,
																	 CH_NetworkElementAsset__r.Product2.Name, CH_NetworkElementAsset__r.Product2Id, CH_NetworkElementAsset__r.CH_Solution__c,
																	 CH_NetworkElementAsset__r.CH_ProductVariant__c, CH_NetworkElementAsset__r.CH_ProductRelease__c, CH_NetworkElementAsset__r.CH_City__c, CH_NetworkElementAsset__r.CH_State_Province__c,
																	 CH_NetworkElementAsset__r.CH_ProductVariant__r.Name, CH_NetworkElementAsset__r.CH_Solution__r.Name, CH_NetworkElementAsset__r.CH_ProductRelease__r.Name, 
																	 CH_NetworkElementAsset__r.Address__r.CH_AddressDetails__c, CH_NetworkElementAsset__r.Address__c, CH_NetworkElementAsset__r.Address__r.Street, CH_NetworkElementAsset__r.Address__r.Country, CH_NetworkElementAsset__r.Address__r.postalcode
																	 from CH_CoveredNetworkElementAsset__c  where CH_ContractLineItem__c= :contractLineItemId and CH_NetworkElementAsset__r.recordTypeId=:rid
																	 and CH_Status__c ='Active'  and CH_NetworkElementAsset__c in : selectedRowID];
		for( CH_CoveredNetworkElementAsset__c cneElement : networkEleAssests){
			cneElement.CH_Status__c = 'InActive';
			networkEleAssestUpdatestatus.add(cneElement);
		}

		upsert networkEleAssestUpdatestatus;
		system.debug(' networkEleAssestUpdatestatus -->'+networkEleAssestUpdatestatus);
	}
	
	public static set<string> getAllAssetId(List<asset> oAssetList){
		set<string> assetId = new set<string>();
		for(Asset obj :oAssetList ){
			assetId.add(obj.Id);
		}
		return assetId;
	}
	public static set<string> getAllNEId(List<CH_CoveredNetworkElementAsset__c> networkEleAssests){
		set<string> neID = new set<string>();
		for(CH_CoveredNetworkElementAsset__c obj :networkEleAssests ){
			neID.add(obj.Id);
		}
		return neID;
	}
	
	
}