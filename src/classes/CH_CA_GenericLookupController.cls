/**********************************************************************************************************************
* Class Name :  CH_CA_GenericLookupController
* Created Date: 02-05-2019
* Created By :  TCS
* Description : This class is used by lightning component CH_CA_GenericLookupComponent which will create lookup for 
specified  object
* Test Class:   CH_CA_GenericLookupController_Test
***********************************************************************************************************************/
public class CH_CA_GenericLookupController {
	
	/* This method returns the lookup record searched for.*/
	@AuraEnabled 
	public static List<RecordsData> fetchRecords( String objectName, String filterField, String filterField1, String searchString, string extraFilter) {
		List<RecordsData> recordsDataList = new List<RecordsData>();
		System.debug('CH_CA: Generic Lookup - ObjectName ' + objectName);
		System.debug('CH_CA: Generic Lookup - FilterField' + filterField);
		System.debug('CH_CA: Generic Lookup - FilterField1' + filterField1);
		System.debug('CH_CA: Generic Lookup - SearchString' + searchString);
		System.debug('CH_CA: Generic Lookup - ExtraFilter' + extraFilter);
		try {
			String query = 'SELECT Id, ';
			if(objectName == 'Account' && !string.isBlank(filterField1)){
	query += filterField + ', ' + filterField1;
			}
			//Changes added for NOKIASC-32921
			else if(objectName == 'Product2' && !string.isBlank(filterField1)){
				query += filterField + ', ' + filterField1;
			}
			else{
	query += filterField;
			}
			//Changes added for NOKIASC-32920 and NOKIASC-32921
			if(!string.isBlank(filterField1)){
				query += ' FROM ' + objectName +
					' WHERE ('+ filterField +' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\'' +
					' OR '+ filterField1 +' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\')' +
					' ' + ((extraFilter == null) ? '' : extraFilter);
			 }
			else{
				query += ' FROM ' + objectName +
					' WHERE '+ filterField +' LIKE ' + '\'' + String.escapeSingleQuotes(searchString.trim()) + '%\'' +
					' ' + ((extraFilter == null) ? '' : extraFilter);
			  }
			system.debug('Query-->'+query);
			for(SObject s : Database.query(query)){
	RecordsData recordsData = new RecordsData();
	recordsData.value = String.valueOf(s.get('id'));
	System.debug('CH_CA: Generic Lookup - value '+ String.valueOf(s.get('id')));
	if(objectName == 'Account' && !string.isBlank(filterField1)){
		recordsData.label = String.valueOf(s.get(filterField))+' ('+String.valueOf(s.get(filterField1))+')';
	}
	//Changes added for NOKIASC-32921
	else if(objectName == 'Product2' && !string.isBlank(filterField1)){
					recordsData.label = String.valueOf(s.get(filterField))+' ('+String.valueOf(s.get(filterField1))+')';
				}else{
		recordsData.label = String.valueOf(s.get(filterField));
	}
	System.debug('CH_CA: Generic Lookup - label '+ String.valueOf(s.get(filterField)));
	recordsDataList.add(recordsData);
			} 
		} 
		catch (Exception err) {
			if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
	throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
			} 
			else {
	throw new AuraHandledException(err.getMessage());
			}
		}
		System.debug('CH_CA: Generic Lookup - recordsDataList ' + recordsDataList);
		return recordsDataList;
	}
	
	public class RecordsData{
		@AuraEnabled public String label {get;set;}
		@AuraEnabled public String value {get;set;}
	}
}