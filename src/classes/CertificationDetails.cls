/***
* Created By: Accenture IDC
* Created Date: 21/3/2017
*
* Modified By: Joao Rodrigues - COE Sales team - Portugal
* Modified Date: 11/12/2019
* Modified By: Christie JJ - Standav/Brillio ext team
* Modified Date: 03/17/2022
***/
public without sharing class CertificationDetails
{ 
	
	/**
	* Description : Method to return the BP record, If Request is coming from Business Plan object
	* @param Id BP recordId  
	* @return BP record
	* @throws NA
	**/
	@AuraEnabled(cacheable=true)
	public static Business_Plan__c getAccountId(Id recordId){
		return [SELECT Id, Account_BP__c FROM Business_Plan__c WHERE Id =: recordId LIMIT 1];
	}
	
	/**
	* Description : Method to return the Account Id, If Request is coming from Business Plan object
	* @param Id parentID 
	* @return iD
	* @throws NA
	**/
	
	@AuraEnabled(cacheable=true)
	public static WrapperFull getCertifAndAccredforComponent(Id parentId)
	{
		//Wrapper to send to component
		WrapperFull wrapperToSend = new WrapperFull();
		//Query filter
		Set<Id> partnersIds = new Set<Id>();
		Map<Id, String> partnersId2RoleMap = new Map<Id, String>();
		//Accreditaions and Certification lists do display on Component
		List<WrapperAccreditation> accreditationWrapperList = new List<WrapperAccreditation>();
		List<WrapperCertification> certificationWrapperList = new List<WrapperCertification>();
		//Droplist values to show on component
		Set<String> uniquePartnerList = new Set<String>();
		Set<String> uniquePartnerTypeList = new Set<String>();
		Set<String> uniqueAccLevelList = new Set<String>();
		Set<String> uniquePortfolioList = new Set<String>();
		Set<String> uniqueMarketValuesList = new Set<String>();
		String defaultPartnerTypeValue = '';
		uniquePartnerList.add('');
		uniquePartnerTypeList.add('');
		uniqueAccLevelList.add('');
		uniquePortfolioList.add('');
		uniqueMarketValuesList.add('');
		
		//Get partners and parent Ids
		parentId = PRMHelper.getBpDetails(parentId);
		partnersId2RoleMap = PRMHelper.getDistAndIR(parentId, false);
		partnersIds = PRMHelper.getSetFromMap(partnersId2RoleMap);
		partnersIds.add(parentId);
		
		//Get Certifications and Accreditations linked to distributor and its indirect reseller partners
		List<Account> partnersList = [SELECT 
	 Id, Name, Partner_Type__c,
	 //(SELECT id, name, Accreditation_Level__c, Portfolio__c, Accreditation_Date__c, Accreditation_Type__c, Market__c FROM Accreditations__r ORDER BY Portfolio__c, Accreditation_Type__c, Accreditation_Level__c), 
	 //Modified for ITCCPQ-3054 by Christie JJ
	 (SELECT id, name, Accreditation_Level__c, tolabel(Portfolio__c), Accreditation_Date__c, Accreditation_Type__c, Market__c FROM Accreditations__r ORDER BY Portfolio__c, Accreditation_Type__c, Accreditation_Level__c), 
	 (SELECT id, name, GPP_Certification_Name__c, Certification_Registration_Date__c, Certification_Expiration_Date__c, Technologies_Portfolio__c, Certification_Number__c, Certification_Status__c FROM Certifications__r ORDER BY Technologies_Portfolio__c, Certification_Status__c ) 
	 FROM Account
	 Where Id IN :partnersIds ORDER BY Name limit :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
	
		//Include parent partner business role into roles map 
		for(Account p :  partnersList)
		{
			if(p.Id == parentId)
			{
	partnersId2RoleMap.put(parentId, p.Partner_Type__c);//Add role / business role from parent record do the parter Map
	break;
			}
		}
		
		//Set Certification and Accreditations wrapers to send, as well droplist values.
		for(Account partner : partnersList)
		{
			for(Certification__C cert : partner.certifications__r)
			{
	//Create wrapper from Accreditation record
	WrapperCertification wrapCert = new WrapperCertification();
	wrapCert.id = cert.Id;
	wrapCert.partnerType = partnersId2RoleMap.get(partner.Id);
	wrapCert.partnerName = partner.Name;
	wrapCert.partnerId = partner.Id;
	wrapCert.name = cert.name;
	wrapCert.portfolio = cert.Technologies_Portfolio__c;
	wrapCert.gppCertificationName = cert.GPP_Certification_Name__c;
	wrapCert.certificationExpirationDate = cert.Certification_Expiration_Date__c;
	wrapCert.certificationRegistrationDate = cert.Certification_Registration_Date__c;
	wrapCert.certificationStatus = cert.Certification_Status__c;
	wrapCert.visible = true;
	certificationWrapperList.add(wrapCert);//Update filter droplist for portfolio
	
	//Update droplist values
	uniquePortfolioList.add(cert.Technologies_Portfolio__c);
			}
			
			for(Accreditation__c accred : partner.accreditations__r)
			{
	//Create wrapper from Accreditation record
	WrapperAccreditation wrapAcc = new WrapperAccreditation();
	wrapAcc.id = accred.Id;
	wrapAcc.partnerId = partner.Id;
	wrapAcc.partnerType = (partnersId2RoleMap.keyset().contains(partner.Id) ? partnersId2RoleMap.get(partner.Id) : partner.Partner_Type__c);
	wrapAcc.partnerName = partner.Name;
	wrapAcc.portfolio = accred.Portfolio__c;
	wrapAcc.market = accred.Market__c;
	wrapAcc.accreditationType = accred.Accreditation_Type__c;
	wrapAcc.accreditationLevel = accred.Accreditation_Level__c;
	wrapAcc.accreditationDate = accred.Accreditation_Date__c;
	wrapAcc.visible = true;
	accreditationWrapperList.add(wrapAcc);//Update filter droplist for portfolio
	
	//Update droplist values
	uniquePortfolioList.add(accred.Portfolio__c);
	uniqueAccLevelList.add(accred.Accreditation_Level__c);
	uniqueMarketValuesList.add(accred.Market__c);
			}
			
			//Update more droplist values
			uniquePartnerList.add(partner.Name);//Update filter droplist for Partners
			uniquePartnerTypeList.add((partnersId2RoleMap.keyset().contains(partner.Id) ? partnersId2RoleMap.get(partner.Id) : partner.Partner_Type__c) );//Update filter droplist for Partner Type
			if( partner.Id == parentId )
			{
	defaultPartnerTypeValue= partner.Partner_Type__c;//Set default value for partner type
			}
		}
		wrapperToSend.accreditationWrapper = accreditationWrapperList;
		wrapperToSend.certificationWrapper = orderCertifByPortfolio(certificationWrapperList);
		wrapperToSend.certificationCounterWrapper = getCertifCounterWrapper(parentId, '', '', '');
		
		wrapperToSend.droplistValues = new WrapperDroplistValues();
		wrapperToSend.droplistValues.partnerTypeList = PRMHelper.orderSet(uniquePartnerTypeList);
		wrapperToSend.droplistValues.partnerList = PRMHelper.orderSet(uniquePartnerList);
		wrapperToSend.droplistValues.portfolioList = PRMHelper.orderSet(uniquePortfolioList);
		wrapperToSend.droplistValues.marketValuesList = PRMHelper.orderSet(uniqueMarketValuesList);
		wrapperToSend.droplistValues.accrLevelList = PRMHelper.orderSet(uniqueAccLevelList);
		wrapperToSend.droplistValues.defaultPartnerTypeValue = defaultPartnerTypeValue;
		
		return wrapperToSend;
	}
	
	/**
	* Description : Method to create records of wrapper class
	* @param Id parentID
	* @return List
	* @throws NA
	**/ 
	@AuraEnabled(cacheable = true)
	public static List<WrapperCertCounters> getCertifCounterWrapper(Id parentId, String partnerFilter, String partnerTypeFilter, String portfolioFilter)
	{
		Map<String,WrapperCertCounters> mapWrap=new Map<String,WrapperCertCounters>();
		try
		{
			//Add partner that are indirect resellers if they exist.
			Set<Id> partnersIds = new Set<Id>();
			Map<Id, String> partnersId2RoleMap  = new Map<Id, String>();
			
			//Get partners and parent Ids
			parentId = PRMHelper.getBpDetails(parentId);
			partnersId2RoleMap = PRMHelper.getDistAndIR(parentId, false);
			partnersIds = PRMHelper.getSetFromMap(partnersId2RoleMap);
			partnersIds.add(parentId);
	  
			String queryForCert = generateCounterSQLquery(parentId, partnersIds, partnerFilter, partnerTypeFilter, portfolioFilter);
			System.debug('SOQL query for cert counters: ' + queryForCert);

			if(queryForCert != null)
			{
	List<AggregateResult> certificationsList = Database.query(queryForCert);
	 
	//Iterate Certificates
	for(AggregateResult ins : certificationsList)
	{
		WrapperCertCounters insWrap=new WrapperCertCounters();
		if(!mapWrap.containskey((String)ins.get(GlobalConstants.PORTFOLIO_APINAME)+GlobalConstants.HYPHEN+(String)ins.get(GlobalConstants.GPP_CERTIFICATION_APINAME)))
		{
			insWrap.Name=(String)ins.get(GlobalConstants.GPP_CERTIFICATION_APINAME );
			insWrap.port=(String)ins.get(GlobalConstants.PORTFOLIO_APINAME);
			if(((String)ins.get(GlobalConstants.CERTIF_STATUS_APINAME)).equalsIgnoreCase(GlobalConstants.CERTIF_STATUS_INPROGRESS))
			{
	insWrap.Inp = (Integer)ins.get(GlobalConstants.COUNT);
	insWrap.Comp = 0;
	insWrap.Reg = 0;
	insWrap.App = 0;
			}
			if(((String)ins.get(GlobalConstants.CERTIF_STATUS_APINAME)).equalsIgnoreCase(GlobalConstants.CERTIF_STATUS_COMPLETED))
			{
	insWrap.Comp = (Integer)ins.get(GlobalConstants.COUNT);
	insWrap.Inp = 0;
	insWrap.Reg = 0;
	insWrap.App = 0;
			}
			if(((String)ins.get(GlobalConstants.CERTIF_STATUS_APINAME)).equalsIgnoreCase(GlobalConstants.CERTIF_STATUS_REGISTERED))
			{
	insWrap.Reg = (Integer)ins.get(GlobalConstants.COUNT);
	insWrap.Comp = 0;
	insWrap.Inp = 0;
	insWrap.App = 0;
			}
			if(((String)ins.get(GlobalConstants.CERTIF_STATUS_APINAME)).equalsIgnoreCase(GlobalConstants.CERTIF_STATUS_APPROVED))
			{
	insWrap.App = (Integer)ins.get(GlobalConstants.COUNT);
	insWrap.Comp = 0;
	insWrap.Reg = 0;
	insWrap.Inp = 0;
			}
			
			mapWrap.put((String)ins.get(GlobalConstants.PORTFOLIO_APINAME)+GlobalConstants.HYPHEN+(String)ins.get(GlobalConstants.GPP_CERTIFICATION_APINAME),insWrap); 
		}
		else
		{
			WrapperCertCounters wrapRec= mapWrap.get((String)ins.get(GlobalConstants.PORTFOLIO_APINAME)+GlobalConstants.HYPHEN+(String)ins.get(GlobalConstants.GPP_CERTIFICATION_APINAME ));
			if(((String)ins.get(GlobalConstants.CERTIF_STATUS_APINAME)).equalsIgnoreCase(GlobalConstants.CERTIF_STATUS_INPROGRESS))
			{
	wrapRec.Inp = (Integer)ins.get(GlobalConstants.COUNT);
			}
			if(((String)ins.get(GlobalConstants.CERTIF_STATUS_APINAME)).equalsIgnoreCase(GlobalConstants.CERTIF_STATUS_COMPLETED))
			{
	wrapRec.Comp = (Integer)ins.get(GlobalConstants.COUNT);
			}
			if(((String)ins.get(GlobalConstants.CERTIF_STATUS_APINAME)).equalsIgnoreCase(GlobalConstants.CERTIF_STATUS_REGISTERED))
			{
	wrapRec.Reg = (Integer)ins.get(GlobalConstants.COUNT);
			}
			if(((String)ins.get(GlobalConstants.CERTIF_STATUS_APINAME)).equalsIgnoreCase(GlobalConstants.CERTIF_STATUS_APPROVED))
			{
	wrapRec.App = (Integer)ins.get(GlobalConstants.COUNT);
			}
		}	 
	}   
			}
		}
		catch(Exception e)
		{
			ExceptionHandler.addException(e,GlobalConstants.CERTIF_DETAIL_CONTROLLER ,PRMGlobalConstants.GET_Wrapper);
		}
		return new List<WrapperCertCounters>(mapWrap.values());
	}
	
	private static String generateCounterSQLquery(Id parentId, Set<Id> partnersIds, String partnerFilter, String partnerTypeFilter, String portfolioFilter)
	{
		String queryForCert;
		if(partnersIds.size() == 0)
		{
			queryForCert = null;
		}
		else
		{
			queryForCert = 'SELECT GPP_Certification_Name__c, count(Name__c) mycount,certification_status__c,port__c  FROM Certification__c WHERE Partner__c in (';
			
			//Filter by partner type here.
			for(Id partnerId : partnersIds)
			{
	//Filter some Ids out due to partner Type filtering 
	if( partnersIds.size() == 1 || partnerTypeFilter.equals('') )//Only one partner in the list to show certif and accred. This means that this is the parent account (record in context), so it should appear
	{
		queryForCert += '\'' + String.valueOf(partnerId) + '\',';
	}
	else if( (partnersIds.size() > 1) && !partnerId.equals(parentId) )//This means that partner is not the distributor. If it was the indirect reseller only one partner Id should be present.
	{
		if(!partnerTypeFilter.equals(GlobalConstants.PARTNER_TYPE_DISTR))
		{
			queryForCert += '\'' + String.valueOf(partnerId) + '\',';
		}
	}
	else if( (partnersIds.size() > 1) && partnerId.equals(parentId) )//This means that partner is account in context
	{
		if(partnerTypeFilter.equals(GlobalConstants.PARTNER_TYPE_DISTR))
		{
			queryForCert += '\'' + String.valueOf(partnerId) + '\',';
		}
	}
			}
			queryForCert = queryForCert.removeEnd(',');
			queryForCert += ') AND certification_status__c in (\'' + GlobalConstants.CERTIF_STATUS_INPROGRESS + '\',\'' + GlobalConstants.CERTIF_STATUS_COMPLETED +'\',\'' + GlobalConstants.CERTIF_STATUS_REGISTERED +'\',\'' + GlobalConstants.CERTIF_STATUS_APPROVED +'\')';
			if(partnerFilter != '' && partnerFilter != null)
			{
	queryForCert += ' AND Partner__r.Name = \'' + partnerFilter + '\'';
			}
			if(portfolioFilter != '' && portfolioFilter != null)
			{
	queryForCert += ' AND port__c = \'' + portfolioFilter + '\'';
			}
			queryForCert += ' GROUP BY certification_status__c,port__c,GPP_Certification_Name__c order by port__c LIMIT ' + limits.getLimitQueryRows();
		}
		System.debug('JOTATR');
		System.debug(queryForCert);
		return queryForCert;
	}
	
	private static List<WrapperCertification> orderCertifByPortfolio(List<WrapperCertification> certifWrapperList)
	{
		Map<String,List<WrapperCertification>> portfolioCertifMap = new Map<String,List<WrapperCertification>>();
		List<WrapperCertification> sortedCertifWrapList = new List<WrapperCertification>();
		
		for (WrapperCertification certifWrap: certifWrapperList)//Create MAP having portfolio as keys
		{
			List<WrapperCertification> samePortfolioList = new List<WrapperCertification>();
			if(portfolioCertifMap.get(certifWrap.portfolio) == null)
			{
	samePortfolioList.add(certifWrap); 
			}
			else
			{
	samePortfolioList = portfolioCertifMap.get(certifWrap.portfolio);
	samePortfolioList.add(certifWrap);
			}
			portfolioCertifMap.put(certifWrap.portfolio, samePortfolioList);
		}

		for (String key : portfolioCertifMap.keySet())
		{
			sortedCertifWrapList.addAll(portfolioCertifMap.get(key));
		}
		return sortedCertifWrapList;
	}
		
	/**
	* Description : Wrapper class created which is used above to create records.
	* @properties: String
	**/ 
	//Certification
	public class WrapperCertCounters
	{ 
		@AuraEnabled
		public String port{get;set;} 
		@AuraEnabled
		public String Name{get;set;}
		@AuraEnabled
		public Integer Inp{get;set;}
		@AuraEnabled
		public Integer Comp{get;set;}
		@AuraEnabled
		public Integer Reg{get;set;}
		@AuraEnabled
		public Integer App{get;set;}
	}
	
	//Certification Wrapper
	public class WrapperCertification
	{ 
		@AuraEnabled
		public String id {get;set;}   
		@AuraEnabled
		public String partnerId {get;set;}   
		@AuraEnabled
		public String partnerType {get;set;}
		@AuraEnabled
		public String partnerName {get;set;}
		@AuraEnabled
		public String name {get;set;}
		@AuraEnabled
		public String portfolio {get;set;}
		@AuraEnabled
		public String gppCertificationName {get;set;}
		@AuraEnabled
		public Date certificationExpirationDate {get;set;} 
		@AuraEnabled
		public Date certificationRegistrationDate {get;set;}
		@AuraEnabled
		public String certificationStatus {get;set;}
		@AuraEnabled
		public Boolean visible {get;set;}
	}

	//Accreditaion Wrapper
	public class WrapperAccreditation
	{ 
		@AuraEnabled
		public String id {get;set;}
		@AuraEnabled
		public String partnerId {get;set;}
		@AuraEnabled
		public String partnerType {get;set;}
		@AuraEnabled
		public String partnerName {get;set;}
		@AuraEnabled
		public String name {get;set;}
		@AuraEnabled
		public String portfolio {get;set;}
		@AuraEnabled
		public String market {get;set;}
		@AuraEnabled
		public String accreditationType {get;set;} 
		@AuraEnabled
		public String accreditationLevel {get;set;}
		@AuraEnabled
		public Date accreditationDate {get;set;}
		@AuraEnabled
		public Boolean visible {get;set;}
	}   
	
	public class WrapperDroplistValues
	{ 
		@AuraEnabled
		public Set<String> partnerList {get;set;}
		@AuraEnabled
		public Set<String> portfolioList {get;set;}
		@AuraEnabled
		public Set<String> marketValuesList {get;set;}
		@AuraEnabled
		public Set<String> partnerTypeList {get;set;}
		@AuraEnabled
		public Set<String> accrLevelList {get;set;}
		@AuraEnabled
		public String defaultPartnerTypeValue {get;set;}
	}
	
	public class WrapperFull
	{
		@AuraEnabled
		public List<WrapperAccreditation> accreditationWrapper {get;set;} 
		@AuraEnabled
		public List<WrapperCertification> certificationWrapper {get;set;} 
		@AuraEnabled
		public List<WrapperCertCounters> certificationCounterWrapper {get;set;} 
		@AuraEnabled
		public WrapperDroplistValues droplistValues {get;set;}
	}
}