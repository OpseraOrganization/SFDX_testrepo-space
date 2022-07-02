/**
 * @description: Loightning component on file
 *
 * ============================================================================
 * History:
 * -------
 * 
 * VERSION AUTHOR		  DATE		DETAIL								  k		
 * 1.0	 Accenture	   01/11/2018 Feb Release
 * ============================================================================ 
 */
public class FileFieldHistoryTracking {
	 @AuraEnabled
	/**********************************************************************************************************************
	* author: Accenture
	* Date:  01/11/2018
	* Param: ContentDocument[] contentDocumentOld
	* Description:Method will retrive File_Report__c details from ContentDocumentId
	**********************************************************************************************************************/
	public static List<File_Report__c> getFileReportList(String docId) {
		List<File_Report__c> report = new List<File_Report__c>();
		String query = GlobalConstants.SELECTQUERY;
		for(Schema.FieldSetMember f : SObjectType.File_Report__c.FieldSets.File_Report_custom_layout.getFields()) {
			query += f.getFieldPath() + GlobalConstants.COMMASPACE;
		}
		query += GlobalConstants.fileReportQueryList;
		
		if(!Database.query(query).isEmpty()){
			report = Database.query(query);
			system.debug(report);
			return report;
		}else{
			return report;
		}
	}
	/**********************************************************************************************************************
	* author: Accenture
	* Date:  01/11/2018
	* Param: reportId[] reportId
	* Description:Method will retrive File_Report__History details from ContentDocumentId
	**********************************************************************************************************************/
	@AuraEnabled
   public static List<fileFieldHistoryWrapper> getFileReportHistory(List<String> reportId) {
	   List<fileFieldHistoryWrapper> wrapperList = new List<fileFieldHistoryWrapper> ();
	   fileFieldHistoryWrapper wrapper;
	   String type = GlobalConstants.FileReportObject;
	   Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
	   Schema.SObjectType fileReportSchema = schemaMap.get(type);
	   Map<String, Schema.SObjectField> fieldMap = fileReportSchema.getDescribe().fields.getMap();
	   
	   for(File_Report__History fileReportHistory : [SELECT Field,NewValue,OldValue,
							ParentId,Parent.File_Version__c,Parent.CreatedBy.Name,
							CreatedBy.Name,CreatedDate 
							FROM File_Report__History 
							WHERE ParentId IN: reportId 
							ORDER BY CreatedDate DESC])
	   {
		   wrapper = new fileFieldHistoryWrapper();
		   wrapper.version = fileReportHistory.Parent.File_Version__c;
		   wrapper.uploader = fileReportHistory.Parent.CreatedBy.Name;
		   if(fileReportHistory.Field == GlobalConstants.CREATED){
		 wrapper.field = GlobalConstants.FILE_VERSION;
		   }else{
			   wrapper.field = fieldMap.get(fileReportHistory.Field).getDescribe().getLabel();
		   }
		   wrapper.user = fileReportHistory.CreatedBy.Name;
		   wrapper.oldValue = fileReportHistory.OldValue;
		   wrapper.newValue = fileReportHistory.NewValue;
		   wrapper.dateValue = fileReportHistory.CreatedDate;
		   wrapperList.add(wrapper);
	   }
	   return wrapperList;   
   }
}