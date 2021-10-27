/***
* Created By: Joao Rodrigues - COE Sales team - Portugal
* Created Date: 11/12/2019
***/
public without sharing class PartnerCompaniesRecords 
{
	/**
	* Description : Method to return the Partner Companies records related Distributor (all indirect resellers under Distributor).
	* @param Id parentID 
	* @return List
	* @throws NA
	**/
	@AuraEnabled
	public static WrapperFull getPartnerCompforComponent(Id parentId)
	{
		Set<Id> partnersIds = new Set<Id>();
		Map<Id, String> partnersId2RoleMap = new Map<Id, String>();
		List<Partner_Company__c> partnerCompanyList = new List<Partner_Company__c>();
		List<WrapperTerritories> territoriesList = new List<WrapperTerritories>();
		WrapperFull wrapperToSend = new WrapperFull();
		parentId = PRMHelper.getBpDetails(parentId);
		
		if(parentId != null)
		{
			try
			{
	partnersId2RoleMap = PRMHelper.getDistAndIR(parentId, false);//only has the indirect resellers records
				partnersIds = PRMHelper.getSetFromMap(partnersId2RoleMap);
				partnersIds.add(parentId);
	partnerCompanyList = [SELECT Id, Name, Market__c, Country_Headquarters__c, Partner_Name__c, Partner_Name__r.Partner_Type__c FROM Partner_Company__c WHERE Partner_Name__c IN :partnersIds order by Name limit :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
	//We can have several countries in the same record. We will generate a new row for each country assigned to a partner. 
	//If the same records holds more than one country, we will duplicate it 
	territoriesList = expandTerritoriesList(partnerCompanyList, partnersId2RoleMap);			
			}
			catch(Exception e){
	ExceptionHandler.addException(e,GlobalConstants.CERTIF_RECORDS_CONTROLLER ,GlobalConstants.GET_CERT_VALUES_METHOD);
			}
		}
		wrapperToSend.territoriesList = territoriesList;
		wrapperToSend.droplistValues = getUniqueValuesForFilters(territoriesList, parentId, partnersId2RoleMap);
		return wrapperToSend;
	}
	
	//Splits data by creating a new row when more than one country is assigned to the same partner in the same record (field Country__c having several countries splitted by ";")
	private static List<WrapperTerritories> expandTerritoriesList(List<Partner_Company__c> partnerCompanyList, Map<Id, String> partnersId2RoleMap)
	{
		List<WrapperTerritories> expandedTerritoriesList = new List<WrapperTerritories>();
		for(Partner_Company__c partnerCompany : partnerCompanyList)
		{
			if(partnerCompany.Country_Headquarters__c != null)
			{	
	List<WrapperTerritories> partnerTerritoriesList = new List<WrapperTerritories>();
	List<String> assignedCountries = partnerCompany.Country_Headquarters__c.split(';');
	for(String country : assignedCountries)
	{
		WrapperTerritories wrapperTerr = new WrapperTerritories();
		wrapperTerr.Id = partnerCompany.Id;
		wrapperTerr.partnerId = partnerCompany.Partner_Name__c;
		wrapperTerr.name = partnerCompany.Name;
		wrapperTerr.partnerType =  (partnersId2RoleMap.keyset().contains(partnerCompany.Partner_Name__c) ? partnersId2RoleMap.get(partnerCompany.Partner_Name__c) : partnerCompany.Partner_Name__r.Partner_Type__c);
		wrapperTerr.market = partnerCompany.Market__c;
		wrapperTerr.countryHeadquarters = country;
		wrapperTerr.Visible = true;
		partnerTerritoriesList.add(wrapperTerr);
	}
				System.debug(orderTerritoriesByCountry(partnerTerritoriesList));
				expandedTerritoriesList.addAll(orderTerritoriesByCountry(partnerTerritoriesList));
			}
			else
			{
	WrapperTerritories wrapperTerr = new WrapperTerritories();
	wrapperTerr.Id = partnerCompany.Id;
	wrapperTerr.partnerId = partnerCompany.Partner_Name__c;
	wrapperTerr.name = partnerCompany.Name;
	wrapperTerr.partnerType = (partnersId2RoleMap.keyset().contains(partnerCompany.Partner_Name__c) ? partnersId2RoleMap.get(partnerCompany.Partner_Name__c) : partnerCompany.Partner_Name__r.Partner_Type__c);
	wrapperTerr.market = partnerCompany.Market__c;
	wrapperTerr.countryHeadquarters = partnerCompany.Country_Headquarters__c;
	wrapperTerr.Visible = true;
	expandedTerritoriesList.add(wrapperTerr);
			}
		}
		return expandedTerritoriesList;
	}
	
	//get unique values
	private static WrapperDroplistValues getUniqueValuesForFilters(List<WrapperTerritories> territList, Id parentId, Map<Id, String> partnersId2RoleMap)
	{
		Set<String> uniquePartnerValues = new Set<String>();
		Set<String> uniqueMarketValues = new Set<String>();
		Set<String> uniqueCountryValues = new Set<String>();
		Set<String> uniquePartnerTypeValues = new Set<String>();
		WrapperDroplistValues droplistValues = new WrapperDroplistValues();
		
		//Add default filter value (blank)
		uniquePartnerValues.add('');
		uniqueMarketValues.add('');
		uniqueCountryValues.add('');
		uniquePartnerTypeValues.add('');
		
		for(WrapperTerritories partner : territList)
		{		
			uniquePartnerValues.add(partner.Name);
			uniqueMarketValues.add(partner.Market);
			uniqueCountryValues.add(partner.countryHeadquarters);
			uniquePartnerTypeValues.add(partner.partnerType);
			if( partner.partnerId == parentId )
			{
	droplistValues.defaultPartnerValue = partner.partnerType;
			}
		}
		droplistValues.partnerList = PRMHelper.orderSet(uniquePartnerValues);
		droplistValues.marketList = PRMHelper.orderSet(uniqueMarketValues);
		droplistValues.countryList = PRMHelper.orderSet(uniqueCountryValues);
		droplistValues.partnerTypeList = PRMHelper.orderSet(uniquePartnerTypeValues);		
		return droplistValues;
	}
	
	private static List<WrapperTerritories> orderTerritoriesByCountry(List<WrapperTerritories> terrWrapperList)
	{
		Map<String,List<WrapperTerritories>> countryTerrMap = new Map<String,List<WrapperTerritories>>();
		List<WrapperTerritories> sortedTerrWrapList = new List<WrapperTerritories>();
		
		for (WrapperTerritories terrWrap: terrWrapperList)//Create MAP having countryHeadquarters as keys
		{
			List<WrapperTerritories> sameTerrList = new List<WrapperTerritories>();
			if(countryTerrMap.get(terrWrap.countryHeadquarters) == null)
			{
	sameTerrList.add(terrWrap);
			}
			else
			{
	sameTerrList = countryTerrMap.get(terrWrap.countryHeadquarters);
	sameTerrList.add(terrWrap);
			}
			countryTerrMap.put(terrWrap.countryHeadquarters, sameTerrList);
		}

		for (String key : countryTerrMap.keySet())
		{
			sortedTerrWrapList.addAll(countryTerrMap.get(key));
		}
		return sortedTerrWrapList;
	}
	
	public class WrapperTerritories
	{ 
		@AuraEnabled
		public String name {get;set;} 
		@AuraEnabled
		public String market {get;set;}
		@AuraEnabled
		public String countryHeadquarters {get;set;}
		@AuraEnabled
		public String partnerId {get;set;}
		@AuraEnabled
		public String Id {get;set;}
		@AuraEnabled
		public String partnerType {get;set;}
		@AuraEnabled
		public Boolean visible {get;set;}
	}   
	
	public class WrapperDroplistValues
	{ 
		@AuraEnabled
		public Set<String> partnerList {get;set;}
		@AuraEnabled
		public Set<String> marketList {get;set;}
		@AuraEnabled
		public Set<String> countryList {get;set;}
		@AuraEnabled
		public Set<String> partnerTypeList {get;set;}
		@AuraEnabled
		public String defaultPartnerValue {get;set;}
	}
	
	public class WrapperFull
	{
		@AuraEnabled
		public List<WrapperTerritories> territoriesList {get;set;} 
		@AuraEnabled
		public WrapperDroplistValues droplistValues {get;set;}
	}
}