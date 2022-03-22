/****************************************
	 * Name : EDPProductRelations
	 * Author : Accenture
	 * Description : This class is for loading data from edp to product relation and create interface logs
	 * ReqNo : 4732
	****************************************/
public class EDPProductRelations 
{	   
	  //  readProductRelData('https://edpqaapi.azurewebsites.net/api/ProductRelations/EDP.ConfigurationItemRelation()?$filter=RelationType%20eq%20\'EBOM\'%20or%20RelationType%20eq%20\'EBOM%20History\'&$top=10');		
	
	Public static string status;
	Public static integer statusCode;
	Public static string path_pr;
	public static DateTime MaxTimestamp;
	public static Integer successRecordCount = 0;
	
	/****************************************
		 * Name : uploadToStagingTable
		 * Description : load data to Product relations
		 * Parameters: HttResponse, URL
		 * Returns: List of product relation items
	 *****************************************/
	public static void uploadToStagingTable(HttpResponse response, String path)
	{		
		System.debug('Into the fn UploadToStagingTable');
		status = response.getStatus();
		statusCode = response.getStatuscode(); 
		path_pr = path;
		String[] PR_del_list = new String[]{};
		String[] PR_prd_list = new String[]{};
		List<Product_Relation__c> PR_List = new List<Product_Relation__c>();
		list<Product_Relation__c> productRelList = new List<Product_Relation__c>();
	   
		//Deserializing response and passing it to a list
		List<EDPPRFields> productArray = (List<EDPPRFields>)System.JSON.deserialize(
			response.getBody().substring(response.getBody().indexof('['),response.getBody().lastindexof(']')+1), 
						List<EDPPRFields>.class);
		//System.debug('ProductRelArray: '+productArray);
		System.debug('ProductRelArraySize: '+productArray.size());
		response = null; 
		
		Set<String> prod_code_set = new Set<String>();
		
		//MaxTimestamp = datetime.valueOf(productArray[0].EDP_LastModifiedDate);
	 
		String data = productArray[0].EDP_LastModifiedDate;
	  MaxTimestamp = (DateTime)JSON.deserialize('"' + data + '"', DateTime.class);
		System.debug('1st Time stamp is :'+MaxTimestamp);
			for(EDPPRFields edp :  productArray)
		{
			if(prod_code_set.add(edp.ChildName+'_'+edp.ParentID))
			{
			if (edp.EDP_ActiveStatus == True) {
				Product_Relation__c productRel = new Product_Relation__c();
			   
				productRel.Child_ID__c		= edp.ChildID;
				productRel.Child_Name__c	= edp.ChildName;
				productRel.Child_Revision__c 		= edp.ChildRevision;
				productRel.Child_Type__c	= edp.ChildType;
				productRel.Parent_ID__c	= edp.ParentID;	
				productRel.Parent_Name__c	= edp.ParentName;
				productRel.Parent_Revision__c 		= edp.ParentRevision;
				productRel.Parent_Type__c	= edp.ParentType;
				productRel.RelationType__c	= edp.RelationType; 
				productRel.Combined_key__c	= edp.ChildName+'_'+edp.ParentID;
				productRel.EDPActiveStatus__c		= edp.EDP_ActiveStatus;
				productRel.EDP_LastModifiedDate__c 	= edp.EDP_LastModifiedDate;
				
				PR_List.add(productRel);
				PR_prd_list.add(edp.ParentID);
				PR_prd_list.add(edp.ChildName);
			} else {
				String PR_del = edp.ChildName+'_'+edp.ParentID;
				PR_del_list.add(PR_del);
				
			}
		}
			DateTime dt= (DateTime)JSON.deserialize('"' + edp.EDP_LastModifiedDate + '"', DateTime.class);
			System.debug('dt is:'+dt);
			if(dt>MaxTimestamp)
			{ 
				MaxTimestamp= dt;
				System.debug('Now the max time stamp is:'+MaxTimestamp);
			}
	}
  
		//System.debug(PR_del_list);
	system.debug('prods from edp: '+PR_prd_list);
		//clear product array after loading it to PI_List
		productArray.clear();
		//Collect all the product ID's of parent and child records
		//List<product2> prod_id_list = [select ID,ProductCode from product2 where ProductCode in :PR_prd_list];
		//system.debug('prod Id list: '+prod_id_list);
		map<string,Id> m_prd_id = new map<string,Id>();
		for(product2 prd :[select ID,ProductCode from product2 where ProductCode in :PR_prd_list])
		{
		   m_prd_id.put(prd.ProductCode,prd.id);
		}
		
		for (Product_Relation__c pr :PR_List){
			pr.Child_Product__c = m_prd_id.get(pr.Child_Name__c);
			pr.Parent_Product__c = m_prd_id.get(pr.Parent_ID__c);
		}
		system.debug('prd_list :'+PR_List);
		//Insert Product Relations into staging table
		List<Database.UpsertResult> results_PR = new List<Database.UpsertResult>();
		//Delete Product Relations from staging table
		
		List<Product_Relation__c> PR_del_id_list = [select Id,Child_Name__c,EDPActiveStatus__c,
													Child_ID__c,Parent_Name__c,Parent_ID__c,
													RelationType__c,Combined_key__c
													from Product_Relation__c where Combined_key__c in :PR_del_list];
		List<Database.DeleteResult> result_del_PR = new List<Database.DeleteResult>();
		try
		{
			 results_PR = Database.upsert(PR_List, Product_Relation__c.Fields.Combined_key__c, false);
			 result_del_PR = Database.delete(PR_del_id_list, false);
			 System.debug('Data loaded to Product Relations staging table :'+ results_PR);
			 System.debug('Product Relations deleted from staging table :'+ result_del_PR);
		}
		catch(Exception e)
		{
			System.debug('Exception occured while loading Product Relations data to staging table. Exception: '+e);
		}
		// Send the insert details to interface log 
		upsertinterfacelog(results_PR,PR_List);
		delinterfacelog(result_del_PR,PR_del_id_list);
	}
	
	/****************************************
		 * Name : upsertinterfacelog
		 * Description : create interface logs for poduct relations insert and update
		 * Parameters: upsert results of relations, List of relations data
		 * Returns: 
	 *****************************************/
	public static void upsertinterfacelog(List<Database.UpsertResult> results, List<Product_Relation__c> PR_List)
	{
		try{
		// Method to create interface logs
		
		List<interface_log__c> ilogs = new List<interface_log__c>();
		interface_log__c ilog_callout = new interface_log__c();
		ilog_callout.Interface_Type__c = 'EDP Product Relations Stage';
		ilog_callout.Message_Type__c = 'Inbound';
		ilog_callout.Operation_Type__c = 'Insert';
		
		 // Callout Interface Logs//
		 if(statusCode == 200)
		 {
			ilog_callout.Interface_Request_Sent__c 	= 'Request URL: '+path_pr+ '\n'+
													 'Response: '+status+'\n'+
													  'Response Code'+statusCode+'\n';
			 
			ilog_callout.Name				= 'Product Relations Rest Callout success';
			 ilog_callout.Status__c		= 'Success';
			 ilog_callout.Comment__c	= 'Success';
		 } 
		
		  ilogs.add(ilog_callout);
		
		//Product Relations staging Interface logs//
		
		for(Integer index = 0, size = results.size(); index < size; index++) 
			{
				Interface_log__c ilog_pr = new Interface_log__c();
				String operationType = (results[index].isCreated() ? 'Insert' : 'Update');
				ilog_pr.Interface_Type__c = 'EDP Product Relations Stage';
				ilog_pr.Message_Type__c = 'Inbound';
				if(!results[index].isSuccess()) 
				{ 
					////Product Relations Error Interface Logs///
					for (Database.Error err : results[index].getErrors()){
						ilog_pr.comment__c = 'Fields: '+err.getFields()+'Message: '+err.getMessage()+
												'Status Code: '+err.getStatusCode();
					}										
					ilog_pr.Operation_Type__c = operationType; 
					ilog_pr.Status__c = 'Failure';
					ilog_pr.Interface_Request_Sent__c = 'Request URL: '+path_pr+ '\n'+
														'ParentCode: '+PR_List[index].Parent_ID__c +'\n'+
														'ParentName: '+PR_List[index].Parent_Name__c +'\n'+
														'Child Name: '+PR_List[index].Child_Name__c +'\n'+
														'Child ID: '+PR_List[index].Child_ID__c +'\n'+
														'EDP ActiveStatus: '+PR_List[index].EDPActiveStatus__c+'\n'+
					'Relation Type : '+PR_List[index].RelationType__c ;
					ilog_pr.Name = 'Relation '+operationType+' with Parent ID: '+PR_List[index].Parent_ID__c + ' ,Child ID:' + PR_List[index].Child_Name__c ;
		if(ilog_pr.Name.length() > 80)
						ilog_pr.Name = 'Relation '+operationType+' with key: '+PR_List[index].Combined_key__c;
					ilogs.add(ilog_pr);
					//System.debug('Interface logs failure: '+ilog_pr+'items'); 
				}
				else
				{ 
		////Product Relation Success Interface Logs///				  
					ilog_pr.comment__c = 'Success';
					ilog_pr.Operation_Type__c = operationType; 
					ilog_pr.Status__c = 'Success';
					ilog_pr.Interface_Request_Sent__c = 'Request URL: '+path_pr+ '\n'+
					'ID: '+results[index].getId() +'\n'+
														'ParentCode: '+PR_List[index].Parent_ID__c +'\n'+
														'ParentName: '+PR_List[index].Parent_Name__c +'\n'+
														'Child Name: '+PR_List[index].Child_Name__c +'\n'+
														'Child ID: '+PR_List[index].Child_ID__c +'\n'+
														'EDP ActiveStatus: '+PR_List[index].EDPActiveStatus__c+'\n'+
					'Relation Type : '+PR_List[index].RelationType__c ;
					ilog_pr.Name = 'Relation '+operationType+' with Parent ID: '+PR_List[index].Parent_ID__c + ' ,Child ID:' + PR_List[index].Child_Name__c ;
					if(ilog_pr.Name.length() > 80)
						ilog_pr.Name = 'Relation '+operationType+' with key: '+PR_List[index].Combined_key__c;
					ilogs.add(ilog_pr);
					successRecordCount++;
					//System.debug('Interface logs success: '+ilog_pr+'items');
				 }
			}

			List<Database.SaveResult> result_ilog = Database.Insert(Ilogs,false);			 
			//System.debug('Interface logs created for '+Ilogs.size()+'items');
			//System.debug('Interface logs created : '+result_ilog+'items');
			//Insert Ilogs;
			Ilogs.clear(); 
			}
	
			catch(Exception e){
				System.debug('Exception occured while loading Product Relations interface log. Exception: '+e);
			}
	}
	
	/****************************************
		 * Name : delinterfacelog
		 * Description : create interface logs for product relations deletion
		 * Parameters: List of delete result, List of product relation
		 * Returns: 
	 *****************************************/
	public static void delinterfacelog(List<Database.DeleteResult> result_del, List<Product_Relation__c> PR_List)
	{
		try{
		// Method to create interface logs for Product Relation Deletions
		
			List<interface_log__c> Ilogs = new List<interface_log__c>();
		  	for(Integer index = 0, size = result_del.size(); index < size; index++)
			{
				Interface_log__c ilog_pr = new Interface_log__c();
	ilog_pr.Interface_Type__c = 'EDP Product Relations Stage';
				ilog_pr.Message_Type__c = 'Inbound';
				ilog_pr.Operation_Type__c = 'Delete';
				
				if(!result_del[index].isSuccess()) 
				{ 
					////Product Relations Error Interface Logs///
					for (Database.Error err : result_del[index].getErrors())
		{
						ilog_pr.comment__c = 'Fields: '+err.getFields()+'Message: '+err.getMessage()+
												'Status Code: '+err.getStatusCode();
					}
					
					ilog_pr.Status__c = 'Failure';
					ilog_pr.Interface_Request_Sent__c = 'Request URL: '+path_pr+ '\n'+
					'ID: '+result_del[index].getId() +'\n'+
														'ParentCode: '+PR_List[index].Parent_ID__c +'\n'+
														'ParentName: '+PR_List[index].Parent_Name__c +'\n'+
														'Child Name: '+PR_List[index].Child_Name__c +'\n'+
														'Child ID: '+PR_List[index].Child_ID__c +'\n'+
														'EDP ActiveStatus: '+PR_List[index].EDPActiveStatus__c+'\n'+
					'Relation Type : '+PR_List[index].RelationType__c ;
					ilog_pr.Name = 'Relation deletion with Parent ID: '+PR_List[index].Parent_ID__c + ' ,Child ID:' + PR_List[index].Child_Name__c ;
		ilogs.add(ilog_pr);
				}
	else
	{
		ilog_pr.Status__c = 'Success';
					ilog_pr.comment__c = 'Success';
					ilog_pr.Interface_Request_Sent__c = 'Request URL: '+path_pr+ '\n'+
					'ID: '+result_del[index].getId() +'\n'+
														'ParentCode: '+PR_List[index].Parent_ID__c +'\n'+
														'ParentName: '+PR_List[index].Parent_Name__c +'\n'+
														'Child Name: '+PR_List[index].Child_Name__c +'\n'+
														'Child ID: '+PR_List[index].Child_ID__c +'\n'+
														'EDP ActiveStatus: '+PR_List[index].EDPActiveStatus__c+'\n'+
					'Relation Type : '+PR_List[index].RelationType__c ;
					ilog_pr.Name = 'Relation deletion with Parent ID: '+PR_List[index].Parent_ID__c + ' ,Child ID:' + PR_List[index].Child_Name__c ;
				 	if(ilog_pr.Name.length() > 80)
						ilog_pr.Name = 'Relation deletion with key: '+PR_List[index].Combined_key__c;
					Ilogs.add(ilog_pr);
	}
			
			}
			
			List<Database.SaveResult> result_ilog = Database.Insert(Ilogs,false);		  
		   // System.debug('Interface logs created for Deletion '+Ilogs.size()+'items');
			//System.debug('Interface logs deletion : '+result_ilog+'items');
			Ilogs.clear();
		}
		catch(Exception e){
				System.debug('Exception occured while loading PI interface log. Exception: '+e);
			}
	}
	
	public class EDPPRFields {
	
	 	public String RelationFor;
		public String RelationType;
		public String ParentID;
		public String ParentName;
		public String ParentRevision;
		public String ParentType;
		public String ChildID;
		public String ChildName;
		public String ChildRevision;
		public String ChildType;	 
		public String EDP_LastModifiedDate;
		public Boolean EDP_ActiveStatus;
	 
	}
	
}