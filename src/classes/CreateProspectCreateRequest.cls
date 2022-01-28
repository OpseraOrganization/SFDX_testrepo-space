/****************************************
 * Class Name : CreateProspectCreateRequest
 * Created Date: 28 September 2017
 * Created By : Accenture
 * Last Modified by: Accenture
 * Last Modified Date: 28 September 2017
 * Description : Create Prospect Creation request for SOAP webservice available on EAI 
 * Test Class: 
 *****************************************/
public class CreateProspectCreateRequest{
	
	public String SFDCID;
	public String accountName; 
	public String companyType;
	public String businessPartnerRole;
	public String accountLifeCycleStatus;
	public String market; 
	public String salesHierarchy;
	public String streetLine;
	public String postalCode;
	public String city;	
	public String stateProvince;
	public String countryISO2;
	public String accountOwnerEmail; 
	public String accountOwnerNOKIAID;
	public String marketSegment;
	public String activitySectorName;
	public String customerCompliance;
	public String website;
	public String remarks;
	public String cRMOMStatus; 
	
	 /********************
	*Method Name: CreateProspectCreateRequest
	*Parameter: AccountId 
	*Description:Constructor to initialize all member variables
	*******************/
	public CreateProspectCreateRequest(string accountId){
		 Account acc = [select Id,name,
								BusinessPartnerRole__c,
								Customer_Compliance__c,
								website,
								CBT_CT_Code__c,
								billingStreet,
								billingpostalcode,
								billingcity,
								billingStateCode,
								billingCountryCode,
								owner.email,
								owner.nokia_Id__c,
								Activity_Sector_Name__c,
								Notes__c,
								market__c
								from account where Id =: accountId limit 1];
		if((!String.isBlank(acc.name)) && acc.name.length()>35)
			accountName = acc.name.substring(0,35);
		else
			accountName = acc.name;
		
		if((!String.isBlank(acc.website)) && acc.website.length()>60)
			website = acc.website.substring(0,60);
		else
			website = acc.website;
		
		if((!String.isBlank(acc.billingStreet)) && acc.billingStreet.length()>35)
			streetLine = acc.billingStreet.substring(0,35);
		else
			streetLine = acc.billingStreet;
		
		if((!String.isBlank(acc.billingpostalcode)) && acc.billingpostalcode.length()>10)
			postalCode = acc.billingpostalcode.substring(0,10);
		else
			postalCode = acc.billingpostalcode;
		
		if((!String.isBlank(acc.billingcity)) && acc.billingcity.length()>35)
			city = acc.billingcity.substring(0,35);	
		else
			city = acc.billingcity;
		
		SFDCID = accountId;
		companyType ='PROSPECT';
		customerCompliance = acc.Customer_Compliance__c;
		
		
		countryISO2 = acc.billingCountryCode;
		
		if(ISOStateCodes__c.getValues(countryISO2+'-'+acc.billingStateCode)!=NULL)
			stateProvince = ISOStateCodes__c.getValues(countryISO2+'-'+acc.billingStateCode).StateCode__c;
		else
			stateProvince = NULL;
			
		accountOwnerEmail = acc.owner.email; 
		accountOwnerNOKIAID = acc.owner.nokia_Id__c;
		activitySectorName = acc.Activity_Sector_Name__c;
		remarks =acc.Notes__c;
		
		businessPartnerRole = acc.BusinessPartnerRole__c;
	   
		if(businessPartnerRole == 'End Customer'){
		   acc.CBT_CT_Code__c = End_Customer_CBT_CT_Code__c.getValues(acc.Market__c).CBT_CT_Code__c;
		}
		salesHierarchy = acc.CBT_CT_Code__c;
		
	}
	
	 /********************
	*Method Name: createRequest
	*Parameter: 
	*Description: Create a SOAP envelop xml to send data to EAI
	*******************/
	public DOM.Document createRequest(){
		DOM.Document doc = new DOM.Document();
		
		String soapNS = 'http://schemas.xmlsoap.org/soap/envelope/';
		String xsd = 'http://www.w3.org/2001/XMLSchema';
		String xsi='http://www.w3.org/2001/XMLSchema-instance';
		
		String endpoint = 'http://nsn.com/scmd/createProspectSFStartProcess/';
		
		dom.XmlNode envelope
		= doc.createRootElement('Envelope', soapNS, 'env');
		envelope.setNamespace('xsd', xsd);
		envelope.setNamespace('xsi', xsi);
		
		envelope.addChildElement('Header', soapNS, null); 
		dom.XmlNode body
		= envelope.addChildElement('Body', soapNS, null);
		
		dom.XmlNode prospectData = body.addChildElement('StartProcess', endpoint, 'm');
		
		prospectData.addChildElement('legalNameLine1', null, null).addTextNode(String.isBlank(accountName)?'':accountName );
		prospectData.addChildElement('customerCompliance', null, null).addTextNode(String.isBlank(customerCompliance)?'':customerCompliance );
		prospectData.addChildElement('website', null, null).addTextNode(String.isBlank(website)?'':website );
		prospectData.addChildElement('salesHierarchy', null, null).addTextNode(String.isBlank(salesHierarchy)?'':salesHierarchy );
		prospectData.addChildElement('businessPartnerRole', null, null).addTextNode(String.isBlank(businessPartnerRole)?'':businessPartnerRole );
		prospectData.addChildElement('streetLine1', null, null).addTextNode(String.isBlank(streetLine)?'':streetLine );
		prospectData.addChildElement('city', null, null).addTextNode(String.isBlank(city)?'':city);
		prospectData.addChildElement('accntUserNokiaId', null, null).addTextNode(String.isBlank(accountOwnerNOKIAID)?'':accountOwnerNOKIAID );
		prospectData.addChildElement('SWFID', null, null).addTextNode(String.isBlank(SFDCID)?'':SFDCID);
		prospectData.addChildElement('activitySectorName', null, null).addTextNode(String.isBlank(activitySectorName)?'':activitySectorName);
		prospectData.addChildElement('stateProvinceCountry', null, null).addTextNode(String.isBlank(stateProvince)?'':stateProvince);
		prospectData.addChildElement('country', null, null).addTextNode(String.isBlank(countryISO2)?'':countryISO2);
		prospectData.addChildElement('companyType', null, null).addTextNode('PROSPECT');
		prospectData.addChildElement('postalCode', null, null).addTextNode(String.isBlank(postalCode)?'':postalCode);
		prospectData.addChildElement('remarks', null, null).addTextNode(String.isBlank(remarks)?'':remarks);
		prospectData.addChildElement('accntOwnerEmailId', null, null).addTextNode(String.isBlank(accountOwnerEmail)?'':accountOwnerEmail);
		
		System.debug(doc.toXmlString());
		
		return doc;

	}
}