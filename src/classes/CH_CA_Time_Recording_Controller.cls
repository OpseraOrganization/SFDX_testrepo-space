public without sharing class CH_CA_Time_Recording_Controller {
	// Check the Case status/owner/case team member(s)
	@AuraEnabled
	public static Boolean checkAddTimeButtonApplicability(String caseId){
		Boolean returnMsg =true;		 
		
		Case supportCase = [SELECT Id, Status,OwnerId 
				FROM Case 
				WHERE Id =:caseId LIMIT 1];
		System.debug('CH_CA : SupprotCase : ' + supportCase);
		//Check if Case status is cancelled or completed	
		if( supportCase.Status=='Cancelled' ||supportCase.Status=='Completed' ){
			return true;
		}
		//Check if login user is a case  owner
		if (supportCase.OwnerId ==UserInfo.getUserId()){
			return false; 
		}
		//Check if login user is a part of Case Team
		Integer caseTeamMembercount= [SELECT count()
			  FROM CaseTeamMember 
			  WHERE ParentId =: caseId AND MemberId= : UserInfo.getUserId() limit 1 ];
		if (caseTeamMemberCount != 0 ){  
			return false;	   
		}
		return returnMsg;
	}
	//get login user case team role
	@AuraEnabled
	public static List< String> getUserRole(String caseId){
		List< String> role = new List<String>();		
		Case supportCase = [SELECT Id, Status,OwnerId 
				FROM Case 
				WHERE Id =:caseId];
		//Check if login user is a case  owner
		if (supportCase.OwnerId ==UserInfo.getUserId()){
			role.add('Owner');
		}
		Integer caseTeamMembercount= [SELECT count()
			  FROM CaseTeamMember 
			  WHERE ParentId =: caseId AND MemberId= : UserInfo.getUserId() limit 1 ];
		if (caseTeamMemberCount != 0 ){
			CaseTeamMember caseTeamMember= [SELECT Id,TeamRoleId
					FROM CaseTeamMember 
					WHERE ParentId =: caseId AND MemberId= : UserInfo.getUserId() limit 1 ];
			
			CaseTeamRole caseTeamRole = [SELECT Id,Name 
				 FROM CaseTeamRole 
				 WHERE Id = :caseTeamMember.TeamRoleId LIMIT 1];
			
			role.add(caseTeamRole.Name);
			
		}
		return role;
	}
	//save time recording data 
	@AuraEnabled	
	public static void saveTimeRecording(String caseId, String role,Integer hours,Integer minutes,String startDate){
		Integer timeSpent =0;
		String errorMsg='';
		DateTime dateStart;
		try{ 
			//Validate data
			errorMsg= validateInputData(role,hours,minutes);
	 //NOKIASC-38835
		   if (hours==0&&minutes==0){
	AuraHandledException auraExp = new AuraHandledException('');
	auraExp.setMessage('Please enter a duration.'); 
	throw auraExp;
			}
			if (!String.isBlank(errorMsg))
			{
	AuraHandledException auraExp = new AuraHandledException('');
	auraExp.setMessage(errorMsg);   
	throw auraExp; 
			}
			//Converting string to date
			if(String.isNotBlank(startDate)){
	dateStart = convertStringToDateTime(startDate);
			}
			timeSpent=hours*60+minutes;
			
			System.debug('CH_CA : saveTimeRecording caseId:' + caseId + ' role: '+ role+ ' hours: '+hours +' minutes: '+minutes);
			//Map user data against user id
			map<Id, User> users = new map<Id, User>([SELECT Id,User_Cost_Center__c,User_Cost_Center_Description__c,Department FROM user where id = :UserInfo.getUserId()]);
			// Initialize CH_TimeRecording__c for insert data
			CH_TimeRecording__c timeRecording= new CH_TimeRecording__c();
			timeRecording.CH_Role__c=role;
			timeRecording.CH_SupportTicketNumber__c=caseId;
			timeRecording.CH_TimeSpent__c=timeSpent;		
			timeRecording.CH_CostCenterDescription__c=users.get(UserInfo.getUserId()).User_Cost_Center_Description__c;
			timeRecording.CH_UserName__c=UserInfo.getUserId();		  
			timeRecording.CH_Organization__c=users.get(UserInfo.getUserId()).Department;
			if(String.isNotBlank(startDate)){
	timeRecording.CH_StartDate__c=dateStart;
			}
			insert timeRecording;  
		}
		catch(DmlException e){
			//Any type of Validation Rule error message, Required field missing error message, Trigger error message etc..		 
			for (Integer i = 0; i < e.getNumDml(); i++) {
	//Get Validation Rule & Trigger Error Messages
	errorMsg =+ e.getDmlMessage(i) +  '\n' ;
			}
			//throw DML exception message
			throw new AuraHandledException(errorMsg);
		}
		catch(Exception e){
			System.debug('CH_CA :Exception saveTimeRecording' + e);
			throw new AuraHandledException(e.getMessage());
		}
	}
	//Edit Time Recording Data
	@AuraEnabled	
	public static void editTimeRecording(String Id, String role,Integer hours,Integer minutes,String startDate){
		Integer timeSpent =0;
		String errorMsg='';
		DateTime dateStart;
		try{ 
			//Validate data
			errorMsg= validateInputData(role,hours,minutes);
			if (!String.isBlank(errorMsg))
			{
	AuraHandledException auraExp = new AuraHandledException('');
	auraExp.setMessage(errorMsg);   
	throw auraExp; 
			}
			//Converting string to date
			if(String.isNotBlank(startDate)){
	dateStart = convertStringToDateTime(startDate);
			}
			timeSpent=hours*60+minutes;
			System.debug('CH_CA : editTimeRecording Id:' + Id + ' role: '+ role+ ' hours: '+hours +' minutes: '+minutes);
			//retrive record to update
			CH_TimeRecording__c updateTimeRecording=[ SELECT Id,CH_Role__c,CH_SupportTicketNumber__r.casenumber,CH_TimeSpent__c,CH_UserName__c,CreatedDate,LastModifiedDate,CH_Organization__c
				 FROM CH_TimeRecording__c 
				 WHERE Id =: Id LIMIT 1];
			//validate the user is owner or not
			if (updateTimeRecording.CH_UserName__c!=UserInfo.getUserId()){
	AuraHandledException auraExp = new AuraHandledException('');
	auraExp.setMessage('You are not allowed to modify this record. Only the Record Owner can modify the record.');  
	throw auraExp;
			}
			//Ref:NOKIASC-36264 Validate Hours & Minutes
			if (hours==0&&minutes==0){
	AuraHandledException auraExp = new AuraHandledException('');
	auraExp.setMessage('Please enter a duration.'); 
	throw auraExp;
			}
			//update data in CH_TimeRecording__c
			updateTimeRecording.CH_TimeSpent__c=timeSpent;
			if(String.isNotBlank(startDate)){
	updateTimeRecording.CH_StartDate__c=dateStart;
			}
			update  updateTimeRecording;  
		}
		catch(DmlException e){
			//Any type of Validation Rule error message, Required field missing error message, Trigger error message etc..		 
			for (Integer i = 0; i < e.getNumDml(); i++) {
	//Get Validation Rule & Trigger Error Messages
	errorMsg =+ e.getDmlMessage(i) +  '\n' ;
			}
			//throw DML exception message
			throw new AuraHandledException(errorMsg);
		}
		catch(Exception e){
			System.debug('CH_CA :Exception editTimeRecording' + e);
			throw new AuraHandledException(e.getMessage());
		}
	}
	//Validate input data
	public static String validateInputData(String role,Integer hours,Integer minutes){
		Integer timeSpent =0;
		String errorMsg='';	 
		if (String.isBlank(role)){	  
			errorMsg += 'Role can not be blank.';
		}   
		timeSpent=hours*60+minutes;
		if(timeSpent>120000 || timeSpent<0){	  
			errorMsg += 'Time Spent can not be greater than 120000 and less than 0';	
		}
		return errorMsg;
	}
	//get record against a case
	//Uncomment if required
	@AuraEnabled
	public static List<CH_TimeRecording__c> getTimeRecordingListbyCaseId(String caseId){
		return [SELECT Id,CH_Role__c,CH_SupportTicketNumber__c,CH_SupportTicketNumber__r.casenumber,CH_TimeSpent__c,CH_UserName__r.Name, 
	CreatedDate,LastModifiedDate,CH_Organization__c,CH_StartDate__c
	FROM CH_TimeRecording__c 
	WHERE CH_SupportTicketNumber__c =: caseId];
	}
	//get record aginst time record id
	@AuraEnabled
	public static List<CH_TimeRecording__c> getTimeRecordingListbyId(String timeRecordingId){
		return [SELECT Id,CH_Role__c,CH_SupportTicketNumber__c,CH_SupportTicketNumber__r.casenumber,CH_TimeSpent__c,CH_UserName__r.Name, 
	CreatedDate,LastModifiedDate,CH_Organization__c,CH_StartDate__c
	FROM CH_TimeRecording__c 
	WHERE Id =: timeRecordingId LIMIT 1];
	}
	
	//Method : getStartDate
	//Description : This method is used to return current date time
	@AuraEnabled
	public static DateTime getStartDate(){
		return system.now();
	}
	//Method : convertStringToDateTime
	//Description : This method is used to convert string Date to DateTime format.
	//parameter1 : string strDate : it is a string Date
	private static DateTime convertStringToDateTime (string strDate){
		DateTime datetoDateTime ;
		if(strDate != null){
			// need convert to '2019-04-18 11:57:10' format where given format would be 
			string onlyDate = strDate.substringBefore('T');
			string onlyTime = strDate.substringBetween('T','Z');
			string generatedStardDate = onlyDate+ ' '+onlyTime;
			datetoDateTime = DateTime.valueOf(generatedStardDate);
		}
		return datetoDateTime;
	}

}