/****************************************
 * Class Name : Home_Page_Offers
 * Created Date: 27 Dec 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Description : Controller Class for Home_Page_Offers.cmp
 *****************************************/
public with sharing class Home_Page_Offers {
	/*****************************
 *Method Name : getProposal
 *Description: This method will return Query Data   
 *******************************/ 
	@AuraEnabled
	 public static List<Apttus_Proposal__Proposal__c> getProposal(){
	 List<Apttus_Proposal__Proposal__c> OffersList = new List<Apttus_Proposal__Proposal__c>(); 
	   try {
		 OffersList = [Select Id,Name,Level_3__c,Creation_Date__c FROM Apttus_Proposal__Proposal__c
					  where Apttus_Proposal__Approval_Stage__c= :CSWXGlobalConstant.Approval_stage_approved and Creation_Date__c !=null
					  ORDER BY Creation_Date__c DESC
					  limit 5];
		return OffersList;
	   } 
	  catch (Exception ex) {ExceptionHandler.addException(ex,CSWXGlobalConstant.Home_Page_Offers,CSWXGlobalConstant.getProposalMethod); return null;
	  } 
		
	}
	  
}