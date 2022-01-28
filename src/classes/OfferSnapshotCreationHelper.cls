/**
* @description: This class will be called for populating certain fields of opportunity on offer when oppty phase status is
* is changed from G3 to G4 Approvals.
* @author:	Accenture IDC.
*
* ============================================================================
* History:
* -------
*
* VERSION AUTHOR	DATE		DETAIL			FEATURES/CSR/TTP
* 1.0	 Accenture	26/12/2016  Sprint 3 Doc Stretegy & LoA requirements.
* ============================================================================
*/
public without sharing class OfferSnapshotCreationHelper
{
/**********************************************************************************************************************
* author: Accenture
* Date: June-2017
* Param: None
* Return: void
* Description: Updates Opportunity fields when Excel-AddIn updates Offer fields
* High Level Process :
**********************************************************************************************************************/
	public static void updateOpportunity(List<Opportunity> opptiesToUpdate)
	{
		try
		{
			// stop opportunity trigger execution.
			GlobalConstants.SKIP_TRIGGER_OPPORTUNITY_ON_PRESALES = True;
			Database.SaveResult[] savedResults = Database.update(opptiesToUpdate, false);
			List<Exception__c> listExcp = new List<Exception__c>();
			for (Database.SaveResult sr : savedResults)
			{
				if (!sr.isSuccess())
				{
					for (Database.Error err: sr.getErrors())
					{
						Exception__c excLog = new Exception__c();  excLog.Class__c = OfferSnapshotCreationHelper.class.getName();  excLog.Message__c = 'Error occured : ' + err.getStatusCode()+' ; Error::: '+ err.getMessage() +' ; field(s) that affected this error : ' +err.getFields();  excLog.Message__c = 'Error occured : ' + err.getStatusCode()+' ; Error::: '+ err.getMessage() +' ; field(s) that affected this error : ' +err.getFields();   excLog.Method__c = GlobalConstants.METHOD_UPDATEOPPORTUNITY;   excLog.Error__c = err.getMessage();   listExcp.add(excLog);
					}
				}
			}
			if (listExcp.size() > 0)
			{
				ExceptionHandler.logExceptions(listExcp);
			}
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, OfferSnapshotCreationHelper.class.getName(), GlobalConstants.METHOD_UPDATEOPPORTUNITY);
		}
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Aug-2017
* Param: Offer__c Trigger Map Trigger.New & Trigger.Old
* Return: void
* Description: Add Custom code validation on Offer that, Only User from Offer team OR Opportunity Team with Role = "Pricing Manager" can set value
* as "LoA Bypass offer condition" = "Authorized for Pricing Manager".
* High Level Process : Req. # 2790 : put custom validation on Offer Edit.
**********************************************************************************************************************/
	public static void validateLoABypassOfferConditionFieldValue(Map<Id, Offer__c> offerOldMap, Map<Id, Offer__c> offerNewMap)
	{
		Map<id, Offer__c> filteredOfferMap = new Map<Id, Offer__c>();
		Map<Id, Id> offerIdOpptyIdMap = new Map<Id, Id>();
		Map<Id, Boolean> offerIdFinalErrorFlagMap = new Map<Id, Boolean>();
		try
		{
			// collect LoA Bypass Offer Condition Field updated Oppties
			for(Offer__c objOfferNew : offerNewMap.values())
			{
				Offer__c objOfferOld = offerOldMap.get(objOfferNew.id);
				system.debug('objOfferNew.LOA_Bypass__c>>>'+objOfferNew.LOA_Bypass__c);
				system.debug('objOfferOld.LOA_Bypass__c>>>'+objOfferOld.LOA_Bypass__c);
				if(objOfferNew.LOA_Bypass__c != NULL && !objOfferNew.LOA_Bypass__c.equalsIgnoreCase(objOfferOld.LOA_Bypass__c) &&
				   objOfferNew.LOA_Bypass__c.equalsIgnoreCase(GlobalConstants.PICKLIST_VALUE_AUTHORIZED_FOR_PRICING_MANAGER))
				{
					filteredOfferMap.put(objOfferNew.id, objOfferNew);
					// collect related Oppty to check Oppty Share for Logged In user.
					offerIdOpptyIdMap.put(objOfferNew.id, objOfferNew.Opportunity__c);
				}
			}
			
			system.debug('LoA Bypass Offer Condition Field updated Offer:::>>'+filteredOfferMap);
			if(filteredOfferMap != NULL && filteredOfferMap.Size() > 0)
			{
				// validate Oppty Team role for logged in user
				offerIdFinalErrorFlagMap = validateOfferFieldEditForPricingManager(filteredOfferMap, offerIdOpptyIdMap);
				if(offerIdFinalErrorFlagMap != NULL)
				{
					for(id updatedOfferId : offerNewMap.keySet())
					{
						if(offerIdFinalErrorFlagMap.containsKey(updatedOfferId) && offerIdFinalErrorFlagMap.get(updatedOfferId))
						{
							offerNewMap.get(updatedOfferId).AddError(Label.Validation_Error_Message_For_LoA_Bypass_Offer_Condition_Field_Of_Offer);
						}
					}
				}
			}
		}
		catch(exception ex)
		{
			ExceptionHandler.addException(ex, OfferSnapshotCreationHelper.class.getName(), GlobalConstants.FUNCTION_LOA_BYPASS_OFFER_CONDITION_VALIDATION);
		}
		
	}
	
	/**********************************************************************************************************************
* author: Accenture
* Date: Aug-2017
* Param: Map<Id, Offer__c> filteredOfferMap, Set<Id> relatedOpptiesIdSet
* Return: Map<Id, Offer__c> Offer Map with error (not passed in validation )
* Description: check logged in user Role in Opportunity & Offer Team.
* High Level Process : Req. # 2790 : put custom validation on Offer Edit.
**********************************************************************************************************************/
	public static Map<Id, Boolean> validateOfferFieldEditForPricingManager(Map<Id, Offer__c> filteredOfferMap, Map<Id, Id> offerIdOpptyIdMap)
	{
		Map<Id, Boolean> offerIdFinalErrorFlagMap = new Map<Id, Boolean>();
		Map<Id,Id> offerRelatedOpptyIdMap = new Map<Id,Id>();		
		try
		{
			// Mark every offer as Failed in Validaton and latter check/ update after validation,
			for(id offerId : filteredOfferMap.keySet())
			{
				offerIdFinalErrorFlagMap.put(offerId, true);
			}
			
			system.debug('User Id>>>>'+UserInfo.getUserId());
			// Check Logged-In user is part of Offer Team with Pricing Manager Role.
			for(Offer_Team__c offerTeamMap : [Select Id, Name__c, Offer__c, Team_Member_Role__c From Offer_Team__c Where Name__c =: UserInfo.getUserId() And Offer__c IN : filteredOfferMap.keySet()])
			{
				system.debug('offerTeamMap.Team_Member_Role__c>>>'+offerTeamMap.Team_Member_Role__c);
				if(offerTeamMap.Team_Member_Role__c == GlobalConstants.OFFER_OPPTY_TEAM_ROLE_PRICING_MANAGER || offerTeamMap.Team_Member_Role__c == System.Label.NF_PricingManagerLead)
				{
					offerIdFinalErrorFlagMap.put(offerTeamMap.Offer__c, false);
				}
			}
			
			for(Id offerId : offerIdFinalErrorFlagMap.keySet()){
				if(offerIdFinalErrorFlagMap.get(offerId)){
					offerRelatedOpptyIdMap.put(offerIdOpptyIdMap.get(offerId), offerId);
				}
			}
			
			// check if offerRelatedOpptyIdMap is empty, if not query by oppty team members for those oppties
			if( !offerRelatedOpptyIdMap.isEmpty() )
			{
				for(OpportunityTeamMember objOpptyTeamMem : [Select Id, OpportunityId, TeamMemberRole, UserId From OpportunityTeamMember Where UserId =: UserInfo.getUserId() And OpportunityId IN :offerRelatedOpptyIdMap.keySet()])
				{
					Id offerId = offerRelatedOpptyIdMap.get(objOpptyTeamMem.OpportunityId);
					if(offerIdFinalErrorFlagMap.get(offerId) && ( objOpptyTeamMem.TeamMemberRole.EqualsIgnoreCase(GlobalConstants.OFFER_OPPTY_TEAM_ROLE_PRICING_MANAGER) || objOpptyTeamMem.TeamMemberRole.EqualsIgnoreCase(System.Label.NF_PricingManagerLead)))
					{
						offerIdFinalErrorFlagMap.put(offerId, false);
					}
				}
			}
			system.debug('Final Map with Validation >>'+offerIdFinalErrorFlagMap);
		}
		Catch(exception ex)
		{
			ExceptionHandler.addException(ex, OfferSnapshotCreationHelper.class.getName(), GlobalConstants.FUNCTION_VALIDATE_OFFER_FIELD_FOR_PRICING_MANAGER);
		}
		return offerIdFinalErrorFlagMap;
	}
	/**********************************************************************************************************************
* author: Accenture
* Date: Dec-2017
* Param: None
* Return: void
* Description:
- req.#3845 - Add error on offer field update.. use to put custom validation on Offer Update/
- Req. : 3865 : Enable edit for "Approval Scope" field
- Req : 4703 : Updates in LoA based on new DocStrategy ReDesign
- Ticket 8554

*
@description: Freeze of LoA data after their upload in CRM (Excel add-in replacement)
@Release: #1748
@Author: Nuno Cartier
*
* High Level Process :
**********************************************************************************************************************/
	public static void validateOfferFieldsLoA(Map<ID,Offer__c> offerNewMap,Map<ID,Offer__c> offerOldMap)
	{
		String strOldValueSituation ,strNewValueSituation ;
		try
		{
			for (Offer__c objOffer : offerNewMap.Values())
			{
				if(objOffer.Loa_Approval_level_G4__c != null || objOffer.Loa_Approval_level_G5__c != null || Test.isRunningTest() )
				{
					strOldValueSituation = offerOldMap.get(objOffer.id).Customer_and_Competitive_Situation__c==null?GlobalConstants.BLANK_VALUE: offerOldMap.get(objOffer.id).Customer_and_Competitive_Situation__c;
					strNewValueSituation = objOffer.Customer_and_Competitive_Situation__c == null?GlobalConstants.BLANK_VALUE:objOffer.Customer_and_Competitive_Situation__c;
					if(String.valueOf(strOldValueSituation.escapeUnicode()).replace(GlobalConstants.SPECIAL_CHARACTER, GlobalConstants.BLANK_VALUE) != String.valueOf(strNewValueSituation.escapeUnicode()).replace(GlobalConstants.SPECIAL_CHARACTER, GlobalConstants.BLANK_VALUE))
					{
						objOffer.addError(GlobalConstants.ERROR_FOR_CUSTOMER_COMPETITIVE_SITUATION_FIELD);
					}
				}
			}
			
		}
		catch(Exception ex)
		{
			ExceptionHandler.addException(ex, OfferSnapshotCreationHelper.class.getName(), GlobalConstants.UPDATEOPPORTUNITYBOMINSERT);
		}
	}
	
}