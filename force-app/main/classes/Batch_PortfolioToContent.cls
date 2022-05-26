global class Batch_PortfolioToContent implements Database.Batchable<sObject>,Database.Stateful,Schedulable {
	public String query;
	Public List<String>SplitValues=new List<String>();
	private static String bsize= Label.PMDI_PI_To_Content_Batch_Size;
	Public static integer batchSize = Integer.valueOf(bsize);
	
	 global void execute(SchedulableContext SC)	  
	{
	   Batch_PortfolioToContent  batch= new Batch_PortfolioToContent();
		Database.executebatch(batch,batchSize);			
	} 
	

	global Database.QueryLocator start(Database.BatchableContext bc)
	{
		query= 'SELECT AlternateCode__c,NSNLegacyCode__c,DataUsage__c,Name From Product_Portfolio_Item__c Where DataUsage__c!=null';
		//system.debug('QueryResult is: '+ query);
		return  Database.getQueryLocator(query);
		
	}
	
	global void execute(Database.BatchableContext BC,List<Product_Portfolio_Item__c> DataList)
		
	{
		List<String> NSNLegacyList= new List<string>();
		for(Product_Portfolio_Item__c pi: DataList)
		{
			NSNLegacyList.add(pi.NSNLegacyCode__c);
			
		} 
		//System.debug('List is: ' +NSNLegacyList);
		
		List<interface_log__c> ilogs = new List<interface_log__c>();
		List<NCP_Product_Content__c>DataUsageList=new List<NCP_Product_Content__c>();
		
		Map<String,String> ProductMap = new  Map<String,String>();
		
		 for(Product2 p : [Select Id,ProductCode From Product2 Where ProductCode in : NSNLegacyList ])
		 {
			 ProductMap.put(p.ProductCode,p.Id);
			 
		 }  
		for(Product_Portfolio_Item__c ppi: DataList)
		{
			List<String> SplitValues=ppi.DataUsage__c.split(',');
			 //system.debug('SplitValues list is: '+SplitValues);
			 for(String DataUsage:SplitValues)
		{
			
			NCP_Product_Content__c pc= new NCP_Product_Content__c();
			pc.NCP_External_Id__c=ppi.NSNLegacyCode__c+'_'+DataUsage;
			pc.NCP_Product__c = ProductMap.get(ppi.NSNLegacyCode__c);
			pc.NCP_Service__c= DataUsage;
			DataUsageList.add(pc);
			//system.debug('Data usage list is: '+DataUsageList);
		}
		   
		}
	
		try
		{
  // List<Database.SaveResult> results = Database.insert(DataUsageList,false); 
  List<Database.UpsertResult> results= Database.upsert(DataUsageList,NCP_Product_Content__c.NCP_External_Id__c,false);		
	 
	 for(Integer index = 0, size = results.size(); index < size; index++) 
	{
		Interface_log__c ilog = new Interface_log__c();
		String OperationType= (results[index].isCreated() ? 'Insert' : 'Update');	
	if(results[index].isSuccess()) 
	{
			ilog.comment__c ='Success';
			ilog.Interface_Type__c = 'EDP PI to Product Content';
			ilog.Message_Type__c = 'Inbound';
			ilog.Operation_Type__c = OperationType;
			ilog.Interface_Request_Sent__c = 'External Id: '+DataUsageList[index].NCP_External_Id__c+ 'Product: '+DataUsageList[index].NCP_Product__c+
											   'NCP_Service__c : '+DataUsageList[index].NCP_Service__c;
			ilog.Status__c = 'Success';
			ilog.Name = 'PI to Content '+OperationType+ ' success with DataUsage '+DataUsageList[index].NCP_External_Id__c;
			ilogs.add(ilog);
		//system.debug('success of ilogs');
		
	}
	else
	{
			for (Database.Error err : results[index].getErrors() )
			 {
				ilog.comment__c = 'Fields: '+err.getFields()+' Message: '+err.getMessage()+
													' Status Code: '+err.getStatusCode();
			 } 
 

			//ilog.comment__c =results[index].getMessage();
			ilog.Interface_Type__c = 'EDP PI to Product Content';
			ilog.Message_Type__c = 'Inbound';
			ilog.Operation_Type__c = OperationType ;
			ilog.Interface_Request_Sent__c = 'External Id: '+DataUsageList[index].NCP_External_Id__c+ 'Product: '+DataUsageList[index].NCP_Product__c+
											   'NCP_Service__c : '+DataUsageList[index].NCP_Service__c;
			system.debug('Interface req sent: '+ilog.Interface_Request_Sent__c);
			ilog.Status__c = 'Failure';
			ilog.Name = 'PI to Content '+OperationType+ ' failure with DataUsage '+DataUsageList[index].NCP_External_Id__c;
			ilogs.add(ilog);
		//system.debug('Failure of ilogs');
	   // system.debug(ilog);
		
		}
	
	}
		Database.Insert(ilogs,false);
  }
		catch(DMLException e)
		{
			 System.debug('There was an error during the Product Content Upsert!'+e); 
			 ExceptionHandler.addException(e, GlobalConstants.Batch_PortfolioToContent, 'Execute');
			
		}
}
	
	global void finish(Database.BatchableContext BC)
	{
		system.debug('Finally');
	}
	   

}