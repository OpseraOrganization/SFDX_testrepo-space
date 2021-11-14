/****************************************
 * Class Name: CCRE_Offers_List
 * Created Date: 18 Nov 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Description : Controller Class for CCRE_Offers.cmp
 *****************************************/
public with sharing class CCRE_Offers_List{  
	
 /*****************************
 *Method Name : getProposalOnLoad
 *Description: This method will return list of Quotes on page load  for CCRE without any filters added   
 *Parameters: No Parameters
 *Test coverage from: 
 *******************************/ 
	@AuraEnabled
	public static List<Apttus_Proposal__Proposal__c> getProposalOnLoad()
	{
		String analyticsSource = CSWXGlobalConstant.AnalyticsSource_CCRE; 
	   
		Set<String> Approval_Stage= new Set<String>();
		Approval_stage.add( CSWXGlobalConstant.Approval_stage_accepted); 
		Approval_stage.add( CSWXGlobalConstant.Approval_stage_withdrawn);
		//Approval_stage.add( CSWXGlobalConstant.Approval_stage_published);
		Approval_stage.add( CSWXGlobalConstant.Approval_stage_approved);
		Approval_stage.add( CSWXGlobalConstant.Approval_stage_rejected);
		String Revision = CSWXGlobalConstant.revision_status;
		
		String sSoql = 'SELECT Id,Proposal_Recommendation_Type__c,Creation_Date__c ,NAME,Apttus_Proposal__Approval_Stage__c,Quote_Stage__c,Apttus_Proposal__Proposal_Name__c FROM Apttus_Proposal__Proposal__c  where  Analytics_Source__c = :analyticsSource AND (Apttus_Proposal__Approval_Stage__c =:Approval_Stage  OR  Quote_Stage__c=:Revision) order by Name asc ';	 
		
		integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows();
		sSoql += ' LIMIT :limitRows ';
	 
	  list <Apttus_Proposal__Proposal__c> lstResult;
	  try {
		 lstResult = Database.query(sSoql); 
		 List < Apttus_Proposal__Proposal__c > DetailRecord = new List < Apttus_Proposal__Proposal__c > ();
 
		 for (Apttus_Proposal__Proposal__c c: lstResult) {
			DetailRecord.add(c);
		  }
		 return DetailRecord;
	  } 
	  catch (Exception ex) {
		 ExceptionHandler.addException(ex,CSWXGlobalConstant.CCRE_Offers,CSWXGlobalConstant.getProposalMethod);
		 return null;
	  }   
		
	}

 /*****************************
 *Method Name : getProposal
 *Description: This method will return list of quote records based on the search filters applied by customer	
 *Parameters: sort field, Asc/Desc, creation date and stage
 *Test coverage from: 
 *******************************/ 
  @AuraEnabled
	public static List<Apttus_Proposal__Proposal__c> getProposal(String sortField, boolean isAsc,String level5, String level6)
	{
		String analyticsSource = CSWXGlobalConstant.AnalyticsSource_CCRE; 
	   
		Set<String> Approval_Stage= new Set<String>();
		Approval_stage.add( CSWXGlobalConstant.Approval_stage_accepted); 
		Approval_stage.add( CSWXGlobalConstant.Approval_stage_withdrawn);
		//Approval_stage.add( CSWXGlobalConstant.Approval_stage_published);
		Approval_stage.add( CSWXGlobalConstant.Approval_stage_approved);
		Approval_stage.add( CSWXGlobalConstant.Approval_stage_rejected);
		String Revision = CSWXGlobalConstant.revision_status;
		
		String sSoql = 'SELECT Id,Proposal_Recommendation_Type__c,Creation_Date__c ,NAME,Apttus_Proposal__Approval_Stage__c,Quote_Stage__c,Apttus_Proposal__Proposal_Name__c FROM Apttus_Proposal__Proposal__c  where  Analytics_Source__c = :analyticsSource AND (Apttus_Proposal__Approval_Stage__c =:Approval_Stage  OR  Quote_Stage__c=:Revision) ';	 
	 
		// assigning status based on filter applied
		if(level6!=CSWXGlobalConstant.All){
				if(level6.equals(CSWXGlobalConstant.Approval_stage_published) ){
									String Approved =CSWXGlobalConstant.Approval_stage_approved ;
									sSoql += ' and Apttus_Proposal__Approval_Stage__c =: Approved ';
								   }else{
									sSoql += ' and Apttus_Proposal__Approval_Stage__c = :level6 ';
								   }
	  }  
		
	   // if(level5 != null && level5 !='') 
		if(String.isNotBlank(level5)){
			Date level5Date=Date.valueOf(level5);
			sSoql += ' and Creation_Date__c >= :level5Date ';
		}
		
	  //if (sortField != '') {
	   if(String.isNotBlank(sortField)){
		 sSoql += ' order by ' + sortField;
		 if (isAsc) {
			sSoql += ' asc';
		 } else {
			sSoql += ' desc';
		 }
	  }
	   
		integer limitRows=Limits.getLimitQueryRows()- Limits.getQueryRows();
		sSoql += ' LIMIT :limitRows ';
		
	   list <Apttus_Proposal__Proposal__c> lstResult;
	  try {
		 lstResult = Database.query(sSoql); 
		 List < Apttus_Proposal__Proposal__c > DetailRecord = new List < Apttus_Proposal__Proposal__c > ();
 
		 for (Apttus_Proposal__Proposal__c c: lstResult) {
			DetailRecord.add(c);
		  }
		 return DetailRecord;
	  } 
	  catch (Exception ex) {
		 ExceptionHandler.addException(ex,CSWXGlobalConstant.CCRE_Offers,CSWXGlobalConstant.getProposalMethod);
		 return null;
	  }   
		
	}
	
 /*****************************
 *Method Name : getQuoteStages
 *Description: This method will return possible quote stages for customer 
 *Parameters: No Parameters
 *Test coverage from: 
 *******************************/ 
	 @AuraEnabled
	public static List<String> getQuoteStages()
	{
		try{
		  String QuoteStages = System.label.QuoteStages;
		  List<String> lstQuoteStages = QuoteStages.split(GlobalConstants.SEMICOLON);
		  return lstQuoteStages; 
		} 
	  catch (Exception ex) {
		 ExceptionHandler.addException(ex,CSWXGlobalConstant.CCRE_Offers,CSWXGlobalConstant.getQuoteStages);
		 return null;
	  }
	} 
 

}