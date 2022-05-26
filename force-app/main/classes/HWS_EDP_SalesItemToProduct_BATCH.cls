global class HWS_EDP_SalesItemToProduct_BATCH implements Database.Batchable<sObject>,Database.Stateful,Schedulable{
	
	/****************************************
	 * Name : Batch_EDPSalesItemsToProduct
	 * Author : TCS
	 * Description : This class is for updating product2 entries from Product Serviceable sales item staging object
	 *			   with Hardware Services related attributes
	 * User Stroy : 
	****************************************/

	//static variable initialization
	public List<NokiaCPQ_PMDI_Parameter__c> lparas = new List<NokiaCPQ_PMDI_Parameter__c>();
	public string sourcetype = 'HWS_Product_Serviceable_Sales_Item__c';
	private static boolean debug = true;
	private static String code = 'HWS_Part_Number__c';
	Set<String> nsnCodeSet= new Set<String>();
	
	/****************************************
		 * Name : execute
		 * Description : executes the batch class using schedulable instance
		 * Parameters: SchedulableContext
	 *****************************************/
	global void execute(SchedulableContext sc)	  
	{
		HWS_EDP_SalesItemToProduct_BATCH  batch= new HWS_EDP_SalesItemToProduct_BATCH();
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
														   NokiaCPQ_ObjNameSrc__c = 'HWS_Product_Serviceable_Sales_Item__c'
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
		 * Description : Retrieves the data from sales item staging object
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
		
		String sQuery = 'SELECT Id' + fields + ' FROM '+sourcetype+' WHERE HWS_Is_Processed__c = false and '+code+' != NULL';
				
		return database.getQueryLocator(sQuery);
	}

	 /****************************************
		 * Name : execute
		 * Description : Retrieves the data from product serviceable sales item staging object
		 * Parameters: Database.BatchableContext, List of Product sales item
		 * Returns : 
	 *****************************************/	
	global void execute(Database.BatchableContext bc, List<sObject> salesItems)
	{	 
			List<Product2> productList = new List<Product2>();
			Map<String,String> productMap = new Map<String, String>();
			List<String> codeList = new List<String>();
			List<Product2> duplicatecodeList = new List<Product2>();
		
			//Create a new list for interface logs to store callout failures
			List<interface_log__c> ilogs = new List<interface_log__c>();
			
		   /*
		   //Going forward Flagging the duplicate product code will be done HWS Utility class
		   List<Product2> prodListportfolio = [SELECT HWS_DoNotConsider__c,Id,Productcode FROM Product2 where  
										 RecordType.DeveloperName ='NokiaCPQ_Sales_Product' and Portfolio__c != null and NokiaCPQ_Item_Type__c='Hardware' AND HWS_DoNotConsider__c = false];
					
			for(Product2 product : prodListportfolio){
				   if(productMap.containsKey(product.ProductCode) && !product.HWS_DoNotConsider__c){  
					   product.HWS_DoNotConsider__c=true;
					   duplicatecodeList.add(product);
				   }
				   else{
					  productMap.put(product.ProductCode,product.Id);
			}
			   
			}
			
			if(duplicatecodeList.size() > 0)
					 update duplicatecodeList;
			
			productMap.clear();
			duplicatecodeList.clear();
			*/
		
		
			//prepare a list for storing all the salesitems code for this batch			
			for(sObject salesItem : salesItems)
			{
				codeList.add(String.valueOf(salesItem.get(code)));
				
			}			
									
		   //Getting Product Data for the sales items code needed for this batch and store it in a map
		   List<Product2> prodList = [SELECT Portfolio__c, HWS_DoNotConsider__c,Id,Productcode,HWS_NSNPartCode__c FROM Product2 where ProductCode in :codeList 
										and RecordType.DeveloperName ='NokiaCPQ_Sales_Product' and HWS_DoNotConsider__c=false  ];
					
		   for(Product2 product : prodList){
				productMap.put(product.ProductCode,product.Id);
		   }
			 
		 codeList.clear();
		
		productList = HWS_ProcessServiceableSalesItem_SVC.updateTarget(salesItems,productMap,'Product2',lparas);	
		List<Product2> productListtoUpdate = new List<Product2>();
		 
		for(Product2 prod : productList)
			if(!nsnCodeSet.contains(prod.HWS_NSNPartCode__c)){
					productListtoUpdate.add(prod);
					nsnCodeSet.add(prod.HWS_NSNPartCode__c);
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
			   //  update productListtoUpdate;   
				if(debug){
				system.debug('List Size is: '+results.size());
		}
				nsnCodeSet.clear();
				for(Integer index = 0, size = results.size(); index < size; index++) 
				{
					if(results[index].isSuccess()) 
					{							 
					   nsnCodeSet.add(productListtoUpdate[index].HWS_NSNPartCode__c+'-'+productListtoUpdate[index].HWS_Source__c);
					   system.debug('product3333'+productListtoUpdate[index].HWS_NSNPartCode__c+'-'+productListtoUpdate[index].HWS_Source__c);
					}
					else
					{
						Interface_log__c ilog = createErrorLog(results[index].getErrors(),productListtoUpdate[index],'update');
						if(ilog != null){
						ilogs.add(ilog);
			}
					}
				}   
				
		   for(HWS_Product_Serviceable_Sales_Item__c psi : [select HWS_Is_Processed__c from HWS_Product_Serviceable_Sales_Item__c where HWS_NSNCode__c  in:nsnCodeSet ]){
				   psi.HWS_Is_Processed__c=true;	
				   processedList.add(psi);
			   }
			  
			  Database.update(processedList,false);
			  Database.update(duplicatecodeList,false);
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
			nsnCodeSet.clear();
			duplicatecodeList.clear();
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
		 * Name : finish
		 * Description : finish method of batch class which calls price list item batch class to update 
		 *			  or create price list items from product sales items
		 * Parameters: Database.BatchableContext
		 * Returns : 
	 *****************************************/ 
	global void finish(Database.BatchableContext bc){
		   
		  Integer batchSize=Integer.valueOf(HWS_Settings__c.getValues('SSI Batch Size').SettingValue__c);
		  HWS_EDP_SVItoVersionItem_BATCH batch = new HWS_EDP_SVItoVersionItem_BATCH();
		  Database.executebatch(batch,batchSize);
		
	}
}