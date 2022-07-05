/**
 * @description	: 
 * @author			: Yashdeep Prajapati
 * @group	: 
 * @last modified on  : 06-09-2021
 * @last modified by  : Yashdeep Prajapati
 * Modifications Log 
 * Ver   Date		 Author	  Modification
 * 1.0   06-09-2021   Yashdeep Prajapati   Initial Version
**/
global with sharing class NokiaCPQ_DisplayActionCallback implements Apttus_Config2.CustomClass.IDisplayActionCallback{
	
	static List<Apttus_Config2.DisplayActionInfo> displayActions;
	static String Portfolio;
	//static String checkMode;
	global static void start(Apttus_Config2.ProductConfiguration cart, List<Apttus_Config2.DisplayActionInfo> disActionInfoList){	
		
		//system.debug('***DisplayActionCallback > start() > DisActList: '+disActionInfoList + ' <> cart:' + cart);
		displayActions = disActionInfoList;
		
		Apttus_Config2__ProductConfiguration__c standardConfig = cart.getConfigSO();
		
		disableActionsForIndirectQuote(standardConfig,disActionInfoList); 
		// disable all actions except Finalize and Site and Phase,Reprice actions for Partners/Enterprize Quotes if there is Aggregation.
	if(new List<string> {Nokia_CPQ_Constants.QUOTE_TYPE_DIRECTCPQ, Nokia_CPQ_Constants.QUOTE_TYPE_INDIRECTCPQ}.indexOf(standardConfig.Quote_Type__c) >= 0) {
		disableActionsOnAggregation(standardConfig,disActionInfoList);
	}
	}
	
	public static void disableActionsOnAggregation(Apttus_Config2__ProductConfiguration__c objProdConfig,List<Apttus_Config2.DisplayActionInfo> disActionInfoList){	
		if(Nokia_CPQ_Utility.hasAggregation(objProdConfig.id)) {
			for(Apttus_Config2.DisplayActionInfo actionInst : disActionInfoList) {
	Apttus_Config2__ConfigCustomDisplayActions__c ActionSOInst = actionInst.ActionSO;
	String actionName = ActionSOInst.Apttus_Config2__ActionLabelName__c;
	if(!new set<String> {'Site_Phase_Allocation','Reprice', 'Finalize','CPQ_CustomReprice'}.Contains(actionName)) {
		actionInst.IsEnabled = false;
		actionInst.ActionSO.Apttus_Config2__IsEnabled__c= false;
	}
			}
		}
	}
	public static void disableActionsForIndirectQuote(Apttus_Config2__ProductConfiguration__c objProdConfig,List<Apttus_Config2.DisplayActionInfo> disActionInfoList)
	{							 
		Apttus_Proposal__Proposal__c maintenanceQuote = [Select id,NokiaCPQ_Is_Maintenance_Quote__c,NokiaCPQ_Portfolio__c,Apttus_Proposal__Approval_Stage__c from Apttus_Proposal__Proposal__c where id =:objProdConfig.Apttus_QPConfig__Proposald__c];
		
		//system.debug('maintenanceQuote -->'+maintenanceQuote);
		//
		Portfolio = maintenanceQuote.NokiaCPQ_Portfolio__c;
		if(maintenanceQuote.Apttus_Proposal__Approval_Stage__c == 'Draft' || maintenanceQuote.Apttus_Proposal__Approval_Stage__c == 'Pending Approval' || maintenanceQuote.Apttus_Proposal__Approval_Stage__c == 'Requires Approval'){
			for(Apttus_Config2.DisplayActionInfo actionInst : disActionInfoList){
	Apttus_Config2__ConfigCustomDisplayActions__c ActionSOInst = actionInst.ActionSO;
	String actionName = ActionSOInst.Apttus_Config2__ActionLabelName__c;
	system.debug('my action button***************'+actionName);
	if(actionName.equals('CloseCart')) {
		// MAKE ACTION VISIBLE!!!
		actionInst.IsEnabled = false;
		actionInst.ActionSO.Apttus_Config2__IsEnabled__c= false;
	}
	
			}
			
		}
		
		if(maintenanceQuote.NokiaCPQ_Is_Maintenance_Quote__c == True) {
			
			for(Apttus_Config2.DisplayActionInfo actionInfoInst : disActionInfoList){
	
	Apttus_Config2__ConfigCustomDisplayActions__c ActionSOInst = actionInfoInst.ActionSO;
	
	String actionName = ActionSOInst.Apttus_Config2__ActionLabelName__c;
	//system.debug('***DisplayActionCallback > Action Name: ' + actionName);
	
	//system.debug('***DisplayActionCallback > Before: ' + ActionSOInst.Apttus_Config2__ActionLabelName__c + ' <> ' + actionInfoInst.IsEnabled + ' <> ' +  actionInfoInst.ActionSO.Apttus_Config2__IsEnabled__c);
	
	//commented by HCL for SF ticket-01694172
	/*if(actionName.equals('AddMoreProducts')) {
		// MAKE ACTION INVISIBLE!!!
		actionInfoInst.IsEnabled = false;
		actionInfoInst.ActionSO.Apttus_Config2__IsEnabled__c= false;
	}*/

	if(actionName.equals('Site_Phase_Allocation')) {
		// MAKE ACTION INVISIBLE!!!
		actionInfoInst.IsEnabled = false;
		actionInfoInst.ActionSO.Apttus_Config2__IsEnabled__c= false;
	}
	
	//system.debug('***DisplayActionCallback > After: ' + ActionSOInst.Apttus_Config2__ActionLabelName__c + ' <> ' + actionInfoInst.IsEnabled + ' <> ' +  actionInfoInst.ActionSO.Apttus_Config2__IsEnabled__c);
	
			}
		}
		
		// COMMENTED BY PB FOR GPP NEW FUNCTIONALITY REQ #4403	 
		if(maintenanceQuote.NokiaCPQ_Portfolio__c == Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO) {

			for(Apttus_Config2.DisplayActionInfo actionInfoInst : disActionInfoList){

	Apttus_Config2__ConfigCustomDisplayActions__c ActionSOInst = actionInfoInst.ActionSO;
	String gppActionName = ActionSOInst.Apttus_Config2__ActionLabelName__c;
	if(gppActionName.equals('GPPPricing')) {
		// MAKE ACTION INVISIBLE!!!
		actionInfoInst.IsEnabled = false;
		actionInfoInst.ActionSO.Apttus_Config2__IsEnabled__c= false;

	}
			}
		}  
		//}
		
		
		//global static void setActionProperties(Apttus_Config2.CustomClass.ActionParams actionParam){
		//System.debug('***DisplayActionCallback > setActionProperties() > actionParam: '+actionParam);
		
		/* Req 7106 started here, 
* Req Description: Below line of code is added to make Custom Product button disable on catlog/cart page for MPW Network Solution portfolio
*/
		if(String.isNotBlank(Portfolio) && Portfolio.equals(Nokia_CPQ_Constants.MPW_NETWORK_SOLUTION)) {// modified by jithin - added portfolo null check
			for(Apttus_Config2.DisplayActionInfo actionInfoInst : disActionInfoList){
	if((actionInfoInst.ActionSO.Apttus_Config2__ActionName__c == 'CustomAction11') || (actionInfoInst.ActionSO.Apttus_Config2__ActionName__c == 'CustomAction24'))
	{
		actionInfoInst.isEnabled = false;
		actionInfoInst.ActionSO.Apttus_Config2__IsEnabled__c= false;
	}
			}
		}
		/* Req 7106 ended here  */
		
		
		//Req:7237 - Disable "Edit Site" functionality in Cart-Starts Here
		if(Portfolio == Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO){
			for(Apttus_Config2.DisplayActionInfo actionInst : disActionInfoList){
	Apttus_Config2__ConfigCustomDisplayActions__c ActionSOInst = actionInst.ActionSO;
	String actionName = ActionSOInst.Apttus_Config2__ActionLabelName__c;
	if(actionName.equals('Edit_Site_Button')) {
		// MAKE ACTION INVISIBLE!!!
		actionInst.IsEnabled = false;
		actionInst.ActionSO.Apttus_Config2__IsEnabled__c= false;
	}
			}
		}
		//Req:7237-Ends here 
		
		//Logic for Disabling CAT configurator Button in Attribute Page for other portfolio
		if(Portfolio != Nokia_CPQ_Constants.MICROWAVE_PORTFOLIO){
			for(Apttus_Config2.DisplayActionInfo actionInst : disActionInfoList){
	Apttus_Config2__ConfigCustomDisplayActions__c ActionSOInst = actionInst.ActionSO;
	String actionName = ActionSOInst.Apttus_Config2__ActionLabelName__c;
	if(actionName.equals('MicrowaveCATconfigurator')) {
		// MAKE ACTION INVISIBLE!!!
		actionInst.IsEnabled = false;
		actionInst.ActionSO.Apttus_Config2__IsEnabled__c= false;
	} 
			}
		}
		
	}
	global static void setActionProperties(Apttus_Config2.CustomClass.ActionParams actionParam){
	}
}