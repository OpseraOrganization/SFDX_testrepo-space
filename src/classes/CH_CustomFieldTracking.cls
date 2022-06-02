public class CH_CustomFieldTracking implements Queueable{
	
	private map<id, Case> fOldCases;
	private map<id, Case> fNewCases;
	
	public CH_CustomFieldTracking(map<id, Case> fOldCases, map<id, Case> fNewCases){
		this.fOldCases = fOldCases;
		this.fNewCases = fNewCases;
	}
	
	public void execute(QueueableContext context){
		handleCaseFieldChanges(fOldCases, fNewCases);
	}
	
	public static set<string> alreadyTrackedFields {
		  get {
			   if (alreadyTrackedFields == null) {
					alreadyTrackedFields = new set<string>();
			   }
			   return alreadyTrackedFields;
		  }
		  set;
	 }
	
	public static List<CH_AuditTrailFields__c> customAuditFields {
		  get {
			   if (customAuditFields == null) {
					customAuditFields = new List<CH_AuditTrailFields__c>([SELECT Name, Field_API_Name__c, Field_Tracking_Active__c FROM CH_AuditTrailFields__c]);
			   }
			   return customAuditFields;
		  }
		  set;
	 }
	
	// To ensure field tracking is performed only once per transaction
	//public static boolean fieldTrackingChecked = false;
	/*static final list<string> caseFields = new list<string>{'CH_Account_Name__c','AssetId','CH_AssignedDate__c',
						'ClosedDate','Comment__c','ContactId','CH_Workgroup__c',
															'CH_CustomerDescription__c','CH_Defect__c',
															'CH_EntitlementName__c','CH_InitialDiagnosis__c',
															'CH_InitialResponse__c','CH_InternalCase__c',
															'CH_InternalStatus__c','CH_IssueDescription__c',
															'CH_LawfullIntercept_CALEA__c','CH_Outage__c',
						'CH_OutageEndDate__c','CH_OutageStartDate__c',
						'Outage_Triggered_by__c','CH_OutageType__c',
						'CH_PrimaryCause__c','Priority','ProductId',
						'CH_Product_Release__c',
						'CH_ProductVariant__c','CH_ReasonForInternalStatus__c',
						'RecordTypeId','Reference_Number__c','CH_ReportedDate__c',
						'CH_SystemRestored__c','CH_SecondaryCause__c',
						'CH_ServiceDisruptionReportProvided__c','Severity__c',
															'CH_Solution__c','CH_SolutionDetails__c',
															'CH_SolutionProvided__c','Status','Subject',
															'CH_Summary__c','CH_SuspectedDataBreach__c',
															'CH_SW_Release__c','CH_TechnicalAnalysis__c',
															'CH_TemporarySolution__c','CH_TemporarySolutionNotApplicable__c',
															'CH_TemporarySolutionProvided__c','CH_TL9000OutageValidation__c',
						'RecordTypeId','OwnerID', 'CH_CaseCause__c', 'CH_TCAReady__c',
															'CH_DurationOpeToRouted__c', 'CH_AssessedOutage__c', 'CH_Product_Module__c',
															'CH_Product_Variant_Name__c'
	};*/
	
	public static void handleCaseFieldChanges(map<id, Case> oldCases, map<id, Case> newCases){
		//if(!fieldTrackingChecked){ 
		list<CH_Track_Field_Change__c> trackedFields = new list<CH_Track_Field_Change__c>();
		Map<String,Schema.SObjectField> cfields = Schema.getGlobalDescribe().get('Case').getDescribe().fields.getMap();
		//List<CH_AuditTrailFields__c> oCH_AuditTrailFields = [SELECT Name, Field_API_Name__c, Field_Tracking_Active__c FROM CH_AuditTrailFields__c];
		//System.debug('Test Class Test oCH_AuditTrailFields: '+oCH_AuditTrailFields);
			for(Case aCase : newCases.values()){
				for(CH_AuditTrailFields__c field : customAuditFields){
					String fieldName = field.Field_API_Name__c;
					// Check if the current field is a valid case field
					if(cfields.containsKey(fieldName)){
						object newVal = aCase.get(fieldName); 
						object oldVal = oldCases.get(aCase.Id).get(fieldName);
						System.debug(Logginglevel.ERROR,'#FieldKey:' + fieldName + str(newVal) + str(oldVal));
						if(!alreadyTrackedFields.contains(fieldName + str(newVal) + str(oldVal)) && newVal != oldVal && field.Field_Tracking_Active__c){
							alreadyTrackedFields.add(fieldName + str(newVal) + str(oldVal)); 
							Schema.DescribeFieldResult dfr = cfields.get(fieldName).getDescribe();
							
							//system.debug('>>>>>' + dfr.getSOAPType()+ ':' + dfr.getType());
							if(dfr.getSOAPType() == Schema.SOAPType.STRING || dfr.getSOAPType() == Schema.SOAPType.ID || dfr.getSOAPType() == Schema.SOAPType.Boolean || dfr.getSOAPType() == Schema.SOAPType.Double){
								if(dfr.getType() == Schema.DisplayType.TextArea){
									//alreadyTrackedFields.add(fieldName); 
									trackedFields.add(new CH_Track_Field_Change__c( name = dfr.getLabel(),
																				   Support_Ticket__c = aCase.Id,  
																				   CH_API_name_Field__c = fieldName,
																				   field_name__c = dfr.getLabel(),
																				   CH_New_value__c = (string)newVal,
																				   CH_Old_value__c = (string)oldVal)); 
								}else{
									//alreadyTrackedFields.add(fieldName);
									trackedFields.add(new CH_Track_Field_Change__c( name = dfr.getLabel(),
																				   Support_Ticket__c = aCase.Id,  
																				   CH_API_name_Field__c = fieldName,
																				   field_name__c = dfr.getLabel(),
																				   Text_new__c = String.valueOf(newVal),
																				   text_old__c = String.valueOf(oldVal)));
								}
								
							} // 
							else if(dfr.getSOAPType() == Schema.SOAPType.DATETIME){ 
								//alreadyTrackedFields.add(fieldName);
								trackedFields.add(new CH_Track_Field_Change__c( name = dfr.getLabel(),
																			   Support_Ticket__c = aCase.Id, 
																			   CH_API_name_Field__c = fieldName, 
																			   field_name__c = dfr.getLabel(),
																			   //CH_New_value__c = String.valueOf(newVal),
																			   //CH_Old_value__c = string.valueOf(oldVal), 
																			   Date_new__c = (Datetime)newVal,
																			   Date_old__c = (Datetime)oldVal)); 
							}
						}
						
					}
				}
			}
			system.debug('###CH_CustomFieldTracking:trackedFields:' + trackedFields);
			if(!trackedFields.isEmpty()) insert trackedFields;
			//fieldTrackingChecked = true;
		//}			
	}
	
	public static string str(Object obj){
		return obj == null ? '' : string.valueOf(obj);
	}
}