global without sharing class HWS_EDP_PVItoVersionItem_BATCH implements Database.Batchable<sObject>,Database.Stateful,Schedulable{
	
	/****************************************
	 * Name : Batch_ProductVersionToVersionitem
	 * Author : TCS
	 * Description : This class is for updating Version item entries from Product version staging object
	 *	  with standard attributes
	 * User Stroy : 
****************************************/

   //static variable initialization
	public List<NokiaCPQ_PMDI_Parameter__c> lparas = new List<NokiaCPQ_PMDI_Parameter__c>();
	public string sourcetype = 'HWS_Product_Version_Item__c';
	private static boolean debug = false;
	private static String code = 'HWS_NSNCode__c';
	Set<String> nsnCodeSET= new Set<String>();
	
	/****************************************
		 * Name : execute
		 * Description : executes the batch class using schedulable instance
		 * Parameters: SchedulableContext
	 *****************************************/
	global void execute(SchedulableContext sc)	  
	{
		HWS_EDP_SalesItemToProduct_BATCH  batch = new HWS_EDP_SalesItemToProduct_BATCH();
		Database.executebatch(batch,1);			
	} 
	
	/****************************************
		 * Name : getFields
		 * Description : Retrieves the fields used for processing staging entry in to product2
		 * Parameters: 
		 * Returns : fields for querying product serviceable sales items
	 *****************************************/
	public String getFields()
	{
		String sfields = '';		
		// Get a list of all mapping values
		lparas = [SELECT Name, NokiaCPQ_ObjNameSrc__c, NokiaCPQ_ObjNameTrg__c, NokiaCPQ_ParaFrom__c, NokiaCPQ_ParaTo__c, NokiaCPQ_ParaType__c, NokiaCPQ_ReqMap__c 
	  FROM NokiaCPQ_PMDI_Parameter__c 
	 WHERE NokiaCPQ_Active__c=true AND 
	 NokiaCPQ_ParaType__c IN ('MAPPING RULE') AND
	
   NokiaCPQ_ObjNameSrc__c = 'HWS_Product_Version_Item__c' AND NokiaCPQ_ObjNameTrg__c = 'HWS_VersionItem__c'
	 ORDER BY NokiaCPQ_ObjNameSrc__c];
		if(debug){
			System.debug('Parameters found:' + lparas);
		}
		// for all entries
		for (NokiaCPQ_PMDI_Parameter__c para : lparas)
		{
			if(para.NokiaCPQ_ParaType__c == 'MAPPING RULE')
			{
	if(sfields == '')
	{
		sfields = para.NokiaCPQ_ParaFrom__c;
	}
	else
	{
		if(!(sfields.contains(para.NokiaCPQ_ParaFrom__c))){
			sfields = sfields + ', ' + para.NokiaCPQ_ParaFrom__c;	
		}
	}
			}
		}
		return sfields;
	}
	
	/****************************************
		 * Name : start
		 * Description : Retrieves the data from product version item staging object
		 * Parameters: Database.BatchableContext
		 * Returns : Database.QueryLocator
	 *****************************************/
global Database.QueryLocator start(Database.BatchableContext bc)
	{
	  String sfields = getFields();
		String fields = '';
		if(sfields != null || sfields!= '')
		{
			fields = ', ' + sfields;
		}
		
		String squery = 'SELECT Id' + fields + ' FROM '+sourcetype+' WHERE HWS_Is_Processed__c = false and '+code+' != NULL';
		return database.getQueryLocator(squery);
	}

/****************************************
		 * Name : execute
		 * Description : Retrieves the data from product serviceable sales item staging object
		 * Parameters: Database.BatchableContext, List of Product sales item
		 * Returns : 
	 *****************************************/	
	global void execute(Database.BatchableContext bc, List<sObject> versionitems)
	{	 
			List<HWS_VersionItem__c> productList = new List<HWS_VersionItem__c>();
			Map<String, List<String>> productMap = new Map<String, List<String>>();
	 List<String> codeList = new List<String>();
		
		//Create a new list for interface logs to store callout failures
		List<interface_log__c> ilogs = new List<interface_log__c>();
			
			//prepare a list for storing all the salesitems code for this batch			
			for(sObject versionItem : versionitems)
			{
	codeList.add(String.valueOf(versionItem.get(code)));
	
			}			
		
			//Getting Product Data for the sales items code needed for this batch and store it in a map
			for(List<HWS_VersionItem__c> prodList : [SELECT Id,HWS_NSNCode__c 
	FROM HWS_VersionItem__c 
	where HWS_NSNCode__c in :codeList 
			and HWS_Source__c ='Puma1'
			])
			{  
	for(HWS_VersionItem__c product : prodList){
		if(productMap.containsKey(product.HWS_NSNCode__c)){
			productMap.get(product.HWS_NSNCode__c).add(product.Id);
		}
		else{
			productMap.put(product.HWS_NSNCode__c, new List<String>{product.Id});
		}
	}
	 } 
	 codeList.clear();
		
			productList = HWS_EDP_PVItoVersionItem_SVC.updateTarget(versionitems,productMap,lparas);	
			
			List<HWS_VersionItem__c> productListtoUpdate = new List<HWS_VersionItem__c>();
			for(HWS_VersionItem__c prod : productList)
			if(!nsnCodeSET.contains(prod.HWS_NSNCode__c))
	{
		productListtoUpdate.add(prod);
		nsnCodeSET.add(prod.HWS_NSNCode__c);
	}
		if(debug)
		{
			System.debug('Product list size: '+productListtoUpdate);
		}
		//clear all lists and map
			productMap.clear();
		
			Type typSObject = Type.forName(sourcetype);	 
			Type typLstSObject = Type.ForName('List<' + sourcetype + '>');
			
			List<SObject> processedList = (List<SObject>)typLstSObject.NewInstance();
			try 
			{
	//Update all the staging table items to product table
	Database.SaveResult[] results = Database.update(productListtoUpdate,false);
	
	if(debug){
		system.debug('List Size is: '+results.size());
	}
	nsnCodeSET.clear();
	for(Integer index = 0, size = results.size(); index < size; index++) 
	{
		if(results[index].isSuccess()) 
		{		
		nsnCodeSET.add(productListtoUpdate[index].HWS_NSNCode__c);
		}
	  else
		{
			Interface_log__c ilog = createErrorLog(results[index].getErrors(),productListtoUpdate[index],'update');
			if(ilog != null){
	ilogs.add(ilog);
			}
		}
	} 
	
	  for(HWS_Product_Version_Item__c pvi : [select HWS_Is_Processed__c  from HWS_Product_Version_Item__c where HWS_NSNCode__c  in:nsnCodeSET ])
	  {
	pvi.HWS_Is_Processed__c =true;	
	processedList.add(pvi);
	  }
	  Database.update(processedList,false);
	  Database.insert(ilogs,false);
	  } 
	 catch (DmlException e) 
	{ 
		System.debug('There was an error during the Product Upsert!'+e); 
	} 
			
			//Clear processed list after upating its value and product list once its processed
			processedList.clear();
			productListtoUpdate.clear(); 
			productList.clear(); 
			ilogs.clear();
			nsnCodeSET.clear();
	}
	
	/****************************************
		 * Name : createErrorLog
		 * Description : creates an error log for errors occurred during product load
		 * Parameters: Database.Error[], Product record, Operation type
		 * Returns : Interfacelog
	 *****************************************/  
	public Interface_log__c createErrorLog(Database.Error[] errors, HWS_VersionItem__c product, String operationType)
	{
		Interface_log__c ilog = new Interface_log__c();
		for (Database.Error err : errors)
	{
	ilog.comment__c = 'Fields: '+err.getFields()+' Message: '+err.getMessage()+
	' Status Code: '+err.getStatusCode();
	}
			ilog.Interface_Type__c = 'EDP PVI to VI';
			ilog.Message_Type__c = 'Inbound';
			ilog.Operation_Type__c = operationType;
			ilog.Interface_Request_Sent__c = 'Version Item  Name: '+product.Name+' HWS_NSNCode__c: '+product.HWS_NSNCode__c;
			ilog.Status__c = 'Failure';
			ilog.Name = 'VI '+operationType+' failed with '+product.HWS_NSNCode__c;
		return ilog;
	}
	 
	
	/****************************************
		 * Name : finish
		 * Description : finish method of batch class which calls price list item batch class to update 
		 * or create price list items from product sales items
		 * Parameters: Database.BatchableContext
		 * Returns : 
	 *****************************************/ 
	global void finish(Database.BatchableContext bc)
	{
			Integer batchSize=Integer.valueOf(HWS_Settings__c.getValues('SSI_SVI Batch Size').SettingValue__c);
			HWS_EDP_BuildRelation_SSI_SVI batch = new HWS_EDP_BuildRelation_SSI_SVI();
			Database.executebatch(batch,batchSize);
		
	}


}