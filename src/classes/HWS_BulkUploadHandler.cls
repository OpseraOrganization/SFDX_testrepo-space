/***************************************
* Class Name : HWS_BulkUploadHandler 
* Created Date: 14 June 2019
* Created By : TCS - HWS Team
* Description : Created for the userstory HWST-3679 - Identify part code using bulk file
* Last Modified by: 
* Last Modified Date: 
*****************************************/
public without sharing class HWS_BulkUploadHandler {
	/***************************************
  * Method Name : handleTrigger 
  * Created Date: 14 June 2019
  * Created By : TCS - HWS Team
  * Description : Created for the userstory HWST-3679 - Identify part code using bulk file
  * Last Modified by: 
  * Last Modified Date: 
  *****************************************/
	public static void handleTrigger(List<HWS_BulkUpload__c> newList, System.TriggerOperation triggerEvent ) {	  
		switch on triggerEvent {
			
			when AFTER_INSERT, AFTER_UPDATE {
	//create related records
			}
			when BEFORE_INSERT, BEFORE_UPDATE {
	//set value on record create
	Set<String> pcprSet = new Set<String>();	
	Set<String> accountIdSet = new Set<String>();
	Set<String> serviceTypeSet = new Set<String>();
	Map<String, String> pcprMap = new Map<String, String>();
	//HWST-4182
	Map<String, String> pcprFoundValueMap = new Map<String, String>();
	List<String> pcprNotFoundLst = new List<String>();
	Map<String, String> pcprFoundValuesMap = new Map<String, String>();	  
	Map<String, Id> pcprFoundVIdMap = new Map<String, Id>();
	Map<String, Id> pcprFoundVIdANYMap = new Map<String, Id>();	
	for(HWS_BulkUpload__c bu : newList){	
					if(bu.ParentCaseId__c == null && bu.HWS_LSPResponse__c == null){
			pcprSet.add(bu.Part_Code_Part_Revision__c.replaceAll('[^a-zA-Z0-9]', '').toUpperCase());
			accountIdSet.add(bu.HWS_AccountId__c);
			serviceTypeSet.add(bu.HWS_ServiceType__c);
		}
	}
	System.debug('HWS_BulkUploadHandler: handleTrigger: pcprSet: ' +pcprSet);
	
	try{
		if(!pcprSet.isEmpty()){
			for(HWS_VersionItem__c vi : [SELECT Id, HWS_Product_Code__c, HWS_Version_Code__c, HWS_Source__c,
				 HWS_Hardware_Sellable_Item__r.CARE_PartCode__c, HWS_Part_Code_Part_Revision__c  
				 FROM HWS_VersionItem__c 
				 WHERE HWS_Part_Code_Part_Revision__c IN :pcprSet WITH SECURITY_ENFORCED]){		  
					 
		if(vi.HWS_Source__c.equalsIgnoreCase(HWS_Constants.PUMA1_SOURCE)){
		 pcprMap.put(vi.HWS_Part_Code_Part_Revision__c.toUpperCase(), (vi.HWS_Product_Code__c+'HWS'+vi.HWS_Version_Code__c));
		 pcprFoundVIdMap.put(vi.HWS_Part_Code_Part_Revision__c.toUpperCase(),vi.Id);
		}
		if(vi.HWS_Source__c.equalsIgnoreCase(HWS_Constants.PUMA2_SOURCE)){
		 pcprMap.put(vi.HWS_Part_Code_Part_Revision__c.toUpperCase(), (vi.HWS_Hardware_Sellable_Item__r.CARE_PartCode__c+'HWS'+vi.HWS_Version_Code__c));
		 pcprFoundVIdMap.put(vi.HWS_Part_Code_Part_Revision__c.toUpperCase(),vi.Id);
		}
			}
			System.debug('HWS_BulkUploadHandler: handleTrigger: pcprMap: ' +pcprMap);
			String pcprNewValue;
			String partCodeValue;		
			for(HWS_BulkUpload__c bu : newList){
				if(!pcprMap.isEmpty()){
		pcprNewValue = bu.Part_Code_Part_Revision__c.replaceAll('[^a-zA-Z0-9]', '').toUpperCase();
		partCodeValue = bu.Part_Code_Part_Revision__c.toUpperCase();
		if(pcprMap.ContainsKey(pcprNewValue)){			
			bu.HWS_Part_Code__c = pcprMap.get(pcprNewValue).substringBefore('HWS');
			bu.HWS_Part_Revision__c = pcprMap.get(pcprNewValue).substringAfter('HWS');
			bu.HWS_Bulk_Version_Item__c = pcprFoundVIdMap.get(pcprNewValue);
		}
		else{
			pcprNotFoundLst.add(bu.Part_Code_Part_Revision__c);
		}
				}
				else{
		pcprNotFoundLst.add(bu.Part_Code_Part_Revision__c);
				}
			}
			
			//4189 -->? Below code was added to search the exact part code when user has entered with oncatenated string or only part code
			Set<String> partCodeSet = new Set<String>();
			
			List<Asset> astList = [select id, HWS_Part_Code__c, HWS_Service_Type__c, Product2Id from Asset where AccountId =:accountIdSet and HWS_ContractLineItem__r.ServiceContract.NCP_External_Status__c = 'Active' AND HWS_ContractLineItem__r.CH_ServiceClassification__c='HWS Service' AND HWS_ContractLineItem__r.NCP_External_Status__c='Active' AND HWS_ExternalStatus__c='Active' AND HWS_IsSynced__c =true AND HWS_Service_Type__c=:serviceTypeSet];
			
			Set<String> assetPaerCodeSet = new Set<String>();
			if(astList.size()>0){
				for(Asset ast :astList){
		assetPaerCodeSet.add(ast.HWS_Part_Code__c);
				}
			}
			if(pcprNotFoundLst.size()>0 && assetPaerCodeSet.size()>0){
				for(String searchValue: pcprNotFoundLst){
		for(integer i =0;i<searchValue.length();i++){
			String sc = searchValue.substring(0, searchValue.length()-i);
			if(sc.length() >=4 && assetPaerCodeSet.contains(sc)){
				sc = sc.replaceAll('[^a-zA-Z0-9]', '');
				if(!pcprFoundValuesMap.containskey(searchValue)){
					pcprFoundValuesMap.put(searchValue, sc+'ANY');
				}
				
				partCodeSet.add(sc+'ANY');				
				continue;
			}
		}
				}
			}
			if(pcprFoundValuesMap.size()>0){
				for(HWS_VersionItem__c vi : [SELECT Id, HWS_Product_Code__c, HWS_Version_Code__c, HWS_Source__c,
			 HWS_Hardware_Sellable_Item__r.CARE_PartCode__c, HWS_Part_Code_Part_Revision__c  
			 FROM HWS_VersionItem__c 
			 WHERE HWS_Part_Code_Part_Revision__c IN :partCodeSet WITH SECURITY_ENFORCED]){
				 
		if(vi.HWS_Source__c.equalsIgnoreCase(HWS_Constants.PUMA1_SOURCE)){
			pcprFoundValueMap.put(vi.HWS_Part_Code_Part_Revision__c.toUpperCase(), (vi.HWS_Product_Code__c+'HWS'+vi.HWS_Version_Code__c));
			pcprFoundVIdANYMap.put(vi.HWS_Part_Code_Part_Revision__c.toUpperCase(),vi.Id);
			
		}
		if(vi.HWS_Source__c.equalsIgnoreCase(HWS_Constants.PUMA2_SOURCE)){
			pcprFoundValueMap.put(vi.HWS_Part_Code_Part_Revision__c.toUpperCase(), (vi.HWS_Hardware_Sellable_Item__r.CARE_PartCode__c+'HWS'+vi.HWS_Version_Code__c));
			pcprFoundVIdANYMap.put(vi.HWS_Part_Code_Part_Revision__c.toUpperCase(),vi.Id);
		}
				}				
				if(!pcprFoundValueMap.isEmpty() ){
		for(HWS_BulkUpload__c bu : newList){		   
			if(pcprFoundValuesMap.containskey(bu.Part_Code_Part_Revision__c)){
	String pcprANYValue = pcprFoundValuesMap.get(bu.Part_Code_Part_Revision__c).toUpperCase();
	
	if(pcprFoundValueMap.ContainsKey(pcprANYValue)){
		
		bu.HWS_Part_Code__c = pcprFoundValueMap.get(pcprANYValue).substringBefore('HWS');
		
		bu.HWS_Part_Revision__c = pcprFoundValueMap.get(pcprANYValue).substringAfter('HWS');
		bu.HWS_Bulk_Version_Item__c = pcprFoundVIdANYMap.get(pcprANYValue);
	}
			}
			else if(!pcprMap.ContainsKey(bu.Part_Code_Part_Revision__c.replaceAll('[^a-zA-Z0-9]', '').toUpperCase())){
	bu.HWS_Part_Code__c = '';
	bu.HWS_Part_Revision__c = '';
			}		   
		}
				}
			}	
		}
	} catch(QueryException ex){
		throw new SecurityException('You don\'t have access to required Part Code and Part Revision fields on Version Item Object');
	}
			}
			when AFTER_DELETE {
	//prevent deletion of sensitive data
			}
			when else {
	//do nothing for AFTER_UNDELETE, BEFORE_DELETE, or BEFORE_UPDATE
			}
		}   
  }
  
	/***************************************
  * Class Name : SecurityException (extends exception class) 
  * Created Date: 14 June 2019
  * Created By : TCS - HWS Team
  * Description : To throw the Query Exception if any from the handleTrigger method
  * Last Modified by: 
  * Last Modified Date: 
  *****************************************/
	public class SecurityException extends Exception{}
}