/*************************
Class Name: CH_CreateOutS2SInteractionController
Created by: Srinivas Bolneni
Last modified by: 
Description: This class contains methods to resend the failure Interface S2S Outbound Log records
UserStory:15221
***************************/

public with sharing class CH_CreateOutS2SInteractionController {
 @AuraEnabled
 public static string sendS2SInteraction(Id outboundS2SInteractionId) {
		Interface_Log__c outboundS2SInteraction = [SELECT Id,Name,Comment__c,Digital_Proposal__c,DS_Payload__c, iLog_Timestamp__c, Interface_Request_Sent__c,Interface_Type__c,Message_Type__c,Month_Day_Year__c,Number_of_Record_Processed__c,Number_of_Records_Errored__c,Number_of_Records_Success__c,Operation_Type__c,Resend__c,Status__c,User_Market__c FROM Interface_Log__c WHERE Id =: outboundS2SInteractionId];
		if(outboundS2SInteraction.Interface_Type__c == 'Customer S2S' && outboundS2SInteraction.Message_Type__c == 'Outbound' && outboundS2SInteraction.Status__c != 'Success') {
		 CH_ExternalInterfaceUTIL.resendOutboundS2SInteraction(outboundS2SInteraction);
		}
		return null;
	}
}