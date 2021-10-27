/****************************************
* Class Name : DS_Recordbanner
* Created Date: 13 Nov 2018
* Created By : Accenture
* Last Modified by: Accenture
* Description : class used  for creating custom list view for commercial entitlement page
* Controller class for DS_Prop_RelatedProducts component
*/
public without sharing class  DS_Recordbanner {
	
	 private static integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows();
	
	/*****************************
*Method Name: getCurrentRecommendation
*Description: This method used to retrive current record details for a digital proposal
#DSI-952-Sprint-19-Customer should be able to see digital proposal details in header level
*******************************/
	 @AuraEnabled
	public static SWx_Upsell_Proposal__c getCurrentRecommendation(Id currentRecordId)
	{
		 try{
		 SWx_Upsell_Proposal__c swxproposal = [Select Id,Name ,Recommendation_Type__c,
											   Technology__c,
											   Use_Case__c,
											   Collection_Period_Start_Date__c  ,
											   Collection_Period_End_Date__c,
											   Identified_Cells__c  ,
											   Analysed_Cells__c,
											   Entitlement_Info__c  ,
											   Proposal_Status__c   ,
											   Proposal_Recommendation_Type__c
											   from SWx_Upsell_Proposal__c 
											   where ID = :currentRecordId 
											   limit 1];  
	  
		return swxproposal;
				}
		catch(Exception ex){
			ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_RecordBanner,CSWXGlobalConstant.DS_RecordBanner);
			return NULL;  
		 }
	}
	
	
	//DS_entitlemlistview entries
	 /******************************
	*Method Name: getCurrentUserData
	*Description: This Method will get the required data for the logged in user
	********************************/
	@AuraEnabled
	public static User getCurrentUserData()
	{   
		try{
			
			return [SELECT Accountid,Contactid,FirstName,Name, LastName from User where id=:UserInfo.getUserId() limit 1] ;
		 }catch(Exception ex){
			ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_RecordBanner,CSWXGlobalConstant.DS_RecordBanner);
			return NULL;  
		 }
	}
	
	/******************************
	*Method Name: filtercommercialRecord
	*Description: DSI-987 sprint-19
			This Method will get the required data based on filter
	********************************/
	 @AuraEnabled
	public static List <Commercial_Entitlement__c> filtercommercialRecord(String techinfo,
																		  String useCaseInfo,string Entitlementinfo) {
	 
		system.debug('in filter');																	   
		List<String> Accountids = new List<String>();
		List<String> techinfoList= new List<String>();
		List<String> useCaseInfoList= new List<String>();
		List<Commercial_Entitlement__c> dpList = new List<Commercial_Entitlement__c>();
		List<Account> currentuserAccounts = new List<Account>();
		//Set<String> technologySet = new Set<String>();
		//Set<String> useCaseSet = new Set<String>();
		
	   system.debug('Entitlementinfo++>'+Entitlementinfo);
	   System.debug('*******techinfo*************'+techinfo);
	   System.debug('*******useCaseInfo*************'+useCaseInfo);
		try{
			
			string Soql = 'select Id,Sold_To_Party__c,Authorised_Quantity__c,Sold_To_Party__r.Name,Name,Consumed_Quantity__c,Available_Quantity__c,Parent_Account__c,Product_Name__c,Product_Name__r.Name,Product_Code__c,Features__c,Technology__c,Use_Case__c,Activated_Quantity__c from Commercial_Entitlement__c ';
			Soql += ' where Id!=null  ';
			
			if(!String.isBlank(techinfo) && techinfo !=null)
			{
				techinfoList.add(techinfo.trim());
				String nullvalue = CSWXGlobalConstant.nullValue;
				Soql +='  and Technology__c in :techinfoList' ;
			}
			if(!String.isBlank(useCaseInfo) && useCaseInfo!=null && 
				useCaseInfo != CSWXGlobalConstant.NONE_OPTION_VALUE)
			{
				useCaseInfoList.add(useCaseInfo.trim());
				Soql +='  and Use_Case__c  in : useCaseInfoList' ;
			}
			
			system.debug('Entitlementinfo>>'+Entitlementinfo);
			if(Entitlementinfo.equalsIgnoreCase(CSWXGlobalConstant.NONE_OPTION_VALUE)||Entitlementinfo==null)
			{
				system.debug('in if');
				currentuserAccounts=Get_entitlepicklist();
				for(Account acc:currentuserAccounts )
				{
					Accountids.add(acc.Id);
				}
				Soql +='  and  Sold_To_Party__c In :Accountids' ;
				
			}
		   if(!Entitlementinfo.equalsIgnoreCase(CSWXGlobalConstant.NONE_OPTION_VALUE)&& Entitlementinfo<>null)
			 {
				Soql +='  and  Sold_To_Party__c =:Entitlementinfo' ;
			}

			Soql +=' LIMIT:limitRows ' ;
			System.debug('*******Entitlementinfo*************'+Entitlementinfo); 
			System.debug('*******Accountids*************'+Accountids);
			System.debug('*******Soql*************'+Soql);   
			dpList=Database.query(Soql);
			system.debug('dpList>>'+dpList);
			return dpList;
			
		}	   
		catch (Exception ex) {
			ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_RecordBanner, CSWXGlobalConstant.filtercommercialRecord );
			return null;
		} 
	}
	
  
  /******************************
	*Method Name: sortDPRec
	*Description: This Method will sort the digital proposal record.
	
	********************************/ 
	@AuraEnabled
	public static List <Commercial_Entitlement__c> sortCPRec(String sortField,boolean isAsc,
															string techinfo,String useCaseInfo,string Entitlementinfo) {
		
	   List <Commercial_Entitlement__c > dpRec= filtercommercialRecord(techinfo,useCaseInfo, Entitlementinfo);
		list <Commercial_Entitlement__c> lstResult;
		List < Commercial_Entitlement__c > ProposalRecord = new List < Commercial_Entitlement__c > ();
		String sSoql=null;
		
		//System.debug('dpRec'+dpRec);
		if(!dpRec.isEmpty() && dpRec!=null) {
			  sSoql = 'select Id,Sold_To_Party__c,Authorised_Quantity__c,Sold_To_Party__r.Name,Name,Consumed_Quantity__c,Product_Name__r.Name,Available_Quantity__c,Parent_Account__c,Product_Name__c,Product_Code__c,Features__c,Technology__c,Use_Case__c,Activated_Quantity__c from Commercial_Entitlement__c ';
			sSoql +='  where id in : dpRec' ;
		 }
		if(!String.isBlank(sortField)) {
			sSoql += ' order by ' + sortField;
			if (isAsc) {
				sSoql += ' asc';
				 //sSoql += ' LIMIT :limitRows ';
			}else {
				sSoql += ' desc NULLS LAST';
				 //sSoql += ' LIMIT :limitRows ';
			 }
			sSoql += ' LIMIT :limitRows ';
		}
	  try{
		   lstResult = Database.query(sSoql); 
		   if(!lstResult.isEmpty() && lstResult!=null){
			   for (Commercial_Entitlement__c c: lstResult) {
					ProposalRecord.add(c);
			   }
		   }
		   return ProposalRecord;
		 }catch (Exception ex) {
			ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_RecordBanner,CSWXGlobalConstant.DS_RecordBanner);
		   return null;
	  } 
	}
	
	
	
	 /******************************
	*Method Name: getTechnologies
	*Description: This Method is used to get technology and use case values from the object.
	
	********************************/	
	@AuraEnabled
	public static List<String> getTechnologies() {
		try
		{
			List<String>  objResults = new List<String>();
			objResults.add(CSWXGlobalConstant.NONE_OPTION_VALUE);
			List<String> subList = DS_Util.getTechnologiesForLC();			  
			objResults.addAll(subList);
			return objResults;
		 }catch(Exception ex)
		{
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_RecordBanner,CSWXGlobalConstant.DS_getTechnologies);
			return null;
		}			
	}
	
	
	/******************************
	*Method Name: getUseCaseOnTechnology
	*Description: This Method is used to get technology and use case values from the object.
	
	********************************/	
	@AuraEnabled
	public static List<String> getUseCaseOnTechnology(String selectedTechnology) {
		try
		{
			 List<String>  objResults = new List<String>();
			 objResults.add(CSWXGlobalConstant.NONE_OPTION_VALUE);
			if(!(selectedTechnology.equalsIgnoreCase(CSWXGlobalConstant.NONE_OPTION_VALUE) ))
			{
				 List<String> subList = DS_Util.getUseCaseOnTechnologyForLC(selectedTechnology);
				 objResults.addAll(subList);
			}	   
			return objResults;
		}catch(Exception ex)
		{
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_RecordBanner,CSWXGlobalConstant.DS_getUseCaseOnTechnology);
			return null;
		}	   
	}
	
  /******************************
	*Method Name: Get_entitlepicklist
	*Description: This Method will get entitlement.
	
	********************************/ 
	 @AuraEnabled
	public static  List<Account> Get_entitlepicklist() {
		try{			
		string parentaccountId= getCurrentUserData().accountId; 
			system.debug('parentaccountId>>'+parentaccountId);
		List<Account> relatedAccounts=new List<Account>();
		List<Account> relatedAccountsval=[SELECT Id,Name,AccountNumber,RecordType.Name,ParentId 
										  from Account 
										  where RecordType.DeveloperName = :CSWXGlobalConstant.DS_legalEntity
										  and  ParentId=:parentaccountId
										  Order by Name
										  LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())] ;
		system.debug('relatedAccountsval>>'+relatedAccountsval);
		return relatedAccountsval;
		}catch(Exception ex){
			ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_RecordBanner,CSWXGlobalConstant.DS_Get_entitlepicklist);
			return null;
		}
	}
	
}