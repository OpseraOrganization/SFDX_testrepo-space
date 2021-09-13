/****************************************
 * Class Name : LeadTriggerHandlerPRM
 * Created Date: 27 July 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 27 July 2017
 * Description : Handle the sequence of the LeadTriggerHelperPRM (It Contains Functionality of PRM)
 * Test Class: 
 *****************************************/
public without sharing class LeadTriggerHandlerPRM{

/**********************************************************************************************************************
* author: Accenture
* Date: Dec-2016
* Param: Map<Id,Lead> leadNewMap
* Return: void
* Description: Method for afterUpdateLead
* High Level Process : share lead with bus ops and direct approver
**********************************************************************************************************************/  
	 public static void afterUpdateLead(Map<Id,Lead> leadNewMap){
		try{
			 List<LeadShare> leadShareToInsert = new List<LeadShare> ();
			 
		   /********Lead share with Bus_Ops_Approver__c ********/
		   for(Lead lead : leadNewMap.Values()){
			   if(string.IsNotblank(lead.Bus_Ops_Approver__c)){
				
							LeadShare share = new LeadShare();
							share.UserOrGroupId = lead.Bus_Ops_Approver__c;
							share.LeadId = lead.Id;
							share.LeadAccessLevel = PRMGlobalConstants.READ;
							share.RowCause = PRMGlobalConstants.MANUAL;
							leadShareToInsert.add(share);
				}
			}
		  
			 Database.SaveResult[] srList = Database.insert(leadShareToInsert, false);
			
			/********Lead share with Direct_Sales_Approver__c ********/
			 List<LeadShare> leadShareToApprover = new List<LeadShare> ();
		   for(Lead lead : leadNewMap.Values()){
			   if(string.IsNotblank(lead.Direct_Sales_Approver__c)){
				
							LeadShare share = new LeadShare();
							share.UserOrGroupId = lead.Direct_Sales_Approver__c;
							share.LeadId = lead.Id;
							share.LeadAccessLevel = PRMGlobalConstants.READ;
							share.RowCause = PRMGlobalConstants.MANUAL;
							leadShareToApprover.add(share);
				}
			}
		  
			 Database.SaveResult[] srListoApprover= Database.insert(leadShareToApprover, false);
		}
		
		catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.LEAD_TRIGGER_HANDLER_PRM,PRMGlobalConstants.afterUpdateLead);
		}
	}   
	
/**********************************************************************************************************************
* author: Accenture
* Date: Dec-2016
* Param: Map<Id,Lead> leadNewMap
* Return: void
* Description: Method for afterUpdate
* High Level Process : update Lead owner with partner
**********************************************************************************************************************/  
	public static void afterUpdate(List<Lead> leadList ,Map<Id,Lead> leadOldMap){  
		try{
			LeadTriggerHelperPRM.updateValueAssignment(leadList,leadOldMap);
			  LeadTriggerHelperPRM.updateValueAssignment(leadList,leadOldMap);
			Map<Id, Lead> leadMap = new Map<Id, Lead>([SELECT Id, Distributor_account__r.Involve_Distributor_in_IR_Deal_Registrat__c 
														   FROM Lead where id in : leadList Limit : (Limits.getLimitQueryRows() - Limits.getQueryRows())]);
			List<Lead> leadToShare = new List<Lead>();
			for(Lead lead : leadList)
			{
				if(lead.DistributorPRM__c!=leadOldMap.get(lead.id).DistributorPRM__c && Lead.DistributorPRM__c!=null && leadMap.get(lead.Id).Distributor_account__r.Involve_Distributor_in_IR_Deal_Registrat__c)
				{
					leadToShare.add(lead);
				}
			   
			}
			if(leadToShare.size()>0)
			{
				LeadTriggerHelperPRM.ShareToDistributorPRM(leadToShare);
			}
		}catch(Exception e) {
			ExceptionHandler.addException(e,PRMGlobalConstants.LEAD_TRIGGER_HANDLER_PRM,PRMGlobalConstants.afterUpdate);}
	}
	
	
}//end of class LeadTriggerHandlerPRM