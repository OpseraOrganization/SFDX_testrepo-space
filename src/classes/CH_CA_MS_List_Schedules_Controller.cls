public Without Sharing class CH_CA_MS_List_Schedules_Controller {
	
	// Get the schedules for a workgroup
	@AuraEnabled
	public static List<CH_Workgroup_Schedule__c> getSchedules(Id workgroupId){
		List<CH_Workgroup_Schedule__c> workgroupSchedules;
		workgroupSchedules = [SELECT Id, CH_Active__c, Name, CH_Start_DateTime__c, CH_End_DateTime__c,CH_Start_Date__c,CH_Start_Time__c,
							  CH_End_Date__c,CH_End_Time__c,CH_Time_Zone__c,
		 (SELECT CH_Region__c, CH_Country__c, CH_Outage__c, CH_Severity__c, CH_Workgroup_Type__c,CH_LevelOfSupport__c	
		FROM CH_Workgroup_Filters__r)
		 FROM CH_Workgroup_Schedule__c 
		 WHERE CH_Workgroup__c =:workgroupId
		 ORDER BY CH_Start_DateTime__c, Name];

		return workgroupSchedules;
	}

	// Get the locale of the logged i user
	// getLocale() returns en_US this is converted to international standard of en-US
	@AuraEnabled
	public static string getLocale(){
		String userLocale = UserInfo.getLocale();
		return userLocale.replace('_','-');
	}
	
	// Delete the selected rows and return the status of the deletion
	@AuraEnabled
	public static string deleteSelectedSchedules(List<id> selectedScheduleIds){
		//Delete the schedules
		List<CH_Workgroup_Schedule__c> selectedSchedules;
		selectedSchedules = [SELECT Id FROM CH_Workgroup_Schedule__c WHERE Id in :selectedScheduleIds];
		
		return CH_CA_MS_Util.deleteSelectedObjects(selectedSchedules, 'schedule');
	}
	
	// Check the Logged in User has Access for Workgroup Schedules
	@AuraEnabled
	public static boolean accessCheckForManageSchedules(string accessId){
		Boolean isAccessEnabled = false;
		UserRecordAccess[] userAccess=[SELECT RecordId, HasEditAccess FROM UserRecordAccess WHERE UserId =:UserInfo.getUserId()  AND RecordId =:accessId  LIMIT 1];
		if(userAccess.size()>0){
			isAccessEnabled=userAccess[0].HasEditAccess;
		}
		return isAccessEnabled;
		
	}
	
	 //Clone the Selected Schedule
	@AuraEnabled
	public static Id cloneSelectedSchedules(List<Id> selectedScheduleIds,string scheduleName,string workgpFilterName){
		//Clone the schedules
		List<CH_Workgroup_Schedule__c> selectedSchedules=new List<CH_Workgroup_Schedule__c>();
		for(CH_Workgroup_Schedule__c cloneSched : [SELECT Id,Name, CH_Workgroup__c,CH_Workgroup_Filters_Count__c,CH_Active__c,CH_Description__c,CH_End_DateTime__c,
				CH_Start_Date__c,CH_Start_Time__c,
												   CH_End_Date__c,CH_End_Time__c,CH_StartDateTime__c,CH_EndDateTime__c,
												   CH_Start_DateTime__c,CH_Time_Zone__c  
												   FROM CH_Workgroup_Schedule__c WHERE Id in :selectedScheduleIds])
		{
			CH_Workgroup_Schedule__c cloneScheduleRecord = cloneSched.clone();
			cloneScheduleRecord.Name = scheduleName;
			cloneScheduleRecord.CH_Active__c = false;
			selectedSchedules.add(cloneScheduleRecord);
		}
		if(selectedSchedules.Size()>0){
			insert selectedSchedules;
		}
		cloneWorkgroupFilter(selectedScheduleIds,selectedSchedules,workgpFilterName);
		cloneTimeslotRecords(selectedScheduleIds,selectedSchedules);
		return selectedSchedules[0].Id;
	}
	
	//Clone the Workgroup Filter and its related objects  
	Public static void cloneWorkgroupFilter(List<Id> oldScheduleIds,List<CH_Workgroup_Schedule__c> newScheduleIds,string wrkgroupFilterName){
		List<CH_Workgroup_Filter__c> getWGF=new List<CH_Workgroup_Filter__c>();
		List<CH_Workgroup_Filter__c> lstfilter=[SELECT Id,Name,CH_Country__c,CH_LevelOfSupport__c, CH_Outage__c,CH_ProductModule__c,CH_ProductVariant__c
												,CH_Region__c, CH_Severity__c,CH_Solution__c,CH_Workgroup_Type__c,
												(SELECT Id, CH_Workgroup_Filter__c,CH_Account__c 
												 ,CH_Account__r.Name FROM Workgroup_Filter_Customer_Associations__r ), 
												(SELECT Id, CH_Workgroup_Filter__c ,CH_Product__c,CH_Product__r.Name FROM Workgroup_Filter_Product_Associations__r ) 
												FROM CH_Workgroup_Filter__c  WHERE CH_Workgroup_Schedule__r.Id in :oldScheduleIds];
		for(CH_Workgroup_Filter__c getFilter:lstfilter)
		{
			CH_Workgroup_Filter__c clonWGFilter = getFilter.clone();
			clonWGFilter.CH_Workgroup_Schedule__c=newScheduleIds[0].Id;
			clonWGFilter.Name=wrkgroupFilterName;
			getWGF.add(clonWGFilter);
		}
		if(getWGF.Size()>0){
			insert getWGF;
		}
		List<CH_Workgroup_Filter_Product_Association__c> lstWGP=new List<CH_Workgroup_Filter_Product_Association__c>();
		List<CH_Workgroup_Filter_Customer_Association__c> lstWGC=new List<CH_Workgroup_Filter_Customer_Association__c>();
		for(CH_Workgroup_Filter__c getlter:lstfilter){
			if(getlter.Workgroup_Filter_Product_Associations__r.size() != 0){
				for (CH_Workgroup_Filter_Product_Association__c productFilter: getlter.Workgroup_Filter_Product_Associations__r){
					CH_Workgroup_Filter_Product_Association__c getPli=productFilter.clone();
					getPli.CH_Workgroup_Filter__c= getWGF[0].Id;
					lstWGP.add(getPli);
					
				}
			}
			if(getlter.Workgroup_Filter_Customer_Associations__r.size() != 0){
				for (CH_Workgroup_Filter_Customer_Association__c customerFilter: getlter.Workgroup_Filter_Customer_Associations__r){
					CH_Workgroup_Filter_Customer_Association__c getCli=customerFilter.clone();
					getCli.CH_Workgroup_Filter__c= getWGF[0].Id;
					lstWGC.add(getCli);
				}
			}
		}
		if(lstWGP.Size()>0){
			try {
				insert lstWGP;
			}
			catch (Exception e) {
				throw new AuraHandledException(e.getMessage());
			}
		}
		if(lstWGC.Size()>0){
			try{
				insert lstWGC;
			}
			catch (Exception e) {
				throw new AuraHandledException(e.getMessage());
			}
		}
		
	}
	
	//Clone the Timeslot and workgroup member time Slot association 
	Public static void cloneTimeslotRecords(List<Id> oldScheduleIds,List<CH_Workgroup_Schedule__c> newScheduleIds){
		Map<Id, Id> getTmeSlot =new Map<Id,Id>();
		Set<Id> getIds=new Set<Id>();
		List<CH_Workgroup_Member_Timeslot_Association__c> getlstWMTA =new List<CH_Workgroup_Member_Timeslot_Association__c>();
		List<CH_Workgroup_Schedule_Timeslot__c> getTimeslot=new List<CH_Workgroup_Schedule_Timeslot__c>();
		List<CH_Workgroup_Schedule_Timeslot__c> lstWST=[SELECT Id ,CH_Day__c,CH_Start_Time__c,CH_End_Time__c ,CH_Old_Timeslot_ID__c,
														(Select id,CH_Workgroup_Member__r.ID,CH_Schedule_Type__c,CH_Workgroup_Member__c,
														 CH_Workgroup_Schedule_Timeslot__c,CH_Workgroup_Schedule_Timeslot__r.Id 
														 from Workgroup_Member_Timeslot_Association__r)
														FROM CH_Workgroup_Schedule_Timeslot__c 
														WHERE CH_Workgroup_Schedule__r.Id  in :oldScheduleIds ORDER BY NAME ASC];
		for(CH_Workgroup_Schedule_Timeslot__c getTmeSlt:lstWST){
			getIds.add(getTmeSlt.Id);
			CH_Workgroup_Schedule_Timeslot__c clonedRecord = getTmeSlt.clone();
			clonedRecord.CH_Workgroup_Schedule__c=newScheduleIds[0].Id;
			clonedRecord.CH_Old_Timeslot_ID__c=getTmeSlt.Id;
			getTimeslot.add(clonedRecord);
		}
		if(getTimeslot.Size()>0){
			insert getTimeslot;
			
		}
		if(getTimeslot.Size()>0){
			for(CH_Workgroup_Schedule_Timeslot__c gtId:getTimeslot){
				getTmeSlot.put(gtId.CH_Old_Timeslot_Id__c,gtId.Id);
			}
			for(CH_Workgroup_Member_Timeslot_Association__c getMTA:[SELECT CH_Workgroup_Member__r.Name,CH_Workgroup_Schedule_Timeslot__r.Name,
																	CH_Workgroup_Schedule_Timeslot__c,CH_Workgroup_Schedule_Timeslot__r.ID,CH_Workgroup_Member__c
																	,CH_Schedule_Type__c  
																	FROM CH_Workgroup_Member_Timeslot_Association__c where CH_Workgroup_Schedule_Timeslot__r.ID in :getIds ORDER BY NAME ASC]){
																		if(getTmeSlot.containsKey(getMTA.CH_Workgroup_Schedule_Timeslot__r.ID)){
																			CH_Workgroup_Member_Timeslot_Association__c clonedWMTA = getMTA.clone();
																			clonedWMTA.CH_Workgroup_Schedule_Timeslot__c=getTmeSlot.get(getMTA.CH_Workgroup_Schedule_Timeslot__r.ID);
																			clonedWMTA.CH_Workgroup_Member__c=getMTA.CH_Workgroup_Member__c;
																			getlstWMTA.add(clonedWMTA);
																		}
																	}
		}
		
		if(getlstWMTA.size()>0){
			system.debug('getlstWMTA is '+getlstWMTA.size());
			insert getlstWMTA;
			
		}
	}
	
	  //Get the Timeslot Records for the Selected Schedules
	@AuraEnabled
	public static List<CH_Workgroup_Schedule_Timeslot__c> fetchTimeSlot(List<Id> selScheduleIds){
		List <CH_Workgroup_Schedule_Timeslot__c> returnMemberList = new List <CH_Workgroup_Schedule_Timeslot__c> ();
		for(CH_Workgroup_Schedule_Timeslot__c con: [Select CH_Workgroup_Schedule__r.CH_Workgroup__r.Name,CH_Workgroup_Schedule__r.Name,
				CH_Workgroup_Schedule__r.CH_Start_Date__c,CH_Workgroup_Schedule__r.CH_Start_Time__c,
													CH_Workgroup_Schedule__r.CH_End_Date__c,CH_Workgroup_Schedule__r.CH_End_Time__c,
													CH_Workgroup_Schedule__r.CH_Time_Zone__c,
													CH_Workgroup_Schedule__r.Id,Name,ID,
													CH_Day__c,CH_Start_Time__c, 
													CH_End_Time__c FROM CH_Workgroup_Schedule_Timeslot__c 
													Where CH_Workgroup_Schedule__r.Id IN : selScheduleIds ORDER BY
													CH_Workgroup_Schedule__r.Name ASC,NAME ASC ]) {
														returnMemberList.add(con);
													}
		return returnMemberList;
	}
	
	//Get the Timeslot Members Records for the Selected Schedules
	@AuraEnabled
	public static list <CH_Workgroup_Member_Timeslot_Association__c> fetchTimeSlotMembers(List<Id> selScheduleIds){
		List <CH_Workgroup_Member_Timeslot_Association__c> returnMemberList = new List <CH_Workgroup_Member_Timeslot_Association__c> ();
		for(CH_Workgroup_Member_Timeslot_Association__c con: [Select CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Workgroup__r.Name,
				 CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Start_Date__c,
															  CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Start_Time__c,
															  CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_End_Date__c,
															  CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_End_Time__c,
															  CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.CH_Time_Zone__c,
															  CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.Name,
															  CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.Id,CH_Workgroup_Schedule_Timeslot__r.Name,
															  CH_Workgroup_Schedule_Timeslot__r.CH_Day__c, CH_Workgroup_Schedule_Timeslot__r.CH_Start_Time__c, 
															  CH_Workgroup_Schedule_Timeslot__r.CH_End_Time__c, CH_Workgroup_Member__r.Name,CH_Workgroup_Member__r.ID
															  ,CH_Schedule_Type__c,Id,
															  CH_Workgroup_Schedule_Timeslot__r.Id from CH_Workgroup_Member_Timeslot_Association__c 
															  Where CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.Id IN : selScheduleIds ORDER BY
															  CH_Workgroup_Schedule_Timeslot__r.CH_Workgroup_Schedule__r.Name ASC,CH_Workgroup_Schedule_Timeslot__r.Name ASC ]) {
																  returnMemberList.add(con);
															  }
		return returnMemberList;
	}
	
	//Process the Timeslot Records for the Selected Schedules
	@AuraEnabled
	Public static List<CH_EmailAlert__c> processtimeSlotData(String fileData) {
		List<CH_EmailAlert__c> returnErrors=new List<CH_EmailAlert__c>();
		Map<Id,String> getUpdateDeleteErrs=new Map<Id,String>();
		List<CH_Workgroup_Schedule_Timeslot__c> getUpdateLst=new List<CH_Workgroup_Schedule_Timeslot__c>();
		List<CH_Workgroup_Schedule_Timeslot__c> getdeleteLst=new List<CH_Workgroup_Schedule_Timeslot__c>();
		List<WorkgroupMemberAssociation> workgroupSchduleTimeslot = (List<WorkgroupMemberAssociation>) JSON.deserialize(fileData, List<WorkgroupMemberAssociation>.class);		   
		for(WorkgroupMemberAssociation details : workgroupSchduleTimeslot){
			switch on details.operationType.toLowerCase().trim() {
				when 'delete' {
					CH_Workgroup_Schedule_Timeslot__c delWST=new CH_Workgroup_Schedule_Timeslot__c();
					delWST.Id=details.getTimeslotId;
					getdeleteLst.add(delWST);
				}
				when 'update' {
					CH_Workgroup_Schedule_Timeslot__c gtUpdate=new CH_Workgroup_Schedule_Timeslot__c();
					gtUpdate.Id=details.getTimeslotId;
					gtUpdate.CH_Day__c=details.day.replaceAll(':', ';');
					gtUpdate.CH_Start_Time__c=updateTime(details.startTime);
					gtUpdate.CH_End_Time__c=updateTime(details.endTime);
					getUpdateLst.add(gtUpdate);
					
				}
				when else{ //Do Nothing
	}					
			}
			
		}
		 if(getUpdateLst != null && !getUpdateLst.isEmpty()) {
			Database.SaveResult[] getScheduleTimeslot = Database.update(getUpdateLst,false);   
			Integer i=0;
			for(Database.SaveResult results : getScheduleTimeslot){
				if(!results.isSuccess()){
					for(Database.Error err : results.getErrors()) {
						getUpdateDeleteErrs.put(getUpdateLst.get(i).Id, err.getMessage());
					}
				}
				i++; 
			}
		}
		if(getdeleteLst != null && !getdeleteLst.isEmpty()) {
			Database.DeleteResult[] getSTimeslot = Database.Delete(getdeleteLst,false);   
			Integer i=0;
			for(Database.DeleteResult results : getSTimeslot){
				if(!results.isSuccess()){
					for(Database.Error err : results.getErrors()) {
						getUpdateDeleteErrs.put(getdeleteLst.get(i).Id, err.getMessage());
					}
				}
				i++; 
			}
		}
		if(getUpdateDeleteErrs.size()>0){
			for(WorkgroupMemberAssociation details : workgroupSchduleTimeslot){
				if(getUpdateDeleteErrs.containskey(details.getTimeslotId) && !String.IsBlank(getUpdateDeleteErrs.get(details.getTimeslotId))){

						CH_EmailAlert__c getTimeSltErr=new CH_EmailAlert__c();
						getTimeSltErr.CH_Bind1__c=details.workgroupName;
						getTimeSltErr.CH_Bind2__c=details.scheduleName;
						getTimeSltErr.CH_Bind3__c=details.scheduleStartDate;
						getTimeSltErr.CH_Bind4__c=details.scheduleStartTime;
						getTimeSltErr.CH_Bind5__c=details.scheduleEndDate;
						getTimeSltErr.CH_Bind6__c=details.scheduleEndTime;
						getTimeSltErr.CH_Bind7__c=details.scheduleTimeZone;  
						getTimeSltErr.CH_Bind8__c=details.timeslotName;	 
						getTimeSltErr.CH_Bind9__c=details.getTimeslotId;  
						getTimeSltErr.CH_Bind10__c=details.day.replaceAll(';', ':');
						getTimeSltErr.CH_Bind11__c=details.startTime;
						getTimeSltErr.CH_Bind12__c=details.endTime;
						getTimeSltErr.CH_Bind13__c=getUpdateDeleteErrs.get(details.getTimeslotId);
						returnErrors.add(getTimeSltErr);
					}
				}
			}
		return returnErrors;
	}
	//Process the Timeslot Members Records for the Selected Schedules
	@AuraEnabled
	Public static List<CH_EmailAlert__c> processtimeSlotMembersData(String fileData) {
		List<Id> getEmailIds=new List<Id>();
		List<CH_EmailAlert__c> getEmaillst=new List<CH_EmailAlert__c>();
		List<CH_EmailAlert__c> returnErros=new List<CH_EmailAlert__c>();
		Map<Id,String> getUpdateDeleteErrs=new Map<Id,String>();
		List<CH_Workgroup_Member_Timeslot_Association__c> getUpdate=new List<CH_Workgroup_Member_Timeslot_Association__c>();
		List<CH_Workgroup_Member_Timeslot_Association__c> lstInsert=new List<CH_Workgroup_Member_Timeslot_Association__c>();
		List<CH_Workgroup_Member_Timeslot_Association__c> getdeleteLst=new List<CH_Workgroup_Member_Timeslot_Association__c>();
		List<CH_EmailAlert__c> getEmails=new List<CH_EmailAlert__c>();
		List<WorkgroupMemberAssociation> workgroupSchduleTimeslot = (List<WorkgroupMemberAssociation>) JSON.deserialize(fileData, List<WorkgroupMemberAssociation>.class);		   
		for(WorkgroupMemberAssociation details : workgroupSchduleTimeslot){
			switch on details.operationType.toLowerCase().trim() {
				when 'delete' {
					CH_Workgroup_Member_Timeslot_Association__c delWSTMA=new CH_Workgroup_Member_Timeslot_Association__c();
					delWSTMA.ID=details.getTimeslotMemberId;
					getdeleteLst.add(delWSTMA);
				}
				when 'update' {
					CH_Workgroup_Member_Timeslot_Association__c updtWSTMA=new CH_Workgroup_Member_Timeslot_Association__c();
					updtWSTMA.CH_Schedule_Type__c=details.scheduleType;
					updtWSTMA.Id=details.getTimeslotMemberId;
					getUpdate.add(updtWSTMA);
					
				}
				when 'insert' {
					CH_EmailAlert__c gtInst=new CH_EmailAlert__c();
					gtInst.CH_Bind1__c=details.workgroupName;
					gtInst.CH_Bind2__c=details.scheduleName;
					gtInst.CH_Bind3__c=details.scheduleStartDate;
					gtInst.CH_Bind4__c=details.scheduleStartTime;
					gtInst.CH_Bind5__c=details.scheduleEndDate;
					gtInst.CH_Bind6__c=details.scheduleEndTime;
					gtInst.CH_Bind7__c=details.scheduleTimeZone;
					gtInst.CH_Bind8__c=details.timeslotName;
					gtInst.CH_Bind9__c=details.getTimeslotId;
					gtInst.CH_Bind10__c=details.day;
					gtInst.CH_Bind11__c=details.startTime;
					gtInst.CH_Bind12__c=details.endTime;
					gtInst.CH_Bind13__c=details.getTimeslotMemberId;
					gtInst.CH_Bind_16__c=details.workgroupMemberName;
					gtInst.CH_Bind_17__c=details.getmemberId;
					gtInst.CH_Bind19__c=details.scheduleType;
					getEmails.add(gtInst);
				}
				when else{ //Do Nothing
		}					
			}
			
		}
		 if(getUpdate != null && !getUpdate.isEmpty()) {
			Database.SaveResult[] getScheduleTimeslot = Database.Update(getUpdate,false);   
			Integer i=0;
			for(Database.SaveResult results : getScheduleTimeslot){
				if(!results.isSuccess()){
					for(Database.Error err : results.getErrors()) {
						getUpdateDeleteErrs.put(getUpdate.get(i).Id, err.getMessage());
					}
				}
				i++; 
			}
		}
		if(getdeleteLst != null && !getdeleteLst.isEmpty()) {
			Database.DeleteResult[] getSTimeslot = Database.Delete(getdeleteLst,false);   
			Integer i=0;
			for(Database.DeleteResult results : getSTimeslot){
				if(!results.isSuccess()){
					for(Database.Error err : results.getErrors()) {
					   getUpdateDeleteErrs.put(getdeleteLst.get(i).Id, err.getMessage());
					}
				}
				i++; 
			}
		}
		Map<Id,String> getInsertErrs=new Map<Id,String>();
		if(getEmails != null && !getEmails.isEmpty()) {
			Database.SaveResult[] srList = Database.insert(getEmails, false);
			// Iterate through each returned result
			for (Database.SaveResult sr : srList) {
	if (sr.isSuccess()) {
		getEmailIds.add(sr.getId());
	}
	 }
		}
		if(getEmailIds != null && !getEmailIds.isEmpty()) {
			getEmaillst=[Select Id,CH_Bind1__c,CH_Bind2__c,CH_Bind3__c,CH_Bind4__c,CH_Bind5__c,CH_Bind6__c,CH_Bind7__c,
						 CH_Bind8__c,CH_Bind9__c,CH_Bind10__c,CH_Bind11__c,CH_Bind12__c,CH_Bind13__c,CH_Bind_16__c,CH_Bind_17__c,
						 CH_Bind19__c,CH_Bind20__c
						 from CH_EmailAlert__c Where Id In :getEmailIds];
			for(CH_EmailAlert__c getlsst:getEmaillst){
				CH_Workgroup_Member_Timeslot_Association__c instWSTMA=new CH_Workgroup_Member_Timeslot_Association__c();
				instWSTMA.CH_Workgroup_Member__c=getlsst.CH_Bind_17__c;
				instWSTMA.CH_Workgroup_Schedule_Timeslot__c=getlsst.CH_Bind9__c;
				instWSTMA.CH_Schedule_Type__c=getlsst.CH_Bind19__c;
				lstInsert.add(instWSTMA);
			}
			
			if(lstInsert.Size()>0){
				Database.SaveResult[] getInsertList = Database.insert(lstInsert,false);   
				Integer i=0;
				for(Database.SaveResult results : getInsertList){
					if(!results.isSuccess()){
						for(Database.Error err : results.getErrors()) {
						   getInsertErrs.put(getEmaillst[i].Id, err.getMessage());
						}
					}
					i++; 
				}
				if(getInsertErrs.Values().Size()>0){
					for(CH_EmailAlert__c getlsst:getEmaillst){
						if(getInsertErrs.containskey(getlsst.Id)){
							CH_EmailAlert__c stWSTMA=new CH_EmailAlert__c();
							stWSTMA.CH_Bind1__c=getlsst.CH_Bind1__c;
							stWSTMA.CH_Bind2__c=getlsst.CH_Bind2__c;
							stWSTMA.CH_Bind3__c=getlsst.CH_Bind3__c;
							stWSTMA.CH_Bind4__c=getlsst.CH_Bind4__c;
							stWSTMA.CH_Bind5__c=getlsst.CH_Bind5__c;
							stWSTMA.CH_Bind6__c=getlsst.CH_Bind6__c;
							stWSTMA.CH_Bind7__c=getlsst.CH_Bind7__c;
							stWSTMA.CH_Bind8__c=getlsst.CH_Bind8__c;
							stWSTMA.CH_Bind9__c=getlsst.CH_Bind9__c;
							stWSTMA.CH_Bind10__c=getlsst.CH_Bind10__c;
							stWSTMA.CH_Bind11__c=getlsst.CH_Bind11__c;
							stWSTMA.CH_Bind12__c=getlsst.CH_Bind12__c;
							stWSTMA.CH_Bind13__c=getlsst.CH_Bind13__c;
							stWSTMA.CH_Bind_16__c=getlsst.CH_Bind_16__c;
							stWSTMA.CH_Bind_17__c=getlsst.CH_Bind_17__c;
							stWSTMA.CH_Bind19__c=getlsst.CH_Bind19__c;
							stWSTMA.CH_Bind20__c=getInsertErrs.get(getlsst.Id);
							returnErros.add(stWSTMA);
						}
						
					}
				}
			}
		}
		if(getUpdateDeleteErrs.size()>0){
			for(WorkgroupMemberAssociation details : workgroupSchduleTimeslot){
				if(getUpdateDeleteErrs.containskey(details.getTimeslotMemberId) && !String.IsBlank(getUpdateDeleteErrs.get(details.getTimeslotMemberId))){
			CH_EmailAlert__c stWSTMA=new CH_EmailAlert__c();
						stWSTMA.CH_Bind1__c=details.workgroupName;
						stWSTMA.CH_Bind2__c=details.scheduleName;
						stWSTMA.CH_Bind3__c=details.scheduleStartDate;
						stWSTMA.CH_Bind4__c=details.scheduleStartTime;
						stWSTMA.CH_Bind5__c=details.scheduleEndDate;
						stWSTMA.CH_Bind6__c=details.scheduleEndTime;
						stWSTMA.CH_Bind7__c=details.scheduleTimeZone;
						stWSTMA.CH_Bind8__c=details.timeslotName;
						stWSTMA.CH_Bind9__c=details.getTimeslotId;
						stWSTMA.CH_Bind10__c=details.day;
						stWSTMA.CH_Bind11__c=details.startTime;
						stWSTMA.CH_Bind12__c=details.endTime;
						stWSTMA.CH_Bind13__c=details.getTimeslotMemberId;
						stWSTMA.CH_Bind_16__c=details.workgroupMemberName;
						stWSTMA.CH_Bind_17__c=details.getmemberId;
						stWSTMA.CH_Bind19__c=details.scheduleType;
						stWSTMA.CH_Bind20__c=getUpdateDeleteErrs.get(details.getTimeslotMemberId);
						returnErros.add(stWSTMA);
					}
				}
			}
		if(getEmaillst != null && !getEmaillst.isEmpty()){
			Database.DeleteResult[] getSTimeslot = Database.Delete(getEmaillst,false);   
		}
		return returnErros;
	}
	
	//Check whether the Selected Schedules are Active or InActive
	@AuraEnabled
	Public static Boolean isScheduleActive(String fileData) {
		Boolean isScheduleActive;
		List<Id> getTimeSlotId=new List<Id>();
		List<WorkgroupMemberAssociation> workgroupSchduleTimeslot = (List<WorkgroupMemberAssociation>) JSON.deserialize(fileData, List<WorkgroupMemberAssociation>.class);		   
		for(WorkgroupMemberAssociation details : workgroupSchduleTimeslot){
			getTimeSlotId.add(details.getTimeslotId);
		} 
		for(CH_Workgroup_Schedule_Timeslot__c con: [Select CH_Workgroup_Schedule__r.Name,CH_Workgroup_Schedule__r.Id,Name,ID,CH_Workgroup_Schedule__r.CH_Active__c,
													CH_Day__c,CH_Start_Time__c,CH_End_Time__c FROM CH_Workgroup_Schedule_Timeslot__c Where Id IN : getTimeSlotId]) {
														if(con.CH_Workgroup_Schedule__r.CH_Active__c){
															isScheduleActive=true;
															break;
														}
													}
		
		return isScheduleActive;
	}
	
	//Converting the string to Time 
	Public static time updateTime(String strTimeChange){
		String[] strTimeSplit = strTimeChange.split(':');
		String checktime=strTimeSplit[2];
		if(checktime.toLowerCase().contains('am') && Integer.valueOf(strTimeSplit[0])==12){
			strTimeSplit[0]='0';
		}
		if(checktime.toLowerCase().contains('pm') && Integer.valueOf(strTimeSplit[0])<12){
			Integer timesplit=12+Integer.valueOf(strTimeSplit[0]);
			strTimeSplit[0]=string.valueOf(timesplit);
			
		}
		Time timeChange = Time.newInstance(Integer.valueOf(strTimeSplit[0]) //hour
										   ,Integer.valueOf(strTimeSplit[1]) //min
										   ,0 //sec
										   ,0);  
		return timeChange;
	}
	
	Public class WorkgroupMemberAssociation {
		public string workgroupName;
		public string scheduleName;
		public string scheduleTimeZone;
		public string timeslotName;
		public string getTimeslotId;
		public string day;
		public String scheduleStartDate;
		public String scheduleStartTime;
		public String scheduleEndDate;
		public String scheduleEndTime;
		public String startTime;
		public String endTime;
		public string getTimeslotMemberId;
		public string workgroupMemberName;
		public string getmemberId;
		public string scheduleType;
		public string operationType;
		public string errorMessage;
	}
	 
	
}