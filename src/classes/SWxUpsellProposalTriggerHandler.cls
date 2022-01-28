/*******************************
Class Name: SWxUpsellProposalTriggerHandler
Created By: Accenture
Created Date: 5th June 2017
Last Modified By: Accenture
Last Modified Date: 5th June 2017
Description: Handler Class for SWxUpsellProposalTrigger which is used for 3 business validation rule
*******************************/
public with sharing class SWxUpsellProposalTriggerHandler {
 /*****************************
*Method Name: BeforeUpdate
*Description: This is handler method for before update on SWx Upsell Proposal  
*Parameters: SWx Upsell Proposal List,SWx Upsell Proposal Map
*******************************/
 public static void beforeUpdate(List<SWx_Upsell_Proposal__c> upsellProposalList,Map<Id,SWx_Upsell_Proposal__c>oldmap){
		  
		  try{
				if(!CSWXGlobalConstant.recCheckStatus){
						SWxUpsellProposalTriggerHelper.checkStatus(upsellProposalList,oldmap);
						CSWXGlobalConstant.recCheckStatus = true;
				} 
				SWxUpsellProposalTriggerHelper.errorOnUpdate(upsellProposalList);
				SWxUpsellProposalTriggerHelper.updateProposalStageToCloseValidated(upsellProposalList);
			   if(Test.isRunningTest()){
					CustomException testingCatch = new CustomException(GlobalConstants.ERROR_TEXT);
					throw testingCatch; 
				}	
		  }catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.dproposalHandler,CSWXGlobalConstant.upsellProposalListMethod);
			   
		   }  
	
	}
/*****************************
*Method Name: AfterUpdate
*Description: This is handler method for after update on SWx Upsell Proposal  
*Parameters: SWx Upsell Proposal List
*******************************/	
	public static void afterUpdate(List<SWx_Upsell_Proposal__c> upsellProposalList,Map<Id,SWx_Upsell_Proposal__c> oldupsell){
  
		  try{
		  
		  //SWxUpsellProposalTriggerHelper.InsertFile(Trigger.new);
				
			   if(!CSWXGlobalConstant.recCheck && upsellProposalList[0].Upsell_Status__c == CSWXGlobalConstant.convert && oldupsell.get(upsellProposalList[0].id).Upsell_Status__c !=CSWXGlobalConstant.convert){
				  SWxUpsellProposalTriggerHelper.createOppty(Trigger.new);
				  
				  CSWXGlobalConstant.recCheck = true;
				}
			 
			  List <SWx_Upsell_Proposal__c>dpRecList = new List<SWx_Upsell_Proposal__c>();
			  for(SWx_Upsell_Proposal__c dpRec : upsellProposalList){
				  System.debug('Inside handler>>>>>');
				  if(((dpRec.Upsell_Status__c == CSWXGlobalConstant.VALIDATED || dpRec.Upsell_Status__c == CSWXGlobalConstant.readyForConversion) && oldupsell.get(dpRec.Id).Upsell_Status__c ==CSWXGlobalConstant.readyForReview) ){
					  dpRecList.add(dpRec);
				   }
			   } 
			  if(CSWXGlobalConstant.Recursivecheck_CPO == CSWXGlobalConstant.FalseVal && !dpRecList.isEmpty()){
				  System.debug('CSWXGlobalConstant.Recursivecheck_CPO>>>>'+CSWXGlobalConstant.Recursivecheck_CPO);
				  System.debug('dpRecList'+dpRecList);
				   SWxUpsellProposalTriggerHelper.dpConsumptionOnValidate(dpRecList);
			  }
			 
			 
			  if(Test.isRunningTest()){
					CustomException testingCatch = new CustomException(GlobalConstants.ERROR_TEXT);
					throw testingCatch; 
				}	
		  }catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.dproposalHandler,CSWXGlobalConstant.upsellProposalListMethod);
			   
		   }  
	
	}
	
	/*****************************
*Method Name: AfterUpdate
*Description: This is handler method for after update on SWx Upsell Proposal  
*Parameters: SWx Upsell Proposal List
*******************************/	
	public static void XAuthorCall(List<SWx_Upsell_Proposal__c> upsellProposalList, Map<Id,SWx_Upsell_Proposal__c> oldupsellMap){
  
		  try{
		  SWxUpsellProposalTriggerHelper.XAuthorCall(upsellProposalList, oldupsellMap);
			  
		  }catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.dproposalHandler,CSWXGlobalConstant.upsellProposalListMethod);
			   
		   }  
	
	}
	
	
	/*****************************
*Method Name: AfterUpdate
*Description: This is handler method used to send json to Eccenca 
*Parameters: newProposalList ,oldProposalMap
*******************************/	
	public static void sendJsonToEccenca(List<SWx_Upsell_Proposal__c> newProposalList,Map<Id,SWx_Upsell_Proposal__c> oldProposalMap){
	
		System.debug('newProposalList--->'+newProposalList);
		try{

				 Id [] dpList = new List<Id>();
		
				for(SWx_Upsell_Proposal__c propList :newProposalList){
						System.debug('old------>'+oldProposalMap.get(propList.id).Entitlement_Info__c);
						System.debug('New------>'+propList.Entitlement_Info__c);
						System.debug('CPO----->'+propList.PO__c);
						System.debug('propList.Delivery_System__c----->'+propList.Delivery_System__c);
				
					If(propList.PO__c != null && propList.Delivery_System__c==CSWXGlobalConstant.SWMP && 
						propList.Entitlement_Info__c ==CSWXGlobalConstant.entitledValue && 
						(oldProposalMap.get(propList.id).Entitlement_Info__c != propList.Entitlement_Info__c || 
						oldProposalMap.get(propList.id).PO__c != propList.PO__c)){
						dpList.add(propList.id);
						System.debug('inside for loop');
					   
				   }
				}
				  System.debug('dpList---->'+dpList);
				  
				  if(dpList!=null && !dpList.isEmpty()) {
					   if(checkRecursive.runOnce()){
					   System.debug('inside recursive');
					  SWxUpsellProposalTriggerHelper.sendJson(dpList);
					  }
				  
				  }
			 
			  
		  }catch(Exception ex){
			   ExceptionHandler.addException(ex,CSWXGlobalConstant.dproposalHandler,CSWXGlobalConstant.sendJsonToEccencaMethod );
			   
		   }  
	 }
	
	
	
	
	
   
 }