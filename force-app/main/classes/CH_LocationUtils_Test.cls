/** 
* About 
* ----- 
* @Description	  : Case Handling Location Utils Test Class.
* @Project	: Case Handling.
* @Modification Log : 
*  Created  : 2020 02 07 – tiago.almeida@nokia.com
* ----- 
**/
@isTest
public class CH_LocationUtils_Test {
	public static testMethod void test() {
		String country = 'Portugal';
		String city = 'Almada';
		ISO_Country_Codes__c oISOCountryCode = new ISO_Country_Codes__c(
			Name = country,
			Country_Name__c = country,
			Multi_Timezone__c = true
		);
		insert oISOCountryCode;
		test.startTest();
		Boolean result = CH_LocationUtils.countryIsMultiTimezone(country); 
		System.assertEquals(result, true);	  
		try {
			CH_LocationUtils.countryIsMultiTimezone(null); 
		} catch(Exception e) { }	 
		try {
			CH_LocationUtils.getCoordinates('', city, '', '', country); 
		} catch(Exception e) { }		
		try {
			CH_LocationUtils.getTimeZone(new Map<String, Object>{'lat' => 38.6412592, 'lng' => -9.186883});
		} catch(Exception e) { } 
		test.stopTest();
	}
}