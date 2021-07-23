public with sharing class CH_GeneratePdfApex {
	//This class is designed to keep a dynamic name of the vf page
	public static Case caseObj  { get; set; }
	public Static User userDetails  { get; set; }
	public String RootCauseDescription {get;set;}
	public String StepsToReproduceIssue {get;set;}
	public String SummaryOfAnalysis {get;set;}
	public String ActionTaken {get;set;}
	public String PreventiveActions {get;set;}
	public String CorrectiveActions {get;set;}
	public String IssueDescription {get;set;}
	public String SequenceOfEvents {get;set;}
	public String RestorationMethod {get;set;}
	public String TechnicalAnalysis {get;set;}
	public String TemporarySolution {get;set;}
	public String SolutionDetails {get;set;}
	
	public Case c;
	public list<case> caseList;
	
	public CH_GeneratePdfApex(ApexPages.StandardController caseController) {
   // caseController.addFields(new list<string>{'CH_problem__r.CH_Root_Cause_Description__c','CH_problem__r.Steps_to_Reproduce_Issue__c','CH_problem__r.CH_SummaryofAnalysis__c'});
	

		caseObj = (Case) caseController.getRecord();
		this.c= (Case)caseController.getRecord();
		caseList = [select id,CH_RestorationMethod__c, CH_TechnicalAnalysis__c, CH_TemporarySolution__c, CH_SolutionDetails__c, CH_SequenceOfEvents__c,CH_IssueDescription__c,CH_Problem__r.CH_CorrectiveActions__c,CH_Problem__r.CH_ActionTaken__c,CH_Problem__r.CH_PreventiveActions__c,CH_problem__r.CH_Root_Cause_Description__c,CH_problem__r.Steps_to_Reproduce_Issue__c,CH_problem__r.CH_SummaryofAnalysis__c
								from case where id=:caseObj.Id];
						String yourFileName =caseObj.caseNumber;			
		Apexpages.currentPage().getHeaders().put( 'content-disposition', 'inline; filename=' + yourFileName + '.pdf');
	}
	
	public PageReference process(){
		if(caseList[0].CH_problem__r.CH_Root_Cause_Description__c != null){
			RootCauseDescription = caseList[0].CH_problem__r.CH_Root_Cause_Description__c;
			RootCauseDescription = getFormattedString(RootCauseDescription) ; //SFDC WORKAROUND
			//RootCauseDescription = RootCauseDescription.replaceAll('\n','<br />');
			
			}
		if(caseList[0].CH_problem__r.Steps_to_Reproduce_Issue__c != null){
			StepsToReproduceIssue = caseList[0].CH_problem__r.Steps_to_Reproduce_Issue__c;
			StepsToReproduceIssue = getFormattedString(StepsToReproduceIssue) ; //SFDC WORKAROUND 
		   // StepsToReproduceIssue = StepsToReproduceIssue.replaceAll('\n','<br />');
		}
		
		if(caseList[0].CH_problem__r.CH_SummaryofAnalysis__c != null){
			SummaryOfAnalysis = caseList[0].CH_problem__r.CH_SummaryofAnalysis__c;
			SummaryOfAnalysis = getFormattedString(SummaryOfAnalysis) ; //SFDC WORKAROUND
			
			//SummaryOfAnalysis = SummaryOfAnalysis.replaceAll('\n','<br />');
		}
		if(caseList[0].CH_Problem__r.CH_PreventiveActions__c != null){
		PreventiveActions = caseList[0].CH_Problem__r.CH_PreventiveActions__c;
		PreventiveActions = getFormattedString(PreventiveActions);
		}
		  if(caseList[0].CH_Problem__r.CH_ActionTaken__c != null){
		  ActionTaken = caseList[0].CH_Problem__r.CH_ActionTaken__c;
		  ActionTaken = getFormattedString(ActionTaken);
		  } 
		  if(caseList[0].CH_Problem__r.CH_CorrectiveActions__c != null){
		  CorrectiveActions = caseList[0].CH_Problem__r.CH_CorrectiveActions__c;
		  CorrectiveActions = getFormattedString(CorrectiveActions);
		  } 
		  if(caseList[0].CH_IssueDescription__c != null){
		  IssueDescription = caseList[0].CH_IssueDescription__c;
		  IssueDescription = getFormattedString(IssueDescription);
		  } 
		  if(caseList[0].CH_SequenceOfEvents__c != null){
		  SequenceOfEvents = caseList[0].CH_SequenceOfEvents__c;
		  SequenceOfEvents = getFormattedString(SequenceOfEvents);
		  }
		  if(caseList[0].CH_RestorationMethod__c != null){
		  RestorationMethod = caseList[0].CH_RestorationMethod__c;
		  RestorationMethod = getFormattedString(RestorationMethod);
		  }
		  if(caseList[0].CH_TechnicalAnalysis__c != null){
		  TechnicalAnalysis = caseList[0].CH_TechnicalAnalysis__c;
		  TechnicalAnalysis = getFormattedString(TechnicalAnalysis);
		  }
		  if(caseList[0].CH_TemporarySolution__c != null){
		  TemporarySolution = caseList[0].CH_TemporarySolution__c;
		  TemporarySolution = getFormattedString(TemporarySolution);
		  }
		  if(caseList[0].CH_SolutionDetails__c != null){
		  SolutionDetails = caseList[0].CH_SolutionDetails__c;
		  SolutionDetails = getFormattedString(SolutionDetails);
		  }
		return null;
	}
	/*SFDC WORKAROUND*/
	public string getFormattedString(String str){ 
		integer spacer = 50 ;   
		List<String> formatString = str.split('') ; //just splitting all the characters into a array 
		//List<String> formatString = str.split(',') ; //alternative of splitting based on , or could choose own 
		integer index = spacer ; 
		while( index < formatString.size() - 1  ){
			formatString.add(index, '<br />'); //for every position relating to spacer .. insert a new br tag. 
			index+=spacer ; 
		}
		return String.join(formatString, '')   ; 
	}
	/*END SFDC WORKAROUND*/

	
	//This class is designed to set the customer care manager details
	public static void careManager (){
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
					caseTeamMemberId=caseTeamMemberList[0].MemberId;				}
				if(!String.isBlank(caseTeamMemberId)){
					userDetails=[SELECT Id , Name,Email,MobilePhone 
								 FROM user 
								 WHERE Id=:caseTeamMemberId 
								 LIMIT 1];
				}
			}
		}Catch(Exception e){System.debug('An unhandled exception occured: '+e.getMessage());}
	}
	
}