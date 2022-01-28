/*******************************
Class Name: OpptyGateInfoController
Created by: Accenture
Description: 
Req.:  sales process
*******************************/
public without sharing class OpptyGateInfoController {
	private static final Id directRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.DIRECT_OPPTY).getRecordTypeId();
	private static final Id inDirectRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(GlobalConstants.INDIRECT_OPPTY).getRecordTypeId();
	
	/*******************************
Method Name: getOpptyGateInfo
Description: 
Req.: sales process
*******************************/ 
	@AuraEnabled 
	public static String getOpptyGateInfo(Id currentRecordId){
		String message ;
		try{
			if(currentRecordId != null)  
			{				
				List <Sales_Role__c> salesRolesUser = [SELECT Role_Name__c,User__c FROM Sales_Role__c 
													   WHERE Role_Name__c LIKE :GlobalConstants.WILDCARD_SEARCH+System.Label.CO_Market_Sales_Ops+GlobalConstants.WILDCARD_SEARCH
													   and User__c =: UserInfo.getUserId() 
													   LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()]; 
				if(salesRolesUser.isEmpty()){
					message = System.Label.Advanced_PO_Booking_By_CO_Market_Sales_Ops; 
				}else{
					
					Opportunity currentOpp = [SELECT id,StageName, RecordTypeId,Advanced_PO_Booking__c FROM Opportunity
											  WHERE Id =: currentRecordId and 
											  (RecordTypeId =: inDirectRecordTypeId OR RecordTypeId =: directRecordTypeId)
											  LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
					if(currentOpp.Advanced_PO_Booking__c == true)
					{
						message = System.Label.AdvanedPOBooking_Confirmation;
					}
					else 
					{
						if(currentOpp.StageName == GlobalConstants.IDENTIFY_OPPORTUNITY || 
						   currentOpp.StageName ==  GlobalConstants.DEVELOP_OPPORTUNITY ||
						   currentOpp.StageName == GlobalConstants.CREATE_OFFER) 
						{
							message = System.Label.AdvanedPOBooking_Error;
						}
						else if (currentOpp.StageName == GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE || 
								 currentOpp.StageName == GlobalConstants.HANDOVER_OPPTY || 
								 currentOpp.StageName == GlobalConstants.COMPLETED_OPPTY) 
						{
							message = System.Label.AdvanedPOBooking_Display;
						}
					}
				}
				
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.OPPTYINFOCONTROLLER, GlobalConstants.GETOPPTYINFO);
		}
		return message;
	}
	
	/*******************************
Method Name: getOpptyGateInfo
Description: 
Req.: sales process
*******************************/
	@AuraEnabled 
	public static String confirmPOBookingCtrl(String poReference, Id currentRecordId){
		String message ;
		try{
			if(currentRecordId != null)
			{
				Opportunity currentOpp = [SELECT id,StageName,Phase_Status__c, PO_Reference__c,RecordTypeId,Advanced_PO_Booking__c FROM Opportunity
										  WHERE Id =: currentRecordId
										  LIMIT: Limits.getLimitQueryRows() - Limits.getQueryRows()];
				if((currentOpp.RecordTypeId == inDirectRecordTypeId || currentOpp.RecordTypeId == directRecordTypeId) &&
				   currentOpp.StageName == GlobalConstants.WIN_THE_CASE_OPPORTUNITY_STAGE )				
				{
					system.debug('In confirmPOBookingCtrl');
					currentOpp.Advanced_PO_Booking__c = GlobalConstants.VALUE_TRUE;
					if(String.isNotBlank(poReference)){
						currentOpp.PO_Reference__c = poReference;
					}
					system.debug('currentOpp.Advanced_PO_Booking__c>>'+currentOpp.Advanced_PO_Booking__c);
					system.debug('currentOpp.PO_Reference__c>>'+currentOpp.PO_Reference__c);
					Database.SaveResult savedResults = Database.update(currentOpp, false);
					Boolean someFailure = false;
					if (!savedResults.isSuccess()) {
						someFailure = true;
						for (Database.Error err: savedResults.getErrors()) {
							message = err.getMessage();
							System.debug('Error occured : ' + err.getStatusCode() + ' : ' + err.getMessage());
							System.debug('Fields that affected this error : ' + err.getFields());
						}
					}
					if (!someFailure) {
						message = System.Label.AdvanedPOBooking_OpptyUpdate;
					} 
				}
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, GlobalConstants.OPPTYINFOCONTROLLER, GlobalConstants.CONFIRMPOBOOKINGCTRL);
		} 
		return message;
	}
	
}