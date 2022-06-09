/***
* Created By: Accenture IDC
* Created Date: 21/4/2017
*
* Modified By: Joao Rodrigues - COE Sales team - Portugal
* Modified Date: 11/12/2019
***/
public without sharing class CertificationRecords {
/**
* Description : Method to return the Certification records related to account.
* @param Id parentID 
* @return List
* @throws NA
**/
	@AuraEnabled	 
	public static  WrapperFull getCertificationsValuesforComponent(Id parentId)
	{
		Set<Id> partnersIds = new Set<Id>();
		Map<Id, String> partnersId2RoleMap = new Map<Id, String>();
		List<Certification__c> certificationsList = new List<Certification__c>();
		WrapperFull wrapperToSend = new WrapperFull();
		parentId = PRMhelper.getBpDetails(parentId);
		
		if(parentId != null)
		{
			try
			{
				partnersId2RoleMap = PRMHelper.getDistAndIR(parentId, true);
				partnersIds = PRMHelper.getSetFromMap(partnersId2RoleMap);
				partnersIds.add(parentId);
				List<User> userList = [Select Id, ContactId from User where Id = :UserInfo.getUserId() limit 1];
				if( !PRMHelper.checkAccountMemberRole(parentId))
				{
					certificationsList = [SELECT id,name,GPP_Certification_Name__c,Certification_Registration_Date__c,Certification_Expiration_Date__c,Name__r.Name,Technologies_Portfolio__c,Certification_Number__c,Certification_Status__c,Partner__r.Name, Job_Function__c,Certification_Name__c, partner__r.Partner_Type__c FROM Certification__c WHERE Partner__c IN:partnersIds AND Name__c =: userList[0].ContactId ORDER BY Partner__r.Name, Technologies_Portfolio__c limit :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
				}
				else
				{
					certificationsList = [SELECT id,name,GPP_Certification_Name__c,Certification_Registration_Date__c,Certification_Expiration_Date__c,Name__r.Name,Technologies_Portfolio__c,Certification_Number__c,Certification_Status__c,Partner__r.Name, Job_Function__c,Certification_Name__c, partner__r.Partner_Type__c FROM Certification__c WHERE Partner__c IN:partnersIds ORDER BY Partner__r.Name, Technologies_Portfolio__c limit :(Limits.getLimitQueryRows() - Limits.getQueryRows())];
				}
			}
			catch(Exception e)
			{
				ExceptionHandler.addException(e,GlobalConstants.CERTIF_RECORDS_CONTROLLER,GlobalConstants.GET_CERT_VALUES_METHOD);
			}
		}
		wrapperToSend.certificationWrapperList = getCertifWrapper(certificationsList, parentId);
		wrapperToSend.droplistValues = getUniqueValuesForFilters(certificationsList, parentId);
		
		return wrapperToSend;
	}
	
	private static List<WrapperCertification> getCertifWrapper (List<Certification__c> certificationList, Id parentId)
	{
		List<WrapperCertification> certificationWrapperList = new List<WrapperCertification>();
		for(Certification__C cert : certificationList)
		{
			//Create wrapper from Accreditation record
			WrapperCertification wrapCert = new WrapperCertification();
			wrapCert.id = cert.Id;
			wrapCert.partnerType = cert.partner__r.Partner_Type__c;
			wrapCert.partnerName = cert.partner__r.Name;
			wrapCert.partnerId = cert.partner__c;
			wrapCert.name = cert.Certification_Name__c;
			wrapCert.portfolio = cert.Technologies_Portfolio__c;
			wrapCert.jobFunction = cert.Job_Function__c;
			if(parentId == cert.partner__c)
			{
				wrapCert.contactName = cert.Name__r.Name;//Only shows contact name if the certificate is linked to the parent Account (where the component is beiong accessed)
			}
			wrapCert.certificationExpirationDate = cert.Certification_Expiration_Date__c;
			wrapCert.certificationRegistrationDate = cert.Certification_Registration_Date__c;
			wrapCert.certificationStatus = cert.Certification_Status__c;
			wrapCert.visible = true;
			certificationWrapperList.add(wrapCert);//Update filter droplist for portfolio
		}
		return certificationWrapperList;
	}
	
	//get unique values
	private static WrapperDroplistValues getUniqueValuesForFilters(List<Certification__c> certificationList, Id parentId)
	{
		Set<String> uniquePartnerValues = new Set<String>();
		Set<String> uniquePartnerTypeValues = new Set<String>();
		Set<String> uniquePortfolioValues = new Set<String>();
		Set<String> uniqueJobFunctionValues = new Set<String>();
		Set<String> uniqueStatusValues = new Set<String>();
		WrapperDroplistValues droplistValues = new WrapperDroplistValues();
		
		//Add default filter value (blank)
		uniquePartnerValues.add('');
		uniquePartnerTypeValues.add('');
		uniquePortfolioValues.add('');
		uniqueJobFunctionValues.add('');
		uniqueStatusValues.add('');
		
		for(Certification__c certif : certificationList)
		{
			uniquePartnerValues.add(certif.Partner__r.Name);
			uniquePartnerTypeValues.add(certif.Partner__r.Partner_Type__c);
			uniquePortfolioValues.add(certif.Technologies_Portfolio__c);
			uniqueJobFunctionValues.add(certif.Job_Function__c);
			uniqueStatusValues.add(certif.Certification_Status__c);
			if( certif.Partner__c == parentId )
			{
				droplistValues.defaultPartnerValue = certif.Partner__r.Name;
			}
		}
		droplistValues.partnerList = PRMHelper.orderSet(uniquePartnerValues);
		droplistValues.partnerTypeList = PRMHelper.orderSet(uniquePartnerTypeValues);  
		droplistValues.portfolioList = PRMHelper.orderSet(uniquePortfolioValues);
		droplistValues.jobFunctionList = PRMHelper.orderSet(uniqueJobFunctionValues);
		droplistValues.statusValuesList = PRMHelper.orderSet(uniqueStatusValues);	  
		return droplistValues;
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
		public String jobFunction {get;set;}
		@AuraEnabled
		public String contactName {get;set;}
		@AuraEnabled
		public Date certificationExpirationDate {get;set;} 
		@AuraEnabled
		public Date certificationRegistrationDate {get;set;}
		@AuraEnabled
		public String certificationStatus {get;set;}
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
		public Set<String> statusValuesList {get;set;}
		@AuraEnabled
		public Set<String> partnerTypeList {get;set;}
		@AuraEnabled
		public Set<String> jobFunctionList {get;set;}
		@AuraEnabled
		public String defaultPartnerValue {get;set;}
	}
	
	public class WrapperFull
	{ 
		@AuraEnabled
		public List<WrapperCertification> certificationWrapperList {get;set;} 
		@AuraEnabled
		public WrapperDroplistValues droplistValues {get;set;}
	}
}