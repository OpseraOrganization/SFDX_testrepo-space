/****************************************
*Class Name : OIFGrid
*Created Date: 6th March 2017
*Created By : Accenture
*Last Modified by: Accenture
*Last Modified Date:  
*Description : Get the ID from  Grid and return the Grid lock value
*Test Class: OIFGridTest
*****************************************/

public with sharing class OIFGrid
{
	
	Public Static Opportunity Oppdata;
	String recordTypeName = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.PREOPPTY_RECORD_TYPE).getRecordTypeId();
		
	/*******************************
*Method name: getOIFByOpportunityId
*Description: Get the Opportunity ID and return the Values
*Parameter:List<Id> Ids
*******************************/
	@AuraEnabled
	public static Wrapper getOIFByOpportunityId(Id oppid)
	{	
		Wrapper wrp = new Wrapper();
		// retriving the opportunity information
		Oppdata=[select id,name,Grid_Buddy_Closed__c,Opportunity_Lock__c, recordTypeId from Opportunity where id=:oppid LIMIT 1]; 
		wrp.oppData = Oppdata;
		Id preOppRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(GlobalConstants.PREOPPTY_RECORD_TYPE).getRecordTypeId();
		if(Oppdata.RecordTypeId ==  preOppRecId)
		{
			wrp.isPreOpp = true;	
		}
		else
		{
			wrp.isPreOpp = false;
		}
		return wrp;
	}
	
	/*******************************
*Method name: getUrlInfo
*Description: Return the URL path 
*Parameter: 
*******************************/
	@AuraEnabled
	public static String getUrlInfo()
	{
		String Name=System.label.Grid_URL_Path;
		return Name;
	}
	
	/*******************************
*Method name: getopplock
*Description: Return the Opportunity lock Information
*Parameter: ID
*******************************/
	@AuraEnabled
	public static Integer getopplock(Id oppid) 
	{
		Integer Lock;
		// retriving the opportunity information
		List<Opportunity> lockrecords=[select id,name,Opportunity_Lock__c from Opportunity where id=:oppid LIMIT 1];
		for(Opportunity Opplist:lockrecords)
		{
			Lock=(Integer)Opplist.Opportunity_Lock__c;   
		}
		return Lock;
	}
	
	public class Wrapper
	{
		@AuraEnabled
		public Opportunity oppData {get;set;}
		@AuraEnabled
		public Boolean isPreOpp {get;set;} 
	}
}