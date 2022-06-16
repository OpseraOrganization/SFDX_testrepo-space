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
 * Method Name: beforeInsert
 * Description: This will handle the methods from OpportunityTeamHelper that will fire before Update
 * Parameters: Opportunity Team  List
 *****************************************/
public static void beforeInsert(List<Attachment> attList){
	try{
		//System.debug('AttachmentHandler');
		//Set<id> newIdSet=new Set<id>();
		Map<string,List<Attachment> > parentAttMap = new Map<string,List<Attachment> >();
		For(Attachment ac: attList){
			//newIdSet.add(ac.parentId);
			if(!parentAttMap.containsKey(ac.parentId)) {
	parentAttMap.put(ac.parentId, new List<Attachment>());
			}
			parentAttMap.get(ac.parentId).add(ac);
		}
		system.debug('NokiaCPQ_AttachmentHandler parentAttMap >> ' + parentAttMap);
		List<Apttus_Proposal__Proposal__c> appcList = [Select id,RecordTypeId,Name,app_name__C, Analytics_Source__c, Quote_Type__c, NokiaCPQ_Proposal_Id__c, Apttus_Proposal__Account__c from Apttus_Proposal__Proposal__c where id in:parentAttMap.keySet()];
		List<Accreditation__c> accreList = [select id, RecordTypeId,App_Name__c,Partner__c from Accreditation__c where id in: parentAttMap.keySet()];
		List<CPQ_ExportAttach__c> eaList = [SELECT id,CPQ_Account__c FROM CPQ_ExportAttach__c WHERE id IN: parentAttMap.keySet()];
		system.debug('NokiaCPQ_AttachmentHandler appcList >> ' + appcList);
		system.debug('NokiaCPQ_AttachmentHandler accreList >> ' + accreList);
		system.debug('NokiaCPQ_AttachmentHandler eaList >> ' + eaList);
		if(!appcList.isEmpty())
		{
			for(Apttus_Proposal__Proposal__c appc : appcList)
			{
	for(Attachment att :  parentAttMap.get(appc.Id)) {
		system.debug('In attachment1');
		system.debug('In attachment2:'+appc.app_name__c);
		if(!att.Name.equalsIgnoreCase(appc.NokiaCPQ_Proposal_Id__c+Nokia_CPQ_Constants.xlsm)) {
			//att.Name = appc.app_name__C+ Nokia_CPQ_Constants.xlsm;
		}
		if(((appc.RecordTypeId ==Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('SWx_CCRE_Proposal_Read_Only').getRecordTypeId() || appc.RecordTypeId ==Schema.SObjectType.Apttus_Proposal__Proposal__c.getRecordTypeInfosByDeveloperName().get('CCRE_Proposal').getRecordTypeId()) && appc.app_name__C!=null  && appc.app_name__C.contains(CSWXGlobalConstant.EXPORT_PROPOSAL ))) {
			att.Name = appc.app_name__C+ Nokia_CPQ_Constants.xlsm;
		}

		appName = appc.app_name__C;
		accountid = appc.Apttus_Proposal__Account__c;

		if(att.Name.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_BOM_APP+appc.NokiaCPQ_Proposal_Id__c+Nokia_CPQ_Constants.xlsm)) {
			att.IsPrivate=True;
		}
		system.debug('App Name' + att.Name + '  Proposal Id  ' + appc.NokiaCPQ_Proposal_Id__c);

		//Marked PrM export as private
		if(att.Name != null && att.Name.contains(Nokia_CPQ_Constants.PRMEXPORT)) {
			att.IsPrivate=True;
		}

		//Marked LOA export as private
		if(att.Name != null && att.Name.contains(Nokia_CPQ_Constants.LOAEXPORT + appc.NokiaCPQ_Proposal_Id__c +Nokia_CPQ_Constants.xlsm)) {
			att.IsPrivate=True;
		}
		//Marked CSP export file as private
		if(att.Name != null && att.Name.contains(Nokia_CPQ_Constants.CSPEXPORT + appc.NokiaCPQ_Proposal_Id__c +Nokia_CPQ_Constants.xlsm)) {
			att.IsPrivate=True;
		}
	}
			}
		}

		else if(!accreList.isEmpty()) {
			String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
			for(Accreditation__c accre : accreList)
			{
	for(Attachment att : parentAttMap.get(accre.Id)) {
		system.debug('NokiaCPQ_AttachmentHandler accr att name >> ' + att.Name);
		accountid = accre.Partner__c;
		appName = accre.app_name__C;
		if((profileName.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PARTNER_PROFILE_NAME)||profileName.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PARTNER_RELATIONSHIP_MANAGER)) && (!att.Name.contains(Nokia_CPQ_Constants.NOKIA_Q2C))) {
			isPRM =true;
			shareAccount('Edit');
		}
		system.debug('NokiaCPQ_AttachmentHandler after >> ');
		//commented by Yashdeep as part of ITCCPQ-2264
		// if(att.Name.contains(Nokia_CPQ_Constants.NOKIA_Q2C)) {
		// 	att.IsPrivate=True;
		// }
	}
			}
		}
		//added by Yashdeep as part of ITCCPQ-2264
		else if(!eaList.isEmpty()) {
			system.debug('NokiaCPQ_AttachmentHandler inside ea >> ');
			String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
			for(CPQ_ExportAttach__c ea : eaList)
			{
	system.debug('NokiaCPQ_AttachmentHandler ea >> ' + ea);
	for(Attachment att :  parentAttMap.get(ea.Id)) {
		system.debug('NokiaCPQ_AttachmentHandler name >> ' + att.Name);
		accountid = ea.CPQ_Account__c;
		if(!att.Name.contains(Nokia_CPQ_Constants.NOKIA_ACCR_PRICE_EXPORT)) {
			att.IsPrivate=True;
		}
		if((profileName.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PARTNER_PROFILE_NAME)||profileName.equalsIgnoreCase(Nokia_CPQ_Constants.NOKIA_PARTNER_RELATIONSHIP_MANAGER)) && (att.Name.contains(Nokia_CPQ_Constants.NOKIA_ACCR_PRICE_EXPORT))) {
			isPRM =true;
			shareAccount('Edit');
		}
	}
			}
		}
	} catch(Exception e) {
		system.debug('NokiaCPQ_AttachmentHandler ex >> ' + e);
		ExceptionHandler.addException(e,NokiaCPQ_AttachmentHandler.class.getName(),GlobalConstants.ERRORVK);
	}

}

/***************************************
 * Method Name: getAccountID
 * Description: Returns AccountId
 * Parameters: NA
 *****************************************/
/*	public static String getAccountID(){
				return accountid;
		} */

/***************************************
 * Method Name: getAppName
 * Description: Returns appName
 * Parameters: NA
 *****************************************/
public static String getAppName(){
	return appName;
}

public static Boolean getIsPRM(){
	return isPRM;
}

/***************************************
 * Method Name: shareAccount
 * Description: Returns None
 * Parameters: NA
 *****************************************/
public static void shareAccount(string access){

	try{
		AccountShare thisAccountShare = new AccountShare();		 //a new empty AccountShare object
		thisAccountShare.UserOrGroupId = userinfo.getUserId();
		thisAccountShare.accountid = accountid;
		thisAccountShare.accountaccesslevel = access;
		thisAccountShare.CaseAccessLevel = 'None';
		thisAccountShare.ContactAccessLevel = access;
		thisAccountShare.OpportunityAccessLevel = 'None';
		insert thisAccountShare;
	}catch(Exception e) {
		ExceptionHandler.addException(e,NokiaCPQ_AttachmentHandler.class.getName(),GlobalConstants.ERRORVK);

	}

}
}