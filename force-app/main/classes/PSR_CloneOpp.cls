/*******************************
Class Name: PSR_CloneOpp
Created by: Accenture
Created Date: 22.9.2017
Last modified by: Accenture
Last modified date: 29.9.2017
Description: This class will handle the logic implemented on PreSales Clone Functionality
*******************************/
public with sharing class PSR_CloneOpp {

	/***************************
	* Requirement Details:  Pre-Sales:Sprint 10 :req#3026
	*Method Name: getPSRClone
	*Description: Cloning PSRO Opportunity
	*Parameters: String recordId
	***********************/
	@AuraEnabled
	public static String getPSRClone(String recordId){
		List<PSRCloneObject__c> objList = new List<PSRCloneObject__c>();
		String returnMessage;
		Schema.DescribeSObjectResult sc = Opportunity.sObjectType.getDescribe();
		Boolean isCreateable = sc.isCreateable();
		
		system.debug('isCreateable' + isCreateable);
		
		if(isCreateable){
			String objectName = GlobalConstants.OBJECT_OPPORTUNITY;
			String query = GlobalConstants.SELECT_QUERY;
			for(PSRCloneObject__c s : [SELECT Field_API__c, DefaultValue__c  FROM PSRCloneObject__c where Object__c =: GlobalConstants.OBJECT_OPPORTUNITY ]){
				query += GlobalConstants.SPACE + s.Field_API__c + GlobalConstants.COMMA;
			}
			system.debug('objList' + objList);
			system.debug('query.subString(query.Length())?>>>>'+query.Length());
			
			system.debug('query.subString(query.Length()-1,query.Length())?>>>>'+query.subString(query.Length()-1,query.Length()));
			if (query.subString(query.Length()-1,query.Length()) == GlobalConstants.COMMA){
				system.debug('in if... query?>>>>'+query);
				query = query.subString(0,query.Length()-1);
				system.debug('in if after substring... query?>>>>'+query);
			}
			query += GlobalConstants.SOQLFROM + GlobalConstants.OBJECT_OPPORTUNITY;
			query += GlobalConstants.SOQLWHERE + recordId +GlobalConstants.SOQLLIMIT;
			system.debug(query);
			
			try{
				Opportunity oppObj  = database.query(query);				
				Opportunity newoppObj = oppObj.clone(false,false,false,false);
				if(oppObj.PSR_Reference_Opportunity__r.stagename != GlobalConstants.STAGECLOSED){
					newoppObj.Name=oppObj.Name + GlobalConstants.CLONEOPTYNAME;
					newoppObj.CloseDate = Date.today();
					newoppObj.stageName = GlobalConstants.PREPARATION;
					if(oppObj.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c.equalsIgnoreCase(GlobalConstants.RISK_ORDER_WITH_SHIPMENT)&& oppObj.PSR_Reset_PSRO__c == True){
						   
						   newoppObj.PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c = GlobalConstants.RISK_ORDER_ONLY;
	   
					   }
					newoppObj.PSR_Reset_PSRO__c = False;
					insert newoppObj;
					system.debug('Insert successful');
					returnMessage = newoppObj.Id;
				}
			}catch(Exception ex){
				returnMessage = ex.getDmlMessage(0);
				ExceptionHandler.addException(ex, GlobalConstants.PSRCLONEOPPORTUNITY, GlobalConstants.GETPSRCLONE);
				return returnMessage; 
			}
		}else{
			returnMessage = system.label.AccessDenied;			
		}
		return returnMessage;
	}  
}