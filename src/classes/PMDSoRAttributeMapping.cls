/****************************************
 * Name : PMDSoRAttributeMapping
 * Author : Standav
 * Description : This class stores the mapping between pmdsor attributes and product2 attributes
****************************************/
public with sharing class PMDSoRAttributeMapping {
	
	//Secondary Category Mapping - Staging to Product2 (NSN_Secondary_Category__c to CPQ_Secondary_Category__c)
	public static final Map<String, String> secondaryCategoryValueMapping = new Map<String, String>{
		'INCENTIVE' => 'Incentive',
		'SITE MODEL' => 'Site Model',
		'SOLUTION' => 'Solution Model',
		'TRANSPORTATION' => 'Transportation'
	};

	//Business Group Mapping - Staging to Product2 (NSN_Secondary_Category__c to CPQ_Secondary_Category__c)
	public static final Map<String, String> bgValueMapping = new Map<String, String>{
		'IOF' => 'NI'
	};

	//mapping util methods

	//method to identify Incentive products
	public static Boolean isIncentiveProduct(String secondaryCategory) {
		if(String.isNotBlank(secondaryCategory) && secondaryCategory.startsWithIgnoreCase('INCT')) {
			return true;
		} else {
			return false;
		}
	}

	//method to identify Bundle products
	public static Boolean isBundleProduct(String secondaryCategory) {
		if(String.isNotBlank(secondaryCategory) && (secondaryCategory.equalsIgnoreCase('Solution Model') || secondaryCategory.equalsIgnoreCase('Site Model'))) {
			return true;
		}
		return false;
	}

	//method to transform the BG values
	public static String getBGMappingValue(String bg) {
		if(String.isNotBlank(bg) && bgValueMapping.containsKey(bg)) {
			return bgValueMapping.get(bg);
		} else {
			return bg;
		}
	}

}