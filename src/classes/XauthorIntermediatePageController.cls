/****************************************
 * Class Name : XauthorIntermediatePageController
 * Created Date: 8 December 2017
 * Created By : Accenture
 * Description : XauthorIntermediatePageController
 * Test Class: XauthorIntermediatePageControllerTest
 *****************************************/
public without sharing class XauthorIntermediatePageController {
String app = ApexPages.currentPage().getParameters().get(Nokia_CPQ_Constants.NOKIA_APPNAME);
String qId = ApexPages.currentPage().getParameters().get(Nokia_CPQ_Constants.NOKIA_SELECTED_RECORD_ID);
String accId;
List<Apttus_Proposal__Proposal__c> quoteList = [select id,name,App_Name__c,NokiaCPQ_Proposal_Id__c, Version__c from Apttus_Proposal__Proposal__c where id =: qId Limit : limits.getLimitQueryRows()];
List<Accreditation__c> accreList = [select id,App_Name__c,Partner__c,Partner_Type__c,Partner_Program__c,Portfolio__c,Pricing_Cluster__c,Pricing_Accreditation__c from Accreditation__c where id =: qId Limit : limits.getLimitQueryRows()];
Custom_Constant_Field__c customConstantField = Custom_Constant_Field__c.getOrgDefaults();

/*********************************
 * author: Accenture
 * Date: 29 MAR 2018
 * Param: None
 * Return: None
 * Description: updateAppName
 * High Level Process :
 **********************************/
public PageReference updateAppName()
{
	/* commented as the variables are not used
	id id1 = userinfo.getUserId();
	id id2 = userinfo.getProfileId();
	String pf=[Select Id,Name from Profile where Id=:id2].Name;
	//when attachment is on quote(Apttus_Proposal__Proposal__c) object*/
	PageReference pg;
	system.debug('app:'+app);
	system.debug('quoteList:'+quoteList);
	try{

		if(!quoteList.isEmpty() && !String.isBlank(app)) {
			for(Apttus_Proposal__Proposal__c quote : quoteList) {

	if(Nokia_CPQ_Constants.NOKIA_EXPORTQUOTE == app)
		quote.App_Name__c = quote.NokiaCPQ_Proposal_Id__c;
	else if(Nokia_CPQ_Constants.NOKIA_BOMNONMPW == app)
		quote.App_Name__c = Nokia_CPQ_Constants.NOKIA_BOM + Nokia_CPQ_Constants.NOKIA_UNDERSCORE + quote.NokiaCPQ_Proposal_Id__c;
	else if(Nokia_CPQ_Constants.NOKIA_DIRECTEXPORTQUOTE == app)
		quote.App_Name__c = quote.NokiaCPQ_Proposal_Id__c;
	else if(Nokia_CPQ_Constants.NOKIA_CSPEXPORT == app)
		quote.App_Name__c = Nokia_CPQ_Constants.NOKIA_CSPEXPORT + Nokia_CPQ_Constants.NOKIA_UNDERSCORE + quote.NokiaCPQ_Proposal_Id__c;
	else if(CSWXGlobalConstant.DOWNLOAD_OFFER ==app)
		quote.App_Name__c = CSWXGlobalConstant.EXPORT_PROPOSAL  + Nokia_CPQ_Constants.NOKIA_UNDERSCORE + quote.NokiaCPQ_Proposal_Id__c+ Nokia_CPQ_Constants.NOKIA_UNDERSCORE + CSWXGlobalConstant.string_v +quote.Version__c;
	else if(Nokia_CPQ_Constants.NOKIA_BASICEXPORTQUOTE == app)		 //Added by RG for Req 6611
		quote.App_Name__c = quote.NokiaCPQ_Proposal_Id__c;

			}
			update quoteList;
		}
		//when attachment is on Accreditation(Accreditation__c) object
		else if(!accreList.isEmpty() && !String.isBlank(app)) {
			for(Accreditation__c accre : accreList) {
	if(Nokia_CPQ_Constants.NOKIA_PRICECATALOGEXPORT == app)
		accre.App_Name__c = Nokia_CPQ_Constants.PRODUCTCATALOG + Nokia_CPQ_Constants.NOKIA_UNDERSCORE + accre.Portfolio__c;
	if(app.contains(Nokia_CPQ_Constants.NOKIA_ACCRED_TYPE_MAINTENANCE))
		accre.App_Name__c = Nokia_CPQ_Constants.NOKIA_MAINTENANCE_CATALOGUE + accre.Portfolio__c;
	if(Nokia_CPQ_Constants.NOKIA_ORDERGENERATION == app)
		accre.App_Name__c = accre.Pricing_Cluster__c + Nokia_CPQ_Constants.BLANK_STRING +accre.Portfolio__c + Nokia_CPQ_Constants.BLANK_STRING + accre.Partner_Program__c + Nokia_CPQ_Constants.BLANK_STRING + Nokia_CPQ_Constants.NOKIA_PPA +accre.Partner_Type__c + Nokia_CPQ_Constants.BLANK_STRING + accre.Pricing_Accreditation__c;
			}
			update accreList;
		}

		if(app.equalsIgnorecase(Nokia_CPQ_Constants.NOKIA_EXPORTQUOTE) ||app.equalsIgnorecase(Nokia_CPQ_Constants.NOKIA_BASICEXPORTQUOTE) || app.equalsIgnorecase(Nokia_CPQ_Constants.NOKIA_ORDERGENERATION) || app.equalsIgnorecase(Nokia_CPQ_Constants.NOKIA_BOMNONMPW ) || app.equalsIgnorecase(Nokia_CPQ_Constants.NOKIA_BOMMPW) ) {
			pg = new PageReference(Nokia_CPQ_Constants.NOKIA_URL_PART1 + qId + Nokia_CPQ_Constants.NOKIA_URL_PART2 + app + Nokia_CPQ_Constants.NOKIA_URL_PART4);
		}
		else{
			pg = new PageReference(Nokia_CPQ_Constants.NOKIA_URL_PART1 + qId + Nokia_CPQ_Constants.NOKIA_URL_PART2 + app + Nokia_CPQ_Constants.NOKIA_URL_PART3);
		}
	}

	catch(Exception ex) {
		ExceptionHandler.addException(ex,XauthorIntermediatePageController.class.getName(),Nokia_CPQ_Constants.QUOTE_NOT_FOUND);
	}

	return pg;
}
}