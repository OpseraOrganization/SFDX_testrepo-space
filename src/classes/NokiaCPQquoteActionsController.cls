/******************************
 * Author : Piyush
 * Date : September - 2018
 * Description : The class controls the link and visibility of Quote Action Lightning Component
 *******************************/
public without sharing class NokiaCPQquoteActionsController {

	/***************************
	* Description : The method returns proposal onject.
	* Parameter passed : proposalId
	* return : Apttus_Proposal__Proposal__c object
	***************************/
	@AuraEnabled
	public static Apttus_Proposal__Proposal__c getProposal(Id proposalId) {
		Apttus_Proposal__Proposal__c proposalObj = new Apttus_Proposal__Proposal__c();
		try{
			List<Apttus_Proposal__Proposal__c> proposals
	 = [SELECT Id, Name,NokiaCPQ_Needs_Reprice__c, Apttus_Proposal__Primary__c,NokiaCPQ_Is_Maintenance_Quote__c, Make_Primary_Button_Field__c, IsCollaborationProgress__c, Direct_Price_List_Number__c,
	 Configure_Collaboration_Button_Field__c, Configure_button_field__c,Accept_Button_Field__c, LOA_Export__c,CPQ_NCQ_Check__c,CPQ_CQ_Check__c,
	 Export_Quote_Button_Field__c,NokiaCPQ_Environment_Access_Type__c, Customer_Export_Quote_with_BOQ_and_CLP__c,
	 Roll_Up_Of_Proposal_Line_Item__c,Quote_Type__c, Bill_of_Material_Button_Field__c, Internal_Detailed_Quote_Export_for_PrM__c,
	 CSP_Export_Button_Field__c, Apttus_Proposal__Approval_Stage__c, Configure_grid_flow_button__c, NokiaCPQ_Portfolio__c,Quote_Status__c,
	 NokiaCPQ_Configure_Products_button_field__c, Customer_Quote_Export_with_BOQ__c, NokiaCPQ_Proposal_Id__c,Apttus_QPConfig__ConfigurationFinalizedDate__c,Basic_Quote_Export__c,NokiaCPQ_Approval_Required_Flag__c,
	 NokiaCPQ_LEO_Discount__c,SRS__c,SSP__c,Maintenance_Y1__c,Maintenance_Y2__c,NokiaCPQ_CAD__c,NokiaCPQ_has_Partner_Certified__c,Apttus_QPApprov__Approval_Status__c,Custom_Product_Quote__c,Indirect_Approval_Required__c,APTS_ConfigureProductsTP__c,Is_Classic_Pricing__c,Is_Turbo_Pricing__c,Turbo_Pricing_Enable__c,Classic_Pricing_Enable__c,NokiaCPQ_Geo_Level_1_ID__c,NokiaCPQ_SAPIntegrationStatus__c,NokiaCPQ_SAPIntegrationStatusDescription__c FROM Apttus_Proposal__Proposal__c
	 WHERE Id =: proposalId LIMIT 1];
	
			if(!proposals.isEmpty()) {
	proposalObj = proposals[0];
	
			} else {
	proposalObj = null;
			}
		}
	
	
	
	
	
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
		}
		return proposalObj;
	}
	
	/***************************
	* Description : The method to Generate Site Id on Proposal Line Item and return value as updated or not.
	* Parameter passed : proposalId
	* return : String
	***************************/
	
	@AuraEnabled
	public Static string generateSiteId(Id proposalId) {
		String LineItem;
		String QDSI;
		String PLIs;
		try{
			LineItem = updatePLIandQDSI(proposalId);
	
	
	
	
	
		}
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
			LineItem= 'Error'+ e.getMessage();
		}
		return LineItem;
	}
	
	/***************************
	* Description : The method returns config button URL.
	* Parameter passed : recordIdVar
	* return : String
	***************************/
	@AuraEnabled
	public static String configureMethod(String recordIdVar){
	
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		String readOnly = '&mode=readOnly';
		String configure = 'Classic';
		try{
			String retResult = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			String baseUrl = System.URL.getSalesforceBaseUrl().ToExternalForm();
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
			List<Apttus_Config2__LineItem__c> lineitemsHidden = New list<Apttus_Config2__LineItem__c>();
			List<Apttus_Config2__LineItem__c> updateLineItemsHidden = New list<Apttus_Config2__LineItem__c>();
			quoteObj = [Select Id, CPQ_NCQ_Check__c, Name, CPQ_Configure_Products_SNCQ__c, Apttus_QPConfig__IsTaskPending__c, NokiaCPQ_Is_Maintenance_Quote__c,Configure_button_field__c,NokiaCPQ_Environment_Access_Type__c,Apttus_QPConfig__ConfigurationFinalizedDate__c,Is_Classic_Pricing__c, Is_Turbo_Pricing__c from Apttus_Proposal__Proposal__c where Id =: recordIdvar Limit 1];
			//Imran Wipro -- Moved below code to UpdateConfigurebutton method
			//Workaround Majid for Apttus case 00104031 D-14586 START
			//if(quoteObj.Apttus_QPConfig__IsTaskPending__c){
			//  update new Apttus_Proposal__Proposal__c(id=quoteObj.id, Apttus_QPConfig__IsTaskPending__c = false);
			// }
			//Workaround Majid for Apttus case 00104031 D-14586 END
			//Added by Imran Wipro
			UpdateConfigurebutton(recordIdvar,configure,quoteObj);
			retResult = quoteObj.Configure_button_field__c;
			//system.debug('retResult-->'+baseUrl+retResult);
			if(quoteObj.NokiaCPQ_Environment_Access_Type__c.equals(Nokia_CPQ_Constants.SCRM)) {
	finalString = baseUrl+retResult;
	
			}
	
			else{
	finalString = retResult;
			}
			//Yashdeep- commented as part of 1885
			//Heema: 6383 req
			// if(quoteObj.NokiaCPQ_Is_Maintenance_Quote__c== true && quoteObj.Apttus_QPConfig__ConfigurationFinalizedDate__c!=null){
			//   finalString = NokiaCPQquoteActionsController.viewProductsMethod(recordIdVar);
			// }
	
	
	
	
	
		}
	
	
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
		return finalString;
	}
	/***************************
	* Added as per NPT button on Quote requirement
	* Description : The method returns NPT response
	* Parameter passed : QuoteId
	* return : String
	***************************/
	@AuraEnabled
	public static String callSendBomToNPT(String recordIdVar){
	
		String returnString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
	
		try{
			system.debug('quoteIdTop1 :--- ' +recordIdVar);
			Apttus_Config2__ProductConfiguration__c prodConfig = new Apttus_Config2__ProductConfiguration__c();
	
			prodConfig = [Select Id, Name from Apttus_Config2__ProductConfiguration__c where Apttus_QPConfig__Proposald__c =: recordIdVar AND Apttus_Config2__Status__c = 'Finalized' Limit 1]; //AND Apttus_Config2__Status__c = 'Finalized'
			NokiaCPQSendBOMNPTController nptController= new NokiaCPQSendBOMNPTController();
			system.debug('prodConfig :--- '+prodConfig.id);
			system.debug('quoteId :--- ' +recordIdVar );
			nptController.NokiaCPQSendBOMNPTControllerAction(prodConfig.Id);
			returnString = 'Success';
		}
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
			returnString = Nokia_CPQ_Constants.ERROR_MSD;
		}
	
		return returnString;
	}
	/***************************
	* Description : The method returns Turbo config button URL.
	* Parameter passed : recordIdVar
	* return : String
	* Author : Imran Wipro
	***************************/
	
	@AuraEnabled
	public static String configureTurboserver(String recordIdVar)
	{
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		try
		{
			String configure = 'Turbo';
			String retResult = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			String baseUrl = System.URL.getSalesforceBaseUrl().ToExternalForm();
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
			quoteObj = [Select Id,Name,CPQ_CQ_Check__c,CPQ_Configure_Products_SNCQ_Turbo__c,Quote_Type__c,Configure_button_field_TP__c,Apttus_QPConfig__IsTaskPending__c,APTS_ConfigureProductsTP__c,NokiaCPQ_Environment_Access_Type__c,Is_Classic_Pricing__c,Is_Turbo_Pricing__c
	  from Apttus_Proposal__Proposal__c where Id =: recordIdvar Limit 1];
			/*if(quoteObj.Apttus_QPConfig__IsTaskPending__c){
		 update new Apttus_Proposal__Proposal__c(id=quoteObj.id, Apttus_QPConfig__IsTaskPending__c = false);
		 }*/
			UpdateConfigurebutton(recordIdvar,configure,quoteObj);
			// Added by Nandeesh for partners
			if(quoteObj.Quote_Type__c == 'Direct CPQ') {
	retResult = quoteObj.APTS_ConfigureProductsTP__c;
			}else if(quoteObj.CPQ_CQ_Check__c) {
	retResult = quoteObj.CPQ_Configure_Products_SNCQ_Turbo__c;
			}else{
	retResult = quoteObj.Configure_button_field_TP__c;
			}
			//system.debug('Base Url -->'+baseUrl);
			//system.debug('Append Url -->'+retResult);
			if(quoteObj.NokiaCPQ_Environment_Access_Type__c.equals(Nokia_CPQ_Constants.SCRM))
	finalString = baseUrl+retResult;
			else
	finalString = retResult;
	
		}
		catch(Exception e)
		{
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
		}
		system.debug('Final string -->'+finalString);
		return finalString;
	}
	/***************************
	* Description : update Apttus_QPConfig__IsTaskPending__c,Update Is_Turbo_Pricing__c, Is_Classic_Pricing__c fields
	* return :
	* Author: Imran Wipro
	***************************/
	@AuraEnabled
	public static String UpdateConfigurebutton(Id proposalId,string configure,Apttus_Proposal__Proposal__c quoteObj){
		String returnValue ='SUCCESS';
		try{
			//Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
			//quoteObj = [Select Id, Name, Is_Classic_Pricing__c,Is_Turbo_Pricing__c from Apttus_Proposal__Proposal__c where Id=:proposalId Limit 1];
	
			if(quoteObj.Apttus_QPConfig__IsTaskPending__c)
	quoteobj.Apttus_QPConfig__IsTaskPending__c = false;
			if(configure == 'Turbo')
			{
	quoteobj.Is_Turbo_Pricing__c = true;
	quoteobj.Is_Classic_Pricing__c = false;
			}
			else
			{
	quoteobj.Is_Turbo_Pricing__c = false;
	quoteobj.Is_Classic_Pricing__c = true;
			}
	
			database.update(quoteObj);
		}
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
			returnValue = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ERROR_STRING +e.getMessage();
		}
		return returnValue;
	}
	
	/***************************
	* Description : Fetch Quote Configuration record
	* return :
	* Author: Imran Wipro
	***************************/
	@AuraEnabled
	public static String QueryConfiguration(String recordIdVar){
		String retResult = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		system.debug('Start QueryConfiguration-->'+recordIdVar);
		try{
			//Apttus_Config2__ProductConfiguration__c ConfigObj = new Apttus_Config2__ProductConfiguration__c ();
			//ConfigObj = [SELECT Id,Apttus_QPConfig__Proposald__c FROM Apttus_Config2__ProductConfiguration__c WHERE Apttus_QPConfig__Proposald__c =: recordIdvar Limit 1];
			//retResult = ConfigObj.Apttus_QPConfig__Proposald__c;
			//retResult = ConfigObj.Id;
			List<Apttus_Config2__ProductConfiguration__c> ConfigObj = [SELECT Id,Apttus_QPConfig__Proposald__c FROM Apttus_Config2__ProductConfiguration__c 
						WHERE Apttus_QPConfig__Proposald__c =: recordIdvar Limit 1];
			if(ConfigObj.size()>0){
	retResult = ConfigObj[0].Apttus_QPConfig__Proposald__c;
			}
			
			system.debug('retResult-->'+retResult);
		}
		catch(Exception e)
		{
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
		}
		return retResult;
	}
	
	
	/***************************
	* Description : Fetch Is Classic Pricing and Is Turbo Pricing values
	* return :
	* Author: Imran Wipro
	***************************/
	@AuraEnabled
	public static Boolean QueryQuoteRecord(String recordIdVar){
		Boolean retResult = false;
		system.debug('Start QueryConfiguration-->'+recordIdVar);
		try{
			Apttus_Proposal__Proposal__c QuoteObj = new Apttus_Proposal__Proposal__c ();
			QuoteObj = [SELECT Id,Is_Classic_Pricing__c,Is_Turbo_Pricing__c FROM Apttus_Proposal__Proposal__c WHERE Id =: recordIdvar Limit 1];
			if(QuoteObj.Is_Classic_Pricing__c == false && QuoteObj.Is_Turbo_Pricing__c == false)
			{
	retResult = true;
			}
			system.debug('retResult-->'+retResult);
		}
		catch(Exception e)
		{
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
		}
		return retResult;
	}
	
	
	
	/***************************
	
	
	
	* Description : The method returns config button direct URL.
	* Parameter passed : recordIdVar
	* return : String
	***************************/
	@AuraEnabled
	public static String configureMethodDirect(String recordIdVar){
	
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		String configure = 'Classic';
		try{
			String retResult = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			String baseUrl = System.URL.getSalesforceBaseUrl().ToExternalForm();
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
	
			quoteObj = [Select Id, CPQ_NCQ_Check__c, Name, Apttus_QPConfig__IsTaskPending__c, Configure_grid_flow_button__c, NokiaCPQ_Environment_Access_Type__c, Is_Classic_Pricing__c, Is_Turbo_Pricing__c from Apttus_Proposal__Proposal__c where Id =: recordIdvar Limit 1];
			//Imran Wipro -- Moved below code to UpdateConfigurebutton method
			//Workaround Majid for Apttus case 00104031 D-14586 START
			//if(quoteObj.Apttus_QPConfig__IsTaskPending__c){
			//  update new Apttus_Proposal__Proposal__c(id=quoteObj.id, Apttus_QPConfig__IsTaskPending__c = false);
			//}
			//Workaround Majid for Apttus case 00104031 D-14586 END
			UpdateConfigurebutton(recordIdvar,configure,quoteObj);
			retResult = quoteObj.Configure_grid_flow_button__c;
			system.debug('retResult-->'+retResult);
			system.debug('retResult-->'+baseUrl);
			if (quoteObj.CPQ_NCQ_Check__c == false && quoteObj.NokiaCPQ_Environment_Access_Type__c.equals(Nokia_CPQ_Constants.SCRM)) {
	finalString = baseUrl + retResult;
			} else if (quoteObj.CPQ_NCQ_Check__c == true) {
	finalString = baseUrl + retResult;
			} else {
	finalString = retResult;
			}
	
		}
	
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
		return finalString;
	
	}
	
	/***************************
	* Description : The method returns Collaboration URL.
	* Parameter passed : recordIdVar
	* return : String
	***************************/
	@AuraEnabled
	public static String configureCollaboration(String recordIdVar){
	
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		try{
			String retResult = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			String baseUrl = System.URL.getSalesforceBaseUrl().ToExternalForm();
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
	
			quoteObj = [Select Id, Name, Apttus_QPConfig__IsTaskPending__c, Configure_Collaboration_Button_Field__c, NokiaCPQ_Environment_Access_Type__c from Apttus_Proposal__Proposal__c where Id =: recordIdvar Limit 1];
			//Workaround Majid for Apttus case 00104031 D-14586 START
			if(quoteObj.Apttus_QPConfig__IsTaskPending__c) {
	update new Apttus_Proposal__Proposal__c(id=quoteObj.id, Apttus_QPConfig__IsTaskPending__c = false);
			}
			//Workaround Majid for Apttus case 00104031 D-14586 END
			retResult = quoteObj.Configure_Collaboration_Button_Field__c;
			//system.debug('retResult-->'+baseUrl+retResult);
			if(quoteObj.NokiaCPQ_Environment_Access_Type__c.equals(Nokia_CPQ_Constants.SCRM)) {
	finalString = baseUrl+retResult;
			}
			else{
	finalString = retResult;
			}
	
	
	
	
	
	
	
		}
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
		return finalString;
	
	}
	
	/***************************
	* Description : The method returns make primary URL.
	* Parameter passed : recordIdVar
	* return : String
	***************************/
	@AuraEnabled
	public static String makePrimaryMethod(String recordIdVar){
	
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		try{
			String retResult = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			String baseUrl = System.URL.getSalesforceBaseUrl().ToExternalForm();
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
			quoteObj = [Select Id, Name, Make_Primary_Button_Field__c,NokiaCPQ_Environment_Access_Type__c from Apttus_Proposal__Proposal__c where Id =: recordIdvar Limit 1];
			retResult = quoteObj.Make_Primary_Button_Field__c;
			system.debug('retResult-->'+baseUrl+retResult);
			if(quoteObj.NokiaCPQ_Environment_Access_Type__c.equals(Nokia_CPQ_Constants.SCRM)) {
	finalString = baseUrl+retResult;
			}
			else{
	finalString = retResult;
			}
		}
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
		return finalString;
	}
	
	/***************************
	* Description : The method returns bom export URL.
	* Parameter passed : recordIdVar
	* return : String
	***************************/
	@AuraEnabled
	public static String bomExportMethod(String recordIdVar){
	
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		try{
			String retResult = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			String baseUrl = System.URL.getSalesforceBaseUrl().ToExternalForm();
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
	
			quoteObj = [Select Id, Name, Bill_of_Material_Button_Field__c,NokiaCPQ_Environment_Access_Type__c from Apttus_Proposal__Proposal__c where Id=:recordIdVar Limit 1];
			retResult = quoteObj.Bill_of_Material_Button_Field__c;
			//system.debug('retResult-->'+baseUrl+retResult);
			if(quoteObj.NokiaCPQ_Environment_Access_Type__c.equals(Nokia_CPQ_Constants.SCRM)) {
	finalString = baseUrl+retResult;
			}
			else{
	finalString = retResult;
			}
	
	
	
	
	
		}
	
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
		return finalString;
	}
	
	/***************************
	* Description : The method returns Advance Quote export URL.
	* Parameter passed : recordIdVar
	* return : String
	***************************/
	@AuraEnabled
	public static String quoteExportMethod(String recordIdVar){
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		try{
			String retResult = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			String baseUrl = System.URL.getSalesforceBaseUrl().ToExternalForm();
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
	
			quoteObj = [Select Id, Name, Export_Quote_Button_Field__c,NokiaCPQ_Environment_Access_Type__c from Apttus_Proposal__Proposal__c where Id=:recordIdVar Limit 1];
			retResult = quoteObj.Export_Quote_Button_Field__c;
			//system.debug('retResult-->'+baseUrl+retResult);
			if(quoteObj.NokiaCPQ_Environment_Access_Type__c.equals(Nokia_CPQ_Constants.SCRM)) {
	finalString = baseUrl+retResult;
			}
			else{
	finalString = retResult;
			}
	
	
	
	
	
	
		}
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
		return finalString;
	}
	
	//RG Start:Renamed for Req-6611
	/***************************
	* Description : The method returns Basic Quote export URL.
	* Parameter passed : recordIdVar
	* return : String
	***************************/
	@AuraEnabled
	public static String basicquoteExportMethod(String recordIdVar){
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		try{
			String retResult = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			String baseUrl = System.URL.getSalesforceBaseUrl().ToExternalForm();
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
	
			quoteObj = [Select Id, Name, Basic_Quote_Export__c,NokiaCPQ_Environment_Access_Type__c from Apttus_Proposal__Proposal__c where Id=:recordIdVar Limit 1];
			retResult = quoteObj.Basic_Quote_Export__c;
			//system.debug('retResult-->'+baseUrl+retResult);
			if(quoteObj.NokiaCPQ_Environment_Access_Type__c.equals(Nokia_CPQ_Constants.SCRM)) {
	finalString = baseUrl+retResult;
			}
			else{
	finalString = retResult;
			}
	
	
	
	
	
	
		}
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
		return finalString;
	}
	//RG End:Renamed for Req-6611
	
	/***************************
	* Description : The method returns Basic Quote export URL.
	* Parameter passed : recordIdVar
	* return : String
	***************************/
	@AuraEnabled
	public static String submitForApprovalMethod(String recordIdVar){
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		try{
			finalString = '/apex/NokiaCPQ_Submit_For_Approval?quoteId='+recordIdVar;
	
	
	
	
	
	
	
		}
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
		return finalString;
	}
	
	/***************************
	* Description : The method returns Accept button URL.
	* Parameter passed : recordIdVar
	* return : String
	***************************/
	
	/* Modified by Christie for ITCCPQ - 677 */
	
	@AuraEnabled
	public static String acceptMethod(String recordIdVar){
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		try{
			String retResult = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			String baseUrl = System.URL.getSalesforceBaseUrl().ToExternalForm();
			String region = '';
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
	
			quoteObj = [Select Id, Name, Accept_Button_Field__c,NokiaCPQ_Environment_Access_Type__c,Quote_Type__c,NokiaCPQ_Geo_Level_1_ID__c from Apttus_Proposal__Proposal__c where Id=:recordIdVar Limit 1];
			retResult = quoteObj.Accept_Button_Field__c;
			if(quoteObj.NokiaCPQ_Geo_Level_1_ID__c == 'RG_NAM')
	region = Nokia_CPQ_Constants.TRUE_STRING;
			else
	region = Nokia_CPQ_Constants.FALSE_CONSTANT;
	
			//system.debug('retResult-->'+baseUrl+retResult);
			if(quoteObj.NokiaCPQ_Environment_Access_Type__c.equals(Nokia_CPQ_Constants.SCRM)) {
	finalString = baseUrl+retResult;
			}
			else{
	finalString = retResult;
			}
	
			//Added for ITCCPQ - 677
			String quoteType = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			quoteType = quoteObj.Quote_Type__c;
			finalString = finalString + Nokia_CPQ_Constants.QTC_FILE_COLUMN_SEPERATOR + quoteType + Nokia_CPQ_Constants.QTC_FILE_COLUMN_SEPERATOR + region;
	
	
	
	
		}
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
		return finalString;
	
	}
	
	/***************************
	* Description : The method returns CSP Export URL.
	* Parameter passed : recordIdVar
	* return : String
	***************************/
	@AuraEnabled
	public static string cspExportMethod(String recordIdVar, String appName){
	
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		String filePath;
		try{
			//system.debug('cspExportMethod called');
			NokiaCPQ_CSP_Export_Generator.PLIbundleOptionMapping(recordIdVar);
			filePath = '/apex/Apttus_XApps__EditInExcelLaunch?selectedRecordId='+recordIdVar+'&appName=CSPExportp20&mode=touchless&outputType=None';
	
			// 29.07.2019 : AJ: as the statement for Quote Rec. Type check was commented way before, comenting the SOQL from line 289 as there is no use of this SOQL in this function.
			//Apttus_Proposal__Proposal__c proposals = [SELECT Id, Quote_Type__c,NokiaCPQ_Proposal_Id__c FROM Apttus_Proposal__Proposal__c WHERE Id =: recordIdVar];
			//if(proposals.Quote_Type__c.equalsIgnoreCase('Indirect CPQ')){
			// 29.07.2019: AJ: as new lightning component is created for Product Status check, removing old logic to execute prod check from line no. : 292
			//filePath = '/apex/ValidateCSPExport?id='+recordIdVar+'&appName=CSPExportp20';
			//}
			/*else{
		 filePath = '/apex/ValidateCSPExport?id='+recordIdVar+'&appName=CSPExportp20';
		 //filePath = '/apex/Apttus_XApps__EditInExcelLaunch?selectedRecordId='+recordIdVar+'&appName=CSPExportp20&mode=touchless&outputType=None';
		 }*/
	
	
	
	
		}
	
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName()+e.getLineNumber()+e.getMessage(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
		return filePath;
	
	}
	
	/***************************
	* Description : The method returns View Products URL.
	* Parameter passed : recordIdVar
	* return : String
	***************************/
	@AuraEnabled
	public static String viewProductsMethod(String recordIdVar){
	
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		try{
			String retResult = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			String baseUrl = System.URL.getSalesforceBaseUrl().ToExternalForm();
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
	
			quoteObj = [Select Id, Name, Apttus_QPConfig__IsTaskPending__c, NokiaCPQ_View_Products_Pricing_Button__c, NokiaCPQ_Environment_Access_Type__c from Apttus_Proposal__Proposal__c where Id=:recordIdVar Limit 1];
			//Workaround Majid for Apttus case 00104031 D-14586 START
			if(quoteObj.Apttus_QPConfig__IsTaskPending__c) {
	update new Apttus_Proposal__Proposal__c(id=quoteObj.id, Apttus_QPConfig__IsTaskPending__c = false);
			}
			//Workaround Majid for Apttus case 00104031 D-14586 END
			retResult = quoteObj.NokiaCPQ_View_Products_Pricing_Button__c;
			//system.debug('retResult-->'+baseUrl+retResult);
			if(quoteObj.NokiaCPQ_Environment_Access_Type__c.equals(Nokia_CPQ_Constants.SCRM)) {
	finalString = baseUrl+retResult;
			}
			else{
	finalString = retResult;
			}
	
	
	
	
	
	
	
		}
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
		return finalString;
	
	}
	
	/***************************
	* Description : The method returns View Products URL for Direct quotes.
	* Parameter passed : recordIdVar
	* return : String
	***************************/
	@AuraEnabled
	public static String viewProductsDirectMethod(String recordIdVar){
	
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		try{
			String retResult = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			String baseUrl = System.URL.getSalesforceBaseUrl().ToExternalForm();
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
	
			quoteObj = [Select Id, Name, Apttus_QPConfig__IsTaskPending__c, NokiaCPQ_Configure_Products_Read_Button__c, NokiaCPQ_Environment_Access_Type__c from Apttus_Proposal__Proposal__c where Id=:recordIdVar Limit 1];
			//Workaround Majid for Apttus case 00104031 D-14586 START
			if(quoteObj.Apttus_QPConfig__IsTaskPending__c) {
	update new Apttus_Proposal__Proposal__c(id=quoteObj.id, Apttus_QPConfig__IsTaskPending__c = false);
			}
			//Workaround Majid for Apttus case 00104031 D-14586 END
			retResult = quoteObj.NokiaCPQ_Configure_Products_Read_Button__c;
			//system.debug('retResult-->'+baseUrl+retResult);
			if(quoteObj.NokiaCPQ_Environment_Access_Type__c.equals(Nokia_CPQ_Constants.SCRM)) {
	finalString = baseUrl+retResult;
			}
			else{
	finalString = retResult;
			}
	
	
	
	
	
		}
	
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
		return finalString;
	
	}
	
	/***************************
	* Description : The method returns the Access of Internal_Detailed_Quote_Export_for_PrM__c field to the current user.
	* Parameter passed : null
	* return : String
	***************************/
	@AuraEnabled
	public static Boolean returnProfileName(){
	
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		Boolean returnVal = False;
		try{
			SObjectType schemaType = Schema.getGlobalDescribe().get(Nokia_CPQ_Constants.PROPOSAL_OBJECT);
			Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();
			DescribeFieldResult fieldDescribe = fields.get(Nokia_CPQ_Constants.PRM_QUOTE_BUTTON).getDescribe();
			returnVal = fieldDescribe.isAccessible();
	
	
	
	
	
		}
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
		return returnVal;
	}
	
	
	/***************************
	* Description : The method returns Customer Simple Quote with BOQ button link.
	* Parameter passed : recordIdVar
	* return : String
	***************************/
	@AuraEnabled
	public static String boqExportreturn(String recordIdVar){
	
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		try{
			String retResult = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			String baseUrl = System.URL.getSalesforceBaseUrl().ToExternalForm();
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
	
			quoteObj = [Select Id, Name, Apttus_Proposal__Approval_Stage__c,Quote_Status__c,Customer_Quote_Export_with_BOQ__c, NokiaCPQ_Environment_Access_Type__c from Apttus_Proposal__Proposal__c where Id=:recordIdVar Limit 1];
			retResult = quoteObj.Customer_Quote_Export_with_BOQ__c;
			finalString = baseUrl+retResult;
	
	
	
	
	
	
	
		}
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
		return finalString;
	
	}
	
	/***************************
	* Description : The method returns Customer Simple Quote with BOQ and CLP.
	* Parameter passed : recordIdVar
	* return : String
	***************************/
	@AuraEnabled
	public static String boqClpExportReturn(String recordIdVar){
	
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		try{
			String retResult = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			String baseUrl = System.URL.getSalesforceBaseUrl().ToExternalForm();
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
	
			quoteObj = [Select Id, Name,  Apttus_Proposal__Approval_Stage__c,Quote_Status__c,Customer_Export_Quote_with_BOQ_and_CLP__c, NokiaCPQ_Environment_Access_Type__c from Apttus_Proposal__Proposal__c where Id=:recordIdVar Limit 1];
			retResult = quoteObj.Customer_Export_Quote_with_BOQ_and_CLP__c;
			finalString = baseUrl+retResult;
	
	
	
	
	
	
	
		}
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
		return finalString;
	
	}
	
	/***************************
	* Description : The method returns Internal Detailed Quote for PrM.
	* Parameter passed : recordIdVar
	* return : String
	***************************/
	@AuraEnabled
	public static String prmExportFunction(String recordIdVar){
	
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		try{
			String retResult = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			String baseUrl = System.URL.getSalesforceBaseUrl().ToExternalForm();
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
	
			quoteObj = [Select Id, Name,  Apttus_Proposal__Approval_Stage__c,Quote_Status__c,Internal_Detailed_Quote_Export_for_PrM__c, NokiaCPQ_Environment_Access_Type__c from Apttus_Proposal__Proposal__c where Id=:recordIdVar Limit 1];
			retResult = quoteObj.Internal_Detailed_Quote_Export_for_PrM__c;
			finalString = baseUrl+retResult;
	
	
	
	
	
	
	
		}
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
		return finalString;
	
	}
	
	/***************************
	* Description : The method returns the Access of LOA_Export__c field to the current user.
	* Parameter passed : null
	* return : String
	***************************/
	@AuraEnabled
	public static Boolean returnAccessLoaFile(){
	
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		Boolean returnVal = False;
		try{
			SObjectType schemaType = Schema.getGlobalDescribe().get(Nokia_CPQ_Constants.PROPOSAL_OBJECT);
			Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();
			DescribeFieldResult fieldDescribe = fields.get(Nokia_CPQ_Constants.LOA_QUOTE_BUTTON).getDescribe();
			returnVal = fieldDescribe.isAccessible();
	
	
	
	
	
		}
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
		return returnVal;
	}
	
	/***************************
	* Description : The method returns LoA File button link.
	* Parameter passed : recordIdVar
	* return : String
	***************************/
	@AuraEnabled
	public static String loaFileExportFunction(String recordIdVar){
	
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		try{
			String retResult = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			String baseUrl = System.URL.getSalesforceBaseUrl().ToExternalForm();
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
	
			quoteObj = [Select Id, Name, Apttus_Proposal__Approval_Stage__c,Quote_Status__c,LOA_Export__c, NokiaCPQ_Environment_Access_Type__c from Apttus_Proposal__Proposal__c where Id=:recordIdVar Limit 1];
			retResult = quoteObj.LOA_Export__c;
			finalString = baseUrl+retResult;
			system.debug('finalString'+finalString);
			if(quoteObj.Quote_Status__c =='Order') {
	quoteobj.Quote_Status__c = 'Closed';
			}
	
			system.debug('Quote_Status__c before' +quoteobj.Quote_Status__c);
			database.update(quoteObj);
			system.debug('Quote_Status__c after' +quoteobj.Quote_Status__c);
	
	
	
	
	
	
		}
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
		return finalString;
	
	}
	
	/***************************
	* Description : The method Delete the existing export result from 'Order export result for external system' object.
	*	and re generate the export record and generate the excel file.
	* Parameter passed : Proposal record ID, external system name
	* return : String
	***************************/
	@AuraEnabled
	public static String initiateOrderExportForAlliance(Id proposalId, String externalSystenName){
		String returnValue;
		List<Order_Export_Result_For_External_System__c> existingAllianceDataList = [SELECT Id, External_System_Name__c, Quote_Id__c FROM Order_Export_Result_For_External_System__c WHERE Quote_Id__c =: proposalId AND External_System_Name__c =:externalSystenName];
		try{
			// check existing records for the quote in output object.
			// If exists, Delete the existing record and re create new records for export.
			if(existingAllianceDataList.IsEmpty()) {
	returnValue = OrderExportProvider.intiateExportForAllianceSystem(externalSystenName, proposalId);
			}
			else{
	String operationOutcome = OrderExportProvider.deleteExistingAllianceOrderData(existingAllianceDataList);
	if(operationOutcome.contains(Nokia_CPQ_Constants.ALLIANCE_EXPORT_SUCCESS_STRING))
		returnValue = OrderExportProvider.intiateExportForAllianceSystem(externalSystenName, proposalId);
	
	else{
		// return error if Delete DML fails.
		returnValue = operationOutcome;
	}
			}
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
	
			quoteObj = [Select Id, Name, Apttus_Proposal__Approval_Stage__c,Quote_Status__c,LOA_Export__c, NokiaCPQ_Environment_Access_Type__c from Apttus_Proposal__Proposal__c where Id=:proposalId Limit 1];
			if(quoteObj.Quote_Status__c =='Order') {
	quoteobj.Quote_Status__c = 'Closed';
			}
	
			system.debug('Quote_Status__c before' +quoteobj.Quote_Status__c);
			database.update(quoteObj);
			system.debug('Quote_Status__c after' +quoteobj.Quote_Status__c);
	
	
	
	
	
		}
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
			returnValue = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ERROR_STRING +e.getMessage();
		}
	
		return returnValue;
	}
	
	/***************************
	* Description : To generate .txt file for QTC export
	* Parameter passed : Proposal record ID, Nokia Quote Id
	* return : String
	***************************/
	@AuraEnabled
	public static String initiateOrderExportForQTC(Id proposalId, String nokiaQuoteId){
		String returnValue;
	
		try{
			returnValue = OrderExportProvider.intiateExportForQTCSystem(proposalId, nokiaQuoteId);
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
	
			quoteObj = [Select Id, Name, Apttus_Proposal__Approval_Stage__c,Quote_Status__c,LOA_Export__c, NokiaCPQ_Environment_Access_Type__c from Apttus_Proposal__Proposal__c where Id=:proposalId Limit 1];
			if(quoteObj.Quote_Status__c =='Order') {
	quoteobj.Quote_Status__c = 'Closed';
			}
	
			system.debug('Quote_Status__c before' +quoteobj.Quote_Status__c);
			database.update(quoteObj);
			system.debug('Quote_Status__c after' +quoteobj.Quote_Status__c);
	
		}
	
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
			returnValue = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ERROR_STRING +e.getMessage();
		}
	
		return returnValue;
	}
	
	/***************************
	* Description : To generate .txt file for QTC SITE export
	* Parameter passed : Proposal record ID, Nokia Quote Id
	* return : String
	***************************/
	@AuraEnabled
	public static String initiateOrderExportForQTCSite(Id proposalId, String nokiaQuoteId){
		String returnValue = 'SUCCESS';
	
		try{
			returnValue = QTC_SiteXMLGeneration.generateQTCSITEFile(proposalId, nokiaQuoteId);
	
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
	
			quoteObj = [Select Id, Name, Apttus_Proposal__Approval_Stage__c,Quote_Status__c,LOA_Export__c, NokiaCPQ_Environment_Access_Type__c from Apttus_Proposal__Proposal__c where Id=:proposalId Limit 1];
			if(quoteObj.Quote_Status__c =='Order') {
	quoteobj.Quote_Status__c = 'Closed';
			}
	
			system.debug('Quote_Status__c before' +quoteobj.Quote_Status__c);
			database.update(quoteObj);
			system.debug('Quote_Status__c after' +quoteobj.Quote_Status__c);
		}
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
			returnValue = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ERROR_STRING +e.getMessage();
		}
	
		return returnValue;
	}
	
	/***************************
	* Description : Return true if user is PricingManager
	* return : Boolean
	***************************/
	@AuraEnabled
	public static Boolean isPricingManager(){
		Boolean isAdvancedMode= false;
		try{
			//For sys admin and global process admin
			String profileName = [SELECT Name FROM Profile WHERE Id =: UserInfo.getProfileId() LIMIT 1].Name;
			system.debug('##profileName' + profileName);
			if(profileName == GlobalConstants.SYSTEM_AdMINISTRATOR || profileName == GlobalConstants.GLOBAL_PROCESS_ADMIN_PROFILE) {
	isAdvancedMode = true;
			}
	
			//For Pricing Manager user and SDC Admin
			For(PermissionSetAssignment psa: [ SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = : Userinfo.getUserId()]){
	
	system.debug('##psa.PermissionSet.Name' + psa.PermissionSet.Name);
	if(psa.PermissionSet.Name.equals('Nokia_CPQ_Pricing_Manager') || psa.PermissionSet.Name.equals('CPQ_Admin'))
		isAdvancedMode  = true;
	
			}
		}
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
			isAdvancedMode = false;
		}
		system.debug('##isAdvancedMode##' + isAdvancedMode);
		return isAdvancedMode;
	}
	
	/***************************
	* Description : To send Quote and Proposal line items to EAI
	* Parameter passed : Proposal record ID, Nokia Quote Id
	* return : String
	***************************/
	@AuraEnabled
	public static String sendAddQuoteMessageToEAI(Id proposalId,String nokiaQuoteId){
		String returnValue='SUCCESS';
		Boolean sCustomProd;
		Map<String,String> taskValuesMap = new Map<String,String>();
		try{
			Set<Id> quoteIds = new Set<Id>();
			quoteIds.add(proposalId);
			//Imran --ITCEPP820  Custom Product validation
			List<Apttus_Proposal__Proposal_Line_Item__c> CustomProductlist = [select id,is_Custom_Product__c from Apttus_Proposal__Proposal_Line_Item__c
			where Apttus_Proposal__Proposal__c =:proposalId and Apttus_QPConfig__ParentBundleNumber__c = null and is_Custom_Product__c = true
				 order by Apttus_QPConfig__ParentBundleNumber__c asc nulls first];
			if(CustomProductlist <> null) {
	for(Apttus_Proposal__Proposal_Line_Item__c pliCustomBundleItem : CustomProductlist) {
		if(pliCustomBundleItem.is_Custom_Product__c == true) {
			returnValue ='ERROR';
		}
	}
			}
			if(returnValue == 'SUCCESS')
			{
	Apttus_Proposal__Proposal__c prop = [SELECT Id,NokiaCPQ_Proposal_Id__c,NokiaCPQ_SAPIntegrationStatus__c,NokiaCPQ_SAPIntegrationStatusDescription__c,Quote_Type__c FROM Apttus_Proposal__Proposal__c WHERE Id =:proposalId LIMIT 1];
	system.debug('prop--> ' + prop);
	taskValuesMap.put(prop.NokiaCPQ_Proposal_Id__c,Globalconstants.TASK_VALUE_UPD);
	
	String batch_size = system.Label.QTC_ADDQuoteBatchSize;
	//returnValue = SendAddQuoteMessage.mapQuoteWithWSDL(quoteObj, listFinalizedLineItems);
	QTC_QuoteProposalToStaging QTC = new QTC_QuoteProposalToStaging(quoteIds,taskValuesMap);
	Database.executebatch(QTC,Integer.valueOf(batch_size));
	//ITCCPQ-1948 - Yashdeep start
	if(new List<string> {GlobalConstants.DIRECT_QUOTE_TYPE, GlobalConstants.INDIRECT_QUOTE_TYPE}.indexOf(prop.Quote_Type__c) >= 0) {
		prop.NokiaCPQ_SAPIntegrationStatus__c = 'In Progress';
		prop.NokiaCPQ_SAPIntegrationStatusDescription__c = '';
		update prop;
	}
	//ITCCPQ-1948 - Yashdeep end
			}
		}
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),'sendAddQuoteMessageToEAI');
			//returnValue = Nokia_CPQ_Constants.ALLIANCE_EXPORT_ERROR_STRING +e.getMessage();
	
		}
	
		return returnValue;
	}
	
	
	/***************************
	* Description : The method returns CQ Order Document Export URL.
	* Parameter passed : recordIdVar
	* return : String
	***************************/
	@AuraEnabled
	public static string CQOrderDocExportMethod(String recordIdVar, String appName){
		String filePath;
		try{
			filePath = '/apex/Apttus_XApps__EditInExcelLaunch?selectedRecordId='+recordIdVar+'&appName='+appName+'&mode=touchless&outputType=None';
		}
	
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName()+e.getLineNumber()+e.getMessage(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
		return filePath;
	}
	
	/***************************
	* Description : The method Proposal Line Item and return value as updated or not.
	* Parameter passed : proposalId
	* return : String
	***************************/
	
	@AuraEnabled
	public Static string generateReconciliationExport(Id proposalId) {
		String LineItem;
		try{
			//Logic to generate SiteId on Proposal Line Item record
			String PLISuccess = generateSiteId(proposalId);
			//String QDSISuccess = NokiaCPQ_Reconcilation_File_Generator.generateSiteIdOnQDSI(proposalId);
			String proposalIdStr = proposalId;
			String reconcililiationSuccess = NokiaCPQ_Reconcilation_File_Generator.PLIbundleOptionMapping(proposalIdStr);
	
			//if(PLISuccess == 'SUCCESS' && QDSISuccess == 'SUCCESS' && reconcililiationSuccess == 'SUCCESS'){
			//  LineItem = 'SUCCESS';
			//}
			if(PLISuccess == 'SUCCESS' && reconcililiationSuccess == 'SUCCESS') {
	LineItem = 'SUCCESS';
			}
			else
	LineItem = 'Fail';
		}
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
			LineItem= 'Error'+ e.getMessage();
		}
		return LineItem;
	}
	
	//Method to update Sequence Site Id,CMN and Alias on Proposal Line Item and Quote Delivery Sales Items
	public Static string updatePLIandQDSI(String quoteId){
		String LineItem;
		map<Decimal,Decimal> mapPrimaryLineToParentline = new map<Decimal,Decimal>();
	
		map<decimal,list<Apttus_Proposal__Proposal_Line_Item__c> > mapParentbundlenumberwithListOptions = new map<Decimal,list<Apttus_Proposal__Proposal_Line_Item__c> >();
	
		map<decimal,list<Apttus_Proposal__Proposal_Line_Item__c> > mapParentbundlenumberWithListOptionsDummyFiltered = new map<Decimal,list<Apttus_Proposal__Proposal_Line_Item__c> >();
		map<Decimal,Apttus_Proposal__Proposal_Line_Item__c> mapDummyBundles = new map<Decimal,Apttus_Proposal__Proposal_Line_Item__c>();
		map<Decimal,Apttus_Proposal__Proposal_Line_Item__c> mapMBundAndStand = new map<Decimal,Apttus_Proposal__Proposal_Line_Item__c>();
		map<Decimal,Apttus_Proposal__Proposal_Line_Item__c> mapOfMainAndStandaloneProducts = new map<Decimal,Apttus_Proposal__Proposal_Line_Item__c>();
		map<Decimal,Apttus_Proposal__Proposal_Line_Item__c> mapALLPLI = new map<Decimal,Apttus_Proposal__Proposal_Line_Item__c>();
		Map<String, NokiaCPQ_CSP_Map_Control__c> productNameAndNokiaCSPMapControl = new Map<String, NokiaCPQ_CSP_Map_Control__c>();
		List<Apttus_Proposal__Proposal_Line_Item__c> cmnList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
		List<Apttus_Proposal__Proposal_Line_Item__c> lineItemList = new List<Apttus_Proposal__Proposal_Line_Item__c>();
		map<Decimal,Apttus_Proposal__Proposal_Line_Item__c> primaryLineWithPLI = new map<Decimal,Apttus_Proposal__Proposal_Line_Item__c>();
		map<String, Decimal> mapOfLineNumAndArcProdCodeWithPrimaryLine = new map<String, Decimal>();
	
		List<Apttus_Proposal__Proposal_Line_Item__c> listFinalizedLineItems = new List<Apttus_Proposal__Proposal_Line_Item__c>(
			[SELECT Id,NokiaCPQ_IsArcadiaBundle__c, Name, PCI_Code__c,ISP_Per_Unit__c,NokiaCPQ_Quantity__c,NokiaCPQ_Item_Type__c,
	Apttus_Proposal__Proposal__c, Apttus_Proposal__Proposal__r.CurrencyIsoCode, Apttus_QPConfig__BasePrice__c,
	NokiaCPQ_Product_Name__c, Apttus_QPConfig__LineNumber__c,Apttus_QPConfig__ChargeType__c,
	Product_Code__c, Apttus_Proposal__Unit_Price__c, Apttus_Proposal__Sales_Discount__c, Apttus_Proposal__Unit_Net_Price__c,
	Apttus_Proposal__Ext_Price__c, Apttus_Proposal__Ext_Net_Price__c, Apttus_Proposal__Service_Date__c,
	Apttus_QPConfig__LineType__c, Apttus_QPConfig__PrimaryLineNumber__c, Apttus_QPConfig__ParentBundleNumber__c,
	NokiaCPQ_Extended_IRP__c, NokiaCPQ_Unitary_IRP__c,  NokiaCPQ_Extended_CLP__c,  NokiaCPQ_Configuration_Type__c,
	Apttus_Proposal__Description__c, NokiaCPQ_ExtendedPrice_CNP__c, NokiaCPQ_Product_Description__c,Custom_Product_Code__c,
	Apttus_QPConfig__OptionId__r.Arcadia_Replacement_Code__c, Apttus_Proposal__Proposal__r.Name,Product_Classification__c,
	OEM__c,Apttus_QPConfig__ItemSequence__c,Sequence_Site_Id__c,Is_Dummy_Product__c,Is_Dummy_Bundle__c,
	Apttus_QPConfig__OptionId__r.Apttus_Config2__ConfigurationType__c, NokiaCPQ_Rationale_Of_Adjustment__c,NokiaCPQ_Net_Price__c,
	Apttus_QPConfig__ExtendedCost__c,NokiaCPQ_Extended_CUP_2__c,NokiaCPQ_Extended_IRP2__c,Apttus_Proposal__Quantity__c,
	NokiaCPQ_Partner_Price__c, NokiaCPQ_Alias__c,Apttus_QPConfig__AdjustmentType__c,NokiaCPQ_Extended_Cost__c,NokiaCPQ_Extended_CLP_2__c,NokiaCPQ_ExtendedAdvance_NP__c, Apttus_QPConfig__IsPrimaryLine__c,Total_Option_Quantity__c, Apttus_QPConfig__Quantity2__c,NokiaCPQ_Unitary_IRPrice__c,Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c,Alias_for_Exports__c,CMN__c,NokiaCPQ_Spare__c
	FROM Apttus_Proposal__Proposal_Line_Item__c WHERE Apttus_Proposal__Proposal__c =: quoteId and Apttus_QPConfig__IsPrimaryLine__c = true ORDER BY Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c ASC
				 LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]);
		System.debug('listFinalizedLineItems-->'+listFinalizedLineItems.size());
	
		List<Apttus_Proposal__Proposal__c> quoteRec = new List<Apttus_Proposal__Proposal__c>([Select NokiaCPQ_Portfolio__c
			 from Apttus_Proposal__Proposal__c
			 where id =: quoteId
		 limit 1]);
		system.debug('quoteRec'+quoteRec);
		for (NokiaCPQ_CSP_Map_Control__c nokiaCspMap : [SELECT Id, Name, Product_Code__c,
	 Source__c,Splitlevel__c,
	 Map_Mode__c,Portfolio__c
	 FROM NokiaCPQ_CSP_Map_Control__c
	 where Portfolio__c =: quoteRec[0].NokiaCPQ_Portfolio__c
		LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())])
		{
			productNameAndNokiaCSPMapControl.put(nokiaCspMap.Product_Code__c, nokiaCspMap);
		}
		try{
			for(Apttus_Proposal__Proposal_Line_Item__c PLI : listFinalizedLineItems) {
	if(PLI.Sequence_Site_Id__c!=null) {
		break;
	}
	
	mapALLPLI.put(PLI.Apttus_QPConfig__PrimaryLineNumber__c,PLI);
	if(PLI.Apttus_QPConfig__ParentBundleNumber__c == null) {
	
		mapMBundAndStand.put(PLI.Apttus_QPConfig__PrimaryLineNumber__c,PLI);
		mapOfMainAndStandaloneProducts.put(PLI.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c,PLI);
	}
	
	//Filter record of Arcadia/dummy bundles/DirectOptions/Arcadia Options
	if(PLI.Apttus_QPConfig__ParentBundleNumber__c != null) {
	
		If(mapParentbundlenumberwithListOptions.containskey(PLI.Apttus_QPConfig__ParentBundleNumber__c)){
			mapParentbundlenumberwithListOptions.get(PLI.Apttus_QPConfig__ParentBundleNumber__c).add(PLI);
		}
		else{
			mapParentbundlenumberwithListOptions.put(PLI.Apttus_QPConfig__ParentBundleNumber__c,new list<Apttus_Proposal__Proposal_Line_Item__c> {PLI});
		}
	
		// map Primary Line & Parent Line number 1:1
		mapPrimaryLineToParentline.put(PLI.Apttus_QPConfig__PrimaryLineNumber__c,PLI.Apttus_QPConfig__ParentBundleNumber__c);
	
		// Collect Only Arcadia Bundles.
		//system.debug('Arcadia - >>>'+PLI.Product_Code__c + '<<<<Is Arcadia>>>'+PLI.NokiaCPQ_IsArcadiaBundle__c);
		if(PLI.NokiaCPQ_IsArcadiaBundle__c) {
			String Key = PLI.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c+'_'+PLI.Product_Code__c;
			mapOfLineNumAndArcProdCodeWithPrimaryLine.put(Key, PLI.Apttus_QPConfig__PrimaryLineNumber__c);
		}
	
	}
	if(PLI.Is_Dummy_Bundle__c=='Yes') {
		mapDummyBundles.put(PLI.Apttus_QPConfig__PrimaryLineNumber__c,PLI);
	}
			}
			System.debug('mapPrimaryLineToParentline--->'+mapPrimaryLineToParentline);
			System.debug('mapDummyBundles--->'+mapDummyBundles);
			System.debug('mapParentbundlenumberwithListOptions--->'+mapParentbundlenumberwithListOptions);
	
	
			// collect ParentBundleLineNumber and List of Options after dummy bundle filter.
			// Map contains Main bundle & list of Direct/Arcadia/cust gr. and Arcadia or custom gr. & its option.
			//optionsgroup + SI
	
			mapParentbundlenumberWithListOptionsDummyFiltered = generateParentToChildOptionsHierarchy(mapPrimaryLineToParentline, mapDummyBundles, mapParentbundlenumberwithListOptions);
	
			//map of Arcadia Primary number List of QDSI
			Map<Decimal, List<Quote_Delivery_Sales_Item__c> > mapArcPrimayNumListQDSIs = new Map<Decimal, List<Quote_Delivery_Sales_Item__c> >();
	
			// manage Qoute Delivery SalesItems for Arcadia Bundle in case of CAT configuration.
			Map<String, List<Quote_Delivery_Sales_Item__c> > mapArcadiaChildQDSIs = new Map<String, List<Quote_Delivery_Sales_Item__c> >();
			mapArcadiaChildQDSIs= getQuoteDeliverySalesItemsForArcadia(quoteId);
	
			for(String keyOfQDSI : mapArcadiaChildQDSIs.keySet()) {
	//system.debug('keyOfQDSI:::' + keyOfQDSI +'>>>>>'+mapOfLineNumAndArcProdCodeWithPrimaryLine.containskey(keyOfQDSI));
	if(mapOfLineNumAndArcProdCodeWithPrimaryLine.containskey(keyOfQDSI)) {
		mapArcPrimayNumListQDSIs.put(mapOfLineNumAndArcProdCodeWithPrimaryLine.get(keyOfQDSI), mapArcadiaChildQDSIs.get(keyOfQDSI));
	}
			}
	
			System.debug('mapParentbundlenumberWithListOptionsDummyFiltered--->'+mapParentbundlenumberWithListOptionsDummyFiltered);
	
			for(Decimal PLN : mapParentbundlenumberWithListOptionsDummyFiltered.keySet()) {
	for(Apttus_Proposal__Proposal_Line_Item__c PLI: mapParentbundlenumberWithListOptionsDummyFiltered.get(PLN)) {
		if(!mapOfMainAndStandaloneProducts.isEmpty() && !productNameAndNokiaCSPMapControl.isEmpty() &&  mapOfMainAndStandaloneProducts.get(PLI.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c) != null && productNameAndNokiaCSPMapControl.containskey(mapOfMainAndStandaloneProducts.get(PLI.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c).Product_Code__c) && productNameAndNokiaCSPMapControl.get(mapOfMainAndStandaloneProducts.get(PLI.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c).Product_Code__c).Map_mode__c == Nokia_CPQ_Constants.Split) {
			String siteId;
			if(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c < 10) {
	siteId = '0'+String.ValueOf(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c);
			}
			else{
	siteId = String.ValueOf(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c);
			}
			if(mapMBundAndStand.containskey(PLN)) {
	if(PLI.Apttus_QPConfig__LineType__c =='Option' && PLI.NokiaCPQ_Configuration_Type__c=='Bundle') {
		System.debug('inside optiongroup');
	
	
	}
	else{
		System.debug('inside directoption');
	
		if(mapALLPLI != null && mapALLPLI.containskey(PLN) && mapALLPLI.get(PLN).Product_Code__c!= null) {
	
			PLI.CMN__c= siteId+'_'+mapALLPLI.get(PLN).Product_Code__c;
		}
	
	
	}
	
			}
			else{
	if(mapALLPLI != null && mapALLPLI.containskey(PLN) && mapALLPLI.get(PLN).Product_Code__c!= null) {
		System.debug('inside directoption2');
		PLI.CMN__c= siteId+'_'+mapALLPLI.get(PLN).Product_Code__c;
	}
	
	
			}
	
			cmnList.add(PLI);
		}
		else{
			String siteId;
			if(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c < 10) {
	siteId = '0'+String.ValueOf(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c);
			}
			else{
	
	
	siteId = String.ValueOf(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c);
			}
			PLI.CMN__c= siteId+'_'+PLI.Apttus_Proposal__Proposal__r.Name;
			cmnList.add(PLI);
		}
	}
	
			}
	
	
			for(Apttus_Proposal__Proposal_Line_Item__c PLI : mapMBundAndStand.values()) {
	System.debug('inside main bundle');
	String siteId;
	if(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c < 10) {
		siteId = '0'+String.ValueOf(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c);
	}
	else{
		siteId = String.ValueOf(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c);
	}
	if(!productNameAndNokiaCSPMapControl.isEmpty() && !mapOfMainAndStandaloneProducts.isEmpty() && mapOfMainAndStandaloneProducts.get(PLI.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c) != null &&  productNameAndNokiaCSPMapControl.containskey(mapOfMainAndStandaloneProducts.get(PLI.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c).Product_Code__c) && productNameAndNokiaCSPMapControl.get(mapOfMainAndStandaloneProducts.get(PLI.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c).Product_Code__c).Map_mode__c == Nokia_CPQ_Constants.Split) {
		PLI.CMN__c= siteId+'_'+PLI.Product_Code__c;
	}
	else if(PLI.Product_Classification__c!='' && PLI.Product_Classification__c!=null && PLI.Product_Classification__c.equalsIgnoreCase('Deploy Services')) {
		PLI.CMN__c= siteId+'_'+System.Label.GS_Deploy_Group_ProductCode;
	}
	else if(PLI.NokiaCPQ_Spare__c==true) {
		PLI.CMN__c= siteId+'_'+System.Label.Spare;
	}
	else{
		PLI.CMN__c= siteId+'_'+PLI.Apttus_Proposal__Proposal__r.Name;
	}
	cmnList.add(PLI);
			}
	
			for(Apttus_Proposal__Proposal_Line_Item__c pli : cmnList) {
	
	//pli.Sequence_Site_Id__c = pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c;
	String siteId;
	if(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c < 10) {
		siteId = '0'+String.ValueOf(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c);
	}
	else{
		siteId = String.ValueOf(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c);
	}
	pli.Sequence_Site_Id__c = siteId;
	System.debug('siteItd---'+siteId);
	if(pli.Apttus_QPConfig__ParentBundleNumber__c == null) {
		if(pli.NokiaCPQ_Alias__c!=null && pli.NokiaCPQ_Alias__c!='') {
			pli.Alias_for_Exports__c= siteId+'_'+pli.NokiaCPQ_Alias__c;
		}
		else{
			pli.Alias_for_Exports__c=siteId+'_'+pli.NokiaCPQ_Product_Name__c;
		}
	}
	else{
		// if(pli.NokiaCPQ_Alias__c!=null && pli.NokiaCPQ_Alias__c!='' && !mapOfMainAndStandaloneProducts.isEmpty() && mapOfMainAndStandaloneProducts.get(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c) != null && mapOfMainAndStandaloneProducts.containskey(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c) && mapOfMainAndStandaloneProducts.get(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c).NokiaCPQ_Alias__c!=null) {
		// 	pli.Alias_for_Exports__c= siteId+'_'+mapOfMainAndStandaloneProducts.get(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c).NokiaCPQ_Alias__c+'_'+pli.NokiaCPQ_Alias__c;
		// }
		// else if(pli.NokiaCPQ_Alias__c!=null && pli.NokiaCPQ_Alias__c!='') {
		// 	pli.Alias_for_Exports__c= siteId+'_'+pli.NokiaCPQ_Alias__c;
		// }
		// else if(!mapOfMainAndStandaloneProducts.isEmpty() &&  mapOfMainAndStandaloneProducts.containskey(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c) && mapOfMainAndStandaloneProducts.get(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c).NokiaCPQ_Alias__c!=null) {
		// 	pli.Alias_for_Exports__c=siteId+'_'+mapOfMainAndStandaloneProducts.get(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c).NokiaCPQ_Alias__c;
		// }
		// else if(!mapOfMainAndStandaloneProducts.isEmpty() &&  mapOfMainAndStandaloneProducts.containskey(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c))
		// {
		// 	pli.Alias_for_Exports__c=siteId+'_'+mapOfMainAndStandaloneProducts.get(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c).NokiaCPQ_Product_Name__c;
		// }
	
		//Yashdeep start-1365
		if(!mapOfMainAndStandaloneProducts.isEmpty() &&  mapOfMainAndStandaloneProducts.containskey(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c) && mapOfMainAndStandaloneProducts.get(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c).NokiaCPQ_Alias__c!=null) {
			pli.Alias_for_Exports__c=siteId+'_'+mapOfMainAndStandaloneProducts.get(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c).NokiaCPQ_Alias__c;
		}
		else if(!mapOfMainAndStandaloneProducts.isEmpty() &&  mapOfMainAndStandaloneProducts.containskey(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c))
		{
			pli.Alias_for_Exports__c=siteId+'_'+mapOfMainAndStandaloneProducts.get(pli.Apttus_QPConfig__DerivedFromId__r.Apttus_Config2__LineSequence__c).NokiaCPQ_Product_Name__c;
		}
		//Yashdeep end-1365
	}
	System.debug('pli.Alias_for_Exports__c---'+pli.Alias_for_Exports__c);
	lineItemList.add(pli);
			}
	
			System.debug('lineItemList--->'+lineItemList);
			//try{
	
			if(!lineItemList.isEmpty()) {
	update lineItemList;
			}
	
			/*}catch(Exception e){
	
		 System.debug('e-->'+e);
	
	
		 }*/
			list<Quote_Delivery_Sales_Item__c> listQDSI = new list<Quote_Delivery_Sales_Item__c>();
			for(Apttus_Proposal__Proposal_Line_Item__c PLI : [Select Id,CMN__c, Apttus_QPConfig__PrimaryLineNumber__c from Apttus_Proposal__Proposal_Line_Item__c Where Apttus_Proposal__Proposal__c =:quoteId and Apttus_QPConfig__IsPrimaryLine__c = true]) {
	primaryLineWithPLI.put(PLI.Apttus_QPConfig__PrimaryLineNumber__c,PLI);
			}
			for(Decimal PLN : mapParentbundlenumberWithListOptionsDummyFiltered.keySet()) {
	for(Apttus_Proposal__Proposal_Line_Item__c PLI: mapParentbundlenumberWithListOptionsDummyFiltered.get(PLN)) {
		if(mapArcPrimayNumListQDSIs.containskey(PLI.Apttus_QPConfig__PrimaryLineNumber__c)) {
			system.debug('2nd Level Child in QDSI>>>'+mapArcPrimayNumListQDSIs.get(PLI.Apttus_QPConfig__PrimaryLineNumber__c).size());
			for(Quote_Delivery_Sales_Item__c objQDSI : mapArcPrimayNumListQDSIs.get(PLI.Apttus_QPConfig__PrimaryLineNumber__c)) {
	if(!primaryLineWithPLI.isEmpty() && primaryLineWithPLI.get(objQDSI.Parent_Line_Item__r.Apttus_Config2__PrimaryLineNumber__c) != null)
	{
		objQDSI.CMN__c = primaryLineWithPLI.get(objQDSI.Parent_Line_Item__r.Apttus_Config2__PrimaryLineNumber__c).CMN__c;
	}
	//objQDSI.Sequence_Site_Id__c = objQDSI.Parent_Line_Item__r.Apttus_Config2__LineSequence__c;
	String siteId;
	if(objQDSI.Parent_Line_Item__r.Apttus_Config2__LineSequence__c < 10) {
		siteId = '0'+String.ValueOf(objQDSI.Parent_Line_Item__r.Apttus_Config2__LineSequence__c);
	}
	else{
		siteId = String.ValueOf(objQDSI.Parent_Line_Item__r.Apttus_Config2__LineSequence__c);
	}
	objQDSI.Sequence_Site_Id__c = siteId;
	if(objQDSI.Parent_Line_Item__r.Apttus_Config2__ParentBundleNumber__c == null) {
		if(objQDSI.Parent_Line_Item__r.NokiaCPQ_Alias__c!=null && objQDSI.Parent_Line_Item__r.NokiaCPQ_Alias__c!='') {
			objQDSI.Alias_for_Exports__c= siteId+'_'+objQDSI.Parent_Line_Item__r.NokiaCPQ_Alias__c;
		}
		else{
			objQDSI.Alias_for_Exports__c=siteId+'_'+objQDSI.Parent_Line_Item__r.NokiaCPQ_Product_Name__c;
		}
	}
	else{
		if(objQDSI.Parent_Line_Item__r.NokiaCPQ_Alias__c!=null && objQDSI.Parent_Line_Item__r.NokiaCPQ_Alias__c!='') {
			objQDSI.Alias_for_Exports__c= siteId+'_'+objQDSI.Parent_Line_Item__r.NokiaCPQ_Alias__c;
		}
		else if(!mapOfMainAndStandaloneProducts.isEmpty() && mapOfMainAndStandaloneProducts.get(objQDSI.Parent_Line_Item__r.Apttus_Config2__LineSequence__c) != null) {
			objQDSI.Alias_for_Exports__c=siteId+'_'+mapOfMainAndStandaloneProducts.get(objQDSI.Parent_Line_Item__r.Apttus_Config2__LineSequence__c).NokiaCPQ_Product_Name__c;
		}
	}
	listQDSI.add(objQDSI);
	
			}
		}
	}
			}
			if(!listQDSI.isEmpty()) {
	database.update(listQDSI, false);
			}
	
			LineItem= 'SUCCESS';
		}
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQ_Reconcilation_File_Generator.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
			LineItem= 'Error'+ e.getMessage();
		}
		return LineItem;
	}
	
	// method to filter Dummy bundles and return:
	// map Main Bundle & Its Direct Options/Arcadia/CustGr. AND Arcadia/Cust gr. & its Options list.
	public static map<decimal,list<Apttus_Proposal__Proposal_Line_Item__c> > generateParentToChildOptionsHierarchy(map<Decimal,Decimal> mapPrimaryLineToParentline, map<Decimal,Apttus_Proposal__Proposal_Line_Item__c> mapDummyBundles, map<decimal,list<Apttus_Proposal__Proposal_Line_Item__c> > mapParentbundlenumberwithListOptions){
		decimal count=0;
		for(Decimal primaryLineNum: mapPrimaryLineToParentline.keyset()) {
			system.debug('---count--'+count+'>>>primaryLineNum>>>'+primaryLineNum);
			Decimal varParentBundle = primaryLineNum;
			count++;
			if(mapDummyBundles.containskey(primaryLineNum)) {
	system.debug('---count--'+count+'::before Dummy While loop:varParentBundle:::'+varParentBundle);
	while(mapDummyBundles.containskey(varParentBundle)) {
	
		varParentBundle = mapPrimaryLineToParentline.get(varParentBundle);
		system.debug('---count--'+count+'::After Dummy While loop:varParentBundle:::'+varParentBundle);
	}
	
	list<Apttus_Proposal__Proposal_Line_Item__c> mainBundleOptionList = new list<Apttus_Proposal__Proposal_Line_Item__c>();
	list<Apttus_Proposal__Proposal_Line_Item__c> addline = new list<Apttus_Proposal__Proposal_Line_Item__c>();
	
	// collect Main Bundles/ Valid parent Child list & remove dummy child from valid parent list
	if(mapParentbundlenumberwithListOptions.containskey(varParentBundle)) {
		system.debug('---count--'+count+'varParentBundle>>>>'+varParentBundle+'Child of main bundle--size()::'+mapParentbundlenumberwithListOptions.get(varParentBundle).size());
		for(Apttus_Proposal__Proposal_Line_Item__c objPLI : mapParentbundlenumberwithListOptions.get(varParentBundle)) {
			if(objPLI.Apttus_QPConfig__PrimaryLineNumber__c != primaryLineNum) {
	mainBundleOptionList.add(objPLI);
	system.debug('---count--'+count+'>>>varParentBundle::'+varParentBundle+'::TopLevelParent\'s Child PLI ProdCode::'+objPLI.Product_Code__c);
			}
		}
	}
	
	list<Apttus_Proposal__Proposal_Line_Item__c> listDummyBundlesOptions = new list<Apttus_Proposal__Proposal_Line_Item__c>();
	if(mapParentbundlenumberwithListOptions.containskey(primaryLineNum)) {
		system.debug('---count--'+count+'::Current PLI PrimayLine::'+primaryLineNum );
		listDummyBundlesOptions = mapParentbundlenumberwithListOptions.get(primaryLineNum);
	}
	
	system.debug('::---count--'+count);
	System.debug('@@listDummyBundlesOptions>>>'+listDummyBundlesOptions+'---count--'+count);
	System.debug('@@mainBundleOptionList>>>>'+mainBundleOptionList+'---count--'+count);
	mapParentbundlenumberwithListOptions.remove(primaryLineNum);
	/*
	for(Apttus_Proposal__Proposal_Line_Item__c linenum : listDummyBundlesOptions){
	if(!mapDummyBundles.containskey(linenum.Apttus_QPConfig__PrimaryLineNumber__c)){
	addline.add(linenum);
	}
	}
		*/
	if(listDummyBundlesOptions.size() > 0) {
		mainBundleOptionList.addall(listDummyBundlesOptions);
	}
	
	for(Apttus_Proposal__Proposal_Line_Item__c oblChildPLI : mainBundleOptionList) {
		system.debug('---count--'+count+'>>>primaryLineNum>>>'+primaryLineNum+':::Filtered Top Parent Line >>'+varParentBundle +'::ChildPLIProductCode>>'+oblChildPLI.Product_Code__c+'::: Primary Line::'+oblChildPLI.Apttus_QPConfig__PrimaryLineNumber__c);
	}
	
	mapParentbundlenumberwithListOptions.put(varParentBundle,mainBundleOptionList);
	
			}
	
		}
	
		system.debug('Final ParentLine :::'+mapParentbundlenumberwithListOptions.keySet());
		system.debug('Final ParentLine :::'+mapParentbundlenumberwithListOptions);
	
		return mapParentbundlenumberwithListOptions;
	
	}
	
	public static Map<String, List<Quote_Delivery_Sales_Item__c> > getQuoteDeliverySalesItemsForArcadia(Id quoteId) {
		List<Quote_Delivery_Sales_Item__c> listQDSIs = new List<Quote_Delivery_Sales_Item__c>([SELECT Id,Arcadia_Product_Code__c, Item_Type__c, Parent_Line_Item__c, PCI_Code__c, Product_Code__c, Quantity__c, Proposal__c, Parent_Line_Item__r.Apttus_Config2__LineNumber__c,Parent_Line_Item__r.Apttus_Config2__PrimaryLineNumber__c, Sequence_Site_Id__c,Alias_for_Exports__c,Parent_Line_Item__r.NokiaCPQ_Alias__c,Parent_Line_Item__r.NokiaCPQ_Product_Name__c,Parent_Line_Item__r.Apttus_Config2__ParentBundleNumber__c,Parent_Line_Item__r.Apttus_Config2__LineSequence__c,CMN__c FROM Quote_Delivery_Sales_Item__c WHERE Proposal__c =: quoteId AND Parent_Line_Item__c != null]);
	
		Map<String, List<Quote_Delivery_Sales_Item__c> > mapArcadiaChildQDSIs = new Map<String, List<Quote_Delivery_Sales_Item__c> >();
		if(!listQDSIs.IsEmpty())
		{
			for(Quote_Delivery_Sales_Item__c objQDSI : listQDSIs)
			{
	String key = objQDSI.Parent_Line_Item__r.Apttus_Config2__LineSequence__c +'_'+ objQDSI.Arcadia_Product_Code__c;
	if(mapArcadiaChildQDSIs.containskey(key))
		mapArcadiaChildQDSIs.get(key).add(objQDSI);
	else
		mapArcadiaChildQDSIs.put(key, new List<Quote_Delivery_Sales_Item__c> {objQDSI});
	
			}
		}
	
		return mapArcadiaChildQDSIs;
	}
	
	//Workaround Majid for Apttus case 00104031
	@AuraEnabled
	public static void configureMethodMNDirect(String recordIdVar){
		try{
			string configure ='Classic';
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
			quoteObj = [Select Id, Apttus_QPConfig__IsTaskPending__c from Apttus_Proposal__Proposal__c where Id =: recordIdvar Limit 1];
			//Imran Wipro -- Moved below code to UpdateConfigurebutton method
			//Workaround Majid for Apttus case 00104031 D-14586 START
			//if(quoteObj.Apttus_QPConfig__IsTaskPending__c){
			//  update new Apttus_Proposal__Proposal__c(id=quoteObj.id, Apttus_QPConfig__IsTaskPending__c = false);
			//}
			UpdateConfigurebutton(recordIdvar,configure,quoteObj);
			//Workaround Majid for Apttus case 00104031 D-14586 END
		}
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	
	}
	
	@AuraEnabled
	public static void viewProductsMNDirectMethod(String recordIdVar){
		try{
			Apttus_Proposal__Proposal__c quoteObj;
			quoteObj = [Select Id, Name, Apttus_QPConfig__IsTaskPending__c, NokiaCPQ_Configure_Products_Read_Button__c, NokiaCPQ_Environment_Access_Type__c from Apttus_Proposal__Proposal__c where Id=:recordIdVar Limit 1];
			//Workaround Majid for Apttus case 00104031 D-14586 START
			if(quoteObj.Apttus_QPConfig__IsTaskPending__c) {
	update new Apttus_Proposal__Proposal__c(id=quoteObj.id, Apttus_QPConfig__IsTaskPending__c = false);
			}
			//Workaround Majid for Apttus case 00104031 D-14586 END
		}
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
	}
	
	/*Added by Rajitha***************************
	 * Description : The method returns config button direct URL.
	 * Parameter passed : recordIdVar
	 * return : String
	 ***************************/
	@AuraEnabled
	public static String configureMethodNCQ(String recordIdVar){
		system.debug('in configureProductsNCQ');
		String finalString = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
		String configure = 'Classic';
		try{
			String retResult = Nokia_CPQ_Constants.BLANK_STRING_WITHOUT_SPACE;
			String baseUrl = System.URL.getSalesforceBaseUrl().ToExternalForm();
			Apttus_Proposal__Proposal__c quoteObj = new Apttus_Proposal__Proposal__c();
	
			quoteObj = [Select Id,CPQ_NCQ_Check__c, Name, Apttus_QPConfig__IsTaskPending__c, CPQ_Configure_Products_SNCQ__c, NokiaCPQ_Environment_Access_Type__c,Is_Turbo_Pricing__c,Is_Classic_Pricing__c from Apttus_Proposal__Proposal__c where Id =: recordIdvar Limit 1];
			//Imran Wipro -- Moved below code to UpdateConfigurebutton method
			//Workaround Majid for Apttus case 00104031 D-14586 START
			//if(quoteObj.Apttus_QPConfig__IsTaskPending__c){
			//  update new Apttus_Proposal__Proposal__c(id=quoteObj.id, Apttus_QPConfig__IsTaskPending__c = false);
			//}
			//Workaround Majid for Apttus case 00104031 D-14586 END
			UpdateConfigurebutton(recordIdvar,configure,quoteObj);
			retResult = quoteObj.CPQ_Configure_Products_SNCQ__c;
			system.debug('redirecturl-->'+retResult);
			system.debug('basurl-->'+baseUrl);
	
			if(quoteObj.NokiaCPQ_Environment_Access_Type__c.equals(Nokia_CPQ_Constants.SCRM))
	finalString = baseUrl+retResult;
			else
	finalString = retResult;
		} catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
		}
		return finalString;
	}
	
	/***************************
	* Description : Return true if user is user has edit access on Quote
	* return : Boolean
	***************************/
	@AuraEnabled
	public static Boolean QueryUserQuoteAccess(String recordIdVar){
		Boolean isEdit= false;
		try{
			UserRecordAccess usere = new UserRecordAccess();
			usere = [SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId =: UserInfo.getUserId() AND RecordId =: recordIdVar];
			isEdit = usere.HasEditAccess;
	
		}
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
			isEdit = true;
		}
		return isEdit;
	}
	
	
	/***************************
	* Added By Christie JJ for ITCCPQ-1125
	* Description : Return SessionId, and relevant parameters for XAE app login
	* return : String
	***************************/
	@AuraEnabled
	public static String getXAEParameters(String recordIdVar){
		String urlVal='';
	
		try{
	
			
			String hostUrl = CPQ_Direct_Pricing__c.getInstance().hostUrl__c;
			String appId = CPQ_Direct_Pricing__c.getInstance().AppId__c;
			String actionflowName = CPQ_Direct_Pricing__c.getInstance().actionflowName__c;
			
			PageReference sessionIdPage = Page.NokiaCPQ_GetSessionVF;
			String vfContent = sessionIdPage.getContent().toString();
			Integer startPosition = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
	 endPosition = vfContent.indexOf('End_Of_Session_Id');
			String sessionId = vfContent.substring(startPosition, endPosition);
			System.debug('sessionId '+sessionId);
			urlVal = 'xauthorforexcel:export '+ appId + ' ' + recordIdVar + ' ' + sessionId + ' ' + hostUrl + ' ' + actionflowName;
			system.debug('[+] xae url - '+urlVal);
	
	
		}
		catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
	
		}
		return urlVal;
	}
	
	/***************************
	* Added By Christie JJ for ITCCPQ-1125
	* Description : Returns the latest product configuration record having aggregation, for the proposal record
	* return : String
	***************************/
	@AuraEnabled
	public static String getAggregation(Id proposalId) {
	
		List<Apttus_Config2__ProductConfiguration__c> productConfigurationList = [SELECT Id,Apttus_Config2__VersionNumber__c, (SELECT Id,NokiaCPQ_Aggregator__c FROM Site_Phase_Configuration__r WHERE NokiaCPQ_Aggregator__c!=null LIMIT 1) FROM Apttus_Config2__ProductConfiguration__c WHERE Apttus_QPConfig__Proposald__c =:proposalId ORDER BY Apttus_Config2__VersionNumber__c DESC LIMIT 1];
		// if(prodConfig != null) {
		// 	return prodConfig.Id + '|' + !prodConfig.Site_Phase_Configuration__r.isEmpty();
		// }
		// return null;
		if(!productConfigurationList.isEmpty()) {
			return productConfigurationList[0].Id + '|' + !productConfigurationList[0].Site_Phase_Configuration__r.isEmpty();
		}
		return null;
	}
	
	/***************************
	* Added By Christie JJ for ITCCPQ-1125
	* Description : Returns the plugin url for Direct CPQ, from the custom hierarchy settings
	* return : String
	***************************/
	@AuraEnabled
	public static String getCustomSetting() {
	
		CPQ_Direct_Pricing__c cpq = CPQ_Direct_Pricing__c.getInstance();
		return cpq.PluginUrl__c;
	
	}
	
	/************************
	 * Added by Surinder for Turbo change
	 * Description: On Turbo Toggle on cart, set isTurboPricing = true and classic = false.
	 */
	@AuraEnabled
	public static void updateTurboFlag(Apttus_Proposal__Proposal__c quoteRecord,boolean isTurbo){	
		Apttus_Proposal_Proposal__c userOrgSpficSetting=Apttus_Proposal_Proposal__c.getInstance(UserInfo.getUserId());
		try{
			if(userOrgSpficSetting!=null) {
	if(quoteRecord.Quote_Type__c.equalsIgnoreCase(GlobalConstants.INDIRECT_QUOTE_TYPE) ) {
		userOrgSpficSetting.Enable_Turbo_Pricing_Button_for_Partner__c =isTurbo;
		userOrgSpficSetting.Enable_Classic_Pricing_Button_forPartner__c = !isTurbo;
	
	}
	if(quoteRecord.Quote_Type__c.equalsIgnoreCase(GlobalConstants.DIRECT_QUOTE_TYPE) ) {
		userOrgSpficSetting.Enable_Turbo_Pricing_Button__c =isTurbo;
		userOrgSpficSetting.Enable_Classic_Pricing_Button__c = !isTurbo;
	}
	if(quoteRecord.CPQ_CQ_Check__c==true  ) {
		userOrgSpficSetting.Enable_Surround_Turbo_Pricing_Button__c =isTurbo;
		userOrgSpficSetting.Enable_Surround_Classic_Pricing_Button__c = !isTurbo;
	}
	database.upsert(userOrgSpficSetting);
			}
			quoteRecord.Is_Turbo_Pricing__c = isTurbo;
			quoteRecord.Is_Classic_Pricing__c = !isTurbo;
			update quoteRecord;
		}catch(Exception e) {
			ExceptionHandler.addException(e,NokiaCPQquoteActionsController.class.getName(),Nokia_CPQ_Constants.ERROR_MSD);
		}
	
		
	}
	
	
	/**
	 * @description Check if user has special permission for Turbo feature.
	 * @author Surinder | 11-23-2021
	 * @param 
	 * ITCCPQ-2543
	 * @return boolean
	 **/
	@AuraEnabled
	public static boolean isUserhasTurboPermission() {
		return (FeatureManagement.checkPermission('CPQ_Turbo_Permission'));
	}
	
	
	
	}