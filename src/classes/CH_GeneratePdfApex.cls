public with sharing class CH_GeneratePdfApex {
	//This class is designed to keep a dynamic name of the vf page
	public static Case caseObj  { get; set; }
	public Static User userDetails  { get; set; }
	public static Case caseOutDurList  { get; set; }
	public static Case caseAttList  { get; set; }
	public String selectedTimezone  { get; set; }
	
	
	public CH_GeneratePdfApex(ApexPages.StandardController caseController) {
	

		caseObj = (Case) caseController.getRecord();
	String yourFileName =caseObj.caseNumber;			
		Apexpages.currentPage().getHeaders().put( 'content-disposition', 'inline; filename=' + yourFileName + '.pdf');
		selectedTimezone = ApexPages.currentPage().getParameters().get('timezone');
		caseOutDurList = [SELECT Id, (SELECT Id, CH_AttributableParty__c, CH_OutageDurationCause__c, CH_UnitsAffected1__c, CH_DurationClassification__c, CH_DurationStartDate__c, CH_DurationEndDate__c, CH_OutageDuration__c from Outage_Durations__r) from Case where Id=:caseObj.Id];
		caseAttList=[SELECT Id, (select id,name from CH_Attachment__r) from Case where  Id=:caseObj.Id];
	}
	
	
	/*SFDC WORKAROUND*/ 
   /* public string getFormattedString(String str){ 
		integer spacer = 50;   
		List<String> formatString = str.split('') ; //just splitting all the characters into a array 
		
		integer index = spacer ; 
	while( index < formatString.size() - 1 ){
			formatString.add(index, '<br />'); //for every position relating to spacer .. insert a new br tag. 
			index+=spacer ; 
		}
	
		return String.join(formatString, ''); 
	} */
	/*END SFDC WORKAROUND*/

	
	//This class is designed to set the customer care manager details
	public pagereference careManager (){
	 
		try{
			String caseTeamRoleId;
			String caseTeamMemberId;
			List<CaseTeamRole> caseTeamRoleList = [SELECT Id , Name 
			   FROM CaseTeamRole 
			   WHERE Name='Customer Care Manager' 
			   LIMIT 1];
			if(!caseTeamRoleList.isEmpty()){
	caseTeamRoleId = caseTeamRoleList[0].Id;
			}
			if(!String.isBlank(caseTeamRoleId)){
	List<CaseTeamMember> caseTeamMemberList =[SELECT MemberId ,TeamRoleId ,ParentId 
				FROM CaseTeamMember 
				WHERE TeamRoleId=:caseTeamRoleId AND ParentId=:caseObj.Id 
				LIMIT :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
	if(!caseTeamMemberList.isEmpty()){
		caseTeamMemberId=caseTeamMemberList[0].MemberId;	}
	if(!String.isBlank(caseTeamMemberId)){
		userDetails=[SELECT Id , Name,Email,MobilePhone 
		 FROM user 
		 WHERE Id=:caseTeamMemberId 
		 LIMIT 1];
	}
			}
		}Catch(Exception e){System.debug('An unhandled exception occured: '+e.getMessage());}
		return null;
	}
	
	 public Double offset{get{
		TimeZone tz = Timezone.getTimeZone(selectedTimezone);
		//Milliseconds to Day
		return tz.getOffset(DateTime.now()) / (1000 * 3600 * 24.0);
	}}
	
}