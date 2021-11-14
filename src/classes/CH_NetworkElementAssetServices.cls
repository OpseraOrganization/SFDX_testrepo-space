/****************************************
* Class Name : CH_NetworkElementAssetServices
* Created Date: 31 Oct 2019
* Created By : Rajeshwari
* Description : Controller for Network Element Tab from CLI Related/Add/Unlink
* Test Class: 
Name	  Modified DATE	 Comments
*****************************************/
public without sharing class CH_NetworkElementAssetServices {
 /****************************************
* Created By : Rajeshwari
* Description : On Load of Related Tab, 
Fetch all the Linked Covered Network Element Asset match CLI id.
*****************************************/ 
 public static final String hwsServiceType='HWS Service';
 public static string rectypeId = Schema.getGlobalDescribe().get('Asset').getDescribe().getRecordTypeInfosByDeveloperName().get('CH_NetworkElementAsset').getRecordTypeId(); 
  @AuraEnabled 
  public static CH_NetworkElementAssetWrapper.AssetPagerWrapper fetchAssetFromNetworkElement(Decimal pageNumber ,Integer recordToDisply, String contractLineItemId) {
   
	Integer pageSize = recordToDisply;
	Integer offset = ((Integer)pageNumber - 1) * pageSize;
	CH_NetworkElementAssetWrapper.AssetPagerWrapper obj =  new CH_NetworkElementAssetWrapper.AssetPagerWrapper();
	// set the pageSize,Page(Number), total records and asset List(using OFFSET)   
	obj.pageSize = pageSize;
	obj.page = (Integer) pageNumber;
	obj.total = [SELECT count() FROM CH_CoveredNetworkElementAsset__c  where CH_ContractLineItem__c= :contractLineItemId and CH_NetworkElementAsset__r.recordTypeId=:rectypeId];
	
	obj.networkEleAssests = [select Id,Name,CH_Status__c,CH_NetworkElementAsset__r.Name, CH_NetworkElementAsset__r.CH_LabEnvironment__c,CH_NetworkElementAsset__c, CH_NetworkElementAsset__r.Status,CH_NetworkElementAsset__r.CH_NetworkElementID__c,
	 CH_NetworkElementAsset__r.Product2.Name, CH_NetworkElementAsset__r.Product2Id, CH_NetworkElementAsset__r.CH_Solution__c,
	 CH_NetworkElementAsset__r.CH_ProductVariant__c, CH_NetworkElementAsset__r.CH_ProductRelease__c, CH_NetworkElementAsset__r.CH_City__c, CH_NetworkElementAsset__r.CH_State_Province__c,
	 CH_NetworkElementAsset__r.CH_ProductVariant__r.Name, CH_NetworkElementAsset__r.CH_Solution__r.Name, CH_NetworkElementAsset__r.CH_ProductRelease__r.Name, 
	 CH_NetworkElementAsset__r.Address__r.CH_AddressDetails__c, CH_NetworkElementAsset__r.Address__c, CH_NetworkElementAsset__r.Address__r.Street,  CH_NetworkElementAsset__r.Address__r.Country, CH_NetworkElementAsset__r.Address__r.postalcode
	 from CH_CoveredNetworkElementAsset__c  where CH_ContractLineItem__c= :contractLineItemId and CH_NetworkElementAsset__r.recordTypeId=:rectypeId
	 ORDER BY Name LIMIT :recordToDisply OFFSET :offset ];
	obj =  CH_NetworkElementAssetServicesHelper.assignPicklistValue(obj);
   
	
	return obj;
  }
  /****************************************
* Created By : Rajeshwari
* Description : Picklist values for Filter Logic
*****************************************/
  @AuraEnabled 
  public static CH_NetworkElementAssetWrapper.FilterSelectionWrapper getFilterFieldDetails(String fieldLabel, List<string> existingFilter, Boolean isChanged, String contractLineItemId, String serviceCLType){
	
	CH_NetworkElementAssetWrapper.FilterSelectionWrapper objFilterDetailsList = new CH_NetworkElementAssetWrapper.FilterSelectionWrapper();
	List<String> matchCriteriaSet = new List<string>();
	map<String,string> fieldAPISet = getFieldDetails(serviceCLType);
	List<string> fieldSet = new List<string>();
	List<String> pickValueOperator = new List<String>{'Equal', 'Not Equal'};
	  List<String> otherOperator = new List<String>{'Equal', 'Not Equal','Contains'};
		fieldSet = getFilterPickListValue( existingFilter,serviceCLType);
	if(!isChanged){
	  fieldLabel =fieldSet[0];
	}
	if((matchCriteriaSet !=null && !matchCriteriaSet.contains(fieldLabel)) || matchCriteriaSet ==null || matchCriteriaSet.isempty()) {
	  string apiName = fieldAPISet.get(fieldLabel);
	  Boolean isPickValue = false;
	  if(apiName=='Status' || apiName=='CH_City__c' || apiName=='CH_State_Province__c'||apiName=='CH_Status__c'
		|| apiName=='CH_ProductRelease__r.Name' || apiName=='CH_ProductVariant__r.Name'||apiName=='CH_Solution__r.Name'){
		isPickValue = true;
	  }
	  objFilterDetailsList = CH_NetworkElementAssetServicesHelper.assignFilterFieldDetails(fieldLabel, apiName, isPickValue, fieldAPISet.Values(), 
			 pickValueOperator, otherOperator, fieldSet, isChanged, contractLineItemId);
	}
   
	return objFilterDetailsList;
  }
  /****************************************
* Created By : Rajeshwari
* Description : Add all the Fields For Filter Logic 
serviceCLType ==hwsServiceType Add Product Variant & Product Solution
*****************************************/
  @AuraEnabled 
  public static  map<String,string> getFieldDetails(String serviceCLType){
   
	map<String,string> fieldAPISet = new map<String,string>();
	fieldAPISet.put('Link Status','CH_Status__c');
	fieldAPISet.put('Asset Name','Name');
	fieldAPISet.put('Network Element ID','CH_NetworkElementID__c');
	fieldAPISet.put('State/Province','CH_State_Province__c');
	fieldAPISet.put('City','CH_City__c');
	fieldAPISet.put('Product Release','CH_ProductRelease__r.Name');
	fieldAPISet.put('NEA Status','Status');
	if(serviceCLType !=null && serviceCLType ==hwsServiceType){
	  fieldAPISet.put('Solution','CH_Solution__r.Name');
	  fieldAPISet.put('Product Variant','CH_ProductVariant__r.Name');
	}
	return fieldAPISet;
  }
  /****************************************
* Created By : Rajeshwari
* Description :  Display only fields which are not selected in Filter criteria.
*****************************************/
  @AuraEnabled 
  public static  List<String> getFilterPickListValue(List<string> existingFilter, string serviceCLType){
	List<String> fieldSet = new List<String>();
	for(String field : getFieldDetails(serviceCLType).keySet()){
	  if(existingFilter !=null && !existingFilter.isempty() ){ //Checks if Fields are already added 
		if(!existingFilter.contains(field)){
	fieldSet.add(field);
		}
	  }else{
		fieldSet.add(field);
	  }
	}
   
	return fieldSet;
  }
  /****************************************
* Created By : Rajeshwari
* Description : selected Filter checks will be assigned to Wrapper
*****************************************/
  @AuraEnabled 
  public static  List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper> assignSelectedFieldsForFilter(string jsonFieldFilter, string jsonFieldFilterList){
	List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper> fieldList = (List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper>) JSON.deserialize(jsonFieldFilterList, List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper>.class);
	CH_NetworkElementAssetWrapper.FilterSelectionWrapper fieldFilter = (CH_NetworkElementAssetWrapper.FilterSelectionWrapper) JSON.deserialize(jsonFieldFilter, CH_NetworkElementAssetWrapper.FilterSelectionWrapper.class);
	if(fieldList == null || fieldList.isempty()){
	  fieldList = new List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper>();
	}
	fieldList.add(fieldFilter);
	
	return fieldList;
  }
  /****************************************
* Created By : Rajeshwari
* Description : On Load of Related/Unlink Tab, 
- Related Tab Fetch all the Linked Covered Network Element Asset match CLI id 
- Unlink Tab  Fetch all the Linked Covered Network Element Asset match CLI id & status is Active
*****************************************/
  @AuraEnabled 
  public static CH_NetworkElementAssetWrapper.AssetPagerWrapper fetchAssetNetworkElementWithSearch(Decimal pageNumber ,Integer recordToDisply, String contractLineItemId,String searchKeyWordSer,String jsonFiterSelected, String sortedBy , String sortedDirection, string type , String serviceCLType) {
	List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper> selectedFilter = (List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper>) JSON.deserialize(jsonFiterSelected, List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper>.class);
	Integer pageSize = recordToDisply;
	Integer offset = ((Integer)pageNumber - 1) * pageSize;
	map<String,string> operator = CH_NetworkElementAssetServicesHelper.getQueryOperator();
	String sortDirection = sortedDirection;
	String orderByName = CH_NetworkElementAssetServicesHelper.getAPINameForDataTable().get(sortedBy);
	string rectypeId = Schema.getGlobalDescribe().get('Asset').getDescribe().getRecordTypeInfosByDeveloperName().get('CH_NetworkElementAsset').getRecordTypeId();
	if(orderByName =='CH_NetworkElementAsset__r.CH_Status__c'){
	orderByName = 'CH_Status__c';
	}
	CH_NetworkElementAssetWrapper.AssetPagerWrapper obj =  new CH_NetworkElementAssetWrapper.AssetPagerWrapper();
	// set the pageSize,Page(Number), total records and asset List(using OFFSET)   
	obj.pageSize = pageSize;
	obj.page = (Integer) pageNumber;
	obj.total = [SELECT count() FROM CH_CoveredNetworkElementAsset__c  where CH_ContractLineItem__c= :contractLineItemId and CH_NetworkElementAsset__r.recordTypeId=:rectypeId];
	string assetQueryCountSer = 'SELECT count() FROM CH_CoveredNetworkElementAsset__c  where CH_ContractLineItem__c= :contractLineItemId and CH_NetworkElementAsset__r.recordTypeId=:rectypeId ';
	String assetQuery = 'Select Id,Name, CH_Status__c,CH_NetworkElementAsset__r.Name, CH_NetworkElementAsset__r.CH_LabEnvironment__c, CH_NetworkElementAsset__c, CH_NetworkElementAsset__r.Status,CH_NetworkElementAsset__r.CH_NetworkElementID__c,';
	assetQuery = assetQuery+ ' CH_NetworkElementAsset__r.Product2.Name, CH_NetworkElementAsset__r.Product2Id, CH_NetworkElementAsset__r.CH_Solution__c,';
	assetQuery = assetQuery+ ' CH_NetworkElementAsset__r.CH_ProductVariant__c, CH_NetworkElementAsset__r.CH_ProductRelease__c , CH_NetworkElementAsset__r.CH_City__c, CH_NetworkElementAsset__r.CH_State_Province__c, CH_NetworkElementAsset__r.Address__r.CH_AddressDetails__c, CH_NetworkElementAsset__r.Address__r.Country, CH_NetworkElementAsset__r.Address__c, CH_NetworkElementAsset__r.Address__r.Street, CH_NetworkElementAsset__r.Address__r.postalcode, ';
	assetQuery = assetQuery+ ' CH_NetworkElementAsset__r.CH_ProductVariant__r.Name, CH_NetworkElementAsset__r.CH_Solution__r.Name, CH_NetworkElementAsset__r.CH_ProductRelease__r.Name ';
	assetQuery = assetQuery+ ' FROM CH_CoveredNetworkElementAsset__c  where CH_ContractLineItem__c= :contractLineItemId and CH_NetworkElementAsset__r.recordTypeId=:rectypeId ';
	if(type !=null && type == 'Unlink'){
	  string activeStatus = 'Active';
	  assetQueryCountSer = assetQueryCountSer+ ' And CH_Status__C = :activeStatus ' ;
	  assetQuery = assetQuery+ ' And CH_Status__C = :activeStatus ' ;
	}
	//Assign if any Filter fields are selected.
	if(selectedFilter !=null && !selectedFilter.isempty()){
	  for(CH_NetworkElementAssetWrapper.FilterSelectionWrapper filterField : selectedFilter){
		String qOpt = operator.get(filterField.fieldOperator);
		String fieldAPIName = 'CH_NetworkElementAsset__r.'+filterField.fieldAPI ;
		if( filterField.fieldAPI =='CH_Status__c' ){
	 fieldAPIName ='CH_Status__c' ;
		}
		String fieldValueservice = filterField.fieldValue;
		if(fieldValueservice.contains('\'')){
	 fieldValueservice = fieldValueservice.replace('\'', '\\\''); //cases where the fieldvalue has '
		} 
		
		
		if(qOpt =='LIKE'){
	fieldValueservice = '%'+fieldValueservice+'%';
		}
		assetQuery = assetQuery+ ' AND '+fieldAPIName+ ' '+qOpt+' \''+fieldValueservice+'\'';
		assetQueryCountSer = assetQueryCountSer+ ' AND '+fieldAPIName+ ' '+qOpt+' \''+fieldValueservice+'\'';
	  }
	}
	
	// Full the result based on the serach tab
	if(searchKeyWordSer !=null && searchKeyWordSer !=''){
	  searchKeyWordSer = '%'+searchKeyWordSer+'%';

	  String assetQuery2 =  ' AND ( CH_Status__c LIKE  \''+searchKeyWordSer+'\' ';
	  assetQuery2 = assetQuery2+ 'OR CH_NetworkElementAsset__r.Name LIKE \''+searchKeyWordSer+'\' ';
	  assetQuery2 = assetQuery2+ 'OR CH_NetworkElementAsset__r.CH_City__c LIKE \''+searchKeyWordSer+'\' ';
	  assetQuery2 = assetQuery2+ 'OR CH_NetworkElementAsset__r.CH_State_Province__c LIKE \''+searchKeyWordSer+'\' ';
	  assetQuery2 = assetQuery2+ 'OR CH_NetworkElementAsset__r.Address__r.Street LIKE \''+searchKeyWordSer+'\' ';
	  assetQuery2 = assetQuery2+ 'OR CH_NetworkElementAsset__r.Address__r.postalcode LIKE \''+searchKeyWordSer+'\' ';
	  assetQuery2 = assetQuery2+ 'OR CH_NetworkElementAsset__r.Address__r.Country LIKE \''+searchKeyWordSer+'\' ';
	  assetQuery2 = assetQuery2+ 'OR CH_NetworkElementAsset__r.CH_NetworkElementID__c LIKE \''+searchKeyWordSer+'\' ';
	  assetQuery2 = assetQuery2+ 'OR CH_NetworkElementAsset__r.Product2.Name LIKE \''+searchKeyWordSer+'\' ';
	  assetQuery2 = assetQuery2+ 'OR CH_NetworkElementAsset__r.CH_ProductRelease__r.Name LIKE \''+searchKeyWordSer+'\' ';
	  assetQuery2 = assetQuery2+ 'OR CH_NetworkElementAsset__r.Status LIKE \''+searchKeyWordSer+'\' ';
	  if(serviceCLType ==hwsServiceType){
		assetQuery2 = assetQuery2+ ' OR CH_NetworkElementAsset__r.CH_Solution__r.Name LIKE \''+searchKeyWordSer+'\' ';
		assetQuery2 = assetQuery2+ ' OR CH_NetworkElementAsset__r.CH_ProductVariant__r.Name LIKE \''+searchKeyWordSer+'\' ';
	  }
	  assetQuery2 = assetQuery2+ ' )';
	  
	  assetQuery = assetQuery+assetQuery2; 
	  assetQueryCountSer = assetQueryCountSer+ ' AND ( CH_Status__c LIKE  \''+searchKeyWordSer+'\' ';
	  assetQueryCountSer = assetQueryCountSer+ 'OR CH_NetworkElementAsset__r.Name LIKE \''+searchKeyWordSer+'\' ';
	  assetQueryCountSer = assetQueryCountSer+ 'OR CH_NetworkElementAsset__r.CH_City__c LIKE \''+searchKeyWordSer+'\' ';
	  assetQueryCountSer = assetQueryCountSer+ 'OR CH_NetworkElementAsset__r.CH_State_Province__c LIKE \''+searchKeyWordSer+'\' ';
	  assetQueryCountSer = assetQueryCountSer+ 'OR CH_NetworkElementAsset__r.Address__r.Street LIKE \''+searchKeyWordSer+'\' ';
	  assetQueryCountSer = assetQueryCountSer+ 'OR CH_NetworkElementAsset__r.Address__r.postalcode LIKE \''+searchKeyWordSer+'\' ';
	  assetQueryCountSer = assetQueryCountSer+ 'OR CH_NetworkElementAsset__r.Address__r.Country LIKE \''+searchKeyWordSer+'\' ';
	  assetQueryCountSer = assetQueryCountSer+ 'OR CH_NetworkElementAsset__r.CH_NetworkElementID__c LIKE \''+searchKeyWordSer+'\' ';
	  assetQueryCountSer = assetQueryCountSer+ 'OR CH_NetworkElementAsset__r.Product2.Name LIKE \''+searchKeyWordSer+'\' ';
	  assetQueryCountSer = assetQueryCountSer+ 'OR CH_NetworkElementAsset__r.CH_ProductRelease__r.Name LIKE \''+searchKeyWordSer+'\' ';
	  assetQueryCountSer = assetQueryCountSer+ 'OR CH_NetworkElementAsset__r.Status LIKE \''+searchKeyWordSer+'\' ';
	  if(serviceCLType ==hwsServiceType){
		assetQueryCountSer = assetQueryCountSer+ ' OR CH_NetworkElementAsset__r.CH_Solution__r.Name LIKE \''+searchKeyWordSer+'\' ';
		assetQueryCountSer = assetQueryCountSer+ ' OR CH_NetworkElementAsset__r.CH_ProductVariant__r.Name LIKE \''+searchKeyWordSer+'\' ';
		
	  }  
	  assetQueryCountSer = assetQueryCountSer+ ' )';
	}
	if(orderByName == 'CH_NetworkElementAsset__r.Address__r.CH_AddressDetails__c'){ 
	  orderByName ='CH_NetworkElementAsset__r.Address__r.Street';
	}
	
	if(sortDirection =='DESC'){ 
	  assetQuery = assetQuery+ ' ORDER BY '+orderByName+' '+ sortDirection+'  NULLS LAST LIMIT :recordToDisply OFFSET :offset';
	}else{
	  assetQuery = assetQuery+ ' ORDER BY '+orderByName+' '+ sortDirection+'  NULLS FIRST LIMIT :recordToDisply OFFSET :offset';
	}			 
	obj.networkEleAssests = database.query(assetQuery);
	obj.total = database.countQuery(assetQueryCountSer);
	obj = CH_NetworkElementAssetServicesHelper.assignPicklistValue(obj);	 
	return obj;
  }
  /****************************************
* Created By : Rajeshwari
* Description : Cancel/On close adds only Saved Filters, Filers which are not saved
will be removed
*****************************************/
  @AuraEnabled 
  public static  List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper> cancelSelectedFieldsForFilter( string jsonFieldFilterList){
	List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper> fieldList = (List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper>) JSON.deserialize(jsonFieldFilterList, List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper>.class);
	List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper> fieldNewList = new List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper>();
	if(fieldList == null || fieldList.isempty()){
	  fieldList = new List<CH_NetworkElementAssetWrapper.FilterSelectionWrapper>();
	}else{
	  for(CH_NetworkElementAssetWrapper.FilterSelectionWrapper fieldFilter:  fieldList){
		
		if(!fieldFilter.isNew){
	fieldNewList.add(fieldFilter);
		}
	  }
	}
   
	return fieldNewList;
  }
  /****************************************
* Created By : Rajeshwari
* Description : ADD Tab-  1) Fetch all the Linked Covered Network Element Asset matching CLI id and status is Inactive
2) Fecth all the Asstes where Account ID, ProductId, Country Name, Product Relase (Or null PR) Matches
3) If service Classification is "HWS Service", Then checks for Product Variant and Solution
*****************************************/
  @AuraEnabled
   public static CH_NetworkElementAssetWrapper.AssetPagerWrapper fetchAsset(Decimal pageNumber ,Integer recordToDisply, String contractLineItemId , String searchKeyWordSer,String jsonFiterSelected, String sortedBy , String sortedDirection, String serviceCLType) {
	 CH_NetworkElementAssetWrapper.AssetPagerWrapper obj = CH_NetworkElementAssetUtility.fetchAsset(pageNumber, recordToDisply, contractLineItemId, searchKeyWordSer, jsonFiterSelected, sortedBy, sortedDirection, serviceCLType);
	 obj =  CH_NetworkElementAssetServicesHelper.assignPicklistValueForasset(obj);
	 return obj;
   }
  /****************************************
* Created By : Rajeshwari
* Description :  ADd Tab, Link selected NE to  Cov NEA updating Active as Status 
Updates Inactive Status of Cov NEA to Active.
*****************************************/
  @AuraEnabled
  public static void addToCoveredNetworkElement (String contractLineItemId , List<string> selectedRowID){   
	CH_NetworkElementAssetUtility.addToCoveredNetworkElement(contractLineItemId, selectedRowID);
  }
  /****************************************
* Created By : Rajeshwari
* Description :  Unlink Tab, Update  selected Covered NE Status to InActive 
*****************************************/
  @AuraEnabled
  public static void unlinkToCoveredNetworkElement (String contractLineItemId , List<string> selectedRowID){
	CH_NetworkElementAssetUtility.unlinkToCoveredNetworkElement(contractLineItemId, selectedRowID);
  }
  /****************************************
* Created By : Rajeshwari
* Description : retrives Service Classification type
*****************************************/
  @AuraEnabled
  public static ContractLineItem getServiceClassification (String contractLineItemId ){
	ContractLineItem clType = CH_NetworkElementAssetServicesHelper.getServiceClassificationType(contractLineItemId);   
	return clType;
  }
  
  
}