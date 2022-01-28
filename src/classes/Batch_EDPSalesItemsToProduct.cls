/****************************************
	 * Name : Batch_EDPSalesItemsToProduct
	 * Author : Accenture
	 * Description : This class is for creating product entries from Product sales item staging object
	 * ReqNo : 4560
	****************************************/
global class Batch_EDPSalesItemsToProduct implements Database.Batchable<sObject>,Database.Stateful,Schedulable 
{
	//static variable initialization
	public List<NokiaCPQ_PMDI_Parameter__c> l_paras = new List<NokiaCPQ_PMDI_Parameter__c>();
	public List<NokiaCPQ_PMDI_Parameter__c> l_trans = new List<NokiaCPQ_PMDI_Parameter__c>();
	public Map<Object, String> paraValueMap = new Map<Object, String>();
	public string source_type = 'Product_Sales_Item__c';
	private static boolean debug = false;
	private static String code = 'NSNCode__c';
	
	/****************************************
		 * Name : execute
		 * Description : executes the batch class using schedulable instance
		 * Parameters: SchedulableContext
	 *****************************************/
	global void execute(SchedulableContext SC)	  
	{
		Batch_EDPSalesItemsToProduct  batch= new Batch_EDPSalesItemsToProduct();
		Database.executebatch(batch,1);			
	} 
	
	/****************************************
		 * Name : getFields
		 * Description : Retrieves the fields used for processing staging entry in to product2
		 * Parameters: 
		 * Returns : fields for querying sales items
	 *****************************************/
	public String getFields()
	{
		String s_fields = '';		
		// Get a list of all mapping values
		l_paras = [SELECT Name, NokiaCPQ_ObjNameSrc__c, NokiaCPQ_ObjNameTrg__c, NokiaCPQ_ParaFrom__c, NokiaCPQ_ParaTo__c, NokiaCPQ_ParaType__c, NokiaCPQ_ReqMap__c 
													  FROM NokiaCPQ_PMDI_Parameter__c 
													 WHERE NokiaCPQ_Active__c=true AND 
														   NokiaCPQ_ParaType__c IN ('MAPPING RULE','DIRECT_VALUE') AND
														NokiaCPQ_ObjNameSrc__c = 'Product_Sales_Item__c'
													 ORDER BY NokiaCPQ_ObjNameSrc__c];
		if(debug)
		System.debug('Parameters found:' + l_paras);
		
		// Get a list of all transformation rules
		l_trans = [SELECT NokiaCPQ_ParaFrom__c, NokiaCPQ_ParaTo__c
													  	FROM NokiaCPQ_PMDI_Parameter__c 
													 	WHERE NokiaCPQ_Active__c=true AND 
														   NokiaCPQ_ParaType__c='MAPPING_VALUE'
														];
		
		// Get all mapping values in a map
		for(NokiaCPQ_PMDI_Parameter__c param : l_trans)
		{
			paraValueMap.put(param.NokiaCPQ_ParaFrom__c,param.NokiaCPQ_ParaTo__c); 
		}
		
		// for all entries
		for (NokiaCPQ_PMDI_Parameter__c para : l_paras)
		{
			if(para.NokiaCPQ_ParaType__c != 'DIRECT_VALUE')
			{
				if(s_fields == '')
				{
					s_fields = para.NokiaCPQ_ParaFrom__c;
				}
				else
				{
					if(!(s_fields.contains(para.NokiaCPQ_ParaFrom__c)))
						s_fields = s_fields + ', ' + para.NokiaCPQ_ParaFrom__c;	
				}
			}
		}
		return s_fields;
	}
	
	/****************************************
		 * Name : start
		 * Description : Retrieves the data from sales item staging object
		 * Parameters: Database.BatchableContext
		 * Returns : Database.QueryLocator
	 *****************************************/
	global Database.QueryLocator start(Database.BatchableContext BC)
	{
	 	String s_fields = getFields();
		String fields = '';
		if(s_fields != null || s_fields!= '')
		{
			fields = ', ' + s_fields;
		}
		
		String s_query = 'SELECT Id' + fields + ' FROM '+source_type+' WHERE Is_Processed__c = false and '+code+' != NULL';
	
		return database.getQueryLocator(s_query);
	}

	 /****************************************
		 * Name : execute
		 * Description : Retrieves the data from sales item staging object
		 * Parameters: Database.BatchableContext, List of Product sales item
		 * Returns : 
	 *****************************************/	
	global void execute(Database.BatchableContext BC, List<sObject> salesItems)
	{	 
			List<Product2> productList = new List<Product2>();
			Map<String, List<String>> productMap = new Map<String, List<String>>();
			List<String> codeList = new List<String>();
		
			//Create a new list for interface logs to store callout failures
			List<interface_log__c> ilogs = new List<interface_log__c>();
			
			//prepare a list for storing all the salesitems code for this batch			
			for(sObject salesItem : salesItems)
			{
				codeList.add(String.valueOf(salesItem.get(code)));
				
			}			
								 
			//Getting Product Data for the sales items code needed for this batch and store it in a map
			for(List<Product2> ProdList : [SELECT Id,Productcode,Portfolio__c
										   FROM Product2 
										   where ProductCode in :codeList 
										  and RecordType.DeveloperName ='NokiaCPQ_Sales_Product'
										  ])
			{ 	 
				for(Product2 product : ProdList){
					if(productMap.containsKey(product.ProductCode))
			productMap.get(product.ProductCode).add(product.Id+','+product.Portfolio__c);
		else
						productMap.put(product.ProductCode, new List<String>{product.Id+','+product.Portfolio__c});
				}
			} 
			codeList.clear();
		
			productList = EDP_ProcessPOC.updateTarget(salesItems,productMap,'Product2',l_paras,paraValueMap);	
			 
			if(debug)
			{
			System.debug('Product list size: '+productList);
			}
			//clear all lists and map
			productMap.clear();
		
			Type typSObject = Type.forName(source_type);	 
			Type typLstSObject = Type.ForName('List<' + source_type + '>');
			
			List<SObject> processedList = (List<SObject>)typLstSObject.NewInstance();
			try 
			{
				//Upsert all the staging table items to product table
				Database.UpsertResult[] results = Database.upsert(productList,false);
				
				if(debug)
				system.debug('List Size is: '+results.size());
				
				for(Integer index = 0, size = results.size(); index < size; index++) 
				{
					String operationType = (results[index].isCreated() ? 'Insert' : 'Update');
					if(results[index].isSuccess()) 
					{							 
								//update processed flag for all staging items if product is proccessed						   
								sObject stagingItem = (sObject)typSObject.newInstance();
								stagingItem.put('Is_Processed__c',true);
								stagingItem.put(code,productList[index].ProductCode);
								if(!processedList.contains(stagingItem))
								processedList.add(stagingItem);  
								Interface_log__c ilog = createSuccessLog(productList[index],operationType);
								if(ilog != null)
								ilogs.add(ilog); 
																						 
					}
				  	else
					{
							//If the staging object is not loaded to product, add an error log
							if(debug)
							System.debug('Error upserting product: '+results[index].getErrors());
							//System.debug('For product: '+ProductList[index]);
							Interface_log__c ilog = createErrorLog(results[index].getErrors(),productList[index],operationType);
							if(ilog != null)
							ilogs.add(ilog);
					}
				}
				
				Database.insert(ilogs,false);
				
						 //Update processed flag as true after processing the psi from staging table to product2
						Schema.SObjectType objectType = Schema.getGlobalDescribe().get(source_type);
						Schema.SobjectField theField = objectType.getDescribe().fields.getMap().get(code);
						
						database.upsert(processedList, theField);									
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
	public Interface_log__c createErrorLog(Database.Error[] errors, Product2 product, String operationType)
	{
			Interface_log__c ilog = new Interface_log__c();
			for (Database.Error err : errors)
			 {
				ilog.comment__c = 'Fields: '+err.getFields()+' Message: '+err.getMessage()+
													' Status Code: '+err.getStatusCode();
			 }
			ilog.Interface_Type__c = 'EDP SI to Product2';
			ilog.Message_Type__c = 'Inbound';
			ilog.Operation_Type__c = operationType;
			ilog.Interface_Request_Sent__c = 'Product Name: '+product.Name+' Status: '+product.NokiaCPQ_State__c+
								' Item type: '+product.PMD_Product_Item_Type__c+' APXT_EXT_ID: '+product.APTS_Ext_ID__c;
			ilog.Status__c = 'Failure';
			ilog.Name = 'SI Product '+operationType+' failed with '+product.productCode;
			return ilog;
	}
	
	/****************************************
		 * Name : createSuccessLog
		 * Description : creates an success log for errors occurred during product load
		 * Parameters: Product record, Operation type
		 * Returns : Interfacelog
	 *****************************************/ 
	public Interface_log__c createSuccessLog(Product2 product, String operationType)
	{
			Interface_log__c ilog = new Interface_log__c();
			ilog.comment__c = 'Success';
			ilog.Interface_Type__c = 'EDP SI to Product2';
			ilog.Message_Type__c = 'Inbound';
			ilog.Operation_Type__c = operationType;
			ilog.Interface_Request_Sent__c = 'Product Name: '+product.Name+' Status: '+product.NokiaCPQ_State__c+
								' Item type: '+product.PMD_Product_Item_Type__c+' APXT_EXT_ID: '+product.APTS_Ext_ID__c;
			ilog.Status__c = 'Success';
			ilog.Name = 'SI Product '+operationType+' success with '+product.productCode;
			return ilog;
	}
	
	/****************************************
		 * Name : finish
		 * Description : finish method of batch class which calls price list item batch class to update 
		 *		or create price list items from product sales items
		 * Parameters: Database.BatchableContext
		 * Returns : 
	 *****************************************/ 
	global void finish(Database.BatchableContext BC)
	{
		   
			Batch_EDPPriceListItem batch = new Batch_EDPPriceListItem();
			Database.executebatch(batch,2000);
	}
}