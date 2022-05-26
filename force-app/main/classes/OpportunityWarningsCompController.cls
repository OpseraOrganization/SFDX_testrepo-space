/****************************************
* Controller of the Lightning Component Opportunity Warnings
* It's used for the logic of :
* 		> Main Reason pre-populated info pop-up
* 		> Offer and Opportunity Warning
*	> Opportunity Decision Date override from OIF (F1784 - Mar 2020)
*/

public with sharing class OpportunityWarningsCompController {
	
	private static final Id indirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.Indirect_Record_Type).getRecordTypeId();
	
	@AuraEnabled
	public static String[] validateFieldsAccessibility(){
		String[] fields = new String[]{ 'StageName', 'Phase_Status__c','Lead_BG__c','DS_Reasons_Populated__c', 'OIF_Amount_EUR__c', 'SWx_Upsell_Proposal__c', 'Last_Refresh_OIF__c','OIF_Lines__c','G5_Planned_Date__c', 'IsClosed', 'Care_Renewal__c','Upside_Subtotal__c','Risk_Subtotal__c','Risk_Categories__c','Risk_Rating__c','Risk_type__c','Upside_Categories__c','Upside_Rating__c','Type'};			
			
			String[] accessibleFields = new String[]{};
				
				Map<String,Schema.SObjectField> opptyFields = Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap();
		for(String field : fields){
			if(opptyFields.containsKey(field) && opptyFields.get(field).getDescribe().isAccessible()){
				accessibleFields.add(field);
			}
		}
		return accessibleFields;
	}
	
	@AuraEnabled 
	public static boolean getOpptyInfo(Id currentRecordId){
		try{
			for(Opportunity currentOpp : [SELECT Id FROM Opportunity WHERE Id =: currentRecordId AND RecordTypeId = :indirectRecordTypeId AND CreatedDate = TODAY LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]){
				return true;
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.OPPTYINFOCONTROLLER, GlobalConstants.GETOPPTYINFO);
		}
		return false;
	}
	
	
	// Server side method to check if the Opportunity is complaint with the logic and warn the user that the main reasons are pre-populated
	@AuraEnabled
	public static Integer checkOpttyStageParams(Id recordId)
	{
		Opportunity oppty = [Select Id, StageName, Phase_Status__c,Lead_BG__c,DS_Reasons_Populated__c,OIF_Amount_EUR__c, SWx_Upsell_Proposal__c from Opportunity WHERE id =: recordId LIMIT 1];
		if(oppty.SWx_Upsell_Proposal__c!= null && oppty.DS_Reasons_Populated__c ==true && oppty.OIF_Amount_EUR__c > CSWXGlobalConstant.threshold  &&((oppty.StageName == CSWXGlobalConstant.EXECUTE_STAGE && oppty.Phase_Status__c == CSWXGlobalConstant.EXECUTE_PHASE && oppty.Lead_BG__c == CSWXGlobalConstant.MN )||(oppty.StageName == CSWXGlobalConstant.CLOSED_STAGE && oppty.Phase_Status__c == CSWXGlobalConstant.CLOSED_PHASE) || (oppty.StageName == CSWXGlobalConstant.HANDOVER_OPPTY && oppty.Phase_Status__c == CSWXGlobalConstant.PTA_HANDOVER))){
			return 1;
		}
		return 0;
	}
	
	
	// Server side method to verify offers in the opportunity to show the warning to the user
	@AuraEnabled
	public static String findOffer(Id recordId, String url){
		
		String offerWarningMsg = GlobalConstants.BLANK_VALUE;
		
		try{
			
			if(recordId != null && url.contains(recordId) && String.isNotBlank(url)){
				
				List<Offer__c> offerList = [SELECT id, Opportunity__r.Phase_Status__c
											FROM Offer__c
											WHERE Opportunity__r.Phase_Status__c =: GlobalConstants.OFFERSUBMITTEDTOCUSTOMER
											and ActiveOffer__c = true
											and Opportunity__c =:recordId
											and Opportunity__r.Business_Type__c <> :GlobalConstants.FAST_TRACK_OPP_TYPE LIMIT: (Limits.getLimitQueryRows() - Limits.getQueryRows())];
				
				if(!offerList.isEmpty()){
					offerWarningMsg = System.label.Warning_Message;
				}
				
			}
			
		}catch(Exception ex){
			ExceptionHandler.addException(ex, GlobalConstants.OFFER_WARNING_MSG, GlobalConstants.GET_OFFER_ID);
		}
		
		return offerWarningMsg;
	}
	
	//F1784 - Verify OIF changes and check if there is a new proposed Decision Plan Date
	@AuraEnabled
	public static Date checkMinPlanDateOIF(Id recordId){
		
		Date newWDPlanDate = null;
		Id userId = UserInfo.getUserId();
		List<String> openStatusOIF = GlobalConstants.OPEN_STATUS_OIF.split(',');
		
		try {
			//get all OIFs from the oppty , even the ones deleted during today , to check the earliest one 
			List<Order_Intake_Forecast__c> oifs = [SELECT Id, POPlanReceipt__c, POPlanReceipt__r.Start_Date__c, POPlanReceipt__r.End_Date__c, Forecast_Category__c, Opportunity__c, Opportunity__r.G5_Planned_Date__c, Opportunity__r.StageName, LastModifiedById, LastModifiedDate, IsDeleted
												   ,POPlanReceipt__r.Period_Number__c,POPlanReceipt__r.Year__c FROM Order_Intake_Forecast__c WHERE Opportunity__c = :recordId AND Opportunity__r.isClosed = false AND Forecast_Category__c IN :openStatusOIF AND ( IsDeleted = FALSE OR LastModifiedDate = TODAY ) ORDER BY LastModifiedDate DESC ALL ROWS];
			
			if(!oifs.isEmpty()){
				//check if the last modified (or deleted) was performed by the user looking at the oppty
				if(oifs[0].LastModifiedById != userId){
					return newWDPlanDate;
				}
				
				Date oppWDPlanDate = oifs[0].Opportunity__r.G5_Planned_Date__c;
				Date minStartPOPlanDate = null;
				Date minEndPOPlanDate = null;
				Date startOfMonthDate = null;
				//find earliest interval (only the existing OIFs)
				for(integer k = 0 ; k < oifs.size(); k++){
					if(!oifs[k].isDeleted && ( (minStartPOPlanDate == null && minEndPOPlanDate == null) || oifs[k].POPlanReceipt__r.End_Date__c < minEndPOPlanDate )){
						minEndPOPlanDate = oifs[k].POPlanReceipt__r.End_Date__c;
						minStartPOPlanDate = oifs[k].POPlanReceipt__r.Start_Date__c;
						startOfMonthDate = Date.newInstance(Integer.valueOf(oifs[k].POPlanReceipt__r.Year__c), Integer.valueOf(oifs[k].POPlanReceipt__r.Period_Number__c), 1);
					}
				}
				//Changes as per SF-02111848
				if(oppWDPlanDate == null || minStartPOPlanDate > oppWDPlanDate || minEndPOPlanDate < oppWDPlanDate){
					//set the date to the last day of the month of the beggining of the calendar
					newWDPlanDate = ((startOfMonthDate.addMonths(1)).toStartOfMonth()).addDays(-1);
				}
				
			}
			
		} catch (Exception ex) {
			ExceptionHandler.addException(ex, OpportunityWarningsCompController.class.getName(), 'checkMinPlanDateOIF');
		}
		
		return newWDPlanDate;
	}
	
	//F1784 - Update the G5 Plan Date in the opportunity
	@AuraEnabled
	public static void overrideDecisionPlanDate(Id recordId, Date newWDPlanDate) {
		update new Opportunity(Id=recordId, G5_Planned_Date__c=newWDPlanDate);
	}
	
	//ft-241
	@AuraEnabled
	public static String createCareRenewalOpp(Id recordId, Integer renewalYears) {
		String returnMessage;
		if(renewalYears != null)
		{
			returnMessage = CloneOpportunity.cloneOpp(String.valueOf(recordId), renewalYears);
		}
		return returnMessage;
	}
	
	@AuraEnabled
	public static  Map<Id, Order_Intake_Forecast__c> fetchCareOIFLinesApex(Id recordId)
	{
		Map<Id, Order_Intake_Forecast__c> careOIFLines = new Map<Id, Order_Intake_Forecast__c>();
		List<String> careOIFList = System.label.CRM_Care_OIF_PL.split(';');
		List<Opportunity> oppList = [SELECT Id, Care_Renewal__c,
									 (SELECT Id, Forecast_Category__c, LastModifiedById, BusinessLine__r.ProductCode FROM Order_Intake_Forecast_del__r WHERE BusinessLine__r.ProductCode IN :careOIFList),
									 (SELECT Id FROM RenewedOpportunties__r) 
									 FROM Opportunity WHERE IsDeleted = false AND Id = :recordId AND Care_Renewal__c = true];
		if(oppList.size() > 0 && oppList[0].RenewedOpportunties__r.size() == 0)
		{
			careOIFLines = new Map<Id, Order_Intake_Forecast__c>(oppList[0].Order_Intake_Forecast_del__r);
		}
		return careOIFLines;
	}
}