/* ----------------------------------------------------------------------------------------------------------------------------------------------------------
Name:			IRTermsClass
Description:	 IRTermsClass class to get values and perform DML operations on Multi_Language_Terms__c
Date		Version	  Author		Summary of Changes 
-----------	  ----------	  -----------------	---------------------------------------------------------------------------------------------------
11/20/2017	 1.0		Supriyam			Initial Release for IR application Form

----------------------------------------------------------------------------------------------------------------------------------------------------------*/
	/**
* Description :  constructor 
* @param NA
* @return User
* @throws NA
**/
public without sharing class IRTermsClass {
	 public  Multi_Language_Terms__c Records {get; set;} 
	public  String Lang {get; set;}
	public  String Term {get; set;}
	public  String EnglishTerm {get; set;}
	
	/**
* Description :  constructor 
* @param NA
* @return User
* @throws NA
**/
	public IRTermsClass(){
		Term=this.getTerm(ApexPages.currentPage().getParameters().get(PRMGlobalConstants.LanguageEng));
		Lang=ApexPages.currentPage().getParameters().get(PRMGlobalConstants.LanguageEng);
		EnglishTerm=this.getTerm(PRMGlobalConstants.English);
		String FileName = PRMGlobalConstants.FileNameForTerm;
		Apexpages.currentPage().getHeaders().put(PRMGlobalConstants.content_disposition,PRMGlobalConstants.attachment);
	
	}	
	 /**
* Description : getLanguageTerm method 
* @param NA
* @return LIST<Multi_Language_Terms__c>
* @throws NA
**/
	  @AuraEnabled
	public static LIST<Multi_Language_Terms__c> getLanguageTerm(String selectedLanguage) 
	{
		LIST<Multi_Language_Terms__c> TermValue=new LIST<Multi_Language_Terms__c>();
		try{
		TermValue = [Select Terms__c,Language__c from Multi_Language_Terms__c Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())];
		}	 
		Catch(System.Exception e)
		{
			String message=e.getMessage();
	 
		}
		return TermValue;
	}
	  /**
* Description : getLanguageTerm method 
* @param NA
* @return LIST<Multi_Language_Terms__c>
* @throws NA
**/
	public String getTerm(String Lang) {
		String Term;
		try{
			Multi_Language_Terms__c Records=[select Terms__c,Language__c from Multi_Language_Terms__c where Language__c=:Lang LIMIT 1]; 
			if(Records != null){
	Term=Records.Terms__c;
			}			
		}
		Catch(System.Exception e)
		{
			String message=e.getMessage();
			
		}
		return Term;
	}
	
	  
}