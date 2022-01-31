/****************************************
	 * Name : EDP_PCI_Staging
	 * Author : Accenture
	 * Description : This class is for loading data from edp to configuration items and create interface logs
	 * ReqNo : 4561
	****************************************/
public class EDP_PCI_Staging {

	Public class EDPPCIFields{
	public String ConfId;
	public String Type;
	public String Name;
	public String Revision;
	public String ObjectName;
	public String SerialNumberTraced;
	public String ProductLine;
	public String ProductHierarchy;
	public String NcmCode;
	public String NSNCode;
	public String ConfigurationType;
	public String Classification;
	public String Description;
	public String CurrentStatus;
	public String PDMModified;
	public String PDMTimestamp;
	public String Applicability;
	public DateTime EDP_LastModifiedDate;
	public boolean EDP_ActiveStatus;
	public String NSNMaterialGroup;
	}
	
	Public static string status;
	Public static integer statusCode;
	public static DateTime MaxTimestamp;
	public static Integer successRecordCount = 0;
	
	/****************************************
		 * Name : uploadToStagingTable
		 * Description : load data to Product configuration Item object
		 * Parameters: HttResponse, URL
		 * Returns: List of product configuration items
	 *****************************************/
	public static List<Product_Configuration_Item__c> uploadToStagingTable(HttpResponse response, String path){
		
		status = response.getStatus();
		statusCode = response.getStatuscode(); 
		string path_pci = path;
		Set<String> prod_code_set = new Set<String>();
		List<Product_Configuration_Item__c> PCI_List = new List<Product_Configuration_Item__c>();
		
		
		//Deserializing response and passing it to a list
		List<EDPPCIFields> productArray = (List<EDPPCIFields>)System.JSON.deserialize(
		response.getBody().substring(response.getBody().indexof('['),response.getBody().lastindexof(']')+1), List<EDPPCIFields>.class);
		//System.debug('Extracted PCI: '+productArray);
		System.debug('Extracted PCI size: '+productArray.size());
		
		 //Clear the response once its processed, to clear heap size
		response = null;
		MaxTimestamp=productArray[0].EDP_LastModifiedDate;
		
		for(EDPPCIFields edp :  productArray)
		{			
			Product_Configuration_Item__c pci_item = new Product_Configuration_Item__c();			
			pci_item.confid__c				  =   edp.Confid;
			pci_item.Applicability__c		   =   edp.Applicability;
			pci_item.Classification__c		  =   edp.Classification;
			pci_item.ConfigurationType__c	   =   edp.ConfigurationType;
			pci_item.CurrentStatus__c		   =   edp.CurrentStatus;
			pci_item.Description__c			 =   edp.Description;
			pci_item.EDP_LastModifiedDate__c	=   edp.EDP_LastModifiedDate;
			pci_item.Name					   =   edp.Name;
			pci_item.NcmCode__c				 =   edp.NcmCode;
			pci_item.NSNCode__c				 =   edp.NSNCode;
			pci_item.ObjectName__c			  =   edp.ObjectName;
			pci_item.PDMModified__c			 =   edp.PDMModified;
			pci_item.PDMTimestamp__c			=   edp.PDMTimestamp;
			pci_item.ProductHierarchy__c		=   edp.ProductHierarchy;
			pci_item.ProductLine__c			 =   edp.ProductLine;
			pci_item.Revision__c				=   edp.Revision;
			pci_item.SerialNumberTraced__c	  =   edp.SerialNumberTraced;
			pci_item.Type__c					=   edp.Type;
			pci_item.Is_Processed__c			=   False;
			pci_item.EDP_ActiveStatus__c		=   edp.EDP_ActiveStatus;  
			pci_item.NSNMaterialGroup__c		= 	edp.NSNMaterialGroup;			
			
			if(prod_code_set.add(pci_item.confid__c))
				PCI_List.add(pci_item);	   
			if(edp.EDP_LastModifiedDate>MaxTimestamp)
				MaxTimestamp=edp.EDP_LastModifiedDate;
		}
		
	   //clear product array after loading it to PI_List
		productArray.clear(); 
		prod_code_set.clear();

		return PCI_List;
	}
	
	/****************************************
		 * Name : createInterfaceLogs
		 * Description : create interface logs for configuration items load
		 * Parameters: List of configuration items, path
		 * Returns: 
	 *****************************************/
	public static void createinterfacelog(List<Product_Configuration_Item__c> PCI_List,String path_pci)
	{
		//Insert PCI's into staging table
		List<Database.UpsertResult> results = new List<Database.UpsertResult>();
		try{
		 results = Database.upsert(PCI_List,Product_Configuration_Item__c.confid__c, false);

		// Method to create interface logs
		
		System.debug('Data loaded to configuration item..');
		 
		List<interface_log__c> ilogs = new List<interface_log__c>();
		interface_log__c ilog_callout = new interface_log__c();
		ilog_callout.Interface_Type__c = 'EDP Configuration Item Stage';
		ilog_callout.Message_Type__c = 'Inbound';
		ilog_callout.Operation_Type__c = 'Insert';
		
		 // Callout Interface Logs//
		 if(statusCode == 200)
		 {
			ilog_callout.Interface_Request_Sent__c  = 'Request URL: '+path_pci+ '\n'+
													 'Response: '+status+'\n'+
													  'Response Code'+statusCode+'\n';
			ilog_callout.Status__c				  = 'Success';
			ilog_callout.Name					   = 'PCI Rest Callout success';
		 }				  
		  ilogs.add(ilog_callout);
		
		String operationType = '';
		//PCI staging Interface logs//
		for(Integer index = 0, size = results.size(); index < size; index++) 
			{
				operationType = (results[index].isCreated() ? 'Insert' : 'Update');
				
				Interface_log__c ilog_pci = new Interface_log__c();
				ilog_pci.Interface_Type__c = 'EDP Configuration Item Stage';
				ilog_pci.Message_Type__c = 'Inbound';
				ilog_pci.Operation_Type__c = operationType;
				
				if(!results[index].isSuccess()) 
				{ 
					////PCI Error Interface Logs///
					
					for (Database.Error err : results[index].getErrors()){
						ilog_pci.comment__c = 'Fields: '+err.getFields()+'Message: '+err.getMessage()+
												'Status Code: '+err.getStatusCode();
					}
					
					//ilog_pci.comment__c = results_pci[index].getMessage();				  
					ilog_pci.Status__c = 'Failure';
					ilog_pci.Interface_Request_Sent__c = 'Request URL: '+path_pci+ '\n'+
														'ConfId: '+PCI_List[index].confid__c +'\n'+
														'Type: '+PCI_List[index].Type__c +'\n'+
														'Name: '+PCI_List[index].Name +'\n'+
														'Description: '+PCI_List[index].Description__c +'\n'+
														'Status: '+PCI_List[index].CurrentStatus__c +'\n'+
														'EDP_LastModifiedDate: '+PCI_List[index].EDP_LastModifiedDate__c;
					ilog_pci.Name = 'PCI '+operationType+' Failed with product code: '+PCI_List[index].confid__c;
				 ilogs.add(ilog_pci);					
				}
				else
				{
						 ////PCI Success Interface Logs///
						ilog_pci.comment__c = 'Success';
						ilog_pci.Status__c = 'Success';
						ilog_pci.Interface_Request_Sent__c = 'Request URL: '+path_pci+ '\n'+
															'Id: '+ results[index].Id + '\n'+
															'ConfId: '+PCI_List[index].confid__c +'\n'+
															'Type: '+PCI_List[index].Type__c +'\n'+
															'Name: '+PCI_List[index].Name +'\n'+
															'Description: '+PCI_List[index].Description__c +'\n'+
															'Status: '+PCI_List[index].CurrentStatus__c +'\n'+
															'EDP_LastModifiedDate: '+PCI_List[index].EDP_LastModifiedDate__c;
						ilog_pci.Name = 'PCI '+operationType+' Success with product code: '+PCI_List[index].confid__c;
						ilogs.add(ilog_pci);
					successRecordCount++;
				 }
			}
			
			Database.Insert(Ilogs,false);			 
			System.debug('Interface logs created for '+Ilogs.size()+'items');
			Ilogs.clear(); 
			}
	
			catch(Exception e){
				System.debug('Exception occured while loading PCI interface log. Exception: '+e);
			}
	}
	   
}