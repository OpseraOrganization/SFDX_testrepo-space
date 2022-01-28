/**********************************************************************************************************************
* Class Name 	: CH_CA_WorkgroupUserController
* Created Date	: 30-04-2019
* Created By 	: TCS
* Description 	: This class is used by lightning component CH_CA_GenericLookupComponent which will create lookup for specified  object.
* Test Class	: CH_CA_WorkgroupUser_Controller_Test
**********************************************************************************************************************/
public class CH_CA_WorkgroupUserController {
	// Method to get Current User
	@AuraEnabled
	public static User fetchCurrentUser(){
		User currentUser = [SELECT Id, Name FROM User WHERE id =: userInfo.getUserId()];
		System.debug('CH CA: current user'+currentUser);
		return currentUser;
	}
	
	// Method to return workgroup and associated details based on user
	@AuraEnabled
	public static List<WorkgroupUserWrapper> searchWorkgroupByUser(String userId){
		System.debug('CH CA: user to be searched' +userId);
		List<CH_Workgroup_Member__c> workgroupmembers;
		List<CH_Workgroup__c> workgroups;
		List<CH_Workgroup_Member_Timeslot_Association__c> workgroupMemberTimeslotAssociation;
		List<CH_Workgroup_Schedule__c> workgroupScheduleList;
		Set<Id> distinctWorkgroups = new Set<Id>();  
		Set<Id> workgroupMembersSet = new Set<Id>();  
		Set<Id> workgroupScheduleSet = new Set<Id>();
		List<WorkgroupUserWrapper> listofWorkgroupUser = new List<WorkgroupUserWrapper>();
		
		if(!String.isBlank(userId)){
			workgroupmembers = [SELECT Id, CH_Name__c, CH_Workgroup__c, CH_Role__c 
								FROM CH_Workgroup_Member__c 
								WHERE CH_User__c =:userId];
			System.debug('CH CA: returned members'+workgroupmembers);
			if( workgroupmembers.size() > 0){
				//Get list of  workgroup users and workgroups user falls in
				for(CH_Workgroup_Member__c workgroupmember : workgroupmembers){
					distinctWorkgroups.add(workgroupmember.CH_Workgroup__c);
					workgroupMembersSet.add(workgroupmember.Id);
				}
			}
			System.debug('CH CA: List of Workgroups'+distinctWorkgroups);
			//Get workgroup details of workgroups related to returned members
			if(distinctWorkgroups.size() > 0){
				workgroups = [SELECT Id, Name, CH_Level_Of_Support__c, CH_Type__c,Owner.Name, CH_BusinessHours__r.Name, CH_Workgroup_Admin__r.Name 
							  FROM CH_Workgroup__c 
							  WHERE Id IN :distinctWorkgroups];
			}
			//If workgroup members are present then fetch their timeslot association
			if(workgroupMembersSet != NULL && workgroupMembersSet.size() > 0){
				workgroupMemberTimeslotAssociation = [SELECT Id, CH_Workgroup_Member__c, CH_Workgroup_Id__c, CH_Workgroup_Schedule_Timeslot__c, CH_Schedule_Id__c
													  FROM CH_Workgroup_Member_Timeslot_Association__c 
													  WHERE CH_Workgroup_Member__c IN :workgroupMembersSet];
			}
			if(workgroupMemberTimeslotAssociation != NULL && workgroupMemberTimeslotAssociation.size() > 0){
				//Create set of ID for workgroup schedule
				for(CH_Workgroup_Member_Timeslot_Association__c workgroupMemberTSA : workgroupMemberTimeslotAssociation){
					workgroupScheduleSet.add(workgroupMemberTSA.CH_Schedule_Id__c);
				}
				workgroupScheduleList = [SELECT Id, CH_Workgroup__c, CH_Start_DateTime__c, CH_End_DateTime__c
										 FROM CH_Workgroup_Schedule__c 
										 WHERE Id IN :workgroupScheduleSet
										 AND CH_End_DateTime__c >= :SYSTEM.now()
										 AND CH_Active__c = true];
			}
			
			for(CH_Workgroup_Member__c workgroupmember : workgroupmembers){
				WorkgroupUserWrapper workgroupUserrecord = new WorkgroupUserWrapper();
				workgroupUserrecord.userRole = workgroupmember.CH_Role__c;
				workgroupUserrecord.scheduled = 'No'; //setting default value to No
				// To check if Member is Scheduled
				if(workgroupMemberTimeslotAssociation.size() > 0){
					//Loop through available workgroup member timeslot association
					for(CH_Workgroup_Member_Timeslot_Association__c workgroupTSA : workgroupMemberTimeslotAssociation){
						//Check if workgroup member is present in timeslot assocation set
						if(workgroupTSA.CH_Workgroup_Member__c == workgroupmember.Id){
							if(workgroupScheduleList.size() > 0){
								//Loop through all workgroup schedule
								for(CH_Workgroup_Schedule__c workgroupSchedule : workgroupScheduleList){
									//check if workgroup schedule id is present in workgroup time slot association
									if(workgroupSchedule.Id == workgroupTSA.CH_Schedule_Id__c){
										DateTime startdate = workGroupSchedule.CH_Start_DateTime__c;
										System.debug('CH CA: startdate'+startdate);
										//check if workgroup member falls within active schedule.
										if(startdate <= system.now() || startdate <= system.now().addMonths(1)){
											workgroupUserrecord.scheduled = 'Yes';
										}
									}
								}
							}
						}
					}
				}
				// to setup workgroup Information for Workgroup Member
				for(CH_Workgroup__c workgroup : workgroups){
					if(workgroup.Id == workgroupmember.CH_Workgroup__c){
						// Seperating level of Support values
						String finalLvlOfSupport = '';
						String finalworkgroupType = '';
						String tempBHName = '';
						if(workgroup.CH_Level_Of_Support__c != NULL){
							String tempLvlOfSupport = workgroup.CH_Level_Of_Support__c;
							String[] arrLvlOfSupport = tempLvlOfSupport.split(';');
							for(String lvlOfSupport : arrLvlOfSupport){
								finalLvlOfSupport = '<div>' + finalLvlOfSupport+lvlOfSupport + '</div>';
							}
							// Seperating  Bussiness Hrs 
							if(workgroup.CH_Workgroup_Business_Hours_Associations__r != null){
								for(CH_Workgroup_Business_Hours_Association__c bhAssociation : workgroup.CH_Workgroup_Business_Hours_Associations__r){
									tempBHName = '<div>' + tempBHName+bhAssociation.CH_Business_Hours__r.Name + '</div>';
								} 
							}
						}
						// Seperating  Workgroup Type
						if(workgroup.CH_Type__c != null) {
							String tempworkgroupType = workgroup.CH_Type__c;
							String[] arrtempworkgroupType = tempworkgroupType.split(';');
							for(String workgroupType : arrtempworkgroupType){
								finalworkgroupType = '<div>' + finalworkgroupType+workgroupType + '</div>';
							}
						}
						//setting values
						workgroupUserrecord.workgroupName = workgroup.Name;					   
						workgroupUserrecord.levelOfSupport = finalLvlOfSupport;
						workgroupUserrecord.workgroupType = finalworkgroupType;
						workgroupUserrecord.workgroupManager = workgroup.Owner.Name;
						workgroupUserrecord.workgroupAdmin = workgroup.CH_Workgroup_Admin__r.Name;						
						workgroupUserrecord.workgroupBusinessHours = tempBHName;   
						listofWorkgroupUser.add(workgroupUserrecord);
					}
				}
			}
		}
		System.debug('CH CA: returned members'+listofWorkgroupUser);
		return listofWorkgroupUser;
	}
	
	public class WorkgroupUserWrapper{
		@AuraEnabled public String workgroupName {get; set;}
		@AuraEnabled public String levelOfSupport{get; set;}
		@AuraEnabled public String userRole {get; set;}
		@AuraEnabled public String workgroupType {get; set;}
		@AuraEnabled public String workgroupManager {get; set;}
		@AuraEnabled public String workgroupAdmin {get; set;}
		@AuraEnabled public String workgroupBusinessHours {get; set;}
		@AuraEnabled public String scheduled {get; set;}
	}
}