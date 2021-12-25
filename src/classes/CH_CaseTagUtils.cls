public with sharing class CH_CaseTagUtils {
	private final static String recordTypeId =  Schema.SObjectType.CH_CaseTag__c.getRecordTypeInfosByDeveloperName().get('CH_CaseTag').getRecordTypeId();
	
	public static List<String> getTagDetails(String field, String productId, String issueType, String issueDetails) {
		Set<String> result = new Set<String>();
		String sQuery = 'SELECT Id, CH_IssueType__c, CH_IssueDetails__c, CH_AdditionalDetails__c FROM CH_CaseTag__c ';
		sQuery += 'WHERE RecordTypeId = "' + recordTypeId + '" AND CH_Product__c= "' + productId + '" AND CH_Status__c = "Active" ';
		if(field == 'CH_IssueDetails__c' || field == 'CH_AdditionalDetails__c')
			sQuery += 'AND CH_IssueType__c = "' + issueType + '" ';
		if(field == 'CH_AdditionalDetails__c')
			sQuery += 'AND CH_IssueDetails__c = "' + issueDetails + '" ';
		//
		for(CH_CaseTag__c oCaseTag : (List<CH_CaseTag__c>) DML_SObject.doQuery(sQuery)){
			result.add((String) oCaseTag.get(field));
		}
		return new List<String>(result);
	}
	
	public static CH_CaseTag__c getTag (String productId, String issueType, String issueDetails, String additionalDetails){
		
		String sQuery = 'SELECT Id, Name, RecordTypeId, CH_IssueType__c, CH_IssueDetails__c, CH_AdditionalDetails__c, CH_Status__c, CH_LegacyTagName__c, CH_TagID__c, CH_Product__c, '
			+'CH_ProductBusinessGroup__c, CH_ProductCode__c, CH_TagName__c FROM CH_CaseTag__c where CH_Product__c=\'' + productId + '\' and CH_Status__c=\'Active\' and RecordTypeId=\'' 
			+ recordTypeId + '\' and CH_IssueType__c=\''+ issueType +'\' and CH_IssueDetails__c=\''+ issueDetails +'\' and CH_AdditionalDetails__c=\''+ additionalDetails +'\''; 

		List<CH_CaseTag__c> oCaseTagList = DML_SObject.doQuery(sQuery);
		return !oCaseTagList.isEmpty()? oCaseTagList[0]: null;

	}

}