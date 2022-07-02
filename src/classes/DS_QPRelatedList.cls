public class DS_QPRelatedList {
	/*****************************
	 *Method Name: getLineItem
	 *Description: This method will retrieve the Proposal line Items  
	 *Parameters: Digital Proposal ID
	*******************************/	
	 @AuraEnabled
		public static List<Apttus_Proposal__Proposal_Line_Item__c> getLineItem(Id currentRecordId)
		{ 
			List<Apttus_Proposal__Proposal_Line_Item__c> lineItemlist= new  List<Apttus_Proposal__Proposal_Line_Item__c>();
			lineItemlist = [Select Id,Name,DS_Grouping_Name__c,Apttus_QPConfig__LineNumber__c,Apttus_QPConfig__LineType__c from Apttus_Proposal__Proposal_Line_Item__c where Apttus_Proposal__Proposal__c =:currentRecordId];
			return lineItemlist;
			
		}
}