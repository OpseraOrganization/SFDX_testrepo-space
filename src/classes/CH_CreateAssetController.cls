/*
* Class Name : CH_CreateAssetController
* Created Date: 11 Nov 2019
* Created By : 
* Last Modified by: 
* Last Modified Date: 
* Description : Asset creation button action and visibility 
*/
public with sharing class CH_CreateAssetController {
	/********************
	* Method Name: checkFieldAccess
	* Parameter: String sObjectName, Map < String, String > fieldMap
	* Description: Used to check access of fields with provided access level
	* Reference: NOKIASC-15495/15083
	*******************/
	public static Map < String, String > checkFieldAccess(String sObjectName, Map < String, String > fieldMap) {
		Map < String, String > fieldAccessmap = new Map < String, String > ();
		SObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectName);
		Map < String, Schema.SObjectField > schemaFieldMap = sObjectType.getDescribe().fields.getMap();
		for (String fieldApiName : fieldMap.keySet()) {
			if(schemaFieldMap.get(fieldApiName) != null) {
				if(fieldMap.get(fieldApiName) == 'Read' && !schemaFieldMap.get(fieldApiName).getDescribe().isAccessible()) {
					 //fieldAccessmap.put('No Read Access for field' , fieldApiName);
					 fieldAccessmap.put(fieldApiName, 'No Read Access for field');
				} else if(fieldMap.get(fieldApiName) == 'Edit' && !schemaFieldMap.get(fieldApiName).getDescribe().isUpdateable()) {
					 //fieldAccessmap.put('No Edit Access for field' , fieldApiName);
					fieldAccessmap.put(fieldApiName, 'No Edit Access for field');
				} else {
					//fieldAccessmap.put( '', fieldApiName);
					fieldAccessmap.put(fieldApiName, '');
				}
			}		  
		}	  
		return fieldAccessmap;
	}
}