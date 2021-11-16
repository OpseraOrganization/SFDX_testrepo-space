/**
About
-----
COE
Description: This Class is used to represent Emergency support object in support contact in the community.

Created for: Nokia Customer Portal
Created date: 21 11 2018

Update History
--------------
**/

public with sharing class JIVE_NCP_EmergencySupport_COM {

	@AuraEnabled
	public static List<NCP_EmergencySupport_Wrapper> getCountries() {

		List<NCP_EmergencySupport_Wrapper> resultCountries = new List<NCP_EmergencySupport_Wrapper>();
		set<String> countryFilter = new set<String>();

		for (NCP_EmergencySupport_Setting__c countries : [SELECT NCP_Country__c, NCP_Country_code__c FROM NCP_EmergencySupport_Setting__c WHERE NCP_Country__c != :NCP_Constants.COUNTRY_GLOBAL]) {

			if (countryFilter.add(countries.NCP_Country__c)) {
				NCP_EmergencySupport_Wrapper country = new NCP_EmergencySupport_Wrapper();
				country.value = countries.NCP_Country_code__c;
				country.label = countries.NCP_Country__c;
				resultCountries.add(country);
			}
		}
		return resultCountries;
	}

	@AuraEnabled
	public static List<NCP_EmergencySupport_Wrapper> getEmergencyGlobalSupport(String countryCode) {

		List<NCP_EmergencySupport_Wrapper> resultData = new List<NCP_EmergencySupport_Wrapper>();

		for (NCP_EmergencySupport_Setting__c globalSupport : [
				SELECT NCP_Contact_label__c, NCP_Contact_email_telephone__c
				FROM NCP_EmergencySupport_Setting__c
				WHERE (NCP_Country__c = :NCP_Constants.COUNTRY_GLOBAL AND NCP_IsEmail__c = TRUE)
				OR (NCP_Country__c = :countryCode
				AND NCP_Type__c = :NCP_Constants.TYPE_CARES
				AND NCP_IsEmail__c = TRUE)
		]) {
			NCP_EmergencySupport_Wrapper emailSupport = new NCP_EmergencySupport_Wrapper();
			emailSupport.contact_label = globalSupport.NCP_Contact_label__c;
			emailSupport.contact_email_telephone = globalSupport.NCP_Contact_email_telephone__c;
			resultData.add(emailSupport);
		}

		return resultData;
	}

	@AuraEnabled
	public static NCP_EmergencyContact_Wrapper getEmergencyContactSupport(String countryCode) {

		Boolean hasCaresSupport, hasNctSupport;
		if (NCP_Utils.isInternalUser()) {
			hasCaresSupport = hasNctSupport = true;
		} else {
			Set<String> userAccessSet = NCP_Entitlements.searchSelectedServices();
			hasCaresSupport = userAccessSet.contains(NCP_Constants.TYPE_CARES);
			hasNctSupport = userAccessSet.contains(NCP_Constants.HD_VALUE);
		}

		NCP_EmergencyContact_Wrapper emergencyContact = new NCP_EmergencyContact_Wrapper();
		if (hasCaresSupport && !hasNctSupport) {
			emergencyContact.CARES_TelephoneContact = getEmergencySupportByType(countryCode, NCP_Constants.TYPE_CARES);
			emergencyContact.CARES_EmailSupport = getEmergencyGlobalSupport(countryCode);
		} else if (!hasCaresSupport && hasNctSupport) {
			emergencyContact.NCT_TelephoneContact = getEmergencySupportByType(countryCode, NCP_Constants.NCT_VALUE);
		} else {
			emergencyContact.CARES_TelephoneContact = getEmergencySupportByType(countryCode, NCP_Constants.TYPE_CARES);
			emergencyContact.NCT_TelephoneContact = getEmergencySupportByType(countryCode, NCP_Constants.NCT_VALUE);
			emergencyContact.CARES_EmailSupport = getEmergencyGlobalSupport(countryCode);
		}

		return emergencyContact;
	}

	private static List<NCP_EmergencySupport_Wrapper> getEmergencySupportByType(String countryCode, String supportType) {

		List<NCP_EmergencySupport_Wrapper> resultData = new List<NCP_EmergencySupport_Wrapper>();

		for (NCP_EmergencySupport_Setting__c telSupport : [
				SELECT NCP_Contact_label__c, NCP_Contact_email_telephone__c
				FROM NCP_EmergencySupport_Setting__c
				WHERE NCP_Country_code__c = :countryCode
				AND NCP_Country__c != :NCP_Constants.COUNTRY_GLOBAL
				AND NCP_Type__c = :supportType
				AND NCP_IsPhone__c = TRUE
		]) {
			NCP_EmergencySupport_Wrapper emergencyTelSupport = new NCP_EmergencySupport_Wrapper();
			emergencyTelSupport.contact_label = telSupport.NCP_Contact_label__c;
			emergencyTelSupport.contact_email_telephone = telSupport.NCP_Contact_email_telephone__c;
			resultData.add(emergencyTelSupport);
		}

		return resultData;
	}

	@AuraEnabled
	public static user getUser() {
		return [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
	}

	// this does not look like it is being used
	// but if it is it should return the CountryCode and not the Country name
	// the function name should be correctly spelt too.
	@AuraEnabled
	public static String getDefaultCounry() {
		String country = [SELECT Country FROM User WHERE Id = :UserInfo.getUserId()].Country;
		return country;
	}

}