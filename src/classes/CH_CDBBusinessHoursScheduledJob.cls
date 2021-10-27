public class CH_CDBBusinessHoursScheduledJob implements Schedulable {
	
	public void execute(SchedulableContext context) {
		CH_Business_Hours_Integration__c integrationSettings = CH_Business_Hours_Integration__c.getOrgDefaults();
		if (checkBusinessHoursChanges(integrationSettings)) {
			sendBusinessHoursToCDB();
		}
	}
	
	private Boolean checkBusinessHoursChanges(CH_Business_Hours_Integration__c integrationSettings) {
		if (integrationSettings == NULL || integrationSettings.CH_Last_Success_Sync_DateTime__c == NULL) {
			return true;
		}

		DateTime lastSyncDateTime = integrationSettings.CH_Last_Success_Sync_DateTime__c;
		Integer modifiedBusinessHourCount = Database.countQuery('SELECT COUNT() FROM BusinessHours WHERE LastModifiedDate > :lastSyncDateTime');
		return modifiedBusinessHourCount > 0;
	}

	@future(callout = true)
	private static void sendBusinessHoursToCDB() {
		CH_Business_Hours_Integration__c integrationSettings = CH_Business_Hours_Integration__c.getOrgDefaults();
		if (integrationSettings == NULL) {
			integrationSettings = new CH_Business_Hours_Integration__c(SetupOwnerId = UserInfo.getOrganizationId());
		}
		integrationSettings.CH_Start_Sync_DateTime__c = Datetime.now();

		HttpRequest httpRequest = new HttpRequest();
		httpRequest.setHeader('Accept', 'application/json');
		httpRequest.setHeader('Content-Type', 'application/json');
		httpRequest.setMethod('POST');
		httpRequest.setEndpoint('callout:CDB');
		List<BusinessHours> businessHours = [SELECT Id, Name, IsActive, IsDefault, LastViewedDate, FridayEndTime, FridayStartTime, MondayEndTime, MondayStartTime, SaturdayEndTime, SaturdayStartTime, SundayEndTime, SundayStartTime, ThursdayEndTime, ThursdayStartTime, TimeZoneSidKey,TuesdayEndTime,  TuesdayStartTime, WednesdayEndTime, WednesdayStartTime FROM BusinessHours where IsActive = true];
		httpRequest.setBody(JSON.serialize(businessHours));
		
		Http http = new Http();
		HttpResponse response = http.send(httpRequest);
		//TODO: validate response

		upsert integrationSettings;
	}
}