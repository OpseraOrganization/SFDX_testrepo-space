global without sharing class HWS_EDP_SVItoVersionItem_BATCH implements Database.Batchable<sObject>,Database.Stateful,Schedulable{
	/****************************************
	 * Name : HWS_EDP_SVItoVersionItem_BATCH
	 * Author : TCS
	 * Description : This class is for upserting Version Item entries from Product Serviceable Version item staging object
	 *	  with Hardware Services related attributes
	 * User Stroy : 
  ****************************************/

	//static variable initialization
	public List<NokiaCPQ_PMDI_Parameter__c> lparas = new List<NokiaCPQ_PMDI_Parameter__c>();
	public string sourceType = 'HWS_Product_Serviceable_Version_Item__c';
	private static String code = 'HWS_NSNCode__c';
	
	/****************************************
		 * Name : execute
		 * Description : executes the batch class using schedulable instance
		 * Parameters: SchedulableContext
	 *****************************************/
	global void execute(SchedulableContext sc)	  
	{
		HWS_EDP_SVItoVersionItem_BATCH  batch= new HWS_EDP_SVItoVersionItem_BATCH();
		Database.executebatch(batch,1);			
	} 
	
	/****************************************
		 * Name : getFields
		 * Description : Retrieves the fields used for processing staging entry in to version item
		 * Parameters: 
		 * Returns : fields for querying product serviceable version items
	 *****************************************/
	public String getFields()
	{
		String sfields = '';		
		// Get a list of all mapping values
		lparas = [SELECT Name, NokiaCPQ_ObjNameSrc__c, NokiaCPQ_ObjNameTrg__c, NokiaCPQ_ParaFrom__c, NokiaCPQ_ParaTo__c, NokiaCPQ_ParaType__c, NokiaCPQ_ReqMap__c 
				  FROM NokiaCPQ_PMDI_Parameter__c 
				 WHERE NokiaCPQ_Active__c=true AND 
				 NokiaCPQ_ParaType__c IN ('MAPPING RULE') AND
					 NokiaCPQ_ObjNameSrc__c = 'HWS_Product_Serviceable_Version_Item__c'
				 ORDER BY NokiaCPQ_ObjNameSrc__c];
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
		 * Description : Retrieves the data from serviceable version item staging object
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
		
		String squery = 'SELECT Id' + fields + ' FROM '+sourceType+' WHERE HWS_Is_Processed__c = false and '+code+' != NULL';
		
		return database.getQueryLocator(squery);
	}

   /****************************************
		 * Name : execute
		 * Description : Retrieves the data from product serviceable version item staging object
		 * Parameters: Database.BatchableContext, List of Product sales item
		 * Returns : 
	 *****************************************/	
	global void execute(Database.BatchableContext bc, List<sObject> serviceableVersionItems)
	{	 
			List<HWS_VersionItem__c> productList = new List<HWS_VersionItem__c>();
			//Create a new list for interface logs to store callout failures
	List<interface_log__c> ilogs = new List<interface_log__c>();
	 productList = HWS_ProcessServiceableVersionItem_SVC.updateTarget(serviceableVersionItems,lparas);	
	//clear all lists and map
			Type typSObject = Type.forName(sourceType);	 
			Type typLstSObject = Type.ForName('List<' + sourceType + '>');
			List<SObject> processedList = (List<SObject>)typLstSObject.NewInstance();
			try 
			{
	//Upserting all the serviceable version item staging table to version item table
	Schema.SObjectField extId = HWS_VersionItem__c.HWS_NSNCode__c; 
	Database.UpsertResult[] results = Database.upsert(productList,extId,false);
	for(Integer index = 0, size = results.size(); index < size; index++) 
	{
		String operationType = (results[index].isCreated() ? 'Insert' : 'Update');
	  if(results[index].isSuccess()) 
		{		
		//update processed flag for all staging items if product is proccessed		 
		sObject stagingItem = (sObject)typSObject.newInstance();
		stagingItem.put('HWS_Is_Processed__c',true);
		stagingItem.put(code,productList[index].HWS_NSNCode__c);
				if(!processedList.contains(stagingItem)){
		processedList.add(stagingItem); 
				}			
	}
		else
		{
				//If the staging object is not loaded to product, add an error log
				Interface_log__c ilog = createErrorLog(results[index].getErrors(),productList[index],'upsert');
				if(ilog != null){
		ilogs.add(ilog);
				}
		}
	}
		 //Update processed flag as true after processing the psi from staging table to product2
		 Schema.SObjectType objectType = Schema.getGlobalDescribe().get(sourceType);
		 Schema.SobjectField theField = objectType.getDescribe().fields.getMap().get(code);
		 
		 Database.upsert(processedList, theField); 
	Database.insert(ilogs,false);
			
	} 
	catch (DmlException e) 
	{ 
		System.debug('There was an error during the Product Upsert!'+e); 
	} 
			
			//Clear processed list after upating its value and product list once its processed
			processedList.clear();
			productList.clear(); 
	ilogs.clear();
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
			ilog.Interface_Type__c = 'EDP Serviceable Version item to Version item';
			ilog.Message_Type__c = 'Inbound';
			ilog.Operation_Type__c = operationType;
			ilog.Interface_Request_Sent__c = 'Product Name: '+product.HWS_NSNCode__c;
			ilog.Status__c = 'Failure';
			ilog.Name = 'SSI '+operationType+' failed with '+product.HWS_NSNCode__c;
	return ilog;
		
	}
	
	
	/****************************************
		 * Name : finish
		 * Description : finish method of batch class which calls price list item batch class to update 
		 *		 or create price list items from product sales items
		 * Parameters: Database.BatchableContext
		 * Returns : 
	 *****************************************/ 
	global void finish(Database.BatchableContext bc)
	{
			Integer batchSize=Integer.valueOf(HWS_Settings__c.getValues('PVI Batch Size').SettingValue__c);
			HWS_EDP_PVItoVersionItem_BATCH batch = new HWS_EDP_PVItoVersionItem_BATCH();
			Database.executebatch(batch,batchSize);
	}


}