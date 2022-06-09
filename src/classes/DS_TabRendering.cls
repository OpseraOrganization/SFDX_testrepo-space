/*----------------  
 Class Name: DS_TabRendering 
Created By: Accenture
Created date - 23-6-2018,
Last Modified By: Accenture
Description: This class having logic to display filters and slides on DS portal.
Description: This class having logic to display filters and slides on DS portal.
 ---------------------------*/
public with sharing class DS_TabRendering {
	private static integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows();
	
	 /******************************
	*Method Name: getCurrentUserData
	*Description: This Method will get the required data for the logged in user
	********************************/
	@AuraEnabled
	public static User getCurrentUserData()
	{   
		try{
			
			return [SELECT Accountid,Contactid,FirstName,Name, LastName from User where id=:UserInfo.getUserId() limit 1] ;
		 }catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_TabRendering, 
																CSWXGlobalConstant.getCurrentUserData);
			return NULL;  
		 }
	}
	
	/******************************
	*Method Name: getFiles
	*Description: This Method will get the required PPT based on selected Technology and Usecase
	*Parameter:String technology, String useCase
	*******************************
	  @AuraEnabled
	 public static Map<String,String> getFiles(String technology, String useCase) {
		
		 Map<String,String> tabsToFileURL = new Map<String,String>();
		 Set<String> mapKeys = new Set<String>(); 
		 mapKeys.add(CSWXGlobalConstant.mapview);
		 mapKeys.add(CSWXGlobalConstant.benchmarking);
		 mapKeys.add(CSWXGlobalConstant.ucase);
		 mapKeys.add(CSWXGlobalConstant.featuredetails);
		 mapKeys.add(CSWXGlobalConstant.Instructions);
		 id accountId = getCurrentUserData().accountId;
		 
		 Id fileUploadId;
		 try{
			 if(!String.isBlank(technology) && technology != CSWXGlobalConstant.NONE && useCase!= CSWXGlobalConstant.NONE && !String.isBlank(useCase) ){
				 
			   
				 fileUploadId = [select Id from File_Upload__c where Technology_Txt__c =: technology and Use_Case_Txt__c =: useCase and Account__c =:accountId limit 1].id;  
			   
				 Set<id> contentid = new Set<id>();
				 for(ContentDocumentLink cdl1 : [select ContentDocumentId from ContentDocumentLink where LinkedEntityId = :fileUploadId LIMIT:limitRows ]){
					 contentid.add(cdl1.ContentDocumentId);
				 }
				   
			   
				 for(ContentVersion cv : [SELECT ContentDocumentId,FileExtension,Title,ContentBodyId FROM ContentVersion where ContentDocumentId IN:contentid LIMIT:limitRows]){	 
					 if(cv.Title == CSWXGlobalConstant.Instructions || cv.Title == CSWXGlobalConstant.mapview || cv.Title == CSWXGlobalConstant.benchmarking ||cv.Title == CSWXGlobalConstant.ucase ||cv.Title == CSWXGlobalConstant.featuredetails){
							
							String part1 = Label.ExecSumFileURLOne;
							String part2 = Label.ExecSumFileURLTwo;
							String part3 = Label.ExecSumFileURLThree;	 
							String urlToPPT = part1+cv.Id+part2+cv.ContentBodyId+part3;							
							tabsToFileURL.put(cv.Title,urlToPPT);
					}
				 }
				for(String key : mapKeys){
					 if(!tabsToFileURL.containsKey(key)){
						  tabsToFileURL.put(key,CSWXGlobalConstant.noURL);
					 }
					 
				 }
				return tabsToFileURL;
			}
			 else{
			   for(String key : mapKeys){
					 
						  tabsToFileURL.put(key,CSWXGlobalConstant.noRecord);
						 
					 
				 }
					return tabsToFileURL;
			  }
			}catch (Exception ex) { ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_TabRendering,CSWXGlobalConstant.getFiles);
								  
				 return null;
			  }
	 
	 }
 

   /******************************
	*Method Name: filterDPRecord
	*Description: This Method will filter the record based on value selected in technology ,usecase and status field in portal.
	
	********************************/
	@AuraEnabled
	public static List <SWx_Upsell_Proposal__c> filterDPRecord(String techinfo,String useCaseInfo, 
															   String statusInfo,string Entitlementinfo, String Typeinfo) {
	 
	List<String> upsellStatus = new List<String>();
   // List<String> typeList = new List<String>();
	List<String> proposalStatus = new List<String>();
	List<String> techinfoList= new List<String>();
	List<String> useCaseInfoList= new List<String>();
	List<SWx_Upsell_Proposal__c> dpList = new List<SWx_Upsell_Proposal__c>();
  //  Set<String> technologySet = new Set<String>();
   // Set<String> useCaseSet = new Set<String>();
	   
	//system.debug('Entitlementinfo++>'+Entitlementinfo);
   // System.debug('*******techinfo*************'+techinfo);
   // System.debug('*******useCaseInfo*************'+useCaseInfo);
  //  System.debug('*******statusInfo*************'+statusInfo); 
  //  System.debug('*******Typeinfo*************'+Typeinfo);  
	  string Id= getCurrentUserData().accountId; 
   try{
		
	 
	   if(statusInfo == CSWXGlobalConstant.allProposal){
						  
					DP_PortalFilter__c dpCS = DP_PortalFilter__c.getValues(CSWXGlobalConstant.csAllProposal);
					

					String ProposalCS = dpCS.ProposalStage__c; 
					String upsellCS = dpCS.Upsell_Stage__c; 
					proposalStatus= ProposalCS.split(CSWXGlobalConstant.splitBy);
					upsellStatus= upsellCS.split(CSWXGlobalConstant.splitBy);
				}
				
			   if(statusInfo ==CSWXGlobalConstant.closedProposal){
				 
				   DP_PortalFilter__c dpCS = DP_PortalFilter__c.getValues(CSWXGlobalConstant.csClosedProposal);
				   String ProposalCS = dpCS.ProposalStage__c;
				   String upsellCS = dpCS.Upsell_Stage__c; 
				   proposalStatus= ProposalCS.split(CSWXGlobalConstant.splitBy);
				   upsellStatus= upsellCS.split(CSWXGlobalConstant.splitBy);
			   }
			   if(statusInfo == CSWXGlobalConstant.forYourReview){
				  
					DP_PortalFilter__c dpCS = DP_PortalFilter__c.getValues(CSWXGlobalConstant.csForYourReview);
					String ProposalCS = dpCS.ProposalStage__c;
					String upsellCS = dpCS.Upsell_Stage__c; 
					proposalStatus= ProposalCS.split(CSWXGlobalConstant.splitBy);
					 upsellStatus= upsellCS.split(CSWXGlobalConstant.splitBy);
			   }
			   if(statusInfo == CSWXGlobalConstant.validatedProposal){
			  
					DP_PortalFilter__c dpCS = DP_PortalFilter__c.getValues(CSWXGlobalConstant.csValidatedProposal);
					String ProposalCS = dpCS.ProposalStage__c;
					String upsellCS = dpCS.Upsell_Stage__c; 
					proposalStatus= ProposalCS.split(CSWXGlobalConstant.splitBy);
					upsellStatus= upsellCS.split(CSWXGlobalConstant.splitBy);
			   }
		
			 string Soql = 'select id,Name,Analysed_Cells__c,Identified_Cells__c,Collection_Period_End_Date__c,Collection_Period_Start_Date__c,Technology__c,Use_Case__c,Entitlement_Info__c,Analytics_File_Refer_ID__c,Creation_Date__c,Proposal_Status__c,Proposal_Recommendation_Type__c, Analytics_Source__c, Recommendation_Type__c from SWx_Upsell_Proposal__c ';
			  Soql += 'where Account_ID__c =:Id and  DS_Show_In_Portal__c=true'; 
			  
			  
if(Typeinfo<>null&&!Typeinfo.equalsIgnoreCase(CSWXGlobalConstant.noneValue))
{
 //typeList.add(Typeinfo.trim());
Soql +='  and Recommendation_Type__c  =: Typeinfo' ;
}

if(!String.isBlank(techinfo) && techinfo !=null)
			   {
		 techinfoList.add(techinfo.trim());
				String nullvalue = CSWXGlobalConstant.nullValue;
				//techinfoList.add(CSWXGlobalConstant.Blank);
	Soql +='  and Technology__c =:techinfoList' ;
		}
  //System.debug('*******techinfoList*************'+techinfoList);  
	   
if(!String.isBlank(useCaseInfo) && useCaseInfo!=null &&  useCaseInfo != CSWXGlobalConstant.NONE_OPTION_VALUE)
{
 useCaseInfoList.add(useCaseInfo.trim());
//useCaseInfoList.add(CSWXGlobalConstant.Blank);
Soql +='  and Use_Case__c  in : useCaseInfoList' ;
}
	   //System.debug('*******useCaseInfoList*************'+useCaseInfoList);  
  if(upsellStatus<>null)  
{
Soql +='  and Upsell_Status__c in :upsellStatus' ;
}
		//System.debug('*******upsellStatus*************'+upsellStatus); 
	   
if(proposalStatus<>null)  
{
Soql +='  and Proposal_Status__c in :proposalStatus' ; 
}
		//System.debug('*******proposalStatus*************'+proposalStatus); 
 if(Entitlementinfo<>null&&!Entitlementinfo.equalsIgnoreCase(CSWXGlobalConstant.noneValue))
 {
 Soql +='  and  Entitlement_Info__c =:Entitlementinfo' ;
}
Soql +=' LIMIT:limitRows' ;
  // System.debug('*******Entitlementinfo*************'+Entitlementinfo); 
	//  System.debug('*******SOQL*************'+Soql); 
	   dpList=Database.query(Soql);
	   
return dpList;
}
			
		 catch (Exception ex) { ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_TabRendering,
																CSWXGlobalConstant.filterDPRecord);
				 return null;
			  } 
	}
	
	/******************************
	*Method Name: sortDPRec
	*Description: This Method will sort the digital proposal record.
	
	********************************/ 
	 @AuraEnabled
	public static  List<String> Get_entitlepicklist() {
		try{
			List<String>  objpicklists = new List<String>();
		objpicklists.add(CSWXGlobalConstant.noneValue);
   Schema.DescribeFieldResult fieldResult =SWx_Upsell_Proposal__c.Entitlement_Info__c.getDescribe();
   List<Schema.PicklistEntry> pickval = fieldResult.getPicklistValues();
		
   for( Schema.PicklistEntry picklistval : pickval)
   {
		 if(picklistval.isActive()){
		 objpicklists.add(picklistval.getValue());}
   }	   
   return objpicklists;
			
		}catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_TabRendering, 
																CSWXGlobalConstant.Get_entitlepicklistmethod );  
							return null;
				}
		 
	}
	
		/******************************
	*Method Name: Get_typepicklist
	*Description: to get type picklist values
	
	********************************/ 
	 @AuraEnabled
	public static  List<String> Get_typepicklist(){
		try{
			List<String>  objpicklists = new List<String>();
			List<DS_Recommendation_Type__c> recommendationType = DS_Recommendation_Type__c.getall().values();
			
			objpicklists.add(CSWXGlobalConstant.noneValue);
			for( DS_Recommendation_Type__c recomType : recommendationType)
			   {
				   objpicklists.add(recomType.name);
			   } 
			/* Schema.DescribeFieldResult fieldResult =SWx_Upsell_Proposal__c.Analytics_Source__c.getDescribe();
			   List<Schema.PicklistEntry> pickval = fieldResult.getPicklistValues();
					
			   for( Schema.PicklistEntry picklistval : pickval)
			   {
					 if(picklistval.isActive())
				   objpicklists.add(picklistval.getValue());
			   }	  */
			   
			
  //  system.debug('type picklist  :  '+ objpicklists);
			return objpicklists;
			
		}catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_TabRendering, 
															   CSWXGlobalConstant.Get_entitlepicklistmethod );  
			return null;
		}
		 
	}
	
  /******************************
	*Method Name: sortDPRec
	*Description: This Method will sort the digital proposal record.
	
	********************************/ 
	@AuraEnabled
	public static List <SWx_Upsell_Proposal__c> sortDPRec(String sortField,boolean isAsc,
														string techinfo,String useCaseInfo, String statusInfo,string Entitlementinfo, 
														String Typeinfo) {
		
		List <SWx_Upsell_Proposal__c > dpRec = DS_TabRendering.filterDPRecord(techinfo,useCaseInfo,
																			statusInfo, Entitlementinfo, Typeinfo);
		list <SWx_Upsell_Proposal__c> lstResult = new list <SWx_Upsell_Proposal__c>();
		List < SWx_Upsell_Proposal__c > ProposalRecord = new List < SWx_Upsell_Proposal__c > ();
		String sSoql=null;
		if(!dpRec.isEmpty() && dpRec!=null) {
			sSoql = 'select id,Name,Analysed_Cells__c,Identified_Cells__c,Entitlement_Info__c,Analytics_Source__c, Recommendation_Type__c, Collection_Period_End_Date__c  ,Collection_Period_Start_Date__c,Technology__c,Use_Case__c,Analytics_File_Refer_ID__c,Creation_Date__c,Proposal_Status__c,Proposal_Recommendation_Type__c from SWx_Upsell_Proposal__c';
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
		  }
		   sSoql += ' LIMIT :limitRows ';
	  try{
		   lstResult = Database.query(sSoql); 
		   if(!lstResult.isEmpty() && lstResult!=null){
			   for (SWx_Upsell_Proposal__c c: lstResult) {
					ProposalRecord.add(c);
			   }
		   }
		   return ProposalRecord;
		 }catch (Exception ex) {ExceptionHandler.addException(ex,CSWXGlobalConstant.DS_TabRendering,CSWXGlobalConstant.sortDPRec);
		   return null;
	  } 
	}
	
	
	
	 /******************************
	*Method Name: getTechnologies
	*Description: This Method is used to get technology and use case values from the object.
	
	********************************/	
	@AuraEnabled
	public static List<String> getTechnologies() {
		try{
		  List<String>  objResults = new List<String>();
		objResults.add(CSWXGlobalConstant.NONE_OPTION_VALUE);
		List<String> subList = DS_Util.getTechnologiesForLC();
		

		objResults.addAll(subList);
		return objResults;   
			
		}catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_TabRendering, CSWXGlobalConstant.GET_TECHNOLOGIES);  
							return null;
				}
	   
		
	}
	
	
	/******************************
	*Method Name: getUseCaseOnTechnology
	*Description: This Method is used to get technology and use case values from the object.
	
	********************************/	
	@AuraEnabled
	public static List<String> getUseCaseOnTechnology(String selectedTechnology) {
		
		try{
			  List<String>  objResults = new List<String>();
		objResults.add(CSWXGlobalConstant.NONE_OPTION_VALUE);
		if(selectedTechnology.equalsIgnoreCase( CSWXGlobalConstant.NONE_OPTION_VALUE) ) {
			 
		}		   
		else {
			 List<String> subList = DS_Util.getUseCaseOnTechnologyForLC(selectedTechnology);
			 objResults.addAll(subList);
		}
	   
		return objResults;
			
		}catch(Exception ex){ExceptionHandler.addException(ex, CSWXGlobalConstant.DS_TabRendering, CSWXGlobalConstant.GET_USECASE_ONTECHNOLOGY);  
							return null;
				}
	  
		
	}
	
	 /******************************
	*Method Name: getUseCase
	*Description: This Method is used to get technology and use case values from the object.
	
	*******************************	
	@AuraEnabled
	public static List<String> getUseCase(sObject objDetail, string contrfieldApiName) {
		
		String controllingField = contrfieldApiName.toLowerCase();
		
		List<String> objResults = new List<String>();
		Schema.sObjectType objType = objDetail.getSObjectType();
	   
		if (objType==null){
			return objResults;
		}
		
		Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
		
		
		if (!objFieldMap.containsKey(controllingField)){
			
			return objResults;	 
		}
		
		
		Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
		
		List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
		
	   
		objResults.add('---None---');
		List<String> subList = new List<String>();
		for (Schema.PicklistEntry ple : contrEntries) {
			String label = ple.getLabel();
			
			subList.add(label);
		}
		subList.sort();
		objResults.addAll(subList);
		return objResults;
		
	}
   */
	
   /******************************
	*Method Name: getDependentMap
	*Description: This Method is used to get technology and use case values from the object.
	
	******************************* */   
   /*  @AuraEnabled 
	public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName) {
		String controllingField = contrfieldApiName.toLowerCase();
		String dependentField = depfieldApiName.toLowerCase();
		
		Map<String,List<String>> objResults = new Map<String,List<String>>();
		
		Schema.sObjectType objType = objDetail.getSObjectType();
	   
		if (objType==null){
			return objResults;
		}
		
		Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
		
		
		if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
			
			return objResults;	 
		}
		
		Schema.SObjectField theField = objFieldMap.get(dependentField);
		Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
		
		List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
		List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
		
		List<String> controllingValues = new List<String>();
		
		for (Schema.PicklistEntry ple : contrEntries) {
			String label = ple.getLabel();
			objResults.put(label, new List<String>());
			controllingValues.add(label);
		}
		
		for (PicklistEntryWrapper plew : depEntries) {
			String label = plew.label;
			String validForBits = base64ToBits(plew.validFor);
			for (Integer i = 0; i < validForBits.length(); i++) {
				String bit = validForBits.mid(i, 1);
				if (bit == '1') {
					objResults.get(controllingValues.get(i)).add(label);
				}
			}
		}
		return objResults;
	} 
	
	 public static String decimalToBinary(Integer val) {
		String bits = '';
		while (val > 0) {
			Integer remainder = Math.mod(val, 2);
			val = Integer.valueOf(Math.floor(val / 2));
			bits = String.valueOf(remainder) + bits;
		}
		return bits;
	}
	
	public static String base64ToBits(String validFor) {
		if (String.isEmpty(validFor)) return '';
		
		String validForBits = '';
		
		for (Integer i = 0; i < validFor.length(); i++) {
			String thisChar = validFor.mid(i, 1);
			Integer val = base64Chars.indexOf(thisChar);
			String bits = decimalToBinary(val).leftPad(6, '0');
			validForBits += bits;
		}
		
		return validForBits;
	}
	
	private static final String base64Chars = '' +
		CSWXGlobalConstant.upper_case +
	   CSWXGlobalConstant.lower_case +
	   CSWXGlobalConstant.digits;
	
	
	private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
		return (List<PicklistEntryWrapper>)
			JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
	}
	
	public class PicklistEntryWrapper{
		public String active {get;set;}
		public String defaultValue {get;set;}
		public String label {get;set;}
		public String value {get;set;}
		public String validFor {get;set;}
		public PicklistEntryWrapper(){			
		}
		
	}
   */
}