/****************************************
* Class Name : CH_WorkgroupRotaTriggerHelper
* Created Date: 12-09-2018
* Created By : TCS
* Description : This trigger is used to create entries for workgroup member for their rotation on reoccurance
* Test Class: CH_WorkgroupRotaTriggerHelperTest
*****************************************/
public class CH_WorkgroupRotaTriggerHelper {
	//********************
	//*Method Name: AddReoccuranceRotaRecords
	//*Parameter: WorkgroupEvent
	//*Description: used to create entries for workgroup member for their rotation on reoccurance
	//*******************/
	public static void AddReoccuranceRotaRecords(List<CH_Workgroup_Event__c> newWorkgroupEventList) {
		try{  
			List<CH_Workgroup_Event__c> workgroupEventList= new List<CH_Workgroup_Event__c>();
			for(CH_Workgroup_Event__c newWorkgroupEvent : newWorkgroupEventList){
				if(newWorkgroupEvent.CH_Recoccurence__c && newWorkgroupEvent.CH_EndOccurence__c!=Null && !String.isBlank(newWorkgroupEvent.CH_Days__c)){
					datetime myStartDate = datetime.newInstance(newWorkgroupEvent.ch_startdate__c.year(), newWorkgroupEvent.ch_startdate__c.month(), newWorkgroupEvent.ch_startdate__c.day(), newWorkgroupEvent.ch_startdate__c.hour(), newWorkgroupEvent.ch_startdate__c.minute(), newWorkgroupEvent.ch_startdate__c.second());
					datetime myEndDate = datetime.newInstance(newWorkgroupEvent.ch_enddate__c.year(), newWorkgroupEvent.ch_enddate__c.month(), newWorkgroupEvent.ch_enddate__c.day(), newWorkgroupEvent.ch_enddate__c.hour(), newWorkgroupEvent.ch_enddate__c.minute(), newWorkgroupEvent.ch_enddate__c.second());
					do{
						myStartDate=myStartDate.addDays(1);
						myEndDate=myEndDate.addDays(1);
						String day = myStartDate.format('EEEE');
						if(newWorkgroupEvent.CH_Days__c.Contains(day)){
							CH_Workgroup_Event__c varWorkgroupEvent = new CH_Workgroup_Event__c(ch_startdate__c=myStartDate,ch_enddate__c=myEndDate,CH_Workgroup__c=newWorkgroupEvent.CH_Workgroup__c,CH_SupportType__c=newWorkgroupEvent.CH_SupportType__c,CH_Timezone__c=newWorkgroupEvent.CH_Timezone__c,CH_WorkgroupMember__c=newWorkgroupEvent.CH_WorkgroupMember__c,CH_Days__c=newWorkgroupEvent.CH_Days__c,CH_EndOccurence__c=newWorkgroupEvent.CH_EndOccurence__c  );
							workgroupEventList.add(varWorkgroupEvent);
						}
					}while(myStartDate< newWorkgroupEvent.CH_EndOccurence__c );
				}
			}
			if(workgroupEventList.size()>0){
				database.insert(workgroupEventList,true);
			}
		}
		catch(Exception ex){
			System.debug('Exception has occured class:CH_WorkgroupRotaTriggerHelper,Method:AddReoccuranceRotaRecords '+ex.getMessage());
		}
	}
}