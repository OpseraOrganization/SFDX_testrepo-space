/**
 * @description: Loightning component on file
 *
 * ============================================================================
 * History:
 * -------
 * 
 * VERSION AUTHOR		  DATE		DETAIL										  
 * 1.0	 Accenture	   31/09/2018 August hypercare
 * ============================================================================ 
 */
public without sharing class FileFieldDocStrategy {
	 /**********************************************************************************************************************
	* author: Accenture
	* Date: 31/09/2018
	* Param: ContentDocument[] contentDocumentOld
	* Description:Method will retrive ContentVersion details from ContentDocumentId
	**********************************************************************************************************************/
	@AuraEnabled
	public static ContentVersion getFileData(String docId) {
		ContentVersion version = new ContentVersion();
		String recordTypeName = GlobalConstants.BLANK;
		String query = GlobalConstants.SELECTQUERY;
		for(Schema.FieldSetMember f : SObjectType.ContentVersion.FieldSets.Custom_compact_layout.getFields()) {
			query += f.getFieldPath() + GlobalConstants.COMMASPACE;
		}
		query += GlobalConstants.contentVersionQuery;

		return Database.query(query);
	}
	/**********************************************************************************************************************
	* author: Accenture
	* Date: 31/09/2018
	* Param: ContentDocument[] contentDocumentOld
	* Description:Method will retrive File_Report__c details from ContentDocumentId
	**********************************************************************************************************************/
	@AuraEnabled
	public static File_Report__c getFileReportData(String docId) {
		File_Report__c report = new File_Report__c();
		String query = GlobalConstants.SELECTQUERY;
		for(Schema.FieldSetMember f : SObjectType.File_Report__c.FieldSets.File_Report_custom_layout.getFields()) {
			query += f.getFieldPath() + GlobalConstants.COMMASPACE;
		}
		query += GlobalConstants.fileReportQuery;
		
		if(!Database.query(query).isEmpty()){
			report = Database.query(query);
			return report;
		}else{
			return null;
		}
	}
	
}