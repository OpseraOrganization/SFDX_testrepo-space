public with sharing class CH_FilterRota 
{  
	private static final integer MAXROWS = 50;
		
	@AuraEnabled	
	public static List <CH_Workgroup_Event__c> getMyWorkgroupRota(){
		// Get the current user
		Id currentUserId = UserInfo.getUserId();
		DateTime now = DateTime.Now();
		// Get all ROTAs for the user
		string query = 'select Id, Name, CH_Workgroup__r.Name, CH_WorkgroupMember__r.CH_Name__c, CH_SupportType__c, CH_StartDate__c, CH_EndDate__c, CH_EndOccurence__c from ch_workgroup_event__c WHERE';
		query += ' CH_WorkgroupMember__r.CH_User__c = :currentUserId AND CH_EndDate__c >= :now ';
		query += ' ORDER BY CH_StartDate__c, CH_Workgroup__r.Name, CH_WorkgroupMember__r.CH_Name__c ASC NULLS LAST';
		query += ' LIMIT ' + MAXROWS;
		List<CH_Workgroup_Event__c> lstOfRecords = Database.query(query);															
		return lstOfRecords; 
	}

	// Get the current user
	@AuraEnabled
	public static CH_Custom_Lookup_Result getUserName() {
		CH_Custom_Lookup_Result user = new CH_Custom_Lookup_Result();
		user.recordId = UserInfo.getUserId();
		user.recordValue = userinfo.getName();
		return user;
	}	
	
	//Description - This method is used to to return workgroup rota.
	@AuraEnabled	
	public static List<CH_Workgroup_Event__c> getWorkgroupRota(Id workgroupId, Id workgroupMemberId, 
																String startDateString, String endDateString){
		string query = 'select Id, Name, CH_Workgroup__r.Name, CH_WorkgroupMember__r.CH_Name__c, CH_SupportType__c, CH_StartDate__c, CH_EndDate__c, CH_EndOccurence__c from ch_workgroup_event__c WHERE';
		if (workgroupId != null){
			system.debug('xx ' + workgroupId);
			query += ' CH_Workgroup__c=:workgroupId AND';
		}
		if (workgroupMemberId != null){
			system.debug('xx ' + workgroupMemberId);
			query += ' CH_WorkgroupMember__c=:workgroupMemberId AND';
		}
		if (String.isNotBlank(startDateString)){
			DateTime startDate = Date.valueOf(startDateString);
			query += ' CH_StartDate__c>=:startDate AND';
		}
		if (String.isNotBlank(endDateString)){
			DateTime endDate = Date.valueOf(endDateString);
			query += ' CH_EndDate__c<=:endDate AND';
		}
		integer len1 = query.length();
		if(query.endsWithIgnoreCase('AND')){
			query = query.substring(0, len1 - 3);
		} 
		if(query.endsWithIgnoreCase('WHERE')){
			query = query.substring(0, len1 - 5);
		}
		query += ' ORDER BY CH_StartDate__c, CH_Workgroup__r.Name, CH_WorkgroupMember__r.CH_Name__c, CH_StartDate__c ASC NULLS LAST';
		query += ' LIMIT ' + MAXROWS;
		System.debug('SOQL: ' + query);															
		List<CH_Workgroup_Event__c> lstOfRecords = Database.query(query);															
		return lstOfRecords;													  
	}
}