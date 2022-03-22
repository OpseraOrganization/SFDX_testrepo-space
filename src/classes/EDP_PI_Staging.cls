/****************************************
	 * Name : EDP_PI_Staging
	 * Author : Accenture
	 * Description : This class is for loading data from edp to portfolio items and create interface logs
	 * ReqNo : 4562
  ****************************************/
public class EDP_PI_Staging {
	
	Public static string status;
	Public static integer statusCode;
	public static DateTime MaxTimestamp;
	public static Integer successRecordCount = 0;
	
	/****************************************
		 * Name : uploadToStagingTable
		 * Description : load data to Product Portfolio Item object
		 * Parameters: HttResponse, URL
		 * Returns: List of product portfolio items
	 *****************************************/
	public static List<Product_Portfolio_Item__c> uploadToStagingTable(HttpResponse response, String path){
		
		status = response.getStatus();
		statusCode = response.getStatuscode(); 
		
		System.debug('CPU size after response processing: '+Limits.getHeapSize());
		
		String response1 = response.getBody().substring(response.getBody().indexof('['),response.getBody().lastindexof(']')+1);
		
		//Clear the response once its processed, to clear heap size
		response = null;
		
		string path_pi = path;
		Set<String> prod_code_set = new Set<String>();
		List<Product_Portfolio_Item__c> PI_List = new List<Product_Portfolio_Item__c>();
		
		//Deserializing response and passing it to a list
		List<EDPPIFields> productArray = (List<EDPPIFields>)System.JSON.deserialize(
											  response1 , List<EDPPIFields>.class);
		response1 = null;
		MaxTimestamp=productArray[0].EDP_LastModifiedDate;
		
		//System.debug('Extracted PI: '+productArray);
		System.debug('Extracted PI size: '+productArray.size());
		
		
		for(EDPPIFields edp :  productArray)
		{			
			Product_Portfolio_Item__c pi_item = new Product_Portfolio_Item__c();
			
			pi_item.ActionType__c				   = edp.ActionType;
			pi_item.AlternateCode__c				= edp.AlternateCode;
			if(pi_item.AlternateCode__c <> null &&  !String.isBlank(pi_item.AlternateCode__c) && pi_item.AlternateCode__c.length() > 49)
				pi_item.AlternateCode__c = pi_item.AlternateCode__c.substring(0,49);
			pi_item.AlternateCode2__c			   = edp.AlternateCode2;
			if(pi_item.AlternateCode2__c <> null &&  !String.isBlank(pi_item.AlternateCode2__c) && pi_item.AlternateCode2__c.length() > 49)
				pi_item.AlternateCode2__c		   = pi_item.AlternateCode2__c.substring(0,49);
			pi_item.CareActivate__c				 = edp.CareActivate;
			pi_item.CareException__c				= edp.CareException;
			pi_item.CareSelect__c				   = edp.CareSelect;
			pi_item.CdbStatus__c					= edp.CdbStatus;
			pi_item.ComponentStatus__c			  = edp.ComponentStatus;
			pi_item.Description__c				  = edp.Description;
			pi_item.EDP_LastModifiedDate__c		 = edp.EDP_LastModifiedDate;
			pi_item.IbaseStatus__c				  = edp.IbaseStatus;
			pi_item.Implement__c					= edp.Implement;
			pi_item.ItemId__c					   = edp.ItemId;
			pi_item.ItemUsage__c					= edp.ItemUsage;
			pi_item.LastUpdate__c				   = edp.LastUpdate;
			pi_item.Lifecyclestatus__c			  = edp.Lifecyclestatus;
			pi_item.LimitingRouting__c			  = edp.LimitingRouting;
			pi_item.Maintain__c					 = edp.Maintain;
			pi_item.NctStatus__c					= edp.NctStatus;
			pi_item.Notes__c						= edp.Notes;
			pi_item.NSNAbbreviation__c			  = edp.NSNAbbreviation;
			pi_item.NSNAdditionalClassification__c  = edp.NSNAdditionalClassification;
			pi_item.NSNAliasName__c				 = edp.NSNAliasName;
			pi_item.NSNCloud__c					 = edp.NSNCloud;
			pi_item.NSNCode__c					  = edp.NSNCode;   
			pi_item.NSNDesignResponsibility__c	  = edp.NSNDesignResponsibility;
			pi_item.NSNDesignType__c				= edp.NSNDesignType;
			pi_item.NSNLegacyCode__c				= edp.NSNLegacyCode;
			pi_item.NSNLegacyNcmCode__c			 = edp.NSNLegacyNcmCode;
			pi_item.NSNLegacyRevision__c			= edp.NSNLegacyRevision;
			pi_item.NSNMaximumOla__c				= edp.NSNMaximumOla;
			pi_item.NSNMutivendorOwner__c		   = edp.NSNMultivendorOwner;
			pi_item.NSNNameInCustomerNetwork__c	 = edp.NSNNameInCustomerNetwork;
			pi_item.NSNOfficialProductName__c	   = edp.NSNOfficialProductName;
			pi_item.NSNOriginalOwnerGroup__c		= edp.NSNOriginalOwnerGroup; 
			pi_item.NSNPartner__c				   = edp.NSNPartner;
			pi_item.NSNPlatform__c				  = edp.NSNPlatform;
			pi_item.NSNPortfolioClassification__c   = edp.NSNPortfolioClassification;
			pi_item.NSNPortfolioDataSpecialist__c   = edp.NSNPortfolioDataSpecialist;		
			pi_item.NSNProductHierarchy__c		  = edp.NSNProductHierarchy;
			pi_item.NSNProductManager__c			= edp.NSNProductManager;
			pi_item.NSNScope__c					 = edp.NSNScope;	 
			pi_item.NSNSummary__c				   = edp.NSNSummary;
			pi_item.NSNTargetNeType__c			  = edp.NSNTargetNeType;
			pi_item.NSNThirdPartyOwner__c		   = edp.NSNThirdPartyOwner;
			pi_item.NSNVirtualization__c			= edp.NSNVirtualization;
			pi_item.Obsolete__c					 = edp.Obsolete;
			pi_item.PDMModified__c				  = edp.PDMModified;
			pi_item.PDMTimestamp__c				 = edp.PDMTimestamp;
			pi_item.Rampdown__c					 = edp.Rampdown;
			pi_item.Rejected__c					 = edp.Rejected;
			pi_item.TechCluster__c				  = edp.TechCluster;
			pi_item.Type__c						 = edp.Type;
			pi_item.Is_Processed__c				 = false;			 
			pi_item.EDP_ActiveStatus__c			 = edp.EDP_ActiveStatus;
			pi_item.DataUsage__c					= edp.NSNDataUsage;
			pi_item.NCP_Marketing_Text__c		   = edp.MarketingText;

			if(prod_code_set.add(pi_item.NSNLegacyCode__c))
			  PI_List.add(pi_item);
			if(edp.EDP_LastModifiedDate>MaxTimestamp)
				MaxTimestamp=edp.EDP_LastModifiedDate;
			
			}
		
		//clear product array after loading it to PI_List
		productArray.clear();	 
		prod_code_set.clear();
		
		return PI_List;
		
		}
	
	/****************************************
		 * Name : createInterfaceLogs
		 * Description : create interface logs for portfoio items load
		 * Parameters: List of portfolio items, path 
		 * Returns: 
	 *****************************************/
	public static void createinterfacelog(List<Product_Portfolio_Item__c> PI_List,string path_pi)
	{
		//Upsert PI's into staging table
		List<Database.UpsertResult> results = new List<Database.UpsertResult>();
		try
		{
		 results = Database.upsert(PI_List,Product_Portfolio_Item__c.NSNLegacyCode__c,false);
		}
		catch(Exception e)
		{
			System.debug('Exception occured while loading PI data to staging table. Exception: '+e);
		}
		
		try{
		// Method to create interface logs
		
		List<interface_log__c> ilogs = new List<interface_log__c>();
		interface_log__c ilog_callout = new interface_log__c();
		ilog_callout.Interface_Type__c = 'EDP Portfolio Item Stage';
		ilog_callout.Message_Type__c = 'Inbound';
		ilog_callout.Operation_Type__c = 'Insert';
		
		 // Callout Interface Logs//
		 if(statusCode == 200)
		 {
			ilog_callout.Interface_Request_Sent__c  = 'Request URL: '+path_pi+ '\n'+
													 'Response: '+status+'\n'+
													  'Response Code'+statusCode+'\n';
			 
			ilog_callout.Name					   = 'PCI Rest Callout success';
		 } 
		
		  ilogs.add(ilog_callout);
		
		//PI staging Interface logs//
		
		String operationType = '';
		for(Integer index = 0, size = results.size(); index < size; index++) 
			{
				operationType = (results[index].isCreated() ? 'Insert' : 'Update');
				
				Interface_log__c ilog_pi = new interface_log__c();
				ilog_pi.Interface_Type__c = 'EDP Portfolio Item Stage';
				ilog_pi.Message_Type__c = 'Inbound';
				
				if(!results[index].isSuccess()) 
				{ 
						////PI Insert Error Interface Logs///
						
						
						for (Database.Error err : results[index].getErrors()){
							ilog_pi.comment__c = 'Fields: '+err.getFields()+'Message: '+err.getMessage()+
													'Status Code: '+err.getStatusCode();
						}
						
						//ilog_pi.comment__c = results_pci[index].getMessage();
						
						ilog_pi.Operation_Type__c = operationType;
						ilog_pi.Status__c = 'Failure';
						ilog_pi.Interface_Request_Sent__c = 'Request URL: '+path_pi+ '\n'+
															'NSNLegacyCode: '+PI_List[index].NSNLegacyCode__c +'\n'+
															'Type: '+PI_List[index].Type__c +'\n'+
															'Description: '+PI_List[index].Description__c +'\n'+
															'Status: '+PI_List[index].Lifecyclestatus__c +'\n'+
															'EDP_LastModifiedDate: '+PI_List[index].EDP_LastModifiedDate__c;
						ilog_pi.Name = 'PI '+operationType+' Failed with product code: '+PI_List[index].NSNLegacyCode__c;
						ilogs.add(ilog_pi);
				} 
				else
				{ 
					////PI Insert Success Interface Logs///
						ilog_pi.comment__c = 'Success';
						ilog_pi.Operation_Type__c = operationType;
						ilog_pi.Status__c = 'Success';
						ilog_pi.Interface_Request_Sent__c = 'Request URL: '+path_pi+ '\n'+
															'Id: '+ results[index].Id + '\n'+
															'NSNLegacyCode: '+PI_List[index].NSNLegacyCode__c +'\n'+
															'Type: '+PI_List[index].Type__c +'\n'+
															'Description: '+PI_List[index].Description__c +'\n'+
															'Status: '+PI_List[index].Lifecyclestatus__c +'\n'+
															'EDP_LastModifiedDate: '+PI_List[index].EDP_LastModifiedDate__c;
					   ilog_pi.Name = 'PI '+operationType+' Success with product code: '+PI_List[index].NSNLegacyCode__c;
						ilogs.add(ilog_pi);
					successRecordCount++;
				}
			}

			Database.Insert(Ilogs,false);			 
			System.debug('Interface logs created for '+Ilogs.size()+'items');
			Ilogs.clear(); 
			}
	
			catch(Exception e){
				System.debug('Exception occured while loading PI interface log. Exception: '+e);
			}
	}
			
public class EDPPIFields {

	 public String ActionType;
	 public String AlternateCode;
	 public String AlternateCode2;
	 public String CareActivate;
	 public String CareException;
	 public String CareSelect;
	 public String CdbStatus;
	 public String ComponentStatus;
	 public String Description;
	 public DateTime EDP_LastModifiedDate;
	 public String IbaseStatus;
	 public String Implement;
	 public boolean IsProcessed;
	 public String ItemId;
	 public String ItemUsage;
	 public DateTime LastUpdate;
	 public String Lifecyclestatus;
	 public String LimitingRouting;
	 public String Maintain;
	 public String NctStatus;
	 public String Notes;
	 public String NSNAbbreviation;
	 public String NSNAdditionalClassification;
	 public String NSNAliasName;
	 public String NSNCloud;
	 public String NSNCode;   
	 public String NSNDesignResponsibility;
	 public String NSNDesignType;
	 public String NSNLegacyCode;
	 public String NSNLegacyNcmCode;
	 public String NSNLegacyRevision;
	 public String NSNMaximumOla;
	 public String NSNMultivendorOwner;
	 public String NSNNameInCustomerNetwork;
	 public String NSNOfficialProductName;
	 public String NSNOriginalOwnerGroup; 
	 public String NSNPartner;
	 public String NSNPlatform;
	 public String NSNPortfolioClassification;
	 public String NSNPortfolioDataSpecialist;		
	 public String NSNProductHierarchy;
	 public String NSNProductManager;
	 public String NSNScope;	 
	 public String NSNSummary;
	 public String NSNTargetNeType;
	 public String NSNThirdPartyOwner;
	 public String NSNVirtualization;
	 public String Obsolete;
	 public DateTime PDMModified;
	 public DateTime PDMTimestamp;
	 public String Rampdown;
	 public String Rejected;
	 public String TechCluster;
	 public String Type;
	 public boolean EDP_ActiveStatus;
	 public String NSNDataUsage;
	 public String MarketingText;
	 }

}