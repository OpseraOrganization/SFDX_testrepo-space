/******************************************************************************************************
Name : CLM_GlobalConstants
Created Date: 24th Apr 2021
Created by: Forsys Inc
Description : This class will serve all constant values for CLM. So no hardcoding will be required in any of classes
*********************************************************************************************************/
public class CLM_GlobalConstants {
	
	public static string CMRole = 'Commercial Contract Manager (L&C)';
	public static string AMRole = 'Account Manager (TRICORN Sales Case Owner (SCO))';
	public static string CMProfileName = 'Non-Sales User Profile';
	public static string agrmntAPIName = 'Apttus__APTS_Agreement__c';
	public static string optyAPIName = 'Opportunity';
	public static string Access_Read = 'Read';
	public static string Access_ReadWrite = 'Read/Write';
	public static string Manual = 'Manual';
	public static string CLM_AM_Permission = 'CLM_Account_Manager_Permission';
	public static string CLM_CM_Permission = 'CLM_Contract_Manager_Permission';
	public static string Equal_To = 'equal to';
	public static string Not_EqualTo = 'not equal to';
	public static string groupAPIName = 'Group';
	public static string User_Val = 'User';
	public static string queu_Val = 'Queue';
	
	public static string frameRequestAct = 'ActivateFrameRequest';
	public static string requestAct = 'ActivateRequest';
	public static string fullSignedSts = 'Fully Signed';
	
	public static string agrmntClauseAPIName = 'Apttus__Agreement_Clause__c';
	public static string templateAPIName = 'Apttus__APTS_Template__c';
	public static List<string> agreementRecordTypeNames = new List<string>{'Care Agreement','Non-Transactional Agreement','Supply and Services Agreement','Contract Request','Legacy','NDA'};
	public static List<string> optyRecordTypeNames = new List<string>{'Create Indirect Sales Opportunity','Create Direct Sales Opportunity'};
	public static String NextLine =  '<br>' ;
	public static string optyIndirectRecordtypeName = 'Create Indirect Sales Opportunity';
	public static string optyDirectRecordTypeName = 'Create Direct Sales Opportunity';
	public static String subjectforContractfailed =  'Contract Request creation failed for the opportunity ' ;
	public static String pLevel = 'Full access';
	public static String docFormat = 'pdf';
	public static Boolean isDraft = false;
	public static String sessionId = UserInfo.getSessionId(); 
	public static String serverUrl = System.Url.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/u/14.0/' + UserInfo.getOrganizationId();
	public static List<string> activationRecordTypes = new List<string>{'Care Agreement','Non-Transactional Agreement','Supply and Services Agreement'};
	 
	
}