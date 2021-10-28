/******************************************************************************************************
Name : DS_CPOValidity_Check
Created Date: 18th October 2018
Created by: Accenture
Description : This class is controller for lightning component DS_CPOValidity_Check	 
*********************************************************************************************************/
public with sharing class DS_CPOValidity_Check {
/******************************************************************************************************
Name : getListOfFieldsOnStatus
Description : This method is used to get Mandatory fields on CPO based on Status from Custom Setting 'DS_CPO_validation__c'. 
Parameter : List of Statuses of CPO records
*********************************************************************************************************/
public static Map<String,String> getListOfFieldsOnStatus(List<String> cpoStatus) {
	
	try{
		  Map<String,String> cpoFieldsOnStatusMap = new Map<String,String>();
		  for(DS_CPO_validation__c csObj : [Select Name, CPO_Status__c, CPO_MandatoryFields__c, CPO_Mandatory_Fields2__c, CPO_Mandatory_Fields3__c from DS_CPO_validation__c where Name!=Null AND CPO_Status__c =:cpoStatus LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]) {
			String cpo_mandfields=CSWXGlobalConstant.EMPTY_STRING;
			if(csObj.CPO_Mandatory_Fields3__c!=null){
				cpo_mandfields = CSWXGlobalConstant.CPOStatus+ csObj.CPO_MandatoryFields__c + CSWXGlobalConstant.comma + csObj.CPO_Mandatory_Fields2__c + CSWXGlobalConstant.comma + csObj.CPO_Mandatory_Fields3__c;	
			}else{
				cpo_mandfields = CSWXGlobalConstant.CPOStatus+ csObj.CPO_MandatoryFields__c + CSWXGlobalConstant.comma + csObj.CPO_Mandatory_Fields2__c;
			  }
			cpoFieldsOnStatusMap.put(csObj.CPO_Status__c,cpo_mandfields);
		   }
			return cpoFieldsOnStatusMap;
		
		}catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_CPOValidity_Check, CSWXGlobalConstant.getListOfFieldsOnStatusMethod);
						return null ; }
	}

/******************************************************************************************************
Name : getAllFieldsFromCustomSetting
Description : This method is used to get all fields on CPO based on Status from Custom Setting 'DS_CPO_validation__c'. 
Parameter : List of Statuses of CPO records
*********************************************************************************************************/	
	public static String getAllFieldsFromCustomSetting(List<String> cpoStatus) {
		
		try{
			List<String> fieldsOnStatus = new List<String>();
			Set<String> columnSet = new Set<String>();
			String allstatusFields = CSWXGlobalConstant.EMPTY_STRING ;
			for(DS_CPO_validation__c csObj : [Select Name, CPO_Status__c, CPO_MandatoryFields__c, CPO_Mandatory_Fields2__c, CPO_Mandatory_Fields3__c from DS_CPO_validation__c where Name!=Null AND CPO_Status__c =:cpoStatus LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())] ){
				system.debug('csObj.CPO_Status__c>>>>>>>>>>>'+csObj.CPO_Status__c); 
				String cpo_mandfields=CSWXGlobalConstant.EMPTY_STRING;
				if(csObj.CPO_Mandatory_Fields3__c!=null){
					cpo_mandfields = CSWXGlobalConstant.CPOStatus+ csObj.CPO_MandatoryFields__c + CSWXGlobalConstant.comma + csObj.CPO_Mandatory_Fields2__c + CSWXGlobalConstant.comma + csObj.CPO_Mandatory_Fields3__c;	
				}else{
					cpo_mandfields = CSWXGlobalConstant.CPOStatus+ csObj.CPO_MandatoryFields__c + CSWXGlobalConstant.comma + csObj.CPO_Mandatory_Fields2__c;
				}
				
				fieldsOnStatus.add(cpo_mandfields);
			   }
		
			if(!fieldsOnStatus.isEmpty()) {
				for(String item : fieldsOnStatus) {
					if(!columnSet.contains(item)){
					columnSet.add(item);
					allstatusFields= allstatusFields+ item;
				}
			  }
		   }
			return allstatusFields;
	   }catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_CPOValidity_Check, CSWXGlobalConstant.getAllFieldsFromCustomSettingMethod);
						   return null; }
	}
	
/******************************************************************************************************
Name : checkCPOValidity
Created Date: 18th October 2018
Created by: Accenture
Description : This method is used to validate if all the mandatory fields on CPO are filled or not
Parameter : List of CurrentRecord IDs
*********************************************************************************************************/   
 @AuraEnabled
	public static boolean checkCPOValidity(List<Id> currentRecordId){
	  
	   try{
			if(!CurrentRecordId.isEmpty()){
				
			   List<String>cpoStatusList = new List<String>();
			   for(Apttus_Config2__CustomerPurchaseOrder__c cpoNew:[Select Apttus_Config2__Status__c, DS_CPO_Validity_Check__c, Apttus_QPConfig__ProposalId__r.Agreement_Lookup__r.Confidence_Level__c from Apttus_Config2__CustomerPurchaseOrder__c where Id in:CurrentRecordId LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())]){
				  
				   system.debug('validity value>>>'+cpoNew.DS_CPO_Validity_Check__c);
					if(cpoNew.Apttus_QPConfig__ProposalId__r.Agreement_Lookup__r.Confidence_Level__c ==CSWXGlobalConstant.High_Level_value && cpoNew.DS_CPO_Validity_Check__c==Null){
						System.debug('inside if>>>>>>>>>>>>>>>>>>');
						 cpoStatusList.add(CSWXGlobalConstant.ReadyforExecution);	
					}else{
						System.debug('inside else>>>>>>>>>>>>>>>>>>');
						 cpoStatusList.add(cpoNew.Apttus_Config2__Status__c);
					}
				}
				System.debug('cpoStatusList>>>>'+ cpoStatusList);
				String cpoFieldListForQuery = getAllFieldsFromCustomSetting(cpoStatusList);
				Map<String,String>  cpoStatusFieldListMap = new Map<STring,String>();
				
				cpoStatusFieldListMap = getListOfFieldsOnStatus(cpoStatusList);
				System.debug('cpoStatusFieldListMap>>>'+cpoStatusFieldListMap);
				
				boolean isValid= CSWXGlobalConstant.FalseVal;			 // This field used to indicate whether the CPO is valid or not
				List<Apttus_Config2__CustomerPurchaseOrder__c>cpoList;   //This field will store the list of CPO's
				String soql=CSWXGlobalConstant.soql_part1Vaidate  + cpoFieldListForQuery + CSWXGlobalConstant.soql_Agreement_High_Level + CSWXGlobalConstant.soql_part2;
				
				system.debug('soql>>>>>>>>' + soql);
				cpoList=Database.query(soql);
				 
				system.debug('cpoList>>>>>>>>' + cpoList);
				if(!cpoList.isEmpty()){
				
				   //Below for loop iterate through the CPO result and checks for the empty values for the Required fields. 
					for (Apttus_Config2__CustomerPurchaseOrder__c cpo: cpoList) {
					
						boolean isfieldblank = CSWXGlobalConstant.FalseVal;
						List<String> fieldlist = new List <String>();
						List<String> allBypassFields = new List<String>();
						List<DS_Legacy_CPO_MandatoryCheckBypass__c> legacyBypassFields = DS_Legacy_CPO_MandatoryCheckBypass__c.getall().values();
			
						for(DS_Legacy_CPO_MandatoryCheckBypass__c bypadField : legacyBypassFields){
							allBypassFields.add(bypadField.name);
						}
			
						system.debug('allBypassFields>>>>>>>>>>'+allBypassFields);
			
					   
						if(cpo.Apttus_QPConfig__ProposalId__r.Agreement_Lookup__r.Confidence_Level__c ==CSWXGlobalConstant.High_Level_value && cpo.DS_CPO_Validity_Check__c==NULL){
						   fieldlist = cpoStatusFieldListMap.get(CSWXGlobalConstant.ReadyforExecution).split(CSWXGlobalConstant.comma);
						}else{
							fieldlist = cpoStatusFieldListMap.get(cpo.Apttus_Config2__Status__c).split(CSWXGlobalConstant.comma); 
						}
						String cpo_mandfields=CSWXGlobalConstant.EMPTY_STRING;   
						String missingFieldsLabels = CSWXGlobalConstant.EMPTY_STRING;  
						for(String item : fieldlist) {
							
						   /* if(!(cpo.Legacy_CPO__c == true && (item.equals(CSWXGlobalConstant.Quote_ProposalField)  || item.equals(CSWXGlobalConstant.Opportunityfield) || item.equals(CSWXGlobalConstant.AgreementField)))){ */
							if(!(cpo.Legacy_CPO__c == true && allBypassFields.contains(item))){
								if(cpo.Apttus_Config2__Status__c.equalsIgnorecase(CSWXGlobalConstant.draft) && cpo.get(item)==null){
									system.debug('inside draft');
									isfieldblank= CSWXGlobalConstant.TrueVal;
									missingFieldsLabels = missingFieldsLabels + Schema.getGlobalDescribe().get(CSWXGlobalConstant.CPOObject).getDescribe().fields.getMap().get(item).getDescribe().getLabel() + CSWXGlobalConstant.comma;
									
								}
								 if(cpo.Apttus_Config2__Status__c.equalsIgnorecase(CSWXGlobalConstant.ReadyforExecution) && cpo.get(item)==null){
									system.debug('Ready for Execution>>>>>');
									isfieldblank= CSWXGlobalConstant.TrueVal;
									 missingFieldsLabels = missingFieldsLabels + Schema.getGlobalDescribe().get(CSWXGlobalConstant.CPOObject).getDescribe().fields.getMap().get(item).getDescribe().getLabel() + CSWXGlobalConstant.comma;
									
								}
							   
							}
						 }
						system.debug('isfieldblank>>>>>>'+isfieldblank);
						if(isfieldblank==CSWXGlobalConstant.TrueVal){
							
							cpo.DS_CPO_Validity_Check__c=CSWXGlobalConstant.RED;
							isValid=CSWXGlobalConstant.FalseVal;
						   cpo.Missing_Fields_CPO__c = missingFieldsLabels.removeEnd(',');
						  }
						  else{
							 
							  if(cpo.Apttus_QPConfig__ProposalId__r.Agreement_Lookup__r.Confidence_Level__c ==CSWXGlobalConstant.High_Level_value  && cpo.DS_CPO_Validity_Check__c==Null ){
								 cpo.Apttus_Config2__Status__c = CSWXGlobalConstant.ReadyforExecution; 
							  }
							  cpo.DS_CPO_Validity_Check__c=CSWXGlobalConstant.GREEN;
							 isValid=CSWXGlobalConstant.TrueVal; 
							 cpo.Missing_Fields_CPO__c = '';
						  }
					}
					
				   database.update(cpoList);
				   return isValid;
			   }
			}
		  
	  }catch (Exception ex) {ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_CPOValidity_Check,CSWXGlobalConstant.checkCPOValidity);} 
		return null;
	}
	
 }