global without sharing class CRM_PSROLoALevel_Batch  implements Database.Batchable<sObject>, Database.Stateful  {
	
	public String csvInfo = '';

	global Database.QueryLocator start(Database.BatchableContext context)
	{	
		return Database.getQueryLocator([SELECT Id, PSR_Cost_BU_NI_FN__c , PSR_Cost_BU_NI_IPRTG__c , PSR_Cost_BU_NI_OPTICS__c , PSR_Cost_BG_MN__c , PSR_Cost_BG_CNS__c, PSR_Cost_BG_NI__c,
										 Org_L3__c,Org_L4__c,Org_L5__c,CurrencyIsoCode, Lead_BG__C, Lead_BU__c, PSR_LoA_Level__c, PSR_Reference_Opportunity__c,
										 PSR_Pre_Sales_Risk_Opportunity_Type__c, PSR_Pre_Sales_Risk_Opportunity_Sub_Type__c, PSR_Total_Cost_In_Euro__c, PSR_Total_Sales_Value_In_Euro__c FROM Opportunity 
										 WHERE RecordType.DeveloperName In ('Pre_Sales_Risk_Opportunity','Pre_Sales_Risk_Opportunity_read_only')
										 AND StageName = 'Preparation']);
	}
	
	global void execute(Database.BatchableContext context, List<Opportunity> psros)
	{
		Set<Id> refOpptiesIds = new Set<Id>();
		
		for(Opportunity psro : psros){
			refOpptiesIds.add(psro.PSR_Reference_Opportunity__c);
		}
		
		OpportunityTriggerHelper_PreSales.calculatePSROApprovalLevel(psros, refOpptiesIds, null);
				
		Database.SaveResult[] results = Database.update(psros, false);
		
		for (Database.SaveResult sr : results) {
			if (sr.isSuccess()) {
				csvInfo += sr.getId() + ';TRUE;\n';
			}
			else {
				csvInfo += sr.getId() + ';FALSE;';				
				for(Database.Error err : sr.getErrors()) {
					csvInfo += err.getMessage() + '//';
				}
				csvInfo += '\n';
			}
		}
	}
	
	global void finish(Database.BatchableContext context)
	{
		Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();  
		Messaging.EmailFileAttachment csv_Attach = new Messaging.EmailFileAttachment();
		List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
		
		String csv = 'Id;Updated;Comments\n' + csvInfo;
	
		Blob csvBlob = Blob.valueOf(csv);
		csv_Attach.setFileName('PSROLoALevel_Batch_Results.csv');
		csv_Attach.setBody(csvBlob);
		fileAttachments.add(csv_Attach);
		email.setFileAttachments(new Messaging.EmailFileAttachment[]{csv_Attach});
		
		AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :context.getJobId()];
		String[] toAddresses = new String[] {a.CreatedBy.Email};
		email.setToAddresses(toAddresses);
		email.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems + ' batches with '+ a.NumberOfErrors + ' failures. Please look at the attachment for more details');
		email.setSubject('PSRO LoA Level Migration Results - ' + a.Status);
		if(!Test.isRunningTest()) {
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
		}
	}
}