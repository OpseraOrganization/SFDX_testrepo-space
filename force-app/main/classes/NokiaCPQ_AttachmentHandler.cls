/***********************************************
*	Class Name : AttachmentHandler
*	Created By : Accenture IDC
*	Created Date :22/Sept/2017
*	Description : This will update the name of the attachment on Quote and Accreditation object

*********************************************/
public without sharing class NokiaCPQ_AttachmentHandler {
	
	static String accountid;
	static String appName;
	static Boolean isPRM = false;
	/***************************************
*Method Name: beforeInsert
*Description: This will handle the methods from OpportunityTeamHelper that will fire before Update
*Parameters: Opportunity Team  List
*****************************************/
	public static void beforeInsert(List<Attachment> attList){
		try{
			//System.debug('AttachmentHandler');
			Set<id> newIdSet=new Set<id>();
			For(Attachment ac:attList){
				newIdSet.add(ac.parentId); 
			}
			system.debug('Attachment update name-->');
			List<Apttus_Proposal__Proposal__c> appcList = [Select id,RecordTypeId,Name,app_name__C, Analytics_Source__c, Quote_Type__c, NokiaCPQ_Proposal_Id__c, Apttus_Proposal__Account__c from Apttus_Proposal__Proposal__c where id in:newIdSet];
			List<Accreditation__c> accreList = [select id, RecordTypeId,App_Name__c,Partner__c from Accreditation__c where id in: newIdSet];	 
			 
			if(!appcList.isEmpty())
			{
				for(Apttus_Proposal__Proposal__c appc : appcList)
					for(Attachment att : attList)
				{	  
					system.debug('In attachment1');
					if(att.ParentId==appc.id){   
						system.debug('In attachment2:'+appc.app_name__c);
						if(!att.Name.equalsIgnoreCase(appc.NokiaCPQ_Proposal_Id__c+Nokia_CPQ_Constants.xlsm)){
							//att.Name = appc.app_name__C+ Nokia_CPQ_Constants.xlsm;
						} 
						if(((appc.RecordTypeId ==Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.QuoteReadOnlyLayout).getRecordTypeId() || appc.RecordTypeId ==Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByName().get(CSWXGlobalConstant.QuoteRecordType).getRecordTypeId()) && appc.app_name__C!=null  && appc.app_name__C.contains(CSWXGlobalConstant.EXPORT_PROPOSAL ))){
							att.Name = appc.app_name__C+ Nokia_CPQ_Constants.xlsm; 
						} 
						
						appName = appc.app_name__C;
						accountid = appc.Apttus_Proposal__Account__c;
						
						if(att.Name.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_BOM_APP+appc.NokiaCPQ_Proposal_Id__c+Nokia_CPQ_Constants.xlsm)){
							att.IsPrivate=True;
						}
						system.debug('App Name' + att.Name + '  Proposal Id  ' + appc.NokiaCPQ_Proposal_Id__c);
						
						//Marked PrM export as private
						if(att.Name != null && att.Name.contains(Nokia_CPQ_Constants.PRMEXPORT)){
							att.IsPrivate=True;
						}
						
						//Marked LOA export as private
						if(att.Name != null && att.Name.contains(Nokia_CPQ_Constants.LOAEXPORT + appc.NokiaCPQ_Proposal_Id__c +Nokia_CPQ_Constants.xlsm)){
							att.IsPrivate=True;
						}
						//Marked CSP export file as private
						if(att.Name != null && att.Name.contains(Nokia_CPQ_Constants.CSPEXPORT + appc.NokiaCPQ_Proposal_Id__c +Nokia_CPQ_Constants.xlsm)){
							att.IsPrivate=True;
						}
					} 
				}
			}
			
			else if(!accreList.isEmpty()){
				for(Accreditation__c accre : accreList)
					for(Attachment att : attList)
				{  
					if(att.ParentId==accre.id)
					{   
						String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
						
						accountid = accre.Partner__c;
						appName = accre.app_name__C;
						if((profileName.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PARTNER_PROFILE_NAME)||profileName.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PARTNER_RELATIONSHIP_MANAGER)) && (!att.Name.contains(Nokia_CPQ_Constants.NOKIA_Q2C))){
							isPRM =true;
							shareAccount('Edit');
						}
						
						if(att.Name.contains(Nokia_CPQ_Constants.NOKIA_Q2C)){
							att.IsPrivate=True;
						}
						// att.ContentType =Nokia_CPQ_Constants.NOKIA_Q2C;
						//if(att.Name!=null && (!att.Name.contains(Nokia_CPQ_Constants.NOKIA_Q2C))){
						//att.Name = accre.app_name__C+Nokia_CPQ_Constants.xlsm;
						
						// }
						/* else{
att.Name = accre.app_name__C+Nokia_CPQ_Constants.xlsm;
} */ 
					}	 
				}
			}
		} catch(Exception e){
			ExceptionHandler.addException(e,NokiaCPQ_AttachmentHandler.class.getName(),GlobalConstants.ERRORVK);
		}
		
	}
	
	/***************************************
*Method Name: getAccountID
*Description: Returns AccountId
*Parameters: NA
*****************************************/ 
/*	public static String getAccountID(){
		return accountid;
	} */
	
	/***************************************
*Method Name: getAppName
*Description: Returns appName
*Parameters: NA
*****************************************/ 
	public static String getAppName(){
		return appName;
	}
	
	public static Boolean getIsPRM(){
		return isPRM;
	}
	
	/***************************************
*Method Name: shareAccount
*Description: Returns None
*Parameters: NA
*****************************************/ 
	public static void shareAccount(string access){
		
		try{
			AccountShare thisAccountShare = new AccountShare(); //a new empty AccountShare object
			thisAccountShare.UserOrGroupId = userinfo.getUserId();
			thisAccountShare.accountid = accountid;
			thisAccountShare.accountaccesslevel = access;
			thisAccountShare.CaseAccessLevel = 'None';
			thisAccountShare.ContactAccessLevel = access;
			thisAccountShare.OpportunityAccessLevel = 'None';
			insert thisAccountShare;
		}catch(Exception e){
			ExceptionHandler.addException(e,NokiaCPQ_AttachmentHandler.class.getName(),GlobalConstants.ERRORVK);
			
		}
		
	}
}