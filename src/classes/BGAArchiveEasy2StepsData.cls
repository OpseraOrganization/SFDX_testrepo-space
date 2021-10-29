public with sharing class BGAArchiveEasy2StepsData {

	public BGA_PO_Tracker__c processRecord{ get; private set;}
	
	public BGAArchiveEasy2StepsData(ApexPages.StandardController rec){
		processRecord = (BGA_PO_Tracker__c)(rec.getRecord());
		getFieldsList();
	}

	public BGAArchiveEasy2StepsData(BGA_PO_Tracker__c rec){
		processRecord = rec;
		getFieldsList();
	}

	public PageReference performAction(){
		Boolean isArchiveNeeded = false;
		List<sObject> listSobj = 
		Database.query(		'select ' +
							getListAsCSVString(fieldsList)
							+'Id,Name  from BGA_PO_Tracker__c where Id = \''+processRecord.Id+'\''
					);
		
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Steps are archived.'));
		
		Sobject archRec = new Easy2_Steps__c();
		Sobject cleanPoTrackerFields = new BGA_PO_Tracker__c();
		
		for(String colName: fieldsList){
			
			archRec.put(colName,listSobj[0].get(colName));
			cleanPoTrackerFields.put(colName,null);
			
			isArchiveNeeded = isArchiveNeeded | (listSobj[0].get(colName) == null ? false : true);
			
			if(listSobj[0].get(colName) != null){
				addDataSummary(fieldNameVsLabel.get(colName),String.valueOf(listSobj[0].get(colName)));
			}
		}
		
		String currentApmPartNumbr = String.valueOf(listSobj[0].get('Current_APM_Name__c'));
		
		if(isArchiveNeeded){
			
			archRec.put('PO_Tracker__c',listSobj[0].get('Id'));
			archRec.put('Step_Name__c',getStepName(currentApmPartNumbr));
			archRec.put('Archive_Details__c',dataSummaery);
			insert archRec;
			
			cleanPoTrackerFields.put('Id',listSobj[0].get('Id'));
			update cleanPoTrackerFields;
			
		}
		
		PageReference backToMainScreen = new PageReference('/'+processRecord.Id);
		return backToMainScreen;
		
	}
	
	
	public PageReference doCancel(){
		return new PageReference('/'+processRecord.Id);
	}
	
	String getListAsCSVString(List<String> listVal){
		
		if(listVal==null){
			return '';
		}
		
		String csvCols='';
					for(String fieldName : listVal){
						csvCols	=	csvCols	+	fieldName +', ';
				}
				
		return csvCols;	
	}
		
	List<String> fieldsList = null;
	Map<String,String> fieldNameVsLabel = null;
	void getFieldsList(){
		
		if(fieldsList == null){fieldsList = new List<String>(); fieldNameVsLabel = new Map<String,String>();}
		else{return;}
		
		Schema.FieldSet fs1 = Schema.SObjectType.BGA_PO_Tracker__c.fieldSets.getMap().get('Easy2TrackingFields');
		
		for(FieldSetMember fsm: fs1.getFields()){
			fieldsList.add(fsm.getFieldPath());
			fieldNameVsLabel.put(fsm.getFieldPath(),fsm.getLabel());
		}
		
	}

	String getStepName(String currentAPMPartNumber){
			try{
			if(currentAPMPartNumber != null){
				Map<String,String> mapStepName = 
				(Map<String,String>)Json.deserialize(Label.PoTrackerEasy2StepMap, Map<String,String>.class);
			
			     for(String ky : mapStepName.keySet()){
			     	if(currentAPMPartNumber.contains(ky))
			     	return mapStepName.get(ky);
			     }
			}	
			
			List<AggregateResult> result = 
						[select count(Id) from Easy2_Steps__c where PO_Tracker__c = :processRecord.Id];
			
			return 	'Step ' + (Integer.valueOf(result[0].get('expr0'))+1);
			}catch(Exception e){
				return 'N/A';
			}
	}
	
	String dataSummaery = null;
	void addDataSummary(String fieldLabel,String fieldData){
		if(dataSummaery == null){
			dataSummaery = '';
		}
		dataSummaery = dataSummaery +  fieldLabel + '   =>   ' + fieldData + '\n';
	}
	
	@isTest(seeAllData = true)
	public static void codeCoverageMethod(){
		List<BGA_PO_Tracker__c> bptList = [	select Id,Current_APM_Name__c from BGA_PO_Tracker__c
											where Current_APM_Name__c != null  and PO_GPS_Upgrade__c!= null 
											and Charts_Platform_Family__c like 'Falcon%' LIMIT 20
										];
		
		for(BGA_PO_Tracker__c bpt:bptList){
			BGAArchiveEasy2StepsData baae2sd_prod = new BGAArchiveEasy2StepsData(bpt);
			baae2sd_prod.performAction();
		}
	}
	
	
}