/****************************************
* Name : HWS_CaseFlow
* Author : TCS
* Description : This class is submitting SOO requests. It is called from a batch class HWS_BulkUpload_Batch. It
* SOO is called in a bactch class HWS_BulkUpload_SOOCallout_Batch. 
* Test class : HWS_BulkUpload_Batch_Test 
* ReqNo : NOKIASC-37921
****************************************/
public without sharing class HWS_BulkUpload_SOOCallout_Batch implements Database.AllowsCallouts, Database.batchable < sObject>,  Database.Stateful , Database.RaisesPlatformEvents{
	public set<Id> lstParentCases = new set<Id>();
	public string sActionType; 
	public HWS_BulkUpload_SOOCallout_Batch(set<Id> parentCases, string sType){
	system.debug('Abhay----caliing1 HWS_CaseFlow.makeSOOCallout');
		this.lstParentCases = parentCases;
		this.sActionType = sType;
	}
	public Database.QueryLocator  start(Database.BatchableContext bc) {
		string sSOQL = 'SELECT ID FROM CASE WHERE ID IN: lstParentCases';
		return Database.getQueryLocator(sSOQL);
	}
	public void execute(Database.BatchableContext batchableContext, List<Case> lstCase){
		
		if(this.sActionType == 'Submit'){  
			system.debug('Abhay----caliing HWS_CaseFlow.makeSOOCallout');
				HWS_CaseFlow.makeSOOCallout(lstCase[0].id);
			system.debug('Abhay----caliing HWS_CaseFlow.makeSOOCallout done');
				List<case> lstCases = [select id,Status from case where ParentId =:lstCase[0].id and parent.HWS_Is_Error__c = false];
				for(case c :lstCases){
					c.Status ='Ordered';
				}
				update lstCases;
		}
		else{  
			system.debug('Calling this method start---');			
			HWS_SendServiceRequesttoSOO_SVC.sendBulkToSOO(lstCase[0].id);  
			system.debug('Calling this method end---');			
		}
	}
	
	public void finish(Database.BatchableContext batchableContext) {
	   
		
	}
}