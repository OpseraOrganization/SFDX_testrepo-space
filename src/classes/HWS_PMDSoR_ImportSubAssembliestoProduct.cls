/****************************************
* Class Name : HWS_PMDSoR_ImportSubAssembliestoProduct
* Created Date: 25 June 2020
* Created By : Sai Lakshman Kanukollu 
* Last Modified by: Sai Lakshman Kanukollu
* Last Modified Date: 25 June 2020
* Description : This batch class is used to update Product Version Item to Product object
* Reference: NOKIASC-28644
* Test Class: HWS_PMDSoRImportSubAssemtoProduct_Test
*****************************************/

public class HWS_PMDSoR_ImportSubAssembliestoProduct implements Database.Batchable<sObject>,Database.Stateful
{
	
	//static variable initialization
	public List<NokiaCPQ_PMDI_Parameter__c> lparas = new List<NokiaCPQ_PMDI_Parameter__c>();
	public string sourceType = 'HWS_Product_Version_Item__c';
	private static boolean debug = false;
	private static String code = 'HWS_NSNCode__c';
	
	/****************************************
* Name : getFields
* Description : Retrieves the fields used for processing staging entry in to HWS Product version item
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
				  NokiaCPQ_ParaType__c IN ('MAPPING RULE','DIRECT_VALUE') AND
				  NokiaCPQ_ObjNameSrc__c = 'HWS_Product_Version_Item__c' AND NokiaCPQ_ObjNameTrg__c = 'Product2'
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
* Description : Retrieves the data from HWS_Product_Version_Item__c object
* Parameters: Database.BatchableContext
* Returns : Database.QueryLocator
*****************************************/
	public Database.QueryLocator start(Database.BatchableContext BC) {
		
		String sfields = getFields();
		String fields = '';
		if(sfields != null || sfields!= '')
		{
			fields = ', ' + sfields;
		}
		
		String query = 'SELECT Id' + fields + ' FROM '+sourceType+' WHERE HWS_IsAssembly__c  = true AND HWS_Is_Assembly_Processed__c = false AND '+code+' != NULL';
		return Database.getQueryLocator(query);
	}
	
	/****************************************
* Name : execute
* Description : Used to update Product Table from HWS product Version Item Table
* Parameters: Database.BatchableContext, List of Product Version item
* Returns : 
*****************************************/	
	public void execute(Database.BatchableContext BC, List < HWS_Product_Version_Item__c> scope) {	
		
		try {
			
			updateVersionToProduct2(scope,lparas);
			
		} catch(Exception ex) {
			System.debug('### An exception has occurred : ' + ex.getMessage());
		}			
	}
	
	public void finish(Database.BatchableContext BC) {
		try{
			
			Integer batchSizeSSI=Integer.valueOf(HWS_Settings__c.getValues('SSI Batch Size').SettingValue__c);
			HWS_EDP_SalesItemToProduct_BATCH batch = new HWS_EDP_SalesItemToProduct_BATCH();
			Database.executebatch(new HWS_EDP_SalesItemToProduct_BATCH(),batchSizeSSI);
			
		}catch(Exception ex) {
			System.debug('### An exception has occurred : ' + ex.getMessage());
		} 
	}
	
	
	/********************
* Method Name: updateVersionToProduct2
* Parameter: List < HWS_Product_Version_Item__c > versionItems
* Description: Used to update Product Table from HWS product Version Item Table
* Reference: NOKIASC-28644
*******************/
	public void updateVersionToProduct2 (List <HWS_Product_Version_Item__c> versionItems, List<NokiaCPQ_PMDI_Parameter__c> pmapping) { 
		Set<String> nsnCode = new Set<String>();
		//Create a new list for interface logs to store callout failures
		List<interface_log__c> iLogs = new List<interface_log__c>();
		Map<String,HWS_Product_Version_Item__c> nsnVersionMap = new Map<String,HWS_Product_Version_Item__c>();
		List<Product2> productsToUpdate = new List<Product2>();
		Map<String,String> productMap = new Map<String, String>();
		List<HWS_Product_Version_Item__c> processedList = new List<HWS_Product_Version_Item__c>();
		
		for (HWS_Product_Version_Item__c VersionObject: versionItems) {
			nsnVersionMap.put(VersionObject.HWS_NSNCode__c,VersionObject);
		}
		
		List<Product2> prodList = [SELECT id, HWS_NSNPartCode__c,ProductCode  FROM Product2 where HWS_NSNPartCode__c =:nsnVersionMap.keyset()];
		
		for(Product2 product : prodList){
			productMap.put(product.HWS_NSNPartCode__c,product.Id);
		}
		
		productsToUpdate = HWS_ProcessversionItem_SVC.updateTarget(versionItems,productMap,'Product2',lparas);	
		
		try 
		{
			Database.UpsertResult[] srList = Database.upsert(productsToUpdate, false); 
			
			// Iterate through each returned result
			for(Integer index = 0, size = srList.size(); index < size; index++) 
			{
				String operationType = (srList[index].isCreated() ? 'Insert' : 'Update');
				
				if(srList[index].isSuccess()){		
					nsnCode.add(productsToUpdate[index].HWS_NSNPartCode__c);
					
				}
				else{
					Interface_log__c ilog = createErrorLog(srList[index].getErrors(),productsToUpdate[index],operationType);
					if(ilog != null){
						iLogs.add(ilog);
					}
				}
			}
			
			for(HWS_Product_Version_Item__c pvi : [select Id,HWS_Is_Assembly_Processed__c  from HWS_Product_Version_Item__c where HWS_NSNCode__c in:nsnCode ]){
				pvi.HWS_Is_Assembly_Processed__c = true;	
				processedList.add(pvi);
			}
			
			Database.insert(iLogs,false);
			Database.update(processedList,false);
		}
		catch (DmlException e) 
		{ 
			System.debug('There was an error during the Product Upsert!'+e); 
		} 
		
	} 
	
	/****************************************
* Name : createErrorLog
* Description : creates an error log for errors occurred during product load
* Parameters: Database.Error[], Product record, Operation type
* Returns : Interfacelog
*****************************************/ 
	
	public Interface_log__c createErrorLog(Database.Error[] errors, Product2 prod, String operationType)
	{
		Interface_log__c ilog = new Interface_log__c();
		if(errors.size()>0){
			for (Database.Error err : errors)
			{
				ilog.comment__c = 'Fields: '+err.getFields()+' Message: '+err.getMessage()+
					' Status Code: '+err.getStatusCode();
			}
		}
		ilog.Interface_Type__c = 'PMDSOR-HWS';
		ilog.Message_Type__c = 'Inbound';
		ilog.Operation_Type__c = operationType;
		ilog.Interface_Request_Sent__c = 'HWS_PMDSoR_ImportSubAssembliestoProduct: '+prod.Name+' NSN Code: '+prod.HWS_NSNPartCode__c +
			' Item type: '+prod.NokiaCPQ_Item_Type__c ;
		ilog.Status__c = 'Failure';
		ilog.Name = 'Product Upsert failed with '+prod.HWS_NSNPartCode__c;
		return ilog;
	}
	
}