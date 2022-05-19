public without sharing class OpportunityStrategyController
{
	//Export VF page attributes
	public Opportunity opportunity {get;set;}
	public List<Competitor__c> competitors {get;set;}
	public List<ContactRoleInfo> contactRoles {get;set;}
	public List<Task> activities {get;set;}
	private String taskPrefix = Label.CRM_WinPlanPrefix;

	//Opportunity Strategy LC attributes
	private static Set<String> profilesAllowedEdit = new Set<String>{'Excel Add-In Profile','Sales Ops Profile','Non-Sales User Profile',
		'Nokia Sales Profile','Nokia Admin Profile','System Administrator',
		'Integration API Only Profile','DeployProfile','Global Process Admin Profile',
		'Data Loader Profile'};


	@AuraEnabled(cacheable=true)
	public static boolean allowedUserToEdit(ID recordId)
	{
		Id profileId = UserInfo.getProfileId();
		try
		{
			List<Opportunity> oppList = [SELECT ID,Phase_Status__c FROM Opportunity WHERE ID=:recordId];
			if( !oppList.isEmpty() && !oppList[0].Phase_Status__c.contains('Submitted for')){
				List<Profile> profileAllowed = [SELECT ID,Name FROM Profile WHERE Name IN :profilesAllowedEdit AND Id = :profileId];
				if(!profileAllowed.isEmpty()){
					return true;
				}
			}
			return false;
		}
		catch(Exception e){
			System.debug('[OpportunityStrategyController] --> '+e.getLineNumber()+' '+e.getTypeName()+' '+ e.getMessage()+' '+e.getStackTraceString());
			return false;
		}
	}

/**
*   @description : Method used on CRM_WinPlanExport VF Page to retrive opportunity data
*/
	public void getOpportunityInfo(){
		Id opptyId = ApexPages.currentPage().getParameters().get('recordId');
		competitors = new List<Competitor__c>();
		contactRoles = new List<ContactRoleInfo>();
		activities = new List<Task>();
		String taskSubjectFilter = taskPrefix + '%';

		opportunity = [SELECT Id, Name, Opportunity_Id__c, Account.Name, StageName, Country__c, Amount, Owner.Name, End_Customer__r.Name, End_Customer_Country__c, G5_Planned_Date__c,CurrencyIsoCode,
					   Customer_Request__c, StrategicContextCompetitiveSituation__c, Customer_pain_points_challenges__c, Pursue_Strategy__c, Selection_Criteria__c,
					   High_level_Solution_Installed_base__c, Customer_Commitment__c, Solution_Scope_Installed_base__c, Target_Price_Budget__c, Commercial_strategy__c,
					   Probability, Likelyhood_to_Win__c, Pres_sales_Cost_And_Resources__c,Comments_Cust_Req_Nokia_Prop__c,Comments_Competitive_Analysis__c,
					   (SELECT Id,Competitor_New__c, Primary_Competitor__c, Strength__c, Weakness__c FROM Competitors__r ORDER BY CreatedDate ASC),
					   (SELECT Id,ContactId, Contact.Name, Contact.AccName__c, Role, Engagement_Level__c, Opinion_of_Nokia__c FROM OpportunityContactRoles ORDER BY CreatedDate ASC),
					   (SELECT Id, WhoId, OwnerId, Owner.Name, Subject, ActivityDate, Status FROM Tasks WHERE Subject LIKE :taskSubjectFilter ORDER BY CreatedDate ASC)
					  FROM Opportunity WHERE Id = :opptyId];

		String fileName = 'CRM_OpportunityStrategy&WinPlan_' + opportunity.Opportunity_Id__c + '.pdf' ;
		Apexpages.currentPage().getHeaders().put( 'content-disposition', 'inline; filename=' + fileName );

		List<Competitor__c> auxCompetitorLst = new List<Competitor__c>(opportunity.Competitors__r);
		for(Integer k = 0; k < auxCompetitorLst.size() ; k++){
			if(auxCompetitorLst[k].Competitor_New__c == Label.CRM_Nokia_Competitor_Name){
				competitors.add(auxCompetitorLst.remove(k));
				break;
			}
		}
		competitors.addAll(auxCompetitorLst);

		Map<Id, ContactRoleInfo> contactRolesMap = new Map<Id, ContactRoleInfo>();
		for(OpportunityContactRole contact : opportunity.OpportunityContactRoles){
		 	contactRolesMap.put(contact.ContactId, new ContactRoleInfo(contact, new List<Task>()));
		}

		for(Task taskObj : opportunity.Tasks){
			taskObj.Subject = taskObj.Subject.replace(taskPrefix,'');
			if(contactRolesMap.containsKey(taskObj.WhoId)){
				contactRolesMap.get(taskObj.WhoId).tasks.add(taskObj);
			} else {
				activities.add(taskObj);
			}
		}
		contactRoles = contactRolesMap.values();
	}

	public class ContactRoleInfo {
		public OpportunityContactRole contactRole {get;set;}
		public List<Task> tasks {get;set;}
		public ContactRoleInfo(OpportunityContactRole contactRole, List<Task> tasks){
			this.contactRole = contactRole;
			this.tasks = tasks;
		}
	}
}