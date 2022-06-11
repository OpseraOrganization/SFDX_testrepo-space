public with sharing class CRM_CompetitiveAnalysis_listViewCtrl
{	
	@AuraEnabled
	public static WrapperFull getOppCompetitorsApex(Id oppId)
	{	
		WrapperFull wrapper = new WrapperFull();
		try
		{
			wrapper.competitorStrengthPLV = getPicklistValues('Competitor__c','Strength__c');
			wrapper.competitorWeaknessPLV = getPicklistValues('Competitor__c','Weakness__c');
			wrapper.competitorPLV = getPicklistValues('Competitor__c','Competitor_New__c');
			wrapper.competitorWrapperList = new List<WrapperCompetitor>();
			Opportunity oppRecord = [SELECT Id, AccountId, Comments_Competitive_Analysis__c,
				(SELECT Id, Competitor_New__c, Strength__c, Weakness__c, Primary_Competitor__c, Opportunity__c FROM Competitors__r)
			 FROM Opportunity WHERE Id = :oppId];
			wrapper.comments = oppRecord.Comments_Competitive_Analysis__c;
			wrapper.oppId = oppRecord.Id;
			List<Competitor__c> competitors = oppRecord.Competitors__r;
			for(Competitor__c comp : competitors)
			{
				WrapperCompetitor wrapperC = new WrapperCompetitor();
				wrapperC.Id = comp.Id;
				wrapperC.name = comp.Competitor_New__c;
				wrapperC.strengthString = comp.Strength__c;
				wrapperC.strength = new List<String>();
				if(comp.Strength__c != null)
				{
					wrapperC.strength = comp.Strength__c.split(';');
				}
				wrapperC.weaknessString = comp.Weakness__c;
				wrapperC.weakness = new List<String>();
				if(comp.Weakness__c != null)
				{
					wrapperC.weakness = comp.Weakness__c.split(';');
				}
				wrapperC.primary = comp.Primary_Competitor__c;
				wrapperC.oppId = comp.Opportunity__c;
				wrapperC.readMode = true;
				wrapper.competitorWrapperList.add(wrapperC);

				if(Label.CRM_Nokia_Competitor_Name.equals(wrapperC.name))
				{
					wrapperC.nokiaCompetitor = true;
				}
				else
				{
					wrapperC.nokiaCompetitor = false;
				}
			}
		}
		catch(DMLException err)
		{
			wrapper.errorMessage = err.getDmlMessage(0);
		}
		catch (Exception err)
		{
			if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) )
			{
				wrapper.errorMessage = err.getMessage().split('error:')[1].split(':')[0] + '.';
			}
			else
			{
				wrapper.errorMessage = err.getMessage();
			}
		}
		return wrapper;
	}

	@AuraEnabled
	public static WrapperCompetitor saveCompetitorApex(WrapperCompetitor competitorWrapper)
	{
		try
		{
			Boolean isCreation = ( competitorWrapper.Id == null );
			List<Competitor__c> compList = new List<Competitor__c>();
			Competitor__c competitor = new Competitor__c();
			competitor.Id = competitorWrapper.Id;
			if(isCreation)
			{
				competitor.Opportunity__c = competitorWrapper.oppId;
			}
			competitor.Competitor_New__c = competitorWrapper.name;
			competitor.Strength__c = competitorWrapper.strength == null ? null : String.join(competitorWrapper.strength,';');
			competitor.Weakness__c = competitorWrapper.weakness == null ? null : String.join(competitorWrapper.weakness,';');
			competitor.Primary_Competitor__c = competitorWrapper.primary;

			if(competitor.Primary_Competitor__c)
			{
				List<Competitor__c> currPrimaryComp = new List<Competitor__c>();
				if(isCreation)
				{
					currPrimaryComp = [SELECT Id, Primary_Competitor__c FROM Competitor__c WHERE Primary_Competitor__c = true AND Opportunity__c = :competitorWrapper.oppId];
					if(currPrimaryComp.size() > 0)
					{
						currPrimaryComp[0].Primary_Competitor__c = false;
						update currPrimaryComp;//needed because upsert first perform inserts and then updates.... we need the other way arround
					}
				}
				else
				{
					currPrimaryComp = [SELECT Id, Primary_Competitor__c FROM Competitor__c WHERE Primary_Competitor__c = true AND Id != :competitor.Id AND Opportunity__c = :competitorWrapper.oppId];
					if(currPrimaryComp.size() > 0)
					{
						currPrimaryComp[0].Primary_Competitor__c = false;
						compList.add(currPrimaryComp[0]);
					}
				}
			}
			compList.add(competitor);
			upsert compList;

			if(isCreation)
			{
				competitorWrapper.Id = competitor.Id;
			}
			competitorWrapper.readMode = true;
			competitorWrapper.weaknessString = competitor.Weakness__c;
			competitorWrapper.strengthString = competitor.Strength__c;
		}
		catch(DMLException err)
		{
			competitorWrapper.errorMessage = err.getDmlMessage(0);
		}
		catch (Exception err)
		{
			if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) )
			{
				competitorWrapper.errorMessage = err.getMessage().split('error:')[1].split(':')[0];
			}
			else
			{
				competitorWrapper.errorMessage = err.getMessage();
			}
		}
		return competitorWrapper;
	}

	 @AuraEnabled
	public static WrapperFull deleteCompetitorApex(WrapperCompetitor competitorWrapper)
	{
		WrapperFull wrapper = new WrapperFull();
		try
		{
			Competitor__c comp = [SELECT Id FROM Competitor__c WHERE Id = :competitorWrapper.Id];
			delete comp;
			wrapper.successMessage = 'Competitor was successfully deleted.';
		}
		catch(DMLException err)
		{
			competitorWrapper.errorMessage = err.getDmlMessage(0);
		}
		catch (Exception err)
		{
			if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) )
			{
				wrapper.errorMessage = err.getMessage().split('error:')[1].split(':')[0] + '.';
			}
			else
			{
				wrapper.errorMessage = err.getMessage();
			}
		}	 
		return wrapper;
	}
	
	@AuraEnabled
	public static WrapperFull updateCommentsApex(Id oppId, String comments)
	{	
		WrapperFull wrapper = new WrapperFull();
		try
		{
			Opportunity oppRecord = [SELECT Id, AccountId, Comments_Competitive_Analysis__c FROM Opportunity WHERE Id = :oppId];
			oppRecord.Comments_Competitive_Analysis__c = comments;
			update oppRecord;
			wrapper.successMessage = 'Competitor comment field updated.';
		}
		catch(DMLException err)
		{
			wrapper.errorMessage = err.getDmlMessage(0);
		}
		catch (Exception err)
		{
			if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) )
			{
				wrapper.errorMessage = err.getMessage().split('error:')[1].split(':')[0] + '.';
			}
			else
			{
				wrapper.errorMessage = err.getMessage();
			}
		}
		return wrapper;
	}

	private static Map<String, String> getPicklistValues(String objectName, String fieldName){
		Map<String, String> options = new Map<String, String>();	   

		Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
		Schema.DescribeSObjectResult r = s.getDescribe() ;
		Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
		Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

		for( Schema.PicklistEntry pickListVal : ple){
			options.put(pickListVal.getValue(), pickListVal.getLabel());
		}
		return options;
	}

	/** WRAPPER CLASSES**/
	public class WrapperFull
	{
		@AuraEnabled
		public Id oppId  {get;set;}
		@AuraEnabled
		public String comments  {get;set;}
		@AuraEnabled
		public List<WrapperCompetitor> competitorWrapperList {get;set;}
		@AuraEnabled
		public Map<String, String> competitorStrengthPLV  {get;set;}
		@AuraEnabled
		public Map<String, String> competitorWeaknessPLV  {get;set;}
		@AuraEnabled
		public Map<String, String> competitorPLV  {get;set;}
		@AuraEnabled
		public String successMessage {get;set;}
		@AuraEnabled
		public String errorMessage {get;set;}
	}

	public class WrapperCompetitor
	{
		@AuraEnabled
		public Id Id  {get;set;}
		@AuraEnabled
		public Id oppId  {get;set;}
		@AuraEnabled
		public String name  {get;set;}
		@AuraEnabled
		public List<String> strength  {get;set;}
		@AuraEnabled
		public List<String> weakness  {get;set;}
		@AuraEnabled
		public String weaknessString  {get;set;}
		@AuraEnabled
		public String strengthString  {get;set;}
		@AuraEnabled
		public Boolean primary  {get;set;}
		@AuraEnabled
		public Boolean nokiaCompetitor  {get;set;}
		@AuraEnabled
		public Boolean readMode  {get;set;}
		@AuraEnabled
		public String successMessage {get;set;}
		@AuraEnabled
		public String errorMessage {get;set;}
	}
}