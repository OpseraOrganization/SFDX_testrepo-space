/****************************************
	 * Name : EDP_Supplier_Staging
	 * Author : Nokia
	 * Description : This class is for loading data from edp to Supplier staging and create interface logs
	 * ReqNo : 20993
	****************************************/

public class EDP_Supplier_Staging {
	
	public static String status = '';
	public static Integer statusCode;   
	public static DateTime MaxTimestamp;
	public static Integer successRecordCount = 0;
	
	
	
	public static List<Supplier_Staging__c> uploadToStagingTable(HttpResponse response1, String path){
		
		status = response1.getStatus();
		statusCode = response1.getStatuscode(); 
		String path_SI = path;
		
		try{
			
			System.debug('Deserializing');
			//Deserializing response and passing it to a list
			List<EDPSupplier> supplierArray = (List<EDPSupplier>)System.JSON.deserialize(response1.getBody().substring(response1.getBody().indexOf('['), response1.getBody().lastIndexOf(']')+1), List<EDPSupplier>.class);
		
			//Clear the response once its processed, to clear heap size
			response1 = null;
			
			//Process each Supplieritem in a for loop and add it to Suppler items list
			List<Supplier_Staging__c> supplierList = new List<Supplier_Staging__c>();			   
			
			MaxTimestamp=Datetime.valueOf(supplierArray[0].EDP_LastModifiedDate);
			
			for(EDPSupplier sup :  supplierArray)
			{
				Supplier_Staging__c suppl = new Supplier_Staging__c();
				
				suppl.Active_Status__c = sup.ActiveStatus;
				suppl.City__c = sup.City;
				suppl.Company_Lifecycle_Status__c = sup.CompanyLifecycleStatus;
				suppl.Company_Name__c = sup.CompanyName;
				suppl.Country__c = sup.ISOCode2;
				suppl.Current_Supplier_Role__c = sup.CurrentSupplierRole;
				suppl.EDP_LastModifiedDate__c = sup.EDP_LastModifiedDate;
				suppl.Internal_Company__c  = sup.InternalCompany;
				suppl.Name_Of_Street_District__c = sup.NameOfStreetDistrict;
				suppl.Street_Name__c = sup.StreetName;
				suppl.Supplier_ID__c = sup.Supplier_ID;
				suppl.URL__c = sup.URL;
				suppl.ZIP_Code__c = sup.ZIPCode;
				suppl.Is_Processed__c = false;
				
				supplierList.add(suppl);
				
				if(Datetime.valueOf(sup.EDP_LastModifiedDate)>MaxTimestamp)
					MaxTimestamp=Datetime.valueOf(sup.EDP_LastModifiedDate);
				
			}
			//clear supplierArray list after loading it to supplierList
			supplierArray.clear();
			
			
			return supplierList;
		}
		catch(Exception ex)
		{
		   //  ExceptionHandler.addException(ex, PMDI_Constants.EDP_SI_Staging, PMDI_Constants.UPLOADTOSTAGINGTABLE);
			return null;
		}
	}
	
	
	public static void createInterfaceLogs(List<Supplier_Staging__c> SupplierList,String path_SI)
	{	
		try { 
		List<Database.upsertResult> results_si = Database.upsert(SupplierList,Supplier_Staging__c.Fields.Supplier_ID__c, false);

			List<interface_log__c> ilogs = new List<interface_log__c>();		   
			interface_log__c ilog_callout = new interface_log__c();
			ilog_callout.Interface_Type__c = 'EDP Sales Item Stage';
			ilog_callout.Message_Type__c = 'Inbound';
			ilog_callout.Operation_Type__c = 'Insert';
			
			if(statusCode == 200)
			 {
				ilog_callout.Interface_Request_Sent__c = 'Request URL: '+path_SI+ '\n'+
														 'Response: '+status+'\n'+
														  'Response Code'+statusCode+'\n';
														  //'Product Codes extracted: '+prod_code_str;
														  ilog_callout.Status__c = 'Success';
				ilog_callout.Name = 'SI Rest Callout success';
			 }
	
	String operationType;
	
	 for(Integer index = 0, size = results_si.size(); index < size; index++) 
			{
				operationType = (results_si[index].isCreated() ? 'Insert' : 'Update');
				if(!results_si[index].isSuccess()) 
				{ 
					//// Error Interface Logs///
					interface_log__c ilog_si = new interface_log__c();
					for (Database.Error err : results_si[index].getErrors()){
						ilog_si.comment__c = 'Fields: '+err.getFields()+'Message: '+err.getMessage()+
												'Status Code: '+err.getStatusCode();
					}
					
					
					ilog_si.Interface_Type__c = 'EDP Supplier Item';
					ilog_si.Message_Type__c = 'Inbound';
					ilog_si.Operation_Type__c = operationType;
					ilog_si.Status__c = 'Failure';
					ilog_si.Interface_Request_Sent__c = 'Request URL: '+Path_SI+ '\n'+
														'ActiveStatus: '+SupplierList[index].Active_Status__c +'\n'+
														'City: '+SupplierList[index].City__c +'\n'+
														'CompanyLifecycleStatus: '+SupplierList[index].Company_Lifecycle_Status__c +'\n'+
					'CountryISOCode2: '+SupplierList[index].Country__c +'\n'+
														'ZipCode: '+SupplierList[index].ZIP_Code__c +'\n'+
														'EDP_LastModifiedDate: '+SupplierList[index].EDP_LastModifiedDate__c;
					ilog_si.Name = 'SI '+operationType+' Failed with Supplier Id: '+SupplierList[index].Supplier_ID__c;
				 ilogs.add(ilog_si);
									   
				}
	
	
	
				else
				{ 
				//// Success Interface Logs///
				interface_log__c ilog_si = new interface_log__c();
					ilog_si.comment__c = 'Success';
					ilog_si.Interface_Type__c = 'EDP Sales Item Stage';
					ilog_si.Message_Type__c = 'Inbound';
					ilog_si.Operation_Type__c = operationType;
					ilog_si.Status__c = 'Success';
					ilog_si.Interface_Request_Sent__c = 'Request URL: '+Path_SI+ '\n'+
					'Id: '+ results_si[index].Id + '\n'+
													   'ActiveStatus: '+SupplierList[index].Active_Status__c +'\n'+
														'City: '+SupplierList[index].City__c +'\n'+
														'CompanyLifecycleStatus: '+SupplierList[index].Company_Lifecycle_Status__c +'\n'+
					'CountryISOCode2: '+SupplierList[index].Country__c +'\n'+
														'ZipCode: '+SupplierList[index].ZIP_Code__c +'\n'+
														'EDP_LastModifiedDate: '+SupplierList[index].EDP_LastModifiedDate__c;
					ilog_si.Name = 'SI '+operationType+' Success with Supplier Id: '+SupplierList[index].Supplier_ID__c;
				 ilogs.add(ilog_si);
					successRecordCount++;
				 }
			}

			Database.Insert(Ilogs,false);			 
			System.debug('Interface logs created for '+Ilogs.size()+'items');
			Ilogs.clear(); 
		   
	
		}
		catch (Exception ex){
			System.debug('Exception occured '+ex.getMessage());
		}
	}
	
	
	
	public class EDPSupplier{
		public String Supplier_ID;	
		public String CompanyName;		
		public String CurrentSupplierRole;	
		public String URL;	
		public String StreetName;	
		public String City;	
		public String NameOfStreetDistrict;	
		public String ZIPCode;	
		public String Country;	
		public String ISOCode2;	
		public String OrganizationRole;	
		public boolean ActiveStatus;
		public String InternalCompany;		
		public String CompanyLifecycleStatus;
		public DateTime EDP_LastModifiedDate;	
		
	}
	
	
}