/****************************************
 * Class Name : PMDSoRAttributeMappingTest
 * Created Date: 01 Dec 2021
 * Created By : Standav
 * Last Modified by: 
 * Last Modified Date: 
 * Description : Test class for PMDSoRAttributeMapping Class
*****************************************/
@isTest
public with sharing class PMDSoRAttributeMappingTest {
	@isTest
	static void testClassvariables() {
		PMDSoRAttributeMapping.isIncentiveProduct('INCT Test');
		PMDSoRAttributeMapping.isIncentiveProduct('Test');
		PMDSoRAttributeMapping.isBundleProduct('Solution Model');
		PMDSoRAttributeMapping.isBundleProduct('Test');
		PMDSoRAttributeMapping.getBGMappingValue('IOF');
		PMDSoRAttributeMapping.getBGMappingValue('Test');
	}
}